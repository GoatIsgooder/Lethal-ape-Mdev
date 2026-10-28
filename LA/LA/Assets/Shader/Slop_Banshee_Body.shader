// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Banshee/Body" {
Properties {

_MainTex ("Albedo", 2D) = "white" { }

_Color ("Tint", Color) = (1,1,1,1)

_RimColor ("Rim", Color) = (0.55,0.6,0.75,1)

_RimPower ("Rim Power", Range(0.5, 8)) = 3.0

_RimScale ("Rim Scale (per material: dark cloth wants less)", Range(0, 1)) = 1.0

_Ambient ("Ambient", Range(0, 1)) = 0.3199999928474426

_Key ("Key Light", Range(0, 2)) = 0.800000011920929

_KeyDir ("Key Direction (world)", Vector) = (0.35,0.85,0.4,0)

_ProbeWeight ("Light Probe Share", Range(0, 1)) = 0.3499999940395355

_Glow ("Self Illumination", Range(0, 1)) = 0.10000000149011612

_EmitColor ("Crack Glow (albedo alpha)", Color) = (0,0,0,1)

_Dissolve ("Dissolve", Range(0, 1)) = 0.0

_NoiseTex ("Dissolve Noise (R)", 2D) = "gray" { }

_NoiseScale ("Dissolve Noise Tiling", Float) = 3.0

_EdgeColor ("Burn Edge", Color) = (3,0.5,0.25,1)

_EdgeWidth ("Burn Edge Width", Range(0.01, 0.3)) = 0.09000000357627869

}
SubShader {
 LOD 200
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
 Pass {
Cull Back
ZWrite On
  LOD 200
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _22_m9[4];
float4x4 unity_WorldToObject;
static float4 _22_m10[4];
float4x4 unity_MatrixVP;
static float4 _22_m11[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _22_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _ProjectionParams
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m5 unity_SHBr
#define _22_m6 unity_SHBg
#define _22_m7 unity_SHBb
#define _22_m8 unity_SHC
#define _22_m12 unity_FogParams
#define _22_m13 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _151;
static float3 _163;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _163 : NORMAL;
    float2 _151 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float _183;
static float3 _202;
static float4 _219;
static float3 _225;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m9[1];
    _9 = (_22_m9[0] * _11.xxxx) + _9;
    _9 = (_22_m9[2] * _11.zzzz) + _9;
    _46 = _9 + _22_m9[3];
    float3 _60 = (_22_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    vs_TEXCOORD2 = (-_9.xyz) + _22_m0;
    _9 = _46.yyyy * _22_m11[1];
    _9 = (_22_m11[0] * _46.xxxx) + _9;
    _9 = (_22_m11[2] * _46.zzzz) + _9;
    _9 = (_22_m11[3] * _46.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _22_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _22_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _22_m12.y;
    vs_TEXCOORD4 = exp2(-_9.x);
    vs_TEXCOORD0 = (_151 * _22_m13.xy) + _22_m13.zw;
    _9.x = dot(_163, _22_m10[0].xyz);
    _9.y = dot(_163, _22_m10[1].xyz);
    _9.z = dot(_163, _22_m10[2].xyz);
    _183 = dot(_9.xyz, _9.xyz);
    _183 = rsqrt(_183);
    float3 _195 = _183.xxx * _9.xyz;
    _9 = float4(_195.x, _195.y, _195.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _202.x = _9.y * _9.y;
    _202.x = (_9.x * _9.x) + (-_202.x);
    _219 = _9.yzzx * _9.xyzz;
    _225.x = dot(_22_m5, _219);
    _225.y = dot(_22_m6, _219);
    _225.z = dot(_22_m7, _219);
    _202 = (_22_m8.xyz * _202.xxx) + _225;
    _9.w = 1.0f;
    _225.x = dot(_22_m2, _9);
    _225.y = dot(_22_m3, _9);
    _225.z = dot(_22_m4, _9);
    _202 += _225;
    vs_TEXCOORD3 = max(_202, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _151 = stage_input._151;
    _163 = stage_input._163;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _Color;
float4 _RimColor;
float _RimPower;
float _RimScale;
float _Ambient;
float _Key;
float4 _KeyDir;
float _ProbeWeight;
float _Glow;
float4 _EmitColor;
float _Dissolve;
float _NoiseScale;
float4 _EdgeColor;
float _EdgeWidth;
#define _17_m0 unity_FogColor
#define _17_m1 _Color
#define _17_m2 _RimColor
#define _17_m3 _RimPower
#define _17_m4 _RimScale
#define _17_m5 _Ambient
#define _17_m6 _Key
#define _17_m7 _KeyDir
#define _17_m8 _ProbeWeight
#define _17_m9 _Glow
#define _17_m10 _EmitColor
#define _17_m11 _Dissolve
#define _17_m12 _NoiseScale
#define _17_m13 _EdgeColor
#define _17_m14 _EdgeWidth


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _291;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _291 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float3 _42;
static bool _62;
static float3 _82;
static float _128;
static float3 _135;
static float _140;
static float3 _197;
static float3 _223;
static float3 _230;

void frag_inner()
{
    float2 _24 = vs_TEXCOORD0 * _17_m12.xx;
    _9 = float3(_24.x, _24.y, _9.z);
    _28.x = _NoiseTex.Sample(sampler_NoiseTex, _9.xy).x;
    _42.x = _17_m14 + 1.0f;
    _42.x = ((-_17_m11) * _42.x) + _28.x;
    _62 = _42.x < 0.0f;
    _42.x /= _17_m14;
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _82 = _42.xxx * _17_m13.xyz;
    if ((int(_62) * (-1)) != 0)
    {
        discard;
    }
    _62 = _17_m11 >= 0.001000000047497451305389404296875f;
    float3 _107;
    if (_62)
    {
        _107 = _82;
    }
    else
    {
        _107 = 0.0f.xxx;
    }
    _42 = _107;
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD2;
    _128 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _128 = rsqrt(_128);
    _135 = _128.xxx * vs_TEXCOORD1;
    _140 = dot(_135, _9);
    _140 = clamp(_140, 0.0f, 1.0f);
    _140 = (-_140) + 1.0f;
    _140 = log2(_140);
    _140 *= _17_m3;
    _140 = exp2(_140);
    _140 *= _17_m4;
    _9.x = dot(_17_m7.xyz, _17_m7.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _17_m7.xyz;
    _9.x = dot(_135, _9);
    _9.x = (_9.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _197.x = (_17_m6 * _9.x) + _17_m5;
    _197 = (vs_TEXCOORD3 * _17_m8.xxx) + _197.xxx;
    _28 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _223 = _28.xyz * _17_m1.xyz;
    _230 = _223 * float3(float3(_17_m9, _17_m9, _17_m9));
    _197 = (_223 * _197) + _230;
    _197 = (_17_m2.xyz * _140.xxx) + _197;
    _197 = (_17_m10.xyz * _28.www) + _197;
    _42 += _197;
    _9 = _42 + (-_17_m0.xyz);
    _128 = vs_TEXCOORD4;
    _128 = clamp(_128, 0.0f, 1.0f);
    _9 = (_128.xxx * _9) + _17_m0.xyz;
    _291 = float4(_9.x, _9.y, _9.z, _291.w);
    _291.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._291 = _291;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _22_m9[4];
float4x4 unity_WorldToObject;
static float4 _22_m10[4];
float4x4 unity_MatrixVP;
static float4 _22_m11[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _22_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _ProjectionParams
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m5 unity_SHBr
#define _22_m6 unity_SHBg
#define _22_m7 unity_SHBb
#define _22_m8 unity_SHC
#define _22_m12 unity_FogParams
#define _22_m13 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _157;
static float3 _169;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _169 : NORMAL;
    float2 _157 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float _189;
static float3 _208;
static float4 _225;
static float3 _231;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m9[1];
    _9 = (_22_m9[0] * _11.xxxx) + _9;
    _9 = (_22_m9[2] * _11.zzzz) + _9;
    _46 = _9 + _22_m9[3];
    float3 _60 = (_22_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    vs_TEXCOORD2 = (-_9.xyz) + _22_m0;
    _9 = _46.yyyy * _22_m11[1];
    _9 = (_22_m11[0] * _46.xxxx) + _9;
    _9 = (_22_m11[2] * _46.zzzz) + _9;
    _9 = (_22_m11[3] * _46.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _22_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _22_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _22_m12.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD4 = exp2(_9.x);
    vs_TEXCOORD0 = (_157 * _22_m13.xy) + _22_m13.zw;
    _9.x = dot(_169, _22_m10[0].xyz);
    _9.y = dot(_169, _22_m10[1].xyz);
    _9.z = dot(_169, _22_m10[2].xyz);
    _189 = dot(_9.xyz, _9.xyz);
    _189 = rsqrt(_189);
    float3 _201 = _189.xxx * _9.xyz;
    _9 = float4(_201.x, _201.y, _201.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _208.x = _9.y * _9.y;
    _208.x = (_9.x * _9.x) + (-_208.x);
    _225 = _9.yzzx * _9.xyzz;
    _231.x = dot(_22_m5, _225);
    _231.y = dot(_22_m6, _225);
    _231.z = dot(_22_m7, _225);
    _208 = (_22_m8.xyz * _208.xxx) + _231;
    _9.w = 1.0f;
    _231.x = dot(_22_m2, _9);
    _231.y = dot(_22_m3, _9);
    _231.z = dot(_22_m4, _9);
    _208 += _231;
    vs_TEXCOORD3 = max(_208, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _157 = stage_input._157;
    _169 = stage_input._169;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _Color;
float4 _RimColor;
float _RimPower;
float _RimScale;
float _Ambient;
float _Key;
float4 _KeyDir;
float _ProbeWeight;
float _Glow;
float4 _EmitColor;
float _Dissolve;
float _NoiseScale;
float4 _EdgeColor;
float _EdgeWidth;
#define _17_m0 unity_FogColor
#define _17_m1 _Color
#define _17_m2 _RimColor
#define _17_m3 _RimPower
#define _17_m4 _RimScale
#define _17_m5 _Ambient
#define _17_m6 _Key
#define _17_m7 _KeyDir
#define _17_m8 _ProbeWeight
#define _17_m9 _Glow
#define _17_m10 _EmitColor
#define _17_m11 _Dissolve
#define _17_m12 _NoiseScale
#define _17_m13 _EdgeColor
#define _17_m14 _EdgeWidth


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _291;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _291 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float3 _42;
static bool _62;
static float3 _82;
static float _128;
static float3 _135;
static float _140;
static float3 _197;
static float3 _223;
static float3 _230;

void frag_inner()
{
    float2 _24 = vs_TEXCOORD0 * _17_m12.xx;
    _9 = float3(_24.x, _24.y, _9.z);
    _28.x = _NoiseTex.Sample(sampler_NoiseTex, _9.xy).x;
    _42.x = _17_m14 + 1.0f;
    _42.x = ((-_17_m11) * _42.x) + _28.x;
    _62 = _42.x < 0.0f;
    _42.x /= _17_m14;
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _82 = _42.xxx * _17_m13.xyz;
    if ((int(_62) * (-1)) != 0)
    {
        discard;
    }
    _62 = _17_m11 >= 0.001000000047497451305389404296875f;
    float3 _107;
    if (_62)
    {
        _107 = _82;
    }
    else
    {
        _107 = 0.0f.xxx;
    }
    _42 = _107;
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD2;
    _128 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _128 = rsqrt(_128);
    _135 = _128.xxx * vs_TEXCOORD1;
    _140 = dot(_135, _9);
    _140 = clamp(_140, 0.0f, 1.0f);
    _140 = (-_140) + 1.0f;
    _140 = log2(_140);
    _140 *= _17_m3;
    _140 = exp2(_140);
    _140 *= _17_m4;
    _9.x = dot(_17_m7.xyz, _17_m7.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _17_m7.xyz;
    _9.x = dot(_135, _9);
    _9.x = (_9.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _197.x = (_17_m6 * _9.x) + _17_m5;
    _197 = (vs_TEXCOORD3 * _17_m8.xxx) + _197.xxx;
    _28 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _223 = _28.xyz * _17_m1.xyz;
    _230 = _223 * float3(float3(_17_m9, _17_m9, _17_m9));
    _197 = (_223 * _197) + _230;
    _197 = (_17_m2.xyz * _140.xxx) + _197;
    _197 = (_17_m10.xyz * _28.www) + _197;
    _42 += _197;
    _9 = _42 + (-_17_m0.xyz);
    _128 = vs_TEXCOORD4;
    _128 = clamp(_128, 0.0f, 1.0f);
    _9 = (_128.xxx * _9) + _17_m0.xyz;
    _291 = float4(_9.x, _9.y, _9.z, _291.w);
    _291.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._291 = _291;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _22_m9[4];
float4x4 unity_WorldToObject;
static float4 _22_m10[4];
float4x4 unity_MatrixVP;
static float4 _22_m11[4];
float4 unity_FogParams;
float4 _MainTex_ST;
void __unity_init()
{
    _22_m9[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m9[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m9[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m9[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m10[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m10[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m10[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m10[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m11[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m11[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m11[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m11[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 _ProjectionParams
#define _22_m2 unity_SHAr
#define _22_m3 unity_SHAg
#define _22_m4 unity_SHAb
#define _22_m5 unity_SHBr
#define _22_m6 unity_SHBg
#define _22_m7 unity_SHBb
#define _22_m8 unity_SHC
#define _22_m12 unity_FogParams
#define _22_m13 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _150;
static float3 _162;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _162 : NORMAL;
    float2 _150 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float _182;
static float3 _201;
static float4 _218;
static float3 _224;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m9[1];
    _9 = (_22_m9[0] * _11.xxxx) + _9;
    _9 = (_22_m9[2] * _11.zzzz) + _9;
    _46 = _9 + _22_m9[3];
    float3 _60 = (_22_m9[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    vs_TEXCOORD2 = (-_9.xyz) + _22_m0;
    _9 = _46.yyyy * _22_m11[1];
    _9 = (_22_m11[0] * _46.xxxx) + _9;
    _9 = (_22_m11[2] * _46.zzzz) + _9;
    _9 = (_22_m11[3] * _46.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _22_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _22_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD4 = (_9.x * _22_m12.z) + _22_m12.w;
    vs_TEXCOORD0 = (_150 * _22_m13.xy) + _22_m13.zw;
    _9.x = dot(_162, _22_m10[0].xyz);
    _9.y = dot(_162, _22_m10[1].xyz);
    _9.z = dot(_162, _22_m10[2].xyz);
    _182 = dot(_9.xyz, _9.xyz);
    _182 = rsqrt(_182);
    float3 _194 = _182.xxx * _9.xyz;
    _9 = float4(_194.x, _194.y, _194.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _201.x = _9.y * _9.y;
    _201.x = (_9.x * _9.x) + (-_201.x);
    _218 = _9.yzzx * _9.xyzz;
    _224.x = dot(_22_m5, _218);
    _224.y = dot(_22_m6, _218);
    _224.z = dot(_22_m7, _218);
    _201 = (_22_m8.xyz * _201.xxx) + _224;
    _9.w = 1.0f;
    _224.x = dot(_22_m2, _9);
    _224.y = dot(_22_m3, _9);
    _224.z = dot(_22_m4, _9);
    _201 += _224;
    vs_TEXCOORD3 = max(_201, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _150 = stage_input._150;
    _162 = stage_input._162;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _Color;
float4 _RimColor;
float _RimPower;
float _RimScale;
float _Ambient;
float _Key;
float4 _KeyDir;
float _ProbeWeight;
float _Glow;
float4 _EmitColor;
float _Dissolve;
float _NoiseScale;
float4 _EdgeColor;
float _EdgeWidth;
#define _17_m0 unity_FogColor
#define _17_m1 _Color
#define _17_m2 _RimColor
#define _17_m3 _RimPower
#define _17_m4 _RimScale
#define _17_m5 _Ambient
#define _17_m6 _Key
#define _17_m7 _KeyDir
#define _17_m8 _ProbeWeight
#define _17_m9 _Glow
#define _17_m10 _EmitColor
#define _17_m11 _Dissolve
#define _17_m12 _NoiseScale
#define _17_m13 _EdgeColor
#define _17_m14 _EdgeWidth


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _291;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _291 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float3 _42;
static bool _62;
static float3 _82;
static float _128;
static float3 _135;
static float _140;
static float3 _197;
static float3 _223;
static float3 _230;

void frag_inner()
{
    float2 _24 = vs_TEXCOORD0 * _17_m12.xx;
    _9 = float3(_24.x, _24.y, _9.z);
    _28.x = _NoiseTex.Sample(sampler_NoiseTex, _9.xy).x;
    _42.x = _17_m14 + 1.0f;
    _42.x = ((-_17_m11) * _42.x) + _28.x;
    _62 = _42.x < 0.0f;
    _42.x /= _17_m14;
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _82 = _42.xxx * _17_m13.xyz;
    if ((int(_62) * (-1)) != 0)
    {
        discard;
    }
    _62 = _17_m11 >= 0.001000000047497451305389404296875f;
    float3 _107;
    if (_62)
    {
        _107 = _82;
    }
    else
    {
        _107 = 0.0f.xxx;
    }
    _42 = _107;
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD2;
    _128 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _128 = rsqrt(_128);
    _135 = _128.xxx * vs_TEXCOORD1;
    _140 = dot(_135, _9);
    _140 = clamp(_140, 0.0f, 1.0f);
    _140 = (-_140) + 1.0f;
    _140 = log2(_140);
    _140 *= _17_m3;
    _140 = exp2(_140);
    _140 *= _17_m4;
    _9.x = dot(_17_m7.xyz, _17_m7.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _17_m7.xyz;
    _9.x = dot(_135, _9);
    _9.x = (_9.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _197.x = (_17_m6 * _9.x) + _17_m5;
    _197 = (vs_TEXCOORD3 * _17_m8.xxx) + _197.xxx;
    _28 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _223 = _28.xyz * _17_m1.xyz;
    _230 = _223 * float3(float3(_17_m9, _17_m9, _17_m9));
    _197 = (_223 * _197) + _230;
    _197 = (_17_m2.xyz * _140.xxx) + _197;
    _197 = (_17_m10.xyz * _28.www) + _197;
    _42 += _197;
    _9 = _42 + (-_17_m0.xyz);
    _128 = vs_TEXCOORD4;
    _128 = clamp(_128, 0.0f, 1.0f);
    _9 = (_128.xxx * _9) + _17_m0.xyz;
    _291 = float4(_9.x, _9.y, _9.z, _291.w);
    _291.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._291 = _291;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _22_m8[4];
float4x4 unity_WorldToObject;
static float4 _22_m9[4];
float4x4 unity_MatrixVP;
static float4 _22_m10[4];
float4 _MainTex_ST;
void __unity_init()
{
    _22_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m9[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m9[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m9[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m9[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m10[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m10[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m10[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m10[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _22_m0 _WorldSpaceCameraPos
#define _22_m1 unity_SHAr
#define _22_m2 unity_SHAg
#define _22_m3 unity_SHAb
#define _22_m4 unity_SHBr
#define _22_m5 unity_SHBg
#define _22_m6 unity_SHBb
#define _22_m7 unity_SHC
#define _22_m11 _MainTex_ST



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _110;
static float3 _122;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _122 : NORMAL;
    float2 _110 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float _145;
static float3 _164;
static float4 _181;
static float3 _187;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m8[1];
    _9 = (_22_m8[0] * _11.xxxx) + _9;
    _9 = (_22_m8[2] * _11.zzzz) + _9;
    _46 = _9 + _22_m8[3];
    float3 _60 = (_22_m8[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    vs_TEXCOORD2 = (-_9.xyz) + _22_m0;
    _9 = _46.yyyy * _22_m10[1];
    _9 = (_22_m10[0] * _46.xxxx) + _9;
    _9 = (_22_m10[2] * _46.zzzz) + _9;
    gl_Position = (_22_m10[3] * _46.wwww) + _9;
    vs_TEXCOORD0 = (_110 * _22_m11.xy) + _22_m11.zw;
    _9.x = dot(_122, _22_m9[0].xyz);
    _9.y = dot(_122, _22_m9[1].xyz);
    _9.z = dot(_122, _22_m9[2].xyz);
    _145 = dot(_9.xyz, _9.xyz);
    _145 = rsqrt(_145);
    float3 _157 = _145.xxx * _9.xyz;
    _9 = float4(_157.x, _157.y, _157.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    _164.x = _9.y * _9.y;
    _164.x = (_9.x * _9.x) + (-_164.x);
    _181 = _9.yzzx * _9.xyzz;
    _187.x = dot(_22_m4, _181);
    _187.y = dot(_22_m5, _181);
    _187.z = dot(_22_m6, _181);
    _164 = (_22_m7.xyz * _164.xxx) + _187;
    _9.w = 1.0f;
    _187.x = dot(_22_m1, _9);
    _187.y = dot(_22_m2, _9);
    _187.z = dot(_22_m3, _9);
    _164 += _187;
    vs_TEXCOORD3 = max(_164, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _110 = stage_input._110;
    _122 = stage_input._122;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Color;
float4 _RimColor;
float _RimPower;
float _RimScale;
float _Ambient;
float _Key;
float4 _KeyDir;
float _ProbeWeight;
float _Glow;
float4 _EmitColor;
float _Dissolve;
float _NoiseScale;
float4 _EdgeColor;
float _EdgeWidth;
#define _17_m0 _Color
#define _17_m1 _RimColor
#define _17_m2 _RimPower
#define _17_m3 _RimScale
#define _17_m4 _Ambient
#define _17_m5 _Key
#define _17_m6 _KeyDir
#define _17_m7 _ProbeWeight
#define _17_m8 _Glow
#define _17_m9 _EmitColor
#define _17_m10 _Dissolve
#define _17_m11 _NoiseScale
#define _17_m12 _EdgeColor
#define _17_m13 _EdgeWidth


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float4 _268;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _268 : SV_Target0;
};

static float3 _9;
static float4 _28;
static float3 _42;
static bool _62;
static float3 _82;
static float _128;
static float3 _135;
static float _140;
static float3 _197;
static float3 _223;
static float3 _230;

void frag_inner()
{
    float2 _24 = vs_TEXCOORD0 * _17_m11.xx;
    _9 = float3(_24.x, _24.y, _9.z);
    _28.x = _NoiseTex.Sample(sampler_NoiseTex, _9.xy).x;
    _42.x = _17_m13 + 1.0f;
    _42.x = ((-_17_m10) * _42.x) + _28.x;
    _62 = _42.x < 0.0f;
    _42.x /= _17_m13;
    _42.x = clamp(_42.x, 0.0f, 1.0f);
    _42.x = (-_42.x) + 1.0f;
    _82 = _42.xxx * _17_m12.xyz;
    if ((int(_62) * (-1)) != 0)
    {
        discard;
    }
    _62 = _17_m10 >= 0.001000000047497451305389404296875f;
    float3 _107;
    if (_62)
    {
        _107 = _82;
    }
    else
    {
        _107 = 0.0f.xxx;
    }
    _42 = _107;
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD2;
    _128 = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _128 = rsqrt(_128);
    _135 = _128.xxx * vs_TEXCOORD1;
    _140 = dot(_135, _9);
    _140 = clamp(_140, 0.0f, 1.0f);
    _140 = (-_140) + 1.0f;
    _140 = log2(_140);
    _140 *= _17_m2;
    _140 = exp2(_140);
    _140 *= _17_m3;
    _9.x = dot(_17_m6.xyz, _17_m6.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _17_m6.xyz;
    _9.x = dot(_135, _9);
    _9.x = (_9.x * 0.60000002384185791015625f) + 0.4000000059604644775390625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _197.x = (_17_m5 * _9.x) + _17_m4;
    _197 = (vs_TEXCOORD3 * _17_m7.xxx) + _197.xxx;
    _28 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _223 = _28.xyz * _17_m0.xyz;
    _230 = _223 * float3(float3(_17_m8, _17_m8, _17_m8));
    _197 = (_223 * _197) + _230;
    _197 = (_17_m1.xyz * _140.xxx) + _197;
    _197 = (_17_m9.xyz * _28.www) + _197;
    float3 _271 = _42 + _197;
    _268 = float4(_271.x, _271.y, _271.z, _268.w);
    _268.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._268 = _268;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}