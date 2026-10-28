// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MenuFrame" {
Properties {

_MainTex ("Texture", 2D) = "white" { }

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
static float4 _82;
static float4 _83;
static float4 vs_TEXCOORD0;
static float4 _86;
static float4 vs_TEXCOORD1;
static float4 _89;
static float4 vs_TEXCOORD2;
static float4 _92;
static float4 vs_TEXCOORD3;
static float4 _95;
static float4 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _83 : COLOR;
    float4 _86 : TEXCOORD0;
    float4 _89 : TEXCOORD1;
    float4 _92 : TEXCOORD2;
    float4 _95 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _82 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD4 : TEXCOORD5;
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
    _82 = _83;
    vs_TEXCOORD0 = _86;
    vs_TEXCOORD1 = _89;
    vs_TEXCOORD2 = _92;
    vs_TEXCOORD3 = _95;
    vs_TEXCOORD4 = _11;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _83 = stage_input._83;
    _86 = stage_input._86;
    _89 = stage_input._89;
    _92 = stage_input._92;
    _95 = stage_input._95;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._82 = _82;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _ClipRect;
#define _438_m0 _ClipRect



static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 _420;
static float4 vs_TEXCOORD4;
static float4 _499;

struct SPIRV_Cross_Input
{
    float4 _420 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _499 : SV_Target0;
};

static float4 _9;
static float2 _23;
static float _40;
static bool _64;
static float2 _71;
static bool2 _88;
static float _94;
static float2 _109;
static bool _127;
static float4 _135;
static float _151;
static float _167;
static float _274;
static bool _293;
static float4 _373;
static float _389;
static float4 _411;
static bool4 _432;

void frag_inner()
{
    float2 _19 = (-vs_TEXCOORD0.zw) + abs(vs_TEXCOORD0.xy);
    _9 = float4(_19.x, _19.y, _9.z, _9.w);
    _23 = max(_9.xy, 0.0f.xx);
    _23.x = dot(_23, _23);
    _23.x = sqrt(_23.x);
    _40 = max(_9.y, _9.x);
    float2 _52 = _9.xy + vs_TEXCOORD3.ww;
    _9 = float4(_52.x, _52.y, _9.z, _9.w);
    _40 = min(_40, 0.0f);
    _23.x = _40 + _23.x;
    _64 = vs_TEXCOORD3.z >= 7.5f;
    _71.x = _64 ? (-8.0f) : (-0.0f);
    _40 = float(_64);
    _71.x += vs_TEXCOORD3.z;
    _88.x = _71.x >= 3.5f;
    _94 = _88.x ? (-4.0f) : (-0.0f);
    _71.x = _94 + _71.x;
    _88.y = _71.x >= 1.5f;
    _109.x = float(_88.x);
    _109.y = float(_88.y);
    _71.x = ((-_109.y) * 2.0f) + _71.x;
    _127 = _71.x >= 0.5f;
    _71.x = float(_127);
    float2 _141 = vs_TEXCOORD0.yx + (-vs_TEXCOORD0.xy);
    _135 = float4(_141.x, _141.y, _135.z, _135.w);
    float2 _148 = vs_TEXCOORD0.wy + vs_TEXCOORD0.zx;
    _135 = float4(_135.x, _135.y, _148.x, _148.y);
    _151 = _135.z + (-vs_TEXCOORD3.y);
    float3 _164 = (-_151.xxx) + _135.xyw;
    _135 = float4(_164.x, _164.y, _164.z, _135.w);
    _167 = (_135.z * 0.707106769084930419921875f) + 10000.0f;
    _94 = (_109.y * _167) + (-10000.0f);
    float2 _185 = (_135.xy * 0.707106769084930419921875f.xx) + 10000.0f.xx;
    _135 = float4(_185.x, _185.y, _135.z, _135.w);
    _71.x = (_71.x * _135.x) + (-10000.0f);
    _109.x = (_109.x * _135.y) + (-10000.0f);
    _71.x = max(_23.x, _71.x);
    _71.x = max(_94, _71.x);
    _71.x = max(_109.x, _71.x);
    _109.x = (-vs_TEXCOORD0.y) + (-vs_TEXCOORD0.x);
    _109.x = (-_151) + _109.x;
    _109.x = (_109.x * 0.707106769084930419921875f) + 10000.0f;
    _40 = (_40 * _109.x) + (-10000.0f);
    _40 = max(_40, _71.x);
    _127 = 0.0f < vs_TEXCOORD3.y;
    float _252;
    if (_127)
    {
        _252 = _40;
    }
    else
    {
        _252 = _23.x;
    }
    _23.x = _252;
    _71 = max(_9.xy, 0.0f.xx);
    _9.x = max(_9.y, _9.x);
    _9.x = min(_9.x, 0.0f);
    _274 = dot(_71, _71);
    _274 = sqrt(_274);
    _9.x += _274;
    _9.x += (-vs_TEXCOORD3.w);
    _293 = 0.0f >= vs_TEXCOORD3.w;
    float _298;
    if (_293)
    {
        _298 = _23.x;
    }
    else
    {
        _298 = _9.x;
    }
    _9.x = _298;
    _274 = ddx_coarse(_9.x);
    _23.x = ddy_coarse(_9.x);
    _274 = abs(_23.x) + abs(_274);
    _274 = max(_274, 9.9999997473787516355514526367188e-05f);
    _23.x = max(_274, vs_TEXCOORD3.x);
    _9.z = _23.x + _9.x;
    float2 _339 = _9.xz / _274.xx;
    _9 = float4(_339.x, _9.y, _339.y, _9.w);
    _274 = vs_TEXCOORD3.x / _274;
    _274 = clamp(_274, 0.0f, 1.0f);
    float2 _352 = (-_9.xz) + 0.5f.xx;
    _9 = float4(_352.x, _9.y, _352.y, _9.w);
    float2 _359 = clamp(_9.xz, 0.0f.xx, 1.0f.xx);
    _9 = float4(_359.x, _9.y, _359.y, _9.w);
    _23.x = (-_9.z) + _9.x;
    _274 *= _23.x;
    float3 _379 = vs_TEXCOORD1.www * vs_TEXCOORD1.xyz;
    _373 = float4(_379.x, _379.y, _379.z, _373.w);
    _373.w = vs_TEXCOORD1.w;
    _135 = _274.xxxx * _373;
    _389 = ((-_373.w) * _274) + 1.0f;
    float3 _401 = vs_TEXCOORD2.www * vs_TEXCOORD2.xyz;
    _373 = float4(_401.x, _401.y, _401.z, _373.w);
    _373.w = vs_TEXCOORD2.w;
    _9 = _9.xxxx * _373;
    _411 = (_9 * _389.xxxx) + _135;
    float3 _423 = _411.xyz * _420.xyz;
    _411 = float4(_423.x, _423.y, _423.z, _411.w);
    _411 *= _420.wwww;
    bool2 _446 = bool4(vs_TEXCOORD4.xyxx.x >= _438_m0.xyxx.x, vs_TEXCOORD4.xyxx.y >= _438_m0.xyxx.y, vs_TEXCOORD4.xyxx.z >= _438_m0.xyxx.z, vs_TEXCOORD4.xyxx.w >= _438_m0.xyxx.w).xy;
    _432 = bool4(_446.x, _446.y, _432.z, _432.w);
    bool2 _455 = bool4(_438_m0.zzzw.x >= vs_TEXCOORD4.xxxy.x, _438_m0.zzzw.y >= vs_TEXCOORD4.xxxy.y, _438_m0.zzzw.z >= vs_TEXCOORD4.xxxy.z, _438_m0.zzzw.w >= vs_TEXCOORD4.xxxy.w).zw;
    _432 = bool4(_432.x, _432.y, _455.x, _455.y);
    _135.x = float(_432.x);
    _135.y = float(_432.y);
    _135.z = float(_432.z);
    _135.w = float(_432.w);
    float2 _478 = _135.zw * _135.xy;
    _135 = float4(_478.x, _478.y, _135.z, _135.w);
    _135.x = _135.y * _135.x;
    _389 = (_411.w * _135.x) + (-0.001000000047497451305389404296875f);
    _9 = _411 * _135.xxxx;
    _499 = _9;
    _432.x = _389 < 0.0f;
    if ((int(_432.x) * (-1)) != 0)
    {
        discard;
    }
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _420 = stage_input._420;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._499 = _499;
    return stage_output;
}

#endif
#elif defined(UNITY_UI_ALPHACLIP)
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
static float4 _82;
static float4 _83;
static float4 vs_TEXCOORD0;
static float4 _86;
static float4 vs_TEXCOORD1;
static float4 _89;
static float4 vs_TEXCOORD2;
static float4 _92;
static float4 vs_TEXCOORD3;
static float4 _95;
static float4 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _83 : COLOR;
    float4 _86 : TEXCOORD0;
    float4 _89 : TEXCOORD1;
    float4 _92 : TEXCOORD2;
    float4 _95 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _82 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD4 : TEXCOORD5;
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
    _82 = _83;
    vs_TEXCOORD0 = _86;
    vs_TEXCOORD1 = _89;
    vs_TEXCOORD2 = _92;
    vs_TEXCOORD3 = _95;
    vs_TEXCOORD4 = _11;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _83 = stage_input._83;
    _86 = stage_input._86;
    _89 = stage_input._89;
    _92 = stage_input._92;
    _95 = stage_input._95;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._82 = _82;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 _420;
static float4 _452;

struct SPIRV_Cross_Input
{
    float4 _420 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _452 : SV_Target0;
};

static float4 _9;
static float2 _23;
static float _40;
static bool _64;
static float2 _71;
static bool2 _88;
static float _94;
static float2 _109;
static bool _127;
static float4 _135;
static float _151;
static float _167;
static float _274;
static bool _293;
static float4 _373;
static float _389;
static float4 _411;
static bool _437;

void frag_inner()
{
    float2 _19 = (-vs_TEXCOORD0.zw) + abs(vs_TEXCOORD0.xy);
    _9 = float4(_19.x, _19.y, _9.z, _9.w);
    _23 = max(_9.xy, 0.0f.xx);
    _23.x = dot(_23, _23);
    _23.x = sqrt(_23.x);
    _40 = max(_9.y, _9.x);
    float2 _52 = _9.xy + vs_TEXCOORD3.ww;
    _9 = float4(_52.x, _52.y, _9.z, _9.w);
    _40 = min(_40, 0.0f);
    _23.x = _40 + _23.x;
    _64 = vs_TEXCOORD3.z >= 7.5f;
    _71.x = _64 ? (-8.0f) : (-0.0f);
    _40 = float(_64);
    _71.x += vs_TEXCOORD3.z;
    _88.x = _71.x >= 3.5f;
    _94 = _88.x ? (-4.0f) : (-0.0f);
    _71.x = _94 + _71.x;
    _88.y = _71.x >= 1.5f;
    _109.x = float(_88.x);
    _109.y = float(_88.y);
    _71.x = ((-_109.y) * 2.0f) + _71.x;
    _127 = _71.x >= 0.5f;
    _71.x = float(_127);
    float2 _141 = vs_TEXCOORD0.yx + (-vs_TEXCOORD0.xy);
    _135 = float4(_141.x, _141.y, _135.z, _135.w);
    float2 _148 = vs_TEXCOORD0.wy + vs_TEXCOORD0.zx;
    _135 = float4(_135.x, _135.y, _148.x, _148.y);
    _151 = _135.z + (-vs_TEXCOORD3.y);
    float3 _164 = (-_151.xxx) + _135.xyw;
    _135 = float4(_164.x, _164.y, _164.z, _135.w);
    _167 = (_135.z * 0.707106769084930419921875f) + 10000.0f;
    _94 = (_109.y * _167) + (-10000.0f);
    float2 _185 = (_135.xy * 0.707106769084930419921875f.xx) + 10000.0f.xx;
    _135 = float4(_185.x, _185.y, _135.z, _135.w);
    _71.x = (_71.x * _135.x) + (-10000.0f);
    _109.x = (_109.x * _135.y) + (-10000.0f);
    _71.x = max(_23.x, _71.x);
    _71.x = max(_94, _71.x);
    _71.x = max(_109.x, _71.x);
    _109.x = (-vs_TEXCOORD0.y) + (-vs_TEXCOORD0.x);
    _109.x = (-_151) + _109.x;
    _109.x = (_109.x * 0.707106769084930419921875f) + 10000.0f;
    _40 = (_40 * _109.x) + (-10000.0f);
    _40 = max(_40, _71.x);
    _127 = 0.0f < vs_TEXCOORD3.y;
    float _252;
    if (_127)
    {
        _252 = _40;
    }
    else
    {
        _252 = _23.x;
    }
    _23.x = _252;
    _71 = max(_9.xy, 0.0f.xx);
    _9.x = max(_9.y, _9.x);
    _9.x = min(_9.x, 0.0f);
    _274 = dot(_71, _71);
    _274 = sqrt(_274);
    _9.x += _274;
    _9.x += (-vs_TEXCOORD3.w);
    _293 = 0.0f >= vs_TEXCOORD3.w;
    float _298;
    if (_293)
    {
        _298 = _23.x;
    }
    else
    {
        _298 = _9.x;
    }
    _9.x = _298;
    _274 = ddx_coarse(_9.x);
    _23.x = ddy_coarse(_9.x);
    _274 = abs(_23.x) + abs(_274);
    _274 = max(_274, 9.9999997473787516355514526367188e-05f);
    _23.x = max(_274, vs_TEXCOORD3.x);
    _9.z = _23.x + _9.x;
    float2 _339 = _9.xz / _274.xx;
    _9 = float4(_339.x, _9.y, _339.y, _9.w);
    _274 = vs_TEXCOORD3.x / _274;
    _274 = clamp(_274, 0.0f, 1.0f);
    float2 _352 = (-_9.xz) + 0.5f.xx;
    _9 = float4(_352.x, _9.y, _352.y, _9.w);
    float2 _359 = clamp(_9.xz, 0.0f.xx, 1.0f.xx);
    _9 = float4(_359.x, _9.y, _359.y, _9.w);
    _23.x = (-_9.z) + _9.x;
    _274 *= _23.x;
    float3 _379 = vs_TEXCOORD1.www * vs_TEXCOORD1.xyz;
    _373 = float4(_379.x, _379.y, _379.z, _373.w);
    _373.w = vs_TEXCOORD1.w;
    _135 = _274.xxxx * _373;
    _389 = ((-_373.w) * _274) + 1.0f;
    float3 _401 = vs_TEXCOORD2.www * vs_TEXCOORD2.xyz;
    _373 = float4(_401.x, _401.y, _401.z, _373.w);
    _373.w = vs_TEXCOORD2.w;
    _9 = _9.xxxx * _373;
    _411 = (_9 * _389.xxxx) + _135;
    float3 _423 = _411.xyz * _420.xyz;
    _411 = float4(_423.x, _423.y, _423.z, _411.w);
    _373 = _411 * _420.wwww;
    _389 = (_411.w * _420.w) + (-0.001000000047497451305389404296875f);
    _437 = _389 < 0.0f;
    if ((int(_437) * (-1)) != 0)
    {
        discard;
    }
    _452 = _373;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _420 = stage_input._420;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._452 = _452;
    return stage_output;
}

#endif
#elif defined(UNITY_UI_CLIP_RECT)
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
static float4 _82;
static float4 _83;
static float4 vs_TEXCOORD0;
static float4 _86;
static float4 vs_TEXCOORD1;
static float4 _89;
static float4 vs_TEXCOORD2;
static float4 _92;
static float4 vs_TEXCOORD3;
static float4 _95;
static float4 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _83 : COLOR;
    float4 _86 : TEXCOORD0;
    float4 _89 : TEXCOORD1;
    float4 _92 : TEXCOORD2;
    float4 _95 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _82 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD4 : TEXCOORD5;
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
    _82 = _83;
    vs_TEXCOORD0 = _86;
    vs_TEXCOORD1 = _89;
    vs_TEXCOORD2 = _92;
    vs_TEXCOORD3 = _95;
    vs_TEXCOORD4 = _11;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _83 = stage_input._83;
    _86 = stage_input._86;
    _89 = stage_input._89;
    _92 = stage_input._92;
    _95 = stage_input._95;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._82 = _82;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _ClipRect;
#define _438_m0 _ClipRect



static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 _420;
static float4 vs_TEXCOORD4;
static float4 _492;

struct SPIRV_Cross_Input
{
    float4 _420 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _492 : SV_Target0;
};

static float4 _9;
static float2 _23;
static float _40;
static bool _64;
static float2 _71;
static bool2 _88;
static float _94;
static float2 _109;
static bool _127;
static float4 _135;
static float _151;
static float _167;
static float _274;
static bool _293;
static float4 _373;
static float _389;
static float4 _411;
static bool4 _432;

void frag_inner()
{
    float2 _19 = (-vs_TEXCOORD0.zw) + abs(vs_TEXCOORD0.xy);
    _9 = float4(_19.x, _19.y, _9.z, _9.w);
    _23 = max(_9.xy, 0.0f.xx);
    _23.x = dot(_23, _23);
    _23.x = sqrt(_23.x);
    _40 = max(_9.y, _9.x);
    float2 _52 = _9.xy + vs_TEXCOORD3.ww;
    _9 = float4(_52.x, _52.y, _9.z, _9.w);
    _40 = min(_40, 0.0f);
    _23.x = _40 + _23.x;
    _64 = vs_TEXCOORD3.z >= 7.5f;
    _71.x = _64 ? (-8.0f) : (-0.0f);
    _40 = float(_64);
    _71.x += vs_TEXCOORD3.z;
    _88.x = _71.x >= 3.5f;
    _94 = _88.x ? (-4.0f) : (-0.0f);
    _71.x = _94 + _71.x;
    _88.y = _71.x >= 1.5f;
    _109.x = float(_88.x);
    _109.y = float(_88.y);
    _71.x = ((-_109.y) * 2.0f) + _71.x;
    _127 = _71.x >= 0.5f;
    _71.x = float(_127);
    float2 _141 = vs_TEXCOORD0.yx + (-vs_TEXCOORD0.xy);
    _135 = float4(_141.x, _141.y, _135.z, _135.w);
    float2 _148 = vs_TEXCOORD0.wy + vs_TEXCOORD0.zx;
    _135 = float4(_135.x, _135.y, _148.x, _148.y);
    _151 = _135.z + (-vs_TEXCOORD3.y);
    float3 _164 = (-_151.xxx) + _135.xyw;
    _135 = float4(_164.x, _164.y, _164.z, _135.w);
    _167 = (_135.z * 0.707106769084930419921875f) + 10000.0f;
    _94 = (_109.y * _167) + (-10000.0f);
    float2 _185 = (_135.xy * 0.707106769084930419921875f.xx) + 10000.0f.xx;
    _135 = float4(_185.x, _185.y, _135.z, _135.w);
    _71.x = (_71.x * _135.x) + (-10000.0f);
    _109.x = (_109.x * _135.y) + (-10000.0f);
    _71.x = max(_23.x, _71.x);
    _71.x = max(_94, _71.x);
    _71.x = max(_109.x, _71.x);
    _109.x = (-vs_TEXCOORD0.y) + (-vs_TEXCOORD0.x);
    _109.x = (-_151) + _109.x;
    _109.x = (_109.x * 0.707106769084930419921875f) + 10000.0f;
    _40 = (_40 * _109.x) + (-10000.0f);
    _40 = max(_40, _71.x);
    _127 = 0.0f < vs_TEXCOORD3.y;
    float _252;
    if (_127)
    {
        _252 = _40;
    }
    else
    {
        _252 = _23.x;
    }
    _23.x = _252;
    _71 = max(_9.xy, 0.0f.xx);
    _9.x = max(_9.y, _9.x);
    _9.x = min(_9.x, 0.0f);
    _274 = dot(_71, _71);
    _274 = sqrt(_274);
    _9.x += _274;
    _9.x += (-vs_TEXCOORD3.w);
    _293 = 0.0f >= vs_TEXCOORD3.w;
    float _298;
    if (_293)
    {
        _298 = _23.x;
    }
    else
    {
        _298 = _9.x;
    }
    _9.x = _298;
    _274 = ddx_coarse(_9.x);
    _23.x = ddy_coarse(_9.x);
    _274 = abs(_23.x) + abs(_274);
    _274 = max(_274, 9.9999997473787516355514526367188e-05f);
    _23.x = max(_274, vs_TEXCOORD3.x);
    _9.z = _23.x + _9.x;
    float2 _339 = _9.xz / _274.xx;
    _9 = float4(_339.x, _9.y, _339.y, _9.w);
    _274 = vs_TEXCOORD3.x / _274;
    _274 = clamp(_274, 0.0f, 1.0f);
    float2 _352 = (-_9.xz) + 0.5f.xx;
    _9 = float4(_352.x, _9.y, _352.y, _9.w);
    float2 _359 = clamp(_9.xz, 0.0f.xx, 1.0f.xx);
    _9 = float4(_359.x, _9.y, _359.y, _9.w);
    _23.x = (-_9.z) + _9.x;
    _274 *= _23.x;
    float3 _379 = vs_TEXCOORD1.www * vs_TEXCOORD1.xyz;
    _373 = float4(_379.x, _379.y, _379.z, _373.w);
    _373.w = vs_TEXCOORD1.w;
    _135 = _274.xxxx * _373;
    _389 = ((-_373.w) * _274) + 1.0f;
    float3 _401 = vs_TEXCOORD2.www * vs_TEXCOORD2.xyz;
    _373 = float4(_401.x, _401.y, _401.z, _373.w);
    _373.w = vs_TEXCOORD2.w;
    _9 = _9.xxxx * _373;
    _411 = (_9 * _389.xxxx) + _135;
    float3 _423 = _411.xyz * _420.xyz;
    _411 = float4(_423.x, _423.y, _423.z, _411.w);
    _411 *= _420.wwww;
    bool2 _446 = bool4(vs_TEXCOORD4.xyxx.x >= _438_m0.xyxx.x, vs_TEXCOORD4.xyxx.y >= _438_m0.xyxx.y, vs_TEXCOORD4.xyxx.z >= _438_m0.xyxx.z, vs_TEXCOORD4.xyxx.w >= _438_m0.xyxx.w).xy;
    _432 = bool4(_446.x, _446.y, _432.z, _432.w);
    bool2 _455 = bool4(_438_m0.zzzw.x >= vs_TEXCOORD4.xxxy.x, _438_m0.zzzw.y >= vs_TEXCOORD4.xxxy.y, _438_m0.zzzw.z >= vs_TEXCOORD4.xxxy.z, _438_m0.zzzw.w >= vs_TEXCOORD4.xxxy.w).zw;
    _432 = bool4(_432.x, _432.y, _455.x, _455.y);
    _135.x = float(_432.x);
    _135.y = float(_432.y);
    _135.z = float(_432.z);
    _135.w = float(_432.w);
    float2 _478 = _135.zw * _135.xy;
    _135 = float4(_478.x, _478.y, _135.z, _135.w);
    _135.x = _135.y * _135.x;
    _9 = _411 * _135.xxxx;
    _492 = _9;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _420 = stage_input._420;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._492 = _492;
    return stage_output;
}

#endif
#else
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
static float4 _82;
static float4 _83;
static float4 vs_TEXCOORD0;
static float4 _86;
static float4 vs_TEXCOORD1;
static float4 _89;
static float4 vs_TEXCOORD2;
static float4 _92;
static float4 vs_TEXCOORD3;
static float4 _95;
static float4 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _83 : COLOR;
    float4 _86 : TEXCOORD0;
    float4 _89 : TEXCOORD1;
    float4 _92 : TEXCOORD2;
    float4 _95 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _82 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float4 vs_TEXCOORD4 : TEXCOORD5;
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
    _82 = _83;
    vs_TEXCOORD0 = _86;
    vs_TEXCOORD1 = _89;
    vs_TEXCOORD2 = _92;
    vs_TEXCOORD3 = _95;
    vs_TEXCOORD4 = _11;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _83 = stage_input._83;
    _86 = stage_input._86;
    _89 = stage_input._89;
    _92 = stage_input._92;
    _95 = stage_input._95;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._82 = _82;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD2;
static float4 _420;
static float4 _427;

struct SPIRV_Cross_Input
{
    float4 _420 : TEXCOORD0;
    float4 vs_TEXCOORD0 : TEXCOORD1;
    float4 vs_TEXCOORD1 : TEXCOORD2;
    float4 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _427 : SV_Target0;
};

static float4 _9;
static float2 _23;
static float _40;
static bool _64;
static float2 _71;
static bool2 _88;
static float _94;
static float2 _109;
static bool _127;
static float4 _135;
static float _151;
static float _167;
static float _274;
static bool _293;
static float4 _373;
static float _389;
static float4 _411;

void frag_inner()
{
    float2 _19 = (-vs_TEXCOORD0.zw) + abs(vs_TEXCOORD0.xy);
    _9 = float4(_19.x, _19.y, _9.z, _9.w);
    _23 = max(_9.xy, 0.0f.xx);
    _23.x = dot(_23, _23);
    _23.x = sqrt(_23.x);
    _40 = max(_9.y, _9.x);
    float2 _52 = _9.xy + vs_TEXCOORD3.ww;
    _9 = float4(_52.x, _52.y, _9.z, _9.w);
    _40 = min(_40, 0.0f);
    _23.x = _40 + _23.x;
    _64 = vs_TEXCOORD3.z >= 7.5f;
    _71.x = _64 ? (-8.0f) : (-0.0f);
    _40 = float(_64);
    _71.x += vs_TEXCOORD3.z;
    _88.x = _71.x >= 3.5f;
    _94 = _88.x ? (-4.0f) : (-0.0f);
    _71.x = _94 + _71.x;
    _88.y = _71.x >= 1.5f;
    _109.x = float(_88.x);
    _109.y = float(_88.y);
    _71.x = ((-_109.y) * 2.0f) + _71.x;
    _127 = _71.x >= 0.5f;
    _71.x = float(_127);
    float2 _141 = vs_TEXCOORD0.yx + (-vs_TEXCOORD0.xy);
    _135 = float4(_141.x, _141.y, _135.z, _135.w);
    float2 _148 = vs_TEXCOORD0.wy + vs_TEXCOORD0.zx;
    _135 = float4(_135.x, _135.y, _148.x, _148.y);
    _151 = _135.z + (-vs_TEXCOORD3.y);
    float3 _164 = (-_151.xxx) + _135.xyw;
    _135 = float4(_164.x, _164.y, _164.z, _135.w);
    _167 = (_135.z * 0.707106769084930419921875f) + 10000.0f;
    _94 = (_109.y * _167) + (-10000.0f);
    float2 _185 = (_135.xy * 0.707106769084930419921875f.xx) + 10000.0f.xx;
    _135 = float4(_185.x, _185.y, _135.z, _135.w);
    _71.x = (_71.x * _135.x) + (-10000.0f);
    _109.x = (_109.x * _135.y) + (-10000.0f);
    _71.x = max(_23.x, _71.x);
    _71.x = max(_94, _71.x);
    _71.x = max(_109.x, _71.x);
    _109.x = (-vs_TEXCOORD0.y) + (-vs_TEXCOORD0.x);
    _109.x = (-_151) + _109.x;
    _109.x = (_109.x * 0.707106769084930419921875f) + 10000.0f;
    _40 = (_40 * _109.x) + (-10000.0f);
    _40 = max(_40, _71.x);
    _127 = 0.0f < vs_TEXCOORD3.y;
    float _252;
    if (_127)
    {
        _252 = _40;
    }
    else
    {
        _252 = _23.x;
    }
    _23.x = _252;
    _71 = max(_9.xy, 0.0f.xx);
    _9.x = max(_9.y, _9.x);
    _9.x = min(_9.x, 0.0f);
    _274 = dot(_71, _71);
    _274 = sqrt(_274);
    _9.x += _274;
    _9.x += (-vs_TEXCOORD3.w);
    _293 = 0.0f >= vs_TEXCOORD3.w;
    float _298;
    if (_293)
    {
        _298 = _23.x;
    }
    else
    {
        _298 = _9.x;
    }
    _9.x = _298;
    _274 = ddx_coarse(_9.x);
    _23.x = ddy_coarse(_9.x);
    _274 = abs(_23.x) + abs(_274);
    _274 = max(_274, 9.9999997473787516355514526367188e-05f);
    _23.x = max(_274, vs_TEXCOORD3.x);
    _9.z = _23.x + _9.x;
    float2 _339 = _9.xz / _274.xx;
    _9 = float4(_339.x, _9.y, _339.y, _9.w);
    _274 = vs_TEXCOORD3.x / _274;
    _274 = clamp(_274, 0.0f, 1.0f);
    float2 _352 = (-_9.xz) + 0.5f.xx;
    _9 = float4(_352.x, _9.y, _352.y, _9.w);
    float2 _359 = clamp(_9.xz, 0.0f.xx, 1.0f.xx);
    _9 = float4(_359.x, _9.y, _359.y, _9.w);
    _23.x = (-_9.z) + _9.x;
    _274 *= _23.x;
    float3 _379 = vs_TEXCOORD1.www * vs_TEXCOORD1.xyz;
    _373 = float4(_379.x, _379.y, _379.z, _373.w);
    _373.w = vs_TEXCOORD1.w;
    _135 = _274.xxxx * _373;
    _389 = ((-_373.w) * _274) + 1.0f;
    float3 _401 = vs_TEXCOORD2.www * vs_TEXCOORD2.xyz;
    _373 = float4(_401.x, _401.y, _401.z, _373.w);
    _373.w = vs_TEXCOORD2.w;
    _9 = _9.xxxx * _373;
    _411 = (_9 * _389.xxxx) + _135;
    float3 _423 = _411.xyz * _420.xyz;
    _411 = float4(_423.x, _423.y, _423.z, _411.w);
    _427 = _411 * _420.wwww;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    _420 = stage_input._420;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._427 = _427;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}