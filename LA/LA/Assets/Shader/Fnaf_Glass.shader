// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Fnaf/Glass" {
Properties {

_Color ("Tint (alpha = opacity)", Color) = (0.55,0.65,0.7,0.03)

_RimColor ("Rim (alpha = opacity)", Color) = (0.7,0.8,0.85,0.06)

_RimPower ("Rim Power", Range(0.5, 8)) = 3.0

_Reflect ("Reflection strength", Range(0, 2)) = 0.8999999761581421

_DirtTex ("Smudges (R)", 2D) = "black" { }

_DirtColor ("Smudge colour (alpha = opacity)", Color) = (0.75,0.72,0.66,0.22)

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One OneMinusSrcAlpha
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
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _DirtTex_ST;
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
#define _21_m5 _DirtTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _152;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _152 : NORMAL;
    float2 _140 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _171;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD3 = exp2(-_9.x);
    vs_TEXCOORD0 = (_140 * _21_m5.xy) + _21_m5.zw;
    _9.x = dot(_152, _21_m2[0].xyz);
    _9.y = dot(_152, _21_m2[1].xyz);
    _9.z = dot(_152, _21_m2[2].xyz);
    _171 = dot(_9.xyz, _9.xyz);
    _171 = rsqrt(_171);
    vs_TEXCOORD2 = _171.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _152 = stage_input._152;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_SpecCube0_HDR;
float4 _Color;
float4 _RimColor;
float _RimPower;
float _Reflect;
float4 _DirtColor;
#define _76_m0 _WorldSpaceCameraPos
#define _76_m1 unity_SHAr
#define _76_m2 unity_SHAg
#define _76_m3 unity_SHAb
#define _76_m4 unity_SHBr
#define _76_m5 unity_SHBg
#define _76_m6 unity_SHBb
#define _76_m7 unity_SHC
#define _76_m8 unity_SpecCube0_HDR
#define _76_m9 _Color
#define _76_m10 _RimColor
#define _76_m11 _RimPower
#define _76_m12 _Reflect
#define _76_m13 _DirtColor


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _DirtTex;
SamplerState sampler_DirtTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _337;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _337 : SV_Target0;
};

static float4 _9;
static float _30;
static float3 _49;
static float4 _67;
static float4 _73;
static float3 _140;
static float3 _166;
static float _185;
static float4 _190;
static float _238;
static float _330;
static float3 _352;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD2;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _30 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    float3 _45 = _30.xxx * _9.xyz;
    _9 = float4(_45.x, _45.y, _45.z, _9.w);
    _49.x = _9.y * _9.y;
    _49.x = (_9.x * _9.x) + (-_49.x);
    _67 = _9.yzzx * _9.xyzz;
    _73.x = dot(_76_m4, _67);
    _73.y = dot(_76_m5, _67);
    _73.z = dot(_76_m6, _67);
    _49 = (_76_m7.xyz * _49.xxx) + _73.xyz;
    _9.w = 1.0f;
    _67.x = dot(_76_m1, _9);
    _67.y = dot(_76_m2, _9);
    _67.z = dot(_76_m3, _9);
    _49 += _67.xyz;
    _49 = max(_49, 0.0f.xxx);
    _49 *= 1.60000002384185791015625f.xxx;
    _140 = (-vs_TEXCOORD1) + _76_m0;
    _30 = dot(_140, _140);
    _30 = rsqrt(_30);
    _140 = _30.xxx * _140;
    _30 = dot(-_140, _9.xyz);
    _30 += _30;
    _166 = (_9.xyz * (-_30.xxx)) + (-_140);
    _9.x = dot(_9.xyz, _140);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _185 = (-_9.x) + 1.0f;
    _190 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _166, 1.0f);
    _67.x = _190.w + (-1.0f);
    _67.x = (_76_m8.w * _67.x) + 1.0f;
    _67.x = log2(_67.x);
    _67.x *= _76_m8.y;
    _67.x = exp2(_67.x);
    _67.x *= _76_m8.x;
    float3 _235 = _190.xyz * _67.xxx;
    _67 = float4(_235.x, _235.y, _235.z, _67.w);
    _238 = _185 * _185;
    _238 *= _238;
    _238 = _185 * _238;
    _185 = log2(_185);
    _185 *= _76_m11;
    _185 = exp2(_185);
    _238 = (_238 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    float3 _266 = _238.xxx * _67.xyz;
    _67 = float4(_266.x, _266.y, _266.z, _67.w);
    float3 _283 = _67.xyz * float3(float3(_76_m12, _76_m12, _76_m12));
    _67 = float4(_283.x, _283.y, _283.z, _67.w);
    _190.x = _DirtTex.Sample(sampler_DirtTex, vs_TEXCOORD0).x;
    _238 = (_190.x * _76_m13.w) + 1.0f;
    float3 _309 = _238.xxx * _67.xyz;
    _67 = float4(_309.x, _309.y, _309.z, _67.w);
    _73 = (-_76_m9.wxyz) + _76_m10.wxyz;
    _73 = (_185.xxxx * _73) + _76_m9.wxyz;
    _330 = _190.x * _76_m13.w;
    _337.w = (_190.x * _76_m13.w) + _73.x;
    _337.w = clamp(_337.w, 0.0f, 1.0f);
    _352 = _330.xxx * _76_m13.xyz;
    float3 _365 = (_73.yzw * _73.xxx) + _352;
    _73 = float4(_365.x, _365.y, _365.z, _73.w);
    _49 = (_73.xyz * _49) + _67.xyz;
    _9.x = vs_TEXCOORD3;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _386 = _49 * _9.xxx;
    _9 = float4(_386.x, _386.y, _386.z, _9.w);
    _337 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _337.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._337 = _337;
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
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _DirtTex_ST;
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
#define _21_m5 _DirtTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _146;
static float3 _158;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _158 : NORMAL;
    float2 _146 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _177;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD3 = exp2(_9.x);
    vs_TEXCOORD0 = (_146 * _21_m5.xy) + _21_m5.zw;
    _9.x = dot(_158, _21_m2[0].xyz);
    _9.y = dot(_158, _21_m2[1].xyz);
    _9.z = dot(_158, _21_m2[2].xyz);
    _177 = dot(_9.xyz, _9.xyz);
    _177 = rsqrt(_177);
    vs_TEXCOORD2 = _177.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    _158 = stage_input._158;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_SpecCube0_HDR;
float4 _Color;
float4 _RimColor;
float _RimPower;
float _Reflect;
float4 _DirtColor;
#define _76_m0 _WorldSpaceCameraPos
#define _76_m1 unity_SHAr
#define _76_m2 unity_SHAg
#define _76_m3 unity_SHAb
#define _76_m4 unity_SHBr
#define _76_m5 unity_SHBg
#define _76_m6 unity_SHBb
#define _76_m7 unity_SHC
#define _76_m8 unity_SpecCube0_HDR
#define _76_m9 _Color
#define _76_m10 _RimColor
#define _76_m11 _RimPower
#define _76_m12 _Reflect
#define _76_m13 _DirtColor


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _DirtTex;
SamplerState sampler_DirtTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _337;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _337 : SV_Target0;
};

static float4 _9;
static float _30;
static float3 _49;
static float4 _67;
static float4 _73;
static float3 _140;
static float3 _166;
static float _185;
static float4 _190;
static float _238;
static float _330;
static float3 _352;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD2;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _30 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    float3 _45 = _30.xxx * _9.xyz;
    _9 = float4(_45.x, _45.y, _45.z, _9.w);
    _49.x = _9.y * _9.y;
    _49.x = (_9.x * _9.x) + (-_49.x);
    _67 = _9.yzzx * _9.xyzz;
    _73.x = dot(_76_m4, _67);
    _73.y = dot(_76_m5, _67);
    _73.z = dot(_76_m6, _67);
    _49 = (_76_m7.xyz * _49.xxx) + _73.xyz;
    _9.w = 1.0f;
    _67.x = dot(_76_m1, _9);
    _67.y = dot(_76_m2, _9);
    _67.z = dot(_76_m3, _9);
    _49 += _67.xyz;
    _49 = max(_49, 0.0f.xxx);
    _49 *= 1.60000002384185791015625f.xxx;
    _140 = (-vs_TEXCOORD1) + _76_m0;
    _30 = dot(_140, _140);
    _30 = rsqrt(_30);
    _140 = _30.xxx * _140;
    _30 = dot(-_140, _9.xyz);
    _30 += _30;
    _166 = (_9.xyz * (-_30.xxx)) + (-_140);
    _9.x = dot(_9.xyz, _140);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _185 = (-_9.x) + 1.0f;
    _190 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _166, 1.0f);
    _67.x = _190.w + (-1.0f);
    _67.x = (_76_m8.w * _67.x) + 1.0f;
    _67.x = log2(_67.x);
    _67.x *= _76_m8.y;
    _67.x = exp2(_67.x);
    _67.x *= _76_m8.x;
    float3 _235 = _190.xyz * _67.xxx;
    _67 = float4(_235.x, _235.y, _235.z, _67.w);
    _238 = _185 * _185;
    _238 *= _238;
    _238 = _185 * _238;
    _185 = log2(_185);
    _185 *= _76_m11;
    _185 = exp2(_185);
    _238 = (_238 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    float3 _266 = _238.xxx * _67.xyz;
    _67 = float4(_266.x, _266.y, _266.z, _67.w);
    float3 _283 = _67.xyz * float3(float3(_76_m12, _76_m12, _76_m12));
    _67 = float4(_283.x, _283.y, _283.z, _67.w);
    _190.x = _DirtTex.Sample(sampler_DirtTex, vs_TEXCOORD0).x;
    _238 = (_190.x * _76_m13.w) + 1.0f;
    float3 _309 = _238.xxx * _67.xyz;
    _67 = float4(_309.x, _309.y, _309.z, _67.w);
    _73 = (-_76_m9.wxyz) + _76_m10.wxyz;
    _73 = (_185.xxxx * _73) + _76_m9.wxyz;
    _330 = _190.x * _76_m13.w;
    _337.w = (_190.x * _76_m13.w) + _73.x;
    _337.w = clamp(_337.w, 0.0f, 1.0f);
    _352 = _330.xxx * _76_m13.xyz;
    float3 _365 = (_73.yzw * _73.xxx) + _352;
    _73 = float4(_365.x, _365.y, _365.z, _73.w);
    _49 = (_73.xyz * _49) + _67.xyz;
    _9.x = vs_TEXCOORD3;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _386 = _49 * _9.xxx;
    _9 = float4(_386.x, _386.y, _386.z, _9.w);
    _337 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _337.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._337 = _337;
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
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _DirtTex_ST;
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
#define _21_m5 _DirtTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _139;
static float3 _151;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _151 : NORMAL;
    float2 _139 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _170;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD3 = (_9.x * _21_m4.z) + _21_m4.w;
    vs_TEXCOORD0 = (_139 * _21_m5.xy) + _21_m5.zw;
    _9.x = dot(_151, _21_m2[0].xyz);
    _9.y = dot(_151, _21_m2[1].xyz);
    _9.z = dot(_151, _21_m2[2].xyz);
    _170 = dot(_9.xyz, _9.xyz);
    _170 = rsqrt(_170);
    vs_TEXCOORD2 = _170.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _151 = stage_input._151;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_SpecCube0_HDR;
float4 _Color;
float4 _RimColor;
float _RimPower;
float _Reflect;
float4 _DirtColor;
#define _76_m0 _WorldSpaceCameraPos
#define _76_m1 unity_SHAr
#define _76_m2 unity_SHAg
#define _76_m3 unity_SHAb
#define _76_m4 unity_SHBr
#define _76_m5 unity_SHBg
#define _76_m6 unity_SHBb
#define _76_m7 unity_SHC
#define _76_m8 unity_SpecCube0_HDR
#define _76_m9 _Color
#define _76_m10 _RimColor
#define _76_m11 _RimPower
#define _76_m12 _Reflect
#define _76_m13 _DirtColor


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _DirtTex;
SamplerState sampler_DirtTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _337;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _337 : SV_Target0;
};

static float4 _9;
static float _30;
static float3 _49;
static float4 _67;
static float4 _73;
static float3 _140;
static float3 _166;
static float _185;
static float4 _190;
static float _238;
static float _330;
static float3 _352;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD2;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _30 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    float3 _45 = _30.xxx * _9.xyz;
    _9 = float4(_45.x, _45.y, _45.z, _9.w);
    _49.x = _9.y * _9.y;
    _49.x = (_9.x * _9.x) + (-_49.x);
    _67 = _9.yzzx * _9.xyzz;
    _73.x = dot(_76_m4, _67);
    _73.y = dot(_76_m5, _67);
    _73.z = dot(_76_m6, _67);
    _49 = (_76_m7.xyz * _49.xxx) + _73.xyz;
    _9.w = 1.0f;
    _67.x = dot(_76_m1, _9);
    _67.y = dot(_76_m2, _9);
    _67.z = dot(_76_m3, _9);
    _49 += _67.xyz;
    _49 = max(_49, 0.0f.xxx);
    _49 *= 1.60000002384185791015625f.xxx;
    _140 = (-vs_TEXCOORD1) + _76_m0;
    _30 = dot(_140, _140);
    _30 = rsqrt(_30);
    _140 = _30.xxx * _140;
    _30 = dot(-_140, _9.xyz);
    _30 += _30;
    _166 = (_9.xyz * (-_30.xxx)) + (-_140);
    _9.x = dot(_9.xyz, _140);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _185 = (-_9.x) + 1.0f;
    _190 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _166, 1.0f);
    _67.x = _190.w + (-1.0f);
    _67.x = (_76_m8.w * _67.x) + 1.0f;
    _67.x = log2(_67.x);
    _67.x *= _76_m8.y;
    _67.x = exp2(_67.x);
    _67.x *= _76_m8.x;
    float3 _235 = _190.xyz * _67.xxx;
    _67 = float4(_235.x, _235.y, _235.z, _67.w);
    _238 = _185 * _185;
    _238 *= _238;
    _238 = _185 * _238;
    _185 = log2(_185);
    _185 *= _76_m11;
    _185 = exp2(_185);
    _238 = (_238 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    float3 _266 = _238.xxx * _67.xyz;
    _67 = float4(_266.x, _266.y, _266.z, _67.w);
    float3 _283 = _67.xyz * float3(float3(_76_m12, _76_m12, _76_m12));
    _67 = float4(_283.x, _283.y, _283.z, _67.w);
    _190.x = _DirtTex.Sample(sampler_DirtTex, vs_TEXCOORD0).x;
    _238 = (_190.x * _76_m13.w) + 1.0f;
    float3 _309 = _238.xxx * _67.xyz;
    _67 = float4(_309.x, _309.y, _309.z, _67.w);
    _73 = (-_76_m9.wxyz) + _76_m10.wxyz;
    _73 = (_185.xxxx * _73) + _76_m9.wxyz;
    _330 = _190.x * _76_m13.w;
    _337.w = (_190.x * _76_m13.w) + _73.x;
    _337.w = clamp(_337.w, 0.0f, 1.0f);
    _352 = _330.xxx * _76_m13.xyz;
    float3 _365 = (_73.yzw * _73.xxx) + _352;
    _73 = float4(_365.x, _365.y, _365.z, _73.w);
    _49 = (_73.xyz * _49) + _67.xyz;
    _9.x = vs_TEXCOORD3;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _386 = _49 * _9.xxx;
    _9 = float4(_386.x, _386.y, _386.z, _9.w);
    _337 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _337.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._337 = _337;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float4 _DirtTex_ST;
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
#define _21_m3 _DirtTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _110;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _110 : NORMAL;
    float2 _99 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _132;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _44.xxxx) + _9;
    _9 = (_21_m2[2] * _44.zzzz) + _9;
    gl_Position = (_21_m2[3] * _44.wwww) + _9;
    vs_TEXCOORD0 = (_99 * _21_m3.xy) + _21_m3.zw;
    _9.x = dot(_110, _21_m1[0].xyz);
    _9.y = dot(_110, _21_m1[1].xyz);
    _9.z = dot(_110, _21_m1[2].xyz);
    _132 = dot(_9.xyz, _9.xyz);
    _132 = rsqrt(_132);
    vs_TEXCOORD2 = _132.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _110 = stage_input._110;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_SpecCube0_HDR;
float4 _Color;
float4 _RimColor;
float _RimPower;
float _Reflect;
float4 _DirtColor;
#define _76_m0 _WorldSpaceCameraPos
#define _76_m1 unity_SHAr
#define _76_m2 unity_SHAg
#define _76_m3 unity_SHAb
#define _76_m4 unity_SHBr
#define _76_m5 unity_SHBg
#define _76_m6 unity_SHBb
#define _76_m7 unity_SHC
#define _76_m8 unity_SpecCube0_HDR
#define _76_m9 _Color
#define _76_m10 _RimColor
#define _76_m11 _RimPower
#define _76_m12 _Reflect
#define _76_m13 _DirtColor


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _DirtTex;
SamplerState sampler_DirtTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _337;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _337 : SV_Target0;
};

static float4 _9;
static float _30;
static float3 _49;
static float4 _67;
static float4 _73;
static float3 _140;
static float3 _166;
static float _185;
static float4 _190;
static float _238;
static float _330;
static float3 _352;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD2;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _30 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    float3 _45 = _30.xxx * _9.xyz;
    _9 = float4(_45.x, _45.y, _45.z, _9.w);
    _49.x = _9.y * _9.y;
    _49.x = (_9.x * _9.x) + (-_49.x);
    _67 = _9.yzzx * _9.xyzz;
    _73.x = dot(_76_m4, _67);
    _73.y = dot(_76_m5, _67);
    _73.z = dot(_76_m6, _67);
    _49 = (_76_m7.xyz * _49.xxx) + _73.xyz;
    _9.w = 1.0f;
    _67.x = dot(_76_m1, _9);
    _67.y = dot(_76_m2, _9);
    _67.z = dot(_76_m3, _9);
    _49 += _67.xyz;
    _49 = max(_49, 0.0f.xxx);
    _49 *= 1.60000002384185791015625f.xxx;
    _140 = (-vs_TEXCOORD1) + _76_m0;
    _30 = dot(_140, _140);
    _30 = rsqrt(_30);
    _140 = _30.xxx * _140;
    _30 = dot(-_140, _9.xyz);
    _30 += _30;
    _166 = (_9.xyz * (-_30.xxx)) + (-_140);
    _9.x = dot(_9.xyz, _140);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _185 = (-_9.x) + 1.0f;
    _190 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _166, 1.0f);
    _67.x = _190.w + (-1.0f);
    _67.x = (_76_m8.w * _67.x) + 1.0f;
    _67.x = log2(_67.x);
    _67.x *= _76_m8.y;
    _67.x = exp2(_67.x);
    _67.x *= _76_m8.x;
    float3 _235 = _190.xyz * _67.xxx;
    _67 = float4(_235.x, _235.y, _235.z, _67.w);
    _238 = _185 * _185;
    _238 *= _238;
    _238 = _185 * _238;
    _185 = log2(_185);
    _185 *= _76_m11;
    _185 = exp2(_185);
    _238 = (_238 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    float3 _266 = _238.xxx * _67.xyz;
    _67 = float4(_266.x, _266.y, _266.z, _67.w);
    float3 _283 = _67.xyz * float3(float3(_76_m12, _76_m12, _76_m12));
    _67 = float4(_283.x, _283.y, _283.z, _67.w);
    _190.x = _DirtTex.Sample(sampler_DirtTex, vs_TEXCOORD0).x;
    _238 = (_190.x * _76_m13.w) + 1.0f;
    float3 _309 = _238.xxx * _67.xyz;
    _67 = float4(_309.x, _309.y, _309.z, _67.w);
    _73 = (-_76_m9.wxyz) + _76_m10.wxyz;
    _73 = (_185.xxxx * _73) + _76_m9.wxyz;
    _330 = _190.x * _76_m13.w;
    _337.w = (_190.x * _76_m13.w) + _73.x;
    _337.w = clamp(_337.w, 0.0f, 1.0f);
    _352 = _330.xxx * _76_m13.xyz;
    float3 _365 = (_73.yzw * _73.xxx) + _352;
    _73 = float4(_365.x, _365.y, _365.z, _73.w);
    float3 _374 = (_73.xyz * _49) + _67.xyz;
    _337 = float4(_374.x, _374.y, _374.z, _337.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._337 = _337;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}