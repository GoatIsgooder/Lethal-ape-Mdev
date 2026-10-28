// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/ChainsawSmoke" {
Properties {

_MainTex ("Base", 2D) = "white" { }

_NoiseMap ("Noise", 2D) = "gray" { }

_NoiseScale ("Noise Scale", Float) = 1.399999976158142

_ErosionSmooth ("Erosion Smoothness", Range(0.01, 1)) = 0.3499999940395355

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
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float _NoiseScale;
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
#define _20_m4 _NoiseScale



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float4 _122;
static float4 _123;
static float3 vs_TEXCOORD0;
static float4 _128;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _123 : COLOR;
    float4 _128 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _122 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float2 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
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
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    _122 = _123;
    vs_TEXCOORD0 = _128.xyz;
    _9.x = _128.z * 0.300000011920928955078125f;
    vs_TEXCOORD1 = (_128.xy * _20_m4.xx) + _9.xx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _123 = stage_input._123;
    _128 = stage_input._128;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._122 = _122;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float _ErosionSmooth;
#define _30_m0 unity_FogColor
#define _30_m1 _ErosionSmooth


Texture2D<float4> _NoiseMap;
SamplerState sampler_NoiseMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float4 _126;
static float4 _138;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _126 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float2 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _138 : SV_Target0;
};

static float3 _9;
static float _26;
static float _37;
static float _58;
static float4 _71;
static float _77;
static float _145;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.z;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _26 = _30_m1 + 1.0f;
    _37 = (_9.x * _26) + (-_30_m1);
    _9.x = (_9.x * _26) + (-_37);
    _9.x = 1.0f / _9.x;
    _58 = _NoiseMap.Sample(sampler_NoiseMap, vs_TEXCOORD1).x;
    _71 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy);
    _77 = _71.w * 0.449999988079071044921875f;
    _77 = (_58 * 0.75f) + _77;
    _26 = (-_37) + _77;
    _9.x *= _26;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _26 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _26;
    _77 = _9.x * _71.w;
    _9 = (_71.xyz * _126.xyz) + (-_30_m0.xyz);
    _138.w = _77 * _126.w;
    _145 = vs_TEXCOORD2;
    _145 = clamp(_145, 0.0f, 1.0f);
    _9 = (_145.xxx * _9) + _30_m0.xyz;
    _138 = float4(_9.x, _9.y, _9.z, _138.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _126 = stage_input._126;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._138 = _138;
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
float _NoiseScale;
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
#define _20_m4 _NoiseScale



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float4 _128;
static float4 _129;
static float3 vs_TEXCOORD0;
static float4 _134;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _129 : COLOR;
    float4 _134 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _128 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float2 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
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
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    _128 = _129;
    vs_TEXCOORD0 = _134.xyz;
    _9.x = _134.z * 0.300000011920928955078125f;
    vs_TEXCOORD1 = (_134.xy * _20_m4.xx) + _9.xx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _129 = stage_input._129;
    _134 = stage_input._134;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._128 = _128;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float _ErosionSmooth;
#define _30_m0 unity_FogColor
#define _30_m1 _ErosionSmooth


Texture2D<float4> _NoiseMap;
SamplerState sampler_NoiseMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float4 _126;
static float4 _138;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _126 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float2 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _138 : SV_Target0;
};

static float3 _9;
static float _26;
static float _37;
static float _58;
static float4 _71;
static float _77;
static float _145;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.z;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _26 = _30_m1 + 1.0f;
    _37 = (_9.x * _26) + (-_30_m1);
    _9.x = (_9.x * _26) + (-_37);
    _9.x = 1.0f / _9.x;
    _58 = _NoiseMap.Sample(sampler_NoiseMap, vs_TEXCOORD1).x;
    _71 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy);
    _77 = _71.w * 0.449999988079071044921875f;
    _77 = (_58 * 0.75f) + _77;
    _26 = (-_37) + _77;
    _9.x *= _26;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _26 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _26;
    _77 = _9.x * _71.w;
    _9 = (_71.xyz * _126.xyz) + (-_30_m0.xyz);
    _138.w = _77 * _126.w;
    _145 = vs_TEXCOORD2;
    _145 = clamp(_145, 0.0f, 1.0f);
    _9 = (_145.xxx * _9) + _30_m0.xyz;
    _138 = float4(_9.x, _9.y, _9.z, _138.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _126 = stage_input._126;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._138 = _138;
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
float _NoiseScale;
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
#define _20_m4 _NoiseScale



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float4 _121;
static float4 _122;
static float3 vs_TEXCOORD0;
static float4 _127;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _122 : COLOR;
    float4 _127 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _121 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float2 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
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
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _20_m3.z) + _20_m3.w;
    _121 = _122;
    vs_TEXCOORD0 = _127.xyz;
    _9.x = _127.z * 0.300000011920928955078125f;
    vs_TEXCOORD1 = (_127.xy * _20_m4.xx) + _9.xx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _122 = stage_input._122;
    _127 = stage_input._127;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._121 = _121;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float _ErosionSmooth;
#define _30_m0 unity_FogColor
#define _30_m1 _ErosionSmooth


Texture2D<float4> _NoiseMap;
SamplerState sampler_NoiseMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float4 _126;
static float4 _138;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _126 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float2 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _138 : SV_Target0;
};

static float3 _9;
static float _26;
static float _37;
static float _58;
static float4 _71;
static float _77;
static float _145;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.z;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _26 = _30_m1 + 1.0f;
    _37 = (_9.x * _26) + (-_30_m1);
    _9.x = (_9.x * _26) + (-_37);
    _9.x = 1.0f / _9.x;
    _58 = _NoiseMap.Sample(sampler_NoiseMap, vs_TEXCOORD1).x;
    _71 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy);
    _77 = _71.w * 0.449999988079071044921875f;
    _77 = (_58 * 0.75f) + _77;
    _26 = (-_37) + _77;
    _9.x *= _26;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _26 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _26;
    _77 = _9.x * _71.w;
    _9 = (_71.xyz * _126.xyz) + (-_30_m0.xyz);
    _138.w = _77 * _126.w;
    _145 = vs_TEXCOORD2;
    _145 = clamp(_145, 0.0f, 1.0f);
    _9 = (_145.xxx * _9) + _30_m0.xyz;
    _138 = float4(_9.x, _9.y, _9.z, _138.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _126 = stage_input._126;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._138 = _138;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _20_m0[4];
float4x4 unity_MatrixVP;
static float4 _20_m1[4];
float _NoiseScale;
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
#define _20_m2 _NoiseScale



static float4 gl_Position;
static float4 _11;
static float4 _82;
static float4 _83;
static float3 vs_TEXCOORD0;
static float4 _88;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _83 : COLOR;
    float4 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _82 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float2 vs_TEXCOORD1 : TEXCOORD2;
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
    _82 = _83;
    vs_TEXCOORD0 = _88.xyz;
    _9.x = _88.z * 0.300000011920928955078125f;
    vs_TEXCOORD1 = (_88.xy * _20_m2.xx) + _9.xx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _83 = stage_input._83;
    _88 = stage_input._88;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._82 = _82;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _ErosionSmooth;
#define _24_m0 _ErosionSmooth


Texture2D<float4> _NoiseMap;
SamplerState sampler_NoiseMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float4 _104;
static float4 _108;

struct SPIRV_Cross_Input
{
    float4 _108 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float2 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _104 : SV_Target0;
};

static float _8;
static float _21;
static float _31;
static float _47;
static float4 _62;
static float _68;

void frag_inner()
{
    _8 = vs_TEXCOORD0.z;
    _8 = clamp(_8, 0.0f, 1.0f);
    _21 = _24_m0 + 1.0f;
    _31 = (_8 * _21) + (-_24_m0);
    _8 = (_8 * _21) + (-_31);
    _8 = 1.0f / _8;
    _47 = _NoiseMap.Sample(sampler_NoiseMap, vs_TEXCOORD1).x;
    _62 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy);
    _68 = _62.w * 0.449999988079071044921875f;
    _68 = (_47 * 0.75f) + _68;
    _21 = (-_31) + _68;
    _8 *= _21;
    _8 = clamp(_8, 0.0f, 1.0f);
    _21 = (_8 * (-2.0f)) + 3.0f;
    _8 *= _8;
    _8 *= _21;
    _68 = _8 * _62.w;
    float3 _111 = _62.xyz * _108.xyz;
    _104 = float4(_111.x, _111.y, _111.z, _104.w);
    _104.w = _68 * _108.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _108 = stage_input._108;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._104 = _104;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}