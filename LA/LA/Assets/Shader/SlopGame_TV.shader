// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SlopGame/TV" {
Properties {

[Header(Screen Content)] _MainTex ("Screen Texture", 2D) = "white" { }

_ScrollX ("Scroll Speed X", Range(-2, 2)) = 0.0

_ScrollY ("Scroll Speed Y", Range(-2, 2)) = -0.25

_OffsetX ("Offset X", Range(-1, 1)) = 0.0

_OffsetY ("Offset Y", Range(-1, 1)) = 0.0

_Tint ("Screen Tint", Color) = (1,1,1,1)

_Brightness ("Brightness", Range(0, 4)) = 1.2000000476837158

_Contrast ("Contrast", Range(0, 4)) = 1.100000023841858

[Header(Emission)] _EmissionColor ("Emission Color", Color) = (1,1,1,1)

_EmissionStrength ("Emission Strength", Range(0, 10)) = 2.5

[Header(Scanlines)] [Toggle(SCANLINES_ON)] _ScanlinesEnabled ("Enable Scanlines", Float) = 1.0

_ScanlineDensity ("Scanline Density", Range(10, 600)) = 240.0

_ScanlineDark ("Scanline Darkness", Range(0, 1)) = 0.20000000298023224

[Header(Flicker)] [Toggle(FLICKER_ON)] _FlickerEnabled ("Enable Flicker", Float) = 0.0

_FlickerSpeed ("Flicker Speed", Range(1, 60)) = 8.0

_FlickerAmount ("Flicker Amount", Range(0, 0.3)) = 0.05000000074505806

[Header(Static Noise)] [Toggle(STATIC_ON)] _StaticEnabled ("Enable Static", Float) = 0.0

_StaticAmount ("Static Amount", Range(0, 1)) = 0.10000000149011612

_StaticSpeed ("Static Speed", Range(1, 30)) = 10.0

_StaticResolution ("Static Resolution", Range(10, 120)) = 60.0

}
SubShader {
 LOD 100
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  LOD 100
  Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m2[4];
float4x4 unity_MatrixVP;
static float4 _20_m3[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float _ScrollX;
float _ScrollY;
float _OffsetX;
float _OffsetY;
void __unity_init()
{
    _20_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _Time
#define _20_m1 _ProjectionParams
#define _20_m4 unity_FogParams
#define _20_m5 _MainTex_ST
#define _20_m6 _ScrollX
#define _20_m7 _ScrollY
#define _20_m8 _OffsetX
#define _20_m9 _OffsetY



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 _125;
static float4 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _125 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m2[1];
    _9 = (_20_m2[0] * _11.xxxx) + _9;
    _9 = (_20_m2[2] * _11.zzzz) + _9;
    _9 += _20_m2[3];
    _48 = _9.yyyy * _20_m3[1];
    _48 = (_20_m3[0] * _9.xxxx) + _48;
    _48 = (_20_m3[2] * _9.zzzz) + _48;
    _9 = (_20_m3[3] * _9.wwww) + _48;
    gl_Position = _9;
    _9.x = _9.z / _20_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m4.y;
    vs_TEXCOORD1 = exp2(-_9.x);
    float2 _135 = (_125 * _20_m5.xy) + _20_m5.zw;
    _9 = float4(_135.x, _135.y, _9.z, _9.w);
    float2 _151 = (float2(_20_m6, _20_m7) * _20_m0.yy) + _9.xy;
    _9 = float4(_151.x, _151.y, _9.z, _9.w);
    float2 _164 = _9.xy + float2(_20_m8, _20_m9);
    vs_TEXCOORD0 = float4(_164.x, _164.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _125.x, _125.y);
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
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _Tint;
float _Brightness;
float _Contrast;
float4 _EmissionColor;
float _EmissionStrength;
#define _27_m0 unity_FogColor
#define _27_m1 _Tint
#define _27_m2 _Brightness
#define _27_m3 _Contrast
#define _27_m4 _EmissionColor
#define _27_m5 _EmissionStrength


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _103;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _103 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _68;
static float _88;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = (_9 * _27_m1.xyz) + (-0.5f).xxx;
    _23 = (_23 * float3(float3(_27_m3, _27_m3, _27_m3))) + 0.5f.xxx;
    _23 = clamp(_23, 0.0f.xxx, 1.0f.xxx);
    _23 *= _27_m2.xxx;
    _68 = _23 * _27_m4.xyz;
    _23 = (_68 * _27_m5.xxx) + (-_27_m0.xyz);
    _88 = vs_TEXCOORD1;
    _88 = clamp(_88, 0.0f, 1.0f);
    _23 = (_88.xxx * _23) + _27_m0.xyz;
    _103 = float4(_23.x, _23.y, _23.z, _103.w);
    _103.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._103 = _103;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m2[4];
float4x4 unity_MatrixVP;
static float4 _20_m3[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float _ScrollX;
float _ScrollY;
float _OffsetX;
float _OffsetY;
void __unity_init()
{
    _20_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _Time
#define _20_m1 _ProjectionParams
#define _20_m4 unity_FogParams
#define _20_m5 _MainTex_ST
#define _20_m6 _ScrollX
#define _20_m7 _ScrollY
#define _20_m8 _OffsetX
#define _20_m9 _OffsetY



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 _131;
static float4 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _131 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m2[1];
    _9 = (_20_m2[0] * _11.xxxx) + _9;
    _9 = (_20_m2[2] * _11.zzzz) + _9;
    _9 += _20_m2[3];
    _48 = _9.yyyy * _20_m3[1];
    _48 = (_20_m3[0] * _9.xxxx) + _48;
    _48 = (_20_m3[2] * _9.zzzz) + _48;
    _9 = (_20_m3[3] * _9.wwww) + _48;
    gl_Position = _9;
    _9.x = _9.z / _20_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD1 = exp2(_9.x);
    float2 _141 = (_131 * _20_m5.xy) + _20_m5.zw;
    _9 = float4(_141.x, _141.y, _9.z, _9.w);
    float2 _157 = (float2(_20_m6, _20_m7) * _20_m0.yy) + _9.xy;
    _9 = float4(_157.x, _157.y, _9.z, _9.w);
    float2 _170 = _9.xy + float2(_20_m8, _20_m9);
    vs_TEXCOORD0 = float4(_170.x, _170.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _131.x, _131.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _131 = stage_input._131;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _Tint;
float _Brightness;
float _Contrast;
float4 _EmissionColor;
float _EmissionStrength;
#define _27_m0 unity_FogColor
#define _27_m1 _Tint
#define _27_m2 _Brightness
#define _27_m3 _Contrast
#define _27_m4 _EmissionColor
#define _27_m5 _EmissionStrength


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _103;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _103 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _68;
static float _88;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = (_9 * _27_m1.xyz) + (-0.5f).xxx;
    _23 = (_23 * float3(float3(_27_m3, _27_m3, _27_m3))) + 0.5f.xxx;
    _23 = clamp(_23, 0.0f.xxx, 1.0f.xxx);
    _23 *= _27_m2.xxx;
    _68 = _23 * _27_m4.xyz;
    _23 = (_68 * _27_m5.xxx) + (-_27_m0.xyz);
    _88 = vs_TEXCOORD1;
    _88 = clamp(_88, 0.0f, 1.0f);
    _23 = (_88.xxx * _23) + _27_m0.xyz;
    _103 = float4(_23.x, _23.y, _23.z, _103.w);
    _103.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._103 = _103;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m2[4];
float4x4 unity_MatrixVP;
static float4 _20_m3[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float _ScrollX;
float _ScrollY;
float _OffsetX;
float _OffsetY;
void __unity_init()
{
    _20_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _Time
#define _20_m1 _ProjectionParams
#define _20_m4 unity_FogParams
#define _20_m5 _MainTex_ST
#define _20_m6 _ScrollX
#define _20_m7 _ScrollY
#define _20_m8 _OffsetX
#define _20_m9 _OffsetY



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 _124;
static float4 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _124 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m2[1];
    _9 = (_20_m2[0] * _11.xxxx) + _9;
    _9 = (_20_m2[2] * _11.zzzz) + _9;
    _9 += _20_m2[3];
    _48 = _9.yyyy * _20_m3[1];
    _48 = (_20_m3[0] * _9.xxxx) + _48;
    _48 = (_20_m3[2] * _9.zzzz) + _48;
    _9 = (_20_m3[3] * _9.wwww) + _48;
    gl_Position = _9;
    _9.x = _9.z / _20_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD1 = (_9.x * _20_m4.z) + _20_m4.w;
    float2 _134 = (_124 * _20_m5.xy) + _20_m5.zw;
    _9 = float4(_134.x, _134.y, _9.z, _9.w);
    float2 _150 = (float2(_20_m6, _20_m7) * _20_m0.yy) + _9.xy;
    _9 = float4(_150.x, _150.y, _9.z, _9.w);
    float2 _163 = _9.xy + float2(_20_m8, _20_m9);
    vs_TEXCOORD0 = float4(_163.x, _163.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _124.x, _124.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _124 = stage_input._124;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _Tint;
float _Brightness;
float _Contrast;
float4 _EmissionColor;
float _EmissionStrength;
#define _27_m0 unity_FogColor
#define _27_m1 _Tint
#define _27_m2 _Brightness
#define _27_m3 _Contrast
#define _27_m4 _EmissionColor
#define _27_m5 _EmissionStrength


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _103;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _103 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _68;
static float _88;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = (_9 * _27_m1.xyz) + (-0.5f).xxx;
    _23 = (_23 * float3(float3(_27_m3, _27_m3, _27_m3))) + 0.5f.xxx;
    _23 = clamp(_23, 0.0f.xxx, 1.0f.xxx);
    _23 *= _27_m2.xxx;
    _68 = _23 * _27_m4.xyz;
    _23 = (_68 * _27_m5.xxx) + (-_27_m0.xyz);
    _88 = vs_TEXCOORD1;
    _88 = clamp(_88, 0.0f, 1.0f);
    _23 = (_88.xxx * _23) + _27_m0.xyz;
    _103 = float4(_23.x, _23.y, _23.z, _103.w);
    _103.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._103 = _103;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 _MainTex_ST;
float _ScrollX;
float _ScrollY;
float _OffsetX;
float _OffsetY;
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
#define _20_m0 _Time
#define _20_m3 _MainTex_ST
#define _20_m4 _ScrollX
#define _20_m5 _ScrollY
#define _20_m6 _OffsetX
#define _20_m7 _OffsetY



static float4 gl_Position;
static float4 _11;
static float2 _84;
static float4 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _84 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
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
    gl_Position = (_20_m2[3] * _9.wwww) + _48;
    float2 _93 = (_84 * _20_m3.xy) + _20_m3.zw;
    _9 = float4(_93.x, _93.y, _9.z, _9.w);
    float2 _110 = (float2(_20_m4, _20_m5) * _20_m0.yy) + _9.xy;
    _9 = float4(_110.x, _110.y, _9.z, _9.w);
    float2 _123 = _9.xy + float2(_20_m6, _20_m7);
    vs_TEXCOORD0 = float4(_123.x, _123.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _84.x, _84.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _84 = stage_input._84;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Brightness;
float _Contrast;
float4 _EmissionColor;
float _EmissionStrength;
#define _27_m0 _Tint
#define _27_m1 _Brightness
#define _27_m2 _Contrast
#define _27_m3 _EmissionColor
#define _27_m4 _EmissionStrength


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float4 _76;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _76 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _68;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _23 = (_9 * _27_m0.xyz) + (-0.5f).xxx;
    _23 = (_23 * float3(float3(_27_m2, _27_m2, _27_m2))) + 0.5f.xxx;
    _23 = clamp(_23, 0.0f.xxx, 1.0f.xxx);
    _23 *= _27_m1.xxx;
    _68 = _23 * _27_m3.xyz;
    float3 _82 = _68 * _27_m4.xxx;
    _76 = float4(_82.x, _82.y, _82.z, _76.w);
    _76.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._76 = _76;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Unlit/Texture"
}