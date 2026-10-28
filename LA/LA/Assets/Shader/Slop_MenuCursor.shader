// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MenuCursor" {
Properties {

_Color ("Colour", Color) = (1,1,1,1)

_Ring ("Ring Radius", Range(0, 1)) = 0.7200000286102295

_RingWidth ("Ring Width", Range(0, 0.5)) = 0.1599999964237213

_DotRadius ("Dot Radius", Range(0, 1)) = 0.2199999988079071

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+50" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+50" "RenderType" = "Transparent" }
 ZTest Always
 ZWrite Off
 Cull Off
   Blend One OneMinusSrcAlpha
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
    vs_TEXCOORD0 = (_86 * 2.0f.xx) + (-1.0f).xx;
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
float _Ring;
float _RingWidth;
float _DotRadius;
#define _36_m0 _Color
#define _36_m1 _Ring
#define _36_m2 _RingWidth
#define _36_m3 _DotRadius



static float2 vs_TEXCOORD0;
static float4 _132;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _132 : SV_Target0;
};

static float4 _9;
static float _24;
static float _28;
static bool _94;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = sqrt(_9.x);
    _24 = ddx_coarse(_9.x);
    _28 = ddy_coarse(_9.x);
    float2 _47 = _9.xx + (-float2(_36_m1, _36_m3));
    _9 = float4(_47.x, _9.y, _9.z, _47.y);
    _24 = abs(_28) + abs(_24);
    _24 = max(_24, 9.9999997473787516355514526367188e-05f);
    _9.x = ((-_36_m2) * 0.5f) + abs(_9.x);
    float2 _73 = _9.xw / _24.xx;
    _9 = float4(_73.x, _9.y, _73.y, _9.w);
    float2 _80 = (-_9.xz) + 0.5f.xx;
    _9 = float4(_80.x, _80.y, _9.z, _9.w);
    float2 _89 = clamp(_9.xy, 0.0f.xx, 1.0f.xx);
    _9 = float4(_89.x, _89.y, _9.z, _9.w);
    _94 = _36_m2 >= 0.001000000047497451305389404296875f;
    _28 = float(_94);
    _9.x = _28 * _9.x;
    _9.x = max(_9.y, _9.x);
    _9.w = _9.x * _36_m0.w;
    float3 _128 = _9.www * _36_m0.xyz;
    _9 = float4(_128.x, _128.y, _128.z, _9.w);
    _132 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._132 = _132;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}