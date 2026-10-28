"""Replace AssetRipper's stub copies of third-party SDKs with the real SDK sources, keeping every
scene/prefab reference by remapping stub script GUIDs to the real scripts' GUIDs.

  python sdk_swap.py          dry run: mapping + counts
  python sdk_swap.py apply    back up, remap, delete stubs, install real SDKs

Unity must be closed for apply.
"""
import os
import re
import shutil
import sys

PROJ = r"C:\Users\Donal\Downloads\LA\LA\LA"
SDK = r"C:\Users\Donal\Downloads\_sdk"
BACKUP = r"C:\Users\Donal\Downloads\LA\material_backup\before_sdk_swap"
ASSETS = os.path.join(PROJ, "Assets")

# stub folders (Assets/Scripts/<name>) -> where the real code comes from and where it is installed
SWAPS = [
    {"stubs": ["PlayFab"], "src": os.path.join(SDK, "PlayFabSDK"), "dest": os.path.join(ASSETS, "PlayFabSDK")},
    {"stubs": ["LIV.LCK", "LIV.LCKCore", "LIV.LCKCore.ThirdParty.MessagePack", "LIV.NativeAudioBridge"],
     "src": os.path.join(SDK, "tv.liv.lck"), "dest": os.path.join(PROJ, "Packages", "tv.liv.lck")},
    {"stubs": ["LIV.LCK.Streaming"], "src": os.path.join(SDK, "tv.liv.lck-streaming"), "dest": os.path.join(PROJ, "Packages", "tv.liv.lck-streaming")},
]
TEXT_EXT = {".unity", ".prefab", ".asset", ".mat", ".controller", ".anim", ".overrideController", ".playable", ".preset", ".lighting", ".signal", ".mask"}
GUID_RE = re.compile(r"guid: ([0-9a-f]{32})")
TYPE_RE = re.compile(r"(?:class|struct|interface|enum)\s+(\w+)")


def guid(meta):
    m = GUID_RE.search(open(meta, encoding="utf-8", errors="ignore").read())
    return m.group(1) if m else None


def scripts(root):
    for r, _, fs in os.walk(root):
        for f in fs:
            if f.endswith(".cs") and os.path.isfile(os.path.join(r, f) + ".meta"):
                yield os.path.join(r, f)


mapping = {}
report = []
for s in SWAPS:
    real = {}
    for p in scripts(s["src"]):
        real.setdefault(os.path.basename(p), []).append(p)
    for stub_dir in s["stubs"]:
        root = os.path.join(ASSETS, "Scripts", stub_dir)
        hit = miss = 0
        for p in scripts(root):
            cands = real.get(os.path.basename(p), [])
            if len(cands) > 1:
                # same file name in several folders: pick the one whose path tail matches best
                tail = os.path.relpath(p, root).replace("\\", "/").split("/")
                cands = sorted(cands, key=lambda c: -sum(a == b for a, b in zip(reversed(c.replace("\\", "/").split("/")), reversed(tail))))
            if not cands:
                # AssetRipper names files after the type; the SDK may keep several types per file
                want = os.path.splitext(os.path.basename(p))[0]
                cands = [c for cs in real.values() for c in cs if re.search(r"(?:class|struct|interface|enum)\s+" + re.escape(want) + r"\b", open(c, encoding="utf-8", errors="ignore").read())]
            if cands:
                a, b = guid(p + ".meta"), guid(cands[0] + ".meta")
                if a and b and a != b:
                    mapping[a] = b
                hit += 1
            else:
                miss += 1
        report.append(f"{stub_dir}: {hit} matched, {miss} unmatched")
print("\n".join(report))
print("guids to remap:", len(mapping))

apply = len(sys.argv) > 1 and sys.argv[1] == "apply"
pat = re.compile("|".join(mapping)) if mapping else None
files = reps = 0
stub_roots = [os.path.join(ASSETS, "Scripts", d) for s in SWAPS for d in s["stubs"]]
for r, _, fs in os.walk(ASSETS):
    if any(os.path.abspath(r).startswith(os.path.abspath(x)) for x in stub_roots):
        continue
    for f in fs:
        if os.path.splitext(f)[1] not in TEXT_EXT or pat is None:
            continue
        p = os.path.join(r, f)
        try:
            txt = open(p, encoding="utf-8", newline="").read()
        except (UnicodeDecodeError, OSError):
            continue
        n = len(pat.findall(txt))
        if not n:
            continue
        files += 1
        reps += n
        if apply:
            bk = os.path.join(BACKUP, "files", os.path.relpath(p, ASSETS))
            os.makedirs(os.path.dirname(bk), exist_ok=True)
            shutil.copy2(p, bk)
            open(p, "w", encoding="utf-8", newline="").write(pat.sub(lambda m: mapping[m.group(0)], txt))
print("assets referencing stubs:", files, "occurrences:", reps)

if apply:
    for s in SWAPS:
        for d in s["stubs"]:
            root = os.path.join(ASSETS, "Scripts", d)
            if os.path.isdir(root):
                shutil.copytree(root, os.path.join(BACKUP, "stubs", d), dirs_exist_ok=True)
                shutil.rmtree(root)
            if os.path.isfile(root + ".meta"):
                os.remove(root + ".meta")
        if os.path.exists(s["dest"]):
            shutil.rmtree(s["dest"])
        shutil.copytree(s["src"], s["dest"])
        if s["dest"].startswith(ASSETS) and os.path.isfile(s["src"] + ".meta"):
            shutil.copy2(s["src"] + ".meta", s["dest"] + ".meta")
    print("installed real SDKs; backup:", BACKUP)
