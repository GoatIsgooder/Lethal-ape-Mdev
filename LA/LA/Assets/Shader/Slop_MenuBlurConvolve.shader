// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MenuBlurConvolve" {
Properties {

_Source ("Source", Cube) = "" { }

_Cone ("Blur Radius (degrees)", Float) = 14.0

_Lod ("Source Mip", Float) = 3.0

_Center ("Centre (world)", Vector) = (0,0,0,0)

}
SubShader {
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
  Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 ZTest Always
 ZWrite Off
 Cull Off
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
float _Cone;
float _Lod;
float4 _Center;
#define _16_m0 _Cone
#define _16_m1 _Lod
#define _16_m2 _Center


TextureCube<float4> _Source;
SamplerState sampler_Source;

static float3 vs_TEXCOORD0;
static float4 _240;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _240 : SV_Target0;
};

static float3 _9;
static float _26;
static bool _38;
static float3 _46;
static float3 _55;
static float2 _92;
static float3 _107;
static float _113;
static float2 _124;
static float _149;
static float _153;
static float _157;
static float _161;
static float3 _165;
static float3 _211;
static bool _259;
static int _261;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-_16_m2.xyz);
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _38 = abs(_9.y) < 0.9900000095367431640625f;
    bool3 _53 = _38.xxx;
    _46 = float3(_53.x ? float3(0.0f, 0.0f, 1.0f).x : float3(0.0f, 1.0f, 0.0f).x, _53.y ? float3(0.0f, 0.0f, 1.0f).y : float3(0.0f, 1.0f, 0.0f).y, _53.z ? float3(0.0f, 0.0f, 1.0f).z : float3(0.0f, 1.0f, 0.0f).z);
    _55 = _9.yzx * _46;
    _46 = (_46.zxy * _9.zxy) + (-_55);
    _26 = dot(_46, _46);
    _26 = rsqrt(_26);
    _46 = _26.xxx * _46;
    _55 = _9.zxy * _46.yzx;
    _55 = (_9.yzx * _46.zxy) + (-_55);
    _92 = _16_m0.xx * float2(0.01745329238474369049072265625f, 0.0078539811074733734130859375f);
    _26 = _92.y * _92.y;
    _107.x = 0.0f;
    _107.y = 0.0f;
    _107.z = 0.0f;
    _113 = 0.0f;
    for (int _115 = 0; _115 < 64; _115++)
    {
        _124.x = float(_115);
        _124.x += 0.5f;
        _124 = _124.xx * float2(0.015625f, 2.3999631404876708984375f);
        _124.x = sqrt(_124.x);
        _124.x = _92.x * _124.x;
        _149 = sin(_124.x);
        _153 = cos(_124.x);
        _157 = sin(_124.y);
        _161 = cos(_124.y);
        _165 = _55 * _157.xxx;
        _165 = (_46 * _161.xxx) + _165;
        _165 = _149.xxx * _165;
        _165 = (_9 * _153.xxx) + _165;
        _124.x *= _124.x;
        _124.x *= (-0.5f);
        _124.x /= _26;
        _124.x *= 1.44269502162933349609375f;
        _124.x = exp2(_124.x);
        _211 = _Source.SampleLevel(sampler_Source, _165, _16_m1).xyz;
        _107 = (_211 * _124.xxx) + _107;
        _113 += _124.x;
    }
    _9 = _107 / _113.xxx;
    _240 = float4(_9.x, _9.y, _9.z, _240.w);
    _240.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._240 = _240;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}