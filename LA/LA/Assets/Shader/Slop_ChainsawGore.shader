// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/ChainsawGore" {
Properties {

_MainTex ("Texture", 2D) = "white" { }

_Color ("Color", Color) = (1,1,1,1)

_Smoothness ("Smoothness", Range(0, 1)) = 0.800000011920929

_Specular ("Highlight", Range(0, 4)) = 1.2000000476837158

_Bumps ("Bumpiness", Range(0, 1)) = 0.3499999940395355

[Toggle(BAKERY_VOLUME)] _BAKERY_VOLUME ("Use Bakery Volume", Float) = 1.0

_VolumeMin ("Volume Min", Vector) = (0,0,0,1)

_VolumeInvSize ("Volume Inv Size", Vector) = (1000000.0,1000000.0,1000000.0,1)

}
SubShader {
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
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
float4 _MainTex_ST;
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
#define _22_m16 _MainTex_ST


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _92;
static float2 vs_TEXCOORD2;
static float2 _135;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _718;
static float4 _719;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _92 : NORMAL;
    float2 _135 : TEXCOORD0;
    float4 _719 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _718 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float4 _52;
static float _116;
static bool _148;
static float4 _155;
static float4 _180;
static float4 _232;
static float3 _250;
static float3 _261;
static float _267;
static float3 _271;
static float _283;
static float _331;
static float _387;
static float _437;
static float3 _489;
static float _545;
static float3 _593;
static float3 _601;
static float4 _617;
static float3 _623;
static float _642;

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
    vs_TEXCOORD2 = (_135 * _22_m16.xy) + _22_m16.zw;
    _148 = 1000000.0f < _22_m13.x;
    float3 _158;
    if (_148)
    {
        _158 = _22_m14;
    }
    else
    {
        _158 = _22_m12;
    }
    _155 = float4(_158.x, _158.y, _158.z, _155.w);
    float3 _177 = _9.xyz + (-_155.xyz);
    _155 = float4(_177.x, _177.y, _177.z, _155.w);
    float3 _182;
    if (_148)
    {
        _182 = _22_m15;
    }
    else
    {
        _182 = _22_m13;
    }
    _180 = float4(_182.x, _182.y, _182.z, _180.w);
    float3 _198 = _155.xyz * _180.xyz;
    _155 = float4(_198.x, _198.y, _198.z, _155.w);
    _180 = _Volume0.SampleLevel(sampler_Volume0, _155.xyz, 0.0f).xywz;
    _116 = _180.y + _180.x;
    _116 = _180.w + _116;
    _148 = 9.9999997473787516355514526367188e-06f < _116;
    if (_148)
    {
        _232 = _Volume1.SampleLevel(sampler_Volume0, _155.xyz, 0.0f).yxwz;
        _155 = _Volume2.SampleLevel(sampler_Volume0, _155.xyz, 0.0f).xzwy;
        _250 = max(_180.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _180.x = _232.y;
        _180.y = _155.x;
        _261 = _180.xyz * 0.5f.xxx;
        _267 = dot(_261, _261);
        _271.z = sqrt(_267);
        float3 _280 = (_180.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _180 = float4(_280.x, _280.y, _280.z, _180.w);
        _283 = dot(_180.xyz, _180.xyz);
        _283 = rsqrt(_283);
        float3 _295 = _180.xyz * _283.xxx;
        _180 = float4(_295.x, _295.y, _295.z, _180.w);
        _180.x = dot(_180.xyz, _52.xyz);
        _180.x = (_180.x * 0.5f) + 0.5f;
        _180.x = clamp(_180.x, 0.0f, 1.0f);
        _271.x = _271.z + _271.z;
        float2 _324 = _271.xz / _250.xx;
        _271 = float3(_324.x, _324.y, _271.z);
        _267 = (-_271.y) + 1.0f;
        _331 = _271.y + 1.0f;
        _331 = _267 / _331;
        _267 = (-_331) + 1.0f;
        float2 _345 = _271.xx + float2(1.0f, 2.0f);
        _261 = float3(_345.x, _345.y, _261.z);
        _271.x = _267 * _261.y;
        _180.x = log2(_180.x);
        _180.x *= _261.x;
        _180.x = exp2(_180.x);
        _180.x = (_271.x * _180.x) + _331;
        _180.x *= _250.x;
        _232.y = _155.w;
        _261 = _232.xyz * 0.5f.xxx;
        _387 = dot(_261, _261);
        _387 = sqrt(_387);
        float3 _396 = (_232.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _232 = float4(_396.x, _396.y, _396.z, _232.w);
        _267 = dot(_232.xyz, _232.xyz);
        _267 = rsqrt(_267);
        float3 _410 = _267.xxx * _232.xyz;
        _232 = float4(_410.x, _410.y, _410.z, _232.w);
        _267 = dot(_232.xyz, _52.xyz);
        _267 = (_267 * 0.5f) + 0.5f;
        _267 = clamp(_267, 0.0f, 1.0f);
        _232.x = _387 + _387;
        _232.x /= _250.y;
        _387 /= _250.y;
        _437 = (-_387) + 1.0f;
        _387 += 1.0f;
        _387 = _437 / _387;
        _437 = (-_387) + 1.0f;
        float2 _451 = _232.xx + float2(1.0f, 2.0f);
        _232 = float4(_451.x, _232.y, _451.y, _232.w);
        _437 = _232.z * _437;
        _267 = log2(_267);
        _267 *= _232.x;
        _267 = exp2(_267);
        _387 = (_437 * _267) + _387;
        _180.y = _387 * _250.y;
        _155.x = _232.w;
        float3 _481 = _155.xyz * 0.5f.xxx;
        _232 = float4(_481.x, _481.y, _481.z, _232.w);
        _387 = dot(_232.xyz, _232.xyz);
        _489.z = sqrt(_387);
        float3 _496 = (_155.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _155 = float4(_496.x, _496.y, _496.z, _155.w);
        _267 = dot(_155.xyz, _155.xyz);
        _267 = rsqrt(_267);
        float3 _510 = _155.xyz * _267.xxx;
        _155 = float4(_510.x, _510.y, _510.z, _155.w);
        _155.x = dot(_155.xyz, _52.xyz);
        _155.x = (_155.x * 0.5f) + 0.5f;
        _155.x = clamp(_155.x, 0.0f, 1.0f);
        _489.x = _489.z + _489.z;
        float2 _538 = _489.xz / _250.zz;
        _489 = float3(_538.x, _538.y, _489.z);
        _387 = (-_489.y) + 1.0f;
        _545 = _489.y + 1.0f;
        _545 = _387 / _545;
        _387 = (-_545) + 1.0f;
        float2 _557 = _489.xx + float2(1.0f, 2.0f);
        _232 = float4(_557.x, _557.y, _232.z, _232.w);
        _489.x = _387 * _232.y;
        _155.x = log2(_155.x);
        _155.x *= _232.x;
        _155.x = exp2(_155.x);
        _155.x = (_489.x * _155.x) + _545;
        _180.z = _155.x * _250.z;
        _593 = _180.xyz;
    }
    else
    {
        _593.x = 0.0f;
        _593.y = 0.0f;
        _593.z = 0.0f;
    }
    _52.w = 1.0f;
    _601.x = dot(_22_m1, _52);
    _601.y = dot(_22_m2, _52);
    _601.z = dot(_22_m3, _52);
    _617 = _52.yzzx * _52.xyzz;
    _623.x = dot(_22_m4, _617);
    _623.y = dot(_22_m5, _617);
    _623.z = dot(_22_m6, _617);
    _642 = _52.y * _52.y;
    _642 = (_52.x * _52.x) + (-_642);
    _623 = (_22_m7.xyz * _642.xxx) + _623;
    _601 += _623;
    float3 _669;
    if (_148)
    {
        _669 = _593;
    }
    else
    {
        _669 = _601;
    }
    _593 = _669;
    vs_TEXCOORD3 = max(_593, 0.0f.xxx);
    _116 = _46.z / _22_m0.y;
    _116 = (-_116) + 1.0f;
    _116 *= _22_m0.z;
    _116 = max(_116, 0.0f);
    _116 *= _22_m11.y;
    vs_TEXCOORD4 = exp2(-_116);
    gl_Position = _46;
    vs_TEXCOORD0 = _9.xyz;
    vs_TEXCOORD1 = _52.xyz;
    _718 = _719;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _135 = stage_input._135;
    _719 = stage_input._719;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._718 = _718;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float _Smoothness;
float _Specular;
float _Bumps;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_FogColor
#define _13_m3 _LightColor0
#define _13_m4 _Color
#define _13_m5 _Smoothness
#define _13_m6 _Specular
#define _13_m7 _Bumps


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _166;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _325;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _166 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _325 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float3 _42;
static bool _49;
static float3 _70;
static float _80;
static float3 _86;
static float3 _112;
static float3 _130;
static float3 _157;
static float3 _183;
static float3 _234;
static float3 _240;

void frag_inner()
{
    _9.x = (_13_m5 * 10.0f) + 1.0f;
    _9.x = exp2(_9.x);
    _31.x = dot(_13_m1.xyz, _13_m1.xyz);
    _42.x = rsqrt(_31.x);
    _49 = 9.9999999747524270787835121154785e-07f < _31.x;
    _42 = _42.xxx * _13_m1.xyz;
    float3 _62;
    if (_49)
    {
        _62 = _42;
    }
    else
    {
        _62 = float3(0.0f, 1.0f, 0.0f);
    }
    _31 = _62;
    _70 = (-vs_TEXCOORD0) + _13_m0;
    _80 = dot(_70, _70);
    _80 = rsqrt(_80);
    _86 = (_70 * _80.xxx) + _31;
    _70 = _80.xxx * _70;
    _80 = dot(_86, _86);
    _80 = rsqrt(_80);
    _86 = _80.xxx * _86;
    _80 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80 = rsqrt(_80);
    _112 = _80.xxx * vs_TEXCOORD1;
    _80 = dot(_112, _86);
    _80 = clamp(_80, 0.0f, 1.0f);
    _80 = log2(_80);
    _80 = _9.x * _80;
    _80 = exp2(_80);
    _130 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD2).xyz;
    _9.x = _130.y * 2.2000000476837158203125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _157 = _130 * _13_m4.xyz;
    _157 *= _166.xyz;
    _9.x += (-1.0f);
    _9.x = (_13_m7 * _9.x) + 1.0f;
    _183.x = _9.x * _13_m6;
    _9 = _9.xxx * _157;
    _80 *= _183.x;
    _183 = _80.xxx * _13_m3.xyz;
    _31.x = dot(_112, _31);
    _42.x = dot(_112, _70);
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _31.x = (_31.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _234 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _240 = (_13_m3.xyz * _31.xxx) + _234;
    _183 = (_9 * _240) + _183;
    _9 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _31.x = _42.x * _42.x;
    _31.x *= _31.x;
    _31.x *= _42.x;
    _31.x = (_31.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _234 = _31.xxx * _234;
    _234 *= _13_m5.xxx;
    _234 *= 0.300000011920928955078125f.xxx;
    _9 = (_234 * _9) + _183;
    _31 = _9 + (-_13_m2.xyz);
    _80 = vs_TEXCOORD4;
    _80 = clamp(_80, 0.0f, 1.0f);
    _31 = (_80.xxx * _31) + _13_m2.xyz;
    _325 = float4(_31.x, _31.y, _31.z, _325.w);
    _325.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _166 = stage_input._166;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._325 = _325;
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
float4 _MainTex_ST;
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
#define _22_m16 _MainTex_ST


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _92;
static float2 vs_TEXCOORD2;
static float2 _135;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _721;
static float4 _722;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _92 : NORMAL;
    float2 _135 : TEXCOORD0;
    float4 _722 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _721 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float4 _52;
static float _116;
static bool _148;
static float4 _155;
static float4 _180;
static float4 _232;
static float3 _250;
static float3 _261;
static float _267;
static float3 _271;
static float _283;
static float _331;
static float _387;
static float _437;
static float3 _489;
static float _545;
static float3 _593;
static float3 _601;
static float4 _617;
static float3 _623;
static float _642;

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
    vs_TEXCOORD2 = (_135 * _22_m16.xy) + _22_m16.zw;
    _148 = 1000000.0f < _22_m13.x;
    float3 _158;
    if (_148)
    {
        _158 = _22_m14;
    }
    else
    {
        _158 = _22_m12;
    }
    _155 = float4(_158.x, _158.y, _158.z, _155.w);
    float3 _177 = _9.xyz + (-_155.xyz);
    _155 = float4(_177.x, _177.y, _177.z, _155.w);
    float3 _182;
    if (_148)
    {
        _182 = _22_m15;
    }
    else
    {
        _182 = _22_m13;
    }
    _180 = float4(_182.x, _182.y, _182.z, _180.w);
    float3 _198 = _155.xyz * _180.xyz;
    _155 = float4(_198.x, _198.y, _198.z, _155.w);
    _180 = _Volume0.SampleLevel(sampler_Volume0, _155.xyz, 0.0f).xywz;
    _116 = _180.y + _180.x;
    _116 = _180.w + _116;
    _148 = 9.9999997473787516355514526367188e-06f < _116;
    if (_148)
    {
        _232 = _Volume1.SampleLevel(sampler_Volume0, _155.xyz, 0.0f).yxwz;
        _155 = _Volume2.SampleLevel(sampler_Volume0, _155.xyz, 0.0f).xzwy;
        _250 = max(_180.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _180.x = _232.y;
        _180.y = _155.x;
        _261 = _180.xyz * 0.5f.xxx;
        _267 = dot(_261, _261);
        _271.z = sqrt(_267);
        float3 _280 = (_180.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _180 = float4(_280.x, _280.y, _280.z, _180.w);
        _283 = dot(_180.xyz, _180.xyz);
        _283 = rsqrt(_283);
        float3 _295 = _180.xyz * _283.xxx;
        _180 = float4(_295.x, _295.y, _295.z, _180.w);
        _180.x = dot(_180.xyz, _52.xyz);
        _180.x = (_180.x * 0.5f) + 0.5f;
        _180.x = clamp(_180.x, 0.0f, 1.0f);
        _271.x = _271.z + _271.z;
        float2 _324 = _271.xz / _250.xx;
        _271 = float3(_324.x, _324.y, _271.z);
        _267 = (-_271.y) + 1.0f;
        _331 = _271.y + 1.0f;
        _331 = _267 / _331;
        _267 = (-_331) + 1.0f;
        float2 _345 = _271.xx + float2(1.0f, 2.0f);
        _261 = float3(_345.x, _345.y, _261.z);
        _271.x = _267 * _261.y;
        _180.x = log2(_180.x);
        _180.x *= _261.x;
        _180.x = exp2(_180.x);
        _180.x = (_271.x * _180.x) + _331;
        _180.x *= _250.x;
        _232.y = _155.w;
        _261 = _232.xyz * 0.5f.xxx;
        _387 = dot(_261, _261);
        _387 = sqrt(_387);
        float3 _396 = (_232.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _232 = float4(_396.x, _396.y, _396.z, _232.w);
        _267 = dot(_232.xyz, _232.xyz);
        _267 = rsqrt(_267);
        float3 _410 = _267.xxx * _232.xyz;
        _232 = float4(_410.x, _410.y, _410.z, _232.w);
        _267 = dot(_232.xyz, _52.xyz);
        _267 = (_267 * 0.5f) + 0.5f;
        _267 = clamp(_267, 0.0f, 1.0f);
        _232.x = _387 + _387;
        _232.x /= _250.y;
        _387 /= _250.y;
        _437 = (-_387) + 1.0f;
        _387 += 1.0f;
        _387 = _437 / _387;
        _437 = (-_387) + 1.0f;
        float2 _451 = _232.xx + float2(1.0f, 2.0f);
        _232 = float4(_451.x, _232.y, _451.y, _232.w);
        _437 = _232.z * _437;
        _267 = log2(_267);
        _267 *= _232.x;
        _267 = exp2(_267);
        _387 = (_437 * _267) + _387;
        _180.y = _387 * _250.y;
        _155.x = _232.w;
        float3 _481 = _155.xyz * 0.5f.xxx;
        _232 = float4(_481.x, _481.y, _481.z, _232.w);
        _387 = dot(_232.xyz, _232.xyz);
        _489.z = sqrt(_387);
        float3 _496 = (_155.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _155 = float4(_496.x, _496.y, _496.z, _155.w);
        _267 = dot(_155.xyz, _155.xyz);
        _267 = rsqrt(_267);
        float3 _510 = _155.xyz * _267.xxx;
        _155 = float4(_510.x, _510.y, _510.z, _155.w);
        _155.x = dot(_155.xyz, _52.xyz);
        _155.x = (_155.x * 0.5f) + 0.5f;
        _155.x = clamp(_155.x, 0.0f, 1.0f);
        _489.x = _489.z + _489.z;
        float2 _538 = _489.xz / _250.zz;
        _489 = float3(_538.x, _538.y, _489.z);
        _387 = (-_489.y) + 1.0f;
        _545 = _489.y + 1.0f;
        _545 = _387 / _545;
        _387 = (-_545) + 1.0f;
        float2 _557 = _489.xx + float2(1.0f, 2.0f);
        _232 = float4(_557.x, _557.y, _232.z, _232.w);
        _489.x = _387 * _232.y;
        _155.x = log2(_155.x);
        _155.x *= _232.x;
        _155.x = exp2(_155.x);
        _155.x = (_489.x * _155.x) + _545;
        _180.z = _155.x * _250.z;
        _593 = _180.xyz;
    }
    else
    {
        _593.x = 0.0f;
        _593.y = 0.0f;
        _593.z = 0.0f;
    }
    _52.w = 1.0f;
    _601.x = dot(_22_m1, _52);
    _601.y = dot(_22_m2, _52);
    _601.z = dot(_22_m3, _52);
    _617 = _52.yzzx * _52.xyzz;
    _623.x = dot(_22_m4, _617);
    _623.y = dot(_22_m5, _617);
    _623.z = dot(_22_m6, _617);
    _642 = _52.y * _52.y;
    _642 = (_52.x * _52.x) + (-_642);
    _623 = (_22_m7.xyz * _642.xxx) + _623;
    _601 += _623;
    float3 _669;
    if (_148)
    {
        _669 = _593;
    }
    else
    {
        _669 = _601;
    }
    _593 = _669;
    vs_TEXCOORD3 = max(_593, 0.0f.xxx);
    _116 = _46.z / _22_m0.y;
    _116 = (-_116) + 1.0f;
    _116 *= _22_m0.z;
    _116 = max(_116, 0.0f);
    _116 *= _22_m11.x;
    _116 *= (-_116);
    vs_TEXCOORD4 = exp2(_116);
    gl_Position = _46;
    vs_TEXCOORD0 = _9.xyz;
    vs_TEXCOORD1 = _52.xyz;
    _721 = _722;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _135 = stage_input._135;
    _722 = stage_input._722;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._721 = _721;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float _Smoothness;
float _Specular;
float _Bumps;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_FogColor
#define _13_m3 _LightColor0
#define _13_m4 _Color
#define _13_m5 _Smoothness
#define _13_m6 _Specular
#define _13_m7 _Bumps


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _166;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _325;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _166 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _325 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float3 _42;
static bool _49;
static float3 _70;
static float _80;
static float3 _86;
static float3 _112;
static float3 _130;
static float3 _157;
static float3 _183;
static float3 _234;
static float3 _240;

void frag_inner()
{
    _9.x = (_13_m5 * 10.0f) + 1.0f;
    _9.x = exp2(_9.x);
    _31.x = dot(_13_m1.xyz, _13_m1.xyz);
    _42.x = rsqrt(_31.x);
    _49 = 9.9999999747524270787835121154785e-07f < _31.x;
    _42 = _42.xxx * _13_m1.xyz;
    float3 _62;
    if (_49)
    {
        _62 = _42;
    }
    else
    {
        _62 = float3(0.0f, 1.0f, 0.0f);
    }
    _31 = _62;
    _70 = (-vs_TEXCOORD0) + _13_m0;
    _80 = dot(_70, _70);
    _80 = rsqrt(_80);
    _86 = (_70 * _80.xxx) + _31;
    _70 = _80.xxx * _70;
    _80 = dot(_86, _86);
    _80 = rsqrt(_80);
    _86 = _80.xxx * _86;
    _80 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80 = rsqrt(_80);
    _112 = _80.xxx * vs_TEXCOORD1;
    _80 = dot(_112, _86);
    _80 = clamp(_80, 0.0f, 1.0f);
    _80 = log2(_80);
    _80 = _9.x * _80;
    _80 = exp2(_80);
    _130 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD2).xyz;
    _9.x = _130.y * 2.2000000476837158203125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _157 = _130 * _13_m4.xyz;
    _157 *= _166.xyz;
    _9.x += (-1.0f);
    _9.x = (_13_m7 * _9.x) + 1.0f;
    _183.x = _9.x * _13_m6;
    _9 = _9.xxx * _157;
    _80 *= _183.x;
    _183 = _80.xxx * _13_m3.xyz;
    _31.x = dot(_112, _31);
    _42.x = dot(_112, _70);
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _31.x = (_31.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _234 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _240 = (_13_m3.xyz * _31.xxx) + _234;
    _183 = (_9 * _240) + _183;
    _9 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _31.x = _42.x * _42.x;
    _31.x *= _31.x;
    _31.x *= _42.x;
    _31.x = (_31.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _234 = _31.xxx * _234;
    _234 *= _13_m5.xxx;
    _234 *= 0.300000011920928955078125f.xxx;
    _9 = (_234 * _9) + _183;
    _31 = _9 + (-_13_m2.xyz);
    _80 = vs_TEXCOORD4;
    _80 = clamp(_80, 0.0f, 1.0f);
    _31 = (_80.xxx * _31) + _13_m2.xyz;
    _325 = float4(_31.x, _31.y, _31.z, _325.w);
    _325.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _166 = stage_input._166;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._325 = _325;
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
float4 _MainTex_ST;
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
#define _22_m16 _MainTex_ST


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _92;
static float2 vs_TEXCOORD2;
static float2 _135;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _718;
static float4 _719;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _92 : NORMAL;
    float2 _135 : TEXCOORD0;
    float4 _719 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _718 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float4 _52;
static float _116;
static bool _148;
static float4 _155;
static float4 _180;
static float4 _232;
static float3 _250;
static float3 _261;
static float _267;
static float3 _271;
static float _283;
static float _331;
static float _387;
static float _437;
static float3 _489;
static float _545;
static float3 _593;
static float3 _601;
static float4 _617;
static float3 _623;
static float _642;

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
    vs_TEXCOORD2 = (_135 * _22_m16.xy) + _22_m16.zw;
    _148 = 1000000.0f < _22_m13.x;
    float3 _158;
    if (_148)
    {
        _158 = _22_m14;
    }
    else
    {
        _158 = _22_m12;
    }
    _155 = float4(_158.x, _158.y, _158.z, _155.w);
    float3 _177 = _9.xyz + (-_155.xyz);
    _155 = float4(_177.x, _177.y, _177.z, _155.w);
    float3 _182;
    if (_148)
    {
        _182 = _22_m15;
    }
    else
    {
        _182 = _22_m13;
    }
    _180 = float4(_182.x, _182.y, _182.z, _180.w);
    float3 _198 = _155.xyz * _180.xyz;
    _155 = float4(_198.x, _198.y, _198.z, _155.w);
    _180 = _Volume0.SampleLevel(sampler_Volume0, _155.xyz, 0.0f).xywz;
    _116 = _180.y + _180.x;
    _116 = _180.w + _116;
    _148 = 9.9999997473787516355514526367188e-06f < _116;
    if (_148)
    {
        _232 = _Volume1.SampleLevel(sampler_Volume0, _155.xyz, 0.0f).yxwz;
        _155 = _Volume2.SampleLevel(sampler_Volume0, _155.xyz, 0.0f).xzwy;
        _250 = max(_180.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _180.x = _232.y;
        _180.y = _155.x;
        _261 = _180.xyz * 0.5f.xxx;
        _267 = dot(_261, _261);
        _271.z = sqrt(_267);
        float3 _280 = (_180.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _180 = float4(_280.x, _280.y, _280.z, _180.w);
        _283 = dot(_180.xyz, _180.xyz);
        _283 = rsqrt(_283);
        float3 _295 = _180.xyz * _283.xxx;
        _180 = float4(_295.x, _295.y, _295.z, _180.w);
        _180.x = dot(_180.xyz, _52.xyz);
        _180.x = (_180.x * 0.5f) + 0.5f;
        _180.x = clamp(_180.x, 0.0f, 1.0f);
        _271.x = _271.z + _271.z;
        float2 _324 = _271.xz / _250.xx;
        _271 = float3(_324.x, _324.y, _271.z);
        _267 = (-_271.y) + 1.0f;
        _331 = _271.y + 1.0f;
        _331 = _267 / _331;
        _267 = (-_331) + 1.0f;
        float2 _345 = _271.xx + float2(1.0f, 2.0f);
        _261 = float3(_345.x, _345.y, _261.z);
        _271.x = _267 * _261.y;
        _180.x = log2(_180.x);
        _180.x *= _261.x;
        _180.x = exp2(_180.x);
        _180.x = (_271.x * _180.x) + _331;
        _180.x *= _250.x;
        _232.y = _155.w;
        _261 = _232.xyz * 0.5f.xxx;
        _387 = dot(_261, _261);
        _387 = sqrt(_387);
        float3 _396 = (_232.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _232 = float4(_396.x, _396.y, _396.z, _232.w);
        _267 = dot(_232.xyz, _232.xyz);
        _267 = rsqrt(_267);
        float3 _410 = _267.xxx * _232.xyz;
        _232 = float4(_410.x, _410.y, _410.z, _232.w);
        _267 = dot(_232.xyz, _52.xyz);
        _267 = (_267 * 0.5f) + 0.5f;
        _267 = clamp(_267, 0.0f, 1.0f);
        _232.x = _387 + _387;
        _232.x /= _250.y;
        _387 /= _250.y;
        _437 = (-_387) + 1.0f;
        _387 += 1.0f;
        _387 = _437 / _387;
        _437 = (-_387) + 1.0f;
        float2 _451 = _232.xx + float2(1.0f, 2.0f);
        _232 = float4(_451.x, _232.y, _451.y, _232.w);
        _437 = _232.z * _437;
        _267 = log2(_267);
        _267 *= _232.x;
        _267 = exp2(_267);
        _387 = (_437 * _267) + _387;
        _180.y = _387 * _250.y;
        _155.x = _232.w;
        float3 _481 = _155.xyz * 0.5f.xxx;
        _232 = float4(_481.x, _481.y, _481.z, _232.w);
        _387 = dot(_232.xyz, _232.xyz);
        _489.z = sqrt(_387);
        float3 _496 = (_155.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _155 = float4(_496.x, _496.y, _496.z, _155.w);
        _267 = dot(_155.xyz, _155.xyz);
        _267 = rsqrt(_267);
        float3 _510 = _155.xyz * _267.xxx;
        _155 = float4(_510.x, _510.y, _510.z, _155.w);
        _155.x = dot(_155.xyz, _52.xyz);
        _155.x = (_155.x * 0.5f) + 0.5f;
        _155.x = clamp(_155.x, 0.0f, 1.0f);
        _489.x = _489.z + _489.z;
        float2 _538 = _489.xz / _250.zz;
        _489 = float3(_538.x, _538.y, _489.z);
        _387 = (-_489.y) + 1.0f;
        _545 = _489.y + 1.0f;
        _545 = _387 / _545;
        _387 = (-_545) + 1.0f;
        float2 _557 = _489.xx + float2(1.0f, 2.0f);
        _232 = float4(_557.x, _557.y, _232.z, _232.w);
        _489.x = _387 * _232.y;
        _155.x = log2(_155.x);
        _155.x *= _232.x;
        _155.x = exp2(_155.x);
        _155.x = (_489.x * _155.x) + _545;
        _180.z = _155.x * _250.z;
        _593 = _180.xyz;
    }
    else
    {
        _593.x = 0.0f;
        _593.y = 0.0f;
        _593.z = 0.0f;
    }
    _52.w = 1.0f;
    _601.x = dot(_22_m1, _52);
    _601.y = dot(_22_m2, _52);
    _601.z = dot(_22_m3, _52);
    _617 = _52.yzzx * _52.xyzz;
    _623.x = dot(_22_m4, _617);
    _623.y = dot(_22_m5, _617);
    _623.z = dot(_22_m6, _617);
    _642 = _52.y * _52.y;
    _642 = (_52.x * _52.x) + (-_642);
    _623 = (_22_m7.xyz * _642.xxx) + _623;
    _601 += _623;
    float3 _669;
    if (_148)
    {
        _669 = _593;
    }
    else
    {
        _669 = _601;
    }
    _593 = _669;
    vs_TEXCOORD3 = max(_593, 0.0f.xxx);
    _116 = _46.z / _22_m0.y;
    _116 = (-_116) + 1.0f;
    _116 *= _22_m0.z;
    _116 = max(_116, 0.0f);
    vs_TEXCOORD4 = (_116 * _22_m11.z) + _22_m11.w;
    gl_Position = _46;
    vs_TEXCOORD0 = _9.xyz;
    vs_TEXCOORD1 = _52.xyz;
    _718 = _719;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _135 = stage_input._135;
    _719 = stage_input._719;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._718 = _718;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float _Smoothness;
float _Specular;
float _Bumps;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_FogColor
#define _13_m3 _LightColor0
#define _13_m4 _Color
#define _13_m5 _Smoothness
#define _13_m6 _Specular
#define _13_m7 _Bumps


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _166;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _325;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _166 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _325 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float3 _42;
static bool _49;
static float3 _70;
static float _80;
static float3 _86;
static float3 _112;
static float3 _130;
static float3 _157;
static float3 _183;
static float3 _234;
static float3 _240;

void frag_inner()
{
    _9.x = (_13_m5 * 10.0f) + 1.0f;
    _9.x = exp2(_9.x);
    _31.x = dot(_13_m1.xyz, _13_m1.xyz);
    _42.x = rsqrt(_31.x);
    _49 = 9.9999999747524270787835121154785e-07f < _31.x;
    _42 = _42.xxx * _13_m1.xyz;
    float3 _62;
    if (_49)
    {
        _62 = _42;
    }
    else
    {
        _62 = float3(0.0f, 1.0f, 0.0f);
    }
    _31 = _62;
    _70 = (-vs_TEXCOORD0) + _13_m0;
    _80 = dot(_70, _70);
    _80 = rsqrt(_80);
    _86 = (_70 * _80.xxx) + _31;
    _70 = _80.xxx * _70;
    _80 = dot(_86, _86);
    _80 = rsqrt(_80);
    _86 = _80.xxx * _86;
    _80 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80 = rsqrt(_80);
    _112 = _80.xxx * vs_TEXCOORD1;
    _80 = dot(_112, _86);
    _80 = clamp(_80, 0.0f, 1.0f);
    _80 = log2(_80);
    _80 = _9.x * _80;
    _80 = exp2(_80);
    _130 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD2).xyz;
    _9.x = _130.y * 2.2000000476837158203125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _157 = _130 * _13_m4.xyz;
    _157 *= _166.xyz;
    _9.x += (-1.0f);
    _9.x = (_13_m7 * _9.x) + 1.0f;
    _183.x = _9.x * _13_m6;
    _9 = _9.xxx * _157;
    _80 *= _183.x;
    _183 = _80.xxx * _13_m3.xyz;
    _31.x = dot(_112, _31);
    _42.x = dot(_112, _70);
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _31.x = (_31.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _234 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _240 = (_13_m3.xyz * _31.xxx) + _234;
    _183 = (_9 * _240) + _183;
    _9 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _31.x = _42.x * _42.x;
    _31.x *= _31.x;
    _31.x *= _42.x;
    _31.x = (_31.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _234 = _31.xxx * _234;
    _234 *= _13_m5.xxx;
    _234 *= 0.300000011920928955078125f.xxx;
    _9 = (_234 * _9) + _183;
    _31 = _9 + (-_13_m2.xyz);
    _80 = vs_TEXCOORD4;
    _80 = clamp(_80, 0.0f, 1.0f);
    _31 = (_80.xxx * _31) + _13_m2.xyz;
    _325 = float4(_31.x, _31.y, _31.z, _325.w);
    _325.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _166 = stage_input._166;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._325 = _325;
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
float4 _MainTex_ST;
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
#define _22_m14 _MainTex_ST


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _99;
static float2 vs_TEXCOORD2;
static float2 _141;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _691;
static float4 _692;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _99 : NORMAL;
    float2 _141 : TEXCOORD0;
    float4 _692 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _691 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float4 _52;
static float _122;
static bool _154;
static float4 _185;
static float4 _237;
static float3 _255;
static float3 _266;
static float _272;
static float3 _276;
static float _288;
static float _336;
static float _392;
static float _442;
static float3 _494;
static float _550;
static float3 _598;
static float3 _606;
static float4 _622;
static float3 _628;
static float _646;

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
    vs_TEXCOORD2 = (_141 * _22_m14.xy) + _22_m14.zw;
    _154 = 1000000.0f < _22_m11.x;
    float3 _163;
    if (_154)
    {
        _163 = _22_m12;
    }
    else
    {
        _163 = _22_m10;
    }
    _52 = float4(_163.x, _163.y, _163.z, _52.w);
    float3 _182 = _9.xyz + (-_52.xyz);
    _52 = float4(_182.x, _182.y, _182.z, _52.w);
    float3 _187;
    if (_154)
    {
        _187 = _22_m13;
    }
    else
    {
        _187 = _22_m11;
    }
    _185 = float4(_187.x, _187.y, _187.z, _185.w);
    float3 _203 = _52.xyz * _185.xyz;
    _52 = float4(_203.x, _203.y, _203.z, _52.w);
    _185 = _Volume0.SampleLevel(sampler_Volume0, _52.xyz, 0.0f).xywz;
    _122 = _185.y + _185.x;
    _122 = _185.w + _122;
    _154 = 9.9999997473787516355514526367188e-06f < _122;
    if (_154)
    {
        _237 = _Volume1.SampleLevel(sampler_Volume0, _52.xyz, 0.0f).yxwz;
        _52 = _Volume2.SampleLevel(sampler_Volume0, _52.xyz, 0.0f).xzwy;
        _255 = max(_185.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _185.x = _237.y;
        _185.y = _52.x;
        _266 = _185.xyz * 0.5f.xxx;
        _272 = dot(_266, _266);
        _276.z = sqrt(_272);
        float3 _285 = (_185.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _185 = float4(_285.x, _285.y, _285.z, _185.w);
        _288 = dot(_185.xyz, _185.xyz);
        _288 = rsqrt(_288);
        float3 _300 = _185.xyz * _288.xxx;
        _185 = float4(_300.x, _300.y, _300.z, _185.w);
        _185.x = dot(_185.xyz, _46.xyz);
        _185.x = (_185.x * 0.5f) + 0.5f;
        _185.x = clamp(_185.x, 0.0f, 1.0f);
        _276.x = _276.z + _276.z;
        float2 _329 = _276.xz / _255.xx;
        _276 = float3(_329.x, _329.y, _276.z);
        _272 = (-_276.y) + 1.0f;
        _336 = _276.y + 1.0f;
        _336 = _272 / _336;
        _272 = (-_336) + 1.0f;
        float2 _350 = _276.xx + float2(1.0f, 2.0f);
        _266 = float3(_350.x, _350.y, _266.z);
        _276.x = _272 * _266.y;
        _185.x = log2(_185.x);
        _185.x *= _266.x;
        _185.x = exp2(_185.x);
        _185.x = (_276.x * _185.x) + _336;
        _185.x *= _255.x;
        _237.y = _52.w;
        _266 = _237.xyz * 0.5f.xxx;
        _392 = dot(_266, _266);
        _392 = sqrt(_392);
        float3 _401 = (_237.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _237 = float4(_401.x, _401.y, _401.z, _237.w);
        _272 = dot(_237.xyz, _237.xyz);
        _272 = rsqrt(_272);
        float3 _415 = _272.xxx * _237.xyz;
        _237 = float4(_415.x, _415.y, _415.z, _237.w);
        _272 = dot(_237.xyz, _46.xyz);
        _272 = (_272 * 0.5f) + 0.5f;
        _272 = clamp(_272, 0.0f, 1.0f);
        _237.x = _392 + _392;
        _237.x /= _255.y;
        _392 /= _255.y;
        _442 = (-_392) + 1.0f;
        _392 += 1.0f;
        _392 = _442 / _392;
        _442 = (-_392) + 1.0f;
        float2 _456 = _237.xx + float2(1.0f, 2.0f);
        _237 = float4(_456.x, _237.y, _456.y, _237.w);
        _442 = _237.z * _442;
        _272 = log2(_272);
        _272 *= _237.x;
        _272 = exp2(_272);
        _392 = (_442 * _272) + _392;
        _185.y = _392 * _255.y;
        _52.x = _237.w;
        float3 _486 = _52.xyz * 0.5f.xxx;
        _237 = float4(_486.x, _486.y, _486.z, _237.w);
        _392 = dot(_237.xyz, _237.xyz);
        _494.z = sqrt(_392);
        float3 _501 = (_52.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _52 = float4(_501.x, _501.y, _501.z, _52.w);
        _272 = dot(_52.xyz, _52.xyz);
        _272 = rsqrt(_272);
        float3 _515 = _52.xyz * _272.xxx;
        _52 = float4(_515.x, _515.y, _515.z, _52.w);
        _52.x = dot(_52.xyz, _46.xyz);
        _52.x = (_52.x * 0.5f) + 0.5f;
        _52.x = clamp(_52.x, 0.0f, 1.0f);
        _494.x = _494.z + _494.z;
        float2 _543 = _494.xz / _255.zz;
        _494 = float3(_543.x, _543.y, _494.z);
        _392 = (-_494.y) + 1.0f;
        _550 = _494.y + 1.0f;
        _550 = _392 / _550;
        _392 = (-_550) + 1.0f;
        float2 _562 = _494.xx + float2(1.0f, 2.0f);
        _237 = float4(_562.x, _562.y, _237.z, _237.w);
        _494.x = _392 * _237.y;
        _52.x = log2(_52.x);
        _52.x *= _237.x;
        _52.x = exp2(_52.x);
        _52.x = (_494.x * _52.x) + _550;
        _185.z = _52.x * _255.z;
        _598 = _185.xyz;
    }
    else
    {
        _598.x = 0.0f;
        _598.y = 0.0f;
        _598.z = 0.0f;
    }
    _46.w = 1.0f;
    _606.x = dot(_22_m0, _46);
    _606.y = dot(_22_m1, _46);
    _606.z = dot(_22_m2, _46);
    _622 = _46.yzzx * _46.xyzz;
    _628.x = dot(_22_m3, _622);
    _628.y = dot(_22_m4, _622);
    _628.z = dot(_22_m5, _622);
    _646 = _46.y * _46.y;
    _646 = (_46.x * _46.x) + (-_646);
    _628 = (_22_m6.xyz * _646.xxx) + _628;
    _606 += _628;
    float3 _673;
    if (_154)
    {
        _673 = _598;
    }
    else
    {
        _673 = _606;
    }
    _598 = _673;
    vs_TEXCOORD3 = max(_598, 0.0f.xxx);
    vs_TEXCOORD0 = _9.xyz;
    vs_TEXCOORD1 = _46.xyz;
    _691 = _692;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _141 = stage_input._141;
    _692 = stage_input._692;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._691 = _691;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _Smoothness;
float _Specular;
float _Bumps;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 _LightColor0
#define _13_m3 _Color
#define _13_m4 _Smoothness
#define _13_m5 _Specular
#define _13_m6 _Bumps


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _166;
static float3 vs_TEXCOORD3;
static float4 _300;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _166 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _300 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float3 _42;
static bool _49;
static float3 _70;
static float _80;
static float3 _86;
static float3 _112;
static float3 _130;
static float3 _157;
static float3 _183;
static float3 _234;
static float3 _240;

void frag_inner()
{
    _9.x = (_13_m4 * 10.0f) + 1.0f;
    _9.x = exp2(_9.x);
    _31.x = dot(_13_m1.xyz, _13_m1.xyz);
    _42.x = rsqrt(_31.x);
    _49 = 9.9999999747524270787835121154785e-07f < _31.x;
    _42 = _42.xxx * _13_m1.xyz;
    float3 _62;
    if (_49)
    {
        _62 = _42;
    }
    else
    {
        _62 = float3(0.0f, 1.0f, 0.0f);
    }
    _31 = _62;
    _70 = (-vs_TEXCOORD0) + _13_m0;
    _80 = dot(_70, _70);
    _80 = rsqrt(_80);
    _86 = (_70 * _80.xxx) + _31;
    _70 = _80.xxx * _70;
    _80 = dot(_86, _86);
    _80 = rsqrt(_80);
    _86 = _80.xxx * _86;
    _80 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80 = rsqrt(_80);
    _112 = _80.xxx * vs_TEXCOORD1;
    _80 = dot(_112, _86);
    _80 = clamp(_80, 0.0f, 1.0f);
    _80 = log2(_80);
    _80 = _9.x * _80;
    _80 = exp2(_80);
    _130 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD2).xyz;
    _9.x = _130.y * 2.2000000476837158203125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _157 = _130 * _13_m3.xyz;
    _157 *= _166.xyz;
    _9.x += (-1.0f);
    _9.x = (_13_m6 * _9.x) + 1.0f;
    _183.x = _9.x * _13_m5;
    _9 = _9.xxx * _157;
    _80 *= _183.x;
    _183 = _80.xxx * _13_m2.xyz;
    _31.x = dot(_112, _31);
    _42.x = dot(_112, _70);
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _31.x = (_31.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _234 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _240 = (_13_m2.xyz * _31.xxx) + _234;
    _183 = (_9 * _240) + _183;
    _9 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _31.x = _42.x * _42.x;
    _31.x *= _31.x;
    _31.x *= _42.x;
    _31.x = (_31.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _234 = _31.xxx * _234;
    _234 *= _13_m4.xxx;
    _234 *= 0.300000011920928955078125f.xxx;
    float3 _305 = (_234 * _9) + _183;
    _300 = float4(_305.x, _305.y, _305.z, _300.w);
    _300.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _166 = stage_input._166;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._300 = _300;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD4;
static float3 _139;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float2 _181;
static float3 vs_TEXCOORD3;
static float4 _268;
static float4 _269;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _139 : NORMAL;
    float2 _181 : TEXCOORD0;
    float4 _269 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _268 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _159;
static float3 _193;
static float4 _210;
static float3 _216;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD0 = (_21_m8[3].xyz * _11.www) + _9.xyz;
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
    vs_TEXCOORD4 = exp2(-_9.x);
    _9.x = dot(_139, _21_m9[0].xyz);
    _9.y = dot(_139, _21_m9[1].xyz);
    _9.z = dot(_139, _21_m9[2].xyz);
    _159 = dot(_9.xyz, _9.xyz);
    _159 = rsqrt(_159);
    float3 _171 = _159.xxx * _9.xyz;
    _9 = float4(_171.x, _171.y, _171.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD2 = (_181 * _21_m12.xy) + _21_m12.zw;
    _193.x = _9.y * _9.y;
    _193.x = (_9.x * _9.x) + (-_193.x);
    _210 = _9.yzzx * _9.xyzz;
    _216.x = dot(_21_m4, _210);
    _216.y = dot(_21_m5, _210);
    _216.z = dot(_21_m6, _210);
    _193 = (_21_m7.xyz * _193.xxx) + _216;
    _9.w = 1.0f;
    _216.x = dot(_21_m1, _9);
    _216.y = dot(_21_m2, _9);
    _216.z = dot(_21_m3, _9);
    _193 += _216;
    vs_TEXCOORD3 = max(_193, 0.0f.xxx);
    _268 = _269;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _181 = stage_input._181;
    _269 = stage_input._269;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._268 = _268;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float _Smoothness;
float _Specular;
float _Bumps;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_FogColor
#define _13_m3 _LightColor0
#define _13_m4 _Color
#define _13_m5 _Smoothness
#define _13_m6 _Specular
#define _13_m7 _Bumps


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _161;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _320;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _161 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _320 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float3 _42;
static bool _49;
static float3 _70;
static float _80;
static float3 _86;
static float3 _112;
static float3 _130;
static float3 _152;
static float3 _178;
static float3 _229;
static float3 _235;

void frag_inner()
{
    _9.x = (_13_m5 * 10.0f) + 1.0f;
    _9.x = exp2(_9.x);
    _31.x = dot(_13_m1.xyz, _13_m1.xyz);
    _42.x = rsqrt(_31.x);
    _49 = 9.9999999747524270787835121154785e-07f < _31.x;
    _42 = _42.xxx * _13_m1.xyz;
    float3 _62;
    if (_49)
    {
        _62 = _42;
    }
    else
    {
        _62 = float3(0.0f, 1.0f, 0.0f);
    }
    _31 = _62;
    _70 = (-vs_TEXCOORD0) + _13_m0;
    _80 = dot(_70, _70);
    _80 = rsqrt(_80);
    _86 = (_70 * _80.xxx) + _31;
    _70 = _80.xxx * _70;
    _80 = dot(_86, _86);
    _80 = rsqrt(_80);
    _86 = _80.xxx * _86;
    _80 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80 = rsqrt(_80);
    _112 = _80.xxx * vs_TEXCOORD1;
    _80 = dot(_112, _86);
    _80 = clamp(_80, 0.0f, 1.0f);
    _80 = log2(_80);
    _80 = _9.x * _80;
    _80 = exp2(_80);
    _130 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD2).xyz;
    _9.x = _130.y * 2.2000000476837158203125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _152 = _130 * _13_m4.xyz;
    _152 *= _161.xyz;
    _9.x += (-1.0f);
    _9.x = (_13_m7 * _9.x) + 1.0f;
    _178.x = _9.x * _13_m6;
    _9 = _9.xxx * _152;
    _80 *= _178.x;
    _178 = _80.xxx * _13_m3.xyz;
    _31.x = dot(_112, _31);
    _42.x = dot(_112, _70);
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _31.x = (_31.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _229 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _235 = (_13_m3.xyz * _31.xxx) + _229;
    _178 = (_9 * _235) + _178;
    _9 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _31.x = _42.x * _42.x;
    _31.x *= _31.x;
    _31.x *= _42.x;
    _31.x = (_31.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _229 = _31.xxx * _229;
    _229 *= _13_m5.xxx;
    _229 *= 0.300000011920928955078125f.xxx;
    _9 = (_229 * _9) + _178;
    _31 = _9 + (-_13_m2.xyz);
    _80 = vs_TEXCOORD4;
    _80 = clamp(_80, 0.0f, 1.0f);
    _31 = (_80.xxx * _31) + _13_m2.xyz;
    _320 = float4(_31.x, _31.y, _31.z, _320.w);
    _320.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _161 = stage_input._161;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._320 = _320;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD4;
static float3 _145;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float2 _187;
static float3 vs_TEXCOORD3;
static float4 _274;
static float4 _275;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _145 : NORMAL;
    float2 _187 : TEXCOORD0;
    float4 _275 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _274 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _165;
static float3 _199;
static float4 _216;
static float3 _222;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD0 = (_21_m8[3].xyz * _11.www) + _9.xyz;
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
    vs_TEXCOORD4 = exp2(_9.x);
    _9.x = dot(_145, _21_m9[0].xyz);
    _9.y = dot(_145, _21_m9[1].xyz);
    _9.z = dot(_145, _21_m9[2].xyz);
    _165 = dot(_9.xyz, _9.xyz);
    _165 = rsqrt(_165);
    float3 _177 = _165.xxx * _9.xyz;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD2 = (_187 * _21_m12.xy) + _21_m12.zw;
    _199.x = _9.y * _9.y;
    _199.x = (_9.x * _9.x) + (-_199.x);
    _216 = _9.yzzx * _9.xyzz;
    _222.x = dot(_21_m4, _216);
    _222.y = dot(_21_m5, _216);
    _222.z = dot(_21_m6, _216);
    _199 = (_21_m7.xyz * _199.xxx) + _222;
    _9.w = 1.0f;
    _222.x = dot(_21_m1, _9);
    _222.y = dot(_21_m2, _9);
    _222.z = dot(_21_m3, _9);
    _199 += _222;
    vs_TEXCOORD3 = max(_199, 0.0f.xxx);
    _274 = _275;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    _187 = stage_input._187;
    _275 = stage_input._275;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._274 = _274;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float _Smoothness;
float _Specular;
float _Bumps;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_FogColor
#define _13_m3 _LightColor0
#define _13_m4 _Color
#define _13_m5 _Smoothness
#define _13_m6 _Specular
#define _13_m7 _Bumps


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _161;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _320;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _161 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _320 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float3 _42;
static bool _49;
static float3 _70;
static float _80;
static float3 _86;
static float3 _112;
static float3 _130;
static float3 _152;
static float3 _178;
static float3 _229;
static float3 _235;

void frag_inner()
{
    _9.x = (_13_m5 * 10.0f) + 1.0f;
    _9.x = exp2(_9.x);
    _31.x = dot(_13_m1.xyz, _13_m1.xyz);
    _42.x = rsqrt(_31.x);
    _49 = 9.9999999747524270787835121154785e-07f < _31.x;
    _42 = _42.xxx * _13_m1.xyz;
    float3 _62;
    if (_49)
    {
        _62 = _42;
    }
    else
    {
        _62 = float3(0.0f, 1.0f, 0.0f);
    }
    _31 = _62;
    _70 = (-vs_TEXCOORD0) + _13_m0;
    _80 = dot(_70, _70);
    _80 = rsqrt(_80);
    _86 = (_70 * _80.xxx) + _31;
    _70 = _80.xxx * _70;
    _80 = dot(_86, _86);
    _80 = rsqrt(_80);
    _86 = _80.xxx * _86;
    _80 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80 = rsqrt(_80);
    _112 = _80.xxx * vs_TEXCOORD1;
    _80 = dot(_112, _86);
    _80 = clamp(_80, 0.0f, 1.0f);
    _80 = log2(_80);
    _80 = _9.x * _80;
    _80 = exp2(_80);
    _130 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD2).xyz;
    _9.x = _130.y * 2.2000000476837158203125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _152 = _130 * _13_m4.xyz;
    _152 *= _161.xyz;
    _9.x += (-1.0f);
    _9.x = (_13_m7 * _9.x) + 1.0f;
    _178.x = _9.x * _13_m6;
    _9 = _9.xxx * _152;
    _80 *= _178.x;
    _178 = _80.xxx * _13_m3.xyz;
    _31.x = dot(_112, _31);
    _42.x = dot(_112, _70);
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _31.x = (_31.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _229 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _235 = (_13_m3.xyz * _31.xxx) + _229;
    _178 = (_9 * _235) + _178;
    _9 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _31.x = _42.x * _42.x;
    _31.x *= _31.x;
    _31.x *= _42.x;
    _31.x = (_31.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _229 = _31.xxx * _229;
    _229 *= _13_m5.xxx;
    _229 *= 0.300000011920928955078125f.xxx;
    _9 = (_229 * _9) + _178;
    _31 = _9 + (-_13_m2.xyz);
    _80 = vs_TEXCOORD4;
    _80 = clamp(_80, 0.0f, 1.0f);
    _31 = (_80.xxx * _31) + _13_m2.xyz;
    _320 = float4(_31.x, _31.y, _31.z, _320.w);
    _320.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _161 = stage_input._161;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._320 = _320;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD4;
static float3 _138;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float2 _180;
static float3 vs_TEXCOORD3;
static float4 _266;
static float4 _267;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _138 : NORMAL;
    float2 _180 : TEXCOORD0;
    float4 _267 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _266 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _158;
static float3 _192;
static float4 _209;
static float3 _215;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    vs_TEXCOORD0 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m10[1];
    _9 = (_21_m10[0] * _45.xxxx) + _9;
    _9 = (_21_m10[2] * _45.zzzz) + _9;
    _9 = (_21_m10[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD4 = (_9.x * _21_m11.z) + _21_m11.w;
    _9.x = dot(_138, _21_m9[0].xyz);
    _9.y = dot(_138, _21_m9[1].xyz);
    _9.z = dot(_138, _21_m9[2].xyz);
    _158 = dot(_9.xyz, _9.xyz);
    _158 = rsqrt(_158);
    float3 _170 = _158.xxx * _9.xyz;
    _9 = float4(_170.x, _170.y, _170.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD2 = (_180 * _21_m12.xy) + _21_m12.zw;
    _192.x = _9.y * _9.y;
    _192.x = (_9.x * _9.x) + (-_192.x);
    _209 = _9.yzzx * _9.xyzz;
    _215.x = dot(_21_m4, _209);
    _215.y = dot(_21_m5, _209);
    _215.z = dot(_21_m6, _209);
    _192 = (_21_m7.xyz * _192.xxx) + _215;
    _9.w = 1.0f;
    _215.x = dot(_21_m1, _9);
    _215.y = dot(_21_m2, _9);
    _215.z = dot(_21_m3, _9);
    _192 += _215;
    vs_TEXCOORD3 = max(_192, 0.0f.xxx);
    _266 = _267;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _180 = stage_input._180;
    _267 = stage_input._267;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._266 = _266;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float _Smoothness;
float _Specular;
float _Bumps;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 unity_FogColor
#define _13_m3 _LightColor0
#define _13_m4 _Color
#define _13_m5 _Smoothness
#define _13_m6 _Specular
#define _13_m7 _Bumps


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _161;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _320;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _161 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _320 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float3 _42;
static bool _49;
static float3 _70;
static float _80;
static float3 _86;
static float3 _112;
static float3 _130;
static float3 _152;
static float3 _178;
static float3 _229;
static float3 _235;

void frag_inner()
{
    _9.x = (_13_m5 * 10.0f) + 1.0f;
    _9.x = exp2(_9.x);
    _31.x = dot(_13_m1.xyz, _13_m1.xyz);
    _42.x = rsqrt(_31.x);
    _49 = 9.9999999747524270787835121154785e-07f < _31.x;
    _42 = _42.xxx * _13_m1.xyz;
    float3 _62;
    if (_49)
    {
        _62 = _42;
    }
    else
    {
        _62 = float3(0.0f, 1.0f, 0.0f);
    }
    _31 = _62;
    _70 = (-vs_TEXCOORD0) + _13_m0;
    _80 = dot(_70, _70);
    _80 = rsqrt(_80);
    _86 = (_70 * _80.xxx) + _31;
    _70 = _80.xxx * _70;
    _80 = dot(_86, _86);
    _80 = rsqrt(_80);
    _86 = _80.xxx * _86;
    _80 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80 = rsqrt(_80);
    _112 = _80.xxx * vs_TEXCOORD1;
    _80 = dot(_112, _86);
    _80 = clamp(_80, 0.0f, 1.0f);
    _80 = log2(_80);
    _80 = _9.x * _80;
    _80 = exp2(_80);
    _130 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD2).xyz;
    _9.x = _130.y * 2.2000000476837158203125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _152 = _130 * _13_m4.xyz;
    _152 *= _161.xyz;
    _9.x += (-1.0f);
    _9.x = (_13_m7 * _9.x) + 1.0f;
    _178.x = _9.x * _13_m6;
    _9 = _9.xxx * _152;
    _80 *= _178.x;
    _178 = _80.xxx * _13_m3.xyz;
    _31.x = dot(_112, _31);
    _42.x = dot(_112, _70);
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _31.x = (_31.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _229 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _235 = (_13_m3.xyz * _31.xxx) + _229;
    _178 = (_9 * _235) + _178;
    _9 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _31.x = _42.x * _42.x;
    _31.x *= _31.x;
    _31.x *= _42.x;
    _31.x = (_31.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _229 = _31.xxx * _229;
    _229 *= _13_m5.xxx;
    _229 *= 0.300000011920928955078125f.xxx;
    _9 = (_229 * _9) + _178;
    _31 = _9 + (-_13_m2.xyz);
    _80 = vs_TEXCOORD4;
    _80 = clamp(_80, 0.0f, 1.0f);
    _31 = (_80.xxx * _31) + _13_m2.xyz;
    _320 = float4(_31.x, _31.y, _31.z, _320.w);
    _320.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _161 = stage_input._161;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._320 = _320;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 _98;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float2 _143;
static float3 vs_TEXCOORD3;
static float4 _231;
static float4 _232;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _98 : NORMAL;
    float2 _143 : TEXCOORD0;
    float4 _232 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _231 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _121;
static float3 _155;
static float4 _172;
static float3 _178;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _11.xxxx) + _9;
    _9 = (_21_m7[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m7[3];
    vs_TEXCOORD0 = (_21_m7[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m9[1];
    _9 = (_21_m9[0] * _45.xxxx) + _9;
    _9 = (_21_m9[2] * _45.zzzz) + _9;
    gl_Position = (_21_m9[3] * _45.wwww) + _9;
    _9.x = dot(_98, _21_m8[0].xyz);
    _9.y = dot(_98, _21_m8[1].xyz);
    _9.z = dot(_98, _21_m8[2].xyz);
    _121 = dot(_9.xyz, _9.xyz);
    _121 = rsqrt(_121);
    float3 _133 = _121.xxx * _9.xyz;
    _9 = float4(_133.x, _133.y, _133.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD2 = (_143 * _21_m10.xy) + _21_m10.zw;
    _155.x = _9.y * _9.y;
    _155.x = (_9.x * _9.x) + (-_155.x);
    _172 = _9.yzzx * _9.xyzz;
    _178.x = dot(_21_m3, _172);
    _178.y = dot(_21_m4, _172);
    _178.z = dot(_21_m5, _172);
    _155 = (_21_m6.xyz * _155.xxx) + _178;
    _9.w = 1.0f;
    _178.x = dot(_21_m0, _9);
    _178.y = dot(_21_m1, _9);
    _178.z = dot(_21_m2, _9);
    _155 += _178;
    vs_TEXCOORD3 = max(_155, 0.0f.xxx);
    _231 = _232;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _98 = stage_input._98;
    _143 = stage_input._143;
    _232 = stage_input._232;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._231 = _231;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _Smoothness;
float _Specular;
float _Bumps;
#define _13_m0 _WorldSpaceCameraPos
#define _13_m1 _WorldSpaceLightPos0
#define _13_m2 _LightColor0
#define _13_m3 _Color
#define _13_m4 _Smoothness
#define _13_m5 _Specular
#define _13_m6 _Bumps


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _161;
static float3 vs_TEXCOORD3;
static float4 _295;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _161 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _295 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float3 _42;
static bool _49;
static float3 _70;
static float _80;
static float3 _86;
static float3 _112;
static float3 _130;
static float3 _152;
static float3 _178;
static float3 _229;
static float3 _235;

void frag_inner()
{
    _9.x = (_13_m4 * 10.0f) + 1.0f;
    _9.x = exp2(_9.x);
    _31.x = dot(_13_m1.xyz, _13_m1.xyz);
    _42.x = rsqrt(_31.x);
    _49 = 9.9999999747524270787835121154785e-07f < _31.x;
    _42 = _42.xxx * _13_m1.xyz;
    float3 _62;
    if (_49)
    {
        _62 = _42;
    }
    else
    {
        _62 = float3(0.0f, 1.0f, 0.0f);
    }
    _31 = _62;
    _70 = (-vs_TEXCOORD0) + _13_m0;
    _80 = dot(_70, _70);
    _80 = rsqrt(_80);
    _86 = (_70 * _80.xxx) + _31;
    _70 = _80.xxx * _70;
    _80 = dot(_86, _86);
    _80 = rsqrt(_80);
    _86 = _80.xxx * _86;
    _80 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80 = rsqrt(_80);
    _112 = _80.xxx * vs_TEXCOORD1;
    _80 = dot(_112, _86);
    _80 = clamp(_80, 0.0f, 1.0f);
    _80 = log2(_80);
    _80 = _9.x * _80;
    _80 = exp2(_80);
    _130 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD2).xyz;
    _9.x = _130.y * 2.2000000476837158203125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _152 = _130 * _13_m3.xyz;
    _152 *= _161.xyz;
    _9.x += (-1.0f);
    _9.x = (_13_m6 * _9.x) + 1.0f;
    _178.x = _9.x * _13_m5;
    _9 = _9.xxx * _152;
    _80 *= _178.x;
    _178 = _80.xxx * _13_m2.xyz;
    _31.x = dot(_112, _31);
    _42.x = dot(_112, _70);
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _31.x = (_31.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _229 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _235 = (_13_m2.xyz * _31.xxx) + _229;
    _178 = (_9 * _235) + _178;
    _9 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _31.x = _42.x * _42.x;
    _31.x *= _31.x;
    _31.x *= _42.x;
    _31.x = (_31.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _229 = _31.xxx * _229;
    _229 *= _13_m4.xxx;
    _229 *= 0.300000011920928955078125f.xxx;
    float3 _300 = (_229 * _9) + _178;
    _295 = float4(_300.x, _300.y, _300.z, _295.w);
    _295.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _161 = stage_input._161;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._295 = _295;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}