// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SoreBones/SpectatorGhostDark" {
Properties {

[Header(Normal Look)] _MainTex ("Albedo", 2D) = "white" { }

_Color ("Color", Color) = (1,1,1,1)

_BumpMap ("Normal Map", 2D) = "bump" { }

_BumpScale ("Normal Scale", Float) = 1.0

_MetallicGlossMap ("Metallic (R) Smoothness (A)", 2D) = "white" { }

_Metallic ("Metallic (x map R)", Range(0, 1)) = 0.0

_Glossiness ("Smoothness (x map A)", Range(0, 1)) = 0.5

_EmissionMap ("Emission", 2D) = "white" { }

_EmissionColor ("Emission Color", Color) = (0,0,0,1)

_VolumeSpecular ("Volume Specular", Range(0, 1)) = 1.0

[ToggleUI] _GlossyReflections ("Reflection Probe", Float) = 1.0

[Header(Darkness)] _GhostBelow ("Full Ghost Below", Range(0, 1)) = 0.05000000074505806

_NormalAbove ("Full Normal Above", Range(0, 1)) = 0.15000000596046448

[Header(Ghost Look)] _GhostColor ("Bone Tint", Color) = (0.75,0.75,0.75,1)

_GhostOpacity ("Opacity", Range(0, 1)) = 0.0

_GhostSelfLight ("Self Light", Range(0, 1)) = 0.10999999940395355

_BlackPoint ("Black Point", Range(0, 1)) = 0.2150000035762787

_WhitePoint ("White Point", Range(0, 1)) = 0.6959999799728394

_DarkClear ("Dark See-Through", Range(0, 1)) = 0.75

_Waver ("Waver", Range(0, 1)) = 0.3869999945163727

_RimColor ("Rim Color", Color) = (0.742,4,3.162,1)

_RimPower ("Rim Power", Range(0.5, 8)) = 1.7899999618530273

_RimStrength ("Rim Strength", Range(0, 4)) = 0.27000001072883606

_PulseSpeed ("Pulse Speed", Float) = 2.7200000286102295

_PulseAmount ("Pulse Amount", Range(0, 1)) = 0.47999998927116394

[ToggleUI] _FadeWithDistance ("Fade With Distance", Float) = 1.0

_FadeNear ("Fade Near", Float) = 1.5

_FadeFar ("Fade Far", Float) = 3.0

[Header(Both Looks)] _InsideShade ("Inside Shade", Range(0, 1)) = 0.11999999731779099

[ToggleUI] _DoubleSided ("Double Sided", Float) = 0.0

_VolumeMin ("Volume Min", Vector) = (0,0,0,1)

_VolumeInvSize ("Volume Inv Size", Vector) = (1000000.0,1000000.0,1000000.0,1)

}
SubShader {
 LOD 300
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
ZWrite On
 Name "GhostDepth"
  LOD 300
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Cull Off
   ColorMask 0
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_MatrixVP;
static float4 _21_m1[4];
float _GhostBelow;
float _NormalAbove;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m1[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m1[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m1[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m2 _GhostBelow
#define _21_m3 _NormalAbove
#define _21_m4 _VolumeMin
#define _21_m5 _VolumeInvSize
#define _21_m6 _GlobalVolumeMin
#define _21_m7 _GlobalVolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;

static float4 gl_Position;
static float4 _12;
static float4 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float4 _54;
static bool _87;
static float3 _111;
static float _163;

void vert_inner()
{
    __unity_init();
    _9 = _12.yyy * _21_m0[1].xyz;
    _9 = (_21_m0[0].xyz * _12.xxx) + _9;
    _9 = (_21_m0[2].xyz * _12.zzz) + _9;
    _9 += _21_m0[3].xyz;
    _54 = _9.yyyy * _21_m1[1];
    _54 = (_21_m1[0] * _9.xxxx) + _54;
    _54 = (_21_m1[2] * _9.zzzz) + _54;
    gl_Position = _54 + _21_m1[3];
    _87 = 1000000.0f < _21_m5.x;
    float3 _97;
    if (_87)
    {
        _97 = _21_m6;
    }
    else
    {
        _97 = _21_m4;
    }
    _54 = float4(_97.x, _97.y, _97.z, _54.w);
    float3 _113;
    if (_87)
    {
        _113 = _21_m7;
    }
    else
    {
        _113 = _21_m5;
    }
    _111 = _113;
    float3 _127 = _9 + (-_54.xyz);
    _54 = float4(_127.x, _127.y, _127.z, _54.w);
    vs_TEXCOORD0 = float4(_9.x, _9.y, _9.z, vs_TEXCOORD0.w);
    _9 = _111 * _54.xyz;
    _9 = _Volume0.SampleLevel(sampler_Volume0, _9, 0.0f).xyz;
    _9.x = dot(_9, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    _9.x = max(_9.x, 0.0f);
    _9.x = sqrt(_9.x);
    _163 = _21_m2 + 0.001000000047497451305389404296875f;
    _9.y = max(_163, _21_m3);
    float2 _180 = _9.xy + (-_21_m2.xx);
    _9 = float3(_180.x, _180.y, _9.z);
    _163 = 1.0f / _9.y;
    _9.x = _163 * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _163 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    vs_TEXCOORD0.w = ((-_163) * _9.x) + 1.0f;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float _FadeWithDistance;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _FadeWithDistance
#define _17_m2 _FadeNear
#define _17_m3 _FadeFar
#define _17_m4 _GhostSeeAll



static float4 vs_TEXCOORD0;
static float4 _111;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _111 : SV_Target0;
};

static float3 _9;
static float _45;
static bool _98;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyz + (-_17_m0);
    _9.x = dot(_9, _9);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + _17_m3;
    _45 = (-_17_m2) + _17_m3;
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _9.x /= _45;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = max(_9.x, _17_m4);
    _9.x += (-1.0f);
    _9.x *= _17_m1;
    _9.x = (vs_TEXCOORD0.w * _9.x) + 0.980000019073486328125f;
    _98 = _9.x < 0.0f;
    if ((int(_98) * (-1)) != 0)
    {
        discard;
    }
    _111 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._111 = _111;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
 Name "Ghost"
  LOD 300
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
float _GhostBelow;
float _NormalAbove;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _MainTex_ST;
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m6 _GhostBelow
#define _22_m7 _NormalAbove
#define _22_m8 _VolumeMin
#define _22_m9 _VolumeInvSize
#define _22_m10 _GlobalVolumeMin
#define _22_m11 _GlobalVolumeInvSize
#define _22_m12 _MainTex_ST


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float2 _252;
static float4 vs_TEXCOORD1;
static float3 _272;
static float4 _309;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _272 : NORMAL;
    float4 _309 : TANGENT;
    float2 _252 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float vs_TEXCOORD7 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _65;
static float _99;
static bool _147;
static float3 _155;
static float4 _170;
static float _211;
static float3 _308;
static float3 _344;

void vert_inner()
{
    __unity_init();
    float3 _29 = _11.yyy * _22_m1[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _41 = (_22_m1[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_41.x, _41.y, _41.z, _9.w);
    float3 _53 = (_22_m1[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _62 = _9.xyz + _22_m1[3].xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _9.yyyy * _22_m4[1];
    _65 = (_22_m4[0] * _9.xxxx) + _65;
    _65 = (_22_m4[2] * _9.zzzz) + _65;
    _65 += _22_m4[3];
    gl_Position = _65;
    _99 = _65.z / _22_m0.y;
    _99 = (-_99) + 1.0f;
    _99 *= _22_m0.z;
    _99 = max(_99, 0.0f);
    _99 *= _22_m5.y;
    vs_TEXCOORD7 = exp2(-_99);
    _99 = _22_m6 + 0.001000000047497451305389404296875f;
    _99 = max(_99, _22_m7);
    _99 += (-_22_m6);
    _99 = 1.0f / _99;
    _147 = 1000000.0f < _22_m9.x;
    float3 _158;
    if (_147)
    {
        _158 = _22_m10;
    }
    else
    {
        _158 = _22_m8;
    }
    _155 = _158;
    float3 _172;
    if (_147)
    {
        _172 = _22_m11;
    }
    else
    {
        _172 = _22_m9;
    }
    _170 = float4(_172.x, _172.y, _172.z, _170.w);
    float3 _188 = _9.xyz + (-_155);
    _65 = float4(_188.x, _188.y, _188.z, _65.w);
    float3 _195 = _170.xyz * _65.xyz;
    _65 = float4(_195.x, _195.y, _195.z, _65.w);
    _170 = _Volume0.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    _211 = dot(_170.xyz, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    vs_TEXCOORD4 = _170;
    _211 = max(_211, 0.0f);
    _211 = sqrt(_211);
    _211 += (-_22_m6);
    _99 *= _211;
    _99 = clamp(_99, 0.0f, 1.0f);
    _211 = (_99 * (-2.0f)) + 3.0f;
    _99 *= _99;
    vs_TEXCOORD0.z = ((-_211) * _99) + 1.0f;
    float2 _262 = (_252 * _22_m12.xy) + _22_m12.zw;
    vs_TEXCOORD0 = float4(_262.x, _262.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0.w = 0.0f;
    vs_TEXCOORD1.w = _9.x;
    _170.y = dot(_272, _22_m2[0].xyz);
    _170.z = dot(_272, _22_m2[1].xyz);
    _170.x = dot(_272, _22_m2[2].xyz);
    _9.x = dot(_170.xyz, _170.xyz);
    _9.x = rsqrt(_9.x);
    float3 _305 = _9.xxx * _170.xyz;
    _170 = float4(_305.x, _305.y, _305.z, _170.w);
    _308 = _309.yyy * _22_m1[1].yzx;
    _308 = (_22_m1[0].yzx * _309.xxx) + _308;
    _308 = (_22_m1[2].yzx * _309.zzz) + _308;
    _9.x = dot(_308, _308);
    _9.x = rsqrt(_9.x);
    _308 = _9.xxx * _308;
    _344 = _170.xyz * _308;
    _344 = (_170.zxy * _308.yzx) + (-_344);
    _344 *= _309.www;
    _344 *= _22_m3.www;
    vs_TEXCOORD1.y = _344.x;
    vs_TEXCOORD1.x = _308.z;
    vs_TEXCOORD1.z = _170.y;
    vs_TEXCOORD2.x = _308.x;
    vs_TEXCOORD3.x = _308.y;
    vs_TEXCOORD2.z = _170.z;
    vs_TEXCOORD3.z = _170.x;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _344.y;
    vs_TEXCOORD3.y = _344.z;
    _9 = _Volume1.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    _65 = _Volume2.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    vs_TEXCOORD6 = _65;
    vs_TEXCOORD5 = _9;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _252 = stage_input._252;
    _272 = stage_input._272;
    _309 = stage_input._309;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_IndirectSpecColor;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float _FadeWithDistance;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
float4 _Color;
float _BumpScale;
float _Metallic;
float _Glossiness;
float4 _EmissionColor;
float _VolumeSpecular;
float _GlossyReflections;
float4 _GhostColor;
float _GhostOpacity;
float _GhostSelfLight;
float _BlackPoint;
float _WhitePoint;
float _DarkClear;
float _Waver;
float4 _RimColor;
float _RimPower;
float _RimStrength;
float _PulseSpeed;
float _PulseAmount;
float _InsideShade;
float _DoubleSided;
#define _38_m0 _Time
#define _38_m1 _WorldSpaceCameraPos
#define _38_m2 unity_IndirectSpecColor
#define _38_m3 unity_FogColor
#define _38_m4 unity_SpecCube0_HDR
#define _38_m5 _FadeWithDistance
#define _38_m6 _FadeNear
#define _38_m7 _FadeFar
#define _38_m8 _GhostSeeAll
#define _38_m9 _Color
#define _38_m10 _BumpScale
#define _38_m11 _Metallic
#define _38_m12 _Glossiness
#define _38_m13 _EmissionColor
#define _38_m14 _VolumeSpecular
#define _38_m15 _GlossyReflections
#define _38_m16 _GhostColor
#define _38_m17 _GhostOpacity
#define _38_m18 _GhostSelfLight
#define _38_m19 _BlackPoint
#define _38_m20 _WhitePoint
#define _38_m21 _DarkClear
#define _38_m22 _Waver
#define _38_m23 _RimColor
#define _38_m24 _RimPower
#define _38_m25 _RimStrength
#define _38_m26 _PulseSpeed
#define _38_m27 _PulseAmount
#define _38_m28 _InsideShade
#define _38_m29 _DoubleSided


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState sampler_unity_SpecCube0;

static bool gl_FrontFacing;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD5;
static float vs_TEXCOORD7;
static float4 _1047;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float vs_TEXCOORD7 : TEXCOORD7;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _1047 : SV_Target0;
};

static float4 _9;
static float3 _32;
static float _45;
static float3 _72;
static bool _90;
static float3 _98;
static float2 _109;
static float3 _119;
static float3 _129;
static float3 _146;
static float _162;
static float3 _172;
static float _201;
static float3 _207;
static float4 _212;
static float3 _235;
static float3 _252;
static float3 _271;
static float3 _298;
static float3 _302;
static float _351;
static float3 _359;
static float4 _380;
static float _496;
static float _504;
static float _512;
static float3 _705;
static float _754;
static float _816;
static float _848;
static float _928;
static float3 _992;
static float _994;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    _32 = (-_9.xyz) + _38_m1;
    _45 = dot(_32, _32);
    _45 = rsqrt(_45);
    _32 = _45.xxx * _32;
    _45 = (-_38_m29) + 1.0f;
    _45 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 0.0f : _45;
    _72 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _90 = vs_TEXCOORD0.z < 0.999000012874603271484375f;
    if (_90)
    {
        _98 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
        _109 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0.xy).xw;
        _119 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
        _129 = (_98 * 2.0f.xxx) + (-1.0f).xxx;
        float2 _143 = _129.xy * _38_m10.xx;
        _129 = float3(_143.x, _143.y, _129.z);
        _146.x = dot(vs_TEXCOORD1.xyz, _129);
        _146.y = dot(vs_TEXCOORD2.xyz, _129);
        _146.z = dot(vs_TEXCOORD3.xyz, _129);
        _162 = dot(_146, _146);
        _162 = rsqrt(_162);
        _146 = _162.xxx * _146;
        _172 = _72 * _38_m9.xyz;
        _162 = _109.x * _38_m11;
        _129 = (_72 * _38_m9.xyz) + (-0.039999999105930328369140625f).xxx;
        _129 = (_162.xxx * _129) + 0.039999999105930328369140625f.xxx;
        _201 = ((-_162) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
        _207 = _201.xxx * _172;
        float3 _218 = max(vs_TEXCOORD4.xyz, 9.9999997473787516355514526367188e-06f.xxx);
        _212 = float4(_218.x, _212.y, _218.y, _218.z);
        _172 = vs_TEXCOORD6.xyz * vs_TEXCOORD6.xyz;
        _172 = (vs_TEXCOORD5.xyz * vs_TEXCOORD5.xyz) + _172;
        _235.x = vs_TEXCOORD4.w;
        _235.y = vs_TEXCOORD5.w;
        _235.z = vs_TEXCOORD6.w;
        _172 = (_235 * _235) + _172;
        _172 = sqrt(_172);
        _252 = _146.yyy * vs_TEXCOORD6.xyz;
        _252 = (vs_TEXCOORD5.xyz * _146.xxx) + _252;
        _252 = (_235 * _146.zzz) + _252;
        _271 = max(_172, 9.9999999747524270787835121154785e-07f.xxx);
        _252 /= _271;
        _252 = (_252 * 0.5f.xxx) + 0.5f.xxx;
        _252 = clamp(_252, 0.0f.xxx, 1.0f.xxx);
        _172 *= 0.5f.xxx;
        _172 /= _212.xzw;
        _271 = (_172 * 2.0f.xxx) + 1.0f.xxx;
        _298 = (-_172) + 1.0f.xxx;
        _302 = _172 + 1.0f.xxx;
        _298 /= _302;
        _302 = (-_298) + 1.0f.xxx;
        _172 = (_172 * 2.0f.xxx) + 2.0f.xxx;
        _172 *= _302;
        _252 = log2(_252);
        _252 *= _271;
        _252 = exp2(_252);
        _172 = (_172 * _252) + _298;
        _172 = _212.xzw * _172;
        _172 = max(_172, 0.0f.xxx);
        _90 = 0.5f < _38_m15;
        if (_90)
        {
            _162 = ((-_109.y) * _38_m12) + 1.0f;
            _351 = dot(-_32, _146);
            _351 += _351;
            _359 = (_146 * (-_351.xxx)) + (-_32);
            _351 = ((-_162) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
            _351 = _162 * _351;
            _351 *= 6.0f;
            _380 = unity_SpecCube0.SampleLevel(sampler_unity_SpecCube0, _359, _351);
            _351 = _380.w + (-1.0f);
            _351 = (_38_m4.w * _351) + 1.0f;
            _351 = log2(_351);
            _351 *= _38_m4.y;
            _351 = exp2(_351);
            _351 *= _38_m4.x;
            _359 = _380.xyz * _351.xxx;
        }
        else
        {
            _359 = _38_m2.xyz;
        }
        float3 _425 = 1.0f.xxx / _212.xzw;
        _212 = float4(_425.x, _212.y, _425.y, _425.z);
        _252 = _212.xzw * vs_TEXCOORD5.xyz;
        _252.x = dot(_252, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _271 = _212.xzw * vs_TEXCOORD6.xyz;
        _252.y = dot(_271, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        float3 _451 = _212.xzw * _235;
        _212 = float4(_451.x, _212.y, _451.y, _451.z);
        _252.z = dot(_212.xzw, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _162 = dot(_252, _252);
        _162 = max(_162, 0.001000000047497451305389404296875f);
        _162 = rsqrt(_162);
        float3 _471 = (_252 * _162.xxx) + _32;
        _212 = float4(_471.x, _212.y, _471.y, _471.z);
        _162 = dot(_212.xzw, _212.xzw);
        _162 = max(_162, 0.001000000047497451305389404296875f);
        _162 = rsqrt(_162);
        float3 _487 = _162.xxx * _212.xzw;
        _212 = float4(_487.x, _212.y, _487.y, _487.z);
        _162 = dot(_146, _212.xzw);
        _162 = clamp(_162, 0.0f, 1.0f);
        _496 = ((-_109.y) * _38_m12) + 1.0f;
        _504 = _496 * _496;
        _212.x = _504 * _504;
        _512 = (_162 * _212.x) + (-_162);
        _162 = (_512 * _162) + 1.0f;
        _212.x *= 0.3183098733425140380859375f;
        _162 = (_162 * _162) + 1.0000000116860974230803549289703e-07f;
        _162 = _212.x / _162;
        float3 _545 = (_252.xxx * vs_TEXCOORD5.xyz) + vs_TEXCOORD4.xyz;
        _212 = float4(_545.x, _212.y, _545.y, _545.z);
        float3 _555 = (_252.yyy * vs_TEXCOORD6.xyz) + _212.xzw;
        _212 = float4(_555.x, _212.y, _555.y, _555.z);
        float3 _564 = (_252.zzz * _235) + _212.xzw;
        _212 = float4(_564.x, _212.y, _564.y, _564.z);
        float3 _571 = _162.xxx * _212.xzw;
        _212 = float4(_571.x, _212.y, _571.y, _571.z);
        float3 _576 = max(_212.xzw, 0.0f.xxx);
        _212 = float4(_576.x, _212.y, _576.y, _576.z);
        float3 _587 = (_212.xzw * _38_m14.xxx) + _359;
        _212 = float4(_587.x, _212.y, _587.y, _587.z);
        _162 = dot(_146, _32);
        _162 = clamp(_162, 0.0f, 1.0f);
        _351 = ((-_496) * 0.07999999821186065673828125f) + 0.60000002384185791015625f;
        _235.x = _496 * _504;
        _351 = ((-_235.x) * _351) + 1.0f;
        _201 = (-_201) + 1.0f;
        _201 = (_109.y * _38_m12) + _201;
        _201 = clamp(_201, 0.0f, 1.0f);
        _235 = _212.xzw * _351.xxx;
        _351 = (-_162) + 1.0f;
        _351 *= _351;
        _351 *= _351;
        _359 = (-_129) + _201.xxx;
        _129 = (_351.xxx * _359) + _129;
        _129 *= _235;
        _146 = (_172 * _207) + _129;
        _129 = (_119 * _38_m13.xyz) + _146;
        _162 = _38_m28 + (-1.0f);
        _162 = (_45 * _162) + 1.0f;
        _146 = _162.xxx * _129;
        _98 = _146;
    }
    else
    {
        _98.x = 0.0f;
        _98.y = 0.0f;
        _98.z = 0.0f;
    }
    _90 = 0.001000000047497451305389404296875f < vs_TEXCOORD0.z;
    if (_90)
    {
        _129.x = dot(_72, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
        _129.x = sqrt(_129.x);
        _162 = _129.x + (-_38_m19);
        _705.x = (-_38_m19) + _38_m20;
        _705.x = max(_705.x, 0.001000000047497451305389404296875f);
        _162 /= _705.x;
        _162 = clamp(_162, 0.0f, 1.0f);
        _129.x = _162 * _162;
        float3 _733 = _9.xyz + (-_38_m1);
        _9 = float4(_733.x, _733.y, _733.z, _9.w);
        _9.x = dot(_9.xyz, _9.xyz);
        _9.x = sqrt(_9.x);
        _9.x = (-_9.x) + _38_m7;
        _754 = (-_38_m6) + _38_m7;
        _754 = max(_754, 0.001000000047497451305389404296875f);
        _9.x /= _754;
        _9.x = clamp(_9.x, 0.0f, 1.0f);
        _9.x = max(_9.x, _38_m8);
        _9.x += (-1.0f);
        _9.x = (_38_m5 * _9.x) + 1.0f;
        _754 = _38_m0.y * 2.5f;
        _754 = (vs_TEXCOORD2.w * 9.0f) + (-_754);
        _754 = sin(_754);
        _754 = (_754 * 0.5f) + 0.5f;
        _754 = ((-_38_m22) * _754) + 1.0f;
        _816 = (_162 * _162) + (-1.0f);
        _816 = (_38_m21 * _816) + 1.0f;
        _816 *= _38_m17;
        _754 *= _816;
        _754 = clamp(_754, 0.0f, 1.0f);
        _754 = _9.x * _754;
        _705 = _129.xxx * _38_m16.xyz;
        _848 = dot(vs_TEXCOORD4.xyz, float3(0.0396819151937961578369140625f, 0.4580217897891998291015625f, 0.0060965395532548427581787109375f));
        _162 = _848 + _38_m18;
        _705 = _162.xxx * _705;
        _162 = _38_m28 + (-1.0f);
        _162 = (_45 * _162) + 1.0f;
        _705 = _162.xxx * _705;
        _212.x = vs_TEXCOORD1.z;
        _212.y = vs_TEXCOORD2.z;
        _212.z = vs_TEXCOORD3.z;
        _162 = dot(_212.xyz, _212.xyz);
        _162 = rsqrt(_162);
        float3 _896 = _162.xxx * _212.xyz;
        _212 = float4(_896.x, _896.y, _896.z, _212.w);
        _32.x = dot(_212.xyz, _32);
        _32.x = clamp(_32.x, 0.0f, 1.0f);
        _32.x = (-_32.x) + 1.0f;
        _32.x = log2(_32.x);
        _32.x *= _38_m24;
        _32.x = exp2(_32.x);
        _928 = (-_45) + 1.0f;
        _32.x = _928 * _32.x;
        _32.x = _129.x * _32.x;
        _928 = _38_m0.y * _38_m26;
        _928 = sin(_928);
        _928 = (_928 * 0.5f) + 0.5f;
        _928 = ((-_38_m27) * _928) + 1.0f;
        _32.x *= _38_m25;
        _32.x = _928 * _32.x;
        _32.x = _9.x * _32.x;
        _32 = _32.xxx * _38_m23.xyz;
        _32 = (_705 * _754.xxx) + _32;
        _992 = _32;
        _994 = _754;
    }
    else
    {
        _992.x = 0.0f;
        _992.y = 0.0f;
        _992.z = 0.0f;
        _994 = 0.0f;
    }
    _705 = (-_98) + _992;
    _705 = (vs_TEXCOORD0.zzz * _705) + _98;
    _496 = _994 + (-1.0f);
    _9.w = (vs_TEXCOORD0.z * _496) + 1.0f;
    _129 = _9.www * _38_m3.xyz;
    _496 = vs_TEXCOORD7;
    _496 = clamp(_496, 0.0f, 1.0f);
    _705 = ((-_38_m3.xyz) * _9.www) + _705;
    float3 _1043 = (_496.xxx * _705) + _129;
    _9 = float4(_1043.x, _1043.y, _1043.z, _9.w);
    _1047 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1047 = _1047;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
float _GhostBelow;
float _NormalAbove;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _MainTex_ST;
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m6 _GhostBelow
#define _22_m7 _NormalAbove
#define _22_m8 _VolumeMin
#define _22_m9 _VolumeInvSize
#define _22_m10 _GlobalVolumeMin
#define _22_m11 _GlobalVolumeInvSize
#define _22_m12 _MainTex_ST


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float2 _255;
static float4 vs_TEXCOORD1;
static float3 _275;
static float4 _312;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _275 : NORMAL;
    float4 _312 : TANGENT;
    float2 _255 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float vs_TEXCOORD7 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _65;
static float _99;
static bool _151;
static float3 _158;
static float4 _173;
static float _214;
static float3 _311;
static float3 _347;

void vert_inner()
{
    __unity_init();
    float3 _29 = _11.yyy * _22_m1[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _41 = (_22_m1[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_41.x, _41.y, _41.z, _9.w);
    float3 _53 = (_22_m1[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _62 = _9.xyz + _22_m1[3].xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _9.yyyy * _22_m4[1];
    _65 = (_22_m4[0] * _9.xxxx) + _65;
    _65 = (_22_m4[2] * _9.zzzz) + _65;
    _65 += _22_m4[3];
    gl_Position = _65;
    _99 = _65.z / _22_m0.y;
    _99 = (-_99) + 1.0f;
    _99 *= _22_m0.z;
    _99 = max(_99, 0.0f);
    _99 *= _22_m5.x;
    _99 *= (-_99);
    vs_TEXCOORD7 = exp2(_99);
    _99 = _22_m6 + 0.001000000047497451305389404296875f;
    _99 = max(_99, _22_m7);
    _99 += (-_22_m6);
    _99 = 1.0f / _99;
    _151 = 1000000.0f < _22_m9.x;
    float3 _161;
    if (_151)
    {
        _161 = _22_m10;
    }
    else
    {
        _161 = _22_m8;
    }
    _158 = _161;
    float3 _175;
    if (_151)
    {
        _175 = _22_m11;
    }
    else
    {
        _175 = _22_m9;
    }
    _173 = float4(_175.x, _175.y, _175.z, _173.w);
    float3 _191 = _9.xyz + (-_158);
    _65 = float4(_191.x, _191.y, _191.z, _65.w);
    float3 _198 = _173.xyz * _65.xyz;
    _65 = float4(_198.x, _198.y, _198.z, _65.w);
    _173 = _Volume0.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    _214 = dot(_173.xyz, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    vs_TEXCOORD4 = _173;
    _214 = max(_214, 0.0f);
    _214 = sqrt(_214);
    _214 += (-_22_m6);
    _99 *= _214;
    _99 = clamp(_99, 0.0f, 1.0f);
    _214 = (_99 * (-2.0f)) + 3.0f;
    _99 *= _99;
    vs_TEXCOORD0.z = ((-_214) * _99) + 1.0f;
    float2 _265 = (_255 * _22_m12.xy) + _22_m12.zw;
    vs_TEXCOORD0 = float4(_265.x, _265.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0.w = 0.0f;
    vs_TEXCOORD1.w = _9.x;
    _173.y = dot(_275, _22_m2[0].xyz);
    _173.z = dot(_275, _22_m2[1].xyz);
    _173.x = dot(_275, _22_m2[2].xyz);
    _9.x = dot(_173.xyz, _173.xyz);
    _9.x = rsqrt(_9.x);
    float3 _308 = _9.xxx * _173.xyz;
    _173 = float4(_308.x, _308.y, _308.z, _173.w);
    _311 = _312.yyy * _22_m1[1].yzx;
    _311 = (_22_m1[0].yzx * _312.xxx) + _311;
    _311 = (_22_m1[2].yzx * _312.zzz) + _311;
    _9.x = dot(_311, _311);
    _9.x = rsqrt(_9.x);
    _311 = _9.xxx * _311;
    _347 = _173.xyz * _311;
    _347 = (_173.zxy * _311.yzx) + (-_347);
    _347 *= _312.www;
    _347 *= _22_m3.www;
    vs_TEXCOORD1.y = _347.x;
    vs_TEXCOORD1.x = _311.z;
    vs_TEXCOORD1.z = _173.y;
    vs_TEXCOORD2.x = _311.x;
    vs_TEXCOORD3.x = _311.y;
    vs_TEXCOORD2.z = _173.z;
    vs_TEXCOORD3.z = _173.x;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _347.y;
    vs_TEXCOORD3.y = _347.z;
    _9 = _Volume1.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    _65 = _Volume2.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    vs_TEXCOORD6 = _65;
    vs_TEXCOORD5 = _9;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _255 = stage_input._255;
    _275 = stage_input._275;
    _312 = stage_input._312;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_IndirectSpecColor;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float _FadeWithDistance;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
float4 _Color;
float _BumpScale;
float _Metallic;
float _Glossiness;
float4 _EmissionColor;
float _VolumeSpecular;
float _GlossyReflections;
float4 _GhostColor;
float _GhostOpacity;
float _GhostSelfLight;
float _BlackPoint;
float _WhitePoint;
float _DarkClear;
float _Waver;
float4 _RimColor;
float _RimPower;
float _RimStrength;
float _PulseSpeed;
float _PulseAmount;
float _InsideShade;
float _DoubleSided;
#define _38_m0 _Time
#define _38_m1 _WorldSpaceCameraPos
#define _38_m2 unity_IndirectSpecColor
#define _38_m3 unity_FogColor
#define _38_m4 unity_SpecCube0_HDR
#define _38_m5 _FadeWithDistance
#define _38_m6 _FadeNear
#define _38_m7 _FadeFar
#define _38_m8 _GhostSeeAll
#define _38_m9 _Color
#define _38_m10 _BumpScale
#define _38_m11 _Metallic
#define _38_m12 _Glossiness
#define _38_m13 _EmissionColor
#define _38_m14 _VolumeSpecular
#define _38_m15 _GlossyReflections
#define _38_m16 _GhostColor
#define _38_m17 _GhostOpacity
#define _38_m18 _GhostSelfLight
#define _38_m19 _BlackPoint
#define _38_m20 _WhitePoint
#define _38_m21 _DarkClear
#define _38_m22 _Waver
#define _38_m23 _RimColor
#define _38_m24 _RimPower
#define _38_m25 _RimStrength
#define _38_m26 _PulseSpeed
#define _38_m27 _PulseAmount
#define _38_m28 _InsideShade
#define _38_m29 _DoubleSided


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState sampler_unity_SpecCube0;

static bool gl_FrontFacing;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD5;
static float vs_TEXCOORD7;
static float4 _1047;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float vs_TEXCOORD7 : TEXCOORD7;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _1047 : SV_Target0;
};

static float4 _9;
static float3 _32;
static float _45;
static float3 _72;
static bool _90;
static float3 _98;
static float2 _109;
static float3 _119;
static float3 _129;
static float3 _146;
static float _162;
static float3 _172;
static float _201;
static float3 _207;
static float4 _212;
static float3 _235;
static float3 _252;
static float3 _271;
static float3 _298;
static float3 _302;
static float _351;
static float3 _359;
static float4 _380;
static float _496;
static float _504;
static float _512;
static float3 _705;
static float _754;
static float _816;
static float _848;
static float _928;
static float3 _992;
static float _994;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    _32 = (-_9.xyz) + _38_m1;
    _45 = dot(_32, _32);
    _45 = rsqrt(_45);
    _32 = _45.xxx * _32;
    _45 = (-_38_m29) + 1.0f;
    _45 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 0.0f : _45;
    _72 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _90 = vs_TEXCOORD0.z < 0.999000012874603271484375f;
    if (_90)
    {
        _98 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
        _109 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0.xy).xw;
        _119 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
        _129 = (_98 * 2.0f.xxx) + (-1.0f).xxx;
        float2 _143 = _129.xy * _38_m10.xx;
        _129 = float3(_143.x, _143.y, _129.z);
        _146.x = dot(vs_TEXCOORD1.xyz, _129);
        _146.y = dot(vs_TEXCOORD2.xyz, _129);
        _146.z = dot(vs_TEXCOORD3.xyz, _129);
        _162 = dot(_146, _146);
        _162 = rsqrt(_162);
        _146 = _162.xxx * _146;
        _172 = _72 * _38_m9.xyz;
        _162 = _109.x * _38_m11;
        _129 = (_72 * _38_m9.xyz) + (-0.039999999105930328369140625f).xxx;
        _129 = (_162.xxx * _129) + 0.039999999105930328369140625f.xxx;
        _201 = ((-_162) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
        _207 = _201.xxx * _172;
        float3 _218 = max(vs_TEXCOORD4.xyz, 9.9999997473787516355514526367188e-06f.xxx);
        _212 = float4(_218.x, _212.y, _218.y, _218.z);
        _172 = vs_TEXCOORD6.xyz * vs_TEXCOORD6.xyz;
        _172 = (vs_TEXCOORD5.xyz * vs_TEXCOORD5.xyz) + _172;
        _235.x = vs_TEXCOORD4.w;
        _235.y = vs_TEXCOORD5.w;
        _235.z = vs_TEXCOORD6.w;
        _172 = (_235 * _235) + _172;
        _172 = sqrt(_172);
        _252 = _146.yyy * vs_TEXCOORD6.xyz;
        _252 = (vs_TEXCOORD5.xyz * _146.xxx) + _252;
        _252 = (_235 * _146.zzz) + _252;
        _271 = max(_172, 9.9999999747524270787835121154785e-07f.xxx);
        _252 /= _271;
        _252 = (_252 * 0.5f.xxx) + 0.5f.xxx;
        _252 = clamp(_252, 0.0f.xxx, 1.0f.xxx);
        _172 *= 0.5f.xxx;
        _172 /= _212.xzw;
        _271 = (_172 * 2.0f.xxx) + 1.0f.xxx;
        _298 = (-_172) + 1.0f.xxx;
        _302 = _172 + 1.0f.xxx;
        _298 /= _302;
        _302 = (-_298) + 1.0f.xxx;
        _172 = (_172 * 2.0f.xxx) + 2.0f.xxx;
        _172 *= _302;
        _252 = log2(_252);
        _252 *= _271;
        _252 = exp2(_252);
        _172 = (_172 * _252) + _298;
        _172 = _212.xzw * _172;
        _172 = max(_172, 0.0f.xxx);
        _90 = 0.5f < _38_m15;
        if (_90)
        {
            _162 = ((-_109.y) * _38_m12) + 1.0f;
            _351 = dot(-_32, _146);
            _351 += _351;
            _359 = (_146 * (-_351.xxx)) + (-_32);
            _351 = ((-_162) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
            _351 = _162 * _351;
            _351 *= 6.0f;
            _380 = unity_SpecCube0.SampleLevel(sampler_unity_SpecCube0, _359, _351);
            _351 = _380.w + (-1.0f);
            _351 = (_38_m4.w * _351) + 1.0f;
            _351 = log2(_351);
            _351 *= _38_m4.y;
            _351 = exp2(_351);
            _351 *= _38_m4.x;
            _359 = _380.xyz * _351.xxx;
        }
        else
        {
            _359 = _38_m2.xyz;
        }
        float3 _425 = 1.0f.xxx / _212.xzw;
        _212 = float4(_425.x, _212.y, _425.y, _425.z);
        _252 = _212.xzw * vs_TEXCOORD5.xyz;
        _252.x = dot(_252, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _271 = _212.xzw * vs_TEXCOORD6.xyz;
        _252.y = dot(_271, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        float3 _451 = _212.xzw * _235;
        _212 = float4(_451.x, _212.y, _451.y, _451.z);
        _252.z = dot(_212.xzw, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _162 = dot(_252, _252);
        _162 = max(_162, 0.001000000047497451305389404296875f);
        _162 = rsqrt(_162);
        float3 _471 = (_252 * _162.xxx) + _32;
        _212 = float4(_471.x, _212.y, _471.y, _471.z);
        _162 = dot(_212.xzw, _212.xzw);
        _162 = max(_162, 0.001000000047497451305389404296875f);
        _162 = rsqrt(_162);
        float3 _487 = _162.xxx * _212.xzw;
        _212 = float4(_487.x, _212.y, _487.y, _487.z);
        _162 = dot(_146, _212.xzw);
        _162 = clamp(_162, 0.0f, 1.0f);
        _496 = ((-_109.y) * _38_m12) + 1.0f;
        _504 = _496 * _496;
        _212.x = _504 * _504;
        _512 = (_162 * _212.x) + (-_162);
        _162 = (_512 * _162) + 1.0f;
        _212.x *= 0.3183098733425140380859375f;
        _162 = (_162 * _162) + 1.0000000116860974230803549289703e-07f;
        _162 = _212.x / _162;
        float3 _545 = (_252.xxx * vs_TEXCOORD5.xyz) + vs_TEXCOORD4.xyz;
        _212 = float4(_545.x, _212.y, _545.y, _545.z);
        float3 _555 = (_252.yyy * vs_TEXCOORD6.xyz) + _212.xzw;
        _212 = float4(_555.x, _212.y, _555.y, _555.z);
        float3 _564 = (_252.zzz * _235) + _212.xzw;
        _212 = float4(_564.x, _212.y, _564.y, _564.z);
        float3 _571 = _162.xxx * _212.xzw;
        _212 = float4(_571.x, _212.y, _571.y, _571.z);
        float3 _576 = max(_212.xzw, 0.0f.xxx);
        _212 = float4(_576.x, _212.y, _576.y, _576.z);
        float3 _587 = (_212.xzw * _38_m14.xxx) + _359;
        _212 = float4(_587.x, _212.y, _587.y, _587.z);
        _162 = dot(_146, _32);
        _162 = clamp(_162, 0.0f, 1.0f);
        _351 = ((-_496) * 0.07999999821186065673828125f) + 0.60000002384185791015625f;
        _235.x = _496 * _504;
        _351 = ((-_235.x) * _351) + 1.0f;
        _201 = (-_201) + 1.0f;
        _201 = (_109.y * _38_m12) + _201;
        _201 = clamp(_201, 0.0f, 1.0f);
        _235 = _212.xzw * _351.xxx;
        _351 = (-_162) + 1.0f;
        _351 *= _351;
        _351 *= _351;
        _359 = (-_129) + _201.xxx;
        _129 = (_351.xxx * _359) + _129;
        _129 *= _235;
        _146 = (_172 * _207) + _129;
        _129 = (_119 * _38_m13.xyz) + _146;
        _162 = _38_m28 + (-1.0f);
        _162 = (_45 * _162) + 1.0f;
        _146 = _162.xxx * _129;
        _98 = _146;
    }
    else
    {
        _98.x = 0.0f;
        _98.y = 0.0f;
        _98.z = 0.0f;
    }
    _90 = 0.001000000047497451305389404296875f < vs_TEXCOORD0.z;
    if (_90)
    {
        _129.x = dot(_72, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
        _129.x = sqrt(_129.x);
        _162 = _129.x + (-_38_m19);
        _705.x = (-_38_m19) + _38_m20;
        _705.x = max(_705.x, 0.001000000047497451305389404296875f);
        _162 /= _705.x;
        _162 = clamp(_162, 0.0f, 1.0f);
        _129.x = _162 * _162;
        float3 _733 = _9.xyz + (-_38_m1);
        _9 = float4(_733.x, _733.y, _733.z, _9.w);
        _9.x = dot(_9.xyz, _9.xyz);
        _9.x = sqrt(_9.x);
        _9.x = (-_9.x) + _38_m7;
        _754 = (-_38_m6) + _38_m7;
        _754 = max(_754, 0.001000000047497451305389404296875f);
        _9.x /= _754;
        _9.x = clamp(_9.x, 0.0f, 1.0f);
        _9.x = max(_9.x, _38_m8);
        _9.x += (-1.0f);
        _9.x = (_38_m5 * _9.x) + 1.0f;
        _754 = _38_m0.y * 2.5f;
        _754 = (vs_TEXCOORD2.w * 9.0f) + (-_754);
        _754 = sin(_754);
        _754 = (_754 * 0.5f) + 0.5f;
        _754 = ((-_38_m22) * _754) + 1.0f;
        _816 = (_162 * _162) + (-1.0f);
        _816 = (_38_m21 * _816) + 1.0f;
        _816 *= _38_m17;
        _754 *= _816;
        _754 = clamp(_754, 0.0f, 1.0f);
        _754 = _9.x * _754;
        _705 = _129.xxx * _38_m16.xyz;
        _848 = dot(vs_TEXCOORD4.xyz, float3(0.0396819151937961578369140625f, 0.4580217897891998291015625f, 0.0060965395532548427581787109375f));
        _162 = _848 + _38_m18;
        _705 = _162.xxx * _705;
        _162 = _38_m28 + (-1.0f);
        _162 = (_45 * _162) + 1.0f;
        _705 = _162.xxx * _705;
        _212.x = vs_TEXCOORD1.z;
        _212.y = vs_TEXCOORD2.z;
        _212.z = vs_TEXCOORD3.z;
        _162 = dot(_212.xyz, _212.xyz);
        _162 = rsqrt(_162);
        float3 _896 = _162.xxx * _212.xyz;
        _212 = float4(_896.x, _896.y, _896.z, _212.w);
        _32.x = dot(_212.xyz, _32);
        _32.x = clamp(_32.x, 0.0f, 1.0f);
        _32.x = (-_32.x) + 1.0f;
        _32.x = log2(_32.x);
        _32.x *= _38_m24;
        _32.x = exp2(_32.x);
        _928 = (-_45) + 1.0f;
        _32.x = _928 * _32.x;
        _32.x = _129.x * _32.x;
        _928 = _38_m0.y * _38_m26;
        _928 = sin(_928);
        _928 = (_928 * 0.5f) + 0.5f;
        _928 = ((-_38_m27) * _928) + 1.0f;
        _32.x *= _38_m25;
        _32.x = _928 * _32.x;
        _32.x = _9.x * _32.x;
        _32 = _32.xxx * _38_m23.xyz;
        _32 = (_705 * _754.xxx) + _32;
        _992 = _32;
        _994 = _754;
    }
    else
    {
        _992.x = 0.0f;
        _992.y = 0.0f;
        _992.z = 0.0f;
        _994 = 0.0f;
    }
    _705 = (-_98) + _992;
    _705 = (vs_TEXCOORD0.zzz * _705) + _98;
    _496 = _994 + (-1.0f);
    _9.w = (vs_TEXCOORD0.z * _496) + 1.0f;
    _129 = _9.www * _38_m3.xyz;
    _496 = vs_TEXCOORD7;
    _496 = clamp(_496, 0.0f, 1.0f);
    _705 = ((-_38_m3.xyz) * _9.www) + _705;
    float3 _1043 = (_496.xxx * _705) + _129;
    _9 = float4(_1043.x, _1043.y, _1043.z, _9.w);
    _1047 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1047 = _1047;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
float _GhostBelow;
float _NormalAbove;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _MainTex_ST;
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m6 _GhostBelow
#define _22_m7 _NormalAbove
#define _22_m8 _VolumeMin
#define _22_m9 _VolumeInvSize
#define _22_m10 _GlobalVolumeMin
#define _22_m11 _GlobalVolumeInvSize
#define _22_m12 _MainTex_ST


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float2 _253;
static float4 vs_TEXCOORD1;
static float3 _272;
static float4 _309;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _272 : NORMAL;
    float4 _309 : TANGENT;
    float2 _253 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float vs_TEXCOORD7 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _65;
static float _99;
static bool _148;
static float3 _156;
static float4 _171;
static float _212;
static float3 _308;
static float3 _344;

void vert_inner()
{
    __unity_init();
    float3 _29 = _11.yyy * _22_m1[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _41 = (_22_m1[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_41.x, _41.y, _41.z, _9.w);
    float3 _53 = (_22_m1[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _62 = _9.xyz + _22_m1[3].xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _9.yyyy * _22_m4[1];
    _65 = (_22_m4[0] * _9.xxxx) + _65;
    _65 = (_22_m4[2] * _9.zzzz) + _65;
    _65 += _22_m4[3];
    gl_Position = _65;
    _99 = _65.z / _22_m0.y;
    _99 = (-_99) + 1.0f;
    _99 *= _22_m0.z;
    _99 = max(_99, 0.0f);
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    _99 = _22_m6 + 0.001000000047497451305389404296875f;
    _99 = max(_99, _22_m7);
    _99 += (-_22_m6);
    _99 = 1.0f / _99;
    _148 = 1000000.0f < _22_m9.x;
    float3 _159;
    if (_148)
    {
        _159 = _22_m10;
    }
    else
    {
        _159 = _22_m8;
    }
    _156 = _159;
    float3 _173;
    if (_148)
    {
        _173 = _22_m11;
    }
    else
    {
        _173 = _22_m9;
    }
    _171 = float4(_173.x, _173.y, _173.z, _171.w);
    float3 _189 = _9.xyz + (-_156);
    _65 = float4(_189.x, _189.y, _189.z, _65.w);
    float3 _196 = _171.xyz * _65.xyz;
    _65 = float4(_196.x, _196.y, _196.z, _65.w);
    _171 = _Volume0.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    _212 = dot(_171.xyz, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    vs_TEXCOORD4 = _171;
    _212 = max(_212, 0.0f);
    _212 = sqrt(_212);
    _212 += (-_22_m6);
    _99 *= _212;
    _99 = clamp(_99, 0.0f, 1.0f);
    _212 = (_99 * (-2.0f)) + 3.0f;
    _99 *= _99;
    vs_TEXCOORD0.z = ((-_212) * _99) + 1.0f;
    float2 _263 = (_253 * _22_m12.xy) + _22_m12.zw;
    vs_TEXCOORD0 = float4(_263.x, _263.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0.w = 0.0f;
    vs_TEXCOORD1.w = _9.x;
    _171.y = dot(_272, _22_m2[0].xyz);
    _171.z = dot(_272, _22_m2[1].xyz);
    _171.x = dot(_272, _22_m2[2].xyz);
    _9.x = dot(_171.xyz, _171.xyz);
    _9.x = rsqrt(_9.x);
    float3 _305 = _9.xxx * _171.xyz;
    _171 = float4(_305.x, _305.y, _305.z, _171.w);
    _308 = _309.yyy * _22_m1[1].yzx;
    _308 = (_22_m1[0].yzx * _309.xxx) + _308;
    _308 = (_22_m1[2].yzx * _309.zzz) + _308;
    _9.x = dot(_308, _308);
    _9.x = rsqrt(_9.x);
    _308 = _9.xxx * _308;
    _344 = _171.xyz * _308;
    _344 = (_171.zxy * _308.yzx) + (-_344);
    _344 *= _309.www;
    _344 *= _22_m3.www;
    vs_TEXCOORD1.y = _344.x;
    vs_TEXCOORD1.x = _308.z;
    vs_TEXCOORD1.z = _171.y;
    vs_TEXCOORD2.x = _308.x;
    vs_TEXCOORD3.x = _308.y;
    vs_TEXCOORD2.z = _171.z;
    vs_TEXCOORD3.z = _171.x;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _344.y;
    vs_TEXCOORD3.y = _344.z;
    _9 = _Volume1.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    _65 = _Volume2.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    vs_TEXCOORD6 = _65;
    vs_TEXCOORD5 = _9;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _253 = stage_input._253;
    _272 = stage_input._272;
    _309 = stage_input._309;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_IndirectSpecColor;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float _FadeWithDistance;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
float4 _Color;
float _BumpScale;
float _Metallic;
float _Glossiness;
float4 _EmissionColor;
float _VolumeSpecular;
float _GlossyReflections;
float4 _GhostColor;
float _GhostOpacity;
float _GhostSelfLight;
float _BlackPoint;
float _WhitePoint;
float _DarkClear;
float _Waver;
float4 _RimColor;
float _RimPower;
float _RimStrength;
float _PulseSpeed;
float _PulseAmount;
float _InsideShade;
float _DoubleSided;
#define _38_m0 _Time
#define _38_m1 _WorldSpaceCameraPos
#define _38_m2 unity_IndirectSpecColor
#define _38_m3 unity_FogColor
#define _38_m4 unity_SpecCube0_HDR
#define _38_m5 _FadeWithDistance
#define _38_m6 _FadeNear
#define _38_m7 _FadeFar
#define _38_m8 _GhostSeeAll
#define _38_m9 _Color
#define _38_m10 _BumpScale
#define _38_m11 _Metallic
#define _38_m12 _Glossiness
#define _38_m13 _EmissionColor
#define _38_m14 _VolumeSpecular
#define _38_m15 _GlossyReflections
#define _38_m16 _GhostColor
#define _38_m17 _GhostOpacity
#define _38_m18 _GhostSelfLight
#define _38_m19 _BlackPoint
#define _38_m20 _WhitePoint
#define _38_m21 _DarkClear
#define _38_m22 _Waver
#define _38_m23 _RimColor
#define _38_m24 _RimPower
#define _38_m25 _RimStrength
#define _38_m26 _PulseSpeed
#define _38_m27 _PulseAmount
#define _38_m28 _InsideShade
#define _38_m29 _DoubleSided


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState sampler_unity_SpecCube0;

static bool gl_FrontFacing;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD5;
static float vs_TEXCOORD7;
static float4 _1047;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float vs_TEXCOORD7 : TEXCOORD7;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _1047 : SV_Target0;
};

static float4 _9;
static float3 _32;
static float _45;
static float3 _72;
static bool _90;
static float3 _98;
static float2 _109;
static float3 _119;
static float3 _129;
static float3 _146;
static float _162;
static float3 _172;
static float _201;
static float3 _207;
static float4 _212;
static float3 _235;
static float3 _252;
static float3 _271;
static float3 _298;
static float3 _302;
static float _351;
static float3 _359;
static float4 _380;
static float _496;
static float _504;
static float _512;
static float3 _705;
static float _754;
static float _816;
static float _848;
static float _928;
static float3 _992;
static float _994;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    _32 = (-_9.xyz) + _38_m1;
    _45 = dot(_32, _32);
    _45 = rsqrt(_45);
    _32 = _45.xxx * _32;
    _45 = (-_38_m29) + 1.0f;
    _45 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 0.0f : _45;
    _72 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _90 = vs_TEXCOORD0.z < 0.999000012874603271484375f;
    if (_90)
    {
        _98 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
        _109 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0.xy).xw;
        _119 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
        _129 = (_98 * 2.0f.xxx) + (-1.0f).xxx;
        float2 _143 = _129.xy * _38_m10.xx;
        _129 = float3(_143.x, _143.y, _129.z);
        _146.x = dot(vs_TEXCOORD1.xyz, _129);
        _146.y = dot(vs_TEXCOORD2.xyz, _129);
        _146.z = dot(vs_TEXCOORD3.xyz, _129);
        _162 = dot(_146, _146);
        _162 = rsqrt(_162);
        _146 = _162.xxx * _146;
        _172 = _72 * _38_m9.xyz;
        _162 = _109.x * _38_m11;
        _129 = (_72 * _38_m9.xyz) + (-0.039999999105930328369140625f).xxx;
        _129 = (_162.xxx * _129) + 0.039999999105930328369140625f.xxx;
        _201 = ((-_162) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
        _207 = _201.xxx * _172;
        float3 _218 = max(vs_TEXCOORD4.xyz, 9.9999997473787516355514526367188e-06f.xxx);
        _212 = float4(_218.x, _212.y, _218.y, _218.z);
        _172 = vs_TEXCOORD6.xyz * vs_TEXCOORD6.xyz;
        _172 = (vs_TEXCOORD5.xyz * vs_TEXCOORD5.xyz) + _172;
        _235.x = vs_TEXCOORD4.w;
        _235.y = vs_TEXCOORD5.w;
        _235.z = vs_TEXCOORD6.w;
        _172 = (_235 * _235) + _172;
        _172 = sqrt(_172);
        _252 = _146.yyy * vs_TEXCOORD6.xyz;
        _252 = (vs_TEXCOORD5.xyz * _146.xxx) + _252;
        _252 = (_235 * _146.zzz) + _252;
        _271 = max(_172, 9.9999999747524270787835121154785e-07f.xxx);
        _252 /= _271;
        _252 = (_252 * 0.5f.xxx) + 0.5f.xxx;
        _252 = clamp(_252, 0.0f.xxx, 1.0f.xxx);
        _172 *= 0.5f.xxx;
        _172 /= _212.xzw;
        _271 = (_172 * 2.0f.xxx) + 1.0f.xxx;
        _298 = (-_172) + 1.0f.xxx;
        _302 = _172 + 1.0f.xxx;
        _298 /= _302;
        _302 = (-_298) + 1.0f.xxx;
        _172 = (_172 * 2.0f.xxx) + 2.0f.xxx;
        _172 *= _302;
        _252 = log2(_252);
        _252 *= _271;
        _252 = exp2(_252);
        _172 = (_172 * _252) + _298;
        _172 = _212.xzw * _172;
        _172 = max(_172, 0.0f.xxx);
        _90 = 0.5f < _38_m15;
        if (_90)
        {
            _162 = ((-_109.y) * _38_m12) + 1.0f;
            _351 = dot(-_32, _146);
            _351 += _351;
            _359 = (_146 * (-_351.xxx)) + (-_32);
            _351 = ((-_162) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
            _351 = _162 * _351;
            _351 *= 6.0f;
            _380 = unity_SpecCube0.SampleLevel(sampler_unity_SpecCube0, _359, _351);
            _351 = _380.w + (-1.0f);
            _351 = (_38_m4.w * _351) + 1.0f;
            _351 = log2(_351);
            _351 *= _38_m4.y;
            _351 = exp2(_351);
            _351 *= _38_m4.x;
            _359 = _380.xyz * _351.xxx;
        }
        else
        {
            _359 = _38_m2.xyz;
        }
        float3 _425 = 1.0f.xxx / _212.xzw;
        _212 = float4(_425.x, _212.y, _425.y, _425.z);
        _252 = _212.xzw * vs_TEXCOORD5.xyz;
        _252.x = dot(_252, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _271 = _212.xzw * vs_TEXCOORD6.xyz;
        _252.y = dot(_271, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        float3 _451 = _212.xzw * _235;
        _212 = float4(_451.x, _212.y, _451.y, _451.z);
        _252.z = dot(_212.xzw, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _162 = dot(_252, _252);
        _162 = max(_162, 0.001000000047497451305389404296875f);
        _162 = rsqrt(_162);
        float3 _471 = (_252 * _162.xxx) + _32;
        _212 = float4(_471.x, _212.y, _471.y, _471.z);
        _162 = dot(_212.xzw, _212.xzw);
        _162 = max(_162, 0.001000000047497451305389404296875f);
        _162 = rsqrt(_162);
        float3 _487 = _162.xxx * _212.xzw;
        _212 = float4(_487.x, _212.y, _487.y, _487.z);
        _162 = dot(_146, _212.xzw);
        _162 = clamp(_162, 0.0f, 1.0f);
        _496 = ((-_109.y) * _38_m12) + 1.0f;
        _504 = _496 * _496;
        _212.x = _504 * _504;
        _512 = (_162 * _212.x) + (-_162);
        _162 = (_512 * _162) + 1.0f;
        _212.x *= 0.3183098733425140380859375f;
        _162 = (_162 * _162) + 1.0000000116860974230803549289703e-07f;
        _162 = _212.x / _162;
        float3 _545 = (_252.xxx * vs_TEXCOORD5.xyz) + vs_TEXCOORD4.xyz;
        _212 = float4(_545.x, _212.y, _545.y, _545.z);
        float3 _555 = (_252.yyy * vs_TEXCOORD6.xyz) + _212.xzw;
        _212 = float4(_555.x, _212.y, _555.y, _555.z);
        float3 _564 = (_252.zzz * _235) + _212.xzw;
        _212 = float4(_564.x, _212.y, _564.y, _564.z);
        float3 _571 = _162.xxx * _212.xzw;
        _212 = float4(_571.x, _212.y, _571.y, _571.z);
        float3 _576 = max(_212.xzw, 0.0f.xxx);
        _212 = float4(_576.x, _212.y, _576.y, _576.z);
        float3 _587 = (_212.xzw * _38_m14.xxx) + _359;
        _212 = float4(_587.x, _212.y, _587.y, _587.z);
        _162 = dot(_146, _32);
        _162 = clamp(_162, 0.0f, 1.0f);
        _351 = ((-_496) * 0.07999999821186065673828125f) + 0.60000002384185791015625f;
        _235.x = _496 * _504;
        _351 = ((-_235.x) * _351) + 1.0f;
        _201 = (-_201) + 1.0f;
        _201 = (_109.y * _38_m12) + _201;
        _201 = clamp(_201, 0.0f, 1.0f);
        _235 = _212.xzw * _351.xxx;
        _351 = (-_162) + 1.0f;
        _351 *= _351;
        _351 *= _351;
        _359 = (-_129) + _201.xxx;
        _129 = (_351.xxx * _359) + _129;
        _129 *= _235;
        _146 = (_172 * _207) + _129;
        _129 = (_119 * _38_m13.xyz) + _146;
        _162 = _38_m28 + (-1.0f);
        _162 = (_45 * _162) + 1.0f;
        _146 = _162.xxx * _129;
        _98 = _146;
    }
    else
    {
        _98.x = 0.0f;
        _98.y = 0.0f;
        _98.z = 0.0f;
    }
    _90 = 0.001000000047497451305389404296875f < vs_TEXCOORD0.z;
    if (_90)
    {
        _129.x = dot(_72, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
        _129.x = sqrt(_129.x);
        _162 = _129.x + (-_38_m19);
        _705.x = (-_38_m19) + _38_m20;
        _705.x = max(_705.x, 0.001000000047497451305389404296875f);
        _162 /= _705.x;
        _162 = clamp(_162, 0.0f, 1.0f);
        _129.x = _162 * _162;
        float3 _733 = _9.xyz + (-_38_m1);
        _9 = float4(_733.x, _733.y, _733.z, _9.w);
        _9.x = dot(_9.xyz, _9.xyz);
        _9.x = sqrt(_9.x);
        _9.x = (-_9.x) + _38_m7;
        _754 = (-_38_m6) + _38_m7;
        _754 = max(_754, 0.001000000047497451305389404296875f);
        _9.x /= _754;
        _9.x = clamp(_9.x, 0.0f, 1.0f);
        _9.x = max(_9.x, _38_m8);
        _9.x += (-1.0f);
        _9.x = (_38_m5 * _9.x) + 1.0f;
        _754 = _38_m0.y * 2.5f;
        _754 = (vs_TEXCOORD2.w * 9.0f) + (-_754);
        _754 = sin(_754);
        _754 = (_754 * 0.5f) + 0.5f;
        _754 = ((-_38_m22) * _754) + 1.0f;
        _816 = (_162 * _162) + (-1.0f);
        _816 = (_38_m21 * _816) + 1.0f;
        _816 *= _38_m17;
        _754 *= _816;
        _754 = clamp(_754, 0.0f, 1.0f);
        _754 = _9.x * _754;
        _705 = _129.xxx * _38_m16.xyz;
        _848 = dot(vs_TEXCOORD4.xyz, float3(0.0396819151937961578369140625f, 0.4580217897891998291015625f, 0.0060965395532548427581787109375f));
        _162 = _848 + _38_m18;
        _705 = _162.xxx * _705;
        _162 = _38_m28 + (-1.0f);
        _162 = (_45 * _162) + 1.0f;
        _705 = _162.xxx * _705;
        _212.x = vs_TEXCOORD1.z;
        _212.y = vs_TEXCOORD2.z;
        _212.z = vs_TEXCOORD3.z;
        _162 = dot(_212.xyz, _212.xyz);
        _162 = rsqrt(_162);
        float3 _896 = _162.xxx * _212.xyz;
        _212 = float4(_896.x, _896.y, _896.z, _212.w);
        _32.x = dot(_212.xyz, _32);
        _32.x = clamp(_32.x, 0.0f, 1.0f);
        _32.x = (-_32.x) + 1.0f;
        _32.x = log2(_32.x);
        _32.x *= _38_m24;
        _32.x = exp2(_32.x);
        _928 = (-_45) + 1.0f;
        _32.x = _928 * _32.x;
        _32.x = _129.x * _32.x;
        _928 = _38_m0.y * _38_m26;
        _928 = sin(_928);
        _928 = (_928 * 0.5f) + 0.5f;
        _928 = ((-_38_m27) * _928) + 1.0f;
        _32.x *= _38_m25;
        _32.x = _928 * _32.x;
        _32.x = _9.x * _32.x;
        _32 = _32.xxx * _38_m23.xyz;
        _32 = (_705 * _754.xxx) + _32;
        _992 = _32;
        _994 = _754;
    }
    else
    {
        _992.x = 0.0f;
        _992.y = 0.0f;
        _992.z = 0.0f;
        _994 = 0.0f;
    }
    _705 = (-_98) + _992;
    _705 = (vs_TEXCOORD0.zzz * _705) + _98;
    _496 = _994 + (-1.0f);
    _9.w = (vs_TEXCOORD0.z * _496) + 1.0f;
    _129 = _9.www * _38_m3.xyz;
    _496 = vs_TEXCOORD7;
    _496 = clamp(_496, 0.0f, 1.0f);
    _705 = ((-_38_m3.xyz) * _9.www) + _705;
    float3 _1043 = (_496.xxx * _705) + _129;
    _9 = float4(_1043.x, _1043.y, _1043.z, _9.w);
    _1047 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1047 = _1047;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float _GhostBelow;
float _NormalAbove;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _MainTex_ST;
void __unity_init()
{
    _22_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m2 unity_WorldTransformParams
#define _22_m4 _GhostBelow
#define _22_m5 _NormalAbove
#define _22_m6 _VolumeMin
#define _22_m7 _VolumeInvSize
#define _22_m8 _GlobalVolumeMin
#define _22_m9 _GlobalVolumeInvSize
#define _22_m10 _MainTex_ST


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float2 _227;
static float4 vs_TEXCOORD1;
static float3 _247;
static float4 _284;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _247 : NORMAL;
    float4 _284 : TANGENT;
    float2 _227 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _65;
static float _97;
static bool _119;
static float3 _127;
static float4 _142;
static float _184;
static float3 _283;
static float3 _319;

void vert_inner()
{
    __unity_init();
    float3 _30 = _11.yyy * _22_m0[1].xyz;
    _9 = float4(_30.x, _30.y, _30.z, _9.w);
    float3 _41 = (_22_m0[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_41.x, _41.y, _41.z, _9.w);
    float3 _53 = (_22_m0[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _62 = _9.xyz + _22_m0[3].xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _9.yyyy * _22_m3[1];
    _65 = (_22_m3[0] * _9.xxxx) + _65;
    _65 = (_22_m3[2] * _9.zzzz) + _65;
    gl_Position = _65 + _22_m3[3];
    _97 = _22_m4 + 0.001000000047497451305389404296875f;
    _97 = max(_97, _22_m5);
    _97 += (-_22_m4);
    _97 = 1.0f / _97;
    _119 = 1000000.0f < _22_m7.x;
    float3 _130;
    if (_119)
    {
        _130 = _22_m8;
    }
    else
    {
        _130 = _22_m6;
    }
    _127 = _130;
    float3 _144;
    if (_119)
    {
        _144 = _22_m9;
    }
    else
    {
        _144 = _22_m7;
    }
    _142 = float4(_144.x, _144.y, _144.z, _142.w);
    float3 _160 = _9.xyz + (-_127);
    _65 = float4(_160.x, _160.y, _160.z, _65.w);
    float3 _167 = _142.xyz * _65.xyz;
    _65 = float4(_167.x, _167.y, _167.z, _65.w);
    _142 = _Volume0.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    _184 = dot(_142.xyz, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    vs_TEXCOORD4 = _142;
    _184 = max(_184, 0.0f);
    _184 = sqrt(_184);
    _184 += (-_22_m4);
    _97 *= _184;
    _97 = clamp(_97, 0.0f, 1.0f);
    _184 = (_97 * (-2.0f)) + 3.0f;
    _97 *= _97;
    vs_TEXCOORD0.z = ((-_184) * _97) + 1.0f;
    float2 _237 = (_227 * _22_m10.xy) + _22_m10.zw;
    vs_TEXCOORD0 = float4(_237.x, _237.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0.w = 0.0f;
    vs_TEXCOORD1.w = _9.x;
    _142.y = dot(_247, _22_m1[0].xyz);
    _142.z = dot(_247, _22_m1[1].xyz);
    _142.x = dot(_247, _22_m1[2].xyz);
    _9.x = dot(_142.xyz, _142.xyz);
    _9.x = rsqrt(_9.x);
    float3 _280 = _9.xxx * _142.xyz;
    _142 = float4(_280.x, _280.y, _280.z, _142.w);
    _283 = _284.yyy * _22_m0[1].yzx;
    _283 = (_22_m0[0].yzx * _284.xxx) + _283;
    _283 = (_22_m0[2].yzx * _284.zzz) + _283;
    _9.x = dot(_283, _283);
    _9.x = rsqrt(_9.x);
    _283 = _9.xxx * _283;
    _319 = _142.xyz * _283;
    _319 = (_142.zxy * _283.yzx) + (-_319);
    _319 *= _284.www;
    _319 *= _22_m2.www;
    vs_TEXCOORD1.y = _319.x;
    vs_TEXCOORD1.x = _283.z;
    vs_TEXCOORD1.z = _142.y;
    vs_TEXCOORD2.x = _283.x;
    vs_TEXCOORD3.x = _283.y;
    vs_TEXCOORD2.z = _142.z;
    vs_TEXCOORD3.z = _142.x;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _319.y;
    vs_TEXCOORD3.y = _319.z;
    _9 = _Volume1.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    _65 = _Volume2.SampleLevel(sampler_Volume0, _65.xyz, 0.0f);
    vs_TEXCOORD6 = _65;
    vs_TEXCOORD5 = _9;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _227 = stage_input._227;
    _247 = stage_input._247;
    _284 = stage_input._284;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_IndirectSpecColor;
float4 unity_SpecCube0_HDR;
float _FadeWithDistance;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
float4 _Color;
float _BumpScale;
float _Metallic;
float _Glossiness;
float4 _EmissionColor;
float _VolumeSpecular;
float _GlossyReflections;
float4 _GhostColor;
float _GhostOpacity;
float _GhostSelfLight;
float _BlackPoint;
float _WhitePoint;
float _DarkClear;
float _Waver;
float4 _RimColor;
float _RimPower;
float _RimStrength;
float _PulseSpeed;
float _PulseAmount;
float _InsideShade;
float _DoubleSided;
#define _37_m0 _Time
#define _37_m1 _WorldSpaceCameraPos
#define _37_m2 unity_IndirectSpecColor
#define _37_m3 unity_SpecCube0_HDR
#define _37_m4 _FadeWithDistance
#define _37_m5 _FadeNear
#define _37_m6 _FadeFar
#define _37_m7 _GhostSeeAll
#define _37_m8 _Color
#define _37_m9 _BumpScale
#define _37_m10 _Metallic
#define _37_m11 _Glossiness
#define _37_m12 _EmissionColor
#define _37_m13 _VolumeSpecular
#define _37_m14 _GlossyReflections
#define _37_m15 _GhostColor
#define _37_m16 _GhostOpacity
#define _37_m17 _GhostSelfLight
#define _37_m18 _BlackPoint
#define _37_m19 _WhitePoint
#define _37_m20 _DarkClear
#define _37_m21 _Waver
#define _37_m22 _RimColor
#define _37_m23 _RimPower
#define _37_m24 _RimStrength
#define _37_m25 _PulseSpeed
#define _37_m26 _PulseAmount
#define _37_m27 _InsideShade
#define _37_m28 _DoubleSided


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState sampler_unity_SpecCube0;

static bool gl_FrontFacing;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD5;
static float4 _1035;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _1035 : SV_Target0;
};

static float3 _9;
static float4 _32;
static float _46;
static float3 _78;
static bool _96;
static float3 _104;
static float2 _115;
static float3 _125;
static float3 _135;
static float3 _152;
static float _168;
static float3 _178;
static float _207;
static float3 _213;
static float4 _218;
static float3 _241;
static float3 _258;
static float3 _277;
static float3 _304;
static float3 _308;
static float _357;
static float3 _366;
static float4 _388;
static float _505;
static float _513;
static float _521;
static float3 _715;
static float _759;
static float _821;
static float _853;
static float _934;
static float3 _1003;
static float _1006;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _43 = (-_9) + _37_m1;
    _32 = float4(_43.x, _43.y, _43.z, _32.w);
    _46 = dot(_32.xyz, _32.xyz);
    _46 = rsqrt(_46);
    float3 _58 = _46.xxx * _32.xyz;
    _32 = float4(_58.x, _58.y, _58.z, _32.w);
    _46 = (-_37_m28) + 1.0f;
    _46 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 0.0f : _46;
    _78 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _96 = vs_TEXCOORD0.z < 0.999000012874603271484375f;
    if (_96)
    {
        _104 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
        _115 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0.xy).xw;
        _125 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0.xy).xyz;
        _135 = (_104 * 2.0f.xxx) + (-1.0f).xxx;
        float2 _149 = _135.xy * _37_m9.xx;
        _135 = float3(_149.x, _149.y, _135.z);
        _152.x = dot(vs_TEXCOORD1.xyz, _135);
        _152.y = dot(vs_TEXCOORD2.xyz, _135);
        _152.z = dot(vs_TEXCOORD3.xyz, _135);
        _168 = dot(_152, _152);
        _168 = rsqrt(_168);
        _152 = _168.xxx * _152;
        _178 = _78 * _37_m8.xyz;
        _168 = _115.x * _37_m10;
        _135 = (_78 * _37_m8.xyz) + (-0.039999999105930328369140625f).xxx;
        _135 = (_168.xxx * _135) + 0.039999999105930328369140625f.xxx;
        _207 = ((-_168) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
        _213 = _207.xxx * _178;
        float3 _224 = max(vs_TEXCOORD4.xyz, 9.9999997473787516355514526367188e-06f.xxx);
        _218 = float4(_224.x, _218.y, _224.y, _224.z);
        _178 = vs_TEXCOORD6.xyz * vs_TEXCOORD6.xyz;
        _178 = (vs_TEXCOORD5.xyz * vs_TEXCOORD5.xyz) + _178;
        _241.x = vs_TEXCOORD4.w;
        _241.y = vs_TEXCOORD5.w;
        _241.z = vs_TEXCOORD6.w;
        _178 = (_241 * _241) + _178;
        _178 = sqrt(_178);
        _258 = _152.yyy * vs_TEXCOORD6.xyz;
        _258 = (vs_TEXCOORD5.xyz * _152.xxx) + _258;
        _258 = (_241 * _152.zzz) + _258;
        _277 = max(_178, 9.9999999747524270787835121154785e-07f.xxx);
        _258 /= _277;
        _258 = (_258 * 0.5f.xxx) + 0.5f.xxx;
        _258 = clamp(_258, 0.0f.xxx, 1.0f.xxx);
        _178 *= 0.5f.xxx;
        _178 /= _218.xzw;
        _277 = (_178 * 2.0f.xxx) + 1.0f.xxx;
        _304 = (-_178) + 1.0f.xxx;
        _308 = _178 + 1.0f.xxx;
        _304 /= _308;
        _308 = (-_304) + 1.0f.xxx;
        _178 = (_178 * 2.0f.xxx) + 2.0f.xxx;
        _178 *= _308;
        _258 = log2(_258);
        _258 *= _277;
        _258 = exp2(_258);
        _178 = (_178 * _258) + _304;
        _178 = _218.xzw * _178;
        _178 = max(_178, 0.0f.xxx);
        _96 = 0.5f < _37_m14;
        if (_96)
        {
            _168 = ((-_115.y) * _37_m11) + 1.0f;
            _357 = dot(-_32.xyz, _152);
            _357 += _357;
            _366 = (_152 * (-_357.xxx)) + (-_32.xyz);
            _357 = ((-_168) * 0.699999988079071044921875f) + 1.7000000476837158203125f;
            _357 = _168 * _357;
            _357 *= 6.0f;
            _388 = unity_SpecCube0.SampleLevel(sampler_unity_SpecCube0, _366, _357);
            _357 = _388.w + (-1.0f);
            _357 = (_37_m3.w * _357) + 1.0f;
            _357 = log2(_357);
            _357 *= _37_m3.y;
            _357 = exp2(_357);
            _357 *= _37_m3.x;
            _366 = _388.xyz * _357.xxx;
        }
        else
        {
            _366 = _37_m2.xyz;
        }
        float3 _433 = 1.0f.xxx / _218.xzw;
        _218 = float4(_433.x, _218.y, _433.y, _433.z);
        _258 = _218.xzw * vs_TEXCOORD5.xyz;
        _258.x = dot(_258, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _277 = _218.xzw * vs_TEXCOORD6.xyz;
        _258.y = dot(_277, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        float3 _459 = _218.xzw * _241;
        _218 = float4(_459.x, _218.y, _459.y, _459.z);
        _258.z = dot(_218.xzw, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _168 = dot(_258, _258);
        _168 = max(_168, 0.001000000047497451305389404296875f);
        _168 = rsqrt(_168);
        float3 _480 = (_258 * _168.xxx) + _32.xyz;
        _218 = float4(_480.x, _218.y, _480.y, _480.z);
        _168 = dot(_218.xzw, _218.xzw);
        _168 = max(_168, 0.001000000047497451305389404296875f);
        _168 = rsqrt(_168);
        float3 _496 = _168.xxx * _218.xzw;
        _218 = float4(_496.x, _218.y, _496.y, _496.z);
        _168 = dot(_152, _218.xzw);
        _168 = clamp(_168, 0.0f, 1.0f);
        _505 = ((-_115.y) * _37_m11) + 1.0f;
        _513 = _505 * _505;
        _218.x = _513 * _513;
        _521 = (_168 * _218.x) + (-_168);
        _168 = (_521 * _168) + 1.0f;
        _218.x *= 0.3183098733425140380859375f;
        _168 = (_168 * _168) + 1.0000000116860974230803549289703e-07f;
        _168 = _218.x / _168;
        float3 _554 = (_258.xxx * vs_TEXCOORD5.xyz) + vs_TEXCOORD4.xyz;
        _218 = float4(_554.x, _218.y, _554.y, _554.z);
        float3 _564 = (_258.yyy * vs_TEXCOORD6.xyz) + _218.xzw;
        _218 = float4(_564.x, _218.y, _564.y, _564.z);
        float3 _573 = (_258.zzz * _241) + _218.xzw;
        _218 = float4(_573.x, _218.y, _573.y, _573.z);
        float3 _580 = _168.xxx * _218.xzw;
        _218 = float4(_580.x, _218.y, _580.y, _580.z);
        float3 _585 = max(_218.xzw, 0.0f.xxx);
        _218 = float4(_585.x, _218.y, _585.y, _585.z);
        float3 _596 = (_218.xzw * _37_m13.xxx) + _366;
        _218 = float4(_596.x, _218.y, _596.y, _596.z);
        _168 = dot(_152, _32.xyz);
        _168 = clamp(_168, 0.0f, 1.0f);
        _357 = ((-_505) * 0.07999999821186065673828125f) + 0.60000002384185791015625f;
        _241.x = _505 * _513;
        _357 = ((-_241.x) * _357) + 1.0f;
        _207 = (-_207) + 1.0f;
        _207 = (_115.y * _37_m11) + _207;
        _207 = clamp(_207, 0.0f, 1.0f);
        _241 = _218.xzw * _357.xxx;
        _357 = (-_168) + 1.0f;
        _357 *= _357;
        _357 *= _357;
        _366 = (-_135) + _207.xxx;
        _135 = (_357.xxx * _366) + _135;
        _135 *= _241;
        _152 = (_178 * _213) + _135;
        _135 = (_125 * _37_m12.xyz) + _152;
        _168 = _37_m27 + (-1.0f);
        _168 = (_46 * _168) + 1.0f;
        _152 = _168.xxx * _135;
        _104 = _152;
    }
    else
    {
        _104.x = 0.0f;
        _104.y = 0.0f;
        _104.z = 0.0f;
    }
    _96 = 0.001000000047497451305389404296875f < vs_TEXCOORD0.z;
    if (_96)
    {
        _135.x = dot(_78, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
        _135.x = sqrt(_135.x);
        _168 = _135.x + (-_37_m18);
        _715.x = (-_37_m18) + _37_m19;
        _715.x = max(_715.x, 0.001000000047497451305389404296875f);
        _168 /= _715.x;
        _168 = clamp(_168, 0.0f, 1.0f);
        _135.x = _168 * _168;
        _9 += (-_37_m1);
        _9.x = dot(_9, _9);
        _9.x = sqrt(_9.x);
        _9.x = (-_9.x) + _37_m6;
        _759 = (-_37_m5) + _37_m6;
        _759 = max(_759, 0.001000000047497451305389404296875f);
        _9.x /= _759;
        _9.x = clamp(_9.x, 0.0f, 1.0f);
        _9.x = max(_9.x, _37_m7);
        _9.x += (-1.0f);
        _9.x = (_37_m4 * _9.x) + 1.0f;
        _759 = _37_m0.y * 2.5f;
        _759 = (vs_TEXCOORD2.w * 9.0f) + (-_759);
        _759 = sin(_759);
        _759 = (_759 * 0.5f) + 0.5f;
        _759 = ((-_37_m21) * _759) + 1.0f;
        _821 = (_168 * _168) + (-1.0f);
        _821 = (_37_m20 * _821) + 1.0f;
        _821 *= _37_m16;
        _759 *= _821;
        _759 = clamp(_759, 0.0f, 1.0f);
        _759 = _9.x * _759;
        _715 = _135.xxx * _37_m15.xyz;
        _853 = dot(vs_TEXCOORD4.xyz, float3(0.0396819151937961578369140625f, 0.4580217897891998291015625f, 0.0060965395532548427581787109375f));
        _168 = _853 + _37_m17;
        _715 = _168.xxx * _715;
        _168 = _37_m27 + (-1.0f);
        _168 = (_46 * _168) + 1.0f;
        _715 = _168.xxx * _715;
        _218.x = vs_TEXCOORD1.z;
        _218.y = vs_TEXCOORD2.z;
        _218.z = vs_TEXCOORD3.z;
        _168 = dot(_218.xyz, _218.xyz);
        _168 = rsqrt(_168);
        float3 _901 = _168.xxx * _218.xyz;
        _218 = float4(_901.x, _901.y, _901.z, _218.w);
        _32.x = dot(_218.xyz, _32.xyz);
        _32.x = clamp(_32.x, 0.0f, 1.0f);
        _32.x = (-_32.x) + 1.0f;
        _32.x = log2(_32.x);
        _32.x *= _37_m23;
        _32.x = exp2(_32.x);
        _934 = (-_46) + 1.0f;
        _32.x = _934 * _32.x;
        _32.x = _135.x * _32.x;
        _934 = _37_m0.y * _37_m25;
        _934 = sin(_934);
        _934 = (_934 * 0.5f) + 0.5f;
        _934 = ((-_37_m26) * _934) + 1.0f;
        _32.x *= _37_m24;
        _32.x = _934 * _32.x;
        _32.x = _9.x * _32.x;
        float3 _991 = _32.xxx * _37_m22.xyz;
        _32 = float4(_991.x, _991.y, _991.z, _32.w);
        float3 _1000 = (_715 * _759.xxx) + _32.xyz;
        _32 = float4(_1000.x, _1000.y, _1000.z, _32.w);
        _1003 = _32.xyz;
        _1006 = _759;
    }
    else
    {
        _1003.x = 0.0f;
        _1003.y = 0.0f;
        _1003.z = 0.0f;
        _1006 = 0.0f;
    }
    _715 = (-_104) + _1003;
    float3 _1021 = (vs_TEXCOORD0.zzz * _715) + _104;
    _32 = float4(_1021.x, _1021.y, _1021.z, _32.w);
    _715.x = _1006 + (-1.0f);
    _32.w = (vs_TEXCOORD0.z * _715.x) + 1.0f;
    _1035 = _32;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1035 = _1035;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}