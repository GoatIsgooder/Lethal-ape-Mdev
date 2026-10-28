// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Fnaf/CrtScreen" {
Properties {

[Header(Picture)] _MainTex ("Picture", 2D) = "black" { }

_Gain ("Gain", Range(0, 4)) = 1.25

_BlackLevel ("Black Level", Color) = (0.008,0.016,0.011,1)

_Bloom ("Phosphor Bloom", Range(0, 1)) = 0.30000001192092896

_BloomMip ("Bloom Mip", Range(0, 6)) = 3.0

[Header(Glass)] _Scanlines ("Scanlines", Range(0, 1)) = 0.14000000059604645

_ScanlineCount ("Scanline Count", Float) = 212.0

_Vignette ("Vignette", Range(0, 2)) = 0.41999998688697815

_Aspect ("Glass Aspect (w / h)", Float) = 1.2109999656677246

_CornerRadius ("Corner Radius (of the height)", Range(0, 0.5)) = 0.17000000178813934

_CornerSoftness ("Corner Softness", Range(0.001, 0.05)) = 0.009999999776482582

_Sheen ("Glass Sheen", Range(0, 0.2)) = 0.029999999329447746

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
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
float4 _MainTex_ST;
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
#define _20_m2 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _86;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m0[1];
    _9 = (_20_m0[0] * _11.xxxx) + _9;
    _9 = (_20_m0[2] * _11.zzzz) + _9;
    _9 += _20_m0[3];
    _48 = _9.yyyy * _20_m1[1];
    _48 = (_20_m1[0] * _9.xxxx) + _48;
    _48 = (_20_m1[2] * _9.zzzz) + _48;
    gl_Position = (_20_m1[3] * _9.wwww) + _48;
    vs_TEXCOORD0 = (_86 * _20_m2.xy) + _20_m2.zw;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Gain;
float4 _BlackLevel;
float _Bloom;
float _BloomMip;
float _Scanlines;
float _ScanlineCount;
float _Vignette;
float _Aspect;
float _CornerRadius;
float _CornerSoftness;
float _Sheen;
#define _21_m0 _Gain
#define _21_m1 _BlackLevel
#define _21_m2 _Bloom
#define _21_m3 _BloomMip
#define _21_m4 _Scanlines
#define _21_m5 _ScanlineCount
#define _21_m6 _Vignette
#define _21_m7 _Aspect
#define _21_m8 _CornerRadius
#define _21_m9 _CornerSoftness
#define _21_m10 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _312;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _312 : SV_Target0;
};

static float3 _9;
static float2 _32;
static float _37;
static float3 _79;
static float3 _95;
static float3 _104;
static float3 _112;
static float4 _171;
static float2 _217;
static float _252;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.y * _21_m5;
    _32.x = ddx_coarse(_9.x);
    _37 = ddy_coarse(_9.x);
    _9.x *= 6.283185482025146484375f;
    _9.x = cos(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _32.x = abs(_37) + abs(_32.x);
    _32.x = (-_32.x) + 0.5f;
    _32.x *= 4.0f;
    _32.x = clamp(_32.x, 0.0f, 1.0f);
    _79.x = _32.x * _21_m4;
    _79.x = ((-_79.x) * _9.x) + 1.0f;
    _95 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _104 = _MainTex.SampleLevel(sampler_MainTex, vs_TEXCOORD0, _21_m3).xyz;
    _112 = (_104 * _21_m2.xxx) + _95;
    _112 *= _21_m0.xxx;
    _112 = max(_112, _21_m1.xyz);
    _79 = _79.xxx * _112;
    float2 _144 = (vs_TEXCOORD0 * 2.0f.xx) + (-1.0f).xx;
    _9 = float3(_144.x, _144.y, _9.z);
    _9.x = dot(_9.xy, _9.xy);
    _9.x *= _21_m6;
    _9.x = ((-_9.x) * 0.5f) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _171 = vs_TEXCOORD0.xyxy + float4(-0.300000011920928955078125f, -0.819999992847442626953125f, -0.5f, -0.5f);
    _32 = _171.xy * float2(1.39999997615814208984375f, 2.599999904632568359375f);
    _32.x = dot(_32, _32);
    _32.x = (-_32.x) + 1.0f;
    _32.x = max(_32.x, 0.0f);
    _32.x *= _21_m10;
    _9 = (_79 * _9.xxx) + _32.xxx;
    _171.x = _21_m7;
    _171.y = 1.0f;
    _217 = _171.xy * _171.zw;
    float2 _237 = (_171.xy * 0.5f.xx) + (-float2(float2(_21_m8, _21_m8)));
    _171 = float4(_237.x, _237.y, _171.z, _171.w);
    float2 _245 = (-_171.xy) + abs(_217);
    _171 = float4(_245.x, _245.y, _171.z, _171.w);
    _217 = max(_171.xy, 0.0f.xx);
    _252 = max(_171.y, _171.x);
    _252 = min(_252, 0.0f);
    _171.x = dot(_217, _217);
    _171.x = sqrt(_171.x);
    _252 += _171.x;
    _252 += (-_21_m8);
    _252 += _21_m9;
    _171.x = 1.0f / _21_m9;
    _252 *= _171.x;
    _252 = clamp(_252, 0.0f, 1.0f);
    _171.x = (_252 * (-2.0f)) + 3.0f;
    _252 *= _252;
    _252 = ((-_171.x) * _252) + 1.0f;
    _9 = _252.xxx * _9;
    _312 = float4(_9.x, _9.y, _9.z, _312.w);
    _312.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._312 = _312;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}