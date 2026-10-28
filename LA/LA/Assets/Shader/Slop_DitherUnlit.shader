// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/DitherUnlit" {
Properties {

_Texture2D ("Texture", 2D) = "white" { }

_Color ("Color", Color) = (1,0.627,1,1)

_DitherAmmount ("Dither Amount", Range(0, 4)) = 1.9199999570846558

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
Cull Back
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 _Texture2D_ST;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 _Texture2D_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _87;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _87 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    vs_TEXCOORD0 = (_87 * _20_m3.xy) + _20_m3.zw;
    _9.y *= _20_m0.x;
    float3 _111 = _9.xwy * 0.5f.xxx;
    _48 = float4(_111.x, _48.y, _111.y, _111.z);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _9.zw.x, _9.zw.y);
    float2 _123 = _48.zz + _48.xw;
    vs_TEXCOORD1 = float4(_123.x, _123.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _87 = stage_input._87;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _ScreenParams;
float4 _Color;
float _DitherAmmount;
#define _31_m0 _ScreenParams
#define _31_m1 _Color
#define _31_m2 _DitherAmmount
static const uint4 _97[16] = { uint4(1030811889u, 0u, 0u, 0u), uint4(1057458056u, 0u, 0u, 0u), uint4(1043641525u, 0u, 0u, 0u), uint4(1059431846u, 0u, 0u, 0u), uint4(1061405636u, 0u, 0u, 0u), uint4(1050056343u, 0u, 0u, 0u), uint4(1063379426u, 0u, 0u, 0u), uint4(1054003923u, 0u, 0u, 0u), uint4(1047589105u, 0u, 0u, 0u), uint4(1060418741u, 0u, 0u, 0u), uint4(1039200497u, 0u, 0u, 0u), uint4(1058444951u, 0u, 0u, 0u), uint4(1064366321u, 0u, 0u, 0u), uint4(1055977713u, 0u, 0u, 0u), uint4(1062392531u, 0u, 0u, 0u), uint4(1052030133u, 0u, 0u, 0u) };



Texture2D<float4> _Texture2D;
SamplerState sampler_Texture2D;

static float4 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _128;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _128 : SV_Target0;
};

static float2 _9;
static uint2 _41;
static int _45;
static float _58;
static float3 _109;
static float3 _120;

uint spvBitfieldInsert(uint Base, uint Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint2 spvBitfieldInsert(uint2 Base, uint2 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint3 spvBitfieldInsert(uint3 Base, uint3 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint4 spvBitfieldInsert(uint4 Base, uint4 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

void frag_inner()
{
    _9.x = max(vs_TEXCOORD1.w, 9.9999997473787516355514526367188e-06f);
    _9 = vs_TEXCOORD1.xy / _9.xx;
    _9 *= _31_m0.xy;
    _41 = uint2(_9);
    _45 = int(spvBitfieldInsert(0, int(_41.x), 2, 2));
    _45 = int(spvBitfieldInsert(_45, int(_41.y), 0, 2));
    _58 = _31_m2 + (-asfloat(_97[_45].x));
    _109 = _Texture2D.Sample(sampler_Texture2D, vs_TEXCOORD0).xyz;
    _120 = _109 * _31_m1.xyz;
    _128.w = _109.x;
    float3 _136 = _58.xxx * _120;
    _128 = float4(_136.x, _136.y, _136.z, _128.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._128 = _128;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}