// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Gamemode/Portal" {
Properties {

[Header(Color)] _CoreColor ("Core / Void Color", Color) = (0.015,0,0.035,1)

_ColorA ("Swirl Color (inner)", Color) = (0.1,0.85,1,1)

_ColorB ("Swirl Color (outer)", Color) = (0.55,0.1,1,1)

_RimColor ("Event Horizon / Sparks", Color) = (0.9,0.97,1,1)

_Intensity ("Emissive Intensity", Range(0, 6)) = 1.600000023841858

_Opacity ("Overall Opacity", Range(0, 1)) = 1.0

_VoidOpacity ("Void Opacity (hides BG)", Range(0, 1)) = 0.9200000166893005

_HueOffset ("Hue Offset (per gate)", Range(0, 1)) = 0.0

_HueSpeed ("Hue Cycle Speed", Range(-0.5, 0.5)) = 0.0

[Header(Vortex)] [IntRange] _ArmCount ("Arm Count", Range(1, 16)) = 5.0

[IntRange] _ArmCount2 ("Counter Arm Count", Range(1, 16)) = 3.0

_SwirlSpeed ("Swirl Speed", Range(-8, 8)) = 1.600000023841858

_SwirlTwist ("Spiral Twist", Range(0, 8)) = 2.5999999046325684

_BandSharp ("Arm Sharpness", Range(0.5, 8)) = 2.200000047683716

_SwirlBoost ("Swirl Opacity Boost", Range(0, 4)) = 1.600000023841858

[Header(Flow Detail)] _NoiseTex ("Noise (tiling, R)", 2D) = "gray" { }

_NoiseTile ("Noise Tiling", Range(0.25, 12)) = 2.5

_NoiseAmount ("Noise Amount", Range(0, 1)) = 0.6499999761581421

_FlowSpeed ("Churn Speed", Range(0, 4)) = 0.6000000238418579

[Header(Shape)] _Radius ("Aperture Radius", Range(0.1, 1.4)) = 1.0

_EdgeFade ("Aperture Feather", Range(0.001, 0.5)) = 0.05999999865889549

_CoreSize ("Void Size", Range(0, 0.95)) = 0.20000000298023224

_CoreSoft ("Void Softness", Range(0.01, 1)) = 0.30000001192092896

_HorizonBoost ("Horizon Glow", Range(0, 4)) = 0.800000011920929

_Center ("Center Offset (XY)", Vector) = (0,0,0,0)

_Shape ("Ellipse Scale (XY)", Vector) = (1,1,0,0)

[Header(Outer Rim)] _RimWidth ("Rim Width", Range(0.005, 0.6)) = 0.07000000029802322

_RimPower ("Rim Falloff", Range(0.5, 8)) = 3.0

_RimBoost ("Rim Brightness", Range(0, 6)) = 1.2000000476837158

_RimWobble ("Rim Wobble", Range(0, 0.3)) = 0.029999999329447746

[IntRange] _RimWobbleFreq ("Rim Wobble Freq", Range(1, 20)) = 7.0

[Header(Spark Tunnel)] _SparkAmount ("Spark Amount", Range(0, 4)) = 0.44999998807907104

[IntRange] _SparkCols ("Spark Columns", Range(4, 64)) = 28.0

_SparkRows ("Spark Density (radial)", Range(1, 24)) = 5.0

_SparkSpeed ("Spark Inward Speed", Range(0, 8)) = 1.100000023841858

_SparkSize ("Spark Size", Range(0.02, 0.6)) = 0.12999999523162842

_SparkStretch ("Spark Streak (lower = longer)", Range(0.05, 1)) = 0.1599999964237213

[Header(Stereo Depth)] _ParallaxDepth ("Parallax Depth", Range(0, 0.6)) = 0.1599999964237213

[Header(Render State)] [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 5.0

[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 10.0

[Enum(Off,0,On,1)] _ZWrite ("ZWrite", Float) = 0.0

[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 0.0

}
SubShader {
 Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite [_ZWrite]
 Cull [_Cull]
   Blend [_SrcBlend] [_DstBlend]
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
static float2 vs_TEXCOORD0;
static float2 _88;
static float3 _91;
static float4 _110;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _91 : NORMAL;
    float4 _110 : TANGENT;
    float2 _88 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;
static float _109;
static float3 _126;

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
    vs_TEXCOORD0 = _88;
    _9.x = dot(_91, _91);
    _9.x = rsqrt(_9.x);
    float3 _106 = _9.xxx * _91.zxy;
    _9 = float4(_106.x, _106.y, _106.z, _9.w);
    _109 = dot(_110.xyz, _110.xyz);
    _109 = rsqrt(_109);
    float3 _122 = _109.xxx * _110.yzx;
    _50 = float4(_122.x, _122.y, _122.z, _50.w);
    _126 = _9.xyz * _50.xyz;
    float3 _139 = (_9.zxy * _50.yzx) + (-_126);
    _9 = float4(_139.x, _139.y, _139.z, _9.w);
    float3 _146 = _9.xyz * _110.www;
    _9 = float4(_146.x, _146.y, _146.z, _9.w);
    float3 _156 = _22_m0.yyy * _22_m2[1].xyz;
    _50 = float4(_156.x, _156.y, _156.z, _50.w);
    float3 _168 = (_22_m2[0].xyz * _22_m0.xxx) + _50.xyz;
    _50 = float4(_168.x, _168.y, _168.z, _50.w);
    float3 _180 = (_22_m2[2].xyz * _22_m0.zzz) + _50.xyz;
    _50 = float4(_180.x, _180.y, _180.z, _50.w);
    float3 _188 = _50.xyz + _22_m2[3].xyz;
    _50 = float4(_188.x, _188.y, _188.z, _50.w);
    float3 _196 = _50.xyz + (-_11.xyz);
    _50 = float4(_196.x, _196.y, _196.z, _50.w);
    vs_TEXCOORD1.y = dot(_9.xyz, _50.xyz);
    vs_TEXCOORD1.x = dot(_110.xyz, _50.xyz);
    vs_TEXCOORD1.z = dot(_91, _50.xyz);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _88 = stage_input._88;
    _91 = stage_input._91;
    _110 = stage_input._110;
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
float4 _CoreColor;
float4 _ColorA;
float4 _ColorB;
float4 _RimColor;
float _Intensity;
float _Opacity;
float _VoidOpacity;
float _HueOffset;
float _HueSpeed;
float _ArmCount;
float _ArmCount2;
float _SwirlSpeed;
float _SwirlTwist;
float _BandSharp;
float _SwirlBoost;
float _NoiseTile;
float _NoiseAmount;
float _FlowSpeed;
float _Radius;
float _EdgeFade;
float _CoreSize;
float _CoreSoft;
float _HorizonBoost;
float4 _Center;
float4 _Shape;
float _RimWidth;
float _RimPower;
float _RimBoost;
float _RimWobble;
float _RimWobbleFreq;
float _SparkAmount;
float _SparkCols;
float _SparkRows;
float _SparkSpeed;
float _SparkSize;
float _SparkStretch;
float _ParallaxDepth;
#define _21_m0 _Time
#define _21_m1 _CoreColor
#define _21_m2 _ColorA
#define _21_m3 _ColorB
#define _21_m4 _RimColor
#define _21_m5 _Intensity
#define _21_m6 _Opacity
#define _21_m7 _VoidOpacity
#define _21_m8 _HueOffset
#define _21_m9 _HueSpeed
#define _21_m10 _ArmCount
#define _21_m11 _ArmCount2
#define _21_m12 _SwirlSpeed
#define _21_m13 _SwirlTwist
#define _21_m14 _BandSharp
#define _21_m15 _SwirlBoost
#define _21_m16 _NoiseTile
#define _21_m17 _NoiseAmount
#define _21_m18 _FlowSpeed
#define _21_m19 _Radius
#define _21_m20 _EdgeFade
#define _21_m21 _CoreSize
#define _21_m22 _CoreSoft
#define _21_m23 _HorizonBoost
#define _21_m24 _Center
#define _21_m25 _Shape
#define _21_m26 _RimWidth
#define _21_m27 _RimPower
#define _21_m28 _RimBoost
#define _21_m29 _RimWobble
#define _21_m30 _RimWobbleFreq
#define _21_m31 _SparkAmount
#define _21_m32 _SparkCols
#define _21_m33 _SparkRows
#define _21_m34 _SparkSpeed
#define _21_m35 _SparkSize
#define _21_m36 _SparkStretch
#define _21_m37 _ParallaxDepth


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float2 vs_TEXCOORD0;
static float4 _115;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _115 : SV_Target0;
};

static float2 _9;
static float2 _30;
static float _56;
static float4 _67;
static bool _108;
static float _135;
static float4 _149;
static float _203;
static float4 _219;
static bool _250;
static bool _280;
static bool _307;
static float4 _371;
static float3 _404;
static float2 _427;
static float2 _431;
static float _460;
static float2 _576;
static float _664;
static float _674;
static float _691;
static float _702;
static float2 _898;
static bool _931;
static bool _989;
static bool _996;
static float _1029;
static float _1202;

void frag_inner()
{
    _9 = vs_TEXCOORD0.yx + (-0.5f).xx;
    _9 += (-_21_m24.yx);
    _30 = max(abs(_21_m25.yx), 0.001000000047497451305389404296875f.xx);
    _9 /= _30;
    _9 += _9;
    _30.x = dot(_9, _9);
    _30.x = sqrt(_30.x);
    _56 = (-_21_m20) + _21_m19;
    _67.x = (-_56) + _21_m19;
    _56 = (-_56) + _30.x;
    _67.x = 1.0f / _67.x;
    _56 *= _67.x;
    _56 = clamp(_56, 0.0f, 1.0f);
    _67.x = (_56 * (-2.0f)) + 3.0f;
    _56 *= _56;
    _56 = ((-_67.x) * _56) + 1.0f;
    _108 = 0.0f >= _56;
    if (_108)
    {
        _115 = 0.0f.xxxx;
        return;
    }
    _67.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _67.x = rsqrt(_67.x);
    float3 _132 = _67.xxx * vs_TEXCOORD1;
    _67 = float4(_132.x, _132.y, _132.z, _67.w);
    _135 = max(abs(_67.z), 0.25f);
    float2 _146 = _67.yx / _135.xx;
    _67 = float4(_146.x, _146.y, _67.z, _67.w);
    float2 _165 = ((-_67.yx) * float2(float2(_21_m37, _21_m37))) + _9.yx;
    _149 = float4(_149.x, _165.x, _165.y, _149.w);
    _135 = _21_m37 * 2.5f;
    _9 = ((-_67.xy) * _135.xx) + _9;
    _67.x = dot(_149.yz, _149.yz);
    _67.y = sqrt(_67.x);
    float2 _193 = -_149.yz;
    _149 = float4(_193.x, _149.y, _149.z, _193.y);
    _135 = min(abs(_149.y), abs(_149.z));
    _203 = max(abs(_149.y), abs(_149.z));
    _203 = 1.0f / _203;
    _135 = _203 * _135;
    _203 = _135 * _135;
    _219.x = (_203 * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _219.x = (_203 * _219.x) + 0.1801410019397735595703125f;
    _219.x = (_203 * _219.x) + (-0.33029949665069580078125f);
    _203 = (_203 * _219.x) + 0.999866008758544921875f;
    _219.x = _203 * _135;
    _250 = abs(_149.y) < abs(_149.z);
    _219.x = (_219.x * (-2.0f)) + 1.57079637050628662109375f;
    float _266;
    if (_250)
    {
        _266 = _219.x;
    }
    else
    {
        _266 = 0.0f;
    }
    _219.x = _266;
    _135 = (_135 * _203) + _219.x;
    _280 = _149.y < _149.x;
    _203 = _280 ? (-3.1415927410125732421875f) : 0.0f;
    _135 = _203 + _135;
    _203 = min(_149.y, _149.z);
    _149.x = max(_149.y, _149.z);
    _280 = _203 < (-_203);
    _307 = _149.x >= (-_149.x);
    _280 = _280 && _307;
    float _318;
    if (_280)
    {
        _318 = -_135;
    }
    else
    {
        _318 = _135;
    }
    _135 = _318;
    float3 _331 = max(_67.xyy, float3(9.9999999747524270787835121154785e-07f, 0.001000000047497451305389404296875f, 0.0599999986588954925537109375f));
    _67 = float4(_331.x, _331.y, _67.z, _331.z);
    _203 = log2(_67.w);
    _203 *= _21_m13;
    float2 _352 = float2(_21_m10, _21_m11) + 0.5f.xx;
    _219 = float4(_352.x, _352.y, _219.z, _219.w);
    float2 _362 = float2(_21_m30, _21_m32) + 0.5f.xx;
    _219 = float4(_219.x, _219.y, _362.x, _362.y);
    _219 = floor(_219);
    _219 = max(_219, float4(1.0f, 1.0f, 1.0f, 2.0f));
    _371 = _203.xxxx * float4(0.693147182464599609375f, 0.4505456387996673583984375f, 0.3465735912322998046875f, 0.65848982334136962890625f);
    _203 = (_135 * _219.x) + _371.x;
    _149.x = _21_m0.y * _21_m12;
    _203 = ((-_21_m0.y) * _21_m12) + _203;
    _404.x = (_135 * _219.y) + (-_371.y);
    _149.x = (_149.x * 0.550000011920928955078125f) + _404.x;
    float2 _424 = ddx_coarse(_149.yz);
    _371 = float4(_424.x, _424.y, _371.z, _371.w);
    _427 = ddy_coarse(_149.yz);
    _431 = _149.yz * _21_m13.xx;
    float2 _444 = (_219.xx * _149.wy) + _431;
    _219 = float4(_444.x, _444.y, _219.z, _219.w);
    float2 _451 = _219.xy / _67.xx;
    _219 = float4(_451.x, _451.y, _219.z, _219.w);
    _67.x = dot(_219.xy, _371.xy);
    _460 = dot(_219.xy, _427);
    _67.x = abs(_67.x) + abs(_460);
    _67.x = (_67.x * 1.7000000476837158203125f) + 1.0f;
    _67.x = 1.0f / _67.x;
    _203 = sin(_203);
    _203 = (_203 * 0.5f) + 0.5f;
    _203 = log2(_203);
    _203 *= _21_m14;
    _203 = exp2(_203);
    _149.x = sin(_149.x);
    _149.x = _67.x * _149.x;
    _203 += (-0.550000011920928955078125f);
    _67.x = (_67.x * _203) + 0.550000011920928955078125f;
    _203 = (_149.x * 0.5f) + 0.5f;
    _203 *= 0.3499999940395355224609375f;
    _67.x = (_67.x * 0.800000011920928955078125f) + _203;
    _203 = _21_m0.y * _21_m18;
    _203 = (_203 * 0.550000011920928955078125f) + _371.z;
    _149.x = (-_21_m0.y) * _21_m18;
    _149.x = (_149.x * 0.319999992847442626953125f) + _371.w;
    _219.x = sin(_203);
    _371.x = cos(_203);
    _427.x = cos(_149.x);
    _149.x = sin(_149.x);
    float2 _573 = _149.zy * _219.xx;
    _219 = float4(_573.x, _573.y, _219.z, _219.w);
    _576.x = (_149.y * _371.x) + (-_219.x);
    _576.y = (_149.z * _371.x) + _219.y;
    float2 _606 = _576 * float2(float2(_21_m16, _21_m16));
    _219 = float4(_606.x, _606.y, _219.z, _219.w);
    float2 _612 = (_219.xy * 0.5f.xx) + 0.5f.xx;
    _219 = float4(_612.x, _612.y, _219.z, _219.w);
    float2 _619 = _149.xx * _149.zy;
    _149 = float4(_619.x, _149.y, _149.z, _619.y);
    _149.x = (_149.y * _427.x) + (-_149.x);
    _149.y = (_149.z * _427.x) + _149.w;
    float2 _651 = _149.xy * float2(float2(_21_m16, _21_m16));
    _149 = float4(_651.x, _651.y, _149.z, _149.w);
    float2 _661 = (_149.xy * 0.310000002384185791015625f.xx) + 0.17000000178813934326171875f.xx;
    _149 = float4(_661.x, _661.y, _149.z, _149.w);
    _664 = _NoiseTex.Sample(sampler_NoiseTex, _219.xy).x;
    _674 = _NoiseTex.Sample(sampler_NoiseTex, _149.xy).x;
    _203 = _664 * _674;
    _149.x = _67.y + (-_21_m21);
    _691 = 1.0f / _21_m22;
    _691 *= _149.x;
    _691 = clamp(_691, 0.0f, 1.0f);
    _702 = (_691 * (-2.0f)) + 3.0f;
    _691 *= _691;
    _691 *= _702;
    _702 = _21_m19 * 0.519999980926513671875f;
    _460 = ((-_21_m19) * 0.5f) + _67.y;
    _702 = 1.0f / _702;
    _702 *= _460;
    _702 = clamp(_702, 0.0f, 1.0f);
    _460 = (_702 * (-2.0f)) + 3.0f;
    _702 *= _702;
    _702 *= _460;
    _702 = ((-_702) * 0.3499999940395355224609375f) + 1.0f;
    _460 = _21_m22 * 1.60000002384185791015625f;
    _460 = max(_460, 0.001000000047497451305389404296875f);
    _460 = abs(_149.x) / _460;
    _460 = (-_460) + 1.0f;
    _460 = max(_460, 0.0f);
    _460 *= _460;
    _219.x = _702 * _691;
    _404.x = (_460 * 0.699999988079071044921875f) + 1.0f;
    _219.x = _404.x * _219.x;
    _404.x = _21_m0.y * 1.7000000476837158203125f;
    _135 = (_135 * _219.z) + _404.x;
    _135 = sin(_135);
    _135 = (_135 * _21_m29) + _21_m19;
    _30.x += (-_135);
    _135 = max(_21_m26, 0.001000000047497451305389404296875f);
    _30.x = abs(_30.x) / _135;
    _30.x = (-_30.x) + 1.0f;
    _30.x = max(_30.x, 0.0f);
    _30.x = log2(_30.x);
    _30.x *= _21_m27;
    _30.x = exp2(_30.x);
    _135 = _67.x * _219.x;
    _203 = (_203 * 2.2000000476837158203125f) + 0.300000011920928955078125f;
    _203 = (_135 * _203) + (-_135);
    _135 = (_21_m17 * _203) + _135;
    _203 = dot(_9, _9);
    _203 = sqrt(_203);
    _219.x = min(abs(_9.y), abs(_9.x));
    _404.x = max(abs(_9.y), abs(_9.x));
    _404.x = 1.0f / _404.x;
    _219.x = _404.x * _219.x;
    _404.x = _219.x * _219.x;
    _898.x = (_404.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _898.x = (_404.x * _898.x) + 0.1801410019397735595703125f;
    _898.x = (_404.x * _898.x) + (-0.33029949665069580078125f);
    _404.x = (_404.x * _898.x) + 0.999866008758544921875f;
    _898.x = _404.x * _219.x;
    _931 = abs(_9.y) < abs(_9.x);
    _898.x = (_898.x * (-2.0f)) + 1.57079637050628662109375f;
    float _945;
    if (_931)
    {
        _945 = _898.x;
    }
    else
    {
        _945 = 0.0f;
    }
    _898.x = _945;
    _219.x = (_219.x * _404.x) + _898.x;
    _250 = _9.y < (-_9.y);
    _404.x = _250 ? (-3.1415927410125732421875f) : 0.0f;
    _219.x = _404.x + _219.x;
    _404.x = min(_9.y, _9.x);
    _9.x = max(_9.y, _9.x);
    _989 = _404.x < (-_404.x);
    _996 = _9.x >= (-_9.x);
    _996 = _996 && _989;
    float _1007;
    if (_996)
    {
        _1007 = -_219.x;
    }
    else
    {
        _1007 = _219.x;
    }
    _9.x = _1007;
    _9.x = _219.w * _9.x;
    _9.x *= 0.15915493667125701904296875f;
    _1029 = max(_203, 0.0599999986588954925537109375f);
    _1029 = log2(_1029);
    _1029 *= _21_m33;
    _203 = _21_m0.y * _21_m34;
    _9.y = (_1029 * 0.693147182464599609375f) + _203;
    _203 = floor(_9.x);
    _219.z = floor(_9.y);
    _404.x = _203 / _219.w;
    _404.x = floor(_404.x);
    _219.x = ((-_219.w) * _404.x) + _203;
    float2 _1080 = _219.xz * float2(127.12999725341796875f, 311.709991455078125f);
    _219 = float4(_1080.x, _1080.y, _219.z, _219.w);
    float2 _1085 = frac(_219.xy);
    _219 = float4(_1085.x, _1085.y, _219.z, _219.w);
    _898 = _219.xy + 34.4199981689453125f.xx;
    _203 = dot(_219.xy, _898);
    float2 _1101 = _203.xx + _219.xy;
    _219 = float4(_1101.x, _1101.y, _219.z, _219.w);
    _203 = _219.y * _219.x;
    _219.x = frac(_203);
    float2 _1113 = frac(_9);
    _371 = float4(_1113.x, _1113.y, _371.z, _371.w);
    _9 = _219.xx * float2(97.12999725341796875f, 13.770000457763671875f);
    float2 _1123 = frac(_9);
    _219 = float4(_219.x, _1123.x, _1123.y, _219.w);
    float2 _1131 = (-_219.xy) + _371.xy;
    _371 = float4(_1131.x, _1131.y, _371.z, _371.w);
    _371.z = _371.y * _21_m36;
    _9.x = (_219.z * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _1029 = dot(_371.xz, _371.xz);
    _1029 = sqrt(_1029);
    _203 = max(_21_m35, 0.001000000047497451305389404296875f);
    _1029 /= _203;
    _1029 = (-_1029) + 1.0f;
    _1029 = max(_1029, 0.0f);
    _1029 = log2(_1029);
    _1029 *= 2.5f;
    _1029 = exp2(_1029);
    _280 = _219.x >= 0.62000000476837158203125f;
    _203 = float(_280);
    _1029 *= _203;
    _1029 *= _21_m31;
    _9.x *= _1029;
    _9.x = _691 * _9.x;
    _1029 = _702 * _9.x;
    _203 = max(_21_m19, 0.001000000047497451305389404296875f);
    _1202 = _67.y / _203;
    _1202 = min(_1202, 1.0f);
    float3 _1218 = (-_21_m2.xyz) + _21_m3.xyz;
    _219 = float4(_1218.x, _1218.y, _1218.z, _219.w);
    float3 _1229 = (_1202.xxx * _219.xyz) + _21_m2.xyz;
    _219 = float4(_1229.x, _1229.y, _1229.z, _219.w);
    _1202 = (_135 * 1.14999997615814208984375f) + 0.3499999940395355224609375f;
    _203 = _135 * _21_m15;
    _203 = _203;
    _203 = clamp(_203, 0.0f, 1.0f);
    float3 _1254 = (_219.xyz * _1202.xxx) + (-_21_m1.xyz);
    _219 = float4(_1254.x, _1254.y, _1254.z, _219.w);
    float3 _1265 = (_203.xxx * _219.xyz) + _21_m1.xyz;
    _219 = float4(_1265.x, _1265.y, _1265.z, _219.w);
    _1202 = _460 * _21_m23;
    _67.x = (_67.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _67.x *= _1202;
    float3 _1292 = (_21_m2.xyz * _67.xxx) + _219.xyz;
    _67 = float4(_1292.x, _1292.y, _67.z, _1292.z);
    _1029 = (_30.x * _21_m28) + _1029;
    float3 _1312 = (_21_m4.xyz * _1029.xxx) + _67.xyw;
    _67 = float4(_1312.x, _1312.y, _67.z, _1312.z);
    _1029 = (_21_m0.y * _21_m9) + _21_m8;
    _1029 *= 6.283185482025146484375f;
    _219.x = sin(_1029);
    _371.x = cos(_1029);
    _404 = _67.wxy * 0.57735025882720947265625f.xxx;
    _404 = (_67.wxy * 0.57735025882720947265625f.xxx) + (-_404.zxy);
    float3 _1349 = _219.xxx * _404;
    _219 = float4(_1349.x, _1349.y, _1349.z, _219.w);
    float3 _1359 = (_67.xyw * _371.xxx) + _219.xyz;
    _219 = float4(_1359.x, _1359.y, _1359.z, _219.w);
    _1029 = dot(0.57735025882720947265625f.xxx, _67.xyw);
    _1029 *= 0.57735025882720947265625f;
    _67.x = (-_371.x) + 1.0f;
    float3 _1379 = (_1029.xxx * _67.xxx) + _219.xyz;
    _67 = float4(_1379.x, _1379.y, _67.z, _1379.z);
    float3 _1388 = _67.xyw * _21_m5.xxx;
    _219 = float4(_1388.x, _1388.y, _1388.z, _219.w);
    _1029 = _21_m19 + (-_21_m21);
    _1029 = 1.0f / _1029;
    _1029 *= _149.x;
    _1029 = clamp(_1029, 0.0f, 1.0f);
    _67.x = (_1029 * (-2.0f)) + 3.0f;
    _1029 *= _1029;
    _1029 *= _67.x;
    _1029 = ((-_1029) * 0.449999988079071044921875f) + 1.0f;
    _1029 *= _21_m7;
    _30.x = (_135 * _21_m15) + _30.x;
    _9.x = (_9.x * _702) + _30.x;
    _9.x = max(_9.x, _1029);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = _56 * _9.x;
    _219.w = _9.x * _21_m6;
    _115 = _219;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._115 = _115;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}