// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmZipBeam" {
Properties {

_Color ("Beam", Color) = (1,0.25,0.85,1)

_CoreColor ("Core", Color) = (1,0.85,1,1)

_Intensity ("Intensity", Range(0, 3)) = 1.0

_PulseSpacing ("Pulse Spacing (m)", Float) = 1.2000000476837158

_PulseLength ("Pulse Length (0-1)", Range(0.02, 0.9)) = 0.18000000715255737

_FlowSpeed ("Flow Speed (m/s)", Float) = 1.5

_FlowDirection ("Flow Direction", Float) = 1.0

_Boost ("Boost (riding / grab flash)", Range(0, 2)) = 0.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One One
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _20_m0[4];
float4x4 unity_MatrixVP;
static float4 _20_m1[4];
void __unity_init()
{
    _20_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m1[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m1[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m1[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m1[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _86;
static float4 _88;
static float4 _89;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
    float4 _89 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 _88 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m0[1];
    _9 = (_20_m0[0] * _11.xxxx) + _9;
    _9 = (_20_m0[2] * _11.zzzz) + _9;
    _9 += _20_m0[3];
    _48 = _9.yyyy * _20_m1[1];
    _48 = (_20_m1[0] * _9.xxxx) + _48;
    _48 = (_20_m1[2] * _9.zzzz) + _48;
    gl_Position = (_20_m1[3] * _9.wwww) + _48;
    vs_TEXCOORD0 = _86;
    _88 = _89;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    _89 = stage_input._89;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._88 = _88;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _Color;
float4 _CoreColor;
float _Intensity;
float _PulseSpacing;
float _PulseLength;
float _FlowSpeed;
float _FlowDirection;
float _Boost;
#define _13_m0 _Time
#define _13_m1 _Color
#define _13_m2 _CoreColor
#define _13_m3 _Intensity
#define _13_m4 _PulseSpacing
#define _13_m5 _PulseLength
#define _13_m6 _FlowSpeed
#define _13_m7 _FlowDirection
#define _13_m8 _Boost



static float2 vs_TEXCOORD0;
static float4 _200;
static float4 _212;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 _200 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _212 : SV_Target0;
};

static float3 _9;
static float3 _35;
static float _119;
static float3 _139;
static float _187;

void frag_inner()
{
    _9.x = _13_m0.y * _13_m6;
    _9.x /= _13_m4;
    _35.x = vs_TEXCOORD0.x / _13_m4;
    _9.x = ((-_9.x) * _13_m7) + _35.x;
    _9.x = frac(_9.x);
    _35.x = (-_13_m5) + 1.0f;
    _9.x = (-_35.x) + _9.x;
    _35.x = (-_35.x) + 1.0f;
    _35.x = 1.0f / _35.x;
    _9.x = _35.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _35.x;
    _35.x = vs_TEXCOORD0.y + (-0.5f);
    _119 = ((-abs(_35.x)) * 2.0f) + 1.0f;
    _35.x = ((-abs(_35.x)) * 5.0f) + 1.0f;
    _35.x = max(_35.x, 0.0f);
    _139 = _35.xxx * _13_m2.xyz;
    _139 *= 0.800000011920928955078125f.xxx;
    _35.x = _119 * _119;
    _9.x = _35.x * _9.x;
    _35 = _35.xxx * _13_m1.xyz;
    _35 = (_35 * 0.550000011920928955078125f.xxx) + _139;
    _139 = _9.xxx * _13_m2.xyz;
    _9 = (_139 * 1.2999999523162841796875f.xxx) + _35;
    _187 = _13_m8 + 1.0f;
    _187 *= _13_m3;
    _139 = _187.xxx * _200.xyz;
    _139 *= _200.www;
    _9 *= _139;
    _212 = float4(_9.x, _9.y, _9.z, _212.w);
    _212.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _200 = stage_input._200;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._212 = _212;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}