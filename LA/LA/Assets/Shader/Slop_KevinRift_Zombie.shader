// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/KevinRift/Zombie" {
Properties {

[Header(Surface)] _MainTex ("Albedo", 2D) = "white" { }

_Color ("Tint", Color) = (1,1,1,1)

_BumpMap ("Normal Map", 2D) = "bump" { }

_BumpScale ("Normal Strength", Range(0, 2)) = 1.0

[Header(Gore on vertex colour R)] _GoreColor ("Gore Colour", Color) = (0.14,0.01,0.02,1)

_GoreWetness ("Gore Wetness", Range(0, 2)) = 0.800000011920929

[Header(Infection on vertex colour G)] _GlowColor ("Glow Colour (eyes, crystal shards)", Color) = (2.2,0.55,3.2,1)

_Sparkle ("Shard Sparkle", Range(0, 2)) = 1.0

_RimColor ("Infection Rim Colour", Color) = (0.32,0.07,0.55,1)

_RimPower ("Infection Rim Power", Range(0.5, 8)) = 3.200000047683716

[Header(Runtime driven by MaterialPropertyBlock)] _HitFlash ("Hit Flash", Range(0, 1)) = 0.0

_Dissolve ("Dissolve", Range(0, 1)) = 0.0

[Header(Dissolve needs the variant toggle on)] [Toggle(_DISSOLVE_ON)] _DissolveVariant ("Dissolve Variant (adds clip)", Float) = 0.0

_DissolveTex ("Dissolve Noise (R)", 2D) = "gray" { }

_DissolveEdgeColor ("Dissolve Edge Colour", Color) = (3,0.9,4.2,1)

_DissolveEdgeWidth ("Dissolve Edge Width", Range(0.01, 0.3)) = 0.07000000029802322

_DissolveHeight ("Dissolve Height (m above renderer origin: bottom, top)", Vector) = (-0.5,1,0,0)

_DissolveRise ("Dissolve Bottom-Up Bias", Range(0, 1)) = 0.550000011920929

}
SubShader {
 LOD 200
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
 Name "FORWARD"
  LOD 200
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _MainTex_ST;
float4 _DissolveHeight;
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
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m6 _GlobalVolumeMin
#define _22_m7 _GlobalVolumeInvSize
#define _22_m8 _MainTex_ST
#define _22_m9 _DissolveHeight


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float4 _93;
static float4 vs_TEXCOORD0;
static float2 _121;
static float4 vs_TEXCOORD1;
static float3 _190;
static float4 _225;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD7;
static float vs_TEXCOORD8;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _190 : NORMAL;
    float4 _225 : TANGENT;
    float2 _121 : TEXCOORD0;
    float4 _93 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD8 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 vs_TEXCOORD7 : TEXCOORD8;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float2 _92;
static bool _113;
static float _151;
static float3 _224;
static float3 _257;
static float3 _275;
static float4 _287;
static float4 _305;
static float4 _319;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    float3 _87 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_87.x, _87.y, _87.z, _9.w);
    _92.x = _93.y + _93.x;
    _92.x += _93.z;
    _113 = _92.x >= 2.9900000095367431640625f;
    float2 _131 = (_121 * _22_m8.xy) + _22_m8.zw;
    vs_TEXCOORD0 = float4(_131.x, _131.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _92 = _93.xy;
    _92 = clamp(_92, 0.0f.xx, 1.0f.xx);
    float2 _144;
    if (_113)
    {
        _144 = 0.0f.xx;
    }
    else
    {
        _144 = _92;
    }
    _92 = _144;
    _151 = _9.y + (-_22_m1[3].y);
    _151 += (-_22_m9.x);
    _51.x = (-_22_m9.x) + _22_m9.y;
    _51.x = max(_51.x, 0.001000000047497451305389404296875f);
    vs_TEXCOORD1.w = _151 / _51.x;
    vs_TEXCOORD1.w = clamp(vs_TEXCOORD1.w, 0.0f, 1.0f);
    _51.y = dot(_190, _22_m2[0].xyz);
    _51.z = dot(_190, _22_m2[1].xyz);
    _51.x = dot(_190, _22_m2[2].xyz);
    _151 = dot(_51.xyz, _51.xyz);
    _151 = rsqrt(_151);
    float3 _220 = _151.xxx * _51.yzx;
    _51 = float4(_220.x, _220.y, _220.z, _51.w);
    _224 = _225.yyy * _22_m1[1].yzx;
    _224 = (_22_m1[0].yzx * _225.xxx) + _224;
    _224 = (_22_m1[2].yzx * _225.zzz) + _224;
    _151 = dot(_224, _224);
    _151 = rsqrt(_151);
    _224 = _151.xxx * _224;
    _257 = _51.zxy * _224;
    _257 = (_51.yzx * _224.yzx) + (-_257);
    _151 = _225.w * _22_m3.w;
    _275 = _151.xxx * _257;
    _113 = 0.0f < _22_m7.x;
    if (_113)
    {
        float3 _295 = _9.xyz + (-_22_m6);
        _287 = float4(_295.x, _295.y, _295.z, _287.w);
        float3 _302 = _287.xyz * _22_m7;
        _287 = float4(_302.x, _302.y, _302.z, _287.w);
        _305 = _Volume0.SampleLevel(sampler_Volume0, _287.xyz, 0.0f);
        _319 = _Volume1.SampleLevel(sampler_Volume0, _287.xyz, 0.0f);
        _287 = _Volume2.SampleLevel(sampler_Volume0, _287.xyz, 0.0f);
        vs_TEXCOORD5.x = _319.x;
        vs_TEXCOORD5.y = _287.x;
        vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _305.wx.x, _305.wx.y);
        vs_TEXCOORD6 = float4(_319.yw.x, vs_TEXCOORD6.y, _319.yw.y, vs_TEXCOORD6.w);
        vs_TEXCOORD6.y = _287.y;
        vs_TEXCOORD6.w = _305.y;
        vs_TEXCOORD7.x = _319.z;
        vs_TEXCOORD7 = float4(vs_TEXCOORD7.x, _287.zw.x, _287.zw.y, vs_TEXCOORD7.w);
        vs_TEXCOORD7.w = _305.z;
    }
    else
    {
        vs_TEXCOORD5 = 0.0f.xxxx;
        vs_TEXCOORD6 = 0.0f.xxxx;
        vs_TEXCOORD7 = 0.0f.xxxx;
    }
    _151 = _45.z / _22_m0.y;
    _151 = (-_151) + 1.0f;
    _151 *= _22_m0.z;
    _151 = max(_151, 0.0f);
    _151 *= _22_m5.y;
    vs_TEXCOORD8 = exp2(-_151);
    gl_Position = _45;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _92.x, _92.y);
    vs_TEXCOORD1 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, vs_TEXCOORD1.w);
    _9.x = _224.z;
    _9.y = _275.x;
    _9.z = _51.x;
    vs_TEXCOORD2 = _9.xyz;
    _9.x = _224.x;
    _9.y = _275.y;
    _9.z = _51.y;
    vs_TEXCOORD3 = _9.xyz;
    _51.x = _224.y;
    _51.y = _275.z;
    vs_TEXCOORD4 = _51.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _93 = stage_input._93;
    _121 = stage_input._121;
    _190 = stage_input._190;
    _225 = stage_input._225;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD8 = vs_TEXCOORD8;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
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
float4 _LightColor0;
float3 _GlobalVolumeInvSize;
float4 _Color;
float _BumpScale;
float4 _GoreColor;
float _GoreWetness;
float4 _GlowColor;
float _Sparkle;
float4 _RimColor;
float _RimPower;
float _HitFlash;
#define _32_m0 _Time
#define _32_m1 _WorldSpaceCameraPos
#define _32_m2 _WorldSpaceLightPos0
#define _32_m3 unity_SHAr
#define _32_m4 unity_SHAg
#define _32_m5 unity_SHAb
#define _32_m6 unity_SHBr
#define _32_m7 unity_SHBg
#define _32_m8 unity_SHBb
#define _32_m9 unity_SHC
#define _32_m10 unity_FogColor
#define _32_m11 _LightColor0
#define _32_m12 _GlobalVolumeInvSize
#define _32_m13 _Color
#define _32_m14 _BumpScale
#define _32_m15 _GoreColor
#define _32_m16 _GoreWetness
#define _32_m17 _GlowColor
#define _32_m18 _Sparkle
#define _32_m19 _RimColor
#define _32_m20 _RimPower
#define _32_m21 _HitFlash


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD7;
static float vs_TEXCOORD8;
static float4 _892;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD8 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 vs_TEXCOORD7 : TEXCOORD8;
};

struct SPIRV_Cross_Output
{
    float4 _892 : SV_Target0;
};

static float3 _9;
static float3 _28;
static float4 _41;
static float3 _53;
static float _65;
static float4 _73;
static float3 _91;
static float3 _124;
static float _134;
static float3 _140;
static float _145;
static float3 _176;
static bool3 _196;
static float3 _207;
static float3 _250;
static float3 _255;
static float3 _274;
static float3 _292;
static float3 _297;
static float3 _301;
static bool3 _330;
static bool _404;
static float4 _449;
static float2 _469;
static float _583;
static float3 _710;
static float _780;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _28 = _9 * _32_m13.xyz;
    float3 _50 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _41 = float4(_50.x, _50.y, _50.z, _41.w);
    _53.x = (-vs_TEXCOORD0.w) + 1.0f;
    _65 = _53.x * _32_m14;
    float3 _81 = (_41.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _73 = float4(_81.x, _81.y, _81.z, _73.w);
    float2 _88 = _65.xx * _73.xy;
    _73 = float4(_88.x, _88.y, _73.z, _73.w);
    _91.x = dot(vs_TEXCOORD2, _73.xyz);
    _91.y = dot(vs_TEXCOORD3, _73.xyz);
    _91.z = dot(vs_TEXCOORD4, _73.xyz);
    _65 = dot(_91, _91);
    _65 = rsqrt(_65);
    float3 _121 = _65.xxx * _91;
    _41 = float4(_121.x, _121.y, _121.z, _41.w);
    _124 = (-vs_TEXCOORD1.xyz) + _32_m1;
    _134 = dot(_124, _124);
    _134 = rsqrt(_134);
    _140 = _134.xxx * _124;
    _145 = dot(_41.xyz, _140);
    _145 = clamp(_145, 0.0f, 1.0f);
    _65 = (-_145) + 1.0f;
    float3 _166 = ((-_9) * _32_m13.xyz) + _32_m15.xyz;
    _73 = float4(_166.x, _166.y, _166.z, _73.w);
    _91 = (vs_TEXCOORD0.zzz * _73.xyz) + _28;
    _176 = (_32_m17.xyz * 0.0500000007450580596923828125f.xxx) + (-_91);
    _91 = (vs_TEXCOORD0.www * _176) + _91;
    _196.x = 0.0f < _32_m12.x;
    if (_196.x)
    {
        _207.x = dot(vs_TEXCOORD5.xyz, vs_TEXCOORD5.xyz);
        _207.x = sqrt(_207.x);
        _28.x = dot(vs_TEXCOORD6.xyz, vs_TEXCOORD6.xyz);
        _207.y = sqrt(_28.x);
        _28.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
        _207.z = sqrt(_28.x);
        _28.x = vs_TEXCOORD5.w;
        _28.y = vs_TEXCOORD6.w;
        _28.z = vs_TEXCOORD7.w;
        _250 = max(_28, 9.9999997473787516355514526367188e-06f.xxx);
        _255.x = dot(vs_TEXCOORD5.xyz, _41.xyz);
        _255.y = dot(vs_TEXCOORD6.xyz, _41.xyz);
        _255.z = dot(vs_TEXCOORD7.xyz, _41.xyz);
        _274 = max(_207, 9.9999999747524270787835121154785e-07f.xxx);
        _255 /= _274;
        _255 = (_255 * 0.5f.xxx) + 0.5f.xxx;
        _274 = _207 * 0.5f.xxx;
        _274 /= _250;
        _292 = (_274 * 2.0f.xxx) + 1.0f.xxx;
        _297 = (-_274) + 1.0f.xxx;
        _301 = _274 + 1.0f.xxx;
        _297 /= _301;
        _301 = (-_297) + 1.0f.xxx;
        _274 = (_274 * 2.0f.xxx) + 2.0f.xxx;
        _274 *= _301;
        _255 = max(_255, 9.9999999747524270787835121154785e-07f.xxx);
        _255 = log2(_255);
        _255 *= _292;
        _255 = exp2(_255);
        _255 = (_274 * _255) + _297;
        _330 = bool4(_28.xyzx.x >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).x, _28.xyzx.y >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).y, _28.xyzx.z >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).z, _28.xyzx.w >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).w).xyz;
        _274.x = float(_330.x);
        _274.y = float(_330.y);
        _274.z = float(_330.z);
        _196 = bool4(_207.xyzx.x >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).x, _207.xyzx.y >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).y, _207.xyzx.z >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).z, _207.xyzx.w >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).w).xyz;
        _207.x = float(_196.x);
        _207.y = float(_196.y);
        _207.z = float(_196.z);
        _207 *= _274;
        _250 = (_250 * _255) + (-_28);
        _207 = (_207 * _250) + _28;
        _207 = max(_207, 0.0f.xxx);
        _28 = vs_TEXCOORD6.xyz * 0.715200006961822509765625f.xxx;
        _28 = (vs_TEXCOORD5.xyz * 0.2125999927520751953125f.xxx) + _28;
        _28 = (vs_TEXCOORD7.xyz * 0.072200000286102294921875f.xxx) + _28;
        _145 = dot(_28, _28);
        _404 = 1.0000000133514319600180897396058e-10f < _145;
        _145 = rsqrt(_145);
        _28 = _145.xxx * _28;
        float3 _416;
        if (_404)
        {
            _416 = _28;
        }
        else
        {
            _416 = float3(0.0f, 1.0f, 0.0f);
        }
        _28 = _416;
        _9 = _207;
    }
    else
    {
        _41.w = 1.0f;
        _176.x = dot(_32_m3, _41);
        _176.y = dot(_32_m4, _41);
        _176.z = dot(_32_m5, _41);
        _73 = _41.yzzx * _41.xyzz;
        _449.x = dot(_32_m6, _73);
        _449.y = dot(_32_m7, _73);
        _449.z = dot(_32_m8, _73);
        _469.x = _41.y * _41.y;
        _469.x = (_41.x * _41.x) + (-_469.x);
        float3 _495 = (_32_m9.xyz * _469.xxx) + _449.xyz;
        _449 = float4(_495.x, _495.y, _495.z, _449.w);
        _9 = _176 + _449.xyz;
        _28.x = 0.0f;
        _28.y = 1.0f;
        _28.z = 0.0f;
    }
    _145 = dot(_32_m2.xyz, _32_m2.xyz);
    _145 = sqrt(_145);
    _404 = 9.9999997473787516355514526367188e-05f < _145;
    _250 = _32_m2.xyz / _145.xxx;
    float3 _525;
    if (_404)
    {
        _525 = _250;
    }
    else
    {
        _525 = float3(0.0f, 1.0f, 0.0f);
    }
    _250 = _525;
    _145 = dot(_41.xyz, _250);
    _145 = clamp(_145, 0.0f, 1.0f);
    _176 = (_32_m11.xyz * _145.xxx) + _9;
    _28 = (_124 * _134.xxx) + _28;
    _145 = dot(_28, _28);
    _145 = rsqrt(_145);
    _28 = _145.xxx * _28;
    _469.x = dot(_41.xyz, _28);
    _469.x = clamp(_469.x, 0.0f, 1.0f);
    _469.x = log2(_469.x);
    _469.x *= 80.0f;
    _469.x = exp2(_469.x);
    _583 = _65 * _65;
    float2 _592 = _583.xx * float2(0.1500000059604644775390625f, 0.89999997615814208984375f);
    _449 = float4(_592.x, _592.y, _449.z, _449.w);
    _469.x = (_469.x * 3.0f) + _449.x;
    _469.x *= vs_TEXCOORD0.z;
    _469.x *= _32_m16;
    float3 _619 = _176 * _469.xxx;
    _449 = float4(_619.x, _449.y, _619.y, _619.z);
    _91 = (_91 * _176) + _449.xzw;
    _176 = (_41.xyz * 3.0f.xxx) + 0.5f.xxx;
    _176 = floor(_176);
    _176 += 7.309999942779541015625f.xxx;
    _28 = _176 * float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
    _28 = frac(_28);
    _124 = _28.yxz + 33.3300018310546875f.xxx;
    _145 = dot(_28, _124);
    _28 = _145.xxx + _28;
    _28.x = _28.y + _28.x;
    _28.x = _28.z * _28.x;
    _28.x = frac(_28.x);
    _28.x *= 37.0f;
    _28.x = (_32_m0.y * 2.2999999523162841796875f) + _28.x;
    _28.x = sin(_28.x);
    _28.x = max(_28.x, 0.0f);
    _28.x = log2(_28.x);
    _28.x *= 16.0f;
    _28.x = exp2(_28.x);
    _710.x = dot(-_140, _41.xyz);
    _710.x += _710.x;
    _710 = (_41.xyz * (-_710.xxx)) + (-_140);
    _710.x = dot(_710, float3(0.23999999463558197021484375f, 0.959999978542327880859375f, 0.14000000059604644775390625f));
    _710.x = clamp(_710.x, 0.0f, 1.0f);
    _710.x = log2(_710.x);
    _710.x *= 40.0f;
    _710.x = exp2(_710.x);
    _469 = (_65.xx * float2(0.64999997615814208984375f, 0.550000011920928955078125f)) + float2(0.3499999940395355224609375f, 0.449999988079071044921875f);
    _469.x = _28.x * _469.x;
    _469.x = (_710.x * 1.39999997615814208984375f) + _469.x;
    _780 = _469.x * _32_m18;
    _176 = vs_TEXCOORD0.www * _32_m17.xyz;
    _469.x = (_469.x * _32_m18) + _449.y;
    _469.x += 0.550000011920928955078125f;
    _780 *= vs_TEXCOORD0.w;
    _780 *= 0.5f;
    _176 = (_176 * _469.xxx) + _780.xxx;
    _65 = log2(_65);
    _65 *= _32_m20;
    _65 = exp2(_65);
    float3 _834 = _65.xxx * _32_m19.xyz;
    _449 = float4(_834.x, _834.y, _834.z, _449.w);
    _53 = (_449.xyz * _53.xxx) + _176;
    _176 = float3(float3(_32_m21, _32_m21, _32_m21)) * float3(1.60000002384185791015625f, 1.14999997615814208984375f, 2.0f);
    _53 = (_176 * _469.yyy) + _53;
    _53 += _91;
    _28.x = vs_TEXCOORD8;
    _28.x = clamp(_28.x, 0.0f, 1.0f);
    _710 = _53 + (-_32_m10.xyz);
    _28 = (_28.xxx * _710) + _32_m10.xyz;
    _892 = float4(_28.x, _28.y, _28.z, _892.w);
    _892.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    vs_TEXCOORD8 = stage_input.vs_TEXCOORD8;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._892 = _892;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _MainTex_ST;
float4 _DissolveHeight;
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
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m6 _GlobalVolumeMin
#define _22_m7 _GlobalVolumeInvSize
#define _22_m8 _MainTex_ST
#define _22_m9 _DissolveHeight


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float4 _93;
static float4 vs_TEXCOORD0;
static float2 _121;
static float4 vs_TEXCOORD1;
static float3 _190;
static float4 _225;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD7;
static float vs_TEXCOORD8;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _190 : NORMAL;
    float4 _225 : TANGENT;
    float2 _121 : TEXCOORD0;
    float4 _93 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD8 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 vs_TEXCOORD7 : TEXCOORD8;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float2 _92;
static bool _113;
static float _151;
static float3 _224;
static float3 _257;
static float3 _275;
static float4 _287;
static float4 _305;
static float4 _319;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    float3 _87 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_87.x, _87.y, _87.z, _9.w);
    _92.x = _93.y + _93.x;
    _92.x += _93.z;
    _113 = _92.x >= 2.9900000095367431640625f;
    float2 _131 = (_121 * _22_m8.xy) + _22_m8.zw;
    vs_TEXCOORD0 = float4(_131.x, _131.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _92 = _93.xy;
    _92 = clamp(_92, 0.0f.xx, 1.0f.xx);
    float2 _144;
    if (_113)
    {
        _144 = 0.0f.xx;
    }
    else
    {
        _144 = _92;
    }
    _92 = _144;
    _151 = _9.y + (-_22_m1[3].y);
    _151 += (-_22_m9.x);
    _51.x = (-_22_m9.x) + _22_m9.y;
    _51.x = max(_51.x, 0.001000000047497451305389404296875f);
    vs_TEXCOORD1.w = _151 / _51.x;
    vs_TEXCOORD1.w = clamp(vs_TEXCOORD1.w, 0.0f, 1.0f);
    _51.y = dot(_190, _22_m2[0].xyz);
    _51.z = dot(_190, _22_m2[1].xyz);
    _51.x = dot(_190, _22_m2[2].xyz);
    _151 = dot(_51.xyz, _51.xyz);
    _151 = rsqrt(_151);
    float3 _220 = _151.xxx * _51.yzx;
    _51 = float4(_220.x, _220.y, _220.z, _51.w);
    _224 = _225.yyy * _22_m1[1].yzx;
    _224 = (_22_m1[0].yzx * _225.xxx) + _224;
    _224 = (_22_m1[2].yzx * _225.zzz) + _224;
    _151 = dot(_224, _224);
    _151 = rsqrt(_151);
    _224 = _151.xxx * _224;
    _257 = _51.zxy * _224;
    _257 = (_51.yzx * _224.yzx) + (-_257);
    _151 = _225.w * _22_m3.w;
    _275 = _151.xxx * _257;
    _113 = 0.0f < _22_m7.x;
    if (_113)
    {
        float3 _295 = _9.xyz + (-_22_m6);
        _287 = float4(_295.x, _295.y, _295.z, _287.w);
        float3 _302 = _287.xyz * _22_m7;
        _287 = float4(_302.x, _302.y, _302.z, _287.w);
        _305 = _Volume0.SampleLevel(sampler_Volume0, _287.xyz, 0.0f);
        _319 = _Volume1.SampleLevel(sampler_Volume0, _287.xyz, 0.0f);
        _287 = _Volume2.SampleLevel(sampler_Volume0, _287.xyz, 0.0f);
        vs_TEXCOORD5.x = _319.x;
        vs_TEXCOORD5.y = _287.x;
        vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _305.wx.x, _305.wx.y);
        vs_TEXCOORD6 = float4(_319.yw.x, vs_TEXCOORD6.y, _319.yw.y, vs_TEXCOORD6.w);
        vs_TEXCOORD6.y = _287.y;
        vs_TEXCOORD6.w = _305.y;
        vs_TEXCOORD7.x = _319.z;
        vs_TEXCOORD7 = float4(vs_TEXCOORD7.x, _287.zw.x, _287.zw.y, vs_TEXCOORD7.w);
        vs_TEXCOORD7.w = _305.z;
    }
    else
    {
        vs_TEXCOORD5 = 0.0f.xxxx;
        vs_TEXCOORD6 = 0.0f.xxxx;
        vs_TEXCOORD7 = 0.0f.xxxx;
    }
    _151 = _45.z / _22_m0.y;
    _151 = (-_151) + 1.0f;
    _151 *= _22_m0.z;
    _151 = max(_151, 0.0f);
    _151 *= _22_m5.x;
    _151 *= (-_151);
    vs_TEXCOORD8 = exp2(_151);
    gl_Position = _45;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _92.x, _92.y);
    vs_TEXCOORD1 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, vs_TEXCOORD1.w);
    _9.x = _224.z;
    _9.y = _275.x;
    _9.z = _51.x;
    vs_TEXCOORD2 = _9.xyz;
    _9.x = _224.x;
    _9.y = _275.y;
    _9.z = _51.y;
    vs_TEXCOORD3 = _9.xyz;
    _51.x = _224.y;
    _51.y = _275.z;
    vs_TEXCOORD4 = _51.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _93 = stage_input._93;
    _121 = stage_input._121;
    _190 = stage_input._190;
    _225 = stage_input._225;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD8 = vs_TEXCOORD8;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
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
float4 _LightColor0;
float3 _GlobalVolumeInvSize;
float4 _Color;
float _BumpScale;
float4 _GoreColor;
float _GoreWetness;
float4 _GlowColor;
float _Sparkle;
float4 _RimColor;
float _RimPower;
float _HitFlash;
#define _32_m0 _Time
#define _32_m1 _WorldSpaceCameraPos
#define _32_m2 _WorldSpaceLightPos0
#define _32_m3 unity_SHAr
#define _32_m4 unity_SHAg
#define _32_m5 unity_SHAb
#define _32_m6 unity_SHBr
#define _32_m7 unity_SHBg
#define _32_m8 unity_SHBb
#define _32_m9 unity_SHC
#define _32_m10 unity_FogColor
#define _32_m11 _LightColor0
#define _32_m12 _GlobalVolumeInvSize
#define _32_m13 _Color
#define _32_m14 _BumpScale
#define _32_m15 _GoreColor
#define _32_m16 _GoreWetness
#define _32_m17 _GlowColor
#define _32_m18 _Sparkle
#define _32_m19 _RimColor
#define _32_m20 _RimPower
#define _32_m21 _HitFlash


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD7;
static float vs_TEXCOORD8;
static float4 _892;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD8 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 vs_TEXCOORD7 : TEXCOORD8;
};

struct SPIRV_Cross_Output
{
    float4 _892 : SV_Target0;
};

static float3 _9;
static float3 _28;
static float4 _41;
static float3 _53;
static float _65;
static float4 _73;
static float3 _91;
static float3 _124;
static float _134;
static float3 _140;
static float _145;
static float3 _176;
static bool3 _196;
static float3 _207;
static float3 _250;
static float3 _255;
static float3 _274;
static float3 _292;
static float3 _297;
static float3 _301;
static bool3 _330;
static bool _404;
static float4 _449;
static float2 _469;
static float _583;
static float3 _710;
static float _780;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _28 = _9 * _32_m13.xyz;
    float3 _50 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _41 = float4(_50.x, _50.y, _50.z, _41.w);
    _53.x = (-vs_TEXCOORD0.w) + 1.0f;
    _65 = _53.x * _32_m14;
    float3 _81 = (_41.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _73 = float4(_81.x, _81.y, _81.z, _73.w);
    float2 _88 = _65.xx * _73.xy;
    _73 = float4(_88.x, _88.y, _73.z, _73.w);
    _91.x = dot(vs_TEXCOORD2, _73.xyz);
    _91.y = dot(vs_TEXCOORD3, _73.xyz);
    _91.z = dot(vs_TEXCOORD4, _73.xyz);
    _65 = dot(_91, _91);
    _65 = rsqrt(_65);
    float3 _121 = _65.xxx * _91;
    _41 = float4(_121.x, _121.y, _121.z, _41.w);
    _124 = (-vs_TEXCOORD1.xyz) + _32_m1;
    _134 = dot(_124, _124);
    _134 = rsqrt(_134);
    _140 = _134.xxx * _124;
    _145 = dot(_41.xyz, _140);
    _145 = clamp(_145, 0.0f, 1.0f);
    _65 = (-_145) + 1.0f;
    float3 _166 = ((-_9) * _32_m13.xyz) + _32_m15.xyz;
    _73 = float4(_166.x, _166.y, _166.z, _73.w);
    _91 = (vs_TEXCOORD0.zzz * _73.xyz) + _28;
    _176 = (_32_m17.xyz * 0.0500000007450580596923828125f.xxx) + (-_91);
    _91 = (vs_TEXCOORD0.www * _176) + _91;
    _196.x = 0.0f < _32_m12.x;
    if (_196.x)
    {
        _207.x = dot(vs_TEXCOORD5.xyz, vs_TEXCOORD5.xyz);
        _207.x = sqrt(_207.x);
        _28.x = dot(vs_TEXCOORD6.xyz, vs_TEXCOORD6.xyz);
        _207.y = sqrt(_28.x);
        _28.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
        _207.z = sqrt(_28.x);
        _28.x = vs_TEXCOORD5.w;
        _28.y = vs_TEXCOORD6.w;
        _28.z = vs_TEXCOORD7.w;
        _250 = max(_28, 9.9999997473787516355514526367188e-06f.xxx);
        _255.x = dot(vs_TEXCOORD5.xyz, _41.xyz);
        _255.y = dot(vs_TEXCOORD6.xyz, _41.xyz);
        _255.z = dot(vs_TEXCOORD7.xyz, _41.xyz);
        _274 = max(_207, 9.9999999747524270787835121154785e-07f.xxx);
        _255 /= _274;
        _255 = (_255 * 0.5f.xxx) + 0.5f.xxx;
        _274 = _207 * 0.5f.xxx;
        _274 /= _250;
        _292 = (_274 * 2.0f.xxx) + 1.0f.xxx;
        _297 = (-_274) + 1.0f.xxx;
        _301 = _274 + 1.0f.xxx;
        _297 /= _301;
        _301 = (-_297) + 1.0f.xxx;
        _274 = (_274 * 2.0f.xxx) + 2.0f.xxx;
        _274 *= _301;
        _255 = max(_255, 9.9999999747524270787835121154785e-07f.xxx);
        _255 = log2(_255);
        _255 *= _292;
        _255 = exp2(_255);
        _255 = (_274 * _255) + _297;
        _330 = bool4(_28.xyzx.x >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).x, _28.xyzx.y >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).y, _28.xyzx.z >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).z, _28.xyzx.w >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).w).xyz;
        _274.x = float(_330.x);
        _274.y = float(_330.y);
        _274.z = float(_330.z);
        _196 = bool4(_207.xyzx.x >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).x, _207.xyzx.y >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).y, _207.xyzx.z >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).z, _207.xyzx.w >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).w).xyz;
        _207.x = float(_196.x);
        _207.y = float(_196.y);
        _207.z = float(_196.z);
        _207 *= _274;
        _250 = (_250 * _255) + (-_28);
        _207 = (_207 * _250) + _28;
        _207 = max(_207, 0.0f.xxx);
        _28 = vs_TEXCOORD6.xyz * 0.715200006961822509765625f.xxx;
        _28 = (vs_TEXCOORD5.xyz * 0.2125999927520751953125f.xxx) + _28;
        _28 = (vs_TEXCOORD7.xyz * 0.072200000286102294921875f.xxx) + _28;
        _145 = dot(_28, _28);
        _404 = 1.0000000133514319600180897396058e-10f < _145;
        _145 = rsqrt(_145);
        _28 = _145.xxx * _28;
        float3 _416;
        if (_404)
        {
            _416 = _28;
        }
        else
        {
            _416 = float3(0.0f, 1.0f, 0.0f);
        }
        _28 = _416;
        _9 = _207;
    }
    else
    {
        _41.w = 1.0f;
        _176.x = dot(_32_m3, _41);
        _176.y = dot(_32_m4, _41);
        _176.z = dot(_32_m5, _41);
        _73 = _41.yzzx * _41.xyzz;
        _449.x = dot(_32_m6, _73);
        _449.y = dot(_32_m7, _73);
        _449.z = dot(_32_m8, _73);
        _469.x = _41.y * _41.y;
        _469.x = (_41.x * _41.x) + (-_469.x);
        float3 _495 = (_32_m9.xyz * _469.xxx) + _449.xyz;
        _449 = float4(_495.x, _495.y, _495.z, _449.w);
        _9 = _176 + _449.xyz;
        _28.x = 0.0f;
        _28.y = 1.0f;
        _28.z = 0.0f;
    }
    _145 = dot(_32_m2.xyz, _32_m2.xyz);
    _145 = sqrt(_145);
    _404 = 9.9999997473787516355514526367188e-05f < _145;
    _250 = _32_m2.xyz / _145.xxx;
    float3 _525;
    if (_404)
    {
        _525 = _250;
    }
    else
    {
        _525 = float3(0.0f, 1.0f, 0.0f);
    }
    _250 = _525;
    _145 = dot(_41.xyz, _250);
    _145 = clamp(_145, 0.0f, 1.0f);
    _176 = (_32_m11.xyz * _145.xxx) + _9;
    _28 = (_124 * _134.xxx) + _28;
    _145 = dot(_28, _28);
    _145 = rsqrt(_145);
    _28 = _145.xxx * _28;
    _469.x = dot(_41.xyz, _28);
    _469.x = clamp(_469.x, 0.0f, 1.0f);
    _469.x = log2(_469.x);
    _469.x *= 80.0f;
    _469.x = exp2(_469.x);
    _583 = _65 * _65;
    float2 _592 = _583.xx * float2(0.1500000059604644775390625f, 0.89999997615814208984375f);
    _449 = float4(_592.x, _592.y, _449.z, _449.w);
    _469.x = (_469.x * 3.0f) + _449.x;
    _469.x *= vs_TEXCOORD0.z;
    _469.x *= _32_m16;
    float3 _619 = _176 * _469.xxx;
    _449 = float4(_619.x, _449.y, _619.y, _619.z);
    _91 = (_91 * _176) + _449.xzw;
    _176 = (_41.xyz * 3.0f.xxx) + 0.5f.xxx;
    _176 = floor(_176);
    _176 += 7.309999942779541015625f.xxx;
    _28 = _176 * float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
    _28 = frac(_28);
    _124 = _28.yxz + 33.3300018310546875f.xxx;
    _145 = dot(_28, _124);
    _28 = _145.xxx + _28;
    _28.x = _28.y + _28.x;
    _28.x = _28.z * _28.x;
    _28.x = frac(_28.x);
    _28.x *= 37.0f;
    _28.x = (_32_m0.y * 2.2999999523162841796875f) + _28.x;
    _28.x = sin(_28.x);
    _28.x = max(_28.x, 0.0f);
    _28.x = log2(_28.x);
    _28.x *= 16.0f;
    _28.x = exp2(_28.x);
    _710.x = dot(-_140, _41.xyz);
    _710.x += _710.x;
    _710 = (_41.xyz * (-_710.xxx)) + (-_140);
    _710.x = dot(_710, float3(0.23999999463558197021484375f, 0.959999978542327880859375f, 0.14000000059604644775390625f));
    _710.x = clamp(_710.x, 0.0f, 1.0f);
    _710.x = log2(_710.x);
    _710.x *= 40.0f;
    _710.x = exp2(_710.x);
    _469 = (_65.xx * float2(0.64999997615814208984375f, 0.550000011920928955078125f)) + float2(0.3499999940395355224609375f, 0.449999988079071044921875f);
    _469.x = _28.x * _469.x;
    _469.x = (_710.x * 1.39999997615814208984375f) + _469.x;
    _780 = _469.x * _32_m18;
    _176 = vs_TEXCOORD0.www * _32_m17.xyz;
    _469.x = (_469.x * _32_m18) + _449.y;
    _469.x += 0.550000011920928955078125f;
    _780 *= vs_TEXCOORD0.w;
    _780 *= 0.5f;
    _176 = (_176 * _469.xxx) + _780.xxx;
    _65 = log2(_65);
    _65 *= _32_m20;
    _65 = exp2(_65);
    float3 _834 = _65.xxx * _32_m19.xyz;
    _449 = float4(_834.x, _834.y, _834.z, _449.w);
    _53 = (_449.xyz * _53.xxx) + _176;
    _176 = float3(float3(_32_m21, _32_m21, _32_m21)) * float3(1.60000002384185791015625f, 1.14999997615814208984375f, 2.0f);
    _53 = (_176 * _469.yyy) + _53;
    _53 += _91;
    _28.x = vs_TEXCOORD8;
    _28.x = clamp(_28.x, 0.0f, 1.0f);
    _710 = _53 + (-_32_m10.xyz);
    _28 = (_28.xxx * _710) + _32_m10.xyz;
    _892 = float4(_28.x, _28.y, _28.z, _892.w);
    _892.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    vs_TEXCOORD8 = stage_input.vs_TEXCOORD8;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._892 = _892;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 unity_FogParams;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _MainTex_ST;
float4 _DissolveHeight;
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
    _22_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m3 unity_WorldTransformParams
#define _22_m5 unity_FogParams
#define _22_m6 _GlobalVolumeMin
#define _22_m7 _GlobalVolumeInvSize
#define _22_m8 _MainTex_ST
#define _22_m9 _DissolveHeight


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float4 _93;
static float4 vs_TEXCOORD0;
static float2 _121;
static float4 vs_TEXCOORD1;
static float3 _190;
static float4 _225;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD7;
static float vs_TEXCOORD8;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _190 : NORMAL;
    float4 _225 : TANGENT;
    float2 _121 : TEXCOORD0;
    float4 _93 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD8 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 vs_TEXCOORD7 : TEXCOORD8;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float2 _92;
static bool _113;
static float _151;
static float3 _224;
static float3 _257;
static float3 _275;
static float4 _287;
static float4 _305;
static float4 _319;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m4[1];
    _51 = (_22_m4[0] * _45.xxxx) + _51;
    _51 = (_22_m4[2] * _45.zzzz) + _51;
    _45 = (_22_m4[3] * _45.wwww) + _51;
    float3 _87 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_87.x, _87.y, _87.z, _9.w);
    _92.x = _93.y + _93.x;
    _92.x += _93.z;
    _113 = _92.x >= 2.9900000095367431640625f;
    float2 _131 = (_121 * _22_m8.xy) + _22_m8.zw;
    vs_TEXCOORD0 = float4(_131.x, _131.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _92 = _93.xy;
    _92 = clamp(_92, 0.0f.xx, 1.0f.xx);
    float2 _144;
    if (_113)
    {
        _144 = 0.0f.xx;
    }
    else
    {
        _144 = _92;
    }
    _92 = _144;
    _151 = _9.y + (-_22_m1[3].y);
    _151 += (-_22_m9.x);
    _51.x = (-_22_m9.x) + _22_m9.y;
    _51.x = max(_51.x, 0.001000000047497451305389404296875f);
    vs_TEXCOORD1.w = _151 / _51.x;
    vs_TEXCOORD1.w = clamp(vs_TEXCOORD1.w, 0.0f, 1.0f);
    _51.y = dot(_190, _22_m2[0].xyz);
    _51.z = dot(_190, _22_m2[1].xyz);
    _51.x = dot(_190, _22_m2[2].xyz);
    _151 = dot(_51.xyz, _51.xyz);
    _151 = rsqrt(_151);
    float3 _220 = _151.xxx * _51.yzx;
    _51 = float4(_220.x, _220.y, _220.z, _51.w);
    _224 = _225.yyy * _22_m1[1].yzx;
    _224 = (_22_m1[0].yzx * _225.xxx) + _224;
    _224 = (_22_m1[2].yzx * _225.zzz) + _224;
    _151 = dot(_224, _224);
    _151 = rsqrt(_151);
    _224 = _151.xxx * _224;
    _257 = _51.zxy * _224;
    _257 = (_51.yzx * _224.yzx) + (-_257);
    _151 = _225.w * _22_m3.w;
    _275 = _151.xxx * _257;
    _113 = 0.0f < _22_m7.x;
    if (_113)
    {
        float3 _295 = _9.xyz + (-_22_m6);
        _287 = float4(_295.x, _295.y, _295.z, _287.w);
        float3 _302 = _287.xyz * _22_m7;
        _287 = float4(_302.x, _302.y, _302.z, _287.w);
        _305 = _Volume0.SampleLevel(sampler_Volume0, _287.xyz, 0.0f);
        _319 = _Volume1.SampleLevel(sampler_Volume0, _287.xyz, 0.0f);
        _287 = _Volume2.SampleLevel(sampler_Volume0, _287.xyz, 0.0f);
        vs_TEXCOORD5.x = _319.x;
        vs_TEXCOORD5.y = _287.x;
        vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _305.wx.x, _305.wx.y);
        vs_TEXCOORD6 = float4(_319.yw.x, vs_TEXCOORD6.y, _319.yw.y, vs_TEXCOORD6.w);
        vs_TEXCOORD6.y = _287.y;
        vs_TEXCOORD6.w = _305.y;
        vs_TEXCOORD7.x = _319.z;
        vs_TEXCOORD7 = float4(vs_TEXCOORD7.x, _287.zw.x, _287.zw.y, vs_TEXCOORD7.w);
        vs_TEXCOORD7.w = _305.z;
    }
    else
    {
        vs_TEXCOORD5 = 0.0f.xxxx;
        vs_TEXCOORD6 = 0.0f.xxxx;
        vs_TEXCOORD7 = 0.0f.xxxx;
    }
    _151 = _45.z / _22_m0.y;
    _151 = (-_151) + 1.0f;
    _151 *= _22_m0.z;
    _151 = max(_151, 0.0f);
    vs_TEXCOORD8 = (_151 * _22_m5.z) + _22_m5.w;
    gl_Position = _45;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _92.x, _92.y);
    vs_TEXCOORD1 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, vs_TEXCOORD1.w);
    _9.x = _224.z;
    _9.y = _275.x;
    _9.z = _51.x;
    vs_TEXCOORD2 = _9.xyz;
    _9.x = _224.x;
    _9.y = _275.y;
    _9.z = _51.y;
    vs_TEXCOORD3 = _9.xyz;
    _51.x = _224.y;
    _51.y = _275.z;
    vs_TEXCOORD4 = _51.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _93 = stage_input._93;
    _121 = stage_input._121;
    _190 = stage_input._190;
    _225 = stage_input._225;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD8 = vs_TEXCOORD8;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
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
float4 _LightColor0;
float3 _GlobalVolumeInvSize;
float4 _Color;
float _BumpScale;
float4 _GoreColor;
float _GoreWetness;
float4 _GlowColor;
float _Sparkle;
float4 _RimColor;
float _RimPower;
float _HitFlash;
#define _32_m0 _Time
#define _32_m1 _WorldSpaceCameraPos
#define _32_m2 _WorldSpaceLightPos0
#define _32_m3 unity_SHAr
#define _32_m4 unity_SHAg
#define _32_m5 unity_SHAb
#define _32_m6 unity_SHBr
#define _32_m7 unity_SHBg
#define _32_m8 unity_SHBb
#define _32_m9 unity_SHC
#define _32_m10 unity_FogColor
#define _32_m11 _LightColor0
#define _32_m12 _GlobalVolumeInvSize
#define _32_m13 _Color
#define _32_m14 _BumpScale
#define _32_m15 _GoreColor
#define _32_m16 _GoreWetness
#define _32_m17 _GlowColor
#define _32_m18 _Sparkle
#define _32_m19 _RimColor
#define _32_m20 _RimPower
#define _32_m21 _HitFlash


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD7;
static float vs_TEXCOORD8;
static float4 _892;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD8 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 vs_TEXCOORD6 : TEXCOORD7;
    float4 vs_TEXCOORD7 : TEXCOORD8;
};

struct SPIRV_Cross_Output
{
    float4 _892 : SV_Target0;
};

static float3 _9;
static float3 _28;
static float4 _41;
static float3 _53;
static float _65;
static float4 _73;
static float3 _91;
static float3 _124;
static float _134;
static float3 _140;
static float _145;
static float3 _176;
static bool3 _196;
static float3 _207;
static float3 _250;
static float3 _255;
static float3 _274;
static float3 _292;
static float3 _297;
static float3 _301;
static bool3 _330;
static bool _404;
static float4 _449;
static float2 _469;
static float _583;
static float3 _710;
static float _780;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _28 = _9 * _32_m13.xyz;
    float3 _50 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _41 = float4(_50.x, _50.y, _50.z, _41.w);
    _53.x = (-vs_TEXCOORD0.w) + 1.0f;
    _65 = _53.x * _32_m14;
    float3 _81 = (_41.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _73 = float4(_81.x, _81.y, _81.z, _73.w);
    float2 _88 = _65.xx * _73.xy;
    _73 = float4(_88.x, _88.y, _73.z, _73.w);
    _91.x = dot(vs_TEXCOORD2, _73.xyz);
    _91.y = dot(vs_TEXCOORD3, _73.xyz);
    _91.z = dot(vs_TEXCOORD4, _73.xyz);
    _65 = dot(_91, _91);
    _65 = rsqrt(_65);
    float3 _121 = _65.xxx * _91;
    _41 = float4(_121.x, _121.y, _121.z, _41.w);
    _124 = (-vs_TEXCOORD1.xyz) + _32_m1;
    _134 = dot(_124, _124);
    _134 = rsqrt(_134);
    _140 = _134.xxx * _124;
    _145 = dot(_41.xyz, _140);
    _145 = clamp(_145, 0.0f, 1.0f);
    _65 = (-_145) + 1.0f;
    float3 _166 = ((-_9) * _32_m13.xyz) + _32_m15.xyz;
    _73 = float4(_166.x, _166.y, _166.z, _73.w);
    _91 = (vs_TEXCOORD0.zzz * _73.xyz) + _28;
    _176 = (_32_m17.xyz * 0.0500000007450580596923828125f.xxx) + (-_91);
    _91 = (vs_TEXCOORD0.www * _176) + _91;
    _196.x = 0.0f < _32_m12.x;
    if (_196.x)
    {
        _207.x = dot(vs_TEXCOORD5.xyz, vs_TEXCOORD5.xyz);
        _207.x = sqrt(_207.x);
        _28.x = dot(vs_TEXCOORD6.xyz, vs_TEXCOORD6.xyz);
        _207.y = sqrt(_28.x);
        _28.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
        _207.z = sqrt(_28.x);
        _28.x = vs_TEXCOORD5.w;
        _28.y = vs_TEXCOORD6.w;
        _28.z = vs_TEXCOORD7.w;
        _250 = max(_28, 9.9999997473787516355514526367188e-06f.xxx);
        _255.x = dot(vs_TEXCOORD5.xyz, _41.xyz);
        _255.y = dot(vs_TEXCOORD6.xyz, _41.xyz);
        _255.z = dot(vs_TEXCOORD7.xyz, _41.xyz);
        _274 = max(_207, 9.9999999747524270787835121154785e-07f.xxx);
        _255 /= _274;
        _255 = (_255 * 0.5f.xxx) + 0.5f.xxx;
        _274 = _207 * 0.5f.xxx;
        _274 /= _250;
        _292 = (_274 * 2.0f.xxx) + 1.0f.xxx;
        _297 = (-_274) + 1.0f.xxx;
        _301 = _274 + 1.0f.xxx;
        _297 /= _301;
        _301 = (-_297) + 1.0f.xxx;
        _274 = (_274 * 2.0f.xxx) + 2.0f.xxx;
        _274 *= _301;
        _255 = max(_255, 9.9999999747524270787835121154785e-07f.xxx);
        _255 = log2(_255);
        _255 *= _292;
        _255 = exp2(_255);
        _255 = (_274 * _255) + _297;
        _330 = bool4(_28.xyzx.x >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).x, _28.xyzx.y >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).y, _28.xyzx.z >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).z, _28.xyzx.w >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).w).xyz;
        _274.x = float(_330.x);
        _274.y = float(_330.y);
        _274.z = float(_330.z);
        _196 = bool4(_207.xyzx.x >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).x, _207.xyzx.y >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).y, _207.xyzx.z >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).z, _207.xyzx.w >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).w).xyz;
        _207.x = float(_196.x);
        _207.y = float(_196.y);
        _207.z = float(_196.z);
        _207 *= _274;
        _250 = (_250 * _255) + (-_28);
        _207 = (_207 * _250) + _28;
        _207 = max(_207, 0.0f.xxx);
        _28 = vs_TEXCOORD6.xyz * 0.715200006961822509765625f.xxx;
        _28 = (vs_TEXCOORD5.xyz * 0.2125999927520751953125f.xxx) + _28;
        _28 = (vs_TEXCOORD7.xyz * 0.072200000286102294921875f.xxx) + _28;
        _145 = dot(_28, _28);
        _404 = 1.0000000133514319600180897396058e-10f < _145;
        _145 = rsqrt(_145);
        _28 = _145.xxx * _28;
        float3 _416;
        if (_404)
        {
            _416 = _28;
        }
        else
        {
            _416 = float3(0.0f, 1.0f, 0.0f);
        }
        _28 = _416;
        _9 = _207;
    }
    else
    {
        _41.w = 1.0f;
        _176.x = dot(_32_m3, _41);
        _176.y = dot(_32_m4, _41);
        _176.z = dot(_32_m5, _41);
        _73 = _41.yzzx * _41.xyzz;
        _449.x = dot(_32_m6, _73);
        _449.y = dot(_32_m7, _73);
        _449.z = dot(_32_m8, _73);
        _469.x = _41.y * _41.y;
        _469.x = (_41.x * _41.x) + (-_469.x);
        float3 _495 = (_32_m9.xyz * _469.xxx) + _449.xyz;
        _449 = float4(_495.x, _495.y, _495.z, _449.w);
        _9 = _176 + _449.xyz;
        _28.x = 0.0f;
        _28.y = 1.0f;
        _28.z = 0.0f;
    }
    _145 = dot(_32_m2.xyz, _32_m2.xyz);
    _145 = sqrt(_145);
    _404 = 9.9999997473787516355514526367188e-05f < _145;
    _250 = _32_m2.xyz / _145.xxx;
    float3 _525;
    if (_404)
    {
        _525 = _250;
    }
    else
    {
        _525 = float3(0.0f, 1.0f, 0.0f);
    }
    _250 = _525;
    _145 = dot(_41.xyz, _250);
    _145 = clamp(_145, 0.0f, 1.0f);
    _176 = (_32_m11.xyz * _145.xxx) + _9;
    _28 = (_124 * _134.xxx) + _28;
    _145 = dot(_28, _28);
    _145 = rsqrt(_145);
    _28 = _145.xxx * _28;
    _469.x = dot(_41.xyz, _28);
    _469.x = clamp(_469.x, 0.0f, 1.0f);
    _469.x = log2(_469.x);
    _469.x *= 80.0f;
    _469.x = exp2(_469.x);
    _583 = _65 * _65;
    float2 _592 = _583.xx * float2(0.1500000059604644775390625f, 0.89999997615814208984375f);
    _449 = float4(_592.x, _592.y, _449.z, _449.w);
    _469.x = (_469.x * 3.0f) + _449.x;
    _469.x *= vs_TEXCOORD0.z;
    _469.x *= _32_m16;
    float3 _619 = _176 * _469.xxx;
    _449 = float4(_619.x, _449.y, _619.y, _619.z);
    _91 = (_91 * _176) + _449.xzw;
    _176 = (_41.xyz * 3.0f.xxx) + 0.5f.xxx;
    _176 = floor(_176);
    _176 += 7.309999942779541015625f.xxx;
    _28 = _176 * float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
    _28 = frac(_28);
    _124 = _28.yxz + 33.3300018310546875f.xxx;
    _145 = dot(_28, _124);
    _28 = _145.xxx + _28;
    _28.x = _28.y + _28.x;
    _28.x = _28.z * _28.x;
    _28.x = frac(_28.x);
    _28.x *= 37.0f;
    _28.x = (_32_m0.y * 2.2999999523162841796875f) + _28.x;
    _28.x = sin(_28.x);
    _28.x = max(_28.x, 0.0f);
    _28.x = log2(_28.x);
    _28.x *= 16.0f;
    _28.x = exp2(_28.x);
    _710.x = dot(-_140, _41.xyz);
    _710.x += _710.x;
    _710 = (_41.xyz * (-_710.xxx)) + (-_140);
    _710.x = dot(_710, float3(0.23999999463558197021484375f, 0.959999978542327880859375f, 0.14000000059604644775390625f));
    _710.x = clamp(_710.x, 0.0f, 1.0f);
    _710.x = log2(_710.x);
    _710.x *= 40.0f;
    _710.x = exp2(_710.x);
    _469 = (_65.xx * float2(0.64999997615814208984375f, 0.550000011920928955078125f)) + float2(0.3499999940395355224609375f, 0.449999988079071044921875f);
    _469.x = _28.x * _469.x;
    _469.x = (_710.x * 1.39999997615814208984375f) + _469.x;
    _780 = _469.x * _32_m18;
    _176 = vs_TEXCOORD0.www * _32_m17.xyz;
    _469.x = (_469.x * _32_m18) + _449.y;
    _469.x += 0.550000011920928955078125f;
    _780 *= vs_TEXCOORD0.w;
    _780 *= 0.5f;
    _176 = (_176 * _469.xxx) + _780.xxx;
    _65 = log2(_65);
    _65 *= _32_m20;
    _65 = exp2(_65);
    float3 _834 = _65.xxx * _32_m19.xyz;
    _449 = float4(_834.x, _834.y, _834.z, _449.w);
    _53 = (_449.xyz * _53.xxx) + _176;
    _176 = float3(float3(_32_m21, _32_m21, _32_m21)) * float3(1.60000002384185791015625f, 1.14999997615814208984375f, 2.0f);
    _53 = (_176 * _469.yyy) + _53;
    _53 += _91;
    _28.x = vs_TEXCOORD8;
    _28.x = clamp(_28.x, 0.0f, 1.0f);
    _710 = _53 + (-_32_m10.xyz);
    _28 = (_28.xxx * _710) + _32_m10.xyz;
    _892 = float4(_28.x, _28.y, _28.z, _892.w);
    _892.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    vs_TEXCOORD8 = stage_input.vs_TEXCOORD8;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._892 = _892;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _MainTex_ST;
float4 _DissolveHeight;
void __unity_init()
{
    _22_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m2 unity_WorldTransformParams
#define _22_m4 _GlobalVolumeMin
#define _22_m5 _GlobalVolumeInvSize
#define _22_m6 _MainTex_ST
#define _22_m7 _DissolveHeight


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float4 _99;
static float4 vs_TEXCOORD0;
static float2 _125;
static float4 vs_TEXCOORD1;
static float3 _194;
static float4 _227;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD7;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _194 : NORMAL;
    float4 _227 : TANGENT;
    float2 _125 : TEXCOORD0;
    float4 _99 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 vs_TEXCOORD7 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float2 _98;
static bool _118;
static float _155;
static float3 _273;
static float3 _292;
static float4 _304;
static float4 _322;
static float4 _336;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m0[1];
    _9 = (_22_m0[0] * _11.xxxx) + _9;
    _9 = (_22_m0[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m0[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    gl_Position = (_22_m3[3] * _45.wwww) + _51;
    float3 _93 = (_22_m0[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_93.x, _93.y, _93.z, _9.w);
    _98.x = _99.y + _99.x;
    _98.x += _99.z;
    _118 = _98.x >= 2.9900000095367431640625f;
    float2 _135 = (_125 * _22_m6.xy) + _22_m6.zw;
    vs_TEXCOORD0 = float4(_135.x, _135.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _98 = _99.xy;
    _98 = clamp(_98, 0.0f.xx, 1.0f.xx);
    float2 _148;
    if (_118)
    {
        _148 = 0.0f.xx;
    }
    else
    {
        _148 = _98;
    }
    _98 = _148;
    _155 = _9.y + (-_22_m0[3].y);
    _155 += (-_22_m7.x);
    _45.x = (-_22_m7.x) + _22_m7.y;
    _45.x = max(_45.x, 0.001000000047497451305389404296875f);
    vs_TEXCOORD1.w = _155 / _45.x;
    vs_TEXCOORD1.w = clamp(vs_TEXCOORD1.w, 0.0f, 1.0f);
    _45.y = dot(_194, _22_m1[0].xyz);
    _45.z = dot(_194, _22_m1[1].xyz);
    _45.x = dot(_194, _22_m1[2].xyz);
    _155 = dot(_45.xyz, _45.xyz);
    _155 = rsqrt(_155);
    float3 _224 = _155.xxx * _45.yzx;
    _45 = float4(_224.x, _224.y, _224.z, _45.w);
    float3 _233 = _227.yyy * _22_m0[1].yzx;
    _51 = float4(_233.x, _233.y, _233.z, _51.w);
    float3 _244 = (_22_m0[0].yzx * _227.xxx) + _51.xyz;
    _51 = float4(_244.x, _244.y, _244.z, _51.w);
    float3 _255 = (_22_m0[2].yzx * _227.zzz) + _51.xyz;
    _51 = float4(_255.x, _255.y, _255.z, _51.w);
    _155 = dot(_51.xyz, _51.xyz);
    _155 = rsqrt(_155);
    float3 _269 = _155.xxx * _51.xyz;
    _51 = float4(_269.x, _269.y, _269.z, _51.w);
    _273 = _45.zxy * _51.xyz;
    _273 = (_45.yzx * _51.yzx) + (-_273);
    _155 = _227.w * _22_m2.w;
    _292 = _155.xxx * _273;
    _118 = 0.0f < _22_m5.x;
    if (_118)
    {
        float3 _312 = _9.xyz + (-_22_m4);
        _304 = float4(_312.x, _312.y, _312.z, _304.w);
        float3 _319 = _304.xyz * _22_m5;
        _304 = float4(_319.x, _319.y, _319.z, _304.w);
        _322 = _Volume0.SampleLevel(sampler_Volume0, _304.xyz, 0.0f);
        _336 = _Volume1.SampleLevel(sampler_Volume0, _304.xyz, 0.0f);
        _304 = _Volume2.SampleLevel(sampler_Volume0, _304.xyz, 0.0f);
        vs_TEXCOORD5.x = _336.x;
        vs_TEXCOORD5.y = _304.x;
        vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _322.wx.x, _322.wx.y);
        vs_TEXCOORD6 = float4(_336.yw.x, vs_TEXCOORD6.y, _336.yw.y, vs_TEXCOORD6.w);
        vs_TEXCOORD6.y = _304.y;
        vs_TEXCOORD6.w = _322.y;
        vs_TEXCOORD7.x = _336.z;
        vs_TEXCOORD7 = float4(vs_TEXCOORD7.x, _304.zw.x, _304.zw.y, vs_TEXCOORD7.w);
        vs_TEXCOORD7.w = _322.z;
    }
    else
    {
        vs_TEXCOORD5 = 0.0f.xxxx;
        vs_TEXCOORD6 = 0.0f.xxxx;
        vs_TEXCOORD7 = 0.0f.xxxx;
    }
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _98.x, _98.y);
    vs_TEXCOORD1 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, vs_TEXCOORD1.w);
    _9.x = _51.z;
    _9.y = _292.x;
    _9.z = _45.x;
    vs_TEXCOORD2 = _9.xyz;
    _9.x = _51.x;
    _9.y = _292.y;
    _9.z = _45.y;
    vs_TEXCOORD3 = _9.xyz;
    _45.x = _51.y;
    _45.y = _292.z;
    vs_TEXCOORD4 = _45.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _125 = stage_input._125;
    _194 = stage_input._194;
    _227 = stage_input._227;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 _LightColor0;
float3 _GlobalVolumeInvSize;
float4 _Color;
float _BumpScale;
float4 _GoreColor;
float _GoreWetness;
float4 _GlowColor;
float _Sparkle;
float4 _RimColor;
float _RimPower;
float _HitFlash;
#define _32_m0 _Time
#define _32_m1 _WorldSpaceCameraPos
#define _32_m2 _WorldSpaceLightPos0
#define _32_m3 unity_SHAr
#define _32_m4 unity_SHAg
#define _32_m5 unity_SHAb
#define _32_m6 unity_SHBr
#define _32_m7 unity_SHBg
#define _32_m8 unity_SHBb
#define _32_m9 unity_SHC
#define _32_m10 _LightColor0
#define _32_m11 _GlobalVolumeInvSize
#define _32_m12 _Color
#define _32_m13 _BumpScale
#define _32_m14 _GoreColor
#define _32_m15 _GoreWetness
#define _32_m16 _GlowColor
#define _32_m17 _Sparkle
#define _32_m18 _RimColor
#define _32_m19 _RimPower
#define _32_m20 _HitFlash


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD5;
static float4 vs_TEXCOORD6;
static float4 vs_TEXCOORD7;
static float4 _867;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 vs_TEXCOORD6 : TEXCOORD6;
    float4 vs_TEXCOORD7 : TEXCOORD7;
};

struct SPIRV_Cross_Output
{
    float4 _867 : SV_Target0;
};

static float3 _9;
static float3 _28;
static float4 _41;
static float3 _53;
static float _65;
static float4 _73;
static float3 _91;
static float3 _124;
static float _134;
static float3 _140;
static float _145;
static float3 _176;
static bool3 _196;
static float3 _207;
static float3 _250;
static float3 _255;
static float3 _274;
static float3 _292;
static float3 _297;
static float3 _301;
static bool3 _330;
static bool _404;
static float4 _449;
static float2 _469;
static float _583;
static float3 _710;
static float _780;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _28 = _9 * _32_m12.xyz;
    float3 _50 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0.xy)).xyz;
    _41 = float4(_50.x, _50.y, _50.z, _41.w);
    _53.x = (-vs_TEXCOORD0.w) + 1.0f;
    _65 = _53.x * _32_m13;
    float3 _81 = (_41.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _73 = float4(_81.x, _81.y, _81.z, _73.w);
    float2 _88 = _65.xx * _73.xy;
    _73 = float4(_88.x, _88.y, _73.z, _73.w);
    _91.x = dot(vs_TEXCOORD2, _73.xyz);
    _91.y = dot(vs_TEXCOORD3, _73.xyz);
    _91.z = dot(vs_TEXCOORD4, _73.xyz);
    _65 = dot(_91, _91);
    _65 = rsqrt(_65);
    float3 _121 = _65.xxx * _91;
    _41 = float4(_121.x, _121.y, _121.z, _41.w);
    _124 = (-vs_TEXCOORD1.xyz) + _32_m1;
    _134 = dot(_124, _124);
    _134 = rsqrt(_134);
    _140 = _134.xxx * _124;
    _145 = dot(_41.xyz, _140);
    _145 = clamp(_145, 0.0f, 1.0f);
    _65 = (-_145) + 1.0f;
    float3 _166 = ((-_9) * _32_m12.xyz) + _32_m14.xyz;
    _73 = float4(_166.x, _166.y, _166.z, _73.w);
    _91 = (vs_TEXCOORD0.zzz * _73.xyz) + _28;
    _176 = (_32_m16.xyz * 0.0500000007450580596923828125f.xxx) + (-_91);
    _91 = (vs_TEXCOORD0.www * _176) + _91;
    _196.x = 0.0f < _32_m11.x;
    if (_196.x)
    {
        _207.x = dot(vs_TEXCOORD5.xyz, vs_TEXCOORD5.xyz);
        _207.x = sqrt(_207.x);
        _28.x = dot(vs_TEXCOORD6.xyz, vs_TEXCOORD6.xyz);
        _207.y = sqrt(_28.x);
        _28.x = dot(vs_TEXCOORD7.xyz, vs_TEXCOORD7.xyz);
        _207.z = sqrt(_28.x);
        _28.x = vs_TEXCOORD5.w;
        _28.y = vs_TEXCOORD6.w;
        _28.z = vs_TEXCOORD7.w;
        _250 = max(_28, 9.9999997473787516355514526367188e-06f.xxx);
        _255.x = dot(vs_TEXCOORD5.xyz, _41.xyz);
        _255.y = dot(vs_TEXCOORD6.xyz, _41.xyz);
        _255.z = dot(vs_TEXCOORD7.xyz, _41.xyz);
        _274 = max(_207, 9.9999999747524270787835121154785e-07f.xxx);
        _255 /= _274;
        _255 = (_255 * 0.5f.xxx) + 0.5f.xxx;
        _274 = _207 * 0.5f.xxx;
        _274 /= _250;
        _292 = (_274 * 2.0f.xxx) + 1.0f.xxx;
        _297 = (-_274) + 1.0f.xxx;
        _301 = _274 + 1.0f.xxx;
        _297 /= _301;
        _301 = (-_297) + 1.0f.xxx;
        _274 = (_274 * 2.0f.xxx) + 2.0f.xxx;
        _274 *= _301;
        _255 = max(_255, 9.9999999747524270787835121154785e-07f.xxx);
        _255 = log2(_255);
        _255 *= _292;
        _255 = exp2(_255);
        _255 = (_274 * _255) + _297;
        _330 = bool4(_28.xyzx.x >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).x, _28.xyzx.y >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).y, _28.xyzx.z >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).z, _28.xyzx.w >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).w).xyz;
        _274.x = float(_330.x);
        _274.y = float(_330.y);
        _274.z = float(_330.z);
        _196 = bool4(_207.xyzx.x >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).x, _207.xyzx.y >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).y, _207.xyzx.z >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).z, _207.xyzx.w >= float4(9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 9.9999999747524270787835121154785e-07f, 0.0f).w).xyz;
        _207.x = float(_196.x);
        _207.y = float(_196.y);
        _207.z = float(_196.z);
        _207 *= _274;
        _250 = (_250 * _255) + (-_28);
        _207 = (_207 * _250) + _28;
        _207 = max(_207, 0.0f.xxx);
        _28 = vs_TEXCOORD6.xyz * 0.715200006961822509765625f.xxx;
        _28 = (vs_TEXCOORD5.xyz * 0.2125999927520751953125f.xxx) + _28;
        _28 = (vs_TEXCOORD7.xyz * 0.072200000286102294921875f.xxx) + _28;
        _145 = dot(_28, _28);
        _404 = 1.0000000133514319600180897396058e-10f < _145;
        _145 = rsqrt(_145);
        _28 = _145.xxx * _28;
        float3 _416;
        if (_404)
        {
            _416 = _28;
        }
        else
        {
            _416 = float3(0.0f, 1.0f, 0.0f);
        }
        _28 = _416;
        _9 = _207;
    }
    else
    {
        _41.w = 1.0f;
        _176.x = dot(_32_m3, _41);
        _176.y = dot(_32_m4, _41);
        _176.z = dot(_32_m5, _41);
        _73 = _41.yzzx * _41.xyzz;
        _449.x = dot(_32_m6, _73);
        _449.y = dot(_32_m7, _73);
        _449.z = dot(_32_m8, _73);
        _469.x = _41.y * _41.y;
        _469.x = (_41.x * _41.x) + (-_469.x);
        float3 _495 = (_32_m9.xyz * _469.xxx) + _449.xyz;
        _449 = float4(_495.x, _495.y, _495.z, _449.w);
        _9 = _176 + _449.xyz;
        _28.x = 0.0f;
        _28.y = 1.0f;
        _28.z = 0.0f;
    }
    _145 = dot(_32_m2.xyz, _32_m2.xyz);
    _145 = sqrt(_145);
    _404 = 9.9999997473787516355514526367188e-05f < _145;
    _250 = _32_m2.xyz / _145.xxx;
    float3 _525;
    if (_404)
    {
        _525 = _250;
    }
    else
    {
        _525 = float3(0.0f, 1.0f, 0.0f);
    }
    _250 = _525;
    _145 = dot(_41.xyz, _250);
    _145 = clamp(_145, 0.0f, 1.0f);
    _176 = (_32_m10.xyz * _145.xxx) + _9;
    _28 = (_124 * _134.xxx) + _28;
    _145 = dot(_28, _28);
    _145 = rsqrt(_145);
    _28 = _145.xxx * _28;
    _469.x = dot(_41.xyz, _28);
    _469.x = clamp(_469.x, 0.0f, 1.0f);
    _469.x = log2(_469.x);
    _469.x *= 80.0f;
    _469.x = exp2(_469.x);
    _583 = _65 * _65;
    float2 _592 = _583.xx * float2(0.1500000059604644775390625f, 0.89999997615814208984375f);
    _449 = float4(_592.x, _592.y, _449.z, _449.w);
    _469.x = (_469.x * 3.0f) + _449.x;
    _469.x *= vs_TEXCOORD0.z;
    _469.x *= _32_m15;
    float3 _619 = _176 * _469.xxx;
    _449 = float4(_619.x, _449.y, _619.y, _619.z);
    _91 = (_91 * _176) + _449.xzw;
    _176 = (_41.xyz * 3.0f.xxx) + 0.5f.xxx;
    _176 = floor(_176);
    _176 += 7.309999942779541015625f.xxx;
    _28 = _176 * float3(0.103100001811981201171875f, 0.10300000011920928955078125f, 0.097300000488758087158203125f);
    _28 = frac(_28);
    _124 = _28.yxz + 33.3300018310546875f.xxx;
    _145 = dot(_28, _124);
    _28 = _145.xxx + _28;
    _28.x = _28.y + _28.x;
    _28.x = _28.z * _28.x;
    _28.x = frac(_28.x);
    _28.x *= 37.0f;
    _28.x = (_32_m0.y * 2.2999999523162841796875f) + _28.x;
    _28.x = sin(_28.x);
    _28.x = max(_28.x, 0.0f);
    _28.x = log2(_28.x);
    _28.x *= 16.0f;
    _28.x = exp2(_28.x);
    _710.x = dot(-_140, _41.xyz);
    _710.x += _710.x;
    _710 = (_41.xyz * (-_710.xxx)) + (-_140);
    _710.x = dot(_710, float3(0.23999999463558197021484375f, 0.959999978542327880859375f, 0.14000000059604644775390625f));
    _710.x = clamp(_710.x, 0.0f, 1.0f);
    _710.x = log2(_710.x);
    _710.x *= 40.0f;
    _710.x = exp2(_710.x);
    _469 = (_65.xx * float2(0.64999997615814208984375f, 0.550000011920928955078125f)) + float2(0.3499999940395355224609375f, 0.449999988079071044921875f);
    _469.x = _28.x * _469.x;
    _469.x = (_710.x * 1.39999997615814208984375f) + _469.x;
    _780 = _469.x * _32_m17;
    _176 = vs_TEXCOORD0.www * _32_m16.xyz;
    _469.x = (_469.x * _32_m17) + _449.y;
    _469.x += 0.550000011920928955078125f;
    _780 *= vs_TEXCOORD0.w;
    _780 *= 0.5f;
    _176 = (_176 * _469.xxx) + _780.xxx;
    _65 = log2(_65);
    _65 *= _32_m19;
    _65 = exp2(_65);
    float3 _834 = _65.xxx * _32_m18.xyz;
    _449 = float4(_834.x, _834.y, _834.z, _449.w);
    _53 = (_449.xyz * _53.xxx) + _176;
    _176 = float3(float3(_32_m20, _32_m20, _32_m20)) * float3(1.60000002384185791015625f, 1.14999997615814208984375f, 2.0f);
    _53 = (_176 * _469.yyy) + _53;
    float3 _870 = _53 + _91;
    _867 = float4(_870.x, _870.y, _870.z, _867.w);
    _867.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._867 = _867;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}