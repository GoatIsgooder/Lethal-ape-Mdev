// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BloodDecal" {
Properties {

_MainTex ("Splat Atlas (2x2)", 2D) = "white" { }

_SplatTint ("Tint", Color) = (1,1,1,1)

_Cutoff ("Edge", Range(0.05, 0.95)) = 0.5

_Smoothness ("Smoothness", Range(0, 1)) = 0.8500000238418579

_Specular ("Highlight", Range(0, 4)) = 1.2000000476837158

_Sheen ("Wet Sheen", Range(0, 2)) = 0.6000000238418579

[Toggle(BAKERY_VOLUME)] _BAKERY_VOLUME ("Use Bakery Volume", Float) = 1.0

_VolumeMin ("Volume Min", Vector) = (0,0,0,1)

_VolumeInvSize ("Volume Inv Size", Vector) = (1000000.0,1000000.0,1000000.0,1)

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-20" "RenderType" = "Transparent" }
 Pass {
Cull Back
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-20" "RenderType" = "Transparent" }
 ZWrite Off
 Offset -1.0, -1.0
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ BAKERY_VOLUME
#if defined(BAKERY_VOLUME) && defined(FOG_EXP)
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
static float4 _22_m8[4];
float4x4 unity_WorldToObject;
static float4 _22_m9[4];
float4x4 unity_MatrixVP;
static float4 _22_m10[4];
float4 unity_FogParams;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float _Atlas;
float _Fade;
void __unity_init()
{
    _22_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m1 unity_SHAr
#define _22_m2 unity_SHAg
#define _22_m3 unity_SHAb
#define _22_m4 unity_SHBr
#define _22_m5 unity_SHBg
#define _22_m6 unity_SHBb
#define _22_m7 unity_SHC
#define _22_m11 unity_FogParams
#define _22_m12 _VolumeMin
#define _22_m13 _VolumeInvSize
#define _22_m14 _GlobalVolumeMin
#define _22_m15 _GlobalVolumeInvSize
#define _22_m16 _Atlas
#define _22_m17 _Fade


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _92;
static float2 _173;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _92 : NORMAL;
    float2 _173 : TEXCOORD0;
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
static float4 _46;
static float4 _52;
static float _116;
static bool _139;
static float _144;
static float4 _148;
static bool _184;
static float4 _214;
static float4 _250;
static float4 _283;
static float4 _290;
static float3 _301;
static float _306;
static float _320;
static float _351;
static float _363;
static float3 _417;
static float2 _485;
static float _539;
static float3 _618;
static float3 _626;
static float4 _642;
static float3 _648;
static float _667;
static float _750;
static bool _754;
static float _792;
static float3 _821;
static float _836;
static float _898;
static float2 _947;
static float _1034;
static float3 _1084;
static bool _1119;
static float4 _1154;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m8[1];
    _9 = (_22_m8[0] * _11.xxxx) + _9;
    _9 = (_22_m8[2] * _11.zzzz) + _9;
    _46 = _9 + _22_m8[3];
    _52 = _46.yyyy * _22_m10[1];
    _52 = (_22_m10[0] * _46.xxxx) + _52;
    _52 = (_22_m10[2] * _46.zzzz) + _52;
    _46 = (_22_m10[3] * _46.wwww) + _52;
    float3 _88 = (_22_m8[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_88.x, _88.y, _88.z, _9.w);
    _52.x = dot(_92, _22_m9[0].xyz);
    _52.y = dot(_92, _22_m9[1].xyz);
    _52.z = dot(_92, _22_m9[2].xyz);
    _116 = dot(_52.xyz, _52.xyz);
    _116 = rsqrt(_116);
    float3 _128 = _116.xxx * _52.xyz;
    _52 = float4(_128.x, _128.y, _128.z, _52.w);
    _116 = _22_m16 * 0.5f;
    _139 = _116 >= (-_116);
    _144 = frac(abs(_116));
    float _151;
    if (_139)
    {
        _151 = _144;
    }
    else
    {
        _151 = -_144;
    }
    _148.x = _151;
    _148.x += _148.x;
    _148.y = floor(_116);
    float2 _175 = _148.xy + _173;
    _148 = float4(_175.x, _175.y, _148.z, _148.w);
    vs_TEXCOORD0 = _148.xy * 0.5f.xx;
    _184 = 1000000.0f < _22_m13.x;
    float3 _192;
    if (_184)
    {
        _192 = _22_m14;
    }
    else
    {
        _192 = _22_m12;
    }
    _148 = float4(_192.x, _192.y, _192.z, _148.w);
    float3 _211 = _9.xyz + (-_148.xyz);
    _148 = float4(_211.x, _211.y, _211.z, _148.w);
    float3 _216;
    if (_184)
    {
        _216 = _22_m15;
    }
    else
    {
        _216 = _22_m13;
    }
    _214 = float4(_216.x, _216.y, _216.z, _214.w);
    float3 _232 = _148.xyz * _214.xyz;
    _148 = float4(_232.x, _232.y, _232.z, _148.w);
    _214 = _Volume0.SampleLevel(sampler_Volume0, _148.xyz, 0.0f).xywz;
    _250 = _Volume1.SampleLevel(sampler_Volume0, _148.xyz, 0.0f).yxwz;
    _148 = _Volume2.SampleLevel(sampler_Volume0, _148.xyz, 0.0f).xzwy;
    _116 = _214.y + _214.x;
    _116 = _214.w + _116;
    _184 = 9.9999997473787516355514526367188e-06f < _116;
    if (_184)
    {
        float3 _287 = max(_214.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _283 = float4(_287.x, _287.y, _287.z, _283.w);
        _290.x = _250.y;
        _290.y = _148.x;
        _290.z = _214.z;
        _301 = _290.xyz * 0.5f.xxx;
        _306 = dot(_301, _301);
        _306 = sqrt(_306);
        float3 _317 = (_290.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _290 = float4(_317.x, _317.y, _317.z, _290.w);
        _320 = dot(_290.xyz, _290.xyz);
        _320 = rsqrt(_320);
        float3 _332 = _320.xxx * _290.xyz;
        _290 = float4(_332.x, _332.y, _332.z, _290.w);
        _290.x = dot(_290.xyz, _52.xyz);
        _290.x = (_290.x * 0.5f) + 0.5f;
        _290.x = clamp(_290.x, 0.0f, 1.0f);
        _351 = _306 + _306;
        _351 /= _283.x;
        _306 /= _283.x;
        _363 = (-_306) + 1.0f;
        _306 += 1.0f;
        _306 = _363 / _306;
        _290.z = (-_306) + 1.0f;
        float2 _380 = _351.xx + float2(1.0f, 2.0f);
        _290 = float4(_290.x, _380.x, _290.z, _380.y);
        _290.x = log2(_290.x);
        float2 _391 = _290.xw * _290.yz;
        _290 = float4(_391.x, _290.y, _391.y, _290.w);
        _290.x = exp2(_290.x);
        _306 = (_290.z * _290.x) + _306;
        _290.x = _306 * _283.x;
        _301 = float3(_250.xz.x, _301.y, _250.xz.y);
        _301.y = _148.w;
        _417 = _301 * 0.5f.xxx;
        _283.x = dot(_417, _417);
        _283.x = sqrt(_283.x);
        _301 = (_301 * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _306 = dot(_301, _301);
        _306 = rsqrt(_306);
        _301 = _306.xxx * _301;
        _306 = dot(_301, _52.xyz);
        _306 = (_306 * 0.5f) + 0.5f;
        _306 = clamp(_306, 0.0f, 1.0f);
        _320 = _283.x + _283.x;
        _320 /= _283.y;
        _283.x /= _283.y;
        _301.x = (-_283.x) + 1.0f;
        _283.x += 1.0f;
        _283.x = _301.x / _283.x;
        _301.x = (-_283.x) + 1.0f;
        _485 = _320.xx + float2(1.0f, 2.0f);
        _320 = _485.y * _301.x;
        _306 = log2(_306);
        _306 *= _485.x;
        _306 = exp2(_306);
        _283.x = (_320 * _306) + _283.x;
        _290.y = _283.x * _283.y;
        _301.x = _250.w;
        _301 = float3(_301.x, _148.yz.x, _148.yz.y);
        float3 _523 = _301 * 0.5f.xxx;
        _283 = float4(_523.x, _523.y, _283.z, _523.z);
        _283.x = dot(_283.xyw, _283.xyw);
        _283.x = sqrt(_283.x);
        _301 = (_301 * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _539 = dot(_301, _301);
        _539 = rsqrt(_539);
        _301 = _539.xxx * _301;
        _539 = dot(_301, _52.xyz);
        _539 = (_539 * 0.5f) + 0.5f;
        _539 = clamp(_539, 0.0f, 1.0f);
        _283.w = _283.x + _283.x;
        float2 _568 = _283.xw / _283.zz;
        _283 = float4(_568.x, _283.y, _283.z, _568.y);
        _320 = (-_283.x) + 1.0f;
        _283.x += 1.0f;
        _283.x = _320 / _283.x;
        _320 = (-_283.x) + 1.0f;
        float2 _590 = _283.ww + float2(1.0f, 2.0f);
        _301 = float3(_590.x, _590.y, _301.z);
        _306 = _320 * _301.y;
        _539 = log2(_539);
        _539 *= _301.x;
        _539 = exp2(_539);
        _283.x = (_306 * _539) + _283.x;
        _290.z = _283.x * _283.z;
        _618 = _290.xyz;
    }
    else
    {
        _618.x = 0.0f;
        _618.y = 0.0f;
        _618.z = 0.0f;
    }
    _52.w = 1.0f;
    _626.x = dot(_22_m1, _52);
    _626.y = dot(_22_m2, _52);
    _626.z = dot(_22_m3, _52);
    _642 = _52.yzzx * _52.xyzz;
    _648.x = dot(_22_m4, _642);
    _648.y = dot(_22_m5, _642);
    _648.z = dot(_22_m6, _642);
    _667 = _52.y * _52.y;
    _667 = (_52.x * _52.x) + (-_667);
    _648 = (_22_m7.xyz * _667.xxx) + _648;
    _626 += _648;
    float3 _694;
    if (_184)
    {
        _694 = _618;
    }
    else
    {
        _694 = _626;
    }
    _618 = _694;
    float3 _705 = max(_618, 0.0f.xxx);
    vs_TEXCOORD3 = float4(_705.x, _705.y, _705.z, vs_TEXCOORD3.w);
    if (_184)
    {
        float3 _713 = max(_214.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _290 = float4(_713.x, _713.y, _713.z, _290.w);
        _301 = _250.yxw / _290.xyz;
        _301.x = dot(_301, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _417 = _148.xwy / _290.xyz;
        _301.y = dot(_417, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _214.x = _250.z;
        _214.y = _148.z;
        _417 = _214.zxy / _290.xyz;
        _301.z = dot(_417, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _750 = dot(_301, _301);
        _754 = 9.9999999392252902907785028219223e-09f < _750;
        _750 = rsqrt(_750);
        _301 = _750.xxx * _301;
        float3 _765;
        if (_754)
        {
            _765 = _301;
        }
        else
        {
            _765 = float3(0.0f, 1.0f, 0.0f);
        }
        _301 = _765;
        _214.x = _250.y;
        _214.y = _148.x;
        _417 = _214.xyz * 0.5f.xxx;
        _750 = dot(_417, _417);
        _750 = sqrt(_750);
        float3 _789 = (_214.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _214 = float4(_789.x, _789.y, _789.z, _214.w);
        _792 = dot(_214.xyz, _214.xyz);
        _792 = rsqrt(_792);
        float3 _804 = _792.xxx * _214.xyz;
        _214 = float4(_804.x, _804.y, _804.z, _214.w);
        _214.x = dot(_214.xyz, _301);
        _214.x = (_214.x * 0.5f) + 0.5f;
        _214.x = clamp(_214.x, 0.0f, 1.0f);
        _821.x = _750 + _750;
        _821.x /= _290.x;
        _750 /= _290.x;
        _836 = (-_750) + 1.0f;
        _750 += 1.0f;
        _750 = _836 / _750;
        _214.z = (-_750) + 1.0f;
        float2 _851 = _821.xx + float2(1.0f, 2.0f);
        _214 = float4(_214.x, _851.x, _214.z, _851.y);
        _214.x = log2(_214.x);
        float2 _862 = _214.xw * _214.yz;
        _214 = float4(_862.x, _214.y, _862.y, _214.w);
        _214.x = exp2(_214.x);
        _750 = (_214.z * _214.x) + _750;
        _214.x = _750 * _290.x;
        _250.y = _148.w;
        _417 = _250.xyz * 0.5f.xxx;
        _750 = dot(_417, _417);
        _750 = sqrt(_750);
        float3 _895 = (_250.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _250 = float4(_895.x, _895.y, _895.z, _250.w);
        _898 = dot(_250.xyz, _250.xyz);
        _898 = rsqrt(_898);
        float3 _910 = _898.xxx * _250.xyz;
        _250 = float4(_910.x, _910.y, _910.z, _250.w);
        _898 = dot(_250.xyz, _301);
        _898 = (_898 * 0.5f) + 0.5f;
        _898 = clamp(_898, 0.0f, 1.0f);
        _792 = _750 + _750;
        _792 /= _290.y;
        _750 /= _290.y;
        _250.x = (-_750) + 1.0f;
        _750 += 1.0f;
        _750 = _250.x / _750;
        _250.x = (-_750) + 1.0f;
        _947 = _792.xx + float2(1.0f, 2.0f);
        _792 = _947.y * _250.x;
        _898 = log2(_898);
        _898 *= _947.x;
        _898 = exp2(_898);
        _750 = (_792 * _898) + _750;
        _214.y = _750 * _290.y;
        _148.x = _250.w;
        float3 _979 = _148.xyz * 0.5f.xxx;
        _250 = float4(_979.x, _979.y, _979.z, _250.w);
        _750 = dot(_250.xyz, _250.xyz);
        _750 = sqrt(_750);
        float3 _992 = (_148.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _148 = float4(_992.x, _992.y, _992.z, _148.w);
        _898 = dot(_148.xyz, _148.xyz);
        _898 = rsqrt(_898);
        float3 _1006 = _898.xxx * _148.xyz;
        _148 = float4(_1006.x, _1006.y, _1006.z, _148.w);
        _148.x = dot(_148.xyz, _301);
        _148.x = (_148.x * 0.5f) + 0.5f;
        _148.x = clamp(_148.x, 0.0f, 1.0f);
        _144 = _750 + _750;
        _144 /= _290.z;
        _750 /= _290.z;
        _1034 = (-_750) + 1.0f;
        _750 += 1.0f;
        _750 = _1034 / _750;
        _148.z = (-_750) + 1.0f;
        float2 _1049 = _144.xx + float2(1.0f, 2.0f);
        _148 = float4(_148.x, _1049.x, _148.z, _1049.y);
        _148.x = log2(_148.x);
        float2 _1060 = _148.xw * _148.yz;
        _148 = float4(_1060.x, _148.y, _1060.y, _148.w);
        _148.x = exp2(_148.x);
        _750 = (_148.z * _148.x) + _750;
        _214.z = _750 * _290.z;
        float3 _1081 = max(_214.xyz, 0.0f.xxx);
        _148 = float4(_1081.x, _1081.y, _1081.z, _148.w);
        _1084 = _148.xyz;
    }
    else
    {
        _301.x = 0.0f;
        _301.y = 1.0f;
        _301.z = 0.0f;
        _1084.x = 0.0f;
        _1084.y = 0.0f;
        _1084.z = 0.0f;
    }
    _618 = _22_m2.xyz * 0.715200006961822509765625f.xxx;
    _618 = (_22_m1.xyz * 0.2125999927520751953125f.xxx) + _618;
    _618 = (_22_m3.xyz * 0.072200000286102294921875f.xxx) + _618;
    _750 = dot(_618, _618);
    _1119 = 9.9999999392252902907785028219223e-09f < _750;
    _750 = rsqrt(_750);
    _821 = _750.xxx * _618;
    float3 _1129;
    if (_1119)
    {
        _1129 = _821;
    }
    else
    {
        _1129 = _301;
    }
    _214 = float4(_1129.x, _1129.y, _1129.z, _214.w);
    _214.w = 1.0f;
    _618.x = dot(_22_m1, _214);
    _618.y = dot(_22_m2, _214);
    _618.z = dot(_22_m3, _214);
    _1154 = _214.yzzx * _214.xyzz;
    _626.x = dot(_22_m4, _1154);
    _626.y = dot(_22_m5, _1154);
    _626.z = dot(_22_m6, _1154);
    _667 = _214.y * _214.y;
    _667 = (_214.x * _214.x) + (-_667);
    _626 = (_22_m7.xyz * _667.xxx) + _626;
    _618 += _626;
    _618 = max(_618, 0.0f.xxx);
    float3 _1204;
    if (_184)
    {
        _1204 = _301;
    }
    else
    {
        _1204 = _214.xyz;
    }
    vs_TEXCOORD4 = _1204;
    float3 _1214;
    if (_184)
    {
        _1214 = _1084;
    }
    else
    {
        _1214 = _618;
    }
    vs_TEXCOORD5 = _1214;
    _116 = _46.z / _22_m0.y;
    _116 = (-_116) + 1.0f;
    _116 *= _22_m0.z;
    _116 = max(_116, 0.0f);
    _116 *= _22_m11.y;
    vs_TEXCOORD6 = exp2(-_116);
    gl_Position = _46;
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD2 = _52.xyz;
    vs_TEXCOORD3.w = _22_m17;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _173 = stage_input._173;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SplatTint;
float _Cutoff;
float _Smoothness;
float _Specular;
float _Sheen;
#define _55_m0 _WorldSpaceCameraPos
#define _55_m1 _WorldSpaceLightPos0
#define _55_m2 unity_FogColor
#define _55_m3 _LightColor0
#define _55_m4 _SplatTint
#define _55_m5 _Cutoff
#define _55_m6 _Smoothness
#define _55_m7 _Specular
#define _55_m8 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 _109;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD6;

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
    float4 _109 : SV_Target0;
};

static float4 _9;
static float4 _25;
static float _34;
static bool _116;
static float3 _130;
static float3 _140;
static float3 _164;
static float _173;
static float3 _179;
static float3 _205;
static float3 _257;
static float3 _264;
static float3 _270;
static float3 _293;
static float3 _299;
static float3 _340;
static float _366;
static float3 _377;
static float _547;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _25.x = ddx_coarse(_9.w);
    _34 = ddy_coarse(_9.w);
    _25.x = abs(_34) + abs(_25.x);
    _25.x = max(_25.x, 0.001000000047497451305389404296875f);
    _34 = _9.w + (-_55_m5);
    _25.x = _34 / _25.x;
    _25.x += 0.5f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = _9.w * _25.x;
    _25.x *= _55_m4.w;
    _34 = (_25.x * vs_TEXCOORD3.w) + (-0.0040000001899898052215576171875f);
    _25.x *= vs_TEXCOORD3.w;
    _109.w = _25.x;
    _116 = _34 < 0.0f;
    if ((int(_116) * (-1)) != 0)
    {
        discard;
    }
    _130.x = dot(_55_m1.xyz, _55_m1.xyz);
    _140.x = rsqrt(_130.x);
    _116 = 9.9999999747524270787835121154785e-07f < _130.x;
    _140 = _140.xxx * _55_m1.xyz;
    float3 _157;
    if (_116)
    {
        _157 = _140;
    }
    else
    {
        _157 = float3(0.0f, 1.0f, 0.0f);
    }
    _130 = _157;
    _164 = (-vs_TEXCOORD1) + _55_m0;
    _173 = dot(_164, _164);
    _173 = rsqrt(_173);
    _179 = (_164 * _173.xxx) + _130;
    _164 = _173.xxx * _164;
    _173 = dot(_179, _179);
    _173 = rsqrt(_173);
    _179 = _173.xxx * _179;
    _173 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _173 = rsqrt(_173);
    _205 = _173.xxx * vs_TEXCOORD2;
    _173 = dot(_205, _179);
    _173 = clamp(_173, 0.0f, 1.0f);
    _173 = log2(_173);
    float2 _231 = (float2(float2(_55_m6, _55_m6)) * float2(10.0f, 7.0f)) + 1.0f.xx;
    _25 = float4(_231.x, _231.y, _25.z, _25.w);
    float2 _236 = exp2(_25.xy);
    _25 = float4(_236.x, _236.y, _25.z, _25.w);
    _173 *= _25.x;
    _173 = exp2(_173);
    float2 _254 = _9.ww * float2(_55_m7, _55_m8);
    _25 = float4(_254.x, _25.y, _254.y, _25.w);
    _257 = _9.xyz * _55_m4.xyz;
    _264.x = _25.x * _173;
    _270 = _264.xxx * _55_m3.xyz;
    _264.x = dot(_205, _130);
    _264.x = (_264.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _293 = max(vs_TEXCOORD3.xyz, 0.2199999988079071044921875f.xxx);
    _299 = (_55_m3.xyz * _264.xxx) + _293;
    _270 = (_257 * _299) + _270;
    _299 = (_257 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _257 = (_257 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _264.x = dot(_205, _164);
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x = (-_264.x) + 1.0f;
    _340.x = _264.x * _264.x;
    _340.x *= _340.x;
    _264.x = _340.x * _264.x;
    _340.x = (_264.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _366 = _25.z * _264.x;
    _366 *= _55_m6;
    _377 = _340.xxx * _293;
    _377 *= float3(float3(_55_m6, _55_m6, _55_m6));
    _377 *= 0.300000011920928955078125f.xxx;
    _270 = (_377 * _299) + _270;
    _264.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _264.x = rsqrt(_264.x);
    _340 = (vs_TEXCOORD4 * _264.xxx) + _164;
    _130 = _264.xxx * vs_TEXCOORD4;
    _264.x = dot(_340, _340);
    _264.x = rsqrt(_264.x);
    _264 = _264.xxx * _340;
    _264.x = dot(_205, _264);
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x = log2(_264.x);
    _264.x *= _25.y;
    _264.x = exp2(_264.x);
    _264.x = _25.x * _264.x;
    float3 _470 = (vs_TEXCOORD5 * _264.xxx) + _270;
    _25 = float4(_470.x, _470.y, _25.z, _470.z);
    _264.x = dot(-_164, _205);
    _264.x += _264.x;
    _264 = (_205 * (-_264.xxx)) + (-_164);
    _264.x = dot(_264, _130);
    _264.x = (_264.x * 0.5f) + 0.5f;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x *= _264.x;
    _264.x *= _264.x;
    _270 = (-_293) + vs_TEXCOORD5;
    _270 = (_264.xxx * _270) + _293;
    _257 *= _270;
    float3 _536 = (_257 * _366.xxx) + _25.xyw;
    _25 = float4(_536.x, _536.y, _536.z, _25.w);
    _264 = _25.xyz + (-_55_m2.xyz);
    _547 = vs_TEXCOORD6;
    _547 = clamp(_547, 0.0f, 1.0f);
    _264 = (_547.xxx * _264) + _55_m2.xyz;
    _109 = float4(_264.x, _264.y, _264.z, _109.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._109 = _109;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP2)
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
static float4 _22_m8[4];
float4x4 unity_WorldToObject;
static float4 _22_m9[4];
float4x4 unity_MatrixVP;
static float4 _22_m10[4];
float4 unity_FogParams;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float _Atlas;
float _Fade;
void __unity_init()
{
    _22_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m1 unity_SHAr
#define _22_m2 unity_SHAg
#define _22_m3 unity_SHAb
#define _22_m4 unity_SHBr
#define _22_m5 unity_SHBg
#define _22_m6 unity_SHBb
#define _22_m7 unity_SHC
#define _22_m11 unity_FogParams
#define _22_m12 _VolumeMin
#define _22_m13 _VolumeInvSize
#define _22_m14 _GlobalVolumeMin
#define _22_m15 _GlobalVolumeInvSize
#define _22_m16 _Atlas
#define _22_m17 _Fade


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _92;
static float2 _173;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _92 : NORMAL;
    float2 _173 : TEXCOORD0;
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
static float4 _46;
static float4 _52;
static float _116;
static bool _139;
static float _144;
static float4 _148;
static bool _184;
static float4 _214;
static float4 _250;
static float4 _283;
static float4 _290;
static float3 _301;
static float _306;
static float _320;
static float _351;
static float _363;
static float3 _417;
static float2 _485;
static float _539;
static float3 _618;
static float3 _626;
static float4 _642;
static float3 _648;
static float _667;
static float _750;
static bool _754;
static float _792;
static float3 _821;
static float _836;
static float _898;
static float2 _947;
static float _1034;
static float3 _1084;
static bool _1119;
static float4 _1154;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m8[1];
    _9 = (_22_m8[0] * _11.xxxx) + _9;
    _9 = (_22_m8[2] * _11.zzzz) + _9;
    _46 = _9 + _22_m8[3];
    _52 = _46.yyyy * _22_m10[1];
    _52 = (_22_m10[0] * _46.xxxx) + _52;
    _52 = (_22_m10[2] * _46.zzzz) + _52;
    _46 = (_22_m10[3] * _46.wwww) + _52;
    float3 _88 = (_22_m8[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_88.x, _88.y, _88.z, _9.w);
    _52.x = dot(_92, _22_m9[0].xyz);
    _52.y = dot(_92, _22_m9[1].xyz);
    _52.z = dot(_92, _22_m9[2].xyz);
    _116 = dot(_52.xyz, _52.xyz);
    _116 = rsqrt(_116);
    float3 _128 = _116.xxx * _52.xyz;
    _52 = float4(_128.x, _128.y, _128.z, _52.w);
    _116 = _22_m16 * 0.5f;
    _139 = _116 >= (-_116);
    _144 = frac(abs(_116));
    float _151;
    if (_139)
    {
        _151 = _144;
    }
    else
    {
        _151 = -_144;
    }
    _148.x = _151;
    _148.x += _148.x;
    _148.y = floor(_116);
    float2 _175 = _148.xy + _173;
    _148 = float4(_175.x, _175.y, _148.z, _148.w);
    vs_TEXCOORD0 = _148.xy * 0.5f.xx;
    _184 = 1000000.0f < _22_m13.x;
    float3 _192;
    if (_184)
    {
        _192 = _22_m14;
    }
    else
    {
        _192 = _22_m12;
    }
    _148 = float4(_192.x, _192.y, _192.z, _148.w);
    float3 _211 = _9.xyz + (-_148.xyz);
    _148 = float4(_211.x, _211.y, _211.z, _148.w);
    float3 _216;
    if (_184)
    {
        _216 = _22_m15;
    }
    else
    {
        _216 = _22_m13;
    }
    _214 = float4(_216.x, _216.y, _216.z, _214.w);
    float3 _232 = _148.xyz * _214.xyz;
    _148 = float4(_232.x, _232.y, _232.z, _148.w);
    _214 = _Volume0.SampleLevel(sampler_Volume0, _148.xyz, 0.0f).xywz;
    _250 = _Volume1.SampleLevel(sampler_Volume0, _148.xyz, 0.0f).yxwz;
    _148 = _Volume2.SampleLevel(sampler_Volume0, _148.xyz, 0.0f).xzwy;
    _116 = _214.y + _214.x;
    _116 = _214.w + _116;
    _184 = 9.9999997473787516355514526367188e-06f < _116;
    if (_184)
    {
        float3 _287 = max(_214.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _283 = float4(_287.x, _287.y, _287.z, _283.w);
        _290.x = _250.y;
        _290.y = _148.x;
        _290.z = _214.z;
        _301 = _290.xyz * 0.5f.xxx;
        _306 = dot(_301, _301);
        _306 = sqrt(_306);
        float3 _317 = (_290.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _290 = float4(_317.x, _317.y, _317.z, _290.w);
        _320 = dot(_290.xyz, _290.xyz);
        _320 = rsqrt(_320);
        float3 _332 = _320.xxx * _290.xyz;
        _290 = float4(_332.x, _332.y, _332.z, _290.w);
        _290.x = dot(_290.xyz, _52.xyz);
        _290.x = (_290.x * 0.5f) + 0.5f;
        _290.x = clamp(_290.x, 0.0f, 1.0f);
        _351 = _306 + _306;
        _351 /= _283.x;
        _306 /= _283.x;
        _363 = (-_306) + 1.0f;
        _306 += 1.0f;
        _306 = _363 / _306;
        _290.z = (-_306) + 1.0f;
        float2 _380 = _351.xx + float2(1.0f, 2.0f);
        _290 = float4(_290.x, _380.x, _290.z, _380.y);
        _290.x = log2(_290.x);
        float2 _391 = _290.xw * _290.yz;
        _290 = float4(_391.x, _290.y, _391.y, _290.w);
        _290.x = exp2(_290.x);
        _306 = (_290.z * _290.x) + _306;
        _290.x = _306 * _283.x;
        _301 = float3(_250.xz.x, _301.y, _250.xz.y);
        _301.y = _148.w;
        _417 = _301 * 0.5f.xxx;
        _283.x = dot(_417, _417);
        _283.x = sqrt(_283.x);
        _301 = (_301 * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _306 = dot(_301, _301);
        _306 = rsqrt(_306);
        _301 = _306.xxx * _301;
        _306 = dot(_301, _52.xyz);
        _306 = (_306 * 0.5f) + 0.5f;
        _306 = clamp(_306, 0.0f, 1.0f);
        _320 = _283.x + _283.x;
        _320 /= _283.y;
        _283.x /= _283.y;
        _301.x = (-_283.x) + 1.0f;
        _283.x += 1.0f;
        _283.x = _301.x / _283.x;
        _301.x = (-_283.x) + 1.0f;
        _485 = _320.xx + float2(1.0f, 2.0f);
        _320 = _485.y * _301.x;
        _306 = log2(_306);
        _306 *= _485.x;
        _306 = exp2(_306);
        _283.x = (_320 * _306) + _283.x;
        _290.y = _283.x * _283.y;
        _301.x = _250.w;
        _301 = float3(_301.x, _148.yz.x, _148.yz.y);
        float3 _523 = _301 * 0.5f.xxx;
        _283 = float4(_523.x, _523.y, _283.z, _523.z);
        _283.x = dot(_283.xyw, _283.xyw);
        _283.x = sqrt(_283.x);
        _301 = (_301 * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _539 = dot(_301, _301);
        _539 = rsqrt(_539);
        _301 = _539.xxx * _301;
        _539 = dot(_301, _52.xyz);
        _539 = (_539 * 0.5f) + 0.5f;
        _539 = clamp(_539, 0.0f, 1.0f);
        _283.w = _283.x + _283.x;
        float2 _568 = _283.xw / _283.zz;
        _283 = float4(_568.x, _283.y, _283.z, _568.y);
        _320 = (-_283.x) + 1.0f;
        _283.x += 1.0f;
        _283.x = _320 / _283.x;
        _320 = (-_283.x) + 1.0f;
        float2 _590 = _283.ww + float2(1.0f, 2.0f);
        _301 = float3(_590.x, _590.y, _301.z);
        _306 = _320 * _301.y;
        _539 = log2(_539);
        _539 *= _301.x;
        _539 = exp2(_539);
        _283.x = (_306 * _539) + _283.x;
        _290.z = _283.x * _283.z;
        _618 = _290.xyz;
    }
    else
    {
        _618.x = 0.0f;
        _618.y = 0.0f;
        _618.z = 0.0f;
    }
    _52.w = 1.0f;
    _626.x = dot(_22_m1, _52);
    _626.y = dot(_22_m2, _52);
    _626.z = dot(_22_m3, _52);
    _642 = _52.yzzx * _52.xyzz;
    _648.x = dot(_22_m4, _642);
    _648.y = dot(_22_m5, _642);
    _648.z = dot(_22_m6, _642);
    _667 = _52.y * _52.y;
    _667 = (_52.x * _52.x) + (-_667);
    _648 = (_22_m7.xyz * _667.xxx) + _648;
    _626 += _648;
    float3 _694;
    if (_184)
    {
        _694 = _618;
    }
    else
    {
        _694 = _626;
    }
    _618 = _694;
    float3 _705 = max(_618, 0.0f.xxx);
    vs_TEXCOORD3 = float4(_705.x, _705.y, _705.z, vs_TEXCOORD3.w);
    if (_184)
    {
        float3 _713 = max(_214.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _290 = float4(_713.x, _713.y, _713.z, _290.w);
        _301 = _250.yxw / _290.xyz;
        _301.x = dot(_301, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _417 = _148.xwy / _290.xyz;
        _301.y = dot(_417, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _214.x = _250.z;
        _214.y = _148.z;
        _417 = _214.zxy / _290.xyz;
        _301.z = dot(_417, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _750 = dot(_301, _301);
        _754 = 9.9999999392252902907785028219223e-09f < _750;
        _750 = rsqrt(_750);
        _301 = _750.xxx * _301;
        float3 _765;
        if (_754)
        {
            _765 = _301;
        }
        else
        {
            _765 = float3(0.0f, 1.0f, 0.0f);
        }
        _301 = _765;
        _214.x = _250.y;
        _214.y = _148.x;
        _417 = _214.xyz * 0.5f.xxx;
        _750 = dot(_417, _417);
        _750 = sqrt(_750);
        float3 _789 = (_214.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _214 = float4(_789.x, _789.y, _789.z, _214.w);
        _792 = dot(_214.xyz, _214.xyz);
        _792 = rsqrt(_792);
        float3 _804 = _792.xxx * _214.xyz;
        _214 = float4(_804.x, _804.y, _804.z, _214.w);
        _214.x = dot(_214.xyz, _301);
        _214.x = (_214.x * 0.5f) + 0.5f;
        _214.x = clamp(_214.x, 0.0f, 1.0f);
        _821.x = _750 + _750;
        _821.x /= _290.x;
        _750 /= _290.x;
        _836 = (-_750) + 1.0f;
        _750 += 1.0f;
        _750 = _836 / _750;
        _214.z = (-_750) + 1.0f;
        float2 _851 = _821.xx + float2(1.0f, 2.0f);
        _214 = float4(_214.x, _851.x, _214.z, _851.y);
        _214.x = log2(_214.x);
        float2 _862 = _214.xw * _214.yz;
        _214 = float4(_862.x, _214.y, _862.y, _214.w);
        _214.x = exp2(_214.x);
        _750 = (_214.z * _214.x) + _750;
        _214.x = _750 * _290.x;
        _250.y = _148.w;
        _417 = _250.xyz * 0.5f.xxx;
        _750 = dot(_417, _417);
        _750 = sqrt(_750);
        float3 _895 = (_250.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _250 = float4(_895.x, _895.y, _895.z, _250.w);
        _898 = dot(_250.xyz, _250.xyz);
        _898 = rsqrt(_898);
        float3 _910 = _898.xxx * _250.xyz;
        _250 = float4(_910.x, _910.y, _910.z, _250.w);
        _898 = dot(_250.xyz, _301);
        _898 = (_898 * 0.5f) + 0.5f;
        _898 = clamp(_898, 0.0f, 1.0f);
        _792 = _750 + _750;
        _792 /= _290.y;
        _750 /= _290.y;
        _250.x = (-_750) + 1.0f;
        _750 += 1.0f;
        _750 = _250.x / _750;
        _250.x = (-_750) + 1.0f;
        _947 = _792.xx + float2(1.0f, 2.0f);
        _792 = _947.y * _250.x;
        _898 = log2(_898);
        _898 *= _947.x;
        _898 = exp2(_898);
        _750 = (_792 * _898) + _750;
        _214.y = _750 * _290.y;
        _148.x = _250.w;
        float3 _979 = _148.xyz * 0.5f.xxx;
        _250 = float4(_979.x, _979.y, _979.z, _250.w);
        _750 = dot(_250.xyz, _250.xyz);
        _750 = sqrt(_750);
        float3 _992 = (_148.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _148 = float4(_992.x, _992.y, _992.z, _148.w);
        _898 = dot(_148.xyz, _148.xyz);
        _898 = rsqrt(_898);
        float3 _1006 = _898.xxx * _148.xyz;
        _148 = float4(_1006.x, _1006.y, _1006.z, _148.w);
        _148.x = dot(_148.xyz, _301);
        _148.x = (_148.x * 0.5f) + 0.5f;
        _148.x = clamp(_148.x, 0.0f, 1.0f);
        _144 = _750 + _750;
        _144 /= _290.z;
        _750 /= _290.z;
        _1034 = (-_750) + 1.0f;
        _750 += 1.0f;
        _750 = _1034 / _750;
        _148.z = (-_750) + 1.0f;
        float2 _1049 = _144.xx + float2(1.0f, 2.0f);
        _148 = float4(_148.x, _1049.x, _148.z, _1049.y);
        _148.x = log2(_148.x);
        float2 _1060 = _148.xw * _148.yz;
        _148 = float4(_1060.x, _148.y, _1060.y, _148.w);
        _148.x = exp2(_148.x);
        _750 = (_148.z * _148.x) + _750;
        _214.z = _750 * _290.z;
        float3 _1081 = max(_214.xyz, 0.0f.xxx);
        _148 = float4(_1081.x, _1081.y, _1081.z, _148.w);
        _1084 = _148.xyz;
    }
    else
    {
        _301.x = 0.0f;
        _301.y = 1.0f;
        _301.z = 0.0f;
        _1084.x = 0.0f;
        _1084.y = 0.0f;
        _1084.z = 0.0f;
    }
    _618 = _22_m2.xyz * 0.715200006961822509765625f.xxx;
    _618 = (_22_m1.xyz * 0.2125999927520751953125f.xxx) + _618;
    _618 = (_22_m3.xyz * 0.072200000286102294921875f.xxx) + _618;
    _750 = dot(_618, _618);
    _1119 = 9.9999999392252902907785028219223e-09f < _750;
    _750 = rsqrt(_750);
    _821 = _750.xxx * _618;
    float3 _1129;
    if (_1119)
    {
        _1129 = _821;
    }
    else
    {
        _1129 = _301;
    }
    _214 = float4(_1129.x, _1129.y, _1129.z, _214.w);
    _214.w = 1.0f;
    _618.x = dot(_22_m1, _214);
    _618.y = dot(_22_m2, _214);
    _618.z = dot(_22_m3, _214);
    _1154 = _214.yzzx * _214.xyzz;
    _626.x = dot(_22_m4, _1154);
    _626.y = dot(_22_m5, _1154);
    _626.z = dot(_22_m6, _1154);
    _667 = _214.y * _214.y;
    _667 = (_214.x * _214.x) + (-_667);
    _626 = (_22_m7.xyz * _667.xxx) + _626;
    _618 += _626;
    _618 = max(_618, 0.0f.xxx);
    float3 _1204;
    if (_184)
    {
        _1204 = _301;
    }
    else
    {
        _1204 = _214.xyz;
    }
    vs_TEXCOORD4 = _1204;
    float3 _1214;
    if (_184)
    {
        _1214 = _1084;
    }
    else
    {
        _1214 = _618;
    }
    vs_TEXCOORD5 = _1214;
    _116 = _46.z / _22_m0.y;
    _116 = (-_116) + 1.0f;
    _116 *= _22_m0.z;
    _116 = max(_116, 0.0f);
    _116 *= _22_m11.x;
    _116 *= (-_116);
    vs_TEXCOORD6 = exp2(_116);
    gl_Position = _46;
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD2 = _52.xyz;
    vs_TEXCOORD3.w = _22_m17;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _173 = stage_input._173;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SplatTint;
float _Cutoff;
float _Smoothness;
float _Specular;
float _Sheen;
#define _55_m0 _WorldSpaceCameraPos
#define _55_m1 _WorldSpaceLightPos0
#define _55_m2 unity_FogColor
#define _55_m3 _LightColor0
#define _55_m4 _SplatTint
#define _55_m5 _Cutoff
#define _55_m6 _Smoothness
#define _55_m7 _Specular
#define _55_m8 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 _109;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD6;

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
    float4 _109 : SV_Target0;
};

static float4 _9;
static float4 _25;
static float _34;
static bool _116;
static float3 _130;
static float3 _140;
static float3 _164;
static float _173;
static float3 _179;
static float3 _205;
static float3 _257;
static float3 _264;
static float3 _270;
static float3 _293;
static float3 _299;
static float3 _340;
static float _366;
static float3 _377;
static float _547;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _25.x = ddx_coarse(_9.w);
    _34 = ddy_coarse(_9.w);
    _25.x = abs(_34) + abs(_25.x);
    _25.x = max(_25.x, 0.001000000047497451305389404296875f);
    _34 = _9.w + (-_55_m5);
    _25.x = _34 / _25.x;
    _25.x += 0.5f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = _9.w * _25.x;
    _25.x *= _55_m4.w;
    _34 = (_25.x * vs_TEXCOORD3.w) + (-0.0040000001899898052215576171875f);
    _25.x *= vs_TEXCOORD3.w;
    _109.w = _25.x;
    _116 = _34 < 0.0f;
    if ((int(_116) * (-1)) != 0)
    {
        discard;
    }
    _130.x = dot(_55_m1.xyz, _55_m1.xyz);
    _140.x = rsqrt(_130.x);
    _116 = 9.9999999747524270787835121154785e-07f < _130.x;
    _140 = _140.xxx * _55_m1.xyz;
    float3 _157;
    if (_116)
    {
        _157 = _140;
    }
    else
    {
        _157 = float3(0.0f, 1.0f, 0.0f);
    }
    _130 = _157;
    _164 = (-vs_TEXCOORD1) + _55_m0;
    _173 = dot(_164, _164);
    _173 = rsqrt(_173);
    _179 = (_164 * _173.xxx) + _130;
    _164 = _173.xxx * _164;
    _173 = dot(_179, _179);
    _173 = rsqrt(_173);
    _179 = _173.xxx * _179;
    _173 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _173 = rsqrt(_173);
    _205 = _173.xxx * vs_TEXCOORD2;
    _173 = dot(_205, _179);
    _173 = clamp(_173, 0.0f, 1.0f);
    _173 = log2(_173);
    float2 _231 = (float2(float2(_55_m6, _55_m6)) * float2(10.0f, 7.0f)) + 1.0f.xx;
    _25 = float4(_231.x, _231.y, _25.z, _25.w);
    float2 _236 = exp2(_25.xy);
    _25 = float4(_236.x, _236.y, _25.z, _25.w);
    _173 *= _25.x;
    _173 = exp2(_173);
    float2 _254 = _9.ww * float2(_55_m7, _55_m8);
    _25 = float4(_254.x, _25.y, _254.y, _25.w);
    _257 = _9.xyz * _55_m4.xyz;
    _264.x = _25.x * _173;
    _270 = _264.xxx * _55_m3.xyz;
    _264.x = dot(_205, _130);
    _264.x = (_264.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _293 = max(vs_TEXCOORD3.xyz, 0.2199999988079071044921875f.xxx);
    _299 = (_55_m3.xyz * _264.xxx) + _293;
    _270 = (_257 * _299) + _270;
    _299 = (_257 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _257 = (_257 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _264.x = dot(_205, _164);
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x = (-_264.x) + 1.0f;
    _340.x = _264.x * _264.x;
    _340.x *= _340.x;
    _264.x = _340.x * _264.x;
    _340.x = (_264.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _366 = _25.z * _264.x;
    _366 *= _55_m6;
    _377 = _340.xxx * _293;
    _377 *= float3(float3(_55_m6, _55_m6, _55_m6));
    _377 *= 0.300000011920928955078125f.xxx;
    _270 = (_377 * _299) + _270;
    _264.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _264.x = rsqrt(_264.x);
    _340 = (vs_TEXCOORD4 * _264.xxx) + _164;
    _130 = _264.xxx * vs_TEXCOORD4;
    _264.x = dot(_340, _340);
    _264.x = rsqrt(_264.x);
    _264 = _264.xxx * _340;
    _264.x = dot(_205, _264);
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x = log2(_264.x);
    _264.x *= _25.y;
    _264.x = exp2(_264.x);
    _264.x = _25.x * _264.x;
    float3 _470 = (vs_TEXCOORD5 * _264.xxx) + _270;
    _25 = float4(_470.x, _470.y, _25.z, _470.z);
    _264.x = dot(-_164, _205);
    _264.x += _264.x;
    _264 = (_205 * (-_264.xxx)) + (-_164);
    _264.x = dot(_264, _130);
    _264.x = (_264.x * 0.5f) + 0.5f;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x *= _264.x;
    _264.x *= _264.x;
    _270 = (-_293) + vs_TEXCOORD5;
    _270 = (_264.xxx * _270) + _293;
    _257 *= _270;
    float3 _536 = (_257 * _366.xxx) + _25.xyw;
    _25 = float4(_536.x, _536.y, _536.z, _25.w);
    _264 = _25.xyz + (-_55_m2.xyz);
    _547 = vs_TEXCOORD6;
    _547 = clamp(_547, 0.0f, 1.0f);
    _264 = (_547.xxx * _264) + _55_m2.xyz;
    _109 = float4(_264.x, _264.y, _264.z, _109.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._109 = _109;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_LINEAR)
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
static float4 _22_m8[4];
float4x4 unity_WorldToObject;
static float4 _22_m9[4];
float4x4 unity_MatrixVP;
static float4 _22_m10[4];
float4 unity_FogParams;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float _Atlas;
float _Fade;
void __unity_init()
{
    _22_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m1 unity_SHAr
#define _22_m2 unity_SHAg
#define _22_m3 unity_SHAb
#define _22_m4 unity_SHBr
#define _22_m5 unity_SHBg
#define _22_m6 unity_SHBb
#define _22_m7 unity_SHC
#define _22_m11 unity_FogParams
#define _22_m12 _VolumeMin
#define _22_m13 _VolumeInvSize
#define _22_m14 _GlobalVolumeMin
#define _22_m15 _GlobalVolumeInvSize
#define _22_m16 _Atlas
#define _22_m17 _Fade


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _92;
static float2 _173;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _92 : NORMAL;
    float2 _173 : TEXCOORD0;
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
static float4 _46;
static float4 _52;
static float _116;
static bool _139;
static float _144;
static float4 _148;
static bool _184;
static float4 _214;
static float4 _250;
static float4 _283;
static float4 _290;
static float3 _301;
static float _306;
static float _320;
static float _351;
static float _363;
static float3 _417;
static float2 _485;
static float _539;
static float3 _618;
static float3 _626;
static float4 _642;
static float3 _648;
static float _667;
static float _750;
static bool _754;
static float _792;
static float3 _821;
static float _836;
static float _898;
static float2 _947;
static float _1034;
static float3 _1084;
static bool _1119;
static float4 _1154;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m8[1];
    _9 = (_22_m8[0] * _11.xxxx) + _9;
    _9 = (_22_m8[2] * _11.zzzz) + _9;
    _46 = _9 + _22_m8[3];
    _52 = _46.yyyy * _22_m10[1];
    _52 = (_22_m10[0] * _46.xxxx) + _52;
    _52 = (_22_m10[2] * _46.zzzz) + _52;
    _46 = (_22_m10[3] * _46.wwww) + _52;
    float3 _88 = (_22_m8[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_88.x, _88.y, _88.z, _9.w);
    _52.x = dot(_92, _22_m9[0].xyz);
    _52.y = dot(_92, _22_m9[1].xyz);
    _52.z = dot(_92, _22_m9[2].xyz);
    _116 = dot(_52.xyz, _52.xyz);
    _116 = rsqrt(_116);
    float3 _128 = _116.xxx * _52.xyz;
    _52 = float4(_128.x, _128.y, _128.z, _52.w);
    _116 = _22_m16 * 0.5f;
    _139 = _116 >= (-_116);
    _144 = frac(abs(_116));
    float _151;
    if (_139)
    {
        _151 = _144;
    }
    else
    {
        _151 = -_144;
    }
    _148.x = _151;
    _148.x += _148.x;
    _148.y = floor(_116);
    float2 _175 = _148.xy + _173;
    _148 = float4(_175.x, _175.y, _148.z, _148.w);
    vs_TEXCOORD0 = _148.xy * 0.5f.xx;
    _184 = 1000000.0f < _22_m13.x;
    float3 _192;
    if (_184)
    {
        _192 = _22_m14;
    }
    else
    {
        _192 = _22_m12;
    }
    _148 = float4(_192.x, _192.y, _192.z, _148.w);
    float3 _211 = _9.xyz + (-_148.xyz);
    _148 = float4(_211.x, _211.y, _211.z, _148.w);
    float3 _216;
    if (_184)
    {
        _216 = _22_m15;
    }
    else
    {
        _216 = _22_m13;
    }
    _214 = float4(_216.x, _216.y, _216.z, _214.w);
    float3 _232 = _148.xyz * _214.xyz;
    _148 = float4(_232.x, _232.y, _232.z, _148.w);
    _214 = _Volume0.SampleLevel(sampler_Volume0, _148.xyz, 0.0f).xywz;
    _250 = _Volume1.SampleLevel(sampler_Volume0, _148.xyz, 0.0f).yxwz;
    _148 = _Volume2.SampleLevel(sampler_Volume0, _148.xyz, 0.0f).xzwy;
    _116 = _214.y + _214.x;
    _116 = _214.w + _116;
    _184 = 9.9999997473787516355514526367188e-06f < _116;
    if (_184)
    {
        float3 _287 = max(_214.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _283 = float4(_287.x, _287.y, _287.z, _283.w);
        _290.x = _250.y;
        _290.y = _148.x;
        _290.z = _214.z;
        _301 = _290.xyz * 0.5f.xxx;
        _306 = dot(_301, _301);
        _306 = sqrt(_306);
        float3 _317 = (_290.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _290 = float4(_317.x, _317.y, _317.z, _290.w);
        _320 = dot(_290.xyz, _290.xyz);
        _320 = rsqrt(_320);
        float3 _332 = _320.xxx * _290.xyz;
        _290 = float4(_332.x, _332.y, _332.z, _290.w);
        _290.x = dot(_290.xyz, _52.xyz);
        _290.x = (_290.x * 0.5f) + 0.5f;
        _290.x = clamp(_290.x, 0.0f, 1.0f);
        _351 = _306 + _306;
        _351 /= _283.x;
        _306 /= _283.x;
        _363 = (-_306) + 1.0f;
        _306 += 1.0f;
        _306 = _363 / _306;
        _290.z = (-_306) + 1.0f;
        float2 _380 = _351.xx + float2(1.0f, 2.0f);
        _290 = float4(_290.x, _380.x, _290.z, _380.y);
        _290.x = log2(_290.x);
        float2 _391 = _290.xw * _290.yz;
        _290 = float4(_391.x, _290.y, _391.y, _290.w);
        _290.x = exp2(_290.x);
        _306 = (_290.z * _290.x) + _306;
        _290.x = _306 * _283.x;
        _301 = float3(_250.xz.x, _301.y, _250.xz.y);
        _301.y = _148.w;
        _417 = _301 * 0.5f.xxx;
        _283.x = dot(_417, _417);
        _283.x = sqrt(_283.x);
        _301 = (_301 * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _306 = dot(_301, _301);
        _306 = rsqrt(_306);
        _301 = _306.xxx * _301;
        _306 = dot(_301, _52.xyz);
        _306 = (_306 * 0.5f) + 0.5f;
        _306 = clamp(_306, 0.0f, 1.0f);
        _320 = _283.x + _283.x;
        _320 /= _283.y;
        _283.x /= _283.y;
        _301.x = (-_283.x) + 1.0f;
        _283.x += 1.0f;
        _283.x = _301.x / _283.x;
        _301.x = (-_283.x) + 1.0f;
        _485 = _320.xx + float2(1.0f, 2.0f);
        _320 = _485.y * _301.x;
        _306 = log2(_306);
        _306 *= _485.x;
        _306 = exp2(_306);
        _283.x = (_320 * _306) + _283.x;
        _290.y = _283.x * _283.y;
        _301.x = _250.w;
        _301 = float3(_301.x, _148.yz.x, _148.yz.y);
        float3 _523 = _301 * 0.5f.xxx;
        _283 = float4(_523.x, _523.y, _283.z, _523.z);
        _283.x = dot(_283.xyw, _283.xyw);
        _283.x = sqrt(_283.x);
        _301 = (_301 * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _539 = dot(_301, _301);
        _539 = rsqrt(_539);
        _301 = _539.xxx * _301;
        _539 = dot(_301, _52.xyz);
        _539 = (_539 * 0.5f) + 0.5f;
        _539 = clamp(_539, 0.0f, 1.0f);
        _283.w = _283.x + _283.x;
        float2 _568 = _283.xw / _283.zz;
        _283 = float4(_568.x, _283.y, _283.z, _568.y);
        _320 = (-_283.x) + 1.0f;
        _283.x += 1.0f;
        _283.x = _320 / _283.x;
        _320 = (-_283.x) + 1.0f;
        float2 _590 = _283.ww + float2(1.0f, 2.0f);
        _301 = float3(_590.x, _590.y, _301.z);
        _306 = _320 * _301.y;
        _539 = log2(_539);
        _539 *= _301.x;
        _539 = exp2(_539);
        _283.x = (_306 * _539) + _283.x;
        _290.z = _283.x * _283.z;
        _618 = _290.xyz;
    }
    else
    {
        _618.x = 0.0f;
        _618.y = 0.0f;
        _618.z = 0.0f;
    }
    _52.w = 1.0f;
    _626.x = dot(_22_m1, _52);
    _626.y = dot(_22_m2, _52);
    _626.z = dot(_22_m3, _52);
    _642 = _52.yzzx * _52.xyzz;
    _648.x = dot(_22_m4, _642);
    _648.y = dot(_22_m5, _642);
    _648.z = dot(_22_m6, _642);
    _667 = _52.y * _52.y;
    _667 = (_52.x * _52.x) + (-_667);
    _648 = (_22_m7.xyz * _667.xxx) + _648;
    _626 += _648;
    float3 _694;
    if (_184)
    {
        _694 = _618;
    }
    else
    {
        _694 = _626;
    }
    _618 = _694;
    float3 _705 = max(_618, 0.0f.xxx);
    vs_TEXCOORD3 = float4(_705.x, _705.y, _705.z, vs_TEXCOORD3.w);
    if (_184)
    {
        float3 _713 = max(_214.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _290 = float4(_713.x, _713.y, _713.z, _290.w);
        _301 = _250.yxw / _290.xyz;
        _301.x = dot(_301, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _417 = _148.xwy / _290.xyz;
        _301.y = dot(_417, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _214.x = _250.z;
        _214.y = _148.z;
        _417 = _214.zxy / _290.xyz;
        _301.z = dot(_417, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _750 = dot(_301, _301);
        _754 = 9.9999999392252902907785028219223e-09f < _750;
        _750 = rsqrt(_750);
        _301 = _750.xxx * _301;
        float3 _765;
        if (_754)
        {
            _765 = _301;
        }
        else
        {
            _765 = float3(0.0f, 1.0f, 0.0f);
        }
        _301 = _765;
        _214.x = _250.y;
        _214.y = _148.x;
        _417 = _214.xyz * 0.5f.xxx;
        _750 = dot(_417, _417);
        _750 = sqrt(_750);
        float3 _789 = (_214.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _214 = float4(_789.x, _789.y, _789.z, _214.w);
        _792 = dot(_214.xyz, _214.xyz);
        _792 = rsqrt(_792);
        float3 _804 = _792.xxx * _214.xyz;
        _214 = float4(_804.x, _804.y, _804.z, _214.w);
        _214.x = dot(_214.xyz, _301);
        _214.x = (_214.x * 0.5f) + 0.5f;
        _214.x = clamp(_214.x, 0.0f, 1.0f);
        _821.x = _750 + _750;
        _821.x /= _290.x;
        _750 /= _290.x;
        _836 = (-_750) + 1.0f;
        _750 += 1.0f;
        _750 = _836 / _750;
        _214.z = (-_750) + 1.0f;
        float2 _851 = _821.xx + float2(1.0f, 2.0f);
        _214 = float4(_214.x, _851.x, _214.z, _851.y);
        _214.x = log2(_214.x);
        float2 _862 = _214.xw * _214.yz;
        _214 = float4(_862.x, _214.y, _862.y, _214.w);
        _214.x = exp2(_214.x);
        _750 = (_214.z * _214.x) + _750;
        _214.x = _750 * _290.x;
        _250.y = _148.w;
        _417 = _250.xyz * 0.5f.xxx;
        _750 = dot(_417, _417);
        _750 = sqrt(_750);
        float3 _895 = (_250.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _250 = float4(_895.x, _895.y, _895.z, _250.w);
        _898 = dot(_250.xyz, _250.xyz);
        _898 = rsqrt(_898);
        float3 _910 = _898.xxx * _250.xyz;
        _250 = float4(_910.x, _910.y, _910.z, _250.w);
        _898 = dot(_250.xyz, _301);
        _898 = (_898 * 0.5f) + 0.5f;
        _898 = clamp(_898, 0.0f, 1.0f);
        _792 = _750 + _750;
        _792 /= _290.y;
        _750 /= _290.y;
        _250.x = (-_750) + 1.0f;
        _750 += 1.0f;
        _750 = _250.x / _750;
        _250.x = (-_750) + 1.0f;
        _947 = _792.xx + float2(1.0f, 2.0f);
        _792 = _947.y * _250.x;
        _898 = log2(_898);
        _898 *= _947.x;
        _898 = exp2(_898);
        _750 = (_792 * _898) + _750;
        _214.y = _750 * _290.y;
        _148.x = _250.w;
        float3 _979 = _148.xyz * 0.5f.xxx;
        _250 = float4(_979.x, _979.y, _979.z, _250.w);
        _750 = dot(_250.xyz, _250.xyz);
        _750 = sqrt(_750);
        float3 _992 = (_148.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _148 = float4(_992.x, _992.y, _992.z, _148.w);
        _898 = dot(_148.xyz, _148.xyz);
        _898 = rsqrt(_898);
        float3 _1006 = _898.xxx * _148.xyz;
        _148 = float4(_1006.x, _1006.y, _1006.z, _148.w);
        _148.x = dot(_148.xyz, _301);
        _148.x = (_148.x * 0.5f) + 0.5f;
        _148.x = clamp(_148.x, 0.0f, 1.0f);
        _144 = _750 + _750;
        _144 /= _290.z;
        _750 /= _290.z;
        _1034 = (-_750) + 1.0f;
        _750 += 1.0f;
        _750 = _1034 / _750;
        _148.z = (-_750) + 1.0f;
        float2 _1049 = _144.xx + float2(1.0f, 2.0f);
        _148 = float4(_148.x, _1049.x, _148.z, _1049.y);
        _148.x = log2(_148.x);
        float2 _1060 = _148.xw * _148.yz;
        _148 = float4(_1060.x, _148.y, _1060.y, _148.w);
        _148.x = exp2(_148.x);
        _750 = (_148.z * _148.x) + _750;
        _214.z = _750 * _290.z;
        float3 _1081 = max(_214.xyz, 0.0f.xxx);
        _148 = float4(_1081.x, _1081.y, _1081.z, _148.w);
        _1084 = _148.xyz;
    }
    else
    {
        _301.x = 0.0f;
        _301.y = 1.0f;
        _301.z = 0.0f;
        _1084.x = 0.0f;
        _1084.y = 0.0f;
        _1084.z = 0.0f;
    }
    _618 = _22_m2.xyz * 0.715200006961822509765625f.xxx;
    _618 = (_22_m1.xyz * 0.2125999927520751953125f.xxx) + _618;
    _618 = (_22_m3.xyz * 0.072200000286102294921875f.xxx) + _618;
    _750 = dot(_618, _618);
    _1119 = 9.9999999392252902907785028219223e-09f < _750;
    _750 = rsqrt(_750);
    _821 = _750.xxx * _618;
    float3 _1129;
    if (_1119)
    {
        _1129 = _821;
    }
    else
    {
        _1129 = _301;
    }
    _214 = float4(_1129.x, _1129.y, _1129.z, _214.w);
    _214.w = 1.0f;
    _618.x = dot(_22_m1, _214);
    _618.y = dot(_22_m2, _214);
    _618.z = dot(_22_m3, _214);
    _1154 = _214.yzzx * _214.xyzz;
    _626.x = dot(_22_m4, _1154);
    _626.y = dot(_22_m5, _1154);
    _626.z = dot(_22_m6, _1154);
    _667 = _214.y * _214.y;
    _667 = (_214.x * _214.x) + (-_667);
    _626 = (_22_m7.xyz * _667.xxx) + _626;
    _618 += _626;
    _618 = max(_618, 0.0f.xxx);
    float3 _1204;
    if (_184)
    {
        _1204 = _301;
    }
    else
    {
        _1204 = _214.xyz;
    }
    vs_TEXCOORD4 = _1204;
    float3 _1214;
    if (_184)
    {
        _1214 = _1084;
    }
    else
    {
        _1214 = _618;
    }
    vs_TEXCOORD5 = _1214;
    _116 = _46.z / _22_m0.y;
    _116 = (-_116) + 1.0f;
    _116 *= _22_m0.z;
    _116 = max(_116, 0.0f);
    vs_TEXCOORD6 = (_116 * _22_m11.z) + _22_m11.w;
    gl_Position = _46;
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD2 = _52.xyz;
    vs_TEXCOORD3.w = _22_m17;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _173 = stage_input._173;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SplatTint;
float _Cutoff;
float _Smoothness;
float _Specular;
float _Sheen;
#define _55_m0 _WorldSpaceCameraPos
#define _55_m1 _WorldSpaceLightPos0
#define _55_m2 unity_FogColor
#define _55_m3 _LightColor0
#define _55_m4 _SplatTint
#define _55_m5 _Cutoff
#define _55_m6 _Smoothness
#define _55_m7 _Specular
#define _55_m8 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 _109;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD6;

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
    float4 _109 : SV_Target0;
};

static float4 _9;
static float4 _25;
static float _34;
static bool _116;
static float3 _130;
static float3 _140;
static float3 _164;
static float _173;
static float3 _179;
static float3 _205;
static float3 _257;
static float3 _264;
static float3 _270;
static float3 _293;
static float3 _299;
static float3 _340;
static float _366;
static float3 _377;
static float _547;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _25.x = ddx_coarse(_9.w);
    _34 = ddy_coarse(_9.w);
    _25.x = abs(_34) + abs(_25.x);
    _25.x = max(_25.x, 0.001000000047497451305389404296875f);
    _34 = _9.w + (-_55_m5);
    _25.x = _34 / _25.x;
    _25.x += 0.5f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = _9.w * _25.x;
    _25.x *= _55_m4.w;
    _34 = (_25.x * vs_TEXCOORD3.w) + (-0.0040000001899898052215576171875f);
    _25.x *= vs_TEXCOORD3.w;
    _109.w = _25.x;
    _116 = _34 < 0.0f;
    if ((int(_116) * (-1)) != 0)
    {
        discard;
    }
    _130.x = dot(_55_m1.xyz, _55_m1.xyz);
    _140.x = rsqrt(_130.x);
    _116 = 9.9999999747524270787835121154785e-07f < _130.x;
    _140 = _140.xxx * _55_m1.xyz;
    float3 _157;
    if (_116)
    {
        _157 = _140;
    }
    else
    {
        _157 = float3(0.0f, 1.0f, 0.0f);
    }
    _130 = _157;
    _164 = (-vs_TEXCOORD1) + _55_m0;
    _173 = dot(_164, _164);
    _173 = rsqrt(_173);
    _179 = (_164 * _173.xxx) + _130;
    _164 = _173.xxx * _164;
    _173 = dot(_179, _179);
    _173 = rsqrt(_173);
    _179 = _173.xxx * _179;
    _173 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _173 = rsqrt(_173);
    _205 = _173.xxx * vs_TEXCOORD2;
    _173 = dot(_205, _179);
    _173 = clamp(_173, 0.0f, 1.0f);
    _173 = log2(_173);
    float2 _231 = (float2(float2(_55_m6, _55_m6)) * float2(10.0f, 7.0f)) + 1.0f.xx;
    _25 = float4(_231.x, _231.y, _25.z, _25.w);
    float2 _236 = exp2(_25.xy);
    _25 = float4(_236.x, _236.y, _25.z, _25.w);
    _173 *= _25.x;
    _173 = exp2(_173);
    float2 _254 = _9.ww * float2(_55_m7, _55_m8);
    _25 = float4(_254.x, _25.y, _254.y, _25.w);
    _257 = _9.xyz * _55_m4.xyz;
    _264.x = _25.x * _173;
    _270 = _264.xxx * _55_m3.xyz;
    _264.x = dot(_205, _130);
    _264.x = (_264.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _293 = max(vs_TEXCOORD3.xyz, 0.2199999988079071044921875f.xxx);
    _299 = (_55_m3.xyz * _264.xxx) + _293;
    _270 = (_257 * _299) + _270;
    _299 = (_257 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _257 = (_257 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _264.x = dot(_205, _164);
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x = (-_264.x) + 1.0f;
    _340.x = _264.x * _264.x;
    _340.x *= _340.x;
    _264.x = _340.x * _264.x;
    _340.x = (_264.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _366 = _25.z * _264.x;
    _366 *= _55_m6;
    _377 = _340.xxx * _293;
    _377 *= float3(float3(_55_m6, _55_m6, _55_m6));
    _377 *= 0.300000011920928955078125f.xxx;
    _270 = (_377 * _299) + _270;
    _264.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _264.x = rsqrt(_264.x);
    _340 = (vs_TEXCOORD4 * _264.xxx) + _164;
    _130 = _264.xxx * vs_TEXCOORD4;
    _264.x = dot(_340, _340);
    _264.x = rsqrt(_264.x);
    _264 = _264.xxx * _340;
    _264.x = dot(_205, _264);
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x = log2(_264.x);
    _264.x *= _25.y;
    _264.x = exp2(_264.x);
    _264.x = _25.x * _264.x;
    float3 _470 = (vs_TEXCOORD5 * _264.xxx) + _270;
    _25 = float4(_470.x, _470.y, _25.z, _470.z);
    _264.x = dot(-_164, _205);
    _264.x += _264.x;
    _264 = (_205 * (-_264.xxx)) + (-_164);
    _264.x = dot(_264, _130);
    _264.x = (_264.x * 0.5f) + 0.5f;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x *= _264.x;
    _264.x *= _264.x;
    _270 = (-_293) + vs_TEXCOORD5;
    _270 = (_264.xxx * _270) + _293;
    _257 *= _270;
    float3 _536 = (_257 * _366.xxx) + _25.xyw;
    _25 = float4(_536.x, _536.y, _536.z, _25.w);
    _264 = _25.xyz + (-_55_m2.xyz);
    _547 = vs_TEXCOORD6;
    _547 = clamp(_547, 0.0f, 1.0f);
    _264 = (_547.xxx * _264) + _55_m2.xyz;
    _109 = float4(_264.x, _264.y, _264.z, _109.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._109 = _109;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _22_m7[4];
float4x4 unity_WorldToObject;
static float4 _22_m8[4];
float4x4 unity_MatrixVP;
static float4 _22_m9[4];
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float _Atlas;
float _Fade;
void __unity_init()
{
    _22_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m8[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m8[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m8[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m8[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m9[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m9[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m9[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m9[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 unity_SHAr
#define _22_m1 unity_SHAg
#define _22_m2 unity_SHAb
#define _22_m3 unity_SHBr
#define _22_m4 unity_SHBg
#define _22_m5 unity_SHBb
#define _22_m6 unity_SHC
#define _22_m10 _VolumeMin
#define _22_m11 _VolumeInvSize
#define _22_m12 _GlobalVolumeMin
#define _22_m13 _GlobalVolumeInvSize
#define _22_m14 _Atlas
#define _22_m15 _Fade


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _99;
static float2 _178;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _99 : NORMAL;
    float2 _178 : TEXCOORD0;
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
static float4 _46;
static float4 _52;
static float _122;
static bool _145;
static float _150;
static bool _189;
static float4 _219;
static float4 _255;
static float4 _288;
static float4 _295;
static float3 _306;
static float _311;
static float _325;
static float _356;
static float _368;
static float3 _422;
static float2 _490;
static float _544;
static float3 _623;
static float3 _631;
static float4 _647;
static float3 _653;
static float _671;
static float _753;
static bool _757;
static float _795;
static float3 _824;
static float _839;
static float _901;
static float2 _950;
static float _1037;
static float3 _1087;
static bool _1122;
static float4 _1157;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m7[1];
    _9 = (_22_m7[0] * _11.xxxx) + _9;
    _9 = (_22_m7[2] * _11.zzzz) + _9;
    _46 = _9 + _22_m7[3];
    _52 = _46.yyyy * _22_m9[1];
    _52 = (_22_m9[0] * _46.xxxx) + _52;
    _52 = (_22_m9[2] * _46.zzzz) + _52;
    gl_Position = (_22_m9[3] * _46.wwww) + _52;
    float3 _95 = (_22_m7[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_95.x, _95.y, _95.z, _9.w);
    _46.x = dot(_99, _22_m8[0].xyz);
    _46.y = dot(_99, _22_m8[1].xyz);
    _46.z = dot(_99, _22_m8[2].xyz);
    _122 = dot(_46.xyz, _46.xyz);
    _122 = rsqrt(_122);
    float3 _134 = _122.xxx * _46.xyz;
    _46 = float4(_134.x, _134.y, _134.z, _46.w);
    _122 = _22_m14 * 0.5f;
    _145 = _122 >= (-_122);
    _150 = frac(abs(_122));
    float _156;
    if (_145)
    {
        _156 = _150;
    }
    else
    {
        _156 = -_150;
    }
    _52.x = _156;
    _52.x += _52.x;
    _52.y = floor(_122);
    float2 _180 = _52.xy + _178;
    _52 = float4(_180.x, _180.y, _52.z, _52.w);
    vs_TEXCOORD0 = _52.xy * 0.5f.xx;
    _189 = 1000000.0f < _22_m11.x;
    float3 _197;
    if (_189)
    {
        _197 = _22_m12;
    }
    else
    {
        _197 = _22_m10;
    }
    _52 = float4(_197.x, _197.y, _197.z, _52.w);
    float3 _216 = _9.xyz + (-_52.xyz);
    _52 = float4(_216.x, _216.y, _216.z, _52.w);
    float3 _221;
    if (_189)
    {
        _221 = _22_m13;
    }
    else
    {
        _221 = _22_m11;
    }
    _219 = float4(_221.x, _221.y, _221.z, _219.w);
    float3 _237 = _52.xyz * _219.xyz;
    _52 = float4(_237.x, _237.y, _237.z, _52.w);
    _219 = _Volume0.SampleLevel(sampler_Volume0, _52.xyz, 0.0f).xywz;
    _255 = _Volume1.SampleLevel(sampler_Volume0, _52.xyz, 0.0f).yxwz;
    _52 = _Volume2.SampleLevel(sampler_Volume0, _52.xyz, 0.0f).xzwy;
    _122 = _219.y + _219.x;
    _122 = _219.w + _122;
    _189 = 9.9999997473787516355514526367188e-06f < _122;
    if (_189)
    {
        float3 _292 = max(_219.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _288 = float4(_292.x, _292.y, _292.z, _288.w);
        _295.x = _255.y;
        _295.y = _52.x;
        _295.z = _219.z;
        _306 = _295.xyz * 0.5f.xxx;
        _311 = dot(_306, _306);
        _311 = sqrt(_311);
        float3 _322 = (_295.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _295 = float4(_322.x, _322.y, _322.z, _295.w);
        _325 = dot(_295.xyz, _295.xyz);
        _325 = rsqrt(_325);
        float3 _337 = _325.xxx * _295.xyz;
        _295 = float4(_337.x, _337.y, _337.z, _295.w);
        _295.x = dot(_295.xyz, _46.xyz);
        _295.x = (_295.x * 0.5f) + 0.5f;
        _295.x = clamp(_295.x, 0.0f, 1.0f);
        _356 = _311 + _311;
        _356 /= _288.x;
        _311 /= _288.x;
        _368 = (-_311) + 1.0f;
        _311 += 1.0f;
        _311 = _368 / _311;
        _295.z = (-_311) + 1.0f;
        float2 _385 = _356.xx + float2(1.0f, 2.0f);
        _295 = float4(_295.x, _385.x, _295.z, _385.y);
        _295.x = log2(_295.x);
        float2 _396 = _295.xw * _295.yz;
        _295 = float4(_396.x, _295.y, _396.y, _295.w);
        _295.x = exp2(_295.x);
        _311 = (_295.z * _295.x) + _311;
        _295.x = _311 * _288.x;
        _306 = float3(_255.xz.x, _306.y, _255.xz.y);
        _306.y = _52.w;
        _422 = _306 * 0.5f.xxx;
        _288.x = dot(_422, _422);
        _288.x = sqrt(_288.x);
        _306 = (_306 * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _311 = dot(_306, _306);
        _311 = rsqrt(_311);
        _306 = _311.xxx * _306;
        _311 = dot(_306, _46.xyz);
        _311 = (_311 * 0.5f) + 0.5f;
        _311 = clamp(_311, 0.0f, 1.0f);
        _325 = _288.x + _288.x;
        _325 /= _288.y;
        _288.x /= _288.y;
        _306.x = (-_288.x) + 1.0f;
        _288.x += 1.0f;
        _288.x = _306.x / _288.x;
        _306.x = (-_288.x) + 1.0f;
        _490 = _325.xx + float2(1.0f, 2.0f);
        _325 = _490.y * _306.x;
        _311 = log2(_311);
        _311 *= _490.x;
        _311 = exp2(_311);
        _288.x = (_325 * _311) + _288.x;
        _295.y = _288.x * _288.y;
        _306.x = _255.w;
        _306 = float3(_306.x, _52.yz.x, _52.yz.y);
        float3 _528 = _306 * 0.5f.xxx;
        _288 = float4(_528.x, _528.y, _288.z, _528.z);
        _288.x = dot(_288.xyw, _288.xyw);
        _288.x = sqrt(_288.x);
        _306 = (_306 * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _544 = dot(_306, _306);
        _544 = rsqrt(_544);
        _306 = _544.xxx * _306;
        _544 = dot(_306, _46.xyz);
        _544 = (_544 * 0.5f) + 0.5f;
        _544 = clamp(_544, 0.0f, 1.0f);
        _288.w = _288.x + _288.x;
        float2 _573 = _288.xw / _288.zz;
        _288 = float4(_573.x, _288.y, _288.z, _573.y);
        _325 = (-_288.x) + 1.0f;
        _288.x += 1.0f;
        _288.x = _325 / _288.x;
        _325 = (-_288.x) + 1.0f;
        float2 _595 = _288.ww + float2(1.0f, 2.0f);
        _306 = float3(_595.x, _595.y, _306.z);
        _311 = _325 * _306.y;
        _544 = log2(_544);
        _544 *= _306.x;
        _544 = exp2(_544);
        _288.x = (_311 * _544) + _288.x;
        _295.z = _288.x * _288.z;
        _623 = _295.xyz;
    }
    else
    {
        _623.x = 0.0f;
        _623.y = 0.0f;
        _623.z = 0.0f;
    }
    _46.w = 1.0f;
    _631.x = dot(_22_m0, _46);
    _631.y = dot(_22_m1, _46);
    _631.z = dot(_22_m2, _46);
    _647 = _46.yzzx * _46.xyzz;
    _653.x = dot(_22_m3, _647);
    _653.y = dot(_22_m4, _647);
    _653.z = dot(_22_m5, _647);
    _671 = _46.y * _46.y;
    _671 = (_46.x * _46.x) + (-_671);
    _653 = (_22_m6.xyz * _671.xxx) + _653;
    _631 += _653;
    float3 _698;
    if (_189)
    {
        _698 = _623;
    }
    else
    {
        _698 = _631;
    }
    _623 = _698;
    float3 _708 = max(_623, 0.0f.xxx);
    vs_TEXCOORD3 = float4(_708.x, _708.y, _708.z, vs_TEXCOORD3.w);
    if (_189)
    {
        float3 _716 = max(_219.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _295 = float4(_716.x, _716.y, _716.z, _295.w);
        _306 = _255.yxw / _295.xyz;
        _306.x = dot(_306, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _422 = _52.xwy / _295.xyz;
        _306.y = dot(_422, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _219.x = _255.z;
        _219.y = _52.z;
        _422 = _219.zxy / _295.xyz;
        _306.z = dot(_422, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _753 = dot(_306, _306);
        _757 = 9.9999999392252902907785028219223e-09f < _753;
        _753 = rsqrt(_753);
        _306 = _753.xxx * _306;
        float3 _768;
        if (_757)
        {
            _768 = _306;
        }
        else
        {
            _768 = float3(0.0f, 1.0f, 0.0f);
        }
        _306 = _768;
        _219.x = _255.y;
        _219.y = _52.x;
        _422 = _219.xyz * 0.5f.xxx;
        _753 = dot(_422, _422);
        _753 = sqrt(_753);
        float3 _792 = (_219.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _219 = float4(_792.x, _792.y, _792.z, _219.w);
        _795 = dot(_219.xyz, _219.xyz);
        _795 = rsqrt(_795);
        float3 _807 = _795.xxx * _219.xyz;
        _219 = float4(_807.x, _807.y, _807.z, _219.w);
        _219.x = dot(_219.xyz, _306);
        _219.x = (_219.x * 0.5f) + 0.5f;
        _219.x = clamp(_219.x, 0.0f, 1.0f);
        _824.x = _753 + _753;
        _824.x /= _295.x;
        _753 /= _295.x;
        _839 = (-_753) + 1.0f;
        _753 += 1.0f;
        _753 = _839 / _753;
        _219.z = (-_753) + 1.0f;
        float2 _854 = _824.xx + float2(1.0f, 2.0f);
        _219 = float4(_219.x, _854.x, _219.z, _854.y);
        _219.x = log2(_219.x);
        float2 _865 = _219.xw * _219.yz;
        _219 = float4(_865.x, _219.y, _865.y, _219.w);
        _219.x = exp2(_219.x);
        _753 = (_219.z * _219.x) + _753;
        _219.x = _753 * _295.x;
        _255.y = _52.w;
        _422 = _255.xyz * 0.5f.xxx;
        _753 = dot(_422, _422);
        _753 = sqrt(_753);
        float3 _898 = (_255.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _255 = float4(_898.x, _898.y, _898.z, _255.w);
        _901 = dot(_255.xyz, _255.xyz);
        _901 = rsqrt(_901);
        float3 _913 = _901.xxx * _255.xyz;
        _255 = float4(_913.x, _913.y, _913.z, _255.w);
        _901 = dot(_255.xyz, _306);
        _901 = (_901 * 0.5f) + 0.5f;
        _901 = clamp(_901, 0.0f, 1.0f);
        _795 = _753 + _753;
        _795 /= _295.y;
        _753 /= _295.y;
        _255.x = (-_753) + 1.0f;
        _753 += 1.0f;
        _753 = _255.x / _753;
        _255.x = (-_753) + 1.0f;
        _950 = _795.xx + float2(1.0f, 2.0f);
        _795 = _950.y * _255.x;
        _901 = log2(_901);
        _901 *= _950.x;
        _901 = exp2(_901);
        _753 = (_795 * _901) + _753;
        _219.y = _753 * _295.y;
        _52.x = _255.w;
        float3 _982 = _52.xyz * 0.5f.xxx;
        _255 = float4(_982.x, _982.y, _982.z, _255.w);
        _753 = dot(_255.xyz, _255.xyz);
        _753 = sqrt(_753);
        float3 _995 = (_52.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _52 = float4(_995.x, _995.y, _995.z, _52.w);
        _901 = dot(_52.xyz, _52.xyz);
        _901 = rsqrt(_901);
        float3 _1009 = _901.xxx * _52.xyz;
        _52 = float4(_1009.x, _1009.y, _1009.z, _52.w);
        _52.x = dot(_52.xyz, _306);
        _52.x = (_52.x * 0.5f) + 0.5f;
        _52.x = clamp(_52.x, 0.0f, 1.0f);
        _150 = _753 + _753;
        _150 /= _295.z;
        _753 /= _295.z;
        _1037 = (-_753) + 1.0f;
        _753 += 1.0f;
        _753 = _1037 / _753;
        _52.z = (-_753) + 1.0f;
        float2 _1052 = _150.xx + float2(1.0f, 2.0f);
        _52 = float4(_52.x, _1052.x, _52.z, _1052.y);
        _52.x = log2(_52.x);
        float2 _1063 = _52.xw * _52.yz;
        _52 = float4(_1063.x, _52.y, _1063.y, _52.w);
        _52.x = exp2(_52.x);
        _753 = (_52.z * _52.x) + _753;
        _219.z = _753 * _295.z;
        float3 _1084 = max(_219.xyz, 0.0f.xxx);
        _52 = float4(_1084.x, _1084.y, _1084.z, _52.w);
        _1087 = _52.xyz;
    }
    else
    {
        _306.x = 0.0f;
        _306.y = 1.0f;
        _306.z = 0.0f;
        _1087.x = 0.0f;
        _1087.y = 0.0f;
        _1087.z = 0.0f;
    }
    _623 = _22_m1.xyz * 0.715200006961822509765625f.xxx;
    _623 = (_22_m0.xyz * 0.2125999927520751953125f.xxx) + _623;
    _623 = (_22_m2.xyz * 0.072200000286102294921875f.xxx) + _623;
    _753 = dot(_623, _623);
    _1122 = 9.9999999392252902907785028219223e-09f < _753;
    _753 = rsqrt(_753);
    _824 = _753.xxx * _623;
    float3 _1132;
    if (_1122)
    {
        _1132 = _824;
    }
    else
    {
        _1132 = _306;
    }
    _219 = float4(_1132.x, _1132.y, _1132.z, _219.w);
    _219.w = 1.0f;
    _623.x = dot(_22_m0, _219);
    _623.y = dot(_22_m1, _219);
    _623.z = dot(_22_m2, _219);
    _1157 = _219.yzzx * _219.xyzz;
    _631.x = dot(_22_m3, _1157);
    _631.y = dot(_22_m4, _1157);
    _631.z = dot(_22_m5, _1157);
    _671 = _219.y * _219.y;
    _671 = (_219.x * _219.x) + (-_671);
    _631 = (_22_m6.xyz * _671.xxx) + _631;
    _623 += _631;
    _623 = max(_623, 0.0f.xxx);
    float3 _1207;
    if (_189)
    {
        _1207 = _306;
    }
    else
    {
        _1207 = _219.xyz;
    }
    vs_TEXCOORD4 = _1207;
    float3 _1217;
    if (_189)
    {
        _1217 = _1087;
    }
    else
    {
        _1217 = _623;
    }
    vs_TEXCOORD5 = _1217;
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD2 = _46.xyz;
    vs_TEXCOORD3.w = _22_m15;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _178 = stage_input._178;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SplatTint;
float _Cutoff;
float _Smoothness;
float _Specular;
float _Sheen;
#define _55_m0 _WorldSpaceCameraPos
#define _55_m1 _WorldSpaceLightPos0
#define _55_m2 _LightColor0
#define _55_m3 _SplatTint
#define _55_m4 _Cutoff
#define _55_m5 _Smoothness
#define _55_m6 _Specular
#define _55_m7 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 _109;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

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
    float4 _109 : SV_Target0;
};

static float4 _9;
static float4 _25;
static float _34;
static bool _116;
static float3 _130;
static float3 _140;
static float3 _164;
static float _173;
static float3 _179;
static float3 _205;
static float3 _257;
static float3 _264;
static float3 _270;
static float3 _293;
static float3 _299;
static float3 _340;
static float _366;
static float3 _377;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _25.x = ddx_coarse(_9.w);
    _34 = ddy_coarse(_9.w);
    _25.x = abs(_34) + abs(_25.x);
    _25.x = max(_25.x, 0.001000000047497451305389404296875f);
    _34 = _9.w + (-_55_m4);
    _25.x = _34 / _25.x;
    _25.x += 0.5f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = _9.w * _25.x;
    _25.x *= _55_m3.w;
    _34 = (_25.x * vs_TEXCOORD3.w) + (-0.0040000001899898052215576171875f);
    _25.x *= vs_TEXCOORD3.w;
    _109.w = _25.x;
    _116 = _34 < 0.0f;
    if ((int(_116) * (-1)) != 0)
    {
        discard;
    }
    _130.x = dot(_55_m1.xyz, _55_m1.xyz);
    _140.x = rsqrt(_130.x);
    _116 = 9.9999999747524270787835121154785e-07f < _130.x;
    _140 = _140.xxx * _55_m1.xyz;
    float3 _157;
    if (_116)
    {
        _157 = _140;
    }
    else
    {
        _157 = float3(0.0f, 1.0f, 0.0f);
    }
    _130 = _157;
    _164 = (-vs_TEXCOORD1) + _55_m0;
    _173 = dot(_164, _164);
    _173 = rsqrt(_173);
    _179 = (_164 * _173.xxx) + _130;
    _164 = _173.xxx * _164;
    _173 = dot(_179, _179);
    _173 = rsqrt(_173);
    _179 = _173.xxx * _179;
    _173 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _173 = rsqrt(_173);
    _205 = _173.xxx * vs_TEXCOORD2;
    _173 = dot(_205, _179);
    _173 = clamp(_173, 0.0f, 1.0f);
    _173 = log2(_173);
    float2 _231 = (float2(float2(_55_m5, _55_m5)) * float2(10.0f, 7.0f)) + 1.0f.xx;
    _25 = float4(_231.x, _231.y, _25.z, _25.w);
    float2 _236 = exp2(_25.xy);
    _25 = float4(_236.x, _236.y, _25.z, _25.w);
    _173 *= _25.x;
    _173 = exp2(_173);
    float2 _254 = _9.ww * float2(_55_m6, _55_m7);
    _25 = float4(_254.x, _25.y, _254.y, _25.w);
    _257 = _9.xyz * _55_m3.xyz;
    _264.x = _25.x * _173;
    _270 = _264.xxx * _55_m2.xyz;
    _264.x = dot(_205, _130);
    _264.x = (_264.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _293 = max(vs_TEXCOORD3.xyz, 0.2199999988079071044921875f.xxx);
    _299 = (_55_m2.xyz * _264.xxx) + _293;
    _270 = (_257 * _299) + _270;
    _299 = (_257 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _257 = (_257 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _264.x = dot(_205, _164);
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x = (-_264.x) + 1.0f;
    _340.x = _264.x * _264.x;
    _340.x *= _340.x;
    _264.x = _340.x * _264.x;
    _340.x = (_264.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _366 = _25.z * _264.x;
    _366 *= _55_m5;
    _377 = _340.xxx * _293;
    _377 *= float3(float3(_55_m5, _55_m5, _55_m5));
    _377 *= 0.300000011920928955078125f.xxx;
    _270 = (_377 * _299) + _270;
    _264.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _264.x = rsqrt(_264.x);
    _340 = (vs_TEXCOORD4 * _264.xxx) + _164;
    _130 = _264.xxx * vs_TEXCOORD4;
    _264.x = dot(_340, _340);
    _264.x = rsqrt(_264.x);
    _264 = _264.xxx * _340;
    _264.x = dot(_205, _264);
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x = log2(_264.x);
    _264.x *= _25.y;
    _264.x = exp2(_264.x);
    _264.x = _25.x * _264.x;
    float3 _470 = (vs_TEXCOORD5 * _264.xxx) + _270;
    _25 = float4(_470.x, _470.y, _25.z, _470.z);
    _264.x = dot(-_164, _205);
    _264.x += _264.x;
    _264 = (_205 * (-_264.xxx)) + (-_164);
    _264.x = dot(_264, _130);
    _264.x = (_264.x * 0.5f) + 0.5f;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _264.x *= _264.x;
    _264.x *= _264.x;
    _270 = (-_293) + vs_TEXCOORD5;
    _270 = (_264.xxx * _270) + _293;
    _257 *= _270;
    float3 _536 = (_257 * _366.xxx) + _25.xyw;
    _109 = float4(_536.x, _536.y, _536.z, _109.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._109 = _109;
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
float _Atlas;
float _Fade;
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
#define _21_m12 _Atlas
#define _21_m13 _Fade



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float2 _183;
static float2 vs_TEXCOORD0;
static float3 _195;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _195 : NORMAL;
    float2 _183 : TEXCOORD0;
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
static bool _146;
static float _153;
static float _215;
static float3 _234;
static float4 _251;
static float3 _257;
static float3 _341;
static bool _346;

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
    _9.x = _21_m12 * 0.5f;
    _146 = _9.x >= (-_9.x);
    _153 = frac(abs(_9.x));
    _45.y = floor(_9.x);
    float _164;
    if (_146)
    {
        _164 = _153;
    }
    else
    {
        _164 = -_153;
    }
    _9.x = _164;
    _45.x = _9.x + _9.x;
    float2 _185 = _45.xy + _183;
    _9 = float4(_185.x, _185.y, _9.z, _9.w);
    vs_TEXCOORD0 = _9.xy * 0.5f.xx;
    _9.x = dot(_195, _21_m9[0].xyz);
    _9.y = dot(_195, _21_m9[1].xyz);
    _9.z = dot(_195, _21_m9[2].xyz);
    _215 = dot(_9.xyz, _9.xyz);
    _215 = rsqrt(_215);
    float3 _227 = _215.xxx * _9.xyz;
    _9 = float4(_227.x, _227.y, _227.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _234.x = _9.y * _9.y;
    _234.x = (_9.x * _9.x) + (-_234.x);
    _251 = _9.yzzx * _9.xyzz;
    _257.x = dot(_21_m4, _251);
    _257.y = dot(_21_m5, _251);
    _257.z = dot(_21_m6, _251);
    _234 = (_21_m7.xyz * _234.xxx) + _257;
    _9.w = 1.0f;
    _257.x = dot(_21_m1, _9);
    _257.y = dot(_21_m2, _9);
    _257.z = dot(_21_m3, _9);
    _234 += _257;
    float3 _308 = max(_234, 0.0f.xxx);
    vs_TEXCOORD3 = float4(_308.x, _308.y, _308.z, vs_TEXCOORD3.w);
    vs_TEXCOORD3.w = _21_m13;
    _234 = _21_m2.xyz * 0.715200006961822509765625f.xxx;
    _234 = (_21_m1.xyz * 0.2125999927520751953125f.xxx) + _234;
    _234 = (_21_m3.xyz * 0.072200000286102294921875f.xxx) + _234;
    _9.x = dot(_234, _234);
    _341.x = rsqrt(_9.x);
    _346 = 9.9999999392252902907785028219223e-09f < _9.x;
    _341 = _341.xxx * _234;
    float3 _357;
    if (_346)
    {
        _357 = _341;
    }
    else
    {
        _357 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_357.x, _357.y, _357.z, _9.w);
    vs_TEXCOORD4 = _9.xyz;
    _234.x = _9.y * _9.y;
    _234.x = (_9.x * _9.x) + (-_234.x);
    _251 = _9.yzzx * _9.xyzz;
    _257.x = dot(_21_m4, _251);
    _257.y = dot(_21_m5, _251);
    _257.z = dot(_21_m6, _251);
    _234 = (_21_m7.xyz * _234.xxx) + _257;
    _9.w = 1.0f;
    _257.x = dot(_21_m1, _9);
    _257.y = dot(_21_m2, _9);
    _257.z = dot(_21_m3, _9);
    _234 += _257;
    vs_TEXCOORD5 = max(_234, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _183 = stage_input._183;
    _195 = stage_input._195;
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
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SplatTint;
float _Cutoff;
float _Smoothness;
float _Specular;
float _Sheen;
#define _50_m0 _WorldSpaceCameraPos
#define _50_m1 _WorldSpaceLightPos0
#define _50_m2 unity_FogColor
#define _50_m3 _LightColor0
#define _50_m4 _SplatTint
#define _50_m5 _Cutoff
#define _50_m6 _Smoothness
#define _50_m7 _Specular
#define _50_m8 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 _104;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD6;

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
    float4 _104 : SV_Target0;
};

static float4 _9;
static float4 _20;
static float _29;
static bool _111;
static float3 _125;
static float3 _135;
static float3 _159;
static float _168;
static float3 _174;
static float3 _200;
static float3 _252;
static float3 _259;
static float3 _265;
static float3 _288;
static float3 _294;
static float3 _335;
static float _361;
static float3 _372;
static float _542;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20.x = ddx_coarse(_9.w);
    _29 = ddy_coarse(_9.w);
    _20.x = abs(_29) + abs(_20.x);
    _20.x = max(_20.x, 0.001000000047497451305389404296875f);
    _29 = _9.w + (-_50_m5);
    _20.x = _29 / _20.x;
    _20.x += 0.5f;
    _20.x = clamp(_20.x, 0.0f, 1.0f);
    _20.x = _9.w * _20.x;
    _20.x *= _50_m4.w;
    _29 = (_20.x * vs_TEXCOORD3.w) + (-0.0040000001899898052215576171875f);
    _20.x *= vs_TEXCOORD3.w;
    _104.w = _20.x;
    _111 = _29 < 0.0f;
    if ((int(_111) * (-1)) != 0)
    {
        discard;
    }
    _125.x = dot(_50_m1.xyz, _50_m1.xyz);
    _135.x = rsqrt(_125.x);
    _111 = 9.9999999747524270787835121154785e-07f < _125.x;
    _135 = _135.xxx * _50_m1.xyz;
    float3 _152;
    if (_111)
    {
        _152 = _135;
    }
    else
    {
        _152 = float3(0.0f, 1.0f, 0.0f);
    }
    _125 = _152;
    _159 = (-vs_TEXCOORD1) + _50_m0;
    _168 = dot(_159, _159);
    _168 = rsqrt(_168);
    _174 = (_159 * _168.xxx) + _125;
    _159 = _168.xxx * _159;
    _168 = dot(_174, _174);
    _168 = rsqrt(_168);
    _174 = _168.xxx * _174;
    _168 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _168 = rsqrt(_168);
    _200 = _168.xxx * vs_TEXCOORD2;
    _168 = dot(_200, _174);
    _168 = clamp(_168, 0.0f, 1.0f);
    _168 = log2(_168);
    float2 _226 = (float2(float2(_50_m6, _50_m6)) * float2(10.0f, 7.0f)) + 1.0f.xx;
    _20 = float4(_226.x, _226.y, _20.z, _20.w);
    float2 _231 = exp2(_20.xy);
    _20 = float4(_231.x, _231.y, _20.z, _20.w);
    _168 *= _20.x;
    _168 = exp2(_168);
    float2 _249 = _9.ww * float2(_50_m7, _50_m8);
    _20 = float4(_249.x, _20.y, _249.y, _20.w);
    _252 = _9.xyz * _50_m4.xyz;
    _259.x = _20.x * _168;
    _265 = _259.xxx * _50_m3.xyz;
    _259.x = dot(_200, _125);
    _259.x = (_259.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _288 = max(vs_TEXCOORD3.xyz, 0.2199999988079071044921875f.xxx);
    _294 = (_50_m3.xyz * _259.xxx) + _288;
    _265 = (_252 * _294) + _265;
    _294 = (_252 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _252 = (_252 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _259.x = dot(_200, _159);
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x = (-_259.x) + 1.0f;
    _335.x = _259.x * _259.x;
    _335.x *= _335.x;
    _259.x = _335.x * _259.x;
    _335.x = (_259.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _361 = _20.z * _259.x;
    _361 *= _50_m6;
    _372 = _335.xxx * _288;
    _372 *= float3(float3(_50_m6, _50_m6, _50_m6));
    _372 *= 0.300000011920928955078125f.xxx;
    _265 = (_372 * _294) + _265;
    _259.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _259.x = rsqrt(_259.x);
    _335 = (vs_TEXCOORD4 * _259.xxx) + _159;
    _125 = _259.xxx * vs_TEXCOORD4;
    _259.x = dot(_335, _335);
    _259.x = rsqrt(_259.x);
    _259 = _259.xxx * _335;
    _259.x = dot(_200, _259);
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x = log2(_259.x);
    _259.x *= _20.y;
    _259.x = exp2(_259.x);
    _259.x = _20.x * _259.x;
    float3 _465 = (vs_TEXCOORD5 * _259.xxx) + _265;
    _20 = float4(_465.x, _465.y, _20.z, _465.z);
    _259.x = dot(-_159, _200);
    _259.x += _259.x;
    _259 = (_200 * (-_259.xxx)) + (-_159);
    _259.x = dot(_259, _125);
    _259.x = (_259.x * 0.5f) + 0.5f;
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x *= _259.x;
    _259.x *= _259.x;
    _265 = (-_288) + vs_TEXCOORD5;
    _265 = (_259.xxx * _265) + _288;
    _252 *= _265;
    float3 _531 = (_252 * _361.xxx) + _20.xyw;
    _20 = float4(_531.x, _531.y, _531.z, _20.w);
    _259 = _20.xyz + (-_50_m2.xyz);
    _542 = vs_TEXCOORD6;
    _542 = clamp(_542, 0.0f, 1.0f);
    _259 = (_542.xxx * _259) + _50_m2.xyz;
    _104 = float4(_259.x, _259.y, _259.z, _104.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._104 = _104;
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
float _Atlas;
float _Fade;
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
#define _21_m12 _Atlas
#define _21_m13 _Fade



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float2 _189;
static float2 vs_TEXCOORD0;
static float3 _201;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _201 : NORMAL;
    float2 _189 : TEXCOORD0;
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
static bool _152;
static float _159;
static float _221;
static float3 _240;
static float4 _257;
static float3 _263;
static float3 _347;
static bool _352;

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
    _9.x = _21_m12 * 0.5f;
    _152 = _9.x >= (-_9.x);
    _159 = frac(abs(_9.x));
    _45.y = floor(_9.x);
    float _170;
    if (_152)
    {
        _170 = _159;
    }
    else
    {
        _170 = -_159;
    }
    _9.x = _170;
    _45.x = _9.x + _9.x;
    float2 _191 = _45.xy + _189;
    _9 = float4(_191.x, _191.y, _9.z, _9.w);
    vs_TEXCOORD0 = _9.xy * 0.5f.xx;
    _9.x = dot(_201, _21_m9[0].xyz);
    _9.y = dot(_201, _21_m9[1].xyz);
    _9.z = dot(_201, _21_m9[2].xyz);
    _221 = dot(_9.xyz, _9.xyz);
    _221 = rsqrt(_221);
    float3 _233 = _221.xxx * _9.xyz;
    _9 = float4(_233.x, _233.y, _233.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _240.x = _9.y * _9.y;
    _240.x = (_9.x * _9.x) + (-_240.x);
    _257 = _9.yzzx * _9.xyzz;
    _263.x = dot(_21_m4, _257);
    _263.y = dot(_21_m5, _257);
    _263.z = dot(_21_m6, _257);
    _240 = (_21_m7.xyz * _240.xxx) + _263;
    _9.w = 1.0f;
    _263.x = dot(_21_m1, _9);
    _263.y = dot(_21_m2, _9);
    _263.z = dot(_21_m3, _9);
    _240 += _263;
    float3 _314 = max(_240, 0.0f.xxx);
    vs_TEXCOORD3 = float4(_314.x, _314.y, _314.z, vs_TEXCOORD3.w);
    vs_TEXCOORD3.w = _21_m13;
    _240 = _21_m2.xyz * 0.715200006961822509765625f.xxx;
    _240 = (_21_m1.xyz * 0.2125999927520751953125f.xxx) + _240;
    _240 = (_21_m3.xyz * 0.072200000286102294921875f.xxx) + _240;
    _9.x = dot(_240, _240);
    _347.x = rsqrt(_9.x);
    _352 = 9.9999999392252902907785028219223e-09f < _9.x;
    _347 = _347.xxx * _240;
    float3 _363;
    if (_352)
    {
        _363 = _347;
    }
    else
    {
        _363 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_363.x, _363.y, _363.z, _9.w);
    vs_TEXCOORD4 = _9.xyz;
    _240.x = _9.y * _9.y;
    _240.x = (_9.x * _9.x) + (-_240.x);
    _257 = _9.yzzx * _9.xyzz;
    _263.x = dot(_21_m4, _257);
    _263.y = dot(_21_m5, _257);
    _263.z = dot(_21_m6, _257);
    _240 = (_21_m7.xyz * _240.xxx) + _263;
    _9.w = 1.0f;
    _263.x = dot(_21_m1, _9);
    _263.y = dot(_21_m2, _9);
    _263.z = dot(_21_m3, _9);
    _240 += _263;
    vs_TEXCOORD5 = max(_240, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _189 = stage_input._189;
    _201 = stage_input._201;
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
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SplatTint;
float _Cutoff;
float _Smoothness;
float _Specular;
float _Sheen;
#define _50_m0 _WorldSpaceCameraPos
#define _50_m1 _WorldSpaceLightPos0
#define _50_m2 unity_FogColor
#define _50_m3 _LightColor0
#define _50_m4 _SplatTint
#define _50_m5 _Cutoff
#define _50_m6 _Smoothness
#define _50_m7 _Specular
#define _50_m8 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 _104;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD6;

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
    float4 _104 : SV_Target0;
};

static float4 _9;
static float4 _20;
static float _29;
static bool _111;
static float3 _125;
static float3 _135;
static float3 _159;
static float _168;
static float3 _174;
static float3 _200;
static float3 _252;
static float3 _259;
static float3 _265;
static float3 _288;
static float3 _294;
static float3 _335;
static float _361;
static float3 _372;
static float _542;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20.x = ddx_coarse(_9.w);
    _29 = ddy_coarse(_9.w);
    _20.x = abs(_29) + abs(_20.x);
    _20.x = max(_20.x, 0.001000000047497451305389404296875f);
    _29 = _9.w + (-_50_m5);
    _20.x = _29 / _20.x;
    _20.x += 0.5f;
    _20.x = clamp(_20.x, 0.0f, 1.0f);
    _20.x = _9.w * _20.x;
    _20.x *= _50_m4.w;
    _29 = (_20.x * vs_TEXCOORD3.w) + (-0.0040000001899898052215576171875f);
    _20.x *= vs_TEXCOORD3.w;
    _104.w = _20.x;
    _111 = _29 < 0.0f;
    if ((int(_111) * (-1)) != 0)
    {
        discard;
    }
    _125.x = dot(_50_m1.xyz, _50_m1.xyz);
    _135.x = rsqrt(_125.x);
    _111 = 9.9999999747524270787835121154785e-07f < _125.x;
    _135 = _135.xxx * _50_m1.xyz;
    float3 _152;
    if (_111)
    {
        _152 = _135;
    }
    else
    {
        _152 = float3(0.0f, 1.0f, 0.0f);
    }
    _125 = _152;
    _159 = (-vs_TEXCOORD1) + _50_m0;
    _168 = dot(_159, _159);
    _168 = rsqrt(_168);
    _174 = (_159 * _168.xxx) + _125;
    _159 = _168.xxx * _159;
    _168 = dot(_174, _174);
    _168 = rsqrt(_168);
    _174 = _168.xxx * _174;
    _168 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _168 = rsqrt(_168);
    _200 = _168.xxx * vs_TEXCOORD2;
    _168 = dot(_200, _174);
    _168 = clamp(_168, 0.0f, 1.0f);
    _168 = log2(_168);
    float2 _226 = (float2(float2(_50_m6, _50_m6)) * float2(10.0f, 7.0f)) + 1.0f.xx;
    _20 = float4(_226.x, _226.y, _20.z, _20.w);
    float2 _231 = exp2(_20.xy);
    _20 = float4(_231.x, _231.y, _20.z, _20.w);
    _168 *= _20.x;
    _168 = exp2(_168);
    float2 _249 = _9.ww * float2(_50_m7, _50_m8);
    _20 = float4(_249.x, _20.y, _249.y, _20.w);
    _252 = _9.xyz * _50_m4.xyz;
    _259.x = _20.x * _168;
    _265 = _259.xxx * _50_m3.xyz;
    _259.x = dot(_200, _125);
    _259.x = (_259.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _288 = max(vs_TEXCOORD3.xyz, 0.2199999988079071044921875f.xxx);
    _294 = (_50_m3.xyz * _259.xxx) + _288;
    _265 = (_252 * _294) + _265;
    _294 = (_252 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _252 = (_252 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _259.x = dot(_200, _159);
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x = (-_259.x) + 1.0f;
    _335.x = _259.x * _259.x;
    _335.x *= _335.x;
    _259.x = _335.x * _259.x;
    _335.x = (_259.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _361 = _20.z * _259.x;
    _361 *= _50_m6;
    _372 = _335.xxx * _288;
    _372 *= float3(float3(_50_m6, _50_m6, _50_m6));
    _372 *= 0.300000011920928955078125f.xxx;
    _265 = (_372 * _294) + _265;
    _259.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _259.x = rsqrt(_259.x);
    _335 = (vs_TEXCOORD4 * _259.xxx) + _159;
    _125 = _259.xxx * vs_TEXCOORD4;
    _259.x = dot(_335, _335);
    _259.x = rsqrt(_259.x);
    _259 = _259.xxx * _335;
    _259.x = dot(_200, _259);
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x = log2(_259.x);
    _259.x *= _20.y;
    _259.x = exp2(_259.x);
    _259.x = _20.x * _259.x;
    float3 _465 = (vs_TEXCOORD5 * _259.xxx) + _265;
    _20 = float4(_465.x, _465.y, _20.z, _465.z);
    _259.x = dot(-_159, _200);
    _259.x += _259.x;
    _259 = (_200 * (-_259.xxx)) + (-_159);
    _259.x = dot(_259, _125);
    _259.x = (_259.x * 0.5f) + 0.5f;
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x *= _259.x;
    _259.x *= _259.x;
    _265 = (-_288) + vs_TEXCOORD5;
    _265 = (_259.xxx * _265) + _288;
    _252 *= _265;
    float3 _531 = (_252 * _361.xxx) + _20.xyw;
    _20 = float4(_531.x, _531.y, _531.z, _20.w);
    _259 = _20.xyz + (-_50_m2.xyz);
    _542 = vs_TEXCOORD6;
    _542 = clamp(_542, 0.0f, 1.0f);
    _259 = (_542.xxx * _259) + _50_m2.xyz;
    _104 = float4(_259.x, _259.y, _259.z, _104.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._104 = _104;
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
float _Atlas;
float _Fade;
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
#define _21_m12 _Atlas
#define _21_m13 _Fade



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD6;
static float2 _182;
static float2 vs_TEXCOORD0;
static float3 _194;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _194 : NORMAL;
    float2 _182 : TEXCOORD0;
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
static bool _145;
static float _152;
static float _214;
static float3 _233;
static float4 _250;
static float3 _256;
static float3 _339;
static bool _344;

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
    _9.x = _21_m12 * 0.5f;
    _145 = _9.x >= (-_9.x);
    _152 = frac(abs(_9.x));
    _45.y = floor(_9.x);
    float _163;
    if (_145)
    {
        _163 = _152;
    }
    else
    {
        _163 = -_152;
    }
    _9.x = _163;
    _45.x = _9.x + _9.x;
    float2 _184 = _45.xy + _182;
    _9 = float4(_184.x, _184.y, _9.z, _9.w);
    vs_TEXCOORD0 = _9.xy * 0.5f.xx;
    _9.x = dot(_194, _21_m9[0].xyz);
    _9.y = dot(_194, _21_m9[1].xyz);
    _9.z = dot(_194, _21_m9[2].xyz);
    _214 = dot(_9.xyz, _9.xyz);
    _214 = rsqrt(_214);
    float3 _226 = _214.xxx * _9.xyz;
    _9 = float4(_226.x, _226.y, _226.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _233.x = _9.y * _9.y;
    _233.x = (_9.x * _9.x) + (-_233.x);
    _250 = _9.yzzx * _9.xyzz;
    _256.x = dot(_21_m4, _250);
    _256.y = dot(_21_m5, _250);
    _256.z = dot(_21_m6, _250);
    _233 = (_21_m7.xyz * _233.xxx) + _256;
    _9.w = 1.0f;
    _256.x = dot(_21_m1, _9);
    _256.y = dot(_21_m2, _9);
    _256.z = dot(_21_m3, _9);
    _233 += _256;
    float3 _306 = max(_233, 0.0f.xxx);
    vs_TEXCOORD3 = float4(_306.x, _306.y, _306.z, vs_TEXCOORD3.w);
    vs_TEXCOORD3.w = _21_m13;
    _233 = _21_m2.xyz * 0.715200006961822509765625f.xxx;
    _233 = (_21_m1.xyz * 0.2125999927520751953125f.xxx) + _233;
    _233 = (_21_m3.xyz * 0.072200000286102294921875f.xxx) + _233;
    _9.x = dot(_233, _233);
    _339.x = rsqrt(_9.x);
    _344 = 9.9999999392252902907785028219223e-09f < _9.x;
    _339 = _339.xxx * _233;
    float3 _355;
    if (_344)
    {
        _355 = _339;
    }
    else
    {
        _355 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_355.x, _355.y, _355.z, _9.w);
    vs_TEXCOORD4 = _9.xyz;
    _233.x = _9.y * _9.y;
    _233.x = (_9.x * _9.x) + (-_233.x);
    _250 = _9.yzzx * _9.xyzz;
    _256.x = dot(_21_m4, _250);
    _256.y = dot(_21_m5, _250);
    _256.z = dot(_21_m6, _250);
    _233 = (_21_m7.xyz * _233.xxx) + _256;
    _9.w = 1.0f;
    _256.x = dot(_21_m1, _9);
    _256.y = dot(_21_m2, _9);
    _256.z = dot(_21_m3, _9);
    _233 += _256;
    vs_TEXCOORD5 = max(_233, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _182 = stage_input._182;
    _194 = stage_input._194;
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
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SplatTint;
float _Cutoff;
float _Smoothness;
float _Specular;
float _Sheen;
#define _50_m0 _WorldSpaceCameraPos
#define _50_m1 _WorldSpaceLightPos0
#define _50_m2 unity_FogColor
#define _50_m3 _LightColor0
#define _50_m4 _SplatTint
#define _50_m5 _Cutoff
#define _50_m6 _Smoothness
#define _50_m7 _Specular
#define _50_m8 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 _104;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD6;

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
    float4 _104 : SV_Target0;
};

static float4 _9;
static float4 _20;
static float _29;
static bool _111;
static float3 _125;
static float3 _135;
static float3 _159;
static float _168;
static float3 _174;
static float3 _200;
static float3 _252;
static float3 _259;
static float3 _265;
static float3 _288;
static float3 _294;
static float3 _335;
static float _361;
static float3 _372;
static float _542;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20.x = ddx_coarse(_9.w);
    _29 = ddy_coarse(_9.w);
    _20.x = abs(_29) + abs(_20.x);
    _20.x = max(_20.x, 0.001000000047497451305389404296875f);
    _29 = _9.w + (-_50_m5);
    _20.x = _29 / _20.x;
    _20.x += 0.5f;
    _20.x = clamp(_20.x, 0.0f, 1.0f);
    _20.x = _9.w * _20.x;
    _20.x *= _50_m4.w;
    _29 = (_20.x * vs_TEXCOORD3.w) + (-0.0040000001899898052215576171875f);
    _20.x *= vs_TEXCOORD3.w;
    _104.w = _20.x;
    _111 = _29 < 0.0f;
    if ((int(_111) * (-1)) != 0)
    {
        discard;
    }
    _125.x = dot(_50_m1.xyz, _50_m1.xyz);
    _135.x = rsqrt(_125.x);
    _111 = 9.9999999747524270787835121154785e-07f < _125.x;
    _135 = _135.xxx * _50_m1.xyz;
    float3 _152;
    if (_111)
    {
        _152 = _135;
    }
    else
    {
        _152 = float3(0.0f, 1.0f, 0.0f);
    }
    _125 = _152;
    _159 = (-vs_TEXCOORD1) + _50_m0;
    _168 = dot(_159, _159);
    _168 = rsqrt(_168);
    _174 = (_159 * _168.xxx) + _125;
    _159 = _168.xxx * _159;
    _168 = dot(_174, _174);
    _168 = rsqrt(_168);
    _174 = _168.xxx * _174;
    _168 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _168 = rsqrt(_168);
    _200 = _168.xxx * vs_TEXCOORD2;
    _168 = dot(_200, _174);
    _168 = clamp(_168, 0.0f, 1.0f);
    _168 = log2(_168);
    float2 _226 = (float2(float2(_50_m6, _50_m6)) * float2(10.0f, 7.0f)) + 1.0f.xx;
    _20 = float4(_226.x, _226.y, _20.z, _20.w);
    float2 _231 = exp2(_20.xy);
    _20 = float4(_231.x, _231.y, _20.z, _20.w);
    _168 *= _20.x;
    _168 = exp2(_168);
    float2 _249 = _9.ww * float2(_50_m7, _50_m8);
    _20 = float4(_249.x, _20.y, _249.y, _20.w);
    _252 = _9.xyz * _50_m4.xyz;
    _259.x = _20.x * _168;
    _265 = _259.xxx * _50_m3.xyz;
    _259.x = dot(_200, _125);
    _259.x = (_259.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _288 = max(vs_TEXCOORD3.xyz, 0.2199999988079071044921875f.xxx);
    _294 = (_50_m3.xyz * _259.xxx) + _288;
    _265 = (_252 * _294) + _265;
    _294 = (_252 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _252 = (_252 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _259.x = dot(_200, _159);
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x = (-_259.x) + 1.0f;
    _335.x = _259.x * _259.x;
    _335.x *= _335.x;
    _259.x = _335.x * _259.x;
    _335.x = (_259.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _361 = _20.z * _259.x;
    _361 *= _50_m6;
    _372 = _335.xxx * _288;
    _372 *= float3(float3(_50_m6, _50_m6, _50_m6));
    _372 *= 0.300000011920928955078125f.xxx;
    _265 = (_372 * _294) + _265;
    _259.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _259.x = rsqrt(_259.x);
    _335 = (vs_TEXCOORD4 * _259.xxx) + _159;
    _125 = _259.xxx * vs_TEXCOORD4;
    _259.x = dot(_335, _335);
    _259.x = rsqrt(_259.x);
    _259 = _259.xxx * _335;
    _259.x = dot(_200, _259);
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x = log2(_259.x);
    _259.x *= _20.y;
    _259.x = exp2(_259.x);
    _259.x = _20.x * _259.x;
    float3 _465 = (vs_TEXCOORD5 * _259.xxx) + _265;
    _20 = float4(_465.x, _465.y, _20.z, _465.z);
    _259.x = dot(-_159, _200);
    _259.x += _259.x;
    _259 = (_200 * (-_259.xxx)) + (-_159);
    _259.x = dot(_259, _125);
    _259.x = (_259.x * 0.5f) + 0.5f;
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x *= _259.x;
    _259.x *= _259.x;
    _265 = (-_288) + vs_TEXCOORD5;
    _265 = (_259.xxx * _265) + _288;
    _252 *= _265;
    float3 _531 = (_252 * _361.xxx) + _20.xyw;
    _20 = float4(_531.x, _531.y, _531.z, _20.w);
    _259 = _20.xyz + (-_50_m2.xyz);
    _542 = vs_TEXCOORD6;
    _542 = clamp(_542, 0.0f, 1.0f);
    _259 = (_542.xxx * _259) + _50_m2.xyz;
    _104 = float4(_259.x, _259.y, _259.z, _104.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._104 = _104;
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
float _Atlas;
float _Fade;
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
#define _21_m10 _Atlas
#define _21_m11 _Fade



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 _145;
static float2 vs_TEXCOORD0;
static float3 _157;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _157 : NORMAL;
    float2 _145 : TEXCOORD0;
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
static bool _108;
static float _115;
static float _178;
static float3 _197;
static float4 _214;
static float3 _220;
static float3 _306;
static bool _311;

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
    _9.x = _21_m10 * 0.5f;
    _108 = _9.x >= (-_9.x);
    _115 = frac(abs(_9.x));
    _45.y = floor(_9.x);
    float _126;
    if (_108)
    {
        _126 = _115;
    }
    else
    {
        _126 = -_115;
    }
    _9.x = _126;
    _45.x = _9.x + _9.x;
    float2 _147 = _45.xy + _145;
    _9 = float4(_147.x, _147.y, _9.z, _9.w);
    vs_TEXCOORD0 = _9.xy * 0.5f.xx;
    _9.x = dot(_157, _21_m8[0].xyz);
    _9.y = dot(_157, _21_m8[1].xyz);
    _9.z = dot(_157, _21_m8[2].xyz);
    _178 = dot(_9.xyz, _9.xyz);
    _178 = rsqrt(_178);
    float3 _190 = _178.xxx * _9.xyz;
    _9 = float4(_190.x, _190.y, _190.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
    _197.x = _9.y * _9.y;
    _197.x = (_9.x * _9.x) + (-_197.x);
    _214 = _9.yzzx * _9.xyzz;
    _220.x = dot(_21_m3, _214);
    _220.y = dot(_21_m4, _214);
    _220.z = dot(_21_m5, _214);
    _197 = (_21_m6.xyz * _197.xxx) + _220;
    _9.w = 1.0f;
    _220.x = dot(_21_m0, _9);
    _220.y = dot(_21_m1, _9);
    _220.z = dot(_21_m2, _9);
    _197 += _220;
    float3 _272 = max(_197, 0.0f.xxx);
    vs_TEXCOORD3 = float4(_272.x, _272.y, _272.z, vs_TEXCOORD3.w);
    vs_TEXCOORD3.w = _21_m11;
    _197 = _21_m1.xyz * 0.715200006961822509765625f.xxx;
    _197 = (_21_m0.xyz * 0.2125999927520751953125f.xxx) + _197;
    _197 = (_21_m2.xyz * 0.072200000286102294921875f.xxx) + _197;
    _9.x = dot(_197, _197);
    _306.x = rsqrt(_9.x);
    _311 = 9.9999999392252902907785028219223e-09f < _9.x;
    _306 = _306.xxx * _197;
    float3 _322;
    if (_311)
    {
        _322 = _306;
    }
    else
    {
        _322 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_322.x, _322.y, _322.z, _9.w);
    vs_TEXCOORD4 = _9.xyz;
    _197.x = _9.y * _9.y;
    _197.x = (_9.x * _9.x) + (-_197.x);
    _214 = _9.yzzx * _9.xyzz;
    _220.x = dot(_21_m3, _214);
    _220.y = dot(_21_m4, _214);
    _220.z = dot(_21_m5, _214);
    _197 = (_21_m6.xyz * _197.xxx) + _220;
    _9.w = 1.0f;
    _220.x = dot(_21_m0, _9);
    _220.y = dot(_21_m1, _9);
    _220.z = dot(_21_m2, _9);
    _197 += _220;
    vs_TEXCOORD5 = max(_197, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    _157 = stage_input._157;
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
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SplatTint;
float _Cutoff;
float _Smoothness;
float _Specular;
float _Sheen;
#define _50_m0 _WorldSpaceCameraPos
#define _50_m1 _WorldSpaceLightPos0
#define _50_m2 _LightColor0
#define _50_m3 _SplatTint
#define _50_m4 _Cutoff
#define _50_m5 _Smoothness
#define _50_m6 _Specular
#define _50_m7 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 _104;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

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
    float4 _104 : SV_Target0;
};

static float4 _9;
static float4 _20;
static float _29;
static bool _111;
static float3 _125;
static float3 _135;
static float3 _159;
static float _168;
static float3 _174;
static float3 _200;
static float3 _252;
static float3 _259;
static float3 _265;
static float3 _288;
static float3 _294;
static float3 _335;
static float _361;
static float3 _372;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20.x = ddx_coarse(_9.w);
    _29 = ddy_coarse(_9.w);
    _20.x = abs(_29) + abs(_20.x);
    _20.x = max(_20.x, 0.001000000047497451305389404296875f);
    _29 = _9.w + (-_50_m4);
    _20.x = _29 / _20.x;
    _20.x += 0.5f;
    _20.x = clamp(_20.x, 0.0f, 1.0f);
    _20.x = _9.w * _20.x;
    _20.x *= _50_m3.w;
    _29 = (_20.x * vs_TEXCOORD3.w) + (-0.0040000001899898052215576171875f);
    _20.x *= vs_TEXCOORD3.w;
    _104.w = _20.x;
    _111 = _29 < 0.0f;
    if ((int(_111) * (-1)) != 0)
    {
        discard;
    }
    _125.x = dot(_50_m1.xyz, _50_m1.xyz);
    _135.x = rsqrt(_125.x);
    _111 = 9.9999999747524270787835121154785e-07f < _125.x;
    _135 = _135.xxx * _50_m1.xyz;
    float3 _152;
    if (_111)
    {
        _152 = _135;
    }
    else
    {
        _152 = float3(0.0f, 1.0f, 0.0f);
    }
    _125 = _152;
    _159 = (-vs_TEXCOORD1) + _50_m0;
    _168 = dot(_159, _159);
    _168 = rsqrt(_168);
    _174 = (_159 * _168.xxx) + _125;
    _159 = _168.xxx * _159;
    _168 = dot(_174, _174);
    _168 = rsqrt(_168);
    _174 = _168.xxx * _174;
    _168 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _168 = rsqrt(_168);
    _200 = _168.xxx * vs_TEXCOORD2;
    _168 = dot(_200, _174);
    _168 = clamp(_168, 0.0f, 1.0f);
    _168 = log2(_168);
    float2 _226 = (float2(float2(_50_m5, _50_m5)) * float2(10.0f, 7.0f)) + 1.0f.xx;
    _20 = float4(_226.x, _226.y, _20.z, _20.w);
    float2 _231 = exp2(_20.xy);
    _20 = float4(_231.x, _231.y, _20.z, _20.w);
    _168 *= _20.x;
    _168 = exp2(_168);
    float2 _249 = _9.ww * float2(_50_m6, _50_m7);
    _20 = float4(_249.x, _20.y, _249.y, _20.w);
    _252 = _9.xyz * _50_m3.xyz;
    _259.x = _20.x * _168;
    _265 = _259.xxx * _50_m2.xyz;
    _259.x = dot(_200, _125);
    _259.x = (_259.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _288 = max(vs_TEXCOORD3.xyz, 0.2199999988079071044921875f.xxx);
    _294 = (_50_m2.xyz * _259.xxx) + _288;
    _265 = (_252 * _294) + _265;
    _294 = (_252 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _252 = (_252 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _259.x = dot(_200, _159);
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x = (-_259.x) + 1.0f;
    _335.x = _259.x * _259.x;
    _335.x *= _335.x;
    _259.x = _335.x * _259.x;
    _335.x = (_259.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _361 = _20.z * _259.x;
    _361 *= _50_m5;
    _372 = _335.xxx * _288;
    _372 *= float3(float3(_50_m5, _50_m5, _50_m5));
    _372 *= 0.300000011920928955078125f.xxx;
    _265 = (_372 * _294) + _265;
    _259.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _259.x = rsqrt(_259.x);
    _335 = (vs_TEXCOORD4 * _259.xxx) + _159;
    _125 = _259.xxx * vs_TEXCOORD4;
    _259.x = dot(_335, _335);
    _259.x = rsqrt(_259.x);
    _259 = _259.xxx * _335;
    _259.x = dot(_200, _259);
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x = log2(_259.x);
    _259.x *= _20.y;
    _259.x = exp2(_259.x);
    _259.x = _20.x * _259.x;
    float3 _465 = (vs_TEXCOORD5 * _259.xxx) + _265;
    _20 = float4(_465.x, _465.y, _20.z, _465.z);
    _259.x = dot(-_159, _200);
    _259.x += _259.x;
    _259 = (_200 * (-_259.xxx)) + (-_159);
    _259.x = dot(_259, _125);
    _259.x = (_259.x * 0.5f) + 0.5f;
    _259.x = clamp(_259.x, 0.0f, 1.0f);
    _259.x *= _259.x;
    _259.x *= _259.x;
    _265 = (-_288) + vs_TEXCOORD5;
    _265 = (_259.xxx * _265) + _288;
    _252 *= _265;
    float3 _531 = (_252 * _361.xxx) + _20.xyw;
    _104 = float4(_531.x, _531.y, _531.z, _104.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
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