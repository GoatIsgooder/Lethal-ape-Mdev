// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Pumpkin/Soft Smoke" {
Properties {

_MainTex ("Smoke Atlas (R light, A density)", 2D) = "white" { }

_ShadowTint ("Shadow Tint", Color) = (0.42,0.44,0.5,1)

_LightBoost ("Light Boost", Range(0.5, 2)) = 1.149999976158142

_Softness ("Edge Softness", Range(0.05, 1)) = 0.44999998807907104

_Opacity ("Opacity", Range(0, 1)) = 0.8999999761581421

_HeatColor ("Heat Glow", Color) = (1,0.45,0.08,1)

_NearFade ("Near Camera Fade (m)", Range(0, 2)) = 0.6000000238418579

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
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
float _NearFade;
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
#define _21_m6 _NearFade



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float4 _146;
static float4 _147;
static float3 vs_TEXCOORD0;
static float4 _151;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _147 : COLOR;
    float4 _151 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _146 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _170;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    float3 _58 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _82 = _44.yyyy * _21_m3[1];
    _82 = (_21_m3[0] * _44.xxxx) + _82;
    _82 = (_21_m3[2] * _44.zzzz) + _82;
    _44 = (_21_m3[3] * _44.wwww) + _82;
    gl_Position = _44;
    _117 = _44.z / _21_m1.y;
    _117 = (-_117) + 1.0f;
    _117 *= _21_m1.z;
    _117 = max(_117, 0.0f);
    _117 *= _21_m4.y;
    vs_TEXCOORD2 = exp2(-_117);
    _146 = _147;
    float2 _163 = (_151.xy * _21_m5.xy) + _21_m5.zw;
    vs_TEXCOORD0 = float3(_163.x, _163.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = _151.z;
    _170 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _170;
    _9.x += (-0.3499999940395355224609375f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _151 = stage_input._151;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._146 = _146;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _ShadowTint;
float _LightBoost;
float _Softness;
float _Opacity;
float4 _HeatColor;
#define _33_m0 unity_FogColor
#define _33_m1 _ShadowTint
#define _33_m2 _LightBoost
#define _33_m3 _Softness
#define _33_m4 _Opacity
#define _33_m5 _HeatColor


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float4 _84;
static float vs_TEXCOORD2;
static float4 _117;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _84 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _117 : SV_Target0;
};

static float4 _9;
static float3 _28;
static float2 _43;
static float _53;
static float3 _63;
static float _100;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.z;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _28 = _9.xxx * _33_m5.xyz;
    _43 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xw;
    _53 = _43.y + 0.4000000059604644775390625f;
    _28 = _53.xxx * _28;
    _63 = (-_33_m1.xyz) + _33_m2.xxx;
    _63 = (_43.xxx * _63) + _33_m1.xyz;
    _28 = (_84.xyz * _63) + _28;
    float3 _97 = _28 + (-_33_m0.xyz);
    _9 = float4(_97.x, _9.y, _97.y, _97.z);
    _100 = vs_TEXCOORD2;
    _100 = clamp(_100, 0.0f, 1.0f);
    float3 _113 = (_100.xxx * _9.xzw) + _33_m0.xyz;
    _9 = float4(_113.x, _9.y, _113.y, _113.z);
    _117 = float4(_9.xzw.x, _9.xzw.y, _9.xzw.z, _117.w);
    _28.x = (-_84.w) + 1.0f;
    _28.x = ((-_28.x) * 0.85000002384185791015625f) + _43.y;
    _28.x /= _33_m3;
    _28.x = clamp(_28.x, 0.0f, 1.0f);
    _28.x *= _33_m4;
    _117.w = _28.x * vs_TEXCOORD1;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _84 = stage_input._84;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._117 = _117;
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
float _NearFade;
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
#define _21_m6 _NearFade



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float4 _149;
static float4 _150;
static float3 vs_TEXCOORD0;
static float4 _154;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : COLOR;
    float4 _154 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _149 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _173;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    float3 _58 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _82 = _44.yyyy * _21_m3[1];
    _82 = (_21_m3[0] * _44.xxxx) + _82;
    _82 = (_21_m3[2] * _44.zzzz) + _82;
    _44 = (_21_m3[3] * _44.wwww) + _82;
    gl_Position = _44;
    _117 = _44.z / _21_m1.y;
    _117 = (-_117) + 1.0f;
    _117 *= _21_m1.z;
    _117 = max(_117, 0.0f);
    _117 *= _21_m4.x;
    _117 *= (-_117);
    vs_TEXCOORD2 = exp2(_117);
    _149 = _150;
    float2 _166 = (_154.xy * _21_m5.xy) + _21_m5.zw;
    vs_TEXCOORD0 = float3(_166.x, _166.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = _154.z;
    _173 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _173;
    _9.x += (-0.3499999940395355224609375f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _150 = stage_input._150;
    _154 = stage_input._154;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._149 = _149;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _ShadowTint;
float _LightBoost;
float _Softness;
float _Opacity;
float4 _HeatColor;
#define _33_m0 unity_FogColor
#define _33_m1 _ShadowTint
#define _33_m2 _LightBoost
#define _33_m3 _Softness
#define _33_m4 _Opacity
#define _33_m5 _HeatColor


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float4 _84;
static float vs_TEXCOORD2;
static float4 _117;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _84 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _117 : SV_Target0;
};

static float4 _9;
static float3 _28;
static float2 _43;
static float _53;
static float3 _63;
static float _100;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.z;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _28 = _9.xxx * _33_m5.xyz;
    _43 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xw;
    _53 = _43.y + 0.4000000059604644775390625f;
    _28 = _53.xxx * _28;
    _63 = (-_33_m1.xyz) + _33_m2.xxx;
    _63 = (_43.xxx * _63) + _33_m1.xyz;
    _28 = (_84.xyz * _63) + _28;
    float3 _97 = _28 + (-_33_m0.xyz);
    _9 = float4(_97.x, _9.y, _97.y, _97.z);
    _100 = vs_TEXCOORD2;
    _100 = clamp(_100, 0.0f, 1.0f);
    float3 _113 = (_100.xxx * _9.xzw) + _33_m0.xyz;
    _9 = float4(_113.x, _9.y, _113.y, _113.z);
    _117 = float4(_9.xzw.x, _9.xzw.y, _9.xzw.z, _117.w);
    _28.x = (-_84.w) + 1.0f;
    _28.x = ((-_28.x) * 0.85000002384185791015625f) + _43.y;
    _28.x /= _33_m3;
    _28.x = clamp(_28.x, 0.0f, 1.0f);
    _28.x *= _33_m4;
    _117.w = _28.x * vs_TEXCOORD1;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _84 = stage_input._84;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._117 = _117;
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
float _NearFade;
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
#define _21_m6 _NearFade



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float4 _147;
static float4 _148;
static float3 vs_TEXCOORD0;
static float4 _152;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _148 : COLOR;
    float4 _152 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _147 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _171;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    float3 _58 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _82 = _44.yyyy * _21_m3[1];
    _82 = (_21_m3[0] * _44.xxxx) + _82;
    _82 = (_21_m3[2] * _44.zzzz) + _82;
    _44 = (_21_m3[3] * _44.wwww) + _82;
    gl_Position = _44;
    _117 = _44.z / _21_m1.y;
    _117 = (-_117) + 1.0f;
    _117 *= _21_m1.z;
    _117 = max(_117, 0.0f);
    vs_TEXCOORD2 = (_117 * _21_m4.z) + _21_m4.w;
    _147 = _148;
    float2 _164 = (_152.xy * _21_m5.xy) + _21_m5.zw;
    vs_TEXCOORD0 = float3(_164.x, _164.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = _152.z;
    _171 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _171;
    _9.x += (-0.3499999940395355224609375f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _148 = stage_input._148;
    _152 = stage_input._152;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output._147 = _147;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _ShadowTint;
float _LightBoost;
float _Softness;
float _Opacity;
float4 _HeatColor;
#define _33_m0 unity_FogColor
#define _33_m1 _ShadowTint
#define _33_m2 _LightBoost
#define _33_m3 _Softness
#define _33_m4 _Opacity
#define _33_m5 _HeatColor


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float4 _84;
static float vs_TEXCOORD2;
static float4 _117;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _84 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _117 : SV_Target0;
};

static float4 _9;
static float3 _28;
static float2 _43;
static float _53;
static float3 _63;
static float _100;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.z;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _28 = _9.xxx * _33_m5.xyz;
    _43 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xw;
    _53 = _43.y + 0.4000000059604644775390625f;
    _28 = _53.xxx * _28;
    _63 = (-_33_m1.xyz) + _33_m2.xxx;
    _63 = (_43.xxx * _63) + _33_m1.xyz;
    _28 = (_84.xyz * _63) + _28;
    float3 _97 = _28 + (-_33_m0.xyz);
    _9 = float4(_97.x, _9.y, _97.y, _97.z);
    _100 = vs_TEXCOORD2;
    _100 = clamp(_100, 0.0f, 1.0f);
    float3 _113 = (_100.xxx * _9.xzw) + _33_m0.xyz;
    _9 = float4(_113.x, _9.y, _113.y, _113.z);
    _117 = float4(_9.xzw.x, _9.xzw.y, _9.xzw.z, _117.w);
    _28.x = (-_84.w) + 1.0f;
    _28.x = ((-_28.x) * 0.85000002384185791015625f) + _43.y;
    _28.x /= _33_m3;
    _28.x = clamp(_28.x, 0.0f, 1.0f);
    _28.x *= _33_m4;
    _117.w = _28.x * vs_TEXCOORD1;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _84 = stage_input._84;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._117 = _117;
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
float _NearFade;
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
#define _21_m4 _NearFade



static float4 gl_Position;
static float4 _11;
static float4 _116;
static float4 _117;
static float3 vs_TEXCOORD0;
static float4 _121;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _117 : COLOR;
    float4 _121 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _116 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _141;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    float3 _58 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _82 = _44.yyyy * _21_m2[1];
    _82 = (_21_m2[0] * _44.xxxx) + _82;
    _82 = (_21_m2[2] * _44.zzzz) + _82;
    gl_Position = (_21_m2[3] * _44.wwww) + _82;
    _116 = _117;
    float2 _132 = (_121.xy * _21_m3.xy) + _21_m3.zw;
    vs_TEXCOORD0 = float3(_132.x, _132.y, vs_TEXCOORD0.z);
    vs_TEXCOORD0.z = _121.z;
    _141 = max(_21_m4, 0.001000000047497451305389404296875f);
    _9.x /= _141;
    _9.x += (-0.3499999940395355224609375f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _117 = stage_input._117;
    _121 = stage_input._121;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._116 = _116;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _ShadowTint;
float _LightBoost;
float _Softness;
float _Opacity;
float4 _HeatColor;
#define _28_m0 _ShadowTint
#define _28_m1 _LightBoost
#define _28_m2 _Softness
#define _28_m3 _Opacity
#define _28_m4 _HeatColor


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float3 vs_TEXCOORD0;
static float4 _79;
static float4 _81;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _81 : TEXCOORD0;
    float3 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _79 : SV_Target0;
};

static float _8;
static float3 _22;
static float2 _38;
static float _48;
static float3 _58;

void frag_inner()
{
    _8 = vs_TEXCOORD0.z;
    _8 = clamp(_8, 0.0f, 1.0f);
    _22 = _8.xxx * _28_m4.xyz;
    _38 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).xw;
    _48 = _38.y + 0.4000000059604644775390625f;
    _22 = _48.xxx * _22;
    _58 = (-_28_m0.xyz) + _28_m1.xxx;
    _58 = (_38.xxx * _58) + _28_m0.xyz;
    float3 _87 = (_81.xyz * _58) + _22;
    _79 = float4(_87.x, _87.y, _87.z, _79.w);
    _22.x = (-_81.w) + 1.0f;
    _22.x = ((-_22.x) * 0.85000002384185791015625f) + _38.y;
    _22.x /= _28_m2;
    _22.x = clamp(_22.x, 0.0f, 1.0f);
    _22.x *= _28_m3;
    _79.w = _22.x * vs_TEXCOORD1;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _81 = stage_input._81;
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