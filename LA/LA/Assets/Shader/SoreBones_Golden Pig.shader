// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SoreBones/Golden Pig" {
Properties {

[Toggle(_MONEY_MODE)] _MoneyMode ("Render As Money (off = Glass Shell)", Float) = 0.0

[Header(Money Fill)] _Fill ("Fill Amount", Range(0, 1)) = 0.6000000238418579

[ToggleUI] _FillWorldSpace ("Fill Along World Up", Float) = 0.0

_MoneyTex ("Money Texture", 2D) = "white" { }

_MoneyColor ("Money Tint", Color) = (0.55,0.75,0.45,1)

_CapTiling ("Top Face Tiling", Float) = 1.0

_CapSurfaceGlow ("Top Face Glow", Range(0, 1)) = 0.25

_FillYMin ("Fill Bottom (Object Y)", Float) = -0.5

_FillYMax ("Fill Top (Object Y)", Float) = 0.5

_FillNoise ("Fill Surface Unevenness", Range(0, 0.3)) = 0.05999999865889549

_FillNoiseScale ("Fill Noise Scale", Float) = 8.0

_DepthDarken ("Deep Money Darkening", Range(0, 1)) = 0.44999998807907104

_SurfaceBand ("Surface Highlight Band", Range(0.001, 0.5)) = 0.14000000059604645

_SurfaceGlow ("Surface Highlight Strength", Range(0, 3)) = 1.2000000476837158

_InteriorTint ("Interior Gold Tint", Range(0, 1)) = 0.25

_InteriorBrightness ("Interior Brightness", Range(0, 2)) = 0.8999999761581421

[Header(Golden Glass Shell)] _GlassColor ("Glass Color", Color) = (1,0.78,0.3,1)

_GlassAlpha ("Glass Base Alpha", Range(0, 1)) = 0.14000000059604645

[Header(Refraction  reads the scene GrabPass)] [Toggle(_REFRACTION)] _UseRefraction ("Enable Scene Refraction", Float) = 1.0

_RefractStrength ("Refraction Strength", Range(0, 0.2)) = 0.05000000074505806

_AbsorbColor ("Gold Absorption", Color) = (1,0.7,0.25,1)

_AbsorbDensity ("Absorption Density", Range(0, 4)) = 1.399999976158142

_RefractTint ("Refraction Clarity", Range(0, 1)) = 0.699999988079071

[Header(Glass Surface Detail)] _BumpMap ("Normal Map", 2D) = "bump" { }

_BumpScale ("Normal Strength", Range(0, 3)) = 1.0

[Toggle(_MASKMAP)] _UseMaskMap ("Use Mask Map (A) for Roughness", Float) = 0.0

_MaskMap ("Mask Map", 2D) = "white" { }

[ToggleUI] _MaskAlphaIsRoughness ("Mask Alpha is Roughness (else Smoothness)", Float) = 1.0

_Smoothness ("Smoothness", Range(0, 1)) = 0.8999999761581421

[Header(Baked Shading)] [Toggle(_AO_ON)] _AOEnabled ("Enable Baked Shading", Float) = 0.0

_AO ("Baked Shading", 2D) = "white" { }

[ToggleUI] _AOUseUV1 ("Sample on UV1 (off = UV0)", Float) = 0.0

_AOStrength ("Baked Shading Strength", Range(0, 1)) = 1.0

[Header(Reflection and Specular)] _FresnelColor ("Fresnel Rim Color", Color) = (1,0.9,0.5,1)

_FresnelPower ("Fresnel Power", Range(0.2, 10)) = 3.0

_FresnelIntensity ("Fresnel Intensity", Range(0, 2)) = 1.0

_FresnelAlpha ("Fresnel Edge Opacity", Range(0, 2)) = 0.6000000238418579

_Reflection ("Reflection Strength", Range(0, 2)) = 0.8500000238418579

_ReflectionColor ("Reflection Tint", Color) = (1,0.85,0.5,1)

_Gloss ("Specular Intensity", Range(0, 1)) = 0.8999999761581421

_SpecPower ("Specular Power", Range(1, 256)) = 90.0

_SpecTint ("Specular Color", Color) = (1,1,1,1)

_Emission ("Glass Emission", Range(0, 2)) = 0.05000000074505806

[Header(Render State  set by material)] [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 5.0

[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 10.0

[Enum(Off,0,On,1)] _ZWrite ("ZWrite", Float) = 0.0

[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2.0

}
SubShader {
 LOD 200
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 GrabPass {
 "_PigGrabTexture"
}
 Pass {
 Name "GOLDEN_PIG"
  LOD 200
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite [_ZWrite]
 Cull [_Cull]
   Blend [_SrcBlend] [_DstBlend]
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ _MASKMAP
#pragma multi_compile_local __ _MONEY_MODE
#pragma multi_compile_local __ _REFRACTION
#if defined(FOG_EXP) && defined(_MASKMAP) && defined(_MONEY_MODE) && defined(_REFRACTION)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _MoneyTex_ST;
float _FillWorldSpace;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _MoneyTex_ST
#define _21_m6 _FillWorldSpace



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float2 _195;
static float3 _207;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _207 : NORMAL;
    float2 _195 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _226;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD4 = exp2(-_9.x);
    float3 _130 = _11.yyy * _21_m1[1].xyz;
    _9 = float4(_130.x, _130.y, _130.z, _9.w);
    float3 _141 = (_21_m1[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_141.x, _141.y, _141.z, _9.w);
    float3 _152 = (_21_m1[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_152.x, _152.y, _152.z, _9.w);
    float3 _160 = _9.xyz + _21_m1[3].xyz;
    _9 = float4(_160.x, _160.y, _160.z, _9.w);
    float3 _168 = _9.xyz + (-_11.xyz);
    _9 = float4(_168.x, _168.y, _168.z, _9.w);
    vs_TEXCOORD0 = (float3(float3(_21_m6, _21_m6, _21_m6)) * _9.xyz) + _11.xyz;
    vs_TEXCOORD1 = (_195 * _21_m5.xy) + _21_m5.zw;
    _9.x = dot(_207, _21_m2[0].xyz);
    _9.y = dot(_207, _21_m2[1].xyz);
    _9.z = dot(_207, _21_m2[2].xyz);
    _226 = dot(_9.xyz, _9.xyz);
    _226 = rsqrt(_226);
    vs_TEXCOORD2 = _226.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _195 = stage_input._195;
    _207 = stage_input._207;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _MoneyColor;
float _Fill;
float _FillYMin;
float _FillYMax;
float _FillNoise;
float _FillNoiseScale;
float _DepthDarken;
float _SurfaceBand;
float _SurfaceGlow;
float _InteriorTint;
float _InteriorBrightness;
float4 _GlassColor;
#define _18_m0 _WorldSpaceLightPos0
#define _18_m1 unity_FogColor
#define _18_m2 _MoneyColor
#define _18_m3 _Fill
#define _18_m4 _FillYMin
#define _18_m5 _FillYMax
#define _18_m6 _FillNoise
#define _18_m7 _FillNoiseScale
#define _18_m8 _DepthDarken
#define _18_m9 _SurfaceBand
#define _18_m10 _SurfaceGlow
#define _18_m11 _InteriorTint
#define _18_m12 _InteriorBrightness
#define _18_m13 _GlassColor


Texture2D<float4> _MoneyTex;
SamplerState sampler_MoneyTex;

static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 _497;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _497 : SV_Target0;
};

static float4 _9;
static float2 _34;
static float3 _39;
static float2 _59;
static float4 _87;
static float4 _104;
static float3 _108;
static float _215;
static float _251;
static bool _301;
static float3 _338;
static float _362;
static float3 _373;
static float3 _398;

void frag_inner()
{
    float2 _30 = vs_TEXCOORD0.xz * float2(float2(_18_m7, _18_m7));
    _9 = float4(_30.x, _30.y, _9.z, _9.w);
    _34 = floor(_9.xy);
    float2 _43 = _34 + 1.0f.xx;
    _39 = float3(_43.x, _43.y, _39.z);
    float2 _51 = _39.xy * float2(123.339996337890625f, 456.209991455078125f);
    _39 = float3(_51.x, _51.y, _39.z);
    float2 _56 = frac(_39.xy);
    _39 = float3(_56.x, _56.y, _39.z);
    _59 = _39.xy + 45.31999969482421875f.xx;
    _59.x = dot(_39.xy, _59);
    float2 _77 = _59.xx + _39.xy;
    _39 = float3(_77.x, _77.y, _39.z);
    _39.x = _39.y * _39.x;
    _87 = _34.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _94 = _34 * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_9.x, _9.y, _94.x, _94.y);
    _9 = frac(_9);
    _87 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _87 = frac(_87);
    _104 = _87 + 45.31999969482421875f.xxxx;
    _108.x = dot(_87.zw, _104.zw);
    _59.x = dot(_87.xy, _104.xy);
    _59 = _59.xx + _87.xy;
    float2 _130 = _108.xx + _87.zw;
    _87 = float4(_130.x, _130.y, _87.z, _87.w);
    _39.y = _87.y * _87.x;
    _39.z = _59.y * _59.x;
    _39 = frac(_39);
    _39.x = (-_39.y) + _39.x;
    float2 _159 = _9.xy * _9.xy;
    _87 = float4(_159.x, _159.y, _87.z, _87.w);
    float2 _170 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_170.x, _170.y, _9.z, _9.w);
    float2 _177 = _9.xy * _87.xy;
    _9 = float4(_177.x, _177.y, _9.z, _9.w);
    _39.x = (_9.x * _39.x) + _39.y;
    float2 _191 = _9.zw + 45.31999969482421875f.xx;
    _108 = float3(_191.x, _108.y, _191.y);
    _108.x = dot(_9.zw, _108.xz);
    _34 = _9.zw + _108.xx;
    _34.x = _34.y * _34.x;
    _34.x = frac(_34.x);
    _215 = (-_34.x) + _39.z;
    _9.x = (_9.x * _215) + _34.x;
    _34.x = (-_9.x) + _39.x;
    _9.x = (_9.y * _34.x) + _9.x;
    _9.x += (-0.5f);
    _251 = _18_m3;
    _251 = clamp(_251, 0.0f, 1.0f);
    _34.x = (-_18_m4) + _18_m5;
    _251 = (_251 * _34.x) + _18_m4;
    _34.x = max(_34.x, 9.9999997473787516355514526367188e-05f);
    _34.x = 1.0f / _34.x;
    _9.x = (_9.x * _18_m6) + _251;
    _9.x += (-vs_TEXCOORD0.y);
    _301 = _9.x < 0.0f;
    _9.x = _34.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    if ((int(_301) * (-1)) != 0)
    {
        discard;
    }
    _251 = max(_18_m9, 9.9999997473787516355514526367188e-05f);
    _251 = _9.x / _251;
    _251 = (-_251) + 1.0f;
    _251 = max(_251, 0.0f);
    _338.x = _251 * _251;
    _338.x *= _18_m10;
    _338 = _338.xxx * _18_m2.xyz;
    _338 *= 0.5f.xxx;
    _362 = _18_m8 + (-1.0f);
    _362 = (_9.x * _362) + 1.0f;
    _373 = _MoneyTex.Sample(sampler_MoneyTex, vs_TEXCOORD1).xyz;
    float3 _388 = _373 * _18_m2.xyz;
    _9 = float4(_388.x, _388.y, _388.z, _9.w);
    _338 = (_9.xyz * _362.xxx) + _338;
    _398 = _338 * _18_m13.xyz;
    _398 = (_398 * 2.0f.xxx) + (-_338);
    _338 = (float3(float3(_18_m11, _18_m11, _18_m11)) * _398) + _338;
    _338 *= _18_m12.xxx;
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    float3 _445 = _9.xxx * vs_TEXCOORD2;
    _9 = float4(_445.x, _445.y, _445.z, _9.w);
    _9.x = dot(_9.xyz, _18_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _362 = _9.x + (-1.0f);
    _362 = (_362 * 0.5f) + 1.0f;
    float3 _478 = (_338 * _362.xxx) + (-_18_m1.xyz);
    _9 = float4(_478.x, _478.y, _478.z, _9.w);
    _215 = vs_TEXCOORD4;
    _215 = clamp(_215, 0.0f, 1.0f);
    float3 _493 = (_215.xxx * _9.xyz) + _18_m1.xyz;
    _9 = float4(_493.x, _493.y, _493.z, _9.w);
    _497 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _497.w);
    _497.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._497 = _497;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(_MASKMAP) && defined(_MONEY_MODE) && defined(_REFRACTION)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _MoneyTex_ST;
float _FillWorldSpace;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _MoneyTex_ST
#define _21_m6 _FillWorldSpace



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float2 _201;
static float3 _213;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _213 : NORMAL;
    float2 _201 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _232;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD4 = exp2(_9.x);
    float3 _136 = _11.yyy * _21_m1[1].xyz;
    _9 = float4(_136.x, _136.y, _136.z, _9.w);
    float3 _147 = (_21_m1[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_147.x, _147.y, _147.z, _9.w);
    float3 _158 = (_21_m1[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_158.x, _158.y, _158.z, _9.w);
    float3 _166 = _9.xyz + _21_m1[3].xyz;
    _9 = float4(_166.x, _166.y, _166.z, _9.w);
    float3 _174 = _9.xyz + (-_11.xyz);
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    vs_TEXCOORD0 = (float3(float3(_21_m6, _21_m6, _21_m6)) * _9.xyz) + _11.xyz;
    vs_TEXCOORD1 = (_201 * _21_m5.xy) + _21_m5.zw;
    _9.x = dot(_213, _21_m2[0].xyz);
    _9.y = dot(_213, _21_m2[1].xyz);
    _9.z = dot(_213, _21_m2[2].xyz);
    _232 = dot(_9.xyz, _9.xyz);
    _232 = rsqrt(_232);
    vs_TEXCOORD2 = _232.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _201 = stage_input._201;
    _213 = stage_input._213;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _MoneyColor;
float _Fill;
float _FillYMin;
float _FillYMax;
float _FillNoise;
float _FillNoiseScale;
float _DepthDarken;
float _SurfaceBand;
float _SurfaceGlow;
float _InteriorTint;
float _InteriorBrightness;
float4 _GlassColor;
#define _18_m0 _WorldSpaceLightPos0
#define _18_m1 unity_FogColor
#define _18_m2 _MoneyColor
#define _18_m3 _Fill
#define _18_m4 _FillYMin
#define _18_m5 _FillYMax
#define _18_m6 _FillNoise
#define _18_m7 _FillNoiseScale
#define _18_m8 _DepthDarken
#define _18_m9 _SurfaceBand
#define _18_m10 _SurfaceGlow
#define _18_m11 _InteriorTint
#define _18_m12 _InteriorBrightness
#define _18_m13 _GlassColor


Texture2D<float4> _MoneyTex;
SamplerState sampler_MoneyTex;

static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 _497;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _497 : SV_Target0;
};

static float4 _9;
static float2 _34;
static float3 _39;
static float2 _59;
static float4 _87;
static float4 _104;
static float3 _108;
static float _215;
static float _251;
static bool _301;
static float3 _338;
static float _362;
static float3 _373;
static float3 _398;

void frag_inner()
{
    float2 _30 = vs_TEXCOORD0.xz * float2(float2(_18_m7, _18_m7));
    _9 = float4(_30.x, _30.y, _9.z, _9.w);
    _34 = floor(_9.xy);
    float2 _43 = _34 + 1.0f.xx;
    _39 = float3(_43.x, _43.y, _39.z);
    float2 _51 = _39.xy * float2(123.339996337890625f, 456.209991455078125f);
    _39 = float3(_51.x, _51.y, _39.z);
    float2 _56 = frac(_39.xy);
    _39 = float3(_56.x, _56.y, _39.z);
    _59 = _39.xy + 45.31999969482421875f.xx;
    _59.x = dot(_39.xy, _59);
    float2 _77 = _59.xx + _39.xy;
    _39 = float3(_77.x, _77.y, _39.z);
    _39.x = _39.y * _39.x;
    _87 = _34.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _94 = _34 * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_9.x, _9.y, _94.x, _94.y);
    _9 = frac(_9);
    _87 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _87 = frac(_87);
    _104 = _87 + 45.31999969482421875f.xxxx;
    _108.x = dot(_87.zw, _104.zw);
    _59.x = dot(_87.xy, _104.xy);
    _59 = _59.xx + _87.xy;
    float2 _130 = _108.xx + _87.zw;
    _87 = float4(_130.x, _130.y, _87.z, _87.w);
    _39.y = _87.y * _87.x;
    _39.z = _59.y * _59.x;
    _39 = frac(_39);
    _39.x = (-_39.y) + _39.x;
    float2 _159 = _9.xy * _9.xy;
    _87 = float4(_159.x, _159.y, _87.z, _87.w);
    float2 _170 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_170.x, _170.y, _9.z, _9.w);
    float2 _177 = _9.xy * _87.xy;
    _9 = float4(_177.x, _177.y, _9.z, _9.w);
    _39.x = (_9.x * _39.x) + _39.y;
    float2 _191 = _9.zw + 45.31999969482421875f.xx;
    _108 = float3(_191.x, _108.y, _191.y);
    _108.x = dot(_9.zw, _108.xz);
    _34 = _9.zw + _108.xx;
    _34.x = _34.y * _34.x;
    _34.x = frac(_34.x);
    _215 = (-_34.x) + _39.z;
    _9.x = (_9.x * _215) + _34.x;
    _34.x = (-_9.x) + _39.x;
    _9.x = (_9.y * _34.x) + _9.x;
    _9.x += (-0.5f);
    _251 = _18_m3;
    _251 = clamp(_251, 0.0f, 1.0f);
    _34.x = (-_18_m4) + _18_m5;
    _251 = (_251 * _34.x) + _18_m4;
    _34.x = max(_34.x, 9.9999997473787516355514526367188e-05f);
    _34.x = 1.0f / _34.x;
    _9.x = (_9.x * _18_m6) + _251;
    _9.x += (-vs_TEXCOORD0.y);
    _301 = _9.x < 0.0f;
    _9.x = _34.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    if ((int(_301) * (-1)) != 0)
    {
        discard;
    }
    _251 = max(_18_m9, 9.9999997473787516355514526367188e-05f);
    _251 = _9.x / _251;
    _251 = (-_251) + 1.0f;
    _251 = max(_251, 0.0f);
    _338.x = _251 * _251;
    _338.x *= _18_m10;
    _338 = _338.xxx * _18_m2.xyz;
    _338 *= 0.5f.xxx;
    _362 = _18_m8 + (-1.0f);
    _362 = (_9.x * _362) + 1.0f;
    _373 = _MoneyTex.Sample(sampler_MoneyTex, vs_TEXCOORD1).xyz;
    float3 _388 = _373 * _18_m2.xyz;
    _9 = float4(_388.x, _388.y, _388.z, _9.w);
    _338 = (_9.xyz * _362.xxx) + _338;
    _398 = _338 * _18_m13.xyz;
    _398 = (_398 * 2.0f.xxx) + (-_338);
    _338 = (float3(float3(_18_m11, _18_m11, _18_m11)) * _398) + _338;
    _338 *= _18_m12.xxx;
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    float3 _445 = _9.xxx * vs_TEXCOORD2;
    _9 = float4(_445.x, _445.y, _445.z, _9.w);
    _9.x = dot(_9.xyz, _18_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _362 = _9.x + (-1.0f);
    _362 = (_362 * 0.5f) + 1.0f;
    float3 _478 = (_338 * _362.xxx) + (-_18_m1.xyz);
    _9 = float4(_478.x, _478.y, _478.z, _9.w);
    _215 = vs_TEXCOORD4;
    _215 = clamp(_215, 0.0f, 1.0f);
    float3 _493 = (_215.xxx * _9.xyz) + _18_m1.xyz;
    _9 = float4(_493.x, _493.y, _493.z, _9.w);
    _497 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _497.w);
    _497.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._497 = _497;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(_MASKMAP) && defined(_MONEY_MODE) && defined(_REFRACTION)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _MoneyTex_ST;
float _FillWorldSpace;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _MoneyTex_ST
#define _21_m6 _FillWorldSpace



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float2 _194;
static float3 _206;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _206 : NORMAL;
    float2 _194 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _225;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD4 = (_9.x * _21_m4.z) + _21_m4.w;
    float3 _129 = _11.yyy * _21_m1[1].xyz;
    _9 = float4(_129.x, _129.y, _129.z, _9.w);
    float3 _140 = (_21_m1[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_140.x, _140.y, _140.z, _9.w);
    float3 _151 = (_21_m1[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_151.x, _151.y, _151.z, _9.w);
    float3 _159 = _9.xyz + _21_m1[3].xyz;
    _9 = float4(_159.x, _159.y, _159.z, _9.w);
    float3 _167 = _9.xyz + (-_11.xyz);
    _9 = float4(_167.x, _167.y, _167.z, _9.w);
    vs_TEXCOORD0 = (float3(float3(_21_m6, _21_m6, _21_m6)) * _9.xyz) + _11.xyz;
    vs_TEXCOORD1 = (_194 * _21_m5.xy) + _21_m5.zw;
    _9.x = dot(_206, _21_m2[0].xyz);
    _9.y = dot(_206, _21_m2[1].xyz);
    _9.z = dot(_206, _21_m2[2].xyz);
    _225 = dot(_9.xyz, _9.xyz);
    _225 = rsqrt(_225);
    vs_TEXCOORD2 = _225.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _194 = stage_input._194;
    _206 = stage_input._206;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _MoneyColor;
float _Fill;
float _FillYMin;
float _FillYMax;
float _FillNoise;
float _FillNoiseScale;
float _DepthDarken;
float _SurfaceBand;
float _SurfaceGlow;
float _InteriorTint;
float _InteriorBrightness;
float4 _GlassColor;
#define _18_m0 _WorldSpaceLightPos0
#define _18_m1 unity_FogColor
#define _18_m2 _MoneyColor
#define _18_m3 _Fill
#define _18_m4 _FillYMin
#define _18_m5 _FillYMax
#define _18_m6 _FillNoise
#define _18_m7 _FillNoiseScale
#define _18_m8 _DepthDarken
#define _18_m9 _SurfaceBand
#define _18_m10 _SurfaceGlow
#define _18_m11 _InteriorTint
#define _18_m12 _InteriorBrightness
#define _18_m13 _GlassColor


Texture2D<float4> _MoneyTex;
SamplerState sampler_MoneyTex;

static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 _497;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _497 : SV_Target0;
};

static float4 _9;
static float2 _34;
static float3 _39;
static float2 _59;
static float4 _87;
static float4 _104;
static float3 _108;
static float _215;
static float _251;
static bool _301;
static float3 _338;
static float _362;
static float3 _373;
static float3 _398;

void frag_inner()
{
    float2 _30 = vs_TEXCOORD0.xz * float2(float2(_18_m7, _18_m7));
    _9 = float4(_30.x, _30.y, _9.z, _9.w);
    _34 = floor(_9.xy);
    float2 _43 = _34 + 1.0f.xx;
    _39 = float3(_43.x, _43.y, _39.z);
    float2 _51 = _39.xy * float2(123.339996337890625f, 456.209991455078125f);
    _39 = float3(_51.x, _51.y, _39.z);
    float2 _56 = frac(_39.xy);
    _39 = float3(_56.x, _56.y, _39.z);
    _59 = _39.xy + 45.31999969482421875f.xx;
    _59.x = dot(_39.xy, _59);
    float2 _77 = _59.xx + _39.xy;
    _39 = float3(_77.x, _77.y, _39.z);
    _39.x = _39.y * _39.x;
    _87 = _34.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _94 = _34 * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_9.x, _9.y, _94.x, _94.y);
    _9 = frac(_9);
    _87 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _87 = frac(_87);
    _104 = _87 + 45.31999969482421875f.xxxx;
    _108.x = dot(_87.zw, _104.zw);
    _59.x = dot(_87.xy, _104.xy);
    _59 = _59.xx + _87.xy;
    float2 _130 = _108.xx + _87.zw;
    _87 = float4(_130.x, _130.y, _87.z, _87.w);
    _39.y = _87.y * _87.x;
    _39.z = _59.y * _59.x;
    _39 = frac(_39);
    _39.x = (-_39.y) + _39.x;
    float2 _159 = _9.xy * _9.xy;
    _87 = float4(_159.x, _159.y, _87.z, _87.w);
    float2 _170 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_170.x, _170.y, _9.z, _9.w);
    float2 _177 = _9.xy * _87.xy;
    _9 = float4(_177.x, _177.y, _9.z, _9.w);
    _39.x = (_9.x * _39.x) + _39.y;
    float2 _191 = _9.zw + 45.31999969482421875f.xx;
    _108 = float3(_191.x, _108.y, _191.y);
    _108.x = dot(_9.zw, _108.xz);
    _34 = _9.zw + _108.xx;
    _34.x = _34.y * _34.x;
    _34.x = frac(_34.x);
    _215 = (-_34.x) + _39.z;
    _9.x = (_9.x * _215) + _34.x;
    _34.x = (-_9.x) + _39.x;
    _9.x = (_9.y * _34.x) + _9.x;
    _9.x += (-0.5f);
    _251 = _18_m3;
    _251 = clamp(_251, 0.0f, 1.0f);
    _34.x = (-_18_m4) + _18_m5;
    _251 = (_251 * _34.x) + _18_m4;
    _34.x = max(_34.x, 9.9999997473787516355514526367188e-05f);
    _34.x = 1.0f / _34.x;
    _9.x = (_9.x * _18_m6) + _251;
    _9.x += (-vs_TEXCOORD0.y);
    _301 = _9.x < 0.0f;
    _9.x = _34.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    if ((int(_301) * (-1)) != 0)
    {
        discard;
    }
    _251 = max(_18_m9, 9.9999997473787516355514526367188e-05f);
    _251 = _9.x / _251;
    _251 = (-_251) + 1.0f;
    _251 = max(_251, 0.0f);
    _338.x = _251 * _251;
    _338.x *= _18_m10;
    _338 = _338.xxx * _18_m2.xyz;
    _338 *= 0.5f.xxx;
    _362 = _18_m8 + (-1.0f);
    _362 = (_9.x * _362) + 1.0f;
    _373 = _MoneyTex.Sample(sampler_MoneyTex, vs_TEXCOORD1).xyz;
    float3 _388 = _373 * _18_m2.xyz;
    _9 = float4(_388.x, _388.y, _388.z, _9.w);
    _338 = (_9.xyz * _362.xxx) + _338;
    _398 = _338 * _18_m13.xyz;
    _398 = (_398 * 2.0f.xxx) + (-_338);
    _338 = (float3(float3(_18_m11, _18_m11, _18_m11)) * _398) + _338;
    _338 *= _18_m12.xxx;
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    float3 _445 = _9.xxx * vs_TEXCOORD2;
    _9 = float4(_445.x, _445.y, _445.z, _9.w);
    _9.x = dot(_9.xyz, _18_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _362 = _9.x + (-1.0f);
    _362 = (_362 * 0.5f) + 1.0f;
    float3 _478 = (_338 * _362.xxx) + (-_18_m1.xyz);
    _9 = float4(_478.x, _478.y, _478.z, _9.w);
    _215 = vs_TEXCOORD4;
    _215 = clamp(_215, 0.0f, 1.0f);
    float3 _493 = (_215.xxx * _9.xyz) + _18_m1.xyz;
    _9 = float4(_493.x, _493.y, _493.z, _9.w);
    _497 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _497.w);
    _497.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._497 = _497;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(_MASKMAP) && defined(_REFRACTION)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _BumpMap_ST;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _BumpMap_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float2 _88;
static float3 _107;
static float4 vs_TEXCOORD1;
static float4 _190;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _107 : NORMAL;
    float4 _190 : TANGENT;
    float2 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _129;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m4[1];
    _49 = (_21_m4[0] * _9.xxxx) + _49;
    _49 = (_21_m4[2] * _9.zzzz) + _49;
    _9 = (_21_m4[3] * _9.wwww) + _49;
    gl_Position = _9;
    float2 _98 = (_88 * _21_m6.xy) + _21_m6.zw;
    vs_TEXCOORD0 = float4(_98.x, _98.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, 0.0f.xx.x, 0.0f.xx.y);
    _49.x = dot(_107, _21_m2[0].xyz);
    _49.y = dot(_107, _21_m2[1].xyz);
    _49.z = dot(_107, _21_m2[2].xyz);
    _129 = dot(_49.xyz, _49.xyz);
    _129 = rsqrt(_129);
    float3 _142 = _129.xxx * _49.xyz;
    vs_TEXCOORD1 = float4(_142.x, _142.y, _142.z, vs_TEXCOORD1.w);
    float3 _150 = _11.yyy * _21_m1[1].xyz;
    _49 = float4(_150.x, _150.y, _150.z, _49.w);
    float3 _161 = (_21_m1[0].xyz * _11.xxx) + _49.xyz;
    _49 = float4(_161.x, _161.y, _161.z, _49.w);
    float3 _172 = (_21_m1[2].xyz * _11.zzz) + _49.xyz;
    _49 = float4(_172.x, _172.y, _172.z, _49.w);
    float3 _180 = _49.xyz + _21_m1[3].xyz;
    _49 = float4(_180.x, _180.y, _180.z, _49.w);
    vs_TEXCOORD1.w = _49.x;
    _189 = _190.yyy * _21_m1[1].xyz;
    _189 = (_21_m1[0].xyz * _190.xxx) + _189;
    _189 = (_21_m1[2].xyz * _190.zzz) + _189;
    _49.x = dot(_189, _189);
    _49.x = rsqrt(_49.x);
    float3 _225 = _49.xxx * _189;
    vs_TEXCOORD2 = float4(_225.x, _225.y, _225.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _49.y;
    vs_TEXCOORD3.x = _49.z;
    _49.x = _9.z / _21_m0.y;
    _49.x = (-_49.x) + 1.0f;
    _49.x *= _21_m0.z;
    _49.x = max(_49.x, 0.0f);
    _49.x *= _21_m5.y;
    vs_TEXCOORD4 = exp2(-_49.x);
    vs_TEXCOORD3.y = _190.w * _21_m3.w;
    float3 _283 = _9.xwy * float3(0.5f, 0.5f, -0.5f);
    _49 = float4(_283.x, _283.y, _283.z, _49.w);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _9.zw.x, _9.zw.y);
    float2 _295 = _49.yy + _49.xz;
    vs_TEXCOORD5 = float4(_295.x, _295.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _107 = stage_input._107;
    _190 = stage_input._190;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_MatrixV;
static float4 _64_m2[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _GlassColor;
float _GlassAlpha;
float _RefractStrength;
float _AbsorbDensity;
float _RefractTint;
float4 _AbsorbColor;
float4 _FresnelColor;
float _FresnelPower;
float _FresnelIntensity;
float _FresnelAlpha;
float _Reflection;
float4 _ReflectionColor;
float _Gloss;
float _SpecPower;
float4 _SpecTint;
float _Emission;
float _BumpScale;
float _Smoothness;
float _MaskAlphaIsRoughness;
void __unity_init()
{
    _64_m2[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _64_m2[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _64_m2[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _64_m2[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _64_m0 _WorldSpaceCameraPos
#define _64_m1 _WorldSpaceLightPos0
#define _64_m3 unity_FogColor
#define _64_m4 unity_SpecCube0_HDR
#define _64_m5 _LightColor0
#define _64_m6 _GlassColor
#define _64_m7 _GlassAlpha
#define _64_m8 _RefractStrength
#define _64_m9 _AbsorbDensity
#define _64_m10 _RefractTint
#define _64_m11 _AbsorbColor
#define _64_m12 _FresnelColor
#define _64_m13 _FresnelPower
#define _64_m14 _FresnelIntensity
#define _64_m15 _FresnelAlpha
#define _64_m16 _Reflection
#define _64_m17 _ReflectionColor
#define _64_m18 _Gloss
#define _64_m19 _SpecPower
#define _64_m20 _SpecTint
#define _64_m21 _Emission
#define _64_m22 _BumpScale
#define _64_m23 _Smoothness
#define _64_m24 _MaskAlphaIsRoughness


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _PigGrabTexture;
SamplerState sampler_PigGrabTexture;
Texture2D<float4> _MaskMap;
SamplerState sampler_MaskMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD5;
static float vs_TEXCOORD4;
static float4 _557;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _557 : SV_Target0;
};

static float3 _9;
static float4 _35;
static float3 _48;
static float _93;
static float3 _103;
static float3 _123;
static float2 _138;
static float3 _216;
static float3 _253;
static float _263;
static float _294;
static float _323;
static float _412;
static float _462;
static float _484;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
    _9 = (vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy) + (-_9);
    _9 *= vs_TEXCOORD3.yyy;
    float3 _45 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _35 = float4(_45.x, _45.y, _45.z, _35.w);
    _48 = (_35.xyz * 2.0f.xxx) + (-1.0f).xxx;
    float2 _71 = _48.xy * _64_m22.xx;
    _48 = float3(_71.x, _71.y, _48.z);
    _9 *= _48.yyy;
    _9 = (_48.xxx * vs_TEXCOORD2.xyz) + _9;
    _9 = (_48.zzz * vs_TEXCOORD1.xyz) + _9;
    _93 = dot(_9, _9);
    _93 = rsqrt(_93);
    _9 = _93.xxx * _9;
    _103.x = _64_m2[0].x;
    _103.y = _64_m2[1].x;
    _103.z = _64_m2[2].x;
    _103.x = dot(_103, _9);
    _123.x = _64_m2[0].y;
    _123.y = _64_m2[1].y;
    _123.z = _64_m2[2].y;
    _103.y = dot(_123, _9);
    _138 = vs_TEXCOORD5.xy / vs_TEXCOORD5.ww;
    float2 _158 = (_103.xy * float2(float2(_64_m8, _64_m8))) + _138;
    _103 = float3(_158.x, _158.y, _103.z);
    _103 = _PigGrabTexture.Sample(sampler_PigGrabTexture, _103.xy).xyz;
    _123.x = vs_TEXCOORD1.w;
    _123.y = vs_TEXCOORD2.w;
    _123.z = vs_TEXCOORD3.x;
    _123 = (-_123) + _64_m0;
    _93 = dot(_123, _123);
    _93 = rsqrt(_93);
    _123 = _93.xxx * _123;
    _93 = dot(_9, _123);
    _93 = clamp(_93, 0.0f, 1.0f);
    _93 = (-_93) + 1.0f;
    _48.x = _93 + 0.3499999940395355224609375f;
    _93 = log2(_93);
    _93 *= _64_m13;
    _93 = exp2(_93);
    _216 = (-_64_m11.xyz) + 1.0f.xxx;
    _216 *= (-float3(float3(_64_m9, _64_m9, _64_m9)));
    _48 = _48.xxx * _216;
    _48 *= 1.44269502162933349609375f.xxx;
    _48 = exp2(_48);
    _48 = _103 * _48;
    _253 = (_48 * _64_m6.xyz) + (-_48);
    _263 = (-_64_m10) + 1.0f;
    _48 = (_263.xxx * _253) + _48;
    _103.x = dot(-_123, _9);
    _103.x += _103.x;
    _103 = (_9 * (-_103.xxx)) + (-_123);
    _294 = _MaskMap.Sample(sampler_MaskMap, vs_TEXCOORD0.xy).w;
    _263 = (_294 * (-2.0f)) + 1.0f;
    _263 = (_64_m24 * _263) + _294;
    _263 *= _64_m23;
    _263 = clamp(_263, 0.0f, 1.0f);
    _253.x = (-_263) + 1.0f;
    _323 = ((-_253.x) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
    _253.x = _323 * _253.x;
    _253.x *= 6.0f;
    _35 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _103, _253.x);
    _253.x = _35.w + (-1.0f);
    _253.x = (_64_m4.w * _253.x) + 1.0f;
    _253.x = log2(_253.x);
    _253.x *= _64_m4.y;
    _253.x = exp2(_253.x);
    _253.x *= _64_m4.x;
    _253 = _35.xyz * _253.xxx;
    _253 *= _64_m17.xyz;
    _253 *= _64_m6.xyz;
    _253 *= float3(float3(_64_m16, _64_m16, _64_m16));
    _412 = (_93 * 0.949999988079071044921875f) + 0.0500000007450580596923828125f;
    _48 = (_253 * _412.xxx) + _48;
    _253 = (-_48) + _64_m12.xyz;
    _412 = _93 * _64_m14;
    _48 = (_412.xxx * _253) + _48;
    _103.x = dot(_64_m1.xyz, _64_m1.xyz);
    _103.x = rsqrt(_103.x);
    _103 = (_64_m1.xyz * _103.xxx) + _123;
    _462 = dot(_103, _103);
    _462 = rsqrt(_462);
    _103 = _462.xxx * _103;
    _9.x = dot(_9, _103);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _484 = _263 * _64_m19;
    _484 = max(_484, 1.0f);
    _9.x *= _484;
    _9.x = exp2(_9.x);
    _9.x *= _64_m18;
    _484 = _263 * _9.x;
    _253 = _64_m5.xyz * _64_m20.xyz;
    _48 = (_253 * _484.xxx) + _48;
    _48 = (_64_m6.xyz * _64_m21.xxx) + _48;
    _103 = _48 + (-_64_m3.xyz);
    _484 = vs_TEXCOORD4;
    _484 = clamp(_484, 0.0f, 1.0f);
    _103 = (_484.xxx * _103) + _64_m3.xyz;
    _557 = float4(_103.x, _103.y, _103.z, _557.w);
    _48.x = (_64_m10 * 0.550000011920928955078125f) + _64_m7;
    _48.x = (_93 * _64_m15) + _48.x;
    _557.w = (_9.x * _263) + _48.x;
    _557.w = clamp(_557.w, 0.0f, 1.0f);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._557 = _557;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(_MASKMAP) && defined(_REFRACTION)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _BumpMap_ST;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _BumpMap_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float2 _88;
static float3 _107;
static float4 vs_TEXCOORD1;
static float4 _190;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _107 : NORMAL;
    float4 _190 : TANGENT;
    float2 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _129;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m4[1];
    _49 = (_21_m4[0] * _9.xxxx) + _49;
    _49 = (_21_m4[2] * _9.zzzz) + _49;
    _9 = (_21_m4[3] * _9.wwww) + _49;
    gl_Position = _9;
    float2 _98 = (_88 * _21_m6.xy) + _21_m6.zw;
    vs_TEXCOORD0 = float4(_98.x, _98.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, 0.0f.xx.x, 0.0f.xx.y);
    _49.x = dot(_107, _21_m2[0].xyz);
    _49.y = dot(_107, _21_m2[1].xyz);
    _49.z = dot(_107, _21_m2[2].xyz);
    _129 = dot(_49.xyz, _49.xyz);
    _129 = rsqrt(_129);
    float3 _142 = _129.xxx * _49.xyz;
    vs_TEXCOORD1 = float4(_142.x, _142.y, _142.z, vs_TEXCOORD1.w);
    float3 _150 = _11.yyy * _21_m1[1].xyz;
    _49 = float4(_150.x, _150.y, _150.z, _49.w);
    float3 _161 = (_21_m1[0].xyz * _11.xxx) + _49.xyz;
    _49 = float4(_161.x, _161.y, _161.z, _49.w);
    float3 _172 = (_21_m1[2].xyz * _11.zzz) + _49.xyz;
    _49 = float4(_172.x, _172.y, _172.z, _49.w);
    float3 _180 = _49.xyz + _21_m1[3].xyz;
    _49 = float4(_180.x, _180.y, _180.z, _49.w);
    vs_TEXCOORD1.w = _49.x;
    _189 = _190.yyy * _21_m1[1].xyz;
    _189 = (_21_m1[0].xyz * _190.xxx) + _189;
    _189 = (_21_m1[2].xyz * _190.zzz) + _189;
    _49.x = dot(_189, _189);
    _49.x = rsqrt(_49.x);
    float3 _225 = _49.xxx * _189;
    vs_TEXCOORD2 = float4(_225.x, _225.y, _225.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _49.y;
    vs_TEXCOORD3.x = _49.z;
    _49.x = _9.z / _21_m0.y;
    _49.x = (-_49.x) + 1.0f;
    _49.x *= _21_m0.z;
    _49.x = max(_49.x, 0.0f);
    _49.x *= _21_m5.x;
    _49.x *= (-_49.x);
    vs_TEXCOORD4 = exp2(_49.x);
    vs_TEXCOORD3.y = _190.w * _21_m3.w;
    float3 _289 = _9.xwy * float3(0.5f, 0.5f, -0.5f);
    _49 = float4(_289.x, _289.y, _289.z, _49.w);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _9.zw.x, _9.zw.y);
    float2 _301 = _49.yy + _49.xz;
    vs_TEXCOORD5 = float4(_301.x, _301.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _107 = stage_input._107;
    _190 = stage_input._190;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_MatrixV;
static float4 _64_m2[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _GlassColor;
float _GlassAlpha;
float _RefractStrength;
float _AbsorbDensity;
float _RefractTint;
float4 _AbsorbColor;
float4 _FresnelColor;
float _FresnelPower;
float _FresnelIntensity;
float _FresnelAlpha;
float _Reflection;
float4 _ReflectionColor;
float _Gloss;
float _SpecPower;
float4 _SpecTint;
float _Emission;
float _BumpScale;
float _Smoothness;
float _MaskAlphaIsRoughness;
void __unity_init()
{
    _64_m2[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _64_m2[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _64_m2[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _64_m2[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _64_m0 _WorldSpaceCameraPos
#define _64_m1 _WorldSpaceLightPos0
#define _64_m3 unity_FogColor
#define _64_m4 unity_SpecCube0_HDR
#define _64_m5 _LightColor0
#define _64_m6 _GlassColor
#define _64_m7 _GlassAlpha
#define _64_m8 _RefractStrength
#define _64_m9 _AbsorbDensity
#define _64_m10 _RefractTint
#define _64_m11 _AbsorbColor
#define _64_m12 _FresnelColor
#define _64_m13 _FresnelPower
#define _64_m14 _FresnelIntensity
#define _64_m15 _FresnelAlpha
#define _64_m16 _Reflection
#define _64_m17 _ReflectionColor
#define _64_m18 _Gloss
#define _64_m19 _SpecPower
#define _64_m20 _SpecTint
#define _64_m21 _Emission
#define _64_m22 _BumpScale
#define _64_m23 _Smoothness
#define _64_m24 _MaskAlphaIsRoughness


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _PigGrabTexture;
SamplerState sampler_PigGrabTexture;
Texture2D<float4> _MaskMap;
SamplerState sampler_MaskMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD5;
static float vs_TEXCOORD4;
static float4 _557;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _557 : SV_Target0;
};

static float3 _9;
static float4 _35;
static float3 _48;
static float _93;
static float3 _103;
static float3 _123;
static float2 _138;
static float3 _216;
static float3 _253;
static float _263;
static float _294;
static float _323;
static float _412;
static float _462;
static float _484;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
    _9 = (vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy) + (-_9);
    _9 *= vs_TEXCOORD3.yyy;
    float3 _45 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _35 = float4(_45.x, _45.y, _45.z, _35.w);
    _48 = (_35.xyz * 2.0f.xxx) + (-1.0f).xxx;
    float2 _71 = _48.xy * _64_m22.xx;
    _48 = float3(_71.x, _71.y, _48.z);
    _9 *= _48.yyy;
    _9 = (_48.xxx * vs_TEXCOORD2.xyz) + _9;
    _9 = (_48.zzz * vs_TEXCOORD1.xyz) + _9;
    _93 = dot(_9, _9);
    _93 = rsqrt(_93);
    _9 = _93.xxx * _9;
    _103.x = _64_m2[0].x;
    _103.y = _64_m2[1].x;
    _103.z = _64_m2[2].x;
    _103.x = dot(_103, _9);
    _123.x = _64_m2[0].y;
    _123.y = _64_m2[1].y;
    _123.z = _64_m2[2].y;
    _103.y = dot(_123, _9);
    _138 = vs_TEXCOORD5.xy / vs_TEXCOORD5.ww;
    float2 _158 = (_103.xy * float2(float2(_64_m8, _64_m8))) + _138;
    _103 = float3(_158.x, _158.y, _103.z);
    _103 = _PigGrabTexture.Sample(sampler_PigGrabTexture, _103.xy).xyz;
    _123.x = vs_TEXCOORD1.w;
    _123.y = vs_TEXCOORD2.w;
    _123.z = vs_TEXCOORD3.x;
    _123 = (-_123) + _64_m0;
    _93 = dot(_123, _123);
    _93 = rsqrt(_93);
    _123 = _93.xxx * _123;
    _93 = dot(_9, _123);
    _93 = clamp(_93, 0.0f, 1.0f);
    _93 = (-_93) + 1.0f;
    _48.x = _93 + 0.3499999940395355224609375f;
    _93 = log2(_93);
    _93 *= _64_m13;
    _93 = exp2(_93);
    _216 = (-_64_m11.xyz) + 1.0f.xxx;
    _216 *= (-float3(float3(_64_m9, _64_m9, _64_m9)));
    _48 = _48.xxx * _216;
    _48 *= 1.44269502162933349609375f.xxx;
    _48 = exp2(_48);
    _48 = _103 * _48;
    _253 = (_48 * _64_m6.xyz) + (-_48);
    _263 = (-_64_m10) + 1.0f;
    _48 = (_263.xxx * _253) + _48;
    _103.x = dot(-_123, _9);
    _103.x += _103.x;
    _103 = (_9 * (-_103.xxx)) + (-_123);
    _294 = _MaskMap.Sample(sampler_MaskMap, vs_TEXCOORD0.xy).w;
    _263 = (_294 * (-2.0f)) + 1.0f;
    _263 = (_64_m24 * _263) + _294;
    _263 *= _64_m23;
    _263 = clamp(_263, 0.0f, 1.0f);
    _253.x = (-_263) + 1.0f;
    _323 = ((-_253.x) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
    _253.x = _323 * _253.x;
    _253.x *= 6.0f;
    _35 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _103, _253.x);
    _253.x = _35.w + (-1.0f);
    _253.x = (_64_m4.w * _253.x) + 1.0f;
    _253.x = log2(_253.x);
    _253.x *= _64_m4.y;
    _253.x = exp2(_253.x);
    _253.x *= _64_m4.x;
    _253 = _35.xyz * _253.xxx;
    _253 *= _64_m17.xyz;
    _253 *= _64_m6.xyz;
    _253 *= float3(float3(_64_m16, _64_m16, _64_m16));
    _412 = (_93 * 0.949999988079071044921875f) + 0.0500000007450580596923828125f;
    _48 = (_253 * _412.xxx) + _48;
    _253 = (-_48) + _64_m12.xyz;
    _412 = _93 * _64_m14;
    _48 = (_412.xxx * _253) + _48;
    _103.x = dot(_64_m1.xyz, _64_m1.xyz);
    _103.x = rsqrt(_103.x);
    _103 = (_64_m1.xyz * _103.xxx) + _123;
    _462 = dot(_103, _103);
    _462 = rsqrt(_462);
    _103 = _462.xxx * _103;
    _9.x = dot(_9, _103);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _484 = _263 * _64_m19;
    _484 = max(_484, 1.0f);
    _9.x *= _484;
    _9.x = exp2(_9.x);
    _9.x *= _64_m18;
    _484 = _263 * _9.x;
    _253 = _64_m5.xyz * _64_m20.xyz;
    _48 = (_253 * _484.xxx) + _48;
    _48 = (_64_m6.xyz * _64_m21.xxx) + _48;
    _103 = _48 + (-_64_m3.xyz);
    _484 = vs_TEXCOORD4;
    _484 = clamp(_484, 0.0f, 1.0f);
    _103 = (_484.xxx * _103) + _64_m3.xyz;
    _557 = float4(_103.x, _103.y, _103.z, _557.w);
    _48.x = (_64_m10 * 0.550000011920928955078125f) + _64_m7;
    _48.x = (_93 * _64_m15) + _48.x;
    _557.w = (_9.x * _263) + _48.x;
    _557.w = clamp(_557.w, 0.0f, 1.0f);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._557 = _557;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(_MASKMAP) && defined(_REFRACTION)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _BumpMap_ST;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _BumpMap_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float2 _88;
static float3 _107;
static float4 vs_TEXCOORD1;
static float4 _190;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _107 : NORMAL;
    float4 _190 : TANGENT;
    float2 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _129;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m4[1];
    _49 = (_21_m4[0] * _9.xxxx) + _49;
    _49 = (_21_m4[2] * _9.zzzz) + _49;
    _9 = (_21_m4[3] * _9.wwww) + _49;
    gl_Position = _9;
    float2 _98 = (_88 * _21_m6.xy) + _21_m6.zw;
    vs_TEXCOORD0 = float4(_98.x, _98.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, 0.0f.xx.x, 0.0f.xx.y);
    _49.x = dot(_107, _21_m2[0].xyz);
    _49.y = dot(_107, _21_m2[1].xyz);
    _49.z = dot(_107, _21_m2[2].xyz);
    _129 = dot(_49.xyz, _49.xyz);
    _129 = rsqrt(_129);
    float3 _142 = _129.xxx * _49.xyz;
    vs_TEXCOORD1 = float4(_142.x, _142.y, _142.z, vs_TEXCOORD1.w);
    float3 _150 = _11.yyy * _21_m1[1].xyz;
    _49 = float4(_150.x, _150.y, _150.z, _49.w);
    float3 _161 = (_21_m1[0].xyz * _11.xxx) + _49.xyz;
    _49 = float4(_161.x, _161.y, _161.z, _49.w);
    float3 _172 = (_21_m1[2].xyz * _11.zzz) + _49.xyz;
    _49 = float4(_172.x, _172.y, _172.z, _49.w);
    float3 _180 = _49.xyz + _21_m1[3].xyz;
    _49 = float4(_180.x, _180.y, _180.z, _49.w);
    vs_TEXCOORD1.w = _49.x;
    _189 = _190.yyy * _21_m1[1].xyz;
    _189 = (_21_m1[0].xyz * _190.xxx) + _189;
    _189 = (_21_m1[2].xyz * _190.zzz) + _189;
    _49.x = dot(_189, _189);
    _49.x = rsqrt(_49.x);
    float3 _225 = _49.xxx * _189;
    vs_TEXCOORD2 = float4(_225.x, _225.y, _225.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _49.y;
    vs_TEXCOORD3.x = _49.z;
    _49.x = _9.z / _21_m0.y;
    _49.x = (-_49.x) + 1.0f;
    _49.x *= _21_m0.z;
    _49.x = max(_49.x, 0.0f);
    vs_TEXCOORD4 = (_49.x * _21_m5.z) + _21_m5.w;
    vs_TEXCOORD3.y = _190.w * _21_m3.w;
    float3 _281 = _9.xwy * float3(0.5f, 0.5f, -0.5f);
    _49 = float4(_281.x, _281.y, _281.z, _49.w);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _9.zw.x, _9.zw.y);
    float2 _293 = _49.yy + _49.xz;
    vs_TEXCOORD5 = float4(_293.x, _293.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _107 = stage_input._107;
    _190 = stage_input._190;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_MatrixV;
static float4 _64_m2[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _GlassColor;
float _GlassAlpha;
float _RefractStrength;
float _AbsorbDensity;
float _RefractTint;
float4 _AbsorbColor;
float4 _FresnelColor;
float _FresnelPower;
float _FresnelIntensity;
float _FresnelAlpha;
float _Reflection;
float4 _ReflectionColor;
float _Gloss;
float _SpecPower;
float4 _SpecTint;
float _Emission;
float _BumpScale;
float _Smoothness;
float _MaskAlphaIsRoughness;
void __unity_init()
{
    _64_m2[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _64_m2[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _64_m2[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _64_m2[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _64_m0 _WorldSpaceCameraPos
#define _64_m1 _WorldSpaceLightPos0
#define _64_m3 unity_FogColor
#define _64_m4 unity_SpecCube0_HDR
#define _64_m5 _LightColor0
#define _64_m6 _GlassColor
#define _64_m7 _GlassAlpha
#define _64_m8 _RefractStrength
#define _64_m9 _AbsorbDensity
#define _64_m10 _RefractTint
#define _64_m11 _AbsorbColor
#define _64_m12 _FresnelColor
#define _64_m13 _FresnelPower
#define _64_m14 _FresnelIntensity
#define _64_m15 _FresnelAlpha
#define _64_m16 _Reflection
#define _64_m17 _ReflectionColor
#define _64_m18 _Gloss
#define _64_m19 _SpecPower
#define _64_m20 _SpecTint
#define _64_m21 _Emission
#define _64_m22 _BumpScale
#define _64_m23 _Smoothness
#define _64_m24 _MaskAlphaIsRoughness


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _PigGrabTexture;
SamplerState sampler_PigGrabTexture;
Texture2D<float4> _MaskMap;
SamplerState sampler_MaskMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD5;
static float vs_TEXCOORD4;
static float4 _557;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _557 : SV_Target0;
};

static float3 _9;
static float4 _35;
static float3 _48;
static float _93;
static float3 _103;
static float3 _123;
static float2 _138;
static float3 _216;
static float3 _253;
static float _263;
static float _294;
static float _323;
static float _412;
static float _462;
static float _484;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
    _9 = (vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy) + (-_9);
    _9 *= vs_TEXCOORD3.yyy;
    float3 _45 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _35 = float4(_45.x, _45.y, _45.z, _35.w);
    _48 = (_35.xyz * 2.0f.xxx) + (-1.0f).xxx;
    float2 _71 = _48.xy * _64_m22.xx;
    _48 = float3(_71.x, _71.y, _48.z);
    _9 *= _48.yyy;
    _9 = (_48.xxx * vs_TEXCOORD2.xyz) + _9;
    _9 = (_48.zzz * vs_TEXCOORD1.xyz) + _9;
    _93 = dot(_9, _9);
    _93 = rsqrt(_93);
    _9 = _93.xxx * _9;
    _103.x = _64_m2[0].x;
    _103.y = _64_m2[1].x;
    _103.z = _64_m2[2].x;
    _103.x = dot(_103, _9);
    _123.x = _64_m2[0].y;
    _123.y = _64_m2[1].y;
    _123.z = _64_m2[2].y;
    _103.y = dot(_123, _9);
    _138 = vs_TEXCOORD5.xy / vs_TEXCOORD5.ww;
    float2 _158 = (_103.xy * float2(float2(_64_m8, _64_m8))) + _138;
    _103 = float3(_158.x, _158.y, _103.z);
    _103 = _PigGrabTexture.Sample(sampler_PigGrabTexture, _103.xy).xyz;
    _123.x = vs_TEXCOORD1.w;
    _123.y = vs_TEXCOORD2.w;
    _123.z = vs_TEXCOORD3.x;
    _123 = (-_123) + _64_m0;
    _93 = dot(_123, _123);
    _93 = rsqrt(_93);
    _123 = _93.xxx * _123;
    _93 = dot(_9, _123);
    _93 = clamp(_93, 0.0f, 1.0f);
    _93 = (-_93) + 1.0f;
    _48.x = _93 + 0.3499999940395355224609375f;
    _93 = log2(_93);
    _93 *= _64_m13;
    _93 = exp2(_93);
    _216 = (-_64_m11.xyz) + 1.0f.xxx;
    _216 *= (-float3(float3(_64_m9, _64_m9, _64_m9)));
    _48 = _48.xxx * _216;
    _48 *= 1.44269502162933349609375f.xxx;
    _48 = exp2(_48);
    _48 = _103 * _48;
    _253 = (_48 * _64_m6.xyz) + (-_48);
    _263 = (-_64_m10) + 1.0f;
    _48 = (_263.xxx * _253) + _48;
    _103.x = dot(-_123, _9);
    _103.x += _103.x;
    _103 = (_9 * (-_103.xxx)) + (-_123);
    _294 = _MaskMap.Sample(sampler_MaskMap, vs_TEXCOORD0.xy).w;
    _263 = (_294 * (-2.0f)) + 1.0f;
    _263 = (_64_m24 * _263) + _294;
    _263 *= _64_m23;
    _263 = clamp(_263, 0.0f, 1.0f);
    _253.x = (-_263) + 1.0f;
    _323 = ((-_253.x) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
    _253.x = _323 * _253.x;
    _253.x *= 6.0f;
    _35 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _103, _253.x);
    _253.x = _35.w + (-1.0f);
    _253.x = (_64_m4.w * _253.x) + 1.0f;
    _253.x = log2(_253.x);
    _253.x *= _64_m4.y;
    _253.x = exp2(_253.x);
    _253.x *= _64_m4.x;
    _253 = _35.xyz * _253.xxx;
    _253 *= _64_m17.xyz;
    _253 *= _64_m6.xyz;
    _253 *= float3(float3(_64_m16, _64_m16, _64_m16));
    _412 = (_93 * 0.949999988079071044921875f) + 0.0500000007450580596923828125f;
    _48 = (_253 * _412.xxx) + _48;
    _253 = (-_48) + _64_m12.xyz;
    _412 = _93 * _64_m14;
    _48 = (_412.xxx * _253) + _48;
    _103.x = dot(_64_m1.xyz, _64_m1.xyz);
    _103.x = rsqrt(_103.x);
    _103 = (_64_m1.xyz * _103.xxx) + _123;
    _462 = dot(_103, _103);
    _462 = rsqrt(_462);
    _103 = _462.xxx * _103;
    _9.x = dot(_9, _103);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _484 = _263 * _64_m19;
    _484 = max(_484, 1.0f);
    _9.x *= _484;
    _9.x = exp2(_9.x);
    _9.x *= _64_m18;
    _484 = _263 * _9.x;
    _253 = _64_m5.xyz * _64_m20.xyz;
    _48 = (_253 * _484.xxx) + _48;
    _48 = (_64_m6.xyz * _64_m21.xxx) + _48;
    _103 = _48 + (-_64_m3.xyz);
    _484 = vs_TEXCOORD4;
    _484 = clamp(_484, 0.0f, 1.0f);
    _103 = (_484.xxx * _103) + _64_m3.xyz;
    _557 = float4(_103.x, _103.y, _103.z, _557.w);
    _48.x = (_64_m10 * 0.550000011920928955078125f) + _64_m7;
    _48.x = (_93 * _64_m15) + _48.x;
    _557.w = (_9.x * _263) + _48.x;
    _557.w = clamp(_557.w, 0.0f, 1.0f);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._557 = _557;
    return stage_output;
}

#endif
#elif defined(_MASKMAP) && defined(_MONEY_MODE) && defined(_REFRACTION)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float4 _MoneyTex_ST;
float _FillWorldSpace;
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m3 _MoneyTex_ST
#define _21_m4 _FillWorldSpace



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float2 _155;
static float3 _166;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _166 : NORMAL;
    float2 _155 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _9 += _21_m0[3];
    _49 = _9.yyyy * _21_m2[1];
    _49 = (_21_m2[0] * _9.xxxx) + _49;
    _49 = (_21_m2[2] * _9.zzzz) + _49;
    gl_Position = (_21_m2[3] * _9.wwww) + _49;
    float3 _89 = _11.yyy * _21_m0[1].xyz;
    _9 = float4(_89.x, _89.y, _89.z, _9.w);
    float3 _100 = (_21_m0[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_100.x, _100.y, _100.z, _9.w);
    float3 _111 = (_21_m0[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_111.x, _111.y, _111.z, _9.w);
    float3 _119 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_119.x, _119.y, _119.z, _9.w);
    float3 _127 = _9.xyz + (-_11.xyz);
    _9 = float4(_127.x, _127.y, _127.z, _9.w);
    vs_TEXCOORD0 = (float3(float3(_21_m4, _21_m4, _21_m4)) * _9.xyz) + _11.xyz;
    vs_TEXCOORD1 = (_155 * _21_m3.xy) + _21_m3.zw;
    _9.x = dot(_166, _21_m1[0].xyz);
    _9.y = dot(_166, _21_m1[1].xyz);
    _9.z = dot(_166, _21_m1[2].xyz);
    _188 = dot(_9.xyz, _9.xyz);
    _188 = rsqrt(_188);
    vs_TEXCOORD2 = _188.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _155 = stage_input._155;
    _166 = stage_input._166;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _MoneyColor;
float _Fill;
float _FillYMin;
float _FillYMax;
float _FillNoise;
float _FillNoiseScale;
float _DepthDarken;
float _SurfaceBand;
float _SurfaceGlow;
float _InteriorTint;
float _InteriorBrightness;
float4 _GlassColor;
#define _18_m0 _WorldSpaceLightPos0
#define _18_m1 _MoneyColor
#define _18_m2 _Fill
#define _18_m3 _FillYMin
#define _18_m4 _FillYMax
#define _18_m5 _FillNoise
#define _18_m6 _FillNoiseScale
#define _18_m7 _DepthDarken
#define _18_m8 _SurfaceBand
#define _18_m9 _SurfaceGlow
#define _18_m10 _InteriorTint
#define _18_m11 _InteriorBrightness
#define _18_m12 _GlassColor


Texture2D<float4> _MoneyTex;
SamplerState sampler_MoneyTex;

static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _470;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _470 : SV_Target0;
};

static float4 _9;
static float2 _34;
static float3 _39;
static float2 _59;
static float4 _87;
static float4 _104;
static float3 _108;
static float _215;
static float _251;
static bool _301;
static float3 _338;
static float _361;
static float3 _372;
static float3 _397;

void frag_inner()
{
    float2 _30 = vs_TEXCOORD0.xz * float2(float2(_18_m6, _18_m6));
    _9 = float4(_30.x, _30.y, _9.z, _9.w);
    _34 = floor(_9.xy);
    float2 _43 = _34 + 1.0f.xx;
    _39 = float3(_43.x, _43.y, _39.z);
    float2 _51 = _39.xy * float2(123.339996337890625f, 456.209991455078125f);
    _39 = float3(_51.x, _51.y, _39.z);
    float2 _56 = frac(_39.xy);
    _39 = float3(_56.x, _56.y, _39.z);
    _59 = _39.xy + 45.31999969482421875f.xx;
    _59.x = dot(_39.xy, _59);
    float2 _77 = _59.xx + _39.xy;
    _39 = float3(_77.x, _77.y, _39.z);
    _39.x = _39.y * _39.x;
    _87 = _34.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _94 = _34 * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_9.x, _9.y, _94.x, _94.y);
    _9 = frac(_9);
    _87 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _87 = frac(_87);
    _104 = _87 + 45.31999969482421875f.xxxx;
    _108.x = dot(_87.zw, _104.zw);
    _59.x = dot(_87.xy, _104.xy);
    _59 = _59.xx + _87.xy;
    float2 _130 = _108.xx + _87.zw;
    _87 = float4(_130.x, _130.y, _87.z, _87.w);
    _39.y = _87.y * _87.x;
    _39.z = _59.y * _59.x;
    _39 = frac(_39);
    _39.x = (-_39.y) + _39.x;
    float2 _159 = _9.xy * _9.xy;
    _87 = float4(_159.x, _159.y, _87.z, _87.w);
    float2 _170 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_170.x, _170.y, _9.z, _9.w);
    float2 _177 = _9.xy * _87.xy;
    _9 = float4(_177.x, _177.y, _9.z, _9.w);
    _39.x = (_9.x * _39.x) + _39.y;
    float2 _191 = _9.zw + 45.31999969482421875f.xx;
    _108 = float3(_191.x, _108.y, _191.y);
    _108.x = dot(_9.zw, _108.xz);
    _34 = _9.zw + _108.xx;
    _34.x = _34.y * _34.x;
    _34.x = frac(_34.x);
    _215 = (-_34.x) + _39.z;
    _9.x = (_9.x * _215) + _34.x;
    _34.x = (-_9.x) + _39.x;
    _9.x = (_9.y * _34.x) + _9.x;
    _9.x += (-0.5f);
    _251 = _18_m2;
    _251 = clamp(_251, 0.0f, 1.0f);
    _34.x = (-_18_m3) + _18_m4;
    _251 = (_251 * _34.x) + _18_m3;
    _34.x = max(_34.x, 9.9999997473787516355514526367188e-05f);
    _34.x = 1.0f / _34.x;
    _9.x = (_9.x * _18_m5) + _251;
    _9.x += (-vs_TEXCOORD0.y);
    _301 = _9.x < 0.0f;
    _9.x = _34.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    if ((int(_301) * (-1)) != 0)
    {
        discard;
    }
    _251 = max(_18_m8, 9.9999997473787516355514526367188e-05f);
    _251 = _9.x / _251;
    _251 = (-_251) + 1.0f;
    _251 = max(_251, 0.0f);
    _338.x = _251 * _251;
    _338.x *= _18_m9;
    _338 = _338.xxx * _18_m1.xyz;
    _338 *= 0.5f.xxx;
    _361 = _18_m7 + (-1.0f);
    _361 = (_9.x * _361) + 1.0f;
    _372 = _MoneyTex.Sample(sampler_MoneyTex, vs_TEXCOORD1).xyz;
    float3 _387 = _372 * _18_m1.xyz;
    _9 = float4(_387.x, _387.y, _387.z, _9.w);
    _338 = (_9.xyz * _361.xxx) + _338;
    _397 = _338 * _18_m12.xyz;
    _397 = (_397 * 2.0f.xxx) + (-_338);
    _338 = (float3(float3(_18_m10, _18_m10, _18_m10)) * _397) + _338;
    _338 *= _18_m11.xxx;
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    float3 _444 = _9.xxx * vs_TEXCOORD2;
    _9 = float4(_444.x, _444.y, _444.z, _9.w);
    _9.x = dot(_9.xyz, _18_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _361 = _9.x + (-1.0f);
    _361 = (_361 * 0.5f) + 1.0f;
    float3 _474 = _361.xxx * _338;
    _470 = float4(_474.x, _474.y, _474.z, _470.w);
    _470.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._470 = _470;
    return stage_output;
}

#endif
#elif defined(_MASKMAP) && defined(_REFRACTION)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 _BumpMap_ST;
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m2 unity_WorldTransformParams
#define _21_m4 _BumpMap_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float2 _87;
static float3 _106;
static float4 vs_TEXCOORD1;
static float4 _189;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _106 : NORMAL;
    float4 _189 : TANGENT;
    float2 _87 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _128;
static float3 _188;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _9 += _21_m0[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    float2 _97 = (_87 * _21_m4.xy) + _21_m4.zw;
    vs_TEXCOORD0 = float4(_97.x, _97.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, 0.0f.xx.x, 0.0f.xx.y);
    _49.x = dot(_106, _21_m1[0].xyz);
    _49.y = dot(_106, _21_m1[1].xyz);
    _49.z = dot(_106, _21_m1[2].xyz);
    _128 = dot(_49.xyz, _49.xyz);
    _128 = rsqrt(_128);
    float3 _141 = _128.xxx * _49.xyz;
    vs_TEXCOORD1 = float4(_141.x, _141.y, _141.z, vs_TEXCOORD1.w);
    float3 _149 = _11.yyy * _21_m0[1].xyz;
    _49 = float4(_149.x, _149.y, _149.z, _49.w);
    float3 _160 = (_21_m0[0].xyz * _11.xxx) + _49.xyz;
    _49 = float4(_160.x, _160.y, _160.z, _49.w);
    float3 _171 = (_21_m0[2].xyz * _11.zzz) + _49.xyz;
    _49 = float4(_171.x, _171.y, _171.z, _49.w);
    float3 _179 = _49.xyz + _21_m0[3].xyz;
    _49 = float4(_179.x, _179.y, _179.z, _49.w);
    vs_TEXCOORD1.w = _49.x;
    _188 = _189.yyy * _21_m0[1].xyz;
    _188 = (_21_m0[0].xyz * _189.xxx) + _188;
    _188 = (_21_m0[2].xyz * _189.zzz) + _188;
    _49.x = dot(_188, _188);
    _49.x = rsqrt(_49.x);
    float3 _224 = _49.xxx * _188;
    vs_TEXCOORD2 = float4(_224.x, _224.y, _224.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _49.y;
    _49.w = _189.w * _21_m2.w;
    vs_TEXCOORD3 = _49.zw;
    float3 _247 = _9.xwy * float3(0.5f, 0.5f, -0.5f);
    _49 = float4(_247.x, _247.y, _247.z, _49.w);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _9.zw.x, _9.zw.y);
    float2 _259 = _49.yy + _49.xz;
    vs_TEXCOORD5 = float4(_259.x, _259.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _87 = stage_input._87;
    _106 = stage_input._106;
    _189 = stage_input._189;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_MatrixV;
static float4 _64_m2[4];
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _GlassColor;
float _GlassAlpha;
float _RefractStrength;
float _AbsorbDensity;
float _RefractTint;
float4 _AbsorbColor;
float4 _FresnelColor;
float _FresnelPower;
float _FresnelIntensity;
float _FresnelAlpha;
float _Reflection;
float4 _ReflectionColor;
float _Gloss;
float _SpecPower;
float4 _SpecTint;
float _Emission;
float _BumpScale;
float _Smoothness;
float _MaskAlphaIsRoughness;
void __unity_init()
{
    _64_m2[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _64_m2[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _64_m2[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _64_m2[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _64_m0 _WorldSpaceCameraPos
#define _64_m1 _WorldSpaceLightPos0
#define _64_m3 unity_SpecCube0_HDR
#define _64_m4 _LightColor0
#define _64_m5 _GlassColor
#define _64_m6 _GlassAlpha
#define _64_m7 _RefractStrength
#define _64_m8 _AbsorbDensity
#define _64_m9 _RefractTint
#define _64_m10 _AbsorbColor
#define _64_m11 _FresnelColor
#define _64_m12 _FresnelPower
#define _64_m13 _FresnelIntensity
#define _64_m14 _FresnelAlpha
#define _64_m15 _Reflection
#define _64_m16 _ReflectionColor
#define _64_m17 _Gloss
#define _64_m18 _SpecPower
#define _64_m19 _SpecTint
#define _64_m20 _Emission
#define _64_m21 _BumpScale
#define _64_m22 _Smoothness
#define _64_m23 _MaskAlphaIsRoughness


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _PigGrabTexture;
SamplerState sampler_PigGrabTexture;
Texture2D<float4> _MaskMap;
SamplerState sampler_MaskMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD5;
static float4 _528;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _528 : SV_Target0;
};

static float3 _9;
static float4 _35;
static float3 _48;
static float _93;
static float3 _103;
static float3 _123;
static float2 _138;
static float3 _216;
static float3 _253;
static float _263;
static float _294;
static float _323;
static float _412;
static float _462;
static float _484;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
    _9 = (vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy) + (-_9);
    _9 *= vs_TEXCOORD3.yyy;
    float3 _45 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _35 = float4(_45.x, _45.y, _45.z, _35.w);
    _48 = (_35.xyz * 2.0f.xxx) + (-1.0f).xxx;
    float2 _71 = _48.xy * _64_m21.xx;
    _48 = float3(_71.x, _71.y, _48.z);
    _9 *= _48.yyy;
    _9 = (_48.xxx * vs_TEXCOORD2.xyz) + _9;
    _9 = (_48.zzz * vs_TEXCOORD1.xyz) + _9;
    _93 = dot(_9, _9);
    _93 = rsqrt(_93);
    _9 = _93.xxx * _9;
    _103.x = _64_m2[0].x;
    _103.y = _64_m2[1].x;
    _103.z = _64_m2[2].x;
    _103.x = dot(_103, _9);
    _123.x = _64_m2[0].y;
    _123.y = _64_m2[1].y;
    _123.z = _64_m2[2].y;
    _103.y = dot(_123, _9);
    _138 = vs_TEXCOORD5.xy / vs_TEXCOORD5.ww;
    float2 _158 = (_103.xy * float2(float2(_64_m7, _64_m7))) + _138;
    _103 = float3(_158.x, _158.y, _103.z);
    _103 = _PigGrabTexture.Sample(sampler_PigGrabTexture, _103.xy).xyz;
    _123.x = vs_TEXCOORD1.w;
    _123.y = vs_TEXCOORD2.w;
    _123.z = vs_TEXCOORD3.x;
    _123 = (-_123) + _64_m0;
    _93 = dot(_123, _123);
    _93 = rsqrt(_93);
    _123 = _93.xxx * _123;
    _93 = dot(_9, _123);
    _93 = clamp(_93, 0.0f, 1.0f);
    _93 = (-_93) + 1.0f;
    _48.x = _93 + 0.3499999940395355224609375f;
    _93 = log2(_93);
    _93 *= _64_m12;
    _93 = exp2(_93);
    _216 = (-_64_m10.xyz) + 1.0f.xxx;
    _216 *= (-float3(float3(_64_m8, _64_m8, _64_m8)));
    _48 = _48.xxx * _216;
    _48 *= 1.44269502162933349609375f.xxx;
    _48 = exp2(_48);
    _48 = _103 * _48;
    _253 = (_48 * _64_m5.xyz) + (-_48);
    _263 = (-_64_m9) + 1.0f;
    _48 = (_263.xxx * _253) + _48;
    _103.x = dot(-_123, _9);
    _103.x += _103.x;
    _103 = (_9 * (-_103.xxx)) + (-_123);
    _294 = _MaskMap.Sample(sampler_MaskMap, vs_TEXCOORD0.xy).w;
    _263 = (_294 * (-2.0f)) + 1.0f;
    _263 = (_64_m23 * _263) + _294;
    _263 *= _64_m22;
    _263 = clamp(_263, 0.0f, 1.0f);
    _253.x = (-_263) + 1.0f;
    _323 = ((-_253.x) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
    _253.x = _323 * _253.x;
    _253.x *= 6.0f;
    _35 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _103, _253.x);
    _253.x = _35.w + (-1.0f);
    _253.x = (_64_m3.w * _253.x) + 1.0f;
    _253.x = log2(_253.x);
    _253.x *= _64_m3.y;
    _253.x = exp2(_253.x);
    _253.x *= _64_m3.x;
    _253 = _35.xyz * _253.xxx;
    _253 *= _64_m16.xyz;
    _253 *= _64_m5.xyz;
    _253 *= float3(float3(_64_m15, _64_m15, _64_m15));
    _412 = (_93 * 0.949999988079071044921875f) + 0.0500000007450580596923828125f;
    _48 = (_253 * _412.xxx) + _48;
    _253 = (-_48) + _64_m11.xyz;
    _412 = _93 * _64_m13;
    _48 = (_412.xxx * _253) + _48;
    _103.x = dot(_64_m1.xyz, _64_m1.xyz);
    _103.x = rsqrt(_103.x);
    _103 = (_64_m1.xyz * _103.xxx) + _123;
    _462 = dot(_103, _103);
    _462 = rsqrt(_462);
    _103 = _462.xxx * _103;
    _9.x = dot(_9, _103);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _484 = _263 * _64_m18;
    _484 = max(_484, 1.0f);
    _9.x *= _484;
    _9.x = exp2(_9.x);
    _9.x *= _64_m17;
    _484 = _263 * _9.x;
    _253 = _64_m4.xyz * _64_m19.xyz;
    _48 = (_253 * _484.xxx) + _48;
    float3 _538 = (_64_m5.xyz * _64_m20.xxx) + _48;
    _528 = float4(_538.x, _538.y, _538.z, _528.w);
    _48.x = (_64_m9 * 0.550000011920928955078125f) + _64_m6;
    _48.x = (_93 * _64_m14) + _48.x;
    _528.w = (_9.x * _263) + _48.x;
    _528.w = clamp(_528.w, 0.0f, 1.0f);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._528 = _528;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _BumpMap_ST;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _BumpMap_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float2 _88;
static float3 _107;
static float4 vs_TEXCOORD1;
static float4 _190;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _107 : NORMAL;
    float4 _190 : TANGENT;
    float2 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _129;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m4[1];
    _49 = (_21_m4[0] * _9.xxxx) + _49;
    _49 = (_21_m4[2] * _9.zzzz) + _49;
    _9 = (_21_m4[3] * _9.wwww) + _49;
    gl_Position = _9;
    float2 _98 = (_88 * _21_m6.xy) + _21_m6.zw;
    vs_TEXCOORD0 = float4(_98.x, _98.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, 0.0f.xx.x, 0.0f.xx.y);
    _49.x = dot(_107, _21_m2[0].xyz);
    _49.y = dot(_107, _21_m2[1].xyz);
    _49.z = dot(_107, _21_m2[2].xyz);
    _129 = dot(_49.xyz, _49.xyz);
    _129 = rsqrt(_129);
    float3 _142 = _129.xxx * _49.xyz;
    vs_TEXCOORD1 = float4(_142.x, _142.y, _142.z, vs_TEXCOORD1.w);
    float3 _150 = _11.yyy * _21_m1[1].xyz;
    _49 = float4(_150.x, _150.y, _150.z, _49.w);
    float3 _161 = (_21_m1[0].xyz * _11.xxx) + _49.xyz;
    _49 = float4(_161.x, _161.y, _161.z, _49.w);
    float3 _172 = (_21_m1[2].xyz * _11.zzz) + _49.xyz;
    _49 = float4(_172.x, _172.y, _172.z, _49.w);
    float3 _180 = _49.xyz + _21_m1[3].xyz;
    _49 = float4(_180.x, _180.y, _180.z, _49.w);
    vs_TEXCOORD1.w = _49.x;
    _189 = _190.yyy * _21_m1[1].xyz;
    _189 = (_21_m1[0].xyz * _190.xxx) + _189;
    _189 = (_21_m1[2].xyz * _190.zzz) + _189;
    _49.x = dot(_189, _189);
    _49.x = rsqrt(_49.x);
    float3 _225 = _49.xxx * _189;
    vs_TEXCOORD2 = float4(_225.x, _225.y, _225.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _49.y;
    vs_TEXCOORD3.x = _49.z;
    _49.x = _9.z / _21_m0.y;
    _49.x = (-_49.x) + 1.0f;
    _49.x *= _21_m0.z;
    _49.x = max(_49.x, 0.0f);
    _49.x *= _21_m5.y;
    vs_TEXCOORD4 = exp2(-_49.x);
    vs_TEXCOORD3.y = _190.w * _21_m3.w;
    float3 _283 = _9.xwy * float3(0.5f, 0.5f, -0.5f);
    _49 = float4(_283.x, _283.y, _283.z, _49.w);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _9.zw.x, _9.zw.y);
    float2 _295 = _49.yy + _49.xz;
    vs_TEXCOORD5 = float4(_295.x, _295.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _107 = stage_input._107;
    _190 = stage_input._190;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _GlassColor;
float _GlassAlpha;
float4 _FresnelColor;
float _FresnelPower;
float _FresnelIntensity;
float _FresnelAlpha;
float _Reflection;
float4 _ReflectionColor;
float _Gloss;
float _SpecPower;
float4 _SpecTint;
float _Emission;
float _BumpScale;
float _Smoothness;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_FogColor
#define _13_m3 unity_SpecCube0_HDR
#define _13_m4 _LightColor0
#define _13_m5 _GlassColor
#define _13_m6 _GlassAlpha
#define _13_m7 _FresnelColor
#define _13_m8 _FresnelPower
#define _13_m9 _FresnelIntensity
#define _13_m10 _FresnelAlpha
#define _13_m11 _Reflection
#define _13_m12 _ReflectionColor
#define _13_m13 _Gloss
#define _13_m14 _SpecPower
#define _13_m15 _SpecTint
#define _13_m16 _Emission
#define _13_m17 _BumpScale
#define _13_m18 _Smoothness


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 _377;
static float vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _377 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _47;
static float3 _71;
static float _116;
static float3 _126;
static float3 _163;
static float3 _181;
static float _264;
static float3 _278;
static float _291;
static float _346;

void frag_inner()
{
    _9.x = (-_13_m18) + 1.0f;
    _27.x = ((-_9.x) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
    _9.x = _27.x * _9.x;
    _9.x *= 6.0f;
    _47 = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
    _47 = (vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy) + (-_47);
    _47 *= vs_TEXCOORD3.yyy;
    _71 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _27 = (_71 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _95 = _27.xy * _13_m17.xx;
    _27 = float3(_95.x, _95.y, _27.z);
    _47 *= _27.yyy;
    _47 = (_27.xxx * vs_TEXCOORD2.xyz) + _47;
    _47 = (_27.zzz * vs_TEXCOORD1.xyz) + _47;
    _116 = dot(_47, _47);
    _116 = rsqrt(_116);
    _47 = _116.xxx * _47;
    _126.x = vs_TEXCOORD1.w;
    _126.y = vs_TEXCOORD2.w;
    _126.z = vs_TEXCOORD3.x;
    _126 = (-_126) + _13_m0;
    _116 = dot(_126, _126);
    _116 = rsqrt(_116);
    _126 = _116.xxx * _126;
    _116 = dot(-_126, _47);
    _116 += _116;
    _163 = (_47 * (-_116.xxx)) + (-_126);
    _9 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _163, _9.x);
    _181.x = _9.w + (-1.0f);
    _181.x = (_13_m3.w * _181.x) + 1.0f;
    _181.x = log2(_181.x);
    _181.x *= _13_m3.y;
    _181.x = exp2(_181.x);
    _181.x *= _13_m3.x;
    _181 = _9.xyz * _181.xxx;
    _181 *= _13_m12.xyz;
    _181 *= _13_m5.xyz;
    _181 *= float3(float3(_13_m11, _13_m11, _13_m11));
    _116 = dot(_47, _126);
    _116 = clamp(_116, 0.0f, 1.0f);
    _116 = (-_116) + 1.0f;
    _116 = log2(_116);
    _116 *= _13_m8;
    _116 = exp2(_116);
    _264 = (_116 * 0.949999988079071044921875f) + 0.0500000007450580596923828125f;
    _181 = (_181 * _264.xxx) + _13_m5.xyz;
    _278 = (-_181) + _13_m7.xyz;
    _264 = _116 * _13_m9;
    _291 = (_116 * _13_m10) + _13_m6;
    _181 = (_264.xxx * _278) + _181;
    _116 = dot(_13_m1.xyz, _13_m1.xyz);
    _116 = rsqrt(_116);
    _126 = (_13_m1.xyz * _116.xxx) + _126;
    _116 = dot(_126, _126);
    _116 = rsqrt(_116);
    _126 = _116.xxx * _126;
    _47.x = dot(_47, _126);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _47.x = log2(_47.x);
    _346 = _13_m14 * _13_m18;
    _346 = max(_346, 1.0f);
    _47.x *= _346;
    _47.x = exp2(_47.x);
    _47.x *= _13_m13;
    _346 = _47.x * _13_m18;
    _377.w = (_47.x * _13_m18) + _291;
    _377.w = clamp(_377.w, 0.0f, 1.0f);
    _278 = _13_m4.xyz * _13_m15.xyz;
    _181 = (_278 * _346.xxx) + _181;
    _181 = (_13_m5.xyz * _13_m16.xxx) + _181;
    _47 = _181 + (-_13_m2.xyz);
    _116 = vs_TEXCOORD4;
    _116 = clamp(_116, 0.0f, 1.0f);
    _47 = (_116.xxx * _47) + _13_m2.xyz;
    _377 = float4(_47.x, _47.y, _47.z, _377.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._377 = _377;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _BumpMap_ST;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _BumpMap_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float2 _88;
static float3 _107;
static float4 vs_TEXCOORD1;
static float4 _190;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _107 : NORMAL;
    float4 _190 : TANGENT;
    float2 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _129;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m4[1];
    _49 = (_21_m4[0] * _9.xxxx) + _49;
    _49 = (_21_m4[2] * _9.zzzz) + _49;
    _9 = (_21_m4[3] * _9.wwww) + _49;
    gl_Position = _9;
    float2 _98 = (_88 * _21_m6.xy) + _21_m6.zw;
    vs_TEXCOORD0 = float4(_98.x, _98.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, 0.0f.xx.x, 0.0f.xx.y);
    _49.x = dot(_107, _21_m2[0].xyz);
    _49.y = dot(_107, _21_m2[1].xyz);
    _49.z = dot(_107, _21_m2[2].xyz);
    _129 = dot(_49.xyz, _49.xyz);
    _129 = rsqrt(_129);
    float3 _142 = _129.xxx * _49.xyz;
    vs_TEXCOORD1 = float4(_142.x, _142.y, _142.z, vs_TEXCOORD1.w);
    float3 _150 = _11.yyy * _21_m1[1].xyz;
    _49 = float4(_150.x, _150.y, _150.z, _49.w);
    float3 _161 = (_21_m1[0].xyz * _11.xxx) + _49.xyz;
    _49 = float4(_161.x, _161.y, _161.z, _49.w);
    float3 _172 = (_21_m1[2].xyz * _11.zzz) + _49.xyz;
    _49 = float4(_172.x, _172.y, _172.z, _49.w);
    float3 _180 = _49.xyz + _21_m1[3].xyz;
    _49 = float4(_180.x, _180.y, _180.z, _49.w);
    vs_TEXCOORD1.w = _49.x;
    _189 = _190.yyy * _21_m1[1].xyz;
    _189 = (_21_m1[0].xyz * _190.xxx) + _189;
    _189 = (_21_m1[2].xyz * _190.zzz) + _189;
    _49.x = dot(_189, _189);
    _49.x = rsqrt(_49.x);
    float3 _225 = _49.xxx * _189;
    vs_TEXCOORD2 = float4(_225.x, _225.y, _225.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _49.y;
    vs_TEXCOORD3.x = _49.z;
    _49.x = _9.z / _21_m0.y;
    _49.x = (-_49.x) + 1.0f;
    _49.x *= _21_m0.z;
    _49.x = max(_49.x, 0.0f);
    _49.x *= _21_m5.x;
    _49.x *= (-_49.x);
    vs_TEXCOORD4 = exp2(_49.x);
    vs_TEXCOORD3.y = _190.w * _21_m3.w;
    float3 _289 = _9.xwy * float3(0.5f, 0.5f, -0.5f);
    _49 = float4(_289.x, _289.y, _289.z, _49.w);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _9.zw.x, _9.zw.y);
    float2 _301 = _49.yy + _49.xz;
    vs_TEXCOORD5 = float4(_301.x, _301.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _107 = stage_input._107;
    _190 = stage_input._190;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _GlassColor;
float _GlassAlpha;
float4 _FresnelColor;
float _FresnelPower;
float _FresnelIntensity;
float _FresnelAlpha;
float _Reflection;
float4 _ReflectionColor;
float _Gloss;
float _SpecPower;
float4 _SpecTint;
float _Emission;
float _BumpScale;
float _Smoothness;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_FogColor
#define _13_m3 unity_SpecCube0_HDR
#define _13_m4 _LightColor0
#define _13_m5 _GlassColor
#define _13_m6 _GlassAlpha
#define _13_m7 _FresnelColor
#define _13_m8 _FresnelPower
#define _13_m9 _FresnelIntensity
#define _13_m10 _FresnelAlpha
#define _13_m11 _Reflection
#define _13_m12 _ReflectionColor
#define _13_m13 _Gloss
#define _13_m14 _SpecPower
#define _13_m15 _SpecTint
#define _13_m16 _Emission
#define _13_m17 _BumpScale
#define _13_m18 _Smoothness


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 _377;
static float vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _377 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _47;
static float3 _71;
static float _116;
static float3 _126;
static float3 _163;
static float3 _181;
static float _264;
static float3 _278;
static float _291;
static float _346;

void frag_inner()
{
    _9.x = (-_13_m18) + 1.0f;
    _27.x = ((-_9.x) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
    _9.x = _27.x * _9.x;
    _9.x *= 6.0f;
    _47 = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
    _47 = (vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy) + (-_47);
    _47 *= vs_TEXCOORD3.yyy;
    _71 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _27 = (_71 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _95 = _27.xy * _13_m17.xx;
    _27 = float3(_95.x, _95.y, _27.z);
    _47 *= _27.yyy;
    _47 = (_27.xxx * vs_TEXCOORD2.xyz) + _47;
    _47 = (_27.zzz * vs_TEXCOORD1.xyz) + _47;
    _116 = dot(_47, _47);
    _116 = rsqrt(_116);
    _47 = _116.xxx * _47;
    _126.x = vs_TEXCOORD1.w;
    _126.y = vs_TEXCOORD2.w;
    _126.z = vs_TEXCOORD3.x;
    _126 = (-_126) + _13_m0;
    _116 = dot(_126, _126);
    _116 = rsqrt(_116);
    _126 = _116.xxx * _126;
    _116 = dot(-_126, _47);
    _116 += _116;
    _163 = (_47 * (-_116.xxx)) + (-_126);
    _9 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _163, _9.x);
    _181.x = _9.w + (-1.0f);
    _181.x = (_13_m3.w * _181.x) + 1.0f;
    _181.x = log2(_181.x);
    _181.x *= _13_m3.y;
    _181.x = exp2(_181.x);
    _181.x *= _13_m3.x;
    _181 = _9.xyz * _181.xxx;
    _181 *= _13_m12.xyz;
    _181 *= _13_m5.xyz;
    _181 *= float3(float3(_13_m11, _13_m11, _13_m11));
    _116 = dot(_47, _126);
    _116 = clamp(_116, 0.0f, 1.0f);
    _116 = (-_116) + 1.0f;
    _116 = log2(_116);
    _116 *= _13_m8;
    _116 = exp2(_116);
    _264 = (_116 * 0.949999988079071044921875f) + 0.0500000007450580596923828125f;
    _181 = (_181 * _264.xxx) + _13_m5.xyz;
    _278 = (-_181) + _13_m7.xyz;
    _264 = _116 * _13_m9;
    _291 = (_116 * _13_m10) + _13_m6;
    _181 = (_264.xxx * _278) + _181;
    _116 = dot(_13_m1.xyz, _13_m1.xyz);
    _116 = rsqrt(_116);
    _126 = (_13_m1.xyz * _116.xxx) + _126;
    _116 = dot(_126, _126);
    _116 = rsqrt(_116);
    _126 = _116.xxx * _126;
    _47.x = dot(_47, _126);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _47.x = log2(_47.x);
    _346 = _13_m14 * _13_m18;
    _346 = max(_346, 1.0f);
    _47.x *= _346;
    _47.x = exp2(_47.x);
    _47.x *= _13_m13;
    _346 = _47.x * _13_m18;
    _377.w = (_47.x * _13_m18) + _291;
    _377.w = clamp(_377.w, 0.0f, 1.0f);
    _278 = _13_m4.xyz * _13_m15.xyz;
    _181 = (_278 * _346.xxx) + _181;
    _181 = (_13_m5.xyz * _13_m16.xxx) + _181;
    _47 = _181 + (-_13_m2.xyz);
    _116 = vs_TEXCOORD4;
    _116 = clamp(_116, 0.0f, 1.0f);
    _47 = (_116.xxx * _47) + _13_m2.xyz;
    _377 = float4(_47.x, _47.y, _47.z, _377.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._377 = _377;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _BumpMap_ST;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _BumpMap_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float2 _88;
static float3 _107;
static float4 vs_TEXCOORD1;
static float4 _190;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _107 : NORMAL;
    float4 _190 : TANGENT;
    float2 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _129;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m4[1];
    _49 = (_21_m4[0] * _9.xxxx) + _49;
    _49 = (_21_m4[2] * _9.zzzz) + _49;
    _9 = (_21_m4[3] * _9.wwww) + _49;
    gl_Position = _9;
    float2 _98 = (_88 * _21_m6.xy) + _21_m6.zw;
    vs_TEXCOORD0 = float4(_98.x, _98.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, 0.0f.xx.x, 0.0f.xx.y);
    _49.x = dot(_107, _21_m2[0].xyz);
    _49.y = dot(_107, _21_m2[1].xyz);
    _49.z = dot(_107, _21_m2[2].xyz);
    _129 = dot(_49.xyz, _49.xyz);
    _129 = rsqrt(_129);
    float3 _142 = _129.xxx * _49.xyz;
    vs_TEXCOORD1 = float4(_142.x, _142.y, _142.z, vs_TEXCOORD1.w);
    float3 _150 = _11.yyy * _21_m1[1].xyz;
    _49 = float4(_150.x, _150.y, _150.z, _49.w);
    float3 _161 = (_21_m1[0].xyz * _11.xxx) + _49.xyz;
    _49 = float4(_161.x, _161.y, _161.z, _49.w);
    float3 _172 = (_21_m1[2].xyz * _11.zzz) + _49.xyz;
    _49 = float4(_172.x, _172.y, _172.z, _49.w);
    float3 _180 = _49.xyz + _21_m1[3].xyz;
    _49 = float4(_180.x, _180.y, _180.z, _49.w);
    vs_TEXCOORD1.w = _49.x;
    _189 = _190.yyy * _21_m1[1].xyz;
    _189 = (_21_m1[0].xyz * _190.xxx) + _189;
    _189 = (_21_m1[2].xyz * _190.zzz) + _189;
    _49.x = dot(_189, _189);
    _49.x = rsqrt(_49.x);
    float3 _225 = _49.xxx * _189;
    vs_TEXCOORD2 = float4(_225.x, _225.y, _225.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _49.y;
    vs_TEXCOORD3.x = _49.z;
    _49.x = _9.z / _21_m0.y;
    _49.x = (-_49.x) + 1.0f;
    _49.x *= _21_m0.z;
    _49.x = max(_49.x, 0.0f);
    vs_TEXCOORD4 = (_49.x * _21_m5.z) + _21_m5.w;
    vs_TEXCOORD3.y = _190.w * _21_m3.w;
    float3 _281 = _9.xwy * float3(0.5f, 0.5f, -0.5f);
    _49 = float4(_281.x, _281.y, _281.z, _49.w);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _9.zw.x, _9.zw.y);
    float2 _293 = _49.yy + _49.xz;
    vs_TEXCOORD5 = float4(_293.x, _293.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _107 = stage_input._107;
    _190 = stage_input._190;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _GlassColor;
float _GlassAlpha;
float4 _FresnelColor;
float _FresnelPower;
float _FresnelIntensity;
float _FresnelAlpha;
float _Reflection;
float4 _ReflectionColor;
float _Gloss;
float _SpecPower;
float4 _SpecTint;
float _Emission;
float _BumpScale;
float _Smoothness;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_FogColor
#define _13_m3 unity_SpecCube0_HDR
#define _13_m4 _LightColor0
#define _13_m5 _GlassColor
#define _13_m6 _GlassAlpha
#define _13_m7 _FresnelColor
#define _13_m8 _FresnelPower
#define _13_m9 _FresnelIntensity
#define _13_m10 _FresnelAlpha
#define _13_m11 _Reflection
#define _13_m12 _ReflectionColor
#define _13_m13 _Gloss
#define _13_m14 _SpecPower
#define _13_m15 _SpecTint
#define _13_m16 _Emission
#define _13_m17 _BumpScale
#define _13_m18 _Smoothness


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 _377;
static float vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _377 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _47;
static float3 _71;
static float _116;
static float3 _126;
static float3 _163;
static float3 _181;
static float _264;
static float3 _278;
static float _291;
static float _346;

void frag_inner()
{
    _9.x = (-_13_m18) + 1.0f;
    _27.x = ((-_9.x) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
    _9.x = _27.x * _9.x;
    _9.x *= 6.0f;
    _47 = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
    _47 = (vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy) + (-_47);
    _47 *= vs_TEXCOORD3.yyy;
    _71 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _27 = (_71 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _95 = _27.xy * _13_m17.xx;
    _27 = float3(_95.x, _95.y, _27.z);
    _47 *= _27.yyy;
    _47 = (_27.xxx * vs_TEXCOORD2.xyz) + _47;
    _47 = (_27.zzz * vs_TEXCOORD1.xyz) + _47;
    _116 = dot(_47, _47);
    _116 = rsqrt(_116);
    _47 = _116.xxx * _47;
    _126.x = vs_TEXCOORD1.w;
    _126.y = vs_TEXCOORD2.w;
    _126.z = vs_TEXCOORD3.x;
    _126 = (-_126) + _13_m0;
    _116 = dot(_126, _126);
    _116 = rsqrt(_116);
    _126 = _116.xxx * _126;
    _116 = dot(-_126, _47);
    _116 += _116;
    _163 = (_47 * (-_116.xxx)) + (-_126);
    _9 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _163, _9.x);
    _181.x = _9.w + (-1.0f);
    _181.x = (_13_m3.w * _181.x) + 1.0f;
    _181.x = log2(_181.x);
    _181.x *= _13_m3.y;
    _181.x = exp2(_181.x);
    _181.x *= _13_m3.x;
    _181 = _9.xyz * _181.xxx;
    _181 *= _13_m12.xyz;
    _181 *= _13_m5.xyz;
    _181 *= float3(float3(_13_m11, _13_m11, _13_m11));
    _116 = dot(_47, _126);
    _116 = clamp(_116, 0.0f, 1.0f);
    _116 = (-_116) + 1.0f;
    _116 = log2(_116);
    _116 *= _13_m8;
    _116 = exp2(_116);
    _264 = (_116 * 0.949999988079071044921875f) + 0.0500000007450580596923828125f;
    _181 = (_181 * _264.xxx) + _13_m5.xyz;
    _278 = (-_181) + _13_m7.xyz;
    _264 = _116 * _13_m9;
    _291 = (_116 * _13_m10) + _13_m6;
    _181 = (_264.xxx * _278) + _181;
    _116 = dot(_13_m1.xyz, _13_m1.xyz);
    _116 = rsqrt(_116);
    _126 = (_13_m1.xyz * _116.xxx) + _126;
    _116 = dot(_126, _126);
    _116 = rsqrt(_116);
    _126 = _116.xxx * _126;
    _47.x = dot(_47, _126);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _47.x = log2(_47.x);
    _346 = _13_m14 * _13_m18;
    _346 = max(_346, 1.0f);
    _47.x *= _346;
    _47.x = exp2(_47.x);
    _47.x *= _13_m13;
    _346 = _47.x * _13_m18;
    _377.w = (_47.x * _13_m18) + _291;
    _377.w = clamp(_377.w, 0.0f, 1.0f);
    _278 = _13_m4.xyz * _13_m15.xyz;
    _181 = (_278 * _346.xxx) + _181;
    _181 = (_13_m5.xyz * _13_m16.xxx) + _181;
    _47 = _181 + (-_13_m2.xyz);
    _116 = vs_TEXCOORD4;
    _116 = clamp(_116, 0.0f, 1.0f);
    _47 = (_116.xxx * _47) + _13_m2.xyz;
    _377 = float4(_47.x, _47.y, _47.z, _377.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._377 = _377;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 _BumpMap_ST;
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m2 unity_WorldTransformParams
#define _21_m4 _BumpMap_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float2 _87;
static float3 _106;
static float4 vs_TEXCOORD1;
static float4 _189;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _106 : NORMAL;
    float4 _189 : TANGENT;
    float2 _87 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _128;
static float3 _188;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _9 += _21_m0[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    float2 _97 = (_87 * _21_m4.xy) + _21_m4.zw;
    vs_TEXCOORD0 = float4(_97.x, _97.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, 0.0f.xx.x, 0.0f.xx.y);
    _49.x = dot(_106, _21_m1[0].xyz);
    _49.y = dot(_106, _21_m1[1].xyz);
    _49.z = dot(_106, _21_m1[2].xyz);
    _128 = dot(_49.xyz, _49.xyz);
    _128 = rsqrt(_128);
    float3 _141 = _128.xxx * _49.xyz;
    vs_TEXCOORD1 = float4(_141.x, _141.y, _141.z, vs_TEXCOORD1.w);
    float3 _149 = _11.yyy * _21_m0[1].xyz;
    _49 = float4(_149.x, _149.y, _149.z, _49.w);
    float3 _160 = (_21_m0[0].xyz * _11.xxx) + _49.xyz;
    _49 = float4(_160.x, _160.y, _160.z, _49.w);
    float3 _171 = (_21_m0[2].xyz * _11.zzz) + _49.xyz;
    _49 = float4(_171.x, _171.y, _171.z, _49.w);
    float3 _179 = _49.xyz + _21_m0[3].xyz;
    _49 = float4(_179.x, _179.y, _179.z, _49.w);
    vs_TEXCOORD1.w = _49.x;
    _188 = _189.yyy * _21_m0[1].xyz;
    _188 = (_21_m0[0].xyz * _189.xxx) + _188;
    _188 = (_21_m0[2].xyz * _189.zzz) + _188;
    _49.x = dot(_188, _188);
    _49.x = rsqrt(_49.x);
    float3 _224 = _49.xxx * _188;
    vs_TEXCOORD2 = float4(_224.x, _224.y, _224.z, vs_TEXCOORD2.w);
    vs_TEXCOORD2.w = _49.y;
    _49.w = _189.w * _21_m2.w;
    vs_TEXCOORD3 = _49.zw;
    float3 _247 = _9.xwy * float3(0.5f, 0.5f, -0.5f);
    _49 = float4(_247.x, _247.y, _247.z, _49.w);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _9.zw.x, _9.zw.y);
    float2 _259 = _49.yy + _49.xz;
    vs_TEXCOORD5 = float4(_259.x, _259.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _87 = stage_input._87;
    _106 = stage_input._106;
    _189 = stage_input._189;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _GlassColor;
float _GlassAlpha;
float4 _FresnelColor;
float _FresnelPower;
float _FresnelIntensity;
float _FresnelAlpha;
float _Reflection;
float4 _ReflectionColor;
float _Gloss;
float _SpecPower;
float4 _SpecTint;
float _Emission;
float _BumpScale;
float _Smoothness;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_SpecCube0_HDR
#define _13_m3 _LightColor0
#define _13_m4 _GlassColor
#define _13_m5 _GlassAlpha
#define _13_m6 _FresnelColor
#define _13_m7 _FresnelPower
#define _13_m8 _FresnelIntensity
#define _13_m9 _FresnelAlpha
#define _13_m10 _Reflection
#define _13_m11 _ReflectionColor
#define _13_m12 _Gloss
#define _13_m13 _SpecPower
#define _13_m14 _SpecTint
#define _13_m15 _Emission
#define _13_m16 _BumpScale
#define _13_m17 _Smoothness


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 _377;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _377 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _47;
static float3 _71;
static float _116;
static float3 _126;
static float3 _163;
static float3 _181;
static float _264;
static float3 _278;
static float _291;
static float _346;

void frag_inner()
{
    _9.x = (-_13_m17) + 1.0f;
    _27.x = ((-_9.x) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
    _9.x = _27.x * _9.x;
    _9.x *= 6.0f;
    _47 = vs_TEXCOORD1.zxy * vs_TEXCOORD2.yzx;
    _47 = (vs_TEXCOORD1.yzx * vs_TEXCOORD2.zxy) + (-_47);
    _47 *= vs_TEXCOORD3.yyy;
    _71 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _27 = (_71 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _95 = _27.xy * _13_m16.xx;
    _27 = float3(_95.x, _95.y, _27.z);
    _47 *= _27.yyy;
    _47 = (_27.xxx * vs_TEXCOORD2.xyz) + _47;
    _47 = (_27.zzz * vs_TEXCOORD1.xyz) + _47;
    _116 = dot(_47, _47);
    _116 = rsqrt(_116);
    _47 = _116.xxx * _47;
    _126.x = vs_TEXCOORD1.w;
    _126.y = vs_TEXCOORD2.w;
    _126.z = vs_TEXCOORD3.x;
    _126 = (-_126) + _13_m0;
    _116 = dot(_126, _126);
    _116 = rsqrt(_116);
    _126 = _116.xxx * _126;
    _116 = dot(-_126, _47);
    _116 += _116;
    _163 = (_47 * (-_116.xxx)) + (-_126);
    _9 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _163, _9.x);
    _181.x = _9.w + (-1.0f);
    _181.x = (_13_m2.w * _181.x) + 1.0f;
    _181.x = log2(_181.x);
    _181.x *= _13_m2.y;
    _181.x = exp2(_181.x);
    _181.x *= _13_m2.x;
    _181 = _9.xyz * _181.xxx;
    _181 *= _13_m11.xyz;
    _181 *= _13_m4.xyz;
    _181 *= float3(float3(_13_m10, _13_m10, _13_m10));
    _116 = dot(_47, _126);
    _116 = clamp(_116, 0.0f, 1.0f);
    _116 = (-_116) + 1.0f;
    _116 = log2(_116);
    _116 *= _13_m7;
    _116 = exp2(_116);
    _264 = (_116 * 0.949999988079071044921875f) + 0.0500000007450580596923828125f;
    _181 = (_181 * _264.xxx) + _13_m4.xyz;
    _278 = (-_181) + _13_m6.xyz;
    _264 = _116 * _13_m8;
    _291 = (_116 * _13_m9) + _13_m5;
    _181 = (_264.xxx * _278) + _181;
    _116 = dot(_13_m1.xyz, _13_m1.xyz);
    _116 = rsqrt(_116);
    _126 = (_13_m1.xyz * _116.xxx) + _126;
    _116 = dot(_126, _126);
    _116 = rsqrt(_116);
    _126 = _116.xxx * _126;
    _47.x = dot(_47, _126);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _47.x = log2(_47.x);
    _346 = _13_m13 * _13_m17;
    _346 = max(_346, 1.0f);
    _47.x *= _346;
    _47.x = exp2(_47.x);
    _47.x *= _13_m12;
    _346 = _47.x * _13_m17;
    _377.w = (_47.x * _13_m17) + _291;
    _377.w = clamp(_377.w, 0.0f, 1.0f);
    _278 = _13_m3.xyz * _13_m14.xyz;
    _181 = (_278 * _346.xxx) + _181;
    float3 _415 = (_13_m4.xyz * _13_m15.xxx) + _181;
    _377 = float4(_415.x, _415.y, _415.z, _377.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._377 = _377;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
 Name "MONEY_CAP"
  LOD 200
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite [_ZWrite]
 Cull Off
   Blend [_SrcBlend] [_DstBlend]
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ _MONEY_MODE
#if defined(FOG_EXP) && defined(_MONEY_MODE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _16_m1[4];
float4x4 unity_MatrixVP;
static float4 _16_m2[4];
float4 unity_FogParams;
float4 _MoneyTex_ST;
float _CapTiling;
float _Fill;
float _FillYMin;
float _FillYMax;
float _FillWorldSpace;
void __unity_init()
{
    _16_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _16_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _16_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _16_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _16_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _16_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _16_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _16_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _16_m0 _ProjectionParams
#define _16_m3 unity_FogParams
#define _16_m4 _MoneyTex_ST
#define _16_m5 _CapTiling
#define _16_m6 _Fill
#define _16_m7 _FillYMin
#define _16_m8 _FillYMax
#define _16_m9 _FillWorldSpace



static float4 gl_Position;
static float4 _134;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _134 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _33;
static float _62;
static float4 _118;
static float4 _126;
static bool _148;
static float4 _199;
static float _256;
static bool _271;
static bool _313;

void vert_inner()
{
    __unity_init();
    _9.x = _16_m6;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _33.x = (-_16_m7) + _16_m8;
    _9.x = (_9.x * _33.x) + _16_m7;
    _33.x *= 0.5f;
    _33.x = max(_33.x, 9.9999997473787516355514526367188e-05f);
    _62 = _16_m7 + _16_m8;
    _9.x = ((-_62) * 0.5f) + _9.x;
    _62 *= 0.5f;
    _9.x /= _33.x;
    _9.x = max(_9.x, -0.98500001430511474609375f);
    _9.x = min(_9.x, 0.98500001430511474609375f);
    _62 = (_9.x * _33.x) + _62;
    _9.x = ((-_9.x) * _9.x) + 1.0f;
    _9.x = sqrt(_9.x);
    _9.x *= _33.x;
    _118 = _62.xxxx * _16_m1[1];
    _126 = _62.xxxx * _16_m2[1];
    _33.x = dot(_134.xz, _134.xz);
    _33.x = sqrt(_33.x);
    _148 = 9.9999997473787516355514526367188e-06f < _33.x;
    float2 _157 = _134.xz / _33.xx;
    _33 = float3(_157.x, _33.y, _157.y);
    float2 _162;
    if (_148)
    {
        _162 = _33.xz;
    }
    else
    {
        _162 = float2(1.0f, 0.0f);
    }
    _33 = float3(_162.x, _162.y, _33.z);
    float2 _176 = _9.xx * _33.xy;
    _33 = float3(_176.x, _176.y, _33.z);
    _118 = (_16_m1[0] * _33.xxxx) + _118;
    _118 = (_16_m1[2] * _33.yyyy) + _118;
    _118 += _16_m1[3];
    _199 = _118.yyyy * _16_m2[1];
    _199 = (_16_m2[0] * _118.xxxx) + _199;
    _199 = (_16_m2[2] * _118.zzzz) + _199;
    _118 = (_16_m2[3] * _118.wwww) + _199;
    float2 _231 = _134.yy * _16_m1[1].xz;
    _199 = float4(_231.x, _231.y, _199.z, _199.w);
    float2 _242 = (_16_m1[0].xz * _134.xx) + _199.xy;
    _199 = float4(_242.x, _242.y, _199.z, _199.w);
    float2 _253 = (_16_m1[2].xz * _134.zz) + _199.xy;
    _199 = float4(_253.x, _253.y, _199.z, _199.w);
    _256 = dot(_199.xy, _199.xy);
    _256 = sqrt(_256);
    float2 _268 = _199.xy / _256.xx;
    _199 = float4(_268.x, _268.y, _199.z, _199.w);
    _271 = 9.9999997473787516355514526367188e-06f < _256;
    float2 _275;
    if (_271)
    {
        _275 = _199.xy;
    }
    else
    {
        _275 = float2(1.0f, 0.0f);
    }
    _199 = float4(_275.x, _275.y, _199.z, _199.w);
    float2 _292 = (_199.xy * _9.xx) + _16_m1[3].xz;
    _9 = float4(_292.x, _9.y, _9.z, _292.y);
    _126 = (_16_m2[0] * _9.xxxx) + _126;
    _126 = (_16_m2[2] * _9.wwww) + _126;
    _126 += _16_m2[3];
    _313 = 0.5f < _16_m9;
    bool4 _322 = _313.xxxx;
    _118 = float4(_322.x ? _126.x : _118.x, _322.y ? _126.y : _118.y, _322.z ? _126.z : _118.z, _322.w ? _126.w : _118.w);
    float2 _325;
    if (_313)
    {
        _325 = _9.xw;
    }
    else
    {
        _325 = _33.xy;
    }
    _9 = float4(_325.x, _325.y, _9.z, _9.w);
    float2 _346 = (_9.xy * _16_m4.xy) + _16_m4.zw;
    _9 = float4(_346.x, _346.y, _9.z, _9.w);
    vs_TEXCOORD0 = _9.xy * _16_m5.xx;
    gl_Position = _118;
    _9.x = _118.z / _16_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _16_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _16_m3.y;
    vs_TEXCOORD1 = exp2(-_9.x);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _134 = stage_input._134;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _MoneyColor;
float _CapSurfaceGlow;
float _Fill;
float _SurfaceGlow;
float _InteriorTint;
float _InteriorBrightness;
float4 _GlassColor;
#define _13_m0 _WorldSpaceLightPos0
#define _13_m1 unity_FogColor
#define _13_m2 _MoneyColor
#define _13_m3 _CapSurfaceGlow
#define _13_m4 _Fill
#define _13_m5 _SurfaceGlow
#define _13_m6 _InteriorTint
#define _13_m7 _InteriorBrightness
#define _13_m8 _GlassColor


Texture2D<float4> _MoneyTex;
SamplerState sampler_MoneyTex;

static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _184;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _184 : SV_Target0;
};

static float3 _9;
static bool _36;
static float3 _50;
static float3 _77;
static float3 _96;
static float _144;
static float _169;

void frag_inner()
{
    _9.x = _13_m4;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x += (-0.00100010004825890064239501953125f);
    _36 = _9.x < 0.0f;
    if ((int(_36) * (-1)) != 0)
    {
        discard;
    }
    _50.x = _13_m3 * _13_m3;
    _50.x *= _13_m5;
    _50 = _50.xxx * _13_m2.xyz;
    _50 *= 0.5f.xxx;
    _77 = _MoneyTex.Sample(sampler_MoneyTex, vs_TEXCOORD0).xyz;
    _50 = (_77 * _13_m2.xyz) + _50;
    _96 = _50 * _13_m8.xyz;
    _96 = (_96 * 2.0f.xxx) + (-_50);
    _50 = (float3(float3(_13_m6, _13_m6, _13_m6)) * _96) + _50;
    _50 *= _13_m7.xxx;
    _9.x = dot(_13_m0.xyz, _13_m0.xyz);
    _9.x = rsqrt(_9.x);
    _144 = _9.x * _13_m0.y;
    _144 = clamp(_144, 0.0f, 1.0f);
    _144 = (_144 * 0.5f) + (-0.5f);
    _144 = (_144 * 0.5f) + 1.0f;
    _9 = (_50 * _144.xxx) + (-_13_m1.xyz);
    _169 = vs_TEXCOORD1;
    _169 = clamp(_169, 0.0f, 1.0f);
    _9 = (_169.xxx * _9) + _13_m1.xyz;
    _184 = float4(_9.x, _9.y, _9.z, _184.w);
    _184.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._184 = _184;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(_MONEY_MODE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _16_m1[4];
float4x4 unity_MatrixVP;
static float4 _16_m2[4];
float4 unity_FogParams;
float4 _MoneyTex_ST;
float _CapTiling;
float _Fill;
float _FillYMin;
float _FillYMax;
float _FillWorldSpace;
void __unity_init()
{
    _16_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _16_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _16_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _16_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _16_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _16_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _16_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _16_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _16_m0 _ProjectionParams
#define _16_m3 unity_FogParams
#define _16_m4 _MoneyTex_ST
#define _16_m5 _CapTiling
#define _16_m6 _Fill
#define _16_m7 _FillYMin
#define _16_m8 _FillYMax
#define _16_m9 _FillWorldSpace



static float4 gl_Position;
static float4 _134;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _134 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _33;
static float _62;
static float4 _118;
static float4 _126;
static bool _148;
static float4 _199;
static float _256;
static bool _271;
static bool _313;

void vert_inner()
{
    __unity_init();
    _9.x = _16_m6;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _33.x = (-_16_m7) + _16_m8;
    _9.x = (_9.x * _33.x) + _16_m7;
    _33.x *= 0.5f;
    _33.x = max(_33.x, 9.9999997473787516355514526367188e-05f);
    _62 = _16_m7 + _16_m8;
    _9.x = ((-_62) * 0.5f) + _9.x;
    _62 *= 0.5f;
    _9.x /= _33.x;
    _9.x = max(_9.x, -0.98500001430511474609375f);
    _9.x = min(_9.x, 0.98500001430511474609375f);
    _62 = (_9.x * _33.x) + _62;
    _9.x = ((-_9.x) * _9.x) + 1.0f;
    _9.x = sqrt(_9.x);
    _9.x *= _33.x;
    _118 = _62.xxxx * _16_m1[1];
    _126 = _62.xxxx * _16_m2[1];
    _33.x = dot(_134.xz, _134.xz);
    _33.x = sqrt(_33.x);
    _148 = 9.9999997473787516355514526367188e-06f < _33.x;
    float2 _157 = _134.xz / _33.xx;
    _33 = float3(_157.x, _33.y, _157.y);
    float2 _162;
    if (_148)
    {
        _162 = _33.xz;
    }
    else
    {
        _162 = float2(1.0f, 0.0f);
    }
    _33 = float3(_162.x, _162.y, _33.z);
    float2 _176 = _9.xx * _33.xy;
    _33 = float3(_176.x, _176.y, _33.z);
    _118 = (_16_m1[0] * _33.xxxx) + _118;
    _118 = (_16_m1[2] * _33.yyyy) + _118;
    _118 += _16_m1[3];
    _199 = _118.yyyy * _16_m2[1];
    _199 = (_16_m2[0] * _118.xxxx) + _199;
    _199 = (_16_m2[2] * _118.zzzz) + _199;
    _118 = (_16_m2[3] * _118.wwww) + _199;
    float2 _231 = _134.yy * _16_m1[1].xz;
    _199 = float4(_231.x, _231.y, _199.z, _199.w);
    float2 _242 = (_16_m1[0].xz * _134.xx) + _199.xy;
    _199 = float4(_242.x, _242.y, _199.z, _199.w);
    float2 _253 = (_16_m1[2].xz * _134.zz) + _199.xy;
    _199 = float4(_253.x, _253.y, _199.z, _199.w);
    _256 = dot(_199.xy, _199.xy);
    _256 = sqrt(_256);
    float2 _268 = _199.xy / _256.xx;
    _199 = float4(_268.x, _268.y, _199.z, _199.w);
    _271 = 9.9999997473787516355514526367188e-06f < _256;
    float2 _275;
    if (_271)
    {
        _275 = _199.xy;
    }
    else
    {
        _275 = float2(1.0f, 0.0f);
    }
    _199 = float4(_275.x, _275.y, _199.z, _199.w);
    float2 _292 = (_199.xy * _9.xx) + _16_m1[3].xz;
    _9 = float4(_292.x, _9.y, _9.z, _292.y);
    _126 = (_16_m2[0] * _9.xxxx) + _126;
    _126 = (_16_m2[2] * _9.wwww) + _126;
    _126 += _16_m2[3];
    _313 = 0.5f < _16_m9;
    bool4 _322 = _313.xxxx;
    _118 = float4(_322.x ? _126.x : _118.x, _322.y ? _126.y : _118.y, _322.z ? _126.z : _118.z, _322.w ? _126.w : _118.w);
    float2 _325;
    if (_313)
    {
        _325 = _9.xw;
    }
    else
    {
        _325 = _33.xy;
    }
    _9 = float4(_325.x, _325.y, _9.z, _9.w);
    float2 _346 = (_9.xy * _16_m4.xy) + _16_m4.zw;
    _9 = float4(_346.x, _346.y, _9.z, _9.w);
    vs_TEXCOORD0 = _9.xy * _16_m5.xx;
    gl_Position = _118;
    _9.x = _118.z / _16_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _16_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _16_m3.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD1 = exp2(_9.x);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _134 = stage_input._134;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _MoneyColor;
float _CapSurfaceGlow;
float _Fill;
float _SurfaceGlow;
float _InteriorTint;
float _InteriorBrightness;
float4 _GlassColor;
#define _13_m0 _WorldSpaceLightPos0
#define _13_m1 unity_FogColor
#define _13_m2 _MoneyColor
#define _13_m3 _CapSurfaceGlow
#define _13_m4 _Fill
#define _13_m5 _SurfaceGlow
#define _13_m6 _InteriorTint
#define _13_m7 _InteriorBrightness
#define _13_m8 _GlassColor


Texture2D<float4> _MoneyTex;
SamplerState sampler_MoneyTex;

static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _184;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _184 : SV_Target0;
};

static float3 _9;
static bool _36;
static float3 _50;
static float3 _77;
static float3 _96;
static float _144;
static float _169;

void frag_inner()
{
    _9.x = _13_m4;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x += (-0.00100010004825890064239501953125f);
    _36 = _9.x < 0.0f;
    if ((int(_36) * (-1)) != 0)
    {
        discard;
    }
    _50.x = _13_m3 * _13_m3;
    _50.x *= _13_m5;
    _50 = _50.xxx * _13_m2.xyz;
    _50 *= 0.5f.xxx;
    _77 = _MoneyTex.Sample(sampler_MoneyTex, vs_TEXCOORD0).xyz;
    _50 = (_77 * _13_m2.xyz) + _50;
    _96 = _50 * _13_m8.xyz;
    _96 = (_96 * 2.0f.xxx) + (-_50);
    _50 = (float3(float3(_13_m6, _13_m6, _13_m6)) * _96) + _50;
    _50 *= _13_m7.xxx;
    _9.x = dot(_13_m0.xyz, _13_m0.xyz);
    _9.x = rsqrt(_9.x);
    _144 = _9.x * _13_m0.y;
    _144 = clamp(_144, 0.0f, 1.0f);
    _144 = (_144 * 0.5f) + (-0.5f);
    _144 = (_144 * 0.5f) + 1.0f;
    _9 = (_50 * _144.xxx) + (-_13_m1.xyz);
    _169 = vs_TEXCOORD1;
    _169 = clamp(_169, 0.0f, 1.0f);
    _9 = (_169.xxx * _9) + _13_m1.xyz;
    _184 = float4(_9.x, _9.y, _9.z, _184.w);
    _184.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._184 = _184;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(_MONEY_MODE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _16_m1[4];
float4x4 unity_MatrixVP;
static float4 _16_m2[4];
float4 unity_FogParams;
float4 _MoneyTex_ST;
float _CapTiling;
float _Fill;
float _FillYMin;
float _FillYMax;
float _FillWorldSpace;
void __unity_init()
{
    _16_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _16_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _16_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _16_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _16_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _16_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _16_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _16_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _16_m0 _ProjectionParams
#define _16_m3 unity_FogParams
#define _16_m4 _MoneyTex_ST
#define _16_m5 _CapTiling
#define _16_m6 _Fill
#define _16_m7 _FillYMin
#define _16_m8 _FillYMax
#define _16_m9 _FillWorldSpace



static float4 gl_Position;
static float4 _134;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _134 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _33;
static float _62;
static float4 _118;
static float4 _126;
static bool _148;
static float4 _199;
static float _256;
static bool _271;
static bool _313;

void vert_inner()
{
    __unity_init();
    _9.x = _16_m6;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _33.x = (-_16_m7) + _16_m8;
    _9.x = (_9.x * _33.x) + _16_m7;
    _33.x *= 0.5f;
    _33.x = max(_33.x, 9.9999997473787516355514526367188e-05f);
    _62 = _16_m7 + _16_m8;
    _9.x = ((-_62) * 0.5f) + _9.x;
    _62 *= 0.5f;
    _9.x /= _33.x;
    _9.x = max(_9.x, -0.98500001430511474609375f);
    _9.x = min(_9.x, 0.98500001430511474609375f);
    _62 = (_9.x * _33.x) + _62;
    _9.x = ((-_9.x) * _9.x) + 1.0f;
    _9.x = sqrt(_9.x);
    _9.x *= _33.x;
    _118 = _62.xxxx * _16_m1[1];
    _126 = _62.xxxx * _16_m2[1];
    _33.x = dot(_134.xz, _134.xz);
    _33.x = sqrt(_33.x);
    _148 = 9.9999997473787516355514526367188e-06f < _33.x;
    float2 _157 = _134.xz / _33.xx;
    _33 = float3(_157.x, _33.y, _157.y);
    float2 _162;
    if (_148)
    {
        _162 = _33.xz;
    }
    else
    {
        _162 = float2(1.0f, 0.0f);
    }
    _33 = float3(_162.x, _162.y, _33.z);
    float2 _176 = _9.xx * _33.xy;
    _33 = float3(_176.x, _176.y, _33.z);
    _118 = (_16_m1[0] * _33.xxxx) + _118;
    _118 = (_16_m1[2] * _33.yyyy) + _118;
    _118 += _16_m1[3];
    _199 = _118.yyyy * _16_m2[1];
    _199 = (_16_m2[0] * _118.xxxx) + _199;
    _199 = (_16_m2[2] * _118.zzzz) + _199;
    _118 = (_16_m2[3] * _118.wwww) + _199;
    float2 _231 = _134.yy * _16_m1[1].xz;
    _199 = float4(_231.x, _231.y, _199.z, _199.w);
    float2 _242 = (_16_m1[0].xz * _134.xx) + _199.xy;
    _199 = float4(_242.x, _242.y, _199.z, _199.w);
    float2 _253 = (_16_m1[2].xz * _134.zz) + _199.xy;
    _199 = float4(_253.x, _253.y, _199.z, _199.w);
    _256 = dot(_199.xy, _199.xy);
    _256 = sqrt(_256);
    float2 _268 = _199.xy / _256.xx;
    _199 = float4(_268.x, _268.y, _199.z, _199.w);
    _271 = 9.9999997473787516355514526367188e-06f < _256;
    float2 _275;
    if (_271)
    {
        _275 = _199.xy;
    }
    else
    {
        _275 = float2(1.0f, 0.0f);
    }
    _199 = float4(_275.x, _275.y, _199.z, _199.w);
    float2 _292 = (_199.xy * _9.xx) + _16_m1[3].xz;
    _9 = float4(_292.x, _9.y, _9.z, _292.y);
    _126 = (_16_m2[0] * _9.xxxx) + _126;
    _126 = (_16_m2[2] * _9.wwww) + _126;
    _126 += _16_m2[3];
    _313 = 0.5f < _16_m9;
    bool4 _322 = _313.xxxx;
    _118 = float4(_322.x ? _126.x : _118.x, _322.y ? _126.y : _118.y, _322.z ? _126.z : _118.z, _322.w ? _126.w : _118.w);
    float2 _325;
    if (_313)
    {
        _325 = _9.xw;
    }
    else
    {
        _325 = _33.xy;
    }
    _9 = float4(_325.x, _325.y, _9.z, _9.w);
    float2 _346 = (_9.xy * _16_m4.xy) + _16_m4.zw;
    _9 = float4(_346.x, _346.y, _9.z, _9.w);
    vs_TEXCOORD0 = _9.xy * _16_m5.xx;
    gl_Position = _118;
    _9.x = _118.z / _16_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _16_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD1 = (_9.x * _16_m3.z) + _16_m3.w;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _134 = stage_input._134;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _MoneyColor;
float _CapSurfaceGlow;
float _Fill;
float _SurfaceGlow;
float _InteriorTint;
float _InteriorBrightness;
float4 _GlassColor;
#define _13_m0 _WorldSpaceLightPos0
#define _13_m1 unity_FogColor
#define _13_m2 _MoneyColor
#define _13_m3 _CapSurfaceGlow
#define _13_m4 _Fill
#define _13_m5 _SurfaceGlow
#define _13_m6 _InteriorTint
#define _13_m7 _InteriorBrightness
#define _13_m8 _GlassColor


Texture2D<float4> _MoneyTex;
SamplerState sampler_MoneyTex;

static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _184;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _184 : SV_Target0;
};

static float3 _9;
static bool _36;
static float3 _50;
static float3 _77;
static float3 _96;
static float _144;
static float _169;

void frag_inner()
{
    _9.x = _13_m4;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x += (-0.00100010004825890064239501953125f);
    _36 = _9.x < 0.0f;
    if ((int(_36) * (-1)) != 0)
    {
        discard;
    }
    _50.x = _13_m3 * _13_m3;
    _50.x *= _13_m5;
    _50 = _50.xxx * _13_m2.xyz;
    _50 *= 0.5f.xxx;
    _77 = _MoneyTex.Sample(sampler_MoneyTex, vs_TEXCOORD0).xyz;
    _50 = (_77 * _13_m2.xyz) + _50;
    _96 = _50 * _13_m8.xyz;
    _96 = (_96 * 2.0f.xxx) + (-_50);
    _50 = (float3(float3(_13_m6, _13_m6, _13_m6)) * _96) + _50;
    _50 *= _13_m7.xxx;
    _9.x = dot(_13_m0.xyz, _13_m0.xyz);
    _9.x = rsqrt(_9.x);
    _144 = _9.x * _13_m0.y;
    _144 = clamp(_144, 0.0f, 1.0f);
    _144 = (_144 * 0.5f) + (-0.5f);
    _144 = (_144 * 0.5f) + 1.0f;
    _9 = (_50 * _144.xxx) + (-_13_m1.xyz);
    _169 = vs_TEXCOORD1;
    _169 = clamp(_169, 0.0f, 1.0f);
    _9 = (_169.xxx * _9) + _13_m1.xyz;
    _184 = float4(_9.x, _9.y, _9.z, _184.w);
    _184.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._184 = _184;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_FogParams;
#define _25_m0 _ProjectionParams
#define _25_m1 unity_FogParams



static float4 gl_Position;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD1 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float _22;

void vert_inner()
{
    gl_Position = float4(2.0f, 2.0f, 2.0f, 1.0f);
    _22 = 2.0f / _25_m0.y;
    _22 = (-_22) + 1.0f;
    _22 *= _25_m0.z;
    _22 = max(_22, 0.0f);
    _22 *= _25_m1.y;
    vs_TEXCOORD1 = exp2(-_22);
}

SPIRV_Cross_Output vert()
{
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_FogParams;
#define _25_m0 _ProjectionParams
#define _25_m1 unity_FogParams



static float4 gl_Position;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD1 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float _22;

void vert_inner()
{
    gl_Position = float4(2.0f, 2.0f, 2.0f, 1.0f);
    _22 = 2.0f / _25_m0.y;
    _22 = (-_22) + 1.0f;
    _22 *= _25_m0.z;
    _22 = max(_22, 0.0f);
    _22 *= _25_m1.x;
    _22 *= (-_22);
    vs_TEXCOORD1 = exp2(_22);
}

SPIRV_Cross_Output vert()
{
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_FogParams;
#define _25_m0 _ProjectionParams
#define _25_m1 unity_FogParams



static float4 gl_Position;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD1 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float _22;

void vert_inner()
{
    gl_Position = float4(2.0f, 2.0f, 2.0f, 1.0f);
    _22 = 2.0f / _25_m0.y;
    _22 = (-_22) + 1.0f;
    _22 *= _25_m0.z;
    _22 = max(_22, 0.0f);
    vs_TEXCOORD1 = (_22 * _25_m1.z) + _25_m1.w;
}

SPIRV_Cross_Output vert()
{
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(_MONEY_MODE)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _16_m0[4];
float4x4 unity_MatrixVP;
static float4 _16_m1[4];
float4 _MoneyTex_ST;
float _CapTiling;
float _Fill;
float _FillYMin;
float _FillYMax;
float _FillWorldSpace;
void __unity_init()
{
    _16_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _16_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _16_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _16_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _16_m1[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _16_m1[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _16_m1[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _16_m1[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _16_m2 _MoneyTex_ST
#define _16_m3 _CapTiling
#define _16_m4 _Fill
#define _16_m5 _FillYMin
#define _16_m6 _FillYMax
#define _16_m7 _FillWorldSpace



static float4 gl_Position;
static float4 _134;
static float2 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _134 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _33;
static float _62;
static float4 _118;
static float4 _127;
static bool _148;
static float4 _199;
static float _256;
static bool _271;
static bool _313;

void vert_inner()
{
    __unity_init();
    _9.x = _16_m4;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _33.x = (-_16_m5) + _16_m6;
    _9.x = (_9.x * _33.x) + _16_m5;
    _33.x *= 0.5f;
    _33.x = max(_33.x, 9.9999997473787516355514526367188e-05f);
    _62 = _16_m5 + _16_m6;
    _9.x = ((-_62) * 0.5f) + _9.x;
    _62 *= 0.5f;
    _9.x /= _33.x;
    _9.x = max(_9.x, -0.98500001430511474609375f);
    _9.x = min(_9.x, 0.98500001430511474609375f);
    _62 = (_9.x * _33.x) + _62;
    _9.x = ((-_9.x) * _9.x) + 1.0f;
    _9.x = sqrt(_9.x);
    _9.x *= _33.x;
    _118 = _62.xxxx * _16_m0[1];
    _127 = _62.xxxx * _16_m1[1];
    _33.x = dot(_134.xz, _134.xz);
    _33.x = sqrt(_33.x);
    _148 = 9.9999997473787516355514526367188e-06f < _33.x;
    float2 _157 = _134.xz / _33.xx;
    _33 = float3(_157.x, _33.y, _157.y);
    float2 _162;
    if (_148)
    {
        _162 = _33.xz;
    }
    else
    {
        _162 = float2(1.0f, 0.0f);
    }
    _33 = float3(_162.x, _162.y, _33.z);
    float2 _176 = _9.xx * _33.xy;
    _33 = float3(_176.x, _176.y, _33.z);
    _118 = (_16_m0[0] * _33.xxxx) + _118;
    _118 = (_16_m0[2] * _33.yyyy) + _118;
    _118 += _16_m0[3];
    _199 = _118.yyyy * _16_m1[1];
    _199 = (_16_m1[0] * _118.xxxx) + _199;
    _199 = (_16_m1[2] * _118.zzzz) + _199;
    _118 = (_16_m1[3] * _118.wwww) + _199;
    float2 _231 = _134.yy * _16_m0[1].xz;
    _199 = float4(_231.x, _231.y, _199.z, _199.w);
    float2 _242 = (_16_m0[0].xz * _134.xx) + _199.xy;
    _199 = float4(_242.x, _242.y, _199.z, _199.w);
    float2 _253 = (_16_m0[2].xz * _134.zz) + _199.xy;
    _199 = float4(_253.x, _253.y, _199.z, _199.w);
    _256 = dot(_199.xy, _199.xy);
    _256 = sqrt(_256);
    float2 _268 = _199.xy / _256.xx;
    _199 = float4(_268.x, _268.y, _199.z, _199.w);
    _271 = 9.9999997473787516355514526367188e-06f < _256;
    float2 _275;
    if (_271)
    {
        _275 = _199.xy;
    }
    else
    {
        _275 = float2(1.0f, 0.0f);
    }
    _199 = float4(_275.x, _275.y, _199.z, _199.w);
    float2 _292 = (_199.xy * _9.xx) + _16_m0[3].xz;
    _9 = float4(_292.x, _9.y, _9.z, _292.y);
    _127 = (_16_m1[0] * _9.xxxx) + _127;
    _127 = (_16_m1[2] * _9.wwww) + _127;
    _127 += _16_m1[3];
    _313 = 0.5f < _16_m7;
    bool4 _327 = _313.xxxx;
    gl_Position = float4(_327.x ? _127.x : _118.x, _327.y ? _127.y : _118.y, _327.z ? _127.z : _118.z, _327.w ? _127.w : _118.w);
    float2 _332;
    if (_313)
    {
        _332 = _9.xw;
    }
    else
    {
        _332 = _33.xy;
    }
    _9 = float4(_332.x, _332.y, _9.z, _9.w);
    float2 _352 = (_9.xy * _16_m2.xy) + _16_m2.zw;
    _9 = float4(_352.x, _352.y, _9.z, _9.w);
    vs_TEXCOORD0 = _9.xy * _16_m3.xx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _134 = stage_input._134;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _MoneyColor;
float _CapSurfaceGlow;
float _Fill;
float _SurfaceGlow;
float _InteriorTint;
float _InteriorBrightness;
float4 _GlassColor;
#define _12_m0 _WorldSpaceLightPos0
#define _12_m1 _MoneyColor
#define _12_m2 _CapSurfaceGlow
#define _12_m3 _Fill
#define _12_m4 _SurfaceGlow
#define _12_m5 _InteriorTint
#define _12_m6 _InteriorBrightness
#define _12_m7 _GlassColor


Texture2D<float4> _MoneyTex;
SamplerState sampler_MoneyTex;

static float2 vs_TEXCOORD0;
static float4 _150;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _150 : SV_Target0;
};

static float _8;
static bool _27;
static float3 _42;
static float3 _70;
static float3 _89;
static float _134;

void frag_inner()
{
    _8 = _12_m3;
    _8 = clamp(_8, 0.0f, 1.0f);
    _8 += (-0.00100010004825890064239501953125f);
    _27 = _8 < 0.0f;
    if ((int(_27) * (-1)) != 0)
    {
        discard;
    }
    _42.x = _12_m2 * _12_m2;
    _42.x *= _12_m4;
    _42 = _42.xxx * _12_m1.xyz;
    _42 *= 0.5f.xxx;
    _70 = _MoneyTex.Sample(sampler_MoneyTex, vs_TEXCOORD0).xyz;
    _42 = (_70 * _12_m1.xyz) + _42;
    _89 = _42 * _12_m7.xyz;
    _89 = (_89 * 2.0f.xxx) + (-_42);
    _42 = (float3(float3(_12_m5, _12_m5, _12_m5)) * _89) + _42;
    _42 *= _12_m6.xxx;
    _8 = dot(_12_m0.xyz, _12_m0.xyz);
    _8 = rsqrt(_8);
    _134 = _8 * _12_m0.y;
    _134 = clamp(_134, 0.0f, 1.0f);
    _134 = (_134 * 0.5f) + (-0.5f);
    _134 = (_134 * 0.5f) + 1.0f;
    float3 _154 = _134.xxx * _42;
    _150 = float4(_154.x, _154.y, _154.z, _150.w);
    _150.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._150 = _150;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)


static float4 gl_Position;
struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

void vert_inner()
{
    gl_Position = float4(2.0f, 2.0f, 2.0f, 1.0f);
}

SPIRV_Cross_Output vert()
{
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}