"""Remap AssetRipper stub-script GUIDs in Assets/Scripts/<Assembly> to the real
GUIDs from installed packages, so prefabs/scenes point at the real scripts.

  python guid_remap.py PROJECT [--source DIR ...] [--apply] [--delete-broken]

Sources default to PROJECT/Library/PackageCache and PROJECT/Assets (minus
Assets/Scripts). A stub folder is "matched" when some source has an .asmdef or
.dll with the same assembly name. Dry run unless --apply.
"""
import argparse
import os
import re
import shutil
import struct
from collections import defaultdict

GUID_RE = re.compile(rb"guid: ([0-9a-f]{32})")
KEEP = {"Assembly-CSharp", "Assembly-CSharp-firstpass", "LethalApe.SDK.Runtime"}
YAML_EXT = {".prefab", ".unity", ".asset", ".mat", ".controller", ".anim", ".overrideController",
            ".playable", ".mask", ".physicMaterial", ".physicsMaterial2D", ".lighting", ".signal",
            ".mixer", ".renderTexture", ".flare", ".guiskin", ".fontsettings", ".preset", ".meta",
            ".spriteatlas", ".terrainlayer", ".brush", ".giparams", ".cubemap"}


def read_guid(meta_path):
    with open(meta_path, "rb") as f:
        m = GUID_RE.search(f.read(512))
    return m.group(1).decode() if m else None


def asmdef_name(path):
    with open(path, encoding="utf-8-sig") as f:
        m = re.search(r'"name"\s*:\s*"([^"]+)"', f.read())
    return m.group(1) if m else os.path.splitext(os.path.basename(path))[0]


# ------------------------------------------------------------ MD4 (DLLs) ---

def _md4(msg):
    def lrot(x, n): return ((x << n) | (x >> (32 - n))) & 0xFFFFFFFF
    h = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476]
    ml = len(msg) * 8
    msg += b"\x80" + b"\0" * ((55 - len(msg)) % 64) + struct.pack("<Q", ml)
    for i in range(0, len(msg), 64):
        X = struct.unpack("<16I", msg[i:i + 64])
        a, b, c, d = h
        F = lambda x, y, z: (x & y) | (~x & z)
        G = lambda x, y, z: (x & y) | (x & z) | (y & z)
        H = lambda x, y, z: x ^ y ^ z
        for k in range(16):
            s = (3, 7, 11, 19)[k % 4]
            a, b, c, d = d, lrot((a + F(b, c, d) + X[k]) & 0xFFFFFFFF, s), b, c
        for k in range(16):
            s = (3, 5, 9, 13)[k % 4]
            idx = (k % 4) * 4 + k // 4
            a, b, c, d = d, lrot((a + G(b, c, d) + X[idx] + 0x5A827999) & 0xFFFFFFFF, s), b, c
        order = (0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15)
        for k in range(16):
            s = (3, 9, 11, 15)[k % 4]
            a, b, c, d = d, lrot((a + H(b, c, d) + X[order[k]] + 0x6ED9EBA1) & 0xFFFFFFFF, s), b, c
        h = [(x + y) & 0xFFFFFFFF for x, y in zip(h, (a, b, c, d))]
    return struct.pack("<4I", *h)


def dll_file_id(namespace, cls):
    return struct.unpack("<i", _md4(("s\0\0\0" + namespace + cls).encode())[:4])[0]


# --------------------------------------------------------------- indexing ---

def index_sources(roots, skip):
    """(assembly, filename) -> [(dir parts, guid)] for .cs; assembly -> dll guid."""
    cs = defaultdict(list)
    dlls = {}
    for root in roots:
        asm_of = {}
        for d, dirs, files in os.walk(root):
            dirs[:] = [x for x in dirs if not x.endswith("~") and not x.startswith(".")
                       and os.path.normcase(os.path.join(d, x)) not in skip]
            here = [f for f in files if f.endswith(".asmdef")]
            asm_of[d] = asmdef_name(os.path.join(d, here[0])) if here else asm_of.get(os.path.dirname(d))
            for f in files:
                if f.endswith(".cs.meta") and asm_of[d]:
                    g = read_guid(os.path.join(d, f))
                    if g:
                        cs[(asm_of[d], f)].append((os.path.normcase(d).split(os.sep), g))
                elif f.lower().endswith(".dll.meta"):
                    g = read_guid(os.path.join(d, f))
                    if g:
                        dlls.setdefault(f[:-9], g)
    return cs, dlls


def best_candidate(cands, stub_dir_parts):
    if len(cands) == 1:
        return cands[0][1]
    def score(c):
        n = 0
        for a, b in zip(reversed(c[0]), reversed(stub_dir_parts)):
            if a.lower() != b.lower():
                break
            n += 1
        return n
    ranked = sorted(cands, key=score, reverse=True)
    if score(ranked[0]) > score(ranked[1]):
        return ranked[0][1]
    return None


def stub_type(cs_path):
    with open(cs_path, encoding="utf-8", errors="replace") as f:
        src = f.read()
    ns = re.search(r"^\s*namespace\s+([\w.]+)", src, re.M)
    return (ns.group(1) if ns else ""), os.path.splitext(os.path.basename(cs_path))[0]


def build_mapping(scripts_dir, cs_index, dlls):
    plain, dllmap, report = {}, {}, {}
    for asm in sorted(os.listdir(scripts_dir)):
        folder = os.path.join(scripts_dir, asm)
        if asm in KEEP or not os.path.isdir(folder):
            continue
        has_src = any(k[0] == asm for k in cs_index)
        dll_guid = dlls.get(asm)
        if not has_src and not dll_guid:
            report[asm] = ("unmatched", 0, 0)
            continue
        mapped = missed = 0
        for d, _, files in os.walk(folder):
            for f in files:
                if not f.endswith(".cs.meta"):
                    continue
                wrong = read_guid(os.path.join(d, f))
                if not wrong:
                    continue
                right = None
                if has_src:
                    cands = cs_index.get((asm, f))
                    right = best_candidate(cands, os.path.normcase(d).split(os.sep)) if cands else None
                    if right and right != wrong:
                        plain[wrong] = right
                elif dll_guid:
                    ns, cls = stub_type(os.path.join(d, f[:-5]))
                    dllmap[wrong] = (dll_guid, dll_file_id(ns, cls))
                    right = dll_guid
                mapped += bool(right)
                missed += not right
        report[asm] = ("dll" if not has_src else "source", mapped, missed)
    return plain, dllmap, report


# ---------------------------------------------------------------- applying ---

def iter_yaml_files(assets, skip):
    for d, dirs, files in os.walk(assets):
        dirs[:] = [x for x in dirs if os.path.normcase(os.path.join(d, x)) not in skip]
        for f in files:
            if os.path.splitext(f)[1] in YAML_EXT:
                yield os.path.join(d, f)


def backup_copy(path, project, backup):
    dst = os.path.join(backup, os.path.relpath(path, project))
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    shutil.copy2(path, dst)


def apply(assets, skip, plain, dllmap, write, backup=None):
    plain_b = {k.encode(): v.encode() for k, v in plain.items()}
    dll_re = re.compile(rb"fileID: 11500000, guid: (" + b"|".join(k.encode() for k in dllmap) + rb")") \
        if dllmap else None
    files = hits = 0
    for path in iter_yaml_files(assets, skip):
        with open(path, "rb") as f:
            data = f.read()
        if not data.startswith(b"%YAML") and not path.endswith(".meta"):
            continue
        n = 0
        if dll_re:
            def sub_dll(m):
                g, fid = dllmap[m.group(1).decode()]
                return f"fileID: {fid}, guid: {g}".encode()
            data, k = dll_re.subn(sub_dll, data)
            n += k
        def sub(m):
            new = plain_b.get(m.group(1))
            return b"guid: " + new if new else m.group(0)
        n += sum(1 for m in GUID_RE.finditer(data) if m.group(1) in plain_b)
        new_data = GUID_RE.sub(sub, data)
        if n:
            files += 1
            hits += n
            if write:
                if backup:
                    backup_copy(path, os.path.dirname(assets), backup)
                with open(path, "wb") as f:
                    f.write(new_data)
    return files, hits


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("project")
    ap.add_argument("--source", action="append", default=[])
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--delete-broken", action="store_true",
                    help="with --apply: delete matched stub folders afterwards")
    ap.add_argument("--backup", help="copy changed files here and move deleted stub folders here")
    a = ap.parse_args()

    assets = os.path.join(a.project, "Assets")
    scripts = os.path.join(assets, "Scripts")
    skip_scripts = {os.path.normcase(scripts)}
    roots = [os.path.join(a.project, "Library", "PackageCache"), assets] + a.source
    roots = [r for r in roots if os.path.isdir(r)]
    print("sources:", *roots, sep="\n  ")

    cs_index, dlls = index_sources(roots, skip_scripts)
    plain, dllmap, report = build_mapping(scripts, cs_index, dlls)

    print("\nstub folder                                      kind       mapped  missed")
    for asm, (kind, m, x) in report.items():
        print(f"  {asm:46} {kind:10} {m:6}  {x:6}")
    print(f"\nGUID pairs: {len(plain)} source scripts, {len(dllmap)} DLL classes")

    matched = [asm for asm, r in report.items() if r[0] != "unmatched"]
    skip = {os.path.normcase(os.path.join(scripts, asm)) for asm in matched}
    files, hits = apply(assets, skip, plain, dllmap, a.apply, a.backup)
    print(f"{'changed' if a.apply else 'would change'}: {files} files, {hits} references")

    if a.apply and a.delete_broken:
        for asm in matched:
            for p in (os.path.join(scripts, asm), os.path.join(scripts, asm + ".meta")):
                if not os.path.exists(p):
                    continue
                if a.backup:
                    dst = os.path.join(a.backup, os.path.relpath(p, a.project))
                    os.makedirs(os.path.dirname(dst), exist_ok=True)
                    shutil.move(p, dst)
                elif os.path.isdir(p):
                    shutil.rmtree(p)
                else:
                    os.remove(p)
        print(f"removed {len(matched)} stub folders" + (f" (moved to {a.backup})" if a.backup else ""))
    unmatched = [asm for asm, r in report.items() if r[0] == "unmatched"]
    if unmatched:
        print("\nleft in place (no package/import provides them yet):\n  " + "\n  ".join(unmatched))


if __name__ == "__main__":
    main()
