// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BTM/Flashlight Beam" {
Properties {

_Color ("Colour", Color) = (1,0.94,0.84,1)

_Intensity ("Haze density", Range(0, 4)) = 1.5

_LensRadius ("Lens radius (m)", Float) = 0.029999999329447746

_HalfAngle ("Half angle (deg)", Range(5, 45)) = 24.0

_Length ("Length (m)", Float) = 9.0

_Falloff ("Distance falloff (m)", Float) = 3.0

_NearFade ("Fade near the eye (m)", Float) = 0.8999999761581421

_Soft ("Fade into surfaces (m)", Float) = 0.3499999940395355

_Phase ("Forward scatter", Range(0, 0.6)) = 0.25

[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2.0

[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4.0

}
SubShader {
 Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
 Name "Beam"
  Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZTest [_ZTest]
 ZWrite Off
 Cull [_Cull]
   Blend One One
 ZTest [_ZTest]
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float _LensRadius;
float _HalfAngle;
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
#define _22_m4 _LensRadius
#define _22_m5 _HalfAngle



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _9 += _22_m1[3];
    _50 = _9.yyyy * _22_m3[1];
    _50 = (_22_m3[0] * _9.xxxx) + _50;
    _50 = (_22_m3[2] * _9.zzzz) + _50;
    gl_Position = (_22_m3[3] * _9.wwww) + _50;
    vs_TEXCOORD0 = _11.xyz;
    float3 _95 = _22_m0.yyy * _22_m2[1].xyz;
    _9 = float4(_95.x, _95.y, _95.z, _9.w);
    float3 _107 = (_22_m2[0].xyz * _22_m0.xxx) + _9.xyz;
    _9 = float4(_107.x, _107.y, _107.z, _9.w);
    float3 _119 = (_22_m2[2].xyz * _22_m0.zzz) + _9.xyz;
    _9 = float4(_119.x, _119.y, _119.z, _9.w);
    vs_TEXCOORD1 = _9.xyz + _22_m2[3].xyz;
    _9.x = _22_m5 * 0.01745329238474369049072265625f;
    _50.x = cos(_9.x);
    _9.x = sin(_9.x);
    _9.x /= _50.x;
    vs_TEXCOORD2.y = _22_m4 / _9.x;
    vs_TEXCOORD2.x = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogParams;
float4 _Color;
float _Intensity;
float _LensRadius;
float _Length;
float _Falloff;
float _NearFade;
float _Soft;
float _Phase;
float4 _Planes[4];
#define _269_m0 unity_FogParams
#define _269_m1 _Color
#define _269_m2 _Intensity
#define _269_m3 _LensRadius
#define _269_m4 _Length
#define _269_m5 _Falloff
#define _269_m6 _NearFade
#define _269_m7 _Soft
#define _269_m8 _Phase
#define _269_m9 _Planes



static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _655;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _655 : SV_Target0;
};

static float3 _9;
static float _18;
static float4 _41;
static float3 _50;
static float _57;
static float _87;
static bool4 _103;
static float4 _113;
static bool _153;
static float4 _201;
static bool _280;
static float2 _294;
static bool _319;
static bool _344;
static bool _395;
static bool _415;
static bool _647;
static float _765;
static float _772;
static float _783;
static float _801;
static float _866;
static float4 _963;
static float _1043;
static float _1054;
static float _1293;
static float _1528;
static float _1640;
static float _1676;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-vs_TEXCOORD1);
    _18 = dot(_9, _9);
    _18 = rsqrt(_18);
    _9 = _18.xxx * _9;
    _18 = vs_TEXCOORD2.x * vs_TEXCOORD2.x;
    _41.x = vs_TEXCOORD1.z + vs_TEXCOORD2.y;
    _50.x = dot(_9.xy, _9.xy);
    _57 = _9.z * _9.z;
    _41.y = ((-_57) * _18) + _50.x;
    _57 = dot(vs_TEXCOORD1.xy, _9.xy);
    _18 *= _41.x;
    _57 = ((-_18) * _9.z) + _57;
    _87 = dot(vs_TEXCOORD1.xy, vs_TEXCOORD1.xy);
    _18 = ((-_18) * _41.x) + _87;
    bool2 _110 = bool4(_41.xxxy.x >= 0.0f.xxxx.x, _41.xxxy.y >= 0.0f.xxxx.y, _41.xxxy.z >= 0.0f.xxxx.z, _41.xxxy.w >= 0.0f.xxxx.w).xw;
    _103 = bool4(_110.x, _103.y, _103.z, _110.y);
    _113.x = max(_41.y, 9.9999997473787516355514526367188e-06f);
    _50.x = min(_41.y, -9.9999997473787516355514526367188e-06f);
    float _129;
    if (_103.w)
    {
        _129 = _113.x;
    }
    else
    {
        _129 = _50.x;
    }
    _50.x = _129;
    _87 = _18 * _50.x;
    _87 = (_57 * _57) + (-_87);
    _87 = max(_87, 0.0f);
    _87 = sqrt(_87);
    _153 = 0.0f >= _18;
    _153 = _103.x && _153;
    _41.x = (-_87) + (-_57);
    _41.x /= _50.x;
    float _173;
    if (_153)
    {
        _173 = 0.0f;
    }
    else
    {
        _173 = _41.x;
    }
    _113.x = _173;
    _153 = _50.x < 0.0f;
    _103.x = 0.0f < _9.z;
    _153 = _153 && _103.x;
    _57 = _87 + (-_57);
    _50.x = _57 / _50.x;
    float _203;
    if (_153)
    {
        _203 = 1000000.0f;
    }
    else
    {
        _203 = _50.x;
    }
    _201.y = _203;
    _153 = 9.9999997473787516355514526367188e-06f < abs(_9.z);
    float _217;
    if (_153)
    {
        _217 = _9.z;
    }
    else
    {
        _217 = 9.9999997473787516355514526367188e-06f;
    }
    _18 = _217;
    _18 = (-vs_TEXCOORD1.z) / _18;
    _201.x = max(_18, _113.x);
    _113.y = min(_18, _201.y);
    float2 _242;
    if (_103.x)
    {
        _242 = _201.xy;
    }
    else
    {
        _242 = _113.xy;
    }
    _41 = float4(_242.x, _242.y, _41.z, _41.w);
    _18 = dot(vs_TEXCOORD1, _9);
    _87 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _87 = (_18 * _18) + (-_87);
    _87 = (_269_m4 * _269_m4) + _87;
    _280 = 0.0f < _87;
    _87 = sqrt(_87);
    _18 = (-_18) + _87;
    _18 = min(_18, _41.y);
    _294.y = _280 ? _18 : (-1.0f);
    _18 = dot(_269_m9[0].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[0].w);
    _50.x = dot(_269_m9[0].xyz, _9);
    _319 = 9.9999997473787516355514526367188e-06f < abs(_50.x);
    float _325;
    if (_319)
    {
        _325 = _50.x;
    }
    else
    {
        _325 = 9.9999997473787516355514526367188e-06f;
    }
    _87 = _325;
    _87 = (-_18) / _87;
    _280 = 9.9999997473787516355514526367188e-06f < _50.x;
    _294.x = max(_87, _41.x);
    _344 = _50.x < (-9.9999997473787516355514526367188e-06f);
    _87 = min(_87, _294.y);
    _153 = _18 < 0.0f;
    float _355;
    if (_153)
    {
        _355 = -1.0f;
    }
    else
    {
        _355 = _294.y;
    }
    _18 = _355;
    _41.z = _344 ? _87 : _18;
    float2 _368;
    if (_280)
    {
        _368 = _294;
    }
    else
    {
        _368 = _41.xz;
    }
    _41 = float4(_41.x, _368.x, _368.y, _41.w);
    _18 = dot(_269_m9[1].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[1].w);
    _113.x = dot(_269_m9[1].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _401;
    if (_395)
    {
        _401 = _113.x;
    }
    else
    {
        _401 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _401;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _437;
    if (_153)
    {
        _437 = -1.0f;
    }
    else
    {
        _437 = _41.z;
    }
    _18 = _437;
    float _445;
    if (_280)
    {
        _445 = _294.x;
    }
    else
    {
        _445 = _18;
    }
    _41.w = _445;
    float2 _455;
    if (_415)
    {
        _455 = _41.xz;
    }
    else
    {
        _455 = _41.yw;
    }
    _41 = float4(_41.x, _455.x, _455.y, _41.w);
    _18 = dot(_269_m9[2].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[2].w);
    _113.x = dot(_269_m9[2].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _488;
    if (_395)
    {
        _488 = _113.x;
    }
    else
    {
        _488 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _488;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _523;
    if (_153)
    {
        _523 = -1.0f;
    }
    else
    {
        _523 = _41.z;
    }
    _18 = _523;
    float _531;
    if (_280)
    {
        _531 = _294.x;
    }
    else
    {
        _531 = _18;
    }
    _41.w = _531;
    float2 _541;
    if (_415)
    {
        _541 = _41.xz;
    }
    else
    {
        _541 = _41.yw;
    }
    _41 = float4(_41.x, _541.x, _541.y, _41.w);
    _18 = dot(_269_m9[3].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[3].w);
    _113.x = dot(_269_m9[3].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _574;
    if (_395)
    {
        _574 = _113.x;
    }
    else
    {
        _574 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _574;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _609;
    if (_153)
    {
        _609 = -1.0f;
    }
    else
    {
        _609 = _41.z;
    }
    _18 = _609;
    float _617;
    if (_280)
    {
        _617 = _294.x;
    }
    else
    {
        _617 = _18;
    }
    _41.w = _617;
    float2 _627;
    if (_415)
    {
        _627 = _41.xz;
    }
    else
    {
        _627 = _41.yw;
    }
    _41 = float4(_627.x, _627.y, _41.z, _41.w);
    _18 = max(_41.x, 0.0f);
    _41.x = (-_18) + _41.y;
    _647 = 0.0f >= _41.x;
    if (_647)
    {
        _655 = float4(0.0f, 0.0f, 0.0f, 1.0f);
        return;
    }
    float3 _664 = (_9 * _18.xxx) + vs_TEXCOORD1;
    _113 = float4(_664.x, _664.y, _664.z, _113.w);
    float3 _672 = (_9 * _41.yyy) + vs_TEXCOORD1;
    _201 = float4(_672.x, _672.y, _672.z, _201.w);
    _57 = dot(_113.xyz, _113.xyz);
    _87 = dot(_201.xyz, _201.xyz);
    _647 = _87 >= _57;
    float _689;
    if (_647)
    {
        _689 = _18;
    }
    else
    {
        _689 = _41.y;
    }
    _18 = _689;
    float _698;
    if (_647)
    {
        _698 = _41.x;
    }
    else
    {
        _698 = -_41.x;
    }
    _50.x = _698;
    _113 = (_50.xxxx * float4(0.015625f, 0.140625f, 0.390625f, 0.765625f)) + _18.xxxx;
    _50 = (_9 * _113.xxx) + vs_TEXCOORD1;
    _18 = max(_50.z, 0.0f);
    _18 = (_18 * vs_TEXCOORD2.x) + _269_m3;
    _201.x = dot(_50.xy, _50.xy);
    _201.x = sqrt(_201.x);
    _18 = _201.x / _18;
    _18 = clamp(_18, 0.0f, 1.0f);
    _18 = ((-_18) * _18) + 1.0f;
    _201.x = dot(_50, _50);
    _201.x = sqrt(_201.x);
    _765 = _201.x / _269_m5;
    _772 = _201.x / _269_m4;
    _772 = (-_772) + 1.0f;
    _772 = clamp(_772, 0.0f, 1.0f);
    _783 = dot(_269_m9[0].xyz, _50);
    _783 += (-_269_m9[0].w);
    _783 /= _269_m7;
    _783 = clamp(_783, 0.0f, 1.0f);
    _801 = dot(_269_m9[1].xyz, _50);
    _801 += (-_269_m9[1].w);
    _801 /= _269_m7;
    _801 = clamp(_801, 0.0f, 1.0f);
    _783 *= _801;
    _801 = dot(_269_m9[2].xyz, _50);
    _801 += (-_269_m9[2].w);
    _801 /= _269_m7;
    _801 = clamp(_801, 0.0f, 1.0f);
    _783 *= _801;
    _801 = dot(_269_m9[3].xyz, _50);
    _801 += (-_269_m9[3].w);
    _801 /= _269_m7;
    _801 = clamp(_801, 0.0f, 1.0f);
    _783 *= _801;
    _801 = (_269_m8 * _269_m8) + 1.0f;
    _866 = _269_m8 + _269_m8;
    _50.x = dot(_50, _9);
    _50.x *= _866;
    _57 = max(_201.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _801;
    _50.x = _801 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _18 *= _18;
    _57 = _772 * _772;
    _18 *= _57;
    _18 = _783 * _18;
    _18 = _50.x * _18;
    _50.x = (_765 * _765) + 1.0f;
    _18 /= _50.x;
    _201 = _113 + (-0.1500000059604644775390625f).xxxx;
    _201 /= float4(float4(_269_m6, _269_m6, _269_m6, _269_m6));
    _201 = clamp(_201, 0.0f.xxxx, 1.0f.xxxx);
    _963 = _113 * (-_269_m0.yyyy);
    _963 = exp2(_963);
    _963 = min(_963, 1.0f.xxxx);
    _201 *= _963;
    _18 *= _201.x;
    _50 = (_9 * _113.yyy) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m3;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _201.x = _294.x / _269_m5;
    _1043 = _294.x / _269_m4;
    _1043 = (-_1043) + 1.0f;
    _1043 = clamp(_1043, 0.0f, 1.0f);
    _1054 = dot(_269_m9[0].xyz, _50);
    _1054 += (-_269_m9[0].w);
    _1054 /= _269_m7;
    _1054 = clamp(_1054, 0.0f, 1.0f);
    _963.x = dot(_269_m9[1].xyz, _50);
    _963.x += (-_269_m9[1].w);
    _963.x /= _269_m7;
    _963.x = clamp(_963.x, 0.0f, 1.0f);
    _1054 *= _963.x;
    _963.x = dot(_269_m9[2].xyz, _50);
    _963.x += (-_269_m9[2].w);
    _963.x /= _269_m7;
    _963.x = clamp(_963.x, 0.0f, 1.0f);
    _1054 *= _963.x;
    _963.x = dot(_269_m9[3].xyz, _50);
    _963.x += (-_269_m9[3].w);
    _963.x /= _269_m7;
    _963.x = clamp(_963.x, 0.0f, 1.0f);
    _1054 *= _963.x;
    _50.x = dot(_50, _9);
    _50.x *= _866;
    _57 = max(_294.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _801;
    _50.x = _801 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _57 = _113.x * _113.x;
    _87 = _1043 * _1043;
    _57 *= _87;
    _57 = _1054 * _57;
    _50.x *= _57;
    _57 = (_201.x * _201.x) + 1.0f;
    _50.x /= _57;
    _50.x = _201.y * _50.x;
    _50.x *= 0.375f;
    _18 = (_18 * 0.125f) + _50.x;
    _50 = (_9 * _113.zzz) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m3;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _1293 = _294.x / _269_m5;
    _201.x = _294.x / _269_m4;
    _201.x = (-_201.x) + 1.0f;
    _201.x = clamp(_201.x, 0.0f, 1.0f);
    _765 = dot(_269_m9[0].xyz, _50);
    _765 += (-_269_m9[0].w);
    _765 /= _269_m7;
    _765 = clamp(_765, 0.0f, 1.0f);
    _1043 = dot(_269_m9[1].xyz, _50);
    _1043 += (-_269_m9[1].w);
    _1043 /= _269_m7;
    _1043 = clamp(_1043, 0.0f, 1.0f);
    _765 *= _1043;
    _1043 = dot(_269_m9[2].xyz, _50);
    _1043 += (-_269_m9[2].w);
    _1043 /= _269_m7;
    _1043 = clamp(_1043, 0.0f, 1.0f);
    _765 *= _1043;
    _1043 = dot(_269_m9[3].xyz, _50);
    _1043 += (-_269_m9[3].w);
    _1043 /= _269_m7;
    _1043 = clamp(_1043, 0.0f, 1.0f);
    _765 *= _1043;
    _50.x = dot(_50, _9);
    _50.x *= _866;
    _57 = max(_294.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _801;
    _50.x = _801 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _57 = _113.x * _113.x;
    _87 = _201.x * _201.x;
    _57 *= _87;
    _57 = _765 * _57;
    _50.x *= _57;
    _57 = (_1293 * _1293) + 1.0f;
    _50.x /= _57;
    _50.x = _201.z * _50.x;
    _18 = (_50.x * 0.625f) + _18;
    _50 = (_9 * _113.www) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m3;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _1293 = _294.x / _269_m5;
    _1528 = _294.x / _269_m4;
    _1528 = (-_1528) + 1.0f;
    _1528 = clamp(_1528, 0.0f, 1.0f);
    _201.x = dot(_269_m9[0].xyz, _50);
    _201.x += (-_269_m9[0].w);
    _765 = dot(_269_m9[1].xyz, _50);
    _201.y = _765 + (-_269_m9[1].w);
    float2 _1573 = _201.xy / float2(float2(_269_m7, _269_m7));
    _201 = float4(_1573.x, _1573.y, _201.z, _201.w);
    float2 _1580 = clamp(_201.xy, 0.0f.xx, 1.0f.xx);
    _201 = float4(_1580.x, _1580.y, _201.z, _201.w);
    _201.x = _201.y * _201.x;
    _765 = dot(_269_m9[2].xyz, _50);
    _765 += (-_269_m9[2].w);
    _765 /= _269_m7;
    _765 = clamp(_765, 0.0f, 1.0f);
    _201.x = _765 * _201.x;
    _765 = dot(_269_m9[3].xyz, _50);
    _765 += (-_269_m9[3].w);
    _765 /= _269_m7;
    _765 = clamp(_765, 0.0f, 1.0f);
    _201.x = _765 * _201.x;
    _9.x = dot(_50, _9);
    _9.x *= _866;
    _1640 = max(_294.x, 0.001000000047497451305389404296875f);
    _9.x /= _1640;
    _9.x += _801;
    _9.x = _801 / _9.x;
    _9.x = log2(_9.x);
    _9.x *= 1.5f;
    _9.x = exp2(_9.x);
    _1640 = _113.x * _113.x;
    _1676 = _1528 * _1528;
    _1640 *= _1676;
    _1640 = _201.x * _1640;
    _9.x *= _1640;
    _1640 = (_1293 * _1293) + 1.0f;
    _9.x /= _1640;
    _9.x = _201.w * _9.x;
    _9.x = (_9.x * 0.875f) + _18;
    _9.x *= _41.x;
    _9.x *= 0.5f;
    _9.x = (-_9.x) * _269_m2;
    _9.x *= 1.44269502162933349609375f;
    _9.x = exp2(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9 = _9.xxx * _269_m1.xyz;
    _655 = float4(_9.x, _9.y, _9.z, _655.w);
    _655.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._655 = _655;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float _LensRadius;
float _HalfAngle;
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
#define _22_m4 _LensRadius
#define _22_m5 _HalfAngle



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _9 += _22_m1[3];
    _50 = _9.yyyy * _22_m3[1];
    _50 = (_22_m3[0] * _9.xxxx) + _50;
    _50 = (_22_m3[2] * _9.zzzz) + _50;
    gl_Position = (_22_m3[3] * _9.wwww) + _50;
    vs_TEXCOORD0 = _11.xyz;
    float3 _95 = _22_m0.yyy * _22_m2[1].xyz;
    _9 = float4(_95.x, _95.y, _95.z, _9.w);
    float3 _107 = (_22_m2[0].xyz * _22_m0.xxx) + _9.xyz;
    _9 = float4(_107.x, _107.y, _107.z, _9.w);
    float3 _119 = (_22_m2[2].xyz * _22_m0.zzz) + _9.xyz;
    _9 = float4(_119.x, _119.y, _119.z, _9.w);
    vs_TEXCOORD1 = _9.xyz + _22_m2[3].xyz;
    _9.x = _22_m5 * 0.01745329238474369049072265625f;
    _50.x = cos(_9.x);
    _9.x = sin(_9.x);
    _9.x /= _50.x;
    vs_TEXCOORD2.y = _22_m4 / _9.x;
    vs_TEXCOORD2.x = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogParams;
float4 _Color;
float _Intensity;
float _LensRadius;
float _Length;
float _Falloff;
float _NearFade;
float _Soft;
float _Phase;
float4 _Planes[4];
#define _269_m0 unity_FogParams
#define _269_m1 _Color
#define _269_m2 _Intensity
#define _269_m3 _LensRadius
#define _269_m4 _Length
#define _269_m5 _Falloff
#define _269_m6 _NearFade
#define _269_m7 _Soft
#define _269_m8 _Phase
#define _269_m9 _Planes



static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _655;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _655 : SV_Target0;
};

static float3 _9;
static float _18;
static float4 _41;
static float3 _50;
static float _57;
static float _87;
static bool4 _103;
static float4 _113;
static bool _153;
static float4 _201;
static bool _280;
static float2 _294;
static bool _319;
static bool _344;
static bool _395;
static bool _415;
static bool _647;
static float _765;
static float _772;
static float _783;
static float _801;
static float _866;
static float4 _963;
static float _1043;
static float _1054;
static float _1293;
static float _1528;
static float _1640;
static float _1676;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-vs_TEXCOORD1);
    _18 = dot(_9, _9);
    _18 = rsqrt(_18);
    _9 = _18.xxx * _9;
    _18 = vs_TEXCOORD2.x * vs_TEXCOORD2.x;
    _41.x = vs_TEXCOORD1.z + vs_TEXCOORD2.y;
    _50.x = dot(_9.xy, _9.xy);
    _57 = _9.z * _9.z;
    _41.y = ((-_57) * _18) + _50.x;
    _57 = dot(vs_TEXCOORD1.xy, _9.xy);
    _18 *= _41.x;
    _57 = ((-_18) * _9.z) + _57;
    _87 = dot(vs_TEXCOORD1.xy, vs_TEXCOORD1.xy);
    _18 = ((-_18) * _41.x) + _87;
    bool2 _110 = bool4(_41.xxxy.x >= 0.0f.xxxx.x, _41.xxxy.y >= 0.0f.xxxx.y, _41.xxxy.z >= 0.0f.xxxx.z, _41.xxxy.w >= 0.0f.xxxx.w).xw;
    _103 = bool4(_110.x, _103.y, _103.z, _110.y);
    _113.x = max(_41.y, 9.9999997473787516355514526367188e-06f);
    _50.x = min(_41.y, -9.9999997473787516355514526367188e-06f);
    float _129;
    if (_103.w)
    {
        _129 = _113.x;
    }
    else
    {
        _129 = _50.x;
    }
    _50.x = _129;
    _87 = _18 * _50.x;
    _87 = (_57 * _57) + (-_87);
    _87 = max(_87, 0.0f);
    _87 = sqrt(_87);
    _153 = 0.0f >= _18;
    _153 = _103.x && _153;
    _41.x = (-_87) + (-_57);
    _41.x /= _50.x;
    float _173;
    if (_153)
    {
        _173 = 0.0f;
    }
    else
    {
        _173 = _41.x;
    }
    _113.x = _173;
    _153 = _50.x < 0.0f;
    _103.x = 0.0f < _9.z;
    _153 = _153 && _103.x;
    _57 = _87 + (-_57);
    _50.x = _57 / _50.x;
    float _203;
    if (_153)
    {
        _203 = 1000000.0f;
    }
    else
    {
        _203 = _50.x;
    }
    _201.y = _203;
    _153 = 9.9999997473787516355514526367188e-06f < abs(_9.z);
    float _217;
    if (_153)
    {
        _217 = _9.z;
    }
    else
    {
        _217 = 9.9999997473787516355514526367188e-06f;
    }
    _18 = _217;
    _18 = (-vs_TEXCOORD1.z) / _18;
    _201.x = max(_18, _113.x);
    _113.y = min(_18, _201.y);
    float2 _242;
    if (_103.x)
    {
        _242 = _201.xy;
    }
    else
    {
        _242 = _113.xy;
    }
    _41 = float4(_242.x, _242.y, _41.z, _41.w);
    _18 = dot(vs_TEXCOORD1, _9);
    _87 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _87 = (_18 * _18) + (-_87);
    _87 = (_269_m4 * _269_m4) + _87;
    _280 = 0.0f < _87;
    _87 = sqrt(_87);
    _18 = (-_18) + _87;
    _18 = min(_18, _41.y);
    _294.y = _280 ? _18 : (-1.0f);
    _18 = dot(_269_m9[0].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[0].w);
    _50.x = dot(_269_m9[0].xyz, _9);
    _319 = 9.9999997473787516355514526367188e-06f < abs(_50.x);
    float _325;
    if (_319)
    {
        _325 = _50.x;
    }
    else
    {
        _325 = 9.9999997473787516355514526367188e-06f;
    }
    _87 = _325;
    _87 = (-_18) / _87;
    _280 = 9.9999997473787516355514526367188e-06f < _50.x;
    _294.x = max(_87, _41.x);
    _344 = _50.x < (-9.9999997473787516355514526367188e-06f);
    _87 = min(_87, _294.y);
    _153 = _18 < 0.0f;
    float _355;
    if (_153)
    {
        _355 = -1.0f;
    }
    else
    {
        _355 = _294.y;
    }
    _18 = _355;
    _41.z = _344 ? _87 : _18;
    float2 _368;
    if (_280)
    {
        _368 = _294;
    }
    else
    {
        _368 = _41.xz;
    }
    _41 = float4(_41.x, _368.x, _368.y, _41.w);
    _18 = dot(_269_m9[1].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[1].w);
    _113.x = dot(_269_m9[1].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _401;
    if (_395)
    {
        _401 = _113.x;
    }
    else
    {
        _401 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _401;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _437;
    if (_153)
    {
        _437 = -1.0f;
    }
    else
    {
        _437 = _41.z;
    }
    _18 = _437;
    float _445;
    if (_280)
    {
        _445 = _294.x;
    }
    else
    {
        _445 = _18;
    }
    _41.w = _445;
    float2 _455;
    if (_415)
    {
        _455 = _41.xz;
    }
    else
    {
        _455 = _41.yw;
    }
    _41 = float4(_41.x, _455.x, _455.y, _41.w);
    _18 = dot(_269_m9[2].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[2].w);
    _113.x = dot(_269_m9[2].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _488;
    if (_395)
    {
        _488 = _113.x;
    }
    else
    {
        _488 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _488;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _523;
    if (_153)
    {
        _523 = -1.0f;
    }
    else
    {
        _523 = _41.z;
    }
    _18 = _523;
    float _531;
    if (_280)
    {
        _531 = _294.x;
    }
    else
    {
        _531 = _18;
    }
    _41.w = _531;
    float2 _541;
    if (_415)
    {
        _541 = _41.xz;
    }
    else
    {
        _541 = _41.yw;
    }
    _41 = float4(_41.x, _541.x, _541.y, _41.w);
    _18 = dot(_269_m9[3].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[3].w);
    _113.x = dot(_269_m9[3].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _574;
    if (_395)
    {
        _574 = _113.x;
    }
    else
    {
        _574 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _574;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _609;
    if (_153)
    {
        _609 = -1.0f;
    }
    else
    {
        _609 = _41.z;
    }
    _18 = _609;
    float _617;
    if (_280)
    {
        _617 = _294.x;
    }
    else
    {
        _617 = _18;
    }
    _41.w = _617;
    float2 _627;
    if (_415)
    {
        _627 = _41.xz;
    }
    else
    {
        _627 = _41.yw;
    }
    _41 = float4(_627.x, _627.y, _41.z, _41.w);
    _18 = max(_41.x, 0.0f);
    _41.x = (-_18) + _41.y;
    _647 = 0.0f >= _41.x;
    if (_647)
    {
        _655 = float4(0.0f, 0.0f, 0.0f, 1.0f);
        return;
    }
    float3 _664 = (_9 * _18.xxx) + vs_TEXCOORD1;
    _113 = float4(_664.x, _664.y, _664.z, _113.w);
    float3 _672 = (_9 * _41.yyy) + vs_TEXCOORD1;
    _201 = float4(_672.x, _672.y, _672.z, _201.w);
    _57 = dot(_113.xyz, _113.xyz);
    _87 = dot(_201.xyz, _201.xyz);
    _647 = _87 >= _57;
    float _689;
    if (_647)
    {
        _689 = _18;
    }
    else
    {
        _689 = _41.y;
    }
    _18 = _689;
    float _698;
    if (_647)
    {
        _698 = _41.x;
    }
    else
    {
        _698 = -_41.x;
    }
    _50.x = _698;
    _113 = (_50.xxxx * float4(0.015625f, 0.140625f, 0.390625f, 0.765625f)) + _18.xxxx;
    _50 = (_9 * _113.xxx) + vs_TEXCOORD1;
    _18 = max(_50.z, 0.0f);
    _18 = (_18 * vs_TEXCOORD2.x) + _269_m3;
    _201.x = dot(_50.xy, _50.xy);
    _201.x = sqrt(_201.x);
    _18 = _201.x / _18;
    _18 = clamp(_18, 0.0f, 1.0f);
    _18 = ((-_18) * _18) + 1.0f;
    _201.x = dot(_50, _50);
    _201.x = sqrt(_201.x);
    _765 = _201.x / _269_m5;
    _772 = _201.x / _269_m4;
    _772 = (-_772) + 1.0f;
    _772 = clamp(_772, 0.0f, 1.0f);
    _783 = dot(_269_m9[0].xyz, _50);
    _783 += (-_269_m9[0].w);
    _783 /= _269_m7;
    _783 = clamp(_783, 0.0f, 1.0f);
    _801 = dot(_269_m9[1].xyz, _50);
    _801 += (-_269_m9[1].w);
    _801 /= _269_m7;
    _801 = clamp(_801, 0.0f, 1.0f);
    _783 *= _801;
    _801 = dot(_269_m9[2].xyz, _50);
    _801 += (-_269_m9[2].w);
    _801 /= _269_m7;
    _801 = clamp(_801, 0.0f, 1.0f);
    _783 *= _801;
    _801 = dot(_269_m9[3].xyz, _50);
    _801 += (-_269_m9[3].w);
    _801 /= _269_m7;
    _801 = clamp(_801, 0.0f, 1.0f);
    _783 *= _801;
    _801 = (_269_m8 * _269_m8) + 1.0f;
    _866 = _269_m8 + _269_m8;
    _50.x = dot(_50, _9);
    _50.x *= _866;
    _57 = max(_201.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _801;
    _50.x = _801 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _18 *= _18;
    _57 = _772 * _772;
    _18 *= _57;
    _18 = _783 * _18;
    _18 = _50.x * _18;
    _50.x = (_765 * _765) + 1.0f;
    _18 /= _50.x;
    _201 = _113 + (-0.1500000059604644775390625f).xxxx;
    _201 /= float4(float4(_269_m6, _269_m6, _269_m6, _269_m6));
    _201 = clamp(_201, 0.0f.xxxx, 1.0f.xxxx);
    _963 = _113 * _269_m0.xxxx;
    _963 *= (-_963);
    _963 = exp2(_963);
    _201 *= _963;
    _18 *= _201.x;
    _50 = (_9 * _113.yyy) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m3;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _201.x = _294.x / _269_m5;
    _1043 = _294.x / _269_m4;
    _1043 = (-_1043) + 1.0f;
    _1043 = clamp(_1043, 0.0f, 1.0f);
    _1054 = dot(_269_m9[0].xyz, _50);
    _1054 += (-_269_m9[0].w);
    _1054 /= _269_m7;
    _1054 = clamp(_1054, 0.0f, 1.0f);
    _963.x = dot(_269_m9[1].xyz, _50);
    _963.x += (-_269_m9[1].w);
    _963.x /= _269_m7;
    _963.x = clamp(_963.x, 0.0f, 1.0f);
    _1054 *= _963.x;
    _963.x = dot(_269_m9[2].xyz, _50);
    _963.x += (-_269_m9[2].w);
    _963.x /= _269_m7;
    _963.x = clamp(_963.x, 0.0f, 1.0f);
    _1054 *= _963.x;
    _963.x = dot(_269_m9[3].xyz, _50);
    _963.x += (-_269_m9[3].w);
    _963.x /= _269_m7;
    _963.x = clamp(_963.x, 0.0f, 1.0f);
    _1054 *= _963.x;
    _50.x = dot(_50, _9);
    _50.x *= _866;
    _57 = max(_294.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _801;
    _50.x = _801 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _57 = _113.x * _113.x;
    _87 = _1043 * _1043;
    _57 *= _87;
    _57 = _1054 * _57;
    _50.x *= _57;
    _57 = (_201.x * _201.x) + 1.0f;
    _50.x /= _57;
    _50.x = _201.y * _50.x;
    _50.x *= 0.375f;
    _18 = (_18 * 0.125f) + _50.x;
    _50 = (_9 * _113.zzz) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m3;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _1293 = _294.x / _269_m5;
    _201.x = _294.x / _269_m4;
    _201.x = (-_201.x) + 1.0f;
    _201.x = clamp(_201.x, 0.0f, 1.0f);
    _765 = dot(_269_m9[0].xyz, _50);
    _765 += (-_269_m9[0].w);
    _765 /= _269_m7;
    _765 = clamp(_765, 0.0f, 1.0f);
    _1043 = dot(_269_m9[1].xyz, _50);
    _1043 += (-_269_m9[1].w);
    _1043 /= _269_m7;
    _1043 = clamp(_1043, 0.0f, 1.0f);
    _765 *= _1043;
    _1043 = dot(_269_m9[2].xyz, _50);
    _1043 += (-_269_m9[2].w);
    _1043 /= _269_m7;
    _1043 = clamp(_1043, 0.0f, 1.0f);
    _765 *= _1043;
    _1043 = dot(_269_m9[3].xyz, _50);
    _1043 += (-_269_m9[3].w);
    _1043 /= _269_m7;
    _1043 = clamp(_1043, 0.0f, 1.0f);
    _765 *= _1043;
    _50.x = dot(_50, _9);
    _50.x *= _866;
    _57 = max(_294.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _801;
    _50.x = _801 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _57 = _113.x * _113.x;
    _87 = _201.x * _201.x;
    _57 *= _87;
    _57 = _765 * _57;
    _50.x *= _57;
    _57 = (_1293 * _1293) + 1.0f;
    _50.x /= _57;
    _50.x = _201.z * _50.x;
    _18 = (_50.x * 0.625f) + _18;
    _50 = (_9 * _113.www) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m3;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _1293 = _294.x / _269_m5;
    _1528 = _294.x / _269_m4;
    _1528 = (-_1528) + 1.0f;
    _1528 = clamp(_1528, 0.0f, 1.0f);
    _201.x = dot(_269_m9[0].xyz, _50);
    _201.x += (-_269_m9[0].w);
    _765 = dot(_269_m9[1].xyz, _50);
    _201.y = _765 + (-_269_m9[1].w);
    float2 _1573 = _201.xy / float2(float2(_269_m7, _269_m7));
    _201 = float4(_1573.x, _1573.y, _201.z, _201.w);
    float2 _1580 = clamp(_201.xy, 0.0f.xx, 1.0f.xx);
    _201 = float4(_1580.x, _1580.y, _201.z, _201.w);
    _201.x = _201.y * _201.x;
    _765 = dot(_269_m9[2].xyz, _50);
    _765 += (-_269_m9[2].w);
    _765 /= _269_m7;
    _765 = clamp(_765, 0.0f, 1.0f);
    _201.x = _765 * _201.x;
    _765 = dot(_269_m9[3].xyz, _50);
    _765 += (-_269_m9[3].w);
    _765 /= _269_m7;
    _765 = clamp(_765, 0.0f, 1.0f);
    _201.x = _765 * _201.x;
    _9.x = dot(_50, _9);
    _9.x *= _866;
    _1640 = max(_294.x, 0.001000000047497451305389404296875f);
    _9.x /= _1640;
    _9.x += _801;
    _9.x = _801 / _9.x;
    _9.x = log2(_9.x);
    _9.x *= 1.5f;
    _9.x = exp2(_9.x);
    _1640 = _113.x * _113.x;
    _1676 = _1528 * _1528;
    _1640 *= _1676;
    _1640 = _201.x * _1640;
    _9.x *= _1640;
    _1640 = (_1293 * _1293) + 1.0f;
    _9.x /= _1640;
    _9.x = _201.w * _9.x;
    _9.x = (_9.x * 0.875f) + _18;
    _9.x *= _41.x;
    _9.x *= 0.5f;
    _9.x = (-_9.x) * _269_m2;
    _9.x *= 1.44269502162933349609375f;
    _9.x = exp2(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9 = _9.xxx * _269_m1.xyz;
    _655 = float4(_9.x, _9.y, _9.z, _655.w);
    _655.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._655 = _655;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float _LensRadius;
float _HalfAngle;
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
#define _22_m4 _LensRadius
#define _22_m5 _HalfAngle



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _9 += _22_m1[3];
    _50 = _9.yyyy * _22_m3[1];
    _50 = (_22_m3[0] * _9.xxxx) + _50;
    _50 = (_22_m3[2] * _9.zzzz) + _50;
    gl_Position = (_22_m3[3] * _9.wwww) + _50;
    vs_TEXCOORD0 = _11.xyz;
    float3 _95 = _22_m0.yyy * _22_m2[1].xyz;
    _9 = float4(_95.x, _95.y, _95.z, _9.w);
    float3 _107 = (_22_m2[0].xyz * _22_m0.xxx) + _9.xyz;
    _9 = float4(_107.x, _107.y, _107.z, _9.w);
    float3 _119 = (_22_m2[2].xyz * _22_m0.zzz) + _9.xyz;
    _9 = float4(_119.x, _119.y, _119.z, _9.w);
    vs_TEXCOORD1 = _9.xyz + _22_m2[3].xyz;
    _9.x = _22_m5 * 0.01745329238474369049072265625f;
    _50.x = cos(_9.x);
    _9.x = sin(_9.x);
    _9.x /= _50.x;
    vs_TEXCOORD2.y = _22_m4 / _9.x;
    vs_TEXCOORD2.x = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogParams;
float4 _Color;
float _Intensity;
float _LensRadius;
float _Length;
float _Falloff;
float _NearFade;
float _Soft;
float _Phase;
float4 _Planes[4];
#define _269_m0 unity_FogParams
#define _269_m1 _Color
#define _269_m2 _Intensity
#define _269_m3 _LensRadius
#define _269_m4 _Length
#define _269_m5 _Falloff
#define _269_m6 _NearFade
#define _269_m7 _Soft
#define _269_m8 _Phase
#define _269_m9 _Planes



static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _655;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _655 : SV_Target0;
};

static float3 _9;
static float _18;
static float4 _41;
static float3 _50;
static float _57;
static float _87;
static bool4 _103;
static float4 _113;
static bool _153;
static float4 _201;
static bool _280;
static float2 _294;
static bool _319;
static bool _344;
static bool _395;
static bool _415;
static bool _647;
static float _765;
static float _772;
static float _783;
static float _801;
static float _866;
static float4 _963;
static float _1045;
static float _1056;
static float _1295;
static float _1530;
static float _1642;
static float _1678;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-vs_TEXCOORD1);
    _18 = dot(_9, _9);
    _18 = rsqrt(_18);
    _9 = _18.xxx * _9;
    _18 = vs_TEXCOORD2.x * vs_TEXCOORD2.x;
    _41.x = vs_TEXCOORD1.z + vs_TEXCOORD2.y;
    _50.x = dot(_9.xy, _9.xy);
    _57 = _9.z * _9.z;
    _41.y = ((-_57) * _18) + _50.x;
    _57 = dot(vs_TEXCOORD1.xy, _9.xy);
    _18 *= _41.x;
    _57 = ((-_18) * _9.z) + _57;
    _87 = dot(vs_TEXCOORD1.xy, vs_TEXCOORD1.xy);
    _18 = ((-_18) * _41.x) + _87;
    bool2 _110 = bool4(_41.xxxy.x >= 0.0f.xxxx.x, _41.xxxy.y >= 0.0f.xxxx.y, _41.xxxy.z >= 0.0f.xxxx.z, _41.xxxy.w >= 0.0f.xxxx.w).xw;
    _103 = bool4(_110.x, _103.y, _103.z, _110.y);
    _113.x = max(_41.y, 9.9999997473787516355514526367188e-06f);
    _50.x = min(_41.y, -9.9999997473787516355514526367188e-06f);
    float _129;
    if (_103.w)
    {
        _129 = _113.x;
    }
    else
    {
        _129 = _50.x;
    }
    _50.x = _129;
    _87 = _18 * _50.x;
    _87 = (_57 * _57) + (-_87);
    _87 = max(_87, 0.0f);
    _87 = sqrt(_87);
    _153 = 0.0f >= _18;
    _153 = _103.x && _153;
    _41.x = (-_87) + (-_57);
    _41.x /= _50.x;
    float _173;
    if (_153)
    {
        _173 = 0.0f;
    }
    else
    {
        _173 = _41.x;
    }
    _113.x = _173;
    _153 = _50.x < 0.0f;
    _103.x = 0.0f < _9.z;
    _153 = _153 && _103.x;
    _57 = _87 + (-_57);
    _50.x = _57 / _50.x;
    float _203;
    if (_153)
    {
        _203 = 1000000.0f;
    }
    else
    {
        _203 = _50.x;
    }
    _201.y = _203;
    _153 = 9.9999997473787516355514526367188e-06f < abs(_9.z);
    float _217;
    if (_153)
    {
        _217 = _9.z;
    }
    else
    {
        _217 = 9.9999997473787516355514526367188e-06f;
    }
    _18 = _217;
    _18 = (-vs_TEXCOORD1.z) / _18;
    _201.x = max(_18, _113.x);
    _113.y = min(_18, _201.y);
    float2 _242;
    if (_103.x)
    {
        _242 = _201.xy;
    }
    else
    {
        _242 = _113.xy;
    }
    _41 = float4(_242.x, _242.y, _41.z, _41.w);
    _18 = dot(vs_TEXCOORD1, _9);
    _87 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _87 = (_18 * _18) + (-_87);
    _87 = (_269_m4 * _269_m4) + _87;
    _280 = 0.0f < _87;
    _87 = sqrt(_87);
    _18 = (-_18) + _87;
    _18 = min(_18, _41.y);
    _294.y = _280 ? _18 : (-1.0f);
    _18 = dot(_269_m9[0].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[0].w);
    _50.x = dot(_269_m9[0].xyz, _9);
    _319 = 9.9999997473787516355514526367188e-06f < abs(_50.x);
    float _325;
    if (_319)
    {
        _325 = _50.x;
    }
    else
    {
        _325 = 9.9999997473787516355514526367188e-06f;
    }
    _87 = _325;
    _87 = (-_18) / _87;
    _280 = 9.9999997473787516355514526367188e-06f < _50.x;
    _294.x = max(_87, _41.x);
    _344 = _50.x < (-9.9999997473787516355514526367188e-06f);
    _87 = min(_87, _294.y);
    _153 = _18 < 0.0f;
    float _355;
    if (_153)
    {
        _355 = -1.0f;
    }
    else
    {
        _355 = _294.y;
    }
    _18 = _355;
    _41.z = _344 ? _87 : _18;
    float2 _368;
    if (_280)
    {
        _368 = _294;
    }
    else
    {
        _368 = _41.xz;
    }
    _41 = float4(_41.x, _368.x, _368.y, _41.w);
    _18 = dot(_269_m9[1].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[1].w);
    _113.x = dot(_269_m9[1].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _401;
    if (_395)
    {
        _401 = _113.x;
    }
    else
    {
        _401 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _401;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _437;
    if (_153)
    {
        _437 = -1.0f;
    }
    else
    {
        _437 = _41.z;
    }
    _18 = _437;
    float _445;
    if (_280)
    {
        _445 = _294.x;
    }
    else
    {
        _445 = _18;
    }
    _41.w = _445;
    float2 _455;
    if (_415)
    {
        _455 = _41.xz;
    }
    else
    {
        _455 = _41.yw;
    }
    _41 = float4(_41.x, _455.x, _455.y, _41.w);
    _18 = dot(_269_m9[2].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[2].w);
    _113.x = dot(_269_m9[2].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _488;
    if (_395)
    {
        _488 = _113.x;
    }
    else
    {
        _488 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _488;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _523;
    if (_153)
    {
        _523 = -1.0f;
    }
    else
    {
        _523 = _41.z;
    }
    _18 = _523;
    float _531;
    if (_280)
    {
        _531 = _294.x;
    }
    else
    {
        _531 = _18;
    }
    _41.w = _531;
    float2 _541;
    if (_415)
    {
        _541 = _41.xz;
    }
    else
    {
        _541 = _41.yw;
    }
    _41 = float4(_41.x, _541.x, _541.y, _41.w);
    _18 = dot(_269_m9[3].xyz, vs_TEXCOORD1);
    _18 += (-_269_m9[3].w);
    _113.x = dot(_269_m9[3].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _574;
    if (_395)
    {
        _574 = _113.x;
    }
    else
    {
        _574 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _574;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _609;
    if (_153)
    {
        _609 = -1.0f;
    }
    else
    {
        _609 = _41.z;
    }
    _18 = _609;
    float _617;
    if (_280)
    {
        _617 = _294.x;
    }
    else
    {
        _617 = _18;
    }
    _41.w = _617;
    float2 _627;
    if (_415)
    {
        _627 = _41.xz;
    }
    else
    {
        _627 = _41.yw;
    }
    _41 = float4(_627.x, _627.y, _41.z, _41.w);
    _18 = max(_41.x, 0.0f);
    _41.x = (-_18) + _41.y;
    _647 = 0.0f >= _41.x;
    if (_647)
    {
        _655 = float4(0.0f, 0.0f, 0.0f, 1.0f);
        return;
    }
    float3 _664 = (_9 * _18.xxx) + vs_TEXCOORD1;
    _113 = float4(_664.x, _664.y, _664.z, _113.w);
    float3 _672 = (_9 * _41.yyy) + vs_TEXCOORD1;
    _201 = float4(_672.x, _672.y, _672.z, _201.w);
    _57 = dot(_113.xyz, _113.xyz);
    _87 = dot(_201.xyz, _201.xyz);
    _647 = _87 >= _57;
    float _689;
    if (_647)
    {
        _689 = _18;
    }
    else
    {
        _689 = _41.y;
    }
    _18 = _689;
    float _698;
    if (_647)
    {
        _698 = _41.x;
    }
    else
    {
        _698 = -_41.x;
    }
    _50.x = _698;
    _113 = (_50.xxxx * float4(0.015625f, 0.140625f, 0.390625f, 0.765625f)) + _18.xxxx;
    _50 = (_9 * _113.xxx) + vs_TEXCOORD1;
    _18 = max(_50.z, 0.0f);
    _18 = (_18 * vs_TEXCOORD2.x) + _269_m3;
    _201.x = dot(_50.xy, _50.xy);
    _201.x = sqrt(_201.x);
    _18 = _201.x / _18;
    _18 = clamp(_18, 0.0f, 1.0f);
    _18 = ((-_18) * _18) + 1.0f;
    _201.x = dot(_50, _50);
    _201.x = sqrt(_201.x);
    _765 = _201.x / _269_m5;
    _772 = _201.x / _269_m4;
    _772 = (-_772) + 1.0f;
    _772 = clamp(_772, 0.0f, 1.0f);
    _783 = dot(_269_m9[0].xyz, _50);
    _783 += (-_269_m9[0].w);
    _783 /= _269_m7;
    _783 = clamp(_783, 0.0f, 1.0f);
    _801 = dot(_269_m9[1].xyz, _50);
    _801 += (-_269_m9[1].w);
    _801 /= _269_m7;
    _801 = clamp(_801, 0.0f, 1.0f);
    _783 *= _801;
    _801 = dot(_269_m9[2].xyz, _50);
    _801 += (-_269_m9[2].w);
    _801 /= _269_m7;
    _801 = clamp(_801, 0.0f, 1.0f);
    _783 *= _801;
    _801 = dot(_269_m9[3].xyz, _50);
    _801 += (-_269_m9[3].w);
    _801 /= _269_m7;
    _801 = clamp(_801, 0.0f, 1.0f);
    _783 *= _801;
    _801 = (_269_m8 * _269_m8) + 1.0f;
    _866 = _269_m8 + _269_m8;
    _50.x = dot(_50, _9);
    _50.x *= _866;
    _57 = max(_201.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _801;
    _50.x = _801 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _18 *= _18;
    _57 = _772 * _772;
    _18 *= _57;
    _18 = _783 * _18;
    _18 = _50.x * _18;
    _50.x = (_765 * _765) + 1.0f;
    _18 /= _50.x;
    _201 = _113 + (-0.1500000059604644775390625f).xxxx;
    _201 /= float4(float4(_269_m6, _269_m6, _269_m6, _269_m6));
    _201 = clamp(_201, 0.0f.xxxx, 1.0f.xxxx);
    _963 = (_113 * _269_m0.zzzz) + _269_m0.wwww;
    _963 = clamp(_963, 0.0f.xxxx, 1.0f.xxxx);
    _201 *= _963;
    _18 *= _201.x;
    _50 = (_9 * _113.yyy) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m3;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _201.x = _294.x / _269_m5;
    _1045 = _294.x / _269_m4;
    _1045 = (-_1045) + 1.0f;
    _1045 = clamp(_1045, 0.0f, 1.0f);
    _1056 = dot(_269_m9[0].xyz, _50);
    _1056 += (-_269_m9[0].w);
    _1056 /= _269_m7;
    _1056 = clamp(_1056, 0.0f, 1.0f);
    _963.x = dot(_269_m9[1].xyz, _50);
    _963.x += (-_269_m9[1].w);
    _963.x /= _269_m7;
    _963.x = clamp(_963.x, 0.0f, 1.0f);
    _1056 *= _963.x;
    _963.x = dot(_269_m9[2].xyz, _50);
    _963.x += (-_269_m9[2].w);
    _963.x /= _269_m7;
    _963.x = clamp(_963.x, 0.0f, 1.0f);
    _1056 *= _963.x;
    _963.x = dot(_269_m9[3].xyz, _50);
    _963.x += (-_269_m9[3].w);
    _963.x /= _269_m7;
    _963.x = clamp(_963.x, 0.0f, 1.0f);
    _1056 *= _963.x;
    _50.x = dot(_50, _9);
    _50.x *= _866;
    _57 = max(_294.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _801;
    _50.x = _801 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _57 = _113.x * _113.x;
    _87 = _1045 * _1045;
    _57 *= _87;
    _57 = _1056 * _57;
    _50.x *= _57;
    _57 = (_201.x * _201.x) + 1.0f;
    _50.x /= _57;
    _50.x = _201.y * _50.x;
    _50.x *= 0.375f;
    _18 = (_18 * 0.125f) + _50.x;
    _50 = (_9 * _113.zzz) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m3;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _1295 = _294.x / _269_m5;
    _201.x = _294.x / _269_m4;
    _201.x = (-_201.x) + 1.0f;
    _201.x = clamp(_201.x, 0.0f, 1.0f);
    _765 = dot(_269_m9[0].xyz, _50);
    _765 += (-_269_m9[0].w);
    _765 /= _269_m7;
    _765 = clamp(_765, 0.0f, 1.0f);
    _1045 = dot(_269_m9[1].xyz, _50);
    _1045 += (-_269_m9[1].w);
    _1045 /= _269_m7;
    _1045 = clamp(_1045, 0.0f, 1.0f);
    _765 *= _1045;
    _1045 = dot(_269_m9[2].xyz, _50);
    _1045 += (-_269_m9[2].w);
    _1045 /= _269_m7;
    _1045 = clamp(_1045, 0.0f, 1.0f);
    _765 *= _1045;
    _1045 = dot(_269_m9[3].xyz, _50);
    _1045 += (-_269_m9[3].w);
    _1045 /= _269_m7;
    _1045 = clamp(_1045, 0.0f, 1.0f);
    _765 *= _1045;
    _50.x = dot(_50, _9);
    _50.x *= _866;
    _57 = max(_294.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _801;
    _50.x = _801 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _57 = _113.x * _113.x;
    _87 = _201.x * _201.x;
    _57 *= _87;
    _57 = _765 * _57;
    _50.x *= _57;
    _57 = (_1295 * _1295) + 1.0f;
    _50.x /= _57;
    _50.x = _201.z * _50.x;
    _18 = (_50.x * 0.625f) + _18;
    _50 = (_9 * _113.www) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m3;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _1295 = _294.x / _269_m5;
    _1530 = _294.x / _269_m4;
    _1530 = (-_1530) + 1.0f;
    _1530 = clamp(_1530, 0.0f, 1.0f);
    _201.x = dot(_269_m9[0].xyz, _50);
    _201.x += (-_269_m9[0].w);
    _765 = dot(_269_m9[1].xyz, _50);
    _201.y = _765 + (-_269_m9[1].w);
    float2 _1575 = _201.xy / float2(float2(_269_m7, _269_m7));
    _201 = float4(_1575.x, _1575.y, _201.z, _201.w);
    float2 _1582 = clamp(_201.xy, 0.0f.xx, 1.0f.xx);
    _201 = float4(_1582.x, _1582.y, _201.z, _201.w);
    _201.x = _201.y * _201.x;
    _765 = dot(_269_m9[2].xyz, _50);
    _765 += (-_269_m9[2].w);
    _765 /= _269_m7;
    _765 = clamp(_765, 0.0f, 1.0f);
    _201.x = _765 * _201.x;
    _765 = dot(_269_m9[3].xyz, _50);
    _765 += (-_269_m9[3].w);
    _765 /= _269_m7;
    _765 = clamp(_765, 0.0f, 1.0f);
    _201.x = _765 * _201.x;
    _9.x = dot(_50, _9);
    _9.x *= _866;
    _1642 = max(_294.x, 0.001000000047497451305389404296875f);
    _9.x /= _1642;
    _9.x += _801;
    _9.x = _801 / _9.x;
    _9.x = log2(_9.x);
    _9.x *= 1.5f;
    _9.x = exp2(_9.x);
    _1642 = _113.x * _113.x;
    _1678 = _1530 * _1530;
    _1642 *= _1678;
    _1642 = _201.x * _1642;
    _9.x *= _1642;
    _1642 = (_1295 * _1295) + 1.0f;
    _9.x /= _1642;
    _9.x = _201.w * _9.x;
    _9.x = (_9.x * 0.875f) + _18;
    _9.x *= _41.x;
    _9.x *= 0.5f;
    _9.x = (-_9.x) * _269_m2;
    _9.x *= 1.44269502162933349609375f;
    _9.x = exp2(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9 = _9.xxx * _269_m1.xyz;
    _655 = float4(_9.x, _9.y, _9.z, _655.w);
    _655.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._655 = _655;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float _LensRadius;
float _HalfAngle;
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
#define _22_m4 _LensRadius
#define _22_m5 _HalfAngle



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _9 += _22_m1[3];
    _50 = _9.yyyy * _22_m3[1];
    _50 = (_22_m3[0] * _9.xxxx) + _50;
    _50 = (_22_m3[2] * _9.zzzz) + _50;
    gl_Position = (_22_m3[3] * _9.wwww) + _50;
    vs_TEXCOORD0 = _11.xyz;
    float3 _95 = _22_m0.yyy * _22_m2[1].xyz;
    _9 = float4(_95.x, _95.y, _95.z, _9.w);
    float3 _107 = (_22_m2[0].xyz * _22_m0.xxx) + _9.xyz;
    _9 = float4(_107.x, _107.y, _107.z, _9.w);
    float3 _119 = (_22_m2[2].xyz * _22_m0.zzz) + _9.xyz;
    _9 = float4(_119.x, _119.y, _119.z, _9.w);
    vs_TEXCOORD1 = _9.xyz + _22_m2[3].xyz;
    _9.x = _22_m5 * 0.01745329238474369049072265625f;
    _50.x = cos(_9.x);
    _9.x = sin(_9.x);
    _9.x /= _50.x;
    vs_TEXCOORD2.y = _22_m4 / _9.x;
    vs_TEXCOORD2.x = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float _Intensity;
float _LensRadius;
float _Length;
float _Falloff;
float _NearFade;
float _Soft;
float _Phase;
float4 _Planes[4];
#define _269_m0 _Color
#define _269_m1 _Intensity
#define _269_m2 _LensRadius
#define _269_m3 _Length
#define _269_m4 _Falloff
#define _269_m5 _NearFade
#define _269_m6 _Soft
#define _269_m7 _Phase
#define _269_m8 _Planes



static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD2;
static float4 _654;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float2 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _654 : SV_Target0;
};

static float3 _9;
static float _18;
static float4 _41;
static float3 _50;
static float _57;
static float _87;
static bool4 _103;
static float4 _113;
static bool _153;
static float4 _201;
static bool _280;
static float2 _294;
static bool _319;
static bool _344;
static bool _395;
static bool _415;
static bool _646;
static float _764;
static float _771;
static float _782;
static float _800;
static float _865;
static float _1027;
static float _1038;
static float _1055;
static float _1254;
static float _1489;
static float _1601;
static float _1637;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-vs_TEXCOORD1);
    _18 = dot(_9, _9);
    _18 = rsqrt(_18);
    _9 = _18.xxx * _9;
    _18 = vs_TEXCOORD2.x * vs_TEXCOORD2.x;
    _41.x = vs_TEXCOORD1.z + vs_TEXCOORD2.y;
    _50.x = dot(_9.xy, _9.xy);
    _57 = _9.z * _9.z;
    _41.y = ((-_57) * _18) + _50.x;
    _57 = dot(vs_TEXCOORD1.xy, _9.xy);
    _18 *= _41.x;
    _57 = ((-_18) * _9.z) + _57;
    _87 = dot(vs_TEXCOORD1.xy, vs_TEXCOORD1.xy);
    _18 = ((-_18) * _41.x) + _87;
    bool2 _110 = bool4(_41.xxxy.x >= 0.0f.xxxx.x, _41.xxxy.y >= 0.0f.xxxx.y, _41.xxxy.z >= 0.0f.xxxx.z, _41.xxxy.w >= 0.0f.xxxx.w).xw;
    _103 = bool4(_110.x, _103.y, _103.z, _110.y);
    _113.x = max(_41.y, 9.9999997473787516355514526367188e-06f);
    _50.x = min(_41.y, -9.9999997473787516355514526367188e-06f);
    float _129;
    if (_103.w)
    {
        _129 = _113.x;
    }
    else
    {
        _129 = _50.x;
    }
    _50.x = _129;
    _87 = _18 * _50.x;
    _87 = (_57 * _57) + (-_87);
    _87 = max(_87, 0.0f);
    _87 = sqrt(_87);
    _153 = 0.0f >= _18;
    _153 = _103.x && _153;
    _41.x = (-_87) + (-_57);
    _41.x /= _50.x;
    float _173;
    if (_153)
    {
        _173 = 0.0f;
    }
    else
    {
        _173 = _41.x;
    }
    _113.x = _173;
    _153 = _50.x < 0.0f;
    _103.x = 0.0f < _9.z;
    _153 = _153 && _103.x;
    _57 = _87 + (-_57);
    _50.x = _57 / _50.x;
    float _203;
    if (_153)
    {
        _203 = 1000000.0f;
    }
    else
    {
        _203 = _50.x;
    }
    _201.y = _203;
    _153 = 9.9999997473787516355514526367188e-06f < abs(_9.z);
    float _217;
    if (_153)
    {
        _217 = _9.z;
    }
    else
    {
        _217 = 9.9999997473787516355514526367188e-06f;
    }
    _18 = _217;
    _18 = (-vs_TEXCOORD1.z) / _18;
    _201.x = max(_18, _113.x);
    _113.y = min(_18, _201.y);
    float2 _242;
    if (_103.x)
    {
        _242 = _201.xy;
    }
    else
    {
        _242 = _113.xy;
    }
    _41 = float4(_242.x, _242.y, _41.z, _41.w);
    _18 = dot(vs_TEXCOORD1, _9);
    _87 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _87 = (_18 * _18) + (-_87);
    _87 = (_269_m3 * _269_m3) + _87;
    _280 = 0.0f < _87;
    _87 = sqrt(_87);
    _18 = (-_18) + _87;
    _18 = min(_18, _41.y);
    _294.y = _280 ? _18 : (-1.0f);
    _18 = dot(_269_m8[0].xyz, vs_TEXCOORD1);
    _18 += (-_269_m8[0].w);
    _50.x = dot(_269_m8[0].xyz, _9);
    _319 = 9.9999997473787516355514526367188e-06f < abs(_50.x);
    float _325;
    if (_319)
    {
        _325 = _50.x;
    }
    else
    {
        _325 = 9.9999997473787516355514526367188e-06f;
    }
    _87 = _325;
    _87 = (-_18) / _87;
    _280 = 9.9999997473787516355514526367188e-06f < _50.x;
    _294.x = max(_87, _41.x);
    _344 = _50.x < (-9.9999997473787516355514526367188e-06f);
    _87 = min(_87, _294.y);
    _153 = _18 < 0.0f;
    float _355;
    if (_153)
    {
        _355 = -1.0f;
    }
    else
    {
        _355 = _294.y;
    }
    _18 = _355;
    _41.z = _344 ? _87 : _18;
    float2 _368;
    if (_280)
    {
        _368 = _294;
    }
    else
    {
        _368 = _41.xz;
    }
    _41 = float4(_41.x, _368.x, _368.y, _41.w);
    _18 = dot(_269_m8[1].xyz, vs_TEXCOORD1);
    _18 += (-_269_m8[1].w);
    _113.x = dot(_269_m8[1].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _401;
    if (_395)
    {
        _401 = _113.x;
    }
    else
    {
        _401 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _401;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _437;
    if (_153)
    {
        _437 = -1.0f;
    }
    else
    {
        _437 = _41.z;
    }
    _18 = _437;
    float _445;
    if (_280)
    {
        _445 = _294.x;
    }
    else
    {
        _445 = _18;
    }
    _41.w = _445;
    float2 _455;
    if (_415)
    {
        _455 = _41.xz;
    }
    else
    {
        _455 = _41.yw;
    }
    _41 = float4(_41.x, _455.x, _455.y, _41.w);
    _18 = dot(_269_m8[2].xyz, vs_TEXCOORD1);
    _18 += (-_269_m8[2].w);
    _113.x = dot(_269_m8[2].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _488;
    if (_395)
    {
        _488 = _113.x;
    }
    else
    {
        _488 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _488;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _523;
    if (_153)
    {
        _523 = -1.0f;
    }
    else
    {
        _523 = _41.z;
    }
    _18 = _523;
    float _531;
    if (_280)
    {
        _531 = _294.x;
    }
    else
    {
        _531 = _18;
    }
    _41.w = _531;
    float2 _541;
    if (_415)
    {
        _541 = _41.xz;
    }
    else
    {
        _541 = _41.yw;
    }
    _41 = float4(_41.x, _541.x, _541.y, _41.w);
    _18 = dot(_269_m8[3].xyz, vs_TEXCOORD1);
    _18 += (-_269_m8[3].w);
    _113.x = dot(_269_m8[3].xyz, _9);
    _395 = 9.9999997473787516355514526367188e-06f < abs(_113.x);
    float _573;
    if (_395)
    {
        _573 = _113.x;
    }
    else
    {
        _573 = 9.9999997473787516355514526367188e-06f;
    }
    _294.x = _573;
    _294.x = (-_18) / _294.x;
    _415 = 9.9999997473787516355514526367188e-06f < _113.x;
    _41.x = max(_41.y, _294.x);
    _280 = _113.x < (-9.9999997473787516355514526367188e-06f);
    _294.x = min(_41.z, _294.x);
    _153 = _18 < 0.0f;
    float _608;
    if (_153)
    {
        _608 = -1.0f;
    }
    else
    {
        _608 = _41.z;
    }
    _18 = _608;
    float _616;
    if (_280)
    {
        _616 = _294.x;
    }
    else
    {
        _616 = _18;
    }
    _41.w = _616;
    float2 _626;
    if (_415)
    {
        _626 = _41.xz;
    }
    else
    {
        _626 = _41.yw;
    }
    _41 = float4(_626.x, _626.y, _41.z, _41.w);
    _18 = max(_41.x, 0.0f);
    _41.x = (-_18) + _41.y;
    _646 = 0.0f >= _41.x;
    if (_646)
    {
        _654 = float4(0.0f, 0.0f, 0.0f, 1.0f);
        return;
    }
    float3 _663 = (_9 * _18.xxx) + vs_TEXCOORD1;
    _113 = float4(_663.x, _663.y, _663.z, _113.w);
    float3 _671 = (_9 * _41.yyy) + vs_TEXCOORD1;
    _201 = float4(_671.x, _671.y, _671.z, _201.w);
    _57 = dot(_113.xyz, _113.xyz);
    _87 = dot(_201.xyz, _201.xyz);
    _646 = _87 >= _57;
    float _688;
    if (_646)
    {
        _688 = _18;
    }
    else
    {
        _688 = _41.y;
    }
    _18 = _688;
    float _697;
    if (_646)
    {
        _697 = _41.x;
    }
    else
    {
        _697 = -_41.x;
    }
    _50.x = _697;
    _113 = (_50.xxxx * float4(0.015625f, 0.140625f, 0.390625f, 0.765625f)) + _18.xxxx;
    _50 = (_9 * _113.xxx) + vs_TEXCOORD1;
    _18 = max(_50.z, 0.0f);
    _18 = (_18 * vs_TEXCOORD2.x) + _269_m2;
    _201.x = dot(_50.xy, _50.xy);
    _201.x = sqrt(_201.x);
    _18 = _201.x / _18;
    _18 = clamp(_18, 0.0f, 1.0f);
    _18 = ((-_18) * _18) + 1.0f;
    _201.x = dot(_50, _50);
    _201.x = sqrt(_201.x);
    _764 = _201.x / _269_m4;
    _771 = _201.x / _269_m3;
    _771 = (-_771) + 1.0f;
    _771 = clamp(_771, 0.0f, 1.0f);
    _782 = dot(_269_m8[0].xyz, _50);
    _782 += (-_269_m8[0].w);
    _782 /= _269_m6;
    _782 = clamp(_782, 0.0f, 1.0f);
    _800 = dot(_269_m8[1].xyz, _50);
    _800 += (-_269_m8[1].w);
    _800 /= _269_m6;
    _800 = clamp(_800, 0.0f, 1.0f);
    _782 *= _800;
    _800 = dot(_269_m8[2].xyz, _50);
    _800 += (-_269_m8[2].w);
    _800 /= _269_m6;
    _800 = clamp(_800, 0.0f, 1.0f);
    _782 *= _800;
    _800 = dot(_269_m8[3].xyz, _50);
    _800 += (-_269_m8[3].w);
    _800 /= _269_m6;
    _800 = clamp(_800, 0.0f, 1.0f);
    _782 *= _800;
    _800 = (_269_m7 * _269_m7) + 1.0f;
    _865 = _269_m7 + _269_m7;
    _50.x = dot(_50, _9);
    _50.x *= _865;
    _57 = max(_201.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _800;
    _50.x = _800 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _18 *= _18;
    _57 = _771 * _771;
    _18 *= _57;
    _18 = _782 * _18;
    _18 = _50.x * _18;
    _50.x = (_764 * _764) + 1.0f;
    _18 /= _50.x;
    _201 = _113 + (-0.1500000059604644775390625f).xxxx;
    _201 /= float4(float4(_269_m5, _269_m5, _269_m5, _269_m5));
    _201 = clamp(_201, 0.0f.xxxx, 1.0f.xxxx);
    _18 *= _201.x;
    _50 = (_9 * _113.yyy) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m2;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _201.x = _294.x / _269_m4;
    _1027 = _294.x / _269_m3;
    _1027 = (-_1027) + 1.0f;
    _1027 = clamp(_1027, 0.0f, 1.0f);
    _1038 = dot(_269_m8[0].xyz, _50);
    _1038 += (-_269_m8[0].w);
    _1038 /= _269_m6;
    _1038 = clamp(_1038, 0.0f, 1.0f);
    _1055 = dot(_269_m8[1].xyz, _50);
    _1055 += (-_269_m8[1].w);
    _1055 /= _269_m6;
    _1055 = clamp(_1055, 0.0f, 1.0f);
    _1038 *= _1055;
    _1055 = dot(_269_m8[2].xyz, _50);
    _1055 += (-_269_m8[2].w);
    _1055 /= _269_m6;
    _1055 = clamp(_1055, 0.0f, 1.0f);
    _1038 *= _1055;
    _1055 = dot(_269_m8[3].xyz, _50);
    _1055 += (-_269_m8[3].w);
    _1055 /= _269_m6;
    _1055 = clamp(_1055, 0.0f, 1.0f);
    _1038 *= _1055;
    _50.x = dot(_50, _9);
    _50.x *= _865;
    _57 = max(_294.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _800;
    _50.x = _800 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _57 = _113.x * _113.x;
    _87 = _1027 * _1027;
    _57 *= _87;
    _57 = _1038 * _57;
    _50.x *= _57;
    _57 = (_201.x * _201.x) + 1.0f;
    _50.x /= _57;
    _50.x = _201.y * _50.x;
    _50.x *= 0.375f;
    _18 = (_18 * 0.125f) + _50.x;
    _50 = (_9 * _113.zzz) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m2;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _1254 = _294.x / _269_m4;
    _201.x = _294.x / _269_m3;
    _201.x = (-_201.x) + 1.0f;
    _201.x = clamp(_201.x, 0.0f, 1.0f);
    _764 = dot(_269_m8[0].xyz, _50);
    _764 += (-_269_m8[0].w);
    _764 /= _269_m6;
    _764 = clamp(_764, 0.0f, 1.0f);
    _1027 = dot(_269_m8[1].xyz, _50);
    _1027 += (-_269_m8[1].w);
    _1027 /= _269_m6;
    _1027 = clamp(_1027, 0.0f, 1.0f);
    _764 *= _1027;
    _1027 = dot(_269_m8[2].xyz, _50);
    _1027 += (-_269_m8[2].w);
    _1027 /= _269_m6;
    _1027 = clamp(_1027, 0.0f, 1.0f);
    _764 *= _1027;
    _1027 = dot(_269_m8[3].xyz, _50);
    _1027 += (-_269_m8[3].w);
    _1027 /= _269_m6;
    _1027 = clamp(_1027, 0.0f, 1.0f);
    _764 *= _1027;
    _50.x = dot(_50, _9);
    _50.x *= _865;
    _57 = max(_294.x, 0.001000000047497451305389404296875f);
    _50.x /= _57;
    _50.x += _800;
    _50.x = _800 / _50.x;
    _50.x = log2(_50.x);
    _50.x *= 1.5f;
    _50.x = exp2(_50.x);
    _57 = _113.x * _113.x;
    _87 = _201.x * _201.x;
    _57 *= _87;
    _57 = _764 * _57;
    _50.x *= _57;
    _57 = (_1254 * _1254) + 1.0f;
    _50.x /= _57;
    _50.x = _201.z * _50.x;
    _18 = (_50.x * 0.625f) + _18;
    _50 = (_9 * _113.www) + vs_TEXCOORD1;
    _113.x = max(_50.z, 0.0f);
    _113.x = (_113.x * vs_TEXCOORD2.x) + _269_m2;
    _294.x = dot(_50.xy, _50.xy);
    _294.x = sqrt(_294.x);
    _113.x = _294.x / _113.x;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _113.x = ((-_113.x) * _113.x) + 1.0f;
    _294.x = dot(_50, _50);
    _294.x = sqrt(_294.x);
    _1254 = _294.x / _269_m4;
    _1489 = _294.x / _269_m3;
    _1489 = (-_1489) + 1.0f;
    _1489 = clamp(_1489, 0.0f, 1.0f);
    _201.x = dot(_269_m8[0].xyz, _50);
    _201.x += (-_269_m8[0].w);
    _764 = dot(_269_m8[1].xyz, _50);
    _201.y = _764 + (-_269_m8[1].w);
    float2 _1534 = _201.xy / float2(float2(_269_m6, _269_m6));
    _201 = float4(_1534.x, _1534.y, _201.z, _201.w);
    float2 _1541 = clamp(_201.xy, 0.0f.xx, 1.0f.xx);
    _201 = float4(_1541.x, _1541.y, _201.z, _201.w);
    _201.x = _201.y * _201.x;
    _764 = dot(_269_m8[2].xyz, _50);
    _764 += (-_269_m8[2].w);
    _764 /= _269_m6;
    _764 = clamp(_764, 0.0f, 1.0f);
    _201.x = _764 * _201.x;
    _764 = dot(_269_m8[3].xyz, _50);
    _764 += (-_269_m8[3].w);
    _764 /= _269_m6;
    _764 = clamp(_764, 0.0f, 1.0f);
    _201.x = _764 * _201.x;
    _9.x = dot(_50, _9);
    _9.x *= _865;
    _1601 = max(_294.x, 0.001000000047497451305389404296875f);
    _9.x /= _1601;
    _9.x += _800;
    _9.x = _800 / _9.x;
    _9.x = log2(_9.x);
    _9.x *= 1.5f;
    _9.x = exp2(_9.x);
    _1601 = _113.x * _113.x;
    _1637 = _1489 * _1489;
    _1601 *= _1637;
    _1601 = _201.x * _1601;
    _9.x *= _1601;
    _1601 = (_1254 * _1254) + 1.0f;
    _9.x /= _1601;
    _9.x = _201.w * _9.x;
    _9.x = (_9.x * 0.875f) + _18;
    _9.x *= _41.x;
    _9.x *= 0.5f;
    _9.x = (-_9.x) * _269_m1;
    _9.x *= 1.44269502162933349609375f;
    _9.x = exp2(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9 = _9.xxx * _269_m0.xyz;
    _654 = float4(_9.x, _9.y, _9.z, _654.w);
    _654.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._654 = _654;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}