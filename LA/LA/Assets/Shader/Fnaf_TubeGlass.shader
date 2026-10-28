// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Fnaf/TubeGlass" {
Properties {

_Color ("Tint (alpha = opacity)", Color) = (0.55,0.7,0.68,0.035)

_RimColor ("Rim (alpha = opacity)", Color) = (0.65,0.85,0.8,0.12)

_RimPower ("Rim Power", Range(0.5, 8)) = 2.5

_Reflect ("Reflection Strength", Range(0, 2)) = 1.0

_CrackTex ("Cracks (R = reach, G = coverage)", 2D) = "black" { }

_CrackColor ("Crack Colour (alpha = opacity)", Color) = (0.85,0.95,0.92,0.55)

_Crack ("Crack Reach (driven at runtime)", Range(0, 1)) = 0.0

_EdgeColor ("Broken Edge (alpha = opacity)", Color) = (0.9,1,0.95,0.9)

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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _143;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float4 _177;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
    float2 _140 : TEXCOORD0;
    float4 _177 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _162;

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
    vs_TEXCOORD0 = _140;
    _9.x = dot(_143, _21_m2[0].xyz);
    _9.y = dot(_143, _21_m2[1].xyz);
    _9.z = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    vs_TEXCOORD2 = _162.xxx * _9.xyz;
    vs_TEXCOORD4 = _177.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _143 = stage_input._143;
    _177 = stage_input._177;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
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
float4 _CrackColor;
float4 _EdgeColor;
float _Crack;
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
#define _76_m13 _CrackColor
#define _76_m14 _EdgeColor
#define _76_m15 _Crack


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _CrackTex;
SamplerState sampler_CrackTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float4 _435;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _435 : SV_Target0;
};

static float4 _9;
static float _30;
static float3 _49;
static float4 _67;
static float3 _73;
static float3 _139;
static float3 _165;
static float _184;
static float4 _189;
static float _237;
static float3 _314;
static float _339;
static float _343;
static float2 _380;
static bool _408;

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
    _49 = (_76_m7.xyz * _49.xxx) + _73;
    _9.w = 1.0f;
    _67.x = dot(_76_m1, _9);
    _67.y = dot(_76_m2, _9);
    _67.z = dot(_76_m3, _9);
    _49 += _67.xyz;
    _49 = max(_49, 0.0f.xxx);
    _49 *= 1.60000002384185791015625f.xxx;
    _139 = (-vs_TEXCOORD1) + _76_m0;
    _30 = dot(_139, _139);
    _30 = rsqrt(_30);
    _139 = _30.xxx * _139;
    _30 = dot(-_139, _9.xyz);
    _30 += _30;
    _165 = (_9.xyz * (-_30.xxx)) + (-_139);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _184 = (-_9.x) + 1.0f;
    _189 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _165, 1.0f);
    _67.x = _189.w + (-1.0f);
    _67.x = (_76_m8.w * _67.x) + 1.0f;
    _67.x = log2(_67.x);
    _67.x *= _76_m8.y;
    _67.x = exp2(_67.x);
    _67.x *= _76_m8.x;
    float3 _234 = _189.xyz * _67.xxx;
    _67 = float4(_234.x, _234.y, _234.z, _67.w);
    _237 = _184 * _184;
    _237 *= _237;
    _237 = _184 * _237;
    _184 = log2(_184);
    _184 *= _76_m11;
    _184 = exp2(_184);
    _237 = (_237 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _73 = _237.xxx * _67.xyz;
    float3 _272 = (_67.xyz * 0.60000002384185791015625f.xxx) + _49;
    _67 = float4(_272.x, _272.y, _272.z, _67.w);
    float3 _279 = _67.xyz + 0.0500000007450580596923828125f.xxx;
    _67 = float4(_279.x, _279.y, _279.z, _67.w);
    _73 *= float3(float3(_76_m12, _76_m12, _76_m12));
    _189 = (-_76_m9.wxyz) + _76_m10.wxyz;
    _189 = (_184.xxxx * _189) + _76_m9.wxyz;
    _314 = _189.xxx * _189.yzw;
    _49 = (_314 * _49) + _73;
    _139.x = min(vs_TEXCOORD4.z, vs_TEXCOORD4.y);
    _139.x = min(_139.x, vs_TEXCOORD4.x);
    _339 = ddx_coarse(_139.x);
    _343 = ddy_coarse(_139.x);
    _339 = abs(_343) + abs(_339);
    _339 *= 1.5f;
    _339 = max(_339, 9.9999997473787516355514526367188e-05f);
    _139.x /= _339;
    _139.x = clamp(_139.x, 0.0f, 1.0f);
    _139.x = (-_139.x) + 1.0f;
    _184 = _139.x * _76_m14.w;
    _380 = _CrackTex.Sample(sampler_CrackTex, vs_TEXCOORD0).xy;
    _237 = (-_380.x) + _76_m15;
    _237 *= 40.0f;
    _237 = clamp(_237, 0.0f, 1.0f);
    _237 *= _380.y;
    _408 = _76_m15 >= 0.001000000047497451305389404296875f;
    _73.x = float(_408);
    _237 *= _73.x;
    _237 *= _76_m13.w;
    _184 = max(_184, _237);
    _73 = _184.xxx * _76_m13.xyz;
    _435.w = _189.x + _184;
    _435.w = clamp(_435.w, 0.0f, 1.0f);
    _49 = (_73 * _67.xyz) + _49;
    _139.x = vs_TEXCOORD3;
    _139.x = clamp(_139.x, 0.0f, 1.0f);
    _139 = _49 * _139.xxx;
    _435 = float4(_139.x, _139.y, _139.z, _435.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._435 = _435;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _146;
static float3 _149;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float4 _183;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _149 : NORMAL;
    float2 _146 : TEXCOORD0;
    float4 _183 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _168;

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
    vs_TEXCOORD0 = _146;
    _9.x = dot(_149, _21_m2[0].xyz);
    _9.y = dot(_149, _21_m2[1].xyz);
    _9.z = dot(_149, _21_m2[2].xyz);
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD2 = _168.xxx * _9.xyz;
    vs_TEXCOORD4 = _183.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    _149 = stage_input._149;
    _183 = stage_input._183;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
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
float4 _CrackColor;
float4 _EdgeColor;
float _Crack;
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
#define _76_m13 _CrackColor
#define _76_m14 _EdgeColor
#define _76_m15 _Crack


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _CrackTex;
SamplerState sampler_CrackTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float4 _435;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _435 : SV_Target0;
};

static float4 _9;
static float _30;
static float3 _49;
static float4 _67;
static float3 _73;
static float3 _139;
static float3 _165;
static float _184;
static float4 _189;
static float _237;
static float3 _314;
static float _339;
static float _343;
static float2 _380;
static bool _408;

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
    _49 = (_76_m7.xyz * _49.xxx) + _73;
    _9.w = 1.0f;
    _67.x = dot(_76_m1, _9);
    _67.y = dot(_76_m2, _9);
    _67.z = dot(_76_m3, _9);
    _49 += _67.xyz;
    _49 = max(_49, 0.0f.xxx);
    _49 *= 1.60000002384185791015625f.xxx;
    _139 = (-vs_TEXCOORD1) + _76_m0;
    _30 = dot(_139, _139);
    _30 = rsqrt(_30);
    _139 = _30.xxx * _139;
    _30 = dot(-_139, _9.xyz);
    _30 += _30;
    _165 = (_9.xyz * (-_30.xxx)) + (-_139);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _184 = (-_9.x) + 1.0f;
    _189 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _165, 1.0f);
    _67.x = _189.w + (-1.0f);
    _67.x = (_76_m8.w * _67.x) + 1.0f;
    _67.x = log2(_67.x);
    _67.x *= _76_m8.y;
    _67.x = exp2(_67.x);
    _67.x *= _76_m8.x;
    float3 _234 = _189.xyz * _67.xxx;
    _67 = float4(_234.x, _234.y, _234.z, _67.w);
    _237 = _184 * _184;
    _237 *= _237;
    _237 = _184 * _237;
    _184 = log2(_184);
    _184 *= _76_m11;
    _184 = exp2(_184);
    _237 = (_237 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _73 = _237.xxx * _67.xyz;
    float3 _272 = (_67.xyz * 0.60000002384185791015625f.xxx) + _49;
    _67 = float4(_272.x, _272.y, _272.z, _67.w);
    float3 _279 = _67.xyz + 0.0500000007450580596923828125f.xxx;
    _67 = float4(_279.x, _279.y, _279.z, _67.w);
    _73 *= float3(float3(_76_m12, _76_m12, _76_m12));
    _189 = (-_76_m9.wxyz) + _76_m10.wxyz;
    _189 = (_184.xxxx * _189) + _76_m9.wxyz;
    _314 = _189.xxx * _189.yzw;
    _49 = (_314 * _49) + _73;
    _139.x = min(vs_TEXCOORD4.z, vs_TEXCOORD4.y);
    _139.x = min(_139.x, vs_TEXCOORD4.x);
    _339 = ddx_coarse(_139.x);
    _343 = ddy_coarse(_139.x);
    _339 = abs(_343) + abs(_339);
    _339 *= 1.5f;
    _339 = max(_339, 9.9999997473787516355514526367188e-05f);
    _139.x /= _339;
    _139.x = clamp(_139.x, 0.0f, 1.0f);
    _139.x = (-_139.x) + 1.0f;
    _184 = _139.x * _76_m14.w;
    _380 = _CrackTex.Sample(sampler_CrackTex, vs_TEXCOORD0).xy;
    _237 = (-_380.x) + _76_m15;
    _237 *= 40.0f;
    _237 = clamp(_237, 0.0f, 1.0f);
    _237 *= _380.y;
    _408 = _76_m15 >= 0.001000000047497451305389404296875f;
    _73.x = float(_408);
    _237 *= _73.x;
    _237 *= _76_m13.w;
    _184 = max(_184, _237);
    _73 = _184.xxx * _76_m13.xyz;
    _435.w = _189.x + _184;
    _435.w = clamp(_435.w, 0.0f, 1.0f);
    _49 = (_73 * _67.xyz) + _49;
    _139.x = vs_TEXCOORD3;
    _139.x = clamp(_139.x, 0.0f, 1.0f);
    _139 = _49 * _139.xxx;
    _435 = float4(_139.x, _139.y, _139.z, _435.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._435 = _435;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _139;
static float3 _142;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float4 _176;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _142 : NORMAL;
    float2 _139 : TEXCOORD0;
    float4 _176 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _161;

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
    vs_TEXCOORD0 = _139;
    _9.x = dot(_142, _21_m2[0].xyz);
    _9.y = dot(_142, _21_m2[1].xyz);
    _9.z = dot(_142, _21_m2[2].xyz);
    _161 = dot(_9.xyz, _9.xyz);
    _161 = rsqrt(_161);
    vs_TEXCOORD2 = _161.xxx * _9.xyz;
    vs_TEXCOORD4 = _176.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _142 = stage_input._142;
    _176 = stage_input._176;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
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
float4 _CrackColor;
float4 _EdgeColor;
float _Crack;
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
#define _76_m13 _CrackColor
#define _76_m14 _EdgeColor
#define _76_m15 _Crack


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _CrackTex;
SamplerState sampler_CrackTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float4 _435;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _435 : SV_Target0;
};

static float4 _9;
static float _30;
static float3 _49;
static float4 _67;
static float3 _73;
static float3 _139;
static float3 _165;
static float _184;
static float4 _189;
static float _237;
static float3 _314;
static float _339;
static float _343;
static float2 _380;
static bool _408;

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
    _49 = (_76_m7.xyz * _49.xxx) + _73;
    _9.w = 1.0f;
    _67.x = dot(_76_m1, _9);
    _67.y = dot(_76_m2, _9);
    _67.z = dot(_76_m3, _9);
    _49 += _67.xyz;
    _49 = max(_49, 0.0f.xxx);
    _49 *= 1.60000002384185791015625f.xxx;
    _139 = (-vs_TEXCOORD1) + _76_m0;
    _30 = dot(_139, _139);
    _30 = rsqrt(_30);
    _139 = _30.xxx * _139;
    _30 = dot(-_139, _9.xyz);
    _30 += _30;
    _165 = (_9.xyz * (-_30.xxx)) + (-_139);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _184 = (-_9.x) + 1.0f;
    _189 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _165, 1.0f);
    _67.x = _189.w + (-1.0f);
    _67.x = (_76_m8.w * _67.x) + 1.0f;
    _67.x = log2(_67.x);
    _67.x *= _76_m8.y;
    _67.x = exp2(_67.x);
    _67.x *= _76_m8.x;
    float3 _234 = _189.xyz * _67.xxx;
    _67 = float4(_234.x, _234.y, _234.z, _67.w);
    _237 = _184 * _184;
    _237 *= _237;
    _237 = _184 * _237;
    _184 = log2(_184);
    _184 *= _76_m11;
    _184 = exp2(_184);
    _237 = (_237 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _73 = _237.xxx * _67.xyz;
    float3 _272 = (_67.xyz * 0.60000002384185791015625f.xxx) + _49;
    _67 = float4(_272.x, _272.y, _272.z, _67.w);
    float3 _279 = _67.xyz + 0.0500000007450580596923828125f.xxx;
    _67 = float4(_279.x, _279.y, _279.z, _67.w);
    _73 *= float3(float3(_76_m12, _76_m12, _76_m12));
    _189 = (-_76_m9.wxyz) + _76_m10.wxyz;
    _189 = (_184.xxxx * _189) + _76_m9.wxyz;
    _314 = _189.xxx * _189.yzw;
    _49 = (_314 * _49) + _73;
    _139.x = min(vs_TEXCOORD4.z, vs_TEXCOORD4.y);
    _139.x = min(_139.x, vs_TEXCOORD4.x);
    _339 = ddx_coarse(_139.x);
    _343 = ddy_coarse(_139.x);
    _339 = abs(_343) + abs(_339);
    _339 *= 1.5f;
    _339 = max(_339, 9.9999997473787516355514526367188e-05f);
    _139.x /= _339;
    _139.x = clamp(_139.x, 0.0f, 1.0f);
    _139.x = (-_139.x) + 1.0f;
    _184 = _139.x * _76_m14.w;
    _380 = _CrackTex.Sample(sampler_CrackTex, vs_TEXCOORD0).xy;
    _237 = (-_380.x) + _76_m15;
    _237 *= 40.0f;
    _237 = clamp(_237, 0.0f, 1.0f);
    _237 *= _380.y;
    _408 = _76_m15 >= 0.001000000047497451305389404296875f;
    _73.x = float(_408);
    _237 *= _73.x;
    _237 *= _76_m13.w;
    _184 = max(_184, _237);
    _73 = _184.xxx * _76_m13.xyz;
    _435.w = _189.x + _184;
    _435.w = clamp(_435.w, 0.0f, 1.0f);
    _49 = (_73 * _67.xyz) + _49;
    _139.x = vs_TEXCOORD3;
    _139.x = clamp(_139.x, 0.0f, 1.0f);
    _139 = _49 * _139.xxx;
    _435 = float4(_139.x, _139.y, _139.z, _435.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._435 = _435;
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




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _102;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float4 _139;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _102 : NORMAL;
    float2 _99 : TEXCOORD0;
    float4 _139 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _124;

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
    vs_TEXCOORD0 = _99;
    _9.x = dot(_102, _21_m1[0].xyz);
    _9.y = dot(_102, _21_m1[1].xyz);
    _9.z = dot(_102, _21_m1[2].xyz);
    _124 = dot(_9.xyz, _9.xyz);
    _124 = rsqrt(_124);
    vs_TEXCOORD2 = _124.xxx * _9.xyz;
    vs_TEXCOORD4 = _139.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _102 = stage_input._102;
    _139 = stage_input._139;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
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
float4 _CrackColor;
float4 _EdgeColor;
float _Crack;
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
#define _76_m13 _CrackColor
#define _76_m14 _EdgeColor
#define _76_m15 _Crack


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _CrackTex;
SamplerState sampler_CrackTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float4 _435;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _435 : SV_Target0;
};

static float4 _9;
static float _30;
static float3 _49;
static float4 _67;
static float3 _73;
static float3 _139;
static float3 _165;
static float _184;
static float4 _189;
static float _237;
static float3 _314;
static float _339;
static float _343;
static float2 _380;
static bool _408;

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
    _49 = (_76_m7.xyz * _49.xxx) + _73;
    _9.w = 1.0f;
    _67.x = dot(_76_m1, _9);
    _67.y = dot(_76_m2, _9);
    _67.z = dot(_76_m3, _9);
    _49 += _67.xyz;
    _49 = max(_49, 0.0f.xxx);
    _49 *= 1.60000002384185791015625f.xxx;
    _139 = (-vs_TEXCOORD1) + _76_m0;
    _30 = dot(_139, _139);
    _30 = rsqrt(_30);
    _139 = _30.xxx * _139;
    _30 = dot(-_139, _9.xyz);
    _30 += _30;
    _165 = (_9.xyz * (-_30.xxx)) + (-_139);
    _9.x = dot(_9.xyz, _139);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _184 = (-_9.x) + 1.0f;
    _189 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _165, 1.0f);
    _67.x = _189.w + (-1.0f);
    _67.x = (_76_m8.w * _67.x) + 1.0f;
    _67.x = log2(_67.x);
    _67.x *= _76_m8.y;
    _67.x = exp2(_67.x);
    _67.x *= _76_m8.x;
    float3 _234 = _189.xyz * _67.xxx;
    _67 = float4(_234.x, _234.y, _234.z, _67.w);
    _237 = _184 * _184;
    _237 *= _237;
    _237 = _184 * _237;
    _184 = log2(_184);
    _184 *= _76_m11;
    _184 = exp2(_184);
    _237 = (_237 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _73 = _237.xxx * _67.xyz;
    float3 _272 = (_67.xyz * 0.60000002384185791015625f.xxx) + _49;
    _67 = float4(_272.x, _272.y, _272.z, _67.w);
    float3 _279 = _67.xyz + 0.0500000007450580596923828125f.xxx;
    _67 = float4(_279.x, _279.y, _279.z, _67.w);
    _73 *= float3(float3(_76_m12, _76_m12, _76_m12));
    _189 = (-_76_m9.wxyz) + _76_m10.wxyz;
    _189 = (_184.xxxx * _189) + _76_m9.wxyz;
    _314 = _189.xxx * _189.yzw;
    _49 = (_314 * _49) + _73;
    _139.x = min(vs_TEXCOORD4.z, vs_TEXCOORD4.y);
    _139.x = min(_139.x, vs_TEXCOORD4.x);
    _339 = ddx_coarse(_139.x);
    _343 = ddy_coarse(_139.x);
    _339 = abs(_343) + abs(_339);
    _339 *= 1.5f;
    _339 = max(_339, 9.9999997473787516355514526367188e-05f);
    _139.x /= _339;
    _139.x = clamp(_139.x, 0.0f, 1.0f);
    _139.x = (-_139.x) + 1.0f;
    _184 = _139.x * _76_m14.w;
    _380 = _CrackTex.Sample(sampler_CrackTex, vs_TEXCOORD0).xy;
    _237 = (-_380.x) + _76_m15;
    _237 *= 40.0f;
    _237 = clamp(_237, 0.0f, 1.0f);
    _237 *= _380.y;
    _408 = _76_m15 >= 0.001000000047497451305389404296875f;
    _73.x = float(_408);
    _237 *= _73.x;
    _237 *= _76_m13.w;
    _184 = max(_184, _237);
    _73 = _184.xxx * _76_m13.xyz;
    _435.w = _189.x + _184;
    _435.w = clamp(_435.w, 0.0f, 1.0f);
    float3 _451 = (_73 * _67.xyz) + _49;
    _435 = float4(_451.x, _451.y, _451.z, _435.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._435 = _435;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}