// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MimicMorph" {
Properties {

_MimicBaseMap ("Mimic Albedo", 2D) = "white" { }

_MimicNormalMap ("Mimic Normal", 2D) = "bump" { }

_MimicNormalScale ("Mimic Normal Scale", Float) = 1.0

_MimicTint ("Mimic Tint", Color) = (1,1,1,1)

_MainTex ("Ape Albedo", 2D) = "white" { }

_ColorMask ("Ape Color Mask", 2D) = "white" { }

_BumpMap ("Ape Normal", 2D) = "bump" { }

_Color ("Ape Colour", Color) = (1,1,1,1)

_Morph ("Morph", Range(0, 1)) = 0.0

_SweepTop ("Sweep Top", Float) = 1.7999999523162842

_SweepHeight ("Sweep Height", Float) = 1.2999999523162842

_NoiseScale ("Noise Scale", Float) = 9.0

_NoiseWeight ("Noise Weight", Range(0, 1)) = 0.3499999940395355

_BlendWidth ("Blend Width", Range(0.001, 0.1)) = 0.014999999664723873

_SeamWidth ("Seam Width", Range(0.02, 0.3)) = 0.07999999821186066

_SeamColor ("Seam Color", Color) = (4,0.3,0.1,1)

_VeinReach ("Vein Reach", Range(0.01, 0.6)) = 0.25

_VeinColor ("Vein Color", Color) = (1.5,0.05,0.02,1)

_BulgeAmount ("Bulge Amount", Float) = 0.019999999552965164

_BulgeScale ("Bulge Scale", Float) = 1.0

_FlashColor ("Flash Color", Color) = (3,0.2,0.1,1)

_Flash ("Flash", Range(0, 1)) = 0.0

[Toggle(_MIMIC_CLIP)] _ClipConverted ("Clip Converted", Float) = 0.0

[Toggle(BAKERY_VOLUME)] _BAKERY_VOLUME ("Use Bakery Volume", Float) = 1.0

_VolumeMin ("Volume Min", Vector) = (0,0,0,1)

_VolumeInvSize ("Volume Inv Size", Vector) = (1000000.0,1000000.0,1000000.0,1)

}
SubShader {
 LOD 250
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
 Name "MIMIC_MORPH"
  LOD 250
  Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ BAKERY_VOLUME
#pragma multi_compile_local __ _MIMIC_CLIP
#if defined(BAKERY_VOLUME) && defined(FOG_EXP) && defined(_MIMIC_CLIP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_WorldToObject;
static float4 _21_m3[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m5[4];
float4 unity_FogParams;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _ProjectionParams
#define _21_m4 unity_WorldTransformParams
#define _21_m6 unity_FogParams
#define _21_m7 _Morph
#define _21_m8 _SweepTop
#define _21_m9 _SweepHeight
#define _21_m10 _NoiseScale
#define _21_m11 _NoiseWeight
#define _21_m12 _SeamWidth
#define _21_m13 _BulgeAmount
#define _21_m14 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _595;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _595 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m10, _21_m10));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m2[1].xyz;
    _318 = (_21_m2[0].xyz * _320.xxx) + _318;
    _318 = (_21_m2[2].xyz * _320.zzz) + _318;
    _318 += _21_m2[3].xyz;
    _43.x = (-_318.y) + _21_m8;
    _93.x = max(_21_m9, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m11 * _9.x) + _43.x;
    _43.x = (_21_m12 * 2.0f) + 1.0f;
    _43.x = (_21_m7 * _43.x) + (-_21_m12);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m12;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m13 * _21_m14;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m3[0].xyz);
    _43.z = dot(_485, _21_m3[1].xyz);
    _43.x = dot(_485, _21_m3[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m5[1];
    _68 = (_21_m5[0] * _9.xxxx) + _68;
    _68 = (_21_m5[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    _9 = _68 + _21_m5[3];
    gl_Position = _9;
    _9.x = _9.z / _21_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m6.y;
    vs_TEXCOORD5 = exp2(-_9.x);
    vs_TEXCOORD0 = _12;
    float3 _601 = _595.yyy * _21_m2[1].yzx;
    _9 = float4(_601.x, _601.y, _601.z, _9.w);
    float3 _612 = (_21_m2[0].yzx * _595.xxx) + _9.xyz;
    _9 = float4(_612.x, _612.y, _612.z, _9.w);
    float3 _623 = (_21_m2[2].yzx * _595.zzz) + _9.xyz;
    _9 = float4(_623.x, _623.y, _623.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _637 = _89.xxx * _9.xyz;
    _9 = float4(_637.x, _637.y, _637.z, _9.w);
    float3 _643 = _9.xyz * _43;
    _68 = float4(_643.x, _643.y, _643.z, _68.w);
    float3 _654 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_654.x, _654.y, _654.z, _68.w);
    float3 _661 = _68.xyz * _595.www;
    _68 = float4(_661.x, _661.y, _661.z, _68.w);
    float3 _670 = _68.xyz * _21_m4.www;
    _68 = float4(_670.x, _670.y, _670.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _595 = stage_input._595;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_FogColor
#define _18_m3 _Morph
#define _18_m4 _SweepTop
#define _18_m5 _SweepHeight
#define _18_m6 _NoiseScale
#define _18_m7 _NoiseWeight
#define _18_m8 _BlendWidth
#define _18_m9 _SeamWidth
#define _18_m10 _LightColor0
#define _18_m11 _MimicNormalScale
#define _18_m12 _MimicTint
#define _18_m13 _Color
#define _18_m14 _SeamColor
#define _18_m15 _VeinReach
#define _18_m16 _VeinColor
#define _18_m17 _FlashColor
#define _18_m18 _Flash
#define _18_m19 _VolumeMin
#define _18_m20 _VolumeInvSize
#define _18_m21 _GlobalVolumeMin
#define _18_m22 _GlobalVolumeInvSize


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _1439;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1439 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _457;
static float _546;
static float _582;
static bool _592;
static float3 _677;
static float4 _691;
static float3 _707;
static bool _773;
static float3 _779;
static float4 _820;
static float4 _848;
static float3 _863;
static float3 _886;
static float2 _929;
static float3 _995;
static float _999;
static float _1005;
static bool _1216;
static float3 _1264;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m6, _18_m6, _18_m6, _18_m6));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m4;
    _37.x = max(_18_m5, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m7 * _9.x) + _325.x;
    _325.x = (_18_m9 * 2.0f) + 1.0f;
    _325.x = (_18_m3 * _325.x) + (-_18_m9);
    _37.x = _325.x + (-_18_m8);
    _88.x = _9.x + (-_37.x);
    _217 = _325.x + _18_m8;
    _37.x = (-_37.x) + _217;
    _37.x = 1.0f / _37.x;
    _37.x *= _88.x;
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _88.x = (_37.x * (-2.0f)) + 3.0f;
    _37.x *= _37.x;
    _37.x = ((-_88.x) * _37.x) + 1.0f;
    float2 _452 = (-_37.xx) + float2(0.5f, 1.0f);
    _88 = float3(_452.x, _88.y, _452.y);
    _457 = _88.x < 0.0f;
    if ((int(_457) * (-1)) != 0)
    {
        discard;
    }
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _88.x = sin(_88.x);
    _88.x *= 43758.546875f;
    _88.x = frac(_88.x);
    _44.x = (-_88.x) + _88.y;
    _88.x = (_9.z * _44.x) + _88.x;
    _44.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _44.x = sin(_44.x);
    _44.x *= 43758.546875f;
    _44.x = frac(_44.x);
    _44.x = (-_69.x) + _44.x;
    _546 = (_9.z * _44.x) + _69.x;
    _546 = (-_88.x) + _546;
    _546 = (_9.w * _546) + _88.x;
    _546 = (_546 * 2.0f) + (-1.0f);
    _546 = (-abs(_546)) + 0.199999988079071044921875f;
    _546 *= 5.882352352142333984375f;
    _546 = clamp(_546, 0.0f, 1.0f);
    _582 = (_546 * (-2.0f)) + 3.0f;
    _546 *= _546;
    _546 *= _582;
    _592 = _9.x >= _325.x;
    _9.x = (-_325.x) + _9.x;
    _325.x = float(_592);
    _9.w = _9.x / _18_m15;
    _9.x = abs(_9.x) / _18_m9;
    float2 _625 = (-_9.xw) + 1.0f.xx;
    _9 = float4(_625.x, _9.y, _9.z, _625.y);
    float2 _632 = clamp(_9.xw, 0.0f.xx, 1.0f.xx);
    _9 = float4(_632.x, _9.y, _9.z, _632.y);
    _9.x *= _9.x;
    _325.x *= _9.w;
    _582 = _18_m3 * 10.0f;
    _582 = clamp(_582, 0.0f, 1.0f);
    _325.x = _582 * _325.x;
    _325.x *= _546;
    _325.x = _88.z * _325.x;
    _325 = _325.xxx * _18_m16.xyz;
    _677 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _696 = (_677 * 2.0f.xxx) + (-1.0f).xxx;
    _691 = float4(_696.x, _696.y, _696.z, _691.w);
    _677 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _707 = (_677 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _717 = _707.xy * _18_m11.xx;
    _707 = float3(_717.x, _717.y, _707.z);
    _88 = _691.xyz + (-_707);
    _88 = (_37.xxx * _88) + _707;
    _69.x = dot(_88, _88);
    _69.x = rsqrt(_69.x);
    _88 *= _69.xxx;
    _69.x = dot(vs_TEXCOORD2, _88);
    _69.y = dot(vs_TEXCOORD3, _88);
    _69.z = dot(vs_TEXCOORD4, _88);
    _88.x = dot(_69.xyz, _69.xyz);
    _88.x = rsqrt(_88.x);
    _88 = _88.xxx * _69.xyz;
    _773 = 1000000.0f < _18_m20.x;
    float3 _782;
    if (_773)
    {
        _782 = _18_m21;
    }
    else
    {
        _782 = _18_m19;
    }
    _779 = _782;
    float3 _795;
    if (_773)
    {
        _795 = _18_m22;
    }
    else
    {
        _795 = _18_m20;
    }
    _192 = float4(_795.x, _795.y, _795.z, _192.w);
    float3 _810 = (-_779) + vs_TEXCOORD1;
    _69 = float4(_810.x, _810.y, _810.z, _69.w);
    float3 _817 = _192.xyz * _69.xyz;
    _69 = float4(_817.x, _817.y, _817.z, _69.w);
    _820 = _Volume0.Sample(sampler_Volume0, _69.xyz).xywz;
    float3 _837 = max(_820.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _251 = float4(_837.x, _837.y, _837.z, _251.w);
    _691 = _Volume1.Sample(sampler_Volume0, _69.xyz).yxwz;
    _848 = _Volume2.Sample(sampler_Volume0, _69.xyz).xzwy;
    _820.x = _691.y;
    _820.y = _848.x;
    _863 = (_820.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    float3 _873 = _820.xyz * 0.5f.xxx;
    _192 = float4(_873.x, _873.y, _873.z, _192.w);
    _192.x = dot(_192.xyz, _192.xyz);
    _192.x = sqrt(_192.x);
    _886.x = dot(_863, _863);
    _886.x = rsqrt(_886.x);
    _886 = _886.xxx * _863;
    _886.x = dot(_886, _88);
    _886.x = (_886.x * 0.5f) + 0.5f;
    _886.x = clamp(_886.x, 0.0f, 1.0f);
    _886.x = log2(_886.x);
    _192.z = _192.x + _192.x;
    float2 _926 = _192.xz / _251.xx;
    _192 = float4(_926.x, _192.y, _926.y, _192.w);
    _929 = _192.zz + float2(1.0f, 2.0f);
    _886.x *= _929.x;
    _886.x = exp2(_886.x);
    _929.x = (-_192.x) + 1.0f;
    _192.x += 1.0f;
    _192.x = _929.x / _192.x;
    _929.x = (-_192.x) + 1.0f;
    _929.x = _929.y * _929.x;
    _192.x = (_929.x * _886.x) + _192.x;
    _192.x *= _251.x;
    _848.x = _691.w;
    _691.y = _848.w;
    _863 = (_691.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _995 = _691.xyz * 0.5f.xxx;
    _999 = dot(_995, _995);
    _999 = sqrt(_999);
    _1005 = dot(_863, _863);
    _1005 = rsqrt(_1005);
    _863 = _1005.xxx * _863;
    _1005 = dot(_863, _88);
    _1005 = (_1005 * 0.5f) + 0.5f;
    _1005 = clamp(_1005, 0.0f, 1.0f);
    _1005 = log2(_1005);
    _251.x = _999 + _999;
    _999 /= _251.y;
    _251.x /= _251.y;
    float2 _1041 = _251.xx + float2(1.0f, 2.0f);
    _251 = float4(_1041.x, _251.y, _251.z, _1041.y);
    _1005 *= _251.x;
    _1005 = exp2(_1005);
    _251.x = (-_999) + 1.0f;
    _999 += 1.0f;
    _999 = _251.x / _999;
    _251.x = (-_999) + 1.0f;
    _251.x = _251.w * _251.x;
    _999 = (_251.x * _1005) + _999;
    _192.y = _999 * _251.y;
    float3 _1084 = (_848.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _251 = float4(_1084.x, _1084.y, _251.z, _1084.z);
    float3 _1089 = _848.xyz * 0.5f.xxx;
    _69 = float4(_1089.x, _1089.y, _1089.z, _69.w);
    _69.x = dot(_69.xyz, _69.xyz);
    _69.x = sqrt(_69.x);
    _779.x = dot(_251.xyw, _251.xyw);
    _779.x = rsqrt(_779.x);
    _779 = _779.xxx * _251.xyw;
    _779.x = dot(_779, _88);
    _779.x = (_779.x * 0.5f) + 0.5f;
    _779.x = clamp(_779.x, 0.0f, 1.0f);
    _779.x = log2(_779.x);
    _69.z = _69.x + _69.x;
    float2 _1144 = _69.xz / _251.zz;
    _69 = float4(_1144.x, _69.y, _1144.y, _69.w);
    _130 = _69.zz + float2(1.0f, 2.0f);
    _779.x *= _130.x;
    _779.x = exp2(_779.x);
    _130.x = (-_69.x) + 1.0f;
    _69.x += 1.0f;
    _69.x = _130.x / _69.x;
    _130.x = (-_69.x) + 1.0f;
    _130.x = _130.y * _130.x;
    _69.x = (_130.x * _779.x) + _69.x;
    _192.z = _69.x * _251.z;
    float3 _1204 = max(_192.xyz, 0.0f.xxx);
    _69 = float4(_1204.x, _1204.y, _1204.z, _69.w);
    _999 = dot(_18_m1.xyz, _18_m1.xyz);
    _999 = sqrt(_999);
    _1216 = 9.9999997473787516355514526367188e-05f < _999;
    _886 = _18_m1.xyz / _999.xxx;
    float3 _1227;
    if (_1216)
    {
        _1227 = _886;
    }
    else
    {
        _1227 = float3(0.0f, 1.0f, 0.0f);
    }
    _192 = float4(_1227.x, _1227.y, _1227.z, _192.w);
    _88.x = dot(_88, _192.xyz);
    _88.x = clamp(_88.x, 0.0f, 1.0f);
    _707 = (_18_m10.xyz * _88.xxx) + _69.xyz;
    _677.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _1264 = _18_m13.xyz + (-1.0f).xxx;
    _1264 = (_677.xxx * _1264) + 1.0f.xxx;
    _677 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _1291 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    _848 = float4(_1291.x, _1291.y, _1291.z, _848.w);
    float3 _1300 = _848.xyz * _18_m12.xyz;
    _69 = float4(_1300.x, _1300.y, _1300.z, _69.w);
    _88 = (_677 * _1264) + (-_69.xyz);
    float3 _1316 = (_37.xxx * _88) + _69.xyz;
    _37 = float4(_1316.x, _1316.y, _1316.z, _37.w);
    _325 = (_37.xyz * _707) + _325;
    float3 _1333 = (_18_m14.xyz * _9.xxx) + _325;
    _9 = float4(_1333.x, _1333.y, _1333.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _582 = dot(_37.xyz, _37.xyz);
    _582 = rsqrt(_582);
    float3 _1356 = _582.xxx * _37.xyz;
    _37 = float4(_1356.x, _1356.y, _1356.z, _37.w);
    float3 _1363 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_1363.x, _1363.y, _1363.z, _69.w);
    _582 = dot(_69.xyz, _69.xyz);
    _582 = rsqrt(_582);
    float3 _1377 = _582.xxx * _69.xyz;
    _69 = float4(_1377.x, _1377.y, _1377.z, _69.w);
    _582 = dot(_37.xyz, _69.xyz);
    _582 = clamp(_582, 0.0f, 1.0f);
    _582 = (-_582) + 1.0f;
    _582 *= _582;
    _582 = (_582 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _582 *= _18_m18;
    float3 _1410 = (_18_m17.xyz * _582.xxx) + _9.xyz;
    _9 = float4(_1410.x, _1410.y, _1410.z, _9.w);
    float3 _1420 = _9.xyz + (-_18_m2.xyz);
    _9 = float4(_1420.x, _1420.y, _1420.z, _9.w);
    _582 = vs_TEXCOORD5;
    _582 = clamp(_582, 0.0f, 1.0f);
    float3 _1435 = (_582.xxx * _9.xyz) + _18_m2.xyz;
    _9 = float4(_1435.x, _1435.y, _1435.z, _9.w);
    _1439 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1439.w);
    _1439.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1439 = _1439;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP2) && defined(_MIMIC_CLIP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_WorldToObject;
static float4 _21_m3[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m5[4];
float4 unity_FogParams;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _ProjectionParams
#define _21_m4 unity_WorldTransformParams
#define _21_m6 unity_FogParams
#define _21_m7 _Morph
#define _21_m8 _SweepTop
#define _21_m9 _SweepHeight
#define _21_m10 _NoiseScale
#define _21_m11 _NoiseWeight
#define _21_m12 _SeamWidth
#define _21_m13 _BulgeAmount
#define _21_m14 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _601;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _601 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m10, _21_m10));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m2[1].xyz;
    _318 = (_21_m2[0].xyz * _320.xxx) + _318;
    _318 = (_21_m2[2].xyz * _320.zzz) + _318;
    _318 += _21_m2[3].xyz;
    _43.x = (-_318.y) + _21_m8;
    _93.x = max(_21_m9, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m11 * _9.x) + _43.x;
    _43.x = (_21_m12 * 2.0f) + 1.0f;
    _43.x = (_21_m7 * _43.x) + (-_21_m12);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m12;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m13 * _21_m14;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m3[0].xyz);
    _43.z = dot(_485, _21_m3[1].xyz);
    _43.x = dot(_485, _21_m3[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m5[1];
    _68 = (_21_m5[0] * _9.xxxx) + _68;
    _68 = (_21_m5[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    _9 = _68 + _21_m5[3];
    gl_Position = _9;
    _9.x = _9.z / _21_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m6.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD5 = exp2(_9.x);
    vs_TEXCOORD0 = _12;
    float3 _607 = _601.yyy * _21_m2[1].yzx;
    _9 = float4(_607.x, _607.y, _607.z, _9.w);
    float3 _618 = (_21_m2[0].yzx * _601.xxx) + _9.xyz;
    _9 = float4(_618.x, _618.y, _618.z, _9.w);
    float3 _629 = (_21_m2[2].yzx * _601.zzz) + _9.xyz;
    _9 = float4(_629.x, _629.y, _629.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _643 = _89.xxx * _9.xyz;
    _9 = float4(_643.x, _643.y, _643.z, _9.w);
    float3 _649 = _9.xyz * _43;
    _68 = float4(_649.x, _649.y, _649.z, _68.w);
    float3 _660 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_660.x, _660.y, _660.z, _68.w);
    float3 _667 = _68.xyz * _601.www;
    _68 = float4(_667.x, _667.y, _667.z, _68.w);
    float3 _676 = _68.xyz * _21_m4.www;
    _68 = float4(_676.x, _676.y, _676.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _601 = stage_input._601;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_FogColor
#define _18_m3 _Morph
#define _18_m4 _SweepTop
#define _18_m5 _SweepHeight
#define _18_m6 _NoiseScale
#define _18_m7 _NoiseWeight
#define _18_m8 _BlendWidth
#define _18_m9 _SeamWidth
#define _18_m10 _LightColor0
#define _18_m11 _MimicNormalScale
#define _18_m12 _MimicTint
#define _18_m13 _Color
#define _18_m14 _SeamColor
#define _18_m15 _VeinReach
#define _18_m16 _VeinColor
#define _18_m17 _FlashColor
#define _18_m18 _Flash
#define _18_m19 _VolumeMin
#define _18_m20 _VolumeInvSize
#define _18_m21 _GlobalVolumeMin
#define _18_m22 _GlobalVolumeInvSize


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _1439;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1439 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _457;
static float _546;
static float _582;
static bool _592;
static float3 _677;
static float4 _691;
static float3 _707;
static bool _773;
static float3 _779;
static float4 _820;
static float4 _848;
static float3 _863;
static float3 _886;
static float2 _929;
static float3 _995;
static float _999;
static float _1005;
static bool _1216;
static float3 _1264;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m6, _18_m6, _18_m6, _18_m6));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m4;
    _37.x = max(_18_m5, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m7 * _9.x) + _325.x;
    _325.x = (_18_m9 * 2.0f) + 1.0f;
    _325.x = (_18_m3 * _325.x) + (-_18_m9);
    _37.x = _325.x + (-_18_m8);
    _88.x = _9.x + (-_37.x);
    _217 = _325.x + _18_m8;
    _37.x = (-_37.x) + _217;
    _37.x = 1.0f / _37.x;
    _37.x *= _88.x;
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _88.x = (_37.x * (-2.0f)) + 3.0f;
    _37.x *= _37.x;
    _37.x = ((-_88.x) * _37.x) + 1.0f;
    float2 _452 = (-_37.xx) + float2(0.5f, 1.0f);
    _88 = float3(_452.x, _88.y, _452.y);
    _457 = _88.x < 0.0f;
    if ((int(_457) * (-1)) != 0)
    {
        discard;
    }
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _88.x = sin(_88.x);
    _88.x *= 43758.546875f;
    _88.x = frac(_88.x);
    _44.x = (-_88.x) + _88.y;
    _88.x = (_9.z * _44.x) + _88.x;
    _44.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _44.x = sin(_44.x);
    _44.x *= 43758.546875f;
    _44.x = frac(_44.x);
    _44.x = (-_69.x) + _44.x;
    _546 = (_9.z * _44.x) + _69.x;
    _546 = (-_88.x) + _546;
    _546 = (_9.w * _546) + _88.x;
    _546 = (_546 * 2.0f) + (-1.0f);
    _546 = (-abs(_546)) + 0.199999988079071044921875f;
    _546 *= 5.882352352142333984375f;
    _546 = clamp(_546, 0.0f, 1.0f);
    _582 = (_546 * (-2.0f)) + 3.0f;
    _546 *= _546;
    _546 *= _582;
    _592 = _9.x >= _325.x;
    _9.x = (-_325.x) + _9.x;
    _325.x = float(_592);
    _9.w = _9.x / _18_m15;
    _9.x = abs(_9.x) / _18_m9;
    float2 _625 = (-_9.xw) + 1.0f.xx;
    _9 = float4(_625.x, _9.y, _9.z, _625.y);
    float2 _632 = clamp(_9.xw, 0.0f.xx, 1.0f.xx);
    _9 = float4(_632.x, _9.y, _9.z, _632.y);
    _9.x *= _9.x;
    _325.x *= _9.w;
    _582 = _18_m3 * 10.0f;
    _582 = clamp(_582, 0.0f, 1.0f);
    _325.x = _582 * _325.x;
    _325.x *= _546;
    _325.x = _88.z * _325.x;
    _325 = _325.xxx * _18_m16.xyz;
    _677 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _696 = (_677 * 2.0f.xxx) + (-1.0f).xxx;
    _691 = float4(_696.x, _696.y, _696.z, _691.w);
    _677 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _707 = (_677 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _717 = _707.xy * _18_m11.xx;
    _707 = float3(_717.x, _717.y, _707.z);
    _88 = _691.xyz + (-_707);
    _88 = (_37.xxx * _88) + _707;
    _69.x = dot(_88, _88);
    _69.x = rsqrt(_69.x);
    _88 *= _69.xxx;
    _69.x = dot(vs_TEXCOORD2, _88);
    _69.y = dot(vs_TEXCOORD3, _88);
    _69.z = dot(vs_TEXCOORD4, _88);
    _88.x = dot(_69.xyz, _69.xyz);
    _88.x = rsqrt(_88.x);
    _88 = _88.xxx * _69.xyz;
    _773 = 1000000.0f < _18_m20.x;
    float3 _782;
    if (_773)
    {
        _782 = _18_m21;
    }
    else
    {
        _782 = _18_m19;
    }
    _779 = _782;
    float3 _795;
    if (_773)
    {
        _795 = _18_m22;
    }
    else
    {
        _795 = _18_m20;
    }
    _192 = float4(_795.x, _795.y, _795.z, _192.w);
    float3 _810 = (-_779) + vs_TEXCOORD1;
    _69 = float4(_810.x, _810.y, _810.z, _69.w);
    float3 _817 = _192.xyz * _69.xyz;
    _69 = float4(_817.x, _817.y, _817.z, _69.w);
    _820 = _Volume0.Sample(sampler_Volume0, _69.xyz).xywz;
    float3 _837 = max(_820.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _251 = float4(_837.x, _837.y, _837.z, _251.w);
    _691 = _Volume1.Sample(sampler_Volume0, _69.xyz).yxwz;
    _848 = _Volume2.Sample(sampler_Volume0, _69.xyz).xzwy;
    _820.x = _691.y;
    _820.y = _848.x;
    _863 = (_820.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    float3 _873 = _820.xyz * 0.5f.xxx;
    _192 = float4(_873.x, _873.y, _873.z, _192.w);
    _192.x = dot(_192.xyz, _192.xyz);
    _192.x = sqrt(_192.x);
    _886.x = dot(_863, _863);
    _886.x = rsqrt(_886.x);
    _886 = _886.xxx * _863;
    _886.x = dot(_886, _88);
    _886.x = (_886.x * 0.5f) + 0.5f;
    _886.x = clamp(_886.x, 0.0f, 1.0f);
    _886.x = log2(_886.x);
    _192.z = _192.x + _192.x;
    float2 _926 = _192.xz / _251.xx;
    _192 = float4(_926.x, _192.y, _926.y, _192.w);
    _929 = _192.zz + float2(1.0f, 2.0f);
    _886.x *= _929.x;
    _886.x = exp2(_886.x);
    _929.x = (-_192.x) + 1.0f;
    _192.x += 1.0f;
    _192.x = _929.x / _192.x;
    _929.x = (-_192.x) + 1.0f;
    _929.x = _929.y * _929.x;
    _192.x = (_929.x * _886.x) + _192.x;
    _192.x *= _251.x;
    _848.x = _691.w;
    _691.y = _848.w;
    _863 = (_691.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _995 = _691.xyz * 0.5f.xxx;
    _999 = dot(_995, _995);
    _999 = sqrt(_999);
    _1005 = dot(_863, _863);
    _1005 = rsqrt(_1005);
    _863 = _1005.xxx * _863;
    _1005 = dot(_863, _88);
    _1005 = (_1005 * 0.5f) + 0.5f;
    _1005 = clamp(_1005, 0.0f, 1.0f);
    _1005 = log2(_1005);
    _251.x = _999 + _999;
    _999 /= _251.y;
    _251.x /= _251.y;
    float2 _1041 = _251.xx + float2(1.0f, 2.0f);
    _251 = float4(_1041.x, _251.y, _251.z, _1041.y);
    _1005 *= _251.x;
    _1005 = exp2(_1005);
    _251.x = (-_999) + 1.0f;
    _999 += 1.0f;
    _999 = _251.x / _999;
    _251.x = (-_999) + 1.0f;
    _251.x = _251.w * _251.x;
    _999 = (_251.x * _1005) + _999;
    _192.y = _999 * _251.y;
    float3 _1084 = (_848.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _251 = float4(_1084.x, _1084.y, _251.z, _1084.z);
    float3 _1089 = _848.xyz * 0.5f.xxx;
    _69 = float4(_1089.x, _1089.y, _1089.z, _69.w);
    _69.x = dot(_69.xyz, _69.xyz);
    _69.x = sqrt(_69.x);
    _779.x = dot(_251.xyw, _251.xyw);
    _779.x = rsqrt(_779.x);
    _779 = _779.xxx * _251.xyw;
    _779.x = dot(_779, _88);
    _779.x = (_779.x * 0.5f) + 0.5f;
    _779.x = clamp(_779.x, 0.0f, 1.0f);
    _779.x = log2(_779.x);
    _69.z = _69.x + _69.x;
    float2 _1144 = _69.xz / _251.zz;
    _69 = float4(_1144.x, _69.y, _1144.y, _69.w);
    _130 = _69.zz + float2(1.0f, 2.0f);
    _779.x *= _130.x;
    _779.x = exp2(_779.x);
    _130.x = (-_69.x) + 1.0f;
    _69.x += 1.0f;
    _69.x = _130.x / _69.x;
    _130.x = (-_69.x) + 1.0f;
    _130.x = _130.y * _130.x;
    _69.x = (_130.x * _779.x) + _69.x;
    _192.z = _69.x * _251.z;
    float3 _1204 = max(_192.xyz, 0.0f.xxx);
    _69 = float4(_1204.x, _1204.y, _1204.z, _69.w);
    _999 = dot(_18_m1.xyz, _18_m1.xyz);
    _999 = sqrt(_999);
    _1216 = 9.9999997473787516355514526367188e-05f < _999;
    _886 = _18_m1.xyz / _999.xxx;
    float3 _1227;
    if (_1216)
    {
        _1227 = _886;
    }
    else
    {
        _1227 = float3(0.0f, 1.0f, 0.0f);
    }
    _192 = float4(_1227.x, _1227.y, _1227.z, _192.w);
    _88.x = dot(_88, _192.xyz);
    _88.x = clamp(_88.x, 0.0f, 1.0f);
    _707 = (_18_m10.xyz * _88.xxx) + _69.xyz;
    _677.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _1264 = _18_m13.xyz + (-1.0f).xxx;
    _1264 = (_677.xxx * _1264) + 1.0f.xxx;
    _677 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _1291 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    _848 = float4(_1291.x, _1291.y, _1291.z, _848.w);
    float3 _1300 = _848.xyz * _18_m12.xyz;
    _69 = float4(_1300.x, _1300.y, _1300.z, _69.w);
    _88 = (_677 * _1264) + (-_69.xyz);
    float3 _1316 = (_37.xxx * _88) + _69.xyz;
    _37 = float4(_1316.x, _1316.y, _1316.z, _37.w);
    _325 = (_37.xyz * _707) + _325;
    float3 _1333 = (_18_m14.xyz * _9.xxx) + _325;
    _9 = float4(_1333.x, _1333.y, _1333.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _582 = dot(_37.xyz, _37.xyz);
    _582 = rsqrt(_582);
    float3 _1356 = _582.xxx * _37.xyz;
    _37 = float4(_1356.x, _1356.y, _1356.z, _37.w);
    float3 _1363 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_1363.x, _1363.y, _1363.z, _69.w);
    _582 = dot(_69.xyz, _69.xyz);
    _582 = rsqrt(_582);
    float3 _1377 = _582.xxx * _69.xyz;
    _69 = float4(_1377.x, _1377.y, _1377.z, _69.w);
    _582 = dot(_37.xyz, _69.xyz);
    _582 = clamp(_582, 0.0f, 1.0f);
    _582 = (-_582) + 1.0f;
    _582 *= _582;
    _582 = (_582 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _582 *= _18_m18;
    float3 _1410 = (_18_m17.xyz * _582.xxx) + _9.xyz;
    _9 = float4(_1410.x, _1410.y, _1410.z, _9.w);
    float3 _1420 = _9.xyz + (-_18_m2.xyz);
    _9 = float4(_1420.x, _1420.y, _1420.z, _9.w);
    _582 = vs_TEXCOORD5;
    _582 = clamp(_582, 0.0f, 1.0f);
    float3 _1435 = (_582.xxx * _9.xyz) + _18_m2.xyz;
    _9 = float4(_1435.x, _1435.y, _1435.z, _9.w);
    _1439 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1439.w);
    _1439.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1439 = _1439;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_LINEAR) && defined(_MIMIC_CLIP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_WorldToObject;
static float4 _21_m3[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m5[4];
float4 unity_FogParams;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _ProjectionParams
#define _21_m4 unity_WorldTransformParams
#define _21_m6 unity_FogParams
#define _21_m7 _Morph
#define _21_m8 _SweepTop
#define _21_m9 _SweepHeight
#define _21_m10 _NoiseScale
#define _21_m11 _NoiseWeight
#define _21_m12 _SeamWidth
#define _21_m13 _BulgeAmount
#define _21_m14 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _593;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _593 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m10, _21_m10));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m2[1].xyz;
    _318 = (_21_m2[0].xyz * _320.xxx) + _318;
    _318 = (_21_m2[2].xyz * _320.zzz) + _318;
    _318 += _21_m2[3].xyz;
    _43.x = (-_318.y) + _21_m8;
    _93.x = max(_21_m9, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m11 * _9.x) + _43.x;
    _43.x = (_21_m12 * 2.0f) + 1.0f;
    _43.x = (_21_m7 * _43.x) + (-_21_m12);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m12;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m13 * _21_m14;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m3[0].xyz);
    _43.z = dot(_485, _21_m3[1].xyz);
    _43.x = dot(_485, _21_m3[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m5[1];
    _68 = (_21_m5[0] * _9.xxxx) + _68;
    _68 = (_21_m5[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    _9 = _68 + _21_m5[3];
    gl_Position = _9;
    _9.x = _9.z / _21_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD5 = (_9.x * _21_m6.z) + _21_m6.w;
    vs_TEXCOORD0 = _12;
    float3 _599 = _593.yyy * _21_m2[1].yzx;
    _9 = float4(_599.x, _599.y, _599.z, _9.w);
    float3 _610 = (_21_m2[0].yzx * _593.xxx) + _9.xyz;
    _9 = float4(_610.x, _610.y, _610.z, _9.w);
    float3 _621 = (_21_m2[2].yzx * _593.zzz) + _9.xyz;
    _9 = float4(_621.x, _621.y, _621.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _635 = _89.xxx * _9.xyz;
    _9 = float4(_635.x, _635.y, _635.z, _9.w);
    float3 _641 = _9.xyz * _43;
    _68 = float4(_641.x, _641.y, _641.z, _68.w);
    float3 _652 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_652.x, _652.y, _652.z, _68.w);
    float3 _659 = _68.xyz * _593.www;
    _68 = float4(_659.x, _659.y, _659.z, _68.w);
    float3 _668 = _68.xyz * _21_m4.www;
    _68 = float4(_668.x, _668.y, _668.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _593 = stage_input._593;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_FogColor
#define _18_m3 _Morph
#define _18_m4 _SweepTop
#define _18_m5 _SweepHeight
#define _18_m6 _NoiseScale
#define _18_m7 _NoiseWeight
#define _18_m8 _BlendWidth
#define _18_m9 _SeamWidth
#define _18_m10 _LightColor0
#define _18_m11 _MimicNormalScale
#define _18_m12 _MimicTint
#define _18_m13 _Color
#define _18_m14 _SeamColor
#define _18_m15 _VeinReach
#define _18_m16 _VeinColor
#define _18_m17 _FlashColor
#define _18_m18 _Flash
#define _18_m19 _VolumeMin
#define _18_m20 _VolumeInvSize
#define _18_m21 _GlobalVolumeMin
#define _18_m22 _GlobalVolumeInvSize


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _1439;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1439 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _457;
static float _546;
static float _582;
static bool _592;
static float3 _677;
static float4 _691;
static float3 _707;
static bool _773;
static float3 _779;
static float4 _820;
static float4 _848;
static float3 _863;
static float3 _886;
static float2 _929;
static float3 _995;
static float _999;
static float _1005;
static bool _1216;
static float3 _1264;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m6, _18_m6, _18_m6, _18_m6));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m4;
    _37.x = max(_18_m5, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m7 * _9.x) + _325.x;
    _325.x = (_18_m9 * 2.0f) + 1.0f;
    _325.x = (_18_m3 * _325.x) + (-_18_m9);
    _37.x = _325.x + (-_18_m8);
    _88.x = _9.x + (-_37.x);
    _217 = _325.x + _18_m8;
    _37.x = (-_37.x) + _217;
    _37.x = 1.0f / _37.x;
    _37.x *= _88.x;
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _88.x = (_37.x * (-2.0f)) + 3.0f;
    _37.x *= _37.x;
    _37.x = ((-_88.x) * _37.x) + 1.0f;
    float2 _452 = (-_37.xx) + float2(0.5f, 1.0f);
    _88 = float3(_452.x, _88.y, _452.y);
    _457 = _88.x < 0.0f;
    if ((int(_457) * (-1)) != 0)
    {
        discard;
    }
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _88.x = sin(_88.x);
    _88.x *= 43758.546875f;
    _88.x = frac(_88.x);
    _44.x = (-_88.x) + _88.y;
    _88.x = (_9.z * _44.x) + _88.x;
    _44.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _44.x = sin(_44.x);
    _44.x *= 43758.546875f;
    _44.x = frac(_44.x);
    _44.x = (-_69.x) + _44.x;
    _546 = (_9.z * _44.x) + _69.x;
    _546 = (-_88.x) + _546;
    _546 = (_9.w * _546) + _88.x;
    _546 = (_546 * 2.0f) + (-1.0f);
    _546 = (-abs(_546)) + 0.199999988079071044921875f;
    _546 *= 5.882352352142333984375f;
    _546 = clamp(_546, 0.0f, 1.0f);
    _582 = (_546 * (-2.0f)) + 3.0f;
    _546 *= _546;
    _546 *= _582;
    _592 = _9.x >= _325.x;
    _9.x = (-_325.x) + _9.x;
    _325.x = float(_592);
    _9.w = _9.x / _18_m15;
    _9.x = abs(_9.x) / _18_m9;
    float2 _625 = (-_9.xw) + 1.0f.xx;
    _9 = float4(_625.x, _9.y, _9.z, _625.y);
    float2 _632 = clamp(_9.xw, 0.0f.xx, 1.0f.xx);
    _9 = float4(_632.x, _9.y, _9.z, _632.y);
    _9.x *= _9.x;
    _325.x *= _9.w;
    _582 = _18_m3 * 10.0f;
    _582 = clamp(_582, 0.0f, 1.0f);
    _325.x = _582 * _325.x;
    _325.x *= _546;
    _325.x = _88.z * _325.x;
    _325 = _325.xxx * _18_m16.xyz;
    _677 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _696 = (_677 * 2.0f.xxx) + (-1.0f).xxx;
    _691 = float4(_696.x, _696.y, _696.z, _691.w);
    _677 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _707 = (_677 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _717 = _707.xy * _18_m11.xx;
    _707 = float3(_717.x, _717.y, _707.z);
    _88 = _691.xyz + (-_707);
    _88 = (_37.xxx * _88) + _707;
    _69.x = dot(_88, _88);
    _69.x = rsqrt(_69.x);
    _88 *= _69.xxx;
    _69.x = dot(vs_TEXCOORD2, _88);
    _69.y = dot(vs_TEXCOORD3, _88);
    _69.z = dot(vs_TEXCOORD4, _88);
    _88.x = dot(_69.xyz, _69.xyz);
    _88.x = rsqrt(_88.x);
    _88 = _88.xxx * _69.xyz;
    _773 = 1000000.0f < _18_m20.x;
    float3 _782;
    if (_773)
    {
        _782 = _18_m21;
    }
    else
    {
        _782 = _18_m19;
    }
    _779 = _782;
    float3 _795;
    if (_773)
    {
        _795 = _18_m22;
    }
    else
    {
        _795 = _18_m20;
    }
    _192 = float4(_795.x, _795.y, _795.z, _192.w);
    float3 _810 = (-_779) + vs_TEXCOORD1;
    _69 = float4(_810.x, _810.y, _810.z, _69.w);
    float3 _817 = _192.xyz * _69.xyz;
    _69 = float4(_817.x, _817.y, _817.z, _69.w);
    _820 = _Volume0.Sample(sampler_Volume0, _69.xyz).xywz;
    float3 _837 = max(_820.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _251 = float4(_837.x, _837.y, _837.z, _251.w);
    _691 = _Volume1.Sample(sampler_Volume0, _69.xyz).yxwz;
    _848 = _Volume2.Sample(sampler_Volume0, _69.xyz).xzwy;
    _820.x = _691.y;
    _820.y = _848.x;
    _863 = (_820.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    float3 _873 = _820.xyz * 0.5f.xxx;
    _192 = float4(_873.x, _873.y, _873.z, _192.w);
    _192.x = dot(_192.xyz, _192.xyz);
    _192.x = sqrt(_192.x);
    _886.x = dot(_863, _863);
    _886.x = rsqrt(_886.x);
    _886 = _886.xxx * _863;
    _886.x = dot(_886, _88);
    _886.x = (_886.x * 0.5f) + 0.5f;
    _886.x = clamp(_886.x, 0.0f, 1.0f);
    _886.x = log2(_886.x);
    _192.z = _192.x + _192.x;
    float2 _926 = _192.xz / _251.xx;
    _192 = float4(_926.x, _192.y, _926.y, _192.w);
    _929 = _192.zz + float2(1.0f, 2.0f);
    _886.x *= _929.x;
    _886.x = exp2(_886.x);
    _929.x = (-_192.x) + 1.0f;
    _192.x += 1.0f;
    _192.x = _929.x / _192.x;
    _929.x = (-_192.x) + 1.0f;
    _929.x = _929.y * _929.x;
    _192.x = (_929.x * _886.x) + _192.x;
    _192.x *= _251.x;
    _848.x = _691.w;
    _691.y = _848.w;
    _863 = (_691.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _995 = _691.xyz * 0.5f.xxx;
    _999 = dot(_995, _995);
    _999 = sqrt(_999);
    _1005 = dot(_863, _863);
    _1005 = rsqrt(_1005);
    _863 = _1005.xxx * _863;
    _1005 = dot(_863, _88);
    _1005 = (_1005 * 0.5f) + 0.5f;
    _1005 = clamp(_1005, 0.0f, 1.0f);
    _1005 = log2(_1005);
    _251.x = _999 + _999;
    _999 /= _251.y;
    _251.x /= _251.y;
    float2 _1041 = _251.xx + float2(1.0f, 2.0f);
    _251 = float4(_1041.x, _251.y, _251.z, _1041.y);
    _1005 *= _251.x;
    _1005 = exp2(_1005);
    _251.x = (-_999) + 1.0f;
    _999 += 1.0f;
    _999 = _251.x / _999;
    _251.x = (-_999) + 1.0f;
    _251.x = _251.w * _251.x;
    _999 = (_251.x * _1005) + _999;
    _192.y = _999 * _251.y;
    float3 _1084 = (_848.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _251 = float4(_1084.x, _1084.y, _251.z, _1084.z);
    float3 _1089 = _848.xyz * 0.5f.xxx;
    _69 = float4(_1089.x, _1089.y, _1089.z, _69.w);
    _69.x = dot(_69.xyz, _69.xyz);
    _69.x = sqrt(_69.x);
    _779.x = dot(_251.xyw, _251.xyw);
    _779.x = rsqrt(_779.x);
    _779 = _779.xxx * _251.xyw;
    _779.x = dot(_779, _88);
    _779.x = (_779.x * 0.5f) + 0.5f;
    _779.x = clamp(_779.x, 0.0f, 1.0f);
    _779.x = log2(_779.x);
    _69.z = _69.x + _69.x;
    float2 _1144 = _69.xz / _251.zz;
    _69 = float4(_1144.x, _69.y, _1144.y, _69.w);
    _130 = _69.zz + float2(1.0f, 2.0f);
    _779.x *= _130.x;
    _779.x = exp2(_779.x);
    _130.x = (-_69.x) + 1.0f;
    _69.x += 1.0f;
    _69.x = _130.x / _69.x;
    _130.x = (-_69.x) + 1.0f;
    _130.x = _130.y * _130.x;
    _69.x = (_130.x * _779.x) + _69.x;
    _192.z = _69.x * _251.z;
    float3 _1204 = max(_192.xyz, 0.0f.xxx);
    _69 = float4(_1204.x, _1204.y, _1204.z, _69.w);
    _999 = dot(_18_m1.xyz, _18_m1.xyz);
    _999 = sqrt(_999);
    _1216 = 9.9999997473787516355514526367188e-05f < _999;
    _886 = _18_m1.xyz / _999.xxx;
    float3 _1227;
    if (_1216)
    {
        _1227 = _886;
    }
    else
    {
        _1227 = float3(0.0f, 1.0f, 0.0f);
    }
    _192 = float4(_1227.x, _1227.y, _1227.z, _192.w);
    _88.x = dot(_88, _192.xyz);
    _88.x = clamp(_88.x, 0.0f, 1.0f);
    _707 = (_18_m10.xyz * _88.xxx) + _69.xyz;
    _677.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _1264 = _18_m13.xyz + (-1.0f).xxx;
    _1264 = (_677.xxx * _1264) + 1.0f.xxx;
    _677 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _1291 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    _848 = float4(_1291.x, _1291.y, _1291.z, _848.w);
    float3 _1300 = _848.xyz * _18_m12.xyz;
    _69 = float4(_1300.x, _1300.y, _1300.z, _69.w);
    _88 = (_677 * _1264) + (-_69.xyz);
    float3 _1316 = (_37.xxx * _88) + _69.xyz;
    _37 = float4(_1316.x, _1316.y, _1316.z, _37.w);
    _325 = (_37.xyz * _707) + _325;
    float3 _1333 = (_18_m14.xyz * _9.xxx) + _325;
    _9 = float4(_1333.x, _1333.y, _1333.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _582 = dot(_37.xyz, _37.xyz);
    _582 = rsqrt(_582);
    float3 _1356 = _582.xxx * _37.xyz;
    _37 = float4(_1356.x, _1356.y, _1356.z, _37.w);
    float3 _1363 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_1363.x, _1363.y, _1363.z, _69.w);
    _582 = dot(_69.xyz, _69.xyz);
    _582 = rsqrt(_582);
    float3 _1377 = _582.xxx * _69.xyz;
    _69 = float4(_1377.x, _1377.y, _1377.z, _69.w);
    _582 = dot(_37.xyz, _69.xyz);
    _582 = clamp(_582, 0.0f, 1.0f);
    _582 = (-_582) + 1.0f;
    _582 *= _582;
    _582 = (_582 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _582 *= _18_m18;
    float3 _1410 = (_18_m17.xyz * _582.xxx) + _9.xyz;
    _9 = float4(_1410.x, _1410.y, _1410.z, _9.w);
    float3 _1420 = _9.xyz + (-_18_m2.xyz);
    _9 = float4(_1420.x, _1420.y, _1420.z, _9.w);
    _582 = vs_TEXCOORD5;
    _582 = clamp(_582, 0.0f, 1.0f);
    float3 _1435 = (_582.xxx * _9.xyz) + _18_m2.xyz;
    _9 = float4(_1435.x, _1435.y, _1435.z, _9.w);
    _1439 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1439.w);
    _1439.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1439 = _1439;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_WorldToObject;
static float4 _21_m3[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m5[4];
float4 unity_FogParams;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _ProjectionParams
#define _21_m4 unity_WorldTransformParams
#define _21_m6 unity_FogParams
#define _21_m7 _Morph
#define _21_m8 _SweepTop
#define _21_m9 _SweepHeight
#define _21_m10 _NoiseScale
#define _21_m11 _NoiseWeight
#define _21_m12 _SeamWidth
#define _21_m13 _BulgeAmount
#define _21_m14 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _595;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _595 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m10, _21_m10));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m2[1].xyz;
    _318 = (_21_m2[0].xyz * _320.xxx) + _318;
    _318 = (_21_m2[2].xyz * _320.zzz) + _318;
    _318 += _21_m2[3].xyz;
    _43.x = (-_318.y) + _21_m8;
    _93.x = max(_21_m9, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m11 * _9.x) + _43.x;
    _43.x = (_21_m12 * 2.0f) + 1.0f;
    _43.x = (_21_m7 * _43.x) + (-_21_m12);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m12;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m13 * _21_m14;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m3[0].xyz);
    _43.z = dot(_485, _21_m3[1].xyz);
    _43.x = dot(_485, _21_m3[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m5[1];
    _68 = (_21_m5[0] * _9.xxxx) + _68;
    _68 = (_21_m5[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    _9 = _68 + _21_m5[3];
    gl_Position = _9;
    _9.x = _9.z / _21_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m6.y;
    vs_TEXCOORD5 = exp2(-_9.x);
    vs_TEXCOORD0 = _12;
    float3 _601 = _595.yyy * _21_m2[1].yzx;
    _9 = float4(_601.x, _601.y, _601.z, _9.w);
    float3 _612 = (_21_m2[0].yzx * _595.xxx) + _9.xyz;
    _9 = float4(_612.x, _612.y, _612.z, _9.w);
    float3 _623 = (_21_m2[2].yzx * _595.zzz) + _9.xyz;
    _9 = float4(_623.x, _623.y, _623.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _637 = _89.xxx * _9.xyz;
    _9 = float4(_637.x, _637.y, _637.z, _9.w);
    float3 _643 = _9.xyz * _43;
    _68 = float4(_643.x, _643.y, _643.z, _68.w);
    float3 _654 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_654.x, _654.y, _654.z, _68.w);
    float3 _661 = _68.xyz * _595.www;
    _68 = float4(_661.x, _661.y, _661.z, _68.w);
    float3 _670 = _68.xyz * _21_m4.www;
    _68 = float4(_670.x, _670.y, _670.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _595 = stage_input._595;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_FogColor
#define _18_m3 _Morph
#define _18_m4 _SweepTop
#define _18_m5 _SweepHeight
#define _18_m6 _NoiseScale
#define _18_m7 _NoiseWeight
#define _18_m8 _BlendWidth
#define _18_m9 _SeamWidth
#define _18_m10 _LightColor0
#define _18_m11 _MimicNormalScale
#define _18_m12 _MimicTint
#define _18_m13 _Color
#define _18_m14 _SeamColor
#define _18_m15 _VeinReach
#define _18_m16 _VeinColor
#define _18_m17 _FlashColor
#define _18_m18 _Flash
#define _18_m19 _VolumeMin
#define _18_m20 _VolumeInvSize
#define _18_m21 _GlobalVolumeMin
#define _18_m22 _GlobalVolumeInvSize


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _1434;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1434 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _389;
static float _512;
static float _547;
static float4 _635;
static float4 _651;
static float3 _670;
static bool _752;
static float3 _758;
static float4 _799;
static float4 _827;
static float3 _842;
static float3 _866;
static float2 _910;
static float3 _976;
static float _980;
static float _986;
static bool _1200;
static float3 _1249;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m6, _18_m6, _18_m6, _18_m6));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m4;
    _37.x = max(_18_m5, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m7 * _9.x) + _325.x;
    _325.x = (_18_m9 * 2.0f) + 1.0f;
    _325.x = (_18_m3 * _325.x) + (-_18_m9);
    _389 = _9.x >= _325.x;
    _37.x = float(_389);
    _88.x = (-_325.x) + _9.x;
    _88.z = _88.x / _18_m15;
    _88.x = abs(_88.x) / _18_m9;
    float2 _422 = (-_88.xz) + 1.0f.xx;
    _88 = float3(_422.x, _88.y, _422.y);
    float2 _429 = clamp(_88.xz, 0.0f.xx, 1.0f.xx);
    _88 = float3(_429.x, _88.y, _429.y);
    _88.x *= _88.x;
    _37.x *= _88.z;
    _217 = _18_m3 * 10.0f;
    _217 = clamp(_217, 0.0f, 1.0f);
    _37.x = _217 * _37.x;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _44.x = (-_217) + _88.y;
    _44.x = (_9.z * _44.x) + _217;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _217 = (-_69.x) + _217;
    _512 = (_9.z * _217) + _69.x;
    _512 = (-_44.x) + _512;
    _512 = (_9.w * _512) + _44.x;
    _512 = (_512 * 2.0f) + (-1.0f);
    _512 = (-abs(_512)) + 0.199999988079071044921875f;
    _512 *= 5.882352352142333984375f;
    _512 = clamp(_512, 0.0f, 1.0f);
    _547 = (_512 * (-2.0f)) + 3.0f;
    _512 *= _512;
    _512 *= _547;
    _512 = _37.x * _512;
    _9.w = _325.x + _18_m8;
    _325.x += (-_18_m8);
    float2 _581 = (-_325.xx) + _9.xw;
    _9 = float4(_581.x, _9.y, _9.z, _581.y);
    _325.x = 1.0f / _9.w;
    _9.x = _325.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _325.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_325.x) * _9.x) + 1.0f;
    _325.x = (-_9.x) + 1.0f;
    _325.x *= _512;
    _325 = _325.xxx * _18_m16.xyz;
    float3 _648 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _635 = float4(_648.x, _635.y, _648.y, _648.z);
    float3 _657 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    _651 = float4(_657.x, _657.y, _657.z, _651.w);
    float3 _667 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _635 = float4(_667.x, _635.y, _667.y, _667.z);
    _670 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _681 = _670.xy * _18_m11.xx;
    _670 = float3(_681.x, _681.y, _670.z);
    float3 _688 = _651.xyz + (-_670);
    _37 = float4(_688.x, _37.y, _688.y, _688.z);
    float3 _697 = (_9.xxx * _37.xzw) + _670;
    _37 = float4(_697.x, _37.y, _697.y, _697.z);
    _69.x = dot(_37.xzw, _37.xzw);
    _69.x = rsqrt(_69.x);
    float3 _714 = _37.xzw * _69.xxx;
    _37 = float4(_714.x, _37.y, _714.y, _714.z);
    _69.x = dot(vs_TEXCOORD2, _37.xzw);
    _69.y = dot(vs_TEXCOORD3, _37.xzw);
    _69.z = dot(vs_TEXCOORD4, _37.xzw);
    _37.x = dot(_69.xyz, _69.xyz);
    _37.x = rsqrt(_37.x);
    float3 _749 = _37.xxx * _69.xyz;
    _37 = float4(_749.x, _37.y, _749.y, _749.z);
    _752 = 1000000.0f < _18_m20.x;
    float3 _761;
    if (_752)
    {
        _761 = _18_m21;
    }
    else
    {
        _761 = _18_m19;
    }
    _758 = _761;
    float3 _774;
    if (_752)
    {
        _774 = _18_m22;
    }
    else
    {
        _774 = _18_m20;
    }
    _192 = float4(_774.x, _774.y, _774.z, _192.w);
    float3 _789 = (-_758) + vs_TEXCOORD1;
    _69 = float4(_789.x, _789.y, _789.z, _69.w);
    float3 _796 = _192.xyz * _69.xyz;
    _69 = float4(_796.x, _796.y, _796.z, _69.w);
    _799 = _Volume0.Sample(sampler_Volume0, _69.xyz).xywz;
    float3 _816 = max(_799.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _251 = float4(_816.x, _816.y, _816.z, _251.w);
    _651 = _Volume1.Sample(sampler_Volume0, _69.xyz).yxwz;
    _827 = _Volume2.Sample(sampler_Volume0, _69.xyz).xzwy;
    _799.x = _651.y;
    _799.y = _827.x;
    _842 = (_799.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    float3 _853 = _799.xyz * 0.5f.xxx;
    _192 = float4(_853.x, _853.y, _853.z, _192.w);
    _192.x = dot(_192.xyz, _192.xyz);
    _192.x = sqrt(_192.x);
    _866.x = dot(_842, _842);
    _866.x = rsqrt(_866.x);
    _866 = _866.xxx * _842;
    _866.x = dot(_866, _37.xzw);
    _866.x = (_866.x * 0.5f) + 0.5f;
    _866.x = clamp(_866.x, 0.0f, 1.0f);
    _866.x = log2(_866.x);
    _192.z = _192.x + _192.x;
    float2 _907 = _192.xz / _251.xx;
    _192 = float4(_907.x, _192.y, _907.y, _192.w);
    _910 = _192.zz + float2(1.0f, 2.0f);
    _866.x *= _910.x;
    _866.x = exp2(_866.x);
    _910.x = (-_192.x) + 1.0f;
    _192.x += 1.0f;
    _192.x = _910.x / _192.x;
    _910.x = (-_192.x) + 1.0f;
    _910.x = _910.y * _910.x;
    _192.x = (_910.x * _866.x) + _192.x;
    _192.x *= _251.x;
    _827.x = _651.w;
    _651.y = _827.w;
    _842 = (_651.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _976 = _651.xyz * 0.5f.xxx;
    _980 = dot(_976, _976);
    _980 = sqrt(_980);
    _986 = dot(_842, _842);
    _986 = rsqrt(_986);
    _842 = _986.xxx * _842;
    _986 = dot(_842, _37.xzw);
    _986 = (_986 * 0.5f) + 0.5f;
    _986 = clamp(_986, 0.0f, 1.0f);
    _986 = log2(_986);
    _251.x = _980 + _980;
    _980 /= _251.y;
    _251.x /= _251.y;
    float2 _1023 = _251.xx + float2(1.0f, 2.0f);
    _251 = float4(_1023.x, _251.y, _251.z, _1023.y);
    _986 *= _251.x;
    _986 = exp2(_986);
    _251.x = (-_980) + 1.0f;
    _980 += 1.0f;
    _980 = _251.x / _980;
    _251.x = (-_980) + 1.0f;
    _251.x = _251.w * _251.x;
    _980 = (_251.x * _986) + _980;
    _192.y = _980 * _251.y;
    float3 _1066 = (_827.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _251 = float4(_1066.x, _1066.y, _251.z, _1066.z);
    float3 _1071 = _827.xyz * 0.5f.xxx;
    _69 = float4(_1071.x, _1071.y, _1071.z, _69.w);
    _69.x = dot(_69.xyz, _69.xyz);
    _69.x = sqrt(_69.x);
    _758.x = dot(_251.xyw, _251.xyw);
    _758.x = rsqrt(_758.x);
    _758 = _758.xxx * _251.xyw;
    _758.x = dot(_758, _37.xzw);
    _758.x = (_758.x * 0.5f) + 0.5f;
    _758.x = clamp(_758.x, 0.0f, 1.0f);
    _758.x = log2(_758.x);
    _69.z = _69.x + _69.x;
    float2 _1127 = _69.xz / _251.zz;
    _69 = float4(_1127.x, _69.y, _1127.y, _69.w);
    _130 = _69.zz + float2(1.0f, 2.0f);
    _758.x *= _130.x;
    _758.x = exp2(_758.x);
    _130.x = (-_69.x) + 1.0f;
    _69.x += 1.0f;
    _69.x = _130.x / _69.x;
    _130.x = (-_69.x) + 1.0f;
    _130.x = _130.y * _130.x;
    _69.x = (_130.x * _758.x) + _69.x;
    _192.z = _69.x * _251.z;
    float3 _1187 = max(_192.xyz, 0.0f.xxx);
    _69 = float4(_1187.x, _1187.y, _1187.z, _69.w);
    _980 = dot(_18_m1.xyz, _18_m1.xyz);
    _980 = sqrt(_980);
    _1200 = 9.9999997473787516355514526367188e-05f < _980;
    _866 = _18_m1.xyz / _980.xxx;
    float3 _1211;
    if (_1200)
    {
        _1211 = _866;
    }
    else
    {
        _1211 = float3(0.0f, 1.0f, 0.0f);
    }
    _192 = float4(_1211.x, _1211.y, _1211.z, _192.w);
    _37.x = dot(_37.xzw, _192.xyz);
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _670 = (_18_m10.xyz * _37.xxx) + _69.xyz;
    _635.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _1249 = _18_m13.xyz + (-1.0f).xxx;
    _1249 = (_635.xxx * _1249) + 1.0f.xxx;
    float3 _1268 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _635 = float4(_1268.x, _635.y, _1268.y, _1268.z);
    float3 _1278 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    _827 = float4(_1278.x, _1278.y, _1278.z, _827.w);
    float3 _1287 = _827.xyz * _18_m12.xyz;
    _69 = float4(_1287.x, _1287.y, _1287.z, _69.w);
    float3 _1297 = (_635.xzw * _1249) + (-_69.xyz);
    _37 = float4(_1297.x, _37.y, _1297.y, _1297.z);
    float3 _1307 = (_9.xxx * _37.xzw) + _69.xyz;
    _37 = float4(_1307.x, _37.y, _1307.y, _1307.z);
    float3 _1315 = (_37.xzw * _670) + _325;
    _9 = float4(_1315.x, _1315.y, _1315.z, _9.w);
    float3 _1327 = (_18_m14.xyz * _88.xxx) + _9.xyz;
    _9 = float4(_1327.x, _1327.y, _1327.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _547 = dot(_37.xyz, _37.xyz);
    _547 = rsqrt(_547);
    float3 _1350 = _547.xxx * _37.xyz;
    _37 = float4(_1350.x, _1350.y, _1350.z, _37.w);
    float3 _1358 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_1358.x, _1358.y, _1358.z, _69.w);
    _547 = dot(_69.xyz, _69.xyz);
    _547 = rsqrt(_547);
    float3 _1372 = _547.xxx * _69.xyz;
    _69 = float4(_1372.x, _1372.y, _1372.z, _69.w);
    _547 = dot(_37.xyz, _69.xyz);
    _547 = clamp(_547, 0.0f, 1.0f);
    _547 = (-_547) + 1.0f;
    _547 *= _547;
    _547 = (_547 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _547 *= _18_m18;
    float3 _1405 = (_18_m17.xyz * _547.xxx) + _9.xyz;
    _9 = float4(_1405.x, _1405.y, _1405.z, _9.w);
    float3 _1415 = _9.xyz + (-_18_m2.xyz);
    _9 = float4(_1415.x, _1415.y, _1415.z, _9.w);
    _547 = vs_TEXCOORD5;
    _547 = clamp(_547, 0.0f, 1.0f);
    float3 _1430 = (_547.xxx * _9.xyz) + _18_m2.xyz;
    _9 = float4(_1430.x, _1430.y, _1430.z, _9.w);
    _1434 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1434.w);
    _1434.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1434 = _1434;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_WorldToObject;
static float4 _21_m3[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m5[4];
float4 unity_FogParams;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _ProjectionParams
#define _21_m4 unity_WorldTransformParams
#define _21_m6 unity_FogParams
#define _21_m7 _Morph
#define _21_m8 _SweepTop
#define _21_m9 _SweepHeight
#define _21_m10 _NoiseScale
#define _21_m11 _NoiseWeight
#define _21_m12 _SeamWidth
#define _21_m13 _BulgeAmount
#define _21_m14 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _601;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _601 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m10, _21_m10));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m2[1].xyz;
    _318 = (_21_m2[0].xyz * _320.xxx) + _318;
    _318 = (_21_m2[2].xyz * _320.zzz) + _318;
    _318 += _21_m2[3].xyz;
    _43.x = (-_318.y) + _21_m8;
    _93.x = max(_21_m9, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m11 * _9.x) + _43.x;
    _43.x = (_21_m12 * 2.0f) + 1.0f;
    _43.x = (_21_m7 * _43.x) + (-_21_m12);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m12;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m13 * _21_m14;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m3[0].xyz);
    _43.z = dot(_485, _21_m3[1].xyz);
    _43.x = dot(_485, _21_m3[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m5[1];
    _68 = (_21_m5[0] * _9.xxxx) + _68;
    _68 = (_21_m5[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    _9 = _68 + _21_m5[3];
    gl_Position = _9;
    _9.x = _9.z / _21_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m6.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD5 = exp2(_9.x);
    vs_TEXCOORD0 = _12;
    float3 _607 = _601.yyy * _21_m2[1].yzx;
    _9 = float4(_607.x, _607.y, _607.z, _9.w);
    float3 _618 = (_21_m2[0].yzx * _601.xxx) + _9.xyz;
    _9 = float4(_618.x, _618.y, _618.z, _9.w);
    float3 _629 = (_21_m2[2].yzx * _601.zzz) + _9.xyz;
    _9 = float4(_629.x, _629.y, _629.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _643 = _89.xxx * _9.xyz;
    _9 = float4(_643.x, _643.y, _643.z, _9.w);
    float3 _649 = _9.xyz * _43;
    _68 = float4(_649.x, _649.y, _649.z, _68.w);
    float3 _660 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_660.x, _660.y, _660.z, _68.w);
    float3 _667 = _68.xyz * _601.www;
    _68 = float4(_667.x, _667.y, _667.z, _68.w);
    float3 _676 = _68.xyz * _21_m4.www;
    _68 = float4(_676.x, _676.y, _676.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _601 = stage_input._601;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_FogColor
#define _18_m3 _Morph
#define _18_m4 _SweepTop
#define _18_m5 _SweepHeight
#define _18_m6 _NoiseScale
#define _18_m7 _NoiseWeight
#define _18_m8 _BlendWidth
#define _18_m9 _SeamWidth
#define _18_m10 _LightColor0
#define _18_m11 _MimicNormalScale
#define _18_m12 _MimicTint
#define _18_m13 _Color
#define _18_m14 _SeamColor
#define _18_m15 _VeinReach
#define _18_m16 _VeinColor
#define _18_m17 _FlashColor
#define _18_m18 _Flash
#define _18_m19 _VolumeMin
#define _18_m20 _VolumeInvSize
#define _18_m21 _GlobalVolumeMin
#define _18_m22 _GlobalVolumeInvSize


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _1434;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1434 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _389;
static float _512;
static float _547;
static float4 _635;
static float4 _651;
static float3 _670;
static bool _752;
static float3 _758;
static float4 _799;
static float4 _827;
static float3 _842;
static float3 _866;
static float2 _910;
static float3 _976;
static float _980;
static float _986;
static bool _1200;
static float3 _1249;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m6, _18_m6, _18_m6, _18_m6));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m4;
    _37.x = max(_18_m5, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m7 * _9.x) + _325.x;
    _325.x = (_18_m9 * 2.0f) + 1.0f;
    _325.x = (_18_m3 * _325.x) + (-_18_m9);
    _389 = _9.x >= _325.x;
    _37.x = float(_389);
    _88.x = (-_325.x) + _9.x;
    _88.z = _88.x / _18_m15;
    _88.x = abs(_88.x) / _18_m9;
    float2 _422 = (-_88.xz) + 1.0f.xx;
    _88 = float3(_422.x, _88.y, _422.y);
    float2 _429 = clamp(_88.xz, 0.0f.xx, 1.0f.xx);
    _88 = float3(_429.x, _88.y, _429.y);
    _88.x *= _88.x;
    _37.x *= _88.z;
    _217 = _18_m3 * 10.0f;
    _217 = clamp(_217, 0.0f, 1.0f);
    _37.x = _217 * _37.x;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _44.x = (-_217) + _88.y;
    _44.x = (_9.z * _44.x) + _217;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _217 = (-_69.x) + _217;
    _512 = (_9.z * _217) + _69.x;
    _512 = (-_44.x) + _512;
    _512 = (_9.w * _512) + _44.x;
    _512 = (_512 * 2.0f) + (-1.0f);
    _512 = (-abs(_512)) + 0.199999988079071044921875f;
    _512 *= 5.882352352142333984375f;
    _512 = clamp(_512, 0.0f, 1.0f);
    _547 = (_512 * (-2.0f)) + 3.0f;
    _512 *= _512;
    _512 *= _547;
    _512 = _37.x * _512;
    _9.w = _325.x + _18_m8;
    _325.x += (-_18_m8);
    float2 _581 = (-_325.xx) + _9.xw;
    _9 = float4(_581.x, _9.y, _9.z, _581.y);
    _325.x = 1.0f / _9.w;
    _9.x = _325.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _325.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_325.x) * _9.x) + 1.0f;
    _325.x = (-_9.x) + 1.0f;
    _325.x *= _512;
    _325 = _325.xxx * _18_m16.xyz;
    float3 _648 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _635 = float4(_648.x, _635.y, _648.y, _648.z);
    float3 _657 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    _651 = float4(_657.x, _657.y, _657.z, _651.w);
    float3 _667 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _635 = float4(_667.x, _635.y, _667.y, _667.z);
    _670 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _681 = _670.xy * _18_m11.xx;
    _670 = float3(_681.x, _681.y, _670.z);
    float3 _688 = _651.xyz + (-_670);
    _37 = float4(_688.x, _37.y, _688.y, _688.z);
    float3 _697 = (_9.xxx * _37.xzw) + _670;
    _37 = float4(_697.x, _37.y, _697.y, _697.z);
    _69.x = dot(_37.xzw, _37.xzw);
    _69.x = rsqrt(_69.x);
    float3 _714 = _37.xzw * _69.xxx;
    _37 = float4(_714.x, _37.y, _714.y, _714.z);
    _69.x = dot(vs_TEXCOORD2, _37.xzw);
    _69.y = dot(vs_TEXCOORD3, _37.xzw);
    _69.z = dot(vs_TEXCOORD4, _37.xzw);
    _37.x = dot(_69.xyz, _69.xyz);
    _37.x = rsqrt(_37.x);
    float3 _749 = _37.xxx * _69.xyz;
    _37 = float4(_749.x, _37.y, _749.y, _749.z);
    _752 = 1000000.0f < _18_m20.x;
    float3 _761;
    if (_752)
    {
        _761 = _18_m21;
    }
    else
    {
        _761 = _18_m19;
    }
    _758 = _761;
    float3 _774;
    if (_752)
    {
        _774 = _18_m22;
    }
    else
    {
        _774 = _18_m20;
    }
    _192 = float4(_774.x, _774.y, _774.z, _192.w);
    float3 _789 = (-_758) + vs_TEXCOORD1;
    _69 = float4(_789.x, _789.y, _789.z, _69.w);
    float3 _796 = _192.xyz * _69.xyz;
    _69 = float4(_796.x, _796.y, _796.z, _69.w);
    _799 = _Volume0.Sample(sampler_Volume0, _69.xyz).xywz;
    float3 _816 = max(_799.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _251 = float4(_816.x, _816.y, _816.z, _251.w);
    _651 = _Volume1.Sample(sampler_Volume0, _69.xyz).yxwz;
    _827 = _Volume2.Sample(sampler_Volume0, _69.xyz).xzwy;
    _799.x = _651.y;
    _799.y = _827.x;
    _842 = (_799.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    float3 _853 = _799.xyz * 0.5f.xxx;
    _192 = float4(_853.x, _853.y, _853.z, _192.w);
    _192.x = dot(_192.xyz, _192.xyz);
    _192.x = sqrt(_192.x);
    _866.x = dot(_842, _842);
    _866.x = rsqrt(_866.x);
    _866 = _866.xxx * _842;
    _866.x = dot(_866, _37.xzw);
    _866.x = (_866.x * 0.5f) + 0.5f;
    _866.x = clamp(_866.x, 0.0f, 1.0f);
    _866.x = log2(_866.x);
    _192.z = _192.x + _192.x;
    float2 _907 = _192.xz / _251.xx;
    _192 = float4(_907.x, _192.y, _907.y, _192.w);
    _910 = _192.zz + float2(1.0f, 2.0f);
    _866.x *= _910.x;
    _866.x = exp2(_866.x);
    _910.x = (-_192.x) + 1.0f;
    _192.x += 1.0f;
    _192.x = _910.x / _192.x;
    _910.x = (-_192.x) + 1.0f;
    _910.x = _910.y * _910.x;
    _192.x = (_910.x * _866.x) + _192.x;
    _192.x *= _251.x;
    _827.x = _651.w;
    _651.y = _827.w;
    _842 = (_651.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _976 = _651.xyz * 0.5f.xxx;
    _980 = dot(_976, _976);
    _980 = sqrt(_980);
    _986 = dot(_842, _842);
    _986 = rsqrt(_986);
    _842 = _986.xxx * _842;
    _986 = dot(_842, _37.xzw);
    _986 = (_986 * 0.5f) + 0.5f;
    _986 = clamp(_986, 0.0f, 1.0f);
    _986 = log2(_986);
    _251.x = _980 + _980;
    _980 /= _251.y;
    _251.x /= _251.y;
    float2 _1023 = _251.xx + float2(1.0f, 2.0f);
    _251 = float4(_1023.x, _251.y, _251.z, _1023.y);
    _986 *= _251.x;
    _986 = exp2(_986);
    _251.x = (-_980) + 1.0f;
    _980 += 1.0f;
    _980 = _251.x / _980;
    _251.x = (-_980) + 1.0f;
    _251.x = _251.w * _251.x;
    _980 = (_251.x * _986) + _980;
    _192.y = _980 * _251.y;
    float3 _1066 = (_827.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _251 = float4(_1066.x, _1066.y, _251.z, _1066.z);
    float3 _1071 = _827.xyz * 0.5f.xxx;
    _69 = float4(_1071.x, _1071.y, _1071.z, _69.w);
    _69.x = dot(_69.xyz, _69.xyz);
    _69.x = sqrt(_69.x);
    _758.x = dot(_251.xyw, _251.xyw);
    _758.x = rsqrt(_758.x);
    _758 = _758.xxx * _251.xyw;
    _758.x = dot(_758, _37.xzw);
    _758.x = (_758.x * 0.5f) + 0.5f;
    _758.x = clamp(_758.x, 0.0f, 1.0f);
    _758.x = log2(_758.x);
    _69.z = _69.x + _69.x;
    float2 _1127 = _69.xz / _251.zz;
    _69 = float4(_1127.x, _69.y, _1127.y, _69.w);
    _130 = _69.zz + float2(1.0f, 2.0f);
    _758.x *= _130.x;
    _758.x = exp2(_758.x);
    _130.x = (-_69.x) + 1.0f;
    _69.x += 1.0f;
    _69.x = _130.x / _69.x;
    _130.x = (-_69.x) + 1.0f;
    _130.x = _130.y * _130.x;
    _69.x = (_130.x * _758.x) + _69.x;
    _192.z = _69.x * _251.z;
    float3 _1187 = max(_192.xyz, 0.0f.xxx);
    _69 = float4(_1187.x, _1187.y, _1187.z, _69.w);
    _980 = dot(_18_m1.xyz, _18_m1.xyz);
    _980 = sqrt(_980);
    _1200 = 9.9999997473787516355514526367188e-05f < _980;
    _866 = _18_m1.xyz / _980.xxx;
    float3 _1211;
    if (_1200)
    {
        _1211 = _866;
    }
    else
    {
        _1211 = float3(0.0f, 1.0f, 0.0f);
    }
    _192 = float4(_1211.x, _1211.y, _1211.z, _192.w);
    _37.x = dot(_37.xzw, _192.xyz);
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _670 = (_18_m10.xyz * _37.xxx) + _69.xyz;
    _635.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _1249 = _18_m13.xyz + (-1.0f).xxx;
    _1249 = (_635.xxx * _1249) + 1.0f.xxx;
    float3 _1268 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _635 = float4(_1268.x, _635.y, _1268.y, _1268.z);
    float3 _1278 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    _827 = float4(_1278.x, _1278.y, _1278.z, _827.w);
    float3 _1287 = _827.xyz * _18_m12.xyz;
    _69 = float4(_1287.x, _1287.y, _1287.z, _69.w);
    float3 _1297 = (_635.xzw * _1249) + (-_69.xyz);
    _37 = float4(_1297.x, _37.y, _1297.y, _1297.z);
    float3 _1307 = (_9.xxx * _37.xzw) + _69.xyz;
    _37 = float4(_1307.x, _37.y, _1307.y, _1307.z);
    float3 _1315 = (_37.xzw * _670) + _325;
    _9 = float4(_1315.x, _1315.y, _1315.z, _9.w);
    float3 _1327 = (_18_m14.xyz * _88.xxx) + _9.xyz;
    _9 = float4(_1327.x, _1327.y, _1327.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _547 = dot(_37.xyz, _37.xyz);
    _547 = rsqrt(_547);
    float3 _1350 = _547.xxx * _37.xyz;
    _37 = float4(_1350.x, _1350.y, _1350.z, _37.w);
    float3 _1358 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_1358.x, _1358.y, _1358.z, _69.w);
    _547 = dot(_69.xyz, _69.xyz);
    _547 = rsqrt(_547);
    float3 _1372 = _547.xxx * _69.xyz;
    _69 = float4(_1372.x, _1372.y, _1372.z, _69.w);
    _547 = dot(_37.xyz, _69.xyz);
    _547 = clamp(_547, 0.0f, 1.0f);
    _547 = (-_547) + 1.0f;
    _547 *= _547;
    _547 = (_547 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _547 *= _18_m18;
    float3 _1405 = (_18_m17.xyz * _547.xxx) + _9.xyz;
    _9 = float4(_1405.x, _1405.y, _1405.z, _9.w);
    float3 _1415 = _9.xyz + (-_18_m2.xyz);
    _9 = float4(_1415.x, _1415.y, _1415.z, _9.w);
    _547 = vs_TEXCOORD5;
    _547 = clamp(_547, 0.0f, 1.0f);
    float3 _1430 = (_547.xxx * _9.xyz) + _18_m2.xyz;
    _9 = float4(_1430.x, _1430.y, _1430.z, _9.w);
    _1434 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1434.w);
    _1434.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1434 = _1434;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_WorldToObject;
static float4 _21_m3[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m5[4];
float4 unity_FogParams;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _ProjectionParams
#define _21_m4 unity_WorldTransformParams
#define _21_m6 unity_FogParams
#define _21_m7 _Morph
#define _21_m8 _SweepTop
#define _21_m9 _SweepHeight
#define _21_m10 _NoiseScale
#define _21_m11 _NoiseWeight
#define _21_m12 _SeamWidth
#define _21_m13 _BulgeAmount
#define _21_m14 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _593;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _593 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m10, _21_m10));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m2[1].xyz;
    _318 = (_21_m2[0].xyz * _320.xxx) + _318;
    _318 = (_21_m2[2].xyz * _320.zzz) + _318;
    _318 += _21_m2[3].xyz;
    _43.x = (-_318.y) + _21_m8;
    _93.x = max(_21_m9, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m11 * _9.x) + _43.x;
    _43.x = (_21_m12 * 2.0f) + 1.0f;
    _43.x = (_21_m7 * _43.x) + (-_21_m12);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m12;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m13 * _21_m14;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m3[0].xyz);
    _43.z = dot(_485, _21_m3[1].xyz);
    _43.x = dot(_485, _21_m3[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m5[1];
    _68 = (_21_m5[0] * _9.xxxx) + _68;
    _68 = (_21_m5[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    _9 = _68 + _21_m5[3];
    gl_Position = _9;
    _9.x = _9.z / _21_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD5 = (_9.x * _21_m6.z) + _21_m6.w;
    vs_TEXCOORD0 = _12;
    float3 _599 = _593.yyy * _21_m2[1].yzx;
    _9 = float4(_599.x, _599.y, _599.z, _9.w);
    float3 _610 = (_21_m2[0].yzx * _593.xxx) + _9.xyz;
    _9 = float4(_610.x, _610.y, _610.z, _9.w);
    float3 _621 = (_21_m2[2].yzx * _593.zzz) + _9.xyz;
    _9 = float4(_621.x, _621.y, _621.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _635 = _89.xxx * _9.xyz;
    _9 = float4(_635.x, _635.y, _635.z, _9.w);
    float3 _641 = _9.xyz * _43;
    _68 = float4(_641.x, _641.y, _641.z, _68.w);
    float3 _652 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_652.x, _652.y, _652.z, _68.w);
    float3 _659 = _68.xyz * _593.www;
    _68 = float4(_659.x, _659.y, _659.z, _68.w);
    float3 _668 = _68.xyz * _21_m4.www;
    _68 = float4(_668.x, _668.y, _668.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _593 = stage_input._593;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_FogColor
#define _18_m3 _Morph
#define _18_m4 _SweepTop
#define _18_m5 _SweepHeight
#define _18_m6 _NoiseScale
#define _18_m7 _NoiseWeight
#define _18_m8 _BlendWidth
#define _18_m9 _SeamWidth
#define _18_m10 _LightColor0
#define _18_m11 _MimicNormalScale
#define _18_m12 _MimicTint
#define _18_m13 _Color
#define _18_m14 _SeamColor
#define _18_m15 _VeinReach
#define _18_m16 _VeinColor
#define _18_m17 _FlashColor
#define _18_m18 _Flash
#define _18_m19 _VolumeMin
#define _18_m20 _VolumeInvSize
#define _18_m21 _GlobalVolumeMin
#define _18_m22 _GlobalVolumeInvSize


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _1434;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1434 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _389;
static float _512;
static float _547;
static float4 _635;
static float4 _651;
static float3 _670;
static bool _752;
static float3 _758;
static float4 _799;
static float4 _827;
static float3 _842;
static float3 _866;
static float2 _910;
static float3 _976;
static float _980;
static float _986;
static bool _1200;
static float3 _1249;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m6, _18_m6, _18_m6, _18_m6));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m4;
    _37.x = max(_18_m5, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m7 * _9.x) + _325.x;
    _325.x = (_18_m9 * 2.0f) + 1.0f;
    _325.x = (_18_m3 * _325.x) + (-_18_m9);
    _389 = _9.x >= _325.x;
    _37.x = float(_389);
    _88.x = (-_325.x) + _9.x;
    _88.z = _88.x / _18_m15;
    _88.x = abs(_88.x) / _18_m9;
    float2 _422 = (-_88.xz) + 1.0f.xx;
    _88 = float3(_422.x, _88.y, _422.y);
    float2 _429 = clamp(_88.xz, 0.0f.xx, 1.0f.xx);
    _88 = float3(_429.x, _88.y, _429.y);
    _88.x *= _88.x;
    _37.x *= _88.z;
    _217 = _18_m3 * 10.0f;
    _217 = clamp(_217, 0.0f, 1.0f);
    _37.x = _217 * _37.x;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _44.x = (-_217) + _88.y;
    _44.x = (_9.z * _44.x) + _217;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _217 = (-_69.x) + _217;
    _512 = (_9.z * _217) + _69.x;
    _512 = (-_44.x) + _512;
    _512 = (_9.w * _512) + _44.x;
    _512 = (_512 * 2.0f) + (-1.0f);
    _512 = (-abs(_512)) + 0.199999988079071044921875f;
    _512 *= 5.882352352142333984375f;
    _512 = clamp(_512, 0.0f, 1.0f);
    _547 = (_512 * (-2.0f)) + 3.0f;
    _512 *= _512;
    _512 *= _547;
    _512 = _37.x * _512;
    _9.w = _325.x + _18_m8;
    _325.x += (-_18_m8);
    float2 _581 = (-_325.xx) + _9.xw;
    _9 = float4(_581.x, _9.y, _9.z, _581.y);
    _325.x = 1.0f / _9.w;
    _9.x = _325.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _325.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_325.x) * _9.x) + 1.0f;
    _325.x = (-_9.x) + 1.0f;
    _325.x *= _512;
    _325 = _325.xxx * _18_m16.xyz;
    float3 _648 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _635 = float4(_648.x, _635.y, _648.y, _648.z);
    float3 _657 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    _651 = float4(_657.x, _657.y, _657.z, _651.w);
    float3 _667 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _635 = float4(_667.x, _635.y, _667.y, _667.z);
    _670 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _681 = _670.xy * _18_m11.xx;
    _670 = float3(_681.x, _681.y, _670.z);
    float3 _688 = _651.xyz + (-_670);
    _37 = float4(_688.x, _37.y, _688.y, _688.z);
    float3 _697 = (_9.xxx * _37.xzw) + _670;
    _37 = float4(_697.x, _37.y, _697.y, _697.z);
    _69.x = dot(_37.xzw, _37.xzw);
    _69.x = rsqrt(_69.x);
    float3 _714 = _37.xzw * _69.xxx;
    _37 = float4(_714.x, _37.y, _714.y, _714.z);
    _69.x = dot(vs_TEXCOORD2, _37.xzw);
    _69.y = dot(vs_TEXCOORD3, _37.xzw);
    _69.z = dot(vs_TEXCOORD4, _37.xzw);
    _37.x = dot(_69.xyz, _69.xyz);
    _37.x = rsqrt(_37.x);
    float3 _749 = _37.xxx * _69.xyz;
    _37 = float4(_749.x, _37.y, _749.y, _749.z);
    _752 = 1000000.0f < _18_m20.x;
    float3 _761;
    if (_752)
    {
        _761 = _18_m21;
    }
    else
    {
        _761 = _18_m19;
    }
    _758 = _761;
    float3 _774;
    if (_752)
    {
        _774 = _18_m22;
    }
    else
    {
        _774 = _18_m20;
    }
    _192 = float4(_774.x, _774.y, _774.z, _192.w);
    float3 _789 = (-_758) + vs_TEXCOORD1;
    _69 = float4(_789.x, _789.y, _789.z, _69.w);
    float3 _796 = _192.xyz * _69.xyz;
    _69 = float4(_796.x, _796.y, _796.z, _69.w);
    _799 = _Volume0.Sample(sampler_Volume0, _69.xyz).xywz;
    float3 _816 = max(_799.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _251 = float4(_816.x, _816.y, _816.z, _251.w);
    _651 = _Volume1.Sample(sampler_Volume0, _69.xyz).yxwz;
    _827 = _Volume2.Sample(sampler_Volume0, _69.xyz).xzwy;
    _799.x = _651.y;
    _799.y = _827.x;
    _842 = (_799.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    float3 _853 = _799.xyz * 0.5f.xxx;
    _192 = float4(_853.x, _853.y, _853.z, _192.w);
    _192.x = dot(_192.xyz, _192.xyz);
    _192.x = sqrt(_192.x);
    _866.x = dot(_842, _842);
    _866.x = rsqrt(_866.x);
    _866 = _866.xxx * _842;
    _866.x = dot(_866, _37.xzw);
    _866.x = (_866.x * 0.5f) + 0.5f;
    _866.x = clamp(_866.x, 0.0f, 1.0f);
    _866.x = log2(_866.x);
    _192.z = _192.x + _192.x;
    float2 _907 = _192.xz / _251.xx;
    _192 = float4(_907.x, _192.y, _907.y, _192.w);
    _910 = _192.zz + float2(1.0f, 2.0f);
    _866.x *= _910.x;
    _866.x = exp2(_866.x);
    _910.x = (-_192.x) + 1.0f;
    _192.x += 1.0f;
    _192.x = _910.x / _192.x;
    _910.x = (-_192.x) + 1.0f;
    _910.x = _910.y * _910.x;
    _192.x = (_910.x * _866.x) + _192.x;
    _192.x *= _251.x;
    _827.x = _651.w;
    _651.y = _827.w;
    _842 = (_651.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _976 = _651.xyz * 0.5f.xxx;
    _980 = dot(_976, _976);
    _980 = sqrt(_980);
    _986 = dot(_842, _842);
    _986 = rsqrt(_986);
    _842 = _986.xxx * _842;
    _986 = dot(_842, _37.xzw);
    _986 = (_986 * 0.5f) + 0.5f;
    _986 = clamp(_986, 0.0f, 1.0f);
    _986 = log2(_986);
    _251.x = _980 + _980;
    _980 /= _251.y;
    _251.x /= _251.y;
    float2 _1023 = _251.xx + float2(1.0f, 2.0f);
    _251 = float4(_1023.x, _251.y, _251.z, _1023.y);
    _986 *= _251.x;
    _986 = exp2(_986);
    _251.x = (-_980) + 1.0f;
    _980 += 1.0f;
    _980 = _251.x / _980;
    _251.x = (-_980) + 1.0f;
    _251.x = _251.w * _251.x;
    _980 = (_251.x * _986) + _980;
    _192.y = _980 * _251.y;
    float3 _1066 = (_827.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _251 = float4(_1066.x, _1066.y, _251.z, _1066.z);
    float3 _1071 = _827.xyz * 0.5f.xxx;
    _69 = float4(_1071.x, _1071.y, _1071.z, _69.w);
    _69.x = dot(_69.xyz, _69.xyz);
    _69.x = sqrt(_69.x);
    _758.x = dot(_251.xyw, _251.xyw);
    _758.x = rsqrt(_758.x);
    _758 = _758.xxx * _251.xyw;
    _758.x = dot(_758, _37.xzw);
    _758.x = (_758.x * 0.5f) + 0.5f;
    _758.x = clamp(_758.x, 0.0f, 1.0f);
    _758.x = log2(_758.x);
    _69.z = _69.x + _69.x;
    float2 _1127 = _69.xz / _251.zz;
    _69 = float4(_1127.x, _69.y, _1127.y, _69.w);
    _130 = _69.zz + float2(1.0f, 2.0f);
    _758.x *= _130.x;
    _758.x = exp2(_758.x);
    _130.x = (-_69.x) + 1.0f;
    _69.x += 1.0f;
    _69.x = _130.x / _69.x;
    _130.x = (-_69.x) + 1.0f;
    _130.x = _130.y * _130.x;
    _69.x = (_130.x * _758.x) + _69.x;
    _192.z = _69.x * _251.z;
    float3 _1187 = max(_192.xyz, 0.0f.xxx);
    _69 = float4(_1187.x, _1187.y, _1187.z, _69.w);
    _980 = dot(_18_m1.xyz, _18_m1.xyz);
    _980 = sqrt(_980);
    _1200 = 9.9999997473787516355514526367188e-05f < _980;
    _866 = _18_m1.xyz / _980.xxx;
    float3 _1211;
    if (_1200)
    {
        _1211 = _866;
    }
    else
    {
        _1211 = float3(0.0f, 1.0f, 0.0f);
    }
    _192 = float4(_1211.x, _1211.y, _1211.z, _192.w);
    _37.x = dot(_37.xzw, _192.xyz);
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _670 = (_18_m10.xyz * _37.xxx) + _69.xyz;
    _635.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _1249 = _18_m13.xyz + (-1.0f).xxx;
    _1249 = (_635.xxx * _1249) + 1.0f.xxx;
    float3 _1268 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _635 = float4(_1268.x, _635.y, _1268.y, _1268.z);
    float3 _1278 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    _827 = float4(_1278.x, _1278.y, _1278.z, _827.w);
    float3 _1287 = _827.xyz * _18_m12.xyz;
    _69 = float4(_1287.x, _1287.y, _1287.z, _69.w);
    float3 _1297 = (_635.xzw * _1249) + (-_69.xyz);
    _37 = float4(_1297.x, _37.y, _1297.y, _1297.z);
    float3 _1307 = (_9.xxx * _37.xzw) + _69.xyz;
    _37 = float4(_1307.x, _37.y, _1307.y, _1307.z);
    float3 _1315 = (_37.xzw * _670) + _325;
    _9 = float4(_1315.x, _1315.y, _1315.z, _9.w);
    float3 _1327 = (_18_m14.xyz * _88.xxx) + _9.xyz;
    _9 = float4(_1327.x, _1327.y, _1327.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _547 = dot(_37.xyz, _37.xyz);
    _547 = rsqrt(_547);
    float3 _1350 = _547.xxx * _37.xyz;
    _37 = float4(_1350.x, _1350.y, _1350.z, _37.w);
    float3 _1358 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_1358.x, _1358.y, _1358.z, _69.w);
    _547 = dot(_69.xyz, _69.xyz);
    _547 = rsqrt(_547);
    float3 _1372 = _547.xxx * _69.xyz;
    _69 = float4(_1372.x, _1372.y, _1372.z, _69.w);
    _547 = dot(_37.xyz, _69.xyz);
    _547 = clamp(_547, 0.0f, 1.0f);
    _547 = (-_547) + 1.0f;
    _547 *= _547;
    _547 = (_547 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _547 *= _18_m18;
    float3 _1405 = (_18_m17.xyz * _547.xxx) + _9.xyz;
    _9 = float4(_1405.x, _1405.y, _1405.z, _9.w);
    float3 _1415 = _9.xyz + (-_18_m2.xyz);
    _9 = float4(_1415.x, _1415.y, _1415.z, _9.w);
    _547 = vs_TEXCOORD5;
    _547 = clamp(_547, 0.0f, 1.0f);
    float3 _1430 = (_547.xxx * _9.xyz) + _18_m2.xyz;
    _9 = float4(_1430.x, _1430.y, _1430.z, _9.w);
    _1434 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1434.w);
    _1434.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1434 = _1434;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(_MIMIC_CLIP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
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
    _21_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m3 unity_WorldTransformParams
#define _21_m5 _Morph
#define _21_m6 _SweepTop
#define _21_m7 _SweepHeight
#define _21_m8 _NoiseScale
#define _21_m9 _NoiseWeight
#define _21_m10 _SeamWidth
#define _21_m11 _BulgeAmount
#define _21_m12 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _560;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _560 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m8, _21_m8));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m1[1].xyz;
    _318 = (_21_m1[0].xyz * _320.xxx) + _318;
    _318 = (_21_m1[2].xyz * _320.zzz) + _318;
    _318 += _21_m1[3].xyz;
    _43.x = (-_318.y) + _21_m6;
    _93.x = max(_21_m7, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m9 * _9.x) + _43.x;
    _43.x = (_21_m10 * 2.0f) + 1.0f;
    _43.x = (_21_m5 * _43.x) + (-_21_m10);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m10;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m11 * _21_m12;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m2[0].xyz);
    _43.z = dot(_485, _21_m2[1].xyz);
    _43.x = dot(_485, _21_m2[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m4[1];
    _68 = (_21_m4[0] * _9.xxxx) + _68;
    _68 = (_21_m4[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    gl_Position = _68 + _21_m4[3];
    vs_TEXCOORD0 = _12;
    float3 _566 = _560.yyy * _21_m1[1].yzx;
    _9 = float4(_566.x, _566.y, _566.z, _9.w);
    float3 _577 = (_21_m1[0].yzx * _560.xxx) + _9.xyz;
    _9 = float4(_577.x, _577.y, _577.z, _9.w);
    float3 _588 = (_21_m1[2].yzx * _560.zzz) + _9.xyz;
    _9 = float4(_588.x, _588.y, _588.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _602 = _89.xxx * _9.xyz;
    _9 = float4(_602.x, _602.y, _602.z, _9.w);
    float3 _608 = _9.xyz * _43;
    _68 = float4(_608.x, _608.y, _608.z, _68.w);
    float3 _619 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_619.x, _619.y, _619.z, _68.w);
    float3 _626 = _68.xyz * _560.www;
    _68 = float4(_626.x, _626.y, _626.z, _68.w);
    float3 _634 = _68.xyz * _21_m3.www;
    _68 = float4(_634.x, _634.y, _634.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _560 = stage_input._560;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 _Morph
#define _18_m3 _SweepTop
#define _18_m4 _SweepHeight
#define _18_m5 _NoiseScale
#define _18_m6 _NoiseWeight
#define _18_m7 _BlendWidth
#define _18_m8 _SeamWidth
#define _18_m9 _LightColor0
#define _18_m10 _MimicNormalScale
#define _18_m11 _MimicTint
#define _18_m12 _Color
#define _18_m13 _SeamColor
#define _18_m14 _VeinReach
#define _18_m15 _VeinColor
#define _18_m16 _FlashColor
#define _18_m17 _Flash
#define _18_m18 _VolumeMin
#define _18_m19 _VolumeInvSize
#define _18_m20 _GlobalVolumeMin
#define _18_m21 _GlobalVolumeInvSize


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 _1414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _1414 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _457;
static float _546;
static float _582;
static bool _592;
static float3 _677;
static float4 _691;
static float3 _707;
static bool _773;
static float3 _779;
static float4 _820;
static float4 _848;
static float3 _863;
static float3 _886;
static float2 _929;
static float3 _995;
static float _999;
static float _1005;
static bool _1216;
static float3 _1264;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m5, _18_m5, _18_m5, _18_m5));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m3;
    _37.x = max(_18_m4, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m6 * _9.x) + _325.x;
    _325.x = (_18_m8 * 2.0f) + 1.0f;
    _325.x = (_18_m2 * _325.x) + (-_18_m8);
    _37.x = _325.x + (-_18_m7);
    _88.x = _9.x + (-_37.x);
    _217 = _325.x + _18_m7;
    _37.x = (-_37.x) + _217;
    _37.x = 1.0f / _37.x;
    _37.x *= _88.x;
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _88.x = (_37.x * (-2.0f)) + 3.0f;
    _37.x *= _37.x;
    _37.x = ((-_88.x) * _37.x) + 1.0f;
    float2 _452 = (-_37.xx) + float2(0.5f, 1.0f);
    _88 = float3(_452.x, _88.y, _452.y);
    _457 = _88.x < 0.0f;
    if ((int(_457) * (-1)) != 0)
    {
        discard;
    }
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _88.x = sin(_88.x);
    _88.x *= 43758.546875f;
    _88.x = frac(_88.x);
    _44.x = (-_88.x) + _88.y;
    _88.x = (_9.z * _44.x) + _88.x;
    _44.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _44.x = sin(_44.x);
    _44.x *= 43758.546875f;
    _44.x = frac(_44.x);
    _44.x = (-_69.x) + _44.x;
    _546 = (_9.z * _44.x) + _69.x;
    _546 = (-_88.x) + _546;
    _546 = (_9.w * _546) + _88.x;
    _546 = (_546 * 2.0f) + (-1.0f);
    _546 = (-abs(_546)) + 0.199999988079071044921875f;
    _546 *= 5.882352352142333984375f;
    _546 = clamp(_546, 0.0f, 1.0f);
    _582 = (_546 * (-2.0f)) + 3.0f;
    _546 *= _546;
    _546 *= _582;
    _592 = _9.x >= _325.x;
    _9.x = (-_325.x) + _9.x;
    _325.x = float(_592);
    _9.w = _9.x / _18_m14;
    _9.x = abs(_9.x) / _18_m8;
    float2 _625 = (-_9.xw) + 1.0f.xx;
    _9 = float4(_625.x, _9.y, _9.z, _625.y);
    float2 _632 = clamp(_9.xw, 0.0f.xx, 1.0f.xx);
    _9 = float4(_632.x, _9.y, _9.z, _632.y);
    _9.x *= _9.x;
    _325.x *= _9.w;
    _582 = _18_m2 * 10.0f;
    _582 = clamp(_582, 0.0f, 1.0f);
    _325.x = _582 * _325.x;
    _325.x *= _546;
    _325.x = _88.z * _325.x;
    _325 = _325.xxx * _18_m15.xyz;
    _677 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _696 = (_677 * 2.0f.xxx) + (-1.0f).xxx;
    _691 = float4(_696.x, _696.y, _696.z, _691.w);
    _677 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _707 = (_677 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _717 = _707.xy * _18_m10.xx;
    _707 = float3(_717.x, _717.y, _707.z);
    _88 = _691.xyz + (-_707);
    _88 = (_37.xxx * _88) + _707;
    _69.x = dot(_88, _88);
    _69.x = rsqrt(_69.x);
    _88 *= _69.xxx;
    _69.x = dot(vs_TEXCOORD2, _88);
    _69.y = dot(vs_TEXCOORD3, _88);
    _69.z = dot(vs_TEXCOORD4, _88);
    _88.x = dot(_69.xyz, _69.xyz);
    _88.x = rsqrt(_88.x);
    _88 = _88.xxx * _69.xyz;
    _773 = 1000000.0f < _18_m19.x;
    float3 _782;
    if (_773)
    {
        _782 = _18_m20;
    }
    else
    {
        _782 = _18_m18;
    }
    _779 = _782;
    float3 _795;
    if (_773)
    {
        _795 = _18_m21;
    }
    else
    {
        _795 = _18_m19;
    }
    _192 = float4(_795.x, _795.y, _795.z, _192.w);
    float3 _810 = (-_779) + vs_TEXCOORD1;
    _69 = float4(_810.x, _810.y, _810.z, _69.w);
    float3 _817 = _192.xyz * _69.xyz;
    _69 = float4(_817.x, _817.y, _817.z, _69.w);
    _820 = _Volume0.Sample(sampler_Volume0, _69.xyz).xywz;
    float3 _837 = max(_820.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _251 = float4(_837.x, _837.y, _837.z, _251.w);
    _691 = _Volume1.Sample(sampler_Volume0, _69.xyz).yxwz;
    _848 = _Volume2.Sample(sampler_Volume0, _69.xyz).xzwy;
    _820.x = _691.y;
    _820.y = _848.x;
    _863 = (_820.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    float3 _873 = _820.xyz * 0.5f.xxx;
    _192 = float4(_873.x, _873.y, _873.z, _192.w);
    _192.x = dot(_192.xyz, _192.xyz);
    _192.x = sqrt(_192.x);
    _886.x = dot(_863, _863);
    _886.x = rsqrt(_886.x);
    _886 = _886.xxx * _863;
    _886.x = dot(_886, _88);
    _886.x = (_886.x * 0.5f) + 0.5f;
    _886.x = clamp(_886.x, 0.0f, 1.0f);
    _886.x = log2(_886.x);
    _192.z = _192.x + _192.x;
    float2 _926 = _192.xz / _251.xx;
    _192 = float4(_926.x, _192.y, _926.y, _192.w);
    _929 = _192.zz + float2(1.0f, 2.0f);
    _886.x *= _929.x;
    _886.x = exp2(_886.x);
    _929.x = (-_192.x) + 1.0f;
    _192.x += 1.0f;
    _192.x = _929.x / _192.x;
    _929.x = (-_192.x) + 1.0f;
    _929.x = _929.y * _929.x;
    _192.x = (_929.x * _886.x) + _192.x;
    _192.x *= _251.x;
    _848.x = _691.w;
    _691.y = _848.w;
    _863 = (_691.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _995 = _691.xyz * 0.5f.xxx;
    _999 = dot(_995, _995);
    _999 = sqrt(_999);
    _1005 = dot(_863, _863);
    _1005 = rsqrt(_1005);
    _863 = _1005.xxx * _863;
    _1005 = dot(_863, _88);
    _1005 = (_1005 * 0.5f) + 0.5f;
    _1005 = clamp(_1005, 0.0f, 1.0f);
    _1005 = log2(_1005);
    _251.x = _999 + _999;
    _999 /= _251.y;
    _251.x /= _251.y;
    float2 _1041 = _251.xx + float2(1.0f, 2.0f);
    _251 = float4(_1041.x, _251.y, _251.z, _1041.y);
    _1005 *= _251.x;
    _1005 = exp2(_1005);
    _251.x = (-_999) + 1.0f;
    _999 += 1.0f;
    _999 = _251.x / _999;
    _251.x = (-_999) + 1.0f;
    _251.x = _251.w * _251.x;
    _999 = (_251.x * _1005) + _999;
    _192.y = _999 * _251.y;
    float3 _1084 = (_848.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _251 = float4(_1084.x, _1084.y, _251.z, _1084.z);
    float3 _1089 = _848.xyz * 0.5f.xxx;
    _69 = float4(_1089.x, _1089.y, _1089.z, _69.w);
    _69.x = dot(_69.xyz, _69.xyz);
    _69.x = sqrt(_69.x);
    _779.x = dot(_251.xyw, _251.xyw);
    _779.x = rsqrt(_779.x);
    _779 = _779.xxx * _251.xyw;
    _779.x = dot(_779, _88);
    _779.x = (_779.x * 0.5f) + 0.5f;
    _779.x = clamp(_779.x, 0.0f, 1.0f);
    _779.x = log2(_779.x);
    _69.z = _69.x + _69.x;
    float2 _1144 = _69.xz / _251.zz;
    _69 = float4(_1144.x, _69.y, _1144.y, _69.w);
    _130 = _69.zz + float2(1.0f, 2.0f);
    _779.x *= _130.x;
    _779.x = exp2(_779.x);
    _130.x = (-_69.x) + 1.0f;
    _69.x += 1.0f;
    _69.x = _130.x / _69.x;
    _130.x = (-_69.x) + 1.0f;
    _130.x = _130.y * _130.x;
    _69.x = (_130.x * _779.x) + _69.x;
    _192.z = _69.x * _251.z;
    float3 _1204 = max(_192.xyz, 0.0f.xxx);
    _69 = float4(_1204.x, _1204.y, _1204.z, _69.w);
    _999 = dot(_18_m1.xyz, _18_m1.xyz);
    _999 = sqrt(_999);
    _1216 = 9.9999997473787516355514526367188e-05f < _999;
    _886 = _18_m1.xyz / _999.xxx;
    float3 _1227;
    if (_1216)
    {
        _1227 = _886;
    }
    else
    {
        _1227 = float3(0.0f, 1.0f, 0.0f);
    }
    _192 = float4(_1227.x, _1227.y, _1227.z, _192.w);
    _88.x = dot(_88, _192.xyz);
    _88.x = clamp(_88.x, 0.0f, 1.0f);
    _707 = (_18_m9.xyz * _88.xxx) + _69.xyz;
    _677.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _1264 = _18_m12.xyz + (-1.0f).xxx;
    _1264 = (_677.xxx * _1264) + 1.0f.xxx;
    _677 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _1291 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    _848 = float4(_1291.x, _1291.y, _1291.z, _848.w);
    float3 _1300 = _848.xyz * _18_m11.xyz;
    _69 = float4(_1300.x, _1300.y, _1300.z, _69.w);
    _88 = (_677 * _1264) + (-_69.xyz);
    float3 _1316 = (_37.xxx * _88) + _69.xyz;
    _37 = float4(_1316.x, _1316.y, _1316.z, _37.w);
    _325 = (_37.xyz * _707) + _325;
    float3 _1333 = (_18_m13.xyz * _9.xxx) + _325;
    _9 = float4(_1333.x, _1333.y, _1333.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _582 = dot(_37.xyz, _37.xyz);
    _582 = rsqrt(_582);
    float3 _1356 = _582.xxx * _37.xyz;
    _37 = float4(_1356.x, _1356.y, _1356.z, _37.w);
    float3 _1363 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_1363.x, _1363.y, _1363.z, _69.w);
    _582 = dot(_69.xyz, _69.xyz);
    _582 = rsqrt(_582);
    float3 _1377 = _582.xxx * _69.xyz;
    _69 = float4(_1377.x, _1377.y, _1377.z, _69.w);
    _582 = dot(_37.xyz, _69.xyz);
    _582 = clamp(_582, 0.0f, 1.0f);
    _582 = (-_582) + 1.0f;
    _582 *= _582;
    _582 = (_582 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _582 *= _18_m17;
    float3 _1410 = (_18_m16.xyz * _582.xxx) + _9.xyz;
    _9 = float4(_1410.x, _1410.y, _1410.z, _9.w);
    _1414 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1414.w);
    _1414.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1414 = _1414;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
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
    _21_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m3 unity_WorldTransformParams
#define _21_m5 _Morph
#define _21_m6 _SweepTop
#define _21_m7 _SweepHeight
#define _21_m8 _NoiseScale
#define _21_m9 _NoiseWeight
#define _21_m10 _SeamWidth
#define _21_m11 _BulgeAmount
#define _21_m12 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _560;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _560 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m8, _21_m8));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m1[1].xyz;
    _318 = (_21_m1[0].xyz * _320.xxx) + _318;
    _318 = (_21_m1[2].xyz * _320.zzz) + _318;
    _318 += _21_m1[3].xyz;
    _43.x = (-_318.y) + _21_m6;
    _93.x = max(_21_m7, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m9 * _9.x) + _43.x;
    _43.x = (_21_m10 * 2.0f) + 1.0f;
    _43.x = (_21_m5 * _43.x) + (-_21_m10);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m10;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m11 * _21_m12;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m2[0].xyz);
    _43.z = dot(_485, _21_m2[1].xyz);
    _43.x = dot(_485, _21_m2[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m4[1];
    _68 = (_21_m4[0] * _9.xxxx) + _68;
    _68 = (_21_m4[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    gl_Position = _68 + _21_m4[3];
    vs_TEXCOORD0 = _12;
    float3 _566 = _560.yyy * _21_m1[1].yzx;
    _9 = float4(_566.x, _566.y, _566.z, _9.w);
    float3 _577 = (_21_m1[0].yzx * _560.xxx) + _9.xyz;
    _9 = float4(_577.x, _577.y, _577.z, _9.w);
    float3 _588 = (_21_m1[2].yzx * _560.zzz) + _9.xyz;
    _9 = float4(_588.x, _588.y, _588.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _602 = _89.xxx * _9.xyz;
    _9 = float4(_602.x, _602.y, _602.z, _9.w);
    float3 _608 = _9.xyz * _43;
    _68 = float4(_608.x, _608.y, _608.z, _68.w);
    float3 _619 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_619.x, _619.y, _619.z, _68.w);
    float3 _626 = _68.xyz * _560.www;
    _68 = float4(_626.x, _626.y, _626.z, _68.w);
    float3 _634 = _68.xyz * _21_m3.www;
    _68 = float4(_634.x, _634.y, _634.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _560 = stage_input._560;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 _Morph
#define _18_m3 _SweepTop
#define _18_m4 _SweepHeight
#define _18_m5 _NoiseScale
#define _18_m6 _NoiseWeight
#define _18_m7 _BlendWidth
#define _18_m8 _SeamWidth
#define _18_m9 _LightColor0
#define _18_m10 _MimicNormalScale
#define _18_m11 _MimicTint
#define _18_m12 _Color
#define _18_m13 _SeamColor
#define _18_m14 _VeinReach
#define _18_m15 _VeinColor
#define _18_m16 _FlashColor
#define _18_m17 _Flash
#define _18_m18 _VolumeMin
#define _18_m19 _VolumeInvSize
#define _18_m20 _GlobalVolumeMin
#define _18_m21 _GlobalVolumeInvSize


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 _1409;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _1409 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _389;
static float _512;
static float _547;
static float4 _635;
static float4 _651;
static float3 _670;
static bool _752;
static float3 _758;
static float4 _799;
static float4 _827;
static float3 _842;
static float3 _866;
static float2 _910;
static float3 _976;
static float _980;
static float _986;
static bool _1200;
static float3 _1249;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m5, _18_m5, _18_m5, _18_m5));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m3;
    _37.x = max(_18_m4, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m6 * _9.x) + _325.x;
    _325.x = (_18_m8 * 2.0f) + 1.0f;
    _325.x = (_18_m2 * _325.x) + (-_18_m8);
    _389 = _9.x >= _325.x;
    _37.x = float(_389);
    _88.x = (-_325.x) + _9.x;
    _88.z = _88.x / _18_m14;
    _88.x = abs(_88.x) / _18_m8;
    float2 _422 = (-_88.xz) + 1.0f.xx;
    _88 = float3(_422.x, _88.y, _422.y);
    float2 _429 = clamp(_88.xz, 0.0f.xx, 1.0f.xx);
    _88 = float3(_429.x, _88.y, _429.y);
    _88.x *= _88.x;
    _37.x *= _88.z;
    _217 = _18_m2 * 10.0f;
    _217 = clamp(_217, 0.0f, 1.0f);
    _37.x = _217 * _37.x;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _44.x = (-_217) + _88.y;
    _44.x = (_9.z * _44.x) + _217;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _217 = (-_69.x) + _217;
    _512 = (_9.z * _217) + _69.x;
    _512 = (-_44.x) + _512;
    _512 = (_9.w * _512) + _44.x;
    _512 = (_512 * 2.0f) + (-1.0f);
    _512 = (-abs(_512)) + 0.199999988079071044921875f;
    _512 *= 5.882352352142333984375f;
    _512 = clamp(_512, 0.0f, 1.0f);
    _547 = (_512 * (-2.0f)) + 3.0f;
    _512 *= _512;
    _512 *= _547;
    _512 = _37.x * _512;
    _9.w = _325.x + _18_m7;
    _325.x += (-_18_m7);
    float2 _581 = (-_325.xx) + _9.xw;
    _9 = float4(_581.x, _9.y, _9.z, _581.y);
    _325.x = 1.0f / _9.w;
    _9.x = _325.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _325.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_325.x) * _9.x) + 1.0f;
    _325.x = (-_9.x) + 1.0f;
    _325.x *= _512;
    _325 = _325.xxx * _18_m15.xyz;
    float3 _648 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _635 = float4(_648.x, _635.y, _648.y, _648.z);
    float3 _657 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    _651 = float4(_657.x, _657.y, _657.z, _651.w);
    float3 _667 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _635 = float4(_667.x, _635.y, _667.y, _667.z);
    _670 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _681 = _670.xy * _18_m10.xx;
    _670 = float3(_681.x, _681.y, _670.z);
    float3 _688 = _651.xyz + (-_670);
    _37 = float4(_688.x, _37.y, _688.y, _688.z);
    float3 _697 = (_9.xxx * _37.xzw) + _670;
    _37 = float4(_697.x, _37.y, _697.y, _697.z);
    _69.x = dot(_37.xzw, _37.xzw);
    _69.x = rsqrt(_69.x);
    float3 _714 = _37.xzw * _69.xxx;
    _37 = float4(_714.x, _37.y, _714.y, _714.z);
    _69.x = dot(vs_TEXCOORD2, _37.xzw);
    _69.y = dot(vs_TEXCOORD3, _37.xzw);
    _69.z = dot(vs_TEXCOORD4, _37.xzw);
    _37.x = dot(_69.xyz, _69.xyz);
    _37.x = rsqrt(_37.x);
    float3 _749 = _37.xxx * _69.xyz;
    _37 = float4(_749.x, _37.y, _749.y, _749.z);
    _752 = 1000000.0f < _18_m19.x;
    float3 _761;
    if (_752)
    {
        _761 = _18_m20;
    }
    else
    {
        _761 = _18_m18;
    }
    _758 = _761;
    float3 _774;
    if (_752)
    {
        _774 = _18_m21;
    }
    else
    {
        _774 = _18_m19;
    }
    _192 = float4(_774.x, _774.y, _774.z, _192.w);
    float3 _789 = (-_758) + vs_TEXCOORD1;
    _69 = float4(_789.x, _789.y, _789.z, _69.w);
    float3 _796 = _192.xyz * _69.xyz;
    _69 = float4(_796.x, _796.y, _796.z, _69.w);
    _799 = _Volume0.Sample(sampler_Volume0, _69.xyz).xywz;
    float3 _816 = max(_799.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _251 = float4(_816.x, _816.y, _816.z, _251.w);
    _651 = _Volume1.Sample(sampler_Volume0, _69.xyz).yxwz;
    _827 = _Volume2.Sample(sampler_Volume0, _69.xyz).xzwy;
    _799.x = _651.y;
    _799.y = _827.x;
    _842 = (_799.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    float3 _853 = _799.xyz * 0.5f.xxx;
    _192 = float4(_853.x, _853.y, _853.z, _192.w);
    _192.x = dot(_192.xyz, _192.xyz);
    _192.x = sqrt(_192.x);
    _866.x = dot(_842, _842);
    _866.x = rsqrt(_866.x);
    _866 = _866.xxx * _842;
    _866.x = dot(_866, _37.xzw);
    _866.x = (_866.x * 0.5f) + 0.5f;
    _866.x = clamp(_866.x, 0.0f, 1.0f);
    _866.x = log2(_866.x);
    _192.z = _192.x + _192.x;
    float2 _907 = _192.xz / _251.xx;
    _192 = float4(_907.x, _192.y, _907.y, _192.w);
    _910 = _192.zz + float2(1.0f, 2.0f);
    _866.x *= _910.x;
    _866.x = exp2(_866.x);
    _910.x = (-_192.x) + 1.0f;
    _192.x += 1.0f;
    _192.x = _910.x / _192.x;
    _910.x = (-_192.x) + 1.0f;
    _910.x = _910.y * _910.x;
    _192.x = (_910.x * _866.x) + _192.x;
    _192.x *= _251.x;
    _827.x = _651.w;
    _651.y = _827.w;
    _842 = (_651.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _976 = _651.xyz * 0.5f.xxx;
    _980 = dot(_976, _976);
    _980 = sqrt(_980);
    _986 = dot(_842, _842);
    _986 = rsqrt(_986);
    _842 = _986.xxx * _842;
    _986 = dot(_842, _37.xzw);
    _986 = (_986 * 0.5f) + 0.5f;
    _986 = clamp(_986, 0.0f, 1.0f);
    _986 = log2(_986);
    _251.x = _980 + _980;
    _980 /= _251.y;
    _251.x /= _251.y;
    float2 _1023 = _251.xx + float2(1.0f, 2.0f);
    _251 = float4(_1023.x, _251.y, _251.z, _1023.y);
    _986 *= _251.x;
    _986 = exp2(_986);
    _251.x = (-_980) + 1.0f;
    _980 += 1.0f;
    _980 = _251.x / _980;
    _251.x = (-_980) + 1.0f;
    _251.x = _251.w * _251.x;
    _980 = (_251.x * _986) + _980;
    _192.y = _980 * _251.y;
    float3 _1066 = (_827.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _251 = float4(_1066.x, _1066.y, _251.z, _1066.z);
    float3 _1071 = _827.xyz * 0.5f.xxx;
    _69 = float4(_1071.x, _1071.y, _1071.z, _69.w);
    _69.x = dot(_69.xyz, _69.xyz);
    _69.x = sqrt(_69.x);
    _758.x = dot(_251.xyw, _251.xyw);
    _758.x = rsqrt(_758.x);
    _758 = _758.xxx * _251.xyw;
    _758.x = dot(_758, _37.xzw);
    _758.x = (_758.x * 0.5f) + 0.5f;
    _758.x = clamp(_758.x, 0.0f, 1.0f);
    _758.x = log2(_758.x);
    _69.z = _69.x + _69.x;
    float2 _1127 = _69.xz / _251.zz;
    _69 = float4(_1127.x, _69.y, _1127.y, _69.w);
    _130 = _69.zz + float2(1.0f, 2.0f);
    _758.x *= _130.x;
    _758.x = exp2(_758.x);
    _130.x = (-_69.x) + 1.0f;
    _69.x += 1.0f;
    _69.x = _130.x / _69.x;
    _130.x = (-_69.x) + 1.0f;
    _130.x = _130.y * _130.x;
    _69.x = (_130.x * _758.x) + _69.x;
    _192.z = _69.x * _251.z;
    float3 _1187 = max(_192.xyz, 0.0f.xxx);
    _69 = float4(_1187.x, _1187.y, _1187.z, _69.w);
    _980 = dot(_18_m1.xyz, _18_m1.xyz);
    _980 = sqrt(_980);
    _1200 = 9.9999997473787516355514526367188e-05f < _980;
    _866 = _18_m1.xyz / _980.xxx;
    float3 _1211;
    if (_1200)
    {
        _1211 = _866;
    }
    else
    {
        _1211 = float3(0.0f, 1.0f, 0.0f);
    }
    _192 = float4(_1211.x, _1211.y, _1211.z, _192.w);
    _37.x = dot(_37.xzw, _192.xyz);
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _670 = (_18_m9.xyz * _37.xxx) + _69.xyz;
    _635.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _1249 = _18_m12.xyz + (-1.0f).xxx;
    _1249 = (_635.xxx * _1249) + 1.0f.xxx;
    float3 _1268 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _635 = float4(_1268.x, _635.y, _1268.y, _1268.z);
    float3 _1278 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    _827 = float4(_1278.x, _1278.y, _1278.z, _827.w);
    float3 _1287 = _827.xyz * _18_m11.xyz;
    _69 = float4(_1287.x, _1287.y, _1287.z, _69.w);
    float3 _1297 = (_635.xzw * _1249) + (-_69.xyz);
    _37 = float4(_1297.x, _37.y, _1297.y, _1297.z);
    float3 _1307 = (_9.xxx * _37.xzw) + _69.xyz;
    _37 = float4(_1307.x, _37.y, _1307.y, _1307.z);
    float3 _1315 = (_37.xzw * _670) + _325;
    _9 = float4(_1315.x, _1315.y, _1315.z, _9.w);
    float3 _1327 = (_18_m13.xyz * _88.xxx) + _9.xyz;
    _9 = float4(_1327.x, _1327.y, _1327.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _547 = dot(_37.xyz, _37.xyz);
    _547 = rsqrt(_547);
    float3 _1350 = _547.xxx * _37.xyz;
    _37 = float4(_1350.x, _1350.y, _1350.z, _37.w);
    float3 _1358 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_1358.x, _1358.y, _1358.z, _69.w);
    _547 = dot(_69.xyz, _69.xyz);
    _547 = rsqrt(_547);
    float3 _1372 = _547.xxx * _69.xyz;
    _69 = float4(_1372.x, _1372.y, _1372.z, _69.w);
    _547 = dot(_37.xyz, _69.xyz);
    _547 = clamp(_547, 0.0f, 1.0f);
    _547 = (-_547) + 1.0f;
    _547 *= _547;
    _547 = (_547 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _547 *= _18_m17;
    float3 _1405 = (_18_m16.xyz * _547.xxx) + _9.xyz;
    _9 = float4(_1405.x, _1405.y, _1405.z, _9.w);
    _1409 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1409.w);
    _1409.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1409 = _1409;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_WorldToObject;
static float4 _21_m3[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m5[4];
float4 unity_FogParams;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _ProjectionParams
#define _21_m4 unity_WorldTransformParams
#define _21_m6 unity_FogParams
#define _21_m7 _Morph
#define _21_m8 _SweepTop
#define _21_m9 _SweepHeight
#define _21_m10 _NoiseScale
#define _21_m11 _NoiseWeight
#define _21_m12 _SeamWidth
#define _21_m13 _BulgeAmount
#define _21_m14 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _595;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _595 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m10, _21_m10));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m2[1].xyz;
    _318 = (_21_m2[0].xyz * _320.xxx) + _318;
    _318 = (_21_m2[2].xyz * _320.zzz) + _318;
    _318 += _21_m2[3].xyz;
    _43.x = (-_318.y) + _21_m8;
    _93.x = max(_21_m9, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m11 * _9.x) + _43.x;
    _43.x = (_21_m12 * 2.0f) + 1.0f;
    _43.x = (_21_m7 * _43.x) + (-_21_m12);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m12;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m13 * _21_m14;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m3[0].xyz);
    _43.z = dot(_485, _21_m3[1].xyz);
    _43.x = dot(_485, _21_m3[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m5[1];
    _68 = (_21_m5[0] * _9.xxxx) + _68;
    _68 = (_21_m5[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    _9 = _68 + _21_m5[3];
    gl_Position = _9;
    _9.x = _9.z / _21_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m6.y;
    vs_TEXCOORD5 = exp2(-_9.x);
    vs_TEXCOORD0 = _12;
    float3 _601 = _595.yyy * _21_m2[1].yzx;
    _9 = float4(_601.x, _601.y, _601.z, _9.w);
    float3 _612 = (_21_m2[0].yzx * _595.xxx) + _9.xyz;
    _9 = float4(_612.x, _612.y, _612.z, _9.w);
    float3 _623 = (_21_m2[2].yzx * _595.zzz) + _9.xyz;
    _9 = float4(_623.x, _623.y, _623.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _637 = _89.xxx * _9.xyz;
    _9 = float4(_637.x, _637.y, _637.z, _9.w);
    float3 _643 = _9.xyz * _43;
    _68 = float4(_643.x, _643.y, _643.z, _68.w);
    float3 _654 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_654.x, _654.y, _654.z, _68.w);
    float3 _661 = _68.xyz * _595.www;
    _68 = float4(_661.x, _661.y, _661.z, _68.w);
    float3 _670 = _68.xyz * _21_m4.www;
    _68 = float4(_670.x, _670.y, _670.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _595 = stage_input._595;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_FogColor;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_SHAr
#define _18_m3 unity_SHAg
#define _18_m4 unity_SHAb
#define _18_m5 unity_SHBr
#define _18_m6 unity_SHBg
#define _18_m7 unity_SHBb
#define _18_m8 unity_SHC
#define _18_m9 unity_FogColor
#define _18_m10 _Morph
#define _18_m11 _SweepTop
#define _18_m12 _SweepHeight
#define _18_m13 _NoiseScale
#define _18_m14 _NoiseWeight
#define _18_m15 _BlendWidth
#define _18_m16 _SeamWidth
#define _18_m17 _LightColor0
#define _18_m18 _MimicNormalScale
#define _18_m19 _MimicTint
#define _18_m20 _Color
#define _18_m21 _SeamColor
#define _18_m22 _VeinReach
#define _18_m23 _VeinColor
#define _18_m24 _FlashColor
#define _18_m25 _Flash


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _1050;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1050 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _389;
static float _512;
static float _547;
static float4 _635;
static float3 _646;
static float3 _660;
static float4 _755;
static bool _823;
static float3 _891;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m13, _18_m13, _18_m13, _18_m13));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m11;
    _37.x = max(_18_m12, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m14 * _9.x) + _325.x;
    _325.x = (_18_m16 * 2.0f) + 1.0f;
    _325.x = (_18_m10 * _325.x) + (-_18_m16);
    _389 = _9.x >= _325.x;
    _37.x = float(_389);
    _88.x = (-_325.x) + _9.x;
    _88.z = _88.x / _18_m22;
    _88.x = abs(_88.x) / _18_m16;
    float2 _422 = (-_88.xz) + 1.0f.xx;
    _88 = float3(_422.x, _88.y, _422.y);
    float2 _429 = clamp(_88.xz, 0.0f.xx, 1.0f.xx);
    _88 = float3(_429.x, _88.y, _429.y);
    _88.x *= _88.x;
    _37.x *= _88.z;
    _217 = _18_m10 * 10.0f;
    _217 = clamp(_217, 0.0f, 1.0f);
    _37.x = _217 * _37.x;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _44.x = (-_217) + _88.y;
    _44.x = (_9.z * _44.x) + _217;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _217 = (-_69.x) + _217;
    _512 = (_9.z * _217) + _69.x;
    _512 = (-_44.x) + _512;
    _512 = (_9.w * _512) + _44.x;
    _512 = (_512 * 2.0f) + (-1.0f);
    _512 = (-abs(_512)) + 0.199999988079071044921875f;
    _512 *= 5.882352352142333984375f;
    _512 = clamp(_512, 0.0f, 1.0f);
    _547 = (_512 * (-2.0f)) + 3.0f;
    _512 *= _512;
    _512 *= _547;
    _512 = _37.x * _512;
    _9.w = _325.x + _18_m15;
    _325.x += (-_18_m15);
    float2 _581 = (-_325.xx) + _9.xw;
    _9 = float4(_581.x, _9.y, _9.z, _581.y);
    _325.x = 1.0f / _9.w;
    _9.x = _325.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _325.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_325.x) * _9.x) + 1.0f;
    _325.x = (-_9.x) + 1.0f;
    _325.x *= _512;
    _325 = _325.xxx * _18_m23.xyz;
    float3 _643 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _635 = float4(_643.x, _635.y, _643.y, _643.z);
    _646 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float3 _657 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _635 = float4(_657.x, _635.y, _657.y, _657.z);
    _660 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _671 = _660.xy * _18_m18.xx;
    _660 = float3(_671.x, _671.y, _660.z);
    float3 _677 = _646 + (-_660);
    _37 = float4(_677.x, _37.y, _677.y, _677.z);
    float3 _686 = (_9.xxx * _37.xzw) + _660;
    _37 = float4(_686.x, _37.y, _686.y, _686.z);
    _69.x = dot(_37.xzw, _37.xzw);
    _69.x = rsqrt(_69.x);
    float3 _703 = _37.xzw * _69.xxx;
    _37 = float4(_703.x, _37.y, _703.y, _703.z);
    _69.x = dot(vs_TEXCOORD2, _37.xzw);
    _69.y = dot(vs_TEXCOORD3, _37.xzw);
    _69.z = dot(vs_TEXCOORD4, _37.xzw);
    _37.x = dot(_69.xyz, _69.xyz);
    _37.x = rsqrt(_37.x);
    _69 = _37.xxxx * _69.xyzz;
    _646.x = _69.y * _69.y;
    _646.x = (_69.x * _69.x) + (-_646.x);
    _755 = _69.yzwx * _69.xywz;
    _660.x = dot(_18_m5, _755);
    _660.y = dot(_18_m6, _755);
    _660.z = dot(_18_m7, _755);
    _646 = (_18_m8.xyz * _646.xxx) + _660;
    _69.w = 1.0f;
    _660.x = dot(_18_m2, _69);
    _660.y = dot(_18_m3, _69);
    _660.z = dot(_18_m4, _69);
    _646 += _660;
    _37.x = dot(_18_m1.xyz, _18_m1.xyz);
    _37.x = sqrt(_37.x);
    _823 = 9.9999997473787516355514526367188e-05f < _37.x;
    float3 _833 = _18_m1.xyz / _37.xxx;
    _251 = float4(_833.x, _833.y, _833.z, _251.w);
    float3 _838;
    if (_823)
    {
        _838 = _251.xyz;
    }
    else
    {
        _838 = float3(0.0f, 1.0f, 0.0f);
    }
    _37 = float4(_838.x, _37.y, _838.y, _838.z);
    _37.x = dot(_69.xyz, _37.xzw);
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _646 = (_18_m17.xyz * _37.xxx) + _646;
    _635.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _660 = _18_m20.xyz + (-1.0f).xxx;
    _660 = (_635.xxx * _660) + 1.0f.xxx;
    float3 _888 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _635 = float4(_888.x, _635.y, _888.y, _888.z);
    _891 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    float3 _902 = _891 * _18_m19.xyz;
    _69 = float4(_902.x, _902.y, _902.z, _69.w);
    float3 _912 = (_635.xzw * _660) + (-_69.xyz);
    _37 = float4(_912.x, _37.y, _912.y, _912.z);
    float3 _922 = (_9.xxx * _37.xzw) + _69.xyz;
    _37 = float4(_922.x, _37.y, _922.y, _922.z);
    float3 _930 = (_37.xzw * _646) + _325;
    _9 = float4(_930.x, _930.y, _930.z, _9.w);
    float3 _942 = (_18_m21.xyz * _88.xxx) + _9.xyz;
    _9 = float4(_942.x, _942.y, _942.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _547 = dot(_37.xyz, _37.xyz);
    _547 = rsqrt(_547);
    float3 _965 = _547.xxx * _37.xyz;
    _37 = float4(_965.x, _965.y, _965.z, _37.w);
    float3 _974 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_974.x, _974.y, _974.z, _69.w);
    _547 = dot(_69.xyz, _69.xyz);
    _547 = rsqrt(_547);
    float3 _988 = _547.xxx * _69.xyz;
    _69 = float4(_988.x, _988.y, _988.z, _69.w);
    _547 = dot(_37.xyz, _69.xyz);
    _547 = clamp(_547, 0.0f, 1.0f);
    _547 = (-_547) + 1.0f;
    _547 *= _547;
    _547 = (_547 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _547 *= _18_m25;
    float3 _1021 = (_18_m24.xyz * _547.xxx) + _9.xyz;
    _9 = float4(_1021.x, _1021.y, _1021.z, _9.w);
    float3 _1031 = _9.xyz + (-_18_m9.xyz);
    _9 = float4(_1031.x, _1031.y, _1031.z, _9.w);
    _547 = vs_TEXCOORD5;
    _547 = clamp(_547, 0.0f, 1.0f);
    float3 _1046 = (_547.xxx * _9.xyz) + _18_m9.xyz;
    _9 = float4(_1046.x, _1046.y, _1046.z, _9.w);
    _1050 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1050.w);
    _1050.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1050 = _1050;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_WorldToObject;
static float4 _21_m3[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m5[4];
float4 unity_FogParams;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _ProjectionParams
#define _21_m4 unity_WorldTransformParams
#define _21_m6 unity_FogParams
#define _21_m7 _Morph
#define _21_m8 _SweepTop
#define _21_m9 _SweepHeight
#define _21_m10 _NoiseScale
#define _21_m11 _NoiseWeight
#define _21_m12 _SeamWidth
#define _21_m13 _BulgeAmount
#define _21_m14 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _601;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _601 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m10, _21_m10));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m2[1].xyz;
    _318 = (_21_m2[0].xyz * _320.xxx) + _318;
    _318 = (_21_m2[2].xyz * _320.zzz) + _318;
    _318 += _21_m2[3].xyz;
    _43.x = (-_318.y) + _21_m8;
    _93.x = max(_21_m9, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m11 * _9.x) + _43.x;
    _43.x = (_21_m12 * 2.0f) + 1.0f;
    _43.x = (_21_m7 * _43.x) + (-_21_m12);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m12;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m13 * _21_m14;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m3[0].xyz);
    _43.z = dot(_485, _21_m3[1].xyz);
    _43.x = dot(_485, _21_m3[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m5[1];
    _68 = (_21_m5[0] * _9.xxxx) + _68;
    _68 = (_21_m5[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    _9 = _68 + _21_m5[3];
    gl_Position = _9;
    _9.x = _9.z / _21_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m6.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD5 = exp2(_9.x);
    vs_TEXCOORD0 = _12;
    float3 _607 = _601.yyy * _21_m2[1].yzx;
    _9 = float4(_607.x, _607.y, _607.z, _9.w);
    float3 _618 = (_21_m2[0].yzx * _601.xxx) + _9.xyz;
    _9 = float4(_618.x, _618.y, _618.z, _9.w);
    float3 _629 = (_21_m2[2].yzx * _601.zzz) + _9.xyz;
    _9 = float4(_629.x, _629.y, _629.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _643 = _89.xxx * _9.xyz;
    _9 = float4(_643.x, _643.y, _643.z, _9.w);
    float3 _649 = _9.xyz * _43;
    _68 = float4(_649.x, _649.y, _649.z, _68.w);
    float3 _660 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_660.x, _660.y, _660.z, _68.w);
    float3 _667 = _68.xyz * _601.www;
    _68 = float4(_667.x, _667.y, _667.z, _68.w);
    float3 _676 = _68.xyz * _21_m4.www;
    _68 = float4(_676.x, _676.y, _676.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _601 = stage_input._601;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_FogColor;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_SHAr
#define _18_m3 unity_SHAg
#define _18_m4 unity_SHAb
#define _18_m5 unity_SHBr
#define _18_m6 unity_SHBg
#define _18_m7 unity_SHBb
#define _18_m8 unity_SHC
#define _18_m9 unity_FogColor
#define _18_m10 _Morph
#define _18_m11 _SweepTop
#define _18_m12 _SweepHeight
#define _18_m13 _NoiseScale
#define _18_m14 _NoiseWeight
#define _18_m15 _BlendWidth
#define _18_m16 _SeamWidth
#define _18_m17 _LightColor0
#define _18_m18 _MimicNormalScale
#define _18_m19 _MimicTint
#define _18_m20 _Color
#define _18_m21 _SeamColor
#define _18_m22 _VeinReach
#define _18_m23 _VeinColor
#define _18_m24 _FlashColor
#define _18_m25 _Flash


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _1050;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1050 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _389;
static float _512;
static float _547;
static float4 _635;
static float3 _646;
static float3 _660;
static float4 _755;
static bool _823;
static float3 _891;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m13, _18_m13, _18_m13, _18_m13));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m11;
    _37.x = max(_18_m12, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m14 * _9.x) + _325.x;
    _325.x = (_18_m16 * 2.0f) + 1.0f;
    _325.x = (_18_m10 * _325.x) + (-_18_m16);
    _389 = _9.x >= _325.x;
    _37.x = float(_389);
    _88.x = (-_325.x) + _9.x;
    _88.z = _88.x / _18_m22;
    _88.x = abs(_88.x) / _18_m16;
    float2 _422 = (-_88.xz) + 1.0f.xx;
    _88 = float3(_422.x, _88.y, _422.y);
    float2 _429 = clamp(_88.xz, 0.0f.xx, 1.0f.xx);
    _88 = float3(_429.x, _88.y, _429.y);
    _88.x *= _88.x;
    _37.x *= _88.z;
    _217 = _18_m10 * 10.0f;
    _217 = clamp(_217, 0.0f, 1.0f);
    _37.x = _217 * _37.x;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _44.x = (-_217) + _88.y;
    _44.x = (_9.z * _44.x) + _217;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _217 = (-_69.x) + _217;
    _512 = (_9.z * _217) + _69.x;
    _512 = (-_44.x) + _512;
    _512 = (_9.w * _512) + _44.x;
    _512 = (_512 * 2.0f) + (-1.0f);
    _512 = (-abs(_512)) + 0.199999988079071044921875f;
    _512 *= 5.882352352142333984375f;
    _512 = clamp(_512, 0.0f, 1.0f);
    _547 = (_512 * (-2.0f)) + 3.0f;
    _512 *= _512;
    _512 *= _547;
    _512 = _37.x * _512;
    _9.w = _325.x + _18_m15;
    _325.x += (-_18_m15);
    float2 _581 = (-_325.xx) + _9.xw;
    _9 = float4(_581.x, _9.y, _9.z, _581.y);
    _325.x = 1.0f / _9.w;
    _9.x = _325.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _325.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_325.x) * _9.x) + 1.0f;
    _325.x = (-_9.x) + 1.0f;
    _325.x *= _512;
    _325 = _325.xxx * _18_m23.xyz;
    float3 _643 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _635 = float4(_643.x, _635.y, _643.y, _643.z);
    _646 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float3 _657 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _635 = float4(_657.x, _635.y, _657.y, _657.z);
    _660 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _671 = _660.xy * _18_m18.xx;
    _660 = float3(_671.x, _671.y, _660.z);
    float3 _677 = _646 + (-_660);
    _37 = float4(_677.x, _37.y, _677.y, _677.z);
    float3 _686 = (_9.xxx * _37.xzw) + _660;
    _37 = float4(_686.x, _37.y, _686.y, _686.z);
    _69.x = dot(_37.xzw, _37.xzw);
    _69.x = rsqrt(_69.x);
    float3 _703 = _37.xzw * _69.xxx;
    _37 = float4(_703.x, _37.y, _703.y, _703.z);
    _69.x = dot(vs_TEXCOORD2, _37.xzw);
    _69.y = dot(vs_TEXCOORD3, _37.xzw);
    _69.z = dot(vs_TEXCOORD4, _37.xzw);
    _37.x = dot(_69.xyz, _69.xyz);
    _37.x = rsqrt(_37.x);
    _69 = _37.xxxx * _69.xyzz;
    _646.x = _69.y * _69.y;
    _646.x = (_69.x * _69.x) + (-_646.x);
    _755 = _69.yzwx * _69.xywz;
    _660.x = dot(_18_m5, _755);
    _660.y = dot(_18_m6, _755);
    _660.z = dot(_18_m7, _755);
    _646 = (_18_m8.xyz * _646.xxx) + _660;
    _69.w = 1.0f;
    _660.x = dot(_18_m2, _69);
    _660.y = dot(_18_m3, _69);
    _660.z = dot(_18_m4, _69);
    _646 += _660;
    _37.x = dot(_18_m1.xyz, _18_m1.xyz);
    _37.x = sqrt(_37.x);
    _823 = 9.9999997473787516355514526367188e-05f < _37.x;
    float3 _833 = _18_m1.xyz / _37.xxx;
    _251 = float4(_833.x, _833.y, _833.z, _251.w);
    float3 _838;
    if (_823)
    {
        _838 = _251.xyz;
    }
    else
    {
        _838 = float3(0.0f, 1.0f, 0.0f);
    }
    _37 = float4(_838.x, _37.y, _838.y, _838.z);
    _37.x = dot(_69.xyz, _37.xzw);
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _646 = (_18_m17.xyz * _37.xxx) + _646;
    _635.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _660 = _18_m20.xyz + (-1.0f).xxx;
    _660 = (_635.xxx * _660) + 1.0f.xxx;
    float3 _888 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _635 = float4(_888.x, _635.y, _888.y, _888.z);
    _891 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    float3 _902 = _891 * _18_m19.xyz;
    _69 = float4(_902.x, _902.y, _902.z, _69.w);
    float3 _912 = (_635.xzw * _660) + (-_69.xyz);
    _37 = float4(_912.x, _37.y, _912.y, _912.z);
    float3 _922 = (_9.xxx * _37.xzw) + _69.xyz;
    _37 = float4(_922.x, _37.y, _922.y, _922.z);
    float3 _930 = (_37.xzw * _646) + _325;
    _9 = float4(_930.x, _930.y, _930.z, _9.w);
    float3 _942 = (_18_m21.xyz * _88.xxx) + _9.xyz;
    _9 = float4(_942.x, _942.y, _942.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _547 = dot(_37.xyz, _37.xyz);
    _547 = rsqrt(_547);
    float3 _965 = _547.xxx * _37.xyz;
    _37 = float4(_965.x, _965.y, _965.z, _37.w);
    float3 _974 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_974.x, _974.y, _974.z, _69.w);
    _547 = dot(_69.xyz, _69.xyz);
    _547 = rsqrt(_547);
    float3 _988 = _547.xxx * _69.xyz;
    _69 = float4(_988.x, _988.y, _988.z, _69.w);
    _547 = dot(_37.xyz, _69.xyz);
    _547 = clamp(_547, 0.0f, 1.0f);
    _547 = (-_547) + 1.0f;
    _547 *= _547;
    _547 = (_547 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _547 *= _18_m25;
    float3 _1021 = (_18_m24.xyz * _547.xxx) + _9.xyz;
    _9 = float4(_1021.x, _1021.y, _1021.z, _9.w);
    float3 _1031 = _9.xyz + (-_18_m9.xyz);
    _9 = float4(_1031.x, _1031.y, _1031.z, _9.w);
    _547 = vs_TEXCOORD5;
    _547 = clamp(_547, 0.0f, 1.0f);
    float3 _1046 = (_547.xxx * _9.xyz) + _18_m9.xyz;
    _9 = float4(_1046.x, _1046.y, _1046.z, _9.w);
    _1050 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1050.w);
    _1050.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1050 = _1050;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_WorldToObject;
static float4 _21_m3[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m5[4];
float4 unity_FogParams;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _ProjectionParams
#define _21_m4 unity_WorldTransformParams
#define _21_m6 unity_FogParams
#define _21_m7 _Morph
#define _21_m8 _SweepTop
#define _21_m9 _SweepHeight
#define _21_m10 _NoiseScale
#define _21_m11 _NoiseWeight
#define _21_m12 _SeamWidth
#define _21_m13 _BulgeAmount
#define _21_m14 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float4 _593;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _593 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m10, _21_m10));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m2[1].xyz;
    _318 = (_21_m2[0].xyz * _320.xxx) + _318;
    _318 = (_21_m2[2].xyz * _320.zzz) + _318;
    _318 += _21_m2[3].xyz;
    _43.x = (-_318.y) + _21_m8;
    _93.x = max(_21_m9, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m11 * _9.x) + _43.x;
    _43.x = (_21_m12 * 2.0f) + 1.0f;
    _43.x = (_21_m7 * _43.x) + (-_21_m12);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m12;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m13 * _21_m14;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m3[0].xyz);
    _43.z = dot(_485, _21_m3[1].xyz);
    _43.x = dot(_485, _21_m3[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m5[1];
    _68 = (_21_m5[0] * _9.xxxx) + _68;
    _68 = (_21_m5[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    _9 = _68 + _21_m5[3];
    gl_Position = _9;
    _9.x = _9.z / _21_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD5 = (_9.x * _21_m6.z) + _21_m6.w;
    vs_TEXCOORD0 = _12;
    float3 _599 = _593.yyy * _21_m2[1].yzx;
    _9 = float4(_599.x, _599.y, _599.z, _9.w);
    float3 _610 = (_21_m2[0].yzx * _593.xxx) + _9.xyz;
    _9 = float4(_610.x, _610.y, _610.z, _9.w);
    float3 _621 = (_21_m2[2].yzx * _593.zzz) + _9.xyz;
    _9 = float4(_621.x, _621.y, _621.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _635 = _89.xxx * _9.xyz;
    _9 = float4(_635.x, _635.y, _635.z, _9.w);
    float3 _641 = _9.xyz * _43;
    _68 = float4(_641.x, _641.y, _641.z, _68.w);
    float3 _652 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_652.x, _652.y, _652.z, _68.w);
    float3 _659 = _68.xyz * _593.www;
    _68 = float4(_659.x, _659.y, _659.z, _68.w);
    float3 _668 = _68.xyz * _21_m4.www;
    _68 = float4(_668.x, _668.y, _668.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _593 = stage_input._593;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 unity_FogColor;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_SHAr
#define _18_m3 unity_SHAg
#define _18_m4 unity_SHAb
#define _18_m5 unity_SHBr
#define _18_m6 unity_SHBg
#define _18_m7 unity_SHBb
#define _18_m8 unity_SHC
#define _18_m9 unity_FogColor
#define _18_m10 _Morph
#define _18_m11 _SweepTop
#define _18_m12 _SweepHeight
#define _18_m13 _NoiseScale
#define _18_m14 _NoiseWeight
#define _18_m15 _BlendWidth
#define _18_m16 _SeamWidth
#define _18_m17 _LightColor0
#define _18_m18 _MimicNormalScale
#define _18_m19 _MimicTint
#define _18_m20 _Color
#define _18_m21 _SeamColor
#define _18_m22 _VeinReach
#define _18_m23 _VeinColor
#define _18_m24 _FlashColor
#define _18_m25 _Flash


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _1050;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1050 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _389;
static float _512;
static float _547;
static float4 _635;
static float3 _646;
static float3 _660;
static float4 _755;
static bool _823;
static float3 _891;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m13, _18_m13, _18_m13, _18_m13));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m11;
    _37.x = max(_18_m12, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m14 * _9.x) + _325.x;
    _325.x = (_18_m16 * 2.0f) + 1.0f;
    _325.x = (_18_m10 * _325.x) + (-_18_m16);
    _389 = _9.x >= _325.x;
    _37.x = float(_389);
    _88.x = (-_325.x) + _9.x;
    _88.z = _88.x / _18_m22;
    _88.x = abs(_88.x) / _18_m16;
    float2 _422 = (-_88.xz) + 1.0f.xx;
    _88 = float3(_422.x, _88.y, _422.y);
    float2 _429 = clamp(_88.xz, 0.0f.xx, 1.0f.xx);
    _88 = float3(_429.x, _88.y, _429.y);
    _88.x *= _88.x;
    _37.x *= _88.z;
    _217 = _18_m10 * 10.0f;
    _217 = clamp(_217, 0.0f, 1.0f);
    _37.x = _217 * _37.x;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _44.x = (-_217) + _88.y;
    _44.x = (_9.z * _44.x) + _217;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _217 = (-_69.x) + _217;
    _512 = (_9.z * _217) + _69.x;
    _512 = (-_44.x) + _512;
    _512 = (_9.w * _512) + _44.x;
    _512 = (_512 * 2.0f) + (-1.0f);
    _512 = (-abs(_512)) + 0.199999988079071044921875f;
    _512 *= 5.882352352142333984375f;
    _512 = clamp(_512, 0.0f, 1.0f);
    _547 = (_512 * (-2.0f)) + 3.0f;
    _512 *= _512;
    _512 *= _547;
    _512 = _37.x * _512;
    _9.w = _325.x + _18_m15;
    _325.x += (-_18_m15);
    float2 _581 = (-_325.xx) + _9.xw;
    _9 = float4(_581.x, _9.y, _9.z, _581.y);
    _325.x = 1.0f / _9.w;
    _9.x = _325.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _325.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_325.x) * _9.x) + 1.0f;
    _325.x = (-_9.x) + 1.0f;
    _325.x *= _512;
    _325 = _325.xxx * _18_m23.xyz;
    float3 _643 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _635 = float4(_643.x, _635.y, _643.y, _643.z);
    _646 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float3 _657 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _635 = float4(_657.x, _635.y, _657.y, _657.z);
    _660 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _671 = _660.xy * _18_m18.xx;
    _660 = float3(_671.x, _671.y, _660.z);
    float3 _677 = _646 + (-_660);
    _37 = float4(_677.x, _37.y, _677.y, _677.z);
    float3 _686 = (_9.xxx * _37.xzw) + _660;
    _37 = float4(_686.x, _37.y, _686.y, _686.z);
    _69.x = dot(_37.xzw, _37.xzw);
    _69.x = rsqrt(_69.x);
    float3 _703 = _37.xzw * _69.xxx;
    _37 = float4(_703.x, _37.y, _703.y, _703.z);
    _69.x = dot(vs_TEXCOORD2, _37.xzw);
    _69.y = dot(vs_TEXCOORD3, _37.xzw);
    _69.z = dot(vs_TEXCOORD4, _37.xzw);
    _37.x = dot(_69.xyz, _69.xyz);
    _37.x = rsqrt(_37.x);
    _69 = _37.xxxx * _69.xyzz;
    _646.x = _69.y * _69.y;
    _646.x = (_69.x * _69.x) + (-_646.x);
    _755 = _69.yzwx * _69.xywz;
    _660.x = dot(_18_m5, _755);
    _660.y = dot(_18_m6, _755);
    _660.z = dot(_18_m7, _755);
    _646 = (_18_m8.xyz * _646.xxx) + _660;
    _69.w = 1.0f;
    _660.x = dot(_18_m2, _69);
    _660.y = dot(_18_m3, _69);
    _660.z = dot(_18_m4, _69);
    _646 += _660;
    _37.x = dot(_18_m1.xyz, _18_m1.xyz);
    _37.x = sqrt(_37.x);
    _823 = 9.9999997473787516355514526367188e-05f < _37.x;
    float3 _833 = _18_m1.xyz / _37.xxx;
    _251 = float4(_833.x, _833.y, _833.z, _251.w);
    float3 _838;
    if (_823)
    {
        _838 = _251.xyz;
    }
    else
    {
        _838 = float3(0.0f, 1.0f, 0.0f);
    }
    _37 = float4(_838.x, _37.y, _838.y, _838.z);
    _37.x = dot(_69.xyz, _37.xzw);
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _646 = (_18_m17.xyz * _37.xxx) + _646;
    _635.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _660 = _18_m20.xyz + (-1.0f).xxx;
    _660 = (_635.xxx * _660) + 1.0f.xxx;
    float3 _888 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _635 = float4(_888.x, _635.y, _888.y, _888.z);
    _891 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    float3 _902 = _891 * _18_m19.xyz;
    _69 = float4(_902.x, _902.y, _902.z, _69.w);
    float3 _912 = (_635.xzw * _660) + (-_69.xyz);
    _37 = float4(_912.x, _37.y, _912.y, _912.z);
    float3 _922 = (_9.xxx * _37.xzw) + _69.xyz;
    _37 = float4(_922.x, _37.y, _922.y, _922.z);
    float3 _930 = (_37.xzw * _646) + _325;
    _9 = float4(_930.x, _930.y, _930.z, _9.w);
    float3 _942 = (_18_m21.xyz * _88.xxx) + _9.xyz;
    _9 = float4(_942.x, _942.y, _942.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _547 = dot(_37.xyz, _37.xyz);
    _547 = rsqrt(_547);
    float3 _965 = _547.xxx * _37.xyz;
    _37 = float4(_965.x, _965.y, _965.z, _37.w);
    float3 _974 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_974.x, _974.y, _974.z, _69.w);
    _547 = dot(_69.xyz, _69.xyz);
    _547 = rsqrt(_547);
    float3 _988 = _547.xxx * _69.xyz;
    _69 = float4(_988.x, _988.y, _988.z, _69.w);
    _547 = dot(_37.xyz, _69.xyz);
    _547 = clamp(_547, 0.0f, 1.0f);
    _547 = (-_547) + 1.0f;
    _547 *= _547;
    _547 = (_547 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _547 *= _18_m25;
    float3 _1021 = (_18_m24.xyz * _547.xxx) + _9.xyz;
    _9 = float4(_1021.x, _1021.y, _1021.z, _9.w);
    float3 _1031 = _9.xyz + (-_18_m9.xyz);
    _9 = float4(_1031.x, _1031.y, _1031.z, _9.w);
    _547 = vs_TEXCOORD5;
    _547 = clamp(_547, 0.0f, 1.0f);
    float3 _1046 = (_547.xxx * _9.xyz) + _18_m9.xyz;
    _9 = float4(_1046.x, _1046.y, _1046.z, _9.w);
    _1050 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1050.w);
    _1050.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1050 = _1050;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _SeamWidth;
float _BulgeAmount;
float _BulgeScale;
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
    _21_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m3 unity_WorldTransformParams
#define _21_m5 _Morph
#define _21_m6 _SweepTop
#define _21_m7 _SweepHeight
#define _21_m8 _NoiseScale
#define _21_m9 _NoiseWeight
#define _21_m10 _SeamWidth
#define _21_m11 _BulgeAmount
#define _21_m12 _BulgeScale



static float4 gl_Position;
static float2 _12;
static float4 _320;
static float3 _485;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _560;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _320 : POSITION;
    float3 _485 : NORMAL;
    float4 _560 : TANGENT;
    float2 _12 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _37;
static float3 _43;
static float4 _68;
static float _89;
static float2 _93;
static float2 _127;
static float3 _318;
static float _504;

void vert_inner()
{
    __unity_init();
    float2 _33 = _12 * float2(float2(_21_m8, _21_m8));
    _9 = float4(_33.x, _33.y, _9.z, _9.w);
    _37 = floor(_9.xy);
    float2 _47 = _37 + 1.0f.xx;
    _43 = float3(_47.x, _47.y, _43.z);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _68 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _37.x = frac(_37.x);
    _89 = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93.x = sin(_93.x);
    _43.y = _93.x * 43758.546875f;
    float2 _109 = frac(_43.xy);
    _43 = float3(_109.x, _109.y, _43.z);
    _89 = sin(_89);
    _89 *= 43758.546875f;
    _37.y = frac(_89);
    float2 _124 = (-_37.yx) + _43.xy;
    _43 = float3(_124.x, _124.y, _43.z);
    _127 = frac(_9.xy);
    float2 _138 = (_9.xy * 2.7000000476837158203125f.xx) + 17.299999237060546875f.xx;
    _9 = float4(_138.x, _138.y, _9.z, _9.w);
    float2 _143 = _127 * _127;
    _68 = float4(_143.x, _143.y, _68.z, _68.w);
    _127 = ((-_127) * 2.0f.xx) + 3.0f.xx;
    _127 *= _68.xy;
    _89 = (_127.x * _43.x) + _37.y;
    _37.x = (_127.x * _43.y) + _37.x;
    _89 = (-_37.x) + _89;
    _37.x = (_127.y * _89) + _37.x;
    float2 _190 = floor(_9.xy);
    _43 = float3(_190.x, _190.y, _43.z);
    _127 = _43.xy + 1.0f.xx;
    _89 = dot(_127, float2(127.09999847412109375f, 311.70001220703125f));
    _89 = sin(_89);
    _9.w = _89 * 43758.546875f;
    float3 _206 = frac(_9.xyw);
    _9 = float4(_206.x, _206.y, _9.z, _206.z);
    _68 = _43.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _43.x = dot(_43.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _93.x = dot(_68.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _93.y = dot(_68.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _93 = sin(_93);
    float2 _236 = _93 * 43758.546875f.xx;
    _43 = float3(_43.x, _236.x, _236.y);
    _43 = frac(_43);
    _127.x = (-_43.x) + _43.z;
    _89 = _9.w + (-_43.y);
    float2 _259 = _9.xy * _9.xy;
    _68 = float4(_259.x, _259.y, _68.z, _68.w);
    float2 _266 = ((-_9.xy) * 2.0f.xx) + 3.0f.xx;
    _9 = float4(_266.x, _266.y, _9.z, _9.w);
    float2 _273 = _9.xy * _68.xy;
    _9 = float4(_273.x, _273.y, _9.z, _9.w);
    _89 = (_9.x * _89) + _43.y;
    _9.x = (_9.x * _127.x) + _43.x;
    _89 = (-_9.x) + _89;
    _9.x = (_9.y * _89) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _318 = _320.yyy * _21_m1[1].xyz;
    _318 = (_21_m1[0].xyz * _320.xxx) + _318;
    _318 = (_21_m1[2].xyz * _320.zzz) + _318;
    _318 += _21_m1[3].xyz;
    _43.x = (-_318.y) + _21_m6;
    _93.x = max(_21_m7, 0.001000000047497451305389404296875f);
    _43.x /= _93.x;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _9.x += (-_43.x);
    _9.x = (_21_m9 * _9.x) + _43.x;
    _43.x = (_21_m10 * 2.0f) + 1.0f;
    _43.x = (_21_m5 * _43.x) + (-_21_m10);
    _43.x = _9.x + (-_43.x);
    _9.x *= 60.0f;
    _9.x = (_21_m0.y * 38.0f) + _9.x;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.4000000059604644775390625f) + 0.60000002384185791015625f;
    _43.x = abs(_43.x) / _21_m10;
    _43.x = (-_43.x) + 1.0f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x *= _43.x;
    _93.x = _21_m11 * _21_m12;
    _43.x *= _93.x;
    _9.x *= _43.x;
    _43.y = dot(_485, _21_m2[0].xyz);
    _43.z = dot(_485, _21_m2[1].xyz);
    _43.x = dot(_485, _21_m2[2].xyz);
    _504 = dot(_43, _43);
    _504 = rsqrt(_504);
    _43 = _504.xxx * _43;
    float3 _520 = (_43.yzx * _9.xxx) + _318;
    _9 = float4(_520.x, _520.y, _520.z, _9.w);
    _68 = _9.yyyy * _21_m4[1];
    _68 = (_21_m4[0] * _9.xxxx) + _68;
    _68 = (_21_m4[2] * _9.zzzz) + _68;
    vs_TEXCOORD1 = _9.xyz;
    gl_Position = _68 + _21_m4[3];
    vs_TEXCOORD0 = _12;
    float3 _566 = _560.yyy * _21_m1[1].yzx;
    _9 = float4(_566.x, _566.y, _566.z, _9.w);
    float3 _577 = (_21_m1[0].yzx * _560.xxx) + _9.xyz;
    _9 = float4(_577.x, _577.y, _577.z, _9.w);
    float3 _588 = (_21_m1[2].yzx * _560.zzz) + _9.xyz;
    _9 = float4(_588.x, _588.y, _588.z, _9.w);
    _89 = dot(_9.xyz, _9.xyz);
    _89 = rsqrt(_89);
    float3 _602 = _89.xxx * _9.xyz;
    _9 = float4(_602.x, _602.y, _602.z, _9.w);
    float3 _608 = _9.xyz * _43;
    _68 = float4(_608.x, _608.y, _608.z, _68.w);
    float3 _619 = (_43.zxy * _9.yzx) + (-_68.xyz);
    _68 = float4(_619.x, _619.y, _619.z, _68.w);
    float3 _626 = _68.xyz * _560.www;
    _68 = float4(_626.x, _626.y, _626.z, _68.w);
    float3 _634 = _68.xyz * _21_m3.www;
    _68 = float4(_634.x, _634.y, _634.z, _68.w);
    vs_TEXCOORD2.y = _68.x;
    vs_TEXCOORD2.z = _43.y;
    vs_TEXCOORD2.x = _9.z;
    vs_TEXCOORD3.x = _9.x;
    vs_TEXCOORD4.x = _9.y;
    vs_TEXCOORD3.z = _43.z;
    vs_TEXCOORD4.z = _43.x;
    vs_TEXCOORD3.y = _68.y;
    vs_TEXCOORD4.y = _68.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _320 = stage_input._320;
    _485 = stage_input._485;
    _560 = stage_input._560;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float _Morph;
float _SweepTop;
float _SweepHeight;
float _NoiseScale;
float _NoiseWeight;
float _BlendWidth;
float _SeamWidth;
float4 _LightColor0;
float _MimicNormalScale;
float4 _MimicTint;
float4 _Color;
float4 _SeamColor;
float _VeinReach;
float4 _VeinColor;
float4 _FlashColor;
float _Flash;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _WorldSpaceLightPos0
#define _18_m2 unity_SHAr
#define _18_m3 unity_SHAg
#define _18_m4 unity_SHAb
#define _18_m5 unity_SHBr
#define _18_m6 unity_SHBg
#define _18_m7 unity_SHBb
#define _18_m8 unity_SHC
#define _18_m9 _Morph
#define _18_m10 _SweepTop
#define _18_m11 _SweepHeight
#define _18_m12 _NoiseScale
#define _18_m13 _NoiseWeight
#define _18_m14 _BlendWidth
#define _18_m15 _SeamWidth
#define _18_m16 _LightColor0
#define _18_m17 _MimicNormalScale
#define _18_m18 _MimicTint
#define _18_m19 _Color
#define _18_m20 _SeamColor
#define _18_m21 _VeinReach
#define _18_m22 _VeinColor
#define _18_m23 _FlashColor
#define _18_m24 _Flash


Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MimicNormalMap;
SamplerState sampler_MimicNormalMap;
Texture2D<float4> _ColorMask;
SamplerState sampler_ColorMask;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _MimicBaseMap;
SamplerState sampler_MimicBaseMap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 _1025;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _1025 : SV_Target0;
};

static float4 _9;
static float4 _37;
static float2 _44;
static float4 _69;
static float3 _88;
static float2 _130;
static float4 _192;
static float _217;
static float4 _251;
static float3 _325;
static bool _389;
static float _512;
static float _547;
static float4 _635;
static float3 _646;
static float3 _660;
static float4 _755;
static bool _823;
static float3 _891;

void frag_inner()
{
    _9 = vs_TEXCOORD0.xyxy * float4(float4(_18_m12, _18_m12, _18_m12, _18_m12));
    float2 _40 = floor(_9.zw);
    _37 = float4(_40.x, _40.y, _37.z, _37.w);
    _44 = _37.xy + 1.0f.xx;
    _44.x = dot(_44, float2(127.09999847412109375f, 311.70001220703125f));
    _44.x = sin(_44.x);
    _37.z = _44.x * 43758.546875f;
    _69 = _37.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _37.x = dot(_37.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _37.x = sin(_37.x);
    _37.x *= 43758.546875f;
    _88.x = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _88.z = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _99 = sin(_88.xz);
    _88 = float3(_99.x, _88.y, _99.y);
    float2 _105 = _88.xz * 43758.546875f.xx;
    _37 = float4(_37.x, _105.x, _37.z, _105.y);
    _37 = frac(_37);
    _44 = (-_37.yx) + _37.zw;
    float2 _118 = frac(_9.zw);
    _69 = float4(_118.x, _118.y, _69.z, _69.w);
    _9 = (_9 * float4(2.7000000476837158203125f, 2.7000000476837158203125f, 4.30000019073486328125f, 4.30000019073486328125f)) + float4(17.299999237060546875f, 17.299999237060546875f, 5.099999904632568359375f, 5.099999904632568359375f);
    _130 = _69.xy * _69.xy;
    float2 _144 = ((-_69.xy) * 2.0f.xx) + 3.0f.xx;
    _69 = float4(_144.x, _144.y, _69.z, _69.w);
    float2 _150 = _69.xy * _130;
    _69 = float4(_150.x, _150.y, _69.z, _69.w);
    _88.x = (_69.x * _44.x) + _37.y;
    _37.x = (_69.x * _44.y) + _37.x;
    _88.x = (-_37.x) + _88.x;
    _37.x = (_69.y * _88.x) + _37.x;
    _69 = floor(_9);
    _9 = frac(_9);
    _192 = _69 + float4(1.0f, 1.0f, 1.0f, 0.0f);
    _88.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _88.y = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    float2 _206 = sin(_88.xy);
    _88 = float3(_206.x, _206.y, _88.z);
    float2 _211 = _88.xy * 43758.546875f.xx;
    _88 = float3(_211.x, _211.y, _88.z);
    _192 = _69.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _217 = dot(_192.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = dot(_192.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _192.x = sin(_192.x);
    _192.x *= 43758.546875f;
    _192.x = frac(_192.x);
    _217 = sin(_217);
    _88.z = _217 * 43758.546875f;
    _88 = frac(_88);
    _88.x = (-_88.z) + _88.x;
    _251 = _9 * _9;
    _9 = ((-_9) * 2.0f.xxxx) + 3.0f.xxxx;
    _9 *= _251;
    _88.x = (_9.x * _88.x) + _88.z;
    _217 = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _69.x = (-_217) + _192.x;
    _9.x = (_9.x * _69.x) + _217;
    _88.x = (-_9.x) + _88.x;
    _9.x = (_9.y * _88.x) + _9.x;
    _9.x *= 0.3499999940395355224609375f;
    _9.x = (_37.x * 0.64999997615814208984375f) + _9.x;
    _325.x = (-vs_TEXCOORD1.y) + _18_m10;
    _37.x = max(_18_m11, 0.001000000047497451305389404296875f);
    _325.x /= _37.x;
    _325.x = clamp(_325.x, 0.0f, 1.0f);
    _9.x = (-_325.x) + _9.x;
    _9.x = (_18_m13 * _9.x) + _325.x;
    _325.x = (_18_m15 * 2.0f) + 1.0f;
    _325.x = (_18_m9 * _325.x) + (-_18_m15);
    _389 = _9.x >= _325.x;
    _37.x = float(_389);
    _88.x = (-_325.x) + _9.x;
    _88.z = _88.x / _18_m21;
    _88.x = abs(_88.x) / _18_m15;
    float2 _422 = (-_88.xz) + 1.0f.xx;
    _88 = float3(_422.x, _88.y, _422.y);
    float2 _429 = clamp(_88.xz, 0.0f.xx, 1.0f.xx);
    _88 = float3(_429.x, _88.y, _429.y);
    _88.x *= _88.x;
    _37.x *= _88.z;
    _217 = _18_m9 * 10.0f;
    _217 = clamp(_217, 0.0f, 1.0f);
    _37.x = _217 * _37.x;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69 = _69.zwzw + float4(0.0f, 1.0f, 1.0f, 1.0f);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _44.x = (-_217) + _88.y;
    _44.x = (_9.z * _44.x) + _217;
    _217 = dot(_69.zw, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = dot(_69.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _69.x = sin(_69.x);
    _69.x *= 43758.546875f;
    _69.x = frac(_69.x);
    _217 = sin(_217);
    _217 *= 43758.546875f;
    _217 = frac(_217);
    _217 = (-_69.x) + _217;
    _512 = (_9.z * _217) + _69.x;
    _512 = (-_44.x) + _512;
    _512 = (_9.w * _512) + _44.x;
    _512 = (_512 * 2.0f) + (-1.0f);
    _512 = (-abs(_512)) + 0.199999988079071044921875f;
    _512 *= 5.882352352142333984375f;
    _512 = clamp(_512, 0.0f, 1.0f);
    _547 = (_512 * (-2.0f)) + 3.0f;
    _512 *= _512;
    _512 *= _547;
    _512 = _37.x * _512;
    _9.w = _325.x + _18_m14;
    _325.x += (-_18_m14);
    float2 _581 = (-_325.xx) + _9.xw;
    _9 = float4(_581.x, _9.y, _9.z, _581.y);
    _325.x = 1.0f / _9.w;
    _9.x = _325.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _325.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_325.x) * _9.x) + 1.0f;
    _325.x = (-_9.x) + 1.0f;
    _325.x *= _512;
    _325 = _325.xxx * _18_m22.xyz;
    float3 _643 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    _635 = float4(_643.x, _635.y, _643.y, _643.z);
    _646 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float3 _657 = _MimicNormalMap.Sample(sampler_MimicNormalMap, vs_TEXCOORD0).xyz;
    _635 = float4(_657.x, _635.y, _657.y, _657.z);
    _660 = (_635.xzw * 2.0f.xxx) + (-1.0f).xxx;
    float2 _671 = _660.xy * _18_m17.xx;
    _660 = float3(_671.x, _671.y, _660.z);
    float3 _677 = _646 + (-_660);
    _37 = float4(_677.x, _37.y, _677.y, _677.z);
    float3 _686 = (_9.xxx * _37.xzw) + _660;
    _37 = float4(_686.x, _37.y, _686.y, _686.z);
    _69.x = dot(_37.xzw, _37.xzw);
    _69.x = rsqrt(_69.x);
    float3 _703 = _37.xzw * _69.xxx;
    _37 = float4(_703.x, _37.y, _703.y, _703.z);
    _69.x = dot(vs_TEXCOORD2, _37.xzw);
    _69.y = dot(vs_TEXCOORD3, _37.xzw);
    _69.z = dot(vs_TEXCOORD4, _37.xzw);
    _37.x = dot(_69.xyz, _69.xyz);
    _37.x = rsqrt(_37.x);
    _69 = _37.xxxx * _69.xyzz;
    _646.x = _69.y * _69.y;
    _646.x = (_69.x * _69.x) + (-_646.x);
    _755 = _69.yzwx * _69.xywz;
    _660.x = dot(_18_m5, _755);
    _660.y = dot(_18_m6, _755);
    _660.z = dot(_18_m7, _755);
    _646 = (_18_m8.xyz * _646.xxx) + _660;
    _69.w = 1.0f;
    _660.x = dot(_18_m2, _69);
    _660.y = dot(_18_m3, _69);
    _660.z = dot(_18_m4, _69);
    _646 += _660;
    _37.x = dot(_18_m1.xyz, _18_m1.xyz);
    _37.x = sqrt(_37.x);
    _823 = 9.9999997473787516355514526367188e-05f < _37.x;
    float3 _833 = _18_m1.xyz / _37.xxx;
    _251 = float4(_833.x, _833.y, _833.z, _251.w);
    float3 _838;
    if (_823)
    {
        _838 = _251.xyz;
    }
    else
    {
        _838 = float3(0.0f, 1.0f, 0.0f);
    }
    _37 = float4(_838.x, _37.y, _838.y, _838.z);
    _37.x = dot(_69.xyz, _37.xzw);
    _37.x = clamp(_37.x, 0.0f, 1.0f);
    _646 = (_18_m16.xyz * _37.xxx) + _646;
    _635.x = _ColorMask.Sample(sampler_ColorMask, vs_TEXCOORD0).x;
    _660 = _18_m19.xyz + (-1.0f).xxx;
    _660 = (_635.xxx * _660) + 1.0f.xxx;
    float3 _888 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _635 = float4(_888.x, _635.y, _888.y, _888.z);
    _891 = _MimicBaseMap.Sample(sampler_MimicBaseMap, vs_TEXCOORD0).xyz;
    float3 _902 = _891 * _18_m18.xyz;
    _69 = float4(_902.x, _902.y, _902.z, _69.w);
    float3 _912 = (_635.xzw * _660) + (-_69.xyz);
    _37 = float4(_912.x, _37.y, _912.y, _912.z);
    float3 _922 = (_9.xxx * _37.xzw) + _69.xyz;
    _37 = float4(_922.x, _37.y, _922.y, _922.z);
    float3 _930 = (_37.xzw * _646) + _325;
    _9 = float4(_930.x, _930.y, _930.z, _9.w);
    float3 _942 = (_18_m20.xyz * _88.xxx) + _9.xyz;
    _9 = float4(_942.x, _942.y, _942.z, _9.w);
    _37.x = vs_TEXCOORD2.z;
    _37.y = vs_TEXCOORD3.z;
    _37.z = vs_TEXCOORD4.z;
    _547 = dot(_37.xyz, _37.xyz);
    _547 = rsqrt(_547);
    float3 _965 = _547.xxx * _37.xyz;
    _37 = float4(_965.x, _965.y, _965.z, _37.w);
    float3 _974 = (-vs_TEXCOORD1) + _18_m0;
    _69 = float4(_974.x, _974.y, _974.z, _69.w);
    _547 = dot(_69.xyz, _69.xyz);
    _547 = rsqrt(_547);
    float3 _988 = _547.xxx * _69.xyz;
    _69 = float4(_988.x, _988.y, _988.z, _69.w);
    _547 = dot(_37.xyz, _69.xyz);
    _547 = clamp(_547, 0.0f, 1.0f);
    _547 = (-_547) + 1.0f;
    _547 *= _547;
    _547 = (_547 * 0.64999997615814208984375f) + 0.3499999940395355224609375f;
    _547 *= _18_m24;
    float3 _1021 = (_18_m23.xyz * _547.xxx) + _9.xyz;
    _9 = float4(_1021.x, _1021.y, _1021.z, _9.w);
    _1025 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _1025.w);
    _1025.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1025 = _1025;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}