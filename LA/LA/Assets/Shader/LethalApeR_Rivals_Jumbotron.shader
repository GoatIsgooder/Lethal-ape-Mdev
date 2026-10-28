// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "LethalApeR/Rivals/Jumbotron" {
Properties {

_MainTex ("Screen Texture (orbit camera feed)", 2D) = "black" { }

_Boost ("Emissive Boost", Range(0.5, 4)) = 1.399999976158142

_BorderColor ("Border Color", Color) = (1,0.78,0.25,1)

_BorderWidth ("Border Width (UV)", Range(0, 0.1)) = 0.019999999552965164

_Aspect ("Screen Aspect (w over h)", Range(0.5, 4)) = 1.7777999639511108

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
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _20_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float2 _125;

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
    vs_TEXCOORD1 = exp2(-_9.x);
    float2 _135 = (_125 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD0 = float4(_135.x, _135.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
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
float4 _Time;
float4 unity_FogColor;
float _Boost;
float4 _BorderColor;
float _BorderWidth;
float _Aspect;
#define _37_m0 _Time
#define _37_m1 unity_FogColor
#define _37_m2 _Boost
#define _37_m3 _BorderColor
#define _37_m4 _BorderWidth
#define _37_m5 _Aspect


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _174;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _174 : SV_Target0;
};

static float3 _9;
static float3 _29;
static float _58;
static float3 _118;
static float3 _128;
static float _159;

void frag_inner()
{
    float2 _19 = (-vs_TEXCOORD0.zw) + 1.0f.xx;
    _9 = float3(_19.x, _19.y, _9.z);
    float2 _26 = min(_9.xy, vs_TEXCOORD0.zw);
    _9 = float3(_26.x, _26.y, _9.z);
    _29.x = _9.x * _37_m5;
    _29.x = min(_9.y, _29.x);
    _9.x = max(_37_m4, 9.9999997473787516355514526367188e-05f);
    _58 = ((-_9.x) * 0.699999988079071044921875f) + _29.x;
    _9.x *= 0.300000011920928955078125f;
    _9.x = 1.0f / _9.x;
    _9.x *= _58;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _58 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_58) * _9.x) + 1.0f;
    _58 = _37_m0.y + _37_m0.y;
    _58 = sin(_58);
    _58 = (_58 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
    _118 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _128 = _118 * _37_m2.xxx;
    _29 = (_37_m3.xyz * _58.xxx) + (-_128);
    _29 = (_9.xxx * _29) + _128;
    _9 = _29 + (-_37_m1.xyz);
    _159 = vs_TEXCOORD1;
    _159 = clamp(_159, 0.0f, 1.0f);
    _9 = (_159.xxx * _9) + _37_m1.xyz;
    _174 = float4(_9.x, _9.y, _9.z, _174.w);
    _174.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._174 = _174;
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
float4 _MainTex_ST;
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
#define _20_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float2 _131;

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
    vs_TEXCOORD1 = exp2(_9.x);
    float2 _141 = (_131 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD0 = float4(_141.x, _141.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
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
float4 _Time;
float4 unity_FogColor;
float _Boost;
float4 _BorderColor;
float _BorderWidth;
float _Aspect;
#define _37_m0 _Time
#define _37_m1 unity_FogColor
#define _37_m2 _Boost
#define _37_m3 _BorderColor
#define _37_m4 _BorderWidth
#define _37_m5 _Aspect


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _174;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _174 : SV_Target0;
};

static float3 _9;
static float3 _29;
static float _58;
static float3 _118;
static float3 _128;
static float _159;

void frag_inner()
{
    float2 _19 = (-vs_TEXCOORD0.zw) + 1.0f.xx;
    _9 = float3(_19.x, _19.y, _9.z);
    float2 _26 = min(_9.xy, vs_TEXCOORD0.zw);
    _9 = float3(_26.x, _26.y, _9.z);
    _29.x = _9.x * _37_m5;
    _29.x = min(_9.y, _29.x);
    _9.x = max(_37_m4, 9.9999997473787516355514526367188e-05f);
    _58 = ((-_9.x) * 0.699999988079071044921875f) + _29.x;
    _9.x *= 0.300000011920928955078125f;
    _9.x = 1.0f / _9.x;
    _9.x *= _58;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _58 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_58) * _9.x) + 1.0f;
    _58 = _37_m0.y + _37_m0.y;
    _58 = sin(_58);
    _58 = (_58 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
    _118 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _128 = _118 * _37_m2.xxx;
    _29 = (_37_m3.xyz * _58.xxx) + (-_128);
    _29 = (_9.xxx * _29) + _128;
    _9 = _29 + (-_37_m1.xyz);
    _159 = vs_TEXCOORD1;
    _159 = clamp(_159, 0.0f, 1.0f);
    _9 = (_159.xxx * _9) + _37_m1.xyz;
    _174 = float4(_9.x, _9.y, _9.z, _174.w);
    _174.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._174 = _174;
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
float4 _MainTex_ST;
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
#define _20_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float2 _124;

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
    vs_TEXCOORD1 = (_9.x * _20_m3.z) + _20_m3.w;
    float2 _134 = (_124 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD0 = float4(_134.x, _134.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
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
float4 _Time;
float4 unity_FogColor;
float _Boost;
float4 _BorderColor;
float _BorderWidth;
float _Aspect;
#define _37_m0 _Time
#define _37_m1 unity_FogColor
#define _37_m2 _Boost
#define _37_m3 _BorderColor
#define _37_m4 _BorderWidth
#define _37_m5 _Aspect


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _174;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _174 : SV_Target0;
};

static float3 _9;
static float3 _29;
static float _58;
static float3 _118;
static float3 _128;
static float _159;

void frag_inner()
{
    float2 _19 = (-vs_TEXCOORD0.zw) + 1.0f.xx;
    _9 = float3(_19.x, _19.y, _9.z);
    float2 _26 = min(_9.xy, vs_TEXCOORD0.zw);
    _9 = float3(_26.x, _26.y, _9.z);
    _29.x = _9.x * _37_m5;
    _29.x = min(_9.y, _29.x);
    _9.x = max(_37_m4, 9.9999997473787516355514526367188e-05f);
    _58 = ((-_9.x) * 0.699999988079071044921875f) + _29.x;
    _9.x *= 0.300000011920928955078125f;
    _9.x = 1.0f / _9.x;
    _9.x *= _58;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _58 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_58) * _9.x) + 1.0f;
    _58 = _37_m0.y + _37_m0.y;
    _58 = sin(_58);
    _58 = (_58 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
    _118 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _128 = _118 * _37_m2.xxx;
    _29 = (_37_m3.xyz * _58.xxx) + (-_128);
    _29 = (_9.xxx * _29) + _128;
    _9 = _29 + (-_37_m1.xyz);
    _159 = vs_TEXCOORD1;
    _159 = clamp(_159, 0.0f, 1.0f);
    _9 = (_159.xxx * _9) + _37_m1.xyz;
    _174 = float4(_9.x, _9.y, _9.z, _174.w);
    _174.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._174 = _174;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _20_m0[4];
float4x4 unity_MatrixVP;
static float4 _20_m1[4];
float4 _MainTex_ST;
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
#define _20_m2 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float2 _85;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _85 : TEXCOORD0;
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
    _9 = _11.yyyy * _20_m0[1];
    _9 = (_20_m0[0] * _11.xxxx) + _9;
    _9 = (_20_m0[2] * _11.zzzz) + _9;
    _9 += _20_m0[3];
    _48 = _9.yyyy * _20_m1[1];
    _48 = (_20_m1[0] * _9.xxxx) + _48;
    _48 = (_20_m1[2] * _9.zzzz) + _48;
    gl_Position = (_20_m1[3] * _9.wwww) + _48;
    float2 _94 = (_85 * _20_m2.xy) + _20_m2.zw;
    vs_TEXCOORD0 = float4(_94.x, _94.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _85.x, _85.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _85 = stage_input._85;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float _Boost;
float4 _BorderColor;
float _BorderWidth;
float _Aspect;
#define _33_m0 _Time
#define _33_m1 _Boost
#define _33_m2 _BorderColor
#define _33_m3 _BorderWidth
#define _33_m4 _Aspect


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float4 _143;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _143 : SV_Target0;
};

static float2 _9;
static float3 _25;
static float _54;
static float3 _114;
static float3 _124;

void frag_inner()
{
    _9 = (-vs_TEXCOORD0.zw) + 1.0f.xx;
    _9 = min(_9, vs_TEXCOORD0.zw);
    _25.x = _9.x * _33_m4;
    _25.x = min(_9.y, _25.x);
    _9.x = max(_33_m3, 9.9999997473787516355514526367188e-05f);
    _54 = ((-_9.x) * 0.699999988079071044921875f) + _25.x;
    _9.x *= 0.300000011920928955078125f;
    _9.x = 1.0f / _9.x;
    _9.x *= _54;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _54 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_54) * _9.x) + 1.0f;
    _54 = _33_m0.y + _33_m0.y;
    _54 = sin(_54);
    _54 = (_54 * 0.1500000059604644775390625f) + 0.85000002384185791015625f;
    _114 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _124 = _114 * _33_m1.xxx;
    _25 = (_33_m2.xyz * _54.xxx) + (-_124);
    float3 _149 = (_9.xxx * _25) + _124;
    _143 = float4(_149.x, _149.y, _149.z, _143.w);
    _143.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._143 = _143;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Unlit/Texture"
}