// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "LethalApeR/Rivals/ScopeLens" {
Properties {

_MainTex ("Scope View (set by script)", 2D) = "black" { }

_Active ("Active", Range(0, 1)) = 0.0

_LensRadius ("Lens Radius (UV)", Range(0.1, 0.5)) = 0.47999998927116394

_EdgeSoftness ("Edge Softness", Range(0.001, 0.1)) = 0.014999999664723873

_RingColor ("Ring Color", Color) = (0.02,0.02,0.02,1)

_RingWidth ("Ring Width (UV)", Range(0, 0.2)) = 0.05000000074505806

_InactiveColor ("Inactive Glass Color", Color) = (0.03,0.05,0.06,1)

_VignetteStrength ("In-Scope Vignette", Range(0, 1)) = 0.44999998807907104

_CrosshairColor ("Crosshair Color", Color) = (0,0,0,0.9)

_CrosshairThickness ("Crosshair Thickness (UV)", Range(0, 0.01)) = 0.0020000000949949026

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
Cull Back
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
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
float _Active;
float _LensRadius;
float _EdgeSoftness;
float4 _RingColor;
float _RingWidth;
float4 _InactiveColor;
float _VignetteStrength;
float4 _CrosshairColor;
float _CrosshairThickness;
#define _27_m0 _Active
#define _27_m1 _LensRadius
#define _27_m2 _EdgeSoftness
#define _27_m3 _RingColor
#define _27_m4 _RingWidth
#define _27_m5 _InactiveColor
#define _27_m6 _VignetteStrength
#define _27_m7 _CrosshairColor
#define _27_m8 _CrosshairThickness


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _289;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _289 : SV_Target0;
};

static float3 _9;
static float4 _23;
static float _53;
static float4 _62;
static float2 _75;
static float _80;
static bool2 _96;
static float _105;
static float3 _156;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _35 = _9 + (-_27_m5.xyz);
    _23 = float4(_35.x, _35.y, _35.z, _23.w);
    float3 _49 = (_27_m0.xxx * _23.xyz) + _27_m5.xyz;
    _23 = float4(_49.x, _49.y, _49.z, _23.w);
    _53 = _27_m1 + (-_27_m4);
    _62.x = _53 * 0.449999988079071044921875f;
    _62.x = 1.0f / _62.x;
    _75 = vs_TEXCOORD0 + (-0.5f).xx;
    _80 = dot(_75, _75);
    _75.x = min(abs(_75.y), abs(_75.x));
    _96.y = _27_m8 >= _75.x;
    _105 = sqrt(_80);
    _80 = ((-_53) * 0.550000011920928955078125f) + _105;
    _62.x *= _80;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _80 = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _80;
    _62.x *= _27_m6;
    _62.x = ((-_62.x) * _27_m0) + 1.0f;
    _156 = _23.xyz * _62.xxx;
    float3 _172 = ((-_23.xyz) * _62.xxx) + _27_m7.xyz;
    _23 = float4(_172.x, _172.y, _172.z, _23.w);
    _96.x = _53 >= _105;
    _53 = (-_53) + _105;
    _105 += (-_27_m1);
    _62.x = float(_96.x);
    _62.y = float(_96.y);
    _62.x *= _62.y;
    _62.x *= _27_m7.w;
    _62.x *= _27_m0;
    float3 _221 = (_62.xxx * _23.xyz) + _156;
    _23 = float4(_221.x, _221.y, _221.z, _23.w);
    float3 _231 = (-_23.xyz) + _27_m3.xyz;
    _62 = float4(_231.x, _231.y, _62.z, _231.z);
    _156.x = 1.0f / _27_m2;
    _53 *= _156.x;
    _53 = clamp(_53, 0.0f, 1.0f);
    _105 *= _156.x;
    _105 = clamp(_105, 0.0f, 1.0f);
    _156.x = (_53 * (-2.0f)) + 3.0f;
    _53 *= _53;
    _53 *= _156.x;
    float3 _269 = (_53.xxx * _62.xyw) + _23.xyz;
    _23 = float4(_269.x, _269.y, _269.z, _23.w);
    _62.x = (_105 * (-2.0f)) + 3.0f;
    _75.x = _105 * _105;
    _23.w = ((-_62.x) * _75.x) + 1.0f;
    _289 = _23;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._289 = _289;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}