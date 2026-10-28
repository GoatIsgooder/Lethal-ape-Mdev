// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Social/UI Curved" {
Properties {

_MainTex ("Sprite Texture", 2D) = "white" { }

_Color ("Tint", Color) = (1,1,1,1)

_CurveRadius ("Curve Radius (canvas units, 0 = flat)", Float) = 0.0

_FadeNear ("Fade Start (m)", Float) = 2.5

_FadeFar ("Fade End (m)", Float) = 4.0

_DrumRadius ("Drum Radius (canvas units, 0 = none)", Float) = 0.0

_DrumCentreY ("Drum Centre Y (canvas units)", Float) = 0.0

_DrumHalfHeight ("Drum Half Height (canvas units)", Float) = 1.0

_DrumFade ("Drum Edge Fade", Range(0, 1)) = 0.3499999940395355

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
   Blend One OneMinusSrcAlpha
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
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _17_m1[4];
float4x4 unity_MatrixVP;
static float4 _17_m2[4];
float _CurveRadius;
float _FadeNear;
float _FadeFar;
float _DrumRadius;
float _DrumCentreY;
float _DrumHalfHeight;
float _DrumFade;
float4 _Color;
float4 _MainTex_ST;
void __unity_init()
{
    _17_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _WorldSpaceCameraPos
#define _17_m3 _CurveRadius
#define _17_m4 _FadeNear
#define _17_m5 _FadeFar
#define _17_m6 _DrumRadius
#define _17_m7 _DrumCentreY
#define _17_m8 _DrumHalfHeight
#define _17_m9 _DrumFade
#define _17_m10 _Color
#define _17_m11 _MainTex_ST



static float4 gl_Position;
static float4 _58;
static float4 _386;
static float4 _398;
static float2 vs_TEXCOORD0;
static float2 _403;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _58 : POSITION;
    float4 _386 : COLOR;
    float2 _403 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _398 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _31;
static float2 _41;
static float _56;
static float4 _82;
static float4 _86;
static float3 _183;
static float _218;
static bool2 _252;
static float _294;

void vert_inner()
{
    __unity_init();
    _9.x = _17_m8 / _17_m6;
    _31.x = (-_17_m9) + 1.0f;
    _41.x = ((-_9.x) * _31.x) + _9.x;
    _41.x = 1.0f / _41.x;
    _56 = _58.y + (-_17_m7);
    _56 /= _17_m6;
    _9.x = ((-_9.x) * _31.x) + abs(_56);
    _82.x = sin(_56);
    _86.x = cos(_56);
    _9.x = _41.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_31.x) * _9.x) + 1.0f;
    _31 = _17_m0 + (-_17_m1[3].xyz);
    _31.x = dot(_31, _31);
    _31.x = sqrt(_31.x);
    _31.x += (-_17_m5);
    _41.x = (-_17_m5) + _17_m4;
    _41.x = 1.0f / _41.x;
    _31.x = _41.x * _31.x;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _41.x = (_31.x * (-2.0f)) + 3.0f;
    _31.x *= _31.x;
    _183.x = _31.x * _41.x;
    _9.x *= _183.x;
    _56 = _17_m8 * _17_m8;
    _56 = (_17_m6 * _17_m6) + (-_56);
    _56 = max(_56, 0.0f);
    _56 = sqrt(_56);
    _56 = (-_56) + _17_m6;
    _218 = (-_86.x) + 1.0f;
    _9.y = (_17_m6 * _82.x) + _17_m7;
    _56 = (_17_m6 * _218) + (-_56);
    _9.z = _56 + _58.z;
    _183 = float3(_183.x, _58.yz.x, _58.yz.y);
    float4 _262 = float4(_17_m6, _17_m3, _17_m6, _17_m6);
    _252 = bool4(0.0f.xxxx.x < _262.x, 0.0f.xxxx.y < _262.y, 0.0f.xxxx.z < _262.z, 0.0f.xxxx.w < _262.w).xy;
    float3 _270;
    if (_252.x)
    {
        _270 = _9.xyz;
    }
    else
    {
        _270 = _183;
    }
    _9 = float4(_270.x, _270.y, _270.z, _9.w);
    _82.x = _58.x / _17_m3;
    _86.x = cos(_82.x);
    _82.x = sin(_82.x);
    _294 = (-_86.x) + 1.0f;
    _86.x = _82.x * _17_m3;
    _86.y = ((-_17_m3) * _294) + _9.z;
    _9.w = _58.x;
    float2 _321;
    if (_252.y)
    {
        _321 = _86.xy;
    }
    else
    {
        _321 = _9.wz;
    }
    _41 = _321;
    _82 = _9.yyyy * _17_m1[1];
    _82 = (_17_m1[0] * _41.xxxx) + _82;
    _82 = (_17_m1[2] * _41.yyyy) + _82;
    _82 += _17_m1[3];
    _86 = _82.yyyy * _17_m2[1];
    _86 = (_17_m2[0] * _82.xxxx) + _86;
    _86 = (_17_m2[2] * _82.zzzz) + _86;
    gl_Position = (_17_m2[3] * _82.wwww) + _86;
    _82 = _386 * _17_m10;
    _82.w = _9.x * _82.w;
    _398 = _82;
    vs_TEXCOORD0 = (_403 * _17_m11.xy) + _17_m11.zw;
    vs_TEXCOORD1 = _58;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _58 = stage_input._58;
    _386 = stage_input._386;
    _403 = stage_input._403;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._398 = _398;
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
    _40.x *= _90.w;
    float3 _121 = _40.xxx * _90.xyz;
    _115 = float4(_121.x, _121.y, _121.z, _115.w);
    _115.w = _40.x;
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
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _17_m1[4];
float4x4 unity_MatrixVP;
static float4 _17_m2[4];
float _CurveRadius;
float _FadeNear;
float _FadeFar;
float _DrumRadius;
float _DrumCentreY;
float _DrumHalfHeight;
float _DrumFade;
float4 _Color;
float4 _MainTex_ST;
void __unity_init()
{
    _17_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _WorldSpaceCameraPos
#define _17_m3 _CurveRadius
#define _17_m4 _FadeNear
#define _17_m5 _FadeFar
#define _17_m6 _DrumRadius
#define _17_m7 _DrumCentreY
#define _17_m8 _DrumHalfHeight
#define _17_m9 _DrumFade
#define _17_m10 _Color
#define _17_m11 _MainTex_ST



static float4 gl_Position;
static float4 _58;
static float4 _386;
static float4 _398;
static float2 vs_TEXCOORD0;
static float2 _403;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _58 : POSITION;
    float4 _386 : COLOR;
    float2 _403 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _398 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _31;
static float2 _41;
static float _56;
static float4 _82;
static float4 _86;
static float3 _183;
static float _218;
static bool2 _252;
static float _294;

void vert_inner()
{
    __unity_init();
    _9.x = _17_m8 / _17_m6;
    _31.x = (-_17_m9) + 1.0f;
    _41.x = ((-_9.x) * _31.x) + _9.x;
    _41.x = 1.0f / _41.x;
    _56 = _58.y + (-_17_m7);
    _56 /= _17_m6;
    _9.x = ((-_9.x) * _31.x) + abs(_56);
    _82.x = sin(_56);
    _86.x = cos(_56);
    _9.x = _41.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_31.x) * _9.x) + 1.0f;
    _31 = _17_m0 + (-_17_m1[3].xyz);
    _31.x = dot(_31, _31);
    _31.x = sqrt(_31.x);
    _31.x += (-_17_m5);
    _41.x = (-_17_m5) + _17_m4;
    _41.x = 1.0f / _41.x;
    _31.x = _41.x * _31.x;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _41.x = (_31.x * (-2.0f)) + 3.0f;
    _31.x *= _31.x;
    _183.x = _31.x * _41.x;
    _9.x *= _183.x;
    _56 = _17_m8 * _17_m8;
    _56 = (_17_m6 * _17_m6) + (-_56);
    _56 = max(_56, 0.0f);
    _56 = sqrt(_56);
    _56 = (-_56) + _17_m6;
    _218 = (-_86.x) + 1.0f;
    _9.y = (_17_m6 * _82.x) + _17_m7;
    _56 = (_17_m6 * _218) + (-_56);
    _9.z = _56 + _58.z;
    _183 = float3(_183.x, _58.yz.x, _58.yz.y);
    float4 _262 = float4(_17_m6, _17_m3, _17_m6, _17_m6);
    _252 = bool4(0.0f.xxxx.x < _262.x, 0.0f.xxxx.y < _262.y, 0.0f.xxxx.z < _262.z, 0.0f.xxxx.w < _262.w).xy;
    float3 _270;
    if (_252.x)
    {
        _270 = _9.xyz;
    }
    else
    {
        _270 = _183;
    }
    _9 = float4(_270.x, _270.y, _270.z, _9.w);
    _82.x = _58.x / _17_m3;
    _86.x = cos(_82.x);
    _82.x = sin(_82.x);
    _294 = (-_86.x) + 1.0f;
    _86.x = _82.x * _17_m3;
    _86.y = ((-_17_m3) * _294) + _9.z;
    _9.w = _58.x;
    float2 _321;
    if (_252.y)
    {
        _321 = _86.xy;
    }
    else
    {
        _321 = _9.wz;
    }
    _41 = _321;
    _82 = _9.yyyy * _17_m1[1];
    _82 = (_17_m1[0] * _41.xxxx) + _82;
    _82 = (_17_m1[2] * _41.yyyy) + _82;
    _82 += _17_m1[3];
    _86 = _82.yyyy * _17_m2[1];
    _86 = (_17_m2[0] * _82.xxxx) + _86;
    _86 = (_17_m2[2] * _82.zzzz) + _86;
    gl_Position = (_17_m2[3] * _82.wwww) + _86;
    _82 = _386 * _17_m10;
    _82.w = _9.x * _82.w;
    _398 = _82;
    vs_TEXCOORD0 = (_403 * _17_m11.xy) + _17_m11.zw;
    vs_TEXCOORD1 = _58;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _58 = stage_input._58;
    _386 = stage_input._386;
    _403 = stage_input._403;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._398 = _398;
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
static float4 _64;

struct SPIRV_Cross_Input
{
    float4 _38 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _64 : SV_Target0;
};

static float4 _9;
static float4 _20;
static float _32;
static bool _50;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20 = _9 + _24_m0;
    _32 = (_20.w * _38.w) + (-0.001000000047497451305389404296875f);
    _20 *= _38;
    _50 = _32 < 0.0f;
    if ((int(_50) * (-1)) != 0)
    {
        discard;
    }
    float3 _70 = _20.www * _20.xyz;
    _64 = float4(_70.x, _70.y, _70.z, _64.w);
    _64.w = _20.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _38 = stage_input._38;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._64 = _64;
    return stage_output;
}

#endif
#elif defined(UNITY_UI_CLIP_RECT)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _17_m1[4];
float4x4 unity_MatrixVP;
static float4 _17_m2[4];
float _CurveRadius;
float _FadeNear;
float _FadeFar;
float _DrumRadius;
float _DrumCentreY;
float _DrumHalfHeight;
float _DrumFade;
float4 _Color;
float4 _MainTex_ST;
void __unity_init()
{
    _17_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _WorldSpaceCameraPos
#define _17_m3 _CurveRadius
#define _17_m4 _FadeNear
#define _17_m5 _FadeFar
#define _17_m6 _DrumRadius
#define _17_m7 _DrumCentreY
#define _17_m8 _DrumHalfHeight
#define _17_m9 _DrumFade
#define _17_m10 _Color
#define _17_m11 _MainTex_ST



static float4 gl_Position;
static float4 _58;
static float4 _386;
static float4 _398;
static float2 vs_TEXCOORD0;
static float2 _403;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _58 : POSITION;
    float4 _386 : COLOR;
    float2 _403 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _398 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _31;
static float2 _41;
static float _56;
static float4 _82;
static float4 _86;
static float3 _183;
static float _218;
static bool2 _252;
static float _294;

void vert_inner()
{
    __unity_init();
    _9.x = _17_m8 / _17_m6;
    _31.x = (-_17_m9) + 1.0f;
    _41.x = ((-_9.x) * _31.x) + _9.x;
    _41.x = 1.0f / _41.x;
    _56 = _58.y + (-_17_m7);
    _56 /= _17_m6;
    _9.x = ((-_9.x) * _31.x) + abs(_56);
    _82.x = sin(_56);
    _86.x = cos(_56);
    _9.x = _41.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_31.x) * _9.x) + 1.0f;
    _31 = _17_m0 + (-_17_m1[3].xyz);
    _31.x = dot(_31, _31);
    _31.x = sqrt(_31.x);
    _31.x += (-_17_m5);
    _41.x = (-_17_m5) + _17_m4;
    _41.x = 1.0f / _41.x;
    _31.x = _41.x * _31.x;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _41.x = (_31.x * (-2.0f)) + 3.0f;
    _31.x *= _31.x;
    _183.x = _31.x * _41.x;
    _9.x *= _183.x;
    _56 = _17_m8 * _17_m8;
    _56 = (_17_m6 * _17_m6) + (-_56);
    _56 = max(_56, 0.0f);
    _56 = sqrt(_56);
    _56 = (-_56) + _17_m6;
    _218 = (-_86.x) + 1.0f;
    _9.y = (_17_m6 * _82.x) + _17_m7;
    _56 = (_17_m6 * _218) + (-_56);
    _9.z = _56 + _58.z;
    _183 = float3(_183.x, _58.yz.x, _58.yz.y);
    float4 _262 = float4(_17_m6, _17_m3, _17_m6, _17_m6);
    _252 = bool4(0.0f.xxxx.x < _262.x, 0.0f.xxxx.y < _262.y, 0.0f.xxxx.z < _262.z, 0.0f.xxxx.w < _262.w).xy;
    float3 _270;
    if (_252.x)
    {
        _270 = _9.xyz;
    }
    else
    {
        _270 = _183;
    }
    _9 = float4(_270.x, _270.y, _270.z, _9.w);
    _82.x = _58.x / _17_m3;
    _86.x = cos(_82.x);
    _82.x = sin(_82.x);
    _294 = (-_86.x) + 1.0f;
    _86.x = _82.x * _17_m3;
    _86.y = ((-_17_m3) * _294) + _9.z;
    _9.w = _58.x;
    float2 _321;
    if (_252.y)
    {
        _321 = _86.xy;
    }
    else
    {
        _321 = _9.wz;
    }
    _41 = _321;
    _82 = _9.yyyy * _17_m1[1];
    _82 = (_17_m1[0] * _41.xxxx) + _82;
    _82 = (_17_m1[2] * _41.yyyy) + _82;
    _82 += _17_m1[3];
    _86 = _82.yyyy * _17_m2[1];
    _86 = (_17_m2[0] * _82.xxxx) + _86;
    _86 = (_17_m2[2] * _82.zzzz) + _86;
    gl_Position = (_17_m2[3] * _82.wwww) + _86;
    _82 = _386 * _17_m10;
    _82.w = _9.x * _82.w;
    _398 = _82;
    vs_TEXCOORD0 = (_403 * _17_m11.xy) + _17_m11.zw;
    vs_TEXCOORD1 = _58;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _58 = stage_input._58;
    _386 = stage_input._386;
    _403 = stage_input._403;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._398 = _398;
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
    _40.x *= _90.w;
    float3 _113 = _40.xxx * _90.xyz;
    _107 = float4(_113.x, _113.y, _113.z, _107.w);
    _107.w = _40.x;
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
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _17_m1[4];
float4x4 unity_MatrixVP;
static float4 _17_m2[4];
float _CurveRadius;
float _FadeNear;
float _FadeFar;
float _DrumRadius;
float _DrumCentreY;
float _DrumHalfHeight;
float _DrumFade;
float4 _Color;
float4 _MainTex_ST;
void __unity_init()
{
    _17_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _WorldSpaceCameraPos
#define _17_m3 _CurveRadius
#define _17_m4 _FadeNear
#define _17_m5 _FadeFar
#define _17_m6 _DrumRadius
#define _17_m7 _DrumCentreY
#define _17_m8 _DrumHalfHeight
#define _17_m9 _DrumFade
#define _17_m10 _Color
#define _17_m11 _MainTex_ST



static float4 gl_Position;
static float4 _58;
static float4 _386;
static float4 _398;
static float2 vs_TEXCOORD0;
static float2 _403;
static float4 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _58 : POSITION;
    float4 _386 : COLOR;
    float2 _403 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _398 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float3 _31;
static float2 _41;
static float _56;
static float4 _82;
static float4 _86;
static float3 _183;
static float _218;
static bool2 _252;
static float _294;

void vert_inner()
{
    __unity_init();
    _9.x = _17_m8 / _17_m6;
    _31.x = (-_17_m9) + 1.0f;
    _41.x = ((-_9.x) * _31.x) + _9.x;
    _41.x = 1.0f / _41.x;
    _56 = _58.y + (-_17_m7);
    _56 /= _17_m6;
    _9.x = ((-_9.x) * _31.x) + abs(_56);
    _82.x = sin(_56);
    _86.x = cos(_56);
    _9.x = _41.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = ((-_31.x) * _9.x) + 1.0f;
    _31 = _17_m0 + (-_17_m1[3].xyz);
    _31.x = dot(_31, _31);
    _31.x = sqrt(_31.x);
    _31.x += (-_17_m5);
    _41.x = (-_17_m5) + _17_m4;
    _41.x = 1.0f / _41.x;
    _31.x = _41.x * _31.x;
    _31.x = clamp(_31.x, 0.0f, 1.0f);
    _41.x = (_31.x * (-2.0f)) + 3.0f;
    _31.x *= _31.x;
    _183.x = _31.x * _41.x;
    _9.x *= _183.x;
    _56 = _17_m8 * _17_m8;
    _56 = (_17_m6 * _17_m6) + (-_56);
    _56 = max(_56, 0.0f);
    _56 = sqrt(_56);
    _56 = (-_56) + _17_m6;
    _218 = (-_86.x) + 1.0f;
    _9.y = (_17_m6 * _82.x) + _17_m7;
    _56 = (_17_m6 * _218) + (-_56);
    _9.z = _56 + _58.z;
    _183 = float3(_183.x, _58.yz.x, _58.yz.y);
    float4 _262 = float4(_17_m6, _17_m3, _17_m6, _17_m6);
    _252 = bool4(0.0f.xxxx.x < _262.x, 0.0f.xxxx.y < _262.y, 0.0f.xxxx.z < _262.z, 0.0f.xxxx.w < _262.w).xy;
    float3 _270;
    if (_252.x)
    {
        _270 = _9.xyz;
    }
    else
    {
        _270 = _183;
    }
    _9 = float4(_270.x, _270.y, _270.z, _9.w);
    _82.x = _58.x / _17_m3;
    _86.x = cos(_82.x);
    _82.x = sin(_82.x);
    _294 = (-_86.x) + 1.0f;
    _86.x = _82.x * _17_m3;
    _86.y = ((-_17_m3) * _294) + _9.z;
    _9.w = _58.x;
    float2 _321;
    if (_252.y)
    {
        _321 = _86.xy;
    }
    else
    {
        _321 = _9.wz;
    }
    _41 = _321;
    _82 = _9.yyyy * _17_m1[1];
    _82 = (_17_m1[0] * _41.xxxx) + _82;
    _82 = (_17_m1[2] * _41.yyyy) + _82;
    _82 += _17_m1[3];
    _86 = _82.yyyy * _17_m2[1];
    _86 = (_17_m2[0] * _82.xxxx) + _86;
    _86 = (_17_m2[2] * _82.zzzz) + _86;
    gl_Position = (_17_m2[3] * _82.wwww) + _86;
    _82 = _386 * _17_m10;
    _82.w = _9.x * _82.w;
    _398 = _82;
    vs_TEXCOORD0 = (_403 * _17_m11.xy) + _17_m11.zw;
    vs_TEXCOORD1 = _58;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _58 = stage_input._58;
    _386 = stage_input._386;
    _403 = stage_input._403;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._398 = _398;
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
    float3 _43 = _20.www * _20.xyz;
    _37 = float4(_43.x, _43.y, _43.z, _37.w);
    _37.w = _20.w;
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