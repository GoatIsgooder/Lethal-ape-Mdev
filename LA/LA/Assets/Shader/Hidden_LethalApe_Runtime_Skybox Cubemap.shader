// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Hidden/LethalApe/Runtime/Skybox Cubemap" {
Properties {

_Tint ("Tint", Color) = (0.5,0.5,0.5,0.5)

_Exposure ("Exposure", Range(0, 8)) = 1.0

_Rotation ("Rotation", Range(0, 360)) = 0.0

_Tex ("Cubemap (HDR)", Cube) = "grey" { }

}
SubShader {
 Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
 Pass {
  Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
 ZWrite Off
 Cull Off
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
float _Rotation;
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
#define _20_m2 _Rotation



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _28;
static float _38;
static float _64;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m0[1];
    _28.x = _20_m2 * 0.0174532942473888397216796875f;
    _38 = cos(_28.x);
    _28.x = sin(_28.x);
    float2 _51 = _28.xx * _11.zx;
    _28 = float4(_51.x, _51.y, _28.z, _28.w);
    _28.x = (_38 * _11.x) + (-_28.x);
    _64 = (_38 * _11.z) + _28.y;
    _9 = (_20_m0[0] * _28.xxxx) + _9;
    _9 = (_20_m0[2] * _64.xxxx) + _9;
    _9 += _20_m0[3];
    _28 = _9.yyyy * _20_m1[1];
    _28 = (_20_m1[0] * _9.xxxx) + _28;
    _28 = (_20_m1[2] * _9.zzzz) + _28;
    gl_Position = (_20_m1[3] * _9.wwww) + _28;
    vs_TEXCOORD0 = _11.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tex_HDR;
float4 _Tint;
float _Exposure;
#define _33_m0 _Tex_HDR
#define _33_m1 _Tint
#define _33_m2 _Exposure


TextureCube<float4> _Tex;
SamplerState sampler_Tex;

static float3 vs_TEXCOORD0;
static float4 _86;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _86 : SV_Target0;
};

static float4 _9;
static float3 _21;
static float3 _71;

void frag_inner()
{
    _9 = _Tex.Sample(sampler_Tex, vs_TEXCOORD0);
    _21.x = _9.w + (-1.0f);
    _21.x = (_33_m0.w * _21.x) + 1.0f;
    _21.x = log2(_21.x);
    _21.x *= _33_m0.y;
    _21.x = exp2(_21.x);
    _21.x *= _33_m0.x;
    _21 = _9.xyz * _21.xxx;
    _71 = _33_m1.xyz * _33_m2.xxx;
    _21 *= _71;
    float3 _90 = _21 * 4.594793796539306640625f.xxx;
    _86 = float4(_90.x, _90.y, _90.z, _86.w);
    _86.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._86 = _86;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}