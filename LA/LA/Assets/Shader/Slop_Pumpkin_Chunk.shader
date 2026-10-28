// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Pumpkin/Chunk" {
Properties {

_RindColor ("Rind", Color) = (1,0.45,0.05,1)

_PulpColor ("Pulp", Color) = (1,0.82,0.35,1)

_ShadowTint ("Shadow Tint", Color) = (0.55,0.42,0.45,1)

_LightDir ("Light Direction", Vector) = (0.35,0.85,0.25,0)

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
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _RindColor;
float4 _PulpColor;
float4 _ShadowTint;
float4 _LightDir;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _RindColor
#define _21_m6 _PulpColor
#define _21_m7 _ShadowTint
#define _21_m8 _LightDir



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD0;
static float3 _126;
static float2 _214;
static float4 _247;
static float4 _251;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _126 : NORMAL;
    float4 _247 : COLOR;
    float2 _214 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _251 : TEXCOORD0;
    float vs_TEXCOORD0 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _145;
static float3 _196;
static float3 _223;
static float3 _244;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD0 = exp2(-_9.x);
    _9.x = dot(_126, _21_m2[0].xyz);
    _9.y = dot(_126, _21_m2[1].xyz);
    _9.z = dot(_126, _21_m2[2].xyz);
    _145 = dot(_9.xyz, _9.xyz);
    _145 = rsqrt(_145);
    float3 _157 = _145.xxx * _9.xyz;
    _9 = float4(_157.x, _157.y, _157.z, _9.w);
    _145 = dot(_21_m8.xyz, _21_m8.xyz);
    _145 = rsqrt(_145);
    float3 _175 = _145.xxx * _21_m8.xyz;
    _49 = float4(_175.x, _175.y, _175.z, _49.w);
    _9.x = dot(_9.xyz, _49.xyz);
    _9.x = (_9.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _196 = (-_21_m7.xyz) + 1.0f.xxx;
    _196 = (_9.xxx * _196) + _21_m7.xyz;
    _9.x = _214.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _223 = (-_21_m5.xyz) + _21_m6.xyz;
    float3 _241 = (_9.xxx * _223) + _21_m5.xyz;
    _9 = float4(_241.x, _241.y, _241.z, _9.w);
    _244 = _9.xyz * _247.xyz;
    float3 _254 = _196 * _244;
    _251 = float4(_254.x, _254.y, _254.z, _251.w);
    _251.w = 1.0f;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _126 = stage_input._126;
    _214 = stage_input._214;
    _247 = stage_input._247;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._251 = _251;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
#define _31_m0 unity_FogColor



static float vs_TEXCOORD0;
static float4 _26;
static float4 _49;

struct SPIRV_Cross_Input
{
    float4 _26 : TEXCOORD0;
    float vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _49 : SV_Target0;
};

static float3 _9;
static float3 _23;

void frag_inner()
{
    _9.x = vs_TEXCOORD0;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _23 = _26.xyz + (-_31_m0.xyz);
    _9 = (_9.xxx * _23) + _31_m0.xyz;
    _49 = float4(_9.x, _9.y, _9.z, _49.w);
    _49.w = _26.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _26 = stage_input._26;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._49 = _49;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _RindColor;
float4 _PulpColor;
float4 _ShadowTint;
float4 _LightDir;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _RindColor
#define _21_m6 _PulpColor
#define _21_m7 _ShadowTint
#define _21_m8 _LightDir



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD0;
static float3 _132;
static float2 _220;
static float4 _253;
static float4 _257;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _132 : NORMAL;
    float4 _253 : COLOR;
    float2 _220 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _257 : TEXCOORD0;
    float vs_TEXCOORD0 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _151;
static float3 _202;
static float3 _229;
static float3 _250;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD0 = exp2(_9.x);
    _9.x = dot(_132, _21_m2[0].xyz);
    _9.y = dot(_132, _21_m2[1].xyz);
    _9.z = dot(_132, _21_m2[2].xyz);
    _151 = dot(_9.xyz, _9.xyz);
    _151 = rsqrt(_151);
    float3 _163 = _151.xxx * _9.xyz;
    _9 = float4(_163.x, _163.y, _163.z, _9.w);
    _151 = dot(_21_m8.xyz, _21_m8.xyz);
    _151 = rsqrt(_151);
    float3 _181 = _151.xxx * _21_m8.xyz;
    _49 = float4(_181.x, _181.y, _181.z, _49.w);
    _9.x = dot(_9.xyz, _49.xyz);
    _9.x = (_9.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _202 = (-_21_m7.xyz) + 1.0f.xxx;
    _202 = (_9.xxx * _202) + _21_m7.xyz;
    _9.x = _220.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _229 = (-_21_m5.xyz) + _21_m6.xyz;
    float3 _247 = (_9.xxx * _229) + _21_m5.xyz;
    _9 = float4(_247.x, _247.y, _247.z, _9.w);
    _250 = _9.xyz * _253.xyz;
    float3 _260 = _202 * _250;
    _257 = float4(_260.x, _260.y, _260.z, _257.w);
    _257.w = 1.0f;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _220 = stage_input._220;
    _253 = stage_input._253;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._257 = _257;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
#define _31_m0 unity_FogColor



static float vs_TEXCOORD0;
static float4 _26;
static float4 _49;

struct SPIRV_Cross_Input
{
    float4 _26 : TEXCOORD0;
    float vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _49 : SV_Target0;
};

static float3 _9;
static float3 _23;

void frag_inner()
{
    _9.x = vs_TEXCOORD0;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _23 = _26.xyz + (-_31_m0.xyz);
    _9 = (_9.xxx * _23) + _31_m0.xyz;
    _49 = float4(_9.x, _9.y, _9.z, _49.w);
    _49.w = _26.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _26 = stage_input._26;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._49 = _49;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _RindColor;
float4 _PulpColor;
float4 _ShadowTint;
float4 _LightDir;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _RindColor
#define _21_m6 _PulpColor
#define _21_m7 _ShadowTint
#define _21_m8 _LightDir



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD0;
static float3 _125;
static float2 _213;
static float4 _246;
static float4 _250;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _125 : NORMAL;
    float4 _246 : COLOR;
    float2 _213 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _250 : TEXCOORD0;
    float vs_TEXCOORD0 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _144;
static float3 _195;
static float3 _222;
static float3 _243;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD0 = (_9.x * _21_m4.z) + _21_m4.w;
    _9.x = dot(_125, _21_m2[0].xyz);
    _9.y = dot(_125, _21_m2[1].xyz);
    _9.z = dot(_125, _21_m2[2].xyz);
    _144 = dot(_9.xyz, _9.xyz);
    _144 = rsqrt(_144);
    float3 _156 = _144.xxx * _9.xyz;
    _9 = float4(_156.x, _156.y, _156.z, _9.w);
    _144 = dot(_21_m8.xyz, _21_m8.xyz);
    _144 = rsqrt(_144);
    float3 _174 = _144.xxx * _21_m8.xyz;
    _49 = float4(_174.x, _174.y, _174.z, _49.w);
    _9.x = dot(_9.xyz, _49.xyz);
    _9.x = (_9.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _195 = (-_21_m7.xyz) + 1.0f.xxx;
    _195 = (_9.xxx * _195) + _21_m7.xyz;
    _9.x = _213.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _222 = (-_21_m5.xyz) + _21_m6.xyz;
    float3 _240 = (_9.xxx * _222) + _21_m5.xyz;
    _9 = float4(_240.x, _240.y, _240.z, _9.w);
    _243 = _9.xyz * _246.xyz;
    float3 _253 = _195 * _243;
    _250 = float4(_253.x, _253.y, _253.z, _250.w);
    _250.w = 1.0f;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _125 = stage_input._125;
    _213 = stage_input._213;
    _246 = stage_input._246;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._250 = _250;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
#define _31_m0 unity_FogColor



static float vs_TEXCOORD0;
static float4 _26;
static float4 _49;

struct SPIRV_Cross_Input
{
    float4 _26 : TEXCOORD0;
    float vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _49 : SV_Target0;
};

static float3 _9;
static float3 _23;

void frag_inner()
{
    _9.x = vs_TEXCOORD0;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _23 = _26.xyz + (-_31_m0.xyz);
    _9 = (_9.xxx * _23) + _31_m0.xyz;
    _49 = float4(_9.x, _9.y, _9.z, _49.w);
    _49.w = _26.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _26 = stage_input._26;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._49 = _49;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float4 _RindColor;
float4 _PulpColor;
float4 _ShadowTint;
float4 _LightDir;
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m3 _RindColor
#define _21_m4 _PulpColor
#define _21_m5 _ShadowTint
#define _21_m6 _LightDir



static float4 gl_Position;
static float4 _11;
static float3 _85;
static float2 _178;
static float4 _210;
static float4 _214;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _85 : NORMAL;
    float4 _210 : COLOR;
    float2 _178 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _214 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _107;
static float3 _160;
static float3 _187;
static float3 _207;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _9 += _21_m0[3];
    _49 = _9.yyyy * _21_m2[1];
    _49 = (_21_m2[0] * _9.xxxx) + _49;
    _49 = (_21_m2[2] * _9.zzzz) + _49;
    gl_Position = (_21_m2[3] * _9.wwww) + _49;
    _9.x = dot(_85, _21_m1[0].xyz);
    _9.y = dot(_85, _21_m1[1].xyz);
    _9.z = dot(_85, _21_m1[2].xyz);
    _107 = dot(_9.xyz, _9.xyz);
    _107 = rsqrt(_107);
    float3 _119 = _107.xxx * _9.xyz;
    _9 = float4(_119.x, _119.y, _119.z, _9.w);
    _107 = dot(_21_m6.xyz, _21_m6.xyz);
    _107 = rsqrt(_107);
    float3 _137 = _107.xxx * _21_m6.xyz;
    _49 = float4(_137.x, _137.y, _137.z, _49.w);
    _9.x = dot(_9.xyz, _49.xyz);
    _9.x = (_9.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _160 = (-_21_m5.xyz) + 1.0f.xxx;
    _160 = (_9.xxx * _160) + _21_m5.xyz;
    _9.x = _178.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _187 = (-_21_m3.xyz) + _21_m4.xyz;
    float3 _204 = (_9.xxx * _187) + _21_m3.xyz;
    _9 = float4(_204.x, _204.y, _204.z, _9.w);
    _207 = _9.xyz * _210.xyz;
    float3 _217 = _160 * _207;
    _214 = float4(_217.x, _217.y, _217.z, _214.w);
    _214.w = 1.0f;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _85 = stage_input._85;
    _178 = stage_input._178;
    _210 = stage_input._210;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._214 = _214;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 _9;
static float4 _11;

struct SPIRV_Cross_Input
{
    float4 _11 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = _11;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}