// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Fnaf/LightCone" {
Properties {

_Color ("Color", Color) = (1,0.88,0.66,1)

_Intensity ("Intensity", Range(0, 8)) = 1.0

[Header(Length)] [Enum(UV,0,ObjectY,1,ObjectZ,2)] _LengthSource ("Length Source", Float) = 0.0

_Apex ("Apex Coordinate", Float) = 0.0

_Base ("Base Coordinate", Float) = 1.0

_LengthFalloff ("Length Falloff", Range(0.1, 8)) = 1.5

_ApexSoftness ("Apex Softness", Range(0, 0.5)) = 0.05999999865889549

[Header(Edges)] _EdgeSoftness ("Edge Softness", Range(0.1, 8)) = 1.5

_CameraFade ("Camera Fade Distance", Range(0, 3)) = 0.6000000238418579

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One One
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
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
float _LengthSource;
float _Apex;
float _Base;
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
#define _22_m6 _LengthSource
#define _22_m7 _Apex
#define _22_m8 _Base



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _149;
static float3 vs_TEXCOORD0;
static float2 _219;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _149 : NORMAL;
    float2 _219 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _65;
static float _168;
static bool2 _186;
static float _197;
static bool _241;

void vert_inner()
{
    __unity_init();
    float3 _30 = _11.yyy * _22_m2[1].xyz;
    _9 = float4(_30.x, _30.y, _30.z, _9.w);
    float3 _42 = (_22_m2[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    float3 _53 = (_22_m2[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _62 = _9.xyz + _22_m2[3].xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _9.yyyy * _22_m4[1];
    _65 = (_22_m4[0] * _9.xxxx) + _65;
    _65 = (_22_m4[2] * _9.zzzz) + _65;
    float3 _94 = (-_9.xyz) + _22_m0;
    vs_TEXCOORD1 = float4(_94.x, _94.y, _94.z, vs_TEXCOORD1.w);
    _9 = _65 + _22_m4[3];
    gl_Position = _9;
    _9.x = _9.z / _22_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _22_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _22_m5.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    _9.x = dot(_149, _22_m3[0].xyz);
    _9.y = dot(_149, _22_m3[1].xyz);
    _9.z = dot(_149, _22_m3[2].xyz);
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD0 = _168.xxx * _9.xyz;
    float4 _190 = _22_m6.xxxx;
    _186 = bool4(_190.x < float4(0.5f, 1.5f, 0.0f, 0.0f).x, _190.y < float4(0.5f, 1.5f, 0.0f, 0.0f).y, _190.z < float4(0.5f, 1.5f, 0.0f, 0.0f).z, _190.w < float4(0.5f, 1.5f, 0.0f, 0.0f).w).xy;
    float _202;
    if (_186.y)
    {
        _202 = _11.y;
    }
    else
    {
        _202 = _11.z;
    }
    _197 = _202;
    float _214;
    if (_186.x)
    {
        _214 = _219.y;
    }
    else
    {
        _214 = _197;
    }
    _9.x = _214;
    _9.x += (-_22_m7);
    _197 = (-_22_m7) + _22_m8;
    _241 = abs(_197) < 9.9999997473787516355514526367188e-05f;
    _197 = _241 ? 9.9999997473787516355514526367188e-05f : _197;
    vs_TEXCOORD1.w = _9.x / _197;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _149 = stage_input._149;
    _219 = stage_input._219;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float _Intensity;
float _LengthFalloff;
float _ApexSoftness;
float _EdgeSoftness;
float _CameraFade;
#define _13_m0 _Color
#define _13_m1 _Intensity
#define _13_m2 _LengthFalloff
#define _13_m3 _ApexSoftness
#define _13_m4 _EdgeSoftness
#define _13_m5 _CameraFade



static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _193;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _193 : SV_Target0;
};

static float3 _9;
static float3 _30;
static float _53;
static float _70;
static float _114;
static float3 _122;

void frag_inner()
{
    _9.x = _13_m3 + 0.001000000047497451305389404296875f;
    _9.x = 1.0f / _9.x;
    _30.x = vs_TEXCOORD1.w;
    _30.x = clamp(_30.x, 0.0f, 1.0f);
    _9.x *= _30.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _53 = (-_30.x) + 1.0f;
    _53 = max(_53, 9.9999997473787516355514526367188e-05f);
    _53 = log2(_53);
    _53 *= _13_m2;
    _53 = exp2(_53);
    _70 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _70;
    _9.x *= _53;
    _9.x *= _13_m1;
    _30.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _30.x = rsqrt(_30.x);
    _30 = _30.xxx * vs_TEXCOORD0;
    _114 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
    _114 = sqrt(_114);
    _122.x = max(_114, 9.9999997473787516355514526367188e-05f);
    _122 = vs_TEXCOORD1.xyz / _122.xxx;
    _30.x = dot(_30, _122);
    _53 = max(abs(_30.x), 9.9999997473787516355514526367188e-05f);
    _53 = log2(_53);
    _53 *= _13_m4;
    _53 = exp2(_53);
    _9.x = _53 * _9.x;
    _30.x = max(_13_m5, 0.001000000047497451305389404296875f);
    _30.x = _114 / _30.x;
    _30.x = min(_30.x, 1.0f);
    _9.x *= _30.x;
    _9 = _9.xxx * _13_m0.xyz;
    _30.x = vs_TEXCOORD2;
    _30.x = clamp(_30.x, 0.0f, 1.0f);
    _30 = _9 * _30.xxx;
    _193 = float4(_30.x, _30.y, _30.z, _193.w);
    _193.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._193 = _193;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
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
float _LengthSource;
float _Apex;
float _Base;
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
#define _22_m6 _LengthSource
#define _22_m7 _Apex
#define _22_m8 _Base



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _155;
static float3 vs_TEXCOORD0;
static float2 _225;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _155 : NORMAL;
    float2 _225 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _65;
static float _174;
static bool2 _192;
static float _203;
static bool _247;

void vert_inner()
{
    __unity_init();
    float3 _30 = _11.yyy * _22_m2[1].xyz;
    _9 = float4(_30.x, _30.y, _30.z, _9.w);
    float3 _42 = (_22_m2[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    float3 _53 = (_22_m2[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _62 = _9.xyz + _22_m2[3].xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _9.yyyy * _22_m4[1];
    _65 = (_22_m4[0] * _9.xxxx) + _65;
    _65 = (_22_m4[2] * _9.zzzz) + _65;
    float3 _94 = (-_9.xyz) + _22_m0;
    vs_TEXCOORD1 = float4(_94.x, _94.y, _94.z, vs_TEXCOORD1.w);
    _9 = _65 + _22_m4[3];
    gl_Position = _9;
    _9.x = _9.z / _22_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _22_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _22_m5.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    _9.x = dot(_155, _22_m3[0].xyz);
    _9.y = dot(_155, _22_m3[1].xyz);
    _9.z = dot(_155, _22_m3[2].xyz);
    _174 = dot(_9.xyz, _9.xyz);
    _174 = rsqrt(_174);
    vs_TEXCOORD0 = _174.xxx * _9.xyz;
    float4 _196 = _22_m6.xxxx;
    _192 = bool4(_196.x < float4(0.5f, 1.5f, 0.0f, 0.0f).x, _196.y < float4(0.5f, 1.5f, 0.0f, 0.0f).y, _196.z < float4(0.5f, 1.5f, 0.0f, 0.0f).z, _196.w < float4(0.5f, 1.5f, 0.0f, 0.0f).w).xy;
    float _208;
    if (_192.y)
    {
        _208 = _11.y;
    }
    else
    {
        _208 = _11.z;
    }
    _203 = _208;
    float _220;
    if (_192.x)
    {
        _220 = _225.y;
    }
    else
    {
        _220 = _203;
    }
    _9.x = _220;
    _9.x += (-_22_m7);
    _203 = (-_22_m7) + _22_m8;
    _247 = abs(_203) < 9.9999997473787516355514526367188e-05f;
    _203 = _247 ? 9.9999997473787516355514526367188e-05f : _203;
    vs_TEXCOORD1.w = _9.x / _203;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _155 = stage_input._155;
    _225 = stage_input._225;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float _Intensity;
float _LengthFalloff;
float _ApexSoftness;
float _EdgeSoftness;
float _CameraFade;
#define _13_m0 _Color
#define _13_m1 _Intensity
#define _13_m2 _LengthFalloff
#define _13_m3 _ApexSoftness
#define _13_m4 _EdgeSoftness
#define _13_m5 _CameraFade



static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _193;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _193 : SV_Target0;
};

static float3 _9;
static float3 _30;
static float _53;
static float _70;
static float _114;
static float3 _122;

void frag_inner()
{
    _9.x = _13_m3 + 0.001000000047497451305389404296875f;
    _9.x = 1.0f / _9.x;
    _30.x = vs_TEXCOORD1.w;
    _30.x = clamp(_30.x, 0.0f, 1.0f);
    _9.x *= _30.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _53 = (-_30.x) + 1.0f;
    _53 = max(_53, 9.9999997473787516355514526367188e-05f);
    _53 = log2(_53);
    _53 *= _13_m2;
    _53 = exp2(_53);
    _70 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _70;
    _9.x *= _53;
    _9.x *= _13_m1;
    _30.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _30.x = rsqrt(_30.x);
    _30 = _30.xxx * vs_TEXCOORD0;
    _114 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
    _114 = sqrt(_114);
    _122.x = max(_114, 9.9999997473787516355514526367188e-05f);
    _122 = vs_TEXCOORD1.xyz / _122.xxx;
    _30.x = dot(_30, _122);
    _53 = max(abs(_30.x), 9.9999997473787516355514526367188e-05f);
    _53 = log2(_53);
    _53 *= _13_m4;
    _53 = exp2(_53);
    _9.x = _53 * _9.x;
    _30.x = max(_13_m5, 0.001000000047497451305389404296875f);
    _30.x = _114 / _30.x;
    _30.x = min(_30.x, 1.0f);
    _9.x *= _30.x;
    _9 = _9.xxx * _13_m0.xyz;
    _30.x = vs_TEXCOORD2;
    _30.x = clamp(_30.x, 0.0f, 1.0f);
    _30 = _9 * _30.xxx;
    _193 = float4(_30.x, _30.y, _30.z, _193.w);
    _193.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._193 = _193;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
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
float _LengthSource;
float _Apex;
float _Base;
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
#define _22_m6 _LengthSource
#define _22_m7 _Apex
#define _22_m8 _Base



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _148;
static float3 vs_TEXCOORD0;
static float2 _218;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _148 : NORMAL;
    float2 _218 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _65;
static float _167;
static bool2 _185;
static float _196;
static bool _240;

void vert_inner()
{
    __unity_init();
    float3 _30 = _11.yyy * _22_m2[1].xyz;
    _9 = float4(_30.x, _30.y, _30.z, _9.w);
    float3 _42 = (_22_m2[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    float3 _53 = (_22_m2[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _62 = _9.xyz + _22_m2[3].xyz;
    _9 = float4(_62.x, _62.y, _62.z, _9.w);
    _65 = _9.yyyy * _22_m4[1];
    _65 = (_22_m4[0] * _9.xxxx) + _65;
    _65 = (_22_m4[2] * _9.zzzz) + _65;
    float3 _94 = (-_9.xyz) + _22_m0;
    vs_TEXCOORD1 = float4(_94.x, _94.y, _94.z, vs_TEXCOORD1.w);
    _9 = _65 + _22_m4[3];
    gl_Position = _9;
    _9.x = _9.z / _22_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _22_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _22_m5.z) + _22_m5.w;
    _9.x = dot(_148, _22_m3[0].xyz);
    _9.y = dot(_148, _22_m3[1].xyz);
    _9.z = dot(_148, _22_m3[2].xyz);
    _167 = dot(_9.xyz, _9.xyz);
    _167 = rsqrt(_167);
    vs_TEXCOORD0 = _167.xxx * _9.xyz;
    float4 _189 = _22_m6.xxxx;
    _185 = bool4(_189.x < float4(0.5f, 1.5f, 0.0f, 0.0f).x, _189.y < float4(0.5f, 1.5f, 0.0f, 0.0f).y, _189.z < float4(0.5f, 1.5f, 0.0f, 0.0f).z, _189.w < float4(0.5f, 1.5f, 0.0f, 0.0f).w).xy;
    float _201;
    if (_185.y)
    {
        _201 = _11.y;
    }
    else
    {
        _201 = _11.z;
    }
    _196 = _201;
    float _213;
    if (_185.x)
    {
        _213 = _218.y;
    }
    else
    {
        _213 = _196;
    }
    _9.x = _213;
    _9.x += (-_22_m7);
    _196 = (-_22_m7) + _22_m8;
    _240 = abs(_196) < 9.9999997473787516355514526367188e-05f;
    _196 = _240 ? 9.9999997473787516355514526367188e-05f : _196;
    vs_TEXCOORD1.w = _9.x / _196;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _148 = stage_input._148;
    _218 = stage_input._218;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float _Intensity;
float _LengthFalloff;
float _ApexSoftness;
float _EdgeSoftness;
float _CameraFade;
#define _13_m0 _Color
#define _13_m1 _Intensity
#define _13_m2 _LengthFalloff
#define _13_m3 _ApexSoftness
#define _13_m4 _EdgeSoftness
#define _13_m5 _CameraFade



static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _193;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _193 : SV_Target0;
};

static float3 _9;
static float3 _30;
static float _53;
static float _70;
static float _114;
static float3 _122;

void frag_inner()
{
    _9.x = _13_m3 + 0.001000000047497451305389404296875f;
    _9.x = 1.0f / _9.x;
    _30.x = vs_TEXCOORD1.w;
    _30.x = clamp(_30.x, 0.0f, 1.0f);
    _9.x *= _30.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _53 = (-_30.x) + 1.0f;
    _53 = max(_53, 9.9999997473787516355514526367188e-05f);
    _53 = log2(_53);
    _53 *= _13_m2;
    _53 = exp2(_53);
    _70 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _70;
    _9.x *= _53;
    _9.x *= _13_m1;
    _30.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _30.x = rsqrt(_30.x);
    _30 = _30.xxx * vs_TEXCOORD0;
    _114 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
    _114 = sqrt(_114);
    _122.x = max(_114, 9.9999997473787516355514526367188e-05f);
    _122 = vs_TEXCOORD1.xyz / _122.xxx;
    _30.x = dot(_30, _122);
    _53 = max(abs(_30.x), 9.9999997473787516355514526367188e-05f);
    _53 = log2(_53);
    _53 *= _13_m4;
    _53 = exp2(_53);
    _9.x = _53 * _9.x;
    _30.x = max(_13_m5, 0.001000000047497451305389404296875f);
    _30.x = _114 / _30.x;
    _30.x = min(_30.x, 1.0f);
    _9.x *= _30.x;
    _9 = _9.xxx * _13_m0.xyz;
    _30.x = vs_TEXCOORD2;
    _30.x = clamp(_30.x, 0.0f, 1.0f);
    _30 = _9 * _30.xxx;
    _193 = float4(_30.x, _30.y, _30.z, _193.w);
    _193.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._193 = _193;
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
float _LengthSource;
float _Apex;
float _Base;
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
#define _22_m4 _LengthSource
#define _22_m5 _Apex
#define _22_m6 _Base



static float4 gl_Position;
static float4 _12;
static float4 vs_TEXCOORD1;
static float3 _96;
static float3 vs_TEXCOORD0;
static float2 _168;

struct SPIRV_Cross_Input
{
    float4 _12 : POSITION;
    float3 _96 : NORMAL;
    float2 _168 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float4 _55;
static float _118;
static bool2 _133;
static float _146;
static bool _190;

void vert_inner()
{
    __unity_init();
    _9 = _12.yyy * _22_m1[1].xyz;
    _9 = (_22_m1[0].xyz * _12.xxx) + _9;
    _9 = (_22_m1[2].xyz * _12.zzz) + _9;
    _9 += _22_m1[3].xyz;
    _55 = _9.yyyy * _22_m3[1];
    _55 = (_22_m3[0] * _9.xxxx) + _55;
    _55 = (_22_m3[2] * _9.zzzz) + _55;
    float3 _82 = (-_9) + _22_m0;
    vs_TEXCOORD1 = float4(_82.x, _82.y, _82.z, vs_TEXCOORD1.w);
    gl_Position = _55 + _22_m3[3];
    _9.x = dot(_96, _22_m2[0].xyz);
    _9.y = dot(_96, _22_m2[1].xyz);
    _9.z = dot(_96, _22_m2[2].xyz);
    _118 = dot(_9, _9);
    _118 = rsqrt(_118);
    vs_TEXCOORD0 = _118.xxx * _9;
    float4 _138 = _22_m4.xxxx;
    _133 = bool4(_138.x < float4(0.5f, 1.5f, 0.0f, 0.0f).x, _138.y < float4(0.5f, 1.5f, 0.0f, 0.0f).y, _138.z < float4(0.5f, 1.5f, 0.0f, 0.0f).z, _138.w < float4(0.5f, 1.5f, 0.0f, 0.0f).w).xy;
    float _151;
    if (_133.y)
    {
        _151 = _12.y;
    }
    else
    {
        _151 = _12.z;
    }
    _146 = _151;
    float _163;
    if (_133.x)
    {
        _163 = _168.y;
    }
    else
    {
        _163 = _146;
    }
    _9.x = _163;
    _9.x += (-_22_m5);
    _146 = (-_22_m5) + _22_m6;
    _190 = abs(_146) < 9.9999997473787516355514526367188e-05f;
    _146 = _190 ? 9.9999997473787516355514526367188e-05f : _146;
    vs_TEXCOORD1.w = _9.x / _146;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _96 = stage_input._96;
    _168 = stage_input._168;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float _Intensity;
float _LengthFalloff;
float _ApexSoftness;
float _EdgeSoftness;
float _CameraFade;
#define _12_m0 _Color
#define _12_m1 _Intensity
#define _12_m2 _LengthFalloff
#define _12_m3 _ApexSoftness
#define _12_m4 _EdgeSoftness
#define _12_m5 _CameraFade



static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float4 _153;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _153 : SV_Target0;
};

static float _8;
static float3 _25;
static float _46;
static float _63;
static float _97;
static float3 _105;

void frag_inner()
{
    _8 = _12_m3 + 0.001000000047497451305389404296875f;
    _8 = 1.0f / _8;
    _25.x = vs_TEXCOORD1.w;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _8 *= _25.x;
    _8 = clamp(_8, 0.0f, 1.0f);
    _46 = (-_25.x) + 1.0f;
    _46 = max(_46, 9.9999997473787516355514526367188e-05f);
    _46 = log2(_46);
    _46 *= _12_m2;
    _46 = exp2(_46);
    _63 = (_8 * (-2.0f)) + 3.0f;
    _8 *= _8;
    _8 *= _63;
    _8 *= _46;
    _8 *= _12_m1;
    _25.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _25.x = rsqrt(_25.x);
    _25 = _25.xxx * vs_TEXCOORD0;
    _97 = dot(vs_TEXCOORD1.xyz, vs_TEXCOORD1.xyz);
    _97 = sqrt(_97);
    _105.x = max(_97, 9.9999997473787516355514526367188e-05f);
    _105 = vs_TEXCOORD1.xyz / _105.xxx;
    _25.x = dot(_25, _105);
    _46 = max(abs(_25.x), 9.9999997473787516355514526367188e-05f);
    _46 = log2(_46);
    _46 *= _12_m4;
    _46 = exp2(_46);
    _8 = _46 * _8;
    _25.x = max(_12_m5, 0.001000000047497451305389404296875f);
    _25.x = _97 / _25.x;
    _25.x = min(_25.x, 1.0f);
    _8 *= _25.x;
    float3 _161 = _8.xxx * _12_m0.xyz;
    _153 = float4(_161.x, _161.y, _161.z, _153.w);
    _153.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._153 = _153;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}