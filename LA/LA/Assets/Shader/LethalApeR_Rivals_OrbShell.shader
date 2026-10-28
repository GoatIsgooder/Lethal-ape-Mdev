// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "LethalApeR/Rivals/OrbShell" {
Properties {

_Color ("Color (A = overall opacity)", Color) = (0.25,0.85,1,0.6)

_RimPower ("Rim Power", Range(0.5, 8)) = 2.5

_RimBoost ("Rim Boost", Range(0, 4)) = 1.600000023841858

_BaseAlpha ("Center Alpha", Range(0, 1)) = 0.11999999731779099

_Pulse ("Idle Pulse Amount", Range(0, 1)) = 0.15000000596046448

_PulseSpeed ("Idle Pulse Speed", Range(0, 10)) = 2.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Front
   Blend SrcAlpha OneMinusSrcAlpha
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
static float3 vs_TEXCOORD1;
static float3 _105;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _105 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _127;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    float3 _59 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    vs_TEXCOORD1 = (-_9.xyz) + _22_m0;
    _9 = _45.yyyy * _22_m3[1];
    _9 = (_22_m3[0] * _45.xxxx) + _9;
    _9 = (_22_m3[2] * _45.zzzz) + _9;
    gl_Position = (_22_m3[3] * _45.wwww) + _9;
    _9.x = dot(_105, _22_m2[0].xyz);
    _9.y = dot(_105, _22_m2[1].xyz);
    _9.z = dot(_105, _22_m2[2].xyz);
    _127 = dot(_9.xyz, _9.xyz);
    _127 = rsqrt(_127);
    float3 _139 = _127.xxx * _9.xyz;
    _9 = float4(_139.x, _139.y, _139.z, _9.w);
    vs_TEXCOORD0 = -_9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _105 = stage_input._105;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _Color;
float _RimPower;
float _RimBoost;
float _BaseAlpha;
float _Pulse;
float _PulseSpeed;
#define _67_m0 _Time
#define _67_m1 _Color
#define _67_m2 _RimPower
#define _67_m3 _RimBoost
#define _67_m4 _BaseAlpha
#define _67_m5 _Pulse
#define _67_m6 _PulseSpeed



static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _140;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _140 : SV_Target0;
};

static float3 _9;
static float _27;
static float4 _36;
static float _79;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD0;
    _27 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _27 = rsqrt(_27);
    float3 _40 = _27.xxx * vs_TEXCOORD1;
    _36 = float4(_40.x, _40.y, _40.z, _36.w);
    _9.x = dot(_9, _36.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _67_m2;
    _9.x = exp2(_9.x);
    _79 = (_9.x * _67_m3) + _67_m4;
    _9.x = (_9.x * _67_m3) + 0.550000011920928955078125f;
    float3 _105 = _9.xxx * _67_m1.xyz;
    _36 = float4(_105.x, _105.y, _105.z, _36.w);
    _9.x = _79 * _67_m1.w;
    _79 = _67_m0.y * _67_m6;
    _79 = sin(_79);
    _79 = (_67_m5 * _79) + 1.0f;
    _36.w = _79 * _9.x;
    _36.w = clamp(_36.w, 0.0f, 1.0f);
    _140 = _36;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._140 = _140;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}