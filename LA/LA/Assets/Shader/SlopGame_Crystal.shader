// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SlopGame/Crystal" {
Properties {

[Header(Crystal Color)] _CoreColor ("Core Color", Color) = (0.5,0.85,1,0.65)

_EdgeColor ("Edge Rim Color", Color) = (0.85,0.95,1,0.95)

_FresnelPower ("Fresnel Power", Range(1, 10)) = 3.5

[Header(Texture)] _MainTex ("Albedo Texture", 2D) = "white" { }

[Header(Emission and Pulse)] _EmissionColor ("Emission Color", Color) = (0.3,0.75,1,1)

_EmissionTex ("Emission Texture", 2D) = "white" { }

_EmissionBase ("Emission Base", Range(0, 5)) = 1.0

_EmissionPulse ("Pulse Amount", Range(0, 3)) = 0.5

_PulseSpeed ("Pulse Speed", Range(0.1, 10)) = 1.5

[Header(Specular)] _SpecularColor ("Specular Color", Color) = (1,1,1,1)

_Shininess ("Shininess", Range(16, 512)) = 200.0

_SpecularStrength ("Specular Strength", Range(0, 3)) = 1.5

[Header(Reflection)] _ReflectionStrength ("Reflection Strength", Range(0, 2)) = 0.699999988079071

_ReflectionBlur ("Reflection Blur", Range(0, 6)) = 0.5

[Header(Refraction)] _IOR ("Index of Refraction", Range(1, 2.5)) = 1.4500000476837158

_RefractWeight ("Refraction Weight", Range(0, 1)) = 0.3499999940395355

[Toggle(CRYSTAL_DISPERSION)] _DispersionEnabled ("Chromatic Dispersion", Float) = 1.0

_DispersionAmount ("Dispersion Amount", Range(0, 0.15)) = 0.029999999329447746

[Header(Interior)] _InteriorColor ("Interior Color", Color) = (0.4,0.7,1,1)

_InteriorDepth ("Depth", Range(0, 0.5)) = 0.11999999731779099

_InteriorStrength ("Interior Strength", Range(0, 3)) = 1.0

_InteriorScale ("Pattern Scale", Range(1, 20)) = 7.0

[Header(Surface)] _NormalMap ("Normal Map", 2D) = "bump" { }

_NormalStrength ("Normal Strength", Range(0, 3)) = 0.6000000238418579

_NormalScrollSpeed ("Scroll Speed", Range(0, 0.5)) = 0.019999999552965164

}
SubShader {
 LOD 200
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  LOD 200
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Front
   Blend SrcAlpha OneMinusSrcAlpha
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
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
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
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _152;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _152 : NORMAL;
    float2 _140 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _171;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD3 = exp2(-_9.x);
    vs_TEXCOORD0 = (_140 * _21_m5.xy) + _21_m5.zw;
    _9.x = dot(_152, _21_m2[0].xyz);
    _9.y = dot(_152, _21_m2[1].xyz);
    _9.z = dot(_152, _21_m2[2].xyz);
    _171 = dot(_9.xyz, _9.xyz);
    _171 = rsqrt(_171);
    vs_TEXCOORD2 = _171.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _152 = stage_input._152;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
#define _13_m0 _Time
#define _13_m1 _WorldSpaceCameraPos
#define _13_m2 unity_FogColor
#define _13_m3 _CoreColor
#define _13_m4 _EdgeColor
#define _13_m5 _FresnelPower
#define _13_m6 _EmissionColor
#define _13_m7 _EmissionTex_ST
#define _13_m8 _EmissionBase
#define _13_m9 _EmissionPulse
#define _13_m10 _PulseSpeed


Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float4 _221;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _221 : SV_Target0;
};

static float3 _9;
static float2 _51;
static float3 _65;
static float4 _75;
static float4 _95;
static float _107;
static float3 _130;
static float3 _175;

void frag_inner()
{
    _9.x = _13_m0.y * _13_m10;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = (_13_m9 * _9.x) + _13_m8;
    _51 = (vs_TEXCOORD0 * _13_m7.xy) + _13_m7.zw;
    _65 = _EmissionTex.Sample(sampler_EmissionTex, _51).xyz;
    float3 _81 = _65 * _13_m6.xyz;
    _75 = float4(_81.x, _81.y, _81.z, _75.w);
    float3 _88 = _9.xxx * _75.xyz;
    _75 = float4(_88.x, _88.y, _88.z, _75.w);
    _9 = _75.xyz * 0.5f.xxx;
    float3 _104 = (-vs_TEXCOORD1) + _13_m1;
    _95 = float4(_104.x, _104.y, _104.z, _95.w);
    _107 = dot(_95.xyz, _95.xyz);
    _107 = rsqrt(_107);
    float3 _119 = _107.xxx * _95.xyz;
    _95 = float4(_119.x, _119.y, _119.z, _95.w);
    _107 = dot(-vs_TEXCOORD2, -vs_TEXCOORD2);
    _107 = rsqrt(_107);
    _130 = _107.xxx * (-vs_TEXCOORD2);
    _75.x = dot(_130, _95.xyz);
    _75.x = clamp(_75.x, 0.0f, 1.0f);
    _107 = (-_75.x) + 1.0f;
    _107 = log2(_107);
    _107 *= _13_m5;
    _107 = exp2(_107);
    _75 = (-_13_m3) + _13_m4;
    _75 = (_107.xxxx * _75) + _13_m3;
    _175 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _184 = _75.xyz * _175;
    _75 = float4(_184.x, _184.y, _184.z, _75.w);
    _95.w = _75.w * 0.60000002384185791015625f;
    _9 = (_75.xyz * 0.5f.xxx) + _9;
    _9 += (-_13_m2.xyz);
    _107 = vs_TEXCOORD3;
    _107 = clamp(_107, 0.0f, 1.0f);
    float3 _217 = (_107.xxx * _9) + _13_m2.xyz;
    _95 = float4(_217.x, _217.y, _217.z, _95.w);
    _221 = _95;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._221 = _221;
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
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
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
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _146;
static float3 _158;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _158 : NORMAL;
    float2 _146 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _177;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD3 = exp2(_9.x);
    vs_TEXCOORD0 = (_146 * _21_m5.xy) + _21_m5.zw;
    _9.x = dot(_158, _21_m2[0].xyz);
    _9.y = dot(_158, _21_m2[1].xyz);
    _9.z = dot(_158, _21_m2[2].xyz);
    _177 = dot(_9.xyz, _9.xyz);
    _177 = rsqrt(_177);
    vs_TEXCOORD2 = _177.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    _158 = stage_input._158;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
#define _13_m0 _Time
#define _13_m1 _WorldSpaceCameraPos
#define _13_m2 unity_FogColor
#define _13_m3 _CoreColor
#define _13_m4 _EdgeColor
#define _13_m5 _FresnelPower
#define _13_m6 _EmissionColor
#define _13_m7 _EmissionTex_ST
#define _13_m8 _EmissionBase
#define _13_m9 _EmissionPulse
#define _13_m10 _PulseSpeed


Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float4 _221;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _221 : SV_Target0;
};

static float3 _9;
static float2 _51;
static float3 _65;
static float4 _75;
static float4 _95;
static float _107;
static float3 _130;
static float3 _175;

void frag_inner()
{
    _9.x = _13_m0.y * _13_m10;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = (_13_m9 * _9.x) + _13_m8;
    _51 = (vs_TEXCOORD0 * _13_m7.xy) + _13_m7.zw;
    _65 = _EmissionTex.Sample(sampler_EmissionTex, _51).xyz;
    float3 _81 = _65 * _13_m6.xyz;
    _75 = float4(_81.x, _81.y, _81.z, _75.w);
    float3 _88 = _9.xxx * _75.xyz;
    _75 = float4(_88.x, _88.y, _88.z, _75.w);
    _9 = _75.xyz * 0.5f.xxx;
    float3 _104 = (-vs_TEXCOORD1) + _13_m1;
    _95 = float4(_104.x, _104.y, _104.z, _95.w);
    _107 = dot(_95.xyz, _95.xyz);
    _107 = rsqrt(_107);
    float3 _119 = _107.xxx * _95.xyz;
    _95 = float4(_119.x, _119.y, _119.z, _95.w);
    _107 = dot(-vs_TEXCOORD2, -vs_TEXCOORD2);
    _107 = rsqrt(_107);
    _130 = _107.xxx * (-vs_TEXCOORD2);
    _75.x = dot(_130, _95.xyz);
    _75.x = clamp(_75.x, 0.0f, 1.0f);
    _107 = (-_75.x) + 1.0f;
    _107 = log2(_107);
    _107 *= _13_m5;
    _107 = exp2(_107);
    _75 = (-_13_m3) + _13_m4;
    _75 = (_107.xxxx * _75) + _13_m3;
    _175 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _184 = _75.xyz * _175;
    _75 = float4(_184.x, _184.y, _184.z, _75.w);
    _95.w = _75.w * 0.60000002384185791015625f;
    _9 = (_75.xyz * 0.5f.xxx) + _9;
    _9 += (-_13_m2.xyz);
    _107 = vs_TEXCOORD3;
    _107 = clamp(_107, 0.0f, 1.0f);
    float3 _217 = (_107.xxx * _9) + _13_m2.xyz;
    _95 = float4(_217.x, _217.y, _217.z, _95.w);
    _221 = _95;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._221 = _221;
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
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
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
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD0;
static float2 _139;
static float3 _151;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _151 : NORMAL;
    float2 _139 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _170;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD3 = (_9.x * _21_m4.z) + _21_m4.w;
    vs_TEXCOORD0 = (_139 * _21_m5.xy) + _21_m5.zw;
    _9.x = dot(_151, _21_m2[0].xyz);
    _9.y = dot(_151, _21_m2[1].xyz);
    _9.z = dot(_151, _21_m2[2].xyz);
    _170 = dot(_9.xyz, _9.xyz);
    _170 = rsqrt(_170);
    vs_TEXCOORD2 = _170.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _151 = stage_input._151;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
#define _13_m0 _Time
#define _13_m1 _WorldSpaceCameraPos
#define _13_m2 unity_FogColor
#define _13_m3 _CoreColor
#define _13_m4 _EdgeColor
#define _13_m5 _FresnelPower
#define _13_m6 _EmissionColor
#define _13_m7 _EmissionTex_ST
#define _13_m8 _EmissionBase
#define _13_m9 _EmissionPulse
#define _13_m10 _PulseSpeed


Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float4 _221;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD3 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _221 : SV_Target0;
};

static float3 _9;
static float2 _51;
static float3 _65;
static float4 _75;
static float4 _95;
static float _107;
static float3 _130;
static float3 _175;

void frag_inner()
{
    _9.x = _13_m0.y * _13_m10;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = (_13_m9 * _9.x) + _13_m8;
    _51 = (vs_TEXCOORD0 * _13_m7.xy) + _13_m7.zw;
    _65 = _EmissionTex.Sample(sampler_EmissionTex, _51).xyz;
    float3 _81 = _65 * _13_m6.xyz;
    _75 = float4(_81.x, _81.y, _81.z, _75.w);
    float3 _88 = _9.xxx * _75.xyz;
    _75 = float4(_88.x, _88.y, _88.z, _75.w);
    _9 = _75.xyz * 0.5f.xxx;
    float3 _104 = (-vs_TEXCOORD1) + _13_m1;
    _95 = float4(_104.x, _104.y, _104.z, _95.w);
    _107 = dot(_95.xyz, _95.xyz);
    _107 = rsqrt(_107);
    float3 _119 = _107.xxx * _95.xyz;
    _95 = float4(_119.x, _119.y, _119.z, _95.w);
    _107 = dot(-vs_TEXCOORD2, -vs_TEXCOORD2);
    _107 = rsqrt(_107);
    _130 = _107.xxx * (-vs_TEXCOORD2);
    _75.x = dot(_130, _95.xyz);
    _75.x = clamp(_75.x, 0.0f, 1.0f);
    _107 = (-_75.x) + 1.0f;
    _107 = log2(_107);
    _107 *= _13_m5;
    _107 = exp2(_107);
    _75 = (-_13_m3) + _13_m4;
    _75 = (_107.xxxx * _75) + _13_m3;
    _175 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _184 = _75.xyz * _175;
    _75 = float4(_184.x, _184.y, _184.z, _75.w);
    _95.w = _75.w * 0.60000002384185791015625f;
    _9 = (_75.xyz * 0.5f.xxx) + _9;
    _9 += (-_13_m2.xyz);
    _107 = vs_TEXCOORD3;
    _107 = clamp(_107, 0.0f, 1.0f);
    float3 _217 = (_107.xxx * _9) + _13_m2.xyz;
    _95 = float4(_217.x, _217.y, _217.z, _95.w);
    _221 = _95;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._221 = _221;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
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
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m3 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _110;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _110 : NORMAL;
    float2 _99 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _132;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _44.xxxx) + _9;
    _9 = (_21_m2[2] * _44.zzzz) + _9;
    gl_Position = (_21_m2[3] * _44.wwww) + _9;
    vs_TEXCOORD0 = (_99 * _21_m3.xy) + _21_m3.zw;
    _9.x = dot(_110, _21_m1[0].xyz);
    _9.y = dot(_110, _21_m1[1].xyz);
    _9.z = dot(_110, _21_m1[2].xyz);
    _132 = dot(_9.xyz, _9.xyz);
    _132 = rsqrt(_132);
    vs_TEXCOORD2 = _132.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _110 = stage_input._110;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
#define _13_m0 _Time
#define _13_m1 _WorldSpaceCameraPos
#define _13_m2 _CoreColor
#define _13_m3 _EdgeColor
#define _13_m4 _FresnelPower
#define _13_m5 _EmissionColor
#define _13_m6 _EmissionTex_ST
#define _13_m7 _EmissionBase
#define _13_m8 _EmissionPulse
#define _13_m9 _PulseSpeed


Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _201;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _201 : SV_Target0;
};

static float3 _9;
static float2 _51;
static float3 _65;
static float4 _75;
static float4 _95;
static float _107;
static float3 _130;
static float3 _175;

void frag_inner()
{
    _9.x = _13_m0.y * _13_m9;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = (_13_m8 * _9.x) + _13_m7;
    _51 = (vs_TEXCOORD0 * _13_m6.xy) + _13_m6.zw;
    _65 = _EmissionTex.Sample(sampler_EmissionTex, _51).xyz;
    float3 _81 = _65 * _13_m5.xyz;
    _75 = float4(_81.x, _81.y, _81.z, _75.w);
    float3 _88 = _9.xxx * _75.xyz;
    _75 = float4(_88.x, _88.y, _88.z, _75.w);
    _9 = _75.xyz * 0.5f.xxx;
    float3 _104 = (-vs_TEXCOORD1) + _13_m1;
    _95 = float4(_104.x, _104.y, _104.z, _95.w);
    _107 = dot(_95.xyz, _95.xyz);
    _107 = rsqrt(_107);
    float3 _119 = _107.xxx * _95.xyz;
    _95 = float4(_119.x, _119.y, _119.z, _95.w);
    _107 = dot(-vs_TEXCOORD2, -vs_TEXCOORD2);
    _107 = rsqrt(_107);
    _130 = _107.xxx * (-vs_TEXCOORD2);
    _75.x = dot(_130, _95.xyz);
    _75.x = clamp(_75.x, 0.0f, 1.0f);
    _107 = (-_75.x) + 1.0f;
    _107 = log2(_107);
    _107 *= _13_m4;
    _107 = exp2(_107);
    _75 = (-_13_m2) + _13_m3;
    _75 = (_107.xxxx * _75) + _13_m2;
    _175 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    float3 _184 = _75.xyz * _175;
    _75 = float4(_184.x, _184.y, _184.z, _75.w);
    _95.w = _75.w * 0.60000002384185791015625f;
    float3 _197 = (_75.xyz * 0.5f.xxx) + _9;
    _95 = float4(_197.x, _197.y, _197.z, _95.w);
    _201 = _95;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._201 = _201;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
Cull Back
  LOD 200
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
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
#pragma multi_compile_local __ CRYSTAL_DISPERSION
#if defined(CRYSTAL_DISPERSION) && defined(FOG_EXP)
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _141;
static float3 _144;
static float4 _178;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _144 : NORMAL;
    float4 _178 : TANGENT;
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
static float _163;
static float3 _224;
static float3 _238;

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
    vs_TEXCOORD0 = _141;
    _9.y = dot(_144, _21_m2[0].xyz);
    _9.z = dot(_144, _21_m2[1].xyz);
    _9.x = dot(_144, _21_m2[2].xyz);
    _163 = dot(_9.xyz, _9.xyz);
    _163 = rsqrt(_163);
    float3 _175 = _163.xxx * _9.xyz;
    _9 = float4(_175.x, _175.y, _175.z, _9.w);
    float3 _184 = _178.yyy * _21_m1[1].yzx;
    _44 = float4(_184.x, _184.y, _184.z, _44.w);
    float3 _195 = (_21_m1[0].yzx * _178.xxx) + _44.xyz;
    _44 = float4(_195.x, _195.y, _195.z, _44.w);
    float3 _206 = (_21_m1[2].yzx * _178.zzz) + _44.xyz;
    _44 = float4(_206.x, _206.y, _206.z, _44.w);
    _163 = dot(_44.xyz, _44.xyz);
    _163 = rsqrt(_163);
    float3 _220 = _163.xxx * _44.xyz;
    _44 = float4(_220.x, _220.y, _220.z, _44.w);
    _224 = _9.xyz * _44.xyz;
    _224 = (_9.zxy * _44.yzx) + (-_224);
    _238 = _224 * _178.www;
    _238 *= _21_m3.www;
    vs_TEXCOORD2.y = _238.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _238.y;
    vs_TEXCOORD4.y = _238.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _144 = stage_input._144;
    _178 = stage_input._178;
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
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _MainTex_ST;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
float4 _SpecularColor;
float _Shininess;
float _SpecularStrength;
float _ReflectionStrength;
float _ReflectionBlur;
float _IOR;
float _RefractWeight;
float _DispersionAmount;
float4 _InteriorColor;
float _InteriorDepth;
float _InteriorStrength;
float _InteriorScale;
float4 _NormalMap_ST;
float _NormalStrength;
float _NormalScrollSpeed;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _WorldSpaceLightPos0
#define _17_m3 unity_FogColor
#define _17_m4 unity_SpecCube0_HDR
#define _17_m5 _CoreColor
#define _17_m6 _EdgeColor
#define _17_m7 _FresnelPower
#define _17_m8 _MainTex_ST
#define _17_m9 _EmissionColor
#define _17_m10 _EmissionTex_ST
#define _17_m11 _EmissionBase
#define _17_m12 _EmissionPulse
#define _17_m13 _PulseSpeed
#define _17_m14 _SpecularColor
#define _17_m15 _Shininess
#define _17_m16 _SpecularStrength
#define _17_m17 _ReflectionStrength
#define _17_m18 _ReflectionBlur
#define _17_m19 _IOR
#define _17_m20 _RefractWeight
#define _17_m21 _DispersionAmount
#define _17_m22 _InteriorColor
#define _17_m23 _InteriorDepth
#define _17_m24 _InteriorStrength
#define _17_m25 _InteriorScale
#define _17_m26 _NormalMap_ST
#define _17_m27 _NormalStrength
#define _17_m28 _NormalScrollSpeed


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _571;
static float vs_TEXCOORD5;

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
    float4 _571 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _54;
static float2 _68;
static float2 _78;
static float3 _83;
static float _168;
static float3 _188;
static float _194;
static bool _212;
static float3 _223;
static float _245;
static float4 _254;
static float3 _265;
static float2 _302;
static float _314;
static float3 _352;
static float2 _367;
static float3 _372;
static float3 _532;
static float _587;
static float _687;
static float2 _784;
static float2 _793;
static float2 _817;
static float4 _841;
static float4 _861;
static float2 _917;
static float _1099;
static float _1166;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m26.xy) + _17_m26.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _31.x = _17_m0.y * _17_m28;
    float2 _50 = _31.xx * float2(0.699999988079071044921875f, 0.5f);
    _31 = float3(_31.x, _50.x, _50.y);
    _54 = _9.xy + _31.xy;
    float2 _65 = _9.xy + (-_31.zx);
    _9 = float3(_65.x, _65.y, _9.z);
    _68 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _9.xy)).xy;
    _78 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _54)).xy;
    float2 _90 = (_78 * 2.0f.xx) + (-1.0f).xx;
    _83 = float3(_90.x, _90.y, _83.z);
    float2 _97 = (_68 * 2.0f.xx) + _83.xy;
    _83 = float3(_97.x, _97.y, _83.z);
    float2 _102 = _83.xy + (-1.0f).xx;
    _83 = float3(_102.x, _102.y, _83.z);
    _9.x = _17_m27 * 0.5f;
    float2 _114 = _9.xx * _83.xy;
    _9 = float3(_114.x, _114.y, _9.z);
    _9.z = 1.0f;
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9.x = dot(vs_TEXCOORD2, _83);
    _9.y = dot(vs_TEXCOORD3, _83);
    _9.z = dot(vs_TEXCOORD4, _83);
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _168 = dot(_9, _9);
    _168 = rsqrt(_168);
    _9 = _168.xxx * _9;
    _168 = dot(-_9, _83);
    _31.x = ((-_168) * _168) + 1.0f;
    _188.x = 1.0f / _17_m19;
    _194 = _188.x * _188.x;
    _31.x = ((-_194) * _31.x) + 1.0f;
    _194 = sqrt(_31.x);
    _212 = _31.x >= 0.0f;
    _168 = (_188.x * _168) + _194;
    _223 = _83 * _168.xxx;
    _188 = (_188.xxx * (-_9)) + (-_223);
    float3 _238;
    if (_212)
    {
        _238 = _188;
    }
    else
    {
        _238 = 0.0f.xxx;
    }
    _31 = _238;
    _245 = dot(-_9, _83);
    _245 += _245;
    float3 _262 = (_83 * (-_245.xxx)) + (-_9);
    _254 = float4(_262.x, _262.y, _262.z, _254.w);
    _265 = _31 + (-_254.xyz);
    float3 _287 = (float3(float3(_17_m20, _17_m20, _17_m20)) * _265) + _254.xyz;
    _254 = float4(_287.x, _287.y, _287.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    _265 = _245.xxx * _254.xyz;
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _265, _17_m18).yw;
    _314 = _302.y + (-1.0f);
    _314 = (_17_m4.w * _314) + 1.0f;
    _314 = log2(_314);
    _314 *= _17_m4.y;
    _314 = exp2(_314);
    _314 *= _17_m4.x;
    _265.y = _302.x * _314;
    _31.x = vs_TEXCOORD2.x;
    _31.y = vs_TEXCOORD3.x;
    _31.z = vs_TEXCOORD4.x;
    _352 = _31 * float3(float3(_17_m21, _17_m21, _17_m21));
    _367.x = dot(_9, _31);
    _372 = (_254.xyz * _245.xxx) + _352;
    float3 _387 = (_254.xyz * _245.xxx) + (-_352);
    _254 = float4(_387.x, _387.y, _387.z, _254.w);
    _245 = dot(_372, _372);
    _245 = rsqrt(_245);
    _352 = _245.xxx * _372;
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _352, _17_m18).xw;
    _245 = _302.y + (-1.0f);
    _245 = (_17_m4.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m4.y;
    _245 = exp2(_245);
    _245 *= _17_m4.x;
    _265.x = _302.x * _245;
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _441 = _245.xxx * _254.xyz;
    _254 = float4(_441.x, _441.y, _441.z, _254.w);
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _254.xyz, _17_m18).zw;
    _245 = _302.y + (-1.0f);
    _245 = (_17_m4.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m4.y;
    _245 = exp2(_245);
    _245 *= _17_m4.x;
    _265.z = _302.x * _245;
    float3 _489 = _265 * float3(float3(_17_m17, _17_m17, _17_m17));
    _254 = float4(_489.x, _489.y, _489.z, _254.w);
    _245 = dot(_83, _9);
    _245 = clamp(_245, 0.0f, 1.0f);
    _168 = (-_245) + 1.0f;
    _168 = log2(_168);
    _168 *= _17_m7;
    _168 = exp2(_168);
    _31.x = (_168 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _31 = _31.xxx * _254.xyz;
    float2 _529 = (vs_TEXCOORD0 * _17_m8.xy) + _17_m8.zw;
    _223 = float3(_529.x, _529.y, _223.z);
    _532 = _MainTex.Sample(sampler_MainTex, _223.xy).xyz;
    _254 = (-_17_m5) + _17_m6;
    _254 = (_168.xxxx * _254) + _17_m5;
    _168 = ((-_168) * _168) + 1.0f;
    _168 *= _17_m24;
    _31 = (_254.xyz * _532) + _31;
    _571.w = _254.w;
    _223 = ((-vs_TEXCOORD1) * _17_m2.www) + _17_m2.xyz;
    _587 = dot(_223, _223);
    _587 = rsqrt(_587);
    float3 _598 = (_223 * _587.xxx) + _9;
    _254 = float4(_598.x, _598.y, _598.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _612 = _245.xxx * _254.xyz;
    _254 = float4(_612.x, _612.y, _612.z, _254.w);
    _83.x = dot(_83, _254.xyz);
    _83.x = clamp(_83.x, 0.0f, 1.0f);
    _83.x = log2(_83.x);
    _83.x *= _17_m15;
    _83.x = exp2(_83.x);
    _83.x *= _17_m16;
    _31 = (_17_m14.xyz * _83.xxx) + _31;
    _587 = _17_m0.y * _17_m13;
    _223.x = sin(_587);
    _587 = (_587 * 3.7000000476837158203125f) + 1.2999999523162841796875f;
    _587 = sin(_587);
    _223.x = (_223.x * 0.5f) + 0.5f;
    _223.x = (_17_m12 * _223.x) + _17_m11;
    _687 = _17_m12 * 0.119999997317790985107421875f;
    _587 = (_687 * _587) + _223.x;
    float2 _707 = (vs_TEXCOORD0 * _17_m10.xy) + _17_m10.zw;
    _223 = float3(_707.x, _707.y, _223.z);
    _532 = _EmissionTex.Sample(sampler_EmissionTex, _223.xy).xyz;
    _83 = _532 * _17_m9.xyz;
    _31 = (_83 * _587.xxx) + _31;
    _223.x = vs_TEXCOORD2.y;
    _223.y = vs_TEXCOORD3.y;
    _223.z = vs_TEXCOORD4.y;
    _367.y = dot(_9, _223);
    float2 _746 = _367 * _17_m23.xx;
    _9 = float3(_746.x, _746.y, _9.z);
    float2 _762 = (vs_TEXCOORD0 * float2(float2(_17_m25, _17_m25))) + _9.xy;
    _223 = float3(_762.x, _762.y, _223.z);
    float2 _769 = _9.xy * 1.7999999523162841796875f.xx;
    _9 = float3(_769.x, _769.y, _9.z);
    float2 _781 = (_17_m0.yy * float2(0.010999999940395355224609375f, 0.008000000379979610443115234375f)) + _223.xy;
    _223 = float3(_781.x, _781.y, _223.z);
    _784 = frac(_223.xy);
    float2 _790 = floor(_223.xy);
    _223 = float3(_790.x, _790.y, _223.z);
    _793 = _784 * _784;
    _784 = ((-_784) * 2.0f.xx) + 3.0f.xx;
    _784 *= _793;
    _793 = _223.xy + 1.0f.xx;
    _793 *= float2(443.897491455078125f, 397.29730224609375f);
    _793 = frac(_793);
    _817 = _793.yx + 19.1900005340576171875f.xx;
    _54.x = dot(_793, _817);
    _793 = _54.xx + _793;
    _54.x = _793.y * _793.x;
    _54.x = frac(_54.x);
    _841 = _223.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _848 = _223.xy * float2(443.897491455078125f, 397.29730224609375f);
    _223 = float3(_848.x, _848.y, _223.z);
    float2 _853 = frac(_223.xy);
    _223 = float3(_853.x, _853.y, _223.z);
    _841 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _841 = frac(_841);
    _861 = _841 + 19.1900005340576171875f.xxxx;
    _587 = dot(_841.wz, _861.zw);
    _793.x = dot(_841.yx, _861.xy);
    _793 = _841.yx + _793.xx;
    _817 = _587.xx + _841.wz;
    _587 = _817.y * _817.x;
    _587 = frac(_587);
    _793.x = _793.y * _793.x;
    _793.x = frac(_793.x);
    _54.x += (-_587);
    _54.x = (_784.x * _54.x) + _587;
    _917 = _223.yx + 19.1900005340576171875f.xx;
    _587 = dot(_223.xy, _917);
    float2 _929 = _587.xx + _223.xy;
    _223 = float3(_929.x, _929.y, _223.z);
    _587 = _223.y * _223.x;
    _587 = frac(_587);
    _223.x = (-_587) + _793.x;
    _587 = (_784.x * _223.x) + _587;
    _54.x += (-_587);
    _265.x = (_784.y * _54.x) + _587;
    _265.x = clamp(_265.x, 0.0f, 1.0f);
    _54.x = _265.x * _265.x;
    _54.x *= _54.x;
    _54.x *= _265.x;
    float2 _997 = vs_TEXCOORD0 * float2(float2(_17_m25, _17_m25));
    _223 = float3(_997.x, _997.y, _223.z);
    float2 _1007 = (_223.xy * 0.550000011920928955078125f.xx) + _9.xy;
    _9 = float3(_1007.x, _1007.y, _9.z);
    float2 _1019 = (_17_m0.yy * float2(-0.007000000216066837310791015625f, 0.0130000002682209014892578125f)) + _9.xy;
    _9 = float3(_1019.x, _1019.y, _9.z);
    float2 _1024 = frac(_9.xy);
    _223 = float3(_1024.x, _1024.y, _223.z);
    float2 _1029 = floor(_9.xy);
    _9 = float3(_1029.x, _1029.y, _9.z);
    _784 = _223.xy * _223.xy;
    float2 _1041 = ((-_223.xy) * 2.0f.xx) + 3.0f.xx;
    _223 = float3(_1041.x, _1041.y, _223.z);
    float2 _1047 = _223.xy * _784;
    _223 = float3(_1047.x, _1047.y, _223.z);
    _784 = _9.xy + 1.0f.xx;
    _784 *= float2(443.897491455078125f, 397.29730224609375f);
    _784 = frac(_784);
    _793 = _784.yx + 19.1900005340576171875f.xx;
    _587 = dot(_784, _793);
    _784 = _587.xx + _784;
    _587 = _784.y * _784.x;
    _587 = frac(_587);
    _841 = _9.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _1079 = _9.xy * float2(443.897491455078125f, 397.29730224609375f);
    _9 = float3(_1079.x, _1079.y, _9.z);
    float2 _1084 = frac(_9.xy);
    _9 = float3(_1084.x, _1084.y, _9.z);
    _841 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _841 = frac(_841);
    _861 = _841 + 19.1900005340576171875f.xxxx;
    _784.x = dot(_841.wz, _861.zw);
    _1099 = dot(_841.yx, _861.xy);
    _793 = _841.yx + _1099.xx;
    _784 = _841.wz + _784.xx;
    _784.x = _784.y * _784.x;
    _784.y = _793.y * _793.x;
    _784 = frac(_784);
    _587 += (-_784.x);
    _587 = (_223.x * _587) + _784.x;
    _793 = _9.yx + 19.1900005340576171875f.xx;
    _784.x = dot(_9.xy, _793);
    float2 _1153 = _9.xy + _784.xx;
    _9 = float3(_1153.x, _1153.y, _9.z);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1166 = (-_9.x) + _784.y;
    _9.x = (_223.x * _1166) + _9.x;
    _1166 = (-_9.x) + _587;
    _9.x = (_223.y * _1166) + _9.x;
    _265.x = _9.x * _9.x;
    _9.x = _265.x * 0.449999988079071044921875f;
    _265.x = (_54.x * 3.0f) + _9.x;
    _265.x = min(_265.x, 1.0f);
    _265 = _265.xxx * _17_m22.xyz;
    _9 = (_265 * _168.xxx) + _31;
    _9 += (-_17_m3.xyz);
    _168 = vs_TEXCOORD5;
    _168 = clamp(_168, 0.0f, 1.0f);
    _9 = (_168.xxx * _9) + _17_m3.xyz;
    _571 = float4(_9.x, _9.y, _9.z, _571.w);
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
    stage_output._571 = _571;
    return stage_output;
}

#endif
#elif defined(CRYSTAL_DISPERSION) && defined(FOG_EXP2)
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _147;
static float3 _150;
static float4 _184;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _150 : NORMAL;
    float4 _184 : TANGENT;
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
static float _169;
static float3 _230;
static float3 _244;

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
    vs_TEXCOORD0 = _147;
    _9.y = dot(_150, _21_m2[0].xyz);
    _9.z = dot(_150, _21_m2[1].xyz);
    _9.x = dot(_150, _21_m2[2].xyz);
    _169 = dot(_9.xyz, _9.xyz);
    _169 = rsqrt(_169);
    float3 _181 = _169.xxx * _9.xyz;
    _9 = float4(_181.x, _181.y, _181.z, _9.w);
    float3 _190 = _184.yyy * _21_m1[1].yzx;
    _44 = float4(_190.x, _190.y, _190.z, _44.w);
    float3 _201 = (_21_m1[0].yzx * _184.xxx) + _44.xyz;
    _44 = float4(_201.x, _201.y, _201.z, _44.w);
    float3 _212 = (_21_m1[2].yzx * _184.zzz) + _44.xyz;
    _44 = float4(_212.x, _212.y, _212.z, _44.w);
    _169 = dot(_44.xyz, _44.xyz);
    _169 = rsqrt(_169);
    float3 _226 = _169.xxx * _44.xyz;
    _44 = float4(_226.x, _226.y, _226.z, _44.w);
    _230 = _9.xyz * _44.xyz;
    _230 = (_9.zxy * _44.yzx) + (-_230);
    _244 = _230 * _184.www;
    _244 *= _21_m3.www;
    vs_TEXCOORD2.y = _244.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _244.y;
    vs_TEXCOORD4.y = _244.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _150 = stage_input._150;
    _184 = stage_input._184;
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
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _MainTex_ST;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
float4 _SpecularColor;
float _Shininess;
float _SpecularStrength;
float _ReflectionStrength;
float _ReflectionBlur;
float _IOR;
float _RefractWeight;
float _DispersionAmount;
float4 _InteriorColor;
float _InteriorDepth;
float _InteriorStrength;
float _InteriorScale;
float4 _NormalMap_ST;
float _NormalStrength;
float _NormalScrollSpeed;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _WorldSpaceLightPos0
#define _17_m3 unity_FogColor
#define _17_m4 unity_SpecCube0_HDR
#define _17_m5 _CoreColor
#define _17_m6 _EdgeColor
#define _17_m7 _FresnelPower
#define _17_m8 _MainTex_ST
#define _17_m9 _EmissionColor
#define _17_m10 _EmissionTex_ST
#define _17_m11 _EmissionBase
#define _17_m12 _EmissionPulse
#define _17_m13 _PulseSpeed
#define _17_m14 _SpecularColor
#define _17_m15 _Shininess
#define _17_m16 _SpecularStrength
#define _17_m17 _ReflectionStrength
#define _17_m18 _ReflectionBlur
#define _17_m19 _IOR
#define _17_m20 _RefractWeight
#define _17_m21 _DispersionAmount
#define _17_m22 _InteriorColor
#define _17_m23 _InteriorDepth
#define _17_m24 _InteriorStrength
#define _17_m25 _InteriorScale
#define _17_m26 _NormalMap_ST
#define _17_m27 _NormalStrength
#define _17_m28 _NormalScrollSpeed


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _571;
static float vs_TEXCOORD5;

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
    float4 _571 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _54;
static float2 _68;
static float2 _78;
static float3 _83;
static float _168;
static float3 _188;
static float _194;
static bool _212;
static float3 _223;
static float _245;
static float4 _254;
static float3 _265;
static float2 _302;
static float _314;
static float3 _352;
static float2 _367;
static float3 _372;
static float3 _532;
static float _587;
static float _687;
static float2 _784;
static float2 _793;
static float2 _817;
static float4 _841;
static float4 _861;
static float2 _917;
static float _1099;
static float _1166;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m26.xy) + _17_m26.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _31.x = _17_m0.y * _17_m28;
    float2 _50 = _31.xx * float2(0.699999988079071044921875f, 0.5f);
    _31 = float3(_31.x, _50.x, _50.y);
    _54 = _9.xy + _31.xy;
    float2 _65 = _9.xy + (-_31.zx);
    _9 = float3(_65.x, _65.y, _9.z);
    _68 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _9.xy)).xy;
    _78 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _54)).xy;
    float2 _90 = (_78 * 2.0f.xx) + (-1.0f).xx;
    _83 = float3(_90.x, _90.y, _83.z);
    float2 _97 = (_68 * 2.0f.xx) + _83.xy;
    _83 = float3(_97.x, _97.y, _83.z);
    float2 _102 = _83.xy + (-1.0f).xx;
    _83 = float3(_102.x, _102.y, _83.z);
    _9.x = _17_m27 * 0.5f;
    float2 _114 = _9.xx * _83.xy;
    _9 = float3(_114.x, _114.y, _9.z);
    _9.z = 1.0f;
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9.x = dot(vs_TEXCOORD2, _83);
    _9.y = dot(vs_TEXCOORD3, _83);
    _9.z = dot(vs_TEXCOORD4, _83);
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _168 = dot(_9, _9);
    _168 = rsqrt(_168);
    _9 = _168.xxx * _9;
    _168 = dot(-_9, _83);
    _31.x = ((-_168) * _168) + 1.0f;
    _188.x = 1.0f / _17_m19;
    _194 = _188.x * _188.x;
    _31.x = ((-_194) * _31.x) + 1.0f;
    _194 = sqrt(_31.x);
    _212 = _31.x >= 0.0f;
    _168 = (_188.x * _168) + _194;
    _223 = _83 * _168.xxx;
    _188 = (_188.xxx * (-_9)) + (-_223);
    float3 _238;
    if (_212)
    {
        _238 = _188;
    }
    else
    {
        _238 = 0.0f.xxx;
    }
    _31 = _238;
    _245 = dot(-_9, _83);
    _245 += _245;
    float3 _262 = (_83 * (-_245.xxx)) + (-_9);
    _254 = float4(_262.x, _262.y, _262.z, _254.w);
    _265 = _31 + (-_254.xyz);
    float3 _287 = (float3(float3(_17_m20, _17_m20, _17_m20)) * _265) + _254.xyz;
    _254 = float4(_287.x, _287.y, _287.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    _265 = _245.xxx * _254.xyz;
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _265, _17_m18).yw;
    _314 = _302.y + (-1.0f);
    _314 = (_17_m4.w * _314) + 1.0f;
    _314 = log2(_314);
    _314 *= _17_m4.y;
    _314 = exp2(_314);
    _314 *= _17_m4.x;
    _265.y = _302.x * _314;
    _31.x = vs_TEXCOORD2.x;
    _31.y = vs_TEXCOORD3.x;
    _31.z = vs_TEXCOORD4.x;
    _352 = _31 * float3(float3(_17_m21, _17_m21, _17_m21));
    _367.x = dot(_9, _31);
    _372 = (_254.xyz * _245.xxx) + _352;
    float3 _387 = (_254.xyz * _245.xxx) + (-_352);
    _254 = float4(_387.x, _387.y, _387.z, _254.w);
    _245 = dot(_372, _372);
    _245 = rsqrt(_245);
    _352 = _245.xxx * _372;
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _352, _17_m18).xw;
    _245 = _302.y + (-1.0f);
    _245 = (_17_m4.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m4.y;
    _245 = exp2(_245);
    _245 *= _17_m4.x;
    _265.x = _302.x * _245;
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _441 = _245.xxx * _254.xyz;
    _254 = float4(_441.x, _441.y, _441.z, _254.w);
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _254.xyz, _17_m18).zw;
    _245 = _302.y + (-1.0f);
    _245 = (_17_m4.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m4.y;
    _245 = exp2(_245);
    _245 *= _17_m4.x;
    _265.z = _302.x * _245;
    float3 _489 = _265 * float3(float3(_17_m17, _17_m17, _17_m17));
    _254 = float4(_489.x, _489.y, _489.z, _254.w);
    _245 = dot(_83, _9);
    _245 = clamp(_245, 0.0f, 1.0f);
    _168 = (-_245) + 1.0f;
    _168 = log2(_168);
    _168 *= _17_m7;
    _168 = exp2(_168);
    _31.x = (_168 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _31 = _31.xxx * _254.xyz;
    float2 _529 = (vs_TEXCOORD0 * _17_m8.xy) + _17_m8.zw;
    _223 = float3(_529.x, _529.y, _223.z);
    _532 = _MainTex.Sample(sampler_MainTex, _223.xy).xyz;
    _254 = (-_17_m5) + _17_m6;
    _254 = (_168.xxxx * _254) + _17_m5;
    _168 = ((-_168) * _168) + 1.0f;
    _168 *= _17_m24;
    _31 = (_254.xyz * _532) + _31;
    _571.w = _254.w;
    _223 = ((-vs_TEXCOORD1) * _17_m2.www) + _17_m2.xyz;
    _587 = dot(_223, _223);
    _587 = rsqrt(_587);
    float3 _598 = (_223 * _587.xxx) + _9;
    _254 = float4(_598.x, _598.y, _598.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _612 = _245.xxx * _254.xyz;
    _254 = float4(_612.x, _612.y, _612.z, _254.w);
    _83.x = dot(_83, _254.xyz);
    _83.x = clamp(_83.x, 0.0f, 1.0f);
    _83.x = log2(_83.x);
    _83.x *= _17_m15;
    _83.x = exp2(_83.x);
    _83.x *= _17_m16;
    _31 = (_17_m14.xyz * _83.xxx) + _31;
    _587 = _17_m0.y * _17_m13;
    _223.x = sin(_587);
    _587 = (_587 * 3.7000000476837158203125f) + 1.2999999523162841796875f;
    _587 = sin(_587);
    _223.x = (_223.x * 0.5f) + 0.5f;
    _223.x = (_17_m12 * _223.x) + _17_m11;
    _687 = _17_m12 * 0.119999997317790985107421875f;
    _587 = (_687 * _587) + _223.x;
    float2 _707 = (vs_TEXCOORD0 * _17_m10.xy) + _17_m10.zw;
    _223 = float3(_707.x, _707.y, _223.z);
    _532 = _EmissionTex.Sample(sampler_EmissionTex, _223.xy).xyz;
    _83 = _532 * _17_m9.xyz;
    _31 = (_83 * _587.xxx) + _31;
    _223.x = vs_TEXCOORD2.y;
    _223.y = vs_TEXCOORD3.y;
    _223.z = vs_TEXCOORD4.y;
    _367.y = dot(_9, _223);
    float2 _746 = _367 * _17_m23.xx;
    _9 = float3(_746.x, _746.y, _9.z);
    float2 _762 = (vs_TEXCOORD0 * float2(float2(_17_m25, _17_m25))) + _9.xy;
    _223 = float3(_762.x, _762.y, _223.z);
    float2 _769 = _9.xy * 1.7999999523162841796875f.xx;
    _9 = float3(_769.x, _769.y, _9.z);
    float2 _781 = (_17_m0.yy * float2(0.010999999940395355224609375f, 0.008000000379979610443115234375f)) + _223.xy;
    _223 = float3(_781.x, _781.y, _223.z);
    _784 = frac(_223.xy);
    float2 _790 = floor(_223.xy);
    _223 = float3(_790.x, _790.y, _223.z);
    _793 = _784 * _784;
    _784 = ((-_784) * 2.0f.xx) + 3.0f.xx;
    _784 *= _793;
    _793 = _223.xy + 1.0f.xx;
    _793 *= float2(443.897491455078125f, 397.29730224609375f);
    _793 = frac(_793);
    _817 = _793.yx + 19.1900005340576171875f.xx;
    _54.x = dot(_793, _817);
    _793 = _54.xx + _793;
    _54.x = _793.y * _793.x;
    _54.x = frac(_54.x);
    _841 = _223.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _848 = _223.xy * float2(443.897491455078125f, 397.29730224609375f);
    _223 = float3(_848.x, _848.y, _223.z);
    float2 _853 = frac(_223.xy);
    _223 = float3(_853.x, _853.y, _223.z);
    _841 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _841 = frac(_841);
    _861 = _841 + 19.1900005340576171875f.xxxx;
    _587 = dot(_841.wz, _861.zw);
    _793.x = dot(_841.yx, _861.xy);
    _793 = _841.yx + _793.xx;
    _817 = _587.xx + _841.wz;
    _587 = _817.y * _817.x;
    _587 = frac(_587);
    _793.x = _793.y * _793.x;
    _793.x = frac(_793.x);
    _54.x += (-_587);
    _54.x = (_784.x * _54.x) + _587;
    _917 = _223.yx + 19.1900005340576171875f.xx;
    _587 = dot(_223.xy, _917);
    float2 _929 = _587.xx + _223.xy;
    _223 = float3(_929.x, _929.y, _223.z);
    _587 = _223.y * _223.x;
    _587 = frac(_587);
    _223.x = (-_587) + _793.x;
    _587 = (_784.x * _223.x) + _587;
    _54.x += (-_587);
    _265.x = (_784.y * _54.x) + _587;
    _265.x = clamp(_265.x, 0.0f, 1.0f);
    _54.x = _265.x * _265.x;
    _54.x *= _54.x;
    _54.x *= _265.x;
    float2 _997 = vs_TEXCOORD0 * float2(float2(_17_m25, _17_m25));
    _223 = float3(_997.x, _997.y, _223.z);
    float2 _1007 = (_223.xy * 0.550000011920928955078125f.xx) + _9.xy;
    _9 = float3(_1007.x, _1007.y, _9.z);
    float2 _1019 = (_17_m0.yy * float2(-0.007000000216066837310791015625f, 0.0130000002682209014892578125f)) + _9.xy;
    _9 = float3(_1019.x, _1019.y, _9.z);
    float2 _1024 = frac(_9.xy);
    _223 = float3(_1024.x, _1024.y, _223.z);
    float2 _1029 = floor(_9.xy);
    _9 = float3(_1029.x, _1029.y, _9.z);
    _784 = _223.xy * _223.xy;
    float2 _1041 = ((-_223.xy) * 2.0f.xx) + 3.0f.xx;
    _223 = float3(_1041.x, _1041.y, _223.z);
    float2 _1047 = _223.xy * _784;
    _223 = float3(_1047.x, _1047.y, _223.z);
    _784 = _9.xy + 1.0f.xx;
    _784 *= float2(443.897491455078125f, 397.29730224609375f);
    _784 = frac(_784);
    _793 = _784.yx + 19.1900005340576171875f.xx;
    _587 = dot(_784, _793);
    _784 = _587.xx + _784;
    _587 = _784.y * _784.x;
    _587 = frac(_587);
    _841 = _9.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _1079 = _9.xy * float2(443.897491455078125f, 397.29730224609375f);
    _9 = float3(_1079.x, _1079.y, _9.z);
    float2 _1084 = frac(_9.xy);
    _9 = float3(_1084.x, _1084.y, _9.z);
    _841 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _841 = frac(_841);
    _861 = _841 + 19.1900005340576171875f.xxxx;
    _784.x = dot(_841.wz, _861.zw);
    _1099 = dot(_841.yx, _861.xy);
    _793 = _841.yx + _1099.xx;
    _784 = _841.wz + _784.xx;
    _784.x = _784.y * _784.x;
    _784.y = _793.y * _793.x;
    _784 = frac(_784);
    _587 += (-_784.x);
    _587 = (_223.x * _587) + _784.x;
    _793 = _9.yx + 19.1900005340576171875f.xx;
    _784.x = dot(_9.xy, _793);
    float2 _1153 = _9.xy + _784.xx;
    _9 = float3(_1153.x, _1153.y, _9.z);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1166 = (-_9.x) + _784.y;
    _9.x = (_223.x * _1166) + _9.x;
    _1166 = (-_9.x) + _587;
    _9.x = (_223.y * _1166) + _9.x;
    _265.x = _9.x * _9.x;
    _9.x = _265.x * 0.449999988079071044921875f;
    _265.x = (_54.x * 3.0f) + _9.x;
    _265.x = min(_265.x, 1.0f);
    _265 = _265.xxx * _17_m22.xyz;
    _9 = (_265 * _168.xxx) + _31;
    _9 += (-_17_m3.xyz);
    _168 = vs_TEXCOORD5;
    _168 = clamp(_168, 0.0f, 1.0f);
    _9 = (_168.xxx * _9) + _17_m3.xyz;
    _571 = float4(_9.x, _9.y, _9.z, _571.w);
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
    stage_output._571 = _571;
    return stage_output;
}

#endif
#elif defined(CRYSTAL_DISPERSION) && defined(FOG_LINEAR)
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _143;
static float4 _177;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
    float4 _177 : TANGENT;
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
static float _162;
static float3 _223;
static float3 _237;

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
    vs_TEXCOORD0 = _140;
    _9.y = dot(_143, _21_m2[0].xyz);
    _9.z = dot(_143, _21_m2[1].xyz);
    _9.x = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    float3 _174 = _162.xxx * _9.xyz;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    float3 _183 = _177.yyy * _21_m1[1].yzx;
    _44 = float4(_183.x, _183.y, _183.z, _44.w);
    float3 _194 = (_21_m1[0].yzx * _177.xxx) + _44.xyz;
    _44 = float4(_194.x, _194.y, _194.z, _44.w);
    float3 _205 = (_21_m1[2].yzx * _177.zzz) + _44.xyz;
    _44 = float4(_205.x, _205.y, _205.z, _44.w);
    _162 = dot(_44.xyz, _44.xyz);
    _162 = rsqrt(_162);
    float3 _219 = _162.xxx * _44.xyz;
    _44 = float4(_219.x, _219.y, _219.z, _44.w);
    _223 = _9.xyz * _44.xyz;
    _223 = (_9.zxy * _44.yzx) + (-_223);
    _237 = _223 * _177.www;
    _237 *= _21_m3.www;
    vs_TEXCOORD2.y = _237.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _237.y;
    vs_TEXCOORD4.y = _237.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _143 = stage_input._143;
    _177 = stage_input._177;
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
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _MainTex_ST;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
float4 _SpecularColor;
float _Shininess;
float _SpecularStrength;
float _ReflectionStrength;
float _ReflectionBlur;
float _IOR;
float _RefractWeight;
float _DispersionAmount;
float4 _InteriorColor;
float _InteriorDepth;
float _InteriorStrength;
float _InteriorScale;
float4 _NormalMap_ST;
float _NormalStrength;
float _NormalScrollSpeed;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _WorldSpaceLightPos0
#define _17_m3 unity_FogColor
#define _17_m4 unity_SpecCube0_HDR
#define _17_m5 _CoreColor
#define _17_m6 _EdgeColor
#define _17_m7 _FresnelPower
#define _17_m8 _MainTex_ST
#define _17_m9 _EmissionColor
#define _17_m10 _EmissionTex_ST
#define _17_m11 _EmissionBase
#define _17_m12 _EmissionPulse
#define _17_m13 _PulseSpeed
#define _17_m14 _SpecularColor
#define _17_m15 _Shininess
#define _17_m16 _SpecularStrength
#define _17_m17 _ReflectionStrength
#define _17_m18 _ReflectionBlur
#define _17_m19 _IOR
#define _17_m20 _RefractWeight
#define _17_m21 _DispersionAmount
#define _17_m22 _InteriorColor
#define _17_m23 _InteriorDepth
#define _17_m24 _InteriorStrength
#define _17_m25 _InteriorScale
#define _17_m26 _NormalMap_ST
#define _17_m27 _NormalStrength
#define _17_m28 _NormalScrollSpeed


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _571;
static float vs_TEXCOORD5;

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
    float4 _571 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _54;
static float2 _68;
static float2 _78;
static float3 _83;
static float _168;
static float3 _188;
static float _194;
static bool _212;
static float3 _223;
static float _245;
static float4 _254;
static float3 _265;
static float2 _302;
static float _314;
static float3 _352;
static float2 _367;
static float3 _372;
static float3 _532;
static float _587;
static float _687;
static float2 _784;
static float2 _793;
static float2 _817;
static float4 _841;
static float4 _861;
static float2 _917;
static float _1099;
static float _1166;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m26.xy) + _17_m26.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _31.x = _17_m0.y * _17_m28;
    float2 _50 = _31.xx * float2(0.699999988079071044921875f, 0.5f);
    _31 = float3(_31.x, _50.x, _50.y);
    _54 = _9.xy + _31.xy;
    float2 _65 = _9.xy + (-_31.zx);
    _9 = float3(_65.x, _65.y, _9.z);
    _68 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _9.xy)).xy;
    _78 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _54)).xy;
    float2 _90 = (_78 * 2.0f.xx) + (-1.0f).xx;
    _83 = float3(_90.x, _90.y, _83.z);
    float2 _97 = (_68 * 2.0f.xx) + _83.xy;
    _83 = float3(_97.x, _97.y, _83.z);
    float2 _102 = _83.xy + (-1.0f).xx;
    _83 = float3(_102.x, _102.y, _83.z);
    _9.x = _17_m27 * 0.5f;
    float2 _114 = _9.xx * _83.xy;
    _9 = float3(_114.x, _114.y, _9.z);
    _9.z = 1.0f;
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9.x = dot(vs_TEXCOORD2, _83);
    _9.y = dot(vs_TEXCOORD3, _83);
    _9.z = dot(vs_TEXCOORD4, _83);
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _168 = dot(_9, _9);
    _168 = rsqrt(_168);
    _9 = _168.xxx * _9;
    _168 = dot(-_9, _83);
    _31.x = ((-_168) * _168) + 1.0f;
    _188.x = 1.0f / _17_m19;
    _194 = _188.x * _188.x;
    _31.x = ((-_194) * _31.x) + 1.0f;
    _194 = sqrt(_31.x);
    _212 = _31.x >= 0.0f;
    _168 = (_188.x * _168) + _194;
    _223 = _83 * _168.xxx;
    _188 = (_188.xxx * (-_9)) + (-_223);
    float3 _238;
    if (_212)
    {
        _238 = _188;
    }
    else
    {
        _238 = 0.0f.xxx;
    }
    _31 = _238;
    _245 = dot(-_9, _83);
    _245 += _245;
    float3 _262 = (_83 * (-_245.xxx)) + (-_9);
    _254 = float4(_262.x, _262.y, _262.z, _254.w);
    _265 = _31 + (-_254.xyz);
    float3 _287 = (float3(float3(_17_m20, _17_m20, _17_m20)) * _265) + _254.xyz;
    _254 = float4(_287.x, _287.y, _287.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    _265 = _245.xxx * _254.xyz;
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _265, _17_m18).yw;
    _314 = _302.y + (-1.0f);
    _314 = (_17_m4.w * _314) + 1.0f;
    _314 = log2(_314);
    _314 *= _17_m4.y;
    _314 = exp2(_314);
    _314 *= _17_m4.x;
    _265.y = _302.x * _314;
    _31.x = vs_TEXCOORD2.x;
    _31.y = vs_TEXCOORD3.x;
    _31.z = vs_TEXCOORD4.x;
    _352 = _31 * float3(float3(_17_m21, _17_m21, _17_m21));
    _367.x = dot(_9, _31);
    _372 = (_254.xyz * _245.xxx) + _352;
    float3 _387 = (_254.xyz * _245.xxx) + (-_352);
    _254 = float4(_387.x, _387.y, _387.z, _254.w);
    _245 = dot(_372, _372);
    _245 = rsqrt(_245);
    _352 = _245.xxx * _372;
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _352, _17_m18).xw;
    _245 = _302.y + (-1.0f);
    _245 = (_17_m4.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m4.y;
    _245 = exp2(_245);
    _245 *= _17_m4.x;
    _265.x = _302.x * _245;
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _441 = _245.xxx * _254.xyz;
    _254 = float4(_441.x, _441.y, _441.z, _254.w);
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _254.xyz, _17_m18).zw;
    _245 = _302.y + (-1.0f);
    _245 = (_17_m4.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m4.y;
    _245 = exp2(_245);
    _245 *= _17_m4.x;
    _265.z = _302.x * _245;
    float3 _489 = _265 * float3(float3(_17_m17, _17_m17, _17_m17));
    _254 = float4(_489.x, _489.y, _489.z, _254.w);
    _245 = dot(_83, _9);
    _245 = clamp(_245, 0.0f, 1.0f);
    _168 = (-_245) + 1.0f;
    _168 = log2(_168);
    _168 *= _17_m7;
    _168 = exp2(_168);
    _31.x = (_168 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _31 = _31.xxx * _254.xyz;
    float2 _529 = (vs_TEXCOORD0 * _17_m8.xy) + _17_m8.zw;
    _223 = float3(_529.x, _529.y, _223.z);
    _532 = _MainTex.Sample(sampler_MainTex, _223.xy).xyz;
    _254 = (-_17_m5) + _17_m6;
    _254 = (_168.xxxx * _254) + _17_m5;
    _168 = ((-_168) * _168) + 1.0f;
    _168 *= _17_m24;
    _31 = (_254.xyz * _532) + _31;
    _571.w = _254.w;
    _223 = ((-vs_TEXCOORD1) * _17_m2.www) + _17_m2.xyz;
    _587 = dot(_223, _223);
    _587 = rsqrt(_587);
    float3 _598 = (_223 * _587.xxx) + _9;
    _254 = float4(_598.x, _598.y, _598.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _612 = _245.xxx * _254.xyz;
    _254 = float4(_612.x, _612.y, _612.z, _254.w);
    _83.x = dot(_83, _254.xyz);
    _83.x = clamp(_83.x, 0.0f, 1.0f);
    _83.x = log2(_83.x);
    _83.x *= _17_m15;
    _83.x = exp2(_83.x);
    _83.x *= _17_m16;
    _31 = (_17_m14.xyz * _83.xxx) + _31;
    _587 = _17_m0.y * _17_m13;
    _223.x = sin(_587);
    _587 = (_587 * 3.7000000476837158203125f) + 1.2999999523162841796875f;
    _587 = sin(_587);
    _223.x = (_223.x * 0.5f) + 0.5f;
    _223.x = (_17_m12 * _223.x) + _17_m11;
    _687 = _17_m12 * 0.119999997317790985107421875f;
    _587 = (_687 * _587) + _223.x;
    float2 _707 = (vs_TEXCOORD0 * _17_m10.xy) + _17_m10.zw;
    _223 = float3(_707.x, _707.y, _223.z);
    _532 = _EmissionTex.Sample(sampler_EmissionTex, _223.xy).xyz;
    _83 = _532 * _17_m9.xyz;
    _31 = (_83 * _587.xxx) + _31;
    _223.x = vs_TEXCOORD2.y;
    _223.y = vs_TEXCOORD3.y;
    _223.z = vs_TEXCOORD4.y;
    _367.y = dot(_9, _223);
    float2 _746 = _367 * _17_m23.xx;
    _9 = float3(_746.x, _746.y, _9.z);
    float2 _762 = (vs_TEXCOORD0 * float2(float2(_17_m25, _17_m25))) + _9.xy;
    _223 = float3(_762.x, _762.y, _223.z);
    float2 _769 = _9.xy * 1.7999999523162841796875f.xx;
    _9 = float3(_769.x, _769.y, _9.z);
    float2 _781 = (_17_m0.yy * float2(0.010999999940395355224609375f, 0.008000000379979610443115234375f)) + _223.xy;
    _223 = float3(_781.x, _781.y, _223.z);
    _784 = frac(_223.xy);
    float2 _790 = floor(_223.xy);
    _223 = float3(_790.x, _790.y, _223.z);
    _793 = _784 * _784;
    _784 = ((-_784) * 2.0f.xx) + 3.0f.xx;
    _784 *= _793;
    _793 = _223.xy + 1.0f.xx;
    _793 *= float2(443.897491455078125f, 397.29730224609375f);
    _793 = frac(_793);
    _817 = _793.yx + 19.1900005340576171875f.xx;
    _54.x = dot(_793, _817);
    _793 = _54.xx + _793;
    _54.x = _793.y * _793.x;
    _54.x = frac(_54.x);
    _841 = _223.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _848 = _223.xy * float2(443.897491455078125f, 397.29730224609375f);
    _223 = float3(_848.x, _848.y, _223.z);
    float2 _853 = frac(_223.xy);
    _223 = float3(_853.x, _853.y, _223.z);
    _841 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _841 = frac(_841);
    _861 = _841 + 19.1900005340576171875f.xxxx;
    _587 = dot(_841.wz, _861.zw);
    _793.x = dot(_841.yx, _861.xy);
    _793 = _841.yx + _793.xx;
    _817 = _587.xx + _841.wz;
    _587 = _817.y * _817.x;
    _587 = frac(_587);
    _793.x = _793.y * _793.x;
    _793.x = frac(_793.x);
    _54.x += (-_587);
    _54.x = (_784.x * _54.x) + _587;
    _917 = _223.yx + 19.1900005340576171875f.xx;
    _587 = dot(_223.xy, _917);
    float2 _929 = _587.xx + _223.xy;
    _223 = float3(_929.x, _929.y, _223.z);
    _587 = _223.y * _223.x;
    _587 = frac(_587);
    _223.x = (-_587) + _793.x;
    _587 = (_784.x * _223.x) + _587;
    _54.x += (-_587);
    _265.x = (_784.y * _54.x) + _587;
    _265.x = clamp(_265.x, 0.0f, 1.0f);
    _54.x = _265.x * _265.x;
    _54.x *= _54.x;
    _54.x *= _265.x;
    float2 _997 = vs_TEXCOORD0 * float2(float2(_17_m25, _17_m25));
    _223 = float3(_997.x, _997.y, _223.z);
    float2 _1007 = (_223.xy * 0.550000011920928955078125f.xx) + _9.xy;
    _9 = float3(_1007.x, _1007.y, _9.z);
    float2 _1019 = (_17_m0.yy * float2(-0.007000000216066837310791015625f, 0.0130000002682209014892578125f)) + _9.xy;
    _9 = float3(_1019.x, _1019.y, _9.z);
    float2 _1024 = frac(_9.xy);
    _223 = float3(_1024.x, _1024.y, _223.z);
    float2 _1029 = floor(_9.xy);
    _9 = float3(_1029.x, _1029.y, _9.z);
    _784 = _223.xy * _223.xy;
    float2 _1041 = ((-_223.xy) * 2.0f.xx) + 3.0f.xx;
    _223 = float3(_1041.x, _1041.y, _223.z);
    float2 _1047 = _223.xy * _784;
    _223 = float3(_1047.x, _1047.y, _223.z);
    _784 = _9.xy + 1.0f.xx;
    _784 *= float2(443.897491455078125f, 397.29730224609375f);
    _784 = frac(_784);
    _793 = _784.yx + 19.1900005340576171875f.xx;
    _587 = dot(_784, _793);
    _784 = _587.xx + _784;
    _587 = _784.y * _784.x;
    _587 = frac(_587);
    _841 = _9.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _1079 = _9.xy * float2(443.897491455078125f, 397.29730224609375f);
    _9 = float3(_1079.x, _1079.y, _9.z);
    float2 _1084 = frac(_9.xy);
    _9 = float3(_1084.x, _1084.y, _9.z);
    _841 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _841 = frac(_841);
    _861 = _841 + 19.1900005340576171875f.xxxx;
    _784.x = dot(_841.wz, _861.zw);
    _1099 = dot(_841.yx, _861.xy);
    _793 = _841.yx + _1099.xx;
    _784 = _841.wz + _784.xx;
    _784.x = _784.y * _784.x;
    _784.y = _793.y * _793.x;
    _784 = frac(_784);
    _587 += (-_784.x);
    _587 = (_223.x * _587) + _784.x;
    _793 = _9.yx + 19.1900005340576171875f.xx;
    _784.x = dot(_9.xy, _793);
    float2 _1153 = _9.xy + _784.xx;
    _9 = float3(_1153.x, _1153.y, _9.z);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1166 = (-_9.x) + _784.y;
    _9.x = (_223.x * _1166) + _9.x;
    _1166 = (-_9.x) + _587;
    _9.x = (_223.y * _1166) + _9.x;
    _265.x = _9.x * _9.x;
    _9.x = _265.x * 0.449999988079071044921875f;
    _265.x = (_54.x * 3.0f) + _9.x;
    _265.x = min(_265.x, 1.0f);
    _265 = _265.xxx * _17_m22.xyz;
    _9 = (_265 * _168.xxx) + _31;
    _9 += (-_17_m3.xyz);
    _168 = vs_TEXCOORD5;
    _168 = clamp(_168, 0.0f, 1.0f);
    _9 = (_168.xxx * _9) + _17_m3.xyz;
    _571 = float4(_9.x, _9.y, _9.z, _571.w);
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
    stage_output._571 = _571;
    return stage_output;
}

#endif
#elif defined(CRYSTAL_DISPERSION)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4 unity_WorldTransformParams;
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _102;
static float4 _139;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _102 : NORMAL;
    float4 _139 : TANGENT;
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
static float _124;
static float3 _185;
static float3 _199;

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
    vs_TEXCOORD0 = _99;
    _9.y = dot(_102, _21_m1[0].xyz);
    _9.z = dot(_102, _21_m1[1].xyz);
    _9.x = dot(_102, _21_m1[2].xyz);
    _124 = dot(_9.xyz, _9.xyz);
    _124 = rsqrt(_124);
    float3 _136 = _124.xxx * _9.xyz;
    _9 = float4(_136.x, _136.y, _136.z, _9.w);
    float3 _145 = _139.yyy * _21_m0[1].yzx;
    _44 = float4(_145.x, _145.y, _145.z, _44.w);
    float3 _156 = (_21_m0[0].yzx * _139.xxx) + _44.xyz;
    _44 = float4(_156.x, _156.y, _156.z, _44.w);
    float3 _167 = (_21_m0[2].yzx * _139.zzz) + _44.xyz;
    _44 = float4(_167.x, _167.y, _167.z, _44.w);
    _124 = dot(_44.xyz, _44.xyz);
    _124 = rsqrt(_124);
    float3 _181 = _124.xxx * _44.xyz;
    _44 = float4(_181.x, _181.y, _181.z, _44.w);
    _185 = _9.xyz * _44.xyz;
    _185 = (_9.zxy * _44.yzx) + (-_185);
    _199 = _185 * _139.www;
    _199 *= _21_m2.www;
    vs_TEXCOORD2.y = _199.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _199.y;
    vs_TEXCOORD4.y = _199.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _102 = stage_input._102;
    _139 = stage_input._139;
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
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SpecCube0_HDR;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _MainTex_ST;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
float4 _SpecularColor;
float _Shininess;
float _SpecularStrength;
float _ReflectionStrength;
float _ReflectionBlur;
float _IOR;
float _RefractWeight;
float _DispersionAmount;
float4 _InteriorColor;
float _InteriorDepth;
float _InteriorStrength;
float _InteriorScale;
float4 _NormalMap_ST;
float _NormalStrength;
float _NormalScrollSpeed;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _WorldSpaceLightPos0
#define _17_m3 unity_SpecCube0_HDR
#define _17_m4 _CoreColor
#define _17_m5 _EdgeColor
#define _17_m6 _FresnelPower
#define _17_m7 _MainTex_ST
#define _17_m8 _EmissionColor
#define _17_m9 _EmissionTex_ST
#define _17_m10 _EmissionBase
#define _17_m11 _EmissionPulse
#define _17_m12 _PulseSpeed
#define _17_m13 _SpecularColor
#define _17_m14 _Shininess
#define _17_m15 _SpecularStrength
#define _17_m16 _ReflectionStrength
#define _17_m17 _ReflectionBlur
#define _17_m18 _IOR
#define _17_m19 _RefractWeight
#define _17_m20 _DispersionAmount
#define _17_m21 _InteriorColor
#define _17_m22 _InteriorDepth
#define _17_m23 _InteriorStrength
#define _17_m24 _InteriorScale
#define _17_m25 _NormalMap_ST
#define _17_m26 _NormalStrength
#define _17_m27 _NormalScrollSpeed


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _571;

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
    float4 _571 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _54;
static float2 _68;
static float2 _78;
static float3 _83;
static float _168;
static float3 _188;
static float _194;
static bool _212;
static float3 _223;
static float _245;
static float4 _254;
static float3 _265;
static float2 _302;
static float _314;
static float3 _352;
static float2 _367;
static float3 _372;
static float3 _532;
static float _587;
static float _687;
static float2 _784;
static float2 _793;
static float2 _817;
static float4 _841;
static float4 _861;
static float2 _917;
static float _1099;
static float _1166;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m25.xy) + _17_m25.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _31.x = _17_m0.y * _17_m27;
    float2 _50 = _31.xx * float2(0.699999988079071044921875f, 0.5f);
    _31 = float3(_31.x, _50.x, _50.y);
    _54 = _9.xy + _31.xy;
    float2 _65 = _9.xy + (-_31.zx);
    _9 = float3(_65.x, _65.y, _9.z);
    _68 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _9.xy)).xy;
    _78 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _54)).xy;
    float2 _90 = (_78 * 2.0f.xx) + (-1.0f).xx;
    _83 = float3(_90.x, _90.y, _83.z);
    float2 _97 = (_68 * 2.0f.xx) + _83.xy;
    _83 = float3(_97.x, _97.y, _83.z);
    float2 _102 = _83.xy + (-1.0f).xx;
    _83 = float3(_102.x, _102.y, _83.z);
    _9.x = _17_m26 * 0.5f;
    float2 _114 = _9.xx * _83.xy;
    _9 = float3(_114.x, _114.y, _9.z);
    _9.z = 1.0f;
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9.x = dot(vs_TEXCOORD2, _83);
    _9.y = dot(vs_TEXCOORD3, _83);
    _9.z = dot(vs_TEXCOORD4, _83);
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _168 = dot(_9, _9);
    _168 = rsqrt(_168);
    _9 = _168.xxx * _9;
    _168 = dot(-_9, _83);
    _31.x = ((-_168) * _168) + 1.0f;
    _188.x = 1.0f / _17_m18;
    _194 = _188.x * _188.x;
    _31.x = ((-_194) * _31.x) + 1.0f;
    _194 = sqrt(_31.x);
    _212 = _31.x >= 0.0f;
    _168 = (_188.x * _168) + _194;
    _223 = _83 * _168.xxx;
    _188 = (_188.xxx * (-_9)) + (-_223);
    float3 _238;
    if (_212)
    {
        _238 = _188;
    }
    else
    {
        _238 = 0.0f.xxx;
    }
    _31 = _238;
    _245 = dot(-_9, _83);
    _245 += _245;
    float3 _262 = (_83 * (-_245.xxx)) + (-_9);
    _254 = float4(_262.x, _262.y, _262.z, _254.w);
    _265 = _31 + (-_254.xyz);
    float3 _287 = (float3(float3(_17_m19, _17_m19, _17_m19)) * _265) + _254.xyz;
    _254 = float4(_287.x, _287.y, _287.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    _265 = _245.xxx * _254.xyz;
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _265, _17_m17).yw;
    _314 = _302.y + (-1.0f);
    _314 = (_17_m3.w * _314) + 1.0f;
    _314 = log2(_314);
    _314 *= _17_m3.y;
    _314 = exp2(_314);
    _314 *= _17_m3.x;
    _265.y = _302.x * _314;
    _31.x = vs_TEXCOORD2.x;
    _31.y = vs_TEXCOORD3.x;
    _31.z = vs_TEXCOORD4.x;
    _352 = _31 * float3(float3(_17_m20, _17_m20, _17_m20));
    _367.x = dot(_9, _31);
    _372 = (_254.xyz * _245.xxx) + _352;
    float3 _387 = (_254.xyz * _245.xxx) + (-_352);
    _254 = float4(_387.x, _387.y, _387.z, _254.w);
    _245 = dot(_372, _372);
    _245 = rsqrt(_245);
    _352 = _245.xxx * _372;
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _352, _17_m17).xw;
    _245 = _302.y + (-1.0f);
    _245 = (_17_m3.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m3.y;
    _245 = exp2(_245);
    _245 *= _17_m3.x;
    _265.x = _302.x * _245;
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _441 = _245.xxx * _254.xyz;
    _254 = float4(_441.x, _441.y, _441.z, _254.w);
    _302 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _254.xyz, _17_m17).zw;
    _245 = _302.y + (-1.0f);
    _245 = (_17_m3.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m3.y;
    _245 = exp2(_245);
    _245 *= _17_m3.x;
    _265.z = _302.x * _245;
    float3 _489 = _265 * float3(float3(_17_m16, _17_m16, _17_m16));
    _254 = float4(_489.x, _489.y, _489.z, _254.w);
    _245 = dot(_83, _9);
    _245 = clamp(_245, 0.0f, 1.0f);
    _168 = (-_245) + 1.0f;
    _168 = log2(_168);
    _168 *= _17_m6;
    _168 = exp2(_168);
    _31.x = (_168 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _31 = _31.xxx * _254.xyz;
    float2 _529 = (vs_TEXCOORD0 * _17_m7.xy) + _17_m7.zw;
    _223 = float3(_529.x, _529.y, _223.z);
    _532 = _MainTex.Sample(sampler_MainTex, _223.xy).xyz;
    _254 = (-_17_m4) + _17_m5;
    _254 = (_168.xxxx * _254) + _17_m4;
    _168 = ((-_168) * _168) + 1.0f;
    _168 *= _17_m23;
    _31 = (_254.xyz * _532) + _31;
    _571.w = _254.w;
    _223 = ((-vs_TEXCOORD1) * _17_m2.www) + _17_m2.xyz;
    _587 = dot(_223, _223);
    _587 = rsqrt(_587);
    float3 _598 = (_223 * _587.xxx) + _9;
    _254 = float4(_598.x, _598.y, _598.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _612 = _245.xxx * _254.xyz;
    _254 = float4(_612.x, _612.y, _612.z, _254.w);
    _83.x = dot(_83, _254.xyz);
    _83.x = clamp(_83.x, 0.0f, 1.0f);
    _83.x = log2(_83.x);
    _83.x *= _17_m14;
    _83.x = exp2(_83.x);
    _83.x *= _17_m15;
    _31 = (_17_m13.xyz * _83.xxx) + _31;
    _587 = _17_m0.y * _17_m12;
    _223.x = sin(_587);
    _587 = (_587 * 3.7000000476837158203125f) + 1.2999999523162841796875f;
    _587 = sin(_587);
    _223.x = (_223.x * 0.5f) + 0.5f;
    _223.x = (_17_m11 * _223.x) + _17_m10;
    _687 = _17_m11 * 0.119999997317790985107421875f;
    _587 = (_687 * _587) + _223.x;
    float2 _707 = (vs_TEXCOORD0 * _17_m9.xy) + _17_m9.zw;
    _223 = float3(_707.x, _707.y, _223.z);
    _532 = _EmissionTex.Sample(sampler_EmissionTex, _223.xy).xyz;
    _83 = _532 * _17_m8.xyz;
    _31 = (_83 * _587.xxx) + _31;
    _223.x = vs_TEXCOORD2.y;
    _223.y = vs_TEXCOORD3.y;
    _223.z = vs_TEXCOORD4.y;
    _367.y = dot(_9, _223);
    float2 _746 = _367 * _17_m22.xx;
    _9 = float3(_746.x, _746.y, _9.z);
    float2 _762 = (vs_TEXCOORD0 * float2(float2(_17_m24, _17_m24))) + _9.xy;
    _223 = float3(_762.x, _762.y, _223.z);
    float2 _769 = _9.xy * 1.7999999523162841796875f.xx;
    _9 = float3(_769.x, _769.y, _9.z);
    float2 _781 = (_17_m0.yy * float2(0.010999999940395355224609375f, 0.008000000379979610443115234375f)) + _223.xy;
    _223 = float3(_781.x, _781.y, _223.z);
    _784 = frac(_223.xy);
    float2 _790 = floor(_223.xy);
    _223 = float3(_790.x, _790.y, _223.z);
    _793 = _784 * _784;
    _784 = ((-_784) * 2.0f.xx) + 3.0f.xx;
    _784 *= _793;
    _793 = _223.xy + 1.0f.xx;
    _793 *= float2(443.897491455078125f, 397.29730224609375f);
    _793 = frac(_793);
    _817 = _793.yx + 19.1900005340576171875f.xx;
    _54.x = dot(_793, _817);
    _793 = _54.xx + _793;
    _54.x = _793.y * _793.x;
    _54.x = frac(_54.x);
    _841 = _223.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _848 = _223.xy * float2(443.897491455078125f, 397.29730224609375f);
    _223 = float3(_848.x, _848.y, _223.z);
    float2 _853 = frac(_223.xy);
    _223 = float3(_853.x, _853.y, _223.z);
    _841 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _841 = frac(_841);
    _861 = _841 + 19.1900005340576171875f.xxxx;
    _587 = dot(_841.wz, _861.zw);
    _793.x = dot(_841.yx, _861.xy);
    _793 = _841.yx + _793.xx;
    _817 = _587.xx + _841.wz;
    _587 = _817.y * _817.x;
    _587 = frac(_587);
    _793.x = _793.y * _793.x;
    _793.x = frac(_793.x);
    _54.x += (-_587);
    _54.x = (_784.x * _54.x) + _587;
    _917 = _223.yx + 19.1900005340576171875f.xx;
    _587 = dot(_223.xy, _917);
    float2 _929 = _587.xx + _223.xy;
    _223 = float3(_929.x, _929.y, _223.z);
    _587 = _223.y * _223.x;
    _587 = frac(_587);
    _223.x = (-_587) + _793.x;
    _587 = (_784.x * _223.x) + _587;
    _54.x += (-_587);
    _265.x = (_784.y * _54.x) + _587;
    _265.x = clamp(_265.x, 0.0f, 1.0f);
    _54.x = _265.x * _265.x;
    _54.x *= _54.x;
    _54.x *= _265.x;
    float2 _997 = vs_TEXCOORD0 * float2(float2(_17_m24, _17_m24));
    _223 = float3(_997.x, _997.y, _223.z);
    float2 _1007 = (_223.xy * 0.550000011920928955078125f.xx) + _9.xy;
    _9 = float3(_1007.x, _1007.y, _9.z);
    float2 _1019 = (_17_m0.yy * float2(-0.007000000216066837310791015625f, 0.0130000002682209014892578125f)) + _9.xy;
    _9 = float3(_1019.x, _1019.y, _9.z);
    float2 _1024 = frac(_9.xy);
    _223 = float3(_1024.x, _1024.y, _223.z);
    float2 _1029 = floor(_9.xy);
    _9 = float3(_1029.x, _1029.y, _9.z);
    _784 = _223.xy * _223.xy;
    float2 _1041 = ((-_223.xy) * 2.0f.xx) + 3.0f.xx;
    _223 = float3(_1041.x, _1041.y, _223.z);
    float2 _1047 = _223.xy * _784;
    _223 = float3(_1047.x, _1047.y, _223.z);
    _784 = _9.xy + 1.0f.xx;
    _784 *= float2(443.897491455078125f, 397.29730224609375f);
    _784 = frac(_784);
    _793 = _784.yx + 19.1900005340576171875f.xx;
    _587 = dot(_784, _793);
    _784 = _587.xx + _784;
    _587 = _784.y * _784.x;
    _587 = frac(_587);
    _841 = _9.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _1079 = _9.xy * float2(443.897491455078125f, 397.29730224609375f);
    _9 = float3(_1079.x, _1079.y, _9.z);
    float2 _1084 = frac(_9.xy);
    _9 = float3(_1084.x, _1084.y, _9.z);
    _841 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _841 = frac(_841);
    _861 = _841 + 19.1900005340576171875f.xxxx;
    _784.x = dot(_841.wz, _861.zw);
    _1099 = dot(_841.yx, _861.xy);
    _793 = _841.yx + _1099.xx;
    _784 = _841.wz + _784.xx;
    _784.x = _784.y * _784.x;
    _784.y = _793.y * _793.x;
    _784 = frac(_784);
    _587 += (-_784.x);
    _587 = (_223.x * _587) + _784.x;
    _793 = _9.yx + 19.1900005340576171875f.xx;
    _784.x = dot(_9.xy, _793);
    float2 _1153 = _9.xy + _784.xx;
    _9 = float3(_1153.x, _1153.y, _9.z);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1166 = (-_9.x) + _784.y;
    _9.x = (_223.x * _1166) + _9.x;
    _1166 = (-_9.x) + _587;
    _9.x = (_223.y * _1166) + _9.x;
    _265.x = _9.x * _9.x;
    _9.x = _265.x * 0.449999988079071044921875f;
    _265.x = (_54.x * 3.0f) + _9.x;
    _265.x = min(_265.x, 1.0f);
    _265 = _265.xxx * _17_m21.xyz;
    _9 = (_265 * _168.xxx) + _31;
    _571 = float4(_9.x, _9.y, _9.z, _571.w);
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
    stage_output._571 = _571;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _141;
static float3 _144;
static float4 _178;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _144 : NORMAL;
    float4 _178 : TANGENT;
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
static float _163;
static float3 _224;
static float3 _238;

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
    vs_TEXCOORD0 = _141;
    _9.y = dot(_144, _21_m2[0].xyz);
    _9.z = dot(_144, _21_m2[1].xyz);
    _9.x = dot(_144, _21_m2[2].xyz);
    _163 = dot(_9.xyz, _9.xyz);
    _163 = rsqrt(_163);
    float3 _175 = _163.xxx * _9.xyz;
    _9 = float4(_175.x, _175.y, _175.z, _9.w);
    float3 _184 = _178.yyy * _21_m1[1].yzx;
    _44 = float4(_184.x, _184.y, _184.z, _44.w);
    float3 _195 = (_21_m1[0].yzx * _178.xxx) + _44.xyz;
    _44 = float4(_195.x, _195.y, _195.z, _44.w);
    float3 _206 = (_21_m1[2].yzx * _178.zzz) + _44.xyz;
    _44 = float4(_206.x, _206.y, _206.z, _44.w);
    _163 = dot(_44.xyz, _44.xyz);
    _163 = rsqrt(_163);
    float3 _220 = _163.xxx * _44.xyz;
    _44 = float4(_220.x, _220.y, _220.z, _44.w);
    _224 = _9.xyz * _44.xyz;
    _224 = (_9.zxy * _44.yzx) + (-_224);
    _238 = _224 * _178.www;
    _238 *= _21_m3.www;
    vs_TEXCOORD2.y = _238.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _238.y;
    vs_TEXCOORD4.y = _238.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _144 = stage_input._144;
    _178 = stage_input._178;
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
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _MainTex_ST;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
float4 _SpecularColor;
float _Shininess;
float _SpecularStrength;
float _ReflectionStrength;
float _ReflectionBlur;
float _IOR;
float _RefractWeight;
float4 _InteriorColor;
float _InteriorDepth;
float _InteriorStrength;
float _InteriorScale;
float4 _NormalMap_ST;
float _NormalStrength;
float _NormalScrollSpeed;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _WorldSpaceLightPos0
#define _17_m3 unity_FogColor
#define _17_m4 unity_SpecCube0_HDR
#define _17_m5 _CoreColor
#define _17_m6 _EdgeColor
#define _17_m7 _FresnelPower
#define _17_m8 _MainTex_ST
#define _17_m9 _EmissionColor
#define _17_m10 _EmissionTex_ST
#define _17_m11 _EmissionBase
#define _17_m12 _EmissionPulse
#define _17_m13 _PulseSpeed
#define _17_m14 _SpecularColor
#define _17_m15 _Shininess
#define _17_m16 _SpecularStrength
#define _17_m17 _ReflectionStrength
#define _17_m18 _ReflectionBlur
#define _17_m19 _IOR
#define _17_m20 _RefractWeight
#define _17_m21 _InteriorColor
#define _17_m22 _InteriorDepth
#define _17_m23 _InteriorStrength
#define _17_m24 _InteriorScale
#define _17_m25 _NormalMap_ST
#define _17_m26 _NormalStrength
#define _17_m27 _NormalScrollSpeed


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _441;
static float vs_TEXCOORD5;

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
    float4 _441 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _54;
static float2 _68;
static float2 _78;
static float3 _83;
static float _168;
static float3 _188;
static float _194;
static bool _212;
static float3 _223;
static float _245;
static float4 _254;
static float3 _265;
static float4 _304;
static float3 _402;
static float _457;
static float _557;
static float2 _669;
static float2 _678;
static float2 _702;
static float4 _726;
static float4 _746;
static float2 _802;
static float _984;
static float _1051;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m25.xy) + _17_m25.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _31.x = _17_m0.y * _17_m27;
    float2 _50 = _31.xx * float2(0.699999988079071044921875f, 0.5f);
    _31 = float3(_31.x, _50.x, _50.y);
    _54 = _9.xy + _31.xy;
    float2 _65 = _9.xy + (-_31.zx);
    _9 = float3(_65.x, _65.y, _9.z);
    _68 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _9.xy)).xy;
    _78 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _54)).xy;
    float2 _90 = (_78 * 2.0f.xx) + (-1.0f).xx;
    _83 = float3(_90.x, _90.y, _83.z);
    float2 _97 = (_68 * 2.0f.xx) + _83.xy;
    _83 = float3(_97.x, _97.y, _83.z);
    float2 _102 = _83.xy + (-1.0f).xx;
    _83 = float3(_102.x, _102.y, _83.z);
    _9.x = _17_m26 * 0.5f;
    float2 _114 = _9.xx * _83.xy;
    _9 = float3(_114.x, _114.y, _9.z);
    _9.z = 1.0f;
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9.x = dot(vs_TEXCOORD2, _83);
    _9.y = dot(vs_TEXCOORD3, _83);
    _9.z = dot(vs_TEXCOORD4, _83);
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _168 = dot(_9, _9);
    _168 = rsqrt(_168);
    _9 = _168.xxx * _9;
    _168 = dot(-_9, _83);
    _31.x = ((-_168) * _168) + 1.0f;
    _188.x = 1.0f / _17_m19;
    _194 = _188.x * _188.x;
    _31.x = ((-_194) * _31.x) + 1.0f;
    _194 = sqrt(_31.x);
    _212 = _31.x >= 0.0f;
    _168 = (_188.x * _168) + _194;
    _223 = _83 * _168.xxx;
    _188 = (_188.xxx * (-_9)) + (-_223);
    float3 _238;
    if (_212)
    {
        _238 = _188;
    }
    else
    {
        _238 = 0.0f.xxx;
    }
    _31 = _238;
    _245 = dot(-_9, _83);
    _245 += _245;
    float3 _262 = (_83 * (-_245.xxx)) + (-_9);
    _254 = float4(_262.x, _262.y, _262.z, _254.w);
    _265 = _31 + (-_254.xyz);
    float3 _287 = (float3(float3(_17_m20, _17_m20, _17_m20)) * _265) + _254.xyz;
    _254 = float4(_287.x, _287.y, _287.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _301 = _245.xxx * _254.xyz;
    _254 = float4(_301.x, _301.y, _301.z, _254.w);
    _304 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _254.xyz, _17_m18);
    _245 = _304.w + (-1.0f);
    _245 = (_17_m4.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m4.y;
    _245 = exp2(_245);
    _245 *= _17_m4.x;
    float3 _342 = _304.xyz * _245.xxx;
    _254 = float4(_342.x, _342.y, _342.z, _254.w);
    float3 _359 = _254.xyz * float3(float3(_17_m17, _17_m17, _17_m17));
    _254 = float4(_359.x, _359.y, _359.z, _254.w);
    _245 = dot(_83, _9);
    _245 = clamp(_245, 0.0f, 1.0f);
    _168 = (-_245) + 1.0f;
    _168 = log2(_168);
    _168 *= _17_m7;
    _168 = exp2(_168);
    _31.x = (_168 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _31 = _31.xxx * _254.xyz;
    float2 _399 = (vs_TEXCOORD0 * _17_m8.xy) + _17_m8.zw;
    _223 = float3(_399.x, _399.y, _223.z);
    _402 = _MainTex.Sample(sampler_MainTex, _223.xy).xyz;
    _254 = (-_17_m5) + _17_m6;
    _254 = (_168.xxxx * _254) + _17_m5;
    _168 = ((-_168) * _168) + 1.0f;
    _168 *= _17_m23;
    _31 = (_254.xyz * _402) + _31;
    _441.w = _254.w;
    _223 = ((-vs_TEXCOORD1) * _17_m2.www) + _17_m2.xyz;
    _457 = dot(_223, _223);
    _457 = rsqrt(_457);
    float3 _468 = (_223 * _457.xxx) + _9;
    _254 = float4(_468.x, _468.y, _468.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _482 = _245.xxx * _254.xyz;
    _254 = float4(_482.x, _482.y, _482.z, _254.w);
    _83.x = dot(_83, _254.xyz);
    _83.x = clamp(_83.x, 0.0f, 1.0f);
    _83.x = log2(_83.x);
    _83.x *= _17_m15;
    _83.x = exp2(_83.x);
    _83.x *= _17_m16;
    _31 = (_17_m14.xyz * _83.xxx) + _31;
    _457 = _17_m0.y * _17_m13;
    _223.x = sin(_457);
    _457 = (_457 * 3.7000000476837158203125f) + 1.2999999523162841796875f;
    _457 = sin(_457);
    _223.x = (_223.x * 0.5f) + 0.5f;
    _223.x = (_17_m12 * _223.x) + _17_m11;
    _557 = _17_m12 * 0.119999997317790985107421875f;
    _457 = (_557 * _457) + _223.x;
    float2 _577 = (vs_TEXCOORD0 * _17_m10.xy) + _17_m10.zw;
    _223 = float3(_577.x, _577.y, _223.z);
    _402 = _EmissionTex.Sample(sampler_EmissionTex, _223.xy).xyz;
    _83 = _402 * _17_m9.xyz;
    _31 = (_83 * _457.xxx) + _31;
    _223.x = vs_TEXCOORD2.x;
    _223.y = vs_TEXCOORD3.x;
    _223.z = vs_TEXCOORD4.x;
    _83.x = dot(_9, _223);
    _223.x = vs_TEXCOORD2.y;
    _223.y = vs_TEXCOORD3.y;
    _223.z = vs_TEXCOORD4.y;
    _83.y = dot(_9, _223);
    float2 _631 = _83.xy * _17_m22.xx;
    _9 = float3(_631.x, _631.y, _9.z);
    float2 _647 = (vs_TEXCOORD0 * float2(float2(_17_m24, _17_m24))) + _9.xy;
    _223 = float3(_647.x, _647.y, _223.z);
    float2 _654 = _9.xy * 1.7999999523162841796875f.xx;
    _9 = float3(_654.x, _654.y, _9.z);
    float2 _666 = (_17_m0.yy * float2(0.010999999940395355224609375f, 0.008000000379979610443115234375f)) + _223.xy;
    _223 = float3(_666.x, _666.y, _223.z);
    _669 = frac(_223.xy);
    float2 _675 = floor(_223.xy);
    _223 = float3(_675.x, _675.y, _223.z);
    _678 = _669 * _669;
    _669 = ((-_669) * 2.0f.xx) + 3.0f.xx;
    _669 *= _678;
    _678 = _223.xy + 1.0f.xx;
    _678 *= float2(443.897491455078125f, 397.29730224609375f);
    _678 = frac(_678);
    _702 = _678.yx + 19.1900005340576171875f.xx;
    _54.x = dot(_678, _702);
    _678 = _54.xx + _678;
    _54.x = _678.y * _678.x;
    _54.x = frac(_54.x);
    _726 = _223.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _733 = _223.xy * float2(443.897491455078125f, 397.29730224609375f);
    _223 = float3(_733.x, _733.y, _223.z);
    float2 _738 = frac(_223.xy);
    _223 = float3(_738.x, _738.y, _223.z);
    _726 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _726 = frac(_726);
    _746 = _726 + 19.1900005340576171875f.xxxx;
    _457 = dot(_726.wz, _746.zw);
    _678.x = dot(_726.yx, _746.xy);
    _678 = _726.yx + _678.xx;
    _702 = _457.xx + _726.wz;
    _457 = _702.y * _702.x;
    _457 = frac(_457);
    _678.x = _678.y * _678.x;
    _678.x = frac(_678.x);
    _54.x += (-_457);
    _54.x = (_669.x * _54.x) + _457;
    _802 = _223.yx + 19.1900005340576171875f.xx;
    _457 = dot(_223.xy, _802);
    float2 _814 = _457.xx + _223.xy;
    _223 = float3(_814.x, _814.y, _223.z);
    _457 = _223.y * _223.x;
    _457 = frac(_457);
    _223.x = (-_457) + _678.x;
    _457 = (_669.x * _223.x) + _457;
    _54.x += (-_457);
    _265.x = (_669.y * _54.x) + _457;
    _265.x = clamp(_265.x, 0.0f, 1.0f);
    _54.x = _265.x * _265.x;
    _54.x *= _54.x;
    _54.x *= _265.x;
    float2 _882 = vs_TEXCOORD0 * float2(float2(_17_m24, _17_m24));
    _223 = float3(_882.x, _882.y, _223.z);
    float2 _892 = (_223.xy * 0.550000011920928955078125f.xx) + _9.xy;
    _9 = float3(_892.x, _892.y, _9.z);
    float2 _904 = (_17_m0.yy * float2(-0.007000000216066837310791015625f, 0.0130000002682209014892578125f)) + _9.xy;
    _9 = float3(_904.x, _904.y, _9.z);
    float2 _909 = frac(_9.xy);
    _223 = float3(_909.x, _909.y, _223.z);
    float2 _914 = floor(_9.xy);
    _9 = float3(_914.x, _914.y, _9.z);
    _669 = _223.xy * _223.xy;
    float2 _926 = ((-_223.xy) * 2.0f.xx) + 3.0f.xx;
    _223 = float3(_926.x, _926.y, _223.z);
    float2 _932 = _223.xy * _669;
    _223 = float3(_932.x, _932.y, _223.z);
    _669 = _9.xy + 1.0f.xx;
    _669 *= float2(443.897491455078125f, 397.29730224609375f);
    _669 = frac(_669);
    _678 = _669.yx + 19.1900005340576171875f.xx;
    _457 = dot(_669, _678);
    _669 = _457.xx + _669;
    _457 = _669.y * _669.x;
    _457 = frac(_457);
    _726 = _9.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _964 = _9.xy * float2(443.897491455078125f, 397.29730224609375f);
    _9 = float3(_964.x, _964.y, _9.z);
    float2 _969 = frac(_9.xy);
    _9 = float3(_969.x, _969.y, _9.z);
    _726 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _726 = frac(_726);
    _746 = _726 + 19.1900005340576171875f.xxxx;
    _669.x = dot(_726.wz, _746.zw);
    _984 = dot(_726.yx, _746.xy);
    _678 = _726.yx + _984.xx;
    _669 = _726.wz + _669.xx;
    _669.x = _669.y * _669.x;
    _669.y = _678.y * _678.x;
    _669 = frac(_669);
    _457 += (-_669.x);
    _457 = (_223.x * _457) + _669.x;
    _678 = _9.yx + 19.1900005340576171875f.xx;
    _669.x = dot(_9.xy, _678);
    float2 _1038 = _9.xy + _669.xx;
    _9 = float3(_1038.x, _1038.y, _9.z);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1051 = (-_9.x) + _669.y;
    _9.x = (_223.x * _1051) + _9.x;
    _1051 = (-_9.x) + _457;
    _9.x = (_223.y * _1051) + _9.x;
    _265.x = _9.x * _9.x;
    _9.x = _265.x * 0.449999988079071044921875f;
    _265.x = (_54.x * 3.0f) + _9.x;
    _265.x = min(_265.x, 1.0f);
    _265 = _265.xxx * _17_m21.xyz;
    _9 = (_265 * _168.xxx) + _31;
    _9 += (-_17_m3.xyz);
    _168 = vs_TEXCOORD5;
    _168 = clamp(_168, 0.0f, 1.0f);
    _9 = (_168.xxx * _9) + _17_m3.xyz;
    _441 = float4(_9.x, _9.y, _9.z, _441.w);
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
    stage_output._441 = _441;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _147;
static float3 _150;
static float4 _184;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _150 : NORMAL;
    float4 _184 : TANGENT;
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
static float _169;
static float3 _230;
static float3 _244;

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
    vs_TEXCOORD0 = _147;
    _9.y = dot(_150, _21_m2[0].xyz);
    _9.z = dot(_150, _21_m2[1].xyz);
    _9.x = dot(_150, _21_m2[2].xyz);
    _169 = dot(_9.xyz, _9.xyz);
    _169 = rsqrt(_169);
    float3 _181 = _169.xxx * _9.xyz;
    _9 = float4(_181.x, _181.y, _181.z, _9.w);
    float3 _190 = _184.yyy * _21_m1[1].yzx;
    _44 = float4(_190.x, _190.y, _190.z, _44.w);
    float3 _201 = (_21_m1[0].yzx * _184.xxx) + _44.xyz;
    _44 = float4(_201.x, _201.y, _201.z, _44.w);
    float3 _212 = (_21_m1[2].yzx * _184.zzz) + _44.xyz;
    _44 = float4(_212.x, _212.y, _212.z, _44.w);
    _169 = dot(_44.xyz, _44.xyz);
    _169 = rsqrt(_169);
    float3 _226 = _169.xxx * _44.xyz;
    _44 = float4(_226.x, _226.y, _226.z, _44.w);
    _230 = _9.xyz * _44.xyz;
    _230 = (_9.zxy * _44.yzx) + (-_230);
    _244 = _230 * _184.www;
    _244 *= _21_m3.www;
    vs_TEXCOORD2.y = _244.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _244.y;
    vs_TEXCOORD4.y = _244.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _150 = stage_input._150;
    _184 = stage_input._184;
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
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _MainTex_ST;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
float4 _SpecularColor;
float _Shininess;
float _SpecularStrength;
float _ReflectionStrength;
float _ReflectionBlur;
float _IOR;
float _RefractWeight;
float4 _InteriorColor;
float _InteriorDepth;
float _InteriorStrength;
float _InteriorScale;
float4 _NormalMap_ST;
float _NormalStrength;
float _NormalScrollSpeed;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _WorldSpaceLightPos0
#define _17_m3 unity_FogColor
#define _17_m4 unity_SpecCube0_HDR
#define _17_m5 _CoreColor
#define _17_m6 _EdgeColor
#define _17_m7 _FresnelPower
#define _17_m8 _MainTex_ST
#define _17_m9 _EmissionColor
#define _17_m10 _EmissionTex_ST
#define _17_m11 _EmissionBase
#define _17_m12 _EmissionPulse
#define _17_m13 _PulseSpeed
#define _17_m14 _SpecularColor
#define _17_m15 _Shininess
#define _17_m16 _SpecularStrength
#define _17_m17 _ReflectionStrength
#define _17_m18 _ReflectionBlur
#define _17_m19 _IOR
#define _17_m20 _RefractWeight
#define _17_m21 _InteriorColor
#define _17_m22 _InteriorDepth
#define _17_m23 _InteriorStrength
#define _17_m24 _InteriorScale
#define _17_m25 _NormalMap_ST
#define _17_m26 _NormalStrength
#define _17_m27 _NormalScrollSpeed


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _441;
static float vs_TEXCOORD5;

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
    float4 _441 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _54;
static float2 _68;
static float2 _78;
static float3 _83;
static float _168;
static float3 _188;
static float _194;
static bool _212;
static float3 _223;
static float _245;
static float4 _254;
static float3 _265;
static float4 _304;
static float3 _402;
static float _457;
static float _557;
static float2 _669;
static float2 _678;
static float2 _702;
static float4 _726;
static float4 _746;
static float2 _802;
static float _984;
static float _1051;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m25.xy) + _17_m25.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _31.x = _17_m0.y * _17_m27;
    float2 _50 = _31.xx * float2(0.699999988079071044921875f, 0.5f);
    _31 = float3(_31.x, _50.x, _50.y);
    _54 = _9.xy + _31.xy;
    float2 _65 = _9.xy + (-_31.zx);
    _9 = float3(_65.x, _65.y, _9.z);
    _68 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _9.xy)).xy;
    _78 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _54)).xy;
    float2 _90 = (_78 * 2.0f.xx) + (-1.0f).xx;
    _83 = float3(_90.x, _90.y, _83.z);
    float2 _97 = (_68 * 2.0f.xx) + _83.xy;
    _83 = float3(_97.x, _97.y, _83.z);
    float2 _102 = _83.xy + (-1.0f).xx;
    _83 = float3(_102.x, _102.y, _83.z);
    _9.x = _17_m26 * 0.5f;
    float2 _114 = _9.xx * _83.xy;
    _9 = float3(_114.x, _114.y, _9.z);
    _9.z = 1.0f;
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9.x = dot(vs_TEXCOORD2, _83);
    _9.y = dot(vs_TEXCOORD3, _83);
    _9.z = dot(vs_TEXCOORD4, _83);
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _168 = dot(_9, _9);
    _168 = rsqrt(_168);
    _9 = _168.xxx * _9;
    _168 = dot(-_9, _83);
    _31.x = ((-_168) * _168) + 1.0f;
    _188.x = 1.0f / _17_m19;
    _194 = _188.x * _188.x;
    _31.x = ((-_194) * _31.x) + 1.0f;
    _194 = sqrt(_31.x);
    _212 = _31.x >= 0.0f;
    _168 = (_188.x * _168) + _194;
    _223 = _83 * _168.xxx;
    _188 = (_188.xxx * (-_9)) + (-_223);
    float3 _238;
    if (_212)
    {
        _238 = _188;
    }
    else
    {
        _238 = 0.0f.xxx;
    }
    _31 = _238;
    _245 = dot(-_9, _83);
    _245 += _245;
    float3 _262 = (_83 * (-_245.xxx)) + (-_9);
    _254 = float4(_262.x, _262.y, _262.z, _254.w);
    _265 = _31 + (-_254.xyz);
    float3 _287 = (float3(float3(_17_m20, _17_m20, _17_m20)) * _265) + _254.xyz;
    _254 = float4(_287.x, _287.y, _287.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _301 = _245.xxx * _254.xyz;
    _254 = float4(_301.x, _301.y, _301.z, _254.w);
    _304 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _254.xyz, _17_m18);
    _245 = _304.w + (-1.0f);
    _245 = (_17_m4.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m4.y;
    _245 = exp2(_245);
    _245 *= _17_m4.x;
    float3 _342 = _304.xyz * _245.xxx;
    _254 = float4(_342.x, _342.y, _342.z, _254.w);
    float3 _359 = _254.xyz * float3(float3(_17_m17, _17_m17, _17_m17));
    _254 = float4(_359.x, _359.y, _359.z, _254.w);
    _245 = dot(_83, _9);
    _245 = clamp(_245, 0.0f, 1.0f);
    _168 = (-_245) + 1.0f;
    _168 = log2(_168);
    _168 *= _17_m7;
    _168 = exp2(_168);
    _31.x = (_168 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _31 = _31.xxx * _254.xyz;
    float2 _399 = (vs_TEXCOORD0 * _17_m8.xy) + _17_m8.zw;
    _223 = float3(_399.x, _399.y, _223.z);
    _402 = _MainTex.Sample(sampler_MainTex, _223.xy).xyz;
    _254 = (-_17_m5) + _17_m6;
    _254 = (_168.xxxx * _254) + _17_m5;
    _168 = ((-_168) * _168) + 1.0f;
    _168 *= _17_m23;
    _31 = (_254.xyz * _402) + _31;
    _441.w = _254.w;
    _223 = ((-vs_TEXCOORD1) * _17_m2.www) + _17_m2.xyz;
    _457 = dot(_223, _223);
    _457 = rsqrt(_457);
    float3 _468 = (_223 * _457.xxx) + _9;
    _254 = float4(_468.x, _468.y, _468.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _482 = _245.xxx * _254.xyz;
    _254 = float4(_482.x, _482.y, _482.z, _254.w);
    _83.x = dot(_83, _254.xyz);
    _83.x = clamp(_83.x, 0.0f, 1.0f);
    _83.x = log2(_83.x);
    _83.x *= _17_m15;
    _83.x = exp2(_83.x);
    _83.x *= _17_m16;
    _31 = (_17_m14.xyz * _83.xxx) + _31;
    _457 = _17_m0.y * _17_m13;
    _223.x = sin(_457);
    _457 = (_457 * 3.7000000476837158203125f) + 1.2999999523162841796875f;
    _457 = sin(_457);
    _223.x = (_223.x * 0.5f) + 0.5f;
    _223.x = (_17_m12 * _223.x) + _17_m11;
    _557 = _17_m12 * 0.119999997317790985107421875f;
    _457 = (_557 * _457) + _223.x;
    float2 _577 = (vs_TEXCOORD0 * _17_m10.xy) + _17_m10.zw;
    _223 = float3(_577.x, _577.y, _223.z);
    _402 = _EmissionTex.Sample(sampler_EmissionTex, _223.xy).xyz;
    _83 = _402 * _17_m9.xyz;
    _31 = (_83 * _457.xxx) + _31;
    _223.x = vs_TEXCOORD2.x;
    _223.y = vs_TEXCOORD3.x;
    _223.z = vs_TEXCOORD4.x;
    _83.x = dot(_9, _223);
    _223.x = vs_TEXCOORD2.y;
    _223.y = vs_TEXCOORD3.y;
    _223.z = vs_TEXCOORD4.y;
    _83.y = dot(_9, _223);
    float2 _631 = _83.xy * _17_m22.xx;
    _9 = float3(_631.x, _631.y, _9.z);
    float2 _647 = (vs_TEXCOORD0 * float2(float2(_17_m24, _17_m24))) + _9.xy;
    _223 = float3(_647.x, _647.y, _223.z);
    float2 _654 = _9.xy * 1.7999999523162841796875f.xx;
    _9 = float3(_654.x, _654.y, _9.z);
    float2 _666 = (_17_m0.yy * float2(0.010999999940395355224609375f, 0.008000000379979610443115234375f)) + _223.xy;
    _223 = float3(_666.x, _666.y, _223.z);
    _669 = frac(_223.xy);
    float2 _675 = floor(_223.xy);
    _223 = float3(_675.x, _675.y, _223.z);
    _678 = _669 * _669;
    _669 = ((-_669) * 2.0f.xx) + 3.0f.xx;
    _669 *= _678;
    _678 = _223.xy + 1.0f.xx;
    _678 *= float2(443.897491455078125f, 397.29730224609375f);
    _678 = frac(_678);
    _702 = _678.yx + 19.1900005340576171875f.xx;
    _54.x = dot(_678, _702);
    _678 = _54.xx + _678;
    _54.x = _678.y * _678.x;
    _54.x = frac(_54.x);
    _726 = _223.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _733 = _223.xy * float2(443.897491455078125f, 397.29730224609375f);
    _223 = float3(_733.x, _733.y, _223.z);
    float2 _738 = frac(_223.xy);
    _223 = float3(_738.x, _738.y, _223.z);
    _726 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _726 = frac(_726);
    _746 = _726 + 19.1900005340576171875f.xxxx;
    _457 = dot(_726.wz, _746.zw);
    _678.x = dot(_726.yx, _746.xy);
    _678 = _726.yx + _678.xx;
    _702 = _457.xx + _726.wz;
    _457 = _702.y * _702.x;
    _457 = frac(_457);
    _678.x = _678.y * _678.x;
    _678.x = frac(_678.x);
    _54.x += (-_457);
    _54.x = (_669.x * _54.x) + _457;
    _802 = _223.yx + 19.1900005340576171875f.xx;
    _457 = dot(_223.xy, _802);
    float2 _814 = _457.xx + _223.xy;
    _223 = float3(_814.x, _814.y, _223.z);
    _457 = _223.y * _223.x;
    _457 = frac(_457);
    _223.x = (-_457) + _678.x;
    _457 = (_669.x * _223.x) + _457;
    _54.x += (-_457);
    _265.x = (_669.y * _54.x) + _457;
    _265.x = clamp(_265.x, 0.0f, 1.0f);
    _54.x = _265.x * _265.x;
    _54.x *= _54.x;
    _54.x *= _265.x;
    float2 _882 = vs_TEXCOORD0 * float2(float2(_17_m24, _17_m24));
    _223 = float3(_882.x, _882.y, _223.z);
    float2 _892 = (_223.xy * 0.550000011920928955078125f.xx) + _9.xy;
    _9 = float3(_892.x, _892.y, _9.z);
    float2 _904 = (_17_m0.yy * float2(-0.007000000216066837310791015625f, 0.0130000002682209014892578125f)) + _9.xy;
    _9 = float3(_904.x, _904.y, _9.z);
    float2 _909 = frac(_9.xy);
    _223 = float3(_909.x, _909.y, _223.z);
    float2 _914 = floor(_9.xy);
    _9 = float3(_914.x, _914.y, _9.z);
    _669 = _223.xy * _223.xy;
    float2 _926 = ((-_223.xy) * 2.0f.xx) + 3.0f.xx;
    _223 = float3(_926.x, _926.y, _223.z);
    float2 _932 = _223.xy * _669;
    _223 = float3(_932.x, _932.y, _223.z);
    _669 = _9.xy + 1.0f.xx;
    _669 *= float2(443.897491455078125f, 397.29730224609375f);
    _669 = frac(_669);
    _678 = _669.yx + 19.1900005340576171875f.xx;
    _457 = dot(_669, _678);
    _669 = _457.xx + _669;
    _457 = _669.y * _669.x;
    _457 = frac(_457);
    _726 = _9.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _964 = _9.xy * float2(443.897491455078125f, 397.29730224609375f);
    _9 = float3(_964.x, _964.y, _9.z);
    float2 _969 = frac(_9.xy);
    _9 = float3(_969.x, _969.y, _9.z);
    _726 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _726 = frac(_726);
    _746 = _726 + 19.1900005340576171875f.xxxx;
    _669.x = dot(_726.wz, _746.zw);
    _984 = dot(_726.yx, _746.xy);
    _678 = _726.yx + _984.xx;
    _669 = _726.wz + _669.xx;
    _669.x = _669.y * _669.x;
    _669.y = _678.y * _678.x;
    _669 = frac(_669);
    _457 += (-_669.x);
    _457 = (_223.x * _457) + _669.x;
    _678 = _9.yx + 19.1900005340576171875f.xx;
    _669.x = dot(_9.xy, _678);
    float2 _1038 = _9.xy + _669.xx;
    _9 = float3(_1038.x, _1038.y, _9.z);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1051 = (-_9.x) + _669.y;
    _9.x = (_223.x * _1051) + _9.x;
    _1051 = (-_9.x) + _457;
    _9.x = (_223.y * _1051) + _9.x;
    _265.x = _9.x * _9.x;
    _9.x = _265.x * 0.449999988079071044921875f;
    _265.x = (_54.x * 3.0f) + _9.x;
    _265.x = min(_265.x, 1.0f);
    _265 = _265.xxx * _17_m21.xyz;
    _9 = (_265 * _168.xxx) + _31;
    _9 += (-_17_m3.xyz);
    _168 = vs_TEXCOORD5;
    _168 = clamp(_168, 0.0f, 1.0f);
    _9 = (_168.xxx * _9) + _17_m3.xyz;
    _441 = float4(_9.x, _9.y, _9.z, _441.w);
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
    stage_output._441 = _441;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _143;
static float4 _177;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
    float4 _177 : TANGENT;
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
static float _162;
static float3 _223;
static float3 _237;

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
    vs_TEXCOORD0 = _140;
    _9.y = dot(_143, _21_m2[0].xyz);
    _9.z = dot(_143, _21_m2[1].xyz);
    _9.x = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    float3 _174 = _162.xxx * _9.xyz;
    _9 = float4(_174.x, _174.y, _174.z, _9.w);
    float3 _183 = _177.yyy * _21_m1[1].yzx;
    _44 = float4(_183.x, _183.y, _183.z, _44.w);
    float3 _194 = (_21_m1[0].yzx * _177.xxx) + _44.xyz;
    _44 = float4(_194.x, _194.y, _194.z, _44.w);
    float3 _205 = (_21_m1[2].yzx * _177.zzz) + _44.xyz;
    _44 = float4(_205.x, _205.y, _205.z, _44.w);
    _162 = dot(_44.xyz, _44.xyz);
    _162 = rsqrt(_162);
    float3 _219 = _162.xxx * _44.xyz;
    _44 = float4(_219.x, _219.y, _219.z, _44.w);
    _223 = _9.xyz * _44.xyz;
    _223 = (_9.zxy * _44.yzx) + (-_223);
    _237 = _223 * _177.www;
    _237 *= _21_m3.www;
    vs_TEXCOORD2.y = _237.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _237.y;
    vs_TEXCOORD4.y = _237.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _143 = stage_input._143;
    _177 = stage_input._177;
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
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _MainTex_ST;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
float4 _SpecularColor;
float _Shininess;
float _SpecularStrength;
float _ReflectionStrength;
float _ReflectionBlur;
float _IOR;
float _RefractWeight;
float4 _InteriorColor;
float _InteriorDepth;
float _InteriorStrength;
float _InteriorScale;
float4 _NormalMap_ST;
float _NormalStrength;
float _NormalScrollSpeed;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _WorldSpaceLightPos0
#define _17_m3 unity_FogColor
#define _17_m4 unity_SpecCube0_HDR
#define _17_m5 _CoreColor
#define _17_m6 _EdgeColor
#define _17_m7 _FresnelPower
#define _17_m8 _MainTex_ST
#define _17_m9 _EmissionColor
#define _17_m10 _EmissionTex_ST
#define _17_m11 _EmissionBase
#define _17_m12 _EmissionPulse
#define _17_m13 _PulseSpeed
#define _17_m14 _SpecularColor
#define _17_m15 _Shininess
#define _17_m16 _SpecularStrength
#define _17_m17 _ReflectionStrength
#define _17_m18 _ReflectionBlur
#define _17_m19 _IOR
#define _17_m20 _RefractWeight
#define _17_m21 _InteriorColor
#define _17_m22 _InteriorDepth
#define _17_m23 _InteriorStrength
#define _17_m24 _InteriorScale
#define _17_m25 _NormalMap_ST
#define _17_m26 _NormalStrength
#define _17_m27 _NormalScrollSpeed


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _441;
static float vs_TEXCOORD5;

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
    float4 _441 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _54;
static float2 _68;
static float2 _78;
static float3 _83;
static float _168;
static float3 _188;
static float _194;
static bool _212;
static float3 _223;
static float _245;
static float4 _254;
static float3 _265;
static float4 _304;
static float3 _402;
static float _457;
static float _557;
static float2 _669;
static float2 _678;
static float2 _702;
static float4 _726;
static float4 _746;
static float2 _802;
static float _984;
static float _1051;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m25.xy) + _17_m25.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _31.x = _17_m0.y * _17_m27;
    float2 _50 = _31.xx * float2(0.699999988079071044921875f, 0.5f);
    _31 = float3(_31.x, _50.x, _50.y);
    _54 = _9.xy + _31.xy;
    float2 _65 = _9.xy + (-_31.zx);
    _9 = float3(_65.x, _65.y, _9.z);
    _68 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _9.xy)).xy;
    _78 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _54)).xy;
    float2 _90 = (_78 * 2.0f.xx) + (-1.0f).xx;
    _83 = float3(_90.x, _90.y, _83.z);
    float2 _97 = (_68 * 2.0f.xx) + _83.xy;
    _83 = float3(_97.x, _97.y, _83.z);
    float2 _102 = _83.xy + (-1.0f).xx;
    _83 = float3(_102.x, _102.y, _83.z);
    _9.x = _17_m26 * 0.5f;
    float2 _114 = _9.xx * _83.xy;
    _9 = float3(_114.x, _114.y, _9.z);
    _9.z = 1.0f;
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9.x = dot(vs_TEXCOORD2, _83);
    _9.y = dot(vs_TEXCOORD3, _83);
    _9.z = dot(vs_TEXCOORD4, _83);
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _168 = dot(_9, _9);
    _168 = rsqrt(_168);
    _9 = _168.xxx * _9;
    _168 = dot(-_9, _83);
    _31.x = ((-_168) * _168) + 1.0f;
    _188.x = 1.0f / _17_m19;
    _194 = _188.x * _188.x;
    _31.x = ((-_194) * _31.x) + 1.0f;
    _194 = sqrt(_31.x);
    _212 = _31.x >= 0.0f;
    _168 = (_188.x * _168) + _194;
    _223 = _83 * _168.xxx;
    _188 = (_188.xxx * (-_9)) + (-_223);
    float3 _238;
    if (_212)
    {
        _238 = _188;
    }
    else
    {
        _238 = 0.0f.xxx;
    }
    _31 = _238;
    _245 = dot(-_9, _83);
    _245 += _245;
    float3 _262 = (_83 * (-_245.xxx)) + (-_9);
    _254 = float4(_262.x, _262.y, _262.z, _254.w);
    _265 = _31 + (-_254.xyz);
    float3 _287 = (float3(float3(_17_m20, _17_m20, _17_m20)) * _265) + _254.xyz;
    _254 = float4(_287.x, _287.y, _287.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _301 = _245.xxx * _254.xyz;
    _254 = float4(_301.x, _301.y, _301.z, _254.w);
    _304 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _254.xyz, _17_m18);
    _245 = _304.w + (-1.0f);
    _245 = (_17_m4.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m4.y;
    _245 = exp2(_245);
    _245 *= _17_m4.x;
    float3 _342 = _304.xyz * _245.xxx;
    _254 = float4(_342.x, _342.y, _342.z, _254.w);
    float3 _359 = _254.xyz * float3(float3(_17_m17, _17_m17, _17_m17));
    _254 = float4(_359.x, _359.y, _359.z, _254.w);
    _245 = dot(_83, _9);
    _245 = clamp(_245, 0.0f, 1.0f);
    _168 = (-_245) + 1.0f;
    _168 = log2(_168);
    _168 *= _17_m7;
    _168 = exp2(_168);
    _31.x = (_168 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _31 = _31.xxx * _254.xyz;
    float2 _399 = (vs_TEXCOORD0 * _17_m8.xy) + _17_m8.zw;
    _223 = float3(_399.x, _399.y, _223.z);
    _402 = _MainTex.Sample(sampler_MainTex, _223.xy).xyz;
    _254 = (-_17_m5) + _17_m6;
    _254 = (_168.xxxx * _254) + _17_m5;
    _168 = ((-_168) * _168) + 1.0f;
    _168 *= _17_m23;
    _31 = (_254.xyz * _402) + _31;
    _441.w = _254.w;
    _223 = ((-vs_TEXCOORD1) * _17_m2.www) + _17_m2.xyz;
    _457 = dot(_223, _223);
    _457 = rsqrt(_457);
    float3 _468 = (_223 * _457.xxx) + _9;
    _254 = float4(_468.x, _468.y, _468.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _482 = _245.xxx * _254.xyz;
    _254 = float4(_482.x, _482.y, _482.z, _254.w);
    _83.x = dot(_83, _254.xyz);
    _83.x = clamp(_83.x, 0.0f, 1.0f);
    _83.x = log2(_83.x);
    _83.x *= _17_m15;
    _83.x = exp2(_83.x);
    _83.x *= _17_m16;
    _31 = (_17_m14.xyz * _83.xxx) + _31;
    _457 = _17_m0.y * _17_m13;
    _223.x = sin(_457);
    _457 = (_457 * 3.7000000476837158203125f) + 1.2999999523162841796875f;
    _457 = sin(_457);
    _223.x = (_223.x * 0.5f) + 0.5f;
    _223.x = (_17_m12 * _223.x) + _17_m11;
    _557 = _17_m12 * 0.119999997317790985107421875f;
    _457 = (_557 * _457) + _223.x;
    float2 _577 = (vs_TEXCOORD0 * _17_m10.xy) + _17_m10.zw;
    _223 = float3(_577.x, _577.y, _223.z);
    _402 = _EmissionTex.Sample(sampler_EmissionTex, _223.xy).xyz;
    _83 = _402 * _17_m9.xyz;
    _31 = (_83 * _457.xxx) + _31;
    _223.x = vs_TEXCOORD2.x;
    _223.y = vs_TEXCOORD3.x;
    _223.z = vs_TEXCOORD4.x;
    _83.x = dot(_9, _223);
    _223.x = vs_TEXCOORD2.y;
    _223.y = vs_TEXCOORD3.y;
    _223.z = vs_TEXCOORD4.y;
    _83.y = dot(_9, _223);
    float2 _631 = _83.xy * _17_m22.xx;
    _9 = float3(_631.x, _631.y, _9.z);
    float2 _647 = (vs_TEXCOORD0 * float2(float2(_17_m24, _17_m24))) + _9.xy;
    _223 = float3(_647.x, _647.y, _223.z);
    float2 _654 = _9.xy * 1.7999999523162841796875f.xx;
    _9 = float3(_654.x, _654.y, _9.z);
    float2 _666 = (_17_m0.yy * float2(0.010999999940395355224609375f, 0.008000000379979610443115234375f)) + _223.xy;
    _223 = float3(_666.x, _666.y, _223.z);
    _669 = frac(_223.xy);
    float2 _675 = floor(_223.xy);
    _223 = float3(_675.x, _675.y, _223.z);
    _678 = _669 * _669;
    _669 = ((-_669) * 2.0f.xx) + 3.0f.xx;
    _669 *= _678;
    _678 = _223.xy + 1.0f.xx;
    _678 *= float2(443.897491455078125f, 397.29730224609375f);
    _678 = frac(_678);
    _702 = _678.yx + 19.1900005340576171875f.xx;
    _54.x = dot(_678, _702);
    _678 = _54.xx + _678;
    _54.x = _678.y * _678.x;
    _54.x = frac(_54.x);
    _726 = _223.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _733 = _223.xy * float2(443.897491455078125f, 397.29730224609375f);
    _223 = float3(_733.x, _733.y, _223.z);
    float2 _738 = frac(_223.xy);
    _223 = float3(_738.x, _738.y, _223.z);
    _726 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _726 = frac(_726);
    _746 = _726 + 19.1900005340576171875f.xxxx;
    _457 = dot(_726.wz, _746.zw);
    _678.x = dot(_726.yx, _746.xy);
    _678 = _726.yx + _678.xx;
    _702 = _457.xx + _726.wz;
    _457 = _702.y * _702.x;
    _457 = frac(_457);
    _678.x = _678.y * _678.x;
    _678.x = frac(_678.x);
    _54.x += (-_457);
    _54.x = (_669.x * _54.x) + _457;
    _802 = _223.yx + 19.1900005340576171875f.xx;
    _457 = dot(_223.xy, _802);
    float2 _814 = _457.xx + _223.xy;
    _223 = float3(_814.x, _814.y, _223.z);
    _457 = _223.y * _223.x;
    _457 = frac(_457);
    _223.x = (-_457) + _678.x;
    _457 = (_669.x * _223.x) + _457;
    _54.x += (-_457);
    _265.x = (_669.y * _54.x) + _457;
    _265.x = clamp(_265.x, 0.0f, 1.0f);
    _54.x = _265.x * _265.x;
    _54.x *= _54.x;
    _54.x *= _265.x;
    float2 _882 = vs_TEXCOORD0 * float2(float2(_17_m24, _17_m24));
    _223 = float3(_882.x, _882.y, _223.z);
    float2 _892 = (_223.xy * 0.550000011920928955078125f.xx) + _9.xy;
    _9 = float3(_892.x, _892.y, _9.z);
    float2 _904 = (_17_m0.yy * float2(-0.007000000216066837310791015625f, 0.0130000002682209014892578125f)) + _9.xy;
    _9 = float3(_904.x, _904.y, _9.z);
    float2 _909 = frac(_9.xy);
    _223 = float3(_909.x, _909.y, _223.z);
    float2 _914 = floor(_9.xy);
    _9 = float3(_914.x, _914.y, _9.z);
    _669 = _223.xy * _223.xy;
    float2 _926 = ((-_223.xy) * 2.0f.xx) + 3.0f.xx;
    _223 = float3(_926.x, _926.y, _223.z);
    float2 _932 = _223.xy * _669;
    _223 = float3(_932.x, _932.y, _223.z);
    _669 = _9.xy + 1.0f.xx;
    _669 *= float2(443.897491455078125f, 397.29730224609375f);
    _669 = frac(_669);
    _678 = _669.yx + 19.1900005340576171875f.xx;
    _457 = dot(_669, _678);
    _669 = _457.xx + _669;
    _457 = _669.y * _669.x;
    _457 = frac(_457);
    _726 = _9.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _964 = _9.xy * float2(443.897491455078125f, 397.29730224609375f);
    _9 = float3(_964.x, _964.y, _9.z);
    float2 _969 = frac(_9.xy);
    _9 = float3(_969.x, _969.y, _9.z);
    _726 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _726 = frac(_726);
    _746 = _726 + 19.1900005340576171875f.xxxx;
    _669.x = dot(_726.wz, _746.zw);
    _984 = dot(_726.yx, _746.xy);
    _678 = _726.yx + _984.xx;
    _669 = _726.wz + _669.xx;
    _669.x = _669.y * _669.x;
    _669.y = _678.y * _678.x;
    _669 = frac(_669);
    _457 += (-_669.x);
    _457 = (_223.x * _457) + _669.x;
    _678 = _9.yx + 19.1900005340576171875f.xx;
    _669.x = dot(_9.xy, _678);
    float2 _1038 = _9.xy + _669.xx;
    _9 = float3(_1038.x, _1038.y, _9.z);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1051 = (-_9.x) + _669.y;
    _9.x = (_223.x * _1051) + _9.x;
    _1051 = (-_9.x) + _457;
    _9.x = (_223.y * _1051) + _9.x;
    _265.x = _9.x * _9.x;
    _9.x = _265.x * 0.449999988079071044921875f;
    _265.x = (_54.x * 3.0f) + _9.x;
    _265.x = min(_265.x, 1.0f);
    _265 = _265.xxx * _17_m21.xyz;
    _9 = (_265 * _168.xxx) + _31;
    _9 += (-_17_m3.xyz);
    _168 = vs_TEXCOORD5;
    _168 = clamp(_168, 0.0f, 1.0f);
    _9 = (_168.xxx * _9) + _17_m3.xyz;
    _441 = float4(_9.x, _9.y, _9.z, _441.w);
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
    stage_output._441 = _441;
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _102;
static float4 _139;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _102 : NORMAL;
    float4 _139 : TANGENT;
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
static float _124;
static float3 _185;
static float3 _199;

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
    vs_TEXCOORD0 = _99;
    _9.y = dot(_102, _21_m1[0].xyz);
    _9.z = dot(_102, _21_m1[1].xyz);
    _9.x = dot(_102, _21_m1[2].xyz);
    _124 = dot(_9.xyz, _9.xyz);
    _124 = rsqrt(_124);
    float3 _136 = _124.xxx * _9.xyz;
    _9 = float4(_136.x, _136.y, _136.z, _9.w);
    float3 _145 = _139.yyy * _21_m0[1].yzx;
    _44 = float4(_145.x, _145.y, _145.z, _44.w);
    float3 _156 = (_21_m0[0].yzx * _139.xxx) + _44.xyz;
    _44 = float4(_156.x, _156.y, _156.z, _44.w);
    float3 _167 = (_21_m0[2].yzx * _139.zzz) + _44.xyz;
    _44 = float4(_167.x, _167.y, _167.z, _44.w);
    _124 = dot(_44.xyz, _44.xyz);
    _124 = rsqrt(_124);
    float3 _181 = _124.xxx * _44.xyz;
    _44 = float4(_181.x, _181.y, _181.z, _44.w);
    _185 = _9.xyz * _44.xyz;
    _185 = (_9.zxy * _44.yzx) + (-_185);
    _199 = _185 * _139.www;
    _199 *= _21_m2.www;
    vs_TEXCOORD2.y = _199.x;
    vs_TEXCOORD2.x = _44.z;
    vs_TEXCOORD2.z = _9.y;
    vs_TEXCOORD3.x = _44.x;
    vs_TEXCOORD4.x = _44.y;
    vs_TEXCOORD3.z = _9.z;
    vs_TEXCOORD4.z = _9.x;
    vs_TEXCOORD3.y = _199.y;
    vs_TEXCOORD4.y = _199.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _102 = stage_input._102;
    _139 = stage_input._139;
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
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SpecCube0_HDR;
float4 _CoreColor;
float4 _EdgeColor;
float _FresnelPower;
float4 _MainTex_ST;
float4 _EmissionColor;
float4 _EmissionTex_ST;
float _EmissionBase;
float _EmissionPulse;
float _PulseSpeed;
float4 _SpecularColor;
float _Shininess;
float _SpecularStrength;
float _ReflectionStrength;
float _ReflectionBlur;
float _IOR;
float _RefractWeight;
float4 _InteriorColor;
float _InteriorDepth;
float _InteriorStrength;
float _InteriorScale;
float4 _NormalMap_ST;
float _NormalStrength;
float _NormalScrollSpeed;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _WorldSpaceLightPos0
#define _17_m3 unity_SpecCube0_HDR
#define _17_m4 _CoreColor
#define _17_m5 _EdgeColor
#define _17_m6 _FresnelPower
#define _17_m7 _MainTex_ST
#define _17_m8 _EmissionColor
#define _17_m9 _EmissionTex_ST
#define _17_m10 _EmissionBase
#define _17_m11 _EmissionPulse
#define _17_m12 _PulseSpeed
#define _17_m13 _SpecularColor
#define _17_m14 _Shininess
#define _17_m15 _SpecularStrength
#define _17_m16 _ReflectionStrength
#define _17_m17 _ReflectionBlur
#define _17_m18 _IOR
#define _17_m19 _RefractWeight
#define _17_m20 _InteriorColor
#define _17_m21 _InteriorDepth
#define _17_m22 _InteriorStrength
#define _17_m23 _InteriorScale
#define _17_m24 _NormalMap_ST
#define _17_m25 _NormalStrength
#define _17_m26 _NormalScrollSpeed


Texture2D<float4> _NormalMap;
SamplerState sampler_NormalMap;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionTex;
SamplerState sampler_EmissionTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _441;

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
    float4 _441 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _54;
static float2 _68;
static float2 _78;
static float3 _83;
static float _168;
static float3 _188;
static float _194;
static bool _212;
static float3 _223;
static float _245;
static float4 _254;
static float3 _265;
static float4 _304;
static float3 _402;
static float _457;
static float _557;
static float2 _669;
static float2 _678;
static float2 _702;
static float4 _726;
static float4 _746;
static float2 _802;
static float _984;
static float _1051;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m24.xy) + _17_m24.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _31.x = _17_m0.y * _17_m26;
    float2 _50 = _31.xx * float2(0.699999988079071044921875f, 0.5f);
    _31 = float3(_31.x, _50.x, _50.y);
    _54 = _9.xy + _31.xy;
    float2 _65 = _9.xy + (-_31.zx);
    _9 = float3(_65.x, _65.y, _9.z);
    _68 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _9.xy)).xy;
    _78 = LA_UnpackNormalTex(_NormalMap.Sample(sampler_NormalMap, _54)).xy;
    float2 _90 = (_78 * 2.0f.xx) + (-1.0f).xx;
    _83 = float3(_90.x, _90.y, _83.z);
    float2 _97 = (_68 * 2.0f.xx) + _83.xy;
    _83 = float3(_97.x, _97.y, _83.z);
    float2 _102 = _83.xy + (-1.0f).xx;
    _83 = float3(_102.x, _102.y, _83.z);
    _9.x = _17_m25 * 0.5f;
    float2 _114 = _9.xx * _83.xy;
    _9 = float3(_114.x, _114.y, _9.z);
    _9.z = 1.0f;
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9.x = dot(vs_TEXCOORD2, _83);
    _9.y = dot(vs_TEXCOORD3, _83);
    _9.z = dot(vs_TEXCOORD4, _83);
    _83.x = dot(_9, _9);
    _83.x = rsqrt(_83.x);
    _83 = _9 * _83.xxx;
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _168 = dot(_9, _9);
    _168 = rsqrt(_168);
    _9 = _168.xxx * _9;
    _168 = dot(-_9, _83);
    _31.x = ((-_168) * _168) + 1.0f;
    _188.x = 1.0f / _17_m18;
    _194 = _188.x * _188.x;
    _31.x = ((-_194) * _31.x) + 1.0f;
    _194 = sqrt(_31.x);
    _212 = _31.x >= 0.0f;
    _168 = (_188.x * _168) + _194;
    _223 = _83 * _168.xxx;
    _188 = (_188.xxx * (-_9)) + (-_223);
    float3 _238;
    if (_212)
    {
        _238 = _188;
    }
    else
    {
        _238 = 0.0f.xxx;
    }
    _31 = _238;
    _245 = dot(-_9, _83);
    _245 += _245;
    float3 _262 = (_83 * (-_245.xxx)) + (-_9);
    _254 = float4(_262.x, _262.y, _262.z, _254.w);
    _265 = _31 + (-_254.xyz);
    float3 _287 = (float3(float3(_17_m19, _17_m19, _17_m19)) * _265) + _254.xyz;
    _254 = float4(_287.x, _287.y, _287.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _301 = _245.xxx * _254.xyz;
    _254 = float4(_301.x, _301.y, _301.z, _254.w);
    _304 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _254.xyz, _17_m17);
    _245 = _304.w + (-1.0f);
    _245 = (_17_m3.w * _245) + 1.0f;
    _245 = log2(_245);
    _245 *= _17_m3.y;
    _245 = exp2(_245);
    _245 *= _17_m3.x;
    float3 _342 = _304.xyz * _245.xxx;
    _254 = float4(_342.x, _342.y, _342.z, _254.w);
    float3 _359 = _254.xyz * float3(float3(_17_m16, _17_m16, _17_m16));
    _254 = float4(_359.x, _359.y, _359.z, _254.w);
    _245 = dot(_83, _9);
    _245 = clamp(_245, 0.0f, 1.0f);
    _168 = (-_245) + 1.0f;
    _168 = log2(_168);
    _168 *= _17_m6;
    _168 = exp2(_168);
    _31.x = (_168 * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _31 = _31.xxx * _254.xyz;
    float2 _399 = (vs_TEXCOORD0 * _17_m7.xy) + _17_m7.zw;
    _223 = float3(_399.x, _399.y, _223.z);
    _402 = _MainTex.Sample(sampler_MainTex, _223.xy).xyz;
    _254 = (-_17_m4) + _17_m5;
    _254 = (_168.xxxx * _254) + _17_m4;
    _168 = ((-_168) * _168) + 1.0f;
    _168 *= _17_m22;
    _31 = (_254.xyz * _402) + _31;
    _441.w = _254.w;
    _223 = ((-vs_TEXCOORD1) * _17_m2.www) + _17_m2.xyz;
    _457 = dot(_223, _223);
    _457 = rsqrt(_457);
    float3 _468 = (_223 * _457.xxx) + _9;
    _254 = float4(_468.x, _468.y, _468.z, _254.w);
    _245 = dot(_254.xyz, _254.xyz);
    _245 = rsqrt(_245);
    float3 _482 = _245.xxx * _254.xyz;
    _254 = float4(_482.x, _482.y, _482.z, _254.w);
    _83.x = dot(_83, _254.xyz);
    _83.x = clamp(_83.x, 0.0f, 1.0f);
    _83.x = log2(_83.x);
    _83.x *= _17_m14;
    _83.x = exp2(_83.x);
    _83.x *= _17_m15;
    _31 = (_17_m13.xyz * _83.xxx) + _31;
    _457 = _17_m0.y * _17_m12;
    _223.x = sin(_457);
    _457 = (_457 * 3.7000000476837158203125f) + 1.2999999523162841796875f;
    _457 = sin(_457);
    _223.x = (_223.x * 0.5f) + 0.5f;
    _223.x = (_17_m11 * _223.x) + _17_m10;
    _557 = _17_m11 * 0.119999997317790985107421875f;
    _457 = (_557 * _457) + _223.x;
    float2 _577 = (vs_TEXCOORD0 * _17_m9.xy) + _17_m9.zw;
    _223 = float3(_577.x, _577.y, _223.z);
    _402 = _EmissionTex.Sample(sampler_EmissionTex, _223.xy).xyz;
    _83 = _402 * _17_m8.xyz;
    _31 = (_83 * _457.xxx) + _31;
    _223.x = vs_TEXCOORD2.x;
    _223.y = vs_TEXCOORD3.x;
    _223.z = vs_TEXCOORD4.x;
    _83.x = dot(_9, _223);
    _223.x = vs_TEXCOORD2.y;
    _223.y = vs_TEXCOORD3.y;
    _223.z = vs_TEXCOORD4.y;
    _83.y = dot(_9, _223);
    float2 _631 = _83.xy * _17_m21.xx;
    _9 = float3(_631.x, _631.y, _9.z);
    float2 _647 = (vs_TEXCOORD0 * float2(float2(_17_m23, _17_m23))) + _9.xy;
    _223 = float3(_647.x, _647.y, _223.z);
    float2 _654 = _9.xy * 1.7999999523162841796875f.xx;
    _9 = float3(_654.x, _654.y, _9.z);
    float2 _666 = (_17_m0.yy * float2(0.010999999940395355224609375f, 0.008000000379979610443115234375f)) + _223.xy;
    _223 = float3(_666.x, _666.y, _223.z);
    _669 = frac(_223.xy);
    float2 _675 = floor(_223.xy);
    _223 = float3(_675.x, _675.y, _223.z);
    _678 = _669 * _669;
    _669 = ((-_669) * 2.0f.xx) + 3.0f.xx;
    _669 *= _678;
    _678 = _223.xy + 1.0f.xx;
    _678 *= float2(443.897491455078125f, 397.29730224609375f);
    _678 = frac(_678);
    _702 = _678.yx + 19.1900005340576171875f.xx;
    _54.x = dot(_678, _702);
    _678 = _54.xx + _678;
    _54.x = _678.y * _678.x;
    _54.x = frac(_54.x);
    _726 = _223.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _733 = _223.xy * float2(443.897491455078125f, 397.29730224609375f);
    _223 = float3(_733.x, _733.y, _223.z);
    float2 _738 = frac(_223.xy);
    _223 = float3(_738.x, _738.y, _223.z);
    _726 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _726 = frac(_726);
    _746 = _726 + 19.1900005340576171875f.xxxx;
    _457 = dot(_726.wz, _746.zw);
    _678.x = dot(_726.yx, _746.xy);
    _678 = _726.yx + _678.xx;
    _702 = _457.xx + _726.wz;
    _457 = _702.y * _702.x;
    _457 = frac(_457);
    _678.x = _678.y * _678.x;
    _678.x = frac(_678.x);
    _54.x += (-_457);
    _54.x = (_669.x * _54.x) + _457;
    _802 = _223.yx + 19.1900005340576171875f.xx;
    _457 = dot(_223.xy, _802);
    float2 _814 = _457.xx + _223.xy;
    _223 = float3(_814.x, _814.y, _223.z);
    _457 = _223.y * _223.x;
    _457 = frac(_457);
    _223.x = (-_457) + _678.x;
    _457 = (_669.x * _223.x) + _457;
    _54.x += (-_457);
    _265.x = (_669.y * _54.x) + _457;
    _265.x = clamp(_265.x, 0.0f, 1.0f);
    _54.x = _265.x * _265.x;
    _54.x *= _54.x;
    _54.x *= _265.x;
    float2 _882 = vs_TEXCOORD0 * float2(float2(_17_m23, _17_m23));
    _223 = float3(_882.x, _882.y, _223.z);
    float2 _892 = (_223.xy * 0.550000011920928955078125f.xx) + _9.xy;
    _9 = float3(_892.x, _892.y, _9.z);
    float2 _904 = (_17_m0.yy * float2(-0.007000000216066837310791015625f, 0.0130000002682209014892578125f)) + _9.xy;
    _9 = float3(_904.x, _904.y, _9.z);
    float2 _909 = frac(_9.xy);
    _223 = float3(_909.x, _909.y, _223.z);
    float2 _914 = floor(_9.xy);
    _9 = float3(_914.x, _914.y, _9.z);
    _669 = _223.xy * _223.xy;
    float2 _926 = ((-_223.xy) * 2.0f.xx) + 3.0f.xx;
    _223 = float3(_926.x, _926.y, _223.z);
    float2 _932 = _223.xy * _669;
    _223 = float3(_932.x, _932.y, _223.z);
    _669 = _9.xy + 1.0f.xx;
    _669 *= float2(443.897491455078125f, 397.29730224609375f);
    _669 = frac(_669);
    _678 = _669.yx + 19.1900005340576171875f.xx;
    _457 = dot(_669, _678);
    _669 = _457.xx + _669;
    _457 = _669.y * _669.x;
    _457 = frac(_457);
    _726 = _9.yxyx + float4(0.0f, 1.0f, 1.0f, 0.0f);
    float2 _964 = _9.xy * float2(443.897491455078125f, 397.29730224609375f);
    _9 = float3(_964.x, _964.y, _9.z);
    float2 _969 = frac(_9.xy);
    _9 = float3(_969.x, _969.y, _9.z);
    _726 *= float4(397.29730224609375f, 443.897491455078125f, 397.29730224609375f, 443.897491455078125f);
    _726 = frac(_726);
    _746 = _726 + 19.1900005340576171875f.xxxx;
    _669.x = dot(_726.wz, _746.zw);
    _984 = dot(_726.yx, _746.xy);
    _678 = _726.yx + _984.xx;
    _669 = _726.wz + _669.xx;
    _669.x = _669.y * _669.x;
    _669.y = _678.y * _678.x;
    _669 = frac(_669);
    _457 += (-_669.x);
    _457 = (_223.x * _457) + _669.x;
    _678 = _9.yx + 19.1900005340576171875f.xx;
    _669.x = dot(_9.xy, _678);
    float2 _1038 = _9.xy + _669.xx;
    _9 = float3(_1038.x, _1038.y, _9.z);
    _9.x = _9.y * _9.x;
    _9.x = frac(_9.x);
    _1051 = (-_9.x) + _669.y;
    _9.x = (_223.x * _1051) + _9.x;
    _1051 = (-_9.x) + _457;
    _9.x = (_223.y * _1051) + _9.x;
    _265.x = _9.x * _9.x;
    _9.x = _265.x * 0.449999988079071044921875f;
    _265.x = (_54.x * 3.0f) + _9.x;
    _265.x = min(_265.x, 1.0f);
    _265 = _265.xxx * _17_m20.xyz;
    _9 = (_265 * _168.xxx) + _31;
    _441 = float4(_9.x, _9.y, _9.z, _441.w);
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
    stage_output._441 = _441;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Transparent/Diffuse"
}