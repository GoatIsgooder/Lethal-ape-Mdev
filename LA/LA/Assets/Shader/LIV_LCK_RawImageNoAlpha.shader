// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "LIV/LCK/RawImageNoAlpha" {
Properties {

_MainTex ("Texture", 2D) = "white" { }

}
SubShader {
 LOD 100
 Tags { "RenderType" = "Opaque" }
 Pass {
ZWrite On
  LOD 100
  Tags { "RenderType" = "Opaque" }
 Cull Off
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _26_m0[4];
float4x4 unity_MatrixVP;
static float4 _26_m1[4];
void __unity_init()
{
    _26_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _26_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _26_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _26_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _26_m1[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _26_m1[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _26_m1[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _26_m1[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}




static float4 gl_Position;
static float2 vs_TEXCOORD0;
static float2 _11;
static float4 _17;

struct SPIRV_Cross_Input
{
    float4 _17 : POSITION;
    float2 _11 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float4 _15;
static float4 _54;

void vert_inner()
{
    __unity_init();
    vs_TEXCOORD0 = _11;
    _15 = _17.yyyy * _26_m0[1];
    _15 = (_26_m0[0] * _17.xxxx) + _15;
    _15 = (_26_m0[2] * _17.zzzz) + _15;
    _15 += _26_m0[3];
    _54 = _15.yyyy * _26_m1[1];
    _54 = (_26_m1[0] * _15.xxxx) + _54;
    _54 = (_26_m1[2] * _15.zzzz) + _54;
    gl_Position = (_26_m1[3] * _15.wwww) + _54;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _17 = stage_input._17;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _23;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _23 : SV_Target0;
};

static float3 _9;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _23 = float4(_9.x, _9.y, _9.z, _23.w);
    _23.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._23 = _23;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}