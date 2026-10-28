"""Swap LA's AssetRipper RootMotion (FinalIK) stubs for the real package from
LetalRape and remap every stub script GUID to the real one.

  python rootmotion_guidfix.py          dry run (prints mapping + counts)
  python rootmotion_guidfix.py apply    back up, remap, delete stubs, copy package
"""
import collections
import os
import re
import shutil
import sys

SRC = r"C:\Users\Donal\LetalRape 2026-06-06_21-41-31\Assets\Plugins\RootMotion"
LA = r"C:\Users\Donal\Downloads\LA\LA\LA\Assets"
STUB = os.path.join(LA, "Plugins", "Assembly-CSharp-firstpass")
DEST = os.path.join(LA, "Plugins", "RootMotion")
BACKUP = r"C:\Users\Donal\Downloads\LA\material_backup\before_rootmotion_guidfix"
TEXT_EXT = {".unity", ".prefab", ".asset", ".mat", ".controller", ".anim", ".overrideController",
            ".mask", ".playable", ".meta", ".physicMaterial", ".lighting", ".signal", ".preset"}
GUID_RE = re.compile(r"guid: ([0-9a-f]{32})")


def guid(path):
    m = GUID_RE.search(open(path + ".meta", encoding="utf-8", errors="ignore").read())
    return m.group(1) if m else None


real = collections.defaultdict(list)
for r, _, fs in os.walk(SRC):
    for f in fs:
        if f.endswith(".cs"):
            real[f].append(os.path.join(r, f))

mapping = {}
for r, _, fs in os.walk(os.path.join(STUB, "RootMotion")):
    for f in fs:
        if f.endswith(".cs") and len(real.get(f, [])) == 1:
            a, b = guid(os.path.join(r, f)), guid(real[f][0])
            if a and b and a != b:
                mapping[a] = b
print("mapped scripts:", len(mapping))

apply = len(sys.argv) > 1 and sys.argv[1] == "apply"
pat = re.compile("|".join(mapping))
files = reps = 0
for r, ds, fs in os.walk(LA):
    if os.path.abspath(r).startswith(os.path.abspath(STUB)):
        continue
    for f in fs:
        if os.path.splitext(f)[1] not in TEXT_EXT:
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
            bk = os.path.join(BACKUP, "files", os.path.relpath(p, LA))
            os.makedirs(os.path.dirname(bk), exist_ok=True)
            shutil.copy2(p, bk)
            open(p, "w", encoding="utf-8", newline="").write(pat.sub(lambda m: mapping[m.group(0)], txt))
print("files with stub refs:", files, "occurrences:", reps)

if apply:
    shutil.copytree(STUB, os.path.join(BACKUP, "Assembly-CSharp-firstpass"), dirs_exist_ok=True)
    shutil.copy2(STUB + ".meta", os.path.join(BACKUP, "Assembly-CSharp-firstpass.meta"))
    shutil.rmtree(STUB)
    os.remove(STUB + ".meta")
    shutil.copytree(SRC, DEST)
    shutil.copy2(SRC + ".meta", DEST + ".meta")
    print("stubs removed, real RootMotion copied to", DEST, "| backup:", BACKUP)
