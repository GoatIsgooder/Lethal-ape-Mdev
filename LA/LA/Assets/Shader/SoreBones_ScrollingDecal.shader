// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SoreBones/ScrollingDecal" {
Properties {

_Color ("Color", Color) = (1,1,1,1)

_Decal ("Decal", 2D) = "white" { }

_ScrollingSpeed ("Scrolling Speed", Vector) = (0,0,0,0)

_DitherNoiseMap ("Dither Noise Map", 2D) = "white" { }

_ScrollingDither ("Scrolling Dither", Vector) = (0,0,0,0)

_DitherTile ("Dither Tile", Float) = 1.0

_DitherSize ("Dither Size", Float) = 1.0

_Vector2 ("Dither Clamp", Vector) = (0,1,0,0)

}
SubShader {
 LOD 100
 Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
 Pass {
Cull Back
ZWrite On
  LOD 100
  Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _Decal_ST;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 unity_FogParams
#define _20_m4 _Decal_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _126;
static float4 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _126 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    _48.x = _9.z / _20_m0.y;
    _48.x = (-_48.x) + 1.0f;
    _48.x *= _20_m0.z;
    _48.x = max(_48.x, 0.0f);
    _48.x *= _20_m3.y;
    vs_TEXCOORD1 = exp2(-_48.x);
    vs_TEXCOORD0 = (_126 * _20_m4.xy) + _20_m4.zw;
    _9.y *= _20_m0.x;
    float3 _148 = _9.xwy * 0.5f.xxx;
    _48 = float4(_148.x, _48.y, _148.y, _148.z);
    vs_TEXCOORD2 = float4(vs_TEXCOORD2.x, vs_TEXCOORD2.y, _9.zw.x, _9.zw.y);
    float2 _160 = _48.zz + _48.xw;
    vs_TEXCOORD2 = float4(_160.x, _160.y, vs_TEXCOORD2.z, vs_TEXCOORD2.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _126 = stage_input._126;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _ScreenParams;
float4 unity_FogColor;
float4 _Color;
float2 _ScrollingSpeed;
float2 _ScrollingDither;
float _DitherTile;
float _DitherSize;
float2 _Vector2;
#define _21_m0 _Time
#define _21_m1 _ScreenParams
#define _21_m2 unity_FogColor
#define _21_m3 _Color
#define _21_m4 _ScrollingSpeed
#define _21_m5 _ScrollingDither
#define _21_m6 _DitherTile
#define _21_m7 _DitherSize
#define _21_m8 _Vector2
static const uint4 _119[4] = { uint4(1065353216u, 0u, 0u, 0u), uint4(0u, 1065353216u, 0u, 0u), uint4(0u, 0u, 1065353216u, 0u), uint4(0u, 0u, 0u, 1065353216u) };



Texture2D<float4> _DitherNoiseMap;
SamplerState sampler_DitherNoiseMap;
Texture2D<float4> _Decal;
SamplerState sampler_Decal;

static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _303;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _303 : SV_Target0;
};

static float2 _9;
static bool2 _48;
static uint2 _102;
static float4 _106;
static float3 _188;
static float _215;
static bool _244;
static float4 _277;

void frag_inner()
{
    _9 = vs_TEXCOORD2.xy / vs_TEXCOORD2.ww;
    _9 *= _21_m1.xy;
    _9 /= float2(float2(_21_m7, _21_m7));
    _9 *= 0.25f.xx;
    float4 _53 = -_9.xyxy;
    _48 = bool4(_9.xyxy.x >= _53.x, _9.xyxy.y >= _53.y, _9.xyxy.z >= _53.z, _9.xyxy.w >= _53.w).xy;
    _9 = frac(abs(_9));
    float2 _61 = _9;
    float _69;
    if (_48.x)
    {
        _69 = _9.x;
    }
    else
    {
        _69 = -_9.x;
    }
    _61.x = _69;
    float _84;
    if (_48.y)
    {
        _84 = _9.y;
    }
    else
    {
        _84 = -_9.y;
    }
    _61.y = _84;
    _9 = _61;
    _9 *= 4.0f.xx;
    _102 = uint2(_9);
    _106.x = dot(float4(0.0625f, 0.8125f, 0.25f, 1.0f), asfloat(_119[int(_102.x)]));
    _106.y = dot(float4(0.5625f, 0.3125f, 0.75f, 0.5f), asfloat(_119[int(_102.x)]));
    _106.z = dot(float4(0.1875f, 0.9375f, 0.125f, 0.875f), asfloat(_119[int(_102.x)]));
    _106.w = dot(float4(0.6875f, 0.4375f, 0.625f, 0.375f), asfloat(_119[int(_102.x)]));
    _9.x = dot(_106, asfloat(_119[int(_102.y)]));
    float2 _199 = _21_m0.yy * float2(_21_m5.x, _21_m5.y);
    _188 = float3(_199.x, _199.y, _188.z);
    float2 _212 = (vs_TEXCOORD0 * _21_m6.xx) + _188.xy;
    _188 = float3(_212.x, _212.y, _188.z);
    _215 = _DitherNoiseMap.Sample(sampler_DitherNoiseMap, _188.xy).x;
    _188.x = max(_215, _21_m8.x);
    _188.x = min(_188.x, _21_m8.y);
    _9.x = (-_9.x) + _188.x;
    _244 = _9.x < 0.0f;
    if ((int(_244) * (-1)) != 0)
    {
        discard;
    }
    _9.x = vs_TEXCOORD1;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float2 _274 = (_21_m4 * _21_m0.xy) + vs_TEXCOORD0;
    _188 = float3(_274.x, _274.y, _188.z);
    _277 = _Decal.Sample(sampler_Decal, _188.xy);
    _188 = (_277.xyz * _21_m3.xyz) + (-_21_m2.xyz);
    _106.x = _277.w * _21_m3.w;
    _303.w = _106.x;
    float3 _315 = (_9.xxx * _188) + _21_m2.xyz;
    _303 = float4(_315.x, _315.y, _315.z, _303.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._303 = _303;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _Decal_ST;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 unity_FogParams
#define _20_m4 _Decal_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    _48.x = _9.z / _20_m0.y;
    _48.x = (-_48.x) + 1.0f;
    _48.x *= _20_m0.z;
    _48.x = max(_48.x, 0.0f);
    _48.x *= _20_m3.x;
    _48.x *= (-_48.x);
    vs_TEXCOORD1 = exp2(_48.x);
    vs_TEXCOORD0 = (_132 * _20_m4.xy) + _20_m4.zw;
    _9.y *= _20_m0.x;
    float3 _154 = _9.xwy * 0.5f.xxx;
    _48 = float4(_154.x, _48.y, _154.y, _154.z);
    vs_TEXCOORD2 = float4(vs_TEXCOORD2.x, vs_TEXCOORD2.y, _9.zw.x, _9.zw.y);
    float2 _166 = _48.zz + _48.xw;
    vs_TEXCOORD2 = float4(_166.x, _166.y, vs_TEXCOORD2.z, vs_TEXCOORD2.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _ScreenParams;
float4 unity_FogColor;
float4 _Color;
float2 _ScrollingSpeed;
float2 _ScrollingDither;
float _DitherTile;
float _DitherSize;
float2 _Vector2;
#define _21_m0 _Time
#define _21_m1 _ScreenParams
#define _21_m2 unity_FogColor
#define _21_m3 _Color
#define _21_m4 _ScrollingSpeed
#define _21_m5 _ScrollingDither
#define _21_m6 _DitherTile
#define _21_m7 _DitherSize
#define _21_m8 _Vector2
static const uint4 _119[4] = { uint4(1065353216u, 0u, 0u, 0u), uint4(0u, 1065353216u, 0u, 0u), uint4(0u, 0u, 1065353216u, 0u), uint4(0u, 0u, 0u, 1065353216u) };



Texture2D<float4> _DitherNoiseMap;
SamplerState sampler_DitherNoiseMap;
Texture2D<float4> _Decal;
SamplerState sampler_Decal;

static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _303;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _303 : SV_Target0;
};

static float2 _9;
static bool2 _48;
static uint2 _102;
static float4 _106;
static float3 _188;
static float _215;
static bool _244;
static float4 _277;

void frag_inner()
{
    _9 = vs_TEXCOORD2.xy / vs_TEXCOORD2.ww;
    _9 *= _21_m1.xy;
    _9 /= float2(float2(_21_m7, _21_m7));
    _9 *= 0.25f.xx;
    float4 _53 = -_9.xyxy;
    _48 = bool4(_9.xyxy.x >= _53.x, _9.xyxy.y >= _53.y, _9.xyxy.z >= _53.z, _9.xyxy.w >= _53.w).xy;
    _9 = frac(abs(_9));
    float2 _61 = _9;
    float _69;
    if (_48.x)
    {
        _69 = _9.x;
    }
    else
    {
        _69 = -_9.x;
    }
    _61.x = _69;
    float _84;
    if (_48.y)
    {
        _84 = _9.y;
    }
    else
    {
        _84 = -_9.y;
    }
    _61.y = _84;
    _9 = _61;
    _9 *= 4.0f.xx;
    _102 = uint2(_9);
    _106.x = dot(float4(0.0625f, 0.8125f, 0.25f, 1.0f), asfloat(_119[int(_102.x)]));
    _106.y = dot(float4(0.5625f, 0.3125f, 0.75f, 0.5f), asfloat(_119[int(_102.x)]));
    _106.z = dot(float4(0.1875f, 0.9375f, 0.125f, 0.875f), asfloat(_119[int(_102.x)]));
    _106.w = dot(float4(0.6875f, 0.4375f, 0.625f, 0.375f), asfloat(_119[int(_102.x)]));
    _9.x = dot(_106, asfloat(_119[int(_102.y)]));
    float2 _199 = _21_m0.yy * float2(_21_m5.x, _21_m5.y);
    _188 = float3(_199.x, _199.y, _188.z);
    float2 _212 = (vs_TEXCOORD0 * _21_m6.xx) + _188.xy;
    _188 = float3(_212.x, _212.y, _188.z);
    _215 = _DitherNoiseMap.Sample(sampler_DitherNoiseMap, _188.xy).x;
    _188.x = max(_215, _21_m8.x);
    _188.x = min(_188.x, _21_m8.y);
    _9.x = (-_9.x) + _188.x;
    _244 = _9.x < 0.0f;
    if ((int(_244) * (-1)) != 0)
    {
        discard;
    }
    _9.x = vs_TEXCOORD1;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float2 _274 = (_21_m4 * _21_m0.xy) + vs_TEXCOORD0;
    _188 = float3(_274.x, _274.y, _188.z);
    _277 = _Decal.Sample(sampler_Decal, _188.xy);
    _188 = (_277.xyz * _21_m3.xyz) + (-_21_m2.xyz);
    _106.x = _277.w * _21_m3.w;
    _303.w = _106.x;
    float3 _315 = (_9.xxx * _188) + _21_m2.xyz;
    _303 = float4(_315.x, _315.y, _315.z, _303.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._303 = _303;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _Decal_ST;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 unity_FogParams
#define _20_m4 _Decal_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _125;
static float4 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _125 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    _48.x = _9.z / _20_m0.y;
    _48.x = (-_48.x) + 1.0f;
    _48.x *= _20_m0.z;
    _48.x = max(_48.x, 0.0f);
    vs_TEXCOORD1 = (_48.x * _20_m3.z) + _20_m3.w;
    vs_TEXCOORD0 = (_125 * _20_m4.xy) + _20_m4.zw;
    _9.y *= _20_m0.x;
    float3 _147 = _9.xwy * 0.5f.xxx;
    _48 = float4(_147.x, _48.y, _147.y, _147.z);
    vs_TEXCOORD2 = float4(vs_TEXCOORD2.x, vs_TEXCOORD2.y, _9.zw.x, _9.zw.y);
    float2 _159 = _48.zz + _48.xw;
    vs_TEXCOORD2 = float4(_159.x, _159.y, vs_TEXCOORD2.z, vs_TEXCOORD2.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _125 = stage_input._125;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _ScreenParams;
float4 unity_FogColor;
float4 _Color;
float2 _ScrollingSpeed;
float2 _ScrollingDither;
float _DitherTile;
float _DitherSize;
float2 _Vector2;
#define _21_m0 _Time
#define _21_m1 _ScreenParams
#define _21_m2 unity_FogColor
#define _21_m3 _Color
#define _21_m4 _ScrollingSpeed
#define _21_m5 _ScrollingDither
#define _21_m6 _DitherTile
#define _21_m7 _DitherSize
#define _21_m8 _Vector2
static const uint4 _119[4] = { uint4(1065353216u, 0u, 0u, 0u), uint4(0u, 1065353216u, 0u, 0u), uint4(0u, 0u, 1065353216u, 0u), uint4(0u, 0u, 0u, 1065353216u) };



Texture2D<float4> _DitherNoiseMap;
SamplerState sampler_DitherNoiseMap;
Texture2D<float4> _Decal;
SamplerState sampler_Decal;

static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _303;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _303 : SV_Target0;
};

static float2 _9;
static bool2 _48;
static uint2 _102;
static float4 _106;
static float3 _188;
static float _215;
static bool _244;
static float4 _277;

void frag_inner()
{
    _9 = vs_TEXCOORD2.xy / vs_TEXCOORD2.ww;
    _9 *= _21_m1.xy;
    _9 /= float2(float2(_21_m7, _21_m7));
    _9 *= 0.25f.xx;
    float4 _53 = -_9.xyxy;
    _48 = bool4(_9.xyxy.x >= _53.x, _9.xyxy.y >= _53.y, _9.xyxy.z >= _53.z, _9.xyxy.w >= _53.w).xy;
    _9 = frac(abs(_9));
    float2 _61 = _9;
    float _69;
    if (_48.x)
    {
        _69 = _9.x;
    }
    else
    {
        _69 = -_9.x;
    }
    _61.x = _69;
    float _84;
    if (_48.y)
    {
        _84 = _9.y;
    }
    else
    {
        _84 = -_9.y;
    }
    _61.y = _84;
    _9 = _61;
    _9 *= 4.0f.xx;
    _102 = uint2(_9);
    _106.x = dot(float4(0.0625f, 0.8125f, 0.25f, 1.0f), asfloat(_119[int(_102.x)]));
    _106.y = dot(float4(0.5625f, 0.3125f, 0.75f, 0.5f), asfloat(_119[int(_102.x)]));
    _106.z = dot(float4(0.1875f, 0.9375f, 0.125f, 0.875f), asfloat(_119[int(_102.x)]));
    _106.w = dot(float4(0.6875f, 0.4375f, 0.625f, 0.375f), asfloat(_119[int(_102.x)]));
    _9.x = dot(_106, asfloat(_119[int(_102.y)]));
    float2 _199 = _21_m0.yy * float2(_21_m5.x, _21_m5.y);
    _188 = float3(_199.x, _199.y, _188.z);
    float2 _212 = (vs_TEXCOORD0 * _21_m6.xx) + _188.xy;
    _188 = float3(_212.x, _212.y, _188.z);
    _215 = _DitherNoiseMap.Sample(sampler_DitherNoiseMap, _188.xy).x;
    _188.x = max(_215, _21_m8.x);
    _188.x = min(_188.x, _21_m8.y);
    _9.x = (-_9.x) + _188.x;
    _244 = _9.x < 0.0f;
    if ((int(_244) * (-1)) != 0)
    {
        discard;
    }
    _9.x = vs_TEXCOORD1;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float2 _274 = (_21_m4 * _21_m0.xy) + vs_TEXCOORD0;
    _188 = float3(_274.x, _274.y, _188.z);
    _277 = _Decal.Sample(sampler_Decal, _188.xy);
    _188 = (_277.xyz * _21_m3.xyz) + (-_21_m2.xyz);
    _106.x = _277.w * _21_m3.w;
    _303.w = _106.x;
    float3 _315 = (_9.xxx * _188) + _21_m2.xyz;
    _303 = float4(_315.x, _315.y, _315.z, _303.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._303 = _303;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 _Decal_ST;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 _Decal_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _87;
static float4 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _87 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD2 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    vs_TEXCOORD0 = (_87 * _20_m3.xy) + _20_m3.zw;
    _9.y *= _20_m0.x;
    float3 _111 = _9.xwy * 0.5f.xxx;
    _48 = float4(_111.x, _48.y, _111.y, _111.z);
    vs_TEXCOORD2 = float4(vs_TEXCOORD2.x, vs_TEXCOORD2.y, _9.zw.x, _9.zw.y);
    float2 _123 = _48.zz + _48.xw;
    vs_TEXCOORD2 = float4(_123.x, _123.y, vs_TEXCOORD2.z, vs_TEXCOORD2.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _87 = stage_input._87;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _ScreenParams;
float4 _Color;
float2 _ScrollingSpeed;
float2 _ScrollingDither;
float _DitherTile;
float _DitherSize;
float2 _Vector2;
#define _21_m0 _Time
#define _21_m1 _ScreenParams
#define _21_m2 _Color
#define _21_m3 _ScrollingSpeed
#define _21_m4 _ScrollingDither
#define _21_m5 _DitherTile
#define _21_m6 _DitherSize
#define _21_m7 _Vector2
static const uint4 _119[4] = { uint4(1065353216u, 0u, 0u, 0u), uint4(0u, 1065353216u, 0u, 0u), uint4(0u, 0u, 1065353216u, 0u), uint4(0u, 0u, 0u, 1065353216u) };



Texture2D<float4> _DitherNoiseMap;
SamplerState sampler_DitherNoiseMap;
Texture2D<float4> _Decal;
SamplerState sampler_Decal;

static float4 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float4 _265;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD2 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _265 : SV_Target0;
};

static float2 _9;
static bool2 _48;
static uint2 _102;
static float4 _106;
static float2 _186;
static float _208;
static bool _236;
static float4 _259;

void frag_inner()
{
    _9 = vs_TEXCOORD2.xy / vs_TEXCOORD2.ww;
    _9 *= _21_m1.xy;
    _9 /= float2(float2(_21_m6, _21_m6));
    _9 *= 0.25f.xx;
    float4 _53 = -_9.xyxy;
    _48 = bool4(_9.xyxy.x >= _53.x, _9.xyxy.y >= _53.y, _9.xyxy.z >= _53.z, _9.xyxy.w >= _53.w).xy;
    _9 = frac(abs(_9));
    float2 _61 = _9;
    float _69;
    if (_48.x)
    {
        _69 = _9.x;
    }
    else
    {
        _69 = -_9.x;
    }
    _61.x = _69;
    float _84;
    if (_48.y)
    {
        _84 = _9.y;
    }
    else
    {
        _84 = -_9.y;
    }
    _61.y = _84;
    _9 = _61;
    _9 *= 4.0f.xx;
    _102 = uint2(_9);
    _106.x = dot(float4(0.0625f, 0.8125f, 0.25f, 1.0f), asfloat(_119[int(_102.x)]));
    _106.y = dot(float4(0.5625f, 0.3125f, 0.75f, 0.5f), asfloat(_119[int(_102.x)]));
    _106.z = dot(float4(0.1875f, 0.9375f, 0.125f, 0.875f), asfloat(_119[int(_102.x)]));
    _106.w = dot(float4(0.6875f, 0.4375f, 0.625f, 0.375f), asfloat(_119[int(_102.x)]));
    _9.x = dot(_106, asfloat(_119[int(_102.y)]));
    _186 = _21_m0.yy * float2(_21_m4.x, _21_m4.y);
    _186 = (vs_TEXCOORD0 * _21_m5.xx) + _186;
    _208 = _DitherNoiseMap.Sample(sampler_DitherNoiseMap, _186).x;
    _186.x = max(_208, _21_m7.x);
    _186.x = min(_186.x, _21_m7.y);
    _9.x = (-_9.x) + _186.x;
    _236 = _9.x < 0.0f;
    if ((int(_236) * (-1)) != 0)
    {
        discard;
    }
    _9 = (_21_m3 * _21_m0.xy) + vs_TEXCOORD0;
    _259 = _Decal.Sample(sampler_Decal, _9);
    _265 = _259 * _21_m2;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._265 = _265;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}