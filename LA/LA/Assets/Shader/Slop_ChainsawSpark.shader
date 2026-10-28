// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/ChainsawSpark" {
Properties {

_MainTex ("Base", 2D) = "white" { }

_HotBoost ("Hot Core Boost", Range(0, 6)) = 2.5999999046325684

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha One
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
static float4 _82;
static float4 _83;
static float3 vs_TEXCOORD0;
static float4 _88;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _83 : COLOR;
    float4 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _82 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
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
    _82 = _83;
    vs_TEXCOORD0 = _88.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _83 = stage_input._83;
    _88 = stage_input._88;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._82 = _82;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _HotBoost;
#define _35_m0 _HotBoost


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float4 _52;
static float4 _54;

struct SPIRV_Cross_Input
{
    float4 _54 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _52 : SV_Target0;
};

static float _8;
static float _24;
static float _31;
static float _65;

void frag_inner()
{
    _8 = vs_TEXCOORD0.z;
    _8 = clamp(_8, 0.0f, 1.0f);
    _8 = (-_8) + 1.0f;
    _24 = _8 * _8;
    _24 = _8 * _24;
    _31 = _24 * _35_m0;
    _24 = (_24 * _35_m0) + 1.0f;
    _31 *= 0.550000011920928955078125f;
    float3 _62 = (_54.xyz * _24.xxx) + _31.xxx;
    _52 = float4(_62.x, _62.y, _62.z, _52.w);
    _65 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).w;
    _52.w = _65 * _54.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _54 = stage_input._54;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._52 = _52;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}