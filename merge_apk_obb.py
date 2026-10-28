"""Merge a Unity split-binary APK and its main OBB into one installable APK.

Usage:
  python merge_apk_obb.py IN.apk MAIN.obb OUT.apk --keystore KS --alias ALIAS
         [--ks-pass pass:xxx | env:VAR] [--key-pass ...] [--no-sign]

Needs ANDROID_HOME (build-tools with zipalign + apksigner) and a Java runtime
(JAVA_HOME, PATH, or a Unity install's bundled OpenJDK).

Both archives carry an assets/bin/Data/data.unity3d (UnityFS). They are
combined by chaining the LZ4 block lists and offsetting the OBB's nodes, so no
asset data is decompressed or recompressed.
"""
import argparse
import glob
import os
import shutil
import struct
import subprocess
import sys
import zipfile

import lz4.block

BUNDLE = "assets/bin/Data/data.unity3d"
CHUNK = 16 * 1024 * 1024


# ---------------------------------------------------------------- UnityFS ---

def _cstr(b, p):
    e = b.index(b"\0", p)
    return b[p:e], e + 1


def read_bundle_meta(f):
    """Parse a UnityFS header + block/directory info from a file object."""
    head = f.read(4096)
    p = 0
    sig, p = _cstr(head, p)
    if sig != b"UnityFS":
        raise ValueError("not a UnityFS bundle")
    ver, = struct.unpack_from(">I", head, p); p += 4
    player_ver, p = _cstr(head, p)
    engine_rev, p = _cstr(head, p)
    total, bi_c, bi_u, flags = struct.unpack_from(">qIII", head, p); p += 20
    if ver >= 7:
        p = (p + 15) & ~15
    if flags & 0x80:
        raise ValueError("block info at end of file not supported")
    f.seek(p)
    raw = f.read(bi_c)
    comp = flags & 0x3F
    if comp == 0:
        info = raw
    elif comp in (2, 3):
        info = lz4.block.decompress(raw, uncompressed_size=bi_u)
    else:
        raise ValueError(f"unsupported block-info compression {comp}")
    data_start = p + bi_c
    if flags & 0x200:
        data_start = (data_start + 15) & ~15

    q = 16  # skip uncompressed data hash
    nblocks, = struct.unpack_from(">i", info, q); q += 4
    blocks = []
    for _ in range(nblocks):
        blocks.append(struct.unpack_from(">IIH", info, q)); q += 10
    nnodes, = struct.unpack_from(">i", info, q); q += 4
    nodes = []
    for _ in range(nnodes):
        off, size, nflags = struct.unpack_from(">qqI", info, q); q += 20
        name, q = _cstr(info, q)
        nodes.append((off, size, nflags, name))
    return dict(ver=ver, player_ver=player_ver, engine_rev=engine_rev,
                flags=flags, blocks=blocks, nodes=nodes,
                data_start=data_start, data_len=sum(b[1] for b in blocks))


def build_merged_header(a, b):
    """Header + uncompressed block info for bundle a followed by bundle b."""
    names_a = {n[3] for n in a["nodes"]}
    dup = [n[3].decode() for n in b["nodes"] if n[3] in names_a]
    if dup:
        raise ValueError(f"bundles share node names: {dup[:5]}")
    shift = sum(blk[0] for blk in a["blocks"])
    blocks = a["blocks"] + b["blocks"]
    nodes = a["nodes"] + [(o + shift, s, fl, n) for o, s, fl, n in b["nodes"]]

    info = bytearray(16)
    info += struct.pack(">i", len(blocks))
    for u, c, fl in blocks:
        info += struct.pack(">IIH", u, c, fl)
    info += struct.pack(">i", len(nodes))
    for o, s, fl, n in nodes:
        info += struct.pack(">qqI", o, s, fl) + n + b"\0"

    flags = a["flags"] & ~0x3F  # block info stored uncompressed
    pre = (b"UnityFS\0" + struct.pack(">I", a["ver"]) + a["player_ver"] + b"\0"
           + a["engine_rev"] + b"\0")
    hdr_len = len(pre) + 20
    if a["ver"] >= 7:
        hdr_len = (hdr_len + 15) & ~15
    data_start = hdr_len + len(info)
    if flags & 0x200:
        data_start = (data_start + 15) & ~15
    total = data_start + a["data_len"] + b["data_len"]

    out = bytearray(pre + struct.pack(">qIII", total, len(info), len(info), flags))
    out += b"\0" * (hdr_len - len(out))
    out += info
    out += b"\0" * (data_start - len(out))
    return bytes(out), total


def copy_range(src, start, length, dst):
    src.seek(start)
    while length:
        buf = src.read(min(CHUNK, length))
        if not buf:
            raise IOError("unexpected end of bundle data")
        dst.write(buf)
        length -= len(buf)


# ------------------------------------------------------------------- APK ----

def is_signature_file(name):
    if not name.startswith("META-INF/") or name.count("/") != 1:
        return False
    base = name[9:].upper()
    return base == "MANIFEST.MF" or base.endswith((".SF", ".RSA", ".DSA", ".EC"))


def copy_entry(zin, info, zout):
    out = zipfile.ZipInfo(info.filename, info.date_time)
    out.compress_type = info.compress_type
    out.external_attr = info.external_attr
    with zin.open(info) as s, zout.open(out, "w") as d:
        shutil.copyfileobj(s, d, CHUNK)


def merge(apk, obb, out):
    with zipfile.ZipFile(apk) as za, zipfile.ZipFile(obb) as zo, \
            zipfile.ZipFile(out, "w", allowZip64=False) as zw:
        written = set()
        for info in za.infolist():
            if info.filename == BUNDLE or is_signature_file(info.filename):
                continue
            copy_entry(za, info, zw)
            written.add(info.filename)
        for info in zo.infolist():
            n = info.filename
            if n == BUNDLE or n == "unity_obb_guid" or n.endswith("/"):
                continue
            if n in written:
                print(f"  skip duplicate from OBB: {n}")
                continue
            copy_entry(zo, info, zw)
            written.add(n)
            print(f"  + {n} ({info.file_size:,} bytes)")

        if BUNDLE in za.namelist():
            print("  merging data.unity3d bundles")
            with za.open(BUNDLE) as fa, zo.open(BUNDLE) as fb:
                a, b = read_bundle_meta(fa), read_bundle_meta(fb)
                header, total = build_merged_header(a, b)
                zi = zipfile.ZipInfo(BUNDLE, (2020, 1, 1, 0, 0, 0))
                zi.compress_type = zipfile.ZIP_STORED
                zi.file_size = total
                with zw.open(zi, "w") as d:
                    d.write(header)
                    copy_range(fa, a["data_start"], a["data_len"], d)
                    copy_range(fb, b["data_start"], b["data_len"], d)
            print(f"  data.unity3d: {len(a['nodes'])}+{len(b['nodes'])} files, {total:,} bytes")


def verify_bundle(apk):
    with zipfile.ZipFile(apk) as z, z.open(BUNDLE) as f:
        m = read_bundle_meta(f)
        size = z.getinfo(BUNDLE).file_size
        if m["data_start"] + m["data_len"] != size:
            raise ValueError("merged bundle size mismatch")
        # spot-check: first and last block must LZ4-decompress cleanly
        for idx in (0, len(m["blocks"]) - 1):
            off = m["data_start"] + sum(blk[1] for blk in m["blocks"][:idx])
            u, c, fl = m["blocks"][idx]
            f.seek(off)
            raw = f.read(c)
            if fl & 0x3F in (2, 3):
                lz4.block.decompress(raw, uncompressed_size=u)
    print(f"  verified merged bundle ({len(m['nodes'])} files, {len(m['blocks'])} blocks)")


# ----------------------------------------------------------------- tools ----

def find_build_tool(name):
    sdk = os.environ.get("ANDROID_HOME") or os.environ.get("ANDROID_SDK_ROOT")
    if not sdk:
        sys.exit("ANDROID_HOME is not set")
    exe = name + (".bat" if name == "apksigner" and os.name == "nt" else "")
    exe += ".exe" if name == "zipalign" and os.name == "nt" else ""
    for d in sorted(glob.glob(os.path.join(sdk, "build-tools", "*")), reverse=True):
        p = os.path.join(d, exe)
        if os.path.isfile(p):
            return p
    sys.exit(f"{name} not found under {sdk}\\build-tools")


def ensure_java():
    if os.environ.get("JAVA_HOME") or shutil.which("java"):
        return
    for jdk in sorted(glob.glob(r"C:\Program Files\Unity\Hub\Editor\*\Editor\Data"
                                r"\PlaybackEngines\AndroidPlayer\OpenJDK"), reverse=True):
        if os.path.isfile(os.path.join(jdk, "bin", "java.exe")):
            os.environ["JAVA_HOME"] = jdk
            os.environ["PATH"] = os.path.join(jdk, "bin") + os.pathsep + os.environ["PATH"]
            print(f"  using Java from {jdk}")
            return
    sys.exit("No Java found; set JAVA_HOME")


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("apk")
    ap.add_argument("obb")
    ap.add_argument("out")
    ap.add_argument("--keystore")
    ap.add_argument("--alias")
    ap.add_argument("--ks-pass", help="apksigner format, e.g. pass:secret or env:VAR")
    ap.add_argument("--key-pass")
    ap.add_argument("--no-sign", action="store_true",
                    help="stop after writing the aligned, unsigned APK")
    args = ap.parse_args()
    if not args.no_sign and not (args.keystore and args.alias):
        ap.error("--keystore and --alias are required unless --no-sign")
    if args.keystore and not os.path.isfile(args.keystore):
        ap.error(f"keystore not found: {args.keystore}")

    zipalign = find_build_tool("zipalign")
    base = os.path.splitext(args.out)[0]
    unaligned, aligned = base + ".unaligned.apk", base + ".unsigned.apk"

    print("[1/4] merging")
    merge(args.apk, args.obb, unaligned)
    verify_bundle(unaligned)

    print("[2/4] zipalign")
    subprocess.check_call([zipalign, "-p", "-f", "4", unaligned, aligned])
    os.remove(unaligned)
    if args.no_sign:
        print(f"done (unsigned): {aligned}")
        return

    print("[3/4] signing")
    ensure_java()
    cmd = [find_build_tool("apksigner"), "sign", "--ks", args.keystore,
           "--ks-key-alias", args.alias, "--out", args.out]
    if args.ks_pass:
        cmd += ["--ks-pass", args.ks_pass]
    if args.key_pass:
        cmd += ["--key-pass", args.key_pass]
    subprocess.check_call(cmd + [aligned])
    os.remove(aligned)

    print("[4/4] verifying signature")
    subprocess.check_call([find_build_tool("apksigner"), "verify", "--print-certs", args.out])
    print(f"done: {args.out} ({os.path.getsize(args.out):,} bytes)")


if __name__ == "__main__":
    main()
