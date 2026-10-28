// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmFloorLane" {
Properties {

_Color ("Lane Color", Color) = (0.72,0.86,1,1)

_ChannelTint ("Channel Darkness", Range(0, 0.5)) = 0.10000000149011612

_HalfWidth ("Half Width (m)", Float) = 0.10000000149011612

_RailWidth ("Rail Width (0-1 of half)", Range(0.02, 0.4)) = 0.11999999731779099

_ChevronSpacing ("Chevron Spacing (m)", Float) = 0.44999998807907104

_ChevronSpeed ("Chevron Speed (m/s)", Float) = 0.6000000238418579

_ChevronSlant ("Chevron Slant", Range(0, 1)) = 0.44999998807907104

_ChevronWidth ("Chevron Width (0-1 of spacing)", Range(0.05, 0.5)) = 0.2199999988079071

_PacketSpacing ("Bright Packet Spacing (m)", Float) = 6.0

_PacketSpeed ("Bright Packet Speed (m/s)", Float) = 2.200000047683716

}
SubShader {
 Tags { "QUEUE" = "Geometry+1" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "QUEUE" = "Geometry+1" "RenderType" = "Opaque" }
 Offset -1.0, -1.0
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
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _127;
static float2 _137;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _127 : TEXCOORD0;
    float2 _137 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
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
    vs_TEXCOORD1 = exp2(-_9.x);
    float2 _134 = (_127 * float2(1.0f, 2.0f)) + float2(0.0f, -1.0f);
    vs_TEXCOORD0 = float3(_134.x, _134.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = _137.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _127 = stage_input._127;
    _137 = stage_input._137;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 unity_FogColor;
float4 _Color;
float _ChannelTint;
float _HalfWidth;
float _RailWidth;
float _ChevronSpacing;
float _ChevronSpeed;
float _ChevronSlant;
float _ChevronWidth;
float _PacketSpacing;
float _PacketSpeed;
#define _30_m0 _Time
#define _30_m1 unity_FogColor
#define _30_m2 _Color
#define _30_m3 _ChannelTint
#define _30_m4 _HalfWidth
#define _30_m5 _RailWidth
#define _30_m6 _ChevronSpacing
#define _30_m7 _ChevronSpeed
#define _30_m8 _ChevronSlant
#define _30_m9 _ChevronWidth
#define _30_m10 _PacketSpacing
#define _30_m11 _PacketSpeed



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _535;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _535 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _54;
static float _80;
static float _84;
static bool _123;
static float3 _210;
static float3 _378;
static float _394;
static float _428;
static float3 _478;
static float _521;

void frag_inner()
{
    _9.x = min(vs_TEXCOORD0.z, vs_TEXCOORD0.x);
    _23.x = (-_9.x) + _30_m4;
    _23.x = max(_23.x, 0.0f);
    _23.x /= _30_m4;
    _9.x = abs(vs_TEXCOORD0.y);
    _54.x = _9.x * _9.x;
    _54.x = (_23.x * _23.x) + _54.x;
    _23.x = max(_23.x, _9.x);
    _54.x = sqrt(_54.x);
    _80 = ddx_coarse(_54.x);
    _84 = ddy_coarse(_54.x);
    _54.x = (-_54.x) + 1.0f;
    _80 = abs(_84) + abs(_80);
    _80 = max(_80, 9.9999997473787516355514526367188e-05f);
    _54.x /= _80;
    _54.x += 0.5f;
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x += (-0.0199999995529651641845703125f);
    _123 = _54.x < 0.0f;
    if ((int(_123) * (-1)) != 0)
    {
        discard;
    }
    _54.x = ddx_coarse(_9.x);
    _80 = ddy_coarse(_9.x);
    _54.x = abs(_80) + abs(_54.x);
    _54.x = max(_54.x, 9.9999997473787516355514526367188e-05f);
    _80 = (-_9.x) + 0.62000000476837158203125f;
    _84 = _9.x * _30_m8;
    _84 *= _30_m4;
    _54.x = _80 / _54.x;
    _9.x = ((-_30_m0.y) * _30_m7) + vs_TEXCOORD0.x;
    _9.x = (_84 * 4.0f) + _9.x;
    _9.x /= _30_m6;
    _9.x = frac(_9.x);
    _80 = ddx_coarse(_9.x);
    _84 = ddy_coarse(_9.x);
    _210.x = (-_9.x) + _30_m9;
    _80 = abs(_84) + abs(_80);
    _80 = max(_80, 9.9999997473787516355514526367188e-05f);
    _54.y = _210.x / _80;
    float2 _235 = _54.xy + 0.5f.xx;
    _54 = float3(_235.x, _235.y, _54.z);
    float2 _242 = clamp(_54.xy, 0.0f.xx, 1.0f.xx);
    _54 = float3(_242.x, _242.y, _54.z);
    _54.x *= _54.y;
    float2 _255 = vs_TEXCOORD0.xz * 1.66666662693023681640625f.xx;
    _9 = float3(_255.x, _255.y, _9.z);
    float2 _262 = clamp(_9.xy, 0.0f.xx, 1.0f.xx);
    _9 = float3(_262.x, _262.y, _9.z);
    _9.x = _9.y * _9.x;
    _80 = ((-_54.x) * _9.x) + 1.0f;
    _9.x *= _54.x;
    _54.x = ddx_coarse(_23.x);
    _84 = ddy_coarse(_23.x);
    _54.x = abs(_84) + abs(_54.x);
    _54.x = max(_54.x, 9.9999997473787516355514526367188e-05f);
    float2 _308 = (-_23.xx) + float2(0.9700000286102294921875f, 0.0599999986588954925537109375f);
    _210 = float3(_308.x, _308.y, _210.z);
    float2 _315 = _210.xy / _54.xx;
    _54 = float3(_315.x, _54.y, _315.y);
    float2 _320 = _54.xz + 0.5f.xx;
    _54 = float3(_320.x, _54.y, _320.y);
    float2 _327 = clamp(_54.xz, 0.0f.xx, 1.0f.xx);
    _54 = float3(_327.x, _54.y, _327.y);
    _80 *= _54.z;
    _84 = (-_30_m5) + 1.0f;
    _23.x = (-_84) + _23.x;
    _23.x = (_23.x * 10000.0f) + 0.5f;
    _23.x = clamp(_23.x, 0.0f, 1.0f);
    _84 = _54.x * _23.x;
    _23.x = ((-_23.x) * _54.x) + 1.0f;
    _210 = _30_m2.xyz * _30_m3.xxx;
    _378 = (_30_m2.xyz * 0.85000002384185791015625f.xxx) + (-_210);
    _210 = (_84.xxx * _378) + _210;
    _394 = ((-_30_m0.y) * _30_m11) + vs_TEXCOORD0.x;
    _394 /= _30_m10;
    _394 = frac(_394);
    _54.x = _394 * 12.5f;
    _84 = _394 + (-0.07999999821186065673828125f);
    _84 *= 8.33333301544189453125f;
    _84 = clamp(_84, 0.0f, 1.0f);
    _54.x = min(_54.x, 1.0f);
    _428 = (_54.x * (-2.0f)) + 3.0f;
    _54.x *= _54.x;
    _54.x *= _428;
    _428 = (_84 * (-2.0f)) + 3.0f;
    _84 *= _84;
    _84 = ((-_428) * _84) + 1.0f;
    _54.x = _84 * _54.x;
    _84 = (_54.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _378 = _54.xxx * _30_m2.xyz;
    _378 *= 0.25f.xxx;
    _478 = (_30_m2.xyz * _84.xxx) + (-_210);
    _210 = (_9.xxx * _478) + _210;
    _478 = (_30_m2.xyz * 0.3499999940395355224609375f.xxx) + (-_210);
    _54 = (_80.xxx * _478) + _210;
    _23 = (_378 * _23.xxx) + _54;
    _9 = _23 + (-_30_m1.xyz);
    _521 = vs_TEXCOORD1;
    _521 = clamp(_521, 0.0f, 1.0f);
    _9 = (_521.xxx * _9) + _30_m1.xyz;
    _535 = float4(_9.x, _9.y, _9.z, _535.w);
    _535.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._535 = _535;
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
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _133;
static float2 _143;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _133 : TEXCOORD0;
    float2 _143 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
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
    vs_TEXCOORD1 = exp2(_9.x);
    float2 _140 = (_133 * float2(1.0f, 2.0f)) + float2(0.0f, -1.0f);
    vs_TEXCOORD0 = float3(_140.x, _140.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = _143.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _133 = stage_input._133;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 unity_FogColor;
float4 _Color;
float _ChannelTint;
float _HalfWidth;
float _RailWidth;
float _ChevronSpacing;
float _ChevronSpeed;
float _ChevronSlant;
float _ChevronWidth;
float _PacketSpacing;
float _PacketSpeed;
#define _30_m0 _Time
#define _30_m1 unity_FogColor
#define _30_m2 _Color
#define _30_m3 _ChannelTint
#define _30_m4 _HalfWidth
#define _30_m5 _RailWidth
#define _30_m6 _ChevronSpacing
#define _30_m7 _ChevronSpeed
#define _30_m8 _ChevronSlant
#define _30_m9 _ChevronWidth
#define _30_m10 _PacketSpacing
#define _30_m11 _PacketSpeed



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _535;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _535 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _54;
static float _80;
static float _84;
static bool _123;
static float3 _210;
static float3 _378;
static float _394;
static float _428;
static float3 _478;
static float _521;

void frag_inner()
{
    _9.x = min(vs_TEXCOORD0.z, vs_TEXCOORD0.x);
    _23.x = (-_9.x) + _30_m4;
    _23.x = max(_23.x, 0.0f);
    _23.x /= _30_m4;
    _9.x = abs(vs_TEXCOORD0.y);
    _54.x = _9.x * _9.x;
    _54.x = (_23.x * _23.x) + _54.x;
    _23.x = max(_23.x, _9.x);
    _54.x = sqrt(_54.x);
    _80 = ddx_coarse(_54.x);
    _84 = ddy_coarse(_54.x);
    _54.x = (-_54.x) + 1.0f;
    _80 = abs(_84) + abs(_80);
    _80 = max(_80, 9.9999997473787516355514526367188e-05f);
    _54.x /= _80;
    _54.x += 0.5f;
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x += (-0.0199999995529651641845703125f);
    _123 = _54.x < 0.0f;
    if ((int(_123) * (-1)) != 0)
    {
        discard;
    }
    _54.x = ddx_coarse(_9.x);
    _80 = ddy_coarse(_9.x);
    _54.x = abs(_80) + abs(_54.x);
    _54.x = max(_54.x, 9.9999997473787516355514526367188e-05f);
    _80 = (-_9.x) + 0.62000000476837158203125f;
    _84 = _9.x * _30_m8;
    _84 *= _30_m4;
    _54.x = _80 / _54.x;
    _9.x = ((-_30_m0.y) * _30_m7) + vs_TEXCOORD0.x;
    _9.x = (_84 * 4.0f) + _9.x;
    _9.x /= _30_m6;
    _9.x = frac(_9.x);
    _80 = ddx_coarse(_9.x);
    _84 = ddy_coarse(_9.x);
    _210.x = (-_9.x) + _30_m9;
    _80 = abs(_84) + abs(_80);
    _80 = max(_80, 9.9999997473787516355514526367188e-05f);
    _54.y = _210.x / _80;
    float2 _235 = _54.xy + 0.5f.xx;
    _54 = float3(_235.x, _235.y, _54.z);
    float2 _242 = clamp(_54.xy, 0.0f.xx, 1.0f.xx);
    _54 = float3(_242.x, _242.y, _54.z);
    _54.x *= _54.y;
    float2 _255 = vs_TEXCOORD0.xz * 1.66666662693023681640625f.xx;
    _9 = float3(_255.x, _255.y, _9.z);
    float2 _262 = clamp(_9.xy, 0.0f.xx, 1.0f.xx);
    _9 = float3(_262.x, _262.y, _9.z);
    _9.x = _9.y * _9.x;
    _80 = ((-_54.x) * _9.x) + 1.0f;
    _9.x *= _54.x;
    _54.x = ddx_coarse(_23.x);
    _84 = ddy_coarse(_23.x);
    _54.x = abs(_84) + abs(_54.x);
    _54.x = max(_54.x, 9.9999997473787516355514526367188e-05f);
    float2 _308 = (-_23.xx) + float2(0.9700000286102294921875f, 0.0599999986588954925537109375f);
    _210 = float3(_308.x, _308.y, _210.z);
    float2 _315 = _210.xy / _54.xx;
    _54 = float3(_315.x, _54.y, _315.y);
    float2 _320 = _54.xz + 0.5f.xx;
    _54 = float3(_320.x, _54.y, _320.y);
    float2 _327 = clamp(_54.xz, 0.0f.xx, 1.0f.xx);
    _54 = float3(_327.x, _54.y, _327.y);
    _80 *= _54.z;
    _84 = (-_30_m5) + 1.0f;
    _23.x = (-_84) + _23.x;
    _23.x = (_23.x * 10000.0f) + 0.5f;
    _23.x = clamp(_23.x, 0.0f, 1.0f);
    _84 = _54.x * _23.x;
    _23.x = ((-_23.x) * _54.x) + 1.0f;
    _210 = _30_m2.xyz * _30_m3.xxx;
    _378 = (_30_m2.xyz * 0.85000002384185791015625f.xxx) + (-_210);
    _210 = (_84.xxx * _378) + _210;
    _394 = ((-_30_m0.y) * _30_m11) + vs_TEXCOORD0.x;
    _394 /= _30_m10;
    _394 = frac(_394);
    _54.x = _394 * 12.5f;
    _84 = _394 + (-0.07999999821186065673828125f);
    _84 *= 8.33333301544189453125f;
    _84 = clamp(_84, 0.0f, 1.0f);
    _54.x = min(_54.x, 1.0f);
    _428 = (_54.x * (-2.0f)) + 3.0f;
    _54.x *= _54.x;
    _54.x *= _428;
    _428 = (_84 * (-2.0f)) + 3.0f;
    _84 *= _84;
    _84 = ((-_428) * _84) + 1.0f;
    _54.x = _84 * _54.x;
    _84 = (_54.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _378 = _54.xxx * _30_m2.xyz;
    _378 *= 0.25f.xxx;
    _478 = (_30_m2.xyz * _84.xxx) + (-_210);
    _210 = (_9.xxx * _478) + _210;
    _478 = (_30_m2.xyz * 0.3499999940395355224609375f.xxx) + (-_210);
    _54 = (_80.xxx * _478) + _210;
    _23 = (_378 * _23.xxx) + _54;
    _9 = _23 + (-_30_m1.xyz);
    _521 = vs_TEXCOORD1;
    _521 = clamp(_521, 0.0f, 1.0f);
    _9 = (_521.xxx * _9) + _30_m1.xyz;
    _535 = float4(_9.x, _9.y, _9.z, _535.w);
    _535.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._535 = _535;
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
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _126;
static float2 _136;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _126 : TEXCOORD0;
    float2 _136 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
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
    vs_TEXCOORD1 = (_9.x * _20_m3.z) + _20_m3.w;
    float2 _133 = (_126 * float2(1.0f, 2.0f)) + float2(0.0f, -1.0f);
    vs_TEXCOORD0 = float3(_133.x, _133.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = _136.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _126 = stage_input._126;
    _136 = stage_input._136;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 unity_FogColor;
float4 _Color;
float _ChannelTint;
float _HalfWidth;
float _RailWidth;
float _ChevronSpacing;
float _ChevronSpeed;
float _ChevronSlant;
float _ChevronWidth;
float _PacketSpacing;
float _PacketSpeed;
#define _30_m0 _Time
#define _30_m1 unity_FogColor
#define _30_m2 _Color
#define _30_m3 _ChannelTint
#define _30_m4 _HalfWidth
#define _30_m5 _RailWidth
#define _30_m6 _ChevronSpacing
#define _30_m7 _ChevronSpeed
#define _30_m8 _ChevronSlant
#define _30_m9 _ChevronWidth
#define _30_m10 _PacketSpacing
#define _30_m11 _PacketSpeed



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _535;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _535 : SV_Target0;
};

static float3 _9;
static float3 _23;
static float3 _54;
static float _80;
static float _84;
static bool _123;
static float3 _210;
static float3 _378;
static float _394;
static float _428;
static float3 _478;
static float _521;

void frag_inner()
{
    _9.x = min(vs_TEXCOORD0.z, vs_TEXCOORD0.x);
    _23.x = (-_9.x) + _30_m4;
    _23.x = max(_23.x, 0.0f);
    _23.x /= _30_m4;
    _9.x = abs(vs_TEXCOORD0.y);
    _54.x = _9.x * _9.x;
    _54.x = (_23.x * _23.x) + _54.x;
    _23.x = max(_23.x, _9.x);
    _54.x = sqrt(_54.x);
    _80 = ddx_coarse(_54.x);
    _84 = ddy_coarse(_54.x);
    _54.x = (-_54.x) + 1.0f;
    _80 = abs(_84) + abs(_80);
    _80 = max(_80, 9.9999997473787516355514526367188e-05f);
    _54.x /= _80;
    _54.x += 0.5f;
    _54.x = clamp(_54.x, 0.0f, 1.0f);
    _54.x += (-0.0199999995529651641845703125f);
    _123 = _54.x < 0.0f;
    if ((int(_123) * (-1)) != 0)
    {
        discard;
    }
    _54.x = ddx_coarse(_9.x);
    _80 = ddy_coarse(_9.x);
    _54.x = abs(_80) + abs(_54.x);
    _54.x = max(_54.x, 9.9999997473787516355514526367188e-05f);
    _80 = (-_9.x) + 0.62000000476837158203125f;
    _84 = _9.x * _30_m8;
    _84 *= _30_m4;
    _54.x = _80 / _54.x;
    _9.x = ((-_30_m0.y) * _30_m7) + vs_TEXCOORD0.x;
    _9.x = (_84 * 4.0f) + _9.x;
    _9.x /= _30_m6;
    _9.x = frac(_9.x);
    _80 = ddx_coarse(_9.x);
    _84 = ddy_coarse(_9.x);
    _210.x = (-_9.x) + _30_m9;
    _80 = abs(_84) + abs(_80);
    _80 = max(_80, 9.9999997473787516355514526367188e-05f);
    _54.y = _210.x / _80;
    float2 _235 = _54.xy + 0.5f.xx;
    _54 = float3(_235.x, _235.y, _54.z);
    float2 _242 = clamp(_54.xy, 0.0f.xx, 1.0f.xx);
    _54 = float3(_242.x, _242.y, _54.z);
    _54.x *= _54.y;
    float2 _255 = vs_TEXCOORD0.xz * 1.66666662693023681640625f.xx;
    _9 = float3(_255.x, _255.y, _9.z);
    float2 _262 = clamp(_9.xy, 0.0f.xx, 1.0f.xx);
    _9 = float3(_262.x, _262.y, _9.z);
    _9.x = _9.y * _9.x;
    _80 = ((-_54.x) * _9.x) + 1.0f;
    _9.x *= _54.x;
    _54.x = ddx_coarse(_23.x);
    _84 = ddy_coarse(_23.x);
    _54.x = abs(_84) + abs(_54.x);
    _54.x = max(_54.x, 9.9999997473787516355514526367188e-05f);
    float2 _308 = (-_23.xx) + float2(0.9700000286102294921875f, 0.0599999986588954925537109375f);
    _210 = float3(_308.x, _308.y, _210.z);
    float2 _315 = _210.xy / _54.xx;
    _54 = float3(_315.x, _54.y, _315.y);
    float2 _320 = _54.xz + 0.5f.xx;
    _54 = float3(_320.x, _54.y, _320.y);
    float2 _327 = clamp(_54.xz, 0.0f.xx, 1.0f.xx);
    _54 = float3(_327.x, _54.y, _327.y);
    _80 *= _54.z;
    _84 = (-_30_m5) + 1.0f;
    _23.x = (-_84) + _23.x;
    _23.x = (_23.x * 10000.0f) + 0.5f;
    _23.x = clamp(_23.x, 0.0f, 1.0f);
    _84 = _54.x * _23.x;
    _23.x = ((-_23.x) * _54.x) + 1.0f;
    _210 = _30_m2.xyz * _30_m3.xxx;
    _378 = (_30_m2.xyz * 0.85000002384185791015625f.xxx) + (-_210);
    _210 = (_84.xxx * _378) + _210;
    _394 = ((-_30_m0.y) * _30_m11) + vs_TEXCOORD0.x;
    _394 /= _30_m10;
    _394 = frac(_394);
    _54.x = _394 * 12.5f;
    _84 = _394 + (-0.07999999821186065673828125f);
    _84 *= 8.33333301544189453125f;
    _84 = clamp(_84, 0.0f, 1.0f);
    _54.x = min(_54.x, 1.0f);
    _428 = (_54.x * (-2.0f)) + 3.0f;
    _54.x *= _54.x;
    _54.x *= _428;
    _428 = (_84 * (-2.0f)) + 3.0f;
    _84 *= _84;
    _84 = ((-_428) * _84) + 1.0f;
    _54.x = _84 * _54.x;
    _84 = (_54.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _378 = _54.xxx * _30_m2.xyz;
    _378 *= 0.25f.xxx;
    _478 = (_30_m2.xyz * _84.xxx) + (-_210);
    _210 = (_9.xxx * _478) + _210;
    _478 = (_30_m2.xyz * 0.3499999940395355224609375f.xxx) + (-_210);
    _54 = (_80.xxx * _478) + _210;
    _23 = (_378 * _23.xxx) + _54;
    _9 = _23 + (-_30_m1.xyz);
    _521 = vs_TEXCOORD1;
    _521 = clamp(_521, 0.0f, 1.0f);
    _9 = (_521.xxx * _9) + _30_m1.xyz;
    _535 = float4(_9.x, _9.y, _9.z, _535.w);
    _535.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._535 = _535;
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
static float3 vs_TEXCOORD0;
static float2 _87;
static float2 _99;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _87 : TEXCOORD0;
    float2 _99 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
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
    float2 _96 = (_87 * float2(1.0f, 2.0f)) + float2(0.0f, -1.0f);
    vs_TEXCOORD0 = float3(_96.x, _96.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = _99.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _87 = stage_input._87;
    _99 = stage_input._99;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4 _Color;
float _ChannelTint;
float _HalfWidth;
float _RailWidth;
float _ChevronSpacing;
float _ChevronSpeed;
float _ChevronSlant;
float _ChevronWidth;
float _PacketSpacing;
float _PacketSpeed;
#define _31_m0 _Time
#define _31_m1 _Color
#define _31_m2 _ChannelTint
#define _31_m3 _HalfWidth
#define _31_m4 _RailWidth
#define _31_m5 _ChevronSpacing
#define _31_m6 _ChevronSpeed
#define _31_m7 _ChevronSlant
#define _31_m8 _ChevronWidth
#define _31_m9 _PacketSpacing
#define _31_m10 _PacketSpeed



static float3 vs_TEXCOORD0;
static float4 _485;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _485 : SV_Target0;
};

static float2 _9;
static float _24;
static float3 _51;
static float _73;
static float _77;
static bool _116;
static float3 _203;
static float3 _353;
static float _369;
static float _403;
static float3 _453;

void frag_inner()
{
    _9.x = min(vs_TEXCOORD0.z, vs_TEXCOORD0.x);
    _24 = (-_9.x) + _31_m3;
    _24 = max(_24, 0.0f);
    _24 /= _31_m3;
    _9.x = abs(vs_TEXCOORD0.y);
    _51.x = _9.x * _9.x;
    _51.x = (_24 * _24) + _51.x;
    _24 = max(_24, _9.x);
    _51.x = sqrt(_51.x);
    _73 = ddx_coarse(_51.x);
    _77 = ddy_coarse(_51.x);
    _51.x = (-_51.x) + 1.0f;
    _73 = abs(_77) + abs(_73);
    _73 = max(_73, 9.9999997473787516355514526367188e-05f);
    _51.x /= _73;
    _51.x += 0.5f;
    _51.x = clamp(_51.x, 0.0f, 1.0f);
    _51.x += (-0.0199999995529651641845703125f);
    _116 = _51.x < 0.0f;
    if ((int(_116) * (-1)) != 0)
    {
        discard;
    }
    _51.x = ddx_coarse(_9.x);
    _73 = ddy_coarse(_9.x);
    _51.x = abs(_73) + abs(_51.x);
    _51.x = max(_51.x, 9.9999997473787516355514526367188e-05f);
    _73 = (-_9.x) + 0.62000000476837158203125f;
    _77 = _9.x * _31_m7;
    _77 *= _31_m3;
    _51.x = _73 / _51.x;
    _9.x = ((-_31_m0.y) * _31_m6) + vs_TEXCOORD0.x;
    _9.x = (_77 * 4.0f) + _9.x;
    _9.x /= _31_m5;
    _9.x = frac(_9.x);
    _73 = ddx_coarse(_9.x);
    _77 = ddy_coarse(_9.x);
    _203.x = (-_9.x) + _31_m8;
    _73 = abs(_77) + abs(_73);
    _73 = max(_73, 9.9999997473787516355514526367188e-05f);
    _51.y = _203.x / _73;
    float2 _227 = _51.xy + 0.5f.xx;
    _51 = float3(_227.x, _227.y, _51.z);
    float2 _234 = clamp(_51.xy, 0.0f.xx, 1.0f.xx);
    _51 = float3(_234.x, _234.y, _51.z);
    _51.x *= _51.y;
    _9 = vs_TEXCOORD0.xz * 1.66666662693023681640625f.xx;
    _9 = clamp(_9, 0.0f.xx, 1.0f.xx);
    _9.x = _9.y * _9.x;
    _73 = ((-_51.x) * _9.x) + 1.0f;
    _9.x *= _51.x;
    _51.x = ddx_coarse(_24);
    _77 = ddy_coarse(_24);
    _51.x = abs(_77) + abs(_51.x);
    _51.x = max(_51.x, 9.9999997473787516355514526367188e-05f);
    float2 _293 = (-_24.xx) + float2(0.9700000286102294921875f, 0.0599999986588954925537109375f);
    _203 = float3(_293.x, _293.y, _203.z);
    float2 _300 = _203.xy / _51.xx;
    _51 = float3(_300.x, _51.y, _300.y);
    float2 _305 = _51.xz + 0.5f.xx;
    _51 = float3(_305.x, _51.y, _305.y);
    float2 _312 = clamp(_51.xz, 0.0f.xx, 1.0f.xx);
    _51 = float3(_312.x, _51.y, _312.y);
    _73 *= _51.z;
    _77 = (-_31_m4) + 1.0f;
    _24 = (-_77) + _24;
    _24 = (_24 * 10000.0f) + 0.5f;
    _24 = clamp(_24, 0.0f, 1.0f);
    _77 = _51.x * _24;
    _24 = ((-_24) * _51.x) + 1.0f;
    _203 = _31_m1.xyz * _31_m2.xxx;
    _353 = (_31_m1.xyz * 0.85000002384185791015625f.xxx) + (-_203);
    _203 = (_77.xxx * _353) + _203;
    _369 = ((-_31_m0.y) * _31_m10) + vs_TEXCOORD0.x;
    _369 /= _31_m9;
    _369 = frac(_369);
    _51.x = _369 * 12.5f;
    _77 = _369 + (-0.07999999821186065673828125f);
    _77 *= 8.33333301544189453125f;
    _77 = clamp(_77, 0.0f, 1.0f);
    _51.x = min(_51.x, 1.0f);
    _403 = (_51.x * (-2.0f)) + 3.0f;
    _51.x *= _51.x;
    _51.x *= _403;
    _403 = (_77 * (-2.0f)) + 3.0f;
    _77 *= _77;
    _77 = ((-_403) * _77) + 1.0f;
    _51.x = _77 * _51.x;
    _77 = (_51.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _353 = _51.xxx * _31_m1.xyz;
    _353 *= 0.25f.xxx;
    _453 = (_31_m1.xyz * _77.xxx) + (-_203);
    _203 = (_9.xxx * _453) + _203;
    _453 = (_31_m1.xyz * 0.3499999940395355224609375f.xxx) + (-_203);
    _51 = (_73.xxx * _453) + _203;
    float3 _491 = (_353 * _24.xxx) + _51;
    _485 = float4(_491.x, _491.y, _491.z, _485.w);
    _485.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._485 = _485;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}