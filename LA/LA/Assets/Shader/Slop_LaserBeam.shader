// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/LaserBeam" {
Properties {

_CoreColor ("Core Color", Color) = (1,0.15,0.12,1)

_GlowColor ("Glow Color", Color) = (1,0,0,1)

_CoreSharp ("Core Sharpness", Range(1, 24)) = 9.0

_GlowFalloff ("Glow Falloff", Range(0.5, 8)) = 2.200000047683716

_Intensity ("Intensity", Float) = 2.0

_Pulse ("Pulse Amount", Range(0, 1)) = 0.11999999731779099

_PulseSpeed ("Pulse Speed", Float) = 9.0

_NoiseTex ("Energy Texture (RGB, optional)", 2D) = "white" { }

_NoiseTiling ("Energy Tiling (x=along, y=across)", Vector) = (6,1,0,0)

_ScrollSpeed ("Energy Scroll Speed", Float) = 3.0

_EndFade ("End Softness", Range(0, 0.5)) = 0.05999999865889549

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One One
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
float4 _Time;
float4 _CoreColor;
float4 _GlowColor;
float _CoreSharp;
float _GlowFalloff;
float _Intensity;
float _Pulse;
float _PulseSpeed;
float4 _NoiseTiling;
float _ScrollSpeed;
float _EndFade;
#define _28_m0 _Time
#define _28_m1 _CoreColor
#define _28_m2 _GlowColor
#define _28_m3 _CoreSharp
#define _28_m4 _GlowFalloff
#define _28_m5 _Intensity
#define _28_m6 _Pulse
#define _28_m7 _PulseSpeed
#define _28_m8 _NoiseTiling
#define _28_m9 _ScrollSpeed
#define _28_m10 _EndFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float2 vs_TEXCOORD0;
static float4 _223;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _223 : SV_Target0;
};

static float3 _9;
static float3 _24;
static float _57;
static float3 _96;
static float _118;

void frag_inner()
{
    _9.x = (-vs_TEXCOORD0.y) + 1.0f;
    _24.x = 1.0f / _28_m10;
    _9.x = _24.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _24.x *= vs_TEXCOORD0.y;
    _24.x = clamp(_24.x, 0.0f, 1.0f);
    _57 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _57;
    _57 = (_24.x * (-2.0f)) + 3.0f;
    _24.x *= _24.x;
    _24.x *= _57;
    _9.x *= _24.x;
    float2 _103 = vs_TEXCOORD0 * _28_m8.yx;
    _96 = float3(_103.x, _103.y, _96.z);
    _96.z = (_28_m0.y * _28_m9) + _96.y;
    _118 = _NoiseTex.Sample(sampler_NoiseTex, _96.xz).x;
    _24.x = (_118 * 0.599999964237213134765625f) + 0.699999988079071044921875f;
    _57 = _28_m0.y * _28_m7;
    _57 = sin(_57);
    _57 = (_57 * _28_m6) + 1.0f;
    _57 *= _28_m5;
    _24.x *= _57;
    _9.x *= _24.x;
    _24.x = vs_TEXCOORD0.x + (-0.5f);
    _24.x = ((-abs(_24.x)) * 2.0f) + 1.0f;
    _24.x = max(_24.x, 0.0f);
    _24.x = log2(_24.x);
    float2 _194 = _24.xx * float2(_28_m3, _28_m4);
    _24 = float3(_194.x, _194.y, _24.z);
    float2 _199 = exp2(_24.xy);
    _24 = float3(_199.x, _199.y, _24.z);
    _96 = _24.yyy * _28_m2.xyz;
    _24 = (_28_m1.xyz * _24.xxx) + _96;
    _9 = _9.xxx * _24;
    _223 = float4(_9.x, _9.y, _9.z, _223.w);
    _223.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._223 = _223;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}