// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Monster Index/Display" {
Properties {

_MainTex ("Albedo", 2D) = "white" { }

_Color ("Colour", Color) = (1,1,1,1)

[Toggle(_EMISSION)] _Emission ("Emission", Float) = 0.0

_EmissionMap ("Emission Map", 2D) = "white" { }

_EmissionColor ("Emission Colour", Color) = (0,0,0,1)

[Toggle(_CUTOUT)] _Cutout ("Cut Out", Float) = 0.0

_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5

_Ambient ("Ambient", Range(0, 1)) = 0.44999998807907104

_RimColor ("Rim Colour", Color) = (0.16,0.16,0.18,1)

_RimPower ("Rim Power", Range(0.5, 8)) = 4.0

_FadeNear ("Full Size Within (m)", Float) = 2.5

_FadeFar ("Gone At (m)", Float) = 4.0

}
SubShader {
 Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_local __ _EMISSION
#if defined(_EMISSION)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _18_m1[4];
float4x4 unity_WorldToObject;
static float4 _18_m2[4];
float4x4 unity_MatrixVP;
static float4 _18_m3[4];
float4 _MainTex_ST;
float _Ambient;
float4 _RimColor;
float _RimPower;
float _FadeNear;
float _FadeFar;
void __unity_init()
{
    _18_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _18_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _18_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _18_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _18_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _18_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _18_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _18_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _18_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _18_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _18_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _18_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _18_m0 _WorldSpaceCameraPos
#define _18_m4 _MainTex_ST
#define _18_m5 _Ambient
#define _18_m6 _RimColor
#define _18_m7 _RimPower
#define _18_m8 _FadeNear
#define _18_m9 _FadeFar



static float4 gl_Position;
static float4 _96;
static float2 vs_TEXCOORD0;
static float2 _184;
static float3 _237;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _96 : POSITION;
    float3 _237 : NORMAL;
    float2 _184 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float _55;
static float4 _102;
static float _195;
static float3 _235;
static float _322;

void vert_inner()
{
    __unity_init();
    float3 _31 = _18_m0 + (-_18_m1[3].xyz);
    _9 = float4(_31.x, _31.y, _31.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x += (-_18_m9);
    _55 = (-_18_m9) + _18_m8;
    _55 = 1.0f / _55;
    _9.x = _55 * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _55 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _55;
    float3 _99 = _9.xxx * _96.xyz;
    _9 = float4(_99.x, _99.y, _99.z, _9.w);
    float3 _108 = _9.yyy * _18_m1[1].xyz;
    _102 = float4(_108.x, _108.y, _108.z, _102.w);
    float3 _119 = (_18_m1[0].xyz * _9.xxx) + _102.xyz;
    _9 = float4(_119.x, _119.y, _9.z, _119.z);
    float3 _131 = (_18_m1[2].xyz * _9.zzz) + _9.xyw;
    _9 = float4(_131.x, _131.y, _131.z, _9.w);
    float3 _139 = _9.xyz + _18_m1[3].xyz;
    _9 = float4(_139.x, _139.y, _139.z, _9.w);
    _102 = _9.yyyy * _18_m3[1];
    _102 = (_18_m3[0] * _9.xxxx) + _102;
    _102 = (_18_m3[2] * _9.zzzz) + _102;
    float3 _166 = (-_9.xyz) + _18_m0;
    _9 = float4(_166.x, _166.y, _166.z, _9.w);
    gl_Position = _102 + _18_m3[3];
    vs_TEXCOORD0 = (_184 * _18_m4.xy) + _18_m4.zw;
    _195 = dot(_9.xyz, _9.xyz);
    _195 = rsqrt(_195);
    float3 _210 = (_9.xyz * _195.xxx) + float3(0.0f, 1.2999999523162841796875f, 0.0f);
    _102 = float4(_210.x, _210.y, _210.z, _102.w);
    float3 _217 = _195.xxx * _9.xyz;
    _9 = float4(_217.x, _217.y, _217.z, _9.w);
    _195 = dot(_102.xyz, _102.xyz);
    _195 = rsqrt(_195);
    float3 _231 = _195.xxx * _102.xyz;
    _102 = float4(_231.x, _231.y, _231.z, _102.w);
    _235.x = dot(_237, _18_m2[0].xyz);
    _235.y = dot(_237, _18_m2[1].xyz);
    _235.z = dot(_237, _18_m2[2].xyz);
    _195 = dot(_235, _235);
    _195 = rsqrt(_195);
    _235 = _195.xxx * _235;
    _195 = dot(_235, _102.xyz);
    _9.x = dot(_235, _9.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _18_m7;
    _9.x = exp2(_9.x);
    float3 _305 = _9.xxx * _18_m6.xyz;
    _9 = float4(_305.x, _305.y, _305.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _9.x = (_195 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _322 = (-_18_m5) + 1.0f;
    _9.x = (_322 * _9.x) + _18_m5;
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _96 = stage_input._96;
    _184 = stage_input._184;
    _237 = stage_input._237;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float4 _EmissionColor;
#define _26_m0 _Color
#define _26_m1 _EmissionColor


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;

static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _59;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _59 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _34;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = _9 * _26_m0.xyz;
    _34 = (_22 * vs_TEXCOORD1.xxx) + vs_TEXCOORD2;
    _9 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0).xyz;
    _22 = (_9 * _26_m1.xyz) + _34;
    _59 = float4(_22.x, _22.y, _22.z, _59.w);
    _59.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._59 = _59;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _18_m1[4];
float4x4 unity_WorldToObject;
static float4 _18_m2[4];
float4x4 unity_MatrixVP;
static float4 _18_m3[4];
float4 _MainTex_ST;
float _Ambient;
float4 _RimColor;
float _RimPower;
float _FadeNear;
float _FadeFar;
void __unity_init()
{
    _18_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _18_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _18_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _18_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _18_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _18_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _18_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _18_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _18_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _18_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _18_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _18_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _18_m0 _WorldSpaceCameraPos
#define _18_m4 _MainTex_ST
#define _18_m5 _Ambient
#define _18_m6 _RimColor
#define _18_m7 _RimPower
#define _18_m8 _FadeNear
#define _18_m9 _FadeFar



static float4 gl_Position;
static float4 _96;
static float2 vs_TEXCOORD0;
static float2 _184;
static float3 _237;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _96 : POSITION;
    float3 _237 : NORMAL;
    float2 _184 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float _55;
static float4 _102;
static float _195;
static float3 _235;
static float _322;

void vert_inner()
{
    __unity_init();
    float3 _31 = _18_m0 + (-_18_m1[3].xyz);
    _9 = float4(_31.x, _31.y, _31.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x += (-_18_m9);
    _55 = (-_18_m9) + _18_m8;
    _55 = 1.0f / _55;
    _9.x = _55 * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _55 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _55;
    float3 _99 = _9.xxx * _96.xyz;
    _9 = float4(_99.x, _99.y, _99.z, _9.w);
    float3 _108 = _9.yyy * _18_m1[1].xyz;
    _102 = float4(_108.x, _108.y, _108.z, _102.w);
    float3 _119 = (_18_m1[0].xyz * _9.xxx) + _102.xyz;
    _9 = float4(_119.x, _119.y, _9.z, _119.z);
    float3 _131 = (_18_m1[2].xyz * _9.zzz) + _9.xyw;
    _9 = float4(_131.x, _131.y, _131.z, _9.w);
    float3 _139 = _9.xyz + _18_m1[3].xyz;
    _9 = float4(_139.x, _139.y, _139.z, _9.w);
    _102 = _9.yyyy * _18_m3[1];
    _102 = (_18_m3[0] * _9.xxxx) + _102;
    _102 = (_18_m3[2] * _9.zzzz) + _102;
    float3 _166 = (-_9.xyz) + _18_m0;
    _9 = float4(_166.x, _166.y, _166.z, _9.w);
    gl_Position = _102 + _18_m3[3];
    vs_TEXCOORD0 = (_184 * _18_m4.xy) + _18_m4.zw;
    _195 = dot(_9.xyz, _9.xyz);
    _195 = rsqrt(_195);
    float3 _210 = (_9.xyz * _195.xxx) + float3(0.0f, 1.2999999523162841796875f, 0.0f);
    _102 = float4(_210.x, _210.y, _210.z, _102.w);
    float3 _217 = _195.xxx * _9.xyz;
    _9 = float4(_217.x, _217.y, _217.z, _9.w);
    _195 = dot(_102.xyz, _102.xyz);
    _195 = rsqrt(_195);
    float3 _231 = _195.xxx * _102.xyz;
    _102 = float4(_231.x, _231.y, _231.z, _102.w);
    _235.x = dot(_237, _18_m2[0].xyz);
    _235.y = dot(_237, _18_m2[1].xyz);
    _235.z = dot(_237, _18_m2[2].xyz);
    _195 = dot(_235, _235);
    _195 = rsqrt(_195);
    _235 = _195.xxx * _235;
    _195 = dot(_235, _102.xyz);
    _9.x = dot(_235, _9.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _18_m7;
    _9.x = exp2(_9.x);
    float3 _305 = _9.xxx * _18_m6.xyz;
    _9 = float4(_305.x, _305.y, _305.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _9.x = (_195 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _322 = (-_18_m5) + 1.0f;
    _9.x = (_322 * _9.x) + _18_m5;
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _96 = stage_input._96;
    _184 = stage_input._184;
    _237 = stage_input._237;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
#define _26_m0 _Color


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _35;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _35 : SV_Target0;
};

static float3 _9;
static float3 _22;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22 = _9 * _26_m0.xyz;
    float3 _45 = (_22 * vs_TEXCOORD1.xxx) + vs_TEXCOORD2;
    _35 = float4(_45.x, _45.y, _45.z, _35.w);
    _35.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._35 = _35;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}