// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SoreBones/PumkinEyeFire" {
Properties {

[Header(Color Ramp)] _EdgeColor ("Edge Color", Color) = (0.05,0.6,0.15,1)

_MidColor ("Mid Color", Color) = (0.65,1,0.6,1)

_CoreColor ("Core Color", Color) = (1,1,1,1)

_WhiteBias ("White Bias", Range(0, 1)) = 0.699999988079071

_Intensity ("Intensity", Range(0, 10)) = 3.0

_Contrast ("Contrast", Range(0.5, 3)) = 1.2000000476837158

[Header(Strip Mapping)] _RootUV ("Root UV", Vector) = (0.984,-0.005,0,0)

_TipUV ("Tip UV", Vector) = (0.055,1.007,0,0)

_AcrossScale ("Across Scale", Float) = 0.5

[Header(Shape)] _RootWidth ("Root Width", Range(0, 0.3)) = 0.03500000014901161

_MaxWidth ("Max Width", Range(0, 0.3)) = 0.10999999940395355

_TipStart ("Tip Fade Start", Range(0, 1)) = 0.550000011920929

_EdgeSoftness ("Edge Softness", Range(0.05, 1)) = 0.699999988079071

[Header(Motion)] _FlameScale ("Flame Scale", Float) = 7.0

_FlameSpeed ("Flame Speed", Float) = 1.7999999523162842

_Erosion ("Erosion", Range(0, 1)) = 0.550000011920929

_Wiggle ("Sway", Range(0, 0.2)) = 0.05000000074505806

_WiggleSpeed ("Sway Speed", Float) = 2.200000047683716

_WarpStrength ("Warp Strength", Range(0, 0.2)) = 0.03999999910593033

[Header(Core Streak)] _CoreWidth ("Core Width", Range(0.05, 1)) = 0.30000001192092896

_CoreIntensity ("Core Intensity", Range(0, 6)) = 2.0

[Header(Sparks)] [Toggle(_SPARKS_ON)] _SparksOn ("Enable", Float) = 1.0

_SparkDensity ("Density", Float) = 12.0

_SparkSpeed ("Rise Speed", Float) = 0.3499999940395355

_SparkSize ("Size", Range(0.01, 0.4)) = 0.10000000149011612

_SparkChance ("Chance", Range(0, 1)) = 0.30000001192092896

_SparkIntensity ("Intensity", Range(0, 8)) = 3.0

[Header(Pulse)] _PulseSpeed ("Pulse Speed", Float) = 1.7999999523162842

_PulseAmount ("Pulse Amount", Range(0, 0.6)) = 0.15000000596046448

[Header(Pixelation)] _PixelSize ("Pixel Size", Range(0.002, 0.2)) = 0.02800000086426735

_FrameRate ("Frame Rate", Range(1, 60)) = 12.0

_Steps ("Color Steps", Range(2, 16)) = 5.0

[Header(Rendering)] [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 5.0

[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 1.0

[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 0.0

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull [_Cull]
   Blend [_SrcBlend] [_DstBlend]
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ _SPARKS_ON
#if defined(FOG_EXP) && defined(_SPARKS_ON)
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
float4 _EdgeColor;
float4 _MidColor;
float4 _CoreColor;
float _WhiteBias;
float _Intensity;
float _Contrast;
float4 _RootUV;
float4 _TipUV;
float _AcrossScale;
float _RootWidth;
float _MaxWidth;
float _TipStart;
float _EdgeSoftness;
float _FlameScale;
float _FlameSpeed;
float _Erosion;
float _Wiggle;
float _WiggleSpeed;
float _WarpStrength;
float _CoreWidth;
float _CoreIntensity;
float _SparkDensity;
float _SparkSpeed;
float _SparkSize;
float _SparkChance;
float _SparkIntensity;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _22_m0 _Time
#define _22_m1 _EdgeColor
#define _22_m2 _MidColor
#define _22_m3 _CoreColor
#define _22_m4 _WhiteBias
#define _22_m5 _Intensity
#define _22_m6 _Contrast
#define _22_m7 _RootUV
#define _22_m8 _TipUV
#define _22_m9 _AcrossScale
#define _22_m10 _RootWidth
#define _22_m11 _MaxWidth
#define _22_m12 _TipStart
#define _22_m13 _EdgeSoftness
#define _22_m14 _FlameScale
#define _22_m15 _FlameSpeed
#define _22_m16 _Erosion
#define _22_m17 _Wiggle
#define _22_m18 _WiggleSpeed
#define _22_m19 _WarpStrength
#define _22_m20 _CoreWidth
#define _22_m21 _CoreIntensity
#define _22_m22 _SparkDensity
#define _22_m23 _SparkSpeed
#define _22_m24 _SparkSize
#define _22_m25 _SparkChance
#define _22_m26 _SparkIntensity
#define _22_m27 _PulseSpeed
#define _22_m28 _PulseAmount
#define _22_m29 _PixelSize
#define _22_m30 _FrameRate
#define _22_m31 _Steps



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _2148;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _2148 : SV_Target0;
};

static float4 _9;
static float4 _15;
static float4 _33;
static float2 _52;
static float _65;
static float _125;
static float3 _189;
static float4 _200;
static float2 _220;
static float4 _244;
static float4 _265;
static float3 _269;
static float _379;
static float _446;
static float _482;
static float2 _533;
static float4 _672;
static float _681;
static float2 _755;
static float2 _921;
static float2 _1061;
static float3 _1361;
static float _1459;
static float _1536;
static float3 _1543;
static float3 _1653;
static float3 _1692;
static float3 _1745;
static float2 _1982;
static float _1999;
static bool _2086;
static bool _2133;

void frag_inner()
{
    _9.w = 1.2999999523162841796875f;
    float2 _30 = vs_TEXCOORD0 + (-_22_m7.xy);
    _15 = float4(_30.x, _30.y, _15.z, _15.w);
    float2 _42 = (-_22_m7.xy) + _22_m8.xy;
    _33 = float4(_42.x, _42.y, _33.z, _33.w);
    _33.z = -_33.x;
    _52.x = dot(_15.xy, _33.yz);
    _15.x = dot(_15.xy, _33.xy);
    _65 = dot(_33.xy, _33.xy);
    _65 = max(_65, 9.9999997473787516355514526367188e-06f);
    _65 = 1.0f / _65;
    _33.y = _65 * _15.x;
    _15.x = _65 * _52.x;
    _33.x = _15.x * _22_m9;
    float2 _102 = _33.xy / _22_m29.xx;
    _15 = float4(_102.x, _102.y, _15.z, _15.w);
    float2 _107 = floor(_15.xy);
    _15 = float4(_107.x, _107.y, _15.z, _15.w);
    float2 _114 = _15.xy + 0.5f.xx;
    _15 = float4(_114.x, _114.y, _15.z, _15.w);
    float2 _122 = _15.xy * _22_m29.xx;
    _15 = float4(_122.x, _15.y, _122.y, _15.w);
    _125 = vs_TEXCOORD1 + _22_m0.y;
    _125 *= _22_m30;
    _125 = floor(_125);
    _15.w = _125 / _22_m30;
    float3 _157 = _15.xzw * float3(_22_m14, _22_m14, _22_m15);
    _33 = float4(_157.x, _157.y, _33.z, _157.z);
    _33.z = (_33.y * 0.449999988079071044921875f) + (-_33.w);
    float3 _175 = _15.www * float3(0.699999988079071044921875f, 3.0f, 9.0f);
    _9 = float4(_175.x, _175.y, _175.z, _9.w);
    float2 _185 = (_33.xz * 0.800000011920928955078125f.xx) + _9.wx;
    _9 = float4(_185.x, _9.y, _9.z, _185.y);
    float2 _192 = floor(_9.xw);
    _189 = float3(_192.x, _189.y, _192.y);
    float2 _197 = frac(_9.xw);
    _9 = float4(_197.x, _9.y, _9.z, _197.y);
    float2 _204 = _189.xz + 1.0f.xx;
    _200 = float4(_204.x, _204.y, _200.z, _200.w);
    float2 _212 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_212.x, _212.y, _200.z, _200.w);
    float2 _217 = frac(_200.xy);
    _200 = float4(_217.x, _217.y, _200.z, _200.w);
    _220 = _200.xy + 45.31999969482421875f.xx;
    _220.x = dot(_200.xy, _220);
    float2 _235 = _220.xx + _200.xy;
    _200 = float4(_235.x, _235.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _244 = _189.xzxz + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _252 = _189.xz * float2(123.339996337890625f, 456.209991455078125f);
    _189 = float3(_252.x, _189.y, _252.y);
    float2 _257 = frac(_189.xz);
    _189 = float3(_257.x, _189.y, _257.y);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _269.x = dot(_244.zw, _265.zw);
    _220.x = dot(_244.xy, _265.xy);
    _220 = _220.xx + _244.xy;
    float2 _291 = _269.xx + _244.zw;
    _244 = float4(_291.x, _291.y, _244.z, _244.w);
    _200.y = _244.y * _244.x;
    _200.z = _220.y * _220.x;
    float3 _308 = frac(_200.xyz);
    _200 = float4(_308.x, _308.y, _308.z, _200.w);
    _200.x = (-_200.y) + _200.x;
    float2 _322 = _9.xw * _9.xw;
    _244 = float4(_322.x, _322.y, _244.z, _244.w);
    float2 _332 = ((-_9.xw) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_332.x, _9.y, _9.z, _332.y);
    float2 _339 = _9.xw * _244.xy;
    _9 = float4(_339.x, _9.y, _9.z, _339.y);
    _200.x = (_9.x * _200.x) + _200.y;
    float2 _353 = _189.xz + 45.31999969482421875f.xx;
    _269 = float3(_353.x, _269.y, _353.y);
    _269.x = dot(_189.xz, _269.xz);
    float2 _366 = _189.xz + _269.xx;
    _189 = float3(_366.x, _189.y, _366.y);
    _189.x = _189.z * _189.x;
    _189.x = frac(_189.x);
    _379 = (-_189.x) + _200.z;
    _9.x = (_9.x * _379) + _189.x;
    _189.x = (-_9.x) + _200.x;
    _9.x = (_9.w * _189.x) + _9.x;
    _9.x = (_9.x * 2.0f) + (-1.0f);
    _33 = (_9.xxxx * 0.5f.xxxx) + _33.xzxz;
    _9.x *= _22_m19;
    float2 _432 = floor(_33.zw);
    _200 = float4(_432.x, _432.y, _200.z, _200.w);
    _220 = _200.xy + 1.0f.xx;
    _220 *= float2(123.339996337890625f, 456.209991455078125f);
    _220 = frac(_220);
    float2 _443 = _220 + 45.31999969482421875f.xx;
    _244 = float4(_443.x, _443.y, _244.z, _244.w);
    _446 = dot(_220, _244.xy);
    _220 = _446.xx + _220;
    _446 = _220.y * _220.x;
    _446 = frac(_446);
    _244 = _200.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _467 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_467.x, _467.y, _200.z, _200.w);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _220.x = dot(_244.zw, _265.zw);
    _482 = dot(_244.xy, _265.xy);
    float2 _492 = _482.xx + _244.xy;
    _244 = float4(_492.x, _492.y, _244.z, _244.w);
    _220 = _220.xx + _244.zw;
    _200.z = _220.y * _220.x;
    _200.w = _244.y * _244.x;
    _200 = frac(_200);
    _446 += (-_200.z);
    float2 _521 = frac(_33.zw);
    _244 = float4(_521.x, _521.y, _244.z, _244.w);
    _33 = (_33 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _533 = _244.xy * _244.xy;
    float2 _543 = ((-_244.xy) * 2.0f.xx) + 3.0f.xx;
    _244 = float4(_543.x, _543.y, _244.z, _244.w);
    float2 _549 = _244.xy * _533;
    _244 = float4(_549.x, _549.y, _244.z, _244.w);
    _446 = (_244.x * _446) + _200.z;
    _533 = _200.xy + 45.31999969482421875f.xx;
    _220.x = dot(_200.xy, _533);
    float2 _571 = _220.xx + _200.xy;
    _200 = float4(_571.x, _571.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _200.x = frac(_200.x);
    _269.x = (-_200.x) + _200.w;
    _200.x = (_244.x * _269.x) + _200.x;
    _446 += (-_200.x);
    _446 = (_244.y * _446) + _200.x;
    _200 = frac(_33);
    _33 = floor(_33);
    _244 = _200 * _200;
    _200 = ((-_200) * 2.0f.xxxx) + 3.0f.xxxx;
    _200 *= _244;
    _244 = _33 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _265.x = dot(_244.xy, _265.xy);
    _265.y = dot(_244.zw, _265.zw);
    _244 += _265.xxyy;
    _244.x = _244.y * _244.x;
    _244.y = _244.w * _244.z;
    _265 = _33.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _265 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _265 = frac(_265);
    _672 = _265 + 45.31999969482421875f.xxxx;
    _533.x = dot(_265.zw, _672.zw);
    _681 = dot(_265.xy, _672.xy);
    float2 _691 = _681.xx + _265.xy;
    _265 = float4(_691.x, _691.y, _265.z, _265.w);
    _533 = _533.xx + _265.zw;
    _244.z = _533.y * _533.x;
    _244.w = _265.y * _265.x;
    _244 = frac(_244);
    _244.x = (-_244.z) + _244.x;
    _244.x = (_200.x * _244.x) + _244.z;
    _265 = _33 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = _33.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _33 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = frac(_33);
    _265 = frac(_265);
    _672 = _265 + 45.31999969482421875f.xxxx;
    _533.x = dot(_265.xy, _672.xy);
    _672.x = dot(_265.zw, _672.zw);
    _755 = _265.zw + _672.xx;
    float2 _765 = _533.xx + _265.xy;
    _265 = float4(_765.x, _765.y, _265.z, _265.w);
    _533.x = _265.y * _265.x;
    _533.x = frac(_533.x);
    _265.x = _755.y * _755.x;
    _265.x = frac(_265.x);
    _681 = (-_533.x) + _244.w;
    _200.x = (_200.x * _681) + _533.x;
    _244.x = (-_200.x) + _244.x;
    _200.x = (_200.y * _244.x) + _200.x;
    _200.x *= 0.25f;
    _446 = (_446 * 0.5f) + _200.x;
    _672 = _33 + 45.31999969482421875f.xxxx;
    _200.x = dot(_33.zw, _672.zw);
    _200.y = dot(_33.xy, _672.xy);
    _33 += _200.yyxx;
    float2 _850 = _33.yw * _33.xz;
    _33 = float4(_850.x, _33.y, _850.y, _33.w);
    float2 _855 = frac(_33.xz);
    _33 = float4(_855.x, _33.y, _855.y, _33.w);
    _189.x = (-_33.x) + _33.z;
    _33.x = (_200.z * _189.x) + _33.x;
    _189.x = _244.y + (-_265.x);
    _189.x = (_200.z * _189.x) + _265.x;
    _33.x = (-_189.x) + _33.x;
    _33.x = (_200.w * _33.x) + _189.x;
    _446 = (_33.x * 0.125f) + _446;
    float3 _918 = _15.zzz * float3(1.5f, 2.22222232818603515625f, 2.5f);
    _33 = float4(_918.x, _918.y, _918.z, _33.w);
    _921.x = ((-_15.w) * _22_m18) + _33.z;
    _33 = float4(_33.xy.x, _33.xy.y, _33.z, _33.w);
    float2 _941 = clamp(_33.xy, 0.0f.xx, 1.0f.xx);
    _33 = float4(_941.x, _941.y, _33.z, _33.w);
    _379 = frac(_921.x);
    _200.x = floor(_921.x);
    _921.x = _379 * _379;
    _379 = ((-_379) * 2.0f) + 3.0f;
    _921.x = _379 * _921.x;
    _200.y = 3.0f;
    _220.y = 0.0f;
    float2 _968 = _200.xy + 1.0f.xx;
    _244 = float4(_968.x, _968.y, _244.z, _244.w);
    float2 _973 = _244.xy * float2(123.339996337890625f, 456.209991455078125f);
    _244 = float4(_973.x, _973.y, _244.z, _244.w);
    float2 _978 = frac(_244.xy);
    _244 = float4(_978.x, _978.y, _244.z, _244.w);
    _533 = _244.xy + 45.31999969482421875f.xx;
    _379 = dot(_244.xy, _533);
    float2 _992 = _379.xx + _244.xy;
    _244 = float4(_992.x, _992.y, _244.z, _244.w);
    _379 = _244.y * _244.x;
    _379 = frac(_379);
    _244 = _200.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _1007 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_1007.x, _1007.y, _200.z, _200.w);
    float2 _1012 = frac(_200.xy);
    _200 = float4(_1012.x, _1012.y, _200.z, _200.w);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _265.z = dot(_244.zw, _265.zw);
    _265.x = dot(_244.xy, _265.xy);
    _244 += _265.xxzz;
    float2 _1041 = _244.yw * _244.xz;
    _244 = float4(_1041.x, _244.y, _1041.y, _244.w);
    float2 _1046 = frac(_244.xz);
    _244 = float4(_1046.x, _244.y, _1046.y, _244.w);
    _379 += (-_244.z);
    _379 = (_921.x * _379) + _244.z;
    _1061 = _200.xy + 45.31999969482421875f.xx;
    _1061.x = dot(_200.xy, _1061);
    float2 _1074 = _200.xy + _1061.xx;
    _200 = float4(_1074.x, _1074.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _200.x = frac(_200.x);
    _269.x = (-_200.x) + _244.x;
    _921.x = (_921.x * _269.x) + _200.x;
    _379 = (-_921.x) + _379;
    _921.x = (_379 * 0.78400003910064697265625f) + _921.x;
    _921.x = (_921.x * 2.0f) + (-1.0f);
    _921.x *= _22_m17;
    _33.x = ((-_921.x) * _33.x) + _15.x;
    _9.x = (_9.x * _15.z) + _33.x;
    _33.x = (_15.y * _22_m29) + (-_22_m12);
    float3 _1167 = (_15.yyy * _22_m29.xxx) + float3(0.0199999995529651641845703125f, -0.20000000298023223876953125f, -0.85000002384185791015625f);
    _244 = float4(_1167.x, _1167.y, _1167.z, _244.w);
    float3 _1176 = _244.xyz * float3(12.5f, 1.4285714626312255859375f, 5.0000019073486328125f);
    _244 = float4(_1176.x, _1176.y, _1176.z, _244.w);
    float3 _1183 = clamp(_244.xyz, 0.0f.xxx, 1.0f.xxx);
    _244 = float4(_1183.x, _1183.y, _1183.z, _244.w);
    _921 = (-float2(float2(_22_m12, _22_m12))) + float2(1.0f, 1.0499999523162841796875f);
    _921 = 1.0f.xx / _921;
    float2 _1203 = _921 * _33.xx;
    _33 = float4(_1203.x, _33.y, _1203.y, _33.w);
    float2 _1210 = clamp(_33.xz, 0.0f.xx, 1.0f.xx);
    _33 = float4(_1210.x, _33.y, _1210.y, _33.w);
    float2 _1218 = (_33.xz * (-2.0f).xx) + 3.0f.xx;
    _200 = float4(_1218.x, _1218.y, _200.z, _200.w);
    float2 _1225 = _33.xz * _33.xz;
    _33 = float4(_1225.x, _33.y, _1225.y, _33.w);
    _65 = _33.x * _200.x;
    _33.x = ((-_200.y) * _33.z) + 1.0f;
    _65 = ((-_65) * 0.60000002384185791015625f) + 1.0f;
    _921.x = (_33.y * (-2.0f)) + 3.0f;
    _189.x = _33.y * _33.y;
    _189.x *= _921.x;
    _921.x = (-_22_m10) + _22_m11;
    _189.x = (_189.x * _921.x) + _22_m10;
    _921.x = _65 * _189.x;
    _379 = (-_22_m13) + 1.0f;
    _200.x = ((-_921.x) * _379) + abs(_9.x);
    _379 *= _921.x;
    _379 = (_189.x * _65) + (-_379);
    _65 = ((-_189.x) * _65) + abs(_9.x);
    _9.x = abs(_9.x) * (-3.0f);
    _189.x = 1.0f / _379;
    _189.x *= _200.x;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _379 = (_189.x * (-2.0f)) + 3.0f;
    _189.x *= _189.x;
    _189.x = ((-_379) * _189.x) + 1.0f;
    _379 = _446 * _189.x;
    float2 _1369 = (_446.xx * float2(0.628571450710296630859375f, 0.457142889499664306640625f)) + float2(0.449999988079071044921875f, 0.60000002384185791015625f);
    _1361 = float3(_1369.x, _1369.y, _1361.z);
    _446 = (_189.x * 0.5f) + 0.5f;
    float3 _1381 = (_244.xyz * (-2.0f).xxx) + 3.0f.xxx;
    _265 = float4(_1381.x, _1381.y, _1381.z, _265.w);
    float3 _1388 = _244.xyz * _244.xyz;
    _244 = float4(_1388.x, _1388.y, _1388.z, _244.w);
    _189.x = _244.x * _265.x;
    float2 _1403 = ((-_265.yz) * _244.yz) + 1.0f.xx;
    _200 = float4(_1403.x, _1403.y, _200.z, _200.w);
    _33.x *= _189.x;
    _189.x = _33.x * _379;
    _379 = (_15.z * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _379 *= _22_m16;
    _189.x = (_189.x * 1.8285715579986572265625f) + (-_379);
    _189.x *= 2.857142925262451171875f;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _379 = (_189.x * (-2.0f)) + 3.0f;
    _189.x *= _189.x;
    _189.x *= _379;
    _1459 = log2(_189.x);
    _1459 *= _22_m6;
    _1459 = exp2(_1459);
    _189.x = _15.z;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _189.x = (_189.x * (-0.550000011920928955078125f)) + 1.0f;
    _189.x *= _1459;
    _189.x = _1361.x * _189.x;
    _446 *= _189.x;
    _1361.x = (_22_m4 * 2.0f) + 1.0f;
    _1361.x = _446 * _1361.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1459 = _446 * 4.0f;
    _1459 = clamp(_1459, 0.0f, 1.0f);
    _1361.x = (_1361.x * _22_m31) + 0.5f;
    _1361.x = floor(_1361.x);
    _1361.x /= _22_m31;
    _1536 = (_1361.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _1543.z = _1536 * _22_m5;
    _446 = _15.w * _22_m27;
    _125 = _15.w * _22_m23;
    _220.x = floor(_446);
    _446 = frac(_446);
    float2 _1569 = _220 + float2(1.0f, 0.0f);
    _189 = float3(_1569.x, _189.y, _1569.y);
    _220 *= float2(123.339996337890625f, 456.209991455078125f);
    _220 = frac(_220);
    float2 _1578 = _189.xz * float2(123.339996337890625f, 456.209991455078125f);
    _189 = float3(_1578.x, _189.y, _1578.y);
    float2 _1583 = frac(_189.xz);
    _189 = float3(_1583.x, _189.y, _1583.y);
    _244.x = _189.x + 45.31999969482421875f;
    float2 _1597 = (_189.xx * _244.xx) + _189.xz;
    _189 = float3(_1597.x, _189.y, _1597.y);
    _189.x = _189.z * _189.x;
    _379 = _220.x + 45.31999969482421875f;
    _220 = (_220.xx * _379.xx) + _220;
    _189.z = _220.y * _220.x;
    float2 _1624 = frac(_189.xz);
    _189 = float3(_1624.x, _189.y, _1624.y);
    _189.x = (-_189.z) + _189.x;
    _220.x = _446 * _446;
    _446 = ((-_446) * 2.0f) + 3.0f;
    _446 *= _220.x;
    _446 = (_446 * _189.x) + _189.z;
    _1653.x = (-_22_m28) + 1.0f;
    _446 = (_22_m28 * _446) + _1653.x;
    _1653.x = _1361.x + (-0.3499999940395355224609375f);
    _1361.x *= 2.857142925262451171875f;
    _1361.x = _1361.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1653.x *= 2.2222220897674560546875f;
    _1653.x = clamp(_1653.x, 0.0f, 1.0f);
    _1692.x = (_1653.x * (-2.0f)) + 3.0f;
    _1653.x *= _1653.x;
    _1653.x *= _1692.x;
    _1692.x = (_1361.x * (-2.0f)) + 3.0f;
    _1361.x *= _1361.x;
    _1361.x *= _1692.x;
    _1692 = (-_22_m1.xyz) + _22_m2.xyz;
    _1692 = (_1361.xxx * _1692) + _22_m1.xyz;
    _1745 = (-_1692) + _22_m3.xyz;
    _1653 = (_1653.xxx * _1745) + _1692;
    _189.x = _921.x * _22_m20;
    _921.x = 1.0f / _921.x;
    _65 *= _921.x;
    _65 = clamp(_65, 0.0f, 1.0f);
    _189.x = max(_189.x, 9.9999997473787516355514526367188e-05f);
    _9.x /= _189.x;
    _9.x = exp2(_9.x);
    _9.x = _33.x * _9.x;
    _9.x = _200.x * _9.x;
    _1361.x = _1361.y * _9.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1361.x = (_1361.x * _22_m31) + 0.5f;
    _1361.x = floor(_1361.x);
    _1361.x /= _22_m31;
    _1543.x = _1361.x * _22_m21;
    _1361.x = max(_1361.x, _1459);
    _1361.x = min(_1361.x, 1.0f);
    float2 _1850 = _446.xx * _1543.xz;
    _1543 = float3(_1850.x, _1543.y, _1850.y);
    _1745 = _1543.xxx * _22_m3.xyz;
    _1543 = (_1653 * _1543.zzz) + _1745;
    float2 _1871 = _15.xz * _22_m22.xx;
    _9 = float4(_1871.x, _9.y, _9.z, _1871.y);
    _15.x = _15.z * 4.0f;
    _15.x = clamp(_15.x, 0.0f, 1.0f);
    _9.w = ((-_125) * _22_m22) + _9.w;
    float2 _1893 = frac(_9.xw);
    _33 = float4(_1893.x, _1893.y, _33.z, _33.w);
    _244 = floor(_9.xwxw);
    float2 _1903 = _33.xy + (-0.5f).xx;
    _9 = float4(_1903.x, _9.y, _9.z, _1903.y);
    _33 = _244 + float4(7.099999904632568359375f, 7.099999904632568359375f, 3.2999999523162841796875f, 3.2999999523162841796875f);
    _52 = _244.zw * float2(123.339996337890625f, 456.209991455078125f);
    _52 = frac(_52);
    _33 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = frac(_33);
    _244 = _33 + 45.31999969482421875f.xxxx;
    _200.x = dot(_33.xy, _244.xy);
    _200.z = dot(_33.zw, _244.zw);
    _33 += _200.xxzz;
    _33.x = _33.y * _33.x;
    _1061.x = frac(_33.x);
    _33.x = _33.w * _33.z;
    _1061.y = frac(_33.x);
    float2 _1959 = _1061 + (-0.5f).xx;
    _33 = float4(_1959.x, _1959.y, _33.z, _33.w);
    _921 = _52 + 45.31999969482421875f.xx;
    _921.x = dot(_52, _921);
    _52 += _921.xx;
    _52.x = _52.y * _52.x;
    _52.x = frac(_52.x);
    _1982 = (_52.xx * float2(6.283199787139892578125f, 40.0f)) + _9.yz;
    _1982 = sin(_1982);
    _1982.x *= 0.1500000059604644775390625f;
    _1999 = (_1982.y * 0.5f) + 0.5f;
    _33.x = (_33.x * 0.60000002384185791015625f) + _1982.x;
    _33.z = _33.y * 0.60000002384185791015625f;
    float2 _2020 = _9.xw + (-_33.xz);
    _9 = float4(_2020.x, _2020.y, _9.z, _9.w);
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x += (-_22_m24);
    _1982.x = 1.0f / (-_22_m24);
    _9.x = _1982.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1982.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _1982.x;
    _9.x = _1999 * _9.x;
    _1982.x = (-_22_m25) + 1.0f;
    _2086 = _52.x >= _1982.x;
    _1982.x = float(_2086);
    _9.x = _1982.x * _9.x;
    _1982.x = (_65 * (-2.0f)) + 3.0f;
    _1999 = _65 * _65;
    _1982.x = ((-_1982.x) * _1999) + 1.0f;
    _1982.x = _15.x * _1982.x;
    _1982.x = _200.y * _1982.x;
    _9.x = _1982.x * _9.x;
    _2133 = _9.x >= 0.5f;
    _9.x = float(_2133);
    _1653.x = _9.x * _22_m26;
    _2148.w = max(_9.x, _1361.x);
    _1692 = (-_22_m2.xyz) + _22_m3.xyz;
    _1692 = (_1692 * 0.60000002384185791015625f.xxx) + _22_m2.xyz;
    _1361 = (_1692 * _1653.xxx) + _1543;
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _2187 = _1361 * _9.xxx;
    _9 = float4(_2187.x, _2187.y, _2187.z, _9.w);
    _2148 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _2148.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2148 = _2148;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(_SPARKS_ON)
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
float4 _EdgeColor;
float4 _MidColor;
float4 _CoreColor;
float _WhiteBias;
float _Intensity;
float _Contrast;
float4 _RootUV;
float4 _TipUV;
float _AcrossScale;
float _RootWidth;
float _MaxWidth;
float _TipStart;
float _EdgeSoftness;
float _FlameScale;
float _FlameSpeed;
float _Erosion;
float _Wiggle;
float _WiggleSpeed;
float _WarpStrength;
float _CoreWidth;
float _CoreIntensity;
float _SparkDensity;
float _SparkSpeed;
float _SparkSize;
float _SparkChance;
float _SparkIntensity;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _22_m0 _Time
#define _22_m1 _EdgeColor
#define _22_m2 _MidColor
#define _22_m3 _CoreColor
#define _22_m4 _WhiteBias
#define _22_m5 _Intensity
#define _22_m6 _Contrast
#define _22_m7 _RootUV
#define _22_m8 _TipUV
#define _22_m9 _AcrossScale
#define _22_m10 _RootWidth
#define _22_m11 _MaxWidth
#define _22_m12 _TipStart
#define _22_m13 _EdgeSoftness
#define _22_m14 _FlameScale
#define _22_m15 _FlameSpeed
#define _22_m16 _Erosion
#define _22_m17 _Wiggle
#define _22_m18 _WiggleSpeed
#define _22_m19 _WarpStrength
#define _22_m20 _CoreWidth
#define _22_m21 _CoreIntensity
#define _22_m22 _SparkDensity
#define _22_m23 _SparkSpeed
#define _22_m24 _SparkSize
#define _22_m25 _SparkChance
#define _22_m26 _SparkIntensity
#define _22_m27 _PulseSpeed
#define _22_m28 _PulseAmount
#define _22_m29 _PixelSize
#define _22_m30 _FrameRate
#define _22_m31 _Steps



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _2148;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _2148 : SV_Target0;
};

static float4 _9;
static float4 _15;
static float4 _33;
static float2 _52;
static float _65;
static float _125;
static float3 _189;
static float4 _200;
static float2 _220;
static float4 _244;
static float4 _265;
static float3 _269;
static float _379;
static float _446;
static float _482;
static float2 _533;
static float4 _672;
static float _681;
static float2 _755;
static float2 _921;
static float2 _1061;
static float3 _1361;
static float _1459;
static float _1536;
static float3 _1543;
static float3 _1653;
static float3 _1692;
static float3 _1745;
static float2 _1982;
static float _1999;
static bool _2086;
static bool _2133;

void frag_inner()
{
    _9.w = 1.2999999523162841796875f;
    float2 _30 = vs_TEXCOORD0 + (-_22_m7.xy);
    _15 = float4(_30.x, _30.y, _15.z, _15.w);
    float2 _42 = (-_22_m7.xy) + _22_m8.xy;
    _33 = float4(_42.x, _42.y, _33.z, _33.w);
    _33.z = -_33.x;
    _52.x = dot(_15.xy, _33.yz);
    _15.x = dot(_15.xy, _33.xy);
    _65 = dot(_33.xy, _33.xy);
    _65 = max(_65, 9.9999997473787516355514526367188e-06f);
    _65 = 1.0f / _65;
    _33.y = _65 * _15.x;
    _15.x = _65 * _52.x;
    _33.x = _15.x * _22_m9;
    float2 _102 = _33.xy / _22_m29.xx;
    _15 = float4(_102.x, _102.y, _15.z, _15.w);
    float2 _107 = floor(_15.xy);
    _15 = float4(_107.x, _107.y, _15.z, _15.w);
    float2 _114 = _15.xy + 0.5f.xx;
    _15 = float4(_114.x, _114.y, _15.z, _15.w);
    float2 _122 = _15.xy * _22_m29.xx;
    _15 = float4(_122.x, _15.y, _122.y, _15.w);
    _125 = vs_TEXCOORD1 + _22_m0.y;
    _125 *= _22_m30;
    _125 = floor(_125);
    _15.w = _125 / _22_m30;
    float3 _157 = _15.xzw * float3(_22_m14, _22_m14, _22_m15);
    _33 = float4(_157.x, _157.y, _33.z, _157.z);
    _33.z = (_33.y * 0.449999988079071044921875f) + (-_33.w);
    float3 _175 = _15.www * float3(0.699999988079071044921875f, 3.0f, 9.0f);
    _9 = float4(_175.x, _175.y, _175.z, _9.w);
    float2 _185 = (_33.xz * 0.800000011920928955078125f.xx) + _9.wx;
    _9 = float4(_185.x, _9.y, _9.z, _185.y);
    float2 _192 = floor(_9.xw);
    _189 = float3(_192.x, _189.y, _192.y);
    float2 _197 = frac(_9.xw);
    _9 = float4(_197.x, _9.y, _9.z, _197.y);
    float2 _204 = _189.xz + 1.0f.xx;
    _200 = float4(_204.x, _204.y, _200.z, _200.w);
    float2 _212 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_212.x, _212.y, _200.z, _200.w);
    float2 _217 = frac(_200.xy);
    _200 = float4(_217.x, _217.y, _200.z, _200.w);
    _220 = _200.xy + 45.31999969482421875f.xx;
    _220.x = dot(_200.xy, _220);
    float2 _235 = _220.xx + _200.xy;
    _200 = float4(_235.x, _235.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _244 = _189.xzxz + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _252 = _189.xz * float2(123.339996337890625f, 456.209991455078125f);
    _189 = float3(_252.x, _189.y, _252.y);
    float2 _257 = frac(_189.xz);
    _189 = float3(_257.x, _189.y, _257.y);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _269.x = dot(_244.zw, _265.zw);
    _220.x = dot(_244.xy, _265.xy);
    _220 = _220.xx + _244.xy;
    float2 _291 = _269.xx + _244.zw;
    _244 = float4(_291.x, _291.y, _244.z, _244.w);
    _200.y = _244.y * _244.x;
    _200.z = _220.y * _220.x;
    float3 _308 = frac(_200.xyz);
    _200 = float4(_308.x, _308.y, _308.z, _200.w);
    _200.x = (-_200.y) + _200.x;
    float2 _322 = _9.xw * _9.xw;
    _244 = float4(_322.x, _322.y, _244.z, _244.w);
    float2 _332 = ((-_9.xw) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_332.x, _9.y, _9.z, _332.y);
    float2 _339 = _9.xw * _244.xy;
    _9 = float4(_339.x, _9.y, _9.z, _339.y);
    _200.x = (_9.x * _200.x) + _200.y;
    float2 _353 = _189.xz + 45.31999969482421875f.xx;
    _269 = float3(_353.x, _269.y, _353.y);
    _269.x = dot(_189.xz, _269.xz);
    float2 _366 = _189.xz + _269.xx;
    _189 = float3(_366.x, _189.y, _366.y);
    _189.x = _189.z * _189.x;
    _189.x = frac(_189.x);
    _379 = (-_189.x) + _200.z;
    _9.x = (_9.x * _379) + _189.x;
    _189.x = (-_9.x) + _200.x;
    _9.x = (_9.w * _189.x) + _9.x;
    _9.x = (_9.x * 2.0f) + (-1.0f);
    _33 = (_9.xxxx * 0.5f.xxxx) + _33.xzxz;
    _9.x *= _22_m19;
    float2 _432 = floor(_33.zw);
    _200 = float4(_432.x, _432.y, _200.z, _200.w);
    _220 = _200.xy + 1.0f.xx;
    _220 *= float2(123.339996337890625f, 456.209991455078125f);
    _220 = frac(_220);
    float2 _443 = _220 + 45.31999969482421875f.xx;
    _244 = float4(_443.x, _443.y, _244.z, _244.w);
    _446 = dot(_220, _244.xy);
    _220 = _446.xx + _220;
    _446 = _220.y * _220.x;
    _446 = frac(_446);
    _244 = _200.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _467 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_467.x, _467.y, _200.z, _200.w);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _220.x = dot(_244.zw, _265.zw);
    _482 = dot(_244.xy, _265.xy);
    float2 _492 = _482.xx + _244.xy;
    _244 = float4(_492.x, _492.y, _244.z, _244.w);
    _220 = _220.xx + _244.zw;
    _200.z = _220.y * _220.x;
    _200.w = _244.y * _244.x;
    _200 = frac(_200);
    _446 += (-_200.z);
    float2 _521 = frac(_33.zw);
    _244 = float4(_521.x, _521.y, _244.z, _244.w);
    _33 = (_33 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _533 = _244.xy * _244.xy;
    float2 _543 = ((-_244.xy) * 2.0f.xx) + 3.0f.xx;
    _244 = float4(_543.x, _543.y, _244.z, _244.w);
    float2 _549 = _244.xy * _533;
    _244 = float4(_549.x, _549.y, _244.z, _244.w);
    _446 = (_244.x * _446) + _200.z;
    _533 = _200.xy + 45.31999969482421875f.xx;
    _220.x = dot(_200.xy, _533);
    float2 _571 = _220.xx + _200.xy;
    _200 = float4(_571.x, _571.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _200.x = frac(_200.x);
    _269.x = (-_200.x) + _200.w;
    _200.x = (_244.x * _269.x) + _200.x;
    _446 += (-_200.x);
    _446 = (_244.y * _446) + _200.x;
    _200 = frac(_33);
    _33 = floor(_33);
    _244 = _200 * _200;
    _200 = ((-_200) * 2.0f.xxxx) + 3.0f.xxxx;
    _200 *= _244;
    _244 = _33 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _265.x = dot(_244.xy, _265.xy);
    _265.y = dot(_244.zw, _265.zw);
    _244 += _265.xxyy;
    _244.x = _244.y * _244.x;
    _244.y = _244.w * _244.z;
    _265 = _33.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _265 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _265 = frac(_265);
    _672 = _265 + 45.31999969482421875f.xxxx;
    _533.x = dot(_265.zw, _672.zw);
    _681 = dot(_265.xy, _672.xy);
    float2 _691 = _681.xx + _265.xy;
    _265 = float4(_691.x, _691.y, _265.z, _265.w);
    _533 = _533.xx + _265.zw;
    _244.z = _533.y * _533.x;
    _244.w = _265.y * _265.x;
    _244 = frac(_244);
    _244.x = (-_244.z) + _244.x;
    _244.x = (_200.x * _244.x) + _244.z;
    _265 = _33 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = _33.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _33 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = frac(_33);
    _265 = frac(_265);
    _672 = _265 + 45.31999969482421875f.xxxx;
    _533.x = dot(_265.xy, _672.xy);
    _672.x = dot(_265.zw, _672.zw);
    _755 = _265.zw + _672.xx;
    float2 _765 = _533.xx + _265.xy;
    _265 = float4(_765.x, _765.y, _265.z, _265.w);
    _533.x = _265.y * _265.x;
    _533.x = frac(_533.x);
    _265.x = _755.y * _755.x;
    _265.x = frac(_265.x);
    _681 = (-_533.x) + _244.w;
    _200.x = (_200.x * _681) + _533.x;
    _244.x = (-_200.x) + _244.x;
    _200.x = (_200.y * _244.x) + _200.x;
    _200.x *= 0.25f;
    _446 = (_446 * 0.5f) + _200.x;
    _672 = _33 + 45.31999969482421875f.xxxx;
    _200.x = dot(_33.zw, _672.zw);
    _200.y = dot(_33.xy, _672.xy);
    _33 += _200.yyxx;
    float2 _850 = _33.yw * _33.xz;
    _33 = float4(_850.x, _33.y, _850.y, _33.w);
    float2 _855 = frac(_33.xz);
    _33 = float4(_855.x, _33.y, _855.y, _33.w);
    _189.x = (-_33.x) + _33.z;
    _33.x = (_200.z * _189.x) + _33.x;
    _189.x = _244.y + (-_265.x);
    _189.x = (_200.z * _189.x) + _265.x;
    _33.x = (-_189.x) + _33.x;
    _33.x = (_200.w * _33.x) + _189.x;
    _446 = (_33.x * 0.125f) + _446;
    float3 _918 = _15.zzz * float3(1.5f, 2.22222232818603515625f, 2.5f);
    _33 = float4(_918.x, _918.y, _918.z, _33.w);
    _921.x = ((-_15.w) * _22_m18) + _33.z;
    _33 = float4(_33.xy.x, _33.xy.y, _33.z, _33.w);
    float2 _941 = clamp(_33.xy, 0.0f.xx, 1.0f.xx);
    _33 = float4(_941.x, _941.y, _33.z, _33.w);
    _379 = frac(_921.x);
    _200.x = floor(_921.x);
    _921.x = _379 * _379;
    _379 = ((-_379) * 2.0f) + 3.0f;
    _921.x = _379 * _921.x;
    _200.y = 3.0f;
    _220.y = 0.0f;
    float2 _968 = _200.xy + 1.0f.xx;
    _244 = float4(_968.x, _968.y, _244.z, _244.w);
    float2 _973 = _244.xy * float2(123.339996337890625f, 456.209991455078125f);
    _244 = float4(_973.x, _973.y, _244.z, _244.w);
    float2 _978 = frac(_244.xy);
    _244 = float4(_978.x, _978.y, _244.z, _244.w);
    _533 = _244.xy + 45.31999969482421875f.xx;
    _379 = dot(_244.xy, _533);
    float2 _992 = _379.xx + _244.xy;
    _244 = float4(_992.x, _992.y, _244.z, _244.w);
    _379 = _244.y * _244.x;
    _379 = frac(_379);
    _244 = _200.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _1007 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_1007.x, _1007.y, _200.z, _200.w);
    float2 _1012 = frac(_200.xy);
    _200 = float4(_1012.x, _1012.y, _200.z, _200.w);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _265.z = dot(_244.zw, _265.zw);
    _265.x = dot(_244.xy, _265.xy);
    _244 += _265.xxzz;
    float2 _1041 = _244.yw * _244.xz;
    _244 = float4(_1041.x, _244.y, _1041.y, _244.w);
    float2 _1046 = frac(_244.xz);
    _244 = float4(_1046.x, _244.y, _1046.y, _244.w);
    _379 += (-_244.z);
    _379 = (_921.x * _379) + _244.z;
    _1061 = _200.xy + 45.31999969482421875f.xx;
    _1061.x = dot(_200.xy, _1061);
    float2 _1074 = _200.xy + _1061.xx;
    _200 = float4(_1074.x, _1074.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _200.x = frac(_200.x);
    _269.x = (-_200.x) + _244.x;
    _921.x = (_921.x * _269.x) + _200.x;
    _379 = (-_921.x) + _379;
    _921.x = (_379 * 0.78400003910064697265625f) + _921.x;
    _921.x = (_921.x * 2.0f) + (-1.0f);
    _921.x *= _22_m17;
    _33.x = ((-_921.x) * _33.x) + _15.x;
    _9.x = (_9.x * _15.z) + _33.x;
    _33.x = (_15.y * _22_m29) + (-_22_m12);
    float3 _1167 = (_15.yyy * _22_m29.xxx) + float3(0.0199999995529651641845703125f, -0.20000000298023223876953125f, -0.85000002384185791015625f);
    _244 = float4(_1167.x, _1167.y, _1167.z, _244.w);
    float3 _1176 = _244.xyz * float3(12.5f, 1.4285714626312255859375f, 5.0000019073486328125f);
    _244 = float4(_1176.x, _1176.y, _1176.z, _244.w);
    float3 _1183 = clamp(_244.xyz, 0.0f.xxx, 1.0f.xxx);
    _244 = float4(_1183.x, _1183.y, _1183.z, _244.w);
    _921 = (-float2(float2(_22_m12, _22_m12))) + float2(1.0f, 1.0499999523162841796875f);
    _921 = 1.0f.xx / _921;
    float2 _1203 = _921 * _33.xx;
    _33 = float4(_1203.x, _33.y, _1203.y, _33.w);
    float2 _1210 = clamp(_33.xz, 0.0f.xx, 1.0f.xx);
    _33 = float4(_1210.x, _33.y, _1210.y, _33.w);
    float2 _1218 = (_33.xz * (-2.0f).xx) + 3.0f.xx;
    _200 = float4(_1218.x, _1218.y, _200.z, _200.w);
    float2 _1225 = _33.xz * _33.xz;
    _33 = float4(_1225.x, _33.y, _1225.y, _33.w);
    _65 = _33.x * _200.x;
    _33.x = ((-_200.y) * _33.z) + 1.0f;
    _65 = ((-_65) * 0.60000002384185791015625f) + 1.0f;
    _921.x = (_33.y * (-2.0f)) + 3.0f;
    _189.x = _33.y * _33.y;
    _189.x *= _921.x;
    _921.x = (-_22_m10) + _22_m11;
    _189.x = (_189.x * _921.x) + _22_m10;
    _921.x = _65 * _189.x;
    _379 = (-_22_m13) + 1.0f;
    _200.x = ((-_921.x) * _379) + abs(_9.x);
    _379 *= _921.x;
    _379 = (_189.x * _65) + (-_379);
    _65 = ((-_189.x) * _65) + abs(_9.x);
    _9.x = abs(_9.x) * (-3.0f);
    _189.x = 1.0f / _379;
    _189.x *= _200.x;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _379 = (_189.x * (-2.0f)) + 3.0f;
    _189.x *= _189.x;
    _189.x = ((-_379) * _189.x) + 1.0f;
    _379 = _446 * _189.x;
    float2 _1369 = (_446.xx * float2(0.628571450710296630859375f, 0.457142889499664306640625f)) + float2(0.449999988079071044921875f, 0.60000002384185791015625f);
    _1361 = float3(_1369.x, _1369.y, _1361.z);
    _446 = (_189.x * 0.5f) + 0.5f;
    float3 _1381 = (_244.xyz * (-2.0f).xxx) + 3.0f.xxx;
    _265 = float4(_1381.x, _1381.y, _1381.z, _265.w);
    float3 _1388 = _244.xyz * _244.xyz;
    _244 = float4(_1388.x, _1388.y, _1388.z, _244.w);
    _189.x = _244.x * _265.x;
    float2 _1403 = ((-_265.yz) * _244.yz) + 1.0f.xx;
    _200 = float4(_1403.x, _1403.y, _200.z, _200.w);
    _33.x *= _189.x;
    _189.x = _33.x * _379;
    _379 = (_15.z * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _379 *= _22_m16;
    _189.x = (_189.x * 1.8285715579986572265625f) + (-_379);
    _189.x *= 2.857142925262451171875f;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _379 = (_189.x * (-2.0f)) + 3.0f;
    _189.x *= _189.x;
    _189.x *= _379;
    _1459 = log2(_189.x);
    _1459 *= _22_m6;
    _1459 = exp2(_1459);
    _189.x = _15.z;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _189.x = (_189.x * (-0.550000011920928955078125f)) + 1.0f;
    _189.x *= _1459;
    _189.x = _1361.x * _189.x;
    _446 *= _189.x;
    _1361.x = (_22_m4 * 2.0f) + 1.0f;
    _1361.x = _446 * _1361.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1459 = _446 * 4.0f;
    _1459 = clamp(_1459, 0.0f, 1.0f);
    _1361.x = (_1361.x * _22_m31) + 0.5f;
    _1361.x = floor(_1361.x);
    _1361.x /= _22_m31;
    _1536 = (_1361.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _1543.z = _1536 * _22_m5;
    _446 = _15.w * _22_m27;
    _125 = _15.w * _22_m23;
    _220.x = floor(_446);
    _446 = frac(_446);
    float2 _1569 = _220 + float2(1.0f, 0.0f);
    _189 = float3(_1569.x, _189.y, _1569.y);
    _220 *= float2(123.339996337890625f, 456.209991455078125f);
    _220 = frac(_220);
    float2 _1578 = _189.xz * float2(123.339996337890625f, 456.209991455078125f);
    _189 = float3(_1578.x, _189.y, _1578.y);
    float2 _1583 = frac(_189.xz);
    _189 = float3(_1583.x, _189.y, _1583.y);
    _244.x = _189.x + 45.31999969482421875f;
    float2 _1597 = (_189.xx * _244.xx) + _189.xz;
    _189 = float3(_1597.x, _189.y, _1597.y);
    _189.x = _189.z * _189.x;
    _379 = _220.x + 45.31999969482421875f;
    _220 = (_220.xx * _379.xx) + _220;
    _189.z = _220.y * _220.x;
    float2 _1624 = frac(_189.xz);
    _189 = float3(_1624.x, _189.y, _1624.y);
    _189.x = (-_189.z) + _189.x;
    _220.x = _446 * _446;
    _446 = ((-_446) * 2.0f) + 3.0f;
    _446 *= _220.x;
    _446 = (_446 * _189.x) + _189.z;
    _1653.x = (-_22_m28) + 1.0f;
    _446 = (_22_m28 * _446) + _1653.x;
    _1653.x = _1361.x + (-0.3499999940395355224609375f);
    _1361.x *= 2.857142925262451171875f;
    _1361.x = _1361.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1653.x *= 2.2222220897674560546875f;
    _1653.x = clamp(_1653.x, 0.0f, 1.0f);
    _1692.x = (_1653.x * (-2.0f)) + 3.0f;
    _1653.x *= _1653.x;
    _1653.x *= _1692.x;
    _1692.x = (_1361.x * (-2.0f)) + 3.0f;
    _1361.x *= _1361.x;
    _1361.x *= _1692.x;
    _1692 = (-_22_m1.xyz) + _22_m2.xyz;
    _1692 = (_1361.xxx * _1692) + _22_m1.xyz;
    _1745 = (-_1692) + _22_m3.xyz;
    _1653 = (_1653.xxx * _1745) + _1692;
    _189.x = _921.x * _22_m20;
    _921.x = 1.0f / _921.x;
    _65 *= _921.x;
    _65 = clamp(_65, 0.0f, 1.0f);
    _189.x = max(_189.x, 9.9999997473787516355514526367188e-05f);
    _9.x /= _189.x;
    _9.x = exp2(_9.x);
    _9.x = _33.x * _9.x;
    _9.x = _200.x * _9.x;
    _1361.x = _1361.y * _9.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1361.x = (_1361.x * _22_m31) + 0.5f;
    _1361.x = floor(_1361.x);
    _1361.x /= _22_m31;
    _1543.x = _1361.x * _22_m21;
    _1361.x = max(_1361.x, _1459);
    _1361.x = min(_1361.x, 1.0f);
    float2 _1850 = _446.xx * _1543.xz;
    _1543 = float3(_1850.x, _1543.y, _1850.y);
    _1745 = _1543.xxx * _22_m3.xyz;
    _1543 = (_1653 * _1543.zzz) + _1745;
    float2 _1871 = _15.xz * _22_m22.xx;
    _9 = float4(_1871.x, _9.y, _9.z, _1871.y);
    _15.x = _15.z * 4.0f;
    _15.x = clamp(_15.x, 0.0f, 1.0f);
    _9.w = ((-_125) * _22_m22) + _9.w;
    float2 _1893 = frac(_9.xw);
    _33 = float4(_1893.x, _1893.y, _33.z, _33.w);
    _244 = floor(_9.xwxw);
    float2 _1903 = _33.xy + (-0.5f).xx;
    _9 = float4(_1903.x, _9.y, _9.z, _1903.y);
    _33 = _244 + float4(7.099999904632568359375f, 7.099999904632568359375f, 3.2999999523162841796875f, 3.2999999523162841796875f);
    _52 = _244.zw * float2(123.339996337890625f, 456.209991455078125f);
    _52 = frac(_52);
    _33 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = frac(_33);
    _244 = _33 + 45.31999969482421875f.xxxx;
    _200.x = dot(_33.xy, _244.xy);
    _200.z = dot(_33.zw, _244.zw);
    _33 += _200.xxzz;
    _33.x = _33.y * _33.x;
    _1061.x = frac(_33.x);
    _33.x = _33.w * _33.z;
    _1061.y = frac(_33.x);
    float2 _1959 = _1061 + (-0.5f).xx;
    _33 = float4(_1959.x, _1959.y, _33.z, _33.w);
    _921 = _52 + 45.31999969482421875f.xx;
    _921.x = dot(_52, _921);
    _52 += _921.xx;
    _52.x = _52.y * _52.x;
    _52.x = frac(_52.x);
    _1982 = (_52.xx * float2(6.283199787139892578125f, 40.0f)) + _9.yz;
    _1982 = sin(_1982);
    _1982.x *= 0.1500000059604644775390625f;
    _1999 = (_1982.y * 0.5f) + 0.5f;
    _33.x = (_33.x * 0.60000002384185791015625f) + _1982.x;
    _33.z = _33.y * 0.60000002384185791015625f;
    float2 _2020 = _9.xw + (-_33.xz);
    _9 = float4(_2020.x, _2020.y, _9.z, _9.w);
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x += (-_22_m24);
    _1982.x = 1.0f / (-_22_m24);
    _9.x = _1982.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1982.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _1982.x;
    _9.x = _1999 * _9.x;
    _1982.x = (-_22_m25) + 1.0f;
    _2086 = _52.x >= _1982.x;
    _1982.x = float(_2086);
    _9.x = _1982.x * _9.x;
    _1982.x = (_65 * (-2.0f)) + 3.0f;
    _1999 = _65 * _65;
    _1982.x = ((-_1982.x) * _1999) + 1.0f;
    _1982.x = _15.x * _1982.x;
    _1982.x = _200.y * _1982.x;
    _9.x = _1982.x * _9.x;
    _2133 = _9.x >= 0.5f;
    _9.x = float(_2133);
    _1653.x = _9.x * _22_m26;
    _2148.w = max(_9.x, _1361.x);
    _1692 = (-_22_m2.xyz) + _22_m3.xyz;
    _1692 = (_1692 * 0.60000002384185791015625f.xxx) + _22_m2.xyz;
    _1361 = (_1692 * _1653.xxx) + _1543;
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _2187 = _1361 * _9.xxx;
    _9 = float4(_2187.x, _2187.y, _2187.z, _9.w);
    _2148 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _2148.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2148 = _2148;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(_SPARKS_ON)
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
float4 _EdgeColor;
float4 _MidColor;
float4 _CoreColor;
float _WhiteBias;
float _Intensity;
float _Contrast;
float4 _RootUV;
float4 _TipUV;
float _AcrossScale;
float _RootWidth;
float _MaxWidth;
float _TipStart;
float _EdgeSoftness;
float _FlameScale;
float _FlameSpeed;
float _Erosion;
float _Wiggle;
float _WiggleSpeed;
float _WarpStrength;
float _CoreWidth;
float _CoreIntensity;
float _SparkDensity;
float _SparkSpeed;
float _SparkSize;
float _SparkChance;
float _SparkIntensity;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _22_m0 _Time
#define _22_m1 _EdgeColor
#define _22_m2 _MidColor
#define _22_m3 _CoreColor
#define _22_m4 _WhiteBias
#define _22_m5 _Intensity
#define _22_m6 _Contrast
#define _22_m7 _RootUV
#define _22_m8 _TipUV
#define _22_m9 _AcrossScale
#define _22_m10 _RootWidth
#define _22_m11 _MaxWidth
#define _22_m12 _TipStart
#define _22_m13 _EdgeSoftness
#define _22_m14 _FlameScale
#define _22_m15 _FlameSpeed
#define _22_m16 _Erosion
#define _22_m17 _Wiggle
#define _22_m18 _WiggleSpeed
#define _22_m19 _WarpStrength
#define _22_m20 _CoreWidth
#define _22_m21 _CoreIntensity
#define _22_m22 _SparkDensity
#define _22_m23 _SparkSpeed
#define _22_m24 _SparkSize
#define _22_m25 _SparkChance
#define _22_m26 _SparkIntensity
#define _22_m27 _PulseSpeed
#define _22_m28 _PulseAmount
#define _22_m29 _PixelSize
#define _22_m30 _FrameRate
#define _22_m31 _Steps



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _2148;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _2148 : SV_Target0;
};

static float4 _9;
static float4 _15;
static float4 _33;
static float2 _52;
static float _65;
static float _125;
static float3 _189;
static float4 _200;
static float2 _220;
static float4 _244;
static float4 _265;
static float3 _269;
static float _379;
static float _446;
static float _482;
static float2 _533;
static float4 _672;
static float _681;
static float2 _755;
static float2 _921;
static float2 _1061;
static float3 _1361;
static float _1459;
static float _1536;
static float3 _1543;
static float3 _1653;
static float3 _1692;
static float3 _1745;
static float2 _1982;
static float _1999;
static bool _2086;
static bool _2133;

void frag_inner()
{
    _9.w = 1.2999999523162841796875f;
    float2 _30 = vs_TEXCOORD0 + (-_22_m7.xy);
    _15 = float4(_30.x, _30.y, _15.z, _15.w);
    float2 _42 = (-_22_m7.xy) + _22_m8.xy;
    _33 = float4(_42.x, _42.y, _33.z, _33.w);
    _33.z = -_33.x;
    _52.x = dot(_15.xy, _33.yz);
    _15.x = dot(_15.xy, _33.xy);
    _65 = dot(_33.xy, _33.xy);
    _65 = max(_65, 9.9999997473787516355514526367188e-06f);
    _65 = 1.0f / _65;
    _33.y = _65 * _15.x;
    _15.x = _65 * _52.x;
    _33.x = _15.x * _22_m9;
    float2 _102 = _33.xy / _22_m29.xx;
    _15 = float4(_102.x, _102.y, _15.z, _15.w);
    float2 _107 = floor(_15.xy);
    _15 = float4(_107.x, _107.y, _15.z, _15.w);
    float2 _114 = _15.xy + 0.5f.xx;
    _15 = float4(_114.x, _114.y, _15.z, _15.w);
    float2 _122 = _15.xy * _22_m29.xx;
    _15 = float4(_122.x, _15.y, _122.y, _15.w);
    _125 = vs_TEXCOORD1 + _22_m0.y;
    _125 *= _22_m30;
    _125 = floor(_125);
    _15.w = _125 / _22_m30;
    float3 _157 = _15.xzw * float3(_22_m14, _22_m14, _22_m15);
    _33 = float4(_157.x, _157.y, _33.z, _157.z);
    _33.z = (_33.y * 0.449999988079071044921875f) + (-_33.w);
    float3 _175 = _15.www * float3(0.699999988079071044921875f, 3.0f, 9.0f);
    _9 = float4(_175.x, _175.y, _175.z, _9.w);
    float2 _185 = (_33.xz * 0.800000011920928955078125f.xx) + _9.wx;
    _9 = float4(_185.x, _9.y, _9.z, _185.y);
    float2 _192 = floor(_9.xw);
    _189 = float3(_192.x, _189.y, _192.y);
    float2 _197 = frac(_9.xw);
    _9 = float4(_197.x, _9.y, _9.z, _197.y);
    float2 _204 = _189.xz + 1.0f.xx;
    _200 = float4(_204.x, _204.y, _200.z, _200.w);
    float2 _212 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_212.x, _212.y, _200.z, _200.w);
    float2 _217 = frac(_200.xy);
    _200 = float4(_217.x, _217.y, _200.z, _200.w);
    _220 = _200.xy + 45.31999969482421875f.xx;
    _220.x = dot(_200.xy, _220);
    float2 _235 = _220.xx + _200.xy;
    _200 = float4(_235.x, _235.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _244 = _189.xzxz + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _252 = _189.xz * float2(123.339996337890625f, 456.209991455078125f);
    _189 = float3(_252.x, _189.y, _252.y);
    float2 _257 = frac(_189.xz);
    _189 = float3(_257.x, _189.y, _257.y);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _269.x = dot(_244.zw, _265.zw);
    _220.x = dot(_244.xy, _265.xy);
    _220 = _220.xx + _244.xy;
    float2 _291 = _269.xx + _244.zw;
    _244 = float4(_291.x, _291.y, _244.z, _244.w);
    _200.y = _244.y * _244.x;
    _200.z = _220.y * _220.x;
    float3 _308 = frac(_200.xyz);
    _200 = float4(_308.x, _308.y, _308.z, _200.w);
    _200.x = (-_200.y) + _200.x;
    float2 _322 = _9.xw * _9.xw;
    _244 = float4(_322.x, _322.y, _244.z, _244.w);
    float2 _332 = ((-_9.xw) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_332.x, _9.y, _9.z, _332.y);
    float2 _339 = _9.xw * _244.xy;
    _9 = float4(_339.x, _9.y, _9.z, _339.y);
    _200.x = (_9.x * _200.x) + _200.y;
    float2 _353 = _189.xz + 45.31999969482421875f.xx;
    _269 = float3(_353.x, _269.y, _353.y);
    _269.x = dot(_189.xz, _269.xz);
    float2 _366 = _189.xz + _269.xx;
    _189 = float3(_366.x, _189.y, _366.y);
    _189.x = _189.z * _189.x;
    _189.x = frac(_189.x);
    _379 = (-_189.x) + _200.z;
    _9.x = (_9.x * _379) + _189.x;
    _189.x = (-_9.x) + _200.x;
    _9.x = (_9.w * _189.x) + _9.x;
    _9.x = (_9.x * 2.0f) + (-1.0f);
    _33 = (_9.xxxx * 0.5f.xxxx) + _33.xzxz;
    _9.x *= _22_m19;
    float2 _432 = floor(_33.zw);
    _200 = float4(_432.x, _432.y, _200.z, _200.w);
    _220 = _200.xy + 1.0f.xx;
    _220 *= float2(123.339996337890625f, 456.209991455078125f);
    _220 = frac(_220);
    float2 _443 = _220 + 45.31999969482421875f.xx;
    _244 = float4(_443.x, _443.y, _244.z, _244.w);
    _446 = dot(_220, _244.xy);
    _220 = _446.xx + _220;
    _446 = _220.y * _220.x;
    _446 = frac(_446);
    _244 = _200.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _467 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_467.x, _467.y, _200.z, _200.w);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _220.x = dot(_244.zw, _265.zw);
    _482 = dot(_244.xy, _265.xy);
    float2 _492 = _482.xx + _244.xy;
    _244 = float4(_492.x, _492.y, _244.z, _244.w);
    _220 = _220.xx + _244.zw;
    _200.z = _220.y * _220.x;
    _200.w = _244.y * _244.x;
    _200 = frac(_200);
    _446 += (-_200.z);
    float2 _521 = frac(_33.zw);
    _244 = float4(_521.x, _521.y, _244.z, _244.w);
    _33 = (_33 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _533 = _244.xy * _244.xy;
    float2 _543 = ((-_244.xy) * 2.0f.xx) + 3.0f.xx;
    _244 = float4(_543.x, _543.y, _244.z, _244.w);
    float2 _549 = _244.xy * _533;
    _244 = float4(_549.x, _549.y, _244.z, _244.w);
    _446 = (_244.x * _446) + _200.z;
    _533 = _200.xy + 45.31999969482421875f.xx;
    _220.x = dot(_200.xy, _533);
    float2 _571 = _220.xx + _200.xy;
    _200 = float4(_571.x, _571.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _200.x = frac(_200.x);
    _269.x = (-_200.x) + _200.w;
    _200.x = (_244.x * _269.x) + _200.x;
    _446 += (-_200.x);
    _446 = (_244.y * _446) + _200.x;
    _200 = frac(_33);
    _33 = floor(_33);
    _244 = _200 * _200;
    _200 = ((-_200) * 2.0f.xxxx) + 3.0f.xxxx;
    _200 *= _244;
    _244 = _33 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _265.x = dot(_244.xy, _265.xy);
    _265.y = dot(_244.zw, _265.zw);
    _244 += _265.xxyy;
    _244.x = _244.y * _244.x;
    _244.y = _244.w * _244.z;
    _265 = _33.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _265 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _265 = frac(_265);
    _672 = _265 + 45.31999969482421875f.xxxx;
    _533.x = dot(_265.zw, _672.zw);
    _681 = dot(_265.xy, _672.xy);
    float2 _691 = _681.xx + _265.xy;
    _265 = float4(_691.x, _691.y, _265.z, _265.w);
    _533 = _533.xx + _265.zw;
    _244.z = _533.y * _533.x;
    _244.w = _265.y * _265.x;
    _244 = frac(_244);
    _244.x = (-_244.z) + _244.x;
    _244.x = (_200.x * _244.x) + _244.z;
    _265 = _33 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = _33.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _33 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = frac(_33);
    _265 = frac(_265);
    _672 = _265 + 45.31999969482421875f.xxxx;
    _533.x = dot(_265.xy, _672.xy);
    _672.x = dot(_265.zw, _672.zw);
    _755 = _265.zw + _672.xx;
    float2 _765 = _533.xx + _265.xy;
    _265 = float4(_765.x, _765.y, _265.z, _265.w);
    _533.x = _265.y * _265.x;
    _533.x = frac(_533.x);
    _265.x = _755.y * _755.x;
    _265.x = frac(_265.x);
    _681 = (-_533.x) + _244.w;
    _200.x = (_200.x * _681) + _533.x;
    _244.x = (-_200.x) + _244.x;
    _200.x = (_200.y * _244.x) + _200.x;
    _200.x *= 0.25f;
    _446 = (_446 * 0.5f) + _200.x;
    _672 = _33 + 45.31999969482421875f.xxxx;
    _200.x = dot(_33.zw, _672.zw);
    _200.y = dot(_33.xy, _672.xy);
    _33 += _200.yyxx;
    float2 _850 = _33.yw * _33.xz;
    _33 = float4(_850.x, _33.y, _850.y, _33.w);
    float2 _855 = frac(_33.xz);
    _33 = float4(_855.x, _33.y, _855.y, _33.w);
    _189.x = (-_33.x) + _33.z;
    _33.x = (_200.z * _189.x) + _33.x;
    _189.x = _244.y + (-_265.x);
    _189.x = (_200.z * _189.x) + _265.x;
    _33.x = (-_189.x) + _33.x;
    _33.x = (_200.w * _33.x) + _189.x;
    _446 = (_33.x * 0.125f) + _446;
    float3 _918 = _15.zzz * float3(1.5f, 2.22222232818603515625f, 2.5f);
    _33 = float4(_918.x, _918.y, _918.z, _33.w);
    _921.x = ((-_15.w) * _22_m18) + _33.z;
    _33 = float4(_33.xy.x, _33.xy.y, _33.z, _33.w);
    float2 _941 = clamp(_33.xy, 0.0f.xx, 1.0f.xx);
    _33 = float4(_941.x, _941.y, _33.z, _33.w);
    _379 = frac(_921.x);
    _200.x = floor(_921.x);
    _921.x = _379 * _379;
    _379 = ((-_379) * 2.0f) + 3.0f;
    _921.x = _379 * _921.x;
    _200.y = 3.0f;
    _220.y = 0.0f;
    float2 _968 = _200.xy + 1.0f.xx;
    _244 = float4(_968.x, _968.y, _244.z, _244.w);
    float2 _973 = _244.xy * float2(123.339996337890625f, 456.209991455078125f);
    _244 = float4(_973.x, _973.y, _244.z, _244.w);
    float2 _978 = frac(_244.xy);
    _244 = float4(_978.x, _978.y, _244.z, _244.w);
    _533 = _244.xy + 45.31999969482421875f.xx;
    _379 = dot(_244.xy, _533);
    float2 _992 = _379.xx + _244.xy;
    _244 = float4(_992.x, _992.y, _244.z, _244.w);
    _379 = _244.y * _244.x;
    _379 = frac(_379);
    _244 = _200.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _1007 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_1007.x, _1007.y, _200.z, _200.w);
    float2 _1012 = frac(_200.xy);
    _200 = float4(_1012.x, _1012.y, _200.z, _200.w);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _265.z = dot(_244.zw, _265.zw);
    _265.x = dot(_244.xy, _265.xy);
    _244 += _265.xxzz;
    float2 _1041 = _244.yw * _244.xz;
    _244 = float4(_1041.x, _244.y, _1041.y, _244.w);
    float2 _1046 = frac(_244.xz);
    _244 = float4(_1046.x, _244.y, _1046.y, _244.w);
    _379 += (-_244.z);
    _379 = (_921.x * _379) + _244.z;
    _1061 = _200.xy + 45.31999969482421875f.xx;
    _1061.x = dot(_200.xy, _1061);
    float2 _1074 = _200.xy + _1061.xx;
    _200 = float4(_1074.x, _1074.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _200.x = frac(_200.x);
    _269.x = (-_200.x) + _244.x;
    _921.x = (_921.x * _269.x) + _200.x;
    _379 = (-_921.x) + _379;
    _921.x = (_379 * 0.78400003910064697265625f) + _921.x;
    _921.x = (_921.x * 2.0f) + (-1.0f);
    _921.x *= _22_m17;
    _33.x = ((-_921.x) * _33.x) + _15.x;
    _9.x = (_9.x * _15.z) + _33.x;
    _33.x = (_15.y * _22_m29) + (-_22_m12);
    float3 _1167 = (_15.yyy * _22_m29.xxx) + float3(0.0199999995529651641845703125f, -0.20000000298023223876953125f, -0.85000002384185791015625f);
    _244 = float4(_1167.x, _1167.y, _1167.z, _244.w);
    float3 _1176 = _244.xyz * float3(12.5f, 1.4285714626312255859375f, 5.0000019073486328125f);
    _244 = float4(_1176.x, _1176.y, _1176.z, _244.w);
    float3 _1183 = clamp(_244.xyz, 0.0f.xxx, 1.0f.xxx);
    _244 = float4(_1183.x, _1183.y, _1183.z, _244.w);
    _921 = (-float2(float2(_22_m12, _22_m12))) + float2(1.0f, 1.0499999523162841796875f);
    _921 = 1.0f.xx / _921;
    float2 _1203 = _921 * _33.xx;
    _33 = float4(_1203.x, _33.y, _1203.y, _33.w);
    float2 _1210 = clamp(_33.xz, 0.0f.xx, 1.0f.xx);
    _33 = float4(_1210.x, _33.y, _1210.y, _33.w);
    float2 _1218 = (_33.xz * (-2.0f).xx) + 3.0f.xx;
    _200 = float4(_1218.x, _1218.y, _200.z, _200.w);
    float2 _1225 = _33.xz * _33.xz;
    _33 = float4(_1225.x, _33.y, _1225.y, _33.w);
    _65 = _33.x * _200.x;
    _33.x = ((-_200.y) * _33.z) + 1.0f;
    _65 = ((-_65) * 0.60000002384185791015625f) + 1.0f;
    _921.x = (_33.y * (-2.0f)) + 3.0f;
    _189.x = _33.y * _33.y;
    _189.x *= _921.x;
    _921.x = (-_22_m10) + _22_m11;
    _189.x = (_189.x * _921.x) + _22_m10;
    _921.x = _65 * _189.x;
    _379 = (-_22_m13) + 1.0f;
    _200.x = ((-_921.x) * _379) + abs(_9.x);
    _379 *= _921.x;
    _379 = (_189.x * _65) + (-_379);
    _65 = ((-_189.x) * _65) + abs(_9.x);
    _9.x = abs(_9.x) * (-3.0f);
    _189.x = 1.0f / _379;
    _189.x *= _200.x;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _379 = (_189.x * (-2.0f)) + 3.0f;
    _189.x *= _189.x;
    _189.x = ((-_379) * _189.x) + 1.0f;
    _379 = _446 * _189.x;
    float2 _1369 = (_446.xx * float2(0.628571450710296630859375f, 0.457142889499664306640625f)) + float2(0.449999988079071044921875f, 0.60000002384185791015625f);
    _1361 = float3(_1369.x, _1369.y, _1361.z);
    _446 = (_189.x * 0.5f) + 0.5f;
    float3 _1381 = (_244.xyz * (-2.0f).xxx) + 3.0f.xxx;
    _265 = float4(_1381.x, _1381.y, _1381.z, _265.w);
    float3 _1388 = _244.xyz * _244.xyz;
    _244 = float4(_1388.x, _1388.y, _1388.z, _244.w);
    _189.x = _244.x * _265.x;
    float2 _1403 = ((-_265.yz) * _244.yz) + 1.0f.xx;
    _200 = float4(_1403.x, _1403.y, _200.z, _200.w);
    _33.x *= _189.x;
    _189.x = _33.x * _379;
    _379 = (_15.z * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _379 *= _22_m16;
    _189.x = (_189.x * 1.8285715579986572265625f) + (-_379);
    _189.x *= 2.857142925262451171875f;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _379 = (_189.x * (-2.0f)) + 3.0f;
    _189.x *= _189.x;
    _189.x *= _379;
    _1459 = log2(_189.x);
    _1459 *= _22_m6;
    _1459 = exp2(_1459);
    _189.x = _15.z;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _189.x = (_189.x * (-0.550000011920928955078125f)) + 1.0f;
    _189.x *= _1459;
    _189.x = _1361.x * _189.x;
    _446 *= _189.x;
    _1361.x = (_22_m4 * 2.0f) + 1.0f;
    _1361.x = _446 * _1361.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1459 = _446 * 4.0f;
    _1459 = clamp(_1459, 0.0f, 1.0f);
    _1361.x = (_1361.x * _22_m31) + 0.5f;
    _1361.x = floor(_1361.x);
    _1361.x /= _22_m31;
    _1536 = (_1361.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _1543.z = _1536 * _22_m5;
    _446 = _15.w * _22_m27;
    _125 = _15.w * _22_m23;
    _220.x = floor(_446);
    _446 = frac(_446);
    float2 _1569 = _220 + float2(1.0f, 0.0f);
    _189 = float3(_1569.x, _189.y, _1569.y);
    _220 *= float2(123.339996337890625f, 456.209991455078125f);
    _220 = frac(_220);
    float2 _1578 = _189.xz * float2(123.339996337890625f, 456.209991455078125f);
    _189 = float3(_1578.x, _189.y, _1578.y);
    float2 _1583 = frac(_189.xz);
    _189 = float3(_1583.x, _189.y, _1583.y);
    _244.x = _189.x + 45.31999969482421875f;
    float2 _1597 = (_189.xx * _244.xx) + _189.xz;
    _189 = float3(_1597.x, _189.y, _1597.y);
    _189.x = _189.z * _189.x;
    _379 = _220.x + 45.31999969482421875f;
    _220 = (_220.xx * _379.xx) + _220;
    _189.z = _220.y * _220.x;
    float2 _1624 = frac(_189.xz);
    _189 = float3(_1624.x, _189.y, _1624.y);
    _189.x = (-_189.z) + _189.x;
    _220.x = _446 * _446;
    _446 = ((-_446) * 2.0f) + 3.0f;
    _446 *= _220.x;
    _446 = (_446 * _189.x) + _189.z;
    _1653.x = (-_22_m28) + 1.0f;
    _446 = (_22_m28 * _446) + _1653.x;
    _1653.x = _1361.x + (-0.3499999940395355224609375f);
    _1361.x *= 2.857142925262451171875f;
    _1361.x = _1361.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1653.x *= 2.2222220897674560546875f;
    _1653.x = clamp(_1653.x, 0.0f, 1.0f);
    _1692.x = (_1653.x * (-2.0f)) + 3.0f;
    _1653.x *= _1653.x;
    _1653.x *= _1692.x;
    _1692.x = (_1361.x * (-2.0f)) + 3.0f;
    _1361.x *= _1361.x;
    _1361.x *= _1692.x;
    _1692 = (-_22_m1.xyz) + _22_m2.xyz;
    _1692 = (_1361.xxx * _1692) + _22_m1.xyz;
    _1745 = (-_1692) + _22_m3.xyz;
    _1653 = (_1653.xxx * _1745) + _1692;
    _189.x = _921.x * _22_m20;
    _921.x = 1.0f / _921.x;
    _65 *= _921.x;
    _65 = clamp(_65, 0.0f, 1.0f);
    _189.x = max(_189.x, 9.9999997473787516355514526367188e-05f);
    _9.x /= _189.x;
    _9.x = exp2(_9.x);
    _9.x = _33.x * _9.x;
    _9.x = _200.x * _9.x;
    _1361.x = _1361.y * _9.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1361.x = (_1361.x * _22_m31) + 0.5f;
    _1361.x = floor(_1361.x);
    _1361.x /= _22_m31;
    _1543.x = _1361.x * _22_m21;
    _1361.x = max(_1361.x, _1459);
    _1361.x = min(_1361.x, 1.0f);
    float2 _1850 = _446.xx * _1543.xz;
    _1543 = float3(_1850.x, _1543.y, _1850.y);
    _1745 = _1543.xxx * _22_m3.xyz;
    _1543 = (_1653 * _1543.zzz) + _1745;
    float2 _1871 = _15.xz * _22_m22.xx;
    _9 = float4(_1871.x, _9.y, _9.z, _1871.y);
    _15.x = _15.z * 4.0f;
    _15.x = clamp(_15.x, 0.0f, 1.0f);
    _9.w = ((-_125) * _22_m22) + _9.w;
    float2 _1893 = frac(_9.xw);
    _33 = float4(_1893.x, _1893.y, _33.z, _33.w);
    _244 = floor(_9.xwxw);
    float2 _1903 = _33.xy + (-0.5f).xx;
    _9 = float4(_1903.x, _9.y, _9.z, _1903.y);
    _33 = _244 + float4(7.099999904632568359375f, 7.099999904632568359375f, 3.2999999523162841796875f, 3.2999999523162841796875f);
    _52 = _244.zw * float2(123.339996337890625f, 456.209991455078125f);
    _52 = frac(_52);
    _33 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = frac(_33);
    _244 = _33 + 45.31999969482421875f.xxxx;
    _200.x = dot(_33.xy, _244.xy);
    _200.z = dot(_33.zw, _244.zw);
    _33 += _200.xxzz;
    _33.x = _33.y * _33.x;
    _1061.x = frac(_33.x);
    _33.x = _33.w * _33.z;
    _1061.y = frac(_33.x);
    float2 _1959 = _1061 + (-0.5f).xx;
    _33 = float4(_1959.x, _1959.y, _33.z, _33.w);
    _921 = _52 + 45.31999969482421875f.xx;
    _921.x = dot(_52, _921);
    _52 += _921.xx;
    _52.x = _52.y * _52.x;
    _52.x = frac(_52.x);
    _1982 = (_52.xx * float2(6.283199787139892578125f, 40.0f)) + _9.yz;
    _1982 = sin(_1982);
    _1982.x *= 0.1500000059604644775390625f;
    _1999 = (_1982.y * 0.5f) + 0.5f;
    _33.x = (_33.x * 0.60000002384185791015625f) + _1982.x;
    _33.z = _33.y * 0.60000002384185791015625f;
    float2 _2020 = _9.xw + (-_33.xz);
    _9 = float4(_2020.x, _2020.y, _9.z, _9.w);
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x += (-_22_m24);
    _1982.x = 1.0f / (-_22_m24);
    _9.x = _1982.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1982.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _1982.x;
    _9.x = _1999 * _9.x;
    _1982.x = (-_22_m25) + 1.0f;
    _2086 = _52.x >= _1982.x;
    _1982.x = float(_2086);
    _9.x = _1982.x * _9.x;
    _1982.x = (_65 * (-2.0f)) + 3.0f;
    _1999 = _65 * _65;
    _1982.x = ((-_1982.x) * _1999) + 1.0f;
    _1982.x = _15.x * _1982.x;
    _1982.x = _200.y * _1982.x;
    _9.x = _1982.x * _9.x;
    _2133 = _9.x >= 0.5f;
    _9.x = float(_2133);
    _1653.x = _9.x * _22_m26;
    _2148.w = max(_9.x, _1361.x);
    _1692 = (-_22_m2.xyz) + _22_m3.xyz;
    _1692 = (_1692 * 0.60000002384185791015625f.xxx) + _22_m2.xyz;
    _1361 = (_1692 * _1653.xxx) + _1543;
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _2187 = _1361 * _9.xxx;
    _9 = float4(_2187.x, _2187.y, _2187.z, _9.w);
    _2148 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _2148.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2148 = _2148;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
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
float4 _EdgeColor;
float4 _MidColor;
float4 _CoreColor;
float _WhiteBias;
float _Intensity;
float _Contrast;
float4 _RootUV;
float4 _TipUV;
float _AcrossScale;
float _RootWidth;
float _MaxWidth;
float _TipStart;
float _EdgeSoftness;
float _FlameScale;
float _FlameSpeed;
float _Erosion;
float _Wiggle;
float _WiggleSpeed;
float _WarpStrength;
float _CoreWidth;
float _CoreIntensity;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _16_m0 _Time
#define _16_m1 _EdgeColor
#define _16_m2 _MidColor
#define _16_m3 _CoreColor
#define _16_m4 _WhiteBias
#define _16_m5 _Intensity
#define _16_m6 _Contrast
#define _16_m7 _RootUV
#define _16_m8 _TipUV
#define _16_m9 _AcrossScale
#define _16_m10 _RootWidth
#define _16_m11 _MaxWidth
#define _16_m12 _TipStart
#define _16_m13 _EdgeSoftness
#define _16_m14 _FlameScale
#define _16_m15 _FlameSpeed
#define _16_m16 _Erosion
#define _16_m17 _Wiggle
#define _16_m18 _WiggleSpeed
#define _16_m19 _WarpStrength
#define _16_m20 _CoreWidth
#define _16_m21 _CoreIntensity
#define _16_m22 _PulseSpeed
#define _16_m23 _PulseAmount
#define _16_m24 _PixelSize
#define _16_m25 _FrameRate
#define _16_m26 _Steps



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _1533;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _1533 : SV_Target0;
};

static float4 _9;
static float4 _27;
static float _47;
static float _59;
static float _118;
static float2 _164;
static float4 _170;
static float3 _176;
static float4 _194;
static float2 _213;
static float4 _237;
static float4 _252;
static float3 _256;
static float _361;
static float _428;
static float2 _516;
static float2 _567;
static float4 _622;
static float2 _748;
static float _1091;
static float3 _1340;
static float3 _1399;
static float _1473;
static float _1564;
static float3 _1594;
static float3 _1624;

void frag_inner()
{
    float2 _24 = vs_TEXCOORD0 + (-_16_m7.xy);
    _9 = float4(_24.x, _24.y, _9.z, _9.w);
    float2 _36 = (-_16_m7.xy) + _16_m8.xy;
    _27 = float4(_36.x, _36.y, _27.z, _27.w);
    _27.z = -_27.x;
    _47 = dot(_9.xy, _27.yz);
    _9.x = dot(_9.xy, _27.xy);
    _59 = dot(_27.xy, _27.xy);
    _59 = max(_59, 9.9999997473787516355514526367188e-06f);
    _59 = 1.0f / _59;
    _27.y = _59 * _9.x;
    _9.x = _59 * _47;
    _27.x = _9.x * _16_m9;
    float2 _95 = _27.xy / _16_m24.xx;
    _9 = float4(_95.x, _95.y, _9.z, _9.w);
    float2 _100 = floor(_9.xy);
    _9 = float4(_100.x, _100.y, _9.z, _9.w);
    float2 _107 = _9.xy + 0.5f.xx;
    _9 = float4(_107.x, _107.y, _9.z, _9.w);
    float2 _115 = _9.yx * _16_m24.xx;
    _9 = float4(_115.x, _9.y, _115.y, _9.w);
    _118 = vs_TEXCOORD1 + _16_m0.y;
    _118 *= _16_m25;
    _118 = floor(_118);
    _9.w = _118 / _16_m25;
    float3 _151 = _9.zxw * float3(_16_m14, _16_m14, _16_m15);
    _27 = float4(_151.x, _151.y, _27.z, _151.z);
    _27.z = (_27.y * 0.449999988079071044921875f) + (-_27.w);
    _164.y = _9.w * 0.699999988079071044921875f;
    _170.y = 3.0f;
    _164.x = 1.2999999523162841796875f;
    float2 _183 = (_27.xz * 0.800000011920928955078125f.xx) + _164;
    _176 = float3(_183.x, _176.y, _183.y);
    _164 = floor(_176.xz);
    float2 _191 = frac(_176.xz);
    _176 = float3(_191.x, _176.y, _191.y);
    float2 _197 = _164 + 1.0f.xx;
    _194 = float4(_197.x, _197.y, _194.z, _194.w);
    float2 _205 = _194.xy * float2(123.339996337890625f, 456.209991455078125f);
    _194 = float4(_205.x, _205.y, _194.z, _194.w);
    float2 _210 = frac(_194.xy);
    _194 = float4(_210.x, _210.y, _194.z, _194.w);
    _213 = _194.xy + 45.31999969482421875f.xx;
    _213.x = dot(_194.xy, _213);
    float2 _228 = _213.xx + _194.xy;
    _194 = float4(_228.x, _228.y, _194.z, _194.w);
    _194.x = _194.y * _194.x;
    _237 = _164.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _256.x = dot(_237.zw, _252.zw);
    _213.x = dot(_237.xy, _252.xy);
    _213 = _213.xx + _237.xy;
    float2 _278 = _256.xx + _237.zw;
    _237 = float4(_278.x, _278.y, _237.z, _237.w);
    _194.y = _237.y * _237.x;
    _194.z = _213.y * _213.x;
    float3 _295 = frac(_194.xyz);
    _194 = float4(_295.x, _295.y, _295.z, _194.w);
    _194.x = (-_194.y) + _194.x;
    float2 _309 = _176.xz * _176.xz;
    _237 = float4(_309.x, _309.y, _237.z, _237.w);
    float2 _319 = ((-_176.xz) * 2.0f.xx) + 3.0f.xx;
    _176 = float3(_319.x, _176.y, _319.y);
    float2 _326 = _176.xz * _237.xy;
    _176 = float3(_326.x, _176.y, _326.y);
    _194.x = (_176.x * _194.x) + _194.y;
    float2 _339 = _164 + 45.31999969482421875f.xx;
    _256 = float3(_339.x, _256.y, _339.y);
    _256.x = dot(_164, _256.xz);
    _164 += _256.xx;
    _164.x = _164.y * _164.x;
    _164.x = frac(_164.x);
    _361 = (-_164.x) + _194.z;
    _176.x = (_176.x * _361) + _164.x;
    _164.x = (-_176.x) + _194.x;
    _176.x = (_176.z * _164.x) + _176.x;
    _176.x = (_176.x * 2.0f) + (-1.0f);
    _194 = (_176.xxxx * 0.5f.xxxx) + _27.xzxz;
    _27.x = _176.x * _16_m19;
    float2 _414 = floor(_194.zw);
    _176 = float3(_414.x, _414.y, _176.z);
    _164 = _176.xy + 1.0f.xx;
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    float2 _425 = _164 + 45.31999969482421875f.xx;
    _237 = float4(_425.x, _425.y, _237.z, _237.w);
    _428 = dot(_164, _237.xy);
    _164 = _428.xx + _164;
    _176.z = _164.y * _164.x;
    _237 = _176.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _448 = _176.xy * float2(123.339996337890625f, 456.209991455078125f);
    _176 = float3(_448.x, _448.y, _176.z);
    _176 = frac(_176);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _164.x = dot(_237.zw, _252.zw);
    _361 = dot(_237.xy, _252.xy);
    float2 _474 = _361.xx + _237.xy;
    _237 = float4(_474.x, _474.y, _237.z, _237.w);
    _164 = _164.xx + _237.zw;
    _164.x = _164.y * _164.x;
    _164.y = _237.y * _237.x;
    _164 = frac(_164);
    _428 = _176.z + (-_164.x);
    float2 _504 = frac(_194.zw);
    _237 = float4(_504.x, _504.y, _237.z, _237.w);
    _194 = (_194 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _516 = _237.xy * _237.xy;
    float2 _526 = ((-_237.xy) * 2.0f.xx) + 3.0f.xx;
    _237 = float4(_526.x, _526.y, _237.z, _237.w);
    float2 _532 = _237.xy * _516;
    _237 = float4(_532.x, _532.y, _237.z, _237.w);
    _428 = (_237.x * _428) + _164.x;
    _516 = _176.xy + 45.31999969482421875f.xx;
    _164.x = dot(_176.xy, _516);
    float2 _554 = _176.xy + _164.xx;
    _176 = float3(_554.x, _554.y, _176.z);
    _176.x = _176.y * _176.x;
    _176.x = frac(_176.x);
    _567.x = (-_176.x) + _164.y;
    _176.x = (_237.x * _567.x) + _176.x;
    _567.x = (-_176.x) + _428;
    _176.x = (_237.y * _567.x) + _176.x;
    _237 = frac(_194);
    _194 = floor(_194);
    _252 = _237 * _237;
    _237 = ((-_237) * 2.0f.xxxx) + 3.0f.xxxx;
    _237 *= _252;
    _252 = _194 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _252 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _567.x = dot(_252.xy, _622.xy);
    _428 = dot(_252.zw, _622.zw);
    _164 = _428.xx + _252.zw;
    _567 = _567.xx + _252.xy;
    _567.x = _567.y * _567.x;
    _567.y = _164.y * _164.x;
    _567 = frac(_567);
    _252 = _194.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _252 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _164.x = dot(_252.zw, _622.zw);
    _361 = dot(_252.xy, _622.xy);
    float2 _684 = _361.xx + _252.xy;
    _252 = float4(_684.x, _684.y, _252.z, _252.w);
    _164 = _164.xx + _252.zw;
    _164.x = _164.y * _164.x;
    _164.y = _252.y * _252.x;
    _164 = frac(_164);
    _567.x += (-_164.x);
    _567.x = (_237.x * _567.x) + _164.x;
    _252 = _194 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _194 = _194.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _194 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _194 = frac(_194);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _164.x = dot(_252.xy, _622.xy);
    _622.x = dot(_252.zw, _622.zw);
    _748 = _252.zw + _622.xx;
    float2 _758 = _164.xx + _252.xy;
    _252 = float4(_758.x, _758.y, _252.z, _252.w);
    _164.x = _252.y * _252.x;
    _164.x = frac(_164.x);
    _252.x = _748.y * _748.x;
    _252.x = frac(_252.x);
    _361 = (-_164.x) + _164.y;
    _164.x = (_237.x * _361) + _164.x;
    _567.x += (-_164.x);
    _567.x = (_237.y * _567.x) + _164.x;
    _567.x *= 0.25f;
    _176.x = (_176.x * 0.5f) + _567.x;
    _622 = _194 + 45.31999969482421875f.xxxx;
    _567.x = dot(_194.zw, _622.zw);
    _164.x = dot(_194.xy, _622.xy);
    _164 = _164.xx + _194.xy;
    float2 _846 = _567.xx + _194.zw;
    _194 = float4(_846.x, _846.y, _194.z, _194.w);
    _567.x = _194.y * _194.x;
    _567.x = frac(_567.x);
    _164.x = _164.y * _164.x;
    _164.x = frac(_164.x);
    _567.x += (-_164.x);
    _567.x = (_237.z * _567.x) + _164.x;
    _428 = _567.y + (-_252.x);
    _428 = (_237.z * _428) + _252.x;
    _567.x = (-_428) + _567.x;
    _567.x = (_237.w * _567.x) + _428;
    _176.x = (_567.x * 0.125f) + _176.x;
    float3 _926 = _9.xxx * float3(1.5f, 2.22222232818603515625f, 2.5f);
    _194 = float4(_926.x, _926.y, _926.z, _194.w);
    _567.x = ((-_9.w) * _16_m18) + _194.z;
    _9.w *= _16_m22;
    _194 = float4(_194.xy.x, _194.xy.y, _194.z, _194.w);
    float2 _955 = clamp(_194.xy, 0.0f.xx, 1.0f.xx);
    _194 = float4(_955.x, _955.y, _194.z, _194.w);
    _170.x = floor(_567.x);
    _164 = _170.xy + 1.0f.xx;
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    _213 = _164 + 45.31999969482421875f.xx;
    _428 = dot(_164, _213);
    _164 = _428.xx + _164;
    _567.y = _164.y * _164.x;
    _567 = frac(_567);
    _237 = _170.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _991 = _170.xy * float2(123.339996337890625f, 456.209991455078125f);
    _170 = float4(_991.x, _991.y, _170.z, _170.w);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _164.x = dot(_237.zw, _252.zw);
    _361 = dot(_237.xy, _252.xy);
    _213 = _361.xx + _237.xy;
    _164 = _164.xx + _237.zw;
    _170.z = _164.y * _164.x;
    _170.w = _213.y * _213.x;
    _170 = frac(_170);
    _428 = _567.y + (-_170.z);
    _213.x = _567.x * _567.x;
    _567.x = ((-_567.x) * 2.0f) + 3.0f;
    _567.x *= _213.x;
    _428 = (_567.x * _428) + _170.z;
    _213 = _170.xy + 45.31999969482421875f.xx;
    _164.x = dot(_170.xy, _213);
    float2 _1078 = _164.xx + _170.xy;
    _170 = float4(_1078.x, _1078.y, _170.z, _170.w);
    _170.x = _170.y * _170.x;
    _170.x = frac(_170.x);
    _1091 = (-_170.x) + _170.w;
    _567.x = (_567.x * _1091) + _170.x;
    _428 = (-_567.x) + _428;
    _567.x = (_428 * 0.78400003910064697265625f) + _567.x;
    _567.x = (_567.x * 2.0f) + (-1.0f);
    _567.x *= _16_m17;
    _47 = ((-_567.x) * _194.x) + _9.z;
    _47 = (_27.x * _9.x) + _47;
    _27.x = (_194.y * (-2.0f)) + 3.0f;
    _567.x = _194.y * _194.y;
    _27.x = _567.x * _27.x;
    _567.x = (-_16_m10) + _16_m11;
    _27.x = (_27.x * _567.x) + _16_m10;
    _567.x = (_9.y * _16_m24) + (-_16_m12);
    float2 _1202 = (_9.yy * _16_m24.xx) + float2(0.0199999995529651641845703125f, -0.20000000298023223876953125f);
    _170 = float4(_1202.x, _1202.y, _170.z, _170.w);
    float2 _1210 = _170.xy * float2(12.5f, 1.4285714626312255859375f);
    _170 = float4(_1210.x, _1210.y, _170.z, _170.w);
    float2 _1217 = clamp(_170.xy, 0.0f.xx, 1.0f.xx);
    _170 = float4(_1217.x, _1217.y, _170.z, _170.w);
    _164 = (-float2(float2(_16_m12, _16_m12))) + float2(1.0f, 1.0499999523162841796875f);
    _164 = 1.0f.xx / _164;
    _567 = _567.xx * _164;
    _567 = clamp(_567, 0.0f.xx, 1.0f.xx);
    _164 = (_567 * (-2.0f).xx) + 3.0f.xx;
    _567 *= _567;
    _59 = _567.x * _164.x;
    _567.x = ((-_164.y) * _567.y) + 1.0f;
    _59 = ((-_59) * 0.60000002384185791015625f) + 1.0f;
    _428 = _59 * _27.x;
    _164.x = (-_16_m13) + 1.0f;
    _361 = ((-_428) * _164.x) + abs(_47);
    _47 = abs(_47) * (-3.0f);
    _164.x = _428 * _164.x;
    _428 *= _16_m20;
    _428 = max(_428, 9.9999997473787516355514526367188e-05f);
    _47 /= _428;
    _47 = exp2(_47);
    _59 = (_27.x * _59) + (-_164.x);
    _59 = 1.0f / _59;
    _59 *= _361;
    _59 = clamp(_59, 0.0f, 1.0f);
    _27.x = (_59 * (-2.0f)) + 3.0f;
    _59 *= _59;
    _59 = ((-_27.x) * _59) + 1.0f;
    _27.x = _59 * _176.x;
    float2 _1348 = (_176.xx * float2(0.628571450710296630859375f, 0.457142889499664306640625f)) + float2(0.449999988079071044921875f, 0.60000002384185791015625f);
    _1340 = float3(_1348.x, _1348.y, _1340.z);
    _59 = (_59 * 0.5f) + 0.5f;
    float2 _1357 = (_170.xy * (-2.0f).xx) + 3.0f.xx;
    _176 = float3(_1357.x, _176.y, _1357.y);
    float2 _1364 = _170.xy * _170.xy;
    _170 = float4(_1364.x, _1364.y, _170.z, _170.w);
    _176.x *= _170.x;
    _428 = ((-_176.z) * _170.y) + 1.0f;
    _176.x = _567.x * _176.x;
    _27.x = _176.x * _27.x;
    _47 *= _176.x;
    _47 = _428 * _47;
    _1399.x = _1340.y * _47;
    _1399.x = clamp(_1399.x, 0.0f, 1.0f);
    _1399.x = (_1399.x * _16_m26) + 0.5f;
    _1399.x = floor(_1399.x);
    _1399.x /= _16_m26;
    _47 = (_9.x * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _9.x = _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * (-0.550000011920928955078125f)) + 1.0f;
    _47 *= _16_m16;
    _47 = (_27.x * 1.8285715579986572265625f) + (-_47);
    _47 *= 2.857142925262451171875f;
    _47 = clamp(_47, 0.0f, 1.0f);
    _27.x = (_47 * (-2.0f)) + 3.0f;
    _47 *= _47;
    _47 *= _27.x;
    _1473 = log2(_47);
    _1473 *= _16_m6;
    _1473 = exp2(_1473);
    _9.x *= _1473;
    _9.x = _1340.x * _9.x;
    _9.x = _59 * _9.x;
    _1340.x = (_16_m4 * 2.0f) + 1.0f;
    _1340.x = _9.x * _1340.x;
    _1340.x = clamp(_1340.x, 0.0f, 1.0f);
    _1473 = _9.x * 4.0f;
    _1473 = clamp(_1473, 0.0f, 1.0f);
    _1473 = max(_1399.x, _1473);
    _1340.y = _1399.x * _16_m21;
    _1533.w = min(_1473, 1.0f);
    _1340.x = (_1340.x * _16_m26) + 0.5f;
    _1340.x = floor(_1340.x);
    _1340.x /= _16_m26;
    _1473 = _1340.x + (-0.3499999940395355224609375f);
    _1473 *= 2.2222220897674560546875f;
    _1473 = clamp(_1473, 0.0f, 1.0f);
    _1564 = (_1473 * (-2.0f)) + 3.0f;
    _1473 *= _1473;
    _1473 *= _1564;
    _1564 = _1340.x * 2.857142925262451171875f;
    _1340.x = (_1340.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _1340.x *= _16_m5;
    _1564 = _1564;
    _1564 = clamp(_1564, 0.0f, 1.0f);
    _1594.x = (_1564 * (-2.0f)) + 3.0f;
    _1564 *= _1564;
    _1564 *= _1594.x;
    _1594 = (-_16_m1.xyz) + _16_m2.xyz;
    _1594 = (_1564.xxx * _1594) + _16_m1.xyz;
    _1624 = (-_1594) + _16_m3.xyz;
    _1594 = (_1473.xxx * _1624) + _1594;
    _9.x = floor(_9.w);
    _9.y = 0.0f;
    float2 _1646 = _9.xy + float2(1.0f, 0.0f);
    _27 = float4(_1646.x, _1646.y, _27.z, _27.w);
    float2 _1651 = _9.xy * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_1651.x, _1651.y, _9.z, _9.w);
    float3 _1656 = frac(_9.xyw);
    _9 = float4(_1656.x, _1656.y, _1656.z, _9.w);
    float2 _1661 = _27.xy * float2(123.339996337890625f, 456.209991455078125f);
    _27 = float4(_1661.x, _1661.y, _27.z, _27.w);
    float2 _1666 = frac(_27.xy);
    _27 = float4(_1666.x, _1666.y, _27.z, _27.w);
    _118 = _27.x + 45.31999969482421875f;
    float2 _1679 = (_27.xx * _118.xx) + _27.xy;
    _27 = float4(_1679.x, _1679.y, _27.z, _27.w);
    _9.w = _27.y * _27.x;
    _27.x = _9.x + 45.31999969482421875f;
    float2 _1699 = (_9.xx * _27.xx) + _9.xy;
    _9 = float4(_1699.x, _1699.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    float2 _1710 = frac(_9.xw);
    _9 = float4(_1710.x, _9.y, _9.z, _1710.y);
    _59 = (-_9.x) + _9.w;
    _118 = _9.z * _9.z;
    _47 = ((-_9.z) * 2.0f) + 3.0f;
    _47 *= _118;
    _9.x = (_47 * _59) + _9.x;
    _1473 = (-_16_m23) + 1.0f;
    _9.x = (_16_m23 * _9.x) + _1473;
    float2 _1756 = _9.xx * _1340.xy;
    _1340 = float3(_1756.x, _1756.y, _1340.z);
    _1399 = _1340.yyy * _16_m3.xyz;
    _1340 = (_1594 * _1340.xxx) + _1399;
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _1781 = _1340 * _9.xxx;
    _9 = float4(_1781.x, _1781.y, _1781.z, _9.w);
    _1533 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1533.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1533 = _1533;
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
float4 _EdgeColor;
float4 _MidColor;
float4 _CoreColor;
float _WhiteBias;
float _Intensity;
float _Contrast;
float4 _RootUV;
float4 _TipUV;
float _AcrossScale;
float _RootWidth;
float _MaxWidth;
float _TipStart;
float _EdgeSoftness;
float _FlameScale;
float _FlameSpeed;
float _Erosion;
float _Wiggle;
float _WiggleSpeed;
float _WarpStrength;
float _CoreWidth;
float _CoreIntensity;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _16_m0 _Time
#define _16_m1 _EdgeColor
#define _16_m2 _MidColor
#define _16_m3 _CoreColor
#define _16_m4 _WhiteBias
#define _16_m5 _Intensity
#define _16_m6 _Contrast
#define _16_m7 _RootUV
#define _16_m8 _TipUV
#define _16_m9 _AcrossScale
#define _16_m10 _RootWidth
#define _16_m11 _MaxWidth
#define _16_m12 _TipStart
#define _16_m13 _EdgeSoftness
#define _16_m14 _FlameScale
#define _16_m15 _FlameSpeed
#define _16_m16 _Erosion
#define _16_m17 _Wiggle
#define _16_m18 _WiggleSpeed
#define _16_m19 _WarpStrength
#define _16_m20 _CoreWidth
#define _16_m21 _CoreIntensity
#define _16_m22 _PulseSpeed
#define _16_m23 _PulseAmount
#define _16_m24 _PixelSize
#define _16_m25 _FrameRate
#define _16_m26 _Steps



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _1533;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _1533 : SV_Target0;
};

static float4 _9;
static float4 _27;
static float _47;
static float _59;
static float _118;
static float2 _164;
static float4 _170;
static float3 _176;
static float4 _194;
static float2 _213;
static float4 _237;
static float4 _252;
static float3 _256;
static float _361;
static float _428;
static float2 _516;
static float2 _567;
static float4 _622;
static float2 _748;
static float _1091;
static float3 _1340;
static float3 _1399;
static float _1473;
static float _1564;
static float3 _1594;
static float3 _1624;

void frag_inner()
{
    float2 _24 = vs_TEXCOORD0 + (-_16_m7.xy);
    _9 = float4(_24.x, _24.y, _9.z, _9.w);
    float2 _36 = (-_16_m7.xy) + _16_m8.xy;
    _27 = float4(_36.x, _36.y, _27.z, _27.w);
    _27.z = -_27.x;
    _47 = dot(_9.xy, _27.yz);
    _9.x = dot(_9.xy, _27.xy);
    _59 = dot(_27.xy, _27.xy);
    _59 = max(_59, 9.9999997473787516355514526367188e-06f);
    _59 = 1.0f / _59;
    _27.y = _59 * _9.x;
    _9.x = _59 * _47;
    _27.x = _9.x * _16_m9;
    float2 _95 = _27.xy / _16_m24.xx;
    _9 = float4(_95.x, _95.y, _9.z, _9.w);
    float2 _100 = floor(_9.xy);
    _9 = float4(_100.x, _100.y, _9.z, _9.w);
    float2 _107 = _9.xy + 0.5f.xx;
    _9 = float4(_107.x, _107.y, _9.z, _9.w);
    float2 _115 = _9.yx * _16_m24.xx;
    _9 = float4(_115.x, _9.y, _115.y, _9.w);
    _118 = vs_TEXCOORD1 + _16_m0.y;
    _118 *= _16_m25;
    _118 = floor(_118);
    _9.w = _118 / _16_m25;
    float3 _151 = _9.zxw * float3(_16_m14, _16_m14, _16_m15);
    _27 = float4(_151.x, _151.y, _27.z, _151.z);
    _27.z = (_27.y * 0.449999988079071044921875f) + (-_27.w);
    _164.y = _9.w * 0.699999988079071044921875f;
    _170.y = 3.0f;
    _164.x = 1.2999999523162841796875f;
    float2 _183 = (_27.xz * 0.800000011920928955078125f.xx) + _164;
    _176 = float3(_183.x, _176.y, _183.y);
    _164 = floor(_176.xz);
    float2 _191 = frac(_176.xz);
    _176 = float3(_191.x, _176.y, _191.y);
    float2 _197 = _164 + 1.0f.xx;
    _194 = float4(_197.x, _197.y, _194.z, _194.w);
    float2 _205 = _194.xy * float2(123.339996337890625f, 456.209991455078125f);
    _194 = float4(_205.x, _205.y, _194.z, _194.w);
    float2 _210 = frac(_194.xy);
    _194 = float4(_210.x, _210.y, _194.z, _194.w);
    _213 = _194.xy + 45.31999969482421875f.xx;
    _213.x = dot(_194.xy, _213);
    float2 _228 = _213.xx + _194.xy;
    _194 = float4(_228.x, _228.y, _194.z, _194.w);
    _194.x = _194.y * _194.x;
    _237 = _164.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _256.x = dot(_237.zw, _252.zw);
    _213.x = dot(_237.xy, _252.xy);
    _213 = _213.xx + _237.xy;
    float2 _278 = _256.xx + _237.zw;
    _237 = float4(_278.x, _278.y, _237.z, _237.w);
    _194.y = _237.y * _237.x;
    _194.z = _213.y * _213.x;
    float3 _295 = frac(_194.xyz);
    _194 = float4(_295.x, _295.y, _295.z, _194.w);
    _194.x = (-_194.y) + _194.x;
    float2 _309 = _176.xz * _176.xz;
    _237 = float4(_309.x, _309.y, _237.z, _237.w);
    float2 _319 = ((-_176.xz) * 2.0f.xx) + 3.0f.xx;
    _176 = float3(_319.x, _176.y, _319.y);
    float2 _326 = _176.xz * _237.xy;
    _176 = float3(_326.x, _176.y, _326.y);
    _194.x = (_176.x * _194.x) + _194.y;
    float2 _339 = _164 + 45.31999969482421875f.xx;
    _256 = float3(_339.x, _256.y, _339.y);
    _256.x = dot(_164, _256.xz);
    _164 += _256.xx;
    _164.x = _164.y * _164.x;
    _164.x = frac(_164.x);
    _361 = (-_164.x) + _194.z;
    _176.x = (_176.x * _361) + _164.x;
    _164.x = (-_176.x) + _194.x;
    _176.x = (_176.z * _164.x) + _176.x;
    _176.x = (_176.x * 2.0f) + (-1.0f);
    _194 = (_176.xxxx * 0.5f.xxxx) + _27.xzxz;
    _27.x = _176.x * _16_m19;
    float2 _414 = floor(_194.zw);
    _176 = float3(_414.x, _414.y, _176.z);
    _164 = _176.xy + 1.0f.xx;
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    float2 _425 = _164 + 45.31999969482421875f.xx;
    _237 = float4(_425.x, _425.y, _237.z, _237.w);
    _428 = dot(_164, _237.xy);
    _164 = _428.xx + _164;
    _176.z = _164.y * _164.x;
    _237 = _176.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _448 = _176.xy * float2(123.339996337890625f, 456.209991455078125f);
    _176 = float3(_448.x, _448.y, _176.z);
    _176 = frac(_176);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _164.x = dot(_237.zw, _252.zw);
    _361 = dot(_237.xy, _252.xy);
    float2 _474 = _361.xx + _237.xy;
    _237 = float4(_474.x, _474.y, _237.z, _237.w);
    _164 = _164.xx + _237.zw;
    _164.x = _164.y * _164.x;
    _164.y = _237.y * _237.x;
    _164 = frac(_164);
    _428 = _176.z + (-_164.x);
    float2 _504 = frac(_194.zw);
    _237 = float4(_504.x, _504.y, _237.z, _237.w);
    _194 = (_194 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _516 = _237.xy * _237.xy;
    float2 _526 = ((-_237.xy) * 2.0f.xx) + 3.0f.xx;
    _237 = float4(_526.x, _526.y, _237.z, _237.w);
    float2 _532 = _237.xy * _516;
    _237 = float4(_532.x, _532.y, _237.z, _237.w);
    _428 = (_237.x * _428) + _164.x;
    _516 = _176.xy + 45.31999969482421875f.xx;
    _164.x = dot(_176.xy, _516);
    float2 _554 = _176.xy + _164.xx;
    _176 = float3(_554.x, _554.y, _176.z);
    _176.x = _176.y * _176.x;
    _176.x = frac(_176.x);
    _567.x = (-_176.x) + _164.y;
    _176.x = (_237.x * _567.x) + _176.x;
    _567.x = (-_176.x) + _428;
    _176.x = (_237.y * _567.x) + _176.x;
    _237 = frac(_194);
    _194 = floor(_194);
    _252 = _237 * _237;
    _237 = ((-_237) * 2.0f.xxxx) + 3.0f.xxxx;
    _237 *= _252;
    _252 = _194 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _252 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _567.x = dot(_252.xy, _622.xy);
    _428 = dot(_252.zw, _622.zw);
    _164 = _428.xx + _252.zw;
    _567 = _567.xx + _252.xy;
    _567.x = _567.y * _567.x;
    _567.y = _164.y * _164.x;
    _567 = frac(_567);
    _252 = _194.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _252 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _164.x = dot(_252.zw, _622.zw);
    _361 = dot(_252.xy, _622.xy);
    float2 _684 = _361.xx + _252.xy;
    _252 = float4(_684.x, _684.y, _252.z, _252.w);
    _164 = _164.xx + _252.zw;
    _164.x = _164.y * _164.x;
    _164.y = _252.y * _252.x;
    _164 = frac(_164);
    _567.x += (-_164.x);
    _567.x = (_237.x * _567.x) + _164.x;
    _252 = _194 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _194 = _194.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _194 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _194 = frac(_194);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _164.x = dot(_252.xy, _622.xy);
    _622.x = dot(_252.zw, _622.zw);
    _748 = _252.zw + _622.xx;
    float2 _758 = _164.xx + _252.xy;
    _252 = float4(_758.x, _758.y, _252.z, _252.w);
    _164.x = _252.y * _252.x;
    _164.x = frac(_164.x);
    _252.x = _748.y * _748.x;
    _252.x = frac(_252.x);
    _361 = (-_164.x) + _164.y;
    _164.x = (_237.x * _361) + _164.x;
    _567.x += (-_164.x);
    _567.x = (_237.y * _567.x) + _164.x;
    _567.x *= 0.25f;
    _176.x = (_176.x * 0.5f) + _567.x;
    _622 = _194 + 45.31999969482421875f.xxxx;
    _567.x = dot(_194.zw, _622.zw);
    _164.x = dot(_194.xy, _622.xy);
    _164 = _164.xx + _194.xy;
    float2 _846 = _567.xx + _194.zw;
    _194 = float4(_846.x, _846.y, _194.z, _194.w);
    _567.x = _194.y * _194.x;
    _567.x = frac(_567.x);
    _164.x = _164.y * _164.x;
    _164.x = frac(_164.x);
    _567.x += (-_164.x);
    _567.x = (_237.z * _567.x) + _164.x;
    _428 = _567.y + (-_252.x);
    _428 = (_237.z * _428) + _252.x;
    _567.x = (-_428) + _567.x;
    _567.x = (_237.w * _567.x) + _428;
    _176.x = (_567.x * 0.125f) + _176.x;
    float3 _926 = _9.xxx * float3(1.5f, 2.22222232818603515625f, 2.5f);
    _194 = float4(_926.x, _926.y, _926.z, _194.w);
    _567.x = ((-_9.w) * _16_m18) + _194.z;
    _9.w *= _16_m22;
    _194 = float4(_194.xy.x, _194.xy.y, _194.z, _194.w);
    float2 _955 = clamp(_194.xy, 0.0f.xx, 1.0f.xx);
    _194 = float4(_955.x, _955.y, _194.z, _194.w);
    _170.x = floor(_567.x);
    _164 = _170.xy + 1.0f.xx;
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    _213 = _164 + 45.31999969482421875f.xx;
    _428 = dot(_164, _213);
    _164 = _428.xx + _164;
    _567.y = _164.y * _164.x;
    _567 = frac(_567);
    _237 = _170.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _991 = _170.xy * float2(123.339996337890625f, 456.209991455078125f);
    _170 = float4(_991.x, _991.y, _170.z, _170.w);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _164.x = dot(_237.zw, _252.zw);
    _361 = dot(_237.xy, _252.xy);
    _213 = _361.xx + _237.xy;
    _164 = _164.xx + _237.zw;
    _170.z = _164.y * _164.x;
    _170.w = _213.y * _213.x;
    _170 = frac(_170);
    _428 = _567.y + (-_170.z);
    _213.x = _567.x * _567.x;
    _567.x = ((-_567.x) * 2.0f) + 3.0f;
    _567.x *= _213.x;
    _428 = (_567.x * _428) + _170.z;
    _213 = _170.xy + 45.31999969482421875f.xx;
    _164.x = dot(_170.xy, _213);
    float2 _1078 = _164.xx + _170.xy;
    _170 = float4(_1078.x, _1078.y, _170.z, _170.w);
    _170.x = _170.y * _170.x;
    _170.x = frac(_170.x);
    _1091 = (-_170.x) + _170.w;
    _567.x = (_567.x * _1091) + _170.x;
    _428 = (-_567.x) + _428;
    _567.x = (_428 * 0.78400003910064697265625f) + _567.x;
    _567.x = (_567.x * 2.0f) + (-1.0f);
    _567.x *= _16_m17;
    _47 = ((-_567.x) * _194.x) + _9.z;
    _47 = (_27.x * _9.x) + _47;
    _27.x = (_194.y * (-2.0f)) + 3.0f;
    _567.x = _194.y * _194.y;
    _27.x = _567.x * _27.x;
    _567.x = (-_16_m10) + _16_m11;
    _27.x = (_27.x * _567.x) + _16_m10;
    _567.x = (_9.y * _16_m24) + (-_16_m12);
    float2 _1202 = (_9.yy * _16_m24.xx) + float2(0.0199999995529651641845703125f, -0.20000000298023223876953125f);
    _170 = float4(_1202.x, _1202.y, _170.z, _170.w);
    float2 _1210 = _170.xy * float2(12.5f, 1.4285714626312255859375f);
    _170 = float4(_1210.x, _1210.y, _170.z, _170.w);
    float2 _1217 = clamp(_170.xy, 0.0f.xx, 1.0f.xx);
    _170 = float4(_1217.x, _1217.y, _170.z, _170.w);
    _164 = (-float2(float2(_16_m12, _16_m12))) + float2(1.0f, 1.0499999523162841796875f);
    _164 = 1.0f.xx / _164;
    _567 = _567.xx * _164;
    _567 = clamp(_567, 0.0f.xx, 1.0f.xx);
    _164 = (_567 * (-2.0f).xx) + 3.0f.xx;
    _567 *= _567;
    _59 = _567.x * _164.x;
    _567.x = ((-_164.y) * _567.y) + 1.0f;
    _59 = ((-_59) * 0.60000002384185791015625f) + 1.0f;
    _428 = _59 * _27.x;
    _164.x = (-_16_m13) + 1.0f;
    _361 = ((-_428) * _164.x) + abs(_47);
    _47 = abs(_47) * (-3.0f);
    _164.x = _428 * _164.x;
    _428 *= _16_m20;
    _428 = max(_428, 9.9999997473787516355514526367188e-05f);
    _47 /= _428;
    _47 = exp2(_47);
    _59 = (_27.x * _59) + (-_164.x);
    _59 = 1.0f / _59;
    _59 *= _361;
    _59 = clamp(_59, 0.0f, 1.0f);
    _27.x = (_59 * (-2.0f)) + 3.0f;
    _59 *= _59;
    _59 = ((-_27.x) * _59) + 1.0f;
    _27.x = _59 * _176.x;
    float2 _1348 = (_176.xx * float2(0.628571450710296630859375f, 0.457142889499664306640625f)) + float2(0.449999988079071044921875f, 0.60000002384185791015625f);
    _1340 = float3(_1348.x, _1348.y, _1340.z);
    _59 = (_59 * 0.5f) + 0.5f;
    float2 _1357 = (_170.xy * (-2.0f).xx) + 3.0f.xx;
    _176 = float3(_1357.x, _176.y, _1357.y);
    float2 _1364 = _170.xy * _170.xy;
    _170 = float4(_1364.x, _1364.y, _170.z, _170.w);
    _176.x *= _170.x;
    _428 = ((-_176.z) * _170.y) + 1.0f;
    _176.x = _567.x * _176.x;
    _27.x = _176.x * _27.x;
    _47 *= _176.x;
    _47 = _428 * _47;
    _1399.x = _1340.y * _47;
    _1399.x = clamp(_1399.x, 0.0f, 1.0f);
    _1399.x = (_1399.x * _16_m26) + 0.5f;
    _1399.x = floor(_1399.x);
    _1399.x /= _16_m26;
    _47 = (_9.x * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _9.x = _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * (-0.550000011920928955078125f)) + 1.0f;
    _47 *= _16_m16;
    _47 = (_27.x * 1.8285715579986572265625f) + (-_47);
    _47 *= 2.857142925262451171875f;
    _47 = clamp(_47, 0.0f, 1.0f);
    _27.x = (_47 * (-2.0f)) + 3.0f;
    _47 *= _47;
    _47 *= _27.x;
    _1473 = log2(_47);
    _1473 *= _16_m6;
    _1473 = exp2(_1473);
    _9.x *= _1473;
    _9.x = _1340.x * _9.x;
    _9.x = _59 * _9.x;
    _1340.x = (_16_m4 * 2.0f) + 1.0f;
    _1340.x = _9.x * _1340.x;
    _1340.x = clamp(_1340.x, 0.0f, 1.0f);
    _1473 = _9.x * 4.0f;
    _1473 = clamp(_1473, 0.0f, 1.0f);
    _1473 = max(_1399.x, _1473);
    _1340.y = _1399.x * _16_m21;
    _1533.w = min(_1473, 1.0f);
    _1340.x = (_1340.x * _16_m26) + 0.5f;
    _1340.x = floor(_1340.x);
    _1340.x /= _16_m26;
    _1473 = _1340.x + (-0.3499999940395355224609375f);
    _1473 *= 2.2222220897674560546875f;
    _1473 = clamp(_1473, 0.0f, 1.0f);
    _1564 = (_1473 * (-2.0f)) + 3.0f;
    _1473 *= _1473;
    _1473 *= _1564;
    _1564 = _1340.x * 2.857142925262451171875f;
    _1340.x = (_1340.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _1340.x *= _16_m5;
    _1564 = _1564;
    _1564 = clamp(_1564, 0.0f, 1.0f);
    _1594.x = (_1564 * (-2.0f)) + 3.0f;
    _1564 *= _1564;
    _1564 *= _1594.x;
    _1594 = (-_16_m1.xyz) + _16_m2.xyz;
    _1594 = (_1564.xxx * _1594) + _16_m1.xyz;
    _1624 = (-_1594) + _16_m3.xyz;
    _1594 = (_1473.xxx * _1624) + _1594;
    _9.x = floor(_9.w);
    _9.y = 0.0f;
    float2 _1646 = _9.xy + float2(1.0f, 0.0f);
    _27 = float4(_1646.x, _1646.y, _27.z, _27.w);
    float2 _1651 = _9.xy * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_1651.x, _1651.y, _9.z, _9.w);
    float3 _1656 = frac(_9.xyw);
    _9 = float4(_1656.x, _1656.y, _1656.z, _9.w);
    float2 _1661 = _27.xy * float2(123.339996337890625f, 456.209991455078125f);
    _27 = float4(_1661.x, _1661.y, _27.z, _27.w);
    float2 _1666 = frac(_27.xy);
    _27 = float4(_1666.x, _1666.y, _27.z, _27.w);
    _118 = _27.x + 45.31999969482421875f;
    float2 _1679 = (_27.xx * _118.xx) + _27.xy;
    _27 = float4(_1679.x, _1679.y, _27.z, _27.w);
    _9.w = _27.y * _27.x;
    _27.x = _9.x + 45.31999969482421875f;
    float2 _1699 = (_9.xx * _27.xx) + _9.xy;
    _9 = float4(_1699.x, _1699.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    float2 _1710 = frac(_9.xw);
    _9 = float4(_1710.x, _9.y, _9.z, _1710.y);
    _59 = (-_9.x) + _9.w;
    _118 = _9.z * _9.z;
    _47 = ((-_9.z) * 2.0f) + 3.0f;
    _47 *= _118;
    _9.x = (_47 * _59) + _9.x;
    _1473 = (-_16_m23) + 1.0f;
    _9.x = (_16_m23 * _9.x) + _1473;
    float2 _1756 = _9.xx * _1340.xy;
    _1340 = float3(_1756.x, _1756.y, _1340.z);
    _1399 = _1340.yyy * _16_m3.xyz;
    _1340 = (_1594 * _1340.xxx) + _1399;
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _1781 = _1340 * _9.xxx;
    _9 = float4(_1781.x, _1781.y, _1781.z, _9.w);
    _1533 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1533.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1533 = _1533;
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
float4 _EdgeColor;
float4 _MidColor;
float4 _CoreColor;
float _WhiteBias;
float _Intensity;
float _Contrast;
float4 _RootUV;
float4 _TipUV;
float _AcrossScale;
float _RootWidth;
float _MaxWidth;
float _TipStart;
float _EdgeSoftness;
float _FlameScale;
float _FlameSpeed;
float _Erosion;
float _Wiggle;
float _WiggleSpeed;
float _WarpStrength;
float _CoreWidth;
float _CoreIntensity;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _16_m0 _Time
#define _16_m1 _EdgeColor
#define _16_m2 _MidColor
#define _16_m3 _CoreColor
#define _16_m4 _WhiteBias
#define _16_m5 _Intensity
#define _16_m6 _Contrast
#define _16_m7 _RootUV
#define _16_m8 _TipUV
#define _16_m9 _AcrossScale
#define _16_m10 _RootWidth
#define _16_m11 _MaxWidth
#define _16_m12 _TipStart
#define _16_m13 _EdgeSoftness
#define _16_m14 _FlameScale
#define _16_m15 _FlameSpeed
#define _16_m16 _Erosion
#define _16_m17 _Wiggle
#define _16_m18 _WiggleSpeed
#define _16_m19 _WarpStrength
#define _16_m20 _CoreWidth
#define _16_m21 _CoreIntensity
#define _16_m22 _PulseSpeed
#define _16_m23 _PulseAmount
#define _16_m24 _PixelSize
#define _16_m25 _FrameRate
#define _16_m26 _Steps



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _1533;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _1533 : SV_Target0;
};

static float4 _9;
static float4 _27;
static float _47;
static float _59;
static float _118;
static float2 _164;
static float4 _170;
static float3 _176;
static float4 _194;
static float2 _213;
static float4 _237;
static float4 _252;
static float3 _256;
static float _361;
static float _428;
static float2 _516;
static float2 _567;
static float4 _622;
static float2 _748;
static float _1091;
static float3 _1340;
static float3 _1399;
static float _1473;
static float _1564;
static float3 _1594;
static float3 _1624;

void frag_inner()
{
    float2 _24 = vs_TEXCOORD0 + (-_16_m7.xy);
    _9 = float4(_24.x, _24.y, _9.z, _9.w);
    float2 _36 = (-_16_m7.xy) + _16_m8.xy;
    _27 = float4(_36.x, _36.y, _27.z, _27.w);
    _27.z = -_27.x;
    _47 = dot(_9.xy, _27.yz);
    _9.x = dot(_9.xy, _27.xy);
    _59 = dot(_27.xy, _27.xy);
    _59 = max(_59, 9.9999997473787516355514526367188e-06f);
    _59 = 1.0f / _59;
    _27.y = _59 * _9.x;
    _9.x = _59 * _47;
    _27.x = _9.x * _16_m9;
    float2 _95 = _27.xy / _16_m24.xx;
    _9 = float4(_95.x, _95.y, _9.z, _9.w);
    float2 _100 = floor(_9.xy);
    _9 = float4(_100.x, _100.y, _9.z, _9.w);
    float2 _107 = _9.xy + 0.5f.xx;
    _9 = float4(_107.x, _107.y, _9.z, _9.w);
    float2 _115 = _9.yx * _16_m24.xx;
    _9 = float4(_115.x, _9.y, _115.y, _9.w);
    _118 = vs_TEXCOORD1 + _16_m0.y;
    _118 *= _16_m25;
    _118 = floor(_118);
    _9.w = _118 / _16_m25;
    float3 _151 = _9.zxw * float3(_16_m14, _16_m14, _16_m15);
    _27 = float4(_151.x, _151.y, _27.z, _151.z);
    _27.z = (_27.y * 0.449999988079071044921875f) + (-_27.w);
    _164.y = _9.w * 0.699999988079071044921875f;
    _170.y = 3.0f;
    _164.x = 1.2999999523162841796875f;
    float2 _183 = (_27.xz * 0.800000011920928955078125f.xx) + _164;
    _176 = float3(_183.x, _176.y, _183.y);
    _164 = floor(_176.xz);
    float2 _191 = frac(_176.xz);
    _176 = float3(_191.x, _176.y, _191.y);
    float2 _197 = _164 + 1.0f.xx;
    _194 = float4(_197.x, _197.y, _194.z, _194.w);
    float2 _205 = _194.xy * float2(123.339996337890625f, 456.209991455078125f);
    _194 = float4(_205.x, _205.y, _194.z, _194.w);
    float2 _210 = frac(_194.xy);
    _194 = float4(_210.x, _210.y, _194.z, _194.w);
    _213 = _194.xy + 45.31999969482421875f.xx;
    _213.x = dot(_194.xy, _213);
    float2 _228 = _213.xx + _194.xy;
    _194 = float4(_228.x, _228.y, _194.z, _194.w);
    _194.x = _194.y * _194.x;
    _237 = _164.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _256.x = dot(_237.zw, _252.zw);
    _213.x = dot(_237.xy, _252.xy);
    _213 = _213.xx + _237.xy;
    float2 _278 = _256.xx + _237.zw;
    _237 = float4(_278.x, _278.y, _237.z, _237.w);
    _194.y = _237.y * _237.x;
    _194.z = _213.y * _213.x;
    float3 _295 = frac(_194.xyz);
    _194 = float4(_295.x, _295.y, _295.z, _194.w);
    _194.x = (-_194.y) + _194.x;
    float2 _309 = _176.xz * _176.xz;
    _237 = float4(_309.x, _309.y, _237.z, _237.w);
    float2 _319 = ((-_176.xz) * 2.0f.xx) + 3.0f.xx;
    _176 = float3(_319.x, _176.y, _319.y);
    float2 _326 = _176.xz * _237.xy;
    _176 = float3(_326.x, _176.y, _326.y);
    _194.x = (_176.x * _194.x) + _194.y;
    float2 _339 = _164 + 45.31999969482421875f.xx;
    _256 = float3(_339.x, _256.y, _339.y);
    _256.x = dot(_164, _256.xz);
    _164 += _256.xx;
    _164.x = _164.y * _164.x;
    _164.x = frac(_164.x);
    _361 = (-_164.x) + _194.z;
    _176.x = (_176.x * _361) + _164.x;
    _164.x = (-_176.x) + _194.x;
    _176.x = (_176.z * _164.x) + _176.x;
    _176.x = (_176.x * 2.0f) + (-1.0f);
    _194 = (_176.xxxx * 0.5f.xxxx) + _27.xzxz;
    _27.x = _176.x * _16_m19;
    float2 _414 = floor(_194.zw);
    _176 = float3(_414.x, _414.y, _176.z);
    _164 = _176.xy + 1.0f.xx;
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    float2 _425 = _164 + 45.31999969482421875f.xx;
    _237 = float4(_425.x, _425.y, _237.z, _237.w);
    _428 = dot(_164, _237.xy);
    _164 = _428.xx + _164;
    _176.z = _164.y * _164.x;
    _237 = _176.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _448 = _176.xy * float2(123.339996337890625f, 456.209991455078125f);
    _176 = float3(_448.x, _448.y, _176.z);
    _176 = frac(_176);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _164.x = dot(_237.zw, _252.zw);
    _361 = dot(_237.xy, _252.xy);
    float2 _474 = _361.xx + _237.xy;
    _237 = float4(_474.x, _474.y, _237.z, _237.w);
    _164 = _164.xx + _237.zw;
    _164.x = _164.y * _164.x;
    _164.y = _237.y * _237.x;
    _164 = frac(_164);
    _428 = _176.z + (-_164.x);
    float2 _504 = frac(_194.zw);
    _237 = float4(_504.x, _504.y, _237.z, _237.w);
    _194 = (_194 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _516 = _237.xy * _237.xy;
    float2 _526 = ((-_237.xy) * 2.0f.xx) + 3.0f.xx;
    _237 = float4(_526.x, _526.y, _237.z, _237.w);
    float2 _532 = _237.xy * _516;
    _237 = float4(_532.x, _532.y, _237.z, _237.w);
    _428 = (_237.x * _428) + _164.x;
    _516 = _176.xy + 45.31999969482421875f.xx;
    _164.x = dot(_176.xy, _516);
    float2 _554 = _176.xy + _164.xx;
    _176 = float3(_554.x, _554.y, _176.z);
    _176.x = _176.y * _176.x;
    _176.x = frac(_176.x);
    _567.x = (-_176.x) + _164.y;
    _176.x = (_237.x * _567.x) + _176.x;
    _567.x = (-_176.x) + _428;
    _176.x = (_237.y * _567.x) + _176.x;
    _237 = frac(_194);
    _194 = floor(_194);
    _252 = _237 * _237;
    _237 = ((-_237) * 2.0f.xxxx) + 3.0f.xxxx;
    _237 *= _252;
    _252 = _194 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _252 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _567.x = dot(_252.xy, _622.xy);
    _428 = dot(_252.zw, _622.zw);
    _164 = _428.xx + _252.zw;
    _567 = _567.xx + _252.xy;
    _567.x = _567.y * _567.x;
    _567.y = _164.y * _164.x;
    _567 = frac(_567);
    _252 = _194.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _252 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _164.x = dot(_252.zw, _622.zw);
    _361 = dot(_252.xy, _622.xy);
    float2 _684 = _361.xx + _252.xy;
    _252 = float4(_684.x, _684.y, _252.z, _252.w);
    _164 = _164.xx + _252.zw;
    _164.x = _164.y * _164.x;
    _164.y = _252.y * _252.x;
    _164 = frac(_164);
    _567.x += (-_164.x);
    _567.x = (_237.x * _567.x) + _164.x;
    _252 = _194 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _194 = _194.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _194 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _194 = frac(_194);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _164.x = dot(_252.xy, _622.xy);
    _622.x = dot(_252.zw, _622.zw);
    _748 = _252.zw + _622.xx;
    float2 _758 = _164.xx + _252.xy;
    _252 = float4(_758.x, _758.y, _252.z, _252.w);
    _164.x = _252.y * _252.x;
    _164.x = frac(_164.x);
    _252.x = _748.y * _748.x;
    _252.x = frac(_252.x);
    _361 = (-_164.x) + _164.y;
    _164.x = (_237.x * _361) + _164.x;
    _567.x += (-_164.x);
    _567.x = (_237.y * _567.x) + _164.x;
    _567.x *= 0.25f;
    _176.x = (_176.x * 0.5f) + _567.x;
    _622 = _194 + 45.31999969482421875f.xxxx;
    _567.x = dot(_194.zw, _622.zw);
    _164.x = dot(_194.xy, _622.xy);
    _164 = _164.xx + _194.xy;
    float2 _846 = _567.xx + _194.zw;
    _194 = float4(_846.x, _846.y, _194.z, _194.w);
    _567.x = _194.y * _194.x;
    _567.x = frac(_567.x);
    _164.x = _164.y * _164.x;
    _164.x = frac(_164.x);
    _567.x += (-_164.x);
    _567.x = (_237.z * _567.x) + _164.x;
    _428 = _567.y + (-_252.x);
    _428 = (_237.z * _428) + _252.x;
    _567.x = (-_428) + _567.x;
    _567.x = (_237.w * _567.x) + _428;
    _176.x = (_567.x * 0.125f) + _176.x;
    float3 _926 = _9.xxx * float3(1.5f, 2.22222232818603515625f, 2.5f);
    _194 = float4(_926.x, _926.y, _926.z, _194.w);
    _567.x = ((-_9.w) * _16_m18) + _194.z;
    _9.w *= _16_m22;
    _194 = float4(_194.xy.x, _194.xy.y, _194.z, _194.w);
    float2 _955 = clamp(_194.xy, 0.0f.xx, 1.0f.xx);
    _194 = float4(_955.x, _955.y, _194.z, _194.w);
    _170.x = floor(_567.x);
    _164 = _170.xy + 1.0f.xx;
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    _213 = _164 + 45.31999969482421875f.xx;
    _428 = dot(_164, _213);
    _164 = _428.xx + _164;
    _567.y = _164.y * _164.x;
    _567 = frac(_567);
    _237 = _170.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _991 = _170.xy * float2(123.339996337890625f, 456.209991455078125f);
    _170 = float4(_991.x, _991.y, _170.z, _170.w);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _164.x = dot(_237.zw, _252.zw);
    _361 = dot(_237.xy, _252.xy);
    _213 = _361.xx + _237.xy;
    _164 = _164.xx + _237.zw;
    _170.z = _164.y * _164.x;
    _170.w = _213.y * _213.x;
    _170 = frac(_170);
    _428 = _567.y + (-_170.z);
    _213.x = _567.x * _567.x;
    _567.x = ((-_567.x) * 2.0f) + 3.0f;
    _567.x *= _213.x;
    _428 = (_567.x * _428) + _170.z;
    _213 = _170.xy + 45.31999969482421875f.xx;
    _164.x = dot(_170.xy, _213);
    float2 _1078 = _164.xx + _170.xy;
    _170 = float4(_1078.x, _1078.y, _170.z, _170.w);
    _170.x = _170.y * _170.x;
    _170.x = frac(_170.x);
    _1091 = (-_170.x) + _170.w;
    _567.x = (_567.x * _1091) + _170.x;
    _428 = (-_567.x) + _428;
    _567.x = (_428 * 0.78400003910064697265625f) + _567.x;
    _567.x = (_567.x * 2.0f) + (-1.0f);
    _567.x *= _16_m17;
    _47 = ((-_567.x) * _194.x) + _9.z;
    _47 = (_27.x * _9.x) + _47;
    _27.x = (_194.y * (-2.0f)) + 3.0f;
    _567.x = _194.y * _194.y;
    _27.x = _567.x * _27.x;
    _567.x = (-_16_m10) + _16_m11;
    _27.x = (_27.x * _567.x) + _16_m10;
    _567.x = (_9.y * _16_m24) + (-_16_m12);
    float2 _1202 = (_9.yy * _16_m24.xx) + float2(0.0199999995529651641845703125f, -0.20000000298023223876953125f);
    _170 = float4(_1202.x, _1202.y, _170.z, _170.w);
    float2 _1210 = _170.xy * float2(12.5f, 1.4285714626312255859375f);
    _170 = float4(_1210.x, _1210.y, _170.z, _170.w);
    float2 _1217 = clamp(_170.xy, 0.0f.xx, 1.0f.xx);
    _170 = float4(_1217.x, _1217.y, _170.z, _170.w);
    _164 = (-float2(float2(_16_m12, _16_m12))) + float2(1.0f, 1.0499999523162841796875f);
    _164 = 1.0f.xx / _164;
    _567 = _567.xx * _164;
    _567 = clamp(_567, 0.0f.xx, 1.0f.xx);
    _164 = (_567 * (-2.0f).xx) + 3.0f.xx;
    _567 *= _567;
    _59 = _567.x * _164.x;
    _567.x = ((-_164.y) * _567.y) + 1.0f;
    _59 = ((-_59) * 0.60000002384185791015625f) + 1.0f;
    _428 = _59 * _27.x;
    _164.x = (-_16_m13) + 1.0f;
    _361 = ((-_428) * _164.x) + abs(_47);
    _47 = abs(_47) * (-3.0f);
    _164.x = _428 * _164.x;
    _428 *= _16_m20;
    _428 = max(_428, 9.9999997473787516355514526367188e-05f);
    _47 /= _428;
    _47 = exp2(_47);
    _59 = (_27.x * _59) + (-_164.x);
    _59 = 1.0f / _59;
    _59 *= _361;
    _59 = clamp(_59, 0.0f, 1.0f);
    _27.x = (_59 * (-2.0f)) + 3.0f;
    _59 *= _59;
    _59 = ((-_27.x) * _59) + 1.0f;
    _27.x = _59 * _176.x;
    float2 _1348 = (_176.xx * float2(0.628571450710296630859375f, 0.457142889499664306640625f)) + float2(0.449999988079071044921875f, 0.60000002384185791015625f);
    _1340 = float3(_1348.x, _1348.y, _1340.z);
    _59 = (_59 * 0.5f) + 0.5f;
    float2 _1357 = (_170.xy * (-2.0f).xx) + 3.0f.xx;
    _176 = float3(_1357.x, _176.y, _1357.y);
    float2 _1364 = _170.xy * _170.xy;
    _170 = float4(_1364.x, _1364.y, _170.z, _170.w);
    _176.x *= _170.x;
    _428 = ((-_176.z) * _170.y) + 1.0f;
    _176.x = _567.x * _176.x;
    _27.x = _176.x * _27.x;
    _47 *= _176.x;
    _47 = _428 * _47;
    _1399.x = _1340.y * _47;
    _1399.x = clamp(_1399.x, 0.0f, 1.0f);
    _1399.x = (_1399.x * _16_m26) + 0.5f;
    _1399.x = floor(_1399.x);
    _1399.x /= _16_m26;
    _47 = (_9.x * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _9.x = _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * (-0.550000011920928955078125f)) + 1.0f;
    _47 *= _16_m16;
    _47 = (_27.x * 1.8285715579986572265625f) + (-_47);
    _47 *= 2.857142925262451171875f;
    _47 = clamp(_47, 0.0f, 1.0f);
    _27.x = (_47 * (-2.0f)) + 3.0f;
    _47 *= _47;
    _47 *= _27.x;
    _1473 = log2(_47);
    _1473 *= _16_m6;
    _1473 = exp2(_1473);
    _9.x *= _1473;
    _9.x = _1340.x * _9.x;
    _9.x = _59 * _9.x;
    _1340.x = (_16_m4 * 2.0f) + 1.0f;
    _1340.x = _9.x * _1340.x;
    _1340.x = clamp(_1340.x, 0.0f, 1.0f);
    _1473 = _9.x * 4.0f;
    _1473 = clamp(_1473, 0.0f, 1.0f);
    _1473 = max(_1399.x, _1473);
    _1340.y = _1399.x * _16_m21;
    _1533.w = min(_1473, 1.0f);
    _1340.x = (_1340.x * _16_m26) + 0.5f;
    _1340.x = floor(_1340.x);
    _1340.x /= _16_m26;
    _1473 = _1340.x + (-0.3499999940395355224609375f);
    _1473 *= 2.2222220897674560546875f;
    _1473 = clamp(_1473, 0.0f, 1.0f);
    _1564 = (_1473 * (-2.0f)) + 3.0f;
    _1473 *= _1473;
    _1473 *= _1564;
    _1564 = _1340.x * 2.857142925262451171875f;
    _1340.x = (_1340.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _1340.x *= _16_m5;
    _1564 = _1564;
    _1564 = clamp(_1564, 0.0f, 1.0f);
    _1594.x = (_1564 * (-2.0f)) + 3.0f;
    _1564 *= _1564;
    _1564 *= _1594.x;
    _1594 = (-_16_m1.xyz) + _16_m2.xyz;
    _1594 = (_1564.xxx * _1594) + _16_m1.xyz;
    _1624 = (-_1594) + _16_m3.xyz;
    _1594 = (_1473.xxx * _1624) + _1594;
    _9.x = floor(_9.w);
    _9.y = 0.0f;
    float2 _1646 = _9.xy + float2(1.0f, 0.0f);
    _27 = float4(_1646.x, _1646.y, _27.z, _27.w);
    float2 _1651 = _9.xy * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_1651.x, _1651.y, _9.z, _9.w);
    float3 _1656 = frac(_9.xyw);
    _9 = float4(_1656.x, _1656.y, _1656.z, _9.w);
    float2 _1661 = _27.xy * float2(123.339996337890625f, 456.209991455078125f);
    _27 = float4(_1661.x, _1661.y, _27.z, _27.w);
    float2 _1666 = frac(_27.xy);
    _27 = float4(_1666.x, _1666.y, _27.z, _27.w);
    _118 = _27.x + 45.31999969482421875f;
    float2 _1679 = (_27.xx * _118.xx) + _27.xy;
    _27 = float4(_1679.x, _1679.y, _27.z, _27.w);
    _9.w = _27.y * _27.x;
    _27.x = _9.x + 45.31999969482421875f;
    float2 _1699 = (_9.xx * _27.xx) + _9.xy;
    _9 = float4(_1699.x, _1699.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    float2 _1710 = frac(_9.xw);
    _9 = float4(_1710.x, _9.y, _9.z, _1710.y);
    _59 = (-_9.x) + _9.w;
    _118 = _9.z * _9.z;
    _47 = ((-_9.z) * 2.0f) + 3.0f;
    _47 *= _118;
    _9.x = (_47 * _59) + _9.x;
    _1473 = (-_16_m23) + 1.0f;
    _9.x = (_16_m23 * _9.x) + _1473;
    float2 _1756 = _9.xx * _1340.xy;
    _1340 = float3(_1756.x, _1756.y, _1340.z);
    _1399 = _1340.yyy * _16_m3.xyz;
    _1340 = (_1594 * _1340.xxx) + _1399;
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _1781 = _1340 * _9.xxx;
    _9 = float4(_1781.x, _1781.y, _1781.z, _9.w);
    _1533 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1533.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1533 = _1533;
    return stage_output;
}

#endif
#elif defined(_SPARKS_ON)
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
float4 _EdgeColor;
float4 _MidColor;
float4 _CoreColor;
float _WhiteBias;
float _Intensity;
float _Contrast;
float4 _RootUV;
float4 _TipUV;
float _AcrossScale;
float _RootWidth;
float _MaxWidth;
float _TipStart;
float _EdgeSoftness;
float _FlameScale;
float _FlameSpeed;
float _Erosion;
float _Wiggle;
float _WiggleSpeed;
float _WarpStrength;
float _CoreWidth;
float _CoreIntensity;
float _SparkDensity;
float _SparkSpeed;
float _SparkSize;
float _SparkChance;
float _SparkIntensity;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _22_m0 _Time
#define _22_m1 _EdgeColor
#define _22_m2 _MidColor
#define _22_m3 _CoreColor
#define _22_m4 _WhiteBias
#define _22_m5 _Intensity
#define _22_m6 _Contrast
#define _22_m7 _RootUV
#define _22_m8 _TipUV
#define _22_m9 _AcrossScale
#define _22_m10 _RootWidth
#define _22_m11 _MaxWidth
#define _22_m12 _TipStart
#define _22_m13 _EdgeSoftness
#define _22_m14 _FlameScale
#define _22_m15 _FlameSpeed
#define _22_m16 _Erosion
#define _22_m17 _Wiggle
#define _22_m18 _WiggleSpeed
#define _22_m19 _WarpStrength
#define _22_m20 _CoreWidth
#define _22_m21 _CoreIntensity
#define _22_m22 _SparkDensity
#define _22_m23 _SparkSpeed
#define _22_m24 _SparkSize
#define _22_m25 _SparkChance
#define _22_m26 _SparkIntensity
#define _22_m27 _PulseSpeed
#define _22_m28 _PulseAmount
#define _22_m29 _PixelSize
#define _22_m30 _FrameRate
#define _22_m31 _Steps



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _2146;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _2146 : SV_Target0;
};

static float4 _9;
static float4 _15;
static float4 _33;
static float2 _52;
static float _65;
static float _125;
static float3 _189;
static float4 _200;
static float2 _220;
static float4 _244;
static float4 _265;
static float3 _269;
static float _379;
static float _446;
static float _482;
static float2 _533;
static float4 _672;
static float _681;
static float2 _755;
static float2 _921;
static float2 _1061;
static float2 _1361;
static float _1457;
static float _1534;
static float3 _1541;
static float3 _1651;
static float3 _1690;
static float3 _1743;
static float2 _1980;
static float _1997;
static bool _2084;
static bool _2131;

void frag_inner()
{
    _9.w = 1.2999999523162841796875f;
    float2 _30 = vs_TEXCOORD0 + (-_22_m7.xy);
    _15 = float4(_30.x, _30.y, _15.z, _15.w);
    float2 _42 = (-_22_m7.xy) + _22_m8.xy;
    _33 = float4(_42.x, _42.y, _33.z, _33.w);
    _33.z = -_33.x;
    _52.x = dot(_15.xy, _33.yz);
    _15.x = dot(_15.xy, _33.xy);
    _65 = dot(_33.xy, _33.xy);
    _65 = max(_65, 9.9999997473787516355514526367188e-06f);
    _65 = 1.0f / _65;
    _33.y = _65 * _15.x;
    _15.x = _65 * _52.x;
    _33.x = _15.x * _22_m9;
    float2 _102 = _33.xy / _22_m29.xx;
    _15 = float4(_102.x, _102.y, _15.z, _15.w);
    float2 _107 = floor(_15.xy);
    _15 = float4(_107.x, _107.y, _15.z, _15.w);
    float2 _114 = _15.xy + 0.5f.xx;
    _15 = float4(_114.x, _114.y, _15.z, _15.w);
    float2 _122 = _15.xy * _22_m29.xx;
    _15 = float4(_122.x, _15.y, _122.y, _15.w);
    _125 = vs_TEXCOORD1 + _22_m0.y;
    _125 *= _22_m30;
    _125 = floor(_125);
    _15.w = _125 / _22_m30;
    float3 _157 = _15.xzw * float3(_22_m14, _22_m14, _22_m15);
    _33 = float4(_157.x, _157.y, _33.z, _157.z);
    _33.z = (_33.y * 0.449999988079071044921875f) + (-_33.w);
    float3 _175 = _15.www * float3(0.699999988079071044921875f, 3.0f, 9.0f);
    _9 = float4(_175.x, _175.y, _175.z, _9.w);
    float2 _185 = (_33.xz * 0.800000011920928955078125f.xx) + _9.wx;
    _9 = float4(_185.x, _9.y, _9.z, _185.y);
    float2 _192 = floor(_9.xw);
    _189 = float3(_192.x, _189.y, _192.y);
    float2 _197 = frac(_9.xw);
    _9 = float4(_197.x, _9.y, _9.z, _197.y);
    float2 _204 = _189.xz + 1.0f.xx;
    _200 = float4(_204.x, _204.y, _200.z, _200.w);
    float2 _212 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_212.x, _212.y, _200.z, _200.w);
    float2 _217 = frac(_200.xy);
    _200 = float4(_217.x, _217.y, _200.z, _200.w);
    _220 = _200.xy + 45.31999969482421875f.xx;
    _220.x = dot(_200.xy, _220);
    float2 _235 = _220.xx + _200.xy;
    _200 = float4(_235.x, _235.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _244 = _189.xzxz + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _252 = _189.xz * float2(123.339996337890625f, 456.209991455078125f);
    _189 = float3(_252.x, _189.y, _252.y);
    float2 _257 = frac(_189.xz);
    _189 = float3(_257.x, _189.y, _257.y);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _269.x = dot(_244.zw, _265.zw);
    _220.x = dot(_244.xy, _265.xy);
    _220 = _220.xx + _244.xy;
    float2 _291 = _269.xx + _244.zw;
    _244 = float4(_291.x, _291.y, _244.z, _244.w);
    _200.y = _244.y * _244.x;
    _200.z = _220.y * _220.x;
    float3 _308 = frac(_200.xyz);
    _200 = float4(_308.x, _308.y, _308.z, _200.w);
    _200.x = (-_200.y) + _200.x;
    float2 _322 = _9.xw * _9.xw;
    _244 = float4(_322.x, _322.y, _244.z, _244.w);
    float2 _332 = ((-_9.xw) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_332.x, _9.y, _9.z, _332.y);
    float2 _339 = _9.xw * _244.xy;
    _9 = float4(_339.x, _9.y, _9.z, _339.y);
    _200.x = (_9.x * _200.x) + _200.y;
    float2 _353 = _189.xz + 45.31999969482421875f.xx;
    _269 = float3(_353.x, _269.y, _353.y);
    _269.x = dot(_189.xz, _269.xz);
    float2 _366 = _189.xz + _269.xx;
    _189 = float3(_366.x, _189.y, _366.y);
    _189.x = _189.z * _189.x;
    _189.x = frac(_189.x);
    _379 = (-_189.x) + _200.z;
    _9.x = (_9.x * _379) + _189.x;
    _189.x = (-_9.x) + _200.x;
    _9.x = (_9.w * _189.x) + _9.x;
    _9.x = (_9.x * 2.0f) + (-1.0f);
    _33 = (_9.xxxx * 0.5f.xxxx) + _33.xzxz;
    _9.x *= _22_m19;
    float2 _432 = floor(_33.zw);
    _200 = float4(_432.x, _432.y, _200.z, _200.w);
    _220 = _200.xy + 1.0f.xx;
    _220 *= float2(123.339996337890625f, 456.209991455078125f);
    _220 = frac(_220);
    float2 _443 = _220 + 45.31999969482421875f.xx;
    _244 = float4(_443.x, _443.y, _244.z, _244.w);
    _446 = dot(_220, _244.xy);
    _220 = _446.xx + _220;
    _446 = _220.y * _220.x;
    _446 = frac(_446);
    _244 = _200.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _467 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_467.x, _467.y, _200.z, _200.w);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _220.x = dot(_244.zw, _265.zw);
    _482 = dot(_244.xy, _265.xy);
    float2 _492 = _482.xx + _244.xy;
    _244 = float4(_492.x, _492.y, _244.z, _244.w);
    _220 = _220.xx + _244.zw;
    _200.z = _220.y * _220.x;
    _200.w = _244.y * _244.x;
    _200 = frac(_200);
    _446 += (-_200.z);
    float2 _521 = frac(_33.zw);
    _244 = float4(_521.x, _521.y, _244.z, _244.w);
    _33 = (_33 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _533 = _244.xy * _244.xy;
    float2 _543 = ((-_244.xy) * 2.0f.xx) + 3.0f.xx;
    _244 = float4(_543.x, _543.y, _244.z, _244.w);
    float2 _549 = _244.xy * _533;
    _244 = float4(_549.x, _549.y, _244.z, _244.w);
    _446 = (_244.x * _446) + _200.z;
    _533 = _200.xy + 45.31999969482421875f.xx;
    _220.x = dot(_200.xy, _533);
    float2 _571 = _220.xx + _200.xy;
    _200 = float4(_571.x, _571.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _200.x = frac(_200.x);
    _269.x = (-_200.x) + _200.w;
    _200.x = (_244.x * _269.x) + _200.x;
    _446 += (-_200.x);
    _446 = (_244.y * _446) + _200.x;
    _200 = frac(_33);
    _33 = floor(_33);
    _244 = _200 * _200;
    _200 = ((-_200) * 2.0f.xxxx) + 3.0f.xxxx;
    _200 *= _244;
    _244 = _33 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _265.x = dot(_244.xy, _265.xy);
    _265.y = dot(_244.zw, _265.zw);
    _244 += _265.xxyy;
    _244.x = _244.y * _244.x;
    _244.y = _244.w * _244.z;
    _265 = _33.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _265 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _265 = frac(_265);
    _672 = _265 + 45.31999969482421875f.xxxx;
    _533.x = dot(_265.zw, _672.zw);
    _681 = dot(_265.xy, _672.xy);
    float2 _691 = _681.xx + _265.xy;
    _265 = float4(_691.x, _691.y, _265.z, _265.w);
    _533 = _533.xx + _265.zw;
    _244.z = _533.y * _533.x;
    _244.w = _265.y * _265.x;
    _244 = frac(_244);
    _244.x = (-_244.z) + _244.x;
    _244.x = (_200.x * _244.x) + _244.z;
    _265 = _33 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = _33.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _33 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = frac(_33);
    _265 = frac(_265);
    _672 = _265 + 45.31999969482421875f.xxxx;
    _533.x = dot(_265.xy, _672.xy);
    _672.x = dot(_265.zw, _672.zw);
    _755 = _265.zw + _672.xx;
    float2 _765 = _533.xx + _265.xy;
    _265 = float4(_765.x, _765.y, _265.z, _265.w);
    _533.x = _265.y * _265.x;
    _533.x = frac(_533.x);
    _265.x = _755.y * _755.x;
    _265.x = frac(_265.x);
    _681 = (-_533.x) + _244.w;
    _200.x = (_200.x * _681) + _533.x;
    _244.x = (-_200.x) + _244.x;
    _200.x = (_200.y * _244.x) + _200.x;
    _200.x *= 0.25f;
    _446 = (_446 * 0.5f) + _200.x;
    _672 = _33 + 45.31999969482421875f.xxxx;
    _200.x = dot(_33.zw, _672.zw);
    _200.y = dot(_33.xy, _672.xy);
    _33 += _200.yyxx;
    float2 _850 = _33.yw * _33.xz;
    _33 = float4(_850.x, _33.y, _850.y, _33.w);
    float2 _855 = frac(_33.xz);
    _33 = float4(_855.x, _33.y, _855.y, _33.w);
    _189.x = (-_33.x) + _33.z;
    _33.x = (_200.z * _189.x) + _33.x;
    _189.x = _244.y + (-_265.x);
    _189.x = (_200.z * _189.x) + _265.x;
    _33.x = (-_189.x) + _33.x;
    _33.x = (_200.w * _33.x) + _189.x;
    _446 = (_33.x * 0.125f) + _446;
    float3 _918 = _15.zzz * float3(1.5f, 2.22222232818603515625f, 2.5f);
    _33 = float4(_918.x, _918.y, _918.z, _33.w);
    _921.x = ((-_15.w) * _22_m18) + _33.z;
    _33 = float4(_33.xy.x, _33.xy.y, _33.z, _33.w);
    float2 _941 = clamp(_33.xy, 0.0f.xx, 1.0f.xx);
    _33 = float4(_941.x, _941.y, _33.z, _33.w);
    _379 = frac(_921.x);
    _200.x = floor(_921.x);
    _921.x = _379 * _379;
    _379 = ((-_379) * 2.0f) + 3.0f;
    _921.x = _379 * _921.x;
    _200.y = 3.0f;
    _220.y = 0.0f;
    float2 _968 = _200.xy + 1.0f.xx;
    _244 = float4(_968.x, _968.y, _244.z, _244.w);
    float2 _973 = _244.xy * float2(123.339996337890625f, 456.209991455078125f);
    _244 = float4(_973.x, _973.y, _244.z, _244.w);
    float2 _978 = frac(_244.xy);
    _244 = float4(_978.x, _978.y, _244.z, _244.w);
    _533 = _244.xy + 45.31999969482421875f.xx;
    _379 = dot(_244.xy, _533);
    float2 _992 = _379.xx + _244.xy;
    _244 = float4(_992.x, _992.y, _244.z, _244.w);
    _379 = _244.y * _244.x;
    _379 = frac(_379);
    _244 = _200.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _1007 = _200.xy * float2(123.339996337890625f, 456.209991455078125f);
    _200 = float4(_1007.x, _1007.y, _200.z, _200.w);
    float2 _1012 = frac(_200.xy);
    _200 = float4(_1012.x, _1012.y, _200.z, _200.w);
    _244 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _244 = frac(_244);
    _265 = _244 + 45.31999969482421875f.xxxx;
    _265.z = dot(_244.zw, _265.zw);
    _265.x = dot(_244.xy, _265.xy);
    _244 += _265.xxzz;
    float2 _1041 = _244.yw * _244.xz;
    _244 = float4(_1041.x, _244.y, _1041.y, _244.w);
    float2 _1046 = frac(_244.xz);
    _244 = float4(_1046.x, _244.y, _1046.y, _244.w);
    _379 += (-_244.z);
    _379 = (_921.x * _379) + _244.z;
    _1061 = _200.xy + 45.31999969482421875f.xx;
    _1061.x = dot(_200.xy, _1061);
    float2 _1074 = _200.xy + _1061.xx;
    _200 = float4(_1074.x, _1074.y, _200.z, _200.w);
    _200.x = _200.y * _200.x;
    _200.x = frac(_200.x);
    _269.x = (-_200.x) + _244.x;
    _921.x = (_921.x * _269.x) + _200.x;
    _379 = (-_921.x) + _379;
    _921.x = (_379 * 0.78400003910064697265625f) + _921.x;
    _921.x = (_921.x * 2.0f) + (-1.0f);
    _921.x *= _22_m17;
    _33.x = ((-_921.x) * _33.x) + _15.x;
    _9.x = (_9.x * _15.z) + _33.x;
    _33.x = (_15.y * _22_m29) + (-_22_m12);
    float3 _1167 = (_15.yyy * _22_m29.xxx) + float3(0.0199999995529651641845703125f, -0.20000000298023223876953125f, -0.85000002384185791015625f);
    _244 = float4(_1167.x, _1167.y, _1167.z, _244.w);
    float3 _1176 = _244.xyz * float3(12.5f, 1.4285714626312255859375f, 5.0000019073486328125f);
    _244 = float4(_1176.x, _1176.y, _1176.z, _244.w);
    float3 _1183 = clamp(_244.xyz, 0.0f.xxx, 1.0f.xxx);
    _244 = float4(_1183.x, _1183.y, _1183.z, _244.w);
    _921 = (-float2(float2(_22_m12, _22_m12))) + float2(1.0f, 1.0499999523162841796875f);
    _921 = 1.0f.xx / _921;
    float2 _1203 = _921 * _33.xx;
    _33 = float4(_1203.x, _33.y, _1203.y, _33.w);
    float2 _1210 = clamp(_33.xz, 0.0f.xx, 1.0f.xx);
    _33 = float4(_1210.x, _33.y, _1210.y, _33.w);
    float2 _1218 = (_33.xz * (-2.0f).xx) + 3.0f.xx;
    _200 = float4(_1218.x, _1218.y, _200.z, _200.w);
    float2 _1225 = _33.xz * _33.xz;
    _33 = float4(_1225.x, _33.y, _1225.y, _33.w);
    _65 = _33.x * _200.x;
    _33.x = ((-_200.y) * _33.z) + 1.0f;
    _65 = ((-_65) * 0.60000002384185791015625f) + 1.0f;
    _921.x = (_33.y * (-2.0f)) + 3.0f;
    _189.x = _33.y * _33.y;
    _189.x *= _921.x;
    _921.x = (-_22_m10) + _22_m11;
    _189.x = (_189.x * _921.x) + _22_m10;
    _921.x = _65 * _189.x;
    _379 = (-_22_m13) + 1.0f;
    _200.x = ((-_921.x) * _379) + abs(_9.x);
    _379 *= _921.x;
    _379 = (_189.x * _65) + (-_379);
    _65 = ((-_189.x) * _65) + abs(_9.x);
    _9.x = abs(_9.x) * (-3.0f);
    _189.x = 1.0f / _379;
    _189.x *= _200.x;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _379 = (_189.x * (-2.0f)) + 3.0f;
    _189.x *= _189.x;
    _189.x = ((-_379) * _189.x) + 1.0f;
    _379 = _446 * _189.x;
    _1361 = (_446.xx * float2(0.628571450710296630859375f, 0.457142889499664306640625f)) + float2(0.449999988079071044921875f, 0.60000002384185791015625f);
    _446 = (_189.x * 0.5f) + 0.5f;
    float3 _1379 = (_244.xyz * (-2.0f).xxx) + 3.0f.xxx;
    _265 = float4(_1379.x, _1379.y, _1379.z, _265.w);
    float3 _1386 = _244.xyz * _244.xyz;
    _244 = float4(_1386.x, _1386.y, _1386.z, _244.w);
    _189.x = _244.x * _265.x;
    float2 _1401 = ((-_265.yz) * _244.yz) + 1.0f.xx;
    _200 = float4(_1401.x, _1401.y, _200.z, _200.w);
    _33.x *= _189.x;
    _189.x = _33.x * _379;
    _379 = (_15.z * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _379 *= _22_m16;
    _189.x = (_189.x * 1.8285715579986572265625f) + (-_379);
    _189.x *= 2.857142925262451171875f;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _379 = (_189.x * (-2.0f)) + 3.0f;
    _189.x *= _189.x;
    _189.x *= _379;
    _1457 = log2(_189.x);
    _1457 *= _22_m6;
    _1457 = exp2(_1457);
    _189.x = _15.z;
    _189.x = clamp(_189.x, 0.0f, 1.0f);
    _189.x = (_189.x * (-0.550000011920928955078125f)) + 1.0f;
    _189.x *= _1457;
    _189.x = _1361.x * _189.x;
    _446 *= _189.x;
    _1361.x = (_22_m4 * 2.0f) + 1.0f;
    _1361.x = _446 * _1361.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1457 = _446 * 4.0f;
    _1457 = clamp(_1457, 0.0f, 1.0f);
    _1361.x = (_1361.x * _22_m31) + 0.5f;
    _1361.x = floor(_1361.x);
    _1361.x /= _22_m31;
    _1534 = (_1361.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _1541.z = _1534 * _22_m5;
    _446 = _15.w * _22_m27;
    _125 = _15.w * _22_m23;
    _220.x = floor(_446);
    _446 = frac(_446);
    float2 _1567 = _220 + float2(1.0f, 0.0f);
    _189 = float3(_1567.x, _189.y, _1567.y);
    _220 *= float2(123.339996337890625f, 456.209991455078125f);
    _220 = frac(_220);
    float2 _1576 = _189.xz * float2(123.339996337890625f, 456.209991455078125f);
    _189 = float3(_1576.x, _189.y, _1576.y);
    float2 _1581 = frac(_189.xz);
    _189 = float3(_1581.x, _189.y, _1581.y);
    _244.x = _189.x + 45.31999969482421875f;
    float2 _1595 = (_189.xx * _244.xx) + _189.xz;
    _189 = float3(_1595.x, _189.y, _1595.y);
    _189.x = _189.z * _189.x;
    _379 = _220.x + 45.31999969482421875f;
    _220 = (_220.xx * _379.xx) + _220;
    _189.z = _220.y * _220.x;
    float2 _1622 = frac(_189.xz);
    _189 = float3(_1622.x, _189.y, _1622.y);
    _189.x = (-_189.z) + _189.x;
    _220.x = _446 * _446;
    _446 = ((-_446) * 2.0f) + 3.0f;
    _446 *= _220.x;
    _446 = (_446 * _189.x) + _189.z;
    _1651.x = (-_22_m28) + 1.0f;
    _446 = (_22_m28 * _446) + _1651.x;
    _1651.x = _1361.x + (-0.3499999940395355224609375f);
    _1361.x *= 2.857142925262451171875f;
    _1361.x = _1361.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1651.x *= 2.2222220897674560546875f;
    _1651.x = clamp(_1651.x, 0.0f, 1.0f);
    _1690.x = (_1651.x * (-2.0f)) + 3.0f;
    _1651.x *= _1651.x;
    _1651.x *= _1690.x;
    _1690.x = (_1361.x * (-2.0f)) + 3.0f;
    _1361.x *= _1361.x;
    _1361.x *= _1690.x;
    _1690 = (-_22_m1.xyz) + _22_m2.xyz;
    _1690 = (_1361.xxx * _1690) + _22_m1.xyz;
    _1743 = (-_1690) + _22_m3.xyz;
    _1651 = (_1651.xxx * _1743) + _1690;
    _189.x = _921.x * _22_m20;
    _921.x = 1.0f / _921.x;
    _65 *= _921.x;
    _65 = clamp(_65, 0.0f, 1.0f);
    _189.x = max(_189.x, 9.9999997473787516355514526367188e-05f);
    _9.x /= _189.x;
    _9.x = exp2(_9.x);
    _9.x = _33.x * _9.x;
    _9.x = _200.x * _9.x;
    _1361.x = _1361.y * _9.x;
    _1361.x = clamp(_1361.x, 0.0f, 1.0f);
    _1361.x = (_1361.x * _22_m31) + 0.5f;
    _1361.x = floor(_1361.x);
    _1361.x /= _22_m31;
    _1541.x = _1361.x * _22_m21;
    _1361.x = max(_1361.x, _1457);
    _1361.x = min(_1361.x, 1.0f);
    float2 _1848 = _446.xx * _1541.xz;
    _1541 = float3(_1848.x, _1541.y, _1848.y);
    _1743 = _1541.xxx * _22_m3.xyz;
    _1541 = (_1651 * _1541.zzz) + _1743;
    float2 _1869 = _15.xz * _22_m22.xx;
    _9 = float4(_1869.x, _9.y, _9.z, _1869.y);
    _15.x = _15.z * 4.0f;
    _15.x = clamp(_15.x, 0.0f, 1.0f);
    _9.w = ((-_125) * _22_m22) + _9.w;
    float2 _1891 = frac(_9.xw);
    _33 = float4(_1891.x, _1891.y, _33.z, _33.w);
    _244 = floor(_9.xwxw);
    float2 _1901 = _33.xy + (-0.5f).xx;
    _9 = float4(_1901.x, _9.y, _9.z, _1901.y);
    _33 = _244 + float4(7.099999904632568359375f, 7.099999904632568359375f, 3.2999999523162841796875f, 3.2999999523162841796875f);
    _52 = _244.zw * float2(123.339996337890625f, 456.209991455078125f);
    _52 = frac(_52);
    _33 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _33 = frac(_33);
    _244 = _33 + 45.31999969482421875f.xxxx;
    _200.x = dot(_33.xy, _244.xy);
    _200.z = dot(_33.zw, _244.zw);
    _33 += _200.xxzz;
    _33.x = _33.y * _33.x;
    _1061.x = frac(_33.x);
    _33.x = _33.w * _33.z;
    _1061.y = frac(_33.x);
    float2 _1957 = _1061 + (-0.5f).xx;
    _33 = float4(_1957.x, _1957.y, _33.z, _33.w);
    _921 = _52 + 45.31999969482421875f.xx;
    _921.x = dot(_52, _921);
    _52 += _921.xx;
    _52.x = _52.y * _52.x;
    _52.x = frac(_52.x);
    _1980 = (_52.xx * float2(6.283199787139892578125f, 40.0f)) + _9.yz;
    _1980 = sin(_1980);
    _1980.x *= 0.1500000059604644775390625f;
    _1997 = (_1980.y * 0.5f) + 0.5f;
    _33.x = (_33.x * 0.60000002384185791015625f) + _1980.x;
    _33.z = _33.y * 0.60000002384185791015625f;
    float2 _2018 = _9.xw + (-_33.xz);
    _9 = float4(_2018.x, _2018.y, _9.z, _9.w);
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x += (-_22_m24);
    _1980.x = 1.0f / (-_22_m24);
    _9.x = _1980.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1980.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _1980.x;
    _9.x = _1997 * _9.x;
    _1980.x = (-_22_m25) + 1.0f;
    _2084 = _52.x >= _1980.x;
    _1980.x = float(_2084);
    _9.x = _1980.x * _9.x;
    _1980.x = (_65 * (-2.0f)) + 3.0f;
    _1997 = _65 * _65;
    _1980.x = ((-_1980.x) * _1997) + 1.0f;
    _1980.x = _15.x * _1980.x;
    _1980.x = _200.y * _1980.x;
    _9.x = _1980.x * _9.x;
    _2131 = _9.x >= 0.5f;
    _9.x = float(_2131);
    _1651.x = _9.x * _22_m26;
    _2146.w = max(_9.x, _1361.x);
    _1690 = (-_22_m2.xyz) + _22_m3.xyz;
    _1690 = (_1690 * 0.60000002384185791015625f.xxx) + _22_m2.xyz;
    float3 _2174 = (_1690 * _1651.xxx) + _1541;
    _2146 = float4(_2174.x, _2174.y, _2174.z, _2146.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2146 = _2146;
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
float4 _EdgeColor;
float4 _MidColor;
float4 _CoreColor;
float _WhiteBias;
float _Intensity;
float _Contrast;
float4 _RootUV;
float4 _TipUV;
float _AcrossScale;
float _RootWidth;
float _MaxWidth;
float _TipStart;
float _EdgeSoftness;
float _FlameScale;
float _FlameSpeed;
float _Erosion;
float _Wiggle;
float _WiggleSpeed;
float _WarpStrength;
float _CoreWidth;
float _CoreIntensity;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _16_m0 _Time
#define _16_m1 _EdgeColor
#define _16_m2 _MidColor
#define _16_m3 _CoreColor
#define _16_m4 _WhiteBias
#define _16_m5 _Intensity
#define _16_m6 _Contrast
#define _16_m7 _RootUV
#define _16_m8 _TipUV
#define _16_m9 _AcrossScale
#define _16_m10 _RootWidth
#define _16_m11 _MaxWidth
#define _16_m12 _TipStart
#define _16_m13 _EdgeSoftness
#define _16_m14 _FlameScale
#define _16_m15 _FlameSpeed
#define _16_m16 _Erosion
#define _16_m17 _Wiggle
#define _16_m18 _WiggleSpeed
#define _16_m19 _WarpStrength
#define _16_m20 _CoreWidth
#define _16_m21 _CoreIntensity
#define _16_m22 _PulseSpeed
#define _16_m23 _PulseAmount
#define _16_m24 _PixelSize
#define _16_m25 _FrameRate
#define _16_m26 _Steps



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _1531;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _1531 : SV_Target0;
};

static float4 _9;
static float4 _27;
static float _47;
static float _59;
static float _118;
static float2 _164;
static float4 _170;
static float3 _176;
static float4 _194;
static float2 _213;
static float4 _237;
static float4 _252;
static float3 _256;
static float _361;
static float _428;
static float2 _516;
static float2 _567;
static float4 _622;
static float2 _748;
static float _1091;
static float2 _1340;
static float3 _1397;
static float _1471;
static float _1562;
static float3 _1592;
static float3 _1622;

void frag_inner()
{
    float2 _24 = vs_TEXCOORD0 + (-_16_m7.xy);
    _9 = float4(_24.x, _24.y, _9.z, _9.w);
    float2 _36 = (-_16_m7.xy) + _16_m8.xy;
    _27 = float4(_36.x, _36.y, _27.z, _27.w);
    _27.z = -_27.x;
    _47 = dot(_9.xy, _27.yz);
    _9.x = dot(_9.xy, _27.xy);
    _59 = dot(_27.xy, _27.xy);
    _59 = max(_59, 9.9999997473787516355514526367188e-06f);
    _59 = 1.0f / _59;
    _27.y = _59 * _9.x;
    _9.x = _59 * _47;
    _27.x = _9.x * _16_m9;
    float2 _95 = _27.xy / _16_m24.xx;
    _9 = float4(_95.x, _95.y, _9.z, _9.w);
    float2 _100 = floor(_9.xy);
    _9 = float4(_100.x, _100.y, _9.z, _9.w);
    float2 _107 = _9.xy + 0.5f.xx;
    _9 = float4(_107.x, _107.y, _9.z, _9.w);
    float2 _115 = _9.yx * _16_m24.xx;
    _9 = float4(_115.x, _9.y, _115.y, _9.w);
    _118 = vs_TEXCOORD1 + _16_m0.y;
    _118 *= _16_m25;
    _118 = floor(_118);
    _9.w = _118 / _16_m25;
    float3 _151 = _9.zxw * float3(_16_m14, _16_m14, _16_m15);
    _27 = float4(_151.x, _151.y, _27.z, _151.z);
    _27.z = (_27.y * 0.449999988079071044921875f) + (-_27.w);
    _164.y = _9.w * 0.699999988079071044921875f;
    _170.y = 3.0f;
    _164.x = 1.2999999523162841796875f;
    float2 _183 = (_27.xz * 0.800000011920928955078125f.xx) + _164;
    _176 = float3(_183.x, _176.y, _183.y);
    _164 = floor(_176.xz);
    float2 _191 = frac(_176.xz);
    _176 = float3(_191.x, _176.y, _191.y);
    float2 _197 = _164 + 1.0f.xx;
    _194 = float4(_197.x, _197.y, _194.z, _194.w);
    float2 _205 = _194.xy * float2(123.339996337890625f, 456.209991455078125f);
    _194 = float4(_205.x, _205.y, _194.z, _194.w);
    float2 _210 = frac(_194.xy);
    _194 = float4(_210.x, _210.y, _194.z, _194.w);
    _213 = _194.xy + 45.31999969482421875f.xx;
    _213.x = dot(_194.xy, _213);
    float2 _228 = _213.xx + _194.xy;
    _194 = float4(_228.x, _228.y, _194.z, _194.w);
    _194.x = _194.y * _194.x;
    _237 = _164.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _256.x = dot(_237.zw, _252.zw);
    _213.x = dot(_237.xy, _252.xy);
    _213 = _213.xx + _237.xy;
    float2 _278 = _256.xx + _237.zw;
    _237 = float4(_278.x, _278.y, _237.z, _237.w);
    _194.y = _237.y * _237.x;
    _194.z = _213.y * _213.x;
    float3 _295 = frac(_194.xyz);
    _194 = float4(_295.x, _295.y, _295.z, _194.w);
    _194.x = (-_194.y) + _194.x;
    float2 _309 = _176.xz * _176.xz;
    _237 = float4(_309.x, _309.y, _237.z, _237.w);
    float2 _319 = ((-_176.xz) * 2.0f.xx) + 3.0f.xx;
    _176 = float3(_319.x, _176.y, _319.y);
    float2 _326 = _176.xz * _237.xy;
    _176 = float3(_326.x, _176.y, _326.y);
    _194.x = (_176.x * _194.x) + _194.y;
    float2 _339 = _164 + 45.31999969482421875f.xx;
    _256 = float3(_339.x, _256.y, _339.y);
    _256.x = dot(_164, _256.xz);
    _164 += _256.xx;
    _164.x = _164.y * _164.x;
    _164.x = frac(_164.x);
    _361 = (-_164.x) + _194.z;
    _176.x = (_176.x * _361) + _164.x;
    _164.x = (-_176.x) + _194.x;
    _176.x = (_176.z * _164.x) + _176.x;
    _176.x = (_176.x * 2.0f) + (-1.0f);
    _194 = (_176.xxxx * 0.5f.xxxx) + _27.xzxz;
    _27.x = _176.x * _16_m19;
    float2 _414 = floor(_194.zw);
    _176 = float3(_414.x, _414.y, _176.z);
    _164 = _176.xy + 1.0f.xx;
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    float2 _425 = _164 + 45.31999969482421875f.xx;
    _237 = float4(_425.x, _425.y, _237.z, _237.w);
    _428 = dot(_164, _237.xy);
    _164 = _428.xx + _164;
    _176.z = _164.y * _164.x;
    _237 = _176.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _448 = _176.xy * float2(123.339996337890625f, 456.209991455078125f);
    _176 = float3(_448.x, _448.y, _176.z);
    _176 = frac(_176);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _164.x = dot(_237.zw, _252.zw);
    _361 = dot(_237.xy, _252.xy);
    float2 _474 = _361.xx + _237.xy;
    _237 = float4(_474.x, _474.y, _237.z, _237.w);
    _164 = _164.xx + _237.zw;
    _164.x = _164.y * _164.x;
    _164.y = _237.y * _237.x;
    _164 = frac(_164);
    _428 = _176.z + (-_164.x);
    float2 _504 = frac(_194.zw);
    _237 = float4(_504.x, _504.y, _237.z, _237.w);
    _194 = (_194 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _516 = _237.xy * _237.xy;
    float2 _526 = ((-_237.xy) * 2.0f.xx) + 3.0f.xx;
    _237 = float4(_526.x, _526.y, _237.z, _237.w);
    float2 _532 = _237.xy * _516;
    _237 = float4(_532.x, _532.y, _237.z, _237.w);
    _428 = (_237.x * _428) + _164.x;
    _516 = _176.xy + 45.31999969482421875f.xx;
    _164.x = dot(_176.xy, _516);
    float2 _554 = _176.xy + _164.xx;
    _176 = float3(_554.x, _554.y, _176.z);
    _176.x = _176.y * _176.x;
    _176.x = frac(_176.x);
    _567.x = (-_176.x) + _164.y;
    _176.x = (_237.x * _567.x) + _176.x;
    _567.x = (-_176.x) + _428;
    _176.x = (_237.y * _567.x) + _176.x;
    _237 = frac(_194);
    _194 = floor(_194);
    _252 = _237 * _237;
    _237 = ((-_237) * 2.0f.xxxx) + 3.0f.xxxx;
    _237 *= _252;
    _252 = _194 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _252 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _567.x = dot(_252.xy, _622.xy);
    _428 = dot(_252.zw, _622.zw);
    _164 = _428.xx + _252.zw;
    _567 = _567.xx + _252.xy;
    _567.x = _567.y * _567.x;
    _567.y = _164.y * _164.x;
    _567 = frac(_567);
    _252 = _194.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _252 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _164.x = dot(_252.zw, _622.zw);
    _361 = dot(_252.xy, _622.xy);
    float2 _684 = _361.xx + _252.xy;
    _252 = float4(_684.x, _684.y, _252.z, _252.w);
    _164 = _164.xx + _252.zw;
    _164.x = _164.y * _164.x;
    _164.y = _252.y * _252.x;
    _164 = frac(_164);
    _567.x += (-_164.x);
    _567.x = (_237.x * _567.x) + _164.x;
    _252 = _194 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _194 = _194.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _194 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _194 = frac(_194);
    _252 = frac(_252);
    _622 = _252 + 45.31999969482421875f.xxxx;
    _164.x = dot(_252.xy, _622.xy);
    _622.x = dot(_252.zw, _622.zw);
    _748 = _252.zw + _622.xx;
    float2 _758 = _164.xx + _252.xy;
    _252 = float4(_758.x, _758.y, _252.z, _252.w);
    _164.x = _252.y * _252.x;
    _164.x = frac(_164.x);
    _252.x = _748.y * _748.x;
    _252.x = frac(_252.x);
    _361 = (-_164.x) + _164.y;
    _164.x = (_237.x * _361) + _164.x;
    _567.x += (-_164.x);
    _567.x = (_237.y * _567.x) + _164.x;
    _567.x *= 0.25f;
    _176.x = (_176.x * 0.5f) + _567.x;
    _622 = _194 + 45.31999969482421875f.xxxx;
    _567.x = dot(_194.zw, _622.zw);
    _164.x = dot(_194.xy, _622.xy);
    _164 = _164.xx + _194.xy;
    float2 _846 = _567.xx + _194.zw;
    _194 = float4(_846.x, _846.y, _194.z, _194.w);
    _567.x = _194.y * _194.x;
    _567.x = frac(_567.x);
    _164.x = _164.y * _164.x;
    _164.x = frac(_164.x);
    _567.x += (-_164.x);
    _567.x = (_237.z * _567.x) + _164.x;
    _428 = _567.y + (-_252.x);
    _428 = (_237.z * _428) + _252.x;
    _567.x = (-_428) + _567.x;
    _567.x = (_237.w * _567.x) + _428;
    _176.x = (_567.x * 0.125f) + _176.x;
    float3 _926 = _9.xxx * float3(1.5f, 2.22222232818603515625f, 2.5f);
    _194 = float4(_926.x, _926.y, _926.z, _194.w);
    _567.x = ((-_9.w) * _16_m18) + _194.z;
    _9.w *= _16_m22;
    _194 = float4(_194.xy.x, _194.xy.y, _194.z, _194.w);
    float2 _955 = clamp(_194.xy, 0.0f.xx, 1.0f.xx);
    _194 = float4(_955.x, _955.y, _194.z, _194.w);
    _170.x = floor(_567.x);
    _164 = _170.xy + 1.0f.xx;
    _164 *= float2(123.339996337890625f, 456.209991455078125f);
    _164 = frac(_164);
    _213 = _164 + 45.31999969482421875f.xx;
    _428 = dot(_164, _213);
    _164 = _428.xx + _164;
    _567.y = _164.y * _164.x;
    _567 = frac(_567);
    _237 = _170.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _991 = _170.xy * float2(123.339996337890625f, 456.209991455078125f);
    _170 = float4(_991.x, _991.y, _170.z, _170.w);
    _237 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _237 = frac(_237);
    _252 = _237 + 45.31999969482421875f.xxxx;
    _164.x = dot(_237.zw, _252.zw);
    _361 = dot(_237.xy, _252.xy);
    _213 = _361.xx + _237.xy;
    _164 = _164.xx + _237.zw;
    _170.z = _164.y * _164.x;
    _170.w = _213.y * _213.x;
    _170 = frac(_170);
    _428 = _567.y + (-_170.z);
    _213.x = _567.x * _567.x;
    _567.x = ((-_567.x) * 2.0f) + 3.0f;
    _567.x *= _213.x;
    _428 = (_567.x * _428) + _170.z;
    _213 = _170.xy + 45.31999969482421875f.xx;
    _164.x = dot(_170.xy, _213);
    float2 _1078 = _164.xx + _170.xy;
    _170 = float4(_1078.x, _1078.y, _170.z, _170.w);
    _170.x = _170.y * _170.x;
    _170.x = frac(_170.x);
    _1091 = (-_170.x) + _170.w;
    _567.x = (_567.x * _1091) + _170.x;
    _428 = (-_567.x) + _428;
    _567.x = (_428 * 0.78400003910064697265625f) + _567.x;
    _567.x = (_567.x * 2.0f) + (-1.0f);
    _567.x *= _16_m17;
    _47 = ((-_567.x) * _194.x) + _9.z;
    _47 = (_27.x * _9.x) + _47;
    _27.x = (_194.y * (-2.0f)) + 3.0f;
    _567.x = _194.y * _194.y;
    _27.x = _567.x * _27.x;
    _567.x = (-_16_m10) + _16_m11;
    _27.x = (_27.x * _567.x) + _16_m10;
    _567.x = (_9.y * _16_m24) + (-_16_m12);
    float2 _1202 = (_9.yy * _16_m24.xx) + float2(0.0199999995529651641845703125f, -0.20000000298023223876953125f);
    _170 = float4(_1202.x, _1202.y, _170.z, _170.w);
    float2 _1210 = _170.xy * float2(12.5f, 1.4285714626312255859375f);
    _170 = float4(_1210.x, _1210.y, _170.z, _170.w);
    float2 _1217 = clamp(_170.xy, 0.0f.xx, 1.0f.xx);
    _170 = float4(_1217.x, _1217.y, _170.z, _170.w);
    _164 = (-float2(float2(_16_m12, _16_m12))) + float2(1.0f, 1.0499999523162841796875f);
    _164 = 1.0f.xx / _164;
    _567 = _567.xx * _164;
    _567 = clamp(_567, 0.0f.xx, 1.0f.xx);
    _164 = (_567 * (-2.0f).xx) + 3.0f.xx;
    _567 *= _567;
    _59 = _567.x * _164.x;
    _567.x = ((-_164.y) * _567.y) + 1.0f;
    _59 = ((-_59) * 0.60000002384185791015625f) + 1.0f;
    _428 = _59 * _27.x;
    _164.x = (-_16_m13) + 1.0f;
    _361 = ((-_428) * _164.x) + abs(_47);
    _47 = abs(_47) * (-3.0f);
    _164.x = _428 * _164.x;
    _428 *= _16_m20;
    _428 = max(_428, 9.9999997473787516355514526367188e-05f);
    _47 /= _428;
    _47 = exp2(_47);
    _59 = (_27.x * _59) + (-_164.x);
    _59 = 1.0f / _59;
    _59 *= _361;
    _59 = clamp(_59, 0.0f, 1.0f);
    _27.x = (_59 * (-2.0f)) + 3.0f;
    _59 *= _59;
    _59 = ((-_27.x) * _59) + 1.0f;
    _27.x = _59 * _176.x;
    _1340 = (_176.xx * float2(0.628571450710296630859375f, 0.457142889499664306640625f)) + float2(0.449999988079071044921875f, 0.60000002384185791015625f);
    _59 = (_59 * 0.5f) + 0.5f;
    float2 _1355 = (_170.xy * (-2.0f).xx) + 3.0f.xx;
    _176 = float3(_1355.x, _176.y, _1355.y);
    float2 _1362 = _170.xy * _170.xy;
    _170 = float4(_1362.x, _1362.y, _170.z, _170.w);
    _176.x *= _170.x;
    _428 = ((-_176.z) * _170.y) + 1.0f;
    _176.x = _567.x * _176.x;
    _27.x = _176.x * _27.x;
    _47 *= _176.x;
    _47 = _428 * _47;
    _1397.x = _1340.y * _47;
    _1397.x = clamp(_1397.x, 0.0f, 1.0f);
    _1397.x = (_1397.x * _16_m26) + 0.5f;
    _1397.x = floor(_1397.x);
    _1397.x /= _16_m26;
    _47 = (_9.x * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _9.x = _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * (-0.550000011920928955078125f)) + 1.0f;
    _47 *= _16_m16;
    _47 = (_27.x * 1.8285715579986572265625f) + (-_47);
    _47 *= 2.857142925262451171875f;
    _47 = clamp(_47, 0.0f, 1.0f);
    _27.x = (_47 * (-2.0f)) + 3.0f;
    _47 *= _47;
    _47 *= _27.x;
    _1471 = log2(_47);
    _1471 *= _16_m6;
    _1471 = exp2(_1471);
    _9.x *= _1471;
    _9.x = _1340.x * _9.x;
    _9.x = _59 * _9.x;
    _1340.x = (_16_m4 * 2.0f) + 1.0f;
    _1340.x = _9.x * _1340.x;
    _1340.x = clamp(_1340.x, 0.0f, 1.0f);
    _1471 = _9.x * 4.0f;
    _1471 = clamp(_1471, 0.0f, 1.0f);
    _1471 = max(_1397.x, _1471);
    _1340.y = _1397.x * _16_m21;
    _1531.w = min(_1471, 1.0f);
    _1340.x = (_1340.x * _16_m26) + 0.5f;
    _1340.x = floor(_1340.x);
    _1340.x /= _16_m26;
    _1471 = _1340.x + (-0.3499999940395355224609375f);
    _1471 *= 2.2222220897674560546875f;
    _1471 = clamp(_1471, 0.0f, 1.0f);
    _1562 = (_1471 * (-2.0f)) + 3.0f;
    _1471 *= _1471;
    _1471 *= _1562;
    _1562 = _1340.x * 2.857142925262451171875f;
    _1340.x = (_1340.x * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _1340.x *= _16_m5;
    _1562 = _1562;
    _1562 = clamp(_1562, 0.0f, 1.0f);
    _1592.x = (_1562 * (-2.0f)) + 3.0f;
    _1562 *= _1562;
    _1562 *= _1592.x;
    _1592 = (-_16_m1.xyz) + _16_m2.xyz;
    _1592 = (_1562.xxx * _1592) + _16_m1.xyz;
    _1622 = (-_1592) + _16_m3.xyz;
    _1592 = (_1471.xxx * _1622) + _1592;
    _9.x = floor(_9.w);
    _9.y = 0.0f;
    float2 _1644 = _9.xy + float2(1.0f, 0.0f);
    _27 = float4(_1644.x, _1644.y, _27.z, _27.w);
    float2 _1649 = _9.xy * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_1649.x, _1649.y, _9.z, _9.w);
    float3 _1654 = frac(_9.xyw);
    _9 = float4(_1654.x, _1654.y, _1654.z, _9.w);
    float2 _1659 = _27.xy * float2(123.339996337890625f, 456.209991455078125f);
    _27 = float4(_1659.x, _1659.y, _27.z, _27.w);
    float2 _1664 = frac(_27.xy);
    _27 = float4(_1664.x, _1664.y, _27.z, _27.w);
    _118 = _27.x + 45.31999969482421875f;
    float2 _1677 = (_27.xx * _118.xx) + _27.xy;
    _27 = float4(_1677.x, _1677.y, _27.z, _27.w);
    _9.w = _27.y * _27.x;
    _27.x = _9.x + 45.31999969482421875f;
    float2 _1697 = (_9.xx * _27.xx) + _9.xy;
    _9 = float4(_1697.x, _1697.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    float2 _1708 = frac(_9.xw);
    _9 = float4(_1708.x, _9.y, _9.z, _1708.y);
    _59 = (-_9.x) + _9.w;
    _118 = _9.z * _9.z;
    _47 = ((-_9.z) * 2.0f) + 3.0f;
    _47 *= _118;
    _9.x = (_47 * _59) + _9.x;
    _1471 = (-_16_m23) + 1.0f;
    _9.x = (_16_m23 * _9.x) + _1471;
    _1340 = _9.xx * _1340;
    _1397 = _1340.yyy * _16_m3.xyz;
    float3 _1765 = (_1592 * _1340.xxx) + _1397;
    _1531 = float4(_1765.x, _1765.y, _1765.z, _1531.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1531 = _1531;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}