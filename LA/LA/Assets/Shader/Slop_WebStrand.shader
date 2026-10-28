// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/WebStrand" {
Properties {

_Color ("Tint", Color) = (1,1,1,1)

_Alpha ("Alpha (fade)", Range(0, 1)) = 1.0

_Intensity ("Intensity", Range(0, 4)) = 1.0

[Header(Core)] _CoreWidth ("Core Width", Range(0.01, 1)) = 0.44999998807907104

_CoreFalloff ("Core Falloff", Range(0.2, 6)) = 1.600000023841858

[Header(Filaments)] _Twist ("Braid Frequency", Range(0, 8)) = 0.5

_TwistAmp ("Braid Spread", Range(0, 0.5)) = 0.18000000715255737

_FilamentWidth ("Filament Width", Range(0.01, 0.5)) = 0.12999999523162842

_FilamentStrength ("Filament Strength", Range(0, 2)) = 0.699999988079071

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
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
float _Alpha;
float _Intensity;
float _CoreWidth;
float _CoreFalloff;
float _Twist;
float _TwistAmp;
float _FilamentWidth;
float _FilamentStrength;
#define _20_m0 _Color
#define _20_m1 _Alpha
#define _20_m2 _Intensity
#define _20_m3 _CoreWidth
#define _20_m4 _CoreFalloff
#define _20_m5 _Twist
#define _20_m6 _TwistAmp
#define _20_m7 _FilamentWidth
#define _20_m8 _FilamentStrength



static float2 vs_TEXCOORD0;
static float4 _156;
static float4 _192;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 _156 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _192 : SV_Target0;
};

static float4 _9;
static float _46;
static float _51;
static float _60;
static float3 _167;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.x * _20_m5;
    _9.y = _9.x * 6.283185482025146484375f;
    _9.x = (_9.x * 6.283185482025146484375f) + 3.1415927410125732421875f;
    float2 _43 = sin(_9.xy);
    _9 = float4(_43.x, _43.y, _9.z, _9.w);
    _46 = vs_TEXCOORD0.y + (-0.5f);
    _51 = (_9.y * _20_m6) + _46;
    _60 = max(_20_m7, 0.001000000047497451305389404296875f);
    _51 = abs(_51) / _60;
    _9.y = (-_51) + 1.0f;
    _9.x = (_9.x * _20_m6) + _46;
    _46 = abs(_46) + abs(_46);
    _9.x = abs(_9.x) / _60;
    _9.x = (-_9.x) + 1.0f;
    float2 _103 = max(_9.xy, 0.0f.xx);
    _9 = float4(_103.x, _103.y, _9.z, _9.w);
    _9.x += _9.y;
    _51 = max(_20_m3, 0.001000000047497451305389404296875f);
    _51 = _46 / _51;
    _51 = (-_51) + 1.0f;
    _51 = max(_51, 0.0f);
    _51 = log2(_51);
    _51 *= _20_m4;
    _51 = exp2(_51);
    _9.x = (_9.x * _20_m8) + _51;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _51 = _20_m0.w * _20_m1;
    _51 *= _156.w;
    _9.w = _51 * _9.x;
    _167 = _156.xyz * _20_m0.xyz;
    float3 _188 = _167 * float3(float3(_20_m2, _20_m2, _20_m2));
    _9 = float4(_188.x, _188.y, _188.z, _9.w);
    _192 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _156 = stage_input._156;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._192 = _192;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}