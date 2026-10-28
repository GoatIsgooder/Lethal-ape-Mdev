// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Pumpkin/Fire" {
Properties {

_MainTex ("Heat Atlas (R)", 2D) = "white" { }

_Cool ("Cool", Color) = (0.35,0.04,0,1)

_Warm ("Warm", Color) = (1,0.32,0.03,1)

_Hot ("Hot", Color) = (1,0.72,0.2,1)

_Core ("Core", Color) = (1,0.97,0.8,1)

_Intensity ("Intensity", Range(0, 4)) = 1.399999976158142

_Occlusion ("Rim Occlusion", Range(0, 1)) = 0.25

_EdgeSoftness ("Edge Softness", Range(0.02, 0.5)) = 0.11999999731779099

_NearFade ("Near Camera Fade (m)", Range(0, 2)) = 0.4000000059604645

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One OneMinusSrcAlpha
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
static float2 vs_TEXCOORD0;
static float2 _153;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _147 : COLOR;
    float2 _153 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _146 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _164;

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
    vs_TEXCOORD0 = (_153 * _21_m5.xy) + _21_m5.zw;
    _164 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _164;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _153 = stage_input._153;
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
float4 _Cool;
float4 _Warm;
float4 _Hot;
float4 _Core;
float _Intensity;
float _Occlusion;
float _EdgeSoftness;
#define _71_m0 _Cool
#define _71_m1 _Warm
#define _71_m2 _Hot
#define _71_m3 _Core
#define _71_m4 _Intensity
#define _71_m5 _Occlusion
#define _71_m6 _EdgeSoftness


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 _12;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _152;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _12 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _152 : SV_Target0;
};

static float3 _9;
static float3 _24;
static float _37;
static float _101;
static float3 _108;
static float3 _128;
static float2 _137;
static float3 _200;

void frag_inner()
{
    _9.x = (-_12.w) + 1.0f;
    _24.x = ((-_9.x) * 0.75f) + 1.0f;
    _24.x = max(_24.x, 0.001000000047497451305389404296875f);
    _37 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).x;
    _9.x = ((-_9.x) * 0.75f) + _37;
    _24.x = _9.x / _24.x;
    _24.x = clamp(_24.x, 0.0f, 1.0f);
    _9.x /= _71_m6;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= vs_TEXCOORD1;
    float2 _98 = _9.xx * float2(_71_m4, _71_m5);
    _9 = float3(_98.x, _9.y, _98.y);
    _101 = _24.x * 3.0f;
    _101 = min(_101, 1.0f);
    _108 = (-_71_m0.xyz) + _71_m1.xyz;
    _108 = (_101.xxx * _108) + _71_m0.xyz;
    _128 = (-_108) + _71_m2.xyz;
    _137 = (_24.xx * 3.0f.xx) + float2(-1.0f, -2.0f);
    _24.x = (-_24.x) + 1.0f;
    _152.w = _24.x * _9.z;
    _137.x = _137.x;
    _137.x = clamp(_137.x, 0.0f, 1.0f);
    _24.x = max(_137.y, 0.0f);
    _108 = (_137.xxx * _128) + _108;
    _128 = (-_108) + _71_m3.xyz;
    _24 = (_24.xxx * _128) + _108;
    _24 *= _12.xyz;
    _9 = _9.xxx * _24;
    _200.x = vs_TEXCOORD2;
    _200.x = clamp(_200.x, 0.0f, 1.0f);
    _200 = _9 * _200.xxx;
    _152 = float4(_200.x, _200.y, _200.z, _152.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._152 = _152;
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
static float2 vs_TEXCOORD0;
static float2 _156;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : COLOR;
    float2 _156 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _149 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _167;

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
    vs_TEXCOORD0 = (_156 * _21_m5.xy) + _21_m5.zw;
    _167 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _167;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _150 = stage_input._150;
    _156 = stage_input._156;
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
float4 _Cool;
float4 _Warm;
float4 _Hot;
float4 _Core;
float _Intensity;
float _Occlusion;
float _EdgeSoftness;
#define _71_m0 _Cool
#define _71_m1 _Warm
#define _71_m2 _Hot
#define _71_m3 _Core
#define _71_m4 _Intensity
#define _71_m5 _Occlusion
#define _71_m6 _EdgeSoftness


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 _12;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _152;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _12 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _152 : SV_Target0;
};

static float3 _9;
static float3 _24;
static float _37;
static float _101;
static float3 _108;
static float3 _128;
static float2 _137;
static float3 _200;

void frag_inner()
{
    _9.x = (-_12.w) + 1.0f;
    _24.x = ((-_9.x) * 0.75f) + 1.0f;
    _24.x = max(_24.x, 0.001000000047497451305389404296875f);
    _37 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).x;
    _9.x = ((-_9.x) * 0.75f) + _37;
    _24.x = _9.x / _24.x;
    _24.x = clamp(_24.x, 0.0f, 1.0f);
    _9.x /= _71_m6;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= vs_TEXCOORD1;
    float2 _98 = _9.xx * float2(_71_m4, _71_m5);
    _9 = float3(_98.x, _9.y, _98.y);
    _101 = _24.x * 3.0f;
    _101 = min(_101, 1.0f);
    _108 = (-_71_m0.xyz) + _71_m1.xyz;
    _108 = (_101.xxx * _108) + _71_m0.xyz;
    _128 = (-_108) + _71_m2.xyz;
    _137 = (_24.xx * 3.0f.xx) + float2(-1.0f, -2.0f);
    _24.x = (-_24.x) + 1.0f;
    _152.w = _24.x * _9.z;
    _137.x = _137.x;
    _137.x = clamp(_137.x, 0.0f, 1.0f);
    _24.x = max(_137.y, 0.0f);
    _108 = (_137.xxx * _128) + _108;
    _128 = (-_108) + _71_m3.xyz;
    _24 = (_24.xxx * _128) + _108;
    _24 *= _12.xyz;
    _9 = _9.xxx * _24;
    _200.x = vs_TEXCOORD2;
    _200.x = clamp(_200.x, 0.0f, 1.0f);
    _200 = _9 * _200.xxx;
    _152 = float4(_200.x, _200.y, _200.z, _152.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._152 = _152;
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
static float2 vs_TEXCOORD0;
static float2 _154;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _148 : COLOR;
    float2 _154 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _147 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _165;

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
    vs_TEXCOORD0 = (_154 * _21_m5.xy) + _21_m5.zw;
    _165 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _165;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _148 = stage_input._148;
    _154 = stage_input._154;
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
float4 _Cool;
float4 _Warm;
float4 _Hot;
float4 _Core;
float _Intensity;
float _Occlusion;
float _EdgeSoftness;
#define _71_m0 _Cool
#define _71_m1 _Warm
#define _71_m2 _Hot
#define _71_m3 _Core
#define _71_m4 _Intensity
#define _71_m5 _Occlusion
#define _71_m6 _EdgeSoftness


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 _12;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _152;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _12 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _152 : SV_Target0;
};

static float3 _9;
static float3 _24;
static float _37;
static float _101;
static float3 _108;
static float3 _128;
static float2 _137;
static float3 _200;

void frag_inner()
{
    _9.x = (-_12.w) + 1.0f;
    _24.x = ((-_9.x) * 0.75f) + 1.0f;
    _24.x = max(_24.x, 0.001000000047497451305389404296875f);
    _37 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).x;
    _9.x = ((-_9.x) * 0.75f) + _37;
    _24.x = _9.x / _24.x;
    _24.x = clamp(_24.x, 0.0f, 1.0f);
    _9.x /= _71_m6;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= vs_TEXCOORD1;
    float2 _98 = _9.xx * float2(_71_m4, _71_m5);
    _9 = float3(_98.x, _9.y, _98.y);
    _101 = _24.x * 3.0f;
    _101 = min(_101, 1.0f);
    _108 = (-_71_m0.xyz) + _71_m1.xyz;
    _108 = (_101.xxx * _108) + _71_m0.xyz;
    _128 = (-_108) + _71_m2.xyz;
    _137 = (_24.xx * 3.0f.xx) + float2(-1.0f, -2.0f);
    _24.x = (-_24.x) + 1.0f;
    _152.w = _24.x * _9.z;
    _137.x = _137.x;
    _137.x = clamp(_137.x, 0.0f, 1.0f);
    _24.x = max(_137.y, 0.0f);
    _108 = (_137.xxx * _128) + _108;
    _128 = (-_108) + _71_m3.xyz;
    _24 = (_24.xxx * _128) + _108;
    _24 *= _12.xyz;
    _9 = _9.xxx * _24;
    _200.x = vs_TEXCOORD2;
    _200.x = clamp(_200.x, 0.0f, 1.0f);
    _200 = _9 * _200.xxx;
    _152 = float4(_200.x, _200.y, _200.z, _152.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._152 = _152;
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
static float2 vs_TEXCOORD0;
static float2 _123;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _117 : COLOR;
    float2 _123 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _116 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _133;

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
    vs_TEXCOORD0 = (_123 * _21_m3.xy) + _21_m3.zw;
    _133 = max(_21_m4, 0.001000000047497451305389404296875f);
    _9.x /= _133;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _117 = stage_input._117;
    _123 = stage_input._123;
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
float4 _Cool;
float4 _Warm;
float4 _Hot;
float4 _Core;
float _Intensity;
float _Occlusion;
float _EdgeSoftness;
#define _71_m0 _Cool
#define _71_m1 _Warm
#define _71_m2 _Hot
#define _71_m3 _Core
#define _71_m4 _Intensity
#define _71_m5 _Occlusion
#define _71_m6 _EdgeSoftness


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 _12;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _152;

struct SPIRV_Cross_Input
{
    float4 _12 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _152 : SV_Target0;
};

static float3 _9;
static float3 _24;
static float _37;
static float _101;
static float3 _108;
static float3 _128;
static float2 _137;

void frag_inner()
{
    _9.x = (-_12.w) + 1.0f;
    _24.x = ((-_9.x) * 0.75f) + 1.0f;
    _24.x = max(_24.x, 0.001000000047497451305389404296875f);
    _37 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).x;
    _9.x = ((-_9.x) * 0.75f) + _37;
    _24.x = _9.x / _24.x;
    _24.x = clamp(_24.x, 0.0f, 1.0f);
    _9.x /= _71_m6;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= vs_TEXCOORD1;
    float2 _98 = _9.xx * float2(_71_m4, _71_m5);
    _9 = float3(_98.x, _9.y, _98.y);
    _101 = _24.x * 3.0f;
    _101 = min(_101, 1.0f);
    _108 = (-_71_m0.xyz) + _71_m1.xyz;
    _108 = (_101.xxx * _108) + _71_m0.xyz;
    _128 = (-_108) + _71_m2.xyz;
    _137 = (_24.xx * 3.0f.xx) + float2(-1.0f, -2.0f);
    _24.x = (-_24.x) + 1.0f;
    _152.w = _24.x * _9.z;
    _137.x = _137.x;
    _137.x = clamp(_137.x, 0.0f, 1.0f);
    _24.x = max(_137.y, 0.0f);
    _108 = (_137.xxx * _128) + _108;
    _128 = (-_108) + _71_m3.xyz;
    _24 = (_24.xxx * _128) + _108;
    _24 *= _12.xyz;
    float3 _199 = _9.xxx * _24;
    _152 = float4(_199.x, _199.y, _199.z, _152.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._152 = _152;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}