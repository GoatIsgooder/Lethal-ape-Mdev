// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Custom/TitleReveal" {
Properties {

_MainTex ("Title (white fill, transparent bg)", 2D) = "white" { }

_NoiseTex ("Dissolve Noise", 2D) = "gray" { }

_OutlineColor ("Outline Color", Color) = (0.6,0.7,1,1)

_FillColor ("Fill Color", Color) = (1,1,1,1)

_FillAmount ("Fill Amount", Range(0, 1)) = 0.0

_OutlineGlow ("Outline Glow", Range(0, 1)) = 0.0

_Dissolve ("Dissolve", Range(0, 1)) = 0.0

_DissolveEdge ("Dissolve Edge Width", Range(0, 0.2)) = 0.05000000074505806

_EdgeColor ("Dissolve Edge Color", Color) = (0.6,0.7,1,1)

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
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
float4 _MainTex_TexelSize;
float4 _OutlineColor;
float4 _FillColor;
float4 _EdgeColor;
float _FillAmount;
float _OutlineGlow;
float _Dissolve;
float _DissolveEdge;
#define _19_m0 _MainTex_TexelSize
#define _19_m1 _OutlineColor
#define _19_m2 _FillColor
#define _19_m3 _EdgeColor
#define _19_m4 _FillAmount
#define _19_m5 _OutlineGlow
#define _19_m6 _Dissolve
#define _19_m7 _DissolveEdge


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float2 vs_TEXCOORD0;
static float4 _288;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _288 : SV_Target0;
};

static float4 _9;
static float4 _32;
static float2 _45;
static float2 _63;
static float _87;
static float4 _137;
static float _151;
static float _157;
static float3 _190;
static float _224;
static float _230;
static bool _239;

void frag_inner()
{
    _9.x = 0.0f;
    _9.w = 0.0f;
    float2 _29 = _19_m0.yx * 2.0f.xx;
    _9 = float4(_9.x, _29.x, _29.y, _9.w);
    _32 = _9 + vs_TEXCOORD0.xyxy;
    _9 = (-_9) + vs_TEXCOORD0.xyxy;
    _45.x = _MainTex.Sample(sampler_MainTex, _32.xy).w;
    _45.y = _MainTex.Sample(sampler_MainTex, _32.zw).w;
    _63.x = _MainTex.Sample(sampler_MainTex, _9.xy).w;
    _63.y = _MainTex.Sample(sampler_MainTex, _9.zw).w;
    float2 _78 = max(_63, _45);
    _9 = float4(_78.x, _78.y, _9.z, _9.w);
    _9.x = max(_9.y, _9.x);
    _87 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).w;
    _9.x = (-_87) + _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _110 = _9.xxx * _19_m1.xyz;
    _32 = float4(_110.x, _110.y, _110.z, _32.w);
    _9.x *= _19_m5;
    float3 _134 = _32.xyz * float3(float3(_19_m5, _19_m5, _19_m5));
    _32 = float4(_134.x, _134.y, _134.z, _32.w);
    float3 _148 = (_19_m2.xyz * _87.xxx) + (-_32.xyz);
    _137 = float4(_148.x, _148.y, _148.z, _137.w);
    _151 = _19_m4 + (-0.039999999105930328369140625f);
    _157 = (-_151) + _19_m4;
    _151 = (-_151) + vs_TEXCOORD0.x;
    _157 = 1.0f / _157;
    _151 = _157 * _151;
    _151 = clamp(_151, 0.0f, 1.0f);
    _157 = (_151 * (-2.0f)) + 3.0f;
    _151 *= _151;
    _151 = ((-_157) * _151) + 1.0f;
    _190.x = _151 * _87;
    float3 _202 = (_190.xxx * _137.xyz) + _32.xyz;
    _32 = float4(_202.x, _202.y, _202.z, _32.w);
    _9.x = max(_190.x, _9.x);
    _190 = _32.xyz + (-_19_m3.xyz);
    _32.x = 1.0f / _19_m7;
    _224 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0).x;
    _230 = _224 + (-_19_m6);
    _239 = _224 >= _19_m6;
    _224 = float(_239);
    _137.w = _9.x * _224;
    _9.x = _32.x * _230;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _32.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _32.x;
    float3 _284 = (_9.xxx * _190) + _19_m3.xyz;
    _137 = float4(_284.x, _284.y, _284.z, _137.w);
    _288 = _137;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._288 = _288;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}