// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MenuBlurBackdrop" {
Properties {

_Snapshot ("Snapshot", Cube) = "" { }

_Lod ("Blur Mip", Float) = 4.0

_Spread ("Tap Spread", Float) = 0.05999999865889549

_Tint ("Tint", Color) = (0.65,0.65,0.65,1)

_Amount ("Amount", Range(0, 1)) = 0.0

_Center ("Centre (world)", Vector) = (0,0,0,0)

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+15" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+15" "RenderType" = "Transparent" }
 ZTest Always
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
 ZTest Always
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _20_m0[4];
float4x4 unity_MatrixVP;
static float4 _20_m1[4];
void __unity_init()
{
    _20_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m1[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m1[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m1[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m1[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _43;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m0[1];
    _9 = (_20_m0[0] * _11.xxxx) + _9;
    _9 = (_20_m0[2] * _11.zzzz) + _9;
    _43 = _9 + _20_m0[3];
    vs_TEXCOORD0 = (_20_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _43.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _43.xxxx) + _9;
    _9 = (_20_m1[2] * _43.zzzz) + _9;
    gl_Position = (_20_m1[3] * _43.wwww) + _9;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Lod;
float _Spread;
float _Amount;
float4 _Tint;
float4 _Center;
#define _16_m0 _Lod
#define _16_m1 _Spread
#define _16_m2 _Amount
#define _16_m3 _Tint
#define _16_m4 _Center


TextureCube<float4> _Snapshot;
SamplerState sampler_Snapshot;

static float3 vs_TEXCOORD0;
static float4 _196;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _196 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _32;
static bool _39;
static float3 _47;
static float3 _56;
static float _69;
static float3 _100;
static float3 _116;
static float3 _129;
static float3 _173;
static float3 _180;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-_16_m4.xyz);
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _32 = _26.xxx * _9;
    _39 = abs(_32.y) < 0.9900000095367431640625f;
    bool3 _54 = _39.xxx;
    _47 = float3(_54.x ? float3(0.0f, 0.0f, 1.0f).x : float3(0.0f, 1.0f, 0.0f).x, _54.y ? float3(0.0f, 0.0f, 1.0f).y : float3(0.0f, 1.0f, 0.0f).y, _54.z ? float3(0.0f, 0.0f, 1.0f).z : float3(0.0f, 1.0f, 0.0f).z);
    _56 = _32.yzx * _47;
    _47 = (_47.zxy * _32.zxy) + (-_56);
    _69 = dot(_47, _47);
    _69 = rsqrt(_69);
    _47 = _69.xxx * _47;
    _47 *= float3(float3(_16_m1, _16_m1, _16_m1));
    _56 = (_9 * _26.xxx) + _47;
    _100 = _Snapshot.SampleLevel(sampler_Snapshot, _56, _16_m0).xyz;
    _56 = _100 * 0.180000007152557373046875f.xxx;
    _116 = _Snapshot.SampleLevel(sampler_Snapshot, _32, _16_m0).xyz;
    _56 = (_116 * 0.2800000011920928955078125f.xxx) + _56;
    _129 = (_9 * _26.xxx) + (-_47);
    _116 = _Snapshot.SampleLevel(sampler_Snapshot, _129, _16_m0).xyz;
    _56 = (_116 * 0.180000007152557373046875f.xxx) + _56;
    _129 = _32.zxy * _47.yzx;
    _32 = (_32.yzx * _47.zxy) + (-_129);
    _47 = (_9 * _26.xxx) + _32;
    _9 = (_9 * _26.xxx) + (-_32);
    _173 = _Snapshot.SampleLevel(sampler_Snapshot, _9, _16_m0).xyz;
    _180 = _Snapshot.SampleLevel(sampler_Snapshot, _47, _16_m0).xyz;
    _32 = (_180 * 0.180000007152557373046875f.xxx) + _56;
    _9 = (_173 * 0.180000007152557373046875f.xxx) + _32;
    float3 _202 = _9 * _16_m3.xyz;
    _196 = float4(_202.x, _202.y, _202.z, _196.w);
    _196.w = _16_m2;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._196 = _196;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}