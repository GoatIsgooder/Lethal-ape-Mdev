// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Pumpkin/Additive Flash" {
Properties {

_MainTex ("Mask Atlas (R)", 2D) = "white" { }

_Intensity ("Intensity", Range(0, 4)) = 1.2000000476837158

_CoreWhite ("Core White", Range(0, 2)) = 0.800000011920929

_NearFade ("Near Camera Fade (m)", Range(0, 2)) = 0.3499999940395355

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One One
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
static float vs_TEXCOORD1;
static float4 _166;
static float4 _169;
static float2 vs_TEXCOORD0;
static float2 _184;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _169 : COLOR;
    float2 _184 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _166 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _146;

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
    vs_TEXCOORD1 = exp2(-_117);
    _146 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _146;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _166.w = _9.x * _169.w;
    _166 = float4(_169.xyz.x, _169.xyz.y, _169.xyz.z, _166.w);
    vs_TEXCOORD0 = (_184 * _21_m5.xy) + _21_m5.zw;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _169 = stage_input._169;
    _184 = stage_input._184;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._166 = _166;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Intensity;
float _CoreWhite;
#define _54_m0 _Intensity
#define _54_m1 _CoreWhite


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _42;
static float vs_TEXCOORD1;
static float4 _96;

struct SPIRV_Cross_Input
{
    float4 _42 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _96 : SV_Target0;
};

static float _8;
static float3 _25;
static float3 _81;

void frag_inner()
{
    _8 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).x;
    _25.x = _8 * _8;
    _25.x = _8 * _25.x;
    _25.x = _8 * _25.x;
    _25.y = _8 * _42.w;
    float2 _64 = _25.xy * float2(_54_m1, _54_m0);
    _25 = float3(_64.x, _64.y, _25.z);
    _25.x *= _42.w;
    _25 = (_42.xyz * _25.yyy) + _25.xxx;
    _81.x = vs_TEXCOORD1;
    _81.x = clamp(_81.x, 0.0f, 1.0f);
    _81 = _25 * _81.xxx;
    _96 = float4(_81.x, _81.y, _81.z, _96.w);
    _96.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _42 = stage_input._42;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._96 = _96;
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
static float vs_TEXCOORD1;
static float4 _169;
static float4 _172;
static float2 vs_TEXCOORD0;
static float2 _187;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _172 : COLOR;
    float2 _187 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _169 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _149;

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
    vs_TEXCOORD1 = exp2(_117);
    _149 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _149;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _169.w = _9.x * _172.w;
    _169 = float4(_172.xyz.x, _172.xyz.y, _172.xyz.z, _169.w);
    vs_TEXCOORD0 = (_187 * _21_m5.xy) + _21_m5.zw;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _172 = stage_input._172;
    _187 = stage_input._187;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._169 = _169;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Intensity;
float _CoreWhite;
#define _54_m0 _Intensity
#define _54_m1 _CoreWhite


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _42;
static float vs_TEXCOORD1;
static float4 _96;

struct SPIRV_Cross_Input
{
    float4 _42 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _96 : SV_Target0;
};

static float _8;
static float3 _25;
static float3 _81;

void frag_inner()
{
    _8 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).x;
    _25.x = _8 * _8;
    _25.x = _8 * _25.x;
    _25.x = _8 * _25.x;
    _25.y = _8 * _42.w;
    float2 _64 = _25.xy * float2(_54_m1, _54_m0);
    _25 = float3(_64.x, _64.y, _25.z);
    _25.x *= _42.w;
    _25 = (_42.xyz * _25.yyy) + _25.xxx;
    _81.x = vs_TEXCOORD1;
    _81.x = clamp(_81.x, 0.0f, 1.0f);
    _81 = _25 * _81.xxx;
    _96 = float4(_81.x, _81.y, _81.z, _96.w);
    _96.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _42 = stage_input._42;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._96 = _96;
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
static float vs_TEXCOORD1;
static float4 _167;
static float4 _170;
static float2 vs_TEXCOORD0;
static float2 _184;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _170 : COLOR;
    float2 _184 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _167 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _147;

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
    vs_TEXCOORD1 = (_117 * _21_m4.z) + _21_m4.w;
    _147 = max(_21_m6, 0.001000000047497451305389404296875f);
    _9.x /= _147;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _167.w = _9.x * _170.w;
    _167 = float4(_170.xyz.x, _170.xyz.y, _170.xyz.z, _167.w);
    vs_TEXCOORD0 = (_184 * _21_m5.xy) + _21_m5.zw;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _170 = stage_input._170;
    _184 = stage_input._184;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._167 = _167;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Intensity;
float _CoreWhite;
#define _54_m0 _Intensity
#define _54_m1 _CoreWhite


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _42;
static float vs_TEXCOORD1;
static float4 _96;

struct SPIRV_Cross_Input
{
    float4 _42 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _96 : SV_Target0;
};

static float _8;
static float3 _25;
static float3 _81;

void frag_inner()
{
    _8 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).x;
    _25.x = _8 * _8;
    _25.x = _8 * _25.x;
    _25.x = _8 * _25.x;
    _25.y = _8 * _42.w;
    float2 _64 = _25.xy * float2(_54_m1, _54_m0);
    _25 = float3(_64.x, _64.y, _25.z);
    _25.x *= _42.w;
    _25 = (_42.xyz * _25.yyy) + _25.xxx;
    _81.x = vs_TEXCOORD1;
    _81.x = clamp(_81.x, 0.0f, 1.0f);
    _81 = _25 * _81.xxx;
    _96 = float4(_81.x, _81.y, _81.z, _96.w);
    _96.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _42 = stage_input._42;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._96 = _96;
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
static float4 _139;
static float4 _142;
static float2 vs_TEXCOORD0;
static float2 _158;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _142 : COLOR;
    float2 _158 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _139 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _116;

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
    _116 = max(_21_m4, 0.001000000047497451305389404296875f);
    _9.x /= _116;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _139.w = _9.x * _142.w;
    _139 = float4(_142.xyz.x, _142.xyz.y, _142.xyz.z, _139.w);
    vs_TEXCOORD0 = (_158 * _21_m3.xy) + _21_m3.zw;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _142 = stage_input._142;
    _158 = stage_input._158;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._139 = _139;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Intensity;
float _CoreWhite;
#define _52_m0 _Intensity
#define _52_m1 _CoreWhite


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _41;
static float4 _70;

struct SPIRV_Cross_Input
{
    float4 _41 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _70 : SV_Target0;
};

static float _8;
static float2 _24;

void frag_inner()
{
    _8 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0).x;
    _24.x = _8 * _8;
    _24.x = _8 * _24.x;
    _24.x = _8 * _24.x;
    _24.y = _8 * _41.w;
    _24 *= float2(_52_m1, _52_m0);
    _24.x *= _41.w;
    float3 _79 = (_41.xyz * _24.yyy) + _24.xxx;
    _70 = float4(_79.x, _79.y, _79.z, _70.w);
    _70.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _41 = stage_input._41;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._70 = _70;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}