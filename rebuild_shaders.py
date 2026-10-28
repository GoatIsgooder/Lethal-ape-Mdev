"""Rebuild AssetRipper dummy shaders (//DummyShaderTextExporter) into working
built-in-pipeline shaders, keeping each shader's name, Properties block and
file/GUID so existing materials keep their values and references.

  python rebuild_shaders.py SHADER_DIR BACKUP_DIR [--apply]

Categories are inferred from the shader name and its declared properties:
lit (Standard surface), additive, alpha, cutout, opaque unlit, sky.
"""
import os
import re
import shutil
import sys

COLOR_HINT = re.compile(r"(colou?r|tint|_Core|_Warm|_Cool|_Hot|_Mid|_Deep|_Eye(White|Back)|Colors)$", re.I)
COLOR_PRIORITY = ["_Color", "_Tint", "_TintColor", "_BaseColor", "_MainColor", "_FillColor", "_FaceColor",
                  "_LiquidColor", "_DropColor", "_FleshColor", "_RindColor", "_ShallowColor", "_SplatTint",
                  "_MimicTint", "_GhostColor", "_MoneyColor", "_GlassColor", "_LineColor", "_StreamingColor",
                  "_DefaultColor", "_EyeWhite", "_PupilColor", "_Colors", "_ColorA", "_Color1", "_NVColor",
                  "_HeadColor", "_IconColor", "_BezelColor", "_GlowColor", "_CoreColor", "_Core", "_Warm",
                  "_HotColor", "_EdgeColor", "_TopColor", "_HorizonColor"]
TEX_PRIORITY = ["_MainTex", "_BaseMap", "_Texture2D", "_Texture", "_EyeTex", "_Decal", "_OuterAlbedo",
                "_MimicBaseMap", "_Atlas", "_StreakTex", "_GlowMask", "_MoneyTex", "_IconTex", "_GroundTex"]
BUMP_PRIORITY = ["_BumpMap", "_NormalMap", "_OuterNormal", "_MimicNormalMap"]
MASK_TEX_RE = re.compile(r"Noise|Dirt|Crack|Dissolve|Grid|Dither", re.I)
EMIT_COLOR = ["_EmissionColor", "_GlowColor", "_EmitColor", "_InnerEmissionColor"]
EMIT_TEX = ["_EmissionMap", "_EmissionTex", "_InnerEmissionMap"]

ADD_RE = re.compile(r"Glow|Fire|Flash|Spark|Beam|Laser|Lightning|Additive|Neon|Glare|Ribbon|Comet|Orb\b|OrbShell|"
                    r"Cone|Xray|Pulse|Rift|Reticle|Lidar|ZeroPoint|Holo|GroundShock|CyberWire|Glowerboi", re.I)
ALPHA_RE = re.compile(r"Glass|Liquid|Fluid|Smoke|Fog|Vignette|Decal|Blood|Droplet|Transparent|Fade|Water|Puddle|"
                      r"Lens|Static|Crt|/TV|NightVision|UI|Menu|Portal|Social|Portrait|Fill|Card|Title|Button|"
                      r"Frame|Backdrop|Cursor|Rail|Wheel|Picker|Web|Mirror|Dither|Ghost|Particles Alpha|Particle|"
                      r"Storm|FloorLane|ScreenEdge|Crow|LIVLogo|Jumbotron|StreamingButton|SeasonPass|Wound|Gore|"
                      r"Ice|Crystal|Gland", re.I)
SKY_RE = re.compile(r"Sky|Dome", re.I)
LIT_NAME_RE = re.compile(r"Standard|/Lit |Terrain|Fur|MonsterGlow|Zombie|Banshee/Body|Pumpkin/Chunk|Golden Pig|"
                         r"Mimic|SimSurface|ParallaxLight|BtmFakeLit|ChainsawChain|Eue|EyeShader", re.I)


def parse(src):
    name = re.search(r'Shader\s+"([^"]+)"', src).group(1)
    m = re.search(r"Properties\s*\{(.*?)\n\t\}", src, re.S)
    block = m.group(1) if m else ""
    props = {}
    for pm in re.finditer(r'^(\s*(?:\[[^\]]*\]\s*)*)(\w+)\s*\(\s*("[^"]*")\s*,\s*([^)]*?\)?)\s*\)\s*=', block, re.M):
        props[pm.group(2)] = pm.group(4).split("(")[0].strip()
    return name, block, props


def fix_block(block, props):
    """Turn Vector-typed colour properties into Color so the Inspector shows a picker."""
    def repl(m):
        pname = m.group(2)
        if m.group(4).strip() == "Vector" and COLOR_HINT.search(pname):
            return f'{m.group(1)}{pname} ({m.group(3)}, Color)'
        return m.group(0)
    return re.sub(r'^(\s*(?:\[[^\]]*\]\s*)*)(\w+)\s*\(\s*("[^"]*")\s*,\s*(Vector)\s*\)', repl, block, flags=re.M)


def first(props, names, kind=None):
    for n in names:
        if n in props and (kind is None or props[n] == kind):
            return n
    return None


def any_tex(props):
    return first(props, TEX_PRIORITY, "2D") or next((n for n, t in props.items() if t == "2D"), None)


def classify(name, props):
    if name == "Slop/Monster Index/Display":
        return "display"
    if re.search(r"Cutout", name):
        return "cutout_lit" if "/Lit" in name else "cutout"
    if all(p in props for p in ("_Stencil", "_StencilComp", "_StencilOp")):
        return "alpha"
    if SKY_RE.search(name) and "Simsurface" not in name:
        return "sky"
    if re.search(r"Unlit|/Hidden/|^Hidden/|Particles", name) and not LIT_NAME_RE.search(name):
        if "Additive" in name:
            return "add"
        if "Transparent" in name or "Alpha" in name:
            return "alpha"
        return "unlit"
    if ADD_RE.search(name) and not LIT_NAME_RE.search(name):
        return "add"
    if ALPHA_RE.search(name):
        return "alpha"
    if LIT_NAME_RE.search(name) or first(props, BUMP_PRIORITY) or "_MetallicGlossMap" in props:
        return "lit"
    return "unlit"


def decl(props, names):
    out = []
    for n in names:
        if not n:
            continue
        t = props.get(n)
        if t in ("2D", "2DArray"):
            out.append(f"sampler2D {n};" if t == "2D" else f"UNITY_DECLARE_TEX2DARRAY({n});")
        elif t == "Cube":
            out.append(f"samplerCUBE {n};")
        elif t in ("Vector", "Color"):
            out.append(f"fixed4 {n};")
        elif t:
            out.append(f"half {n};")
    return "\n\t\t".join(dict.fromkeys(out))


def lit_shader(name, props, cutout=False):
    col = first(props, COLOR_PRIORITY)
    tex = any_tex(props)
    bump = first(props, BUMP_PRIORITY, "2D")
    mask = "_ColorMask" if props.get("_ColorMask") == "2D" else None
    ecol = first(props, EMIT_COLOR)
    etex = first(props, EMIT_TEX, "2D")
    gloss = "_Glossiness" if "_Glossiness" in props else None
    metal = "_Metallic" if "_Metallic" in props else None
    uvsrc = tex or bump or etex
    # surface-shader Input names drop one leading underscore: _MainTex -> uv_MainTex
    uvname = ("uv" + uvsrc if uvsrc.startswith("_") else "uv_" + uvsrc) if uvsrc else None
    lines = [decl(props, [col, tex, bump, mask, ecol, etex, gloss, metal,
                          "_BumpScale" if "_BumpScale" in props else None,
                          "_Cutoff" if "_Cutoff" in props else None])]
    body = []
    body.append(f"fixed4 c = {'tex2D(' + tex + ', IN.uv_' + uvsrc + ')' if tex else 'fixed4(1,1,1,1)'};")
    if col:
        if mask:
            body.append(f"fixed m = tex2D({mask}, IN.uv_{uvsrc}).r;")
            body.append(f"c.rgb = lerp(c.rgb, c.rgb * {col}.rgb, m);")
        else:
            body.append(f"c *= {col};")
    body.append("o.Albedo = c.rgb;")
    body.append("o.Alpha = c.a;")
    if bump:
        scale = "_BumpScale" if "_BumpScale" in props else "1"
        body.append(f"o.Normal = UnpackScaleNormal(tex2D({bump}, IN.uv_{uvsrc}), {scale});")
    body.append(f"o.Smoothness = {gloss or '0.25'};")
    body.append(f"o.Metallic = {metal or '0'};")
    if ecol or etex:
        e = []
        if etex:
            e.append(f"tex2D({etex}, IN.uv_{uvsrc}).rgb")
        if ecol:
            e.append(f"{ecol}.rgb")
        body.append(f"o.Emission = {' * '.join(e)};")
    if cutout:
        body.append(f"clip(c.a - {'_Cutoff' if '_Cutoff' in props else '0.5'});")
    body = [b.replace(f"IN.uv_{uvsrc}", f"IN.{uvname}") for b in body]
    inp = f"float2 {uvname};" if uvsrc else "float3 worldPos;"
    blend = ""
    if "_SrcBlend" in props and "_DstBlend" in props:
        blend = "Blend [_SrcBlend] [_DstBlend]\n\t\t" + ("ZWrite [_ZWrite]\n\t\t" if "_ZWrite" in props else "")
    cull = "Cull [_BAKERY_2SIDED]\n\t\t" if "_BAKERY_2SIDED" in props else ""
    return f"""	SubShader {{
		Tags {{ "RenderType"="{'TransparentCutout' if cutout else 'Opaque'}" "Queue"="{'AlphaTest' if cutout else 'Geometry'}" }}
		LOD 200
		{blend}{cull}CGPROGRAM
		#pragma surface surf Standard fullforwardshadows addshadow
		#pragma target 3.0
		{lines[0]}
		struct Input {{ {inp} }};
		void surf (Input IN, inout SurfaceOutputStandard o)
		{{
			{chr(10).join(chr(9) * 3 + b for b in body).lstrip()}
		}}
		ENDCG
	}}
	FallBack "Diffuse"
"""


def unlit_shader(name, props, mode):
    col = first(props, COLOR_PRIORITY)
    tex = any_tex(props)
    tex_is_array = props.get(tex) == "2DArray" if tex else False
    if tex_is_array:
        tex = None
    ecol = first(props, ["_EmissionColor"]) if mode == "display" else None
    etex = first(props, ["_EmissionMap"], "2D") if mode == "display" else None
    ui = all(p in props for p in ("_Stencil", "_StencilComp", "_StencilOp"))
    queue, rtype, state = {
        "add": ("Transparent", "Transparent", "Blend One One\n\t\tZWrite Off\n\t\tCull Off"),
        "alpha": ("Transparent", "Transparent", "Blend SrcAlpha OneMinusSrcAlpha\n\t\tZWrite Off\n\t\tCull Off"),
        "cutout": ("AlphaTest", "TransparentCutout", ""),
        "display": ("Geometry", "Opaque", ""),
        "unlit": ("Geometry", "Opaque", ""),
    }[mode]
    if "_SrcBlend" in props and "_DstBlend" in props:
        state = "Blend [_SrcBlend] [_DstBlend]\n\t\t" + ("ZWrite [_ZWrite]" if "_ZWrite" in props else
                                                         ("ZWrite Off" if mode in ("add", "alpha") else ""))
        if "_Cull" in props:
            state += "\n\t\tCull [_Cull]"
    elif "_Cull" in props:
        state += "\n\t\tCull [_Cull]"
    stencil = ""
    if ui:
        stencil = """Stencil {
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}
		ZTest [unity_GUIZTestMode]
		""" + ("ColorMask [_ColorMask]\n\t\t" if props.get("_ColorMask") == "Float" else "")
    use_vcol = mode in ("add", "alpha") or ui
    # noise/dirt/crack-style textures shape transparency; they are not the surface colour
    mask_tex = bool(tex and MASK_TEX_RE.search(tex) and mode in ("add", "alpha"))
    if mask_tex:
        frag = [f"fixed4 c = {col or 'fixed4(1,1,1,1)'};", f"c.a *= tex2D({tex}, i.uv).r;"]
    else:
        frag = [f"fixed4 c = {'tex2D(' + tex + ', i.uv)' if tex else 'fixed4(1,1,1,1)'};"]
    if col and not mask_tex:
        frag.append(f"c *= {col};")
    if use_vcol:
        frag.append("c *= i.color;")
    if etex or ecol:
        e = " * ".join(x for x in [f"tex2D({etex}, i.uv).rgb" if etex else None, f"{ecol}.rgb" if ecol else None] if x)
        frag.append(f"c.rgb += {e}{' * _Emission' if '_Emission' in props else ''};")
    if mode == "cutout":
        frag.append(f"clip(c.a - {'_Cutoff' if '_Cutoff' in props else '0.5'});")
    if mode == "display" and "_Cutout" in props:
        frag.append("clip(c.a - _Cutout);")
    if mode == "add":
        frag.append("c.rgb *= c.a;")
        frag.append("UNITY_APPLY_FOG_COLOR(i.fogCoord, c, fixed4(0,0,0,0));")
    else:
        frag.append("UNITY_APPLY_FOG(i.fogCoord, c);")
    st = f"float4 {tex}_ST;" if tex else ""
    uvx = f"TRANSFORM_TEX(v.uv, {tex})" if tex else "v.uv"
    return f"""	SubShader {{
		Tags {{ "Queue"="{queue}" "RenderType"="{rtype}" "IgnoreProjector"="True" "PreviewType"="Plane" }}
		{stencil}{state}
		Pass {{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			{decl(props, [col, tex, ecol, etex, '_Cutoff' if '_Cutoff' in props else None, '_Cutout' if mode == 'display' and '_Cutout' in props else None, '_Emission' if mode == 'display' and '_Emission' in props else None])}
			{st}
			struct appdata {{ float4 vertex : POSITION; float2 uv : TEXCOORD0; fixed4 color : COLOR; }};
			struct v2f {{ float4 pos : SV_POSITION; float2 uv : TEXCOORD0; fixed4 color : COLOR; UNITY_FOG_COORDS(1) }};
			v2f vert (appdata v)
			{{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = {uvx};
				o.color = v.color;
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
			}}
			fixed4 frag (v2f i) : SV_Target
			{{
				{chr(10).join(chr(9) * 4 + f for f in frag).lstrip()}
				return c;
			}}
			ENDCG
		}}
	}}
"""


def sky_shader(name, props):
    cube = next((n for n, t in props.items() if t == "Cube"), None)
    top = first(props, ["_ZenithColor", "_TopColor", "_SkyTint", "_Tint"])
    hor = first(props, ["_HorizonColor", "_HorizonGlowColor"])
    bot = first(props, ["_BottomColor", "_GroundTint", "_HorizonColor"])
    tint = first(props, ["_SkyTint", "_Tint"])
    if cube:
        col = f"texCUBE({cube}, d)" + (f" * {tint}" if tint else "")
    else:
        t = top or "fixed4(0.3,0.4,0.6,1)"
        h = hor or t
        b = bot or h
        col = f"(d.y >= 0 ? lerp({h}, {t}, saturate(d.y)) : lerp({h}, {b}, saturate(-d.y * 4)))"
    return f"""	SubShader {{
		Tags {{ "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }}
		Cull Off
		ZWrite Off
		Pass {{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			{decl(props, [cube, top, hor, bot, tint])}
			struct v2f {{ float4 pos : SV_POSITION; float3 dir : TEXCOORD0; }};
			v2f vert (float4 vertex : POSITION)
			{{
				v2f o;
				o.pos = UnityObjectToClipPos(vertex);
				o.dir = mul(unity_ObjectToWorld, vertex).xyz - _WorldSpaceCameraPos;
				return o;
			}}
			fixed4 frag (v2f i) : SV_Target
			{{
				float3 d = normalize(i.dir);
				return {col};
			}}
			ENDCG
		}}
	}}
"""


def rebuild(src):
    name, block, props = parse(src)
    kind = classify(name, props)
    if kind == "lit":
        sub = lit_shader(name, props)
    elif kind == "cutout_lit":
        sub = lit_shader(name, props, cutout=True)
    elif kind == "sky":
        sub = sky_shader(name, props)
    else:
        sub = unlit_shader(name, props, kind)
    header = f"// Rebuilt from AssetRipper placeholder by rebuild_shaders.py ({kind}); original effect code was not recoverable.\n"
    return kind, header + f'Shader "{name}" {{\n\tProperties {{{fix_block(block, props)}\n\t}}\n{sub}}}\n'


def main():
    # SHADER_DIR may also be a single .shader file
    shader_dir, backup_dir = sys.argv[1], sys.argv[2]
    apply = "--apply" in sys.argv
    counts = {}
    if os.path.isfile(shader_dir):
        shader_dir, only = os.path.split(shader_dir)
        files = [only]
    else:
        files = sorted(os.listdir(shader_dir))
    for f in files:
        if not f.endswith(".shader"):
            continue
        p = os.path.join(shader_dir, f)
        # re-runs regenerate from the backed-up AssetRipper original
        orig = os.path.join(backup_dir, f)
        src = open(orig if os.path.exists(orig) else p, encoding="utf-8", errors="replace").read()
        if "DummyShaderTextExporter" not in src:
            continue
        name = parse(src)[0]
        kind, out = rebuild(src)
        counts[kind] = counts.get(kind, 0) + 1
        print(f"{kind:10} {name}")
        if apply:
            os.makedirs(backup_dir, exist_ok=True)
            dst = os.path.join(backup_dir, f)
            if not os.path.exists(dst):
                shutil.copy2(p, dst)
            open(p, "w", encoding="utf-8", newline="\n").write(out)
    print(counts)


if __name__ == "__main__":
    main()
