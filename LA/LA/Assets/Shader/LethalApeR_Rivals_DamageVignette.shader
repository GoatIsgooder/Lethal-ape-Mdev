// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "LethalApeR/Rivals/DamageVignette" {
Properties {

_Color ("Vignette Color", Color) = (0.75,0.02,0.02,1)

_Intensity ("Intensity", Range(0, 1)) = 0.0

_Inner ("Inner Radius", Range(0, 1)) = 0.44999998807907104

_Outer ("Outer Radius", Range(0.1, 2)) = 1.350000023841858

_Pow ("Falloff Power", Range(0.25, 4)) = 1.2999999523162842

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+50" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+50" "RenderType" = "Transparent" }
 ZTest Always
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
 ZTest Always
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
float _Intensity;
float _Inner;
float _Outer;
float _Pow;
#define _34_m0 _Color
#define _34_m1 _Intensity
#define _34_m2 _Inner
#define _34_m3 _Outer
#define _34_m4 _Pow



static float2 vs_TEXCOORD0;
static float4 _120;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _120 : SV_Target0;
};

static float2 _9;
static float _43;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-0.5f).xx;
    _9.x = dot(_9, _9);
    _9.x = sqrt(_9.x);
    _9.x = (_9.x * 2.0f) + (-_34_m2);
    _43 = (-_34_m2) + _34_m3;
    _43 = 1.0f / _43;
    _9.x = _43 * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _43 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _43;
    _9.x = min(_9.x, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _34_m4;
    _9.x = exp2(_9.x);
    _9.x *= _34_m1;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _34_m0.w;
    _120.w = _9.x;
    _120 = float4(_34_m0.xyz.x, _34_m0.xyz.y, _34_m0.xyz.z, _120.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._120 = _120;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}