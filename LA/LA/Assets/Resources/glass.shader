// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SoreBones/Glass" {
Properties {

_Overlay ("Overlay", 2D) = "white" { }

_OverlayColor ("Overlay Color", Color) = (1,1,1,1)

_DistortionNormal ("Distortion Normal", 2D) = "bump" { }

_DistortionTiling ("Distortion Tiling", Float) = 0.30000001192092896

_DistortionNormalStr ("Distortion Normal Strength", Float) = 1.0

_TilableNormal ("Tilable Normal", 2D) = "bump" { }

_Color ("Color", Color) = (1,1,1,1)

_Emission ("Emission", Color) = (0,0,0,0)

_Smoothness ("Smoothness", Float) = 1.0

_Metallic ("Metallic", Float) = 0.0

_Cubemap ("Cubemap", Cube) = "" { }

_Distortion ("Distortion", Float) = 0.0

}
SubShader {
 LOD 100
 Tags { "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  LOD 100
  Tags { "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
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
float4 _Overlay_ST;
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
#define _21_m6 _Overlay_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _141;
static float3 _153;
static float3 vs_TEXCOORD2;
static float4 _190;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _141 : TEXCOORD0;
    float3 _153 : NORMAL;
    float4 _190 : TANGENT;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _172;
static float3 _239;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
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
    vs_TEXCOORD5 = exp2(-_9.x);
    vs_TEXCOORD0 = (_141 * _21_m6.xy) + _21_m6.zw;
    _9.x = dot(_153, _21_m2[0].xyz);
    _9.y = dot(_153, _21_m2[1].xyz);
    _9.z = dot(_153, _21_m2[2].xyz);
    _172 = dot(_9.xyz, _9.xyz);
    _172 = rsqrt(_172);
    float3 _184 = _172.xxx * _9.xyz;
    _9 = float4(_184.x, _184.y, _184.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _196 = _190.yyy * _21_m1[1].xyz;
    _44 = float4(_196.x, _196.y, _196.z, _44.w);
    float3 _207 = (_21_m1[0].xyz * _190.xxx) + _44.xyz;
    _44 = float4(_207.x, _207.y, _207.z, _44.w);
    float3 _218 = (_21_m1[2].xyz * _190.zzz) + _44.xyz;
    _44 = float4(_218.x, _218.y, _218.z, _44.w);
    _172 = dot(_44.xyz, _44.xyz);
    _172 = rsqrt(_172);
    float3 _232 = _172.xxx * _44.xyz;
    _44 = float4(_232.x, _232.y, _232.z, _44.w);
    vs_TEXCOORD3 = _44.xyz;
    _239 = _9.zxy * _44.yzx;
    float3 _252 = (_9.yzx * _44.zxy) + (-_239);
    _9 = float4(_252.x, _252.y, _252.z, _9.w);
    float3 _259 = _9.xyz * _190.www;
    _9 = float4(_259.x, _259.y, _259.z, _9.w);
    vs_TEXCOORD4 = _9.xyz * _21_m3.www;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _153 = stage_input._153;
    _190 = stage_input._190;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _OverlayColor;
float4 _Color;
float4 _Emission;
float _Smoothness;
float _Metallic;
float _DistortionTiling;
float _DistortionNormalStr;
float _Distortion;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 unity_FogColor
#define _17_m2 _OverlayColor
#define _17_m3 _Color
#define _17_m4 _Emission
#define _17_m5 _Smoothness
#define _17_m6 _Metallic
#define _17_m7 _DistortionTiling
#define _17_m8 _DistortionNormalStr
#define _17_m9 _Distortion


Texture2D<float4> _DistortionNormal;
SamplerState sampler_DistortionNormal;
Texture2D<float4> _TilableNormal;
SamplerState sampler_TilableNormal;
TextureCube<float4> _Cubemap;
SamplerState sampler_Cubemap;
Texture2D<float4> _Overlay;
SamplerState sampler_Overlay;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD5;
static float4 _521;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _521 : SV_Target0;
};

static float4 _9;
static float4 _36;
static float3 _50;
static float3 _56;
static float3 _64;
static float _84;
static float3 _91;
static float3 _96;
static float3 _122;
static float3 _136;
static float4 _179;
static float _223;
static float _291;
static float3 _461;

void frag_inner()
{
    _9 = vs_TEXCOORD1.yzxz * float4(float4(_17_m7, _17_m7, _17_m7, _17_m7));
    float3 _46 = _DistortionNormal.Sample(sampler_DistortionNormal, _9.xy).xyz;
    _36 = float4(_46.x, _46.y, _46.z, _36.w);
    _50 = _DistortionNormal.Sample(sampler_DistortionNormal, _9.zw).xyz;
    _56 = (_50 * 2.0f.xxx) + (-1.0f).xxx;
    _64 = (_36.xyz * 2.0f.xxx) + (-1.0f).xxx;
    float2 _80 = _64.xy * float2(float2(_17_m8, _17_m8));
    _9 = float4(_80.x, _80.y, _9.z, _9.w);
    _84 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _84 = rsqrt(_84);
    _91 = _84.xxx * vs_TEXCOORD2;
    _96 = abs(_91) * abs(_91);
    _96 *= _96;
    _96 = min(_96, 1.0f.xxx);
    _84 = dot(_96, 1.0f.xxx);
    _96 /= _84.xxx;
    float2 _119 = _9.xy * _96.xx;
    _9 = float4(_119.x, _119.y, _9.z, _9.w);
    float2 _133 = _56.xy * float2(float2(_17_m8, _17_m8));
    _122 = float3(_133.x, _133.y, _122.z);
    _136.z = _56.z * _96.y;
    float2 _150 = _96.yy * _122.xy;
    _136 = float3(_150.x, _150.y, _136.z);
    _9.z = _64.z * _96.x;
    float3 _163 = _9.xyz + _136;
    _9 = float4(_163.x, _163.y, _163.z, _9.w);
    float2 _176 = vs_TEXCOORD1.xy * float2(float2(_17_m7, _17_m7));
    _96 = float3(_176.x, _176.y, _96.z);
    float3 _184 = _DistortionNormal.Sample(sampler_DistortionNormal, _96.xy).xyz;
    _179 = float4(_184.x, _184.y, _179.z, _184.z);
    _56 = (_179.xyw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _201 = _56.xy * float2(float2(_17_m8, _17_m8));
    _96 = float3(_201.x, _201.y, _96.z);
    _122.z = _96.z * _56.z;
    float2 _214 = _96.zz * _96.xy;
    _122 = float3(_214.x, _214.y, _122.z);
    float3 _220 = _9.xyz + _122;
    _9 = float4(_220.x, _220.y, _220.z, _9.w);
    _223 = dot(_9.xyz, _9.xyz);
    _223 = rsqrt(_223);
    _84 = _223 * _9.z;
    float3 _241 = _TilableNormal.Sample(sampler_TilableNormal, vs_TEXCOORD0).xyz;
    _179 = float4(_241.x, _241.y, _241.z, _179.w);
    _56 = (_179.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _96.z = _84 * _56.z;
    float2 _260 = (_9.xy * _223.xx) + _56.xy;
    _96 = float3(_260.x, _260.y, _96.z);
    _9.x = dot(_96, _96);
    _9.x = rsqrt(_9.x);
    float3 _274 = _9.xxx * _96;
    _9 = float4(_274.x, _274.y, _274.z, _9.w);
    _223 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _223 = rsqrt(_223);
    _96 = _223.xxx * vs_TEXCOORD4;
    _96 = _9.yyy * _96;
    _291 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _291 = rsqrt(_291);
    _122 = _291.xxx * vs_TEXCOORD3;
    float3 _307 = (_9.xxx * _122) + _96;
    _9 = float4(_307.x, _307.y, _9.z, _307.z);
    float3 _316 = (_9.zzz * _91) + _9.xyw;
    _9 = float4(_316.x, _316.y, _316.z, _9.w);
    _223 = dot(_9.xyz, _9.xyz);
    _223 = rsqrt(_223);
    float3 _330 = _223.xxx * _9.xyz;
    _9 = float4(_330.x, _330.y, _330.z, _9.w);
    _96 = (-vs_TEXCOORD1) + _17_m0;
    _223 = dot(_96, _96);
    _223 = rsqrt(_223);
    _96 = _223.xxx * _96;
    _122 = _96.yzx * float3(1.0f, 0.0f, 0.0f);
    _122 = (_96.zxy * float3(0.0f, 1.0f, 0.0f)) + (-_122);
    _122 = (_122 * (-8.7422776573475857730954885482788e-08f).xxx) + (-_96);
    _122 = (_96.zzz * float3(0.0f, 0.0f, 2.0f)) + _122;
    _223 = dot(_91, _96);
    _223 = clamp(_223, 0.0f, 1.0f);
    _223 = (-_223) + 1.0f;
    float3 _390 = (_17_m9.xxx * _9.xyz) + _122;
    _9 = float4(_390.x, _390.y, _390.z, _9.w);
    _50 = _Cubemap.Sample(sampler_Cubemap, _9.xyz).xyz;
    _36 = _Overlay.Sample(sampler_Overlay, vs_TEXCOORD0);
    _91 = (_17_m2.xyz * _36.xyz) + (-_50);
    float3 _422 = (_36.www * _91) + _50;
    _9 = float4(_422.x, _422.y, _422.z, _9.w);
    _91.x = (-_36.w) + 1.0f;
    float2 _440 = _91.xx * float2(_17_m5, _17_m6);
    _91 = float3(_440.x, _440.y, _91.z);
    _96 = (_9.xyz * _17_m3.xyz) + (-0.039999999105930328369140625f).xxx;
    float3 _458 = _9.xyz * _17_m3.xyz;
    _9 = float4(_458.x, _458.y, _458.z, _9.w);
    _461 = (_91.yyy * _96) + 0.039999999105930328369140625f.xxx;
    _96.x = _223 * _223;
    _96.x *= _96.x;
    _223 *= _96.x;
    _223 = _91.x * _223;
    _91 = (_461 * _223.xxx) + _9.xyz;
    float3 _502 = (_9.xyz * _17_m4.xyz) + _91;
    _9 = float4(_502.x, _502.y, _502.z, _9.w);
    float3 _512 = _9.xyz + (-_17_m1.xyz);
    _9 = float4(_512.x, _512.y, _512.z, _9.w);
    _223 = vs_TEXCOORD5;
    _223 = clamp(_223, 0.0f, 1.0f);
    float3 _530 = (_223.xxx * _9.xyz) + _17_m1.xyz;
    _521 = float4(_530.x, _530.y, _530.z, _521.w);
    _521.w = _17_m3.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._521 = _521;
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
float4 _Overlay_ST;
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
#define _21_m6 _Overlay_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _147;
static float3 _159;
static float3 vs_TEXCOORD2;
static float4 _196;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _147 : TEXCOORD0;
    float3 _159 : NORMAL;
    float4 _196 : TANGENT;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _178;
static float3 _245;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
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
    vs_TEXCOORD5 = exp2(_9.x);
    vs_TEXCOORD0 = (_147 * _21_m6.xy) + _21_m6.zw;
    _9.x = dot(_159, _21_m2[0].xyz);
    _9.y = dot(_159, _21_m2[1].xyz);
    _9.z = dot(_159, _21_m2[2].xyz);
    _178 = dot(_9.xyz, _9.xyz);
    _178 = rsqrt(_178);
    float3 _190 = _178.xxx * _9.xyz;
    _9 = float4(_190.x, _190.y, _190.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _202 = _196.yyy * _21_m1[1].xyz;
    _44 = float4(_202.x, _202.y, _202.z, _44.w);
    float3 _213 = (_21_m1[0].xyz * _196.xxx) + _44.xyz;
    _44 = float4(_213.x, _213.y, _213.z, _44.w);
    float3 _224 = (_21_m1[2].xyz * _196.zzz) + _44.xyz;
    _44 = float4(_224.x, _224.y, _224.z, _44.w);
    _178 = dot(_44.xyz, _44.xyz);
    _178 = rsqrt(_178);
    float3 _238 = _178.xxx * _44.xyz;
    _44 = float4(_238.x, _238.y, _238.z, _44.w);
    vs_TEXCOORD3 = _44.xyz;
    _245 = _9.zxy * _44.yzx;
    float3 _258 = (_9.yzx * _44.zxy) + (-_245);
    _9 = float4(_258.x, _258.y, _258.z, _9.w);
    float3 _265 = _9.xyz * _196.www;
    _9 = float4(_265.x, _265.y, _265.z, _9.w);
    vs_TEXCOORD4 = _9.xyz * _21_m3.www;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _159 = stage_input._159;
    _196 = stage_input._196;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _OverlayColor;
float4 _Color;
float4 _Emission;
float _Smoothness;
float _Metallic;
float _DistortionTiling;
float _DistortionNormalStr;
float _Distortion;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 unity_FogColor
#define _17_m2 _OverlayColor
#define _17_m3 _Color
#define _17_m4 _Emission
#define _17_m5 _Smoothness
#define _17_m6 _Metallic
#define _17_m7 _DistortionTiling
#define _17_m8 _DistortionNormalStr
#define _17_m9 _Distortion


Texture2D<float4> _DistortionNormal;
SamplerState sampler_DistortionNormal;
Texture2D<float4> _TilableNormal;
SamplerState sampler_TilableNormal;
TextureCube<float4> _Cubemap;
SamplerState sampler_Cubemap;
Texture2D<float4> _Overlay;
SamplerState sampler_Overlay;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD5;
static float4 _521;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _521 : SV_Target0;
};

static float4 _9;
static float4 _36;
static float3 _50;
static float3 _56;
static float3 _64;
static float _84;
static float3 _91;
static float3 _96;
static float3 _122;
static float3 _136;
static float4 _179;
static float _223;
static float _291;
static float3 _461;

void frag_inner()
{
    _9 = vs_TEXCOORD1.yzxz * float4(float4(_17_m7, _17_m7, _17_m7, _17_m7));
    float3 _46 = _DistortionNormal.Sample(sampler_DistortionNormal, _9.xy).xyz;
    _36 = float4(_46.x, _46.y, _46.z, _36.w);
    _50 = _DistortionNormal.Sample(sampler_DistortionNormal, _9.zw).xyz;
    _56 = (_50 * 2.0f.xxx) + (-1.0f).xxx;
    _64 = (_36.xyz * 2.0f.xxx) + (-1.0f).xxx;
    float2 _80 = _64.xy * float2(float2(_17_m8, _17_m8));
    _9 = float4(_80.x, _80.y, _9.z, _9.w);
    _84 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _84 = rsqrt(_84);
    _91 = _84.xxx * vs_TEXCOORD2;
    _96 = abs(_91) * abs(_91);
    _96 *= _96;
    _96 = min(_96, 1.0f.xxx);
    _84 = dot(_96, 1.0f.xxx);
    _96 /= _84.xxx;
    float2 _119 = _9.xy * _96.xx;
    _9 = float4(_119.x, _119.y, _9.z, _9.w);
    float2 _133 = _56.xy * float2(float2(_17_m8, _17_m8));
    _122 = float3(_133.x, _133.y, _122.z);
    _136.z = _56.z * _96.y;
    float2 _150 = _96.yy * _122.xy;
    _136 = float3(_150.x, _150.y, _136.z);
    _9.z = _64.z * _96.x;
    float3 _163 = _9.xyz + _136;
    _9 = float4(_163.x, _163.y, _163.z, _9.w);
    float2 _176 = vs_TEXCOORD1.xy * float2(float2(_17_m7, _17_m7));
    _96 = float3(_176.x, _176.y, _96.z);
    float3 _184 = _DistortionNormal.Sample(sampler_DistortionNormal, _96.xy).xyz;
    _179 = float4(_184.x, _184.y, _179.z, _184.z);
    _56 = (_179.xyw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _201 = _56.xy * float2(float2(_17_m8, _17_m8));
    _96 = float3(_201.x, _201.y, _96.z);
    _122.z = _96.z * _56.z;
    float2 _214 = _96.zz * _96.xy;
    _122 = float3(_214.x, _214.y, _122.z);
    float3 _220 = _9.xyz + _122;
    _9 = float4(_220.x, _220.y, _220.z, _9.w);
    _223 = dot(_9.xyz, _9.xyz);
    _223 = rsqrt(_223);
    _84 = _223 * _9.z;
    float3 _241 = _TilableNormal.Sample(sampler_TilableNormal, vs_TEXCOORD0).xyz;
    _179 = float4(_241.x, _241.y, _241.z, _179.w);
    _56 = (_179.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _96.z = _84 * _56.z;
    float2 _260 = (_9.xy * _223.xx) + _56.xy;
    _96 = float3(_260.x, _260.y, _96.z);
    _9.x = dot(_96, _96);
    _9.x = rsqrt(_9.x);
    float3 _274 = _9.xxx * _96;
    _9 = float4(_274.x, _274.y, _274.z, _9.w);
    _223 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _223 = rsqrt(_223);
    _96 = _223.xxx * vs_TEXCOORD4;
    _96 = _9.yyy * _96;
    _291 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _291 = rsqrt(_291);
    _122 = _291.xxx * vs_TEXCOORD3;
    float3 _307 = (_9.xxx * _122) + _96;
    _9 = float4(_307.x, _307.y, _9.z, _307.z);
    float3 _316 = (_9.zzz * _91) + _9.xyw;
    _9 = float4(_316.x, _316.y, _316.z, _9.w);
    _223 = dot(_9.xyz, _9.xyz);
    _223 = rsqrt(_223);
    float3 _330 = _223.xxx * _9.xyz;
    _9 = float4(_330.x, _330.y, _330.z, _9.w);
    _96 = (-vs_TEXCOORD1) + _17_m0;
    _223 = dot(_96, _96);
    _223 = rsqrt(_223);
    _96 = _223.xxx * _96;
    _122 = _96.yzx * float3(1.0f, 0.0f, 0.0f);
    _122 = (_96.zxy * float3(0.0f, 1.0f, 0.0f)) + (-_122);
    _122 = (_122 * (-8.7422776573475857730954885482788e-08f).xxx) + (-_96);
    _122 = (_96.zzz * float3(0.0f, 0.0f, 2.0f)) + _122;
    _223 = dot(_91, _96);
    _223 = clamp(_223, 0.0f, 1.0f);
    _223 = (-_223) + 1.0f;
    float3 _390 = (_17_m9.xxx * _9.xyz) + _122;
    _9 = float4(_390.x, _390.y, _390.z, _9.w);
    _50 = _Cubemap.Sample(sampler_Cubemap, _9.xyz).xyz;
    _36 = _Overlay.Sample(sampler_Overlay, vs_TEXCOORD0);
    _91 = (_17_m2.xyz * _36.xyz) + (-_50);
    float3 _422 = (_36.www * _91) + _50;
    _9 = float4(_422.x, _422.y, _422.z, _9.w);
    _91.x = (-_36.w) + 1.0f;
    float2 _440 = _91.xx * float2(_17_m5, _17_m6);
    _91 = float3(_440.x, _440.y, _91.z);
    _96 = (_9.xyz * _17_m3.xyz) + (-0.039999999105930328369140625f).xxx;
    float3 _458 = _9.xyz * _17_m3.xyz;
    _9 = float4(_458.x, _458.y, _458.z, _9.w);
    _461 = (_91.yyy * _96) + 0.039999999105930328369140625f.xxx;
    _96.x = _223 * _223;
    _96.x *= _96.x;
    _223 *= _96.x;
    _223 = _91.x * _223;
    _91 = (_461 * _223.xxx) + _9.xyz;
    float3 _502 = (_9.xyz * _17_m4.xyz) + _91;
    _9 = float4(_502.x, _502.y, _502.z, _9.w);
    float3 _512 = _9.xyz + (-_17_m1.xyz);
    _9 = float4(_512.x, _512.y, _512.z, _9.w);
    _223 = vs_TEXCOORD5;
    _223 = clamp(_223, 0.0f, 1.0f);
    float3 _530 = (_223.xxx * _9.xyz) + _17_m1.xyz;
    _521 = float4(_530.x, _530.y, _530.z, _521.w);
    _521.w = _17_m3.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._521 = _521;
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
float4 _Overlay_ST;
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
#define _21_m6 _Overlay_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _152;
static float3 vs_TEXCOORD2;
static float4 _189;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _140 : TEXCOORD0;
    float3 _152 : NORMAL;
    float4 _189 : TANGENT;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _171;
static float3 _238;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD5 = (_9.x * _21_m5.z) + _21_m5.w;
    vs_TEXCOORD0 = (_140 * _21_m6.xy) + _21_m6.zw;
    _9.x = dot(_152, _21_m2[0].xyz);
    _9.y = dot(_152, _21_m2[1].xyz);
    _9.z = dot(_152, _21_m2[2].xyz);
    _171 = dot(_9.xyz, _9.xyz);
    _171 = rsqrt(_171);
    float3 _183 = _171.xxx * _9.xyz;
    _9 = float4(_183.x, _183.y, _183.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _195 = _189.yyy * _21_m1[1].xyz;
    _44 = float4(_195.x, _195.y, _195.z, _44.w);
    float3 _206 = (_21_m1[0].xyz * _189.xxx) + _44.xyz;
    _44 = float4(_206.x, _206.y, _206.z, _44.w);
    float3 _217 = (_21_m1[2].xyz * _189.zzz) + _44.xyz;
    _44 = float4(_217.x, _217.y, _217.z, _44.w);
    _171 = dot(_44.xyz, _44.xyz);
    _171 = rsqrt(_171);
    float3 _231 = _171.xxx * _44.xyz;
    _44 = float4(_231.x, _231.y, _231.z, _44.w);
    vs_TEXCOORD3 = _44.xyz;
    _238 = _9.zxy * _44.yzx;
    float3 _251 = (_9.yzx * _44.zxy) + (-_238);
    _9 = float4(_251.x, _251.y, _251.z, _9.w);
    float3 _258 = _9.xyz * _189.www;
    _9 = float4(_258.x, _258.y, _258.z, _9.w);
    vs_TEXCOORD4 = _9.xyz * _21_m3.www;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _152 = stage_input._152;
    _189 = stage_input._189;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _OverlayColor;
float4 _Color;
float4 _Emission;
float _Smoothness;
float _Metallic;
float _DistortionTiling;
float _DistortionNormalStr;
float _Distortion;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 unity_FogColor
#define _17_m2 _OverlayColor
#define _17_m3 _Color
#define _17_m4 _Emission
#define _17_m5 _Smoothness
#define _17_m6 _Metallic
#define _17_m7 _DistortionTiling
#define _17_m8 _DistortionNormalStr
#define _17_m9 _Distortion


Texture2D<float4> _DistortionNormal;
SamplerState sampler_DistortionNormal;
Texture2D<float4> _TilableNormal;
SamplerState sampler_TilableNormal;
TextureCube<float4> _Cubemap;
SamplerState sampler_Cubemap;
Texture2D<float4> _Overlay;
SamplerState sampler_Overlay;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD5;
static float4 _521;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _521 : SV_Target0;
};

static float4 _9;
static float4 _36;
static float3 _50;
static float3 _56;
static float3 _64;
static float _84;
static float3 _91;
static float3 _96;
static float3 _122;
static float3 _136;
static float4 _179;
static float _223;
static float _291;
static float3 _461;

void frag_inner()
{
    _9 = vs_TEXCOORD1.yzxz * float4(float4(_17_m7, _17_m7, _17_m7, _17_m7));
    float3 _46 = _DistortionNormal.Sample(sampler_DistortionNormal, _9.xy).xyz;
    _36 = float4(_46.x, _46.y, _46.z, _36.w);
    _50 = _DistortionNormal.Sample(sampler_DistortionNormal, _9.zw).xyz;
    _56 = (_50 * 2.0f.xxx) + (-1.0f).xxx;
    _64 = (_36.xyz * 2.0f.xxx) + (-1.0f).xxx;
    float2 _80 = _64.xy * float2(float2(_17_m8, _17_m8));
    _9 = float4(_80.x, _80.y, _9.z, _9.w);
    _84 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _84 = rsqrt(_84);
    _91 = _84.xxx * vs_TEXCOORD2;
    _96 = abs(_91) * abs(_91);
    _96 *= _96;
    _96 = min(_96, 1.0f.xxx);
    _84 = dot(_96, 1.0f.xxx);
    _96 /= _84.xxx;
    float2 _119 = _9.xy * _96.xx;
    _9 = float4(_119.x, _119.y, _9.z, _9.w);
    float2 _133 = _56.xy * float2(float2(_17_m8, _17_m8));
    _122 = float3(_133.x, _133.y, _122.z);
    _136.z = _56.z * _96.y;
    float2 _150 = _96.yy * _122.xy;
    _136 = float3(_150.x, _150.y, _136.z);
    _9.z = _64.z * _96.x;
    float3 _163 = _9.xyz + _136;
    _9 = float4(_163.x, _163.y, _163.z, _9.w);
    float2 _176 = vs_TEXCOORD1.xy * float2(float2(_17_m7, _17_m7));
    _96 = float3(_176.x, _176.y, _96.z);
    float3 _184 = _DistortionNormal.Sample(sampler_DistortionNormal, _96.xy).xyz;
    _179 = float4(_184.x, _184.y, _179.z, _184.z);
    _56 = (_179.xyw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _201 = _56.xy * float2(float2(_17_m8, _17_m8));
    _96 = float3(_201.x, _201.y, _96.z);
    _122.z = _96.z * _56.z;
    float2 _214 = _96.zz * _96.xy;
    _122 = float3(_214.x, _214.y, _122.z);
    float3 _220 = _9.xyz + _122;
    _9 = float4(_220.x, _220.y, _220.z, _9.w);
    _223 = dot(_9.xyz, _9.xyz);
    _223 = rsqrt(_223);
    _84 = _223 * _9.z;
    float3 _241 = _TilableNormal.Sample(sampler_TilableNormal, vs_TEXCOORD0).xyz;
    _179 = float4(_241.x, _241.y, _241.z, _179.w);
    _56 = (_179.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _96.z = _84 * _56.z;
    float2 _260 = (_9.xy * _223.xx) + _56.xy;
    _96 = float3(_260.x, _260.y, _96.z);
    _9.x = dot(_96, _96);
    _9.x = rsqrt(_9.x);
    float3 _274 = _9.xxx * _96;
    _9 = float4(_274.x, _274.y, _274.z, _9.w);
    _223 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _223 = rsqrt(_223);
    _96 = _223.xxx * vs_TEXCOORD4;
    _96 = _9.yyy * _96;
    _291 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _291 = rsqrt(_291);
    _122 = _291.xxx * vs_TEXCOORD3;
    float3 _307 = (_9.xxx * _122) + _96;
    _9 = float4(_307.x, _307.y, _9.z, _307.z);
    float3 _316 = (_9.zzz * _91) + _9.xyw;
    _9 = float4(_316.x, _316.y, _316.z, _9.w);
    _223 = dot(_9.xyz, _9.xyz);
    _223 = rsqrt(_223);
    float3 _330 = _223.xxx * _9.xyz;
    _9 = float4(_330.x, _330.y, _330.z, _9.w);
    _96 = (-vs_TEXCOORD1) + _17_m0;
    _223 = dot(_96, _96);
    _223 = rsqrt(_223);
    _96 = _223.xxx * _96;
    _122 = _96.yzx * float3(1.0f, 0.0f, 0.0f);
    _122 = (_96.zxy * float3(0.0f, 1.0f, 0.0f)) + (-_122);
    _122 = (_122 * (-8.7422776573475857730954885482788e-08f).xxx) + (-_96);
    _122 = (_96.zzz * float3(0.0f, 0.0f, 2.0f)) + _122;
    _223 = dot(_91, _96);
    _223 = clamp(_223, 0.0f, 1.0f);
    _223 = (-_223) + 1.0f;
    float3 _390 = (_17_m9.xxx * _9.xyz) + _122;
    _9 = float4(_390.x, _390.y, _390.z, _9.w);
    _50 = _Cubemap.Sample(sampler_Cubemap, _9.xyz).xyz;
    _36 = _Overlay.Sample(sampler_Overlay, vs_TEXCOORD0);
    _91 = (_17_m2.xyz * _36.xyz) + (-_50);
    float3 _422 = (_36.www * _91) + _50;
    _9 = float4(_422.x, _422.y, _422.z, _9.w);
    _91.x = (-_36.w) + 1.0f;
    float2 _440 = _91.xx * float2(_17_m5, _17_m6);
    _91 = float3(_440.x, _440.y, _91.z);
    _96 = (_9.xyz * _17_m3.xyz) + (-0.039999999105930328369140625f).xxx;
    float3 _458 = _9.xyz * _17_m3.xyz;
    _9 = float4(_458.x, _458.y, _458.z, _9.w);
    _461 = (_91.yyy * _96) + 0.039999999105930328369140625f.xxx;
    _96.x = _223 * _223;
    _96.x *= _96.x;
    _223 *= _96.x;
    _223 = _91.x * _223;
    _91 = (_461 * _223.xxx) + _9.xyz;
    float3 _502 = (_9.xyz * _17_m4.xyz) + _91;
    _9 = float4(_502.x, _502.y, _502.z, _9.w);
    float3 _512 = _9.xyz + (-_17_m1.xyz);
    _9 = float4(_512.x, _512.y, _512.z, _9.w);
    _223 = vs_TEXCOORD5;
    _223 = clamp(_223, 0.0f, 1.0f);
    float3 _530 = (_223.xxx * _9.xyz) + _17_m1.xyz;
    _521 = float4(_530.x, _530.y, _530.z, _521.w);
    _521.w = _17_m3.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._521 = _521;
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
float4 _Overlay_ST;
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
#define _21_m4 _Overlay_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _111;
static float3 vs_TEXCOORD2;
static float4 _151;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _99 : TEXCOORD0;
    float3 _111 : NORMAL;
    float4 _151 : TANGENT;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _133;
static float3 _200;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    gl_Position = (_21_m3[3] * _44.wwww) + _9;
    vs_TEXCOORD0 = (_99 * _21_m4.xy) + _21_m4.zw;
    _9.x = dot(_111, _21_m1[0].xyz);
    _9.y = dot(_111, _21_m1[1].xyz);
    _9.z = dot(_111, _21_m1[2].xyz);
    _133 = dot(_9.xyz, _9.xyz);
    _133 = rsqrt(_133);
    float3 _145 = _133.xxx * _9.xyz;
    _9 = float4(_145.x, _145.y, _145.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _157 = _151.yyy * _21_m0[1].xyz;
    _44 = float4(_157.x, _157.y, _157.z, _44.w);
    float3 _168 = (_21_m0[0].xyz * _151.xxx) + _44.xyz;
    _44 = float4(_168.x, _168.y, _168.z, _44.w);
    float3 _179 = (_21_m0[2].xyz * _151.zzz) + _44.xyz;
    _44 = float4(_179.x, _179.y, _179.z, _44.w);
    _133 = dot(_44.xyz, _44.xyz);
    _133 = rsqrt(_133);
    float3 _193 = _133.xxx * _44.xyz;
    _44 = float4(_193.x, _193.y, _193.z, _44.w);
    vs_TEXCOORD3 = _44.xyz;
    _200 = _9.zxy * _44.yzx;
    float3 _213 = (_9.yzx * _44.zxy) + (-_200);
    _9 = float4(_213.x, _213.y, _213.z, _9.w);
    float3 _220 = _9.xyz * _151.www;
    _9 = float4(_220.x, _220.y, _220.z, _9.w);
    vs_TEXCOORD4 = _9.xyz * _21_m2.www;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _111 = stage_input._111;
    _151 = stage_input._151;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _OverlayColor;
float4 _Color;
float4 _Emission;
float _Smoothness;
float _Metallic;
float _DistortionTiling;
float _DistortionNormalStr;
float _Distortion;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _OverlayColor
#define _17_m2 _Color
#define _17_m3 _Emission
#define _17_m4 _Smoothness
#define _17_m5 _Metallic
#define _17_m6 _DistortionTiling
#define _17_m7 _DistortionNormalStr
#define _17_m8 _Distortion


Texture2D<float4> _DistortionNormal;
SamplerState sampler_DistortionNormal;
Texture2D<float4> _TilableNormal;
SamplerState sampler_TilableNormal;
TextureCube<float4> _Cubemap;
SamplerState sampler_Cubemap;
Texture2D<float4> _Overlay;
SamplerState sampler_Overlay;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _495;

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
    float4 _495 : SV_Target0;
};

static float4 _9;
static float4 _36;
static float3 _50;
static float3 _56;
static float3 _64;
static float _84;
static float3 _91;
static float3 _96;
static float3 _122;
static float3 _136;
static float4 _179;
static float _223;
static float _291;
static float3 _461;

void frag_inner()
{
    _9 = vs_TEXCOORD1.yzxz * float4(float4(_17_m6, _17_m6, _17_m6, _17_m6));
    float3 _46 = _DistortionNormal.Sample(sampler_DistortionNormal, _9.xy).xyz;
    _36 = float4(_46.x, _46.y, _46.z, _36.w);
    _50 = _DistortionNormal.Sample(sampler_DistortionNormal, _9.zw).xyz;
    _56 = (_50 * 2.0f.xxx) + (-1.0f).xxx;
    _64 = (_36.xyz * 2.0f.xxx) + (-1.0f).xxx;
    float2 _80 = _64.xy * float2(float2(_17_m7, _17_m7));
    _9 = float4(_80.x, _80.y, _9.z, _9.w);
    _84 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _84 = rsqrt(_84);
    _91 = _84.xxx * vs_TEXCOORD2;
    _96 = abs(_91) * abs(_91);
    _96 *= _96;
    _96 = min(_96, 1.0f.xxx);
    _84 = dot(_96, 1.0f.xxx);
    _96 /= _84.xxx;
    float2 _119 = _9.xy * _96.xx;
    _9 = float4(_119.x, _119.y, _9.z, _9.w);
    float2 _133 = _56.xy * float2(float2(_17_m7, _17_m7));
    _122 = float3(_133.x, _133.y, _122.z);
    _136.z = _56.z * _96.y;
    float2 _150 = _96.yy * _122.xy;
    _136 = float3(_150.x, _150.y, _136.z);
    _9.z = _64.z * _96.x;
    float3 _163 = _9.xyz + _136;
    _9 = float4(_163.x, _163.y, _163.z, _9.w);
    float2 _176 = vs_TEXCOORD1.xy * float2(float2(_17_m6, _17_m6));
    _96 = float3(_176.x, _176.y, _96.z);
    float3 _184 = _DistortionNormal.Sample(sampler_DistortionNormal, _96.xy).xyz;
    _179 = float4(_184.x, _184.y, _179.z, _184.z);
    _56 = (_179.xyw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _201 = _56.xy * float2(float2(_17_m7, _17_m7));
    _96 = float3(_201.x, _201.y, _96.z);
    _122.z = _96.z * _56.z;
    float2 _214 = _96.zz * _96.xy;
    _122 = float3(_214.x, _214.y, _122.z);
    float3 _220 = _9.xyz + _122;
    _9 = float4(_220.x, _220.y, _220.z, _9.w);
    _223 = dot(_9.xyz, _9.xyz);
    _223 = rsqrt(_223);
    _84 = _223 * _9.z;
    float3 _241 = _TilableNormal.Sample(sampler_TilableNormal, vs_TEXCOORD0).xyz;
    _179 = float4(_241.x, _241.y, _241.z, _179.w);
    _56 = (_179.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _96.z = _84 * _56.z;
    float2 _260 = (_9.xy * _223.xx) + _56.xy;
    _96 = float3(_260.x, _260.y, _96.z);
    _9.x = dot(_96, _96);
    _9.x = rsqrt(_9.x);
    float3 _274 = _9.xxx * _96;
    _9 = float4(_274.x, _274.y, _274.z, _9.w);
    _223 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _223 = rsqrt(_223);
    _96 = _223.xxx * vs_TEXCOORD4;
    _96 = _9.yyy * _96;
    _291 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _291 = rsqrt(_291);
    _122 = _291.xxx * vs_TEXCOORD3;
    float3 _307 = (_9.xxx * _122) + _96;
    _9 = float4(_307.x, _307.y, _9.z, _307.z);
    float3 _316 = (_9.zzz * _91) + _9.xyw;
    _9 = float4(_316.x, _316.y, _316.z, _9.w);
    _223 = dot(_9.xyz, _9.xyz);
    _223 = rsqrt(_223);
    float3 _330 = _223.xxx * _9.xyz;
    _9 = float4(_330.x, _330.y, _330.z, _9.w);
    _96 = (-vs_TEXCOORD1) + _17_m0;
    _223 = dot(_96, _96);
    _223 = rsqrt(_223);
    _96 = _223.xxx * _96;
    _122 = _96.yzx * float3(1.0f, 0.0f, 0.0f);
    _122 = (_96.zxy * float3(0.0f, 1.0f, 0.0f)) + (-_122);
    _122 = (_122 * (-8.7422776573475857730954885482788e-08f).xxx) + (-_96);
    _122 = (_96.zzz * float3(0.0f, 0.0f, 2.0f)) + _122;
    _223 = dot(_91, _96);
    _223 = clamp(_223, 0.0f, 1.0f);
    _223 = (-_223) + 1.0f;
    float3 _390 = (_17_m8.xxx * _9.xyz) + _122;
    _9 = float4(_390.x, _390.y, _390.z, _9.w);
    _50 = _Cubemap.Sample(sampler_Cubemap, _9.xyz).xyz;
    _36 = _Overlay.Sample(sampler_Overlay, vs_TEXCOORD0);
    _91 = (_17_m1.xyz * _36.xyz) + (-_50);
    float3 _422 = (_36.www * _91) + _50;
    _9 = float4(_422.x, _422.y, _422.z, _9.w);
    _91.x = (-_36.w) + 1.0f;
    float2 _440 = _91.xx * float2(_17_m4, _17_m5);
    _91 = float3(_440.x, _440.y, _91.z);
    _96 = (_9.xyz * _17_m2.xyz) + (-0.039999999105930328369140625f).xxx;
    float3 _458 = _9.xyz * _17_m2.xyz;
    _9 = float4(_458.x, _458.y, _458.z, _9.w);
    _461 = (_91.yyy * _96) + 0.039999999105930328369140625f.xxx;
    _96.x = _223 * _223;
    _96.x *= _96.x;
    _223 *= _96.x;
    _223 = _91.x * _223;
    _91 = (_461 * _223.xxx) + _9.xyz;
    float3 _504 = (_9.xyz * _17_m3.xyz) + _91;
    _495 = float4(_504.x, _504.y, _504.z, _495.w);
    _495.w = _17_m2.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._495 = _495;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "VertexLit"
}