// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MirrorFade" {
Properties {

[Header(Reflection)] _MainTex ("Reflection (RenderTexture)", 2D) = "black" { }

_Color ("Reflection Tint", Color) = (1,1,1,1)

_EmissionColor ("Reflection Emission", Color) = (1,1,1,1)

[Header(Dormant Proto)] _ProtoTex ("Proto Texture", 2D) = "grey" { }

_ProtoColor ("Proto Tint", Color) = (1,1,1,1)

_ParallaxDepth ("Proto Parallax Depth", Range(0, 0.5)) = 0.05999999865889549

_ProtoEmission ("Proto Emission", Range(0, 2)) = 0.0

[Header(Blend)] _Fade ("Fade  0 = proto, 1 = mirror", Range(0, 1)) = 0.0

_FadeEmission ("Fade Emission", Range(0, 1)) = 0.0

[Header(Surface)] _Glossiness ("Smoothness", Range(0, 1)) = 0.699999988079071

_Metallic ("Metallic", Range(0, 1)) = 0.0

}
SubShader {
 LOD 200
 Tags { "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
 Name "FORWARD"
  LOD 200
  Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile __ DIRECTIONAL
#pragma multi_compile __ LIGHTPROBE_SH
#pragma multi_compile __ SHADOWS_SCREEN
#pragma multi_compile __ VERTEXLIGHT_ON
#if defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _132;
static float3 _161;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _161 : NORMAL;
    float4 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _209;
static float4 _222;
static float3 _319;
static float4 _336;
static float3 _342;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m13.y;
    vs_TEXCOORD4 = exp2(-_102);
    float2 _144 = (_132.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_144.x, _144.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _157 = (_132.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _157.x, _157.y);
    _47.x = dot(_161, _23_m11[0].xyz);
    _47.y = dot(_161, _23_m11[1].xyz);
    _47.z = dot(_161, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _193 = _102.xxx * _47.xyz;
    _47 = float4(_193.x, _193.y, _193.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _209 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _222 = _47.yyyy * _209;
    _209 *= _209;
    _209 = (_65 * _65) + _209;
    _65 = (_65 * _47.xxxx) + _222;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _209;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _209 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _209;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _282 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_282.x, _282.y, _282.z, _65.w);
    float3 _293 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_293.x, _293.y, _293.z, _65.w);
    float3 _304 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_304.x, _304.y, _304.z, _9.w);
    float3 _315 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_315.x, _315.y, _315.z, _9.w);
    _319.x = _47.y * _47.y;
    _319.x = (_47.x * _47.x) + (-_319.x);
    _336 = _47.yzzx * _47.xyzz;
    _342.x = dot(_23_m6, _336);
    _342.y = dot(_23_m7, _336);
    _342.z = dot(_23_m8, _336);
    _319 = (_23_m9.xyz * _319.xxx) + _342;
    vs_TEXCOORD3 = _9.xyz + _319;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _161 = stage_input._161;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _136;
static float3 _165;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _165 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _212;
static float4 _225;
static float3 _322;
static float4 _339;
static float3 _345;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m13.x;
    _102 *= (-_102);
    vs_TEXCOORD4 = exp2(_102);
    float2 _148 = (_136.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_148.x, _148.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _161 = (_136.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _161.x, _161.y);
    _47.x = dot(_165, _23_m11[0].xyz);
    _47.y = dot(_165, _23_m11[1].xyz);
    _47.z = dot(_165, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _196 = _102.xxx * _47.xyz;
    _47 = float4(_196.x, _196.y, _196.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _212 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _225 = _47.yyyy * _212;
    _212 *= _212;
    _212 = (_65 * _65) + _212;
    _65 = (_65 * _47.xxxx) + _225;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _212;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _212 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _212;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _285 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_285.x, _285.y, _285.z, _65.w);
    float3 _296 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_296.x, _296.y, _296.z, _65.w);
    float3 _307 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_307.x, _307.y, _307.z, _9.w);
    float3 _318 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_318.x, _318.y, _318.z, _9.w);
    _322.x = _47.y * _47.y;
    _322.x = (_47.x * _47.x) + (-_322.x);
    _339 = _47.yzzx * _47.xyzz;
    _345.x = dot(_23_m6, _339);
    _345.y = dot(_23_m7, _339);
    _345.z = dot(_23_m8, _339);
    _322 = (_23_m9.xyz * _322.xxx) + _345;
    vs_TEXCOORD3 = _9.xyz + _322;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _165 = stage_input._165;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _133;
static float3 _162;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _162 : NORMAL;
    float4 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _210;
static float4 _223;
static float3 _320;
static float4 _337;
static float3 _343;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    vs_TEXCOORD4 = (_102 * _23_m13.z) + _23_m13.w;
    float2 _145 = (_133.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_145.x, _145.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _158 = (_133.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _158.x, _158.y);
    _47.x = dot(_162, _23_m11[0].xyz);
    _47.y = dot(_162, _23_m11[1].xyz);
    _47.z = dot(_162, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _194 = _102.xxx * _47.xyz;
    _47 = float4(_194.x, _194.y, _194.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _210 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _223 = _47.yyyy * _210;
    _210 *= _210;
    _210 = (_65 * _65) + _210;
    _65 = (_65 * _47.xxxx) + _223;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _210;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _210 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _210;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _283 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_283.x, _283.y, _283.z, _65.w);
    float3 _294 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_294.x, _294.y, _294.z, _65.w);
    float3 _305 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_305.x, _305.y, _305.z, _9.w);
    float3 _316 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_316.x, _316.y, _316.z, _9.w);
    _320.x = _47.y * _47.y;
    _320.x = (_47.x * _47.x) + (-_320.x);
    _337 = _47.yzzx * _47.xyzz;
    _343.x = dot(_23_m6, _337);
    _343.y = dot(_23_m7, _337);
    _343.z = dot(_23_m8, _337);
    _320 = (_23_m9.xyz * _320.xxx) + _343;
    vs_TEXCOORD3 = _9.xyz + _320;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _162 = stage_input._162;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _139;
static float3 _168;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _168 : NORMAL;
    float4 _139 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _188;
static float _206;
static float4 _220;
static float3 _227;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m8.y;
    vs_TEXCOORD4 = exp2(-_9.x);
    float2 _151 = (_139.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_151.x, _151.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _164 = (_139.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _164.x, _164.y);
    _9.x = dot(_168, _21_m6[0].xyz);
    _9.y = dot(_168, _21_m6[1].xyz);
    _9.z = dot(_168, _21_m6[2].xyz);
    _188 = dot(_9.xyz, _9.xyz);
    _188 = rsqrt(_188);
    float3 _200 = _188.xxx * _9.xyz;
    _9 = float4(_200.x, _200.y, _200.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _206 = _9.y * _9.y;
    _206 = (_9.x * _9.x) + (-_206);
    _220 = _9.yzzx * _9.xyzz;
    _227.x = dot(_21_m1, _220);
    _227.y = dot(_21_m2, _220);
    _227.z = dot(_21_m3, _220);
    vs_TEXCOORD3 = (_21_m4.xyz * _206.xxx) + _227;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _168 = stage_input._168;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _132;
static float3 _161;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _161 : NORMAL;
    float4 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _209;
static float4 _222;
static float3 _319;
static float4 _336;
static float3 _342;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m13.y;
    vs_TEXCOORD4 = exp2(-_102);
    float2 _144 = (_132.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_144.x, _144.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _157 = (_132.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _157.x, _157.y);
    _47.x = dot(_161, _23_m11[0].xyz);
    _47.y = dot(_161, _23_m11[1].xyz);
    _47.z = dot(_161, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _193 = _102.xxx * _47.xyz;
    _47 = float4(_193.x, _193.y, _193.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _209 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _222 = _47.yyyy * _209;
    _209 *= _209;
    _209 = (_65 * _65) + _209;
    _65 = (_65 * _47.xxxx) + _222;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _209;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _209 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _209;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _282 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_282.x, _282.y, _282.z, _65.w);
    float3 _293 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_293.x, _293.y, _293.z, _65.w);
    float3 _304 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_304.x, _304.y, _304.z, _9.w);
    float3 _315 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_315.x, _315.y, _315.z, _9.w);
    _319.x = _47.y * _47.y;
    _319.x = (_47.x * _47.x) + (-_319.x);
    _336 = _47.yzzx * _47.xyzz;
    _342.x = dot(_23_m6, _336);
    _342.y = dot(_23_m7, _336);
    _342.z = dot(_23_m8, _336);
    _319 = (_23_m9.xyz * _319.xxx) + _342;
    vs_TEXCOORD3 = _9.xyz + _319;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _161 = stage_input._161;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _132;
static float3 _161;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _161 : NORMAL;
    float4 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _209;
static float4 _222;
static float3 _319;
static float4 _336;
static float3 _342;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m13.y;
    vs_TEXCOORD4 = exp2(-_102);
    float2 _144 = (_132.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_144.x, _144.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _157 = (_132.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _157.x, _157.y);
    _47.x = dot(_161, _23_m11[0].xyz);
    _47.y = dot(_161, _23_m11[1].xyz);
    _47.z = dot(_161, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _193 = _102.xxx * _47.xyz;
    _47 = float4(_193.x, _193.y, _193.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _209 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _222 = _47.yyyy * _209;
    _209 *= _209;
    _209 = (_65 * _65) + _209;
    _65 = (_65 * _47.xxxx) + _222;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _209;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _209 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _209;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _282 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_282.x, _282.y, _282.z, _65.w);
    float3 _293 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_293.x, _293.y, _293.z, _65.w);
    float3 _304 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_304.x, _304.y, _304.z, _9.w);
    float3 _315 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_315.x, _315.y, _315.z, _9.w);
    _319.x = _47.y * _47.y;
    _319.x = (_47.x * _47.x) + (-_319.x);
    _336 = _47.yzzx * _47.xyzz;
    _342.x = dot(_23_m6, _336);
    _342.y = dot(_23_m7, _336);
    _342.z = dot(_23_m8, _336);
    _319 = (_23_m9.xyz * _319.xxx) + _342;
    vs_TEXCOORD3 = _9.xyz + _319;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _161 = stage_input._161;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _145;
static float3 _174;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _174 : NORMAL;
    float4 _145 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _194;
static float _212;
static float4 _226;
static float3 _233;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m8.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD4 = exp2(_9.x);
    float2 _157 = (_145.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_157.x, _157.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _170 = (_145.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _170.x, _170.y);
    _9.x = dot(_174, _21_m6[0].xyz);
    _9.y = dot(_174, _21_m6[1].xyz);
    _9.z = dot(_174, _21_m6[2].xyz);
    _194 = dot(_9.xyz, _9.xyz);
    _194 = rsqrt(_194);
    float3 _206 = _194.xxx * _9.xyz;
    _9 = float4(_206.x, _206.y, _206.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _212 = _9.y * _9.y;
    _212 = (_9.x * _9.x) + (-_212);
    _226 = _9.yzzx * _9.xyzz;
    _233.x = dot(_21_m1, _226);
    _233.y = dot(_21_m2, _226);
    _233.z = dot(_21_m3, _226);
    vs_TEXCOORD3 = (_21_m4.xyz * _212.xxx) + _233;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    _174 = stage_input._174;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _136;
static float3 _165;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _165 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _212;
static float4 _225;
static float3 _322;
static float4 _339;
static float3 _345;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m13.x;
    _102 *= (-_102);
    vs_TEXCOORD4 = exp2(_102);
    float2 _148 = (_136.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_148.x, _148.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _161 = (_136.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _161.x, _161.y);
    _47.x = dot(_165, _23_m11[0].xyz);
    _47.y = dot(_165, _23_m11[1].xyz);
    _47.z = dot(_165, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _196 = _102.xxx * _47.xyz;
    _47 = float4(_196.x, _196.y, _196.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _212 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _225 = _47.yyyy * _212;
    _212 *= _212;
    _212 = (_65 * _65) + _212;
    _65 = (_65 * _47.xxxx) + _225;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _212;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _212 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _212;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _285 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_285.x, _285.y, _285.z, _65.w);
    float3 _296 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_296.x, _296.y, _296.z, _65.w);
    float3 _307 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_307.x, _307.y, _307.z, _9.w);
    float3 _318 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_318.x, _318.y, _318.z, _9.w);
    _322.x = _47.y * _47.y;
    _322.x = (_47.x * _47.x) + (-_322.x);
    _339 = _47.yzzx * _47.xyzz;
    _345.x = dot(_23_m6, _339);
    _345.y = dot(_23_m7, _339);
    _345.z = dot(_23_m8, _339);
    _322 = (_23_m9.xyz * _322.xxx) + _345;
    vs_TEXCOORD3 = _9.xyz + _322;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _165 = stage_input._165;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _136;
static float3 _165;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _165 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _212;
static float4 _225;
static float3 _322;
static float4 _339;
static float3 _345;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m13.x;
    _102 *= (-_102);
    vs_TEXCOORD4 = exp2(_102);
    float2 _148 = (_136.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_148.x, _148.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _161 = (_136.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _161.x, _161.y);
    _47.x = dot(_165, _23_m11[0].xyz);
    _47.y = dot(_165, _23_m11[1].xyz);
    _47.z = dot(_165, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _196 = _102.xxx * _47.xyz;
    _47 = float4(_196.x, _196.y, _196.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _212 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _225 = _47.yyyy * _212;
    _212 *= _212;
    _212 = (_65 * _65) + _212;
    _65 = (_65 * _47.xxxx) + _225;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _212;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _212 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _212;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _285 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_285.x, _285.y, _285.z, _65.w);
    float3 _296 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_296.x, _296.y, _296.z, _65.w);
    float3 _307 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_307.x, _307.y, _307.z, _9.w);
    float3 _318 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_318.x, _318.y, _318.z, _9.w);
    _322.x = _47.y * _47.y;
    _322.x = (_47.x * _47.x) + (-_322.x);
    _339 = _47.yzzx * _47.xyzz;
    _345.x = dot(_23_m6, _339);
    _345.y = dot(_23_m7, _339);
    _345.z = dot(_23_m8, _339);
    _322 = (_23_m9.xyz * _322.xxx) + _345;
    vs_TEXCOORD3 = _9.xyz + _322;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _165 = stage_input._165;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _138;
static float3 _167;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _167 : NORMAL;
    float4 _138 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _187;
static float _205;
static float4 _219;
static float3 _226;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD4 = (_9.x * _21_m8.z) + _21_m8.w;
    float2 _150 = (_138.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_150.x, _150.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _163 = (_138.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _163.x, _163.y);
    _9.x = dot(_167, _21_m6[0].xyz);
    _9.y = dot(_167, _21_m6[1].xyz);
    _9.z = dot(_167, _21_m6[2].xyz);
    _187 = dot(_9.xyz, _9.xyz);
    _187 = rsqrt(_187);
    float3 _199 = _187.xxx * _9.xyz;
    _9 = float4(_199.x, _199.y, _199.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _205 = _9.y * _9.y;
    _205 = (_9.x * _9.x) + (-_205);
    _219 = _9.yzzx * _9.xyzz;
    _226.x = dot(_21_m1, _219);
    _226.y = dot(_21_m2, _219);
    _226.z = dot(_21_m3, _219);
    vs_TEXCOORD3 = (_21_m4.xyz * _205.xxx) + _226;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _167 = stage_input._167;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _133;
static float3 _162;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _162 : NORMAL;
    float4 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _210;
static float4 _223;
static float3 _320;
static float4 _337;
static float3 _343;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    vs_TEXCOORD4 = (_102 * _23_m13.z) + _23_m13.w;
    float2 _145 = (_133.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_145.x, _145.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _158 = (_133.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _158.x, _158.y);
    _47.x = dot(_162, _23_m11[0].xyz);
    _47.y = dot(_162, _23_m11[1].xyz);
    _47.z = dot(_162, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _194 = _102.xxx * _47.xyz;
    _47 = float4(_194.x, _194.y, _194.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _210 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _223 = _47.yyyy * _210;
    _210 *= _210;
    _210 = (_65 * _65) + _210;
    _65 = (_65 * _47.xxxx) + _223;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _210;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _210 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _210;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _283 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_283.x, _283.y, _283.z, _65.w);
    float3 _294 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_294.x, _294.y, _294.z, _65.w);
    float3 _305 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_305.x, _305.y, _305.z, _9.w);
    float3 _316 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_316.x, _316.y, _316.z, _9.w);
    _320.x = _47.y * _47.y;
    _320.x = (_47.x * _47.x) + (-_320.x);
    _337 = _47.yzzx * _47.xyzz;
    _343.x = dot(_23_m6, _337);
    _343.y = dot(_23_m7, _337);
    _343.z = dot(_23_m8, _337);
    _320 = (_23_m9.xyz * _320.xxx) + _343;
    vs_TEXCOORD3 = _9.xyz + _320;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _162 = stage_input._162;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _133;
static float3 _162;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _162 : NORMAL;
    float4 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _210;
static float4 _223;
static float3 _320;
static float4 _337;
static float3 _343;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    vs_TEXCOORD4 = (_102 * _23_m13.z) + _23_m13.w;
    float2 _145 = (_133.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_145.x, _145.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _158 = (_133.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _158.x, _158.y);
    _47.x = dot(_162, _23_m11[0].xyz);
    _47.y = dot(_162, _23_m11[1].xyz);
    _47.z = dot(_162, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _194 = _102.xxx * _47.xyz;
    _47 = float4(_194.x, _194.y, _194.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _210 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _223 = _47.yyyy * _210;
    _210 *= _210;
    _210 = (_65 * _65) + _210;
    _65 = (_65 * _47.xxxx) + _223;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _210;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _210 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _210;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _283 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_283.x, _283.y, _283.z, _65.w);
    float3 _294 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_294.x, _294.y, _294.z, _65.w);
    float3 _305 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_305.x, _305.y, _305.z, _9.w);
    float3 _316 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_316.x, _316.y, _316.z, _9.w);
    _320.x = _47.y * _47.y;
    _320.x = (_47.x * _47.x) + (-_320.x);
    _337 = _47.yzzx * _47.xyzz;
    _343.x = dot(_23_m6, _337);
    _343.y = dot(_23_m7, _337);
    _343.z = dot(_23_m8, _337);
    _320 = (_23_m9.xyz * _320.xxx) + _343;
    vs_TEXCOORD3 = _9.xyz + _320;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _162 = stage_input._162;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m9[4];
float4x4 unity_WorldToObject;
static float4 _23_m10[4];
float4x4 unity_MatrixVP;
static float4 _23_m11[4];
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 unity_4LightPosX0
#define _23_m1 unity_4LightPosY0
#define _23_m2 unity_4LightPosZ0
#define _23_m3 unity_4LightAtten0
#define _23_m4 unity_LightColor
#define _23_m5 unity_SHBr
#define _23_m6 unity_SHBg
#define _23_m7 unity_SHBb
#define _23_m8 unity_SHC
#define _23_m12 _MainTex_ST
#define _23_m13 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float4 _101;
static float3 _130;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _130 : NORMAL;
    float4 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _153;
static float4 _181;
static float4 _194;
static float3 _292;
static float4 _309;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m9[1];
    _9 = (_23_m9[0] * _11.xxxx) + _9;
    _9 = (_23_m9[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m9[3];
    float3 _62 = (_23_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m11[1];
    _65 = (_23_m11[0] * _47.xxxx) + _65;
    _65 = (_23_m11[2] * _47.zzzz) + _65;
    gl_Position = (_23_m11[3] * _47.wwww) + _65;
    float2 _113 = (_101.xy * _23_m12.xy) + _23_m12.zw;
    vs_TEXCOORD0 = float4(_113.x, _113.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _126 = (_101.xy * _23_m13.xy) + _23_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _126.x, _126.y);
    _47.x = dot(_130, _23_m10[0].xyz);
    _47.y = dot(_130, _23_m10[1].xyz);
    _47.z = dot(_130, _23_m10[2].xyz);
    _153 = dot(_47.xyz, _47.xyz);
    _153 = rsqrt(_153);
    float3 _165 = _153.xxx * _47.xyz;
    _47 = float4(_165.x, _165.y, _165.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m0;
    _181 = (-_9.yyyy) + _23_m1;
    _9 = (-_9.zzzz) + _23_m2;
    _194 = _47.yyyy * _181;
    _181 *= _181;
    _181 = (_65 * _65) + _181;
    _65 = (_65 * _47.xxxx) + _194;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _181;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _181 = rsqrt(_9);
    _9 = (_9 * _23_m3) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _181;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _255 = _9.yyy * _23_m4[1].xyz;
    _65 = float4(_255.x, _255.y, _255.z, _65.w);
    float3 _266 = (_23_m4[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_266.x, _266.y, _266.z, _65.w);
    float3 _277 = (_23_m4[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_277.x, _277.y, _277.z, _9.w);
    float3 _288 = (_23_m4[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_288.x, _288.y, _288.z, _9.w);
    _292.x = _47.y * _47.y;
    _292.x = (_47.x * _47.x) + (-_292.x);
    _309 = _47.yzzx * _47.xyzz;
    _315.x = dot(_23_m5, _309);
    _315.y = dot(_23_m6, _309);
    _315.z = dot(_23_m7, _309);
    _292 = (_23_m8.xyz * _292.xxx) + _315;
    vs_TEXCOORD3 = _9.xyz + _292;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _130 = stage_input._130;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_SpecCube0_HDR
#define _22_m10 _LightColor0
#define _22_m11 _Color
#define _22_m12 _EmissionColor
#define _22_m13 _ProtoColor
#define _22_m14 _ParallaxDepth
#define _22_m15 _ProtoEmission
#define _22_m16 _Fade
#define _22_m17 _FadeEmission
#define _22_m18 _Glossiness
#define _22_m19 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float4 _693;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _693 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m10.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m18) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m14;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m13.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m11.xyz) + (-_78);
    _401 = _384 * _22_m11.xyz;
    _391 = (float3(float3(_22_m16, _22_m16, _22_m16)) * _391) + _78;
    _78 *= float3(float3(_22_m15, _22_m15, _22_m15));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m19, _22_m19, _22_m19)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m19) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m18;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m9.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m9.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m9.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m12.xyz) + (-_78);
    _9 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _129) + _78;
    float3 _696 = _9 + _117;
    _693 = float4(_696.x, _696.y, _696.z, _693.w);
    _693.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._693 = _693;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _139;
static float3 _168;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _168 : NORMAL;
    float4 _139 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _188;
static float _206;
static float4 _220;
static float3 _227;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m8.y;
    vs_TEXCOORD4 = exp2(-_9.x);
    float2 _151 = (_139.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_151.x, _151.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _164 = (_139.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _164.x, _164.y);
    _9.x = dot(_168, _21_m6[0].xyz);
    _9.y = dot(_168, _21_m6[1].xyz);
    _9.z = dot(_168, _21_m6[2].xyz);
    _188 = dot(_9.xyz, _9.xyz);
    _188 = rsqrt(_188);
    float3 _200 = _188.xxx * _9.xyz;
    _9 = float4(_200.x, _200.y, _200.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _206 = _9.y * _9.y;
    _206 = (_9.x * _9.x) + (-_206);
    _220 = _9.yzzx * _9.xyzz;
    _227.x = dot(_21_m1, _220);
    _227.y = dot(_21_m2, _220);
    _227.z = dot(_21_m3, _220);
    vs_TEXCOORD3 = (_21_m4.xyz * _206.xxx) + _227;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _168 = stage_input._168;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _139;
static float3 _168;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _168 : NORMAL;
    float4 _139 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _188;
static float _206;
static float4 _220;
static float3 _227;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m8.y;
    vs_TEXCOORD4 = exp2(-_9.x);
    float2 _151 = (_139.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_151.x, _151.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _164 = (_139.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _164.x, _164.y);
    _9.x = dot(_168, _21_m6[0].xyz);
    _9.y = dot(_168, _21_m6[1].xyz);
    _9.z = dot(_168, _21_m6[2].xyz);
    _188 = dot(_9.xyz, _9.xyz);
    _188 = rsqrt(_188);
    float3 _200 = _188.xxx * _9.xyz;
    _9 = float4(_200.x, _200.y, _200.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _206 = _9.y * _9.y;
    _206 = (_9.x * _9.x) + (-_206);
    _220 = _9.yzzx * _9.xyzz;
    _227.x = dot(_21_m1, _220);
    _227.y = dot(_21_m2, _220);
    _227.z = dot(_21_m3, _220);
    vs_TEXCOORD3 = (_21_m4.xyz * _206.xxx) + _227;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _168 = stage_input._168;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _132;
static float3 _161;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _161 : NORMAL;
    float4 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _209;
static float4 _222;
static float3 _319;
static float4 _336;
static float3 _342;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m13.y;
    vs_TEXCOORD4 = exp2(-_102);
    float2 _144 = (_132.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_144.x, _144.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _157 = (_132.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _157.x, _157.y);
    _47.x = dot(_161, _23_m11[0].xyz);
    _47.y = dot(_161, _23_m11[1].xyz);
    _47.z = dot(_161, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _193 = _102.xxx * _47.xyz;
    _47 = float4(_193.x, _193.y, _193.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _209 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _222 = _47.yyyy * _209;
    _209 *= _209;
    _209 = (_65 * _65) + _209;
    _65 = (_65 * _47.xxxx) + _222;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _209;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _209 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _209;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _282 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_282.x, _282.y, _282.z, _65.w);
    float3 _293 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_293.x, _293.y, _293.z, _65.w);
    float3 _304 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_304.x, _304.y, _304.z, _9.w);
    float3 _315 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_315.x, _315.y, _315.z, _9.w);
    _319.x = _47.y * _47.y;
    _319.x = (_47.x * _47.x) + (-_319.x);
    _336 = _47.yzzx * _47.xyzz;
    _342.x = dot(_23_m6, _336);
    _342.y = dot(_23_m7, _336);
    _342.z = dot(_23_m8, _336);
    _319 = (_23_m9.xyz * _319.xxx) + _342;
    vs_TEXCOORD3 = _9.xyz + _319;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _161 = stage_input._161;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _145;
static float3 _174;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _174 : NORMAL;
    float4 _145 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _194;
static float _212;
static float4 _226;
static float3 _233;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m8.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD4 = exp2(_9.x);
    float2 _157 = (_145.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_157.x, _157.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _170 = (_145.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _170.x, _170.y);
    _9.x = dot(_174, _21_m6[0].xyz);
    _9.y = dot(_174, _21_m6[1].xyz);
    _9.z = dot(_174, _21_m6[2].xyz);
    _194 = dot(_9.xyz, _9.xyz);
    _194 = rsqrt(_194);
    float3 _206 = _194.xxx * _9.xyz;
    _9 = float4(_206.x, _206.y, _206.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _212 = _9.y * _9.y;
    _212 = (_9.x * _9.x) + (-_212);
    _226 = _9.yzzx * _9.xyzz;
    _233.x = dot(_21_m1, _226);
    _233.y = dot(_21_m2, _226);
    _233.z = dot(_21_m3, _226);
    vs_TEXCOORD3 = (_21_m4.xyz * _212.xxx) + _233;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    _174 = stage_input._174;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _145;
static float3 _174;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _174 : NORMAL;
    float4 _145 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _194;
static float _212;
static float4 _226;
static float3 _233;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m8.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD4 = exp2(_9.x);
    float2 _157 = (_145.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_157.x, _157.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _170 = (_145.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _170.x, _170.y);
    _9.x = dot(_174, _21_m6[0].xyz);
    _9.y = dot(_174, _21_m6[1].xyz);
    _9.z = dot(_174, _21_m6[2].xyz);
    _194 = dot(_9.xyz, _9.xyz);
    _194 = rsqrt(_194);
    float3 _206 = _194.xxx * _9.xyz;
    _9 = float4(_206.x, _206.y, _206.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _212 = _9.y * _9.y;
    _212 = (_9.x * _9.x) + (-_212);
    _226 = _9.yzzx * _9.xyzz;
    _233.x = dot(_21_m1, _226);
    _233.y = dot(_21_m2, _226);
    _233.z = dot(_21_m3, _226);
    vs_TEXCOORD3 = (_21_m4.xyz * _212.xxx) + _233;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    _174 = stage_input._174;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _136;
static float3 _165;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _165 : NORMAL;
    float4 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _212;
static float4 _225;
static float3 _322;
static float4 _339;
static float3 _345;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    _102 *= _23_m13.x;
    _102 *= (-_102);
    vs_TEXCOORD4 = exp2(_102);
    float2 _148 = (_136.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_148.x, _148.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _161 = (_136.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _161.x, _161.y);
    _47.x = dot(_165, _23_m11[0].xyz);
    _47.y = dot(_165, _23_m11[1].xyz);
    _47.z = dot(_165, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _196 = _102.xxx * _47.xyz;
    _47 = float4(_196.x, _196.y, _196.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _212 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _225 = _47.yyyy * _212;
    _212 *= _212;
    _212 = (_65 * _65) + _212;
    _65 = (_65 * _47.xxxx) + _225;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _212;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _212 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _212;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _285 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_285.x, _285.y, _285.z, _65.w);
    float3 _296 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_296.x, _296.y, _296.z, _65.w);
    float3 _307 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_307.x, _307.y, _307.z, _9.w);
    float3 _318 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_318.x, _318.y, _318.z, _9.w);
    _322.x = _47.y * _47.y;
    _322.x = (_47.x * _47.x) + (-_322.x);
    _339 = _47.yzzx * _47.xyzz;
    _345.x = dot(_23_m6, _339);
    _345.y = dot(_23_m7, _339);
    _345.z = dot(_23_m8, _339);
    _322 = (_23_m9.xyz * _322.xxx) + _345;
    vs_TEXCOORD3 = _9.xyz + _322;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _165 = stage_input._165;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _138;
static float3 _167;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _167 : NORMAL;
    float4 _138 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _187;
static float _205;
static float4 _219;
static float3 _226;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD4 = (_9.x * _21_m8.z) + _21_m8.w;
    float2 _150 = (_138.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_150.x, _150.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _163 = (_138.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _163.x, _163.y);
    _9.x = dot(_167, _21_m6[0].xyz);
    _9.y = dot(_167, _21_m6[1].xyz);
    _9.z = dot(_167, _21_m6[2].xyz);
    _187 = dot(_9.xyz, _9.xyz);
    _187 = rsqrt(_187);
    float3 _199 = _187.xxx * _9.xyz;
    _9 = float4(_199.x, _199.y, _199.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _205 = _9.y * _9.y;
    _205 = (_9.x * _9.x) + (-_205);
    _219 = _9.yzzx * _9.xyzz;
    _226.x = dot(_21_m1, _219);
    _226.y = dot(_21_m2, _219);
    _226.z = dot(_21_m3, _219);
    vs_TEXCOORD3 = (_21_m4.xyz * _205.xxx) + _226;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _167 = stage_input._167;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _138;
static float3 _167;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _167 : NORMAL;
    float4 _138 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _187;
static float _205;
static float4 _219;
static float3 _226;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD4 = (_9.x * _21_m8.z) + _21_m8.w;
    float2 _150 = (_138.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_150.x, _150.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _163 = (_138.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _163.x, _163.y);
    _9.x = dot(_167, _21_m6[0].xyz);
    _9.y = dot(_167, _21_m6[1].xyz);
    _9.z = dot(_167, _21_m6[2].xyz);
    _187 = dot(_9.xyz, _9.xyz);
    _187 = rsqrt(_187);
    float3 _199 = _187.xxx * _9.xyz;
    _9 = float4(_199.x, _199.y, _199.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _205 = _9.y * _9.y;
    _205 = (_9.x * _9.x) + (-_205);
    _219 = _9.yzzx * _9.xyzz;
    _226.x = dot(_21_m1, _219);
    _226.y = dot(_21_m2, _219);
    _226.z = dot(_21_m3, _219);
    vs_TEXCOORD3 = (_21_m4.xyz * _205.xxx) + _226;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _167 = stage_input._167;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_FogColor
#define _22_m10 unity_SpecCube0_HDR
#define _22_m11 _LightColor0
#define _22_m12 _Color
#define _22_m13 _EmissionColor
#define _22_m14 _ProtoColor
#define _22_m15 _ParallaxDepth
#define _22_m16 _ProtoEmission
#define _22_m17 _Fade
#define _22_m18 _FadeEmission
#define _22_m19 _Glossiness
#define _22_m20 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _716;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _716 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m11.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m19) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m15;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m14.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m12.xyz) + (-_78);
    _401 = _384 * _22_m12.xyz;
    _391 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _391) + _78;
    _78 *= float3(float3(_22_m16, _22_m16, _22_m16));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m20, _22_m20, _22_m20)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m20) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m19;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m10.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m10.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m10.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m13.xyz) + (-_78);
    _9 = (float3(float3(_22_m18, _22_m18, _22_m18)) * _129) + _78;
    _96 = _9 + _117;
    _9 = _96 + (-_22_m9.xyz);
    _221 = vs_TEXCOORD4;
    _221 = clamp(_221, 0.0f, 1.0f);
    _9 = (_221.xxx * _9) + _22_m9.xyz;
    _716 = float4(_9.x, _9.y, _9.z, _716.w);
    _716.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._716 = _716;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m10[4];
float4x4 unity_WorldToObject;
static float4 _23_m11[4];
float4x4 unity_MatrixVP;
static float4 _23_m12[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m10[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m10[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m10[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m10[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m11[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m11[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m11[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m11[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m12[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m12[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m12[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m12[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _ProjectionParams
#define _23_m1 unity_4LightPosX0
#define _23_m2 unity_4LightPosY0
#define _23_m3 unity_4LightPosZ0
#define _23_m4 unity_4LightAtten0
#define _23_m5 unity_LightColor
#define _23_m6 unity_SHBr
#define _23_m7 unity_SHBg
#define _23_m8 unity_SHBb
#define _23_m9 unity_SHC
#define _23_m13 unity_FogParams
#define _23_m14 _MainTex_ST
#define _23_m15 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _133;
static float3 _162;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _162 : NORMAL;
    float4 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _102;
static float4 _210;
static float4 _223;
static float3 _320;
static float4 _337;
static float3 _343;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m10[1];
    _9 = (_23_m10[0] * _11.xxxx) + _9;
    _9 = (_23_m10[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m10[3];
    float3 _62 = (_23_m10[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m12[1];
    _65 = (_23_m12[0] * _47.xxxx) + _65;
    _65 = (_23_m12[2] * _47.zzzz) + _65;
    _47 = (_23_m12[3] * _47.wwww) + _65;
    gl_Position = _47;
    _102 = _47.z / _23_m0.y;
    _102 = (-_102) + 1.0f;
    _102 *= _23_m0.z;
    _102 = max(_102, 0.0f);
    vs_TEXCOORD4 = (_102 * _23_m13.z) + _23_m13.w;
    float2 _145 = (_133.xy * _23_m14.xy) + _23_m14.zw;
    vs_TEXCOORD0 = float4(_145.x, _145.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _158 = (_133.xy * _23_m15.xy) + _23_m15.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _158.x, _158.y);
    _47.x = dot(_162, _23_m11[0].xyz);
    _47.y = dot(_162, _23_m11[1].xyz);
    _47.z = dot(_162, _23_m11[2].xyz);
    _102 = dot(_47.xyz, _47.xyz);
    _102 = rsqrt(_102);
    float3 _194 = _102.xxx * _47.xyz;
    _47 = float4(_194.x, _194.y, _194.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m1;
    _210 = (-_9.yyyy) + _23_m2;
    _9 = (-_9.zzzz) + _23_m3;
    _223 = _47.yyyy * _210;
    _210 *= _210;
    _210 = (_65 * _65) + _210;
    _65 = (_65 * _47.xxxx) + _223;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _210;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _210 = rsqrt(_9);
    _9 = (_9 * _23_m4) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _210;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _283 = _9.yyy * _23_m5[1].xyz;
    _65 = float4(_283.x, _283.y, _283.z, _65.w);
    float3 _294 = (_23_m5[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_294.x, _294.y, _294.z, _65.w);
    float3 _305 = (_23_m5[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_305.x, _305.y, _305.z, _9.w);
    float3 _316 = (_23_m5[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_316.x, _316.y, _316.z, _9.w);
    _320.x = _47.y * _47.y;
    _320.x = (_47.x * _47.x) + (-_320.x);
    _337 = _47.yzzx * _47.xyzz;
    _343.x = dot(_23_m6, _337);
    _343.y = dot(_23_m7, _337);
    _343.z = dot(_23_m8, _337);
    _320 = (_23_m9.xyz * _320.xxx) + _343;
    vs_TEXCOORD3 = _9.xyz + _320;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _162 = stage_input._162;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m4[4];
float4x4 unity_WorldToObject;
static float4 _21_m5[4];
float4x4 unity_MatrixVP;
static float4 _21_m6[4];
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m4[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m4[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m4[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m4[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m5[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m5[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m5[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m5[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m6[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m6[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m6[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m6[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHBr
#define _21_m1 unity_SHBg
#define _21_m2 unity_SHBb
#define _21_m3 unity_SHC
#define _21_m7 _MainTex_ST
#define _21_m8 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 _98;
static float3 _127;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _127 : NORMAL;
    float4 _98 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _150;
static float _168;
static float4 _182;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _11.xxxx) + _9;
    _9 = (_21_m4[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m4[3];
    vs_TEXCOORD2 = (_21_m4[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m6[1];
    _9 = (_21_m6[0] * _45.xxxx) + _9;
    _9 = (_21_m6[2] * _45.zzzz) + _9;
    gl_Position = (_21_m6[3] * _45.wwww) + _9;
    float2 _110 = (_98.xy * _21_m7.xy) + _21_m7.zw;
    vs_TEXCOORD0 = float4(_110.x, _110.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _123 = (_98.xy * _21_m8.xy) + _21_m8.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _123.x, _123.y);
    _9.x = dot(_127, _21_m5[0].xyz);
    _9.y = dot(_127, _21_m5[1].xyz);
    _9.z = dot(_127, _21_m5[2].xyz);
    _150 = dot(_9.xyz, _9.xyz);
    _150 = rsqrt(_150);
    float3 _162 = _150.xxx * _9.xyz;
    _9 = float4(_162.x, _162.y, _162.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _168 = _9.y * _9.y;
    _168 = (_9.x * _9.x) + (-_168);
    _182 = _9.yzzx * _9.xyzz;
    _189.x = dot(_21_m0, _182);
    _189.y = dot(_21_m1, _182);
    _189.z = dot(_21_m2, _182);
    vs_TEXCOORD3 = (_21_m3.xyz * _168.xxx) + _189;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _98 = stage_input._98;
    _127 = stage_input._127;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_SpecCube0_HDR
#define _22_m10 _LightColor0
#define _22_m11 _Color
#define _22_m12 _EmissionColor
#define _22_m13 _ProtoColor
#define _22_m14 _ParallaxDepth
#define _22_m15 _ProtoEmission
#define _22_m16 _Fade
#define _22_m17 _FadeEmission
#define _22_m18 _Glossiness
#define _22_m19 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float4 _693;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _693 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m10.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m18) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m14;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m13.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m11.xyz) + (-_78);
    _401 = _384 * _22_m11.xyz;
    _391 = (float3(float3(_22_m16, _22_m16, _22_m16)) * _391) + _78;
    _78 *= float3(float3(_22_m15, _22_m15, _22_m15));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m19, _22_m19, _22_m19)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m19) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m18;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m9.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m9.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m9.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m12.xyz) + (-_78);
    _9 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _129) + _78;
    float3 _696 = _9 + _117;
    _693 = float4(_696.x, _696.y, _696.z, _693.w);
    _693.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._693 = _693;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m9[4];
float4x4 unity_WorldToObject;
static float4 _23_m10[4];
float4x4 unity_MatrixVP;
static float4 _23_m11[4];
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 unity_4LightPosX0
#define _23_m1 unity_4LightPosY0
#define _23_m2 unity_4LightPosZ0
#define _23_m3 unity_4LightAtten0
#define _23_m4 unity_LightColor
#define _23_m5 unity_SHBr
#define _23_m6 unity_SHBg
#define _23_m7 unity_SHBb
#define _23_m8 unity_SHC
#define _23_m12 _MainTex_ST
#define _23_m13 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float4 _101;
static float3 _130;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _130 : NORMAL;
    float4 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _153;
static float4 _181;
static float4 _194;
static float3 _292;
static float4 _309;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m9[1];
    _9 = (_23_m9[0] * _11.xxxx) + _9;
    _9 = (_23_m9[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m9[3];
    float3 _62 = (_23_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m11[1];
    _65 = (_23_m11[0] * _47.xxxx) + _65;
    _65 = (_23_m11[2] * _47.zzzz) + _65;
    gl_Position = (_23_m11[3] * _47.wwww) + _65;
    float2 _113 = (_101.xy * _23_m12.xy) + _23_m12.zw;
    vs_TEXCOORD0 = float4(_113.x, _113.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _126 = (_101.xy * _23_m13.xy) + _23_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _126.x, _126.y);
    _47.x = dot(_130, _23_m10[0].xyz);
    _47.y = dot(_130, _23_m10[1].xyz);
    _47.z = dot(_130, _23_m10[2].xyz);
    _153 = dot(_47.xyz, _47.xyz);
    _153 = rsqrt(_153);
    float3 _165 = _153.xxx * _47.xyz;
    _47 = float4(_165.x, _165.y, _165.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m0;
    _181 = (-_9.yyyy) + _23_m1;
    _9 = (-_9.zzzz) + _23_m2;
    _194 = _47.yyyy * _181;
    _181 *= _181;
    _181 = (_65 * _65) + _181;
    _65 = (_65 * _47.xxxx) + _194;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _181;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _181 = rsqrt(_9);
    _9 = (_9 * _23_m3) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _181;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _255 = _9.yyy * _23_m4[1].xyz;
    _65 = float4(_255.x, _255.y, _255.z, _65.w);
    float3 _266 = (_23_m4[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_266.x, _266.y, _266.z, _65.w);
    float3 _277 = (_23_m4[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_277.x, _277.y, _277.z, _9.w);
    float3 _288 = (_23_m4[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_288.x, _288.y, _288.z, _9.w);
    _292.x = _47.y * _47.y;
    _292.x = (_47.x * _47.x) + (-_292.x);
    _309 = _47.yzzx * _47.xyzz;
    _315.x = dot(_23_m5, _309);
    _315.y = dot(_23_m6, _309);
    _315.z = dot(_23_m7, _309);
    _292 = (_23_m8.xyz * _292.xxx) + _315;
    vs_TEXCOORD3 = _9.xyz + _292;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _130 = stage_input._130;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_SpecCube0_HDR
#define _17_m6 _LightColor0
#define _17_m7 _Color
#define _17_m8 _EmissionColor
#define _17_m9 _ProtoColor
#define _17_m10 _ParallaxDepth
#define _17_m11 _ProtoEmission
#define _17_m12 _Fade
#define _17_m13 _FadeEmission
#define _17_m14 _Glossiness
#define _17_m15 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float4 _540;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _540 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float _154;
static float3 _202;
static float3 _218;
static float3 _225;
static float3 _235;
static float3 _271;
static float3 _293;
static float3 _301;
static float3 _321;
static float4 _340;
static float3 _346;
static float _391;
static float4 _459;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m14) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154 = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m10;
    float2 _199 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_199.x, _199.y, _31.z);
    _202 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _202 * _17_m9.xyz;
    _218 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _225 = (_218 * _17_m7.xyz) + (-_31);
    _235 = _218 * _17_m7.xyz;
    _225 = (float3(float3(_17_m12, _17_m12, _17_m12)) * _225) + _31;
    _31 *= float3(float3(_17_m11, _17_m11, _17_m11));
    _271 = _225 + (-0.039999999105930328369140625f).xxx;
    _271 = (float3(float3(_17_m15, _17_m15, _17_m15)) * _271) + 0.039999999105930328369140625f.xxx;
    _293.x = ((-_17_m15) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _301 = _225 * _293.xxx;
    _293.x = (-_293.x) + 1.0f;
    _293.x += _17_m14;
    _293.x = clamp(_293.x, 0.0f, 1.0f);
    _321 = (-_271) + _293.xxx;
    _225 = (_25.xxx * _271) + _301;
    _225 *= _17_m6.xyz;
    _340 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _340.w);
    _340.w = 1.0f;
    _346.x = dot(_17_m2, _340);
    _346.y = dot(_17_m3, _340);
    _346.z = dot(_17_m4, _340);
    _346 += vs_TEXCOORD3;
    _346 = max(_346, 0.0f.xxx);
    _293 = _301 * _346;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _391 = (-_80.x) + 1.0f;
    _391 *= _391;
    _391 *= _391;
    _271 = (_391.xxx * _321) + _271;
    _80 = (_225 * _25.xxx) + _293;
    _293.x = dot(-_9, vs_TEXCOORD1);
    _293.x += _293.x;
    _293 = (vs_TEXCOORD1 * (-_293.xxx)) + (-_9);
    float2 _443 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _321 = float3(_443.x, _443.y, _321.z);
    _391 = _73 * _321.x;
    _154 = ((-_154) * _321.y) + 1.0f;
    _391 *= 6.0f;
    _459 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _293, _391);
    _293.x = _459.w + (-1.0f);
    _293.x = (_17_m5.w * _293.x) + 1.0f;
    _293.x = log2(_293.x);
    _293.x *= _17_m5.y;
    _293.x = exp2(_293.x);
    _293.x *= _17_m5.x;
    _293 = _459.xyz * _293.xxx;
    _293 = _154.xxx * _293;
    _9 = (_293 * _271) + _80;
    _80 = (_235 * _17_m8.xyz) + (-_31);
    _31 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _80) + _31;
    float3 _543 = _9 + _31;
    _540 = float4(_543.x, _543.y, _543.z, _540.w);
    _540.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._540 = _540;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m9[4];
float4x4 unity_WorldToObject;
static float4 _23_m10[4];
float4x4 unity_MatrixVP;
static float4 _23_m11[4];
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 unity_4LightPosX0
#define _23_m1 unity_4LightPosY0
#define _23_m2 unity_4LightPosZ0
#define _23_m3 unity_4LightAtten0
#define _23_m4 unity_LightColor
#define _23_m5 unity_SHBr
#define _23_m6 unity_SHBg
#define _23_m7 unity_SHBb
#define _23_m8 unity_SHC
#define _23_m12 _MainTex_ST
#define _23_m13 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float4 _101;
static float3 _130;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _130 : NORMAL;
    float4 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _153;
static float4 _181;
static float4 _194;
static float3 _292;
static float4 _309;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m9[1];
    _9 = (_23_m9[0] * _11.xxxx) + _9;
    _9 = (_23_m9[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m9[3];
    float3 _62 = (_23_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m11[1];
    _65 = (_23_m11[0] * _47.xxxx) + _65;
    _65 = (_23_m11[2] * _47.zzzz) + _65;
    gl_Position = (_23_m11[3] * _47.wwww) + _65;
    float2 _113 = (_101.xy * _23_m12.xy) + _23_m12.zw;
    vs_TEXCOORD0 = float4(_113.x, _113.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _126 = (_101.xy * _23_m13.xy) + _23_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _126.x, _126.y);
    _47.x = dot(_130, _23_m10[0].xyz);
    _47.y = dot(_130, _23_m10[1].xyz);
    _47.z = dot(_130, _23_m10[2].xyz);
    _153 = dot(_47.xyz, _47.xyz);
    _153 = rsqrt(_153);
    float3 _165 = _153.xxx * _47.xyz;
    _47 = float4(_165.x, _165.y, _165.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m0;
    _181 = (-_9.yyyy) + _23_m1;
    _9 = (-_9.zzzz) + _23_m2;
    _194 = _47.yyyy * _181;
    _181 *= _181;
    _181 = (_65 * _65) + _181;
    _65 = (_65 * _47.xxxx) + _194;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _181;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _181 = rsqrt(_9);
    _9 = (_9 * _23_m3) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _181;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _255 = _9.yyy * _23_m4[1].xyz;
    _65 = float4(_255.x, _255.y, _255.z, _65.w);
    float3 _266 = (_23_m4[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_266.x, _266.y, _266.z, _65.w);
    float3 _277 = (_23_m4[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_277.x, _277.y, _277.z, _9.w);
    float3 _288 = (_23_m4[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_288.x, _288.y, _288.z, _9.w);
    _292.x = _47.y * _47.y;
    _292.x = (_47.x * _47.x) + (-_292.x);
    _309 = _47.yzzx * _47.xyzz;
    _315.x = dot(_23_m5, _309);
    _315.y = dot(_23_m6, _309);
    _315.z = dot(_23_m7, _309);
    _292 = (_23_m8.xyz * _292.xxx) + _315;
    vs_TEXCOORD3 = _9.xyz + _292;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _130 = stage_input._130;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_SpecCube0_HDR
#define _22_m10 _LightColor0
#define _22_m11 _Color
#define _22_m12 _EmissionColor
#define _22_m13 _ProtoColor
#define _22_m14 _ParallaxDepth
#define _22_m15 _ProtoEmission
#define _22_m16 _Fade
#define _22_m17 _FadeEmission
#define _22_m18 _Glossiness
#define _22_m19 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float4 _693;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _693 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m10.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m18) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m14;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m13.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m11.xyz) + (-_78);
    _401 = _384 * _22_m11.xyz;
    _391 = (float3(float3(_22_m16, _22_m16, _22_m16)) * _391) + _78;
    _78 *= float3(float3(_22_m15, _22_m15, _22_m15));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m19, _22_m19, _22_m19)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m19) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m18;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m9.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m9.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m9.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m12.xyz) + (-_78);
    _9 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _129) + _78;
    float3 _696 = _9 + _117;
    _693 = float4(_696.x, _696.y, _696.z, _693.w);
    _693.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._693 = _693;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _139;
static float3 _168;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _168 : NORMAL;
    float4 _139 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _188;
static float _206;
static float4 _220;
static float3 _227;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m8.y;
    vs_TEXCOORD4 = exp2(-_9.x);
    float2 _151 = (_139.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_151.x, _151.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _164 = (_139.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _164.x, _164.y);
    _9.x = dot(_168, _21_m6[0].xyz);
    _9.y = dot(_168, _21_m6[1].xyz);
    _9.z = dot(_168, _21_m6[2].xyz);
    _188 = dot(_9.xyz, _9.xyz);
    _188 = rsqrt(_188);
    float3 _200 = _188.xxx * _9.xyz;
    _9 = float4(_200.x, _200.y, _200.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _206 = _9.y * _9.y;
    _206 = (_9.x * _9.x) + (-_206);
    _220 = _9.yzzx * _9.xyzz;
    _227.x = dot(_21_m1, _220);
    _227.y = dot(_21_m2, _220);
    _227.z = dot(_21_m3, _220);
    vs_TEXCOORD3 = (_21_m4.xyz * _206.xxx) + _227;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _168 = stage_input._168;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _145;
static float3 _174;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _174 : NORMAL;
    float4 _145 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _194;
static float _212;
static float4 _226;
static float3 _233;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m8.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD4 = exp2(_9.x);
    float2 _157 = (_145.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_157.x, _157.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _170 = (_145.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _170.x, _170.y);
    _9.x = dot(_174, _21_m6[0].xyz);
    _9.y = dot(_174, _21_m6[1].xyz);
    _9.z = dot(_174, _21_m6[2].xyz);
    _194 = dot(_9.xyz, _9.xyz);
    _194 = rsqrt(_194);
    float3 _206 = _194.xxx * _9.xyz;
    _9 = float4(_206.x, _206.y, _206.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _212 = _9.y * _9.y;
    _212 = (_9.x * _9.x) + (-_212);
    _226 = _9.yzzx * _9.xyzz;
    _233.x = dot(_21_m1, _226);
    _233.y = dot(_21_m2, _226);
    _233.z = dot(_21_m3, _226);
    vs_TEXCOORD3 = (_21_m4.xyz * _212.xxx) + _233;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    _174 = stage_input._174;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_WorldToObject;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m6[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m6[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m6[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHBr
#define _21_m2 unity_SHBg
#define _21_m3 unity_SHBb
#define _21_m4 unity_SHC
#define _21_m8 unity_FogParams
#define _21_m9 _MainTex_ST
#define _21_m10 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float4 vs_TEXCOORD0;
static float4 _138;
static float3 _167;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _167 : NORMAL;
    float4 _138 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _187;
static float _205;
static float4 _219;
static float3 _226;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m5[1];
    _9 = (_21_m5[0] * _11.xxxx) + _9;
    _9 = (_21_m5[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m5[3];
    vs_TEXCOORD2 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _45.xxxx) + _9;
    _9 = (_21_m7[2] * _45.zzzz) + _9;
    _9 = (_21_m7[3] * _45.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD4 = (_9.x * _21_m8.z) + _21_m8.w;
    float2 _150 = (_138.xy * _21_m9.xy) + _21_m9.zw;
    vs_TEXCOORD0 = float4(_150.x, _150.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _163 = (_138.xy * _21_m10.xy) + _21_m10.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _163.x, _163.y);
    _9.x = dot(_167, _21_m6[0].xyz);
    _9.y = dot(_167, _21_m6[1].xyz);
    _9.z = dot(_167, _21_m6[2].xyz);
    _187 = dot(_9.xyz, _9.xyz);
    _187 = rsqrt(_187);
    float3 _199 = _187.xxx * _9.xyz;
    _9 = float4(_199.x, _199.y, _199.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _205 = _9.y * _9.y;
    _205 = (_9.x * _9.x) + (-_205);
    _219 = _9.yzzx * _9.xyzz;
    _226.x = dot(_21_m1, _219);
    _226.y = dot(_21_m2, _219);
    _226.z = dot(_21_m3, _219);
    vs_TEXCOORD3 = (_21_m4.xyz * _205.xxx) + _226;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
    _167 = stage_input._167;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_FogColor
#define _17_m6 unity_SpecCube0_HDR
#define _17_m7 _LightColor0
#define _17_m8 _Color
#define _17_m9 _EmissionColor
#define _17_m10 _ProtoColor
#define _17_m11 _ParallaxDepth
#define _17_m12 _ProtoEmission
#define _17_m13 _Fade
#define _17_m14 _FadeEmission
#define _17_m15 _Glossiness
#define _17_m16 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _566;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD4 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _566 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float3 _154;
static float3 _203;
static float3 _219;
static float3 _226;
static float3 _236;
static float3 _272;
static float3 _294;
static float3 _302;
static float3 _322;
static float4 _341;
static float3 _347;
static float _392;
static float4 _462;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m15) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154.x = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m11;
    float2 _200 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_200.x, _200.y, _31.z);
    _203 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _203 * _17_m10.xyz;
    _219 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _226 = (_219 * _17_m8.xyz) + (-_31);
    _236 = _219 * _17_m8.xyz;
    _226 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _226) + _31;
    _31 *= float3(float3(_17_m12, _17_m12, _17_m12));
    _272 = _226 + (-0.039999999105930328369140625f).xxx;
    _272 = (float3(float3(_17_m16, _17_m16, _17_m16)) * _272) + 0.039999999105930328369140625f.xxx;
    _294.x = ((-_17_m16) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _302 = _226 * _294.xxx;
    _294.x = (-_294.x) + 1.0f;
    _294.x += _17_m15;
    _294.x = clamp(_294.x, 0.0f, 1.0f);
    _322 = (-_272) + _294.xxx;
    _226 = (_25.xxx * _272) + _302;
    _226 *= _17_m7.xyz;
    _341 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _341.w);
    _341.w = 1.0f;
    _347.x = dot(_17_m2, _341);
    _347.y = dot(_17_m3, _341);
    _347.z = dot(_17_m4, _341);
    _347 += vs_TEXCOORD3;
    _347 = max(_347, 0.0f.xxx);
    _294 = _302 * _347;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _392 = (-_80.x) + 1.0f;
    _392 *= _392;
    _392 *= _392;
    _272 = (_392.xxx * _322) + _272;
    _80 = (_226 * _25.xxx) + _294;
    _294.x = dot(-_9, vs_TEXCOORD1);
    _294.x += _294.x;
    _294 = (vs_TEXCOORD1 * (-_294.xxx)) + (-_9);
    float2 _444 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _322 = float3(_444.x, _444.y, _322.z);
    _392 = _73 * _322.x;
    _154.x = ((-_154.x) * _322.y) + 1.0f;
    _392 *= 6.0f;
    _462 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _294, _392);
    _294.x = _462.w + (-1.0f);
    _294.x = (_17_m6.w * _294.x) + 1.0f;
    _294.x = log2(_294.x);
    _294.x *= _17_m6.y;
    _294.x = exp2(_294.x);
    _294.x *= _17_m6.x;
    _294 = _462.xyz * _294.xxx;
    _294 = _154.xxx * _294;
    _9 = (_294 * _272) + _80;
    _80 = (_236 * _17_m9.xyz) + (-_31);
    _31 = (float3(float3(_17_m14, _17_m14, _17_m14)) * _80) + _31;
    _154 = _9 + _31;
    _9 = _154 + (-_17_m5.xyz);
    _25 = vs_TEXCOORD4;
    _25 = clamp(_25, 0.0f, 1.0f);
    _9 = (_25.xxx * _9) + _17_m5.xyz;
    _566 = float4(_9.x, _9.y, _9.z, _566.w);
    _566.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._566 = _566;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m4[4];
float4x4 unity_WorldToObject;
static float4 _21_m5[4];
float4x4 unity_MatrixVP;
static float4 _21_m6[4];
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m4[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m4[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m4[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m4[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m5[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m5[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m5[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m5[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m6[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m6[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m6[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m6[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHBr
#define _21_m1 unity_SHBg
#define _21_m2 unity_SHBb
#define _21_m3 unity_SHC
#define _21_m7 _MainTex_ST
#define _21_m8 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 _98;
static float3 _127;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _127 : NORMAL;
    float4 _98 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _150;
static float _168;
static float4 _182;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _11.xxxx) + _9;
    _9 = (_21_m4[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m4[3];
    vs_TEXCOORD2 = (_21_m4[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m6[1];
    _9 = (_21_m6[0] * _45.xxxx) + _9;
    _9 = (_21_m6[2] * _45.zzzz) + _9;
    gl_Position = (_21_m6[3] * _45.wwww) + _9;
    float2 _110 = (_98.xy * _21_m7.xy) + _21_m7.zw;
    vs_TEXCOORD0 = float4(_110.x, _110.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _123 = (_98.xy * _21_m8.xy) + _21_m8.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _123.x, _123.y);
    _9.x = dot(_127, _21_m5[0].xyz);
    _9.y = dot(_127, _21_m5[1].xyz);
    _9.z = dot(_127, _21_m5[2].xyz);
    _150 = dot(_9.xyz, _9.xyz);
    _150 = rsqrt(_150);
    float3 _162 = _150.xxx * _9.xyz;
    _9 = float4(_162.x, _162.y, _162.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _168 = _9.y * _9.y;
    _168 = (_9.x * _9.x) + (-_168);
    _182 = _9.yzzx * _9.xyzz;
    _189.x = dot(_21_m0, _182);
    _189.y = dot(_21_m1, _182);
    _189.z = dot(_21_m2, _182);
    vs_TEXCOORD3 = (_21_m3.xyz * _168.xxx) + _189;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _98 = stage_input._98;
    _127 = stage_input._127;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_SpecCube0_HDR
#define _17_m6 _LightColor0
#define _17_m7 _Color
#define _17_m8 _EmissionColor
#define _17_m9 _ProtoColor
#define _17_m10 _ParallaxDepth
#define _17_m11 _ProtoEmission
#define _17_m12 _Fade
#define _17_m13 _FadeEmission
#define _17_m14 _Glossiness
#define _17_m15 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float4 _540;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _540 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float _154;
static float3 _202;
static float3 _218;
static float3 _225;
static float3 _235;
static float3 _271;
static float3 _293;
static float3 _301;
static float3 _321;
static float4 _340;
static float3 _346;
static float _391;
static float4 _459;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m14) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154 = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m10;
    float2 _199 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_199.x, _199.y, _31.z);
    _202 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _202 * _17_m9.xyz;
    _218 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _225 = (_218 * _17_m7.xyz) + (-_31);
    _235 = _218 * _17_m7.xyz;
    _225 = (float3(float3(_17_m12, _17_m12, _17_m12)) * _225) + _31;
    _31 *= float3(float3(_17_m11, _17_m11, _17_m11));
    _271 = _225 + (-0.039999999105930328369140625f).xxx;
    _271 = (float3(float3(_17_m15, _17_m15, _17_m15)) * _271) + 0.039999999105930328369140625f.xxx;
    _293.x = ((-_17_m15) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _301 = _225 * _293.xxx;
    _293.x = (-_293.x) + 1.0f;
    _293.x += _17_m14;
    _293.x = clamp(_293.x, 0.0f, 1.0f);
    _321 = (-_271) + _293.xxx;
    _225 = (_25.xxx * _271) + _301;
    _225 *= _17_m6.xyz;
    _340 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _340.w);
    _340.w = 1.0f;
    _346.x = dot(_17_m2, _340);
    _346.y = dot(_17_m3, _340);
    _346.z = dot(_17_m4, _340);
    _346 += vs_TEXCOORD3;
    _346 = max(_346, 0.0f.xxx);
    _293 = _301 * _346;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _391 = (-_80.x) + 1.0f;
    _391 *= _391;
    _391 *= _391;
    _271 = (_391.xxx * _321) + _271;
    _80 = (_225 * _25.xxx) + _293;
    _293.x = dot(-_9, vs_TEXCOORD1);
    _293.x += _293.x;
    _293 = (vs_TEXCOORD1 * (-_293.xxx)) + (-_9);
    float2 _443 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _321 = float3(_443.x, _443.y, _321.z);
    _391 = _73 * _321.x;
    _154 = ((-_154) * _321.y) + 1.0f;
    _391 *= 6.0f;
    _459 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _293, _391);
    _293.x = _459.w + (-1.0f);
    _293.x = (_17_m5.w * _293.x) + 1.0f;
    _293.x = log2(_293.x);
    _293.x *= _17_m5.y;
    _293.x = exp2(_293.x);
    _293.x *= _17_m5.x;
    _293 = _459.xyz * _293.xxx;
    _293 = _154.xxx * _293;
    _9 = (_293 * _271) + _80;
    _80 = (_235 * _17_m8.xyz) + (-_31);
    _31 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _80) + _31;
    float3 _543 = _9 + _31;
    _540 = float4(_543.x, _543.y, _543.z, _540.w);
    _540.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._540 = _540;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m4[4];
float4x4 unity_WorldToObject;
static float4 _21_m5[4];
float4x4 unity_MatrixVP;
static float4 _21_m6[4];
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m4[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m4[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m4[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m4[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m5[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m5[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m5[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m5[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m6[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m6[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m6[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m6[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHBr
#define _21_m1 unity_SHBg
#define _21_m2 unity_SHBb
#define _21_m3 unity_SHC
#define _21_m7 _MainTex_ST
#define _21_m8 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 _98;
static float3 _127;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _127 : NORMAL;
    float4 _98 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _150;
static float _168;
static float4 _182;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _11.xxxx) + _9;
    _9 = (_21_m4[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m4[3];
    vs_TEXCOORD2 = (_21_m4[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m6[1];
    _9 = (_21_m6[0] * _45.xxxx) + _9;
    _9 = (_21_m6[2] * _45.zzzz) + _9;
    gl_Position = (_21_m6[3] * _45.wwww) + _9;
    float2 _110 = (_98.xy * _21_m7.xy) + _21_m7.zw;
    vs_TEXCOORD0 = float4(_110.x, _110.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _123 = (_98.xy * _21_m8.xy) + _21_m8.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _123.x, _123.y);
    _9.x = dot(_127, _21_m5[0].xyz);
    _9.y = dot(_127, _21_m5[1].xyz);
    _9.z = dot(_127, _21_m5[2].xyz);
    _150 = dot(_9.xyz, _9.xyz);
    _150 = rsqrt(_150);
    float3 _162 = _150.xxx * _9.xyz;
    _9 = float4(_162.x, _162.y, _162.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _168 = _9.y * _9.y;
    _168 = (_9.x * _9.x) + (-_168);
    _182 = _9.yzzx * _9.xyzz;
    _189.x = dot(_21_m0, _182);
    _189.y = dot(_21_m1, _182);
    _189.z = dot(_21_m2, _182);
    vs_TEXCOORD3 = (_21_m3.xyz * _168.xxx) + _189;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _98 = stage_input._98;
    _127 = stage_input._127;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_WorldToShadow[4];
static float4 _22_m5[16];
float4 _LightShadowData;
float4 unity_ShadowFadeCenterAndType;
float4x4 unity_MatrixV;
static float4 _22_m8[4];
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
void __unity_init()
{
    _22_m5[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _22_m5[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _22_m5[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _22_m5[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _22_m5[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _22_m5[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _22_m5[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _22_m5[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _22_m5[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _22_m5[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _22_m5[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _22_m5[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _22_m5[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _22_m5[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _22_m5[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _22_m5[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _22_m8[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _22_m8[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _22_m8[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _22_m8[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _WorldSpaceLightPos0
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m6 _LightShadowData
#define _22_m7 unity_ShadowFadeCenterAndType
#define _22_m9 unity_SpecCube0_HDR
#define _22_m10 _LightColor0
#define _22_m11 _Color
#define _22_m12 _EmissionColor
#define _22_m13 _ProtoColor
#define _22_m14 _ParallaxDepth
#define _22_m15 _ProtoEmission
#define _22_m16 _Fade
#define _22_m17 _FadeEmission
#define _22_m18 _Glossiness
#define _22_m19 _Metallic


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __70_sampler;
Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float4 _693;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _693 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float3 _96;
static float3 _117;
static float3 _129;
static float _136;
static float _221;
static float _235;
static float _313;
static float3 _368;
static float3 _384;
static float3 _391;
static float3 _401;
static float3 _437;
static float _459;
static float3 _466;
static float3 _480;
static float4 _496;
static float4 _612;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _22_m5[1].xyz;
    _9 = (_22_m5[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_22_m5[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _22_m5[3].xyz;
    float3 _56 = float3(_9.xy, _9.z);
    _9.x = _ShadowMapTexture.SampleCmpLevelZero(__70_sampler, _56.xy, _56.z);
    _78.x = (-_22_m6.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _22_m6.x;
    _96.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD2 + (-_22_m7.xyz);
    _78.x = dot(_78, _78);
    _78.x = sqrt(_78.x);
    _117.x = _22_m8[0].z;
    _117.y = _22_m8[1].z;
    _117.z = _22_m8[2].z;
    _129 = (-vs_TEXCOORD2) + _22_m0;
    _136 = dot(_129, _117);
    _78.x = (-_136) + _78.x;
    _78.x = (_22_m7.w * _78.x) + _136;
    _78.x = (_78.x * _22_m6.z) + _22_m6.w;
    _78.x = clamp(_78.x, 0.0f, 1.0f);
    _96.x = (_78.x * _96.x) + _9.x;
    _96 = _96.xxx * _22_m10.xyz;
    _9.x = dot(_129, _129);
    _9.x = rsqrt(_9.x);
    _78 = (_129 * _9.xxx) + _22_m1.xyz;
    _117 = _9.xxx * _129;
    _9.x = dot(_78, _78);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _78;
    _221 = dot(_22_m1.xyz, _9);
    _221 = clamp(_221, 0.0f, 1.0f);
    _221 *= _221;
    _221 = max(_221, 0.100000001490116119384765625f);
    _235 = (-_22_m18) + 1.0f;
    _129.x = (_235 * _235) + 0.5f;
    _221 *= _129.x;
    _129.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _129.x = rsqrt(_129.x);
    _129 = _129.xxx * vs_TEXCOORD1;
    _9.x = dot(_129, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.y = _235 * _235;
    _136 = (_9.y * _9.y) + (-1.0f);
    _9.x = (_9.x * _136) + 1.000010013580322265625f;
    float2 _300 = _9.xy * _9.xy;
    _9 = float3(_300.x, _9.y, _300.y);
    _9.x *= _221;
    _9.x *= 4.0f;
    _313 = _235 * _9.y;
    _9.x = _9.z / _9.x;
    _9.x += (-9.9999997473787516355514526367188e-05f);
    _9.x = max(_9.x, 0.0f);
    _9.x = min(_9.x, 100.0f);
    _78.x = (-abs(_117.z)) + 1.0f;
    _78.x = max(_78.x, 0.0f);
    _78.x *= _22_m14;
    float2 _365 = ((-_117.xy) * _78.xx) + vs_TEXCOORD0.zw;
    _78 = float3(_365.x, _365.y, _78.z);
    _368 = _ProtoTex.Sample(sampler_ProtoTex, _78.xy).xyz;
    _78 = _368 * _22_m13.xyz;
    _384 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _391 = (_384 * _22_m11.xyz) + (-_78);
    _401 = _384 * _22_m11.xyz;
    _391 = (float3(float3(_22_m16, _22_m16, _22_m16)) * _391) + _78;
    _78 *= float3(float3(_22_m15, _22_m15, _22_m15));
    _437 = _391 + (-0.039999999105930328369140625f).xxx;
    _437 = (float3(float3(_22_m19, _22_m19, _22_m19)) * _437) + 0.039999999105930328369140625f.xxx;
    _459 = ((-_22_m19) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _466 = _391 * _459.xxx;
    _459 = (-_459) + 1.0f;
    _459 += _22_m18;
    _459 = clamp(_459, 0.0f, 1.0f);
    _480 = (-_437) + _459.xxx;
    _391 = (_9.xxx * _437) + _466;
    _391 = _96 * _391;
    _496 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _496.w);
    _496.w = 1.0f;
    _96.x = dot(_22_m2, _496);
    _96.y = dot(_22_m3, _496);
    _96.z = dot(_22_m4, _496);
    _96 += vs_TEXCOORD3;
    _96 = max(_96, 0.0f.xxx);
    _96 = _466 * _96;
    _9.x = dot(_129, _22_m1.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _129.x = dot(_129, _117);
    _129.x = clamp(_129.x, 0.0f, 1.0f);
    _459 = (-_129.x) + 1.0f;
    _459 *= _459;
    _459 *= _459;
    _437 = (_459.xxx * _480) + _437;
    _129 = (_391 * _9.xxx) + _96;
    _96.x = dot(-_117, vs_TEXCOORD1);
    _96.x += _96.x;
    _96 = (vs_TEXCOORD1 * (-_96.xxx)) + (-_117);
    float2 _596 = ((-_235.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _466 = float3(_596.x, _596.y, _466.z);
    _459 = _235 * _466.x;
    _313 = ((-_313) * _466.y) + 1.0f;
    _459 *= 6.0f;
    _612 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _96, _459);
    _96.x = _612.w + (-1.0f);
    _96.x = (_22_m9.w * _96.x) + 1.0f;
    _96.x = log2(_96.x);
    _96.x *= _22_m9.y;
    _96.x = exp2(_96.x);
    _96.x *= _22_m9.x;
    _96 = _612.xyz * _96.xxx;
    _96 *= _313.xxx;
    _117 = (_96 * _437) + _129;
    _129 = (_401 * _22_m12.xyz) + (-_78);
    _9 = (float3(float3(_22_m17, _22_m17, _22_m17)) * _129) + _78;
    float3 _696 = _9 + _117;
    _693 = float4(_696.x, _696.y, _696.z, _693.w);
    _693.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._693 = _693;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_4LightPosX0;
float4 unity_4LightPosY0;
float4 unity_4LightPosZ0;
float4 unity_4LightAtten0;
float4 unity_LightColor[8];
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _23_m9[4];
float4x4 unity_WorldToObject;
static float4 _23_m10[4];
float4x4 unity_MatrixVP;
static float4 _23_m11[4];
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _23_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 unity_4LightPosX0
#define _23_m1 unity_4LightPosY0
#define _23_m2 unity_4LightPosZ0
#define _23_m3 unity_4LightAtten0
#define _23_m4 unity_LightColor
#define _23_m5 unity_SHBr
#define _23_m6 unity_SHBg
#define _23_m7 unity_SHBb
#define _23_m8 unity_SHC
#define _23_m12 _MainTex_ST
#define _23_m13 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float4 _101;
static float3 _130;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _130 : NORMAL;
    float4 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _65;
static float _153;
static float4 _181;
static float4 _194;
static float3 _292;
static float4 _309;
static float3 _315;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m9[1];
    _9 = (_23_m9[0] * _11.xxxx) + _9;
    _9 = (_23_m9[2] * _11.zzzz) + _9;
    _47 = _9 + _23_m9[3];
    float3 _62 = (_23_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _47.yyyy * _23_m11[1];
    _65 = (_23_m11[0] * _47.xxxx) + _65;
    _65 = (_23_m11[2] * _47.zzzz) + _65;
    gl_Position = (_23_m11[3] * _47.wwww) + _65;
    float2 _113 = (_101.xy * _23_m12.xy) + _23_m12.zw;
    vs_TEXCOORD0 = float4(_113.x, _113.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _126 = (_101.xy * _23_m13.xy) + _23_m13.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _126.x, _126.y);
    _47.x = dot(_130, _23_m10[0].xyz);
    _47.y = dot(_130, _23_m10[1].xyz);
    _47.z = dot(_130, _23_m10[2].xyz);
    _153 = dot(_47.xyz, _47.xyz);
    _153 = rsqrt(_153);
    float3 _165 = _153.xxx * _47.xyz;
    _47 = float4(_165.x, _165.y, _165.z, _47.w);
    vs_TEXCOORD1 = _47.xyz;
    vs_TEXCOORD2 = _9.xyz;
    _65 = (-_9.xxxx) + _23_m0;
    _181 = (-_9.yyyy) + _23_m1;
    _9 = (-_9.zzzz) + _23_m2;
    _194 = _47.yyyy * _181;
    _181 *= _181;
    _181 = (_65 * _65) + _181;
    _65 = (_65 * _47.xxxx) + _194;
    _65 = (_9 * _47.zzzz) + _65;
    _9 = (_9 * _9) + _181;
    _9 = max(_9, 9.9999999747524270787835121154785e-07f.xxxx);
    _181 = rsqrt(_9);
    _9 = (_9 * _23_m3) + 1.0f.xxxx;
    _9 = 1.0f.xxxx / _9;
    _65 *= _181;
    _65 = max(_65, 0.0f.xxxx);
    _9 *= _65;
    float3 _255 = _9.yyy * _23_m4[1].xyz;
    _65 = float4(_255.x, _255.y, _255.z, _65.w);
    float3 _266 = (_23_m4[0].xyz * _9.xxx) + _65.xyz;
    _65 = float4(_266.x, _266.y, _266.z, _65.w);
    float3 _277 = (_23_m4[2].xyz * _9.zzz) + _65.xyz;
    _9 = float4(_277.x, _277.y, _277.z, _9.w);
    float3 _288 = (_23_m4[3].xyz * _9.www) + _9.xyz;
    _9 = float4(_288.x, _288.y, _288.z, _9.w);
    _292.x = _47.y * _47.y;
    _292.x = (_47.x * _47.x) + (-_292.x);
    _309 = _47.yzzx * _47.xyzz;
    _315.x = dot(_23_m5, _309);
    _315.y = dot(_23_m6, _309);
    _315.z = dot(_23_m7, _309);
    _292 = (_23_m8.xyz * _292.xxx) + _315;
    vs_TEXCOORD3 = _9.xyz + _292;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _130 = stage_input._130;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_SpecCube0_HDR
#define _17_m6 _LightColor0
#define _17_m7 _Color
#define _17_m8 _EmissionColor
#define _17_m9 _ProtoColor
#define _17_m10 _ParallaxDepth
#define _17_m11 _ProtoEmission
#define _17_m12 _Fade
#define _17_m13 _FadeEmission
#define _17_m14 _Glossiness
#define _17_m15 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float4 _540;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _540 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float _154;
static float3 _202;
static float3 _218;
static float3 _225;
static float3 _235;
static float3 _271;
static float3 _293;
static float3 _301;
static float3 _321;
static float4 _340;
static float3 _346;
static float _391;
static float4 _459;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m14) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154 = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m10;
    float2 _199 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_199.x, _199.y, _31.z);
    _202 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _202 * _17_m9.xyz;
    _218 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _225 = (_218 * _17_m7.xyz) + (-_31);
    _235 = _218 * _17_m7.xyz;
    _225 = (float3(float3(_17_m12, _17_m12, _17_m12)) * _225) + _31;
    _31 *= float3(float3(_17_m11, _17_m11, _17_m11));
    _271 = _225 + (-0.039999999105930328369140625f).xxx;
    _271 = (float3(float3(_17_m15, _17_m15, _17_m15)) * _271) + 0.039999999105930328369140625f.xxx;
    _293.x = ((-_17_m15) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _301 = _225 * _293.xxx;
    _293.x = (-_293.x) + 1.0f;
    _293.x += _17_m14;
    _293.x = clamp(_293.x, 0.0f, 1.0f);
    _321 = (-_271) + _293.xxx;
    _225 = (_25.xxx * _271) + _301;
    _225 *= _17_m6.xyz;
    _340 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _340.w);
    _340.w = 1.0f;
    _346.x = dot(_17_m2, _340);
    _346.y = dot(_17_m3, _340);
    _346.z = dot(_17_m4, _340);
    _346 += vs_TEXCOORD3;
    _346 = max(_346, 0.0f.xxx);
    _293 = _301 * _346;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _391 = (-_80.x) + 1.0f;
    _391 *= _391;
    _391 *= _391;
    _271 = (_391.xxx * _321) + _271;
    _80 = (_225 * _25.xxx) + _293;
    _293.x = dot(-_9, vs_TEXCOORD1);
    _293.x += _293.x;
    _293 = (vs_TEXCOORD1 * (-_293.xxx)) + (-_9);
    float2 _443 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _321 = float3(_443.x, _443.y, _321.z);
    _391 = _73 * _321.x;
    _154 = ((-_154) * _321.y) + 1.0f;
    _391 *= 6.0f;
    _459 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _293, _391);
    _293.x = _459.w + (-1.0f);
    _293.x = (_17_m5.w * _293.x) + 1.0f;
    _293.x = log2(_293.x);
    _293.x *= _17_m5.y;
    _293.x = exp2(_293.x);
    _293.x *= _17_m5.x;
    _293 = _459.xyz * _293.xxx;
    _293 = _154.xxx * _293;
    _9 = (_293 * _271) + _80;
    _80 = (_235 * _17_m8.xyz) + (-_31);
    _31 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _80) + _31;
    float3 _543 = _9 + _31;
    _540 = float4(_543.x, _543.y, _543.z, _540.w);
    _540.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._540 = _540;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m4[4];
float4x4 unity_WorldToObject;
static float4 _21_m5[4];
float4x4 unity_MatrixVP;
static float4 _21_m6[4];
float4 _MainTex_ST;
float4 _ProtoTex_ST;
void __unity_init()
{
    _21_m4[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m4[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m4[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m4[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m5[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m5[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m5[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m5[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m6[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m6[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m6[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m6[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHBr
#define _21_m1 unity_SHBg
#define _21_m2 unity_SHBb
#define _21_m3 unity_SHC
#define _21_m7 _MainTex_ST
#define _21_m8 _ProtoTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 _98;
static float3 _127;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _127 : NORMAL;
    float4 _98 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _150;
static float _168;
static float4 _182;
static float3 _189;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m4[1];
    _9 = (_21_m4[0] * _11.xxxx) + _9;
    _9 = (_21_m4[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m4[3];
    vs_TEXCOORD2 = (_21_m4[3].xyz * _11.www) + _9.xyz;
    _9 = _45.yyyy * _21_m6[1];
    _9 = (_21_m6[0] * _45.xxxx) + _9;
    _9 = (_21_m6[2] * _45.zzzz) + _9;
    gl_Position = (_21_m6[3] * _45.wwww) + _9;
    float2 _110 = (_98.xy * _21_m7.xy) + _21_m7.zw;
    vs_TEXCOORD0 = float4(_110.x, _110.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _123 = (_98.xy * _21_m8.xy) + _21_m8.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _123.x, _123.y);
    _9.x = dot(_127, _21_m5[0].xyz);
    _9.y = dot(_127, _21_m5[1].xyz);
    _9.z = dot(_127, _21_m5[2].xyz);
    _150 = dot(_9.xyz, _9.xyz);
    _150 = rsqrt(_150);
    float3 _162 = _150.xxx * _9.xyz;
    _9 = float4(_162.x, _162.y, _162.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _168 = _9.y * _9.y;
    _168 = (_9.x * _9.x) + (-_168);
    _182 = _9.yzzx * _9.xyzz;
    _189.x = dot(_21_m0, _182);
    _189.y = dot(_21_m1, _182);
    _189.z = dot(_21_m2, _182);
    vs_TEXCOORD3 = (_21_m3.xyz * _168.xxx) + _189;
    vs_TEXCOORD5 = 0.0f.xxxx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _98 = stage_input._98;
    _127 = stage_input._127;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SpecCube0_HDR;
float4 _LightColor0;
float4 _Color;
float4 _EmissionColor;
float4 _ProtoColor;
float _ParallaxDepth;
float _ProtoEmission;
float _Fade;
float _FadeEmission;
float _Glossiness;
float _Metallic;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 unity_SHAr
#define _17_m3 unity_SHAg
#define _17_m4 unity_SHAb
#define _17_m5 unity_SpecCube0_HDR
#define _17_m6 _LightColor0
#define _17_m7 _Color
#define _17_m8 _EmissionColor
#define _17_m9 _ProtoColor
#define _17_m10 _ParallaxDepth
#define _17_m11 _ProtoEmission
#define _17_m12 _Fade
#define _17_m13 _FadeEmission
#define _17_m14 _Glossiness
#define _17_m15 _Metallic


Texture2D<float4> _ProtoTex;
SamplerState sampler_ProtoTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float4 _540;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _540 : SV_Target0;
};

static float3 _9;
static float _25;
static float3 _31;
static float _73;
static float3 _80;
static float _120;
static float _124;
static float _154;
static float3 _202;
static float3 _218;
static float3 _225;
static float3 _235;
static float3 _271;
static float3 _293;
static float3 _301;
static float3 _321;
static float4 _340;
static float3 _346;
static float _391;
static float4 _459;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _25 = rsqrt(_25);
    _31 = (_9 * _25.xxx) + _17_m1.xyz;
    _9 = _25.xxx * _9;
    _25 = dot(_31, _31);
    _25 = max(_25, 0.001000000047497451305389404296875f);
    _25 = rsqrt(_25);
    _31 = _25.xxx * _31;
    _25 = dot(_17_m1.xyz, _31);
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 *= _25;
    _25 = max(_25, 0.100000001490116119384765625f);
    _73 = (-_17_m14) + 1.0f;
    _80.x = (_73 * _73) + 0.5f;
    _25 *= _80.x;
    _80.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _80.x = rsqrt(_80.x);
    _80 = _80.xxx * vs_TEXCOORD1;
    _31.x = dot(_80, _31);
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _31.x *= _31.x;
    _120 = _73 * _73;
    _124 = (_120 * _120) + (-1.0f);
    _31.x = (_31.x * _124) + 1.000010013580322265625f;
    _31.x *= _31.x;
    _25 *= _31.x;
    _25 *= 4.0f;
    _31.x = _120 * _120;
    _154 = _73 * _120;
    _25 = _31.x / _25;
    _25 += (-9.9999997473787516355514526367188e-05f);
    _25 = max(_25, 0.0f);
    _25 = min(_25, 100.0f);
    _31.x = (-abs(_9.z)) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x *= _17_m10;
    float2 _199 = ((-_9.xy) * _31.xx) + vs_TEXCOORD0.zw;
    _31 = float3(_199.x, _199.y, _31.z);
    _202 = _ProtoTex.Sample(sampler_ProtoTex, _31.xy).xyz;
    _31 = _202 * _17_m9.xyz;
    _218 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xyz;
    _225 = (_218 * _17_m7.xyz) + (-_31);
    _235 = _218 * _17_m7.xyz;
    _225 = (float3(float3(_17_m12, _17_m12, _17_m12)) * _225) + _31;
    _31 *= float3(float3(_17_m11, _17_m11, _17_m11));
    _271 = _225 + (-0.039999999105930328369140625f).xxx;
    _271 = (float3(float3(_17_m15, _17_m15, _17_m15)) * _271) + 0.039999999105930328369140625f.xxx;
    _293.x = ((-_17_m15) * 0.959999978542327880859375f) + 0.959999978542327880859375f;
    _301 = _225 * _293.xxx;
    _293.x = (-_293.x) + 1.0f;
    _293.x += _17_m14;
    _293.x = clamp(_293.x, 0.0f, 1.0f);
    _321 = (-_271) + _293.xxx;
    _225 = (_25.xxx * _271) + _301;
    _225 *= _17_m6.xyz;
    _340 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, vs_TEXCOORD1.z, _340.w);
    _340.w = 1.0f;
    _346.x = dot(_17_m2, _340);
    _346.y = dot(_17_m3, _340);
    _346.z = dot(_17_m4, _340);
    _346 += vs_TEXCOORD3;
    _346 = max(_346, 0.0f.xxx);
    _293 = _301 * _346;
    _25 = dot(_80, _17_m1.xyz);
    _25 = clamp(_25, 0.0f, 1.0f);
    _80.x = dot(_80, _9);
    _80.x = clamp(_80.x, 0.0f, 1.0f);
    _391 = (-_80.x) + 1.0f;
    _391 *= _391;
    _391 *= _391;
    _271 = (_391.xxx * _321) + _271;
    _80 = (_225 * _25.xxx) + _293;
    _293.x = dot(-_9, vs_TEXCOORD1);
    _293.x += _293.x;
    _293 = (vs_TEXCOORD1 * (-_293.xxx)) + (-_9);
    float2 _443 = ((-_73.xx) * float2(0.699999988079071044921875f, 0.07999999821186065673828125f)) + float2(1.7000000476837158203125f, 0.60000002384185791015625f);
    _321 = float3(_443.x, _443.y, _321.z);
    _391 = _73 * _321.x;
    _154 = ((-_154) * _321.y) + 1.0f;
    _391 *= 6.0f;
    _459 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _293, _391);
    _293.x = _459.w + (-1.0f);
    _293.x = (_17_m5.w * _293.x) + 1.0f;
    _293.x = log2(_293.x);
    _293.x *= _17_m5.y;
    _293.x = exp2(_293.x);
    _293.x *= _17_m5.x;
    _293 = _459.xyz * _293.xxx;
    _293 = _154.xxx * _293;
    _9 = (_293 * _271) + _80;
    _80 = (_235 * _17_m8.xyz) + (-_31);
    _31 = (float3(float3(_17_m13, _17_m13, _17_m13)) * _80) + _31;
    float3 _543 = _9 + _31;
    _540 = float4(_543.x, _543.y, _543.z, _540.w);
    _540.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._540 = _540;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Diffuse"
}