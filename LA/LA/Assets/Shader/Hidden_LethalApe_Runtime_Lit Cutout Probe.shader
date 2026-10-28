// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Hidden/LethalApe/Runtime/Lit Cutout Probe" {
Properties {

_Color ("Colour", Color) = (1,1,1,1)

_MainTex ("Albedo (A = cutout)", 2D) = "white" { }

_Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5

[ToggleUI] _VertexColor ("Use Vertex Colours", Float) = 0.0

_EmissionColor ("Emission", Color) = (0,0,0,1)

_EmissionMap ("Emission Map", 2D) = "white" { }

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
 Pass {
ZWrite On
 Name "FORWARD"
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
 Cull Off
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
float4 _Color;
float _VertexColor;
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
#define _21_m15 _Color
#define _21_m16 _VertexColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _130;
static float3 _143;
static float3 vs_TEXCOORD1;
static float4 _270;
static float4 _283;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
    float2 _130 : TEXCOORD0;
    float4 _270 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 _283 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;
static float _163;
static float3 _177;
static float4 _194;
static float3 _200;
static float _228;
static float4 _269;

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
    _228 = clamp(_228, 0.0f, 1.0f);
    _9.w = 1.0f;
    _200.x = dot(_21_m2, _9);
    _200.y = dot(_21_m3, _9);
    _200.z = dot(_21_m4, _9);
    _177 += _200;
    vs_TEXCOORD1 = (_21_m13.xyz * _228.xxx) + _177;
    _269 = _270 + (-1.0f).xxxx;
    _269 = (_21_m16.xxxx * _269) + 1.0f.xxxx;
    _283 = _269 * _21_m15;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _143 = stage_input._143;
    _270 = stage_input._270;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._283 = _283;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _EmissionColor;
float _Cutoff;
#define _34_m0 unity_FogColor
#define _34_m1 _EmissionColor
#define _34_m2 _Cutoff


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;

static float2 vs_TEXCOORD0;
static float4 _27;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _108;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 _27 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _108 : SV_Target0;
};

static float4 _9;
static float _21;
static float4 _42;
static bool _48;
static float3 _64;
static float3 _70;
static float _91;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _21 = (_9.w * _27.w) + (-_34_m2);
    _42 = _9 * _27;
    _48 = _21 < 0.0f;
    if ((int(_48) * (-1)) != 0)
    {
        discard;
    }
    _64 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0).xyz;
    _70 = _64 * _34_m1.xyz;
    _70 = (_42.xyz * vs_TEXCOORD1) + _70;
    _70 += (-_34_m0.xyz);
    _91 = vs_TEXCOORD2;
    _91 = clamp(_91, 0.0f, 1.0f);
    float3 _104 = (_91.xxx * _70) + _34_m0.xyz;
    _42 = float4(_104.x, _104.y, _104.z, _42.w);
    _108 = _42;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _27 = stage_input._27;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._108 = _108;
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
float4 _Color;
float _VertexColor;
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
#define _21_m15 _Color
#define _21_m16 _VertexColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _136;
static float3 _149;
static float3 vs_TEXCOORD1;
static float4 _276;
static float4 _289;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _149 : NORMAL;
    float2 _136 : TEXCOORD0;
    float4 _276 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 _289 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;
static float _169;
static float3 _183;
static float4 _200;
static float3 _206;
static float _234;
static float4 _275;

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
    _234 = clamp(_234, 0.0f, 1.0f);
    _9.w = 1.0f;
    _206.x = dot(_21_m2, _9);
    _206.y = dot(_21_m3, _9);
    _206.z = dot(_21_m4, _9);
    _183 += _206;
    vs_TEXCOORD1 = (_21_m13.xyz * _234.xxx) + _183;
    _275 = _276 + (-1.0f).xxxx;
    _275 = (_21_m16.xxxx * _275) + 1.0f.xxxx;
    _289 = _275 * _21_m15;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    _149 = stage_input._149;
    _276 = stage_input._276;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._289 = _289;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _EmissionColor;
float _Cutoff;
#define _34_m0 unity_FogColor
#define _34_m1 _EmissionColor
#define _34_m2 _Cutoff


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;

static float2 vs_TEXCOORD0;
static float4 _27;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _108;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 _27 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _108 : SV_Target0;
};

static float4 _9;
static float _21;
static float4 _42;
static bool _48;
static float3 _64;
static float3 _70;
static float _91;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _21 = (_9.w * _27.w) + (-_34_m2);
    _42 = _9 * _27;
    _48 = _21 < 0.0f;
    if ((int(_48) * (-1)) != 0)
    {
        discard;
    }
    _64 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0).xyz;
    _70 = _64 * _34_m1.xyz;
    _70 = (_42.xyz * vs_TEXCOORD1) + _70;
    _70 += (-_34_m0.xyz);
    _91 = vs_TEXCOORD2;
    _91 = clamp(_91, 0.0f, 1.0f);
    float3 _104 = (_91.xxx * _70) + _34_m0.xyz;
    _42 = float4(_104.x, _104.y, _104.z, _42.w);
    _108 = _42;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _27 = stage_input._27;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._108 = _108;
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
float4 _Color;
float _VertexColor;
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
#define _21_m15 _Color
#define _21_m16 _VertexColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _129;
static float3 _142;
static float3 vs_TEXCOORD1;
static float4 _268;
static float4 _281;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _142 : NORMAL;
    float2 _129 : TEXCOORD0;
    float4 _268 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 _281 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;
static float _162;
static float3 _176;
static float4 _193;
static float3 _199;
static float _227;
static float4 _267;

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
    _227 = clamp(_227, 0.0f, 1.0f);
    _9.w = 1.0f;
    _199.x = dot(_21_m2, _9);
    _199.y = dot(_21_m3, _9);
    _199.z = dot(_21_m4, _9);
    _176 += _199;
    vs_TEXCOORD1 = (_21_m13.xyz * _227.xxx) + _176;
    _267 = _268 + (-1.0f).xxxx;
    _267 = (_21_m16.xxxx * _267) + 1.0f.xxxx;
    _281 = _267 * _21_m15;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _129 = stage_input._129;
    _142 = stage_input._142;
    _268 = stage_input._268;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._281 = _281;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _EmissionColor;
float _Cutoff;
#define _34_m0 unity_FogColor
#define _34_m1 _EmissionColor
#define _34_m2 _Cutoff


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;

static float2 vs_TEXCOORD0;
static float4 _27;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _108;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 _27 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _108 : SV_Target0;
};

static float4 _9;
static float _21;
static float4 _42;
static bool _48;
static float3 _64;
static float3 _70;
static float _91;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _21 = (_9.w * _27.w) + (-_34_m2);
    _42 = _9 * _27;
    _48 = _21 < 0.0f;
    if ((int(_48) * (-1)) != 0)
    {
        discard;
    }
    _64 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0).xyz;
    _70 = _64 * _34_m1.xyz;
    _70 = (_42.xyz * vs_TEXCOORD1) + _70;
    _70 += (-_34_m0.xyz);
    _91 = vs_TEXCOORD2;
    _91 = clamp(_91, 0.0f, 1.0f);
    float3 _104 = (_91.xxx * _70) + _34_m0.xyz;
    _42 = float4(_104.x, _104.y, _104.z, _42.w);
    _108 = _42;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _27 = stage_input._27;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._108 = _108;
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
float4 _Color;
float _VertexColor;
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
#define _21_m13 _Color
#define _21_m14 _VertexColor



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _89;
static float3 _102;
static float3 vs_TEXCOORD1;
static float4 _233;
static float4 _247;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _102 : NORMAL;
    float2 _89 : TEXCOORD0;
    float4 _233 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 _247 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _50;
static float _125;
static float3 _139;
static float4 _156;
static float3 _162;
static float _190;
static float4 _232;

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
    _190 = clamp(_190, 0.0f, 1.0f);
    _9.w = 1.0f;
    _162.x = dot(_21_m1, _9);
    _162.y = dot(_21_m2, _9);
    _162.z = dot(_21_m3, _9);
    _139 += _162;
    vs_TEXCOORD1 = (_21_m11.xyz * _190.xxx) + _139;
    _232 = _233 + (-1.0f).xxxx;
    _232 = (_21_m14.xxxx * _232) + 1.0f.xxxx;
    _247 = _232 * _21_m13;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _89 = stage_input._89;
    _102 = stage_input._102;
    _233 = stage_input._233;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._247 = _247;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _EmissionColor;
float _Cutoff;
#define _34_m0 _EmissionColor
#define _34_m1 _Cutoff


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;

static float2 vs_TEXCOORD0;
static float4 _27;
static float3 vs_TEXCOORD1;
static float4 _87;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 _27 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _87 : SV_Target0;
};

static float4 _9;
static float _21;
static float4 _42;
static bool _48;
static float3 _63;
static float3 _69;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _21 = (_9.w * _27.w) + (-_34_m1);
    _42 = _9 * _27;
    _48 = _21 < 0.0f;
    if ((int(_48) * (-1)) != 0)
    {
        discard;
    }
    _63 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0).xyz;
    _69 = _63 * _34_m0.xyz;
    float3 _83 = (_42.xyz * vs_TEXCOORD1) + _69;
    _42 = float4(_83.x, _83.y, _83.z, _42.w);
    _87 = _42;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _27 = stage_input._27;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._87 = _87;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}