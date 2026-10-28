// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Custom/ZeroPoint_BIRP" {
Properties {

_CoreColor ("Core (void) Color", Color) = (0.02,0,0,1)

_EdgeColor ("Edge Glow Color", Color) = (1,0.25,0,1)

_RimColor ("Outer Rim Color", Color) = (1,0.55,0.05,1)

_SparkColor ("Spark Color", Color) = (1,0.85,0.3,1)

_Radius ("Void Radius", Range(0.01, 0.6)) = 0.3799999952316284

_EdgeWidth ("Edge Glow Width", Range(0.005, 0.3)) = 0.10000000149011612

_VertWobbleAmp ("Vertex Wobble Amplitude", Range(0, 0.5)) = 0.07999999821186066

_VertWobbleFreq ("Vertex Wobble Frequency", Range(1, 12)) = 5.0

_VertWobbleSpeed ("Vertex Wobble Speed", Range(0, 10)) = 2.200000047683716

_UVWobbleAmp ("UV Edge Wobble Amp", Range(0, 0.15)) = 0.029999999329447746

_UVWobbleFreq ("UV Edge Wobble Freq", Range(1, 20)) = 7.0

_UVWobbleSpeed ("UV Edge Wobble Speed", Range(0, 10)) = 3.5

_NoiseScale ("Noise Scale", Range(0.5, 8)) = 2.5

_NoiseSpeed ("Noise Scroll Speed", Range(0, 3)) = 0.30000001192092896

_NoiseStrength ("Noise Edge Warp", Range(0, 0.2)) = 0.05999999865889549

_DitherBandWidth ("Dither Band Width", Range(0, 0.4)) = 0.18000000715255737

_DitherContrast ("Dither Contrast", Range(0.5, 8)) = 3.5

_DitherScale ("Dither Pixel Scale", Range(1, 6)) = 1.5

_SparkDensity ("Spark Density", Range(0, 1)) = 0.5

_SparkSpeed ("Spark Orbit Speed", Range(0, 6)) = 1.399999976158142

_SparkSize ("Spark Size", Range(0.001, 0.06)) = 0.014000000432133675

_PulseSpeed ("Pulse Speed", Range(0, 8)) = 1.600000023841858

_PulseStrength ("Pulse Strength", Range(0, 0.15)) = 0.03999999910593033

_EmissionIntensity ("Emission Intensity", Range(1, 10)) = 4.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+10" "RenderType" = "Transparent" }
 Pass {
Cull Back
ZWrite On
 Name "DEPTH_PRIME"
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+10" "RenderType" = "Transparent" }
   ColorMask 0
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _170_m1[4];
float4x4 unity_MatrixVP;
static float4 _170_m2[4];
float _VertWobbleAmp;
float _VertWobbleFreq;
float _VertWobbleSpeed;
float _NoiseScale;
float _NoiseSpeed;
void __unity_init()
{
    _170_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _170_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _170_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _170_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _170_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _170_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _170_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _170_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _170_m0 _Time
#define _170_m3 _VertWobbleAmp
#define _170_m4 _VertWobbleFreq
#define _170_m5 _VertWobbleSpeed
#define _170_m6 _NoiseScale
#define _170_m7 _NoiseSpeed



static float4 gl_Position;
static float3 _12;
static float4 _496;

struct SPIRV_Cross_Input
{
    float4 _496 : POSITION;
    float3 _12 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float _30;
static float4 _42;
static float _59;
static bool _96;
static bool _114;
static bool _146;
static float2 _187;
static float3 _271;
static float2 _290;
static float4 _314;
static float4 _330;
static float3 _334;
static float _441;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_12, _12);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * _12;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _30 = max(abs(_9.x), abs(_9.y));
    _30 = 1.0f / _30;
    _42.x = min(abs(_9.x), abs(_9.y));
    _30 *= _42.x;
    _42.x = _30 * _30;
    _59 = (_42.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _59 = (_42.x * _59) + 0.1801410019397735595703125f;
    _59 = (_42.x * _59) + (-0.33029949665069580078125f);
    _42.x = (_42.x * _59) + 0.999866008758544921875f;
    _59 = _30 * _42.x;
    _59 = (_59 * (-2.0f)) + 1.57079637050628662109375f;
    _96 = abs(_9.x) < abs(_9.y);
    _59 = _96 ? _59 : 0.0f;
    _30 = (_30 * _42.x) + _59;
    _114 = _9.x < (-_9.x);
    _42.x = _114 ? (-3.1415927410125732421875f) : 0.0f;
    _30 += _42.x;
    _42.x = min(_9.x, _9.y);
    _114 = _42.x < (-_42.x);
    _59 = max(_9.x, _9.y);
    _146 = _59 >= (-_59);
    _114 = _146 && _114;
    float _156;
    if (_114)
    {
        _156 = -_30;
    }
    else
    {
        _156 = _30;
    }
    _30 = _156;
    _42.x = _30 * _170_m4;
    _59 = _170_m0.y * _170_m5;
    _187.x = _59 * 1.7000000476837158203125f;
    _30 = (_30 * _170_m4) + _59;
    _30 = sin(_30);
    _42.x = (_42.x * 0.5f) + _187.x;
    _42.x += 1.2999999523162841796875f;
    _42.x = sin(_42.x);
    _42.x *= _170_m3;
    _42.x *= 0.4000000059604644775390625f;
    _30 = (_30 * _170_m3) + _42.x;
    float2 _247 = _9.xy * float2(float2(_170_m6, _170_m6));
    _42 = float4(_247.x, _247.y, _42.z, _42.w);
    _187.x = _170_m0.y * _170_m7;
    float2 _264 = (_42.xy * 0.800000011920928955078125f.xx) + _187.xx;
    _42 = float4(_264.x, _264.y, _42.z, _42.w);
    _187 = floor(_42.xy);
    float2 _274 = _187 + 1.0f.xx;
    _271 = float3(_274.x, _274.y, _271.z);
    float2 _282 = _271.xy * float2(127.09999847412109375f, 311.70001220703125f);
    _271 = float3(_282.x, _282.y, _271.z);
    float2 _287 = frac(_271.xy);
    _271 = float3(_287.x, _287.y, _271.z);
    _290 = _271.xy + 19.1900005340576171875f.xx;
    _290.x = dot(_271.xy, _290);
    float2 _305 = _290.xx + _271.xy;
    _271 = float3(_305.x, _305.y, _271.z);
    _271.x = _271.y * _271.x;
    _314 = _187.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _320 = _187 * float2(127.09999847412109375f, 311.70001220703125f);
    _42 = float4(_42.x, _42.y, _320.x, _320.y);
    _42 = frac(_42);
    _314 *= float4(127.09999847412109375f, 311.70001220703125f, 127.09999847412109375f, 311.70001220703125f);
    _314 = frac(_314);
    _330 = _314 + 19.1900005340576171875f.xxxx;
    _334.x = dot(_314.zw, _330.zw);
    _290.x = dot(_314.xy, _330.xy);
    _290 = _290.xx + _314.xy;
    float2 _356 = _334.xx + _314.zw;
    _314 = float4(_356.x, _356.y, _314.z, _314.w);
    _271.y = _314.y * _314.x;
    _271.z = _290.y * _290.x;
    _271 = frac(_271);
    _271.x = (-_271.y) + _271.x;
    float2 _385 = _42.xy * _42.xy;
    _314 = float4(_385.x, _385.y, _314.z, _314.w);
    float2 _396 = ((-_42.xy) * 2.0f.xx) + 3.0f.xx;
    _42 = float4(_396.x, _396.y, _42.z, _42.w);
    float2 _403 = _42.xy * _314.xy;
    _42 = float4(_403.x, _403.y, _42.z, _42.w);
    _271.x = (_42.x * _271.x) + _271.y;
    float2 _417 = _42.zw + 19.1900005340576171875f.xx;
    _334 = float3(_417.x, _334.y, _417.y);
    _334.x = dot(_42.zw, _334.xz);
    _187 = _42.zw + _334.xx;
    _187.x = _187.y * _187.x;
    _187.x = frac(_187.x);
    _441 = (-_187.x) + _271.z;
    _42.x = (_42.x * _441) + _187.x;
    _187.x = (-_42.x) + _271.x;
    _42.x = (_42.y * _187.x) + _42.x;
    _42.x = (_42.x * 2.0f) + (-1.0f);
    _42.x *= _170_m3;
    _30 = (_42.x * 0.3499999940395355224609375f) + _30;
    float3 _499 = (_9.xyz * _30.xxx) + _496.xyz;
    _9 = float4(_499.x, _499.y, _499.z, _9.w);
    _42 = _9.yyyy * _170_m1[1];
    _42 = (_170_m1[0] * _9.xxxx) + _42;
    _9 = (_170_m1[2] * _9.zzzz) + _42;
    _9 += _170_m1[3];
    _42 = _9.yyyy * _170_m2[1];
    _42 = (_170_m2[0] * _9.xxxx) + _42;
    _42 = (_170_m2[2] * _9.zzzz) + _42;
    gl_Position = (_170_m2[3] * _9.wwww) + _42;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _496 = stage_input._496;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
Cull Back
 Name "FORWARD"
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+10" "RenderType" = "Transparent" }
 ZWrite Off
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _170_m2[4];
float4x4 unity_MatrixVP;
static float4 _170_m3[4];
float _VertWobbleAmp;
float _VertWobbleFreq;
float _VertWobbleSpeed;
float _NoiseScale;
float _NoiseSpeed;
void __unity_init()
{
    _170_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _170_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _170_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _170_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _170_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _170_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _170_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _170_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _170_m0 _Time
#define _170_m1 _ProjectionParams
#define _170_m4 _VertWobbleAmp
#define _170_m5 _VertWobbleFreq
#define _170_m6 _VertWobbleSpeed
#define _170_m7 _NoiseScale
#define _170_m8 _NoiseSpeed



static float4 gl_Position;
static float3 _12;
static float4 _491;
static float2 vs_TEXCOORD0;
static float2 _560;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _491 : POSITION;
    float3 _12 : NORMAL;
    float2 _560 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float _30;
static float4 _42;
static float _59;
static bool _96;
static bool _114;
static bool _146;
static float2 _187;
static float3 _266;
static float2 _285;
static float4 _309;
static float4 _325;
static float3 _329;
static float _436;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_12, _12);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * _12;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _30 = max(abs(_9.x), abs(_9.y));
    _30 = 1.0f / _30;
    _42.x = min(abs(_9.x), abs(_9.y));
    _30 *= _42.x;
    _42.x = _30 * _30;
    _59 = (_42.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _59 = (_42.x * _59) + 0.1801410019397735595703125f;
    _59 = (_42.x * _59) + (-0.33029949665069580078125f);
    _42.x = (_42.x * _59) + 0.999866008758544921875f;
    _59 = _30 * _42.x;
    _59 = (_59 * (-2.0f)) + 1.57079637050628662109375f;
    _96 = abs(_9.x) < abs(_9.y);
    _59 = _96 ? _59 : 0.0f;
    _30 = (_30 * _42.x) + _59;
    _114 = _9.x < (-_9.x);
    _42.x = _114 ? (-3.1415927410125732421875f) : 0.0f;
    _30 += _42.x;
    _42.x = min(_9.x, _9.y);
    _114 = _42.x < (-_42.x);
    _59 = max(_9.x, _9.y);
    _146 = _59 >= (-_59);
    _114 = _146 && _114;
    float _156;
    if (_114)
    {
        _156 = -_30;
    }
    else
    {
        _156 = _30;
    }
    _30 = _156;
    _42.x = _30 * _170_m5;
    _59 = _170_m0.y * _170_m6;
    _187.x = _59 * 1.7000000476837158203125f;
    _30 = (_30 * _170_m5) + _59;
    _30 = sin(_30);
    _42.x = (_42.x * 0.5f) + _187.x;
    _42.x += 1.2999999523162841796875f;
    _42.x = sin(_42.x);
    _42.x *= _170_m4;
    _42.x *= 0.4000000059604644775390625f;
    _30 = (_30 * _170_m4) + _42.x;
    float2 _242 = _9.xy * _170_m7.xx;
    _42 = float4(_242.x, _242.y, _42.z, _42.w);
    _187.x = _170_m0.y * _170_m8;
    float2 _259 = (_42.xy * 0.800000011920928955078125f.xx) + _187.xx;
    _42 = float4(_259.x, _259.y, _42.z, _42.w);
    _187 = floor(_42.xy);
    float2 _269 = _187 + 1.0f.xx;
    _266 = float3(_269.x, _269.y, _266.z);
    float2 _277 = _266.xy * float2(127.09999847412109375f, 311.70001220703125f);
    _266 = float3(_277.x, _277.y, _266.z);
    float2 _282 = frac(_266.xy);
    _266 = float3(_282.x, _282.y, _266.z);
    _285 = _266.xy + 19.1900005340576171875f.xx;
    _285.x = dot(_266.xy, _285);
    float2 _300 = _285.xx + _266.xy;
    _266 = float3(_300.x, _300.y, _266.z);
    _266.x = _266.y * _266.x;
    _309 = _187.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _315 = _187 * float2(127.09999847412109375f, 311.70001220703125f);
    _42 = float4(_42.x, _42.y, _315.x, _315.y);
    _42 = frac(_42);
    _309 *= float4(127.09999847412109375f, 311.70001220703125f, 127.09999847412109375f, 311.70001220703125f);
    _309 = frac(_309);
    _325 = _309 + 19.1900005340576171875f.xxxx;
    _329.x = dot(_309.zw, _325.zw);
    _285.x = dot(_309.xy, _325.xy);
    _285 = _285.xx + _309.xy;
    float2 _351 = _329.xx + _309.zw;
    _309 = float4(_351.x, _351.y, _309.z, _309.w);
    _266.y = _309.y * _309.x;
    _266.z = _285.y * _285.x;
    _266 = frac(_266);
    _266.x = (-_266.y) + _266.x;
    float2 _380 = _42.xy * _42.xy;
    _309 = float4(_380.x, _380.y, _309.z, _309.w);
    float2 _391 = ((-_42.xy) * 2.0f.xx) + 3.0f.xx;
    _42 = float4(_391.x, _391.y, _42.z, _42.w);
    float2 _398 = _42.xy * _309.xy;
    _42 = float4(_398.x, _398.y, _42.z, _42.w);
    _266.x = (_42.x * _266.x) + _266.y;
    float2 _412 = _42.zw + 19.1900005340576171875f.xx;
    _329 = float3(_412.x, _329.y, _412.y);
    _329.x = dot(_42.zw, _329.xz);
    _187 = _42.zw + _329.xx;
    _187.x = _187.y * _187.x;
    _187.x = frac(_187.x);
    _436 = (-_187.x) + _266.z;
    _42.x = (_42.x * _436) + _187.x;
    _187.x = (-_42.x) + _266.x;
    _42.x = (_42.y * _187.x) + _42.x;
    _42.x = (_42.x * 2.0f) + (-1.0f);
    _42.x *= _170_m4;
    _30 = (_42.x * 0.3499999940395355224609375f) + _30;
    float3 _494 = (_9.xyz * _30.xxx) + _491.xyz;
    _9 = float4(_494.x, _494.y, _494.z, _9.w);
    _42 = _9.yyyy * _170_m2[1];
    _42 = (_170_m2[0] * _9.xxxx) + _42;
    _9 = (_170_m2[2] * _9.zzzz) + _42;
    _9 += _170_m2[3];
    _42 = _9.yyyy * _170_m3[1];
    _42 = (_170_m3[0] * _9.xxxx) + _42;
    _42 = (_170_m3[2] * _9.zzzz) + _42;
    _9 = (_170_m3[3] * _9.wwww) + _42;
    gl_Position = _9;
    vs_TEXCOORD0 = _560;
    _9.y *= _170_m1.x;
    float3 _571 = _9.xwy * 0.5f.xxx;
    _42 = float4(_571.x, _42.y, _571.y, _571.z);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _9.zw.x, _9.zw.y);
    float2 _583 = _42.zz + _42.xw;
    vs_TEXCOORD1 = float4(_583.x, _583.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _491 = stage_input._491;
    _560 = stage_input._560;
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
float4 _ScreenParams;
float4 _CoreColor;
float4 _EdgeColor;
float4 _RimColor;
float4 _SparkColor;
float _Radius;
float _EdgeWidth;
float _UVWobbleAmp;
float _UVWobbleFreq;
float _UVWobbleSpeed;
float _NoiseScale;
float _NoiseSpeed;
float _NoiseStrength;
float _DitherBandWidth;
float _DitherContrast;
float _DitherScale;
float _SparkDensity;
float _SparkSpeed;
float _SparkSize;
float _PulseSpeed;
float _PulseStrength;
float _EmissionIntensity;
#define _211_m0 _Time
#define _211_m1 _ScreenParams
#define _211_m2 _CoreColor
#define _211_m3 _EdgeColor
#define _211_m4 _RimColor
#define _211_m5 _SparkColor
#define _211_m6 _Radius
#define _211_m7 _EdgeWidth
#define _211_m8 _UVWobbleAmp
#define _211_m9 _UVWobbleFreq
#define _211_m10 _UVWobbleSpeed
#define _211_m11 _NoiseScale
#define _211_m12 _NoiseSpeed
#define _211_m13 _NoiseStrength
#define _211_m14 _DitherBandWidth
#define _211_m15 _DitherContrast
#define _211_m16 _DitherScale
#define _211_m17 _SparkDensity
#define _211_m18 _SparkSpeed
#define _211_m19 _SparkSize
#define _211_m20 _PulseSpeed
#define _211_m21 _PulseStrength
#define _211_m22 _EmissionIntensity



static float2 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 _3841;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _3841 : SV_Target0;
};

static float4 _12[64];
static float _208;
static float3 _226;
static float4 _243;
static float2 _264;
static float4 _279;
static float2 _286;
static float4 _298;
static float _305;
static float4 _335;
static float _345;
static float _434;
static float _602;
static bool _712;
static bool2 _731;
static bool _772;
static float _781;
static float4 _1047;
static float2 _2987;
static float2 _3124;
static int2 _3511;
static int _3516;
static float _3544;
static bool _3568;

void frag_inner()
{
    _12[0].x = 0.0f;
    _12[1].x = 32.0f;
    _12[2].x = 8.0f;
    _12[3].x = 40.0f;
    _12[4].x = 2.0f;
    _12[5].x = 34.0f;
    _12[6].x = 10.0f;
    _12[7].x = 42.0f;
    _12[8].x = 48.0f;
    _12[9].x = 16.0f;
    _12[10].x = 56.0f;
    _12[11].x = 24.0f;
    _12[12].x = 50.0f;
    _12[13].x = 18.0f;
    _12[14].x = 58.0f;
    _12[15].x = 26.0f;
    _12[16].x = 12.0f;
    _12[17].x = 44.0f;
    _12[18].x = 4.0f;
    _12[19].x = 36.0f;
    _12[20].x = 14.0f;
    _12[21].x = 46.0f;
    _12[22].x = 6.0f;
    _12[23].x = 38.0f;
    _12[24].x = 60.0f;
    _12[25].x = 28.0f;
    _12[26].x = 52.0f;
    _12[27].x = 20.0f;
    _12[28].x = 62.0f;
    _12[29].x = 30.0f;
    _12[30].x = 54.0f;
    _12[31].x = 22.0f;
    _12[32].x = 3.0f;
    _12[33].x = 35.0f;
    _12[34].x = 11.0f;
    _12[35].x = 43.0f;
    _12[36].x = 1.0f;
    _12[37].x = 33.0f;
    _12[38].x = 9.0f;
    _12[39].x = 41.0f;
    _12[40].x = 51.0f;
    _12[41].x = 19.0f;
    _12[42].x = 59.0f;
    _12[43].x = 27.0f;
    _12[44].x = 49.0f;
    _12[45].x = 17.0f;
    _12[46].x = 57.0f;
    _12[47].x = 25.0f;
    _12[48].x = 15.0f;
    _12[49].x = 47.0f;
    _12[50].x = 7.0f;
    _12[51].x = 39.0f;
    _12[52].x = 13.0f;
    _12[53].x = 45.0f;
    _12[54].x = 5.0f;
    _12[55].x = 37.0f;
    _12[56].x = 63.0f;
    _12[57].x = 31.0f;
    _12[58].x = 55.0f;
    _12[59].x = 23.0f;
    _12[60].x = 61.0f;
    _12[61].x = 29.0f;
    _12[62].x = 53.0f;
    _12[63].x = 21.0f;
    _208 = _211_m0.y * 1.60000002384185791015625f;
    _208 = sin(_208);
    _208 = (_208 * 0.5f) + 0.5f;
    _226.x = _211_m0.y * _211_m12;
    float2 _239 = _226.xx * float2(0.37000000476837158203125f, 0.20999999344348907470703125f);
    _226 = float3(_239.x, _239.y, _226.z);
    float2 _249 = vs_TEXCOORD0 + (-0.5f).xx;
    _243 = float4(_249.x, _249.y, _243.z, _243.w);
    float2 _260 = (_243.xy * _211_m11.xx) + _226.xy;
    _226 = float3(_260.x, _260.y, _226.z);
    _264 = _226.xy * 3.099999904632568359375f.xx;
    float2 _276 = (_226.xy * 3.099999904632568359375f.xx) + float2(7.30000019073486328125f, 2.900000095367431640625f);
    _226 = float3(_276.x, _276.y, _226.z);
    float2 _281 = floor(_264);
    _279 = float4(_281.x, _281.y, _279.z, _279.w);
    _264 = frac(_264);
    _286 = _279.xy + 1.0f.xx;
    _286 *= float2(127.09999847412109375f, 311.70001220703125f);
    _286 = frac(_286);
    float2 _302 = _286 + 19.1900005340576171875f.xx;
    _298 = float4(_302.x, _302.y, _298.z, _298.w);
    _305 = dot(_286, _298.xy);
    _286 = _305.xx + _286;
    _305 = _286.y * _286.x;
    _305 = frac(_305);
    _298 = _279.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    float2 _327 = _279.xy * float2(127.09999847412109375f, 311.70001220703125f);
    _279 = float4(_327.x, _327.y, _279.z, _279.w);
    _298 *= float4(127.09999847412109375f, 311.70001220703125f, 127.09999847412109375f, 311.70001220703125f);
    _298 = frac(_298);
    _335 = _298 + 19.1900005340576171875f.xxxx;
    _286.x = dot(_298.zw, _335.zw);
    _345 = dot(_298.xy, _335.xy);
    float2 _355 = _345.xx + _298.xy;
    _298 = float4(_355.x, _355.y, _298.z, _298.w);
    _286 = _286.xx + _298.zw;
    _279.z = _286.y * _286.x;
    _279.w = _298.y * _298.x;
    _279 = frac(_279);
    _305 += (-_279.z);
    float2 _386 = _264 * _264;
    _298 = float4(_386.x, _386.y, _298.z, _298.w);
    _264 = ((-_264) * 2.0f.xx) + 3.0f.xx;
    _264 *= _298.xy;
    _305 = (_264.x * _305) + _279.z;
    float2 _408 = _279.xy + 19.1900005340576171875f.xx;
    _298 = float4(_408.x, _408.y, _298.z, _298.w);
    _286.x = dot(_279.xy, _298.xy);
    float2 _421 = _286.xx + _279.xy;
    _279 = float4(_421.x, _421.y, _279.z, _279.w);
    _279.x = _279.y * _279.x;
    _279.x = frac(_279.x);
    _434 = (-_279.x) + _279.w;
    _264.x = (_264.x * _434) + _279.x;
    _305 += (-_264.x);
    _305 = (_264.y * _305) + _264.x;
    _279.x = (_305 * 2.0f) + (-1.0f);
    _264 = floor(_226.xy);
    _286 = _264 + 1.0f.xx;
    _286 *= float2(127.09999847412109375f, 311.70001220703125f);
    _286 = frac(_286);
    float2 _476 = _286 + 19.1900005340576171875f.xx;
    _298 = float4(_476.x, _476.y, _298.z, _298.w);
    _305 = dot(_286, _298.xy);
    _286 = _305.xx + _286;
    _226.z = _286.y * _286.x;
    _226 = frac(_226);
    _298 = _264.xyxy + float4(1.0f, 0.0f, 0.0f, 1.0f);
    _264 *= float2(127.09999847412109375f, 311.70001220703125f);
    _264 = frac(_264);
    _298 *= float4(127.09999847412109375f, 311.70001220703125f, 127.09999847412109375f, 311.70001220703125f);
    _298 = frac(_298);
    _335 = _298 + 19.1900005340576171875f.xxxx;
    _286.x = dot(_298.zw, _335.zw);
    _345 = dot(_298.xy, _335.xy);
    float2 _523 = _345.xx + _298.xy;
    _298 = float4(_523.x, _523.y, _298.z, _298.w);
    _286 = _286.xx + _298.zw;
    _286.x = _286.y * _286.x;
    _286.y = _298.y * _298.x;
    _286 = frac(_286);
    _305 = _226.z + (-_286.x);
    float2 _555 = _226.xy * _226.xy;
    _298 = float4(_555.x, _555.y, _298.z, _298.w);
    float2 _562 = ((-_226.xy) * 2.0f.xx) + 3.0f.xx;
    _226 = float3(_562.x, _562.y, _226.z);
    float2 _569 = _226.xy * _298.xy;
    _226 = float3(_569.x, _569.y, _226.z);
    _305 = (_226.x * _305) + _286.x;
    float2 _580 = _264 + 19.1900005340576171875f.xx;
    _298 = float4(_580.x, _580.y, _298.z, _298.w);
    _286.x = dot(_264, _298.xy);
    _264 += _286.xx;
    _264.x = _264.y * _264.x;
    _264.x = frac(_264.x);
    _602 = (-_264.x) + _286.y;
    _226.x = (_226.x * _602) + _264.x;
    _305 = (-_226.x) + _305;
    _226.x = (_226.y * _305) + _226.x;
    _279.y = (_226.x * 2.0f) + (-1.0f);
    float2 _648 = (_279.xy * float2(float2(_211_m13, _211_m13))) + _243.xy;
    _226 = float3(_648.x, _648.y, _226.z);
    _305 = max(abs(_226.x), abs(_226.y));
    _305 = 1.0f / _305;
    _264.x = min(abs(_226.x), abs(_226.y));
    _305 *= _264.x;
    _264.x = _305 * _305;
    _602 = (_264.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _602 = (_264.x * _602) + 0.1801410019397735595703125f;
    _602 = (_264.x * _602) + (-0.33029949665069580078125f);
    _264.x = (_264.x * _602) + 0.999866008758544921875f;
    _602 = _305 * _264.x;
    _602 = (_602 * (-2.0f)) + 1.57079637050628662109375f;
    _712 = abs(_226.x) < abs(_226.y);
    _602 = _712 ? _602 : 0.0f;
    _305 = (_305 * _264.x) + _602;
    _731.x = _226.x < (-_226.x);
    _264.x = _731.x ? (-3.1415927410125732421875f) : 0.0f;
    _305 += _264.x;
    _264.x = min(_226.x, _226.y);
    _731.x = _264.x < (-_264.x);
    _602 = max(_226.x, _226.y);
    _226.x = dot(_226.xy, _226.xy);
    _772 = _602 >= (-_602);
    _772 = _772 && _731.x;
    float _784;
    if (_772)
    {
        _784 = -_305;
    }
    else
    {
        _784 = _305;
    }
    _781 = _784;
    _305 = _211_m0.y * _211_m10;
    _781 = (_781 * _211_m9) + _305;
    _781 = sin(_781);
    _781 = (_781 * _211_m8) + _211_m6;
    _305 = _211_m0.y * _211_m20;
    _305 = sin(_305);
    _781 = (_305 * _211_m21) + _781;
    float3 _843 = (float3(float3(_211_m7, _211_m7, _211_m7)) * float3(-0.60000002384185791015625f, -0.089062504470348358154296875f, -0.217968761920928955078125f)) + _781.xxx;
    _279 = float4(_843.x, _843.y, _843.z, _279.w);
    _305 = _211_m0.y * _211_m18;
    _298 = (_305.xxxx * float4(-0.4000000059604644775390625f, 0.4659179747104644775390625f, 0.785253942012786865234375f, 0.5652344226837158203125f)) + float4(3.779725551605224609375f, 1.9021346569061279296875f, 2.0125811100006103515625f, 2.4052798748016357421875f);
    _335.x = cos(_298.x);
    _298.x = sin(_298.x);
    _335.y = _298.x;
    _264 = ((-_335.xy) * _279.xx) + _243.xy;
    _264.x = dot(_264, _264);
    _264.x = sqrt(_264.x);
    _602 = 1.0f / _211_m19;
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _208 *= _264.x;
    _279.x = sin(_298.y);
    _298.x = cos(_298.y);
    _298.y = _279.x;
    float2 _947 = ((-_298.xy) * _279.yy) + _243.xy;
    _279 = float4(_947.x, _947.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    float3 _1001 = (_211_m0.yyy * float3(1.86367189884185791015625f, 3.1410157680511474609375f, 2.26093769073486328125f)) + float3(1.83000004291534423828125f, 3.6600000858306884765625f, 5.490000247955322265625f);
    _279 = float4(_1001.x, _1001.y, _279.z, _1001.z);
    float3 _1006 = sin(_279.xyw);
    _279 = float4(_1006.x, _1006.y, _279.z, _1006.z);
    float3 _1013 = (_279.xyw * 0.5f.xxx) + 0.5f.xxx;
    _279 = float4(_1013.x, _1013.y, _279.z, _1013.z);
    _264.x *= _279.x;
    _264.x *= _211_m17;
    _208 = (_208 * _211_m17) + _264.x;
    _279.x = sin(_298.z);
    _298.x = cos(_298.z);
    _335.x = sin(_298.w);
    _1047.x = cos(_298.w);
    _298.y = _279.x;
    float2 _1063 = ((-_298.xy) * _279.zz) + _243.xy;
    _279 = float4(_1063.x, _279.y, _1063.y, _279.w);
    _264.x = dot(_279.xz, _279.xz);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _279.y * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _298 = (float4(float4(_211_m7, _211_m7, _211_m7, _211_m7)) * float4(-0.0328125022351741790771484375f, 0.464062511920928955078125f, -0.1968750059604644775390625f, 0.33984375f)) + _781.xxxx;
    _1047.y = _335.x;
    float2 _1151 = ((-_1047.xy) * _298.xx) + _243.xy;
    _279 = float4(_1151.x, _1151.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _279.w * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279 = (_305.xxxx * float4(-0.97304689884185791015625f, 0.6824219226837158203125f, -0.71054685115814208984375f, 0.637890636920928955078125f)) + float4(6.111374378204345703125f, 5.7186756134033203125f, 5.951840877532958984375f, 5.424151897430419921875f);
    _335.x = cos(_279.x);
    _279.x = sin(_279.x);
    _335.y = _279.x;
    float2 _1238 = ((-_335.xy) * _298.yy) + _243.xy;
    _335 = float4(_1238.x, _1238.y, _335.z, _335.w);
    _264.x = dot(_335.xy, _335.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _335 = (_211_m0.yyyy * float4(3.892187595367431640625f, 2.72968769073486328125f, 2.842187404632568359375f, 2.5515625476837158203125f)) + float4(7.320000171661376953125f, 9.15000057220458984375f, 10.98000049591064453125f, 12.81000041961669921875f);
    _335 = sin(_335);
    _335 = (_335 * 0.5f.xxxx) + 0.5f.xxxx;
    _264.x *= _335.x;
    _208 = (_264.x * _211_m17) + _208;
    _1047.x = cos(_279.y);
    _279.x = sin(_279.y);
    _1047.y = _279.x;
    float2 _1332 = ((-_1047.xy) * _298.yy) + _243.xy;
    _279 = float4(_1332.x, _1332.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.y * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _298.x = cos(_279.z);
    _279.x = sin(_279.z);
    _335.x = sin(_279.w);
    _1047.x = cos(_279.w);
    _298.y = _279.x;
    float2 _1413 = ((-_298.xy) * _298.zz) + _243.xy;
    _279 = float4(_1413.x, _1413.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.z * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _1047.y = _335.x;
    float2 _1478 = ((-_1047.xy) * _298.ww) + _243.xy;
    _279 = float4(_1478.x, _1478.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.w * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279 = (float4(float4(_211_m7, _211_m7, _211_m7, _211_m7)) * float4(0.30703127384185791015625f, -0.56630861759185791015625f, -0.525000035762786865234375f, -0.3984375298023223876953125f)) + _781.xxxx;
    _298 = (_305.xxxx * float4(0.4527343809604644775390625f, -0.90390622615814208984375f, -0.6953125f, 0.8359375f)) + float4(2.84706592559814453125f, 2.994328022003173828125f, 6.246364593505859375f, 0.018407754600048065185546875f);
    _335.x = cos(_298.x);
    _298.x = sin(_298.x);
    _335.y = _298.x;
    float2 _1588 = ((-_335.xy) * _279.xx) + _243.xy;
    _335 = float4(_1588.x, _1588.y, _335.z, _335.w);
    _264.x = dot(_335.xy, _335.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _335 = (_211_m0.yyyy * float4(1.81093752384185791015625f, 3.615624904632568359375f, 2.78125f, 3.34375f)) + float4(14.64000034332275390625f, 16.470001220703125f, 18.3000011444091796875f, 20.130001068115234375f);
    _335 = sin(_335);
    _335 = (_335 * 0.5f.xxxx) + 0.5f.xxxx;
    _264.x *= _335.x;
    _208 = (_264.x * _211_m17) + _208;
    _279.x = sin(_298.y);
    _298.x = cos(_298.y);
    _298.y = _279.x;
    float2 _1681 = ((-_298.xy) * _279.yy) + _243.xy;
    _279 = float4(_1681.x, _1681.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.y * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279.x = sin(_298.z);
    _298.x = cos(_298.z);
    _335.x = sin(_298.w);
    _1047.x = cos(_298.w);
    _298.y = _279.x;
    float2 _1762 = ((-_298.xy) * _279.zz) + _243.xy;
    _279 = float4(_1762.x, _1762.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.z * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _1047.y = _335.x;
    float2 _1827 = ((-_1047.xy) * _279.ww) + _243.xy;
    _279 = float4(_1827.x, _1827.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.w * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279 = (float4(float4(_211_m7, _211_m7, _211_m7, _211_m7)) * float4(0.515625f, 0.27187502384185791015625f, -0.4921875298023223876953125f, 0.014062500558793544769287109375f)) + _781.xxxx;
    _298 = (_305.xxxx * float4(-0.93906247615814208984375f, 0.622656285762786865234375f, 0.46328127384185791015625f, -0.842968761920928955078125f)) + float4(3.9883468151092529296875f, 2.84706592559814453125f, 4.859647274017333984375f, 0.601319968700408935546875f);
    _335.x = cos(_298.x);
    _298.x = sin(_298.x);
    _335.y = _298.x;
    float2 _1936 = ((-_335.xy) * _279.xx) + _243.xy;
    _335 = float4(_1936.x, _1936.y, _335.z, _335.w);
    _264.x = dot(_335.xy, _335.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _335 = (_211_m0.yyyy * float4(3.756249904632568359375f, 2.4906251430511474609375f, 1.853125095367431640625f, 3.3718750476837158203125f)) + float4(21.9600009918212890625f, 23.79000091552734375f, 25.6200008392333984375f, 27.450000762939453125f);
    _335 = sin(_335);
    _335 = (_335 * 0.5f.xxxx) + 0.5f.xxxx;
    _264.x *= _335.x;
    _208 = (_264.x * _211_m17) + _208;
    _279.x = sin(_298.y);
    _298.x = cos(_298.y);
    _298.y = _279.x;
    float2 _2029 = ((-_298.xy) * _279.yy) + _243.xy;
    _279 = float4(_2029.x, _2029.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.y * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279.x = sin(_298.z);
    _298.x = cos(_298.z);
    _335.x = sin(_298.w);
    _1047.x = cos(_298.w);
    _298.y = _279.x;
    float2 _2110 = ((-_298.xy) * _279.zz) + _243.xy;
    _279 = float4(_2110.x, _2110.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.z * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _1047.y = _335.x;
    float2 _2175 = ((-_1047.xy) * _279.ww) + _243.xy;
    _279 = float4(_2175.x, _2175.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.w * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279 = (float4(float4(_211_m7, _211_m7, _211_m7, _211_m7)) * float4(-0.03984375298023223876953125f, -0.3199218809604644775390625f, -0.39199221134185791015625f, -0.22734375298023223876953125f)) + _781.xxxx;
    _298 = (_305.xxxx * float4(0.81484377384185791015625f, -0.6765625476837158203125f, -0.4585937559604644775390625f, -0.500781238079071044921875f)) + float4(3.6263277530670166015625f, 1.06764972209930419921875f, 4.2215118408203125f, 4.638754367828369140625f);
    _335.x = cos(_298.x);
    _298.x = sin(_298.x);
    _335.y = _298.x;
    float2 _2285 = ((-_335.xy) * _279.xx) + _243.xy;
    _335 = float4(_2285.x, _2285.y, _335.z, _335.w);
    _264.x = dot(_335.xy, _335.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _335 = (_211_m0.yyyy * float4(3.259375095367431640625f, 2.70625019073486328125f, 1.83437502384185791015625f, 2.0031249523162841796875f)) + float4(29.2800006866455078125f, 31.1100006103515625f, 32.94000244140625f, 34.770000457763671875f);
    _335 = sin(_335);
    _335 = (_335 * 0.5f.xxxx) + 0.5f.xxxx;
    _264.x *= _335.x;
    _208 = (_264.x * _211_m17) + _208;
    _279.x = sin(_298.y);
    _298.x = cos(_298.y);
    _298.y = _279.x;
    float2 _2378 = ((-_298.xy) * _279.yy) + _243.xy;
    _279 = float4(_2378.x, _2378.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.y * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279.x = sin(_298.z);
    _298.x = cos(_298.z);
    _335.x = sin(_298.w);
    _1047.x = cos(_298.w);
    _298.y = _279.x;
    float2 _2459 = ((-_298.xy) * _279.zz) + _243.xy;
    _279 = float4(_2459.x, _2459.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.z * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _1047.y = _335.x;
    float2 _2524 = ((-_1047.xy) * _279.ww) + _243.xy;
    _279 = float4(_2524.x, _2524.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.w * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279 = (float4(float4(_211_m7, _211_m7, _211_m7, _211_m7)) * float4(-0.276562511920928955078125f, -0.24843750894069671630859375f, -0.16875000298023223876953125f, -0.112500004470348358154296875f)) + _781.xxxx;
    _298 = (_305.xxxx * float4(0.819531261920928955078125f, -0.4046874940395355224609375f, -0.585156261920928955078125f, 0.89453125f)) + float4(1.4971640110015869140625f, 5.51005458831787109375f, 0.56450450420379638671875f, 0.61359179019927978515625f);
    _335.x = cos(_298.x);
    _298.x = sin(_298.x);
    _335.y = _298.x;
    float2 _2634 = ((-_335.xy) * _279.xx) + _243.xy;
    _335 = float4(_2634.x, _2634.y, _335.z, _335.w);
    _264.x = dot(_335.xy, _335.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _335 = (_211_m0.yyyy * float4(3.2781250476837158203125f, 1.61874997615814208984375f, 2.3406250476837158203125f, 3.578125f)) + float4(36.600002288818359375f, 38.43000030517578125f, 40.26000213623046875f, 42.090000152587890625f);
    _335 = sin(_335);
    _335 = (_335 * 0.5f.xxxx) + 0.5f.xxxx;
    _264.x *= _335.x;
    _208 = (_264.x * _211_m17) + _208;
    _279.x = sin(_298.y);
    _298.x = cos(_298.y);
    _298.y = _279.x;
    float2 _2727 = ((-_298.xy) * _279.yy) + _243.xy;
    _279 = float4(_2727.x, _2727.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.y * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279.x = sin(_298.z);
    _298.x = cos(_298.z);
    _335.x = sin(_298.w);
    _1047.x = cos(_298.w);
    _298.y = _279.x;
    float2 _2808 = ((-_298.xy) * _279.zz) + _243.xy;
    _279 = float4(_2808.x, _2808.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.z * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _1047.y = _335.x;
    float2 _2873 = ((-_1047.xy) * _279.ww) + _243.xy;
    _279 = float4(_2873.x, _2873.y, _279.z, _279.w);
    _264.x = dot(_279.xy, _279.xy);
    _264.x = sqrt(_264.x);
    _264.x = _602 * _264.x;
    _264.x = clamp(_264.x, 0.0f, 1.0f);
    _279.x = (_264.x * (-2.0f)) + 3.0f;
    _264.x *= _264.x;
    _264.x = ((-_279.x) * _264.x) + 1.0f;
    _264.x = _335.w * _264.x;
    _208 = (_264.x * _211_m17) + _208;
    _279 = (float4(float4(_211_m7, _211_m7, _211_m7, _211_m7)) * float4(0.43593752384185791015625f, 0.22500000894069671630859375f, 0.0023437500931322574615478515625f, -0.595898449420928955078125f)) + _781.xxxx;
    _298 = (_305.xxxx * float4(0.94140625f, -0.45156252384185791015625f, -0.514843761920928955078125f, -0.625f)) + float4(4.810559749603271484375f, 0.68722283840179443359375f, 2.6875321865081787109375f, 4.601938724517822265625f);
    float2 _2973 = (_305.xx * float2(-0.517187535762786865234375f, 0.68359375f)) + float2(3.503609180450439453125f, 5.105083942413330078125f);
    _335 = float4(_2973.x, _2973.y, _335.z, _335.w);
    _1047.x = cos(_298.x);
    _298.x = sin(_298.x);
    _1047.y = _298.x;
    _2987 = ((-_1047.xy) * _279.xx) + _243.xy;
    _226.z = dot(_2987, _2987);
    float2 _3003 = sqrt(_226.xz);
    _226 = float3(_3003.x, _226.y, _3003.y);
    _305 = _602 * _226.z;
    _305 = clamp(_305, 0.0f, 1.0f);
    _264.x = (_305 * (-2.0f)) + 3.0f;
    _305 *= _305;
    _305 = ((-_264.x) * _305) + 1.0f;
    _1047 = (_211_m0.yyyy * float4(3.765625f, 1.806250095367431640625f, 2.0593750476837158203125f, 2.5f)) + float4(43.920001983642578125f, 45.75f, 47.5800018310546875f, 49.409999847412109375f);
    _1047 = sin(_1047);
    _1047 = (_1047 * 0.5f.xxxx) + 0.5f.xxxx;
    _305 *= _1047.x;
    _208 = (_305 * _211_m17) + _208;
    _279.x = sin(_298.y);
    _298.x = cos(_298.y);
    _298.y = _279.x;
    float2 _3074 = ((-_298.xy) * _279.yy) + _243.xy;
    _279 = float4(_3074.x, _3074.y, _279.z, _279.w);
    _305 = dot(_279.xy, _279.xy);
    _305 = sqrt(_305);
    _305 = _602 * _305;
    _305 = clamp(_305, 0.0f, 1.0f);
    _264.x = (_305 * (-2.0f)) + 3.0f;
    _305 *= _305;
    _305 = ((-_264.x) * _305) + 1.0f;
    _305 = _1047.y * _305;
    _208 = (_305 * _211_m17) + _208;
    _279.x = sin(_298.z);
    _298.x = cos(_298.z);
    _1047.x = sin(_298.w);
    _3124.x = cos(_298.w);
    _298.y = _279.x;
    float2 _3140 = ((-_298.xy) * _279.zz) + _243.xy;
    _279 = float4(_3140.x, _3140.y, _279.z, _279.w);
    _305 = dot(_279.xy, _279.xy);
    _305 = sqrt(_305);
    _305 = _602 * _305;
    _305 = clamp(_305, 0.0f, 1.0f);
    _264.x = (_305 * (-2.0f)) + 3.0f;
    _305 *= _305;
    _305 = ((-_264.x) * _305) + 1.0f;
    _305 = _1047.z * _305;
    _208 = (_305 * _211_m17) + _208;
    _3124.y = _1047.x;
    float2 _3188 = ((-_3124) * _279.ww) + _243.xy;
    _279 = float4(_3188.x, _3188.y, _279.z, _279.w);
    _305 = dot(_279.xy, _279.xy);
    _305 = sqrt(_305);
    _305 = _602 * _305;
    _305 = clamp(_305, 0.0f, 1.0f);
    _264.x = (_305 * (-2.0f)) + 3.0f;
    _305 *= _305;
    _305 = ((-_264.x) * _305) + 1.0f;
    _305 = _1047.w * _305;
    _208 = (_305 * _211_m17) + _208;
    _279 = (float4(float4(_211_m7, _211_m7, _211_m7, _211_m7)) * float4(0.0445312522351741790771484375f, 0.5789062976837158203125f, 2.7999999523162841796875f, 3.0f)) + _781.xxxx;
    _781 = (-_781) + _226.x;
    _226.x += (-_279.z);
    _298.x = sin(_335.x);
    _1047.x = cos(_335.x);
    _3124.x = cos(_335.y);
    _335.x = sin(_335.y);
    _1047.y = _298.x;
    float2 _3287 = ((-_1047.xy) * _279.xx) + _243.xy;
    _298 = float4(_3287.x, _3287.y, _298.z, _298.w);
    _305 = dot(_298.xy, _298.xy);
    _305 = sqrt(_305);
    _305 = _602 * _305;
    _305 = clamp(_305, 0.0f, 1.0f);
    _264.x = (_305 * (-2.0f)) + 3.0f;
    _305 *= _305;
    _305 = ((-_264.x) * _305) + 1.0f;
    float2 _3325 = (_211_m0.yy * float2(2.0687501430511474609375f, 2.734375f)) + float2(51.240001678466796875f, 53.06999969482421875f);
    _298 = float4(_3325.x, _3325.y, _298.z, _298.w);
    float2 _3330 = sin(_298.xy);
    _298 = float4(_3330.x, _3330.y, _298.z, _298.w);
    float2 _3337 = (_298.xy * 0.5f.xx) + 0.5f.xx;
    _298 = float4(_3337.x, _3337.y, _298.z, _298.w);
    _305 *= _298.x;
    _208 = (_305 * _211_m17) + _208;
    _3124.y = _335.x;
    float2 _3360 = ((-_3124) * _279.yy) + _243.xy;
    _243 = float4(_3360.x, _3360.y, _243.z, _243.w);
    _305 = (-_279.z) + _279.w;
    _305 = 1.0f / _305;
    _226.x = _305 * _226.x;
    _226.x = clamp(_226.x, 0.0f, 1.0f);
    _305 = dot(_243.xy, _243.xy);
    _305 = sqrt(_305);
    _305 = _602 * _305;
    _305 = clamp(_305, 0.0f, 1.0f);
    _243.x = (_305 * (-2.0f)) + 3.0f;
    _305 *= _305;
    _305 = ((-_243.x) * _305) + 1.0f;
    _305 = _298.y * _305;
    _208 = (_305 * _211_m17) + _208;
    _208 = clamp(_208, 0.0f, 1.0f);
    float2 _3423 = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    _243 = float4(_3423.x, _3423.y, _243.z, _243.w);
    float2 _3431 = _243.xy * _211_m1.xy;
    _243 = float4(_3431.x, _3431.y, _243.z, _243.w);
    float2 _3444 = _243.xy / float2(float2(_211_m16, _211_m16));
    _243 = float4(_3444.x, _3444.y, _243.z, _243.w);
    float2 _3449 = floor(_243.xy);
    _243 = float4(_3449.x, _3449.y, _243.z, _243.w);
    float2 _3456 = _243.xy * 0.125f.xx;
    _243 = float4(_3456.x, _3456.y, _243.z, _243.w);
    float4 _3463 = -_243.xyxy;
    _731 = bool4(_243.xyxy.x >= _3463.x, _243.xyxy.y >= _3463.y, _243.xyxy.z >= _3463.z, _243.xyxy.w >= _3463.w).xy;
    float2 _3470 = frac(abs(_243.xy));
    _243 = float4(_3470.x, _3470.y, _243.z, _243.w);
    float4 _3474 = _243;
    float _3478;
    if (_731.x)
    {
        _3478 = _243.x;
    }
    else
    {
        _3478 = -_243.x;
    }
    _3474.x = _3478;
    float _3491;
    if (_731.y)
    {
        _3491 = _243.y;
    }
    else
    {
        _3491 = -_243.y;
    }
    _3474.y = _3491;
    _243 = _3474;
    float2 _3506 = _243.xy * 8.0f.xx;
    _243 = float4(_3506.x, _3506.y, _243.z, _243.w);
    _3511 = int2(_243.xy);
    _3516 = _3511.y << 3;
    _3516 += _3511.x;
    _305 = _12[_3516].x;
    _305 *= 0.015625f;
    _243.x = max(_211_m14, 0.001000000047497451305389404296875f);
    _243.x = _781 / _243.x;
    _243.x = clamp(_243.x, 0.0f, 1.0f);
    _3544 = (-_243.x) + 1.0f;
    _243.x = ((-_243.x) * 1.5f) + 1.0f;
    _243.x = max(_243.x, 0.0f);
    _3544 = log2(_3544);
    _3544 *= _211_m15;
    _3544 = exp2(_3544);
    _3568 = _3544 >= _305;
    _305 = float(_3568);
    _3544 = _781 + 0.004999999888241291046142578125f;
    _3544 *= 76.92307281494140625f;
    _3544 = clamp(_3544, 0.0f, 1.0f);
    _264.x = (_3544 * (-2.0f)) + 3.0f;
    _3544 *= _3544;
    _3544 = ((-_264.x) * _3544) + 1.0f;
    _264.x = (-_3544) + 1.0f;
    _305 *= _264.x;
    _305 = _243.x * _305;
    _243.x = (_305 * 0.949999988079071044921875f) + _3544;
    float3 _3618 = _305.xxx * _211_m3.xyz;
    _279 = float4(_3618.x, _3618.y, _3618.z, _279.w);
    float3 _3634 = _279.xyz * float3(float3(_211_m22, _211_m22, _211_m22));
    _279 = float4(_3634.x, _3634.y, _3634.z, _279.w);
    float3 _3645 = (_211_m2.xyz * _3544.xxx) + _279.xyz;
    _279 = float4(_3645.x, _3645.y, _3645.z, _279.w);
    _305 = _781 + (-_211_m7);
    _781 = ((-_211_m7) * 2.5f) + _781;
    _3544 = 1.0f / (-_211_m7);
    _305 *= _3544;
    _305 = clamp(_305, 0.0f, 1.0f);
    _3544 = (_305 * (-2.0f)) + 3.0f;
    _305 *= _305;
    _305 *= _3544;
    _305 = _264.x * _305;
    _243.x = (_305 * 0.64999997615814208984375f) + _243.x;
    float3 _3693 = _305.xxx * _211_m3.xyz;
    _298 = float4(_3693.x, _3693.y, _3693.z, _298.w);
    float3 _3709 = _298.xyz * float3(float3(_211_m22, _211_m22, _211_m22));
    _298 = float4(_3709.x, _3709.y, _3709.z, _298.w);
    float3 _3719 = (_298.xyz * 0.550000011920928955078125f.xxx) + _279.xyz;
    _279 = float4(_3719.x, _3719.y, _3719.z, _279.w);
    _305 = _211_m7 * 2.5f;
    _305 = 1.0f / (-_305);
    _781 = _305 * _781;
    _781 = clamp(_781, 0.0f, 1.0f);
    _305 = (_781 * (-2.0f)) + 3.0f;
    _781 *= _781;
    _781 *= _305;
    _781 = _264.x * _781;
    _305 = (_781 * 0.3499999940395355224609375f) + _243.x;
    float3 _3757 = _781.xxx * _211_m4.xyz;
    _243 = float4(_3757.x, _3757.y, _3757.z, _243.w);
    float3 _3773 = _243.xyz * float3(float3(_211_m22, _211_m22, _211_m22));
    _243 = float4(_3773.x, _3773.y, _3773.z, _243.w);
    float3 _3783 = (_243.xyz * 0.300000011920928955078125f.xxx) + _279.xyz;
    _243 = float4(_3783.x, _3783.y, _3783.z, _243.w);
    _781 = (_208 * 0.89999997615814208984375f) + _305;
    _781 = clamp(_781, 0.0f, 1.0f);
    float3 _3798 = _208.xxx * _211_m5.xyz;
    _279 = float4(_3798.x, _3798.y, _3798.z, _279.w);
    float3 _3817 = (_279.xyz * float3(float3(_211_m22, _211_m22, _211_m22))) + _243.xyz;
    _243 = float4(_3817.x, _3817.y, _3817.z, _243.w);
    _208 = (_226.x * (-2.0f)) + 3.0f;
    _226.x *= _226.x;
    _208 = ((-_208) * _226.x) + 1.0f;
    _243.w = _208 * _781;
    _3841 = _243;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._3841 = _3841;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}