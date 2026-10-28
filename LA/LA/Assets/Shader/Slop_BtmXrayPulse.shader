// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmXrayPulse" {
Properties {

_Color ("Color", Color) = (1,0.08,0.05,1)

_XrayIntensity ("Intensity", Range(0, 1)) = 1.0

_RimPower ("Rim Power", Range(0.5, 6)) = 2.200000047683716

_RimBoost ("Rim Boost", Range(0, 3)) = 1.399999976158142

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+60" "RenderType" = "Transparent" }
 Pass {
Cull Back
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+60" "RenderType" = "Transparent" }
 ZTest Always
 ZWrite Off
   Blend One One
 ZTest Always
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float _RimPower;
float _RimBoost;
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
#define _22_m4 _RimPower
#define _22_m5 _RimBoost



static float4 gl_Position;
static float4 _11;
static float3 _122;
static float vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _122 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _71;
static float _106;

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
    _106 = dot(_9.xyz, _9.xyz);
    _106 = rsqrt(_106);
    float3 _118 = _106.xxx * _9.xyz;
    _9 = float4(_118.x, _118.y, _118.z, _9.w);
    _45.x = dot(_122, _22_m2[0].xyz);
    _45.y = dot(_122, _22_m2[1].xyz);
    _45.z = dot(_122, _22_m2[2].xyz);
    _106 = dot(_45.xyz, _45.xyz);
    _106 = rsqrt(_106);
    float3 _154 = _106.xxx * _45.xyz;
    _45 = float4(_154.x, _154.y, _154.z, _45.w);
    _9.x = dot(_45.xyz, _9.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _22_m4;
    _9.x = exp2(_9.x);
    vs_TEXCOORD0 = (_22_m5 * _9.x) + 1.0f;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _122 = stage_input._122;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float _XrayIntensity;
#define _15_m0 _Color
#define _15_m1 _XrayIntensity



static float vs_TEXCOORD0;
static float4 _34;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _34 : SV_Target0;
};

static float4 _9;

void frag_inner()
{
    _9.x = vs_TEXCOORD0 * _15_m1;
    _9 = _9.xxxx * _15_m0;
    _34 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._34 = _34;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}