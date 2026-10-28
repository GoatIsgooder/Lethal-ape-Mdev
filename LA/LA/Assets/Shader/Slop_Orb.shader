// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Orb" {
Properties {

_Grid ("Grid", 2D) = "white" { }

_Vector2 ("Tiling", Vector) = (5,3,0,0)

_FresnleColor ("Fresnel Color", Color) = (0.212,0.683,1,1)

_FresnlePower ("Fresnel Power", Range(0.01, 16)) = 5.0

_Power ("Grid Power", Range(0.01, 8)) = 1.5099999904632568

}
SubShader {
 LOD 100
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  LOD 100
  Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 _Vector2;
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
#define _22_m4 _Vector2



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _108;
static float3 _116;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _116 : NORMAL;
    float2 _108 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float _138;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    float3 _59 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    vs_TEXCOORD2 = (-_9.xyz) + _22_m0;
    _9 = _45.yyyy * _22_m3[1];
    _9 = (_22_m3[0] * _45.xxxx) + _9;
    _9 = (_22_m3[2] * _45.zzzz) + _9;
    gl_Position = (_22_m3[3] * _45.wwww) + _9;
    vs_TEXCOORD0 = _108 * _22_m4.xy;
    _9.x = dot(_116, _22_m2[0].xyz);
    _9.y = dot(_116, _22_m2[1].xyz);
    _9.z = dot(_116, _22_m2[2].xyz);
    _138 = dot(_9.xyz, _9.xyz);
    _138 = rsqrt(_138);
    vs_TEXCOORD1 = _138.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _108 = stage_input._108;
    _116 = stage_input._116;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _FresnleColor;
float _FresnlePower;
float _Power;
#define _64_m0 _FresnleColor
#define _64_m1 _FresnlePower
#define _64_m2 _Power


Texture2D<float4> _Grid;
SamplerState sampler_Grid;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float4 _119;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _119 : SV_Target0;
};

static float3 _9;
static float _27;
static float3 _34;
static float3 _39;
static float3 _84;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD1;
    _27 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _27 = rsqrt(_27);
    _34 = _27.xxx * vs_TEXCOORD2;
    _39.x = dot(_9, _34);
    _39.x = clamp(_39.x, 0.0f, 1.0f);
    _9.x = (-_39.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _64_m1;
    _9.x = exp2(_9.x);
    _39 = _9.xxx * _64_m0.xyz;
    _84 = _Grid.Sample(sampler_Grid, vs_TEXCOORD0).xyz;
    _9 = max(_84, 9.9999997473787516355514526367188e-05f.xxx);
    _9 = log2(_9);
    _9 *= float3(float3(_64_m2, _64_m2, _64_m2));
    _9 = exp2(_9);
    float3 _126 = (_9 * _64_m0.xyz) + _39;
    _119 = float4(_126.x, _126.y, _126.z, _119.w);
    _119.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._119 = _119;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}