// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmCyberWire" {
Properties {

_ColorA ("Gradient Start (blue)", Color) = (0.16,0.38,1,1)

_ColorB ("Gradient Middle (purple/pink)", Color) = (0.78,0.22,1,1)

_ColorC ("Gradient End (red)", Color) = (1,0.16,0.32,1)

_GradientOrigin ("Gradient Origin (world)", Vector) = (0,0,0,0)

_GradientAxis ("Gradient Axis (world, length = half span)", Vector) = (9,0,0,0)

_Tint ("Tint (A = how much it overrides the gradient)", Color) = (1,1,1,0)

_Flash ("Flash (0-1, white-hot boost)", Range(0, 1)) = 0.0

_Dim ("Dim (0-1, e.g. locked)", Range(0, 1)) = 0.0

_NearIntensity ("Intensity Near", Range(0, 3)) = 1.2000000476837158

_FarIntensity ("Intensity Far", Range(0, 3)) = 0.3499999940395355

_RevealRadius ("Reveal Radius (m)", Float) = 7.0

_RevealSoftness ("Reveal Softness (m)", Float) = 4.0

_CoreWhite ("Hot Core", Range(0, 1)) = 0.44999998807907104

_PulseIntensity ("Pulse Intensity", Range(0, 4)) = 1.2000000476837158

_PulseWidth ("Pulse Width (m)", Float) = 0.800000011920929

_PulseInterval ("Pulse Interval (s)", Float) = 5.0

_PulseMaxRadius ("Pulse Max Radius (m)", Float) = 30.0

}
SubShader {
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
ZWrite On
  Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Cull Off
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



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 _126;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _126 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _62;
static float _110;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    float3 _59 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _45.yyyy * _22_m3[1];
    _62 = (_22_m3[0] * _45.xxxx) + _62;
    _62 = (_22_m3[2] * _45.zzzz) + _62;
    gl_Position = (_22_m3[3] * _45.wwww) + _62;
    vs_TEXCOORD0 = _9.xyz;
    float3 _106 = (-_9.xyz) + _22_m0;
    _9 = float4(_106.x, _106.y, _106.z, _9.w);
    _110 = dot(_9.xyz, _9.xyz);
    _110 = rsqrt(_110);
    float3 _122 = _110.xxx * _9.xyz;
    _9 = float4(_122.x, _122.y, _122.z, _9.w);
    _45.x = dot(_126, _22_m2[0].xyz);
    _45.y = dot(_126, _22_m2[1].xyz);
    _45.z = dot(_126, _22_m2[2].xyz);
    _110 = dot(_45.xyz, _45.xyz);
    _110 = rsqrt(_110);
    float3 _158 = _110.xxx * _45.xyz;
    _45 = float4(_158.x, _158.y, _158.z, _45.w);
    _9.x = dot(_45.xyz, _9.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _126 = stage_input._126;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _BtmRevealCenter;
float4 _BtmPulseOrigin;
float _BtmPulseClock;
float4 _ColorA;
float4 _ColorB;
float4 _ColorC;
float4 _GradientOrigin;
float4 _GradientAxis;
float _RevealRadius;
float _RevealSoftness;
float _PulseIntensity;
float _PulseWidth;
float _PulseInterval;
float _PulseMaxRadius;
float _NearIntensity;
float _FarIntensity;
float _CoreWhite;
float4 _Tint;
float _Flash;
float _Dim;
#define _16_m0 _BtmRevealCenter
#define _16_m1 _BtmPulseOrigin
#define _16_m2 _BtmPulseClock
#define _16_m3 _ColorA
#define _16_m4 _ColorB
#define _16_m5 _ColorC
#define _16_m6 _GradientOrigin
#define _16_m7 _GradientAxis
#define _16_m8 _RevealRadius
#define _16_m9 _RevealSoftness
#define _16_m10 _PulseIntensity
#define _16_m11 _PulseWidth
#define _16_m12 _PulseInterval
#define _16_m13 _PulseMaxRadius
#define _16_m14 _NearIntensity
#define _16_m15 _FarIntensity
#define _16_m16 _CoreWhite
#define _16_m17 _Tint
#define _16_m18 _Flash
#define _16_m19 _Dim



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _388;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _388 : SV_Target0;
};

static float4 _9;
static float3 _41;
static float _143;
static float _169;
static float3 _228;
static float3 _286;
static bool _306;
static float _352;

void frag_inner()
{
    float3 _24 = vs_TEXCOORD0 + (-_16_m0.xyz);
    _9 = float4(_24.x, _24.y, _24.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _41.x = (-_16_m9) + _16_m8;
    _9.x = (-_41.x) + _9.x;
    _41.x = (-_41.x) + _16_m8;
    _41.x = 1.0f / _41.x;
    _9.x = _41.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _41.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _41.x;
    _9.x = (_16_m0.w * (-_9.x)) + 1.0f;
    _41.x = (-_16_m15) + _16_m14;
    _9.x = (_9.x * _41.x) + _16_m15;
    _41 = vs_TEXCOORD0 + (-_16_m1.xyz);
    _41.x = dot(_41, _41);
    _41.x = sqrt(_41.x);
    _143 = max(_16_m12, 0.100000001490116119384765625f);
    _143 = _16_m2 / _143;
    _41.y = frac(_143);
    _41.x = ((-_41.y) * _16_m13) + _41.x;
    _169 = max(_16_m11, 0.00999999977648258209228515625f);
    _41.x = abs(_41.x) / _169;
    _41.x = min(_41.x, 1.0f);
    float2 _190 = (-_41.xy) + 1.0f.xx;
    _41 = float3(_190.x, _190.y, _41.z);
    _41.x *= _41.x;
    _41.x = _41.y * _41.x;
    _9.x = (_41.x * _16_m10) + _9.x;
    _41.x = (_16_m19 * (-0.75f)) + 1.0f;
    _9.x = _41.x * _9.x;
    _228 = vs_TEXCOORD0 + (-_16_m6.xyz);
    _143 = dot(_228, _16_m7.xyz);
    _9.w = dot(_16_m7.xyz, _16_m7.xyz);
    float2 _254 = max(_9.xw, float2(1.0f, 9.9999997473787516355514526367188e-05f));
    _41 = float3(_254.x, _41.y, _254.y);
    _143 /= _41.z;
    _143 = max(_143, -1.0f);
    _143 = min(_143, 1.0f);
    _228 = _16_m3.xyz + (-_16_m4.xyz);
    _228 = ((-_143.xxx) * _228) + _16_m4.xyz;
    _286 = (-_16_m4.xyz) + _16_m5.xyz;
    _286 = (_143.xxx * _286) + _16_m4.xyz;
    _306 = _143 < 0.0f;
    float3 _311;
    if (_306)
    {
        _311 = _228;
    }
    else
    {
        _311 = _286;
    }
    _228 = _311;
    _286 = (-_228) + _16_m17.xyz;
    _228 = (_16_m17.www * _286) + _228;
    _41 = ((-_228) * _9.xxx) + _41.xxx;
    _228 = _9.xxx * _228;
    _9.x = vs_TEXCOORD1 * _16_m16;
    _352 = (-_16_m19) + 1.0f;
    _9.x *= _352;
    float3 _367 = (_9.xxx * _41) + _228;
    _9 = float4(_367.x, _367.y, _367.z, _9.w);
    _228 = (-_9.xyz) + 1.5f.xxx;
    float3 _384 = (_16_m18.xxx * _228) + _9.xyz;
    _9 = float4(_384.x, _384.y, _384.z, _9.w);
    _388 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _388.w);
    _388.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._388 = _388;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}