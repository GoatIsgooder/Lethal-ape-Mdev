// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmFakeLit" {
Properties {

_Color ("Color", Color) = (1,1,1,1)

_MainTex ("Albedo (optional)", 2D) = "white" { }

_EmissionColor ("Emission", Color) = (0,0,0,1)

[Header(Ambient)] _SkyColor ("Sky Ambient", Color) = (0.3,0.33,0.38,1)

_GroundColor ("Ground Ambient", Color) = (0.07,0.065,0.06,1)

_ProbeBlend ("Light Probe Blend", Range(0, 1)) = 0.0

[Header(Key Light)] _KeyDir ("Key Direction (world)", Vector) = (0.35,0.8,0.45,0)

_KeyColor ("Key Color", Color) = (0.95,0.74,0.5,1)

_Wrap ("Half-Lambert Wrap", Range(0, 1)) = 0.6000000238418579

_SpecColor ("Specular Color", Color) = (0.25,0.25,0.25,1)

_Gloss ("Specular Exponent", Range(2, 128)) = 24.0

[Header(Rim)] _RimColor ("Rim Color (A = strength)", Color) = (0.55,0.62,0.72,0.35)

_RimPower ("Rim Power", Range(0.5, 8)) = 3.5

[Header(Grime)] [Toggle(_GRIME)] _GrimeOn ("Procedural Grime", Float) = 0.0

_GrimeColor ("Grime Color", Color) = (0.12,0.09,0.07,1)

_GrimeAmount ("Grime Amount", Range(0, 1)) = 0.44999998807907104

_GrimeScale ("Grime Scale (per metre)", Float) = 2.5

_GrimeStreak ("Vertical Streak Stretch", Range(1, 8)) = 3.0

_VertexColorAmount ("Vertex Color Amount", Range(0, 1)) = 1.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ _GRIME
#if defined(FOG_EXP) && defined(_GRIME)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4x4 unity_MatrixVP;
static float4 _21_m10[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _SkyColor;
float4 _GroundColor;
float _ProbeBlend;
float _VertexColorAmount;
float4 _Color;
float4 _EmissionColor;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m11 unity_FogParams
#define _21_m12 _MainTex_ST
#define _21_m13 _SkyColor
#define _21_m14 _GroundColor
#define _21_m15 _ProbeBlend
#define _21_m16 _VertexColorAmount
#define _21_m17 _Color
#define _21_m18 _EmissionColor



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float2 _142;
static float3 _154;
static float3 vs_TEXCOORD2;
static float4 _193;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _154 : NORMAL;
    float2 _142 : TEXCOORD0;
    float4 _193 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _174;
static float4 _192;
static float3 _218;
static float3 _240;
static float _268;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m10[1];
    _9 = (_21_m10[0] * _45.xxxx) + _9;
    _9 = (_21_m10[2] * _45.zzzz) + _9;
    _9 = (_21_m10[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m11.y;
    vs_TEXCOORD6 = exp2(-_9.x);
    vs_TEXCOORD0 = (_142 * _21_m12.xy) + _21_m12.zw;
    _9.x = dot(_154, _21_m9[0].xyz);
    _9.y = dot(_154, _21_m9[1].xyz);
    _9.z = dot(_154, _21_m9[2].xyz);
    _174 = dot(_9.xyz, _9.xyz);
    _174 = rsqrt(_174);
    float3 _186 = _174.xxx * _9.xyz;
    _9 = float4(_186.x, _186.y, _186.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _192 = _193 + (-1.0f).xxxx;
    _192 = (_21_m16.xxxx * _192) + 1.0f.xxxx;
    vs_TEXCOORD3 = _192 * _21_m17;
    vs_TEXCOORD4 = _21_m18.xyz;
    _218.x = _9.y * _9.y;
    _218.x = (_9.x * _9.x) + (-_218.x);
    _192 = _9.yzzx * _9.xyzz;
    _240.x = dot(_21_m4, _192);
    _240.y = dot(_21_m5, _192);
    _240.z = dot(_21_m6, _192);
    _218 = (_21_m7.xyz * _218.xxx) + _240;
    _268 = (_9.y * 0.5f) + 0.5f;
    _9.w = 1.0f;
    _240.x = dot(_21_m1, _9);
    _240.y = dot(_21_m2, _9);
    _240.z = dot(_21_m3, _9);
    _218 += _240;
    _218 = max(_218, 0.0f.xxx);
    _240 = _21_m13.xyz + (-_21_m14.xyz);
    _240 = (_268.xxx * _240) + _21_m14.xyz;
    _218 += (-_240);
    vs_TEXCOORD5 = (_21_m15.xxx * _218) + _240;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _142 = stage_input._142;
    _154 = stage_input._154;
    _193 = stage_input._193;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _KeyDir;
float4 _KeyColor;
float _Wrap;
float4 _SpecColor;
float _Gloss;
float4 _RimColor;
float _RimPower;
float4 _GrimeColor;
float _GrimeAmount;
float _GrimeScale;
float _GrimeStreak;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 unity_FogColor
#define _16_m2 _KeyDir
#define _16_m3 _KeyColor
#define _16_m4 _Wrap
#define _16_m5 _SpecColor
#define _16_m6 _Gloss
#define _16_m7 _RimColor
#define _16_m8 _RimPower
#define _16_m9 _GrimeColor
#define _16_m10 _GrimeAmount
#define _16_m11 _GrimeScale
#define _16_m12 _GrimeStreak


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD6;
static float4 _1212;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _1212 : SV_Target0;
};

static float4 _9;
static float3 _38;
static float4 _42;
static float3 _61;
static float _67;
static float _111;
static float3 _188;
static float _220;
static float _384;
static float3 _519;
static float _783;
static float _837;
static float3 _893;
static float3 _901;
static float3 _921;
static float _957;
static float4 _982;
static float _1000;
static float3 _1021;
static float _1050;
static float _1054;
static float3 _1084;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD1 * _16_m11.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _9.w = _9.y / _16_m12;
    _38 = floor(_9.xwz);
    float3 _46 = _38 + 1.0f.xxx;
    _42 = float4(_46.x, _46.y, _46.z, _42.w);
    float3 _53 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_53.x, _53.y, _53.z, _42.w);
    float3 _58 = frac(_42.xyz);
    _42 = float4(_58.x, _58.y, _58.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _67 = dot(_42.xyz, _61);
    float3 _76 = _67.xxx + _42.xyz;
    _42 = float4(_76.x, _76.y, _76.z, _42.w);
    _67 = _42.y + _42.x;
    _67 = _42.z * _67;
    _67 = frac(_67);
    float3 _95 = _38 + float3(0.0f, 1.0f, 1.0f);
    _42 = float4(_95.x, _95.y, _95.z, _42.w);
    float3 _100 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_100.x, _100.y, _100.z, _42.w);
    float3 _105 = frac(_42.xyz);
    _42 = float4(_105.x, _105.y, _105.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_42.xyz, _61);
    float3 _120 = _111.xxx + _42.xyz;
    _42 = float4(_120.x, _120.y, _120.z, _42.w);
    _111 = _42.y + _42.x;
    _111 = _42.z * _111;
    _111 = frac(_111);
    _67 += (-_111);
    float3 _140 = frac(_9.xwz);
    _42 = float4(_140.x, _140.y, _140.z, _42.w);
    float3 _150 = (_9.xwz * 3.099999904632568359375f.xxx) + 11.69999980926513671875f.xxx;
    _9 = float4(_150.x, _9.y, _150.y, _150.z);
    _61 = _42.xyz * _42.xyz;
    float3 _166 = ((-_42.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _42 = float4(_166.x, _166.y, _166.z, _42.w);
    float3 _172 = _42.xyz * _61;
    _42 = float4(_172.x, _172.y, _172.z, _42.w);
    _67 = (_42.x * _67) + _111;
    _61 = _38 + float3(1.0f, 0.0f, 1.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_61, _188);
    _61 = _111.xxx + _61;
    _111 = _61.y + _61.x;
    _111 = _61.z * _111;
    _111 = frac(_111);
    _61 = _38 + float3(0.0f, 0.0f, 1.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _111 += (-_220);
    _111 = (_42.x * _111) + _220;
    _67 += (-_111);
    _67 = (_42.y * _67) + _111;
    _61 = _38 + float3(1.0f, 1.0f, 0.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_61, _188);
    _61 = _111.xxx + _61;
    _111 = _61.y + _61.x;
    _111 = _61.z * _111;
    _111 = frac(_111);
    _61 = _38 + float3(0.0f, 1.0f, 0.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _111 += (-_220);
    _111 = (_42.x * _111) + _220;
    _61 = _38 + float3(1.0f, 0.0f, 0.0f);
    _38 *= 0.103100001811981201171875f.xxx;
    _38 = frac(_38);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _61 = _38.zyx + 31.31999969482421875f.xxx;
    _61.x = dot(_38, _61);
    _38 += _61.xxx;
    _38.x = _38.y + _38.x;
    _38.x = _38.z * _38.x;
    _38.x = frac(_38.x);
    _384 = (-_38.x) + _220;
    _38.x = (_42.x * _384) + _38.x;
    _384 = (-_38.x) + _111;
    _38.x = (_42.y * _384) + _38.x;
    _67 += (-_38.x);
    _67 = (_42.z * _67) + _38.x;
    _38 = floor(_9.xzw);
    float3 _428 = frac(_9.xzw);
    _9 = float4(_428.x, _9.y, _428.y, _428.z);
    float3 _432 = _38 + 1.0f.xxx;
    _42 = float4(_432.x, _432.y, _432.z, _42.w);
    float3 _437 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_437.x, _437.y, _437.z, _42.w);
    float3 _442 = frac(_42.xyz);
    _42 = float4(_442.x, _442.y, _442.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_42.xyz, _61);
    float3 _456 = _111.xxx + _42.xyz;
    _42 = float4(_456.x, _456.y, _456.z, _42.w);
    _111 = _42.y + _42.x;
    _111 = _42.z * _111;
    _111 = frac(_111);
    float3 _471 = _38 + float3(0.0f, 1.0f, 1.0f);
    _42 = float4(_471.x, _471.y, _471.z, _42.w);
    float3 _476 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_476.x, _476.y, _476.z, _42.w);
    float3 _481 = frac(_42.xyz);
    _42 = float4(_481.x, _481.y, _481.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _495 = _220.xxx + _42.xyz;
    _42 = float4(_495.x, _495.y, _495.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _42.x = frac(_42.x);
    _111 += (-_42.x);
    _519 = _9.xzw * _9.xzw;
    float3 _529 = ((-_9.xzw) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_529.x, _9.y, _529.y, _529.z);
    float3 _535 = _9.xzw * _519;
    _9 = float4(_535.x, _9.y, _535.y, _535.z);
    _111 = (_9.x * _111) + _42.x;
    float3 _546 = _38 + float3(1.0f, 0.0f, 1.0f);
    _42 = float4(_546.x, _546.y, _546.z, _42.w);
    float3 _551 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_551.x, _551.y, _551.z, _42.w);
    float3 _556 = frac(_42.xyz);
    _42 = float4(_556.x, _556.y, _556.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _570 = _220.xxx + _42.xyz;
    _42 = float4(_570.x, _570.y, _570.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _519 = _38 + float3(0.0f, 0.0f, 1.0f);
    float3 _588 = _519 * 0.103100001811981201171875f.xxx;
    _42 = float4(_42.x, _588.x, _588.y, _588.z);
    _42 = frac(_42);
    _61 = _42.wzy + 31.31999969482421875f.xxx;
    _61.x = dot(_42.yzw, _61);
    _519 = _42.yzw + _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _42.x = (-_519.x) + _42.x;
    _42.x = (_9.x * _42.x) + _519.x;
    _111 += (-_42.x);
    _111 = (_9.z * _111) + _42.x;
    float3 _651 = _38 + float3(1.0f, 1.0f, 0.0f);
    _42 = float4(_651.x, _651.y, _651.z, _42.w);
    float3 _656 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_656.x, _656.y, _656.z, _42.w);
    float3 _661 = frac(_42.xyz);
    _42 = float4(_661.x, _661.y, _661.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _675 = _220.xxx + _42.xyz;
    _42 = float4(_675.x, _675.y, _675.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _519 = _38 + float3(0.0f, 1.0f, 0.0f);
    float3 _693 = _519 * 0.103100001811981201171875f.xxx;
    _42 = float4(_42.x, _693.x, _693.y, _693.z);
    _42 = frac(_42);
    _61 = _42.wzy + 31.31999969482421875f.xxx;
    _61.x = dot(_42.yzw, _61);
    _519 = _42.yzw + _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _42.x = (-_519.x) + _42.x;
    _42.x = (_9.x * _42.x) + _519.x;
    _519 = _38 + float3(1.0f, 0.0f, 0.0f);
    _38 *= 0.103100001811981201171875f.xxx;
    _38 = frac(_38);
    _519 *= 0.103100001811981201171875f.xxx;
    _519 = frac(_519);
    _61 = _519.zyx + 31.31999969482421875f.xxx;
    _61.x = dot(_519, _61);
    _519 += _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _61 = _38.zyx + 31.31999969482421875f.xxx;
    _783 = dot(_38, _61);
    _38 += _783.xxx;
    _38.x = _38.y + _38.x;
    _38.x = _38.z * _38.x;
    _38.x = frac(_38.x);
    _384 = (-_38.x) + _519.x;
    _9.x = (_9.x * _384) + _38.x;
    _38.x = (-_9.x) + _42.x;
    _9.x = (_9.z * _38.x) + _9.x;
    _837 = (-_9.x) + _111;
    _9.x = (_9.w * _837) + _9.x;
    _9.x *= 0.2800000011920928955078125f;
    _9.x = (_67 * 0.7200000286102294921875f) + _9.x;
    _9.x += (-0.37999999523162841796875f);
    _9.x *= 1.92307698726654052734375f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _67 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _67;
    _893.x = _9.x * _16_m10;
    _901 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _918 = _901 * vs_TEXCOORD3.xyz;
    _9 = float4(_918.x, _918.y, _918.z, _9.w);
    _921 = (_16_m9.xyz * vs_TEXCOORD3.xyz) + (-_9.xyz);
    _921 = (_893.xxx * _921) + _9.xyz;
    _893.x = ((-_893.x) * 0.85000002384185791015625f) + 1.0f;
    float3 _954 = (-vs_TEXCOORD1) + _16_m0;
    _9 = float4(_954.x, _954.y, _954.z, _9.w);
    _957 = dot(_9.xyz, _9.xyz);
    _957 = rsqrt(_957);
    float3 _969 = _957.xxx * _9.xyz;
    _9 = float4(_969.x, _969.y, _969.z, _9.w);
    _957 = dot(_16_m2.xyz, _16_m2.xyz);
    _957 = rsqrt(_957);
    float3 _991 = (_16_m2.xyz * _957.xxx) + _9.xyz;
    _982 = float4(_991.x, _991.y, _991.z, _982.w);
    _38 = _957.xxx * _16_m2.xyz;
    _1000 = dot(_982.xyz, _982.xyz);
    _1000 = rsqrt(_1000);
    float3 _1012 = _1000.xxx * _982.xyz;
    _982 = float4(_1012.x, _1012.y, _1012.z, _982.w);
    _1000 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _1000 = rsqrt(_1000);
    _1021 = _1000.xxx * vs_TEXCOORD2;
    _982.x = dot(_1021, _982.xyz);
    _982.x = clamp(_982.x, 0.0f, 1.0f);
    _982.x = log2(_982.x);
    _982.x *= _16_m6;
    _982.x = exp2(_982.x);
    _1050 = dot(_1021, _38);
    _1054 = dot(_1021, _9.xyz);
    _1054 = clamp(_1054, 0.0f, 1.0f);
    _1054 = (-_1054) + 1.0f;
    _1054 = log2(_1054);
    _1054 *= _16_m8;
    _1054 = exp2(_1054);
    _1054 *= _16_m7.w;
    _1021 = _1054.xxx * _16_m7.xyz;
    _1084.x = _1050 * 4.0f;
    _1084.x = _1084.x;
    _1084.x = clamp(_1084.x, 0.0f, 1.0f);
    _982.x *= _1084.x;
    _893.x *= _982.x;
    float3 _1116 = _16_m3.xyz * _16_m5.xyz;
    _982 = float4(_1116.x, _982.y, _1116.y, _1116.z);
    float3 _1123 = _893.xxx * _982.xzw;
    _982 = float4(_1123.x, _982.y, _1123.y, _1123.z);
    _893.x = (_1050 * 0.5f) + 0.5f;
    _1050 = _1050;
    _1050 = clamp(_1050, 0.0f, 1.0f);
    _893.x = (_893.x * _893.x) + (-_1050);
    _893.x = (_16_m4 * _893.x) + _1050;
    _1084 = (_16_m3.xyz * _893.xxx) + vs_TEXCOORD5;
    _893 = (_921 * _1084) + _982.xzw;
    float3 _1173 = (vs_TEXCOORD5 * 0.64999997615814208984375f.xxx) + 0.3499999940395355224609375f.xxx;
    _982 = float4(_1173.x, _1173.y, _1173.z, _982.w);
    _893 = (_1021 * _982.xyz) + _893;
    _893 += vs_TEXCOORD4;
    float3 _1192 = _893 + (-_16_m1.xyz);
    _9 = float4(_1192.x, _1192.y, _1192.z, _9.w);
    _957 = vs_TEXCOORD6;
    _957 = clamp(_957, 0.0f, 1.0f);
    float3 _1208 = (_957.xxx * _9.xyz) + _16_m1.xyz;
    _9 = float4(_1208.x, _1208.y, _1208.z, _9.w);
    _1212 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1212.w);
    _1212.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1212 = _1212;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(_GRIME)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4x4 unity_MatrixVP;
static float4 _21_m10[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _SkyColor;
float4 _GroundColor;
float _ProbeBlend;
float _VertexColorAmount;
float4 _Color;
float4 _EmissionColor;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m11 unity_FogParams
#define _21_m12 _MainTex_ST
#define _21_m13 _SkyColor
#define _21_m14 _GroundColor
#define _21_m15 _ProbeBlend
#define _21_m16 _VertexColorAmount
#define _21_m17 _Color
#define _21_m18 _EmissionColor



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float2 _148;
static float3 _160;
static float3 vs_TEXCOORD2;
static float4 _199;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _160 : NORMAL;
    float2 _148 : TEXCOORD0;
    float4 _199 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _180;
static float4 _198;
static float3 _224;
static float3 _246;
static float _274;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m10[1];
    _9 = (_21_m10[0] * _45.xxxx) + _9;
    _9 = (_21_m10[2] * _45.zzzz) + _9;
    _9 = (_21_m10[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m11.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD6 = exp2(_9.x);
    vs_TEXCOORD0 = (_148 * _21_m12.xy) + _21_m12.zw;
    _9.x = dot(_160, _21_m9[0].xyz);
    _9.y = dot(_160, _21_m9[1].xyz);
    _9.z = dot(_160, _21_m9[2].xyz);
    _180 = dot(_9.xyz, _9.xyz);
    _180 = rsqrt(_180);
    float3 _192 = _180.xxx * _9.xyz;
    _9 = float4(_192.x, _192.y, _192.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _198 = _199 + (-1.0f).xxxx;
    _198 = (_21_m16.xxxx * _198) + 1.0f.xxxx;
    vs_TEXCOORD3 = _198 * _21_m17;
    vs_TEXCOORD4 = _21_m18.xyz;
    _224.x = _9.y * _9.y;
    _224.x = (_9.x * _9.x) + (-_224.x);
    _198 = _9.yzzx * _9.xyzz;
    _246.x = dot(_21_m4, _198);
    _246.y = dot(_21_m5, _198);
    _246.z = dot(_21_m6, _198);
    _224 = (_21_m7.xyz * _224.xxx) + _246;
    _274 = (_9.y * 0.5f) + 0.5f;
    _9.w = 1.0f;
    _246.x = dot(_21_m1, _9);
    _246.y = dot(_21_m2, _9);
    _246.z = dot(_21_m3, _9);
    _224 += _246;
    _224 = max(_224, 0.0f.xxx);
    _246 = _21_m13.xyz + (-_21_m14.xyz);
    _246 = (_274.xxx * _246) + _21_m14.xyz;
    _224 += (-_246);
    vs_TEXCOORD5 = (_21_m15.xxx * _224) + _246;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _148 = stage_input._148;
    _160 = stage_input._160;
    _199 = stage_input._199;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _KeyDir;
float4 _KeyColor;
float _Wrap;
float4 _SpecColor;
float _Gloss;
float4 _RimColor;
float _RimPower;
float4 _GrimeColor;
float _GrimeAmount;
float _GrimeScale;
float _GrimeStreak;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 unity_FogColor
#define _16_m2 _KeyDir
#define _16_m3 _KeyColor
#define _16_m4 _Wrap
#define _16_m5 _SpecColor
#define _16_m6 _Gloss
#define _16_m7 _RimColor
#define _16_m8 _RimPower
#define _16_m9 _GrimeColor
#define _16_m10 _GrimeAmount
#define _16_m11 _GrimeScale
#define _16_m12 _GrimeStreak


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD6;
static float4 _1212;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _1212 : SV_Target0;
};

static float4 _9;
static float3 _38;
static float4 _42;
static float3 _61;
static float _67;
static float _111;
static float3 _188;
static float _220;
static float _384;
static float3 _519;
static float _783;
static float _837;
static float3 _893;
static float3 _901;
static float3 _921;
static float _957;
static float4 _982;
static float _1000;
static float3 _1021;
static float _1050;
static float _1054;
static float3 _1084;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD1 * _16_m11.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _9.w = _9.y / _16_m12;
    _38 = floor(_9.xwz);
    float3 _46 = _38 + 1.0f.xxx;
    _42 = float4(_46.x, _46.y, _46.z, _42.w);
    float3 _53 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_53.x, _53.y, _53.z, _42.w);
    float3 _58 = frac(_42.xyz);
    _42 = float4(_58.x, _58.y, _58.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _67 = dot(_42.xyz, _61);
    float3 _76 = _67.xxx + _42.xyz;
    _42 = float4(_76.x, _76.y, _76.z, _42.w);
    _67 = _42.y + _42.x;
    _67 = _42.z * _67;
    _67 = frac(_67);
    float3 _95 = _38 + float3(0.0f, 1.0f, 1.0f);
    _42 = float4(_95.x, _95.y, _95.z, _42.w);
    float3 _100 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_100.x, _100.y, _100.z, _42.w);
    float3 _105 = frac(_42.xyz);
    _42 = float4(_105.x, _105.y, _105.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_42.xyz, _61);
    float3 _120 = _111.xxx + _42.xyz;
    _42 = float4(_120.x, _120.y, _120.z, _42.w);
    _111 = _42.y + _42.x;
    _111 = _42.z * _111;
    _111 = frac(_111);
    _67 += (-_111);
    float3 _140 = frac(_9.xwz);
    _42 = float4(_140.x, _140.y, _140.z, _42.w);
    float3 _150 = (_9.xwz * 3.099999904632568359375f.xxx) + 11.69999980926513671875f.xxx;
    _9 = float4(_150.x, _9.y, _150.y, _150.z);
    _61 = _42.xyz * _42.xyz;
    float3 _166 = ((-_42.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _42 = float4(_166.x, _166.y, _166.z, _42.w);
    float3 _172 = _42.xyz * _61;
    _42 = float4(_172.x, _172.y, _172.z, _42.w);
    _67 = (_42.x * _67) + _111;
    _61 = _38 + float3(1.0f, 0.0f, 1.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_61, _188);
    _61 = _111.xxx + _61;
    _111 = _61.y + _61.x;
    _111 = _61.z * _111;
    _111 = frac(_111);
    _61 = _38 + float3(0.0f, 0.0f, 1.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _111 += (-_220);
    _111 = (_42.x * _111) + _220;
    _67 += (-_111);
    _67 = (_42.y * _67) + _111;
    _61 = _38 + float3(1.0f, 1.0f, 0.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_61, _188);
    _61 = _111.xxx + _61;
    _111 = _61.y + _61.x;
    _111 = _61.z * _111;
    _111 = frac(_111);
    _61 = _38 + float3(0.0f, 1.0f, 0.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _111 += (-_220);
    _111 = (_42.x * _111) + _220;
    _61 = _38 + float3(1.0f, 0.0f, 0.0f);
    _38 *= 0.103100001811981201171875f.xxx;
    _38 = frac(_38);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _61 = _38.zyx + 31.31999969482421875f.xxx;
    _61.x = dot(_38, _61);
    _38 += _61.xxx;
    _38.x = _38.y + _38.x;
    _38.x = _38.z * _38.x;
    _38.x = frac(_38.x);
    _384 = (-_38.x) + _220;
    _38.x = (_42.x * _384) + _38.x;
    _384 = (-_38.x) + _111;
    _38.x = (_42.y * _384) + _38.x;
    _67 += (-_38.x);
    _67 = (_42.z * _67) + _38.x;
    _38 = floor(_9.xzw);
    float3 _428 = frac(_9.xzw);
    _9 = float4(_428.x, _9.y, _428.y, _428.z);
    float3 _432 = _38 + 1.0f.xxx;
    _42 = float4(_432.x, _432.y, _432.z, _42.w);
    float3 _437 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_437.x, _437.y, _437.z, _42.w);
    float3 _442 = frac(_42.xyz);
    _42 = float4(_442.x, _442.y, _442.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_42.xyz, _61);
    float3 _456 = _111.xxx + _42.xyz;
    _42 = float4(_456.x, _456.y, _456.z, _42.w);
    _111 = _42.y + _42.x;
    _111 = _42.z * _111;
    _111 = frac(_111);
    float3 _471 = _38 + float3(0.0f, 1.0f, 1.0f);
    _42 = float4(_471.x, _471.y, _471.z, _42.w);
    float3 _476 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_476.x, _476.y, _476.z, _42.w);
    float3 _481 = frac(_42.xyz);
    _42 = float4(_481.x, _481.y, _481.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _495 = _220.xxx + _42.xyz;
    _42 = float4(_495.x, _495.y, _495.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _42.x = frac(_42.x);
    _111 += (-_42.x);
    _519 = _9.xzw * _9.xzw;
    float3 _529 = ((-_9.xzw) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_529.x, _9.y, _529.y, _529.z);
    float3 _535 = _9.xzw * _519;
    _9 = float4(_535.x, _9.y, _535.y, _535.z);
    _111 = (_9.x * _111) + _42.x;
    float3 _546 = _38 + float3(1.0f, 0.0f, 1.0f);
    _42 = float4(_546.x, _546.y, _546.z, _42.w);
    float3 _551 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_551.x, _551.y, _551.z, _42.w);
    float3 _556 = frac(_42.xyz);
    _42 = float4(_556.x, _556.y, _556.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _570 = _220.xxx + _42.xyz;
    _42 = float4(_570.x, _570.y, _570.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _519 = _38 + float3(0.0f, 0.0f, 1.0f);
    float3 _588 = _519 * 0.103100001811981201171875f.xxx;
    _42 = float4(_42.x, _588.x, _588.y, _588.z);
    _42 = frac(_42);
    _61 = _42.wzy + 31.31999969482421875f.xxx;
    _61.x = dot(_42.yzw, _61);
    _519 = _42.yzw + _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _42.x = (-_519.x) + _42.x;
    _42.x = (_9.x * _42.x) + _519.x;
    _111 += (-_42.x);
    _111 = (_9.z * _111) + _42.x;
    float3 _651 = _38 + float3(1.0f, 1.0f, 0.0f);
    _42 = float4(_651.x, _651.y, _651.z, _42.w);
    float3 _656 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_656.x, _656.y, _656.z, _42.w);
    float3 _661 = frac(_42.xyz);
    _42 = float4(_661.x, _661.y, _661.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _675 = _220.xxx + _42.xyz;
    _42 = float4(_675.x, _675.y, _675.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _519 = _38 + float3(0.0f, 1.0f, 0.0f);
    float3 _693 = _519 * 0.103100001811981201171875f.xxx;
    _42 = float4(_42.x, _693.x, _693.y, _693.z);
    _42 = frac(_42);
    _61 = _42.wzy + 31.31999969482421875f.xxx;
    _61.x = dot(_42.yzw, _61);
    _519 = _42.yzw + _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _42.x = (-_519.x) + _42.x;
    _42.x = (_9.x * _42.x) + _519.x;
    _519 = _38 + float3(1.0f, 0.0f, 0.0f);
    _38 *= 0.103100001811981201171875f.xxx;
    _38 = frac(_38);
    _519 *= 0.103100001811981201171875f.xxx;
    _519 = frac(_519);
    _61 = _519.zyx + 31.31999969482421875f.xxx;
    _61.x = dot(_519, _61);
    _519 += _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _61 = _38.zyx + 31.31999969482421875f.xxx;
    _783 = dot(_38, _61);
    _38 += _783.xxx;
    _38.x = _38.y + _38.x;
    _38.x = _38.z * _38.x;
    _38.x = frac(_38.x);
    _384 = (-_38.x) + _519.x;
    _9.x = (_9.x * _384) + _38.x;
    _38.x = (-_9.x) + _42.x;
    _9.x = (_9.z * _38.x) + _9.x;
    _837 = (-_9.x) + _111;
    _9.x = (_9.w * _837) + _9.x;
    _9.x *= 0.2800000011920928955078125f;
    _9.x = (_67 * 0.7200000286102294921875f) + _9.x;
    _9.x += (-0.37999999523162841796875f);
    _9.x *= 1.92307698726654052734375f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _67 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _67;
    _893.x = _9.x * _16_m10;
    _901 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _918 = _901 * vs_TEXCOORD3.xyz;
    _9 = float4(_918.x, _918.y, _918.z, _9.w);
    _921 = (_16_m9.xyz * vs_TEXCOORD3.xyz) + (-_9.xyz);
    _921 = (_893.xxx * _921) + _9.xyz;
    _893.x = ((-_893.x) * 0.85000002384185791015625f) + 1.0f;
    float3 _954 = (-vs_TEXCOORD1) + _16_m0;
    _9 = float4(_954.x, _954.y, _954.z, _9.w);
    _957 = dot(_9.xyz, _9.xyz);
    _957 = rsqrt(_957);
    float3 _969 = _957.xxx * _9.xyz;
    _9 = float4(_969.x, _969.y, _969.z, _9.w);
    _957 = dot(_16_m2.xyz, _16_m2.xyz);
    _957 = rsqrt(_957);
    float3 _991 = (_16_m2.xyz * _957.xxx) + _9.xyz;
    _982 = float4(_991.x, _991.y, _991.z, _982.w);
    _38 = _957.xxx * _16_m2.xyz;
    _1000 = dot(_982.xyz, _982.xyz);
    _1000 = rsqrt(_1000);
    float3 _1012 = _1000.xxx * _982.xyz;
    _982 = float4(_1012.x, _1012.y, _1012.z, _982.w);
    _1000 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _1000 = rsqrt(_1000);
    _1021 = _1000.xxx * vs_TEXCOORD2;
    _982.x = dot(_1021, _982.xyz);
    _982.x = clamp(_982.x, 0.0f, 1.0f);
    _982.x = log2(_982.x);
    _982.x *= _16_m6;
    _982.x = exp2(_982.x);
    _1050 = dot(_1021, _38);
    _1054 = dot(_1021, _9.xyz);
    _1054 = clamp(_1054, 0.0f, 1.0f);
    _1054 = (-_1054) + 1.0f;
    _1054 = log2(_1054);
    _1054 *= _16_m8;
    _1054 = exp2(_1054);
    _1054 *= _16_m7.w;
    _1021 = _1054.xxx * _16_m7.xyz;
    _1084.x = _1050 * 4.0f;
    _1084.x = _1084.x;
    _1084.x = clamp(_1084.x, 0.0f, 1.0f);
    _982.x *= _1084.x;
    _893.x *= _982.x;
    float3 _1116 = _16_m3.xyz * _16_m5.xyz;
    _982 = float4(_1116.x, _982.y, _1116.y, _1116.z);
    float3 _1123 = _893.xxx * _982.xzw;
    _982 = float4(_1123.x, _982.y, _1123.y, _1123.z);
    _893.x = (_1050 * 0.5f) + 0.5f;
    _1050 = _1050;
    _1050 = clamp(_1050, 0.0f, 1.0f);
    _893.x = (_893.x * _893.x) + (-_1050);
    _893.x = (_16_m4 * _893.x) + _1050;
    _1084 = (_16_m3.xyz * _893.xxx) + vs_TEXCOORD5;
    _893 = (_921 * _1084) + _982.xzw;
    float3 _1173 = (vs_TEXCOORD5 * 0.64999997615814208984375f.xxx) + 0.3499999940395355224609375f.xxx;
    _982 = float4(_1173.x, _1173.y, _1173.z, _982.w);
    _893 = (_1021 * _982.xyz) + _893;
    _893 += vs_TEXCOORD4;
    float3 _1192 = _893 + (-_16_m1.xyz);
    _9 = float4(_1192.x, _1192.y, _1192.z, _9.w);
    _957 = vs_TEXCOORD6;
    _957 = clamp(_957, 0.0f, 1.0f);
    float3 _1208 = (_957.xxx * _9.xyz) + _16_m1.xyz;
    _9 = float4(_1208.x, _1208.y, _1208.z, _9.w);
    _1212 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1212.w);
    _1212.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1212 = _1212;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(_GRIME)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4x4 unity_MatrixVP;
static float4 _21_m10[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _SkyColor;
float4 _GroundColor;
float _ProbeBlend;
float _VertexColorAmount;
float4 _Color;
float4 _EmissionColor;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m11 unity_FogParams
#define _21_m12 _MainTex_ST
#define _21_m13 _SkyColor
#define _21_m14 _GroundColor
#define _21_m15 _ProbeBlend
#define _21_m16 _VertexColorAmount
#define _21_m17 _Color
#define _21_m18 _EmissionColor



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float2 _141;
static float3 _153;
static float3 vs_TEXCOORD2;
static float4 _192;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _153 : NORMAL;
    float2 _141 : TEXCOORD0;
    float4 _192 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _173;
static float4 _191;
static float3 _217;
static float3 _239;
static float _267;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m10[1];
    _9 = (_21_m10[0] * _45.xxxx) + _9;
    _9 = (_21_m10[2] * _45.zzzz) + _9;
    _9 = (_21_m10[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD6 = (_9.x * _21_m11.z) + _21_m11.w;
    vs_TEXCOORD0 = (_141 * _21_m12.xy) + _21_m12.zw;
    _9.x = dot(_153, _21_m9[0].xyz);
    _9.y = dot(_153, _21_m9[1].xyz);
    _9.z = dot(_153, _21_m9[2].xyz);
    _173 = dot(_9.xyz, _9.xyz);
    _173 = rsqrt(_173);
    float3 _185 = _173.xxx * _9.xyz;
    _9 = float4(_185.x, _185.y, _185.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _191 = _192 + (-1.0f).xxxx;
    _191 = (_21_m16.xxxx * _191) + 1.0f.xxxx;
    vs_TEXCOORD3 = _191 * _21_m17;
    vs_TEXCOORD4 = _21_m18.xyz;
    _217.x = _9.y * _9.y;
    _217.x = (_9.x * _9.x) + (-_217.x);
    _191 = _9.yzzx * _9.xyzz;
    _239.x = dot(_21_m4, _191);
    _239.y = dot(_21_m5, _191);
    _239.z = dot(_21_m6, _191);
    _217 = (_21_m7.xyz * _217.xxx) + _239;
    _267 = (_9.y * 0.5f) + 0.5f;
    _9.w = 1.0f;
    _239.x = dot(_21_m1, _9);
    _239.y = dot(_21_m2, _9);
    _239.z = dot(_21_m3, _9);
    _217 += _239;
    _217 = max(_217, 0.0f.xxx);
    _239 = _21_m13.xyz + (-_21_m14.xyz);
    _239 = (_267.xxx * _239) + _21_m14.xyz;
    _217 += (-_239);
    vs_TEXCOORD5 = (_21_m15.xxx * _217) + _239;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _153 = stage_input._153;
    _192 = stage_input._192;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _KeyDir;
float4 _KeyColor;
float _Wrap;
float4 _SpecColor;
float _Gloss;
float4 _RimColor;
float _RimPower;
float4 _GrimeColor;
float _GrimeAmount;
float _GrimeScale;
float _GrimeStreak;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 unity_FogColor
#define _16_m2 _KeyDir
#define _16_m3 _KeyColor
#define _16_m4 _Wrap
#define _16_m5 _SpecColor
#define _16_m6 _Gloss
#define _16_m7 _RimColor
#define _16_m8 _RimPower
#define _16_m9 _GrimeColor
#define _16_m10 _GrimeAmount
#define _16_m11 _GrimeScale
#define _16_m12 _GrimeStreak


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD6;
static float4 _1212;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _1212 : SV_Target0;
};

static float4 _9;
static float3 _38;
static float4 _42;
static float3 _61;
static float _67;
static float _111;
static float3 _188;
static float _220;
static float _384;
static float3 _519;
static float _783;
static float _837;
static float3 _893;
static float3 _901;
static float3 _921;
static float _957;
static float4 _982;
static float _1000;
static float3 _1021;
static float _1050;
static float _1054;
static float3 _1084;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD1 * _16_m11.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _9.w = _9.y / _16_m12;
    _38 = floor(_9.xwz);
    float3 _46 = _38 + 1.0f.xxx;
    _42 = float4(_46.x, _46.y, _46.z, _42.w);
    float3 _53 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_53.x, _53.y, _53.z, _42.w);
    float3 _58 = frac(_42.xyz);
    _42 = float4(_58.x, _58.y, _58.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _67 = dot(_42.xyz, _61);
    float3 _76 = _67.xxx + _42.xyz;
    _42 = float4(_76.x, _76.y, _76.z, _42.w);
    _67 = _42.y + _42.x;
    _67 = _42.z * _67;
    _67 = frac(_67);
    float3 _95 = _38 + float3(0.0f, 1.0f, 1.0f);
    _42 = float4(_95.x, _95.y, _95.z, _42.w);
    float3 _100 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_100.x, _100.y, _100.z, _42.w);
    float3 _105 = frac(_42.xyz);
    _42 = float4(_105.x, _105.y, _105.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_42.xyz, _61);
    float3 _120 = _111.xxx + _42.xyz;
    _42 = float4(_120.x, _120.y, _120.z, _42.w);
    _111 = _42.y + _42.x;
    _111 = _42.z * _111;
    _111 = frac(_111);
    _67 += (-_111);
    float3 _140 = frac(_9.xwz);
    _42 = float4(_140.x, _140.y, _140.z, _42.w);
    float3 _150 = (_9.xwz * 3.099999904632568359375f.xxx) + 11.69999980926513671875f.xxx;
    _9 = float4(_150.x, _9.y, _150.y, _150.z);
    _61 = _42.xyz * _42.xyz;
    float3 _166 = ((-_42.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _42 = float4(_166.x, _166.y, _166.z, _42.w);
    float3 _172 = _42.xyz * _61;
    _42 = float4(_172.x, _172.y, _172.z, _42.w);
    _67 = (_42.x * _67) + _111;
    _61 = _38 + float3(1.0f, 0.0f, 1.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_61, _188);
    _61 = _111.xxx + _61;
    _111 = _61.y + _61.x;
    _111 = _61.z * _111;
    _111 = frac(_111);
    _61 = _38 + float3(0.0f, 0.0f, 1.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _111 += (-_220);
    _111 = (_42.x * _111) + _220;
    _67 += (-_111);
    _67 = (_42.y * _67) + _111;
    _61 = _38 + float3(1.0f, 1.0f, 0.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_61, _188);
    _61 = _111.xxx + _61;
    _111 = _61.y + _61.x;
    _111 = _61.z * _111;
    _111 = frac(_111);
    _61 = _38 + float3(0.0f, 1.0f, 0.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _111 += (-_220);
    _111 = (_42.x * _111) + _220;
    _61 = _38 + float3(1.0f, 0.0f, 0.0f);
    _38 *= 0.103100001811981201171875f.xxx;
    _38 = frac(_38);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _61 = _38.zyx + 31.31999969482421875f.xxx;
    _61.x = dot(_38, _61);
    _38 += _61.xxx;
    _38.x = _38.y + _38.x;
    _38.x = _38.z * _38.x;
    _38.x = frac(_38.x);
    _384 = (-_38.x) + _220;
    _38.x = (_42.x * _384) + _38.x;
    _384 = (-_38.x) + _111;
    _38.x = (_42.y * _384) + _38.x;
    _67 += (-_38.x);
    _67 = (_42.z * _67) + _38.x;
    _38 = floor(_9.xzw);
    float3 _428 = frac(_9.xzw);
    _9 = float4(_428.x, _9.y, _428.y, _428.z);
    float3 _432 = _38 + 1.0f.xxx;
    _42 = float4(_432.x, _432.y, _432.z, _42.w);
    float3 _437 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_437.x, _437.y, _437.z, _42.w);
    float3 _442 = frac(_42.xyz);
    _42 = float4(_442.x, _442.y, _442.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_42.xyz, _61);
    float3 _456 = _111.xxx + _42.xyz;
    _42 = float4(_456.x, _456.y, _456.z, _42.w);
    _111 = _42.y + _42.x;
    _111 = _42.z * _111;
    _111 = frac(_111);
    float3 _471 = _38 + float3(0.0f, 1.0f, 1.0f);
    _42 = float4(_471.x, _471.y, _471.z, _42.w);
    float3 _476 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_476.x, _476.y, _476.z, _42.w);
    float3 _481 = frac(_42.xyz);
    _42 = float4(_481.x, _481.y, _481.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _495 = _220.xxx + _42.xyz;
    _42 = float4(_495.x, _495.y, _495.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _42.x = frac(_42.x);
    _111 += (-_42.x);
    _519 = _9.xzw * _9.xzw;
    float3 _529 = ((-_9.xzw) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_529.x, _9.y, _529.y, _529.z);
    float3 _535 = _9.xzw * _519;
    _9 = float4(_535.x, _9.y, _535.y, _535.z);
    _111 = (_9.x * _111) + _42.x;
    float3 _546 = _38 + float3(1.0f, 0.0f, 1.0f);
    _42 = float4(_546.x, _546.y, _546.z, _42.w);
    float3 _551 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_551.x, _551.y, _551.z, _42.w);
    float3 _556 = frac(_42.xyz);
    _42 = float4(_556.x, _556.y, _556.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _570 = _220.xxx + _42.xyz;
    _42 = float4(_570.x, _570.y, _570.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _519 = _38 + float3(0.0f, 0.0f, 1.0f);
    float3 _588 = _519 * 0.103100001811981201171875f.xxx;
    _42 = float4(_42.x, _588.x, _588.y, _588.z);
    _42 = frac(_42);
    _61 = _42.wzy + 31.31999969482421875f.xxx;
    _61.x = dot(_42.yzw, _61);
    _519 = _42.yzw + _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _42.x = (-_519.x) + _42.x;
    _42.x = (_9.x * _42.x) + _519.x;
    _111 += (-_42.x);
    _111 = (_9.z * _111) + _42.x;
    float3 _651 = _38 + float3(1.0f, 1.0f, 0.0f);
    _42 = float4(_651.x, _651.y, _651.z, _42.w);
    float3 _656 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_656.x, _656.y, _656.z, _42.w);
    float3 _661 = frac(_42.xyz);
    _42 = float4(_661.x, _661.y, _661.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _675 = _220.xxx + _42.xyz;
    _42 = float4(_675.x, _675.y, _675.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _519 = _38 + float3(0.0f, 1.0f, 0.0f);
    float3 _693 = _519 * 0.103100001811981201171875f.xxx;
    _42 = float4(_42.x, _693.x, _693.y, _693.z);
    _42 = frac(_42);
    _61 = _42.wzy + 31.31999969482421875f.xxx;
    _61.x = dot(_42.yzw, _61);
    _519 = _42.yzw + _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _42.x = (-_519.x) + _42.x;
    _42.x = (_9.x * _42.x) + _519.x;
    _519 = _38 + float3(1.0f, 0.0f, 0.0f);
    _38 *= 0.103100001811981201171875f.xxx;
    _38 = frac(_38);
    _519 *= 0.103100001811981201171875f.xxx;
    _519 = frac(_519);
    _61 = _519.zyx + 31.31999969482421875f.xxx;
    _61.x = dot(_519, _61);
    _519 += _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _61 = _38.zyx + 31.31999969482421875f.xxx;
    _783 = dot(_38, _61);
    _38 += _783.xxx;
    _38.x = _38.y + _38.x;
    _38.x = _38.z * _38.x;
    _38.x = frac(_38.x);
    _384 = (-_38.x) + _519.x;
    _9.x = (_9.x * _384) + _38.x;
    _38.x = (-_9.x) + _42.x;
    _9.x = (_9.z * _38.x) + _9.x;
    _837 = (-_9.x) + _111;
    _9.x = (_9.w * _837) + _9.x;
    _9.x *= 0.2800000011920928955078125f;
    _9.x = (_67 * 0.7200000286102294921875f) + _9.x;
    _9.x += (-0.37999999523162841796875f);
    _9.x *= 1.92307698726654052734375f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _67 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _67;
    _893.x = _9.x * _16_m10;
    _901 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _918 = _901 * vs_TEXCOORD3.xyz;
    _9 = float4(_918.x, _918.y, _918.z, _9.w);
    _921 = (_16_m9.xyz * vs_TEXCOORD3.xyz) + (-_9.xyz);
    _921 = (_893.xxx * _921) + _9.xyz;
    _893.x = ((-_893.x) * 0.85000002384185791015625f) + 1.0f;
    float3 _954 = (-vs_TEXCOORD1) + _16_m0;
    _9 = float4(_954.x, _954.y, _954.z, _9.w);
    _957 = dot(_9.xyz, _9.xyz);
    _957 = rsqrt(_957);
    float3 _969 = _957.xxx * _9.xyz;
    _9 = float4(_969.x, _969.y, _969.z, _9.w);
    _957 = dot(_16_m2.xyz, _16_m2.xyz);
    _957 = rsqrt(_957);
    float3 _991 = (_16_m2.xyz * _957.xxx) + _9.xyz;
    _982 = float4(_991.x, _991.y, _991.z, _982.w);
    _38 = _957.xxx * _16_m2.xyz;
    _1000 = dot(_982.xyz, _982.xyz);
    _1000 = rsqrt(_1000);
    float3 _1012 = _1000.xxx * _982.xyz;
    _982 = float4(_1012.x, _1012.y, _1012.z, _982.w);
    _1000 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _1000 = rsqrt(_1000);
    _1021 = _1000.xxx * vs_TEXCOORD2;
    _982.x = dot(_1021, _982.xyz);
    _982.x = clamp(_982.x, 0.0f, 1.0f);
    _982.x = log2(_982.x);
    _982.x *= _16_m6;
    _982.x = exp2(_982.x);
    _1050 = dot(_1021, _38);
    _1054 = dot(_1021, _9.xyz);
    _1054 = clamp(_1054, 0.0f, 1.0f);
    _1054 = (-_1054) + 1.0f;
    _1054 = log2(_1054);
    _1054 *= _16_m8;
    _1054 = exp2(_1054);
    _1054 *= _16_m7.w;
    _1021 = _1054.xxx * _16_m7.xyz;
    _1084.x = _1050 * 4.0f;
    _1084.x = _1084.x;
    _1084.x = clamp(_1084.x, 0.0f, 1.0f);
    _982.x *= _1084.x;
    _893.x *= _982.x;
    float3 _1116 = _16_m3.xyz * _16_m5.xyz;
    _982 = float4(_1116.x, _982.y, _1116.y, _1116.z);
    float3 _1123 = _893.xxx * _982.xzw;
    _982 = float4(_1123.x, _982.y, _1123.y, _1123.z);
    _893.x = (_1050 * 0.5f) + 0.5f;
    _1050 = _1050;
    _1050 = clamp(_1050, 0.0f, 1.0f);
    _893.x = (_893.x * _893.x) + (-_1050);
    _893.x = (_16_m4 * _893.x) + _1050;
    _1084 = (_16_m3.xyz * _893.xxx) + vs_TEXCOORD5;
    _893 = (_921 * _1084) + _982.xzw;
    float3 _1173 = (vs_TEXCOORD5 * 0.64999997615814208984375f.xxx) + 0.3499999940395355224609375f.xxx;
    _982 = float4(_1173.x, _1173.y, _1173.z, _982.w);
    _893 = (_1021 * _982.xyz) + _893;
    _893 += vs_TEXCOORD4;
    float3 _1192 = _893 + (-_16_m1.xyz);
    _9 = float4(_1192.x, _1192.y, _1192.z, _9.w);
    _957 = vs_TEXCOORD6;
    _957 = clamp(_957, 0.0f, 1.0f);
    float3 _1208 = (_957.xxx * _9.xyz) + _16_m1.xyz;
    _9 = float4(_1208.x, _1208.y, _1208.z, _9.w);
    _1212 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1212.w);
    _1212.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1212 = _1212;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4x4 unity_MatrixVP;
static float4 _21_m10[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _SkyColor;
float4 _GroundColor;
float _ProbeBlend;
float _VertexColorAmount;
float4 _Color;
float4 _EmissionColor;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m11 unity_FogParams
#define _21_m12 _MainTex_ST
#define _21_m13 _SkyColor
#define _21_m14 _GroundColor
#define _21_m15 _ProbeBlend
#define _21_m16 _VertexColorAmount
#define _21_m17 _Color
#define _21_m18 _EmissionColor



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float2 _142;
static float3 _154;
static float3 vs_TEXCOORD2;
static float4 _193;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _154 : NORMAL;
    float2 _142 : TEXCOORD0;
    float4 _193 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _174;
static float4 _192;
static float3 _218;
static float3 _240;
static float _268;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m10[1];
    _9 = (_21_m10[0] * _45.xxxx) + _9;
    _9 = (_21_m10[2] * _45.zzzz) + _9;
    _9 = (_21_m10[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m11.y;
    vs_TEXCOORD6 = exp2(-_9.x);
    vs_TEXCOORD0 = (_142 * _21_m12.xy) + _21_m12.zw;
    _9.x = dot(_154, _21_m9[0].xyz);
    _9.y = dot(_154, _21_m9[1].xyz);
    _9.z = dot(_154, _21_m9[2].xyz);
    _174 = dot(_9.xyz, _9.xyz);
    _174 = rsqrt(_174);
    float3 _186 = _174.xxx * _9.xyz;
    _9 = float4(_186.x, _186.y, _186.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _192 = _193 + (-1.0f).xxxx;
    _192 = (_21_m16.xxxx * _192) + 1.0f.xxxx;
    vs_TEXCOORD3 = _192 * _21_m17;
    vs_TEXCOORD4 = _21_m18.xyz;
    _218.x = _9.y * _9.y;
    _218.x = (_9.x * _9.x) + (-_218.x);
    _192 = _9.yzzx * _9.xyzz;
    _240.x = dot(_21_m4, _192);
    _240.y = dot(_21_m5, _192);
    _240.z = dot(_21_m6, _192);
    _218 = (_21_m7.xyz * _218.xxx) + _240;
    _268 = (_9.y * 0.5f) + 0.5f;
    _9.w = 1.0f;
    _240.x = dot(_21_m1, _9);
    _240.y = dot(_21_m2, _9);
    _240.z = dot(_21_m3, _9);
    _218 += _240;
    _218 = max(_218, 0.0f.xxx);
    _240 = _21_m13.xyz + (-_21_m14.xyz);
    _240 = (_268.xxx * _240) + _21_m14.xyz;
    _218 += (-_240);
    vs_TEXCOORD5 = (_21_m15.xxx * _218) + _240;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _142 = stage_input._142;
    _154 = stage_input._154;
    _193 = stage_input._193;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _KeyDir;
float4 _KeyColor;
float _Wrap;
float4 _SpecColor;
float _Gloss;
float4 _RimColor;
float _RimPower;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 unity_FogColor
#define _17_m2 _KeyDir
#define _17_m3 _KeyColor
#define _17_m4 _Wrap
#define _17_m5 _SpecColor
#define _17_m6 _Gloss
#define _17_m7 _RimColor
#define _17_m8 _RimPower


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD6;
static float4 _287;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _287 : SV_Target0;
};

static float3 _9;
static float _25;
static float4 _47;
static float3 _58;
static float _65;
static float3 _86;
static float _120;
static float _124;
static float3 _154;
static float3 _187;
static float _205;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _9 = _25.xxx * _9;
    _25 = dot(_17_m2.xyz, _17_m2.xyz);
    _25 = rsqrt(_25);
    float3 _55 = (_17_m2.xyz * _25.xxx) + _9;
    _47 = float4(_55.x, _55.y, _55.z, _47.w);
    _58 = _25.xxx * _17_m2.xyz;
    _65 = dot(_47.xyz, _47.xyz);
    _65 = rsqrt(_65);
    float3 _77 = _65.xxx * _47.xyz;
    _47 = float4(_77.x, _77.y, _77.z, _47.w);
    _65 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _65 = rsqrt(_65);
    _86 = _65.xxx * vs_TEXCOORD2;
    _47.x = dot(_86, _47.xyz);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _47.x = log2(_47.x);
    _47.x *= _17_m6;
    _47.x = exp2(_47.x);
    _120 = dot(_86, _58);
    _124 = dot(_86, _9);
    _124 = clamp(_124, 0.0f, 1.0f);
    _124 = (-_124) + 1.0f;
    _124 = log2(_124);
    _124 *= _17_m8;
    _124 = exp2(_124);
    _124 *= _17_m7.w;
    _86 = _124.xxx * _17_m7.xyz;
    _154.x = _120 * 4.0f;
    _154.x = _154.x;
    _154.x = clamp(_154.x, 0.0f, 1.0f);
    _47.x *= _154.x;
    _154 = _17_m3.xyz * _17_m5.xyz;
    float3 _184 = _47.xxx * _154;
    _47 = float4(_184.x, _47.y, _184.y, _184.z);
    _187 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _9 = _187 * vs_TEXCOORD3.xyz;
    _205 = (_120 * 0.5f) + 0.5f;
    _120 = _120;
    _120 = clamp(_120, 0.0f, 1.0f);
    _205 = (_205 * _205) + (-_120);
    _120 = (_17_m4 * _205) + _120;
    _154 = (_17_m3.xyz * _120.xxx) + vs_TEXCOORD5;
    float3 _240 = (_9 * _154) + _47.xzw;
    _47 = float4(_240.x, _240.y, _240.z, _47.w);
    _154 = (vs_TEXCOORD5 * 0.64999997615814208984375f.xxx) + 0.3499999940395355224609375f.xxx;
    float3 _255 = (_86 * _154) + _47.xyz;
    _47 = float4(_255.x, _255.y, _255.z, _47.w);
    float3 _262 = _47.xyz + vs_TEXCOORD4;
    _47 = float4(_262.x, _262.y, _262.z, _47.w);
    _9 = _47.xyz + (-_17_m1.xyz);
    _25 = vs_TEXCOORD6;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m1.xyz;
    _287 = float4(_9.x, _9.y, _9.z, _287.w);
    _287.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._287 = _287;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4x4 unity_MatrixVP;
static float4 _21_m10[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _SkyColor;
float4 _GroundColor;
float _ProbeBlend;
float _VertexColorAmount;
float4 _Color;
float4 _EmissionColor;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m11 unity_FogParams
#define _21_m12 _MainTex_ST
#define _21_m13 _SkyColor
#define _21_m14 _GroundColor
#define _21_m15 _ProbeBlend
#define _21_m16 _VertexColorAmount
#define _21_m17 _Color
#define _21_m18 _EmissionColor



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float2 _148;
static float3 _160;
static float3 vs_TEXCOORD2;
static float4 _199;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _160 : NORMAL;
    float2 _148 : TEXCOORD0;
    float4 _199 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _180;
static float4 _198;
static float3 _224;
static float3 _246;
static float _274;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m10[1];
    _9 = (_21_m10[0] * _45.xxxx) + _9;
    _9 = (_21_m10[2] * _45.zzzz) + _9;
    _9 = (_21_m10[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m11.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD6 = exp2(_9.x);
    vs_TEXCOORD0 = (_148 * _21_m12.xy) + _21_m12.zw;
    _9.x = dot(_160, _21_m9[0].xyz);
    _9.y = dot(_160, _21_m9[1].xyz);
    _9.z = dot(_160, _21_m9[2].xyz);
    _180 = dot(_9.xyz, _9.xyz);
    _180 = rsqrt(_180);
    float3 _192 = _180.xxx * _9.xyz;
    _9 = float4(_192.x, _192.y, _192.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _198 = _199 + (-1.0f).xxxx;
    _198 = (_21_m16.xxxx * _198) + 1.0f.xxxx;
    vs_TEXCOORD3 = _198 * _21_m17;
    vs_TEXCOORD4 = _21_m18.xyz;
    _224.x = _9.y * _9.y;
    _224.x = (_9.x * _9.x) + (-_224.x);
    _198 = _9.yzzx * _9.xyzz;
    _246.x = dot(_21_m4, _198);
    _246.y = dot(_21_m5, _198);
    _246.z = dot(_21_m6, _198);
    _224 = (_21_m7.xyz * _224.xxx) + _246;
    _274 = (_9.y * 0.5f) + 0.5f;
    _9.w = 1.0f;
    _246.x = dot(_21_m1, _9);
    _246.y = dot(_21_m2, _9);
    _246.z = dot(_21_m3, _9);
    _224 += _246;
    _224 = max(_224, 0.0f.xxx);
    _246 = _21_m13.xyz + (-_21_m14.xyz);
    _246 = (_274.xxx * _246) + _21_m14.xyz;
    _224 += (-_246);
    vs_TEXCOORD5 = (_21_m15.xxx * _224) + _246;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _148 = stage_input._148;
    _160 = stage_input._160;
    _199 = stage_input._199;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _KeyDir;
float4 _KeyColor;
float _Wrap;
float4 _SpecColor;
float _Gloss;
float4 _RimColor;
float _RimPower;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 unity_FogColor
#define _17_m2 _KeyDir
#define _17_m3 _KeyColor
#define _17_m4 _Wrap
#define _17_m5 _SpecColor
#define _17_m6 _Gloss
#define _17_m7 _RimColor
#define _17_m8 _RimPower


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD6;
static float4 _287;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _287 : SV_Target0;
};

static float3 _9;
static float _25;
static float4 _47;
static float3 _58;
static float _65;
static float3 _86;
static float _120;
static float _124;
static float3 _154;
static float3 _187;
static float _205;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _9 = _25.xxx * _9;
    _25 = dot(_17_m2.xyz, _17_m2.xyz);
    _25 = rsqrt(_25);
    float3 _55 = (_17_m2.xyz * _25.xxx) + _9;
    _47 = float4(_55.x, _55.y, _55.z, _47.w);
    _58 = _25.xxx * _17_m2.xyz;
    _65 = dot(_47.xyz, _47.xyz);
    _65 = rsqrt(_65);
    float3 _77 = _65.xxx * _47.xyz;
    _47 = float4(_77.x, _77.y, _77.z, _47.w);
    _65 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _65 = rsqrt(_65);
    _86 = _65.xxx * vs_TEXCOORD2;
    _47.x = dot(_86, _47.xyz);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _47.x = log2(_47.x);
    _47.x *= _17_m6;
    _47.x = exp2(_47.x);
    _120 = dot(_86, _58);
    _124 = dot(_86, _9);
    _124 = clamp(_124, 0.0f, 1.0f);
    _124 = (-_124) + 1.0f;
    _124 = log2(_124);
    _124 *= _17_m8;
    _124 = exp2(_124);
    _124 *= _17_m7.w;
    _86 = _124.xxx * _17_m7.xyz;
    _154.x = _120 * 4.0f;
    _154.x = _154.x;
    _154.x = clamp(_154.x, 0.0f, 1.0f);
    _47.x *= _154.x;
    _154 = _17_m3.xyz * _17_m5.xyz;
    float3 _184 = _47.xxx * _154;
    _47 = float4(_184.x, _47.y, _184.y, _184.z);
    _187 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _9 = _187 * vs_TEXCOORD3.xyz;
    _205 = (_120 * 0.5f) + 0.5f;
    _120 = _120;
    _120 = clamp(_120, 0.0f, 1.0f);
    _205 = (_205 * _205) + (-_120);
    _120 = (_17_m4 * _205) + _120;
    _154 = (_17_m3.xyz * _120.xxx) + vs_TEXCOORD5;
    float3 _240 = (_9 * _154) + _47.xzw;
    _47 = float4(_240.x, _240.y, _240.z, _47.w);
    _154 = (vs_TEXCOORD5 * 0.64999997615814208984375f.xxx) + 0.3499999940395355224609375f.xxx;
    float3 _255 = (_86 * _154) + _47.xyz;
    _47 = float4(_255.x, _255.y, _255.z, _47.w);
    float3 _262 = _47.xyz + vs_TEXCOORD4;
    _47 = float4(_262.x, _262.y, _262.z, _47.w);
    _9 = _47.xyz + (-_17_m1.xyz);
    _25 = vs_TEXCOORD6;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m1.xyz;
    _287 = float4(_9.x, _9.y, _9.z, _287.w);
    _287.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._287 = _287;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4x4 unity_MatrixVP;
static float4 _21_m10[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _SkyColor;
float4 _GroundColor;
float _ProbeBlend;
float _VertexColorAmount;
float4 _Color;
float4 _EmissionColor;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m11 unity_FogParams
#define _21_m12 _MainTex_ST
#define _21_m13 _SkyColor
#define _21_m14 _GroundColor
#define _21_m15 _ProbeBlend
#define _21_m16 _VertexColorAmount
#define _21_m17 _Color
#define _21_m18 _EmissionColor



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float2 _141;
static float3 _153;
static float3 vs_TEXCOORD2;
static float4 _192;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _153 : NORMAL;
    float2 _141 : TEXCOORD0;
    float4 _192 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _173;
static float4 _191;
static float3 _217;
static float3 _239;
static float _267;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD1 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m10[1];
    _9 = (_21_m10[0] * _45.xxxx) + _9;
    _9 = (_21_m10[2] * _45.zzzz) + _9;
    _9 = (_21_m10[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD6 = (_9.x * _21_m11.z) + _21_m11.w;
    vs_TEXCOORD0 = (_141 * _21_m12.xy) + _21_m12.zw;
    _9.x = dot(_153, _21_m9[0].xyz);
    _9.y = dot(_153, _21_m9[1].xyz);
    _9.z = dot(_153, _21_m9[2].xyz);
    _173 = dot(_9.xyz, _9.xyz);
    _173 = rsqrt(_173);
    float3 _185 = _173.xxx * _9.xyz;
    _9 = float4(_185.x, _185.y, _185.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _191 = _192 + (-1.0f).xxxx;
    _191 = (_21_m16.xxxx * _191) + 1.0f.xxxx;
    vs_TEXCOORD3 = _191 * _21_m17;
    vs_TEXCOORD4 = _21_m18.xyz;
    _217.x = _9.y * _9.y;
    _217.x = (_9.x * _9.x) + (-_217.x);
    _191 = _9.yzzx * _9.xyzz;
    _239.x = dot(_21_m4, _191);
    _239.y = dot(_21_m5, _191);
    _239.z = dot(_21_m6, _191);
    _217 = (_21_m7.xyz * _217.xxx) + _239;
    _267 = (_9.y * 0.5f) + 0.5f;
    _9.w = 1.0f;
    _239.x = dot(_21_m1, _9);
    _239.y = dot(_21_m2, _9);
    _239.z = dot(_21_m3, _9);
    _217 += _239;
    _217 = max(_217, 0.0f.xxx);
    _239 = _21_m13.xyz + (-_21_m14.xyz);
    _239 = (_267.xxx * _239) + _21_m14.xyz;
    _217 += (-_239);
    vs_TEXCOORD5 = (_21_m15.xxx * _217) + _239;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _153 = stage_input._153;
    _192 = stage_input._192;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _KeyDir;
float4 _KeyColor;
float _Wrap;
float4 _SpecColor;
float _Gloss;
float4 _RimColor;
float _RimPower;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 unity_FogColor
#define _17_m2 _KeyDir
#define _17_m3 _KeyColor
#define _17_m4 _Wrap
#define _17_m5 _SpecColor
#define _17_m6 _Gloss
#define _17_m7 _RimColor
#define _17_m8 _RimPower


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD6;
static float4 _287;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _287 : SV_Target0;
};

static float3 _9;
static float _25;
static float4 _47;
static float3 _58;
static float _65;
static float3 _86;
static float _120;
static float _124;
static float3 _154;
static float3 _187;
static float _205;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _9 = _25.xxx * _9;
    _25 = dot(_17_m2.xyz, _17_m2.xyz);
    _25 = rsqrt(_25);
    float3 _55 = (_17_m2.xyz * _25.xxx) + _9;
    _47 = float4(_55.x, _55.y, _55.z, _47.w);
    _58 = _25.xxx * _17_m2.xyz;
    _65 = dot(_47.xyz, _47.xyz);
    _65 = rsqrt(_65);
    float3 _77 = _65.xxx * _47.xyz;
    _47 = float4(_77.x, _77.y, _77.z, _47.w);
    _65 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _65 = rsqrt(_65);
    _86 = _65.xxx * vs_TEXCOORD2;
    _47.x = dot(_86, _47.xyz);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _47.x = log2(_47.x);
    _47.x *= _17_m6;
    _47.x = exp2(_47.x);
    _120 = dot(_86, _58);
    _124 = dot(_86, _9);
    _124 = clamp(_124, 0.0f, 1.0f);
    _124 = (-_124) + 1.0f;
    _124 = log2(_124);
    _124 *= _17_m8;
    _124 = exp2(_124);
    _124 *= _17_m7.w;
    _86 = _124.xxx * _17_m7.xyz;
    _154.x = _120 * 4.0f;
    _154.x = _154.x;
    _154.x = clamp(_154.x, 0.0f, 1.0f);
    _47.x *= _154.x;
    _154 = _17_m3.xyz * _17_m5.xyz;
    float3 _184 = _47.xxx * _154;
    _47 = float4(_184.x, _47.y, _184.y, _184.z);
    _187 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _9 = _187 * vs_TEXCOORD3.xyz;
    _205 = (_120 * 0.5f) + 0.5f;
    _120 = _120;
    _120 = clamp(_120, 0.0f, 1.0f);
    _205 = (_205 * _205) + (-_120);
    _120 = (_17_m4 * _205) + _120;
    _154 = (_17_m3.xyz * _120.xxx) + vs_TEXCOORD5;
    float3 _240 = (_9 * _154) + _47.xzw;
    _47 = float4(_240.x, _240.y, _240.z, _47.w);
    _154 = (vs_TEXCOORD5 * 0.64999997615814208984375f.xxx) + 0.3499999940395355224609375f.xxx;
    float3 _255 = (_86 * _154) + _47.xyz;
    _47 = float4(_255.x, _255.y, _255.z, _47.w);
    float3 _262 = _47.xyz + vs_TEXCOORD4;
    _47 = float4(_262.x, _262.y, _262.z, _47.w);
    _9 = _47.xyz + (-_17_m1.xyz);
    _25 = vs_TEXCOORD6;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m1.xyz;
    _287 = float4(_9.x, _9.y, _9.z, _287.w);
    _287.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._287 = _287;
    return stage_output;
}

#endif
#elif defined(_GRIME)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m7[4];
float4x4 unity_WorldToObject;
static float4 _21_m8[4];
float4x4 unity_MatrixVP;
static float4 _21_m9[4];
float4 _MainTex_ST;
float4 _SkyColor;
float4 _GroundColor;
float _ProbeBlend;
float _VertexColorAmount;
float4 _Color;
float4 _EmissionColor;
void __unity_init()
{
    _21_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m8[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m8[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m8[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m8[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m9[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m9[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m9[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m9[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHAr
#define _21_m1 unity_SHAg
#define _21_m2 unity_SHAb
#define _21_m3 unity_SHBr
#define _21_m4 unity_SHBg
#define _21_m5 unity_SHBb
#define _21_m6 unity_SHC
#define _21_m10 _MainTex_ST
#define _21_m11 _SkyColor
#define _21_m12 _GroundColor
#define _21_m13 _ProbeBlend
#define _21_m14 _VertexColorAmount
#define _21_m15 _Color
#define _21_m16 _EmissionColor



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _101;
static float3 _113;
static float3 vs_TEXCOORD2;
static float4 _155;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _113 : NORMAL;
    float2 _101 : TEXCOORD0;
    float4 _155 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _136;
static float4 _154;
static float3 _182;
static float3 _204;
static float _231;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _11.xxxx) + _9;
    _9 = (_21_m7[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m7[3];
    vs_TEXCOORD1 = (_21_m7[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m9[1];
    _9 = (_21_m9[0] * _45.xxxx) + _9;
    _9 = (_21_m9[2] * _45.zzzz) + _9;
    gl_Position = (_21_m9[3] * _45.wwww) + _9;
    vs_TEXCOORD0 = (_101 * _21_m10.xy) + _21_m10.zw;
    _9.x = dot(_113, _21_m8[0].xyz);
    _9.y = dot(_113, _21_m8[1].xyz);
    _9.z = dot(_113, _21_m8[2].xyz);
    _136 = dot(_9.xyz, _9.xyz);
    _136 = rsqrt(_136);
    float3 _148 = _136.xxx * _9.xyz;
    _9 = float4(_148.x, _148.y, _148.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _154 = _155 + (-1.0f).xxxx;
    _154 = (_21_m14.xxxx * _154) + 1.0f.xxxx;
    vs_TEXCOORD3 = _154 * _21_m15;
    vs_TEXCOORD4 = _21_m16.xyz;
    _182.x = _9.y * _9.y;
    _182.x = (_9.x * _9.x) + (-_182.x);
    _154 = _9.yzzx * _9.xyzz;
    _204.x = dot(_21_m3, _154);
    _204.y = dot(_21_m4, _154);
    _204.z = dot(_21_m5, _154);
    _182 = (_21_m6.xyz * _182.xxx) + _204;
    _231 = (_9.y * 0.5f) + 0.5f;
    _9.w = 1.0f;
    _204.x = dot(_21_m0, _9);
    _204.y = dot(_21_m1, _9);
    _204.z = dot(_21_m2, _9);
    _182 += _204;
    _182 = max(_182, 0.0f.xxx);
    _204 = _21_m11.xyz + (-_21_m12.xyz);
    _204 = (_231.xxx * _204) + _21_m12.xyz;
    _182 += (-_204);
    vs_TEXCOORD5 = (_21_m13.xxx * _182) + _204;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _113 = stage_input._113;
    _155 = stage_input._155;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _KeyDir;
float4 _KeyColor;
float _Wrap;
float4 _SpecColor;
float _Gloss;
float4 _RimColor;
float _RimPower;
float4 _GrimeColor;
float _GrimeAmount;
float _GrimeScale;
float _GrimeStreak;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _KeyDir
#define _16_m2 _KeyColor
#define _16_m3 _Wrap
#define _16_m4 _SpecColor
#define _16_m5 _Gloss
#define _16_m6 _RimColor
#define _16_m7 _RimPower
#define _16_m8 _GrimeColor
#define _16_m9 _GrimeAmount
#define _16_m10 _GrimeScale
#define _16_m11 _GrimeStreak


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD5;
static float4 _1183;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1183 : SV_Target0;
};

static float4 _9;
static float3 _38;
static float4 _42;
static float3 _61;
static float _67;
static float _111;
static float3 _188;
static float _220;
static float _384;
static float3 _519;
static float _783;
static float _837;
static float3 _893;
static float3 _901;
static float3 _921;
static float _957;
static float4 _982;
static float _1000;
static float3 _1021;
static float _1050;
static float _1054;
static float3 _1084;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD1 * _16_m10.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _9.w = _9.y / _16_m11;
    _38 = floor(_9.xwz);
    float3 _46 = _38 + 1.0f.xxx;
    _42 = float4(_46.x, _46.y, _46.z, _42.w);
    float3 _53 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_53.x, _53.y, _53.z, _42.w);
    float3 _58 = frac(_42.xyz);
    _42 = float4(_58.x, _58.y, _58.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _67 = dot(_42.xyz, _61);
    float3 _76 = _67.xxx + _42.xyz;
    _42 = float4(_76.x, _76.y, _76.z, _42.w);
    _67 = _42.y + _42.x;
    _67 = _42.z * _67;
    _67 = frac(_67);
    float3 _95 = _38 + float3(0.0f, 1.0f, 1.0f);
    _42 = float4(_95.x, _95.y, _95.z, _42.w);
    float3 _100 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_100.x, _100.y, _100.z, _42.w);
    float3 _105 = frac(_42.xyz);
    _42 = float4(_105.x, _105.y, _105.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_42.xyz, _61);
    float3 _120 = _111.xxx + _42.xyz;
    _42 = float4(_120.x, _120.y, _120.z, _42.w);
    _111 = _42.y + _42.x;
    _111 = _42.z * _111;
    _111 = frac(_111);
    _67 += (-_111);
    float3 _140 = frac(_9.xwz);
    _42 = float4(_140.x, _140.y, _140.z, _42.w);
    float3 _150 = (_9.xwz * 3.099999904632568359375f.xxx) + 11.69999980926513671875f.xxx;
    _9 = float4(_150.x, _9.y, _150.y, _150.z);
    _61 = _42.xyz * _42.xyz;
    float3 _166 = ((-_42.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _42 = float4(_166.x, _166.y, _166.z, _42.w);
    float3 _172 = _42.xyz * _61;
    _42 = float4(_172.x, _172.y, _172.z, _42.w);
    _67 = (_42.x * _67) + _111;
    _61 = _38 + float3(1.0f, 0.0f, 1.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_61, _188);
    _61 = _111.xxx + _61;
    _111 = _61.y + _61.x;
    _111 = _61.z * _111;
    _111 = frac(_111);
    _61 = _38 + float3(0.0f, 0.0f, 1.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _111 += (-_220);
    _111 = (_42.x * _111) + _220;
    _67 += (-_111);
    _67 = (_42.y * _67) + _111;
    _61 = _38 + float3(1.0f, 1.0f, 0.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_61, _188);
    _61 = _111.xxx + _61;
    _111 = _61.y + _61.x;
    _111 = _61.z * _111;
    _111 = frac(_111);
    _61 = _38 + float3(0.0f, 1.0f, 0.0f);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _111 += (-_220);
    _111 = (_42.x * _111) + _220;
    _61 = _38 + float3(1.0f, 0.0f, 0.0f);
    _38 *= 0.103100001811981201171875f.xxx;
    _38 = frac(_38);
    _61 *= 0.103100001811981201171875f.xxx;
    _61 = frac(_61);
    _188 = _61.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_61, _188);
    _61 = _220.xxx + _61;
    _220 = _61.y + _61.x;
    _220 = _61.z * _220;
    _220 = frac(_220);
    _61 = _38.zyx + 31.31999969482421875f.xxx;
    _61.x = dot(_38, _61);
    _38 += _61.xxx;
    _38.x = _38.y + _38.x;
    _38.x = _38.z * _38.x;
    _38.x = frac(_38.x);
    _384 = (-_38.x) + _220;
    _38.x = (_42.x * _384) + _38.x;
    _384 = (-_38.x) + _111;
    _38.x = (_42.y * _384) + _38.x;
    _67 += (-_38.x);
    _67 = (_42.z * _67) + _38.x;
    _38 = floor(_9.xzw);
    float3 _428 = frac(_9.xzw);
    _9 = float4(_428.x, _9.y, _428.y, _428.z);
    float3 _432 = _38 + 1.0f.xxx;
    _42 = float4(_432.x, _432.y, _432.z, _42.w);
    float3 _437 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_437.x, _437.y, _437.z, _42.w);
    float3 _442 = frac(_42.xyz);
    _42 = float4(_442.x, _442.y, _442.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _111 = dot(_42.xyz, _61);
    float3 _456 = _111.xxx + _42.xyz;
    _42 = float4(_456.x, _456.y, _456.z, _42.w);
    _111 = _42.y + _42.x;
    _111 = _42.z * _111;
    _111 = frac(_111);
    float3 _471 = _38 + float3(0.0f, 1.0f, 1.0f);
    _42 = float4(_471.x, _471.y, _471.z, _42.w);
    float3 _476 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_476.x, _476.y, _476.z, _42.w);
    float3 _481 = frac(_42.xyz);
    _42 = float4(_481.x, _481.y, _481.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _495 = _220.xxx + _42.xyz;
    _42 = float4(_495.x, _495.y, _495.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _42.x = frac(_42.x);
    _111 += (-_42.x);
    _519 = _9.xzw * _9.xzw;
    float3 _529 = ((-_9.xzw) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_529.x, _9.y, _529.y, _529.z);
    float3 _535 = _9.xzw * _519;
    _9 = float4(_535.x, _9.y, _535.y, _535.z);
    _111 = (_9.x * _111) + _42.x;
    float3 _546 = _38 + float3(1.0f, 0.0f, 1.0f);
    _42 = float4(_546.x, _546.y, _546.z, _42.w);
    float3 _551 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_551.x, _551.y, _551.z, _42.w);
    float3 _556 = frac(_42.xyz);
    _42 = float4(_556.x, _556.y, _556.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _570 = _220.xxx + _42.xyz;
    _42 = float4(_570.x, _570.y, _570.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _519 = _38 + float3(0.0f, 0.0f, 1.0f);
    float3 _588 = _519 * 0.103100001811981201171875f.xxx;
    _42 = float4(_42.x, _588.x, _588.y, _588.z);
    _42 = frac(_42);
    _61 = _42.wzy + 31.31999969482421875f.xxx;
    _61.x = dot(_42.yzw, _61);
    _519 = _42.yzw + _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _42.x = (-_519.x) + _42.x;
    _42.x = (_9.x * _42.x) + _519.x;
    _111 += (-_42.x);
    _111 = (_9.z * _111) + _42.x;
    float3 _651 = _38 + float3(1.0f, 1.0f, 0.0f);
    _42 = float4(_651.x, _651.y, _651.z, _42.w);
    float3 _656 = _42.xyz * 0.103100001811981201171875f.xxx;
    _42 = float4(_656.x, _656.y, _656.z, _42.w);
    float3 _661 = frac(_42.xyz);
    _42 = float4(_661.x, _661.y, _661.z, _42.w);
    _61 = _42.zyx + 31.31999969482421875f.xxx;
    _220 = dot(_42.xyz, _61);
    float3 _675 = _220.xxx + _42.xyz;
    _42 = float4(_675.x, _675.y, _675.z, _42.w);
    _42.x = _42.y + _42.x;
    _42.x = _42.z * _42.x;
    _519 = _38 + float3(0.0f, 1.0f, 0.0f);
    float3 _693 = _519 * 0.103100001811981201171875f.xxx;
    _42 = float4(_42.x, _693.x, _693.y, _693.z);
    _42 = frac(_42);
    _61 = _42.wzy + 31.31999969482421875f.xxx;
    _61.x = dot(_42.yzw, _61);
    _519 = _42.yzw + _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _42.x = (-_519.x) + _42.x;
    _42.x = (_9.x * _42.x) + _519.x;
    _519 = _38 + float3(1.0f, 0.0f, 0.0f);
    _38 *= 0.103100001811981201171875f.xxx;
    _38 = frac(_38);
    _519 *= 0.103100001811981201171875f.xxx;
    _519 = frac(_519);
    _61 = _519.zyx + 31.31999969482421875f.xxx;
    _61.x = dot(_519, _61);
    _519 += _61.xxx;
    _519.x = _519.y + _519.x;
    _519.x = _519.z * _519.x;
    _519.x = frac(_519.x);
    _61 = _38.zyx + 31.31999969482421875f.xxx;
    _783 = dot(_38, _61);
    _38 += _783.xxx;
    _38.x = _38.y + _38.x;
    _38.x = _38.z * _38.x;
    _38.x = frac(_38.x);
    _384 = (-_38.x) + _519.x;
    _9.x = (_9.x * _384) + _38.x;
    _38.x = (-_9.x) + _42.x;
    _9.x = (_9.z * _38.x) + _9.x;
    _837 = (-_9.x) + _111;
    _9.x = (_9.w * _837) + _9.x;
    _9.x *= 0.2800000011920928955078125f;
    _9.x = (_67 * 0.7200000286102294921875f) + _9.x;
    _9.x += (-0.37999999523162841796875f);
    _9.x *= 1.92307698726654052734375f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _67 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _67;
    _893.x = _9.x * _16_m9;
    _901 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _918 = _901 * vs_TEXCOORD3.xyz;
    _9 = float4(_918.x, _918.y, _918.z, _9.w);
    _921 = (_16_m8.xyz * vs_TEXCOORD3.xyz) + (-_9.xyz);
    _921 = (_893.xxx * _921) + _9.xyz;
    _893.x = ((-_893.x) * 0.85000002384185791015625f) + 1.0f;
    float3 _954 = (-vs_TEXCOORD1) + _16_m0;
    _9 = float4(_954.x, _954.y, _954.z, _9.w);
    _957 = dot(_9.xyz, _9.xyz);
    _957 = rsqrt(_957);
    float3 _969 = _957.xxx * _9.xyz;
    _9 = float4(_969.x, _969.y, _969.z, _9.w);
    _957 = dot(_16_m1.xyz, _16_m1.xyz);
    _957 = rsqrt(_957);
    float3 _991 = (_16_m1.xyz * _957.xxx) + _9.xyz;
    _982 = float4(_991.x, _991.y, _991.z, _982.w);
    _38 = _957.xxx * _16_m1.xyz;
    _1000 = dot(_982.xyz, _982.xyz);
    _1000 = rsqrt(_1000);
    float3 _1012 = _1000.xxx * _982.xyz;
    _982 = float4(_1012.x, _1012.y, _1012.z, _982.w);
    _1000 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _1000 = rsqrt(_1000);
    _1021 = _1000.xxx * vs_TEXCOORD2;
    _982.x = dot(_1021, _982.xyz);
    _982.x = clamp(_982.x, 0.0f, 1.0f);
    _982.x = log2(_982.x);
    _982.x *= _16_m5;
    _982.x = exp2(_982.x);
    _1050 = dot(_1021, _38);
    _1054 = dot(_1021, _9.xyz);
    _1054 = clamp(_1054, 0.0f, 1.0f);
    _1054 = (-_1054) + 1.0f;
    _1054 = log2(_1054);
    _1054 *= _16_m7;
    _1054 = exp2(_1054);
    _1054 *= _16_m6.w;
    _1021 = _1054.xxx * _16_m6.xyz;
    _1084.x = _1050 * 4.0f;
    _1084.x = _1084.x;
    _1084.x = clamp(_1084.x, 0.0f, 1.0f);
    _982.x *= _1084.x;
    _893.x *= _982.x;
    float3 _1116 = _16_m2.xyz * _16_m4.xyz;
    _982 = float4(_1116.x, _982.y, _1116.y, _1116.z);
    float3 _1123 = _893.xxx * _982.xzw;
    _982 = float4(_1123.x, _982.y, _1123.y, _1123.z);
    _893.x = (_1050 * 0.5f) + 0.5f;
    _1050 = _1050;
    _1050 = clamp(_1050, 0.0f, 1.0f);
    _893.x = (_893.x * _893.x) + (-_1050);
    _893.x = (_16_m3 * _893.x) + _1050;
    _1084 = (_16_m2.xyz * _893.xxx) + vs_TEXCOORD5;
    _893 = (_921 * _1084) + _982.xzw;
    float3 _1173 = (vs_TEXCOORD5 * 0.64999997615814208984375f.xxx) + 0.3499999940395355224609375f.xxx;
    _982 = float4(_1173.x, _1173.y, _1173.z, _982.w);
    _893 = (_1021 * _982.xyz) + _893;
    float3 _1187 = _893 + vs_TEXCOORD4;
    _1183 = float4(_1187.x, _1187.y, _1187.z, _1183.w);
    _1183.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1183 = _1183;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m7[4];
float4x4 unity_WorldToObject;
static float4 _21_m8[4];
float4x4 unity_MatrixVP;
static float4 _21_m9[4];
float4 _MainTex_ST;
float4 _SkyColor;
float4 _GroundColor;
float _ProbeBlend;
float _VertexColorAmount;
float4 _Color;
float4 _EmissionColor;
void __unity_init()
{
    _21_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m8[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m8[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m8[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m8[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m9[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m9[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m9[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m9[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHAr
#define _21_m1 unity_SHAg
#define _21_m2 unity_SHAb
#define _21_m3 unity_SHBr
#define _21_m4 unity_SHBg
#define _21_m5 unity_SHBb
#define _21_m6 unity_SHC
#define _21_m10 _MainTex_ST
#define _21_m11 _SkyColor
#define _21_m12 _GroundColor
#define _21_m13 _ProbeBlend
#define _21_m14 _VertexColorAmount
#define _21_m15 _Color
#define _21_m16 _EmissionColor



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _101;
static float3 _113;
static float3 vs_TEXCOORD2;
static float4 _155;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _113 : NORMAL;
    float2 _101 : TEXCOORD0;
    float4 _155 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _136;
static float4 _154;
static float3 _182;
static float3 _204;
static float _231;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _11.xxxx) + _9;
    _9 = (_21_m7[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m7[3];
    vs_TEXCOORD1 = (_21_m7[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m9[1];
    _9 = (_21_m9[0] * _45.xxxx) + _9;
    _9 = (_21_m9[2] * _45.zzzz) + _9;
    gl_Position = (_21_m9[3] * _45.wwww) + _9;
    vs_TEXCOORD0 = (_101 * _21_m10.xy) + _21_m10.zw;
    _9.x = dot(_113, _21_m8[0].xyz);
    _9.y = dot(_113, _21_m8[1].xyz);
    _9.z = dot(_113, _21_m8[2].xyz);
    _136 = dot(_9.xyz, _9.xyz);
    _136 = rsqrt(_136);
    float3 _148 = _136.xxx * _9.xyz;
    _9 = float4(_148.x, _148.y, _148.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _154 = _155 + (-1.0f).xxxx;
    _154 = (_21_m14.xxxx * _154) + 1.0f.xxxx;
    vs_TEXCOORD3 = _154 * _21_m15;
    vs_TEXCOORD4 = _21_m16.xyz;
    _182.x = _9.y * _9.y;
    _182.x = (_9.x * _9.x) + (-_182.x);
    _154 = _9.yzzx * _9.xyzz;
    _204.x = dot(_21_m3, _154);
    _204.y = dot(_21_m4, _154);
    _204.z = dot(_21_m5, _154);
    _182 = (_21_m6.xyz * _182.xxx) + _204;
    _231 = (_9.y * 0.5f) + 0.5f;
    _9.w = 1.0f;
    _204.x = dot(_21_m0, _9);
    _204.y = dot(_21_m1, _9);
    _204.z = dot(_21_m2, _9);
    _182 += _204;
    _182 = max(_182, 0.0f.xxx);
    _204 = _21_m11.xyz + (-_21_m12.xyz);
    _204 = (_231.xxx * _204) + _21_m12.xyz;
    _182 += (-_204);
    vs_TEXCOORD5 = (_21_m13.xxx * _182) + _204;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _113 = stage_input._113;
    _155 = stage_input._155;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _KeyDir;
float4 _KeyColor;
float _Wrap;
float4 _SpecColor;
float _Gloss;
float4 _RimColor;
float _RimPower;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _KeyDir
#define _17_m2 _KeyColor
#define _17_m3 _Wrap
#define _17_m4 _SpecColor
#define _17_m5 _Gloss
#define _17_m6 _RimColor
#define _17_m7 _RimPower


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD5;
static float4 _259;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _259 : SV_Target0;
};

static float3 _9;
static float _25;
static float4 _47;
static float3 _58;
static float _65;
static float3 _86;
static float _120;
static float _124;
static float3 _154;
static float3 _187;
static float _205;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _9 = _25.xxx * _9;
    _25 = dot(_17_m1.xyz, _17_m1.xyz);
    _25 = rsqrt(_25);
    float3 _55 = (_17_m1.xyz * _25.xxx) + _9;
    _47 = float4(_55.x, _55.y, _55.z, _47.w);
    _58 = _25.xxx * _17_m1.xyz;
    _65 = dot(_47.xyz, _47.xyz);
    _65 = rsqrt(_65);
    float3 _77 = _65.xxx * _47.xyz;
    _47 = float4(_77.x, _77.y, _77.z, _47.w);
    _65 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _65 = rsqrt(_65);
    _86 = _65.xxx * vs_TEXCOORD2;
    _47.x = dot(_86, _47.xyz);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _47.x = log2(_47.x);
    _47.x *= _17_m5;
    _47.x = exp2(_47.x);
    _120 = dot(_86, _58);
    _124 = dot(_86, _9);
    _124 = clamp(_124, 0.0f, 1.0f);
    _124 = (-_124) + 1.0f;
    _124 = log2(_124);
    _124 *= _17_m7;
    _124 = exp2(_124);
    _124 *= _17_m6.w;
    _86 = _124.xxx * _17_m6.xyz;
    _154.x = _120 * 4.0f;
    _154.x = _154.x;
    _154.x = clamp(_154.x, 0.0f, 1.0f);
    _47.x *= _154.x;
    _154 = _17_m2.xyz * _17_m4.xyz;
    float3 _184 = _47.xxx * _154;
    _47 = float4(_184.x, _47.y, _184.y, _184.z);
    _187 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _9 = _187 * vs_TEXCOORD3.xyz;
    _205 = (_120 * 0.5f) + 0.5f;
    _120 = _120;
    _120 = clamp(_120, 0.0f, 1.0f);
    _205 = (_205 * _205) + (-_120);
    _120 = (_17_m3 * _205) + _120;
    _154 = (_17_m2.xyz * _120.xxx) + vs_TEXCOORD5;
    float3 _240 = (_9 * _154) + _47.xzw;
    _47 = float4(_240.x, _240.y, _240.z, _47.w);
    _154 = (vs_TEXCOORD5 * 0.64999997615814208984375f.xxx) + 0.3499999940395355224609375f.xxx;
    float3 _255 = (_86 * _154) + _47.xyz;
    _47 = float4(_255.x, _255.y, _255.z, _47.w);
    float3 _264 = _47.xyz + vs_TEXCOORD4;
    _259 = float4(_264.x, _264.y, _264.z, _259.w);
    _259.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._259 = _259;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}