// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmGland" {
Properties {

_FleshColor ("Flesh", Color) = (0.42,0.07,0.07,1)

_VeinColor ("Veins", Color) = (0.1,0.012,0.03,1)

_GlowColor ("Core Glow", Color) = (1.6,0.32,0.08,1)

_PulseSpeed ("Pulse Speed (beats/s)", Float) = 1.100000023841858

_PulseAmount ("Pulse Amount (object units)", Float) = 0.002199999988079071

_Quiver ("Surface Quiver", Float) = 0.0006000000284984708

_VeinScale ("Vein Scale", Float) = 150.0

_VeinWidth ("Vein Width", Range(0.02, 0.6)) = 0.18000000715255737

_SkyColor ("Sky Ambient", Color) = (0.3,0.3,0.34,1)

_GroundColor ("Ground Ambient", Color) = (0.08,0.05,0.05,1)

_KeyDir ("Key Direction (world)", Vector) = (0.35,0.8,0.45,0)

_KeyColor ("Key Color", Color) = (0.95,0.74,0.5,1)

_Wetness ("Wet Specular", Range(0, 2)) = 0.8999999761581421

_Gloss ("Specular Exponent", Range(4, 128)) = 56.0

_RimColor ("Wet Rim (A = strength)", Color) = (1,0.55,0.5,0.55)

_RimPower ("Rim Power", Range(0.5, 8)) = 3.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
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
static float4 _30_m2[4];
float4x4 unity_WorldToObject;
static float4 _30_m3[4];
float4x4 unity_MatrixVP;
static float4 _30_m4[4];
float4 unity_FogParams;
float _PulseSpeed;
float _PulseAmount;
float _Quiver;
float4 _SkyColor;
float4 _GroundColor;
void __unity_init()
{
    _30_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _30_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _30_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _30_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _30_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _30_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _30_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _30_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _30_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _30_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _30_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _30_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _30_m0 _Time
#define _30_m1 _ProjectionParams
#define _30_m5 unity_FogParams
#define _30_m6 _PulseSpeed
#define _30_m7 _PulseAmount
#define _30_m8 _Quiver
#define _30_m9 _SkyColor
#define _30_m10 _GroundColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float4 _130;
static float3 _148;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _148 : NORMAL;
    float4 _130 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float2 vs_TEXCOORD4 : TEXCOORD5;
    float vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _45;
static float _129;
static float4 _158;
static float _280;
static float _298;
static float3 _305;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_11.xyz, float3(211.0f, 173.0f, 157.0f));
    _9.x = (_30_m0.y * 5.30000019073486328125f) + _9.x;
    _45.x = dot(_11.xyz, float3(97.0f, 241.0f, 131.0f));
    _9.y = (_30_m0.y * 3.099999904632568359375f) + (-_45.x);
    float2 _65 = sin(_9.xy);
    _9 = float4(_65.x, _65.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    _45.x = _30_m0.y * _30_m6;
    _45.x = frac(_45.x);
    _45 = _45.xx + float2(-0.07999999821186065673828125f, -0.300000011920928955078125f);
    _45 *= float2(16.0f, 18.0f);
    _45 *= _45;
    _45 *= (-1.44269502162933349609375f).xx;
    _45 = exp2(_45);
    _9.y = (_45.y * 0.60000002384185791015625f) + _45.x;
    float2 _122 = _9.xy * float2(_30_m8, _30_m7);
    _9 = float4(_122.x, _9.y, _122.y, _9.w);
    vs_TEXCOORD5 = _9.y;
    _129 = (_130.y * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _9.x = (_9.z * _129) + _9.x;
    float3 _155 = (_148 * _9.xxx) + _11.xyz;
    _9 = float4(_155.x, _155.y, _155.z, _9.w);
    _158 = _9.yyyy * _30_m2[1];
    _158 = (_30_m2[0] * _9.xxxx) + _158;
    _9 = (_30_m2[2] * _9.zzzz) + _158;
    _9 += _30_m2[3];
    _158 = _9.yyyy * _30_m4[1];
    _158 = (_30_m4[0] * _9.xxxx) + _158;
    _158 = (_30_m4[2] * _9.zzzz) + _158;
    _158 = (_30_m4[3] * _9.wwww) + _158;
    vs_TEXCOORD1 = _9.xyz;
    gl_Position = _158;
    _9.x = _158.z / _30_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _30_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _30_m5.y;
    vs_TEXCOORD6 = exp2(-_9.x);
    vs_TEXCOORD0 = _11.xyz;
    _9.x = dot(_148, _30_m3[0].xyz);
    _9.y = dot(_148, _30_m3[1].xyz);
    _9.z = dot(_148, _30_m3[2].xyz);
    _280 = dot(_9.xyz, _9.xyz);
    _280 = rsqrt(_280);
    float3 _292 = _280.xxx * _9.xyz;
    _9 = float4(_292.x, _292.y, _292.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _298 = (_9.y * 0.5f) + 0.5f;
    _305 = _30_m9.xyz + (-_30_m10.xyz);
    vs_TEXCOORD3 = (_298.xxx * _305) + _30_m10.xyz;
    vs_TEXCOORD4 = _130.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _148 = stage_input._148;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _FleshColor;
float4 _VeinColor;
float4 _GlowColor;
float _VeinScale;
float _VeinWidth;
float4 _KeyDir;
float4 _KeyColor;
float _Wetness;
float _Gloss;
float4 _RimColor;
float _RimPower;
#define _30_m0 _WorldSpaceCameraPos
#define _30_m1 unity_FogColor
#define _30_m2 _FleshColor
#define _30_m3 _VeinColor
#define _30_m4 _GlowColor
#define _30_m5 _VeinScale
#define _30_m6 _VeinWidth
#define _30_m7 _KeyDir
#define _30_m8 _KeyColor
#define _30_m9 _Wetness
#define _30_m10 _Gloss
#define _30_m11 _RimColor
#define _30_m12 _RimPower



static float2 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD6;
static float4 _466;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float2 vs_TEXCOORD4 : TEXCOORD5;
    float vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _466 : SV_Target0;
};

static float4 _9;
static float3 _23;
static float3 _46;
static float _56;
static float _99;
static float2 _114;
static float _118;
static float4 _173;
static float3 _184;
static float3 _190;
static float3 _255;
static float3 _270;
static float _343;
static float3 _395;

void frag_inner()
{
    _9 = float4(vs_TEXCOORD4, vs_TEXCOORD5, 0.0f);
    _23 = vs_TEXCOORD0.zxy * float3(float3(_30_m5, _30_m5, _30_m5));
    float2 _52 = _23.zx * float2(0.829999983310699462890625f, 1.07000005245208740234375f);
    _46 = float3(_52.x, _52.y, _46.z);
    _56 = sin(_46.y);
    _56 = (_56 * 1.2999999523162841796875f) + _46.x;
    _56 = sin(_56);
    _56 = (_56 * 2.099999904632568359375f) + _23.y;
    _23 = (_23 * 1.62999999523162841796875f.xxx) + 4.099999904632568359375f.xxx;
    _56 = sin(_56);
    _46.x = 1.0f / _30_m6;
    _56 = abs(_56) * _46.x;
    _56 = clamp(_56, 0.0f, 1.0f);
    _99 = (_56 * (-2.0f)) + 3.0f;
    _56 *= _56;
    _56 = ((-_99) * _56) + 1.0f;
    _114 = _23.yz * float2(0.829999983310699462890625f, 1.07000005245208740234375f);
    _118 = sin(_114.y);
    _114.x = (_118 * 1.2999999523162841796875f) + _114.x;
    _114.x = sin(_114.x);
    _23.x = (_114.x * 2.099999904632568359375f) + _23.x;
    _23.x = sin(_23.x);
    _23.x = _46.x * abs(_23.x);
    _23.x = clamp(_23.x, 0.0f, 1.0f);
    _114.x = (_23.x * (-2.0f)) + 3.0f;
    _23.x *= _23.x;
    _23.x = ((-_114.x) * _23.x) + 1.0f;
    _173.x = _23.x * 0.699999988079071044921875f;
    _173.x = max(_56, _173.x);
    _184.x = _173.x * 0.85000002384185791015625f;
    _190 = (-_30_m2.xyz) + _30_m3.xyz;
    float3 _209 = (_184.xxx * _190) + _30_m2.xyz;
    _173 = float4(_173.x, _209.x, _209.y, _209.z);
    _190.x = ((-_173.x) * 0.5f) + 1.0f;
    _173 *= _9.zxxx;
    _173.x *= 0.2199999988079071044921875f;
    _23 = (-vs_TEXCOORD1) + _30_m0;
    _56 = dot(_23, _23);
    _56 = rsqrt(_56);
    _23 = _56.xxx * _23;
    _56 = dot(_30_m7.xyz, _30_m7.xyz);
    _56 = rsqrt(_56);
    _255 = (_30_m7.xyz * _56.xxx) + _23;
    _46 = _56.xxx * _30_m7.xyz;
    _270.x = dot(_255, _255);
    _270.x = rsqrt(_270.x);
    _255 *= _270.xxx;
    _270.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _270.x = rsqrt(_270.x);
    _270 = _270.xxx * vs_TEXCOORD2;
    _255.x = dot(_270, _255);
    _255.x = clamp(_255.x, 0.0f, 1.0f);
    _255.x = log2(_255.x);
    _255.x *= _30_m10;
    _255.x = exp2(_255.x);
    _255.x *= _30_m9;
    _190.x *= _255.x;
    _190 = _190.xxx * _30_m8.xyz;
    _190 *= _9.xxx;
    _343 = dot(_270, _46);
    _270.x = dot(_270, _23);
    _270.x = clamp(_270.x, 0.0f, 1.0f);
    _270.x = (-_270.x) + 1.0f;
    _270.x = log2(_270.x);
    _270.x *= _30_m12;
    _270.x = exp2(_270.x);
    _270.x *= _30_m11.w;
    _270 = _270.xxx * _30_m11.xyz;
    _343 = (_343 * 0.5f) + 0.5f;
    _343 *= _343;
    _395 = (_30_m8.xyz * _343.xxx) + vs_TEXCOORD3;
    _184 = (_173.yzw * _395) + _190;
    _184 = (_270 * _9.xxx) + _184;
    _190.x = (_9.z * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _173.x = (_9.y * _190.x) + _173.x;
    float3 _442 = (_30_m4.xyz * _173.xxx) + _184;
    _173 = float4(_442.x, _442.y, _442.z, _173.w);
    _23 = _173.xyz + (-_30_m1.xyz);
    _56 = vs_TEXCOORD6;
    _56 = clamp(_56, 0.0f, 1.0f);
    _23 = (_56.xxx * _23) + _30_m1.xyz;
    _466 = float4(_23.x, _23.y, _23.z, _466.w);
    _466.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._466 = _466;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _30_m2[4];
float4x4 unity_WorldToObject;
static float4 _30_m3[4];
float4x4 unity_MatrixVP;
static float4 _30_m4[4];
float4 unity_FogParams;
float _PulseSpeed;
float _PulseAmount;
float _Quiver;
float4 _SkyColor;
float4 _GroundColor;
void __unity_init()
{
    _30_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _30_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _30_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _30_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _30_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _30_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _30_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _30_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _30_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _30_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _30_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _30_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _30_m0 _Time
#define _30_m1 _ProjectionParams
#define _30_m5 unity_FogParams
#define _30_m6 _PulseSpeed
#define _30_m7 _PulseAmount
#define _30_m8 _Quiver
#define _30_m9 _SkyColor
#define _30_m10 _GroundColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float4 _130;
static float3 _148;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _148 : NORMAL;
    float4 _130 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float2 vs_TEXCOORD4 : TEXCOORD5;
    float vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _45;
static float _129;
static float4 _158;
static float _286;
static float _304;
static float3 _311;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_11.xyz, float3(211.0f, 173.0f, 157.0f));
    _9.x = (_30_m0.y * 5.30000019073486328125f) + _9.x;
    _45.x = dot(_11.xyz, float3(97.0f, 241.0f, 131.0f));
    _9.y = (_30_m0.y * 3.099999904632568359375f) + (-_45.x);
    float2 _65 = sin(_9.xy);
    _9 = float4(_65.x, _65.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    _45.x = _30_m0.y * _30_m6;
    _45.x = frac(_45.x);
    _45 = _45.xx + float2(-0.07999999821186065673828125f, -0.300000011920928955078125f);
    _45 *= float2(16.0f, 18.0f);
    _45 *= _45;
    _45 *= (-1.44269502162933349609375f).xx;
    _45 = exp2(_45);
    _9.y = (_45.y * 0.60000002384185791015625f) + _45.x;
    float2 _122 = _9.xy * float2(_30_m8, _30_m7);
    _9 = float4(_122.x, _9.y, _122.y, _9.w);
    vs_TEXCOORD5 = _9.y;
    _129 = (_130.y * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _9.x = (_9.z * _129) + _9.x;
    float3 _155 = (_148 * _9.xxx) + _11.xyz;
    _9 = float4(_155.x, _155.y, _155.z, _9.w);
    _158 = _9.yyyy * _30_m2[1];
    _158 = (_30_m2[0] * _9.xxxx) + _158;
    _9 = (_30_m2[2] * _9.zzzz) + _158;
    _9 += _30_m2[3];
    _158 = _9.yyyy * _30_m4[1];
    _158 = (_30_m4[0] * _9.xxxx) + _158;
    _158 = (_30_m4[2] * _9.zzzz) + _158;
    _158 = (_30_m4[3] * _9.wwww) + _158;
    vs_TEXCOORD1 = _9.xyz;
    gl_Position = _158;
    _9.x = _158.z / _30_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _30_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _30_m5.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD6 = exp2(_9.x);
    vs_TEXCOORD0 = _11.xyz;
    _9.x = dot(_148, _30_m3[0].xyz);
    _9.y = dot(_148, _30_m3[1].xyz);
    _9.z = dot(_148, _30_m3[2].xyz);
    _286 = dot(_9.xyz, _9.xyz);
    _286 = rsqrt(_286);
    float3 _298 = _286.xxx * _9.xyz;
    _9 = float4(_298.x, _298.y, _298.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _304 = (_9.y * 0.5f) + 0.5f;
    _311 = _30_m9.xyz + (-_30_m10.xyz);
    vs_TEXCOORD3 = (_304.xxx * _311) + _30_m10.xyz;
    vs_TEXCOORD4 = _130.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _148 = stage_input._148;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _FleshColor;
float4 _VeinColor;
float4 _GlowColor;
float _VeinScale;
float _VeinWidth;
float4 _KeyDir;
float4 _KeyColor;
float _Wetness;
float _Gloss;
float4 _RimColor;
float _RimPower;
#define _30_m0 _WorldSpaceCameraPos
#define _30_m1 unity_FogColor
#define _30_m2 _FleshColor
#define _30_m3 _VeinColor
#define _30_m4 _GlowColor
#define _30_m5 _VeinScale
#define _30_m6 _VeinWidth
#define _30_m7 _KeyDir
#define _30_m8 _KeyColor
#define _30_m9 _Wetness
#define _30_m10 _Gloss
#define _30_m11 _RimColor
#define _30_m12 _RimPower



static float2 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD6;
static float4 _466;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float2 vs_TEXCOORD4 : TEXCOORD5;
    float vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _466 : SV_Target0;
};

static float4 _9;
static float3 _23;
static float3 _46;
static float _56;
static float _99;
static float2 _114;
static float _118;
static float4 _173;
static float3 _184;
static float3 _190;
static float3 _255;
static float3 _270;
static float _343;
static float3 _395;

void frag_inner()
{
    _9 = float4(vs_TEXCOORD4, vs_TEXCOORD5, 0.0f);
    _23 = vs_TEXCOORD0.zxy * float3(float3(_30_m5, _30_m5, _30_m5));
    float2 _52 = _23.zx * float2(0.829999983310699462890625f, 1.07000005245208740234375f);
    _46 = float3(_52.x, _52.y, _46.z);
    _56 = sin(_46.y);
    _56 = (_56 * 1.2999999523162841796875f) + _46.x;
    _56 = sin(_56);
    _56 = (_56 * 2.099999904632568359375f) + _23.y;
    _23 = (_23 * 1.62999999523162841796875f.xxx) + 4.099999904632568359375f.xxx;
    _56 = sin(_56);
    _46.x = 1.0f / _30_m6;
    _56 = abs(_56) * _46.x;
    _56 = clamp(_56, 0.0f, 1.0f);
    _99 = (_56 * (-2.0f)) + 3.0f;
    _56 *= _56;
    _56 = ((-_99) * _56) + 1.0f;
    _114 = _23.yz * float2(0.829999983310699462890625f, 1.07000005245208740234375f);
    _118 = sin(_114.y);
    _114.x = (_118 * 1.2999999523162841796875f) + _114.x;
    _114.x = sin(_114.x);
    _23.x = (_114.x * 2.099999904632568359375f) + _23.x;
    _23.x = sin(_23.x);
    _23.x = _46.x * abs(_23.x);
    _23.x = clamp(_23.x, 0.0f, 1.0f);
    _114.x = (_23.x * (-2.0f)) + 3.0f;
    _23.x *= _23.x;
    _23.x = ((-_114.x) * _23.x) + 1.0f;
    _173.x = _23.x * 0.699999988079071044921875f;
    _173.x = max(_56, _173.x);
    _184.x = _173.x * 0.85000002384185791015625f;
    _190 = (-_30_m2.xyz) + _30_m3.xyz;
    float3 _209 = (_184.xxx * _190) + _30_m2.xyz;
    _173 = float4(_173.x, _209.x, _209.y, _209.z);
    _190.x = ((-_173.x) * 0.5f) + 1.0f;
    _173 *= _9.zxxx;
    _173.x *= 0.2199999988079071044921875f;
    _23 = (-vs_TEXCOORD1) + _30_m0;
    _56 = dot(_23, _23);
    _56 = rsqrt(_56);
    _23 = _56.xxx * _23;
    _56 = dot(_30_m7.xyz, _30_m7.xyz);
    _56 = rsqrt(_56);
    _255 = (_30_m7.xyz * _56.xxx) + _23;
    _46 = _56.xxx * _30_m7.xyz;
    _270.x = dot(_255, _255);
    _270.x = rsqrt(_270.x);
    _255 *= _270.xxx;
    _270.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _270.x = rsqrt(_270.x);
    _270 = _270.xxx * vs_TEXCOORD2;
    _255.x = dot(_270, _255);
    _255.x = clamp(_255.x, 0.0f, 1.0f);
    _255.x = log2(_255.x);
    _255.x *= _30_m10;
    _255.x = exp2(_255.x);
    _255.x *= _30_m9;
    _190.x *= _255.x;
    _190 = _190.xxx * _30_m8.xyz;
    _190 *= _9.xxx;
    _343 = dot(_270, _46);
    _270.x = dot(_270, _23);
    _270.x = clamp(_270.x, 0.0f, 1.0f);
    _270.x = (-_270.x) + 1.0f;
    _270.x = log2(_270.x);
    _270.x *= _30_m12;
    _270.x = exp2(_270.x);
    _270.x *= _30_m11.w;
    _270 = _270.xxx * _30_m11.xyz;
    _343 = (_343 * 0.5f) + 0.5f;
    _343 *= _343;
    _395 = (_30_m8.xyz * _343.xxx) + vs_TEXCOORD3;
    _184 = (_173.yzw * _395) + _190;
    _184 = (_270 * _9.xxx) + _184;
    _190.x = (_9.z * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _173.x = (_9.y * _190.x) + _173.x;
    float3 _442 = (_30_m4.xyz * _173.xxx) + _184;
    _173 = float4(_442.x, _442.y, _442.z, _173.w);
    _23 = _173.xyz + (-_30_m1.xyz);
    _56 = vs_TEXCOORD6;
    _56 = clamp(_56, 0.0f, 1.0f);
    _23 = (_56.xxx * _23) + _30_m1.xyz;
    _466 = float4(_23.x, _23.y, _23.z, _466.w);
    _466.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._466 = _466;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _30_m2[4];
float4x4 unity_WorldToObject;
static float4 _30_m3[4];
float4x4 unity_MatrixVP;
static float4 _30_m4[4];
float4 unity_FogParams;
float _PulseSpeed;
float _PulseAmount;
float _Quiver;
float4 _SkyColor;
float4 _GroundColor;
void __unity_init()
{
    _30_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _30_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _30_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _30_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _30_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _30_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _30_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _30_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _30_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _30_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _30_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _30_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _30_m0 _Time
#define _30_m1 _ProjectionParams
#define _30_m5 unity_FogParams
#define _30_m6 _PulseSpeed
#define _30_m7 _PulseAmount
#define _30_m8 _Quiver
#define _30_m9 _SkyColor
#define _30_m10 _GroundColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float4 _130;
static float3 _148;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _148 : NORMAL;
    float4 _130 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float2 vs_TEXCOORD4 : TEXCOORD5;
    float vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _45;
static float _129;
static float4 _158;
static float _279;
static float _297;
static float3 _304;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_11.xyz, float3(211.0f, 173.0f, 157.0f));
    _9.x = (_30_m0.y * 5.30000019073486328125f) + _9.x;
    _45.x = dot(_11.xyz, float3(97.0f, 241.0f, 131.0f));
    _9.y = (_30_m0.y * 3.099999904632568359375f) + (-_45.x);
    float2 _65 = sin(_9.xy);
    _9 = float4(_65.x, _65.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    _45.x = _30_m0.y * _30_m6;
    _45.x = frac(_45.x);
    _45 = _45.xx + float2(-0.07999999821186065673828125f, -0.300000011920928955078125f);
    _45 *= float2(16.0f, 18.0f);
    _45 *= _45;
    _45 *= (-1.44269502162933349609375f).xx;
    _45 = exp2(_45);
    _9.y = (_45.y * 0.60000002384185791015625f) + _45.x;
    float2 _122 = _9.xy * float2(_30_m8, _30_m7);
    _9 = float4(_122.x, _9.y, _122.y, _9.w);
    vs_TEXCOORD5 = _9.y;
    _129 = (_130.y * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _9.x = (_9.z * _129) + _9.x;
    float3 _155 = (_148 * _9.xxx) + _11.xyz;
    _9 = float4(_155.x, _155.y, _155.z, _9.w);
    _158 = _9.yyyy * _30_m2[1];
    _158 = (_30_m2[0] * _9.xxxx) + _158;
    _9 = (_30_m2[2] * _9.zzzz) + _158;
    _9 += _30_m2[3];
    _158 = _9.yyyy * _30_m4[1];
    _158 = (_30_m4[0] * _9.xxxx) + _158;
    _158 = (_30_m4[2] * _9.zzzz) + _158;
    _158 = (_30_m4[3] * _9.wwww) + _158;
    vs_TEXCOORD1 = _9.xyz;
    gl_Position = _158;
    _9.x = _158.z / _30_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _30_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD6 = (_9.x * _30_m5.z) + _30_m5.w;
    vs_TEXCOORD0 = _11.xyz;
    _9.x = dot(_148, _30_m3[0].xyz);
    _9.y = dot(_148, _30_m3[1].xyz);
    _9.z = dot(_148, _30_m3[2].xyz);
    _279 = dot(_9.xyz, _9.xyz);
    _279 = rsqrt(_279);
    float3 _291 = _279.xxx * _9.xyz;
    _9 = float4(_291.x, _291.y, _291.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _297 = (_9.y * 0.5f) + 0.5f;
    _304 = _30_m9.xyz + (-_30_m10.xyz);
    vs_TEXCOORD3 = (_297.xxx * _304) + _30_m10.xyz;
    vs_TEXCOORD4 = _130.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _148 = stage_input._148;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _FleshColor;
float4 _VeinColor;
float4 _GlowColor;
float _VeinScale;
float _VeinWidth;
float4 _KeyDir;
float4 _KeyColor;
float _Wetness;
float _Gloss;
float4 _RimColor;
float _RimPower;
#define _30_m0 _WorldSpaceCameraPos
#define _30_m1 unity_FogColor
#define _30_m2 _FleshColor
#define _30_m3 _VeinColor
#define _30_m4 _GlowColor
#define _30_m5 _VeinScale
#define _30_m6 _VeinWidth
#define _30_m7 _KeyDir
#define _30_m8 _KeyColor
#define _30_m9 _Wetness
#define _30_m10 _Gloss
#define _30_m11 _RimColor
#define _30_m12 _RimPower



static float2 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD6;
static float4 _466;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float2 vs_TEXCOORD4 : TEXCOORD5;
    float vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _466 : SV_Target0;
};

static float4 _9;
static float3 _23;
static float3 _46;
static float _56;
static float _99;
static float2 _114;
static float _118;
static float4 _173;
static float3 _184;
static float3 _190;
static float3 _255;
static float3 _270;
static float _343;
static float3 _395;

void frag_inner()
{
    _9 = float4(vs_TEXCOORD4, vs_TEXCOORD5, 0.0f);
    _23 = vs_TEXCOORD0.zxy * float3(float3(_30_m5, _30_m5, _30_m5));
    float2 _52 = _23.zx * float2(0.829999983310699462890625f, 1.07000005245208740234375f);
    _46 = float3(_52.x, _52.y, _46.z);
    _56 = sin(_46.y);
    _56 = (_56 * 1.2999999523162841796875f) + _46.x;
    _56 = sin(_56);
    _56 = (_56 * 2.099999904632568359375f) + _23.y;
    _23 = (_23 * 1.62999999523162841796875f.xxx) + 4.099999904632568359375f.xxx;
    _56 = sin(_56);
    _46.x = 1.0f / _30_m6;
    _56 = abs(_56) * _46.x;
    _56 = clamp(_56, 0.0f, 1.0f);
    _99 = (_56 * (-2.0f)) + 3.0f;
    _56 *= _56;
    _56 = ((-_99) * _56) + 1.0f;
    _114 = _23.yz * float2(0.829999983310699462890625f, 1.07000005245208740234375f);
    _118 = sin(_114.y);
    _114.x = (_118 * 1.2999999523162841796875f) + _114.x;
    _114.x = sin(_114.x);
    _23.x = (_114.x * 2.099999904632568359375f) + _23.x;
    _23.x = sin(_23.x);
    _23.x = _46.x * abs(_23.x);
    _23.x = clamp(_23.x, 0.0f, 1.0f);
    _114.x = (_23.x * (-2.0f)) + 3.0f;
    _23.x *= _23.x;
    _23.x = ((-_114.x) * _23.x) + 1.0f;
    _173.x = _23.x * 0.699999988079071044921875f;
    _173.x = max(_56, _173.x);
    _184.x = _173.x * 0.85000002384185791015625f;
    _190 = (-_30_m2.xyz) + _30_m3.xyz;
    float3 _209 = (_184.xxx * _190) + _30_m2.xyz;
    _173 = float4(_173.x, _209.x, _209.y, _209.z);
    _190.x = ((-_173.x) * 0.5f) + 1.0f;
    _173 *= _9.zxxx;
    _173.x *= 0.2199999988079071044921875f;
    _23 = (-vs_TEXCOORD1) + _30_m0;
    _56 = dot(_23, _23);
    _56 = rsqrt(_56);
    _23 = _56.xxx * _23;
    _56 = dot(_30_m7.xyz, _30_m7.xyz);
    _56 = rsqrt(_56);
    _255 = (_30_m7.xyz * _56.xxx) + _23;
    _46 = _56.xxx * _30_m7.xyz;
    _270.x = dot(_255, _255);
    _270.x = rsqrt(_270.x);
    _255 *= _270.xxx;
    _270.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _270.x = rsqrt(_270.x);
    _270 = _270.xxx * vs_TEXCOORD2;
    _255.x = dot(_270, _255);
    _255.x = clamp(_255.x, 0.0f, 1.0f);
    _255.x = log2(_255.x);
    _255.x *= _30_m10;
    _255.x = exp2(_255.x);
    _255.x *= _30_m9;
    _190.x *= _255.x;
    _190 = _190.xxx * _30_m8.xyz;
    _190 *= _9.xxx;
    _343 = dot(_270, _46);
    _270.x = dot(_270, _23);
    _270.x = clamp(_270.x, 0.0f, 1.0f);
    _270.x = (-_270.x) + 1.0f;
    _270.x = log2(_270.x);
    _270.x *= _30_m12;
    _270.x = exp2(_270.x);
    _270.x *= _30_m11.w;
    _270 = _270.xxx * _30_m11.xyz;
    _343 = (_343 * 0.5f) + 0.5f;
    _343 *= _343;
    _395 = (_30_m8.xyz * _343.xxx) + vs_TEXCOORD3;
    _184 = (_173.yzw * _395) + _190;
    _184 = (_270 * _9.xxx) + _184;
    _190.x = (_9.z * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _173.x = (_9.y * _190.x) + _173.x;
    float3 _442 = (_30_m4.xyz * _173.xxx) + _184;
    _173 = float4(_442.x, _442.y, _442.z, _173.w);
    _23 = _173.xyz + (-_30_m1.xyz);
    _56 = vs_TEXCOORD6;
    _56 = clamp(_56, 0.0f, 1.0f);
    _23 = (_56.xxx * _23) + _30_m1.xyz;
    _466 = float4(_23.x, _23.y, _23.z, _466.w);
    _466.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._466 = _466;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _30_m1[4];
float4x4 unity_WorldToObject;
static float4 _30_m2[4];
float4x4 unity_MatrixVP;
static float4 _30_m3[4];
float _PulseSpeed;
float _PulseAmount;
float _Quiver;
float4 _SkyColor;
float4 _GroundColor;
void __unity_init()
{
    _30_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _30_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _30_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _30_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _30_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _30_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _30_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _30_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _30_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _30_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _30_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _30_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _30_m0 _Time
#define _30_m4 _PulseSpeed
#define _30_m5 _PulseAmount
#define _30_m6 _Quiver
#define _30_m7 _SkyColor
#define _30_m8 _GroundColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float4 _130;
static float3 _148;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _148 : NORMAL;
    float4 _130 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float2 vs_TEXCOORD4 : TEXCOORD4;
    float vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _45;
static float _129;
static float4 _158;
static float _243;
static float _261;
static float3 _268;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_11.xyz, float3(211.0f, 173.0f, 157.0f));
    _9.x = (_30_m0.y * 5.30000019073486328125f) + _9.x;
    _45.x = dot(_11.xyz, float3(97.0f, 241.0f, 131.0f));
    _9.y = (_30_m0.y * 3.099999904632568359375f) + (-_45.x);
    float2 _65 = sin(_9.xy);
    _9 = float4(_65.x, _65.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    _45.x = _30_m0.y * _30_m4;
    _45.x = frac(_45.x);
    _45 = _45.xx + float2(-0.07999999821186065673828125f, -0.300000011920928955078125f);
    _45 *= float2(16.0f, 18.0f);
    _45 *= _45;
    _45 *= (-1.44269502162933349609375f).xx;
    _45 = exp2(_45);
    _9.y = (_45.y * 0.60000002384185791015625f) + _45.x;
    float2 _122 = _9.xy * float2(_30_m6, _30_m5);
    _9 = float4(_122.x, _9.y, _122.y, _9.w);
    vs_TEXCOORD5 = _9.y;
    _129 = (_130.y * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _9.x = (_9.z * _129) + _9.x;
    float3 _155 = (_148 * _9.xxx) + _11.xyz;
    _9 = float4(_155.x, _155.y, _155.z, _9.w);
    _158 = _9.yyyy * _30_m1[1];
    _158 = (_30_m1[0] * _9.xxxx) + _158;
    _9 = (_30_m1[2] * _9.zzzz) + _158;
    _9 += _30_m1[3];
    _158 = _9.yyyy * _30_m3[1];
    _158 = (_30_m3[0] * _9.xxxx) + _158;
    _158 = (_30_m3[2] * _9.zzzz) + _158;
    gl_Position = (_30_m3[3] * _9.wwww) + _158;
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD0 = _11.xyz;
    _9.x = dot(_148, _30_m2[0].xyz);
    _9.y = dot(_148, _30_m2[1].xyz);
    _9.z = dot(_148, _30_m2[2].xyz);
    _243 = dot(_9.xyz, _9.xyz);
    _243 = rsqrt(_243);
    float3 _255 = _243.xxx * _9.xyz;
    _9 = float4(_255.x, _255.y, _255.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _261 = (_9.y * 0.5f) + 0.5f;
    _268 = _30_m7.xyz + (-_30_m8.xyz);
    vs_TEXCOORD3 = (_261.xxx * _268) + _30_m8.xyz;
    vs_TEXCOORD4 = _130.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _148 = stage_input._148;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _FleshColor;
float4 _VeinColor;
float4 _GlowColor;
float _VeinScale;
float _VeinWidth;
float4 _KeyDir;
float4 _KeyColor;
float _Wetness;
float _Gloss;
float4 _RimColor;
float _RimPower;
#define _30_m0 _WorldSpaceCameraPos
#define _30_m1 _FleshColor
#define _30_m2 _VeinColor
#define _30_m3 _GlowColor
#define _30_m4 _VeinScale
#define _30_m5 _VeinWidth
#define _30_m6 _KeyDir
#define _30_m7 _KeyColor
#define _30_m8 _Wetness
#define _30_m9 _Gloss
#define _30_m10 _RimColor
#define _30_m11 _RimPower



static float2 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _435;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float2 vs_TEXCOORD4 : TEXCOORD4;
    float vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _435 : SV_Target0;
};

static float4 _9;
static float3 _23;
static float3 _46;
static float _56;
static float _99;
static float2 _114;
static float _118;
static float4 _173;
static float3 _184;
static float3 _190;
static float3 _255;
static float3 _270;
static float _343;
static float3 _395;

void frag_inner()
{
    _9 = float4(vs_TEXCOORD4, vs_TEXCOORD5, 0.0f);
    _23 = vs_TEXCOORD0.zxy * float3(float3(_30_m4, _30_m4, _30_m4));
    float2 _52 = _23.zx * float2(0.829999983310699462890625f, 1.07000005245208740234375f);
    _46 = float3(_52.x, _52.y, _46.z);
    _56 = sin(_46.y);
    _56 = (_56 * 1.2999999523162841796875f) + _46.x;
    _56 = sin(_56);
    _56 = (_56 * 2.099999904632568359375f) + _23.y;
    _23 = (_23 * 1.62999999523162841796875f.xxx) + 4.099999904632568359375f.xxx;
    _56 = sin(_56);
    _46.x = 1.0f / _30_m5;
    _56 = abs(_56) * _46.x;
    _56 = clamp(_56, 0.0f, 1.0f);
    _99 = (_56 * (-2.0f)) + 3.0f;
    _56 *= _56;
    _56 = ((-_99) * _56) + 1.0f;
    _114 = _23.yz * float2(0.829999983310699462890625f, 1.07000005245208740234375f);
    _118 = sin(_114.y);
    _114.x = (_118 * 1.2999999523162841796875f) + _114.x;
    _114.x = sin(_114.x);
    _23.x = (_114.x * 2.099999904632568359375f) + _23.x;
    _23.x = sin(_23.x);
    _23.x = _46.x * abs(_23.x);
    _23.x = clamp(_23.x, 0.0f, 1.0f);
    _114.x = (_23.x * (-2.0f)) + 3.0f;
    _23.x *= _23.x;
    _23.x = ((-_114.x) * _23.x) + 1.0f;
    _173.x = _23.x * 0.699999988079071044921875f;
    _173.x = max(_56, _173.x);
    _184.x = _173.x * 0.85000002384185791015625f;
    _190 = (-_30_m1.xyz) + _30_m2.xyz;
    float3 _209 = (_184.xxx * _190) + _30_m1.xyz;
    _173 = float4(_173.x, _209.x, _209.y, _209.z);
    _190.x = ((-_173.x) * 0.5f) + 1.0f;
    _173 *= _9.zxxx;
    _173.x *= 0.2199999988079071044921875f;
    _23 = (-vs_TEXCOORD1) + _30_m0;
    _56 = dot(_23, _23);
    _56 = rsqrt(_56);
    _23 = _56.xxx * _23;
    _56 = dot(_30_m6.xyz, _30_m6.xyz);
    _56 = rsqrt(_56);
    _255 = (_30_m6.xyz * _56.xxx) + _23;
    _46 = _56.xxx * _30_m6.xyz;
    _270.x = dot(_255, _255);
    _270.x = rsqrt(_270.x);
    _255 *= _270.xxx;
    _270.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _270.x = rsqrt(_270.x);
    _270 = _270.xxx * vs_TEXCOORD2;
    _255.x = dot(_270, _255);
    _255.x = clamp(_255.x, 0.0f, 1.0f);
    _255.x = log2(_255.x);
    _255.x *= _30_m9;
    _255.x = exp2(_255.x);
    _255.x *= _30_m8;
    _190.x *= _255.x;
    _190 = _190.xxx * _30_m7.xyz;
    _190 *= _9.xxx;
    _343 = dot(_270, _46);
    _270.x = dot(_270, _23);
    _270.x = clamp(_270.x, 0.0f, 1.0f);
    _270.x = (-_270.x) + 1.0f;
    _270.x = log2(_270.x);
    _270.x *= _30_m11;
    _270.x = exp2(_270.x);
    _270.x *= _30_m10.w;
    _270 = _270.xxx * _30_m10.xyz;
    _343 = (_343 * 0.5f) + 0.5f;
    _343 *= _343;
    _395 = (_30_m7.xyz * _343.xxx) + vs_TEXCOORD3;
    _184 = (_173.yzw * _395) + _190;
    _184 = (_270 * _9.xxx) + _184;
    _190.x = (_9.z * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _173.x = (_9.y * _190.x) + _173.x;
    float3 _444 = (_30_m3.xyz * _173.xxx) + _184;
    _435 = float4(_444.x, _444.y, _444.z, _435.w);
    _435.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._435 = _435;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}