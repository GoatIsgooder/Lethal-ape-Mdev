// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmPotionLiquid" {
Properties {

_LiquidColor ("Liquid Color", Color) = (0.45,0.85,0.3,1)

_Fill ("Fill Height (object units from pivot)", Float) = 0.009600000455975533

_WobbleX ("Wobble X", Range(-1.5, 1.5)) = 0.0

_WobbleZ ("Wobble Z", Range(-1.5, 1.5)) = 0.0

_FoamColor ("Foam Color", Color) = (1,0.96,0.88,1)

_FoamMix ("Foam Mix", Range(0, 1)) = 0.4000000059604645

_FoamWidth ("Foam Width", Float) = 0.0024999999441206455

_Depth ("Depth Darkening", Range(0, 1)) = 0.550000011920929

_Glow ("Glow", Range(0, 3)) = 0.699999988079071

_RimPower ("Inner Rim Power", Range(0.5, 8)) = 2.200000047683716

_RimBoost ("Inner Rim Boost", Range(0, 3)) = 1.100000023841858

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
 Pass {
ZWrite On
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
 Cull Off
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
float _RimPower;
float _RimBoost;
float4 _LiquidColor;
float _Fill;
float _WobbleX;
float _WobbleZ;
void __unity_init()
{
    _22_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _ProjectionParams
#define _22_m5 unity_FogParams
#define _22_m6 _RimPower
#define _22_m7 _RimBoost
#define _22_m8 _LiquidColor
#define _22_m9 _Fill
#define _22_m10 _WobbleX
#define _22_m11 _WobbleZ



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float3 _219;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _219 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float _252;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m2[1];
    _9 = (_22_m2[0] * _11.xxxx) + _9;
    _9 = (_22_m2[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m2[3];
    float3 _59 = (_22_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _45.yyyy * _22_m4[1];
    _62 = (_22_m4[0] * _45.xxxx) + _62;
    _62 = (_22_m4[2] * _45.zzzz) + _62;
    _45 = (_22_m4[3] * _45.wwww) + _62;
    gl_Position = _45;
    _99 = _45.z / _22_m1.y;
    _99 = (-_99) + 1.0f;
    _99 *= _22_m1.z;
    _99 = max(_99, 0.0f);
    _99 *= _22_m5.y;
    vs_TEXCOORD4 = exp2(-_99);
    float3 _134 = _9.xyz + (-_22_m2[3].xyz);
    _45 = float4(_134.x, _134.y, _134.z, _45.w);
    float3 _143 = (-_9.xyz) + _22_m0;
    _9 = float4(_143.x, _143.y, _143.z, _9.w);
    _99 = dot(_22_m2[1].xyz, _22_m2[1].xyz);
    _99 = sqrt(_99);
    _99 = max(_99, 9.9999997473787516355514526367188e-06f);
    float3 _162 = _45.xyz / _99.xxx;
    _45 = float4(_162.x, _162.y, _162.z, _45.w);
    _99 = (_45.x * _22_m10) + _45.y;
    _99 = (_45.z * _22_m11) + _99;
    _99 += (-_22_m9);
    vs_TEXCOORD0 = _99;
    _99 *= (-18.0f);
    _99 = clamp(_99, 0.0f, 1.0f);
    vs_TEXCOORD3 = _99;
    vs_TEXCOORD1 = _22_m8.xyz;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    float3 _215 = _99.xxx * _9.xyz;
    _9 = float4(_215.x, _215.y, _215.z, _9.w);
    _45.x = dot(_219, _22_m3[0].xyz);
    _45.y = dot(_219, _22_m3[1].xyz);
    _45.z = dot(_219, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _249 = _99.xxx * _45.xyz;
    _45 = float4(_249.x, _249.y, _249.z, _45.w);
    _252 = dot(_45.xyz, _9.xyz);
    _252 = min(abs(_252), 1.0f);
    _252 = (-_252) + 1.0f;
    _252 = log2(_252);
    _252 *= _22_m6;
    _252 = exp2(_252);
    vs_TEXCOORD2 = _252 * _22_m7;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _219 = stage_input._219;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _FoamColor;
float _FoamMix;
float _FoamWidth;
float _Depth;
float _Glow;
#define _33_m0 unity_FogColor
#define _33_m1 _FoamColor
#define _33_m2 _FoamMix
#define _33_m3 _FoamWidth
#define _33_m4 _Depth
#define _33_m5 _Glow



static bool gl_FrontFacing;
static float vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD4;
static float4 _216;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _216 : SV_Target0;
};

static bool _8;
static float3 _29;
static float _49;
static float3 _80;
static float3 _98;
static float3 _125;
static float4 _142;
static float _202;

void frag_inner()
{
    _8 = (-vs_TEXCOORD0) < 0.0f;
    if ((int(_8) * (-1)) != 0)
    {
        discard;
    }
    _29.x = _33_m3 * 0.64999997615814208984375f;
    _29.x = 1.0f / _29.x;
    _49 = vs_TEXCOORD0 + _33_m3;
    _29.x *= _49;
    _29.x = clamp(_29.x, 0.0f, 1.0f);
    _49 = (_29.x * (-2.0f)) + 3.0f;
    _29.x *= _29.x;
    _29.x *= _49;
    _80.x = (vs_TEXCOORD3 * (-_33_m4)) + 1.0f;
    _80.x = (_80.x * 0.550000011920928955078125f) + vs_TEXCOORD2;
    _98 = vs_TEXCOORD1 * float3(float3(_33_m5, _33_m5, _33_m5));
    _98 *= 0.5f.xxx;
    _80 = (vs_TEXCOORD1 * _80.xxx) + _98;
    _125 = (-vs_TEXCOORD1) + _33_m1.xyz;
    _125 = (_33_m2.xxx * _125) + vs_TEXCOORD1;
    float2 _159 = (float2(float2(_33_m5, _33_m5)) * float2(0.4000000059604644775390625f, 0.3499999940395355224609375f)) + float2(0.89999997615814208984375f, 0.75f);
    _142 = float4(_159.x, _159.y, _142.z, _142.w);
    float3 _168 = (_125 * _142.xxx) + (-_80);
    _142 = float4(_168.x, _142.y, _168.y, _168.z);
    _80 = (_29.xxx * _142.xzw) + _80;
    _125 *= _142.yyy;
    float3 _189;
    if ((gl_FrontFacing ? 4294967295u : 0u) != 0u)
    {
        _189 = _80;
    }
    else
    {
        _189 = _125;
    }
    _80 = _189;
    _29 = _80 + (-_33_m0.xyz);
    _202 = vs_TEXCOORD4;
    _202 = clamp(_202, 0.0f, 1.0f);
    _29 = (_202.xxx * _29) + _33_m0.xyz;
    _216 = float4(_29.x, _29.y, _29.z, _216.w);
    _216.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._216 = _216;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
float _RimPower;
float _RimBoost;
float4 _LiquidColor;
float _Fill;
float _WobbleX;
float _WobbleZ;
void __unity_init()
{
    _22_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _ProjectionParams
#define _22_m5 unity_FogParams
#define _22_m6 _RimPower
#define _22_m7 _RimBoost
#define _22_m8 _LiquidColor
#define _22_m9 _Fill
#define _22_m10 _WobbleX
#define _22_m11 _WobbleZ



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float3 _222;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _222 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float _255;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m2[1];
    _9 = (_22_m2[0] * _11.xxxx) + _9;
    _9 = (_22_m2[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m2[3];
    float3 _59 = (_22_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _45.yyyy * _22_m4[1];
    _62 = (_22_m4[0] * _45.xxxx) + _62;
    _62 = (_22_m4[2] * _45.zzzz) + _62;
    _45 = (_22_m4[3] * _45.wwww) + _62;
    gl_Position = _45;
    _99 = _45.z / _22_m1.y;
    _99 = (-_99) + 1.0f;
    _99 *= _22_m1.z;
    _99 = max(_99, 0.0f);
    _99 *= _22_m5.x;
    _99 *= (-_99);
    vs_TEXCOORD4 = exp2(_99);
    float3 _138 = _9.xyz + (-_22_m2[3].xyz);
    _45 = float4(_138.x, _138.y, _138.z, _45.w);
    float3 _147 = (-_9.xyz) + _22_m0;
    _9 = float4(_147.x, _147.y, _147.z, _9.w);
    _99 = dot(_22_m2[1].xyz, _22_m2[1].xyz);
    _99 = sqrt(_99);
    _99 = max(_99, 9.9999997473787516355514526367188e-06f);
    float3 _166 = _45.xyz / _99.xxx;
    _45 = float4(_166.x, _166.y, _166.z, _45.w);
    _99 = (_45.x * _22_m10) + _45.y;
    _99 = (_45.z * _22_m11) + _99;
    _99 += (-_22_m9);
    vs_TEXCOORD0 = _99;
    _99 *= (-18.0f);
    _99 = clamp(_99, 0.0f, 1.0f);
    vs_TEXCOORD3 = _99;
    vs_TEXCOORD1 = _22_m8.xyz;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    float3 _218 = _99.xxx * _9.xyz;
    _9 = float4(_218.x, _218.y, _218.z, _9.w);
    _45.x = dot(_222, _22_m3[0].xyz);
    _45.y = dot(_222, _22_m3[1].xyz);
    _45.z = dot(_222, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _252 = _99.xxx * _45.xyz;
    _45 = float4(_252.x, _252.y, _252.z, _45.w);
    _255 = dot(_45.xyz, _9.xyz);
    _255 = min(abs(_255), 1.0f);
    _255 = (-_255) + 1.0f;
    _255 = log2(_255);
    _255 *= _22_m6;
    _255 = exp2(_255);
    vs_TEXCOORD2 = _255 * _22_m7;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _222 = stage_input._222;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _FoamColor;
float _FoamMix;
float _FoamWidth;
float _Depth;
float _Glow;
#define _33_m0 unity_FogColor
#define _33_m1 _FoamColor
#define _33_m2 _FoamMix
#define _33_m3 _FoamWidth
#define _33_m4 _Depth
#define _33_m5 _Glow



static bool gl_FrontFacing;
static float vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD4;
static float4 _216;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _216 : SV_Target0;
};

static bool _8;
static float3 _29;
static float _49;
static float3 _80;
static float3 _98;
static float3 _125;
static float4 _142;
static float _202;

void frag_inner()
{
    _8 = (-vs_TEXCOORD0) < 0.0f;
    if ((int(_8) * (-1)) != 0)
    {
        discard;
    }
    _29.x = _33_m3 * 0.64999997615814208984375f;
    _29.x = 1.0f / _29.x;
    _49 = vs_TEXCOORD0 + _33_m3;
    _29.x *= _49;
    _29.x = clamp(_29.x, 0.0f, 1.0f);
    _49 = (_29.x * (-2.0f)) + 3.0f;
    _29.x *= _29.x;
    _29.x *= _49;
    _80.x = (vs_TEXCOORD3 * (-_33_m4)) + 1.0f;
    _80.x = (_80.x * 0.550000011920928955078125f) + vs_TEXCOORD2;
    _98 = vs_TEXCOORD1 * float3(float3(_33_m5, _33_m5, _33_m5));
    _98 *= 0.5f.xxx;
    _80 = (vs_TEXCOORD1 * _80.xxx) + _98;
    _125 = (-vs_TEXCOORD1) + _33_m1.xyz;
    _125 = (_33_m2.xxx * _125) + vs_TEXCOORD1;
    float2 _159 = (float2(float2(_33_m5, _33_m5)) * float2(0.4000000059604644775390625f, 0.3499999940395355224609375f)) + float2(0.89999997615814208984375f, 0.75f);
    _142 = float4(_159.x, _159.y, _142.z, _142.w);
    float3 _168 = (_125 * _142.xxx) + (-_80);
    _142 = float4(_168.x, _142.y, _168.y, _168.z);
    _80 = (_29.xxx * _142.xzw) + _80;
    _125 *= _142.yyy;
    float3 _189;
    if ((gl_FrontFacing ? 4294967295u : 0u) != 0u)
    {
        _189 = _80;
    }
    else
    {
        _189 = _125;
    }
    _80 = _189;
    _29 = _80 + (-_33_m0.xyz);
    _202 = vs_TEXCOORD4;
    _202 = clamp(_202, 0.0f, 1.0f);
    _29 = (_202.xxx * _29) + _33_m0.xyz;
    _216 = float4(_29.x, _29.y, _29.z, _216.w);
    _216.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._216 = _216;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
float _RimPower;
float _RimBoost;
float4 _LiquidColor;
float _Fill;
float _WobbleX;
float _WobbleZ;
void __unity_init()
{
    _22_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _ProjectionParams
#define _22_m5 unity_FogParams
#define _22_m6 _RimPower
#define _22_m7 _RimBoost
#define _22_m8 _LiquidColor
#define _22_m9 _Fill
#define _22_m10 _WobbleX
#define _22_m11 _WobbleZ



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float3 _220;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _220 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float _253;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m2[1];
    _9 = (_22_m2[0] * _11.xxxx) + _9;
    _9 = (_22_m2[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m2[3];
    float3 _59 = (_22_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _45.yyyy * _22_m4[1];
    _62 = (_22_m4[0] * _45.xxxx) + _62;
    _62 = (_22_m4[2] * _45.zzzz) + _62;
    _45 = (_22_m4[3] * _45.wwww) + _62;
    gl_Position = _45;
    _99 = _45.z / _22_m1.y;
    _99 = (-_99) + 1.0f;
    _99 *= _22_m1.z;
    _99 = max(_99, 0.0f);
    vs_TEXCOORD4 = (_99 * _22_m5.z) + _22_m5.w;
    float3 _135 = _9.xyz + (-_22_m2[3].xyz);
    _45 = float4(_135.x, _135.y, _135.z, _45.w);
    float3 _144 = (-_9.xyz) + _22_m0;
    _9 = float4(_144.x, _144.y, _144.z, _9.w);
    _99 = dot(_22_m2[1].xyz, _22_m2[1].xyz);
    _99 = sqrt(_99);
    _99 = max(_99, 9.9999997473787516355514526367188e-06f);
    float3 _163 = _45.xyz / _99.xxx;
    _45 = float4(_163.x, _163.y, _163.z, _45.w);
    _99 = (_45.x * _22_m10) + _45.y;
    _99 = (_45.z * _22_m11) + _99;
    _99 += (-_22_m9);
    vs_TEXCOORD0 = _99;
    _99 *= (-18.0f);
    _99 = clamp(_99, 0.0f, 1.0f);
    vs_TEXCOORD3 = _99;
    vs_TEXCOORD1 = _22_m8.xyz;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    float3 _216 = _99.xxx * _9.xyz;
    _9 = float4(_216.x, _216.y, _216.z, _9.w);
    _45.x = dot(_220, _22_m3[0].xyz);
    _45.y = dot(_220, _22_m3[1].xyz);
    _45.z = dot(_220, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _250 = _99.xxx * _45.xyz;
    _45 = float4(_250.x, _250.y, _250.z, _45.w);
    _253 = dot(_45.xyz, _9.xyz);
    _253 = min(abs(_253), 1.0f);
    _253 = (-_253) + 1.0f;
    _253 = log2(_253);
    _253 *= _22_m6;
    _253 = exp2(_253);
    vs_TEXCOORD2 = _253 * _22_m7;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _220 = stage_input._220;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _FoamColor;
float _FoamMix;
float _FoamWidth;
float _Depth;
float _Glow;
#define _33_m0 unity_FogColor
#define _33_m1 _FoamColor
#define _33_m2 _FoamMix
#define _33_m3 _FoamWidth
#define _33_m4 _Depth
#define _33_m5 _Glow



static bool gl_FrontFacing;
static float vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD4;
static float4 _216;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD4 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _216 : SV_Target0;
};

static bool _8;
static float3 _29;
static float _49;
static float3 _80;
static float3 _98;
static float3 _125;
static float4 _142;
static float _202;

void frag_inner()
{
    _8 = (-vs_TEXCOORD0) < 0.0f;
    if ((int(_8) * (-1)) != 0)
    {
        discard;
    }
    _29.x = _33_m3 * 0.64999997615814208984375f;
    _29.x = 1.0f / _29.x;
    _49 = vs_TEXCOORD0 + _33_m3;
    _29.x *= _49;
    _29.x = clamp(_29.x, 0.0f, 1.0f);
    _49 = (_29.x * (-2.0f)) + 3.0f;
    _29.x *= _29.x;
    _29.x *= _49;
    _80.x = (vs_TEXCOORD3 * (-_33_m4)) + 1.0f;
    _80.x = (_80.x * 0.550000011920928955078125f) + vs_TEXCOORD2;
    _98 = vs_TEXCOORD1 * float3(float3(_33_m5, _33_m5, _33_m5));
    _98 *= 0.5f.xxx;
    _80 = (vs_TEXCOORD1 * _80.xxx) + _98;
    _125 = (-vs_TEXCOORD1) + _33_m1.xyz;
    _125 = (_33_m2.xxx * _125) + vs_TEXCOORD1;
    float2 _159 = (float2(float2(_33_m5, _33_m5)) * float2(0.4000000059604644775390625f, 0.3499999940395355224609375f)) + float2(0.89999997615814208984375f, 0.75f);
    _142 = float4(_159.x, _159.y, _142.z, _142.w);
    float3 _168 = (_125 * _142.xxx) + (-_80);
    _142 = float4(_168.x, _142.y, _168.y, _168.z);
    _80 = (_29.xxx * _142.xzw) + _80;
    _125 *= _142.yyy;
    float3 _189;
    if ((gl_FrontFacing ? 4294967295u : 0u) != 0u)
    {
        _189 = _80;
    }
    else
    {
        _189 = _125;
    }
    _80 = _189;
    _29 = _80 + (-_33_m0.xyz);
    _202 = vs_TEXCOORD4;
    _202 = clamp(_202, 0.0f, 1.0f);
    _29 = (_202.xxx * _29) + _33_m0.xyz;
    _216 = float4(_29.x, _29.y, _29.z, _216.w);
    _216.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._216 = _216;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float _RimPower;
float _RimBoost;
float4 _LiquidColor;
float _Fill;
float _WobbleX;
float _WobbleZ;
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m4 _RimPower
#define _22_m5 _RimBoost
#define _22_m6 _LiquidColor
#define _22_m7 _Fill
#define _22_m8 _WobbleX
#define _22_m9 _WobbleZ



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float3 _194;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _194 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _115;
static float _227;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    float3 _59 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _45.yyyy * _22_m3[1];
    _62 = (_22_m3[0] * _45.xxxx) + _62;
    _62 = (_22_m3[2] * _45.zzzz) + _62;
    gl_Position = (_22_m3[3] * _45.wwww) + _62;
    float3 _102 = _9.xyz + (-_22_m1[3].xyz);
    _45 = float4(_102.x, _102.y, _102.z, _45.w);
    float3 _111 = (-_9.xyz) + _22_m0;
    _9 = float4(_111.x, _111.y, _111.z, _9.w);
    _115 = dot(_22_m1[1].xyz, _22_m1[1].xyz);
    _115 = sqrt(_115);
    _115 = max(_115, 9.9999997473787516355514526367188e-06f);
    float3 _132 = _45.xyz / _115.xxx;
    _45 = float4(_132.x, _132.y, _132.z, _45.w);
    _115 = (_45.x * _22_m8) + _45.y;
    _115 = (_45.z * _22_m9) + _115;
    _115 += (-_22_m7);
    vs_TEXCOORD0 = _115;
    _115 *= (-18.0f);
    _115 = clamp(_115, 0.0f, 1.0f);
    vs_TEXCOORD3 = _115;
    vs_TEXCOORD1 = _22_m6.xyz;
    _115 = dot(_9.xyz, _9.xyz);
    _115 = rsqrt(_115);
    float3 _190 = _115.xxx * _9.xyz;
    _9 = float4(_190.x, _190.y, _190.z, _9.w);
    _45.x = dot(_194, _22_m2[0].xyz);
    _45.y = dot(_194, _22_m2[1].xyz);
    _45.z = dot(_194, _22_m2[2].xyz);
    _115 = dot(_45.xyz, _45.xyz);
    _115 = rsqrt(_115);
    float3 _224 = _115.xxx * _45.xyz;
    _45 = float4(_224.x, _224.y, _224.z, _45.w);
    _227 = dot(_45.xyz, _9.xyz);
    _227 = min(abs(_227), 1.0f);
    _227 = (-_227) + 1.0f;
    _227 = log2(_227);
    _227 *= _22_m4;
    _227 = exp2(_227);
    vs_TEXCOORD2 = _227 * _22_m5;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _194 = stage_input._194;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _FoamColor;
float _FoamMix;
float _FoamWidth;
float _Depth;
float _Glow;
#define _32_m0 _FoamColor
#define _32_m1 _FoamMix
#define _32_m2 _FoamWidth
#define _32_m3 _Depth
#define _32_m4 _Glow



static bool gl_FrontFacing;
static float vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 _169;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _169 : SV_Target0;
};

static bool _8;
static float _28;
static float _42;
static float3 _65;
static float3 _85;
static float3 _112;
static float4 _128;

void frag_inner()
{
    _8 = (-vs_TEXCOORD0) < 0.0f;
    if ((int(_8) * (-1)) != 0)
    {
        discard;
    }
    _28 = _32_m2 * 0.64999997615814208984375f;
    _28 = 1.0f / _28;
    _42 = vs_TEXCOORD0 + _32_m2;
    _28 *= _42;
    _28 = clamp(_28, 0.0f, 1.0f);
    _42 = (_28 * (-2.0f)) + 3.0f;
    _28 *= _28;
    _28 *= _42;
    _65.x = (vs_TEXCOORD3 * (-_32_m3)) + 1.0f;
    _65.x = (_65.x * 0.550000011920928955078125f) + vs_TEXCOORD2;
    _85 = vs_TEXCOORD1 * float3(float3(_32_m4, _32_m4, _32_m4));
    _85 *= 0.5f.xxx;
    _65 = (vs_TEXCOORD1 * _65.xxx) + _85;
    _112 = (-vs_TEXCOORD1) + _32_m0.xyz;
    _112 = (_32_m1.xxx * _112) + vs_TEXCOORD1;
    float2 _145 = (float2(float2(_32_m4, _32_m4)) * float2(0.4000000059604644775390625f, 0.3499999940395355224609375f)) + float2(0.89999997615814208984375f, 0.75f);
    _128 = float4(_145.x, _145.y, _128.z, _128.w);
    float3 _154 = (_112 * _128.xxx) + (-_65);
    _128 = float4(_154.x, _128.y, _154.y, _154.z);
    _65 = (_28.xxx * _128.xzw) + _65;
    _112 *= _128.yyy;
    float3 _177;
    if ((gl_FrontFacing ? 4294967295u : 0u) != 0u)
    {
        _177 = _65;
    }
    else
    {
        _177 = _112;
    }
    _169 = float4(_177.x, _177.y, _177.z, _169.w);
    _169.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._169 = _169;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}