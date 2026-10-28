// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/ChainsawWound" {
Properties {

_Color ("Fresh Blood", Color) = (0.34,0.012,0.012,1)

_DeepColor ("Dark Blood", Color) = (0.1,0.004,0.004,1)

_Smoothness ("Smoothness", Range(0, 1)) = 0.8799999952316284

_Specular ("Highlight", Range(0, 4)) = 1.600000023841858

_NoiseScale ("Edge Noise Scale", Float) = 32.0

_EdgeSoftness ("Edge Softness", Range(0.02, 0.5)) = 0.11999999731779099

_CutCover ("Cover Over The Meat", Range(0, 1)) = 0.6000000238418579

[Toggle(BAKERY_VOLUME)] _BAKERY_VOLUME ("Use Bakery Volume", Float) = 1.0

_VolumeMin ("Volume Min", Vector) = (0,0,0,1)

_VolumeInvSize ("Volume Inv Size", Vector) = (1000000.0,1000000.0,1000000.0,1)

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
 Pass {
Cull Back
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
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


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _92;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _707;
static float4 _708;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _92 : NORMAL;
    float4 _708 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _707 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float4 _52;
static float _116;
static bool _133;
static float4 _140;
static float4 _165;
static float4 _217;
static float3 _235;
static float3 _246;
static float _252;
static float3 _256;
static float _268;
static float _317;
static float _373;
static float _423;
static float3 _475;
static float _531;
static float3 _579;
static float3 _587;
static float4 _603;
static float3 _609;
static float _628;

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
    _133 = 1000000.0f < _22_m13.x;
    float3 _143;
    if (_133)
    {
        _143 = _22_m14;
    }
    else
    {
        _143 = _22_m12;
    }
    _140 = float4(_143.x, _143.y, _143.z, _140.w);
    float3 _162 = _9.xyz + (-_140.xyz);
    _140 = float4(_162.x, _162.y, _162.z, _140.w);
    float3 _167;
    if (_133)
    {
        _167 = _22_m15;
    }
    else
    {
        _167 = _22_m13;
    }
    _165 = float4(_167.x, _167.y, _167.z, _165.w);
    float3 _183 = _140.xyz * _165.xyz;
    _140 = float4(_183.x, _183.y, _183.z, _140.w);
    _165 = _Volume0.SampleLevel(sampler_Volume0, _140.xyz, 0.0f).xywz;
    _116 = _165.y + _165.x;
    _116 = _165.w + _116;
    _133 = 9.9999997473787516355514526367188e-06f < _116;
    if (_133)
    {
        _217 = _Volume1.SampleLevel(sampler_Volume0, _140.xyz, 0.0f).yxwz;
        _140 = _Volume2.SampleLevel(sampler_Volume0, _140.xyz, 0.0f).xzwy;
        _235 = max(_165.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _165.x = _217.y;
        _165.y = _140.x;
        _246 = _165.xyz * 0.5f.xxx;
        _252 = dot(_246, _246);
        _256.z = sqrt(_252);
        float3 _265 = (_165.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _165 = float4(_265.x, _265.y, _265.z, _165.w);
        _268 = dot(_165.xyz, _165.xyz);
        _268 = rsqrt(_268);
        float3 _280 = _165.xyz * _268.xxx;
        _165 = float4(_280.x, _280.y, _280.z, _165.w);
        _165.x = dot(_165.xyz, _52.xyz);
        _165.x = (_165.x * 0.5f) + 0.5f;
        _165.x = clamp(_165.x, 0.0f, 1.0f);
        _256.x = _256.z + _256.z;
        float2 _310 = _256.xz / _235.xx;
        _256 = float3(_310.x, _310.y, _256.z);
        _252 = (-_256.y) + 1.0f;
        _317 = _256.y + 1.0f;
        _317 = _252 / _317;
        _252 = (-_317) + 1.0f;
        float2 _331 = _256.xx + float2(1.0f, 2.0f);
        _246 = float3(_331.x, _331.y, _246.z);
        _256.x = _252 * _246.y;
        _165.x = log2(_165.x);
        _165.x *= _246.x;
        _165.x = exp2(_165.x);
        _165.x = (_256.x * _165.x) + _317;
        _165.x *= _235.x;
        _217.y = _140.w;
        _246 = _217.xyz * 0.5f.xxx;
        _373 = dot(_246, _246);
        _373 = sqrt(_373);
        float3 _382 = (_217.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _217 = float4(_382.x, _382.y, _382.z, _217.w);
        _252 = dot(_217.xyz, _217.xyz);
        _252 = rsqrt(_252);
        float3 _396 = _252.xxx * _217.xyz;
        _217 = float4(_396.x, _396.y, _396.z, _217.w);
        _252 = dot(_217.xyz, _52.xyz);
        _252 = (_252 * 0.5f) + 0.5f;
        _252 = clamp(_252, 0.0f, 1.0f);
        _217.x = _373 + _373;
        _217.x /= _235.y;
        _373 /= _235.y;
        _423 = (-_373) + 1.0f;
        _373 += 1.0f;
        _373 = _423 / _373;
        _423 = (-_373) + 1.0f;
        float2 _437 = _217.xx + float2(1.0f, 2.0f);
        _217 = float4(_437.x, _217.y, _437.y, _217.w);
        _423 = _217.z * _423;
        _252 = log2(_252);
        _252 *= _217.x;
        _252 = exp2(_252);
        _373 = (_423 * _252) + _373;
        _165.y = _373 * _235.y;
        _140.x = _217.w;
        float3 _467 = _140.xyz * 0.5f.xxx;
        _217 = float4(_467.x, _467.y, _467.z, _217.w);
        _373 = dot(_217.xyz, _217.xyz);
        _475.z = sqrt(_373);
        float3 _482 = (_140.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _140 = float4(_482.x, _482.y, _482.z, _140.w);
        _252 = dot(_140.xyz, _140.xyz);
        _252 = rsqrt(_252);
        float3 _496 = _140.xyz * _252.xxx;
        _140 = float4(_496.x, _496.y, _496.z, _140.w);
        _140.x = dot(_140.xyz, _52.xyz);
        _140.x = (_140.x * 0.5f) + 0.5f;
        _140.x = clamp(_140.x, 0.0f, 1.0f);
        _475.x = _475.z + _475.z;
        float2 _524 = _475.xz / _235.zz;
        _475 = float3(_524.x, _524.y, _475.z);
        _373 = (-_475.y) + 1.0f;
        _531 = _475.y + 1.0f;
        _531 = _373 / _531;
        _373 = (-_531) + 1.0f;
        float2 _543 = _475.xx + float2(1.0f, 2.0f);
        _217 = float4(_543.x, _543.y, _217.z, _217.w);
        _475.x = _373 * _217.y;
        _140.x = log2(_140.x);
        _140.x *= _217.x;
        _140.x = exp2(_140.x);
        _140.x = (_475.x * _140.x) + _531;
        _165.z = _140.x * _235.z;
        _579 = _165.xyz;
    }
    else
    {
        _579.x = 0.0f;
        _579.y = 0.0f;
        _579.z = 0.0f;
    }
    _52.w = 1.0f;
    _587.x = dot(_22_m1, _52);
    _587.y = dot(_22_m2, _52);
    _587.z = dot(_22_m3, _52);
    _603 = _52.yzzx * _52.xyzz;
    _609.x = dot(_22_m4, _603);
    _609.y = dot(_22_m5, _603);
    _609.z = dot(_22_m6, _603);
    _628 = _52.y * _52.y;
    _628 = (_52.x * _52.x) + (-_628);
    _609 = (_22_m7.xyz * _628.xxx) + _609;
    _587 += _609;
    float3 _655;
    if (_133)
    {
        _655 = _579;
    }
    else
    {
        _655 = _587;
    }
    _579 = _655;
    vs_TEXCOORD3 = max(_579, 0.0f.xxx);
    _116 = _46.z / _22_m0.y;
    _116 = (-_116) + 1.0f;
    _116 *= _22_m0.z;
    _116 = max(_116, 0.0f);
    _116 *= _22_m11.y;
    vs_TEXCOORD4 = exp2(-_116);
    gl_Position = _46;
    vs_TEXCOORD0 = _9.xyz;
    vs_TEXCOORD1 = _52.xyz;
    vs_TEXCOORD2 = _11.xyz;
    _707 = _708;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _708 = stage_input._708;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._707 = _707;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float4 _DeepColor;
float _Smoothness;
float _Specular;
float _NoiseScale;
float _EdgeSoftness;
float _CutCover;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m2 unity_FogColor
#define _16_m3 _LightColor0
#define _16_m4 _Color
#define _16_m5 _DeepColor
#define _16_m6 _Smoothness
#define _16_m7 _Specular
#define _16_m8 _NoiseScale
#define _16_m9 _EdgeSoftness
#define _16_m10 _CutCover



static float3 vs_TEXCOORD2;
static float4 _769;
static float4 _831;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _769 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _831 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _31;
static float3 _42;
static float _49;
static float _83;
static float3 _136;
static float _168;
static float _332;
static float3 _371;
static float3 _669;
static float3 _726;
static float _753;
static float _791;
static bool _842;
static float3 _873;
static float _879;
static bool _900;
static float3 _980;
static float3 _1016;
static float3 _1022;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD2 * _16_m8.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = floor(_9.xyz);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _49 = _31.z * _49;
    _49 = frac(_49);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 += (-_83);
    _31 = frac(_9.xyz);
    _42 = _31 * _31;
    _31 = ((-_31) * 2.0f.xxx) + 3.0f.xxx;
    _31 *= _42;
    _49 = (_31.x * _49) + _83;
    _42 = _27 + float3(1.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _49 += (-_83);
    _49 = (_31.y * _49) + _83;
    _42 = _27 + float3(1.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _42 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _42 = _27.zyx + 31.31999969482421875f.xxx;
    _42.x = dot(_27, _42);
    _27 += _42.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _168;
    _27.x = (_31.x * _332) + _27.x;
    _332 = (-_27.x) + _83;
    _27.x = (_31.y * _332) + _27.x;
    _49 += (-_27.x);
    _49 = (_31.z * _49) + _27.x;
    float2 _378 = _49.xx * float2(0.3499999940395355224609375f, 0.4000000059604644775390625f);
    _371 = float3(_378.x, _378.y, _371.z);
    _27 = (_9.xyz * 0.310000002384185791015625f.xxx) + 17.0f.xxx;
    float3 _391 = _9.xyz * 0.310000002384185791015625f.xxx;
    _9 = float4(_391.x, _391.y, _391.z, _9.w);
    _27 = floor(_27);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _9.w = _31.z * _49;
    _9 = frac(_9);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 = _9.w + (-_83);
    _31 = _9.xyz * _9.xyz;
    float3 _466 = ((-_9.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_466.x, _466.y, _466.z, _9.w);
    float3 _472 = _9.xyz * _31;
    _9 = float4(_472.x, _472.y, _472.z, _9.w);
    _49 = (_9.x * _49) + _83;
    _31 = _27 + float3(1.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _49 += (-_83);
    _49 = (_9.y * _49) + _83;
    _31 = _27 + float3(1.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _31 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _669 = _27.zyx + 31.31999969482421875f.xxx;
    _669.x = dot(_27, _669);
    _27 += _669.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _31.x;
    _9.x = (_9.x * _332) + _27.x;
    _27.x = (-_9.x) + _83;
    _9.x = (_9.y * _27.x) + _9.x;
    _726.x = (-_9.x) + _49;
    _9.x = (_9.z * _726.x) + _9.x;
    float2 _750 = (_9.xx * float2(0.64999997615814208984375f, 0.60000002384185791015625f)) + _371.xy;
    _371 = float3(_750.x, _750.y, _371.z);
    _753 = _371.y + (-0.300000011920928955078125f);
    _371.x = (_371.x * 0.800000011920928955078125f) + 0.0500000007450580596923828125f;
    _371.x = (-_371.x) + _769.w;
    _371.x /= _16_m9;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 *= 2.5000002384185791015625f;
    _753 = clamp(_753, 0.0f, 1.0f);
    _791 = (_753 * (-2.0f)) + 3.0f;
    _753 *= _753;
    _753 *= _791;
    _753 = (_16_m10 * _753) + 0.119999997317790985107421875f;
    _753 = (-_371.x) + _753;
    _371.x = (_769.x * _753) + _371.x;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 = _371.x + (-0.0040000001899898052215576171875f);
    _831.w = _371.x * _16_m4.w;
    _842 = _753 < 0.0f;
    if ((int(_842) * (-1)) != 0)
    {
        discard;
    }
    _371 = _16_m4.xyz + (-_16_m5.xyz);
    _371 = (_9.xxx * _371) + _16_m5.xyz;
    _873 = (_371 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _879 = (_16_m6 * 10.0f) + 1.0f;
    _879 = exp2(_879);
    _9.x = dot(_16_m1.xyz, _16_m1.xyz);
    _726.x = rsqrt(_9.x);
    _900 = 9.9999999747524270787835121154785e-07f < _9.x;
    _726 = _726.xxx * _16_m1.xyz;
    float3 _913;
    if (_900)
    {
        _913 = _726;
    }
    else
    {
        _913 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_913.x, _913.y, _913.z, _9.w);
    _27 = (-vs_TEXCOORD0) + _16_m0;
    _49 = dot(_27, _27);
    _49 = rsqrt(_49);
    _31 = (_27 * _49.xxx) + _9.xyz;
    _27 = _49.xxx * _27;
    _49 = dot(_31, _31);
    _49 = rsqrt(_49);
    _31 = _49.xxx * _31;
    _49 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _49 = rsqrt(_49);
    _42 = _49.xxx * vs_TEXCOORD1;
    _49 = dot(_42, _31);
    _49 = clamp(_49, 0.0f, 1.0f);
    _49 = log2(_49);
    _49 *= _879;
    _49 = exp2(_49);
    _49 *= _16_m7;
    _980 = _49.xxx * _16_m3.xyz;
    _9.x = dot(_42, _9.xyz);
    _726.x = dot(_42, _27);
    _726.x = clamp(_726.x, 0.0f, 1.0f);
    _726.x = (-_726.x) + 1.0f;
    _9.x = (_9.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1016 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _1022 = (_16_m3.xyz * _9.xxx) + _1016;
    _371 = (_371 * _1022) + _980;
    _9.x = _726.x * _726.x;
    _9.x *= _9.x;
    _9.x *= _726.x;
    _9.x = (_9.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _980 = _9.xxx * _1016;
    _980 *= _16_m6.xxx;
    _980 *= 0.300000011920928955078125f.xxx;
    _371 = (_980 * _873) + _371;
    float3 _1085 = _371 + (-_16_m2.xyz);
    _9 = float4(_1085.x, _1085.y, _1085.z, _9.w);
    _49 = vs_TEXCOORD4;
    _49 = clamp(_49, 0.0f, 1.0f);
    float3 _1100 = (_49.xxx * _9.xyz) + _16_m2.xyz;
    _9 = float4(_1100.x, _1100.y, _1100.z, _9.w);
    _831 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _831.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _769 = stage_input._769;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._831 = _831;
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


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _92;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _710;
static float4 _711;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _92 : NORMAL;
    float4 _711 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _710 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float4 _52;
static float _116;
static bool _133;
static float4 _140;
static float4 _165;
static float4 _217;
static float3 _235;
static float3 _246;
static float _252;
static float3 _256;
static float _268;
static float _317;
static float _373;
static float _423;
static float3 _475;
static float _531;
static float3 _579;
static float3 _587;
static float4 _603;
static float3 _609;
static float _628;

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
    _133 = 1000000.0f < _22_m13.x;
    float3 _143;
    if (_133)
    {
        _143 = _22_m14;
    }
    else
    {
        _143 = _22_m12;
    }
    _140 = float4(_143.x, _143.y, _143.z, _140.w);
    float3 _162 = _9.xyz + (-_140.xyz);
    _140 = float4(_162.x, _162.y, _162.z, _140.w);
    float3 _167;
    if (_133)
    {
        _167 = _22_m15;
    }
    else
    {
        _167 = _22_m13;
    }
    _165 = float4(_167.x, _167.y, _167.z, _165.w);
    float3 _183 = _140.xyz * _165.xyz;
    _140 = float4(_183.x, _183.y, _183.z, _140.w);
    _165 = _Volume0.SampleLevel(sampler_Volume0, _140.xyz, 0.0f).xywz;
    _116 = _165.y + _165.x;
    _116 = _165.w + _116;
    _133 = 9.9999997473787516355514526367188e-06f < _116;
    if (_133)
    {
        _217 = _Volume1.SampleLevel(sampler_Volume0, _140.xyz, 0.0f).yxwz;
        _140 = _Volume2.SampleLevel(sampler_Volume0, _140.xyz, 0.0f).xzwy;
        _235 = max(_165.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _165.x = _217.y;
        _165.y = _140.x;
        _246 = _165.xyz * 0.5f.xxx;
        _252 = dot(_246, _246);
        _256.z = sqrt(_252);
        float3 _265 = (_165.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _165 = float4(_265.x, _265.y, _265.z, _165.w);
        _268 = dot(_165.xyz, _165.xyz);
        _268 = rsqrt(_268);
        float3 _280 = _165.xyz * _268.xxx;
        _165 = float4(_280.x, _280.y, _280.z, _165.w);
        _165.x = dot(_165.xyz, _52.xyz);
        _165.x = (_165.x * 0.5f) + 0.5f;
        _165.x = clamp(_165.x, 0.0f, 1.0f);
        _256.x = _256.z + _256.z;
        float2 _310 = _256.xz / _235.xx;
        _256 = float3(_310.x, _310.y, _256.z);
        _252 = (-_256.y) + 1.0f;
        _317 = _256.y + 1.0f;
        _317 = _252 / _317;
        _252 = (-_317) + 1.0f;
        float2 _331 = _256.xx + float2(1.0f, 2.0f);
        _246 = float3(_331.x, _331.y, _246.z);
        _256.x = _252 * _246.y;
        _165.x = log2(_165.x);
        _165.x *= _246.x;
        _165.x = exp2(_165.x);
        _165.x = (_256.x * _165.x) + _317;
        _165.x *= _235.x;
        _217.y = _140.w;
        _246 = _217.xyz * 0.5f.xxx;
        _373 = dot(_246, _246);
        _373 = sqrt(_373);
        float3 _382 = (_217.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _217 = float4(_382.x, _382.y, _382.z, _217.w);
        _252 = dot(_217.xyz, _217.xyz);
        _252 = rsqrt(_252);
        float3 _396 = _252.xxx * _217.xyz;
        _217 = float4(_396.x, _396.y, _396.z, _217.w);
        _252 = dot(_217.xyz, _52.xyz);
        _252 = (_252 * 0.5f) + 0.5f;
        _252 = clamp(_252, 0.0f, 1.0f);
        _217.x = _373 + _373;
        _217.x /= _235.y;
        _373 /= _235.y;
        _423 = (-_373) + 1.0f;
        _373 += 1.0f;
        _373 = _423 / _373;
        _423 = (-_373) + 1.0f;
        float2 _437 = _217.xx + float2(1.0f, 2.0f);
        _217 = float4(_437.x, _217.y, _437.y, _217.w);
        _423 = _217.z * _423;
        _252 = log2(_252);
        _252 *= _217.x;
        _252 = exp2(_252);
        _373 = (_423 * _252) + _373;
        _165.y = _373 * _235.y;
        _140.x = _217.w;
        float3 _467 = _140.xyz * 0.5f.xxx;
        _217 = float4(_467.x, _467.y, _467.z, _217.w);
        _373 = dot(_217.xyz, _217.xyz);
        _475.z = sqrt(_373);
        float3 _482 = (_140.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _140 = float4(_482.x, _482.y, _482.z, _140.w);
        _252 = dot(_140.xyz, _140.xyz);
        _252 = rsqrt(_252);
        float3 _496 = _140.xyz * _252.xxx;
        _140 = float4(_496.x, _496.y, _496.z, _140.w);
        _140.x = dot(_140.xyz, _52.xyz);
        _140.x = (_140.x * 0.5f) + 0.5f;
        _140.x = clamp(_140.x, 0.0f, 1.0f);
        _475.x = _475.z + _475.z;
        float2 _524 = _475.xz / _235.zz;
        _475 = float3(_524.x, _524.y, _475.z);
        _373 = (-_475.y) + 1.0f;
        _531 = _475.y + 1.0f;
        _531 = _373 / _531;
        _373 = (-_531) + 1.0f;
        float2 _543 = _475.xx + float2(1.0f, 2.0f);
        _217 = float4(_543.x, _543.y, _217.z, _217.w);
        _475.x = _373 * _217.y;
        _140.x = log2(_140.x);
        _140.x *= _217.x;
        _140.x = exp2(_140.x);
        _140.x = (_475.x * _140.x) + _531;
        _165.z = _140.x * _235.z;
        _579 = _165.xyz;
    }
    else
    {
        _579.x = 0.0f;
        _579.y = 0.0f;
        _579.z = 0.0f;
    }
    _52.w = 1.0f;
    _587.x = dot(_22_m1, _52);
    _587.y = dot(_22_m2, _52);
    _587.z = dot(_22_m3, _52);
    _603 = _52.yzzx * _52.xyzz;
    _609.x = dot(_22_m4, _603);
    _609.y = dot(_22_m5, _603);
    _609.z = dot(_22_m6, _603);
    _628 = _52.y * _52.y;
    _628 = (_52.x * _52.x) + (-_628);
    _609 = (_22_m7.xyz * _628.xxx) + _609;
    _587 += _609;
    float3 _655;
    if (_133)
    {
        _655 = _579;
    }
    else
    {
        _655 = _587;
    }
    _579 = _655;
    vs_TEXCOORD3 = max(_579, 0.0f.xxx);
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
    vs_TEXCOORD2 = _11.xyz;
    _710 = _711;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _711 = stage_input._711;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._710 = _710;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float4 _DeepColor;
float _Smoothness;
float _Specular;
float _NoiseScale;
float _EdgeSoftness;
float _CutCover;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m2 unity_FogColor
#define _16_m3 _LightColor0
#define _16_m4 _Color
#define _16_m5 _DeepColor
#define _16_m6 _Smoothness
#define _16_m7 _Specular
#define _16_m8 _NoiseScale
#define _16_m9 _EdgeSoftness
#define _16_m10 _CutCover



static float3 vs_TEXCOORD2;
static float4 _769;
static float4 _831;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _769 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _831 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _31;
static float3 _42;
static float _49;
static float _83;
static float3 _136;
static float _168;
static float _332;
static float3 _371;
static float3 _669;
static float3 _726;
static float _753;
static float _791;
static bool _842;
static float3 _873;
static float _879;
static bool _900;
static float3 _980;
static float3 _1016;
static float3 _1022;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD2 * _16_m8.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = floor(_9.xyz);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _49 = _31.z * _49;
    _49 = frac(_49);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 += (-_83);
    _31 = frac(_9.xyz);
    _42 = _31 * _31;
    _31 = ((-_31) * 2.0f.xxx) + 3.0f.xxx;
    _31 *= _42;
    _49 = (_31.x * _49) + _83;
    _42 = _27 + float3(1.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _49 += (-_83);
    _49 = (_31.y * _49) + _83;
    _42 = _27 + float3(1.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _42 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _42 = _27.zyx + 31.31999969482421875f.xxx;
    _42.x = dot(_27, _42);
    _27 += _42.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _168;
    _27.x = (_31.x * _332) + _27.x;
    _332 = (-_27.x) + _83;
    _27.x = (_31.y * _332) + _27.x;
    _49 += (-_27.x);
    _49 = (_31.z * _49) + _27.x;
    float2 _378 = _49.xx * float2(0.3499999940395355224609375f, 0.4000000059604644775390625f);
    _371 = float3(_378.x, _378.y, _371.z);
    _27 = (_9.xyz * 0.310000002384185791015625f.xxx) + 17.0f.xxx;
    float3 _391 = _9.xyz * 0.310000002384185791015625f.xxx;
    _9 = float4(_391.x, _391.y, _391.z, _9.w);
    _27 = floor(_27);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _9.w = _31.z * _49;
    _9 = frac(_9);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 = _9.w + (-_83);
    _31 = _9.xyz * _9.xyz;
    float3 _466 = ((-_9.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_466.x, _466.y, _466.z, _9.w);
    float3 _472 = _9.xyz * _31;
    _9 = float4(_472.x, _472.y, _472.z, _9.w);
    _49 = (_9.x * _49) + _83;
    _31 = _27 + float3(1.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _49 += (-_83);
    _49 = (_9.y * _49) + _83;
    _31 = _27 + float3(1.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _31 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _669 = _27.zyx + 31.31999969482421875f.xxx;
    _669.x = dot(_27, _669);
    _27 += _669.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _31.x;
    _9.x = (_9.x * _332) + _27.x;
    _27.x = (-_9.x) + _83;
    _9.x = (_9.y * _27.x) + _9.x;
    _726.x = (-_9.x) + _49;
    _9.x = (_9.z * _726.x) + _9.x;
    float2 _750 = (_9.xx * float2(0.64999997615814208984375f, 0.60000002384185791015625f)) + _371.xy;
    _371 = float3(_750.x, _750.y, _371.z);
    _753 = _371.y + (-0.300000011920928955078125f);
    _371.x = (_371.x * 0.800000011920928955078125f) + 0.0500000007450580596923828125f;
    _371.x = (-_371.x) + _769.w;
    _371.x /= _16_m9;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 *= 2.5000002384185791015625f;
    _753 = clamp(_753, 0.0f, 1.0f);
    _791 = (_753 * (-2.0f)) + 3.0f;
    _753 *= _753;
    _753 *= _791;
    _753 = (_16_m10 * _753) + 0.119999997317790985107421875f;
    _753 = (-_371.x) + _753;
    _371.x = (_769.x * _753) + _371.x;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 = _371.x + (-0.0040000001899898052215576171875f);
    _831.w = _371.x * _16_m4.w;
    _842 = _753 < 0.0f;
    if ((int(_842) * (-1)) != 0)
    {
        discard;
    }
    _371 = _16_m4.xyz + (-_16_m5.xyz);
    _371 = (_9.xxx * _371) + _16_m5.xyz;
    _873 = (_371 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _879 = (_16_m6 * 10.0f) + 1.0f;
    _879 = exp2(_879);
    _9.x = dot(_16_m1.xyz, _16_m1.xyz);
    _726.x = rsqrt(_9.x);
    _900 = 9.9999999747524270787835121154785e-07f < _9.x;
    _726 = _726.xxx * _16_m1.xyz;
    float3 _913;
    if (_900)
    {
        _913 = _726;
    }
    else
    {
        _913 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_913.x, _913.y, _913.z, _9.w);
    _27 = (-vs_TEXCOORD0) + _16_m0;
    _49 = dot(_27, _27);
    _49 = rsqrt(_49);
    _31 = (_27 * _49.xxx) + _9.xyz;
    _27 = _49.xxx * _27;
    _49 = dot(_31, _31);
    _49 = rsqrt(_49);
    _31 = _49.xxx * _31;
    _49 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _49 = rsqrt(_49);
    _42 = _49.xxx * vs_TEXCOORD1;
    _49 = dot(_42, _31);
    _49 = clamp(_49, 0.0f, 1.0f);
    _49 = log2(_49);
    _49 *= _879;
    _49 = exp2(_49);
    _49 *= _16_m7;
    _980 = _49.xxx * _16_m3.xyz;
    _9.x = dot(_42, _9.xyz);
    _726.x = dot(_42, _27);
    _726.x = clamp(_726.x, 0.0f, 1.0f);
    _726.x = (-_726.x) + 1.0f;
    _9.x = (_9.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1016 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _1022 = (_16_m3.xyz * _9.xxx) + _1016;
    _371 = (_371 * _1022) + _980;
    _9.x = _726.x * _726.x;
    _9.x *= _9.x;
    _9.x *= _726.x;
    _9.x = (_9.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _980 = _9.xxx * _1016;
    _980 *= _16_m6.xxx;
    _980 *= 0.300000011920928955078125f.xxx;
    _371 = (_980 * _873) + _371;
    float3 _1085 = _371 + (-_16_m2.xyz);
    _9 = float4(_1085.x, _1085.y, _1085.z, _9.w);
    _49 = vs_TEXCOORD4;
    _49 = clamp(_49, 0.0f, 1.0f);
    float3 _1100 = (_49.xxx * _9.xyz) + _16_m2.xyz;
    _9 = float4(_1100.x, _1100.y, _1100.z, _9.w);
    _831 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _831.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _769 = stage_input._769;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._831 = _831;
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


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _92;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _707;
static float4 _708;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _92 : NORMAL;
    float4 _708 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _707 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float4 _52;
static float _116;
static bool _133;
static float4 _140;
static float4 _165;
static float4 _217;
static float3 _235;
static float3 _246;
static float _252;
static float3 _256;
static float _268;
static float _317;
static float _373;
static float _423;
static float3 _475;
static float _531;
static float3 _579;
static float3 _587;
static float4 _603;
static float3 _609;
static float _628;

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
    _133 = 1000000.0f < _22_m13.x;
    float3 _143;
    if (_133)
    {
        _143 = _22_m14;
    }
    else
    {
        _143 = _22_m12;
    }
    _140 = float4(_143.x, _143.y, _143.z, _140.w);
    float3 _162 = _9.xyz + (-_140.xyz);
    _140 = float4(_162.x, _162.y, _162.z, _140.w);
    float3 _167;
    if (_133)
    {
        _167 = _22_m15;
    }
    else
    {
        _167 = _22_m13;
    }
    _165 = float4(_167.x, _167.y, _167.z, _165.w);
    float3 _183 = _140.xyz * _165.xyz;
    _140 = float4(_183.x, _183.y, _183.z, _140.w);
    _165 = _Volume0.SampleLevel(sampler_Volume0, _140.xyz, 0.0f).xywz;
    _116 = _165.y + _165.x;
    _116 = _165.w + _116;
    _133 = 9.9999997473787516355514526367188e-06f < _116;
    if (_133)
    {
        _217 = _Volume1.SampleLevel(sampler_Volume0, _140.xyz, 0.0f).yxwz;
        _140 = _Volume2.SampleLevel(sampler_Volume0, _140.xyz, 0.0f).xzwy;
        _235 = max(_165.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _165.x = _217.y;
        _165.y = _140.x;
        _246 = _165.xyz * 0.5f.xxx;
        _252 = dot(_246, _246);
        _256.z = sqrt(_252);
        float3 _265 = (_165.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _165 = float4(_265.x, _265.y, _265.z, _165.w);
        _268 = dot(_165.xyz, _165.xyz);
        _268 = rsqrt(_268);
        float3 _280 = _165.xyz * _268.xxx;
        _165 = float4(_280.x, _280.y, _280.z, _165.w);
        _165.x = dot(_165.xyz, _52.xyz);
        _165.x = (_165.x * 0.5f) + 0.5f;
        _165.x = clamp(_165.x, 0.0f, 1.0f);
        _256.x = _256.z + _256.z;
        float2 _310 = _256.xz / _235.xx;
        _256 = float3(_310.x, _310.y, _256.z);
        _252 = (-_256.y) + 1.0f;
        _317 = _256.y + 1.0f;
        _317 = _252 / _317;
        _252 = (-_317) + 1.0f;
        float2 _331 = _256.xx + float2(1.0f, 2.0f);
        _246 = float3(_331.x, _331.y, _246.z);
        _256.x = _252 * _246.y;
        _165.x = log2(_165.x);
        _165.x *= _246.x;
        _165.x = exp2(_165.x);
        _165.x = (_256.x * _165.x) + _317;
        _165.x *= _235.x;
        _217.y = _140.w;
        _246 = _217.xyz * 0.5f.xxx;
        _373 = dot(_246, _246);
        _373 = sqrt(_373);
        float3 _382 = (_217.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _217 = float4(_382.x, _382.y, _382.z, _217.w);
        _252 = dot(_217.xyz, _217.xyz);
        _252 = rsqrt(_252);
        float3 _396 = _252.xxx * _217.xyz;
        _217 = float4(_396.x, _396.y, _396.z, _217.w);
        _252 = dot(_217.xyz, _52.xyz);
        _252 = (_252 * 0.5f) + 0.5f;
        _252 = clamp(_252, 0.0f, 1.0f);
        _217.x = _373 + _373;
        _217.x /= _235.y;
        _373 /= _235.y;
        _423 = (-_373) + 1.0f;
        _373 += 1.0f;
        _373 = _423 / _373;
        _423 = (-_373) + 1.0f;
        float2 _437 = _217.xx + float2(1.0f, 2.0f);
        _217 = float4(_437.x, _217.y, _437.y, _217.w);
        _423 = _217.z * _423;
        _252 = log2(_252);
        _252 *= _217.x;
        _252 = exp2(_252);
        _373 = (_423 * _252) + _373;
        _165.y = _373 * _235.y;
        _140.x = _217.w;
        float3 _467 = _140.xyz * 0.5f.xxx;
        _217 = float4(_467.x, _467.y, _467.z, _217.w);
        _373 = dot(_217.xyz, _217.xyz);
        _475.z = sqrt(_373);
        float3 _482 = (_140.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _140 = float4(_482.x, _482.y, _482.z, _140.w);
        _252 = dot(_140.xyz, _140.xyz);
        _252 = rsqrt(_252);
        float3 _496 = _140.xyz * _252.xxx;
        _140 = float4(_496.x, _496.y, _496.z, _140.w);
        _140.x = dot(_140.xyz, _52.xyz);
        _140.x = (_140.x * 0.5f) + 0.5f;
        _140.x = clamp(_140.x, 0.0f, 1.0f);
        _475.x = _475.z + _475.z;
        float2 _524 = _475.xz / _235.zz;
        _475 = float3(_524.x, _524.y, _475.z);
        _373 = (-_475.y) + 1.0f;
        _531 = _475.y + 1.0f;
        _531 = _373 / _531;
        _373 = (-_531) + 1.0f;
        float2 _543 = _475.xx + float2(1.0f, 2.0f);
        _217 = float4(_543.x, _543.y, _217.z, _217.w);
        _475.x = _373 * _217.y;
        _140.x = log2(_140.x);
        _140.x *= _217.x;
        _140.x = exp2(_140.x);
        _140.x = (_475.x * _140.x) + _531;
        _165.z = _140.x * _235.z;
        _579 = _165.xyz;
    }
    else
    {
        _579.x = 0.0f;
        _579.y = 0.0f;
        _579.z = 0.0f;
    }
    _52.w = 1.0f;
    _587.x = dot(_22_m1, _52);
    _587.y = dot(_22_m2, _52);
    _587.z = dot(_22_m3, _52);
    _603 = _52.yzzx * _52.xyzz;
    _609.x = dot(_22_m4, _603);
    _609.y = dot(_22_m5, _603);
    _609.z = dot(_22_m6, _603);
    _628 = _52.y * _52.y;
    _628 = (_52.x * _52.x) + (-_628);
    _609 = (_22_m7.xyz * _628.xxx) + _609;
    _587 += _609;
    float3 _655;
    if (_133)
    {
        _655 = _579;
    }
    else
    {
        _655 = _587;
    }
    _579 = _655;
    vs_TEXCOORD3 = max(_579, 0.0f.xxx);
    _116 = _46.z / _22_m0.y;
    _116 = (-_116) + 1.0f;
    _116 *= _22_m0.z;
    _116 = max(_116, 0.0f);
    vs_TEXCOORD4 = (_116 * _22_m11.z) + _22_m11.w;
    gl_Position = _46;
    vs_TEXCOORD0 = _9.xyz;
    vs_TEXCOORD1 = _52.xyz;
    vs_TEXCOORD2 = _11.xyz;
    _707 = _708;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _708 = stage_input._708;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._707 = _707;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float4 _DeepColor;
float _Smoothness;
float _Specular;
float _NoiseScale;
float _EdgeSoftness;
float _CutCover;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m2 unity_FogColor
#define _16_m3 _LightColor0
#define _16_m4 _Color
#define _16_m5 _DeepColor
#define _16_m6 _Smoothness
#define _16_m7 _Specular
#define _16_m8 _NoiseScale
#define _16_m9 _EdgeSoftness
#define _16_m10 _CutCover



static float3 vs_TEXCOORD2;
static float4 _769;
static float4 _831;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _769 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _831 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _31;
static float3 _42;
static float _49;
static float _83;
static float3 _136;
static float _168;
static float _332;
static float3 _371;
static float3 _669;
static float3 _726;
static float _753;
static float _791;
static bool _842;
static float3 _873;
static float _879;
static bool _900;
static float3 _980;
static float3 _1016;
static float3 _1022;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD2 * _16_m8.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = floor(_9.xyz);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _49 = _31.z * _49;
    _49 = frac(_49);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 += (-_83);
    _31 = frac(_9.xyz);
    _42 = _31 * _31;
    _31 = ((-_31) * 2.0f.xxx) + 3.0f.xxx;
    _31 *= _42;
    _49 = (_31.x * _49) + _83;
    _42 = _27 + float3(1.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _49 += (-_83);
    _49 = (_31.y * _49) + _83;
    _42 = _27 + float3(1.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _42 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _42 = _27.zyx + 31.31999969482421875f.xxx;
    _42.x = dot(_27, _42);
    _27 += _42.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _168;
    _27.x = (_31.x * _332) + _27.x;
    _332 = (-_27.x) + _83;
    _27.x = (_31.y * _332) + _27.x;
    _49 += (-_27.x);
    _49 = (_31.z * _49) + _27.x;
    float2 _378 = _49.xx * float2(0.3499999940395355224609375f, 0.4000000059604644775390625f);
    _371 = float3(_378.x, _378.y, _371.z);
    _27 = (_9.xyz * 0.310000002384185791015625f.xxx) + 17.0f.xxx;
    float3 _391 = _9.xyz * 0.310000002384185791015625f.xxx;
    _9 = float4(_391.x, _391.y, _391.z, _9.w);
    _27 = floor(_27);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _9.w = _31.z * _49;
    _9 = frac(_9);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 = _9.w + (-_83);
    _31 = _9.xyz * _9.xyz;
    float3 _466 = ((-_9.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_466.x, _466.y, _466.z, _9.w);
    float3 _472 = _9.xyz * _31;
    _9 = float4(_472.x, _472.y, _472.z, _9.w);
    _49 = (_9.x * _49) + _83;
    _31 = _27 + float3(1.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _49 += (-_83);
    _49 = (_9.y * _49) + _83;
    _31 = _27 + float3(1.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _31 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _669 = _27.zyx + 31.31999969482421875f.xxx;
    _669.x = dot(_27, _669);
    _27 += _669.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _31.x;
    _9.x = (_9.x * _332) + _27.x;
    _27.x = (-_9.x) + _83;
    _9.x = (_9.y * _27.x) + _9.x;
    _726.x = (-_9.x) + _49;
    _9.x = (_9.z * _726.x) + _9.x;
    float2 _750 = (_9.xx * float2(0.64999997615814208984375f, 0.60000002384185791015625f)) + _371.xy;
    _371 = float3(_750.x, _750.y, _371.z);
    _753 = _371.y + (-0.300000011920928955078125f);
    _371.x = (_371.x * 0.800000011920928955078125f) + 0.0500000007450580596923828125f;
    _371.x = (-_371.x) + _769.w;
    _371.x /= _16_m9;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 *= 2.5000002384185791015625f;
    _753 = clamp(_753, 0.0f, 1.0f);
    _791 = (_753 * (-2.0f)) + 3.0f;
    _753 *= _753;
    _753 *= _791;
    _753 = (_16_m10 * _753) + 0.119999997317790985107421875f;
    _753 = (-_371.x) + _753;
    _371.x = (_769.x * _753) + _371.x;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 = _371.x + (-0.0040000001899898052215576171875f);
    _831.w = _371.x * _16_m4.w;
    _842 = _753 < 0.0f;
    if ((int(_842) * (-1)) != 0)
    {
        discard;
    }
    _371 = _16_m4.xyz + (-_16_m5.xyz);
    _371 = (_9.xxx * _371) + _16_m5.xyz;
    _873 = (_371 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _879 = (_16_m6 * 10.0f) + 1.0f;
    _879 = exp2(_879);
    _9.x = dot(_16_m1.xyz, _16_m1.xyz);
    _726.x = rsqrt(_9.x);
    _900 = 9.9999999747524270787835121154785e-07f < _9.x;
    _726 = _726.xxx * _16_m1.xyz;
    float3 _913;
    if (_900)
    {
        _913 = _726;
    }
    else
    {
        _913 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_913.x, _913.y, _913.z, _9.w);
    _27 = (-vs_TEXCOORD0) + _16_m0;
    _49 = dot(_27, _27);
    _49 = rsqrt(_49);
    _31 = (_27 * _49.xxx) + _9.xyz;
    _27 = _49.xxx * _27;
    _49 = dot(_31, _31);
    _49 = rsqrt(_49);
    _31 = _49.xxx * _31;
    _49 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _49 = rsqrt(_49);
    _42 = _49.xxx * vs_TEXCOORD1;
    _49 = dot(_42, _31);
    _49 = clamp(_49, 0.0f, 1.0f);
    _49 = log2(_49);
    _49 *= _879;
    _49 = exp2(_49);
    _49 *= _16_m7;
    _980 = _49.xxx * _16_m3.xyz;
    _9.x = dot(_42, _9.xyz);
    _726.x = dot(_42, _27);
    _726.x = clamp(_726.x, 0.0f, 1.0f);
    _726.x = (-_726.x) + 1.0f;
    _9.x = (_9.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1016 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _1022 = (_16_m3.xyz * _9.xxx) + _1016;
    _371 = (_371 * _1022) + _980;
    _9.x = _726.x * _726.x;
    _9.x *= _9.x;
    _9.x *= _726.x;
    _9.x = (_9.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _980 = _9.xxx * _1016;
    _980 *= _16_m6.xxx;
    _980 *= 0.300000011920928955078125f.xxx;
    _371 = (_980 * _873) + _371;
    float3 _1085 = _371 + (-_16_m2.xyz);
    _9 = float4(_1085.x, _1085.y, _1085.z, _9.w);
    _49 = vs_TEXCOORD4;
    _49 = clamp(_49, 0.0f, 1.0f);
    float3 _1100 = (_49.xxx * _9.xyz) + _16_m2.xyz;
    _9 = float4(_1100.x, _1100.y, _1100.z, _9.w);
    _831 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _831.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _769 = stage_input._769;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._831 = _831;
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


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float3 _99;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _680;
static float4 _681;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _99 : NORMAL;
    float4 _681 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _680 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float4 _52;
static float _122;
static bool _139;
static float4 _170;
static float4 _222;
static float3 _240;
static float3 _251;
static float _257;
static float3 _261;
static float _273;
static float _322;
static float _378;
static float _428;
static float3 _480;
static float _536;
static float3 _584;
static float3 _592;
static float4 _608;
static float3 _614;
static float _632;

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
    _139 = 1000000.0f < _22_m11.x;
    float3 _148;
    if (_139)
    {
        _148 = _22_m12;
    }
    else
    {
        _148 = _22_m10;
    }
    _52 = float4(_148.x, _148.y, _148.z, _52.w);
    float3 _167 = _9.xyz + (-_52.xyz);
    _52 = float4(_167.x, _167.y, _167.z, _52.w);
    float3 _172;
    if (_139)
    {
        _172 = _22_m13;
    }
    else
    {
        _172 = _22_m11;
    }
    _170 = float4(_172.x, _172.y, _172.z, _170.w);
    float3 _188 = _52.xyz * _170.xyz;
    _52 = float4(_188.x, _188.y, _188.z, _52.w);
    _170 = _Volume0.SampleLevel(sampler_Volume0, _52.xyz, 0.0f).xywz;
    _122 = _170.y + _170.x;
    _122 = _170.w + _122;
    _139 = 9.9999997473787516355514526367188e-06f < _122;
    if (_139)
    {
        _222 = _Volume1.SampleLevel(sampler_Volume0, _52.xyz, 0.0f).yxwz;
        _52 = _Volume2.SampleLevel(sampler_Volume0, _52.xyz, 0.0f).xzwy;
        _240 = max(_170.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _170.x = _222.y;
        _170.y = _52.x;
        _251 = _170.xyz * 0.5f.xxx;
        _257 = dot(_251, _251);
        _261.z = sqrt(_257);
        float3 _270 = (_170.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _170 = float4(_270.x, _270.y, _270.z, _170.w);
        _273 = dot(_170.xyz, _170.xyz);
        _273 = rsqrt(_273);
        float3 _285 = _170.xyz * _273.xxx;
        _170 = float4(_285.x, _285.y, _285.z, _170.w);
        _170.x = dot(_170.xyz, _46.xyz);
        _170.x = (_170.x * 0.5f) + 0.5f;
        _170.x = clamp(_170.x, 0.0f, 1.0f);
        _261.x = _261.z + _261.z;
        float2 _315 = _261.xz / _240.xx;
        _261 = float3(_315.x, _315.y, _261.z);
        _257 = (-_261.y) + 1.0f;
        _322 = _261.y + 1.0f;
        _322 = _257 / _322;
        _257 = (-_322) + 1.0f;
        float2 _336 = _261.xx + float2(1.0f, 2.0f);
        _251 = float3(_336.x, _336.y, _251.z);
        _261.x = _257 * _251.y;
        _170.x = log2(_170.x);
        _170.x *= _251.x;
        _170.x = exp2(_170.x);
        _170.x = (_261.x * _170.x) + _322;
        _170.x *= _240.x;
        _222.y = _52.w;
        _251 = _222.xyz * 0.5f.xxx;
        _378 = dot(_251, _251);
        _378 = sqrt(_378);
        float3 _387 = (_222.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _222 = float4(_387.x, _387.y, _387.z, _222.w);
        _257 = dot(_222.xyz, _222.xyz);
        _257 = rsqrt(_257);
        float3 _401 = _257.xxx * _222.xyz;
        _222 = float4(_401.x, _401.y, _401.z, _222.w);
        _257 = dot(_222.xyz, _46.xyz);
        _257 = (_257 * 0.5f) + 0.5f;
        _257 = clamp(_257, 0.0f, 1.0f);
        _222.x = _378 + _378;
        _222.x /= _240.y;
        _378 /= _240.y;
        _428 = (-_378) + 1.0f;
        _378 += 1.0f;
        _378 = _428 / _378;
        _428 = (-_378) + 1.0f;
        float2 _442 = _222.xx + float2(1.0f, 2.0f);
        _222 = float4(_442.x, _222.y, _442.y, _222.w);
        _428 = _222.z * _428;
        _257 = log2(_257);
        _257 *= _222.x;
        _257 = exp2(_257);
        _378 = (_428 * _257) + _378;
        _170.y = _378 * _240.y;
        _52.x = _222.w;
        float3 _472 = _52.xyz * 0.5f.xxx;
        _222 = float4(_472.x, _472.y, _472.z, _222.w);
        _378 = dot(_222.xyz, _222.xyz);
        _480.z = sqrt(_378);
        float3 _487 = (_52.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _52 = float4(_487.x, _487.y, _487.z, _52.w);
        _257 = dot(_52.xyz, _52.xyz);
        _257 = rsqrt(_257);
        float3 _501 = _52.xyz * _257.xxx;
        _52 = float4(_501.x, _501.y, _501.z, _52.w);
        _52.x = dot(_52.xyz, _46.xyz);
        _52.x = (_52.x * 0.5f) + 0.5f;
        _52.x = clamp(_52.x, 0.0f, 1.0f);
        _480.x = _480.z + _480.z;
        float2 _529 = _480.xz / _240.zz;
        _480 = float3(_529.x, _529.y, _480.z);
        _378 = (-_480.y) + 1.0f;
        _536 = _480.y + 1.0f;
        _536 = _378 / _536;
        _378 = (-_536) + 1.0f;
        float2 _548 = _480.xx + float2(1.0f, 2.0f);
        _222 = float4(_548.x, _548.y, _222.z, _222.w);
        _480.x = _378 * _222.y;
        _52.x = log2(_52.x);
        _52.x *= _222.x;
        _52.x = exp2(_52.x);
        _52.x = (_480.x * _52.x) + _536;
        _170.z = _52.x * _240.z;
        _584 = _170.xyz;
    }
    else
    {
        _584.x = 0.0f;
        _584.y = 0.0f;
        _584.z = 0.0f;
    }
    _46.w = 1.0f;
    _592.x = dot(_22_m0, _46);
    _592.y = dot(_22_m1, _46);
    _592.z = dot(_22_m2, _46);
    _608 = _46.yzzx * _46.xyzz;
    _614.x = dot(_22_m3, _608);
    _614.y = dot(_22_m4, _608);
    _614.z = dot(_22_m5, _608);
    _632 = _46.y * _46.y;
    _632 = (_46.x * _46.x) + (-_632);
    _614 = (_22_m6.xyz * _632.xxx) + _614;
    _592 += _614;
    float3 _659;
    if (_139)
    {
        _659 = _584;
    }
    else
    {
        _659 = _592;
    }
    _584 = _659;
    vs_TEXCOORD3 = max(_584, 0.0f.xxx);
    vs_TEXCOORD0 = _9.xyz;
    vs_TEXCOORD1 = _46.xyz;
    vs_TEXCOORD2 = _11.xyz;
    _680 = _681;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _681 = stage_input._681;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._680 = _680;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float4 _DeepColor;
float _Smoothness;
float _Specular;
float _NoiseScale;
float _EdgeSoftness;
float _CutCover;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m2 _LightColor0
#define _16_m3 _Color
#define _16_m4 _DeepColor
#define _16_m5 _Smoothness
#define _16_m6 _Specular
#define _16_m7 _NoiseScale
#define _16_m8 _EdgeSoftness
#define _16_m9 _CutCover



static float3 vs_TEXCOORD2;
static float4 _769;
static float4 _831;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _769 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _831 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _31;
static float3 _42;
static float _49;
static float _83;
static float3 _136;
static float _168;
static float _332;
static float3 _371;
static float3 _669;
static float3 _726;
static float _753;
static float _791;
static bool _842;
static float3 _873;
static float _879;
static bool _900;
static float3 _980;
static float3 _1016;
static float3 _1022;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD2 * _16_m7.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = floor(_9.xyz);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _49 = _31.z * _49;
    _49 = frac(_49);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 += (-_83);
    _31 = frac(_9.xyz);
    _42 = _31 * _31;
    _31 = ((-_31) * 2.0f.xxx) + 3.0f.xxx;
    _31 *= _42;
    _49 = (_31.x * _49) + _83;
    _42 = _27 + float3(1.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _49 += (-_83);
    _49 = (_31.y * _49) + _83;
    _42 = _27 + float3(1.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _42 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _42 = _27.zyx + 31.31999969482421875f.xxx;
    _42.x = dot(_27, _42);
    _27 += _42.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _168;
    _27.x = (_31.x * _332) + _27.x;
    _332 = (-_27.x) + _83;
    _27.x = (_31.y * _332) + _27.x;
    _49 += (-_27.x);
    _49 = (_31.z * _49) + _27.x;
    float2 _378 = _49.xx * float2(0.3499999940395355224609375f, 0.4000000059604644775390625f);
    _371 = float3(_378.x, _378.y, _371.z);
    _27 = (_9.xyz * 0.310000002384185791015625f.xxx) + 17.0f.xxx;
    float3 _391 = _9.xyz * 0.310000002384185791015625f.xxx;
    _9 = float4(_391.x, _391.y, _391.z, _9.w);
    _27 = floor(_27);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _9.w = _31.z * _49;
    _9 = frac(_9);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 = _9.w + (-_83);
    _31 = _9.xyz * _9.xyz;
    float3 _466 = ((-_9.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_466.x, _466.y, _466.z, _9.w);
    float3 _472 = _9.xyz * _31;
    _9 = float4(_472.x, _472.y, _472.z, _9.w);
    _49 = (_9.x * _49) + _83;
    _31 = _27 + float3(1.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _49 += (-_83);
    _49 = (_9.y * _49) + _83;
    _31 = _27 + float3(1.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _31 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _669 = _27.zyx + 31.31999969482421875f.xxx;
    _669.x = dot(_27, _669);
    _27 += _669.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _31.x;
    _9.x = (_9.x * _332) + _27.x;
    _27.x = (-_9.x) + _83;
    _9.x = (_9.y * _27.x) + _9.x;
    _726.x = (-_9.x) + _49;
    _9.x = (_9.z * _726.x) + _9.x;
    float2 _750 = (_9.xx * float2(0.64999997615814208984375f, 0.60000002384185791015625f)) + _371.xy;
    _371 = float3(_750.x, _750.y, _371.z);
    _753 = _371.y + (-0.300000011920928955078125f);
    _371.x = (_371.x * 0.800000011920928955078125f) + 0.0500000007450580596923828125f;
    _371.x = (-_371.x) + _769.w;
    _371.x /= _16_m8;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 *= 2.5000002384185791015625f;
    _753 = clamp(_753, 0.0f, 1.0f);
    _791 = (_753 * (-2.0f)) + 3.0f;
    _753 *= _753;
    _753 *= _791;
    _753 = (_16_m9 * _753) + 0.119999997317790985107421875f;
    _753 = (-_371.x) + _753;
    _371.x = (_769.x * _753) + _371.x;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 = _371.x + (-0.0040000001899898052215576171875f);
    _831.w = _371.x * _16_m3.w;
    _842 = _753 < 0.0f;
    if ((int(_842) * (-1)) != 0)
    {
        discard;
    }
    _371 = _16_m3.xyz + (-_16_m4.xyz);
    _371 = (_9.xxx * _371) + _16_m4.xyz;
    _873 = (_371 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _879 = (_16_m5 * 10.0f) + 1.0f;
    _879 = exp2(_879);
    _9.x = dot(_16_m1.xyz, _16_m1.xyz);
    _726.x = rsqrt(_9.x);
    _900 = 9.9999999747524270787835121154785e-07f < _9.x;
    _726 = _726.xxx * _16_m1.xyz;
    float3 _913;
    if (_900)
    {
        _913 = _726;
    }
    else
    {
        _913 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_913.x, _913.y, _913.z, _9.w);
    _27 = (-vs_TEXCOORD0) + _16_m0;
    _49 = dot(_27, _27);
    _49 = rsqrt(_49);
    _31 = (_27 * _49.xxx) + _9.xyz;
    _27 = _49.xxx * _27;
    _49 = dot(_31, _31);
    _49 = rsqrt(_49);
    _31 = _49.xxx * _31;
    _49 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _49 = rsqrt(_49);
    _42 = _49.xxx * vs_TEXCOORD1;
    _49 = dot(_42, _31);
    _49 = clamp(_49, 0.0f, 1.0f);
    _49 = log2(_49);
    _49 *= _879;
    _49 = exp2(_49);
    _49 *= _16_m6;
    _980 = _49.xxx * _16_m2.xyz;
    _9.x = dot(_42, _9.xyz);
    _726.x = dot(_42, _27);
    _726.x = clamp(_726.x, 0.0f, 1.0f);
    _726.x = (-_726.x) + 1.0f;
    _9.x = (_9.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1016 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _1022 = (_16_m2.xyz * _9.xxx) + _1016;
    _371 = (_371 * _1022) + _980;
    _9.x = _726.x * _726.x;
    _9.x *= _9.x;
    _9.x *= _726.x;
    _9.x = (_9.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _980 = _9.xxx * _1016;
    _980 *= _16_m5.xxx;
    _980 *= 0.300000011920928955078125f.xxx;
    float3 _1078 = (_980 * _873) + _371;
    _831 = float4(_1078.x, _1078.y, _1078.z, _831.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _769 = stage_input._769;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._831 = _831;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD4;
static float3 _139;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _256;
static float4 _257;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _139 : NORMAL;
    float4 _257 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _256 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _159;
static float3 _181;
static float4 _198;
static float3 _204;

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
    vs_TEXCOORD2 = _11.xyz;
    _181.x = _9.y * _9.y;
    _181.x = (_9.x * _9.x) + (-_181.x);
    _198 = _9.yzzx * _9.xyzz;
    _204.x = dot(_21_m4, _198);
    _204.y = dot(_21_m5, _198);
    _204.z = dot(_21_m6, _198);
    _181 = (_21_m7.xyz * _181.xxx) + _204;
    _9.w = 1.0f;
    _204.x = dot(_21_m1, _9);
    _204.y = dot(_21_m2, _9);
    _204.z = dot(_21_m3, _9);
    _181 += _204;
    vs_TEXCOORD3 = max(_181, 0.0f.xxx);
    _256 = _257;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _257 = stage_input._257;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._256 = _256;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float4 _DeepColor;
float _Smoothness;
float _Specular;
float _NoiseScale;
float _EdgeSoftness;
float _CutCover;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m2 unity_FogColor
#define _16_m3 _LightColor0
#define _16_m4 _Color
#define _16_m5 _DeepColor
#define _16_m6 _Smoothness
#define _16_m7 _Specular
#define _16_m8 _NoiseScale
#define _16_m9 _EdgeSoftness
#define _16_m10 _CutCover



static float3 vs_TEXCOORD2;
static float4 _769;
static float4 _831;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _769 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _831 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _31;
static float3 _42;
static float _49;
static float _83;
static float3 _136;
static float _168;
static float _332;
static float3 _371;
static float3 _669;
static float3 _726;
static float _753;
static float _791;
static bool _842;
static float3 _873;
static float _879;
static bool _900;
static float3 _980;
static float3 _1016;
static float3 _1022;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD2 * _16_m8.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = floor(_9.xyz);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _49 = _31.z * _49;
    _49 = frac(_49);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 += (-_83);
    _31 = frac(_9.xyz);
    _42 = _31 * _31;
    _31 = ((-_31) * 2.0f.xxx) + 3.0f.xxx;
    _31 *= _42;
    _49 = (_31.x * _49) + _83;
    _42 = _27 + float3(1.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _49 += (-_83);
    _49 = (_31.y * _49) + _83;
    _42 = _27 + float3(1.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _42 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _42 = _27.zyx + 31.31999969482421875f.xxx;
    _42.x = dot(_27, _42);
    _27 += _42.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _168;
    _27.x = (_31.x * _332) + _27.x;
    _332 = (-_27.x) + _83;
    _27.x = (_31.y * _332) + _27.x;
    _49 += (-_27.x);
    _49 = (_31.z * _49) + _27.x;
    float2 _378 = _49.xx * float2(0.3499999940395355224609375f, 0.4000000059604644775390625f);
    _371 = float3(_378.x, _378.y, _371.z);
    _27 = (_9.xyz * 0.310000002384185791015625f.xxx) + 17.0f.xxx;
    float3 _391 = _9.xyz * 0.310000002384185791015625f.xxx;
    _9 = float4(_391.x, _391.y, _391.z, _9.w);
    _27 = floor(_27);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _9.w = _31.z * _49;
    _9 = frac(_9);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 = _9.w + (-_83);
    _31 = _9.xyz * _9.xyz;
    float3 _466 = ((-_9.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_466.x, _466.y, _466.z, _9.w);
    float3 _472 = _9.xyz * _31;
    _9 = float4(_472.x, _472.y, _472.z, _9.w);
    _49 = (_9.x * _49) + _83;
    _31 = _27 + float3(1.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _49 += (-_83);
    _49 = (_9.y * _49) + _83;
    _31 = _27 + float3(1.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _31 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _669 = _27.zyx + 31.31999969482421875f.xxx;
    _669.x = dot(_27, _669);
    _27 += _669.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _31.x;
    _9.x = (_9.x * _332) + _27.x;
    _27.x = (-_9.x) + _83;
    _9.x = (_9.y * _27.x) + _9.x;
    _726.x = (-_9.x) + _49;
    _9.x = (_9.z * _726.x) + _9.x;
    float2 _750 = (_9.xx * float2(0.64999997615814208984375f, 0.60000002384185791015625f)) + _371.xy;
    _371 = float3(_750.x, _750.y, _371.z);
    _753 = _371.y + (-0.300000011920928955078125f);
    _371.x = (_371.x * 0.800000011920928955078125f) + 0.0500000007450580596923828125f;
    _371.x = (-_371.x) + _769.w;
    _371.x /= _16_m9;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 *= 2.5000002384185791015625f;
    _753 = clamp(_753, 0.0f, 1.0f);
    _791 = (_753 * (-2.0f)) + 3.0f;
    _753 *= _753;
    _753 *= _791;
    _753 = (_16_m10 * _753) + 0.119999997317790985107421875f;
    _753 = (-_371.x) + _753;
    _371.x = (_769.x * _753) + _371.x;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 = _371.x + (-0.0040000001899898052215576171875f);
    _831.w = _371.x * _16_m4.w;
    _842 = _753 < 0.0f;
    if ((int(_842) * (-1)) != 0)
    {
        discard;
    }
    _371 = _16_m4.xyz + (-_16_m5.xyz);
    _371 = (_9.xxx * _371) + _16_m5.xyz;
    _873 = (_371 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _879 = (_16_m6 * 10.0f) + 1.0f;
    _879 = exp2(_879);
    _9.x = dot(_16_m1.xyz, _16_m1.xyz);
    _726.x = rsqrt(_9.x);
    _900 = 9.9999999747524270787835121154785e-07f < _9.x;
    _726 = _726.xxx * _16_m1.xyz;
    float3 _913;
    if (_900)
    {
        _913 = _726;
    }
    else
    {
        _913 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_913.x, _913.y, _913.z, _9.w);
    _27 = (-vs_TEXCOORD0) + _16_m0;
    _49 = dot(_27, _27);
    _49 = rsqrt(_49);
    _31 = (_27 * _49.xxx) + _9.xyz;
    _27 = _49.xxx * _27;
    _49 = dot(_31, _31);
    _49 = rsqrt(_49);
    _31 = _49.xxx * _31;
    _49 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _49 = rsqrt(_49);
    _42 = _49.xxx * vs_TEXCOORD1;
    _49 = dot(_42, _31);
    _49 = clamp(_49, 0.0f, 1.0f);
    _49 = log2(_49);
    _49 *= _879;
    _49 = exp2(_49);
    _49 *= _16_m7;
    _980 = _49.xxx * _16_m3.xyz;
    _9.x = dot(_42, _9.xyz);
    _726.x = dot(_42, _27);
    _726.x = clamp(_726.x, 0.0f, 1.0f);
    _726.x = (-_726.x) + 1.0f;
    _9.x = (_9.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1016 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _1022 = (_16_m3.xyz * _9.xxx) + _1016;
    _371 = (_371 * _1022) + _980;
    _9.x = _726.x * _726.x;
    _9.x *= _9.x;
    _9.x *= _726.x;
    _9.x = (_9.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _980 = _9.xxx * _1016;
    _980 *= _16_m6.xxx;
    _980 *= 0.300000011920928955078125f.xxx;
    _371 = (_980 * _873) + _371;
    float3 _1085 = _371 + (-_16_m2.xyz);
    _9 = float4(_1085.x, _1085.y, _1085.z, _9.w);
    _49 = vs_TEXCOORD4;
    _49 = clamp(_49, 0.0f, 1.0f);
    float3 _1100 = (_49.xxx * _9.xyz) + _16_m2.xyz;
    _9 = float4(_1100.x, _1100.y, _1100.z, _9.w);
    _831 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _831.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _769 = stage_input._769;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._831 = _831;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD4;
static float3 _145;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _262;
static float4 _263;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _145 : NORMAL;
    float4 _263 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _262 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _165;
static float3 _187;
static float4 _204;
static float3 _210;

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
    vs_TEXCOORD2 = _11.xyz;
    _187.x = _9.y * _9.y;
    _187.x = (_9.x * _9.x) + (-_187.x);
    _204 = _9.yzzx * _9.xyzz;
    _210.x = dot(_21_m4, _204);
    _210.y = dot(_21_m5, _204);
    _210.z = dot(_21_m6, _204);
    _187 = (_21_m7.xyz * _187.xxx) + _210;
    _9.w = 1.0f;
    _210.x = dot(_21_m1, _9);
    _210.y = dot(_21_m2, _9);
    _210.z = dot(_21_m3, _9);
    _187 += _210;
    vs_TEXCOORD3 = max(_187, 0.0f.xxx);
    _262 = _263;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    _263 = stage_input._263;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._262 = _262;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float4 _DeepColor;
float _Smoothness;
float _Specular;
float _NoiseScale;
float _EdgeSoftness;
float _CutCover;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m2 unity_FogColor
#define _16_m3 _LightColor0
#define _16_m4 _Color
#define _16_m5 _DeepColor
#define _16_m6 _Smoothness
#define _16_m7 _Specular
#define _16_m8 _NoiseScale
#define _16_m9 _EdgeSoftness
#define _16_m10 _CutCover



static float3 vs_TEXCOORD2;
static float4 _769;
static float4 _831;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _769 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _831 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _31;
static float3 _42;
static float _49;
static float _83;
static float3 _136;
static float _168;
static float _332;
static float3 _371;
static float3 _669;
static float3 _726;
static float _753;
static float _791;
static bool _842;
static float3 _873;
static float _879;
static bool _900;
static float3 _980;
static float3 _1016;
static float3 _1022;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD2 * _16_m8.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = floor(_9.xyz);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _49 = _31.z * _49;
    _49 = frac(_49);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 += (-_83);
    _31 = frac(_9.xyz);
    _42 = _31 * _31;
    _31 = ((-_31) * 2.0f.xxx) + 3.0f.xxx;
    _31 *= _42;
    _49 = (_31.x * _49) + _83;
    _42 = _27 + float3(1.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _49 += (-_83);
    _49 = (_31.y * _49) + _83;
    _42 = _27 + float3(1.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _42 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _42 = _27.zyx + 31.31999969482421875f.xxx;
    _42.x = dot(_27, _42);
    _27 += _42.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _168;
    _27.x = (_31.x * _332) + _27.x;
    _332 = (-_27.x) + _83;
    _27.x = (_31.y * _332) + _27.x;
    _49 += (-_27.x);
    _49 = (_31.z * _49) + _27.x;
    float2 _378 = _49.xx * float2(0.3499999940395355224609375f, 0.4000000059604644775390625f);
    _371 = float3(_378.x, _378.y, _371.z);
    _27 = (_9.xyz * 0.310000002384185791015625f.xxx) + 17.0f.xxx;
    float3 _391 = _9.xyz * 0.310000002384185791015625f.xxx;
    _9 = float4(_391.x, _391.y, _391.z, _9.w);
    _27 = floor(_27);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _9.w = _31.z * _49;
    _9 = frac(_9);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 = _9.w + (-_83);
    _31 = _9.xyz * _9.xyz;
    float3 _466 = ((-_9.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_466.x, _466.y, _466.z, _9.w);
    float3 _472 = _9.xyz * _31;
    _9 = float4(_472.x, _472.y, _472.z, _9.w);
    _49 = (_9.x * _49) + _83;
    _31 = _27 + float3(1.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _49 += (-_83);
    _49 = (_9.y * _49) + _83;
    _31 = _27 + float3(1.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _31 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _669 = _27.zyx + 31.31999969482421875f.xxx;
    _669.x = dot(_27, _669);
    _27 += _669.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _31.x;
    _9.x = (_9.x * _332) + _27.x;
    _27.x = (-_9.x) + _83;
    _9.x = (_9.y * _27.x) + _9.x;
    _726.x = (-_9.x) + _49;
    _9.x = (_9.z * _726.x) + _9.x;
    float2 _750 = (_9.xx * float2(0.64999997615814208984375f, 0.60000002384185791015625f)) + _371.xy;
    _371 = float3(_750.x, _750.y, _371.z);
    _753 = _371.y + (-0.300000011920928955078125f);
    _371.x = (_371.x * 0.800000011920928955078125f) + 0.0500000007450580596923828125f;
    _371.x = (-_371.x) + _769.w;
    _371.x /= _16_m9;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 *= 2.5000002384185791015625f;
    _753 = clamp(_753, 0.0f, 1.0f);
    _791 = (_753 * (-2.0f)) + 3.0f;
    _753 *= _753;
    _753 *= _791;
    _753 = (_16_m10 * _753) + 0.119999997317790985107421875f;
    _753 = (-_371.x) + _753;
    _371.x = (_769.x * _753) + _371.x;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 = _371.x + (-0.0040000001899898052215576171875f);
    _831.w = _371.x * _16_m4.w;
    _842 = _753 < 0.0f;
    if ((int(_842) * (-1)) != 0)
    {
        discard;
    }
    _371 = _16_m4.xyz + (-_16_m5.xyz);
    _371 = (_9.xxx * _371) + _16_m5.xyz;
    _873 = (_371 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _879 = (_16_m6 * 10.0f) + 1.0f;
    _879 = exp2(_879);
    _9.x = dot(_16_m1.xyz, _16_m1.xyz);
    _726.x = rsqrt(_9.x);
    _900 = 9.9999999747524270787835121154785e-07f < _9.x;
    _726 = _726.xxx * _16_m1.xyz;
    float3 _913;
    if (_900)
    {
        _913 = _726;
    }
    else
    {
        _913 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_913.x, _913.y, _913.z, _9.w);
    _27 = (-vs_TEXCOORD0) + _16_m0;
    _49 = dot(_27, _27);
    _49 = rsqrt(_49);
    _31 = (_27 * _49.xxx) + _9.xyz;
    _27 = _49.xxx * _27;
    _49 = dot(_31, _31);
    _49 = rsqrt(_49);
    _31 = _49.xxx * _31;
    _49 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _49 = rsqrt(_49);
    _42 = _49.xxx * vs_TEXCOORD1;
    _49 = dot(_42, _31);
    _49 = clamp(_49, 0.0f, 1.0f);
    _49 = log2(_49);
    _49 *= _879;
    _49 = exp2(_49);
    _49 *= _16_m7;
    _980 = _49.xxx * _16_m3.xyz;
    _9.x = dot(_42, _9.xyz);
    _726.x = dot(_42, _27);
    _726.x = clamp(_726.x, 0.0f, 1.0f);
    _726.x = (-_726.x) + 1.0f;
    _9.x = (_9.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1016 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _1022 = (_16_m3.xyz * _9.xxx) + _1016;
    _371 = (_371 * _1022) + _980;
    _9.x = _726.x * _726.x;
    _9.x *= _9.x;
    _9.x *= _726.x;
    _9.x = (_9.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _980 = _9.xxx * _1016;
    _980 *= _16_m6.xxx;
    _980 *= 0.300000011920928955078125f.xxx;
    _371 = (_980 * _873) + _371;
    float3 _1085 = _371 + (-_16_m2.xyz);
    _9 = float4(_1085.x, _1085.y, _1085.z, _9.w);
    _49 = vs_TEXCOORD4;
    _49 = clamp(_49, 0.0f, 1.0f);
    float3 _1100 = (_49.xxx * _9.xyz) + _16_m2.xyz;
    _9 = float4(_1100.x, _1100.y, _1100.z, _9.w);
    _831 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _831.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _769 = stage_input._769;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._831 = _831;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD4;
static float3 _138;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _254;
static float4 _255;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _138 : NORMAL;
    float4 _255 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _254 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _158;
static float3 _180;
static float4 _197;
static float3 _203;

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
    vs_TEXCOORD2 = _11.xyz;
    _180.x = _9.y * _9.y;
    _180.x = (_9.x * _9.x) + (-_180.x);
    _197 = _9.yzzx * _9.xyzz;
    _203.x = dot(_21_m4, _197);
    _203.y = dot(_21_m5, _197);
    _203.z = dot(_21_m6, _197);
    _180 = (_21_m7.xyz * _180.xxx) + _203;
    _9.w = 1.0f;
    _203.x = dot(_21_m1, _9);
    _203.y = dot(_21_m2, _9);
    _203.z = dot(_21_m3, _9);
    _180 += _203;
    vs_TEXCOORD3 = max(_180, 0.0f.xxx);
    _254 = _255;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _255 = stage_input._255;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._254 = _254;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float4 _DeepColor;
float _Smoothness;
float _Specular;
float _NoiseScale;
float _EdgeSoftness;
float _CutCover;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m2 unity_FogColor
#define _16_m3 _LightColor0
#define _16_m4 _Color
#define _16_m5 _DeepColor
#define _16_m6 _Smoothness
#define _16_m7 _Specular
#define _16_m8 _NoiseScale
#define _16_m9 _EdgeSoftness
#define _16_m10 _CutCover



static float3 vs_TEXCOORD2;
static float4 _769;
static float4 _831;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _769 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _831 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _31;
static float3 _42;
static float _49;
static float _83;
static float3 _136;
static float _168;
static float _332;
static float3 _371;
static float3 _669;
static float3 _726;
static float _753;
static float _791;
static bool _842;
static float3 _873;
static float _879;
static bool _900;
static float3 _980;
static float3 _1016;
static float3 _1022;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD2 * _16_m8.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = floor(_9.xyz);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _49 = _31.z * _49;
    _49 = frac(_49);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 += (-_83);
    _31 = frac(_9.xyz);
    _42 = _31 * _31;
    _31 = ((-_31) * 2.0f.xxx) + 3.0f.xxx;
    _31 *= _42;
    _49 = (_31.x * _49) + _83;
    _42 = _27 + float3(1.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _49 += (-_83);
    _49 = (_31.y * _49) + _83;
    _42 = _27 + float3(1.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _42 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _42 = _27.zyx + 31.31999969482421875f.xxx;
    _42.x = dot(_27, _42);
    _27 += _42.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _168;
    _27.x = (_31.x * _332) + _27.x;
    _332 = (-_27.x) + _83;
    _27.x = (_31.y * _332) + _27.x;
    _49 += (-_27.x);
    _49 = (_31.z * _49) + _27.x;
    float2 _378 = _49.xx * float2(0.3499999940395355224609375f, 0.4000000059604644775390625f);
    _371 = float3(_378.x, _378.y, _371.z);
    _27 = (_9.xyz * 0.310000002384185791015625f.xxx) + 17.0f.xxx;
    float3 _391 = _9.xyz * 0.310000002384185791015625f.xxx;
    _9 = float4(_391.x, _391.y, _391.z, _9.w);
    _27 = floor(_27);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _9.w = _31.z * _49;
    _9 = frac(_9);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 = _9.w + (-_83);
    _31 = _9.xyz * _9.xyz;
    float3 _466 = ((-_9.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_466.x, _466.y, _466.z, _9.w);
    float3 _472 = _9.xyz * _31;
    _9 = float4(_472.x, _472.y, _472.z, _9.w);
    _49 = (_9.x * _49) + _83;
    _31 = _27 + float3(1.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _49 += (-_83);
    _49 = (_9.y * _49) + _83;
    _31 = _27 + float3(1.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _31 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _669 = _27.zyx + 31.31999969482421875f.xxx;
    _669.x = dot(_27, _669);
    _27 += _669.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _31.x;
    _9.x = (_9.x * _332) + _27.x;
    _27.x = (-_9.x) + _83;
    _9.x = (_9.y * _27.x) + _9.x;
    _726.x = (-_9.x) + _49;
    _9.x = (_9.z * _726.x) + _9.x;
    float2 _750 = (_9.xx * float2(0.64999997615814208984375f, 0.60000002384185791015625f)) + _371.xy;
    _371 = float3(_750.x, _750.y, _371.z);
    _753 = _371.y + (-0.300000011920928955078125f);
    _371.x = (_371.x * 0.800000011920928955078125f) + 0.0500000007450580596923828125f;
    _371.x = (-_371.x) + _769.w;
    _371.x /= _16_m9;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 *= 2.5000002384185791015625f;
    _753 = clamp(_753, 0.0f, 1.0f);
    _791 = (_753 * (-2.0f)) + 3.0f;
    _753 *= _753;
    _753 *= _791;
    _753 = (_16_m10 * _753) + 0.119999997317790985107421875f;
    _753 = (-_371.x) + _753;
    _371.x = (_769.x * _753) + _371.x;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 = _371.x + (-0.0040000001899898052215576171875f);
    _831.w = _371.x * _16_m4.w;
    _842 = _753 < 0.0f;
    if ((int(_842) * (-1)) != 0)
    {
        discard;
    }
    _371 = _16_m4.xyz + (-_16_m5.xyz);
    _371 = (_9.xxx * _371) + _16_m5.xyz;
    _873 = (_371 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _879 = (_16_m6 * 10.0f) + 1.0f;
    _879 = exp2(_879);
    _9.x = dot(_16_m1.xyz, _16_m1.xyz);
    _726.x = rsqrt(_9.x);
    _900 = 9.9999999747524270787835121154785e-07f < _9.x;
    _726 = _726.xxx * _16_m1.xyz;
    float3 _913;
    if (_900)
    {
        _913 = _726;
    }
    else
    {
        _913 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_913.x, _913.y, _913.z, _9.w);
    _27 = (-vs_TEXCOORD0) + _16_m0;
    _49 = dot(_27, _27);
    _49 = rsqrt(_49);
    _31 = (_27 * _49.xxx) + _9.xyz;
    _27 = _49.xxx * _27;
    _49 = dot(_31, _31);
    _49 = rsqrt(_49);
    _31 = _49.xxx * _31;
    _49 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _49 = rsqrt(_49);
    _42 = _49.xxx * vs_TEXCOORD1;
    _49 = dot(_42, _31);
    _49 = clamp(_49, 0.0f, 1.0f);
    _49 = log2(_49);
    _49 *= _879;
    _49 = exp2(_49);
    _49 *= _16_m7;
    _980 = _49.xxx * _16_m3.xyz;
    _9.x = dot(_42, _9.xyz);
    _726.x = dot(_42, _27);
    _726.x = clamp(_726.x, 0.0f, 1.0f);
    _726.x = (-_726.x) + 1.0f;
    _9.x = (_9.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1016 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _1022 = (_16_m3.xyz * _9.xxx) + _1016;
    _371 = (_371 * _1022) + _980;
    _9.x = _726.x * _726.x;
    _9.x *= _9.x;
    _9.x *= _726.x;
    _9.x = (_9.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _980 = _9.xxx * _1016;
    _980 *= _16_m6.xxx;
    _980 *= 0.300000011920928955078125f.xxx;
    _371 = (_980 * _873) + _371;
    float3 _1085 = _371 + (-_16_m2.xyz);
    _9 = float4(_1085.x, _1085.y, _1085.z, _9.w);
    _49 = vs_TEXCOORD4;
    _49 = clamp(_49, 0.0f, 1.0f);
    float3 _1100 = (_49.xxx * _9.xyz) + _16_m2.xyz;
    _9 = float4(_1100.x, _1100.y, _1100.z, _9.w);
    _831 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _831.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _769 = stage_input._769;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._831 = _831;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 _98;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _219;
static float4 _220;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _98 : NORMAL;
    float4 _220 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _219 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _121;
static float3 _143;
static float4 _160;
static float3 _166;

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
    vs_TEXCOORD2 = _11.xyz;
    _143.x = _9.y * _9.y;
    _143.x = (_9.x * _9.x) + (-_143.x);
    _160 = _9.yzzx * _9.xyzz;
    _166.x = dot(_21_m3, _160);
    _166.y = dot(_21_m4, _160);
    _166.z = dot(_21_m5, _160);
    _143 = (_21_m6.xyz * _143.xxx) + _166;
    _9.w = 1.0f;
    _166.x = dot(_21_m0, _9);
    _166.y = dot(_21_m1, _9);
    _166.z = dot(_21_m2, _9);
    _143 += _166;
    vs_TEXCOORD3 = max(_143, 0.0f.xxx);
    _219 = _220;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _98 = stage_input._98;
    _220 = stage_input._220;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._219 = _219;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float4 _DeepColor;
float _Smoothness;
float _Specular;
float _NoiseScale;
float _EdgeSoftness;
float _CutCover;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m2 _LightColor0
#define _16_m3 _Color
#define _16_m4 _DeepColor
#define _16_m5 _Smoothness
#define _16_m6 _Specular
#define _16_m7 _NoiseScale
#define _16_m8 _EdgeSoftness
#define _16_m9 _CutCover



static float3 vs_TEXCOORD2;
static float4 _769;
static float4 _831;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _769 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _831 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float3 _31;
static float3 _42;
static float _49;
static float _83;
static float3 _136;
static float _168;
static float _332;
static float3 _371;
static float3 _669;
static float3 _726;
static float _753;
static float _791;
static bool _842;
static float3 _873;
static float _879;
static bool _900;
static float3 _980;
static float3 _1016;
static float3 _1022;

void frag_inner()
{
    float3 _23 = vs_TEXCOORD2 * _16_m7.xxx;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = floor(_9.xyz);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _49 = _31.z * _49;
    _49 = frac(_49);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 += (-_83);
    _31 = frac(_9.xyz);
    _42 = _31 * _31;
    _31 = ((-_31) * 2.0f.xxx) + 3.0f.xxx;
    _31 *= _42;
    _49 = (_31.x * _49) + _83;
    _42 = _27 + float3(1.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 0.0f, 1.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _49 += (-_83);
    _49 = (_31.y * _49) + _83;
    _42 = _27 + float3(1.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_42, _136);
    _42 = _83.xxx + _42;
    _83 = _42.y + _42.x;
    _83 = _42.z * _83;
    _83 = frac(_83);
    _42 = _27 + float3(0.0f, 1.0f, 0.0f);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _83 += (-_168);
    _83 = (_31.x * _83) + _168;
    _42 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _42 *= 0.103100001811981201171875f.xxx;
    _42 = frac(_42);
    _136 = _42.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_42, _136);
    _42 = _168.xxx + _42;
    _168 = _42.y + _42.x;
    _168 = _42.z * _168;
    _168 = frac(_168);
    _42 = _27.zyx + 31.31999969482421875f.xxx;
    _42.x = dot(_27, _42);
    _27 += _42.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _168;
    _27.x = (_31.x * _332) + _27.x;
    _332 = (-_27.x) + _83;
    _27.x = (_31.y * _332) + _27.x;
    _49 += (-_27.x);
    _49 = (_31.z * _49) + _27.x;
    float2 _378 = _49.xx * float2(0.3499999940395355224609375f, 0.4000000059604644775390625f);
    _371 = float3(_378.x, _378.y, _371.z);
    _27 = (_9.xyz * 0.310000002384185791015625f.xxx) + 17.0f.xxx;
    float3 _391 = _9.xyz * 0.310000002384185791015625f.xxx;
    _9 = float4(_391.x, _391.y, _391.z, _9.w);
    _27 = floor(_27);
    _31 = _27 + 1.0f.xxx;
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _49 = dot(_31, _42);
    _31 = _49.xxx + _31;
    _49 = _31.y + _31.x;
    _9.w = _31.z * _49;
    _9 = frac(_9);
    _31 = _27 + float3(0.0f, 1.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _49 = _9.w + (-_83);
    _31 = _9.xyz * _9.xyz;
    float3 _466 = ((-_9.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _9 = float4(_466.x, _466.y, _466.z, _9.w);
    float3 _472 = _9.xyz * _31;
    _9 = float4(_472.x, _472.y, _472.z, _9.w);
    _49 = (_9.x * _49) + _83;
    _31 = _27 + float3(1.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 0.0f, 1.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _49 += (-_83);
    _49 = (_9.y * _49) + _83;
    _31 = _27 + float3(1.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _83 = dot(_31, _42);
    _31 = _83.xxx + _31;
    _83 = _31.y + _31.x;
    _83 = _31.z * _83;
    _83 = frac(_83);
    _31 = _27 + float3(0.0f, 1.0f, 0.0f);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _83 += (-_31.x);
    _83 = (_9.x * _83) + _31.x;
    _31 = _27 + float3(1.0f, 0.0f, 0.0f);
    _27 *= 0.103100001811981201171875f.xxx;
    _27 = frac(_27);
    _31 *= 0.103100001811981201171875f.xxx;
    _31 = frac(_31);
    _42 = _31.zyx + 31.31999969482421875f.xxx;
    _168 = dot(_31, _42);
    _31 = _168.xxx + _31;
    _31.x = _31.y + _31.x;
    _31.x = _31.z * _31.x;
    _31.x = frac(_31.x);
    _669 = _27.zyx + 31.31999969482421875f.xxx;
    _669.x = dot(_27, _669);
    _27 += _669.xxx;
    _27.x = _27.y + _27.x;
    _27.x = _27.z * _27.x;
    _27.x = frac(_27.x);
    _332 = (-_27.x) + _31.x;
    _9.x = (_9.x * _332) + _27.x;
    _27.x = (-_9.x) + _83;
    _9.x = (_9.y * _27.x) + _9.x;
    _726.x = (-_9.x) + _49;
    _9.x = (_9.z * _726.x) + _9.x;
    float2 _750 = (_9.xx * float2(0.64999997615814208984375f, 0.60000002384185791015625f)) + _371.xy;
    _371 = float3(_750.x, _750.y, _371.z);
    _753 = _371.y + (-0.300000011920928955078125f);
    _371.x = (_371.x * 0.800000011920928955078125f) + 0.0500000007450580596923828125f;
    _371.x = (-_371.x) + _769.w;
    _371.x /= _16_m8;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 *= 2.5000002384185791015625f;
    _753 = clamp(_753, 0.0f, 1.0f);
    _791 = (_753 * (-2.0f)) + 3.0f;
    _753 *= _753;
    _753 *= _791;
    _753 = (_16_m9 * _753) + 0.119999997317790985107421875f;
    _753 = (-_371.x) + _753;
    _371.x = (_769.x * _753) + _371.x;
    _371.x = clamp(_371.x, 0.0f, 1.0f);
    _753 = _371.x + (-0.0040000001899898052215576171875f);
    _831.w = _371.x * _16_m3.w;
    _842 = _753 < 0.0f;
    if ((int(_842) * (-1)) != 0)
    {
        discard;
    }
    _371 = _16_m3.xyz + (-_16_m4.xyz);
    _371 = (_9.xxx * _371) + _16_m4.xyz;
    _873 = (_371 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _879 = (_16_m5 * 10.0f) + 1.0f;
    _879 = exp2(_879);
    _9.x = dot(_16_m1.xyz, _16_m1.xyz);
    _726.x = rsqrt(_9.x);
    _900 = 9.9999999747524270787835121154785e-07f < _9.x;
    _726 = _726.xxx * _16_m1.xyz;
    float3 _913;
    if (_900)
    {
        _913 = _726;
    }
    else
    {
        _913 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_913.x, _913.y, _913.z, _9.w);
    _27 = (-vs_TEXCOORD0) + _16_m0;
    _49 = dot(_27, _27);
    _49 = rsqrt(_49);
    _31 = (_27 * _49.xxx) + _9.xyz;
    _27 = _49.xxx * _27;
    _49 = dot(_31, _31);
    _49 = rsqrt(_49);
    _31 = _49.xxx * _31;
    _49 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _49 = rsqrt(_49);
    _42 = _49.xxx * vs_TEXCOORD1;
    _49 = dot(_42, _31);
    _49 = clamp(_49, 0.0f, 1.0f);
    _49 = log2(_49);
    _49 *= _879;
    _49 = exp2(_49);
    _49 *= _16_m6;
    _980 = _49.xxx * _16_m2.xyz;
    _9.x = dot(_42, _9.xyz);
    _726.x = dot(_42, _27);
    _726.x = clamp(_726.x, 0.0f, 1.0f);
    _726.x = (-_726.x) + 1.0f;
    _9.x = (_9.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _1016 = max(vs_TEXCOORD3, 0.2199999988079071044921875f.xxx);
    _1022 = (_16_m2.xyz * _9.xxx) + _1016;
    _371 = (_371 * _1022) + _980;
    _9.x = _726.x * _726.x;
    _9.x *= _9.x;
    _9.x *= _726.x;
    _9.x = (_9.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _980 = _9.xxx * _1016;
    _980 *= _16_m5.xxx;
    _980 *= 0.300000011920928955078125f.xxx;
    float3 _1078 = (_980 * _873) + _371;
    _831 = float4(_1078.x, _1078.y, _1078.z, _831.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _769 = stage_input._769;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._831 = _831;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}