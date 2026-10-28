// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Social/TMP Curved" {
Properties {

_FaceColor ("Face Color", Color) = (1,1,1,1)

_FaceDilate ("Face Dilate", Range(-1, 1)) = 0.0

_OutlineColor ("Outline Color", Color) = (0,0,0,1)

_OutlineWidth ("Outline Thickness", Range(0, 1)) = 0.0

_OutlineSoftness ("Outline Softness", Range(0, 1)) = 0.0

_UnderlayColor ("Border Color", Color) = (0,0,0,0.5)

_UnderlayOffsetX ("Border OffsetX", Range(-1, 1)) = 0.0

_UnderlayOffsetY ("Border OffsetY", Range(-1, 1)) = 0.0

_UnderlayDilate ("Border Dilate", Range(-1, 1)) = 0.0

_UnderlaySoftness ("Border Softness", Range(0, 1)) = 0.0

_WeightNormal ("Weight Normal", Float) = 0.0

_WeightBold ("Weight Bold", Float) = 0.5

_ShaderFlags ("Flags", Float) = 0.0

_ScaleRatioA ("Scale RatioA", Float) = 1.0

_ScaleRatioB ("Scale RatioB", Float) = 1.0

_ScaleRatioC ("Scale RatioC", Float) = 1.0

_MainTex ("Font Atlas", 2D) = "white" { }

_TextureWidth ("Texture Width", Float) = 512.0

_TextureHeight ("Texture Height", Float) = 512.0

_GradientScale ("Gradient Scale", Float) = 5.0

_ScaleX ("Scale X", Float) = 1.0

_ScaleY ("Scale Y", Float) = 1.0

_PerspectiveFilter ("Perspective Correction", Range(0, 1)) = 0.875

_Sharpness ("Sharpness", Range(-1, 1)) = 0.0

_VertexOffsetX ("Vertex OffsetX", Float) = 0.0

_VertexOffsetY ("Vertex OffsetY", Float) = 0.0

_ClipRect ("Clip Rect", Vector) = (-32767,-32767,32767,32767)

_MaskSoftnessX ("Mask SoftnessX", Float) = 0.0

_MaskSoftnessY ("Mask SoftnessY", Float) = 0.0

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

_CullMode ("Cull Mode", Float) = 0.0

_ColorMask ("Color Mask", Float) = 15.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
Stencil {
 Ref [_Stencil]
 ReadMask [_StencilReadMask]
 WriteMask [_StencilWriteMask]
 Comp [_StencilComp]
 Pass [_StencilOp]
}
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZTest [unity_GUIZTestMode]
 ZWrite Off
 Cull [_CullMode]
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
float4 _ScreenParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m2[4];
float4x4 unity_WorldToObject;
static float4 _20_m3[4];
float4x4 glstate_matrix_projection;
static float4 _20_m4[4];
float4x4 unity_MatrixVP;
static float4 _20_m5[4];
float4 _FaceColor;
float _FaceDilate;
float _OutlineSoftness;
float4 _OutlineColor;
float _OutlineWidth;
float _WeightNormal;
float _WeightBold;
float _ScaleRatioA;
float _VertexOffsetX;
float _VertexOffsetY;
float4 _ClipRect;
float _MaskSoftnessX;
float _MaskSoftnessY;
float _GradientScale;
float _ScaleX;
float _ScaleY;
float _PerspectiveFilter;
float _Sharpness;
float _CurveRadius;
float _FadeNear;
float _FadeFar;
float _DrumRadius;
float _DrumCentreY;
float _DrumHalfHeight;
float _DrumFade;
float _UIMaskSoftnessX;
float _UIMaskSoftnessY;
float _UIVertexColorAlwaysGammaSpace;
void __unity_init()
{
    _20_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _20_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _20_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _20_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _20_m4[0] = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]);
    _20_m4[1] = float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
    _20_m4[2] = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]);
    _20_m4[3] = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]);
    _20_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _ScreenParams
#define _20_m6 _FaceColor
#define _20_m7 _FaceDilate
#define _20_m8 _OutlineSoftness
#define _20_m9 _OutlineColor
#define _20_m10 _OutlineWidth
#define _20_m11 _WeightNormal
#define _20_m12 _WeightBold
#define _20_m13 _ScaleRatioA
#define _20_m14 _VertexOffsetX
#define _20_m15 _VertexOffsetY
#define _20_m16 _ClipRect
#define _20_m17 _MaskSoftnessX
#define _20_m18 _MaskSoftnessY
#define _20_m19 _GradientScale
#define _20_m20 _ScaleX
#define _20_m21 _ScaleY
#define _20_m22 _PerspectiveFilter
#define _20_m23 _Sharpness
#define _20_m24 _CurveRadius
#define _20_m25 _FadeNear
#define _20_m26 _FadeFar
#define _20_m27 _DrumRadius
#define _20_m28 _DrumCentreY
#define _20_m29 _DrumHalfHeight
#define _20_m30 _DrumFade
#define _20_m31 _UIMaskSoftnessX
#define _20_m32 _UIMaskSoftnessY
#define _20_m33 _UIVertexColorAlwaysGammaSpace



static float4 gl_Position;
static float4 _132;
static float4 _349;
static float4 _534;
static float3 _549;
static float4 _639;
static float4 _769;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _132 : POSITION;
    float3 _549 : NORMAL;
    float4 _349 : COLOR;
    float4 _639 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _534 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 _769 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _58;
static float4 _102;
static float3 _112;
static float _119;
static float _145;
static float4 _168;
static float4 _172;
static bool _212;
static float _221;
static float _244;
static float _301;
static bool _321;
static float3 _420;
static float3 _443;
static bool3 _454;
static float4 _521;
static bool _684;
static float4 _740;
static bool _822;
static float _829;

void vert_inner()
{
    __unity_init();
    float3 _32 = _20_m0 + (-_20_m2[3].xyz);
    _9 = float4(_32.x, _32.y, _32.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x += (-_20_m26);
    _58.x = (-_20_m26) + _20_m25;
    _58.x = 1.0f / _58.x;
    _9.x = _58.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _58.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _58.x;
    _102.x = _20_m29 / _20_m27;
    _112.x = (-_20_m30) + 1.0f;
    _119 = ((-_102.x) * _112.x) + _102.x;
    _119 = 1.0f / _119;
    float2 _142 = _132.xy + float2(_20_m14, _20_m15);
    _9 = float4(_9.x, _142.x, _142.y, _9.w);
    _145 = _9.z + (-_20_m28);
    _145 /= _20_m27;
    _102.x = ((-_102.x) * _112.x) + abs(_145);
    _168.x = sin(_145);
    _172.x = cos(_145);
    _102.x = _119 * _102.x;
    _102.x = clamp(_102.x, 0.0f, 1.0f);
    _112.x = (_102.x * (-2.0f)) + 3.0f;
    _102.x *= _102.x;
    _102.x = ((-_112.x) * _102.x) + 1.0f;
    _102.x = _9.x * _102.x;
    _212 = 0.0f < _20_m27;
    _9.w = _132.z;
    _221 = _20_m29 * _20_m29;
    _221 = (_20_m27 * _20_m27) + (-_221);
    _221 = max(_221, 0.0f);
    _221 = sqrt(_221);
    _221 = (-_221) + _20_m27;
    _244 = (-_172.x) + 1.0f;
    _102.y = (_20_m27 * _168.x) + _20_m28;
    _168.x = (_20_m27 * _244) + (-_221);
    _102.z = _168.x + _132.z;
    float3 _275;
    if (_212)
    {
        _275 = _102.xyz;
    }
    else
    {
        _275 = _9.xzw;
    }
    _102 = float4(_275.x, _275.y, _275.z, _102.w);
    _9.x = _9.y / _20_m24;
    _168.x = cos(_9.x);
    _9.x = sin(_9.x);
    _301 = (-_168.x) + 1.0f;
    _168.x = _9.x * _20_m24;
    _168.y = ((-_20_m24) * _301) + _102.z;
    _321 = 0.0f < _20_m24;
    _102.w = _9.y;
    float2 _330;
    if (_321)
    {
        _330 = _168.xy;
    }
    else
    {
        _330 = _102.wz;
    }
    _9 = float4(_330.x, _9.y, _9.z, _330.y);
    _168 = _102.yyyy * _20_m2[1];
    _102.x *= _349.w;
    _168 = (_20_m2[0] * _9.xxxx) + _168;
    _168 = (_20_m2[2] * _9.wwww) + _168;
    _172 = _168 + _20_m2[3];
    _112 = (_20_m2[3].xyz * _132.www) + _168.xyz;
    _112 = (-_112) + _20_m0;
    _168 = _172.yyyy * _20_m5[1];
    _168 = (_20_m5[0] * _172.xxxx) + _168;
    _168 = (_20_m5[2] * _172.zzzz) + _168;
    _168 = (_20_m5[3] * _172.wwww) + _168;
    gl_Position = _168;
    _420 = (_349.xyz * 0.26588499546051025390625f.xxx) + 0.736584007740020751953125f.xxx;
    _420 = (_349.xyz * _420) + (-0.00980184040963649749755859375f).xxx;
    _420 = (_349.xyz * _420) + 0.0031969700939953327178955078125f.xxx;
    _443 = (_349.xyz * 0.084971003234386444091796875f.xxx) + (-0.0001630290062166750431060791015625f).xxx;
    _454 = bool4(_349.xyzx.x < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).x, _349.xyzx.y < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).y, _349.xyzx.z < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).z, _349.xyzx.w < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).w).xyz;
    float3 _462 = _420;
    float _467;
    if (_454.x)
    {
        _467 = _443.x;
    }
    else
    {
        _467 = _420.x;
    }
    _462.x = _467;
    float _479;
    if (_454.y)
    {
        _479 = _443.y;
    }
    else
    {
        _479 = _420.y;
    }
    _462.y = _479;
    float _491;
    if (_454.z)
    {
        _491 = _443.z;
    }
    else
    {
        _491 = _420.z;
    }
    _462.z = _491;
    _420 = _462;
    float3 _507;
    if (_20_m33 != 0)
    {
        _507 = _420;
    }
    else
    {
        _507 = _349.xyz;
    }
    _420 = _507;
    _420 *= _20_m6.xyz;
    _521.w = _102.x * _20_m6.w;
    float3 _531 = _521.www * _420;
    _521 = float4(_531.x, _531.y, _531.z, _521.w);
    _534 = _521;
    _9.x = dot(_112, _112);
    _9.x = rsqrt(_9.x);
    _112 = _9.xxx * _112;
    _168.x = dot(_549, _20_m3[0].xyz);
    _168.y = dot(_549, _20_m3[1].xyz);
    _168.z = dot(_549, _20_m3[2].xyz);
    _9.x = dot(_168.xyz, _168.xyz);
    _9.x = rsqrt(_9.x);
    float3 _582 = _9.xxx * _168.xyz;
    _168 = float4(_582.x, _582.y, _582.z, _168.w);
    _9.x = dot(_168.xyz, _112);
    float2 _597 = _20_m1.yy * _20_m4[1].xy;
    _112 = float3(_597.x, _597.y, _112.z);
    float2 _609 = (_20_m4[0].xy * _20_m1.xx) + _112.xy;
    _112 = float3(_609.x, _609.y, _112.z);
    float2 _622 = abs(_112.xy) * float2(_20_m20, _20_m21);
    _112 = float3(_622.x, _622.y, _112.z);
    float2 _629 = _168.ww / _112.xy;
    _112 = float3(_629.x, _629.y, _112.z);
    _301 = dot(_112.xy, _112.xy);
    _301 = rsqrt(_301);
    _145 = abs(_639.w) * _20_m19;
    _168.x = _20_m23 + 1.0f;
    _145 *= _168.x;
    _168.x = _301 * _145;
    _221 = (-_20_m22) + 1.0f;
    _221 *= abs(_168.x);
    _301 = (_301 * _145) + (-_221);
    _9.x = (abs(_9.x) * _301) + _221;
    _684 = _20_m4[3].w == 0.0f;
    float _689;
    if (_684)
    {
        _689 = _9.x;
    }
    else
    {
        _689 = _168.x;
    }
    _9.x = _689;
    _301 = _20_m8 * _20_m13;
    _301 = (_301 * _9.x) + 1.0f;
    _168.x = _9.x / _301;
    _9.x = _20_m10 * _20_m13;
    _9.x = _168.x * _9.x;
    _301 = min(_9.x, 1.0f);
    _301 = sqrt(_301);
    _145 = _102.x * _20_m9.w;
    _740.w = (_20_m9.w * _102.x) + (-_521.w);
    float3 _760 = (_20_m9.xyz * _145.xxx) + (-_521.xyz);
    _740 = float4(_760.x, _760.y, _760.z, _740.w);
    _172 = (_301.xxxx * _740) + _521;
    _769 = _172;
    _172 = max(_20_m16, (-20000000000.0f).xxxx);
    _172 = min(_172, 20000000000.0f.xxxx);
    float2 _786 = _9.yz + (-_172.xy);
    _102 = float4(_786.x, _102.y, _102.z, _786.y);
    _58 = (_9.yz * 2.0f.xx) + (-_172.xy);
    float2 _802 = (-_172.zw) + _58;
    _740 = float4(_802.x, _802.y, _740.z, _740.w);
    _58 = (-_172.xy) + _172.zw;
    float2 _815 = _102.xw / _58;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _815.x, _815.y);
    vs_TEXCOORD0 = float4(_639.xy.x, _639.xy.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _822 = 0.0f >= _639.w;
    _58.x = float(_822);
    _829 = (-_20_m11) + _20_m12;
    _58.x = (_58.x * _829) + _20_m11;
    _58.x = (_58.x * 0.25f) + _20_m7;
    _58.x *= _20_m13;
    _58.x = ((-_58.x) * 0.5f) + 0.5f;
    _168.w = (_58.x * _168.x) + (-0.5f);
    _168.y = ((-_9.x) * 0.5f) + _168.w;
    _168.z = (_9.x * 0.5f) + _168.w;
    vs_TEXCOORD1 = _168;
    float2 _907 = max(float2(_20_m17, _20_m18), float2(_20_m31, _20_m32));
    _9 = float4(_907.x, _907.y, _9.z, _9.w);
    float2 _916 = (_9.xy * 0.25f.xx) + _112.xy;
    _9 = float4(_916.x, _916.y, _9.z, _9.w);
    float2 _921 = 0.25f.xx / _9.xy;
    _740 = float4(_740.x, _740.y, _921.x, _921.y);
    vs_TEXCOORD2 = _740;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _132 = stage_input._132;
    _349 = stage_input._349;
    _549 = stage_input._549;
    _639 = stage_input._639;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._534 = _534;
    stage_output._769 = _769;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _ClipRect;
#define _13_m0 _ClipRect


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 _83;
static float4 _97;

struct SPIRV_Cross_Input
{
    float4 _83 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _97 : SV_Target0;
};

static float2 _9;
static float _44;
static float4 _54;
static float _67;
static bool _101;

void frag_inner()
{
    _9 = (-_13_m0.xy) + _13_m0.zw;
    _9 += (-abs(vs_TEXCOORD2.xy));
    _9 *= vs_TEXCOORD2.zw;
    _9 = clamp(_9, 0.0f.xx, 1.0f.xx);
    _44 = _9.y * _9.x;
    _54.x = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).w;
    _67 = (_54.x * vs_TEXCOORD1.x) + (-vs_TEXCOORD1.w);
    _67 = clamp(_67, 0.0f, 1.0f);
    _54 = _67.xxxx * _83;
    _67 = (_54.w * _44) + (-0.001000000047497451305389404296875f);
    _54 = _44.xxxx * _54;
    _97 = _54;
    _101 = _67 < 0.0f;
    if ((int(_101) * (-1)) != 0)
    {
        discard;
    }
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _83 = stage_input._83;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._97 = _97;
    return stage_output;
}

#endif
#elif defined(UNITY_UI_ALPHACLIP)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ScreenParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m2[4];
float4x4 unity_WorldToObject;
static float4 _20_m3[4];
float4x4 glstate_matrix_projection;
static float4 _20_m4[4];
float4x4 unity_MatrixVP;
static float4 _20_m5[4];
float4 _FaceColor;
float _FaceDilate;
float _OutlineSoftness;
float4 _OutlineColor;
float _OutlineWidth;
float _WeightNormal;
float _WeightBold;
float _ScaleRatioA;
float _VertexOffsetX;
float _VertexOffsetY;
float4 _ClipRect;
float _MaskSoftnessX;
float _MaskSoftnessY;
float _GradientScale;
float _ScaleX;
float _ScaleY;
float _PerspectiveFilter;
float _Sharpness;
float _CurveRadius;
float _FadeNear;
float _FadeFar;
float _DrumRadius;
float _DrumCentreY;
float _DrumHalfHeight;
float _DrumFade;
float _UIMaskSoftnessX;
float _UIMaskSoftnessY;
float _UIVertexColorAlwaysGammaSpace;
void __unity_init()
{
    _20_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _20_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _20_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _20_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _20_m4[0] = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]);
    _20_m4[1] = float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
    _20_m4[2] = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]);
    _20_m4[3] = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]);
    _20_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _ScreenParams
#define _20_m6 _FaceColor
#define _20_m7 _FaceDilate
#define _20_m8 _OutlineSoftness
#define _20_m9 _OutlineColor
#define _20_m10 _OutlineWidth
#define _20_m11 _WeightNormal
#define _20_m12 _WeightBold
#define _20_m13 _ScaleRatioA
#define _20_m14 _VertexOffsetX
#define _20_m15 _VertexOffsetY
#define _20_m16 _ClipRect
#define _20_m17 _MaskSoftnessX
#define _20_m18 _MaskSoftnessY
#define _20_m19 _GradientScale
#define _20_m20 _ScaleX
#define _20_m21 _ScaleY
#define _20_m22 _PerspectiveFilter
#define _20_m23 _Sharpness
#define _20_m24 _CurveRadius
#define _20_m25 _FadeNear
#define _20_m26 _FadeFar
#define _20_m27 _DrumRadius
#define _20_m28 _DrumCentreY
#define _20_m29 _DrumHalfHeight
#define _20_m30 _DrumFade
#define _20_m31 _UIMaskSoftnessX
#define _20_m32 _UIMaskSoftnessY
#define _20_m33 _UIVertexColorAlwaysGammaSpace



static float4 gl_Position;
static float4 _132;
static float4 _349;
static float4 _534;
static float3 _549;
static float4 _639;
static float4 _769;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _132 : POSITION;
    float3 _549 : NORMAL;
    float4 _349 : COLOR;
    float4 _639 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _534 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 _769 : TEXCOORD3;
    float4 vs_TEXCOORD2 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _58;
static float4 _102;
static float3 _112;
static float _119;
static float _145;
static float4 _168;
static float4 _172;
static bool _212;
static float _221;
static float _244;
static float _301;
static bool _321;
static float3 _420;
static float3 _443;
static bool3 _454;
static float4 _521;
static bool _684;
static float4 _740;
static bool _822;
static float _829;

void vert_inner()
{
    __unity_init();
    float3 _32 = _20_m0 + (-_20_m2[3].xyz);
    _9 = float4(_32.x, _32.y, _32.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x += (-_20_m26);
    _58.x = (-_20_m26) + _20_m25;
    _58.x = 1.0f / _58.x;
    _9.x = _58.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _58.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _58.x;
    _102.x = _20_m29 / _20_m27;
    _112.x = (-_20_m30) + 1.0f;
    _119 = ((-_102.x) * _112.x) + _102.x;
    _119 = 1.0f / _119;
    float2 _142 = _132.xy + float2(_20_m14, _20_m15);
    _9 = float4(_9.x, _142.x, _142.y, _9.w);
    _145 = _9.z + (-_20_m28);
    _145 /= _20_m27;
    _102.x = ((-_102.x) * _112.x) + abs(_145);
    _168.x = sin(_145);
    _172.x = cos(_145);
    _102.x = _119 * _102.x;
    _102.x = clamp(_102.x, 0.0f, 1.0f);
    _112.x = (_102.x * (-2.0f)) + 3.0f;
    _102.x *= _102.x;
    _102.x = ((-_112.x) * _102.x) + 1.0f;
    _102.x = _9.x * _102.x;
    _212 = 0.0f < _20_m27;
    _9.w = _132.z;
    _221 = _20_m29 * _20_m29;
    _221 = (_20_m27 * _20_m27) + (-_221);
    _221 = max(_221, 0.0f);
    _221 = sqrt(_221);
    _221 = (-_221) + _20_m27;
    _244 = (-_172.x) + 1.0f;
    _102.y = (_20_m27 * _168.x) + _20_m28;
    _168.x = (_20_m27 * _244) + (-_221);
    _102.z = _168.x + _132.z;
    float3 _275;
    if (_212)
    {
        _275 = _102.xyz;
    }
    else
    {
        _275 = _9.xzw;
    }
    _102 = float4(_275.x, _275.y, _275.z, _102.w);
    _9.x = _9.y / _20_m24;
    _168.x = cos(_9.x);
    _9.x = sin(_9.x);
    _301 = (-_168.x) + 1.0f;
    _168.x = _9.x * _20_m24;
    _168.y = ((-_20_m24) * _301) + _102.z;
    _321 = 0.0f < _20_m24;
    _102.w = _9.y;
    float2 _330;
    if (_321)
    {
        _330 = _168.xy;
    }
    else
    {
        _330 = _102.wz;
    }
    _9 = float4(_330.x, _9.y, _9.z, _330.y);
    _168 = _102.yyyy * _20_m2[1];
    _102.x *= _349.w;
    _168 = (_20_m2[0] * _9.xxxx) + _168;
    _168 = (_20_m2[2] * _9.wwww) + _168;
    _172 = _168 + _20_m2[3];
    _112 = (_20_m2[3].xyz * _132.www) + _168.xyz;
    _112 = (-_112) + _20_m0;
    _168 = _172.yyyy * _20_m5[1];
    _168 = (_20_m5[0] * _172.xxxx) + _168;
    _168 = (_20_m5[2] * _172.zzzz) + _168;
    _168 = (_20_m5[3] * _172.wwww) + _168;
    gl_Position = _168;
    _420 = (_349.xyz * 0.26588499546051025390625f.xxx) + 0.736584007740020751953125f.xxx;
    _420 = (_349.xyz * _420) + (-0.00980184040963649749755859375f).xxx;
    _420 = (_349.xyz * _420) + 0.0031969700939953327178955078125f.xxx;
    _443 = (_349.xyz * 0.084971003234386444091796875f.xxx) + (-0.0001630290062166750431060791015625f).xxx;
    _454 = bool4(_349.xyzx.x < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).x, _349.xyzx.y < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).y, _349.xyzx.z < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).z, _349.xyzx.w < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).w).xyz;
    float3 _462 = _420;
    float _467;
    if (_454.x)
    {
        _467 = _443.x;
    }
    else
    {
        _467 = _420.x;
    }
    _462.x = _467;
    float _479;
    if (_454.y)
    {
        _479 = _443.y;
    }
    else
    {
        _479 = _420.y;
    }
    _462.y = _479;
    float _491;
    if (_454.z)
    {
        _491 = _443.z;
    }
    else
    {
        _491 = _420.z;
    }
    _462.z = _491;
    _420 = _462;
    float3 _507;
    if (_20_m33 != 0)
    {
        _507 = _420;
    }
    else
    {
        _507 = _349.xyz;
    }
    _420 = _507;
    _420 *= _20_m6.xyz;
    _521.w = _102.x * _20_m6.w;
    float3 _531 = _521.www * _420;
    _521 = float4(_531.x, _531.y, _531.z, _521.w);
    _534 = _521;
    _9.x = dot(_112, _112);
    _9.x = rsqrt(_9.x);
    _112 = _9.xxx * _112;
    _168.x = dot(_549, _20_m3[0].xyz);
    _168.y = dot(_549, _20_m3[1].xyz);
    _168.z = dot(_549, _20_m3[2].xyz);
    _9.x = dot(_168.xyz, _168.xyz);
    _9.x = rsqrt(_9.x);
    float3 _582 = _9.xxx * _168.xyz;
    _168 = float4(_582.x, _582.y, _582.z, _168.w);
    _9.x = dot(_168.xyz, _112);
    float2 _597 = _20_m1.yy * _20_m4[1].xy;
    _112 = float3(_597.x, _597.y, _112.z);
    float2 _609 = (_20_m4[0].xy * _20_m1.xx) + _112.xy;
    _112 = float3(_609.x, _609.y, _112.z);
    float2 _622 = abs(_112.xy) * float2(_20_m20, _20_m21);
    _112 = float3(_622.x, _622.y, _112.z);
    float2 _629 = _168.ww / _112.xy;
    _112 = float3(_629.x, _629.y, _112.z);
    _301 = dot(_112.xy, _112.xy);
    _301 = rsqrt(_301);
    _145 = abs(_639.w) * _20_m19;
    _168.x = _20_m23 + 1.0f;
    _145 *= _168.x;
    _168.x = _301 * _145;
    _221 = (-_20_m22) + 1.0f;
    _221 *= abs(_168.x);
    _301 = (_301 * _145) + (-_221);
    _9.x = (abs(_9.x) * _301) + _221;
    _684 = _20_m4[3].w == 0.0f;
    float _689;
    if (_684)
    {
        _689 = _9.x;
    }
    else
    {
        _689 = _168.x;
    }
    _9.x = _689;
    _301 = _20_m8 * _20_m13;
    _301 = (_301 * _9.x) + 1.0f;
    _168.x = _9.x / _301;
    _9.x = _20_m10 * _20_m13;
    _9.x = _168.x * _9.x;
    _301 = min(_9.x, 1.0f);
    _301 = sqrt(_301);
    _145 = _102.x * _20_m9.w;
    _740.w = (_20_m9.w * _102.x) + (-_521.w);
    float3 _760 = (_20_m9.xyz * _145.xxx) + (-_521.xyz);
    _740 = float4(_760.x, _760.y, _760.z, _740.w);
    _172 = (_301.xxxx * _740) + _521;
    _769 = _172;
    _172 = max(_20_m16, (-20000000000.0f).xxxx);
    _172 = min(_172, 20000000000.0f.xxxx);
    float2 _786 = _9.yz + (-_172.xy);
    _102 = float4(_786.x, _102.y, _102.z, _786.y);
    _58 = (_9.yz * 2.0f.xx) + (-_172.xy);
    float2 _802 = (-_172.zw) + _58;
    _740 = float4(_802.x, _802.y, _740.z, _740.w);
    _58 = (-_172.xy) + _172.zw;
    float2 _815 = _102.xw / _58;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _815.x, _815.y);
    vs_TEXCOORD0 = float4(_639.xy.x, _639.xy.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _822 = 0.0f >= _639.w;
    _58.x = float(_822);
    _829 = (-_20_m11) + _20_m12;
    _58.x = (_58.x * _829) + _20_m11;
    _58.x = (_58.x * 0.25f) + _20_m7;
    _58.x *= _20_m13;
    _58.x = ((-_58.x) * 0.5f) + 0.5f;
    _168.w = (_58.x * _168.x) + (-0.5f);
    _168.y = ((-_9.x) * 0.5f) + _168.w;
    _168.z = (_9.x * 0.5f) + _168.w;
    vs_TEXCOORD1 = _168;
    float2 _907 = max(float2(_20_m17, _20_m18), float2(_20_m31, _20_m32));
    _9 = float4(_907.x, _907.y, _9.z, _9.w);
    float2 _916 = (_9.xy * 0.25f.xx) + _112.xy;
    _9 = float4(_916.x, _916.y, _9.z, _9.w);
    float2 _921 = 0.25f.xx / _9.xy;
    _740 = float4(_740.x, _740.y, _921.x, _921.y);
    vs_TEXCOORD2 = _740;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _132 = stage_input._132;
    _349 = stage_input._349;
    _549 = stage_input._549;
    _639 = stage_input._639;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._534 = _534;
    stage_output._769 = _769;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 _44;
static float4 _56;

struct SPIRV_Cross_Input
{
    float4 _44 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _56 : SV_Target0;
};

static float4 _9;
static float _27;
static float _43;
static bool _60;

void frag_inner()
{
    _9.x = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).w;
    _27 = (_9.x * vs_TEXCOORD1.x) + (-vs_TEXCOORD1.w);
    _27 = clamp(_27, 0.0f, 1.0f);
    _43 = (_44.w * _27) + (-0.001000000047497451305389404296875f);
    _9 = _27.xxxx * _44;
    _56 = _9;
    _60 = _43 < 0.0f;
    if ((int(_60) * (-1)) != 0)
    {
        discard;
    }
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _44 = stage_input._44;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._56 = _56;
    return stage_output;
}

#endif
#elif defined(UNITY_UI_CLIP_RECT)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ScreenParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m2[4];
float4x4 unity_WorldToObject;
static float4 _20_m3[4];
float4x4 glstate_matrix_projection;
static float4 _20_m4[4];
float4x4 unity_MatrixVP;
static float4 _20_m5[4];
float4 _FaceColor;
float _FaceDilate;
float _OutlineSoftness;
float4 _OutlineColor;
float _OutlineWidth;
float _WeightNormal;
float _WeightBold;
float _ScaleRatioA;
float _VertexOffsetX;
float _VertexOffsetY;
float4 _ClipRect;
float _MaskSoftnessX;
float _MaskSoftnessY;
float _GradientScale;
float _ScaleX;
float _ScaleY;
float _PerspectiveFilter;
float _Sharpness;
float _CurveRadius;
float _FadeNear;
float _FadeFar;
float _DrumRadius;
float _DrumCentreY;
float _DrumHalfHeight;
float _DrumFade;
float _UIMaskSoftnessX;
float _UIMaskSoftnessY;
float _UIVertexColorAlwaysGammaSpace;
void __unity_init()
{
    _20_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _20_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _20_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _20_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _20_m4[0] = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]);
    _20_m4[1] = float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
    _20_m4[2] = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]);
    _20_m4[3] = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]);
    _20_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _ScreenParams
#define _20_m6 _FaceColor
#define _20_m7 _FaceDilate
#define _20_m8 _OutlineSoftness
#define _20_m9 _OutlineColor
#define _20_m10 _OutlineWidth
#define _20_m11 _WeightNormal
#define _20_m12 _WeightBold
#define _20_m13 _ScaleRatioA
#define _20_m14 _VertexOffsetX
#define _20_m15 _VertexOffsetY
#define _20_m16 _ClipRect
#define _20_m17 _MaskSoftnessX
#define _20_m18 _MaskSoftnessY
#define _20_m19 _GradientScale
#define _20_m20 _ScaleX
#define _20_m21 _ScaleY
#define _20_m22 _PerspectiveFilter
#define _20_m23 _Sharpness
#define _20_m24 _CurveRadius
#define _20_m25 _FadeNear
#define _20_m26 _FadeFar
#define _20_m27 _DrumRadius
#define _20_m28 _DrumCentreY
#define _20_m29 _DrumHalfHeight
#define _20_m30 _DrumFade
#define _20_m31 _UIMaskSoftnessX
#define _20_m32 _UIMaskSoftnessY
#define _20_m33 _UIVertexColorAlwaysGammaSpace



static float4 gl_Position;
static float4 _132;
static float4 _349;
static float4 _534;
static float3 _549;
static float4 _639;
static float4 _769;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _132 : POSITION;
    float3 _549 : NORMAL;
    float4 _349 : COLOR;
    float4 _639 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _534 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 _769 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _58;
static float4 _102;
static float3 _112;
static float _119;
static float _145;
static float4 _168;
static float4 _172;
static bool _212;
static float _221;
static float _244;
static float _301;
static bool _321;
static float3 _420;
static float3 _443;
static bool3 _454;
static float4 _521;
static bool _684;
static float4 _740;
static bool _822;
static float _829;

void vert_inner()
{
    __unity_init();
    float3 _32 = _20_m0 + (-_20_m2[3].xyz);
    _9 = float4(_32.x, _32.y, _32.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x += (-_20_m26);
    _58.x = (-_20_m26) + _20_m25;
    _58.x = 1.0f / _58.x;
    _9.x = _58.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _58.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _58.x;
    _102.x = _20_m29 / _20_m27;
    _112.x = (-_20_m30) + 1.0f;
    _119 = ((-_102.x) * _112.x) + _102.x;
    _119 = 1.0f / _119;
    float2 _142 = _132.xy + float2(_20_m14, _20_m15);
    _9 = float4(_9.x, _142.x, _142.y, _9.w);
    _145 = _9.z + (-_20_m28);
    _145 /= _20_m27;
    _102.x = ((-_102.x) * _112.x) + abs(_145);
    _168.x = sin(_145);
    _172.x = cos(_145);
    _102.x = _119 * _102.x;
    _102.x = clamp(_102.x, 0.0f, 1.0f);
    _112.x = (_102.x * (-2.0f)) + 3.0f;
    _102.x *= _102.x;
    _102.x = ((-_112.x) * _102.x) + 1.0f;
    _102.x = _9.x * _102.x;
    _212 = 0.0f < _20_m27;
    _9.w = _132.z;
    _221 = _20_m29 * _20_m29;
    _221 = (_20_m27 * _20_m27) + (-_221);
    _221 = max(_221, 0.0f);
    _221 = sqrt(_221);
    _221 = (-_221) + _20_m27;
    _244 = (-_172.x) + 1.0f;
    _102.y = (_20_m27 * _168.x) + _20_m28;
    _168.x = (_20_m27 * _244) + (-_221);
    _102.z = _168.x + _132.z;
    float3 _275;
    if (_212)
    {
        _275 = _102.xyz;
    }
    else
    {
        _275 = _9.xzw;
    }
    _102 = float4(_275.x, _275.y, _275.z, _102.w);
    _9.x = _9.y / _20_m24;
    _168.x = cos(_9.x);
    _9.x = sin(_9.x);
    _301 = (-_168.x) + 1.0f;
    _168.x = _9.x * _20_m24;
    _168.y = ((-_20_m24) * _301) + _102.z;
    _321 = 0.0f < _20_m24;
    _102.w = _9.y;
    float2 _330;
    if (_321)
    {
        _330 = _168.xy;
    }
    else
    {
        _330 = _102.wz;
    }
    _9 = float4(_330.x, _9.y, _9.z, _330.y);
    _168 = _102.yyyy * _20_m2[1];
    _102.x *= _349.w;
    _168 = (_20_m2[0] * _9.xxxx) + _168;
    _168 = (_20_m2[2] * _9.wwww) + _168;
    _172 = _168 + _20_m2[3];
    _112 = (_20_m2[3].xyz * _132.www) + _168.xyz;
    _112 = (-_112) + _20_m0;
    _168 = _172.yyyy * _20_m5[1];
    _168 = (_20_m5[0] * _172.xxxx) + _168;
    _168 = (_20_m5[2] * _172.zzzz) + _168;
    _168 = (_20_m5[3] * _172.wwww) + _168;
    gl_Position = _168;
    _420 = (_349.xyz * 0.26588499546051025390625f.xxx) + 0.736584007740020751953125f.xxx;
    _420 = (_349.xyz * _420) + (-0.00980184040963649749755859375f).xxx;
    _420 = (_349.xyz * _420) + 0.0031969700939953327178955078125f.xxx;
    _443 = (_349.xyz * 0.084971003234386444091796875f.xxx) + (-0.0001630290062166750431060791015625f).xxx;
    _454 = bool4(_349.xyzx.x < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).x, _349.xyzx.y < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).y, _349.xyzx.z < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).z, _349.xyzx.w < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).w).xyz;
    float3 _462 = _420;
    float _467;
    if (_454.x)
    {
        _467 = _443.x;
    }
    else
    {
        _467 = _420.x;
    }
    _462.x = _467;
    float _479;
    if (_454.y)
    {
        _479 = _443.y;
    }
    else
    {
        _479 = _420.y;
    }
    _462.y = _479;
    float _491;
    if (_454.z)
    {
        _491 = _443.z;
    }
    else
    {
        _491 = _420.z;
    }
    _462.z = _491;
    _420 = _462;
    float3 _507;
    if (_20_m33 != 0)
    {
        _507 = _420;
    }
    else
    {
        _507 = _349.xyz;
    }
    _420 = _507;
    _420 *= _20_m6.xyz;
    _521.w = _102.x * _20_m6.w;
    float3 _531 = _521.www * _420;
    _521 = float4(_531.x, _531.y, _531.z, _521.w);
    _534 = _521;
    _9.x = dot(_112, _112);
    _9.x = rsqrt(_9.x);
    _112 = _9.xxx * _112;
    _168.x = dot(_549, _20_m3[0].xyz);
    _168.y = dot(_549, _20_m3[1].xyz);
    _168.z = dot(_549, _20_m3[2].xyz);
    _9.x = dot(_168.xyz, _168.xyz);
    _9.x = rsqrt(_9.x);
    float3 _582 = _9.xxx * _168.xyz;
    _168 = float4(_582.x, _582.y, _582.z, _168.w);
    _9.x = dot(_168.xyz, _112);
    float2 _597 = _20_m1.yy * _20_m4[1].xy;
    _112 = float3(_597.x, _597.y, _112.z);
    float2 _609 = (_20_m4[0].xy * _20_m1.xx) + _112.xy;
    _112 = float3(_609.x, _609.y, _112.z);
    float2 _622 = abs(_112.xy) * float2(_20_m20, _20_m21);
    _112 = float3(_622.x, _622.y, _112.z);
    float2 _629 = _168.ww / _112.xy;
    _112 = float3(_629.x, _629.y, _112.z);
    _301 = dot(_112.xy, _112.xy);
    _301 = rsqrt(_301);
    _145 = abs(_639.w) * _20_m19;
    _168.x = _20_m23 + 1.0f;
    _145 *= _168.x;
    _168.x = _301 * _145;
    _221 = (-_20_m22) + 1.0f;
    _221 *= abs(_168.x);
    _301 = (_301 * _145) + (-_221);
    _9.x = (abs(_9.x) * _301) + _221;
    _684 = _20_m4[3].w == 0.0f;
    float _689;
    if (_684)
    {
        _689 = _9.x;
    }
    else
    {
        _689 = _168.x;
    }
    _9.x = _689;
    _301 = _20_m8 * _20_m13;
    _301 = (_301 * _9.x) + 1.0f;
    _168.x = _9.x / _301;
    _9.x = _20_m10 * _20_m13;
    _9.x = _168.x * _9.x;
    _301 = min(_9.x, 1.0f);
    _301 = sqrt(_301);
    _145 = _102.x * _20_m9.w;
    _740.w = (_20_m9.w * _102.x) + (-_521.w);
    float3 _760 = (_20_m9.xyz * _145.xxx) + (-_521.xyz);
    _740 = float4(_760.x, _760.y, _760.z, _740.w);
    _172 = (_301.xxxx * _740) + _521;
    _769 = _172;
    _172 = max(_20_m16, (-20000000000.0f).xxxx);
    _172 = min(_172, 20000000000.0f.xxxx);
    float2 _786 = _9.yz + (-_172.xy);
    _102 = float4(_786.x, _102.y, _102.z, _786.y);
    _58 = (_9.yz * 2.0f.xx) + (-_172.xy);
    float2 _802 = (-_172.zw) + _58;
    _740 = float4(_802.x, _802.y, _740.z, _740.w);
    _58 = (-_172.xy) + _172.zw;
    float2 _815 = _102.xw / _58;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _815.x, _815.y);
    vs_TEXCOORD0 = float4(_639.xy.x, _639.xy.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _822 = 0.0f >= _639.w;
    _58.x = float(_822);
    _829 = (-_20_m11) + _20_m12;
    _58.x = (_58.x * _829) + _20_m11;
    _58.x = (_58.x * 0.25f) + _20_m7;
    _58.x *= _20_m13;
    _58.x = ((-_58.x) * 0.5f) + 0.5f;
    _168.w = (_58.x * _168.x) + (-0.5f);
    _168.y = ((-_9.x) * 0.5f) + _168.w;
    _168.z = (_9.x * 0.5f) + _168.w;
    vs_TEXCOORD1 = _168;
    float2 _907 = max(float2(_20_m17, _20_m18), float2(_20_m31, _20_m32));
    _9 = float4(_907.x, _907.y, _9.z, _9.w);
    float2 _916 = (_9.xy * 0.25f.xx) + _112.xy;
    _9 = float4(_916.x, _916.y, _9.z, _9.w);
    float2 _921 = 0.25f.xx / _9.xy;
    _740 = float4(_740.x, _740.y, _921.x, _921.y);
    vs_TEXCOORD2 = _740;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _132 = stage_input._132;
    _349 = stage_input._349;
    _549 = stage_input._549;
    _639 = stage_input._639;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._534 = _534;
    stage_output._769 = _769;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _ClipRect;
#define _13_m0 _ClipRect


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 _83;
static float4 _87;

struct SPIRV_Cross_Input
{
    float4 _83 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _87 : SV_Target0;
};

static float2 _9;
static float _44;
static float4 _54;
static float _67;

void frag_inner()
{
    _9 = (-_13_m0.xy) + _13_m0.zw;
    _9 += (-abs(vs_TEXCOORD2.xy));
    _9 *= vs_TEXCOORD2.zw;
    _9 = clamp(_9, 0.0f.xx, 1.0f.xx);
    _44 = _9.y * _9.x;
    _54.x = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).w;
    _67 = (_54.x * vs_TEXCOORD1.x) + (-vs_TEXCOORD1.w);
    _67 = clamp(_67, 0.0f, 1.0f);
    _54 = _67.xxxx * _83;
    _87 = _44.xxxx * _54;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _83 = stage_input._83;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._87 = _87;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ScreenParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m2[4];
float4x4 unity_WorldToObject;
static float4 _20_m3[4];
float4x4 glstate_matrix_projection;
static float4 _20_m4[4];
float4x4 unity_MatrixVP;
static float4 _20_m5[4];
float4 _FaceColor;
float _FaceDilate;
float _OutlineSoftness;
float4 _OutlineColor;
float _OutlineWidth;
float _WeightNormal;
float _WeightBold;
float _ScaleRatioA;
float _VertexOffsetX;
float _VertexOffsetY;
float4 _ClipRect;
float _MaskSoftnessX;
float _MaskSoftnessY;
float _GradientScale;
float _ScaleX;
float _ScaleY;
float _PerspectiveFilter;
float _Sharpness;
float _CurveRadius;
float _FadeNear;
float _FadeFar;
float _DrumRadius;
float _DrumCentreY;
float _DrumHalfHeight;
float _DrumFade;
float _UIMaskSoftnessX;
float _UIMaskSoftnessY;
float _UIVertexColorAlwaysGammaSpace;
void __unity_init()
{
    _20_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _20_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _20_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _20_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _20_m4[0] = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]);
    _20_m4[1] = float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
    _20_m4[2] = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]);
    _20_m4[3] = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]);
    _20_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _ScreenParams
#define _20_m6 _FaceColor
#define _20_m7 _FaceDilate
#define _20_m8 _OutlineSoftness
#define _20_m9 _OutlineColor
#define _20_m10 _OutlineWidth
#define _20_m11 _WeightNormal
#define _20_m12 _WeightBold
#define _20_m13 _ScaleRatioA
#define _20_m14 _VertexOffsetX
#define _20_m15 _VertexOffsetY
#define _20_m16 _ClipRect
#define _20_m17 _MaskSoftnessX
#define _20_m18 _MaskSoftnessY
#define _20_m19 _GradientScale
#define _20_m20 _ScaleX
#define _20_m21 _ScaleY
#define _20_m22 _PerspectiveFilter
#define _20_m23 _Sharpness
#define _20_m24 _CurveRadius
#define _20_m25 _FadeNear
#define _20_m26 _FadeFar
#define _20_m27 _DrumRadius
#define _20_m28 _DrumCentreY
#define _20_m29 _DrumHalfHeight
#define _20_m30 _DrumFade
#define _20_m31 _UIMaskSoftnessX
#define _20_m32 _UIMaskSoftnessY
#define _20_m33 _UIVertexColorAlwaysGammaSpace



static float4 gl_Position;
static float4 _132;
static float4 _349;
static float4 _534;
static float3 _549;
static float4 _639;
static float4 _769;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _132 : POSITION;
    float3 _549 : NORMAL;
    float4 _349 : COLOR;
    float4 _639 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _534 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 _769 : TEXCOORD3;
    float4 vs_TEXCOORD2 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float2 _58;
static float4 _102;
static float3 _112;
static float _119;
static float _145;
static float4 _168;
static float4 _172;
static bool _212;
static float _221;
static float _244;
static float _301;
static bool _321;
static float3 _420;
static float3 _443;
static bool3 _454;
static float4 _521;
static bool _684;
static float4 _740;
static bool _822;
static float _829;

void vert_inner()
{
    __unity_init();
    float3 _32 = _20_m0 + (-_20_m2[3].xyz);
    _9 = float4(_32.x, _32.y, _32.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x += (-_20_m26);
    _58.x = (-_20_m26) + _20_m25;
    _58.x = 1.0f / _58.x;
    _9.x = _58.x * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _58.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _58.x;
    _102.x = _20_m29 / _20_m27;
    _112.x = (-_20_m30) + 1.0f;
    _119 = ((-_102.x) * _112.x) + _102.x;
    _119 = 1.0f / _119;
    float2 _142 = _132.xy + float2(_20_m14, _20_m15);
    _9 = float4(_9.x, _142.x, _142.y, _9.w);
    _145 = _9.z + (-_20_m28);
    _145 /= _20_m27;
    _102.x = ((-_102.x) * _112.x) + abs(_145);
    _168.x = sin(_145);
    _172.x = cos(_145);
    _102.x = _119 * _102.x;
    _102.x = clamp(_102.x, 0.0f, 1.0f);
    _112.x = (_102.x * (-2.0f)) + 3.0f;
    _102.x *= _102.x;
    _102.x = ((-_112.x) * _102.x) + 1.0f;
    _102.x = _9.x * _102.x;
    _212 = 0.0f < _20_m27;
    _9.w = _132.z;
    _221 = _20_m29 * _20_m29;
    _221 = (_20_m27 * _20_m27) + (-_221);
    _221 = max(_221, 0.0f);
    _221 = sqrt(_221);
    _221 = (-_221) + _20_m27;
    _244 = (-_172.x) + 1.0f;
    _102.y = (_20_m27 * _168.x) + _20_m28;
    _168.x = (_20_m27 * _244) + (-_221);
    _102.z = _168.x + _132.z;
    float3 _275;
    if (_212)
    {
        _275 = _102.xyz;
    }
    else
    {
        _275 = _9.xzw;
    }
    _102 = float4(_275.x, _275.y, _275.z, _102.w);
    _9.x = _9.y / _20_m24;
    _168.x = cos(_9.x);
    _9.x = sin(_9.x);
    _301 = (-_168.x) + 1.0f;
    _168.x = _9.x * _20_m24;
    _168.y = ((-_20_m24) * _301) + _102.z;
    _321 = 0.0f < _20_m24;
    _102.w = _9.y;
    float2 _330;
    if (_321)
    {
        _330 = _168.xy;
    }
    else
    {
        _330 = _102.wz;
    }
    _9 = float4(_330.x, _9.y, _9.z, _330.y);
    _168 = _102.yyyy * _20_m2[1];
    _102.x *= _349.w;
    _168 = (_20_m2[0] * _9.xxxx) + _168;
    _168 = (_20_m2[2] * _9.wwww) + _168;
    _172 = _168 + _20_m2[3];
    _112 = (_20_m2[3].xyz * _132.www) + _168.xyz;
    _112 = (-_112) + _20_m0;
    _168 = _172.yyyy * _20_m5[1];
    _168 = (_20_m5[0] * _172.xxxx) + _168;
    _168 = (_20_m5[2] * _172.zzzz) + _168;
    _168 = (_20_m5[3] * _172.wwww) + _168;
    gl_Position = _168;
    _420 = (_349.xyz * 0.26588499546051025390625f.xxx) + 0.736584007740020751953125f.xxx;
    _420 = (_349.xyz * _420) + (-0.00980184040963649749755859375f).xxx;
    _420 = (_349.xyz * _420) + 0.0031969700939953327178955078125f.xxx;
    _443 = (_349.xyz * 0.084971003234386444091796875f.xxx) + (-0.0001630290062166750431060791015625f).xxx;
    _454 = bool4(_349.xyzx.x < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).x, _349.xyzx.y < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).y, _349.xyzx.z < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).z, _349.xyzx.w < float4(0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.07254900038242340087890625f, 0.0f).w).xyz;
    float3 _462 = _420;
    float _467;
    if (_454.x)
    {
        _467 = _443.x;
    }
    else
    {
        _467 = _420.x;
    }
    _462.x = _467;
    float _479;
    if (_454.y)
    {
        _479 = _443.y;
    }
    else
    {
        _479 = _420.y;
    }
    _462.y = _479;
    float _491;
    if (_454.z)
    {
        _491 = _443.z;
    }
    else
    {
        _491 = _420.z;
    }
    _462.z = _491;
    _420 = _462;
    float3 _507;
    if (_20_m33 != 0)
    {
        _507 = _420;
    }
    else
    {
        _507 = _349.xyz;
    }
    _420 = _507;
    _420 *= _20_m6.xyz;
    _521.w = _102.x * _20_m6.w;
    float3 _531 = _521.www * _420;
    _521 = float4(_531.x, _531.y, _531.z, _521.w);
    _534 = _521;
    _9.x = dot(_112, _112);
    _9.x = rsqrt(_9.x);
    _112 = _9.xxx * _112;
    _168.x = dot(_549, _20_m3[0].xyz);
    _168.y = dot(_549, _20_m3[1].xyz);
    _168.z = dot(_549, _20_m3[2].xyz);
    _9.x = dot(_168.xyz, _168.xyz);
    _9.x = rsqrt(_9.x);
    float3 _582 = _9.xxx * _168.xyz;
    _168 = float4(_582.x, _582.y, _582.z, _168.w);
    _9.x = dot(_168.xyz, _112);
    float2 _597 = _20_m1.yy * _20_m4[1].xy;
    _112 = float3(_597.x, _597.y, _112.z);
    float2 _609 = (_20_m4[0].xy * _20_m1.xx) + _112.xy;
    _112 = float3(_609.x, _609.y, _112.z);
    float2 _622 = abs(_112.xy) * float2(_20_m20, _20_m21);
    _112 = float3(_622.x, _622.y, _112.z);
    float2 _629 = _168.ww / _112.xy;
    _112 = float3(_629.x, _629.y, _112.z);
    _301 = dot(_112.xy, _112.xy);
    _301 = rsqrt(_301);
    _145 = abs(_639.w) * _20_m19;
    _168.x = _20_m23 + 1.0f;
    _145 *= _168.x;
    _168.x = _301 * _145;
    _221 = (-_20_m22) + 1.0f;
    _221 *= abs(_168.x);
    _301 = (_301 * _145) + (-_221);
    _9.x = (abs(_9.x) * _301) + _221;
    _684 = _20_m4[3].w == 0.0f;
    float _689;
    if (_684)
    {
        _689 = _9.x;
    }
    else
    {
        _689 = _168.x;
    }
    _9.x = _689;
    _301 = _20_m8 * _20_m13;
    _301 = (_301 * _9.x) + 1.0f;
    _168.x = _9.x / _301;
    _9.x = _20_m10 * _20_m13;
    _9.x = _168.x * _9.x;
    _301 = min(_9.x, 1.0f);
    _301 = sqrt(_301);
    _145 = _102.x * _20_m9.w;
    _740.w = (_20_m9.w * _102.x) + (-_521.w);
    float3 _760 = (_20_m9.xyz * _145.xxx) + (-_521.xyz);
    _740 = float4(_760.x, _760.y, _760.z, _740.w);
    _172 = (_301.xxxx * _740) + _521;
    _769 = _172;
    _172 = max(_20_m16, (-20000000000.0f).xxxx);
    _172 = min(_172, 20000000000.0f.xxxx);
    float2 _786 = _9.yz + (-_172.xy);
    _102 = float4(_786.x, _102.y, _102.z, _786.y);
    _58 = (_9.yz * 2.0f.xx) + (-_172.xy);
    float2 _802 = (-_172.zw) + _58;
    _740 = float4(_802.x, _802.y, _740.z, _740.w);
    _58 = (-_172.xy) + _172.zw;
    float2 _815 = _102.xw / _58;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _815.x, _815.y);
    vs_TEXCOORD0 = float4(_639.xy.x, _639.xy.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _822 = 0.0f >= _639.w;
    _58.x = float(_822);
    _829 = (-_20_m11) + _20_m12;
    _58.x = (_58.x * _829) + _20_m11;
    _58.x = (_58.x * 0.25f) + _20_m7;
    _58.x *= _20_m13;
    _58.x = ((-_58.x) * 0.5f) + 0.5f;
    _168.w = (_58.x * _168.x) + (-0.5f);
    _168.y = ((-_9.x) * 0.5f) + _168.w;
    _168.z = (_9.x * 0.5f) + _168.w;
    vs_TEXCOORD1 = _168;
    float2 _907 = max(float2(_20_m17, _20_m18), float2(_20_m31, _20_m32));
    _9 = float4(_907.x, _907.y, _9.z, _9.w);
    float2 _916 = (_9.xy * 0.25f.xx) + _112.xy;
    _9 = float4(_916.x, _916.y, _9.z, _9.w);
    float2 _921 = 0.25f.xx / _9.xy;
    _740 = float4(_740.x, _740.y, _921.x, _921.y);
    vs_TEXCOORD2 = _740;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _132 = stage_input._132;
    _349 = stage_input._349;
    _549 = stage_input._549;
    _639 = stage_input._639;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._534 = _534;
    stage_output._769 = _769;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 _41;
static float4 _44;

struct SPIRV_Cross_Input
{
    float4 _44 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _41 : SV_Target0;
};

static float _8;
static float _24;

void frag_inner()
{
    _8 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).w;
    _24 = (_8 * vs_TEXCOORD1.x) + (-vs_TEXCOORD1.w);
    _24 = clamp(_24, 0.0f, 1.0f);
    _41 = _24.xxxx * _44;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _44 = stage_input._44;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._41 = _41;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
CustomEditor "TMPro.EditorUtilities.TMP_SDFShaderGUI"
}