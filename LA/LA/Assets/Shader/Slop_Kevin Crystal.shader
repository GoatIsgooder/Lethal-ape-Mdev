// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Kevin Crystal" {
Properties {

[Header(Surface)] _MainTex ("Albedo", 2D) = "white" { }

_BumpMap ("Normal Map", 2D) = "bump" { }

_BumpScale ("Normal Strength", Range(0, 2)) = 1.0

_EmissionMap ("Emission (rock spill + crystal light mask)", 2D) = "black" { }

_RockEmission ("Rock Spill Strength", Range(0, 8)) = 4.0

[Header(Crystal Shell)] _TopColor ("Top Colour", Color) = (0.3,0.2,0.95,1)

_BottomColor ("Bottom Colour", Color) = (0.8,0.18,0.95,1)

_HeightRange ("Gradient Height (object Y min, max)", Vector) = (0,6.1,0,0)

_ShellBrightness ("Shell Brightness", Range(0, 4)) = 1.9759999513626099

_BlockSize ("Block Size (m)", Float) = 0.6000000238418579

_BlockVariation ("Block Tone Variation", Range(0, 0.5)) = 0.1599999964237213

_Gloss ("Glint Tightness", Range(8, 256)) = 110.0

_GlintStrength ("Glint Strength", Range(0, 2)) = 0.5

_RimColor ("Rim Colour", Color) = (0.9,0.35,1.6,1)

_RimPower ("Rim Power", Range(0.5, 8)) = 2.509999990463257

[Header(Inner Light)] _GlowColor ("Inner Light Colour", Color) = (1,1,1,1)

_GlowStrength ("Inner Light Strength", Range(0, 4)) = 0.3100000023841858

_InnerFill ("Inner Fill (base light everywhere)", Range(0, 1)) = 0.30000001192092896

_FacingPower ("Look-Through Falloff", Range(0.25, 4)) = 1.399999976158142

_Refraction ("Refraction Bend", Range(0, 1)) = 0.9369999766349792

_PulseSpeed ("Pulse Speed", Float) = 1.600000023841858

_PulseAmount ("Pulse Amount", Range(0, 1)) = 0.4729999899864197

_CoreColor ("Core Colour", Color) = (1.4,0.45,2.2,1)

_CoreDepth ("Core Depth (m)", Float) = 0.699999988079071

_CoreScale ("Core Scale", Float) = 0.30000001192092896

_CoreSpeed ("Core Swirl Speed", Float) = 0.03999999910593033

_CoreStrength ("Core Strength", Range(0, 3)) = 1.2000000476837158

[Header(Runes)] _RuneTex ("Rune Atlas (R glyphs 4x4, G vein noise, B core noise)", 2D) = "black" { }

_RuneColor ("Rune Colour", Color) = (2.2,0.7,3,1)

_RuneDepth ("Rune Depth (m)", Float) = 0.07999999821186066

_RuneCell ("Rune Cell Size (m)", Float) = 0.3400000035762787

_RuneDensity ("Rune Density", Range(0, 1)) = 0.7509999871253967

_RuneSpeed ("Rune Drift Speed (m/s)", Float) = 0.05999999865889549

_RuneBlink ("Rune Blink Rate", Float) = 0.2199999988079071

[Header(Energy Veins)] _VeinColor ("Vein Colour", Color) = (1.6,0.5,2.4,1)

_VeinDepth ("Vein Depth (m)", Float) = 0.30000001192092896

_VeinScale ("Vein Scale", Float) = 0.2199999988079071

_VeinSpeed ("Vein Speed", Float) = 0.11999999731779099

_VeinSharpness ("Vein Sharpness", Range(1, 16)) = 6.0

_VeinStrength ("Vein Strength", Range(0, 2)) = 0.699999988079071

[Header(Hand Touch)] _TouchColor ("Touch Colour", Color) = (1.8,0.7,2.4,1)

_HandRadius ("Hand Glow Radius (m)", Float) = 0.03999999910593033

_HandStrength ("Hand Glow Strength", Range(0, 2)) = 0.09700000286102295

_RippleSpeed ("Ripple Speed (m/s)", Float) = 2.4000000953674316

_RippleWidth ("Ripple Width (m)", Float) = 0.03999999910593033

_RippleLife ("Ripple Life (s)", Float) = 0.30000001192092896

[Header(Rock Cracks On Touch)] _CrackColor ("Crack Glow Colour", Color) = (2.6,0.6,3.2,1)

_CrackScale ("Crack Pattern Size (m, object)", Float) = 2.0

_CrackSpeed ("Crack Spread Speed (m/s)", Float) = 1.399999976158142

_CrackReach ("Crack Reach (m)", Float) = 1.600000023841858

_CrackLife ("Crack Life (s)", Float) = 2.4000000953674316

_CrackOpen ("Crack Opening (branches at full charge)", Range(0.05, 0.9)) = 0.699999988079071

_CrackGlow ("Crack Glow Strength", Range(0, 4)) = 1.600000023841858

_CrackDarken ("Fissure Darkness", Range(0, 1)) = 0.800000011920929

[Header(Kevin Rift)] _RiftAwake ("Rift Awake", Range(0, 1)) = 0.0

_RiftCrack ("Rift Crack", Range(0, 1)) = 0.0

_RiftFlash ("Rift Flash", Float) = 0.0

}
SubShader {
 LOD 200
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
 Name "FORWARD"
  LOD 200
  Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile __ LIGHTMAP_ON
#if defined(FOG_EXP) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m11[4];
float4 unity_FogParams;
float4 unity_LightmapST;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m10 unity_WorldTransformParams
#define _21_m12 unity_FogParams
#define _21_m13 unity_LightmapST
#define _21_m14 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD8;
static float4 vs_TEXCOORD0;
static float2 _141;
static float2 _154;
static float4 vs_TEXCOORD2;
static float4 _172;
static float4 _178;
static float3 _223;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD7;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _223 : NORMAL;
    float4 _178 : TANGENT;
    float2 _141 : TEXCOORD0;
    float2 _154 : TEXCOORD1;
    float4 _172 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
    float3 vs_TEXCOORD7 : TEXCOORD8;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float3 _187;
static float _243;
static float3 _256;
static float3 _269;
static float3 _275;
static float4 _321;
static float3 _327;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m11[1];
    _9 = (_21_m11[0] * _45.xxxx) + _9;
    _9 = (_21_m11[2] * _45.zzzz) + _9;
    _9 = (_21_m11[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m12.y;
    vs_TEXCOORD8 = exp2(-_9.x);
    float2 _151 = (_141 * _21_m14.xy) + _21_m14.zw;
    vs_TEXCOORD0 = float4(_151.x, _151.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _164 = (_154 * _21_m13.xy) + _21_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _164.x, _164.y);
    vs_TEXCOORD2 = float4(_11.xyz.x, _11.xyz.y, _11.xyz.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _172.x;
    _9.x = _178.w * _21_m10.w;
    _187 = _178.yyy * _21_m8[1].yzx;
    _187 = (_21_m8[0].yzx * _178.xxx) + _187;
    _187 = (_21_m8[2].yzx * _178.zzz) + _187;
    _45.x = dot(_187, _187);
    _45.x = rsqrt(_45.x);
    _187 *= _45.xxx;
    _45.x = dot(_223, _21_m9[0].xyz);
    _45.y = dot(_223, _21_m9[1].xyz);
    _45.z = dot(_223, _21_m9[2].xyz);
    _243 = dot(_45.xyz, _45.xyz);
    _243 = rsqrt(_243);
    _45 = _243.xxxx * _45.xyzz;
    _256 = _187 * _45.zxy;
    _256 = (_45.yzx * _187.yzx) + (-_256);
    _269 = _9.xxx * _256.xzy;
    _275.y = _269.x;
    _275.x = _187.z;
    _275.z = _45.x;
    vs_TEXCOORD3 = _275;
    _269.x = _187.y;
    _187.y = _269.z;
    _187.z = _45.y;
    vs_TEXCOORD4 = _187;
    _269.z = _45.z;
    vs_TEXCOORD5 = _269;
    vs_TEXCOORD6 = _223;
    _256.x = _45.y * _45.y;
    _256.x = (_45.x * _45.x) + (-_256.x);
    _321 = _45.yzwx * _45.xywz;
    _327.x = dot(_21_m4, _321);
    _327.y = dot(_21_m5, _321);
    _327.z = dot(_21_m6, _321);
    _256 = (_21_m7.xyz * _256.xxx) + _327;
    _45.w = 1.0f;
    _327.x = dot(_21_m1, _45);
    _327.y = dot(_21_m2, _45);
    _327.z = dot(_21_m3, _45);
    vs_TEXCOORD7 = _256 + _327;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _154 = stage_input._154;
    _172 = stage_input._172;
    _178 = stage_input._178;
    _223 = stage_input._223;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD8 = vs_TEXCOORD8;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _46_m3[4];
float4 unity_FogColor;
float4 unity_Lightmap_HDR;
float _BumpScale;
float _RockEmission;
float4 _TopColor;
float4 _BottomColor;
float4 _HeightRange;
float _ShellBrightness;
float _BlockSize;
float _BlockVariation;
float _Gloss;
float _GlintStrength;
float4 _RimColor;
float _RimPower;
float4 _GlowColor;
float _GlowStrength;
float _InnerFill;
float _FacingPower;
float _Refraction;
float _PulseSpeed;
float _PulseAmount;
float4 _CoreColor;
float _CoreDepth;
float _CoreScale;
float _CoreSpeed;
float _CoreStrength;
float4 _RuneColor;
float _RuneDepth;
float _RuneCell;
float _RuneSpeed;
float _RuneDensity;
float _RuneBlink;
float4 _VeinColor;
float _VeinDepth;
float _VeinScale;
float _VeinSpeed;
float _VeinSharpness;
float _VeinStrength;
float4 _TouchColor;
float _HandRadius;
float _RippleSpeed;
float _RippleWidth;
float _RippleLife;
float _HandStrength;
float4 _CrackColor;
float _CrackScale;
float _CrackSpeed;
float _CrackReach;
float _CrackLife;
float _CrackOpen;
float _CrackGlow;
float _CrackDarken;
float _KevinActive;
float4 _KevinHands[2];
float4 _KevinRipples[4];
float _RiftAwake;
float _RiftCrack;
float _RiftFlash;
float4 _LightColor0;
void __unity_init()
{
    _46_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _46_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _46_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _46_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _46_m0 _Time
#define _46_m1 _WorldSpaceCameraPos
#define _46_m2 _WorldSpaceLightPos0
#define _46_m4 unity_FogColor
#define _46_m5 unity_Lightmap_HDR
#define _46_m6 _BumpScale
#define _46_m7 _RockEmission
#define _46_m8 _TopColor
#define _46_m9 _BottomColor
#define _46_m10 _HeightRange
#define _46_m11 _ShellBrightness
#define _46_m12 _BlockSize
#define _46_m13 _BlockVariation
#define _46_m14 _Gloss
#define _46_m15 _GlintStrength
#define _46_m16 _RimColor
#define _46_m17 _RimPower
#define _46_m18 _GlowColor
#define _46_m19 _GlowStrength
#define _46_m20 _InnerFill
#define _46_m21 _FacingPower
#define _46_m22 _Refraction
#define _46_m23 _PulseSpeed
#define _46_m24 _PulseAmount
#define _46_m25 _CoreColor
#define _46_m26 _CoreDepth
#define _46_m27 _CoreScale
#define _46_m28 _CoreSpeed
#define _46_m29 _CoreStrength
#define _46_m30 _RuneColor
#define _46_m31 _RuneDepth
#define _46_m32 _RuneCell
#define _46_m33 _RuneSpeed
#define _46_m34 _RuneDensity
#define _46_m35 _RuneBlink
#define _46_m36 _VeinColor
#define _46_m37 _VeinDepth
#define _46_m38 _VeinScale
#define _46_m39 _VeinSpeed
#define _46_m40 _VeinSharpness
#define _46_m41 _VeinStrength
#define _46_m42 _TouchColor
#define _46_m43 _HandRadius
#define _46_m44 _RippleSpeed
#define _46_m45 _RippleWidth
#define _46_m46 _RippleLife
#define _46_m47 _HandStrength
#define _46_m48 _CrackColor
#define _46_m49 _CrackScale
#define _46_m50 _CrackSpeed
#define _46_m51 _CrackReach
#define _46_m52 _CrackLife
#define _46_m53 _CrackOpen
#define _46_m54 _CrackGlow
#define _46_m55 _CrackDarken
#define _46_m56 _KevinActive
#define _46_m57 _KevinHands
#define _46_m58 _KevinRipples
#define _46_m59 _RiftAwake
#define _46_m60 _RiftCrack
#define _46_m61 _RiftFlash
#define _46_m62 _LightColor0


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> unity_Lightmap;
SamplerState samplerunity_Lightmap;
Texture2D<float4> _RuneTex;
SamplerState sampler_RuneTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;

static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD8;
static float4 _3182;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
};

struct SPIRV_Cross_Output
{
    float4 _3182 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _30;
static float _55;
static float3 _70;
static bool _82;
static bool2 _90;
static bool _108;
static float _134;
static float4 _151;
static bool _166;
static float3 _172;
static float2 _199;
static float3 _210;
static float _241;
static bool2 _368;
static bool _391;
static float3 _404;
static float2 _416;
static float _444;
static float _954;
static float _956;
static bool _973;
static float _980;
static int3 _991;
static int _1002;
static bool _1006;
static float3 _1080;
static float4 _1093;
static float2 _1130;
static float3 _1144;
static float3 _1258;
static float _1346;
static float4 _1354;
static float3 _1390;
static float3 _1451;
static float3 _1528;
static float3 _1536;
static int _1562;
static int _1570;
static bool _1573;
static int3 _1597;
static float3 _1616;
static float3 _1623;
static float2 _1680;
static int _1770;
static float _1802;
static bool _1864;
static bool _1870;
static bool2 _1937;
static float2 _1945;
static bool _1960;
static float _1965;
static float2 _2397;
static float _2448;
static float _2491;
static float _2509;
static float _2673;
static float3 _2708;
static float _2966;
static float3 _3128;

void frag_inner()
{
    __unity_init();
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
    _30 = unity_Lightmap.Sample(samplerunity_Lightmap, vs_TEXCOORD0.zw).xyz;
    _30 *= _46_m5.xxx;
    _55 = (-vs_TEXCOORD2.w) + 1.0f;
    _55 *= _46_m7;
    _70 = _23 * _55.xxx;
    _70 = (_9 * _30) + _70;
    _82 = 0.5f < _46_m56;
    float4 _104 = float4(_46_m60, _46_m61, _46_m60, _46_m60);
    _90 = bool4(float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).x < _104.x, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).y < _104.y, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).z < _104.z, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).w < _104.w).xy;
    _108 = _82 || _90.x;
    _108 = _90.y || _108;
    _90.x = vs_TEXCOORD2.w < 0.9900000095367431640625f;
    _108 = _108 && _90.x;
    if (_108)
    {
        if (_82)
        {
            _134 = _46_m0.y + (-_46_m58[0].w);
            _90.x = _46_m58[0].w >= 0.001000000047497451305389404296875f;
            _90.y = _134 >= 0.0f;
            _151.x = float(_90.x);
            _151.y = float(_90.y);
            _151.x = _151.y * _151.x;
            _166 = _46_m52 >= _134;
            _172.x = float(_166);
            _151.x = _172.x * _151.x;
            _172 = vs_TEXCOORD1 + (-_46_m58[0].xyz);
            _172.x = dot(_172, _172);
            _172.x = sqrt(_172.x);
            _199.x = (_134 * _46_m50) + (-_172.x);
            float2 _220 = float2(_46_m52, _46_m51) * float2(0.550000011920928955078125f, 0.449999988079071044921875f);
            _210 = float3(_220.x, _220.y, _210.z);
            _134 = ((-_46_m52) * 0.449999988079071044921875f) + _134;
            float2 _232 = 1.0f.xx / _210.xy;
            _210 = float3(_232.x, _232.y, _210.z);
            _134 *= _210.x;
            _134 = clamp(_134, 0.0f, 1.0f);
            _241 = (_134 * (-2.0f)) + 3.0f;
            _134 *= _134;
            _134 = ((-_241) * _134) + 1.0f;
            _172.x = ((-_46_m51) * 0.550000011920928955078125f) + _172.x;
            _172.x = _210.y * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _241 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_241) * _172.x) + 1.0f;
            _134 *= _172.x;
            _134 = _151.x * _134;
            _151.x = _199.x + 0.20000000298023223876953125f;
            _151.x *= 2.8571426868438720703125f;
            _151.x = clamp(_151.x, 0.0f, 1.0f);
            _172.x = (_151.x * (-2.0f)) + 3.0f;
            _151.x *= _151.x;
            _151.x *= _172.x;
            _151.x = _134 * _151.x;
            _151.x = max(_151.x, 0.0f);
            _172.x = _199.x * (-_199.x);
            _172.x *= 40.0f;
            _172.x = exp2(_172.x);
            _134 *= _172.x;
            _134 = max(_134, 0.0f);
            _172.x = _46_m0.y + (-_46_m58[1].w);
            _368.x = _46_m58[1].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m52 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m58[1].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m50) + (-_241);
            _172.x = ((-_46_m52) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _444 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_444) * _172.x) + 1.0f;
            _241 = ((-_46_m51) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _444 = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_444) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _199.x = _416.x * (-_416.x);
            _199.x *= 40.0f;
            _199.x = exp2(_199.x);
            _172.x *= _199.x;
            _134 = max(_134, _172.x);
            _172.x = _46_m0.y + (-_46_m58[2].w);
            _368.x = _46_m58[2].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m52 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m58[2].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m50) + (-_241);
            _172.x = ((-_46_m52) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _444 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_444) * _172.x) + 1.0f;
            _241 = ((-_46_m51) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _444 = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_444) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _199.x = _416.x * (-_416.x);
            _199.x *= 40.0f;
            _199.x = exp2(_199.x);
            _172.x *= _199.x;
            _134 = max(_134, _172.x);
            _172.x = _46_m0.y + (-_46_m58[3].w);
            _368.x = _46_m58[3].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m52 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m58[3].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m50) + (-_241);
            _172.x = ((-_46_m52) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _210.x = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_210.x) * _172.x) + 1.0f;
            _241 = ((-_46_m51) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _210.x = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_210.x) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _210.x = _416.x * (-_416.x);
            _210.x *= 40.0f;
            _210.x = exp2(_210.x);
            _210.x = _172.x * _210.x;
            _134 = max(_134, _210.x);
            _954 = _134;
            _956 = _151.x;
        }
        else
        {
            _954 = 0.0f;
            _956 = 0.0f;
        }
        _55 = min(_46_m61, 1.0f);
        _55 *= 0.300000011920928955078125f;
        _55 = max(_55, _46_m60);
        _55 = max(_55, _956);
        _973 = 0.00200000009499490261077880859375f < _55;
        if (_973)
        {
            _980 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
            _991.x = int((_980 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
            _1002 = ~_991.x;
            _1006 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
            _1002 = _1006 ? _1002 : 0;
            bool2 _1025 = (_1002 != 0).xx;
            _416 = float2(_1025.x ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).x : float2(0.709999978542327880859375f, 0.189999997615814208984375f).x, _1025.y ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).y : float2(0.709999978542327880859375f, 0.189999997615814208984375f).y);
            float2 _1031;
            if (_991.x != 0)
            {
                _1031 = 0.0f.xx;
            }
            else
            {
                _1031 = _416;
            }
            _416 = _1031;
            float2 _1040;
            if (_1002 != 0)
            {
                _1040 = vs_TEXCOORD2.xy;
            }
            else
            {
                _1040 = vs_TEXCOORD2.xz;
            }
            _404 = float3(_1040.x, _1040.y, _404.z);
            float2 _1054;
            if (_991.x != 0)
            {
                _1054 = vs_TEXCOORD2.zy;
            }
            else
            {
                _1054 = _404.xy;
            }
            _210 = float3(_1054.x, _1054.y, _210.z);
            float2 _1071 = _210.xy / _46_m49.xx;
            _210 = float3(_1071.x, _1071.y, _210.z);
            float2 _1077 = _416 + _210.xy;
            _210 = float3(_1077.x, _1077.y, _210.z);
            _1080.x = _RuneTex.Sample(sampler_RuneTex, _210.xy).w;
            _980 = _55 * _46_m54;
            float2 _1104 = ((-_46_m53.xx) * _55.xx) + float2(1.0f, 0.7799999713897705078125f);
            _1093 = float4(_1104.x, _1104.y, _1093.z, _1093.w);
            float2 _1112 = _1080.xx + (-_1093.xy);
            _1093 = float4(_1112.x, _1112.y, _1093.z, _1093.w);
            float2 _1120 = _1093.xy * float2(12.5f, 4.5454540252685546875f);
            _1093 = float4(_1120.x, _1120.y, _1093.z, _1093.w);
            float2 _1127 = clamp(_1093.xy, 0.0f.xx, 1.0f.xx);
            _1093 = float4(_1127.x, _1127.y, _1093.z, _1093.w);
            _1130 = (_1093.xy * (-2.0f).xx) + 3.0f.xx;
            float2 _1141 = _1093.xy * _1093.xy;
            _1093 = float4(_1141.x, _1141.y, _1093.z, _1093.w);
            float2 _1148 = _1093.xy * _1130;
            _1144 = float3(_1148.x, _1144.y, _1148.y);
            _1093.x = ((-_1130.x) * _1093.x) + 1.0f;
            _1093.x *= _1144.z;
            _55 *= _1093.x;
            _1093.x = (_1144.x * 0.60000002384185791015625f) + _55;
            _1093.x = clamp(_1093.x, 0.0f, 1.0f);
            _1093.x = ((-_1093.x) * _46_m55) + 1.0f;
            _1130.x = _1080.x * 23.0f;
            _210.x = (_46_m0.y * 11.0f) + _1130.x;
            _210.x = sin(_210.x);
            _210.x = (_210.x * 0.25f) + 0.75f;
            _1130.x = _954 * 3.0f;
            _980 = (_980 * _210.x) + _1130.x;
            _55 *= _46_m54;
            _55 *= 0.07999999821186065673828125f;
            _55 = (_1144.x * _980) + _55;
            _1144 = _55.xxx * _46_m48.xyz;
            _55 = _46_m61 + 1.0f;
            _1144 = _55.xxx * _1144;
            float3 _1255 = (_70 * _1093.xxx) + _1144;
            _1093 = float4(_1255.x, _1255.y, _1255.z, _1093.w);
            _1258 = _70 + (-_1093.xyz);
            _70 = (vs_TEXCOORD2.www * _1258) + _1093.xyz;
        }
    }
    _973 = 0.00999999977648258209228515625f < vs_TEXCOORD2.w;
    if (_973)
    {
        _1080 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
        float3 _1290 = (_1080 * 2.0f.xxx) + (-1.0f).xxx;
        _1093 = float4(_1290.x, _1290.y, _1290.z, _1093.w);
        float2 _1299 = _1093.xy * _46_m6.xx;
        _1093 = float4(_1299.x, _1299.y, _1093.z, _1093.w);
        _1258.x = dot(vs_TEXCOORD3, _1093.xyz);
        _1258.y = dot(vs_TEXCOORD4, _1093.xyz);
        _1258.z = dot(vs_TEXCOORD5, _1093.xyz);
        _55 = dot(_1258, _1258);
        _55 = rsqrt(_55);
        float3 _1328 = _55.xxx * _1258;
        _1093 = float4(_1328.x, _1328.y, _1328.z, _1093.w);
        _210 = (-vs_TEXCOORD1) + _46_m1;
        _444 = dot(_210, _210);
        _444 = rsqrt(_444);
        _404 = _444.xxx * _210;
        _1346 = vs_TEXCOORD2.y + (-_46_m10.x);
        _1354.x = (-_46_m10.x) + _46_m10.y;
        _1354.x = max(_1354.x, 0.001000000047497451305389404296875f);
        _1346 /= _1354.x;
        _1346 = clamp(_1346, 0.0f, 1.0f);
        _1258 = _46_m8.xyz + (-_46_m9.xyz);
        _1258 = (_1346.xxx * _1258) + _46_m9.xyz;
        _1390 = (_210 * _444.xxx) + _46_m2.xyz;
        _55 = dot(_1390, _1390);
        _55 = rsqrt(_55);
        _1390 = _55.xxx * _1390;
        _55 = dot(_1093.xyz, _1390);
        _55 = clamp(_55, 0.0f, 1.0f);
        _55 = log2(_55);
        _55 *= _46_m14;
        _55 = exp2(_55);
        _55 += (-0.60000002384185791015625f);
        _55 *= 10.000003814697265625f;
        _55 = clamp(_55, 0.0f, 1.0f);
        _980 = (_55 * (-2.0f)) + 3.0f;
        _55 *= _55;
        _55 *= _980;
        _55 *= _46_m15;
        _980 = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
        _1451 = vs_TEXCOORD2.xyz / _46_m12.xxx;
        _1451 = floor(_1451);
        _1451 *= float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
        _1451 = frac(_1451);
        _210 = _1451.yxz + 33.3300018310546875f.xxx;
        _210.x = dot(_1451, _210);
        _1451 += _210.xxx;
        _1451.x = _1451.y + _1451.x;
        _1451.x = _1451.z * _1451.x;
        _1451.x = frac(_1451.x);
        _980 *= 2.2000000476837158203125f;
        _1390 = _980.xxx * _1258;
        _980 = _1451.x + (-0.5f);
        _980 = dot(_980.xx, _46_m13.xx);
        _980 += 1.0f;
        _1390 = _980.xxx * _1390;
        _1390 *= _46_m11.xxx;
        _1528 = _55.xxx * _46_m62.xyz;
        _1536 = (_1258 * 1.5f.xxx) + (-1.0f).xxx;
        _1536 = (_1536 * 0.5f.xxx) + 1.0f.xxx;
        _1528 *= _1536;
        _30 = (_1390 * _30) + _1528;
        _55 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
        _1562 = int((_55 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
        _1570 = ~_1562;
        _1573 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
        _1570 = _1573 ? _1570 : 0;
        _991 = int3(uint3(bool4(0.0f.xxxx.x < vs_TEXCOORD6.xzyx.x, 0.0f.xxxx.y < vs_TEXCOORD6.xzyx.y, 0.0f.xxxx.z < vs_TEXCOORD6.xzyx.z, 0.0f.xxxx.w < vs_TEXCOORD6.xzyx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1597 = int3(uint3(bool4(vs_TEXCOORD6.xzyx.x < 0.0f.xxxx.x, vs_TEXCOORD6.xzyx.y < 0.0f.xxxx.y, vs_TEXCOORD6.xzyx.z < 0.0f.xxxx.z, vs_TEXCOORD6.xzyx.w < 0.0f.xxxx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _991 = (-_991) + _1597;
        _1354.x = float(_991.x);
        _1354.y = 0.0f;
        _1354.z = 0.0f;
        _1616.x = 0.0f;
        _1616.y = 0.0f;
        _1616.z = float(_991.y);
        _1623.x = 0.0f;
        _1623.z = 0.0f;
        _1623.y = float(_991.z);
        float3 _1633;
        if (_1570 != 0)
        {
            _1633 = _1616;
        }
        else
        {
            _1633 = _1623;
        }
        _210 = _1633;
        float3 _1642;
        if (_1562 != 0)
        {
            _1642 = _1354.xyz;
        }
        else
        {
            _1642 = _210;
        }
        _210 = _1642;
        float3 _1655 = _404.yyy * _46_m3[1].xyz;
        _1354 = float4(_1655.x, _1655.y, _1655.z, _1354.w);
        float3 _1666 = (_46_m3[0].xyz * _404.xxx) + _1354.xyz;
        _1354 = float4(_1666.x, _1666.y, _1666.z, _1354.w);
        float3 _1677 = (_46_m3[2].xyz * _404.zzz) + _1354.xyz;
        _1354 = float4(_1677.x, _1677.y, _1677.z, _1354.w);
        _1680.x = dot(_1354.xyz, _1354.xyz);
        _1680.x = rsqrt(_1680.x);
        float3 _1695 = _1680.xxx * _1354.xyz;
        _1354 = float4(_1695.x, _1695.y, _1695.z, _1354.w);
        _1616 = _1093.yyy * _46_m3[1].xyz;
        _1616 = (_46_m3[0].xyz * _1093.xxx) + _1616;
        _1616 = (_46_m3[2].xyz * _1093.zzz) + _1616;
        _1680.x = dot(_1616, _1616);
        _1680.x = rsqrt(_1680.x);
        _210.x = dot(_1354.xyz, _210);
        _210.x = max(abs(_210.x), 0.300000011920928955078125f);
        _210 = (-_1354.xyz) / _210.xxx;
        float3 _1750 = (_1616 * _1680.xxx) + (-vs_TEXCOORD6);
        _1354 = float4(_1750.x, _1750.y, _1750.z, _1354.w);
        _210 = (_1354.xyz * float3(float3(_46_m22, _46_m22, _46_m22))) + _210;
        _1770 = int(uint(_1570) | uint(_1562));
        _444 = _46_m0.y * _46_m33;
        _1680.x = asfloat(uint(_1770) & asuint(_444));
        if (_82)
        {
            float3 _1799 = vs_TEXCOORD1 + (-_46_m57[0].xyz);
            _1354 = float4(_1799.x, _1799.y, _1799.z, _1354.w);
            _1802 = dot(_1354.xyz, _1354.xyz);
            _1802 = sqrt(_1802);
            _1802 /= _46_m43;
            _1802 = (-_1802) + 1.0f;
            _1802 = clamp(_1802, 0.0f, 1.0f);
            _1802 *= _46_m57[0].w;
            _1802 = max(_1802, 0.0f);
            float3 _1831 = vs_TEXCOORD1 + (-_46_m57[1].xyz);
            _1354 = float4(_1831.x, _1831.y, _1831.z, _1354.w);
            _444 = dot(_1354.xyz, _1354.xyz);
            _444 = sqrt(_444);
            _444 /= _46_m43;
            _444 = (-_444) + 1.0f;
            _444 = clamp(_444, 0.0f, 1.0f);
            _444 *= _46_m57[1].w;
            _1354.x = max(_1802, _444);
            _1802 = _46_m0.y + (-_46_m58[0].w);
            _1864 = _46_m58[0].w >= 0.001000000047497451305389404296875f;
            _444 = float(_1864);
            _1870 = _1802 >= 0.0f;
            _1346 = float(_1870);
            _444 *= _1346;
            _1870 = _46_m46 >= _1802;
            _1346 = float(_1870);
            _444 *= _1346;
            _1616 = vs_TEXCOORD1 + (-_46_m58[0].xyz);
            _1346 = dot(_1616, _1616);
            _1346 = sqrt(_1346);
            _1346 = ((-_1802) * _46_m44) + _1346;
            _1346 /= _46_m45;
            _1346 *= (-_1346);
            _1346 *= 1.44270002841949462890625f;
            _1346 = exp2(_1346);
            _1802 /= _46_m46;
            _1802 = (-_1802) + 1.0f;
            _1802 *= _1346;
            _1346 = _46_m0.y + (-_46_m58[1].w);
            _1937.x = _46_m58[1].w >= 0.001000000047497451305389404296875f;
            _1937.y = _1346 >= 0.0f;
            _1945.x = float(_1937.x);
            _1945.y = float(_1937.y);
            _1945.x = _1945.y * _1945.x;
            _1960 = _46_m46 >= _1346;
            _1965 = float(_1960);
            _1945.x = _1965 * _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m58[1].xyz);
            _1965 = dot(_1616, _1616);
            _1965 = sqrt(_1965);
            _1965 = ((-_1346) * _46_m44) + _1965;
            _1965 /= _46_m45;
            _1965 *= (-_1965);
            _1965 *= 1.44270002841949462890625f;
            _1965 = exp2(_1965);
            _1346 /= _46_m46;
            _1346 = (-_1346) + 1.0f;
            _1346 *= _1965;
            _1346 = _1945.x * _1346;
            _1802 = (_1802 * _444) + _1346;
            _444 = _46_m0.y + (-_46_m58[2].w);
            _1870 = _46_m58[2].w >= 0.001000000047497451305389404296875f;
            _1346 = float(_1870);
            _1937.x = _444 >= 0.0f;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1937.x = _46_m46 >= _444;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m58[2].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_444) * _46_m44) + _1945.x;
            _1945.x /= _46_m45;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _444 /= _46_m46;
            _444 = (-_444) + 1.0f;
            _444 *= _1945.x;
            _1802 = (_444 * _1346) + _1802;
            _444 = _46_m0.y + (-_46_m58[3].w);
            _1870 = _46_m58[3].w >= 0.001000000047497451305389404296875f;
            _1346 = float(_1870);
            _1937.x = _444 >= 0.0f;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1937.x = _46_m46 >= _444;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m58[3].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_444) * _46_m44) + _1945.x;
            _1945.x /= _46_m45;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _444 /= _46_m46;
            _444 = (-_444) + 1.0f;
            _444 *= _1945.x;
            _1354.y = (_444 * _1346) + _1802;
            _1390 = float3(_1354.xy.x, _1354.xy.y, _1390.z);
        }
        else
        {
            _1390.x = 0.0f;
            _1390.y = 0.0f;
        }
        _55 = _1390.x * _1390.x;
        float3 _2233 = (_210 * _46_m31.xxx) + vs_TEXCOORD2.xyz;
        _1354 = float4(_2233.x, _2233.y, _2233.z, _1354.w);
        float2 _2238;
        if (_1570 != 0)
        {
            _2238 = _1354.xy;
        }
        else
        {
            _2238 = _1354.xz;
        }
        _1354 = float4(_2238.x, _1354.y, _1354.z, _2238.y);
        float2 _2251;
        if (_1562 != 0)
        {
            _2251 = _1354.zy;
        }
        else
        {
            _2251 = _1354.xw;
        }
        _1354 = float4(_2251.x, _2251.y, _1354.z, _1354.w);
        _1354.z = (-_1680.x) + _1354.y;
        _1680 = _1354.xz / float2(float2(_46_m32, _46_m32));
        _151 = floor(_1680.xyxy);
        _444 = (_1570 != 0) ? 37.0f : 74.0f;
        _444 = (_1562 != 0) ? 0.0f : _444;
        _151 += _444.xxxx;
        float2 _2302 = _151.zw * float2(123.339996337890625f, 456.209991455078125f);
        _1354 = float4(_2302.x, _2302.y, _1354.z, _1354.w);
        float2 _2307 = frac(_1354.xy);
        _1354 = float4(_2307.x, _2307.y, _1354.z, _1354.w);
        _1945 = _1354.xy + 45.31999969482421875f.xx;
        _444 = dot(_1354.xy, _1945);
        float2 _2323 = _444.xx + _1354.xy;
        _1354 = float4(_2323.x, _2323.y, _1354.z, _1354.w);
        _444 = _1354.y * _1354.x;
        _444 = frac(_444);
        _151 += float4(17.3099994659423828125f, 17.3099994659423828125f, 5.730000019073486328125f, 5.730000019073486328125f);
        _151 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
        _151 = frac(_151);
        _1354 = _151 + 45.31999969482421875f.xxxx;
        _1346 = dot(_151.xy, _1354.xy);
        float2 _2355 = _151.xy + _1346.xx;
        _1354 = float4(_2355.x, _2355.y, _1354.z, _1354.w);
        _1346 = _1354.y * _1354.x;
        _1346 = frac(_1346);
        _1354.x = dot(_151.zw, _1354.zw);
        float2 _2375 = _151.zw + _1354.xx;
        _1354 = float4(_2375.x, _2375.y, _1354.z, _1354.w);
        _1354.x = _1354.y * _1354.x;
        _1354.x = frac(_1354.x);
        _1528 = _444.xxx * float3(16.0f, 13.69999980926513671875f, 40.0f);
        _980 = floor(_1528.x);
        _2397 = frac(_1680);
        _444 = _980 * 0.25f;
        _1960 = _444 >= (-_444);
        _1616.x = frac(_444);
        float _2411;
        if (_1960)
        {
            _2411 = _1616.x;
        }
        else
        {
            _2411 = -_1616.x;
        }
        _1965 = _2411;
        _1616.x = _1965 * 4.0f;
        _1616.y = floor(_444);
        _2397 += _1616.xy;
        _2397 *= 0.25f.xx;
        float2 _2436 = ddx_coarse(_1680);
        _1616 = float3(_2436.x, _2436.y, _1616.z);
        float2 _2441 = _1616.xy * 0.25f.xx;
        _1616 = float3(_2441.x, _2441.y, _1616.z);
        _1680 = ddy_coarse(_1680);
        _1680 *= 0.25f.xx;
        _2448 = _RuneTex.SampleGrad(sampler_RuneTex, _2397, float4(_1616.xyxx).xy, float4(_1680.xyxx).xy).x;
        _1802 = _46_m0.y * _46_m35;
        _980 = (_1346 * 0.800000011920928955078125f) + 0.60000002384185791015625f;
        _1802 = (_1802 * _980) + _1528.y;
        _1802 = frac(_1802);
        _980 = _1802 * 12.5f;
        _980 = min(_980, 1.0f);
        _2491 = (_980 * (-2.0f)) + 3.0f;
        _980 *= _980;
        _980 *= _2491;
        _2491 = _1802 + (-0.550000011920928955078125f);
        _2491 *= (-4.999999523162841796875f);
        _2491 = clamp(_2491, 0.0f, 1.0f);
        _2509 = (_2491 * (-2.0f)) + 3.0f;
        _2491 *= _2491;
        _2491 *= _2509;
        _980 *= _2491;
        _1802 = (_46_m0.y * 23.0f) + _1528.z;
        _1802 = sin(_1802);
        _1802 = (_1802 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
        _1802 *= _980;
        _980 = (-_46_m34) + 1.0f;
        _980 *= _46_m59;
        _980 = (_980 * 0.699999988079071044921875f) + _46_m34;
        _1864 = _980 >= _1354.x;
        _980 = float(_1864);
        _980 = _1802 * _980;
        _2491 = _1390.x + (-0.0500000007450580596923828125f);
        _2491 *= 1.53846156597137451171875f;
        _2491 = clamp(_2491, 0.0f, 1.0f);
        _2509 = (_2491 * (-2.0f)) + 3.0f;
        _2491 *= _2491;
        _2491 *= _2509;
        _980 = max(_980, _2491);
        _980 = _2448 * _980;
        float3 _2595 = (_210 * _46_m37.xxx) + vs_TEXCOORD2.xyz;
        _1354 = float4(_2595.x, _2595.y, _2595.z, _1354.w);
        float2 _2600;
        if (_1570 != 0)
        {
            _2600 = _1354.xy;
        }
        else
        {
            _2600 = _1354.xz;
        }
        _1680 = _2600;
        float2 _2611;
        if (_1562 != 0)
        {
            _2611 = _1354.zy;
        }
        else
        {
            _2611 = _1680;
        }
        _1680 = _2611;
        float2 _2629 = _1680 * float2(float2(_46_m38, _46_m38));
        _1354 = float4(_2629.x, _2629.y, _1354.z, _1354.w);
        _444 = _46_m0.y * _46_m39;
        _151 = _444.xxxx * float4(0.12999999523162841796875f, 0.310000002384185791015625f, -0.20999999344348907470703125f, 0.17000000178813934326171875f);
        _1680 = (_1680 * float2(float2(_46_m38, _46_m38))) + _151.xy;
        _2448 = _RuneTex.Sample(sampler_RuneTex, _1680).y;
        float2 _2670 = (_1354.xy * 1.37000000476837158203125f.xx) + _151.zw;
        _1354 = float4(_2670.x, _2670.y, _1354.z, _1354.w);
        _2673 = _RuneTex.Sample(sampler_RuneTex, _1354.xy).y;
        _2491 = (-_2673) + _2448;
        _2491 = ((-abs(_2491)) * 4.0f) + 1.0f;
        _2491 = max(_2491, 0.0f);
        _2491 = log2(_2491);
        _2491 *= _46_m40;
        _2491 = exp2(_2491);
        _210 = (_210 * _46_m26.xxx) + vs_TEXCOORD2.xyz;
        float2 _2711;
        if (_1570 != 0)
        {
            _2711 = _210.xy;
        }
        else
        {
            _2711 = _210.xz;
        }
        _2708 = float3(_2711.x, _2708.y, _2711.y);
        float2 _2724;
        if (_1562 != 0)
        {
            _2724 = _210.zy;
        }
        else
        {
            _2724 = _2708.xz;
        }
        _1451 = float3(_2724.x, _2724.y, _1451.z);
        _1802 = _46_m0.y * _46_m28;
        _210.x = _1802 * 0.60000002384185791015625f;
        _210.y = (-_46_m0.y) * _46_m28;
        float2 _2765 = (_1451.xy * float2(float2(_46_m27, _46_m27))) + _210.xy;
        _1451 = float3(_2765.x, _2765.y, _1451.z);
        _9.x = _RuneTex.Sample(sampler_RuneTex, _1451.xy).z;
        _1451.x = _9.x + (-0.3499999940395355224609375f);
        _1451.x *= 2.2222220897674560546875f;
        _1451.x = clamp(_1451.x, 0.0f, 1.0f);
        _2708.x = (_1451.x * (-2.0f)) + 3.0f;
        _1451.x *= _1451.x;
        _1451.x *= _2708.x;
        _1093.x = dot(_1093.xyz, _404);
        _1093.x = clamp(_1093.x, 0.0f, 1.0f);
        _1144.x = dot(_23, 0.33329999446868896484375f.xxx);
        _1130.x = log2(_1093.x);
        _1130.x *= _46_m21;
        _1130.x = exp2(_1130.x);
        _1130.x = (_1130.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
        _1144.x = _1130.x * _1144.x;
        _2708.x = _46_m0.y * _46_m23;
        _1802 = vs_TEXCOORD2.y * 0.699999988079071044921875f;
        _210.x = (_46_m0.y * _46_m23) + _1802;
        _210.x = (_2448 * 3.0f) + _210.x;
        _210.x = sin(_210.x);
        _2708.x = (_2708.x * 2.5f) + _1802;
        _2708.x = (_2448 * 3.0f) + _2708.x;
        _2708.x = sin(_2708.x);
        _1130.x = (-_210.x) + _2708.x;
        _1130.x = (_46_m59 * _1130.x) + _210.x;
        _1130.x = (_46_m24 * _1130.x) + 1.0f;
        _1093.x = (-_1093.x) + 1.0f;
        _1093.x = log2(_1093.x);
        _1093.x *= _46_m17;
        _1093.x = exp2(_1093.x);
        _1528 = _1258 * _46_m18.xyz;
        _1536 = _1258 * _46_m25.xyz;
        _1536 = _1451.xxx * _1536;
        _1536 *= _46_m29.xxx;
        _2509 = (_1390.x * _1390.x) + 1.0f;
        _1390.x = _46_m61 * 0.300000011920928955078125f;
        _2966 = (_46_m59 * 0.60000002384185791015625f) + _2509;
        _1536 = _2966.xxx * _1536;
        _1528 = (_1528 * float3(float3(_46_m20, _46_m20, _46_m20))) + _1536;
        _1536 = _2491.xxx * _46_m36.xyz;
        _2491 = (_2448 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _1536 = _2491.xxx * _1536;
        _1536 *= float3(float3(_46_m41, _46_m41, _46_m41));
        _2491 = (_55 * 2.0f) + 1.0f;
        _1528 = (_1536 * _2491.xxx) + _1528;
        _1536 = _980.xxx * _46_m30.xyz;
        _980 = (_55 * 1.5f) + _46_m59;
        _980 += 1.0f;
        _1528 = (_1536 * _980.xxx) + _1528;
        _1528 = _1144.xxx * _1528;
        _1528 *= _46_m19.xxx;
        _1528 = _1130.xxx * _1528;
        _980 = (_46_m59 * 2.0f) + _46_m61;
        _980 += 1.0f;
        float3 _3078 = _1093.xxx * _46_m16.xyz;
        _1093 = float4(_3078.x, _1093.y, _3078.y, _3078.z);
        _2509 += _46_m61;
        float3 _3089 = _1093.xzw * _2509.xxx;
        _1093 = float4(_3089.x, _1093.y, _3089.y, _3089.z);
        float3 _3098 = (_1528 * _980.xxx) + _1093.xzw;
        _1093 = float4(_3098.x, _1093.y, _3098.y, _3098.z);
        _55 *= _46_m47;
        _980 = (_1144.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _55 = (_55 * _980) + _1390.y;
        float3 _3125 = (_46_m42.xyz * _55.xxx) + _1093.xzw;
        _1093 = float4(_3125.x, _3125.y, _3125.z, _1093.w);
        _3128 = (-_1258) + 1.0f.xxx;
        _1258 = (_3128 * 0.5f.xxx) + _1258;
        float3 _3142 = (_1258 * _1390.xxx) + _1093.xyz;
        _1093 = float4(_3142.x, _3142.y, _3142.z, _1093.w);
        _30 += _1093.xyz;
        _30 = (-_70) + _30;
        _70 = (vs_TEXCOORD2.www * _30) + _70;
    }
    _1451.x = vs_TEXCOORD8;
    _1451.x = clamp(_1451.x, 0.0f, 1.0f);
    _2708 = _70 + (-_46_m4.xyz);
    _1451 = (_1451.xxx * _2708) + _46_m4.xyz;
    _3182 = float4(_1451.x, _1451.y, _1451.z, _3182.w);
    _3182.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD8 = stage_input.vs_TEXCOORD8;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._3182 = _3182;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m11[4];
float4 unity_FogParams;
float4 unity_LightmapST;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m10 unity_WorldTransformParams
#define _21_m12 unity_FogParams
#define _21_m13 unity_LightmapST
#define _21_m14 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD8;
static float4 vs_TEXCOORD0;
static float2 _147;
static float2 _160;
static float4 vs_TEXCOORD2;
static float4 _178;
static float4 _184;
static float3 _229;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD7;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _229 : NORMAL;
    float4 _184 : TANGENT;
    float2 _147 : TEXCOORD0;
    float2 _160 : TEXCOORD1;
    float4 _178 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
    float3 vs_TEXCOORD7 : TEXCOORD8;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float3 _193;
static float _249;
static float3 _262;
static float3 _275;
static float3 _281;
static float4 _327;
static float3 _333;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m11[1];
    _9 = (_21_m11[0] * _45.xxxx) + _9;
    _9 = (_21_m11[2] * _45.zzzz) + _9;
    _9 = (_21_m11[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m12.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD8 = exp2(_9.x);
    float2 _157 = (_147 * _21_m14.xy) + _21_m14.zw;
    vs_TEXCOORD0 = float4(_157.x, _157.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _170 = (_160 * _21_m13.xy) + _21_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _170.x, _170.y);
    vs_TEXCOORD2 = float4(_11.xyz.x, _11.xyz.y, _11.xyz.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _178.x;
    _9.x = _184.w * _21_m10.w;
    _193 = _184.yyy * _21_m8[1].yzx;
    _193 = (_21_m8[0].yzx * _184.xxx) + _193;
    _193 = (_21_m8[2].yzx * _184.zzz) + _193;
    _45.x = dot(_193, _193);
    _45.x = rsqrt(_45.x);
    _193 *= _45.xxx;
    _45.x = dot(_229, _21_m9[0].xyz);
    _45.y = dot(_229, _21_m9[1].xyz);
    _45.z = dot(_229, _21_m9[2].xyz);
    _249 = dot(_45.xyz, _45.xyz);
    _249 = rsqrt(_249);
    _45 = _249.xxxx * _45.xyzz;
    _262 = _193 * _45.zxy;
    _262 = (_45.yzx * _193.yzx) + (-_262);
    _275 = _9.xxx * _262.xzy;
    _281.y = _275.x;
    _281.x = _193.z;
    _281.z = _45.x;
    vs_TEXCOORD3 = _281;
    _275.x = _193.y;
    _193.y = _275.z;
    _193.z = _45.y;
    vs_TEXCOORD4 = _193;
    _275.z = _45.z;
    vs_TEXCOORD5 = _275;
    vs_TEXCOORD6 = _229;
    _262.x = _45.y * _45.y;
    _262.x = (_45.x * _45.x) + (-_262.x);
    _327 = _45.yzwx * _45.xywz;
    _333.x = dot(_21_m4, _327);
    _333.y = dot(_21_m5, _327);
    _333.z = dot(_21_m6, _327);
    _262 = (_21_m7.xyz * _262.xxx) + _333;
    _45.w = 1.0f;
    _333.x = dot(_21_m1, _45);
    _333.y = dot(_21_m2, _45);
    _333.z = dot(_21_m3, _45);
    vs_TEXCOORD7 = _262 + _333;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _160 = stage_input._160;
    _178 = stage_input._178;
    _184 = stage_input._184;
    _229 = stage_input._229;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD8 = vs_TEXCOORD8;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _46_m3[4];
float4 unity_FogColor;
float4 unity_Lightmap_HDR;
float _BumpScale;
float _RockEmission;
float4 _TopColor;
float4 _BottomColor;
float4 _HeightRange;
float _ShellBrightness;
float _BlockSize;
float _BlockVariation;
float _Gloss;
float _GlintStrength;
float4 _RimColor;
float _RimPower;
float4 _GlowColor;
float _GlowStrength;
float _InnerFill;
float _FacingPower;
float _Refraction;
float _PulseSpeed;
float _PulseAmount;
float4 _CoreColor;
float _CoreDepth;
float _CoreScale;
float _CoreSpeed;
float _CoreStrength;
float4 _RuneColor;
float _RuneDepth;
float _RuneCell;
float _RuneSpeed;
float _RuneDensity;
float _RuneBlink;
float4 _VeinColor;
float _VeinDepth;
float _VeinScale;
float _VeinSpeed;
float _VeinSharpness;
float _VeinStrength;
float4 _TouchColor;
float _HandRadius;
float _RippleSpeed;
float _RippleWidth;
float _RippleLife;
float _HandStrength;
float4 _CrackColor;
float _CrackScale;
float _CrackSpeed;
float _CrackReach;
float _CrackLife;
float _CrackOpen;
float _CrackGlow;
float _CrackDarken;
float _KevinActive;
float4 _KevinHands[2];
float4 _KevinRipples[4];
float _RiftAwake;
float _RiftCrack;
float _RiftFlash;
float4 _LightColor0;
void __unity_init()
{
    _46_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _46_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _46_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _46_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _46_m0 _Time
#define _46_m1 _WorldSpaceCameraPos
#define _46_m2 _WorldSpaceLightPos0
#define _46_m4 unity_FogColor
#define _46_m5 unity_Lightmap_HDR
#define _46_m6 _BumpScale
#define _46_m7 _RockEmission
#define _46_m8 _TopColor
#define _46_m9 _BottomColor
#define _46_m10 _HeightRange
#define _46_m11 _ShellBrightness
#define _46_m12 _BlockSize
#define _46_m13 _BlockVariation
#define _46_m14 _Gloss
#define _46_m15 _GlintStrength
#define _46_m16 _RimColor
#define _46_m17 _RimPower
#define _46_m18 _GlowColor
#define _46_m19 _GlowStrength
#define _46_m20 _InnerFill
#define _46_m21 _FacingPower
#define _46_m22 _Refraction
#define _46_m23 _PulseSpeed
#define _46_m24 _PulseAmount
#define _46_m25 _CoreColor
#define _46_m26 _CoreDepth
#define _46_m27 _CoreScale
#define _46_m28 _CoreSpeed
#define _46_m29 _CoreStrength
#define _46_m30 _RuneColor
#define _46_m31 _RuneDepth
#define _46_m32 _RuneCell
#define _46_m33 _RuneSpeed
#define _46_m34 _RuneDensity
#define _46_m35 _RuneBlink
#define _46_m36 _VeinColor
#define _46_m37 _VeinDepth
#define _46_m38 _VeinScale
#define _46_m39 _VeinSpeed
#define _46_m40 _VeinSharpness
#define _46_m41 _VeinStrength
#define _46_m42 _TouchColor
#define _46_m43 _HandRadius
#define _46_m44 _RippleSpeed
#define _46_m45 _RippleWidth
#define _46_m46 _RippleLife
#define _46_m47 _HandStrength
#define _46_m48 _CrackColor
#define _46_m49 _CrackScale
#define _46_m50 _CrackSpeed
#define _46_m51 _CrackReach
#define _46_m52 _CrackLife
#define _46_m53 _CrackOpen
#define _46_m54 _CrackGlow
#define _46_m55 _CrackDarken
#define _46_m56 _KevinActive
#define _46_m57 _KevinHands
#define _46_m58 _KevinRipples
#define _46_m59 _RiftAwake
#define _46_m60 _RiftCrack
#define _46_m61 _RiftFlash
#define _46_m62 _LightColor0


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> unity_Lightmap;
SamplerState samplerunity_Lightmap;
Texture2D<float4> _RuneTex;
SamplerState sampler_RuneTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;

static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD8;
static float4 _3182;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
};

struct SPIRV_Cross_Output
{
    float4 _3182 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _30;
static float _55;
static float3 _70;
static bool _82;
static bool2 _90;
static bool _108;
static float _134;
static float4 _151;
static bool _166;
static float3 _172;
static float2 _199;
static float3 _210;
static float _241;
static bool2 _368;
static bool _391;
static float3 _404;
static float2 _416;
static float _444;
static float _954;
static float _956;
static bool _973;
static float _980;
static int3 _991;
static int _1002;
static bool _1006;
static float3 _1080;
static float4 _1093;
static float2 _1130;
static float3 _1144;
static float3 _1258;
static float _1346;
static float4 _1354;
static float3 _1390;
static float3 _1451;
static float3 _1528;
static float3 _1536;
static int _1562;
static int _1570;
static bool _1573;
static int3 _1597;
static float3 _1616;
static float3 _1623;
static float2 _1680;
static int _1770;
static float _1802;
static bool _1864;
static bool _1870;
static bool2 _1937;
static float2 _1945;
static bool _1960;
static float _1965;
static float2 _2397;
static float _2448;
static float _2491;
static float _2509;
static float _2673;
static float3 _2708;
static float _2966;
static float3 _3128;

void frag_inner()
{
    __unity_init();
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
    _30 = unity_Lightmap.Sample(samplerunity_Lightmap, vs_TEXCOORD0.zw).xyz;
    _30 *= _46_m5.xxx;
    _55 = (-vs_TEXCOORD2.w) + 1.0f;
    _55 *= _46_m7;
    _70 = _23 * _55.xxx;
    _70 = (_9 * _30) + _70;
    _82 = 0.5f < _46_m56;
    float4 _104 = float4(_46_m60, _46_m61, _46_m60, _46_m60);
    _90 = bool4(float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).x < _104.x, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).y < _104.y, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).z < _104.z, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).w < _104.w).xy;
    _108 = _82 || _90.x;
    _108 = _90.y || _108;
    _90.x = vs_TEXCOORD2.w < 0.9900000095367431640625f;
    _108 = _108 && _90.x;
    if (_108)
    {
        if (_82)
        {
            _134 = _46_m0.y + (-_46_m58[0].w);
            _90.x = _46_m58[0].w >= 0.001000000047497451305389404296875f;
            _90.y = _134 >= 0.0f;
            _151.x = float(_90.x);
            _151.y = float(_90.y);
            _151.x = _151.y * _151.x;
            _166 = _46_m52 >= _134;
            _172.x = float(_166);
            _151.x = _172.x * _151.x;
            _172 = vs_TEXCOORD1 + (-_46_m58[0].xyz);
            _172.x = dot(_172, _172);
            _172.x = sqrt(_172.x);
            _199.x = (_134 * _46_m50) + (-_172.x);
            float2 _220 = float2(_46_m52, _46_m51) * float2(0.550000011920928955078125f, 0.449999988079071044921875f);
            _210 = float3(_220.x, _220.y, _210.z);
            _134 = ((-_46_m52) * 0.449999988079071044921875f) + _134;
            float2 _232 = 1.0f.xx / _210.xy;
            _210 = float3(_232.x, _232.y, _210.z);
            _134 *= _210.x;
            _134 = clamp(_134, 0.0f, 1.0f);
            _241 = (_134 * (-2.0f)) + 3.0f;
            _134 *= _134;
            _134 = ((-_241) * _134) + 1.0f;
            _172.x = ((-_46_m51) * 0.550000011920928955078125f) + _172.x;
            _172.x = _210.y * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _241 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_241) * _172.x) + 1.0f;
            _134 *= _172.x;
            _134 = _151.x * _134;
            _151.x = _199.x + 0.20000000298023223876953125f;
            _151.x *= 2.8571426868438720703125f;
            _151.x = clamp(_151.x, 0.0f, 1.0f);
            _172.x = (_151.x * (-2.0f)) + 3.0f;
            _151.x *= _151.x;
            _151.x *= _172.x;
            _151.x = _134 * _151.x;
            _151.x = max(_151.x, 0.0f);
            _172.x = _199.x * (-_199.x);
            _172.x *= 40.0f;
            _172.x = exp2(_172.x);
            _134 *= _172.x;
            _134 = max(_134, 0.0f);
            _172.x = _46_m0.y + (-_46_m58[1].w);
            _368.x = _46_m58[1].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m52 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m58[1].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m50) + (-_241);
            _172.x = ((-_46_m52) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _444 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_444) * _172.x) + 1.0f;
            _241 = ((-_46_m51) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _444 = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_444) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _199.x = _416.x * (-_416.x);
            _199.x *= 40.0f;
            _199.x = exp2(_199.x);
            _172.x *= _199.x;
            _134 = max(_134, _172.x);
            _172.x = _46_m0.y + (-_46_m58[2].w);
            _368.x = _46_m58[2].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m52 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m58[2].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m50) + (-_241);
            _172.x = ((-_46_m52) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _444 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_444) * _172.x) + 1.0f;
            _241 = ((-_46_m51) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _444 = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_444) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _199.x = _416.x * (-_416.x);
            _199.x *= 40.0f;
            _199.x = exp2(_199.x);
            _172.x *= _199.x;
            _134 = max(_134, _172.x);
            _172.x = _46_m0.y + (-_46_m58[3].w);
            _368.x = _46_m58[3].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m52 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m58[3].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m50) + (-_241);
            _172.x = ((-_46_m52) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _210.x = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_210.x) * _172.x) + 1.0f;
            _241 = ((-_46_m51) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _210.x = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_210.x) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _210.x = _416.x * (-_416.x);
            _210.x *= 40.0f;
            _210.x = exp2(_210.x);
            _210.x = _172.x * _210.x;
            _134 = max(_134, _210.x);
            _954 = _134;
            _956 = _151.x;
        }
        else
        {
            _954 = 0.0f;
            _956 = 0.0f;
        }
        _55 = min(_46_m61, 1.0f);
        _55 *= 0.300000011920928955078125f;
        _55 = max(_55, _46_m60);
        _55 = max(_55, _956);
        _973 = 0.00200000009499490261077880859375f < _55;
        if (_973)
        {
            _980 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
            _991.x = int((_980 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
            _1002 = ~_991.x;
            _1006 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
            _1002 = _1006 ? _1002 : 0;
            bool2 _1025 = (_1002 != 0).xx;
            _416 = float2(_1025.x ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).x : float2(0.709999978542327880859375f, 0.189999997615814208984375f).x, _1025.y ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).y : float2(0.709999978542327880859375f, 0.189999997615814208984375f).y);
            float2 _1031;
            if (_991.x != 0)
            {
                _1031 = 0.0f.xx;
            }
            else
            {
                _1031 = _416;
            }
            _416 = _1031;
            float2 _1040;
            if (_1002 != 0)
            {
                _1040 = vs_TEXCOORD2.xy;
            }
            else
            {
                _1040 = vs_TEXCOORD2.xz;
            }
            _404 = float3(_1040.x, _1040.y, _404.z);
            float2 _1054;
            if (_991.x != 0)
            {
                _1054 = vs_TEXCOORD2.zy;
            }
            else
            {
                _1054 = _404.xy;
            }
            _210 = float3(_1054.x, _1054.y, _210.z);
            float2 _1071 = _210.xy / _46_m49.xx;
            _210 = float3(_1071.x, _1071.y, _210.z);
            float2 _1077 = _416 + _210.xy;
            _210 = float3(_1077.x, _1077.y, _210.z);
            _1080.x = _RuneTex.Sample(sampler_RuneTex, _210.xy).w;
            _980 = _55 * _46_m54;
            float2 _1104 = ((-_46_m53.xx) * _55.xx) + float2(1.0f, 0.7799999713897705078125f);
            _1093 = float4(_1104.x, _1104.y, _1093.z, _1093.w);
            float2 _1112 = _1080.xx + (-_1093.xy);
            _1093 = float4(_1112.x, _1112.y, _1093.z, _1093.w);
            float2 _1120 = _1093.xy * float2(12.5f, 4.5454540252685546875f);
            _1093 = float4(_1120.x, _1120.y, _1093.z, _1093.w);
            float2 _1127 = clamp(_1093.xy, 0.0f.xx, 1.0f.xx);
            _1093 = float4(_1127.x, _1127.y, _1093.z, _1093.w);
            _1130 = (_1093.xy * (-2.0f).xx) + 3.0f.xx;
            float2 _1141 = _1093.xy * _1093.xy;
            _1093 = float4(_1141.x, _1141.y, _1093.z, _1093.w);
            float2 _1148 = _1093.xy * _1130;
            _1144 = float3(_1148.x, _1144.y, _1148.y);
            _1093.x = ((-_1130.x) * _1093.x) + 1.0f;
            _1093.x *= _1144.z;
            _55 *= _1093.x;
            _1093.x = (_1144.x * 0.60000002384185791015625f) + _55;
            _1093.x = clamp(_1093.x, 0.0f, 1.0f);
            _1093.x = ((-_1093.x) * _46_m55) + 1.0f;
            _1130.x = _1080.x * 23.0f;
            _210.x = (_46_m0.y * 11.0f) + _1130.x;
            _210.x = sin(_210.x);
            _210.x = (_210.x * 0.25f) + 0.75f;
            _1130.x = _954 * 3.0f;
            _980 = (_980 * _210.x) + _1130.x;
            _55 *= _46_m54;
            _55 *= 0.07999999821186065673828125f;
            _55 = (_1144.x * _980) + _55;
            _1144 = _55.xxx * _46_m48.xyz;
            _55 = _46_m61 + 1.0f;
            _1144 = _55.xxx * _1144;
            float3 _1255 = (_70 * _1093.xxx) + _1144;
            _1093 = float4(_1255.x, _1255.y, _1255.z, _1093.w);
            _1258 = _70 + (-_1093.xyz);
            _70 = (vs_TEXCOORD2.www * _1258) + _1093.xyz;
        }
    }
    _973 = 0.00999999977648258209228515625f < vs_TEXCOORD2.w;
    if (_973)
    {
        _1080 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
        float3 _1290 = (_1080 * 2.0f.xxx) + (-1.0f).xxx;
        _1093 = float4(_1290.x, _1290.y, _1290.z, _1093.w);
        float2 _1299 = _1093.xy * _46_m6.xx;
        _1093 = float4(_1299.x, _1299.y, _1093.z, _1093.w);
        _1258.x = dot(vs_TEXCOORD3, _1093.xyz);
        _1258.y = dot(vs_TEXCOORD4, _1093.xyz);
        _1258.z = dot(vs_TEXCOORD5, _1093.xyz);
        _55 = dot(_1258, _1258);
        _55 = rsqrt(_55);
        float3 _1328 = _55.xxx * _1258;
        _1093 = float4(_1328.x, _1328.y, _1328.z, _1093.w);
        _210 = (-vs_TEXCOORD1) + _46_m1;
        _444 = dot(_210, _210);
        _444 = rsqrt(_444);
        _404 = _444.xxx * _210;
        _1346 = vs_TEXCOORD2.y + (-_46_m10.x);
        _1354.x = (-_46_m10.x) + _46_m10.y;
        _1354.x = max(_1354.x, 0.001000000047497451305389404296875f);
        _1346 /= _1354.x;
        _1346 = clamp(_1346, 0.0f, 1.0f);
        _1258 = _46_m8.xyz + (-_46_m9.xyz);
        _1258 = (_1346.xxx * _1258) + _46_m9.xyz;
        _1390 = (_210 * _444.xxx) + _46_m2.xyz;
        _55 = dot(_1390, _1390);
        _55 = rsqrt(_55);
        _1390 = _55.xxx * _1390;
        _55 = dot(_1093.xyz, _1390);
        _55 = clamp(_55, 0.0f, 1.0f);
        _55 = log2(_55);
        _55 *= _46_m14;
        _55 = exp2(_55);
        _55 += (-0.60000002384185791015625f);
        _55 *= 10.000003814697265625f;
        _55 = clamp(_55, 0.0f, 1.0f);
        _980 = (_55 * (-2.0f)) + 3.0f;
        _55 *= _55;
        _55 *= _980;
        _55 *= _46_m15;
        _980 = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
        _1451 = vs_TEXCOORD2.xyz / _46_m12.xxx;
        _1451 = floor(_1451);
        _1451 *= float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
        _1451 = frac(_1451);
        _210 = _1451.yxz + 33.3300018310546875f.xxx;
        _210.x = dot(_1451, _210);
        _1451 += _210.xxx;
        _1451.x = _1451.y + _1451.x;
        _1451.x = _1451.z * _1451.x;
        _1451.x = frac(_1451.x);
        _980 *= 2.2000000476837158203125f;
        _1390 = _980.xxx * _1258;
        _980 = _1451.x + (-0.5f);
        _980 = dot(_980.xx, _46_m13.xx);
        _980 += 1.0f;
        _1390 = _980.xxx * _1390;
        _1390 *= _46_m11.xxx;
        _1528 = _55.xxx * _46_m62.xyz;
        _1536 = (_1258 * 1.5f.xxx) + (-1.0f).xxx;
        _1536 = (_1536 * 0.5f.xxx) + 1.0f.xxx;
        _1528 *= _1536;
        _30 = (_1390 * _30) + _1528;
        _55 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
        _1562 = int((_55 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
        _1570 = ~_1562;
        _1573 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
        _1570 = _1573 ? _1570 : 0;
        _991 = int3(uint3(bool4(0.0f.xxxx.x < vs_TEXCOORD6.xzyx.x, 0.0f.xxxx.y < vs_TEXCOORD6.xzyx.y, 0.0f.xxxx.z < vs_TEXCOORD6.xzyx.z, 0.0f.xxxx.w < vs_TEXCOORD6.xzyx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1597 = int3(uint3(bool4(vs_TEXCOORD6.xzyx.x < 0.0f.xxxx.x, vs_TEXCOORD6.xzyx.y < 0.0f.xxxx.y, vs_TEXCOORD6.xzyx.z < 0.0f.xxxx.z, vs_TEXCOORD6.xzyx.w < 0.0f.xxxx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _991 = (-_991) + _1597;
        _1354.x = float(_991.x);
        _1354.y = 0.0f;
        _1354.z = 0.0f;
        _1616.x = 0.0f;
        _1616.y = 0.0f;
        _1616.z = float(_991.y);
        _1623.x = 0.0f;
        _1623.z = 0.0f;
        _1623.y = float(_991.z);
        float3 _1633;
        if (_1570 != 0)
        {
            _1633 = _1616;
        }
        else
        {
            _1633 = _1623;
        }
        _210 = _1633;
        float3 _1642;
        if (_1562 != 0)
        {
            _1642 = _1354.xyz;
        }
        else
        {
            _1642 = _210;
        }
        _210 = _1642;
        float3 _1655 = _404.yyy * _46_m3[1].xyz;
        _1354 = float4(_1655.x, _1655.y, _1655.z, _1354.w);
        float3 _1666 = (_46_m3[0].xyz * _404.xxx) + _1354.xyz;
        _1354 = float4(_1666.x, _1666.y, _1666.z, _1354.w);
        float3 _1677 = (_46_m3[2].xyz * _404.zzz) + _1354.xyz;
        _1354 = float4(_1677.x, _1677.y, _1677.z, _1354.w);
        _1680.x = dot(_1354.xyz, _1354.xyz);
        _1680.x = rsqrt(_1680.x);
        float3 _1695 = _1680.xxx * _1354.xyz;
        _1354 = float4(_1695.x, _1695.y, _1695.z, _1354.w);
        _1616 = _1093.yyy * _46_m3[1].xyz;
        _1616 = (_46_m3[0].xyz * _1093.xxx) + _1616;
        _1616 = (_46_m3[2].xyz * _1093.zzz) + _1616;
        _1680.x = dot(_1616, _1616);
        _1680.x = rsqrt(_1680.x);
        _210.x = dot(_1354.xyz, _210);
        _210.x = max(abs(_210.x), 0.300000011920928955078125f);
        _210 = (-_1354.xyz) / _210.xxx;
        float3 _1750 = (_1616 * _1680.xxx) + (-vs_TEXCOORD6);
        _1354 = float4(_1750.x, _1750.y, _1750.z, _1354.w);
        _210 = (_1354.xyz * float3(float3(_46_m22, _46_m22, _46_m22))) + _210;
        _1770 = int(uint(_1570) | uint(_1562));
        _444 = _46_m0.y * _46_m33;
        _1680.x = asfloat(uint(_1770) & asuint(_444));
        if (_82)
        {
            float3 _1799 = vs_TEXCOORD1 + (-_46_m57[0].xyz);
            _1354 = float4(_1799.x, _1799.y, _1799.z, _1354.w);
            _1802 = dot(_1354.xyz, _1354.xyz);
            _1802 = sqrt(_1802);
            _1802 /= _46_m43;
            _1802 = (-_1802) + 1.0f;
            _1802 = clamp(_1802, 0.0f, 1.0f);
            _1802 *= _46_m57[0].w;
            _1802 = max(_1802, 0.0f);
            float3 _1831 = vs_TEXCOORD1 + (-_46_m57[1].xyz);
            _1354 = float4(_1831.x, _1831.y, _1831.z, _1354.w);
            _444 = dot(_1354.xyz, _1354.xyz);
            _444 = sqrt(_444);
            _444 /= _46_m43;
            _444 = (-_444) + 1.0f;
            _444 = clamp(_444, 0.0f, 1.0f);
            _444 *= _46_m57[1].w;
            _1354.x = max(_1802, _444);
            _1802 = _46_m0.y + (-_46_m58[0].w);
            _1864 = _46_m58[0].w >= 0.001000000047497451305389404296875f;
            _444 = float(_1864);
            _1870 = _1802 >= 0.0f;
            _1346 = float(_1870);
            _444 *= _1346;
            _1870 = _46_m46 >= _1802;
            _1346 = float(_1870);
            _444 *= _1346;
            _1616 = vs_TEXCOORD1 + (-_46_m58[0].xyz);
            _1346 = dot(_1616, _1616);
            _1346 = sqrt(_1346);
            _1346 = ((-_1802) * _46_m44) + _1346;
            _1346 /= _46_m45;
            _1346 *= (-_1346);
            _1346 *= 1.44270002841949462890625f;
            _1346 = exp2(_1346);
            _1802 /= _46_m46;
            _1802 = (-_1802) + 1.0f;
            _1802 *= _1346;
            _1346 = _46_m0.y + (-_46_m58[1].w);
            _1937.x = _46_m58[1].w >= 0.001000000047497451305389404296875f;
            _1937.y = _1346 >= 0.0f;
            _1945.x = float(_1937.x);
            _1945.y = float(_1937.y);
            _1945.x = _1945.y * _1945.x;
            _1960 = _46_m46 >= _1346;
            _1965 = float(_1960);
            _1945.x = _1965 * _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m58[1].xyz);
            _1965 = dot(_1616, _1616);
            _1965 = sqrt(_1965);
            _1965 = ((-_1346) * _46_m44) + _1965;
            _1965 /= _46_m45;
            _1965 *= (-_1965);
            _1965 *= 1.44270002841949462890625f;
            _1965 = exp2(_1965);
            _1346 /= _46_m46;
            _1346 = (-_1346) + 1.0f;
            _1346 *= _1965;
            _1346 = _1945.x * _1346;
            _1802 = (_1802 * _444) + _1346;
            _444 = _46_m0.y + (-_46_m58[2].w);
            _1870 = _46_m58[2].w >= 0.001000000047497451305389404296875f;
            _1346 = float(_1870);
            _1937.x = _444 >= 0.0f;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1937.x = _46_m46 >= _444;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m58[2].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_444) * _46_m44) + _1945.x;
            _1945.x /= _46_m45;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _444 /= _46_m46;
            _444 = (-_444) + 1.0f;
            _444 *= _1945.x;
            _1802 = (_444 * _1346) + _1802;
            _444 = _46_m0.y + (-_46_m58[3].w);
            _1870 = _46_m58[3].w >= 0.001000000047497451305389404296875f;
            _1346 = float(_1870);
            _1937.x = _444 >= 0.0f;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1937.x = _46_m46 >= _444;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m58[3].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_444) * _46_m44) + _1945.x;
            _1945.x /= _46_m45;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _444 /= _46_m46;
            _444 = (-_444) + 1.0f;
            _444 *= _1945.x;
            _1354.y = (_444 * _1346) + _1802;
            _1390 = float3(_1354.xy.x, _1354.xy.y, _1390.z);
        }
        else
        {
            _1390.x = 0.0f;
            _1390.y = 0.0f;
        }
        _55 = _1390.x * _1390.x;
        float3 _2233 = (_210 * _46_m31.xxx) + vs_TEXCOORD2.xyz;
        _1354 = float4(_2233.x, _2233.y, _2233.z, _1354.w);
        float2 _2238;
        if (_1570 != 0)
        {
            _2238 = _1354.xy;
        }
        else
        {
            _2238 = _1354.xz;
        }
        _1354 = float4(_2238.x, _1354.y, _1354.z, _2238.y);
        float2 _2251;
        if (_1562 != 0)
        {
            _2251 = _1354.zy;
        }
        else
        {
            _2251 = _1354.xw;
        }
        _1354 = float4(_2251.x, _2251.y, _1354.z, _1354.w);
        _1354.z = (-_1680.x) + _1354.y;
        _1680 = _1354.xz / float2(float2(_46_m32, _46_m32));
        _151 = floor(_1680.xyxy);
        _444 = (_1570 != 0) ? 37.0f : 74.0f;
        _444 = (_1562 != 0) ? 0.0f : _444;
        _151 += _444.xxxx;
        float2 _2302 = _151.zw * float2(123.339996337890625f, 456.209991455078125f);
        _1354 = float4(_2302.x, _2302.y, _1354.z, _1354.w);
        float2 _2307 = frac(_1354.xy);
        _1354 = float4(_2307.x, _2307.y, _1354.z, _1354.w);
        _1945 = _1354.xy + 45.31999969482421875f.xx;
        _444 = dot(_1354.xy, _1945);
        float2 _2323 = _444.xx + _1354.xy;
        _1354 = float4(_2323.x, _2323.y, _1354.z, _1354.w);
        _444 = _1354.y * _1354.x;
        _444 = frac(_444);
        _151 += float4(17.3099994659423828125f, 17.3099994659423828125f, 5.730000019073486328125f, 5.730000019073486328125f);
        _151 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
        _151 = frac(_151);
        _1354 = _151 + 45.31999969482421875f.xxxx;
        _1346 = dot(_151.xy, _1354.xy);
        float2 _2355 = _151.xy + _1346.xx;
        _1354 = float4(_2355.x, _2355.y, _1354.z, _1354.w);
        _1346 = _1354.y * _1354.x;
        _1346 = frac(_1346);
        _1354.x = dot(_151.zw, _1354.zw);
        float2 _2375 = _151.zw + _1354.xx;
        _1354 = float4(_2375.x, _2375.y, _1354.z, _1354.w);
        _1354.x = _1354.y * _1354.x;
        _1354.x = frac(_1354.x);
        _1528 = _444.xxx * float3(16.0f, 13.69999980926513671875f, 40.0f);
        _980 = floor(_1528.x);
        _2397 = frac(_1680);
        _444 = _980 * 0.25f;
        _1960 = _444 >= (-_444);
        _1616.x = frac(_444);
        float _2411;
        if (_1960)
        {
            _2411 = _1616.x;
        }
        else
        {
            _2411 = -_1616.x;
        }
        _1965 = _2411;
        _1616.x = _1965 * 4.0f;
        _1616.y = floor(_444);
        _2397 += _1616.xy;
        _2397 *= 0.25f.xx;
        float2 _2436 = ddx_coarse(_1680);
        _1616 = float3(_2436.x, _2436.y, _1616.z);
        float2 _2441 = _1616.xy * 0.25f.xx;
        _1616 = float3(_2441.x, _2441.y, _1616.z);
        _1680 = ddy_coarse(_1680);
        _1680 *= 0.25f.xx;
        _2448 = _RuneTex.SampleGrad(sampler_RuneTex, _2397, float4(_1616.xyxx).xy, float4(_1680.xyxx).xy).x;
        _1802 = _46_m0.y * _46_m35;
        _980 = (_1346 * 0.800000011920928955078125f) + 0.60000002384185791015625f;
        _1802 = (_1802 * _980) + _1528.y;
        _1802 = frac(_1802);
        _980 = _1802 * 12.5f;
        _980 = min(_980, 1.0f);
        _2491 = (_980 * (-2.0f)) + 3.0f;
        _980 *= _980;
        _980 *= _2491;
        _2491 = _1802 + (-0.550000011920928955078125f);
        _2491 *= (-4.999999523162841796875f);
        _2491 = clamp(_2491, 0.0f, 1.0f);
        _2509 = (_2491 * (-2.0f)) + 3.0f;
        _2491 *= _2491;
        _2491 *= _2509;
        _980 *= _2491;
        _1802 = (_46_m0.y * 23.0f) + _1528.z;
        _1802 = sin(_1802);
        _1802 = (_1802 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
        _1802 *= _980;
        _980 = (-_46_m34) + 1.0f;
        _980 *= _46_m59;
        _980 = (_980 * 0.699999988079071044921875f) + _46_m34;
        _1864 = _980 >= _1354.x;
        _980 = float(_1864);
        _980 = _1802 * _980;
        _2491 = _1390.x + (-0.0500000007450580596923828125f);
        _2491 *= 1.53846156597137451171875f;
        _2491 = clamp(_2491, 0.0f, 1.0f);
        _2509 = (_2491 * (-2.0f)) + 3.0f;
        _2491 *= _2491;
        _2491 *= _2509;
        _980 = max(_980, _2491);
        _980 = _2448 * _980;
        float3 _2595 = (_210 * _46_m37.xxx) + vs_TEXCOORD2.xyz;
        _1354 = float4(_2595.x, _2595.y, _2595.z, _1354.w);
        float2 _2600;
        if (_1570 != 0)
        {
            _2600 = _1354.xy;
        }
        else
        {
            _2600 = _1354.xz;
        }
        _1680 = _2600;
        float2 _2611;
        if (_1562 != 0)
        {
            _2611 = _1354.zy;
        }
        else
        {
            _2611 = _1680;
        }
        _1680 = _2611;
        float2 _2629 = _1680 * float2(float2(_46_m38, _46_m38));
        _1354 = float4(_2629.x, _2629.y, _1354.z, _1354.w);
        _444 = _46_m0.y * _46_m39;
        _151 = _444.xxxx * float4(0.12999999523162841796875f, 0.310000002384185791015625f, -0.20999999344348907470703125f, 0.17000000178813934326171875f);
        _1680 = (_1680 * float2(float2(_46_m38, _46_m38))) + _151.xy;
        _2448 = _RuneTex.Sample(sampler_RuneTex, _1680).y;
        float2 _2670 = (_1354.xy * 1.37000000476837158203125f.xx) + _151.zw;
        _1354 = float4(_2670.x, _2670.y, _1354.z, _1354.w);
        _2673 = _RuneTex.Sample(sampler_RuneTex, _1354.xy).y;
        _2491 = (-_2673) + _2448;
        _2491 = ((-abs(_2491)) * 4.0f) + 1.0f;
        _2491 = max(_2491, 0.0f);
        _2491 = log2(_2491);
        _2491 *= _46_m40;
        _2491 = exp2(_2491);
        _210 = (_210 * _46_m26.xxx) + vs_TEXCOORD2.xyz;
        float2 _2711;
        if (_1570 != 0)
        {
            _2711 = _210.xy;
        }
        else
        {
            _2711 = _210.xz;
        }
        _2708 = float3(_2711.x, _2708.y, _2711.y);
        float2 _2724;
        if (_1562 != 0)
        {
            _2724 = _210.zy;
        }
        else
        {
            _2724 = _2708.xz;
        }
        _1451 = float3(_2724.x, _2724.y, _1451.z);
        _1802 = _46_m0.y * _46_m28;
        _210.x = _1802 * 0.60000002384185791015625f;
        _210.y = (-_46_m0.y) * _46_m28;
        float2 _2765 = (_1451.xy * float2(float2(_46_m27, _46_m27))) + _210.xy;
        _1451 = float3(_2765.x, _2765.y, _1451.z);
        _9.x = _RuneTex.Sample(sampler_RuneTex, _1451.xy).z;
        _1451.x = _9.x + (-0.3499999940395355224609375f);
        _1451.x *= 2.2222220897674560546875f;
        _1451.x = clamp(_1451.x, 0.0f, 1.0f);
        _2708.x = (_1451.x * (-2.0f)) + 3.0f;
        _1451.x *= _1451.x;
        _1451.x *= _2708.x;
        _1093.x = dot(_1093.xyz, _404);
        _1093.x = clamp(_1093.x, 0.0f, 1.0f);
        _1144.x = dot(_23, 0.33329999446868896484375f.xxx);
        _1130.x = log2(_1093.x);
        _1130.x *= _46_m21;
        _1130.x = exp2(_1130.x);
        _1130.x = (_1130.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
        _1144.x = _1130.x * _1144.x;
        _2708.x = _46_m0.y * _46_m23;
        _1802 = vs_TEXCOORD2.y * 0.699999988079071044921875f;
        _210.x = (_46_m0.y * _46_m23) + _1802;
        _210.x = (_2448 * 3.0f) + _210.x;
        _210.x = sin(_210.x);
        _2708.x = (_2708.x * 2.5f) + _1802;
        _2708.x = (_2448 * 3.0f) + _2708.x;
        _2708.x = sin(_2708.x);
        _1130.x = (-_210.x) + _2708.x;
        _1130.x = (_46_m59 * _1130.x) + _210.x;
        _1130.x = (_46_m24 * _1130.x) + 1.0f;
        _1093.x = (-_1093.x) + 1.0f;
        _1093.x = log2(_1093.x);
        _1093.x *= _46_m17;
        _1093.x = exp2(_1093.x);
        _1528 = _1258 * _46_m18.xyz;
        _1536 = _1258 * _46_m25.xyz;
        _1536 = _1451.xxx * _1536;
        _1536 *= _46_m29.xxx;
        _2509 = (_1390.x * _1390.x) + 1.0f;
        _1390.x = _46_m61 * 0.300000011920928955078125f;
        _2966 = (_46_m59 * 0.60000002384185791015625f) + _2509;
        _1536 = _2966.xxx * _1536;
        _1528 = (_1528 * float3(float3(_46_m20, _46_m20, _46_m20))) + _1536;
        _1536 = _2491.xxx * _46_m36.xyz;
        _2491 = (_2448 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _1536 = _2491.xxx * _1536;
        _1536 *= float3(float3(_46_m41, _46_m41, _46_m41));
        _2491 = (_55 * 2.0f) + 1.0f;
        _1528 = (_1536 * _2491.xxx) + _1528;
        _1536 = _980.xxx * _46_m30.xyz;
        _980 = (_55 * 1.5f) + _46_m59;
        _980 += 1.0f;
        _1528 = (_1536 * _980.xxx) + _1528;
        _1528 = _1144.xxx * _1528;
        _1528 *= _46_m19.xxx;
        _1528 = _1130.xxx * _1528;
        _980 = (_46_m59 * 2.0f) + _46_m61;
        _980 += 1.0f;
        float3 _3078 = _1093.xxx * _46_m16.xyz;
        _1093 = float4(_3078.x, _1093.y, _3078.y, _3078.z);
        _2509 += _46_m61;
        float3 _3089 = _1093.xzw * _2509.xxx;
        _1093 = float4(_3089.x, _1093.y, _3089.y, _3089.z);
        float3 _3098 = (_1528 * _980.xxx) + _1093.xzw;
        _1093 = float4(_3098.x, _1093.y, _3098.y, _3098.z);
        _55 *= _46_m47;
        _980 = (_1144.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _55 = (_55 * _980) + _1390.y;
        float3 _3125 = (_46_m42.xyz * _55.xxx) + _1093.xzw;
        _1093 = float4(_3125.x, _3125.y, _3125.z, _1093.w);
        _3128 = (-_1258) + 1.0f.xxx;
        _1258 = (_3128 * 0.5f.xxx) + _1258;
        float3 _3142 = (_1258 * _1390.xxx) + _1093.xyz;
        _1093 = float4(_3142.x, _3142.y, _3142.z, _1093.w);
        _30 += _1093.xyz;
        _30 = (-_70) + _30;
        _70 = (vs_TEXCOORD2.www * _30) + _70;
    }
    _1451.x = vs_TEXCOORD8;
    _1451.x = clamp(_1451.x, 0.0f, 1.0f);
    _2708 = _70 + (-_46_m4.xyz);
    _1451 = (_1451.xxx * _2708) + _46_m4.xyz;
    _3182 = float4(_1451.x, _1451.y, _1451.z, _3182.w);
    _3182.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD8 = stage_input.vs_TEXCOORD8;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._3182 = _3182;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m11[4];
float4 unity_FogParams;
float4 unity_LightmapST;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m10 unity_WorldTransformParams
#define _21_m12 unity_FogParams
#define _21_m13 unity_LightmapST
#define _21_m14 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD8;
static float4 vs_TEXCOORD0;
static float2 _140;
static float2 _153;
static float4 vs_TEXCOORD2;
static float4 _171;
static float4 _176;
static float3 _221;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD7;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _221 : NORMAL;
    float4 _176 : TANGENT;
    float2 _140 : TEXCOORD0;
    float2 _153 : TEXCOORD1;
    float4 _171 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
    float3 vs_TEXCOORD7 : TEXCOORD8;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float3 _185;
static float _241;
static float3 _254;
static float3 _267;
static float3 _273;
static float4 _319;
static float3 _325;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m11[1];
    _9 = (_21_m11[0] * _45.xxxx) + _9;
    _9 = (_21_m11[2] * _45.zzzz) + _9;
    _9 = (_21_m11[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD8 = (_9.x * _21_m12.z) + _21_m12.w;
    float2 _150 = (_140 * _21_m14.xy) + _21_m14.zw;
    vs_TEXCOORD0 = float4(_150.x, _150.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _163 = (_153 * _21_m13.xy) + _21_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _163.x, _163.y);
    vs_TEXCOORD2 = float4(_11.xyz.x, _11.xyz.y, _11.xyz.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _171.x;
    _9.x = _176.w * _21_m10.w;
    _185 = _176.yyy * _21_m8[1].yzx;
    _185 = (_21_m8[0].yzx * _176.xxx) + _185;
    _185 = (_21_m8[2].yzx * _176.zzz) + _185;
    _45.x = dot(_185, _185);
    _45.x = rsqrt(_45.x);
    _185 *= _45.xxx;
    _45.x = dot(_221, _21_m9[0].xyz);
    _45.y = dot(_221, _21_m9[1].xyz);
    _45.z = dot(_221, _21_m9[2].xyz);
    _241 = dot(_45.xyz, _45.xyz);
    _241 = rsqrt(_241);
    _45 = _241.xxxx * _45.xyzz;
    _254 = _185 * _45.zxy;
    _254 = (_45.yzx * _185.yzx) + (-_254);
    _267 = _9.xxx * _254.xzy;
    _273.y = _267.x;
    _273.x = _185.z;
    _273.z = _45.x;
    vs_TEXCOORD3 = _273;
    _267.x = _185.y;
    _185.y = _267.z;
    _185.z = _45.y;
    vs_TEXCOORD4 = _185;
    _267.z = _45.z;
    vs_TEXCOORD5 = _267;
    vs_TEXCOORD6 = _221;
    _254.x = _45.y * _45.y;
    _254.x = (_45.x * _45.x) + (-_254.x);
    _319 = _45.yzwx * _45.xywz;
    _325.x = dot(_21_m4, _319);
    _325.y = dot(_21_m5, _319);
    _325.z = dot(_21_m6, _319);
    _254 = (_21_m7.xyz * _254.xxx) + _325;
    _45.w = 1.0f;
    _325.x = dot(_21_m1, _45);
    _325.y = dot(_21_m2, _45);
    _325.z = dot(_21_m3, _45);
    vs_TEXCOORD7 = _254 + _325;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _153 = stage_input._153;
    _171 = stage_input._171;
    _176 = stage_input._176;
    _221 = stage_input._221;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD8 = vs_TEXCOORD8;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _46_m3[4];
float4 unity_FogColor;
float4 unity_Lightmap_HDR;
float _BumpScale;
float _RockEmission;
float4 _TopColor;
float4 _BottomColor;
float4 _HeightRange;
float _ShellBrightness;
float _BlockSize;
float _BlockVariation;
float _Gloss;
float _GlintStrength;
float4 _RimColor;
float _RimPower;
float4 _GlowColor;
float _GlowStrength;
float _InnerFill;
float _FacingPower;
float _Refraction;
float _PulseSpeed;
float _PulseAmount;
float4 _CoreColor;
float _CoreDepth;
float _CoreScale;
float _CoreSpeed;
float _CoreStrength;
float4 _RuneColor;
float _RuneDepth;
float _RuneCell;
float _RuneSpeed;
float _RuneDensity;
float _RuneBlink;
float4 _VeinColor;
float _VeinDepth;
float _VeinScale;
float _VeinSpeed;
float _VeinSharpness;
float _VeinStrength;
float4 _TouchColor;
float _HandRadius;
float _RippleSpeed;
float _RippleWidth;
float _RippleLife;
float _HandStrength;
float4 _CrackColor;
float _CrackScale;
float _CrackSpeed;
float _CrackReach;
float _CrackLife;
float _CrackOpen;
float _CrackGlow;
float _CrackDarken;
float _KevinActive;
float4 _KevinHands[2];
float4 _KevinRipples[4];
float _RiftAwake;
float _RiftCrack;
float _RiftFlash;
float4 _LightColor0;
void __unity_init()
{
    _46_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _46_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _46_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _46_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _46_m0 _Time
#define _46_m1 _WorldSpaceCameraPos
#define _46_m2 _WorldSpaceLightPos0
#define _46_m4 unity_FogColor
#define _46_m5 unity_Lightmap_HDR
#define _46_m6 _BumpScale
#define _46_m7 _RockEmission
#define _46_m8 _TopColor
#define _46_m9 _BottomColor
#define _46_m10 _HeightRange
#define _46_m11 _ShellBrightness
#define _46_m12 _BlockSize
#define _46_m13 _BlockVariation
#define _46_m14 _Gloss
#define _46_m15 _GlintStrength
#define _46_m16 _RimColor
#define _46_m17 _RimPower
#define _46_m18 _GlowColor
#define _46_m19 _GlowStrength
#define _46_m20 _InnerFill
#define _46_m21 _FacingPower
#define _46_m22 _Refraction
#define _46_m23 _PulseSpeed
#define _46_m24 _PulseAmount
#define _46_m25 _CoreColor
#define _46_m26 _CoreDepth
#define _46_m27 _CoreScale
#define _46_m28 _CoreSpeed
#define _46_m29 _CoreStrength
#define _46_m30 _RuneColor
#define _46_m31 _RuneDepth
#define _46_m32 _RuneCell
#define _46_m33 _RuneSpeed
#define _46_m34 _RuneDensity
#define _46_m35 _RuneBlink
#define _46_m36 _VeinColor
#define _46_m37 _VeinDepth
#define _46_m38 _VeinScale
#define _46_m39 _VeinSpeed
#define _46_m40 _VeinSharpness
#define _46_m41 _VeinStrength
#define _46_m42 _TouchColor
#define _46_m43 _HandRadius
#define _46_m44 _RippleSpeed
#define _46_m45 _RippleWidth
#define _46_m46 _RippleLife
#define _46_m47 _HandStrength
#define _46_m48 _CrackColor
#define _46_m49 _CrackScale
#define _46_m50 _CrackSpeed
#define _46_m51 _CrackReach
#define _46_m52 _CrackLife
#define _46_m53 _CrackOpen
#define _46_m54 _CrackGlow
#define _46_m55 _CrackDarken
#define _46_m56 _KevinActive
#define _46_m57 _KevinHands
#define _46_m58 _KevinRipples
#define _46_m59 _RiftAwake
#define _46_m60 _RiftCrack
#define _46_m61 _RiftFlash
#define _46_m62 _LightColor0


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> unity_Lightmap;
SamplerState samplerunity_Lightmap;
Texture2D<float4> _RuneTex;
SamplerState sampler_RuneTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;

static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD8;
static float4 _3182;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
};

struct SPIRV_Cross_Output
{
    float4 _3182 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _30;
static float _55;
static float3 _70;
static bool _82;
static bool2 _90;
static bool _108;
static float _134;
static float4 _151;
static bool _166;
static float3 _172;
static float2 _199;
static float3 _210;
static float _241;
static bool2 _368;
static bool _391;
static float3 _404;
static float2 _416;
static float _444;
static float _954;
static float _956;
static bool _973;
static float _980;
static int3 _991;
static int _1002;
static bool _1006;
static float3 _1080;
static float4 _1093;
static float2 _1130;
static float3 _1144;
static float3 _1258;
static float _1346;
static float4 _1354;
static float3 _1390;
static float3 _1451;
static float3 _1528;
static float3 _1536;
static int _1562;
static int _1570;
static bool _1573;
static int3 _1597;
static float3 _1616;
static float3 _1623;
static float2 _1680;
static int _1770;
static float _1802;
static bool _1864;
static bool _1870;
static bool2 _1937;
static float2 _1945;
static bool _1960;
static float _1965;
static float2 _2397;
static float _2448;
static float _2491;
static float _2509;
static float _2673;
static float3 _2708;
static float _2966;
static float3 _3128;

void frag_inner()
{
    __unity_init();
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
    _30 = unity_Lightmap.Sample(samplerunity_Lightmap, vs_TEXCOORD0.zw).xyz;
    _30 *= _46_m5.xxx;
    _55 = (-vs_TEXCOORD2.w) + 1.0f;
    _55 *= _46_m7;
    _70 = _23 * _55.xxx;
    _70 = (_9 * _30) + _70;
    _82 = 0.5f < _46_m56;
    float4 _104 = float4(_46_m60, _46_m61, _46_m60, _46_m60);
    _90 = bool4(float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).x < _104.x, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).y < _104.y, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).z < _104.z, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).w < _104.w).xy;
    _108 = _82 || _90.x;
    _108 = _90.y || _108;
    _90.x = vs_TEXCOORD2.w < 0.9900000095367431640625f;
    _108 = _108 && _90.x;
    if (_108)
    {
        if (_82)
        {
            _134 = _46_m0.y + (-_46_m58[0].w);
            _90.x = _46_m58[0].w >= 0.001000000047497451305389404296875f;
            _90.y = _134 >= 0.0f;
            _151.x = float(_90.x);
            _151.y = float(_90.y);
            _151.x = _151.y * _151.x;
            _166 = _46_m52 >= _134;
            _172.x = float(_166);
            _151.x = _172.x * _151.x;
            _172 = vs_TEXCOORD1 + (-_46_m58[0].xyz);
            _172.x = dot(_172, _172);
            _172.x = sqrt(_172.x);
            _199.x = (_134 * _46_m50) + (-_172.x);
            float2 _220 = float2(_46_m52, _46_m51) * float2(0.550000011920928955078125f, 0.449999988079071044921875f);
            _210 = float3(_220.x, _220.y, _210.z);
            _134 = ((-_46_m52) * 0.449999988079071044921875f) + _134;
            float2 _232 = 1.0f.xx / _210.xy;
            _210 = float3(_232.x, _232.y, _210.z);
            _134 *= _210.x;
            _134 = clamp(_134, 0.0f, 1.0f);
            _241 = (_134 * (-2.0f)) + 3.0f;
            _134 *= _134;
            _134 = ((-_241) * _134) + 1.0f;
            _172.x = ((-_46_m51) * 0.550000011920928955078125f) + _172.x;
            _172.x = _210.y * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _241 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_241) * _172.x) + 1.0f;
            _134 *= _172.x;
            _134 = _151.x * _134;
            _151.x = _199.x + 0.20000000298023223876953125f;
            _151.x *= 2.8571426868438720703125f;
            _151.x = clamp(_151.x, 0.0f, 1.0f);
            _172.x = (_151.x * (-2.0f)) + 3.0f;
            _151.x *= _151.x;
            _151.x *= _172.x;
            _151.x = _134 * _151.x;
            _151.x = max(_151.x, 0.0f);
            _172.x = _199.x * (-_199.x);
            _172.x *= 40.0f;
            _172.x = exp2(_172.x);
            _134 *= _172.x;
            _134 = max(_134, 0.0f);
            _172.x = _46_m0.y + (-_46_m58[1].w);
            _368.x = _46_m58[1].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m52 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m58[1].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m50) + (-_241);
            _172.x = ((-_46_m52) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _444 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_444) * _172.x) + 1.0f;
            _241 = ((-_46_m51) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _444 = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_444) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _199.x = _416.x * (-_416.x);
            _199.x *= 40.0f;
            _199.x = exp2(_199.x);
            _172.x *= _199.x;
            _134 = max(_134, _172.x);
            _172.x = _46_m0.y + (-_46_m58[2].w);
            _368.x = _46_m58[2].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m52 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m58[2].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m50) + (-_241);
            _172.x = ((-_46_m52) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _444 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_444) * _172.x) + 1.0f;
            _241 = ((-_46_m51) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _444 = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_444) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _199.x = _416.x * (-_416.x);
            _199.x *= 40.0f;
            _199.x = exp2(_199.x);
            _172.x *= _199.x;
            _134 = max(_134, _172.x);
            _172.x = _46_m0.y + (-_46_m58[3].w);
            _368.x = _46_m58[3].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m52 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m58[3].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m50) + (-_241);
            _172.x = ((-_46_m52) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _210.x = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_210.x) * _172.x) + 1.0f;
            _241 = ((-_46_m51) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _210.x = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_210.x) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _210.x = _416.x * (-_416.x);
            _210.x *= 40.0f;
            _210.x = exp2(_210.x);
            _210.x = _172.x * _210.x;
            _134 = max(_134, _210.x);
            _954 = _134;
            _956 = _151.x;
        }
        else
        {
            _954 = 0.0f;
            _956 = 0.0f;
        }
        _55 = min(_46_m61, 1.0f);
        _55 *= 0.300000011920928955078125f;
        _55 = max(_55, _46_m60);
        _55 = max(_55, _956);
        _973 = 0.00200000009499490261077880859375f < _55;
        if (_973)
        {
            _980 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
            _991.x = int((_980 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
            _1002 = ~_991.x;
            _1006 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
            _1002 = _1006 ? _1002 : 0;
            bool2 _1025 = (_1002 != 0).xx;
            _416 = float2(_1025.x ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).x : float2(0.709999978542327880859375f, 0.189999997615814208984375f).x, _1025.y ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).y : float2(0.709999978542327880859375f, 0.189999997615814208984375f).y);
            float2 _1031;
            if (_991.x != 0)
            {
                _1031 = 0.0f.xx;
            }
            else
            {
                _1031 = _416;
            }
            _416 = _1031;
            float2 _1040;
            if (_1002 != 0)
            {
                _1040 = vs_TEXCOORD2.xy;
            }
            else
            {
                _1040 = vs_TEXCOORD2.xz;
            }
            _404 = float3(_1040.x, _1040.y, _404.z);
            float2 _1054;
            if (_991.x != 0)
            {
                _1054 = vs_TEXCOORD2.zy;
            }
            else
            {
                _1054 = _404.xy;
            }
            _210 = float3(_1054.x, _1054.y, _210.z);
            float2 _1071 = _210.xy / _46_m49.xx;
            _210 = float3(_1071.x, _1071.y, _210.z);
            float2 _1077 = _416 + _210.xy;
            _210 = float3(_1077.x, _1077.y, _210.z);
            _1080.x = _RuneTex.Sample(sampler_RuneTex, _210.xy).w;
            _980 = _55 * _46_m54;
            float2 _1104 = ((-_46_m53.xx) * _55.xx) + float2(1.0f, 0.7799999713897705078125f);
            _1093 = float4(_1104.x, _1104.y, _1093.z, _1093.w);
            float2 _1112 = _1080.xx + (-_1093.xy);
            _1093 = float4(_1112.x, _1112.y, _1093.z, _1093.w);
            float2 _1120 = _1093.xy * float2(12.5f, 4.5454540252685546875f);
            _1093 = float4(_1120.x, _1120.y, _1093.z, _1093.w);
            float2 _1127 = clamp(_1093.xy, 0.0f.xx, 1.0f.xx);
            _1093 = float4(_1127.x, _1127.y, _1093.z, _1093.w);
            _1130 = (_1093.xy * (-2.0f).xx) + 3.0f.xx;
            float2 _1141 = _1093.xy * _1093.xy;
            _1093 = float4(_1141.x, _1141.y, _1093.z, _1093.w);
            float2 _1148 = _1093.xy * _1130;
            _1144 = float3(_1148.x, _1144.y, _1148.y);
            _1093.x = ((-_1130.x) * _1093.x) + 1.0f;
            _1093.x *= _1144.z;
            _55 *= _1093.x;
            _1093.x = (_1144.x * 0.60000002384185791015625f) + _55;
            _1093.x = clamp(_1093.x, 0.0f, 1.0f);
            _1093.x = ((-_1093.x) * _46_m55) + 1.0f;
            _1130.x = _1080.x * 23.0f;
            _210.x = (_46_m0.y * 11.0f) + _1130.x;
            _210.x = sin(_210.x);
            _210.x = (_210.x * 0.25f) + 0.75f;
            _1130.x = _954 * 3.0f;
            _980 = (_980 * _210.x) + _1130.x;
            _55 *= _46_m54;
            _55 *= 0.07999999821186065673828125f;
            _55 = (_1144.x * _980) + _55;
            _1144 = _55.xxx * _46_m48.xyz;
            _55 = _46_m61 + 1.0f;
            _1144 = _55.xxx * _1144;
            float3 _1255 = (_70 * _1093.xxx) + _1144;
            _1093 = float4(_1255.x, _1255.y, _1255.z, _1093.w);
            _1258 = _70 + (-_1093.xyz);
            _70 = (vs_TEXCOORD2.www * _1258) + _1093.xyz;
        }
    }
    _973 = 0.00999999977648258209228515625f < vs_TEXCOORD2.w;
    if (_973)
    {
        _1080 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
        float3 _1290 = (_1080 * 2.0f.xxx) + (-1.0f).xxx;
        _1093 = float4(_1290.x, _1290.y, _1290.z, _1093.w);
        float2 _1299 = _1093.xy * _46_m6.xx;
        _1093 = float4(_1299.x, _1299.y, _1093.z, _1093.w);
        _1258.x = dot(vs_TEXCOORD3, _1093.xyz);
        _1258.y = dot(vs_TEXCOORD4, _1093.xyz);
        _1258.z = dot(vs_TEXCOORD5, _1093.xyz);
        _55 = dot(_1258, _1258);
        _55 = rsqrt(_55);
        float3 _1328 = _55.xxx * _1258;
        _1093 = float4(_1328.x, _1328.y, _1328.z, _1093.w);
        _210 = (-vs_TEXCOORD1) + _46_m1;
        _444 = dot(_210, _210);
        _444 = rsqrt(_444);
        _404 = _444.xxx * _210;
        _1346 = vs_TEXCOORD2.y + (-_46_m10.x);
        _1354.x = (-_46_m10.x) + _46_m10.y;
        _1354.x = max(_1354.x, 0.001000000047497451305389404296875f);
        _1346 /= _1354.x;
        _1346 = clamp(_1346, 0.0f, 1.0f);
        _1258 = _46_m8.xyz + (-_46_m9.xyz);
        _1258 = (_1346.xxx * _1258) + _46_m9.xyz;
        _1390 = (_210 * _444.xxx) + _46_m2.xyz;
        _55 = dot(_1390, _1390);
        _55 = rsqrt(_55);
        _1390 = _55.xxx * _1390;
        _55 = dot(_1093.xyz, _1390);
        _55 = clamp(_55, 0.0f, 1.0f);
        _55 = log2(_55);
        _55 *= _46_m14;
        _55 = exp2(_55);
        _55 += (-0.60000002384185791015625f);
        _55 *= 10.000003814697265625f;
        _55 = clamp(_55, 0.0f, 1.0f);
        _980 = (_55 * (-2.0f)) + 3.0f;
        _55 *= _55;
        _55 *= _980;
        _55 *= _46_m15;
        _980 = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
        _1451 = vs_TEXCOORD2.xyz / _46_m12.xxx;
        _1451 = floor(_1451);
        _1451 *= float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
        _1451 = frac(_1451);
        _210 = _1451.yxz + 33.3300018310546875f.xxx;
        _210.x = dot(_1451, _210);
        _1451 += _210.xxx;
        _1451.x = _1451.y + _1451.x;
        _1451.x = _1451.z * _1451.x;
        _1451.x = frac(_1451.x);
        _980 *= 2.2000000476837158203125f;
        _1390 = _980.xxx * _1258;
        _980 = _1451.x + (-0.5f);
        _980 = dot(_980.xx, _46_m13.xx);
        _980 += 1.0f;
        _1390 = _980.xxx * _1390;
        _1390 *= _46_m11.xxx;
        _1528 = _55.xxx * _46_m62.xyz;
        _1536 = (_1258 * 1.5f.xxx) + (-1.0f).xxx;
        _1536 = (_1536 * 0.5f.xxx) + 1.0f.xxx;
        _1528 *= _1536;
        _30 = (_1390 * _30) + _1528;
        _55 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
        _1562 = int((_55 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
        _1570 = ~_1562;
        _1573 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
        _1570 = _1573 ? _1570 : 0;
        _991 = int3(uint3(bool4(0.0f.xxxx.x < vs_TEXCOORD6.xzyx.x, 0.0f.xxxx.y < vs_TEXCOORD6.xzyx.y, 0.0f.xxxx.z < vs_TEXCOORD6.xzyx.z, 0.0f.xxxx.w < vs_TEXCOORD6.xzyx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1597 = int3(uint3(bool4(vs_TEXCOORD6.xzyx.x < 0.0f.xxxx.x, vs_TEXCOORD6.xzyx.y < 0.0f.xxxx.y, vs_TEXCOORD6.xzyx.z < 0.0f.xxxx.z, vs_TEXCOORD6.xzyx.w < 0.0f.xxxx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _991 = (-_991) + _1597;
        _1354.x = float(_991.x);
        _1354.y = 0.0f;
        _1354.z = 0.0f;
        _1616.x = 0.0f;
        _1616.y = 0.0f;
        _1616.z = float(_991.y);
        _1623.x = 0.0f;
        _1623.z = 0.0f;
        _1623.y = float(_991.z);
        float3 _1633;
        if (_1570 != 0)
        {
            _1633 = _1616;
        }
        else
        {
            _1633 = _1623;
        }
        _210 = _1633;
        float3 _1642;
        if (_1562 != 0)
        {
            _1642 = _1354.xyz;
        }
        else
        {
            _1642 = _210;
        }
        _210 = _1642;
        float3 _1655 = _404.yyy * _46_m3[1].xyz;
        _1354 = float4(_1655.x, _1655.y, _1655.z, _1354.w);
        float3 _1666 = (_46_m3[0].xyz * _404.xxx) + _1354.xyz;
        _1354 = float4(_1666.x, _1666.y, _1666.z, _1354.w);
        float3 _1677 = (_46_m3[2].xyz * _404.zzz) + _1354.xyz;
        _1354 = float4(_1677.x, _1677.y, _1677.z, _1354.w);
        _1680.x = dot(_1354.xyz, _1354.xyz);
        _1680.x = rsqrt(_1680.x);
        float3 _1695 = _1680.xxx * _1354.xyz;
        _1354 = float4(_1695.x, _1695.y, _1695.z, _1354.w);
        _1616 = _1093.yyy * _46_m3[1].xyz;
        _1616 = (_46_m3[0].xyz * _1093.xxx) + _1616;
        _1616 = (_46_m3[2].xyz * _1093.zzz) + _1616;
        _1680.x = dot(_1616, _1616);
        _1680.x = rsqrt(_1680.x);
        _210.x = dot(_1354.xyz, _210);
        _210.x = max(abs(_210.x), 0.300000011920928955078125f);
        _210 = (-_1354.xyz) / _210.xxx;
        float3 _1750 = (_1616 * _1680.xxx) + (-vs_TEXCOORD6);
        _1354 = float4(_1750.x, _1750.y, _1750.z, _1354.w);
        _210 = (_1354.xyz * float3(float3(_46_m22, _46_m22, _46_m22))) + _210;
        _1770 = int(uint(_1570) | uint(_1562));
        _444 = _46_m0.y * _46_m33;
        _1680.x = asfloat(uint(_1770) & asuint(_444));
        if (_82)
        {
            float3 _1799 = vs_TEXCOORD1 + (-_46_m57[0].xyz);
            _1354 = float4(_1799.x, _1799.y, _1799.z, _1354.w);
            _1802 = dot(_1354.xyz, _1354.xyz);
            _1802 = sqrt(_1802);
            _1802 /= _46_m43;
            _1802 = (-_1802) + 1.0f;
            _1802 = clamp(_1802, 0.0f, 1.0f);
            _1802 *= _46_m57[0].w;
            _1802 = max(_1802, 0.0f);
            float3 _1831 = vs_TEXCOORD1 + (-_46_m57[1].xyz);
            _1354 = float4(_1831.x, _1831.y, _1831.z, _1354.w);
            _444 = dot(_1354.xyz, _1354.xyz);
            _444 = sqrt(_444);
            _444 /= _46_m43;
            _444 = (-_444) + 1.0f;
            _444 = clamp(_444, 0.0f, 1.0f);
            _444 *= _46_m57[1].w;
            _1354.x = max(_1802, _444);
            _1802 = _46_m0.y + (-_46_m58[0].w);
            _1864 = _46_m58[0].w >= 0.001000000047497451305389404296875f;
            _444 = float(_1864);
            _1870 = _1802 >= 0.0f;
            _1346 = float(_1870);
            _444 *= _1346;
            _1870 = _46_m46 >= _1802;
            _1346 = float(_1870);
            _444 *= _1346;
            _1616 = vs_TEXCOORD1 + (-_46_m58[0].xyz);
            _1346 = dot(_1616, _1616);
            _1346 = sqrt(_1346);
            _1346 = ((-_1802) * _46_m44) + _1346;
            _1346 /= _46_m45;
            _1346 *= (-_1346);
            _1346 *= 1.44270002841949462890625f;
            _1346 = exp2(_1346);
            _1802 /= _46_m46;
            _1802 = (-_1802) + 1.0f;
            _1802 *= _1346;
            _1346 = _46_m0.y + (-_46_m58[1].w);
            _1937.x = _46_m58[1].w >= 0.001000000047497451305389404296875f;
            _1937.y = _1346 >= 0.0f;
            _1945.x = float(_1937.x);
            _1945.y = float(_1937.y);
            _1945.x = _1945.y * _1945.x;
            _1960 = _46_m46 >= _1346;
            _1965 = float(_1960);
            _1945.x = _1965 * _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m58[1].xyz);
            _1965 = dot(_1616, _1616);
            _1965 = sqrt(_1965);
            _1965 = ((-_1346) * _46_m44) + _1965;
            _1965 /= _46_m45;
            _1965 *= (-_1965);
            _1965 *= 1.44270002841949462890625f;
            _1965 = exp2(_1965);
            _1346 /= _46_m46;
            _1346 = (-_1346) + 1.0f;
            _1346 *= _1965;
            _1346 = _1945.x * _1346;
            _1802 = (_1802 * _444) + _1346;
            _444 = _46_m0.y + (-_46_m58[2].w);
            _1870 = _46_m58[2].w >= 0.001000000047497451305389404296875f;
            _1346 = float(_1870);
            _1937.x = _444 >= 0.0f;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1937.x = _46_m46 >= _444;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m58[2].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_444) * _46_m44) + _1945.x;
            _1945.x /= _46_m45;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _444 /= _46_m46;
            _444 = (-_444) + 1.0f;
            _444 *= _1945.x;
            _1802 = (_444 * _1346) + _1802;
            _444 = _46_m0.y + (-_46_m58[3].w);
            _1870 = _46_m58[3].w >= 0.001000000047497451305389404296875f;
            _1346 = float(_1870);
            _1937.x = _444 >= 0.0f;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1937.x = _46_m46 >= _444;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m58[3].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_444) * _46_m44) + _1945.x;
            _1945.x /= _46_m45;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _444 /= _46_m46;
            _444 = (-_444) + 1.0f;
            _444 *= _1945.x;
            _1354.y = (_444 * _1346) + _1802;
            _1390 = float3(_1354.xy.x, _1354.xy.y, _1390.z);
        }
        else
        {
            _1390.x = 0.0f;
            _1390.y = 0.0f;
        }
        _55 = _1390.x * _1390.x;
        float3 _2233 = (_210 * _46_m31.xxx) + vs_TEXCOORD2.xyz;
        _1354 = float4(_2233.x, _2233.y, _2233.z, _1354.w);
        float2 _2238;
        if (_1570 != 0)
        {
            _2238 = _1354.xy;
        }
        else
        {
            _2238 = _1354.xz;
        }
        _1354 = float4(_2238.x, _1354.y, _1354.z, _2238.y);
        float2 _2251;
        if (_1562 != 0)
        {
            _2251 = _1354.zy;
        }
        else
        {
            _2251 = _1354.xw;
        }
        _1354 = float4(_2251.x, _2251.y, _1354.z, _1354.w);
        _1354.z = (-_1680.x) + _1354.y;
        _1680 = _1354.xz / float2(float2(_46_m32, _46_m32));
        _151 = floor(_1680.xyxy);
        _444 = (_1570 != 0) ? 37.0f : 74.0f;
        _444 = (_1562 != 0) ? 0.0f : _444;
        _151 += _444.xxxx;
        float2 _2302 = _151.zw * float2(123.339996337890625f, 456.209991455078125f);
        _1354 = float4(_2302.x, _2302.y, _1354.z, _1354.w);
        float2 _2307 = frac(_1354.xy);
        _1354 = float4(_2307.x, _2307.y, _1354.z, _1354.w);
        _1945 = _1354.xy + 45.31999969482421875f.xx;
        _444 = dot(_1354.xy, _1945);
        float2 _2323 = _444.xx + _1354.xy;
        _1354 = float4(_2323.x, _2323.y, _1354.z, _1354.w);
        _444 = _1354.y * _1354.x;
        _444 = frac(_444);
        _151 += float4(17.3099994659423828125f, 17.3099994659423828125f, 5.730000019073486328125f, 5.730000019073486328125f);
        _151 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
        _151 = frac(_151);
        _1354 = _151 + 45.31999969482421875f.xxxx;
        _1346 = dot(_151.xy, _1354.xy);
        float2 _2355 = _151.xy + _1346.xx;
        _1354 = float4(_2355.x, _2355.y, _1354.z, _1354.w);
        _1346 = _1354.y * _1354.x;
        _1346 = frac(_1346);
        _1354.x = dot(_151.zw, _1354.zw);
        float2 _2375 = _151.zw + _1354.xx;
        _1354 = float4(_2375.x, _2375.y, _1354.z, _1354.w);
        _1354.x = _1354.y * _1354.x;
        _1354.x = frac(_1354.x);
        _1528 = _444.xxx * float3(16.0f, 13.69999980926513671875f, 40.0f);
        _980 = floor(_1528.x);
        _2397 = frac(_1680);
        _444 = _980 * 0.25f;
        _1960 = _444 >= (-_444);
        _1616.x = frac(_444);
        float _2411;
        if (_1960)
        {
            _2411 = _1616.x;
        }
        else
        {
            _2411 = -_1616.x;
        }
        _1965 = _2411;
        _1616.x = _1965 * 4.0f;
        _1616.y = floor(_444);
        _2397 += _1616.xy;
        _2397 *= 0.25f.xx;
        float2 _2436 = ddx_coarse(_1680);
        _1616 = float3(_2436.x, _2436.y, _1616.z);
        float2 _2441 = _1616.xy * 0.25f.xx;
        _1616 = float3(_2441.x, _2441.y, _1616.z);
        _1680 = ddy_coarse(_1680);
        _1680 *= 0.25f.xx;
        _2448 = _RuneTex.SampleGrad(sampler_RuneTex, _2397, float4(_1616.xyxx).xy, float4(_1680.xyxx).xy).x;
        _1802 = _46_m0.y * _46_m35;
        _980 = (_1346 * 0.800000011920928955078125f) + 0.60000002384185791015625f;
        _1802 = (_1802 * _980) + _1528.y;
        _1802 = frac(_1802);
        _980 = _1802 * 12.5f;
        _980 = min(_980, 1.0f);
        _2491 = (_980 * (-2.0f)) + 3.0f;
        _980 *= _980;
        _980 *= _2491;
        _2491 = _1802 + (-0.550000011920928955078125f);
        _2491 *= (-4.999999523162841796875f);
        _2491 = clamp(_2491, 0.0f, 1.0f);
        _2509 = (_2491 * (-2.0f)) + 3.0f;
        _2491 *= _2491;
        _2491 *= _2509;
        _980 *= _2491;
        _1802 = (_46_m0.y * 23.0f) + _1528.z;
        _1802 = sin(_1802);
        _1802 = (_1802 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
        _1802 *= _980;
        _980 = (-_46_m34) + 1.0f;
        _980 *= _46_m59;
        _980 = (_980 * 0.699999988079071044921875f) + _46_m34;
        _1864 = _980 >= _1354.x;
        _980 = float(_1864);
        _980 = _1802 * _980;
        _2491 = _1390.x + (-0.0500000007450580596923828125f);
        _2491 *= 1.53846156597137451171875f;
        _2491 = clamp(_2491, 0.0f, 1.0f);
        _2509 = (_2491 * (-2.0f)) + 3.0f;
        _2491 *= _2491;
        _2491 *= _2509;
        _980 = max(_980, _2491);
        _980 = _2448 * _980;
        float3 _2595 = (_210 * _46_m37.xxx) + vs_TEXCOORD2.xyz;
        _1354 = float4(_2595.x, _2595.y, _2595.z, _1354.w);
        float2 _2600;
        if (_1570 != 0)
        {
            _2600 = _1354.xy;
        }
        else
        {
            _2600 = _1354.xz;
        }
        _1680 = _2600;
        float2 _2611;
        if (_1562 != 0)
        {
            _2611 = _1354.zy;
        }
        else
        {
            _2611 = _1680;
        }
        _1680 = _2611;
        float2 _2629 = _1680 * float2(float2(_46_m38, _46_m38));
        _1354 = float4(_2629.x, _2629.y, _1354.z, _1354.w);
        _444 = _46_m0.y * _46_m39;
        _151 = _444.xxxx * float4(0.12999999523162841796875f, 0.310000002384185791015625f, -0.20999999344348907470703125f, 0.17000000178813934326171875f);
        _1680 = (_1680 * float2(float2(_46_m38, _46_m38))) + _151.xy;
        _2448 = _RuneTex.Sample(sampler_RuneTex, _1680).y;
        float2 _2670 = (_1354.xy * 1.37000000476837158203125f.xx) + _151.zw;
        _1354 = float4(_2670.x, _2670.y, _1354.z, _1354.w);
        _2673 = _RuneTex.Sample(sampler_RuneTex, _1354.xy).y;
        _2491 = (-_2673) + _2448;
        _2491 = ((-abs(_2491)) * 4.0f) + 1.0f;
        _2491 = max(_2491, 0.0f);
        _2491 = log2(_2491);
        _2491 *= _46_m40;
        _2491 = exp2(_2491);
        _210 = (_210 * _46_m26.xxx) + vs_TEXCOORD2.xyz;
        float2 _2711;
        if (_1570 != 0)
        {
            _2711 = _210.xy;
        }
        else
        {
            _2711 = _210.xz;
        }
        _2708 = float3(_2711.x, _2708.y, _2711.y);
        float2 _2724;
        if (_1562 != 0)
        {
            _2724 = _210.zy;
        }
        else
        {
            _2724 = _2708.xz;
        }
        _1451 = float3(_2724.x, _2724.y, _1451.z);
        _1802 = _46_m0.y * _46_m28;
        _210.x = _1802 * 0.60000002384185791015625f;
        _210.y = (-_46_m0.y) * _46_m28;
        float2 _2765 = (_1451.xy * float2(float2(_46_m27, _46_m27))) + _210.xy;
        _1451 = float3(_2765.x, _2765.y, _1451.z);
        _9.x = _RuneTex.Sample(sampler_RuneTex, _1451.xy).z;
        _1451.x = _9.x + (-0.3499999940395355224609375f);
        _1451.x *= 2.2222220897674560546875f;
        _1451.x = clamp(_1451.x, 0.0f, 1.0f);
        _2708.x = (_1451.x * (-2.0f)) + 3.0f;
        _1451.x *= _1451.x;
        _1451.x *= _2708.x;
        _1093.x = dot(_1093.xyz, _404);
        _1093.x = clamp(_1093.x, 0.0f, 1.0f);
        _1144.x = dot(_23, 0.33329999446868896484375f.xxx);
        _1130.x = log2(_1093.x);
        _1130.x *= _46_m21;
        _1130.x = exp2(_1130.x);
        _1130.x = (_1130.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
        _1144.x = _1130.x * _1144.x;
        _2708.x = _46_m0.y * _46_m23;
        _1802 = vs_TEXCOORD2.y * 0.699999988079071044921875f;
        _210.x = (_46_m0.y * _46_m23) + _1802;
        _210.x = (_2448 * 3.0f) + _210.x;
        _210.x = sin(_210.x);
        _2708.x = (_2708.x * 2.5f) + _1802;
        _2708.x = (_2448 * 3.0f) + _2708.x;
        _2708.x = sin(_2708.x);
        _1130.x = (-_210.x) + _2708.x;
        _1130.x = (_46_m59 * _1130.x) + _210.x;
        _1130.x = (_46_m24 * _1130.x) + 1.0f;
        _1093.x = (-_1093.x) + 1.0f;
        _1093.x = log2(_1093.x);
        _1093.x *= _46_m17;
        _1093.x = exp2(_1093.x);
        _1528 = _1258 * _46_m18.xyz;
        _1536 = _1258 * _46_m25.xyz;
        _1536 = _1451.xxx * _1536;
        _1536 *= _46_m29.xxx;
        _2509 = (_1390.x * _1390.x) + 1.0f;
        _1390.x = _46_m61 * 0.300000011920928955078125f;
        _2966 = (_46_m59 * 0.60000002384185791015625f) + _2509;
        _1536 = _2966.xxx * _1536;
        _1528 = (_1528 * float3(float3(_46_m20, _46_m20, _46_m20))) + _1536;
        _1536 = _2491.xxx * _46_m36.xyz;
        _2491 = (_2448 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _1536 = _2491.xxx * _1536;
        _1536 *= float3(float3(_46_m41, _46_m41, _46_m41));
        _2491 = (_55 * 2.0f) + 1.0f;
        _1528 = (_1536 * _2491.xxx) + _1528;
        _1536 = _980.xxx * _46_m30.xyz;
        _980 = (_55 * 1.5f) + _46_m59;
        _980 += 1.0f;
        _1528 = (_1536 * _980.xxx) + _1528;
        _1528 = _1144.xxx * _1528;
        _1528 *= _46_m19.xxx;
        _1528 = _1130.xxx * _1528;
        _980 = (_46_m59 * 2.0f) + _46_m61;
        _980 += 1.0f;
        float3 _3078 = _1093.xxx * _46_m16.xyz;
        _1093 = float4(_3078.x, _1093.y, _3078.y, _3078.z);
        _2509 += _46_m61;
        float3 _3089 = _1093.xzw * _2509.xxx;
        _1093 = float4(_3089.x, _1093.y, _3089.y, _3089.z);
        float3 _3098 = (_1528 * _980.xxx) + _1093.xzw;
        _1093 = float4(_3098.x, _1093.y, _3098.y, _3098.z);
        _55 *= _46_m47;
        _980 = (_1144.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _55 = (_55 * _980) + _1390.y;
        float3 _3125 = (_46_m42.xyz * _55.xxx) + _1093.xzw;
        _1093 = float4(_3125.x, _3125.y, _3125.z, _1093.w);
        _3128 = (-_1258) + 1.0f.xxx;
        _1258 = (_3128 * 0.5f.xxx) + _1258;
        float3 _3142 = (_1258 * _1390.xxx) + _1093.xyz;
        _1093 = float4(_3142.x, _3142.y, _3142.z, _1093.w);
        _30 += _1093.xyz;
        _30 = (-_70) + _30;
        _70 = (vs_TEXCOORD2.www * _30) + _70;
    }
    _1451.x = vs_TEXCOORD8;
    _1451.x = clamp(_1451.x, 0.0f, 1.0f);
    _2708 = _70 + (-_46_m4.xyz);
    _1451 = (_1451.xxx * _2708) + _46_m4.xyz;
    _3182 = float4(_1451.x, _1451.y, _1451.z, _3182.w);
    _3182.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD8 = stage_input.vs_TEXCOORD8;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._3182 = _3182;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m11[4];
float4 unity_FogParams;
float4 unity_LightmapST;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m10 unity_WorldTransformParams
#define _21_m12 unity_FogParams
#define _21_m13 unity_LightmapST
#define _21_m14 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD8;
static float4 vs_TEXCOORD0;
static float2 _141;
static float2 _154;
static float4 vs_TEXCOORD2;
static float4 _172;
static float4 _178;
static float3 _223;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD7;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _223 : NORMAL;
    float4 _178 : TANGENT;
    float2 _141 : TEXCOORD0;
    float2 _154 : TEXCOORD1;
    float4 _172 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
    float3 vs_TEXCOORD7 : TEXCOORD8;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float3 _187;
static float _243;
static float3 _256;
static float3 _269;
static float3 _275;
static float4 _321;
static float3 _327;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m11[1];
    _9 = (_21_m11[0] * _45.xxxx) + _9;
    _9 = (_21_m11[2] * _45.zzzz) + _9;
    _9 = (_21_m11[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m12.y;
    vs_TEXCOORD8 = exp2(-_9.x);
    float2 _151 = (_141 * _21_m14.xy) + _21_m14.zw;
    vs_TEXCOORD0 = float4(_151.x, _151.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _164 = (_154 * _21_m13.xy) + _21_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _164.x, _164.y);
    vs_TEXCOORD2 = float4(_11.xyz.x, _11.xyz.y, _11.xyz.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _172.x;
    _9.x = _178.w * _21_m10.w;
    _187 = _178.yyy * _21_m8[1].yzx;
    _187 = (_21_m8[0].yzx * _178.xxx) + _187;
    _187 = (_21_m8[2].yzx * _178.zzz) + _187;
    _45.x = dot(_187, _187);
    _45.x = rsqrt(_45.x);
    _187 *= _45.xxx;
    _45.x = dot(_223, _21_m9[0].xyz);
    _45.y = dot(_223, _21_m9[1].xyz);
    _45.z = dot(_223, _21_m9[2].xyz);
    _243 = dot(_45.xyz, _45.xyz);
    _243 = rsqrt(_243);
    _45 = _243.xxxx * _45.xyzz;
    _256 = _187 * _45.zxy;
    _256 = (_45.yzx * _187.yzx) + (-_256);
    _269 = _9.xxx * _256.xzy;
    _275.y = _269.x;
    _275.x = _187.z;
    _275.z = _45.x;
    vs_TEXCOORD3 = _275;
    _269.x = _187.y;
    _187.y = _269.z;
    _187.z = _45.y;
    vs_TEXCOORD4 = _187;
    _269.z = _45.z;
    vs_TEXCOORD5 = _269;
    vs_TEXCOORD6 = _223;
    _256.x = _45.y * _45.y;
    _256.x = (_45.x * _45.x) + (-_256.x);
    _321 = _45.yzwx * _45.xywz;
    _327.x = dot(_21_m4, _321);
    _327.y = dot(_21_m5, _321);
    _327.z = dot(_21_m6, _321);
    _256 = (_21_m7.xyz * _256.xxx) + _327;
    _45.w = 1.0f;
    _327.x = dot(_21_m1, _45);
    _327.y = dot(_21_m2, _45);
    _327.z = dot(_21_m3, _45);
    vs_TEXCOORD7 = _256 + _327;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _154 = stage_input._154;
    _172 = stage_input._172;
    _178 = stage_input._178;
    _223 = stage_input._223;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD8 = vs_TEXCOORD8;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _48_m3[4];
float4 unity_FogColor;
float _BumpScale;
float _RockEmission;
float4 _TopColor;
float4 _BottomColor;
float4 _HeightRange;
float _ShellBrightness;
float _BlockSize;
float _BlockVariation;
float _Gloss;
float _GlintStrength;
float4 _RimColor;
float _RimPower;
float4 _GlowColor;
float _GlowStrength;
float _InnerFill;
float _FacingPower;
float _Refraction;
float _PulseSpeed;
float _PulseAmount;
float4 _CoreColor;
float _CoreDepth;
float _CoreScale;
float _CoreSpeed;
float _CoreStrength;
float4 _RuneColor;
float _RuneDepth;
float _RuneCell;
float _RuneSpeed;
float _RuneDensity;
float _RuneBlink;
float4 _VeinColor;
float _VeinDepth;
float _VeinScale;
float _VeinSpeed;
float _VeinSharpness;
float _VeinStrength;
float4 _TouchColor;
float _HandRadius;
float _RippleSpeed;
float _RippleWidth;
float _RippleLife;
float _HandStrength;
float4 _CrackColor;
float _CrackScale;
float _CrackSpeed;
float _CrackReach;
float _CrackLife;
float _CrackOpen;
float _CrackGlow;
float _CrackDarken;
float _KevinActive;
float4 _KevinHands[2];
float4 _KevinRipples[4];
float _RiftAwake;
float _RiftCrack;
float _RiftFlash;
float4 _LightColor0;
void __unity_init()
{
    _48_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _48_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _48_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _48_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _48_m0 _Time
#define _48_m1 _WorldSpaceCameraPos
#define _48_m2 _WorldSpaceLightPos0
#define _48_m4 unity_FogColor
#define _48_m5 _BumpScale
#define _48_m6 _RockEmission
#define _48_m7 _TopColor
#define _48_m8 _BottomColor
#define _48_m9 _HeightRange
#define _48_m10 _ShellBrightness
#define _48_m11 _BlockSize
#define _48_m12 _BlockVariation
#define _48_m13 _Gloss
#define _48_m14 _GlintStrength
#define _48_m15 _RimColor
#define _48_m16 _RimPower
#define _48_m17 _GlowColor
#define _48_m18 _GlowStrength
#define _48_m19 _InnerFill
#define _48_m20 _FacingPower
#define _48_m21 _Refraction
#define _48_m22 _PulseSpeed
#define _48_m23 _PulseAmount
#define _48_m24 _CoreColor
#define _48_m25 _CoreDepth
#define _48_m26 _CoreScale
#define _48_m27 _CoreSpeed
#define _48_m28 _CoreStrength
#define _48_m29 _RuneColor
#define _48_m30 _RuneDepth
#define _48_m31 _RuneCell
#define _48_m32 _RuneSpeed
#define _48_m33 _RuneDensity
#define _48_m34 _RuneBlink
#define _48_m35 _VeinColor
#define _48_m36 _VeinDepth
#define _48_m37 _VeinScale
#define _48_m38 _VeinSpeed
#define _48_m39 _VeinSharpness
#define _48_m40 _VeinStrength
#define _48_m41 _TouchColor
#define _48_m42 _HandRadius
#define _48_m43 _RippleSpeed
#define _48_m44 _RippleWidth
#define _48_m45 _RippleLife
#define _48_m46 _HandStrength
#define _48_m47 _CrackColor
#define _48_m48 _CrackScale
#define _48_m49 _CrackSpeed
#define _48_m50 _CrackReach
#define _48_m51 _CrackLife
#define _48_m52 _CrackOpen
#define _48_m53 _CrackGlow
#define _48_m54 _CrackDarken
#define _48_m55 _KevinActive
#define _48_m56 _KevinHands
#define _48_m57 _KevinRipples
#define _48_m58 _RiftAwake
#define _48_m59 _RiftCrack
#define _48_m60 _RiftFlash
#define _48_m61 _LightColor0


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> _RuneTex;
SamplerState sampler_RuneTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD7;
static float4 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD6;
static float vs_TEXCOORD8;
static float4 _3152;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
    float3 vs_TEXCOORD7 : TEXCOORD8;
};

struct SPIRV_Cross_Output
{
    float4 _3152 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _30;
static float3 _58;
static float _96;
static float3 _155;
static bool _167;
static bool2 _174;
static bool _191;
static float _215;
static float4 _232;
static bool _247;
static float3 _253;
static float2 _279;
static float4 _290;
static float _321;
static bool2 _446;
static bool _469;
static float3 _482;
static float _494;
static float _521;
static float _1020;
static float _1023;
static bool _1040;
static float _1047;
static int3 _1058;
static int _1069;
static bool _1073;
static float2 _1084;
static float3 _1106;
static float _1149;
static float3 _1161;
static float2 _1198;
static float3 _1212;
static float _1219;
static float3 _1315;
static float _1339;
static float _1349;
static float4 _1357;
static float3 _1452;
static float3 _1529;
static float3 _1536;
static int _1562;
static int _1570;
static bool _1573;
static int3 _1597;
static float3 _1616;
static float3 _1623;
static float2 _1680;
static int _1770;
static float _1802;
static bool _1864;
static bool _1870;
static bool2 _1937;
static float2 _1945;
static bool _1960;
static float _1965;
static float2 _2397;
static float _2448;
static float _2508;
static float _2672;
static float3 _2707;
static float _2810;
static float _2815;
static float _2948;
static float3 _3102;

void frag_inner()
{
    __unity_init();
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _30 = (_23 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _55 = _30.xy * _48_m5.xx;
    _30 = float3(_55.x, _55.y, _30.z);
    _58.x = dot(vs_TEXCOORD3, _30);
    _58.y = dot(vs_TEXCOORD4, _30);
    _58.z = dot(vs_TEXCOORD5, _30);
    _30.x = dot(_58, _58);
    _30.x = rsqrt(_30.x);
    _30 = _30.xxx * _58;
    _23 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
    _96 = dot(_30, _48_m2.xyz);
    _96 = (_96 * 0.5f) + 0.5f;
    _96 = clamp(_96, 0.0f, 1.0f);
    _96 += (-0.3499999940395355224609375f);
    _96 *= 2.2222220897674560546875f;
    _96 = clamp(_96, 0.0f, 1.0f);
    _58.x = (_96 * (-2.0f)) + 3.0f;
    _96 *= _96;
    _96 *= _58.x;
    _58 = (_48_m61.xyz * _96.xxx) + vs_TEXCOORD7;
    _96 = (-vs_TEXCOORD2.w) + 1.0f;
    _96 *= _48_m6;
    _155 = _23 * _96.xxx;
    _155 = (_9 * _58) + _155;
    _167 = 0.5f < _48_m55;
    float4 _187 = float4(_48_m59, _48_m60, _48_m59, _48_m59);
    _174 = bool4(float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).x < _187.x, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).y < _187.y, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).z < _187.z, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).w < _187.w).xy;
    _191 = _167 || _174.x;
    _191 = _174.y || _191;
    _174.x = vs_TEXCOORD2.w < 0.9900000095367431640625f;
    _191 = _191 && _174.x;
    if (_191)
    {
        if (_167)
        {
            _215 = _48_m0.y + (-_48_m57[0].w);
            _174.x = _48_m57[0].w >= 0.001000000047497451305389404296875f;
            _174.y = _215 >= 0.0f;
            _232.x = float(_174.x);
            _232.y = float(_174.y);
            _232.x = _232.y * _232.x;
            _247 = _48_m51 >= _215;
            _253.x = float(_247);
            _232.x = _253.x * _232.x;
            _253 = vs_TEXCOORD1 + (-_48_m57[0].xyz);
            _253.x = dot(_253, _253);
            _253.x = sqrt(_253.x);
            _279.x = (_215 * _48_m49) + (-_253.x);
            float2 _300 = float2(_48_m51, _48_m50) * float2(0.550000011920928955078125f, 0.449999988079071044921875f);
            _290 = float4(_300.x, _300.y, _290.z, _290.w);
            _215 = ((-_48_m51) * 0.449999988079071044921875f) + _215;
            float2 _312 = 1.0f.xx / _290.xy;
            _290 = float4(_312.x, _312.y, _290.z, _290.w);
            _215 *= _290.x;
            _215 = clamp(_215, 0.0f, 1.0f);
            _321 = (_215 * (-2.0f)) + 3.0f;
            _215 *= _215;
            _215 = ((-_321) * _215) + 1.0f;
            _253.x = ((-_48_m50) * 0.550000011920928955078125f) + _253.x;
            _253.x = _290.y * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _321 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_321) * _253.x) + 1.0f;
            _215 *= _253.x;
            _215 = _232.x * _215;
            _232.x = _279.x + 0.20000000298023223876953125f;
            _232.x *= 2.8571426868438720703125f;
            _232.x = clamp(_232.x, 0.0f, 1.0f);
            _253.x = (_232.x * (-2.0f)) + 3.0f;
            _232.x *= _232.x;
            _232.x *= _253.x;
            _232.x = _215 * _232.x;
            _232.x = max(_232.x, 0.0f);
            _253.x = _279.x * (-_279.x);
            _253.x *= 40.0f;
            _253.x = exp2(_253.x);
            _215 *= _253.x;
            _215 = max(_215, 0.0f);
            _253.x = _48_m0.y + (-_48_m57[1].w);
            _446.x = _48_m57[1].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m51 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m57[1].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m49) + (-_321);
            _253.x = ((-_48_m51) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _521 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_521) * _253.x) + 1.0f;
            _321 = ((-_48_m50) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _521 = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_521) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _279.x = _494 * (-_494);
            _279.x *= 40.0f;
            _279.x = exp2(_279.x);
            _253.x *= _279.x;
            _215 = max(_215, _253.x);
            _253.x = _48_m0.y + (-_48_m57[2].w);
            _446.x = _48_m57[2].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m51 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m57[2].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m49) + (-_321);
            _253.x = ((-_48_m51) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _521 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_521) * _253.x) + 1.0f;
            _321 = ((-_48_m50) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _521 = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_521) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _279.x = _494 * (-_494);
            _279.x *= 40.0f;
            _279.x = exp2(_279.x);
            _253.x *= _279.x;
            _215 = max(_215, _253.x);
            _253.x = _48_m0.y + (-_48_m57[3].w);
            _446.x = _48_m57[3].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m51 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m57[3].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m49) + (-_321);
            _253.x = ((-_48_m51) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _290.x = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_290.x) * _253.x) + 1.0f;
            _321 = ((-_48_m50) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _290.x = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_290.x) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _290.x = _494 * (-_494);
            _290.x *= 40.0f;
            _290.x = exp2(_290.x);
            _290.x = _253.x * _290.x;
            _290.x = max(_215, _290.x);
            _1020 = _290.x;
            _1023 = _232.x;
        }
        else
        {
            _1020 = 0.0f;
            _1023 = 0.0f;
        }
        _96 = min(_48_m60, 1.0f);
        _96 *= 0.300000011920928955078125f;
        _96 = max(_96, _48_m59);
        _96 = max(_96, _1023);
        _1040 = 0.00200000009499490261077880859375f < _96;
        if (_1040)
        {
            _1047 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
            _1058.x = int((_1047 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
            _1069 = ~_1058.x;
            _1073 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
            _1069 = _1073 ? _1069 : 0;
            bool2 _1093 = (_1069 != 0).xx;
            _1084 = float2(_1093.x ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).x : float2(0.709999978542327880859375f, 0.189999997615814208984375f).x, _1093.y ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).y : float2(0.709999978542327880859375f, 0.189999997615814208984375f).y);
            float2 _1099;
            if (_1058.x != 0)
            {
                _1099 = 0.0f.xx;
            }
            else
            {
                _1099 = _1084;
            }
            _1084 = _1099;
            float2 _1109;
            if (_1069 != 0)
            {
                _1109 = vs_TEXCOORD2.xy;
            }
            else
            {
                _1109 = vs_TEXCOORD2.xz;
            }
            _1106 = float3(_1109.x, _1109.y, _1106.z);
            float2 _1123;
            if (_1058.x != 0)
            {
                _1123 = vs_TEXCOORD2.zy;
            }
            else
            {
                _1123 = _1106.xy;
            }
            _482 = float3(_1123.x, _1123.y, _482.z);
            float2 _1140 = _482.xy / _48_m48.xx;
            _482 = float3(_1140.x, _1140.y, _482.z);
            float2 _1146 = _1084 + _482.xy;
            _482 = float3(_1146.x, _1146.y, _482.z);
            _1149 = _RuneTex.Sample(sampler_RuneTex, _482.xy).w;
            _1047 = _96 * _48_m53;
            float2 _1172 = ((-_48_m52.xx) * _96.xx) + float2(1.0f, 0.7799999713897705078125f);
            _1161 = float3(_1172.x, _1172.y, _1161.z);
            float2 _1180 = _1149.xx + (-_1161.xy);
            _1161 = float3(_1180.x, _1180.y, _1161.z);
            float2 _1188 = _1161.xy * float2(12.5f, 4.5454540252685546875f);
            _1161 = float3(_1188.x, _1188.y, _1161.z);
            float2 _1195 = clamp(_1161.xy, 0.0f.xx, 1.0f.xx);
            _1161 = float3(_1195.x, _1195.y, _1161.z);
            _1198 = (_1161.xy * (-2.0f).xx) + 3.0f.xx;
            float2 _1209 = _1161.xy * _1161.xy;
            _1161 = float3(_1209.x, _1209.y, _1161.z);
            float2 _1216 = _1161.xy * _1198;
            _1212 = float3(_1216.x, _1212.y, _1216.y);
            _1219 = ((-_1198.x) * _1161.x) + 1.0f;
            _1219 *= _1212.z;
            _96 *= _1219;
            _1219 = (_1212.x * 0.60000002384185791015625f) + _96;
            _1219 = clamp(_1219, 0.0f, 1.0f);
            _1219 = ((-_1219) * _48_m54) + 1.0f;
            _1161.x = _1149 * 23.0f;
            _482.x = (_48_m0.y * 11.0f) + _1161.x;
            _482.x = sin(_482.x);
            _482.x = (_482.x * 0.25f) + 0.75f;
            _1161.x = _1020 * 3.0f;
            _1047 = (_1047 * _482.x) + _1161.x;
            _96 *= _48_m53;
            _96 *= 0.07999999821186065673828125f;
            _96 = (_1212.x * _1047) + _96;
            _1161 = _96.xxx * _48_m47.xyz;
            _96 = _48_m60 + 1.0f;
            _1161 = _96.xxx * _1161;
            _1161 = (_155 * _1219.xxx) + _1161;
            _1315 = _155 + (-_1161);
            _155 = (vs_TEXCOORD2.www * _1315) + _1161;
        }
    }
    _1040 = 0.00999999977648258209228515625f < vs_TEXCOORD2.w;
    if (_1040)
    {
        _482 = (-vs_TEXCOORD1) + _48_m1;
        _1339 = dot(_482, _482);
        _1339 = rsqrt(_1339);
        _1106 = _1339.xxx * _482;
        _1349 = vs_TEXCOORD2.y + (-_48_m9.x);
        _1357.x = (-_48_m9.x) + _48_m9.y;
        _1357.x = max(_1357.x, 0.001000000047497451305389404296875f);
        _1349 /= _1357.x;
        _1349 = clamp(_1349, 0.0f, 1.0f);
        _1161 = _48_m7.xyz + (-_48_m8.xyz);
        _1161 = (_1349.xxx * _1161) + _48_m8.xyz;
        _1315 = (_482 * _1339.xxx) + _48_m2.xyz;
        _96 = dot(_1315, _1315);
        _96 = rsqrt(_96);
        _1315 = _96.xxx * _1315;
        _96 = dot(_30, _1315);
        _96 = clamp(_96, 0.0f, 1.0f);
        _96 = log2(_96);
        _96 *= _48_m13;
        _96 = exp2(_96);
        _96 += (-0.60000002384185791015625f);
        _96 *= 10.000003814697265625f;
        _96 = clamp(_96, 0.0f, 1.0f);
        _1047 = (_96 * (-2.0f)) + 3.0f;
        _96 *= _96;
        _96 *= _1047;
        _96 *= _48_m14;
        _1047 = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
        _1452 = vs_TEXCOORD2.xyz / _48_m11.xxx;
        _1452 = floor(_1452);
        _1452 *= float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
        _1452 = frac(_1452);
        _482 = _1452.yxz + 33.3300018310546875f.xxx;
        _482.x = dot(_1452, _482);
        _1452 += _482.xxx;
        _1452.x = _1452.y + _1452.x;
        _1452.x = _1452.z * _1452.x;
        _1452.x = frac(_1452.x);
        _1047 *= 2.2000000476837158203125f;
        _1315 = _1047.xxx * _1161;
        _1047 = _1452.x + (-0.5f);
        _1047 = dot(_1047.xx, _48_m12.xx);
        _1047 += 1.0f;
        _1315 = _1047.xxx * _1315;
        _1315 *= _48_m10.xxx;
        _1529 = _96.xxx * _48_m61.xyz;
        _1536 = (_1161 * 1.5f.xxx) + (-1.0f).xxx;
        _1536 = (_1536 * 0.5f.xxx) + 1.0f.xxx;
        _1529 *= _1536;
        _58 = (_1315 * _58) + _1529;
        _96 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
        _1562 = int((_96 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
        _1570 = ~_1562;
        _1573 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
        _1570 = _1573 ? _1570 : 0;
        _1058 = int3(uint3(bool4(0.0f.xxxx.x < vs_TEXCOORD6.xzyx.x, 0.0f.xxxx.y < vs_TEXCOORD6.xzyx.y, 0.0f.xxxx.z < vs_TEXCOORD6.xzyx.z, 0.0f.xxxx.w < vs_TEXCOORD6.xzyx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1597 = int3(uint3(bool4(vs_TEXCOORD6.xzyx.x < 0.0f.xxxx.x, vs_TEXCOORD6.xzyx.y < 0.0f.xxxx.y, vs_TEXCOORD6.xzyx.z < 0.0f.xxxx.z, vs_TEXCOORD6.xzyx.w < 0.0f.xxxx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1058 = (-_1058) + _1597;
        _1357.x = float(_1058.x);
        _1357.y = 0.0f;
        _1357.z = 0.0f;
        _1616.x = 0.0f;
        _1616.y = 0.0f;
        _1616.z = float(_1058.y);
        _1623.x = 0.0f;
        _1623.z = 0.0f;
        _1623.y = float(_1058.z);
        float3 _1633;
        if (_1570 != 0)
        {
            _1633 = _1616;
        }
        else
        {
            _1633 = _1623;
        }
        _482 = _1633;
        float3 _1642;
        if (_1562 != 0)
        {
            _1642 = _1357.xyz;
        }
        else
        {
            _1642 = _482;
        }
        _482 = _1642;
        float3 _1655 = _1106.yyy * _48_m3[1].xyz;
        _1357 = float4(_1655.x, _1655.y, _1655.z, _1357.w);
        float3 _1666 = (_48_m3[0].xyz * _1106.xxx) + _1357.xyz;
        _1357 = float4(_1666.x, _1666.y, _1666.z, _1357.w);
        float3 _1677 = (_48_m3[2].xyz * _1106.zzz) + _1357.xyz;
        _1357 = float4(_1677.x, _1677.y, _1677.z, _1357.w);
        _1680.x = dot(_1357.xyz, _1357.xyz);
        _1680.x = rsqrt(_1680.x);
        float3 _1695 = _1680.xxx * _1357.xyz;
        _1357 = float4(_1695.x, _1695.y, _1695.z, _1357.w);
        _1616 = _30.yyy * _48_m3[1].xyz;
        _1616 = (_48_m3[0].xyz * _30.xxx) + _1616;
        _1616 = (_48_m3[2].xyz * _30.zzz) + _1616;
        _1680.x = dot(_1616, _1616);
        _1680.x = rsqrt(_1680.x);
        _482.x = dot(_1357.xyz, _482);
        _482.x = max(abs(_482.x), 0.300000011920928955078125f);
        _482 = (-_1357.xyz) / _482.xxx;
        float3 _1750 = (_1616 * _1680.xxx) + (-vs_TEXCOORD6);
        _1357 = float4(_1750.x, _1750.y, _1750.z, _1357.w);
        _482 = (_1357.xyz * float3(float3(_48_m21, _48_m21, _48_m21))) + _482;
        _1770 = int(uint(_1570) | uint(_1562));
        _1339 = _48_m0.y * _48_m32;
        _1680.x = asfloat(uint(_1770) & asuint(_1339));
        if (_167)
        {
            float3 _1799 = vs_TEXCOORD1 + (-_48_m56[0].xyz);
            _1357 = float4(_1799.x, _1799.y, _1799.z, _1357.w);
            _1802 = dot(_1357.xyz, _1357.xyz);
            _1802 = sqrt(_1802);
            _1802 /= _48_m42;
            _1802 = (-_1802) + 1.0f;
            _1802 = clamp(_1802, 0.0f, 1.0f);
            _1802 *= _48_m56[0].w;
            _1802 = max(_1802, 0.0f);
            float3 _1831 = vs_TEXCOORD1 + (-_48_m56[1].xyz);
            _1357 = float4(_1831.x, _1831.y, _1831.z, _1357.w);
            _1339 = dot(_1357.xyz, _1357.xyz);
            _1339 = sqrt(_1339);
            _1339 /= _48_m42;
            _1339 = (-_1339) + 1.0f;
            _1339 = clamp(_1339, 0.0f, 1.0f);
            _1339 *= _48_m56[1].w;
            _1357.x = max(_1802, _1339);
            _1802 = _48_m0.y + (-_48_m57[0].w);
            _1864 = _48_m57[0].w >= 0.001000000047497451305389404296875f;
            _1339 = float(_1864);
            _1870 = _1802 >= 0.0f;
            _1349 = float(_1870);
            _1339 *= _1349;
            _1870 = _48_m45 >= _1802;
            _1349 = float(_1870);
            _1339 *= _1349;
            _1616 = vs_TEXCOORD1 + (-_48_m57[0].xyz);
            _1349 = dot(_1616, _1616);
            _1349 = sqrt(_1349);
            _1349 = ((-_1802) * _48_m43) + _1349;
            _1349 /= _48_m44;
            _1349 *= (-_1349);
            _1349 *= 1.44270002841949462890625f;
            _1349 = exp2(_1349);
            _1802 /= _48_m45;
            _1802 = (-_1802) + 1.0f;
            _1802 *= _1349;
            _1349 = _48_m0.y + (-_48_m57[1].w);
            _1937.x = _48_m57[1].w >= 0.001000000047497451305389404296875f;
            _1937.y = _1349 >= 0.0f;
            _1945.x = float(_1937.x);
            _1945.y = float(_1937.y);
            _1945.x = _1945.y * _1945.x;
            _1960 = _48_m45 >= _1349;
            _1965 = float(_1960);
            _1945.x = _1965 * _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m57[1].xyz);
            _1965 = dot(_1616, _1616);
            _1965 = sqrt(_1965);
            _1965 = ((-_1349) * _48_m43) + _1965;
            _1965 /= _48_m44;
            _1965 *= (-_1965);
            _1965 *= 1.44270002841949462890625f;
            _1965 = exp2(_1965);
            _1349 /= _48_m45;
            _1349 = (-_1349) + 1.0f;
            _1349 *= _1965;
            _1349 = _1945.x * _1349;
            _1802 = (_1802 * _1339) + _1349;
            _1339 = _48_m0.y + (-_48_m57[2].w);
            _1870 = _48_m57[2].w >= 0.001000000047497451305389404296875f;
            _1349 = float(_1870);
            _1937.x = _1339 >= 0.0f;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1937.x = _48_m45 >= _1339;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m57[2].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_1339) * _48_m43) + _1945.x;
            _1945.x /= _48_m44;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _1339 /= _48_m45;
            _1339 = (-_1339) + 1.0f;
            _1339 *= _1945.x;
            _1802 = (_1339 * _1349) + _1802;
            _1339 = _48_m0.y + (-_48_m57[3].w);
            _1870 = _48_m57[3].w >= 0.001000000047497451305389404296875f;
            _1349 = float(_1870);
            _1937.x = _1339 >= 0.0f;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1937.x = _48_m45 >= _1339;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m57[3].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_1339) * _48_m43) + _1945.x;
            _1945.x /= _48_m44;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _1339 /= _48_m45;
            _1339 = (-_1339) + 1.0f;
            _1339 *= _1945.x;
            _1357.y = (_1339 * _1349) + _1802;
            _1315 = float3(_1357.xy.x, _1357.xy.y, _1315.z);
        }
        else
        {
            _1315.x = 0.0f;
            _1315.y = 0.0f;
        }
        _96 = _1315.x * _1315.x;
        float3 _2233 = (_482 * _48_m30.xxx) + vs_TEXCOORD2.xyz;
        _1357 = float4(_2233.x, _2233.y, _2233.z, _1357.w);
        float2 _2238;
        if (_1570 != 0)
        {
            _2238 = _1357.xy;
        }
        else
        {
            _2238 = _1357.xz;
        }
        _1357 = float4(_2238.x, _1357.y, _1357.z, _2238.y);
        float2 _2251;
        if (_1562 != 0)
        {
            _2251 = _1357.zy;
        }
        else
        {
            _2251 = _1357.xw;
        }
        _1357 = float4(_2251.x, _2251.y, _1357.z, _1357.w);
        _1357.z = (-_1680.x) + _1357.y;
        _1680 = _1357.xz / float2(float2(_48_m31, _48_m31));
        _232 = floor(_1680.xyxy);
        _1339 = (_1570 != 0) ? 37.0f : 74.0f;
        _1339 = (_1562 != 0) ? 0.0f : _1339;
        _232 += _1339.xxxx;
        float2 _2302 = _232.zw * float2(123.339996337890625f, 456.209991455078125f);
        _1357 = float4(_2302.x, _2302.y, _1357.z, _1357.w);
        float2 _2307 = frac(_1357.xy);
        _1357 = float4(_2307.x, _2307.y, _1357.z, _1357.w);
        _1945 = _1357.xy + 45.31999969482421875f.xx;
        _1339 = dot(_1357.xy, _1945);
        float2 _2323 = _1339.xx + _1357.xy;
        _1357 = float4(_2323.x, _2323.y, _1357.z, _1357.w);
        _1339 = _1357.y * _1357.x;
        _1339 = frac(_1339);
        _232 += float4(17.3099994659423828125f, 17.3099994659423828125f, 5.730000019073486328125f, 5.730000019073486328125f);
        _232 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
        _232 = frac(_232);
        _290 = _232 + 45.31999969482421875f.xxxx;
        _1349 = dot(_232.xy, _290.xy);
        float2 _2355 = _232.xy + _1349.xx;
        _1357 = float4(_2355.x, _2355.y, _1357.z, _1357.w);
        _1349 = _1357.y * _1357.x;
        _1349 = frac(_1349);
        _1357.x = dot(_232.zw, _290.zw);
        float2 _2375 = _232.zw + _1357.xx;
        _1357 = float4(_2375.x, _2375.y, _1357.z, _1357.w);
        _1357.x = _1357.y * _1357.x;
        _1357.x = frac(_1357.x);
        _1529 = _1339.xxx * float3(16.0f, 13.69999980926513671875f, 40.0f);
        _1047 = floor(_1529.x);
        _2397 = frac(_1680);
        _1339 = _1047 * 0.25f;
        _1960 = _1339 >= (-_1339);
        _1616.x = frac(_1339);
        float _2411;
        if (_1960)
        {
            _2411 = _1616.x;
        }
        else
        {
            _2411 = -_1616.x;
        }
        _1965 = _2411;
        _1616.x = _1965 * 4.0f;
        _1616.y = floor(_1339);
        _2397 += _1616.xy;
        _2397 *= 0.25f.xx;
        float2 _2436 = ddx_coarse(_1680);
        _1616 = float3(_2436.x, _2436.y, _1616.z);
        float2 _2441 = _1616.xy * 0.25f.xx;
        _1616 = float3(_2441.x, _2441.y, _1616.z);
        _1680 = ddy_coarse(_1680);
        _1680 *= 0.25f.xx;
        _2448 = _RuneTex.SampleGrad(sampler_RuneTex, _2397, float4(_1616.xyxx).xy, float4(_1680.xyxx).xy).x;
        _1802 = _48_m0.y * _48_m34;
        _1047 = (_1349 * 0.800000011920928955078125f) + 0.60000002384185791015625f;
        _1802 = (_1802 * _1047) + _1529.y;
        _1802 = frac(_1802);
        _1047 = _1802 * 12.5f;
        _1047 = min(_1047, 1.0f);
        _1219 = (_1047 * (-2.0f)) + 3.0f;
        _1047 *= _1047;
        _1047 *= _1219;
        _1219 = _1802 + (-0.550000011920928955078125f);
        _1219 *= (-4.999999523162841796875f);
        _1219 = clamp(_1219, 0.0f, 1.0f);
        _2508 = (_1219 * (-2.0f)) + 3.0f;
        _1219 *= _1219;
        _1219 *= _2508;
        _1047 *= _1219;
        _1802 = (_48_m0.y * 23.0f) + _1529.z;
        _1802 = sin(_1802);
        _1802 = (_1802 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
        _1802 *= _1047;
        _1047 = (-_48_m33) + 1.0f;
        _1047 *= _48_m58;
        _1047 = (_1047 * 0.699999988079071044921875f) + _48_m33;
        _1864 = _1047 >= _1357.x;
        _1047 = float(_1864);
        _1047 = _1802 * _1047;
        _1219 = _1315.x + (-0.0500000007450580596923828125f);
        _1219 *= 1.53846156597137451171875f;
        _1219 = clamp(_1219, 0.0f, 1.0f);
        _2508 = (_1219 * (-2.0f)) + 3.0f;
        _1219 *= _1219;
        _1219 *= _2508;
        _1047 = max(_1047, _1219);
        _1047 = _2448 * _1047;
        float3 _2594 = (_482 * _48_m36.xxx) + vs_TEXCOORD2.xyz;
        _1357 = float4(_2594.x, _2594.y, _2594.z, _1357.w);
        float2 _2599;
        if (_1570 != 0)
        {
            _2599 = _1357.xy;
        }
        else
        {
            _2599 = _1357.xz;
        }
        _1680 = _2599;
        float2 _2610;
        if (_1562 != 0)
        {
            _2610 = _1357.zy;
        }
        else
        {
            _2610 = _1680;
        }
        _1680 = _2610;
        float2 _2628 = _1680 * float2(float2(_48_m37, _48_m37));
        _1357 = float4(_2628.x, _2628.y, _1357.z, _1357.w);
        _1339 = _48_m0.y * _48_m38;
        _232 = _1339.xxxx * float4(0.12999999523162841796875f, 0.310000002384185791015625f, -0.20999999344348907470703125f, 0.17000000178813934326171875f);
        _1680 = (_1680 * float2(float2(_48_m37, _48_m37))) + _232.xy;
        _2448 = _RuneTex.Sample(sampler_RuneTex, _1680).y;
        float2 _2669 = (_1357.xy * 1.37000000476837158203125f.xx) + _232.zw;
        _1357 = float4(_2669.x, _2669.y, _1357.z, _1357.w);
        _2672 = _RuneTex.Sample(sampler_RuneTex, _1357.xy).y;
        _1219 = (-_2672) + _2448;
        _1219 = ((-abs(_1219)) * 4.0f) + 1.0f;
        _1219 = max(_1219, 0.0f);
        _1219 = log2(_1219);
        _1219 *= _48_m39;
        _1219 = exp2(_1219);
        _482 = (_482 * _48_m25.xxx) + vs_TEXCOORD2.xyz;
        float2 _2710;
        if (_1570 != 0)
        {
            _2710 = _482.xy;
        }
        else
        {
            _2710 = _482.xz;
        }
        _2707 = float3(_2710.x, _2707.y, _2710.y);
        float2 _2723;
        if (_1562 != 0)
        {
            _2723 = _482.zy;
        }
        else
        {
            _2723 = _2707.xz;
        }
        _1452 = float3(_2723.x, _2723.y, _1452.z);
        _1802 = _48_m0.y * _48_m27;
        _482.x = _1802 * 0.60000002384185791015625f;
        _482.y = (-_48_m0.y) * _48_m27;
        float2 _2764 = (_1452.xy * float2(float2(_48_m26, _48_m26))) + _482.xy;
        _1452 = float3(_2764.x, _2764.y, _1452.z);
        _9.x = _RuneTex.Sample(sampler_RuneTex, _1452.xy).z;
        _1452.x = _9.x + (-0.3499999940395355224609375f);
        _1452.x *= 2.2222220897674560546875f;
        _1452.x = clamp(_1452.x, 0.0f, 1.0f);
        _2707.x = (_1452.x * (-2.0f)) + 3.0f;
        _1452.x *= _1452.x;
        _1452.x *= _2707.x;
        _30.x = dot(_30, _1106);
        _30.x = clamp(_30.x, 0.0f, 1.0f);
        _2810 = dot(_23, 0.33329999446868896484375f.xxx);
        _2815 = log2(_30.x);
        _2815 *= _48_m20;
        _2815 = exp2(_2815);
        _2815 = (_2815 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
        _2810 = _2815 * _2810;
        _2707.x = _48_m0.y * _48_m22;
        _1802 = vs_TEXCOORD2.y * 0.699999988079071044921875f;
        _482.x = (_48_m0.y * _48_m22) + _1802;
        _482.x = (_2448 * 3.0f) + _482.x;
        _482.x = sin(_482.x);
        _2707.x = (_2707.x * 2.5f) + _1802;
        _2707.x = (_2448 * 3.0f) + _2707.x;
        _2707.x = sin(_2707.x);
        _2815 = (-_482.x) + _2707.x;
        _2815 = (_48_m58 * _2815) + _482.x;
        _2815 = (_48_m23 * _2815) + 1.0f;
        _30.x = (-_30.x) + 1.0f;
        _30.x = log2(_30.x);
        _30.x *= _48_m16;
        _30.x = exp2(_30.x);
        _1529 = _1161 * _48_m17.xyz;
        _1536 = _1161 * _48_m24.xyz;
        _1536 = _1452.xxx * _1536;
        _1536 *= _48_m28.xxx;
        _2508 = (_1315.x * _1315.x) + 1.0f;
        _1315.x = _48_m60 * 0.300000011920928955078125f;
        _2948 = (_48_m58 * 0.60000002384185791015625f) + _2508;
        _1536 = _2948.xxx * _1536;
        _1529 = (_1529 * float3(float3(_48_m19, _48_m19, _48_m19))) + _1536;
        _1536 = _1219.xxx * _48_m35.xyz;
        _1219 = (_2448 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _1536 = _1219.xxx * _1536;
        _1536 *= float3(float3(_48_m40, _48_m40, _48_m40));
        _1219 = (_96 * 2.0f) + 1.0f;
        _1529 = (_1536 * _1219.xxx) + _1529;
        _1536 = _1047.xxx * _48_m29.xyz;
        _1047 = (_96 * 1.5f) + _48_m58;
        _1047 += 1.0f;
        _1529 = (_1536 * _1047.xxx) + _1529;
        _1529 = _2810.xxx * _1529;
        _1529 *= _48_m18.xxx;
        _1529 = _2815.xxx * _1529;
        _2815 = (_48_m58 * 2.0f) + _48_m60;
        _2815 += 1.0f;
        _1536 = _30.xxx * _48_m15.xyz;
        _30.x = _2508 + _48_m60;
        _1536 = _30.xxx * _1536;
        _1529 = (_1529 * _2815.xxx) + _1536;
        _30.x = _96 * _48_m46;
        _2810 = (_2810 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _30.x = (_30.x * _2810) + _1315.y;
        _30 = (_48_m41.xyz * _30.xxx) + _1529;
        _3102 = (-_1161) + 1.0f.xxx;
        _1161 = (_3102 * 0.5f.xxx) + _1161;
        _30 = (_1161 * _1315.xxx) + _30;
        _30 += _58;
        _30 = (-_155) + _30;
        _155 = (vs_TEXCOORD2.www * _30) + _155;
    }
    _1452.x = vs_TEXCOORD8;
    _1452.x = clamp(_1452.x, 0.0f, 1.0f);
    _2707 = _155 + (-_48_m4.xyz);
    _1452 = (_1452.xxx * _2707) + _48_m4.xyz;
    _3152 = float4(_1452.x, _1452.y, _1452.z, _3152.w);
    _3152.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD8 = stage_input.vs_TEXCOORD8;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._3152 = _3152;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m11[4];
float4 unity_FogParams;
float4 unity_LightmapST;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m10 unity_WorldTransformParams
#define _21_m12 unity_FogParams
#define _21_m13 unity_LightmapST
#define _21_m14 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD8;
static float4 vs_TEXCOORD0;
static float2 _147;
static float2 _160;
static float4 vs_TEXCOORD2;
static float4 _178;
static float4 _184;
static float3 _229;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD7;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _229 : NORMAL;
    float4 _184 : TANGENT;
    float2 _147 : TEXCOORD0;
    float2 _160 : TEXCOORD1;
    float4 _178 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
    float3 vs_TEXCOORD7 : TEXCOORD8;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float3 _193;
static float _249;
static float3 _262;
static float3 _275;
static float3 _281;
static float4 _327;
static float3 _333;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m11[1];
    _9 = (_21_m11[0] * _45.xxxx) + _9;
    _9 = (_21_m11[2] * _45.zzzz) + _9;
    _9 = (_21_m11[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m12.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD8 = exp2(_9.x);
    float2 _157 = (_147 * _21_m14.xy) + _21_m14.zw;
    vs_TEXCOORD0 = float4(_157.x, _157.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _170 = (_160 * _21_m13.xy) + _21_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _170.x, _170.y);
    vs_TEXCOORD2 = float4(_11.xyz.x, _11.xyz.y, _11.xyz.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _178.x;
    _9.x = _184.w * _21_m10.w;
    _193 = _184.yyy * _21_m8[1].yzx;
    _193 = (_21_m8[0].yzx * _184.xxx) + _193;
    _193 = (_21_m8[2].yzx * _184.zzz) + _193;
    _45.x = dot(_193, _193);
    _45.x = rsqrt(_45.x);
    _193 *= _45.xxx;
    _45.x = dot(_229, _21_m9[0].xyz);
    _45.y = dot(_229, _21_m9[1].xyz);
    _45.z = dot(_229, _21_m9[2].xyz);
    _249 = dot(_45.xyz, _45.xyz);
    _249 = rsqrt(_249);
    _45 = _249.xxxx * _45.xyzz;
    _262 = _193 * _45.zxy;
    _262 = (_45.yzx * _193.yzx) + (-_262);
    _275 = _9.xxx * _262.xzy;
    _281.y = _275.x;
    _281.x = _193.z;
    _281.z = _45.x;
    vs_TEXCOORD3 = _281;
    _275.x = _193.y;
    _193.y = _275.z;
    _193.z = _45.y;
    vs_TEXCOORD4 = _193;
    _275.z = _45.z;
    vs_TEXCOORD5 = _275;
    vs_TEXCOORD6 = _229;
    _262.x = _45.y * _45.y;
    _262.x = (_45.x * _45.x) + (-_262.x);
    _327 = _45.yzwx * _45.xywz;
    _333.x = dot(_21_m4, _327);
    _333.y = dot(_21_m5, _327);
    _333.z = dot(_21_m6, _327);
    _262 = (_21_m7.xyz * _262.xxx) + _333;
    _45.w = 1.0f;
    _333.x = dot(_21_m1, _45);
    _333.y = dot(_21_m2, _45);
    _333.z = dot(_21_m3, _45);
    vs_TEXCOORD7 = _262 + _333;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _160 = stage_input._160;
    _178 = stage_input._178;
    _184 = stage_input._184;
    _229 = stage_input._229;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD8 = vs_TEXCOORD8;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _48_m3[4];
float4 unity_FogColor;
float _BumpScale;
float _RockEmission;
float4 _TopColor;
float4 _BottomColor;
float4 _HeightRange;
float _ShellBrightness;
float _BlockSize;
float _BlockVariation;
float _Gloss;
float _GlintStrength;
float4 _RimColor;
float _RimPower;
float4 _GlowColor;
float _GlowStrength;
float _InnerFill;
float _FacingPower;
float _Refraction;
float _PulseSpeed;
float _PulseAmount;
float4 _CoreColor;
float _CoreDepth;
float _CoreScale;
float _CoreSpeed;
float _CoreStrength;
float4 _RuneColor;
float _RuneDepth;
float _RuneCell;
float _RuneSpeed;
float _RuneDensity;
float _RuneBlink;
float4 _VeinColor;
float _VeinDepth;
float _VeinScale;
float _VeinSpeed;
float _VeinSharpness;
float _VeinStrength;
float4 _TouchColor;
float _HandRadius;
float _RippleSpeed;
float _RippleWidth;
float _RippleLife;
float _HandStrength;
float4 _CrackColor;
float _CrackScale;
float _CrackSpeed;
float _CrackReach;
float _CrackLife;
float _CrackOpen;
float _CrackGlow;
float _CrackDarken;
float _KevinActive;
float4 _KevinHands[2];
float4 _KevinRipples[4];
float _RiftAwake;
float _RiftCrack;
float _RiftFlash;
float4 _LightColor0;
void __unity_init()
{
    _48_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _48_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _48_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _48_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _48_m0 _Time
#define _48_m1 _WorldSpaceCameraPos
#define _48_m2 _WorldSpaceLightPos0
#define _48_m4 unity_FogColor
#define _48_m5 _BumpScale
#define _48_m6 _RockEmission
#define _48_m7 _TopColor
#define _48_m8 _BottomColor
#define _48_m9 _HeightRange
#define _48_m10 _ShellBrightness
#define _48_m11 _BlockSize
#define _48_m12 _BlockVariation
#define _48_m13 _Gloss
#define _48_m14 _GlintStrength
#define _48_m15 _RimColor
#define _48_m16 _RimPower
#define _48_m17 _GlowColor
#define _48_m18 _GlowStrength
#define _48_m19 _InnerFill
#define _48_m20 _FacingPower
#define _48_m21 _Refraction
#define _48_m22 _PulseSpeed
#define _48_m23 _PulseAmount
#define _48_m24 _CoreColor
#define _48_m25 _CoreDepth
#define _48_m26 _CoreScale
#define _48_m27 _CoreSpeed
#define _48_m28 _CoreStrength
#define _48_m29 _RuneColor
#define _48_m30 _RuneDepth
#define _48_m31 _RuneCell
#define _48_m32 _RuneSpeed
#define _48_m33 _RuneDensity
#define _48_m34 _RuneBlink
#define _48_m35 _VeinColor
#define _48_m36 _VeinDepth
#define _48_m37 _VeinScale
#define _48_m38 _VeinSpeed
#define _48_m39 _VeinSharpness
#define _48_m40 _VeinStrength
#define _48_m41 _TouchColor
#define _48_m42 _HandRadius
#define _48_m43 _RippleSpeed
#define _48_m44 _RippleWidth
#define _48_m45 _RippleLife
#define _48_m46 _HandStrength
#define _48_m47 _CrackColor
#define _48_m48 _CrackScale
#define _48_m49 _CrackSpeed
#define _48_m50 _CrackReach
#define _48_m51 _CrackLife
#define _48_m52 _CrackOpen
#define _48_m53 _CrackGlow
#define _48_m54 _CrackDarken
#define _48_m55 _KevinActive
#define _48_m56 _KevinHands
#define _48_m57 _KevinRipples
#define _48_m58 _RiftAwake
#define _48_m59 _RiftCrack
#define _48_m60 _RiftFlash
#define _48_m61 _LightColor0


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> _RuneTex;
SamplerState sampler_RuneTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD7;
static float4 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD6;
static float vs_TEXCOORD8;
static float4 _3152;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
    float3 vs_TEXCOORD7 : TEXCOORD8;
};

struct SPIRV_Cross_Output
{
    float4 _3152 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _30;
static float3 _58;
static float _96;
static float3 _155;
static bool _167;
static bool2 _174;
static bool _191;
static float _215;
static float4 _232;
static bool _247;
static float3 _253;
static float2 _279;
static float4 _290;
static float _321;
static bool2 _446;
static bool _469;
static float3 _482;
static float _494;
static float _521;
static float _1020;
static float _1023;
static bool _1040;
static float _1047;
static int3 _1058;
static int _1069;
static bool _1073;
static float2 _1084;
static float3 _1106;
static float _1149;
static float3 _1161;
static float2 _1198;
static float3 _1212;
static float _1219;
static float3 _1315;
static float _1339;
static float _1349;
static float4 _1357;
static float3 _1452;
static float3 _1529;
static float3 _1536;
static int _1562;
static int _1570;
static bool _1573;
static int3 _1597;
static float3 _1616;
static float3 _1623;
static float2 _1680;
static int _1770;
static float _1802;
static bool _1864;
static bool _1870;
static bool2 _1937;
static float2 _1945;
static bool _1960;
static float _1965;
static float2 _2397;
static float _2448;
static float _2508;
static float _2672;
static float3 _2707;
static float _2810;
static float _2815;
static float _2948;
static float3 _3102;

void frag_inner()
{
    __unity_init();
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _30 = (_23 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _55 = _30.xy * _48_m5.xx;
    _30 = float3(_55.x, _55.y, _30.z);
    _58.x = dot(vs_TEXCOORD3, _30);
    _58.y = dot(vs_TEXCOORD4, _30);
    _58.z = dot(vs_TEXCOORD5, _30);
    _30.x = dot(_58, _58);
    _30.x = rsqrt(_30.x);
    _30 = _30.xxx * _58;
    _23 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
    _96 = dot(_30, _48_m2.xyz);
    _96 = (_96 * 0.5f) + 0.5f;
    _96 = clamp(_96, 0.0f, 1.0f);
    _96 += (-0.3499999940395355224609375f);
    _96 *= 2.2222220897674560546875f;
    _96 = clamp(_96, 0.0f, 1.0f);
    _58.x = (_96 * (-2.0f)) + 3.0f;
    _96 *= _96;
    _96 *= _58.x;
    _58 = (_48_m61.xyz * _96.xxx) + vs_TEXCOORD7;
    _96 = (-vs_TEXCOORD2.w) + 1.0f;
    _96 *= _48_m6;
    _155 = _23 * _96.xxx;
    _155 = (_9 * _58) + _155;
    _167 = 0.5f < _48_m55;
    float4 _187 = float4(_48_m59, _48_m60, _48_m59, _48_m59);
    _174 = bool4(float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).x < _187.x, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).y < _187.y, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).z < _187.z, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).w < _187.w).xy;
    _191 = _167 || _174.x;
    _191 = _174.y || _191;
    _174.x = vs_TEXCOORD2.w < 0.9900000095367431640625f;
    _191 = _191 && _174.x;
    if (_191)
    {
        if (_167)
        {
            _215 = _48_m0.y + (-_48_m57[0].w);
            _174.x = _48_m57[0].w >= 0.001000000047497451305389404296875f;
            _174.y = _215 >= 0.0f;
            _232.x = float(_174.x);
            _232.y = float(_174.y);
            _232.x = _232.y * _232.x;
            _247 = _48_m51 >= _215;
            _253.x = float(_247);
            _232.x = _253.x * _232.x;
            _253 = vs_TEXCOORD1 + (-_48_m57[0].xyz);
            _253.x = dot(_253, _253);
            _253.x = sqrt(_253.x);
            _279.x = (_215 * _48_m49) + (-_253.x);
            float2 _300 = float2(_48_m51, _48_m50) * float2(0.550000011920928955078125f, 0.449999988079071044921875f);
            _290 = float4(_300.x, _300.y, _290.z, _290.w);
            _215 = ((-_48_m51) * 0.449999988079071044921875f) + _215;
            float2 _312 = 1.0f.xx / _290.xy;
            _290 = float4(_312.x, _312.y, _290.z, _290.w);
            _215 *= _290.x;
            _215 = clamp(_215, 0.0f, 1.0f);
            _321 = (_215 * (-2.0f)) + 3.0f;
            _215 *= _215;
            _215 = ((-_321) * _215) + 1.0f;
            _253.x = ((-_48_m50) * 0.550000011920928955078125f) + _253.x;
            _253.x = _290.y * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _321 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_321) * _253.x) + 1.0f;
            _215 *= _253.x;
            _215 = _232.x * _215;
            _232.x = _279.x + 0.20000000298023223876953125f;
            _232.x *= 2.8571426868438720703125f;
            _232.x = clamp(_232.x, 0.0f, 1.0f);
            _253.x = (_232.x * (-2.0f)) + 3.0f;
            _232.x *= _232.x;
            _232.x *= _253.x;
            _232.x = _215 * _232.x;
            _232.x = max(_232.x, 0.0f);
            _253.x = _279.x * (-_279.x);
            _253.x *= 40.0f;
            _253.x = exp2(_253.x);
            _215 *= _253.x;
            _215 = max(_215, 0.0f);
            _253.x = _48_m0.y + (-_48_m57[1].w);
            _446.x = _48_m57[1].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m51 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m57[1].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m49) + (-_321);
            _253.x = ((-_48_m51) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _521 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_521) * _253.x) + 1.0f;
            _321 = ((-_48_m50) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _521 = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_521) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _279.x = _494 * (-_494);
            _279.x *= 40.0f;
            _279.x = exp2(_279.x);
            _253.x *= _279.x;
            _215 = max(_215, _253.x);
            _253.x = _48_m0.y + (-_48_m57[2].w);
            _446.x = _48_m57[2].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m51 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m57[2].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m49) + (-_321);
            _253.x = ((-_48_m51) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _521 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_521) * _253.x) + 1.0f;
            _321 = ((-_48_m50) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _521 = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_521) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _279.x = _494 * (-_494);
            _279.x *= 40.0f;
            _279.x = exp2(_279.x);
            _253.x *= _279.x;
            _215 = max(_215, _253.x);
            _253.x = _48_m0.y + (-_48_m57[3].w);
            _446.x = _48_m57[3].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m51 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m57[3].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m49) + (-_321);
            _253.x = ((-_48_m51) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _290.x = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_290.x) * _253.x) + 1.0f;
            _321 = ((-_48_m50) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _290.x = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_290.x) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _290.x = _494 * (-_494);
            _290.x *= 40.0f;
            _290.x = exp2(_290.x);
            _290.x = _253.x * _290.x;
            _290.x = max(_215, _290.x);
            _1020 = _290.x;
            _1023 = _232.x;
        }
        else
        {
            _1020 = 0.0f;
            _1023 = 0.0f;
        }
        _96 = min(_48_m60, 1.0f);
        _96 *= 0.300000011920928955078125f;
        _96 = max(_96, _48_m59);
        _96 = max(_96, _1023);
        _1040 = 0.00200000009499490261077880859375f < _96;
        if (_1040)
        {
            _1047 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
            _1058.x = int((_1047 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
            _1069 = ~_1058.x;
            _1073 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
            _1069 = _1073 ? _1069 : 0;
            bool2 _1093 = (_1069 != 0).xx;
            _1084 = float2(_1093.x ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).x : float2(0.709999978542327880859375f, 0.189999997615814208984375f).x, _1093.y ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).y : float2(0.709999978542327880859375f, 0.189999997615814208984375f).y);
            float2 _1099;
            if (_1058.x != 0)
            {
                _1099 = 0.0f.xx;
            }
            else
            {
                _1099 = _1084;
            }
            _1084 = _1099;
            float2 _1109;
            if (_1069 != 0)
            {
                _1109 = vs_TEXCOORD2.xy;
            }
            else
            {
                _1109 = vs_TEXCOORD2.xz;
            }
            _1106 = float3(_1109.x, _1109.y, _1106.z);
            float2 _1123;
            if (_1058.x != 0)
            {
                _1123 = vs_TEXCOORD2.zy;
            }
            else
            {
                _1123 = _1106.xy;
            }
            _482 = float3(_1123.x, _1123.y, _482.z);
            float2 _1140 = _482.xy / _48_m48.xx;
            _482 = float3(_1140.x, _1140.y, _482.z);
            float2 _1146 = _1084 + _482.xy;
            _482 = float3(_1146.x, _1146.y, _482.z);
            _1149 = _RuneTex.Sample(sampler_RuneTex, _482.xy).w;
            _1047 = _96 * _48_m53;
            float2 _1172 = ((-_48_m52.xx) * _96.xx) + float2(1.0f, 0.7799999713897705078125f);
            _1161 = float3(_1172.x, _1172.y, _1161.z);
            float2 _1180 = _1149.xx + (-_1161.xy);
            _1161 = float3(_1180.x, _1180.y, _1161.z);
            float2 _1188 = _1161.xy * float2(12.5f, 4.5454540252685546875f);
            _1161 = float3(_1188.x, _1188.y, _1161.z);
            float2 _1195 = clamp(_1161.xy, 0.0f.xx, 1.0f.xx);
            _1161 = float3(_1195.x, _1195.y, _1161.z);
            _1198 = (_1161.xy * (-2.0f).xx) + 3.0f.xx;
            float2 _1209 = _1161.xy * _1161.xy;
            _1161 = float3(_1209.x, _1209.y, _1161.z);
            float2 _1216 = _1161.xy * _1198;
            _1212 = float3(_1216.x, _1212.y, _1216.y);
            _1219 = ((-_1198.x) * _1161.x) + 1.0f;
            _1219 *= _1212.z;
            _96 *= _1219;
            _1219 = (_1212.x * 0.60000002384185791015625f) + _96;
            _1219 = clamp(_1219, 0.0f, 1.0f);
            _1219 = ((-_1219) * _48_m54) + 1.0f;
            _1161.x = _1149 * 23.0f;
            _482.x = (_48_m0.y * 11.0f) + _1161.x;
            _482.x = sin(_482.x);
            _482.x = (_482.x * 0.25f) + 0.75f;
            _1161.x = _1020 * 3.0f;
            _1047 = (_1047 * _482.x) + _1161.x;
            _96 *= _48_m53;
            _96 *= 0.07999999821186065673828125f;
            _96 = (_1212.x * _1047) + _96;
            _1161 = _96.xxx * _48_m47.xyz;
            _96 = _48_m60 + 1.0f;
            _1161 = _96.xxx * _1161;
            _1161 = (_155 * _1219.xxx) + _1161;
            _1315 = _155 + (-_1161);
            _155 = (vs_TEXCOORD2.www * _1315) + _1161;
        }
    }
    _1040 = 0.00999999977648258209228515625f < vs_TEXCOORD2.w;
    if (_1040)
    {
        _482 = (-vs_TEXCOORD1) + _48_m1;
        _1339 = dot(_482, _482);
        _1339 = rsqrt(_1339);
        _1106 = _1339.xxx * _482;
        _1349 = vs_TEXCOORD2.y + (-_48_m9.x);
        _1357.x = (-_48_m9.x) + _48_m9.y;
        _1357.x = max(_1357.x, 0.001000000047497451305389404296875f);
        _1349 /= _1357.x;
        _1349 = clamp(_1349, 0.0f, 1.0f);
        _1161 = _48_m7.xyz + (-_48_m8.xyz);
        _1161 = (_1349.xxx * _1161) + _48_m8.xyz;
        _1315 = (_482 * _1339.xxx) + _48_m2.xyz;
        _96 = dot(_1315, _1315);
        _96 = rsqrt(_96);
        _1315 = _96.xxx * _1315;
        _96 = dot(_30, _1315);
        _96 = clamp(_96, 0.0f, 1.0f);
        _96 = log2(_96);
        _96 *= _48_m13;
        _96 = exp2(_96);
        _96 += (-0.60000002384185791015625f);
        _96 *= 10.000003814697265625f;
        _96 = clamp(_96, 0.0f, 1.0f);
        _1047 = (_96 * (-2.0f)) + 3.0f;
        _96 *= _96;
        _96 *= _1047;
        _96 *= _48_m14;
        _1047 = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
        _1452 = vs_TEXCOORD2.xyz / _48_m11.xxx;
        _1452 = floor(_1452);
        _1452 *= float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
        _1452 = frac(_1452);
        _482 = _1452.yxz + 33.3300018310546875f.xxx;
        _482.x = dot(_1452, _482);
        _1452 += _482.xxx;
        _1452.x = _1452.y + _1452.x;
        _1452.x = _1452.z * _1452.x;
        _1452.x = frac(_1452.x);
        _1047 *= 2.2000000476837158203125f;
        _1315 = _1047.xxx * _1161;
        _1047 = _1452.x + (-0.5f);
        _1047 = dot(_1047.xx, _48_m12.xx);
        _1047 += 1.0f;
        _1315 = _1047.xxx * _1315;
        _1315 *= _48_m10.xxx;
        _1529 = _96.xxx * _48_m61.xyz;
        _1536 = (_1161 * 1.5f.xxx) + (-1.0f).xxx;
        _1536 = (_1536 * 0.5f.xxx) + 1.0f.xxx;
        _1529 *= _1536;
        _58 = (_1315 * _58) + _1529;
        _96 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
        _1562 = int((_96 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
        _1570 = ~_1562;
        _1573 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
        _1570 = _1573 ? _1570 : 0;
        _1058 = int3(uint3(bool4(0.0f.xxxx.x < vs_TEXCOORD6.xzyx.x, 0.0f.xxxx.y < vs_TEXCOORD6.xzyx.y, 0.0f.xxxx.z < vs_TEXCOORD6.xzyx.z, 0.0f.xxxx.w < vs_TEXCOORD6.xzyx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1597 = int3(uint3(bool4(vs_TEXCOORD6.xzyx.x < 0.0f.xxxx.x, vs_TEXCOORD6.xzyx.y < 0.0f.xxxx.y, vs_TEXCOORD6.xzyx.z < 0.0f.xxxx.z, vs_TEXCOORD6.xzyx.w < 0.0f.xxxx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1058 = (-_1058) + _1597;
        _1357.x = float(_1058.x);
        _1357.y = 0.0f;
        _1357.z = 0.0f;
        _1616.x = 0.0f;
        _1616.y = 0.0f;
        _1616.z = float(_1058.y);
        _1623.x = 0.0f;
        _1623.z = 0.0f;
        _1623.y = float(_1058.z);
        float3 _1633;
        if (_1570 != 0)
        {
            _1633 = _1616;
        }
        else
        {
            _1633 = _1623;
        }
        _482 = _1633;
        float3 _1642;
        if (_1562 != 0)
        {
            _1642 = _1357.xyz;
        }
        else
        {
            _1642 = _482;
        }
        _482 = _1642;
        float3 _1655 = _1106.yyy * _48_m3[1].xyz;
        _1357 = float4(_1655.x, _1655.y, _1655.z, _1357.w);
        float3 _1666 = (_48_m3[0].xyz * _1106.xxx) + _1357.xyz;
        _1357 = float4(_1666.x, _1666.y, _1666.z, _1357.w);
        float3 _1677 = (_48_m3[2].xyz * _1106.zzz) + _1357.xyz;
        _1357 = float4(_1677.x, _1677.y, _1677.z, _1357.w);
        _1680.x = dot(_1357.xyz, _1357.xyz);
        _1680.x = rsqrt(_1680.x);
        float3 _1695 = _1680.xxx * _1357.xyz;
        _1357 = float4(_1695.x, _1695.y, _1695.z, _1357.w);
        _1616 = _30.yyy * _48_m3[1].xyz;
        _1616 = (_48_m3[0].xyz * _30.xxx) + _1616;
        _1616 = (_48_m3[2].xyz * _30.zzz) + _1616;
        _1680.x = dot(_1616, _1616);
        _1680.x = rsqrt(_1680.x);
        _482.x = dot(_1357.xyz, _482);
        _482.x = max(abs(_482.x), 0.300000011920928955078125f);
        _482 = (-_1357.xyz) / _482.xxx;
        float3 _1750 = (_1616 * _1680.xxx) + (-vs_TEXCOORD6);
        _1357 = float4(_1750.x, _1750.y, _1750.z, _1357.w);
        _482 = (_1357.xyz * float3(float3(_48_m21, _48_m21, _48_m21))) + _482;
        _1770 = int(uint(_1570) | uint(_1562));
        _1339 = _48_m0.y * _48_m32;
        _1680.x = asfloat(uint(_1770) & asuint(_1339));
        if (_167)
        {
            float3 _1799 = vs_TEXCOORD1 + (-_48_m56[0].xyz);
            _1357 = float4(_1799.x, _1799.y, _1799.z, _1357.w);
            _1802 = dot(_1357.xyz, _1357.xyz);
            _1802 = sqrt(_1802);
            _1802 /= _48_m42;
            _1802 = (-_1802) + 1.0f;
            _1802 = clamp(_1802, 0.0f, 1.0f);
            _1802 *= _48_m56[0].w;
            _1802 = max(_1802, 0.0f);
            float3 _1831 = vs_TEXCOORD1 + (-_48_m56[1].xyz);
            _1357 = float4(_1831.x, _1831.y, _1831.z, _1357.w);
            _1339 = dot(_1357.xyz, _1357.xyz);
            _1339 = sqrt(_1339);
            _1339 /= _48_m42;
            _1339 = (-_1339) + 1.0f;
            _1339 = clamp(_1339, 0.0f, 1.0f);
            _1339 *= _48_m56[1].w;
            _1357.x = max(_1802, _1339);
            _1802 = _48_m0.y + (-_48_m57[0].w);
            _1864 = _48_m57[0].w >= 0.001000000047497451305389404296875f;
            _1339 = float(_1864);
            _1870 = _1802 >= 0.0f;
            _1349 = float(_1870);
            _1339 *= _1349;
            _1870 = _48_m45 >= _1802;
            _1349 = float(_1870);
            _1339 *= _1349;
            _1616 = vs_TEXCOORD1 + (-_48_m57[0].xyz);
            _1349 = dot(_1616, _1616);
            _1349 = sqrt(_1349);
            _1349 = ((-_1802) * _48_m43) + _1349;
            _1349 /= _48_m44;
            _1349 *= (-_1349);
            _1349 *= 1.44270002841949462890625f;
            _1349 = exp2(_1349);
            _1802 /= _48_m45;
            _1802 = (-_1802) + 1.0f;
            _1802 *= _1349;
            _1349 = _48_m0.y + (-_48_m57[1].w);
            _1937.x = _48_m57[1].w >= 0.001000000047497451305389404296875f;
            _1937.y = _1349 >= 0.0f;
            _1945.x = float(_1937.x);
            _1945.y = float(_1937.y);
            _1945.x = _1945.y * _1945.x;
            _1960 = _48_m45 >= _1349;
            _1965 = float(_1960);
            _1945.x = _1965 * _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m57[1].xyz);
            _1965 = dot(_1616, _1616);
            _1965 = sqrt(_1965);
            _1965 = ((-_1349) * _48_m43) + _1965;
            _1965 /= _48_m44;
            _1965 *= (-_1965);
            _1965 *= 1.44270002841949462890625f;
            _1965 = exp2(_1965);
            _1349 /= _48_m45;
            _1349 = (-_1349) + 1.0f;
            _1349 *= _1965;
            _1349 = _1945.x * _1349;
            _1802 = (_1802 * _1339) + _1349;
            _1339 = _48_m0.y + (-_48_m57[2].w);
            _1870 = _48_m57[2].w >= 0.001000000047497451305389404296875f;
            _1349 = float(_1870);
            _1937.x = _1339 >= 0.0f;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1937.x = _48_m45 >= _1339;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m57[2].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_1339) * _48_m43) + _1945.x;
            _1945.x /= _48_m44;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _1339 /= _48_m45;
            _1339 = (-_1339) + 1.0f;
            _1339 *= _1945.x;
            _1802 = (_1339 * _1349) + _1802;
            _1339 = _48_m0.y + (-_48_m57[3].w);
            _1870 = _48_m57[3].w >= 0.001000000047497451305389404296875f;
            _1349 = float(_1870);
            _1937.x = _1339 >= 0.0f;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1937.x = _48_m45 >= _1339;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m57[3].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_1339) * _48_m43) + _1945.x;
            _1945.x /= _48_m44;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _1339 /= _48_m45;
            _1339 = (-_1339) + 1.0f;
            _1339 *= _1945.x;
            _1357.y = (_1339 * _1349) + _1802;
            _1315 = float3(_1357.xy.x, _1357.xy.y, _1315.z);
        }
        else
        {
            _1315.x = 0.0f;
            _1315.y = 0.0f;
        }
        _96 = _1315.x * _1315.x;
        float3 _2233 = (_482 * _48_m30.xxx) + vs_TEXCOORD2.xyz;
        _1357 = float4(_2233.x, _2233.y, _2233.z, _1357.w);
        float2 _2238;
        if (_1570 != 0)
        {
            _2238 = _1357.xy;
        }
        else
        {
            _2238 = _1357.xz;
        }
        _1357 = float4(_2238.x, _1357.y, _1357.z, _2238.y);
        float2 _2251;
        if (_1562 != 0)
        {
            _2251 = _1357.zy;
        }
        else
        {
            _2251 = _1357.xw;
        }
        _1357 = float4(_2251.x, _2251.y, _1357.z, _1357.w);
        _1357.z = (-_1680.x) + _1357.y;
        _1680 = _1357.xz / float2(float2(_48_m31, _48_m31));
        _232 = floor(_1680.xyxy);
        _1339 = (_1570 != 0) ? 37.0f : 74.0f;
        _1339 = (_1562 != 0) ? 0.0f : _1339;
        _232 += _1339.xxxx;
        float2 _2302 = _232.zw * float2(123.339996337890625f, 456.209991455078125f);
        _1357 = float4(_2302.x, _2302.y, _1357.z, _1357.w);
        float2 _2307 = frac(_1357.xy);
        _1357 = float4(_2307.x, _2307.y, _1357.z, _1357.w);
        _1945 = _1357.xy + 45.31999969482421875f.xx;
        _1339 = dot(_1357.xy, _1945);
        float2 _2323 = _1339.xx + _1357.xy;
        _1357 = float4(_2323.x, _2323.y, _1357.z, _1357.w);
        _1339 = _1357.y * _1357.x;
        _1339 = frac(_1339);
        _232 += float4(17.3099994659423828125f, 17.3099994659423828125f, 5.730000019073486328125f, 5.730000019073486328125f);
        _232 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
        _232 = frac(_232);
        _290 = _232 + 45.31999969482421875f.xxxx;
        _1349 = dot(_232.xy, _290.xy);
        float2 _2355 = _232.xy + _1349.xx;
        _1357 = float4(_2355.x, _2355.y, _1357.z, _1357.w);
        _1349 = _1357.y * _1357.x;
        _1349 = frac(_1349);
        _1357.x = dot(_232.zw, _290.zw);
        float2 _2375 = _232.zw + _1357.xx;
        _1357 = float4(_2375.x, _2375.y, _1357.z, _1357.w);
        _1357.x = _1357.y * _1357.x;
        _1357.x = frac(_1357.x);
        _1529 = _1339.xxx * float3(16.0f, 13.69999980926513671875f, 40.0f);
        _1047 = floor(_1529.x);
        _2397 = frac(_1680);
        _1339 = _1047 * 0.25f;
        _1960 = _1339 >= (-_1339);
        _1616.x = frac(_1339);
        float _2411;
        if (_1960)
        {
            _2411 = _1616.x;
        }
        else
        {
            _2411 = -_1616.x;
        }
        _1965 = _2411;
        _1616.x = _1965 * 4.0f;
        _1616.y = floor(_1339);
        _2397 += _1616.xy;
        _2397 *= 0.25f.xx;
        float2 _2436 = ddx_coarse(_1680);
        _1616 = float3(_2436.x, _2436.y, _1616.z);
        float2 _2441 = _1616.xy * 0.25f.xx;
        _1616 = float3(_2441.x, _2441.y, _1616.z);
        _1680 = ddy_coarse(_1680);
        _1680 *= 0.25f.xx;
        _2448 = _RuneTex.SampleGrad(sampler_RuneTex, _2397, float4(_1616.xyxx).xy, float4(_1680.xyxx).xy).x;
        _1802 = _48_m0.y * _48_m34;
        _1047 = (_1349 * 0.800000011920928955078125f) + 0.60000002384185791015625f;
        _1802 = (_1802 * _1047) + _1529.y;
        _1802 = frac(_1802);
        _1047 = _1802 * 12.5f;
        _1047 = min(_1047, 1.0f);
        _1219 = (_1047 * (-2.0f)) + 3.0f;
        _1047 *= _1047;
        _1047 *= _1219;
        _1219 = _1802 + (-0.550000011920928955078125f);
        _1219 *= (-4.999999523162841796875f);
        _1219 = clamp(_1219, 0.0f, 1.0f);
        _2508 = (_1219 * (-2.0f)) + 3.0f;
        _1219 *= _1219;
        _1219 *= _2508;
        _1047 *= _1219;
        _1802 = (_48_m0.y * 23.0f) + _1529.z;
        _1802 = sin(_1802);
        _1802 = (_1802 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
        _1802 *= _1047;
        _1047 = (-_48_m33) + 1.0f;
        _1047 *= _48_m58;
        _1047 = (_1047 * 0.699999988079071044921875f) + _48_m33;
        _1864 = _1047 >= _1357.x;
        _1047 = float(_1864);
        _1047 = _1802 * _1047;
        _1219 = _1315.x + (-0.0500000007450580596923828125f);
        _1219 *= 1.53846156597137451171875f;
        _1219 = clamp(_1219, 0.0f, 1.0f);
        _2508 = (_1219 * (-2.0f)) + 3.0f;
        _1219 *= _1219;
        _1219 *= _2508;
        _1047 = max(_1047, _1219);
        _1047 = _2448 * _1047;
        float3 _2594 = (_482 * _48_m36.xxx) + vs_TEXCOORD2.xyz;
        _1357 = float4(_2594.x, _2594.y, _2594.z, _1357.w);
        float2 _2599;
        if (_1570 != 0)
        {
            _2599 = _1357.xy;
        }
        else
        {
            _2599 = _1357.xz;
        }
        _1680 = _2599;
        float2 _2610;
        if (_1562 != 0)
        {
            _2610 = _1357.zy;
        }
        else
        {
            _2610 = _1680;
        }
        _1680 = _2610;
        float2 _2628 = _1680 * float2(float2(_48_m37, _48_m37));
        _1357 = float4(_2628.x, _2628.y, _1357.z, _1357.w);
        _1339 = _48_m0.y * _48_m38;
        _232 = _1339.xxxx * float4(0.12999999523162841796875f, 0.310000002384185791015625f, -0.20999999344348907470703125f, 0.17000000178813934326171875f);
        _1680 = (_1680 * float2(float2(_48_m37, _48_m37))) + _232.xy;
        _2448 = _RuneTex.Sample(sampler_RuneTex, _1680).y;
        float2 _2669 = (_1357.xy * 1.37000000476837158203125f.xx) + _232.zw;
        _1357 = float4(_2669.x, _2669.y, _1357.z, _1357.w);
        _2672 = _RuneTex.Sample(sampler_RuneTex, _1357.xy).y;
        _1219 = (-_2672) + _2448;
        _1219 = ((-abs(_1219)) * 4.0f) + 1.0f;
        _1219 = max(_1219, 0.0f);
        _1219 = log2(_1219);
        _1219 *= _48_m39;
        _1219 = exp2(_1219);
        _482 = (_482 * _48_m25.xxx) + vs_TEXCOORD2.xyz;
        float2 _2710;
        if (_1570 != 0)
        {
            _2710 = _482.xy;
        }
        else
        {
            _2710 = _482.xz;
        }
        _2707 = float3(_2710.x, _2707.y, _2710.y);
        float2 _2723;
        if (_1562 != 0)
        {
            _2723 = _482.zy;
        }
        else
        {
            _2723 = _2707.xz;
        }
        _1452 = float3(_2723.x, _2723.y, _1452.z);
        _1802 = _48_m0.y * _48_m27;
        _482.x = _1802 * 0.60000002384185791015625f;
        _482.y = (-_48_m0.y) * _48_m27;
        float2 _2764 = (_1452.xy * float2(float2(_48_m26, _48_m26))) + _482.xy;
        _1452 = float3(_2764.x, _2764.y, _1452.z);
        _9.x = _RuneTex.Sample(sampler_RuneTex, _1452.xy).z;
        _1452.x = _9.x + (-0.3499999940395355224609375f);
        _1452.x *= 2.2222220897674560546875f;
        _1452.x = clamp(_1452.x, 0.0f, 1.0f);
        _2707.x = (_1452.x * (-2.0f)) + 3.0f;
        _1452.x *= _1452.x;
        _1452.x *= _2707.x;
        _30.x = dot(_30, _1106);
        _30.x = clamp(_30.x, 0.0f, 1.0f);
        _2810 = dot(_23, 0.33329999446868896484375f.xxx);
        _2815 = log2(_30.x);
        _2815 *= _48_m20;
        _2815 = exp2(_2815);
        _2815 = (_2815 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
        _2810 = _2815 * _2810;
        _2707.x = _48_m0.y * _48_m22;
        _1802 = vs_TEXCOORD2.y * 0.699999988079071044921875f;
        _482.x = (_48_m0.y * _48_m22) + _1802;
        _482.x = (_2448 * 3.0f) + _482.x;
        _482.x = sin(_482.x);
        _2707.x = (_2707.x * 2.5f) + _1802;
        _2707.x = (_2448 * 3.0f) + _2707.x;
        _2707.x = sin(_2707.x);
        _2815 = (-_482.x) + _2707.x;
        _2815 = (_48_m58 * _2815) + _482.x;
        _2815 = (_48_m23 * _2815) + 1.0f;
        _30.x = (-_30.x) + 1.0f;
        _30.x = log2(_30.x);
        _30.x *= _48_m16;
        _30.x = exp2(_30.x);
        _1529 = _1161 * _48_m17.xyz;
        _1536 = _1161 * _48_m24.xyz;
        _1536 = _1452.xxx * _1536;
        _1536 *= _48_m28.xxx;
        _2508 = (_1315.x * _1315.x) + 1.0f;
        _1315.x = _48_m60 * 0.300000011920928955078125f;
        _2948 = (_48_m58 * 0.60000002384185791015625f) + _2508;
        _1536 = _2948.xxx * _1536;
        _1529 = (_1529 * float3(float3(_48_m19, _48_m19, _48_m19))) + _1536;
        _1536 = _1219.xxx * _48_m35.xyz;
        _1219 = (_2448 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _1536 = _1219.xxx * _1536;
        _1536 *= float3(float3(_48_m40, _48_m40, _48_m40));
        _1219 = (_96 * 2.0f) + 1.0f;
        _1529 = (_1536 * _1219.xxx) + _1529;
        _1536 = _1047.xxx * _48_m29.xyz;
        _1047 = (_96 * 1.5f) + _48_m58;
        _1047 += 1.0f;
        _1529 = (_1536 * _1047.xxx) + _1529;
        _1529 = _2810.xxx * _1529;
        _1529 *= _48_m18.xxx;
        _1529 = _2815.xxx * _1529;
        _2815 = (_48_m58 * 2.0f) + _48_m60;
        _2815 += 1.0f;
        _1536 = _30.xxx * _48_m15.xyz;
        _30.x = _2508 + _48_m60;
        _1536 = _30.xxx * _1536;
        _1529 = (_1529 * _2815.xxx) + _1536;
        _30.x = _96 * _48_m46;
        _2810 = (_2810 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _30.x = (_30.x * _2810) + _1315.y;
        _30 = (_48_m41.xyz * _30.xxx) + _1529;
        _3102 = (-_1161) + 1.0f.xxx;
        _1161 = (_3102 * 0.5f.xxx) + _1161;
        _30 = (_1161 * _1315.xxx) + _30;
        _30 += _58;
        _30 = (-_155) + _30;
        _155 = (vs_TEXCOORD2.www * _30) + _155;
    }
    _1452.x = vs_TEXCOORD8;
    _1452.x = clamp(_1452.x, 0.0f, 1.0f);
    _2707 = _155 + (-_48_m4.xyz);
    _1452 = (_1452.xxx * _2707) + _48_m4.xyz;
    _3152 = float4(_1452.x, _1452.y, _1452.z, _3152.w);
    _3152.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD8 = stage_input.vs_TEXCOORD8;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._3152 = _3152;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m11[4];
float4 unity_FogParams;
float4 unity_LightmapST;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m10 unity_WorldTransformParams
#define _21_m12 unity_FogParams
#define _21_m13 unity_LightmapST
#define _21_m14 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD8;
static float4 vs_TEXCOORD0;
static float2 _140;
static float2 _153;
static float4 vs_TEXCOORD2;
static float4 _171;
static float4 _176;
static float3 _221;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD7;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _221 : NORMAL;
    float4 _176 : TANGENT;
    float2 _140 : TEXCOORD0;
    float2 _153 : TEXCOORD1;
    float4 _171 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
    float3 vs_TEXCOORD7 : TEXCOORD8;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float3 _185;
static float _241;
static float3 _254;
static float3 _267;
static float3 _273;
static float4 _319;
static float3 _325;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m11[1];
    _9 = (_21_m11[0] * _45.xxxx) + _9;
    _9 = (_21_m11[2] * _45.zzzz) + _9;
    _9 = (_21_m11[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD8 = (_9.x * _21_m12.z) + _21_m12.w;
    float2 _150 = (_140 * _21_m14.xy) + _21_m14.zw;
    vs_TEXCOORD0 = float4(_150.x, _150.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _163 = (_153 * _21_m13.xy) + _21_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _163.x, _163.y);
    vs_TEXCOORD2 = float4(_11.xyz.x, _11.xyz.y, _11.xyz.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _171.x;
    _9.x = _176.w * _21_m10.w;
    _185 = _176.yyy * _21_m8[1].yzx;
    _185 = (_21_m8[0].yzx * _176.xxx) + _185;
    _185 = (_21_m8[2].yzx * _176.zzz) + _185;
    _45.x = dot(_185, _185);
    _45.x = rsqrt(_45.x);
    _185 *= _45.xxx;
    _45.x = dot(_221, _21_m9[0].xyz);
    _45.y = dot(_221, _21_m9[1].xyz);
    _45.z = dot(_221, _21_m9[2].xyz);
    _241 = dot(_45.xyz, _45.xyz);
    _241 = rsqrt(_241);
    _45 = _241.xxxx * _45.xyzz;
    _254 = _185 * _45.zxy;
    _254 = (_45.yzx * _185.yzx) + (-_254);
    _267 = _9.xxx * _254.xzy;
    _273.y = _267.x;
    _273.x = _185.z;
    _273.z = _45.x;
    vs_TEXCOORD3 = _273;
    _267.x = _185.y;
    _185.y = _267.z;
    _185.z = _45.y;
    vs_TEXCOORD4 = _185;
    _267.z = _45.z;
    vs_TEXCOORD5 = _267;
    vs_TEXCOORD6 = _221;
    _254.x = _45.y * _45.y;
    _254.x = (_45.x * _45.x) + (-_254.x);
    _319 = _45.yzwx * _45.xywz;
    _325.x = dot(_21_m4, _319);
    _325.y = dot(_21_m5, _319);
    _325.z = dot(_21_m6, _319);
    _254 = (_21_m7.xyz * _254.xxx) + _325;
    _45.w = 1.0f;
    _325.x = dot(_21_m1, _45);
    _325.y = dot(_21_m2, _45);
    _325.z = dot(_21_m3, _45);
    vs_TEXCOORD7 = _254 + _325;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _153 = stage_input._153;
    _171 = stage_input._171;
    _176 = stage_input._176;
    _221 = stage_input._221;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD8 = vs_TEXCOORD8;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _48_m3[4];
float4 unity_FogColor;
float _BumpScale;
float _RockEmission;
float4 _TopColor;
float4 _BottomColor;
float4 _HeightRange;
float _ShellBrightness;
float _BlockSize;
float _BlockVariation;
float _Gloss;
float _GlintStrength;
float4 _RimColor;
float _RimPower;
float4 _GlowColor;
float _GlowStrength;
float _InnerFill;
float _FacingPower;
float _Refraction;
float _PulseSpeed;
float _PulseAmount;
float4 _CoreColor;
float _CoreDepth;
float _CoreScale;
float _CoreSpeed;
float _CoreStrength;
float4 _RuneColor;
float _RuneDepth;
float _RuneCell;
float _RuneSpeed;
float _RuneDensity;
float _RuneBlink;
float4 _VeinColor;
float _VeinDepth;
float _VeinScale;
float _VeinSpeed;
float _VeinSharpness;
float _VeinStrength;
float4 _TouchColor;
float _HandRadius;
float _RippleSpeed;
float _RippleWidth;
float _RippleLife;
float _HandStrength;
float4 _CrackColor;
float _CrackScale;
float _CrackSpeed;
float _CrackReach;
float _CrackLife;
float _CrackOpen;
float _CrackGlow;
float _CrackDarken;
float _KevinActive;
float4 _KevinHands[2];
float4 _KevinRipples[4];
float _RiftAwake;
float _RiftCrack;
float _RiftFlash;
float4 _LightColor0;
void __unity_init()
{
    _48_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _48_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _48_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _48_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _48_m0 _Time
#define _48_m1 _WorldSpaceCameraPos
#define _48_m2 _WorldSpaceLightPos0
#define _48_m4 unity_FogColor
#define _48_m5 _BumpScale
#define _48_m6 _RockEmission
#define _48_m7 _TopColor
#define _48_m8 _BottomColor
#define _48_m9 _HeightRange
#define _48_m10 _ShellBrightness
#define _48_m11 _BlockSize
#define _48_m12 _BlockVariation
#define _48_m13 _Gloss
#define _48_m14 _GlintStrength
#define _48_m15 _RimColor
#define _48_m16 _RimPower
#define _48_m17 _GlowColor
#define _48_m18 _GlowStrength
#define _48_m19 _InnerFill
#define _48_m20 _FacingPower
#define _48_m21 _Refraction
#define _48_m22 _PulseSpeed
#define _48_m23 _PulseAmount
#define _48_m24 _CoreColor
#define _48_m25 _CoreDepth
#define _48_m26 _CoreScale
#define _48_m27 _CoreSpeed
#define _48_m28 _CoreStrength
#define _48_m29 _RuneColor
#define _48_m30 _RuneDepth
#define _48_m31 _RuneCell
#define _48_m32 _RuneSpeed
#define _48_m33 _RuneDensity
#define _48_m34 _RuneBlink
#define _48_m35 _VeinColor
#define _48_m36 _VeinDepth
#define _48_m37 _VeinScale
#define _48_m38 _VeinSpeed
#define _48_m39 _VeinSharpness
#define _48_m40 _VeinStrength
#define _48_m41 _TouchColor
#define _48_m42 _HandRadius
#define _48_m43 _RippleSpeed
#define _48_m44 _RippleWidth
#define _48_m45 _RippleLife
#define _48_m46 _HandStrength
#define _48_m47 _CrackColor
#define _48_m48 _CrackScale
#define _48_m49 _CrackSpeed
#define _48_m50 _CrackReach
#define _48_m51 _CrackLife
#define _48_m52 _CrackOpen
#define _48_m53 _CrackGlow
#define _48_m54 _CrackDarken
#define _48_m55 _KevinActive
#define _48_m56 _KevinHands
#define _48_m57 _KevinRipples
#define _48_m58 _RiftAwake
#define _48_m59 _RiftCrack
#define _48_m60 _RiftFlash
#define _48_m61 _LightColor0


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> _RuneTex;
SamplerState sampler_RuneTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD7;
static float4 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD6;
static float vs_TEXCOORD8;
static float4 _3152;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD8 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float3 vs_TEXCOORD6 : TEXCOORD7;
    float3 vs_TEXCOORD7 : TEXCOORD8;
};

struct SPIRV_Cross_Output
{
    float4 _3152 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _30;
static float3 _58;
static float _96;
static float3 _155;
static bool _167;
static bool2 _174;
static bool _191;
static float _215;
static float4 _232;
static bool _247;
static float3 _253;
static float2 _279;
static float4 _290;
static float _321;
static bool2 _446;
static bool _469;
static float3 _482;
static float _494;
static float _521;
static float _1020;
static float _1023;
static bool _1040;
static float _1047;
static int3 _1058;
static int _1069;
static bool _1073;
static float2 _1084;
static float3 _1106;
static float _1149;
static float3 _1161;
static float2 _1198;
static float3 _1212;
static float _1219;
static float3 _1315;
static float _1339;
static float _1349;
static float4 _1357;
static float3 _1452;
static float3 _1529;
static float3 _1536;
static int _1562;
static int _1570;
static bool _1573;
static int3 _1597;
static float3 _1616;
static float3 _1623;
static float2 _1680;
static int _1770;
static float _1802;
static bool _1864;
static bool _1870;
static bool2 _1937;
static float2 _1945;
static bool _1960;
static float _1965;
static float2 _2397;
static float _2448;
static float _2508;
static float _2672;
static float3 _2707;
static float _2810;
static float _2815;
static float _2948;
static float3 _3102;

void frag_inner()
{
    __unity_init();
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _30 = (_23 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _55 = _30.xy * _48_m5.xx;
    _30 = float3(_55.x, _55.y, _30.z);
    _58.x = dot(vs_TEXCOORD3, _30);
    _58.y = dot(vs_TEXCOORD4, _30);
    _58.z = dot(vs_TEXCOORD5, _30);
    _30.x = dot(_58, _58);
    _30.x = rsqrt(_30.x);
    _30 = _30.xxx * _58;
    _23 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
    _96 = dot(_30, _48_m2.xyz);
    _96 = (_96 * 0.5f) + 0.5f;
    _96 = clamp(_96, 0.0f, 1.0f);
    _96 += (-0.3499999940395355224609375f);
    _96 *= 2.2222220897674560546875f;
    _96 = clamp(_96, 0.0f, 1.0f);
    _58.x = (_96 * (-2.0f)) + 3.0f;
    _96 *= _96;
    _96 *= _58.x;
    _58 = (_48_m61.xyz * _96.xxx) + vs_TEXCOORD7;
    _96 = (-vs_TEXCOORD2.w) + 1.0f;
    _96 *= _48_m6;
    _155 = _23 * _96.xxx;
    _155 = (_9 * _58) + _155;
    _167 = 0.5f < _48_m55;
    float4 _187 = float4(_48_m59, _48_m60, _48_m59, _48_m59);
    _174 = bool4(float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).x < _187.x, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).y < _187.y, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).z < _187.z, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).w < _187.w).xy;
    _191 = _167 || _174.x;
    _191 = _174.y || _191;
    _174.x = vs_TEXCOORD2.w < 0.9900000095367431640625f;
    _191 = _191 && _174.x;
    if (_191)
    {
        if (_167)
        {
            _215 = _48_m0.y + (-_48_m57[0].w);
            _174.x = _48_m57[0].w >= 0.001000000047497451305389404296875f;
            _174.y = _215 >= 0.0f;
            _232.x = float(_174.x);
            _232.y = float(_174.y);
            _232.x = _232.y * _232.x;
            _247 = _48_m51 >= _215;
            _253.x = float(_247);
            _232.x = _253.x * _232.x;
            _253 = vs_TEXCOORD1 + (-_48_m57[0].xyz);
            _253.x = dot(_253, _253);
            _253.x = sqrt(_253.x);
            _279.x = (_215 * _48_m49) + (-_253.x);
            float2 _300 = float2(_48_m51, _48_m50) * float2(0.550000011920928955078125f, 0.449999988079071044921875f);
            _290 = float4(_300.x, _300.y, _290.z, _290.w);
            _215 = ((-_48_m51) * 0.449999988079071044921875f) + _215;
            float2 _312 = 1.0f.xx / _290.xy;
            _290 = float4(_312.x, _312.y, _290.z, _290.w);
            _215 *= _290.x;
            _215 = clamp(_215, 0.0f, 1.0f);
            _321 = (_215 * (-2.0f)) + 3.0f;
            _215 *= _215;
            _215 = ((-_321) * _215) + 1.0f;
            _253.x = ((-_48_m50) * 0.550000011920928955078125f) + _253.x;
            _253.x = _290.y * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _321 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_321) * _253.x) + 1.0f;
            _215 *= _253.x;
            _215 = _232.x * _215;
            _232.x = _279.x + 0.20000000298023223876953125f;
            _232.x *= 2.8571426868438720703125f;
            _232.x = clamp(_232.x, 0.0f, 1.0f);
            _253.x = (_232.x * (-2.0f)) + 3.0f;
            _232.x *= _232.x;
            _232.x *= _253.x;
            _232.x = _215 * _232.x;
            _232.x = max(_232.x, 0.0f);
            _253.x = _279.x * (-_279.x);
            _253.x *= 40.0f;
            _253.x = exp2(_253.x);
            _215 *= _253.x;
            _215 = max(_215, 0.0f);
            _253.x = _48_m0.y + (-_48_m57[1].w);
            _446.x = _48_m57[1].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m51 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m57[1].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m49) + (-_321);
            _253.x = ((-_48_m51) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _521 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_521) * _253.x) + 1.0f;
            _321 = ((-_48_m50) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _521 = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_521) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _279.x = _494 * (-_494);
            _279.x *= 40.0f;
            _279.x = exp2(_279.x);
            _253.x *= _279.x;
            _215 = max(_215, _253.x);
            _253.x = _48_m0.y + (-_48_m57[2].w);
            _446.x = _48_m57[2].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m51 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m57[2].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m49) + (-_321);
            _253.x = ((-_48_m51) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _521 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_521) * _253.x) + 1.0f;
            _321 = ((-_48_m50) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _521 = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_521) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _279.x = _494 * (-_494);
            _279.x *= 40.0f;
            _279.x = exp2(_279.x);
            _253.x *= _279.x;
            _215 = max(_215, _253.x);
            _253.x = _48_m0.y + (-_48_m57[3].w);
            _446.x = _48_m57[3].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m51 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m57[3].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m49) + (-_321);
            _253.x = ((-_48_m51) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _290.x = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_290.x) * _253.x) + 1.0f;
            _321 = ((-_48_m50) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _290.x = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_290.x) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _290.x = _494 * (-_494);
            _290.x *= 40.0f;
            _290.x = exp2(_290.x);
            _290.x = _253.x * _290.x;
            _290.x = max(_215, _290.x);
            _1020 = _290.x;
            _1023 = _232.x;
        }
        else
        {
            _1020 = 0.0f;
            _1023 = 0.0f;
        }
        _96 = min(_48_m60, 1.0f);
        _96 *= 0.300000011920928955078125f;
        _96 = max(_96, _48_m59);
        _96 = max(_96, _1023);
        _1040 = 0.00200000009499490261077880859375f < _96;
        if (_1040)
        {
            _1047 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
            _1058.x = int((_1047 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
            _1069 = ~_1058.x;
            _1073 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
            _1069 = _1073 ? _1069 : 0;
            bool2 _1093 = (_1069 != 0).xx;
            _1084 = float2(_1093.x ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).x : float2(0.709999978542327880859375f, 0.189999997615814208984375f).x, _1093.y ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).y : float2(0.709999978542327880859375f, 0.189999997615814208984375f).y);
            float2 _1099;
            if (_1058.x != 0)
            {
                _1099 = 0.0f.xx;
            }
            else
            {
                _1099 = _1084;
            }
            _1084 = _1099;
            float2 _1109;
            if (_1069 != 0)
            {
                _1109 = vs_TEXCOORD2.xy;
            }
            else
            {
                _1109 = vs_TEXCOORD2.xz;
            }
            _1106 = float3(_1109.x, _1109.y, _1106.z);
            float2 _1123;
            if (_1058.x != 0)
            {
                _1123 = vs_TEXCOORD2.zy;
            }
            else
            {
                _1123 = _1106.xy;
            }
            _482 = float3(_1123.x, _1123.y, _482.z);
            float2 _1140 = _482.xy / _48_m48.xx;
            _482 = float3(_1140.x, _1140.y, _482.z);
            float2 _1146 = _1084 + _482.xy;
            _482 = float3(_1146.x, _1146.y, _482.z);
            _1149 = _RuneTex.Sample(sampler_RuneTex, _482.xy).w;
            _1047 = _96 * _48_m53;
            float2 _1172 = ((-_48_m52.xx) * _96.xx) + float2(1.0f, 0.7799999713897705078125f);
            _1161 = float3(_1172.x, _1172.y, _1161.z);
            float2 _1180 = _1149.xx + (-_1161.xy);
            _1161 = float3(_1180.x, _1180.y, _1161.z);
            float2 _1188 = _1161.xy * float2(12.5f, 4.5454540252685546875f);
            _1161 = float3(_1188.x, _1188.y, _1161.z);
            float2 _1195 = clamp(_1161.xy, 0.0f.xx, 1.0f.xx);
            _1161 = float3(_1195.x, _1195.y, _1161.z);
            _1198 = (_1161.xy * (-2.0f).xx) + 3.0f.xx;
            float2 _1209 = _1161.xy * _1161.xy;
            _1161 = float3(_1209.x, _1209.y, _1161.z);
            float2 _1216 = _1161.xy * _1198;
            _1212 = float3(_1216.x, _1212.y, _1216.y);
            _1219 = ((-_1198.x) * _1161.x) + 1.0f;
            _1219 *= _1212.z;
            _96 *= _1219;
            _1219 = (_1212.x * 0.60000002384185791015625f) + _96;
            _1219 = clamp(_1219, 0.0f, 1.0f);
            _1219 = ((-_1219) * _48_m54) + 1.0f;
            _1161.x = _1149 * 23.0f;
            _482.x = (_48_m0.y * 11.0f) + _1161.x;
            _482.x = sin(_482.x);
            _482.x = (_482.x * 0.25f) + 0.75f;
            _1161.x = _1020 * 3.0f;
            _1047 = (_1047 * _482.x) + _1161.x;
            _96 *= _48_m53;
            _96 *= 0.07999999821186065673828125f;
            _96 = (_1212.x * _1047) + _96;
            _1161 = _96.xxx * _48_m47.xyz;
            _96 = _48_m60 + 1.0f;
            _1161 = _96.xxx * _1161;
            _1161 = (_155 * _1219.xxx) + _1161;
            _1315 = _155 + (-_1161);
            _155 = (vs_TEXCOORD2.www * _1315) + _1161;
        }
    }
    _1040 = 0.00999999977648258209228515625f < vs_TEXCOORD2.w;
    if (_1040)
    {
        _482 = (-vs_TEXCOORD1) + _48_m1;
        _1339 = dot(_482, _482);
        _1339 = rsqrt(_1339);
        _1106 = _1339.xxx * _482;
        _1349 = vs_TEXCOORD2.y + (-_48_m9.x);
        _1357.x = (-_48_m9.x) + _48_m9.y;
        _1357.x = max(_1357.x, 0.001000000047497451305389404296875f);
        _1349 /= _1357.x;
        _1349 = clamp(_1349, 0.0f, 1.0f);
        _1161 = _48_m7.xyz + (-_48_m8.xyz);
        _1161 = (_1349.xxx * _1161) + _48_m8.xyz;
        _1315 = (_482 * _1339.xxx) + _48_m2.xyz;
        _96 = dot(_1315, _1315);
        _96 = rsqrt(_96);
        _1315 = _96.xxx * _1315;
        _96 = dot(_30, _1315);
        _96 = clamp(_96, 0.0f, 1.0f);
        _96 = log2(_96);
        _96 *= _48_m13;
        _96 = exp2(_96);
        _96 += (-0.60000002384185791015625f);
        _96 *= 10.000003814697265625f;
        _96 = clamp(_96, 0.0f, 1.0f);
        _1047 = (_96 * (-2.0f)) + 3.0f;
        _96 *= _96;
        _96 *= _1047;
        _96 *= _48_m14;
        _1047 = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
        _1452 = vs_TEXCOORD2.xyz / _48_m11.xxx;
        _1452 = floor(_1452);
        _1452 *= float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
        _1452 = frac(_1452);
        _482 = _1452.yxz + 33.3300018310546875f.xxx;
        _482.x = dot(_1452, _482);
        _1452 += _482.xxx;
        _1452.x = _1452.y + _1452.x;
        _1452.x = _1452.z * _1452.x;
        _1452.x = frac(_1452.x);
        _1047 *= 2.2000000476837158203125f;
        _1315 = _1047.xxx * _1161;
        _1047 = _1452.x + (-0.5f);
        _1047 = dot(_1047.xx, _48_m12.xx);
        _1047 += 1.0f;
        _1315 = _1047.xxx * _1315;
        _1315 *= _48_m10.xxx;
        _1529 = _96.xxx * _48_m61.xyz;
        _1536 = (_1161 * 1.5f.xxx) + (-1.0f).xxx;
        _1536 = (_1536 * 0.5f.xxx) + 1.0f.xxx;
        _1529 *= _1536;
        _58 = (_1315 * _58) + _1529;
        _96 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
        _1562 = int((_96 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
        _1570 = ~_1562;
        _1573 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
        _1570 = _1573 ? _1570 : 0;
        _1058 = int3(uint3(bool4(0.0f.xxxx.x < vs_TEXCOORD6.xzyx.x, 0.0f.xxxx.y < vs_TEXCOORD6.xzyx.y, 0.0f.xxxx.z < vs_TEXCOORD6.xzyx.z, 0.0f.xxxx.w < vs_TEXCOORD6.xzyx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1597 = int3(uint3(bool4(vs_TEXCOORD6.xzyx.x < 0.0f.xxxx.x, vs_TEXCOORD6.xzyx.y < 0.0f.xxxx.y, vs_TEXCOORD6.xzyx.z < 0.0f.xxxx.z, vs_TEXCOORD6.xzyx.w < 0.0f.xxxx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1058 = (-_1058) + _1597;
        _1357.x = float(_1058.x);
        _1357.y = 0.0f;
        _1357.z = 0.0f;
        _1616.x = 0.0f;
        _1616.y = 0.0f;
        _1616.z = float(_1058.y);
        _1623.x = 0.0f;
        _1623.z = 0.0f;
        _1623.y = float(_1058.z);
        float3 _1633;
        if (_1570 != 0)
        {
            _1633 = _1616;
        }
        else
        {
            _1633 = _1623;
        }
        _482 = _1633;
        float3 _1642;
        if (_1562 != 0)
        {
            _1642 = _1357.xyz;
        }
        else
        {
            _1642 = _482;
        }
        _482 = _1642;
        float3 _1655 = _1106.yyy * _48_m3[1].xyz;
        _1357 = float4(_1655.x, _1655.y, _1655.z, _1357.w);
        float3 _1666 = (_48_m3[0].xyz * _1106.xxx) + _1357.xyz;
        _1357 = float4(_1666.x, _1666.y, _1666.z, _1357.w);
        float3 _1677 = (_48_m3[2].xyz * _1106.zzz) + _1357.xyz;
        _1357 = float4(_1677.x, _1677.y, _1677.z, _1357.w);
        _1680.x = dot(_1357.xyz, _1357.xyz);
        _1680.x = rsqrt(_1680.x);
        float3 _1695 = _1680.xxx * _1357.xyz;
        _1357 = float4(_1695.x, _1695.y, _1695.z, _1357.w);
        _1616 = _30.yyy * _48_m3[1].xyz;
        _1616 = (_48_m3[0].xyz * _30.xxx) + _1616;
        _1616 = (_48_m3[2].xyz * _30.zzz) + _1616;
        _1680.x = dot(_1616, _1616);
        _1680.x = rsqrt(_1680.x);
        _482.x = dot(_1357.xyz, _482);
        _482.x = max(abs(_482.x), 0.300000011920928955078125f);
        _482 = (-_1357.xyz) / _482.xxx;
        float3 _1750 = (_1616 * _1680.xxx) + (-vs_TEXCOORD6);
        _1357 = float4(_1750.x, _1750.y, _1750.z, _1357.w);
        _482 = (_1357.xyz * float3(float3(_48_m21, _48_m21, _48_m21))) + _482;
        _1770 = int(uint(_1570) | uint(_1562));
        _1339 = _48_m0.y * _48_m32;
        _1680.x = asfloat(uint(_1770) & asuint(_1339));
        if (_167)
        {
            float3 _1799 = vs_TEXCOORD1 + (-_48_m56[0].xyz);
            _1357 = float4(_1799.x, _1799.y, _1799.z, _1357.w);
            _1802 = dot(_1357.xyz, _1357.xyz);
            _1802 = sqrt(_1802);
            _1802 /= _48_m42;
            _1802 = (-_1802) + 1.0f;
            _1802 = clamp(_1802, 0.0f, 1.0f);
            _1802 *= _48_m56[0].w;
            _1802 = max(_1802, 0.0f);
            float3 _1831 = vs_TEXCOORD1 + (-_48_m56[1].xyz);
            _1357 = float4(_1831.x, _1831.y, _1831.z, _1357.w);
            _1339 = dot(_1357.xyz, _1357.xyz);
            _1339 = sqrt(_1339);
            _1339 /= _48_m42;
            _1339 = (-_1339) + 1.0f;
            _1339 = clamp(_1339, 0.0f, 1.0f);
            _1339 *= _48_m56[1].w;
            _1357.x = max(_1802, _1339);
            _1802 = _48_m0.y + (-_48_m57[0].w);
            _1864 = _48_m57[0].w >= 0.001000000047497451305389404296875f;
            _1339 = float(_1864);
            _1870 = _1802 >= 0.0f;
            _1349 = float(_1870);
            _1339 *= _1349;
            _1870 = _48_m45 >= _1802;
            _1349 = float(_1870);
            _1339 *= _1349;
            _1616 = vs_TEXCOORD1 + (-_48_m57[0].xyz);
            _1349 = dot(_1616, _1616);
            _1349 = sqrt(_1349);
            _1349 = ((-_1802) * _48_m43) + _1349;
            _1349 /= _48_m44;
            _1349 *= (-_1349);
            _1349 *= 1.44270002841949462890625f;
            _1349 = exp2(_1349);
            _1802 /= _48_m45;
            _1802 = (-_1802) + 1.0f;
            _1802 *= _1349;
            _1349 = _48_m0.y + (-_48_m57[1].w);
            _1937.x = _48_m57[1].w >= 0.001000000047497451305389404296875f;
            _1937.y = _1349 >= 0.0f;
            _1945.x = float(_1937.x);
            _1945.y = float(_1937.y);
            _1945.x = _1945.y * _1945.x;
            _1960 = _48_m45 >= _1349;
            _1965 = float(_1960);
            _1945.x = _1965 * _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m57[1].xyz);
            _1965 = dot(_1616, _1616);
            _1965 = sqrt(_1965);
            _1965 = ((-_1349) * _48_m43) + _1965;
            _1965 /= _48_m44;
            _1965 *= (-_1965);
            _1965 *= 1.44270002841949462890625f;
            _1965 = exp2(_1965);
            _1349 /= _48_m45;
            _1349 = (-_1349) + 1.0f;
            _1349 *= _1965;
            _1349 = _1945.x * _1349;
            _1802 = (_1802 * _1339) + _1349;
            _1339 = _48_m0.y + (-_48_m57[2].w);
            _1870 = _48_m57[2].w >= 0.001000000047497451305389404296875f;
            _1349 = float(_1870);
            _1937.x = _1339 >= 0.0f;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1937.x = _48_m45 >= _1339;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m57[2].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_1339) * _48_m43) + _1945.x;
            _1945.x /= _48_m44;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _1339 /= _48_m45;
            _1339 = (-_1339) + 1.0f;
            _1339 *= _1945.x;
            _1802 = (_1339 * _1349) + _1802;
            _1339 = _48_m0.y + (-_48_m57[3].w);
            _1870 = _48_m57[3].w >= 0.001000000047497451305389404296875f;
            _1349 = float(_1870);
            _1937.x = _1339 >= 0.0f;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1937.x = _48_m45 >= _1339;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m57[3].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_1339) * _48_m43) + _1945.x;
            _1945.x /= _48_m44;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _1339 /= _48_m45;
            _1339 = (-_1339) + 1.0f;
            _1339 *= _1945.x;
            _1357.y = (_1339 * _1349) + _1802;
            _1315 = float3(_1357.xy.x, _1357.xy.y, _1315.z);
        }
        else
        {
            _1315.x = 0.0f;
            _1315.y = 0.0f;
        }
        _96 = _1315.x * _1315.x;
        float3 _2233 = (_482 * _48_m30.xxx) + vs_TEXCOORD2.xyz;
        _1357 = float4(_2233.x, _2233.y, _2233.z, _1357.w);
        float2 _2238;
        if (_1570 != 0)
        {
            _2238 = _1357.xy;
        }
        else
        {
            _2238 = _1357.xz;
        }
        _1357 = float4(_2238.x, _1357.y, _1357.z, _2238.y);
        float2 _2251;
        if (_1562 != 0)
        {
            _2251 = _1357.zy;
        }
        else
        {
            _2251 = _1357.xw;
        }
        _1357 = float4(_2251.x, _2251.y, _1357.z, _1357.w);
        _1357.z = (-_1680.x) + _1357.y;
        _1680 = _1357.xz / float2(float2(_48_m31, _48_m31));
        _232 = floor(_1680.xyxy);
        _1339 = (_1570 != 0) ? 37.0f : 74.0f;
        _1339 = (_1562 != 0) ? 0.0f : _1339;
        _232 += _1339.xxxx;
        float2 _2302 = _232.zw * float2(123.339996337890625f, 456.209991455078125f);
        _1357 = float4(_2302.x, _2302.y, _1357.z, _1357.w);
        float2 _2307 = frac(_1357.xy);
        _1357 = float4(_2307.x, _2307.y, _1357.z, _1357.w);
        _1945 = _1357.xy + 45.31999969482421875f.xx;
        _1339 = dot(_1357.xy, _1945);
        float2 _2323 = _1339.xx + _1357.xy;
        _1357 = float4(_2323.x, _2323.y, _1357.z, _1357.w);
        _1339 = _1357.y * _1357.x;
        _1339 = frac(_1339);
        _232 += float4(17.3099994659423828125f, 17.3099994659423828125f, 5.730000019073486328125f, 5.730000019073486328125f);
        _232 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
        _232 = frac(_232);
        _290 = _232 + 45.31999969482421875f.xxxx;
        _1349 = dot(_232.xy, _290.xy);
        float2 _2355 = _232.xy + _1349.xx;
        _1357 = float4(_2355.x, _2355.y, _1357.z, _1357.w);
        _1349 = _1357.y * _1357.x;
        _1349 = frac(_1349);
        _1357.x = dot(_232.zw, _290.zw);
        float2 _2375 = _232.zw + _1357.xx;
        _1357 = float4(_2375.x, _2375.y, _1357.z, _1357.w);
        _1357.x = _1357.y * _1357.x;
        _1357.x = frac(_1357.x);
        _1529 = _1339.xxx * float3(16.0f, 13.69999980926513671875f, 40.0f);
        _1047 = floor(_1529.x);
        _2397 = frac(_1680);
        _1339 = _1047 * 0.25f;
        _1960 = _1339 >= (-_1339);
        _1616.x = frac(_1339);
        float _2411;
        if (_1960)
        {
            _2411 = _1616.x;
        }
        else
        {
            _2411 = -_1616.x;
        }
        _1965 = _2411;
        _1616.x = _1965 * 4.0f;
        _1616.y = floor(_1339);
        _2397 += _1616.xy;
        _2397 *= 0.25f.xx;
        float2 _2436 = ddx_coarse(_1680);
        _1616 = float3(_2436.x, _2436.y, _1616.z);
        float2 _2441 = _1616.xy * 0.25f.xx;
        _1616 = float3(_2441.x, _2441.y, _1616.z);
        _1680 = ddy_coarse(_1680);
        _1680 *= 0.25f.xx;
        _2448 = _RuneTex.SampleGrad(sampler_RuneTex, _2397, float4(_1616.xyxx).xy, float4(_1680.xyxx).xy).x;
        _1802 = _48_m0.y * _48_m34;
        _1047 = (_1349 * 0.800000011920928955078125f) + 0.60000002384185791015625f;
        _1802 = (_1802 * _1047) + _1529.y;
        _1802 = frac(_1802);
        _1047 = _1802 * 12.5f;
        _1047 = min(_1047, 1.0f);
        _1219 = (_1047 * (-2.0f)) + 3.0f;
        _1047 *= _1047;
        _1047 *= _1219;
        _1219 = _1802 + (-0.550000011920928955078125f);
        _1219 *= (-4.999999523162841796875f);
        _1219 = clamp(_1219, 0.0f, 1.0f);
        _2508 = (_1219 * (-2.0f)) + 3.0f;
        _1219 *= _1219;
        _1219 *= _2508;
        _1047 *= _1219;
        _1802 = (_48_m0.y * 23.0f) + _1529.z;
        _1802 = sin(_1802);
        _1802 = (_1802 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
        _1802 *= _1047;
        _1047 = (-_48_m33) + 1.0f;
        _1047 *= _48_m58;
        _1047 = (_1047 * 0.699999988079071044921875f) + _48_m33;
        _1864 = _1047 >= _1357.x;
        _1047 = float(_1864);
        _1047 = _1802 * _1047;
        _1219 = _1315.x + (-0.0500000007450580596923828125f);
        _1219 *= 1.53846156597137451171875f;
        _1219 = clamp(_1219, 0.0f, 1.0f);
        _2508 = (_1219 * (-2.0f)) + 3.0f;
        _1219 *= _1219;
        _1219 *= _2508;
        _1047 = max(_1047, _1219);
        _1047 = _2448 * _1047;
        float3 _2594 = (_482 * _48_m36.xxx) + vs_TEXCOORD2.xyz;
        _1357 = float4(_2594.x, _2594.y, _2594.z, _1357.w);
        float2 _2599;
        if (_1570 != 0)
        {
            _2599 = _1357.xy;
        }
        else
        {
            _2599 = _1357.xz;
        }
        _1680 = _2599;
        float2 _2610;
        if (_1562 != 0)
        {
            _2610 = _1357.zy;
        }
        else
        {
            _2610 = _1680;
        }
        _1680 = _2610;
        float2 _2628 = _1680 * float2(float2(_48_m37, _48_m37));
        _1357 = float4(_2628.x, _2628.y, _1357.z, _1357.w);
        _1339 = _48_m0.y * _48_m38;
        _232 = _1339.xxxx * float4(0.12999999523162841796875f, 0.310000002384185791015625f, -0.20999999344348907470703125f, 0.17000000178813934326171875f);
        _1680 = (_1680 * float2(float2(_48_m37, _48_m37))) + _232.xy;
        _2448 = _RuneTex.Sample(sampler_RuneTex, _1680).y;
        float2 _2669 = (_1357.xy * 1.37000000476837158203125f.xx) + _232.zw;
        _1357 = float4(_2669.x, _2669.y, _1357.z, _1357.w);
        _2672 = _RuneTex.Sample(sampler_RuneTex, _1357.xy).y;
        _1219 = (-_2672) + _2448;
        _1219 = ((-abs(_1219)) * 4.0f) + 1.0f;
        _1219 = max(_1219, 0.0f);
        _1219 = log2(_1219);
        _1219 *= _48_m39;
        _1219 = exp2(_1219);
        _482 = (_482 * _48_m25.xxx) + vs_TEXCOORD2.xyz;
        float2 _2710;
        if (_1570 != 0)
        {
            _2710 = _482.xy;
        }
        else
        {
            _2710 = _482.xz;
        }
        _2707 = float3(_2710.x, _2707.y, _2710.y);
        float2 _2723;
        if (_1562 != 0)
        {
            _2723 = _482.zy;
        }
        else
        {
            _2723 = _2707.xz;
        }
        _1452 = float3(_2723.x, _2723.y, _1452.z);
        _1802 = _48_m0.y * _48_m27;
        _482.x = _1802 * 0.60000002384185791015625f;
        _482.y = (-_48_m0.y) * _48_m27;
        float2 _2764 = (_1452.xy * float2(float2(_48_m26, _48_m26))) + _482.xy;
        _1452 = float3(_2764.x, _2764.y, _1452.z);
        _9.x = _RuneTex.Sample(sampler_RuneTex, _1452.xy).z;
        _1452.x = _9.x + (-0.3499999940395355224609375f);
        _1452.x *= 2.2222220897674560546875f;
        _1452.x = clamp(_1452.x, 0.0f, 1.0f);
        _2707.x = (_1452.x * (-2.0f)) + 3.0f;
        _1452.x *= _1452.x;
        _1452.x *= _2707.x;
        _30.x = dot(_30, _1106);
        _30.x = clamp(_30.x, 0.0f, 1.0f);
        _2810 = dot(_23, 0.33329999446868896484375f.xxx);
        _2815 = log2(_30.x);
        _2815 *= _48_m20;
        _2815 = exp2(_2815);
        _2815 = (_2815 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
        _2810 = _2815 * _2810;
        _2707.x = _48_m0.y * _48_m22;
        _1802 = vs_TEXCOORD2.y * 0.699999988079071044921875f;
        _482.x = (_48_m0.y * _48_m22) + _1802;
        _482.x = (_2448 * 3.0f) + _482.x;
        _482.x = sin(_482.x);
        _2707.x = (_2707.x * 2.5f) + _1802;
        _2707.x = (_2448 * 3.0f) + _2707.x;
        _2707.x = sin(_2707.x);
        _2815 = (-_482.x) + _2707.x;
        _2815 = (_48_m58 * _2815) + _482.x;
        _2815 = (_48_m23 * _2815) + 1.0f;
        _30.x = (-_30.x) + 1.0f;
        _30.x = log2(_30.x);
        _30.x *= _48_m16;
        _30.x = exp2(_30.x);
        _1529 = _1161 * _48_m17.xyz;
        _1536 = _1161 * _48_m24.xyz;
        _1536 = _1452.xxx * _1536;
        _1536 *= _48_m28.xxx;
        _2508 = (_1315.x * _1315.x) + 1.0f;
        _1315.x = _48_m60 * 0.300000011920928955078125f;
        _2948 = (_48_m58 * 0.60000002384185791015625f) + _2508;
        _1536 = _2948.xxx * _1536;
        _1529 = (_1529 * float3(float3(_48_m19, _48_m19, _48_m19))) + _1536;
        _1536 = _1219.xxx * _48_m35.xyz;
        _1219 = (_2448 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _1536 = _1219.xxx * _1536;
        _1536 *= float3(float3(_48_m40, _48_m40, _48_m40));
        _1219 = (_96 * 2.0f) + 1.0f;
        _1529 = (_1536 * _1219.xxx) + _1529;
        _1536 = _1047.xxx * _48_m29.xyz;
        _1047 = (_96 * 1.5f) + _48_m58;
        _1047 += 1.0f;
        _1529 = (_1536 * _1047.xxx) + _1529;
        _1529 = _2810.xxx * _1529;
        _1529 *= _48_m18.xxx;
        _1529 = _2815.xxx * _1529;
        _2815 = (_48_m58 * 2.0f) + _48_m60;
        _2815 += 1.0f;
        _1536 = _30.xxx * _48_m15.xyz;
        _30.x = _2508 + _48_m60;
        _1536 = _30.xxx * _1536;
        _1529 = (_1529 * _2815.xxx) + _1536;
        _30.x = _96 * _48_m46;
        _2810 = (_2810 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _30.x = (_30.x * _2810) + _1315.y;
        _30 = (_48_m41.xyz * _30.xxx) + _1529;
        _3102 = (-_1161) + 1.0f.xxx;
        _1161 = (_3102 * 0.5f.xxx) + _1161;
        _30 = (_1161 * _1315.xxx) + _30;
        _30 += _58;
        _30 = (-_155) + _30;
        _155 = (vs_TEXCOORD2.www * _30) + _155;
    }
    _1452.x = vs_TEXCOORD8;
    _1452.x = clamp(_1452.x, 0.0f, 1.0f);
    _2707 = _155 + (-_48_m4.xyz);
    _1452 = (_1452.xxx * _2707) + _48_m4.xyz;
    _3152 = float4(_1452.x, _1452.y, _1452.z, _3152.w);
    _3152.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD8 = stage_input.vs_TEXCOORD8;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._3152 = _3152;
    return stage_output;
}

#endif
#elif defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m7[4];
float4x4 unity_WorldToObject;
static float4 _21_m8[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m10[4];
float4 unity_LightmapST;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m8[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m8[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m8[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m8[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHAr
#define _21_m1 unity_SHAg
#define _21_m2 unity_SHAb
#define _21_m3 unity_SHBr
#define _21_m4 unity_SHBg
#define _21_m5 unity_SHBb
#define _21_m6 unity_SHC
#define _21_m9 unity_WorldTransformParams
#define _21_m11 unity_LightmapST
#define _21_m12 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float2 _100;
static float2 _113;
static float4 vs_TEXCOORD2;
static float4 _131;
static float4 _139;
static float3 _186;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD7;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _186 : NORMAL;
    float4 _139 : TANGENT;
    float2 _100 : TEXCOORD0;
    float2 _113 : TEXCOORD1;
    float4 _131 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD7 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float3 _150;
static float _207;
static float3 _220;
static float3 _233;
static float3 _239;
static float4 _285;
static float3 _291;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _11.xxxx) + _9;
    _9 = (_21_m7[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m7[3];
    vs_TEXCOORD1 = (_21_m7[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m10[1];
    _9 = (_21_m10[0] * _45.xxxx) + _9;
    _9 = (_21_m10[2] * _45.zzzz) + _9;
    gl_Position = (_21_m10[3] * _45.wwww) + _9;
    float2 _110 = (_100 * _21_m12.xy) + _21_m12.zw;
    vs_TEXCOORD0 = float4(_110.x, _110.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _123 = (_113 * _21_m11.xy) + _21_m11.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _123.x, _123.y);
    vs_TEXCOORD2 = float4(_11.xyz.x, _11.xyz.y, _11.xyz.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _131.x;
    _9.x = _139.w * _21_m9.w;
    _150 = _139.yyy * _21_m7[1].yzx;
    _150 = (_21_m7[0].yzx * _139.xxx) + _150;
    _150 = (_21_m7[2].yzx * _139.zzz) + _150;
    _45.x = dot(_150, _150);
    _45.x = rsqrt(_45.x);
    _150 *= _45.xxx;
    _45.x = dot(_186, _21_m8[0].xyz);
    _45.y = dot(_186, _21_m8[1].xyz);
    _45.z = dot(_186, _21_m8[2].xyz);
    _207 = dot(_45.xyz, _45.xyz);
    _207 = rsqrt(_207);
    _45 = _207.xxxx * _45.xyzz;
    _220 = _150 * _45.zxy;
    _220 = (_45.yzx * _150.yzx) + (-_220);
    _233 = _9.xxx * _220.xzy;
    _239.y = _233.x;
    _239.x = _150.z;
    _239.z = _45.x;
    vs_TEXCOORD3 = _239;
    _233.x = _150.y;
    _150.y = _233.z;
    _150.z = _45.y;
    vs_TEXCOORD4 = _150;
    _233.z = _45.z;
    vs_TEXCOORD5 = _233;
    vs_TEXCOORD6 = _186;
    _220.x = _45.y * _45.y;
    _220.x = (_45.x * _45.x) + (-_220.x);
    _285 = _45.yzwx * _45.xywz;
    _291.x = dot(_21_m3, _285);
    _291.y = dot(_21_m4, _285);
    _291.z = dot(_21_m5, _285);
    _220 = (_21_m6.xyz * _220.xxx) + _291;
    _45.w = 1.0f;
    _291.x = dot(_21_m0, _45);
    _291.y = dot(_21_m1, _45);
    _291.z = dot(_21_m2, _45);
    vs_TEXCOORD7 = _220 + _291;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    _113 = stage_input._113;
    _131 = stage_input._131;
    _139 = stage_input._139;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _46_m3[4];
float4 unity_Lightmap_HDR;
float _BumpScale;
float _RockEmission;
float4 _TopColor;
float4 _BottomColor;
float4 _HeightRange;
float _ShellBrightness;
float _BlockSize;
float _BlockVariation;
float _Gloss;
float _GlintStrength;
float4 _RimColor;
float _RimPower;
float4 _GlowColor;
float _GlowStrength;
float _InnerFill;
float _FacingPower;
float _Refraction;
float _PulseSpeed;
float _PulseAmount;
float4 _CoreColor;
float _CoreDepth;
float _CoreScale;
float _CoreSpeed;
float _CoreStrength;
float4 _RuneColor;
float _RuneDepth;
float _RuneCell;
float _RuneSpeed;
float _RuneDensity;
float _RuneBlink;
float4 _VeinColor;
float _VeinDepth;
float _VeinScale;
float _VeinSpeed;
float _VeinSharpness;
float _VeinStrength;
float4 _TouchColor;
float _HandRadius;
float _RippleSpeed;
float _RippleWidth;
float _RippleLife;
float _HandStrength;
float4 _CrackColor;
float _CrackScale;
float _CrackSpeed;
float _CrackReach;
float _CrackLife;
float _CrackOpen;
float _CrackGlow;
float _CrackDarken;
float _KevinActive;
float4 _KevinHands[2];
float4 _KevinRipples[4];
float _RiftAwake;
float _RiftCrack;
float _RiftFlash;
float4 _LightColor0;
void __unity_init()
{
    _46_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _46_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _46_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _46_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _46_m0 _Time
#define _46_m1 _WorldSpaceCameraPos
#define _46_m2 _WorldSpaceLightPos0
#define _46_m4 unity_Lightmap_HDR
#define _46_m5 _BumpScale
#define _46_m6 _RockEmission
#define _46_m7 _TopColor
#define _46_m8 _BottomColor
#define _46_m9 _HeightRange
#define _46_m10 _ShellBrightness
#define _46_m11 _BlockSize
#define _46_m12 _BlockVariation
#define _46_m13 _Gloss
#define _46_m14 _GlintStrength
#define _46_m15 _RimColor
#define _46_m16 _RimPower
#define _46_m17 _GlowColor
#define _46_m18 _GlowStrength
#define _46_m19 _InnerFill
#define _46_m20 _FacingPower
#define _46_m21 _Refraction
#define _46_m22 _PulseSpeed
#define _46_m23 _PulseAmount
#define _46_m24 _CoreColor
#define _46_m25 _CoreDepth
#define _46_m26 _CoreScale
#define _46_m27 _CoreSpeed
#define _46_m28 _CoreStrength
#define _46_m29 _RuneColor
#define _46_m30 _RuneDepth
#define _46_m31 _RuneCell
#define _46_m32 _RuneSpeed
#define _46_m33 _RuneDensity
#define _46_m34 _RuneBlink
#define _46_m35 _VeinColor
#define _46_m36 _VeinDepth
#define _46_m37 _VeinScale
#define _46_m38 _VeinSpeed
#define _46_m39 _VeinSharpness
#define _46_m40 _VeinStrength
#define _46_m41 _TouchColor
#define _46_m42 _HandRadius
#define _46_m43 _RippleSpeed
#define _46_m44 _RippleWidth
#define _46_m45 _RippleLife
#define _46_m46 _HandStrength
#define _46_m47 _CrackColor
#define _46_m48 _CrackScale
#define _46_m49 _CrackSpeed
#define _46_m50 _CrackReach
#define _46_m51 _CrackLife
#define _46_m52 _CrackOpen
#define _46_m53 _CrackGlow
#define _46_m54 _CrackDarken
#define _46_m55 _KevinActive
#define _46_m56 _KevinHands
#define _46_m57 _KevinRipples
#define _46_m58 _RiftAwake
#define _46_m59 _RiftCrack
#define _46_m60 _RiftFlash
#define _46_m61 _LightColor0


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> unity_Lightmap;
SamplerState samplerunity_Lightmap;
Texture2D<float4> _RuneTex;
SamplerState sampler_RuneTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;

static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 _3160;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _3160 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _30;
static float _55;
static float3 _70;
static bool _82;
static bool2 _90;
static bool _108;
static float _134;
static float4 _151;
static bool _166;
static float3 _172;
static float2 _199;
static float3 _210;
static float _241;
static bool2 _368;
static bool _391;
static float3 _404;
static float2 _416;
static float _444;
static float _954;
static float _956;
static bool _973;
static float _980;
static int3 _991;
static int _1002;
static bool _1006;
static float3 _1080;
static float4 _1093;
static float2 _1130;
static float3 _1144;
static float3 _1258;
static float _1346;
static float4 _1354;
static float3 _1390;
static float3 _1451;
static float3 _1528;
static float3 _1536;
static int _1562;
static int _1570;
static bool _1573;
static int3 _1597;
static float3 _1616;
static float3 _1623;
static float2 _1680;
static int _1770;
static float _1802;
static bool _1864;
static bool _1870;
static bool2 _1937;
static float2 _1945;
static bool _1960;
static float _1965;
static float2 _2397;
static float _2448;
static float _2491;
static float _2509;
static float _2673;
static float3 _2708;
static float _2966;
static float3 _3128;

void frag_inner()
{
    __unity_init();
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
    _30 = unity_Lightmap.Sample(samplerunity_Lightmap, vs_TEXCOORD0.zw).xyz;
    _30 *= _46_m4.xxx;
    _55 = (-vs_TEXCOORD2.w) + 1.0f;
    _55 *= _46_m6;
    _70 = _23 * _55.xxx;
    _70 = (_9 * _30) + _70;
    _82 = 0.5f < _46_m55;
    float4 _104 = float4(_46_m59, _46_m60, _46_m59, _46_m59);
    _90 = bool4(float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).x < _104.x, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).y < _104.y, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).z < _104.z, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).w < _104.w).xy;
    _108 = _82 || _90.x;
    _108 = _90.y || _108;
    _90.x = vs_TEXCOORD2.w < 0.9900000095367431640625f;
    _108 = _108 && _90.x;
    if (_108)
    {
        if (_82)
        {
            _134 = _46_m0.y + (-_46_m57[0].w);
            _90.x = _46_m57[0].w >= 0.001000000047497451305389404296875f;
            _90.y = _134 >= 0.0f;
            _151.x = float(_90.x);
            _151.y = float(_90.y);
            _151.x = _151.y * _151.x;
            _166 = _46_m51 >= _134;
            _172.x = float(_166);
            _151.x = _172.x * _151.x;
            _172 = vs_TEXCOORD1 + (-_46_m57[0].xyz);
            _172.x = dot(_172, _172);
            _172.x = sqrt(_172.x);
            _199.x = (_134 * _46_m49) + (-_172.x);
            float2 _220 = float2(_46_m51, _46_m50) * float2(0.550000011920928955078125f, 0.449999988079071044921875f);
            _210 = float3(_220.x, _220.y, _210.z);
            _134 = ((-_46_m51) * 0.449999988079071044921875f) + _134;
            float2 _232 = 1.0f.xx / _210.xy;
            _210 = float3(_232.x, _232.y, _210.z);
            _134 *= _210.x;
            _134 = clamp(_134, 0.0f, 1.0f);
            _241 = (_134 * (-2.0f)) + 3.0f;
            _134 *= _134;
            _134 = ((-_241) * _134) + 1.0f;
            _172.x = ((-_46_m50) * 0.550000011920928955078125f) + _172.x;
            _172.x = _210.y * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _241 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_241) * _172.x) + 1.0f;
            _134 *= _172.x;
            _134 = _151.x * _134;
            _151.x = _199.x + 0.20000000298023223876953125f;
            _151.x *= 2.8571426868438720703125f;
            _151.x = clamp(_151.x, 0.0f, 1.0f);
            _172.x = (_151.x * (-2.0f)) + 3.0f;
            _151.x *= _151.x;
            _151.x *= _172.x;
            _151.x = _134 * _151.x;
            _151.x = max(_151.x, 0.0f);
            _172.x = _199.x * (-_199.x);
            _172.x *= 40.0f;
            _172.x = exp2(_172.x);
            _134 *= _172.x;
            _134 = max(_134, 0.0f);
            _172.x = _46_m0.y + (-_46_m57[1].w);
            _368.x = _46_m57[1].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m51 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m57[1].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m49) + (-_241);
            _172.x = ((-_46_m51) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _444 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_444) * _172.x) + 1.0f;
            _241 = ((-_46_m50) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _444 = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_444) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _199.x = _416.x * (-_416.x);
            _199.x *= 40.0f;
            _199.x = exp2(_199.x);
            _172.x *= _199.x;
            _134 = max(_134, _172.x);
            _172.x = _46_m0.y + (-_46_m57[2].w);
            _368.x = _46_m57[2].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m51 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m57[2].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m49) + (-_241);
            _172.x = ((-_46_m51) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _444 = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_444) * _172.x) + 1.0f;
            _241 = ((-_46_m50) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _444 = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_444) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _199.x = _416.x * (-_416.x);
            _199.x *= 40.0f;
            _199.x = exp2(_199.x);
            _172.x *= _199.x;
            _134 = max(_134, _172.x);
            _172.x = _46_m0.y + (-_46_m57[3].w);
            _368.x = _46_m57[3].w >= 0.001000000047497451305389404296875f;
            _368.y = _172.x >= 0.0f;
            _199.x = float(_368.x);
            _199.y = float(_368.y);
            _199.x = _199.y * _199.x;
            _391 = _46_m51 >= _172.x;
            _241 = float(_391);
            _199.x = _241 * _199.x;
            _404 = vs_TEXCOORD1 + (-_46_m57[3].xyz);
            _241 = dot(_404, _404);
            _241 = sqrt(_241);
            _416.x = (_172.x * _46_m49) + (-_241);
            _172.x = ((-_46_m51) * 0.449999988079071044921875f) + _172.x;
            _172.x = _210.x * _172.x;
            _172.x = clamp(_172.x, 0.0f, 1.0f);
            _210.x = (_172.x * (-2.0f)) + 3.0f;
            _172.x *= _172.x;
            _172.x = ((-_210.x) * _172.x) + 1.0f;
            _241 = ((-_46_m50) * 0.550000011920928955078125f) + _241;
            _241 = _210.y * _241;
            _241 = clamp(_241, 0.0f, 1.0f);
            _210.x = (_241 * (-2.0f)) + 3.0f;
            _241 *= _241;
            _241 = ((-_210.x) * _241) + 1.0f;
            _172.x = _241 * _172.x;
            _172.x = _199.x * _172.x;
            _199.x = _416.x + 0.20000000298023223876953125f;
            _199.x *= 2.8571426868438720703125f;
            _199.x = clamp(_199.x, 0.0f, 1.0f);
            _241 = (_199.x * (-2.0f)) + 3.0f;
            _199.x *= _199.x;
            _199.x *= _241;
            _199.x = _172.x * _199.x;
            _151.x = max(_199.x, _151.x);
            _210.x = _416.x * (-_416.x);
            _210.x *= 40.0f;
            _210.x = exp2(_210.x);
            _210.x = _172.x * _210.x;
            _134 = max(_134, _210.x);
            _954 = _134;
            _956 = _151.x;
        }
        else
        {
            _954 = 0.0f;
            _956 = 0.0f;
        }
        _55 = min(_46_m60, 1.0f);
        _55 *= 0.300000011920928955078125f;
        _55 = max(_55, _46_m59);
        _55 = max(_55, _956);
        _973 = 0.00200000009499490261077880859375f < _55;
        if (_973)
        {
            _980 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
            _991.x = int((_980 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
            _1002 = ~_991.x;
            _1006 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
            _1002 = _1006 ? _1002 : 0;
            bool2 _1025 = (_1002 != 0).xx;
            _416 = float2(_1025.x ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).x : float2(0.709999978542327880859375f, 0.189999997615814208984375f).x, _1025.y ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).y : float2(0.709999978542327880859375f, 0.189999997615814208984375f).y);
            float2 _1031;
            if (_991.x != 0)
            {
                _1031 = 0.0f.xx;
            }
            else
            {
                _1031 = _416;
            }
            _416 = _1031;
            float2 _1040;
            if (_1002 != 0)
            {
                _1040 = vs_TEXCOORD2.xy;
            }
            else
            {
                _1040 = vs_TEXCOORD2.xz;
            }
            _404 = float3(_1040.x, _1040.y, _404.z);
            float2 _1054;
            if (_991.x != 0)
            {
                _1054 = vs_TEXCOORD2.zy;
            }
            else
            {
                _1054 = _404.xy;
            }
            _210 = float3(_1054.x, _1054.y, _210.z);
            float2 _1071 = _210.xy / _46_m48.xx;
            _210 = float3(_1071.x, _1071.y, _210.z);
            float2 _1077 = _416 + _210.xy;
            _210 = float3(_1077.x, _1077.y, _210.z);
            _1080.x = _RuneTex.Sample(sampler_RuneTex, _210.xy).w;
            _980 = _55 * _46_m53;
            float2 _1104 = ((-_46_m52.xx) * _55.xx) + float2(1.0f, 0.7799999713897705078125f);
            _1093 = float4(_1104.x, _1104.y, _1093.z, _1093.w);
            float2 _1112 = _1080.xx + (-_1093.xy);
            _1093 = float4(_1112.x, _1112.y, _1093.z, _1093.w);
            float2 _1120 = _1093.xy * float2(12.5f, 4.5454540252685546875f);
            _1093 = float4(_1120.x, _1120.y, _1093.z, _1093.w);
            float2 _1127 = clamp(_1093.xy, 0.0f.xx, 1.0f.xx);
            _1093 = float4(_1127.x, _1127.y, _1093.z, _1093.w);
            _1130 = (_1093.xy * (-2.0f).xx) + 3.0f.xx;
            float2 _1141 = _1093.xy * _1093.xy;
            _1093 = float4(_1141.x, _1141.y, _1093.z, _1093.w);
            float2 _1148 = _1093.xy * _1130;
            _1144 = float3(_1148.x, _1144.y, _1148.y);
            _1093.x = ((-_1130.x) * _1093.x) + 1.0f;
            _1093.x *= _1144.z;
            _55 *= _1093.x;
            _1093.x = (_1144.x * 0.60000002384185791015625f) + _55;
            _1093.x = clamp(_1093.x, 0.0f, 1.0f);
            _1093.x = ((-_1093.x) * _46_m54) + 1.0f;
            _1130.x = _1080.x * 23.0f;
            _210.x = (_46_m0.y * 11.0f) + _1130.x;
            _210.x = sin(_210.x);
            _210.x = (_210.x * 0.25f) + 0.75f;
            _1130.x = _954 * 3.0f;
            _980 = (_980 * _210.x) + _1130.x;
            _55 *= _46_m53;
            _55 *= 0.07999999821186065673828125f;
            _55 = (_1144.x * _980) + _55;
            _1144 = _55.xxx * _46_m47.xyz;
            _55 = _46_m60 + 1.0f;
            _1144 = _55.xxx * _1144;
            float3 _1255 = (_70 * _1093.xxx) + _1144;
            _1093 = float4(_1255.x, _1255.y, _1255.z, _1093.w);
            _1258 = _70 + (-_1093.xyz);
            _70 = (vs_TEXCOORD2.www * _1258) + _1093.xyz;
        }
    }
    _973 = 0.00999999977648258209228515625f < vs_TEXCOORD2.w;
    if (_973)
    {
        _1080 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
        float3 _1290 = (_1080 * 2.0f.xxx) + (-1.0f).xxx;
        _1093 = float4(_1290.x, _1290.y, _1290.z, _1093.w);
        float2 _1299 = _1093.xy * _46_m5.xx;
        _1093 = float4(_1299.x, _1299.y, _1093.z, _1093.w);
        _1258.x = dot(vs_TEXCOORD3, _1093.xyz);
        _1258.y = dot(vs_TEXCOORD4, _1093.xyz);
        _1258.z = dot(vs_TEXCOORD5, _1093.xyz);
        _55 = dot(_1258, _1258);
        _55 = rsqrt(_55);
        float3 _1328 = _55.xxx * _1258;
        _1093 = float4(_1328.x, _1328.y, _1328.z, _1093.w);
        _210 = (-vs_TEXCOORD1) + _46_m1;
        _444 = dot(_210, _210);
        _444 = rsqrt(_444);
        _404 = _444.xxx * _210;
        _1346 = vs_TEXCOORD2.y + (-_46_m9.x);
        _1354.x = (-_46_m9.x) + _46_m9.y;
        _1354.x = max(_1354.x, 0.001000000047497451305389404296875f);
        _1346 /= _1354.x;
        _1346 = clamp(_1346, 0.0f, 1.0f);
        _1258 = _46_m7.xyz + (-_46_m8.xyz);
        _1258 = (_1346.xxx * _1258) + _46_m8.xyz;
        _1390 = (_210 * _444.xxx) + _46_m2.xyz;
        _55 = dot(_1390, _1390);
        _55 = rsqrt(_55);
        _1390 = _55.xxx * _1390;
        _55 = dot(_1093.xyz, _1390);
        _55 = clamp(_55, 0.0f, 1.0f);
        _55 = log2(_55);
        _55 *= _46_m13;
        _55 = exp2(_55);
        _55 += (-0.60000002384185791015625f);
        _55 *= 10.000003814697265625f;
        _55 = clamp(_55, 0.0f, 1.0f);
        _980 = (_55 * (-2.0f)) + 3.0f;
        _55 *= _55;
        _55 *= _980;
        _55 *= _46_m14;
        _980 = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
        _1451 = vs_TEXCOORD2.xyz / _46_m11.xxx;
        _1451 = floor(_1451);
        _1451 *= float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
        _1451 = frac(_1451);
        _210 = _1451.yxz + 33.3300018310546875f.xxx;
        _210.x = dot(_1451, _210);
        _1451 += _210.xxx;
        _1451.x = _1451.y + _1451.x;
        _1451.x = _1451.z * _1451.x;
        _1451.x = frac(_1451.x);
        _980 *= 2.2000000476837158203125f;
        _1390 = _980.xxx * _1258;
        _980 = _1451.x + (-0.5f);
        _980 = dot(_980.xx, _46_m12.xx);
        _980 += 1.0f;
        _1390 = _980.xxx * _1390;
        _1390 *= _46_m10.xxx;
        _1528 = _55.xxx * _46_m61.xyz;
        _1536 = (_1258 * 1.5f.xxx) + (-1.0f).xxx;
        _1536 = (_1536 * 0.5f.xxx) + 1.0f.xxx;
        _1528 *= _1536;
        _30 = (_1390 * _30) + _1528;
        _55 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
        _1562 = int((_55 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
        _1570 = ~_1562;
        _1573 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
        _1570 = _1573 ? _1570 : 0;
        _991 = int3(uint3(bool4(0.0f.xxxx.x < vs_TEXCOORD6.xzyx.x, 0.0f.xxxx.y < vs_TEXCOORD6.xzyx.y, 0.0f.xxxx.z < vs_TEXCOORD6.xzyx.z, 0.0f.xxxx.w < vs_TEXCOORD6.xzyx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1597 = int3(uint3(bool4(vs_TEXCOORD6.xzyx.x < 0.0f.xxxx.x, vs_TEXCOORD6.xzyx.y < 0.0f.xxxx.y, vs_TEXCOORD6.xzyx.z < 0.0f.xxxx.z, vs_TEXCOORD6.xzyx.w < 0.0f.xxxx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _991 = (-_991) + _1597;
        _1354.x = float(_991.x);
        _1354.y = 0.0f;
        _1354.z = 0.0f;
        _1616.x = 0.0f;
        _1616.y = 0.0f;
        _1616.z = float(_991.y);
        _1623.x = 0.0f;
        _1623.z = 0.0f;
        _1623.y = float(_991.z);
        float3 _1633;
        if (_1570 != 0)
        {
            _1633 = _1616;
        }
        else
        {
            _1633 = _1623;
        }
        _210 = _1633;
        float3 _1642;
        if (_1562 != 0)
        {
            _1642 = _1354.xyz;
        }
        else
        {
            _1642 = _210;
        }
        _210 = _1642;
        float3 _1655 = _404.yyy * _46_m3[1].xyz;
        _1354 = float4(_1655.x, _1655.y, _1655.z, _1354.w);
        float3 _1666 = (_46_m3[0].xyz * _404.xxx) + _1354.xyz;
        _1354 = float4(_1666.x, _1666.y, _1666.z, _1354.w);
        float3 _1677 = (_46_m3[2].xyz * _404.zzz) + _1354.xyz;
        _1354 = float4(_1677.x, _1677.y, _1677.z, _1354.w);
        _1680.x = dot(_1354.xyz, _1354.xyz);
        _1680.x = rsqrt(_1680.x);
        float3 _1695 = _1680.xxx * _1354.xyz;
        _1354 = float4(_1695.x, _1695.y, _1695.z, _1354.w);
        _1616 = _1093.yyy * _46_m3[1].xyz;
        _1616 = (_46_m3[0].xyz * _1093.xxx) + _1616;
        _1616 = (_46_m3[2].xyz * _1093.zzz) + _1616;
        _1680.x = dot(_1616, _1616);
        _1680.x = rsqrt(_1680.x);
        _210.x = dot(_1354.xyz, _210);
        _210.x = max(abs(_210.x), 0.300000011920928955078125f);
        _210 = (-_1354.xyz) / _210.xxx;
        float3 _1750 = (_1616 * _1680.xxx) + (-vs_TEXCOORD6);
        _1354 = float4(_1750.x, _1750.y, _1750.z, _1354.w);
        _210 = (_1354.xyz * float3(float3(_46_m21, _46_m21, _46_m21))) + _210;
        _1770 = int(uint(_1570) | uint(_1562));
        _444 = _46_m0.y * _46_m32;
        _1680.x = asfloat(uint(_1770) & asuint(_444));
        if (_82)
        {
            float3 _1799 = vs_TEXCOORD1 + (-_46_m56[0].xyz);
            _1354 = float4(_1799.x, _1799.y, _1799.z, _1354.w);
            _1802 = dot(_1354.xyz, _1354.xyz);
            _1802 = sqrt(_1802);
            _1802 /= _46_m42;
            _1802 = (-_1802) + 1.0f;
            _1802 = clamp(_1802, 0.0f, 1.0f);
            _1802 *= _46_m56[0].w;
            _1802 = max(_1802, 0.0f);
            float3 _1831 = vs_TEXCOORD1 + (-_46_m56[1].xyz);
            _1354 = float4(_1831.x, _1831.y, _1831.z, _1354.w);
            _444 = dot(_1354.xyz, _1354.xyz);
            _444 = sqrt(_444);
            _444 /= _46_m42;
            _444 = (-_444) + 1.0f;
            _444 = clamp(_444, 0.0f, 1.0f);
            _444 *= _46_m56[1].w;
            _1354.x = max(_1802, _444);
            _1802 = _46_m0.y + (-_46_m57[0].w);
            _1864 = _46_m57[0].w >= 0.001000000047497451305389404296875f;
            _444 = float(_1864);
            _1870 = _1802 >= 0.0f;
            _1346 = float(_1870);
            _444 *= _1346;
            _1870 = _46_m45 >= _1802;
            _1346 = float(_1870);
            _444 *= _1346;
            _1616 = vs_TEXCOORD1 + (-_46_m57[0].xyz);
            _1346 = dot(_1616, _1616);
            _1346 = sqrt(_1346);
            _1346 = ((-_1802) * _46_m43) + _1346;
            _1346 /= _46_m44;
            _1346 *= (-_1346);
            _1346 *= 1.44270002841949462890625f;
            _1346 = exp2(_1346);
            _1802 /= _46_m45;
            _1802 = (-_1802) + 1.0f;
            _1802 *= _1346;
            _1346 = _46_m0.y + (-_46_m57[1].w);
            _1937.x = _46_m57[1].w >= 0.001000000047497451305389404296875f;
            _1937.y = _1346 >= 0.0f;
            _1945.x = float(_1937.x);
            _1945.y = float(_1937.y);
            _1945.x = _1945.y * _1945.x;
            _1960 = _46_m45 >= _1346;
            _1965 = float(_1960);
            _1945.x = _1965 * _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m57[1].xyz);
            _1965 = dot(_1616, _1616);
            _1965 = sqrt(_1965);
            _1965 = ((-_1346) * _46_m43) + _1965;
            _1965 /= _46_m44;
            _1965 *= (-_1965);
            _1965 *= 1.44270002841949462890625f;
            _1965 = exp2(_1965);
            _1346 /= _46_m45;
            _1346 = (-_1346) + 1.0f;
            _1346 *= _1965;
            _1346 = _1945.x * _1346;
            _1802 = (_1802 * _444) + _1346;
            _444 = _46_m0.y + (-_46_m57[2].w);
            _1870 = _46_m57[2].w >= 0.001000000047497451305389404296875f;
            _1346 = float(_1870);
            _1937.x = _444 >= 0.0f;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1937.x = _46_m45 >= _444;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m57[2].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_444) * _46_m43) + _1945.x;
            _1945.x /= _46_m44;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _444 /= _46_m45;
            _444 = (-_444) + 1.0f;
            _444 *= _1945.x;
            _1802 = (_444 * _1346) + _1802;
            _444 = _46_m0.y + (-_46_m57[3].w);
            _1870 = _46_m57[3].w >= 0.001000000047497451305389404296875f;
            _1346 = float(_1870);
            _1937.x = _444 >= 0.0f;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1937.x = _46_m45 >= _444;
            _1945.x = float(_1937.x);
            _1346 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_46_m57[3].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_444) * _46_m43) + _1945.x;
            _1945.x /= _46_m44;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _444 /= _46_m45;
            _444 = (-_444) + 1.0f;
            _444 *= _1945.x;
            _1354.y = (_444 * _1346) + _1802;
            _1390 = float3(_1354.xy.x, _1354.xy.y, _1390.z);
        }
        else
        {
            _1390.x = 0.0f;
            _1390.y = 0.0f;
        }
        _55 = _1390.x * _1390.x;
        float3 _2233 = (_210 * _46_m30.xxx) + vs_TEXCOORD2.xyz;
        _1354 = float4(_2233.x, _2233.y, _2233.z, _1354.w);
        float2 _2238;
        if (_1570 != 0)
        {
            _2238 = _1354.xy;
        }
        else
        {
            _2238 = _1354.xz;
        }
        _1354 = float4(_2238.x, _1354.y, _1354.z, _2238.y);
        float2 _2251;
        if (_1562 != 0)
        {
            _2251 = _1354.zy;
        }
        else
        {
            _2251 = _1354.xw;
        }
        _1354 = float4(_2251.x, _2251.y, _1354.z, _1354.w);
        _1354.z = (-_1680.x) + _1354.y;
        _1680 = _1354.xz / float2(float2(_46_m31, _46_m31));
        _151 = floor(_1680.xyxy);
        _444 = (_1570 != 0) ? 37.0f : 74.0f;
        _444 = (_1562 != 0) ? 0.0f : _444;
        _151 += _444.xxxx;
        float2 _2302 = _151.zw * float2(123.339996337890625f, 456.209991455078125f);
        _1354 = float4(_2302.x, _2302.y, _1354.z, _1354.w);
        float2 _2307 = frac(_1354.xy);
        _1354 = float4(_2307.x, _2307.y, _1354.z, _1354.w);
        _1945 = _1354.xy + 45.31999969482421875f.xx;
        _444 = dot(_1354.xy, _1945);
        float2 _2323 = _444.xx + _1354.xy;
        _1354 = float4(_2323.x, _2323.y, _1354.z, _1354.w);
        _444 = _1354.y * _1354.x;
        _444 = frac(_444);
        _151 += float4(17.3099994659423828125f, 17.3099994659423828125f, 5.730000019073486328125f, 5.730000019073486328125f);
        _151 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
        _151 = frac(_151);
        _1354 = _151 + 45.31999969482421875f.xxxx;
        _1346 = dot(_151.xy, _1354.xy);
        float2 _2355 = _151.xy + _1346.xx;
        _1354 = float4(_2355.x, _2355.y, _1354.z, _1354.w);
        _1346 = _1354.y * _1354.x;
        _1346 = frac(_1346);
        _1354.x = dot(_151.zw, _1354.zw);
        float2 _2375 = _151.zw + _1354.xx;
        _1354 = float4(_2375.x, _2375.y, _1354.z, _1354.w);
        _1354.x = _1354.y * _1354.x;
        _1354.x = frac(_1354.x);
        _1528 = _444.xxx * float3(16.0f, 13.69999980926513671875f, 40.0f);
        _980 = floor(_1528.x);
        _2397 = frac(_1680);
        _444 = _980 * 0.25f;
        _1960 = _444 >= (-_444);
        _1616.x = frac(_444);
        float _2411;
        if (_1960)
        {
            _2411 = _1616.x;
        }
        else
        {
            _2411 = -_1616.x;
        }
        _1965 = _2411;
        _1616.x = _1965 * 4.0f;
        _1616.y = floor(_444);
        _2397 += _1616.xy;
        _2397 *= 0.25f.xx;
        float2 _2436 = ddx_coarse(_1680);
        _1616 = float3(_2436.x, _2436.y, _1616.z);
        float2 _2441 = _1616.xy * 0.25f.xx;
        _1616 = float3(_2441.x, _2441.y, _1616.z);
        _1680 = ddy_coarse(_1680);
        _1680 *= 0.25f.xx;
        _2448 = _RuneTex.SampleGrad(sampler_RuneTex, _2397, float4(_1616.xyxx).xy, float4(_1680.xyxx).xy).x;
        _1802 = _46_m0.y * _46_m34;
        _980 = (_1346 * 0.800000011920928955078125f) + 0.60000002384185791015625f;
        _1802 = (_1802 * _980) + _1528.y;
        _1802 = frac(_1802);
        _980 = _1802 * 12.5f;
        _980 = min(_980, 1.0f);
        _2491 = (_980 * (-2.0f)) + 3.0f;
        _980 *= _980;
        _980 *= _2491;
        _2491 = _1802 + (-0.550000011920928955078125f);
        _2491 *= (-4.999999523162841796875f);
        _2491 = clamp(_2491, 0.0f, 1.0f);
        _2509 = (_2491 * (-2.0f)) + 3.0f;
        _2491 *= _2491;
        _2491 *= _2509;
        _980 *= _2491;
        _1802 = (_46_m0.y * 23.0f) + _1528.z;
        _1802 = sin(_1802);
        _1802 = (_1802 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
        _1802 *= _980;
        _980 = (-_46_m33) + 1.0f;
        _980 *= _46_m58;
        _980 = (_980 * 0.699999988079071044921875f) + _46_m33;
        _1864 = _980 >= _1354.x;
        _980 = float(_1864);
        _980 = _1802 * _980;
        _2491 = _1390.x + (-0.0500000007450580596923828125f);
        _2491 *= 1.53846156597137451171875f;
        _2491 = clamp(_2491, 0.0f, 1.0f);
        _2509 = (_2491 * (-2.0f)) + 3.0f;
        _2491 *= _2491;
        _2491 *= _2509;
        _980 = max(_980, _2491);
        _980 = _2448 * _980;
        float3 _2595 = (_210 * _46_m36.xxx) + vs_TEXCOORD2.xyz;
        _1354 = float4(_2595.x, _2595.y, _2595.z, _1354.w);
        float2 _2600;
        if (_1570 != 0)
        {
            _2600 = _1354.xy;
        }
        else
        {
            _2600 = _1354.xz;
        }
        _1680 = _2600;
        float2 _2611;
        if (_1562 != 0)
        {
            _2611 = _1354.zy;
        }
        else
        {
            _2611 = _1680;
        }
        _1680 = _2611;
        float2 _2629 = _1680 * float2(float2(_46_m37, _46_m37));
        _1354 = float4(_2629.x, _2629.y, _1354.z, _1354.w);
        _444 = _46_m0.y * _46_m38;
        _151 = _444.xxxx * float4(0.12999999523162841796875f, 0.310000002384185791015625f, -0.20999999344348907470703125f, 0.17000000178813934326171875f);
        _1680 = (_1680 * float2(float2(_46_m37, _46_m37))) + _151.xy;
        _2448 = _RuneTex.Sample(sampler_RuneTex, _1680).y;
        float2 _2670 = (_1354.xy * 1.37000000476837158203125f.xx) + _151.zw;
        _1354 = float4(_2670.x, _2670.y, _1354.z, _1354.w);
        _2673 = _RuneTex.Sample(sampler_RuneTex, _1354.xy).y;
        _2491 = (-_2673) + _2448;
        _2491 = ((-abs(_2491)) * 4.0f) + 1.0f;
        _2491 = max(_2491, 0.0f);
        _2491 = log2(_2491);
        _2491 *= _46_m39;
        _2491 = exp2(_2491);
        _210 = (_210 * _46_m25.xxx) + vs_TEXCOORD2.xyz;
        float2 _2711;
        if (_1570 != 0)
        {
            _2711 = _210.xy;
        }
        else
        {
            _2711 = _210.xz;
        }
        _2708 = float3(_2711.x, _2708.y, _2711.y);
        float2 _2724;
        if (_1562 != 0)
        {
            _2724 = _210.zy;
        }
        else
        {
            _2724 = _2708.xz;
        }
        _1451 = float3(_2724.x, _2724.y, _1451.z);
        _1802 = _46_m0.y * _46_m27;
        _210.x = _1802 * 0.60000002384185791015625f;
        _210.y = (-_46_m0.y) * _46_m27;
        float2 _2765 = (_1451.xy * float2(float2(_46_m26, _46_m26))) + _210.xy;
        _1451 = float3(_2765.x, _2765.y, _1451.z);
        _9.x = _RuneTex.Sample(sampler_RuneTex, _1451.xy).z;
        _1451.x = _9.x + (-0.3499999940395355224609375f);
        _1451.x *= 2.2222220897674560546875f;
        _1451.x = clamp(_1451.x, 0.0f, 1.0f);
        _2708.x = (_1451.x * (-2.0f)) + 3.0f;
        _1451.x *= _1451.x;
        _1451.x *= _2708.x;
        _1093.x = dot(_1093.xyz, _404);
        _1093.x = clamp(_1093.x, 0.0f, 1.0f);
        _1144.x = dot(_23, 0.33329999446868896484375f.xxx);
        _1130.x = log2(_1093.x);
        _1130.x *= _46_m20;
        _1130.x = exp2(_1130.x);
        _1130.x = (_1130.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
        _1144.x = _1130.x * _1144.x;
        _2708.x = _46_m0.y * _46_m22;
        _1802 = vs_TEXCOORD2.y * 0.699999988079071044921875f;
        _210.x = (_46_m0.y * _46_m22) + _1802;
        _210.x = (_2448 * 3.0f) + _210.x;
        _210.x = sin(_210.x);
        _2708.x = (_2708.x * 2.5f) + _1802;
        _2708.x = (_2448 * 3.0f) + _2708.x;
        _2708.x = sin(_2708.x);
        _1130.x = (-_210.x) + _2708.x;
        _1130.x = (_46_m58 * _1130.x) + _210.x;
        _1130.x = (_46_m23 * _1130.x) + 1.0f;
        _1093.x = (-_1093.x) + 1.0f;
        _1093.x = log2(_1093.x);
        _1093.x *= _46_m16;
        _1093.x = exp2(_1093.x);
        _1528 = _1258 * _46_m17.xyz;
        _1536 = _1258 * _46_m24.xyz;
        _1536 = _1451.xxx * _1536;
        _1536 *= _46_m28.xxx;
        _2509 = (_1390.x * _1390.x) + 1.0f;
        _1390.x = _46_m60 * 0.300000011920928955078125f;
        _2966 = (_46_m58 * 0.60000002384185791015625f) + _2509;
        _1536 = _2966.xxx * _1536;
        _1528 = (_1528 * float3(float3(_46_m19, _46_m19, _46_m19))) + _1536;
        _1536 = _2491.xxx * _46_m35.xyz;
        _2491 = (_2448 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _1536 = _2491.xxx * _1536;
        _1536 *= float3(float3(_46_m40, _46_m40, _46_m40));
        _2491 = (_55 * 2.0f) + 1.0f;
        _1528 = (_1536 * _2491.xxx) + _1528;
        _1536 = _980.xxx * _46_m29.xyz;
        _980 = (_55 * 1.5f) + _46_m58;
        _980 += 1.0f;
        _1528 = (_1536 * _980.xxx) + _1528;
        _1528 = _1144.xxx * _1528;
        _1528 *= _46_m18.xxx;
        _1528 = _1130.xxx * _1528;
        _980 = (_46_m58 * 2.0f) + _46_m60;
        _980 += 1.0f;
        float3 _3078 = _1093.xxx * _46_m15.xyz;
        _1093 = float4(_3078.x, _1093.y, _3078.y, _3078.z);
        _2509 += _46_m60;
        float3 _3089 = _1093.xzw * _2509.xxx;
        _1093 = float4(_3089.x, _1093.y, _3089.y, _3089.z);
        float3 _3098 = (_1528 * _980.xxx) + _1093.xzw;
        _1093 = float4(_3098.x, _1093.y, _3098.y, _3098.z);
        _55 *= _46_m46;
        _980 = (_1144.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _55 = (_55 * _980) + _1390.y;
        float3 _3125 = (_46_m41.xyz * _55.xxx) + _1093.xzw;
        _1093 = float4(_3125.x, _3125.y, _3125.z, _1093.w);
        _3128 = (-_1258) + 1.0f.xxx;
        _1258 = (_3128 * 0.5f.xxx) + _1258;
        float3 _3142 = (_1258 * _1390.xxx) + _1093.xyz;
        _1093 = float4(_3142.x, _3142.y, _3142.z, _1093.w);
        _30 += _1093.xyz;
        _30 = (-_70) + _30;
        _70 = (vs_TEXCOORD2.www * _30) + _70;
    }
    _3160 = float4(_70.x, _70.y, _70.z, _3160.w);
    _3160.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._3160 = _3160;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m7[4];
float4x4 unity_WorldToObject;
static float4 _21_m8[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m10[4];
float4 unity_LightmapST;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m8[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m8[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m8[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m8[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHAr
#define _21_m1 unity_SHAg
#define _21_m2 unity_SHAb
#define _21_m3 unity_SHBr
#define _21_m4 unity_SHBg
#define _21_m5 unity_SHBb
#define _21_m6 unity_SHC
#define _21_m9 unity_WorldTransformParams
#define _21_m11 unity_LightmapST
#define _21_m12 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float2 _100;
static float2 _113;
static float4 vs_TEXCOORD2;
static float4 _131;
static float4 _139;
static float3 _186;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;
static float3 vs_TEXCOORD7;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _186 : NORMAL;
    float4 _139 : TANGENT;
    float2 _100 : TEXCOORD0;
    float2 _113 : TEXCOORD1;
    float4 _131 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD7 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float3 _150;
static float _207;
static float3 _220;
static float3 _233;
static float3 _239;
static float4 _285;
static float3 _291;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _11.xxxx) + _9;
    _9 = (_21_m7[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m7[3];
    vs_TEXCOORD1 = (_21_m7[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m10[1];
    _9 = (_21_m10[0] * _45.xxxx) + _9;
    _9 = (_21_m10[2] * _45.zzzz) + _9;
    gl_Position = (_21_m10[3] * _45.wwww) + _9;
    float2 _110 = (_100 * _21_m12.xy) + _21_m12.zw;
    vs_TEXCOORD0 = float4(_110.x, _110.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _123 = (_113 * _21_m11.xy) + _21_m11.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _123.x, _123.y);
    vs_TEXCOORD2 = float4(_11.xyz.x, _11.xyz.y, _11.xyz.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _131.x;
    _9.x = _139.w * _21_m9.w;
    _150 = _139.yyy * _21_m7[1].yzx;
    _150 = (_21_m7[0].yzx * _139.xxx) + _150;
    _150 = (_21_m7[2].yzx * _139.zzz) + _150;
    _45.x = dot(_150, _150);
    _45.x = rsqrt(_45.x);
    _150 *= _45.xxx;
    _45.x = dot(_186, _21_m8[0].xyz);
    _45.y = dot(_186, _21_m8[1].xyz);
    _45.z = dot(_186, _21_m8[2].xyz);
    _207 = dot(_45.xyz, _45.xyz);
    _207 = rsqrt(_207);
    _45 = _207.xxxx * _45.xyzz;
    _220 = _150 * _45.zxy;
    _220 = (_45.yzx * _150.yzx) + (-_220);
    _233 = _9.xxx * _220.xzy;
    _239.y = _233.x;
    _239.x = _150.z;
    _239.z = _45.x;
    vs_TEXCOORD3 = _239;
    _233.x = _150.y;
    _150.y = _233.z;
    _150.z = _45.y;
    vs_TEXCOORD4 = _150;
    _233.z = _45.z;
    vs_TEXCOORD5 = _233;
    vs_TEXCOORD6 = _186;
    _220.x = _45.y * _45.y;
    _220.x = (_45.x * _45.x) + (-_220.x);
    _285 = _45.yzwx * _45.xywz;
    _291.x = dot(_21_m3, _285);
    _291.y = dot(_21_m4, _285);
    _291.z = dot(_21_m5, _285);
    _220 = (_21_m6.xyz * _220.xxx) + _291;
    _45.w = 1.0f;
    _291.x = dot(_21_m0, _45);
    _291.y = dot(_21_m1, _45);
    _291.z = dot(_21_m2, _45);
    vs_TEXCOORD7 = _220 + _291;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    _113 = stage_input._113;
    _131 = stage_input._131;
    _139 = stage_input._139;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _48_m3[4];
float _BumpScale;
float _RockEmission;
float4 _TopColor;
float4 _BottomColor;
float4 _HeightRange;
float _ShellBrightness;
float _BlockSize;
float _BlockVariation;
float _Gloss;
float _GlintStrength;
float4 _RimColor;
float _RimPower;
float4 _GlowColor;
float _GlowStrength;
float _InnerFill;
float _FacingPower;
float _Refraction;
float _PulseSpeed;
float _PulseAmount;
float4 _CoreColor;
float _CoreDepth;
float _CoreScale;
float _CoreSpeed;
float _CoreStrength;
float4 _RuneColor;
float _RuneDepth;
float _RuneCell;
float _RuneSpeed;
float _RuneDensity;
float _RuneBlink;
float4 _VeinColor;
float _VeinDepth;
float _VeinScale;
float _VeinSpeed;
float _VeinSharpness;
float _VeinStrength;
float4 _TouchColor;
float _HandRadius;
float _RippleSpeed;
float _RippleWidth;
float _RippleLife;
float _HandStrength;
float4 _CrackColor;
float _CrackScale;
float _CrackSpeed;
float _CrackReach;
float _CrackLife;
float _CrackOpen;
float _CrackGlow;
float _CrackDarken;
float _KevinActive;
float4 _KevinHands[2];
float4 _KevinRipples[4];
float _RiftAwake;
float _RiftCrack;
float _RiftFlash;
float4 _LightColor0;
void __unity_init()
{
    _48_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _48_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _48_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _48_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _48_m0 _Time
#define _48_m1 _WorldSpaceCameraPos
#define _48_m2 _WorldSpaceLightPos0
#define _48_m4 _BumpScale
#define _48_m5 _RockEmission
#define _48_m6 _TopColor
#define _48_m7 _BottomColor
#define _48_m8 _HeightRange
#define _48_m9 _ShellBrightness
#define _48_m10 _BlockSize
#define _48_m11 _BlockVariation
#define _48_m12 _Gloss
#define _48_m13 _GlintStrength
#define _48_m14 _RimColor
#define _48_m15 _RimPower
#define _48_m16 _GlowColor
#define _48_m17 _GlowStrength
#define _48_m18 _InnerFill
#define _48_m19 _FacingPower
#define _48_m20 _Refraction
#define _48_m21 _PulseSpeed
#define _48_m22 _PulseAmount
#define _48_m23 _CoreColor
#define _48_m24 _CoreDepth
#define _48_m25 _CoreScale
#define _48_m26 _CoreSpeed
#define _48_m27 _CoreStrength
#define _48_m28 _RuneColor
#define _48_m29 _RuneDepth
#define _48_m30 _RuneCell
#define _48_m31 _RuneSpeed
#define _48_m32 _RuneDensity
#define _48_m33 _RuneBlink
#define _48_m34 _VeinColor
#define _48_m35 _VeinDepth
#define _48_m36 _VeinScale
#define _48_m37 _VeinSpeed
#define _48_m38 _VeinSharpness
#define _48_m39 _VeinStrength
#define _48_m40 _TouchColor
#define _48_m41 _HandRadius
#define _48_m42 _RippleSpeed
#define _48_m43 _RippleWidth
#define _48_m44 _RippleLife
#define _48_m45 _HandStrength
#define _48_m46 _CrackColor
#define _48_m47 _CrackScale
#define _48_m48 _CrackSpeed
#define _48_m49 _CrackReach
#define _48_m50 _CrackLife
#define _48_m51 _CrackOpen
#define _48_m52 _CrackGlow
#define _48_m53 _CrackDarken
#define _48_m54 _KevinActive
#define _48_m55 _KevinHands
#define _48_m56 _KevinRipples
#define _48_m57 _RiftAwake
#define _48_m58 _RiftCrack
#define _48_m59 _RiftFlash
#define _48_m60 _LightColor0


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> _RuneTex;
SamplerState sampler_RuneTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD7;
static float4 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD6;
static float4 _3130;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD7 : TEXCOORD7;
};

struct SPIRV_Cross_Output
{
    float4 _3130 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _30;
static float3 _58;
static float _96;
static float3 _155;
static bool _167;
static bool2 _174;
static bool _191;
static float _215;
static float4 _232;
static bool _247;
static float3 _253;
static float2 _279;
static float4 _290;
static float _321;
static bool2 _446;
static bool _469;
static float3 _482;
static float _494;
static float _521;
static float _1020;
static float _1023;
static bool _1040;
static float _1047;
static int3 _1058;
static int _1069;
static bool _1073;
static float2 _1084;
static float3 _1106;
static float _1149;
static float3 _1161;
static float2 _1198;
static float3 _1212;
static float _1219;
static float3 _1315;
static float _1339;
static float _1349;
static float4 _1357;
static float3 _1452;
static float3 _1529;
static float3 _1536;
static int _1562;
static int _1570;
static bool _1573;
static int3 _1597;
static float3 _1616;
static float3 _1623;
static float2 _1680;
static int _1770;
static float _1802;
static bool _1864;
static bool _1870;
static bool2 _1937;
static float2 _1945;
static bool _1960;
static float _1965;
static float2 _2397;
static float _2448;
static float _2508;
static float _2672;
static float3 _2707;
static float _2810;
static float _2815;
static float _2948;
static float3 _3102;

void frag_inner()
{
    __unity_init();
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _30 = (_23 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _55 = _30.xy * _48_m4.xx;
    _30 = float3(_55.x, _55.y, _30.z);
    _58.x = dot(vs_TEXCOORD3, _30);
    _58.y = dot(vs_TEXCOORD4, _30);
    _58.z = dot(vs_TEXCOORD5, _30);
    _30.x = dot(_58, _58);
    _30.x = rsqrt(_30.x);
    _30 = _30.xxx * _58;
    _23 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
    _96 = dot(_30, _48_m2.xyz);
    _96 = (_96 * 0.5f) + 0.5f;
    _96 = clamp(_96, 0.0f, 1.0f);
    _96 += (-0.3499999940395355224609375f);
    _96 *= 2.2222220897674560546875f;
    _96 = clamp(_96, 0.0f, 1.0f);
    _58.x = (_96 * (-2.0f)) + 3.0f;
    _96 *= _96;
    _96 *= _58.x;
    _58 = (_48_m60.xyz * _96.xxx) + vs_TEXCOORD7;
    _96 = (-vs_TEXCOORD2.w) + 1.0f;
    _96 *= _48_m5;
    _155 = _23 * _96.xxx;
    _155 = (_9 * _58) + _155;
    _167 = 0.5f < _48_m54;
    float4 _187 = float4(_48_m58, _48_m59, _48_m58, _48_m58);
    _174 = bool4(float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).x < _187.x, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).y < _187.y, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).z < _187.z, float4(0.001000000047497451305389404296875f, 0.001000000047497451305389404296875f, 0.0f, 0.0f).w < _187.w).xy;
    _191 = _167 || _174.x;
    _191 = _174.y || _191;
    _174.x = vs_TEXCOORD2.w < 0.9900000095367431640625f;
    _191 = _191 && _174.x;
    if (_191)
    {
        if (_167)
        {
            _215 = _48_m0.y + (-_48_m56[0].w);
            _174.x = _48_m56[0].w >= 0.001000000047497451305389404296875f;
            _174.y = _215 >= 0.0f;
            _232.x = float(_174.x);
            _232.y = float(_174.y);
            _232.x = _232.y * _232.x;
            _247 = _48_m50 >= _215;
            _253.x = float(_247);
            _232.x = _253.x * _232.x;
            _253 = vs_TEXCOORD1 + (-_48_m56[0].xyz);
            _253.x = dot(_253, _253);
            _253.x = sqrt(_253.x);
            _279.x = (_215 * _48_m48) + (-_253.x);
            float2 _300 = float2(_48_m50, _48_m49) * float2(0.550000011920928955078125f, 0.449999988079071044921875f);
            _290 = float4(_300.x, _300.y, _290.z, _290.w);
            _215 = ((-_48_m50) * 0.449999988079071044921875f) + _215;
            float2 _312 = 1.0f.xx / _290.xy;
            _290 = float4(_312.x, _312.y, _290.z, _290.w);
            _215 *= _290.x;
            _215 = clamp(_215, 0.0f, 1.0f);
            _321 = (_215 * (-2.0f)) + 3.0f;
            _215 *= _215;
            _215 = ((-_321) * _215) + 1.0f;
            _253.x = ((-_48_m49) * 0.550000011920928955078125f) + _253.x;
            _253.x = _290.y * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _321 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_321) * _253.x) + 1.0f;
            _215 *= _253.x;
            _215 = _232.x * _215;
            _232.x = _279.x + 0.20000000298023223876953125f;
            _232.x *= 2.8571426868438720703125f;
            _232.x = clamp(_232.x, 0.0f, 1.0f);
            _253.x = (_232.x * (-2.0f)) + 3.0f;
            _232.x *= _232.x;
            _232.x *= _253.x;
            _232.x = _215 * _232.x;
            _232.x = max(_232.x, 0.0f);
            _253.x = _279.x * (-_279.x);
            _253.x *= 40.0f;
            _253.x = exp2(_253.x);
            _215 *= _253.x;
            _215 = max(_215, 0.0f);
            _253.x = _48_m0.y + (-_48_m56[1].w);
            _446.x = _48_m56[1].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m50 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m56[1].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m48) + (-_321);
            _253.x = ((-_48_m50) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _521 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_521) * _253.x) + 1.0f;
            _321 = ((-_48_m49) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _521 = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_521) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _279.x = _494 * (-_494);
            _279.x *= 40.0f;
            _279.x = exp2(_279.x);
            _253.x *= _279.x;
            _215 = max(_215, _253.x);
            _253.x = _48_m0.y + (-_48_m56[2].w);
            _446.x = _48_m56[2].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m50 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m56[2].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m48) + (-_321);
            _253.x = ((-_48_m50) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _521 = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_521) * _253.x) + 1.0f;
            _321 = ((-_48_m49) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _521 = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_521) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _279.x = _494 * (-_494);
            _279.x *= 40.0f;
            _279.x = exp2(_279.x);
            _253.x *= _279.x;
            _215 = max(_215, _253.x);
            _253.x = _48_m0.y + (-_48_m56[3].w);
            _446.x = _48_m56[3].w >= 0.001000000047497451305389404296875f;
            _446.y = _253.x >= 0.0f;
            _279.x = float(_446.x);
            _279.y = float(_446.y);
            _279.x = _279.y * _279.x;
            _469 = _48_m50 >= _253.x;
            _321 = float(_469);
            _279.x = _321 * _279.x;
            _482 = vs_TEXCOORD1 + (-_48_m56[3].xyz);
            _321 = dot(_482, _482);
            _321 = sqrt(_321);
            _494 = (_253.x * _48_m48) + (-_321);
            _253.x = ((-_48_m50) * 0.449999988079071044921875f) + _253.x;
            _253.x = _290.x * _253.x;
            _253.x = clamp(_253.x, 0.0f, 1.0f);
            _290.x = (_253.x * (-2.0f)) + 3.0f;
            _253.x *= _253.x;
            _253.x = ((-_290.x) * _253.x) + 1.0f;
            _321 = ((-_48_m49) * 0.550000011920928955078125f) + _321;
            _321 = _290.y * _321;
            _321 = clamp(_321, 0.0f, 1.0f);
            _290.x = (_321 * (-2.0f)) + 3.0f;
            _321 *= _321;
            _321 = ((-_290.x) * _321) + 1.0f;
            _253.x = _321 * _253.x;
            _253.x = _279.x * _253.x;
            _279.x = _494 + 0.20000000298023223876953125f;
            _279.x *= 2.8571426868438720703125f;
            _279.x = clamp(_279.x, 0.0f, 1.0f);
            _321 = (_279.x * (-2.0f)) + 3.0f;
            _279.x *= _279.x;
            _279.x *= _321;
            _279.x = _253.x * _279.x;
            _232.x = max(_279.x, _232.x);
            _290.x = _494 * (-_494);
            _290.x *= 40.0f;
            _290.x = exp2(_290.x);
            _290.x = _253.x * _290.x;
            _290.x = max(_215, _290.x);
            _1020 = _290.x;
            _1023 = _232.x;
        }
        else
        {
            _1020 = 0.0f;
            _1023 = 0.0f;
        }
        _96 = min(_48_m59, 1.0f);
        _96 *= 0.300000011920928955078125f;
        _96 = max(_96, _48_m58);
        _96 = max(_96, _1023);
        _1040 = 0.00200000009499490261077880859375f < _96;
        if (_1040)
        {
            _1047 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
            _1058.x = int((_1047 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
            _1069 = ~_1058.x;
            _1073 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
            _1069 = _1073 ? _1069 : 0;
            bool2 _1093 = (_1069 != 0).xx;
            _1084 = float2(_1093.x ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).x : float2(0.709999978542327880859375f, 0.189999997615814208984375f).x, _1093.y ? float2(0.37000000476837158203125f, 0.61000001430511474609375f).y : float2(0.709999978542327880859375f, 0.189999997615814208984375f).y);
            float2 _1099;
            if (_1058.x != 0)
            {
                _1099 = 0.0f.xx;
            }
            else
            {
                _1099 = _1084;
            }
            _1084 = _1099;
            float2 _1109;
            if (_1069 != 0)
            {
                _1109 = vs_TEXCOORD2.xy;
            }
            else
            {
                _1109 = vs_TEXCOORD2.xz;
            }
            _1106 = float3(_1109.x, _1109.y, _1106.z);
            float2 _1123;
            if (_1058.x != 0)
            {
                _1123 = vs_TEXCOORD2.zy;
            }
            else
            {
                _1123 = _1106.xy;
            }
            _482 = float3(_1123.x, _1123.y, _482.z);
            float2 _1140 = _482.xy / _48_m47.xx;
            _482 = float3(_1140.x, _1140.y, _482.z);
            float2 _1146 = _1084 + _482.xy;
            _482 = float3(_1146.x, _1146.y, _482.z);
            _1149 = _RuneTex.Sample(sampler_RuneTex, _482.xy).w;
            _1047 = _96 * _48_m52;
            float2 _1172 = ((-_48_m51.xx) * _96.xx) + float2(1.0f, 0.7799999713897705078125f);
            _1161 = float3(_1172.x, _1172.y, _1161.z);
            float2 _1180 = _1149.xx + (-_1161.xy);
            _1161 = float3(_1180.x, _1180.y, _1161.z);
            float2 _1188 = _1161.xy * float2(12.5f, 4.5454540252685546875f);
            _1161 = float3(_1188.x, _1188.y, _1161.z);
            float2 _1195 = clamp(_1161.xy, 0.0f.xx, 1.0f.xx);
            _1161 = float3(_1195.x, _1195.y, _1161.z);
            _1198 = (_1161.xy * (-2.0f).xx) + 3.0f.xx;
            float2 _1209 = _1161.xy * _1161.xy;
            _1161 = float3(_1209.x, _1209.y, _1161.z);
            float2 _1216 = _1161.xy * _1198;
            _1212 = float3(_1216.x, _1212.y, _1216.y);
            _1219 = ((-_1198.x) * _1161.x) + 1.0f;
            _1219 *= _1212.z;
            _96 *= _1219;
            _1219 = (_1212.x * 0.60000002384185791015625f) + _96;
            _1219 = clamp(_1219, 0.0f, 1.0f);
            _1219 = ((-_1219) * _48_m53) + 1.0f;
            _1161.x = _1149 * 23.0f;
            _482.x = (_48_m0.y * 11.0f) + _1161.x;
            _482.x = sin(_482.x);
            _482.x = (_482.x * 0.25f) + 0.75f;
            _1161.x = _1020 * 3.0f;
            _1047 = (_1047 * _482.x) + _1161.x;
            _96 *= _48_m52;
            _96 *= 0.07999999821186065673828125f;
            _96 = (_1212.x * _1047) + _96;
            _1161 = _96.xxx * _48_m46.xyz;
            _96 = _48_m59 + 1.0f;
            _1161 = _96.xxx * _1161;
            _1161 = (_155 * _1219.xxx) + _1161;
            _1315 = _155 + (-_1161);
            _155 = (vs_TEXCOORD2.www * _1315) + _1161;
        }
    }
    _1040 = 0.00999999977648258209228515625f < vs_TEXCOORD2.w;
    if (_1040)
    {
        _482 = (-vs_TEXCOORD1) + _48_m1;
        _1339 = dot(_482, _482);
        _1339 = rsqrt(_1339);
        _1106 = _1339.xxx * _482;
        _1349 = vs_TEXCOORD2.y + (-_48_m8.x);
        _1357.x = (-_48_m8.x) + _48_m8.y;
        _1357.x = max(_1357.x, 0.001000000047497451305389404296875f);
        _1349 /= _1357.x;
        _1349 = clamp(_1349, 0.0f, 1.0f);
        _1161 = _48_m6.xyz + (-_48_m7.xyz);
        _1161 = (_1349.xxx * _1161) + _48_m7.xyz;
        _1315 = (_482 * _1339.xxx) + _48_m2.xyz;
        _96 = dot(_1315, _1315);
        _96 = rsqrt(_96);
        _1315 = _96.xxx * _1315;
        _96 = dot(_30, _1315);
        _96 = clamp(_96, 0.0f, 1.0f);
        _96 = log2(_96);
        _96 *= _48_m12;
        _96 = exp2(_96);
        _96 += (-0.60000002384185791015625f);
        _96 *= 10.000003814697265625f;
        _96 = clamp(_96, 0.0f, 1.0f);
        _1047 = (_96 * (-2.0f)) + 3.0f;
        _96 *= _96;
        _96 *= _1047;
        _96 *= _48_m13;
        _1047 = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
        _1452 = vs_TEXCOORD2.xyz / _48_m10.xxx;
        _1452 = floor(_1452);
        _1452 *= float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
        _1452 = frac(_1452);
        _482 = _1452.yxz + 33.3300018310546875f.xxx;
        _482.x = dot(_1452, _482);
        _1452 += _482.xxx;
        _1452.x = _1452.y + _1452.x;
        _1452.x = _1452.z * _1452.x;
        _1452.x = frac(_1452.x);
        _1047 *= 2.2000000476837158203125f;
        _1315 = _1047.xxx * _1161;
        _1047 = _1452.x + (-0.5f);
        _1047 = dot(_1047.xx, _48_m11.xx);
        _1047 += 1.0f;
        _1315 = _1047.xxx * _1315;
        _1315 *= _48_m9.xxx;
        _1529 = _96.xxx * _48_m60.xyz;
        _1536 = (_1161 * 1.5f.xxx) + (-1.0f).xxx;
        _1536 = (_1536 * 0.5f.xxx) + 1.0f.xxx;
        _1529 *= _1536;
        _58 = (_1315 * _58) + _1529;
        _96 = max(abs(vs_TEXCOORD6.z), abs(vs_TEXCOORD6.y));
        _1562 = int((_96 < abs(vs_TEXCOORD6.x)) ? 4294967295u : 0u);
        _1570 = ~_1562;
        _1573 = abs(vs_TEXCOORD6.y) < abs(vs_TEXCOORD6.z);
        _1570 = _1573 ? _1570 : 0;
        _1058 = int3(uint3(bool4(0.0f.xxxx.x < vs_TEXCOORD6.xzyx.x, 0.0f.xxxx.y < vs_TEXCOORD6.xzyx.y, 0.0f.xxxx.z < vs_TEXCOORD6.xzyx.z, 0.0f.xxxx.w < vs_TEXCOORD6.xzyx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1597 = int3(uint3(bool4(vs_TEXCOORD6.xzyx.x < 0.0f.xxxx.x, vs_TEXCOORD6.xzyx.y < 0.0f.xxxx.y, vs_TEXCOORD6.xzyx.z < 0.0f.xxxx.z, vs_TEXCOORD6.xzyx.w < 0.0f.xxxx.w).xyz) * uint3(4294967295u, 4294967295u, 4294967295u));
        _1058 = (-_1058) + _1597;
        _1357.x = float(_1058.x);
        _1357.y = 0.0f;
        _1357.z = 0.0f;
        _1616.x = 0.0f;
        _1616.y = 0.0f;
        _1616.z = float(_1058.y);
        _1623.x = 0.0f;
        _1623.z = 0.0f;
        _1623.y = float(_1058.z);
        float3 _1633;
        if (_1570 != 0)
        {
            _1633 = _1616;
        }
        else
        {
            _1633 = _1623;
        }
        _482 = _1633;
        float3 _1642;
        if (_1562 != 0)
        {
            _1642 = _1357.xyz;
        }
        else
        {
            _1642 = _482;
        }
        _482 = _1642;
        float3 _1655 = _1106.yyy * _48_m3[1].xyz;
        _1357 = float4(_1655.x, _1655.y, _1655.z, _1357.w);
        float3 _1666 = (_48_m3[0].xyz * _1106.xxx) + _1357.xyz;
        _1357 = float4(_1666.x, _1666.y, _1666.z, _1357.w);
        float3 _1677 = (_48_m3[2].xyz * _1106.zzz) + _1357.xyz;
        _1357 = float4(_1677.x, _1677.y, _1677.z, _1357.w);
        _1680.x = dot(_1357.xyz, _1357.xyz);
        _1680.x = rsqrt(_1680.x);
        float3 _1695 = _1680.xxx * _1357.xyz;
        _1357 = float4(_1695.x, _1695.y, _1695.z, _1357.w);
        _1616 = _30.yyy * _48_m3[1].xyz;
        _1616 = (_48_m3[0].xyz * _30.xxx) + _1616;
        _1616 = (_48_m3[2].xyz * _30.zzz) + _1616;
        _1680.x = dot(_1616, _1616);
        _1680.x = rsqrt(_1680.x);
        _482.x = dot(_1357.xyz, _482);
        _482.x = max(abs(_482.x), 0.300000011920928955078125f);
        _482 = (-_1357.xyz) / _482.xxx;
        float3 _1750 = (_1616 * _1680.xxx) + (-vs_TEXCOORD6);
        _1357 = float4(_1750.x, _1750.y, _1750.z, _1357.w);
        _482 = (_1357.xyz * float3(float3(_48_m20, _48_m20, _48_m20))) + _482;
        _1770 = int(uint(_1570) | uint(_1562));
        _1339 = _48_m0.y * _48_m31;
        _1680.x = asfloat(uint(_1770) & asuint(_1339));
        if (_167)
        {
            float3 _1799 = vs_TEXCOORD1 + (-_48_m55[0].xyz);
            _1357 = float4(_1799.x, _1799.y, _1799.z, _1357.w);
            _1802 = dot(_1357.xyz, _1357.xyz);
            _1802 = sqrt(_1802);
            _1802 /= _48_m41;
            _1802 = (-_1802) + 1.0f;
            _1802 = clamp(_1802, 0.0f, 1.0f);
            _1802 *= _48_m55[0].w;
            _1802 = max(_1802, 0.0f);
            float3 _1831 = vs_TEXCOORD1 + (-_48_m55[1].xyz);
            _1357 = float4(_1831.x, _1831.y, _1831.z, _1357.w);
            _1339 = dot(_1357.xyz, _1357.xyz);
            _1339 = sqrt(_1339);
            _1339 /= _48_m41;
            _1339 = (-_1339) + 1.0f;
            _1339 = clamp(_1339, 0.0f, 1.0f);
            _1339 *= _48_m55[1].w;
            _1357.x = max(_1802, _1339);
            _1802 = _48_m0.y + (-_48_m56[0].w);
            _1864 = _48_m56[0].w >= 0.001000000047497451305389404296875f;
            _1339 = float(_1864);
            _1870 = _1802 >= 0.0f;
            _1349 = float(_1870);
            _1339 *= _1349;
            _1870 = _48_m44 >= _1802;
            _1349 = float(_1870);
            _1339 *= _1349;
            _1616 = vs_TEXCOORD1 + (-_48_m56[0].xyz);
            _1349 = dot(_1616, _1616);
            _1349 = sqrt(_1349);
            _1349 = ((-_1802) * _48_m42) + _1349;
            _1349 /= _48_m43;
            _1349 *= (-_1349);
            _1349 *= 1.44270002841949462890625f;
            _1349 = exp2(_1349);
            _1802 /= _48_m44;
            _1802 = (-_1802) + 1.0f;
            _1802 *= _1349;
            _1349 = _48_m0.y + (-_48_m56[1].w);
            _1937.x = _48_m56[1].w >= 0.001000000047497451305389404296875f;
            _1937.y = _1349 >= 0.0f;
            _1945.x = float(_1937.x);
            _1945.y = float(_1937.y);
            _1945.x = _1945.y * _1945.x;
            _1960 = _48_m44 >= _1349;
            _1965 = float(_1960);
            _1945.x = _1965 * _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m56[1].xyz);
            _1965 = dot(_1616, _1616);
            _1965 = sqrt(_1965);
            _1965 = ((-_1349) * _48_m42) + _1965;
            _1965 /= _48_m43;
            _1965 *= (-_1965);
            _1965 *= 1.44270002841949462890625f;
            _1965 = exp2(_1965);
            _1349 /= _48_m44;
            _1349 = (-_1349) + 1.0f;
            _1349 *= _1965;
            _1349 = _1945.x * _1349;
            _1802 = (_1802 * _1339) + _1349;
            _1339 = _48_m0.y + (-_48_m56[2].w);
            _1870 = _48_m56[2].w >= 0.001000000047497451305389404296875f;
            _1349 = float(_1870);
            _1937.x = _1339 >= 0.0f;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1937.x = _48_m44 >= _1339;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m56[2].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_1339) * _48_m42) + _1945.x;
            _1945.x /= _48_m43;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _1339 /= _48_m44;
            _1339 = (-_1339) + 1.0f;
            _1339 *= _1945.x;
            _1802 = (_1339 * _1349) + _1802;
            _1339 = _48_m0.y + (-_48_m56[3].w);
            _1870 = _48_m56[3].w >= 0.001000000047497451305389404296875f;
            _1349 = float(_1870);
            _1937.x = _1339 >= 0.0f;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1937.x = _48_m44 >= _1339;
            _1945.x = float(_1937.x);
            _1349 *= _1945.x;
            _1616 = vs_TEXCOORD1 + (-_48_m56[3].xyz);
            _1945.x = dot(_1616, _1616);
            _1945.x = sqrt(_1945.x);
            _1945.x = ((-_1339) * _48_m42) + _1945.x;
            _1945.x /= _48_m43;
            _1945.x *= (-_1945.x);
            _1945.x *= 1.44270002841949462890625f;
            _1945.x = exp2(_1945.x);
            _1339 /= _48_m44;
            _1339 = (-_1339) + 1.0f;
            _1339 *= _1945.x;
            _1357.y = (_1339 * _1349) + _1802;
            _1315 = float3(_1357.xy.x, _1357.xy.y, _1315.z);
        }
        else
        {
            _1315.x = 0.0f;
            _1315.y = 0.0f;
        }
        _96 = _1315.x * _1315.x;
        float3 _2233 = (_482 * _48_m29.xxx) + vs_TEXCOORD2.xyz;
        _1357 = float4(_2233.x, _2233.y, _2233.z, _1357.w);
        float2 _2238;
        if (_1570 != 0)
        {
            _2238 = _1357.xy;
        }
        else
        {
            _2238 = _1357.xz;
        }
        _1357 = float4(_2238.x, _1357.y, _1357.z, _2238.y);
        float2 _2251;
        if (_1562 != 0)
        {
            _2251 = _1357.zy;
        }
        else
        {
            _2251 = _1357.xw;
        }
        _1357 = float4(_2251.x, _2251.y, _1357.z, _1357.w);
        _1357.z = (-_1680.x) + _1357.y;
        _1680 = _1357.xz / float2(float2(_48_m30, _48_m30));
        _232 = floor(_1680.xyxy);
        _1339 = (_1570 != 0) ? 37.0f : 74.0f;
        _1339 = (_1562 != 0) ? 0.0f : _1339;
        _232 += _1339.xxxx;
        float2 _2302 = _232.zw * float2(123.339996337890625f, 456.209991455078125f);
        _1357 = float4(_2302.x, _2302.y, _1357.z, _1357.w);
        float2 _2307 = frac(_1357.xy);
        _1357 = float4(_2307.x, _2307.y, _1357.z, _1357.w);
        _1945 = _1357.xy + 45.31999969482421875f.xx;
        _1339 = dot(_1357.xy, _1945);
        float2 _2323 = _1339.xx + _1357.xy;
        _1357 = float4(_2323.x, _2323.y, _1357.z, _1357.w);
        _1339 = _1357.y * _1357.x;
        _1339 = frac(_1339);
        _232 += float4(17.3099994659423828125f, 17.3099994659423828125f, 5.730000019073486328125f, 5.730000019073486328125f);
        _232 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
        _232 = frac(_232);
        _290 = _232 + 45.31999969482421875f.xxxx;
        _1349 = dot(_232.xy, _290.xy);
        float2 _2355 = _232.xy + _1349.xx;
        _1357 = float4(_2355.x, _2355.y, _1357.z, _1357.w);
        _1349 = _1357.y * _1357.x;
        _1349 = frac(_1349);
        _1357.x = dot(_232.zw, _290.zw);
        float2 _2375 = _232.zw + _1357.xx;
        _1357 = float4(_2375.x, _2375.y, _1357.z, _1357.w);
        _1357.x = _1357.y * _1357.x;
        _1357.x = frac(_1357.x);
        _1529 = _1339.xxx * float3(16.0f, 13.69999980926513671875f, 40.0f);
        _1047 = floor(_1529.x);
        _2397 = frac(_1680);
        _1339 = _1047 * 0.25f;
        _1960 = _1339 >= (-_1339);
        _1616.x = frac(_1339);
        float _2411;
        if (_1960)
        {
            _2411 = _1616.x;
        }
        else
        {
            _2411 = -_1616.x;
        }
        _1965 = _2411;
        _1616.x = _1965 * 4.0f;
        _1616.y = floor(_1339);
        _2397 += _1616.xy;
        _2397 *= 0.25f.xx;
        float2 _2436 = ddx_coarse(_1680);
        _1616 = float3(_2436.x, _2436.y, _1616.z);
        float2 _2441 = _1616.xy * 0.25f.xx;
        _1616 = float3(_2441.x, _2441.y, _1616.z);
        _1680 = ddy_coarse(_1680);
        _1680 *= 0.25f.xx;
        _2448 = _RuneTex.SampleGrad(sampler_RuneTex, _2397, float4(_1616.xyxx).xy, float4(_1680.xyxx).xy).x;
        _1802 = _48_m0.y * _48_m33;
        _1047 = (_1349 * 0.800000011920928955078125f) + 0.60000002384185791015625f;
        _1802 = (_1802 * _1047) + _1529.y;
        _1802 = frac(_1802);
        _1047 = _1802 * 12.5f;
        _1047 = min(_1047, 1.0f);
        _1219 = (_1047 * (-2.0f)) + 3.0f;
        _1047 *= _1047;
        _1047 *= _1219;
        _1219 = _1802 + (-0.550000011920928955078125f);
        _1219 *= (-4.999999523162841796875f);
        _1219 = clamp(_1219, 0.0f, 1.0f);
        _2508 = (_1219 * (-2.0f)) + 3.0f;
        _1219 *= _1219;
        _1219 *= _2508;
        _1047 *= _1219;
        _1802 = (_48_m0.y * 23.0f) + _1529.z;
        _1802 = sin(_1802);
        _1802 = (_1802 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
        _1802 *= _1047;
        _1047 = (-_48_m32) + 1.0f;
        _1047 *= _48_m57;
        _1047 = (_1047 * 0.699999988079071044921875f) + _48_m32;
        _1864 = _1047 >= _1357.x;
        _1047 = float(_1864);
        _1047 = _1802 * _1047;
        _1219 = _1315.x + (-0.0500000007450580596923828125f);
        _1219 *= 1.53846156597137451171875f;
        _1219 = clamp(_1219, 0.0f, 1.0f);
        _2508 = (_1219 * (-2.0f)) + 3.0f;
        _1219 *= _1219;
        _1219 *= _2508;
        _1047 = max(_1047, _1219);
        _1047 = _2448 * _1047;
        float3 _2594 = (_482 * _48_m35.xxx) + vs_TEXCOORD2.xyz;
        _1357 = float4(_2594.x, _2594.y, _2594.z, _1357.w);
        float2 _2599;
        if (_1570 != 0)
        {
            _2599 = _1357.xy;
        }
        else
        {
            _2599 = _1357.xz;
        }
        _1680 = _2599;
        float2 _2610;
        if (_1562 != 0)
        {
            _2610 = _1357.zy;
        }
        else
        {
            _2610 = _1680;
        }
        _1680 = _2610;
        float2 _2628 = _1680 * float2(float2(_48_m36, _48_m36));
        _1357 = float4(_2628.x, _2628.y, _1357.z, _1357.w);
        _1339 = _48_m0.y * _48_m37;
        _232 = _1339.xxxx * float4(0.12999999523162841796875f, 0.310000002384185791015625f, -0.20999999344348907470703125f, 0.17000000178813934326171875f);
        _1680 = (_1680 * float2(float2(_48_m36, _48_m36))) + _232.xy;
        _2448 = _RuneTex.Sample(sampler_RuneTex, _1680).y;
        float2 _2669 = (_1357.xy * 1.37000000476837158203125f.xx) + _232.zw;
        _1357 = float4(_2669.x, _2669.y, _1357.z, _1357.w);
        _2672 = _RuneTex.Sample(sampler_RuneTex, _1357.xy).y;
        _1219 = (-_2672) + _2448;
        _1219 = ((-abs(_1219)) * 4.0f) + 1.0f;
        _1219 = max(_1219, 0.0f);
        _1219 = log2(_1219);
        _1219 *= _48_m38;
        _1219 = exp2(_1219);
        _482 = (_482 * _48_m24.xxx) + vs_TEXCOORD2.xyz;
        float2 _2710;
        if (_1570 != 0)
        {
            _2710 = _482.xy;
        }
        else
        {
            _2710 = _482.xz;
        }
        _2707 = float3(_2710.x, _2707.y, _2710.y);
        float2 _2723;
        if (_1562 != 0)
        {
            _2723 = _482.zy;
        }
        else
        {
            _2723 = _2707.xz;
        }
        _1452 = float3(_2723.x, _2723.y, _1452.z);
        _1802 = _48_m0.y * _48_m26;
        _482.x = _1802 * 0.60000002384185791015625f;
        _482.y = (-_48_m0.y) * _48_m26;
        float2 _2764 = (_1452.xy * float2(float2(_48_m25, _48_m25))) + _482.xy;
        _1452 = float3(_2764.x, _2764.y, _1452.z);
        _9.x = _RuneTex.Sample(sampler_RuneTex, _1452.xy).z;
        _1452.x = _9.x + (-0.3499999940395355224609375f);
        _1452.x *= 2.2222220897674560546875f;
        _1452.x = clamp(_1452.x, 0.0f, 1.0f);
        _2707.x = (_1452.x * (-2.0f)) + 3.0f;
        _1452.x *= _1452.x;
        _1452.x *= _2707.x;
        _30.x = dot(_30, _1106);
        _30.x = clamp(_30.x, 0.0f, 1.0f);
        _2810 = dot(_23, 0.33329999446868896484375f.xxx);
        _2815 = log2(_30.x);
        _2815 *= _48_m19;
        _2815 = exp2(_2815);
        _2815 = (_2815 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
        _2810 = _2815 * _2810;
        _2707.x = _48_m0.y * _48_m21;
        _1802 = vs_TEXCOORD2.y * 0.699999988079071044921875f;
        _482.x = (_48_m0.y * _48_m21) + _1802;
        _482.x = (_2448 * 3.0f) + _482.x;
        _482.x = sin(_482.x);
        _2707.x = (_2707.x * 2.5f) + _1802;
        _2707.x = (_2448 * 3.0f) + _2707.x;
        _2707.x = sin(_2707.x);
        _2815 = (-_482.x) + _2707.x;
        _2815 = (_48_m57 * _2815) + _482.x;
        _2815 = (_48_m22 * _2815) + 1.0f;
        _30.x = (-_30.x) + 1.0f;
        _30.x = log2(_30.x);
        _30.x *= _48_m15;
        _30.x = exp2(_30.x);
        _1529 = _1161 * _48_m16.xyz;
        _1536 = _1161 * _48_m23.xyz;
        _1536 = _1452.xxx * _1536;
        _1536 *= _48_m27.xxx;
        _2508 = (_1315.x * _1315.x) + 1.0f;
        _1315.x = _48_m59 * 0.300000011920928955078125f;
        _2948 = (_48_m57 * 0.60000002384185791015625f) + _2508;
        _1536 = _2948.xxx * _1536;
        _1529 = (_1529 * float3(float3(_48_m18, _48_m18, _48_m18))) + _1536;
        _1536 = _1219.xxx * _48_m34.xyz;
        _1219 = (_2448 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _1536 = _1219.xxx * _1536;
        _1536 *= float3(float3(_48_m39, _48_m39, _48_m39));
        _1219 = (_96 * 2.0f) + 1.0f;
        _1529 = (_1536 * _1219.xxx) + _1529;
        _1536 = _1047.xxx * _48_m28.xyz;
        _1047 = (_96 * 1.5f) + _48_m57;
        _1047 += 1.0f;
        _1529 = (_1536 * _1047.xxx) + _1529;
        _1529 = _2810.xxx * _1529;
        _1529 *= _48_m17.xxx;
        _1529 = _2815.xxx * _1529;
        _2815 = (_48_m57 * 2.0f) + _48_m59;
        _2815 += 1.0f;
        _1536 = _30.xxx * _48_m14.xyz;
        _30.x = _2508 + _48_m59;
        _1536 = _30.xxx * _1536;
        _1529 = (_1529 * _2815.xxx) + _1536;
        _30.x = _96 * _48_m45;
        _2810 = (_2810 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
        _30.x = (_30.x * _2810) + _1315.y;
        _30 = (_48_m40.xyz * _30.xxx) + _1529;
        _3102 = (-_1161) + 1.0f.xxx;
        _1161 = (_3102 * 0.5f.xxx) + _1161;
        _30 = (_1161 * _1315.xxx) + _30;
        _30 += _58;
        _30 = (-_155) + _30;
        _155 = (vs_TEXCOORD2.www * _30) + _155;
    }
    _3130 = float4(_155.x, _155.y, _155.z, _3130.w);
    _3130.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._3130 = _3130;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "VertexLit"
}