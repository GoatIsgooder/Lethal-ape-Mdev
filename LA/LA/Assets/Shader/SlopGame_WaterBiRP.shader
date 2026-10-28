// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SlopGame/WaterBiRP" {
Properties {

Color_ff449a8570c14274ba55e8d07cd83774 ("ShallowColor", Color) = (0.092,0.557,0.388,0)

Color_4cf6d225bd134001ab7dcea1fb58fb6e ("DeepColor", Color) = (0.133,0.282,0.341,0)

Vector1_8950b44aee124c4d916556ec8c87ef3f ("DepthFade", Range(0.05, 8)) = 1.399999976158142

Vector1_cf55867b574a463c83ba155329dfea64 ("FogDensity", Range(0, 8)) = 2.9000000953674316

Vector1_6729378f81fd4ab3ac941f56ecbc0b8a ("Smoothness", Range(0, 1)) = 0.9800000190734863

Vector1_fe60c19674c74223a4aca25f564af887 ("Metallic", Range(0, 1)) = 0.878000020980835

Vector1_fe7b1070c3dc4d1da621ee668cf66978 ("AlphaFade", Range(0.01, 4)) = 0.4000000059604645

Vector1_aceb7f103de1435a8b3d9517a5757774 ("AlphaStr", Range(0, 4)) = 1.0

Texture2D_e0e9f6b982f34470a5e1d61a4e0a237f ("NormalA", 2D) = "bump" { }

Texture2D_a1433b49937f480db28b8cc459ef36f5 ("NormalB", 2D) = "bump" { }

Vector1_e4c0786ba735455fa3d208984b11c9ad ("NormalStrength", Range(0, 4)) = 0.10000000149011612

Vector1_6beb98ff56f0482cb4e80757a71d9149 ("Speed", Range(-5, 5)) = 1.1299999952316284

Vector1_956a889d62c14ab9bf8ca5ef37d8794c ("Tile", Range(0.001, 5)) = 0.25

Vector1_ecd239cc1ed14f97a1905f8c5ce01744 ("RefractionStrength", Range(0, 4)) = 0.5

Texture2D_40d1b6435c73444a8bf21e2de0eb021f ("FoamTex", 2D) = "black" { }

Vector1_9871f392684d4d8f921e20c82f82a154 ("FoamDepth", Range(0, 4)) = 0.10000000149011612

Vector1_84038b57e2ab496c882ca72079eb3418 ("FoamFade", Range(0.01, 8)) = 0.3199999928474426

Vector1_74cf11a838884a1ca1da33cc0cfb2077 ("FoamStr", Range(0, 4)) = 0.05000000074505806

Vector1_4aa82ce25dfc4718b9e16b98aa9f1bef ("FoamTile", Range(0.01, 32)) = 7.5

Vector1_08b02a5734a045829127dc604212bb0d ("FoamRefracStr", Range(0, 8)) = 2.680000066757202

Vector1_da6639f1356b4847af429a09a44e9ef8 ("WaveSteepness", Range(0, 1)) = 0.07000000029802322

Vector1_f2a453661f3f4a5ba9e048487956f02d ("WaveLength", Range(0.5, 80)) = 11.75

Vector1_7993b655d9af4590b2e1943d549d5c36 ("WaveSpeed", Range(0, 5)) = 0.019999999552965164

Vector4_9cbc85c0b2da4bf9a5ef28ed25ca1aac ("WaveDirections", Vector) = (3,12.13,13.24,3.63)

Vector1_f13a308ec7df400098746ab25c30f63f ("WaveRefracStr", Range(0, 4)) = 0.49000000953674316

Vector1_1953120eb9d64aafa2a042654df704ee ("WaveNormalStr", Range(0, 40)) = 24.799999237060547

Vector1_7cd3298c5f0d4a81be78e5b8a8fa137a ("FoamWaveStr", Range(0, 80)) = 29.15999984741211

_ReflectionCubemap ("Fallback Cubemap", Cube) = "black" { }

_ReflectionClamp ("Reflection Max Brightness", Range(0.1, 4)) = 1.0

}
SubShader {
 LOD 200
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+20" "RenderType" = "Transparent" }
 GrabPass {
 "_WaterGrabTex"
}
 Pass {
  LOD 200
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+20" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _16_m2[4];
float4x4 unity_MatrixVP;
static float4 _16_m3[4];
float4 unity_FogParams;
float Vector1_da6639f1356b4847af429a09a44e9ef8;
float Vector1_f2a453661f3f4a5ba9e048487956f02d;
float Vector1_7993b655d9af4590b2e1943d549d5c36;
float4 Vector4_9cbc85c0b2da4bf9a5ef28ed25ca1aac;
void __unity_init()
{
    _16_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _16_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _16_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _16_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _16_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _16_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _16_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _16_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _16_m0 _Time
#define _16_m1 _ProjectionParams
#define _16_m4 unity_FogParams
#define _16_m5 Vector1_da6639f1356b4847af429a09a44e9ef8
#define _16_m6 Vector1_f2a453661f3f4a5ba9e048487956f02d
#define _16_m7 Vector1_7993b655d9af4590b2e1943d549d5c36
#define _16_m8 Vector4_9cbc85c0b2da4bf9a5ef28ed25ca1aac



static float4 gl_Position;
static float4 _67;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD7;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _67 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD7 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 vs_TEXCOORD4 : TEXCOORD6;
    float4 vs_TEXCOORD5 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _32;
static float4 _65;
static float _133;
static float4 _147;
static float _156;
static float _162;
static float4 _167;
static float _175;
static float3 _180;
static float2 _188;
static float2 _199;
static float3 _237;
static float3 _263;
static float _268;
static float3 _273;
static float _296;
static float3 _322;
static float2 _349;
static float3 _476;
static float3 _681;
static float3 _685;
static float _699;
static bool _731;

void vert_inner()
{
    __unity_init();
    _9 = (_16_m8 * 2.0f.xxxx) + (-1.0f).xxxx;
    _9 *= 3.141590118408203125f.xxxx;
    _32.x = cos(_9.x);
    _9.x = sin(_9.x);
    _32.z = _9.x;
    _9.x = dot(_32.xz, _32.xz);
    _9.x = rsqrt(_9.x);
    float2 _62 = _9.xx * _32.xz;
    _32 = float4(_62.x, _62.y, _32.z, _32.w);
    float3 _76 = _67.yyy * _16_m2[1].xyz;
    _65 = float4(_76.x, _76.y, _76.z, _65.w);
    float3 _88 = (_16_m2[0].xyz * _67.xxx) + _65.xyz;
    _65 = float4(_88.x, _88.y, _88.z, _65.w);
    float3 _99 = (_16_m2[2].xyz * _67.zzz) + _65.xyz;
    _65 = float4(_99.x, _99.y, _99.z, _65.w);
    float3 _111 = (_16_m2[3].xyz * _67.www) + _65.xyz;
    _65 = float4(_111.x, _111.y, _111.z, _65.w);
    _9.x = dot(_32.xy, _65.xz);
    _9.x = ((-_16_m7) * _16_m0.y) + _9.x;
    _133 = max(_16_m6, 9.9999997473787516355514526367188e-05f);
    _133 = 6.28318023681640625f / _133;
    _9.x *= _133;
    _147.x = cos(_9.x);
    _9.x = sin(_9.x);
    _156 = _16_m5 / _133;
    _162 = _147.x * _156;
    float2 _172 = _32.xy * _162.xx;
    _167 = float4(_172.x, _167.y, _172.y, _167.w);
    _175 = sin(_9.y);
    _180.x = cos(_9.y);
    _180.z = _175;
    _188.x = dot(_180.xz, _180.xz);
    _188.x = rsqrt(_188.x);
    _199 = _188.xx * _180.xz;
    _188.x = dot(_199, _65.xz);
    _188.x = ((-_16_m7) * _16_m0.y) + _188.x;
    _188.x *= _133;
    _175 = sin(_188.x);
    _180.x = cos(_188.x);
    _188.x = _156 * _180.x;
    float2 _241 = _188.xx * _199;
    _237 = float3(_241.x, _237.y, _241.y);
    _167.y = _9.x * _156;
    _237.y = _156 * _175;
    float3 _256 = _167.xyz + _237;
    _167 = float4(_256.x, _256.y, _256.z, _167.w);
    _237.x = sin(_9.z);
    _263.x = cos(_9.z);
    _268 = sin(_9.w);
    _273.x = cos(_9.w);
    _263.z = _237.x;
    _188.x = dot(_263.xz, _263.xz);
    _188.x = rsqrt(_188.x);
    _188 = _188.xx * _263.xz;
    _296 = dot(_188, _65.xz);
    _296 = ((-_16_m7) * _16_m0.y) + _296;
    _296 *= _133;
    _237.x = sin(_296);
    _263.x = cos(_296);
    _296 = _156 * _263.x;
    float2 _326 = _296.xx * _188;
    _322 = float3(_326.x, _322.y, _326.y);
    _322.y = _156 * _237.x;
    float3 _337 = _167.xyz + _322;
    _167 = float4(_337.x, _337.y, _337.z, _167.w);
    _273.z = _268;
    _296 = dot(_273.xz, _273.xz);
    _296 = rsqrt(_296);
    _349 = _296.xx * _273.xz;
    _296 = dot(_349, _65.xz);
    _296 = ((-_16_m7) * _16_m0.y) + _296;
    _296 *= _133;
    _268 = sin(_296);
    _273.x = cos(_296);
    _296 = _156 * _273.x;
    _322.y = _156 * _268;
    float2 _386 = _296.xx * _349;
    _322 = float3(_386.x, _322.y, _386.y);
    float3 _392 = _167.xyz + _322;
    _167 = float4(_392.x, _392.y, _392.z, _167.w);
    float3 _399 = _65.xyz + _167.xyz;
    _65 = float4(_399.x, _399.y, _399.z, _65.w);
    vs_TEXCOORD6 = _167.y;
    _167 = _65.yyyy * _16_m3[1];
    _167 = (_16_m3[0] * _65.xxxx) + _167;
    _167 = (_16_m3[2] * _65.zzzz) + _167;
    vs_TEXCOORD0 = _65.xyz;
    _65 = _167 + _16_m3[3];
    gl_Position = _65;
    float3 _445 = _32.xyy * (-_32.xxy);
    _167 = float4(_445.x, _445.y, _445.z, _167.w);
    _9.x *= _16_m5;
    _296 = _147.x * _16_m5;
    float2 _463 = _296.xx * _32.xy;
    _32 = float4(_463.x, _463.y, _32.z, _32.w);
    float3 _470 = _9.xxx * _167.xyz;
    _167 = float4(_470.x, _470.y, _470.z, _167.w);
    _167.w = _32.x;
    _476 = _167.xwy + float3(1.0f, 0.0f, 0.0f);
    _32 = float4(_32.x, _32.y, _167.yz.x, _167.yz.y);
    float3 _490 = _32.ywz + float3(0.0f, 1.0f, 0.0f);
    _32 = float4(_490.x, _490.y, _490.z, _32.w);
    float3 _498 = _199.xyy * (-_199.xxy);
    _167 = float4(_498.x, _498.y, _498.z, _167.w);
    _9.x = _175 * _16_m5;
    _296 = _180.x * _16_m5;
    float2 _514 = _296.xx * _199;
    _147 = float4(_514.x, _514.y, _147.z, _147.w);
    float3 _521 = _9.xxx * _167.xyz;
    _167 = float4(_521.x, _521.y, _521.z, _167.w);
    _167.w = _147.x;
    _180 = _167.xwy + _476;
    _147 = float4(_147.x, _147.y, _167.yz.x, _167.yz.y);
    float3 _539 = _32.xyz + _147.ywz;
    _32 = float4(_539.x, _539.y, _539.z, _32.w);
    float3 _547 = _188.xyy * (-_188.xxy);
    _147 = float4(_547.x, _547.y, _547.z, _147.w);
    _9.x = _237.x * _16_m5;
    _296 = _263.x * _16_m5;
    float2 _564 = _296.xx * _188;
    _167 = float4(_564.x, _564.y, _167.z, _167.w);
    float3 _571 = _9.xxx * _147.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.w = _167.x;
    float3 _580 = _9.xwy + _180;
    _147 = float4(_580.x, _580.y, _580.z, _147.w);
    _167 = float4(_167.x, _167.y, _9.yz.x, _9.yz.y);
    float3 _591 = _32.xyz + _167.ywz;
    _9 = float4(_591.x, _591.y, _591.z, _9.w);
    float3 _599 = _349.xyy * (-_349.xxy);
    _32 = float4(_599.x, _599.y, _599.z, _32.w);
    _296 = _268 * _16_m5;
    _156 = _273.x * _16_m5;
    float2 _614 = _156.xx * _349;
    _167 = float4(_614.x, _614.y, _167.z, _167.w);
    float3 _621 = _296.xxx * _32.xyz;
    _32 = float4(_621.x, _621.y, _621.z, _32.w);
    _32.w = _167.x;
    float3 _631 = _32.xwy + _147.xyz;
    _147 = float4(_631.x, _631.y, _631.z, _147.w);
    _167 = float4(_167.x, _167.y, _32.yz.x, _32.yz.y);
    float3 _642 = _9.xyz + _167.ywz;
    _9 = float4(_642.x, _642.y, _642.z, _9.w);
    float3 _649 = _147.xyz * _9.xyz;
    _32 = float4(_649.x, _649.y, _649.z, _32.w);
    float3 _660 = (_9.zxy * _147.yzx) + (-_32.xyz);
    _9 = float4(_660.x, _660.y, _660.z, _9.w);
    _296 = dot(_9.xyz, _9.xyz);
    _296 = rsqrt(_296);
    float3 _674 = _296.xxx * _9.xyz;
    _9 = float4(_674.x, _674.y, _674.z, _9.w);
    vs_TEXCOORD1.z = _9.y;
    _681 = _9.yzx * float3(0.0f, 1.0f, 0.0f);
    _685 = (_9.xyz * float3(1.0f, 0.0f, 0.0f)) + (-_681);
    _681 = ((-_9.yzx) * float3(1.0f, 0.0f, 0.0f)) + _681.zxy;
    _699 = dot(_685.xy, _685.xy);
    _699 = rsqrt(_699);
    _685 = _699.xxx * _685;
    _699 = dot(_681.xz, _681.xz);
    _699 = rsqrt(_699);
    _681 = _699.xxx * _681;
    _699 = dot(_681.xz, _681.xz);
    _699 = sqrt(_699);
    _731 = _699 < 0.00999999977648258209228515625f;
    float3 _737;
    if (_731)
    {
        _737 = _685;
    }
    else
    {
        _737 = _681;
    }
    _681 = _737;
    _685 = _9.xyz * _681;
    _685 = (_9.zxy * _681.yzx) + (-_685);
    vs_TEXCOORD1.y = _685.x;
    vs_TEXCOORD1.x = _681.z;
    _188.x = _65.z / _16_m1.y;
    _188.x = (-_188.x) + 1.0f;
    _188.x *= _16_m1.z;
    _188.x = max(_188.x, 0.0f);
    _188.x *= _16_m4.y;
    vs_TEXCOORD7 = exp2(-_188.x);
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.x = _681.x;
    vs_TEXCOORD3.x = _681.y;
    vs_TEXCOORD2.y = _685.y;
    vs_TEXCOORD3.y = _685.z;
    float2 _819 = _65.xw * 0.5f.xx;
    _9 = float4(_819.x, _9.y, _819.y, _9.w);
    float2 _830 = (_65.xy * float2(0.5f, -0.5f)) + _9.zz;
    vs_TEXCOORD4 = float4(_830.x, _830.y, vs_TEXCOORD4.z, vs_TEXCOORD4.w);
    _188.x = _65.y * _16_m1.x;
    _9.w = _188.x * 0.5f;
    float2 _848 = _9.zz + _9.xw;
    vs_TEXCOORD5 = float4(_848.x, _848.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
    vs_TEXCOORD4 = float4(vs_TEXCOORD4.x, vs_TEXCOORD4.y, _65.zw.x, _65.zw.y);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _65.zw.x, _65.zw.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _67 = stage_input._67;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ZBufferParams;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 Color_ff449a8570c14274ba55e8d07cd83774;
float4 Color_4cf6d225bd134001ab7dcea1fb58fb6e;
float Vector1_8950b44aee124c4d916556ec8c87ef3f;
float Vector1_cf55867b574a463c83ba155329dfea64;
float Vector1_6729378f81fd4ab3ac941f56ecbc0b8a;
float Vector1_fe60c19674c74223a4aca25f564af887;
float Vector1_fe7b1070c3dc4d1da621ee668cf66978;
float Vector1_aceb7f103de1435a8b3d9517a5757774;
float Vector1_e4c0786ba735455fa3d208984b11c9ad;
float Vector1_6beb98ff56f0482cb4e80757a71d9149;
float Vector1_956a889d62c14ab9bf8ca5ef37d8794c;
float Vector1_ecd239cc1ed14f97a1905f8c5ce01744;
float Vector1_9871f392684d4d8f921e20c82f82a154;
float Vector1_84038b57e2ab496c882ca72079eb3418;
float Vector1_74cf11a838884a1ca1da33cc0cfb2077;
float Vector1_4aa82ce25dfc4718b9e16b98aa9f1bef;
float Vector1_08b02a5734a045829127dc604212bb0d;
float Vector1_f13a308ec7df400098746ab25c30f63f;
float Vector1_7cd3298c5f0d4a81be78e5b8a8fa137a;
float _ReflectionClamp;
#define _14_m0 _Time
#define _14_m1 _WorldSpaceCameraPos
#define _14_m2 _ZBufferParams
#define _14_m3 unity_FogColor
#define _14_m4 unity_SpecCube0_HDR
#define _14_m5 Color_ff449a8570c14274ba55e8d07cd83774
#define _14_m6 Color_4cf6d225bd134001ab7dcea1fb58fb6e
#define _14_m7 Vector1_8950b44aee124c4d916556ec8c87ef3f
#define _14_m8 Vector1_cf55867b574a463c83ba155329dfea64
#define _14_m9 Vector1_6729378f81fd4ab3ac941f56ecbc0b8a
#define _14_m10 Vector1_fe60c19674c74223a4aca25f564af887
#define _14_m11 Vector1_fe7b1070c3dc4d1da621ee668cf66978
#define _14_m12 Vector1_aceb7f103de1435a8b3d9517a5757774
#define _14_m13 Vector1_e4c0786ba735455fa3d208984b11c9ad
#define _14_m14 Vector1_6beb98ff56f0482cb4e80757a71d9149
#define _14_m15 Vector1_956a889d62c14ab9bf8ca5ef37d8794c
#define _14_m16 Vector1_ecd239cc1ed14f97a1905f8c5ce01744
#define _14_m17 Vector1_9871f392684d4d8f921e20c82f82a154
#define _14_m18 Vector1_84038b57e2ab496c882ca72079eb3418
#define _14_m19 Vector1_74cf11a838884a1ca1da33cc0cfb2077
#define _14_m20 Vector1_4aa82ce25dfc4718b9e16b98aa9f1bef
#define _14_m21 Vector1_08b02a5734a045829127dc604212bb0d
#define _14_m22 Vector1_f13a308ec7df400098746ab25c30f63f
#define _14_m23 Vector1_7cd3298c5f0d4a81be78e5b8a8fa137a
#define _14_m24 _ReflectionClamp


Texture2D<float4> Texture2D_a1433b49937f480db28b8cc459ef36f5;
SamplerState samplerTexture2D_a1433b49937f480db28b8cc459ef36f5;
Texture2D<float4> Texture2D_e0e9f6b982f34470a5e1d61a4e0a237f;
SamplerState samplerTexture2D_e0e9f6b982f34470a5e1d61a4e0a237f;
Texture2D<float4> Texture2D_40d1b6435c73444a8bf21e2de0eb021f;
SamplerState samplerTexture2D_40d1b6435c73444a8bf21e2de0eb021f;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
TextureCube<float4> _ReflectionCubemap;
SamplerState sampler_ReflectionCubemap;
Texture2D<float4> _WaterGrabTex;
SamplerState sampler_WaterGrabTex;
Texture2D<float4> _CameraDepthTexture;
SamplerState sampler_CameraDepthTexture;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD6;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;
static float vs_TEXCOORD7;
static float4 _723;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD7 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 vs_TEXCOORD4 : TEXCOORD6;
    float4 vs_TEXCOORD5 : TEXCOORD7;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _723 : SV_Target0;
};

static float2 _9;
static float4 _30;
static float3 _71;
static float4 _81;
static float3 _90;
static float3 _99;
static float3 _117;
static float2 _168;
static float2 _184;
static float _276;
static float _282;
static float _492;
static float3 _519;
static float _589;
static float _601;

void frag_inner()
{
    _9.x = _14_m0.y * _14_m14;
    _30 = _9.xxxx * float4(0.100000001490116119384765625f, 0.0500000007450580596923828125f, -0.07999999821186065673828125f, 0.119999997317790985107421875f);
    _9 = _9.xx * float2(0.0199999995529651641845703125f, 0.00999999977648258209228515625f);
    _9 = (vs_TEXCOORD0.xz * float2(float2(_14_m20, _14_m20))) + _9;
    _30 = (vs_TEXCOORD0.xzxz * _14_m15.xxxx) + _30;
    _71 = Texture2D_a1433b49937f480db28b8cc459ef36f5.Sample(samplerTexture2D_a1433b49937f480db28b8cc459ef36f5, _30.zw).xyz;
    float3 _87 = Texture2D_e0e9f6b982f34470a5e1d61a4e0a237f.Sample(samplerTexture2D_e0e9f6b982f34470a5e1d61a4e0a237f, _30.xy).xyz;
    _81 = float4(_87.x, _87.y, _87.z, _81.w);
    _90 = (_81.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _99 = (_71 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _114 = _99.xy * float2(float2(_14_m13, _14_m13));
    _99 = float3(_114.x, _114.y, _99.z);
    _117.z = _90.z * _99.z;
    float2 _138 = (_90.xy * float2(float2(_14_m13, _14_m13))) + _99.xy;
    _117 = float3(_138.x, _138.y, _117.z);
    _90.x = dot(_117, _117);
    _90.x = rsqrt(_90.x);
    _90 = _90.xxx * _117;
    _30.x = dot(vs_TEXCOORD1, _90);
    _30.y = dot(vs_TEXCOORD2, _90);
    _30.z = dot(vs_TEXCOORD3, _90);
    _168.x = dot(_30.xyz, _30.xyz);
    _168.x = rsqrt(_168.x);
    _99 = _30.xyz * _168.xxx;
    _184.x = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    _99 = _184.xxx * _99;
    float3 _205 = (-vs_TEXCOORD0) + _14_m1;
    _30 = float4(_205.x, _205.y, _205.z, _30.w);
    _184.x = dot(_30.xyz, _30.xyz);
    _184.x = rsqrt(_184.x);
    float3 _222 = _184.xxx * _30.xyz;
    _30 = float4(_222.x, _222.y, _222.z, _30.w);
    _168.x = dot(-_30.xyz, _99);
    _168.x += _168.x;
    _117 = (_99 * (-_168.xxx)) + (-_30.xyz);
    _168.x = dot(_99, _30.xyz);
    _168.x = clamp(_168.x, 0.0f, 1.0f);
    float2 _267 = _99.xz * float2(float2(_14_m21, _14_m21));
    _99 = float3(_267.x, _267.y, _99.z);
    _9 = (_99.xy * 0.00999999977648258209228515625f.xx) + _9;
    _276 = Texture2D_40d1b6435c73444a8bf21e2de0eb021f.Sample(samplerTexture2D_40d1b6435c73444a8bf21e2de0eb021f, _9).x;
    _282 = (-_168.x) + 1.0f;
    _184.x = (-_14_m9) + 1.0f;
    _184.x *= 6.0f;
    _81 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _117, _184.x);
    _71 = _ReflectionCubemap.SampleLevel(sampler_ReflectionCubemap, _117, _184.x).xyz;
    _168.x = _81.w + (-1.0f);
    _168.x = (_14_m4.w * _168.x) + 1.0f;
    _168.x = log2(_168.x);
    _168.x *= _14_m4.y;
    _168.x = exp2(_168.x);
    _168.x *= _14_m4.x;
    float3 _353 = (_168.xxx * _81.xyz) + _71;
    _30 = float4(_353.x, _353.y, _353.z, _30.w);
    _99 = min(_30.xyz, float3(float3(_14_m24, _14_m24, _14_m24)));
    _168 = _90.xy * _14_m22.xx;
    float2 _389 = _90.xy * float2(float2(_14_m16, _14_m16));
    _90 = float3(_389.x, _389.y, _90.z);
    _184 = _168 * vs_TEXCOORD6.xx;
    _184 *= 0.0199999995529651641845703125f.xx;
    _184 = (_90.xy * 0.5f.xx) + _184;
    _184 = (_184 * vs_TEXCOORD4.ww) + vs_TEXCOORD4.xy;
    _184 /= vs_TEXCOORD4.ww;
    float3 _425 = _WaterGrabTex.Sample(sampler_WaterGrabTex, _184).xyz;
    _30 = float4(_425.x, _425.y, _425.z, _30.w);
    _184 = vs_TEXCOORD5.xy / vs_TEXCOORD5.ww;
    _184.x = _CameraDepthTexture.Sample(sampler_CameraDepthTexture, _184).x;
    _184.x = (_14_m2.z * _184.x) + _14_m2.w;
    _184.x = 1.0f / _184.x;
    _184.x += (-vs_TEXCOORD5.w);
    _184.x = max(_184.x, 0.0f);
    _184.x = min(_184.x, 50.0f);
    _184 = (-_184.xx) * float2(_14_m7, _14_m8);
    _184 *= float2(1.44269502162933349609375f, 0.14426951110363006591796875f);
    _184 = exp2(_184);
    _184 = (-_184) + 1.0f.xx;
    _492 = _184.y * 0.5f;
    _184.x = max(_184.x, 0.0f);
    _90 = (-_14_m5.xyz) + _14_m6.xyz;
    _90 = (_184.xxx * _90) + _14_m5.xyz;
    _519 = (-_90) + _14_m6.xyz;
    _519 = (_492.xxx * _519) + _90;
    _90 = (-_30.xyz) + _519;
    _492 = (_184.x * 0.85000002384185791015625f) + 0.1500000059604644775390625f;
    _90 = (_492.xxx * _90) + _30.xyz;
    _492 = (_14_m10 * 0.85000002384185791015625f) + 0.3499999940395355224609375f;
    _99 = (_99 * _492.xxx) + (-_90);
    _492 = _282 * _282;
    _492 *= _492;
    _282 = _492 * _282;
    _282 = (_282 * 0.980000019073486328125f) + 0.0199999995529651641845703125f;
    _492 = _282 * 0.699999988079071044921875f;
    _90 = (_492.xxx * _99) + _90;
    _99 = (-_90) + 1.0f.xxx;
    _589 = _184.x + (-_14_m17);
    _184.x = log2(_184.x);
    _601 = 1.0f / _14_m18;
    _589 *= _601;
    _589 = clamp(_589, 0.0f, 1.0f);
    _601 = (_589 * (-2.0f)) + 3.0f;
    _589 *= _589;
    _492 = ((-_601) * _589) + 1.0f;
    _589 = _276 * _492;
    _492 = vs_TEXCOORD6 * _14_m23;
    _492 *= 0.00999999977648258209228515625f;
    _492 = clamp(_492, 0.0f, 1.0f);
    _9.x = _276 * _492;
    _589 = (_589 * _14_m19) + _9.x;
    _589 = clamp(_589, 0.0f, 1.0f);
    _90 = (_589.xxx * _99) + _90;
    float3 _662 = _90 + (-_14_m3.xyz);
    _30 = float4(_662.x, _662.y, _662.z, _30.w);
    _9.x = vs_TEXCOORD7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _680 = (_9.xxx * _30.xyz) + _14_m3.xyz;
    _30 = float4(_680.x, _680.y, _680.z, _30.w);
    _9.x = max(_14_m11, 0.00999999977648258209228515625f);
    _9.x = _184.x * _9.x;
    _9.x = exp2(_9.x);
    _90.x = (_9.x * _14_m12) + _589;
    _9.x = (_282 * 0.89999997615814208984375f) + _90.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _30.w = max(_9.x, 0.3499999940395355224609375f);
    _723 = _30;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._723 = _723;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _16_m2[4];
float4x4 unity_MatrixVP;
static float4 _16_m3[4];
float4 unity_FogParams;
float Vector1_da6639f1356b4847af429a09a44e9ef8;
float Vector1_f2a453661f3f4a5ba9e048487956f02d;
float Vector1_7993b655d9af4590b2e1943d549d5c36;
float4 Vector4_9cbc85c0b2da4bf9a5ef28ed25ca1aac;
void __unity_init()
{
    _16_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _16_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _16_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _16_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _16_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _16_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _16_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _16_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _16_m0 _Time
#define _16_m1 _ProjectionParams
#define _16_m4 unity_FogParams
#define _16_m5 Vector1_da6639f1356b4847af429a09a44e9ef8
#define _16_m6 Vector1_f2a453661f3f4a5ba9e048487956f02d
#define _16_m7 Vector1_7993b655d9af4590b2e1943d549d5c36
#define _16_m8 Vector4_9cbc85c0b2da4bf9a5ef28ed25ca1aac



static float4 gl_Position;
static float4 _67;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD7;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _67 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD7 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 vs_TEXCOORD4 : TEXCOORD6;
    float4 vs_TEXCOORD5 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _32;
static float4 _65;
static float _133;
static float4 _147;
static float _156;
static float _162;
static float4 _167;
static float _175;
static float3 _180;
static float2 _188;
static float2 _199;
static float3 _237;
static float3 _263;
static float _268;
static float3 _273;
static float _296;
static float3 _322;
static float2 _349;
static float3 _476;
static float3 _681;
static float3 _685;
static float _699;
static bool _731;

void vert_inner()
{
    __unity_init();
    _9 = (_16_m8 * 2.0f.xxxx) + (-1.0f).xxxx;
    _9 *= 3.141590118408203125f.xxxx;
    _32.x = cos(_9.x);
    _9.x = sin(_9.x);
    _32.z = _9.x;
    _9.x = dot(_32.xz, _32.xz);
    _9.x = rsqrt(_9.x);
    float2 _62 = _9.xx * _32.xz;
    _32 = float4(_62.x, _62.y, _32.z, _32.w);
    float3 _76 = _67.yyy * _16_m2[1].xyz;
    _65 = float4(_76.x, _76.y, _76.z, _65.w);
    float3 _88 = (_16_m2[0].xyz * _67.xxx) + _65.xyz;
    _65 = float4(_88.x, _88.y, _88.z, _65.w);
    float3 _99 = (_16_m2[2].xyz * _67.zzz) + _65.xyz;
    _65 = float4(_99.x, _99.y, _99.z, _65.w);
    float3 _111 = (_16_m2[3].xyz * _67.www) + _65.xyz;
    _65 = float4(_111.x, _111.y, _111.z, _65.w);
    _9.x = dot(_32.xy, _65.xz);
    _9.x = ((-_16_m7) * _16_m0.y) + _9.x;
    _133 = max(_16_m6, 9.9999997473787516355514526367188e-05f);
    _133 = 6.28318023681640625f / _133;
    _9.x *= _133;
    _147.x = cos(_9.x);
    _9.x = sin(_9.x);
    _156 = _16_m5 / _133;
    _162 = _147.x * _156;
    float2 _172 = _32.xy * _162.xx;
    _167 = float4(_172.x, _167.y, _172.y, _167.w);
    _175 = sin(_9.y);
    _180.x = cos(_9.y);
    _180.z = _175;
    _188.x = dot(_180.xz, _180.xz);
    _188.x = rsqrt(_188.x);
    _199 = _188.xx * _180.xz;
    _188.x = dot(_199, _65.xz);
    _188.x = ((-_16_m7) * _16_m0.y) + _188.x;
    _188.x *= _133;
    _175 = sin(_188.x);
    _180.x = cos(_188.x);
    _188.x = _156 * _180.x;
    float2 _241 = _188.xx * _199;
    _237 = float3(_241.x, _237.y, _241.y);
    _167.y = _9.x * _156;
    _237.y = _156 * _175;
    float3 _256 = _167.xyz + _237;
    _167 = float4(_256.x, _256.y, _256.z, _167.w);
    _237.x = sin(_9.z);
    _263.x = cos(_9.z);
    _268 = sin(_9.w);
    _273.x = cos(_9.w);
    _263.z = _237.x;
    _188.x = dot(_263.xz, _263.xz);
    _188.x = rsqrt(_188.x);
    _188 = _188.xx * _263.xz;
    _296 = dot(_188, _65.xz);
    _296 = ((-_16_m7) * _16_m0.y) + _296;
    _296 *= _133;
    _237.x = sin(_296);
    _263.x = cos(_296);
    _296 = _156 * _263.x;
    float2 _326 = _296.xx * _188;
    _322 = float3(_326.x, _322.y, _326.y);
    _322.y = _156 * _237.x;
    float3 _337 = _167.xyz + _322;
    _167 = float4(_337.x, _337.y, _337.z, _167.w);
    _273.z = _268;
    _296 = dot(_273.xz, _273.xz);
    _296 = rsqrt(_296);
    _349 = _296.xx * _273.xz;
    _296 = dot(_349, _65.xz);
    _296 = ((-_16_m7) * _16_m0.y) + _296;
    _296 *= _133;
    _268 = sin(_296);
    _273.x = cos(_296);
    _296 = _156 * _273.x;
    _322.y = _156 * _268;
    float2 _386 = _296.xx * _349;
    _322 = float3(_386.x, _322.y, _386.y);
    float3 _392 = _167.xyz + _322;
    _167 = float4(_392.x, _392.y, _392.z, _167.w);
    float3 _399 = _65.xyz + _167.xyz;
    _65 = float4(_399.x, _399.y, _399.z, _65.w);
    vs_TEXCOORD6 = _167.y;
    _167 = _65.yyyy * _16_m3[1];
    _167 = (_16_m3[0] * _65.xxxx) + _167;
    _167 = (_16_m3[2] * _65.zzzz) + _167;
    vs_TEXCOORD0 = _65.xyz;
    _65 = _167 + _16_m3[3];
    gl_Position = _65;
    float3 _445 = _32.xyy * (-_32.xxy);
    _167 = float4(_445.x, _445.y, _445.z, _167.w);
    _9.x *= _16_m5;
    _296 = _147.x * _16_m5;
    float2 _463 = _296.xx * _32.xy;
    _32 = float4(_463.x, _463.y, _32.z, _32.w);
    float3 _470 = _9.xxx * _167.xyz;
    _167 = float4(_470.x, _470.y, _470.z, _167.w);
    _167.w = _32.x;
    _476 = _167.xwy + float3(1.0f, 0.0f, 0.0f);
    _32 = float4(_32.x, _32.y, _167.yz.x, _167.yz.y);
    float3 _490 = _32.ywz + float3(0.0f, 1.0f, 0.0f);
    _32 = float4(_490.x, _490.y, _490.z, _32.w);
    float3 _498 = _199.xyy * (-_199.xxy);
    _167 = float4(_498.x, _498.y, _498.z, _167.w);
    _9.x = _175 * _16_m5;
    _296 = _180.x * _16_m5;
    float2 _514 = _296.xx * _199;
    _147 = float4(_514.x, _514.y, _147.z, _147.w);
    float3 _521 = _9.xxx * _167.xyz;
    _167 = float4(_521.x, _521.y, _521.z, _167.w);
    _167.w = _147.x;
    _180 = _167.xwy + _476;
    _147 = float4(_147.x, _147.y, _167.yz.x, _167.yz.y);
    float3 _539 = _32.xyz + _147.ywz;
    _32 = float4(_539.x, _539.y, _539.z, _32.w);
    float3 _547 = _188.xyy * (-_188.xxy);
    _147 = float4(_547.x, _547.y, _547.z, _147.w);
    _9.x = _237.x * _16_m5;
    _296 = _263.x * _16_m5;
    float2 _564 = _296.xx * _188;
    _167 = float4(_564.x, _564.y, _167.z, _167.w);
    float3 _571 = _9.xxx * _147.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.w = _167.x;
    float3 _580 = _9.xwy + _180;
    _147 = float4(_580.x, _580.y, _580.z, _147.w);
    _167 = float4(_167.x, _167.y, _9.yz.x, _9.yz.y);
    float3 _591 = _32.xyz + _167.ywz;
    _9 = float4(_591.x, _591.y, _591.z, _9.w);
    float3 _599 = _349.xyy * (-_349.xxy);
    _32 = float4(_599.x, _599.y, _599.z, _32.w);
    _296 = _268 * _16_m5;
    _156 = _273.x * _16_m5;
    float2 _614 = _156.xx * _349;
    _167 = float4(_614.x, _614.y, _167.z, _167.w);
    float3 _621 = _296.xxx * _32.xyz;
    _32 = float4(_621.x, _621.y, _621.z, _32.w);
    _32.w = _167.x;
    float3 _631 = _32.xwy + _147.xyz;
    _147 = float4(_631.x, _631.y, _631.z, _147.w);
    _167 = float4(_167.x, _167.y, _32.yz.x, _32.yz.y);
    float3 _642 = _9.xyz + _167.ywz;
    _9 = float4(_642.x, _642.y, _642.z, _9.w);
    float3 _649 = _147.xyz * _9.xyz;
    _32 = float4(_649.x, _649.y, _649.z, _32.w);
    float3 _660 = (_9.zxy * _147.yzx) + (-_32.xyz);
    _9 = float4(_660.x, _660.y, _660.z, _9.w);
    _296 = dot(_9.xyz, _9.xyz);
    _296 = rsqrt(_296);
    float3 _674 = _296.xxx * _9.xyz;
    _9 = float4(_674.x, _674.y, _674.z, _9.w);
    vs_TEXCOORD1.z = _9.y;
    _681 = _9.yzx * float3(0.0f, 1.0f, 0.0f);
    _685 = (_9.xyz * float3(1.0f, 0.0f, 0.0f)) + (-_681);
    _681 = ((-_9.yzx) * float3(1.0f, 0.0f, 0.0f)) + _681.zxy;
    _699 = dot(_685.xy, _685.xy);
    _699 = rsqrt(_699);
    _685 = _699.xxx * _685;
    _699 = dot(_681.xz, _681.xz);
    _699 = rsqrt(_699);
    _681 = _699.xxx * _681;
    _699 = dot(_681.xz, _681.xz);
    _699 = sqrt(_699);
    _731 = _699 < 0.00999999977648258209228515625f;
    float3 _737;
    if (_731)
    {
        _737 = _685;
    }
    else
    {
        _737 = _681;
    }
    _681 = _737;
    _685 = _9.xyz * _681;
    _685 = (_9.zxy * _681.yzx) + (-_685);
    vs_TEXCOORD1.y = _685.x;
    vs_TEXCOORD1.x = _681.z;
    _188.x = _65.z / _16_m1.y;
    _188.x = (-_188.x) + 1.0f;
    _188.x *= _16_m1.z;
    _188.x = max(_188.x, 0.0f);
    _188.x *= _16_m4.x;
    _188.x *= (-_188.x);
    vs_TEXCOORD7 = exp2(_188.x);
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.x = _681.x;
    vs_TEXCOORD3.x = _681.y;
    vs_TEXCOORD2.y = _685.y;
    vs_TEXCOORD3.y = _685.z;
    float2 _825 = _65.xw * 0.5f.xx;
    _9 = float4(_825.x, _9.y, _825.y, _9.w);
    float2 _836 = (_65.xy * float2(0.5f, -0.5f)) + _9.zz;
    vs_TEXCOORD4 = float4(_836.x, _836.y, vs_TEXCOORD4.z, vs_TEXCOORD4.w);
    _188.x = _65.y * _16_m1.x;
    _9.w = _188.x * 0.5f;
    float2 _854 = _9.zz + _9.xw;
    vs_TEXCOORD5 = float4(_854.x, _854.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
    vs_TEXCOORD4 = float4(vs_TEXCOORD4.x, vs_TEXCOORD4.y, _65.zw.x, _65.zw.y);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _65.zw.x, _65.zw.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _67 = stage_input._67;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ZBufferParams;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 Color_ff449a8570c14274ba55e8d07cd83774;
float4 Color_4cf6d225bd134001ab7dcea1fb58fb6e;
float Vector1_8950b44aee124c4d916556ec8c87ef3f;
float Vector1_cf55867b574a463c83ba155329dfea64;
float Vector1_6729378f81fd4ab3ac941f56ecbc0b8a;
float Vector1_fe60c19674c74223a4aca25f564af887;
float Vector1_fe7b1070c3dc4d1da621ee668cf66978;
float Vector1_aceb7f103de1435a8b3d9517a5757774;
float Vector1_e4c0786ba735455fa3d208984b11c9ad;
float Vector1_6beb98ff56f0482cb4e80757a71d9149;
float Vector1_956a889d62c14ab9bf8ca5ef37d8794c;
float Vector1_ecd239cc1ed14f97a1905f8c5ce01744;
float Vector1_9871f392684d4d8f921e20c82f82a154;
float Vector1_84038b57e2ab496c882ca72079eb3418;
float Vector1_74cf11a838884a1ca1da33cc0cfb2077;
float Vector1_4aa82ce25dfc4718b9e16b98aa9f1bef;
float Vector1_08b02a5734a045829127dc604212bb0d;
float Vector1_f13a308ec7df400098746ab25c30f63f;
float Vector1_7cd3298c5f0d4a81be78e5b8a8fa137a;
float _ReflectionClamp;
#define _14_m0 _Time
#define _14_m1 _WorldSpaceCameraPos
#define _14_m2 _ZBufferParams
#define _14_m3 unity_FogColor
#define _14_m4 unity_SpecCube0_HDR
#define _14_m5 Color_ff449a8570c14274ba55e8d07cd83774
#define _14_m6 Color_4cf6d225bd134001ab7dcea1fb58fb6e
#define _14_m7 Vector1_8950b44aee124c4d916556ec8c87ef3f
#define _14_m8 Vector1_cf55867b574a463c83ba155329dfea64
#define _14_m9 Vector1_6729378f81fd4ab3ac941f56ecbc0b8a
#define _14_m10 Vector1_fe60c19674c74223a4aca25f564af887
#define _14_m11 Vector1_fe7b1070c3dc4d1da621ee668cf66978
#define _14_m12 Vector1_aceb7f103de1435a8b3d9517a5757774
#define _14_m13 Vector1_e4c0786ba735455fa3d208984b11c9ad
#define _14_m14 Vector1_6beb98ff56f0482cb4e80757a71d9149
#define _14_m15 Vector1_956a889d62c14ab9bf8ca5ef37d8794c
#define _14_m16 Vector1_ecd239cc1ed14f97a1905f8c5ce01744
#define _14_m17 Vector1_9871f392684d4d8f921e20c82f82a154
#define _14_m18 Vector1_84038b57e2ab496c882ca72079eb3418
#define _14_m19 Vector1_74cf11a838884a1ca1da33cc0cfb2077
#define _14_m20 Vector1_4aa82ce25dfc4718b9e16b98aa9f1bef
#define _14_m21 Vector1_08b02a5734a045829127dc604212bb0d
#define _14_m22 Vector1_f13a308ec7df400098746ab25c30f63f
#define _14_m23 Vector1_7cd3298c5f0d4a81be78e5b8a8fa137a
#define _14_m24 _ReflectionClamp


Texture2D<float4> Texture2D_a1433b49937f480db28b8cc459ef36f5;
SamplerState samplerTexture2D_a1433b49937f480db28b8cc459ef36f5;
Texture2D<float4> Texture2D_e0e9f6b982f34470a5e1d61a4e0a237f;
SamplerState samplerTexture2D_e0e9f6b982f34470a5e1d61a4e0a237f;
Texture2D<float4> Texture2D_40d1b6435c73444a8bf21e2de0eb021f;
SamplerState samplerTexture2D_40d1b6435c73444a8bf21e2de0eb021f;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
TextureCube<float4> _ReflectionCubemap;
SamplerState sampler_ReflectionCubemap;
Texture2D<float4> _WaterGrabTex;
SamplerState sampler_WaterGrabTex;
Texture2D<float4> _CameraDepthTexture;
SamplerState sampler_CameraDepthTexture;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD6;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;
static float vs_TEXCOORD7;
static float4 _723;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD7 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 vs_TEXCOORD4 : TEXCOORD6;
    float4 vs_TEXCOORD5 : TEXCOORD7;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _723 : SV_Target0;
};

static float2 _9;
static float4 _30;
static float3 _71;
static float4 _81;
static float3 _90;
static float3 _99;
static float3 _117;
static float2 _168;
static float2 _184;
static float _276;
static float _282;
static float _492;
static float3 _519;
static float _589;
static float _601;

void frag_inner()
{
    _9.x = _14_m0.y * _14_m14;
    _30 = _9.xxxx * float4(0.100000001490116119384765625f, 0.0500000007450580596923828125f, -0.07999999821186065673828125f, 0.119999997317790985107421875f);
    _9 = _9.xx * float2(0.0199999995529651641845703125f, 0.00999999977648258209228515625f);
    _9 = (vs_TEXCOORD0.xz * float2(float2(_14_m20, _14_m20))) + _9;
    _30 = (vs_TEXCOORD0.xzxz * _14_m15.xxxx) + _30;
    _71 = Texture2D_a1433b49937f480db28b8cc459ef36f5.Sample(samplerTexture2D_a1433b49937f480db28b8cc459ef36f5, _30.zw).xyz;
    float3 _87 = Texture2D_e0e9f6b982f34470a5e1d61a4e0a237f.Sample(samplerTexture2D_e0e9f6b982f34470a5e1d61a4e0a237f, _30.xy).xyz;
    _81 = float4(_87.x, _87.y, _87.z, _81.w);
    _90 = (_81.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _99 = (_71 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _114 = _99.xy * float2(float2(_14_m13, _14_m13));
    _99 = float3(_114.x, _114.y, _99.z);
    _117.z = _90.z * _99.z;
    float2 _138 = (_90.xy * float2(float2(_14_m13, _14_m13))) + _99.xy;
    _117 = float3(_138.x, _138.y, _117.z);
    _90.x = dot(_117, _117);
    _90.x = rsqrt(_90.x);
    _90 = _90.xxx * _117;
    _30.x = dot(vs_TEXCOORD1, _90);
    _30.y = dot(vs_TEXCOORD2, _90);
    _30.z = dot(vs_TEXCOORD3, _90);
    _168.x = dot(_30.xyz, _30.xyz);
    _168.x = rsqrt(_168.x);
    _99 = _30.xyz * _168.xxx;
    _184.x = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    _99 = _184.xxx * _99;
    float3 _205 = (-vs_TEXCOORD0) + _14_m1;
    _30 = float4(_205.x, _205.y, _205.z, _30.w);
    _184.x = dot(_30.xyz, _30.xyz);
    _184.x = rsqrt(_184.x);
    float3 _222 = _184.xxx * _30.xyz;
    _30 = float4(_222.x, _222.y, _222.z, _30.w);
    _168.x = dot(-_30.xyz, _99);
    _168.x += _168.x;
    _117 = (_99 * (-_168.xxx)) + (-_30.xyz);
    _168.x = dot(_99, _30.xyz);
    _168.x = clamp(_168.x, 0.0f, 1.0f);
    float2 _267 = _99.xz * float2(float2(_14_m21, _14_m21));
    _99 = float3(_267.x, _267.y, _99.z);
    _9 = (_99.xy * 0.00999999977648258209228515625f.xx) + _9;
    _276 = Texture2D_40d1b6435c73444a8bf21e2de0eb021f.Sample(samplerTexture2D_40d1b6435c73444a8bf21e2de0eb021f, _9).x;
    _282 = (-_168.x) + 1.0f;
    _184.x = (-_14_m9) + 1.0f;
    _184.x *= 6.0f;
    _81 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _117, _184.x);
    _71 = _ReflectionCubemap.SampleLevel(sampler_ReflectionCubemap, _117, _184.x).xyz;
    _168.x = _81.w + (-1.0f);
    _168.x = (_14_m4.w * _168.x) + 1.0f;
    _168.x = log2(_168.x);
    _168.x *= _14_m4.y;
    _168.x = exp2(_168.x);
    _168.x *= _14_m4.x;
    float3 _353 = (_168.xxx * _81.xyz) + _71;
    _30 = float4(_353.x, _353.y, _353.z, _30.w);
    _99 = min(_30.xyz, float3(float3(_14_m24, _14_m24, _14_m24)));
    _168 = _90.xy * _14_m22.xx;
    float2 _389 = _90.xy * float2(float2(_14_m16, _14_m16));
    _90 = float3(_389.x, _389.y, _90.z);
    _184 = _168 * vs_TEXCOORD6.xx;
    _184 *= 0.0199999995529651641845703125f.xx;
    _184 = (_90.xy * 0.5f.xx) + _184;
    _184 = (_184 * vs_TEXCOORD4.ww) + vs_TEXCOORD4.xy;
    _184 /= vs_TEXCOORD4.ww;
    float3 _425 = _WaterGrabTex.Sample(sampler_WaterGrabTex, _184).xyz;
    _30 = float4(_425.x, _425.y, _425.z, _30.w);
    _184 = vs_TEXCOORD5.xy / vs_TEXCOORD5.ww;
    _184.x = _CameraDepthTexture.Sample(sampler_CameraDepthTexture, _184).x;
    _184.x = (_14_m2.z * _184.x) + _14_m2.w;
    _184.x = 1.0f / _184.x;
    _184.x += (-vs_TEXCOORD5.w);
    _184.x = max(_184.x, 0.0f);
    _184.x = min(_184.x, 50.0f);
    _184 = (-_184.xx) * float2(_14_m7, _14_m8);
    _184 *= float2(1.44269502162933349609375f, 0.14426951110363006591796875f);
    _184 = exp2(_184);
    _184 = (-_184) + 1.0f.xx;
    _492 = _184.y * 0.5f;
    _184.x = max(_184.x, 0.0f);
    _90 = (-_14_m5.xyz) + _14_m6.xyz;
    _90 = (_184.xxx * _90) + _14_m5.xyz;
    _519 = (-_90) + _14_m6.xyz;
    _519 = (_492.xxx * _519) + _90;
    _90 = (-_30.xyz) + _519;
    _492 = (_184.x * 0.85000002384185791015625f) + 0.1500000059604644775390625f;
    _90 = (_492.xxx * _90) + _30.xyz;
    _492 = (_14_m10 * 0.85000002384185791015625f) + 0.3499999940395355224609375f;
    _99 = (_99 * _492.xxx) + (-_90);
    _492 = _282 * _282;
    _492 *= _492;
    _282 = _492 * _282;
    _282 = (_282 * 0.980000019073486328125f) + 0.0199999995529651641845703125f;
    _492 = _282 * 0.699999988079071044921875f;
    _90 = (_492.xxx * _99) + _90;
    _99 = (-_90) + 1.0f.xxx;
    _589 = _184.x + (-_14_m17);
    _184.x = log2(_184.x);
    _601 = 1.0f / _14_m18;
    _589 *= _601;
    _589 = clamp(_589, 0.0f, 1.0f);
    _601 = (_589 * (-2.0f)) + 3.0f;
    _589 *= _589;
    _492 = ((-_601) * _589) + 1.0f;
    _589 = _276 * _492;
    _492 = vs_TEXCOORD6 * _14_m23;
    _492 *= 0.00999999977648258209228515625f;
    _492 = clamp(_492, 0.0f, 1.0f);
    _9.x = _276 * _492;
    _589 = (_589 * _14_m19) + _9.x;
    _589 = clamp(_589, 0.0f, 1.0f);
    _90 = (_589.xxx * _99) + _90;
    float3 _662 = _90 + (-_14_m3.xyz);
    _30 = float4(_662.x, _662.y, _662.z, _30.w);
    _9.x = vs_TEXCOORD7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _680 = (_9.xxx * _30.xyz) + _14_m3.xyz;
    _30 = float4(_680.x, _680.y, _680.z, _30.w);
    _9.x = max(_14_m11, 0.00999999977648258209228515625f);
    _9.x = _184.x * _9.x;
    _9.x = exp2(_9.x);
    _90.x = (_9.x * _14_m12) + _589;
    _9.x = (_282 * 0.89999997615814208984375f) + _90.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _30.w = max(_9.x, 0.3499999940395355224609375f);
    _723 = _30;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._723 = _723;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _16_m2[4];
float4x4 unity_MatrixVP;
static float4 _16_m3[4];
float4 unity_FogParams;
float Vector1_da6639f1356b4847af429a09a44e9ef8;
float Vector1_f2a453661f3f4a5ba9e048487956f02d;
float Vector1_7993b655d9af4590b2e1943d549d5c36;
float4 Vector4_9cbc85c0b2da4bf9a5ef28ed25ca1aac;
void __unity_init()
{
    _16_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _16_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _16_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _16_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _16_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _16_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _16_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _16_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _16_m0 _Time
#define _16_m1 _ProjectionParams
#define _16_m4 unity_FogParams
#define _16_m5 Vector1_da6639f1356b4847af429a09a44e9ef8
#define _16_m6 Vector1_f2a453661f3f4a5ba9e048487956f02d
#define _16_m7 Vector1_7993b655d9af4590b2e1943d549d5c36
#define _16_m8 Vector4_9cbc85c0b2da4bf9a5ef28ed25ca1aac



static float4 gl_Position;
static float4 _67;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD7;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _67 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD7 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 vs_TEXCOORD4 : TEXCOORD6;
    float4 vs_TEXCOORD5 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _32;
static float4 _65;
static float _133;
static float4 _147;
static float _156;
static float _162;
static float4 _167;
static float _175;
static float3 _180;
static float2 _188;
static float2 _199;
static float3 _237;
static float3 _263;
static float _268;
static float3 _273;
static float _296;
static float3 _322;
static float2 _349;
static float3 _476;
static float3 _681;
static float3 _685;
static float _699;
static bool _731;

void vert_inner()
{
    __unity_init();
    _9 = (_16_m8 * 2.0f.xxxx) + (-1.0f).xxxx;
    _9 *= 3.141590118408203125f.xxxx;
    _32.x = cos(_9.x);
    _9.x = sin(_9.x);
    _32.z = _9.x;
    _9.x = dot(_32.xz, _32.xz);
    _9.x = rsqrt(_9.x);
    float2 _62 = _9.xx * _32.xz;
    _32 = float4(_62.x, _62.y, _32.z, _32.w);
    float3 _76 = _67.yyy * _16_m2[1].xyz;
    _65 = float4(_76.x, _76.y, _76.z, _65.w);
    float3 _88 = (_16_m2[0].xyz * _67.xxx) + _65.xyz;
    _65 = float4(_88.x, _88.y, _88.z, _65.w);
    float3 _99 = (_16_m2[2].xyz * _67.zzz) + _65.xyz;
    _65 = float4(_99.x, _99.y, _99.z, _65.w);
    float3 _111 = (_16_m2[3].xyz * _67.www) + _65.xyz;
    _65 = float4(_111.x, _111.y, _111.z, _65.w);
    _9.x = dot(_32.xy, _65.xz);
    _9.x = ((-_16_m7) * _16_m0.y) + _9.x;
    _133 = max(_16_m6, 9.9999997473787516355514526367188e-05f);
    _133 = 6.28318023681640625f / _133;
    _9.x *= _133;
    _147.x = cos(_9.x);
    _9.x = sin(_9.x);
    _156 = _16_m5 / _133;
    _162 = _147.x * _156;
    float2 _172 = _32.xy * _162.xx;
    _167 = float4(_172.x, _167.y, _172.y, _167.w);
    _175 = sin(_9.y);
    _180.x = cos(_9.y);
    _180.z = _175;
    _188.x = dot(_180.xz, _180.xz);
    _188.x = rsqrt(_188.x);
    _199 = _188.xx * _180.xz;
    _188.x = dot(_199, _65.xz);
    _188.x = ((-_16_m7) * _16_m0.y) + _188.x;
    _188.x *= _133;
    _175 = sin(_188.x);
    _180.x = cos(_188.x);
    _188.x = _156 * _180.x;
    float2 _241 = _188.xx * _199;
    _237 = float3(_241.x, _237.y, _241.y);
    _167.y = _9.x * _156;
    _237.y = _156 * _175;
    float3 _256 = _167.xyz + _237;
    _167 = float4(_256.x, _256.y, _256.z, _167.w);
    _237.x = sin(_9.z);
    _263.x = cos(_9.z);
    _268 = sin(_9.w);
    _273.x = cos(_9.w);
    _263.z = _237.x;
    _188.x = dot(_263.xz, _263.xz);
    _188.x = rsqrt(_188.x);
    _188 = _188.xx * _263.xz;
    _296 = dot(_188, _65.xz);
    _296 = ((-_16_m7) * _16_m0.y) + _296;
    _296 *= _133;
    _237.x = sin(_296);
    _263.x = cos(_296);
    _296 = _156 * _263.x;
    float2 _326 = _296.xx * _188;
    _322 = float3(_326.x, _322.y, _326.y);
    _322.y = _156 * _237.x;
    float3 _337 = _167.xyz + _322;
    _167 = float4(_337.x, _337.y, _337.z, _167.w);
    _273.z = _268;
    _296 = dot(_273.xz, _273.xz);
    _296 = rsqrt(_296);
    _349 = _296.xx * _273.xz;
    _296 = dot(_349, _65.xz);
    _296 = ((-_16_m7) * _16_m0.y) + _296;
    _296 *= _133;
    _268 = sin(_296);
    _273.x = cos(_296);
    _296 = _156 * _273.x;
    _322.y = _156 * _268;
    float2 _386 = _296.xx * _349;
    _322 = float3(_386.x, _322.y, _386.y);
    float3 _392 = _167.xyz + _322;
    _167 = float4(_392.x, _392.y, _392.z, _167.w);
    float3 _399 = _65.xyz + _167.xyz;
    _65 = float4(_399.x, _399.y, _399.z, _65.w);
    vs_TEXCOORD6 = _167.y;
    _167 = _65.yyyy * _16_m3[1];
    _167 = (_16_m3[0] * _65.xxxx) + _167;
    _167 = (_16_m3[2] * _65.zzzz) + _167;
    vs_TEXCOORD0 = _65.xyz;
    _65 = _167 + _16_m3[3];
    gl_Position = _65;
    float3 _445 = _32.xyy * (-_32.xxy);
    _167 = float4(_445.x, _445.y, _445.z, _167.w);
    _9.x *= _16_m5;
    _296 = _147.x * _16_m5;
    float2 _463 = _296.xx * _32.xy;
    _32 = float4(_463.x, _463.y, _32.z, _32.w);
    float3 _470 = _9.xxx * _167.xyz;
    _167 = float4(_470.x, _470.y, _470.z, _167.w);
    _167.w = _32.x;
    _476 = _167.xwy + float3(1.0f, 0.0f, 0.0f);
    _32 = float4(_32.x, _32.y, _167.yz.x, _167.yz.y);
    float3 _490 = _32.ywz + float3(0.0f, 1.0f, 0.0f);
    _32 = float4(_490.x, _490.y, _490.z, _32.w);
    float3 _498 = _199.xyy * (-_199.xxy);
    _167 = float4(_498.x, _498.y, _498.z, _167.w);
    _9.x = _175 * _16_m5;
    _296 = _180.x * _16_m5;
    float2 _514 = _296.xx * _199;
    _147 = float4(_514.x, _514.y, _147.z, _147.w);
    float3 _521 = _9.xxx * _167.xyz;
    _167 = float4(_521.x, _521.y, _521.z, _167.w);
    _167.w = _147.x;
    _180 = _167.xwy + _476;
    _147 = float4(_147.x, _147.y, _167.yz.x, _167.yz.y);
    float3 _539 = _32.xyz + _147.ywz;
    _32 = float4(_539.x, _539.y, _539.z, _32.w);
    float3 _547 = _188.xyy * (-_188.xxy);
    _147 = float4(_547.x, _547.y, _547.z, _147.w);
    _9.x = _237.x * _16_m5;
    _296 = _263.x * _16_m5;
    float2 _564 = _296.xx * _188;
    _167 = float4(_564.x, _564.y, _167.z, _167.w);
    float3 _571 = _9.xxx * _147.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.w = _167.x;
    float3 _580 = _9.xwy + _180;
    _147 = float4(_580.x, _580.y, _580.z, _147.w);
    _167 = float4(_167.x, _167.y, _9.yz.x, _9.yz.y);
    float3 _591 = _32.xyz + _167.ywz;
    _9 = float4(_591.x, _591.y, _591.z, _9.w);
    float3 _599 = _349.xyy * (-_349.xxy);
    _32 = float4(_599.x, _599.y, _599.z, _32.w);
    _296 = _268 * _16_m5;
    _156 = _273.x * _16_m5;
    float2 _614 = _156.xx * _349;
    _167 = float4(_614.x, _614.y, _167.z, _167.w);
    float3 _621 = _296.xxx * _32.xyz;
    _32 = float4(_621.x, _621.y, _621.z, _32.w);
    _32.w = _167.x;
    float3 _631 = _32.xwy + _147.xyz;
    _147 = float4(_631.x, _631.y, _631.z, _147.w);
    _167 = float4(_167.x, _167.y, _32.yz.x, _32.yz.y);
    float3 _642 = _9.xyz + _167.ywz;
    _9 = float4(_642.x, _642.y, _642.z, _9.w);
    float3 _649 = _147.xyz * _9.xyz;
    _32 = float4(_649.x, _649.y, _649.z, _32.w);
    float3 _660 = (_9.zxy * _147.yzx) + (-_32.xyz);
    _9 = float4(_660.x, _660.y, _660.z, _9.w);
    _296 = dot(_9.xyz, _9.xyz);
    _296 = rsqrt(_296);
    float3 _674 = _296.xxx * _9.xyz;
    _9 = float4(_674.x, _674.y, _674.z, _9.w);
    vs_TEXCOORD1.z = _9.y;
    _681 = _9.yzx * float3(0.0f, 1.0f, 0.0f);
    _685 = (_9.xyz * float3(1.0f, 0.0f, 0.0f)) + (-_681);
    _681 = ((-_9.yzx) * float3(1.0f, 0.0f, 0.0f)) + _681.zxy;
    _699 = dot(_685.xy, _685.xy);
    _699 = rsqrt(_699);
    _685 = _699.xxx * _685;
    _699 = dot(_681.xz, _681.xz);
    _699 = rsqrt(_699);
    _681 = _699.xxx * _681;
    _699 = dot(_681.xz, _681.xz);
    _699 = sqrt(_699);
    _731 = _699 < 0.00999999977648258209228515625f;
    float3 _737;
    if (_731)
    {
        _737 = _685;
    }
    else
    {
        _737 = _681;
    }
    _681 = _737;
    _685 = _9.xyz * _681;
    _685 = (_9.zxy * _681.yzx) + (-_685);
    vs_TEXCOORD1.y = _685.x;
    vs_TEXCOORD1.x = _681.z;
    _188.x = _65.z / _16_m1.y;
    _188.x = (-_188.x) + 1.0f;
    _188.x *= _16_m1.z;
    _188.x = max(_188.x, 0.0f);
    vs_TEXCOORD7 = (_188.x * _16_m4.z) + _16_m4.w;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.x = _681.x;
    vs_TEXCOORD3.x = _681.y;
    vs_TEXCOORD2.y = _685.y;
    vs_TEXCOORD3.y = _685.z;
    float2 _817 = _65.xw * 0.5f.xx;
    _9 = float4(_817.x, _9.y, _817.y, _9.w);
    float2 _828 = (_65.xy * float2(0.5f, -0.5f)) + _9.zz;
    vs_TEXCOORD4 = float4(_828.x, _828.y, vs_TEXCOORD4.z, vs_TEXCOORD4.w);
    _188.x = _65.y * _16_m1.x;
    _9.w = _188.x * 0.5f;
    float2 _846 = _9.zz + _9.xw;
    vs_TEXCOORD5 = float4(_846.x, _846.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
    vs_TEXCOORD4 = float4(vs_TEXCOORD4.x, vs_TEXCOORD4.y, _65.zw.x, _65.zw.y);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _65.zw.x, _65.zw.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _67 = stage_input._67;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ZBufferParams;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 Color_ff449a8570c14274ba55e8d07cd83774;
float4 Color_4cf6d225bd134001ab7dcea1fb58fb6e;
float Vector1_8950b44aee124c4d916556ec8c87ef3f;
float Vector1_cf55867b574a463c83ba155329dfea64;
float Vector1_6729378f81fd4ab3ac941f56ecbc0b8a;
float Vector1_fe60c19674c74223a4aca25f564af887;
float Vector1_fe7b1070c3dc4d1da621ee668cf66978;
float Vector1_aceb7f103de1435a8b3d9517a5757774;
float Vector1_e4c0786ba735455fa3d208984b11c9ad;
float Vector1_6beb98ff56f0482cb4e80757a71d9149;
float Vector1_956a889d62c14ab9bf8ca5ef37d8794c;
float Vector1_ecd239cc1ed14f97a1905f8c5ce01744;
float Vector1_9871f392684d4d8f921e20c82f82a154;
float Vector1_84038b57e2ab496c882ca72079eb3418;
float Vector1_74cf11a838884a1ca1da33cc0cfb2077;
float Vector1_4aa82ce25dfc4718b9e16b98aa9f1bef;
float Vector1_08b02a5734a045829127dc604212bb0d;
float Vector1_f13a308ec7df400098746ab25c30f63f;
float Vector1_7cd3298c5f0d4a81be78e5b8a8fa137a;
float _ReflectionClamp;
#define _14_m0 _Time
#define _14_m1 _WorldSpaceCameraPos
#define _14_m2 _ZBufferParams
#define _14_m3 unity_FogColor
#define _14_m4 unity_SpecCube0_HDR
#define _14_m5 Color_ff449a8570c14274ba55e8d07cd83774
#define _14_m6 Color_4cf6d225bd134001ab7dcea1fb58fb6e
#define _14_m7 Vector1_8950b44aee124c4d916556ec8c87ef3f
#define _14_m8 Vector1_cf55867b574a463c83ba155329dfea64
#define _14_m9 Vector1_6729378f81fd4ab3ac941f56ecbc0b8a
#define _14_m10 Vector1_fe60c19674c74223a4aca25f564af887
#define _14_m11 Vector1_fe7b1070c3dc4d1da621ee668cf66978
#define _14_m12 Vector1_aceb7f103de1435a8b3d9517a5757774
#define _14_m13 Vector1_e4c0786ba735455fa3d208984b11c9ad
#define _14_m14 Vector1_6beb98ff56f0482cb4e80757a71d9149
#define _14_m15 Vector1_956a889d62c14ab9bf8ca5ef37d8794c
#define _14_m16 Vector1_ecd239cc1ed14f97a1905f8c5ce01744
#define _14_m17 Vector1_9871f392684d4d8f921e20c82f82a154
#define _14_m18 Vector1_84038b57e2ab496c882ca72079eb3418
#define _14_m19 Vector1_74cf11a838884a1ca1da33cc0cfb2077
#define _14_m20 Vector1_4aa82ce25dfc4718b9e16b98aa9f1bef
#define _14_m21 Vector1_08b02a5734a045829127dc604212bb0d
#define _14_m22 Vector1_f13a308ec7df400098746ab25c30f63f
#define _14_m23 Vector1_7cd3298c5f0d4a81be78e5b8a8fa137a
#define _14_m24 _ReflectionClamp


Texture2D<float4> Texture2D_a1433b49937f480db28b8cc459ef36f5;
SamplerState samplerTexture2D_a1433b49937f480db28b8cc459ef36f5;
Texture2D<float4> Texture2D_e0e9f6b982f34470a5e1d61a4e0a237f;
SamplerState samplerTexture2D_e0e9f6b982f34470a5e1d61a4e0a237f;
Texture2D<float4> Texture2D_40d1b6435c73444a8bf21e2de0eb021f;
SamplerState samplerTexture2D_40d1b6435c73444a8bf21e2de0eb021f;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
TextureCube<float4> _ReflectionCubemap;
SamplerState sampler_ReflectionCubemap;
Texture2D<float4> _WaterGrabTex;
SamplerState sampler_WaterGrabTex;
Texture2D<float4> _CameraDepthTexture;
SamplerState sampler_CameraDepthTexture;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD6;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;
static float vs_TEXCOORD7;
static float4 _723;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD7 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 vs_TEXCOORD4 : TEXCOORD6;
    float4 vs_TEXCOORD5 : TEXCOORD7;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _723 : SV_Target0;
};

static float2 _9;
static float4 _30;
static float3 _71;
static float4 _81;
static float3 _90;
static float3 _99;
static float3 _117;
static float2 _168;
static float2 _184;
static float _276;
static float _282;
static float _492;
static float3 _519;
static float _589;
static float _601;

void frag_inner()
{
    _9.x = _14_m0.y * _14_m14;
    _30 = _9.xxxx * float4(0.100000001490116119384765625f, 0.0500000007450580596923828125f, -0.07999999821186065673828125f, 0.119999997317790985107421875f);
    _9 = _9.xx * float2(0.0199999995529651641845703125f, 0.00999999977648258209228515625f);
    _9 = (vs_TEXCOORD0.xz * float2(float2(_14_m20, _14_m20))) + _9;
    _30 = (vs_TEXCOORD0.xzxz * _14_m15.xxxx) + _30;
    _71 = Texture2D_a1433b49937f480db28b8cc459ef36f5.Sample(samplerTexture2D_a1433b49937f480db28b8cc459ef36f5, _30.zw).xyz;
    float3 _87 = Texture2D_e0e9f6b982f34470a5e1d61a4e0a237f.Sample(samplerTexture2D_e0e9f6b982f34470a5e1d61a4e0a237f, _30.xy).xyz;
    _81 = float4(_87.x, _87.y, _87.z, _81.w);
    _90 = (_81.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _99 = (_71 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _114 = _99.xy * float2(float2(_14_m13, _14_m13));
    _99 = float3(_114.x, _114.y, _99.z);
    _117.z = _90.z * _99.z;
    float2 _138 = (_90.xy * float2(float2(_14_m13, _14_m13))) + _99.xy;
    _117 = float3(_138.x, _138.y, _117.z);
    _90.x = dot(_117, _117);
    _90.x = rsqrt(_90.x);
    _90 = _90.xxx * _117;
    _30.x = dot(vs_TEXCOORD1, _90);
    _30.y = dot(vs_TEXCOORD2, _90);
    _30.z = dot(vs_TEXCOORD3, _90);
    _168.x = dot(_30.xyz, _30.xyz);
    _168.x = rsqrt(_168.x);
    _99 = _30.xyz * _168.xxx;
    _184.x = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    _99 = _184.xxx * _99;
    float3 _205 = (-vs_TEXCOORD0) + _14_m1;
    _30 = float4(_205.x, _205.y, _205.z, _30.w);
    _184.x = dot(_30.xyz, _30.xyz);
    _184.x = rsqrt(_184.x);
    float3 _222 = _184.xxx * _30.xyz;
    _30 = float4(_222.x, _222.y, _222.z, _30.w);
    _168.x = dot(-_30.xyz, _99);
    _168.x += _168.x;
    _117 = (_99 * (-_168.xxx)) + (-_30.xyz);
    _168.x = dot(_99, _30.xyz);
    _168.x = clamp(_168.x, 0.0f, 1.0f);
    float2 _267 = _99.xz * float2(float2(_14_m21, _14_m21));
    _99 = float3(_267.x, _267.y, _99.z);
    _9 = (_99.xy * 0.00999999977648258209228515625f.xx) + _9;
    _276 = Texture2D_40d1b6435c73444a8bf21e2de0eb021f.Sample(samplerTexture2D_40d1b6435c73444a8bf21e2de0eb021f, _9).x;
    _282 = (-_168.x) + 1.0f;
    _184.x = (-_14_m9) + 1.0f;
    _184.x *= 6.0f;
    _81 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _117, _184.x);
    _71 = _ReflectionCubemap.SampleLevel(sampler_ReflectionCubemap, _117, _184.x).xyz;
    _168.x = _81.w + (-1.0f);
    _168.x = (_14_m4.w * _168.x) + 1.0f;
    _168.x = log2(_168.x);
    _168.x *= _14_m4.y;
    _168.x = exp2(_168.x);
    _168.x *= _14_m4.x;
    float3 _353 = (_168.xxx * _81.xyz) + _71;
    _30 = float4(_353.x, _353.y, _353.z, _30.w);
    _99 = min(_30.xyz, float3(float3(_14_m24, _14_m24, _14_m24)));
    _168 = _90.xy * _14_m22.xx;
    float2 _389 = _90.xy * float2(float2(_14_m16, _14_m16));
    _90 = float3(_389.x, _389.y, _90.z);
    _184 = _168 * vs_TEXCOORD6.xx;
    _184 *= 0.0199999995529651641845703125f.xx;
    _184 = (_90.xy * 0.5f.xx) + _184;
    _184 = (_184 * vs_TEXCOORD4.ww) + vs_TEXCOORD4.xy;
    _184 /= vs_TEXCOORD4.ww;
    float3 _425 = _WaterGrabTex.Sample(sampler_WaterGrabTex, _184).xyz;
    _30 = float4(_425.x, _425.y, _425.z, _30.w);
    _184 = vs_TEXCOORD5.xy / vs_TEXCOORD5.ww;
    _184.x = _CameraDepthTexture.Sample(sampler_CameraDepthTexture, _184).x;
    _184.x = (_14_m2.z * _184.x) + _14_m2.w;
    _184.x = 1.0f / _184.x;
    _184.x += (-vs_TEXCOORD5.w);
    _184.x = max(_184.x, 0.0f);
    _184.x = min(_184.x, 50.0f);
    _184 = (-_184.xx) * float2(_14_m7, _14_m8);
    _184 *= float2(1.44269502162933349609375f, 0.14426951110363006591796875f);
    _184 = exp2(_184);
    _184 = (-_184) + 1.0f.xx;
    _492 = _184.y * 0.5f;
    _184.x = max(_184.x, 0.0f);
    _90 = (-_14_m5.xyz) + _14_m6.xyz;
    _90 = (_184.xxx * _90) + _14_m5.xyz;
    _519 = (-_90) + _14_m6.xyz;
    _519 = (_492.xxx * _519) + _90;
    _90 = (-_30.xyz) + _519;
    _492 = (_184.x * 0.85000002384185791015625f) + 0.1500000059604644775390625f;
    _90 = (_492.xxx * _90) + _30.xyz;
    _492 = (_14_m10 * 0.85000002384185791015625f) + 0.3499999940395355224609375f;
    _99 = (_99 * _492.xxx) + (-_90);
    _492 = _282 * _282;
    _492 *= _492;
    _282 = _492 * _282;
    _282 = (_282 * 0.980000019073486328125f) + 0.0199999995529651641845703125f;
    _492 = _282 * 0.699999988079071044921875f;
    _90 = (_492.xxx * _99) + _90;
    _99 = (-_90) + 1.0f.xxx;
    _589 = _184.x + (-_14_m17);
    _184.x = log2(_184.x);
    _601 = 1.0f / _14_m18;
    _589 *= _601;
    _589 = clamp(_589, 0.0f, 1.0f);
    _601 = (_589 * (-2.0f)) + 3.0f;
    _589 *= _589;
    _492 = ((-_601) * _589) + 1.0f;
    _589 = _276 * _492;
    _492 = vs_TEXCOORD6 * _14_m23;
    _492 *= 0.00999999977648258209228515625f;
    _492 = clamp(_492, 0.0f, 1.0f);
    _9.x = _276 * _492;
    _589 = (_589 * _14_m19) + _9.x;
    _589 = clamp(_589, 0.0f, 1.0f);
    _90 = (_589.xxx * _99) + _90;
    float3 _662 = _90 + (-_14_m3.xyz);
    _30 = float4(_662.x, _662.y, _662.z, _30.w);
    _9.x = vs_TEXCOORD7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _680 = (_9.xxx * _30.xyz) + _14_m3.xyz;
    _30 = float4(_680.x, _680.y, _680.z, _30.w);
    _9.x = max(_14_m11, 0.00999999977648258209228515625f);
    _9.x = _184.x * _9.x;
    _9.x = exp2(_9.x);
    _90.x = (_9.x * _14_m12) + _589;
    _9.x = (_282 * 0.89999997615814208984375f) + _90.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _30.w = max(_9.x, 0.3499999940395355224609375f);
    _723 = _30;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._723 = _723;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _16_m2[4];
float4x4 unity_MatrixVP;
static float4 _16_m3[4];
float Vector1_da6639f1356b4847af429a09a44e9ef8;
float Vector1_f2a453661f3f4a5ba9e048487956f02d;
float Vector1_7993b655d9af4590b2e1943d549d5c36;
float4 Vector4_9cbc85c0b2da4bf9a5ef28ed25ca1aac;
void __unity_init()
{
    _16_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _16_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _16_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _16_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _16_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _16_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _16_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _16_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _16_m0 _Time
#define _16_m1 _ProjectionParams
#define _16_m4 Vector1_da6639f1356b4847af429a09a44e9ef8
#define _16_m5 Vector1_f2a453661f3f4a5ba9e048487956f02d
#define _16_m6 Vector1_7993b655d9af4590b2e1943d549d5c36
#define _16_m7 Vector4_9cbc85c0b2da4bf9a5ef28ed25ca1aac



static float4 gl_Position;
static float4 _67;
static float vs_TEXCOORD6;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _67 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _32;
static float4 _65;
static float _133;
static float4 _147;
static float _156;
static float _162;
static float4 _167;
static float _175;
static float3 _180;
static float2 _188;
static float2 _199;
static float3 _237;
static float3 _263;
static float _268;
static float3 _273;
static float _296;
static float3 _322;
static float2 _349;
static float3 _476;
static float3 _681;
static float3 _685;
static float _699;
static bool _731;

void vert_inner()
{
    __unity_init();
    _9 = (_16_m7 * 2.0f.xxxx) + (-1.0f).xxxx;
    _9 *= 3.141590118408203125f.xxxx;
    _32.x = cos(_9.x);
    _9.x = sin(_9.x);
    _32.z = _9.x;
    _9.x = dot(_32.xz, _32.xz);
    _9.x = rsqrt(_9.x);
    float2 _62 = _9.xx * _32.xz;
    _32 = float4(_62.x, _62.y, _32.z, _32.w);
    float3 _76 = _67.yyy * _16_m2[1].xyz;
    _65 = float4(_76.x, _76.y, _76.z, _65.w);
    float3 _88 = (_16_m2[0].xyz * _67.xxx) + _65.xyz;
    _65 = float4(_88.x, _88.y, _88.z, _65.w);
    float3 _99 = (_16_m2[2].xyz * _67.zzz) + _65.xyz;
    _65 = float4(_99.x, _99.y, _99.z, _65.w);
    float3 _111 = (_16_m2[3].xyz * _67.www) + _65.xyz;
    _65 = float4(_111.x, _111.y, _111.z, _65.w);
    _9.x = dot(_32.xy, _65.xz);
    _9.x = ((-_16_m6) * _16_m0.y) + _9.x;
    _133 = max(_16_m5, 9.9999997473787516355514526367188e-05f);
    _133 = 6.28318023681640625f / _133;
    _9.x *= _133;
    _147.x = cos(_9.x);
    _9.x = sin(_9.x);
    _156 = _16_m4 / _133;
    _162 = _147.x * _156;
    float2 _172 = _32.xy * _162.xx;
    _167 = float4(_172.x, _167.y, _172.y, _167.w);
    _175 = sin(_9.y);
    _180.x = cos(_9.y);
    _180.z = _175;
    _188.x = dot(_180.xz, _180.xz);
    _188.x = rsqrt(_188.x);
    _199 = _188.xx * _180.xz;
    _188.x = dot(_199, _65.xz);
    _188.x = ((-_16_m6) * _16_m0.y) + _188.x;
    _188.x *= _133;
    _175 = sin(_188.x);
    _180.x = cos(_188.x);
    _188.x = _156 * _180.x;
    float2 _241 = _188.xx * _199;
    _237 = float3(_241.x, _237.y, _241.y);
    _167.y = _9.x * _156;
    _237.y = _156 * _175;
    float3 _256 = _167.xyz + _237;
    _167 = float4(_256.x, _256.y, _256.z, _167.w);
    _237.x = sin(_9.z);
    _263.x = cos(_9.z);
    _268 = sin(_9.w);
    _273.x = cos(_9.w);
    _263.z = _237.x;
    _188.x = dot(_263.xz, _263.xz);
    _188.x = rsqrt(_188.x);
    _188 = _188.xx * _263.xz;
    _296 = dot(_188, _65.xz);
    _296 = ((-_16_m6) * _16_m0.y) + _296;
    _296 *= _133;
    _237.x = sin(_296);
    _263.x = cos(_296);
    _296 = _156 * _263.x;
    float2 _326 = _296.xx * _188;
    _322 = float3(_326.x, _322.y, _326.y);
    _322.y = _156 * _237.x;
    float3 _337 = _167.xyz + _322;
    _167 = float4(_337.x, _337.y, _337.z, _167.w);
    _273.z = _268;
    _296 = dot(_273.xz, _273.xz);
    _296 = rsqrt(_296);
    _349 = _296.xx * _273.xz;
    _296 = dot(_349, _65.xz);
    _296 = ((-_16_m6) * _16_m0.y) + _296;
    _296 *= _133;
    _268 = sin(_296);
    _273.x = cos(_296);
    _296 = _156 * _273.x;
    _322.y = _156 * _268;
    float2 _386 = _296.xx * _349;
    _322 = float3(_386.x, _322.y, _386.y);
    float3 _392 = _167.xyz + _322;
    _167 = float4(_392.x, _392.y, _392.z, _167.w);
    float3 _399 = _65.xyz + _167.xyz;
    _65 = float4(_399.x, _399.y, _399.z, _65.w);
    vs_TEXCOORD6 = _167.y;
    _167 = _65.yyyy * _16_m3[1];
    _167 = (_16_m3[0] * _65.xxxx) + _167;
    _167 = (_16_m3[2] * _65.zzzz) + _167;
    vs_TEXCOORD0 = _65.xyz;
    _65 = _167 + _16_m3[3];
    gl_Position = _65;
    float3 _445 = _32.xyy * (-_32.xxy);
    _167 = float4(_445.x, _445.y, _445.z, _167.w);
    _9.x *= _16_m4;
    _296 = _147.x * _16_m4;
    float2 _463 = _296.xx * _32.xy;
    _32 = float4(_463.x, _463.y, _32.z, _32.w);
    float3 _470 = _9.xxx * _167.xyz;
    _167 = float4(_470.x, _470.y, _470.z, _167.w);
    _167.w = _32.x;
    _476 = _167.xwy + float3(1.0f, 0.0f, 0.0f);
    _32 = float4(_32.x, _32.y, _167.yz.x, _167.yz.y);
    float3 _490 = _32.ywz + float3(0.0f, 1.0f, 0.0f);
    _32 = float4(_490.x, _490.y, _490.z, _32.w);
    float3 _498 = _199.xyy * (-_199.xxy);
    _167 = float4(_498.x, _498.y, _498.z, _167.w);
    _9.x = _175 * _16_m4;
    _296 = _180.x * _16_m4;
    float2 _514 = _296.xx * _199;
    _147 = float4(_514.x, _514.y, _147.z, _147.w);
    float3 _521 = _9.xxx * _167.xyz;
    _167 = float4(_521.x, _521.y, _521.z, _167.w);
    _167.w = _147.x;
    _180 = _167.xwy + _476;
    _147 = float4(_147.x, _147.y, _167.yz.x, _167.yz.y);
    float3 _539 = _32.xyz + _147.ywz;
    _32 = float4(_539.x, _539.y, _539.z, _32.w);
    float3 _547 = _188.xyy * (-_188.xxy);
    _147 = float4(_547.x, _547.y, _547.z, _147.w);
    _9.x = _237.x * _16_m4;
    _296 = _263.x * _16_m4;
    float2 _564 = _296.xx * _188;
    _167 = float4(_564.x, _564.y, _167.z, _167.w);
    float3 _571 = _9.xxx * _147.xyz;
    _9 = float4(_571.x, _571.y, _571.z, _9.w);
    _9.w = _167.x;
    float3 _580 = _9.xwy + _180;
    _147 = float4(_580.x, _580.y, _580.z, _147.w);
    _167 = float4(_167.x, _167.y, _9.yz.x, _9.yz.y);
    float3 _591 = _32.xyz + _167.ywz;
    _9 = float4(_591.x, _591.y, _591.z, _9.w);
    float3 _599 = _349.xyy * (-_349.xxy);
    _32 = float4(_599.x, _599.y, _599.z, _32.w);
    _296 = _268 * _16_m4;
    _156 = _273.x * _16_m4;
    float2 _614 = _156.xx * _349;
    _167 = float4(_614.x, _614.y, _167.z, _167.w);
    float3 _621 = _296.xxx * _32.xyz;
    _32 = float4(_621.x, _621.y, _621.z, _32.w);
    _32.w = _167.x;
    float3 _631 = _32.xwy + _147.xyz;
    _147 = float4(_631.x, _631.y, _631.z, _147.w);
    _167 = float4(_167.x, _167.y, _32.yz.x, _32.yz.y);
    float3 _642 = _9.xyz + _167.ywz;
    _9 = float4(_642.x, _642.y, _642.z, _9.w);
    float3 _649 = _147.xyz * _9.xyz;
    _32 = float4(_649.x, _649.y, _649.z, _32.w);
    float3 _660 = (_9.zxy * _147.yzx) + (-_32.xyz);
    _9 = float4(_660.x, _660.y, _660.z, _9.w);
    _296 = dot(_9.xyz, _9.xyz);
    _296 = rsqrt(_296);
    float3 _674 = _296.xxx * _9.xyz;
    _9 = float4(_674.x, _674.y, _674.z, _9.w);
    vs_TEXCOORD1.z = _9.y;
    _681 = _9.yzx * float3(0.0f, 1.0f, 0.0f);
    _685 = (_9.xyz * float3(1.0f, 0.0f, 0.0f)) + (-_681);
    _681 = ((-_9.yzx) * float3(1.0f, 0.0f, 0.0f)) + _681.zxy;
    _699 = dot(_685.xy, _685.xy);
    _699 = rsqrt(_699);
    _685 = _699.xxx * _685;
    _699 = dot(_681.xz, _681.xz);
    _699 = rsqrt(_699);
    _681 = _699.xxx * _681;
    _699 = dot(_681.xz, _681.xz);
    _699 = sqrt(_699);
    _731 = _699 < 0.00999999977648258209228515625f;
    float3 _737;
    if (_731)
    {
        _737 = _685;
    }
    else
    {
        _737 = _681;
    }
    _681 = _737;
    _685 = _9.xyz * _681;
    _685 = (_9.zxy * _681.yzx) + (-_685);
    vs_TEXCOORD1.y = _685.x;
    vs_TEXCOORD1.x = _681.z;
    vs_TEXCOORD2.z = _9.z;
    vs_TEXCOORD3.z = _9.x;
    vs_TEXCOORD2.x = _681.x;
    vs_TEXCOORD3.x = _681.y;
    vs_TEXCOORD2.y = _685.y;
    vs_TEXCOORD3.y = _685.z;
    float2 _786 = _65.xw * 0.5f.xx;
    _9 = float4(_786.x, _9.y, _786.y, _9.w);
    float2 _797 = (_65.xy * float2(0.5f, -0.5f)) + _9.zz;
    vs_TEXCOORD4 = float4(_797.x, _797.y, vs_TEXCOORD4.z, vs_TEXCOORD4.w);
    _188.x = _65.y * _16_m1.x;
    _9.w = _188.x * 0.5f;
    float2 _815 = _9.zz + _9.xw;
    vs_TEXCOORD5 = float4(_815.x, _815.y, vs_TEXCOORD5.z, vs_TEXCOORD5.w);
    vs_TEXCOORD4 = float4(vs_TEXCOORD4.x, vs_TEXCOORD4.y, _65.zw.x, _65.zw.y);
    vs_TEXCOORD5 = float4(vs_TEXCOORD5.x, vs_TEXCOORD5.y, _65.zw.x, _65.zw.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _67 = stage_input._67;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ZBufferParams;
float4 unity_SpecCube0_HDR;
float4 Color_ff449a8570c14274ba55e8d07cd83774;
float4 Color_4cf6d225bd134001ab7dcea1fb58fb6e;
float Vector1_8950b44aee124c4d916556ec8c87ef3f;
float Vector1_cf55867b574a463c83ba155329dfea64;
float Vector1_6729378f81fd4ab3ac941f56ecbc0b8a;
float Vector1_fe60c19674c74223a4aca25f564af887;
float Vector1_fe7b1070c3dc4d1da621ee668cf66978;
float Vector1_aceb7f103de1435a8b3d9517a5757774;
float Vector1_e4c0786ba735455fa3d208984b11c9ad;
float Vector1_6beb98ff56f0482cb4e80757a71d9149;
float Vector1_956a889d62c14ab9bf8ca5ef37d8794c;
float Vector1_ecd239cc1ed14f97a1905f8c5ce01744;
float Vector1_9871f392684d4d8f921e20c82f82a154;
float Vector1_84038b57e2ab496c882ca72079eb3418;
float Vector1_74cf11a838884a1ca1da33cc0cfb2077;
float Vector1_4aa82ce25dfc4718b9e16b98aa9f1bef;
float Vector1_08b02a5734a045829127dc604212bb0d;
float Vector1_f13a308ec7df400098746ab25c30f63f;
float Vector1_7cd3298c5f0d4a81be78e5b8a8fa137a;
float _ReflectionClamp;
#define _14_m0 _Time
#define _14_m1 _WorldSpaceCameraPos
#define _14_m2 _ZBufferParams
#define _14_m3 unity_SpecCube0_HDR
#define _14_m4 Color_ff449a8570c14274ba55e8d07cd83774
#define _14_m5 Color_4cf6d225bd134001ab7dcea1fb58fb6e
#define _14_m6 Vector1_8950b44aee124c4d916556ec8c87ef3f
#define _14_m7 Vector1_cf55867b574a463c83ba155329dfea64
#define _14_m8 Vector1_6729378f81fd4ab3ac941f56ecbc0b8a
#define _14_m9 Vector1_fe60c19674c74223a4aca25f564af887
#define _14_m10 Vector1_fe7b1070c3dc4d1da621ee668cf66978
#define _14_m11 Vector1_aceb7f103de1435a8b3d9517a5757774
#define _14_m12 Vector1_e4c0786ba735455fa3d208984b11c9ad
#define _14_m13 Vector1_6beb98ff56f0482cb4e80757a71d9149
#define _14_m14 Vector1_956a889d62c14ab9bf8ca5ef37d8794c
#define _14_m15 Vector1_ecd239cc1ed14f97a1905f8c5ce01744
#define _14_m16 Vector1_9871f392684d4d8f921e20c82f82a154
#define _14_m17 Vector1_84038b57e2ab496c882ca72079eb3418
#define _14_m18 Vector1_74cf11a838884a1ca1da33cc0cfb2077
#define _14_m19 Vector1_4aa82ce25dfc4718b9e16b98aa9f1bef
#define _14_m20 Vector1_08b02a5734a045829127dc604212bb0d
#define _14_m21 Vector1_f13a308ec7df400098746ab25c30f63f
#define _14_m22 Vector1_7cd3298c5f0d4a81be78e5b8a8fa137a
#define _14_m23 _ReflectionClamp


Texture2D<float4> Texture2D_a1433b49937f480db28b8cc459ef36f5;
SamplerState samplerTexture2D_a1433b49937f480db28b8cc459ef36f5;
Texture2D<float4> Texture2D_e0e9f6b982f34470a5e1d61a4e0a237f;
SamplerState samplerTexture2D_e0e9f6b982f34470a5e1d61a4e0a237f;
Texture2D<float4> Texture2D_40d1b6435c73444a8bf21e2de0eb021f;
SamplerState samplerTexture2D_40d1b6435c73444a8bf21e2de0eb021f;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
TextureCube<float4> _ReflectionCubemap;
SamplerState sampler_ReflectionCubemap;
Texture2D<float4> _WaterGrabTex;
SamplerState sampler_WaterGrabTex;
Texture2D<float4> _CameraDepthTexture;
SamplerState sampler_CameraDepthTexture;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD6;
static float4 vs_TEXCOORD4;
static float4 vs_TEXCOORD5;
static float4 _651;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD6 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD4 : TEXCOORD5;
    float4 vs_TEXCOORD5 : TEXCOORD6;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _651 : SV_Target0;
};

static float2 _9;
static float4 _30;
static float3 _71;
static float4 _81;
static float3 _90;
static float3 _99;
static float3 _117;
static float2 _168;
static float2 _184;
static float _276;
static float _282;
static float _492;
static float3 _519;
static float _589;
static float _601;

void frag_inner()
{
    _9.x = _14_m0.y * _14_m13;
    _30 = _9.xxxx * float4(0.100000001490116119384765625f, 0.0500000007450580596923828125f, -0.07999999821186065673828125f, 0.119999997317790985107421875f);
    _9 = _9.xx * float2(0.0199999995529651641845703125f, 0.00999999977648258209228515625f);
    _9 = (vs_TEXCOORD0.xz * float2(float2(_14_m19, _14_m19))) + _9;
    _30 = (vs_TEXCOORD0.xzxz * _14_m14.xxxx) + _30;
    _71 = Texture2D_a1433b49937f480db28b8cc459ef36f5.Sample(samplerTexture2D_a1433b49937f480db28b8cc459ef36f5, _30.zw).xyz;
    float3 _87 = Texture2D_e0e9f6b982f34470a5e1d61a4e0a237f.Sample(samplerTexture2D_e0e9f6b982f34470a5e1d61a4e0a237f, _30.xy).xyz;
    _81 = float4(_87.x, _87.y, _87.z, _81.w);
    _90 = (_81.xyz * 2.0f.xxx) + (-1.0f).xxx;
    _99 = (_71 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _114 = _99.xy * float2(float2(_14_m12, _14_m12));
    _99 = float3(_114.x, _114.y, _99.z);
    _117.z = _90.z * _99.z;
    float2 _138 = (_90.xy * float2(float2(_14_m12, _14_m12))) + _99.xy;
    _117 = float3(_138.x, _138.y, _117.z);
    _90.x = dot(_117, _117);
    _90.x = rsqrt(_90.x);
    _90 = _90.xxx * _117;
    _30.x = dot(vs_TEXCOORD1, _90);
    _30.y = dot(vs_TEXCOORD2, _90);
    _30.z = dot(vs_TEXCOORD3, _90);
    _168.x = dot(_30.xyz, _30.xyz);
    _168.x = rsqrt(_168.x);
    _99 = _30.xyz * _168.xxx;
    _184.x = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    _99 = _184.xxx * _99;
    float3 _205 = (-vs_TEXCOORD0) + _14_m1;
    _30 = float4(_205.x, _205.y, _205.z, _30.w);
    _184.x = dot(_30.xyz, _30.xyz);
    _184.x = rsqrt(_184.x);
    float3 _222 = _184.xxx * _30.xyz;
    _30 = float4(_222.x, _222.y, _222.z, _30.w);
    _168.x = dot(-_30.xyz, _99);
    _168.x += _168.x;
    _117 = (_99 * (-_168.xxx)) + (-_30.xyz);
    _168.x = dot(_99, _30.xyz);
    _168.x = clamp(_168.x, 0.0f, 1.0f);
    float2 _267 = _99.xz * float2(float2(_14_m20, _14_m20));
    _99 = float3(_267.x, _267.y, _99.z);
    _9 = (_99.xy * 0.00999999977648258209228515625f.xx) + _9;
    _276 = Texture2D_40d1b6435c73444a8bf21e2de0eb021f.Sample(samplerTexture2D_40d1b6435c73444a8bf21e2de0eb021f, _9).x;
    _282 = (-_168.x) + 1.0f;
    _184.x = (-_14_m8) + 1.0f;
    _184.x *= 6.0f;
    _81 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _117, _184.x);
    _71 = _ReflectionCubemap.SampleLevel(sampler_ReflectionCubemap, _117, _184.x).xyz;
    _168.x = _81.w + (-1.0f);
    _168.x = (_14_m3.w * _168.x) + 1.0f;
    _168.x = log2(_168.x);
    _168.x *= _14_m3.y;
    _168.x = exp2(_168.x);
    _168.x *= _14_m3.x;
    float3 _353 = (_168.xxx * _81.xyz) + _71;
    _30 = float4(_353.x, _353.y, _353.z, _30.w);
    _99 = min(_30.xyz, float3(float3(_14_m23, _14_m23, _14_m23)));
    _168 = _90.xy * _14_m21.xx;
    float2 _389 = _90.xy * float2(float2(_14_m15, _14_m15));
    _90 = float3(_389.x, _389.y, _90.z);
    _184 = _168 * vs_TEXCOORD6.xx;
    _184 *= 0.0199999995529651641845703125f.xx;
    _184 = (_90.xy * 0.5f.xx) + _184;
    _184 = (_184 * vs_TEXCOORD4.ww) + vs_TEXCOORD4.xy;
    _184 /= vs_TEXCOORD4.ww;
    float3 _425 = _WaterGrabTex.Sample(sampler_WaterGrabTex, _184).xyz;
    _30 = float4(_425.x, _425.y, _425.z, _30.w);
    _184 = vs_TEXCOORD5.xy / vs_TEXCOORD5.ww;
    _184.x = _CameraDepthTexture.Sample(sampler_CameraDepthTexture, _184).x;
    _184.x = (_14_m2.z * _184.x) + _14_m2.w;
    _184.x = 1.0f / _184.x;
    _184.x += (-vs_TEXCOORD5.w);
    _184.x = max(_184.x, 0.0f);
    _184.x = min(_184.x, 50.0f);
    _184 = (-_184.xx) * float2(_14_m6, _14_m7);
    _184 *= float2(1.44269502162933349609375f, 0.14426951110363006591796875f);
    _184 = exp2(_184);
    _184 = (-_184) + 1.0f.xx;
    _492 = _184.y * 0.5f;
    _184.x = max(_184.x, 0.0f);
    _90 = (-_14_m4.xyz) + _14_m5.xyz;
    _90 = (_184.xxx * _90) + _14_m4.xyz;
    _519 = (-_90) + _14_m5.xyz;
    _519 = (_492.xxx * _519) + _90;
    _90 = (-_30.xyz) + _519;
    _492 = (_184.x * 0.85000002384185791015625f) + 0.1500000059604644775390625f;
    _90 = (_492.xxx * _90) + _30.xyz;
    _492 = (_14_m9 * 0.85000002384185791015625f) + 0.3499999940395355224609375f;
    _99 = (_99 * _492.xxx) + (-_90);
    _492 = _282 * _282;
    _492 *= _492;
    _282 = _492 * _282;
    _282 = (_282 * 0.980000019073486328125f) + 0.0199999995529651641845703125f;
    _492 = _282 * 0.699999988079071044921875f;
    _90 = (_492.xxx * _99) + _90;
    _99 = (-_90) + 1.0f.xxx;
    _589 = _184.x + (-_14_m16);
    _184.x = log2(_184.x);
    _601 = 1.0f / _14_m17;
    _589 *= _601;
    _589 = clamp(_589, 0.0f, 1.0f);
    _601 = (_589 * (-2.0f)) + 3.0f;
    _589 *= _589;
    _492 = ((-_601) * _589) + 1.0f;
    _589 = _276 * _492;
    _492 = vs_TEXCOORD6 * _14_m22;
    _492 *= 0.00999999977648258209228515625f;
    _492 = clamp(_492, 0.0f, 1.0f);
    _9.x = _276 * _492;
    _589 = (_589 * _14_m18) + _9.x;
    _589 = clamp(_589, 0.0f, 1.0f);
    float3 _657 = (_589.xxx * _99) + _90;
    _651 = float4(_657.x, _657.y, _657.z, _651.w);
    _9.x = max(_14_m10, 0.00999999977648258209228515625f);
    _9.x = _184.x * _9.x;
    _9.x = exp2(_9.x);
    _90.x = (_9.x * _14_m11) + _589;
    _9.x = (_282 * 0.89999997615814208984375f) + _90.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = max(_9.x, 0.3499999940395355224609375f);
    _651.w = _9.x;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._651 = _651;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Transparent/Diffuse"
}