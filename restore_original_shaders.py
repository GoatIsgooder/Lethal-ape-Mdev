"""Put materials back on the game's own (recovered, now tangent-fixed) shaders.

Earlier the ape/eye materials were moved to the LetalRape Shader Graph versions because the
recovered originals rendered wrong; the real cause (tangent inputs labelled COLOR) is fixed, so
the original material files from material_backup are restored as they shipped. Four materials
that originally used Bakery/Standard but ended up on Unity's Standard get Bakery/Standard back.

  python restore_original_shaders.py          dry run
  python restore_original_shaders.py apply    back up current files, then restore
"""
import os
import re
import shutil
import sys

PROJ = r"C:\Users\Donal\Downloads\LA\LA\LA\Assets"
ORIG = r"C:\Users\Donal\Downloads\LA\material_backup\Assets"
BACKUP = r"C:\Users\Donal\Downloads\LA\material_backup\before_restore_original_shaders"
CHANGES = r"C:\Users\Donal\AppData\Local\Temp\claude\C--Users-Donal-Downloads-LA-LA-LA\2c7f721c-9659-43ad-980b-e5d086f7d0b0\scratchpad\mat_changes.tsv"
RESTORE_FROM = {"Xera/EyeShader", "Xera/EyeShaderShapes", "Bakery/Standard (Color Mask)",
                "Bakery/Standard (Color Mask Specular)", "Juelz/BakeryApeFurV2", "Bakery/ApeCubemap"}
STUB_BAKERY_STANDARD = "e0d6e6843d6d3a44b9f2acce57ca65a5"


def shader_guid(name):
    for r, _, fs in os.walk(PROJ):
        for f in fs:
            if f.endswith(".shader"):
                p = os.path.join(r, f)
                if re.search(r'Shader\s+"' + re.escape(name) + '"', open(p, encoding="utf-8", errors="ignore").read(3000)):
                    return re.search(r"guid: ([0-9a-f]{32})", open(p + ".meta", encoding="utf-8").read()).group(1)
    return None


apply = len(sys.argv) > 1 and sys.argv[1] == "apply"
bakery_std = shader_guid("Bakery/Standard")
restored = retargeted = 0
for line in open(CHANGES, encoding="utf-8"):
    rel, was, now = line.rstrip("\n").split("\t")
    cur = os.path.join(PROJ, rel)
    if was in RESTORE_FROM:
        print(f"restore  {rel}: {now} -> {was}")
        if apply:
            bk = os.path.join(BACKUP, rel)
            os.makedirs(os.path.dirname(bk), exist_ok=True)
            shutil.copy2(cur, bk)
            shutil.copy2(os.path.join(ORIG, rel), cur)
        restored += 1
    elif was == "MISSING:" + STUB_BAKERY_STANDARD and now == "builtin:46":
        print(f"retarget {rel}: Standard -> Bakery/Standard")
        if apply:
            bk = os.path.join(BACKUP, rel)
            os.makedirs(os.path.dirname(bk), exist_ok=True)
            shutil.copy2(cur, bk)
            t = open(cur, encoding="utf-8", newline="").read()
            t = re.sub(r"m_Shader: \{fileID: 46, guid: 0000000000000000f000000000000000, type: 0\}",
                       "m_Shader: {fileID: 4800000, guid: " + bakery_std + ", type: 3}", t)
            open(cur, "w", encoding="utf-8", newline="").write(t)
        retargeted += 1
print(f"{'applied' if apply else 'dry run'}: {restored} restored to original shaders, {retargeted} back on Bakery/Standard (Bakery/Standard guid {bakery_std})")
