// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MimicTransform" {
Properties {

_Morph ("Morph (0 player   1 monster)", Range(0, 1)) = 0.0

[Header(Player Skin)] _MainTex ("Player Albedo", 2D) = "white" { }

_BumpMap ("Player Normal", 2D) = "bump" { }

[Header(Monster Skin)] _MonsterTex ("Monster Albedo", 2D) = "white" { }

_MonsterBumpMap ("Monster Normal", 2D) = "bump" { }

_BumpScale ("Normal Strength", Range(0, 2)) = 1.0

[Toggle(_MIMIC_MONSTERONLY)] _MonsterOnly ("Monster Skin Only (kill model)", Float) = 0.0

[Header(Bakery)] [Toggle(BAKERY_VOLUME)] _BAKERY_VOLUME ("Use Bakery Volume", Float) = 1.0

_VolumeMin ("Volume Min", Vector) = (0,0,0,1)

_VolumeInvSize ("Volume Inv Size", Vector) = (1000000.0,1000000.0,1000000.0,1)

}
SubShader {
 LOD 250
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
 Name "MIMIC_FORWARD"
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
#pragma multi_compile_local __ _MIMIC_MONSTERONLY
#if defined(BAKERY_VOLUME) && defined(FOG_EXP) && defined(_MIMIC_MONSTERONLY)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _141;
static float3 _153;
static float4 _187;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _153 : NORMAL;
    float4 _187 : TANGENT;
    float2 _141 : TEXCOORD0;
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
static float4 _44;
static float _172;
static float3 _233;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m5.y;
    vs_TEXCOORD5 = exp2(-_9.x);
    vs_TEXCOORD0 = (_141 * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_153, _21_m2[0].xyz);
    _9.z = dot(_153, _21_m2[1].xyz);
    _9.x = dot(_153, _21_m2[2].xyz);
    _172 = dot(_9.xyz, _9.xyz);
    _172 = rsqrt(_172);
    float3 _184 = _172.xxx * _9.xyz;
    _9 = float4(_184.x, _184.y, _184.z, _9.w);
    float3 _193 = _187.yyy * _21_m1[1].yzx;
    _44 = float4(_193.x, _193.y, _193.z, _44.w);
    float3 _204 = (_21_m1[0].yzx * _187.xxx) + _44.xyz;
    _44 = float4(_204.x, _204.y, _204.z, _44.w);
    float3 _215 = (_21_m1[2].yzx * _187.zzz) + _44.xyz;
    _44 = float4(_215.x, _215.y, _215.z, _44.w);
    _172 = dot(_44.xyz, _44.xyz);
    _172 = rsqrt(_172);
    float3 _229 = _172.xxx * _44.xyz;
    _44 = float4(_229.x, _229.y, _229.z, _44.w);
    _233 = _9.xyz * _44.xyz;
    _233 = (_9.zxy * _44.yzx) + (-_233);
    _233 *= _187.www;
    _233 *= _21_m3.www;
    vs_TEXCOORD2.y = _233.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _233.y;
    vs_TEXCOORD4.y = _233.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _153 = stage_input._153;
    _187 = stage_input._187;
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
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float _BumpScale;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _42_m0 _WorldSpaceLightPos0
#define _42_m1 unity_FogColor
#define _42_m2 _LightColor0
#define _42_m3 _BumpScale
#define _42_m4 _VolumeMin
#define _42_m5 _VolumeInvSize
#define _42_m6 _GlobalVolumeMin
#define _42_m7 _GlobalVolumeInvSize


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float4 _552;

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
    float4 _552 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float3 _52;
static float _77;
static bool _89;
static float3 _95;
static float4 _110;
static float4 _151;
static float4 _159;
static float3 _173;
static float3 _182;
static float _191;
static float3 _278;
static float _287;
static float2 _404;
static bool _479;
static float3 _511;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    float3 _35 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _28 = float4(_35.x, _35.y, _35.z, _28.w);
    float2 _49 = _28.xy * _42_m3.xx;
    _28 = float4(_49.x, _49.y, _28.z, _28.w);
    _52.x = dot(vs_TEXCOORD2, _28.xyz);
    _52.y = dot(vs_TEXCOORD3, _28.xyz);
    _52.z = dot(vs_TEXCOORD4, _28.xyz);
    _77 = dot(_52, _52);
    _77 = rsqrt(_77);
    _52 = _77.xxx * _52;
    _89 = 1000000.0f < _42_m5.x;
    float3 _98;
    if (_89)
    {
        _98 = _42_m6;
    }
    else
    {
        _98 = _42_m4;
    }
    _95 = _98;
    float3 _112;
    if (_89)
    {
        _112 = _42_m7;
    }
    else
    {
        _112 = _42_m5;
    }
    _110 = float4(_112.x, _112.y, _112.z, _110.w);
    _95 = (-_95) + vs_TEXCOORD1;
    _95 = _110.xyz * _95;
    _28 = _Volume0.Sample(sampler_Volume0, _95).xywz;
    float3 _148 = max(_28.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _110 = float4(_148.x, _148.y, _148.z, _110.w);
    _151 = _Volume1.Sample(sampler_Volume0, _95).yxwz;
    _159 = _Volume2.Sample(sampler_Volume0, _95).xzwy;
    _28.x = _151.y;
    _28.y = _159.x;
    _173 = (_28.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _182 = _28.xyz * 0.5f.xxx;
    _77 = dot(_182, _182);
    _77 = sqrt(_77);
    _191 = dot(_173, _173);
    _191 = rsqrt(_191);
    _173 = _191.xxx * _173;
    _191 = dot(_173, _52);
    _191 = (_191 * 0.5f) + 0.5f;
    _191 = log2(_191);
    _173.x = _77 + _77;
    _77 /= _110.x;
    _173.x /= _110.x;
    float2 _227 = _173.xx + float2(1.0f, 2.0f);
    _173 = float3(_227.x, _227.y, _173.z);
    _191 *= _173.x;
    _191 = exp2(_191);
    _173.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _173.x / _77;
    _173.x = (-_77) + 1.0f;
    _173.x = _173.y * _173.x;
    _77 = (_173.x * _191) + _77;
    _173.x = _77 * _110.x;
    _159.x = _151.w;
    _151.y = _159.w;
    _182 = (_151.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _278 = _151.xyz * 0.5f.xxx;
    _77 = dot(_278, _278);
    _77 = sqrt(_77);
    _287 = dot(_182, _182);
    _287 = rsqrt(_287);
    _278 = _287.xxx * _182;
    _287 = dot(_278, _52);
    _287 = (_287 * 0.5f) + 0.5f;
    _287 = log2(_287);
    _110.x = _77 + _77;
    _77 /= _110.y;
    _110.x /= _110.y;
    float2 _321 = _110.xx + float2(1.0f, 2.0f);
    _110 = float4(_321.x, _110.y, _110.z, _321.y);
    _287 *= _110.x;
    _287 = exp2(_287);
    _110.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _110.x / _77;
    _110.x = (-_77) + 1.0f;
    _110.x = _110.w * _110.x;
    _77 = (_110.x * _287) + _77;
    _173.y = _77 * _110.y;
    float3 _364 = (_159.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _110 = float4(_364.x, _364.y, _110.z, _364.z);
    _95 = _159.xyz * 0.5f.xxx;
    _77 = dot(_95, _95);
    _77 = sqrt(_77);
    _95.x = dot(_110.xyw, _110.xyw);
    _95.x = rsqrt(_95.x);
    _95 = _95.xxx * _110.xyw;
    _95.x = dot(_95, _52);
    _95.x = (_95.x * 0.5f) + 0.5f;
    _95.x = log2(_95.x);
    _404.x = _77 + _77;
    _77 /= _110.z;
    _404.x /= _110.z;
    _404 = _404.xx + float2(1.0f, 2.0f);
    _95.x *= _404.x;
    _95.x = exp2(_95.x);
    _404.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _404.x / _77;
    _404.x = (-_77) + 1.0f;
    _404.x = _404.y * _404.x;
    _77 = (_404.x * _95.x) + _77;
    _173.z = _77 * _110.z;
    _95 = max(_173, 0.0f.xxx);
    _77 = dot(_42_m0.xyz, _42_m0.xyz);
    _77 = sqrt(_77);
    _479 = 9.9999997473787516355514526367188e-05f < _77;
    float3 _488 = _42_m0.xyz / _77.xxx;
    _110 = float4(_488.x, _488.y, _488.z, _110.w);
    float3 _492;
    if (_479)
    {
        _492 = _110.xyz;
    }
    else
    {
        _492 = float3(0.0f, 1.0f, 0.0f);
    }
    _110 = float4(_492.x, _492.y, _492.z, _110.w);
    _52.x = dot(_52, _110.xyz);
    _52.x = clamp(_52.x, 0.0f, 1.0f);
    _511 = (_42_m2.xyz * _52.xxx) + _95;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    _52 = (_9 * _511) + (-_42_m1.xyz);
    _77 = vs_TEXCOORD5;
    _77 = clamp(_77, 0.0f, 1.0f);
    _52 = (_77.xxx * _52) + _42_m1.xyz;
    _552 = float4(_52.x, _52.y, _52.z, _552.w);
    _552.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._552 = _552;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP2) && defined(_MIMIC_MONSTERONLY)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _147;
static float3 _159;
static float4 _193;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _159 : NORMAL;
    float4 _193 : TANGENT;
    float2 _147 : TEXCOORD0;
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
static float4 _44;
static float _178;
static float3 _239;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m5.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD5 = exp2(_9.x);
    vs_TEXCOORD0 = (_147 * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_159, _21_m2[0].xyz);
    _9.z = dot(_159, _21_m2[1].xyz);
    _9.x = dot(_159, _21_m2[2].xyz);
    _178 = dot(_9.xyz, _9.xyz);
    _178 = rsqrt(_178);
    float3 _190 = _178.xxx * _9.xyz;
    _9 = float4(_190.x, _190.y, _190.z, _9.w);
    float3 _199 = _193.yyy * _21_m1[1].yzx;
    _44 = float4(_199.x, _199.y, _199.z, _44.w);
    float3 _210 = (_21_m1[0].yzx * _193.xxx) + _44.xyz;
    _44 = float4(_210.x, _210.y, _210.z, _44.w);
    float3 _221 = (_21_m1[2].yzx * _193.zzz) + _44.xyz;
    _44 = float4(_221.x, _221.y, _221.z, _44.w);
    _178 = dot(_44.xyz, _44.xyz);
    _178 = rsqrt(_178);
    float3 _235 = _178.xxx * _44.xyz;
    _44 = float4(_235.x, _235.y, _235.z, _44.w);
    _239 = _9.xyz * _44.xyz;
    _239 = (_9.zxy * _44.yzx) + (-_239);
    _239 *= _193.www;
    _239 *= _21_m3.www;
    vs_TEXCOORD2.y = _239.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _239.y;
    vs_TEXCOORD4.y = _239.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _159 = stage_input._159;
    _193 = stage_input._193;
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
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float _BumpScale;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _42_m0 _WorldSpaceLightPos0
#define _42_m1 unity_FogColor
#define _42_m2 _LightColor0
#define _42_m3 _BumpScale
#define _42_m4 _VolumeMin
#define _42_m5 _VolumeInvSize
#define _42_m6 _GlobalVolumeMin
#define _42_m7 _GlobalVolumeInvSize


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float4 _552;

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
    float4 _552 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float3 _52;
static float _77;
static bool _89;
static float3 _95;
static float4 _110;
static float4 _151;
static float4 _159;
static float3 _173;
static float3 _182;
static float _191;
static float3 _278;
static float _287;
static float2 _404;
static bool _479;
static float3 _511;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    float3 _35 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _28 = float4(_35.x, _35.y, _35.z, _28.w);
    float2 _49 = _28.xy * _42_m3.xx;
    _28 = float4(_49.x, _49.y, _28.z, _28.w);
    _52.x = dot(vs_TEXCOORD2, _28.xyz);
    _52.y = dot(vs_TEXCOORD3, _28.xyz);
    _52.z = dot(vs_TEXCOORD4, _28.xyz);
    _77 = dot(_52, _52);
    _77 = rsqrt(_77);
    _52 = _77.xxx * _52;
    _89 = 1000000.0f < _42_m5.x;
    float3 _98;
    if (_89)
    {
        _98 = _42_m6;
    }
    else
    {
        _98 = _42_m4;
    }
    _95 = _98;
    float3 _112;
    if (_89)
    {
        _112 = _42_m7;
    }
    else
    {
        _112 = _42_m5;
    }
    _110 = float4(_112.x, _112.y, _112.z, _110.w);
    _95 = (-_95) + vs_TEXCOORD1;
    _95 = _110.xyz * _95;
    _28 = _Volume0.Sample(sampler_Volume0, _95).xywz;
    float3 _148 = max(_28.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _110 = float4(_148.x, _148.y, _148.z, _110.w);
    _151 = _Volume1.Sample(sampler_Volume0, _95).yxwz;
    _159 = _Volume2.Sample(sampler_Volume0, _95).xzwy;
    _28.x = _151.y;
    _28.y = _159.x;
    _173 = (_28.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _182 = _28.xyz * 0.5f.xxx;
    _77 = dot(_182, _182);
    _77 = sqrt(_77);
    _191 = dot(_173, _173);
    _191 = rsqrt(_191);
    _173 = _191.xxx * _173;
    _191 = dot(_173, _52);
    _191 = (_191 * 0.5f) + 0.5f;
    _191 = log2(_191);
    _173.x = _77 + _77;
    _77 /= _110.x;
    _173.x /= _110.x;
    float2 _227 = _173.xx + float2(1.0f, 2.0f);
    _173 = float3(_227.x, _227.y, _173.z);
    _191 *= _173.x;
    _191 = exp2(_191);
    _173.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _173.x / _77;
    _173.x = (-_77) + 1.0f;
    _173.x = _173.y * _173.x;
    _77 = (_173.x * _191) + _77;
    _173.x = _77 * _110.x;
    _159.x = _151.w;
    _151.y = _159.w;
    _182 = (_151.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _278 = _151.xyz * 0.5f.xxx;
    _77 = dot(_278, _278);
    _77 = sqrt(_77);
    _287 = dot(_182, _182);
    _287 = rsqrt(_287);
    _278 = _287.xxx * _182;
    _287 = dot(_278, _52);
    _287 = (_287 * 0.5f) + 0.5f;
    _287 = log2(_287);
    _110.x = _77 + _77;
    _77 /= _110.y;
    _110.x /= _110.y;
    float2 _321 = _110.xx + float2(1.0f, 2.0f);
    _110 = float4(_321.x, _110.y, _110.z, _321.y);
    _287 *= _110.x;
    _287 = exp2(_287);
    _110.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _110.x / _77;
    _110.x = (-_77) + 1.0f;
    _110.x = _110.w * _110.x;
    _77 = (_110.x * _287) + _77;
    _173.y = _77 * _110.y;
    float3 _364 = (_159.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _110 = float4(_364.x, _364.y, _110.z, _364.z);
    _95 = _159.xyz * 0.5f.xxx;
    _77 = dot(_95, _95);
    _77 = sqrt(_77);
    _95.x = dot(_110.xyw, _110.xyw);
    _95.x = rsqrt(_95.x);
    _95 = _95.xxx * _110.xyw;
    _95.x = dot(_95, _52);
    _95.x = (_95.x * 0.5f) + 0.5f;
    _95.x = log2(_95.x);
    _404.x = _77 + _77;
    _77 /= _110.z;
    _404.x /= _110.z;
    _404 = _404.xx + float2(1.0f, 2.0f);
    _95.x *= _404.x;
    _95.x = exp2(_95.x);
    _404.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _404.x / _77;
    _404.x = (-_77) + 1.0f;
    _404.x = _404.y * _404.x;
    _77 = (_404.x * _95.x) + _77;
    _173.z = _77 * _110.z;
    _95 = max(_173, 0.0f.xxx);
    _77 = dot(_42_m0.xyz, _42_m0.xyz);
    _77 = sqrt(_77);
    _479 = 9.9999997473787516355514526367188e-05f < _77;
    float3 _488 = _42_m0.xyz / _77.xxx;
    _110 = float4(_488.x, _488.y, _488.z, _110.w);
    float3 _492;
    if (_479)
    {
        _492 = _110.xyz;
    }
    else
    {
        _492 = float3(0.0f, 1.0f, 0.0f);
    }
    _110 = float4(_492.x, _492.y, _492.z, _110.w);
    _52.x = dot(_52, _110.xyz);
    _52.x = clamp(_52.x, 0.0f, 1.0f);
    _511 = (_42_m2.xyz * _52.xxx) + _95;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    _52 = (_9 * _511) + (-_42_m1.xyz);
    _77 = vs_TEXCOORD5;
    _77 = clamp(_77, 0.0f, 1.0f);
    _52 = (_77.xxx * _52) + _42_m1.xyz;
    _552 = float4(_52.x, _52.y, _52.z, _552.w);
    _552.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._552 = _552;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_LINEAR) && defined(_MIMIC_MONSTERONLY)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _152;
static float4 _186;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _152 : NORMAL;
    float4 _186 : TANGENT;
    float2 _140 : TEXCOORD0;
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
static float4 _44;
static float _171;
static float3 _232;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD5 = (_9.x * _21_m5.z) + _21_m5.w;
    vs_TEXCOORD0 = (_140 * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_152, _21_m2[0].xyz);
    _9.z = dot(_152, _21_m2[1].xyz);
    _9.x = dot(_152, _21_m2[2].xyz);
    _171 = dot(_9.xyz, _9.xyz);
    _171 = rsqrt(_171);
    float3 _183 = _171.xxx * _9.xyz;
    _9 = float4(_183.x, _183.y, _183.z, _9.w);
    float3 _192 = _186.yyy * _21_m1[1].yzx;
    _44 = float4(_192.x, _192.y, _192.z, _44.w);
    float3 _203 = (_21_m1[0].yzx * _186.xxx) + _44.xyz;
    _44 = float4(_203.x, _203.y, _203.z, _44.w);
    float3 _214 = (_21_m1[2].yzx * _186.zzz) + _44.xyz;
    _44 = float4(_214.x, _214.y, _214.z, _44.w);
    _171 = dot(_44.xyz, _44.xyz);
    _171 = rsqrt(_171);
    float3 _228 = _171.xxx * _44.xyz;
    _44 = float4(_228.x, _228.y, _228.z, _44.w);
    _232 = _9.xyz * _44.xyz;
    _232 = (_9.zxy * _44.yzx) + (-_232);
    _232 *= _186.www;
    _232 *= _21_m3.www;
    vs_TEXCOORD2.y = _232.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _232.y;
    vs_TEXCOORD4.y = _232.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _152 = stage_input._152;
    _186 = stage_input._186;
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
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float _BumpScale;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _42_m0 _WorldSpaceLightPos0
#define _42_m1 unity_FogColor
#define _42_m2 _LightColor0
#define _42_m3 _BumpScale
#define _42_m4 _VolumeMin
#define _42_m5 _VolumeInvSize
#define _42_m6 _GlobalVolumeMin
#define _42_m7 _GlobalVolumeInvSize


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float4 _552;

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
    float4 _552 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float3 _52;
static float _77;
static bool _89;
static float3 _95;
static float4 _110;
static float4 _151;
static float4 _159;
static float3 _173;
static float3 _182;
static float _191;
static float3 _278;
static float _287;
static float2 _404;
static bool _479;
static float3 _511;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    float3 _35 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _28 = float4(_35.x, _35.y, _35.z, _28.w);
    float2 _49 = _28.xy * _42_m3.xx;
    _28 = float4(_49.x, _49.y, _28.z, _28.w);
    _52.x = dot(vs_TEXCOORD2, _28.xyz);
    _52.y = dot(vs_TEXCOORD3, _28.xyz);
    _52.z = dot(vs_TEXCOORD4, _28.xyz);
    _77 = dot(_52, _52);
    _77 = rsqrt(_77);
    _52 = _77.xxx * _52;
    _89 = 1000000.0f < _42_m5.x;
    float3 _98;
    if (_89)
    {
        _98 = _42_m6;
    }
    else
    {
        _98 = _42_m4;
    }
    _95 = _98;
    float3 _112;
    if (_89)
    {
        _112 = _42_m7;
    }
    else
    {
        _112 = _42_m5;
    }
    _110 = float4(_112.x, _112.y, _112.z, _110.w);
    _95 = (-_95) + vs_TEXCOORD1;
    _95 = _110.xyz * _95;
    _28 = _Volume0.Sample(sampler_Volume0, _95).xywz;
    float3 _148 = max(_28.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _110 = float4(_148.x, _148.y, _148.z, _110.w);
    _151 = _Volume1.Sample(sampler_Volume0, _95).yxwz;
    _159 = _Volume2.Sample(sampler_Volume0, _95).xzwy;
    _28.x = _151.y;
    _28.y = _159.x;
    _173 = (_28.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _182 = _28.xyz * 0.5f.xxx;
    _77 = dot(_182, _182);
    _77 = sqrt(_77);
    _191 = dot(_173, _173);
    _191 = rsqrt(_191);
    _173 = _191.xxx * _173;
    _191 = dot(_173, _52);
    _191 = (_191 * 0.5f) + 0.5f;
    _191 = log2(_191);
    _173.x = _77 + _77;
    _77 /= _110.x;
    _173.x /= _110.x;
    float2 _227 = _173.xx + float2(1.0f, 2.0f);
    _173 = float3(_227.x, _227.y, _173.z);
    _191 *= _173.x;
    _191 = exp2(_191);
    _173.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _173.x / _77;
    _173.x = (-_77) + 1.0f;
    _173.x = _173.y * _173.x;
    _77 = (_173.x * _191) + _77;
    _173.x = _77 * _110.x;
    _159.x = _151.w;
    _151.y = _159.w;
    _182 = (_151.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _278 = _151.xyz * 0.5f.xxx;
    _77 = dot(_278, _278);
    _77 = sqrt(_77);
    _287 = dot(_182, _182);
    _287 = rsqrt(_287);
    _278 = _287.xxx * _182;
    _287 = dot(_278, _52);
    _287 = (_287 * 0.5f) + 0.5f;
    _287 = log2(_287);
    _110.x = _77 + _77;
    _77 /= _110.y;
    _110.x /= _110.y;
    float2 _321 = _110.xx + float2(1.0f, 2.0f);
    _110 = float4(_321.x, _110.y, _110.z, _321.y);
    _287 *= _110.x;
    _287 = exp2(_287);
    _110.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _110.x / _77;
    _110.x = (-_77) + 1.0f;
    _110.x = _110.w * _110.x;
    _77 = (_110.x * _287) + _77;
    _173.y = _77 * _110.y;
    float3 _364 = (_159.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _110 = float4(_364.x, _364.y, _110.z, _364.z);
    _95 = _159.xyz * 0.5f.xxx;
    _77 = dot(_95, _95);
    _77 = sqrt(_77);
    _95.x = dot(_110.xyw, _110.xyw);
    _95.x = rsqrt(_95.x);
    _95 = _95.xxx * _110.xyw;
    _95.x = dot(_95, _52);
    _95.x = (_95.x * 0.5f) + 0.5f;
    _95.x = log2(_95.x);
    _404.x = _77 + _77;
    _77 /= _110.z;
    _404.x /= _110.z;
    _404 = _404.xx + float2(1.0f, 2.0f);
    _95.x *= _404.x;
    _95.x = exp2(_95.x);
    _404.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _404.x / _77;
    _404.x = (-_77) + 1.0f;
    _404.x = _404.y * _404.x;
    _77 = (_404.x * _95.x) + _77;
    _173.z = _77 * _110.z;
    _95 = max(_173, 0.0f.xxx);
    _77 = dot(_42_m0.xyz, _42_m0.xyz);
    _77 = sqrt(_77);
    _479 = 9.9999997473787516355514526367188e-05f < _77;
    float3 _488 = _42_m0.xyz / _77.xxx;
    _110 = float4(_488.x, _488.y, _488.z, _110.w);
    float3 _492;
    if (_479)
    {
        _492 = _110.xyz;
    }
    else
    {
        _492 = float3(0.0f, 1.0f, 0.0f);
    }
    _110 = float4(_492.x, _492.y, _492.z, _110.w);
    _52.x = dot(_52, _110.xyz);
    _52.x = clamp(_52.x, 0.0f, 1.0f);
    _511 = (_42_m2.xyz * _52.xxx) + _95;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    _52 = (_9 * _511) + (-_42_m1.xyz);
    _77 = vs_TEXCOORD5;
    _77 = clamp(_77, 0.0f, 1.0f);
    _52 = (_77.xxx * _52) + _42_m1.xyz;
    _552 = float4(_52.x, _52.y, _52.z, _552.w);
    _552.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._552 = _552;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _141;
static float3 _153;
static float4 _187;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _153 : NORMAL;
    float4 _187 : TANGENT;
    float2 _141 : TEXCOORD0;
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
static float4 _44;
static float _172;
static float3 _233;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m5.y;
    vs_TEXCOORD5 = exp2(-_9.x);
    vs_TEXCOORD0 = (_141 * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_153, _21_m2[0].xyz);
    _9.z = dot(_153, _21_m2[1].xyz);
    _9.x = dot(_153, _21_m2[2].xyz);
    _172 = dot(_9.xyz, _9.xyz);
    _172 = rsqrt(_172);
    float3 _184 = _172.xxx * _9.xyz;
    _9 = float4(_184.x, _184.y, _184.z, _9.w);
    float3 _193 = _187.yyy * _21_m1[1].yzx;
    _44 = float4(_193.x, _193.y, _193.z, _44.w);
    float3 _204 = (_21_m1[0].yzx * _187.xxx) + _44.xyz;
    _44 = float4(_204.x, _204.y, _204.z, _44.w);
    float3 _215 = (_21_m1[2].yzx * _187.zzz) + _44.xyz;
    _44 = float4(_215.x, _215.y, _215.z, _44.w);
    _172 = dot(_44.xyz, _44.xyz);
    _172 = rsqrt(_172);
    float3 _229 = _172.xxx * _44.xyz;
    _44 = float4(_229.x, _229.y, _229.z, _44.w);
    _233 = _9.xyz * _44.xyz;
    _233 = (_9.zxy * _44.yzx) + (-_233);
    _233 *= _187.www;
    _233 *= _21_m3.www;
    vs_TEXCOORD2.y = _233.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _233.y;
    vs_TEXCOORD4.y = _233.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _153 = stage_input._153;
    _187 = stage_input._187;
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
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float _BumpScale;
float _Morph;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _62_m0 _WorldSpaceLightPos0
#define _62_m1 unity_FogColor
#define _62_m2 _LightColor0
#define _62_m3 _BumpScale
#define _62_m4 _Morph
#define _62_m5 _VolumeMin
#define _62_m6 _VolumeInvSize
#define _62_m7 _GlobalVolumeMin
#define _62_m8 _GlobalVolumeInvSize


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float4 _624;

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
    float4 _624 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float4 _46;
static float3 _94;
static float _119;
static bool _131;
static float3 _137;
static float4 _152;
static float4 _200;
static float3 _214;
static float3 _223;
static float _232;
static float3 _319;
static float _328;
static float2 _445;
static bool _520;
static float3 _552;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    float3 _35 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _28 = float4(_35.x, _35.y, _35.z, _28.w);
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _49 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _46 = float4(_49.x, _49.y, _49.z, _46.w);
    float3 _57 = _28.xyz + (-_46.xyz);
    _28 = float4(_57.x, _57.y, _57.z, _28.w);
    float3 _82 = (float3(float3(_62_m4, _62_m4, _62_m4)) * _28.xyz) + _46.xyz;
    _28 = float4(_82.x, _82.y, _82.z, _28.w);
    float2 _91 = _28.xy * _62_m3.xx;
    _28 = float4(_91.x, _91.y, _28.z, _28.w);
    _94.x = dot(vs_TEXCOORD2, _28.xyz);
    _94.y = dot(vs_TEXCOORD3, _28.xyz);
    _94.z = dot(vs_TEXCOORD4, _28.xyz);
    _119 = dot(_94, _94);
    _119 = rsqrt(_119);
    _94 = _119.xxx * _94;
    _131 = 1000000.0f < _62_m6.x;
    float3 _140;
    if (_131)
    {
        _140 = _62_m7;
    }
    else
    {
        _140 = _62_m5;
    }
    _137 = _140;
    float3 _154;
    if (_131)
    {
        _154 = _62_m8;
    }
    else
    {
        _154 = _62_m6;
    }
    _152 = float4(_154.x, _154.y, _154.z, _152.w);
    _137 = (-_137) + vs_TEXCOORD1;
    _137 = _152.xyz * _137;
    _28 = _Volume0.Sample(sampler_Volume0, _137).xywz;
    float3 _190 = max(_28.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _152 = float4(_190.x, _190.y, _190.z, _152.w);
    _46 = _Volume1.Sample(sampler_Volume0, _137).yxwz;
    _200 = _Volume2.Sample(sampler_Volume0, _137).xzwy;
    _28.x = _46.y;
    _28.y = _200.x;
    _214 = (_28.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _223 = _28.xyz * 0.5f.xxx;
    _119 = dot(_223, _223);
    _119 = sqrt(_119);
    _232 = dot(_214, _214);
    _232 = rsqrt(_232);
    _214 = _232.xxx * _214;
    _232 = dot(_214, _94);
    _232 = (_232 * 0.5f) + 0.5f;
    _232 = log2(_232);
    _214.x = _119 + _119;
    _119 /= _152.x;
    _214.x /= _152.x;
    float2 _268 = _214.xx + float2(1.0f, 2.0f);
    _214 = float3(_268.x, _268.y, _214.z);
    _232 *= _214.x;
    _232 = exp2(_232);
    _214.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _214.x / _119;
    _214.x = (-_119) + 1.0f;
    _214.x = _214.y * _214.x;
    _119 = (_214.x * _232) + _119;
    _214.x = _119 * _152.x;
    _200.x = _46.w;
    _46.y = _200.w;
    _223 = (_46.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _319 = _46.xyz * 0.5f.xxx;
    _119 = dot(_319, _319);
    _119 = sqrt(_119);
    _328 = dot(_223, _223);
    _328 = rsqrt(_328);
    _223 = _328.xxx * _223;
    _328 = dot(_223, _94);
    _328 = (_328 * 0.5f) + 0.5f;
    _328 = log2(_328);
    _152.x = _119 + _119;
    _119 /= _152.y;
    _152.x /= _152.y;
    float2 _362 = _152.xx + float2(1.0f, 2.0f);
    _152 = float4(_362.x, _152.y, _152.z, _362.y);
    _328 *= _152.x;
    _328 = exp2(_328);
    _152.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _152.x / _119;
    _152.x = (-_119) + 1.0f;
    _152.x = _152.w * _152.x;
    _119 = (_152.x * _328) + _119;
    _214.y = _119 * _152.y;
    float3 _405 = (_200.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _152 = float4(_405.x, _405.y, _152.z, _405.z);
    _137 = _200.xyz * 0.5f.xxx;
    _119 = dot(_137, _137);
    _119 = sqrt(_119);
    _137.x = dot(_152.xyw, _152.xyw);
    _137.x = rsqrt(_137.x);
    _137 = _137.xxx * _152.xyw;
    _137.x = dot(_137, _94);
    _137.x = (_137.x * 0.5f) + 0.5f;
    _137.x = log2(_137.x);
    _445.x = _119 + _119;
    _119 /= _152.z;
    _445.x /= _152.z;
    _445 = _445.xx + float2(1.0f, 2.0f);
    _137.x *= _445.x;
    _137.x = exp2(_137.x);
    _445.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _445.x / _119;
    _445.x = (-_119) + 1.0f;
    _445.x = _445.y * _445.x;
    _119 = (_445.x * _137.x) + _119;
    _214.z = _119 * _152.z;
    _137 = max(_214, 0.0f.xxx);
    _119 = dot(_62_m0.xyz, _62_m0.xyz);
    _119 = sqrt(_119);
    _520 = 9.9999997473787516355514526367188e-05f < _119;
    float3 _529 = _62_m0.xyz / _119.xxx;
    _152 = float4(_529.x, _529.y, _529.z, _152.w);
    float3 _533;
    if (_520)
    {
        _533 = _152.xyz;
    }
    else
    {
        _533 = float3(0.0f, 1.0f, 0.0f);
    }
    _152 = float4(_533.x, _533.y, _533.z, _152.w);
    _94.x = dot(_94, _152.xyz);
    _94.x = clamp(_94.x, 0.0f, 1.0f);
    _552 = (_62_m2.xyz * _94.xxx) + _137;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    float3 _577 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _200 = float4(_577.x, _577.y, _577.z, _200.w);
    _94 = _9 + (-_200.xyz);
    _94 = (float3(float3(_62_m4, _62_m4, _62_m4)) * _94) + _200.xyz;
    _94 = (_94 * _552) + (-_62_m1.xyz);
    _119 = vs_TEXCOORD5;
    _119 = clamp(_119, 0.0f, 1.0f);
    _94 = (_119.xxx * _94) + _62_m1.xyz;
    _624 = float4(_94.x, _94.y, _94.z, _624.w);
    _624.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._624 = _624;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _147;
static float3 _159;
static float4 _193;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _159 : NORMAL;
    float4 _193 : TANGENT;
    float2 _147 : TEXCOORD0;
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
static float4 _44;
static float _178;
static float3 _239;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m5.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD5 = exp2(_9.x);
    vs_TEXCOORD0 = (_147 * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_159, _21_m2[0].xyz);
    _9.z = dot(_159, _21_m2[1].xyz);
    _9.x = dot(_159, _21_m2[2].xyz);
    _178 = dot(_9.xyz, _9.xyz);
    _178 = rsqrt(_178);
    float3 _190 = _178.xxx * _9.xyz;
    _9 = float4(_190.x, _190.y, _190.z, _9.w);
    float3 _199 = _193.yyy * _21_m1[1].yzx;
    _44 = float4(_199.x, _199.y, _199.z, _44.w);
    float3 _210 = (_21_m1[0].yzx * _193.xxx) + _44.xyz;
    _44 = float4(_210.x, _210.y, _210.z, _44.w);
    float3 _221 = (_21_m1[2].yzx * _193.zzz) + _44.xyz;
    _44 = float4(_221.x, _221.y, _221.z, _44.w);
    _178 = dot(_44.xyz, _44.xyz);
    _178 = rsqrt(_178);
    float3 _235 = _178.xxx * _44.xyz;
    _44 = float4(_235.x, _235.y, _235.z, _44.w);
    _239 = _9.xyz * _44.xyz;
    _239 = (_9.zxy * _44.yzx) + (-_239);
    _239 *= _193.www;
    _239 *= _21_m3.www;
    vs_TEXCOORD2.y = _239.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _239.y;
    vs_TEXCOORD4.y = _239.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _159 = stage_input._159;
    _193 = stage_input._193;
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
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float _BumpScale;
float _Morph;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _62_m0 _WorldSpaceLightPos0
#define _62_m1 unity_FogColor
#define _62_m2 _LightColor0
#define _62_m3 _BumpScale
#define _62_m4 _Morph
#define _62_m5 _VolumeMin
#define _62_m6 _VolumeInvSize
#define _62_m7 _GlobalVolumeMin
#define _62_m8 _GlobalVolumeInvSize


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float4 _624;

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
    float4 _624 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float4 _46;
static float3 _94;
static float _119;
static bool _131;
static float3 _137;
static float4 _152;
static float4 _200;
static float3 _214;
static float3 _223;
static float _232;
static float3 _319;
static float _328;
static float2 _445;
static bool _520;
static float3 _552;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    float3 _35 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _28 = float4(_35.x, _35.y, _35.z, _28.w);
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _49 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _46 = float4(_49.x, _49.y, _49.z, _46.w);
    float3 _57 = _28.xyz + (-_46.xyz);
    _28 = float4(_57.x, _57.y, _57.z, _28.w);
    float3 _82 = (float3(float3(_62_m4, _62_m4, _62_m4)) * _28.xyz) + _46.xyz;
    _28 = float4(_82.x, _82.y, _82.z, _28.w);
    float2 _91 = _28.xy * _62_m3.xx;
    _28 = float4(_91.x, _91.y, _28.z, _28.w);
    _94.x = dot(vs_TEXCOORD2, _28.xyz);
    _94.y = dot(vs_TEXCOORD3, _28.xyz);
    _94.z = dot(vs_TEXCOORD4, _28.xyz);
    _119 = dot(_94, _94);
    _119 = rsqrt(_119);
    _94 = _119.xxx * _94;
    _131 = 1000000.0f < _62_m6.x;
    float3 _140;
    if (_131)
    {
        _140 = _62_m7;
    }
    else
    {
        _140 = _62_m5;
    }
    _137 = _140;
    float3 _154;
    if (_131)
    {
        _154 = _62_m8;
    }
    else
    {
        _154 = _62_m6;
    }
    _152 = float4(_154.x, _154.y, _154.z, _152.w);
    _137 = (-_137) + vs_TEXCOORD1;
    _137 = _152.xyz * _137;
    _28 = _Volume0.Sample(sampler_Volume0, _137).xywz;
    float3 _190 = max(_28.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _152 = float4(_190.x, _190.y, _190.z, _152.w);
    _46 = _Volume1.Sample(sampler_Volume0, _137).yxwz;
    _200 = _Volume2.Sample(sampler_Volume0, _137).xzwy;
    _28.x = _46.y;
    _28.y = _200.x;
    _214 = (_28.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _223 = _28.xyz * 0.5f.xxx;
    _119 = dot(_223, _223);
    _119 = sqrt(_119);
    _232 = dot(_214, _214);
    _232 = rsqrt(_232);
    _214 = _232.xxx * _214;
    _232 = dot(_214, _94);
    _232 = (_232 * 0.5f) + 0.5f;
    _232 = log2(_232);
    _214.x = _119 + _119;
    _119 /= _152.x;
    _214.x /= _152.x;
    float2 _268 = _214.xx + float2(1.0f, 2.0f);
    _214 = float3(_268.x, _268.y, _214.z);
    _232 *= _214.x;
    _232 = exp2(_232);
    _214.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _214.x / _119;
    _214.x = (-_119) + 1.0f;
    _214.x = _214.y * _214.x;
    _119 = (_214.x * _232) + _119;
    _214.x = _119 * _152.x;
    _200.x = _46.w;
    _46.y = _200.w;
    _223 = (_46.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _319 = _46.xyz * 0.5f.xxx;
    _119 = dot(_319, _319);
    _119 = sqrt(_119);
    _328 = dot(_223, _223);
    _328 = rsqrt(_328);
    _223 = _328.xxx * _223;
    _328 = dot(_223, _94);
    _328 = (_328 * 0.5f) + 0.5f;
    _328 = log2(_328);
    _152.x = _119 + _119;
    _119 /= _152.y;
    _152.x /= _152.y;
    float2 _362 = _152.xx + float2(1.0f, 2.0f);
    _152 = float4(_362.x, _152.y, _152.z, _362.y);
    _328 *= _152.x;
    _328 = exp2(_328);
    _152.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _152.x / _119;
    _152.x = (-_119) + 1.0f;
    _152.x = _152.w * _152.x;
    _119 = (_152.x * _328) + _119;
    _214.y = _119 * _152.y;
    float3 _405 = (_200.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _152 = float4(_405.x, _405.y, _152.z, _405.z);
    _137 = _200.xyz * 0.5f.xxx;
    _119 = dot(_137, _137);
    _119 = sqrt(_119);
    _137.x = dot(_152.xyw, _152.xyw);
    _137.x = rsqrt(_137.x);
    _137 = _137.xxx * _152.xyw;
    _137.x = dot(_137, _94);
    _137.x = (_137.x * 0.5f) + 0.5f;
    _137.x = log2(_137.x);
    _445.x = _119 + _119;
    _119 /= _152.z;
    _445.x /= _152.z;
    _445 = _445.xx + float2(1.0f, 2.0f);
    _137.x *= _445.x;
    _137.x = exp2(_137.x);
    _445.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _445.x / _119;
    _445.x = (-_119) + 1.0f;
    _445.x = _445.y * _445.x;
    _119 = (_445.x * _137.x) + _119;
    _214.z = _119 * _152.z;
    _137 = max(_214, 0.0f.xxx);
    _119 = dot(_62_m0.xyz, _62_m0.xyz);
    _119 = sqrt(_119);
    _520 = 9.9999997473787516355514526367188e-05f < _119;
    float3 _529 = _62_m0.xyz / _119.xxx;
    _152 = float4(_529.x, _529.y, _529.z, _152.w);
    float3 _533;
    if (_520)
    {
        _533 = _152.xyz;
    }
    else
    {
        _533 = float3(0.0f, 1.0f, 0.0f);
    }
    _152 = float4(_533.x, _533.y, _533.z, _152.w);
    _94.x = dot(_94, _152.xyz);
    _94.x = clamp(_94.x, 0.0f, 1.0f);
    _552 = (_62_m2.xyz * _94.xxx) + _137;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    float3 _577 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _200 = float4(_577.x, _577.y, _577.z, _200.w);
    _94 = _9 + (-_200.xyz);
    _94 = (float3(float3(_62_m4, _62_m4, _62_m4)) * _94) + _200.xyz;
    _94 = (_94 * _552) + (-_62_m1.xyz);
    _119 = vs_TEXCOORD5;
    _119 = clamp(_119, 0.0f, 1.0f);
    _94 = (_119.xxx * _94) + _62_m1.xyz;
    _624 = float4(_94.x, _94.y, _94.z, _624.w);
    _624.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._624 = _624;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _152;
static float4 _186;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _152 : NORMAL;
    float4 _186 : TANGENT;
    float2 _140 : TEXCOORD0;
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
static float4 _44;
static float _171;
static float3 _232;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD5 = (_9.x * _21_m5.z) + _21_m5.w;
    vs_TEXCOORD0 = (_140 * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_152, _21_m2[0].xyz);
    _9.z = dot(_152, _21_m2[1].xyz);
    _9.x = dot(_152, _21_m2[2].xyz);
    _171 = dot(_9.xyz, _9.xyz);
    _171 = rsqrt(_171);
    float3 _183 = _171.xxx * _9.xyz;
    _9 = float4(_183.x, _183.y, _183.z, _9.w);
    float3 _192 = _186.yyy * _21_m1[1].yzx;
    _44 = float4(_192.x, _192.y, _192.z, _44.w);
    float3 _203 = (_21_m1[0].yzx * _186.xxx) + _44.xyz;
    _44 = float4(_203.x, _203.y, _203.z, _44.w);
    float3 _214 = (_21_m1[2].yzx * _186.zzz) + _44.xyz;
    _44 = float4(_214.x, _214.y, _214.z, _44.w);
    _171 = dot(_44.xyz, _44.xyz);
    _171 = rsqrt(_171);
    float3 _228 = _171.xxx * _44.xyz;
    _44 = float4(_228.x, _228.y, _228.z, _44.w);
    _232 = _9.xyz * _44.xyz;
    _232 = (_9.zxy * _44.yzx) + (-_232);
    _232 *= _186.www;
    _232 *= _21_m3.www;
    vs_TEXCOORD2.y = _232.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _232.y;
    vs_TEXCOORD4.y = _232.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _152 = stage_input._152;
    _186 = stage_input._186;
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
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float _BumpScale;
float _Morph;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _62_m0 _WorldSpaceLightPos0
#define _62_m1 unity_FogColor
#define _62_m2 _LightColor0
#define _62_m3 _BumpScale
#define _62_m4 _Morph
#define _62_m5 _VolumeMin
#define _62_m6 _VolumeInvSize
#define _62_m7 _GlobalVolumeMin
#define _62_m8 _GlobalVolumeInvSize


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float4 _624;

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
    float4 _624 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float4 _46;
static float3 _94;
static float _119;
static bool _131;
static float3 _137;
static float4 _152;
static float4 _200;
static float3 _214;
static float3 _223;
static float _232;
static float3 _319;
static float _328;
static float2 _445;
static bool _520;
static float3 _552;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    float3 _35 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _28 = float4(_35.x, _35.y, _35.z, _28.w);
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _49 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _46 = float4(_49.x, _49.y, _49.z, _46.w);
    float3 _57 = _28.xyz + (-_46.xyz);
    _28 = float4(_57.x, _57.y, _57.z, _28.w);
    float3 _82 = (float3(float3(_62_m4, _62_m4, _62_m4)) * _28.xyz) + _46.xyz;
    _28 = float4(_82.x, _82.y, _82.z, _28.w);
    float2 _91 = _28.xy * _62_m3.xx;
    _28 = float4(_91.x, _91.y, _28.z, _28.w);
    _94.x = dot(vs_TEXCOORD2, _28.xyz);
    _94.y = dot(vs_TEXCOORD3, _28.xyz);
    _94.z = dot(vs_TEXCOORD4, _28.xyz);
    _119 = dot(_94, _94);
    _119 = rsqrt(_119);
    _94 = _119.xxx * _94;
    _131 = 1000000.0f < _62_m6.x;
    float3 _140;
    if (_131)
    {
        _140 = _62_m7;
    }
    else
    {
        _140 = _62_m5;
    }
    _137 = _140;
    float3 _154;
    if (_131)
    {
        _154 = _62_m8;
    }
    else
    {
        _154 = _62_m6;
    }
    _152 = float4(_154.x, _154.y, _154.z, _152.w);
    _137 = (-_137) + vs_TEXCOORD1;
    _137 = _152.xyz * _137;
    _28 = _Volume0.Sample(sampler_Volume0, _137).xywz;
    float3 _190 = max(_28.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _152 = float4(_190.x, _190.y, _190.z, _152.w);
    _46 = _Volume1.Sample(sampler_Volume0, _137).yxwz;
    _200 = _Volume2.Sample(sampler_Volume0, _137).xzwy;
    _28.x = _46.y;
    _28.y = _200.x;
    _214 = (_28.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _223 = _28.xyz * 0.5f.xxx;
    _119 = dot(_223, _223);
    _119 = sqrt(_119);
    _232 = dot(_214, _214);
    _232 = rsqrt(_232);
    _214 = _232.xxx * _214;
    _232 = dot(_214, _94);
    _232 = (_232 * 0.5f) + 0.5f;
    _232 = log2(_232);
    _214.x = _119 + _119;
    _119 /= _152.x;
    _214.x /= _152.x;
    float2 _268 = _214.xx + float2(1.0f, 2.0f);
    _214 = float3(_268.x, _268.y, _214.z);
    _232 *= _214.x;
    _232 = exp2(_232);
    _214.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _214.x / _119;
    _214.x = (-_119) + 1.0f;
    _214.x = _214.y * _214.x;
    _119 = (_214.x * _232) + _119;
    _214.x = _119 * _152.x;
    _200.x = _46.w;
    _46.y = _200.w;
    _223 = (_46.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _319 = _46.xyz * 0.5f.xxx;
    _119 = dot(_319, _319);
    _119 = sqrt(_119);
    _328 = dot(_223, _223);
    _328 = rsqrt(_328);
    _223 = _328.xxx * _223;
    _328 = dot(_223, _94);
    _328 = (_328 * 0.5f) + 0.5f;
    _328 = log2(_328);
    _152.x = _119 + _119;
    _119 /= _152.y;
    _152.x /= _152.y;
    float2 _362 = _152.xx + float2(1.0f, 2.0f);
    _152 = float4(_362.x, _152.y, _152.z, _362.y);
    _328 *= _152.x;
    _328 = exp2(_328);
    _152.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _152.x / _119;
    _152.x = (-_119) + 1.0f;
    _152.x = _152.w * _152.x;
    _119 = (_152.x * _328) + _119;
    _214.y = _119 * _152.y;
    float3 _405 = (_200.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _152 = float4(_405.x, _405.y, _152.z, _405.z);
    _137 = _200.xyz * 0.5f.xxx;
    _119 = dot(_137, _137);
    _119 = sqrt(_119);
    _137.x = dot(_152.xyw, _152.xyw);
    _137.x = rsqrt(_137.x);
    _137 = _137.xxx * _152.xyw;
    _137.x = dot(_137, _94);
    _137.x = (_137.x * 0.5f) + 0.5f;
    _137.x = log2(_137.x);
    _445.x = _119 + _119;
    _119 /= _152.z;
    _445.x /= _152.z;
    _445 = _445.xx + float2(1.0f, 2.0f);
    _137.x *= _445.x;
    _137.x = exp2(_137.x);
    _445.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _445.x / _119;
    _445.x = (-_119) + 1.0f;
    _445.x = _445.y * _445.x;
    _119 = (_445.x * _137.x) + _119;
    _214.z = _119 * _152.z;
    _137 = max(_214, 0.0f.xxx);
    _119 = dot(_62_m0.xyz, _62_m0.xyz);
    _119 = sqrt(_119);
    _520 = 9.9999997473787516355514526367188e-05f < _119;
    float3 _529 = _62_m0.xyz / _119.xxx;
    _152 = float4(_529.x, _529.y, _529.z, _152.w);
    float3 _533;
    if (_520)
    {
        _533 = _152.xyz;
    }
    else
    {
        _533 = float3(0.0f, 1.0f, 0.0f);
    }
    _152 = float4(_533.x, _533.y, _533.z, _152.w);
    _94.x = dot(_94, _152.xyz);
    _94.x = clamp(_94.x, 0.0f, 1.0f);
    _552 = (_62_m2.xyz * _94.xxx) + _137;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    float3 _577 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _200 = float4(_577.x, _577.y, _577.z, _200.w);
    _94 = _9 + (-_200.xyz);
    _94 = (float3(float3(_62_m4, _62_m4, _62_m4)) * _94) + _200.xyz;
    _94 = (_94 * _552) + (-_62_m1.xyz);
    _119 = vs_TEXCOORD5;
    _119 = clamp(_119, 0.0f, 1.0f);
    _94 = (_119.xxx * _94) + _62_m1.xyz;
    _624 = float4(_94.x, _94.y, _94.z, _624.w);
    _624.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._624 = _624;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(_MIMIC_MONSTERONLY)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 _MainTex_ST;
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
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m2 unity_WorldTransformParams
#define _21_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _111;
static float4 _148;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _111 : NORMAL;
    float4 _148 : TANGENT;
    float2 _99 : TEXCOORD0;
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
static float4 _44;
static float _133;
static float3 _194;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    gl_Position = (_21_m3[3] * _44.wwww) + _9;
    vs_TEXCOORD0 = (_99 * _21_m4.xy) + _21_m4.zw;
    _9.y = dot(_111, _21_m1[0].xyz);
    _9.z = dot(_111, _21_m1[1].xyz);
    _9.x = dot(_111, _21_m1[2].xyz);
    _133 = dot(_9.xyz, _9.xyz);
    _133 = rsqrt(_133);
    float3 _145 = _133.xxx * _9.xyz;
    _9 = float4(_145.x, _145.y, _145.z, _9.w);
    float3 _154 = _148.yyy * _21_m0[1].yzx;
    _44 = float4(_154.x, _154.y, _154.z, _44.w);
    float3 _165 = (_21_m0[0].yzx * _148.xxx) + _44.xyz;
    _44 = float4(_165.x, _165.y, _165.z, _44.w);
    float3 _176 = (_21_m0[2].yzx * _148.zzz) + _44.xyz;
    _44 = float4(_176.x, _176.y, _176.z, _44.w);
    _133 = dot(_44.xyz, _44.xyz);
    _133 = rsqrt(_133);
    float3 _190 = _133.xxx * _44.xyz;
    _44 = float4(_190.x, _190.y, _190.z, _44.w);
    _194 = _9.xyz * _44.xyz;
    _194 = (_9.zxy * _44.yzx) + (-_194);
    _194 *= _148.www;
    _194 *= _21_m2.www;
    vs_TEXCOORD2.y = _194.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _194.y;
    vs_TEXCOORD4.y = _194.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _111 = stage_input._111;
    _148 = stage_input._148;
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
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float _BumpScale;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _42_m0 _WorldSpaceLightPos0
#define _42_m1 _LightColor0
#define _42_m2 _BumpScale
#define _42_m3 _VolumeMin
#define _42_m4 _VolumeInvSize
#define _42_m5 _GlobalVolumeMin
#define _42_m6 _GlobalVolumeInvSize


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _530;

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
    float4 _530 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float3 _52;
static float _77;
static bool _89;
static float3 _95;
static float4 _110;
static float4 _151;
static float4 _159;
static float3 _173;
static float3 _182;
static float _191;
static float3 _278;
static float _287;
static float2 _404;
static bool _479;
static float3 _511;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    float3 _35 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _28 = float4(_35.x, _35.y, _35.z, _28.w);
    float2 _49 = _28.xy * _42_m2.xx;
    _28 = float4(_49.x, _49.y, _28.z, _28.w);
    _52.x = dot(vs_TEXCOORD2, _28.xyz);
    _52.y = dot(vs_TEXCOORD3, _28.xyz);
    _52.z = dot(vs_TEXCOORD4, _28.xyz);
    _77 = dot(_52, _52);
    _77 = rsqrt(_77);
    _52 = _77.xxx * _52;
    _89 = 1000000.0f < _42_m4.x;
    float3 _98;
    if (_89)
    {
        _98 = _42_m5;
    }
    else
    {
        _98 = _42_m3;
    }
    _95 = _98;
    float3 _112;
    if (_89)
    {
        _112 = _42_m6;
    }
    else
    {
        _112 = _42_m4;
    }
    _110 = float4(_112.x, _112.y, _112.z, _110.w);
    _95 = (-_95) + vs_TEXCOORD1;
    _95 = _110.xyz * _95;
    _28 = _Volume0.Sample(sampler_Volume0, _95).xywz;
    float3 _148 = max(_28.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _110 = float4(_148.x, _148.y, _148.z, _110.w);
    _151 = _Volume1.Sample(sampler_Volume0, _95).yxwz;
    _159 = _Volume2.Sample(sampler_Volume0, _95).xzwy;
    _28.x = _151.y;
    _28.y = _159.x;
    _173 = (_28.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _182 = _28.xyz * 0.5f.xxx;
    _77 = dot(_182, _182);
    _77 = sqrt(_77);
    _191 = dot(_173, _173);
    _191 = rsqrt(_191);
    _173 = _191.xxx * _173;
    _191 = dot(_173, _52);
    _191 = (_191 * 0.5f) + 0.5f;
    _191 = log2(_191);
    _173.x = _77 + _77;
    _77 /= _110.x;
    _173.x /= _110.x;
    float2 _227 = _173.xx + float2(1.0f, 2.0f);
    _173 = float3(_227.x, _227.y, _173.z);
    _191 *= _173.x;
    _191 = exp2(_191);
    _173.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _173.x / _77;
    _173.x = (-_77) + 1.0f;
    _173.x = _173.y * _173.x;
    _77 = (_173.x * _191) + _77;
    _173.x = _77 * _110.x;
    _159.x = _151.w;
    _151.y = _159.w;
    _182 = (_151.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _278 = _151.xyz * 0.5f.xxx;
    _77 = dot(_278, _278);
    _77 = sqrt(_77);
    _287 = dot(_182, _182);
    _287 = rsqrt(_287);
    _278 = _287.xxx * _182;
    _287 = dot(_278, _52);
    _287 = (_287 * 0.5f) + 0.5f;
    _287 = log2(_287);
    _110.x = _77 + _77;
    _77 /= _110.y;
    _110.x /= _110.y;
    float2 _321 = _110.xx + float2(1.0f, 2.0f);
    _110 = float4(_321.x, _110.y, _110.z, _321.y);
    _287 *= _110.x;
    _287 = exp2(_287);
    _110.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _110.x / _77;
    _110.x = (-_77) + 1.0f;
    _110.x = _110.w * _110.x;
    _77 = (_110.x * _287) + _77;
    _173.y = _77 * _110.y;
    float3 _364 = (_159.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _110 = float4(_364.x, _364.y, _110.z, _364.z);
    _95 = _159.xyz * 0.5f.xxx;
    _77 = dot(_95, _95);
    _77 = sqrt(_77);
    _95.x = dot(_110.xyw, _110.xyw);
    _95.x = rsqrt(_95.x);
    _95 = _95.xxx * _110.xyw;
    _95.x = dot(_95, _52);
    _95.x = (_95.x * 0.5f) + 0.5f;
    _95.x = log2(_95.x);
    _404.x = _77 + _77;
    _77 /= _110.z;
    _404.x /= _110.z;
    _404 = _404.xx + float2(1.0f, 2.0f);
    _95.x *= _404.x;
    _95.x = exp2(_95.x);
    _404.x = (-_77) + 1.0f;
    _77 += 1.0f;
    _77 = _404.x / _77;
    _404.x = (-_77) + 1.0f;
    _404.x = _404.y * _404.x;
    _77 = (_404.x * _95.x) + _77;
    _173.z = _77 * _110.z;
    _95 = max(_173, 0.0f.xxx);
    _77 = dot(_42_m0.xyz, _42_m0.xyz);
    _77 = sqrt(_77);
    _479 = 9.9999997473787516355514526367188e-05f < _77;
    float3 _488 = _42_m0.xyz / _77.xxx;
    _110 = float4(_488.x, _488.y, _488.z, _110.w);
    float3 _492;
    if (_479)
    {
        _492 = _110.xyz;
    }
    else
    {
        _492 = float3(0.0f, 1.0f, 0.0f);
    }
    _110 = float4(_492.x, _492.y, _492.z, _110.w);
    _52.x = dot(_52, _110.xyz);
    _52.x = clamp(_52.x, 0.0f, 1.0f);
    _511 = (_42_m1.xyz * _52.xxx) + _95;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    float3 _533 = _511 * _9;
    _530 = float4(_533.x, _533.y, _533.z, _530.w);
    _530.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._530 = _530;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 _MainTex_ST;
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
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m2 unity_WorldTransformParams
#define _21_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _111;
static float4 _148;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _111 : NORMAL;
    float4 _148 : TANGENT;
    float2 _99 : TEXCOORD0;
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
static float4 _44;
static float _133;
static float3 _194;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    gl_Position = (_21_m3[3] * _44.wwww) + _9;
    vs_TEXCOORD0 = (_99 * _21_m4.xy) + _21_m4.zw;
    _9.y = dot(_111, _21_m1[0].xyz);
    _9.z = dot(_111, _21_m1[1].xyz);
    _9.x = dot(_111, _21_m1[2].xyz);
    _133 = dot(_9.xyz, _9.xyz);
    _133 = rsqrt(_133);
    float3 _145 = _133.xxx * _9.xyz;
    _9 = float4(_145.x, _145.y, _145.z, _9.w);
    float3 _154 = _148.yyy * _21_m0[1].yzx;
    _44 = float4(_154.x, _154.y, _154.z, _44.w);
    float3 _165 = (_21_m0[0].yzx * _148.xxx) + _44.xyz;
    _44 = float4(_165.x, _165.y, _165.z, _44.w);
    float3 _176 = (_21_m0[2].yzx * _148.zzz) + _44.xyz;
    _44 = float4(_176.x, _176.y, _176.z, _44.w);
    _133 = dot(_44.xyz, _44.xyz);
    _133 = rsqrt(_133);
    float3 _190 = _133.xxx * _44.xyz;
    _44 = float4(_190.x, _190.y, _190.z, _44.w);
    _194 = _9.xyz * _44.xyz;
    _194 = (_9.zxy * _44.yzx) + (-_194);
    _194 *= _148.www;
    _194 *= _21_m2.www;
    vs_TEXCOORD2.y = _194.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _194.y;
    vs_TEXCOORD4.y = _194.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _111 = stage_input._111;
    _148 = stage_input._148;
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
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float _BumpScale;
float _Morph;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
#define _62_m0 _WorldSpaceLightPos0
#define _62_m1 _LightColor0
#define _62_m2 _BumpScale
#define _62_m3 _Morph
#define _62_m4 _VolumeMin
#define _62_m5 _VolumeInvSize
#define _62_m6 _GlobalVolumeMin
#define _62_m7 _GlobalVolumeInvSize


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _602;

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
    float4 _602 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float4 _46;
static float3 _94;
static float _119;
static bool _131;
static float3 _137;
static float4 _152;
static float4 _200;
static float3 _214;
static float3 _223;
static float _232;
static float3 _319;
static float _328;
static float2 _445;
static bool _520;
static float3 _552;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    float3 _35 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _28 = float4(_35.x, _35.y, _35.z, _28.w);
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _49 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _46 = float4(_49.x, _49.y, _49.z, _46.w);
    float3 _57 = _28.xyz + (-_46.xyz);
    _28 = float4(_57.x, _57.y, _57.z, _28.w);
    float3 _82 = (float3(float3(_62_m3, _62_m3, _62_m3)) * _28.xyz) + _46.xyz;
    _28 = float4(_82.x, _82.y, _82.z, _28.w);
    float2 _91 = _28.xy * _62_m2.xx;
    _28 = float4(_91.x, _91.y, _28.z, _28.w);
    _94.x = dot(vs_TEXCOORD2, _28.xyz);
    _94.y = dot(vs_TEXCOORD3, _28.xyz);
    _94.z = dot(vs_TEXCOORD4, _28.xyz);
    _119 = dot(_94, _94);
    _119 = rsqrt(_119);
    _94 = _119.xxx * _94;
    _131 = 1000000.0f < _62_m5.x;
    float3 _140;
    if (_131)
    {
        _140 = _62_m6;
    }
    else
    {
        _140 = _62_m4;
    }
    _137 = _140;
    float3 _154;
    if (_131)
    {
        _154 = _62_m7;
    }
    else
    {
        _154 = _62_m5;
    }
    _152 = float4(_154.x, _154.y, _154.z, _152.w);
    _137 = (-_137) + vs_TEXCOORD1;
    _137 = _152.xyz * _137;
    _28 = _Volume0.Sample(sampler_Volume0, _137).xywz;
    float3 _190 = max(_28.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _152 = float4(_190.x, _190.y, _190.z, _152.w);
    _46 = _Volume1.Sample(sampler_Volume0, _137).yxwz;
    _200 = _Volume2.Sample(sampler_Volume0, _137).xzwy;
    _28.x = _46.y;
    _28.y = _200.x;
    _214 = (_28.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _223 = _28.xyz * 0.5f.xxx;
    _119 = dot(_223, _223);
    _119 = sqrt(_119);
    _232 = dot(_214, _214);
    _232 = rsqrt(_232);
    _214 = _232.xxx * _214;
    _232 = dot(_214, _94);
    _232 = (_232 * 0.5f) + 0.5f;
    _232 = log2(_232);
    _214.x = _119 + _119;
    _119 /= _152.x;
    _214.x /= _152.x;
    float2 _268 = _214.xx + float2(1.0f, 2.0f);
    _214 = float3(_268.x, _268.y, _214.z);
    _232 *= _214.x;
    _232 = exp2(_232);
    _214.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _214.x / _119;
    _214.x = (-_119) + 1.0f;
    _214.x = _214.y * _214.x;
    _119 = (_214.x * _232) + _119;
    _214.x = _119 * _152.x;
    _200.x = _46.w;
    _46.y = _200.w;
    _223 = (_46.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _319 = _46.xyz * 0.5f.xxx;
    _119 = dot(_319, _319);
    _119 = sqrt(_119);
    _328 = dot(_223, _223);
    _328 = rsqrt(_328);
    _223 = _328.xxx * _223;
    _328 = dot(_223, _94);
    _328 = (_328 * 0.5f) + 0.5f;
    _328 = log2(_328);
    _152.x = _119 + _119;
    _119 /= _152.y;
    _152.x /= _152.y;
    float2 _362 = _152.xx + float2(1.0f, 2.0f);
    _152 = float4(_362.x, _152.y, _152.z, _362.y);
    _328 *= _152.x;
    _328 = exp2(_328);
    _152.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _152.x / _119;
    _152.x = (-_119) + 1.0f;
    _152.x = _152.w * _152.x;
    _119 = (_152.x * _328) + _119;
    _214.y = _119 * _152.y;
    float3 _405 = (_200.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
    _152 = float4(_405.x, _405.y, _152.z, _405.z);
    _137 = _200.xyz * 0.5f.xxx;
    _119 = dot(_137, _137);
    _119 = sqrt(_119);
    _137.x = dot(_152.xyw, _152.xyw);
    _137.x = rsqrt(_137.x);
    _137 = _137.xxx * _152.xyw;
    _137.x = dot(_137, _94);
    _137.x = (_137.x * 0.5f) + 0.5f;
    _137.x = log2(_137.x);
    _445.x = _119 + _119;
    _119 /= _152.z;
    _445.x /= _152.z;
    _445 = _445.xx + float2(1.0f, 2.0f);
    _137.x *= _445.x;
    _137.x = exp2(_137.x);
    _445.x = (-_119) + 1.0f;
    _119 += 1.0f;
    _119 = _445.x / _119;
    _445.x = (-_119) + 1.0f;
    _445.x = _445.y * _445.x;
    _119 = (_445.x * _137.x) + _119;
    _214.z = _119 * _152.z;
    _137 = max(_214, 0.0f.xxx);
    _119 = dot(_62_m0.xyz, _62_m0.xyz);
    _119 = sqrt(_119);
    _520 = 9.9999997473787516355514526367188e-05f < _119;
    float3 _529 = _62_m0.xyz / _119.xxx;
    _152 = float4(_529.x, _529.y, _529.z, _152.w);
    float3 _533;
    if (_520)
    {
        _533 = _152.xyz;
    }
    else
    {
        _533 = float3(0.0f, 1.0f, 0.0f);
    }
    _152 = float4(_533.x, _533.y, _533.z, _152.w);
    _94.x = dot(_94, _152.xyz);
    _94.x = clamp(_94.x, 0.0f, 1.0f);
    _552 = (_62_m1.xyz * _94.xxx) + _137;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    float3 _577 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _200 = float4(_577.x, _577.y, _577.z, _200.w);
    _94 = _9 + (-_200.xyz);
    _94 = (float3(float3(_62_m3, _62_m3, _62_m3)) * _94) + _200.xyz;
    float3 _605 = _552 * _94;
    _602 = float4(_605.x, _605.y, _605.z, _602.w);
    _602.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._602 = _602;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _141;
static float3 _153;
static float4 _187;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _153 : NORMAL;
    float4 _187 : TANGENT;
    float2 _141 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD1 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _172;
static float3 _233;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m5.y;
    vs_TEXCOORD5 = exp2(-_9.x);
    vs_TEXCOORD0 = (_141 * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_153, _21_m2[0].xyz);
    _9.z = dot(_153, _21_m2[1].xyz);
    _9.x = dot(_153, _21_m2[2].xyz);
    _172 = dot(_9.xyz, _9.xyz);
    _172 = rsqrt(_172);
    float3 _184 = _172.xxx * _9.xyz;
    _9 = float4(_184.x, _184.y, _184.z, _9.w);
    float3 _193 = _187.yyy * _21_m1[1].yzx;
    _44 = float4(_193.x, _193.y, _193.z, _44.w);
    float3 _204 = (_21_m1[0].yzx * _187.xxx) + _44.xyz;
    _44 = float4(_204.x, _204.y, _204.z, _44.w);
    float3 _215 = (_21_m1[2].yzx * _187.zzz) + _44.xyz;
    _44 = float4(_215.x, _215.y, _215.z, _44.w);
    _172 = dot(_44.xyz, _44.xyz);
    _172 = rsqrt(_172);
    float3 _229 = _172.xxx * _44.xyz;
    _44 = float4(_229.x, _229.y, _229.z, _44.w);
    _233 = _9.xyz * _44.xyz;
    _233 = (_9.zxy * _44.yzx) + (-_233);
    _233 *= _187.www;
    _233 *= _21_m3.www;
    vs_TEXCOORD2.y = _233.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _233.y;
    vs_TEXCOORD4.y = _233.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _153 = stage_input._153;
    _187 = stage_input._187;
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
float _BumpScale;
float _Morph;
#define _49_m0 _WorldSpaceLightPos0
#define _49_m1 unity_SHAr
#define _49_m2 unity_SHAg
#define _49_m3 unity_SHAb
#define _49_m4 unity_SHBr
#define _49_m5 unity_SHBg
#define _49_m6 unity_SHBb
#define _49_m7 unity_SHC
#define _49_m8 unity_FogColor
#define _49_m9 _LightColor0
#define _49_m10 _BumpScale
#define _49_m11 _Morph


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _304;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _304 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float4 _36;
static float4 _78;
static float _100;
static float3 _134;
static bool _200;
static float3 _204;
static float3 _211;
static float3 _245;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _39 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _36 = float4(_39.x, _39.y, _39.z, _36.w);
    _22 += (-_36.xyz);
    _22 = (float3(float3(_49_m11, _49_m11, _49_m11)) * _22) + _36.xyz;
    float2 _75 = _22.xy * _49_m10.xx;
    _22 = float3(_75.x, _75.y, _22.z);
    _78.x = dot(vs_TEXCOORD2, _22);
    _78.y = dot(vs_TEXCOORD3, _22);
    _78.z = dot(vs_TEXCOORD4, _22);
    _100 = dot(_78.xyz, _78.xyz);
    _100 = rsqrt(_100);
    _78 = _100.xxxx * _78.xyzz;
    _22.x = _78.y * _78.y;
    _22.x = (_78.x * _78.x) + (-_22.x);
    _36 = _78.yzwx * _78.xywz;
    _134.x = dot(_49_m4, _36);
    _134.y = dot(_49_m5, _36);
    _134.z = dot(_49_m6, _36);
    _22 = (_49_m7.xyz * _22.xxx) + _134;
    _78.w = 1.0f;
    _36.x = dot(_49_m1, _78);
    _36.y = dot(_49_m2, _78);
    _36.z = dot(_49_m3, _78);
    _22 += _36.xyz;
    _100 = dot(_49_m0.xyz, _49_m0.xyz);
    _100 = sqrt(_100);
    _200 = 9.9999997473787516355514526367188e-05f < _100;
    _204 = _49_m0.xyz / _100.xxx;
    float3 _214;
    if (_200)
    {
        _214 = _204;
    }
    else
    {
        _214 = float3(0.0f, 1.0f, 0.0f);
    }
    _211 = _214;
    _78.x = dot(_78.xyz, _211);
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _22 = (_49_m9.xyz * _78.xxx) + _22;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    _245 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _254 = _9 + (-_245);
    _78 = float4(_254.x, _254.y, _254.z, _78.w);
    float3 _272 = (float3(float3(_49_m11, _49_m11, _49_m11)) * _78.xyz) + _245;
    _78 = float4(_272.x, _272.y, _272.z, _78.w);
    float3 _284 = (_78.xyz * _22) + (-_49_m8.xyz);
    _78 = float4(_284.x, _284.y, _284.z, _78.w);
    _100 = vs_TEXCOORD5;
    _100 = clamp(_100, 0.0f, 1.0f);
    float3 _300 = (_100.xxx * _78.xyz) + _49_m8.xyz;
    _78 = float4(_300.x, _300.y, _300.z, _78.w);
    _304 = float4(_78.xyz.x, _78.xyz.y, _78.xyz.z, _304.w);
    _304.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._304 = _304;
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
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _147;
static float3 _159;
static float4 _193;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _159 : NORMAL;
    float4 _193 : TANGENT;
    float2 _147 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD1 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _178;
static float3 _239;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m5.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD5 = exp2(_9.x);
    vs_TEXCOORD0 = (_147 * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_159, _21_m2[0].xyz);
    _9.z = dot(_159, _21_m2[1].xyz);
    _9.x = dot(_159, _21_m2[2].xyz);
    _178 = dot(_9.xyz, _9.xyz);
    _178 = rsqrt(_178);
    float3 _190 = _178.xxx * _9.xyz;
    _9 = float4(_190.x, _190.y, _190.z, _9.w);
    float3 _199 = _193.yyy * _21_m1[1].yzx;
    _44 = float4(_199.x, _199.y, _199.z, _44.w);
    float3 _210 = (_21_m1[0].yzx * _193.xxx) + _44.xyz;
    _44 = float4(_210.x, _210.y, _210.z, _44.w);
    float3 _221 = (_21_m1[2].yzx * _193.zzz) + _44.xyz;
    _44 = float4(_221.x, _221.y, _221.z, _44.w);
    _178 = dot(_44.xyz, _44.xyz);
    _178 = rsqrt(_178);
    float3 _235 = _178.xxx * _44.xyz;
    _44 = float4(_235.x, _235.y, _235.z, _44.w);
    _239 = _9.xyz * _44.xyz;
    _239 = (_9.zxy * _44.yzx) + (-_239);
    _239 *= _193.www;
    _239 *= _21_m3.www;
    vs_TEXCOORD2.y = _239.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _239.y;
    vs_TEXCOORD4.y = _239.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _159 = stage_input._159;
    _193 = stage_input._193;
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
float _BumpScale;
float _Morph;
#define _49_m0 _WorldSpaceLightPos0
#define _49_m1 unity_SHAr
#define _49_m2 unity_SHAg
#define _49_m3 unity_SHAb
#define _49_m4 unity_SHBr
#define _49_m5 unity_SHBg
#define _49_m6 unity_SHBb
#define _49_m7 unity_SHC
#define _49_m8 unity_FogColor
#define _49_m9 _LightColor0
#define _49_m10 _BumpScale
#define _49_m11 _Morph


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _304;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _304 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float4 _36;
static float4 _78;
static float _100;
static float3 _134;
static bool _200;
static float3 _204;
static float3 _211;
static float3 _245;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _39 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _36 = float4(_39.x, _39.y, _39.z, _36.w);
    _22 += (-_36.xyz);
    _22 = (float3(float3(_49_m11, _49_m11, _49_m11)) * _22) + _36.xyz;
    float2 _75 = _22.xy * _49_m10.xx;
    _22 = float3(_75.x, _75.y, _22.z);
    _78.x = dot(vs_TEXCOORD2, _22);
    _78.y = dot(vs_TEXCOORD3, _22);
    _78.z = dot(vs_TEXCOORD4, _22);
    _100 = dot(_78.xyz, _78.xyz);
    _100 = rsqrt(_100);
    _78 = _100.xxxx * _78.xyzz;
    _22.x = _78.y * _78.y;
    _22.x = (_78.x * _78.x) + (-_22.x);
    _36 = _78.yzwx * _78.xywz;
    _134.x = dot(_49_m4, _36);
    _134.y = dot(_49_m5, _36);
    _134.z = dot(_49_m6, _36);
    _22 = (_49_m7.xyz * _22.xxx) + _134;
    _78.w = 1.0f;
    _36.x = dot(_49_m1, _78);
    _36.y = dot(_49_m2, _78);
    _36.z = dot(_49_m3, _78);
    _22 += _36.xyz;
    _100 = dot(_49_m0.xyz, _49_m0.xyz);
    _100 = sqrt(_100);
    _200 = 9.9999997473787516355514526367188e-05f < _100;
    _204 = _49_m0.xyz / _100.xxx;
    float3 _214;
    if (_200)
    {
        _214 = _204;
    }
    else
    {
        _214 = float3(0.0f, 1.0f, 0.0f);
    }
    _211 = _214;
    _78.x = dot(_78.xyz, _211);
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _22 = (_49_m9.xyz * _78.xxx) + _22;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    _245 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _254 = _9 + (-_245);
    _78 = float4(_254.x, _254.y, _254.z, _78.w);
    float3 _272 = (float3(float3(_49_m11, _49_m11, _49_m11)) * _78.xyz) + _245;
    _78 = float4(_272.x, _272.y, _272.z, _78.w);
    float3 _284 = (_78.xyz * _22) + (-_49_m8.xyz);
    _78 = float4(_284.x, _284.y, _284.z, _78.w);
    _100 = vs_TEXCOORD5;
    _100 = clamp(_100, 0.0f, 1.0f);
    float3 _300 = (_100.xxx * _78.xyz) + _49_m8.xyz;
    _78 = float4(_300.x, _300.y, _300.z, _78.w);
    _304 = float4(_78.xyz.x, _78.xyz.y, _78.xyz.z, _304.w);
    _304.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._304 = _304;
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
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m4[4];
float4 unity_FogParams;
float4 _MainTex_ST;
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
#define _21_m0 _ProjectionParams
#define _21_m3 unity_WorldTransformParams
#define _21_m5 unity_FogParams
#define _21_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _152;
static float4 _186;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _152 : NORMAL;
    float4 _186 : TANGENT;
    float2 _140 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD1 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _171;
static float3 _232;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _44.xxxx) + _9;
    _9 = (_21_m4[2] * _44.zzzz) + _9;
    _9 = (_21_m4[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD5 = (_9.x * _21_m5.z) + _21_m5.w;
    vs_TEXCOORD0 = (_140 * _21_m6.xy) + _21_m6.zw;
    _9.y = dot(_152, _21_m2[0].xyz);
    _9.z = dot(_152, _21_m2[1].xyz);
    _9.x = dot(_152, _21_m2[2].xyz);
    _171 = dot(_9.xyz, _9.xyz);
    _171 = rsqrt(_171);
    float3 _183 = _171.xxx * _9.xyz;
    _9 = float4(_183.x, _183.y, _183.z, _9.w);
    float3 _192 = _186.yyy * _21_m1[1].yzx;
    _44 = float4(_192.x, _192.y, _192.z, _44.w);
    float3 _203 = (_21_m1[0].yzx * _186.xxx) + _44.xyz;
    _44 = float4(_203.x, _203.y, _203.z, _44.w);
    float3 _214 = (_21_m1[2].yzx * _186.zzz) + _44.xyz;
    _44 = float4(_214.x, _214.y, _214.z, _44.w);
    _171 = dot(_44.xyz, _44.xyz);
    _171 = rsqrt(_171);
    float3 _228 = _171.xxx * _44.xyz;
    _44 = float4(_228.x, _228.y, _228.z, _44.w);
    _232 = _9.xyz * _44.xyz;
    _232 = (_9.zxy * _44.yzx) + (-_232);
    _232 *= _186.www;
    _232 *= _21_m3.www;
    vs_TEXCOORD2.y = _232.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _232.y;
    vs_TEXCOORD4.y = _232.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _152 = stage_input._152;
    _186 = stage_input._186;
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
float _BumpScale;
float _Morph;
#define _49_m0 _WorldSpaceLightPos0
#define _49_m1 unity_SHAr
#define _49_m2 unity_SHAg
#define _49_m3 unity_SHAb
#define _49_m4 unity_SHBr
#define _49_m5 unity_SHBg
#define _49_m6 unity_SHBb
#define _49_m7 unity_SHC
#define _49_m8 unity_FogColor
#define _49_m9 _LightColor0
#define _49_m10 _BumpScale
#define _49_m11 _Morph


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 _304;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _304 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float4 _36;
static float4 _78;
static float _100;
static float3 _134;
static bool _200;
static float3 _204;
static float3 _211;
static float3 _245;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _39 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _36 = float4(_39.x, _39.y, _39.z, _36.w);
    _22 += (-_36.xyz);
    _22 = (float3(float3(_49_m11, _49_m11, _49_m11)) * _22) + _36.xyz;
    float2 _75 = _22.xy * _49_m10.xx;
    _22 = float3(_75.x, _75.y, _22.z);
    _78.x = dot(vs_TEXCOORD2, _22);
    _78.y = dot(vs_TEXCOORD3, _22);
    _78.z = dot(vs_TEXCOORD4, _22);
    _100 = dot(_78.xyz, _78.xyz);
    _100 = rsqrt(_100);
    _78 = _100.xxxx * _78.xyzz;
    _22.x = _78.y * _78.y;
    _22.x = (_78.x * _78.x) + (-_22.x);
    _36 = _78.yzwx * _78.xywz;
    _134.x = dot(_49_m4, _36);
    _134.y = dot(_49_m5, _36);
    _134.z = dot(_49_m6, _36);
    _22 = (_49_m7.xyz * _22.xxx) + _134;
    _78.w = 1.0f;
    _36.x = dot(_49_m1, _78);
    _36.y = dot(_49_m2, _78);
    _36.z = dot(_49_m3, _78);
    _22 += _36.xyz;
    _100 = dot(_49_m0.xyz, _49_m0.xyz);
    _100 = sqrt(_100);
    _200 = 9.9999997473787516355514526367188e-05f < _100;
    _204 = _49_m0.xyz / _100.xxx;
    float3 _214;
    if (_200)
    {
        _214 = _204;
    }
    else
    {
        _214 = float3(0.0f, 1.0f, 0.0f);
    }
    _211 = _214;
    _78.x = dot(_78.xyz, _211);
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _22 = (_49_m9.xyz * _78.xxx) + _22;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    _245 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _254 = _9 + (-_245);
    _78 = float4(_254.x, _254.y, _254.z, _78.w);
    float3 _272 = (float3(float3(_49_m11, _49_m11, _49_m11)) * _78.xyz) + _245;
    _78 = float4(_272.x, _272.y, _272.z, _78.w);
    float3 _284 = (_78.xyz * _22) + (-_49_m8.xyz);
    _78 = float4(_284.x, _284.y, _284.z, _78.w);
    _100 = vs_TEXCOORD5;
    _100 = clamp(_100, 0.0f, 1.0f);
    float3 _300 = (_100.xxx * _78.xyz) + _49_m8.xyz;
    _78 = float4(_300.x, _300.y, _300.z, _78.w);
    _304 = float4(_78.xyz.x, _78.xyz.y, _78.xyz.z, _304.w);
    _304.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._304 = _304;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 _MainTex_ST;
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
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m2 unity_WorldTransformParams
#define _21_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _111;
static float4 _148;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _111 : NORMAL;
    float4 _148 : TANGENT;
    float2 _99 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD1 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _133;
static float3 _194;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    gl_Position = (_21_m3[3] * _44.wwww) + _9;
    vs_TEXCOORD0 = (_99 * _21_m4.xy) + _21_m4.zw;
    _9.y = dot(_111, _21_m1[0].xyz);
    _9.z = dot(_111, _21_m1[1].xyz);
    _9.x = dot(_111, _21_m1[2].xyz);
    _133 = dot(_9.xyz, _9.xyz);
    _133 = rsqrt(_133);
    float3 _145 = _133.xxx * _9.xyz;
    _9 = float4(_145.x, _145.y, _145.z, _9.w);
    float3 _154 = _148.yyy * _21_m0[1].yzx;
    _44 = float4(_154.x, _154.y, _154.z, _44.w);
    float3 _165 = (_21_m0[0].yzx * _148.xxx) + _44.xyz;
    _44 = float4(_165.x, _165.y, _165.z, _44.w);
    float3 _176 = (_21_m0[2].yzx * _148.zzz) + _44.xyz;
    _44 = float4(_176.x, _176.y, _176.z, _44.w);
    _133 = dot(_44.xyz, _44.xyz);
    _133 = rsqrt(_133);
    float3 _190 = _133.xxx * _44.xyz;
    _44 = float4(_190.x, _190.y, _190.z, _44.w);
    _194 = _9.xyz * _44.xyz;
    _194 = (_9.zxy * _44.yzx) + (-_194);
    _194 *= _148.www;
    _194 *= _21_m2.www;
    vs_TEXCOORD2.y = _194.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _194.y;
    vs_TEXCOORD4.y = _194.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _111 = stage_input._111;
    _148 = stage_input._148;
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
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4 _LightColor0;
float _BumpScale;
float _Morph;
#define _49_m0 _WorldSpaceLightPos0
#define _49_m1 unity_SHAr
#define _49_m2 unity_SHAg
#define _49_m3 unity_SHAb
#define _49_m4 unity_SHBr
#define _49_m5 unity_SHBg
#define _49_m6 unity_SHBb
#define _49_m7 unity_SHC
#define _49_m8 _LightColor0
#define _49_m9 _BumpScale
#define _49_m10 _Morph


Texture2D<float4> _MonsterBumpMap;
SamplerState sampler_MonsterBumpMap;
Texture2D<float4> _BumpMap;
SamplerState sampler_BumpMap;
Texture2D<float4> _MonsterTex;
SamplerState sampler_MonsterTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float4 _276;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _276 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float4 _36;
static float4 _78;
static float _100;
static float3 _134;
static bool _200;
static float3 _204;
static float3 _211;
static float3 _245;

void frag_inner()
{
    _9 = _MonsterBumpMap.Sample(sampler_MonsterBumpMap, vs_TEXCOORD0).xyz;
    _22 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _9 = LA_UnpackNormalTex(_BumpMap.Sample(sampler_BumpMap, vs_TEXCOORD0)).xyz;
    float3 _39 = (_9 * 2.0f.xxx) + (-1.0f).xxx;
    _36 = float4(_39.x, _39.y, _39.z, _36.w);
    _22 += (-_36.xyz);
    _22 = (float3(float3(_49_m10, _49_m10, _49_m10)) * _22) + _36.xyz;
    float2 _75 = _22.xy * _49_m9.xx;
    _22 = float3(_75.x, _75.y, _22.z);
    _78.x = dot(vs_TEXCOORD2, _22);
    _78.y = dot(vs_TEXCOORD3, _22);
    _78.z = dot(vs_TEXCOORD4, _22);
    _100 = dot(_78.xyz, _78.xyz);
    _100 = rsqrt(_100);
    _78 = _100.xxxx * _78.xyzz;
    _22.x = _78.y * _78.y;
    _22.x = (_78.x * _78.x) + (-_22.x);
    _36 = _78.yzwx * _78.xywz;
    _134.x = dot(_49_m4, _36);
    _134.y = dot(_49_m5, _36);
    _134.z = dot(_49_m6, _36);
    _22 = (_49_m7.xyz * _22.xxx) + _134;
    _78.w = 1.0f;
    _36.x = dot(_49_m1, _78);
    _36.y = dot(_49_m2, _78);
    _36.z = dot(_49_m3, _78);
    _22 += _36.xyz;
    _100 = dot(_49_m0.xyz, _49_m0.xyz);
    _100 = sqrt(_100);
    _200 = 9.9999997473787516355514526367188e-05f < _100;
    _204 = _49_m0.xyz / _100.xxx;
    float3 _214;
    if (_200)
    {
        _214 = _204;
    }
    else
    {
        _214 = float3(0.0f, 1.0f, 0.0f);
    }
    _211 = _214;
    _78.x = dot(_78.xyz, _211);
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _22 = (_49_m8.xyz * _78.xxx) + _22;
    _9 = _MonsterTex.Sample(sampler_MonsterTex, vs_TEXCOORD0).xyz;
    _245 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _254 = _9 + (-_245);
    _78 = float4(_254.x, _254.y, _254.z, _78.w);
    float3 _272 = (float3(float3(_49_m10, _49_m10, _49_m10)) * _78.xyz) + _245;
    _78 = float4(_272.x, _272.y, _272.z, _78.w);
    float3 _280 = _22 * _78.xyz;
    _276 = float4(_280.x, _280.y, _280.z, _276.w);
    _276.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._276 = _276;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}