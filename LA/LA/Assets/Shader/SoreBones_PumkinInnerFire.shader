// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SoreBones/PumkinInnerFire" {
Properties {

_DeepColor ("Deep Color", Color) = (0.08,0.75,0.12,1)

_MidColor ("Mid Color", Color) = (0.55,1,0.45,1)

_HotColor ("Hot Color", Color) = (1,1,1,1)

_Intensity ("Intensity", Range(0, 4)) = 1.149999976158142

_HotBias ("Hot Bias", Range(0, 1)) = 0.44999998807907104

_FacingBoost ("Facing Boost", Range(0, 1)) = 0.5

[Header(Motion)] _Scale ("Scale (per meter)", Float) = 9.0

_Speed ("Rise Speed", Float) = 1.399999976158142

_WarpStrength ("Warp Strength", Range(0, 2)) = 0.699999988079071

_PulseSpeed ("Pulse Speed", Float) = 1.7999999523162842

_PulseAmount ("Pulse Amount", Range(0, 0.6)) = 0.15000000596046448

[Header(Pixelation)] _PixelSize ("Pixel Size", Range(0.002, 0.2)) = 0.014999999664723873

_FrameRate ("Frame Rate", Range(1, 60)) = 12.0

_Steps ("Color Steps", Range(2, 16)) = 5.0

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
static float vs_TEXCOORD3;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 _140;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _140 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _62;
static float _98;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    float3 _59 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _44.yyyy * _21_m3[1];
    _62 = (_21_m3[0] * _44.xxxx) + _62;
    _62 = (_21_m3[2] * _44.zzzz) + _62;
    _44 = (_21_m3[3] * _44.wwww) + _62;
    gl_Position = _44;
    _98 = _44.z / _21_m0.y;
    _98 = (-_98) + 1.0f;
    _98 *= _21_m0.z;
    _98 = max(_98, 0.0f);
    _98 *= _21_m4.y;
    vs_TEXCOORD3 = exp2(-_98);
    vs_TEXCOORD2 = dot(_9.xyz, float3(0.37000000476837158203125f, 0.20999999344348907470703125f, 0.2899999916553497314453125f));
    vs_TEXCOORD0 = _9.xyz;
    _9.x = dot(_140, _21_m2[0].xyz);
    _9.y = dot(_140, _21_m2[1].xyz);
    _9.z = dot(_140, _21_m2[2].xyz);
    _98 = dot(_9.xyz, _9.xyz);
    _98 = rsqrt(_98);
    vs_TEXCOORD1 = _98.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _DeepColor;
float4 _MidColor;
float4 _HotColor;
float _Intensity;
float _HotBias;
float _FacingBoost;
float _Scale;
float _Speed;
float _WarpStrength;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_FogColor
#define _17_m3 _DeepColor
#define _17_m4 _MidColor
#define _17_m5 _HotColor
#define _17_m6 _Intensity
#define _17_m7 _HotBias
#define _17_m8 _FacingBoost
#define _17_m9 _Scale
#define _17_m10 _Speed
#define _17_m11 _WarpStrength
#define _17_m12 _PulseSpeed
#define _17_m13 _PulseAmount
#define _17_m14 _PixelSize
#define _17_m15 _FrameRate
#define _17_m16 _Steps



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _2201;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _2201 : SV_Target0;
};

static float4 _9;
static float2 _38;
static float4 _68;
static float4 _88;
static float3 _123;
static float4 _134;
static float2 _140;
static float4 _153;
static float _160;
static float4 _191;
static float _195;
static float2 _348;
static float4 _388;
static float _397;
static float2 _492;
static float _635;
static float3 _707;
static float2 _761;
static float _1061;
static float _1341;
static float2 _1398;
static float3 _1820;
static float4 _1894;
static float _1990;
static float _1996;
static float3 _2020;
static float _2063;
static float _2081;
static float _2152;

void frag_inner()
{
    _9 = vs_TEXCOORD0.zyxy / _17_m14.xxxx;
    _9 = floor(_9);
    _9 += 0.5f.xxxx;
    _9 *= _17_m14.xxxx;
    _38.x = vs_TEXCOORD2 + _17_m0.y;
    _38.x *= _17_m15;
    _38.x = floor(_38.x);
    _38.x /= _17_m15;
    float2 _81 = (-_38.xx) * float2(float2(_17_m10, _17_m10));
    _68 = float4(_68.x, _81.x, _68.z, _81.y);
    _68.x = 0.0f;
    _68.z = 0.0f;
    _88 = (_9.xyxy * _17_m9.xxxx) + _68.zwzw;
    _9 = (_9.zwzw * _17_m9.xxxx) + _68;
    float2 _112 = _38.xx * float2(0.300000011920928955078125f, -0.25f);
    _68 = float4(_112.x, _112.y, _68.z, _68.w);
    _38.x *= _17_m12;
    float2 _131 = (_88.zw * 0.699999988079071044921875f.xx) + _68.xx;
    _123 = float3(_131.x, _131.y, _123.z);
    float2 _137 = floor(_123.xy);
    _134 = float4(_137.x, _137.y, _134.z, _134.w);
    _140 = _134.xy + 1.0f.xx;
    _140 *= float2(123.339996337890625f, 456.209991455078125f);
    _140 = frac(_140);
    float2 _157 = _140 + 45.31999969482421875f.xx;
    _153 = float4(_157.x, _157.y, _153.z, _153.w);
    _160 = dot(_140, _153.xy);
    _140 = _160.xx + _140;
    _123.z = _140.y * _140.x;
    _123 = frac(_123);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _183 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_183.x, _183.y, _134.z, _134.w);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _195 = dot(_153.zw, _191.zw);
    _140.x = dot(_153.xy, _191.xy);
    _140 = _140.xx + _153.xy;
    float2 _216 = _195.xx + _153.zw;
    _153 = float4(_216.x, _216.y, _153.z, _153.w);
    _195 = _153.y * _153.x;
    _195 = frac(_195);
    _134.z = _140.y * _140.x;
    float3 _234 = frac(_134.xyz);
    _134 = float4(_234.x, _234.y, _234.z, _134.w);
    _160 = _123.z + (-_195);
    float2 _246 = _123.xy * _123.xy;
    _153 = float4(_246.x, _246.y, _153.z, _153.w);
    float2 _257 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_257.x, _257.y, _123.z);
    float2 _264 = _123.xy * _153.xy;
    _123 = float3(_264.x, _264.y, _123.z);
    _160 = (_123.x * _160) + _195;
    float2 _275 = _134.xy + 45.31999969482421875f.xx;
    _153 = float4(_275.x, _275.y, _153.z, _153.w);
    _195 = dot(_134.xy, _153.xy);
    float2 _287 = _195.xx + _134.xy;
    _134 = float4(_287.x, _287.y, _134.z, _134.w);
    _195 = _134.y * _134.x;
    _195 = frac(_195);
    _134.x = (-_195) + _134.z;
    _123.x = (_123.x * _134.x) + _195;
    _160 = (-_123.x) + _160;
    float2 _323 = (_123.yy * _160.xx) + _123.xx;
    _134 = float4(_323.x, _134.y, _323.y, _134.w);
    _68.z = 5.19999980926513671875f;
    float2 _333 = (_88.zw * 0.699999988079071044921875f.xx) + _68.zy;
    _123 = float3(_333.x, _333.y, _123.z);
    _68 = (_9.zwzw * 0.699999988079071044921875f.xxxx) + _68.xxzy;
    float2 _345 = floor(_123.xy);
    _153 = float4(_345.x, _345.y, _153.z, _153.w);
    _348 = _153.xy + 1.0f.xx;
    _348 *= float2(123.339996337890625f, 456.209991455078125f);
    _348 = frac(_348);
    float2 _357 = _348 + 45.31999969482421875f.xx;
    _191 = float4(_357.x, _357.y, _191.z, _191.w);
    _160 = dot(_348, _191.xy);
    _348 = _160.xx + _348;
    _123.z = _348.y * _348.x;
    _123 = frac(_123);
    _191 = _153.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _381 = _153.xy * float2(123.339996337890625f, 456.209991455078125f);
    _153 = float4(_381.x, _381.y, _153.z, _153.w);
    _191 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _348.x = dot(_191.zw, _388.zw);
    _397 = dot(_191.xy, _388.xy);
    float2 _407 = _397.xx + _191.xy;
    _191 = float4(_407.x, _407.y, _191.z, _191.w);
    _348 = _348.xx + _191.zw;
    _153.z = _348.y * _348.x;
    _153.w = _191.y * _191.x;
    _153 = frac(_153);
    _160 = _123.z + (-_153.z);
    float2 _440 = _123.xy * _123.xy;
    _191 = float4(_440.x, _440.y, _191.z, _191.w);
    float2 _447 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_447.x, _447.y, _123.z);
    float2 _454 = _123.xy * _191.xy;
    _123 = float3(_454.x, _454.y, _123.z);
    _160 = (_123.x * _160) + _153.z;
    float2 _466 = _153.xy + 45.31999969482421875f.xx;
    _191 = float4(_466.x, _466.y, _191.z, _191.w);
    _348.x = dot(_153.xy, _191.xy);
    float2 _479 = _348.xx + _153.xy;
    _153 = float4(_479.x, _479.y, _153.z, _153.w);
    _153.x = _153.y * _153.x;
    _153.x = frac(_153.x);
    _492.x = (-_153.x) + _153.w;
    _123.x = (_123.x * _492.x) + _153.x;
    _160 = (-_123.x) + _160;
    float2 _521 = (_123.yy * _160.xx) + _123.xx;
    _134 = float4(_134.x, _521.x, _134.z, _521.y);
    _134 = (_134 * 2.0f.xxxx) + (-1.0f).xxxx;
    _88 = (_134 * float4(float4(_17_m11, _17_m11, _17_m11, _17_m11))) + _88;
    float2 _551 = frac(_88.zw);
    _123 = float3(_551.x, _551.y, _123.z);
    float2 _558 = _123.xy * _123.xy;
    _134 = float4(_558.x, _558.y, _134.z, _134.w);
    float2 _565 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_565.x, _565.y, _123.z);
    float2 _572 = _123.xy * _134.xy;
    _123 = float3(_572.x, _572.y, _123.z);
    float2 _577 = floor(_88.zw);
    _134 = float4(_577.x, _577.y, _134.z, _134.w);
    _88 = (_88 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _140 = _134.xy + 1.0f.xx;
    _140 *= float2(123.339996337890625f, 456.209991455078125f);
    _140 = frac(_140);
    float2 _597 = _140 + 45.31999969482421875f.xx;
    _153 = float4(_597.x, _597.y, _153.z, _153.w);
    _160 = dot(_140, _153.xy);
    _140 = _160.xx + _140;
    _160 = _140.y * _140.x;
    _160 = frac(_160);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _620 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_620.x, _620.y, _134.z, _134.w);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _140.x = dot(_153.zw, _191.zw);
    _635 = dot(_153.xy, _191.xy);
    float2 _645 = _635.xx + _153.xy;
    _153 = float4(_645.x, _645.y, _153.z, _153.w);
    _140 = _140.xx + _153.zw;
    _134.z = _140.y * _140.x;
    _134.w = _153.y * _153.x;
    _134 = frac(_134);
    _160 += (-_134.z);
    _160 = (_123.x * _160) + _134.z;
    float2 _681 = _134.xy + 45.31999969482421875f.xx;
    _153 = float4(_681.x, _681.y, _153.z, _153.w);
    _140.x = dot(_134.xy, _153.xy);
    float2 _694 = _140.xx + _134.xy;
    _134 = float4(_694.x, _694.y, _134.z, _134.w);
    _134.x = _134.y * _134.x;
    _134.x = frac(_134.x);
    _707.x = (-_134.x) + _134.w;
    _123.x = (_123.x * _707.x) + _134.x;
    _160 = (-_123.x) + _160;
    _123.x = (_123.y * _160) + _123.x;
    _134 = frac(_88);
    _88 = floor(_88);
    _153 = _134 * _134;
    _134 = ((-_134) * 2.0f.xxxx) + 3.0f.xxxx;
    _134 *= _153;
    _153 = _88.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _761.x = dot(_153.zw, _191.zw);
    _160 = dot(_153.xy, _191.xy);
    float2 _777 = _160.xx + _153.xy;
    _153 = float4(_777.x, _777.y, _153.z, _153.w);
    _761 = _761.xx + _153.zw;
    _761.x = _761.y * _761.x;
    _761.y = _153.y * _153.x;
    _761 = frac(_761);
    _153 = _88 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _191.x = dot(_153.xy, _191.xy);
    _191.y = dot(_153.zw, _191.zw);
    _153 += _191.xxyy;
    _153.x = _153.y * _153.x;
    _153.x = frac(_153.x);
    _153.x = (-_761.x) + _153.x;
    _761.x = (_134.x * _153.x) + _761.x;
    _153.x = _153.w * _153.z;
    _191 = _88 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _88 = _88.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _88 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _88 = frac(_88);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _492.x = dot(_191.xy, _388.xy);
    _348.x = dot(_191.zw, _388.zw);
    _348 = _348.xx + _191.zw;
    float2 _891 = _492.xx + _191.xy;
    _191 = float4(_891.x, _891.y, _191.z, _191.w);
    _153.y = _191.y * _191.x;
    _153.z = _348.y * _348.x;
    float3 _908 = frac(_153.xyz);
    _153 = float4(_908.x, _908.y, _908.z, _153.w);
    _160 = _761.y + (-_153.y);
    _160 = (_134.x * _160) + _153.y;
    _761.x = (-_160) + _761.x;
    _761.x = (_134.y * _761.x) + _160;
    _761.x *= 0.25f;
    _123.x = (_123.x * 0.5f) + _761.x;
    _191 = _88 + 45.31999969482421875f.xxxx;
    _761.x = dot(_88.zw, _191.zw);
    _160 = dot(_88.xy, _191.xy);
    float2 _967 = _160.xx + _88.xy;
    _88 = float4(_967.x, _967.y, _88.z, _88.w);
    _761 = _761.xx + _88.zw;
    _761.x = _761.y * _761.x;
    _761.y = _88.y * _88.x;
    _761 = frac(_761);
    _761.x = (-_761.y) + _761.x;
    _761.x = (_134.z * _761.x) + _761.y;
    _160 = (-_153.z) + _153.x;
    _160 = (_134.z * _160) + _153.z;
    _761.x = (-_160) + _761.x;
    _761.x = (_134.w * _761.x) + _160;
    _123.x = (_761.x * 0.125f) + _123.x;
    _761.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _761.x = rsqrt(_761.x);
    float3 _1052 = _761.xxx * vs_TEXCOORD1;
    _88 = float4(_1052.x, _1052.y, _1052.z, _88.w);
    _761 = abs(_88.xz) + 0.001000000047497451305389404296875f.xx;
    _1061 = _761.y + _761.x;
    _761 /= _1061.xx;
    _123.x = _761.x * _123.x;
    _134 = floor(_68);
    _68 = frac(_68);
    _153 = _134 + 1.0f.xxxx;
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _761.x = dot(_153.xy, _191.xy);
    _1061 = dot(_153.zw, _191.zw);
    _348 = _1061.xx + _153.zw;
    float2 _1110 = _761.xx + _153.xy;
    _153 = float4(_1110.x, _1110.y, _153.z, _153.w);
    _761.x = _153.y * _153.x;
    _761.x = frac(_761.x);
    _1061 = _348.y * _348.x;
    _1061 = frac(_1061);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _191.z = dot(_153.zw, _191.zw);
    _191.x = dot(_153.xy, _191.xy);
    _153 += _191.xxzz;
    float2 _1159 = _153.yw * _153.xz;
    _153 = float4(_1159.x, _153.y, _1159.y, _153.w);
    float2 _1164 = frac(_153.xz);
    _153 = float4(_1164.x, _153.y, _1164.y, _153.w);
    _761.x += (-_153.z);
    _191 = _68 * _68;
    _68 = ((-_68) * 2.0f.xxxx) + 3.0f.xxxx;
    _68 *= _191;
    _761.x = (_68.x * _761.x) + _153.z;
    _191 = _134 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = _134.zwzw + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _492.x = dot(_191.xy, _388.xy);
    _348.x = dot(_191.zw, _388.zw);
    _348 = _348.xx + _191.zw;
    float2 _1227 = _492.xx + _191.xy;
    _191 = float4(_1227.x, _1227.y, _191.z, _191.w);
    _492.x = _191.y * _191.x;
    _492.y = _348.y * _348.x;
    _492 = frac(_492);
    _153.x = (-_492.x) + _153.x;
    _68.x = (_68.x * _153.x) + _492.x;
    _761.x += (-_68.x);
    float2 _1274 = (_68.yy * _761.xx) + _68.xx;
    _191 = float4(_1274.x, _191.y, _1274.y, _191.w);
    _388 = _134 + 45.31999969482421875f.xxxx;
    _761.x = dot(_134.zw, _388.zw);
    _68.x = dot(_134.xy, _388.xy);
    float2 _1295 = _68.xx + _134.xy;
    _68 = float4(_1295.x, _1295.y, _68.z, _68.w);
    float2 _1302 = _761.xx + _134.zw;
    _134 = float4(_1302.x, _1302.y, _134.z, _134.w);
    _761.x = _134.y * _134.x;
    _761.x = frac(_761.x);
    _68.x = _68.y * _68.x;
    _68.x = frac(_68.x);
    _68.x = (-_492.y) + _68.x;
    _68.x = (_68.z * _68.x) + _492.y;
    _1341 = (-_761.x) + _1061;
    _761.x = (_68.z * _1341) + _761.x;
    _761.x = (-_68.x) + _761.x;
    float2 _1369 = (_68.ww * _761.xx) + _68.xx;
    _191 = float4(_191.x, _1369.x, _191.z, _1369.y);
    _68 = (_191 * 2.0f.xxxx) + (-1.0f).xxxx;
    _9 = (_68 * float4(float4(_17_m11, _17_m11, _17_m11, _17_m11))) + _9;
    float2 _1395 = frac(_9.zw);
    _68 = float4(_1395.x, _1395.y, _68.z, _68.w);
    _1398 = _68.xy * _68.xy;
    float2 _1408 = ((-_68.xy) * 2.0f.xx) + 3.0f.xx;
    _68 = float4(_1408.x, _1408.y, _68.z, _68.w);
    float2 _1414 = _68.xy * _1398;
    _68 = float4(_1414.x, _1414.y, _68.z, _68.w);
    _1398 = floor(_9.zw);
    _9 = (_9 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    float2 _1424 = _1398 + 1.0f.xx;
    _134 = float4(_1424.x, _1424.y, _134.z, _134.w);
    float2 _1429 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_1429.x, _1429.y, _134.z, _134.w);
    float2 _1434 = frac(_134.xy);
    _134 = float4(_1434.x, _1434.y, _134.z, _134.w);
    _140 = _134.xy + 45.31999969482421875f.xx;
    _761.x = dot(_134.xy, _140);
    float2 _1449 = _761.xx + _134.xy;
    _134 = float4(_1449.x, _1449.y, _134.z, _134.w);
    _761.x = _134.y * _134.x;
    _761.x = frac(_761.x);
    _134 = _1398.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _1398 *= float2(123.339996337890625f, 456.209991455078125f);
    _1398 = frac(_1398);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _153 = _134 + 45.31999969482421875f.xxxx;
    _1061 = dot(_134.zw, _153.zw);
    _153.x = dot(_134.xy, _153.xy);
    float2 _1490 = _134.xy + _153.xx;
    _134 = float4(_1490.x, _1490.y, _134.z, _134.w);
    _140 = _1061.xx + _134.zw;
    _1061 = _140.y * _140.x;
    _1061 = frac(_1061);
    _134.x = _134.y * _134.x;
    _134.x = frac(_134.x);
    _761.x += (-_1061);
    _761.x = (_68.x * _761.x) + _1061;
    float2 _1530 = _1398 + 45.31999969482421875f.xx;
    _707 = float3(_1530.x, _1530.y, _707.z);
    _1061 = dot(_1398, _707.xy);
    _1398 += _1061.xx;
    _1398.x = _1398.y * _1398.x;
    _1398.x = frac(_1398.x);
    _195 = (-_1398.x) + _134.x;
    _68.x = (_68.x * _195) + _1398.x;
    _761.x += (-_68.x);
    _761.x = (_68.y * _761.x) + _68.x;
    _68 = frac(_9);
    _9 = floor(_9);
    _134 = _68 * _68;
    _68 = ((-_68) * 2.0f.xxxx) + 3.0f.xxxx;
    _68 *= _134;
    _134 = _9.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _153 = _134 + 45.31999969482421875f.xxxx;
    _1061 = dot(_134.zw, _153.zw);
    _153.x = dot(_134.xy, _153.xy);
    float2 _1619 = _134.xy + _153.xx;
    _134 = float4(_1619.x, _1619.y, _134.z, _134.w);
    _140 = _1061.xx + _134.zw;
    _1061 = _140.y * _140.x;
    _1061 = frac(_1061);
    _134.x = _134.y * _134.x;
    _153 = _9 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _707.x = dot(_153.xy, _191.xy);
    _140.x = dot(_153.zw, _191.zw);
    _140 = _140.xx + _153.zw;
    float2 _1669 = _707.xx + _153.xy;
    _153 = float4(_1669.x, _1669.y, _153.z, _153.w);
    _134.y = _153.y * _153.x;
    float2 _1680 = frac(_134.xy);
    _134 = float4(_1680.x, _1680.y, _134.z, _134.w);
    _707.x = (-_1061) + _134.y;
    _1061 = (_68.x * _707.x) + _1061;
    _707.x = _140.y * _140.x;
    _153 = _9 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _9 = _9.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _9 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _9 = frac(_9);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _140.x = dot(_153.xy, _191.xy);
    _635 = dot(_153.zw, _191.zw);
    _348 = _635.xx + _153.zw;
    _140 = _140.xx + _153.xy;
    _707.y = _140.y * _140.x;
    _707.z = _348.y * _348.x;
    _707 = frac(_707);
    _134.x = (-_707.y) + _134.x;
    _68.x = (_68.x * _134.x) + _707.y;
    _1061 = (-_68.x) + _1061;
    _68.x = (_68.y * _1061) + _68.x;
    _68.x *= 0.25f;
    _761.x = (_761.x * 0.5f) + _68.x;
    _153 = _9 + 45.31999969482421875f.xxxx;
    _68.x = dot(_9.zw, _153.zw);
    _68.y = dot(_9.xy, _153.xy);
    _9 += _68.yyxx;
    float2 _1812 = _9.yw * _9.xz;
    _9 = float4(_1812.x, _9.y, _1812.y, _9.w);
    float2 _1817 = frac(_9.xz);
    _9 = float4(_1817.x, _9.y, _1817.y, _9.w);
    _1820.x = (-_9.x) + _9.z;
    _9.x = (_68.z * _1820.x) + _9.x;
    _1820.x = (-_707.z) + _707.x;
    _1820.x = (_68.z * _1820.x) + _707.z;
    _9.x = (-_1820.x) + _9.x;
    _9.x = (_68.w * _9.x) + _1820.x;
    _9.x = (_9.x * 0.125f) + _761.x;
    _9.x = _761.y * _9.x;
    _9.x *= 1.14285719394683837890625f;
    _9.x = (_123.x * 1.14285719394683837890625f) + _9.x;
    _1894.x = _17_m7 + 1.0f;
    _9.x = (_9.x * _1894.x) + (-0.25f);
    _1820 = (-vs_TEXCOORD0) + _17_m1;
    _123.x = dot(_1820, _1820);
    _123.x = rsqrt(_123.x);
    _1820 *= _123.xxx;
    _1820.x = dot(_88.xyz, _1820);
    _1820.x = clamp(_1820.x, 0.0f, 1.0f);
    _1894.x = _1820.x * _17_m8;
    _9.x = (_1894.x * 0.5f) + _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1894.x = (_9.x * _17_m16) + 0.5f;
    _1894.x = floor(_1894.x);
    _1894.x /= _17_m16;
    _1894.y = _1894.x + (-0.449999988079071044921875f);
    float2 _1980 = _1894.xy * 2.22222232818603515625f.xx;
    _1894 = float4(_1980.x, _1980.y, _1894.z, _1894.w);
    float2 _1987 = clamp(_1894.xy, 0.0f.xx, 1.0f.xx);
    _1894 = float4(_1987.x, _1987.y, _1894.z, _1894.w);
    _1990 = (_1894.y * (-2.0f)) + 3.0f;
    _1996 = _1894.y * _1894.y;
    _1996 *= _1990;
    _1990 = (_1894.x * (-2.0f)) + 3.0f;
    _1894.x *= _1894.x;
    _1894.x *= _1990;
    _2020 = (-_17_m3.xyz) + _17_m4.xyz;
    float3 _2039 = (_1894.xxx * _2020) + _17_m3.xyz;
    _1894 = float4(_2039.x, _1894.y, _2039.y, _2039.z);
    _2020 = (-_1894.xzw) + _17_m5.xyz;
    float3 _2056 = (_1996.xxx * _2020) + _1894.xzw;
    _1894 = float4(_2056.x, _2056.y, _2056.z, _1894.w);
    _9.x = floor(_38.x);
    _2063 = frac(_38.x);
    _9.y = 0.0f;
    _38 = _9.xy + float2(1.0f, 0.0f);
    float2 _2074 = _9.xy * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_2074.x, _2074.y, _9.z, _9.w);
    _38 *= float2(123.339996337890625f, 456.209991455078125f);
    _38 = frac(_38);
    _2081 = _38.x + 45.31999969482421875f;
    _38 = (_38.xx * _2081.xx) + _38;
    _9.w = _38.y * _38.x;
    float3 _2100 = frac(_9.xyw);
    _9 = float4(_2100.x, _2100.y, _9.z, _2100.z);
    _38.x = _9.x + 45.31999969482421875f;
    float2 _2114 = (_9.xx * _38.xx) + _9.xy;
    _9 = float4(_2114.x, _2114.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1820.x = (-_9.x) + _9.w;
    _2081 = _2063 * _2063;
    _2063 = ((-_2063) * 2.0f) + 3.0f;
    _2063 *= _2081;
    _9.x = (_2063 * _1820.x) + _9.x;
    _2152 = (-_17_m13) + 1.0f;
    _9.x = (_17_m13 * _9.x) + _2152;
    _2152 = _9.x * _17_m6;
    float3 _2182 = (_1894.xyz * _2152.xxx) + (-_17_m2.xyz);
    _9 = float4(_2182.x, _2182.y, _2182.z, _9.w);
    _2081 = vs_TEXCOORD3;
    _2081 = clamp(_2081, 0.0f, 1.0f);
    float3 _2197 = (_2081.xxx * _9.xyz) + _17_m2.xyz;
    _9 = float4(_2197.x, _2197.y, _2197.z, _9.w);
    _2201 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _2201.w);
    _2201.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2201 = _2201;
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
static float vs_TEXCOORD3;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 _144;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _144 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _62;
static float _98;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    float3 _59 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _44.yyyy * _21_m3[1];
    _62 = (_21_m3[0] * _44.xxxx) + _62;
    _62 = (_21_m3[2] * _44.zzzz) + _62;
    _44 = (_21_m3[3] * _44.wwww) + _62;
    gl_Position = _44;
    _98 = _44.z / _21_m0.y;
    _98 = (-_98) + 1.0f;
    _98 *= _21_m0.z;
    _98 = max(_98, 0.0f);
    _98 *= _21_m4.x;
    _98 *= (-_98);
    vs_TEXCOORD3 = exp2(_98);
    vs_TEXCOORD2 = dot(_9.xyz, float3(0.37000000476837158203125f, 0.20999999344348907470703125f, 0.2899999916553497314453125f));
    vs_TEXCOORD0 = _9.xyz;
    _9.x = dot(_144, _21_m2[0].xyz);
    _9.y = dot(_144, _21_m2[1].xyz);
    _9.z = dot(_144, _21_m2[2].xyz);
    _98 = dot(_9.xyz, _9.xyz);
    _98 = rsqrt(_98);
    vs_TEXCOORD1 = _98.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _144 = stage_input._144;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _DeepColor;
float4 _MidColor;
float4 _HotColor;
float _Intensity;
float _HotBias;
float _FacingBoost;
float _Scale;
float _Speed;
float _WarpStrength;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_FogColor
#define _17_m3 _DeepColor
#define _17_m4 _MidColor
#define _17_m5 _HotColor
#define _17_m6 _Intensity
#define _17_m7 _HotBias
#define _17_m8 _FacingBoost
#define _17_m9 _Scale
#define _17_m10 _Speed
#define _17_m11 _WarpStrength
#define _17_m12 _PulseSpeed
#define _17_m13 _PulseAmount
#define _17_m14 _PixelSize
#define _17_m15 _FrameRate
#define _17_m16 _Steps



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _2201;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _2201 : SV_Target0;
};

static float4 _9;
static float2 _38;
static float4 _68;
static float4 _88;
static float3 _123;
static float4 _134;
static float2 _140;
static float4 _153;
static float _160;
static float4 _191;
static float _195;
static float2 _348;
static float4 _388;
static float _397;
static float2 _492;
static float _635;
static float3 _707;
static float2 _761;
static float _1061;
static float _1341;
static float2 _1398;
static float3 _1820;
static float4 _1894;
static float _1990;
static float _1996;
static float3 _2020;
static float _2063;
static float _2081;
static float _2152;

void frag_inner()
{
    _9 = vs_TEXCOORD0.zyxy / _17_m14.xxxx;
    _9 = floor(_9);
    _9 += 0.5f.xxxx;
    _9 *= _17_m14.xxxx;
    _38.x = vs_TEXCOORD2 + _17_m0.y;
    _38.x *= _17_m15;
    _38.x = floor(_38.x);
    _38.x /= _17_m15;
    float2 _81 = (-_38.xx) * float2(float2(_17_m10, _17_m10));
    _68 = float4(_68.x, _81.x, _68.z, _81.y);
    _68.x = 0.0f;
    _68.z = 0.0f;
    _88 = (_9.xyxy * _17_m9.xxxx) + _68.zwzw;
    _9 = (_9.zwzw * _17_m9.xxxx) + _68;
    float2 _112 = _38.xx * float2(0.300000011920928955078125f, -0.25f);
    _68 = float4(_112.x, _112.y, _68.z, _68.w);
    _38.x *= _17_m12;
    float2 _131 = (_88.zw * 0.699999988079071044921875f.xx) + _68.xx;
    _123 = float3(_131.x, _131.y, _123.z);
    float2 _137 = floor(_123.xy);
    _134 = float4(_137.x, _137.y, _134.z, _134.w);
    _140 = _134.xy + 1.0f.xx;
    _140 *= float2(123.339996337890625f, 456.209991455078125f);
    _140 = frac(_140);
    float2 _157 = _140 + 45.31999969482421875f.xx;
    _153 = float4(_157.x, _157.y, _153.z, _153.w);
    _160 = dot(_140, _153.xy);
    _140 = _160.xx + _140;
    _123.z = _140.y * _140.x;
    _123 = frac(_123);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _183 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_183.x, _183.y, _134.z, _134.w);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _195 = dot(_153.zw, _191.zw);
    _140.x = dot(_153.xy, _191.xy);
    _140 = _140.xx + _153.xy;
    float2 _216 = _195.xx + _153.zw;
    _153 = float4(_216.x, _216.y, _153.z, _153.w);
    _195 = _153.y * _153.x;
    _195 = frac(_195);
    _134.z = _140.y * _140.x;
    float3 _234 = frac(_134.xyz);
    _134 = float4(_234.x, _234.y, _234.z, _134.w);
    _160 = _123.z + (-_195);
    float2 _246 = _123.xy * _123.xy;
    _153 = float4(_246.x, _246.y, _153.z, _153.w);
    float2 _257 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_257.x, _257.y, _123.z);
    float2 _264 = _123.xy * _153.xy;
    _123 = float3(_264.x, _264.y, _123.z);
    _160 = (_123.x * _160) + _195;
    float2 _275 = _134.xy + 45.31999969482421875f.xx;
    _153 = float4(_275.x, _275.y, _153.z, _153.w);
    _195 = dot(_134.xy, _153.xy);
    float2 _287 = _195.xx + _134.xy;
    _134 = float4(_287.x, _287.y, _134.z, _134.w);
    _195 = _134.y * _134.x;
    _195 = frac(_195);
    _134.x = (-_195) + _134.z;
    _123.x = (_123.x * _134.x) + _195;
    _160 = (-_123.x) + _160;
    float2 _323 = (_123.yy * _160.xx) + _123.xx;
    _134 = float4(_323.x, _134.y, _323.y, _134.w);
    _68.z = 5.19999980926513671875f;
    float2 _333 = (_88.zw * 0.699999988079071044921875f.xx) + _68.zy;
    _123 = float3(_333.x, _333.y, _123.z);
    _68 = (_9.zwzw * 0.699999988079071044921875f.xxxx) + _68.xxzy;
    float2 _345 = floor(_123.xy);
    _153 = float4(_345.x, _345.y, _153.z, _153.w);
    _348 = _153.xy + 1.0f.xx;
    _348 *= float2(123.339996337890625f, 456.209991455078125f);
    _348 = frac(_348);
    float2 _357 = _348 + 45.31999969482421875f.xx;
    _191 = float4(_357.x, _357.y, _191.z, _191.w);
    _160 = dot(_348, _191.xy);
    _348 = _160.xx + _348;
    _123.z = _348.y * _348.x;
    _123 = frac(_123);
    _191 = _153.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _381 = _153.xy * float2(123.339996337890625f, 456.209991455078125f);
    _153 = float4(_381.x, _381.y, _153.z, _153.w);
    _191 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _348.x = dot(_191.zw, _388.zw);
    _397 = dot(_191.xy, _388.xy);
    float2 _407 = _397.xx + _191.xy;
    _191 = float4(_407.x, _407.y, _191.z, _191.w);
    _348 = _348.xx + _191.zw;
    _153.z = _348.y * _348.x;
    _153.w = _191.y * _191.x;
    _153 = frac(_153);
    _160 = _123.z + (-_153.z);
    float2 _440 = _123.xy * _123.xy;
    _191 = float4(_440.x, _440.y, _191.z, _191.w);
    float2 _447 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_447.x, _447.y, _123.z);
    float2 _454 = _123.xy * _191.xy;
    _123 = float3(_454.x, _454.y, _123.z);
    _160 = (_123.x * _160) + _153.z;
    float2 _466 = _153.xy + 45.31999969482421875f.xx;
    _191 = float4(_466.x, _466.y, _191.z, _191.w);
    _348.x = dot(_153.xy, _191.xy);
    float2 _479 = _348.xx + _153.xy;
    _153 = float4(_479.x, _479.y, _153.z, _153.w);
    _153.x = _153.y * _153.x;
    _153.x = frac(_153.x);
    _492.x = (-_153.x) + _153.w;
    _123.x = (_123.x * _492.x) + _153.x;
    _160 = (-_123.x) + _160;
    float2 _521 = (_123.yy * _160.xx) + _123.xx;
    _134 = float4(_134.x, _521.x, _134.z, _521.y);
    _134 = (_134 * 2.0f.xxxx) + (-1.0f).xxxx;
    _88 = (_134 * float4(float4(_17_m11, _17_m11, _17_m11, _17_m11))) + _88;
    float2 _551 = frac(_88.zw);
    _123 = float3(_551.x, _551.y, _123.z);
    float2 _558 = _123.xy * _123.xy;
    _134 = float4(_558.x, _558.y, _134.z, _134.w);
    float2 _565 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_565.x, _565.y, _123.z);
    float2 _572 = _123.xy * _134.xy;
    _123 = float3(_572.x, _572.y, _123.z);
    float2 _577 = floor(_88.zw);
    _134 = float4(_577.x, _577.y, _134.z, _134.w);
    _88 = (_88 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _140 = _134.xy + 1.0f.xx;
    _140 *= float2(123.339996337890625f, 456.209991455078125f);
    _140 = frac(_140);
    float2 _597 = _140 + 45.31999969482421875f.xx;
    _153 = float4(_597.x, _597.y, _153.z, _153.w);
    _160 = dot(_140, _153.xy);
    _140 = _160.xx + _140;
    _160 = _140.y * _140.x;
    _160 = frac(_160);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _620 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_620.x, _620.y, _134.z, _134.w);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _140.x = dot(_153.zw, _191.zw);
    _635 = dot(_153.xy, _191.xy);
    float2 _645 = _635.xx + _153.xy;
    _153 = float4(_645.x, _645.y, _153.z, _153.w);
    _140 = _140.xx + _153.zw;
    _134.z = _140.y * _140.x;
    _134.w = _153.y * _153.x;
    _134 = frac(_134);
    _160 += (-_134.z);
    _160 = (_123.x * _160) + _134.z;
    float2 _681 = _134.xy + 45.31999969482421875f.xx;
    _153 = float4(_681.x, _681.y, _153.z, _153.w);
    _140.x = dot(_134.xy, _153.xy);
    float2 _694 = _140.xx + _134.xy;
    _134 = float4(_694.x, _694.y, _134.z, _134.w);
    _134.x = _134.y * _134.x;
    _134.x = frac(_134.x);
    _707.x = (-_134.x) + _134.w;
    _123.x = (_123.x * _707.x) + _134.x;
    _160 = (-_123.x) + _160;
    _123.x = (_123.y * _160) + _123.x;
    _134 = frac(_88);
    _88 = floor(_88);
    _153 = _134 * _134;
    _134 = ((-_134) * 2.0f.xxxx) + 3.0f.xxxx;
    _134 *= _153;
    _153 = _88.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _761.x = dot(_153.zw, _191.zw);
    _160 = dot(_153.xy, _191.xy);
    float2 _777 = _160.xx + _153.xy;
    _153 = float4(_777.x, _777.y, _153.z, _153.w);
    _761 = _761.xx + _153.zw;
    _761.x = _761.y * _761.x;
    _761.y = _153.y * _153.x;
    _761 = frac(_761);
    _153 = _88 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _191.x = dot(_153.xy, _191.xy);
    _191.y = dot(_153.zw, _191.zw);
    _153 += _191.xxyy;
    _153.x = _153.y * _153.x;
    _153.x = frac(_153.x);
    _153.x = (-_761.x) + _153.x;
    _761.x = (_134.x * _153.x) + _761.x;
    _153.x = _153.w * _153.z;
    _191 = _88 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _88 = _88.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _88 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _88 = frac(_88);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _492.x = dot(_191.xy, _388.xy);
    _348.x = dot(_191.zw, _388.zw);
    _348 = _348.xx + _191.zw;
    float2 _891 = _492.xx + _191.xy;
    _191 = float4(_891.x, _891.y, _191.z, _191.w);
    _153.y = _191.y * _191.x;
    _153.z = _348.y * _348.x;
    float3 _908 = frac(_153.xyz);
    _153 = float4(_908.x, _908.y, _908.z, _153.w);
    _160 = _761.y + (-_153.y);
    _160 = (_134.x * _160) + _153.y;
    _761.x = (-_160) + _761.x;
    _761.x = (_134.y * _761.x) + _160;
    _761.x *= 0.25f;
    _123.x = (_123.x * 0.5f) + _761.x;
    _191 = _88 + 45.31999969482421875f.xxxx;
    _761.x = dot(_88.zw, _191.zw);
    _160 = dot(_88.xy, _191.xy);
    float2 _967 = _160.xx + _88.xy;
    _88 = float4(_967.x, _967.y, _88.z, _88.w);
    _761 = _761.xx + _88.zw;
    _761.x = _761.y * _761.x;
    _761.y = _88.y * _88.x;
    _761 = frac(_761);
    _761.x = (-_761.y) + _761.x;
    _761.x = (_134.z * _761.x) + _761.y;
    _160 = (-_153.z) + _153.x;
    _160 = (_134.z * _160) + _153.z;
    _761.x = (-_160) + _761.x;
    _761.x = (_134.w * _761.x) + _160;
    _123.x = (_761.x * 0.125f) + _123.x;
    _761.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _761.x = rsqrt(_761.x);
    float3 _1052 = _761.xxx * vs_TEXCOORD1;
    _88 = float4(_1052.x, _1052.y, _1052.z, _88.w);
    _761 = abs(_88.xz) + 0.001000000047497451305389404296875f.xx;
    _1061 = _761.y + _761.x;
    _761 /= _1061.xx;
    _123.x = _761.x * _123.x;
    _134 = floor(_68);
    _68 = frac(_68);
    _153 = _134 + 1.0f.xxxx;
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _761.x = dot(_153.xy, _191.xy);
    _1061 = dot(_153.zw, _191.zw);
    _348 = _1061.xx + _153.zw;
    float2 _1110 = _761.xx + _153.xy;
    _153 = float4(_1110.x, _1110.y, _153.z, _153.w);
    _761.x = _153.y * _153.x;
    _761.x = frac(_761.x);
    _1061 = _348.y * _348.x;
    _1061 = frac(_1061);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _191.z = dot(_153.zw, _191.zw);
    _191.x = dot(_153.xy, _191.xy);
    _153 += _191.xxzz;
    float2 _1159 = _153.yw * _153.xz;
    _153 = float4(_1159.x, _153.y, _1159.y, _153.w);
    float2 _1164 = frac(_153.xz);
    _153 = float4(_1164.x, _153.y, _1164.y, _153.w);
    _761.x += (-_153.z);
    _191 = _68 * _68;
    _68 = ((-_68) * 2.0f.xxxx) + 3.0f.xxxx;
    _68 *= _191;
    _761.x = (_68.x * _761.x) + _153.z;
    _191 = _134 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = _134.zwzw + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _492.x = dot(_191.xy, _388.xy);
    _348.x = dot(_191.zw, _388.zw);
    _348 = _348.xx + _191.zw;
    float2 _1227 = _492.xx + _191.xy;
    _191 = float4(_1227.x, _1227.y, _191.z, _191.w);
    _492.x = _191.y * _191.x;
    _492.y = _348.y * _348.x;
    _492 = frac(_492);
    _153.x = (-_492.x) + _153.x;
    _68.x = (_68.x * _153.x) + _492.x;
    _761.x += (-_68.x);
    float2 _1274 = (_68.yy * _761.xx) + _68.xx;
    _191 = float4(_1274.x, _191.y, _1274.y, _191.w);
    _388 = _134 + 45.31999969482421875f.xxxx;
    _761.x = dot(_134.zw, _388.zw);
    _68.x = dot(_134.xy, _388.xy);
    float2 _1295 = _68.xx + _134.xy;
    _68 = float4(_1295.x, _1295.y, _68.z, _68.w);
    float2 _1302 = _761.xx + _134.zw;
    _134 = float4(_1302.x, _1302.y, _134.z, _134.w);
    _761.x = _134.y * _134.x;
    _761.x = frac(_761.x);
    _68.x = _68.y * _68.x;
    _68.x = frac(_68.x);
    _68.x = (-_492.y) + _68.x;
    _68.x = (_68.z * _68.x) + _492.y;
    _1341 = (-_761.x) + _1061;
    _761.x = (_68.z * _1341) + _761.x;
    _761.x = (-_68.x) + _761.x;
    float2 _1369 = (_68.ww * _761.xx) + _68.xx;
    _191 = float4(_191.x, _1369.x, _191.z, _1369.y);
    _68 = (_191 * 2.0f.xxxx) + (-1.0f).xxxx;
    _9 = (_68 * float4(float4(_17_m11, _17_m11, _17_m11, _17_m11))) + _9;
    float2 _1395 = frac(_9.zw);
    _68 = float4(_1395.x, _1395.y, _68.z, _68.w);
    _1398 = _68.xy * _68.xy;
    float2 _1408 = ((-_68.xy) * 2.0f.xx) + 3.0f.xx;
    _68 = float4(_1408.x, _1408.y, _68.z, _68.w);
    float2 _1414 = _68.xy * _1398;
    _68 = float4(_1414.x, _1414.y, _68.z, _68.w);
    _1398 = floor(_9.zw);
    _9 = (_9 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    float2 _1424 = _1398 + 1.0f.xx;
    _134 = float4(_1424.x, _1424.y, _134.z, _134.w);
    float2 _1429 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_1429.x, _1429.y, _134.z, _134.w);
    float2 _1434 = frac(_134.xy);
    _134 = float4(_1434.x, _1434.y, _134.z, _134.w);
    _140 = _134.xy + 45.31999969482421875f.xx;
    _761.x = dot(_134.xy, _140);
    float2 _1449 = _761.xx + _134.xy;
    _134 = float4(_1449.x, _1449.y, _134.z, _134.w);
    _761.x = _134.y * _134.x;
    _761.x = frac(_761.x);
    _134 = _1398.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _1398 *= float2(123.339996337890625f, 456.209991455078125f);
    _1398 = frac(_1398);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _153 = _134 + 45.31999969482421875f.xxxx;
    _1061 = dot(_134.zw, _153.zw);
    _153.x = dot(_134.xy, _153.xy);
    float2 _1490 = _134.xy + _153.xx;
    _134 = float4(_1490.x, _1490.y, _134.z, _134.w);
    _140 = _1061.xx + _134.zw;
    _1061 = _140.y * _140.x;
    _1061 = frac(_1061);
    _134.x = _134.y * _134.x;
    _134.x = frac(_134.x);
    _761.x += (-_1061);
    _761.x = (_68.x * _761.x) + _1061;
    float2 _1530 = _1398 + 45.31999969482421875f.xx;
    _707 = float3(_1530.x, _1530.y, _707.z);
    _1061 = dot(_1398, _707.xy);
    _1398 += _1061.xx;
    _1398.x = _1398.y * _1398.x;
    _1398.x = frac(_1398.x);
    _195 = (-_1398.x) + _134.x;
    _68.x = (_68.x * _195) + _1398.x;
    _761.x += (-_68.x);
    _761.x = (_68.y * _761.x) + _68.x;
    _68 = frac(_9);
    _9 = floor(_9);
    _134 = _68 * _68;
    _68 = ((-_68) * 2.0f.xxxx) + 3.0f.xxxx;
    _68 *= _134;
    _134 = _9.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _153 = _134 + 45.31999969482421875f.xxxx;
    _1061 = dot(_134.zw, _153.zw);
    _153.x = dot(_134.xy, _153.xy);
    float2 _1619 = _134.xy + _153.xx;
    _134 = float4(_1619.x, _1619.y, _134.z, _134.w);
    _140 = _1061.xx + _134.zw;
    _1061 = _140.y * _140.x;
    _1061 = frac(_1061);
    _134.x = _134.y * _134.x;
    _153 = _9 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _707.x = dot(_153.xy, _191.xy);
    _140.x = dot(_153.zw, _191.zw);
    _140 = _140.xx + _153.zw;
    float2 _1669 = _707.xx + _153.xy;
    _153 = float4(_1669.x, _1669.y, _153.z, _153.w);
    _134.y = _153.y * _153.x;
    float2 _1680 = frac(_134.xy);
    _134 = float4(_1680.x, _1680.y, _134.z, _134.w);
    _707.x = (-_1061) + _134.y;
    _1061 = (_68.x * _707.x) + _1061;
    _707.x = _140.y * _140.x;
    _153 = _9 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _9 = _9.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _9 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _9 = frac(_9);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _140.x = dot(_153.xy, _191.xy);
    _635 = dot(_153.zw, _191.zw);
    _348 = _635.xx + _153.zw;
    _140 = _140.xx + _153.xy;
    _707.y = _140.y * _140.x;
    _707.z = _348.y * _348.x;
    _707 = frac(_707);
    _134.x = (-_707.y) + _134.x;
    _68.x = (_68.x * _134.x) + _707.y;
    _1061 = (-_68.x) + _1061;
    _68.x = (_68.y * _1061) + _68.x;
    _68.x *= 0.25f;
    _761.x = (_761.x * 0.5f) + _68.x;
    _153 = _9 + 45.31999969482421875f.xxxx;
    _68.x = dot(_9.zw, _153.zw);
    _68.y = dot(_9.xy, _153.xy);
    _9 += _68.yyxx;
    float2 _1812 = _9.yw * _9.xz;
    _9 = float4(_1812.x, _9.y, _1812.y, _9.w);
    float2 _1817 = frac(_9.xz);
    _9 = float4(_1817.x, _9.y, _1817.y, _9.w);
    _1820.x = (-_9.x) + _9.z;
    _9.x = (_68.z * _1820.x) + _9.x;
    _1820.x = (-_707.z) + _707.x;
    _1820.x = (_68.z * _1820.x) + _707.z;
    _9.x = (-_1820.x) + _9.x;
    _9.x = (_68.w * _9.x) + _1820.x;
    _9.x = (_9.x * 0.125f) + _761.x;
    _9.x = _761.y * _9.x;
    _9.x *= 1.14285719394683837890625f;
    _9.x = (_123.x * 1.14285719394683837890625f) + _9.x;
    _1894.x = _17_m7 + 1.0f;
    _9.x = (_9.x * _1894.x) + (-0.25f);
    _1820 = (-vs_TEXCOORD0) + _17_m1;
    _123.x = dot(_1820, _1820);
    _123.x = rsqrt(_123.x);
    _1820 *= _123.xxx;
    _1820.x = dot(_88.xyz, _1820);
    _1820.x = clamp(_1820.x, 0.0f, 1.0f);
    _1894.x = _1820.x * _17_m8;
    _9.x = (_1894.x * 0.5f) + _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1894.x = (_9.x * _17_m16) + 0.5f;
    _1894.x = floor(_1894.x);
    _1894.x /= _17_m16;
    _1894.y = _1894.x + (-0.449999988079071044921875f);
    float2 _1980 = _1894.xy * 2.22222232818603515625f.xx;
    _1894 = float4(_1980.x, _1980.y, _1894.z, _1894.w);
    float2 _1987 = clamp(_1894.xy, 0.0f.xx, 1.0f.xx);
    _1894 = float4(_1987.x, _1987.y, _1894.z, _1894.w);
    _1990 = (_1894.y * (-2.0f)) + 3.0f;
    _1996 = _1894.y * _1894.y;
    _1996 *= _1990;
    _1990 = (_1894.x * (-2.0f)) + 3.0f;
    _1894.x *= _1894.x;
    _1894.x *= _1990;
    _2020 = (-_17_m3.xyz) + _17_m4.xyz;
    float3 _2039 = (_1894.xxx * _2020) + _17_m3.xyz;
    _1894 = float4(_2039.x, _1894.y, _2039.y, _2039.z);
    _2020 = (-_1894.xzw) + _17_m5.xyz;
    float3 _2056 = (_1996.xxx * _2020) + _1894.xzw;
    _1894 = float4(_2056.x, _2056.y, _2056.z, _1894.w);
    _9.x = floor(_38.x);
    _2063 = frac(_38.x);
    _9.y = 0.0f;
    _38 = _9.xy + float2(1.0f, 0.0f);
    float2 _2074 = _9.xy * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_2074.x, _2074.y, _9.z, _9.w);
    _38 *= float2(123.339996337890625f, 456.209991455078125f);
    _38 = frac(_38);
    _2081 = _38.x + 45.31999969482421875f;
    _38 = (_38.xx * _2081.xx) + _38;
    _9.w = _38.y * _38.x;
    float3 _2100 = frac(_9.xyw);
    _9 = float4(_2100.x, _2100.y, _9.z, _2100.z);
    _38.x = _9.x + 45.31999969482421875f;
    float2 _2114 = (_9.xx * _38.xx) + _9.xy;
    _9 = float4(_2114.x, _2114.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1820.x = (-_9.x) + _9.w;
    _2081 = _2063 * _2063;
    _2063 = ((-_2063) * 2.0f) + 3.0f;
    _2063 *= _2081;
    _9.x = (_2063 * _1820.x) + _9.x;
    _2152 = (-_17_m13) + 1.0f;
    _9.x = (_17_m13 * _9.x) + _2152;
    _2152 = _9.x * _17_m6;
    float3 _2182 = (_1894.xyz * _2152.xxx) + (-_17_m2.xyz);
    _9 = float4(_2182.x, _2182.y, _2182.z, _9.w);
    _2081 = vs_TEXCOORD3;
    _2081 = clamp(_2081, 0.0f, 1.0f);
    float3 _2197 = (_2081.xxx * _9.xyz) + _17_m2.xyz;
    _9 = float4(_2197.x, _2197.y, _2197.z, _9.w);
    _2201 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _2201.w);
    _2201.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2201 = _2201;
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
static float vs_TEXCOORD3;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 _141;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _141 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _62;
static float _98;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    float3 _59 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _44.yyyy * _21_m3[1];
    _62 = (_21_m3[0] * _44.xxxx) + _62;
    _62 = (_21_m3[2] * _44.zzzz) + _62;
    _44 = (_21_m3[3] * _44.wwww) + _62;
    gl_Position = _44;
    _98 = _44.z / _21_m0.y;
    _98 = (-_98) + 1.0f;
    _98 *= _21_m0.z;
    _98 = max(_98, 0.0f);
    vs_TEXCOORD3 = (_98 * _21_m4.z) + _21_m4.w;
    vs_TEXCOORD2 = dot(_9.xyz, float3(0.37000000476837158203125f, 0.20999999344348907470703125f, 0.2899999916553497314453125f));
    vs_TEXCOORD0 = _9.xyz;
    _9.x = dot(_141, _21_m2[0].xyz);
    _9.y = dot(_141, _21_m2[1].xyz);
    _9.z = dot(_141, _21_m2[2].xyz);
    _98 = dot(_9.xyz, _9.xyz);
    _98 = rsqrt(_98);
    vs_TEXCOORD1 = _98.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _DeepColor;
float4 _MidColor;
float4 _HotColor;
float _Intensity;
float _HotBias;
float _FacingBoost;
float _Scale;
float _Speed;
float _WarpStrength;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_FogColor
#define _17_m3 _DeepColor
#define _17_m4 _MidColor
#define _17_m5 _HotColor
#define _17_m6 _Intensity
#define _17_m7 _HotBias
#define _17_m8 _FacingBoost
#define _17_m9 _Scale
#define _17_m10 _Speed
#define _17_m11 _WarpStrength
#define _17_m12 _PulseSpeed
#define _17_m13 _PulseAmount
#define _17_m14 _PixelSize
#define _17_m15 _FrameRate
#define _17_m16 _Steps



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _2201;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _2201 : SV_Target0;
};

static float4 _9;
static float2 _38;
static float4 _68;
static float4 _88;
static float3 _123;
static float4 _134;
static float2 _140;
static float4 _153;
static float _160;
static float4 _191;
static float _195;
static float2 _348;
static float4 _388;
static float _397;
static float2 _492;
static float _635;
static float3 _707;
static float2 _761;
static float _1061;
static float _1341;
static float2 _1398;
static float3 _1820;
static float4 _1894;
static float _1990;
static float _1996;
static float3 _2020;
static float _2063;
static float _2081;
static float _2152;

void frag_inner()
{
    _9 = vs_TEXCOORD0.zyxy / _17_m14.xxxx;
    _9 = floor(_9);
    _9 += 0.5f.xxxx;
    _9 *= _17_m14.xxxx;
    _38.x = vs_TEXCOORD2 + _17_m0.y;
    _38.x *= _17_m15;
    _38.x = floor(_38.x);
    _38.x /= _17_m15;
    float2 _81 = (-_38.xx) * float2(float2(_17_m10, _17_m10));
    _68 = float4(_68.x, _81.x, _68.z, _81.y);
    _68.x = 0.0f;
    _68.z = 0.0f;
    _88 = (_9.xyxy * _17_m9.xxxx) + _68.zwzw;
    _9 = (_9.zwzw * _17_m9.xxxx) + _68;
    float2 _112 = _38.xx * float2(0.300000011920928955078125f, -0.25f);
    _68 = float4(_112.x, _112.y, _68.z, _68.w);
    _38.x *= _17_m12;
    float2 _131 = (_88.zw * 0.699999988079071044921875f.xx) + _68.xx;
    _123 = float3(_131.x, _131.y, _123.z);
    float2 _137 = floor(_123.xy);
    _134 = float4(_137.x, _137.y, _134.z, _134.w);
    _140 = _134.xy + 1.0f.xx;
    _140 *= float2(123.339996337890625f, 456.209991455078125f);
    _140 = frac(_140);
    float2 _157 = _140 + 45.31999969482421875f.xx;
    _153 = float4(_157.x, _157.y, _153.z, _153.w);
    _160 = dot(_140, _153.xy);
    _140 = _160.xx + _140;
    _123.z = _140.y * _140.x;
    _123 = frac(_123);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _183 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_183.x, _183.y, _134.z, _134.w);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _195 = dot(_153.zw, _191.zw);
    _140.x = dot(_153.xy, _191.xy);
    _140 = _140.xx + _153.xy;
    float2 _216 = _195.xx + _153.zw;
    _153 = float4(_216.x, _216.y, _153.z, _153.w);
    _195 = _153.y * _153.x;
    _195 = frac(_195);
    _134.z = _140.y * _140.x;
    float3 _234 = frac(_134.xyz);
    _134 = float4(_234.x, _234.y, _234.z, _134.w);
    _160 = _123.z + (-_195);
    float2 _246 = _123.xy * _123.xy;
    _153 = float4(_246.x, _246.y, _153.z, _153.w);
    float2 _257 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_257.x, _257.y, _123.z);
    float2 _264 = _123.xy * _153.xy;
    _123 = float3(_264.x, _264.y, _123.z);
    _160 = (_123.x * _160) + _195;
    float2 _275 = _134.xy + 45.31999969482421875f.xx;
    _153 = float4(_275.x, _275.y, _153.z, _153.w);
    _195 = dot(_134.xy, _153.xy);
    float2 _287 = _195.xx + _134.xy;
    _134 = float4(_287.x, _287.y, _134.z, _134.w);
    _195 = _134.y * _134.x;
    _195 = frac(_195);
    _134.x = (-_195) + _134.z;
    _123.x = (_123.x * _134.x) + _195;
    _160 = (-_123.x) + _160;
    float2 _323 = (_123.yy * _160.xx) + _123.xx;
    _134 = float4(_323.x, _134.y, _323.y, _134.w);
    _68.z = 5.19999980926513671875f;
    float2 _333 = (_88.zw * 0.699999988079071044921875f.xx) + _68.zy;
    _123 = float3(_333.x, _333.y, _123.z);
    _68 = (_9.zwzw * 0.699999988079071044921875f.xxxx) + _68.xxzy;
    float2 _345 = floor(_123.xy);
    _153 = float4(_345.x, _345.y, _153.z, _153.w);
    _348 = _153.xy + 1.0f.xx;
    _348 *= float2(123.339996337890625f, 456.209991455078125f);
    _348 = frac(_348);
    float2 _357 = _348 + 45.31999969482421875f.xx;
    _191 = float4(_357.x, _357.y, _191.z, _191.w);
    _160 = dot(_348, _191.xy);
    _348 = _160.xx + _348;
    _123.z = _348.y * _348.x;
    _123 = frac(_123);
    _191 = _153.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _381 = _153.xy * float2(123.339996337890625f, 456.209991455078125f);
    _153 = float4(_381.x, _381.y, _153.z, _153.w);
    _191 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _348.x = dot(_191.zw, _388.zw);
    _397 = dot(_191.xy, _388.xy);
    float2 _407 = _397.xx + _191.xy;
    _191 = float4(_407.x, _407.y, _191.z, _191.w);
    _348 = _348.xx + _191.zw;
    _153.z = _348.y * _348.x;
    _153.w = _191.y * _191.x;
    _153 = frac(_153);
    _160 = _123.z + (-_153.z);
    float2 _440 = _123.xy * _123.xy;
    _191 = float4(_440.x, _440.y, _191.z, _191.w);
    float2 _447 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_447.x, _447.y, _123.z);
    float2 _454 = _123.xy * _191.xy;
    _123 = float3(_454.x, _454.y, _123.z);
    _160 = (_123.x * _160) + _153.z;
    float2 _466 = _153.xy + 45.31999969482421875f.xx;
    _191 = float4(_466.x, _466.y, _191.z, _191.w);
    _348.x = dot(_153.xy, _191.xy);
    float2 _479 = _348.xx + _153.xy;
    _153 = float4(_479.x, _479.y, _153.z, _153.w);
    _153.x = _153.y * _153.x;
    _153.x = frac(_153.x);
    _492.x = (-_153.x) + _153.w;
    _123.x = (_123.x * _492.x) + _153.x;
    _160 = (-_123.x) + _160;
    float2 _521 = (_123.yy * _160.xx) + _123.xx;
    _134 = float4(_134.x, _521.x, _134.z, _521.y);
    _134 = (_134 * 2.0f.xxxx) + (-1.0f).xxxx;
    _88 = (_134 * float4(float4(_17_m11, _17_m11, _17_m11, _17_m11))) + _88;
    float2 _551 = frac(_88.zw);
    _123 = float3(_551.x, _551.y, _123.z);
    float2 _558 = _123.xy * _123.xy;
    _134 = float4(_558.x, _558.y, _134.z, _134.w);
    float2 _565 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_565.x, _565.y, _123.z);
    float2 _572 = _123.xy * _134.xy;
    _123 = float3(_572.x, _572.y, _123.z);
    float2 _577 = floor(_88.zw);
    _134 = float4(_577.x, _577.y, _134.z, _134.w);
    _88 = (_88 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _140 = _134.xy + 1.0f.xx;
    _140 *= float2(123.339996337890625f, 456.209991455078125f);
    _140 = frac(_140);
    float2 _597 = _140 + 45.31999969482421875f.xx;
    _153 = float4(_597.x, _597.y, _153.z, _153.w);
    _160 = dot(_140, _153.xy);
    _140 = _160.xx + _140;
    _160 = _140.y * _140.x;
    _160 = frac(_160);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _620 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_620.x, _620.y, _134.z, _134.w);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _140.x = dot(_153.zw, _191.zw);
    _635 = dot(_153.xy, _191.xy);
    float2 _645 = _635.xx + _153.xy;
    _153 = float4(_645.x, _645.y, _153.z, _153.w);
    _140 = _140.xx + _153.zw;
    _134.z = _140.y * _140.x;
    _134.w = _153.y * _153.x;
    _134 = frac(_134);
    _160 += (-_134.z);
    _160 = (_123.x * _160) + _134.z;
    float2 _681 = _134.xy + 45.31999969482421875f.xx;
    _153 = float4(_681.x, _681.y, _153.z, _153.w);
    _140.x = dot(_134.xy, _153.xy);
    float2 _694 = _140.xx + _134.xy;
    _134 = float4(_694.x, _694.y, _134.z, _134.w);
    _134.x = _134.y * _134.x;
    _134.x = frac(_134.x);
    _707.x = (-_134.x) + _134.w;
    _123.x = (_123.x * _707.x) + _134.x;
    _160 = (-_123.x) + _160;
    _123.x = (_123.y * _160) + _123.x;
    _134 = frac(_88);
    _88 = floor(_88);
    _153 = _134 * _134;
    _134 = ((-_134) * 2.0f.xxxx) + 3.0f.xxxx;
    _134 *= _153;
    _153 = _88.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _761.x = dot(_153.zw, _191.zw);
    _160 = dot(_153.xy, _191.xy);
    float2 _777 = _160.xx + _153.xy;
    _153 = float4(_777.x, _777.y, _153.z, _153.w);
    _761 = _761.xx + _153.zw;
    _761.x = _761.y * _761.x;
    _761.y = _153.y * _153.x;
    _761 = frac(_761);
    _153 = _88 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _191.x = dot(_153.xy, _191.xy);
    _191.y = dot(_153.zw, _191.zw);
    _153 += _191.xxyy;
    _153.x = _153.y * _153.x;
    _153.x = frac(_153.x);
    _153.x = (-_761.x) + _153.x;
    _761.x = (_134.x * _153.x) + _761.x;
    _153.x = _153.w * _153.z;
    _191 = _88 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _88 = _88.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _88 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _88 = frac(_88);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _492.x = dot(_191.xy, _388.xy);
    _348.x = dot(_191.zw, _388.zw);
    _348 = _348.xx + _191.zw;
    float2 _891 = _492.xx + _191.xy;
    _191 = float4(_891.x, _891.y, _191.z, _191.w);
    _153.y = _191.y * _191.x;
    _153.z = _348.y * _348.x;
    float3 _908 = frac(_153.xyz);
    _153 = float4(_908.x, _908.y, _908.z, _153.w);
    _160 = _761.y + (-_153.y);
    _160 = (_134.x * _160) + _153.y;
    _761.x = (-_160) + _761.x;
    _761.x = (_134.y * _761.x) + _160;
    _761.x *= 0.25f;
    _123.x = (_123.x * 0.5f) + _761.x;
    _191 = _88 + 45.31999969482421875f.xxxx;
    _761.x = dot(_88.zw, _191.zw);
    _160 = dot(_88.xy, _191.xy);
    float2 _967 = _160.xx + _88.xy;
    _88 = float4(_967.x, _967.y, _88.z, _88.w);
    _761 = _761.xx + _88.zw;
    _761.x = _761.y * _761.x;
    _761.y = _88.y * _88.x;
    _761 = frac(_761);
    _761.x = (-_761.y) + _761.x;
    _761.x = (_134.z * _761.x) + _761.y;
    _160 = (-_153.z) + _153.x;
    _160 = (_134.z * _160) + _153.z;
    _761.x = (-_160) + _761.x;
    _761.x = (_134.w * _761.x) + _160;
    _123.x = (_761.x * 0.125f) + _123.x;
    _761.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _761.x = rsqrt(_761.x);
    float3 _1052 = _761.xxx * vs_TEXCOORD1;
    _88 = float4(_1052.x, _1052.y, _1052.z, _88.w);
    _761 = abs(_88.xz) + 0.001000000047497451305389404296875f.xx;
    _1061 = _761.y + _761.x;
    _761 /= _1061.xx;
    _123.x = _761.x * _123.x;
    _134 = floor(_68);
    _68 = frac(_68);
    _153 = _134 + 1.0f.xxxx;
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _761.x = dot(_153.xy, _191.xy);
    _1061 = dot(_153.zw, _191.zw);
    _348 = _1061.xx + _153.zw;
    float2 _1110 = _761.xx + _153.xy;
    _153 = float4(_1110.x, _1110.y, _153.z, _153.w);
    _761.x = _153.y * _153.x;
    _761.x = frac(_761.x);
    _1061 = _348.y * _348.x;
    _1061 = frac(_1061);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _191.z = dot(_153.zw, _191.zw);
    _191.x = dot(_153.xy, _191.xy);
    _153 += _191.xxzz;
    float2 _1159 = _153.yw * _153.xz;
    _153 = float4(_1159.x, _153.y, _1159.y, _153.w);
    float2 _1164 = frac(_153.xz);
    _153 = float4(_1164.x, _153.y, _1164.y, _153.w);
    _761.x += (-_153.z);
    _191 = _68 * _68;
    _68 = ((-_68) * 2.0f.xxxx) + 3.0f.xxxx;
    _68 *= _191;
    _761.x = (_68.x * _761.x) + _153.z;
    _191 = _134 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = _134.zwzw + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _492.x = dot(_191.xy, _388.xy);
    _348.x = dot(_191.zw, _388.zw);
    _348 = _348.xx + _191.zw;
    float2 _1227 = _492.xx + _191.xy;
    _191 = float4(_1227.x, _1227.y, _191.z, _191.w);
    _492.x = _191.y * _191.x;
    _492.y = _348.y * _348.x;
    _492 = frac(_492);
    _153.x = (-_492.x) + _153.x;
    _68.x = (_68.x * _153.x) + _492.x;
    _761.x += (-_68.x);
    float2 _1274 = (_68.yy * _761.xx) + _68.xx;
    _191 = float4(_1274.x, _191.y, _1274.y, _191.w);
    _388 = _134 + 45.31999969482421875f.xxxx;
    _761.x = dot(_134.zw, _388.zw);
    _68.x = dot(_134.xy, _388.xy);
    float2 _1295 = _68.xx + _134.xy;
    _68 = float4(_1295.x, _1295.y, _68.z, _68.w);
    float2 _1302 = _761.xx + _134.zw;
    _134 = float4(_1302.x, _1302.y, _134.z, _134.w);
    _761.x = _134.y * _134.x;
    _761.x = frac(_761.x);
    _68.x = _68.y * _68.x;
    _68.x = frac(_68.x);
    _68.x = (-_492.y) + _68.x;
    _68.x = (_68.z * _68.x) + _492.y;
    _1341 = (-_761.x) + _1061;
    _761.x = (_68.z * _1341) + _761.x;
    _761.x = (-_68.x) + _761.x;
    float2 _1369 = (_68.ww * _761.xx) + _68.xx;
    _191 = float4(_191.x, _1369.x, _191.z, _1369.y);
    _68 = (_191 * 2.0f.xxxx) + (-1.0f).xxxx;
    _9 = (_68 * float4(float4(_17_m11, _17_m11, _17_m11, _17_m11))) + _9;
    float2 _1395 = frac(_9.zw);
    _68 = float4(_1395.x, _1395.y, _68.z, _68.w);
    _1398 = _68.xy * _68.xy;
    float2 _1408 = ((-_68.xy) * 2.0f.xx) + 3.0f.xx;
    _68 = float4(_1408.x, _1408.y, _68.z, _68.w);
    float2 _1414 = _68.xy * _1398;
    _68 = float4(_1414.x, _1414.y, _68.z, _68.w);
    _1398 = floor(_9.zw);
    _9 = (_9 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    float2 _1424 = _1398 + 1.0f.xx;
    _134 = float4(_1424.x, _1424.y, _134.z, _134.w);
    float2 _1429 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_1429.x, _1429.y, _134.z, _134.w);
    float2 _1434 = frac(_134.xy);
    _134 = float4(_1434.x, _1434.y, _134.z, _134.w);
    _140 = _134.xy + 45.31999969482421875f.xx;
    _761.x = dot(_134.xy, _140);
    float2 _1449 = _761.xx + _134.xy;
    _134 = float4(_1449.x, _1449.y, _134.z, _134.w);
    _761.x = _134.y * _134.x;
    _761.x = frac(_761.x);
    _134 = _1398.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _1398 *= float2(123.339996337890625f, 456.209991455078125f);
    _1398 = frac(_1398);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _153 = _134 + 45.31999969482421875f.xxxx;
    _1061 = dot(_134.zw, _153.zw);
    _153.x = dot(_134.xy, _153.xy);
    float2 _1490 = _134.xy + _153.xx;
    _134 = float4(_1490.x, _1490.y, _134.z, _134.w);
    _140 = _1061.xx + _134.zw;
    _1061 = _140.y * _140.x;
    _1061 = frac(_1061);
    _134.x = _134.y * _134.x;
    _134.x = frac(_134.x);
    _761.x += (-_1061);
    _761.x = (_68.x * _761.x) + _1061;
    float2 _1530 = _1398 + 45.31999969482421875f.xx;
    _707 = float3(_1530.x, _1530.y, _707.z);
    _1061 = dot(_1398, _707.xy);
    _1398 += _1061.xx;
    _1398.x = _1398.y * _1398.x;
    _1398.x = frac(_1398.x);
    _195 = (-_1398.x) + _134.x;
    _68.x = (_68.x * _195) + _1398.x;
    _761.x += (-_68.x);
    _761.x = (_68.y * _761.x) + _68.x;
    _68 = frac(_9);
    _9 = floor(_9);
    _134 = _68 * _68;
    _68 = ((-_68) * 2.0f.xxxx) + 3.0f.xxxx;
    _68 *= _134;
    _134 = _9.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _153 = _134 + 45.31999969482421875f.xxxx;
    _1061 = dot(_134.zw, _153.zw);
    _153.x = dot(_134.xy, _153.xy);
    float2 _1619 = _134.xy + _153.xx;
    _134 = float4(_1619.x, _1619.y, _134.z, _134.w);
    _140 = _1061.xx + _134.zw;
    _1061 = _140.y * _140.x;
    _1061 = frac(_1061);
    _134.x = _134.y * _134.x;
    _153 = _9 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _707.x = dot(_153.xy, _191.xy);
    _140.x = dot(_153.zw, _191.zw);
    _140 = _140.xx + _153.zw;
    float2 _1669 = _707.xx + _153.xy;
    _153 = float4(_1669.x, _1669.y, _153.z, _153.w);
    _134.y = _153.y * _153.x;
    float2 _1680 = frac(_134.xy);
    _134 = float4(_1680.x, _1680.y, _134.z, _134.w);
    _707.x = (-_1061) + _134.y;
    _1061 = (_68.x * _707.x) + _1061;
    _707.x = _140.y * _140.x;
    _153 = _9 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _9 = _9.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _9 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _9 = frac(_9);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _140.x = dot(_153.xy, _191.xy);
    _635 = dot(_153.zw, _191.zw);
    _348 = _635.xx + _153.zw;
    _140 = _140.xx + _153.xy;
    _707.y = _140.y * _140.x;
    _707.z = _348.y * _348.x;
    _707 = frac(_707);
    _134.x = (-_707.y) + _134.x;
    _68.x = (_68.x * _134.x) + _707.y;
    _1061 = (-_68.x) + _1061;
    _68.x = (_68.y * _1061) + _68.x;
    _68.x *= 0.25f;
    _761.x = (_761.x * 0.5f) + _68.x;
    _153 = _9 + 45.31999969482421875f.xxxx;
    _68.x = dot(_9.zw, _153.zw);
    _68.y = dot(_9.xy, _153.xy);
    _9 += _68.yyxx;
    float2 _1812 = _9.yw * _9.xz;
    _9 = float4(_1812.x, _9.y, _1812.y, _9.w);
    float2 _1817 = frac(_9.xz);
    _9 = float4(_1817.x, _9.y, _1817.y, _9.w);
    _1820.x = (-_9.x) + _9.z;
    _9.x = (_68.z * _1820.x) + _9.x;
    _1820.x = (-_707.z) + _707.x;
    _1820.x = (_68.z * _1820.x) + _707.z;
    _9.x = (-_1820.x) + _9.x;
    _9.x = (_68.w * _9.x) + _1820.x;
    _9.x = (_9.x * 0.125f) + _761.x;
    _9.x = _761.y * _9.x;
    _9.x *= 1.14285719394683837890625f;
    _9.x = (_123.x * 1.14285719394683837890625f) + _9.x;
    _1894.x = _17_m7 + 1.0f;
    _9.x = (_9.x * _1894.x) + (-0.25f);
    _1820 = (-vs_TEXCOORD0) + _17_m1;
    _123.x = dot(_1820, _1820);
    _123.x = rsqrt(_123.x);
    _1820 *= _123.xxx;
    _1820.x = dot(_88.xyz, _1820);
    _1820.x = clamp(_1820.x, 0.0f, 1.0f);
    _1894.x = _1820.x * _17_m8;
    _9.x = (_1894.x * 0.5f) + _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1894.x = (_9.x * _17_m16) + 0.5f;
    _1894.x = floor(_1894.x);
    _1894.x /= _17_m16;
    _1894.y = _1894.x + (-0.449999988079071044921875f);
    float2 _1980 = _1894.xy * 2.22222232818603515625f.xx;
    _1894 = float4(_1980.x, _1980.y, _1894.z, _1894.w);
    float2 _1987 = clamp(_1894.xy, 0.0f.xx, 1.0f.xx);
    _1894 = float4(_1987.x, _1987.y, _1894.z, _1894.w);
    _1990 = (_1894.y * (-2.0f)) + 3.0f;
    _1996 = _1894.y * _1894.y;
    _1996 *= _1990;
    _1990 = (_1894.x * (-2.0f)) + 3.0f;
    _1894.x *= _1894.x;
    _1894.x *= _1990;
    _2020 = (-_17_m3.xyz) + _17_m4.xyz;
    float3 _2039 = (_1894.xxx * _2020) + _17_m3.xyz;
    _1894 = float4(_2039.x, _1894.y, _2039.y, _2039.z);
    _2020 = (-_1894.xzw) + _17_m5.xyz;
    float3 _2056 = (_1996.xxx * _2020) + _1894.xzw;
    _1894 = float4(_2056.x, _2056.y, _2056.z, _1894.w);
    _9.x = floor(_38.x);
    _2063 = frac(_38.x);
    _9.y = 0.0f;
    _38 = _9.xy + float2(1.0f, 0.0f);
    float2 _2074 = _9.xy * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_2074.x, _2074.y, _9.z, _9.w);
    _38 *= float2(123.339996337890625f, 456.209991455078125f);
    _38 = frac(_38);
    _2081 = _38.x + 45.31999969482421875f;
    _38 = (_38.xx * _2081.xx) + _38;
    _9.w = _38.y * _38.x;
    float3 _2100 = frac(_9.xyw);
    _9 = float4(_2100.x, _2100.y, _9.z, _2100.z);
    _38.x = _9.x + 45.31999969482421875f;
    float2 _2114 = (_9.xx * _38.xx) + _9.xy;
    _9 = float4(_2114.x, _2114.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1820.x = (-_9.x) + _9.w;
    _2081 = _2063 * _2063;
    _2063 = ((-_2063) * 2.0f) + 3.0f;
    _2063 *= _2081;
    _9.x = (_2063 * _1820.x) + _9.x;
    _2152 = (-_17_m13) + 1.0f;
    _9.x = (_17_m13 * _9.x) + _2152;
    _2152 = _9.x * _17_m6;
    float3 _2182 = (_1894.xyz * _2152.xxx) + (-_17_m2.xyz);
    _9 = float4(_2182.x, _2182.y, _2182.z, _9.w);
    _2081 = vs_TEXCOORD3;
    _2081 = clamp(_2081, 0.0f, 1.0f);
    float3 _2197 = (_2081.xxx * _9.xyz) + _17_m2.xyz;
    _9 = float4(_2197.x, _2197.y, _2197.z, _9.w);
    _2201 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _2201.w);
    _2201.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2201 = _2201;
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
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 _110;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _110 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _62;
static float _132;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    float3 _59 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _44.yyyy * _21_m2[1];
    _62 = (_21_m2[0] * _44.xxxx) + _62;
    _62 = (_21_m2[2] * _44.zzzz) + _62;
    gl_Position = (_21_m2[3] * _44.wwww) + _62;
    vs_TEXCOORD2 = dot(_9.xyz, float3(0.37000000476837158203125f, 0.20999999344348907470703125f, 0.2899999916553497314453125f));
    vs_TEXCOORD0 = _9.xyz;
    _9.x = dot(_110, _21_m1[0].xyz);
    _9.y = dot(_110, _21_m1[1].xyz);
    _9.z = dot(_110, _21_m1[2].xyz);
    _132 = dot(_9.xyz, _9.xyz);
    _132 = rsqrt(_132);
    vs_TEXCOORD1 = _132.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _110 = stage_input._110;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _DeepColor;
float4 _MidColor;
float4 _HotColor;
float _Intensity;
float _HotBias;
float _FacingBoost;
float _Scale;
float _Speed;
float _WarpStrength;
float _PulseSpeed;
float _PulseAmount;
float _PixelSize;
float _FrameRate;
float _Steps;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _DeepColor
#define _17_m3 _MidColor
#define _17_m4 _HotColor
#define _17_m5 _Intensity
#define _17_m6 _HotBias
#define _17_m7 _FacingBoost
#define _17_m8 _Scale
#define _17_m9 _Speed
#define _17_m10 _WarpStrength
#define _17_m11 _PulseSpeed
#define _17_m12 _PulseAmount
#define _17_m13 _PixelSize
#define _17_m14 _FrameRate
#define _17_m15 _Steps



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 _2173;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _2173 : SV_Target0;
};

static float4 _9;
static float2 _38;
static float4 _68;
static float4 _88;
static float3 _123;
static float4 _134;
static float2 _140;
static float4 _153;
static float _160;
static float4 _191;
static float _195;
static float2 _348;
static float4 _388;
static float _397;
static float2 _492;
static float _635;
static float3 _707;
static float2 _761;
static float _1061;
static float _1341;
static float2 _1398;
static float3 _1820;
static float4 _1894;
static float _1990;
static float _1996;
static float3 _2020;
static float _2063;
static float _2081;
static float _2152;

void frag_inner()
{
    _9 = vs_TEXCOORD0.zyxy / _17_m13.xxxx;
    _9 = floor(_9);
    _9 += 0.5f.xxxx;
    _9 *= _17_m13.xxxx;
    _38.x = vs_TEXCOORD2 + _17_m0.y;
    _38.x *= _17_m14;
    _38.x = floor(_38.x);
    _38.x /= _17_m14;
    float2 _81 = (-_38.xx) * float2(float2(_17_m9, _17_m9));
    _68 = float4(_68.x, _81.x, _68.z, _81.y);
    _68.x = 0.0f;
    _68.z = 0.0f;
    _88 = (_9.xyxy * _17_m8.xxxx) + _68.zwzw;
    _9 = (_9.zwzw * _17_m8.xxxx) + _68;
    float2 _112 = _38.xx * float2(0.300000011920928955078125f, -0.25f);
    _68 = float4(_112.x, _112.y, _68.z, _68.w);
    _38.x *= _17_m11;
    float2 _131 = (_88.zw * 0.699999988079071044921875f.xx) + _68.xx;
    _123 = float3(_131.x, _131.y, _123.z);
    float2 _137 = floor(_123.xy);
    _134 = float4(_137.x, _137.y, _134.z, _134.w);
    _140 = _134.xy + 1.0f.xx;
    _140 *= float2(123.339996337890625f, 456.209991455078125f);
    _140 = frac(_140);
    float2 _157 = _140 + 45.31999969482421875f.xx;
    _153 = float4(_157.x, _157.y, _153.z, _153.w);
    _160 = dot(_140, _153.xy);
    _140 = _160.xx + _140;
    _123.z = _140.y * _140.x;
    _123 = frac(_123);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _183 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_183.x, _183.y, _134.z, _134.w);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _195 = dot(_153.zw, _191.zw);
    _140.x = dot(_153.xy, _191.xy);
    _140 = _140.xx + _153.xy;
    float2 _216 = _195.xx + _153.zw;
    _153 = float4(_216.x, _216.y, _153.z, _153.w);
    _195 = _153.y * _153.x;
    _195 = frac(_195);
    _134.z = _140.y * _140.x;
    float3 _234 = frac(_134.xyz);
    _134 = float4(_234.x, _234.y, _234.z, _134.w);
    _160 = _123.z + (-_195);
    float2 _246 = _123.xy * _123.xy;
    _153 = float4(_246.x, _246.y, _153.z, _153.w);
    float2 _257 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_257.x, _257.y, _123.z);
    float2 _264 = _123.xy * _153.xy;
    _123 = float3(_264.x, _264.y, _123.z);
    _160 = (_123.x * _160) + _195;
    float2 _275 = _134.xy + 45.31999969482421875f.xx;
    _153 = float4(_275.x, _275.y, _153.z, _153.w);
    _195 = dot(_134.xy, _153.xy);
    float2 _287 = _195.xx + _134.xy;
    _134 = float4(_287.x, _287.y, _134.z, _134.w);
    _195 = _134.y * _134.x;
    _195 = frac(_195);
    _134.x = (-_195) + _134.z;
    _123.x = (_123.x * _134.x) + _195;
    _160 = (-_123.x) + _160;
    float2 _323 = (_123.yy * _160.xx) + _123.xx;
    _134 = float4(_323.x, _134.y, _323.y, _134.w);
    _68.z = 5.19999980926513671875f;
    float2 _333 = (_88.zw * 0.699999988079071044921875f.xx) + _68.zy;
    _123 = float3(_333.x, _333.y, _123.z);
    _68 = (_9.zwzw * 0.699999988079071044921875f.xxxx) + _68.xxzy;
    float2 _345 = floor(_123.xy);
    _153 = float4(_345.x, _345.y, _153.z, _153.w);
    _348 = _153.xy + 1.0f.xx;
    _348 *= float2(123.339996337890625f, 456.209991455078125f);
    _348 = frac(_348);
    float2 _357 = _348 + 45.31999969482421875f.xx;
    _191 = float4(_357.x, _357.y, _191.z, _191.w);
    _160 = dot(_348, _191.xy);
    _348 = _160.xx + _348;
    _123.z = _348.y * _348.x;
    _123 = frac(_123);
    _191 = _153.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _381 = _153.xy * float2(123.339996337890625f, 456.209991455078125f);
    _153 = float4(_381.x, _381.y, _153.z, _153.w);
    _191 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _348.x = dot(_191.zw, _388.zw);
    _397 = dot(_191.xy, _388.xy);
    float2 _407 = _397.xx + _191.xy;
    _191 = float4(_407.x, _407.y, _191.z, _191.w);
    _348 = _348.xx + _191.zw;
    _153.z = _348.y * _348.x;
    _153.w = _191.y * _191.x;
    _153 = frac(_153);
    _160 = _123.z + (-_153.z);
    float2 _440 = _123.xy * _123.xy;
    _191 = float4(_440.x, _440.y, _191.z, _191.w);
    float2 _447 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_447.x, _447.y, _123.z);
    float2 _454 = _123.xy * _191.xy;
    _123 = float3(_454.x, _454.y, _123.z);
    _160 = (_123.x * _160) + _153.z;
    float2 _466 = _153.xy + 45.31999969482421875f.xx;
    _191 = float4(_466.x, _466.y, _191.z, _191.w);
    _348.x = dot(_153.xy, _191.xy);
    float2 _479 = _348.xx + _153.xy;
    _153 = float4(_479.x, _479.y, _153.z, _153.w);
    _153.x = _153.y * _153.x;
    _153.x = frac(_153.x);
    _492.x = (-_153.x) + _153.w;
    _123.x = (_123.x * _492.x) + _153.x;
    _160 = (-_123.x) + _160;
    float2 _521 = (_123.yy * _160.xx) + _123.xx;
    _134 = float4(_134.x, _521.x, _134.z, _521.y);
    _134 = (_134 * 2.0f.xxxx) + (-1.0f).xxxx;
    _88 = (_134 * float4(float4(_17_m10, _17_m10, _17_m10, _17_m10))) + _88;
    float2 _551 = frac(_88.zw);
    _123 = float3(_551.x, _551.y, _123.z);
    float2 _558 = _123.xy * _123.xy;
    _134 = float4(_558.x, _558.y, _134.z, _134.w);
    float2 _565 = ((-_123.xy) * 2.0f.xx) + 3.0f.xx;
    _123 = float3(_565.x, _565.y, _123.z);
    float2 _572 = _123.xy * _134.xy;
    _123 = float3(_572.x, _572.y, _123.z);
    float2 _577 = floor(_88.zw);
    _134 = float4(_577.x, _577.y, _134.z, _134.w);
    _88 = (_88 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    _140 = _134.xy + 1.0f.xx;
    _140 *= float2(123.339996337890625f, 456.209991455078125f);
    _140 = frac(_140);
    float2 _597 = _140 + 45.31999969482421875f.xx;
    _153 = float4(_597.x, _597.y, _153.z, _153.w);
    _160 = dot(_140, _153.xy);
    _140 = _160.xx + _140;
    _160 = _140.y * _140.x;
    _160 = frac(_160);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _620 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_620.x, _620.y, _134.z, _134.w);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _140.x = dot(_153.zw, _191.zw);
    _635 = dot(_153.xy, _191.xy);
    float2 _645 = _635.xx + _153.xy;
    _153 = float4(_645.x, _645.y, _153.z, _153.w);
    _140 = _140.xx + _153.zw;
    _134.z = _140.y * _140.x;
    _134.w = _153.y * _153.x;
    _134 = frac(_134);
    _160 += (-_134.z);
    _160 = (_123.x * _160) + _134.z;
    float2 _681 = _134.xy + 45.31999969482421875f.xx;
    _153 = float4(_681.x, _681.y, _153.z, _153.w);
    _140.x = dot(_134.xy, _153.xy);
    float2 _694 = _140.xx + _134.xy;
    _134 = float4(_694.x, _694.y, _134.z, _134.w);
    _134.x = _134.y * _134.x;
    _134.x = frac(_134.x);
    _707.x = (-_134.x) + _134.w;
    _123.x = (_123.x * _707.x) + _134.x;
    _160 = (-_123.x) + _160;
    _123.x = (_123.y * _160) + _123.x;
    _134 = frac(_88);
    _88 = floor(_88);
    _153 = _134 * _134;
    _134 = ((-_134) * 2.0f.xxxx) + 3.0f.xxxx;
    _134 *= _153;
    _153 = _88.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _761.x = dot(_153.zw, _191.zw);
    _160 = dot(_153.xy, _191.xy);
    float2 _777 = _160.xx + _153.xy;
    _153 = float4(_777.x, _777.y, _153.z, _153.w);
    _761 = _761.xx + _153.zw;
    _761.x = _761.y * _761.x;
    _761.y = _153.y * _153.x;
    _761 = frac(_761);
    _153 = _88 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _191.x = dot(_153.xy, _191.xy);
    _191.y = dot(_153.zw, _191.zw);
    _153 += _191.xxyy;
    _153.x = _153.y * _153.x;
    _153.x = frac(_153.x);
    _153.x = (-_761.x) + _153.x;
    _761.x = (_134.x * _153.x) + _761.x;
    _153.x = _153.w * _153.z;
    _191 = _88 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _88 = _88.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _88 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _88 = frac(_88);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _492.x = dot(_191.xy, _388.xy);
    _348.x = dot(_191.zw, _388.zw);
    _348 = _348.xx + _191.zw;
    float2 _891 = _492.xx + _191.xy;
    _191 = float4(_891.x, _891.y, _191.z, _191.w);
    _153.y = _191.y * _191.x;
    _153.z = _348.y * _348.x;
    float3 _908 = frac(_153.xyz);
    _153 = float4(_908.x, _908.y, _908.z, _153.w);
    _160 = _761.y + (-_153.y);
    _160 = (_134.x * _160) + _153.y;
    _761.x = (-_160) + _761.x;
    _761.x = (_134.y * _761.x) + _160;
    _761.x *= 0.25f;
    _123.x = (_123.x * 0.5f) + _761.x;
    _191 = _88 + 45.31999969482421875f.xxxx;
    _761.x = dot(_88.zw, _191.zw);
    _160 = dot(_88.xy, _191.xy);
    float2 _967 = _160.xx + _88.xy;
    _88 = float4(_967.x, _967.y, _88.z, _88.w);
    _761 = _761.xx + _88.zw;
    _761.x = _761.y * _761.x;
    _761.y = _88.y * _88.x;
    _761 = frac(_761);
    _761.x = (-_761.y) + _761.x;
    _761.x = (_134.z * _761.x) + _761.y;
    _160 = (-_153.z) + _153.x;
    _160 = (_134.z * _160) + _153.z;
    _761.x = (-_160) + _761.x;
    _761.x = (_134.w * _761.x) + _160;
    _123.x = (_761.x * 0.125f) + _123.x;
    _761.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _761.x = rsqrt(_761.x);
    float3 _1052 = _761.xxx * vs_TEXCOORD1;
    _88 = float4(_1052.x, _1052.y, _1052.z, _88.w);
    _761 = abs(_88.xz) + 0.001000000047497451305389404296875f.xx;
    _1061 = _761.y + _761.x;
    _761 /= _1061.xx;
    _123.x = _761.x * _123.x;
    _134 = floor(_68);
    _68 = frac(_68);
    _153 = _134 + 1.0f.xxxx;
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _761.x = dot(_153.xy, _191.xy);
    _1061 = dot(_153.zw, _191.zw);
    _348 = _1061.xx + _153.zw;
    float2 _1110 = _761.xx + _153.xy;
    _153 = float4(_1110.x, _1110.y, _153.z, _153.w);
    _761.x = _153.y * _153.x;
    _761.x = frac(_761.x);
    _1061 = _348.y * _348.x;
    _1061 = frac(_1061);
    _153 = _134.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _191.z = dot(_153.zw, _191.zw);
    _191.x = dot(_153.xy, _191.xy);
    _153 += _191.xxzz;
    float2 _1159 = _153.yw * _153.xz;
    _153 = float4(_1159.x, _153.y, _1159.y, _153.w);
    float2 _1164 = frac(_153.xz);
    _153 = float4(_1164.x, _153.y, _1164.y, _153.w);
    _761.x += (-_153.z);
    _191 = _68 * _68;
    _68 = ((-_68) * 2.0f.xxxx) + 3.0f.xxxx;
    _68 *= _191;
    _761.x = (_68.x * _761.x) + _153.z;
    _191 = _134 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = _134.zwzw + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _191 = frac(_191);
    _388 = _191 + 45.31999969482421875f.xxxx;
    _492.x = dot(_191.xy, _388.xy);
    _348.x = dot(_191.zw, _388.zw);
    _348 = _348.xx + _191.zw;
    float2 _1227 = _492.xx + _191.xy;
    _191 = float4(_1227.x, _1227.y, _191.z, _191.w);
    _492.x = _191.y * _191.x;
    _492.y = _348.y * _348.x;
    _492 = frac(_492);
    _153.x = (-_492.x) + _153.x;
    _68.x = (_68.x * _153.x) + _492.x;
    _761.x += (-_68.x);
    float2 _1274 = (_68.yy * _761.xx) + _68.xx;
    _191 = float4(_1274.x, _191.y, _1274.y, _191.w);
    _388 = _134 + 45.31999969482421875f.xxxx;
    _761.x = dot(_134.zw, _388.zw);
    _68.x = dot(_134.xy, _388.xy);
    float2 _1295 = _68.xx + _134.xy;
    _68 = float4(_1295.x, _1295.y, _68.z, _68.w);
    float2 _1302 = _761.xx + _134.zw;
    _134 = float4(_1302.x, _1302.y, _134.z, _134.w);
    _761.x = _134.y * _134.x;
    _761.x = frac(_761.x);
    _68.x = _68.y * _68.x;
    _68.x = frac(_68.x);
    _68.x = (-_492.y) + _68.x;
    _68.x = (_68.z * _68.x) + _492.y;
    _1341 = (-_761.x) + _1061;
    _761.x = (_68.z * _1341) + _761.x;
    _761.x = (-_68.x) + _761.x;
    float2 _1369 = (_68.ww * _761.xx) + _68.xx;
    _191 = float4(_191.x, _1369.x, _191.z, _1369.y);
    _68 = (_191 * 2.0f.xxxx) + (-1.0f).xxxx;
    _9 = (_68 * float4(float4(_17_m10, _17_m10, _17_m10, _17_m10))) + _9;
    float2 _1395 = frac(_9.zw);
    _68 = float4(_1395.x, _1395.y, _68.z, _68.w);
    _1398 = _68.xy * _68.xy;
    float2 _1408 = ((-_68.xy) * 2.0f.xx) + 3.0f.xx;
    _68 = float4(_1408.x, _1408.y, _68.z, _68.w);
    float2 _1414 = _68.xy * _1398;
    _68 = float4(_1414.x, _1414.y, _68.z, _68.w);
    _1398 = floor(_9.zw);
    _9 = (_9 * float4(2.0699999332427978515625f, 2.0699999332427978515625f, 4.13000011444091796875f, 4.13000011444091796875f)) + float4(1.7000000476837158203125f, 1.7000000476837158203125f, 3.099999904632568359375f, 3.099999904632568359375f);
    float2 _1424 = _1398 + 1.0f.xx;
    _134 = float4(_1424.x, _1424.y, _134.z, _134.w);
    float2 _1429 = _134.xy * float2(123.339996337890625f, 456.209991455078125f);
    _134 = float4(_1429.x, _1429.y, _134.z, _134.w);
    float2 _1434 = frac(_134.xy);
    _134 = float4(_1434.x, _1434.y, _134.z, _134.w);
    _140 = _134.xy + 45.31999969482421875f.xx;
    _761.x = dot(_134.xy, _140);
    float2 _1449 = _761.xx + _134.xy;
    _134 = float4(_1449.x, _1449.y, _134.z, _134.w);
    _761.x = _134.y * _134.x;
    _761.x = frac(_761.x);
    _134 = _1398.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _1398 *= float2(123.339996337890625f, 456.209991455078125f);
    _1398 = frac(_1398);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _153 = _134 + 45.31999969482421875f.xxxx;
    _1061 = dot(_134.zw, _153.zw);
    _153.x = dot(_134.xy, _153.xy);
    float2 _1490 = _134.xy + _153.xx;
    _134 = float4(_1490.x, _1490.y, _134.z, _134.w);
    _140 = _1061.xx + _134.zw;
    _1061 = _140.y * _140.x;
    _1061 = frac(_1061);
    _134.x = _134.y * _134.x;
    _134.x = frac(_134.x);
    _761.x += (-_1061);
    _761.x = (_68.x * _761.x) + _1061;
    float2 _1530 = _1398 + 45.31999969482421875f.xx;
    _707 = float3(_1530.x, _1530.y, _707.z);
    _1061 = dot(_1398, _707.xy);
    _1398 += _1061.xx;
    _1398.x = _1398.y * _1398.x;
    _1398.x = frac(_1398.x);
    _195 = (-_1398.x) + _134.x;
    _68.x = (_68.x * _195) + _1398.x;
    _761.x += (-_68.x);
    _761.x = (_68.y * _761.x) + _68.x;
    _68 = frac(_9);
    _9 = floor(_9);
    _134 = _68 * _68;
    _68 = ((-_68) * 2.0f.xxxx) + 3.0f.xxxx;
    _68 *= _134;
    _134 = _9.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _134 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _134 = frac(_134);
    _153 = _134 + 45.31999969482421875f.xxxx;
    _1061 = dot(_134.zw, _153.zw);
    _153.x = dot(_134.xy, _153.xy);
    float2 _1619 = _134.xy + _153.xx;
    _134 = float4(_1619.x, _1619.y, _134.z, _134.w);
    _140 = _1061.xx + _134.zw;
    _1061 = _140.y * _140.x;
    _1061 = frac(_1061);
    _134.x = _134.y * _134.x;
    _153 = _9 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _153 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _707.x = dot(_153.xy, _191.xy);
    _140.x = dot(_153.zw, _191.zw);
    _140 = _140.xx + _153.zw;
    float2 _1669 = _707.xx + _153.xy;
    _153 = float4(_1669.x, _1669.y, _153.z, _153.w);
    _134.y = _153.y * _153.x;
    float2 _1680 = frac(_134.xy);
    _134 = float4(_1680.x, _1680.y, _134.z, _134.w);
    _707.x = (-_1061) + _134.y;
    _1061 = (_68.x * _707.x) + _1061;
    _707.x = _140.y * _140.x;
    _153 = _9 * float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _9 = _9.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _9 *= float4(123.339996337890625f, 456.209991455078125f, 123.339996337890625f, 456.209991455078125f);
    _9 = frac(_9);
    _153 = frac(_153);
    _191 = _153 + 45.31999969482421875f.xxxx;
    _140.x = dot(_153.xy, _191.xy);
    _635 = dot(_153.zw, _191.zw);
    _348 = _635.xx + _153.zw;
    _140 = _140.xx + _153.xy;
    _707.y = _140.y * _140.x;
    _707.z = _348.y * _348.x;
    _707 = frac(_707);
    _134.x = (-_707.y) + _134.x;
    _68.x = (_68.x * _134.x) + _707.y;
    _1061 = (-_68.x) + _1061;
    _68.x = (_68.y * _1061) + _68.x;
    _68.x *= 0.25f;
    _761.x = (_761.x * 0.5f) + _68.x;
    _153 = _9 + 45.31999969482421875f.xxxx;
    _68.x = dot(_9.zw, _153.zw);
    _68.y = dot(_9.xy, _153.xy);
    _9 += _68.yyxx;
    float2 _1812 = _9.yw * _9.xz;
    _9 = float4(_1812.x, _9.y, _1812.y, _9.w);
    float2 _1817 = frac(_9.xz);
    _9 = float4(_1817.x, _9.y, _1817.y, _9.w);
    _1820.x = (-_9.x) + _9.z;
    _9.x = (_68.z * _1820.x) + _9.x;
    _1820.x = (-_707.z) + _707.x;
    _1820.x = (_68.z * _1820.x) + _707.z;
    _9.x = (-_1820.x) + _9.x;
    _9.x = (_68.w * _9.x) + _1820.x;
    _9.x = (_9.x * 0.125f) + _761.x;
    _9.x = _761.y * _9.x;
    _9.x *= 1.14285719394683837890625f;
    _9.x = (_123.x * 1.14285719394683837890625f) + _9.x;
    _1894.x = _17_m6 + 1.0f;
    _9.x = (_9.x * _1894.x) + (-0.25f);
    _1820 = (-vs_TEXCOORD0) + _17_m1;
    _123.x = dot(_1820, _1820);
    _123.x = rsqrt(_123.x);
    _1820 *= _123.xxx;
    _1820.x = dot(_88.xyz, _1820);
    _1820.x = clamp(_1820.x, 0.0f, 1.0f);
    _1894.x = _1820.x * _17_m7;
    _9.x = (_1894.x * 0.5f) + _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1894.x = (_9.x * _17_m15) + 0.5f;
    _1894.x = floor(_1894.x);
    _1894.x /= _17_m15;
    _1894.y = _1894.x + (-0.449999988079071044921875f);
    float2 _1980 = _1894.xy * 2.22222232818603515625f.xx;
    _1894 = float4(_1980.x, _1980.y, _1894.z, _1894.w);
    float2 _1987 = clamp(_1894.xy, 0.0f.xx, 1.0f.xx);
    _1894 = float4(_1987.x, _1987.y, _1894.z, _1894.w);
    _1990 = (_1894.y * (-2.0f)) + 3.0f;
    _1996 = _1894.y * _1894.y;
    _1996 *= _1990;
    _1990 = (_1894.x * (-2.0f)) + 3.0f;
    _1894.x *= _1894.x;
    _1894.x *= _1990;
    _2020 = (-_17_m2.xyz) + _17_m3.xyz;
    float3 _2039 = (_1894.xxx * _2020) + _17_m2.xyz;
    _1894 = float4(_2039.x, _1894.y, _2039.y, _2039.z);
    _2020 = (-_1894.xzw) + _17_m4.xyz;
    float3 _2056 = (_1996.xxx * _2020) + _1894.xzw;
    _1894 = float4(_2056.x, _2056.y, _2056.z, _1894.w);
    _9.x = floor(_38.x);
    _2063 = frac(_38.x);
    _9.y = 0.0f;
    _38 = _9.xy + float2(1.0f, 0.0f);
    float2 _2074 = _9.xy * float2(123.339996337890625f, 456.209991455078125f);
    _9 = float4(_2074.x, _2074.y, _9.z, _9.w);
    _38 *= float2(123.339996337890625f, 456.209991455078125f);
    _38 = frac(_38);
    _2081 = _38.x + 45.31999969482421875f;
    _38 = (_38.xx * _2081.xx) + _38;
    _9.w = _38.y * _38.x;
    float3 _2100 = frac(_9.xyw);
    _9 = float4(_2100.x, _2100.y, _9.z, _2100.z);
    _38.x = _9.x + 45.31999969482421875f;
    float2 _2114 = (_9.xx * _38.xx) + _9.xy;
    _9 = float4(_2114.x, _2114.y, _9.z, _9.w);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1820.x = (-_9.x) + _9.w;
    _2081 = _2063 * _2063;
    _2063 = ((-_2063) * 2.0f) + 3.0f;
    _2063 *= _2081;
    _9.x = (_2063 * _1820.x) + _9.x;
    _2152 = (-_17_m12) + 1.0f;
    _9.x = (_17_m12 * _9.x) + _2152;
    _2152 = _9.x * _17_m5;
    float3 _2178 = _2152.xxx * _1894.xyz;
    _2173 = float4(_2178.x, _2178.y, _2178.z, _2173.w);
    _2173.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2173 = _2173;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}