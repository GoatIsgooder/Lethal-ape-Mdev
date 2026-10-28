// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Rivals/RadialFill" {
Properties {

_FillAmount ("Fill Amount", Range(0, 1)) = 0.0

_FillColor ("Fill Color", Color) = (1,0.84,0,1)

_BackColor ("Back Color", Color) = (0.08,0.1,0.14,0.9)

_Flash ("White Flash", Range(0, 2)) = 0.0

_Alpha ("Master Alpha", Range(0, 1)) = 1.0

_InnerRadius ("Inner Radius", Range(0, 1)) = 0.7400000095367432

_OuterRadius ("Outer Radius", Range(0, 1)) = 0.9700000286102295

_GlowStrength ("Edge Glow Strength", Range(0, 3)) = 0.8999999761581421

_IconTex ("Icon", 2D) = "white" { }

_IconColor ("Icon Tint (a=0 hides)", Color) = (1,1,1,0)

_IconScale ("Icon Scale", Range(0.05, 1)) = 0.5199999809265137

_IconRect ("Icon UV Rect (x,y,w,h)", Vector) = (0,0,1,1)

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay-3" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay-3" "RenderType" = "Transparent" }
 ZTest Always
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
 ZTest Always
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

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
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
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _FillAmount;
float4 _FillColor;
float4 _BackColor;
float _Flash;
float _Alpha;
float _InnerRadius;
float _OuterRadius;
float _GlowStrength;
float4 _IconColor;
float _IconScale;
float4 _IconRect;
#define _203_m0 _FillAmount
#define _203_m1 _FillColor
#define _203_m2 _BackColor
#define _203_m3 _Flash
#define _203_m4 _Alpha
#define _203_m5 _InnerRadius
#define _203_m6 _OuterRadius
#define _203_m7 _GlowStrength
#define _203_m8 _IconColor
#define _203_m9 _IconScale
#define _203_m10 _IconRect


Texture2D<float4> _IconTex;
SamplerState sampler_IconTex;

static float2 vs_TEXCOORD0;
static float4 _642;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _642 : SV_Target0;
};

static float4 _9;
static float2 _20;
static float3 _28;
static float3 _46;
static float _67;
static bool _105;
static bool _125;
static bool _167;
static float _175;
static float3 _292;
static float _303;
static float4 _322;
static float4 _529;
static float3 _538;
static bool2 _561;
static bool2 _568;
static float3 _609;
static float3 _630;

void frag_inner()
{
    float2 _16 = vs_TEXCOORD0 + (-0.5f).xx;
    _9 = float4(_16.x, _16.y, _9.z, _9.w);
    _20 = _9.xy + _9.xy;
    _28.x = max(abs(_20.y), abs(_20.x));
    _28.x = 1.0f / _28.x;
    _46.x = min(abs(_20.y), abs(_20.x));
    _28.x *= _46.x;
    _46.x = _28.x * _28.x;
    _67 = (_46.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _67 = (_46.x * _67) + 0.1801410019397735595703125f;
    _67 = (_46.x * _67) + (-0.33029949665069580078125f);
    _46.x = (_46.x * _67) + 0.999866008758544921875f;
    _67 = _46.x * _28.x;
    _67 = (_67 * (-2.0f)) + 1.57079637050628662109375f;
    _105 = abs(_20.y) < abs(_20.x);
    _67 = _105 ? _67 : 0.0f;
    _28.x = (_28.x * _46.x) + _67;
    _125 = _20.y < (-_20.y);
    _46.x = _125 ? (-3.1415927410125732421875f) : 0.0f;
    _28.x = _46.x + _28.x;
    _46.x = min(_20.y, _20.x);
    _125 = _46.x < (-_46.x);
    _67 = max(_20.y, _20.x);
    _20.x = dot(_20, _20);
    _20.x = sqrt(_20.x);
    _167 = _67 >= (-_67);
    _167 = _167 && _125;
    float _178;
    if (_167)
    {
        _178 = -_28.x;
    }
    else
    {
        _178 = _28.x;
    }
    _175 = _178;
    _175 *= 0.15915493667125701904296875f;
    _175 = frac(_175);
    _28.x = ddx_coarse(_175);
    _46.x = ddy_coarse(_175);
    _175 = (-_175) + _203_m0;
    _28.x = abs(_46.x) + abs(_28.x);
    _28.x = max(_28.x, 9.9999997473787516355514526367188e-05f);
    _28.x = min(_28.x, 0.0199999995529651641845703125f);
    _28.x = _175 / _28.x;
    _175 = max(_175, 0.0f);
    _175 *= (-31.7392902374267578125f);
    _175 = exp2(_175);
    _175 *= _203_m7;
    _28.x += 0.5f;
    _28.x = clamp(_28.x, 0.0f, 1.0f);
    _125 = 9.9999997473787516355514526367188e-05f >= _203_m0;
    float _258;
    if (_125)
    {
        _258 = 0.0f;
    }
    else
    {
        _258 = _28.x;
    }
    _28.x = _258;
    _125 = _203_m0 >= 0.99989998340606689453125f;
    float _271;
    if (_125)
    {
        _271 = 1.0f;
    }
    else
    {
        _271 = _28.x;
    }
    _28.x = _271;
    _175 = (_175 * _28.x) + 1.0f;
    _46 = _175.xxx * _203_m1.xyz;
    _292 = ((-_203_m1.xyz) * _175.xxx) + 1.60000002384185791015625f.xxx;
    _303 = _203_m3;
    _303 = clamp(_303, 0.0f, 1.0f);
    _292 = (_303.xxx * _292) + _46;
    float2 _319 = _303.xx * float2(0.85000002384185791015625f, 0.5f);
    _46 = float3(_319.x, _319.y, _46.z);
    float3 _329 = (-_203_m2.xyz) + 1.0f.xxx;
    _322 = float4(_329.x, _329.y, _329.z, _322.w);
    float3 _340 = (_46.xxx * _322.xyz) + _203_m2.xyz;
    _322 = float4(_340.x, _340.y, _340.z, _322.w);
    _292 += (-_322.xyz);
    _292 = (_28.xxx * _292) + _322.xyz;
    _175 = ddx_coarse(_20.x);
    _46.x = ddy_coarse(_20.x);
    _175 = abs(_175) + abs(_46.x);
    _175 = max(_175, 9.9999997473787516355514526367188e-05f);
    float2 _383 = ((-_175.xx) * 1.2000000476837158203125f.xx) + float2(_203_m5, _203_m6);
    _46 = float3(_383.x, _46.y, _383.y);
    float2 _394 = (_175.xx * 1.2000000476837158203125f.xx) + float2(_203_m5, _203_m6);
    _322 = float4(_394.x, _394.y, _322.z, _322.w);
    float2 _402 = (-_46.xz) + _322.xy;
    _322 = float4(_402.x, _402.y, _322.z, _322.w);
    _20 = _20.xx + (-_46.xz);
    float2 _414 = 1.0f.xx / _322.xy;
    _46 = float3(_414.x, _46.y, _414.y);
    _20 *= _46.xz;
    _20 = clamp(_20, 0.0f.xx, 1.0f.xx);
    float2 _430 = (_20 * (-2.0f).xx) + 3.0f.xx;
    _46 = float3(_430.x, _46.y, _430.y);
    _20 *= _20;
    _20.x *= _46.x;
    _175 = ((-_46.z) * _20.y) + 1.0f;
    _9.z = _175 * _20.x;
    _303 = _203_m1.w + (-_203_m2.w);
    _303 = (_28.x * _303) + _203_m2.w;
    _175 = (-_303) + 1.0f;
    _9.w = (_46.y * _175) + _303;
    _28.x = ((-_9.w) * _9.z) + 1.0f;
    _303 = max(_203_m9, 0.001000000047497451305389404296875f);
    float2 _496 = _9.xy / _303.xx;
    _9 = float4(_496.x, _496.y, _9.z, _9.w);
    float2 _502 = _9.xy + 0.5f.xx;
    _9 = float4(_502.x, _502.y, _9.z, _9.w);
    _46 = float3(_9.xy.x, _46.y, _9.xy.y);
    float2 _513 = clamp(_46.xz, 0.0f.xx, 1.0f.xx);
    _46 = float3(_513.x, _46.y, _513.y);
    float2 _526 = (_46.xz * _203_m10.zw) + _203_m10.xy;
    _46 = float3(_526.x, _46.y, _526.y);
    _529 = _IconTex.Sample(sampler_IconTex, _46.xz);
    _538 = ((-_529.xyz) * _203_m8.xyz) + 1.60000002384185791015625f.xxx;
    _322 = _529 * _203_m8;
    _46 = (_46.yyy * _538) + _322.xyz;
    _561 = bool4(_9.xyxx.x >= 0.0f.xxxx.x, _9.xyxx.y >= 0.0f.xxxx.y, _9.xyxx.z >= 0.0f.xxxx.z, _9.xyxx.w >= 0.0f.xxxx.w).xy;
    _568 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x >= _9.xyxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y >= _9.xyxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z >= _9.xyxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w >= _9.xyxx.w).xy;
    _9.x = float(_568.x);
    _9.y = float(_568.y);
    _322.x = float(_561.x);
    _322.y = float(_561.y);
    float2 _594 = _9.xy * _322.xy;
    _9 = float4(_594.x, _594.y, _9.z, _9.w);
    float2 _601 = _9.yz * _9.xw;
    _9 = float4(_601.x, _9.y, _601.y, _9.w);
    _303 = _9.x * _322.w;
    _609 = _46 * _303.xxx;
    _9.x = (_303 * _28.x) + _9.z;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _28 = _28.xxx * _609;
    _630 = (_292 * _9.zzz) + _28;
    _292.x = max(_9.x, 9.9999997473787516355514526367188e-05f);
    _642.w = _9.x * _203_m4;
    float3 _654 = _630 / _292.xxx;
    _9 = float4(_654.x, _654.y, _654.z, _9.w);
    _642 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _642.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._642 = _642;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}