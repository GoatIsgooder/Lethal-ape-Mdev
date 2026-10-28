// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MenuButton" {
Properties {

_MainTex ("Button Sheet", 2D) = "white" { }

_Color ("Tint", Color) = (1,1,1,1)

_LightInfluence ("Scene Light Influence", Range(0, 1)) = 0.3499999940395355

_PressDarken ("Pressed Darken", Range(0, 1)) = 0.2199999988079071

_Press ("Press", Range(0, 1)) = 0.0

}
SubShader {
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m9[4];
float4x4 unity_WorldToObject;
static float4 _21_m10[4];
float4x4 unity_MatrixVP;
static float4 _21_m11[4];
float4 unity_FogParams;
float4 _LightColor0;
float4 _MainTex_ST;
float _LightInfluence;
float _PressDarken;
float _Press;
void __unity_init()
{
    _21_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 _WorldSpaceLightPos0
#define _21_m2 unity_SHAr
#define _21_m3 unity_SHAg
#define _21_m4 unity_SHAb
#define _21_m5 unity_SHBr
#define _21_m6 unity_SHBg
#define _21_m7 unity_SHBb
#define _21_m8 unity_SHC
#define _21_m12 unity_FogParams
#define _21_m13 _LightColor0
#define _21_m14 _MainTex_ST
#define _21_m15 _LightInfluence
#define _21_m16 _PressDarken
#define _21_m17 _Press



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _130;
static float3 _143;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
    float2 _130 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;
static float _163;
static float3 _177;
static float4 _194;
static float3 _200;
static float _228;
static float _287;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m9[1];
    _9 = (_21_m9[0] * _11.xxxx) + _9;
    _9 = (_21_m9[2] * _11.zzzz) + _9;
    _9 += _21_m9[3];
    _50 = _9.yyyy * _21_m11[1];
    _50 = (_21_m11[0] * _9.xxxx) + _50;
    _50 = (_21_m11[2] * _9.zzzz) + _50;
    _9 = (_21_m11[3] * _9.wwww) + _50;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m12.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    vs_TEXCOORD0 = (_130 * _21_m14.xy) + _21_m14.zw;
    _9.x = dot(_143, _21_m10[0].xyz);
    _9.y = dot(_143, _21_m10[1].xyz);
    _9.z = dot(_143, _21_m10[2].xyz);
    _163 = dot(_9.xyz, _9.xyz);
    _163 = rsqrt(_163);
    _9 = _163.xxxx * _9.xyzz;
    _177.x = _9.y * _9.y;
    _177.x = (_9.x * _9.x) + (-_177.x);
    _194 = _9.yzwx * _9.xywz;
    _200.x = dot(_21_m5, _194);
    _200.y = dot(_21_m6, _194);
    _200.z = dot(_21_m7, _194);
    _177 = (_21_m8.xyz * _177.xxx) + _200;
    _228 = dot(_9.xyz, _21_m1.xyz);
    _228 = (_228 * 0.5f) + 0.5f;
    _228 = clamp(_228, 0.0f, 1.0f);
    _9.w = 1.0f;
    _200.x = dot(_21_m2, _9);
    _200.y = dot(_21_m3, _9);
    _200.z = dot(_21_m4, _9);
    _177 += _200;
    _177 = (_21_m13.xyz * _228.xxx) + _177;
    _177 = clamp(_177, 0.0f.xxx, 1.0f.xxx);
    _177 += (-1.0f).xxx;
    _177 = (_21_m15.xxx * _177) + 1.0f.xxx;
    _287 = ((-_21_m17) * _21_m16) + 1.0f;
    vs_TEXCOORD1 = _287.xxx * _177;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _Color;
#define _33_m0 unity_FogColor
#define _33_m1 _Color


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _66;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _66 : SV_Target0;
};

static float _8;
static float4 _18;
static float4 _29;
static float3 _42;

void frag_inner()
{
    _8 = vs_TEXCOORD2;
    _8 = clamp(_8, 0.0f, 1.0f);
    _18 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _29 = _18 * _33_m1;
    _42 = (_29.xyz * vs_TEXCOORD1) + (-_33_m0.xyz);
    float3 _62 = (_8.xxx * _42) + _33_m0.xyz;
    _29 = float4(_62.x, _62.y, _62.z, _29.w);
    _66 = _29;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._66 = _66;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m9[4];
float4x4 unity_WorldToObject;
static float4 _21_m10[4];
float4x4 unity_MatrixVP;
static float4 _21_m11[4];
float4 unity_FogParams;
float4 _LightColor0;
float4 _MainTex_ST;
float _LightInfluence;
float _PressDarken;
float _Press;
void __unity_init()
{
    _21_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 _WorldSpaceLightPos0
#define _21_m2 unity_SHAr
#define _21_m3 unity_SHAg
#define _21_m4 unity_SHAb
#define _21_m5 unity_SHBr
#define _21_m6 unity_SHBg
#define _21_m7 unity_SHBb
#define _21_m8 unity_SHC
#define _21_m12 unity_FogParams
#define _21_m13 _LightColor0
#define _21_m14 _MainTex_ST
#define _21_m15 _LightInfluence
#define _21_m16 _PressDarken
#define _21_m17 _Press



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _136;
static float3 _149;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _149 : NORMAL;
    float2 _136 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;
static float _169;
static float3 _183;
static float4 _200;
static float3 _206;
static float _234;
static float _293;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m9[1];
    _9 = (_21_m9[0] * _11.xxxx) + _9;
    _9 = (_21_m9[2] * _11.zzzz) + _9;
    _9 += _21_m9[3];
    _50 = _9.yyyy * _21_m11[1];
    _50 = (_21_m11[0] * _9.xxxx) + _50;
    _50 = (_21_m11[2] * _9.zzzz) + _50;
    _9 = (_21_m11[3] * _9.wwww) + _50;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m12.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    vs_TEXCOORD0 = (_136 * _21_m14.xy) + _21_m14.zw;
    _9.x = dot(_149, _21_m10[0].xyz);
    _9.y = dot(_149, _21_m10[1].xyz);
    _9.z = dot(_149, _21_m10[2].xyz);
    _169 = dot(_9.xyz, _9.xyz);
    _169 = rsqrt(_169);
    _9 = _169.xxxx * _9.xyzz;
    _183.x = _9.y * _9.y;
    _183.x = (_9.x * _9.x) + (-_183.x);
    _200 = _9.yzwx * _9.xywz;
    _206.x = dot(_21_m5, _200);
    _206.y = dot(_21_m6, _200);
    _206.z = dot(_21_m7, _200);
    _183 = (_21_m8.xyz * _183.xxx) + _206;
    _234 = dot(_9.xyz, _21_m1.xyz);
    _234 = (_234 * 0.5f) + 0.5f;
    _234 = clamp(_234, 0.0f, 1.0f);
    _9.w = 1.0f;
    _206.x = dot(_21_m2, _9);
    _206.y = dot(_21_m3, _9);
    _206.z = dot(_21_m4, _9);
    _183 += _206;
    _183 = (_21_m13.xyz * _234.xxx) + _183;
    _183 = clamp(_183, 0.0f.xxx, 1.0f.xxx);
    _183 += (-1.0f).xxx;
    _183 = (_21_m15.xxx * _183) + 1.0f.xxx;
    _293 = ((-_21_m17) * _21_m16) + 1.0f;
    vs_TEXCOORD1 = _293.xxx * _183;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _149 = stage_input._149;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _Color;
#define _33_m0 unity_FogColor
#define _33_m1 _Color


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _66;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _66 : SV_Target0;
};

static float _8;
static float4 _18;
static float4 _29;
static float3 _42;

void frag_inner()
{
    _8 = vs_TEXCOORD2;
    _8 = clamp(_8, 0.0f, 1.0f);
    _18 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _29 = _18 * _33_m1;
    _42 = (_29.xyz * vs_TEXCOORD1) + (-_33_m0.xyz);
    float3 _62 = (_8.xxx * _42) + _33_m0.xyz;
    _29 = float4(_62.x, _62.y, _62.z, _29.w);
    _66 = _29;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._66 = _66;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m9[4];
float4x4 unity_WorldToObject;
static float4 _21_m10[4];
float4x4 unity_MatrixVP;
static float4 _21_m11[4];
float4 unity_FogParams;
float4 _LightColor0;
float4 _MainTex_ST;
float _LightInfluence;
float _PressDarken;
float _Press;
void __unity_init()
{
    _21_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 _WorldSpaceLightPos0
#define _21_m2 unity_SHAr
#define _21_m3 unity_SHAg
#define _21_m4 unity_SHAb
#define _21_m5 unity_SHBr
#define _21_m6 unity_SHBg
#define _21_m7 unity_SHBb
#define _21_m8 unity_SHC
#define _21_m12 unity_FogParams
#define _21_m13 _LightColor0
#define _21_m14 _MainTex_ST
#define _21_m15 _LightInfluence
#define _21_m16 _PressDarken
#define _21_m17 _Press



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _129;
static float3 _142;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _142 : NORMAL;
    float2 _129 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;
static float _162;
static float3 _176;
static float4 _193;
static float3 _199;
static float _227;
static float _285;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m9[1];
    _9 = (_21_m9[0] * _11.xxxx) + _9;
    _9 = (_21_m9[2] * _11.zzzz) + _9;
    _9 += _21_m9[3];
    _50 = _9.yyyy * _21_m11[1];
    _50 = (_21_m11[0] * _9.xxxx) + _50;
    _50 = (_21_m11[2] * _9.zzzz) + _50;
    _9 = (_21_m11[3] * _9.wwww) + _50;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _21_m12.z) + _21_m12.w;
    vs_TEXCOORD0 = (_129 * _21_m14.xy) + _21_m14.zw;
    _9.x = dot(_142, _21_m10[0].xyz);
    _9.y = dot(_142, _21_m10[1].xyz);
    _9.z = dot(_142, _21_m10[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    _9 = _162.xxxx * _9.xyzz;
    _176.x = _9.y * _9.y;
    _176.x = (_9.x * _9.x) + (-_176.x);
    _193 = _9.yzwx * _9.xywz;
    _199.x = dot(_21_m5, _193);
    _199.y = dot(_21_m6, _193);
    _199.z = dot(_21_m7, _193);
    _176 = (_21_m8.xyz * _176.xxx) + _199;
    _227 = dot(_9.xyz, _21_m1.xyz);
    _227 = (_227 * 0.5f) + 0.5f;
    _227 = clamp(_227, 0.0f, 1.0f);
    _9.w = 1.0f;
    _199.x = dot(_21_m2, _9);
    _199.y = dot(_21_m3, _9);
    _199.z = dot(_21_m4, _9);
    _176 += _199;
    _176 = (_21_m13.xyz * _227.xxx) + _176;
    _176 = clamp(_176, 0.0f.xxx, 1.0f.xxx);
    _176 += (-1.0f).xxx;
    _176 = (_21_m15.xxx * _176) + 1.0f.xxx;
    _285 = ((-_21_m17) * _21_m16) + 1.0f;
    vs_TEXCOORD1 = _285.xxx * _176;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _129 = stage_input._129;
    _142 = stage_input._142;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _Color;
#define _33_m0 unity_FogColor
#define _33_m1 _Color


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _66;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _66 : SV_Target0;
};

static float _8;
static float4 _18;
static float4 _29;
static float3 _42;

void frag_inner()
{
    _8 = vs_TEXCOORD2;
    _8 = clamp(_8, 0.0f, 1.0f);
    _18 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _29 = _18 * _33_m1;
    _42 = (_29.xyz * vs_TEXCOORD1) + (-_33_m0.xyz);
    float3 _62 = (_8.xxx * _42) + _33_m0.xyz;
    _29 = float4(_62.x, _62.y, _62.z, _29.w);
    _66 = _29;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._66 = _66;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_WorldToObject;
static float4 _21_m9[4];
float4x4 unity_MatrixVP;
static float4 _21_m10[4];
float4 _LightColor0;
float4 _MainTex_ST;
float _LightInfluence;
float _PressDarken;
float _Press;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceLightPos0
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m11 _LightColor0
#define _21_m12 _MainTex_ST
#define _21_m13 _LightInfluence
#define _21_m14 _PressDarken
#define _21_m15 _Press



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _89;
static float3 _102;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _102 : NORMAL;
    float2 _89 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;
static float _125;
static float3 _139;
static float4 _156;
static float3 _162;
static float _190;
static float _251;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _9 += _21_m8[3];
    _50 = _9.yyyy * _21_m10[1];
    _50 = (_21_m10[0] * _9.xxxx) + _50;
    _50 = (_21_m10[2] * _9.zzzz) + _50;
    gl_Position = (_21_m10[3] * _9.wwww) + _50;
    vs_TEXCOORD0 = (_89 * _21_m12.xy) + _21_m12.zw;
    _9.x = dot(_102, _21_m9[0].xyz);
    _9.y = dot(_102, _21_m9[1].xyz);
    _9.z = dot(_102, _21_m9[2].xyz);
    _125 = dot(_9.xyz, _9.xyz);
    _125 = rsqrt(_125);
    _9 = _125.xxxx * _9.xyzz;
    _139.x = _9.y * _9.y;
    _139.x = (_9.x * _9.x) + (-_139.x);
    _156 = _9.yzwx * _9.xywz;
    _162.x = dot(_21_m4, _156);
    _162.y = dot(_21_m5, _156);
    _162.z = dot(_21_m6, _156);
    _139 = (_21_m7.xyz * _139.xxx) + _162;
    _190 = dot(_9.xyz, _21_m0.xyz);
    _190 = (_190 * 0.5f) + 0.5f;
    _190 = clamp(_190, 0.0f, 1.0f);
    _9.w = 1.0f;
    _162.x = dot(_21_m1, _9);
    _162.y = dot(_21_m2, _9);
    _162.z = dot(_21_m3, _9);
    _139 += _162;
    _139 = (_21_m11.xyz * _190.xxx) + _139;
    _139 = clamp(_139, 0.0f.xxx, 1.0f.xxx);
    _139 += (-1.0f).xxx;
    _139 = (_21_m13.xxx * _139) + 1.0f.xxx;
    _251 = ((-_21_m15) * _21_m14) + 1.0f;
    vs_TEXCOORD1 = _251.xxx * _139;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _89 = stage_input._89;
    _102 = stage_input._102;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
#define _24_m0 _Color


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _32;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _32 : SV_Target0;
};

static float4 _9;
static float4 _20;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20 = _9 * _24_m0;
    float3 _39 = _20.xyz * vs_TEXCOORD1;
    _32 = float4(_39.x, _39.y, _39.z, _32.w);
    _32.w = _20.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._32 = _32;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}