// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/GroundShock" {
Properties {

_Color ("Ring Colour", Color) = (0.75,0.85,1,1)

_CoreColor ("Flash Colour", Color) = (1,1,1,1)

_RingRadius ("Ring Radius", Range(0, 1)) = 0.4000000059604645

_RingWidth ("Ring Width", Range(0.005, 0.5)) = 0.07000000029802322

_CoreSize ("Flash Size", Range(0, 0.6)) = 0.12999999523162842

_CoreFade ("Flash Falloff", Range(0.01, 1)) = 0.1599999964237213

_Jitter ("Ring Raggedness", Range(0, 1)) = 0.3499999940395355

_Spokes ("Spoke Count", Range(0, 24)) = 9.0

_Intensity ("Intensity", Range(0, 8)) = 2.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
 Name "GroundShock"
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha One
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
static float2 vs_TEXCOORD0;
static float2 _86;
static float4 _88;
static float4 _89;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
    float4 _89 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 _88 : TEXCOORD1;
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
    vs_TEXCOORD0 = _86;
    _88 = _89;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    _89 = stage_input._89;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._88 = _88;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float4 _CoreColor;
float _RingRadius;
float _RingWidth;
float _CoreSize;
float _CoreFade;
float _Jitter;
float _Spokes;
float _Intensity;
#define _228_m0 _Color
#define _228_m1 _CoreColor
#define _228_m2 _RingRadius
#define _228_m3 _RingWidth
#define _228_m4 _CoreSize
#define _228_m5 _CoreFade
#define _228_m6 _Jitter
#define _228_m7 _Spokes
#define _228_m8 _Intensity



static float2 vs_TEXCOORD0;
static float4 _43;
static float4 _438;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 _438 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _43 : SV_Target0;
};

static float3 _9;
static float _24;
static bool _34;
static float _47;
static float4 _59;
static float _80;
static bool _110;
static bool _132;
static bool _159;
static bool _166;
static float3 _187;
static float3 _451;

void frag_inner()
{
    float2 _20 = (vs_TEXCOORD0.yx * 2.0f.xx) + (-1.0f).xx;
    _9 = float3(_20.x, _20.y, _9.z);
    _24 = dot(_9.xy, _9.xy);
    _24 = sqrt(_24);
    _34 = 1.0f < _24;
    if (_34)
    {
        _43 = 0.0f.xxxx;
        return;
    }
    _47 = min(abs(_9.y), abs(_9.x));
    _59.x = max(abs(_9.y), abs(_9.x));
    _59.x = 1.0f / _59.x;
    _47 *= _59.x;
    _59.x = _47 * _47;
    _80 = (_59.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _80 = (_59.x * _80) + 0.1801410019397735595703125f;
    _80 = (_59.x * _80) + (-0.33029949665069580078125f);
    _59.x = (_59.x * _80) + 0.999866008758544921875f;
    _80 = _47 * _59.x;
    _110 = abs(_9.y) < abs(_9.x);
    _80 = (_80 * (-2.0f)) + 1.57079637050628662109375f;
    _80 = _110 ? _80 : 0.0f;
    _47 = (_47 * _59.x) + _80;
    _132 = _9.y < (-_9.y);
    _59.x = _132 ? (-3.1415927410125732421875f) : 0.0f;
    _47 += _59.x;
    _59.x = min(_9.y, _9.x);
    _9.x = max(_9.y, _9.x);
    _159 = _59.x < (-_59.x);
    _166 = _9.x >= (-_9.x);
    _166 = _166 && _159;
    float _178;
    if (_166)
    {
        _178 = -_47;
    }
    else
    {
        _178 = _47;
    }
    _9.x = _178;
    _187.x = _9.x * 3.0f;
    _187.x = floor(_187.x);
    _187.x += 1.0f;
    _187.x *= 12.98980045318603515625f;
    _187.x = sin(_187.x);
    _187.x *= 43758.546875f;
    _187.x = frac(_187.x);
    _187.x += (-0.5f);
    _187.x *= _228_m6;
    _187.x = (_187.x * 0.699999988079071044921875f) + 1.0f;
    _47 = _187.x * _228_m2;
    _187.x = ((-_228_m2) * _187.x) + _24;
    _59.x = 1.0f / _228_m3;
    _187.x = abs(_187.x) * _59.x;
    _187.x = clamp(_187.x, 0.0f, 1.0f);
    _59.x = (_187.x * (-2.0f)) + 3.0f;
    _187.x *= _187.x;
    _187.x = ((-_59.x) * _187.x) + 1.0f;
    _132 = 0.5f < _228_m7;
    _80 = round(_228_m7);
    _9.x *= _80;
    _9.x = sin(_9.x);
    _9.x = abs(_9.x) * abs(_9.x);
    _9.x *= _9.x;
    _9.x *= _9.x;
    _47 *= 1.35000002384185791015625f;
    _47 = max(_47, 9.9999997473787516355514526367188e-05f);
    _47 = _24 / _47;
    _47 = (-_47) + 1.0f;
    _47 = max(_47, 0.0f);
    _9.x = _47 * _9.x;
    _9.x *= 0.5f;
    float _353;
    if (_132)
    {
        _353 = _9.x;
    }
    else
    {
        _353 = 0.0f;
    }
    _9.x = _353;
    _24 += (-_228_m4);
    _24 = max(_24, 0.0f);
    _47 = max(_228_m5, 9.9999997473787516355514526367188e-05f);
    _24 = (-_24) / _47;
    _24 *= 1.44269502162933349609375f;
    _24 = exp2(_24);
    _9.x += _187.x;
    _9.x = _24 + _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _187.x *= 0.3499999940395355224609375f;
    _187.x = (_24 * 1.5f) + _187.x;
    _187.x = clamp(_187.x, 0.0f, 1.0f);
    float3 _423 = (-_228_m0.xyz) + _228_m1.xyz;
    _59 = float4(_423.x, _423.y, _423.z, _59.w);
    _187 = (_187.xxx * _59.xyz) + _228_m0.xyz;
    _9.x *= _438.w;
    _59.w = _9.x * _228_m0.w;
    _451 = _187 * _438.xyz;
    _9 = _451 * float3(float3(_228_m8, _228_m8, _228_m8));
    float3 _473 = _59.www * _9;
    _59 = float4(_473.x, _473.y, _473.z, _59.w);
    _43 = _59;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _438 = stage_input._438;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._43 = _43;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}