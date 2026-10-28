// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/ChainsawChain" {
Properties {

_Color ("Color", Color) = (1.5,1.45,1.35,1)

_ChainOffset ("Chain Offset", Float) = 0.0

_ChainGlow ("Chain Glow", Range(0, 1)) = 0.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
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
static float2 vs_TEXCOORD0;
static float2 _86;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
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
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float _ChainOffset;
float _ChainGlow;
#define _13_m0 _Color
#define _13_m1 _ChainOffset
#define _13_m2 _ChainGlow



static float2 vs_TEXCOORD0;
static float4 _199;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _199 : SV_Target0;
};

static float2 _9;
static float _65;
static float _74;
static float _90;
static float _113;
static float _125;

void frag_inner()
{
    _9 = _13_m1.xx * float2(0.2700000107288360595703125f, 0.10999999940395355224609375f);
    _9.x = (vs_TEXCOORD0.x * 0.61000001430511474609375f) + (-_9.x);
    _9.y = (vs_TEXCOORD0.x * 2.2999999523162841796875f) + _9.y;
    _9 = sin(_9);
    _9.x = (_9.x * 0.3499999940395355224609375f) + 0.449999988079071044921875f;
    _9.x = (_9.y * 0.20000000298023223876953125f) + _9.x;
    _65 = vs_TEXCOORD0.x + (-_13_m1);
    _65 = frac(_65);
    _74 = _65 * 6.666666507720947265625f;
    _65 += (-0.4000000059604644775390625f);
    _65 *= 4.999999523162841796875f;
    _65 = clamp(_65, 0.0f, 1.0f);
    _74 = min(_74, 1.0f);
    _90 = (_74 * (-2.0f)) + 3.0f;
    _74 *= _74;
    _74 *= _90;
    _90 = (_65 * (-2.0f)) + 3.0f;
    _65 *= _65;
    _65 = ((-_90) * _65) + 1.0f;
    _113 = ((-_74) * _65) + _9.x;
    _9.x = _65 * _74;
    _125 = (_13_m2 * 1.39999997615814208984375f) + (-0.4000000059604644775390625f);
    _125 = clamp(_125, 0.0f, 1.0f);
    _113 = (_125 * _113) + _9.x;
    _9.x = vs_TEXCOORD0.y * 2.857142925262451171875f;
    _9.x = _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _65 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _65;
    _65 = vs_TEXCOORD0.y + (-1.0f);
    _65 *= (-2.8571426868438720703125f);
    _65 = clamp(_65, 0.0f, 1.0f);
    _74 = (_65 * (-2.0f)) + 3.0f;
    _65 *= _65;
    _65 *= _74;
    _9.x = _65 * _9.x;
    _113 = _9.x * _113;
    _113 *= _13_m2;
    _199.w = _113 * _13_m0.w;
    _199 = float4(_13_m0.xyz.x, _13_m0.xyz.y, _13_m0.xyz.z, _199.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._199 = _199;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}