// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmParticle" {
Properties {

_MainTex ("Texture (Texture shape)", 2D) = "white" { }

_TintColor ("Tint", Color) = (1,1,1,1)

_Detail ("Texture Detail", Range(0, 1)) = 0.44999998807907104

_NearFade ("Near Fade Distance", Float) = 0.3499999940395355

_NearFadeRange ("Near Fade Range", Float) = 0.5

[KeywordEnum(Tex, Drop, Shard)] _Shape ("Shape", Float) = 0.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_local __ _SHAPE_DROP
#pragma multi_compile_local __ _SHAPE_SHARD
#pragma multi_compile_local __ _SHAPE_TEX
#if defined(_SHAPE_SHARD)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_MatrixV;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float4 _MainTex_ST;
float4 _TintColor;
float _NearFade;
float _NearFadeRange;
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _21_m1[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _21_m1[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _21_m1[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m3 _MainTex_ST
#define _21_m4 _TintColor
#define _21_m5 _NearFade
#define _21_m6 _NearFadeRange



static float4 gl_Position;
static float4 _11;
static float4 _146;
static float4 _152;
static float2 vs_TEXCOORD0;
static float2 _169;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _146 : COLOR;
    float2 _169 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _152 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _84;
static float4 _145;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _9 += _21_m0[3];
    _49 = _9.yyyy * _21_m2[1];
    _49 = (_21_m2[0] * _9.xxxx) + _49;
    _49 = (_21_m2[2] * _9.zzzz) + _49;
    gl_Position = (_21_m2[3] * _9.wwww) + _49;
    _84 = _9.y * _21_m1[1].z;
    _9.x = (_21_m1[0].z * _9.x) + _84;
    _9.x = (_21_m1[2].z * _9.z) + _9.x;
    _9.x = (_21_m1[3].z * _9.w) + _9.x;
    _9.x = (-_9.x) + (-_21_m5);
    _84 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _84;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _145 = _146 * _21_m4;
    _152.w = _9.x * _145.w;
    _152 = float4(_145.xyz.x, _145.xyz.y, _145.xyz.z, _152.w);
    vs_TEXCOORD0 = (_169 * _21_m3.xy) + _21_m3.zw;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    _169 = stage_input._169;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._152 = _152;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float2 vs_TEXCOORD0;
static float4 _69;
static float4 _77;

struct SPIRV_Cross_Input
{
    float4 _77 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _69 : SV_Target0;
};

static float2 _9;
static float2 _19;
static float _36;
static float2 _49;

void frag_inner()
{
    _9 = (vs_TEXCOORD0 * 2.0f.xx) + (-1.0f).xx;
    _19 = abs(_9) * float2(1.89999997615814208984375f, 1.14999997615814208984375f);
    _9.x = _9.y * _9.x;
    _36 = _19.y + _19.x;
    _9.x = (_9.x * 0.3499999940395355224609375f) + _36;
    _49 = (-_9.xx) + float2(1.0f, 0.449999988079071044921875f);
    _49 *= float2(7.0f, 4.0f);
    _49 = clamp(_49, 0.0f.xx, 1.0f.xx);
    float3 _80 = (_49.yyy * 0.60000002384185791015625f.xxx) + _77.xyz;
    _69 = float4(_80.x, _80.y, _80.z, _69.w);
    _69.w = _49.x * _77.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _77 = stage_input._77;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._69 = _69;
    return stage_output;
}

#endif
#elif defined(_SHAPE_TEX)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_MatrixV;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float4 _MainTex_ST;
float4 _TintColor;
float _NearFade;
float _NearFadeRange;
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _21_m1[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _21_m1[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _21_m1[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m3 _MainTex_ST
#define _21_m4 _TintColor
#define _21_m5 _NearFade
#define _21_m6 _NearFadeRange



static float4 gl_Position;
static float4 _11;
static float4 _146;
static float4 _152;
static float2 vs_TEXCOORD0;
static float2 _169;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _146 : COLOR;
    float2 _169 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _152 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _84;
static float4 _145;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _9 += _21_m0[3];
    _49 = _9.yyyy * _21_m2[1];
    _49 = (_21_m2[0] * _9.xxxx) + _49;
    _49 = (_21_m2[2] * _9.zzzz) + _49;
    gl_Position = (_21_m2[3] * _9.wwww) + _49;
    _84 = _9.y * _21_m1[1].z;
    _9.x = (_21_m1[0].z * _9.x) + _84;
    _9.x = (_21_m1[2].z * _9.z) + _9.x;
    _9.x = (_21_m1[3].z * _9.w) + _9.x;
    _9.x = (-_9.x) + (-_21_m5);
    _84 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _84;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _145 = _146 * _21_m4;
    _152.w = _9.x * _145.w;
    _152 = float4(_145.xyz.x, _145.xyz.y, _145.xyz.z, _152.w);
    vs_TEXCOORD0 = (_169 * _21_m3.xy) + _21_m3.zw;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    _169 = stage_input._169;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._152 = _152;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Detail;
#define _52_m0 _Detail


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _34;
static float4 _39;

struct SPIRV_Cross_Input
{
    float4 _39 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _34 : SV_Target0;
};

static float2 _9;
static float _22;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).yw;
    _22 = _9.x * 1.35000002384185791015625f;
    _22 = clamp(_22, 0.0f, 1.0f);
    _34.w = _9.y * _39.w;
    _22 += (-1.0f);
    _22 = (_52_m0 * _22) + 1.0f;
    float3 _66 = _22.xxx * _39.xyz;
    _34 = float4(_66.x, _66.y, _66.z, _34.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _39 = stage_input._39;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._34 = _34;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_MatrixV;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float4 _MainTex_ST;
float4 _TintColor;
float _NearFade;
float _NearFadeRange;
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _21_m1[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _21_m1[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _21_m1[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m3 _MainTex_ST
#define _21_m4 _TintColor
#define _21_m5 _NearFade
#define _21_m6 _NearFadeRange



static float4 gl_Position;
static float4 _11;
static float4 _146;
static float4 _152;
static float2 vs_TEXCOORD0;
static float2 _169;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _146 : COLOR;
    float2 _169 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _152 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _84;
static float4 _145;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _9 += _21_m0[3];
    _49 = _9.yyyy * _21_m2[1];
    _49 = (_21_m2[0] * _9.xxxx) + _49;
    _49 = (_21_m2[2] * _9.zzzz) + _49;
    gl_Position = (_21_m2[3] * _9.wwww) + _49;
    _84 = _9.y * _21_m1[1].z;
    _9.x = (_21_m1[0].z * _9.x) + _84;
    _9.x = (_21_m1[2].z * _9.z) + _9.x;
    _9.x = (_21_m1[3].z * _9.w) + _9.x;
    _9.x = (-_9.x) + (-_21_m5);
    _84 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _84;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _145 = _146 * _21_m4;
    _152.w = _9.x * _145.w;
    _152 = float4(_145.xyz.x, _145.xyz.y, _145.xyz.z, _152.w);
    vs_TEXCOORD0 = (_169 * _21_m3.xy) + _21_m3.zw;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    _169 = stage_input._169;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._152 = _152;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float2 vs_TEXCOORD0;
static float4 _109;
static float4 _112;

struct SPIRV_Cross_Input
{
    float4 _112 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _109 : SV_Target0;
};

static float4 _9;
static float _24;
static float _42;
static float _66;
static float _86;
static float _91;

void frag_inner()
{
    _9 = (vs_TEXCOORD0.xyxy * 2.0f.xxxx) + float4(-1.0f, -1.0f, -0.699999988079071044921875f, -1.2999999523162841796875f);
    _24 = dot(_9.zw, _9.zw);
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _42 = _9.x + (-0.550000011920928955078125f);
    _42 *= 2.22222232818603515625f;
    _42 = clamp(_42, 0.0f, 1.0f);
    _9.x = sqrt(_24);
    _9.x *= 2.857142925262451171875f;
    _9.x = min(_9.x, 1.0f);
    _66 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_66) * _9.x) + 1.0f;
    _86 = _9.x * 0.550000011920928955078125f;
    _91 = (_42 * (-2.0f)) + 3.0f;
    _42 *= _42;
    _42 = ((-_91) * _42) + 1.0f;
    _91 = (_42 * 0.25f) + 0.75f;
    _109.w = _42 * _112.w;
    float3 _128 = (_112.xyz * _91.xxx) + _86.xxx;
    _109 = float4(_128.x, _128.y, _128.z, _109.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _112 = stage_input._112;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._109 = _109;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}