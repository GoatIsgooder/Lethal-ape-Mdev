// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MenuRail" {
Properties {

_LineColor ("Line Colour", Color) = (0.82,0.82,0.82,1)

_TabColor ("Tab Colour", Color) = (0.42,0.42,0.42,1)

_LineWidth ("Line Width (m)", Float) = 0.0015999999595806003

_TabWidth ("Tab Width (m)", Float) = 0.07000000029802322

_Reveal ("Reveal", Range(0, 1)) = 1.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One OneMinusSrcAlpha
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
static float2 vs_TEXCOORD1;
static float2 _89;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
    float2 _89 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
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
    vs_TEXCOORD1 = _89;
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
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _LineColor;
float4 _TabColor;
float _LineWidth;
float _TabWidth;
float _Reveal;
#define _12_m0 _LineColor
#define _12_m1 _TabColor
#define _12_m2 _LineWidth
#define _12_m3 _TabWidth
#define _12_m4 _Reveal



static float2 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _272;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _272 : SV_Target0;
};

static float4 _9;
static float _24;
static float4 _35;
static bool _122;
static float4 _134;
static float _160;
static float _245;
static float _254;
static float4 _260;

void frag_inner()
{
    _9.x = _12_m3 * 0.5f;
    _24 = vs_TEXCOORD1.x * _12_m4;
    _35.x = max(_24, 9.9999997473787516355514526367188e-05f);
    _35.z = min(_9.x, _35.x);
    _35 = float4(_35.x, vs_TEXCOORD1.yy.x, _35.z, vs_TEXCOORD1.yy.y);
    _9 = (-_35.zwxy) + abs(vs_TEXCOORD0.xyxy);
    float2 _63 = max(_9.xy, 0.0f.xx);
    _35 = float4(_63.x, _63.y, _35.z, _35.w);
    _9.x = max(_9.y, _9.x);
    _9.x = min(_9.x, 0.0f);
    _24 = dot(_35.xy, _35.xy);
    _24 = sqrt(_24);
    _9.x += _24;
    _24 = ddx_coarse(_9.x);
    _35.x = ddy_coarse(_9.x);
    _24 = abs(_24) + abs(_35.x);
    _24 = max(_24, 9.9999997473787516355514526367188e-06f);
    _9.x /= _24;
    _9.x = (-_9.x) + 0.5f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _122 = _12_m4 >= 0.001000000047497451305389404296875f;
    _24 = float(_122);
    _9.x = _24 * _9.x;
    float3 _144 = _12_m1.www * _12_m1.xyz;
    _134 = float4(_144.x, _144.y, _144.z, _134.w);
    _134.w = _12_m1.w;
    _35 = _9.xxxx * _134;
    float2 _157 = max(_9.zw, 0.0f.xx);
    _9 = float4(_157.x, _157.y, _9.z, _9.w);
    _160 = max(_9.w, _9.z);
    _160 = min(_160, 0.0f);
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x = _160 + _9.x;
    _24 = ddx_coarse(_9.x);
    _160 = ddy_coarse(_9.x);
    _24 = abs(_160) + abs(_24);
    _24 = max(_24, 9.9999997473787516355514526367188e-06f);
    _160 = max(_24, _12_m2);
    _9.z = _160 + _9.x;
    float2 _210 = _9.xz / _24.xx;
    _9 = float4(_210.x, _9.y, _210.y, _9.w);
    _24 = _12_m2 / _24;
    _24 = clamp(_24, 0.0f, 1.0f);
    float2 _223 = (-_9.xz) + 0.5f.xx;
    _9 = float4(_223.x, _9.y, _223.y, _9.w);
    float2 _230 = clamp(_9.xz, 0.0f.xx, 1.0f.xx);
    _9 = float4(_230.x, _9.y, _230.y, _9.w);
    _9.x = (-_9.z) + _9.x;
    _9.x = _24 * _9.x;
    _245 = ((-_9.x) * _12_m0.w) + 1.0f;
    _254 = _9.x * _12_m0.w;
    float3 _266 = _254.xxx * _12_m0.xyz;
    _260 = float4(_266.x, _266.y, _266.z, _260.w);
    _260.w = _254;
    _272 = (_35 * _245.xxxx) + _260;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._272 = _272;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}