// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SlopGame/Water" {
Properties {

[Header(Water Color)] _ShallowColor ("Shallow Color", Color) = (0.55,0.65,0.65,0.15)

_DeepColor ("Deep Color", Color) = (0.2,0.28,0.3,0.55)

_FresnelPower ("Fresnel Power", Range(1, 8)) = 4.0

[Header(Normal Maps)] _NormalMap1 ("Normal Map 1", 2D) = "bump" { }

_NormalMap2 ("Normal Map 2", 2D) = "bump" { }

_NormalStrength ("Normal Strength", Range(0, 3)) = 1.0

_ScrollSpeed1 ("Scroll Speed 1 (XY)", Vector) = (0.04,0.02,0,0)

_ScrollSpeed2 ("Scroll Speed 2 (XY)", Vector) = (-0.02,0.04,0,0)

[Header(Reflections)] _ReflectionStrength ("Reflection Strength", Range(0, 2)) = 0.699999988079071

_ReflectionBlur ("Reflection Blur", Range(0, 6)) = 2.0

_ReflectionCubemap ("Fallback Cubemap", Cube) = "" { }

[Header(Foam)] [Toggle(FOAM_ON)] _FoamEnabled ("Enable Foam", Float) = 0.0

_FoamTex ("Foam Texture", 2D) = "white" { }

_FoamColor ("Foam Color", Color) = (1,1,1,0.9)

_FoamScrollSpeed ("Foam Scroll Speed (XY)", Vector) = (0.02,0.01,0,0)

_FoamThreshold ("Foam Threshold", Range(0, 1)) = 0.6000000238418579

}
SubShader {
 LOD 200
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
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
#if defined(FOG_LINEAR)
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
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _ShallowColor;
float4 _DeepColor;
float _FresnelPower;
float4 _NormalMap1_ST;
float4 _NormalMap2_ST;
float _NormalStrength;
float4 _ScrollSpeed1;
float4 _ScrollSpeed2;
float _ReflectionStrength;
float _ReflectionBlur;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_FogColor
#define _17_m3 unity_SpecCube0_HDR
#define _17_m4 _ShallowColor
#define _17_m5 _DeepColor
#define _17_m6 _FresnelPower
#define _17_m7 _NormalMap1_ST
#define _17_m8 _NormalMap2_ST
#define _17_m9 _NormalStrength
#define _17_m10 _ScrollSpeed1
#define _17_m11 _ScrollSpeed2
#define _17_m12 _ReflectionStrength
#define _17_m13 _ReflectionBlur


Texture2D<float4> _NormalMap2;
SamplerState sampler_NormalMap2;
Texture2D<float4> _NormalMap1;
SamplerState sampler_NormalMap1;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
TextureCube<float4> _ReflectionCubemap;
SamplerState sampler_ReflectionCubemap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _372;
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
    float4 _372 : SV_Target0;
};

static float3 _9;
static float3 _45;
static float4 _56;
static float3 _107;
static float3 _111;
static float _189;
static float _199;
static float3 _265;
static float3 _306;
static float3 _312;
static float _325;
static float3 _332;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m8.xy) + _17_m8.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    float2 _42 = (_17_m11.xy * _17_m0.yy) + _9.xy;
    _9 = float3(_42.x, _42.y, _9.z);
    _45 = LA_UnpackNormalTex(_NormalMap2.Sample(sampler_NormalMap2, _9.xy)).xyz;
    float3 _63 = (_45 * 2.0f.xxx) + (-1.0f).xxx;
    _56 = float4(_63.x, _63.y, _63.z, _56.w);
    float2 _73 = _56.xy * _17_m9.xx;
    _56 = float4(_73.x, _73.y, _56.z, _56.w);
    float2 _85 = (vs_TEXCOORD0 * _17_m7.xy) + _17_m7.zw;
    _9 = float3(_85.x, _85.y, _9.z);
    float2 _98 = (_17_m10.xy * _17_m0.yy) + _9.xy;
    _9 = float3(_98.x, _98.y, _9.z);
    _45 = LA_UnpackNormalTex(_NormalMap1.Sample(sampler_NormalMap1, _9.xy)).xyz;
    _107 = (_45 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _120 = (_107.xy * _17_m9.xx) + _56.xy;
    _111 = float3(_120.x, _120.y, _111.z);
    _111.z = _56.z * _107.z;
    _56.x = dot(_111, _111);
    _56.x = rsqrt(_56.x);
    float3 _144 = _56.xxx * _111;
    _56 = float4(_144.x, _144.y, _144.z, _56.w);
    _9.x = dot(vs_TEXCOORD2, _56.xyz);
    _9.y = dot(vs_TEXCOORD3, _56.xyz);
    _9.z = dot(vs_TEXCOORD4, _56.xyz);
    _56.x = dot(_9, _9);
    _56.x = rsqrt(_56.x);
    float3 _178 = _9 * _56.xxx;
    _56 = float4(_178.x, _178.y, _178.z, _56.w);
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _189 = dot(_9, _9);
    _189 = rsqrt(_189);
    _9 = _189.xxx * _9;
    _199 = dot(-_9, _56.xyz);
    _199 += _199;
    _107 = (_56.xyz * (-_199.xxx)) + (-_9);
    _56.x = dot(_56.xyz, _9);
    _56.x = clamp(_56.x, 0.0f, 1.0f);
    _9.x = (-_56.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _17_m6;
    _9.x = exp2(_9.x);
    _9.x = (_9.x * 0.980000019073486328125f) + 0.0199999995529651641845703125f;
    _56 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _107, _17_m13);
    _265 = _ReflectionCubemap.SampleLevel(sampler_ReflectionCubemap, _107, _17_m13).xyz;
    _107.x = _56.w + (-1.0f);
    _107.x = (_17_m3.w * _107.x) + 1.0f;
    _107.x = log2(_107.x);
    _107.x *= _17_m3.y;
    _107.x = exp2(_107.x);
    _107.x *= _17_m3.x;
    _306 = _56.xyz * _107.xxx;
    _312 = (_107.xxx * _56.xyz) + (-_265);
    _107.x = dot(_306, _306);
    _325 = _107.x * 10.0f;
    _325 = min(_325, 1.0f);
    _332 = (_325.xxx * _312) + _265;
    _56 = (-_17_m4) + _17_m5;
    _56 = (_9.xxxx * _56) + _17_m4;
    _107 = (_332 * _17_m12.xxx) + (-_56.xyz);
    _107 = (_9.xxx * _107) + _56.xyz;
    _372.w = _56.w;
    _9 = _107 + (-_17_m2.xyz);
    _189 = vs_TEXCOORD5;
    _189 = clamp(_189, 0.0f, 1.0f);
    _9 = (_189.xxx * _9) + _17_m2.xyz;
    _372 = float4(_9.x, _9.y, _9.z, _372.w);
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
    stage_output._372 = _372;
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
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _ShallowColor;
float4 _DeepColor;
float _FresnelPower;
float4 _NormalMap1_ST;
float4 _NormalMap2_ST;
float _NormalStrength;
float4 _ScrollSpeed1;
float4 _ScrollSpeed2;
float _ReflectionStrength;
float _ReflectionBlur;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_FogColor
#define _17_m3 unity_SpecCube0_HDR
#define _17_m4 _ShallowColor
#define _17_m5 _DeepColor
#define _17_m6 _FresnelPower
#define _17_m7 _NormalMap1_ST
#define _17_m8 _NormalMap2_ST
#define _17_m9 _NormalStrength
#define _17_m10 _ScrollSpeed1
#define _17_m11 _ScrollSpeed2
#define _17_m12 _ReflectionStrength
#define _17_m13 _ReflectionBlur


Texture2D<float4> _NormalMap2;
SamplerState sampler_NormalMap2;
Texture2D<float4> _NormalMap1;
SamplerState sampler_NormalMap1;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
TextureCube<float4> _ReflectionCubemap;
SamplerState sampler_ReflectionCubemap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _372;
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
    float4 _372 : SV_Target0;
};

static float3 _9;
static float3 _45;
static float4 _56;
static float3 _107;
static float3 _111;
static float _189;
static float _199;
static float3 _265;
static float3 _306;
static float3 _312;
static float _325;
static float3 _332;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m8.xy) + _17_m8.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    float2 _42 = (_17_m11.xy * _17_m0.yy) + _9.xy;
    _9 = float3(_42.x, _42.y, _9.z);
    _45 = LA_UnpackNormalTex(_NormalMap2.Sample(sampler_NormalMap2, _9.xy)).xyz;
    float3 _63 = (_45 * 2.0f.xxx) + (-1.0f).xxx;
    _56 = float4(_63.x, _63.y, _63.z, _56.w);
    float2 _73 = _56.xy * _17_m9.xx;
    _56 = float4(_73.x, _73.y, _56.z, _56.w);
    float2 _85 = (vs_TEXCOORD0 * _17_m7.xy) + _17_m7.zw;
    _9 = float3(_85.x, _85.y, _9.z);
    float2 _98 = (_17_m10.xy * _17_m0.yy) + _9.xy;
    _9 = float3(_98.x, _98.y, _9.z);
    _45 = LA_UnpackNormalTex(_NormalMap1.Sample(sampler_NormalMap1, _9.xy)).xyz;
    _107 = (_45 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _120 = (_107.xy * _17_m9.xx) + _56.xy;
    _111 = float3(_120.x, _120.y, _111.z);
    _111.z = _56.z * _107.z;
    _56.x = dot(_111, _111);
    _56.x = rsqrt(_56.x);
    float3 _144 = _56.xxx * _111;
    _56 = float4(_144.x, _144.y, _144.z, _56.w);
    _9.x = dot(vs_TEXCOORD2, _56.xyz);
    _9.y = dot(vs_TEXCOORD3, _56.xyz);
    _9.z = dot(vs_TEXCOORD4, _56.xyz);
    _56.x = dot(_9, _9);
    _56.x = rsqrt(_56.x);
    float3 _178 = _9 * _56.xxx;
    _56 = float4(_178.x, _178.y, _178.z, _56.w);
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _189 = dot(_9, _9);
    _189 = rsqrt(_189);
    _9 = _189.xxx * _9;
    _199 = dot(-_9, _56.xyz);
    _199 += _199;
    _107 = (_56.xyz * (-_199.xxx)) + (-_9);
    _56.x = dot(_56.xyz, _9);
    _56.x = clamp(_56.x, 0.0f, 1.0f);
    _9.x = (-_56.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _17_m6;
    _9.x = exp2(_9.x);
    _9.x = (_9.x * 0.980000019073486328125f) + 0.0199999995529651641845703125f;
    _56 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _107, _17_m13);
    _265 = _ReflectionCubemap.SampleLevel(sampler_ReflectionCubemap, _107, _17_m13).xyz;
    _107.x = _56.w + (-1.0f);
    _107.x = (_17_m3.w * _107.x) + 1.0f;
    _107.x = log2(_107.x);
    _107.x *= _17_m3.y;
    _107.x = exp2(_107.x);
    _107.x *= _17_m3.x;
    _306 = _56.xyz * _107.xxx;
    _312 = (_107.xxx * _56.xyz) + (-_265);
    _107.x = dot(_306, _306);
    _325 = _107.x * 10.0f;
    _325 = min(_325, 1.0f);
    _332 = (_325.xxx * _312) + _265;
    _56 = (-_17_m4) + _17_m5;
    _56 = (_9.xxxx * _56) + _17_m4;
    _107 = (_332 * _17_m12.xxx) + (-_56.xyz);
    _107 = (_9.xxx * _107) + _56.xyz;
    _372.w = _56.w;
    _9 = _107 + (-_17_m2.xyz);
    _189 = vs_TEXCOORD5;
    _189 = clamp(_189, 0.0f, 1.0f);
    _9 = (_189.xxx * _9) + _17_m2.xyz;
    _372 = float4(_9.x, _9.y, _9.z, _372.w);
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
    stage_output._372 = _372;
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
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _ShallowColor;
float4 _DeepColor;
float _FresnelPower;
float4 _NormalMap1_ST;
float4 _NormalMap2_ST;
float _NormalStrength;
float4 _ScrollSpeed1;
float4 _ScrollSpeed2;
float _ReflectionStrength;
float _ReflectionBlur;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_FogColor
#define _17_m3 unity_SpecCube0_HDR
#define _17_m4 _ShallowColor
#define _17_m5 _DeepColor
#define _17_m6 _FresnelPower
#define _17_m7 _NormalMap1_ST
#define _17_m8 _NormalMap2_ST
#define _17_m9 _NormalStrength
#define _17_m10 _ScrollSpeed1
#define _17_m11 _ScrollSpeed2
#define _17_m12 _ReflectionStrength
#define _17_m13 _ReflectionBlur


Texture2D<float4> _NormalMap2;
SamplerState sampler_NormalMap2;
Texture2D<float4> _NormalMap1;
SamplerState sampler_NormalMap1;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
TextureCube<float4> _ReflectionCubemap;
SamplerState sampler_ReflectionCubemap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _372;
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
    float4 _372 : SV_Target0;
};

static float3 _9;
static float3 _45;
static float4 _56;
static float3 _107;
static float3 _111;
static float _189;
static float _199;
static float3 _265;
static float3 _306;
static float3 _312;
static float _325;
static float3 _332;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m8.xy) + _17_m8.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    float2 _42 = (_17_m11.xy * _17_m0.yy) + _9.xy;
    _9 = float3(_42.x, _42.y, _9.z);
    _45 = LA_UnpackNormalTex(_NormalMap2.Sample(sampler_NormalMap2, _9.xy)).xyz;
    float3 _63 = (_45 * 2.0f.xxx) + (-1.0f).xxx;
    _56 = float4(_63.x, _63.y, _63.z, _56.w);
    float2 _73 = _56.xy * _17_m9.xx;
    _56 = float4(_73.x, _73.y, _56.z, _56.w);
    float2 _85 = (vs_TEXCOORD0 * _17_m7.xy) + _17_m7.zw;
    _9 = float3(_85.x, _85.y, _9.z);
    float2 _98 = (_17_m10.xy * _17_m0.yy) + _9.xy;
    _9 = float3(_98.x, _98.y, _9.z);
    _45 = LA_UnpackNormalTex(_NormalMap1.Sample(sampler_NormalMap1, _9.xy)).xyz;
    _107 = (_45 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _120 = (_107.xy * _17_m9.xx) + _56.xy;
    _111 = float3(_120.x, _120.y, _111.z);
    _111.z = _56.z * _107.z;
    _56.x = dot(_111, _111);
    _56.x = rsqrt(_56.x);
    float3 _144 = _56.xxx * _111;
    _56 = float4(_144.x, _144.y, _144.z, _56.w);
    _9.x = dot(vs_TEXCOORD2, _56.xyz);
    _9.y = dot(vs_TEXCOORD3, _56.xyz);
    _9.z = dot(vs_TEXCOORD4, _56.xyz);
    _56.x = dot(_9, _9);
    _56.x = rsqrt(_56.x);
    float3 _178 = _9 * _56.xxx;
    _56 = float4(_178.x, _178.y, _178.z, _56.w);
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _189 = dot(_9, _9);
    _189 = rsqrt(_189);
    _9 = _189.xxx * _9;
    _199 = dot(-_9, _56.xyz);
    _199 += _199;
    _107 = (_56.xyz * (-_199.xxx)) + (-_9);
    _56.x = dot(_56.xyz, _9);
    _56.x = clamp(_56.x, 0.0f, 1.0f);
    _9.x = (-_56.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _17_m6;
    _9.x = exp2(_9.x);
    _9.x = (_9.x * 0.980000019073486328125f) + 0.0199999995529651641845703125f;
    _56 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _107, _17_m13);
    _265 = _ReflectionCubemap.SampleLevel(sampler_ReflectionCubemap, _107, _17_m13).xyz;
    _107.x = _56.w + (-1.0f);
    _107.x = (_17_m3.w * _107.x) + 1.0f;
    _107.x = log2(_107.x);
    _107.x *= _17_m3.y;
    _107.x = exp2(_107.x);
    _107.x *= _17_m3.x;
    _306 = _56.xyz * _107.xxx;
    _312 = (_107.xxx * _56.xyz) + (-_265);
    _107.x = dot(_306, _306);
    _325 = _107.x * 10.0f;
    _325 = min(_325, 1.0f);
    _332 = (_325.xxx * _312) + _265;
    _56 = (-_17_m4) + _17_m5;
    _56 = (_9.xxxx * _56) + _17_m4;
    _107 = (_332 * _17_m12.xxx) + (-_56.xyz);
    _107 = (_9.xxx * _107) + _56.xyz;
    _372.w = _56.w;
    _9 = _107 + (-_17_m2.xyz);
    _189 = vs_TEXCOORD5;
    _189 = clamp(_189, 0.0f, 1.0f);
    _9 = (_189.xxx * _9) + _17_m2.xyz;
    _372 = float4(_9.x, _9.y, _9.z, _372.w);
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
    stage_output._372 = _372;
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
float4 unity_SpecCube0_HDR;
float4 _ShallowColor;
float4 _DeepColor;
float _FresnelPower;
float4 _NormalMap1_ST;
float4 _NormalMap2_ST;
float _NormalStrength;
float4 _ScrollSpeed1;
float4 _ScrollSpeed2;
float _ReflectionStrength;
float _ReflectionBlur;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_SpecCube0_HDR
#define _17_m3 _ShallowColor
#define _17_m4 _DeepColor
#define _17_m5 _FresnelPower
#define _17_m6 _NormalMap1_ST
#define _17_m7 _NormalMap2_ST
#define _17_m8 _NormalStrength
#define _17_m9 _ScrollSpeed1
#define _17_m10 _ScrollSpeed2
#define _17_m11 _ReflectionStrength
#define _17_m12 _ReflectionBlur


Texture2D<float4> _NormalMap2;
SamplerState sampler_NormalMap2;
Texture2D<float4> _NormalMap1;
SamplerState sampler_NormalMap1;
TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;
TextureCube<float4> _ReflectionCubemap;
SamplerState sampler_ReflectionCubemap;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float4 _357;

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
    float4 _357 : SV_Target0;
};

static float3 _9;
static float3 _45;
static float4 _56;
static float3 _107;
static float3 _111;
static float _189;
static float _199;
static float3 _265;
static float3 _306;
static float3 _312;
static float _325;
static float3 _332;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m7.xy) + _17_m7.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    float2 _42 = (_17_m10.xy * _17_m0.yy) + _9.xy;
    _9 = float3(_42.x, _42.y, _9.z);
    _45 = LA_UnpackNormalTex(_NormalMap2.Sample(sampler_NormalMap2, _9.xy)).xyz;
    float3 _63 = (_45 * 2.0f.xxx) + (-1.0f).xxx;
    _56 = float4(_63.x, _63.y, _63.z, _56.w);
    float2 _73 = _56.xy * _17_m8.xx;
    _56 = float4(_73.x, _73.y, _56.z, _56.w);
    float2 _85 = (vs_TEXCOORD0 * _17_m6.xy) + _17_m6.zw;
    _9 = float3(_85.x, _85.y, _9.z);
    float2 _98 = (_17_m9.xy * _17_m0.yy) + _9.xy;
    _9 = float3(_98.x, _98.y, _9.z);
    _45 = LA_UnpackNormalTex(_NormalMap1.Sample(sampler_NormalMap1, _9.xy)).xyz;
    _107 = (_45 * 2.0f.xxx) + (-1.0f).xxx;
    float2 _120 = (_107.xy * _17_m8.xx) + _56.xy;
    _111 = float3(_120.x, _120.y, _111.z);
    _111.z = _56.z * _107.z;
    _56.x = dot(_111, _111);
    _56.x = rsqrt(_56.x);
    float3 _144 = _56.xxx * _111;
    _56 = float4(_144.x, _144.y, _144.z, _56.w);
    _9.x = dot(vs_TEXCOORD2, _56.xyz);
    _9.y = dot(vs_TEXCOORD3, _56.xyz);
    _9.z = dot(vs_TEXCOORD4, _56.xyz);
    _56.x = dot(_9, _9);
    _56.x = rsqrt(_56.x);
    float3 _178 = _9 * _56.xxx;
    _56 = float4(_178.x, _178.y, _178.z, _56.w);
    _9 = (-vs_TEXCOORD1) + _17_m1;
    _189 = dot(_9, _9);
    _189 = rsqrt(_189);
    _9 = _189.xxx * _9;
    _199 = dot(-_9, _56.xyz);
    _199 += _199;
    _107 = (_56.xyz * (-_199.xxx)) + (-_9);
    _56.x = dot(_56.xyz, _9);
    _56.x = clamp(_56.x, 0.0f, 1.0f);
    _9.x = (-_56.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _17_m5;
    _9.x = exp2(_9.x);
    _9.x = (_9.x * 0.980000019073486328125f) + 0.0199999995529651641845703125f;
    _56 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _107, _17_m12);
    _265 = _ReflectionCubemap.SampleLevel(sampler_ReflectionCubemap, _107, _17_m12).xyz;
    _107.x = _56.w + (-1.0f);
    _107.x = (_17_m2.w * _107.x) + 1.0f;
    _107.x = log2(_107.x);
    _107.x *= _17_m2.y;
    _107.x = exp2(_107.x);
    _107.x *= _17_m2.x;
    _306 = _56.xyz * _107.xxx;
    _312 = (_107.xxx * _56.xyz) + (-_265);
    _107.x = dot(_306, _306);
    _325 = _107.x * 10.0f;
    _325 = min(_325, 1.0f);
    _332 = (_325.xxx * _312) + _265;
    _56 = (-_17_m3) + _17_m4;
    _107 = (_9.xxx * _56.xyz) + _17_m3.xyz;
    _357.w = (_9.x * _56.w) + _17_m3.w;
    _111 = (_332 * _17_m11.xxx) + (-_107);
    float3 _382 = (_9.xxx * _111) + _107;
    _357 = float4(_382.x, _382.y, _382.z, _357.w);
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
    stage_output._357 = _357;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Transparent/Diffuse"
}