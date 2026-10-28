// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Fnaf/SpecimenFluid" {
Properties {

_Color ("Fluid (alpha = opacity)", Color) = (0.16,0.55,0.45,0.32)

_EdgeColor ("Edge (alpha = opacity)", Color) = (0.12,0.45,0.38,0.7)

_GlowColor ("Glow", Color) = (0.25,0.9,0.7,1)

_Glow ("Glow Level (driven at runtime)", Range(0, 2)) = 0.6000000238418579

_Bubbles ("Bubbles", Range(0, 1)) = 1.0

_BubbleSpeed ("Bubble Rise", Float) = 0.11999999731779099

_LevelY ("Level (world Y, driven at runtime)", Float) = 1000.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
 Pass {
Cull Back
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
 ZWrite Off
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
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _143;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
    float2 _140 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _162;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD3 = exp2(-_9.x);
    vs_TEXCOORD0 = _140;
    _9.x = dot(_143, _21_m2[0].xyz);
    _9.y = dot(_143, _21_m2[1].xyz);
    _9.z = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    vs_TEXCOORD2 = _162.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_FogColor;
float4 _Color;
float4 _EdgeColor;
float4 _GlowColor;
float _Bubbles;
float _BubbleSpeed;
float _Glow;
float _LevelY;
#define _21_m0 _Time
#define _21_m1 _WorldSpaceCameraPos
#define _21_m2 unity_SHAr
#define _21_m3 unity_SHAg
#define _21_m4 unity_SHAb
#define _21_m5 unity_SHBr
#define _21_m6 unity_SHBg
#define _21_m7 unity_SHBb
#define _21_m8 unity_SHC
#define _21_m9 unity_FogColor
#define _21_m10 _Color
#define _21_m11 _EdgeColor
#define _21_m12 _GlowColor
#define _21_m13 _Bubbles
#define _21_m14 _BubbleSpeed
#define _21_m15 _Glow
#define _21_m16 _LevelY



static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float4 _491;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _491 : SV_Target0;
};

static float3 _9;
static bool _33;
static float _72;
static float _85;
static float4 _95;
static float2 _104;
static float2 _121;
static bool2 _150;
static float3 _156;
static float2 _170;
static float3 _304;
static float3 _334;
static float4 _351;
static float3 _357;
static float _418;
static float3 _455;
static float4 _468;

void frag_inner()
{
    _9.x = (-vs_TEXCOORD1.y) + _21_m16;
    _33 = _9.x < 0.0f;
    if ((int(_33) * (-1)) != 0)
    {
        discard;
    }
    _9.x = vs_TEXCOORD0.x * 38.0f;
    _9.y = floor(_9.x);
    _9.x = frac(_9.x);
    float2 _69 = _9.xy + float2(-0.5f, 17.0f);
    _9 = float3(_69.x, _9.y, _69.y);
    _72 = _9.z * 127.09999847412109375f;
    _72 = sin(_72);
    _72 *= 43758.546875f;
    _72 = frac(_72);
    _85 = (_72 * 2.5f) + 2.0f;
    _72 *= 9.0f;
    _95.x = _21_m0.y * _21_m14;
    _104.x = _9.y * 127.09999847412109375f;
    _104.x = sin(_104.x);
    _104.x *= 43758.546875f;
    _104.x = frac(_104.x);
    _121.x = (_104.x * 2.5f) + 1.5f;
    _95.x = _121.x * _95.x;
    _85 = (vs_TEXCOORD0.y * _85) + (-_95.x);
    _85 = (_104.x * 13.0f) + _85;
    _150.x = _104.x >= 0.62000000476837158203125f;
    _156.y = (_85 * 6.283100128173828125f) + _72;
    _104.x = floor(_85);
    _85 = frac(_85);
    _85 += (-0.5f);
    _170.y = _85 * 4.0f;
    _121 = (_9.yy * float2(7.30000019073486328125f, 1.7000000476837158203125f)) + _104.xx;
    _156.x = (_104.x * 3.099999904632568359375f) + _9.y;
    _156.x *= 127.09999847412109375f;
    float2 _198 = sin(_156.xy);
    _156 = float3(_198.x, _198.y, _156.z);
    _156.x *= 43758.546875f;
    _156.x = frac(_156.x);
    _156.x = (_156.x * 0.14000000059604644775390625f) + 0.180000007152557373046875f;
    _104 = _121 * 127.09999847412109375f.xx;
    _104 = sin(_104);
    _104 *= 43758.546875f.xx;
    _104 = frac(_104);
    _85 = _104.x + (-0.5f);
    _150.y = _104.y >= 0.3499999940395355224609375f;
    _95.x = float(_150.x);
    _95.y = float(_150.y);
    _85 *= 0.300000011920928955078125f;
    _72 = (_156.y * 0.180000007152557373046875f) + _85;
    _9.x = (-_72) + _9.x;
    _170.x = _9.x * 1.39999997615814208984375f;
    _9.x = dot(_170, _170);
    _9.x = sqrt(_9.x);
    _9.x /= _156.x;
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _9.x = _95.x * _9.x;
    _9.x = _95.y * _9.x;
    _9.x *= _21_m13;
    _304.x = (_21_m15 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _304.x = _9.x * _304.x;
    _156.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _156.x = rsqrt(_156.x);
    float3 _331 = _156.xxx * vs_TEXCOORD2;
    _95 = float4(_331.x, _331.y, _331.z, _95.w);
    _334.x = _95.y * _95.y;
    _334.x = (_95.x * _95.x) + (-_334.x);
    _351 = _95.yzzx * _95.xyzz;
    _357.x = dot(_21_m5, _351);
    _357.y = dot(_21_m6, _351);
    _357.z = dot(_21_m7, _351);
    _334 = (_21_m8.xyz * _334.xxx) + _357;
    _95.w = 1.0f;
    _357.x = dot(_21_m2, _95);
    _357.y = dot(_21_m3, _95);
    _357.z = dot(_21_m4, _95);
    _334 += _357;
    _334 = max(_334, 0.0f.xxx);
    _156 = (-vs_TEXCOORD1) + _21_m1;
    _418 = dot(_156, _156);
    _418 = rsqrt(_418);
    _156 *= _418.xxx;
    _156.x = dot(_95.xyz, _156);
    _156.x = min(abs(_156.x), 1.0f);
    _156.x = (-_156.x) + 1.0f;
    _156.x *= _156.x;
    _357.x = (_156.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _455 = _21_m12.xyz * _21_m15.xxx;
    _357 = _357.xxx * _455;
    _468 = (-_21_m10) + _21_m11;
    _468 = (_156.xxxx * _468) + _21_m10;
    _334 = (_468.xyz * _334) + _357;
    _491.w = (_9.x * 0.4000000059604644775390625f) + _468.w;
    _491.w = clamp(_491.w, 0.0f, 1.0f);
    _304 = (_304.xxx * _21_m12.xyz) + _334;
    _9 = _304 + (-_21_m9.xyz);
    _85 = vs_TEXCOORD3;
    _85 = clamp(_85, 0.0f, 1.0f);
    _9 = (_85.xxx * _9) + _21_m9.xyz;
    _491 = float4(_9.x, _9.y, _9.z, _491.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._491 = _491;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _146;
static float3 _149;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _149 : NORMAL;
    float2 _146 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _168;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD3 = exp2(_9.x);
    vs_TEXCOORD0 = _146;
    _9.x = dot(_149, _21_m2[0].xyz);
    _9.y = dot(_149, _21_m2[1].xyz);
    _9.z = dot(_149, _21_m2[2].xyz);
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD2 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    _149 = stage_input._149;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_FogColor;
float4 _Color;
float4 _EdgeColor;
float4 _GlowColor;
float _Bubbles;
float _BubbleSpeed;
float _Glow;
float _LevelY;
#define _21_m0 _Time
#define _21_m1 _WorldSpaceCameraPos
#define _21_m2 unity_SHAr
#define _21_m3 unity_SHAg
#define _21_m4 unity_SHAb
#define _21_m5 unity_SHBr
#define _21_m6 unity_SHBg
#define _21_m7 unity_SHBb
#define _21_m8 unity_SHC
#define _21_m9 unity_FogColor
#define _21_m10 _Color
#define _21_m11 _EdgeColor
#define _21_m12 _GlowColor
#define _21_m13 _Bubbles
#define _21_m14 _BubbleSpeed
#define _21_m15 _Glow
#define _21_m16 _LevelY



static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float4 _491;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _491 : SV_Target0;
};

static float3 _9;
static bool _33;
static float _72;
static float _85;
static float4 _95;
static float2 _104;
static float2 _121;
static bool2 _150;
static float3 _156;
static float2 _170;
static float3 _304;
static float3 _334;
static float4 _351;
static float3 _357;
static float _418;
static float3 _455;
static float4 _468;

void frag_inner()
{
    _9.x = (-vs_TEXCOORD1.y) + _21_m16;
    _33 = _9.x < 0.0f;
    if ((int(_33) * (-1)) != 0)
    {
        discard;
    }
    _9.x = vs_TEXCOORD0.x * 38.0f;
    _9.y = floor(_9.x);
    _9.x = frac(_9.x);
    float2 _69 = _9.xy + float2(-0.5f, 17.0f);
    _9 = float3(_69.x, _9.y, _69.y);
    _72 = _9.z * 127.09999847412109375f;
    _72 = sin(_72);
    _72 *= 43758.546875f;
    _72 = frac(_72);
    _85 = (_72 * 2.5f) + 2.0f;
    _72 *= 9.0f;
    _95.x = _21_m0.y * _21_m14;
    _104.x = _9.y * 127.09999847412109375f;
    _104.x = sin(_104.x);
    _104.x *= 43758.546875f;
    _104.x = frac(_104.x);
    _121.x = (_104.x * 2.5f) + 1.5f;
    _95.x = _121.x * _95.x;
    _85 = (vs_TEXCOORD0.y * _85) + (-_95.x);
    _85 = (_104.x * 13.0f) + _85;
    _150.x = _104.x >= 0.62000000476837158203125f;
    _156.y = (_85 * 6.283100128173828125f) + _72;
    _104.x = floor(_85);
    _85 = frac(_85);
    _85 += (-0.5f);
    _170.y = _85 * 4.0f;
    _121 = (_9.yy * float2(7.30000019073486328125f, 1.7000000476837158203125f)) + _104.xx;
    _156.x = (_104.x * 3.099999904632568359375f) + _9.y;
    _156.x *= 127.09999847412109375f;
    float2 _198 = sin(_156.xy);
    _156 = float3(_198.x, _198.y, _156.z);
    _156.x *= 43758.546875f;
    _156.x = frac(_156.x);
    _156.x = (_156.x * 0.14000000059604644775390625f) + 0.180000007152557373046875f;
    _104 = _121 * 127.09999847412109375f.xx;
    _104 = sin(_104);
    _104 *= 43758.546875f.xx;
    _104 = frac(_104);
    _85 = _104.x + (-0.5f);
    _150.y = _104.y >= 0.3499999940395355224609375f;
    _95.x = float(_150.x);
    _95.y = float(_150.y);
    _85 *= 0.300000011920928955078125f;
    _72 = (_156.y * 0.180000007152557373046875f) + _85;
    _9.x = (-_72) + _9.x;
    _170.x = _9.x * 1.39999997615814208984375f;
    _9.x = dot(_170, _170);
    _9.x = sqrt(_9.x);
    _9.x /= _156.x;
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _9.x = _95.x * _9.x;
    _9.x = _95.y * _9.x;
    _9.x *= _21_m13;
    _304.x = (_21_m15 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _304.x = _9.x * _304.x;
    _156.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _156.x = rsqrt(_156.x);
    float3 _331 = _156.xxx * vs_TEXCOORD2;
    _95 = float4(_331.x, _331.y, _331.z, _95.w);
    _334.x = _95.y * _95.y;
    _334.x = (_95.x * _95.x) + (-_334.x);
    _351 = _95.yzzx * _95.xyzz;
    _357.x = dot(_21_m5, _351);
    _357.y = dot(_21_m6, _351);
    _357.z = dot(_21_m7, _351);
    _334 = (_21_m8.xyz * _334.xxx) + _357;
    _95.w = 1.0f;
    _357.x = dot(_21_m2, _95);
    _357.y = dot(_21_m3, _95);
    _357.z = dot(_21_m4, _95);
    _334 += _357;
    _334 = max(_334, 0.0f.xxx);
    _156 = (-vs_TEXCOORD1) + _21_m1;
    _418 = dot(_156, _156);
    _418 = rsqrt(_418);
    _156 *= _418.xxx;
    _156.x = dot(_95.xyz, _156);
    _156.x = min(abs(_156.x), 1.0f);
    _156.x = (-_156.x) + 1.0f;
    _156.x *= _156.x;
    _357.x = (_156.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _455 = _21_m12.xyz * _21_m15.xxx;
    _357 = _357.xxx * _455;
    _468 = (-_21_m10) + _21_m11;
    _468 = (_156.xxxx * _468) + _21_m10;
    _334 = (_468.xyz * _334) + _357;
    _491.w = (_9.x * 0.4000000059604644775390625f) + _468.w;
    _491.w = clamp(_491.w, 0.0f, 1.0f);
    _304 = (_304.xxx * _21_m12.xyz) + _334;
    _9 = _304 + (-_21_m9.xyz);
    _85 = vs_TEXCOORD3;
    _85 = clamp(_85, 0.0f, 1.0f);
    _9 = (_85.xxx * _9) + _21_m9.xyz;
    _491 = float4(_9.x, _9.y, _9.z, _491.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._491 = _491;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _139;
static float3 _142;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _142 : NORMAL;
    float2 _139 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _161;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD3 = (_9.x * _21_m4.z) + _21_m4.w;
    vs_TEXCOORD0 = _139;
    _9.x = dot(_142, _21_m2[0].xyz);
    _9.y = dot(_142, _21_m2[1].xyz);
    _9.z = dot(_142, _21_m2[2].xyz);
    _161 = dot(_9.xyz, _9.xyz);
    _161 = rsqrt(_161);
    vs_TEXCOORD2 = _161.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _142 = stage_input._142;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_FogColor;
float4 _Color;
float4 _EdgeColor;
float4 _GlowColor;
float _Bubbles;
float _BubbleSpeed;
float _Glow;
float _LevelY;
#define _21_m0 _Time
#define _21_m1 _WorldSpaceCameraPos
#define _21_m2 unity_SHAr
#define _21_m3 unity_SHAg
#define _21_m4 unity_SHAb
#define _21_m5 unity_SHBr
#define _21_m6 unity_SHBg
#define _21_m7 unity_SHBb
#define _21_m8 unity_SHC
#define _21_m9 unity_FogColor
#define _21_m10 _Color
#define _21_m11 _EdgeColor
#define _21_m12 _GlowColor
#define _21_m13 _Bubbles
#define _21_m14 _BubbleSpeed
#define _21_m15 _Glow
#define _21_m16 _LevelY



static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float4 _491;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _491 : SV_Target0;
};

static float3 _9;
static bool _33;
static float _72;
static float _85;
static float4 _95;
static float2 _104;
static float2 _121;
static bool2 _150;
static float3 _156;
static float2 _170;
static float3 _304;
static float3 _334;
static float4 _351;
static float3 _357;
static float _418;
static float3 _455;
static float4 _468;

void frag_inner()
{
    _9.x = (-vs_TEXCOORD1.y) + _21_m16;
    _33 = _9.x < 0.0f;
    if ((int(_33) * (-1)) != 0)
    {
        discard;
    }
    _9.x = vs_TEXCOORD0.x * 38.0f;
    _9.y = floor(_9.x);
    _9.x = frac(_9.x);
    float2 _69 = _9.xy + float2(-0.5f, 17.0f);
    _9 = float3(_69.x, _9.y, _69.y);
    _72 = _9.z * 127.09999847412109375f;
    _72 = sin(_72);
    _72 *= 43758.546875f;
    _72 = frac(_72);
    _85 = (_72 * 2.5f) + 2.0f;
    _72 *= 9.0f;
    _95.x = _21_m0.y * _21_m14;
    _104.x = _9.y * 127.09999847412109375f;
    _104.x = sin(_104.x);
    _104.x *= 43758.546875f;
    _104.x = frac(_104.x);
    _121.x = (_104.x * 2.5f) + 1.5f;
    _95.x = _121.x * _95.x;
    _85 = (vs_TEXCOORD0.y * _85) + (-_95.x);
    _85 = (_104.x * 13.0f) + _85;
    _150.x = _104.x >= 0.62000000476837158203125f;
    _156.y = (_85 * 6.283100128173828125f) + _72;
    _104.x = floor(_85);
    _85 = frac(_85);
    _85 += (-0.5f);
    _170.y = _85 * 4.0f;
    _121 = (_9.yy * float2(7.30000019073486328125f, 1.7000000476837158203125f)) + _104.xx;
    _156.x = (_104.x * 3.099999904632568359375f) + _9.y;
    _156.x *= 127.09999847412109375f;
    float2 _198 = sin(_156.xy);
    _156 = float3(_198.x, _198.y, _156.z);
    _156.x *= 43758.546875f;
    _156.x = frac(_156.x);
    _156.x = (_156.x * 0.14000000059604644775390625f) + 0.180000007152557373046875f;
    _104 = _121 * 127.09999847412109375f.xx;
    _104 = sin(_104);
    _104 *= 43758.546875f.xx;
    _104 = frac(_104);
    _85 = _104.x + (-0.5f);
    _150.y = _104.y >= 0.3499999940395355224609375f;
    _95.x = float(_150.x);
    _95.y = float(_150.y);
    _85 *= 0.300000011920928955078125f;
    _72 = (_156.y * 0.180000007152557373046875f) + _85;
    _9.x = (-_72) + _9.x;
    _170.x = _9.x * 1.39999997615814208984375f;
    _9.x = dot(_170, _170);
    _9.x = sqrt(_9.x);
    _9.x /= _156.x;
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _9.x = _95.x * _9.x;
    _9.x = _95.y * _9.x;
    _9.x *= _21_m13;
    _304.x = (_21_m15 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _304.x = _9.x * _304.x;
    _156.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _156.x = rsqrt(_156.x);
    float3 _331 = _156.xxx * vs_TEXCOORD2;
    _95 = float4(_331.x, _331.y, _331.z, _95.w);
    _334.x = _95.y * _95.y;
    _334.x = (_95.x * _95.x) + (-_334.x);
    _351 = _95.yzzx * _95.xyzz;
    _357.x = dot(_21_m5, _351);
    _357.y = dot(_21_m6, _351);
    _357.z = dot(_21_m7, _351);
    _334 = (_21_m8.xyz * _334.xxx) + _357;
    _95.w = 1.0f;
    _357.x = dot(_21_m2, _95);
    _357.y = dot(_21_m3, _95);
    _357.z = dot(_21_m4, _95);
    _334 += _357;
    _334 = max(_334, 0.0f.xxx);
    _156 = (-vs_TEXCOORD1) + _21_m1;
    _418 = dot(_156, _156);
    _418 = rsqrt(_418);
    _156 *= _418.xxx;
    _156.x = dot(_95.xyz, _156);
    _156.x = min(abs(_156.x), 1.0f);
    _156.x = (-_156.x) + 1.0f;
    _156.x *= _156.x;
    _357.x = (_156.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _455 = _21_m12.xyz * _21_m15.xxx;
    _357 = _357.xxx * _455;
    _468 = (-_21_m10) + _21_m11;
    _468 = (_156.xxxx * _468) + _21_m10;
    _334 = (_468.xyz * _334) + _357;
    _491.w = (_9.x * 0.4000000059604644775390625f) + _468.w;
    _491.w = clamp(_491.w, 0.0f, 1.0f);
    _304 = (_304.xxx * _21_m12.xyz) + _334;
    _9 = _304 + (-_21_m9.xyz);
    _85 = vs_TEXCOORD3;
    _85 = clamp(_85, 0.0f, 1.0f);
    _9 = (_85.xxx * _9) + _21_m9.xyz;
    _491 = float4(_9.x, _9.y, _9.z, _491.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._491 = _491;
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




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _102;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _102 : NORMAL;
    float2 _99 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _124;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _44.xxxx) + _9;
    _9 = (_21_m2[2] * _44.zzzz) + _9;
    gl_Position = (_21_m2[3] * _44.wwww) + _9;
    vs_TEXCOORD0 = _99;
    _9.x = dot(_102, _21_m1[0].xyz);
    _9.y = dot(_102, _21_m1[1].xyz);
    _9.z = dot(_102, _21_m1[2].xyz);
    _124 = dot(_9.xyz, _9.xyz);
    _124 = rsqrt(_124);
    vs_TEXCOORD2 = _124.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _102 = stage_input._102;
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
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 _Color;
float4 _EdgeColor;
float4 _GlowColor;
float _Bubbles;
float _BubbleSpeed;
float _Glow;
float _LevelY;
#define _21_m0 _Time
#define _21_m1 _WorldSpaceCameraPos
#define _21_m2 unity_SHAr
#define _21_m3 unity_SHAg
#define _21_m4 unity_SHAb
#define _21_m5 unity_SHBr
#define _21_m6 unity_SHBg
#define _21_m7 unity_SHBb
#define _21_m8 unity_SHC
#define _21_m9 _Color
#define _21_m10 _EdgeColor
#define _21_m11 _GlowColor
#define _21_m12 _Bubbles
#define _21_m13 _BubbleSpeed
#define _21_m14 _Glow
#define _21_m15 _LevelY



static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float4 _488;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _488 : SV_Target0;
};

static float3 _9;
static bool _33;
static float _72;
static float _85;
static float4 _95;
static float2 _104;
static float2 _121;
static bool2 _150;
static float3 _156;
static float2 _170;
static float _304;
static float3 _331;
static float4 _348;
static float3 _354;
static float _415;
static float3 _452;
static float4 _465;

void frag_inner()
{
    _9.x = (-vs_TEXCOORD1.y) + _21_m15;
    _33 = _9.x < 0.0f;
    if ((int(_33) * (-1)) != 0)
    {
        discard;
    }
    _9.x = vs_TEXCOORD0.x * 38.0f;
    _9.y = floor(_9.x);
    _9.x = frac(_9.x);
    float2 _69 = _9.xy + float2(-0.5f, 17.0f);
    _9 = float3(_69.x, _9.y, _69.y);
    _72 = _9.z * 127.09999847412109375f;
    _72 = sin(_72);
    _72 *= 43758.546875f;
    _72 = frac(_72);
    _85 = (_72 * 2.5f) + 2.0f;
    _72 *= 9.0f;
    _95.x = _21_m0.y * _21_m13;
    _104.x = _9.y * 127.09999847412109375f;
    _104.x = sin(_104.x);
    _104.x *= 43758.546875f;
    _104.x = frac(_104.x);
    _121.x = (_104.x * 2.5f) + 1.5f;
    _95.x = _121.x * _95.x;
    _85 = (vs_TEXCOORD0.y * _85) + (-_95.x);
    _85 = (_104.x * 13.0f) + _85;
    _150.x = _104.x >= 0.62000000476837158203125f;
    _156.y = (_85 * 6.283100128173828125f) + _72;
    _104.x = floor(_85);
    _85 = frac(_85);
    _85 += (-0.5f);
    _170.y = _85 * 4.0f;
    _121 = (_9.yy * float2(7.30000019073486328125f, 1.7000000476837158203125f)) + _104.xx;
    _156.x = (_104.x * 3.099999904632568359375f) + _9.y;
    _156.x *= 127.09999847412109375f;
    float2 _198 = sin(_156.xy);
    _156 = float3(_198.x, _198.y, _156.z);
    _156.x *= 43758.546875f;
    _156.x = frac(_156.x);
    _156.x = (_156.x * 0.14000000059604644775390625f) + 0.180000007152557373046875f;
    _104 = _121 * 127.09999847412109375f.xx;
    _104 = sin(_104);
    _104 *= 43758.546875f.xx;
    _104 = frac(_104);
    _85 = _104.x + (-0.5f);
    _150.y = _104.y >= 0.3499999940395355224609375f;
    _95.x = float(_150.x);
    _95.y = float(_150.y);
    _85 *= 0.300000011920928955078125f;
    _72 = (_156.y * 0.180000007152557373046875f) + _85;
    _9.x = (-_72) + _9.x;
    _170.x = _9.x * 1.39999997615814208984375f;
    _9.x = dot(_170, _170);
    _9.x = sqrt(_9.x);
    _9.x /= _156.x;
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _9.x = _95.x * _9.x;
    _9.x = _95.y * _9.x;
    _9.x *= _21_m12;
    _304 = (_21_m14 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _304 = _9.x * _304;
    _156.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _156.x = rsqrt(_156.x);
    float3 _328 = _156.xxx * vs_TEXCOORD2;
    _95 = float4(_328.x, _328.y, _328.z, _95.w);
    _331.x = _95.y * _95.y;
    _331.x = (_95.x * _95.x) + (-_331.x);
    _348 = _95.yzzx * _95.xyzz;
    _354.x = dot(_21_m5, _348);
    _354.y = dot(_21_m6, _348);
    _354.z = dot(_21_m7, _348);
    _331 = (_21_m8.xyz * _331.xxx) + _354;
    _95.w = 1.0f;
    _354.x = dot(_21_m2, _95);
    _354.y = dot(_21_m3, _95);
    _354.z = dot(_21_m4, _95);
    _331 += _354;
    _331 = max(_331, 0.0f.xxx);
    _156 = (-vs_TEXCOORD1) + _21_m1;
    _415 = dot(_156, _156);
    _415 = rsqrt(_415);
    _156 *= _415.xxx;
    _156.x = dot(_95.xyz, _156);
    _156.x = min(abs(_156.x), 1.0f);
    _156.x = (-_156.x) + 1.0f;
    _156.x *= _156.x;
    _354.x = (_156.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _452 = _21_m11.xyz * _21_m14.xxx;
    _354 = _354.xxx * _452;
    _465 = (-_21_m9) + _21_m10;
    _465 = (_156.xxxx * _465) + _21_m9;
    _331 = (_465.xyz * _331) + _354;
    _488.w = (_9.x * 0.4000000059604644775390625f) + _465.w;
    _488.w = clamp(_488.w, 0.0f, 1.0f);
    float3 _508 = (_304.xxx * _21_m11.xyz) + _331;
    _488 = float4(_508.x, _508.y, _508.z, _488.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._488 = _488;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}