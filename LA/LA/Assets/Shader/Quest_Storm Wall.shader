// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Quest/Storm Wall" {
Properties {

[Header(Color)] _Color ("Storm Color", Color) = (0.42,0.24,0.85,1)

_RimColor ("Rim Color", Color) = (0.75,0.55,1,1)

_RimPower ("Rim Power", Range(0.2, 8)) = 2.5

_RimBoost ("Rim Boost", Range(0, 4)) = 1.399999976158142

_Alpha ("Opacity", Range(0, 1)) = 0.550000011920929

[Header(Noise)] _NoiseTex ("Noise", 2D) = "white" { }

_AngularTiles ("Angular Tiles", Range(1, 64)) = 12.0

_VerticalTiles ("Vertical Tiles", Range(0.01, 4)) = 0.3499999940395355

_ScrollSpeed ("Scroll (Angular, Vertical)", Vector) = (0.06,-0.13,0,0)

_Distort ("Distortion", Range(0, 1)) = 0.3499999940395355

_DistortScale ("Distortion Scale", Range(0.1, 4)) = 0.44999998807907104

_NoiseContrast ("Noise Contrast", Range(0.5, 4)) = 1.600000023841858

[Header(Fades)] [Toggle(_SCENEDEPTHFADE_ON)] _SceneDepthFadeEnabled ("Scene Depth Fade (needs camera depth texture)", Float) = 1.0

_DepthFade ("Scene Depth Fade", Range(0.01, 8)) = 1.2000000476837158

_CameraFade ("Near Camera Fade", Range(0, 5)) = 0.6000000238418579

_TopFade ("Top Fade", Range(0, 1)) = 0.25

_BottomFade ("Bottom Fade", Range(0, 1)) = 0.07999999821186066

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
 Name "StormWall"
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_local __ _SCENEDEPTHFADE_ON
#if defined(_SCENEDEPTHFADE_ON)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float3 _100;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _100 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _122;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    vs_TEXCOORD0 = _11.xyz;
    _44.x = dot(_100, _21_m2[0].xyz);
    _44.y = dot(_100, _21_m2[1].xyz);
    _44.z = dot(_100, _21_m2[2].xyz);
    _122 = dot(_44.xyz, _44.xyz);
    _122 = rsqrt(_122);
    vs_TEXCOORD2 = _122.xxx * _44.xyz;
    _9.y *= _21_m0.x;
    float3 _147 = _9.xwy * 0.5f.xxx;
    _44 = float4(_147.x, _44.y, _147.y, _147.z);
    vs_TEXCOORD3 = float4(vs_TEXCOORD3.x, vs_TEXCOORD3.y, _9.zw.x, _9.zw.y);
    float2 _160 = _44.zz + _44.xw;
    vs_TEXCOORD3 = float4(_160.x, _160.y, vs_TEXCOORD3.z, vs_TEXCOORD3.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ZBufferParams;
float4 _Color;
float4 _RimColor;
float _RimPower;
float _RimBoost;
float _Alpha;
float _AngularTiles;
float _VerticalTiles;
float4 _ScrollSpeed;
float _Distort;
float _DistortScale;
float _NoiseContrast;
float _DepthFade;
float _CameraFade;
float _TopFade;
float _BottomFade;
#define _195_m0 _Time
#define _195_m1 _WorldSpaceCameraPos
#define _195_m2 _ZBufferParams
#define _195_m3 _Color
#define _195_m4 _RimColor
#define _195_m5 _RimPower
#define _195_m6 _RimBoost
#define _195_m7 _Alpha
#define _195_m8 _AngularTiles
#define _195_m9 _VerticalTiles
#define _195_m10 _ScrollSpeed
#define _195_m11 _Distort
#define _195_m12 _DistortScale
#define _195_m13 _NoiseContrast
#define _195_m14 _DepthFade
#define _195_m15 _CameraFade
#define _195_m16 _TopFade
#define _195_m17 _BottomFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;
Texture2D<float4> _CameraDepthTexture;
SamplerState sampler_CameraDepthTexture;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;
static float4 _632;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _632 : SV_Target0;
};

static float2 _9;
static float3 _27;
static float2 _53;
static bool _93;
static bool _128;
static bool _163;
static float _250;
static float _281;
static float4 _313;
static float _406;
static bool _435;
static float2 _457;
static float _508;
static float _574;
static float4 _618;

void frag_inner()
{
    _9.x = min(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.z));
    _27.x = max(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.z));
    _27.x = 1.0f / _27.x;
    _9.x = _27.x * _9.x;
    _27.x = _9.x * _9.x;
    _53.x = (_27.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _53.x = (_27.x * _53.x) + 0.1801410019397735595703125f;
    _53.x = (_27.x * _53.x) + (-0.33029949665069580078125f);
    _27.x = (_27.x * _53.x) + 0.999866008758544921875f;
    _53.x = _27.x * _9.x;
    _93 = abs(vs_TEXCOORD0.x) < abs(vs_TEXCOORD0.z);
    _53.x = (_53.x * (-2.0f)) + 1.57079637050628662109375f;
    float _110;
    if (_93)
    {
        _110 = _53.x;
    }
    else
    {
        _110 = 0.0f;
    }
    _53.x = _110;
    _9.x = (_9.x * _27.x) + _53.x;
    _128 = vs_TEXCOORD0.x < (-vs_TEXCOORD0.x);
    _27.x = _128 ? (-3.1415927410125732421875f) : 0.0f;
    _9.x = _27.x + _9.x;
    _27.x = min(vs_TEXCOORD0.x, vs_TEXCOORD0.z);
    _53.x = max(vs_TEXCOORD0.x, vs_TEXCOORD0.z);
    _128 = _27.x < (-_27.x);
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
    _27.x = round(_195_m8);
    _27.x = max(_27.x, 1.0f);
    _9.x = _27.x * _9.x;
    _9.y = vs_TEXCOORD1.y * _195_m9;
    _53 = _195_m0.yy * _195_m10.xy;
    _53 *= 0.60000002384185791015625f.xx;
    _53 = (_9 * float2(float2(_195_m12, _195_m12))) + (-_53);
    _250 = _NoiseTex.Sample(sampler_NoiseTex, _53).x;
    _53.x = _250 + (-0.5f);
    _9 = (_195_m10.xy * _195_m0.yy) + _9;
    _9 = (_53.xx * _195_m11.xx) + _9;
    _281 = _NoiseTex.Sample(sampler_NoiseTex, _9).x;
    _9.x = log2(abs(_281));
    _9.x *= _195_m13;
    _9.x = exp2(_9.x);
    _9.x = min(_9.x, 1.0f);
    _27 = (-vs_TEXCOORD1) + _195_m1;
    _313.x = dot(_27, _27);
    _313.x = rsqrt(_313.x);
    _27 *= _313.xxx;
    _313.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _313.x = rsqrt(_313.x);
    float3 _338 = _313.xxx * vs_TEXCOORD2;
    _313 = float4(_338.x, _338.y, _338.z, _313.w);
    _27.x = dot(_313.xyz, _27);
    _27.x = min(abs(_27.x), 1.0f);
    _27.x = (-_27.x) + 1.0f;
    _27.x = log2(_27.x);
    _27.x *= _195_m5;
    _27.x = exp2(_27.x);
    _53 = vs_TEXCOORD3.xy / vs_TEXCOORD3.ww;
    _53.x = _CameraDepthTexture.Sample(sampler_CameraDepthTexture, _53).x;
    _53.x = (_195_m2.z * _53.x) + _195_m2.w;
    _53.x = 1.0f / _53.x;
    _53.x += (-vs_TEXCOORD3.w);
    _406 = max(_195_m14, 9.9999997473787516355514526367188e-05f);
    _53.x /= _406;
    _53.x = clamp(_53.x, 0.0f, 1.0f);
    float3 _425 = vs_TEXCOORD1 + (-_195_m1);
    _313 = float4(_425.x, _425.y, _425.z, _313.w);
    _406 = dot(_313.xyz, _313.xyz);
    _406 = sqrt(_406);
    _435 = 9.9999997473787516355514526367188e-05f < _195_m15;
    _406 /= _195_m15;
    _406 = clamp(_406, 0.0f, 1.0f);
    _406 = _435 ? _406 : 1.0f;
    _313.x = vs_TEXCOORD0.y + 0.5f;
    _313.x = clamp(_313.x, 0.0f, 1.0f);
    _457 = max(float2(_195_m17, _195_m16), 9.9999997473787516355514526367188e-05f.xx);
    _457 = 1.0f.xx / _457;
    _457.x *= _313.x;
    _457.x = min(_457.x, 1.0f);
    _313.w = (_457.x * (-2.0f)) + 3.0f;
    _457.x *= _457.x;
    _313.x = (-_313.x) + 1.0f;
    float2 _501 = _457.yx * _313.xw;
    _313 = float4(_501.x, _501.y, _313.z, _313.w);
    _313.x = min(_313.x, 1.0f);
    _508 = (_313.x * (-2.0f)) + 3.0f;
    _313.x *= _313.x;
    _313.x *= _508;
    _313.x *= _313.y;
    _457.x = _195_m3.w * _195_m7;
    _508 = _27.x * _195_m6;
    _27.x = (_27.x * _195_m6) + _9.x;
    _27.x = clamp(_27.x, 0.0f, 1.0f);
    _27.x *= _457.x;
    _53.x = _406 * _53.x;
    _53.x = _313.x * _53.x;
    _574 = _53.x * _27.x;
    _128 = 0.0030000000260770320892333984375f >= _574;
    if ((int(_128) * (-1)) != 0)
    {
        discard;
    }
    _508 = _508;
    _508 = clamp(_508, 0.0f, 1.0f);
    _27 = (-_195_m3.xyz) + _195_m4.xyz;
    _27 = (_508.xxx * _27) + _195_m3.xyz;
    _9.x = (_9.x * 0.699999988079071044921875f) + 0.64999997615814208984375f;
    float3 _622 = _9.xxx * _27;
    _618 = float4(_622.x, _622.y, _622.z, _618.w);
    _618.w = _574;
    _618.w = clamp(_618.w, 0.0f, 1.0f);
    _632 = _618;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._632 = _632;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float3 _100;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _100 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _122;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    vs_TEXCOORD0 = _11.xyz;
    _44.x = dot(_100, _21_m2[0].xyz);
    _44.y = dot(_100, _21_m2[1].xyz);
    _44.z = dot(_100, _21_m2[2].xyz);
    _122 = dot(_44.xyz, _44.xyz);
    _122 = rsqrt(_122);
    vs_TEXCOORD2 = _122.xxx * _44.xyz;
    _9.y *= _21_m0.x;
    float3 _147 = _9.xwy * 0.5f.xxx;
    _44 = float4(_147.x, _44.y, _147.y, _147.z);
    vs_TEXCOORD3 = float4(vs_TEXCOORD3.x, vs_TEXCOORD3.y, _9.zw.x, _9.zw.y);
    float2 _160 = _44.zz + _44.xw;
    vs_TEXCOORD3 = float4(_160.x, _160.y, vs_TEXCOORD3.z, vs_TEXCOORD3.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _Color;
float4 _RimColor;
float _RimPower;
float _RimBoost;
float _Alpha;
float _AngularTiles;
float _VerticalTiles;
float4 _ScrollSpeed;
float _Distort;
float _DistortScale;
float _NoiseContrast;
float _CameraFade;
float _TopFade;
float _BottomFade;
#define _196_m0 _Time
#define _196_m1 _WorldSpaceCameraPos
#define _196_m2 _Color
#define _196_m3 _RimColor
#define _196_m4 _RimPower
#define _196_m5 _RimBoost
#define _196_m6 _Alpha
#define _196_m7 _AngularTiles
#define _196_m8 _VerticalTiles
#define _196_m9 _ScrollSpeed
#define _196_m10 _Distort
#define _196_m11 _DistortScale
#define _196_m12 _NoiseContrast
#define _196_m13 _CameraFade
#define _196_m14 _TopFade
#define _196_m15 _BottomFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _585;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _585 : SV_Target0;
};

static float4 _9;
static float3 _27;
static float2 _55;
static bool _95;
static bool _130;
static bool _165;
static float _252;
static float _289;
static float3 _317;
static float _409;
static float _441;
static float _472;
static float _527;
static float4 _571;

void frag_inner()
{
    _9.x = min(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.z));
    _27.x = max(abs(vs_TEXCOORD0.x), abs(vs_TEXCOORD0.z));
    _27.x = 1.0f / _27.x;
    _9.x = _27.x * _9.x;
    _27.x = _9.x * _9.x;
    _55.x = (_27.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _55.x = (_27.x * _55.x) + 0.1801410019397735595703125f;
    _55.x = (_27.x * _55.x) + (-0.33029949665069580078125f);
    _27.x = (_27.x * _55.x) + 0.999866008758544921875f;
    _55.x = _27.x * _9.x;
    _95 = abs(vs_TEXCOORD0.x) < abs(vs_TEXCOORD0.z);
    _55.x = (_55.x * (-2.0f)) + 1.57079637050628662109375f;
    float _112;
    if (_95)
    {
        _112 = _55.x;
    }
    else
    {
        _112 = 0.0f;
    }
    _55.x = _112;
    _9.x = (_9.x * _27.x) + _55.x;
    _130 = vs_TEXCOORD0.x < (-vs_TEXCOORD0.x);
    _27.x = _130 ? (-3.1415927410125732421875f) : 0.0f;
    _9.x = _27.x + _9.x;
    _27.x = min(vs_TEXCOORD0.x, vs_TEXCOORD0.z);
    _55.x = max(vs_TEXCOORD0.x, vs_TEXCOORD0.z);
    _130 = _27.x < (-_27.x);
    _165 = _55.x >= (-_55.x);
    _130 = _165 && _130;
    float _176;
    if (_130)
    {
        _176 = -_9.x;
    }
    else
    {
        _176 = _9.x;
    }
    _9.x = _176;
    _9.x = (_9.x * 0.15915493667125701904296875f) + 0.5f;
    _27.x = round(_196_m7);
    _27.x = max(_27.x, 1.0f);
    _9.x = _27.x * _9.x;
    _9.y = vs_TEXCOORD1.y * _196_m8;
    _55 = _196_m0.yy * _196_m9.xy;
    _55 *= 0.60000002384185791015625f.xx;
    _55 = (_9.xy * float2(float2(_196_m11, _196_m11))) + (-_55);
    _252 = _NoiseTex.Sample(sampler_NoiseTex, _55).x;
    _55.x = _252 + (-0.5f);
    float2 _274 = (_196_m9.xy * _196_m0.yy) + _9.xy;
    _9 = float4(_274.x, _274.y, _9.z, _9.w);
    float2 _286 = (_55.xx * _196_m10.xx) + _9.xy;
    _9 = float4(_286.x, _286.y, _9.z, _9.w);
    _289 = _NoiseTex.Sample(sampler_NoiseTex, _9.xy).x;
    _9.x = log2(abs(_289));
    _9.x *= _196_m12;
    _9.x = exp2(_9.x);
    _27 = (-vs_TEXCOORD1) + _196_m1;
    _317.x = dot(_27, _27);
    _317.x = rsqrt(_317.x);
    _27 *= _317.xxx;
    _317.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _317.x = rsqrt(_317.x);
    _317 = _317.xxx * vs_TEXCOORD2;
    _27.x = dot(_317, _27);
    _27.x = min(abs(_27.x), 1.0f);
    _27.x = (-_27.x) + 1.0f;
    _27.x = log2(_27.x);
    _27.x *= _196_m4;
    _27.x = exp2(_27.x);
    _317 = vs_TEXCOORD1 + (-_196_m1);
    _55.x = dot(_317, _317);
    _55.x = sqrt(_55.x);
    _95 = 9.9999997473787516355514526367188e-05f < _196_m13;
    _55.x /= _196_m13;
    _55.x = clamp(_55.x, 0.0f, 1.0f);
    float _401;
    if (_95)
    {
        _401 = _55.x;
    }
    else
    {
        _401 = 1.0f;
    }
    _55.x = _401;
    _409 = vs_TEXCOORD0.y + 0.5f;
    _409 = clamp(_409, 0.0f, 1.0f);
    float2 _423 = max(float2(_196_m15, _196_m14), 9.9999997473787516355514526367188e-05f.xx);
    _317 = float3(_423.x, _423.y, _317.z);
    float2 _429 = 1.0f.xx / _317.xy;
    _317 = float3(_429.x, _429.y, _317.z);
    _317.x = _409 * _317.x;
    _317.x = min(_317.x, 1.0f);
    _441 = (_317.x * (-2.0f)) + 3.0f;
    _317.x *= _317.x;
    _317.x *= _441;
    _409 = (-_409) + 1.0f;
    _9.w = _317.y * _409;
    float2 _469 = min(_9.xw, 1.0f.xx);
    _9 = float4(_469.x, _9.y, _9.z, _469.y);
    _472 = (_9.w * (-2.0f)) + 3.0f;
    _409 = _9.w * _9.w;
    _409 *= _472;
    _409 *= _317.x;
    _317.x = _196_m2.w * _196_m6;
    _472 = _27.x * _196_m5;
    _27.x = (_27.x * _196_m5) + _9.x;
    _27.x = clamp(_27.x, 0.0f, 1.0f);
    _27.x *= _317.x;
    _55.x = _409 * _55.x;
    _527 = _55.x * _27.x;
    _130 = 0.0030000000260770320892333984375f >= _527;
    if ((int(_130) * (-1)) != 0)
    {
        discard;
    }
    _472 = _472;
    _472 = clamp(_472, 0.0f, 1.0f);
    _27 = (-_196_m2.xyz) + _196_m3.xyz;
    _27 = (_472.xxx * _27) + _196_m2.xyz;
    _9.x = (_9.x * 0.699999988079071044921875f) + 0.64999997615814208984375f;
    float3 _575 = _9.xxx * _27;
    _571 = float4(_575.x, _575.y, _575.z, _571.w);
    _571.w = _527;
    _571.w = clamp(_571.w, 0.0f, 1.0f);
    _585 = _571;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._585 = _585;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}