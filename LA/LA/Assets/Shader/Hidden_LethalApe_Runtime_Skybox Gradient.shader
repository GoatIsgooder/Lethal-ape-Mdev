// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Hidden/LethalApe/Runtime/Skybox Gradient" {
Properties {

_TopColor ("Top", Color) = (0.24,0.42,0.78,1)

_HorizonColor ("Horizon", Color) = (0.74,0.82,0.9,1)

_BottomColor ("Below Horizon", Color) = (0.28,0.3,0.33,1)

_Exponent ("Blend Softness", Range(0.1, 8)) = 1.399999976158142

[ToggleUI] _SunDisc ("Sun Disc", Float) = 1.0

_SunSize ("Sun Size", Range(0.001, 0.2)) = 0.03500000014901161

_SunColor ("Sun Colour", Color) = (1.4,1.3,1.1,1)

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
float4 _WorldSpaceLightPos0;
float4 _TopColor;
float4 _HorizonColor;
float4 _BottomColor;
float _Exponent;
float _SunDisc;
float _SunSize;
float4 _SunColor;
#define _41_m0 _WorldSpaceLightPos0
#define _41_m1 _TopColor
#define _41_m2 _HorizonColor
#define _41_m3 _BottomColor
#define _41_m4 _Exponent
#define _41_m5 _SunDisc
#define _41_m6 _SunSize
#define _41_m7 _SunColor



static float3 vs_TEXCOORD0;
static float4 _173;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _173 : SV_Target0;
};

static float3 _9;
static float _27;
static float3 _37;
static float3 _55;
static float3 _75;
static float3 _112;
static float _123;
static float _135;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD0;
    _27 = _9.y;
    _27 = clamp(_27, 0.0f, 1.0f);
    _27 = log2(_27);
    _37.x = 1.0f / _41_m4;
    _27 *= _37.x;
    _27 = exp2(_27);
    _55 = _41_m1.xyz + (-_41_m2.xyz);
    _55 = (_27.xxx * _55) + _41_m2.xyz;
    _75 = (-_55) + _41_m3.xyz;
    _27 = -_9.y;
    _27 = clamp(_27, 0.0f, 1.0f);
    _27 = log2(_27);
    _27 *= _37.x;
    _27 = exp2(_27);
    _37 = (_27.xxx * _75) + _55;
    _27 = dot(_41_m0.xyz, _41_m0.xyz);
    _27 = rsqrt(_27);
    _112 = _27.xxx * _41_m0.xyz;
    _9.x = dot(_9, _112);
    _123 = (-_41_m6) + 1.0f;
    _75.x = _9.x + (-_123);
    _135 = ((-_41_m6) * 0.3499999940395355224609375f) + 1.0f;
    _123 = (-_123) + _135;
    _123 = 1.0f / _123;
    _123 *= _75.x;
    _123 = clamp(_123, 0.0f, 1.0f);
    _75.x = (_123 * (-2.0f)) + 3.0f;
    _123 *= _123;
    _123 *= _75.x;
    _123 *= _41_m5;
    float3 _182 = (_41_m7.xyz * _123.xxx) + _37;
    _173 = float4(_182.x, _182.y, _182.z, _173.w);
    _173.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._173 = _173;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}