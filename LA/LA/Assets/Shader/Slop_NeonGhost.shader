// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/NeonGhost" {
Properties {

_MainTex ("Ghost Atlas (R core, G glow, B haze)", 2D) = "black" { }

_CoreColor ("Tube Core", Color) = (1.2,1.3,1.45,1)

_GlowColor ("Glow", Color) = (0.22,0.36,1.35,1)

_FillColor ("Body Haze", Color) = (0.04,0.07,0.3,1)

_Intensity ("Intensity", Range(0, 3)) = 1.0

_WaveAmp ("Cloth Wave Amplitude", Range(0, 0.05)) = 0.014000000432133675

_WaveFreq ("Cloth Wave Frequency", Range(0, 30)) = 9.0

_WaveSpeed ("Cloth Wave Speed", Range(0, 10)) = 3.200000047683716

_Flicker ("Neon Flicker", Range(0, 1)) = 0.18000000715255737

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
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
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
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



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float4 _122;
static float4 _123;
static float2 vs_TEXCOORD0;
static float4 _128;
static float4 vs_TEXCOORD1;
static float2 _137;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _123 : COLOR;
    float4 _128 : TEXCOORD0;
    float2 _137 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _122 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD1 : TEXCOORD3;
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
    _122 = _123;
    vs_TEXCOORD0 = _128.xy;
    vs_TEXCOORD1 = float4(_128.zw.x, _128.zw.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _137.x, _137.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _123 = stage_input._123;
    _128 = stage_input._128;
    _137 = stage_input._137;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._122 = _122;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _CoreColor;
float4 _GlowColor;
float4 _FillColor;
float _Intensity;
float _WaveAmp;
float _WaveFreq;
float _WaveSpeed;
float _Flicker;
#define _97_m0 _Time
#define _97_m1 _CoreColor
#define _97_m2 _GlowColor
#define _97_m3 _FillColor
#define _97_m4 _Intensity
#define _97_m5 _WaveAmp
#define _97_m6 _WaveFreq
#define _97_m7 _WaveSpeed
#define _97_m8 _Flicker


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _742;
static float vs_TEXCOORD2;
static float4 _772;

struct SPIRV_Cross_Input
{
    float4 _742 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD1 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _772 : SV_Target0;
};

static int _8;
static int _25;
static float4 _36;
static float2 _43;
static float _104;
static float _122;
static float3 _175;
static float3 _198;
static bool4 _263;
static bool _328;
static float _333;
static float3 _361;
static float3 _376;
static float4 _414;
static float2 _425;
static float2 _439;
static bool2 _470;
static bool2 _483;
static float _500;
static float2 _505;
static float _570;
static float3 _576;
static float3 _603;
static float _628;
static float2 _662;
static bool _722;

void frag_inner()
{
    _8 = int((0.0f < vs_TEXCOORD1.z) ? 4294967295u : 0u);
    _25 = int((vs_TEXCOORD1.z < 0.0f) ? 4294967295u : 0u);
    _8 = (-_8) + _25;
    _36.x = float(_8);
    _43.x = max(abs(vs_TEXCOORD1.z), 0.180000007152557373046875f);
    _36.x = _43.x * _36.x;
    _43.x = vs_TEXCOORD0.x + (-0.5f);
    _36.x = _43.x / _36.x;
    _36.x += 0.5f;
    _43.x = (-vs_TEXCOORD0.y) + 1.14999997615814208984375f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x = (_43.x * 1.39999997615814208984375f) + 0.3499999940395355224609375f;
    _43.x *= _97_m5;
    _104 = (vs_TEXCOORD1.x * 5.0f) + 1.0f;
    _43.x = _104 * _43.x;
    _104 = _97_m0.y * _97_m7;
    _122 = (vs_TEXCOORD0.y * _97_m6) + _104;
    _104 *= 0.800000011920928955078125f;
    _122 = (vs_TEXCOORD1.y * 6.283100128173828125f) + _122;
    _122 = sin(_122);
    _36.x = (_122 * _43.x) + _36.x;
    _122 = _36.x * _97_m6;
    _104 = (_122 * 0.699999988079071044921875f) + _104;
    _104 = (vs_TEXCOORD1.y * 3.099999904632568359375f) + _104;
    _104 = sin(_104);
    _43.x *= _104;
    _175.y = (_43.x * 0.3499999940395355224609375f) + vs_TEXCOORD0.y;
    _43 = _97_m0.yy * float2(24.0f, 30.0f);
    _43 = floor(_43);
    _43.x *= 3.7000000476837158203125f;
    _198.y = (vs_TEXCOORD1.y * 17.0f) + _43.y;
    _43.x = (_175.y * 22.0f) + _43.x;
    _198.x = floor(_43.x);
    _43.x = dot(_198.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _43.x = frac(_43.x);
    _43.x += (-0.5f);
    _104 = vs_TEXCOORD1.x * vs_TEXCOORD1.x;
    _43.x *= _104;
    _175.x = (_43.x * 0.2199999988079071044921875f) + _36.x;
    bool2 _269 = bool4(_175.xyxx.x >= 0.0f.xxxx.x, _175.xyxx.y >= 0.0f.xxxx.y, _175.xyxx.z >= 0.0f.xxxx.z, _175.xyxx.w >= 0.0f.xxxx.w).xy;
    _263 = bool4(_269.x, _269.y, _263.z, _263.w);
    bool2 _276 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _175.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _175.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _175.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _175.xxxy.w).zw;
    _263 = bool4(_263.x, _263.y, _276.x, _276.y);
    _36.x = float(_263.x);
    _36.y = float(_263.y);
    _36.z = float(_263.z);
    _36.w = float(_263.w);
    _36.x = _36.z * _36.x;
    _36.x = _36.y * _36.x;
    _36.x = _36.w * _36.x;
    _43 = _175.xy;
    _43 = clamp(_43, 0.0f.xx, 1.0f.xx);
    _122 = vs_TEXCOORD1.w + 0.5f;
    _122 = floor(_122);
    _122 *= 0.5f;
    _328 = _122 >= (-_122);
    _333 = frac(abs(_122));
    _198.y = floor(_122);
    float _342;
    if (_328)
    {
        _342 = _333;
    }
    else
    {
        _342 = -_333;
    }
    _122 = _342;
    _198.x = _122 + _122;
    _43 += _198.xy;
    _43 *= 0.5f.xx;
    _361 = _MainTex.Sample(sampler_MainTex, _43).xyz;
    float3 _373 = _36.xxx * _361;
    _36 = float4(_373.x, _373.y, _373.z, _36.w);
    _376 = _36.zzz * _97_m3.xyz;
    _376 = (_36.yyy * _97_m2.xyz) + _376;
    _36.x = (vs_TEXCOORD1.x * (-_36.x)) + _36.x;
    float3 _411 = (_97_m1.xyz * _36.xxx) + _376;
    _36 = float4(_411.x, _411.y, _411.z, _36.w);
    _414.w = 0.0f;
    float3 _422 = vs_TEXCOORD1.yyx * float3(40.0f, 11.0f, 0.02500000037252902984619140625f);
    _414 = float4(_422.x, _422.y, _422.z, _414.w);
    _425 = _175.xy + (-_414.zw);
    float2 _436 = _175.xy + _414.zw;
    _175 = float3(_436.x, _436.y, _175.z);
    _439 = (_97_m0.yy * float2(13.0f, 7.30000019073486328125f)) + _414.xy;
    _439 = sin(_439);
    _122 = _439.y * _439.x;
    _122 = (_122 * 0.5f) + 0.5f;
    _122 *= _97_m8;
    _122 = ((-_122) * 0.5f) + 1.0f;
    _470 = bool4(_425.xyxy.x >= 0.0f.xxxx.x, _425.xyxy.y >= 0.0f.xxxx.y, _425.xyxy.z >= 0.0f.xxxx.z, _425.xyxy.w >= 0.0f.xxxx.w).xy;
    _439.x = float(_470.x);
    _439.y = float(_470.y);
    _483 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x >= _425.xyxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y >= _425.xyxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z >= _425.xyxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w >= _425.xyxx.w).xy;
    _425 = _425;
    _425 = clamp(_425, 0.0f.xx, 1.0f.xx);
    _425 = _198.xy + _425;
    _425 *= 0.5f.xx;
    _500 = _MainTex.Sample(sampler_MainTex, _425).x;
    _505.x = float(_483.x);
    _505.y = float(_483.y);
    _333 = _439.x * _505.x;
    _333 = _439.y * _333;
    _333 = _505.y * _333;
    _425.x = _333 * _500;
    _470 = bool4(_175.xyxy.x >= 0.0f.xxxx.x, _175.xyxy.y >= 0.0f.xxxx.y, _175.xyxy.z >= 0.0f.xxxx.z, _175.xyxy.w >= 0.0f.xxxx.w).xy;
    _439.x = float(_470.x);
    _439.y = float(_470.y);
    _483 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x >= _175.xyxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y >= _175.xyxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z >= _175.xyxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w >= _175.xyxx.w).xy;
    _175 = float3(_175.xy.x, _175.xy.y, _175.z);
    float2 _555 = clamp(_175.xy, 0.0f.xx, 1.0f.xx);
    _175 = float3(_555.x, _555.y, _175.z);
    float2 _562 = _198.xy + _175.xy;
    _175 = float3(_562.x, _562.y, _175.z);
    float2 _567 = _175.xy * 0.5f.xx;
    _175 = float3(_567.x, _567.y, _175.z);
    _570 = _MainTex.Sample(sampler_MainTex, _175.xy).x;
    _576.x = float(_483.x);
    _576.z = float(_483.y);
    _576.x *= _439.x;
    _576.x = _439.y * _576.x;
    _576.x = _576.z * _576.x;
    _603.x = (_570 * _576.x) + _425.x;
    _175.x = _576.x * _570;
    _603.x *= _97_m1.y;
    _603.y = _603.x * 0.25f;
    _628 = _97_m1.x;
    _603.x = _175.x * _628;
    float2 _640 = _603.xy * vs_TEXCOORD1.xx;
    _175 = float3(_640.x, _640.y, _175.z);
    float2 _647 = _175.xy * 0.89999997615814208984375f.xx;
    _198 = float3(_647.x, _647.y, _198.z);
    _198.z = 0.0f;
    float3 _654 = _36.xyz + _198;
    _36 = float4(_654.x, _654.y, _654.z, _36.w);
    _603.x = _425.x * 0.60000002384185791015625f;
    _662.y = _425.x * _97_m1.z;
    _662.x = _603.x * _97_m1.y;
    float2 _678 = _662 * vs_TEXCOORD1.xx;
    _175 = float3(_175.x, _678.x, _678.y);
    _175.x = vs_TEXCOORD1.x;
    float3 _689 = (_175 * float3(0.0f, 0.89999997615814208984375f, 0.89999997615814208984375f)) + _36.xyz;
    _36 = float4(_689.x, _689.y, _689.z, _36.w);
    _175.x = _97_m0.y * 18.0f;
    _175.x = floor(_175.x);
    _175.y = vs_TEXCOORD1.y * 31.0f;
    _175.x = dot(_175.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _175.x = sin(_175.x);
    _175.x *= 43758.546875f;
    _175.x = frac(_175.x);
    _722 = _175.x >= 0.98500001430511474609375f;
    _175.x = _722 ? 0.449999988079071044921875f : 1.0f;
    _122 *= _175.x;
    float3 _739 = _122.xxx * _36.xyz;
    _36 = float4(_739.x, _739.y, _739.z, _36.w);
    _603 = _742.www * _742.xyz;
    _603 *= _97_m4.xxx;
    _603 = _36.xyz * _603;
    _36.x = vs_TEXCOORD2;
    _36.x = clamp(_36.x, 0.0f, 1.0f);
    float3 _768 = _603 * _36.xxx;
    _36 = float4(_768.x, _768.y, _768.z, _36.w);
    _772 = float4(_36.xyz.x, _36.xyz.y, _36.xyz.z, _772.w);
    _772.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _742 = stage_input._742;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._772 = _772;
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



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float4 _128;
static float4 _129;
static float2 vs_TEXCOORD0;
static float4 _134;
static float4 vs_TEXCOORD1;
static float2 _143;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _129 : COLOR;
    float4 _134 : TEXCOORD0;
    float2 _143 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _128 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD1 : TEXCOORD3;
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
    _128 = _129;
    vs_TEXCOORD0 = _134.xy;
    vs_TEXCOORD1 = float4(_134.zw.x, _134.zw.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _143.x, _143.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _129 = stage_input._129;
    _134 = stage_input._134;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._128 = _128;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _CoreColor;
float4 _GlowColor;
float4 _FillColor;
float _Intensity;
float _WaveAmp;
float _WaveFreq;
float _WaveSpeed;
float _Flicker;
#define _97_m0 _Time
#define _97_m1 _CoreColor
#define _97_m2 _GlowColor
#define _97_m3 _FillColor
#define _97_m4 _Intensity
#define _97_m5 _WaveAmp
#define _97_m6 _WaveFreq
#define _97_m7 _WaveSpeed
#define _97_m8 _Flicker


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _742;
static float vs_TEXCOORD2;
static float4 _772;

struct SPIRV_Cross_Input
{
    float4 _742 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD1 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _772 : SV_Target0;
};

static int _8;
static int _25;
static float4 _36;
static float2 _43;
static float _104;
static float _122;
static float3 _175;
static float3 _198;
static bool4 _263;
static bool _328;
static float _333;
static float3 _361;
static float3 _376;
static float4 _414;
static float2 _425;
static float2 _439;
static bool2 _470;
static bool2 _483;
static float _500;
static float2 _505;
static float _570;
static float3 _576;
static float3 _603;
static float _628;
static float2 _662;
static bool _722;

void frag_inner()
{
    _8 = int((0.0f < vs_TEXCOORD1.z) ? 4294967295u : 0u);
    _25 = int((vs_TEXCOORD1.z < 0.0f) ? 4294967295u : 0u);
    _8 = (-_8) + _25;
    _36.x = float(_8);
    _43.x = max(abs(vs_TEXCOORD1.z), 0.180000007152557373046875f);
    _36.x = _43.x * _36.x;
    _43.x = vs_TEXCOORD0.x + (-0.5f);
    _36.x = _43.x / _36.x;
    _36.x += 0.5f;
    _43.x = (-vs_TEXCOORD0.y) + 1.14999997615814208984375f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x = (_43.x * 1.39999997615814208984375f) + 0.3499999940395355224609375f;
    _43.x *= _97_m5;
    _104 = (vs_TEXCOORD1.x * 5.0f) + 1.0f;
    _43.x = _104 * _43.x;
    _104 = _97_m0.y * _97_m7;
    _122 = (vs_TEXCOORD0.y * _97_m6) + _104;
    _104 *= 0.800000011920928955078125f;
    _122 = (vs_TEXCOORD1.y * 6.283100128173828125f) + _122;
    _122 = sin(_122);
    _36.x = (_122 * _43.x) + _36.x;
    _122 = _36.x * _97_m6;
    _104 = (_122 * 0.699999988079071044921875f) + _104;
    _104 = (vs_TEXCOORD1.y * 3.099999904632568359375f) + _104;
    _104 = sin(_104);
    _43.x *= _104;
    _175.y = (_43.x * 0.3499999940395355224609375f) + vs_TEXCOORD0.y;
    _43 = _97_m0.yy * float2(24.0f, 30.0f);
    _43 = floor(_43);
    _43.x *= 3.7000000476837158203125f;
    _198.y = (vs_TEXCOORD1.y * 17.0f) + _43.y;
    _43.x = (_175.y * 22.0f) + _43.x;
    _198.x = floor(_43.x);
    _43.x = dot(_198.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _43.x = frac(_43.x);
    _43.x += (-0.5f);
    _104 = vs_TEXCOORD1.x * vs_TEXCOORD1.x;
    _43.x *= _104;
    _175.x = (_43.x * 0.2199999988079071044921875f) + _36.x;
    bool2 _269 = bool4(_175.xyxx.x >= 0.0f.xxxx.x, _175.xyxx.y >= 0.0f.xxxx.y, _175.xyxx.z >= 0.0f.xxxx.z, _175.xyxx.w >= 0.0f.xxxx.w).xy;
    _263 = bool4(_269.x, _269.y, _263.z, _263.w);
    bool2 _276 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _175.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _175.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _175.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _175.xxxy.w).zw;
    _263 = bool4(_263.x, _263.y, _276.x, _276.y);
    _36.x = float(_263.x);
    _36.y = float(_263.y);
    _36.z = float(_263.z);
    _36.w = float(_263.w);
    _36.x = _36.z * _36.x;
    _36.x = _36.y * _36.x;
    _36.x = _36.w * _36.x;
    _43 = _175.xy;
    _43 = clamp(_43, 0.0f.xx, 1.0f.xx);
    _122 = vs_TEXCOORD1.w + 0.5f;
    _122 = floor(_122);
    _122 *= 0.5f;
    _328 = _122 >= (-_122);
    _333 = frac(abs(_122));
    _198.y = floor(_122);
    float _342;
    if (_328)
    {
        _342 = _333;
    }
    else
    {
        _342 = -_333;
    }
    _122 = _342;
    _198.x = _122 + _122;
    _43 += _198.xy;
    _43 *= 0.5f.xx;
    _361 = _MainTex.Sample(sampler_MainTex, _43).xyz;
    float3 _373 = _36.xxx * _361;
    _36 = float4(_373.x, _373.y, _373.z, _36.w);
    _376 = _36.zzz * _97_m3.xyz;
    _376 = (_36.yyy * _97_m2.xyz) + _376;
    _36.x = (vs_TEXCOORD1.x * (-_36.x)) + _36.x;
    float3 _411 = (_97_m1.xyz * _36.xxx) + _376;
    _36 = float4(_411.x, _411.y, _411.z, _36.w);
    _414.w = 0.0f;
    float3 _422 = vs_TEXCOORD1.yyx * float3(40.0f, 11.0f, 0.02500000037252902984619140625f);
    _414 = float4(_422.x, _422.y, _422.z, _414.w);
    _425 = _175.xy + (-_414.zw);
    float2 _436 = _175.xy + _414.zw;
    _175 = float3(_436.x, _436.y, _175.z);
    _439 = (_97_m0.yy * float2(13.0f, 7.30000019073486328125f)) + _414.xy;
    _439 = sin(_439);
    _122 = _439.y * _439.x;
    _122 = (_122 * 0.5f) + 0.5f;
    _122 *= _97_m8;
    _122 = ((-_122) * 0.5f) + 1.0f;
    _470 = bool4(_425.xyxy.x >= 0.0f.xxxx.x, _425.xyxy.y >= 0.0f.xxxx.y, _425.xyxy.z >= 0.0f.xxxx.z, _425.xyxy.w >= 0.0f.xxxx.w).xy;
    _439.x = float(_470.x);
    _439.y = float(_470.y);
    _483 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x >= _425.xyxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y >= _425.xyxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z >= _425.xyxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w >= _425.xyxx.w).xy;
    _425 = _425;
    _425 = clamp(_425, 0.0f.xx, 1.0f.xx);
    _425 = _198.xy + _425;
    _425 *= 0.5f.xx;
    _500 = _MainTex.Sample(sampler_MainTex, _425).x;
    _505.x = float(_483.x);
    _505.y = float(_483.y);
    _333 = _439.x * _505.x;
    _333 = _439.y * _333;
    _333 = _505.y * _333;
    _425.x = _333 * _500;
    _470 = bool4(_175.xyxy.x >= 0.0f.xxxx.x, _175.xyxy.y >= 0.0f.xxxx.y, _175.xyxy.z >= 0.0f.xxxx.z, _175.xyxy.w >= 0.0f.xxxx.w).xy;
    _439.x = float(_470.x);
    _439.y = float(_470.y);
    _483 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x >= _175.xyxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y >= _175.xyxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z >= _175.xyxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w >= _175.xyxx.w).xy;
    _175 = float3(_175.xy.x, _175.xy.y, _175.z);
    float2 _555 = clamp(_175.xy, 0.0f.xx, 1.0f.xx);
    _175 = float3(_555.x, _555.y, _175.z);
    float2 _562 = _198.xy + _175.xy;
    _175 = float3(_562.x, _562.y, _175.z);
    float2 _567 = _175.xy * 0.5f.xx;
    _175 = float3(_567.x, _567.y, _175.z);
    _570 = _MainTex.Sample(sampler_MainTex, _175.xy).x;
    _576.x = float(_483.x);
    _576.z = float(_483.y);
    _576.x *= _439.x;
    _576.x = _439.y * _576.x;
    _576.x = _576.z * _576.x;
    _603.x = (_570 * _576.x) + _425.x;
    _175.x = _576.x * _570;
    _603.x *= _97_m1.y;
    _603.y = _603.x * 0.25f;
    _628 = _97_m1.x;
    _603.x = _175.x * _628;
    float2 _640 = _603.xy * vs_TEXCOORD1.xx;
    _175 = float3(_640.x, _640.y, _175.z);
    float2 _647 = _175.xy * 0.89999997615814208984375f.xx;
    _198 = float3(_647.x, _647.y, _198.z);
    _198.z = 0.0f;
    float3 _654 = _36.xyz + _198;
    _36 = float4(_654.x, _654.y, _654.z, _36.w);
    _603.x = _425.x * 0.60000002384185791015625f;
    _662.y = _425.x * _97_m1.z;
    _662.x = _603.x * _97_m1.y;
    float2 _678 = _662 * vs_TEXCOORD1.xx;
    _175 = float3(_175.x, _678.x, _678.y);
    _175.x = vs_TEXCOORD1.x;
    float3 _689 = (_175 * float3(0.0f, 0.89999997615814208984375f, 0.89999997615814208984375f)) + _36.xyz;
    _36 = float4(_689.x, _689.y, _689.z, _36.w);
    _175.x = _97_m0.y * 18.0f;
    _175.x = floor(_175.x);
    _175.y = vs_TEXCOORD1.y * 31.0f;
    _175.x = dot(_175.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _175.x = sin(_175.x);
    _175.x *= 43758.546875f;
    _175.x = frac(_175.x);
    _722 = _175.x >= 0.98500001430511474609375f;
    _175.x = _722 ? 0.449999988079071044921875f : 1.0f;
    _122 *= _175.x;
    float3 _739 = _122.xxx * _36.xyz;
    _36 = float4(_739.x, _739.y, _739.z, _36.w);
    _603 = _742.www * _742.xyz;
    _603 *= _97_m4.xxx;
    _603 = _36.xyz * _603;
    _36.x = vs_TEXCOORD2;
    _36.x = clamp(_36.x, 0.0f, 1.0f);
    float3 _768 = _603 * _36.xxx;
    _36 = float4(_768.x, _768.y, _768.z, _36.w);
    _772 = float4(_36.xyz.x, _36.xyz.y, _36.xyz.z, _772.w);
    _772.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _742 = stage_input._742;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._772 = _772;
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



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float4 _121;
static float4 _122;
static float2 vs_TEXCOORD0;
static float4 _127;
static float4 vs_TEXCOORD1;
static float2 _136;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _122 : COLOR;
    float4 _127 : TEXCOORD0;
    float2 _136 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _121 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD1 : TEXCOORD3;
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
    _121 = _122;
    vs_TEXCOORD0 = _127.xy;
    vs_TEXCOORD1 = float4(_127.zw.x, _127.zw.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _136.x, _136.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _122 = stage_input._122;
    _127 = stage_input._127;
    _136 = stage_input._136;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._121 = _121;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _CoreColor;
float4 _GlowColor;
float4 _FillColor;
float _Intensity;
float _WaveAmp;
float _WaveFreq;
float _WaveSpeed;
float _Flicker;
#define _97_m0 _Time
#define _97_m1 _CoreColor
#define _97_m2 _GlowColor
#define _97_m3 _FillColor
#define _97_m4 _Intensity
#define _97_m5 _WaveAmp
#define _97_m6 _WaveFreq
#define _97_m7 _WaveSpeed
#define _97_m8 _Flicker


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _742;
static float vs_TEXCOORD2;
static float4 _772;

struct SPIRV_Cross_Input
{
    float4 _742 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD1 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _772 : SV_Target0;
};

static int _8;
static int _25;
static float4 _36;
static float2 _43;
static float _104;
static float _122;
static float3 _175;
static float3 _198;
static bool4 _263;
static bool _328;
static float _333;
static float3 _361;
static float3 _376;
static float4 _414;
static float2 _425;
static float2 _439;
static bool2 _470;
static bool2 _483;
static float _500;
static float2 _505;
static float _570;
static float3 _576;
static float3 _603;
static float _628;
static float2 _662;
static bool _722;

void frag_inner()
{
    _8 = int((0.0f < vs_TEXCOORD1.z) ? 4294967295u : 0u);
    _25 = int((vs_TEXCOORD1.z < 0.0f) ? 4294967295u : 0u);
    _8 = (-_8) + _25;
    _36.x = float(_8);
    _43.x = max(abs(vs_TEXCOORD1.z), 0.180000007152557373046875f);
    _36.x = _43.x * _36.x;
    _43.x = vs_TEXCOORD0.x + (-0.5f);
    _36.x = _43.x / _36.x;
    _36.x += 0.5f;
    _43.x = (-vs_TEXCOORD0.y) + 1.14999997615814208984375f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x = (_43.x * 1.39999997615814208984375f) + 0.3499999940395355224609375f;
    _43.x *= _97_m5;
    _104 = (vs_TEXCOORD1.x * 5.0f) + 1.0f;
    _43.x = _104 * _43.x;
    _104 = _97_m0.y * _97_m7;
    _122 = (vs_TEXCOORD0.y * _97_m6) + _104;
    _104 *= 0.800000011920928955078125f;
    _122 = (vs_TEXCOORD1.y * 6.283100128173828125f) + _122;
    _122 = sin(_122);
    _36.x = (_122 * _43.x) + _36.x;
    _122 = _36.x * _97_m6;
    _104 = (_122 * 0.699999988079071044921875f) + _104;
    _104 = (vs_TEXCOORD1.y * 3.099999904632568359375f) + _104;
    _104 = sin(_104);
    _43.x *= _104;
    _175.y = (_43.x * 0.3499999940395355224609375f) + vs_TEXCOORD0.y;
    _43 = _97_m0.yy * float2(24.0f, 30.0f);
    _43 = floor(_43);
    _43.x *= 3.7000000476837158203125f;
    _198.y = (vs_TEXCOORD1.y * 17.0f) + _43.y;
    _43.x = (_175.y * 22.0f) + _43.x;
    _198.x = floor(_43.x);
    _43.x = dot(_198.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _43.x = frac(_43.x);
    _43.x += (-0.5f);
    _104 = vs_TEXCOORD1.x * vs_TEXCOORD1.x;
    _43.x *= _104;
    _175.x = (_43.x * 0.2199999988079071044921875f) + _36.x;
    bool2 _269 = bool4(_175.xyxx.x >= 0.0f.xxxx.x, _175.xyxx.y >= 0.0f.xxxx.y, _175.xyxx.z >= 0.0f.xxxx.z, _175.xyxx.w >= 0.0f.xxxx.w).xy;
    _263 = bool4(_269.x, _269.y, _263.z, _263.w);
    bool2 _276 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _175.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _175.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _175.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _175.xxxy.w).zw;
    _263 = bool4(_263.x, _263.y, _276.x, _276.y);
    _36.x = float(_263.x);
    _36.y = float(_263.y);
    _36.z = float(_263.z);
    _36.w = float(_263.w);
    _36.x = _36.z * _36.x;
    _36.x = _36.y * _36.x;
    _36.x = _36.w * _36.x;
    _43 = _175.xy;
    _43 = clamp(_43, 0.0f.xx, 1.0f.xx);
    _122 = vs_TEXCOORD1.w + 0.5f;
    _122 = floor(_122);
    _122 *= 0.5f;
    _328 = _122 >= (-_122);
    _333 = frac(abs(_122));
    _198.y = floor(_122);
    float _342;
    if (_328)
    {
        _342 = _333;
    }
    else
    {
        _342 = -_333;
    }
    _122 = _342;
    _198.x = _122 + _122;
    _43 += _198.xy;
    _43 *= 0.5f.xx;
    _361 = _MainTex.Sample(sampler_MainTex, _43).xyz;
    float3 _373 = _36.xxx * _361;
    _36 = float4(_373.x, _373.y, _373.z, _36.w);
    _376 = _36.zzz * _97_m3.xyz;
    _376 = (_36.yyy * _97_m2.xyz) + _376;
    _36.x = (vs_TEXCOORD1.x * (-_36.x)) + _36.x;
    float3 _411 = (_97_m1.xyz * _36.xxx) + _376;
    _36 = float4(_411.x, _411.y, _411.z, _36.w);
    _414.w = 0.0f;
    float3 _422 = vs_TEXCOORD1.yyx * float3(40.0f, 11.0f, 0.02500000037252902984619140625f);
    _414 = float4(_422.x, _422.y, _422.z, _414.w);
    _425 = _175.xy + (-_414.zw);
    float2 _436 = _175.xy + _414.zw;
    _175 = float3(_436.x, _436.y, _175.z);
    _439 = (_97_m0.yy * float2(13.0f, 7.30000019073486328125f)) + _414.xy;
    _439 = sin(_439);
    _122 = _439.y * _439.x;
    _122 = (_122 * 0.5f) + 0.5f;
    _122 *= _97_m8;
    _122 = ((-_122) * 0.5f) + 1.0f;
    _470 = bool4(_425.xyxy.x >= 0.0f.xxxx.x, _425.xyxy.y >= 0.0f.xxxx.y, _425.xyxy.z >= 0.0f.xxxx.z, _425.xyxy.w >= 0.0f.xxxx.w).xy;
    _439.x = float(_470.x);
    _439.y = float(_470.y);
    _483 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x >= _425.xyxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y >= _425.xyxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z >= _425.xyxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w >= _425.xyxx.w).xy;
    _425 = _425;
    _425 = clamp(_425, 0.0f.xx, 1.0f.xx);
    _425 = _198.xy + _425;
    _425 *= 0.5f.xx;
    _500 = _MainTex.Sample(sampler_MainTex, _425).x;
    _505.x = float(_483.x);
    _505.y = float(_483.y);
    _333 = _439.x * _505.x;
    _333 = _439.y * _333;
    _333 = _505.y * _333;
    _425.x = _333 * _500;
    _470 = bool4(_175.xyxy.x >= 0.0f.xxxx.x, _175.xyxy.y >= 0.0f.xxxx.y, _175.xyxy.z >= 0.0f.xxxx.z, _175.xyxy.w >= 0.0f.xxxx.w).xy;
    _439.x = float(_470.x);
    _439.y = float(_470.y);
    _483 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x >= _175.xyxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y >= _175.xyxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z >= _175.xyxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w >= _175.xyxx.w).xy;
    _175 = float3(_175.xy.x, _175.xy.y, _175.z);
    float2 _555 = clamp(_175.xy, 0.0f.xx, 1.0f.xx);
    _175 = float3(_555.x, _555.y, _175.z);
    float2 _562 = _198.xy + _175.xy;
    _175 = float3(_562.x, _562.y, _175.z);
    float2 _567 = _175.xy * 0.5f.xx;
    _175 = float3(_567.x, _567.y, _175.z);
    _570 = _MainTex.Sample(sampler_MainTex, _175.xy).x;
    _576.x = float(_483.x);
    _576.z = float(_483.y);
    _576.x *= _439.x;
    _576.x = _439.y * _576.x;
    _576.x = _576.z * _576.x;
    _603.x = (_570 * _576.x) + _425.x;
    _175.x = _576.x * _570;
    _603.x *= _97_m1.y;
    _603.y = _603.x * 0.25f;
    _628 = _97_m1.x;
    _603.x = _175.x * _628;
    float2 _640 = _603.xy * vs_TEXCOORD1.xx;
    _175 = float3(_640.x, _640.y, _175.z);
    float2 _647 = _175.xy * 0.89999997615814208984375f.xx;
    _198 = float3(_647.x, _647.y, _198.z);
    _198.z = 0.0f;
    float3 _654 = _36.xyz + _198;
    _36 = float4(_654.x, _654.y, _654.z, _36.w);
    _603.x = _425.x * 0.60000002384185791015625f;
    _662.y = _425.x * _97_m1.z;
    _662.x = _603.x * _97_m1.y;
    float2 _678 = _662 * vs_TEXCOORD1.xx;
    _175 = float3(_175.x, _678.x, _678.y);
    _175.x = vs_TEXCOORD1.x;
    float3 _689 = (_175 * float3(0.0f, 0.89999997615814208984375f, 0.89999997615814208984375f)) + _36.xyz;
    _36 = float4(_689.x, _689.y, _689.z, _36.w);
    _175.x = _97_m0.y * 18.0f;
    _175.x = floor(_175.x);
    _175.y = vs_TEXCOORD1.y * 31.0f;
    _175.x = dot(_175.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _175.x = sin(_175.x);
    _175.x *= 43758.546875f;
    _175.x = frac(_175.x);
    _722 = _175.x >= 0.98500001430511474609375f;
    _175.x = _722 ? 0.449999988079071044921875f : 1.0f;
    _122 *= _175.x;
    float3 _739 = _122.xxx * _36.xyz;
    _36 = float4(_739.x, _739.y, _739.z, _36.w);
    _603 = _742.www * _742.xyz;
    _603 *= _97_m4.xxx;
    _603 = _36.xyz * _603;
    _36.x = vs_TEXCOORD2;
    _36.x = clamp(_36.x, 0.0f, 1.0f);
    float3 _768 = _603 * _36.xxx;
    _36 = float4(_768.x, _768.y, _768.z, _36.w);
    _772 = float4(_36.xyz.x, _36.xyz.y, _36.xyz.z, _772.w);
    _772.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _742 = stage_input._742;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._772 = _772;
    return stage_output;
}

#endif
#else
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
static float4 _82;
static float4 _83;
static float2 vs_TEXCOORD0;
static float4 _88;
static float4 vs_TEXCOORD1;
static float2 _97;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _83 : COLOR;
    float4 _88 : TEXCOORD0;
    float2 _97 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _82 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
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
    _82 = _83;
    vs_TEXCOORD0 = _88.xy;
    vs_TEXCOORD1 = float4(_88.zw.x, _88.zw.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _97.x, _97.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _83 = stage_input._83;
    _88 = stage_input._88;
    _97 = stage_input._97;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._82 = _82;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _CoreColor;
float4 _GlowColor;
float4 _FillColor;
float _Intensity;
float _WaveAmp;
float _WaveFreq;
float _WaveSpeed;
float _Flicker;
#define _97_m0 _Time
#define _97_m1 _CoreColor
#define _97_m2 _GlowColor
#define _97_m3 _FillColor
#define _97_m4 _Intensity
#define _97_m5 _WaveAmp
#define _97_m6 _WaveFreq
#define _97_m7 _WaveSpeed
#define _97_m8 _Flicker


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _742;
static float4 _755;

struct SPIRV_Cross_Input
{
    float4 _742 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _755 : SV_Target0;
};

static int _8;
static int _25;
static float4 _36;
static float2 _43;
static float _104;
static float _122;
static float3 _175;
static float3 _198;
static bool4 _263;
static bool _328;
static float _333;
static float3 _361;
static float3 _376;
static float4 _414;
static float2 _425;
static float2 _439;
static bool2 _470;
static bool2 _483;
static float _500;
static float2 _505;
static float _570;
static float3 _576;
static float3 _603;
static float _628;
static float2 _662;
static bool _722;

void frag_inner()
{
    _8 = int((0.0f < vs_TEXCOORD1.z) ? 4294967295u : 0u);
    _25 = int((vs_TEXCOORD1.z < 0.0f) ? 4294967295u : 0u);
    _8 = (-_8) + _25;
    _36.x = float(_8);
    _43.x = max(abs(vs_TEXCOORD1.z), 0.180000007152557373046875f);
    _36.x = _43.x * _36.x;
    _43.x = vs_TEXCOORD0.x + (-0.5f);
    _36.x = _43.x / _36.x;
    _36.x += 0.5f;
    _43.x = (-vs_TEXCOORD0.y) + 1.14999997615814208984375f;
    _43.x = clamp(_43.x, 0.0f, 1.0f);
    _43.x = (_43.x * 1.39999997615814208984375f) + 0.3499999940395355224609375f;
    _43.x *= _97_m5;
    _104 = (vs_TEXCOORD1.x * 5.0f) + 1.0f;
    _43.x = _104 * _43.x;
    _104 = _97_m0.y * _97_m7;
    _122 = (vs_TEXCOORD0.y * _97_m6) + _104;
    _104 *= 0.800000011920928955078125f;
    _122 = (vs_TEXCOORD1.y * 6.283100128173828125f) + _122;
    _122 = sin(_122);
    _36.x = (_122 * _43.x) + _36.x;
    _122 = _36.x * _97_m6;
    _104 = (_122 * 0.699999988079071044921875f) + _104;
    _104 = (vs_TEXCOORD1.y * 3.099999904632568359375f) + _104;
    _104 = sin(_104);
    _43.x *= _104;
    _175.y = (_43.x * 0.3499999940395355224609375f) + vs_TEXCOORD0.y;
    _43 = _97_m0.yy * float2(24.0f, 30.0f);
    _43 = floor(_43);
    _43.x *= 3.7000000476837158203125f;
    _198.y = (vs_TEXCOORD1.y * 17.0f) + _43.y;
    _43.x = (_175.y * 22.0f) + _43.x;
    _198.x = floor(_43.x);
    _43.x = dot(_198.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _43.x = sin(_43.x);
    _43.x *= 43758.546875f;
    _43.x = frac(_43.x);
    _43.x += (-0.5f);
    _104 = vs_TEXCOORD1.x * vs_TEXCOORD1.x;
    _43.x *= _104;
    _175.x = (_43.x * 0.2199999988079071044921875f) + _36.x;
    bool2 _269 = bool4(_175.xyxx.x >= 0.0f.xxxx.x, _175.xyxx.y >= 0.0f.xxxx.y, _175.xyxx.z >= 0.0f.xxxx.z, _175.xyxx.w >= 0.0f.xxxx.w).xy;
    _263 = bool4(_269.x, _269.y, _263.z, _263.w);
    bool2 _276 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _175.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _175.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _175.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _175.xxxy.w).zw;
    _263 = bool4(_263.x, _263.y, _276.x, _276.y);
    _36.x = float(_263.x);
    _36.y = float(_263.y);
    _36.z = float(_263.z);
    _36.w = float(_263.w);
    _36.x = _36.z * _36.x;
    _36.x = _36.y * _36.x;
    _36.x = _36.w * _36.x;
    _43 = _175.xy;
    _43 = clamp(_43, 0.0f.xx, 1.0f.xx);
    _122 = vs_TEXCOORD1.w + 0.5f;
    _122 = floor(_122);
    _122 *= 0.5f;
    _328 = _122 >= (-_122);
    _333 = frac(abs(_122));
    _198.y = floor(_122);
    float _342;
    if (_328)
    {
        _342 = _333;
    }
    else
    {
        _342 = -_333;
    }
    _122 = _342;
    _198.x = _122 + _122;
    _43 += _198.xy;
    _43 *= 0.5f.xx;
    _361 = _MainTex.Sample(sampler_MainTex, _43).xyz;
    float3 _373 = _36.xxx * _361;
    _36 = float4(_373.x, _373.y, _373.z, _36.w);
    _376 = _36.zzz * _97_m3.xyz;
    _376 = (_36.yyy * _97_m2.xyz) + _376;
    _36.x = (vs_TEXCOORD1.x * (-_36.x)) + _36.x;
    float3 _411 = (_97_m1.xyz * _36.xxx) + _376;
    _36 = float4(_411.x, _411.y, _411.z, _36.w);
    _414.w = 0.0f;
    float3 _422 = vs_TEXCOORD1.yyx * float3(40.0f, 11.0f, 0.02500000037252902984619140625f);
    _414 = float4(_422.x, _422.y, _422.z, _414.w);
    _425 = _175.xy + (-_414.zw);
    float2 _436 = _175.xy + _414.zw;
    _175 = float3(_436.x, _436.y, _175.z);
    _439 = (_97_m0.yy * float2(13.0f, 7.30000019073486328125f)) + _414.xy;
    _439 = sin(_439);
    _122 = _439.y * _439.x;
    _122 = (_122 * 0.5f) + 0.5f;
    _122 *= _97_m8;
    _122 = ((-_122) * 0.5f) + 1.0f;
    _470 = bool4(_425.xyxy.x >= 0.0f.xxxx.x, _425.xyxy.y >= 0.0f.xxxx.y, _425.xyxy.z >= 0.0f.xxxx.z, _425.xyxy.w >= 0.0f.xxxx.w).xy;
    _439.x = float(_470.x);
    _439.y = float(_470.y);
    _483 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x >= _425.xyxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y >= _425.xyxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z >= _425.xyxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w >= _425.xyxx.w).xy;
    _425 = _425;
    _425 = clamp(_425, 0.0f.xx, 1.0f.xx);
    _425 = _198.xy + _425;
    _425 *= 0.5f.xx;
    _500 = _MainTex.Sample(sampler_MainTex, _425).x;
    _505.x = float(_483.x);
    _505.y = float(_483.y);
    _333 = _439.x * _505.x;
    _333 = _439.y * _333;
    _333 = _505.y * _333;
    _425.x = _333 * _500;
    _470 = bool4(_175.xyxy.x >= 0.0f.xxxx.x, _175.xyxy.y >= 0.0f.xxxx.y, _175.xyxy.z >= 0.0f.xxxx.z, _175.xyxy.w >= 0.0f.xxxx.w).xy;
    _439.x = float(_470.x);
    _439.y = float(_470.y);
    _483 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x >= _175.xyxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y >= _175.xyxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z >= _175.xyxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w >= _175.xyxx.w).xy;
    _175 = float3(_175.xy.x, _175.xy.y, _175.z);
    float2 _555 = clamp(_175.xy, 0.0f.xx, 1.0f.xx);
    _175 = float3(_555.x, _555.y, _175.z);
    float2 _562 = _198.xy + _175.xy;
    _175 = float3(_562.x, _562.y, _175.z);
    float2 _567 = _175.xy * 0.5f.xx;
    _175 = float3(_567.x, _567.y, _175.z);
    _570 = _MainTex.Sample(sampler_MainTex, _175.xy).x;
    _576.x = float(_483.x);
    _576.z = float(_483.y);
    _576.x *= _439.x;
    _576.x = _439.y * _576.x;
    _576.x = _576.z * _576.x;
    _603.x = (_570 * _576.x) + _425.x;
    _175.x = _576.x * _570;
    _603.x *= _97_m1.y;
    _603.y = _603.x * 0.25f;
    _628 = _97_m1.x;
    _603.x = _175.x * _628;
    float2 _640 = _603.xy * vs_TEXCOORD1.xx;
    _175 = float3(_640.x, _640.y, _175.z);
    float2 _647 = _175.xy * 0.89999997615814208984375f.xx;
    _198 = float3(_647.x, _647.y, _198.z);
    _198.z = 0.0f;
    float3 _654 = _36.xyz + _198;
    _36 = float4(_654.x, _654.y, _654.z, _36.w);
    _603.x = _425.x * 0.60000002384185791015625f;
    _662.y = _425.x * _97_m1.z;
    _662.x = _603.x * _97_m1.y;
    float2 _678 = _662 * vs_TEXCOORD1.xx;
    _175 = float3(_175.x, _678.x, _678.y);
    _175.x = vs_TEXCOORD1.x;
    float3 _689 = (_175 * float3(0.0f, 0.89999997615814208984375f, 0.89999997615814208984375f)) + _36.xyz;
    _36 = float4(_689.x, _689.y, _689.z, _36.w);
    _175.x = _97_m0.y * 18.0f;
    _175.x = floor(_175.x);
    _175.y = vs_TEXCOORD1.y * 31.0f;
    _175.x = dot(_175.xy, float2(127.09999847412109375f, 311.70001220703125f));
    _175.x = sin(_175.x);
    _175.x *= 43758.546875f;
    _175.x = frac(_175.x);
    _722 = _175.x >= 0.98500001430511474609375f;
    _175.x = _722 ? 0.449999988079071044921875f : 1.0f;
    _122 *= _175.x;
    float3 _739 = _122.xxx * _36.xyz;
    _36 = float4(_739.x, _739.y, _739.z, _36.w);
    _603 = _742.www * _742.xyz;
    _603 *= _97_m4.xxx;
    float3 _759 = _36.xyz * _603;
    _755 = float4(_759.x, _759.y, _759.z, _755.w);
    _755.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _742 = stage_input._742;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._755 = _755;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}