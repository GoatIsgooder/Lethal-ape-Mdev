// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SoreBones/PumkinGlow" {
Properties {

_GlowMask ("Glow Mask (R)", 2D) = "black" { }

_GlowColor ("Glow Color", Color) = (0.35,1,0.25,1)

_HotColor ("Hot Color", Color) = (0.85,1,0.8,1)

_Intensity ("Intensity", Range(0, 6)) = 1.600000023841858

_Falloff ("Falloff", Range(0.5, 6)) = 2.200000047683716

_HotFalloff ("Hot Falloff", Range(1, 16)) = 6.0

[Header(Pixelation)] _PixelGrid ("Pixel Grid (UV)", Float) = 128.0

_FrameRate ("Frame Rate", Range(1, 60)) = 12.0

_Steps ("Color Steps", Range(2, 16)) = 4.0

[Header(Pulse)] _PulseSpeed ("Pulse Speed", Float) = 1.7999999523162842

_PulseAmount ("Pulse Amount", Range(0, 0.6)) = 0.15000000596046448

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
 Pass {
Cull Back
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
 ZWrite Off
 Offset -1.0, -1.0
   Blend One One
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



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _146;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _146 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _43;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _43 = _9 + _20_m1[3];
    float3 _58 = (_20_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    vs_TEXCOORD1 = dot(_9.xyz, float3(0.37000000476837158203125f, 0.20999999344348907470703125f, 0.2899999916553497314453125f));
    _9 = _43.yyyy * _20_m2[1];
    _9 = (_20_m2[0] * _43.xxxx) + _9;
    _9 = (_20_m2[2] * _43.zzzz) + _9;
    _9 = (_20_m2[3] * _43.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    vs_TEXCOORD0 = _146;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _GlowColor;
float4 _HotColor;
float _Intensity;
float _Falloff;
float _HotFalloff;
float _PixelGrid;
float _FrameRate;
float _Steps;
float _PulseSpeed;
float _PulseAmount;
#define _16_m0 _Time
#define _16_m1 _GlowColor
#define _16_m2 _HotColor
#define _16_m3 _Intensity
#define _16_m4 _Falloff
#define _16_m5 _HotFalloff
#define _16_m6 _PixelGrid
#define _16_m7 _FrameRate
#define _16_m8 _Steps
#define _16_m9 _PulseSpeed
#define _16_m10 _PulseAmount


Texture2D<float4> _GlowMask;
SamplerState sampler_GlowMask;

static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _297;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _297 : SV_Target0;
};

static float3 _9;
static float2 _54;
static float2 _61;
static float _79;
static float2 _98;
static float3 _152;
static float _187;
static float3 _222;
static float3 _261;

void frag_inner()
{
    _9.x = vs_TEXCOORD1 + _16_m0.y;
    _9.x *= _16_m7;
    _9.x = floor(_9.x);
    _9.x /= _16_m7;
    _9.x *= _16_m9;
    _54.x = floor(_9.x);
    _54.y = 0.0f;
    _61 = _54 + float2(1.0f, 0.0f);
    _54 *= float2(123.339996337890625f, 456.209991455078125f);
    _54 = frac(_54);
    float2 _74 = _61 * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float3(_9.x, _74.x, _74.y);
    _9 = frac(_9);
    _79 = _9.y + 45.31999969482421875f;
    _61 = (_9.yy * _79.xx) + _9.yz;
    _61.x = _61.y * _61.x;
    _98.x = _54.x + 45.31999969482421875f;
    _98 = (_54.xx * _98.xx) + _54;
    _61.y = _98.y * _98.x;
    _61 = frac(_61);
    _61.x = (-_61.y) + _61.x;
    _79 = _9.x * _9.x;
    _9.x = ((-_9.x) * 2.0f) + 3.0f;
    _9.x *= _79;
    _9.x = (_9.x * _61.x) + _61.y;
    _152.x = (-_16_m10) + 1.0f;
    _9.x = (_16_m10 * _9.x) + _152.x;
    _61 = vs_TEXCOORD0 * _16_m6.xx;
    _61 = floor(_61);
    _61 += 0.5f.xx;
    _61 /= _16_m6.xx;
    _187 = _GlowMask.Sample(sampler_GlowMask, _61).x;
    _152.x = log2(_187);
    float2 _208 = _152.xx * float2(_16_m4, _16_m5);
    _152 = float3(_208.x, _208.y, _152.z);
    float2 _213 = exp2(_152.xy);
    _152 = float3(_213.x, _213.y, _152.z);
    _152.x = _9.x * _152.x;
    _222.x = (_152.y * _16_m8) + 0.5f;
    _152.y = floor(_222.x);
    _152.x = (_152.x * _16_m8) + 0.5f;
    _152.x = floor(_152.x);
    float2 _251 = _152.xy / _16_m8.xx;
    _152 = float3(_251.x, _251.y, _152.z);
    _152.x *= _16_m3;
    _261 = (-_16_m1.xyz) + _16_m2.xyz;
    _222 = (_152.yyy * _261) + _16_m1.xyz;
    _152 = _152.xxx * _222;
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9 = _152 * _9.xxx;
    _297 = float4(_9.x, _9.y, _9.z, _297.w);
    _297.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._297 = _297;
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



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _152;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _152 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _43;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _43 = _9 + _20_m1[3];
    float3 _58 = (_20_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    vs_TEXCOORD1 = dot(_9.xyz, float3(0.37000000476837158203125f, 0.20999999344348907470703125f, 0.2899999916553497314453125f));
    _9 = _43.yyyy * _20_m2[1];
    _9 = (_20_m2[0] * _43.xxxx) + _9;
    _9 = (_20_m2[2] * _43.zzzz) + _9;
    _9 = (_20_m2[3] * _43.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    vs_TEXCOORD0 = _152;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _152 = stage_input._152;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _GlowColor;
float4 _HotColor;
float _Intensity;
float _Falloff;
float _HotFalloff;
float _PixelGrid;
float _FrameRate;
float _Steps;
float _PulseSpeed;
float _PulseAmount;
#define _16_m0 _Time
#define _16_m1 _GlowColor
#define _16_m2 _HotColor
#define _16_m3 _Intensity
#define _16_m4 _Falloff
#define _16_m5 _HotFalloff
#define _16_m6 _PixelGrid
#define _16_m7 _FrameRate
#define _16_m8 _Steps
#define _16_m9 _PulseSpeed
#define _16_m10 _PulseAmount


Texture2D<float4> _GlowMask;
SamplerState sampler_GlowMask;

static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _297;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _297 : SV_Target0;
};

static float3 _9;
static float2 _54;
static float2 _61;
static float _79;
static float2 _98;
static float3 _152;
static float _187;
static float3 _222;
static float3 _261;

void frag_inner()
{
    _9.x = vs_TEXCOORD1 + _16_m0.y;
    _9.x *= _16_m7;
    _9.x = floor(_9.x);
    _9.x /= _16_m7;
    _9.x *= _16_m9;
    _54.x = floor(_9.x);
    _54.y = 0.0f;
    _61 = _54 + float2(1.0f, 0.0f);
    _54 *= float2(123.339996337890625f, 456.209991455078125f);
    _54 = frac(_54);
    float2 _74 = _61 * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float3(_9.x, _74.x, _74.y);
    _9 = frac(_9);
    _79 = _9.y + 45.31999969482421875f;
    _61 = (_9.yy * _79.xx) + _9.yz;
    _61.x = _61.y * _61.x;
    _98.x = _54.x + 45.31999969482421875f;
    _98 = (_54.xx * _98.xx) + _54;
    _61.y = _98.y * _98.x;
    _61 = frac(_61);
    _61.x = (-_61.y) + _61.x;
    _79 = _9.x * _9.x;
    _9.x = ((-_9.x) * 2.0f) + 3.0f;
    _9.x *= _79;
    _9.x = (_9.x * _61.x) + _61.y;
    _152.x = (-_16_m10) + 1.0f;
    _9.x = (_16_m10 * _9.x) + _152.x;
    _61 = vs_TEXCOORD0 * _16_m6.xx;
    _61 = floor(_61);
    _61 += 0.5f.xx;
    _61 /= _16_m6.xx;
    _187 = _GlowMask.Sample(sampler_GlowMask, _61).x;
    _152.x = log2(_187);
    float2 _208 = _152.xx * float2(_16_m4, _16_m5);
    _152 = float3(_208.x, _208.y, _152.z);
    float2 _213 = exp2(_152.xy);
    _152 = float3(_213.x, _213.y, _152.z);
    _152.x = _9.x * _152.x;
    _222.x = (_152.y * _16_m8) + 0.5f;
    _152.y = floor(_222.x);
    _152.x = (_152.x * _16_m8) + 0.5f;
    _152.x = floor(_152.x);
    float2 _251 = _152.xy / _16_m8.xx;
    _152 = float3(_251.x, _251.y, _152.z);
    _152.x *= _16_m3;
    _261 = (-_16_m1.xyz) + _16_m2.xyz;
    _222 = (_152.yyy * _261) + _16_m1.xyz;
    _152 = _152.xxx * _222;
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9 = _152 * _9.xxx;
    _297 = float4(_9.x, _9.y, _9.z, _297.w);
    _297.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._297 = _297;
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



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _145;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _145 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _43;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _43 = _9 + _20_m1[3];
    float3 _58 = (_20_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    vs_TEXCOORD1 = dot(_9.xyz, float3(0.37000000476837158203125f, 0.20999999344348907470703125f, 0.2899999916553497314453125f));
    _9 = _43.yyyy * _20_m2[1];
    _9 = (_20_m2[0] * _43.xxxx) + _9;
    _9 = (_20_m2[2] * _43.zzzz) + _9;
    _9 = (_20_m2[3] * _43.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _20_m3.z) + _20_m3.w;
    vs_TEXCOORD0 = _145;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _GlowColor;
float4 _HotColor;
float _Intensity;
float _Falloff;
float _HotFalloff;
float _PixelGrid;
float _FrameRate;
float _Steps;
float _PulseSpeed;
float _PulseAmount;
#define _16_m0 _Time
#define _16_m1 _GlowColor
#define _16_m2 _HotColor
#define _16_m3 _Intensity
#define _16_m4 _Falloff
#define _16_m5 _HotFalloff
#define _16_m6 _PixelGrid
#define _16_m7 _FrameRate
#define _16_m8 _Steps
#define _16_m9 _PulseSpeed
#define _16_m10 _PulseAmount


Texture2D<float4> _GlowMask;
SamplerState sampler_GlowMask;

static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _297;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _297 : SV_Target0;
};

static float3 _9;
static float2 _54;
static float2 _61;
static float _79;
static float2 _98;
static float3 _152;
static float _187;
static float3 _222;
static float3 _261;

void frag_inner()
{
    _9.x = vs_TEXCOORD1 + _16_m0.y;
    _9.x *= _16_m7;
    _9.x = floor(_9.x);
    _9.x /= _16_m7;
    _9.x *= _16_m9;
    _54.x = floor(_9.x);
    _54.y = 0.0f;
    _61 = _54 + float2(1.0f, 0.0f);
    _54 *= float2(123.339996337890625f, 456.209991455078125f);
    _54 = frac(_54);
    float2 _74 = _61 * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float3(_9.x, _74.x, _74.y);
    _9 = frac(_9);
    _79 = _9.y + 45.31999969482421875f;
    _61 = (_9.yy * _79.xx) + _9.yz;
    _61.x = _61.y * _61.x;
    _98.x = _54.x + 45.31999969482421875f;
    _98 = (_54.xx * _98.xx) + _54;
    _61.y = _98.y * _98.x;
    _61 = frac(_61);
    _61.x = (-_61.y) + _61.x;
    _79 = _9.x * _9.x;
    _9.x = ((-_9.x) * 2.0f) + 3.0f;
    _9.x *= _79;
    _9.x = (_9.x * _61.x) + _61.y;
    _152.x = (-_16_m10) + 1.0f;
    _9.x = (_16_m10 * _9.x) + _152.x;
    _61 = vs_TEXCOORD0 * _16_m6.xx;
    _61 = floor(_61);
    _61 += 0.5f.xx;
    _61 /= _16_m6.xx;
    _187 = _GlowMask.Sample(sampler_GlowMask, _61).x;
    _152.x = log2(_187);
    float2 _208 = _152.xx * float2(_16_m4, _16_m5);
    _152 = float3(_208.x, _208.y, _152.z);
    float2 _213 = exp2(_152.xy);
    _152 = float3(_213.x, _213.y, _152.z);
    _152.x = _9.x * _152.x;
    _222.x = (_152.y * _16_m8) + 0.5f;
    _152.y = floor(_222.x);
    _152.x = (_152.x * _16_m8) + 0.5f;
    _152.x = floor(_152.x);
    float2 _251 = _152.xy / _16_m8.xx;
    _152 = float3(_251.x, _251.y, _152.z);
    _152.x *= _16_m3;
    _261 = (-_16_m1.xyz) + _16_m2.xyz;
    _222 = (_152.yyy * _261) + _16_m1.xyz;
    _152 = _152.xxx * _222;
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9 = _152 * _9.xxx;
    _297 = float4(_9.x, _9.y, _9.z, _297.w);
    _297.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._297 = _297;
    return stage_output;
}

#endif
#else
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
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _107;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _107 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _43;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m0[1];
    _9 = (_20_m0[0] * _11.xxxx) + _9;
    _9 = (_20_m0[2] * _11.zzzz) + _9;
    _43 = _9 + _20_m0[3];
    float3 _58 = (_20_m0[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    vs_TEXCOORD1 = dot(_9.xyz, float3(0.37000000476837158203125f, 0.20999999344348907470703125f, 0.2899999916553497314453125f));
    _9 = _43.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _43.xxxx) + _9;
    _9 = (_20_m1[2] * _43.zzzz) + _9;
    gl_Position = (_20_m1[3] * _43.wwww) + _9;
    vs_TEXCOORD0 = _107;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _107 = stage_input._107;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _GlowColor;
float4 _HotColor;
float _Intensity;
float _Falloff;
float _HotFalloff;
float _PixelGrid;
float _FrameRate;
float _Steps;
float _PulseSpeed;
float _PulseAmount;
#define _16_m0 _Time
#define _16_m1 _GlowColor
#define _16_m2 _HotColor
#define _16_m3 _Intensity
#define _16_m4 _Falloff
#define _16_m5 _HotFalloff
#define _16_m6 _PixelGrid
#define _16_m7 _FrameRate
#define _16_m8 _Steps
#define _16_m9 _PulseSpeed
#define _16_m10 _PulseAmount


Texture2D<float4> _GlowMask;
SamplerState sampler_GlowMask;

static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _274;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _274 : SV_Target0;
};

static float3 _9;
static float2 _54;
static float2 _61;
static float _79;
static float2 _98;
static float2 _152;
static float _187;
static float3 _217;
static float3 _253;

void frag_inner()
{
    _9.x = vs_TEXCOORD1 + _16_m0.y;
    _9.x *= _16_m7;
    _9.x = floor(_9.x);
    _9.x /= _16_m7;
    _9.x *= _16_m9;
    _54.x = floor(_9.x);
    _54.y = 0.0f;
    _61 = _54 + float2(1.0f, 0.0f);
    _54 *= float2(123.339996337890625f, 456.209991455078125f);
    _54 = frac(_54);
    float2 _74 = _61 * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float3(_9.x, _74.x, _74.y);
    _9 = frac(_9);
    _79 = _9.y + 45.31999969482421875f;
    _61 = (_9.yy * _79.xx) + _9.yz;
    _61.x = _61.y * _61.x;
    _98.x = _54.x + 45.31999969482421875f;
    _98 = (_54.xx * _98.xx) + _54;
    _61.y = _98.y * _98.x;
    _61 = frac(_61);
    _61.x = (-_61.y) + _61.x;
    _79 = _9.x * _9.x;
    _9.x = ((-_9.x) * 2.0f) + 3.0f;
    _9.x *= _79;
    _9.x = (_9.x * _61.x) + _61.y;
    _152.x = (-_16_m10) + 1.0f;
    _9.x = (_16_m10 * _9.x) + _152.x;
    _61 = vs_TEXCOORD0 * _16_m6.xx;
    _61 = floor(_61);
    _61 += 0.5f.xx;
    _61 /= _16_m6.xx;
    _187 = _GlowMask.Sample(sampler_GlowMask, _61).x;
    _152.x = log2(_187);
    _152 = _152.xx * float2(_16_m4, _16_m5);
    _152 = exp2(_152);
    _152.x = _9.x * _152.x;
    _217.x = (_152.y * _16_m8) + 0.5f;
    _152.y = floor(_217.x);
    _152.x = (_152.x * _16_m8) + 0.5f;
    _152.x = floor(_152.x);
    _152 /= _16_m8.xx;
    _152.x *= _16_m3;
    _253 = (-_16_m1.xyz) + _16_m2.xyz;
    _217 = (_152.yyy * _253) + _16_m1.xyz;
    float3 _278 = _152.xxx * _217;
    _274 = float4(_278.x, _278.y, _278.z, _274.w);
    _274.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._274 = _274;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}