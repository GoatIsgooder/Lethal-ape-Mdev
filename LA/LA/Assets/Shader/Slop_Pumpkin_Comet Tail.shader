// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Pumpkin/Comet Tail" {
Properties {

_StreakTex ("Streaks (R)", 2D) = "white" { }

_HeadColor ("Head Color", Color) = (1,1,0.75,1)

_MidColor ("Mid Color", Color) = (0.55,1,0.2,1)

_TailColor ("Tail Color", Color) = (0.1,0.55,0.08,1)

_Intensity ("Intensity", Range(0, 4)) = 1.100000023841858

_HeadLength ("Head Length", Range(0.01, 1)) = 0.18000000715255737

_Falloff ("Length Falloff", Range(0.3, 4)) = 1.399999976158142

_StreakTiling ("Streak Tiling (around, along)", Vector) = (3,0.6,0,0)

_StreakSpeed ("Streak Scroll Speed", Float) = 3.5

_StreakAmount ("Streak Amount", Range(0, 1)) = 0.699999988079071

_EdgeFade ("Edge-On Fade", Range(0.01, 1)) = 0.3499999940395355

_NearFade ("Near Camera Fade (m)", Range(0, 3)) = 1.2000000476837158

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One One
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
void __unity_init()
{
    _22_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _ProjectionParams
#define _22_m5 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _141;
static float3 _144;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _144 : NORMAL;
    float2 _141 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD1 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _71;
static float _108;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m2[1];
    _9 = (_22_m2[0] * _11.xxxx) + _9;
    _9 = (_22_m2[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m2[3];
    float3 _59 = (_22_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    float3 _68 = (-_9.xyz) + _22_m0;
    _9 = float4(_68.x, _68.y, _68.z, _9.w);
    _71 = _45.yyyy * _22_m4[1];
    _71 = (_22_m4[0] * _45.xxxx) + _71;
    _71 = (_22_m4[2] * _45.zzzz) + _71;
    _45 = (_22_m4[3] * _45.wwww) + _71;
    gl_Position = _45;
    _108 = _45.z / _22_m1.y;
    _108 = (-_108) + 1.0f;
    _108 *= _22_m1.z;
    _108 = max(_108, 0.0f);
    _108 *= _22_m5.y;
    vs_TEXCOORD4 = exp2(-_108);
    vs_TEXCOORD0 = _141;
    _45.x = dot(_144, _22_m3[0].xyz);
    _45.y = dot(_144, _22_m3[1].xyz);
    _45.z = dot(_144, _22_m3[2].xyz);
    _108 = dot(_45.xyz, _45.xyz);
    _108 = rsqrt(_108);
    vs_TEXCOORD1 = _108.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _108 = dot(_9.xyz, _9.xyz);
    _108 = rsqrt(_108);
    float3 _192 = _108.xxx * _9.xyz;
    _9 = float4(_192.x, _192.y, _192.z, _9.w);
    _108 = dot(_22_m2[2].xyz, _22_m2[2].xyz);
    _108 = rsqrt(_108);
    float3 _209 = _108.xxx * _22_m2[2].xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    _9.x = dot(_45.xyz, _9.xyz);
    _9.x = (-abs(_9.x)) + 1.0f;
    vs_TEXCOORD3 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _144 = stage_input._144;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _HeadColor;
float4 _MidColor;
float4 _TailColor;
float _Intensity;
float _HeadLength;
float _Falloff;
float4 _StreakTiling;
float _StreakSpeed;
float _StreakAmount;
float _EdgeFade;
float _NearFade;
#define _38_m0 _Time
#define _38_m1 _HeadColor
#define _38_m2 _MidColor
#define _38_m3 _TailColor
#define _38_m4 _Intensity
#define _38_m5 _HeadLength
#define _38_m6 _Falloff
#define _38_m7 _StreakTiling
#define _38_m8 _StreakSpeed
#define _38_m9 _StreakAmount
#define _38_m10 _EdgeFade
#define _38_m11 _NearFade


Texture2D<float4> _StreakTex;
SamplerState sampler_StreakTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _304;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD1 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _304 : SV_Target0;
};

static float3 _9;
static float3 _50;
static float3 _66;
static float _88;
static float3 _98;
static float _133;
static float _152;
static float _164;
static bool _273;

void frag_inner()
{
    _9.x = (-vs_TEXCOORD0.y) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _38_m6;
    _9.x = exp2(_9.x);
    _50.x = vs_TEXCOORD0.y * 12.0f;
    _50.x = clamp(_50.x, 0.0f, 1.0f);
    _9.x = _50.x * _9.x;
    float2 _73 = vs_TEXCOORD0 * _38_m7.xy;
    _66 = float3(_73.x, _73.y, _66.z);
    _66.z = (_38_m0.y * _38_m8) + _66.y;
    _88 = _StreakTex.Sample(sampler_StreakTex, _66.xz).x;
    _98.x = (_88 * 1.60000002384185791015625f) + (-1.0f);
    _98.x = (_38_m9 * _98.x) + 1.0f;
    _98.x = _9.x * _98.x;
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD1;
    _133 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _133 = sqrt(_133);
    _66.x = max(_133, 9.9999997473787516355514526367188e-05f);
    _66 = vs_TEXCOORD2 / _66.xxx;
    _9.x = dot(_9, _66);
    _152 = abs(_9.x) / _38_m10;
    _152 = clamp(_152, 0.0f, 1.0f);
    _152 += (-1.0f);
    _164 = vs_TEXCOORD3 * 1.60000002384185791015625f;
    _164 = clamp(_164, 0.0f, 1.0f);
    _152 = (_164 * _152) + 1.0f;
    _98.x = _152 * _98.x;
    _152 = max(_38_m11, 0.001000000047497451305389404296875f);
    _9.x = _133 / _152;
    _9.x += (-0.25f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _98.x;
    _98.x = _9.x * _38_m4;
    _9.x = vs_TEXCOORD0.y + (-_38_m5);
    _152 = (-_38_m5) + 1.0f;
    _9.x /= _152;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _50 = (-_38_m2.xyz) + _38_m3.xyz;
    _9 = (_9.xxx * _50) + _38_m2.xyz;
    _133 = vs_TEXCOORD0.y / _38_m5;
    _66 = (-_38_m1.xyz) + _38_m2.xyz;
    _66 = (_133.xxx * _66) + _38_m1.xyz;
    _273 = vs_TEXCOORD0.y < _38_m5;
    float3 _281;
    if (_273)
    {
        _281 = _66;
    }
    else
    {
        _281 = _9;
    }
    _9 = _281;
    _98 = _98.xxx * _9;
    _9.x = vs_TEXCOORD4;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9 = _98 * _9.xxx;
    _304 = float4(_9.x, _9.y, _9.z, _304.w);
    _304.w = 1.0f;
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
    stage_output._304 = _304;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
void __unity_init()
{
    _22_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _ProjectionParams
#define _22_m5 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _145;
static float3 _148;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _148 : NORMAL;
    float2 _145 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD1 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _71;
static float _108;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m2[1];
    _9 = (_22_m2[0] * _11.xxxx) + _9;
    _9 = (_22_m2[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m2[3];
    float3 _59 = (_22_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    float3 _68 = (-_9.xyz) + _22_m0;
    _9 = float4(_68.x, _68.y, _68.z, _9.w);
    _71 = _45.yyyy * _22_m4[1];
    _71 = (_22_m4[0] * _45.xxxx) + _71;
    _71 = (_22_m4[2] * _45.zzzz) + _71;
    _45 = (_22_m4[3] * _45.wwww) + _71;
    gl_Position = _45;
    _108 = _45.z / _22_m1.y;
    _108 = (-_108) + 1.0f;
    _108 *= _22_m1.z;
    _108 = max(_108, 0.0f);
    _108 *= _22_m5.x;
    _108 *= (-_108);
    vs_TEXCOORD4 = exp2(_108);
    vs_TEXCOORD0 = _145;
    _45.x = dot(_148, _22_m3[0].xyz);
    _45.y = dot(_148, _22_m3[1].xyz);
    _45.z = dot(_148, _22_m3[2].xyz);
    _108 = dot(_45.xyz, _45.xyz);
    _108 = rsqrt(_108);
    vs_TEXCOORD1 = _108.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _108 = dot(_9.xyz, _9.xyz);
    _108 = rsqrt(_108);
    float3 _195 = _108.xxx * _9.xyz;
    _9 = float4(_195.x, _195.y, _195.z, _9.w);
    _108 = dot(_22_m2[2].xyz, _22_m2[2].xyz);
    _108 = rsqrt(_108);
    float3 _212 = _108.xxx * _22_m2[2].xyz;
    _45 = float4(_212.x, _212.y, _212.z, _45.w);
    _9.x = dot(_45.xyz, _9.xyz);
    _9.x = (-abs(_9.x)) + 1.0f;
    vs_TEXCOORD3 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    _148 = stage_input._148;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _HeadColor;
float4 _MidColor;
float4 _TailColor;
float _Intensity;
float _HeadLength;
float _Falloff;
float4 _StreakTiling;
float _StreakSpeed;
float _StreakAmount;
float _EdgeFade;
float _NearFade;
#define _38_m0 _Time
#define _38_m1 _HeadColor
#define _38_m2 _MidColor
#define _38_m3 _TailColor
#define _38_m4 _Intensity
#define _38_m5 _HeadLength
#define _38_m6 _Falloff
#define _38_m7 _StreakTiling
#define _38_m8 _StreakSpeed
#define _38_m9 _StreakAmount
#define _38_m10 _EdgeFade
#define _38_m11 _NearFade


Texture2D<float4> _StreakTex;
SamplerState sampler_StreakTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _304;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD1 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _304 : SV_Target0;
};

static float3 _9;
static float3 _50;
static float3 _66;
static float _88;
static float3 _98;
static float _133;
static float _152;
static float _164;
static bool _273;

void frag_inner()
{
    _9.x = (-vs_TEXCOORD0.y) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _38_m6;
    _9.x = exp2(_9.x);
    _50.x = vs_TEXCOORD0.y * 12.0f;
    _50.x = clamp(_50.x, 0.0f, 1.0f);
    _9.x = _50.x * _9.x;
    float2 _73 = vs_TEXCOORD0 * _38_m7.xy;
    _66 = float3(_73.x, _73.y, _66.z);
    _66.z = (_38_m0.y * _38_m8) + _66.y;
    _88 = _StreakTex.Sample(sampler_StreakTex, _66.xz).x;
    _98.x = (_88 * 1.60000002384185791015625f) + (-1.0f);
    _98.x = (_38_m9 * _98.x) + 1.0f;
    _98.x = _9.x * _98.x;
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD1;
    _133 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _133 = sqrt(_133);
    _66.x = max(_133, 9.9999997473787516355514526367188e-05f);
    _66 = vs_TEXCOORD2 / _66.xxx;
    _9.x = dot(_9, _66);
    _152 = abs(_9.x) / _38_m10;
    _152 = clamp(_152, 0.0f, 1.0f);
    _152 += (-1.0f);
    _164 = vs_TEXCOORD3 * 1.60000002384185791015625f;
    _164 = clamp(_164, 0.0f, 1.0f);
    _152 = (_164 * _152) + 1.0f;
    _98.x = _152 * _98.x;
    _152 = max(_38_m11, 0.001000000047497451305389404296875f);
    _9.x = _133 / _152;
    _9.x += (-0.25f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _98.x;
    _98.x = _9.x * _38_m4;
    _9.x = vs_TEXCOORD0.y + (-_38_m5);
    _152 = (-_38_m5) + 1.0f;
    _9.x /= _152;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _50 = (-_38_m2.xyz) + _38_m3.xyz;
    _9 = (_9.xxx * _50) + _38_m2.xyz;
    _133 = vs_TEXCOORD0.y / _38_m5;
    _66 = (-_38_m1.xyz) + _38_m2.xyz;
    _66 = (_133.xxx * _66) + _38_m1.xyz;
    _273 = vs_TEXCOORD0.y < _38_m5;
    float3 _281;
    if (_273)
    {
        _281 = _66;
    }
    else
    {
        _281 = _9;
    }
    _9 = _281;
    _98 = _98.xxx * _9;
    _9.x = vs_TEXCOORD4;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9 = _98 * _9.xxx;
    _304 = float4(_9.x, _9.y, _9.z, _304.w);
    _304.w = 1.0f;
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
    stage_output._304 = _304;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
void __unity_init()
{
    _22_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _ProjectionParams
#define _22_m5 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _142;
static float3 _145;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _145 : NORMAL;
    float2 _142 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD1 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _71;
static float _108;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m2[1];
    _9 = (_22_m2[0] * _11.xxxx) + _9;
    _9 = (_22_m2[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m2[3];
    float3 _59 = (_22_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    float3 _68 = (-_9.xyz) + _22_m0;
    _9 = float4(_68.x, _68.y, _68.z, _9.w);
    _71 = _45.yyyy * _22_m4[1];
    _71 = (_22_m4[0] * _45.xxxx) + _71;
    _71 = (_22_m4[2] * _45.zzzz) + _71;
    _45 = (_22_m4[3] * _45.wwww) + _71;
    gl_Position = _45;
    _108 = _45.z / _22_m1.y;
    _108 = (-_108) + 1.0f;
    _108 *= _22_m1.z;
    _108 = max(_108, 0.0f);
    vs_TEXCOORD4 = (_108 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = _142;
    _45.x = dot(_145, _22_m3[0].xyz);
    _45.y = dot(_145, _22_m3[1].xyz);
    _45.z = dot(_145, _22_m3[2].xyz);
    _108 = dot(_45.xyz, _45.xyz);
    _108 = rsqrt(_108);
    vs_TEXCOORD1 = _108.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _108 = dot(_9.xyz, _9.xyz);
    _108 = rsqrt(_108);
    float3 _193 = _108.xxx * _9.xyz;
    _9 = float4(_193.x, _193.y, _193.z, _9.w);
    _108 = dot(_22_m2[2].xyz, _22_m2[2].xyz);
    _108 = rsqrt(_108);
    float3 _210 = _108.xxx * _22_m2[2].xyz;
    _45 = float4(_210.x, _210.y, _210.z, _45.w);
    _9.x = dot(_45.xyz, _9.xyz);
    _9.x = (-abs(_9.x)) + 1.0f;
    vs_TEXCOORD3 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _142 = stage_input._142;
    _145 = stage_input._145;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _HeadColor;
float4 _MidColor;
float4 _TailColor;
float _Intensity;
float _HeadLength;
float _Falloff;
float4 _StreakTiling;
float _StreakSpeed;
float _StreakAmount;
float _EdgeFade;
float _NearFade;
#define _38_m0 _Time
#define _38_m1 _HeadColor
#define _38_m2 _MidColor
#define _38_m3 _TailColor
#define _38_m4 _Intensity
#define _38_m5 _HeadLength
#define _38_m6 _Falloff
#define _38_m7 _StreakTiling
#define _38_m8 _StreakSpeed
#define _38_m9 _StreakAmount
#define _38_m10 _EdgeFade
#define _38_m11 _NearFade


Texture2D<float4> _StreakTex;
SamplerState sampler_StreakTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _304;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD1 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _304 : SV_Target0;
};

static float3 _9;
static float3 _50;
static float3 _66;
static float _88;
static float3 _98;
static float _133;
static float _152;
static float _164;
static bool _273;

void frag_inner()
{
    _9.x = (-vs_TEXCOORD0.y) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _38_m6;
    _9.x = exp2(_9.x);
    _50.x = vs_TEXCOORD0.y * 12.0f;
    _50.x = clamp(_50.x, 0.0f, 1.0f);
    _9.x = _50.x * _9.x;
    float2 _73 = vs_TEXCOORD0 * _38_m7.xy;
    _66 = float3(_73.x, _73.y, _66.z);
    _66.z = (_38_m0.y * _38_m8) + _66.y;
    _88 = _StreakTex.Sample(sampler_StreakTex, _66.xz).x;
    _98.x = (_88 * 1.60000002384185791015625f) + (-1.0f);
    _98.x = (_38_m9 * _98.x) + 1.0f;
    _98.x = _9.x * _98.x;
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD1;
    _133 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _133 = sqrt(_133);
    _66.x = max(_133, 9.9999997473787516355514526367188e-05f);
    _66 = vs_TEXCOORD2 / _66.xxx;
    _9.x = dot(_9, _66);
    _152 = abs(_9.x) / _38_m10;
    _152 = clamp(_152, 0.0f, 1.0f);
    _152 += (-1.0f);
    _164 = vs_TEXCOORD3 * 1.60000002384185791015625f;
    _164 = clamp(_164, 0.0f, 1.0f);
    _152 = (_164 * _152) + 1.0f;
    _98.x = _152 * _98.x;
    _152 = max(_38_m11, 0.001000000047497451305389404296875f);
    _9.x = _133 / _152;
    _9.x += (-0.25f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _98.x;
    _98.x = _9.x * _38_m4;
    _9.x = vs_TEXCOORD0.y + (-_38_m5);
    _152 = (-_38_m5) + 1.0f;
    _9.x /= _152;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _50 = (-_38_m2.xyz) + _38_m3.xyz;
    _9 = (_9.xxx * _50) + _38_m2.xyz;
    _133 = vs_TEXCOORD0.y / _38_m5;
    _66 = (-_38_m1.xyz) + _38_m2.xyz;
    _66 = (_133.xxx * _66) + _38_m1.xyz;
    _273 = vs_TEXCOORD0.y < _38_m5;
    float3 _281;
    if (_273)
    {
        _281 = _66;
    }
    else
    {
        _281 = _9;
    }
    _9 = _281;
    _98 = _98.xxx * _9;
    _9.x = vs_TEXCOORD4;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9 = _98 * _9.xxx;
    _304 = float4(_9.x, _9.y, _9.z, _304.w);
    _304.w = 1.0f;
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
    stage_output._304 = _304;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
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
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _109;
static float3 _112;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _112 : NORMAL;
    float2 _109 : TEXCOORD0;
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
static float4 _45;
static float4 _71;
static float _134;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    float3 _59 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    float3 _68 = (-_9.xyz) + _22_m0;
    _9 = float4(_68.x, _68.y, _68.z, _9.w);
    _71 = _45.yyyy * _22_m3[1];
    _71 = (_22_m3[0] * _45.xxxx) + _71;
    _71 = (_22_m3[2] * _45.zzzz) + _71;
    gl_Position = (_22_m3[3] * _45.wwww) + _71;
    vs_TEXCOORD0 = _109;
    _45.x = dot(_112, _22_m2[0].xyz);
    _45.y = dot(_112, _22_m2[1].xyz);
    _45.z = dot(_112, _22_m2[2].xyz);
    _134 = dot(_45.xyz, _45.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD1 = _134.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _134 = dot(_9.xyz, _9.xyz);
    _134 = rsqrt(_134);
    float3 _163 = _134.xxx * _9.xyz;
    _9 = float4(_163.x, _163.y, _163.z, _9.w);
    _134 = dot(_22_m1[2].xyz, _22_m1[2].xyz);
    _134 = rsqrt(_134);
    float3 _180 = _134.xxx * _22_m1[2].xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    _9.x = dot(_45.xyz, _9.xyz);
    _9.x = (-abs(_9.x)) + 1.0f;
    vs_TEXCOORD3 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _109 = stage_input._109;
    _112 = stage_input._112;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _HeadColor;
float4 _MidColor;
float4 _TailColor;
float _Intensity;
float _HeadLength;
float _Falloff;
float4 _StreakTiling;
float _StreakSpeed;
float _StreakAmount;
float _EdgeFade;
float _NearFade;
#define _38_m0 _Time
#define _38_m1 _HeadColor
#define _38_m2 _MidColor
#define _38_m3 _TailColor
#define _38_m4 _Intensity
#define _38_m5 _HeadLength
#define _38_m6 _Falloff
#define _38_m7 _StreakTiling
#define _38_m8 _StreakSpeed
#define _38_m9 _StreakAmount
#define _38_m10 _EdgeFade
#define _38_m11 _NearFade


Texture2D<float4> _StreakTex;
SamplerState sampler_StreakTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float4 _280;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _280 : SV_Target0;
};

static float3 _9;
static float3 _50;
static float3 _66;
static float _88;
static float _98;
static float _128;
static float _147;
static float _159;
static bool _264;

void frag_inner()
{
    _9.x = (-vs_TEXCOORD0.y) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _38_m6;
    _9.x = exp2(_9.x);
    _50.x = vs_TEXCOORD0.y * 12.0f;
    _50.x = clamp(_50.x, 0.0f, 1.0f);
    _9.x = _50.x * _9.x;
    float2 _73 = vs_TEXCOORD0 * _38_m7.xy;
    _66 = float3(_73.x, _73.y, _66.z);
    _66.z = (_38_m0.y * _38_m8) + _66.y;
    _88 = _StreakTex.Sample(sampler_StreakTex, _66.xz).x;
    _98 = (_88 * 1.60000002384185791015625f) + (-1.0f);
    _98 = (_38_m9 * _98) + 1.0f;
    _98 = _9.x * _98;
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD1;
    _128 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _128 = sqrt(_128);
    _66.x = max(_128, 9.9999997473787516355514526367188e-05f);
    _66 = vs_TEXCOORD2 / _66.xxx;
    _9.x = dot(_9, _66);
    _147 = abs(_9.x) / _38_m10;
    _147 = clamp(_147, 0.0f, 1.0f);
    _147 += (-1.0f);
    _159 = vs_TEXCOORD3 * 1.60000002384185791015625f;
    _159 = clamp(_159, 0.0f, 1.0f);
    _147 = (_159 * _147) + 1.0f;
    _98 = _147 * _98;
    _147 = max(_38_m11, 0.001000000047497451305389404296875f);
    _9.x = _128 / _147;
    _9.x += (-0.25f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _98;
    _98 = _9.x * _38_m4;
    _9.x = vs_TEXCOORD0.y + (-_38_m5);
    _147 = (-_38_m5) + 1.0f;
    _9.x /= _147;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _50 = (-_38_m2.xyz) + _38_m3.xyz;
    _9 = (_9.xxx * _50) + _38_m2.xyz;
    _128 = vs_TEXCOORD0.y / _38_m5;
    _66 = (-_38_m1.xyz) + _38_m2.xyz;
    _66 = (_128.xxx * _66) + _38_m1.xyz;
    _264 = vs_TEXCOORD0.y < _38_m5;
    float3 _272;
    if (_264)
    {
        _272 = _66;
    }
    else
    {
        _272 = _9;
    }
    _9 = _272;
    float3 _284 = _98.xxx * _9;
    _280 = float4(_284.x, _284.y, _284.z, _280.w);
    _280.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._280 = _280;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}