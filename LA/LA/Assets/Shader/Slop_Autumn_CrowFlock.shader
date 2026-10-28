// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Autumn/CrowFlock" {
Properties {

[Header(Texture)] _Atlas ("Crow Atlas  [ body | wing ]", 2D) = "white" { }

_Cutoff ("Alpha Cutoff", Range(0.01, 0.9)) = 0.5

[Header(Colour)] _Color ("Crow Colour", Color) = (0.035,0.035,0.045,1)

_ColorVariance ("Per-Crow Brightness Variance", Range(0, 1)) = 0.30000001192092896

[Header(Orbit)] _RadiusMin ("Orbit Radius Min (m)", Float) = 18.0

_RadiusMax ("Orbit Radius Max (m)", Float) = 55.0

_HeightMin ("Height Above Pivot Min (m)", Float) = 12.0

_HeightMax ("Height Above Pivot Max (m)", Float) = 26.0

_SpeedMin ("Angular Speed Min (rad/s)", Float) = 0.05000000074505806

_SpeedMax ("Angular Speed Max (rad/s)", Float) = 0.15000000596046448

_ReverseChance ("Fraction Flying The Other Way", Range(0, 1)) = 0.30000001192092896

[Header(Motion)] _BobAmplitude ("Vertical Bob (m)", Float) = 1.600000023841858

_BobSpeed ("Vertical Bob Speed", Float) = 0.5

_RadiusWobble ("Orbit Wobble (m)", Float) = 4.0

_BankAngle ("Bank Into Turn (deg)", Range(0, 45)) = 14.0

[Header(Wings)] _FlapSpeed ("Flap Speed", Float) = 6.0

_FlapAmplitude ("Flap Height (m)", Float) = 0.25999999046325684

_ScaleMin ("Crow Scale Min", Float) = 0.800000011920929

_ScaleMax ("Crow Scale Max", Float) = 1.350000023841858

}
SubShader {
 LOD 100
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
ZWrite On
  LOD 100
  Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Cull Off
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _26_m2[4];
float4x4 unity_MatrixVP;
static float4 _26_m3[4];
float4 unity_FogParams;
float _RadiusMin;
float _RadiusMax;
float _HeightMin;
float _HeightMax;
float _SpeedMin;
float _SpeedMax;
float _ReverseChance;
float _BobAmplitude;
float _BobSpeed;
float _RadiusWobble;
float _BankAngle;
float _FlapSpeed;
float _FlapAmplitude;
float _ScaleMin;
float _ScaleMax;
float _SlopCrowTimeOffset;
void __unity_init()
{
    _26_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _26_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _26_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _26_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _26_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _26_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _26_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _26_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _26_m0 _Time
#define _26_m1 _ProjectionParams
#define _26_m4 unity_FogParams
#define _26_m5 _RadiusMin
#define _26_m6 _RadiusMax
#define _26_m7 _HeightMin
#define _26_m8 _HeightMax
#define _26_m9 _SpeedMin
#define _26_m10 _SpeedMax
#define _26_m11 _ReverseChance
#define _26_m12 _BobAmplitude
#define _26_m13 _BobSpeed
#define _26_m14 _RadiusWobble
#define _26_m15 _BankAngle
#define _26_m16 _FlapSpeed
#define _26_m17 _FlapAmplitude
#define _26_m18 _ScaleMin
#define _26_m19 _ScaleMax
#define _26_m20 _SlopCrowTimeOffset



static float4 gl_Position;
static float2 _40;
static float4 _244;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _509;

struct SPIRV_Cross_Input
{
    float4 _244 : POSITION;
    float2 _509 : TEXCOORD0;
    float2 _40 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _17;
static float _20;
static float4 _37;
static float4 _67;
static bool _83;
static float4 _90;
static float3 _96;
static float _111;
static float _114;
static float3 _156;
static float3 _187;
static float2 _265;

void vert_inner()
{
    __unity_init();
    _9.z = 0.0f;
    _17.y = 0.0f;
    _20 = (-_26_m9) + _26_m10;
    _37 = (_40.yyyy * 12.98980045318603515625f.xxxx) + float4(78.233001708984375f, 156.46600341796875f, 234.699005126953125f, 312.9320068359375f);
    _37 = sin(_37);
    _37 *= 43758.546875f.xxxx;
    _37 = frac(_37);
    _20 = (_37.y * _20) + _26_m9;
    _67.x = _26_m0.y + _26_m20;
    _20 *= _67.x;
    _83 = _37.z < _26_m11;
    _90.x = _83 ? (-1.0f) : 1.0f;
    _96 = _37.www * float3(6.283185482025146484375f, 10.681415557861328125f, 18.84955596923828125f);
    _20 = (_20 * _90.x) + _96.x;
    _111 = sin(_20);
    _114 = cos(_20);
    _17.x = -_111;
    _17.z = _114;
    float3 _125 = _17 * _90.xxx;
    _90 = float4(_90.x, _125.x, _125.y, _125.z);
    float2 _131 = _90.wy * float2(1.0f, 0.0f);
    _9 = float4(_131.x, _131.y, _9.z, _9.w);
    float3 _141 = ((-_90.xwy) * float3(0.0f, 0.0f, 1.0f)) + _9.xyz;
    _9 = float4(_141.x, _141.y, _141.z, _9.w);
    _20 = _90.x * _26_m15;
    _20 *= 0.01745329238474369049072265625f;
    _90.x = sin(_20);
    _156.x = cos(_20);
    _20 = dot(_9.xz, _9.xz);
    _20 = rsqrt(_20);
    float3 _171 = _20.xxx * _9.xyz;
    _9 = float4(_171.x, _171.y, _171.z, _9.w);
    _17 = _9.yzx * _90.wyz;
    _17 = (_90.zwy * _9.zxy) + (-_17);
    _187 = _90.xxx * _17;
    _17 = _156.xxx * _17;
    _17 = ((-_9.xyz) * _90.xxx) + _17;
    float3 _210 = (_9.xyz * _156.xxx) + _187;
    _9 = float4(_210.x, _210.y, _210.z, _9.w);
    _20 = (_40.y * 12.98980045318603515625f) + 391.165008544921875f;
    _20 = sin(_20);
    _20 *= 43758.546875f;
    _20 = frac(_20);
    _90.x = (-_26_m18) + _26_m19;
    _20 = (_20 * _90.x) + _26_m18;
    _187 = _20.xxx * _244.xyz;
    _90.x = _40.y * 12.98980045318603515625f;
    _90.x = sin(_90.x);
    _90.x *= 43758.546875f;
    _90.x = frac(_90.x);
    _265 = (-float2(_26_m5, _26_m7)) + float2(_26_m6, _26_m8);
    _90.x = (_90.x * _265.x) + _26_m5;
    _265.x = (_37.x * _265.y) + _26_m7;
    vs_TEXCOORD1 = _37.x;
    _37.x = (_67.x * 0.310000002384185791015625f) + _96.y;
    float2 _324 = (_67.xx * float2(_26_m13, _26_m16)) + _96.xz;
    _96 = float3(_324.x, _324.y, _96.z);
    float2 _329 = sin(_96.xy);
    _96 = float3(_329.x, _329.y, _96.z);
    _67.x = sin(_37.x);
    _67.x = (_67.x * _26_m14) + _90.x;
    _156.x = _67.x * _114;
    _156.z = _67.x * _111;
    _156.y = (_96.x * _26_m12) + _265.x;
    _67.x = _96.y * _26_m17;
    _67.x *= _40.x;
    _20 = (_67.x * _20) + _187.y;
    float3 _392 = (_9.xyz * _187.xxx) + _156;
    _9 = float4(_392.x, _392.y, _392.z, _9.w);
    float3 _401 = (_17 * _20.xxx) + _9.xyz;
    _9 = float4(_401.x, _401.y, _401.z, _9.w);
    float3 _411 = (_90.yzw * _187.zzz) + _9.xyz;
    _9 = float4(_411.x, _411.y, _411.z, _9.w);
    _67 = _9.yyyy * _26_m2[1];
    _67 = (_26_m2[0] * _9.xxxx) + _67;
    _9 = (_26_m2[2] * _9.zzzz) + _67;
    _9 += _26_m2[3];
    _67 = _9.yyyy * _26_m3[1];
    _67 = (_26_m3[0] * _9.xxxx) + _67;
    _67 = (_26_m3[2] * _9.zzzz) + _67;
    _9 = (_26_m3[3] * _9.wwww) + _67;
    gl_Position = _9;
    _9.x = _9.z / _26_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _26_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _26_m4.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    vs_TEXCOORD0 = _509;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _40 = stage_input._40;
    _244 = stage_input._244;
    _509 = stage_input._509;
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
float4 unity_FogColor;
float _Cutoff;
float4 _Color;
float _ColorVariance;
#define _30_m0 unity_FogColor
#define _30_m1 _Cutoff
#define _30_m2 _Color
#define _30_m3 _ColorVariance


Texture2D<float4> _Atlas;
SamplerState sampler_Atlas;

static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _104;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _104 : SV_Target0;
};

static float4 _9;
static float3 _22;
static bool _42;
static float _56;
static float3 _78;

void frag_inner()
{
    _9 = _Atlas.Sample(sampler_Atlas, vs_TEXCOORD0);
    _22.x = _9.w + (-_30_m1);
    _42 = _22.x < 0.0f;
    if ((int(_42) * (-1)) != 0)
    {
        discard;
    }
    _56 = ((-_30_m3) * 0.5f) + 1.0f;
    _56 = (vs_TEXCOORD1 * _30_m3) + _56;
    _22 = _9.xyz * _56.xxx;
    _78 = (_30_m2.xyz * _22) + (-_30_m0.xyz);
    _56 = vs_TEXCOORD2;
    _56 = clamp(_56, 0.0f, 1.0f);
    _78 = (_56.xxx * _78) + _30_m0.xyz;
    _104 = float4(_78.x, _78.y, _78.z, _104.w);
    _104.w = _30_m2.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._104 = _104;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _26_m2[4];
float4x4 unity_MatrixVP;
static float4 _26_m3[4];
float4 unity_FogParams;
float _RadiusMin;
float _RadiusMax;
float _HeightMin;
float _HeightMax;
float _SpeedMin;
float _SpeedMax;
float _ReverseChance;
float _BobAmplitude;
float _BobSpeed;
float _RadiusWobble;
float _BankAngle;
float _FlapSpeed;
float _FlapAmplitude;
float _ScaleMin;
float _ScaleMax;
float _SlopCrowTimeOffset;
void __unity_init()
{
    _26_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _26_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _26_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _26_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _26_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _26_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _26_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _26_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _26_m0 _Time
#define _26_m1 _ProjectionParams
#define _26_m4 unity_FogParams
#define _26_m5 _RadiusMin
#define _26_m6 _RadiusMax
#define _26_m7 _HeightMin
#define _26_m8 _HeightMax
#define _26_m9 _SpeedMin
#define _26_m10 _SpeedMax
#define _26_m11 _ReverseChance
#define _26_m12 _BobAmplitude
#define _26_m13 _BobSpeed
#define _26_m14 _RadiusWobble
#define _26_m15 _BankAngle
#define _26_m16 _FlapSpeed
#define _26_m17 _FlapAmplitude
#define _26_m18 _ScaleMin
#define _26_m19 _ScaleMax
#define _26_m20 _SlopCrowTimeOffset



static float4 gl_Position;
static float2 _40;
static float4 _244;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _515;

struct SPIRV_Cross_Input
{
    float4 _244 : POSITION;
    float2 _515 : TEXCOORD0;
    float2 _40 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _17;
static float _20;
static float4 _37;
static float4 _67;
static bool _83;
static float4 _90;
static float3 _96;
static float _111;
static float _114;
static float3 _156;
static float3 _187;
static float2 _265;

void vert_inner()
{
    __unity_init();
    _9.z = 0.0f;
    _17.y = 0.0f;
    _20 = (-_26_m9) + _26_m10;
    _37 = (_40.yyyy * 12.98980045318603515625f.xxxx) + float4(78.233001708984375f, 156.46600341796875f, 234.699005126953125f, 312.9320068359375f);
    _37 = sin(_37);
    _37 *= 43758.546875f.xxxx;
    _37 = frac(_37);
    _20 = (_37.y * _20) + _26_m9;
    _67.x = _26_m0.y + _26_m20;
    _20 *= _67.x;
    _83 = _37.z < _26_m11;
    _90.x = _83 ? (-1.0f) : 1.0f;
    _96 = _37.www * float3(6.283185482025146484375f, 10.681415557861328125f, 18.84955596923828125f);
    _20 = (_20 * _90.x) + _96.x;
    _111 = sin(_20);
    _114 = cos(_20);
    _17.x = -_111;
    _17.z = _114;
    float3 _125 = _17 * _90.xxx;
    _90 = float4(_90.x, _125.x, _125.y, _125.z);
    float2 _131 = _90.wy * float2(1.0f, 0.0f);
    _9 = float4(_131.x, _131.y, _9.z, _9.w);
    float3 _141 = ((-_90.xwy) * float3(0.0f, 0.0f, 1.0f)) + _9.xyz;
    _9 = float4(_141.x, _141.y, _141.z, _9.w);
    _20 = _90.x * _26_m15;
    _20 *= 0.01745329238474369049072265625f;
    _90.x = sin(_20);
    _156.x = cos(_20);
    _20 = dot(_9.xz, _9.xz);
    _20 = rsqrt(_20);
    float3 _171 = _20.xxx * _9.xyz;
    _9 = float4(_171.x, _171.y, _171.z, _9.w);
    _17 = _9.yzx * _90.wyz;
    _17 = (_90.zwy * _9.zxy) + (-_17);
    _187 = _90.xxx * _17;
    _17 = _156.xxx * _17;
    _17 = ((-_9.xyz) * _90.xxx) + _17;
    float3 _210 = (_9.xyz * _156.xxx) + _187;
    _9 = float4(_210.x, _210.y, _210.z, _9.w);
    _20 = (_40.y * 12.98980045318603515625f) + 391.165008544921875f;
    _20 = sin(_20);
    _20 *= 43758.546875f;
    _20 = frac(_20);
    _90.x = (-_26_m18) + _26_m19;
    _20 = (_20 * _90.x) + _26_m18;
    _187 = _20.xxx * _244.xyz;
    _90.x = _40.y * 12.98980045318603515625f;
    _90.x = sin(_90.x);
    _90.x *= 43758.546875f;
    _90.x = frac(_90.x);
    _265 = (-float2(_26_m5, _26_m7)) + float2(_26_m6, _26_m8);
    _90.x = (_90.x * _265.x) + _26_m5;
    _265.x = (_37.x * _265.y) + _26_m7;
    vs_TEXCOORD1 = _37.x;
    _37.x = (_67.x * 0.310000002384185791015625f) + _96.y;
    float2 _324 = (_67.xx * float2(_26_m13, _26_m16)) + _96.xz;
    _96 = float3(_324.x, _324.y, _96.z);
    float2 _329 = sin(_96.xy);
    _96 = float3(_329.x, _329.y, _96.z);
    _67.x = sin(_37.x);
    _67.x = (_67.x * _26_m14) + _90.x;
    _156.x = _67.x * _114;
    _156.z = _67.x * _111;
    _156.y = (_96.x * _26_m12) + _265.x;
    _67.x = _96.y * _26_m17;
    _67.x *= _40.x;
    _20 = (_67.x * _20) + _187.y;
    float3 _392 = (_9.xyz * _187.xxx) + _156;
    _9 = float4(_392.x, _392.y, _392.z, _9.w);
    float3 _401 = (_17 * _20.xxx) + _9.xyz;
    _9 = float4(_401.x, _401.y, _401.z, _9.w);
    float3 _411 = (_90.yzw * _187.zzz) + _9.xyz;
    _9 = float4(_411.x, _411.y, _411.z, _9.w);
    _67 = _9.yyyy * _26_m2[1];
    _67 = (_26_m2[0] * _9.xxxx) + _67;
    _9 = (_26_m2[2] * _9.zzzz) + _67;
    _9 += _26_m2[3];
    _67 = _9.yyyy * _26_m3[1];
    _67 = (_26_m3[0] * _9.xxxx) + _67;
    _67 = (_26_m3[2] * _9.zzzz) + _67;
    _9 = (_26_m3[3] * _9.wwww) + _67;
    gl_Position = _9;
    _9.x = _9.z / _26_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _26_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _26_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    vs_TEXCOORD0 = _515;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _40 = stage_input._40;
    _244 = stage_input._244;
    _515 = stage_input._515;
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
float4 unity_FogColor;
float _Cutoff;
float4 _Color;
float _ColorVariance;
#define _30_m0 unity_FogColor
#define _30_m1 _Cutoff
#define _30_m2 _Color
#define _30_m3 _ColorVariance


Texture2D<float4> _Atlas;
SamplerState sampler_Atlas;

static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _104;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _104 : SV_Target0;
};

static float4 _9;
static float3 _22;
static bool _42;
static float _56;
static float3 _78;

void frag_inner()
{
    _9 = _Atlas.Sample(sampler_Atlas, vs_TEXCOORD0);
    _22.x = _9.w + (-_30_m1);
    _42 = _22.x < 0.0f;
    if ((int(_42) * (-1)) != 0)
    {
        discard;
    }
    _56 = ((-_30_m3) * 0.5f) + 1.0f;
    _56 = (vs_TEXCOORD1 * _30_m3) + _56;
    _22 = _9.xyz * _56.xxx;
    _78 = (_30_m2.xyz * _22) + (-_30_m0.xyz);
    _56 = vs_TEXCOORD2;
    _56 = clamp(_56, 0.0f, 1.0f);
    _78 = (_56.xxx * _78) + _30_m0.xyz;
    _104 = float4(_78.x, _78.y, _78.z, _104.w);
    _104.w = _30_m2.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._104 = _104;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _26_m2[4];
float4x4 unity_MatrixVP;
static float4 _26_m3[4];
float4 unity_FogParams;
float _RadiusMin;
float _RadiusMax;
float _HeightMin;
float _HeightMax;
float _SpeedMin;
float _SpeedMax;
float _ReverseChance;
float _BobAmplitude;
float _BobSpeed;
float _RadiusWobble;
float _BankAngle;
float _FlapSpeed;
float _FlapAmplitude;
float _ScaleMin;
float _ScaleMax;
float _SlopCrowTimeOffset;
void __unity_init()
{
    _26_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _26_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _26_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _26_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _26_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _26_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _26_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _26_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _26_m0 _Time
#define _26_m1 _ProjectionParams
#define _26_m4 unity_FogParams
#define _26_m5 _RadiusMin
#define _26_m6 _RadiusMax
#define _26_m7 _HeightMin
#define _26_m8 _HeightMax
#define _26_m9 _SpeedMin
#define _26_m10 _SpeedMax
#define _26_m11 _ReverseChance
#define _26_m12 _BobAmplitude
#define _26_m13 _BobSpeed
#define _26_m14 _RadiusWobble
#define _26_m15 _BankAngle
#define _26_m16 _FlapSpeed
#define _26_m17 _FlapAmplitude
#define _26_m18 _ScaleMin
#define _26_m19 _ScaleMax
#define _26_m20 _SlopCrowTimeOffset



static float4 gl_Position;
static float2 _40;
static float4 _244;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _508;

struct SPIRV_Cross_Input
{
    float4 _244 : POSITION;
    float2 _508 : TEXCOORD0;
    float2 _40 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _17;
static float _20;
static float4 _37;
static float4 _67;
static bool _83;
static float4 _90;
static float3 _96;
static float _111;
static float _114;
static float3 _156;
static float3 _187;
static float2 _265;

void vert_inner()
{
    __unity_init();
    _9.z = 0.0f;
    _17.y = 0.0f;
    _20 = (-_26_m9) + _26_m10;
    _37 = (_40.yyyy * 12.98980045318603515625f.xxxx) + float4(78.233001708984375f, 156.46600341796875f, 234.699005126953125f, 312.9320068359375f);
    _37 = sin(_37);
    _37 *= 43758.546875f.xxxx;
    _37 = frac(_37);
    _20 = (_37.y * _20) + _26_m9;
    _67.x = _26_m0.y + _26_m20;
    _20 *= _67.x;
    _83 = _37.z < _26_m11;
    _90.x = _83 ? (-1.0f) : 1.0f;
    _96 = _37.www * float3(6.283185482025146484375f, 10.681415557861328125f, 18.84955596923828125f);
    _20 = (_20 * _90.x) + _96.x;
    _111 = sin(_20);
    _114 = cos(_20);
    _17.x = -_111;
    _17.z = _114;
    float3 _125 = _17 * _90.xxx;
    _90 = float4(_90.x, _125.x, _125.y, _125.z);
    float2 _131 = _90.wy * float2(1.0f, 0.0f);
    _9 = float4(_131.x, _131.y, _9.z, _9.w);
    float3 _141 = ((-_90.xwy) * float3(0.0f, 0.0f, 1.0f)) + _9.xyz;
    _9 = float4(_141.x, _141.y, _141.z, _9.w);
    _20 = _90.x * _26_m15;
    _20 *= 0.01745329238474369049072265625f;
    _90.x = sin(_20);
    _156.x = cos(_20);
    _20 = dot(_9.xz, _9.xz);
    _20 = rsqrt(_20);
    float3 _171 = _20.xxx * _9.xyz;
    _9 = float4(_171.x, _171.y, _171.z, _9.w);
    _17 = _9.yzx * _90.wyz;
    _17 = (_90.zwy * _9.zxy) + (-_17);
    _187 = _90.xxx * _17;
    _17 = _156.xxx * _17;
    _17 = ((-_9.xyz) * _90.xxx) + _17;
    float3 _210 = (_9.xyz * _156.xxx) + _187;
    _9 = float4(_210.x, _210.y, _210.z, _9.w);
    _20 = (_40.y * 12.98980045318603515625f) + 391.165008544921875f;
    _20 = sin(_20);
    _20 *= 43758.546875f;
    _20 = frac(_20);
    _90.x = (-_26_m18) + _26_m19;
    _20 = (_20 * _90.x) + _26_m18;
    _187 = _20.xxx * _244.xyz;
    _90.x = _40.y * 12.98980045318603515625f;
    _90.x = sin(_90.x);
    _90.x *= 43758.546875f;
    _90.x = frac(_90.x);
    _265 = (-float2(_26_m5, _26_m7)) + float2(_26_m6, _26_m8);
    _90.x = (_90.x * _265.x) + _26_m5;
    _265.x = (_37.x * _265.y) + _26_m7;
    vs_TEXCOORD1 = _37.x;
    _37.x = (_67.x * 0.310000002384185791015625f) + _96.y;
    float2 _324 = (_67.xx * float2(_26_m13, _26_m16)) + _96.xz;
    _96 = float3(_324.x, _324.y, _96.z);
    float2 _329 = sin(_96.xy);
    _96 = float3(_329.x, _329.y, _96.z);
    _67.x = sin(_37.x);
    _67.x = (_67.x * _26_m14) + _90.x;
    _156.x = _67.x * _114;
    _156.z = _67.x * _111;
    _156.y = (_96.x * _26_m12) + _265.x;
    _67.x = _96.y * _26_m17;
    _67.x *= _40.x;
    _20 = (_67.x * _20) + _187.y;
    float3 _392 = (_9.xyz * _187.xxx) + _156;
    _9 = float4(_392.x, _392.y, _392.z, _9.w);
    float3 _401 = (_17 * _20.xxx) + _9.xyz;
    _9 = float4(_401.x, _401.y, _401.z, _9.w);
    float3 _411 = (_90.yzw * _187.zzz) + _9.xyz;
    _9 = float4(_411.x, _411.y, _411.z, _9.w);
    _67 = _9.yyyy * _26_m2[1];
    _67 = (_26_m2[0] * _9.xxxx) + _67;
    _9 = (_26_m2[2] * _9.zzzz) + _67;
    _9 += _26_m2[3];
    _67 = _9.yyyy * _26_m3[1];
    _67 = (_26_m3[0] * _9.xxxx) + _67;
    _67 = (_26_m3[2] * _9.zzzz) + _67;
    _9 = (_26_m3[3] * _9.wwww) + _67;
    gl_Position = _9;
    _9.x = _9.z / _26_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _26_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _26_m4.z) + _26_m4.w;
    vs_TEXCOORD0 = _508;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _40 = stage_input._40;
    _244 = stage_input._244;
    _508 = stage_input._508;
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
float4 unity_FogColor;
float _Cutoff;
float4 _Color;
float _ColorVariance;
#define _30_m0 unity_FogColor
#define _30_m1 _Cutoff
#define _30_m2 _Color
#define _30_m3 _ColorVariance


Texture2D<float4> _Atlas;
SamplerState sampler_Atlas;

static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _104;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _104 : SV_Target0;
};

static float4 _9;
static float3 _22;
static bool _42;
static float _56;
static float3 _78;

void frag_inner()
{
    _9 = _Atlas.Sample(sampler_Atlas, vs_TEXCOORD0);
    _22.x = _9.w + (-_30_m1);
    _42 = _22.x < 0.0f;
    if ((int(_42) * (-1)) != 0)
    {
        discard;
    }
    _56 = ((-_30_m3) * 0.5f) + 1.0f;
    _56 = (vs_TEXCOORD1 * _30_m3) + _56;
    _22 = _9.xyz * _56.xxx;
    _78 = (_30_m2.xyz * _22) + (-_30_m0.xyz);
    _56 = vs_TEXCOORD2;
    _56 = clamp(_56, 0.0f, 1.0f);
    _78 = (_56.xxx * _78) + _30_m0.xyz;
    _104 = float4(_78.x, _78.y, _78.z, _104.w);
    _104.w = _30_m2.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._104 = _104;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _26_m1[4];
float4x4 unity_MatrixVP;
static float4 _26_m2[4];
float _RadiusMin;
float _RadiusMax;
float _HeightMin;
float _HeightMax;
float _SpeedMin;
float _SpeedMax;
float _ReverseChance;
float _BobAmplitude;
float _BobSpeed;
float _RadiusWobble;
float _BankAngle;
float _FlapSpeed;
float _FlapAmplitude;
float _ScaleMin;
float _ScaleMax;
float _SlopCrowTimeOffset;
void __unity_init()
{
    _26_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _26_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _26_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _26_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _26_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _26_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _26_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _26_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _26_m0 _Time
#define _26_m3 _RadiusMin
#define _26_m4 _RadiusMax
#define _26_m5 _HeightMin
#define _26_m6 _HeightMax
#define _26_m7 _SpeedMin
#define _26_m8 _SpeedMax
#define _26_m9 _ReverseChance
#define _26_m10 _BobAmplitude
#define _26_m11 _BobSpeed
#define _26_m12 _RadiusWobble
#define _26_m13 _BankAngle
#define _26_m14 _FlapSpeed
#define _26_m15 _FlapAmplitude
#define _26_m16 _ScaleMin
#define _26_m17 _ScaleMax
#define _26_m18 _SlopCrowTimeOffset



static float4 gl_Position;
static float2 _40;
static float4 _244;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _474;

struct SPIRV_Cross_Input
{
    float4 _244 : POSITION;
    float2 _474 : TEXCOORD0;
    float2 _40 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _17;
static float _20;
static float4 _37;
static float4 _67;
static bool _83;
static float4 _90;
static float3 _96;
static float _111;
static float _114;
static float3 _156;
static float3 _187;
static float2 _265;

void vert_inner()
{
    __unity_init();
    _9.z = 0.0f;
    _17.y = 0.0f;
    _20 = (-_26_m7) + _26_m8;
    _37 = (_40.yyyy * 12.98980045318603515625f.xxxx) + float4(78.233001708984375f, 156.46600341796875f, 234.699005126953125f, 312.9320068359375f);
    _37 = sin(_37);
    _37 *= 43758.546875f.xxxx;
    _37 = frac(_37);
    _20 = (_37.y * _20) + _26_m7;
    _67.x = _26_m0.y + _26_m18;
    _20 *= _67.x;
    _83 = _37.z < _26_m9;
    _90.x = _83 ? (-1.0f) : 1.0f;
    _96 = _37.www * float3(6.283185482025146484375f, 10.681415557861328125f, 18.84955596923828125f);
    _20 = (_20 * _90.x) + _96.x;
    _111 = sin(_20);
    _114 = cos(_20);
    _17.x = -_111;
    _17.z = _114;
    float3 _125 = _17 * _90.xxx;
    _90 = float4(_90.x, _125.x, _125.y, _125.z);
    float2 _131 = _90.wy * float2(1.0f, 0.0f);
    _9 = float4(_131.x, _131.y, _9.z, _9.w);
    float3 _141 = ((-_90.xwy) * float3(0.0f, 0.0f, 1.0f)) + _9.xyz;
    _9 = float4(_141.x, _141.y, _141.z, _9.w);
    _20 = _90.x * _26_m13;
    _20 *= 0.01745329238474369049072265625f;
    _90.x = sin(_20);
    _156.x = cos(_20);
    _20 = dot(_9.xz, _9.xz);
    _20 = rsqrt(_20);
    float3 _171 = _20.xxx * _9.xyz;
    _9 = float4(_171.x, _171.y, _171.z, _9.w);
    _17 = _9.yzx * _90.wyz;
    _17 = (_90.zwy * _9.zxy) + (-_17);
    _187 = _90.xxx * _17;
    _17 = _156.xxx * _17;
    _17 = ((-_9.xyz) * _90.xxx) + _17;
    float3 _210 = (_9.xyz * _156.xxx) + _187;
    _9 = float4(_210.x, _210.y, _210.z, _9.w);
    _20 = (_40.y * 12.98980045318603515625f) + 391.165008544921875f;
    _20 = sin(_20);
    _20 *= 43758.546875f;
    _20 = frac(_20);
    _90.x = (-_26_m16) + _26_m17;
    _20 = (_20 * _90.x) + _26_m16;
    _187 = _20.xxx * _244.xyz;
    _90.x = _40.y * 12.98980045318603515625f;
    _90.x = sin(_90.x);
    _90.x *= 43758.546875f;
    _90.x = frac(_90.x);
    _265 = (-float2(_26_m3, _26_m5)) + float2(_26_m4, _26_m6);
    _90.x = (_90.x * _265.x) + _26_m3;
    _265.x = (_37.x * _265.y) + _26_m5;
    vs_TEXCOORD1 = _37.x;
    _37.x = (_67.x * 0.310000002384185791015625f) + _96.y;
    float2 _324 = (_67.xx * float2(_26_m11, _26_m14)) + _96.xz;
    _96 = float3(_324.x, _324.y, _96.z);
    float2 _329 = sin(_96.xy);
    _96 = float3(_329.x, _329.y, _96.z);
    _67.x = sin(_37.x);
    _67.x = (_67.x * _26_m12) + _90.x;
    _156.x = _67.x * _114;
    _156.z = _67.x * _111;
    _156.y = (_96.x * _26_m10) + _265.x;
    _67.x = _96.y * _26_m15;
    _67.x *= _40.x;
    _20 = (_67.x * _20) + _187.y;
    float3 _392 = (_9.xyz * _187.xxx) + _156;
    _9 = float4(_392.x, _392.y, _392.z, _9.w);
    float3 _401 = (_17 * _20.xxx) + _9.xyz;
    _9 = float4(_401.x, _401.y, _401.z, _9.w);
    float3 _411 = (_90.yzw * _187.zzz) + _9.xyz;
    _9 = float4(_411.x, _411.y, _411.z, _9.w);
    _67 = _9.yyyy * _26_m1[1];
    _67 = (_26_m1[0] * _9.xxxx) + _67;
    _9 = (_26_m1[2] * _9.zzzz) + _67;
    _9 += _26_m1[3];
    _67 = _9.yyyy * _26_m2[1];
    _67 = (_26_m2[0] * _9.xxxx) + _67;
    _67 = (_26_m2[2] * _9.zzzz) + _67;
    gl_Position = (_26_m2[3] * _9.wwww) + _67;
    vs_TEXCOORD0 = _474;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _40 = stage_input._40;
    _244 = stage_input._244;
    _474 = stage_input._474;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Cutoff;
float4 _Color;
float _ColorVariance;
#define _30_m0 _Cutoff
#define _30_m1 _Color
#define _30_m2 _ColorVariance


Texture2D<float4> _Atlas;
SamplerState sampler_Atlas;

static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _79;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _79 : SV_Target0;
};

static float4 _9;
static float3 _22;
static bool _42;
static float _56;

void frag_inner()
{
    _9 = _Atlas.Sample(sampler_Atlas, vs_TEXCOORD0);
    _22.x = _9.w + (-_30_m0);
    _42 = _22.x < 0.0f;
    if ((int(_42) * (-1)) != 0)
    {
        discard;
    }
    _56 = ((-_30_m2) * 0.5f) + 1.0f;
    _56 = (vs_TEXCOORD1 * _30_m2) + _56;
    _22 = _9.xyz * _56.xxx;
    float3 _85 = _22 * _30_m1.xyz;
    _79 = float4(_85.x, _85.y, _85.z, _79.w);
    _79.w = _30_m1.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._79 = _79;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}