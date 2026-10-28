// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Fnaf/Puddle" {
Properties {

_Color ("Wet (alpha = opacity)", Color) = (0.015,0.04,0.035,0.42)

_GlowColor ("Glow", Color) = (0.25,0.9,0.7,1)

_Glow ("Glow Level", Range(0, 1)) = 0.019999999552965164

_Reflect ("Sheen", Range(0, 2)) = 0.550000011920929

_Spread ("Spread (driven at runtime)", Range(0, 1)) = 0.0

_Seed ("Seed", Float) = 0.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-20" "RenderType" = "Transparent" }
 Pass {
Cull Back
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-20" "RenderType" = "Transparent" }
 ZWrite Off
 Offset -1.0, -1.0
   Blend SrcAlpha OneMinusSrcAlpha
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
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _138;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _138 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _43;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _43 = _9 + _20_m1[3];
    vs_TEXCOORD1 = (_20_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _43.yyyy * _20_m2[1];
    _9 = (_20_m2[0] * _43.xxxx) + _9;
    _9 = (_20_m2[2] * _43.zzzz) + _9;
    _9 = (_20_m2[3] * _43.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    vs_TEXCOORD0 = (_138 * 2.0f.xx) + (-1.0f).xx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _138 = stage_input._138;
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
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _Color;
float4 _GlowColor;
float _Glow;
float _Reflect;
float _Spread;
float _Seed;
#define _234_m0 _WorldSpaceCameraPos
#define _234_m1 unity_FogColor
#define _234_m2 unity_SpecCube0_HDR
#define _234_m3 _Color
#define _234_m4 _GlowColor
#define _234_m5 _Glow
#define _234_m6 _Reflect
#define _234_m7 _Spread
#define _234_m8 _Seed


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _620;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _620 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _53;
static bool _100;
static bool _128;
static bool _163;
static float _197;
static float _246;
static float4 _515;
static float3 _578;
static float3 _583;

void frag_inner()
{
    _9.x = max(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.y));
    _9.x = 1.0f / _9.x;
    _31.x = min(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.y));
    _9.x *= _31.x;
    _31.x = _9.x * _9.x;
    _53.x = (_31.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _53.x = (_31.x * _53.x) + 0.1801410019397735595703125f;
    _53.x = (_31.x * _53.x) + (-0.33029949665069580078125f);
    _31.x = (_31.x * _53.x) + 0.999866008758544921875f;
    _53.x = _31.x * _9.x;
    _53.x = (_53.x * (-2.0f)) + 1.57079637050628662109375f;
    _100 = abs(vs_TEXCOORD0.x) < abs(vs_TEXCOORD0.y);
    float _110;
    if (_100)
    {
        _110 = _53.x;
    }
    else
    {
        _110 = 0.0f;
    }
    _53.x = _110;
    _9.x = (_9.x * _31.x) + _53.x;
    _128 = vs_TEXCOORD0.x < (-vs_TEXCOORD0.x);
    _31.x = _128 ? (-3.1415927410125732421875f) : 0.0f;
    _9.x = _31.x + _9.x;
    _31.x = min(vs_TEXCOORD0.x, vs_TEXCOORD0.y);
    _128 = _31.x < (-_31.x);
    _53.x = max(vs_TEXCOORD0.x, vs_TEXCOORD0.y);
    _163 = _53.x >= (-_53.x);
    _128 = _163 && _128;
    float _174;
    if (_128)
    {
        _174 = -_9.x;
    }
    else
    {
        _174 = _9.x;
    }
    _9.x = _174;
    _9.x = (_9.x * 0.15915493667125701904296875f) + 0.5f;
    _9.x *= 6.283185482025146484375f;
    _197 = cos(_9.x);
    _9.x = sin(_9.x);
    _9 = _9.xxx * float3(1.7000000476837158203125f, 4.30000019073486328125f, 9.8999996185302734375f);
    _31.x = (_197 * 5.099999904632568359375f) + (-_9.y);
    float2 _228 = (_197.xx * float2(2.2999999523162841796875f, 11.69999980926513671875f)) + _9.xz;
    _9 = float3(_228.x, _9.y, _228.y);
    _31.x = (_234_m8 * 2.099999904632568359375f) + _31.x;
    _246 = frac(_31.x);
    _31.x = floor(_31.x);
    _197 = _246 * _246;
    _246 = ((-_246) * 2.0f) + 3.0f;
    _246 *= _197;
    _197 = _31.x + 1.0f;
    _31.x *= 91.6999969482421875f;
    _31.x = sin(_31.x);
    _31.x *= 47453.53125f;
    _31.x = frac(_31.x);
    _197 *= 91.6999969482421875f;
    _197 = sin(_197);
    _197 *= 47453.53125f;
    _197 = frac(_197);
    _197 = (-_31.x) + _197;
    _9.y = (_246 * _197) + _31.x;
    _9.x += _234_m8;
    _53.x = (_234_m8 * 4.69999980926513671875f) + _9.z;
    _246 = frac(_9.x);
    _9.x = floor(_9.x);
    _197 = _246 * _246;
    _246 = ((-_246) * 2.0f) + 3.0f;
    _246 *= _197;
    _197 = _9.x + 1.0f;
    float2 _346 = _9.xy * float2(91.6999969482421875f, 0.300000011920928955078125f);
    _9 = float3(_346.x, _346.y, _9.z);
    _9.x = sin(_9.x);
    _9.x *= 47453.53125f;
    _9.x = frac(_9.x);
    _197 *= 91.6999969482421875f;
    _197 = sin(_197);
    _197 *= 47453.53125f;
    _197 = frac(_197);
    _197 = (-_9.x) + _197;
    _9.x = (_246 * _197) + _9.x;
    _9.x = (_9.x * 0.5f) + _9.y;
    _31.x = frac(_53.x);
    _53.x = floor(_53.x);
    _246 = _31.x * _31.x;
    _31.x = ((-_31.x) * 2.0f) + 3.0f;
    _31.x *= _246;
    _53.y = _53.x + 1.0f;
    _53 *= 91.6999969482421875f.xx;
    _53 = sin(_53);
    _53 *= 47453.53125f.xx;
    _53 = frac(_53);
    _246 = (-_53.x) + _53.y;
    _31.x = (_31.x * _246) + _53.x;
    _9.x = (_31.x * 0.20000000298023223876953125f) + _9.x;
    _9.x = (_9.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _31.x = _9.x * _234_m7;
    _31.x = max(_31.x, 0.0500000007450580596923828125f);
    _53.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _53.x = sqrt(_53.x);
    _31.x = _53.x / _31.x;
    _9.x = (_234_m7 * _9.x) + (-_53.x);
    _9.x *= 9.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31.x = (-_31.x) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x = (_31.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _515.x = (_9.x * _31.x) + (-0.00999999977648258209228515625f);
    _9.x = _31.x * _9.x;
    _128 = _515.x < 0.0f;
    if ((int(_128) * (-1)) != 0)
    {
        discard;
    }
    _31 = (-vs_TEXCOORD1) + _234_m0;
    _197 = dot(_31, _31);
    _197 = rsqrt(_197);
    _31 *= _197.xxx;
    _197 = _31.y;
    _197 = clamp(_197, 0.0f, 1.0f);
    _31 = (_31.yyy * float3(0.0f, 2.0f, 0.0f)) + (-_31);
    _515 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _31, 0.5f);
    _578.x = (-_197) + 1.0f;
    _583.x = _578.x * _578.x;
    _583.x *= _583.x;
    _578.x = _583.x * _578.x;
    _578.x = (_578.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _583.x = _578.x * 0.5f;
    _583.x = _9.x * _583.x;
    _620.w = (_234_m3.w * _9.x) + _583.x;
    _620.w = clamp(_620.w, 0.0f, 1.0f);
    _583.x = _515.w + (-1.0f);
    _583.x = (_234_m2.w * _583.x) + 1.0f;
    _583.x = log2(_583.x);
    _583.x *= _234_m2.y;
    _583.x = exp2(_583.x);
    _583.x *= _234_m2.x;
    _583 = _515.xyz * _583.xxx;
    _578 = _578.xxx * _583;
    _578 = (_578 * float3(float3(_234_m6, _234_m6, _234_m6))) + _234_m3.xyz;
    _578 = (_234_m4.xyz * _234_m5.xxx) + _578;
    _9 = _578 + (-_234_m1.xyz);
    _246 = vs_TEXCOORD2;
    _246 = clamp(_246, 0.0f, 1.0f);
    _9 = (_246.xxx * _9) + _234_m1.xyz;
    _620 = float4(_9.x, _9.y, _9.z, _620.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._620 = _620;
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
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _144;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _144 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _43;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _43 = _9 + _20_m1[3];
    vs_TEXCOORD1 = (_20_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _43.yyyy * _20_m2[1];
    _9 = (_20_m2[0] * _43.xxxx) + _9;
    _9 = (_20_m2[2] * _43.zzzz) + _9;
    _9 = (_20_m2[3] * _43.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    vs_TEXCOORD0 = (_144 * 2.0f.xx) + (-1.0f).xx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _144 = stage_input._144;
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
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _Color;
float4 _GlowColor;
float _Glow;
float _Reflect;
float _Spread;
float _Seed;
#define _234_m0 _WorldSpaceCameraPos
#define _234_m1 unity_FogColor
#define _234_m2 unity_SpecCube0_HDR
#define _234_m3 _Color
#define _234_m4 _GlowColor
#define _234_m5 _Glow
#define _234_m6 _Reflect
#define _234_m7 _Spread
#define _234_m8 _Seed


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _620;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _620 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _53;
static bool _100;
static bool _128;
static bool _163;
static float _197;
static float _246;
static float4 _515;
static float3 _578;
static float3 _583;

void frag_inner()
{
    _9.x = max(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.y));
    _9.x = 1.0f / _9.x;
    _31.x = min(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.y));
    _9.x *= _31.x;
    _31.x = _9.x * _9.x;
    _53.x = (_31.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _53.x = (_31.x * _53.x) + 0.1801410019397735595703125f;
    _53.x = (_31.x * _53.x) + (-0.33029949665069580078125f);
    _31.x = (_31.x * _53.x) + 0.999866008758544921875f;
    _53.x = _31.x * _9.x;
    _53.x = (_53.x * (-2.0f)) + 1.57079637050628662109375f;
    _100 = abs(vs_TEXCOORD0.x) < abs(vs_TEXCOORD0.y);
    float _110;
    if (_100)
    {
        _110 = _53.x;
    }
    else
    {
        _110 = 0.0f;
    }
    _53.x = _110;
    _9.x = (_9.x * _31.x) + _53.x;
    _128 = vs_TEXCOORD0.x < (-vs_TEXCOORD0.x);
    _31.x = _128 ? (-3.1415927410125732421875f) : 0.0f;
    _9.x = _31.x + _9.x;
    _31.x = min(vs_TEXCOORD0.x, vs_TEXCOORD0.y);
    _128 = _31.x < (-_31.x);
    _53.x = max(vs_TEXCOORD0.x, vs_TEXCOORD0.y);
    _163 = _53.x >= (-_53.x);
    _128 = _163 && _128;
    float _174;
    if (_128)
    {
        _174 = -_9.x;
    }
    else
    {
        _174 = _9.x;
    }
    _9.x = _174;
    _9.x = (_9.x * 0.15915493667125701904296875f) + 0.5f;
    _9.x *= 6.283185482025146484375f;
    _197 = cos(_9.x);
    _9.x = sin(_9.x);
    _9 = _9.xxx * float3(1.7000000476837158203125f, 4.30000019073486328125f, 9.8999996185302734375f);
    _31.x = (_197 * 5.099999904632568359375f) + (-_9.y);
    float2 _228 = (_197.xx * float2(2.2999999523162841796875f, 11.69999980926513671875f)) + _9.xz;
    _9 = float3(_228.x, _9.y, _228.y);
    _31.x = (_234_m8 * 2.099999904632568359375f) + _31.x;
    _246 = frac(_31.x);
    _31.x = floor(_31.x);
    _197 = _246 * _246;
    _246 = ((-_246) * 2.0f) + 3.0f;
    _246 *= _197;
    _197 = _31.x + 1.0f;
    _31.x *= 91.6999969482421875f;
    _31.x = sin(_31.x);
    _31.x *= 47453.53125f;
    _31.x = frac(_31.x);
    _197 *= 91.6999969482421875f;
    _197 = sin(_197);
    _197 *= 47453.53125f;
    _197 = frac(_197);
    _197 = (-_31.x) + _197;
    _9.y = (_246 * _197) + _31.x;
    _9.x += _234_m8;
    _53.x = (_234_m8 * 4.69999980926513671875f) + _9.z;
    _246 = frac(_9.x);
    _9.x = floor(_9.x);
    _197 = _246 * _246;
    _246 = ((-_246) * 2.0f) + 3.0f;
    _246 *= _197;
    _197 = _9.x + 1.0f;
    float2 _346 = _9.xy * float2(91.6999969482421875f, 0.300000011920928955078125f);
    _9 = float3(_346.x, _346.y, _9.z);
    _9.x = sin(_9.x);
    _9.x *= 47453.53125f;
    _9.x = frac(_9.x);
    _197 *= 91.6999969482421875f;
    _197 = sin(_197);
    _197 *= 47453.53125f;
    _197 = frac(_197);
    _197 = (-_9.x) + _197;
    _9.x = (_246 * _197) + _9.x;
    _9.x = (_9.x * 0.5f) + _9.y;
    _31.x = frac(_53.x);
    _53.x = floor(_53.x);
    _246 = _31.x * _31.x;
    _31.x = ((-_31.x) * 2.0f) + 3.0f;
    _31.x *= _246;
    _53.y = _53.x + 1.0f;
    _53 *= 91.6999969482421875f.xx;
    _53 = sin(_53);
    _53 *= 47453.53125f.xx;
    _53 = frac(_53);
    _246 = (-_53.x) + _53.y;
    _31.x = (_31.x * _246) + _53.x;
    _9.x = (_31.x * 0.20000000298023223876953125f) + _9.x;
    _9.x = (_9.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _31.x = _9.x * _234_m7;
    _31.x = max(_31.x, 0.0500000007450580596923828125f);
    _53.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _53.x = sqrt(_53.x);
    _31.x = _53.x / _31.x;
    _9.x = (_234_m7 * _9.x) + (-_53.x);
    _9.x *= 9.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31.x = (-_31.x) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x = (_31.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _515.x = (_9.x * _31.x) + (-0.00999999977648258209228515625f);
    _9.x = _31.x * _9.x;
    _128 = _515.x < 0.0f;
    if ((int(_128) * (-1)) != 0)
    {
        discard;
    }
    _31 = (-vs_TEXCOORD1) + _234_m0;
    _197 = dot(_31, _31);
    _197 = rsqrt(_197);
    _31 *= _197.xxx;
    _197 = _31.y;
    _197 = clamp(_197, 0.0f, 1.0f);
    _31 = (_31.yyy * float3(0.0f, 2.0f, 0.0f)) + (-_31);
    _515 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _31, 0.5f);
    _578.x = (-_197) + 1.0f;
    _583.x = _578.x * _578.x;
    _583.x *= _583.x;
    _578.x = _583.x * _578.x;
    _578.x = (_578.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _583.x = _578.x * 0.5f;
    _583.x = _9.x * _583.x;
    _620.w = (_234_m3.w * _9.x) + _583.x;
    _620.w = clamp(_620.w, 0.0f, 1.0f);
    _583.x = _515.w + (-1.0f);
    _583.x = (_234_m2.w * _583.x) + 1.0f;
    _583.x = log2(_583.x);
    _583.x *= _234_m2.y;
    _583.x = exp2(_583.x);
    _583.x *= _234_m2.x;
    _583 = _515.xyz * _583.xxx;
    _578 = _578.xxx * _583;
    _578 = (_578 * float3(float3(_234_m6, _234_m6, _234_m6))) + _234_m3.xyz;
    _578 = (_234_m4.xyz * _234_m5.xxx) + _578;
    _9 = _578 + (-_234_m1.xyz);
    _246 = vs_TEXCOORD2;
    _246 = clamp(_246, 0.0f, 1.0f);
    _9 = (_246.xxx * _9) + _234_m1.xyz;
    _620 = float4(_9.x, _9.y, _9.z, _620.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._620 = _620;
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
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _137;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _137 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _43;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _43 = _9 + _20_m1[3];
    vs_TEXCOORD1 = (_20_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _43.yyyy * _20_m2[1];
    _9 = (_20_m2[0] * _43.xxxx) + _9;
    _9 = (_20_m2[2] * _43.zzzz) + _9;
    _9 = (_20_m2[3] * _43.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _20_m3.z) + _20_m3.w;
    vs_TEXCOORD0 = (_137 * 2.0f.xx) + (-1.0f).xx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _137 = stage_input._137;
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
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 unity_SpecCube0_HDR;
float4 _Color;
float4 _GlowColor;
float _Glow;
float _Reflect;
float _Spread;
float _Seed;
#define _234_m0 _WorldSpaceCameraPos
#define _234_m1 unity_FogColor
#define _234_m2 unity_SpecCube0_HDR
#define _234_m3 _Color
#define _234_m4 _GlowColor
#define _234_m5 _Glow
#define _234_m6 _Reflect
#define _234_m7 _Spread
#define _234_m8 _Seed


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _620;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _620 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _53;
static bool _100;
static bool _128;
static bool _163;
static float _197;
static float _246;
static float4 _515;
static float3 _578;
static float3 _583;

void frag_inner()
{
    _9.x = max(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.y));
    _9.x = 1.0f / _9.x;
    _31.x = min(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.y));
    _9.x *= _31.x;
    _31.x = _9.x * _9.x;
    _53.x = (_31.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _53.x = (_31.x * _53.x) + 0.1801410019397735595703125f;
    _53.x = (_31.x * _53.x) + (-0.33029949665069580078125f);
    _31.x = (_31.x * _53.x) + 0.999866008758544921875f;
    _53.x = _31.x * _9.x;
    _53.x = (_53.x * (-2.0f)) + 1.57079637050628662109375f;
    _100 = abs(vs_TEXCOORD0.x) < abs(vs_TEXCOORD0.y);
    float _110;
    if (_100)
    {
        _110 = _53.x;
    }
    else
    {
        _110 = 0.0f;
    }
    _53.x = _110;
    _9.x = (_9.x * _31.x) + _53.x;
    _128 = vs_TEXCOORD0.x < (-vs_TEXCOORD0.x);
    _31.x = _128 ? (-3.1415927410125732421875f) : 0.0f;
    _9.x = _31.x + _9.x;
    _31.x = min(vs_TEXCOORD0.x, vs_TEXCOORD0.y);
    _128 = _31.x < (-_31.x);
    _53.x = max(vs_TEXCOORD0.x, vs_TEXCOORD0.y);
    _163 = _53.x >= (-_53.x);
    _128 = _163 && _128;
    float _174;
    if (_128)
    {
        _174 = -_9.x;
    }
    else
    {
        _174 = _9.x;
    }
    _9.x = _174;
    _9.x = (_9.x * 0.15915493667125701904296875f) + 0.5f;
    _9.x *= 6.283185482025146484375f;
    _197 = cos(_9.x);
    _9.x = sin(_9.x);
    _9 = _9.xxx * float3(1.7000000476837158203125f, 4.30000019073486328125f, 9.8999996185302734375f);
    _31.x = (_197 * 5.099999904632568359375f) + (-_9.y);
    float2 _228 = (_197.xx * float2(2.2999999523162841796875f, 11.69999980926513671875f)) + _9.xz;
    _9 = float3(_228.x, _9.y, _228.y);
    _31.x = (_234_m8 * 2.099999904632568359375f) + _31.x;
    _246 = frac(_31.x);
    _31.x = floor(_31.x);
    _197 = _246 * _246;
    _246 = ((-_246) * 2.0f) + 3.0f;
    _246 *= _197;
    _197 = _31.x + 1.0f;
    _31.x *= 91.6999969482421875f;
    _31.x = sin(_31.x);
    _31.x *= 47453.53125f;
    _31.x = frac(_31.x);
    _197 *= 91.6999969482421875f;
    _197 = sin(_197);
    _197 *= 47453.53125f;
    _197 = frac(_197);
    _197 = (-_31.x) + _197;
    _9.y = (_246 * _197) + _31.x;
    _9.x += _234_m8;
    _53.x = (_234_m8 * 4.69999980926513671875f) + _9.z;
    _246 = frac(_9.x);
    _9.x = floor(_9.x);
    _197 = _246 * _246;
    _246 = ((-_246) * 2.0f) + 3.0f;
    _246 *= _197;
    _197 = _9.x + 1.0f;
    float2 _346 = _9.xy * float2(91.6999969482421875f, 0.300000011920928955078125f);
    _9 = float3(_346.x, _346.y, _9.z);
    _9.x = sin(_9.x);
    _9.x *= 47453.53125f;
    _9.x = frac(_9.x);
    _197 *= 91.6999969482421875f;
    _197 = sin(_197);
    _197 *= 47453.53125f;
    _197 = frac(_197);
    _197 = (-_9.x) + _197;
    _9.x = (_246 * _197) + _9.x;
    _9.x = (_9.x * 0.5f) + _9.y;
    _31.x = frac(_53.x);
    _53.x = floor(_53.x);
    _246 = _31.x * _31.x;
    _31.x = ((-_31.x) * 2.0f) + 3.0f;
    _31.x *= _246;
    _53.y = _53.x + 1.0f;
    _53 *= 91.6999969482421875f.xx;
    _53 = sin(_53);
    _53 *= 47453.53125f.xx;
    _53 = frac(_53);
    _246 = (-_53.x) + _53.y;
    _31.x = (_31.x * _246) + _53.x;
    _9.x = (_31.x * 0.20000000298023223876953125f) + _9.x;
    _9.x = (_9.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _31.x = _9.x * _234_m7;
    _31.x = max(_31.x, 0.0500000007450580596923828125f);
    _53.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _53.x = sqrt(_53.x);
    _31.x = _53.x / _31.x;
    _9.x = (_234_m7 * _9.x) + (-_53.x);
    _9.x *= 9.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31.x = (-_31.x) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x = (_31.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _515.x = (_9.x * _31.x) + (-0.00999999977648258209228515625f);
    _9.x = _31.x * _9.x;
    _128 = _515.x < 0.0f;
    if ((int(_128) * (-1)) != 0)
    {
        discard;
    }
    _31 = (-vs_TEXCOORD1) + _234_m0;
    _197 = dot(_31, _31);
    _197 = rsqrt(_197);
    _31 *= _197.xxx;
    _197 = _31.y;
    _197 = clamp(_197, 0.0f, 1.0f);
    _31 = (_31.yyy * float3(0.0f, 2.0f, 0.0f)) + (-_31);
    _515 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _31, 0.5f);
    _578.x = (-_197) + 1.0f;
    _583.x = _578.x * _578.x;
    _583.x *= _583.x;
    _578.x = _583.x * _578.x;
    _578.x = (_578.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _583.x = _578.x * 0.5f;
    _583.x = _9.x * _583.x;
    _620.w = (_234_m3.w * _9.x) + _583.x;
    _620.w = clamp(_620.w, 0.0f, 1.0f);
    _583.x = _515.w + (-1.0f);
    _583.x = (_234_m2.w * _583.x) + 1.0f;
    _583.x = log2(_583.x);
    _583.x *= _234_m2.y;
    _583.x = exp2(_583.x);
    _583.x *= _234_m2.x;
    _583 = _515.xyz * _583.xxx;
    _578 = _578.xxx * _583;
    _578 = (_578 * float3(float3(_234_m6, _234_m6, _234_m6))) + _234_m3.xyz;
    _578 = (_234_m4.xyz * _234_m5.xxx) + _578;
    _9 = _578 + (-_234_m1.xyz);
    _246 = vs_TEXCOORD2;
    _246 = clamp(_246, 0.0f, 1.0f);
    _9 = (_246.xxx * _9) + _234_m1.xyz;
    _620 = float4(_9.x, _9.y, _9.z, _620.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._620 = _620;
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
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _98;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _98 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
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
    vs_TEXCOORD1 = (_20_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _43.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _43.xxxx) + _9;
    _9 = (_20_m1[2] * _43.zzzz) + _9;
    gl_Position = (_20_m1[3] * _43.wwww) + _9;
    vs_TEXCOORD0 = (_98 * 2.0f.xx) + (-1.0f).xx;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _98 = stage_input._98;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_SpecCube0_HDR;
float4 _Color;
float4 _GlowColor;
float _Glow;
float _Reflect;
float _Spread;
float _Seed;
#define _234_m0 _WorldSpaceCameraPos
#define _234_m1 unity_SpecCube0_HDR
#define _234_m2 _Color
#define _234_m3 _GlowColor
#define _234_m4 _Glow
#define _234_m5 _Reflect
#define _234_m6 _Spread
#define _234_m7 _Seed


TextureCube<float4> unity_SpecCube0;
SamplerState samplerunity_SpecCube0;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _620;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _620 : SV_Target0;
};

static float3 _9;
static float3 _31;
static float2 _53;
static bool _100;
static bool _128;
static bool _163;
static float _197;
static float _246;
static float4 _515;
static float3 _578;
static float3 _583;

void frag_inner()
{
    _9.x = max(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.y));
    _9.x = 1.0f / _9.x;
    _31.x = min(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.y));
    _9.x *= _31.x;
    _31.x = _9.x * _9.x;
    _53.x = (_31.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _53.x = (_31.x * _53.x) + 0.1801410019397735595703125f;
    _53.x = (_31.x * _53.x) + (-0.33029949665069580078125f);
    _31.x = (_31.x * _53.x) + 0.999866008758544921875f;
    _53.x = _31.x * _9.x;
    _53.x = (_53.x * (-2.0f)) + 1.57079637050628662109375f;
    _100 = abs(vs_TEXCOORD0.x) < abs(vs_TEXCOORD0.y);
    float _110;
    if (_100)
    {
        _110 = _53.x;
    }
    else
    {
        _110 = 0.0f;
    }
    _53.x = _110;
    _9.x = (_9.x * _31.x) + _53.x;
    _128 = vs_TEXCOORD0.x < (-vs_TEXCOORD0.x);
    _31.x = _128 ? (-3.1415927410125732421875f) : 0.0f;
    _9.x = _31.x + _9.x;
    _31.x = min(vs_TEXCOORD0.x, vs_TEXCOORD0.y);
    _128 = _31.x < (-_31.x);
    _53.x = max(vs_TEXCOORD0.x, vs_TEXCOORD0.y);
    _163 = _53.x >= (-_53.x);
    _128 = _163 && _128;
    float _174;
    if (_128)
    {
        _174 = -_9.x;
    }
    else
    {
        _174 = _9.x;
    }
    _9.x = _174;
    _9.x = (_9.x * 0.15915493667125701904296875f) + 0.5f;
    _9.x *= 6.283185482025146484375f;
    _197 = cos(_9.x);
    _9.x = sin(_9.x);
    _9 = _9.xxx * float3(1.7000000476837158203125f, 4.30000019073486328125f, 9.8999996185302734375f);
    _31.x = (_197 * 5.099999904632568359375f) + (-_9.y);
    float2 _228 = (_197.xx * float2(2.2999999523162841796875f, 11.69999980926513671875f)) + _9.xz;
    _9 = float3(_228.x, _9.y, _228.y);
    _31.x = (_234_m7 * 2.099999904632568359375f) + _31.x;
    _246 = frac(_31.x);
    _31.x = floor(_31.x);
    _197 = _246 * _246;
    _246 = ((-_246) * 2.0f) + 3.0f;
    _246 *= _197;
    _197 = _31.x + 1.0f;
    _31.x *= 91.6999969482421875f;
    _31.x = sin(_31.x);
    _31.x *= 47453.53125f;
    _31.x = frac(_31.x);
    _197 *= 91.6999969482421875f;
    _197 = sin(_197);
    _197 *= 47453.53125f;
    _197 = frac(_197);
    _197 = (-_31.x) + _197;
    _9.y = (_246 * _197) + _31.x;
    _9.x += _234_m7;
    _53.x = (_234_m7 * 4.69999980926513671875f) + _9.z;
    _246 = frac(_9.x);
    _9.x = floor(_9.x);
    _197 = _246 * _246;
    _246 = ((-_246) * 2.0f) + 3.0f;
    _246 *= _197;
    _197 = _9.x + 1.0f;
    float2 _346 = _9.xy * float2(91.6999969482421875f, 0.300000011920928955078125f);
    _9 = float3(_346.x, _346.y, _9.z);
    _9.x = sin(_9.x);
    _9.x *= 47453.53125f;
    _9.x = frac(_9.x);
    _197 *= 91.6999969482421875f;
    _197 = sin(_197);
    _197 *= 47453.53125f;
    _197 = frac(_197);
    _197 = (-_9.x) + _197;
    _9.x = (_246 * _197) + _9.x;
    _9.x = (_9.x * 0.5f) + _9.y;
    _31.x = frac(_53.x);
    _53.x = floor(_53.x);
    _246 = _31.x * _31.x;
    _31.x = ((-_31.x) * 2.0f) + 3.0f;
    _31.x *= _246;
    _53.y = _53.x + 1.0f;
    _53 *= 91.6999969482421875f.xx;
    _53 = sin(_53);
    _53 *= 47453.53125f.xx;
    _53 = frac(_53);
    _246 = (-_53.x) + _53.y;
    _31.x = (_31.x * _246) + _53.x;
    _9.x = (_31.x * 0.20000000298023223876953125f) + _9.x;
    _9.x = (_9.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _31.x = _9.x * _234_m6;
    _31.x = max(_31.x, 0.0500000007450580596923828125f);
    _53.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _53.x = sqrt(_53.x);
    _31.x = _53.x / _31.x;
    _9.x = (_234_m6 * _9.x) + (-_53.x);
    _9.x *= 9.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31.x = (-_31.x) + 1.0f;
    _31.x = max(_31.x, 0.0f);
    _31.x = (_31.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _515.x = (_9.x * _31.x) + (-0.00999999977648258209228515625f);
    _9.x = _31.x * _9.x;
    _128 = _515.x < 0.0f;
    if ((int(_128) * (-1)) != 0)
    {
        discard;
    }
    _31 = (-vs_TEXCOORD1) + _234_m0;
    _197 = dot(_31, _31);
    _197 = rsqrt(_197);
    _31 *= _197.xxx;
    _197 = _31.y;
    _197 = clamp(_197, 0.0f, 1.0f);
    _31 = (_31.yyy * float3(0.0f, 2.0f, 0.0f)) + (-_31);
    _515 = unity_SpecCube0.SampleLevel(samplerunity_SpecCube0, _31, 0.5f);
    _578.x = (-_197) + 1.0f;
    _583.x = _578.x * _578.x;
    _583.x *= _583.x;
    _578.x = _583.x * _578.x;
    _578.x = (_578.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _583.x = _578.x * 0.5f;
    _583.x = _9.x * _583.x;
    _620.w = (_234_m2.w * _9.x) + _583.x;
    _620.w = clamp(_620.w, 0.0f, 1.0f);
    _583.x = _515.w + (-1.0f);
    _583.x = (_234_m1.w * _583.x) + 1.0f;
    _583.x = log2(_583.x);
    _583.x *= _234_m1.y;
    _583.x = exp2(_583.x);
    _583.x *= _234_m1.x;
    _583 = _515.xyz * _583.xxx;
    _578 = _578.xxx * _583;
    _578 = (_578 * float3(float3(_234_m5, _234_m5, _234_m5))) + _234_m2.xyz;
    float3 _707 = (_234_m3.xyz * _234_m4.xxx) + _578;
    _620 = float4(_707.x, _707.y, _707.z, _620.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._620 = _620;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}