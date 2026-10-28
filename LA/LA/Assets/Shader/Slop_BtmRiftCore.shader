// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmRiftCore" {
Properties {

_DeepColor ("Deep", Color) = (0.05,0.15,0.55,1)

_MidColor ("Mid", Color) = (0.3,0.75,1,1)

_HotColor ("Hot", Color) = (0.9,0.98,1,1)

_HaloColor ("Halo", Color) = (0.12,0.35,0.75,1)

_QuadHalfSize ("Quad Half Size (m)", Float) = 1.600000023841858

_TearRadius ("Tear Radius (m)", Float) = 0.550000011920929

_Intensity ("Intensity", Range(0, 3)) = 1.0

_Surge ("Surge", Range(0, 1)) = 0.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One One
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
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
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
    vs_TEXCOORD0 = float3(_11.xy.x, _11.xy.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = 0.0f;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
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
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _DeepColor;
float4 _MidColor;
float4 _HotColor;
float4 _HaloColor;
float _QuadHalfSize;
float _TearRadius;
float _Intensity;
float _Surge;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _Time
#define _16_m1 _WorldSpaceCameraPos
#define _16_m3 _DeepColor
#define _16_m4 _MidColor
#define _16_m5 _HotColor
#define _16_m6 _HaloColor
#define _16_m7 _QuadHalfSize
#define _16_m8 _TearRadius
#define _16_m9 _Intensity
#define _16_m10 _Surge



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _2489;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _2489 : SV_Target0;
};

static float3 _9;
static float2 _40;
static float _49;
static float3 _55;
static float2 _80;
static float4 _94;
static float4 _105;
static float4 _110;
static float4 _132;
static float4 _154;
static float4 _164;
static float _167;
static float3 _364;
static bool _604;
static bool _609;
static float _646;
static float _651;
static float2 _775;
static float4 _809;
static float4 _1133;
static float _1218;
static float4 _1511;
static float _1585;
static float2 _1766;
static float2 _1805;
static float _1901;
static float3 _2053;
static float3 _2071;
static float _2396;

void frag_inner()
{
    __unity_init();
    float2 _36 = (float2(float2(_16_m10, _16_m10)) * float2(1.2000000476837158203125f, 0.0199999995529651641845703125f)) + float2(1.0f, 0.02500000037252902984619140625f);
    _9 = float3(_36.x, _36.y, _9.z);
    _40 = vs_TEXCOORD0.xy * float2(1.0f, 0.769230782985687255859375f);
    _49 = dot(_40, _40);
    _49 = sqrt(_49);
    _55.x = max(_49, 9.9999997473787516355514526367188e-05f);
    _40 /= _55.xx;
    _55.x = _40.y * _40.x;
    _55.x = abs(_55.x) + abs(_55.x);
    _80.x = _55.x * _55.x;
    _55.x = _80.x * _55.x;
    _94 = (_40.xyxy * float4(5.0f, 5.0f, 13.0f, 13.0f)) + float4(3.099999904632568359375f, 3.099999904632568359375f, 9.69999980926513671875f, 9.69999980926513671875f);
    _105 = floor(_94);
    _94 = frac(_94);
    _110 = _94 * _94;
    _94 = ((-_94) * 2.0f.xxxx) + 3.0f.xxxx;
    _94 *= _110;
    _110 = _105 * float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _110 = frac(_110);
    _132 = _110 + 23.450000762939453125f.xxxx;
    _80.x = dot(_110.xy, _132.xy);
    _80 = _80.xx + _110.xy;
    _80.x = _80.y * _80.x;
    _154 = _105.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _154 = frac(_154);
    _164 = _154 + 23.450000762939453125f.xxxx;
    _167 = dot(_154.xy, _164.xy);
    float2 _177 = _167.xx + _154.xy;
    _110 = float4(_177.x, _177.y, _110.z, _110.w);
    _80.y = _110.y * _110.x;
    _80 = frac(_80);
    _167 = (-_80.x) + _80.y;
    _80.x = (_94.x * _167) + _80.x;
    _167 = dot(_154.zw, _164.zw);
    float2 _211 = _167.xx + _154.zw;
    _110 = float4(_211.x, _211.y, _110.z, _110.w);
    _167 = _110.y * _110.x;
    _167 = frac(_167);
    _154 = _105 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _154 = frac(_154);
    _164 = _154 + 23.450000762939453125f.xxxx;
    _105.x = dot(_154.xy, _164.xy);
    float2 _240 = _105.xx + _154.xy;
    _105 = float4(_240.x, _240.y, _105.z, _105.w);
    _105.x = _105.y * _105.x;
    _105.x = frac(_105.x);
    _105.x = (-_167) + _105.x;
    _167 = (_94.x * _105.x) + _167;
    _167 = (-_80.x) + _167;
    _80.x = (_94.y * _167) + _80.x;
    _167 = dot(_110.zw, _132.zw);
    float2 _288 = _167.xx + _110.zw;
    _94 = float4(_288.x, _288.y, _94.z, _94.w);
    _167 = _94.y * _94.x;
    _167 = frac(_167);
    _94.x = dot(_154.zw, _164.zw);
    float2 _308 = _94.xx + _154.zw;
    _94 = float4(_308.x, _308.y, _94.z, _94.w);
    _94.x = _94.y * _94.x;
    _94.x = frac(_94.x);
    _94.x = (-_167) + _94.x;
    _167 = (_94.z * _94.x) + _167;
    _105 = _105.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _105 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _105 = frac(_105);
    _110 = _105 + 23.450000762939453125f.xxxx;
    _94.x = dot(_105.xy, _110.xy);
    float2 _355 = _94.xx + _105.xy;
    _94 = float4(_355.x, _355.y, _94.z, _94.w);
    _94.x = _94.y * _94.x;
    _364.x = dot(_105.zw, _110.zw);
    float2 _375 = _364.xx + _105.zw;
    _105 = float4(_375.x, _375.y, _105.z, _105.w);
    _94.y = _105.y * _105.x;
    float2 _386 = frac(_94.xy);
    _94 = float4(_386.x, _386.y, _94.z, _94.w);
    _364.x = (-_94.x) + _94.y;
    _94.x = (_94.z * _364.x) + _94.x;
    _94.x = (-_167) + _94.x;
    _167 = (_94.w * _94.x) + _167;
    _167 *= 0.25f;
    _80.x = (_80.x * 0.5f) + _167;
    _80.x = (_80.x * 0.550000011920928955078125f) + 0.62000000476837158203125f;
    _55.x = (_55.x * 0.89999997615814208984375f) + _80.x;
    _55.x *= _16_m8;
    _80 = _16_m0.yy * float2(1.7000000476837158203125f, 0.07999999821186065673828125f);
    _80.x = sin(_80.x);
    _80.x = (_80.x * 0.039999999105930328369140625f) + 1.0f;
    _80.x = (_16_m10 * 0.25f) + _80.x;
    _94.x = _80.x * _55.x;
    _364.x = _94.x * 0.180000007152557373046875f;
    float2 _496 = ((-_94.xx) * float2(0.819999992847442626953125f, 0.89999997615814208984375f)) + _49.xx;
    _94 = float4(_496.x, _94.y, _496.y, _94.w);
    _364.x = 1.0f / _364.x;
    _94.x = _364.x * _94.x;
    _94.x = clamp(_94.x, 0.0f, 1.0f);
    _364.x = (_94.x * (-2.0f)) + 3.0f;
    _94.x *= _94.x;
    _94.x = ((-_364.x) * _94.x) + 1.0f;
    float3 _542 = _16_m1.yyy * _16_m2[1].xyz;
    _105 = float4(_542.x, _542.y, _542.z, _105.w);
    float3 _554 = (_16_m2[0].xyz * _16_m1.xxx) + _105.xyz;
    _105 = float4(_554.x, _554.y, _554.z, _105.w);
    float3 _566 = (_16_m2[2].xyz * _16_m1.zzz) + _105.xyz;
    _105 = float4(_566.x, _566.y, _566.z, _105.w);
    float3 _575 = _105.xyz + _16_m2[3].xyz;
    _105 = float4(_575.x, _575.y, _575.z, _105.w);
    float3 _582 = (-_105.xyz) + vs_TEXCOORD0;
    _105 = float4(_582.x, _582.y, _582.z, _105.w);
    _364.x = dot(_105.xyz, _105.xyz);
    _364.x = rsqrt(_364.x);
    float3 _599 = _364.xxx * _105.xyz;
    _105 = float4(_599.x, _599.y, _599.z, _105.w);
    _604 = 0.001000000047497451305389404296875f < _94.x;
    _609 = _105.z < (-0.0199999995529651641845703125f);
    _604 = _609 && _604;
    if (_604)
    {
        _110 = float4(0.25f, 0.800000011920928955078125f, 2.0499999523162841796875f, 4.0f) / (-_105.zzzz);
        _132 = (_105.xyxy * _110.xxyy) + vs_TEXCOORD0.xyxy;
        _364.x = dot(_132.xy, _132.xy);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-2.3083121776580810546875f);
        _651 = _9.x * _16_m0.y;
        _154 = _651.xxxx * float4(0.3499999940395355224609375f, 0.4699999988079071044921875f, 0.589999973773956298828125f, 0.709999978542327880859375f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.x);
        _110.x = sin(_651);
        _154.x = cos(_651);
        float2 _683 = _110.xx * _132.yx;
        _110 = float4(_683.x, _683.y, _110.z, _110.w);
        _164.x = (_132.x * _154.x) + (-_110.x);
        _164.y = (_132.y * _154.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _713 = _164.xy / _364.xx;
        _110 = float4(_713.x, _713.y, _110.z, _110.w);
        _364.x = _16_m0.y * 0.1500000059604644775390625f;
        float2 _728 = (_110.xy * 9.0f.xx) + _364.xx;
        _110 = float4(_728.x, _728.y, _110.z, _110.w);
        float2 _733 = floor(_110.xy);
        _132 = float4(_733.x, _733.y, _132.z, _132.w);
        float2 _738 = frac(_110.xy);
        _110 = float4(_738.x, _738.y, _110.z, _110.w);
        float2 _745 = _110.xy * _110.xy;
        _164 = float4(_745.x, _745.y, _164.z, _164.w);
        float2 _754 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_754.x, _754.y, _110.z, _110.w);
        float2 _761 = _110.xy * _164.xy;
        _110 = float4(_761.x, _761.y, _110.z, _110.w);
        float2 _767 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _164 = float4(_767.x, _767.y, _164.z, _164.w);
        float2 _772 = frac(_164.xy);
        _164 = float4(_772.x, _772.y, _164.z, _164.w);
        _775 = _164.xy + 23.450000762939453125f.xx;
        _364.x = dot(_164.xy, _775);
        float2 _789 = _364.xx + _164.xy;
        _164 = float4(_789.x, _789.y, _164.z, _164.w);
        _364.x = _164.y * _164.x;
        _364.x = frac(_364.x);
        _164 = _132.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _164 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _164 = frac(_164);
        _809 = _164 + 23.450000762939453125f.xxxx;
        _651 = dot(_164.xy, _809.xy);
        float2 _821 = _651.xx + _164.xy;
        _164 = float4(_821.x, _821.y, _164.z, _164.w);
        _651 = _164.y * _164.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_164.zw, _809.zw);
        float2 _853 = _651.xx + _164.zw;
        _164 = float4(_853.x, _853.y, _164.z, _164.w);
        _651 = _164.y * _164.x;
        _651 = frac(_651);
        float2 _866 = _132.xy + 1.0f.xx;
        _132 = float4(_866.x, _866.y, _132.z, _132.w);
        float2 _871 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_871.x, _871.y, _132.z, _132.w);
        float2 _876 = frac(_132.xy);
        _132 = float4(_876.x, _876.y, _132.z, _132.w);
        float2 _881 = _132.xy + 23.450000762939453125f.xx;
        _164 = float4(_881.x, _881.y, _164.z, _164.w);
        _154.x = dot(_132.xy, _164.xy);
        float2 _894 = _132.xy + _154.xx;
        _132 = float4(_894.x, _894.y, _132.z, _132.w);
        _132.x = _132.y * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_651) + _132.x;
        _651 = (_110.x * _132.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _960 = _364.xxx * _16_m4.xyz;
        _164 = float4(_960.x, _960.y, _960.z, _164.w);
        _364.x = dot(_132.zw, _132.zw);
        _364.x = sqrt(_364.x);
        _651 = _364.x * (-2.8853900432586669921875f);
        _110.x = (_364.x * 1.7999999523162841796875f) + (-_154.y);
        _110.x += 1.2999999523162841796875f;
        _132.x = cos(_110.x);
        _110.x = sin(_110.x);
        float2 _1002 = _110.xx * _132.wz;
        _110 = float4(_1002.x, _1002.y, _110.z, _110.w);
        _154.x = (_132.z * _132.x) + (-_110.x);
        _154.y = (_132.w * _132.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1032 = _154.xy / _364.xx;
        _110 = float4(_1032.x, _1032.y, _110.z, _110.w);
        float3 _1044 = (_16_m0.yyy * 0.1500000059604644775390625f.xxx) + float3(7.099999904632568359375f, 14.19999980926513671875f, 21.299999237060546875f);
        _132 = float4(_1044.x, _1044.y, _1044.z, _132.w);
        float2 _1054 = (_110.xy * 12.0f.xx) + _132.xx;
        _110 = float4(_1054.x, _1054.y, _110.z, _110.w);
        float2 _1059 = floor(_110.xy);
        _132 = float4(_1059.x, _132.y, _132.z, _1059.y);
        float2 _1064 = frac(_110.xy);
        _110 = float4(_1064.x, _1064.y, _110.z, _110.w);
        float2 _1071 = _110.xy * _110.xy;
        _154 = float4(_1071.x, _1071.y, _154.z, _154.w);
        float2 _1078 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1078.x, _1078.y, _110.z, _110.w);
        float2 _1085 = _110.xy * _154.xy;
        _110 = float4(_1085.x, _1085.y, _110.z, _110.w);
        float2 _1090 = _132.xw * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1090.x, _1090.y, _154.z, _154.w);
        float2 _1095 = frac(_154.xy);
        _154 = float4(_1095.x, _1095.y, _154.z, _154.w);
        float2 _1100 = _154.xy + 23.450000762939453125f.xx;
        _809 = float4(_1100.x, _1100.y, _809.z, _809.w);
        _364.x = dot(_154.xy, _809.xy);
        float2 _1113 = _364.xx + _154.xy;
        _154 = float4(_1113.x, _1113.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _809 = _132.xwxw + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _809 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _809 = frac(_809);
        _1133 = _809 + 23.450000762939453125f.xxxx;
        _154.x = dot(_809.xy, _1133.xy);
        float2 _1146 = _154.xx + _809.xy;
        _154 = float4(_1146.x, _1146.y, _154.z, _154.w);
        _154.x = _154.y * _154.x;
        _154.x = frac(_154.x);
        _154.x = (-_364.x) + _154.x;
        _364.x = (_110.x * _154.x) + _364.x;
        _154.x = dot(_809.zw, _1133.zw);
        float2 _1185 = _154.xx + _809.zw;
        _154 = float4(_1185.x, _1185.y, _154.z, _154.w);
        _154.x = _154.y * _154.x;
        _154.x = frac(_154.x);
        float2 _1200 = _132.xw + 1.0f.xx;
        _132 = float4(_1200.x, _132.y, _132.z, _1200.y);
        float2 _1205 = _132.xw * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_1205.x, _132.y, _132.z, _1205.y);
        float2 _1210 = frac(_132.xw);
        _132 = float4(_1210.x, _132.y, _132.z, _1210.y);
        float2 _1215 = _132.xw + 23.450000762939453125f.xx;
        _809 = float4(_1215.x, _1215.y, _809.z, _809.w);
        _1218 = dot(_132.xw, _809.xy);
        float2 _1228 = _132.xw + _1218.xx;
        _132 = float4(_1228.x, _132.y, _132.z, _1228.y);
        _132.x = _132.w * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_154.x) + _132.x;
        _110.x = (_110.x * _132.x) + _154.x;
        _110.x = (-_364.x) + _110.x;
        _364.x = (_110.y * _110.x) + _364.x;
        _110.x = _364.x * _364.x;
        _110.x *= _110.x;
        _364.x *= _110.x;
        _651 = exp2(_651);
        float3 _1300 = _16_m3.xyz + (-_16_m4.xyz);
        _809 = float4(_1300.x, _1300.y, _1300.z, _809.w);
        float3 _1311 = (_809.xyz * 0.3333333432674407958984375f.xxx) + _16_m4.xyz;
        _1133 = float4(_1311.x, _1311.y, _1311.z, _1133.w);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1323 = _364.xxx * _1133.xyz;
        _1133 = float4(_1323.x, _1323.y, _1323.z, _1133.w);
        float3 _1330 = _651.xxx * _1133.xyz;
        _1133 = float4(_1330.x, _1330.y, _1330.z, _1133.w);
        float3 _1337 = _1133.xyz * 0.625f.xxx;
        _1133 = float4(_1337.x, _1337.y, _1337.z, _1133.w);
        float3 _1347 = (_164.xyz * _646.xxx) + _1133.xyz;
        _164 = float4(_1347.x, _1347.y, _1347.z, _164.w);
        _110 = (_105.xyxy * _110.zzww) + vs_TEXCOORD0.xyxy;
        _364.x = dot(_110.xy, _110.xy);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-3.46246814727783203125f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.z);
        _651 += 2.599999904632568359375f;
        _132.x = sin(_651);
        _154.x = cos(_651);
        float2 _1392 = _110.yx * _132.xx;
        _132 = float4(_1392.x, _132.y, _132.z, _1392.y);
        _1133.x = (_110.x * _154.x) + (-_132.x);
        _1133.y = (_110.y * _154.x) + _132.w;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1422 = _1133.xy / _364.xx;
        _110 = float4(_1422.x, _1422.y, _110.z, _110.w);
        float2 _1432 = (_110.xy * 15.0f.xx) + _132.yy;
        _110 = float4(_1432.x, _1432.y, _110.z, _110.w);
        float2 _1437 = floor(_110.xy);
        _132 = float4(_1437.x, _1437.y, _132.z, _132.w);
        float2 _1442 = frac(_110.xy);
        _110 = float4(_1442.x, _1442.y, _110.z, _110.w);
        float2 _1449 = _110.xy * _110.xy;
        _154 = float4(_1449.x, _1449.y, _154.z, _154.w);
        float2 _1456 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1456.x, _1456.y, _110.z, _110.w);
        float2 _1463 = _110.xy * _154.xy;
        _110 = float4(_1463.x, _1463.y, _110.z, _110.w);
        float2 _1468 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1468.x, _1468.y, _154.z, _154.w);
        float2 _1473 = frac(_154.xy);
        _154 = float4(_1473.x, _1473.y, _154.z, _154.w);
        float2 _1478 = _154.xy + 23.450000762939453125f.xx;
        _1133 = float4(_1478.x, _1478.y, _1133.z, _1133.w);
        _364.x = dot(_154.xy, _1133.xy);
        float2 _1491 = _364.xx + _154.xy;
        _154 = float4(_1491.x, _1491.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _1133 = _132.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _1133 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _1133 = frac(_1133);
        _1511 = _1133 + 23.450000762939453125f.xxxx;
        _651 = dot(_1133.xy, _1511.xy);
        float2 _1523 = _651.xx + _1133.xy;
        _154 = float4(_1523.x, _1523.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_1133.zw, _1511.zw);
        float2 _1555 = _651.xx + _1133.zw;
        _154 = float4(_1555.x, _1555.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        float2 _1567 = _132.xy + 1.0f.xx;
        _132 = float4(_1567.x, _1567.y, _132.z, _132.w);
        float2 _1572 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_1572.x, _1572.y, _132.z, _132.w);
        float2 _1577 = frac(_132.xy);
        _132 = float4(_1577.x, _1577.y, _132.z, _132.w);
        float2 _1582 = _132.xy + 23.450000762939453125f.xx;
        _154 = float4(_1582.x, _1582.y, _154.z, _154.w);
        _1585 = dot(_132.xy, _154.xy);
        float2 _1595 = _1585.xx + _132.xy;
        _132 = float4(_1595.x, _1595.y, _132.z, _132.w);
        _132.x = _132.y * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_651) + _132.x;
        _651 = (_110.x * _132.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        float3 _1657 = (_809.xyz * 0.666666686534881591796875f.xxx) + _16_m4.xyz;
        _132 = float4(_1657.x, _1657.y, _132.z, _1657.z);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1669 = _364.xxx * _132.xyw;
        _132 = float4(_1669.x, _1669.y, _132.z, _1669.z);
        float3 _1676 = _646.xxx * _132.xyw;
        _132 = float4(_1676.x, _1676.y, _132.z, _1676.z);
        float3 _1686 = (_132.xyw * 0.454545438289642333984375f.xxx) + _164.xyz;
        _132 = float4(_1686.x, _1686.y, _132.z, _1686.z);
        _364.x = dot(_110.zw, _110.zw);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-4.039546489715576171875f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.w);
        _651 += 3.8999998569488525390625f;
        _110.x = sin(_651);
        _154.x = cos(_651);
        float2 _1723 = _110.xx * _110.wz;
        _110 = float4(_1723.x, _1723.y, _110.z, _110.w);
        _164.x = (_110.z * _154.x) + (-_110.x);
        _164.y = (_110.w * _154.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1753 = _164.xy / _364.xx;
        _110 = float4(_1753.x, _1753.y, _110.z, _110.w);
        float2 _1763 = (_110.xy * 18.0f.xx) + _132.zz;
        _110 = float4(_1763.x, _1763.y, _110.z, _110.w);
        _1766 = floor(_110.xy);
        float2 _1772 = frac(_110.xy);
        _110 = float4(_1772.x, _1772.y, _110.z, _110.w);
        float2 _1779 = _110.xy * _110.xy;
        _154 = float4(_1779.x, _1779.y, _154.z, _154.w);
        float2 _1786 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1786.x, _1786.y, _110.z, _110.w);
        float2 _1793 = _110.xy * _154.xy;
        _110 = float4(_1793.x, _1793.y, _110.z, _110.w);
        float2 _1797 = _1766 * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1797.x, _1797.y, _154.z, _154.w);
        float2 _1802 = frac(_154.xy);
        _154 = float4(_1802.x, _1802.y, _154.z, _154.w);
        _1805 = _154.xy + 23.450000762939453125f.xx;
        _364.x = dot(_154.xy, _1805);
        float2 _1818 = _364.xx + _154.xy;
        _154 = float4(_1818.x, _1818.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _154 = _1766.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _154 = frac(_154);
        _164 = _154 + 23.450000762939453125f.xxxx;
        _651 = dot(_154.xy, _164.xy);
        float2 _1849 = _651.xx + _154.xy;
        _154 = float4(_1849.x, _1849.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_154.zw, _164.zw);
        float2 _1881 = _651.xx + _154.zw;
        _154 = float4(_1881.x, _1881.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _1766 += 1.0f.xx;
        _1766 *= float2(233.339996337890625f, 851.72998046875f);
        _1766 = frac(_1766);
        float2 _1898 = _1766 + 23.450000762939453125f.xx;
        _154 = float4(_1898.x, _1898.y, _154.z, _154.w);
        _1901 = dot(_1766, _154.xy);
        _1766 += _1901.xx;
        _1766.x = _1766.y * _1766.x;
        _1766.x = frac(_1766.x);
        _1766.x = (-_651) + _1766.x;
        _651 = (_110.x * _1766.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1971 = _364.xxx * _16_m3.xyz;
        _110 = float4(_1971.x, _1971.y, _1971.z, _110.w);
        float3 _1978 = _646.xxx * _110.xyz;
        _110 = float4(_1978.x, _1978.y, _1978.z, _110.w);
        float3 _1988 = (_110.xyz * 0.3571428358554840087890625f.xxx) + _132.xyw;
        _110 = float4(_1988.x, _1988.y, _1988.z, _110.w);
        _364.x = 1.7999999523162841796875f / (-_105.z);
        float2 _2003 = (_105.xy * _364.xx) + vs_TEXCOORD0.xy;
        _364 = float3(_2003.x, _364.y, _2003.y);
        _364.x = dot(_364.xz, _364.xz);
        _364.x *= (-7.21347522735595703125f);
        _364.x = exp2(_364.x);
        float3 _2027 = _364.xxx * _16_m5.xyz;
        _105 = float4(_2027.x, _2027.y, _2027.z, _105.w);
        float3 _2036 = (_105.xyz * 1.2999999523162841796875f.xxx) + _110.xyz;
        _105 = float4(_2036.x, _2036.y, _2036.z, _105.w);
    }
    else
    {
        _105.x = 0.0f;
        _105.y = 0.0f;
        _105.z = 0.0f;
    }
    float3 _2050 = (_16_m3.xyz * 0.3499999940395355224609375f.xxx) + _105.xyz;
    _105 = float4(_2050.x, _2050.y, _2050.z, _105.w);
    _2053.x = (-abs(_94.z)) / _9.y;
    _2053.x *= 1.44269502162933349609375f;
    _2053.x = exp2(_2053.x);
    _2071 = (-_16_m4.xyz) + _16_m5.xyz;
    _2071 = (_2071 * 0.5f.xxx) + _16_m4.xyz;
    _364 = _2053.xxx * _2071;
    _364 *= 0.89999997615814208984375f.xxx;
    _364 = (_105.xyz * _94.xxx) + _364;
    float2 _2108 = _16_m7.xx * float2(0.46153843402862548828125f, 0.100000001490116119384765625f);
    _105 = float4(_2108.x, _2108.y, _105.z, _105.w);
    _2053.x = ((-_16_m7) * 0.2307692468166351318359375f) + _49;
    float2 _2121 = 1.0f.xx / _105.xy;
    _105 = float4(_2121.x, _2121.y, _105.z, _105.w);
    _2053.x *= _105.x;
    _2053.x = clamp(_2053.x, 0.0f, 1.0f);
    _105.x = (_2053.x * (-2.0f)) + 3.0f;
    _2053.x *= _2053.x;
    _2053.x = ((-_105.x) * _2053.x) + 1.0f;
    _55.x = ((-_55.x) * _80.x) + _49;
    _55.x = max(_55.x, 0.0f);
    _55.x *= (-5.193702220916748046875f);
    _55.x = exp2(_55.x);
    _80.x = (-_94.x) + 1.0f;
    _55.x = _80.x * _55.x;
    _40 = (_40 * 22.0f.xx) + _80.yy;
    float2 _2194 = floor(_40);
    _105 = float4(_2194.x, _105.y, _2194.y, _105.w);
    _40 = frac(_40);
    float2 _2201 = _40 * _40;
    _110 = float4(_2201.x, _2201.y, _110.z, _110.w);
    _40 = ((-_40) * 2.0f.xx) + 3.0f.xx;
    _40 *= _110.xy;
    float2 _2214 = _105.xz * float2(233.339996337890625f, 851.72998046875f);
    _110 = float4(_2214.x, _2214.y, _110.z, _110.w);
    float2 _2219 = frac(_110.xy);
    _110 = float4(_2219.x, _2219.y, _110.z, _110.w);
    _1766 = _110.xy + 23.450000762939453125f.xx;
    _167 = dot(_110.xy, _1766);
    float2 _2233 = _167.xx + _110.xy;
    _110 = float4(_2233.x, _2233.y, _110.z, _110.w);
    _167 = _110.y * _110.x;
    _167 = frac(_167);
    _110 = _105.xzxz + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _110 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _110 = frac(_110);
    _132 = _110 + 23.450000762939453125f.xxxx;
    _94.x = dot(_110.xy, _132.xy);
    float2 _2262 = _94.xx + _110.xy;
    _110 = float4(_2262.x, _2262.y, _110.z, _110.w);
    _94.x = _110.y * _110.x;
    _94.x = frac(_94.x);
    _94.x = (-_167) + _94.x;
    _167 = (_40.x * _94.x) + _167;
    _94.x = dot(_110.zw, _132.zw);
    float2 _2298 = _94.xx + _110.zw;
    _110 = float4(_2298.x, _2298.y, _110.z, _110.w);
    _94.x = _110.y * _110.x;
    _94.x = frac(_94.x);
    float2 _2313 = _105.xz + 1.0f.xx;
    _105 = float4(_2313.x, _105.y, _2313.y, _105.w);
    float2 _2318 = _105.xz * float2(233.339996337890625f, 851.72998046875f);
    _105 = float4(_2318.x, _105.y, _2318.y, _105.w);
    float2 _2323 = frac(_105.xz);
    _105 = float4(_2323.x, _105.y, _2323.y, _105.w);
    float2 _2328 = _105.xz + 23.450000762939453125f.xx;
    _110 = float4(_2328.x, _2328.y, _110.z, _110.w);
    _651 = dot(_105.xz, _110.xy);
    float2 _2340 = _651.xx + _105.xz;
    _105 = float4(_2340.x, _105.y, _2340.y, _105.w);
    _105.x = _105.z * _105.x;
    _105.x = frac(_105.x);
    _105.x = (-_94.x) + _105.x;
    _40.x = (_40.x * _105.x) + _94.x;
    _40.x = (-_167) + _40.x;
    _2053.y = (_40.y * _40.x) + _167;
    float2 _2387 = _2053.xy * _2053.xy;
    _2053 = float3(_2387.x, _2387.y, _2053.z);
    _40.x = _2053.y * _2053.y;
    _2396 = _49 * (-3.1739292144775390625f);
    _2396 = exp2(_2396);
    _40.x = _2396 * _40.x;
    _40.x = _80.x * _40.x;
    _40.x *= 0.60000002384185791015625f;
    _40.x = (_55.x * 0.449999988079071044921875f) + _40.x;
    _55 = _40.xxx * _16_m6.xyz;
    _2053 = (_55 * _2053.xxx) + _364;
    _49 = ((-_16_m7) * 0.653846204280853271484375f) + _49;
    _49 = _105.y * _49;
    _49 = clamp(_49, 0.0f, 1.0f);
    _55.x = (_49 * (-2.0f)) + 3.0f;
    _49 *= _49;
    _49 = ((-_55.x) * _49) + 1.0f;
    _49 *= _16_m9;
    _9.x *= _49;
    _9 = _9.xxx * _2053;
    _2396 = vs_TEXCOORD1;
    _2396 = clamp(_2396, 0.0f, 1.0f);
    _9 *= _2396.xxx;
    _2489 = float4(_9.x, _9.y, _9.z, _2489.w);
    _2489.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2489 = _2489;
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
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
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
    vs_TEXCOORD0 = float3(_11.xy.x, _11.xy.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = 0.0f;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
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
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _DeepColor;
float4 _MidColor;
float4 _HotColor;
float4 _HaloColor;
float _QuadHalfSize;
float _TearRadius;
float _Intensity;
float _Surge;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _Time
#define _16_m1 _WorldSpaceCameraPos
#define _16_m3 _DeepColor
#define _16_m4 _MidColor
#define _16_m5 _HotColor
#define _16_m6 _HaloColor
#define _16_m7 _QuadHalfSize
#define _16_m8 _TearRadius
#define _16_m9 _Intensity
#define _16_m10 _Surge



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _2489;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _2489 : SV_Target0;
};

static float3 _9;
static float2 _40;
static float _49;
static float3 _55;
static float2 _80;
static float4 _94;
static float4 _105;
static float4 _110;
static float4 _132;
static float4 _154;
static float4 _164;
static float _167;
static float3 _364;
static bool _604;
static bool _609;
static float _646;
static float _651;
static float2 _775;
static float4 _809;
static float4 _1133;
static float _1218;
static float4 _1511;
static float _1585;
static float2 _1766;
static float2 _1805;
static float _1901;
static float3 _2053;
static float3 _2071;
static float _2396;

void frag_inner()
{
    __unity_init();
    float2 _36 = (float2(float2(_16_m10, _16_m10)) * float2(1.2000000476837158203125f, 0.0199999995529651641845703125f)) + float2(1.0f, 0.02500000037252902984619140625f);
    _9 = float3(_36.x, _36.y, _9.z);
    _40 = vs_TEXCOORD0.xy * float2(1.0f, 0.769230782985687255859375f);
    _49 = dot(_40, _40);
    _49 = sqrt(_49);
    _55.x = max(_49, 9.9999997473787516355514526367188e-05f);
    _40 /= _55.xx;
    _55.x = _40.y * _40.x;
    _55.x = abs(_55.x) + abs(_55.x);
    _80.x = _55.x * _55.x;
    _55.x = _80.x * _55.x;
    _94 = (_40.xyxy * float4(5.0f, 5.0f, 13.0f, 13.0f)) + float4(3.099999904632568359375f, 3.099999904632568359375f, 9.69999980926513671875f, 9.69999980926513671875f);
    _105 = floor(_94);
    _94 = frac(_94);
    _110 = _94 * _94;
    _94 = ((-_94) * 2.0f.xxxx) + 3.0f.xxxx;
    _94 *= _110;
    _110 = _105 * float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _110 = frac(_110);
    _132 = _110 + 23.450000762939453125f.xxxx;
    _80.x = dot(_110.xy, _132.xy);
    _80 = _80.xx + _110.xy;
    _80.x = _80.y * _80.x;
    _154 = _105.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _154 = frac(_154);
    _164 = _154 + 23.450000762939453125f.xxxx;
    _167 = dot(_154.xy, _164.xy);
    float2 _177 = _167.xx + _154.xy;
    _110 = float4(_177.x, _177.y, _110.z, _110.w);
    _80.y = _110.y * _110.x;
    _80 = frac(_80);
    _167 = (-_80.x) + _80.y;
    _80.x = (_94.x * _167) + _80.x;
    _167 = dot(_154.zw, _164.zw);
    float2 _211 = _167.xx + _154.zw;
    _110 = float4(_211.x, _211.y, _110.z, _110.w);
    _167 = _110.y * _110.x;
    _167 = frac(_167);
    _154 = _105 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _154 = frac(_154);
    _164 = _154 + 23.450000762939453125f.xxxx;
    _105.x = dot(_154.xy, _164.xy);
    float2 _240 = _105.xx + _154.xy;
    _105 = float4(_240.x, _240.y, _105.z, _105.w);
    _105.x = _105.y * _105.x;
    _105.x = frac(_105.x);
    _105.x = (-_167) + _105.x;
    _167 = (_94.x * _105.x) + _167;
    _167 = (-_80.x) + _167;
    _80.x = (_94.y * _167) + _80.x;
    _167 = dot(_110.zw, _132.zw);
    float2 _288 = _167.xx + _110.zw;
    _94 = float4(_288.x, _288.y, _94.z, _94.w);
    _167 = _94.y * _94.x;
    _167 = frac(_167);
    _94.x = dot(_154.zw, _164.zw);
    float2 _308 = _94.xx + _154.zw;
    _94 = float4(_308.x, _308.y, _94.z, _94.w);
    _94.x = _94.y * _94.x;
    _94.x = frac(_94.x);
    _94.x = (-_167) + _94.x;
    _167 = (_94.z * _94.x) + _167;
    _105 = _105.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _105 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _105 = frac(_105);
    _110 = _105 + 23.450000762939453125f.xxxx;
    _94.x = dot(_105.xy, _110.xy);
    float2 _355 = _94.xx + _105.xy;
    _94 = float4(_355.x, _355.y, _94.z, _94.w);
    _94.x = _94.y * _94.x;
    _364.x = dot(_105.zw, _110.zw);
    float2 _375 = _364.xx + _105.zw;
    _105 = float4(_375.x, _375.y, _105.z, _105.w);
    _94.y = _105.y * _105.x;
    float2 _386 = frac(_94.xy);
    _94 = float4(_386.x, _386.y, _94.z, _94.w);
    _364.x = (-_94.x) + _94.y;
    _94.x = (_94.z * _364.x) + _94.x;
    _94.x = (-_167) + _94.x;
    _167 = (_94.w * _94.x) + _167;
    _167 *= 0.25f;
    _80.x = (_80.x * 0.5f) + _167;
    _80.x = (_80.x * 0.550000011920928955078125f) + 0.62000000476837158203125f;
    _55.x = (_55.x * 0.89999997615814208984375f) + _80.x;
    _55.x *= _16_m8;
    _80 = _16_m0.yy * float2(1.7000000476837158203125f, 0.07999999821186065673828125f);
    _80.x = sin(_80.x);
    _80.x = (_80.x * 0.039999999105930328369140625f) + 1.0f;
    _80.x = (_16_m10 * 0.25f) + _80.x;
    _94.x = _80.x * _55.x;
    _364.x = _94.x * 0.180000007152557373046875f;
    float2 _496 = ((-_94.xx) * float2(0.819999992847442626953125f, 0.89999997615814208984375f)) + _49.xx;
    _94 = float4(_496.x, _94.y, _496.y, _94.w);
    _364.x = 1.0f / _364.x;
    _94.x = _364.x * _94.x;
    _94.x = clamp(_94.x, 0.0f, 1.0f);
    _364.x = (_94.x * (-2.0f)) + 3.0f;
    _94.x *= _94.x;
    _94.x = ((-_364.x) * _94.x) + 1.0f;
    float3 _542 = _16_m1.yyy * _16_m2[1].xyz;
    _105 = float4(_542.x, _542.y, _542.z, _105.w);
    float3 _554 = (_16_m2[0].xyz * _16_m1.xxx) + _105.xyz;
    _105 = float4(_554.x, _554.y, _554.z, _105.w);
    float3 _566 = (_16_m2[2].xyz * _16_m1.zzz) + _105.xyz;
    _105 = float4(_566.x, _566.y, _566.z, _105.w);
    float3 _575 = _105.xyz + _16_m2[3].xyz;
    _105 = float4(_575.x, _575.y, _575.z, _105.w);
    float3 _582 = (-_105.xyz) + vs_TEXCOORD0;
    _105 = float4(_582.x, _582.y, _582.z, _105.w);
    _364.x = dot(_105.xyz, _105.xyz);
    _364.x = rsqrt(_364.x);
    float3 _599 = _364.xxx * _105.xyz;
    _105 = float4(_599.x, _599.y, _599.z, _105.w);
    _604 = 0.001000000047497451305389404296875f < _94.x;
    _609 = _105.z < (-0.0199999995529651641845703125f);
    _604 = _609 && _604;
    if (_604)
    {
        _110 = float4(0.25f, 0.800000011920928955078125f, 2.0499999523162841796875f, 4.0f) / (-_105.zzzz);
        _132 = (_105.xyxy * _110.xxyy) + vs_TEXCOORD0.xyxy;
        _364.x = dot(_132.xy, _132.xy);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-2.3083121776580810546875f);
        _651 = _9.x * _16_m0.y;
        _154 = _651.xxxx * float4(0.3499999940395355224609375f, 0.4699999988079071044921875f, 0.589999973773956298828125f, 0.709999978542327880859375f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.x);
        _110.x = sin(_651);
        _154.x = cos(_651);
        float2 _683 = _110.xx * _132.yx;
        _110 = float4(_683.x, _683.y, _110.z, _110.w);
        _164.x = (_132.x * _154.x) + (-_110.x);
        _164.y = (_132.y * _154.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _713 = _164.xy / _364.xx;
        _110 = float4(_713.x, _713.y, _110.z, _110.w);
        _364.x = _16_m0.y * 0.1500000059604644775390625f;
        float2 _728 = (_110.xy * 9.0f.xx) + _364.xx;
        _110 = float4(_728.x, _728.y, _110.z, _110.w);
        float2 _733 = floor(_110.xy);
        _132 = float4(_733.x, _733.y, _132.z, _132.w);
        float2 _738 = frac(_110.xy);
        _110 = float4(_738.x, _738.y, _110.z, _110.w);
        float2 _745 = _110.xy * _110.xy;
        _164 = float4(_745.x, _745.y, _164.z, _164.w);
        float2 _754 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_754.x, _754.y, _110.z, _110.w);
        float2 _761 = _110.xy * _164.xy;
        _110 = float4(_761.x, _761.y, _110.z, _110.w);
        float2 _767 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _164 = float4(_767.x, _767.y, _164.z, _164.w);
        float2 _772 = frac(_164.xy);
        _164 = float4(_772.x, _772.y, _164.z, _164.w);
        _775 = _164.xy + 23.450000762939453125f.xx;
        _364.x = dot(_164.xy, _775);
        float2 _789 = _364.xx + _164.xy;
        _164 = float4(_789.x, _789.y, _164.z, _164.w);
        _364.x = _164.y * _164.x;
        _364.x = frac(_364.x);
        _164 = _132.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _164 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _164 = frac(_164);
        _809 = _164 + 23.450000762939453125f.xxxx;
        _651 = dot(_164.xy, _809.xy);
        float2 _821 = _651.xx + _164.xy;
        _164 = float4(_821.x, _821.y, _164.z, _164.w);
        _651 = _164.y * _164.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_164.zw, _809.zw);
        float2 _853 = _651.xx + _164.zw;
        _164 = float4(_853.x, _853.y, _164.z, _164.w);
        _651 = _164.y * _164.x;
        _651 = frac(_651);
        float2 _866 = _132.xy + 1.0f.xx;
        _132 = float4(_866.x, _866.y, _132.z, _132.w);
        float2 _871 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_871.x, _871.y, _132.z, _132.w);
        float2 _876 = frac(_132.xy);
        _132 = float4(_876.x, _876.y, _132.z, _132.w);
        float2 _881 = _132.xy + 23.450000762939453125f.xx;
        _164 = float4(_881.x, _881.y, _164.z, _164.w);
        _154.x = dot(_132.xy, _164.xy);
        float2 _894 = _132.xy + _154.xx;
        _132 = float4(_894.x, _894.y, _132.z, _132.w);
        _132.x = _132.y * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_651) + _132.x;
        _651 = (_110.x * _132.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _960 = _364.xxx * _16_m4.xyz;
        _164 = float4(_960.x, _960.y, _960.z, _164.w);
        _364.x = dot(_132.zw, _132.zw);
        _364.x = sqrt(_364.x);
        _651 = _364.x * (-2.8853900432586669921875f);
        _110.x = (_364.x * 1.7999999523162841796875f) + (-_154.y);
        _110.x += 1.2999999523162841796875f;
        _132.x = cos(_110.x);
        _110.x = sin(_110.x);
        float2 _1002 = _110.xx * _132.wz;
        _110 = float4(_1002.x, _1002.y, _110.z, _110.w);
        _154.x = (_132.z * _132.x) + (-_110.x);
        _154.y = (_132.w * _132.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1032 = _154.xy / _364.xx;
        _110 = float4(_1032.x, _1032.y, _110.z, _110.w);
        float3 _1044 = (_16_m0.yyy * 0.1500000059604644775390625f.xxx) + float3(7.099999904632568359375f, 14.19999980926513671875f, 21.299999237060546875f);
        _132 = float4(_1044.x, _1044.y, _1044.z, _132.w);
        float2 _1054 = (_110.xy * 12.0f.xx) + _132.xx;
        _110 = float4(_1054.x, _1054.y, _110.z, _110.w);
        float2 _1059 = floor(_110.xy);
        _132 = float4(_1059.x, _132.y, _132.z, _1059.y);
        float2 _1064 = frac(_110.xy);
        _110 = float4(_1064.x, _1064.y, _110.z, _110.w);
        float2 _1071 = _110.xy * _110.xy;
        _154 = float4(_1071.x, _1071.y, _154.z, _154.w);
        float2 _1078 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1078.x, _1078.y, _110.z, _110.w);
        float2 _1085 = _110.xy * _154.xy;
        _110 = float4(_1085.x, _1085.y, _110.z, _110.w);
        float2 _1090 = _132.xw * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1090.x, _1090.y, _154.z, _154.w);
        float2 _1095 = frac(_154.xy);
        _154 = float4(_1095.x, _1095.y, _154.z, _154.w);
        float2 _1100 = _154.xy + 23.450000762939453125f.xx;
        _809 = float4(_1100.x, _1100.y, _809.z, _809.w);
        _364.x = dot(_154.xy, _809.xy);
        float2 _1113 = _364.xx + _154.xy;
        _154 = float4(_1113.x, _1113.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _809 = _132.xwxw + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _809 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _809 = frac(_809);
        _1133 = _809 + 23.450000762939453125f.xxxx;
        _154.x = dot(_809.xy, _1133.xy);
        float2 _1146 = _154.xx + _809.xy;
        _154 = float4(_1146.x, _1146.y, _154.z, _154.w);
        _154.x = _154.y * _154.x;
        _154.x = frac(_154.x);
        _154.x = (-_364.x) + _154.x;
        _364.x = (_110.x * _154.x) + _364.x;
        _154.x = dot(_809.zw, _1133.zw);
        float2 _1185 = _154.xx + _809.zw;
        _154 = float4(_1185.x, _1185.y, _154.z, _154.w);
        _154.x = _154.y * _154.x;
        _154.x = frac(_154.x);
        float2 _1200 = _132.xw + 1.0f.xx;
        _132 = float4(_1200.x, _132.y, _132.z, _1200.y);
        float2 _1205 = _132.xw * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_1205.x, _132.y, _132.z, _1205.y);
        float2 _1210 = frac(_132.xw);
        _132 = float4(_1210.x, _132.y, _132.z, _1210.y);
        float2 _1215 = _132.xw + 23.450000762939453125f.xx;
        _809 = float4(_1215.x, _1215.y, _809.z, _809.w);
        _1218 = dot(_132.xw, _809.xy);
        float2 _1228 = _132.xw + _1218.xx;
        _132 = float4(_1228.x, _132.y, _132.z, _1228.y);
        _132.x = _132.w * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_154.x) + _132.x;
        _110.x = (_110.x * _132.x) + _154.x;
        _110.x = (-_364.x) + _110.x;
        _364.x = (_110.y * _110.x) + _364.x;
        _110.x = _364.x * _364.x;
        _110.x *= _110.x;
        _364.x *= _110.x;
        _651 = exp2(_651);
        float3 _1300 = _16_m3.xyz + (-_16_m4.xyz);
        _809 = float4(_1300.x, _1300.y, _1300.z, _809.w);
        float3 _1311 = (_809.xyz * 0.3333333432674407958984375f.xxx) + _16_m4.xyz;
        _1133 = float4(_1311.x, _1311.y, _1311.z, _1133.w);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1323 = _364.xxx * _1133.xyz;
        _1133 = float4(_1323.x, _1323.y, _1323.z, _1133.w);
        float3 _1330 = _651.xxx * _1133.xyz;
        _1133 = float4(_1330.x, _1330.y, _1330.z, _1133.w);
        float3 _1337 = _1133.xyz * 0.625f.xxx;
        _1133 = float4(_1337.x, _1337.y, _1337.z, _1133.w);
        float3 _1347 = (_164.xyz * _646.xxx) + _1133.xyz;
        _164 = float4(_1347.x, _1347.y, _1347.z, _164.w);
        _110 = (_105.xyxy * _110.zzww) + vs_TEXCOORD0.xyxy;
        _364.x = dot(_110.xy, _110.xy);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-3.46246814727783203125f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.z);
        _651 += 2.599999904632568359375f;
        _132.x = sin(_651);
        _154.x = cos(_651);
        float2 _1392 = _110.yx * _132.xx;
        _132 = float4(_1392.x, _132.y, _132.z, _1392.y);
        _1133.x = (_110.x * _154.x) + (-_132.x);
        _1133.y = (_110.y * _154.x) + _132.w;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1422 = _1133.xy / _364.xx;
        _110 = float4(_1422.x, _1422.y, _110.z, _110.w);
        float2 _1432 = (_110.xy * 15.0f.xx) + _132.yy;
        _110 = float4(_1432.x, _1432.y, _110.z, _110.w);
        float2 _1437 = floor(_110.xy);
        _132 = float4(_1437.x, _1437.y, _132.z, _132.w);
        float2 _1442 = frac(_110.xy);
        _110 = float4(_1442.x, _1442.y, _110.z, _110.w);
        float2 _1449 = _110.xy * _110.xy;
        _154 = float4(_1449.x, _1449.y, _154.z, _154.w);
        float2 _1456 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1456.x, _1456.y, _110.z, _110.w);
        float2 _1463 = _110.xy * _154.xy;
        _110 = float4(_1463.x, _1463.y, _110.z, _110.w);
        float2 _1468 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1468.x, _1468.y, _154.z, _154.w);
        float2 _1473 = frac(_154.xy);
        _154 = float4(_1473.x, _1473.y, _154.z, _154.w);
        float2 _1478 = _154.xy + 23.450000762939453125f.xx;
        _1133 = float4(_1478.x, _1478.y, _1133.z, _1133.w);
        _364.x = dot(_154.xy, _1133.xy);
        float2 _1491 = _364.xx + _154.xy;
        _154 = float4(_1491.x, _1491.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _1133 = _132.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _1133 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _1133 = frac(_1133);
        _1511 = _1133 + 23.450000762939453125f.xxxx;
        _651 = dot(_1133.xy, _1511.xy);
        float2 _1523 = _651.xx + _1133.xy;
        _154 = float4(_1523.x, _1523.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_1133.zw, _1511.zw);
        float2 _1555 = _651.xx + _1133.zw;
        _154 = float4(_1555.x, _1555.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        float2 _1567 = _132.xy + 1.0f.xx;
        _132 = float4(_1567.x, _1567.y, _132.z, _132.w);
        float2 _1572 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_1572.x, _1572.y, _132.z, _132.w);
        float2 _1577 = frac(_132.xy);
        _132 = float4(_1577.x, _1577.y, _132.z, _132.w);
        float2 _1582 = _132.xy + 23.450000762939453125f.xx;
        _154 = float4(_1582.x, _1582.y, _154.z, _154.w);
        _1585 = dot(_132.xy, _154.xy);
        float2 _1595 = _1585.xx + _132.xy;
        _132 = float4(_1595.x, _1595.y, _132.z, _132.w);
        _132.x = _132.y * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_651) + _132.x;
        _651 = (_110.x * _132.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        float3 _1657 = (_809.xyz * 0.666666686534881591796875f.xxx) + _16_m4.xyz;
        _132 = float4(_1657.x, _1657.y, _132.z, _1657.z);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1669 = _364.xxx * _132.xyw;
        _132 = float4(_1669.x, _1669.y, _132.z, _1669.z);
        float3 _1676 = _646.xxx * _132.xyw;
        _132 = float4(_1676.x, _1676.y, _132.z, _1676.z);
        float3 _1686 = (_132.xyw * 0.454545438289642333984375f.xxx) + _164.xyz;
        _132 = float4(_1686.x, _1686.y, _132.z, _1686.z);
        _364.x = dot(_110.zw, _110.zw);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-4.039546489715576171875f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.w);
        _651 += 3.8999998569488525390625f;
        _110.x = sin(_651);
        _154.x = cos(_651);
        float2 _1723 = _110.xx * _110.wz;
        _110 = float4(_1723.x, _1723.y, _110.z, _110.w);
        _164.x = (_110.z * _154.x) + (-_110.x);
        _164.y = (_110.w * _154.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1753 = _164.xy / _364.xx;
        _110 = float4(_1753.x, _1753.y, _110.z, _110.w);
        float2 _1763 = (_110.xy * 18.0f.xx) + _132.zz;
        _110 = float4(_1763.x, _1763.y, _110.z, _110.w);
        _1766 = floor(_110.xy);
        float2 _1772 = frac(_110.xy);
        _110 = float4(_1772.x, _1772.y, _110.z, _110.w);
        float2 _1779 = _110.xy * _110.xy;
        _154 = float4(_1779.x, _1779.y, _154.z, _154.w);
        float2 _1786 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1786.x, _1786.y, _110.z, _110.w);
        float2 _1793 = _110.xy * _154.xy;
        _110 = float4(_1793.x, _1793.y, _110.z, _110.w);
        float2 _1797 = _1766 * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1797.x, _1797.y, _154.z, _154.w);
        float2 _1802 = frac(_154.xy);
        _154 = float4(_1802.x, _1802.y, _154.z, _154.w);
        _1805 = _154.xy + 23.450000762939453125f.xx;
        _364.x = dot(_154.xy, _1805);
        float2 _1818 = _364.xx + _154.xy;
        _154 = float4(_1818.x, _1818.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _154 = _1766.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _154 = frac(_154);
        _164 = _154 + 23.450000762939453125f.xxxx;
        _651 = dot(_154.xy, _164.xy);
        float2 _1849 = _651.xx + _154.xy;
        _154 = float4(_1849.x, _1849.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_154.zw, _164.zw);
        float2 _1881 = _651.xx + _154.zw;
        _154 = float4(_1881.x, _1881.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _1766 += 1.0f.xx;
        _1766 *= float2(233.339996337890625f, 851.72998046875f);
        _1766 = frac(_1766);
        float2 _1898 = _1766 + 23.450000762939453125f.xx;
        _154 = float4(_1898.x, _1898.y, _154.z, _154.w);
        _1901 = dot(_1766, _154.xy);
        _1766 += _1901.xx;
        _1766.x = _1766.y * _1766.x;
        _1766.x = frac(_1766.x);
        _1766.x = (-_651) + _1766.x;
        _651 = (_110.x * _1766.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1971 = _364.xxx * _16_m3.xyz;
        _110 = float4(_1971.x, _1971.y, _1971.z, _110.w);
        float3 _1978 = _646.xxx * _110.xyz;
        _110 = float4(_1978.x, _1978.y, _1978.z, _110.w);
        float3 _1988 = (_110.xyz * 0.3571428358554840087890625f.xxx) + _132.xyw;
        _110 = float4(_1988.x, _1988.y, _1988.z, _110.w);
        _364.x = 1.7999999523162841796875f / (-_105.z);
        float2 _2003 = (_105.xy * _364.xx) + vs_TEXCOORD0.xy;
        _364 = float3(_2003.x, _364.y, _2003.y);
        _364.x = dot(_364.xz, _364.xz);
        _364.x *= (-7.21347522735595703125f);
        _364.x = exp2(_364.x);
        float3 _2027 = _364.xxx * _16_m5.xyz;
        _105 = float4(_2027.x, _2027.y, _2027.z, _105.w);
        float3 _2036 = (_105.xyz * 1.2999999523162841796875f.xxx) + _110.xyz;
        _105 = float4(_2036.x, _2036.y, _2036.z, _105.w);
    }
    else
    {
        _105.x = 0.0f;
        _105.y = 0.0f;
        _105.z = 0.0f;
    }
    float3 _2050 = (_16_m3.xyz * 0.3499999940395355224609375f.xxx) + _105.xyz;
    _105 = float4(_2050.x, _2050.y, _2050.z, _105.w);
    _2053.x = (-abs(_94.z)) / _9.y;
    _2053.x *= 1.44269502162933349609375f;
    _2053.x = exp2(_2053.x);
    _2071 = (-_16_m4.xyz) + _16_m5.xyz;
    _2071 = (_2071 * 0.5f.xxx) + _16_m4.xyz;
    _364 = _2053.xxx * _2071;
    _364 *= 0.89999997615814208984375f.xxx;
    _364 = (_105.xyz * _94.xxx) + _364;
    float2 _2108 = _16_m7.xx * float2(0.46153843402862548828125f, 0.100000001490116119384765625f);
    _105 = float4(_2108.x, _2108.y, _105.z, _105.w);
    _2053.x = ((-_16_m7) * 0.2307692468166351318359375f) + _49;
    float2 _2121 = 1.0f.xx / _105.xy;
    _105 = float4(_2121.x, _2121.y, _105.z, _105.w);
    _2053.x *= _105.x;
    _2053.x = clamp(_2053.x, 0.0f, 1.0f);
    _105.x = (_2053.x * (-2.0f)) + 3.0f;
    _2053.x *= _2053.x;
    _2053.x = ((-_105.x) * _2053.x) + 1.0f;
    _55.x = ((-_55.x) * _80.x) + _49;
    _55.x = max(_55.x, 0.0f);
    _55.x *= (-5.193702220916748046875f);
    _55.x = exp2(_55.x);
    _80.x = (-_94.x) + 1.0f;
    _55.x = _80.x * _55.x;
    _40 = (_40 * 22.0f.xx) + _80.yy;
    float2 _2194 = floor(_40);
    _105 = float4(_2194.x, _105.y, _2194.y, _105.w);
    _40 = frac(_40);
    float2 _2201 = _40 * _40;
    _110 = float4(_2201.x, _2201.y, _110.z, _110.w);
    _40 = ((-_40) * 2.0f.xx) + 3.0f.xx;
    _40 *= _110.xy;
    float2 _2214 = _105.xz * float2(233.339996337890625f, 851.72998046875f);
    _110 = float4(_2214.x, _2214.y, _110.z, _110.w);
    float2 _2219 = frac(_110.xy);
    _110 = float4(_2219.x, _2219.y, _110.z, _110.w);
    _1766 = _110.xy + 23.450000762939453125f.xx;
    _167 = dot(_110.xy, _1766);
    float2 _2233 = _167.xx + _110.xy;
    _110 = float4(_2233.x, _2233.y, _110.z, _110.w);
    _167 = _110.y * _110.x;
    _167 = frac(_167);
    _110 = _105.xzxz + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _110 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _110 = frac(_110);
    _132 = _110 + 23.450000762939453125f.xxxx;
    _94.x = dot(_110.xy, _132.xy);
    float2 _2262 = _94.xx + _110.xy;
    _110 = float4(_2262.x, _2262.y, _110.z, _110.w);
    _94.x = _110.y * _110.x;
    _94.x = frac(_94.x);
    _94.x = (-_167) + _94.x;
    _167 = (_40.x * _94.x) + _167;
    _94.x = dot(_110.zw, _132.zw);
    float2 _2298 = _94.xx + _110.zw;
    _110 = float4(_2298.x, _2298.y, _110.z, _110.w);
    _94.x = _110.y * _110.x;
    _94.x = frac(_94.x);
    float2 _2313 = _105.xz + 1.0f.xx;
    _105 = float4(_2313.x, _105.y, _2313.y, _105.w);
    float2 _2318 = _105.xz * float2(233.339996337890625f, 851.72998046875f);
    _105 = float4(_2318.x, _105.y, _2318.y, _105.w);
    float2 _2323 = frac(_105.xz);
    _105 = float4(_2323.x, _105.y, _2323.y, _105.w);
    float2 _2328 = _105.xz + 23.450000762939453125f.xx;
    _110 = float4(_2328.x, _2328.y, _110.z, _110.w);
    _651 = dot(_105.xz, _110.xy);
    float2 _2340 = _651.xx + _105.xz;
    _105 = float4(_2340.x, _105.y, _2340.y, _105.w);
    _105.x = _105.z * _105.x;
    _105.x = frac(_105.x);
    _105.x = (-_94.x) + _105.x;
    _40.x = (_40.x * _105.x) + _94.x;
    _40.x = (-_167) + _40.x;
    _2053.y = (_40.y * _40.x) + _167;
    float2 _2387 = _2053.xy * _2053.xy;
    _2053 = float3(_2387.x, _2387.y, _2053.z);
    _40.x = _2053.y * _2053.y;
    _2396 = _49 * (-3.1739292144775390625f);
    _2396 = exp2(_2396);
    _40.x = _2396 * _40.x;
    _40.x = _80.x * _40.x;
    _40.x *= 0.60000002384185791015625f;
    _40.x = (_55.x * 0.449999988079071044921875f) + _40.x;
    _55 = _40.xxx * _16_m6.xyz;
    _2053 = (_55 * _2053.xxx) + _364;
    _49 = ((-_16_m7) * 0.653846204280853271484375f) + _49;
    _49 = _105.y * _49;
    _49 = clamp(_49, 0.0f, 1.0f);
    _55.x = (_49 * (-2.0f)) + 3.0f;
    _49 *= _49;
    _49 = ((-_55.x) * _49) + 1.0f;
    _49 *= _16_m9;
    _9.x *= _49;
    _9 = _9.xxx * _2053;
    _2396 = vs_TEXCOORD1;
    _2396 = clamp(_2396, 0.0f, 1.0f);
    _9 *= _2396.xxx;
    _2489 = float4(_9.x, _9.y, _9.z, _2489.w);
    _2489.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2489 = _2489;
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
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
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
    vs_TEXCOORD0 = float3(_11.xy.x, _11.xy.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = 0.0f;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
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
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _DeepColor;
float4 _MidColor;
float4 _HotColor;
float4 _HaloColor;
float _QuadHalfSize;
float _TearRadius;
float _Intensity;
float _Surge;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _Time
#define _16_m1 _WorldSpaceCameraPos
#define _16_m3 _DeepColor
#define _16_m4 _MidColor
#define _16_m5 _HotColor
#define _16_m6 _HaloColor
#define _16_m7 _QuadHalfSize
#define _16_m8 _TearRadius
#define _16_m9 _Intensity
#define _16_m10 _Surge



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _2489;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _2489 : SV_Target0;
};

static float3 _9;
static float2 _40;
static float _49;
static float3 _55;
static float2 _80;
static float4 _94;
static float4 _105;
static float4 _110;
static float4 _132;
static float4 _154;
static float4 _164;
static float _167;
static float3 _364;
static bool _604;
static bool _609;
static float _646;
static float _651;
static float2 _775;
static float4 _809;
static float4 _1133;
static float _1218;
static float4 _1511;
static float _1585;
static float2 _1766;
static float2 _1805;
static float _1901;
static float3 _2053;
static float3 _2071;
static float _2396;

void frag_inner()
{
    __unity_init();
    float2 _36 = (float2(float2(_16_m10, _16_m10)) * float2(1.2000000476837158203125f, 0.0199999995529651641845703125f)) + float2(1.0f, 0.02500000037252902984619140625f);
    _9 = float3(_36.x, _36.y, _9.z);
    _40 = vs_TEXCOORD0.xy * float2(1.0f, 0.769230782985687255859375f);
    _49 = dot(_40, _40);
    _49 = sqrt(_49);
    _55.x = max(_49, 9.9999997473787516355514526367188e-05f);
    _40 /= _55.xx;
    _55.x = _40.y * _40.x;
    _55.x = abs(_55.x) + abs(_55.x);
    _80.x = _55.x * _55.x;
    _55.x = _80.x * _55.x;
    _94 = (_40.xyxy * float4(5.0f, 5.0f, 13.0f, 13.0f)) + float4(3.099999904632568359375f, 3.099999904632568359375f, 9.69999980926513671875f, 9.69999980926513671875f);
    _105 = floor(_94);
    _94 = frac(_94);
    _110 = _94 * _94;
    _94 = ((-_94) * 2.0f.xxxx) + 3.0f.xxxx;
    _94 *= _110;
    _110 = _105 * float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _110 = frac(_110);
    _132 = _110 + 23.450000762939453125f.xxxx;
    _80.x = dot(_110.xy, _132.xy);
    _80 = _80.xx + _110.xy;
    _80.x = _80.y * _80.x;
    _154 = _105.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _154 = frac(_154);
    _164 = _154 + 23.450000762939453125f.xxxx;
    _167 = dot(_154.xy, _164.xy);
    float2 _177 = _167.xx + _154.xy;
    _110 = float4(_177.x, _177.y, _110.z, _110.w);
    _80.y = _110.y * _110.x;
    _80 = frac(_80);
    _167 = (-_80.x) + _80.y;
    _80.x = (_94.x * _167) + _80.x;
    _167 = dot(_154.zw, _164.zw);
    float2 _211 = _167.xx + _154.zw;
    _110 = float4(_211.x, _211.y, _110.z, _110.w);
    _167 = _110.y * _110.x;
    _167 = frac(_167);
    _154 = _105 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _154 = frac(_154);
    _164 = _154 + 23.450000762939453125f.xxxx;
    _105.x = dot(_154.xy, _164.xy);
    float2 _240 = _105.xx + _154.xy;
    _105 = float4(_240.x, _240.y, _105.z, _105.w);
    _105.x = _105.y * _105.x;
    _105.x = frac(_105.x);
    _105.x = (-_167) + _105.x;
    _167 = (_94.x * _105.x) + _167;
    _167 = (-_80.x) + _167;
    _80.x = (_94.y * _167) + _80.x;
    _167 = dot(_110.zw, _132.zw);
    float2 _288 = _167.xx + _110.zw;
    _94 = float4(_288.x, _288.y, _94.z, _94.w);
    _167 = _94.y * _94.x;
    _167 = frac(_167);
    _94.x = dot(_154.zw, _164.zw);
    float2 _308 = _94.xx + _154.zw;
    _94 = float4(_308.x, _308.y, _94.z, _94.w);
    _94.x = _94.y * _94.x;
    _94.x = frac(_94.x);
    _94.x = (-_167) + _94.x;
    _167 = (_94.z * _94.x) + _167;
    _105 = _105.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _105 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _105 = frac(_105);
    _110 = _105 + 23.450000762939453125f.xxxx;
    _94.x = dot(_105.xy, _110.xy);
    float2 _355 = _94.xx + _105.xy;
    _94 = float4(_355.x, _355.y, _94.z, _94.w);
    _94.x = _94.y * _94.x;
    _364.x = dot(_105.zw, _110.zw);
    float2 _375 = _364.xx + _105.zw;
    _105 = float4(_375.x, _375.y, _105.z, _105.w);
    _94.y = _105.y * _105.x;
    float2 _386 = frac(_94.xy);
    _94 = float4(_386.x, _386.y, _94.z, _94.w);
    _364.x = (-_94.x) + _94.y;
    _94.x = (_94.z * _364.x) + _94.x;
    _94.x = (-_167) + _94.x;
    _167 = (_94.w * _94.x) + _167;
    _167 *= 0.25f;
    _80.x = (_80.x * 0.5f) + _167;
    _80.x = (_80.x * 0.550000011920928955078125f) + 0.62000000476837158203125f;
    _55.x = (_55.x * 0.89999997615814208984375f) + _80.x;
    _55.x *= _16_m8;
    _80 = _16_m0.yy * float2(1.7000000476837158203125f, 0.07999999821186065673828125f);
    _80.x = sin(_80.x);
    _80.x = (_80.x * 0.039999999105930328369140625f) + 1.0f;
    _80.x = (_16_m10 * 0.25f) + _80.x;
    _94.x = _80.x * _55.x;
    _364.x = _94.x * 0.180000007152557373046875f;
    float2 _496 = ((-_94.xx) * float2(0.819999992847442626953125f, 0.89999997615814208984375f)) + _49.xx;
    _94 = float4(_496.x, _94.y, _496.y, _94.w);
    _364.x = 1.0f / _364.x;
    _94.x = _364.x * _94.x;
    _94.x = clamp(_94.x, 0.0f, 1.0f);
    _364.x = (_94.x * (-2.0f)) + 3.0f;
    _94.x *= _94.x;
    _94.x = ((-_364.x) * _94.x) + 1.0f;
    float3 _542 = _16_m1.yyy * _16_m2[1].xyz;
    _105 = float4(_542.x, _542.y, _542.z, _105.w);
    float3 _554 = (_16_m2[0].xyz * _16_m1.xxx) + _105.xyz;
    _105 = float4(_554.x, _554.y, _554.z, _105.w);
    float3 _566 = (_16_m2[2].xyz * _16_m1.zzz) + _105.xyz;
    _105 = float4(_566.x, _566.y, _566.z, _105.w);
    float3 _575 = _105.xyz + _16_m2[3].xyz;
    _105 = float4(_575.x, _575.y, _575.z, _105.w);
    float3 _582 = (-_105.xyz) + vs_TEXCOORD0;
    _105 = float4(_582.x, _582.y, _582.z, _105.w);
    _364.x = dot(_105.xyz, _105.xyz);
    _364.x = rsqrt(_364.x);
    float3 _599 = _364.xxx * _105.xyz;
    _105 = float4(_599.x, _599.y, _599.z, _105.w);
    _604 = 0.001000000047497451305389404296875f < _94.x;
    _609 = _105.z < (-0.0199999995529651641845703125f);
    _604 = _609 && _604;
    if (_604)
    {
        _110 = float4(0.25f, 0.800000011920928955078125f, 2.0499999523162841796875f, 4.0f) / (-_105.zzzz);
        _132 = (_105.xyxy * _110.xxyy) + vs_TEXCOORD0.xyxy;
        _364.x = dot(_132.xy, _132.xy);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-2.3083121776580810546875f);
        _651 = _9.x * _16_m0.y;
        _154 = _651.xxxx * float4(0.3499999940395355224609375f, 0.4699999988079071044921875f, 0.589999973773956298828125f, 0.709999978542327880859375f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.x);
        _110.x = sin(_651);
        _154.x = cos(_651);
        float2 _683 = _110.xx * _132.yx;
        _110 = float4(_683.x, _683.y, _110.z, _110.w);
        _164.x = (_132.x * _154.x) + (-_110.x);
        _164.y = (_132.y * _154.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _713 = _164.xy / _364.xx;
        _110 = float4(_713.x, _713.y, _110.z, _110.w);
        _364.x = _16_m0.y * 0.1500000059604644775390625f;
        float2 _728 = (_110.xy * 9.0f.xx) + _364.xx;
        _110 = float4(_728.x, _728.y, _110.z, _110.w);
        float2 _733 = floor(_110.xy);
        _132 = float4(_733.x, _733.y, _132.z, _132.w);
        float2 _738 = frac(_110.xy);
        _110 = float4(_738.x, _738.y, _110.z, _110.w);
        float2 _745 = _110.xy * _110.xy;
        _164 = float4(_745.x, _745.y, _164.z, _164.w);
        float2 _754 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_754.x, _754.y, _110.z, _110.w);
        float2 _761 = _110.xy * _164.xy;
        _110 = float4(_761.x, _761.y, _110.z, _110.w);
        float2 _767 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _164 = float4(_767.x, _767.y, _164.z, _164.w);
        float2 _772 = frac(_164.xy);
        _164 = float4(_772.x, _772.y, _164.z, _164.w);
        _775 = _164.xy + 23.450000762939453125f.xx;
        _364.x = dot(_164.xy, _775);
        float2 _789 = _364.xx + _164.xy;
        _164 = float4(_789.x, _789.y, _164.z, _164.w);
        _364.x = _164.y * _164.x;
        _364.x = frac(_364.x);
        _164 = _132.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _164 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _164 = frac(_164);
        _809 = _164 + 23.450000762939453125f.xxxx;
        _651 = dot(_164.xy, _809.xy);
        float2 _821 = _651.xx + _164.xy;
        _164 = float4(_821.x, _821.y, _164.z, _164.w);
        _651 = _164.y * _164.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_164.zw, _809.zw);
        float2 _853 = _651.xx + _164.zw;
        _164 = float4(_853.x, _853.y, _164.z, _164.w);
        _651 = _164.y * _164.x;
        _651 = frac(_651);
        float2 _866 = _132.xy + 1.0f.xx;
        _132 = float4(_866.x, _866.y, _132.z, _132.w);
        float2 _871 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_871.x, _871.y, _132.z, _132.w);
        float2 _876 = frac(_132.xy);
        _132 = float4(_876.x, _876.y, _132.z, _132.w);
        float2 _881 = _132.xy + 23.450000762939453125f.xx;
        _164 = float4(_881.x, _881.y, _164.z, _164.w);
        _154.x = dot(_132.xy, _164.xy);
        float2 _894 = _132.xy + _154.xx;
        _132 = float4(_894.x, _894.y, _132.z, _132.w);
        _132.x = _132.y * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_651) + _132.x;
        _651 = (_110.x * _132.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _960 = _364.xxx * _16_m4.xyz;
        _164 = float4(_960.x, _960.y, _960.z, _164.w);
        _364.x = dot(_132.zw, _132.zw);
        _364.x = sqrt(_364.x);
        _651 = _364.x * (-2.8853900432586669921875f);
        _110.x = (_364.x * 1.7999999523162841796875f) + (-_154.y);
        _110.x += 1.2999999523162841796875f;
        _132.x = cos(_110.x);
        _110.x = sin(_110.x);
        float2 _1002 = _110.xx * _132.wz;
        _110 = float4(_1002.x, _1002.y, _110.z, _110.w);
        _154.x = (_132.z * _132.x) + (-_110.x);
        _154.y = (_132.w * _132.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1032 = _154.xy / _364.xx;
        _110 = float4(_1032.x, _1032.y, _110.z, _110.w);
        float3 _1044 = (_16_m0.yyy * 0.1500000059604644775390625f.xxx) + float3(7.099999904632568359375f, 14.19999980926513671875f, 21.299999237060546875f);
        _132 = float4(_1044.x, _1044.y, _1044.z, _132.w);
        float2 _1054 = (_110.xy * 12.0f.xx) + _132.xx;
        _110 = float4(_1054.x, _1054.y, _110.z, _110.w);
        float2 _1059 = floor(_110.xy);
        _132 = float4(_1059.x, _132.y, _132.z, _1059.y);
        float2 _1064 = frac(_110.xy);
        _110 = float4(_1064.x, _1064.y, _110.z, _110.w);
        float2 _1071 = _110.xy * _110.xy;
        _154 = float4(_1071.x, _1071.y, _154.z, _154.w);
        float2 _1078 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1078.x, _1078.y, _110.z, _110.w);
        float2 _1085 = _110.xy * _154.xy;
        _110 = float4(_1085.x, _1085.y, _110.z, _110.w);
        float2 _1090 = _132.xw * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1090.x, _1090.y, _154.z, _154.w);
        float2 _1095 = frac(_154.xy);
        _154 = float4(_1095.x, _1095.y, _154.z, _154.w);
        float2 _1100 = _154.xy + 23.450000762939453125f.xx;
        _809 = float4(_1100.x, _1100.y, _809.z, _809.w);
        _364.x = dot(_154.xy, _809.xy);
        float2 _1113 = _364.xx + _154.xy;
        _154 = float4(_1113.x, _1113.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _809 = _132.xwxw + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _809 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _809 = frac(_809);
        _1133 = _809 + 23.450000762939453125f.xxxx;
        _154.x = dot(_809.xy, _1133.xy);
        float2 _1146 = _154.xx + _809.xy;
        _154 = float4(_1146.x, _1146.y, _154.z, _154.w);
        _154.x = _154.y * _154.x;
        _154.x = frac(_154.x);
        _154.x = (-_364.x) + _154.x;
        _364.x = (_110.x * _154.x) + _364.x;
        _154.x = dot(_809.zw, _1133.zw);
        float2 _1185 = _154.xx + _809.zw;
        _154 = float4(_1185.x, _1185.y, _154.z, _154.w);
        _154.x = _154.y * _154.x;
        _154.x = frac(_154.x);
        float2 _1200 = _132.xw + 1.0f.xx;
        _132 = float4(_1200.x, _132.y, _132.z, _1200.y);
        float2 _1205 = _132.xw * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_1205.x, _132.y, _132.z, _1205.y);
        float2 _1210 = frac(_132.xw);
        _132 = float4(_1210.x, _132.y, _132.z, _1210.y);
        float2 _1215 = _132.xw + 23.450000762939453125f.xx;
        _809 = float4(_1215.x, _1215.y, _809.z, _809.w);
        _1218 = dot(_132.xw, _809.xy);
        float2 _1228 = _132.xw + _1218.xx;
        _132 = float4(_1228.x, _132.y, _132.z, _1228.y);
        _132.x = _132.w * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_154.x) + _132.x;
        _110.x = (_110.x * _132.x) + _154.x;
        _110.x = (-_364.x) + _110.x;
        _364.x = (_110.y * _110.x) + _364.x;
        _110.x = _364.x * _364.x;
        _110.x *= _110.x;
        _364.x *= _110.x;
        _651 = exp2(_651);
        float3 _1300 = _16_m3.xyz + (-_16_m4.xyz);
        _809 = float4(_1300.x, _1300.y, _1300.z, _809.w);
        float3 _1311 = (_809.xyz * 0.3333333432674407958984375f.xxx) + _16_m4.xyz;
        _1133 = float4(_1311.x, _1311.y, _1311.z, _1133.w);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1323 = _364.xxx * _1133.xyz;
        _1133 = float4(_1323.x, _1323.y, _1323.z, _1133.w);
        float3 _1330 = _651.xxx * _1133.xyz;
        _1133 = float4(_1330.x, _1330.y, _1330.z, _1133.w);
        float3 _1337 = _1133.xyz * 0.625f.xxx;
        _1133 = float4(_1337.x, _1337.y, _1337.z, _1133.w);
        float3 _1347 = (_164.xyz * _646.xxx) + _1133.xyz;
        _164 = float4(_1347.x, _1347.y, _1347.z, _164.w);
        _110 = (_105.xyxy * _110.zzww) + vs_TEXCOORD0.xyxy;
        _364.x = dot(_110.xy, _110.xy);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-3.46246814727783203125f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.z);
        _651 += 2.599999904632568359375f;
        _132.x = sin(_651);
        _154.x = cos(_651);
        float2 _1392 = _110.yx * _132.xx;
        _132 = float4(_1392.x, _132.y, _132.z, _1392.y);
        _1133.x = (_110.x * _154.x) + (-_132.x);
        _1133.y = (_110.y * _154.x) + _132.w;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1422 = _1133.xy / _364.xx;
        _110 = float4(_1422.x, _1422.y, _110.z, _110.w);
        float2 _1432 = (_110.xy * 15.0f.xx) + _132.yy;
        _110 = float4(_1432.x, _1432.y, _110.z, _110.w);
        float2 _1437 = floor(_110.xy);
        _132 = float4(_1437.x, _1437.y, _132.z, _132.w);
        float2 _1442 = frac(_110.xy);
        _110 = float4(_1442.x, _1442.y, _110.z, _110.w);
        float2 _1449 = _110.xy * _110.xy;
        _154 = float4(_1449.x, _1449.y, _154.z, _154.w);
        float2 _1456 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1456.x, _1456.y, _110.z, _110.w);
        float2 _1463 = _110.xy * _154.xy;
        _110 = float4(_1463.x, _1463.y, _110.z, _110.w);
        float2 _1468 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1468.x, _1468.y, _154.z, _154.w);
        float2 _1473 = frac(_154.xy);
        _154 = float4(_1473.x, _1473.y, _154.z, _154.w);
        float2 _1478 = _154.xy + 23.450000762939453125f.xx;
        _1133 = float4(_1478.x, _1478.y, _1133.z, _1133.w);
        _364.x = dot(_154.xy, _1133.xy);
        float2 _1491 = _364.xx + _154.xy;
        _154 = float4(_1491.x, _1491.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _1133 = _132.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _1133 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _1133 = frac(_1133);
        _1511 = _1133 + 23.450000762939453125f.xxxx;
        _651 = dot(_1133.xy, _1511.xy);
        float2 _1523 = _651.xx + _1133.xy;
        _154 = float4(_1523.x, _1523.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_1133.zw, _1511.zw);
        float2 _1555 = _651.xx + _1133.zw;
        _154 = float4(_1555.x, _1555.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        float2 _1567 = _132.xy + 1.0f.xx;
        _132 = float4(_1567.x, _1567.y, _132.z, _132.w);
        float2 _1572 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_1572.x, _1572.y, _132.z, _132.w);
        float2 _1577 = frac(_132.xy);
        _132 = float4(_1577.x, _1577.y, _132.z, _132.w);
        float2 _1582 = _132.xy + 23.450000762939453125f.xx;
        _154 = float4(_1582.x, _1582.y, _154.z, _154.w);
        _1585 = dot(_132.xy, _154.xy);
        float2 _1595 = _1585.xx + _132.xy;
        _132 = float4(_1595.x, _1595.y, _132.z, _132.w);
        _132.x = _132.y * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_651) + _132.x;
        _651 = (_110.x * _132.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        float3 _1657 = (_809.xyz * 0.666666686534881591796875f.xxx) + _16_m4.xyz;
        _132 = float4(_1657.x, _1657.y, _132.z, _1657.z);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1669 = _364.xxx * _132.xyw;
        _132 = float4(_1669.x, _1669.y, _132.z, _1669.z);
        float3 _1676 = _646.xxx * _132.xyw;
        _132 = float4(_1676.x, _1676.y, _132.z, _1676.z);
        float3 _1686 = (_132.xyw * 0.454545438289642333984375f.xxx) + _164.xyz;
        _132 = float4(_1686.x, _1686.y, _132.z, _1686.z);
        _364.x = dot(_110.zw, _110.zw);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-4.039546489715576171875f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.w);
        _651 += 3.8999998569488525390625f;
        _110.x = sin(_651);
        _154.x = cos(_651);
        float2 _1723 = _110.xx * _110.wz;
        _110 = float4(_1723.x, _1723.y, _110.z, _110.w);
        _164.x = (_110.z * _154.x) + (-_110.x);
        _164.y = (_110.w * _154.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1753 = _164.xy / _364.xx;
        _110 = float4(_1753.x, _1753.y, _110.z, _110.w);
        float2 _1763 = (_110.xy * 18.0f.xx) + _132.zz;
        _110 = float4(_1763.x, _1763.y, _110.z, _110.w);
        _1766 = floor(_110.xy);
        float2 _1772 = frac(_110.xy);
        _110 = float4(_1772.x, _1772.y, _110.z, _110.w);
        float2 _1779 = _110.xy * _110.xy;
        _154 = float4(_1779.x, _1779.y, _154.z, _154.w);
        float2 _1786 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1786.x, _1786.y, _110.z, _110.w);
        float2 _1793 = _110.xy * _154.xy;
        _110 = float4(_1793.x, _1793.y, _110.z, _110.w);
        float2 _1797 = _1766 * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1797.x, _1797.y, _154.z, _154.w);
        float2 _1802 = frac(_154.xy);
        _154 = float4(_1802.x, _1802.y, _154.z, _154.w);
        _1805 = _154.xy + 23.450000762939453125f.xx;
        _364.x = dot(_154.xy, _1805);
        float2 _1818 = _364.xx + _154.xy;
        _154 = float4(_1818.x, _1818.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _154 = _1766.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _154 = frac(_154);
        _164 = _154 + 23.450000762939453125f.xxxx;
        _651 = dot(_154.xy, _164.xy);
        float2 _1849 = _651.xx + _154.xy;
        _154 = float4(_1849.x, _1849.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_154.zw, _164.zw);
        float2 _1881 = _651.xx + _154.zw;
        _154 = float4(_1881.x, _1881.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _1766 += 1.0f.xx;
        _1766 *= float2(233.339996337890625f, 851.72998046875f);
        _1766 = frac(_1766);
        float2 _1898 = _1766 + 23.450000762939453125f.xx;
        _154 = float4(_1898.x, _1898.y, _154.z, _154.w);
        _1901 = dot(_1766, _154.xy);
        _1766 += _1901.xx;
        _1766.x = _1766.y * _1766.x;
        _1766.x = frac(_1766.x);
        _1766.x = (-_651) + _1766.x;
        _651 = (_110.x * _1766.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1971 = _364.xxx * _16_m3.xyz;
        _110 = float4(_1971.x, _1971.y, _1971.z, _110.w);
        float3 _1978 = _646.xxx * _110.xyz;
        _110 = float4(_1978.x, _1978.y, _1978.z, _110.w);
        float3 _1988 = (_110.xyz * 0.3571428358554840087890625f.xxx) + _132.xyw;
        _110 = float4(_1988.x, _1988.y, _1988.z, _110.w);
        _364.x = 1.7999999523162841796875f / (-_105.z);
        float2 _2003 = (_105.xy * _364.xx) + vs_TEXCOORD0.xy;
        _364 = float3(_2003.x, _364.y, _2003.y);
        _364.x = dot(_364.xz, _364.xz);
        _364.x *= (-7.21347522735595703125f);
        _364.x = exp2(_364.x);
        float3 _2027 = _364.xxx * _16_m5.xyz;
        _105 = float4(_2027.x, _2027.y, _2027.z, _105.w);
        float3 _2036 = (_105.xyz * 1.2999999523162841796875f.xxx) + _110.xyz;
        _105 = float4(_2036.x, _2036.y, _2036.z, _105.w);
    }
    else
    {
        _105.x = 0.0f;
        _105.y = 0.0f;
        _105.z = 0.0f;
    }
    float3 _2050 = (_16_m3.xyz * 0.3499999940395355224609375f.xxx) + _105.xyz;
    _105 = float4(_2050.x, _2050.y, _2050.z, _105.w);
    _2053.x = (-abs(_94.z)) / _9.y;
    _2053.x *= 1.44269502162933349609375f;
    _2053.x = exp2(_2053.x);
    _2071 = (-_16_m4.xyz) + _16_m5.xyz;
    _2071 = (_2071 * 0.5f.xxx) + _16_m4.xyz;
    _364 = _2053.xxx * _2071;
    _364 *= 0.89999997615814208984375f.xxx;
    _364 = (_105.xyz * _94.xxx) + _364;
    float2 _2108 = _16_m7.xx * float2(0.46153843402862548828125f, 0.100000001490116119384765625f);
    _105 = float4(_2108.x, _2108.y, _105.z, _105.w);
    _2053.x = ((-_16_m7) * 0.2307692468166351318359375f) + _49;
    float2 _2121 = 1.0f.xx / _105.xy;
    _105 = float4(_2121.x, _2121.y, _105.z, _105.w);
    _2053.x *= _105.x;
    _2053.x = clamp(_2053.x, 0.0f, 1.0f);
    _105.x = (_2053.x * (-2.0f)) + 3.0f;
    _2053.x *= _2053.x;
    _2053.x = ((-_105.x) * _2053.x) + 1.0f;
    _55.x = ((-_55.x) * _80.x) + _49;
    _55.x = max(_55.x, 0.0f);
    _55.x *= (-5.193702220916748046875f);
    _55.x = exp2(_55.x);
    _80.x = (-_94.x) + 1.0f;
    _55.x = _80.x * _55.x;
    _40 = (_40 * 22.0f.xx) + _80.yy;
    float2 _2194 = floor(_40);
    _105 = float4(_2194.x, _105.y, _2194.y, _105.w);
    _40 = frac(_40);
    float2 _2201 = _40 * _40;
    _110 = float4(_2201.x, _2201.y, _110.z, _110.w);
    _40 = ((-_40) * 2.0f.xx) + 3.0f.xx;
    _40 *= _110.xy;
    float2 _2214 = _105.xz * float2(233.339996337890625f, 851.72998046875f);
    _110 = float4(_2214.x, _2214.y, _110.z, _110.w);
    float2 _2219 = frac(_110.xy);
    _110 = float4(_2219.x, _2219.y, _110.z, _110.w);
    _1766 = _110.xy + 23.450000762939453125f.xx;
    _167 = dot(_110.xy, _1766);
    float2 _2233 = _167.xx + _110.xy;
    _110 = float4(_2233.x, _2233.y, _110.z, _110.w);
    _167 = _110.y * _110.x;
    _167 = frac(_167);
    _110 = _105.xzxz + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _110 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _110 = frac(_110);
    _132 = _110 + 23.450000762939453125f.xxxx;
    _94.x = dot(_110.xy, _132.xy);
    float2 _2262 = _94.xx + _110.xy;
    _110 = float4(_2262.x, _2262.y, _110.z, _110.w);
    _94.x = _110.y * _110.x;
    _94.x = frac(_94.x);
    _94.x = (-_167) + _94.x;
    _167 = (_40.x * _94.x) + _167;
    _94.x = dot(_110.zw, _132.zw);
    float2 _2298 = _94.xx + _110.zw;
    _110 = float4(_2298.x, _2298.y, _110.z, _110.w);
    _94.x = _110.y * _110.x;
    _94.x = frac(_94.x);
    float2 _2313 = _105.xz + 1.0f.xx;
    _105 = float4(_2313.x, _105.y, _2313.y, _105.w);
    float2 _2318 = _105.xz * float2(233.339996337890625f, 851.72998046875f);
    _105 = float4(_2318.x, _105.y, _2318.y, _105.w);
    float2 _2323 = frac(_105.xz);
    _105 = float4(_2323.x, _105.y, _2323.y, _105.w);
    float2 _2328 = _105.xz + 23.450000762939453125f.xx;
    _110 = float4(_2328.x, _2328.y, _110.z, _110.w);
    _651 = dot(_105.xz, _110.xy);
    float2 _2340 = _651.xx + _105.xz;
    _105 = float4(_2340.x, _105.y, _2340.y, _105.w);
    _105.x = _105.z * _105.x;
    _105.x = frac(_105.x);
    _105.x = (-_94.x) + _105.x;
    _40.x = (_40.x * _105.x) + _94.x;
    _40.x = (-_167) + _40.x;
    _2053.y = (_40.y * _40.x) + _167;
    float2 _2387 = _2053.xy * _2053.xy;
    _2053 = float3(_2387.x, _2387.y, _2053.z);
    _40.x = _2053.y * _2053.y;
    _2396 = _49 * (-3.1739292144775390625f);
    _2396 = exp2(_2396);
    _40.x = _2396 * _40.x;
    _40.x = _80.x * _40.x;
    _40.x *= 0.60000002384185791015625f;
    _40.x = (_55.x * 0.449999988079071044921875f) + _40.x;
    _55 = _40.xxx * _16_m6.xyz;
    _2053 = (_55 * _2053.xxx) + _364;
    _49 = ((-_16_m7) * 0.653846204280853271484375f) + _49;
    _49 = _105.y * _49;
    _49 = clamp(_49, 0.0f, 1.0f);
    _55.x = (_49 * (-2.0f)) + 3.0f;
    _49 *= _49;
    _49 = ((-_55.x) * _49) + 1.0f;
    _49 *= _16_m9;
    _9.x *= _49;
    _9 = _9.xxx * _2053;
    _2396 = vs_TEXCOORD1;
    _2396 = clamp(_2396, 0.0f, 1.0f);
    _9 *= _2396.xxx;
    _2489 = float4(_9.x, _9.y, _9.z, _2489.w);
    _2489.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2489 = _2489;
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
    vs_TEXCOORD0 = float3(_11.xy.x, _11.xy.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = 0.0f;
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
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _DeepColor;
float4 _MidColor;
float4 _HotColor;
float4 _HaloColor;
float _QuadHalfSize;
float _TearRadius;
float _Intensity;
float _Surge;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _Time
#define _16_m1 _WorldSpaceCameraPos
#define _16_m3 _DeepColor
#define _16_m4 _MidColor
#define _16_m5 _HotColor
#define _16_m6 _HaloColor
#define _16_m7 _QuadHalfSize
#define _16_m8 _TearRadius
#define _16_m9 _Intensity
#define _16_m10 _Surge



static float3 vs_TEXCOORD0;
static float4 _2480;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _2480 : SV_Target0;
};

static float3 _9;
static float2 _40;
static float _49;
static float3 _55;
static float2 _80;
static float4 _94;
static float4 _105;
static float4 _110;
static float4 _132;
static float4 _154;
static float4 _164;
static float _167;
static float3 _364;
static bool _604;
static bool _609;
static float _646;
static float _651;
static float2 _775;
static float4 _809;
static float4 _1133;
static float _1218;
static float4 _1511;
static float _1585;
static float2 _1766;
static float2 _1805;
static float _1901;
static float3 _2053;
static float3 _2071;
static float _2396;

void frag_inner()
{
    __unity_init();
    float2 _36 = (float2(float2(_16_m10, _16_m10)) * float2(1.2000000476837158203125f, 0.0199999995529651641845703125f)) + float2(1.0f, 0.02500000037252902984619140625f);
    _9 = float3(_36.x, _36.y, _9.z);
    _40 = vs_TEXCOORD0.xy * float2(1.0f, 0.769230782985687255859375f);
    _49 = dot(_40, _40);
    _49 = sqrt(_49);
    _55.x = max(_49, 9.9999997473787516355514526367188e-05f);
    _40 /= _55.xx;
    _55.x = _40.y * _40.x;
    _55.x = abs(_55.x) + abs(_55.x);
    _80.x = _55.x * _55.x;
    _55.x = _80.x * _55.x;
    _94 = (_40.xyxy * float4(5.0f, 5.0f, 13.0f, 13.0f)) + float4(3.099999904632568359375f, 3.099999904632568359375f, 9.69999980926513671875f, 9.69999980926513671875f);
    _105 = floor(_94);
    _94 = frac(_94);
    _110 = _94 * _94;
    _94 = ((-_94) * 2.0f.xxxx) + 3.0f.xxxx;
    _94 *= _110;
    _110 = _105 * float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _110 = frac(_110);
    _132 = _110 + 23.450000762939453125f.xxxx;
    _80.x = dot(_110.xy, _132.xy);
    _80 = _80.xx + _110.xy;
    _80.x = _80.y * _80.x;
    _154 = _105.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _154 = frac(_154);
    _164 = _154 + 23.450000762939453125f.xxxx;
    _167 = dot(_154.xy, _164.xy);
    float2 _177 = _167.xx + _154.xy;
    _110 = float4(_177.x, _177.y, _110.z, _110.w);
    _80.y = _110.y * _110.x;
    _80 = frac(_80);
    _167 = (-_80.x) + _80.y;
    _80.x = (_94.x * _167) + _80.x;
    _167 = dot(_154.zw, _164.zw);
    float2 _211 = _167.xx + _154.zw;
    _110 = float4(_211.x, _211.y, _110.z, _110.w);
    _167 = _110.y * _110.x;
    _167 = frac(_167);
    _154 = _105 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _154 = frac(_154);
    _164 = _154 + 23.450000762939453125f.xxxx;
    _105.x = dot(_154.xy, _164.xy);
    float2 _240 = _105.xx + _154.xy;
    _105 = float4(_240.x, _240.y, _105.z, _105.w);
    _105.x = _105.y * _105.x;
    _105.x = frac(_105.x);
    _105.x = (-_167) + _105.x;
    _167 = (_94.x * _105.x) + _167;
    _167 = (-_80.x) + _167;
    _80.x = (_94.y * _167) + _80.x;
    _167 = dot(_110.zw, _132.zw);
    float2 _288 = _167.xx + _110.zw;
    _94 = float4(_288.x, _288.y, _94.z, _94.w);
    _167 = _94.y * _94.x;
    _167 = frac(_167);
    _94.x = dot(_154.zw, _164.zw);
    float2 _308 = _94.xx + _154.zw;
    _94 = float4(_308.x, _308.y, _94.z, _94.w);
    _94.x = _94.y * _94.x;
    _94.x = frac(_94.x);
    _94.x = (-_167) + _94.x;
    _167 = (_94.z * _94.x) + _167;
    _105 = _105.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _105 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _105 = frac(_105);
    _110 = _105 + 23.450000762939453125f.xxxx;
    _94.x = dot(_105.xy, _110.xy);
    float2 _355 = _94.xx + _105.xy;
    _94 = float4(_355.x, _355.y, _94.z, _94.w);
    _94.x = _94.y * _94.x;
    _364.x = dot(_105.zw, _110.zw);
    float2 _375 = _364.xx + _105.zw;
    _105 = float4(_375.x, _375.y, _105.z, _105.w);
    _94.y = _105.y * _105.x;
    float2 _386 = frac(_94.xy);
    _94 = float4(_386.x, _386.y, _94.z, _94.w);
    _364.x = (-_94.x) + _94.y;
    _94.x = (_94.z * _364.x) + _94.x;
    _94.x = (-_167) + _94.x;
    _167 = (_94.w * _94.x) + _167;
    _167 *= 0.25f;
    _80.x = (_80.x * 0.5f) + _167;
    _80.x = (_80.x * 0.550000011920928955078125f) + 0.62000000476837158203125f;
    _55.x = (_55.x * 0.89999997615814208984375f) + _80.x;
    _55.x *= _16_m8;
    _80 = _16_m0.yy * float2(1.7000000476837158203125f, 0.07999999821186065673828125f);
    _80.x = sin(_80.x);
    _80.x = (_80.x * 0.039999999105930328369140625f) + 1.0f;
    _80.x = (_16_m10 * 0.25f) + _80.x;
    _94.x = _80.x * _55.x;
    _364.x = _94.x * 0.180000007152557373046875f;
    float2 _496 = ((-_94.xx) * float2(0.819999992847442626953125f, 0.89999997615814208984375f)) + _49.xx;
    _94 = float4(_496.x, _94.y, _496.y, _94.w);
    _364.x = 1.0f / _364.x;
    _94.x = _364.x * _94.x;
    _94.x = clamp(_94.x, 0.0f, 1.0f);
    _364.x = (_94.x * (-2.0f)) + 3.0f;
    _94.x *= _94.x;
    _94.x = ((-_364.x) * _94.x) + 1.0f;
    float3 _542 = _16_m1.yyy * _16_m2[1].xyz;
    _105 = float4(_542.x, _542.y, _542.z, _105.w);
    float3 _554 = (_16_m2[0].xyz * _16_m1.xxx) + _105.xyz;
    _105 = float4(_554.x, _554.y, _554.z, _105.w);
    float3 _566 = (_16_m2[2].xyz * _16_m1.zzz) + _105.xyz;
    _105 = float4(_566.x, _566.y, _566.z, _105.w);
    float3 _575 = _105.xyz + _16_m2[3].xyz;
    _105 = float4(_575.x, _575.y, _575.z, _105.w);
    float3 _582 = (-_105.xyz) + vs_TEXCOORD0;
    _105 = float4(_582.x, _582.y, _582.z, _105.w);
    _364.x = dot(_105.xyz, _105.xyz);
    _364.x = rsqrt(_364.x);
    float3 _599 = _364.xxx * _105.xyz;
    _105 = float4(_599.x, _599.y, _599.z, _105.w);
    _604 = 0.001000000047497451305389404296875f < _94.x;
    _609 = _105.z < (-0.0199999995529651641845703125f);
    _604 = _609 && _604;
    if (_604)
    {
        _110 = float4(0.25f, 0.800000011920928955078125f, 2.0499999523162841796875f, 4.0f) / (-_105.zzzz);
        _132 = (_105.xyxy * _110.xxyy) + vs_TEXCOORD0.xyxy;
        _364.x = dot(_132.xy, _132.xy);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-2.3083121776580810546875f);
        _651 = _9.x * _16_m0.y;
        _154 = _651.xxxx * float4(0.3499999940395355224609375f, 0.4699999988079071044921875f, 0.589999973773956298828125f, 0.709999978542327880859375f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.x);
        _110.x = sin(_651);
        _154.x = cos(_651);
        float2 _683 = _110.xx * _132.yx;
        _110 = float4(_683.x, _683.y, _110.z, _110.w);
        _164.x = (_132.x * _154.x) + (-_110.x);
        _164.y = (_132.y * _154.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _713 = _164.xy / _364.xx;
        _110 = float4(_713.x, _713.y, _110.z, _110.w);
        _364.x = _16_m0.y * 0.1500000059604644775390625f;
        float2 _728 = (_110.xy * 9.0f.xx) + _364.xx;
        _110 = float4(_728.x, _728.y, _110.z, _110.w);
        float2 _733 = floor(_110.xy);
        _132 = float4(_733.x, _733.y, _132.z, _132.w);
        float2 _738 = frac(_110.xy);
        _110 = float4(_738.x, _738.y, _110.z, _110.w);
        float2 _745 = _110.xy * _110.xy;
        _164 = float4(_745.x, _745.y, _164.z, _164.w);
        float2 _754 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_754.x, _754.y, _110.z, _110.w);
        float2 _761 = _110.xy * _164.xy;
        _110 = float4(_761.x, _761.y, _110.z, _110.w);
        float2 _767 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _164 = float4(_767.x, _767.y, _164.z, _164.w);
        float2 _772 = frac(_164.xy);
        _164 = float4(_772.x, _772.y, _164.z, _164.w);
        _775 = _164.xy + 23.450000762939453125f.xx;
        _364.x = dot(_164.xy, _775);
        float2 _789 = _364.xx + _164.xy;
        _164 = float4(_789.x, _789.y, _164.z, _164.w);
        _364.x = _164.y * _164.x;
        _364.x = frac(_364.x);
        _164 = _132.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _164 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _164 = frac(_164);
        _809 = _164 + 23.450000762939453125f.xxxx;
        _651 = dot(_164.xy, _809.xy);
        float2 _821 = _651.xx + _164.xy;
        _164 = float4(_821.x, _821.y, _164.z, _164.w);
        _651 = _164.y * _164.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_164.zw, _809.zw);
        float2 _853 = _651.xx + _164.zw;
        _164 = float4(_853.x, _853.y, _164.z, _164.w);
        _651 = _164.y * _164.x;
        _651 = frac(_651);
        float2 _866 = _132.xy + 1.0f.xx;
        _132 = float4(_866.x, _866.y, _132.z, _132.w);
        float2 _871 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_871.x, _871.y, _132.z, _132.w);
        float2 _876 = frac(_132.xy);
        _132 = float4(_876.x, _876.y, _132.z, _132.w);
        float2 _881 = _132.xy + 23.450000762939453125f.xx;
        _164 = float4(_881.x, _881.y, _164.z, _164.w);
        _154.x = dot(_132.xy, _164.xy);
        float2 _894 = _132.xy + _154.xx;
        _132 = float4(_894.x, _894.y, _132.z, _132.w);
        _132.x = _132.y * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_651) + _132.x;
        _651 = (_110.x * _132.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _960 = _364.xxx * _16_m4.xyz;
        _164 = float4(_960.x, _960.y, _960.z, _164.w);
        _364.x = dot(_132.zw, _132.zw);
        _364.x = sqrt(_364.x);
        _651 = _364.x * (-2.8853900432586669921875f);
        _110.x = (_364.x * 1.7999999523162841796875f) + (-_154.y);
        _110.x += 1.2999999523162841796875f;
        _132.x = cos(_110.x);
        _110.x = sin(_110.x);
        float2 _1002 = _110.xx * _132.wz;
        _110 = float4(_1002.x, _1002.y, _110.z, _110.w);
        _154.x = (_132.z * _132.x) + (-_110.x);
        _154.y = (_132.w * _132.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1032 = _154.xy / _364.xx;
        _110 = float4(_1032.x, _1032.y, _110.z, _110.w);
        float3 _1044 = (_16_m0.yyy * 0.1500000059604644775390625f.xxx) + float3(7.099999904632568359375f, 14.19999980926513671875f, 21.299999237060546875f);
        _132 = float4(_1044.x, _1044.y, _1044.z, _132.w);
        float2 _1054 = (_110.xy * 12.0f.xx) + _132.xx;
        _110 = float4(_1054.x, _1054.y, _110.z, _110.w);
        float2 _1059 = floor(_110.xy);
        _132 = float4(_1059.x, _132.y, _132.z, _1059.y);
        float2 _1064 = frac(_110.xy);
        _110 = float4(_1064.x, _1064.y, _110.z, _110.w);
        float2 _1071 = _110.xy * _110.xy;
        _154 = float4(_1071.x, _1071.y, _154.z, _154.w);
        float2 _1078 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1078.x, _1078.y, _110.z, _110.w);
        float2 _1085 = _110.xy * _154.xy;
        _110 = float4(_1085.x, _1085.y, _110.z, _110.w);
        float2 _1090 = _132.xw * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1090.x, _1090.y, _154.z, _154.w);
        float2 _1095 = frac(_154.xy);
        _154 = float4(_1095.x, _1095.y, _154.z, _154.w);
        float2 _1100 = _154.xy + 23.450000762939453125f.xx;
        _809 = float4(_1100.x, _1100.y, _809.z, _809.w);
        _364.x = dot(_154.xy, _809.xy);
        float2 _1113 = _364.xx + _154.xy;
        _154 = float4(_1113.x, _1113.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _809 = _132.xwxw + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _809 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _809 = frac(_809);
        _1133 = _809 + 23.450000762939453125f.xxxx;
        _154.x = dot(_809.xy, _1133.xy);
        float2 _1146 = _154.xx + _809.xy;
        _154 = float4(_1146.x, _1146.y, _154.z, _154.w);
        _154.x = _154.y * _154.x;
        _154.x = frac(_154.x);
        _154.x = (-_364.x) + _154.x;
        _364.x = (_110.x * _154.x) + _364.x;
        _154.x = dot(_809.zw, _1133.zw);
        float2 _1185 = _154.xx + _809.zw;
        _154 = float4(_1185.x, _1185.y, _154.z, _154.w);
        _154.x = _154.y * _154.x;
        _154.x = frac(_154.x);
        float2 _1200 = _132.xw + 1.0f.xx;
        _132 = float4(_1200.x, _132.y, _132.z, _1200.y);
        float2 _1205 = _132.xw * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_1205.x, _132.y, _132.z, _1205.y);
        float2 _1210 = frac(_132.xw);
        _132 = float4(_1210.x, _132.y, _132.z, _1210.y);
        float2 _1215 = _132.xw + 23.450000762939453125f.xx;
        _809 = float4(_1215.x, _1215.y, _809.z, _809.w);
        _1218 = dot(_132.xw, _809.xy);
        float2 _1228 = _132.xw + _1218.xx;
        _132 = float4(_1228.x, _132.y, _132.z, _1228.y);
        _132.x = _132.w * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_154.x) + _132.x;
        _110.x = (_110.x * _132.x) + _154.x;
        _110.x = (-_364.x) + _110.x;
        _364.x = (_110.y * _110.x) + _364.x;
        _110.x = _364.x * _364.x;
        _110.x *= _110.x;
        _364.x *= _110.x;
        _651 = exp2(_651);
        float3 _1300 = _16_m3.xyz + (-_16_m4.xyz);
        _809 = float4(_1300.x, _1300.y, _1300.z, _809.w);
        float3 _1311 = (_809.xyz * 0.3333333432674407958984375f.xxx) + _16_m4.xyz;
        _1133 = float4(_1311.x, _1311.y, _1311.z, _1133.w);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1323 = _364.xxx * _1133.xyz;
        _1133 = float4(_1323.x, _1323.y, _1323.z, _1133.w);
        float3 _1330 = _651.xxx * _1133.xyz;
        _1133 = float4(_1330.x, _1330.y, _1330.z, _1133.w);
        float3 _1337 = _1133.xyz * 0.625f.xxx;
        _1133 = float4(_1337.x, _1337.y, _1337.z, _1133.w);
        float3 _1347 = (_164.xyz * _646.xxx) + _1133.xyz;
        _164 = float4(_1347.x, _1347.y, _1347.z, _164.w);
        _110 = (_105.xyxy * _110.zzww) + vs_TEXCOORD0.xyxy;
        _364.x = dot(_110.xy, _110.xy);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-3.46246814727783203125f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.z);
        _651 += 2.599999904632568359375f;
        _132.x = sin(_651);
        _154.x = cos(_651);
        float2 _1392 = _110.yx * _132.xx;
        _132 = float4(_1392.x, _132.y, _132.z, _1392.y);
        _1133.x = (_110.x * _154.x) + (-_132.x);
        _1133.y = (_110.y * _154.x) + _132.w;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1422 = _1133.xy / _364.xx;
        _110 = float4(_1422.x, _1422.y, _110.z, _110.w);
        float2 _1432 = (_110.xy * 15.0f.xx) + _132.yy;
        _110 = float4(_1432.x, _1432.y, _110.z, _110.w);
        float2 _1437 = floor(_110.xy);
        _132 = float4(_1437.x, _1437.y, _132.z, _132.w);
        float2 _1442 = frac(_110.xy);
        _110 = float4(_1442.x, _1442.y, _110.z, _110.w);
        float2 _1449 = _110.xy * _110.xy;
        _154 = float4(_1449.x, _1449.y, _154.z, _154.w);
        float2 _1456 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1456.x, _1456.y, _110.z, _110.w);
        float2 _1463 = _110.xy * _154.xy;
        _110 = float4(_1463.x, _1463.y, _110.z, _110.w);
        float2 _1468 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1468.x, _1468.y, _154.z, _154.w);
        float2 _1473 = frac(_154.xy);
        _154 = float4(_1473.x, _1473.y, _154.z, _154.w);
        float2 _1478 = _154.xy + 23.450000762939453125f.xx;
        _1133 = float4(_1478.x, _1478.y, _1133.z, _1133.w);
        _364.x = dot(_154.xy, _1133.xy);
        float2 _1491 = _364.xx + _154.xy;
        _154 = float4(_1491.x, _1491.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _1133 = _132.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _1133 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _1133 = frac(_1133);
        _1511 = _1133 + 23.450000762939453125f.xxxx;
        _651 = dot(_1133.xy, _1511.xy);
        float2 _1523 = _651.xx + _1133.xy;
        _154 = float4(_1523.x, _1523.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_1133.zw, _1511.zw);
        float2 _1555 = _651.xx + _1133.zw;
        _154 = float4(_1555.x, _1555.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        float2 _1567 = _132.xy + 1.0f.xx;
        _132 = float4(_1567.x, _1567.y, _132.z, _132.w);
        float2 _1572 = _132.xy * float2(233.339996337890625f, 851.72998046875f);
        _132 = float4(_1572.x, _1572.y, _132.z, _132.w);
        float2 _1577 = frac(_132.xy);
        _132 = float4(_1577.x, _1577.y, _132.z, _132.w);
        float2 _1582 = _132.xy + 23.450000762939453125f.xx;
        _154 = float4(_1582.x, _1582.y, _154.z, _154.w);
        _1585 = dot(_132.xy, _154.xy);
        float2 _1595 = _1585.xx + _132.xy;
        _132 = float4(_1595.x, _1595.y, _132.z, _132.w);
        _132.x = _132.y * _132.x;
        _132.x = frac(_132.x);
        _132.x = (-_651) + _132.x;
        _651 = (_110.x * _132.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        float3 _1657 = (_809.xyz * 0.666666686534881591796875f.xxx) + _16_m4.xyz;
        _132 = float4(_1657.x, _1657.y, _132.z, _1657.z);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1669 = _364.xxx * _132.xyw;
        _132 = float4(_1669.x, _1669.y, _132.z, _1669.z);
        float3 _1676 = _646.xxx * _132.xyw;
        _132 = float4(_1676.x, _1676.y, _132.z, _1676.z);
        float3 _1686 = (_132.xyw * 0.454545438289642333984375f.xxx) + _164.xyz;
        _132 = float4(_1686.x, _1686.y, _132.z, _1686.z);
        _364.x = dot(_110.zw, _110.zw);
        _364.x = sqrt(_364.x);
        _646 = _364.x * (-4.039546489715576171875f);
        _651 = (_364.x * 1.7999999523162841796875f) + (-_154.w);
        _651 += 3.8999998569488525390625f;
        _110.x = sin(_651);
        _154.x = cos(_651);
        float2 _1723 = _110.xx * _110.wz;
        _110 = float4(_1723.x, _1723.y, _110.z, _110.w);
        _164.x = (_110.z * _154.x) + (-_110.x);
        _164.y = (_110.w * _154.x) + _110.y;
        _364.x = max(_364.x, 9.9999997473787516355514526367188e-05f);
        float2 _1753 = _164.xy / _364.xx;
        _110 = float4(_1753.x, _1753.y, _110.z, _110.w);
        float2 _1763 = (_110.xy * 18.0f.xx) + _132.zz;
        _110 = float4(_1763.x, _1763.y, _110.z, _110.w);
        _1766 = floor(_110.xy);
        float2 _1772 = frac(_110.xy);
        _110 = float4(_1772.x, _1772.y, _110.z, _110.w);
        float2 _1779 = _110.xy * _110.xy;
        _154 = float4(_1779.x, _1779.y, _154.z, _154.w);
        float2 _1786 = ((-_110.xy) * 2.0f.xx) + 3.0f.xx;
        _110 = float4(_1786.x, _1786.y, _110.z, _110.w);
        float2 _1793 = _110.xy * _154.xy;
        _110 = float4(_1793.x, _1793.y, _110.z, _110.w);
        float2 _1797 = _1766 * float2(233.339996337890625f, 851.72998046875f);
        _154 = float4(_1797.x, _1797.y, _154.z, _154.w);
        float2 _1802 = frac(_154.xy);
        _154 = float4(_1802.x, _1802.y, _154.z, _154.w);
        _1805 = _154.xy + 23.450000762939453125f.xx;
        _364.x = dot(_154.xy, _1805);
        float2 _1818 = _364.xx + _154.xy;
        _154 = float4(_1818.x, _1818.y, _154.z, _154.w);
        _364.x = _154.y * _154.x;
        _364.x = frac(_364.x);
        _154 = _1766.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
        _154 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
        _154 = frac(_154);
        _164 = _154 + 23.450000762939453125f.xxxx;
        _651 = dot(_154.xy, _164.xy);
        float2 _1849 = _651.xx + _154.xy;
        _154 = float4(_1849.x, _1849.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _651 = (-_364.x) + _651;
        _364.x = (_110.x * _651) + _364.x;
        _651 = dot(_154.zw, _164.zw);
        float2 _1881 = _651.xx + _154.zw;
        _154 = float4(_1881.x, _1881.y, _154.z, _154.w);
        _651 = _154.y * _154.x;
        _651 = frac(_651);
        _1766 += 1.0f.xx;
        _1766 *= float2(233.339996337890625f, 851.72998046875f);
        _1766 = frac(_1766);
        float2 _1898 = _1766 + 23.450000762939453125f.xx;
        _154 = float4(_1898.x, _1898.y, _154.z, _154.w);
        _1901 = dot(_1766, _154.xy);
        _1766 += _1901.xx;
        _1766.x = _1766.y * _1766.x;
        _1766.x = frac(_1766.x);
        _1766.x = (-_651) + _1766.x;
        _651 = (_110.x * _1766.x) + _651;
        _651 = (-_364.x) + _651;
        _364.x = (_110.y * _651) + _364.x;
        _651 = _364.x * _364.x;
        _651 *= _651;
        _364.x *= _651;
        _646 = exp2(_646);
        _364.x = (_364.x * 1.39999997615814208984375f) + 0.180000007152557373046875f;
        float3 _1971 = _364.xxx * _16_m3.xyz;
        _110 = float4(_1971.x, _1971.y, _1971.z, _110.w);
        float3 _1978 = _646.xxx * _110.xyz;
        _110 = float4(_1978.x, _1978.y, _1978.z, _110.w);
        float3 _1988 = (_110.xyz * 0.3571428358554840087890625f.xxx) + _132.xyw;
        _110 = float4(_1988.x, _1988.y, _1988.z, _110.w);
        _364.x = 1.7999999523162841796875f / (-_105.z);
        float2 _2003 = (_105.xy * _364.xx) + vs_TEXCOORD0.xy;
        _364 = float3(_2003.x, _364.y, _2003.y);
        _364.x = dot(_364.xz, _364.xz);
        _364.x *= (-7.21347522735595703125f);
        _364.x = exp2(_364.x);
        float3 _2027 = _364.xxx * _16_m5.xyz;
        _105 = float4(_2027.x, _2027.y, _2027.z, _105.w);
        float3 _2036 = (_105.xyz * 1.2999999523162841796875f.xxx) + _110.xyz;
        _105 = float4(_2036.x, _2036.y, _2036.z, _105.w);
    }
    else
    {
        _105.x = 0.0f;
        _105.y = 0.0f;
        _105.z = 0.0f;
    }
    float3 _2050 = (_16_m3.xyz * 0.3499999940395355224609375f.xxx) + _105.xyz;
    _105 = float4(_2050.x, _2050.y, _2050.z, _105.w);
    _2053.x = (-abs(_94.z)) / _9.y;
    _2053.x *= 1.44269502162933349609375f;
    _2053.x = exp2(_2053.x);
    _2071 = (-_16_m4.xyz) + _16_m5.xyz;
    _2071 = (_2071 * 0.5f.xxx) + _16_m4.xyz;
    _364 = _2053.xxx * _2071;
    _364 *= 0.89999997615814208984375f.xxx;
    _364 = (_105.xyz * _94.xxx) + _364;
    float2 _2108 = _16_m7.xx * float2(0.46153843402862548828125f, 0.100000001490116119384765625f);
    _105 = float4(_2108.x, _2108.y, _105.z, _105.w);
    _2053.x = ((-_16_m7) * 0.2307692468166351318359375f) + _49;
    float2 _2121 = 1.0f.xx / _105.xy;
    _105 = float4(_2121.x, _2121.y, _105.z, _105.w);
    _2053.x *= _105.x;
    _2053.x = clamp(_2053.x, 0.0f, 1.0f);
    _105.x = (_2053.x * (-2.0f)) + 3.0f;
    _2053.x *= _2053.x;
    _2053.x = ((-_105.x) * _2053.x) + 1.0f;
    _55.x = ((-_55.x) * _80.x) + _49;
    _55.x = max(_55.x, 0.0f);
    _55.x *= (-5.193702220916748046875f);
    _55.x = exp2(_55.x);
    _80.x = (-_94.x) + 1.0f;
    _55.x = _80.x * _55.x;
    _40 = (_40 * 22.0f.xx) + _80.yy;
    float2 _2194 = floor(_40);
    _105 = float4(_2194.x, _105.y, _2194.y, _105.w);
    _40 = frac(_40);
    float2 _2201 = _40 * _40;
    _110 = float4(_2201.x, _2201.y, _110.z, _110.w);
    _40 = ((-_40) * 2.0f.xx) + 3.0f.xx;
    _40 *= _110.xy;
    float2 _2214 = _105.xz * float2(233.339996337890625f, 851.72998046875f);
    _110 = float4(_2214.x, _2214.y, _110.z, _110.w);
    float2 _2219 = frac(_110.xy);
    _110 = float4(_2219.x, _2219.y, _110.z, _110.w);
    _1766 = _110.xy + 23.450000762939453125f.xx;
    _167 = dot(_110.xy, _1766);
    float2 _2233 = _167.xx + _110.xy;
    _110 = float4(_2233.x, _2233.y, _110.z, _110.w);
    _167 = _110.y * _110.x;
    _167 = frac(_167);
    _110 = _105.xzxz + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _110 *= float4(233.339996337890625f, 851.72998046875f, 233.339996337890625f, 851.72998046875f);
    _110 = frac(_110);
    _132 = _110 + 23.450000762939453125f.xxxx;
    _94.x = dot(_110.xy, _132.xy);
    float2 _2262 = _94.xx + _110.xy;
    _110 = float4(_2262.x, _2262.y, _110.z, _110.w);
    _94.x = _110.y * _110.x;
    _94.x = frac(_94.x);
    _94.x = (-_167) + _94.x;
    _167 = (_40.x * _94.x) + _167;
    _94.x = dot(_110.zw, _132.zw);
    float2 _2298 = _94.xx + _110.zw;
    _110 = float4(_2298.x, _2298.y, _110.z, _110.w);
    _94.x = _110.y * _110.x;
    _94.x = frac(_94.x);
    float2 _2313 = _105.xz + 1.0f.xx;
    _105 = float4(_2313.x, _105.y, _2313.y, _105.w);
    float2 _2318 = _105.xz * float2(233.339996337890625f, 851.72998046875f);
    _105 = float4(_2318.x, _105.y, _2318.y, _105.w);
    float2 _2323 = frac(_105.xz);
    _105 = float4(_2323.x, _105.y, _2323.y, _105.w);
    float2 _2328 = _105.xz + 23.450000762939453125f.xx;
    _110 = float4(_2328.x, _2328.y, _110.z, _110.w);
    _651 = dot(_105.xz, _110.xy);
    float2 _2340 = _651.xx + _105.xz;
    _105 = float4(_2340.x, _105.y, _2340.y, _105.w);
    _105.x = _105.z * _105.x;
    _105.x = frac(_105.x);
    _105.x = (-_94.x) + _105.x;
    _40.x = (_40.x * _105.x) + _94.x;
    _40.x = (-_167) + _40.x;
    _2053.y = (_40.y * _40.x) + _167;
    float2 _2387 = _2053.xy * _2053.xy;
    _2053 = float3(_2387.x, _2387.y, _2053.z);
    _40.x = _2053.y * _2053.y;
    _2396 = _49 * (-3.1739292144775390625f);
    _2396 = exp2(_2396);
    _40.x = _2396 * _40.x;
    _40.x = _80.x * _40.x;
    _40.x *= 0.60000002384185791015625f;
    _40.x = (_55.x * 0.449999988079071044921875f) + _40.x;
    _55 = _40.xxx * _16_m6.xyz;
    _2053 = (_55 * _2053.xxx) + _364;
    _49 = ((-_16_m7) * 0.653846204280853271484375f) + _49;
    _49 = _105.y * _49;
    _49 = clamp(_49, 0.0f, 1.0f);
    _55.x = (_49 * (-2.0f)) + 3.0f;
    _49 *= _49;
    _49 = ((-_55.x) * _49) + 1.0f;
    _49 *= _16_m9;
    _9.x *= _49;
    _9 = _9.xxx * _2053;
    _2480 = float4(_9.x, _9.y, _9.z, _2480.w);
    _2480.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._2480 = _2480;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}