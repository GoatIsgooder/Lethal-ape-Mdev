// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/UI/SeasonPassPulse" {
Properties {

_MainTex ("Sprite Texture", 2D) = "white" { }

_Color ("Tint", Color) = (1,1,1,1)

_PulseSpeed ("Pulse Speed", Float) = 3.200000047683716

_PulseMin ("Pulse Min Alpha", Range(0, 1)) = 0.25

_StencilComp ("Stencil Comparison", Float) = 8.0

_Stencil ("Stencil ID", Float) = 0.0

_StencilOp ("Stencil Operation", Float) = 0.0

_StencilWriteMask ("Stencil Write Mask", Float) = 255.0

_StencilReadMask ("Stencil Read Mask", Float) = 255.0

_ColorMask ("Color Mask", Float) = 15.0

[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0.0

}
SubShader {
 Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
Stencil {
 Ref [_Stencil]
 ReadMask [_StencilReadMask]
 WriteMask [_StencilWriteMask]
 Comp [_StencilComp]
 Pass [_StencilOp]
}
 Name "Default"
  Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZTest [unity_GUIZTestMode]
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
 ColorMask [_ColorMask]
 ZTest [unity_GUIZTestMode]
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile __ UNITY_UI_ALPHACLIP
#pragma multi_compile __ UNITY_UI_CLIP_RECT
#if defined(UNITY_UI_ALPHACLIP) && defined(UNITY_UI_CLIP_RECT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 _Color;
float4 _MainTex_ST;
float _PulseSpeed;
float _PulseMin;
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
#define _20_m0 _Time
#define _20_m3 _Color
#define _20_m4 _MainTex_ST
#define _20_m5 _PulseSpeed
#define _20_m6 _PulseMin



static float4 gl_Position;
static float4 _11;
static float4 _123;
static float4 _135;
static float2 vs_TEXCOORD0;
static float2 _141;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _123 : COLOR;
    float2 _141 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _135 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float _108;

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
    gl_Position = (_20_m2[3] * _9.wwww) + _48;
    _9.x = _20_m0.y * _20_m5;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x *= _9.x;
    _108 = (-_20_m6) + 1.0f;
    _9.x = (_9.x * _108) + _20_m6;
    _48 = _123 * _20_m3;
    _48.w = _9.x * _48.w;
    _135 = _48;
    vs_TEXCOORD0 = (_141 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD1 = _11;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _123 = stage_input._123;
    _141 = stage_input._141;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._135 = _135;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _TextureSampleAdd;
float4 _ClipRect;
#define _18_m0 _TextureSampleAdd
#define _18_m1 _ClipRect


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _97;
static float4 _115;

struct SPIRV_Cross_Input
{
    float4 _97 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _115 : SV_Target0;
};

static bool4 _9;
static float4 _40;
static float4 _80;
static float4 _90;
static float _100;

void frag_inner()
{
    bool2 _27 = bool4(vs_TEXCOORD1.xyxx.x >= _18_m1.xyxx.x, vs_TEXCOORD1.xyxx.y >= _18_m1.xyxx.y, vs_TEXCOORD1.xyxx.z >= _18_m1.xyxx.z, vs_TEXCOORD1.xyxx.w >= _18_m1.xyxx.w).xy;
    _9 = bool4(_27.x, _27.y, _9.z, _9.w);
    bool2 _36 = bool4(_18_m1.zzzw.x >= vs_TEXCOORD1.xxxy.x, _18_m1.zzzw.y >= vs_TEXCOORD1.xxxy.y, _18_m1.zzzw.z >= vs_TEXCOORD1.xxxy.z, _18_m1.zzzw.w >= vs_TEXCOORD1.xxxy.w).zw;
    _9 = bool4(_9.x, _9.y, _36.x, _36.y);
    _40.x = float(_9.x);
    _40.y = float(_9.y);
    _40.z = float(_9.z);
    _40.w = float(_9.w);
    float2 _71 = _40.zw * _40.xy;
    _40 = float4(_71.x, _71.y, _40.z, _40.w);
    _40.x = _40.y * _40.x;
    _80 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _90 = _80 + _18_m0;
    _90 *= _97;
    _100 = (_90.w * _40.x) + (-0.001000000047497451305389404296875f);
    _90.w = _40.x * _90.w;
    _115 = _90;
    _9.x = _100 < 0.0f;
    if ((int(_9.x) * (-1)) != 0)
    {
        discard;
    }
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _97 = stage_input._97;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._115 = _115;
    return stage_output;
}

#endif
#elif defined(UNITY_UI_ALPHACLIP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 _Color;
float4 _MainTex_ST;
float _PulseSpeed;
float _PulseMin;
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
#define _20_m0 _Time
#define _20_m3 _Color
#define _20_m4 _MainTex_ST
#define _20_m5 _PulseSpeed
#define _20_m6 _PulseMin



static float4 gl_Position;
static float4 _11;
static float4 _123;
static float4 _135;
static float2 vs_TEXCOORD0;
static float2 _141;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _123 : COLOR;
    float2 _141 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _135 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float _108;

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
    gl_Position = (_20_m2[3] * _9.wwww) + _48;
    _9.x = _20_m0.y * _20_m5;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x *= _9.x;
    _108 = (-_20_m6) + 1.0f;
    _9.x = (_9.x * _108) + _20_m6;
    _48 = _123 * _20_m3;
    _48.w = _9.x * _48.w;
    _135 = _48;
    vs_TEXCOORD0 = (_141 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD1 = _11;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _123 = stage_input._123;
    _141 = stage_input._141;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._135 = _135;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _TextureSampleAdd;
#define _24_m0 _TextureSampleAdd


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _38;
static float4 _49;

struct SPIRV_Cross_Input
{
    float4 _38 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _49 : SV_Target0;
};

static float4 _9;
static float4 _20;
static float _32;
static bool _53;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20 = _9 + _24_m0;
    _32 = (_20.w * _38.w) + (-0.001000000047497451305389404296875f);
    _20 *= _38;
    _49 = _20;
    _53 = _32 < 0.0f;
    if ((int(_53) * (-1)) != 0)
    {
        discard;
    }
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _38 = stage_input._38;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._49 = _49;
    return stage_output;
}

#endif
#elif defined(UNITY_UI_CLIP_RECT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 _Color;
float4 _MainTex_ST;
float _PulseSpeed;
float _PulseMin;
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
#define _20_m0 _Time
#define _20_m3 _Color
#define _20_m4 _MainTex_ST
#define _20_m5 _PulseSpeed
#define _20_m6 _PulseMin



static float4 gl_Position;
static float4 _11;
static float4 _123;
static float4 _135;
static float2 vs_TEXCOORD0;
static float2 _141;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _123 : COLOR;
    float2 _141 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _135 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float _108;

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
    gl_Position = (_20_m2[3] * _9.wwww) + _48;
    _9.x = _20_m0.y * _20_m5;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x *= _9.x;
    _108 = (-_20_m6) + 1.0f;
    _9.x = (_9.x * _108) + _20_m6;
    _48 = _123 * _20_m3;
    _48.w = _9.x * _48.w;
    _135 = _48;
    vs_TEXCOORD0 = (_141 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD1 = _11;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _123 = stage_input._123;
    _141 = stage_input._141;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._135 = _135;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _TextureSampleAdd;
float4 _ClipRect;
#define _18_m0 _TextureSampleAdd
#define _18_m1 _ClipRect


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _97;
static float4 _107;

struct SPIRV_Cross_Input
{
    float4 _97 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _107 : SV_Target0;
};

static bool4 _9;
static float4 _40;
static float4 _80;
static float4 _90;

void frag_inner()
{
    bool2 _27 = bool4(vs_TEXCOORD1.xyxx.x >= _18_m1.xyxx.x, vs_TEXCOORD1.xyxx.y >= _18_m1.xyxx.y, vs_TEXCOORD1.xyxx.z >= _18_m1.xyxx.z, vs_TEXCOORD1.xyxx.w >= _18_m1.xyxx.w).xy;
    _9 = bool4(_27.x, _27.y, _9.z, _9.w);
    bool2 _36 = bool4(_18_m1.zzzw.x >= vs_TEXCOORD1.xxxy.x, _18_m1.zzzw.y >= vs_TEXCOORD1.xxxy.y, _18_m1.zzzw.z >= vs_TEXCOORD1.xxxy.z, _18_m1.zzzw.w >= vs_TEXCOORD1.xxxy.w).zw;
    _9 = bool4(_9.x, _9.y, _36.x, _36.y);
    _40.x = float(_9.x);
    _40.y = float(_9.y);
    _40.z = float(_9.z);
    _40.w = float(_9.w);
    float2 _71 = _40.zw * _40.xy;
    _40 = float4(_71.x, _71.y, _40.z, _40.w);
    _40.x = _40.y * _40.x;
    _80 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _90 = _80 + _18_m0;
    _90 *= _97;
    _90.w = _40.x * _90.w;
    _107 = _90;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _97 = stage_input._97;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._107 = _107;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 _Color;
float4 _MainTex_ST;
float _PulseSpeed;
float _PulseMin;
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
#define _20_m0 _Time
#define _20_m3 _Color
#define _20_m4 _MainTex_ST
#define _20_m5 _PulseSpeed
#define _20_m6 _PulseMin



static float4 gl_Position;
static float4 _11;
static float4 _123;
static float4 _135;
static float2 vs_TEXCOORD0;
static float2 _141;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _123 : COLOR;
    float2 _141 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _135 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float _108;

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
    gl_Position = (_20_m2[3] * _9.wwww) + _48;
    _9.x = _20_m0.y * _20_m5;
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x *= _9.x;
    _108 = (-_20_m6) + 1.0f;
    _9.x = (_9.x * _108) + _20_m6;
    _48 = _123 * _20_m3;
    _48.w = _9.x * _48.w;
    _135 = _48;
    vs_TEXCOORD0 = (_141 * _20_m4.xy) + _20_m4.zw;
    vs_TEXCOORD1 = _11;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _123 = stage_input._123;
    _141 = stage_input._141;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._135 = _135;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _TextureSampleAdd;
#define _24_m0 _TextureSampleAdd


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _33;
static float4 _37;

struct SPIRV_Cross_Input
{
    float4 _33 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _37 : SV_Target0;
};

static float4 _9;
static float4 _20;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20 = _9 + _24_m0;
    _20 *= _33;
    _37 = _20;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _33 = stage_input._33;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._37 = _37;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}