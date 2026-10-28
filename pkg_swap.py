"""Replace AssetRipper's stub copies of third-party packages with the real package sources, keeping every
scene/prefab/asmdef reference by remapping stub GUIDs to the real ones.

  python pkg_swap.py lck|imgui             dry run: mapping + counts
  python pkg_swap.py lck|imgui apply       back up, remap, delete stubs, install real package into Packages/

Close Unity before apply.
"""
import os
import re
import shutil
import sys

PROJ = r"C:\Users\Donal\Downloads\LA\LA\LA"
SDK = r"C:\Users\Donal\Downloads\_sdk"
ASSETS = os.path.join(PROJ, "Assets")
TOOLS = os.path.dirname(os.path.abspath(__file__))

CONFIGS = {
    # LIV Creator Kit 1.4.7 + streaming 1.0.0 (from lck-v1_4_7.zip)
    "lck": [
        {"stubs": ["LIV.LCK", "LIV.LCKCore", "LIV.LCKCore.ThirdParty.MessagePack", "LIV.NativeAudioBridge", "NativeGallery"],
         "src": os.path.join(SDK, "lck_zip_1_4_7", "tv.liv.lck"), "dest": os.path.join(PROJ, "Packages", "tv.liv.lck")},
        {"stubs": ["LIV.LCK.Streaming"],
         "src": os.path.join(SDK, "lck_zip_1_4_7", "tv.liv.lck-streaming"), "dest": os.path.join(PROJ, "Packages", "tv.liv.lck-streaming")},
    ],
    # UImGui Extended (yCatDev/uimgui-extended @982031b): UImGui + its VR backend, ImGui.NET as a prebuilt DLL
    "imgui": [
        {"stubs": ["UImGui"], "drop": ["ImGui.NET"],  # ImGui.NET ships as a DLL; its stub wrappers are only deleted
         "src": os.path.join(SDK, "uimgui-extended"), "dest": os.path.join(PROJ, "Packages", "com.ycatdev.uimgui.extended"),
         # ripped copies of the package's own resources: project path -> package path (same main-object fileID)
         "assets": {
             "Resources/vr/BackgroundTint.mat": "Resources/VR/BackgroundTint.mat",
             "Resources/vr/CursorPointer.mat": "Resources/VR/CursorPointer.mat",
             "Resources/vr/MaterialBase.mat": "Resources/VR/MaterialBase.mat",
             "Resources/vr/MaterialCursor.mat": "Resources/VR/MaterialCursor.mat",
             "Resources/vr/MaterialCursor Active.mat": "Resources/VR/MaterialCursor Active.mat",
             "Resources/shaders/backgroundtint.shader": "Resources/Shaders/BackgroundTint.shader",
             "Resources/shaders/dearimgui-mesh.shader": "Resources/Shaders/DearImGui-Mesh.shader",
             "Resources/shaders/dearimgui-procedural.shader": "Resources/Shaders/DearImGui-Procedural.shader",
             "Resources/shaders/simple.shader": "Resources/Shaders/Simple.shader",
         },
         },
    ],
}
TEXT_EXT = {".unity", ".prefab", ".asset", ".mat", ".controller", ".anim", ".overrideController", ".playable",
            ".preset", ".lighting", ".signal", ".mask", ".asmdef", ".asmref"}
GUID_RE = re.compile(r"guid: ([0-9a-f]{32})")


def guid(meta):
    m = GUID_RE.search(open(meta, encoding="utf-8", errors="ignore").read())
    return m.group(1) if m else None


def files(root, ext):
    for r, dirs, fs in os.walk(root):
        dirs[:] = [d for d in dirs if d != ".git"]
        for f in fs:
            if f.endswith(ext) and os.path.isfile(os.path.join(r, f) + ".meta"):
                yield os.path.join(r, f)


name = sys.argv[1]
apply = len(sys.argv) > 2 and sys.argv[2] == "apply"
SWAPS = CONFIGS[name]
BACKUP = os.path.join(TOOLS, "material_backup", "before_" + name + "_swap")

mapping = {}
report = []
unmatched = []
for s in SWAPS:
    real = {}
    for p in files(s["src"], ".cs"):
        real.setdefault(os.path.basename(p), []).append(p)
    real_asm = {os.path.basename(p): p for p in files(s["src"], ".asmdef")}
    for stub_dir in s["stubs"]:
        root = os.path.join(ASSETS, "Scripts", stub_dir)
        hit = miss = 0
        for p in files(root, ".cs"):
            cands = real.get(os.path.basename(p), [])
            if len(cands) > 1:
                tail = os.path.relpath(p, root).replace("\\", "/").split("/")
                cands = sorted(cands, key=lambda c: -sum(a == b for a, b in zip(reversed(c.replace("\\", "/").split("/")), reversed(tail))))
            if not cands:
                # AssetRipper names files after the type; the package may keep several types per file
                want = os.path.splitext(os.path.basename(p))[0]
                cands = [c for cs in real.values() for c in cs if re.search(r"(?:class|struct|interface|enum|delegate\s+\w+)\s+" + re.escape(want) + r"\b", open(c, encoding="utf-8", errors="ignore").read())]
            if cands:
                a, b = guid(p + ".meta"), guid(cands[0] + ".meta")
                if a and b and a != b:
                    mapping[a] = b
                hit += 1
            else:
                miss += 1
                unmatched.append(os.path.relpath(p, ASSETS))
        for p in files(root, ".asmdef"):
            q = real_asm.get(os.path.basename(p))
            if q:
                a, b = guid(p + ".meta"), guid(q + ".meta")
                if a and b and a != b:
                    mapping[a] = b
            else:
                unmatched.append(os.path.relpath(p, ASSETS) + " (asmdef, no counterpart)")
        report.append(f"{stub_dir}: {hit} scripts matched, {miss} unmatched")
    for proj_rel, pkg_rel in s.get("assets", {}).items():
        a, b = guid(os.path.join(ASSETS, proj_rel) + ".meta"), guid(os.path.join(s["src"], pkg_rel) + ".meta")
        if a and b and a != b:
            mapping[a] = b
        report.append(f"asset {proj_rel} -> package {pkg_rel}: {'mapped' if a and b else 'MISSING'}")
print("\n".join(report))
for u in unmatched[:40]:
    print("  unmatched:", u)
print("guids to remap:", len(mapping))

pat = re.compile("|".join(mapping)) if mapping else None
skip_roots = [os.path.abspath(os.path.join(ASSETS, "Scripts", d)) for s in SWAPS for d in s["stubs"] + s.get("drop", [])]
skip_files = {os.path.abspath(os.path.join(ASSETS, p)) for s in SWAPS for p in s.get("assets", {})}
changed = reps = 0
for r, _, fs in os.walk(ASSETS):
    if any(os.path.abspath(r).startswith(x) for x in skip_roots):
        continue
    for f in fs:
        if os.path.splitext(f)[1] not in TEXT_EXT or pat is None:
            continue
        p = os.path.join(r, f)
        if os.path.abspath(p) in skip_files:
            continue
        try:
            txt = open(p, encoding="utf-8", newline="").read()
        except (UnicodeDecodeError, OSError):
            continue
        n = len(pat.findall(txt))
        if not n:
            continue
        changed += 1
        reps += n
        if apply:
            bk = os.path.join(BACKUP, "files", os.path.relpath(p, ASSETS))
            os.makedirs(os.path.dirname(bk), exist_ok=True)
            shutil.copy2(p, bk)
            open(p, "w", encoding="utf-8", newline="").write(pat.sub(lambda m: mapping[m.group(0)], txt))
print("assets referencing stubs:", changed, "occurrences:", reps)

if apply:
    for s in SWAPS:
        for d in s["stubs"] + s.get("drop", []):
            root = os.path.join(ASSETS, "Scripts", d)
            if os.path.isdir(root):
                shutil.copytree(root, os.path.join(BACKUP, "stubs", d), dirs_exist_ok=True)
                shutil.rmtree(root)
            if os.path.isfile(root + ".meta"):
                shutil.copy2(root + ".meta", os.path.join(BACKUP, "stubs", d + ".meta"))
                os.remove(root + ".meta")
        for proj_rel in s.get("assets", {}):
            p = os.path.join(ASSETS, proj_rel)
            for q in (p, p + ".meta"):
                if os.path.isfile(q):
                    bk = os.path.join(BACKUP, "assets", os.path.relpath(q, ASSETS))
                    os.makedirs(os.path.dirname(bk), exist_ok=True)
                    shutil.copy2(q, bk)
                    os.remove(q)
        if os.path.exists(s["dest"]):
            shutil.rmtree(s["dest"])
        shutil.copytree(s["src"], s["dest"], ignore=shutil.ignore_patterns(".git"))
        for x in s.get("extra", []):
            shutil.copy2(x, os.path.join(s["dest"], "Source", "Renderer", os.path.basename(x)))
    print("installed into Packages/; backup:", BACKUP)
