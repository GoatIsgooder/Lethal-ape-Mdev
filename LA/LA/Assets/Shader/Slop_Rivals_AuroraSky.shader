// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Rivals/AuroraSky" {
Properties {

[Header(Night Gradient)] _HorizonColor ("Horizon Color", Color) = (0.039,0.063,0.149,1)

_ZenithColor ("Zenith Color", Color) = (0.008,0.012,0.039,1)

_GradientPower ("Gradient Power", Range(0.2, 3)) = 0.699999988079071

_HorizonGlowColor ("Horizon Glow Color", Color) = (0.16,0.24,0.42,1)

_HorizonGlowStrength ("Horizon Glow Strength", Range(0, 2)) = 0.3499999940395355

[Header(Stars)] _StarDensity ("Star Density", Range(0, 1)) = 0.5

_StarScale ("Star Grid Scale", Range(8, 80)) = 30.0

_StarBrightness ("Star Brightness", Range(0, 4)) = 1.2999999523162842

_TwinkleSpeed ("Twinkle Speed", Range(0, 4)) = 1.0

_HeroStarDensity ("Hero Star Density", Range(0, 1)) = 0.15000000596046448

_HeroStarScale ("Hero Star Grid Scale", Range(2, 16)) = 6.0

[Header(Aurora)] _AuroraIntensity ("Aurora Intensity", Range(0, 3)) = 1.0

_AuroraBottomColor ("Aurora Bottom (green)", Color) = (0.18,0.902,0.42,1)

_AuroraMidColor ("Aurora Mid (teal)", Color) = (0.13,0.78,0.72,1)

_AuroraTopColor ("Aurora Top (purple)", Color) = (0.482,0.31,0.878,1)

_AuroraHeight ("Aurora Base Height", Range(0.05, 0.8)) = 0.3199999928474426

_AuroraExtent ("Aurora Curtain Extent", Range(0.05, 1)) = 0.3799999952316284

_AuroraSpeed ("Aurora Drift Speed", Range(0, 3)) = 1.0

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
ZWrite On
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Cull Front
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
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
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
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
    vs_TEXCOORD0 = _11.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _HorizonColor;
float4 _ZenithColor;
float _GradientPower;
float4 _HorizonGlowColor;
float _HorizonGlowStrength;
float _StarDensity;
float _StarScale;
float _StarBrightness;
float _TwinkleSpeed;
float _HeroStarDensity;
float _HeroStarScale;
float _AuroraIntensity;
float4 _AuroraBottomColor;
float4 _AuroraMidColor;
float4 _AuroraTopColor;
float _AuroraHeight;
float _AuroraExtent;
float _AuroraSpeed;
#define _52_m0 _Time
#define _52_m1 _HorizonColor
#define _52_m2 _ZenithColor
#define _52_m3 _GradientPower
#define _52_m4 _HorizonGlowColor
#define _52_m5 _HorizonGlowStrength
#define _52_m6 _StarDensity
#define _52_m7 _StarScale
#define _52_m8 _StarBrightness
#define _52_m9 _TwinkleSpeed
#define _52_m10 _HeroStarDensity
#define _52_m11 _HeroStarScale
#define _52_m12 _AuroraIntensity
#define _52_m13 _AuroraBottomColor
#define _52_m14 _AuroraMidColor
#define _52_m15 _AuroraTopColor
#define _52_m16 _AuroraHeight
#define _52_m17 _AuroraExtent
#define _52_m18 _AuroraSpeed



static float3 vs_TEXCOORD0;
static float4 _1932;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _1932 : SV_Target0;
};

static float2 _9;
static float3 _25;
static float4 _33;
static float3 _43;
static float3 _64;
static float _112;
static float4 _130;
static bool _163;
static float3 _191;
static float4 _201;
static float4 _212;
static float4 _222;
static float _230;
static bool _304;
static float2 _314;
static float3 _345;
static float3 _428;
static float3 _486;
static float4 _506;
static float _933;
static float _975;
static float _1032;
static float _1052;
static bool _1077;
static bool _1099;
static bool _1128;
static float3 _1341;
static float3 _1351;
static float3 _1362;
static float3 _1382;
static float2 _1404;
static float _1610;
static float3 _1616;
static float3 _1631;
static float _1830;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    _25 = _9.xxx * vs_TEXCOORD0.yxz;
    _33.x = _25.x;
    _33.x = clamp(_33.x, 0.0f, 1.0f);
    _43.x = log2(_33.x);
    _43.x *= _52_m3;
    _43.x = exp2(_43.x);
    _64 = (-_52_m1.xyz) + _52_m2.xyz;
    _43 = (_43.xxx * _64) + _52_m1.xyz;
    _33.x = abs(_25.x) * (-7.934822559356689453125f);
    _33.x = exp2(_33.x);
    _33.x *= _52_m5;
    float3 _109 = (_52_m4.xyz * _33.xxx) + _43;
    _33 = float4(_109.x, _109.y, _109.z, _33.w);
    _112 = _25.x * (-4.0f);
    _112 = clamp(_112, 0.0f, 1.0f);
    _112 = (_112 * (-0.64999997615814208984375f)) + 1.0f;
    float3 _127 = _112.xxx * _33.xyz;
    _33 = float4(_127.x, _127.y, _127.z, _33.w);
    float2 _139 = (vs_TEXCOORD0.yy * _9.xx) + float2(-0.014999999664723873138427734375f, -0.0199999995529651641845703125f);
    _130 = float4(_139.x, _139.y, _130.z, _130.w);
    _112 = _130.x * 4.87804889678955078125f;
    _112 = clamp(_112, 0.0f, 1.0f);
    _130.x = (_112 * (-2.0f)) + 3.0f;
    _112 *= _112;
    _112 *= _130.x;
    _163 = 0.0040000001899898052215576171875f < _112;
    if (_163)
    {
        _130.x = (vs_TEXCOORD0.y * _9.x) + 1.0f;
        _130.x = max(_130.x, 0.20000000298023223876953125f);
        float2 _188 = _25.zy / _130.xx;
        _130 = float4(_188.x, _130.y, _188.y, _130.w);
        float2 _198 = _130.zx * _52_m7.xx;
        _191 = float3(_198.x, _198.y, _191.z);
        float3 _204 = floor(_191.xyx);
        _201 = float4(_204.x, _204.y, _204.z, _201.w);
        float2 _209 = frac(_191.xy);
        _191 = float3(_209.x, _209.y, _191.z);
        _212 = _201.zyzz * float4(437.19500732421875f, 441.423004150390625f, 443.897003173828125f, 437.19500732421875f);
        _212 = frac(_212);
        float3 _227 = _212.ywz + 19.1900005340576171875f.xxx;
        _222 = float4(_227.x, _227.y, _227.z, _222.w);
        _230 = dot(_212.zyw, _222.xyz);
        _212 += _230.xxxx;
        _222 = _212.ywwy + _212.zzyz;
        _212 *= _222;
        _212 = frac(_212);
        float3 _254 = _201.xyz + 127.09999847412109375f.xxx;
        _201 = float4(_254.x, _254.y, _254.z, _201.w);
        float3 _260 = _201.xyz * float3(437.19500732421875f, 441.423004150390625f, 443.897003173828125f);
        _201 = float4(_260.x, _260.y, _260.z, _201.w);
        float3 _265 = frac(_201.xyz);
        _201 = float4(_265.x, _265.y, _265.z, _201.w);
        float3 _270 = _201.yxz + 19.1900005340576171875f.xxx;
        _222 = float4(_270.x, _270.y, _270.z, _222.w);
        _230 = dot(_201.zyx, _222.xyz);
        float3 _282 = _230.xxx + _201.xyz;
        _201 = float4(_282.x, _282.y, _282.z, _201.w);
        float3 _289 = _201.yxx + _201.zzy;
        _222 = float4(_289.x, _289.y, _289.z, _222.w);
        float3 _296 = _201.xyz * _222.xyz;
        _201 = float4(_296.x, _296.y, _296.z, _201.w);
        float3 _301 = frac(_201.xyz);
        _201 = float4(_301.x, _301.y, _301.z, _201.w);
        _304 = _52_m6 >= _212.z;
        _230 = float(_304);
        _314 = _212.zw * float2(13.729999542236328125f, 6.283199787139892578125f);
        float2 _328 = (_212.xy * 0.36000001430511474609375f.xx) + 0.319999992847442626953125f.xx;
        _222 = float4(_328.x, _328.y, _222.z, _222.w);
        float2 _336 = _191.xy + (-_222.xy);
        _191 = float3(_336.x, _336.y, _191.z);
        _201.x *= _201.x;
        _345.x = _201.x * _201.x;
        _345.x = _201.x * _345.x;
        _345.x = (_345.x * 0.25f) + 0.0500000007450580596923828125f;
        _191.x = dot(_191.xy, _191.xy);
        _345.x *= _345.x;
        _191.x /= _345.x;
        _191.x = (-_191.x) + 1.0f;
        _191.x = max(_191.x, 0.0f);
        _345.x = _191.x * _191.x;
        _345.x = _191.x * _345.x;
        _191.x = frac(_314.x);
        _191.x = (_191.x * 0.699999988079071044921875f) + 0.300000011920928955078125f;
        _212 = (_201.zyyy * float4(1.39999997615814208984375f, 0.2799999713897705078125f, 0.060000002384185791015625f, -0.2799999713897705078125f)) + float4(0.5f, 0.7200000286102294921875f, 0.819999992847442626953125f, 1.0f);
        _428.x = _212.x * _52_m0.y;
        _428.x = (_428.x * _52_m9) + _314.y;
        _428.x = sin(_428.x);
        _428.x = (_428.x * 0.20000000298023223876953125f) + 1.0f;
        _345.x = _191.x * _345.x;
        _345.x = _428.x * _345.x;
        _345.x = _230 * _345.x;
        _230 = _52_m7 * 0.430000007152557373046875f;
        float2 _483 = (_130.zx * _230.xx) + 37.700000762939453125f.xx;
        _191 = float3(_483.x, _483.y, _191.z);
        _486.x = _52_m6 * 0.5f;
        float3 _493 = floor(_191.xyx);
        _201 = float4(_493.x, _493.y, _493.z, _201.w);
        float2 _498 = frac(_191.xy);
        _191 = float3(_498.x, _498.y, _191.z);
        _222 = _201.zyzz * float4(437.19500732421875f, 441.423004150390625f, 443.897003173828125f, 437.19500732421875f);
        _222 = frac(_222);
        float3 _509 = _222.ywz + 19.1900005340576171875f.xxx;
        _506 = float4(_509.x, _509.y, _509.z, _506.w);
        _230 = dot(_222.zyw, _506.xyz);
        _222 = _230.xxxx + _222;
        _506 = _222.ywwy + _222.zzyz;
        _222 *= _506;
        _222 = frac(_222);
        float3 _533 = _201.xyz + 127.09999847412109375f.xxx;
        _201 = float4(_533.x, _533.y, _533.z, _201.w);
        float3 _538 = _201.xyz * float3(437.19500732421875f, 441.423004150390625f, 443.897003173828125f);
        _201 = float4(_538.x, _538.y, _538.z, _201.w);
        float3 _543 = frac(_201.xyz);
        _201 = float4(_543.x, _543.y, _543.z, _201.w);
        float3 _548 = _201.yxz + 19.1900005340576171875f.xxx;
        _506 = float4(_548.x, _548.y, _548.z, _506.w);
        _230 = dot(_201.zyx, _506.xyz);
        float3 _560 = _230.xxx + _201.xyz;
        _201 = float4(_560.x, _560.y, _560.z, _201.w);
        float3 _567 = _201.yxx + _201.zzy;
        _506 = float4(_567.x, _567.y, _567.z, _506.w);
        float3 _574 = _201.xyz * _506.xyz;
        _201 = float4(_574.x, _574.y, _574.z, _201.w);
        float3 _579 = frac(_201.xyz);
        _201 = float4(_579.x, _579.y, _579.z, _201.w);
        _304 = _486.x >= _222.z;
        _230 = float(_304);
        _314 = _222.zw * float2(13.729999542236328125f, 6.283199787139892578125f);
        float2 _595 = (_222.xy * 0.36000001430511474609375f.xx) + 0.319999992847442626953125f.xx;
        _222 = float4(_595.x, _595.y, _222.z, _222.w);
        float2 _603 = _191.xy + (-_222.xy);
        _191 = float3(_603.x, _603.y, _191.z);
        _201.x *= _201.x;
        _486.x = _201.x * _201.x;
        _486.x = _201.x * _486.x;
        _486.x = (_486.x * 0.2700000107288360595703125f) + 0.070000000298023223876953125f;
        _191.x = dot(_191.xy, _191.xy);
        _486.x *= _486.x;
        _191.x /= _486.x;
        _191.x = (-_191.x) + 1.0f;
        _191.x = max(_191.x, 0.0f);
        _486.x = _191.x * _191.x;
        _486.x = _191.x * _486.x;
        _191.x = frac(_314.x);
        _191.x = (_191.x * 0.699999988079071044921875f) + 0.300000011920928955078125f;
        _201 = (_201.zyyy * float4(1.39999997615814208984375f, 0.2799999713897705078125f, 0.060000002384185791015625f, -0.2799999713897705078125f)) + float4(0.5f, 0.7200000286102294921875f, 0.819999992847442626953125f, 1.0f);
        _428.x = _201.x * _52_m0.y;
        _428.x = (_428.x * _52_m9) + _314.y;
        _428.x = sin(_428.x);
        _428.x = (_428.x * 0.20000000298023223876953125f) + 1.0f;
        _486.x = _191.x * _486.x;
        _486.x = _428.x * _486.x;
        _486.x = _230 * _486.x;
        _486 = _201.yzw * _486.xxx;
        _486 *= 1.2000000476837158203125f.xxx;
        _345 = (_212.yzw * _345.xxx) + _486;
        float2 _749 = (_130.xz * _52_m11.xx) + 7.30000019073486328125f.xx;
        _130 = float4(_749.x, _130.y, _749.y, _130.w);
        _212 = floor(_130.zxzx);
        float2 _757 = frac(_130.xz);
        _130 = float4(_757.x, _130.y, _757.y, _130.w);
        _212 += float4(311.70001220703125f, 311.70001220703125f, 89.40000152587890625f, 89.40000152587890625f);
        _191 = _212.xyx * float3(437.19500732421875f, 441.423004150390625f, 443.897003173828125f);
        _191 = frac(_191);
        float3 _772 = _191.yxz + 19.1900005340576171875f.xxx;
        _201 = float4(_772.x, _772.y, _772.z, _201.w);
        _230 = dot(_191.zyx, _201.xyz);
        _191 = _230.xxx + _191;
        float3 _788 = _191.yxx + _191.zzy;
        _201 = float4(_788.x, _788.y, _788.z, _201.w);
        _191 *= _201.xyz;
        _191 = frac(_191);
        float3 _799 = _212.zwz * float3(437.19500732421875f, 441.423004150390625f, 443.897003173828125f);
        _201 = float4(_799.x, _799.y, _799.z, _201.w);
        float3 _804 = frac(_201.xyz);
        _201 = float4(_804.x, _804.y, _804.z, _201.w);
        float3 _809 = _201.yxz + 19.1900005340576171875f.xxx;
        _222 = float4(_809.x, _809.y, _809.z, _222.w);
        _230 = dot(_201.zyx, _222.xyz);
        float3 _821 = _230.xxx + _201.xyz;
        _201 = float4(_821.x, _821.y, _821.z, _201.w);
        float3 _828 = _201.yxx + _201.zzy;
        _222 = float4(_828.x, _828.y, _828.z, _222.w);
        float3 _835 = _201.xyz * _222.xyz;
        _201 = float4(_835.x, _835.y, _835.z, _201.w);
        float3 _840 = frac(_201.xyz);
        _201 = float4(_840.x, _840.y, _840.z, _201.w);
        _304 = _52_m10 >= _191.z;
        _230 = float(_304);
        _191 = (_191.xyx * float3(0.23999999463558197021484375f, 0.23999999463558197021484375f, 0.449999988079071044921875f)) + float3(0.37999999523162841796875f, 0.37999999523162841796875f, 0.550000011920928955078125f);
        float2 _866 = _130.xz + (-_191.yx);
        _130 = float4(_866.x, _130.y, _866.y, _130.w);
        _191.x = dot(_130.xz, _130.xz);
        _191.x *= (-375.1007080078125f);
        _191.x = exp2(_191.x);
        float2 _889 = _130.zx * (-_130.zx);
        _428 = float3(_889.x, _428.y, _889.y);
        float2 _896 = _130.xz * _130.xz;
        _130 = float4(_896.x, _130.y, _896.y, _130.w);
        float2 _903 = _130.xz * 52.0f.xx;
        _130 = float4(_903.x, _130.y, _903.y, _130.w);
        float2 _914 = (_428.xz * 1500.0f.xx) + (-_130.xz);
        _130 = float4(_914.x, _130.y, _914.y, _130.w);
        float2 _921 = _130.xz * 1.44269502162933349609375f.xx;
        _130 = float4(_921.x, _130.y, _921.y, _130.w);
        float2 _926 = exp2(_130.xz);
        _130 = float4(_926.x, _130.y, _926.y, _130.w);
        _428.x = _201.x * 6.283199787139892578125f;
        _933 = (_201.z * 0.89999997615814208984375f) + 0.3499999940395355224609375f;
        _933 *= _52_m0.y;
        _428.x = (_933 * _52_m9) + _428.x;
        _428.x = sin(_428.x);
        _428.x = (_428.x * 0.180000007152557373046875f) + 1.0f;
        float3 _972 = (_201.yyy * float3(0.199999988079071044921875f, 0.040000021457672119140625f, -0.199999988079071044921875f)) + float3(0.800000011920928955078125f, 0.87999999523162841796875f, 1.0f);
        _201 = float4(_972.x, _972.y, _972.z, _201.w);
        _975 = _130.z + _130.x;
        _975 *= 0.4000000059604644775390625f;
        _975 = (_191.x * 1.7000000476837158203125f) + _975;
        _975 = _428.x * _975;
        _975 = _230 * _975;
        _130.x = _191.z * _975;
        _345 = (_201.xyz * _130.xxx) + _345;
        _975 = _112 * _52_m8;
        _345 = (_345 * _975.xxx) + _33.xyz;
    }
    else
    {
        _345 = _33.xyz;
    }
    _33.x = min(abs(_25.z), abs(_25.y));
    _1032 = max(abs(_25.z), abs(_25.y));
    _1032 = 1.0f / _1032;
    _33.x = _1032 * _33.x;
    _1032 = _33.x * _33.x;
    _1052 = (_1032 * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _1052 = (_1032 * _1052) + 0.1801410019397735595703125f;
    _1052 = (_1032 * _1052) + (-0.33029949665069580078125f);
    _1032 = (_1032 * _1052) + 0.999866008758544921875f;
    _1052 = _1032 * _33.x;
    _1077 = abs(_25.z) < abs(_25.y);
    _1052 = (_1052 * (-2.0f)) + 1.57079637050628662109375f;
    _1052 = _1077 ? _1052 : 0.0f;
    _33.x = (_33.x * _1032) + _1052;
    _1099 = _25.z < (-_25.z);
    _1032 = _1099 ? (-3.1415927410125732421875f) : 0.0f;
    _33.x = _1032 + _33.x;
    _1032 = min(_25.z, _25.y);
    _1052 = max(_25.z, _25.y);
    _1099 = _1032 < (-_1032);
    _1128 = _1052 >= (-_1052);
    _1099 = _1128 && _1099;
    float _1138;
    if (_1099)
    {
        _1138 = -_33.x;
    }
    else
    {
        _1138 = _33.x;
    }
    _33.x = _1138;
    _1032 = _52_m0.y * _52_m18;
    _1052 = _33.x + _33.x;
    _112 = (_52_m0.y * _52_m18) + _1052;
    _33.w = sin(_112);
    float2 _1176 = _33.wx * float2(0.085000000894069671630859375f, 47.0f);
    _130 = float4(_1176.x, _130.y, _1176.y, _130.w);
    _191 = _1032.xxx * float3(1.7000000476837158203125f, 0.60000002384185791015625f, 0.17000000178813934326171875f);
    _230 = (_33.x * 5.0f) + (-_191.x);
    _230 = sin(_230);
    _130.x = (_230 * 0.039999999105930328369140625f) + _130.x;
    _230 = (_33.x * 11.0f) + _191.y;
    _230 = sin(_230);
    _130.x = (_230 * 0.017999999225139617919921875f) + _130.x;
    _230 = sin(_191.z);
    _230 = (_230 * 0.2199999988079071044921875f) + 1.0f;
    _230 *= _52_m17;
    _191.x = _130.x + _52_m16;
    _191.x = (vs_TEXCOORD0.y * _9.x) + (-_191.x);
    _428.x = _191.x + 0.01200000010430812835693359375f;
    _428.x *= 23.8095245361328125f;
    _428.x = clamp(_428.x, 0.0f, 1.0f);
    _314.x = (_428.x * (-2.0f)) + 3.0f;
    _428.x *= _428.x;
    _428.x *= _314.x;
    _314.x = max(_191.x, 0.0f);
    _975 = 4.5f / _230;
    _314.x = (-_314.x) * _975;
    _314.x *= 1.44269502162933349609375f;
    _314.x = exp2(_314.x);
    _975 = _314.x * _428.x;
    _130.x = (_130.x * 25.0f) + _130.z;
    _130.x = (_1032 * 1.2999999523162841796875f) + _130.x;
    _130.x = sin(_130.x);
    _130.x = (_130.x * 0.300000011920928955078125f) + 0.699999988079071044921875f;
    _975 = _130.x * _975;
    _130.x = _191.x / _230;
    _130.x = clamp(_130.x, 0.0f, 1.0f);
    _1341.x = _130.x * 2.2000000476837158203125f;
    _1341.x = min(_1341.x, 1.0f);
    _1351 = (-_52_m13.xyz) + _52_m14.xyz;
    _1362 = (_1341.xxx * _1351) + _52_m13.xyz;
    _1341.x = (_130.x * 1.7999999523162841796875f) + (-0.800000011920928955078125f);
    _1341.x = max(_1341.x, 0.0f);
    _1382 = (-_1362) + _52_m15.xyz;
    _1362 = (_1341.xxx * _1382) + _1362;
    float2 _1401 = _52_m16.xx + float2(0.17000000178813934326171875f, -0.0900000035762786865234375f);
    _1382 = float3(_1401.x, _1401.y, _1382.z);
    _1404 = float2(float2(_52_m17, _52_m17)) * float2(0.800000011920928955078125f, 0.550000011920928955078125f);
    float2 _1420 = _1032.xx * float2(1.07099997997283935546875f, 0.3780000209808349609375f);
    _130 = float4(_1420.x, _130.y, _130.z, _1420.y);
    _191.x = (_1032 * 0.62999999523162841796875f) + _1052;
    _191.x += 2.099999904632568359375f;
    _191.x = sin(_191.x);
    _130.x = (_33.x * 5.0f) + (-_130.x);
    _130.x += 4.829999446868896484375f;
    _130.x = sin(_130.x);
    _130.x *= 0.039999999105930328369140625f;
    _130.x = (_191.x * 0.085000000894069671630859375f) + _130.x;
    _230 = (_33.x * 11.0f) + _130.w;
    _230 += 2.099999904632568359375f;
    _230 = sin(_230);
    _130.x = (_230 * 0.017999999225139617919921875f) + _130.x;
    float2 _1489 = (_1032.xx * 0.17000000178813934326171875f.xx) + float2(3.5699999332427978515625f, 7.139999866485595703125f);
    _191 = float3(_1489.x, _1489.y, _191.z);
    float2 _1494 = sin(_191.xy);
    _191 = float3(_1494.x, _1494.y, _191.z);
    float2 _1502 = (_191.xy * 0.2199999988079071044921875f.xx) + 1.0f.xx;
    _191 = float3(_1502.x, _1502.y, _191.z);
    float2 _1508 = _191.xy * _1404;
    _191 = float3(_1508.x, _1508.y, _191.z);
    _230 = _130.x + _1382.x;
    _230 = (vs_TEXCOORD0.y * _9.x) + (-_230);
    _314.x = _230 + 0.01200000010430812835693359375f;
    _314.x *= 23.8095245361328125f;
    _314.x = clamp(_314.x, 0.0f, 1.0f);
    _933 = (_314.x * (-2.0f)) + 3.0f;
    _314.x *= _314.x;
    _314.x *= _933;
    _933 = max(_230, 0.0f);
    float2 _1555 = 4.5f.xx / _191.xy;
    _1382 = float3(_1555.x, _1382.y, _1555.y);
    _933 = (-_933) * _1382.x;
    _933 *= 1.44269502162933349609375f;
    _933 = exp2(_933);
    _1341.x = _933 * _314.x;
    _130.x = (_130.x * 25.0f) + _130.z;
    _130.x = (_1032 * 0.818999946117401123046875f) + _130.x;
    _130.x = sin(_130.x);
    _130.x = (_130.x * 0.300000011920928955078125f) + 0.699999988079071044921875f;
    _1341.x = _130.x * _1341.x;
    _130.x = _230 / _191.x;
    _130.x = clamp(_130.x, 0.0f, 1.0f);
    _1610 = _130.x * 2.2000000476837158203125f;
    _1610 = min(_1610, 1.0f);
    _1616 = (_1610.xxx * _1351) + _52_m13.xyz;
    _1610 = (_130.x * 1.7999999523162841796875f) + (-0.800000011920928955078125f);
    _1610 = max(_1610, 0.0f);
    _1631 = (-_1616) + _52_m15.xyz;
    _1616 = (_1610.xxx * _1631) + _1616;
    _1616 = _1341.xxx * _1616;
    _1616 *= 0.550000011920928955078125f.xxx;
    _1362 = (_1362 * _975.xxx) + _1616;
    float2 _1662 = _1032.xx * float2(2.328999996185302734375f, 0.822000026702880859375f);
    _130 = float4(_1662.x, _130.y, _130.z, _1662.y);
    _1052 = (_1032 * 1.37000000476837158203125f) + _1052;
    _1052 += 4.19999980926513671875f;
    _1052 = sin(_1052);
    _130.x = (_33.x * 5.0f) + (-_130.x);
    _130.x += 9.65999889373779296875f;
    _130.x = sin(_130.x);
    _130.x *= 0.039999999105930328369140625f;
    _1052 = (_1052 * 0.085000000894069671630859375f) + _130.x;
    _33.x = (_33.x * 11.0f) + _130.w;
    _33.x += 4.19999980926513671875f;
    _33.x = sin(_33.x);
    _33.x = (_33.x * 0.017999999225139617919921875f) + _1052;
    _1052 = _33.x + _1382.y;
    _9.x = (vs_TEXCOORD0.y * _9.x) + (-_1052);
    _1052 = _9.x + 0.01200000010430812835693359375f;
    _1052 *= 23.8095245361328125f;
    _1052 = clamp(_1052, 0.0f, 1.0f);
    _130.x = (_1052 * (-2.0f)) + 3.0f;
    _1052 *= _1052;
    _1052 *= _130.x;
    _130.x = max(_9.x, 0.0f);
    _130.x = _1382.z * (-_130.x);
    _130.x *= 1.44269502162933349609375f;
    _130.x = exp2(_130.x);
    _975 = _1052 * _130.x;
    _33.x = (_33.x * 25.0f) + _130.z;
    _33.x = (_1032 * 1.7809998989105224609375f) + _33.x;
    _33.x = sin(_33.x);
    _33.x = (_33.x * 0.300000011920928955078125f) + 0.699999988079071044921875f;
    _975 = _33.x * _975;
    _9.x /= _191.y;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1341.x = _9.x * 2.2000000476837158203125f;
    _1341.x = min(_1341.x, 1.0f);
    _1341 = (_1341.xxx * _1351) + _52_m13.xyz;
    _1830 = (_9.x * 1.7999999523162841796875f) + (-0.800000011920928955078125f);
    _1830 = max(_1830, 0.0f);
    _1382 = (-_1341) + _52_m15.xyz;
    _1341 = (_1830.xxx * _1382) + _1341;
    _1341 = _975.xxx * _1341;
    _1341 = (_1341 * 0.4000000059604644775390625f.xxx) + _1362;
    _345 = (_1341 * _52_m12.xxx) + _345;
    _9.x = abs(_130.y) * (-8.656169891357421875f);
    _9.x = exp2(_9.x);
    _33.x = (_33.w * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _9.x *= _33.x;
    _975 = _9.x * _52_m12;
    _975 *= 0.07999999821186065673828125f;
    _345 = (_52_m13.xyz * _975.xxx) + _345;
    _9 = _25.xx + _25.yz;
    _9.x = dot(_9, float2(12.98980045318603515625f, 78.233001708984375f));
    _9.x = sin(_9.x);
    _9.x *= 43758.546875f;
    _9.x = frac(_9.x);
    _975 = _9.x + (-0.5f);
    float3 _1939 = (_975.xxx * 0.0062745097093284130096435546875f.xxx) + _345;
    _1932 = float4(_1939.x, _1939.y, _1939.z, _1932.w);
    _1932.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1932 = _1932;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}