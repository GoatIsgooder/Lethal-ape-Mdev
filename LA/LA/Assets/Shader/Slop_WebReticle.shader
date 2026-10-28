// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/WebReticle" {
Properties {

_Color ("Colour", Color) = (1,1,1,0.95)

_Intensity ("Intensity", Range(0, 4)) = 1.0

[Header(Ring)] _RingRadius ("Ring Radius", Range(0, 1)) = 0.550000011920929

_RingThickness ("Ring Thickness", Range(0, 0.4)) = 0.07000000029802322

[Header(Centre)] _DotRadius ("Dot Radius", Range(0, 0.5)) = 0.05999999865889549

[Header(Ticks)] _TickWidth ("Tick Width", Range(0, 0.2)) = 0.03500000014901161

_TickGap ("Tick Gap", Range(0, 0.5)) = 0.09000000357627869

_TickLength ("Tick Length", Range(0, 0.5)) = 0.2199999988079071

_Edge ("Edge Softness", Range(0.001, 0.1)) = 0.012000000104308128

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay" "RenderType" = "Transparent" }
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
float _RingRadius;
float _RingThickness;
float _DotRadius;
float _TickWidth;
float _TickGap;
float _TickLength;
float _Edge;
#define _53_m0 _Color
#define _53_m1 _Intensity
#define _53_m2 _RingRadius
#define _53_m3 _RingThickness
#define _53_m4 _DotRadius
#define _53_m5 _TickWidth
#define _53_m6 _TickGap
#define _53_m7 _TickLength
#define _53_m8 _Edge



static float2 vs_TEXCOORD0;
static float4 _348;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _348 : SV_Target0;
};

static float4 _9;
static float _24;
static float _32;
static float2 _36;
static float3 _70;
static float2 _80;
static float2 _104;
static float _311;

void frag_inner()
{
    float2 _20 = (vs_TEXCOORD0.yx * 2.0f.xx) + (-1.0f).xx;
    _9 = float4(_20.x, _20.y, _9.z, _9.w);
    _24 = dot(_9.xy, _9.xy);
    _24 = sqrt(_24);
    _32 = ddx_coarse(_24);
    _36.x = ddy_coarse(_24);
    _32 = abs(_32) + abs(_36.x);
    _32 = (_32 * 1.5f) + _53_m8;
    _36.x = _53_m2 + _53_m6;
    _70.x = (-_32) + _36.x;
    _32 = 1.0f / _32;
    _80.x = (-_70.x) + _36.x;
    float2 _94 = abs(_9.xy) + (-_70.xx);
    _70 = float3(_94.x, _70.y, _94.y);
    _36.x += _53_m7;
    _104 = abs(_9.xy) + (-_36.xx);
    float2 _120 = abs(_9.yx) + (-_53_m5.xx);
    _9 = float4(_120.x, _120.y, _9.z, _9.w);
    float2 _127 = _32.xx * _9.xy;
    _9 = float4(_127.x, _127.y, _9.z, _9.w);
    float2 _135 = clamp(_9.xy, 0.0f.xx, 1.0f.xx);
    _9 = float4(_135.x, _135.y, _9.z, _9.w);
    _104 = _32.xx * _104;
    _104 = clamp(_104, 0.0f.xx, 1.0f.xx);
    _36.x = 1.0f / _80.x;
    _36 = _36.xx * _70.xz;
    _36 = clamp(_36, 0.0f.xx, 1.0f.xx);
    _80 = (_36 * (-2.0f).xx) + 3.0f.xx;
    _36 *= _36;
    _36 *= _80;
    _80 = (_9.xy * (-2.0f).xx) + 3.0f.xx;
    float2 _180 = _9.xy * _9.xy;
    _9 = float4(_180.x, _180.y, _9.z, _9.w);
    float2 _189 = ((-_80) * _9.xy) + 1.0f.xx;
    _9 = float4(_189.x, _189.y, _9.z, _9.w);
    float2 _195 = _36 * _9.xy;
    _9 = float4(_195.x, _195.y, _9.z, _9.w);
    _36 = _24.xx + (-float2(_53_m2, _53_m4));
    _24 += (-0.980000019073486328125f);
    _24 *= 50.000049591064453125f;
    _24 = clamp(_24, 0.0f, 1.0f);
    _36.x = ((-_53_m3) * 0.5f) + abs(_36.x);
    _70.x = _32 * _36.y;
    _70.x = clamp(_70.x, 0.0f, 1.0f);
    _32 *= _36.x;
    _32 = clamp(_32, 0.0f, 1.0f);
    _36.x = (_32 * (-2.0f)) + 3.0f;
    _32 *= _32;
    _32 = ((-_36.x) * _32) + 1.0f;
    _36.x = (_70.x * (-2.0f)) + 3.0f;
    _70.x *= _70.x;
    _32 = ((-_36.x) * _70.x) + _32;
    _36 = (_104 * (-2.0f).xx) + 3.0f.xx;
    _80 = _104 * _104;
    _36 = ((-_36) * _80) + 1.0f.xx;
    _9.x = (_9.x * _36.x) + _32;
    _9.x = (_9.y * _36.y) + _9.x;
    _9.x += 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _311 = (_24 * (-2.0f)) + 3.0f;
    _24 *= _24;
    _311 = ((-_311) * _24) + 1.0f;
    _9.x = _311 * _9.x;
    _9.w = _9.x * _53_m0.w;
    float3 _344 = _53_m0.xyz * _53_m1.xxx;
    _9 = float4(_344.x, _344.y, _344.z, _9.w);
    _348 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._348 = _348;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}