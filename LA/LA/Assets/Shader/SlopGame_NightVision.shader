// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SlopGame/NightVision" {
Properties {

[Header(Feed)] _MainTex ("Camera Feed (RT)", 2D) = "black" { }

_NightVision ("Night Vision Amount", Range(0, 1)) = 1.0

_Brightness ("Brightness", Range(0, 4)) = 1.3200000524520874

_Contrast ("Contrast", Range(0, 4)) = 1.0299999713897705

[Header(Intensifier)] _Gain ("Low-light Gain", Range(1, 8)) = 1.0

_NVColor ("Phosphor Color", Color) = (0.25,1,0.45,1)

_EmissionStrength ("Screen Glow", Range(0, 8)) = 2.5999999046325684

[Header(Bloom (bright bleed))] [Toggle(BLOOM_ON)] _BloomEnabled ("Enable Bloom", Float) = 1.0

_BloomAmount ("Bloom Amount", Range(0, 4)) = 1.399999976158142

_BloomThreshold ("Bloom Threshold", Range(0, 1)) = 0.550000011920929

_BloomRadius ("Bloom Radius (px)", Range(0, 6)) = 2.5

[Header(Sensor grain)] _NoiseAmount ("Grain Amount", Range(0, 1)) = 0.18000000715255737

_NoiseSpeed ("Grain Speed", Range(0, 60)) = 60.0

[Header(Scanlines)] _ScanlineDensity ("Scanline Density", Range(0, 600)) = 320.0

_ScanlineDark ("Scanline Darkness", Range(0, 1)) = 0.18000000715255737

_ScanlineSpeed ("Scanline Drift", Range(-4, 4)) = -0.6000000238418579

[Header(Vignette)] _VignInner ("Vignette Inner", Range(0, 1.5)) = 0.550000011920929

_VignOuter ("Vignette Outer", Range(0, 1.5)) = 1.0499999523162842

[Header(Lens)] [Toggle(ABERRATION_ON)] _AberrationEnabled ("Enable Chromatic Fringe", Float) = 1.0

_Aberration ("Fringe Amount", Range(0, 0.02)) = 0.004000000189989805

[Toggle(DISTORT_ON)] _DistortEnabled ("Enable Barrel Distort", Float) = 1.0

_Distortion ("Barrel Amount", Range(-0.5, 0.5)) = 0.5

[Header(Flicker)] _Flicker ("Flicker Amount", Range(0, 0.4)) = 0.05999999865889549

_FlickerSpeed ("Flicker Speed", Range(0, 60)) = 12.0

_Battery ("Battery (1=full)", Range(0, 1)) = 1.0

[Header(Overlay)] [Toggle(REC_ON)] _RecEnabled ("Show REC dot", Float) = 1.0

_RecColor ("REC Color", Color) = (1,0.1,0.1,1)

[Toggle(BRACKETS_ON)] _BracketsEnabled ("Show Viewfinder Brackets", Float) = 1.0

_BracketColor ("Bracket Color", Color) = (0.6,1,0.7,1)

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
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 unity_FogParams
#define _20_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _126;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _126 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    vs_TEXCOORD0 = (_126 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD1 = _126;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _126 = stage_input._126;
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
float4 _Time;
float4 unity_FogColor;
float4 _MainTex_TexelSize;
float _NightVision;
float _Brightness;
float _Contrast;
float _Gain;
float _EmissionStrength;
float4 _NVColor;
float _NoiseAmount;
float _NoiseSpeed;
float _ScanlineDensity;
float _ScanlineDark;
float _ScanlineSpeed;
float _VignInner;
float _VignOuter;
float _Flicker;
float _FlickerSpeed;
float _Battery;
#define _41_m0 _Time
#define _41_m1 unity_FogColor
#define _41_m2 _MainTex_TexelSize
#define _41_m3 _NightVision
#define _41_m4 _Brightness
#define _41_m5 _Contrast
#define _41_m6 _Gain
#define _41_m7 _EmissionStrength
#define _41_m8 _NVColor
#define _41_m9 _NoiseAmount
#define _41_m10 _NoiseSpeed
#define _41_m11 _ScanlineDensity
#define _41_m12 _ScanlineDark
#define _41_m13 _ScanlineSpeed
#define _41_m14 _VignInner
#define _41_m15 _VignOuter
#define _41_m16 _Flicker
#define _41_m17 _FlickerSpeed
#define _41_m18 _Battery


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _420;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _420 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _33;
static float3 _106;
static float3 _139;
static float2 _150;
static float _163;
static bool _183;
static float2 _209;
static float _237;
static float2 _254;
static float _274;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22.x = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
    _33 = _9 + (-0.5f).xxx;
    _33 = (_33 * float3(float3(_41_m5, _41_m5, _41_m5))) + 0.5f.xxx;
    _33 = clamp(_33, 0.0f.xxx, 1.0f.xxx);
    _33 *= float3(float3(_41_m4, _41_m4, _41_m4));
    _22.x += (-0.5f);
    _22.x = (_22.x * _41_m5) + 0.5f;
    _22.x = clamp(_22.x, 0.0f, 1.0f);
    _22.x *= _41_m6;
    _22.x = clamp(_22.x, 0.0f, 1.0f);
    _106 = _22.xxx * _41_m8.xyz;
    _106 = (_106 * float3(float3(_41_m4, _41_m4, _41_m4))) + (-_33);
    _22 = (_41_m3.xxx * _106) + _33;
    float2 _146 = vs_TEXCOORD1 * _41_m2.zw;
    _139 = float3(_146.x, _146.y, _139.z);
    _150 = _41_m0.yy * float2(_41_m10, _41_m13);
    _163 = (_150.y * 0.0500000007450580596923828125f) + vs_TEXCOORD1.y;
    _150.y = _163 * _41_m11;
    _150 = frac(_150);
    _183 = _150.y >= 0.5f;
    float2 _193 = (_139.xy * 0.5f.xx) + _150.xx;
    _139 = float3(_193.x, _193.y, _139.z);
    float2 _201 = _139.xy * float2(443.897491455078125f, 397.29730224609375f);
    _139 = float3(_201.x, _201.y, _139.z);
    float2 _206 = frac(_139.xy);
    _139 = float3(_206.x, _206.y, _139.z);
    _209 = _139.yx + 19.1900005340576171875f.xx;
    _150.x = dot(_139.xy, _209);
    float2 _224 = _150.xx + _139.xy;
    _139 = float3(_224.x, _224.y, _139.z);
    _139.x = _139.y * _139.x;
    _139.x = frac(_139.x);
    _237 = _139.x + (-0.5f);
    _106 = (_41_m8.xyz * 0.60000002384185791015625f.xxx) + 0.4000000059604644775390625f.xxx;
    _106 = _237.xxx * _106;
    _254 = (-float2(float2(_41_m18, _41_m18))) + float2(1.0f, 2.0f);
    _237 = _254.y * _41_m9;
    _274 = (_254.x * 0.25f) + _41_m16;
    _237 *= _41_m3;
    _22 = (_106 * _237.xxx) + _22;
    _139.x = (-_41_m12) + 1.0f;
    float _301;
    if (_183)
    {
        _301 = _139.x;
    }
    else
    {
        _301 = 1.0f;
    }
    _237 = _301;
    _22 = _237.xxx * _22;
    _139.x = _41_m0.y * _41_m17;
    _139.x *= 6.283199787139892578125f;
    _139.x = sin(_139.x);
    _139.x = (_139.x * 0.5f) + 0.5f;
    _139.x = ((-_274) * _139.x) + 1.0f;
    _139 = _139.xxx * _22;
    _209 = vs_TEXCOORD0 + (-0.5f).xx;
    _163 = dot(_209, _209);
    _163 = sqrt(_163);
    _163 += (-_41_m14);
    _209.x = (-_41_m14) + _41_m15;
    _209.x = 1.0f / _209.x;
    _163 *= _209.x;
    _163 = clamp(_163, 0.0f, 1.0f);
    _209.x = (_163 * (-2.0f)) + 3.0f;
    _163 *= _163;
    _163 = ((-_209.x) * _163) + 1.0f;
    _139 = _163.xxx * _139;
    _139 = (_139 * _41_m7.xxx) + (-_41_m1.xyz);
    _163 = vs_TEXCOORD2;
    _163 = clamp(_163, 0.0f, 1.0f);
    _139 = (_163.xxx * _139) + _41_m1.xyz;
    _420 = float4(_139.x, _139.y, _139.z, _420.w);
    _420.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._420 = _420;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 unity_FogParams
#define _20_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _132;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _132 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    vs_TEXCOORD0 = (_132 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD1 = _132;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
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
float4 _Time;
float4 unity_FogColor;
float4 _MainTex_TexelSize;
float _NightVision;
float _Brightness;
float _Contrast;
float _Gain;
float _EmissionStrength;
float4 _NVColor;
float _NoiseAmount;
float _NoiseSpeed;
float _ScanlineDensity;
float _ScanlineDark;
float _ScanlineSpeed;
float _VignInner;
float _VignOuter;
float _Flicker;
float _FlickerSpeed;
float _Battery;
#define _41_m0 _Time
#define _41_m1 unity_FogColor
#define _41_m2 _MainTex_TexelSize
#define _41_m3 _NightVision
#define _41_m4 _Brightness
#define _41_m5 _Contrast
#define _41_m6 _Gain
#define _41_m7 _EmissionStrength
#define _41_m8 _NVColor
#define _41_m9 _NoiseAmount
#define _41_m10 _NoiseSpeed
#define _41_m11 _ScanlineDensity
#define _41_m12 _ScanlineDark
#define _41_m13 _ScanlineSpeed
#define _41_m14 _VignInner
#define _41_m15 _VignOuter
#define _41_m16 _Flicker
#define _41_m17 _FlickerSpeed
#define _41_m18 _Battery


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _420;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _420 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _33;
static float3 _106;
static float3 _139;
static float2 _150;
static float _163;
static bool _183;
static float2 _209;
static float _237;
static float2 _254;
static float _274;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22.x = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
    _33 = _9 + (-0.5f).xxx;
    _33 = (_33 * float3(float3(_41_m5, _41_m5, _41_m5))) + 0.5f.xxx;
    _33 = clamp(_33, 0.0f.xxx, 1.0f.xxx);
    _33 *= float3(float3(_41_m4, _41_m4, _41_m4));
    _22.x += (-0.5f);
    _22.x = (_22.x * _41_m5) + 0.5f;
    _22.x = clamp(_22.x, 0.0f, 1.0f);
    _22.x *= _41_m6;
    _22.x = clamp(_22.x, 0.0f, 1.0f);
    _106 = _22.xxx * _41_m8.xyz;
    _106 = (_106 * float3(float3(_41_m4, _41_m4, _41_m4))) + (-_33);
    _22 = (_41_m3.xxx * _106) + _33;
    float2 _146 = vs_TEXCOORD1 * _41_m2.zw;
    _139 = float3(_146.x, _146.y, _139.z);
    _150 = _41_m0.yy * float2(_41_m10, _41_m13);
    _163 = (_150.y * 0.0500000007450580596923828125f) + vs_TEXCOORD1.y;
    _150.y = _163 * _41_m11;
    _150 = frac(_150);
    _183 = _150.y >= 0.5f;
    float2 _193 = (_139.xy * 0.5f.xx) + _150.xx;
    _139 = float3(_193.x, _193.y, _139.z);
    float2 _201 = _139.xy * float2(443.897491455078125f, 397.29730224609375f);
    _139 = float3(_201.x, _201.y, _139.z);
    float2 _206 = frac(_139.xy);
    _139 = float3(_206.x, _206.y, _139.z);
    _209 = _139.yx + 19.1900005340576171875f.xx;
    _150.x = dot(_139.xy, _209);
    float2 _224 = _150.xx + _139.xy;
    _139 = float3(_224.x, _224.y, _139.z);
    _139.x = _139.y * _139.x;
    _139.x = frac(_139.x);
    _237 = _139.x + (-0.5f);
    _106 = (_41_m8.xyz * 0.60000002384185791015625f.xxx) + 0.4000000059604644775390625f.xxx;
    _106 = _237.xxx * _106;
    _254 = (-float2(float2(_41_m18, _41_m18))) + float2(1.0f, 2.0f);
    _237 = _254.y * _41_m9;
    _274 = (_254.x * 0.25f) + _41_m16;
    _237 *= _41_m3;
    _22 = (_106 * _237.xxx) + _22;
    _139.x = (-_41_m12) + 1.0f;
    float _301;
    if (_183)
    {
        _301 = _139.x;
    }
    else
    {
        _301 = 1.0f;
    }
    _237 = _301;
    _22 = _237.xxx * _22;
    _139.x = _41_m0.y * _41_m17;
    _139.x *= 6.283199787139892578125f;
    _139.x = sin(_139.x);
    _139.x = (_139.x * 0.5f) + 0.5f;
    _139.x = ((-_274) * _139.x) + 1.0f;
    _139 = _139.xxx * _22;
    _209 = vs_TEXCOORD0 + (-0.5f).xx;
    _163 = dot(_209, _209);
    _163 = sqrt(_163);
    _163 += (-_41_m14);
    _209.x = (-_41_m14) + _41_m15;
    _209.x = 1.0f / _209.x;
    _163 *= _209.x;
    _163 = clamp(_163, 0.0f, 1.0f);
    _209.x = (_163 * (-2.0f)) + 3.0f;
    _163 *= _163;
    _163 = ((-_209.x) * _163) + 1.0f;
    _139 = _163.xxx * _139;
    _139 = (_139 * _41_m7.xxx) + (-_41_m1.xyz);
    _163 = vs_TEXCOORD2;
    _163 = clamp(_163, 0.0f, 1.0f);
    _139 = (_163.xxx * _139) + _41_m1.xyz;
    _420 = float4(_139.x, _139.y, _139.z, _420.w);
    _420.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._420 = _420;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 unity_FogParams
#define _20_m4 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _125;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _125 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _20_m3.z) + _20_m3.w;
    vs_TEXCOORD0 = (_125 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD1 = _125;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _125 = stage_input._125;
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
float4 _Time;
float4 unity_FogColor;
float4 _MainTex_TexelSize;
float _NightVision;
float _Brightness;
float _Contrast;
float _Gain;
float _EmissionStrength;
float4 _NVColor;
float _NoiseAmount;
float _NoiseSpeed;
float _ScanlineDensity;
float _ScanlineDark;
float _ScanlineSpeed;
float _VignInner;
float _VignOuter;
float _Flicker;
float _FlickerSpeed;
float _Battery;
#define _41_m0 _Time
#define _41_m1 unity_FogColor
#define _41_m2 _MainTex_TexelSize
#define _41_m3 _NightVision
#define _41_m4 _Brightness
#define _41_m5 _Contrast
#define _41_m6 _Gain
#define _41_m7 _EmissionStrength
#define _41_m8 _NVColor
#define _41_m9 _NoiseAmount
#define _41_m10 _NoiseSpeed
#define _41_m11 _ScanlineDensity
#define _41_m12 _ScanlineDark
#define _41_m13 _ScanlineSpeed
#define _41_m14 _VignInner
#define _41_m15 _VignOuter
#define _41_m16 _Flicker
#define _41_m17 _FlickerSpeed
#define _41_m18 _Battery


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _420;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _420 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _33;
static float3 _106;
static float3 _139;
static float2 _150;
static float _163;
static bool _183;
static float2 _209;
static float _237;
static float2 _254;
static float _274;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22.x = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
    _33 = _9 + (-0.5f).xxx;
    _33 = (_33 * float3(float3(_41_m5, _41_m5, _41_m5))) + 0.5f.xxx;
    _33 = clamp(_33, 0.0f.xxx, 1.0f.xxx);
    _33 *= float3(float3(_41_m4, _41_m4, _41_m4));
    _22.x += (-0.5f);
    _22.x = (_22.x * _41_m5) + 0.5f;
    _22.x = clamp(_22.x, 0.0f, 1.0f);
    _22.x *= _41_m6;
    _22.x = clamp(_22.x, 0.0f, 1.0f);
    _106 = _22.xxx * _41_m8.xyz;
    _106 = (_106 * float3(float3(_41_m4, _41_m4, _41_m4))) + (-_33);
    _22 = (_41_m3.xxx * _106) + _33;
    float2 _146 = vs_TEXCOORD1 * _41_m2.zw;
    _139 = float3(_146.x, _146.y, _139.z);
    _150 = _41_m0.yy * float2(_41_m10, _41_m13);
    _163 = (_150.y * 0.0500000007450580596923828125f) + vs_TEXCOORD1.y;
    _150.y = _163 * _41_m11;
    _150 = frac(_150);
    _183 = _150.y >= 0.5f;
    float2 _193 = (_139.xy * 0.5f.xx) + _150.xx;
    _139 = float3(_193.x, _193.y, _139.z);
    float2 _201 = _139.xy * float2(443.897491455078125f, 397.29730224609375f);
    _139 = float3(_201.x, _201.y, _139.z);
    float2 _206 = frac(_139.xy);
    _139 = float3(_206.x, _206.y, _139.z);
    _209 = _139.yx + 19.1900005340576171875f.xx;
    _150.x = dot(_139.xy, _209);
    float2 _224 = _150.xx + _139.xy;
    _139 = float3(_224.x, _224.y, _139.z);
    _139.x = _139.y * _139.x;
    _139.x = frac(_139.x);
    _237 = _139.x + (-0.5f);
    _106 = (_41_m8.xyz * 0.60000002384185791015625f.xxx) + 0.4000000059604644775390625f.xxx;
    _106 = _237.xxx * _106;
    _254 = (-float2(float2(_41_m18, _41_m18))) + float2(1.0f, 2.0f);
    _237 = _254.y * _41_m9;
    _274 = (_254.x * 0.25f) + _41_m16;
    _237 *= _41_m3;
    _22 = (_106 * _237.xxx) + _22;
    _139.x = (-_41_m12) + 1.0f;
    float _301;
    if (_183)
    {
        _301 = _139.x;
    }
    else
    {
        _301 = 1.0f;
    }
    _237 = _301;
    _22 = _237.xxx * _22;
    _139.x = _41_m0.y * _41_m17;
    _139.x *= 6.283199787139892578125f;
    _139.x = sin(_139.x);
    _139.x = (_139.x * 0.5f) + 0.5f;
    _139.x = ((-_274) * _139.x) + 1.0f;
    _139 = _139.xxx * _22;
    _209 = vs_TEXCOORD0 + (-0.5f).xx;
    _163 = dot(_209, _209);
    _163 = sqrt(_163);
    _163 += (-_41_m14);
    _209.x = (-_41_m14) + _41_m15;
    _209.x = 1.0f / _209.x;
    _163 *= _209.x;
    _163 = clamp(_163, 0.0f, 1.0f);
    _209.x = (_163 * (-2.0f)) + 3.0f;
    _163 *= _163;
    _163 = ((-_209.x) * _163) + 1.0f;
    _139 = _163.xxx * _139;
    _139 = (_139 * _41_m7.xxx) + (-_41_m1.xyz);
    _163 = vs_TEXCOORD2;
    _163 = clamp(_163, 0.0f, 1.0f);
    _139 = (_163.xxx * _139) + _41_m1.xyz;
    _420 = float4(_139.x, _139.y, _139.z, _420.w);
    _420.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._420 = _420;
    return stage_output;
}

#endif
#else
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
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
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
    vs_TEXCOORD1 = _86;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _MainTex_TexelSize;
float _NightVision;
float _Brightness;
float _Contrast;
float _Gain;
float _EmissionStrength;
float4 _NVColor;
float _NoiseAmount;
float _NoiseSpeed;
float _ScanlineDensity;
float _ScanlineDark;
float _ScanlineSpeed;
float _VignInner;
float _VignOuter;
float _Flicker;
float _FlickerSpeed;
float _Battery;
#define _41_m0 _Time
#define _41_m1 _MainTex_TexelSize
#define _41_m2 _NightVision
#define _41_m3 _Brightness
#define _41_m4 _Contrast
#define _41_m5 _Gain
#define _41_m6 _EmissionStrength
#define _41_m7 _NVColor
#define _41_m8 _NoiseAmount
#define _41_m9 _NoiseSpeed
#define _41_m10 _ScanlineDensity
#define _41_m11 _ScanlineDark
#define _41_m12 _ScanlineSpeed
#define _41_m13 _VignInner
#define _41_m14 _VignOuter
#define _41_m15 _Flicker
#define _41_m16 _FlickerSpeed
#define _41_m17 _Battery


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float4 _396;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _396 : SV_Target0;
};

static float3 _9;
static float3 _22;
static float3 _33;
static float3 _106;
static float3 _139;
static float2 _150;
static float _163;
static bool _183;
static float2 _209;
static float _237;
static float2 _254;
static float _274;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).xyz;
    _22.x = dot(_9, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
    _33 = _9 + (-0.5f).xxx;
    _33 = (_33 * float3(float3(_41_m4, _41_m4, _41_m4))) + 0.5f.xxx;
    _33 = clamp(_33, 0.0f.xxx, 1.0f.xxx);
    _33 *= float3(float3(_41_m3, _41_m3, _41_m3));
    _22.x += (-0.5f);
    _22.x = (_22.x * _41_m4) + 0.5f;
    _22.x = clamp(_22.x, 0.0f, 1.0f);
    _22.x *= _41_m5;
    _22.x = clamp(_22.x, 0.0f, 1.0f);
    _106 = _22.xxx * _41_m7.xyz;
    _106 = (_106 * float3(float3(_41_m3, _41_m3, _41_m3))) + (-_33);
    _22 = (_41_m2.xxx * _106) + _33;
    float2 _146 = vs_TEXCOORD1 * _41_m1.zw;
    _139 = float3(_146.x, _146.y, _139.z);
    _150 = _41_m0.yy * float2(_41_m9, _41_m12);
    _163 = (_150.y * 0.0500000007450580596923828125f) + vs_TEXCOORD1.y;
    _150.y = _163 * _41_m10;
    _150 = frac(_150);
    _183 = _150.y >= 0.5f;
    float2 _193 = (_139.xy * 0.5f.xx) + _150.xx;
    _139 = float3(_193.x, _193.y, _139.z);
    float2 _201 = _139.xy * float2(443.897491455078125f, 397.29730224609375f);
    _139 = float3(_201.x, _201.y, _139.z);
    float2 _206 = frac(_139.xy);
    _139 = float3(_206.x, _206.y, _139.z);
    _209 = _139.yx + 19.1900005340576171875f.xx;
    _150.x = dot(_139.xy, _209);
    float2 _224 = _150.xx + _139.xy;
    _139 = float3(_224.x, _224.y, _139.z);
    _139.x = _139.y * _139.x;
    _139.x = frac(_139.x);
    _237 = _139.x + (-0.5f);
    _106 = (_41_m7.xyz * 0.60000002384185791015625f.xxx) + 0.4000000059604644775390625f.xxx;
    _106 = _237.xxx * _106;
    _254 = (-float2(float2(_41_m17, _41_m17))) + float2(1.0f, 2.0f);
    _237 = _254.y * _41_m8;
    _274 = (_254.x * 0.25f) + _41_m15;
    _237 *= _41_m2;
    _22 = (_106 * _237.xxx) + _22;
    _139.x = (-_41_m11) + 1.0f;
    float _301;
    if (_183)
    {
        _301 = _139.x;
    }
    else
    {
        _301 = 1.0f;
    }
    _237 = _301;
    _22 = _237.xxx * _22;
    _139.x = _41_m0.y * _41_m16;
    _139.x *= 6.283199787139892578125f;
    _139.x = sin(_139.x);
    _139.x = (_139.x * 0.5f) + 0.5f;
    _139.x = ((-_274) * _139.x) + 1.0f;
    _139 = _139.xxx * _22;
    _209 = vs_TEXCOORD0 + (-0.5f).xx;
    _163 = dot(_209, _209);
    _163 = sqrt(_163);
    _163 += (-_41_m13);
    _209.x = (-_41_m13) + _41_m14;
    _209.x = 1.0f / _209.x;
    _163 *= _209.x;
    _163 = clamp(_163, 0.0f, 1.0f);
    _209.x = (_163 * (-2.0f)) + 3.0f;
    _163 *= _163;
    _163 = ((-_209.x) * _163) + 1.0f;
    _139 = _163.xxx * _139;
    float3 _402 = _139 * _41_m6.xxx;
    _396 = float4(_402.x, _402.y, _402.z, _396.w);
    _396.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._396 = _396;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Unlit/Texture"
}