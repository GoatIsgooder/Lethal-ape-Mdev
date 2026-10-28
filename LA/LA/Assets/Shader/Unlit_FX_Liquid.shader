// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Unlit/FX/Liquid" {
Properties {

[Header(Main)] _Tint ("Tint (multiplier)", Color) = (1,1,1,1)

_MainTex ("Texture (optional overlay)", 2D) = "white" { }

_TopColor ("Top Color (backface)", Color) = (1,1,1,1)

[Header(Liquid Gradient)] _DeepColor ("Deep Color (bottom)", Color) = (0.02,0.18,0.05,1)

_MidColor ("Mid Color", Color) = (0.2,1,0.3,1)

_SurfaceColor ("Surface Color (near foam)", Color) = (0.6,1.6,0.5,1)

[Header(Internal Swirl Noise)] _NoiseScale ("Noise Scale", Range(0.1, 100)) = 4.0

_NoiseSpeed ("Noise Scroll Speed", Range(0, 3)) = 0.6000000238418579

_NoiseStrength ("Noise Strength", Range(0, 2)) = 0.699999988079071

_NoiseColorWarp ("Noise → Color Warp", Range(0, 1)) = 0.5

[Header(Radioactive Pulse)] _PulseSpeed ("Pulse Speed", Range(0, 10)) = 2.5

_PulseAmount ("Pulse Amount", Range(0, 1)) = 0.20000000298023224

[Header(Foam)] _FoamColor ("Foam Line Color", Color) = (1.5,2,0.8,1)

_Line ("Foam Line Width", Range(0, 0.1)) = 0.019999999552965164

_LineSmooth ("Foam Line Smoothness", Range(0, 0.1)) = 0.019999999552965164

[Header(Rim)] _RimColor ("Rim Color", Color) = (0.3,1.2,0.5,1)

_RimPower ("Rim Power", Range(0, 10)) = 2.5

[Header(Sine Wobble)] _Freq ("Frequency", Range(0, 15)) = 8.0

_Amplitude ("Amplitude", Range(0, 0.5)) = 0.15000000596046448

}
SubShader {
 Tags { "DisableBatching" = "true" "QUEUE" = "Geometry" }
 Pass {
ZWrite On
  Tags { "DisableBatching" = "true" "QUEUE" = "Geometry" }
 AlphaToMask On
 Cull Off
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float3 _FillAmount;
float _WobbleX;
float _WobbleZ;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _MainTex_ST
#define _21_m6 _FillAmount
#define _21_m7 _WobbleX
#define _21_m8 _WobbleZ



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _119;
static float3 _158;
static float3 _164;
static float3 _166;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _119 : TEXCOORD0;
    float3 _166 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD1 : TEXCOORD0;
    float3 _158 : TEXCOORD1;
    float3 _164 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _50;
static float _78;
static float3 _185;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    _50 = _44.yyyy * _21_m3[1];
    _50 = (_21_m3[0] * _44.xxxx) + _50;
    _50 = (_21_m3[2] * _44.zzzz) + _50;
    _44 = (_21_m3[3] * _44.wwww) + _50;
    _78 = _44.z / _21_m1.y;
    gl_Position = _44;
    _78 = (-_78) + 1.0f;
    _78 *= _21_m1.z;
    _78 = max(_78, 0.0f);
    _78 *= _21_m4.y;
    vs_TEXCOORD1 = exp2(-_78);
    vs_TEXCOORD0 = (_119 * _21_m5.xy) + _21_m5.zw;
    float3 _138 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _44 = float4(_138.x, _138.y, _138.z, _44.w);
    float3 _147 = (-_44.xyz) + _21_m0;
    _44 = float4(_147.x, _147.y, _147.z, _44.w);
    _78 = dot(_44.xyz, _44.xyz);
    _78 = rsqrt(_78);
    _158 = _78.xxx * _44.xyz;
    _164 = _166;
    _44.x = _21_m7;
    _44.z = 0.999999940395355224609375f;
    float3 _181 = _9.xyz + (-_21_m6);
    _50 = float4(_181.x, _181.y, _181.z, _50.w);
    _185.x = dot(float2(-4.3711388286737928865477442741394e-08f, -1.0f), _50.xy);
    _185.y = dot(float2(1.0f, -4.3711388286737928865477442741394e-08f), _50.xy);
    _185.z = _50.z * _21_m7;
    float3 _210 = (_185 * _44.xxz) + _9.xyz;
    _9 = float4(_210.x, _210.y, _210.z, _9.w);
    _44.x = 0.999999940395355224609375f;
    float2 _217 = _21_m8.xx;
    _44 = float4(_44.x, _217.x, _217.y, _44.w);
    _185.x = _50.x * _21_m8;
    _185.y = dot(float2(-4.3711388286737928865477442741394e-08f, -1.0f), _50.yz);
    _185.z = dot(float2(1.0f, -4.3711388286737928865477442741394e-08f), _50.yz);
    float3 _240 = (_185 * _44.xyz) + _9.xyz;
    _9 = float4(_240.x, _240.y, _240.z, _9.w);
    vs_TEXCOORD2 = _9.xyz + (-_21_m6);
    float3 _255 = _166.yyy * _21_m2[1].xyz;
    _9 = float4(_255.x, _255.y, _255.z, _9.w);
    float3 _266 = (_21_m2[0].xyz * _166.xxx) + _9.xyz;
    _9 = float4(_266.x, _266.y, _266.z, _9.w);
    vs_TEXCOORD3 = (_21_m2[2].xyz * _166.zzz) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _119 = stage_input._119;
    _166 = stage_input._166;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._158 = _158;
    stage_output._164 = _164;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4 unity_FogColor;
float _WobbleX;
float _WobbleZ;
float4 _TopColor;
float4 _RimColor;
float4 _FoamColor;
float4 _Tint;
float4 _DeepColor;
float4 _MidColor;
float4 _SurfaceColor;
float _NoiseScale;
float _NoiseSpeed;
float _NoiseStrength;
float _NoiseColorWarp;
float _PulseSpeed;
float _PulseAmount;
float _Line;
float _RimPower;
float _LineSmooth;
float _Freq;
float _Amplitude;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
}
#define _21_m0 _Time
#define _21_m2 unity_FogColor
#define _21_m3 _WobbleX
#define _21_m4 _WobbleZ
#define _21_m5 _TopColor
#define _21_m6 _RimColor
#define _21_m7 _FoamColor
#define _21_m8 _Tint
#define _21_m9 _DeepColor
#define _21_m10 _MidColor
#define _21_m11 _SurfaceColor
#define _21_m12 _NoiseScale
#define _21_m13 _NoiseSpeed
#define _21_m14 _NoiseStrength
#define _21_m15 _NoiseColorWarp
#define _21_m16 _PulseSpeed
#define _21_m17 _PulseAmount
#define _21_m18 _Line
#define _21_m19 _RimPower
#define _21_m20 _LineSmooth
#define _21_m21 _Freq
#define _21_m22 _Amplitude


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD1;
static float3 _1150;
static float3 _1183;
static float4 _1316;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD1 : TEXCOORD0;
    float3 _1183 : TEXCOORD1;
    float3 _1150 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _1316 : SV_Target0;
};

static float4 _9;
static float _49;
static bool _75;
static float4 _93;
static float4 _102;
static float3 _131;
static float3 _142;
static float2 _149;
static float _182;
static float3 _253;
static float _286;
static float _436;
static float3 _464;
static float3 _1033;

void frag_inner()
{
    __unity_init();
    _9.x = dot(vs_TEXCOORD2.xz, float2(float2(_21_m21, _21_m21)));
    _9.x += _21_m0.y;
    _9.x = sin(_9.x);
    _49 = abs(_21_m3) + abs(_21_m4);
    _49 *= _21_m22;
    _9.x = (_9.x * _49) + vs_TEXCOORD2.y;
    _75 = 0.5f >= _9.x;
    if ((int(_75) * (-1)) == 0)
    {
        discard;
    }
    _49 = float(_75);
    float3 _99 = vs_TEXCOORD2 * _21_m12.xxx;
    _93 = float4(_99.x, _99.y, _99.z, _93.w);
    _102.y = (_21_m0.y * _21_m13) + _93.y;
    float2 _122 = (_21_m0.yy * 0.1500000059604644775390625f.xx) + _93.xz;
    _102 = float4(_122.x, _102.y, _122.y, _102.w);
    float3 _127 = floor(_102.xyz);
    _93 = float4(_127.x, _127.y, _127.z, _93.w);
    _131 = _93.xyz + 1.0f.xxx;
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _149.x = dot(_131, _142);
    _131 = _149.xxx + _131;
    _149.x = _131.y + _131.x;
    _149.x = _131.z * _149.x;
    _131 = _93.xyz + float3(0.0f, 1.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_131, _142);
    _131 = _182.xxx + _131;
    _182 = _131.y + _131.x;
    _149.y = _131.z * _182;
    _149 = frac(_149);
    _149.x = (-_149.y) + _149.x;
    _131 = frac(_102.xyz);
    float3 _219 = (_102.xyz * 2.13000011444091796875f.xxx) + 17.299999237060546875f.xxx;
    _102 = float4(_219.x, _219.y, _219.z, _102.w);
    _142 = _131 * _131;
    _131 = ((-_131) * 2.0f.xxx) + 3.0f.xxx;
    _131 *= _142;
    _149.x = (_131.x * _149.x) + _149.y;
    _142 = _93.xyz + float3(1.0f, 0.0f, 1.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_142, _253);
    _142 = _182.xxx + _142;
    _182 = _142.y + _142.x;
    _182 = _142.z * _182;
    _182 = frac(_182);
    _142 = _93.xyz + float3(0.0f, 0.0f, 1.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _286 = _142.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _182 = (_131.x * _182) + _286;
    _149.x = (-_182) + _149.x;
    _149.x = (_131.y * _149.x) + _182;
    _142 = _93.xyz + float3(1.0f, 1.0f, 0.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_142, _253);
    _142 = _182.xxx + _142;
    _182 = _142.y + _142.x;
    _182 = _142.z * _182;
    _182 = frac(_182);
    _142 = _93.xyz + float3(0.0f, 1.0f, 0.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _286 = _142.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _182 = (_131.x * _182) + _286;
    _142 = _93.xyz + float3(1.0f, 0.0f, 0.0f);
    float3 _403 = _93.xyz * 0.103100001811981201171875f.xxx;
    _93 = float4(_403.x, _403.y, _403.z, _93.w);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _93.w = _142.z * _286;
    _93 = frac(_93);
    _142 = _93.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_93.xyz, _142);
    float3 _445 = _93.xyz + _436.xxx;
    _93 = float4(_445.x, _445.y, _445.z, _93.w);
    _93.x = _93.y + _93.x;
    _93.x = _93.z * _93.x;
    _93.x = frac(_93.x);
    _464.x = (-_93.x) + _93.w;
    _93.x = (_131.x * _464.x) + _93.x;
    _182 += (-_93.x);
    _182 = (_131.y * _182) + _93.x;
    _149.x = (-_182) + _149.x;
    _149.x = (_131.z * _149.x) + _182;
    float3 _509 = floor(_102.xyz);
    _93 = float4(_509.x, _509.y, _509.z, _93.w);
    float3 _514 = frac(_102.xyz);
    _102 = float4(_514.x, _514.y, _514.z, _102.w);
    _131 = _93.xyz + 1.0f.xxx;
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_131, _142);
    _131 = _182.xxx + _131;
    _182 = _131.y + _131.x;
    _182 = _131.z * _182;
    _182 = frac(_182);
    _131 = _93.xyz + float3(0.0f, 1.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _131 = _102.xyz * _102.xyz;
    float3 _586 = ((-_102.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _102 = float4(_586.x, _586.y, _586.z, _102.w);
    float3 _592 = _102.xyz * _131;
    _102 = float4(_592.x, _592.y, _592.z, _102.w);
    _182 = (_102.x * _182) + _286;
    _131 = _93.xyz + float3(1.0f, 0.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _131 = _93.xyz + float3(0.0f, 0.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _286 += (-_436);
    _286 = (_102.x * _286) + _436;
    _182 += (-_286);
    _182 = (_102.y * _182) + _286;
    _131 = _93.xyz + float3(1.0f, 1.0f, 0.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _131 = _93.xyz + float3(0.0f, 1.0f, 0.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _286 += (-_436);
    _286 = (_102.x * _286) + _436;
    _131 = _93.xyz + float3(1.0f, 0.0f, 0.0f);
    float3 _748 = _93.xyz * 0.103100001811981201171875f.xxx;
    _93 = float4(_748.x, _748.y, _748.z, _93.w);
    float3 _753 = frac(_93.xyz);
    _93 = float4(_753.x, _753.y, _753.z, _93.w);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _131 = _93.yzx + 33.3300018310546875f.xxx;
    _131.x = dot(_93.xyz, _131);
    float3 _793 = _93.xyz + _131.xxx;
    _93 = float4(_793.x, _793.y, _793.z, _93.w);
    _93.x = _93.y + _93.x;
    _93.x = _93.z * _93.x;
    _93.x = frac(_93.x);
    _464.x = (-_93.x) + _436;
    _93.x = (_102.x * _464.x) + _93.x;
    _464.x = (-_93.x) + _286;
    _93.x = (_102.y * _464.x) + _93.x;
    _182 += (-_93.x);
    _182 = (_102.z * _182) + _93.x;
    _149.x = (_182 * 0.5f) + _149.x;
    _149.x = (_149.x * 0.666666686534881591796875f) + (-0.5f);
    _182 = (_149.x * _21_m14) + 1.0f;
    _93.x = _9.x + 0.5f;
    _93.x = clamp(_93.x, 0.0f, 1.0f);
    _149.x = (_149.x * _21_m15) + _93.x;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _93.x = _149.x + (-0.5f);
    _149.x += _149.x;
    _149.x = min(_149.x, 1.0f);
    _93.x += _93.x;
    _93.x = max(_93.x, 0.0f);
    _464.x = (_93.x * (-2.0f)) + 3.0f;
    _93.x *= _93.x;
    _93.x *= _464.x;
    _464.x = (_149.x * (-2.0f)) + 3.0f;
    _149.x *= _149.x;
    _149.x *= _464.x;
    _464 = (-_21_m9.xyz) + _21_m10.xyz;
    _464 = (_149.xxx * _464) + _21_m9.xyz;
    float3 _979 = (-_464) + _21_m11.xyz;
    _102 = float4(_979.x, _979.y, _979.z, _102.w);
    float3 _988 = (_93.xxx * _102.xyz) + _464;
    _93 = float4(_988.x, _988.y, _988.z, _93.w);
    _149.x = _21_m0.y * _21_m16;
    _149.x = sin(_149.x);
    _149.x = (_149.x * _21_m17) + 1.0f;
    float3 _1014 = _149.xxx * _93.xyz;
    _93 = float4(_1014.x, _1014.y, _1014.z, _93.w);
    float3 _1021 = _182.xxx * _93.xyz;
    _93 = float4(_1021.x, _1021.y, _1021.z, _93.w);
    float3 _1030 = _93.xyz * _21_m8.xyz;
    _93 = float4(_1030.x, _1030.y, _1030.z, _93.w);
    _1033 = _MainTex.Sample(sampler_MainTex, _9.xx).xyz;
    float3 _1052 = (_93.xyz * _1033) + (-_21_m2.xyz);
    _93 = float4(_1052.x, _1052.y, _1052.z, _93.w);
    _149.x = vs_TEXCOORD1;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    float3 _1070 = (_149.xxx * _93.xyz) + _21_m2.xyz;
    _93 = float4(_1070.x, _1070.y, _1070.z, _93.w);
    _149.x = (-_21_m18) + 0.5f;
    _182 = _149.x + (-_21_m20);
    _149.x = (-_182) + _149.x;
    _182 = (-_182) + _9.x;
    _149.x = 1.0f / _149.x;
    _149.x *= _182;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _182 = (_149.x * (-2.0f)) + 3.0f;
    _149.x *= _149.x;
    _149.x *= _182;
    _182 = _149.x * _49;
    _149.x = ((-_49) * _149.x) + _49;
    _102 = _182.xxxx * _21_m7;
    _93.w = 1.0f;
    _93 = (_149.xxxx * _93) + _102;
    float3 _1156 = _1150.yyy * _21_m1[1].xyz;
    _102 = float4(_1156.x, _1156.y, _1156.z, _102.w);
    float3 _1167 = (_21_m1[0].xyz * _1150.xxx) + _102.xyz;
    _102 = float4(_1167.x, _1167.y, _1167.z, _102.w);
    float3 _1178 = (_21_m1[2].xyz * _1150.zzz) + _102.xyz;
    _102 = float4(_1178.x, _1178.y, _1178.z, _102.w);
    _149.x = dot(_102.xyz, _1183);
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _149.x = (-_149.x) + 1.0f;
    _149.x = log2(_149.x);
    _149.x *= _21_m19;
    _149.x = exp2(_149.x);
    float3 _1220 = (_149.xxx * _21_m6.xyz) + _93.xyz;
    _93 = float4(_1220.x, _1220.y, _1220.z, _93.w);
    _9.z = ((-_21_m18) * 0.20000000298023223876953125f) + 0.5f;
    _182 = _9.z + (-_21_m20);
    float2 _1241 = (-_182.xx) + _9.xz;
    _9 = float4(_1241.x, _9.y, _1241.y, _9.w);
    _149.x = 1.0f / _9.z;
    _9.x = _149.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _149.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _149.x;
    _149.x = _9.x * _49;
    _9.x = ((-_49) * _9.x) + 1.0f;
    _102 = _149.xxxx * _21_m7;
    _102 = (_21_m5 * _9.xxxx) + _102;
    _9 = _49.xxxx * _102;
    bool4 _1313 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u).xxxx;
    _9 = float4(_1313.x ? _93.x : _9.x, _1313.y ? _93.y : _9.y, _1313.z ? _93.z : _9.z, _1313.w ? _93.w : _9.w);
    _1316 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _1150 = stage_input._1150;
    _1183 = stage_input._1183;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1316 = _1316;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float3 _FillAmount;
float _WobbleX;
float _WobbleZ;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _MainTex_ST
#define _21_m6 _FillAmount
#define _21_m7 _WobbleX
#define _21_m8 _WobbleZ



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _123;
static float3 _162;
static float3 _168;
static float3 _170;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _123 : TEXCOORD0;
    float3 _170 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD1 : TEXCOORD0;
    float3 _162 : TEXCOORD1;
    float3 _168 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _50;
static float _78;
static float3 _188;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    _50 = _44.yyyy * _21_m3[1];
    _50 = (_21_m3[0] * _44.xxxx) + _50;
    _50 = (_21_m3[2] * _44.zzzz) + _50;
    _44 = (_21_m3[3] * _44.wwww) + _50;
    _78 = _44.z / _21_m1.y;
    gl_Position = _44;
    _78 = (-_78) + 1.0f;
    _78 *= _21_m1.z;
    _78 = max(_78, 0.0f);
    _78 *= _21_m4.x;
    _78 *= (-_78);
    vs_TEXCOORD1 = exp2(_78);
    vs_TEXCOORD0 = (_123 * _21_m5.xy) + _21_m5.zw;
    float3 _142 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _44 = float4(_142.x, _142.y, _142.z, _44.w);
    float3 _151 = (-_44.xyz) + _21_m0;
    _44 = float4(_151.x, _151.y, _151.z, _44.w);
    _78 = dot(_44.xyz, _44.xyz);
    _78 = rsqrt(_78);
    _162 = _78.xxx * _44.xyz;
    _168 = _170;
    _44.x = _21_m7;
    _44.z = 0.999999940395355224609375f;
    float3 _184 = _9.xyz + (-_21_m6);
    _50 = float4(_184.x, _184.y, _184.z, _50.w);
    _188.x = dot(float2(-4.3711388286737928865477442741394e-08f, -1.0f), _50.xy);
    _188.y = dot(float2(1.0f, -4.3711388286737928865477442741394e-08f), _50.xy);
    _188.z = _50.z * _21_m7;
    float3 _213 = (_188 * _44.xxz) + _9.xyz;
    _9 = float4(_213.x, _213.y, _213.z, _9.w);
    _44.x = 0.999999940395355224609375f;
    float2 _220 = _21_m8.xx;
    _44 = float4(_44.x, _220.x, _220.y, _44.w);
    _188.x = _50.x * _21_m8;
    _188.y = dot(float2(-4.3711388286737928865477442741394e-08f, -1.0f), _50.yz);
    _188.z = dot(float2(1.0f, -4.3711388286737928865477442741394e-08f), _50.yz);
    float3 _243 = (_188 * _44.xyz) + _9.xyz;
    _9 = float4(_243.x, _243.y, _243.z, _9.w);
    vs_TEXCOORD2 = _9.xyz + (-_21_m6);
    float3 _258 = _170.yyy * _21_m2[1].xyz;
    _9 = float4(_258.x, _258.y, _258.z, _9.w);
    float3 _269 = (_21_m2[0].xyz * _170.xxx) + _9.xyz;
    _9 = float4(_269.x, _269.y, _269.z, _9.w);
    vs_TEXCOORD3 = (_21_m2[2].xyz * _170.zzz) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _123 = stage_input._123;
    _170 = stage_input._170;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._162 = _162;
    stage_output._168 = _168;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4 unity_FogColor;
float _WobbleX;
float _WobbleZ;
float4 _TopColor;
float4 _RimColor;
float4 _FoamColor;
float4 _Tint;
float4 _DeepColor;
float4 _MidColor;
float4 _SurfaceColor;
float _NoiseScale;
float _NoiseSpeed;
float _NoiseStrength;
float _NoiseColorWarp;
float _PulseSpeed;
float _PulseAmount;
float _Line;
float _RimPower;
float _LineSmooth;
float _Freq;
float _Amplitude;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
}
#define _21_m0 _Time
#define _21_m2 unity_FogColor
#define _21_m3 _WobbleX
#define _21_m4 _WobbleZ
#define _21_m5 _TopColor
#define _21_m6 _RimColor
#define _21_m7 _FoamColor
#define _21_m8 _Tint
#define _21_m9 _DeepColor
#define _21_m10 _MidColor
#define _21_m11 _SurfaceColor
#define _21_m12 _NoiseScale
#define _21_m13 _NoiseSpeed
#define _21_m14 _NoiseStrength
#define _21_m15 _NoiseColorWarp
#define _21_m16 _PulseSpeed
#define _21_m17 _PulseAmount
#define _21_m18 _Line
#define _21_m19 _RimPower
#define _21_m20 _LineSmooth
#define _21_m21 _Freq
#define _21_m22 _Amplitude


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD1;
static float3 _1150;
static float3 _1183;
static float4 _1316;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD1 : TEXCOORD0;
    float3 _1183 : TEXCOORD1;
    float3 _1150 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _1316 : SV_Target0;
};

static float4 _9;
static float _49;
static bool _75;
static float4 _93;
static float4 _102;
static float3 _131;
static float3 _142;
static float2 _149;
static float _182;
static float3 _253;
static float _286;
static float _436;
static float3 _464;
static float3 _1033;

void frag_inner()
{
    __unity_init();
    _9.x = dot(vs_TEXCOORD2.xz, float2(float2(_21_m21, _21_m21)));
    _9.x += _21_m0.y;
    _9.x = sin(_9.x);
    _49 = abs(_21_m3) + abs(_21_m4);
    _49 *= _21_m22;
    _9.x = (_9.x * _49) + vs_TEXCOORD2.y;
    _75 = 0.5f >= _9.x;
    if ((int(_75) * (-1)) == 0)
    {
        discard;
    }
    _49 = float(_75);
    float3 _99 = vs_TEXCOORD2 * _21_m12.xxx;
    _93 = float4(_99.x, _99.y, _99.z, _93.w);
    _102.y = (_21_m0.y * _21_m13) + _93.y;
    float2 _122 = (_21_m0.yy * 0.1500000059604644775390625f.xx) + _93.xz;
    _102 = float4(_122.x, _102.y, _122.y, _102.w);
    float3 _127 = floor(_102.xyz);
    _93 = float4(_127.x, _127.y, _127.z, _93.w);
    _131 = _93.xyz + 1.0f.xxx;
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _149.x = dot(_131, _142);
    _131 = _149.xxx + _131;
    _149.x = _131.y + _131.x;
    _149.x = _131.z * _149.x;
    _131 = _93.xyz + float3(0.0f, 1.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_131, _142);
    _131 = _182.xxx + _131;
    _182 = _131.y + _131.x;
    _149.y = _131.z * _182;
    _149 = frac(_149);
    _149.x = (-_149.y) + _149.x;
    _131 = frac(_102.xyz);
    float3 _219 = (_102.xyz * 2.13000011444091796875f.xxx) + 17.299999237060546875f.xxx;
    _102 = float4(_219.x, _219.y, _219.z, _102.w);
    _142 = _131 * _131;
    _131 = ((-_131) * 2.0f.xxx) + 3.0f.xxx;
    _131 *= _142;
    _149.x = (_131.x * _149.x) + _149.y;
    _142 = _93.xyz + float3(1.0f, 0.0f, 1.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_142, _253);
    _142 = _182.xxx + _142;
    _182 = _142.y + _142.x;
    _182 = _142.z * _182;
    _182 = frac(_182);
    _142 = _93.xyz + float3(0.0f, 0.0f, 1.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _286 = _142.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _182 = (_131.x * _182) + _286;
    _149.x = (-_182) + _149.x;
    _149.x = (_131.y * _149.x) + _182;
    _142 = _93.xyz + float3(1.0f, 1.0f, 0.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_142, _253);
    _142 = _182.xxx + _142;
    _182 = _142.y + _142.x;
    _182 = _142.z * _182;
    _182 = frac(_182);
    _142 = _93.xyz + float3(0.0f, 1.0f, 0.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _286 = _142.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _182 = (_131.x * _182) + _286;
    _142 = _93.xyz + float3(1.0f, 0.0f, 0.0f);
    float3 _403 = _93.xyz * 0.103100001811981201171875f.xxx;
    _93 = float4(_403.x, _403.y, _403.z, _93.w);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _93.w = _142.z * _286;
    _93 = frac(_93);
    _142 = _93.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_93.xyz, _142);
    float3 _445 = _93.xyz + _436.xxx;
    _93 = float4(_445.x, _445.y, _445.z, _93.w);
    _93.x = _93.y + _93.x;
    _93.x = _93.z * _93.x;
    _93.x = frac(_93.x);
    _464.x = (-_93.x) + _93.w;
    _93.x = (_131.x * _464.x) + _93.x;
    _182 += (-_93.x);
    _182 = (_131.y * _182) + _93.x;
    _149.x = (-_182) + _149.x;
    _149.x = (_131.z * _149.x) + _182;
    float3 _509 = floor(_102.xyz);
    _93 = float4(_509.x, _509.y, _509.z, _93.w);
    float3 _514 = frac(_102.xyz);
    _102 = float4(_514.x, _514.y, _514.z, _102.w);
    _131 = _93.xyz + 1.0f.xxx;
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_131, _142);
    _131 = _182.xxx + _131;
    _182 = _131.y + _131.x;
    _182 = _131.z * _182;
    _182 = frac(_182);
    _131 = _93.xyz + float3(0.0f, 1.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _131 = _102.xyz * _102.xyz;
    float3 _586 = ((-_102.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _102 = float4(_586.x, _586.y, _586.z, _102.w);
    float3 _592 = _102.xyz * _131;
    _102 = float4(_592.x, _592.y, _592.z, _102.w);
    _182 = (_102.x * _182) + _286;
    _131 = _93.xyz + float3(1.0f, 0.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _131 = _93.xyz + float3(0.0f, 0.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _286 += (-_436);
    _286 = (_102.x * _286) + _436;
    _182 += (-_286);
    _182 = (_102.y * _182) + _286;
    _131 = _93.xyz + float3(1.0f, 1.0f, 0.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _131 = _93.xyz + float3(0.0f, 1.0f, 0.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _286 += (-_436);
    _286 = (_102.x * _286) + _436;
    _131 = _93.xyz + float3(1.0f, 0.0f, 0.0f);
    float3 _748 = _93.xyz * 0.103100001811981201171875f.xxx;
    _93 = float4(_748.x, _748.y, _748.z, _93.w);
    float3 _753 = frac(_93.xyz);
    _93 = float4(_753.x, _753.y, _753.z, _93.w);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _131 = _93.yzx + 33.3300018310546875f.xxx;
    _131.x = dot(_93.xyz, _131);
    float3 _793 = _93.xyz + _131.xxx;
    _93 = float4(_793.x, _793.y, _793.z, _93.w);
    _93.x = _93.y + _93.x;
    _93.x = _93.z * _93.x;
    _93.x = frac(_93.x);
    _464.x = (-_93.x) + _436;
    _93.x = (_102.x * _464.x) + _93.x;
    _464.x = (-_93.x) + _286;
    _93.x = (_102.y * _464.x) + _93.x;
    _182 += (-_93.x);
    _182 = (_102.z * _182) + _93.x;
    _149.x = (_182 * 0.5f) + _149.x;
    _149.x = (_149.x * 0.666666686534881591796875f) + (-0.5f);
    _182 = (_149.x * _21_m14) + 1.0f;
    _93.x = _9.x + 0.5f;
    _93.x = clamp(_93.x, 0.0f, 1.0f);
    _149.x = (_149.x * _21_m15) + _93.x;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _93.x = _149.x + (-0.5f);
    _149.x += _149.x;
    _149.x = min(_149.x, 1.0f);
    _93.x += _93.x;
    _93.x = max(_93.x, 0.0f);
    _464.x = (_93.x * (-2.0f)) + 3.0f;
    _93.x *= _93.x;
    _93.x *= _464.x;
    _464.x = (_149.x * (-2.0f)) + 3.0f;
    _149.x *= _149.x;
    _149.x *= _464.x;
    _464 = (-_21_m9.xyz) + _21_m10.xyz;
    _464 = (_149.xxx * _464) + _21_m9.xyz;
    float3 _979 = (-_464) + _21_m11.xyz;
    _102 = float4(_979.x, _979.y, _979.z, _102.w);
    float3 _988 = (_93.xxx * _102.xyz) + _464;
    _93 = float4(_988.x, _988.y, _988.z, _93.w);
    _149.x = _21_m0.y * _21_m16;
    _149.x = sin(_149.x);
    _149.x = (_149.x * _21_m17) + 1.0f;
    float3 _1014 = _149.xxx * _93.xyz;
    _93 = float4(_1014.x, _1014.y, _1014.z, _93.w);
    float3 _1021 = _182.xxx * _93.xyz;
    _93 = float4(_1021.x, _1021.y, _1021.z, _93.w);
    float3 _1030 = _93.xyz * _21_m8.xyz;
    _93 = float4(_1030.x, _1030.y, _1030.z, _93.w);
    _1033 = _MainTex.Sample(sampler_MainTex, _9.xx).xyz;
    float3 _1052 = (_93.xyz * _1033) + (-_21_m2.xyz);
    _93 = float4(_1052.x, _1052.y, _1052.z, _93.w);
    _149.x = vs_TEXCOORD1;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    float3 _1070 = (_149.xxx * _93.xyz) + _21_m2.xyz;
    _93 = float4(_1070.x, _1070.y, _1070.z, _93.w);
    _149.x = (-_21_m18) + 0.5f;
    _182 = _149.x + (-_21_m20);
    _149.x = (-_182) + _149.x;
    _182 = (-_182) + _9.x;
    _149.x = 1.0f / _149.x;
    _149.x *= _182;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _182 = (_149.x * (-2.0f)) + 3.0f;
    _149.x *= _149.x;
    _149.x *= _182;
    _182 = _149.x * _49;
    _149.x = ((-_49) * _149.x) + _49;
    _102 = _182.xxxx * _21_m7;
    _93.w = 1.0f;
    _93 = (_149.xxxx * _93) + _102;
    float3 _1156 = _1150.yyy * _21_m1[1].xyz;
    _102 = float4(_1156.x, _1156.y, _1156.z, _102.w);
    float3 _1167 = (_21_m1[0].xyz * _1150.xxx) + _102.xyz;
    _102 = float4(_1167.x, _1167.y, _1167.z, _102.w);
    float3 _1178 = (_21_m1[2].xyz * _1150.zzz) + _102.xyz;
    _102 = float4(_1178.x, _1178.y, _1178.z, _102.w);
    _149.x = dot(_102.xyz, _1183);
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _149.x = (-_149.x) + 1.0f;
    _149.x = log2(_149.x);
    _149.x *= _21_m19;
    _149.x = exp2(_149.x);
    float3 _1220 = (_149.xxx * _21_m6.xyz) + _93.xyz;
    _93 = float4(_1220.x, _1220.y, _1220.z, _93.w);
    _9.z = ((-_21_m18) * 0.20000000298023223876953125f) + 0.5f;
    _182 = _9.z + (-_21_m20);
    float2 _1241 = (-_182.xx) + _9.xz;
    _9 = float4(_1241.x, _9.y, _1241.y, _9.w);
    _149.x = 1.0f / _9.z;
    _9.x = _149.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _149.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _149.x;
    _149.x = _9.x * _49;
    _9.x = ((-_49) * _9.x) + 1.0f;
    _102 = _149.xxxx * _21_m7;
    _102 = (_21_m5 * _9.xxxx) + _102;
    _9 = _49.xxxx * _102;
    bool4 _1313 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u).xxxx;
    _9 = float4(_1313.x ? _93.x : _9.x, _1313.y ? _93.y : _9.y, _1313.z ? _93.z : _9.z, _1313.w ? _93.w : _9.w);
    _1316 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _1150 = stage_input._1150;
    _1183 = stage_input._1183;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1316 = _1316;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float3 _FillAmount;
float _WobbleX;
float _WobbleZ;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _MainTex_ST
#define _21_m6 _FillAmount
#define _21_m7 _WobbleX
#define _21_m8 _WobbleZ



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _120;
static float3 _159;
static float3 _165;
static float3 _167;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _120 : TEXCOORD0;
    float3 _167 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD1 : TEXCOORD0;
    float3 _159 : TEXCOORD1;
    float3 _165 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _50;
static float _78;
static float3 _186;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    _50 = _44.yyyy * _21_m3[1];
    _50 = (_21_m3[0] * _44.xxxx) + _50;
    _50 = (_21_m3[2] * _44.zzzz) + _50;
    _44 = (_21_m3[3] * _44.wwww) + _50;
    _78 = _44.z / _21_m1.y;
    gl_Position = _44;
    _78 = (-_78) + 1.0f;
    _78 *= _21_m1.z;
    _78 = max(_78, 0.0f);
    vs_TEXCOORD1 = (_78 * _21_m4.z) + _21_m4.w;
    vs_TEXCOORD0 = (_120 * _21_m5.xy) + _21_m5.zw;
    float3 _139 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _44 = float4(_139.x, _139.y, _139.z, _44.w);
    float3 _148 = (-_44.xyz) + _21_m0;
    _44 = float4(_148.x, _148.y, _148.z, _44.w);
    _78 = dot(_44.xyz, _44.xyz);
    _78 = rsqrt(_78);
    _159 = _78.xxx * _44.xyz;
    _165 = _167;
    _44.x = _21_m7;
    _44.z = 0.999999940395355224609375f;
    float3 _182 = _9.xyz + (-_21_m6);
    _50 = float4(_182.x, _182.y, _182.z, _50.w);
    _186.x = dot(float2(-4.3711388286737928865477442741394e-08f, -1.0f), _50.xy);
    _186.y = dot(float2(1.0f, -4.3711388286737928865477442741394e-08f), _50.xy);
    _186.z = _50.z * _21_m7;
    float3 _211 = (_186 * _44.xxz) + _9.xyz;
    _9 = float4(_211.x, _211.y, _211.z, _9.w);
    _44.x = 0.999999940395355224609375f;
    float2 _218 = _21_m8.xx;
    _44 = float4(_44.x, _218.x, _218.y, _44.w);
    _186.x = _50.x * _21_m8;
    _186.y = dot(float2(-4.3711388286737928865477442741394e-08f, -1.0f), _50.yz);
    _186.z = dot(float2(1.0f, -4.3711388286737928865477442741394e-08f), _50.yz);
    float3 _241 = (_186 * _44.xyz) + _9.xyz;
    _9 = float4(_241.x, _241.y, _241.z, _9.w);
    vs_TEXCOORD2 = _9.xyz + (-_21_m6);
    float3 _256 = _167.yyy * _21_m2[1].xyz;
    _9 = float4(_256.x, _256.y, _256.z, _9.w);
    float3 _267 = (_21_m2[0].xyz * _167.xxx) + _9.xyz;
    _9 = float4(_267.x, _267.y, _267.z, _9.w);
    vs_TEXCOORD3 = (_21_m2[2].xyz * _167.zzz) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _120 = stage_input._120;
    _167 = stage_input._167;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._159 = _159;
    stage_output._165 = _165;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4 unity_FogColor;
float _WobbleX;
float _WobbleZ;
float4 _TopColor;
float4 _RimColor;
float4 _FoamColor;
float4 _Tint;
float4 _DeepColor;
float4 _MidColor;
float4 _SurfaceColor;
float _NoiseScale;
float _NoiseSpeed;
float _NoiseStrength;
float _NoiseColorWarp;
float _PulseSpeed;
float _PulseAmount;
float _Line;
float _RimPower;
float _LineSmooth;
float _Freq;
float _Amplitude;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
}
#define _21_m0 _Time
#define _21_m2 unity_FogColor
#define _21_m3 _WobbleX
#define _21_m4 _WobbleZ
#define _21_m5 _TopColor
#define _21_m6 _RimColor
#define _21_m7 _FoamColor
#define _21_m8 _Tint
#define _21_m9 _DeepColor
#define _21_m10 _MidColor
#define _21_m11 _SurfaceColor
#define _21_m12 _NoiseScale
#define _21_m13 _NoiseSpeed
#define _21_m14 _NoiseStrength
#define _21_m15 _NoiseColorWarp
#define _21_m16 _PulseSpeed
#define _21_m17 _PulseAmount
#define _21_m18 _Line
#define _21_m19 _RimPower
#define _21_m20 _LineSmooth
#define _21_m21 _Freq
#define _21_m22 _Amplitude


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD1;
static float3 _1150;
static float3 _1183;
static float4 _1316;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD1 : TEXCOORD0;
    float3 _1183 : TEXCOORD1;
    float3 _1150 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _1316 : SV_Target0;
};

static float4 _9;
static float _49;
static bool _75;
static float4 _93;
static float4 _102;
static float3 _131;
static float3 _142;
static float2 _149;
static float _182;
static float3 _253;
static float _286;
static float _436;
static float3 _464;
static float3 _1033;

void frag_inner()
{
    __unity_init();
    _9.x = dot(vs_TEXCOORD2.xz, float2(float2(_21_m21, _21_m21)));
    _9.x += _21_m0.y;
    _9.x = sin(_9.x);
    _49 = abs(_21_m3) + abs(_21_m4);
    _49 *= _21_m22;
    _9.x = (_9.x * _49) + vs_TEXCOORD2.y;
    _75 = 0.5f >= _9.x;
    if ((int(_75) * (-1)) == 0)
    {
        discard;
    }
    _49 = float(_75);
    float3 _99 = vs_TEXCOORD2 * _21_m12.xxx;
    _93 = float4(_99.x, _99.y, _99.z, _93.w);
    _102.y = (_21_m0.y * _21_m13) + _93.y;
    float2 _122 = (_21_m0.yy * 0.1500000059604644775390625f.xx) + _93.xz;
    _102 = float4(_122.x, _102.y, _122.y, _102.w);
    float3 _127 = floor(_102.xyz);
    _93 = float4(_127.x, _127.y, _127.z, _93.w);
    _131 = _93.xyz + 1.0f.xxx;
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _149.x = dot(_131, _142);
    _131 = _149.xxx + _131;
    _149.x = _131.y + _131.x;
    _149.x = _131.z * _149.x;
    _131 = _93.xyz + float3(0.0f, 1.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_131, _142);
    _131 = _182.xxx + _131;
    _182 = _131.y + _131.x;
    _149.y = _131.z * _182;
    _149 = frac(_149);
    _149.x = (-_149.y) + _149.x;
    _131 = frac(_102.xyz);
    float3 _219 = (_102.xyz * 2.13000011444091796875f.xxx) + 17.299999237060546875f.xxx;
    _102 = float4(_219.x, _219.y, _219.z, _102.w);
    _142 = _131 * _131;
    _131 = ((-_131) * 2.0f.xxx) + 3.0f.xxx;
    _131 *= _142;
    _149.x = (_131.x * _149.x) + _149.y;
    _142 = _93.xyz + float3(1.0f, 0.0f, 1.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_142, _253);
    _142 = _182.xxx + _142;
    _182 = _142.y + _142.x;
    _182 = _142.z * _182;
    _182 = frac(_182);
    _142 = _93.xyz + float3(0.0f, 0.0f, 1.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _286 = _142.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _182 = (_131.x * _182) + _286;
    _149.x = (-_182) + _149.x;
    _149.x = (_131.y * _149.x) + _182;
    _142 = _93.xyz + float3(1.0f, 1.0f, 0.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_142, _253);
    _142 = _182.xxx + _142;
    _182 = _142.y + _142.x;
    _182 = _142.z * _182;
    _182 = frac(_182);
    _142 = _93.xyz + float3(0.0f, 1.0f, 0.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _286 = _142.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _182 = (_131.x * _182) + _286;
    _142 = _93.xyz + float3(1.0f, 0.0f, 0.0f);
    float3 _403 = _93.xyz * 0.103100001811981201171875f.xxx;
    _93 = float4(_403.x, _403.y, _403.z, _93.w);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _93.w = _142.z * _286;
    _93 = frac(_93);
    _142 = _93.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_93.xyz, _142);
    float3 _445 = _93.xyz + _436.xxx;
    _93 = float4(_445.x, _445.y, _445.z, _93.w);
    _93.x = _93.y + _93.x;
    _93.x = _93.z * _93.x;
    _93.x = frac(_93.x);
    _464.x = (-_93.x) + _93.w;
    _93.x = (_131.x * _464.x) + _93.x;
    _182 += (-_93.x);
    _182 = (_131.y * _182) + _93.x;
    _149.x = (-_182) + _149.x;
    _149.x = (_131.z * _149.x) + _182;
    float3 _509 = floor(_102.xyz);
    _93 = float4(_509.x, _509.y, _509.z, _93.w);
    float3 _514 = frac(_102.xyz);
    _102 = float4(_514.x, _514.y, _514.z, _102.w);
    _131 = _93.xyz + 1.0f.xxx;
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_131, _142);
    _131 = _182.xxx + _131;
    _182 = _131.y + _131.x;
    _182 = _131.z * _182;
    _182 = frac(_182);
    _131 = _93.xyz + float3(0.0f, 1.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _131 = _102.xyz * _102.xyz;
    float3 _586 = ((-_102.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _102 = float4(_586.x, _586.y, _586.z, _102.w);
    float3 _592 = _102.xyz * _131;
    _102 = float4(_592.x, _592.y, _592.z, _102.w);
    _182 = (_102.x * _182) + _286;
    _131 = _93.xyz + float3(1.0f, 0.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _131 = _93.xyz + float3(0.0f, 0.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _286 += (-_436);
    _286 = (_102.x * _286) + _436;
    _182 += (-_286);
    _182 = (_102.y * _182) + _286;
    _131 = _93.xyz + float3(1.0f, 1.0f, 0.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _131 = _93.xyz + float3(0.0f, 1.0f, 0.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _286 += (-_436);
    _286 = (_102.x * _286) + _436;
    _131 = _93.xyz + float3(1.0f, 0.0f, 0.0f);
    float3 _748 = _93.xyz * 0.103100001811981201171875f.xxx;
    _93 = float4(_748.x, _748.y, _748.z, _93.w);
    float3 _753 = frac(_93.xyz);
    _93 = float4(_753.x, _753.y, _753.z, _93.w);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _131 = _93.yzx + 33.3300018310546875f.xxx;
    _131.x = dot(_93.xyz, _131);
    float3 _793 = _93.xyz + _131.xxx;
    _93 = float4(_793.x, _793.y, _793.z, _93.w);
    _93.x = _93.y + _93.x;
    _93.x = _93.z * _93.x;
    _93.x = frac(_93.x);
    _464.x = (-_93.x) + _436;
    _93.x = (_102.x * _464.x) + _93.x;
    _464.x = (-_93.x) + _286;
    _93.x = (_102.y * _464.x) + _93.x;
    _182 += (-_93.x);
    _182 = (_102.z * _182) + _93.x;
    _149.x = (_182 * 0.5f) + _149.x;
    _149.x = (_149.x * 0.666666686534881591796875f) + (-0.5f);
    _182 = (_149.x * _21_m14) + 1.0f;
    _93.x = _9.x + 0.5f;
    _93.x = clamp(_93.x, 0.0f, 1.0f);
    _149.x = (_149.x * _21_m15) + _93.x;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _93.x = _149.x + (-0.5f);
    _149.x += _149.x;
    _149.x = min(_149.x, 1.0f);
    _93.x += _93.x;
    _93.x = max(_93.x, 0.0f);
    _464.x = (_93.x * (-2.0f)) + 3.0f;
    _93.x *= _93.x;
    _93.x *= _464.x;
    _464.x = (_149.x * (-2.0f)) + 3.0f;
    _149.x *= _149.x;
    _149.x *= _464.x;
    _464 = (-_21_m9.xyz) + _21_m10.xyz;
    _464 = (_149.xxx * _464) + _21_m9.xyz;
    float3 _979 = (-_464) + _21_m11.xyz;
    _102 = float4(_979.x, _979.y, _979.z, _102.w);
    float3 _988 = (_93.xxx * _102.xyz) + _464;
    _93 = float4(_988.x, _988.y, _988.z, _93.w);
    _149.x = _21_m0.y * _21_m16;
    _149.x = sin(_149.x);
    _149.x = (_149.x * _21_m17) + 1.0f;
    float3 _1014 = _149.xxx * _93.xyz;
    _93 = float4(_1014.x, _1014.y, _1014.z, _93.w);
    float3 _1021 = _182.xxx * _93.xyz;
    _93 = float4(_1021.x, _1021.y, _1021.z, _93.w);
    float3 _1030 = _93.xyz * _21_m8.xyz;
    _93 = float4(_1030.x, _1030.y, _1030.z, _93.w);
    _1033 = _MainTex.Sample(sampler_MainTex, _9.xx).xyz;
    float3 _1052 = (_93.xyz * _1033) + (-_21_m2.xyz);
    _93 = float4(_1052.x, _1052.y, _1052.z, _93.w);
    _149.x = vs_TEXCOORD1;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    float3 _1070 = (_149.xxx * _93.xyz) + _21_m2.xyz;
    _93 = float4(_1070.x, _1070.y, _1070.z, _93.w);
    _149.x = (-_21_m18) + 0.5f;
    _182 = _149.x + (-_21_m20);
    _149.x = (-_182) + _149.x;
    _182 = (-_182) + _9.x;
    _149.x = 1.0f / _149.x;
    _149.x *= _182;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _182 = (_149.x * (-2.0f)) + 3.0f;
    _149.x *= _149.x;
    _149.x *= _182;
    _182 = _149.x * _49;
    _149.x = ((-_49) * _149.x) + _49;
    _102 = _182.xxxx * _21_m7;
    _93.w = 1.0f;
    _93 = (_149.xxxx * _93) + _102;
    float3 _1156 = _1150.yyy * _21_m1[1].xyz;
    _102 = float4(_1156.x, _1156.y, _1156.z, _102.w);
    float3 _1167 = (_21_m1[0].xyz * _1150.xxx) + _102.xyz;
    _102 = float4(_1167.x, _1167.y, _1167.z, _102.w);
    float3 _1178 = (_21_m1[2].xyz * _1150.zzz) + _102.xyz;
    _102 = float4(_1178.x, _1178.y, _1178.z, _102.w);
    _149.x = dot(_102.xyz, _1183);
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _149.x = (-_149.x) + 1.0f;
    _149.x = log2(_149.x);
    _149.x *= _21_m19;
    _149.x = exp2(_149.x);
    float3 _1220 = (_149.xxx * _21_m6.xyz) + _93.xyz;
    _93 = float4(_1220.x, _1220.y, _1220.z, _93.w);
    _9.z = ((-_21_m18) * 0.20000000298023223876953125f) + 0.5f;
    _182 = _9.z + (-_21_m20);
    float2 _1241 = (-_182.xx) + _9.xz;
    _9 = float4(_1241.x, _9.y, _1241.y, _9.w);
    _149.x = 1.0f / _9.z;
    _9.x = _149.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _149.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _149.x;
    _149.x = _9.x * _49;
    _9.x = ((-_49) * _9.x) + 1.0f;
    _102 = _149.xxxx * _21_m7;
    _102 = (_21_m5 * _9.xxxx) + _102;
    _9 = _49.xxxx * _102;
    bool4 _1313 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u).xxxx;
    _9 = float4(_1313.x ? _93.x : _9.x, _1313.y ? _93.y : _9.y, _1313.z ? _93.z : _9.z, _1313.w ? _93.w : _9.w);
    _1316 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _1150 = stage_input._1150;
    _1183 = stage_input._1183;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1316 = _1316;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float4 _MainTex_ST;
float3 _FillAmount;
float _WobbleX;
float _WobbleZ;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m3 _MainTex_ST
#define _21_m4 _FillAmount
#define _21_m5 _WobbleX
#define _21_m6 _WobbleZ



static float4 gl_Position;
static float2 vs_TEXCOORD0;
static float2 _11;
static float4 _36;
static float3 _128;
static float3 _134;
static float3 _136;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _36 : POSITION;
    float2 _11 : TEXCOORD0;
    float3 _136 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 _128 : TEXCOORD0;
    float3 _134 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD0 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _34;
static float4 _59;
static float4 _64;
static float _119;
static float3 _157;

void vert_inner()
{
    __unity_init();
    vs_TEXCOORD0 = (_11 * _21_m3.xy) + _21_m3.zw;
    _34 = _36.yyyy * _21_m1[1];
    _34 = (_21_m1[0] * _36.xxxx) + _34;
    _34 = (_21_m1[2] * _36.zzzz) + _34;
    _59 = _34 + _21_m1[3];
    _64 = _59.yyyy * _21_m2[1];
    _64 = (_21_m2[0] * _59.xxxx) + _64;
    _64 = (_21_m2[2] * _59.zzzz) + _64;
    gl_Position = (_21_m2[3] * _59.wwww) + _64;
    float3 _106 = (_21_m1[3].xyz * _36.www) + _34.xyz;
    _59 = float4(_106.x, _106.y, _106.z, _59.w);
    float3 _115 = (-_59.xyz) + _21_m0;
    _59 = float4(_115.x, _115.y, _115.z, _59.w);
    _119 = dot(_59.xyz, _59.xyz);
    _119 = rsqrt(_119);
    _128 = _119.xxx * _59.xyz;
    _134 = _136;
    _59.x = _21_m5;
    _59.z = 0.999999940395355224609375f;
    float3 _153 = _34.xyz + (-_21_m4);
    _64 = float4(_153.x, _153.y, _153.z, _64.w);
    _157.x = dot(float2(-4.3711388286737928865477442741394e-08f, -1.0f), _64.xy);
    _157.y = dot(float2(1.0f, -4.3711388286737928865477442741394e-08f), _64.xy);
    _157.z = _64.z * _21_m5;
    float3 _183 = (_157 * _59.xxz) + _34.xyz;
    _34 = float4(_183.x, _183.y, _183.z, _34.w);
    _59.x = 0.999999940395355224609375f;
    float2 _190 = _21_m6.xx;
    _59 = float4(_59.x, _190.x, _190.y, _59.w);
    _157.x = _64.x * _21_m6;
    _157.y = dot(float2(-4.3711388286737928865477442741394e-08f, -1.0f), _64.yz);
    _157.z = dot(float2(1.0f, -4.3711388286737928865477442741394e-08f), _64.yz);
    float3 _213 = (_157 * _59.xyz) + _34.xyz;
    _34 = float4(_213.x, _213.y, _213.z, _34.w);
    vs_TEXCOORD2 = _34.xyz + (-_21_m4);
    float3 _228 = _136.yyy * _21_m1[1].xyz;
    _34 = float4(_228.x, _228.y, _228.z, _34.w);
    float3 _239 = (_21_m1[0].xyz * _136.xxx) + _34.xyz;
    _34 = float4(_239.x, _239.y, _239.z, _34.w);
    vs_TEXCOORD3 = (_21_m1[2].xyz * _136.zzz) + _34.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _36 = stage_input._36;
    _136 = stage_input._136;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._128 = _128;
    stage_output._134 = _134;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float _WobbleX;
float _WobbleZ;
float4 _TopColor;
float4 _RimColor;
float4 _FoamColor;
float4 _Tint;
float4 _DeepColor;
float4 _MidColor;
float4 _SurfaceColor;
float _NoiseScale;
float _NoiseSpeed;
float _NoiseStrength;
float _NoiseColorWarp;
float _PulseSpeed;
float _PulseAmount;
float _Line;
float _RimPower;
float _LineSmooth;
float _Freq;
float _Amplitude;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
}
#define _21_m0 _Time
#define _21_m2 _WobbleX
#define _21_m3 _WobbleZ
#define _21_m4 _TopColor
#define _21_m5 _RimColor
#define _21_m6 _FoamColor
#define _21_m7 _Tint
#define _21_m8 _DeepColor
#define _21_m9 _MidColor
#define _21_m10 _SurfaceColor
#define _21_m11 _NoiseScale
#define _21_m12 _NoiseSpeed
#define _21_m13 _NoiseStrength
#define _21_m14 _NoiseColorWarp
#define _21_m15 _PulseSpeed
#define _21_m16 _PulseAmount
#define _21_m17 _Line
#define _21_m18 _RimPower
#define _21_m19 _LineSmooth
#define _21_m20 _Freq
#define _21_m21 _Amplitude


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 _1126;
static float3 _1159;
static float4 _1292;

struct SPIRV_Cross_Input
{
    float3 _1159 : TEXCOORD0;
    float3 _1126 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _1292 : SV_Target0;
};

static float4 _9;
static float _49;
static bool _75;
static float4 _93;
static float4 _102;
static float3 _131;
static float3 _142;
static float2 _149;
static float _182;
static float3 _253;
static float _286;
static float _436;
static float3 _464;
static float3 _1033;

void frag_inner()
{
    __unity_init();
    _9.x = dot(vs_TEXCOORD2.xz, float2(float2(_21_m20, _21_m20)));
    _9.x += _21_m0.y;
    _9.x = sin(_9.x);
    _49 = abs(_21_m2) + abs(_21_m3);
    _49 *= _21_m21;
    _9.x = (_9.x * _49) + vs_TEXCOORD2.y;
    _75 = 0.5f >= _9.x;
    if ((int(_75) * (-1)) == 0)
    {
        discard;
    }
    _49 = float(_75);
    float3 _99 = vs_TEXCOORD2 * _21_m11.xxx;
    _93 = float4(_99.x, _99.y, _99.z, _93.w);
    _102.y = (_21_m0.y * _21_m12) + _93.y;
    float2 _122 = (_21_m0.yy * 0.1500000059604644775390625f.xx) + _93.xz;
    _102 = float4(_122.x, _102.y, _122.y, _102.w);
    float3 _127 = floor(_102.xyz);
    _93 = float4(_127.x, _127.y, _127.z, _93.w);
    _131 = _93.xyz + 1.0f.xxx;
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _149.x = dot(_131, _142);
    _131 = _149.xxx + _131;
    _149.x = _131.y + _131.x;
    _149.x = _131.z * _149.x;
    _131 = _93.xyz + float3(0.0f, 1.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_131, _142);
    _131 = _182.xxx + _131;
    _182 = _131.y + _131.x;
    _149.y = _131.z * _182;
    _149 = frac(_149);
    _149.x = (-_149.y) + _149.x;
    _131 = frac(_102.xyz);
    float3 _219 = (_102.xyz * 2.13000011444091796875f.xxx) + 17.299999237060546875f.xxx;
    _102 = float4(_219.x, _219.y, _219.z, _102.w);
    _142 = _131 * _131;
    _131 = ((-_131) * 2.0f.xxx) + 3.0f.xxx;
    _131 *= _142;
    _149.x = (_131.x * _149.x) + _149.y;
    _142 = _93.xyz + float3(1.0f, 0.0f, 1.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_142, _253);
    _142 = _182.xxx + _142;
    _182 = _142.y + _142.x;
    _182 = _142.z * _182;
    _182 = frac(_182);
    _142 = _93.xyz + float3(0.0f, 0.0f, 1.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _286 = _142.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _182 = (_131.x * _182) + _286;
    _149.x = (-_182) + _149.x;
    _149.x = (_131.y * _149.x) + _182;
    _142 = _93.xyz + float3(1.0f, 1.0f, 0.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_142, _253);
    _142 = _182.xxx + _142;
    _182 = _142.y + _142.x;
    _182 = _142.z * _182;
    _182 = frac(_182);
    _142 = _93.xyz + float3(0.0f, 1.0f, 0.0f);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _286 = _142.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _182 = (_131.x * _182) + _286;
    _142 = _93.xyz + float3(1.0f, 0.0f, 0.0f);
    float3 _403 = _93.xyz * 0.103100001811981201171875f.xxx;
    _93 = float4(_403.x, _403.y, _403.z, _93.w);
    _142 *= 0.103100001811981201171875f.xxx;
    _142 = frac(_142);
    _253 = _142.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_142, _253);
    _142 = _286.xxx + _142;
    _286 = _142.y + _142.x;
    _93.w = _142.z * _286;
    _93 = frac(_93);
    _142 = _93.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_93.xyz, _142);
    float3 _445 = _93.xyz + _436.xxx;
    _93 = float4(_445.x, _445.y, _445.z, _93.w);
    _93.x = _93.y + _93.x;
    _93.x = _93.z * _93.x;
    _93.x = frac(_93.x);
    _464.x = (-_93.x) + _93.w;
    _93.x = (_131.x * _464.x) + _93.x;
    _182 += (-_93.x);
    _182 = (_131.y * _182) + _93.x;
    _149.x = (-_182) + _149.x;
    _149.x = (_131.z * _149.x) + _182;
    float3 _509 = floor(_102.xyz);
    _93 = float4(_509.x, _509.y, _509.z, _93.w);
    float3 _514 = frac(_102.xyz);
    _102 = float4(_514.x, _514.y, _514.z, _102.w);
    _131 = _93.xyz + 1.0f.xxx;
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _182 = dot(_131, _142);
    _131 = _182.xxx + _131;
    _182 = _131.y + _131.x;
    _182 = _131.z * _182;
    _182 = frac(_182);
    _131 = _93.xyz + float3(0.0f, 1.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _182 += (-_286);
    _131 = _102.xyz * _102.xyz;
    float3 _586 = ((-_102.xyz) * 2.0f.xxx) + 3.0f.xxx;
    _102 = float4(_586.x, _586.y, _586.z, _102.w);
    float3 _592 = _102.xyz * _131;
    _102 = float4(_592.x, _592.y, _592.z, _102.w);
    _182 = (_102.x * _182) + _286;
    _131 = _93.xyz + float3(1.0f, 0.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _131 = _93.xyz + float3(0.0f, 0.0f, 1.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _286 += (-_436);
    _286 = (_102.x * _286) + _436;
    _182 += (-_286);
    _182 = (_102.y * _182) + _286;
    _131 = _93.xyz + float3(1.0f, 1.0f, 0.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _286 = dot(_131, _142);
    _131 = _286.xxx + _131;
    _286 = _131.y + _131.x;
    _286 = _131.z * _286;
    _286 = frac(_286);
    _131 = _93.xyz + float3(0.0f, 1.0f, 0.0f);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _286 += (-_436);
    _286 = (_102.x * _286) + _436;
    _131 = _93.xyz + float3(1.0f, 0.0f, 0.0f);
    float3 _748 = _93.xyz * 0.103100001811981201171875f.xxx;
    _93 = float4(_748.x, _748.y, _748.z, _93.w);
    float3 _753 = frac(_93.xyz);
    _93 = float4(_753.x, _753.y, _753.z, _93.w);
    _131 *= 0.103100001811981201171875f.xxx;
    _131 = frac(_131);
    _142 = _131.yzx + 33.3300018310546875f.xxx;
    _436 = dot(_131, _142);
    _131 = _436.xxx + _131;
    _436 = _131.y + _131.x;
    _436 = _131.z * _436;
    _436 = frac(_436);
    _131 = _93.yzx + 33.3300018310546875f.xxx;
    _131.x = dot(_93.xyz, _131);
    float3 _793 = _93.xyz + _131.xxx;
    _93 = float4(_793.x, _793.y, _793.z, _93.w);
    _93.x = _93.y + _93.x;
    _93.x = _93.z * _93.x;
    _93.x = frac(_93.x);
    _464.x = (-_93.x) + _436;
    _93.x = (_102.x * _464.x) + _93.x;
    _464.x = (-_93.x) + _286;
    _93.x = (_102.y * _464.x) + _93.x;
    _182 += (-_93.x);
    _182 = (_102.z * _182) + _93.x;
    _149.x = (_182 * 0.5f) + _149.x;
    _149.x = (_149.x * 0.666666686534881591796875f) + (-0.5f);
    _182 = (_149.x * _21_m13) + 1.0f;
    _93.x = _9.x + 0.5f;
    _93.x = clamp(_93.x, 0.0f, 1.0f);
    _149.x = (_149.x * _21_m14) + _93.x;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _93.x = _149.x + (-0.5f);
    _149.x += _149.x;
    _149.x = min(_149.x, 1.0f);
    _93.x += _93.x;
    _93.x = max(_93.x, 0.0f);
    _464.x = (_93.x * (-2.0f)) + 3.0f;
    _93.x *= _93.x;
    _93.x *= _464.x;
    _464.x = (_149.x * (-2.0f)) + 3.0f;
    _149.x *= _149.x;
    _149.x *= _464.x;
    _464 = (-_21_m8.xyz) + _21_m9.xyz;
    _464 = (_149.xxx * _464) + _21_m8.xyz;
    float3 _979 = (-_464) + _21_m10.xyz;
    _102 = float4(_979.x, _979.y, _979.z, _102.w);
    float3 _988 = (_93.xxx * _102.xyz) + _464;
    _93 = float4(_988.x, _988.y, _988.z, _93.w);
    _149.x = _21_m0.y * _21_m15;
    _149.x = sin(_149.x);
    _149.x = (_149.x * _21_m16) + 1.0f;
    float3 _1014 = _149.xxx * _93.xyz;
    _93 = float4(_1014.x, _1014.y, _1014.z, _93.w);
    float3 _1021 = _182.xxx * _93.xyz;
    _93 = float4(_1021.x, _1021.y, _1021.z, _93.w);
    float3 _1030 = _93.xyz * _21_m7.xyz;
    _93 = float4(_1030.x, _1030.y, _1030.z, _93.w);
    _1033 = _MainTex.Sample(sampler_MainTex, _9.xx).xyz;
    float3 _1046 = _93.xyz * _1033;
    _93 = float4(_1046.x, _1046.y, _1046.z, _93.w);
    _149.x = (-_21_m17) + 0.5f;
    _182 = _149.x + (-_21_m19);
    _149.x = (-_182) + _149.x;
    _182 = (-_182) + _9.x;
    _149.x = 1.0f / _149.x;
    _149.x *= _182;
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _182 = (_149.x * (-2.0f)) + 3.0f;
    _149.x *= _149.x;
    _149.x *= _182;
    _182 = _149.x * _49;
    _149.x = ((-_49) * _149.x) + _49;
    _102 = _182.xxxx * _21_m6;
    _93.w = 1.0f;
    _93 = (_149.xxxx * _93) + _102;
    float3 _1132 = _1126.yyy * _21_m1[1].xyz;
    _102 = float4(_1132.x, _1132.y, _1132.z, _102.w);
    float3 _1143 = (_21_m1[0].xyz * _1126.xxx) + _102.xyz;
    _102 = float4(_1143.x, _1143.y, _1143.z, _102.w);
    float3 _1154 = (_21_m1[2].xyz * _1126.zzz) + _102.xyz;
    _102 = float4(_1154.x, _1154.y, _1154.z, _102.w);
    _149.x = dot(_102.xyz, _1159);
    _149.x = clamp(_149.x, 0.0f, 1.0f);
    _149.x = (-_149.x) + 1.0f;
    _149.x = log2(_149.x);
    _149.x *= _21_m18;
    _149.x = exp2(_149.x);
    float3 _1196 = (_149.xxx * _21_m5.xyz) + _93.xyz;
    _93 = float4(_1196.x, _1196.y, _1196.z, _93.w);
    _9.z = ((-_21_m17) * 0.20000000298023223876953125f) + 0.5f;
    _182 = _9.z + (-_21_m19);
    float2 _1217 = (-_182.xx) + _9.xz;
    _9 = float4(_1217.x, _9.y, _1217.y, _9.w);
    _149.x = 1.0f / _9.z;
    _9.x = _149.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _149.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _149.x;
    _149.x = _9.x * _49;
    _9.x = ((-_49) * _9.x) + 1.0f;
    _102 = _149.xxxx * _21_m6;
    _102 = (_21_m4 * _9.xxxx) + _102;
    _9 = _49.xxxx * _102;
    bool4 _1289 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u).xxxx;
    _9 = float4(_1289.x ? _93.x : _9.x, _1289.y ? _93.y : _9.y, _1289.z ? _93.z : _9.z, _1289.w ? _93.w : _9.w);
    _1292 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _1126 = stage_input._1126;
    _1159 = stage_input._1159;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1292 = _1292;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}