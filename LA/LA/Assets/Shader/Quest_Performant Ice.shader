// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Quest/Performant Ice" {
Properties {

_MainTex ("Base Texture", 2D) = "white" { }

_Color ("Ice Tint", Color) = (0.8,0.9,1,0.7)

[Header(Surface Detail)] _NormalMap ("Normal Map", 2D) = "bump" { }

_NormalStrength ("Normal Strength", Range(0, 2)) = 1.0

_BumpScale ("Bump Scale", Range(0, 1)) = 0.30000001192092896

[Header(Refraction)] _RefractionStrength ("Refraction Strength", Range(0, 0.5)) = 0.10000000149011612

_IceDepth ("Ice Depth (Fake Thickness)", Range(0, 2)) = 0.5

_RefractionDistortion ("Distortion Amount", Range(0, 1)) = 0.30000001192092896

[Header(Fresnel and Transparency)] _FresnelPower ("Fresnel Power", Range(0.1, 10)) = 3.0

_FresnelIntensity ("Fresnel Intensity", Range(0, 2)) = 0.800000011920929

_FresnelColor ("Fresnel Color", Color) = (0.7,0.85,1,1)

_Alpha ("Base Alpha", Range(0, 1)) = 0.8500000238418579

[Header(Specular)] _Glossiness ("Smoothness", Range(0, 1)) = 0.8999999761581421

_SpecColor ("Specular Color", Color) = (1,1,1,1)

_SpecularPower ("Specular Power", Range(1, 128)) = 64.0

[Header(Internal Scattering)] _ScatterColor ("Scatter Color", Color) = (0.6,0.8,1,1)

_ScatterStrength ("Scatter Strength", Range(0, 2)) = 0.5

[Header(Environment)] _ReflectionCube ("Reflection Cubemap", Cube) = "" { }

_ReflectionStrength ("Reflection Strength", Range(0, 1)) = 0.30000001192092896

}
SubShader {
 LOD 300
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 GrabPass {
 "_BackgroundTexture"
}
 Pass {
Cull Back
 Name "ICE_MAIN"
  LOD 300
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
 ZWrite Off
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile __ DIRECTIONAL
#pragma multi_compile __ DIRLIGHTMAP_COMBINED
#pragma multi_compile __ LIGHTMAP_ON
#pragma multi_compile __ LIGHTPROBE_SH
#pragma multi_compile __ SHADOWS_SCREEN
#pragma multi_compile __ VERTEXLIGHT_ON
#if defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP) && defined(LIGHTMAP_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP2) && defined(LIGHTMAP_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTMAP_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTMAP_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(SHADOWS_SCREEN)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(VERTEXLIGHT_ON)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _177;
static float3 vs_TEXCOORD3;
static float4 _214;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _177 : NORMAL;
    float4 _214 : TANGENT;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _263;

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
    vs_TEXCOORD7 = exp2(-_99);
    vs_TEXCOORD0 = (_132 * _22_m6.xy) + _22_m6.zw;
    float3 _148 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_148.x, _148.y, _148.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _160 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_160.x, _160.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _173 = (-_9.xyz) + _22_m0;
    _9 = float4(_173.x, _173.y, _173.z, _9.w);
    _45.x = dot(_177, _22_m3[0].xyz);
    _45.y = dot(_177, _22_m3[1].xyz);
    _45.z = dot(_177, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _208 = _99.xxx * _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _220 = _214.yyy * _22_m2[1].xyz;
    _62 = float4(_220.x, _220.y, _220.z, _62.w);
    float3 _231 = (_22_m2[0].xyz * _214.xxx) + _62.xyz;
    _62 = float4(_231.x, _231.y, _231.z, _62.w);
    float3 _242 = (_22_m2[2].xyz * _214.zzz) + _62.xyz;
    _62 = float4(_242.x, _242.y, _242.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _256 = _99.xxx * _62.xyz;
    _62 = float4(_256.x, _256.y, _256.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _263 = _45.zxy * _62.yzx;
    float3 _276 = (_45.yzx * _62.zxy) + (-_263);
    _45 = float4(_276.x, _276.y, _276.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _214.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _177 = stage_input._177;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _136;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _181;
static float3 vs_TEXCOORD3;
static float4 _217;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _181 : NORMAL;
    float4 _217 : TANGENT;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _266;

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
    vs_TEXCOORD7 = exp2(_99);
    vs_TEXCOORD0 = (_136 * _22_m6.xy) + _22_m6.zw;
    float3 _152 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_152.x, _152.y, _152.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _164 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_164.x, _164.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _177 = (-_9.xyz) + _22_m0;
    _9 = float4(_177.x, _177.y, _177.z, _9.w);
    _45.x = dot(_181, _22_m3[0].xyz);
    _45.y = dot(_181, _22_m3[1].xyz);
    _45.z = dot(_181, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _211 = _99.xxx * _45.xyz;
    _45 = float4(_211.x, _211.y, _211.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _223 = _217.yyy * _22_m2[1].xyz;
    _62 = float4(_223.x, _223.y, _223.z, _62.w);
    float3 _234 = (_22_m2[0].xyz * _217.xxx) + _62.xyz;
    _62 = float4(_234.x, _234.y, _234.z, _62.w);
    float3 _245 = (_22_m2[2].xyz * _217.zzz) + _62.xyz;
    _62 = float4(_245.x, _245.y, _245.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _259 = _99.xxx * _62.xyz;
    _62 = float4(_259.x, _259.y, _259.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _266 = _45.zxy * _62.yzx;
    float3 _279 = (_45.yzx * _62.zxy) + (-_266);
    _45 = float4(_279.x, _279.y, _279.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _217.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _181 = stage_input._181;
    _217 = stage_input._217;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR)
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
float4 _MainTex_ST;
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
#define _22_m6 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD7;
static float2 vs_TEXCOORD0;
static float2 _133;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _178;
static float3 vs_TEXCOORD3;
static float4 _215;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _178 : NORMAL;
    float4 _215 : TANGENT;
    float2 _133 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
    float3 vs_TEXCOORD2 : TEXCOORD7;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _99;
static float3 _264;

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
    vs_TEXCOORD7 = (_99 * _22_m5.z) + _22_m5.w;
    vs_TEXCOORD0 = (_133 * _22_m6.xy) + _22_m6.zw;
    float3 _149 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_149.x, _149.y, _149.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _161 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_161.x, _161.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _174 = (-_9.xyz) + _22_m0;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    _45.x = dot(_178, _22_m3[0].xyz);
    _45.y = dot(_178, _22_m3[1].xyz);
    _45.z = dot(_178, _22_m3[2].xyz);
    _99 = dot(_45.xyz, _45.xyz);
    _99 = rsqrt(_99);
    float3 _209 = _99.xxx * _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _221 = _215.yyy * _22_m2[1].xyz;
    _62 = float4(_221.x, _221.y, _221.z, _62.w);
    float3 _232 = (_22_m2[0].xyz * _215.xxx) + _62.xyz;
    _62 = float4(_232.x, _232.y, _232.z, _62.w);
    float3 _243 = (_22_m2[2].xyz * _215.zzz) + _62.xyz;
    _62 = float4(_243.x, _243.y, _243.z, _62.w);
    _99 = dot(_62.xyz, _62.xyz);
    _99 = rsqrt(_99);
    float3 _257 = _99.xxx * _62.xyz;
    _62 = float4(_257.x, _257.y, _257.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _264 = _45.zxy * _62.yzx;
    float3 _277 = (_45.yzx * _62.zxy) + (-_264);
    _45 = float4(_277.x, _277.y, _277.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _215.www;
    _99 = dot(_9.xyz, _9.xyz);
    _99 = rsqrt(_99);
    vs_TEXCOORD6 = _99.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _178 = stage_input._178;
    _215 = stage_input._215;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD7 = vs_TEXCOORD7;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 unity_FogColor
#define _16_m2 _LightColor0
#define _16_m3 _SpecColor
#define _16_m4 _NormalMap_ST
#define _16_m5 _Color
#define _16_m6 _NormalStrength
#define _16_m7 _RefractionStrength
#define _16_m8 _IceDepth
#define _16_m9 _RefractionDistortion
#define _16_m10 _FresnelPower
#define _16_m11 _FresnelIntensity
#define _16_m12 _FresnelColor
#define _16_m13 _Alpha
#define _16_m14 _Glossiness
#define _16_m15 _SpecularPower
#define _16_m16 _ScatterColor
#define _16_m17 _ScatterStrength
#define _16_m18 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD7;
static float4 _414;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD7 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD6 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _414 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m16.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m4.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m6.xxxx;
    _89 = _49 * float4(_16_m7, _16_m7, _16_m8, _16_m8);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m9.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m5.xyz) + (-_89.xyz);
    _163 = _16_m8 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m17.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m15;
    _163 = exp2(_163);
    _163 *= _16_m14;
    _257 = _16_m2.xyz * _16_m3.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m10;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m18, _16_m18, _16_m18));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m12.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m11;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m13;
    _9 = (_362.xxx * _49.xyz) + _331;
    _9 += (-_16_m1.xyz);
    _163 = vs_TEXCOORD7;
    _163 = clamp(_163, 0.0f, 1.0f);
    float3 _410 = (_163.xxx * _9) + _16_m1.xyz;
    _375 = float4(_410.x, _410.y, _410.z, _375.w);
    _414 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD7 = stage_input.vs_TEXCOORD7;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._414 = _414;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
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
float4 _MainTex_ST;
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
#define _22_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 _146;
static float3 vs_TEXCOORD3;
static float4 _186;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD6;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
    float4 _186 : TANGENT;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _168;
static float3 _235;

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
    _45 = (_22_m3[3] * _45.wwww) + _62;
    gl_Position = _45;
    vs_TEXCOORD0 = (_101 * _22_m4.xy) + _22_m4.zw;
    float3 _117 = _45.xwy * float3(0.5f, 0.5f, -0.5f);
    _62 = float4(_117.x, _117.y, _117.z, _62.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _45.zw.x, _45.zw.y);
    float2 _129 = _62.yy + _62.xz;
    vs_TEXCOORD1 = float4(_129.x, _129.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD2 = _9.xyz;
    float3 _142 = (-_9.xyz) + _22_m0;
    _9 = float4(_142.x, _142.y, _142.z, _9.w);
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _168 = dot(_45.xyz, _45.xyz);
    _168 = rsqrt(_168);
    float3 _180 = _168.xxx * _45.xyz;
    _45 = float4(_180.x, _180.y, _180.z, _45.w);
    vs_TEXCOORD3 = _45.xyz;
    float3 _192 = _186.yyy * _22_m1[1].xyz;
    _62 = float4(_192.x, _192.y, _192.z, _62.w);
    float3 _203 = (_22_m1[0].xyz * _186.xxx) + _62.xyz;
    _62 = float4(_203.x, _203.y, _203.z, _62.w);
    float3 _214 = (_22_m1[2].xyz * _186.zzz) + _62.xyz;
    _62 = float4(_214.x, _214.y, _214.z, _62.w);
    _168 = dot(_62.xyz, _62.xyz);
    _168 = rsqrt(_168);
    float3 _228 = _168.xxx * _62.xyz;
    _62 = float4(_228.x, _228.y, _228.z, _62.w);
    vs_TEXCOORD4 = _62.xyz;
    _235 = _45.zxy * _62.yzx;
    float3 _248 = (_45.yzx * _62.zxy) + (-_235);
    _45 = float4(_248.x, _248.y, _248.z, _45.w);
    vs_TEXCOORD5 = _45.xyz * _186.www;
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD6 = _168.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _146 = stage_input._146;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD6 = vs_TEXCOORD6;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _SpecColor;
float4 _NormalMap_ST;
float4 _Color;
float _NormalStrength;
float _RefractionStrength;
float _IceDepth;
float _RefractionDistortion;
float _FresnelPower;
float _FresnelIntensity;
float4 _FresnelColor;
float _Alpha;
float _Glossiness;
float _SpecularPower;
float4 _ScatterColor;
float _ScatterStrength;
float _ReflectionStrength;
#define _16_m0 _WorldSpaceLightPos0
#define _16_m1 _LightColor0
#define _16_m2 _SpecColor
#define _16_m3 _NormalMap_ST
#define _16_m4 _Color
#define _16_m5 _NormalStrength
#define _16_m6 _RefractionStrength
#define _16_m7 _IceDepth
#define _16_m8 _RefractionDistortion
#define _16_m9 _FresnelPower
#define _16_m10 _FresnelIntensity
#define _16_m11 _FresnelColor
#define _16_m12 _Alpha
#define _16_m13 _Glossiness
#define _16_m14 _SpecularPower
#define _16_m15 _ScatterColor
#define _16_m16 _ScatterStrength
#define _16_m17 _ReflectionStrength


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
Texture2D<float4> _BackgroundTexture;
SamplerState sampler_BackgroundTexture;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
TextureCube<float4> _ReflectionCube;
SamplerState sampler_ReflectionCube;

static float3 vs_TEXCOORD6;
static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 _394;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD6 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _394 : SV_Target0;
};

static float3 _9;
static float4 _49;
static float3 _61;
static float4 _71;
static float4 _89;
static float3 _146;
static float3 _152;
static float _163;
static float3 _257;
static float3 _321;
static float3 _331;
static float _362;
static float4 _375;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD6, -_16_m0.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9 = _9.xxx * _16_m15.xyz;
    float2 _58 = vs_TEXCOORD0 * _16_m3.xy;
    _49 = float4(_58.x, _58.y, _49.z, _49.w);
    _61 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _49.xy)).xyz;
    float3 _78 = (_61 * 2.0f.xxx) + (-1.0f).xxx;
    _71 = float4(_78.x, _78.y, _78.z, _71.w);
    _49 = _71.xyxy * _16_m5.xxxx;
    _89 = _49 * float4(_16_m6, _16_m6, _16_m7, _16_m7);
    float2 _107 = _89.zw * 0.0199999995529651641845703125f.xx;
    _49 = float4(_107.x, _107.y, _49.z, _49.w);
    float2 _119 = (_89.xy * _16_m8.xx) + _49.xy;
    _49 = float4(_119.x, _119.y, _49.z, _49.w);
    float2 _128 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _89 = float4(_128.x, _128.y, _89.z, _89.w);
    float2 _135 = _49.xy + _89.xy;
    _49 = float4(_135.x, _135.y, _49.z, _49.w);
    float3 _143 = _BackgroundTexture.Sample(sampler_BackgroundTexture, _49.xy).xyz;
    _89 = float4(_143.x, _143.y, _143.z, _89.w);
    _146 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _152 = (_146 * _16_m4.xyz) + (-_89.xyz);
    _163 = _16_m7 * 0.300000011920928955078125f;
    float3 _174 = (_163.xxx * _152) + _89.xyz;
    _89 = float4(_174.x, _174.y, _174.z, _89.w);
    float3 _185 = (_9 * _16_m16.xxx) + _89.xyz;
    _71 = float4(_185.x, _185.y, _71.z, _185.z);
    _9 = _49.www * vs_TEXCOORD5;
    _9 = (_49.zzz * vs_TEXCOORD4) + _9;
    _9 = (_71.zzz * vs_TEXCOORD3) + _9;
    _163 = dot(_9, _9);
    _163 = rsqrt(_163);
    _9 = _163.xxx * _9;
    float3 _220 = vs_TEXCOORD6 + _16_m0.xyz;
    _49 = float4(_220.x, _220.y, _220.z, _49.w);
    _163 = dot(_49.xyz, _49.xyz);
    _163 = rsqrt(_163);
    float3 _234 = _163.xxx * _49.xyz;
    _49 = float4(_234.x, _234.y, _234.z, _49.w);
    _163 = dot(_9, _49.xyz);
    _163 = clamp(_163, 0.0f, 1.0f);
    _163 = log2(_163);
    _163 *= _16_m14;
    _163 = exp2(_163);
    _163 *= _16_m13;
    _257 = _16_m1.xyz * _16_m2.xyz;
    float3 _273 = (_257 * _163.xxx) + _71.xyw;
    _71 = float4(_273.x, _273.y, _273.z, _71.w);
    _163 = dot(-vs_TEXCOORD6, _9);
    _163 += _163;
    float3 _290 = (_9 * (-_163.xxx)) + (-vs_TEXCOORD6);
    _49 = float4(_290.x, _290.y, _290.z, _49.w);
    _9.x = dot(vs_TEXCOORD6, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _16_m9;
    _9.x = exp2(_9.x);
    _321 = _ReflectionCube.Sample(sampler_ReflectionCube, _49.xyz).xyz;
    _331 = _321 * float3(float3(_16_m17, _16_m17, _16_m17));
    _331 = (_331 * _9.xxx) + _71.xyz;
    float3 _359 = (-_331) + _16_m11.xyz;
    _49 = float4(_359.x, _359.y, _359.z, _49.w);
    _362 = _9.x * _16_m10;
    _9.x = ((-_9.x) * 0.300000011920928955078125f) + 1.0f;
    _375.w = _9.x * _16_m12;
    float3 _390 = (_362.xxx * _49.xyz) + _331;
    _375 = float4(_390.x, _390.y, _390.z, _375.w);
    _394 = _375;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD6 = stage_input.vs_TEXCOORD6;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._394 = _394;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
Cull Back
 Name "ICE_ADDITIVE"
  LOD 300
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
 ZWrite Off
   Blend One One
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag

// Normal maps are DXT5nm-packed on PC (x in alpha, y in green) but plain XYZ on Quest, where these
// shaders were compiled; unpack like Unity's UnpackNormal so both decode, then re-encode to 0..1.
float4 LA_UnpackNormalTex(float4 p) { p.x *= p.w; float2 xy = p.xy * 2.0 - 1.0; float z = sqrt(saturate(1.0 - dot(xy, xy))); return float4(xy * 0.5 + 0.5, z * 0.5 + 0.5, 1.0); }
#pragma target 4.5
#pragma multi_compile __ DIRECTIONAL
#pragma multi_compile __ DIRECTIONAL_COOKIE
#pragma multi_compile __ POINT
#pragma multi_compile __ POINT_COOKIE
#pragma multi_compile __ SHADOWS_CUBE
#pragma multi_compile __ SHADOWS_DEPTH
#pragma multi_compile __ SHADOWS_SCREEN
#pragma multi_compile __ SHADOWS_SOFT
#pragma multi_compile __ SPOT
#if defined(POINT) && defined(SHADOWS_CUBE) && defined(SHADOWS_SOFT)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _LightPositionRange;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 _NormalMap_ST;
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
#define _22_m1 _LightPositionRange
#define _22_m5 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float3 _113;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _113 : NORMAL;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _135;

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
    gl_Position = (_22_m4[3] * _45.wwww) + _62;
    vs_TEXCOORD0 = (_101 * _22_m5.xy) + _22_m5.zw;
    _45.x = dot(_113, _22_m3[0].xyz);
    _45.y = dot(_113, _22_m3[1].xyz);
    _45.z = dot(_113, _22_m3[2].xyz);
    _135 = dot(_45.xyz, _45.xyz);
    _135 = rsqrt(_135);
    vs_TEXCOORD1 = _135.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    float3 _159 = (-_9.xyz) + _22_m0;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    vs_TEXCOORD4 = _9.xyz + (-_22_m1.xyz);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD3 = _9.xxx * _45.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _113 = stage_input._113;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightProjectionParams;
float4 _LightShadowData;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _38_m0 _WorldSpaceLightPos0
#define _38_m1 _LightProjectionParams
#define _38_m2 _LightShadowData
#define _38_m3 _LightColor0
#define _38_m4 _SpecularPower
#define _38_m5 _Glossiness


TextureCube<float4> _ShadowMapTexture;
SamplerComparisonState __97_sampler;

static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 _253;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _253 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float4 _93;
static float _190;

void frag_inner()
{
    _9.x = max(abs(vs_TEXCOORD4.y), abs(vs_TEXCOORD4.x));
    _9.x = max(_9.x, abs(vs_TEXCOORD4.z));
    _9.x += (-_38_m1.z);
    _9.x = max(_9.x, 9.9999997473787516355514526367188e-06f);
    _9.x *= _38_m1.w;
    _9.x = _38_m1.y / _9.x;
    _9.x += (-_38_m1.x);
    _9.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD4 + 0.0078125f.xxx;
    float4 _84 = float4(_78, _9.x);
    _93.x = _ShadowMapTexture.SampleCmp(__97_sampler, _84.xyz, _84.w);
    _78 = vs_TEXCOORD4 + float3(-0.0078125f, -0.0078125f, 0.0078125f);
    float4 _107 = float4(_78, _9.x);
    _93.y = _ShadowMapTexture.SampleCmp(__97_sampler, _107.xyz, _107.w);
    _78 = vs_TEXCOORD4 + float3(-0.0078125f, 0.0078125f, -0.0078125f);
    float4 _123 = float4(_78, _9.x);
    _93.z = _ShadowMapTexture.SampleCmp(__97_sampler, _123.xyz, _123.w);
    _78 = vs_TEXCOORD4 + float3(0.0078125f, -0.0078125f, -0.0078125f);
    float4 _139 = float4(_78, _9.x);
    _93.w = _ShadowMapTexture.SampleCmp(__97_sampler, _139.xyz, _139.w);
    _9.x = dot(_93, 0.25f.xxxx);
    _78.x = (-_38_m2.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _38_m2.x;
    _9 = _9.xxx * _38_m3.xyz;
    float3 _187 = (-vs_TEXCOORD2) + _38_m0.xyz;
    _93 = float4(_187.x, _187.y, _187.z, _93.w);
    _190 = dot(_93.xyz, _93.xyz);
    _190 = rsqrt(_190);
    float3 _205 = (_93.xyz * _190.xxx) + vs_TEXCOORD3;
    _93 = float4(_205.x, _205.y, _205.z, _93.w);
    _190 = dot(_93.xyz, _93.xyz);
    _190 = rsqrt(_190);
    float3 _219 = _190.xxx * _93.xyz;
    _93 = float4(_219.x, _219.y, _219.z, _93.w);
    _190 = dot(vs_TEXCOORD1, _93.xyz);
    _190 = clamp(_190, 0.0f, 1.0f);
    _190 = log2(_190);
    _190 *= _38_m4;
    _190 = exp2(_190);
    _190 *= _38_m5;
    _9 = _190.xxx * _9;
    _9 *= 0.5f.xxx;
    _253 = float4(_9.x, _9.y, _9.z, _253.w);
    _253.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._253 = _253;
    return stage_output;
}

#endif
#elif defined(POINT_COOKIE) && defined(SHADOWS_CUBE) && defined(SHADOWS_SOFT)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _LightPositionRange;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 _NormalMap_ST;
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
#define _22_m1 _LightPositionRange
#define _22_m5 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float3 _113;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _113 : NORMAL;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _135;

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
    gl_Position = (_22_m4[3] * _45.wwww) + _62;
    vs_TEXCOORD0 = (_101 * _22_m5.xy) + _22_m5.zw;
    _45.x = dot(_113, _22_m3[0].xyz);
    _45.y = dot(_113, _22_m3[1].xyz);
    _45.z = dot(_113, _22_m3[2].xyz);
    _135 = dot(_45.xyz, _45.xyz);
    _135 = rsqrt(_135);
    vs_TEXCOORD1 = _135.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    float3 _159 = (-_9.xyz) + _22_m0;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    vs_TEXCOORD4 = _9.xyz + (-_22_m1.xyz);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD3 = _9.xxx * _45.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _113 = stage_input._113;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightProjectionParams;
float4 _LightShadowData;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _38_m0 _WorldSpaceLightPos0
#define _38_m1 _LightProjectionParams
#define _38_m2 _LightShadowData
#define _38_m3 _LightColor0
#define _38_m4 _SpecularPower
#define _38_m5 _Glossiness


TextureCube<float4> _ShadowMapTexture;
SamplerComparisonState __97_sampler;

static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 _253;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _253 : SV_Target0;
};

static float3 _9;
static float3 _78;
static float4 _93;
static float _190;

void frag_inner()
{
    _9.x = max(abs(vs_TEXCOORD4.y), abs(vs_TEXCOORD4.x));
    _9.x = max(_9.x, abs(vs_TEXCOORD4.z));
    _9.x += (-_38_m1.z);
    _9.x = max(_9.x, 9.9999997473787516355514526367188e-06f);
    _9.x *= _38_m1.w;
    _9.x = _38_m1.y / _9.x;
    _9.x += (-_38_m1.x);
    _9.x = (-_9.x) + 1.0f;
    _78 = vs_TEXCOORD4 + 0.0078125f.xxx;
    float4 _84 = float4(_78, _9.x);
    _93.x = _ShadowMapTexture.SampleCmp(__97_sampler, _84.xyz, _84.w);
    _78 = vs_TEXCOORD4 + float3(-0.0078125f, -0.0078125f, 0.0078125f);
    float4 _107 = float4(_78, _9.x);
    _93.y = _ShadowMapTexture.SampleCmp(__97_sampler, _107.xyz, _107.w);
    _78 = vs_TEXCOORD4 + float3(-0.0078125f, 0.0078125f, -0.0078125f);
    float4 _123 = float4(_78, _9.x);
    _93.z = _ShadowMapTexture.SampleCmp(__97_sampler, _123.xyz, _123.w);
    _78 = vs_TEXCOORD4 + float3(0.0078125f, -0.0078125f, -0.0078125f);
    float4 _139 = float4(_78, _9.x);
    _93.w = _ShadowMapTexture.SampleCmp(__97_sampler, _139.xyz, _139.w);
    _9.x = dot(_93, 0.25f.xxxx);
    _78.x = (-_38_m2.x) + 1.0f;
    _9.x = (_9.x * _78.x) + _38_m2.x;
    _9 = _9.xxx * _38_m3.xyz;
    float3 _187 = (-vs_TEXCOORD2) + _38_m0.xyz;
    _93 = float4(_187.x, _187.y, _187.z, _93.w);
    _190 = dot(_93.xyz, _93.xyz);
    _190 = rsqrt(_190);
    float3 _205 = (_93.xyz * _190.xxx) + vs_TEXCOORD3;
    _93 = float4(_205.x, _205.y, _205.z, _93.w);
    _190 = dot(_93.xyz, _93.xyz);
    _190 = rsqrt(_190);
    float3 _219 = _190.xxx * _93.xyz;
    _93 = float4(_219.x, _219.y, _219.z, _93.w);
    _190 = dot(vs_TEXCOORD1, _93.xyz);
    _190 = clamp(_190, 0.0f, 1.0f);
    _190 = log2(_190);
    _190 *= _38_m4;
    _190 = exp2(_190);
    _190 *= _38_m5;
    _9 = _190.xxx * _9;
    _9 *= 0.5f.xxx;
    _253 = float4(_9.x, _9.y, _9.z, _253.w);
    _253.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._253 = _253;
    return stage_output;
}

#endif
#elif defined(SHADOWS_DEPTH) && defined(SHADOWS_SOFT) && defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToShadow[4];
static float4 _24_m1[16];
float4x4 unity_ObjectToWorld;
static float4 _24_m2[4];
float4x4 unity_WorldToObject;
static float4 _24_m3[4];
float4x4 unity_MatrixVP;
static float4 _24_m4[4];
float4 _NormalMap_ST;
void __unity_init()
{
    _24_m1[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _24_m1[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _24_m1[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _24_m1[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _24_m1[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _24_m1[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _24_m1[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _24_m1[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _24_m1[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _24_m1[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _24_m1[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _24_m1[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _24_m1[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _24_m1[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _24_m1[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _24_m1[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _24_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _24_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _24_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _24_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _24_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _24_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _24_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _24_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _24_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _24_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _24_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _24_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _24_m0 _WorldSpaceCameraPos
#define _24_m5 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _92;
static float3 _104;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _104 : NORMAL;
    float2 _92 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float4 vs_TEXCOORD4 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _53;
static float _126;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _24_m2[1];
    _9 = (_24_m2[0] * _11.xxxx) + _9;
    _9 = (_24_m2[2] * _11.zzzz) + _9;
    _47 = _9 + _24_m2[3];
    _53 = _47.yyyy * _24_m4[1];
    _53 = (_24_m4[0] * _47.xxxx) + _53;
    _53 = (_24_m4[2] * _47.zzzz) + _53;
    gl_Position = (_24_m4[3] * _47.wwww) + _53;
    vs_TEXCOORD0 = (_92 * _24_m5.xy) + _24_m5.zw;
    _47.x = dot(_104, _24_m3[0].xyz);
    _47.y = dot(_104, _24_m3[1].xyz);
    _47.z = dot(_104, _24_m3[2].xyz);
    _126 = dot(_47.xyz, _47.xyz);
    _126 = rsqrt(_126);
    vs_TEXCOORD1 = _126.xxx * _47.xyz;
    float3 _149 = (_24_m2[3].xyz * _11.www) + _9.xyz;
    _47 = float4(_149.x, _149.y, _149.z, _47.w);
    _9 = (_24_m2[3] * _11.wwww) + _9;
    vs_TEXCOORD2 = _47.xyz;
    float3 _168 = (-_47.xyz) + _24_m0;
    _47 = float4(_168.x, _168.y, _168.z, _47.w);
    _126 = dot(_47.xyz, _47.xyz);
    _126 = rsqrt(_126);
    vs_TEXCOORD3 = _126.xxx * _47.xyz;
    _47 = _9.yyyy * _24_m1[1];
    _47 = (_24_m1[0] * _9.xxxx) + _47;
    _47 = (_24_m1[2] * _9.zzzz) + _47;
    vs_TEXCOORD4 = (_24_m1[3] * _9.wwww) + _47;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _104 = stage_input._104;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightShadowData;
float4 _LightColor0;
float4 _ShadowOffsets[4];
float _SpecularPower;
float _Glossiness;
#define _26_m0 _WorldSpaceLightPos0
#define _26_m1 _LightShadowData
#define _26_m2 _LightColor0
#define _26_m3 _ShadowOffsets
#define _26_m4 _SpecularPower
#define _26_m5 _Glossiness


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __52_sampler;

static float4 vs_TEXCOORD4;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 _217;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float4 vs_TEXCOORD4 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _217 : SV_Target0;
};

static float3 _9;
static float4 _19;
static float3 _60;
static float _124;
static float _155;

void frag_inner()
{
    _9 = vs_TEXCOORD4.xyz / vs_TEXCOORD4.www;
    float3 _34 = _9 + _26_m3[0].xyz;
    _19 = float4(_34.x, _34.y, _34.z, _19.w);
    float3 _38 = float3(_19.xy, _19.z);
    _19.x = _ShadowMapTexture.SampleCmpLevelZero(__52_sampler, _38.xy, _38.z);
    _60 = _9 + _26_m3[1].xyz;
    float3 _67 = float3(_60.xy, _60.z);
    _19.y = _ShadowMapTexture.SampleCmpLevelZero(__52_sampler, _67.xy, _67.z);
    _60 = _9 + _26_m3[2].xyz;
    _9 += _26_m3[3].xyz;
    float3 _92 = float3(_9.xy, _9.z);
    _19.w = _ShadowMapTexture.SampleCmpLevelZero(__52_sampler, _92.xy, _92.z);
    float3 _106 = float3(_60.xy, _60.z);
    _19.z = _ShadowMapTexture.SampleCmpLevelZero(__52_sampler, _106.xy, _106.z);
    _9.x = dot(_19, 0.25f.xxxx);
    _124 = (-_26_m1.x) + 1.0f;
    _9.x = (_9.x * _124) + _26_m1.x;
    _9 = _9.xxx * _26_m2.xyz;
    float3 _152 = (-vs_TEXCOORD2) + _26_m0.xyz;
    _19 = float4(_152.x, _152.y, _152.z, _19.w);
    _155 = dot(_19.xyz, _19.xyz);
    _155 = rsqrt(_155);
    float3 _170 = (_19.xyz * _155.xxx) + vs_TEXCOORD3;
    _19 = float4(_170.x, _170.y, _170.z, _19.w);
    _155 = dot(_19.xyz, _19.xyz);
    _155 = rsqrt(_155);
    float3 _184 = _155.xxx * _19.xyz;
    _19 = float4(_184.x, _184.y, _184.z, _19.w);
    _155 = dot(vs_TEXCOORD1, _19.xyz);
    _155 = clamp(_155, 0.0f, 1.0f);
    _155 = log2(_155);
    _155 *= _26_m4;
    _155 = exp2(_155);
    _155 *= _26_m5;
    _9 = _155.xxx * _9;
    _9 *= 0.5f.xxx;
    _217 = float4(_9.x, _9.y, _9.z, _217.w);
    _217.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._217 = _217;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToShadow[4];
static float4 _24_m1[16];
float4x4 unity_ObjectToWorld;
static float4 _24_m2[4];
float4x4 unity_WorldToObject;
static float4 _24_m3[4];
float4x4 unity_MatrixVP;
static float4 _24_m4[4];
float4 _NormalMap_ST;
void __unity_init()
{
    _24_m1[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _24_m1[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _24_m1[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _24_m1[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _24_m1[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _24_m1[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _24_m1[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _24_m1[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _24_m1[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _24_m1[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _24_m1[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _24_m1[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _24_m1[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _24_m1[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _24_m1[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _24_m1[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _24_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _24_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _24_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _24_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _24_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _24_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _24_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _24_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _24_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _24_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _24_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _24_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _24_m0 _WorldSpaceCameraPos
#define _24_m5 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _92;
static float3 _104;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _104 : NORMAL;
    float2 _92 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD3 : TEXCOORD1;
    float4 vs_TEXCOORD4 : TEXCOORD2;
    float2 vs_TEXCOORD0 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _53;
static float _126;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _24_m2[1];
    _9 = (_24_m2[0] * _11.xxxx) + _9;
    _9 = (_24_m2[2] * _11.zzzz) + _9;
    _47 = _9 + _24_m2[3];
    _53 = _47.yyyy * _24_m4[1];
    _53 = (_24_m4[0] * _47.xxxx) + _53;
    _53 = (_24_m4[2] * _47.zzzz) + _53;
    gl_Position = (_24_m4[3] * _47.wwww) + _53;
    vs_TEXCOORD0 = (_92 * _24_m5.xy) + _24_m5.zw;
    _47.x = dot(_104, _24_m3[0].xyz);
    _47.y = dot(_104, _24_m3[1].xyz);
    _47.z = dot(_104, _24_m3[2].xyz);
    _126 = dot(_47.xyz, _47.xyz);
    _126 = rsqrt(_126);
    vs_TEXCOORD1 = _126.xxx * _47.xyz;
    float3 _149 = (_24_m2[3].xyz * _11.www) + _9.xyz;
    _47 = float4(_149.x, _149.y, _149.z, _47.w);
    _9 = (_24_m2[3] * _11.wwww) + _9;
    vs_TEXCOORD2 = _47.xyz;
    float3 _168 = (-_47.xyz) + _24_m0;
    _47 = float4(_168.x, _168.y, _168.z, _47.w);
    _126 = dot(_47.xyz, _47.xyz);
    _126 = rsqrt(_126);
    vs_TEXCOORD3 = _126.xxx * _47.xyz;
    _47 = _9.yyyy * _24_m1[1];
    _47 = (_24_m1[0] * _9.xxxx) + _47;
    _47 = (_24_m1[2] * _9.zzzz) + _47;
    vs_TEXCOORD4 = (_24_m1[3] * _9.wwww) + _47;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _104 = stage_input._104;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightShadowData;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _13_m0 _WorldSpaceLightPos0
#define _13_m1 _LightShadowData
#define _13_m2 _LightColor0
#define _13_m3 _SpecularPower
#define _13_m4 _Glossiness


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __104_sampler;

static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD4;
static float4 _140;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD3 : TEXCOORD1;
    float4 vs_TEXCOORD4 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _140 : SV_Target0;
};

static float3 _9;
static float _42;
static float3 _100;
static float _110;

void frag_inner()
{
    _9.x = dot(_13_m0.xyz, _13_m0.xyz);
    _9.x = rsqrt(_9.x);
    _9 = (_13_m0.xyz * _9.xxx) + vs_TEXCOORD3;
    _42 = dot(_9, _9);
    _42 = rsqrt(_42);
    _9 = _42.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _13_m3;
    _9.x = exp2(_9.x);
    _9.x *= _13_m4;
    float3 _87 = float3(vs_TEXCOORD4.xy, vs_TEXCOORD4.z);
    _100.x = _ShadowMapTexture.SampleCmpLevelZero(__104_sampler, _87.xy, _87.z);
    _110 = (-_13_m1.x) + 1.0f;
    _100.x = (_100.x * _110) + _13_m1.x;
    _100 = _100.xxx * _13_m2.xyz;
    _9 = _9.xxx * _100;
    _9 *= 0.5f.xxx;
    _140 = float4(_9.x, _9.y, _9.z, _140.w);
    _140.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._140 = _140;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToShadow[4];
static float4 _24_m1[16];
float4x4 unity_ObjectToWorld;
static float4 _24_m2[4];
float4x4 unity_WorldToObject;
static float4 _24_m3[4];
float4x4 unity_MatrixVP;
static float4 _24_m4[4];
float4 _NormalMap_ST;
void __unity_init()
{
    _24_m1[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _24_m1[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _24_m1[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _24_m1[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _24_m1[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _24_m1[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _24_m1[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _24_m1[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _24_m1[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _24_m1[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _24_m1[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _24_m1[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _24_m1[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _24_m1[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _24_m1[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _24_m1[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _24_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _24_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _24_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _24_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _24_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _24_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _24_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _24_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _24_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _24_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _24_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _24_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _24_m0 _WorldSpaceCameraPos
#define _24_m5 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _92;
static float3 _104;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _104 : NORMAL;
    float2 _92 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD3 : TEXCOORD1;
    float4 vs_TEXCOORD4 : TEXCOORD2;
    float2 vs_TEXCOORD0 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _53;
static float _126;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _24_m2[1];
    _9 = (_24_m2[0] * _11.xxxx) + _9;
    _9 = (_24_m2[2] * _11.zzzz) + _9;
    _47 = _9 + _24_m2[3];
    _53 = _47.yyyy * _24_m4[1];
    _53 = (_24_m4[0] * _47.xxxx) + _53;
    _53 = (_24_m4[2] * _47.zzzz) + _53;
    gl_Position = (_24_m4[3] * _47.wwww) + _53;
    vs_TEXCOORD0 = (_92 * _24_m5.xy) + _24_m5.zw;
    _47.x = dot(_104, _24_m3[0].xyz);
    _47.y = dot(_104, _24_m3[1].xyz);
    _47.z = dot(_104, _24_m3[2].xyz);
    _126 = dot(_47.xyz, _47.xyz);
    _126 = rsqrt(_126);
    vs_TEXCOORD1 = _126.xxx * _47.xyz;
    float3 _149 = (_24_m2[3].xyz * _11.www) + _9.xyz;
    _47 = float4(_149.x, _149.y, _149.z, _47.w);
    _9 = (_24_m2[3] * _11.wwww) + _9;
    vs_TEXCOORD2 = _47.xyz;
    float3 _168 = (-_47.xyz) + _24_m0;
    _47 = float4(_168.x, _168.y, _168.z, _47.w);
    _126 = dot(_47.xyz, _47.xyz);
    _126 = rsqrt(_126);
    vs_TEXCOORD3 = _126.xxx * _47.xyz;
    _47 = _9.yyyy * _24_m1[1];
    _47 = (_24_m1[0] * _9.xxxx) + _47;
    _47 = (_24_m1[2] * _9.zzzz) + _47;
    vs_TEXCOORD4 = (_24_m1[3] * _9.wwww) + _47;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _104 = stage_input._104;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightShadowData;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _13_m0 _WorldSpaceLightPos0
#define _13_m1 _LightShadowData
#define _13_m2 _LightColor0
#define _13_m3 _SpecularPower
#define _13_m4 _Glossiness


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __104_sampler;

static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD4;
static float4 _140;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD3 : TEXCOORD1;
    float4 vs_TEXCOORD4 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _140 : SV_Target0;
};

static float3 _9;
static float _42;
static float3 _100;
static float _110;

void frag_inner()
{
    _9.x = dot(_13_m0.xyz, _13_m0.xyz);
    _9.x = rsqrt(_9.x);
    _9 = (_13_m0.xyz * _9.xxx) + vs_TEXCOORD3;
    _42 = dot(_9, _9);
    _42 = rsqrt(_42);
    _9 = _42.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _13_m3;
    _9.x = exp2(_9.x);
    _9.x *= _13_m4;
    float3 _87 = float3(vs_TEXCOORD4.xy, vs_TEXCOORD4.z);
    _100.x = _ShadowMapTexture.SampleCmpLevelZero(__104_sampler, _87.xy, _87.z);
    _110 = (-_13_m1.x) + 1.0f;
    _100.x = (_100.x * _110) + _13_m1.x;
    _100 = _100.xxx * _13_m2.xyz;
    _9 = _9.xxx * _100;
    _9 *= 0.5f.xxx;
    _140 = float4(_9.x, _9.y, _9.z, _140.w);
    _140.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._140 = _140;
    return stage_output;
}

#endif
#elif defined(POINT) && defined(SHADOWS_CUBE)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _LightPositionRange;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 _NormalMap_ST;
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
#define _22_m1 _LightPositionRange
#define _22_m5 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float3 _113;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _113 : NORMAL;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _135;

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
    gl_Position = (_22_m4[3] * _45.wwww) + _62;
    vs_TEXCOORD0 = (_101 * _22_m5.xy) + _22_m5.zw;
    _45.x = dot(_113, _22_m3[0].xyz);
    _45.y = dot(_113, _22_m3[1].xyz);
    _45.z = dot(_113, _22_m3[2].xyz);
    _135 = dot(_45.xyz, _45.xyz);
    _135 = rsqrt(_135);
    vs_TEXCOORD1 = _135.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    float3 _159 = (-_9.xyz) + _22_m0;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    vs_TEXCOORD4 = _9.xyz + (-_22_m1.xyz);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD3 = _9.xxx * _45.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _113 = stage_input._113;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightProjectionParams;
float4 _LightShadowData;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _17_m0 _WorldSpaceLightPos0
#define _17_m1 _LightProjectionParams
#define _17_m2 _LightShadowData
#define _17_m3 _LightColor0
#define _17_m4 _SpecularPower
#define _17_m5 _Glossiness


TextureCube<float4> _ShadowMapTexture;
SamplerComparisonState __154_sampler;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD4;
static float4 _190;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _190 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _84;
static float _160;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0.xyz;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = (_9 * _26.xxx) + vs_TEXCOORD3;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _17_m4;
    _9.x = exp2(_9.x);
    _9.x *= _17_m5;
    _84.x = max(abs(vs_TEXCOORD4.y), abs(vs_TEXCOORD4.x));
    _84.x = max(_84.x, abs(vs_TEXCOORD4.z));
    _84.x += (-_17_m1.z);
    _84.x = max(_84.x, 9.9999997473787516355514526367188e-06f);
    _84.x *= _17_m1.w;
    _84.x = _17_m1.y / _84.x;
    _84.x += (-_17_m1.x);
    _84.x = (-_84.x) + 1.0f;
    float4 _143 = float4(vs_TEXCOORD4, _84.x);
    _84.x = _ShadowMapTexture.SampleCmp(__154_sampler, _143.xyz, _143.w);
    _160 = (-_17_m2.x) + 1.0f;
    _84.x = (_84.x * _160) + _17_m2.x;
    _84 = _84.xxx * _17_m3.xyz;
    _9 = _9.xxx * _84;
    _9 *= 0.5f.xxx;
    _190 = float4(_9.x, _9.y, _9.z, _190.w);
    _190.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._190 = _190;
    return stage_output;
}

#endif
#elif defined(POINT_COOKIE) && defined(SHADOWS_CUBE)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _LightPositionRange;
float4x4 unity_ObjectToWorld;
static float4 _22_m2[4];
float4x4 unity_WorldToObject;
static float4 _22_m3[4];
float4x4 unity_MatrixVP;
static float4 _22_m4[4];
float4 _NormalMap_ST;
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
#define _22_m1 _LightPositionRange
#define _22_m5 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _101;
static float3 _113;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _113 : NORMAL;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _135;

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
    gl_Position = (_22_m4[3] * _45.wwww) + _62;
    vs_TEXCOORD0 = (_101 * _22_m5.xy) + _22_m5.zw;
    _45.x = dot(_113, _22_m3[0].xyz);
    _45.y = dot(_113, _22_m3[1].xyz);
    _45.z = dot(_113, _22_m3[2].xyz);
    _135 = dot(_45.xyz, _45.xyz);
    _135 = rsqrt(_135);
    vs_TEXCOORD1 = _135.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    float3 _159 = (-_9.xyz) + _22_m0;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    vs_TEXCOORD4 = _9.xyz + (-_22_m1.xyz);
    _9.x = dot(_45.xyz, _45.xyz);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD3 = _9.xxx * _45.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _113 = stage_input._113;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightProjectionParams;
float4 _LightShadowData;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _17_m0 _WorldSpaceLightPos0
#define _17_m1 _LightProjectionParams
#define _17_m2 _LightShadowData
#define _17_m3 _LightColor0
#define _17_m4 _SpecularPower
#define _17_m5 _Glossiness


TextureCube<float4> _ShadowMapTexture;
SamplerComparisonState __154_sampler;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD4;
static float4 _190;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _190 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _84;
static float _160;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0.xyz;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = (_9 * _26.xxx) + vs_TEXCOORD3;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _17_m4;
    _9.x = exp2(_9.x);
    _9.x *= _17_m5;
    _84.x = max(abs(vs_TEXCOORD4.y), abs(vs_TEXCOORD4.x));
    _84.x = max(_84.x, abs(vs_TEXCOORD4.z));
    _84.x += (-_17_m1.z);
    _84.x = max(_84.x, 9.9999997473787516355514526367188e-06f);
    _84.x *= _17_m1.w;
    _84.x = _17_m1.y / _84.x;
    _84.x += (-_17_m1.x);
    _84.x = (-_84.x) + 1.0f;
    float4 _143 = float4(vs_TEXCOORD4, _84.x);
    _84.x = _ShadowMapTexture.SampleCmp(__154_sampler, _143.xyz, _143.w);
    _160 = (-_17_m2.x) + 1.0f;
    _84.x = (_84.x * _160) + _17_m2.x;
    _84 = _84.xxx * _17_m3.xyz;
    _9 = _9.xxx * _84;
    _9 *= 0.5f.xxx;
    _190 = float4(_9.x, _9.y, _9.z, _190.w);
    _190.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._190 = _190;
    return stage_output;
}

#endif
#elif defined(SHADOWS_DEPTH) && defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToShadow[4];
static float4 _24_m1[16];
float4x4 unity_ObjectToWorld;
static float4 _24_m2[4];
float4x4 unity_WorldToObject;
static float4 _24_m3[4];
float4x4 unity_MatrixVP;
static float4 _24_m4[4];
float4 _NormalMap_ST;
void __unity_init()
{
    _24_m1[0] = float4(unity_WorldToShadow[0][0][0], unity_WorldToShadow[0][1][0], unity_WorldToShadow[0][2][0], unity_WorldToShadow[0][3][0]);
    _24_m1[1] = float4(unity_WorldToShadow[0][0][1], unity_WorldToShadow[0][1][1], unity_WorldToShadow[0][2][1], unity_WorldToShadow[0][3][1]);
    _24_m1[2] = float4(unity_WorldToShadow[0][0][2], unity_WorldToShadow[0][1][2], unity_WorldToShadow[0][2][2], unity_WorldToShadow[0][3][2]);
    _24_m1[3] = float4(unity_WorldToShadow[0][0][3], unity_WorldToShadow[0][1][3], unity_WorldToShadow[0][2][3], unity_WorldToShadow[0][3][3]);
    _24_m1[4] = float4(unity_WorldToShadow[1][0][0], unity_WorldToShadow[1][1][0], unity_WorldToShadow[1][2][0], unity_WorldToShadow[1][3][0]);
    _24_m1[5] = float4(unity_WorldToShadow[1][0][1], unity_WorldToShadow[1][1][1], unity_WorldToShadow[1][2][1], unity_WorldToShadow[1][3][1]);
    _24_m1[6] = float4(unity_WorldToShadow[1][0][2], unity_WorldToShadow[1][1][2], unity_WorldToShadow[1][2][2], unity_WorldToShadow[1][3][2]);
    _24_m1[7] = float4(unity_WorldToShadow[1][0][3], unity_WorldToShadow[1][1][3], unity_WorldToShadow[1][2][3], unity_WorldToShadow[1][3][3]);
    _24_m1[8] = float4(unity_WorldToShadow[2][0][0], unity_WorldToShadow[2][1][0], unity_WorldToShadow[2][2][0], unity_WorldToShadow[2][3][0]);
    _24_m1[9] = float4(unity_WorldToShadow[2][0][1], unity_WorldToShadow[2][1][1], unity_WorldToShadow[2][2][1], unity_WorldToShadow[2][3][1]);
    _24_m1[10] = float4(unity_WorldToShadow[2][0][2], unity_WorldToShadow[2][1][2], unity_WorldToShadow[2][2][2], unity_WorldToShadow[2][3][2]);
    _24_m1[11] = float4(unity_WorldToShadow[2][0][3], unity_WorldToShadow[2][1][3], unity_WorldToShadow[2][2][3], unity_WorldToShadow[2][3][3]);
    _24_m1[12] = float4(unity_WorldToShadow[3][0][0], unity_WorldToShadow[3][1][0], unity_WorldToShadow[3][2][0], unity_WorldToShadow[3][3][0]);
    _24_m1[13] = float4(unity_WorldToShadow[3][0][1], unity_WorldToShadow[3][1][1], unity_WorldToShadow[3][2][1], unity_WorldToShadow[3][3][1]);
    _24_m1[14] = float4(unity_WorldToShadow[3][0][2], unity_WorldToShadow[3][1][2], unity_WorldToShadow[3][2][2], unity_WorldToShadow[3][3][2]);
    _24_m1[15] = float4(unity_WorldToShadow[3][0][3], unity_WorldToShadow[3][1][3], unity_WorldToShadow[3][2][3], unity_WorldToShadow[3][3][3]);
    _24_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _24_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _24_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _24_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _24_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _24_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _24_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _24_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _24_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _24_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _24_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _24_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _24_m0 _WorldSpaceCameraPos
#define _24_m5 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _92;
static float3 _104;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _104 : NORMAL;
    float2 _92 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float4 vs_TEXCOORD4 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _47;
static float4 _53;
static float _126;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _24_m2[1];
    _9 = (_24_m2[0] * _11.xxxx) + _9;
    _9 = (_24_m2[2] * _11.zzzz) + _9;
    _47 = _9 + _24_m2[3];
    _53 = _47.yyyy * _24_m4[1];
    _53 = (_24_m4[0] * _47.xxxx) + _53;
    _53 = (_24_m4[2] * _47.zzzz) + _53;
    gl_Position = (_24_m4[3] * _47.wwww) + _53;
    vs_TEXCOORD0 = (_92 * _24_m5.xy) + _24_m5.zw;
    _47.x = dot(_104, _24_m3[0].xyz);
    _47.y = dot(_104, _24_m3[1].xyz);
    _47.z = dot(_104, _24_m3[2].xyz);
    _126 = dot(_47.xyz, _47.xyz);
    _126 = rsqrt(_126);
    vs_TEXCOORD1 = _126.xxx * _47.xyz;
    float3 _149 = (_24_m2[3].xyz * _11.www) + _9.xyz;
    _47 = float4(_149.x, _149.y, _149.z, _47.w);
    _9 = (_24_m2[3] * _11.wwww) + _9;
    vs_TEXCOORD2 = _47.xyz;
    float3 _168 = (-_47.xyz) + _24_m0;
    _47 = float4(_168.x, _168.y, _168.z, _47.w);
    _126 = dot(_47.xyz, _47.xyz);
    _126 = rsqrt(_126);
    vs_TEXCOORD3 = _126.xxx * _47.xyz;
    _47 = _9.yyyy * _24_m1[1];
    _47 = (_24_m1[0] * _9.xxxx) + _47;
    _47 = (_24_m1[2] * _9.zzzz) + _47;
    vs_TEXCOORD4 = (_24_m1[3] * _9.wwww) + _47;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _92 = stage_input._92;
    _104 = stage_input._104;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightShadowData;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _17_m0 _WorldSpaceLightPos0
#define _17_m1 _LightShadowData
#define _17_m2 _LightColor0
#define _17_m3 _SpecularPower
#define _17_m4 _Glossiness


Texture2D<float4> _ShadowMapTexture;
SamplerComparisonState __106_sampler;

static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 vs_TEXCOORD4;
static float4 _142;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float4 vs_TEXCOORD4 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _142 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _84;
static float _112;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0.xyz;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = (_9 * _26.xxx) + vs_TEXCOORD3;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _17_m3;
    _9.x = exp2(_9.x);
    _9.x *= _17_m4;
    _84 = vs_TEXCOORD4.xyz / vs_TEXCOORD4.www;
    float3 _93 = float3(_84.xy, _84.z);
    _84.x = _ShadowMapTexture.SampleCmpLevelZero(__106_sampler, _93.xy, _93.z);
    _112 = (-_17_m1.x) + 1.0f;
    _84.x = (_84.x * _112) + _17_m1.x;
    _84 = _84.xxx * _17_m2.xyz;
    _9 = _9.xxx * _84;
    _9 *= 0.5f.xxx;
    _142 = float4(_9.x, _9.y, _9.z, _142.w);
    _142.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._142 = _142;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _NormalMap_ST;
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
#define _22_m4 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _100;
static float3 _112;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _112 : NORMAL;
    float2 _100 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD3 : TEXCOORD1;
    float2 vs_TEXCOORD0 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _134;

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
    vs_TEXCOORD0 = (_100 * _22_m4.xy) + _22_m4.zw;
    _45.x = dot(_112, _22_m2[0].xyz);
    _45.y = dot(_112, _22_m2[1].xyz);
    _45.z = dot(_112, _22_m2[2].xyz);
    _134 = dot(_45.xyz, _45.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD1 = _134.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    float3 _158 = (-_9.xyz) + _22_m0;
    _9 = float4(_158.x, _158.y, _158.z, _9.w);
    _134 = dot(_9.xyz, _9.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD3 = _134.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    _112 = stage_input._112;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _13_m0 _WorldSpaceLightPos0
#define _13_m1 _LightColor0
#define _13_m2 _SpecularPower
#define _13_m3 _Glossiness



static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 _98;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD3 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _98 : SV_Target0;
};

static float3 _9;
static float _42;

void frag_inner()
{
    _9.x = dot(_13_m0.xyz, _13_m0.xyz);
    _9.x = rsqrt(_9.x);
    _9 = (_13_m0.xyz * _9.xxx) + vs_TEXCOORD3;
    _42 = dot(_9, _9);
    _42 = rsqrt(_42);
    _9 = _42.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _13_m2;
    _9.x = exp2(_9.x);
    _9.x *= _13_m3;
    _9 = _9.xxx * _13_m1.xyz;
    _9 *= 0.5f.xxx;
    _98 = float4(_9.x, _9.y, _9.z, _98.w);
    _98.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._98 = _98;
    return stage_output;
}

#endif
#elif defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _NormalMap_ST;
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
#define _22_m4 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _100;
static float3 _112;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _112 : NORMAL;
    float2 _100 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float2 vs_TEXCOORD0 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _134;

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
    vs_TEXCOORD0 = (_100 * _22_m4.xy) + _22_m4.zw;
    _45.x = dot(_112, _22_m2[0].xyz);
    _45.y = dot(_112, _22_m2[1].xyz);
    _45.z = dot(_112, _22_m2[2].xyz);
    _134 = dot(_45.xyz, _45.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD1 = _134.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    float3 _158 = (-_9.xyz) + _22_m0;
    _9 = float4(_158.x, _158.y, _158.z, _9.w);
    _134 = dot(_9.xyz, _9.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD3 = _134.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    _112 = stage_input._112;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _17_m0 _WorldSpaceLightPos0
#define _17_m1 _LightColor0
#define _17_m2 _SpecularPower
#define _17_m3 _Glossiness



static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 _96;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _96 : SV_Target0;
};

static float3 _9;
static float _26;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0.xyz;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = (_9 * _26.xxx) + vs_TEXCOORD3;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _17_m2;
    _9.x = exp2(_9.x);
    _9.x *= _17_m3;
    _9 = _9.xxx * _17_m1.xyz;
    _9 *= 0.5f.xxx;
    _96 = float4(_9.x, _9.y, _9.z, _96.w);
    _96.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._96 = _96;
    return stage_output;
}

#endif
#elif defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _NormalMap_ST;
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
#define _22_m4 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _100;
static float3 _112;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _112 : NORMAL;
    float2 _100 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float2 vs_TEXCOORD0 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _134;

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
    vs_TEXCOORD0 = (_100 * _22_m4.xy) + _22_m4.zw;
    _45.x = dot(_112, _22_m2[0].xyz);
    _45.y = dot(_112, _22_m2[1].xyz);
    _45.z = dot(_112, _22_m2[2].xyz);
    _134 = dot(_45.xyz, _45.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD1 = _134.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    float3 _158 = (-_9.xyz) + _22_m0;
    _9 = float4(_158.x, _158.y, _158.z, _9.w);
    _134 = dot(_9.xyz, _9.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD3 = _134.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    _112 = stage_input._112;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _17_m0 _WorldSpaceLightPos0
#define _17_m1 _LightColor0
#define _17_m2 _SpecularPower
#define _17_m3 _Glossiness



static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 _96;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _96 : SV_Target0;
};

static float3 _9;
static float _26;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0.xyz;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = (_9 * _26.xxx) + vs_TEXCOORD3;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _17_m2;
    _9.x = exp2(_9.x);
    _9.x *= _17_m3;
    _9 = _9.xxx * _17_m1.xyz;
    _9 *= 0.5f.xxx;
    _96 = float4(_9.x, _9.y, _9.z, _96.w);
    _96.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._96 = _96;
    return stage_output;
}

#endif
#elif defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _NormalMap_ST;
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
#define _22_m4 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _100;
static float3 _112;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _112 : NORMAL;
    float2 _100 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float2 vs_TEXCOORD0 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _134;

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
    vs_TEXCOORD0 = (_100 * _22_m4.xy) + _22_m4.zw;
    _45.x = dot(_112, _22_m2[0].xyz);
    _45.y = dot(_112, _22_m2[1].xyz);
    _45.z = dot(_112, _22_m2[2].xyz);
    _134 = dot(_45.xyz, _45.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD1 = _134.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    float3 _158 = (-_9.xyz) + _22_m0;
    _9 = float4(_158.x, _158.y, _158.z, _9.w);
    _134 = dot(_9.xyz, _9.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD3 = _134.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    _112 = stage_input._112;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _17_m0 _WorldSpaceLightPos0
#define _17_m1 _LightColor0
#define _17_m2 _SpecularPower
#define _17_m3 _Glossiness



static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 _96;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _96 : SV_Target0;
};

static float3 _9;
static float _26;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0.xyz;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = (_9 * _26.xxx) + vs_TEXCOORD3;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _17_m2;
    _9.x = exp2(_9.x);
    _9.x *= _17_m3;
    _9 = _9.xxx * _17_m1.xyz;
    _9 *= 0.5f.xxx;
    _96 = float4(_9.x, _9.y, _9.z, _96.w);
    _96.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._96 = _96;
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
float4 _NormalMap_ST;
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
#define _22_m4 _NormalMap_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _100;
static float3 _112;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _112 : NORMAL;
    float2 _100 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD3 : TEXCOORD1;
    float2 vs_TEXCOORD0 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _134;

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
    vs_TEXCOORD0 = (_100 * _22_m4.xy) + _22_m4.zw;
    _45.x = dot(_112, _22_m2[0].xyz);
    _45.y = dot(_112, _22_m2[1].xyz);
    _45.z = dot(_112, _22_m2[2].xyz);
    _134 = dot(_45.xyz, _45.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD1 = _134.xxx * _45.xyz;
    vs_TEXCOORD2 = _9.xyz;
    float3 _158 = (-_9.xyz) + _22_m0;
    _9 = float4(_158.x, _158.y, _158.z, _9.w);
    _134 = dot(_9.xyz, _9.xyz);
    _134 = rsqrt(_134);
    vs_TEXCOORD3 = _134.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    _112 = stage_input._112;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float _SpecularPower;
float _Glossiness;
#define _13_m0 _WorldSpaceLightPos0
#define _13_m1 _LightColor0
#define _13_m2 _SpecularPower
#define _13_m3 _Glossiness



static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float4 _98;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD3 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _98 : SV_Target0;
};

static float3 _9;
static float _42;

void frag_inner()
{
    _9.x = dot(_13_m0.xyz, _13_m0.xyz);
    _9.x = rsqrt(_9.x);
    _9 = (_13_m0.xyz * _9.xxx) + vs_TEXCOORD3;
    _42 = dot(_9, _9);
    _42 = rsqrt(_42);
    _9 = _42.xxx * _9;
    _9.x = dot(vs_TEXCOORD1, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = log2(_9.x);
    _9.x *= _13_m2;
    _9.x = exp2(_9.x);
    _9.x *= _13_m3;
    _9 = _9.xxx * _13_m1.xyz;
    _9 *= 0.5f.xxx;
    _98 = float4(_9.x, _9.y, _9.z, _98.w);
    _98.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._98 = _98;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Transparent/VertexLit"
}