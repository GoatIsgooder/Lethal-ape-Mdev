// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Fnaf/MonsterGlow" {
Properties {

_Color ("Color", Color) = (1,1,1,1)

_MainTex ("Albedo", 2D) = "white" { }

_BumpMap ("Normal Map", 2D) = "bump" { }

_BumpScale ("Normal Scale", Float) = 1.0

_MetallicGlossMap ("Metallic (R) Smoothness (A)", 2D) = "black" { }

_GlossMapScale ("Smoothness Scale", Range(0, 1)) = 1.0

_OcclusionMap ("Occlusion", 2D) = "white" { }

_OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 1.0

[Header(Glow)] _GlowColor ("Glow Color (driven at runtime)", Color) = (0,0,0,1)

_GlowBase ("Flat Glow Share", Range(0, 1)) = 0.0

_GlowRim ("Rim Glow Share", Range(0, 2)) = 0.6000000238418579

_RimPower ("Rim Power", Range(0.5, 8)) = 3.0

_GlowAlbedo ("Tint Glow By Albedo", Range(0, 1)) = 0.0

}
SubShader {
 LOD 200
 Tags { "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
 Name "FORWARD"
  LOD 200
  Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile __ DIRECTIONAL
#pragma multi_compile __ LIGHTPROBE_SH
#pragma multi_compile __ SHADOWS_SCREEN
#pragma multi_compile __ VERTEXLIGHT_ON
#if defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _134;
static float4 _146;
static float4 vs_TEXCOORD1;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _146 : TANGENT;
    float3 _205 : NORMAL;
    float4 _134 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _225;
static float4 _238;
static float4 _317;
static float3 _414;
static float4 _431;
static float3 _436;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m14.y;
    vs_TEXCOORD5 = exp2(-_102);
    vs_TEXCOORD0 = (_134.xy * _23_m15.xy) + _23_m15.zw;
    float3 _152 = _146.yyy * _23_m10[1].yzx;
    _47 = float4(_152.x, _152.y, _152.z, _47.w);
    float3 _163 = (_23_m10[0].yzx * _146.xxx) + _47.xyz;
    _47 = float4(_163.x, _163.y, _163.z, _47.w);
    float3 _174 = (_23_m10[2].yzx * _146.zzz) + _47.xyz;
    _47 = float4(_174.x, _174.y, _174.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _188 = _102.xxx * _47.xyz;
    _47 = float4(_188.x, _188.y, _188.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _146.w * _23_m12.w;
    _65.x = dot(_205, _23_m11[0].xyz);
    _65.y = dot(_205, _23_m11[1].xyz);
    _65.z = dot(_205, _23_m11[2].xyz);
    _225 = dot(_65.xyz, _65.xyz);
    _225 = rsqrt(_225);
    _65 = _225.xxxx * _65.xyzz;
    float3 _243 = _47.xyz * _65.wxy;
    _238 = float4(_243.x, _243.y, _243.z, _238.w);
    float3 _254 = (_65.ywx * _47.yzx) + (-_238.xyz);
    _238 = float4(_254.x, _254.y, _254.z, _238.w);
    float3 _261 = _102.xxx * _238.xyz;
    _238 = float4(_261.x, _261.y, _261.z, _238.w);
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _238 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _317 = _65.yyyy * _238;
    _238 *= _238;
    _238 = (_47 * _47) + _238;
    _47 = (_47 * _65.xxxx) + _317;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _238;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _238 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _238;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _377 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_377.x, _377.y, _377.z, _47.w);
    float3 _388 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_388.x, _388.y, _388.z, _47.w);
    float3 _399 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_399.x, _399.y, _399.z, _9.w);
    float3 _410 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_410.x, _410.y, _410.z, _9.w);
    _414.x = _65.y * _65.y;
    _414.x = (_65.x * _65.x) + (-_414.x);
    _431 = _65.ywzx * _65;
    _436.x = dot(_23_m6, _431);
    _436.y = dot(_23_m7, _431);
    _436.z = dot(_23_m8, _431);
    _414 = (_23_m9.xyz * _414.xxx) + _436;
    vs_TEXCOORD4 = _9.xyz + _414;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _134 = stage_input._134;
    _146 = stage_input._146;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _138;
static float4 _150;
static float4 vs_TEXCOORD1;
static float3 _208;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _208 : NORMAL;
    float4 _138 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _228;
static float4 _241;
static float4 _320;
static float3 _417;
static float4 _434;
static float3 _439;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m14.x;
    _102 *= (-_102);
    vs_TEXCOORD5 = exp2(_102);
    vs_TEXCOORD0 = (_138.xy * _23_m15.xy) + _23_m15.zw;
    float3 _156 = _150.yyy * _23_m10[1].yzx;
    _47 = float4(_156.x, _156.y, _156.z, _47.w);
    float3 _167 = (_23_m10[0].yzx * _150.xxx) + _47.xyz;
    _47 = float4(_167.x, _167.y, _167.z, _47.w);
    float3 _178 = (_23_m10[2].yzx * _150.zzz) + _47.xyz;
    _47 = float4(_178.x, _178.y, _178.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _192 = _102.xxx * _47.xyz;
    _47 = float4(_192.x, _192.y, _192.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _150.w * _23_m12.w;
    _65.x = dot(_208, _23_m11[0].xyz);
    _65.y = dot(_208, _23_m11[1].xyz);
    _65.z = dot(_208, _23_m11[2].xyz);
    _228 = dot(_65.xyz, _65.xyz);
    _228 = rsqrt(_228);
    _65 = _228.xxxx * _65.xyzz;
    float3 _246 = _47.xyz * _65.wxy;
    _241 = float4(_246.x, _246.y, _246.z, _241.w);
    float3 _257 = (_65.ywx * _47.yzx) + (-_241.xyz);
    _241 = float4(_257.x, _257.y, _257.z, _241.w);
    float3 _264 = _102.xxx * _241.xyz;
    _241 = float4(_264.x, _264.y, _264.z, _241.w);
    vs_TEXCOORD1.y = _241.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _241.y;
    vs_TEXCOORD3.y = _241.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _241 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _320 = _65.yyyy * _241;
    _241 *= _241;
    _241 = (_47 * _47) + _241;
    _47 = (_47 * _65.xxxx) + _320;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _241;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _241 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _241;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _380 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_380.x, _380.y, _380.z, _47.w);
    float3 _391 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_391.x, _391.y, _391.z, _47.w);
    float3 _402 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_402.x, _402.y, _402.z, _9.w);
    float3 _413 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_413.x, _413.y, _413.z, _9.w);
    _417.x = _65.y * _65.y;
    _417.x = (_65.x * _65.x) + (-_417.x);
    _434 = _65.ywzx * _65;
    _439.x = dot(_23_m6, _434);
    _439.y = dot(_23_m7, _434);
    _439.z = dot(_23_m8, _434);
    _417 = (_23_m9.xyz * _417.xxx) + _439;
    vs_TEXCOORD4 = _9.xyz + _417;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _150 = stage_input._150;
    _208 = stage_input._208;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _135;
static float4 _147;
static float4 vs_TEXCOORD1;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _147 : TANGENT;
    float3 _205 : NORMAL;
    float4 _135 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _225;
static float4 _238;
static float4 _317;
static float3 _414;
static float4 _431;
static float3 _436;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    vs_TEXCOORD5 = (_102 * _23_m14.z) + _23_m14.w;
    vs_TEXCOORD0 = (_135.xy * _23_m15.xy) + _23_m15.zw;
    float3 _153 = _147.yyy * _23_m10[1].yzx;
    _47 = float4(_153.x, _153.y, _153.z, _47.w);
    float3 _164 = (_23_m10[0].yzx * _147.xxx) + _47.xyz;
    _47 = float4(_164.x, _164.y, _164.z, _47.w);
    float3 _175 = (_23_m10[2].yzx * _147.zzz) + _47.xyz;
    _47 = float4(_175.x, _175.y, _175.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _189 = _102.xxx * _47.xyz;
    _47 = float4(_189.x, _189.y, _189.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _147.w * _23_m12.w;
    _65.x = dot(_205, _23_m11[0].xyz);
    _65.y = dot(_205, _23_m11[1].xyz);
    _65.z = dot(_205, _23_m11[2].xyz);
    _225 = dot(_65.xyz, _65.xyz);
    _225 = rsqrt(_225);
    _65 = _225.xxxx * _65.xyzz;
    float3 _243 = _47.xyz * _65.wxy;
    _238 = float4(_243.x, _243.y, _243.z, _238.w);
    float3 _254 = (_65.ywx * _47.yzx) + (-_238.xyz);
    _238 = float4(_254.x, _254.y, _254.z, _238.w);
    float3 _261 = _102.xxx * _238.xyz;
    _238 = float4(_261.x, _261.y, _261.z, _238.w);
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _238 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _317 = _65.yyyy * _238;
    _238 *= _238;
    _238 = (_47 * _47) + _238;
    _47 = (_47 * _65.xxxx) + _317;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _238;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _238 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _238;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _377 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_377.x, _377.y, _377.z, _47.w);
    float3 _388 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_388.x, _388.y, _388.z, _47.w);
    float3 _399 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_399.x, _399.y, _399.z, _9.w);
    float3 _410 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_410.x, _410.y, _410.z, _9.w);
    _414.x = _65.y * _65.y;
    _414.x = (_65.x * _65.x) + (-_414.x);
    _431 = _65.ywzx * _65;
    _436.x = dot(_23_m6, _431);
    _436.y = dot(_23_m7, _431);
    _436.z = dot(_23_m8, _431);
    _414 = (_23_m9.xyz * _414.xxx) + _436;
    vs_TEXCOORD4 = _9.xyz + _414;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _135 = stage_input._135;
    _147 = stage_input._147;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _132;
static float4 vs_TEXCOORD1;
static float4 _150;
static float3 _202;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _202 : NORMAL;
    float4 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _238;
static float _296;
static float4 _310;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    _100 *= _21_m9.y;
    vs_TEXCOORD5 = exp2(-_100);
    vs_TEXCOORD0 = (_132.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _156 = _150.yyy * _21_m5[1].yzx;
    _45 = float4(_156.x, _156.y, _156.z, _45.w);
    float3 _167 = (_21_m5[0].yzx * _150.xxx) + _45.xyz;
    _45 = float4(_167.x, _167.y, _167.z, _45.w);
    float3 _178 = (_21_m5[2].yzx * _150.zzz) + _45.xyz;
    _45 = float4(_178.x, _178.y, _178.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _195 = _9.xxx * _45.xyz;
    _45 = float4(_195.x, _195.y, _195.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_202, _21_m6[0].xyz);
    _63.y = dot(_202, _21_m6[1].xyz);
    _63.z = dot(_202, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _238 = _45.xyz * _63.wxy;
    _238 = (_63.ywx * _45.yzx) + (-_238);
    _9.x = _150.w * _21_m7.w;
    _238 = _9.xxx * _238;
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _296 = _63.y * _63.y;
    _296 = (_63.x * _63.x) + (-_296);
    _310 = _63.ywzx * _63;
    _315.x = dot(_21_m1, _310);
    _315.y = dot(_21_m2, _310);
    _315.z = dot(_21_m3, _310);
    vs_TEXCOORD4 = (_21_m4.xyz * _296.xxx) + _315;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _150 = stage_input._150;
    _202 = stage_input._202;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _134;
static float4 _146;
static float4 vs_TEXCOORD1;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _146 : TANGENT;
    float3 _205 : NORMAL;
    float4 _134 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _225;
static float4 _238;
static float4 _317;
static float3 _414;
static float4 _431;
static float3 _436;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m14.y;
    vs_TEXCOORD5 = exp2(-_102);
    vs_TEXCOORD0 = (_134.xy * _23_m15.xy) + _23_m15.zw;
    float3 _152 = _146.yyy * _23_m10[1].yzx;
    _47 = float4(_152.x, _152.y, _152.z, _47.w);
    float3 _163 = (_23_m10[0].yzx * _146.xxx) + _47.xyz;
    _47 = float4(_163.x, _163.y, _163.z, _47.w);
    float3 _174 = (_23_m10[2].yzx * _146.zzz) + _47.xyz;
    _47 = float4(_174.x, _174.y, _174.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _188 = _102.xxx * _47.xyz;
    _47 = float4(_188.x, _188.y, _188.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _146.w * _23_m12.w;
    _65.x = dot(_205, _23_m11[0].xyz);
    _65.y = dot(_205, _23_m11[1].xyz);
    _65.z = dot(_205, _23_m11[2].xyz);
    _225 = dot(_65.xyz, _65.xyz);
    _225 = rsqrt(_225);
    _65 = _225.xxxx * _65.xyzz;
    float3 _243 = _47.xyz * _65.wxy;
    _238 = float4(_243.x, _243.y, _243.z, _238.w);
    float3 _254 = (_65.ywx * _47.yzx) + (-_238.xyz);
    _238 = float4(_254.x, _254.y, _254.z, _238.w);
    float3 _261 = _102.xxx * _238.xyz;
    _238 = float4(_261.x, _261.y, _261.z, _238.w);
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _238 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _317 = _65.yyyy * _238;
    _238 *= _238;
    _238 = (_47 * _47) + _238;
    _47 = (_47 * _65.xxxx) + _317;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _238;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _238 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _238;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _377 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_377.x, _377.y, _377.z, _47.w);
    float3 _388 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_388.x, _388.y, _388.z, _47.w);
    float3 _399 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_399.x, _399.y, _399.z, _9.w);
    float3 _410 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_410.x, _410.y, _410.z, _9.w);
    _414.x = _65.y * _65.y;
    _414.x = (_65.x * _65.x) + (-_414.x);
    _431 = _65.ywzx * _65;
    _436.x = dot(_23_m6, _431);
    _436.y = dot(_23_m7, _431);
    _436.z = dot(_23_m8, _431);
    _414 = (_23_m9.xyz * _414.xxx) + _436;
    vs_TEXCOORD4 = _9.xyz + _414;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _134 = stage_input._134;
    _146 = stage_input._146;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _134;
static float4 _146;
static float4 vs_TEXCOORD1;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _146 : TANGENT;
    float3 _205 : NORMAL;
    float4 _134 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _225;
static float4 _238;
static float4 _317;
static float3 _414;
static float4 _431;
static float3 _436;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m14.y;
    vs_TEXCOORD5 = exp2(-_102);
    vs_TEXCOORD0 = (_134.xy * _23_m15.xy) + _23_m15.zw;
    float3 _152 = _146.yyy * _23_m10[1].yzx;
    _47 = float4(_152.x, _152.y, _152.z, _47.w);
    float3 _163 = (_23_m10[0].yzx * _146.xxx) + _47.xyz;
    _47 = float4(_163.x, _163.y, _163.z, _47.w);
    float3 _174 = (_23_m10[2].yzx * _146.zzz) + _47.xyz;
    _47 = float4(_174.x, _174.y, _174.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _188 = _102.xxx * _47.xyz;
    _47 = float4(_188.x, _188.y, _188.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _146.w * _23_m12.w;
    _65.x = dot(_205, _23_m11[0].xyz);
    _65.y = dot(_205, _23_m11[1].xyz);
    _65.z = dot(_205, _23_m11[2].xyz);
    _225 = dot(_65.xyz, _65.xyz);
    _225 = rsqrt(_225);
    _65 = _225.xxxx * _65.xyzz;
    float3 _243 = _47.xyz * _65.wxy;
    _238 = float4(_243.x, _243.y, _243.z, _238.w);
    float3 _254 = (_65.ywx * _47.yzx) + (-_238.xyz);
    _238 = float4(_254.x, _254.y, _254.z, _238.w);
    float3 _261 = _102.xxx * _238.xyz;
    _238 = float4(_261.x, _261.y, _261.z, _238.w);
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _238 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _317 = _65.yyyy * _238;
    _238 *= _238;
    _238 = (_47 * _47) + _238;
    _47 = (_47 * _65.xxxx) + _317;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _238;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _238 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _238;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _377 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_377.x, _377.y, _377.z, _47.w);
    float3 _388 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_388.x, _388.y, _388.z, _47.w);
    float3 _399 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_399.x, _399.y, _399.z, _9.w);
    float3 _410 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_410.x, _410.y, _410.z, _9.w);
    _414.x = _65.y * _65.y;
    _414.x = (_65.x * _65.x) + (-_414.x);
    _431 = _65.ywzx * _65;
    _436.x = dot(_23_m6, _431);
    _436.y = dot(_23_m7, _431);
    _436.z = dot(_23_m8, _431);
    _414 = (_23_m9.xyz * _414.xxx) + _436;
    vs_TEXCOORD4 = _9.xyz + _414;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _134 = stage_input._134;
    _146 = stage_input._146;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _136;
static float4 vs_TEXCOORD1;
static float4 _153;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _153 : TANGENT;
    float3 _205 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _241;
static float _299;
static float4 _313;
static float3 _318;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    _100 *= _21_m9.x;
    _100 *= (-_100);
    vs_TEXCOORD5 = exp2(_100);
    vs_TEXCOORD0 = (_136.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _159 = _153.yyy * _21_m5[1].yzx;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    float3 _170 = (_21_m5[0].yzx * _153.xxx) + _45.xyz;
    _45 = float4(_170.x, _170.y, _170.z, _45.w);
    float3 _181 = (_21_m5[2].yzx * _153.zzz) + _45.xyz;
    _45 = float4(_181.x, _181.y, _181.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _198 = _9.xxx * _45.xyz;
    _45 = float4(_198.x, _198.y, _198.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_205, _21_m6[0].xyz);
    _63.y = dot(_205, _21_m6[1].xyz);
    _63.z = dot(_205, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _241 = _45.xyz * _63.wxy;
    _241 = (_63.ywx * _45.yzx) + (-_241);
    _9.x = _153.w * _21_m7.w;
    _241 = _9.xxx * _241;
    vs_TEXCOORD1.y = _241.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _241.y;
    vs_TEXCOORD3.y = _241.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _299 = _63.y * _63.y;
    _299 = (_63.x * _63.x) + (-_299);
    _313 = _63.ywzx * _63;
    _318.x = dot(_21_m1, _313);
    _318.y = dot(_21_m2, _313);
    _318.z = dot(_21_m3, _313);
    vs_TEXCOORD4 = (_21_m4.xyz * _299.xxx) + _318;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _153 = stage_input._153;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _138;
static float4 _150;
static float4 vs_TEXCOORD1;
static float3 _208;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _208 : NORMAL;
    float4 _138 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _228;
static float4 _241;
static float4 _320;
static float3 _417;
static float4 _434;
static float3 _439;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m14.x;
    _102 *= (-_102);
    vs_TEXCOORD5 = exp2(_102);
    vs_TEXCOORD0 = (_138.xy * _23_m15.xy) + _23_m15.zw;
    float3 _156 = _150.yyy * _23_m10[1].yzx;
    _47 = float4(_156.x, _156.y, _156.z, _47.w);
    float3 _167 = (_23_m10[0].yzx * _150.xxx) + _47.xyz;
    _47 = float4(_167.x, _167.y, _167.z, _47.w);
    float3 _178 = (_23_m10[2].yzx * _150.zzz) + _47.xyz;
    _47 = float4(_178.x, _178.y, _178.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _192 = _102.xxx * _47.xyz;
    _47 = float4(_192.x, _192.y, _192.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _150.w * _23_m12.w;
    _65.x = dot(_208, _23_m11[0].xyz);
    _65.y = dot(_208, _23_m11[1].xyz);
    _65.z = dot(_208, _23_m11[2].xyz);
    _228 = dot(_65.xyz, _65.xyz);
    _228 = rsqrt(_228);
    _65 = _228.xxxx * _65.xyzz;
    float3 _246 = _47.xyz * _65.wxy;
    _241 = float4(_246.x, _246.y, _246.z, _241.w);
    float3 _257 = (_65.ywx * _47.yzx) + (-_241.xyz);
    _241 = float4(_257.x, _257.y, _257.z, _241.w);
    float3 _264 = _102.xxx * _241.xyz;
    _241 = float4(_264.x, _264.y, _264.z, _241.w);
    vs_TEXCOORD1.y = _241.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _241.y;
    vs_TEXCOORD3.y = _241.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _241 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _320 = _65.yyyy * _241;
    _241 *= _241;
    _241 = (_47 * _47) + _241;
    _47 = (_47 * _65.xxxx) + _320;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _241;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _241 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _241;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _380 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_380.x, _380.y, _380.z, _47.w);
    float3 _391 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_391.x, _391.y, _391.z, _47.w);
    float3 _402 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_402.x, _402.y, _402.z, _9.w);
    float3 _413 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_413.x, _413.y, _413.z, _9.w);
    _417.x = _65.y * _65.y;
    _417.x = (_65.x * _65.x) + (-_417.x);
    _434 = _65.ywzx * _65;
    _439.x = dot(_23_m6, _434);
    _439.y = dot(_23_m7, _434);
    _439.z = dot(_23_m8, _434);
    _417 = (_23_m9.xyz * _417.xxx) + _439;
    vs_TEXCOORD4 = _9.xyz + _417;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _150 = stage_input._150;
    _208 = stage_input._208;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _138;
static float4 _150;
static float4 vs_TEXCOORD1;
static float3 _208;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _208 : NORMAL;
    float4 _138 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _228;
static float4 _241;
static float4 _320;
static float3 _417;
static float4 _434;
static float3 _439;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m14.x;
    _102 *= (-_102);
    vs_TEXCOORD5 = exp2(_102);
    vs_TEXCOORD0 = (_138.xy * _23_m15.xy) + _23_m15.zw;
    float3 _156 = _150.yyy * _23_m10[1].yzx;
    _47 = float4(_156.x, _156.y, _156.z, _47.w);
    float3 _167 = (_23_m10[0].yzx * _150.xxx) + _47.xyz;
    _47 = float4(_167.x, _167.y, _167.z, _47.w);
    float3 _178 = (_23_m10[2].yzx * _150.zzz) + _47.xyz;
    _47 = float4(_178.x, _178.y, _178.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _192 = _102.xxx * _47.xyz;
    _47 = float4(_192.x, _192.y, _192.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _150.w * _23_m12.w;
    _65.x = dot(_208, _23_m11[0].xyz);
    _65.y = dot(_208, _23_m11[1].xyz);
    _65.z = dot(_208, _23_m11[2].xyz);
    _228 = dot(_65.xyz, _65.xyz);
    _228 = rsqrt(_228);
    _65 = _228.xxxx * _65.xyzz;
    float3 _246 = _47.xyz * _65.wxy;
    _241 = float4(_246.x, _246.y, _246.z, _241.w);
    float3 _257 = (_65.ywx * _47.yzx) + (-_241.xyz);
    _241 = float4(_257.x, _257.y, _257.z, _241.w);
    float3 _264 = _102.xxx * _241.xyz;
    _241 = float4(_264.x, _264.y, _264.z, _241.w);
    vs_TEXCOORD1.y = _241.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _241.y;
    vs_TEXCOORD3.y = _241.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _241 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _320 = _65.yyyy * _241;
    _241 *= _241;
    _241 = (_47 * _47) + _241;
    _47 = (_47 * _65.xxxx) + _320;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _241;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _241 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _241;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _380 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_380.x, _380.y, _380.z, _47.w);
    float3 _391 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_391.x, _391.y, _391.z, _47.w);
    float3 _402 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_402.x, _402.y, _402.z, _9.w);
    float3 _413 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_413.x, _413.y, _413.z, _9.w);
    _417.x = _65.y * _65.y;
    _417.x = (_65.x * _65.x) + (-_417.x);
    _434 = _65.ywzx * _65;
    _439.x = dot(_23_m6, _434);
    _439.y = dot(_23_m7, _434);
    _439.z = dot(_23_m8, _434);
    _417 = (_23_m9.xyz * _417.xxx) + _439;
    vs_TEXCOORD4 = _9.xyz + _417;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _150 = stage_input._150;
    _208 = stage_input._208;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _133;
static float4 vs_TEXCOORD1;
static float4 _150;
static float3 _202;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _202 : NORMAL;
    float4 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _238;
static float _296;
static float4 _310;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    vs_TEXCOORD5 = (_100 * _21_m9.z) + _21_m9.w;
    vs_TEXCOORD0 = (_133.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _156 = _150.yyy * _21_m5[1].yzx;
    _45 = float4(_156.x, _156.y, _156.z, _45.w);
    float3 _167 = (_21_m5[0].yzx * _150.xxx) + _45.xyz;
    _45 = float4(_167.x, _167.y, _167.z, _45.w);
    float3 _178 = (_21_m5[2].yzx * _150.zzz) + _45.xyz;
    _45 = float4(_178.x, _178.y, _178.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _195 = _9.xxx * _45.xyz;
    _45 = float4(_195.x, _195.y, _195.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_202, _21_m6[0].xyz);
    _63.y = dot(_202, _21_m6[1].xyz);
    _63.z = dot(_202, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _238 = _45.xyz * _63.wxy;
    _238 = (_63.ywx * _45.yzx) + (-_238);
    _9.x = _150.w * _21_m7.w;
    _238 = _9.xxx * _238;
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _296 = _63.y * _63.y;
    _296 = (_63.x * _63.x) + (-_296);
    _310 = _63.ywzx * _63;
    _315.x = dot(_21_m1, _310);
    _315.y = dot(_21_m2, _310);
    _315.z = dot(_21_m3, _310);
    vs_TEXCOORD4 = (_21_m4.xyz * _296.xxx) + _315;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _150 = stage_input._150;
    _202 = stage_input._202;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _135;
static float4 _147;
static float4 vs_TEXCOORD1;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _147 : TANGENT;
    float3 _205 : NORMAL;
    float4 _135 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _225;
static float4 _238;
static float4 _317;
static float3 _414;
static float4 _431;
static float3 _436;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    vs_TEXCOORD5 = (_102 * _23_m14.z) + _23_m14.w;
    vs_TEXCOORD0 = (_135.xy * _23_m15.xy) + _23_m15.zw;
    float3 _153 = _147.yyy * _23_m10[1].yzx;
    _47 = float4(_153.x, _153.y, _153.z, _47.w);
    float3 _164 = (_23_m10[0].yzx * _147.xxx) + _47.xyz;
    _47 = float4(_164.x, _164.y, _164.z, _47.w);
    float3 _175 = (_23_m10[2].yzx * _147.zzz) + _47.xyz;
    _47 = float4(_175.x, _175.y, _175.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _189 = _102.xxx * _47.xyz;
    _47 = float4(_189.x, _189.y, _189.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _147.w * _23_m12.w;
    _65.x = dot(_205, _23_m11[0].xyz);
    _65.y = dot(_205, _23_m11[1].xyz);
    _65.z = dot(_205, _23_m11[2].xyz);
    _225 = dot(_65.xyz, _65.xyz);
    _225 = rsqrt(_225);
    _65 = _225.xxxx * _65.xyzz;
    float3 _243 = _47.xyz * _65.wxy;
    _238 = float4(_243.x, _243.y, _243.z, _238.w);
    float3 _254 = (_65.ywx * _47.yzx) + (-_238.xyz);
    _238 = float4(_254.x, _254.y, _254.z, _238.w);
    float3 _261 = _102.xxx * _238.xyz;
    _238 = float4(_261.x, _261.y, _261.z, _238.w);
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _238 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _317 = _65.yyyy * _238;
    _238 *= _238;
    _238 = (_47 * _47) + _238;
    _47 = (_47 * _65.xxxx) + _317;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _238;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _238 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _238;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _377 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_377.x, _377.y, _377.z, _47.w);
    float3 _388 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_388.x, _388.y, _388.z, _47.w);
    float3 _399 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_399.x, _399.y, _399.z, _9.w);
    float3 _410 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_410.x, _410.y, _410.z, _9.w);
    _414.x = _65.y * _65.y;
    _414.x = (_65.x * _65.x) + (-_414.x);
    _431 = _65.ywzx * _65;
    _436.x = dot(_23_m6, _431);
    _436.y = dot(_23_m7, _431);
    _436.z = dot(_23_m8, _431);
    _414 = (_23_m9.xyz * _414.xxx) + _436;
    vs_TEXCOORD4 = _9.xyz + _414;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _135 = stage_input._135;
    _147 = stage_input._147;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _135;
static float4 _147;
static float4 vs_TEXCOORD1;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _147 : TANGENT;
    float3 _205 : NORMAL;
    float4 _135 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _225;
static float4 _238;
static float4 _317;
static float3 _414;
static float4 _431;
static float3 _436;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    vs_TEXCOORD5 = (_102 * _23_m14.z) + _23_m14.w;
    vs_TEXCOORD0 = (_135.xy * _23_m15.xy) + _23_m15.zw;
    float3 _153 = _147.yyy * _23_m10[1].yzx;
    _47 = float4(_153.x, _153.y, _153.z, _47.w);
    float3 _164 = (_23_m10[0].yzx * _147.xxx) + _47.xyz;
    _47 = float4(_164.x, _164.y, _164.z, _47.w);
    float3 _175 = (_23_m10[2].yzx * _147.zzz) + _47.xyz;
    _47 = float4(_175.x, _175.y, _175.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _189 = _102.xxx * _47.xyz;
    _47 = float4(_189.x, _189.y, _189.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _147.w * _23_m12.w;
    _65.x = dot(_205, _23_m11[0].xyz);
    _65.y = dot(_205, _23_m11[1].xyz);
    _65.z = dot(_205, _23_m11[2].xyz);
    _225 = dot(_65.xyz, _65.xyz);
    _225 = rsqrt(_225);
    _65 = _225.xxxx * _65.xyzz;
    float3 _243 = _47.xyz * _65.wxy;
    _238 = float4(_243.x, _243.y, _243.z, _238.w);
    float3 _254 = (_65.ywx * _47.yzx) + (-_238.xyz);
    _238 = float4(_254.x, _254.y, _254.z, _238.w);
    float3 _261 = _102.xxx * _238.xyz;
    _238 = float4(_261.x, _261.y, _261.z, _238.w);
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _238 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _317 = _65.yyyy * _238;
    _238 *= _238;
    _238 = (_47 * _47) + _238;
    _47 = (_47 * _65.xxxx) + _317;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _238;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _238 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _238;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _377 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_377.x, _377.y, _377.z, _47.w);
    float3 _388 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_388.x, _388.y, _388.z, _47.w);
    float3 _399 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_399.x, _399.y, _399.z, _9.w);
    float3 _410 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_410.x, _410.y, _410.z, _9.w);
    _414.x = _65.y * _65.y;
    _414.x = (_65.x * _65.x) + (-_414.x);
    _431 = _65.ywzx * _65;
    _436.x = dot(_23_m6, _431);
    _436.y = dot(_23_m7, _431);
    _436.z = dot(_23_m8, _431);
    _414 = (_23_m9.xyz * _414.xxx) + _436;
    vs_TEXCOORD4 = _9.xyz + _414;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _135 = stage_input._135;
    _147 = stage_input._147;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m9[4];
float4x4 unity_WorldToObject;
static float4 _23_m10[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 _MainTex_ST;
void __unity_init()
{
    _23_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 unity_4LightPosX0
#define _23_m1 unity_4LightPosY0
#define _23_m2 unity_4LightPosZ0
#define _23_m3 unity_4LightAtten0
#define _23_m4 unity_LightColor
#define _23_m5 unity_SHBr
#define _23_m6 unity_SHBg
#define _23_m7 unity_SHBb
#define _23_m8 unity_SHC
#define _23_m11 unity_WorldTransformParams
#define _23_m13 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _103;
static float4 _115;
static float4 vs_TEXCOORD1;
static float3 _179;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _115 : TANGENT;
    float3 _179 : NORMAL;
    float4 _103 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD6 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _147;
static float _199;
static float4 _212;
static float4 _291;
static float3 _389;
static float4 _406;
static float3 _411;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m9[1];
    _9 = (_23_m9[0] * _11.xxxx) + _9;
    _9 = (_23_m9[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m9[3];
    float3 _62 = (_23_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    gl_Position = (_23_m12[3] * _47.wwww) + _65;
    vs_TEXCOORD0 = (_103.xy * _23_m13.xy) + _23_m13.zw;
    float3 _121 = _115.yyy * _23_m9[1].yzx;
    _47 = float4(_121.x, _121.y, _121.z, _47.w);
    float3 _132 = (_23_m9[0].yzx * _115.xxx) + _47.xyz;
    _47 = float4(_132.x, _132.y, _132.z, _47.w);
    float3 _143 = (_23_m9[2].yzx * _115.zzz) + _47.xyz;
    _47 = float4(_143.x, _143.y, _143.z, _47.w);
    _147 = dot(_47.xyz, _47.xyz);
    _147 = rsqrt(_147);
    float3 _159 = _147.xxx * _47.xyz;
    _47 = float4(_159.x, _159.y, _159.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _147 = _115.w * _23_m11.w;
    _65.x = dot(_179, _23_m10[0].xyz);
    _65.y = dot(_179, _23_m10[1].xyz);
    _65.z = dot(_179, _23_m10[2].xyz);
    _199 = dot(_65.xyz, _65.xyz);
    _199 = rsqrt(_199);
    _65 = _199.xxxx * _65.xyzz;
    float3 _217 = _47.xyz * _65.wxy;
    _212 = float4(_217.x, _217.y, _217.z, _212.w);
    float3 _228 = (_65.ywx * _47.yzx) + (-_212.xyz);
    _212 = float4(_228.x, _228.y, _228.z, _212.w);
    float3 _235 = _147.xxx * _212.xyz;
    _212 = float4(_235.x, _235.y, _235.z, _212.w);
    vs_TEXCOORD1.y = _212.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _212.y;
    vs_TEXCOORD3.y = _212.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m0;
    _212 = (-_9.yyyy) + _23_m1;
    _9 = (-_9.zzzz) + _23_m2;
    _291 = _65.yyyy * _212;
    _212 *= _212;
    _212 = (_47 * _47) + _212;
    _47 = (_47 * _65.xxxx) + _291;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _212;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _212 = rsqrt(_9);
    _9 = (_9 * _23_m3) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _212;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _352 = _9.yyy * _23_m4[1].xyz;
    _47 = float4(_352.x, _352.y, _352.z, _47.w);
    float3 _363 = (_23_m4[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_363.x, _363.y, _363.z, _47.w);
    float3 _374 = (_23_m4[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_374.x, _374.y, _374.z, _9.w);
    float3 _385 = (_23_m4[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_385.x, _385.y, _385.z, _9.w);
    _389.x = _65.y * _65.y;
    _389.x = (_65.x * _65.x) + (-_389.x);
    _406 = _65.ywzx * _65;
    _411.x = dot(_23_m5, _406);
    _411.y = dot(_23_m6, _406);
    _411.z = dot(_23_m7, _406);
    _389 = (_23_m8.xyz * _389.xxx) + _411;
    vs_TEXCOORD4 = _9.xyz + _389;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _103 = stage_input._103;
    _115 = stage_input._115;
    _179 = stage_input._179;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_SpecCube0_HDR
#define _22_m10 _LightColor0
#define _22_m11 _Color
#define _22_m12 _BumpScale
#define _22_m13 _GlossMapScale
#define _22_m14 _OcclusionStrength
#define _22_m15 _GlowColor
#define _22_m16 _GlowBase
#define _22_m17 _GlowRim
#define _22_m18 _RimPower
#define _22_m19 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float4 _798;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _798 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m10.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m13) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m12.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m11.xyz;
    _432 = (_419 * _22_m11.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m13) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m19, _22_m19, _22_m19)) * _469) + 1.0f.xxx;
    _469 *= _22_m15.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m14 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m9.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m9.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m9.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m18;
    _247 = exp2(_247);
    _99.x = (_22_m17 * _247) + _22_m16;
    float3 _804 = (_469 * _99.xxx) + _9;
    _798 = float4(_804.x, _804.y, _804.z, _798.w);
    _798.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._798 = _798;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _132;
static float4 vs_TEXCOORD1;
static float4 _150;
static float3 _202;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _202 : NORMAL;
    float4 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _238;
static float _296;
static float4 _310;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    _100 *= _21_m9.y;
    vs_TEXCOORD5 = exp2(-_100);
    vs_TEXCOORD0 = (_132.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _156 = _150.yyy * _21_m5[1].yzx;
    _45 = float4(_156.x, _156.y, _156.z, _45.w);
    float3 _167 = (_21_m5[0].yzx * _150.xxx) + _45.xyz;
    _45 = float4(_167.x, _167.y, _167.z, _45.w);
    float3 _178 = (_21_m5[2].yzx * _150.zzz) + _45.xyz;
    _45 = float4(_178.x, _178.y, _178.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _195 = _9.xxx * _45.xyz;
    _45 = float4(_195.x, _195.y, _195.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_202, _21_m6[0].xyz);
    _63.y = dot(_202, _21_m6[1].xyz);
    _63.z = dot(_202, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _238 = _45.xyz * _63.wxy;
    _238 = (_63.ywx * _45.yzx) + (-_238);
    _9.x = _150.w * _21_m7.w;
    _238 = _9.xxx * _238;
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _296 = _63.y * _63.y;
    _296 = (_63.x * _63.x) + (-_296);
    _310 = _63.ywzx * _63;
    _315.x = dot(_21_m1, _310);
    _315.y = dot(_21_m2, _310);
    _315.z = dot(_21_m3, _310);
    vs_TEXCOORD4 = (_21_m4.xyz * _296.xxx) + _315;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _150 = stage_input._150;
    _202 = stage_input._202;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _132;
static float4 vs_TEXCOORD1;
static float4 _150;
static float3 _202;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _202 : NORMAL;
    float4 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _238;
static float _296;
static float4 _310;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    _100 *= _21_m9.y;
    vs_TEXCOORD5 = exp2(-_100);
    vs_TEXCOORD0 = (_132.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _156 = _150.yyy * _21_m5[1].yzx;
    _45 = float4(_156.x, _156.y, _156.z, _45.w);
    float3 _167 = (_21_m5[0].yzx * _150.xxx) + _45.xyz;
    _45 = float4(_167.x, _167.y, _167.z, _45.w);
    float3 _178 = (_21_m5[2].yzx * _150.zzz) + _45.xyz;
    _45 = float4(_178.x, _178.y, _178.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _195 = _9.xxx * _45.xyz;
    _45 = float4(_195.x, _195.y, _195.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_202, _21_m6[0].xyz);
    _63.y = dot(_202, _21_m6[1].xyz);
    _63.z = dot(_202, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _238 = _45.xyz * _63.wxy;
    _238 = (_63.ywx * _45.yzx) + (-_238);
    _9.x = _150.w * _21_m7.w;
    _238 = _9.xxx * _238;
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _296 = _63.y * _63.y;
    _296 = (_63.x * _63.x) + (-_296);
    _310 = _63.ywzx * _63;
    _315.x = dot(_21_m1, _310);
    _315.y = dot(_21_m2, _310);
    _315.z = dot(_21_m3, _310);
    vs_TEXCOORD4 = (_21_m4.xyz * _296.xxx) + _315;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _150 = stage_input._150;
    _202 = stage_input._202;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _134;
static float4 _146;
static float4 vs_TEXCOORD1;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _146 : TANGENT;
    float3 _205 : NORMAL;
    float4 _134 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _225;
static float4 _238;
static float4 _317;
static float3 _414;
static float4 _431;
static float3 _436;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m14.y;
    vs_TEXCOORD5 = exp2(-_102);
    vs_TEXCOORD0 = (_134.xy * _23_m15.xy) + _23_m15.zw;
    float3 _152 = _146.yyy * _23_m10[1].yzx;
    _47 = float4(_152.x, _152.y, _152.z, _47.w);
    float3 _163 = (_23_m10[0].yzx * _146.xxx) + _47.xyz;
    _47 = float4(_163.x, _163.y, _163.z, _47.w);
    float3 _174 = (_23_m10[2].yzx * _146.zzz) + _47.xyz;
    _47 = float4(_174.x, _174.y, _174.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _188 = _102.xxx * _47.xyz;
    _47 = float4(_188.x, _188.y, _188.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _146.w * _23_m12.w;
    _65.x = dot(_205, _23_m11[0].xyz);
    _65.y = dot(_205, _23_m11[1].xyz);
    _65.z = dot(_205, _23_m11[2].xyz);
    _225 = dot(_65.xyz, _65.xyz);
    _225 = rsqrt(_225);
    _65 = _225.xxxx * _65.xyzz;
    float3 _243 = _47.xyz * _65.wxy;
    _238 = float4(_243.x, _243.y, _243.z, _238.w);
    float3 _254 = (_65.ywx * _47.yzx) + (-_238.xyz);
    _238 = float4(_254.x, _254.y, _254.z, _238.w);
    float3 _261 = _102.xxx * _238.xyz;
    _238 = float4(_261.x, _261.y, _261.z, _238.w);
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _238 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _317 = _65.yyyy * _238;
    _238 *= _238;
    _238 = (_47 * _47) + _238;
    _47 = (_47 * _65.xxxx) + _317;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _238;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _238 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _238;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _377 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_377.x, _377.y, _377.z, _47.w);
    float3 _388 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_388.x, _388.y, _388.z, _47.w);
    float3 _399 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_399.x, _399.y, _399.z, _9.w);
    float3 _410 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_410.x, _410.y, _410.z, _9.w);
    _414.x = _65.y * _65.y;
    _414.x = (_65.x * _65.x) + (-_414.x);
    _431 = _65.ywzx * _65;
    _436.x = dot(_23_m6, _431);
    _436.y = dot(_23_m7, _431);
    _436.z = dot(_23_m8, _431);
    _414 = (_23_m9.xyz * _414.xxx) + _436;
    vs_TEXCOORD4 = _9.xyz + _414;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _134 = stage_input._134;
    _146 = stage_input._146;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _136;
static float4 vs_TEXCOORD1;
static float4 _153;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _153 : TANGENT;
    float3 _205 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _241;
static float _299;
static float4 _313;
static float3 _318;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    _100 *= _21_m9.x;
    _100 *= (-_100);
    vs_TEXCOORD5 = exp2(_100);
    vs_TEXCOORD0 = (_136.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _159 = _153.yyy * _21_m5[1].yzx;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    float3 _170 = (_21_m5[0].yzx * _153.xxx) + _45.xyz;
    _45 = float4(_170.x, _170.y, _170.z, _45.w);
    float3 _181 = (_21_m5[2].yzx * _153.zzz) + _45.xyz;
    _45 = float4(_181.x, _181.y, _181.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _198 = _9.xxx * _45.xyz;
    _45 = float4(_198.x, _198.y, _198.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_205, _21_m6[0].xyz);
    _63.y = dot(_205, _21_m6[1].xyz);
    _63.z = dot(_205, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _241 = _45.xyz * _63.wxy;
    _241 = (_63.ywx * _45.yzx) + (-_241);
    _9.x = _153.w * _21_m7.w;
    _241 = _9.xxx * _241;
    vs_TEXCOORD1.y = _241.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _241.y;
    vs_TEXCOORD3.y = _241.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _299 = _63.y * _63.y;
    _299 = (_63.x * _63.x) + (-_299);
    _313 = _63.ywzx * _63;
    _318.x = dot(_21_m1, _313);
    _318.y = dot(_21_m2, _313);
    _318.z = dot(_21_m3, _313);
    vs_TEXCOORD4 = (_21_m4.xyz * _299.xxx) + _318;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _153 = stage_input._153;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _136;
static float4 vs_TEXCOORD1;
static float4 _153;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _153 : TANGENT;
    float3 _205 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _241;
static float _299;
static float4 _313;
static float3 _318;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    _100 *= _21_m9.x;
    _100 *= (-_100);
    vs_TEXCOORD5 = exp2(_100);
    vs_TEXCOORD0 = (_136.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _159 = _153.yyy * _21_m5[1].yzx;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    float3 _170 = (_21_m5[0].yzx * _153.xxx) + _45.xyz;
    _45 = float4(_170.x, _170.y, _170.z, _45.w);
    float3 _181 = (_21_m5[2].yzx * _153.zzz) + _45.xyz;
    _45 = float4(_181.x, _181.y, _181.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _198 = _9.xxx * _45.xyz;
    _45 = float4(_198.x, _198.y, _198.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_205, _21_m6[0].xyz);
    _63.y = dot(_205, _21_m6[1].xyz);
    _63.z = dot(_205, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _241 = _45.xyz * _63.wxy;
    _241 = (_63.ywx * _45.yzx) + (-_241);
    _9.x = _153.w * _21_m7.w;
    _241 = _9.xxx * _241;
    vs_TEXCOORD1.y = _241.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _241.y;
    vs_TEXCOORD3.y = _241.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _299 = _63.y * _63.y;
    _299 = (_63.x * _63.x) + (-_299);
    _313 = _63.ywzx * _63;
    _318.x = dot(_21_m1, _313);
    _318.y = dot(_21_m2, _313);
    _318.z = dot(_21_m3, _313);
    vs_TEXCOORD4 = (_21_m4.xyz * _299.xxx) + _318;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _153 = stage_input._153;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _138;
static float4 _150;
static float4 vs_TEXCOORD1;
static float3 _208;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _208 : NORMAL;
    float4 _138 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _228;
static float4 _241;
static float4 _320;
static float3 _417;
static float4 _434;
static float3 _439;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m14.x;
    _102 *= (-_102);
    vs_TEXCOORD5 = exp2(_102);
    vs_TEXCOORD0 = (_138.xy * _23_m15.xy) + _23_m15.zw;
    float3 _156 = _150.yyy * _23_m10[1].yzx;
    _47 = float4(_156.x, _156.y, _156.z, _47.w);
    float3 _167 = (_23_m10[0].yzx * _150.xxx) + _47.xyz;
    _47 = float4(_167.x, _167.y, _167.z, _47.w);
    float3 _178 = (_23_m10[2].yzx * _150.zzz) + _47.xyz;
    _47 = float4(_178.x, _178.y, _178.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _192 = _102.xxx * _47.xyz;
    _47 = float4(_192.x, _192.y, _192.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _150.w * _23_m12.w;
    _65.x = dot(_208, _23_m11[0].xyz);
    _65.y = dot(_208, _23_m11[1].xyz);
    _65.z = dot(_208, _23_m11[2].xyz);
    _228 = dot(_65.xyz, _65.xyz);
    _228 = rsqrt(_228);
    _65 = _228.xxxx * _65.xyzz;
    float3 _246 = _47.xyz * _65.wxy;
    _241 = float4(_246.x, _246.y, _246.z, _241.w);
    float3 _257 = (_65.ywx * _47.yzx) + (-_241.xyz);
    _241 = float4(_257.x, _257.y, _257.z, _241.w);
    float3 _264 = _102.xxx * _241.xyz;
    _241 = float4(_264.x, _264.y, _264.z, _241.w);
    vs_TEXCOORD1.y = _241.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _241.y;
    vs_TEXCOORD3.y = _241.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _241 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _320 = _65.yyyy * _241;
    _241 *= _241;
    _241 = (_47 * _47) + _241;
    _47 = (_47 * _65.xxxx) + _320;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _241;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _241 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _241;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _380 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_380.x, _380.y, _380.z, _47.w);
    float3 _391 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_391.x, _391.y, _391.z, _47.w);
    float3 _402 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_402.x, _402.y, _402.z, _9.w);
    float3 _413 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_413.x, _413.y, _413.z, _9.w);
    _417.x = _65.y * _65.y;
    _417.x = (_65.x * _65.x) + (-_417.x);
    _434 = _65.ywzx * _65;
    _439.x = dot(_23_m6, _434);
    _439.y = dot(_23_m7, _434);
    _439.z = dot(_23_m8, _434);
    _417 = (_23_m9.xyz * _417.xxx) + _439;
    vs_TEXCOORD4 = _9.xyz + _417;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _150 = stage_input._150;
    _208 = stage_input._208;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _133;
static float4 vs_TEXCOORD1;
static float4 _150;
static float3 _202;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _202 : NORMAL;
    float4 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _238;
static float _296;
static float4 _310;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    vs_TEXCOORD5 = (_100 * _21_m9.z) + _21_m9.w;
    vs_TEXCOORD0 = (_133.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _156 = _150.yyy * _21_m5[1].yzx;
    _45 = float4(_156.x, _156.y, _156.z, _45.w);
    float3 _167 = (_21_m5[0].yzx * _150.xxx) + _45.xyz;
    _45 = float4(_167.x, _167.y, _167.z, _45.w);
    float3 _178 = (_21_m5[2].yzx * _150.zzz) + _45.xyz;
    _45 = float4(_178.x, _178.y, _178.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _195 = _9.xxx * _45.xyz;
    _45 = float4(_195.x, _195.y, _195.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_202, _21_m6[0].xyz);
    _63.y = dot(_202, _21_m6[1].xyz);
    _63.z = dot(_202, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _238 = _45.xyz * _63.wxy;
    _238 = (_63.ywx * _45.yzx) + (-_238);
    _9.x = _150.w * _21_m7.w;
    _238 = _9.xxx * _238;
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _296 = _63.y * _63.y;
    _296 = (_63.x * _63.x) + (-_296);
    _310 = _63.ywzx * _63;
    _315.x = dot(_21_m1, _310);
    _315.y = dot(_21_m2, _310);
    _315.z = dot(_21_m3, _310);
    vs_TEXCOORD4 = (_21_m4.xyz * _296.xxx) + _315;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _150 = stage_input._150;
    _202 = stage_input._202;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _133;
static float4 vs_TEXCOORD1;
static float4 _150;
static float3 _202;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _202 : NORMAL;
    float4 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _238;
static float _296;
static float4 _310;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    vs_TEXCOORD5 = (_100 * _21_m9.z) + _21_m9.w;
    vs_TEXCOORD0 = (_133.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _156 = _150.yyy * _21_m5[1].yzx;
    _45 = float4(_156.x, _156.y, _156.z, _45.w);
    float3 _167 = (_21_m5[0].yzx * _150.xxx) + _45.xyz;
    _45 = float4(_167.x, _167.y, _167.z, _45.w);
    float3 _178 = (_21_m5[2].yzx * _150.zzz) + _45.xyz;
    _45 = float4(_178.x, _178.y, _178.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _195 = _9.xxx * _45.xyz;
    _45 = float4(_195.x, _195.y, _195.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_202, _21_m6[0].xyz);
    _63.y = dot(_202, _21_m6[1].xyz);
    _63.z = dot(_202, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _238 = _45.xyz * _63.wxy;
    _238 = (_63.ywx * _45.yzx) + (-_238);
    _9.x = _150.w * _21_m7.w;
    _238 = _9.xxx * _238;
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _296 = _63.y * _63.y;
    _296 = (_63.x * _63.x) + (-_296);
    _310 = _63.ywzx * _63;
    _315.x = dot(_21_m1, _310);
    _315.y = dot(_21_m2, _310);
    _315.z = dot(_21_m3, _310);
    vs_TEXCOORD4 = (_21_m4.xyz * _296.xxx) + _315;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _150 = stage_input._150;
    _202 = stage_input._202;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _BumpScale
#define _22_m14 _GlossMapScale
#define _22_m15 _OcclusionStrength
#define _22_m16 _GlowColor
#define _22_m17 _GlowBase
#define _22_m18 _GlowRim
#define _22_m19 _RimPower
#define _22_m20 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _826;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _826 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m11.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m14) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m13.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m12.xyz;
    _432 = (_419 * _22_m12.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m14) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _469) + 1.0f.xxx;
    _469 *= _22_m16.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m15 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m10.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m10.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m10.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m19;
    _247 = exp2(_247);
    _99.x = (_22_m18 * _247) + _22_m17;
    float3 _802 = (_469 * _99.xxx) + _9;
    _99 = float4(_802.x, _802.y, _802.z, _99.w);
    _9 = _99.xyz + (-_22_m9.xyz);
    _247 = vs_TEXCOORD5;
    _247 = clamp(_247, 0.0f, 1.0f);
    _9 = (_247.xxx * _9) + _22_m9.xyz;
    _826 = float4(_9.x, _9.y, _9.z, _826.w);
    _826.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._826 = _826;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m13[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m13[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m13[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m13[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m13[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m12 unity_WorldTransformParams
#define _23_m14 unity_FogParams
#define _23_m15 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _135;
static float4 _147;
static float4 vs_TEXCOORD1;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _147 : TANGENT;
    float3 _205 : NORMAL;
    float4 _135 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float _225;
static float4 _238;
static float4 _317;
static float3 _414;
static float4 _431;
static float3 _436;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m13[1];
    _65 = (_23_m13[0] * _47.xxxx) + _65;
    _65 = (_23_m13[2] * _47.zzzz) + _65;
    _47 = (_23_m13[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    vs_TEXCOORD5 = (_102 * _23_m14.z) + _23_m14.w;
    vs_TEXCOORD0 = (_135.xy * _23_m15.xy) + _23_m15.zw;
    float3 _153 = _147.yyy * _23_m10[1].yzx;
    _47 = float4(_153.x, _153.y, _153.z, _47.w);
    float3 _164 = (_23_m10[0].yzx * _147.xxx) + _47.xyz;
    _47 = float4(_164.x, _164.y, _164.z, _47.w);
    float3 _175 = (_23_m10[2].yzx * _147.zzz) + _47.xyz;
    _47 = float4(_175.x, _175.y, _175.z, _47.w);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _189 = _102.xxx * _47.xyz;
    _47 = float4(_189.x, _189.y, _189.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _102 = _147.w * _23_m12.w;
    _65.x = dot(_205, _23_m11[0].xyz);
    _65.y = dot(_205, _23_m11[1].xyz);
    _65.z = dot(_205, _23_m11[2].xyz);
    _225 = dot(_65.xyz, _65.xyz);
    _225 = rsqrt(_225);
    _65 = _225.xxxx * _65.xyzz;
    float3 _243 = _47.xyz * _65.wxy;
    _238 = float4(_243.x, _243.y, _243.z, _238.w);
    float3 _254 = (_65.ywx * _47.yzx) + (-_238.xyz);
    _238 = float4(_254.x, _254.y, _254.z, _238.w);
    float3 _261 = _102.xxx * _238.xyz;
    _238 = float4(_261.x, _261.y, _261.z, _238.w);
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m1;
    _238 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _317 = _65.yyyy * _238;
    _238 *= _238;
    _238 = (_47 * _47) + _238;
    _47 = (_47 * _65.xxxx) + _317;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _238;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _238 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _238;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _377 = _9.yyy * _23_m5[1].xyz;
    _47 = float4(_377.x, _377.y, _377.z, _47.w);
    float3 _388 = (_23_m5[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_388.x, _388.y, _388.z, _47.w);
    float3 _399 = (_23_m5[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_399.x, _399.y, _399.z, _9.w);
    float3 _410 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_410.x, _410.y, _410.z, _9.w);
    _414.x = _65.y * _65.y;
    _414.x = (_65.x * _65.x) + (-_414.x);
    _431 = _65.ywzx * _65;
    _436.x = dot(_23_m6, _431);
    _436.y = dot(_23_m7, _431);
    _436.z = dot(_23_m8, _431);
    _414 = (_23_m9.xyz * _414.xxx) + _436;
    vs_TEXCOORD4 = _9.xyz + _414;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _135 = stage_input._135;
    _147 = stage_input._147;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m4[4];
float4x4 unity_WorldToObject;
static float4 _21_m5[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 _MainTex_ST;
void __unity_init()
{
    _21_m4[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m4[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m4[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m4[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m5[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m5[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m5[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m5[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHBr
#define _21_m1 unity_SHBg
#define _21_m2 unity_SHBb
#define _21_m3 unity_SHC
#define _21_m6 unity_WorldTransformParams
#define _21_m8 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _101;
static float4 vs_TEXCOORD1;
static float4 _121;
static float3 _174;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _121 : TANGENT;
    float3 _174 : NORMAL;
    float4 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD6 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float3 _210;
static float _269;
static float4 _283;
static float3 _288;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _11.xxxx) + _9;
    _9 = (_21_m4[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m4[3];
    float3 _60 = (_21_m4[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m7[1];
    _63 = (_21_m7[0] * _45.xxxx) + _63;
    _63 = (_21_m7[2] * _45.zzzz) + _63;
    gl_Position = (_21_m7[3] * _45.wwww) + _63;
    vs_TEXCOORD0 = (_101.xy * _21_m8.xy) + _21_m8.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _127 = _121.yyy * _21_m4[1].yzx;
    _45 = float4(_127.x, _127.y, _127.z, _45.w);
    float3 _138 = (_21_m4[0].yzx * _121.xxx) + _45.xyz;
    _45 = float4(_138.x, _138.y, _138.z, _45.w);
    float3 _149 = (_21_m4[2].yzx * _121.zzz) + _45.xyz;
    _45 = float4(_149.x, _149.y, _149.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _166 = _9.xxx * _45.xyz;
    _45 = float4(_166.x, _166.y, _166.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_174, _21_m5[0].xyz);
    _63.y = dot(_174, _21_m5[1].xyz);
    _63.z = dot(_174, _21_m5[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _210 = _45.xyz * _63.wxy;
    _210 = (_63.ywx * _45.yzx) + (-_210);
    _9.x = _121.w * _21_m6.w;
    _210 = _9.xxx * _210;
    vs_TEXCOORD1.y = _210.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _210.y;
    vs_TEXCOORD3.y = _210.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _269 = _63.y * _63.y;
    _269 = (_63.x * _63.x) + (-_269);
    _283 = _63.ywzx * _63;
    _288.x = dot(_21_m0, _283);
    _288.y = dot(_21_m1, _283);
    _288.z = dot(_21_m2, _283);
    vs_TEXCOORD4 = (_21_m3.xyz * _269.xxx) + _288;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _121 = stage_input._121;
    _174 = stage_input._174;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_SpecCube0_HDR
#define _22_m10 _LightColor0
#define _22_m11 _Color
#define _22_m12 _BumpScale
#define _22_m13 _GlossMapScale
#define _22_m14 _OcclusionStrength
#define _22_m15 _GlowColor
#define _22_m16 _GlowBase
#define _22_m17 _GlowRim
#define _22_m18 _RimPower
#define _22_m19 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float4 _798;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _798 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m10.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m13) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m12.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m11.xyz;
    _432 = (_419 * _22_m11.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m13) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m19, _22_m19, _22_m19)) * _469) + 1.0f.xxx;
    _469 *= _22_m15.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m14 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m9.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m9.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m9.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m18;
    _247 = exp2(_247);
    _99.x = (_22_m17 * _247) + _22_m16;
    float3 _804 = (_469 * _99.xxx) + _9;
    _798 = float4(_804.x, _804.y, _804.z, _798.w);
    _798.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._798 = _798;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m9[4];
float4x4 unity_WorldToObject;
static float4 _23_m10[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 _MainTex_ST;
void __unity_init()
{
    _23_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 unity_4LightPosX0
#define _23_m1 unity_4LightPosY0
#define _23_m2 unity_4LightPosZ0
#define _23_m3 unity_4LightAtten0
#define _23_m4 unity_LightColor
#define _23_m5 unity_SHBr
#define _23_m6 unity_SHBg
#define _23_m7 unity_SHBb
#define _23_m8 unity_SHC
#define _23_m11 unity_WorldTransformParams
#define _23_m13 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _103;
static float4 _115;
static float4 vs_TEXCOORD1;
static float3 _179;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _115 : TANGENT;
    float3 _179 : NORMAL;
    float4 _103 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD6 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _147;
static float _199;
static float4 _212;
static float4 _291;
static float3 _389;
static float4 _406;
static float3 _411;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m9[1];
    _9 = (_23_m9[0] * _11.xxxx) + _9;
    _9 = (_23_m9[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m9[3];
    float3 _62 = (_23_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    gl_Position = (_23_m12[3] * _47.wwww) + _65;
    vs_TEXCOORD0 = (_103.xy * _23_m13.xy) + _23_m13.zw;
    float3 _121 = _115.yyy * _23_m9[1].yzx;
    _47 = float4(_121.x, _121.y, _121.z, _47.w);
    float3 _132 = (_23_m9[0].yzx * _115.xxx) + _47.xyz;
    _47 = float4(_132.x, _132.y, _132.z, _47.w);
    float3 _143 = (_23_m9[2].yzx * _115.zzz) + _47.xyz;
    _47 = float4(_143.x, _143.y, _143.z, _47.w);
    _147 = dot(_47.xyz, _47.xyz);
    _147 = rsqrt(_147);
    float3 _159 = _147.xxx * _47.xyz;
    _47 = float4(_159.x, _159.y, _159.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _147 = _115.w * _23_m11.w;
    _65.x = dot(_179, _23_m10[0].xyz);
    _65.y = dot(_179, _23_m10[1].xyz);
    _65.z = dot(_179, _23_m10[2].xyz);
    _199 = dot(_65.xyz, _65.xyz);
    _199 = rsqrt(_199);
    _65 = _199.xxxx * _65.xyzz;
    float3 _217 = _47.xyz * _65.wxy;
    _212 = float4(_217.x, _217.y, _217.z, _212.w);
    float3 _228 = (_65.ywx * _47.yzx) + (-_212.xyz);
    _212 = float4(_228.x, _228.y, _228.z, _212.w);
    float3 _235 = _147.xxx * _212.xyz;
    _212 = float4(_235.x, _235.y, _235.z, _212.w);
    vs_TEXCOORD1.y = _212.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _212.y;
    vs_TEXCOORD3.y = _212.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m0;
    _212 = (-_9.yyyy) + _23_m1;
    _9 = (-_9.zzzz) + _23_m2;
    _291 = _65.yyyy * _212;
    _212 *= _212;
    _212 = (_47 * _47) + _212;
    _47 = (_47 * _65.xxxx) + _291;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _212;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _212 = rsqrt(_9);
    _9 = (_9 * _23_m3) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _212;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _352 = _9.yyy * _23_m4[1].xyz;
    _47 = float4(_352.x, _352.y, _352.z, _47.w);
    float3 _363 = (_23_m4[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_363.x, _363.y, _363.z, _47.w);
    float3 _374 = (_23_m4[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_374.x, _374.y, _374.z, _9.w);
    float3 _385 = (_23_m4[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_385.x, _385.y, _385.z, _9.w);
    _389.x = _65.y * _65.y;
    _389.x = (_65.x * _65.x) + (-_389.x);
    _406 = _65.ywzx * _65;
    _411.x = dot(_23_m5, _406);
    _411.y = dot(_23_m6, _406);
    _411.z = dot(_23_m7, _406);
    _389 = (_23_m8.xyz * _389.xxx) + _411;
    vs_TEXCOORD4 = _9.xyz + _389;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _103 = stage_input._103;
    _115 = stage_input._115;
    _179 = stage_input._179;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_SpecCube0_HDR
#define _36_m6 _LightColor0
#define _36_m7 _Color
#define _36_m8 _BumpScale
#define _36_m9 _GlossMapScale
#define _36_m10 _OcclusionStrength
#define _36_m11 _GlowColor
#define _36_m12 _GlowBase
#define _36_m13 _GlowRim
#define _36_m14 _RimPower
#define _36_m15 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float4 _615;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _615 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m9) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m8.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m7.xyz;
    _263 = (_250 * _36_m7.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m9) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m15, _36_m15, _36_m15)) * _301) + 1.0f.xxx;
    _301 *= _36_m11.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m6.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m10 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m5.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m5.y;
    _279 = exp2(_279);
    _279 *= _36_m5.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m14;
    _9.x = exp2(_9.x);
    _139.x = (_36_m13 * _9.x) + _36_m12;
    float3 _621 = (_301 * _139.xxx) + _54;
    _615 = float4(_621.x, _621.y, _621.z, _615.w);
    _615.w = 1.0f;
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
    stage_output._615 = _615;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m9[4];
float4x4 unity_WorldToObject;
static float4 _23_m10[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 _MainTex_ST;
void __unity_init()
{
    _23_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 unity_4LightPosX0
#define _23_m1 unity_4LightPosY0
#define _23_m2 unity_4LightPosZ0
#define _23_m3 unity_4LightAtten0
#define _23_m4 unity_LightColor
#define _23_m5 unity_SHBr
#define _23_m6 unity_SHBg
#define _23_m7 unity_SHBb
#define _23_m8 unity_SHC
#define _23_m11 unity_WorldTransformParams
#define _23_m13 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _103;
static float4 _115;
static float4 vs_TEXCOORD1;
static float3 _179;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _115 : TANGENT;
    float3 _179 : NORMAL;
    float4 _103 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD6 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _147;
static float _199;
static float4 _212;
static float4 _291;
static float3 _389;
static float4 _406;
static float3 _411;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m9[1];
    _9 = (_23_m9[0] * _11.xxxx) + _9;
    _9 = (_23_m9[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m9[3];
    float3 _62 = (_23_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    gl_Position = (_23_m12[3] * _47.wwww) + _65;
    vs_TEXCOORD0 = (_103.xy * _23_m13.xy) + _23_m13.zw;
    float3 _121 = _115.yyy * _23_m9[1].yzx;
    _47 = float4(_121.x, _121.y, _121.z, _47.w);
    float3 _132 = (_23_m9[0].yzx * _115.xxx) + _47.xyz;
    _47 = float4(_132.x, _132.y, _132.z, _47.w);
    float3 _143 = (_23_m9[2].yzx * _115.zzz) + _47.xyz;
    _47 = float4(_143.x, _143.y, _143.z, _47.w);
    _147 = dot(_47.xyz, _47.xyz);
    _147 = rsqrt(_147);
    float3 _159 = _147.xxx * _47.xyz;
    _47 = float4(_159.x, _159.y, _159.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _147 = _115.w * _23_m11.w;
    _65.x = dot(_179, _23_m10[0].xyz);
    _65.y = dot(_179, _23_m10[1].xyz);
    _65.z = dot(_179, _23_m10[2].xyz);
    _199 = dot(_65.xyz, _65.xyz);
    _199 = rsqrt(_199);
    _65 = _199.xxxx * _65.xyzz;
    float3 _217 = _47.xyz * _65.wxy;
    _212 = float4(_217.x, _217.y, _217.z, _212.w);
    float3 _228 = (_65.ywx * _47.yzx) + (-_212.xyz);
    _212 = float4(_228.x, _228.y, _228.z, _212.w);
    float3 _235 = _147.xxx * _212.xyz;
    _212 = float4(_235.x, _235.y, _235.z, _212.w);
    vs_TEXCOORD1.y = _212.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _212.y;
    vs_TEXCOORD3.y = _212.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m0;
    _212 = (-_9.yyyy) + _23_m1;
    _9 = (-_9.zzzz) + _23_m2;
    _291 = _65.yyyy * _212;
    _212 *= _212;
    _212 = (_47 * _47) + _212;
    _47 = (_47 * _65.xxxx) + _291;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _212;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _212 = rsqrt(_9);
    _9 = (_9 * _23_m3) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _212;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _352 = _9.yyy * _23_m4[1].xyz;
    _47 = float4(_352.x, _352.y, _352.z, _47.w);
    float3 _363 = (_23_m4[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_363.x, _363.y, _363.z, _47.w);
    float3 _374 = (_23_m4[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_374.x, _374.y, _374.z, _9.w);
    float3 _385 = (_23_m4[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_385.x, _385.y, _385.z, _9.w);
    _389.x = _65.y * _65.y;
    _389.x = (_65.x * _65.x) + (-_389.x);
    _406 = _65.ywzx * _65;
    _411.x = dot(_23_m5, _406);
    _411.y = dot(_23_m6, _406);
    _411.z = dot(_23_m7, _406);
    _389 = (_23_m8.xyz * _389.xxx) + _411;
    vs_TEXCOORD4 = _9.xyz + _389;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _103 = stage_input._103;
    _115 = stage_input._115;
    _179 = stage_input._179;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_SpecCube0_HDR
#define _22_m10 _LightColor0
#define _22_m11 _Color
#define _22_m12 _BumpScale
#define _22_m13 _GlossMapScale
#define _22_m14 _OcclusionStrength
#define _22_m15 _GlowColor
#define _22_m16 _GlowBase
#define _22_m17 _GlowRim
#define _22_m18 _RimPower
#define _22_m19 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float4 _798;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _798 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m10.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m13) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m12.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m11.xyz;
    _432 = (_419 * _22_m11.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m13) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m19, _22_m19, _22_m19)) * _469) + 1.0f.xxx;
    _469 *= _22_m15.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m14 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m9.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m9.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m9.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m18;
    _247 = exp2(_247);
    _99.x = (_22_m17 * _247) + _22_m16;
    float3 _804 = (_469 * _99.xxx) + _9;
    _798 = float4(_804.x, _804.y, _804.z, _798.w);
    _798.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._798 = _798;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _132;
static float4 vs_TEXCOORD1;
static float4 _150;
static float3 _202;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _202 : NORMAL;
    float4 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _238;
static float _296;
static float4 _310;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    _100 *= _21_m9.y;
    vs_TEXCOORD5 = exp2(-_100);
    vs_TEXCOORD0 = (_132.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _156 = _150.yyy * _21_m5[1].yzx;
    _45 = float4(_156.x, _156.y, _156.z, _45.w);
    float3 _167 = (_21_m5[0].yzx * _150.xxx) + _45.xyz;
    _45 = float4(_167.x, _167.y, _167.z, _45.w);
    float3 _178 = (_21_m5[2].yzx * _150.zzz) + _45.xyz;
    _45 = float4(_178.x, _178.y, _178.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _195 = _9.xxx * _45.xyz;
    _45 = float4(_195.x, _195.y, _195.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_202, _21_m6[0].xyz);
    _63.y = dot(_202, _21_m6[1].xyz);
    _63.z = dot(_202, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _238 = _45.xyz * _63.wxy;
    _238 = (_63.ywx * _45.yzx) + (-_238);
    _9.x = _150.w * _21_m7.w;
    _238 = _9.xxx * _238;
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _296 = _63.y * _63.y;
    _296 = (_63.x * _63.x) + (-_296);
    _310 = _63.ywzx * _63;
    _315.x = dot(_21_m1, _310);
    _315.y = dot(_21_m2, _310);
    _315.z = dot(_21_m3, _310);
    vs_TEXCOORD4 = (_21_m4.xyz * _296.xxx) + _315;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _150 = stage_input._150;
    _202 = stage_input._202;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _136;
static float4 vs_TEXCOORD1;
static float4 _153;
static float3 _205;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _153 : TANGENT;
    float3 _205 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _241;
static float _299;
static float4 _313;
static float3 _318;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    _100 *= _21_m9.x;
    _100 *= (-_100);
    vs_TEXCOORD5 = exp2(_100);
    vs_TEXCOORD0 = (_136.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _159 = _153.yyy * _21_m5[1].yzx;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    float3 _170 = (_21_m5[0].yzx * _153.xxx) + _45.xyz;
    _45 = float4(_170.x, _170.y, _170.z, _45.w);
    float3 _181 = (_21_m5[2].yzx * _153.zzz) + _45.xyz;
    _45 = float4(_181.x, _181.y, _181.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _198 = _9.xxx * _45.xyz;
    _45 = float4(_198.x, _198.y, _198.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_205, _21_m6[0].xyz);
    _63.y = dot(_205, _21_m6[1].xyz);
    _63.z = dot(_205, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _241 = _45.xyz * _63.wxy;
    _241 = (_63.ywx * _45.yzx) + (-_241);
    _9.x = _153.w * _21_m7.w;
    _241 = _9.xxx * _241;
    vs_TEXCOORD1.y = _241.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _241.y;
    vs_TEXCOORD3.y = _241.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _299 = _63.y * _63.y;
    _299 = (_63.x * _63.x) + (-_299);
    _313 = _63.ywzx * _63;
    _318.x = dot(_21_m1, _313);
    _318.y = dot(_21_m2, _313);
    _318.z = dot(_21_m3, _313);
    vs_TEXCOORD4 = (_21_m4.xyz * _299.xxx) + _318;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _153 = stage_input._153;
    _205 = stage_input._205;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m7 unity_WorldTransformParams
#define _21_m9 unity_FogParams
#define _21_m10 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _133;
static float4 vs_TEXCOORD1;
static float4 _150;
static float3 _202;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : TANGENT;
    float3 _202 : NORMAL;
    float4 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float _100;
static float3 _238;
static float _296;
static float4 _310;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    float3 _60 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m8[1];
    _63 = (_21_m8[0] * _45.xxxx) + _63;
    _63 = (_21_m8[2] * _45.zzzz) + _63;
    _45 = (_21_m8[3] * _45.wwww) + _63;
    gl_Position = _45;
    _100 = _45.z / _21_m0.y;
    _100 = (-_100) + 1.0f;
    _100 *= _21_m0.z;
    _100 = max(_100, 0.0f);
    vs_TEXCOORD5 = (_100 * _21_m9.z) + _21_m9.w;
    vs_TEXCOORD0 = (_133.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _156 = _150.yyy * _21_m5[1].yzx;
    _45 = float4(_156.x, _156.y, _156.z, _45.w);
    float3 _167 = (_21_m5[0].yzx * _150.xxx) + _45.xyz;
    _45 = float4(_167.x, _167.y, _167.z, _45.w);
    float3 _178 = (_21_m5[2].yzx * _150.zzz) + _45.xyz;
    _45 = float4(_178.x, _178.y, _178.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _195 = _9.xxx * _45.xyz;
    _45 = float4(_195.x, _195.y, _195.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_202, _21_m6[0].xyz);
    _63.y = dot(_202, _21_m6[1].xyz);
    _63.z = dot(_202, _21_m6[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _238 = _45.xyz * _63.wxy;
    _238 = (_63.ywx * _45.yzx) + (-_238);
    _9.x = _150.w * _21_m7.w;
    _238 = _9.xxx * _238;
    vs_TEXCOORD1.y = _238.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _238.y;
    vs_TEXCOORD3.y = _238.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _296 = _63.y * _63.y;
    _296 = (_63.x * _63.x) + (-_296);
    _310 = _63.ywzx * _63;
    _315.x = dot(_21_m1, _310);
    _315.y = dot(_21_m2, _310);
    _315.z = dot(_21_m3, _310);
    vs_TEXCOORD4 = (_21_m4.xyz * _296.xxx) + _315;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _150 = stage_input._150;
    _202 = stage_input._202;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_FogColor
#define _36_m6 unity_SpecCube0_HDR
#define _36_m7 _LightColor0
#define _36_m8 _Color
#define _36_m9 _BumpScale
#define _36_m10 _GlossMapScale
#define _36_m11 _OcclusionStrength
#define _36_m12 _GlowColor
#define _36_m13 _GlowBase
#define _36_m14 _GlowRim
#define _36_m15 _RimPower
#define _36_m16 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _645;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _645 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m10) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m9.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m8.xyz;
    _263 = (_250 * _36_m8.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m10) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m16, _36_m16, _36_m16)) * _301) + 1.0f.xxx;
    _301 *= _36_m12.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m7.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m11 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m6.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m6.y;
    _279 = exp2(_279);
    _279 *= _36_m6.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m15;
    _9.x = exp2(_9.x);
    _139.x = (_36_m14 * _9.x) + _36_m13;
    _139 = (_301 * _139.xxx) + _54;
    float3 _626 = _139 + (-_36_m5.xyz);
    _9 = float4(_626.x, _626.y, _626.z, _9.w);
    _45 = vs_TEXCOORD5;
    _45 = clamp(_45, 0.0f, 1.0f);
    float3 _641 = (_45.xxx * _9.xyz) + _36_m5.xyz;
    _9 = float4(_641.x, _641.y, _641.z, _9.w);
    _645 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _645.w);
    _645.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._645 = _645;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m4[4];
float4x4 unity_WorldToObject;
static float4 _21_m5[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 _MainTex_ST;
void __unity_init()
{
    _21_m4[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m4[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m4[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m4[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m5[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m5[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m5[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m5[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHBr
#define _21_m1 unity_SHBg
#define _21_m2 unity_SHBb
#define _21_m3 unity_SHC
#define _21_m6 unity_WorldTransformParams
#define _21_m8 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _101;
static float4 vs_TEXCOORD1;
static float4 _121;
static float3 _174;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _121 : TANGENT;
    float3 _174 : NORMAL;
    float4 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD6 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float3 _210;
static float _269;
static float4 _283;
static float3 _288;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _11.xxxx) + _9;
    _9 = (_21_m4[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m4[3];
    float3 _60 = (_21_m4[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m7[1];
    _63 = (_21_m7[0] * _45.xxxx) + _63;
    _63 = (_21_m7[2] * _45.zzzz) + _63;
    gl_Position = (_21_m7[3] * _45.wwww) + _63;
    vs_TEXCOORD0 = (_101.xy * _21_m8.xy) + _21_m8.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _127 = _121.yyy * _21_m4[1].yzx;
    _45 = float4(_127.x, _127.y, _127.z, _45.w);
    float3 _138 = (_21_m4[0].yzx * _121.xxx) + _45.xyz;
    _45 = float4(_138.x, _138.y, _138.z, _45.w);
    float3 _149 = (_21_m4[2].yzx * _121.zzz) + _45.xyz;
    _45 = float4(_149.x, _149.y, _149.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _166 = _9.xxx * _45.xyz;
    _45 = float4(_166.x, _166.y, _166.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_174, _21_m5[0].xyz);
    _63.y = dot(_174, _21_m5[1].xyz);
    _63.z = dot(_174, _21_m5[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _210 = _45.xyz * _63.wxy;
    _210 = (_63.ywx * _45.yzx) + (-_210);
    _9.x = _121.w * _21_m6.w;
    _210 = _9.xxx * _210;
    vs_TEXCOORD1.y = _210.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _210.y;
    vs_TEXCOORD3.y = _210.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _269 = _63.y * _63.y;
    _269 = (_63.x * _63.x) + (-_269);
    _283 = _63.ywzx * _63;
    _288.x = dot(_21_m0, _283);
    _288.y = dot(_21_m1, _283);
    _288.z = dot(_21_m2, _283);
    vs_TEXCOORD4 = (_21_m3.xyz * _269.xxx) + _288;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _121 = stage_input._121;
    _174 = stage_input._174;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_SpecCube0_HDR
#define _36_m6 _LightColor0
#define _36_m7 _Color
#define _36_m8 _BumpScale
#define _36_m9 _GlossMapScale
#define _36_m10 _OcclusionStrength
#define _36_m11 _GlowColor
#define _36_m12 _GlowBase
#define _36_m13 _GlowRim
#define _36_m14 _RimPower
#define _36_m15 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float4 _615;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _615 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m9) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m8.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m7.xyz;
    _263 = (_250 * _36_m7.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m9) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m15, _36_m15, _36_m15)) * _301) + 1.0f.xxx;
    _301 *= _36_m11.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m6.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m10 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m5.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m5.y;
    _279 = exp2(_279);
    _279 *= _36_m5.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m14;
    _9.x = exp2(_9.x);
    _139.x = (_36_m13 * _9.x) + _36_m12;
    float3 _621 = (_301 * _139.xxx) + _54;
    _615 = float4(_621.x, _621.y, _621.z, _615.w);
    _615.w = 1.0f;
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
    stage_output._615 = _615;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m4[4];
float4x4 unity_WorldToObject;
static float4 _21_m5[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 _MainTex_ST;
void __unity_init()
{
    _21_m4[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m4[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m4[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m4[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m5[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m5[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m5[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m5[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHBr
#define _21_m1 unity_SHBg
#define _21_m2 unity_SHBb
#define _21_m3 unity_SHC
#define _21_m6 unity_WorldTransformParams
#define _21_m8 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _101;
static float4 vs_TEXCOORD1;
static float4 _121;
static float3 _174;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _121 : TANGENT;
    float3 _174 : NORMAL;
    float4 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD6 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float3 _210;
static float _269;
static float4 _283;
static float3 _288;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _11.xxxx) + _9;
    _9 = (_21_m4[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m4[3];
    float3 _60 = (_21_m4[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m7[1];
    _63 = (_21_m7[0] * _45.xxxx) + _63;
    _63 = (_21_m7[2] * _45.zzzz) + _63;
    gl_Position = (_21_m7[3] * _45.wwww) + _63;
    vs_TEXCOORD0 = (_101.xy * _21_m8.xy) + _21_m8.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _127 = _121.yyy * _21_m4[1].yzx;
    _45 = float4(_127.x, _127.y, _127.z, _45.w);
    float3 _138 = (_21_m4[0].yzx * _121.xxx) + _45.xyz;
    _45 = float4(_138.x, _138.y, _138.z, _45.w);
    float3 _149 = (_21_m4[2].yzx * _121.zzz) + _45.xyz;
    _45 = float4(_149.x, _149.y, _149.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _166 = _9.xxx * _45.xyz;
    _45 = float4(_166.x, _166.y, _166.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_174, _21_m5[0].xyz);
    _63.y = dot(_174, _21_m5[1].xyz);
    _63.z = dot(_174, _21_m5[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _210 = _45.xyz * _63.wxy;
    _210 = (_63.ywx * _45.yzx) + (-_210);
    _9.x = _121.w * _21_m6.w;
    _210 = _9.xxx * _210;
    vs_TEXCOORD1.y = _210.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _210.y;
    vs_TEXCOORD3.y = _210.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _269 = _63.y * _63.y;
    _269 = (_63.x * _63.x) + (-_269);
    _283 = _63.ywzx * _63;
    _288.x = dot(_21_m0, _283);
    _288.y = dot(_21_m1, _283);
    _288.z = dot(_21_m2, _283);
    vs_TEXCOORD4 = (_21_m3.xyz * _269.xxx) + _288;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _121 = stage_input._121;
    _174 = stage_input._174;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_SpecCube0_HDR
#define _22_m10 _LightColor0
#define _22_m11 _Color
#define _22_m12 _BumpScale
#define _22_m13 _GlossMapScale
#define _22_m14 _OcclusionStrength
#define _22_m15 _GlowColor
#define _22_m16 _GlowBase
#define _22_m17 _GlowRim
#define _22_m18 _RimPower
#define _22_m19 _GlowAlbedo


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __72_sampler;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float4 _798;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _798 : SV_Target0;
};

static float3 _9;
static float3 _80;
static float4 _99;
static float4 _105;
static float3 _143;
static float _154;
static float _247;
static float4 _261;
static float _274;
static float _283;
static float3 _292;
static float3 _298;
static float4 _315;
static float _394;
static float3 _419;
static float3 _425;
static float3 _432;
static float _448;
static float _455;
static float3 _464;
static float3 _469;
static float3 _499;
static float _546;
static float _609;
static float _621;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.www * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD1.www) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD3.www) + _9;
    _9 += _22_m5[3].xyz;
    float3 _58 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__72_sampler, _58.xy, _58.z);
    _80.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _80.x) + _22_m6.x;
    _99.x = (-_9.x) + 1.0f;
    _105.x = vs_TEXCOORD1.w;
    _105.y = vs_TEXCOORD2.w;
    _105.z = vs_TEXCOORD3.w;
    _80 = _105.xyz + (-_22_m7.xyz);
    float3 _132 = (-_105.xyz) + _22_m0;
    _105 = float4(_132.x, _132.y, _132.z, _105.w);
    _80.x = dot(_80, _80);
    _80.x = sqrt(_80.x);
    _143.x = _22_m8[0].z;
    _143.y = _22_m8[1].z;
    _143.z = _22_m8[2].z;
    _154 = dot(_105.xyz, _143);
    _80.x = (-_154) + _80.x;
    _80.x = (_22_m7.w * _80.x) + _154;
    _80.x = (_80.x * _22_m6.z) + _22_m6.w;
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _99.x = (_80.x * _99.x) + _9.x;
    float3 _201 = _99.xxx * _22_m10.xyz;
    _99 = float4(_201.x, _201.y, _201.z, _99.w);
    _9.x = dot(_105.xyz, _105.xyz);
    _9.x = rsqrt(_9.x);
    _80 = (_105.xyz * _9.xxx) + _22_m1.xyz;
    float3 _227 = _9.xxx * _105.xyz;
    _105 = float4(_227.x, _227.y, _227.z, _105.w);
    _9.x = dot(_80, _80);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _80;
    _247 = dot(_22_m1.xyz, _9);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 *= _247;
    _247 = max(_247, 0.100000001490116119384765625f);
    float2 _271 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _261 = float4(_271.x, _271.y, _261.z, _261.w);
    _274 = ((-_261.y) * _22_m13) + 1.0f;
    _283 = (_274 * _274) + 0.5f;
    _247 *= _283;
    _292 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _298 = (_292 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _312 = _298.xy * _22_m12.xx;
    _298 = float3(_312.x, _312.y, _298.z);
    _315.x = dot(vs_TEXCOORD1.xyz, _298);
    _315.y = dot(vs_TEXCOORD2.xyz, _298);
    _315.z = dot(vs_TEXCOORD3.xyz, _298);
    _283 = dot(_315.xyz, _315.xyz);
    _283 = rsqrt(_283);
    float3 _342 = _283.xxx * _315.xyz;
    _315 = float4(_342.x, _342.y, _342.z, _315.w);
    _9.x = dot(_315.xyz, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _274 * _274;
    _154 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _154) + 1.000010013580322265625f;
    float2 _381 = _9.xy * _9.xy;
    _9 = float3(_381.x, _9.y, _381.y);
    _9.x *= _247;
    _9.x *= 4.0f;
    _394 = _274 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _419 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _425 = _419 * _22_m11.xyz;
    _432 = (_419 * _22_m11.xyz) + (-0.039999999105930328369140625f).xxx;
    _432 = (_261.xxx * _432) + 0.039999999105930328369140625f.xxx;
    _448 = ((-_261.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _455 = (_261.y * _22_m13) + (-_448);
    _464 = _448.xxx * _425;
    _469 = (_425 * 2.0f.xxx) + (-1.0f).xxx;
    _469 = (float3(float3(_22_m19, _22_m19, _22_m19)) * _469) + 1.0f.xxx;
    _469 *= _22_m15.xyz;
    _448 = _455 + 1.0f;
    _448 = clamp(_448, 0.0f, 1.0f);
    _499 = (-_432) + _448.xxx;
    _9 = (_9.xxx * _432) + _464;
    _9 = _99.xyz * _9;
    _315.w = 1.0f;
    _99.x = dot(_22_m2, _315);
    _99.y = dot(_22_m3, _315);
    _99.z = dot(_22_m4, _315);
    float3 _537 = _99.xyz + vs_TEXCOORD4;
    _99 = float4(_537.x, _537.y, _537.z, _99.w);
    float3 _543 = max(_99.xyz, 0.0f.xxx);
    _99 = float4(_543.x, _543.y, _543.z, _99.w);
    _546 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _247 = _546 + (-1.0f);
    _247 = (_22_m14 * _247) + 1.0f;
    float3 _564 = _247.xxx * _99.xyz;
    _99 = float4(_564.x, _564.y, _564.z, _99.w);
    float3 _570 = _464 * _99.xyz;
    _99 = float4(_570.x, _570.y, _570.z, _99.w);
    _143.x = dot(_315.xyz, _22_m1.xyz);
    _143.x = clamp(_143.x, 0.0f, 1.0f);
    _9 = (_9 * _143.xxx) + _99.xyz;
    float2 _601 = ((-_274.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _99 = float4(_601.x, _601.y, _99.z, _99.w);
    _99.x *= _274;
    _609 = ((-_394) * _99.y) + 1.0f;
    _99.x *= 6.0f;
    _621 = dot(-_105.xyz, _315.xyz);
    _621 += _621;
    _464 = (_315.xyz * (-_621.xxx)) + (-_105.xyz);
    _274 = dot(_315.xyz, _105.xyz);
    _274 = clamp(_274, 0.0f, 1.0f);
    _621 = (-_274) + 1.0f;
    _621 *= _621;
    _621 *= _621;
    _432 = (_621.xxx * _499) + _432;
    _261 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _464, _99.x);
    _99.x = _261.w + (-1.0f);
    _99.x = (_22_m9.w * _99.x) + 1.0f;
    _99.x = log2(_99.x);
    _99.x *= _22_m9.y;
    _99.x = exp2(_99.x);
    _99.x *= _22_m9.x;
    float3 _708 = _261.xyz * _99.xxx;
    _99 = float4(_708.x, _99.y, _708.y, _708.z);
    float3 _715 = _247.xxx * _99.xzw;
    _99 = float4(_715.x, _99.y, _715.y, _715.z);
    float3 _722 = _99.xzw * _609.xxx;
    _99 = float4(_722.x, _722.y, _722.z, _99.w);
    _9 = (_99.xyz * _432) + _9;
    _143 = _105.yyy * vs_TEXCOORD2.xyz;
    float3 _742 = (vs_TEXCOORD1.xyz * _105.xxx) + _143;
    _105 = float4(_742.x, _742.y, _105.z, _742.z);
    float3 _752 = (vs_TEXCOORD3.xyz * _105.zzz) + _105.xyw;
    _105 = float4(_752.x, _752.y, _752.z, _105.w);
    _247 = dot(_105.xyz, _105.xyz);
    _247 = rsqrt(_247);
    float3 _766 = _247.xxx * _105.xyz;
    _105 = float4(_766.x, _766.y, _766.z, _105.w);
    _247 = dot(_105.xyz, _298);
    _247 = clamp(_247, 0.0f, 1.0f);
    _247 = (-_247) + 1.0f;
    _247 = log2(_247);
    _247 *= _22_m18;
    _247 = exp2(_247);
    _99.x = (_22_m17 * _247) + _22_m16;
    float3 _804 = (_469 * _99.xxx) + _9;
    _798 = float4(_804.x, _804.y, _804.z, _798.w);
    _798.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._798 = _798;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m9[4];
float4x4 unity_WorldToObject;
static float4 _23_m10[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 _MainTex_ST;
void __unity_init()
{
    _23_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 unity_4LightPosX0
#define _23_m1 unity_4LightPosY0
#define _23_m2 unity_4LightPosZ0
#define _23_m3 unity_4LightAtten0
#define _23_m4 unity_LightColor
#define _23_m5 unity_SHBr
#define _23_m6 unity_SHBg
#define _23_m7 unity_SHBb
#define _23_m8 unity_SHC
#define _23_m11 unity_WorldTransformParams
#define _23_m13 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _103;
static float4 _115;
static float4 vs_TEXCOORD1;
static float3 _179;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _115 : TANGENT;
    float3 _179 : NORMAL;
    float4 _103 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD6 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _147;
static float _199;
static float4 _212;
static float4 _291;
static float3 _389;
static float4 _406;
static float3 _411;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m9[1];
    _9 = (_23_m9[0] * _11.xxxx) + _9;
    _9 = (_23_m9[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m9[3];
    float3 _62 = (_23_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    gl_Position = (_23_m12[3] * _47.wwww) + _65;
    vs_TEXCOORD0 = (_103.xy * _23_m13.xy) + _23_m13.zw;
    float3 _121 = _115.yyy * _23_m9[1].yzx;
    _47 = float4(_121.x, _121.y, _121.z, _47.w);
    float3 _132 = (_23_m9[0].yzx * _115.xxx) + _47.xyz;
    _47 = float4(_132.x, _132.y, _132.z, _47.w);
    float3 _143 = (_23_m9[2].yzx * _115.zzz) + _47.xyz;
    _47 = float4(_143.x, _143.y, _143.z, _47.w);
    _147 = dot(_47.xyz, _47.xyz);
    _147 = rsqrt(_147);
    float3 _159 = _147.xxx * _47.xyz;
    _47 = float4(_159.x, _159.y, _159.z, _47.w);
    vs_TEXCOORD1.x = _47.z;
    _147 = _115.w * _23_m11.w;
    _65.x = dot(_179, _23_m10[0].xyz);
    _65.y = dot(_179, _23_m10[1].xyz);
    _65.z = dot(_179, _23_m10[2].xyz);
    _199 = dot(_65.xyz, _65.xyz);
    _199 = rsqrt(_199);
    _65 = _199.xxxx * _65.xyzz;
    float3 _217 = _47.xyz * _65.wxy;
    _212 = float4(_217.x, _217.y, _217.z, _212.w);
    float3 _228 = (_65.ywx * _47.yzx) + (-_212.xyz);
    _212 = float4(_228.x, _228.y, _228.z, _212.w);
    float3 _235 = _147.xxx * _212.xyz;
    _212 = float4(_235.x, _235.y, _235.z, _212.w);
    vs_TEXCOORD1.y = _212.x;
    vs_TEXCOORD1.w = _9.x;
    vs_TEXCOORD1.z = _65.x;
    vs_TEXCOORD2.x = _47.x;
    vs_TEXCOORD3.x = _47.y;
    vs_TEXCOORD2.y = _212.y;
    vs_TEXCOORD3.y = _212.z;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD2.z = _65.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD3.z = _65.w;
    _47 = (-_9.xxxx) + _23_m0;
    _212 = (-_9.yyyy) + _23_m1;
    _9 = (-_9.zzzz) + _23_m2;
    _291 = _65.yyyy * _212;
    _212 *= _212;
    _212 = (_47 * _47) + _212;
    _47 = (_47 * _65.xxxx) + _291;
    _47 = (_9 * _65.wwzw) + _47;
    _9 = (_9 * _9) + _212;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _212 = rsqrt(_9);
    _9 = (_9 * _23_m3) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _47 *= _212;
    _47 = max(_47, 0.0f.xxxx);
    _9 *= _47;
    float3 _352 = _9.yyy * _23_m4[1].xyz;
    _47 = float4(_352.x, _352.y, _352.z, _47.w);
    float3 _363 = (_23_m4[0].xyz * _9.xxx) + _47.xyz;
    _47 = float4(_363.x, _363.y, _363.z, _47.w);
    float3 _374 = (_23_m4[2].xyz * _9.zzz) + _47.xyz;
    _9 = float4(_374.x, _374.y, _374.z, _9.w);
    float3 _385 = (_23_m4[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_385.x, _385.y, _385.z, _9.w);
    _389.x = _65.y * _65.y;
    _389.x = (_65.x * _65.x) + (-_389.x);
    _406 = _65.ywzx * _65;
    _411.x = dot(_23_m5, _406);
    _411.y = dot(_23_m6, _406);
    _411.z = dot(_23_m7, _406);
    _389 = (_23_m8.xyz * _389.xxx) + _411;
    vs_TEXCOORD4 = _9.xyz + _389;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _103 = stage_input._103;
    _115 = stage_input._115;
    _179 = stage_input._179;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_SpecCube0_HDR
#define _36_m6 _LightColor0
#define _36_m7 _Color
#define _36_m8 _BumpScale
#define _36_m9 _GlossMapScale
#define _36_m10 _OcclusionStrength
#define _36_m11 _GlowColor
#define _36_m12 _GlowBase
#define _36_m13 _GlowRim
#define _36_m14 _RimPower
#define _36_m15 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float4 _615;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _615 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m9) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m8.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m7.xyz;
    _263 = (_250 * _36_m7.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m9) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m15, _36_m15, _36_m15)) * _301) + 1.0f.xxx;
    _301 *= _36_m11.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m6.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m10 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m5.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m5.y;
    _279 = exp2(_279);
    _279 *= _36_m5.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m14;
    _9.x = exp2(_9.x);
    _139.x = (_36_m13 * _9.x) + _36_m12;
    float3 _621 = (_301 * _139.xxx) + _54;
    _615 = float4(_621.x, _621.y, _621.z, _615.w);
    _615.w = 1.0f;
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
    stage_output._615 = _615;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m4[4];
float4x4 unity_WorldToObject;
static float4 _21_m5[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 _MainTex_ST;
void __unity_init()
{
    _21_m4[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m4[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m4[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m4[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m5[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m5[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m5[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m5[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHBr
#define _21_m1 unity_SHBg
#define _21_m2 unity_SHBb
#define _21_m3 unity_SHC
#define _21_m6 unity_WorldTransformParams
#define _21_m8 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _101;
static float4 vs_TEXCOORD1;
static float4 _121;
static float3 _174;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _121 : TANGENT;
    float3 _174 : NORMAL;
    float4 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD6 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _63;
static float3 _210;
static float _269;
static float4 _283;
static float3 _288;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _11.xxxx) + _9;
    _9 = (_21_m4[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m4[3];
    float3 _60 = (_21_m4[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    _63 = _45.yyyy * _21_m7[1];
    _63 = (_21_m7[0] * _45.xxxx) + _63;
    _63 = (_21_m7[2] * _45.zzzz) + _63;
    gl_Position = (_21_m7[3] * _45.wwww) + _63;
    vs_TEXCOORD0 = (_101.xy * _21_m8.xy) + _21_m8.zw;
    vs_TEXCOORD1.w = _9.x;
    float3 _127 = _121.yyy * _21_m4[1].yzx;
    _45 = float4(_127.x, _127.y, _127.z, _45.w);
    float3 _138 = (_21_m4[0].yzx * _121.xxx) + _45.xyz;
    _45 = float4(_138.x, _138.y, _138.z, _45.w);
    float3 _149 = (_21_m4[2].yzx * _121.zzz) + _45.xyz;
    _45 = float4(_149.x, _149.y, _149.z, _45.w);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    float3 _166 = _9.xxx * _45.xyz;
    _45 = float4(_166.x, _166.y, _166.z, _45.w);
    vs_TEXCOORD1.x = _45.z;
    _63.x = dot(_174, _21_m5[0].xyz);
    _63.y = dot(_174, _21_m5[1].xyz);
    _63.z = dot(_174, _21_m5[2].xyz);
    _9.x = dot(_63.xyz, _63.xyz);
    _9.x = rsqrt(_9.x);
    _63 = _9.xxxx * _63.xyzz;
    _210 = _45.xyz * _63.wxy;
    _210 = (_63.ywx * _45.yzx) + (-_210);
    _9.x = _121.w * _21_m6.w;
    _210 = _9.xxx * _210;
    vs_TEXCOORD1.y = _210.x;
    vs_TEXCOORD1.z = _63.x;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.w = _9.y;
    vs_TEXCOORD3.w = _9.z;
    vs_TEXCOORD2.y = _210.y;
    vs_TEXCOORD3.y = _210.z;
    vs_TEXCOORD2.z = _63.y;
    vs_TEXCOORD3.z = _63.w;
    _269 = _63.y * _63.y;
    _269 = (_63.x * _63.x) + (-_269);
    _283 = _63.ywzx * _63;
    _288.x = dot(_21_m0, _283);
    _288.y = dot(_21_m1, _283);
    _288.z = dot(_21_m2, _283);
    vs_TEXCOORD4 = (_21_m3.xyz * _269.xxx) + _288;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _121 = stage_input._121;
    _174 = stage_input._174;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
float _OcclusionStrength;
float4 _GlowColor;
float _GlowBase;
float _GlowRim;
float _RimPower;
float _GlowAlbedo;
#define _36_m0 _WorldSpaceCameraPos
#define _36_m1 _WorldSpaceLightPos0
#define _36_m2 unity_SHAr
#define _36_m3 unity_SHAg
#define _36_m4 unity_SHAb
#define _36_m5 unity_SpecCube0_HDR
#define _36_m6 _LightColor0
#define _36_m7 _Color
#define _36_m8 _BumpScale
#define _36_m9 _GlossMapScale
#define _36_m10 _OcclusionStrength
#define _36_m11 _GlowColor
#define _36_m12 _GlowBase
#define _36_m13 _GlowRim
#define _36_m14 _RimPower
#define _36_m15 _GlowAlbedo


Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OcclusionMap;
SamplerState sampler_OcclusionMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float4 _615;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _615 : SV_Target0;
};

static float4 _9;
static float _45;
static float3 _54;
static float4 _100;
static float _114;
static float _124;
static float3 _133;
static float3 _139;
static float4 _156;
static float _201;
static float _205;
static float _234;
static float3 _250;
static float3 _256;
static float3 _263;
static float _279;
static float3 _286;
static float3 _296;
static float3 _301;
static float3 _332;
static float3 _351;
static float _378;
static float3 _399;
static float _473;

void frag_inner()
{
    _9.x = vs_TEXCOORD1.w;
    _9.y = vs_TEXCOORD2.w;
    _9.z = vs_TEXCOORD3.w;
    float3 _42 = (-_9.xyz) + _36_m0;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    _54 = (_9.xyz * _45.xxx) + _36_m1.xyz;
    float3 _70 = _45.xxx * _9.xyz;
    _9 = float4(_70.x, _70.y, _70.z, _9.w);
    _45 = dot(_54, _54);
    _45 = max(_45, 0.001000000047497451305389404296875f);
    _45 = rsqrt(_45);
    _54 = _45.xxx * _54;
    _45 = dot(_36_m1.xyz, _54);
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 *= _45;
    _45 = max(_45, 0.100000001490116119384765625f);
    float2 _111 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _100 = float4(_111.x, _111.y, _100.z, _100.w);
    _114 = ((-_100.y) * _36_m9) + 1.0f;
    _124 = (_114 * _114) + 0.5f;
    _45 *= _124;
    _133 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _139 = (_133 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _153 = _139.xy * _36_m8.xx;
    _139 = float3(_153.x, _153.y, _139.z);
    _156.x = dot(vs_TEXCOORD1.xyz, _139);
    _156.y = dot(vs_TEXCOORD2.xyz, _139);
    _156.z = dot(vs_TEXCOORD3.xyz, _139);
    _124 = dot(_156.xyz, _156.xyz);
    _124 = rsqrt(_124);
    float3 _183 = _124.xxx * _156.xyz;
    _156 = float4(_183.x, _183.y, _183.z, _156.w);
    _54.x = dot(_156.xyz, _54);
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x *= _54.x;
    _201 = _114 * _114;
    _205 = (_201 * _201) + (-1.0f);
    _54.x = (_54.x * _205) + 1.000010013580322265625f;
    _54.x *= _54.x;
    _45 *= _54.x;
    _45 *= 4.0f;
    _54.x = _201 * _201;
    _234 = _114 * _201;
    _45 = _54.x / _45;
    _45 += (-9.9999997473787516355514526367188e-05f);
    _45 = max(_45, 0.0f);
    _45 = min(_45, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _256 = _250 * _36_m7.xyz;
    _263 = (_250 * _36_m7.xyz) + (-0.039999999105930328369140625f).xxx;
    _263 = (_100.xxx * _263) + 0.039999999105930328369140625f.xxx;
    _279 = ((-_100.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _286.x = (_100.y * _36_m9) + (-_279);
    _296 = _256 * _279.xxx;
    _301 = (_256 * 2.0f.xxx) + (-1.0f).xxx;
    _301 = (float3(float3(_36_m15, _36_m15, _36_m15)) * _301) + 1.0f.xxx;
    _301 *= _36_m11.xyz;
    _279 = _286.x + 1.0f;
    _279 = clamp(_279, 0.0f, 1.0f);
    _332 = (-_263) + _279.xxx;
    _54 = (_45.xxx * _263) + _296;
    _54 *= _36_m6.xyz;
    _156.w = 1.0f;
    _351.x = dot(_36_m2, _156);
    _351.y = dot(_36_m3, _156);
    _351.z = dot(_36_m4, _156);
    _351 += vs_TEXCOORD4;
    _351 = max(_351, 0.0f.xxx);
    _378 = _OcclusionMap.Sample(sampler_OcclusionMap, vs_TEXCOORD0).y;
    _45 = _378 + (-1.0f);
    _45 = (_36_m10 * _45) + 1.0f;
    _351 = _45.xxx * _351;
    _286 = _296 * _351;
    _399.x = dot(_156.xyz, _36_m1.xyz);
    _399.x = clamp(_399.x, 0.0f, 1.0f);
    _54 = (_54 * _399.xxx) + _286;
    float2 _427 = ((-_114.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _286 = float3(_427.x, _427.y, _286.z);
    _279 = _114 * _286.x;
    _234 = ((-_234) * _286.y) + 1.0f;
    _279 *= 6.0f;
    _286.x = dot(-_9.xyz, _156.xyz);
    _286.x += _286.x;
    _286 = (_156.xyz * (-_286.xxx)) + (-_9.xyz);
    _114 = dot(_156.xyz, _9.xyz);
    _114 = clamp(_114, 0.0f, 1.0f);
    _473 = (-_114) + 1.0f;
    _473 *= _473;
    _473 *= _473;
    _263 = (_473.xxx * _332) + _263;
    _100 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _286, _279);
    _279 = _100.w + (-1.0f);
    _279 = (_36_m5.w * _279) + 1.0f;
    _279 = log2(_279);
    _279 *= _36_m5.y;
    _279 = exp2(_279);
    _279 *= _36_m5.x;
    _286 = _100.xyz * _279.xxx;
    _286 = _45.xxx * _286;
    _286 = _234.xxx * _286;
    _54 = (_286 * _263) + _54;
    _399 = _9.yyy * vs_TEXCOORD2.xyz;
    float3 _547 = (vs_TEXCOORD1.xyz * _9.xxx) + _399;
    _9 = float4(_547.x, _547.y, _9.z, _547.z);
    float3 _557 = (vs_TEXCOORD3.xyz * _9.zzz) + _9.xyw;
    _9 = float4(_557.x, _557.y, _557.z, _9.w);
    _45 = dot(_9.xyz, _9.xyz);
    _45 = rsqrt(_45);
    float3 _571 = _45.xxx * _9.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _36_m14;
    _9.x = exp2(_9.x);
    _139.x = (_36_m13 * _9.x) + _36_m12;
    float3 _621 = (_301 * _139.xxx) + _54;
    _615 = float4(_621.x, _621.y, _621.z, _615.w);
    _615.w = 1.0f;
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
    stage_output._615 = _615;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
Cull Back
 Name "FORWARD"
  LOD 200
  Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" }
 ZWrite Off
   Blend One One
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile __ DIRECTIONAL
#pragma multi_compile __ DIRECTIONAL_COOKIE
#pragma multi_compile __ POINT
#pragma multi_compile __ POINT_COOKIE
#pragma multi_compile __ SPOT
#if defined(DIRECTIONAL) && defined(FOG_EXP)
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
float4 _MainTex_ST;
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
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _140;
static float3 _153;
static float4 _187;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _187 : TANGENT;
    float3 _153 : NORMAL;
    float4 _140 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _172;
static float3 _233;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD4 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m5.y;
    vs_TEXCOORD7 = exp2(-_9.x);
    vs_TEXCOORD0 = (_140.xy * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_153, _21_m2[0].xyz);
    _9.z = dot(_153, _21_m2[1].xyz);
    _9.x = dot(_153, _21_m2[2].xyz);
    _172 = dot(_9.xyz, _9.xyz);
    _172 = rsqrt(_172);
    float3 _184 = _172.xxx * _9.xyz;
    _9 = float4(_184.x, _184.y, _184.z, _9.w);
    float3 _193 = _187.yyy * _21_m1[1].yzx;
    _44 = float4(_193.x, _193.y, _193.z, _44.w);
    float3 _204 = (_21_m1[0].yzx * _187.xxx) + _44.xyz;
    _44 = float4(_204.x, _204.y, _204.z, _44.w);
    float3 _215 = (_21_m1[2].yzx * _187.zzz) + _44.xyz;
    _44 = float4(_215.x, _215.y, _215.z, _44.w);
    _172 = dot(_44.xyz, _44.xyz);
    _172 = rsqrt(_172);
    float3 _229 = _172.xxx * _44.xyz;
    _44 = float4(_229.x, _229.y, _229.z, _44.w);
    _233 = _9.xyz * _44.xyz;
    _233 = (_9.zxy * _44.yzx) + (-_233);
    _172 = _187.w * _21_m3.w;
    _233 = _172.xxx * _233;
    vs_TEXCOORD1.y = _233.x;
    vs_TEXCOORD1.x = _44.z;
    vs_TEXCOORD1.z = _9.y;
    vs_TEXCOORD2.x = _44.x;
    vs_TEXCOORD3.x = _44.y;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.y = _233.y;
    vs_TEXCOORD3.y = _233.z;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _153 = stage_input._153;
    _187 = stage_input._187;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
#define _34_m0 _WorldSpaceCameraPos
#define _34_m1 _WorldSpaceLightPos0
#define _34_m2 _LightColor0
#define _34_m3 _Color
#define _34_m4 _BumpScale
#define _34_m5 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _301;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _301 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _44;
static float _66;
static float3 _76;
static float3 _112;
static float2 _156;
static float3 _170;
static float _197;
static float3 _237;
static float _264;

void frag_inner()
{
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _41 = _22.xy * _34_m4.xx;
    _22 = float3(_41.x, _41.y, _22.z);
    _44.x = dot(vs_TEXCOORD1, _22);
    _44.y = dot(vs_TEXCOORD2, _22);
    _44.z = dot(vs_TEXCOORD3, _22);
    _66 = dot(_44, _44);
    _66 = rsqrt(_66);
    _44 = _66.xxx * _44;
    _76 = (-vs_TEXCOORD4) + _34_m0;
    _66 = dot(_76, _76);
    _66 = rsqrt(_66);
    _76 = (_76 * _66.xxx) + _34_m1.xyz;
    _66 = dot(_76, _76);
    _66 = max(_66, 0.001000000047497451305389404296875f);
    _66 = rsqrt(_66);
    _76 = _66.xxx * _76;
    _112.z = dot(_44, _76);
    _112.z = clamp(_112.z, 0.0f, 1.0f);
    _44.x = dot(_44, _34_m1.xyz);
    _44.x = clamp(_44.x, 0.0f, 1.0f);
    _112.x = dot(_34_m1.xyz, _76);
    _112.x = clamp(_112.x, 0.0f, 1.0f);
    float2 _147 = _112.xz * _112.xz;
    _112 = float3(_147.x, _147.y, _112.z);
    _112.x = max(_112.x, 0.100000001490116119384765625f);
    _156 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _66 = ((-_156.y) * _34_m5) + 1.0f;
    _170.x = _66 * _66;
    _66 = (_66 * _66) + 0.5f;
    _112.x = _66 * _112.x;
    _66 = (_170.x * _170.x) + (-1.0f);
    _170.x *= _170.x;
    _197 = (_112.y * _66) + 1.000010013580322265625f;
    _197 *= _197;
    _112.x = _197 * _112.x;
    _112.x *= 4.0f;
    _112.x = _170.x / _112.x;
    _112.x += (-9.9999997473787516355514526367188e-05f);
    _112.x = max(_112.x, 0.0f);
    _112.x = min(_112.x, 100.0f);
    _237 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_237 * _34_m3.xyz) + (-0.039999999105930328369140625f).xxx;
    _170 = _237 * _34_m3.xyz;
    _22 = (_156.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _264 = ((-_156.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _112 = _112.xxx * _22;
    _112 = (_170 * _264.xxx) + _112;
    _112 *= _34_m2.xyz;
    _44 = _44.xxx * _112;
    _66 = vs_TEXCOORD7;
    _66 = clamp(_66, 0.0f, 1.0f);
    _44 *= _66.xxx;
    _301 = float4(_44.x, _44.y, _44.z, _301.w);
    _301.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._301 = _301;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2)
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
float4 _MainTex_ST;
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
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _146;
static float3 _159;
static float4 _193;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _193 : TANGENT;
    float3 _159 : NORMAL;
    float4 _146 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _178;
static float3 _239;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD4 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m5.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD7 = exp2(_9.x);
    vs_TEXCOORD0 = (_146.xy * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_159, _21_m2[0].xyz);
    _9.z = dot(_159, _21_m2[1].xyz);
    _9.x = dot(_159, _21_m2[2].xyz);
    _178 = dot(_9.xyz, _9.xyz);
    _178 = rsqrt(_178);
    float3 _190 = _178.xxx * _9.xyz;
    _9 = float4(_190.x, _190.y, _190.z, _9.w);
    float3 _199 = _193.yyy * _21_m1[1].yzx;
    _44 = float4(_199.x, _199.y, _199.z, _44.w);
    float3 _210 = (_21_m1[0].yzx * _193.xxx) + _44.xyz;
    _44 = float4(_210.x, _210.y, _210.z, _44.w);
    float3 _221 = (_21_m1[2].yzx * _193.zzz) + _44.xyz;
    _44 = float4(_221.x, _221.y, _221.z, _44.w);
    _178 = dot(_44.xyz, _44.xyz);
    _178 = rsqrt(_178);
    float3 _235 = _178.xxx * _44.xyz;
    _44 = float4(_235.x, _235.y, _235.z, _44.w);
    _239 = _9.xyz * _44.xyz;
    _239 = (_9.zxy * _44.yzx) + (-_239);
    _178 = _193.w * _21_m3.w;
    _239 = _178.xxx * _239;
    vs_TEXCOORD1.y = _239.x;
    vs_TEXCOORD1.x = _44.z;
    vs_TEXCOORD1.z = _9.y;
    vs_TEXCOORD2.x = _44.x;
    vs_TEXCOORD3.x = _44.y;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.y = _239.y;
    vs_TEXCOORD3.y = _239.z;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    _159 = stage_input._159;
    _193 = stage_input._193;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
#define _34_m0 _WorldSpaceCameraPos
#define _34_m1 _WorldSpaceLightPos0
#define _34_m2 _LightColor0
#define _34_m3 _Color
#define _34_m4 _BumpScale
#define _34_m5 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _301;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _301 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _44;
static float _66;
static float3 _76;
static float3 _112;
static float2 _156;
static float3 _170;
static float _197;
static float3 _237;
static float _264;

void frag_inner()
{
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _41 = _22.xy * _34_m4.xx;
    _22 = float3(_41.x, _41.y, _22.z);
    _44.x = dot(vs_TEXCOORD1, _22);
    _44.y = dot(vs_TEXCOORD2, _22);
    _44.z = dot(vs_TEXCOORD3, _22);
    _66 = dot(_44, _44);
    _66 = rsqrt(_66);
    _44 = _66.xxx * _44;
    _76 = (-vs_TEXCOORD4) + _34_m0;
    _66 = dot(_76, _76);
    _66 = rsqrt(_66);
    _76 = (_76 * _66.xxx) + _34_m1.xyz;
    _66 = dot(_76, _76);
    _66 = max(_66, 0.001000000047497451305389404296875f);
    _66 = rsqrt(_66);
    _76 = _66.xxx * _76;
    _112.z = dot(_44, _76);
    _112.z = clamp(_112.z, 0.0f, 1.0f);
    _44.x = dot(_44, _34_m1.xyz);
    _44.x = clamp(_44.x, 0.0f, 1.0f);
    _112.x = dot(_34_m1.xyz, _76);
    _112.x = clamp(_112.x, 0.0f, 1.0f);
    float2 _147 = _112.xz * _112.xz;
    _112 = float3(_147.x, _147.y, _112.z);
    _112.x = max(_112.x, 0.100000001490116119384765625f);
    _156 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _66 = ((-_156.y) * _34_m5) + 1.0f;
    _170.x = _66 * _66;
    _66 = (_66 * _66) + 0.5f;
    _112.x = _66 * _112.x;
    _66 = (_170.x * _170.x) + (-1.0f);
    _170.x *= _170.x;
    _197 = (_112.y * _66) + 1.000010013580322265625f;
    _197 *= _197;
    _112.x = _197 * _112.x;
    _112.x *= 4.0f;
    _112.x = _170.x / _112.x;
    _112.x += (-9.9999997473787516355514526367188e-05f);
    _112.x = max(_112.x, 0.0f);
    _112.x = min(_112.x, 100.0f);
    _237 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_237 * _34_m3.xyz) + (-0.039999999105930328369140625f).xxx;
    _170 = _237 * _34_m3.xyz;
    _22 = (_156.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _264 = ((-_156.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _112 = _112.xxx * _22;
    _112 = (_170 * _264.xxx) + _112;
    _112 *= _34_m2.xyz;
    _44 = _44.xxx * _112;
    _66 = vs_TEXCOORD7;
    _66 = clamp(_66, 0.0f, 1.0f);
    _44 *= _66.xxx;
    _301 = float4(_44.x, _44.y, _44.z, _301.w);
    _301.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._301 = _301;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR)
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
float4 _MainTex_ST;
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
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _139;
static float3 _152;
static float4 _186;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _186 : TANGENT;
    float3 _152 : NORMAL;
    float4 _139 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _171;
static float3 _232;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD4 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD7 = (_9.x * _21_m5.z) + _21_m5.w;
    vs_TEXCOORD0 = (_139.xy * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_152, _21_m2[0].xyz);
    _9.z = dot(_152, _21_m2[1].xyz);
    _9.x = dot(_152, _21_m2[2].xyz);
    _171 = dot(_9.xyz, _9.xyz);
    _171 = rsqrt(_171);
    float3 _183 = _171.xxx * _9.xyz;
    _9 = float4(_183.x, _183.y, _183.z, _9.w);
    float3 _192 = _186.yyy * _21_m1[1].yzx;
    _44 = float4(_192.x, _192.y, _192.z, _44.w);
    float3 _203 = (_21_m1[0].yzx * _186.xxx) + _44.xyz;
    _44 = float4(_203.x, _203.y, _203.z, _44.w);
    float3 _214 = (_21_m1[2].yzx * _186.zzz) + _44.xyz;
    _44 = float4(_214.x, _214.y, _214.z, _44.w);
    _171 = dot(_44.xyz, _44.xyz);
    _171 = rsqrt(_171);
    float3 _228 = _171.xxx * _44.xyz;
    _44 = float4(_228.x, _228.y, _228.z, _44.w);
    _232 = _9.xyz * _44.xyz;
    _232 = (_9.zxy * _44.yzx) + (-_232);
    _171 = _186.w * _21_m3.w;
    _232 = _171.xxx * _232;
    vs_TEXCOORD1.y = _232.x;
    vs_TEXCOORD1.x = _44.z;
    vs_TEXCOORD1.z = _9.y;
    vs_TEXCOORD2.x = _44.x;
    vs_TEXCOORD3.x = _44.y;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.y = _232.y;
    vs_TEXCOORD3.y = _232.z;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _152 = stage_input._152;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
#define _34_m0 _WorldSpaceCameraPos
#define _34_m1 _WorldSpaceLightPos0
#define _34_m2 _LightColor0
#define _34_m3 _Color
#define _34_m4 _BumpScale
#define _34_m5 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _301;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _301 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _44;
static float _66;
static float3 _76;
static float3 _112;
static float2 _156;
static float3 _170;
static float _197;
static float3 _237;
static float _264;

void frag_inner()
{
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _41 = _22.xy * _34_m4.xx;
    _22 = float3(_41.x, _41.y, _22.z);
    _44.x = dot(vs_TEXCOORD1, _22);
    _44.y = dot(vs_TEXCOORD2, _22);
    _44.z = dot(vs_TEXCOORD3, _22);
    _66 = dot(_44, _44);
    _66 = rsqrt(_66);
    _44 = _66.xxx * _44;
    _76 = (-vs_TEXCOORD4) + _34_m0;
    _66 = dot(_76, _76);
    _66 = rsqrt(_66);
    _76 = (_76 * _66.xxx) + _34_m1.xyz;
    _66 = dot(_76, _76);
    _66 = max(_66, 0.001000000047497451305389404296875f);
    _66 = rsqrt(_66);
    _76 = _66.xxx * _76;
    _112.z = dot(_44, _76);
    _112.z = clamp(_112.z, 0.0f, 1.0f);
    _44.x = dot(_44, _34_m1.xyz);
    _44.x = clamp(_44.x, 0.0f, 1.0f);
    _112.x = dot(_34_m1.xyz, _76);
    _112.x = clamp(_112.x, 0.0f, 1.0f);
    float2 _147 = _112.xz * _112.xz;
    _112 = float3(_147.x, _147.y, _112.z);
    _112.x = max(_112.x, 0.100000001490116119384765625f);
    _156 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _66 = ((-_156.y) * _34_m5) + 1.0f;
    _170.x = _66 * _66;
    _66 = (_66 * _66) + 0.5f;
    _112.x = _66 * _112.x;
    _66 = (_170.x * _170.x) + (-1.0f);
    _170.x *= _170.x;
    _197 = (_112.y * _66) + 1.000010013580322265625f;
    _197 *= _197;
    _112.x = _197 * _112.x;
    _112.x *= 4.0f;
    _112.x = _170.x / _112.x;
    _112.x += (-9.9999997473787516355514526367188e-05f);
    _112.x = max(_112.x, 0.0f);
    _112.x = min(_112.x, 100.0f);
    _237 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_237 * _34_m3.xyz) + (-0.039999999105930328369140625f).xxx;
    _170 = _237 * _34_m3.xyz;
    _22 = (_156.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _264 = ((-_156.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _112 = _112.xxx * _22;
    _112 = (_170 * _264.xxx) + _112;
    _112 *= _34_m2.xyz;
    _44 = _44.xxx * _112;
    _66 = vs_TEXCOORD7;
    _66 = clamp(_66, 0.0f, 1.0f);
    _44 *= _66.xxx;
    _301 = float4(_44.x, _44.y, _44.z, _301.w);
    _301.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._301 = _301;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(FOG_EXP)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float3 vs_TEXCOORD4;
static float2 vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _190;
static float3 _203;
static float4 _237;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _237 : TANGENT;
    float3 _203 : NORMAL;
    float4 _190 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD7 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float2 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _222;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m5.y;
    vs_TEXCOORD7 = exp2(-_45.x);
    _45 = (_22_m1[3] * _11.wwww) + _9;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    float2 _153 = _45.yy * _22_m6[1].xy;
    _9 = float4(_153.x, _153.y, _9.z, _9.w);
    float2 _164 = (_22_m6[0].xy * _45.xx) + _9.xy;
    _9 = float4(_164.x, _164.y, _9.z, _9.w);
    float2 _175 = (_22_m6[2].xy * _45.zz) + _9.xy;
    _9 = float4(_175.x, _175.y, _9.z, _9.w);
    vs_TEXCOORD5 = (_22_m6[3].xy * _45.ww) + _9.xy;
    vs_TEXCOORD0 = (_190.xy * _22_m7.xy) + _22_m7.zw;
    _9.y = dot(_203, _22_m2[0].xyz);
    _9.z = dot(_203, _22_m2[1].xyz);
    _9.x = dot(_203, _22_m2[2].xyz);
    _222 = dot(_9.xyz, _9.xyz);
    _222 = rsqrt(_222);
    float3 _234 = _222.xxx * _9.xyz;
    _9 = float4(_234.x, _234.y, _234.z, _9.w);
    float3 _243 = _237.yyy * _22_m1[1].yzx;
    _45 = float4(_243.x, _243.y, _243.z, _45.w);
    float3 _254 = (_22_m1[0].yzx * _237.xxx) + _45.xyz;
    _45 = float4(_254.x, _254.y, _254.z, _45.w);
    float3 _265 = (_22_m1[2].yzx * _237.zzz) + _45.xyz;
    _45 = float4(_265.x, _265.y, _265.z, _45.w);
    _222 = dot(_45.xyz, _45.xyz);
    _222 = rsqrt(_222);
    float3 _279 = _222.xxx * _45.xyz;
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    float3 _286 = _9.xyz * _45.xyz;
    _51 = float4(_286.x, _286.y, _286.z, _51.w);
    float3 _297 = (_9.zxy * _45.yzx) + (-_51.xyz);
    _51 = float4(_297.x, _297.y, _297.z, _51.w);
    _222 = _237.w * _22_m3.w;
    float3 _311 = _222.xxx * _51.xyz;
    _51 = float4(_311.x, _311.y, _311.z, _51.w);
    vs_TEXCOORD1.y = _51.x;
    vs_TEXCOORD1.x = _45.z;
    vs_TEXCOORD1.z = _9.y;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.y = _51.y;
    vs_TEXCOORD3.y = _51.z;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _190 = stage_input._190;
    _203 = stage_input._203;
    _237 = stage_input._237;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _354;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD7 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _354 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _114;
static float2 _158;
static float3 _172;
static float _199;
static float3 _239;
static float _266;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _78 = (_78 * _68.xxx) + _37_m1.xyz;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _114.z = dot(_47, _78);
    _114.z = clamp(_114.z, 0.0f, 1.0f);
    _47.x = dot(_47, _37_m1.xyz);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _114.x = dot(_37_m1.xyz, _78);
    _114.x = clamp(_114.x, 0.0f, 1.0f);
    float2 _149 = _114.xz * _114.xz;
    _114 = float3(_149.x, _149.y, _114.z);
    _114.x = max(_114.x, 0.100000001490116119384765625f);
    _158 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_158.y) * _37_m6) + 1.0f;
    _172.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _114.x = _68 * _114.x;
    _68 = (_172.x * _172.x) + (-1.0f);
    _172.x *= _172.x;
    _199 = (_114.y * _68) + 1.000010013580322265625f;
    _199 *= _199;
    _114.x = _199 * _114.x;
    _114.x *= 4.0f;
    _114.x = _172.x / _114.x;
    _114.x += (-9.9999997473787516355514526367188e-05f);
    _114.x = max(_114.x, 0.0f);
    _114.x = min(_114.x, 100.0f);
    _239 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_239 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _172 = _239 * _37_m4.xyz;
    _22 = (_158.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _266 = ((-_158.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _114 = _114.xxx * _22;
    _114 = (_172 * _266.xxx) + _114;
    float2 _289 = vs_TEXCOORD4.yy * _37_m3[1].xy;
    _78 = float3(_289.x, _289.y, _78.z);
    float2 _300 = (_37_m3[0].xy * vs_TEXCOORD4.xx) + _78.xy;
    _78 = float3(_300.x, _300.y, _78.z);
    float2 _312 = (_37_m3[2].xy * vs_TEXCOORD4.zz) + _78.xy;
    _78 = float3(_312.x, _312.y, _78.z);
    float2 _320 = _78.xy + _37_m3[3].xy;
    _78 = float3(_320.x, _320.y, _78.z);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xy).w;
    _22 = _78.xxx * _37_m2.xyz;
    _114 *= _22;
    _47 = _47.xxx * _114;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _354 = float4(_47.x, _47.y, _47.z, _354.w);
    _354.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._354 = _354;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(FOG_EXP2)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float3 vs_TEXCOORD4;
static float2 vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _196;
static float3 _209;
static float4 _243;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _243 : TANGENT;
    float3 _209 : NORMAL;
    float4 _196 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD7 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float2 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _228;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m5.x;
    _45.x *= (-_45.x);
    vs_TEXCOORD7 = exp2(_45.x);
    _45 = (_22_m1[3] * _11.wwww) + _9;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    float2 _159 = _45.yy * _22_m6[1].xy;
    _9 = float4(_159.x, _159.y, _9.z, _9.w);
    float2 _170 = (_22_m6[0].xy * _45.xx) + _9.xy;
    _9 = float4(_170.x, _170.y, _9.z, _9.w);
    float2 _181 = (_22_m6[2].xy * _45.zz) + _9.xy;
    _9 = float4(_181.x, _181.y, _9.z, _9.w);
    vs_TEXCOORD5 = (_22_m6[3].xy * _45.ww) + _9.xy;
    vs_TEXCOORD0 = (_196.xy * _22_m7.xy) + _22_m7.zw;
    _9.y = dot(_209, _22_m2[0].xyz);
    _9.z = dot(_209, _22_m2[1].xyz);
    _9.x = dot(_209, _22_m2[2].xyz);
    _228 = dot(_9.xyz, _9.xyz);
    _228 = rsqrt(_228);
    float3 _240 = _228.xxx * _9.xyz;
    _9 = float4(_240.x, _240.y, _240.z, _9.w);
    float3 _249 = _243.yyy * _22_m1[1].yzx;
    _45 = float4(_249.x, _249.y, _249.z, _45.w);
    float3 _260 = (_22_m1[0].yzx * _243.xxx) + _45.xyz;
    _45 = float4(_260.x, _260.y, _260.z, _45.w);
    float3 _271 = (_22_m1[2].yzx * _243.zzz) + _45.xyz;
    _45 = float4(_271.x, _271.y, _271.z, _45.w);
    _228 = dot(_45.xyz, _45.xyz);
    _228 = rsqrt(_228);
    float3 _285 = _228.xxx * _45.xyz;
    _45 = float4(_285.x, _285.y, _285.z, _45.w);
    float3 _292 = _9.xyz * _45.xyz;
    _51 = float4(_292.x, _292.y, _292.z, _51.w);
    float3 _303 = (_9.zxy * _45.yzx) + (-_51.xyz);
    _51 = float4(_303.x, _303.y, _303.z, _51.w);
    _228 = _243.w * _22_m3.w;
    float3 _317 = _228.xxx * _51.xyz;
    _51 = float4(_317.x, _317.y, _317.z, _51.w);
    vs_TEXCOORD1.y = _51.x;
    vs_TEXCOORD1.x = _45.z;
    vs_TEXCOORD1.z = _9.y;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.y = _51.y;
    vs_TEXCOORD3.y = _51.z;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _196 = stage_input._196;
    _209 = stage_input._209;
    _243 = stage_input._243;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _354;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD7 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _354 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _114;
static float2 _158;
static float3 _172;
static float _199;
static float3 _239;
static float _266;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _78 = (_78 * _68.xxx) + _37_m1.xyz;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _114.z = dot(_47, _78);
    _114.z = clamp(_114.z, 0.0f, 1.0f);
    _47.x = dot(_47, _37_m1.xyz);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _114.x = dot(_37_m1.xyz, _78);
    _114.x = clamp(_114.x, 0.0f, 1.0f);
    float2 _149 = _114.xz * _114.xz;
    _114 = float3(_149.x, _149.y, _114.z);
    _114.x = max(_114.x, 0.100000001490116119384765625f);
    _158 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_158.y) * _37_m6) + 1.0f;
    _172.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _114.x = _68 * _114.x;
    _68 = (_172.x * _172.x) + (-1.0f);
    _172.x *= _172.x;
    _199 = (_114.y * _68) + 1.000010013580322265625f;
    _199 *= _199;
    _114.x = _199 * _114.x;
    _114.x *= 4.0f;
    _114.x = _172.x / _114.x;
    _114.x += (-9.9999997473787516355514526367188e-05f);
    _114.x = max(_114.x, 0.0f);
    _114.x = min(_114.x, 100.0f);
    _239 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_239 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _172 = _239 * _37_m4.xyz;
    _22 = (_158.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _266 = ((-_158.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _114 = _114.xxx * _22;
    _114 = (_172 * _266.xxx) + _114;
    float2 _289 = vs_TEXCOORD4.yy * _37_m3[1].xy;
    _78 = float3(_289.x, _289.y, _78.z);
    float2 _300 = (_37_m3[0].xy * vs_TEXCOORD4.xx) + _78.xy;
    _78 = float3(_300.x, _300.y, _78.z);
    float2 _312 = (_37_m3[2].xy * vs_TEXCOORD4.zz) + _78.xy;
    _78 = float3(_312.x, _312.y, _78.z);
    float2 _320 = _78.xy + _37_m3[3].xy;
    _78 = float3(_320.x, _320.y, _78.z);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xy).w;
    _22 = _78.xxx * _37_m2.xyz;
    _114 *= _22;
    _47 = _47.xxx * _114;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _354 = float4(_47.x, _47.y, _47.z, _354.w);
    _354.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._354 = _354;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(FOG_LINEAR)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float3 vs_TEXCOORD4;
static float2 vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _189;
static float3 _202;
static float4 _236;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _236 : TANGENT;
    float3 _202 : NORMAL;
    float4 _189 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD7 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float2 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _221;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    vs_TEXCOORD7 = (_45.x * _22_m5.z) + _22_m5.w;
    _45 = (_22_m1[3] * _11.wwww) + _9;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    float2 _152 = _45.yy * _22_m6[1].xy;
    _9 = float4(_152.x, _152.y, _9.z, _9.w);
    float2 _163 = (_22_m6[0].xy * _45.xx) + _9.xy;
    _9 = float4(_163.x, _163.y, _9.z, _9.w);
    float2 _174 = (_22_m6[2].xy * _45.zz) + _9.xy;
    _9 = float4(_174.x, _174.y, _9.z, _9.w);
    vs_TEXCOORD5 = (_22_m6[3].xy * _45.ww) + _9.xy;
    vs_TEXCOORD0 = (_189.xy * _22_m7.xy) + _22_m7.zw;
    _9.y = dot(_202, _22_m2[0].xyz);
    _9.z = dot(_202, _22_m2[1].xyz);
    _9.x = dot(_202, _22_m2[2].xyz);
    _221 = dot(_9.xyz, _9.xyz);
    _221 = rsqrt(_221);
    float3 _233 = _221.xxx * _9.xyz;
    _9 = float4(_233.x, _233.y, _233.z, _9.w);
    float3 _242 = _236.yyy * _22_m1[1].yzx;
    _45 = float4(_242.x, _242.y, _242.z, _45.w);
    float3 _253 = (_22_m1[0].yzx * _236.xxx) + _45.xyz;
    _45 = float4(_253.x, _253.y, _253.z, _45.w);
    float3 _264 = (_22_m1[2].yzx * _236.zzz) + _45.xyz;
    _45 = float4(_264.x, _264.y, _264.z, _45.w);
    _221 = dot(_45.xyz, _45.xyz);
    _221 = rsqrt(_221);
    float3 _278 = _221.xxx * _45.xyz;
    _45 = float4(_278.x, _278.y, _278.z, _45.w);
    float3 _285 = _9.xyz * _45.xyz;
    _51 = float4(_285.x, _285.y, _285.z, _51.w);
    float3 _296 = (_9.zxy * _45.yzx) + (-_51.xyz);
    _51 = float4(_296.x, _296.y, _296.z, _51.w);
    _221 = _236.w * _22_m3.w;
    float3 _309 = _221.xxx * _51.xyz;
    _51 = float4(_309.x, _309.y, _309.z, _51.w);
    vs_TEXCOORD1.y = _51.x;
    vs_TEXCOORD1.x = _45.z;
    vs_TEXCOORD1.z = _9.y;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.y = _51.y;
    vs_TEXCOORD3.y = _51.z;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _189 = stage_input._189;
    _202 = stage_input._202;
    _236 = stage_input._236;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _354;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD7 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _354 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _114;
static float2 _158;
static float3 _172;
static float _199;
static float3 _239;
static float _266;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _78 = (_78 * _68.xxx) + _37_m1.xyz;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _114.z = dot(_47, _78);
    _114.z = clamp(_114.z, 0.0f, 1.0f);
    _47.x = dot(_47, _37_m1.xyz);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _114.x = dot(_37_m1.xyz, _78);
    _114.x = clamp(_114.x, 0.0f, 1.0f);
    float2 _149 = _114.xz * _114.xz;
    _114 = float3(_149.x, _149.y, _114.z);
    _114.x = max(_114.x, 0.100000001490116119384765625f);
    _158 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_158.y) * _37_m6) + 1.0f;
    _172.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _114.x = _68 * _114.x;
    _68 = (_172.x * _172.x) + (-1.0f);
    _172.x *= _172.x;
    _199 = (_114.y * _68) + 1.000010013580322265625f;
    _199 *= _199;
    _114.x = _199 * _114.x;
    _114.x *= 4.0f;
    _114.x = _172.x / _114.x;
    _114.x += (-9.9999997473787516355514526367188e-05f);
    _114.x = max(_114.x, 0.0f);
    _114.x = min(_114.x, 100.0f);
    _239 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_239 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _172 = _239 * _37_m4.xyz;
    _22 = (_158.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _266 = ((-_158.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _114 = _114.xxx * _22;
    _114 = (_172 * _266.xxx) + _114;
    float2 _289 = vs_TEXCOORD4.yy * _37_m3[1].xy;
    _78 = float3(_289.x, _289.y, _78.z);
    float2 _300 = (_37_m3[0].xy * vs_TEXCOORD4.xx) + _78.xy;
    _78 = float3(_300.x, _300.y, _78.z);
    float2 _312 = (_37_m3[2].xy * vs_TEXCOORD4.zz) + _78.xy;
    _78 = float3(_312.x, _312.y, _78.z);
    float2 _320 = _78.xy + _37_m3[3].xy;
    _78 = float3(_320.x, _320.y, _78.z);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xy).w;
    _22 = _78.xxx * _37_m2.xyz;
    _114 *= _22;
    _47 = _47.xxx * _114;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _354 = float4(_47.x, _47.y, _47.z, _354.w);
    _354.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._354 = _354;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(POINT)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _130;
static float3 _144;
static float4 _178;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _178 : TANGENT;
    float3 _144 : NORMAL;
    float4 _130 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _163;
static float3 _224;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m5.y;
    vs_TEXCOORD7 = exp2(-_45.x);
    vs_TEXCOORD0 = (_130.xy * _22_m7.xy) + _22_m7.zw;
    _45.y = dot(_144, _22_m2[0].xyz);
    _45.z = dot(_144, _22_m2[1].xyz);
    _45.x = dot(_144, _22_m2[2].xyz);
    _163 = dot(_45.xyz, _45.xyz);
    _163 = rsqrt(_163);
    float3 _175 = _163.xxx * _45.xyz;
    _45 = float4(_175.x, _175.y, _175.z, _45.w);
    float3 _184 = _178.yyy * _22_m1[1].yzx;
    _51 = float4(_184.x, _184.y, _184.z, _51.w);
    float3 _195 = (_22_m1[0].yzx * _178.xxx) + _51.xyz;
    _51 = float4(_195.x, _195.y, _195.z, _51.w);
    float3 _206 = (_22_m1[2].yzx * _178.zzz) + _51.xyz;
    _51 = float4(_206.x, _206.y, _206.z, _51.w);
    _163 = dot(_51.xyz, _51.xyz);
    _163 = rsqrt(_163);
    float3 _220 = _163.xxx * _51.xyz;
    _51 = float4(_220.x, _220.y, _220.z, _51.w);
    _224 = _45.xyz * _51.xyz;
    _224 = (_45.zxy * _51.yzx) + (-_224);
    _163 = _178.w * _22_m3.w;
    _224 = _163.xxx * _224;
    vs_TEXCOORD1.y = _224.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _224.y;
    vs_TEXCOORD3.y = _224.z;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    float3 _303 = _9.yyy * _22_m6[1].xyz;
    _45 = float4(_303.x, _303.y, _303.z, _45.w);
    float3 _314 = (_22_m6[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_314.x, _314.y, _314.z, _45.w);
    float3 _325 = (_22_m6[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_325.x, _325.y, _325.z, _9.w);
    vs_TEXCOORD5 = (_22_m6[3].xyz * _9.www) + _9.xyz;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _144 = stage_input._144;
    _178 = stage_input._178;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _357;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _357 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _78 = vs_TEXCOORD4.yyy * _37_m3[1].xyz;
    _78 = (_37_m3[0].xyz * vs_TEXCOORD4.xxx) + _78;
    _78 = (_37_m3[2].xyz * vs_TEXCOORD4.zzz) + _78;
    _78 += _37_m3[3].xyz;
    _78.x = dot(_78, _78);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xx).x;
    _22 = _78.xxx * _37_m2.xyz;
    _129 *= _22;
    _47 = _47.xxx * _129;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _357 = float4(_47.x, _47.y, _47.z, _357.w);
    _357.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._357 = _357;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(POINT_COOKIE)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _130;
static float3 _144;
static float4 _178;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _178 : TANGENT;
    float3 _144 : NORMAL;
    float4 _130 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _163;
static float3 _224;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m5.y;
    vs_TEXCOORD7 = exp2(-_45.x);
    vs_TEXCOORD0 = (_130.xy * _22_m7.xy) + _22_m7.zw;
    _45.y = dot(_144, _22_m2[0].xyz);
    _45.z = dot(_144, _22_m2[1].xyz);
    _45.x = dot(_144, _22_m2[2].xyz);
    _163 = dot(_45.xyz, _45.xyz);
    _163 = rsqrt(_163);
    float3 _175 = _163.xxx * _45.xyz;
    _45 = float4(_175.x, _175.y, _175.z, _45.w);
    float3 _184 = _178.yyy * _22_m1[1].yzx;
    _51 = float4(_184.x, _184.y, _184.z, _51.w);
    float3 _195 = (_22_m1[0].yzx * _178.xxx) + _51.xyz;
    _51 = float4(_195.x, _195.y, _195.z, _51.w);
    float3 _206 = (_22_m1[2].yzx * _178.zzz) + _51.xyz;
    _51 = float4(_206.x, _206.y, _206.z, _51.w);
    _163 = dot(_51.xyz, _51.xyz);
    _163 = rsqrt(_163);
    float3 _220 = _163.xxx * _51.xyz;
    _51 = float4(_220.x, _220.y, _220.z, _51.w);
    _224 = _45.xyz * _51.xyz;
    _224 = (_45.zxy * _51.yzx) + (-_224);
    _163 = _178.w * _22_m3.w;
    _224 = _163.xxx * _224;
    vs_TEXCOORD1.y = _224.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _224.y;
    vs_TEXCOORD3.y = _224.z;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    float3 _303 = _9.yyy * _22_m6[1].xyz;
    _45 = float4(_303.x, _303.y, _303.z, _45.w);
    float3 _314 = (_22_m6[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_314.x, _314.y, _314.z, _45.w);
    float3 _325 = (_22_m6[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_325.x, _325.y, _325.z, _9.w);
    vs_TEXCOORD5 = (_22_m6[3].xyz * _9.www) + _9.xyz;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _144 = stage_input._144;
    _178 = stage_input._178;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _372;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _372 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _78 = vs_TEXCOORD4.yyy * _37_m3[1].xyz;
    _78 = (_37_m3[0].xyz * vs_TEXCOORD4.xxx) + _78;
    _78 = (_37_m3[2].xyz * vs_TEXCOORD4.zzz) + _78;
    _78 += _37_m3[3].xyz;
    _101 = dot(_78, _78);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78).w;
    _183.x = _LightTextureB0.Sample(sampler_LightTextureB0, _101.xx).x;
    _78.x *= _183.x;
    _22 = _78.xxx * _37_m2.xyz;
    _129 *= _22;
    _47 = _47.xxx * _129;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _372 = float4(_47.x, _47.y, _47.z, _372.w);
    _372.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._372 = _372;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(SPOT)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _130;
static float3 _144;
static float4 _178;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _178 : TANGENT;
    float3 _144 : NORMAL;
    float4 _130 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _163;
static float3 _224;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m5.y;
    vs_TEXCOORD7 = exp2(-_45.x);
    vs_TEXCOORD0 = (_130.xy * _22_m7.xy) + _22_m7.zw;
    _45.y = dot(_144, _22_m2[0].xyz);
    _45.z = dot(_144, _22_m2[1].xyz);
    _45.x = dot(_144, _22_m2[2].xyz);
    _163 = dot(_45.xyz, _45.xyz);
    _163 = rsqrt(_163);
    float3 _175 = _163.xxx * _45.xyz;
    _45 = float4(_175.x, _175.y, _175.z, _45.w);
    float3 _184 = _178.yyy * _22_m1[1].yzx;
    _51 = float4(_184.x, _184.y, _184.z, _51.w);
    float3 _195 = (_22_m1[0].yzx * _178.xxx) + _51.xyz;
    _51 = float4(_195.x, _195.y, _195.z, _51.w);
    float3 _206 = (_22_m1[2].yzx * _178.zzz) + _51.xyz;
    _51 = float4(_206.x, _206.y, _206.z, _51.w);
    _163 = dot(_51.xyz, _51.xyz);
    _163 = rsqrt(_163);
    float3 _220 = _163.xxx * _51.xyz;
    _51 = float4(_220.x, _220.y, _220.z, _51.w);
    _224 = _45.xyz * _51.xyz;
    _224 = (_45.zxy * _51.yzx) + (-_224);
    _163 = _178.w * _22_m3.w;
    _224 = _163.xxx * _224;
    vs_TEXCOORD1.y = _224.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _224.y;
    vs_TEXCOORD3.y = _224.z;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45 = _9.yyyy * _22_m6[1];
    _45 = (_22_m6[0] * _9.xxxx) + _45;
    _45 = (_22_m6[2] * _9.zzzz) + _45;
    vs_TEXCOORD5 = (_22_m6[3] * _9.wwww) + _45;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _144 = stage_input._144;
    _178 = stage_input._178;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _398;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _398 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;
static float4 _295;
static bool _344;
static float _348;
static float3 _360;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _295 = vs_TEXCOORD4.yyyy * _37_m3[1];
    _295 = (_37_m3[0] * vs_TEXCOORD4.xxxx) + _295;
    _295 = (_37_m3[2] * vs_TEXCOORD4.zzzz) + _295;
    _295 += _37_m3[3];
    float2 _325 = _295.xy / _295.ww;
    _78 = float3(_325.x, _325.y, _78.z);
    float2 _331 = _78.xy + 0.5f.xx;
    _78 = float3(_331.x, _331.y, _78.z);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xy).w;
    _344 = 0.0f < _295.z;
    _348 = dot(_295.xyz, _295.xyz);
    _348 = _LightTextureB0.Sample(sampler_LightTextureB0, _348.xx).x;
    _360.x = float(_344);
    _360.x = _78.x * _360.x;
    _360.x = _348 * _360.x;
    _360 = _360.xxx * _37_m2.xyz;
    _129 *= _360;
    _47 = _47.xxx * _129;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _398 = float4(_47.x, _47.y, _47.z, _398.w);
    _398.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._398 = _398;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(POINT)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _136;
static float3 _150;
static float4 _184;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _184 : TANGENT;
    float3 _150 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _169;
static float3 _230;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m5.x;
    _45.x *= (-_45.x);
    vs_TEXCOORD7 = exp2(_45.x);
    vs_TEXCOORD0 = (_136.xy * _22_m7.xy) + _22_m7.zw;
    _45.y = dot(_150, _22_m2[0].xyz);
    _45.z = dot(_150, _22_m2[1].xyz);
    _45.x = dot(_150, _22_m2[2].xyz);
    _169 = dot(_45.xyz, _45.xyz);
    _169 = rsqrt(_169);
    float3 _181 = _169.xxx * _45.xyz;
    _45 = float4(_181.x, _181.y, _181.z, _45.w);
    float3 _190 = _184.yyy * _22_m1[1].yzx;
    _51 = float4(_190.x, _190.y, _190.z, _51.w);
    float3 _201 = (_22_m1[0].yzx * _184.xxx) + _51.xyz;
    _51 = float4(_201.x, _201.y, _201.z, _51.w);
    float3 _212 = (_22_m1[2].yzx * _184.zzz) + _51.xyz;
    _51 = float4(_212.x, _212.y, _212.z, _51.w);
    _169 = dot(_51.xyz, _51.xyz);
    _169 = rsqrt(_169);
    float3 _226 = _169.xxx * _51.xyz;
    _51 = float4(_226.x, _226.y, _226.z, _51.w);
    _230 = _45.xyz * _51.xyz;
    _230 = (_45.zxy * _51.yzx) + (-_230);
    _169 = _184.w * _22_m3.w;
    _230 = _169.xxx * _230;
    vs_TEXCOORD1.y = _230.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _230.y;
    vs_TEXCOORD3.y = _230.z;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    float3 _309 = _9.yyy * _22_m6[1].xyz;
    _45 = float4(_309.x, _309.y, _309.z, _45.w);
    float3 _320 = (_22_m6[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_320.x, _320.y, _320.z, _45.w);
    float3 _331 = (_22_m6[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_331.x, _331.y, _331.z, _9.w);
    vs_TEXCOORD5 = (_22_m6[3].xyz * _9.www) + _9.xyz;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _150 = stage_input._150;
    _184 = stage_input._184;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _357;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _357 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _78 = vs_TEXCOORD4.yyy * _37_m3[1].xyz;
    _78 = (_37_m3[0].xyz * vs_TEXCOORD4.xxx) + _78;
    _78 = (_37_m3[2].xyz * vs_TEXCOORD4.zzz) + _78;
    _78 += _37_m3[3].xyz;
    _78.x = dot(_78, _78);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xx).x;
    _22 = _78.xxx * _37_m2.xyz;
    _129 *= _22;
    _47 = _47.xxx * _129;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _357 = float4(_47.x, _47.y, _47.z, _357.w);
    _357.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._357 = _357;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(POINT_COOKIE)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _136;
static float3 _150;
static float4 _184;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _184 : TANGENT;
    float3 _150 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _169;
static float3 _230;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m5.x;
    _45.x *= (-_45.x);
    vs_TEXCOORD7 = exp2(_45.x);
    vs_TEXCOORD0 = (_136.xy * _22_m7.xy) + _22_m7.zw;
    _45.y = dot(_150, _22_m2[0].xyz);
    _45.z = dot(_150, _22_m2[1].xyz);
    _45.x = dot(_150, _22_m2[2].xyz);
    _169 = dot(_45.xyz, _45.xyz);
    _169 = rsqrt(_169);
    float3 _181 = _169.xxx * _45.xyz;
    _45 = float4(_181.x, _181.y, _181.z, _45.w);
    float3 _190 = _184.yyy * _22_m1[1].yzx;
    _51 = float4(_190.x, _190.y, _190.z, _51.w);
    float3 _201 = (_22_m1[0].yzx * _184.xxx) + _51.xyz;
    _51 = float4(_201.x, _201.y, _201.z, _51.w);
    float3 _212 = (_22_m1[2].yzx * _184.zzz) + _51.xyz;
    _51 = float4(_212.x, _212.y, _212.z, _51.w);
    _169 = dot(_51.xyz, _51.xyz);
    _169 = rsqrt(_169);
    float3 _226 = _169.xxx * _51.xyz;
    _51 = float4(_226.x, _226.y, _226.z, _51.w);
    _230 = _45.xyz * _51.xyz;
    _230 = (_45.zxy * _51.yzx) + (-_230);
    _169 = _184.w * _22_m3.w;
    _230 = _169.xxx * _230;
    vs_TEXCOORD1.y = _230.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _230.y;
    vs_TEXCOORD3.y = _230.z;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    float3 _309 = _9.yyy * _22_m6[1].xyz;
    _45 = float4(_309.x, _309.y, _309.z, _45.w);
    float3 _320 = (_22_m6[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_320.x, _320.y, _320.z, _45.w);
    float3 _331 = (_22_m6[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_331.x, _331.y, _331.z, _9.w);
    vs_TEXCOORD5 = (_22_m6[3].xyz * _9.www) + _9.xyz;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _150 = stage_input._150;
    _184 = stage_input._184;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _372;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _372 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _78 = vs_TEXCOORD4.yyy * _37_m3[1].xyz;
    _78 = (_37_m3[0].xyz * vs_TEXCOORD4.xxx) + _78;
    _78 = (_37_m3[2].xyz * vs_TEXCOORD4.zzz) + _78;
    _78 += _37_m3[3].xyz;
    _101 = dot(_78, _78);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78).w;
    _183.x = _LightTextureB0.Sample(sampler_LightTextureB0, _101.xx).x;
    _78.x *= _183.x;
    _22 = _78.xxx * _37_m2.xyz;
    _129 *= _22;
    _47 = _47.xxx * _129;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _372 = float4(_47.x, _47.y, _47.z, _372.w);
    _372.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._372 = _372;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(SPOT)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _136;
static float3 _150;
static float4 _184;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _184 : TANGENT;
    float3 _150 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _169;
static float3 _230;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m5.x;
    _45.x *= (-_45.x);
    vs_TEXCOORD7 = exp2(_45.x);
    vs_TEXCOORD0 = (_136.xy * _22_m7.xy) + _22_m7.zw;
    _45.y = dot(_150, _22_m2[0].xyz);
    _45.z = dot(_150, _22_m2[1].xyz);
    _45.x = dot(_150, _22_m2[2].xyz);
    _169 = dot(_45.xyz, _45.xyz);
    _169 = rsqrt(_169);
    float3 _181 = _169.xxx * _45.xyz;
    _45 = float4(_181.x, _181.y, _181.z, _45.w);
    float3 _190 = _184.yyy * _22_m1[1].yzx;
    _51 = float4(_190.x, _190.y, _190.z, _51.w);
    float3 _201 = (_22_m1[0].yzx * _184.xxx) + _51.xyz;
    _51 = float4(_201.x, _201.y, _201.z, _51.w);
    float3 _212 = (_22_m1[2].yzx * _184.zzz) + _51.xyz;
    _51 = float4(_212.x, _212.y, _212.z, _51.w);
    _169 = dot(_51.xyz, _51.xyz);
    _169 = rsqrt(_169);
    float3 _226 = _169.xxx * _51.xyz;
    _51 = float4(_226.x, _226.y, _226.z, _51.w);
    _230 = _45.xyz * _51.xyz;
    _230 = (_45.zxy * _51.yzx) + (-_230);
    _169 = _184.w * _22_m3.w;
    _230 = _169.xxx * _230;
    vs_TEXCOORD1.y = _230.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _230.y;
    vs_TEXCOORD3.y = _230.z;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45 = _9.yyyy * _22_m6[1];
    _45 = (_22_m6[0] * _9.xxxx) + _45;
    _45 = (_22_m6[2] * _9.zzzz) + _45;
    vs_TEXCOORD5 = (_22_m6[3] * _9.wwww) + _45;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _150 = stage_input._150;
    _184 = stage_input._184;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _398;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _398 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;
static float4 _295;
static bool _344;
static float _348;
static float3 _360;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _295 = vs_TEXCOORD4.yyyy * _37_m3[1];
    _295 = (_37_m3[0] * vs_TEXCOORD4.xxxx) + _295;
    _295 = (_37_m3[2] * vs_TEXCOORD4.zzzz) + _295;
    _295 += _37_m3[3];
    float2 _325 = _295.xy / _295.ww;
    _78 = float3(_325.x, _325.y, _78.z);
    float2 _331 = _78.xy + 0.5f.xx;
    _78 = float3(_331.x, _331.y, _78.z);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xy).w;
    _344 = 0.0f < _295.z;
    _348 = dot(_295.xyz, _295.xyz);
    _348 = _LightTextureB0.Sample(sampler_LightTextureB0, _348.xx).x;
    _360.x = float(_344);
    _360.x = _78.x * _360.x;
    _360.x = _348 * _360.x;
    _360 = _360.xxx * _37_m2.xyz;
    _129 *= _360;
    _47 = _47.xxx * _129;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _398 = float4(_47.x, _47.y, _47.z, _398.w);
    _398.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._398 = _398;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(POINT)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _129;
static float3 _143;
static float4 _177;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _177 : TANGENT;
    float3 _143 : NORMAL;
    float4 _129 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _162;
static float3 _223;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    vs_TEXCOORD7 = (_45.x * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_129.xy * _22_m7.xy) + _22_m7.zw;
    _45.y = dot(_143, _22_m2[0].xyz);
    _45.z = dot(_143, _22_m2[1].xyz);
    _45.x = dot(_143, _22_m2[2].xyz);
    _162 = dot(_45.xyz, _45.xyz);
    _162 = rsqrt(_162);
    float3 _174 = _162.xxx * _45.xyz;
    _45 = float4(_174.x, _174.y, _174.z, _45.w);
    float3 _183 = _177.yyy * _22_m1[1].yzx;
    _51 = float4(_183.x, _183.y, _183.z, _51.w);
    float3 _194 = (_22_m1[0].yzx * _177.xxx) + _51.xyz;
    _51 = float4(_194.x, _194.y, _194.z, _51.w);
    float3 _205 = (_22_m1[2].yzx * _177.zzz) + _51.xyz;
    _51 = float4(_205.x, _205.y, _205.z, _51.w);
    _162 = dot(_51.xyz, _51.xyz);
    _162 = rsqrt(_162);
    float3 _219 = _162.xxx * _51.xyz;
    _51 = float4(_219.x, _219.y, _219.z, _51.w);
    _223 = _45.xyz * _51.xyz;
    _223 = (_45.zxy * _51.yzx) + (-_223);
    _162 = _177.w * _22_m3.w;
    _223 = _162.xxx * _223;
    vs_TEXCOORD1.y = _223.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _223.y;
    vs_TEXCOORD3.y = _223.z;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    float3 _301 = _9.yyy * _22_m6[1].xyz;
    _45 = float4(_301.x, _301.y, _301.z, _45.w);
    float3 _312 = (_22_m6[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_312.x, _312.y, _312.z, _45.w);
    float3 _323 = (_22_m6[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_323.x, _323.y, _323.z, _9.w);
    vs_TEXCOORD5 = (_22_m6[3].xyz * _9.www) + _9.xyz;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _129 = stage_input._129;
    _143 = stage_input._143;
    _177 = stage_input._177;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _357;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _357 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _78 = vs_TEXCOORD4.yyy * _37_m3[1].xyz;
    _78 = (_37_m3[0].xyz * vs_TEXCOORD4.xxx) + _78;
    _78 = (_37_m3[2].xyz * vs_TEXCOORD4.zzz) + _78;
    _78 += _37_m3[3].xyz;
    _78.x = dot(_78, _78);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xx).x;
    _22 = _78.xxx * _37_m2.xyz;
    _129 *= _22;
    _47 = _47.xxx * _129;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _357 = float4(_47.x, _47.y, _47.z, _357.w);
    _357.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._357 = _357;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(POINT_COOKIE)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _129;
static float3 _143;
static float4 _177;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _177 : TANGENT;
    float3 _143 : NORMAL;
    float4 _129 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _162;
static float3 _223;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    vs_TEXCOORD7 = (_45.x * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_129.xy * _22_m7.xy) + _22_m7.zw;
    _45.y = dot(_143, _22_m2[0].xyz);
    _45.z = dot(_143, _22_m2[1].xyz);
    _45.x = dot(_143, _22_m2[2].xyz);
    _162 = dot(_45.xyz, _45.xyz);
    _162 = rsqrt(_162);
    float3 _174 = _162.xxx * _45.xyz;
    _45 = float4(_174.x, _174.y, _174.z, _45.w);
    float3 _183 = _177.yyy * _22_m1[1].yzx;
    _51 = float4(_183.x, _183.y, _183.z, _51.w);
    float3 _194 = (_22_m1[0].yzx * _177.xxx) + _51.xyz;
    _51 = float4(_194.x, _194.y, _194.z, _51.w);
    float3 _205 = (_22_m1[2].yzx * _177.zzz) + _51.xyz;
    _51 = float4(_205.x, _205.y, _205.z, _51.w);
    _162 = dot(_51.xyz, _51.xyz);
    _162 = rsqrt(_162);
    float3 _219 = _162.xxx * _51.xyz;
    _51 = float4(_219.x, _219.y, _219.z, _51.w);
    _223 = _45.xyz * _51.xyz;
    _223 = (_45.zxy * _51.yzx) + (-_223);
    _162 = _177.w * _22_m3.w;
    _223 = _162.xxx * _223;
    vs_TEXCOORD1.y = _223.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _223.y;
    vs_TEXCOORD3.y = _223.z;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    float3 _301 = _9.yyy * _22_m6[1].xyz;
    _45 = float4(_301.x, _301.y, _301.z, _45.w);
    float3 _312 = (_22_m6[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_312.x, _312.y, _312.z, _45.w);
    float3 _323 = (_22_m6[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_323.x, _323.y, _323.z, _9.w);
    vs_TEXCOORD5 = (_22_m6[3].xyz * _9.www) + _9.xyz;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _129 = stage_input._129;
    _143 = stage_input._143;
    _177 = stage_input._177;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _372;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _372 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _78 = vs_TEXCOORD4.yyy * _37_m3[1].xyz;
    _78 = (_37_m3[0].xyz * vs_TEXCOORD4.xxx) + _78;
    _78 = (_37_m3[2].xyz * vs_TEXCOORD4.zzz) + _78;
    _78 += _37_m3[3].xyz;
    _101 = dot(_78, _78);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78).w;
    _183.x = _LightTextureB0.Sample(sampler_LightTextureB0, _101.xx).x;
    _78.x *= _183.x;
    _22 = _78.xxx * _37_m2.xyz;
    _129 *= _22;
    _47 = _47.xxx * _129;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _372 = float4(_47.x, _47.y, _47.z, _372.w);
    _372.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._372 = _372;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(SPOT)
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
float4x4 unity_WorldToLight;
static float4 _22_m6[4];
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
    _22_m6[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m6[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m6[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m6[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m7 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float4 _129;
static float3 _143;
static float4 _177;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _177 : TANGENT;
    float3 _143 : NORMAL;
    float4 _129 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _162;
static float3 _223;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    vs_TEXCOORD7 = (_45.x * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_129.xy * _22_m7.xy) + _22_m7.zw;
    _45.y = dot(_143, _22_m2[0].xyz);
    _45.z = dot(_143, _22_m2[1].xyz);
    _45.x = dot(_143, _22_m2[2].xyz);
    _162 = dot(_45.xyz, _45.xyz);
    _162 = rsqrt(_162);
    float3 _174 = _162.xxx * _45.xyz;
    _45 = float4(_174.x, _174.y, _174.z, _45.w);
    float3 _183 = _177.yyy * _22_m1[1].yzx;
    _51 = float4(_183.x, _183.y, _183.z, _51.w);
    float3 _194 = (_22_m1[0].yzx * _177.xxx) + _51.xyz;
    _51 = float4(_194.x, _194.y, _194.z, _51.w);
    float3 _205 = (_22_m1[2].yzx * _177.zzz) + _51.xyz;
    _51 = float4(_205.x, _205.y, _205.z, _51.w);
    _162 = dot(_51.xyz, _51.xyz);
    _162 = rsqrt(_162);
    float3 _219 = _162.xxx * _51.xyz;
    _51 = float4(_219.x, _219.y, _219.z, _51.w);
    _223 = _45.xyz * _51.xyz;
    _223 = (_45.zxy * _51.yzx) + (-_223);
    _162 = _177.w * _22_m3.w;
    _223 = _162.xxx * _223;
    vs_TEXCOORD1.y = _223.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _223.y;
    vs_TEXCOORD3.y = _223.z;
    vs_TEXCOORD4 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45 = _9.yyyy * _22_m6[1];
    _45 = (_22_m6[0] * _9.xxxx) + _45;
    _45 = (_22_m6[2] * _9.zzzz) + _45;
    vs_TEXCOORD5 = (_22_m6[3] * _9.wwww) + _45;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _129 = stage_input._129;
    _143 = stage_input._143;
    _177 = stage_input._177;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD7;
static float4 _398;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _398 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;
static float4 _295;
static bool _344;
static float _348;
static float3 _360;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _295 = vs_TEXCOORD4.yyyy * _37_m3[1];
    _295 = (_37_m3[0] * vs_TEXCOORD4.xxxx) + _295;
    _295 = (_37_m3[2] * vs_TEXCOORD4.zzzz) + _295;
    _295 += _37_m3[3];
    float2 _325 = _295.xy / _295.ww;
    _78 = float3(_325.x, _325.y, _78.z);
    float2 _331 = _78.xy + 0.5f.xx;
    _78 = float3(_331.x, _331.y, _78.z);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xy).w;
    _344 = 0.0f < _295.z;
    _348 = dot(_295.xyz, _295.xyz);
    _348 = _LightTextureB0.Sample(sampler_LightTextureB0, _348.xx).x;
    _360.x = float(_344);
    _360.x = _78.x * _360.x;
    _360.x = _348 * _360.x;
    _360 = _360.xxx * _37_m2.xyz;
    _129 *= _360;
    _47 = _47.xxx * _129;
    _68 = vs_TEXCOORD7;
    _68 = clamp(_68, 0.0f, 1.0f);
    _47 *= _68.xxx;
    _398 = float4(_47.x, _47.y, _47.z, _398.w);
    _398.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._398 = _398;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4x4 unity_WorldToLight;
static float4 _22_m4[4];
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
    _22_m4[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m4[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m4[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m4[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m2 unity_WorldTransformParams
#define _22_m5 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD4;
static float2 vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _148;
static float3 _161;
static float4 _198;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _198 : TANGENT;
    float3 _161 : NORMAL;
    float4 _148 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float2 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _183;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m0[1];
    _9 = (_22_m0[0] * _11.xxxx) + _9;
    _9 = (_22_m0[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m0[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    gl_Position = (_22_m3[3] * _45.wwww) + _51;
    _45 = (_22_m0[3] * _11.wwww) + _9;
    vs_TEXCOORD4 = (_22_m0[3].xyz * _11.www) + _9.xyz;
    float2 _111 = _45.yy * _22_m4[1].xy;
    _9 = float4(_111.x, _111.y, _9.z, _9.w);
    float2 _122 = (_22_m4[0].xy * _45.xx) + _9.xy;
    _9 = float4(_122.x, _122.y, _9.z, _9.w);
    float2 _133 = (_22_m4[2].xy * _45.zz) + _9.xy;
    _9 = float4(_133.x, _133.y, _9.z, _9.w);
    vs_TEXCOORD5 = (_22_m4[3].xy * _45.ww) + _9.xy;
    vs_TEXCOORD0 = (_148.xy * _22_m5.xy) + _22_m5.zw;
    _9.y = dot(_161, _22_m1[0].xyz);
    _9.z = dot(_161, _22_m1[1].xyz);
    _9.x = dot(_161, _22_m1[2].xyz);
    _183 = dot(_9.xyz, _9.xyz);
    _183 = rsqrt(_183);
    float3 _195 = _183.xxx * _9.xyz;
    _9 = float4(_195.x, _195.y, _195.z, _9.w);
    float3 _204 = _198.yyy * _22_m0[1].yzx;
    _45 = float4(_204.x, _204.y, _204.z, _45.w);
    float3 _215 = (_22_m0[0].yzx * _198.xxx) + _45.xyz;
    _45 = float4(_215.x, _215.y, _215.z, _45.w);
    float3 _226 = (_22_m0[2].yzx * _198.zzz) + _45.xyz;
    _45 = float4(_226.x, _226.y, _226.z, _45.w);
    _183 = dot(_45.xyz, _45.xyz);
    _183 = rsqrt(_183);
    float3 _240 = _183.xxx * _45.xyz;
    _45 = float4(_240.x, _240.y, _240.z, _45.w);
    float3 _247 = _9.xyz * _45.xyz;
    _51 = float4(_247.x, _247.y, _247.z, _51.w);
    float3 _258 = (_9.zxy * _45.yzx) + (-_51.xyz);
    _51 = float4(_258.x, _258.y, _258.z, _51.w);
    _183 = _198.w * _22_m2.w;
    float3 _273 = _183.xxx * _51.xyz;
    _51 = float4(_273.x, _273.y, _273.z, _51.w);
    vs_TEXCOORD1.y = _51.x;
    vs_TEXCOORD1.x = _45.z;
    vs_TEXCOORD1.z = _9.y;
    vs_TEXCOORD2.x = _45.x;
    vs_TEXCOORD3.x = _45.y;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.y = _51.y;
    vs_TEXCOORD3.y = _51.z;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _148 = stage_input._148;
    _161 = stage_input._161;
    _198 = stage_input._198;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 _345;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _345 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _114;
static float2 _158;
static float3 _172;
static float _199;
static float3 _239;
static float _266;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _78 = (_78 * _68.xxx) + _37_m1.xyz;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _114.z = dot(_47, _78);
    _114.z = clamp(_114.z, 0.0f, 1.0f);
    _47.x = dot(_47, _37_m1.xyz);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _114.x = dot(_37_m1.xyz, _78);
    _114.x = clamp(_114.x, 0.0f, 1.0f);
    float2 _149 = _114.xz * _114.xz;
    _114 = float3(_149.x, _149.y, _114.z);
    _114.x = max(_114.x, 0.100000001490116119384765625f);
    _158 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_158.y) * _37_m6) + 1.0f;
    _172.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _114.x = _68 * _114.x;
    _68 = (_172.x * _172.x) + (-1.0f);
    _172.x *= _172.x;
    _199 = (_114.y * _68) + 1.000010013580322265625f;
    _199 *= _199;
    _114.x = _199 * _114.x;
    _114.x *= 4.0f;
    _114.x = _172.x / _114.x;
    _114.x += (-9.9999997473787516355514526367188e-05f);
    _114.x = max(_114.x, 0.0f);
    _114.x = min(_114.x, 100.0f);
    _239 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_239 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _172 = _239 * _37_m4.xyz;
    _22 = (_158.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _266 = ((-_158.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _114 = _114.xxx * _22;
    _114 = (_172 * _266.xxx) + _114;
    float2 _289 = vs_TEXCOORD4.yy * _37_m3[1].xy;
    _78 = float3(_289.x, _289.y, _78.z);
    float2 _300 = (_37_m3[0].xy * vs_TEXCOORD4.xx) + _78.xy;
    _78 = float3(_300.x, _300.y, _78.z);
    float2 _312 = (_37_m3[2].xy * vs_TEXCOORD4.zz) + _78.xy;
    _78 = float3(_312.x, _312.y, _78.z);
    float2 _320 = _78.xy + _37_m3[3].xy;
    _78 = float3(_320.x, _320.y, _78.z);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xy).w;
    _22 = _78.xxx * _37_m2.xyz;
    _114 *= _22;
    _47 = _47.xxx * _114;
    _345 = float4(_47.x, _47.y, _47.z, _345.w);
    _345.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._345 = _345;
    return stage_output;
}

#endif
#elif defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4x4 unity_WorldToLight;
static float4 _22_m4[4];
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
    _22_m4[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m4[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m4[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m4[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m2 unity_WorldTransformParams
#define _22_m5 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _88;
static float3 _102;
static float4 _139;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _139 : TANGENT;
    float3 _102 : NORMAL;
    float4 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _124;
static float3 _185;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m0[1];
    _9 = (_22_m0[0] * _11.xxxx) + _9;
    _9 = (_22_m0[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m0[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    gl_Position = (_22_m3[3] * _45.wwww) + _51;
    vs_TEXCOORD0 = (_88.xy * _22_m5.xy) + _22_m5.zw;
    _45.y = dot(_102, _22_m1[0].xyz);
    _45.z = dot(_102, _22_m1[1].xyz);
    _45.x = dot(_102, _22_m1[2].xyz);
    _124 = dot(_45.xyz, _45.xyz);
    _124 = rsqrt(_124);
    float3 _136 = _124.xxx * _45.xyz;
    _45 = float4(_136.x, _136.y, _136.z, _45.w);
    float3 _145 = _139.yyy * _22_m0[1].yzx;
    _51 = float4(_145.x, _145.y, _145.z, _51.w);
    float3 _156 = (_22_m0[0].yzx * _139.xxx) + _51.xyz;
    _51 = float4(_156.x, _156.y, _156.z, _51.w);
    float3 _167 = (_22_m0[2].yzx * _139.zzz) + _51.xyz;
    _51 = float4(_167.x, _167.y, _167.z, _51.w);
    _124 = dot(_51.xyz, _51.xyz);
    _124 = rsqrt(_124);
    float3 _181 = _124.xxx * _51.xyz;
    _51 = float4(_181.x, _181.y, _181.z, _51.w);
    _185 = _45.xyz * _51.xyz;
    _185 = (_45.zxy * _51.yzx) + (-_185);
    _124 = _139.w * _22_m2.w;
    _185 = _124.xxx * _185;
    vs_TEXCOORD1.y = _185.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _185.y;
    vs_TEXCOORD3.y = _185.z;
    vs_TEXCOORD4 = (_22_m0[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m0[3] * _11.wwww) + _9;
    float3 _266 = _9.yyy * _22_m4[1].xyz;
    _45 = float4(_266.x, _266.y, _266.z, _45.w);
    float3 _277 = (_22_m4[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    float3 _288 = (_22_m4[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_288.x, _288.y, _288.z, _9.w);
    vs_TEXCOORD5 = (_22_m4[3].xyz * _9.www) + _9.xyz;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _102 = stage_input._102;
    _139 = stage_input._139;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 _348;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _348 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _78 = vs_TEXCOORD4.yyy * _37_m3[1].xyz;
    _78 = (_37_m3[0].xyz * vs_TEXCOORD4.xxx) + _78;
    _78 = (_37_m3[2].xyz * vs_TEXCOORD4.zzz) + _78;
    _78 += _37_m3[3].xyz;
    _78.x = dot(_78, _78);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xx).x;
    _22 = _78.xxx * _37_m2.xyz;
    _129 *= _22;
    _47 = _47.xxx * _129;
    _348 = float4(_47.x, _47.y, _47.z, _348.w);
    _348.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._348 = _348;
    return stage_output;
}

#endif
#elif defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4x4 unity_WorldToLight;
static float4 _22_m4[4];
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
    _22_m4[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m4[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m4[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m4[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m2 unity_WorldTransformParams
#define _22_m5 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _88;
static float3 _102;
static float4 _139;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _139 : TANGENT;
    float3 _102 : NORMAL;
    float4 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _124;
static float3 _185;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m0[1];
    _9 = (_22_m0[0] * _11.xxxx) + _9;
    _9 = (_22_m0[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m0[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    gl_Position = (_22_m3[3] * _45.wwww) + _51;
    vs_TEXCOORD0 = (_88.xy * _22_m5.xy) + _22_m5.zw;
    _45.y = dot(_102, _22_m1[0].xyz);
    _45.z = dot(_102, _22_m1[1].xyz);
    _45.x = dot(_102, _22_m1[2].xyz);
    _124 = dot(_45.xyz, _45.xyz);
    _124 = rsqrt(_124);
    float3 _136 = _124.xxx * _45.xyz;
    _45 = float4(_136.x, _136.y, _136.z, _45.w);
    float3 _145 = _139.yyy * _22_m0[1].yzx;
    _51 = float4(_145.x, _145.y, _145.z, _51.w);
    float3 _156 = (_22_m0[0].yzx * _139.xxx) + _51.xyz;
    _51 = float4(_156.x, _156.y, _156.z, _51.w);
    float3 _167 = (_22_m0[2].yzx * _139.zzz) + _51.xyz;
    _51 = float4(_167.x, _167.y, _167.z, _51.w);
    _124 = dot(_51.xyz, _51.xyz);
    _124 = rsqrt(_124);
    float3 _181 = _124.xxx * _51.xyz;
    _51 = float4(_181.x, _181.y, _181.z, _51.w);
    _185 = _45.xyz * _51.xyz;
    _185 = (_45.zxy * _51.yzx) + (-_185);
    _124 = _139.w * _22_m2.w;
    _185 = _124.xxx * _185;
    vs_TEXCOORD1.y = _185.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _185.y;
    vs_TEXCOORD3.y = _185.z;
    vs_TEXCOORD4 = (_22_m0[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m0[3] * _11.wwww) + _9;
    float3 _266 = _9.yyy * _22_m4[1].xyz;
    _45 = float4(_266.x, _266.y, _266.z, _45.w);
    float3 _277 = (_22_m4[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    float3 _288 = (_22_m4[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_288.x, _288.y, _288.z, _9.w);
    vs_TEXCOORD5 = (_22_m4[3].xyz * _9.www) + _9.xyz;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _102 = stage_input._102;
    _139 = stage_input._139;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 _363;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _363 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _78 = vs_TEXCOORD4.yyy * _37_m3[1].xyz;
    _78 = (_37_m3[0].xyz * vs_TEXCOORD4.xxx) + _78;
    _78 = (_37_m3[2].xyz * vs_TEXCOORD4.zzz) + _78;
    _78 += _37_m3[3].xyz;
    _101 = dot(_78, _78);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78).w;
    _183.x = _LightTextureB0.Sample(sampler_LightTextureB0, _101.xx).x;
    _78.x *= _183.x;
    _22 = _78.xxx * _37_m2.xyz;
    _129 *= _22;
    _47 = _47.xxx * _129;
    _363 = float4(_47.x, _47.y, _47.z, _363.w);
    _363.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._363 = _363;
    return stage_output;
}

#endif
#elif defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4x4 unity_WorldToLight;
static float4 _22_m4[4];
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
    _22_m4[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m4[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m4[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m4[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m2 unity_WorldTransformParams
#define _22_m5 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float4 _88;
static float3 _102;
static float4 _139;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _139 : TANGENT;
    float3 _102 : NORMAL;
    float4 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _124;
static float3 _185;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m0[1];
    _9 = (_22_m0[0] * _11.xxxx) + _9;
    _9 = (_22_m0[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m0[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    gl_Position = (_22_m3[3] * _45.wwww) + _51;
    vs_TEXCOORD0 = (_88.xy * _22_m5.xy) + _22_m5.zw;
    _45.y = dot(_102, _22_m1[0].xyz);
    _45.z = dot(_102, _22_m1[1].xyz);
    _45.x = dot(_102, _22_m1[2].xyz);
    _124 = dot(_45.xyz, _45.xyz);
    _124 = rsqrt(_124);
    float3 _136 = _124.xxx * _45.xyz;
    _45 = float4(_136.x, _136.y, _136.z, _45.w);
    float3 _145 = _139.yyy * _22_m0[1].yzx;
    _51 = float4(_145.x, _145.y, _145.z, _51.w);
    float3 _156 = (_22_m0[0].yzx * _139.xxx) + _51.xyz;
    _51 = float4(_156.x, _156.y, _156.z, _51.w);
    float3 _167 = (_22_m0[2].yzx * _139.zzz) + _51.xyz;
    _51 = float4(_167.x, _167.y, _167.z, _51.w);
    _124 = dot(_51.xyz, _51.xyz);
    _124 = rsqrt(_124);
    float3 _181 = _124.xxx * _51.xyz;
    _51 = float4(_181.x, _181.y, _181.z, _51.w);
    _185 = _45.xyz * _51.xyz;
    _185 = (_45.zxy * _51.yzx) + (-_185);
    _124 = _139.w * _22_m2.w;
    _185 = _124.xxx * _185;
    vs_TEXCOORD1.y = _185.x;
    vs_TEXCOORD1.x = _51.z;
    vs_TEXCOORD1.z = _45.y;
    vs_TEXCOORD2.x = _51.x;
    vs_TEXCOORD3.x = _51.y;
    vs_TEXCOORD2.z = _45.z;
    vs_TEXCOORD3.z = _45.x;
    vs_TEXCOORD2.y = _185.y;
    vs_TEXCOORD3.y = _185.z;
    vs_TEXCOORD4 = (_22_m0[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m0[3] * _11.wwww) + _9;
    _45 = _9.yyyy * _22_m4[1];
    _45 = (_22_m4[0] * _9.xxxx) + _45;
    _45 = (_22_m4[2] * _9.zzzz) + _45;
    vs_TEXCOORD5 = (_22_m4[3] * _9.wwww) + _45;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _102 = stage_input._102;
    _139 = stage_input._139;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _37_m3[4];
float4 _Color;
float _BumpScale;
float _GlossMapScale;
void __unity_init()
{
    _37_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _37_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _37_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _37_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _WorldSpaceLightPos0
#define _37_m2 _LightColor0
#define _37_m4 _Color
#define _37_m5 _BumpScale
#define _37_m6 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 _389;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _389 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _47;
static float _68;
static float3 _78;
static float3 _92;
static float _101;
static float3 _129;
static float2 _169;
static float3 _183;
static float _210;
static float3 _250;
static float _277;
static float4 _295;
static bool _344;
static float _348;
static float3 _360;

void frag_inner()
{
    __unity_init();
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _44 = _22.xy * _37_m5.xx;
    _22 = float3(_44.x, _44.y, _22.z);
    _47.x = dot(vs_TEXCOORD1, _22);
    _47.y = dot(vs_TEXCOORD2, _22);
    _47.z = dot(vs_TEXCOORD3, _22);
    _68 = dot(_47, _47);
    _68 = rsqrt(_68);
    _47 = _68.xxx * _47;
    _78 = (-vs_TEXCOORD4) + _37_m0;
    _68 = dot(_78, _78);
    _68 = rsqrt(_68);
    _92 = (-vs_TEXCOORD4) + _37_m1.xyz;
    _101 = dot(_92, _92);
    _101 = rsqrt(_101);
    _92 = _101.xxx * _92;
    _78 = (_78 * _68.xxx) + _92;
    _68 = dot(_78, _78);
    _68 = max(_68, 0.001000000047497451305389404296875f);
    _68 = rsqrt(_68);
    _78 = _68.xxx * _78;
    _129.z = dot(_47, _78);
    _129.z = clamp(_129.z, 0.0f, 1.0f);
    _47.x = dot(_47, _92);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _129.x = dot(_92, _78);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    float2 _160 = _129.xz * _129.xz;
    _129 = float3(_160.x, _160.y, _129.z);
    _129.x = max(_129.x, 0.100000001490116119384765625f);
    _169 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _68 = ((-_169.y) * _37_m6) + 1.0f;
    _183.x = _68 * _68;
    _68 = (_68 * _68) + 0.5f;
    _129.x = _68 * _129.x;
    _68 = (_183.x * _183.x) + (-1.0f);
    _183.x *= _183.x;
    _210 = (_129.y * _68) + 1.000010013580322265625f;
    _210 *= _210;
    _129.x = _210 * _129.x;
    _129.x *= 4.0f;
    _129.x = _183.x / _129.x;
    _129.x += (-9.9999997473787516355514526367188e-05f);
    _129.x = max(_129.x, 0.0f);
    _129.x = min(_129.x, 100.0f);
    _250 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_250 * _37_m4.xyz) + (-0.039999999105930328369140625f).xxx;
    _183 = _250 * _37_m4.xyz;
    _22 = (_169.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _277 = ((-_169.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _129 = _129.xxx * _22;
    _129 = (_183 * _277.xxx) + _129;
    _295 = vs_TEXCOORD4.yyyy * _37_m3[1];
    _295 = (_37_m3[0] * vs_TEXCOORD4.xxxx) + _295;
    _295 = (_37_m3[2] * vs_TEXCOORD4.zzzz) + _295;
    _295 += _37_m3[3];
    float2 _325 = _295.xy / _295.ww;
    _78 = float3(_325.x, _325.y, _78.z);
    float2 _331 = _78.xy + 0.5f.xx;
    _78 = float3(_331.x, _331.y, _78.z);
    _78.x = _LightTexture0.Sample(sampler_LightTexture0, _78.xy).w;
    _344 = 0.0f < _295.z;
    _348 = dot(_295.xyz, _295.xyz);
    _348 = _LightTextureB0.Sample(sampler_LightTextureB0, _348.xx).x;
    _360.x = float(_344);
    _360.x = _78.x * _360.x;
    _360.x = _348 * _360.x;
    _360 = _360.xxx * _37_m2.xyz;
    _129 *= _360;
    _47 = _47.xxx * _129;
    _389 = float4(_47.x, _47.y, _47.z, _389.w);
    _389.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._389 = _389;
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
float4 _MainTex_ST;
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
#define _21_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float4 _98;
static float3 _111;
static float4 _148;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _148 : TANGENT;
    float3 _111 : NORMAL;
    float4 _98 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD6 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _133;
static float3 _194;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD4 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    gl_Position = (_21_m3[3] * _44.wwww) + _9;
    vs_TEXCOORD0 = (_98.xy * _21_m4.xy) + _21_m4.zw;
    _9.y = dot(_111, _21_m1[0].xyz);
    _9.z = dot(_111, _21_m1[1].xyz);
    _9.x = dot(_111, _21_m1[2].xyz);
    _133 = dot(_9.xyz, _9.xyz);
    _133 = rsqrt(_133);
    float3 _145 = _133.xxx * _9.xyz;
    _9 = float4(_145.x, _145.y, _145.z, _9.w);
    float3 _154 = _148.yyy * _21_m0[1].yzx;
    _44 = float4(_154.x, _154.y, _154.z, _44.w);
    float3 _165 = (_21_m0[0].yzx * _148.xxx) + _44.xyz;
    _44 = float4(_165.x, _165.y, _165.z, _44.w);
    float3 _176 = (_21_m0[2].yzx * _148.zzz) + _44.xyz;
    _44 = float4(_176.x, _176.y, _176.z, _44.w);
    _133 = dot(_44.xyz, _44.xyz);
    _133 = rsqrt(_133);
    float3 _190 = _133.xxx * _44.xyz;
    _44 = float4(_190.x, _190.y, _190.z, _44.w);
    _194 = _9.xyz * _44.xyz;
    _194 = (_9.zxy * _44.yzx) + (-_194);
    _133 = _148.w * _21_m2.w;
    _194 = _133.xxx * _194;
    vs_TEXCOORD1.y = _194.x;
    vs_TEXCOORD1.x = _44.z;
    vs_TEXCOORD1.z = _9.y;
    vs_TEXCOORD2.x = _44.x;
    vs_TEXCOORD3.x = _44.y;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.y = _194.y;
    vs_TEXCOORD3.y = _194.z;
    vs_TEXCOORD6 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _98 = stage_input._98;
    _111 = stage_input._111;
    _148 = stage_input._148;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _BumpScale;
float _GlossMapScale;
#define _34_m0 _WorldSpaceCameraPos
#define _34_m1 _WorldSpaceLightPos0
#define _34_m2 _LightColor0
#define _34_m3 _Color
#define _34_m4 _BumpScale
#define _34_m5 _GlossMapScale


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MetallicGlossMap;
SamplerState sampler_MetallicGlossMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 _292;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _292 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _44;
static float _66;
static float3 _76;
static float3 _112;
static float2 _156;
static float3 _170;
static float _197;
static float3 _237;
static float _264;

void frag_inner()
{
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _41 = _22.xy * _34_m4.xx;
    _22 = float3(_41.x, _41.y, _22.z);
    _44.x = dot(vs_TEXCOORD1, _22);
    _44.y = dot(vs_TEXCOORD2, _22);
    _44.z = dot(vs_TEXCOORD3, _22);
    _66 = dot(_44, _44);
    _66 = rsqrt(_66);
    _44 = _66.xxx * _44;
    _76 = (-vs_TEXCOORD4) + _34_m0;
    _66 = dot(_76, _76);
    _66 = rsqrt(_66);
    _76 = (_76 * _66.xxx) + _34_m1.xyz;
    _66 = dot(_76, _76);
    _66 = max(_66, 0.001000000047497451305389404296875f);
    _66 = rsqrt(_66);
    _76 = _66.xxx * _76;
    _112.z = dot(_44, _76);
    _112.z = clamp(_112.z, 0.0f, 1.0f);
    _44.x = dot(_44, _34_m1.xyz);
    _44.x = clamp(_44.x, 0.0f, 1.0f);
    _112.x = dot(_34_m1.xyz, _76);
    _112.x = clamp(_112.x, 0.0f, 1.0f);
    float2 _147 = _112.xz * _112.xz;
    _112 = float3(_147.x, _147.y, _112.z);
    _112.x = max(_112.x, 0.100000001490116119384765625f);
    _156 = _MetallicGlossMap.Sample(sampler_MetallicGlossMap, vs_TEXCOORD0).xw;
    _66 = ((-_156.y) * _34_m5) + 1.0f;
    _170.x = _66 * _66;
    _66 = (_66 * _66) + 0.5f;
    _112.x = _66 * _112.x;
    _66 = (_170.x * _170.x) + (-1.0f);
    _170.x *= _170.x;
    _197 = (_112.y * _66) + 1.000010013580322265625f;
    _197 *= _197;
    _112.x = _197 * _112.x;
    _112.x *= 4.0f;
    _112.x = _170.x / _112.x;
    _112.x += (-9.9999997473787516355514526367188e-05f);
    _112.x = max(_112.x, 0.0f);
    _112.x = min(_112.x, 100.0f);
    _237 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = (_237 * _34_m3.xyz) + (-0.039999999105930328369140625f).xxx;
    _170 = _237 * _34_m3.xyz;
    _22 = (_156.xxx * _22) + 0.039999999105930328369140625f.xxx;
    _264 = ((-_156.x) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _112 = _112.xxx * _22;
    _112 = (_170 * _264.xxx) + _112;
    _112 *= _34_m2.xyz;
    _44 = _44.xxx * _112;
    _292 = float4(_44.x, _44.y, _44.z, _292.w);
    _292.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._292 = _292;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Diffuse"
}