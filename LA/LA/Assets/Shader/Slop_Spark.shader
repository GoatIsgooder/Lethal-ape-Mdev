// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Spark" {
Properties {

_Color ("Colour", Color) = (1,0.95,0.85,1)

_Falloff ("Falloff", Range(0.5, 8)) = 2.5999999046325684

_Intensity ("Intensity", Range(0, 8)) = 2.200000047683716

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
 Name "Spark"
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
float4 _Color;
float _Falloff;
float _Intensity;
#define _53_m0 _Color
#define _53_m1 _Falloff
#define _53_m2 _Intensity



static float2 vs_TEXCOORD0;
static float4 _68;
static float4 _114;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 _68 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _114 : SV_Target0;
};

static float4 _9;
static float3 _84;
static float3 _92;

void frag_inner()
{
    float2 _19 = (vs_TEXCOORD0 * 2.0f.xx) + (-1.0f).xx;
    _9 = float4(_19.x, _19.y, _9.z, _9.w);
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x = min(_9.x, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _53_m1;
    _9.x = exp2(_9.x);
    _9.x *= _68.w;
    _9.w = _9.x * _53_m0.w;
    _84 = _68.xyz * _53_m0.xyz;
    _92 = _84 * float3(float3(_53_m2, _53_m2, _53_m2));
    float3 _110 = _9.www * _92;
    _9 = float4(_110.x, _110.y, _110.z, _9.w);
    _114 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _68 = stage_input._68;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._114 = _114;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}