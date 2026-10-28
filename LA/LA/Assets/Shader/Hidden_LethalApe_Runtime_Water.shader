// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Hidden/LethalApe/Runtime/Water" {
Properties {

_ShallowColor ("Shallow Colour", Color) = (0.25,0.68,0.78,0.55)

_DeepColor ("Deep Colour", Color) = (0.03,0.2,0.3,0.88)

_MainTex ("Ripples (R)", 2D) = "gray" { }

_RippleScale ("Ripple Scale (per metre)", Float) = 0.25

_RippleSpeed ("Ripple Speed", Float) = 0.03999999910593033

_Sparkle ("Sun Sparkle", Range(0, 2)) = 0.800000011920929

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
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
float4 _Time;
float4 _ProjectionParams;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _20_m7[4];
float4x4 unity_MatrixVP;
static float4 _20_m8[4];
float4 unity_FogParams;
float4 _LightColor0;
float _RippleScale;
float _RippleSpeed;
void __unity_init()
{
    _20_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _Time
#define _20_m1 _ProjectionParams
#define _20_m2 _WorldSpaceLightPos0
#define _20_m3 unity_SHAr
#define _20_m4 unity_SHAg
#define _20_m5 unity_SHAb
#define _20_m6 unity_SHC
#define _20_m9 unity_FogParams
#define _20_m10 _LightColor0
#define _20_m11 _RippleScale
#define _20_m12 _RippleSpeed



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _62;
static float _99;
static float3 _176;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m7[1];
    _9 = (_20_m7[0] * _11.xxxx) + _9;
    _9 = (_20_m7[2] * _11.zzzz) + _9;
    _44 = _9 + _20_m7[3];
    float3 _59 = (_20_m7[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _44.yyyy * _20_m8[1];
    _62 = (_20_m8[0] * _44.xxxx) + _62;
    _62 = (_20_m8[2] * _44.zzzz) + _62;
    _44 = (_20_m8[3] * _44.wwww) + _62;
    gl_Position = _44;
    _99 = _44.z / _20_m1.y;
    _99 = (-_99) + 1.0f;
    _99 *= _20_m1.z;
    _99 = max(_99, 0.0f);
    _99 *= _20_m9.y;
    vs_TEXCOORD3 = exp2(-_99);
    _99 = _20_m11 * 1.7000000476837158203125f;
    _44.x = _20_m0.y * _20_m12;
    _44 = _44.xxxx * float4(1.0f, 0.60000002384185791015625f, -0.699999988079071044921875f, 1.10000002384185791015625f);
    float2 _157 = (_9.xz * _99.xx) + _44.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _157.x, _157.y);
    float2 _168 = (_9.xz * _20_m11.xx) + _44.xy;
    vs_TEXCOORD0 = float4(_168.x, _168.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD1 = _9.xyz;
    _176.x = dot(_20_m3.yw, 1.0f.xx);
    _176.y = dot(_20_m4.yw, 1.0f.xx);
    _176.z = dot(_20_m5.yw, 1.0f.xx);
    _176 += (-_20_m6.xyz);
    _9.x = _20_m2.y;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _217 = (_20_m10.xyz * _9.xxx) + _176;
    _9 = float4(_217.x, _217.y, _217.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _ShallowColor;
float4 _DeepColor;
float _Sparkle;
#define _79_m0 _WorldSpaceCameraPos
#define _79_m1 _WorldSpaceLightPos0
#define _79_m2 unity_FogColor
#define _79_m3 _LightColor0
#define _79_m4 _ShallowColor
#define _79_m5 _DeepColor
#define _79_m6 _Sparkle


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _210;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _210 : SV_Target0;
};

static float4 _9;
static float4 _26;
static float _32;
static float _42;
static float _55;
static float3 _72;
static float _86;
static float3 _92;
static float3 _154;
static float3 _163;
static float _232;

void frag_inner()
{
    _9.x = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).x;
    _26.x = _9.x + (-0.5f);
    _32 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.zw).x;
    _26.z = _32 + (-0.5f);
    _42 = _32 + _9.x;
    _26.w = _42 + (-1.0f);
    _26.y = 1.5f;
    _55 = dot(_26.xyz, _26.xyz);
    _55 = rsqrt(_55);
    float3 _68 = _26.xyz * _55.xxx;
    _26 = float4(_68.x, _68.y, _68.z, _26.w);
    _72 = (-vs_TEXCOORD1) + _79_m0;
    _86 = dot(_72, _72);
    _86 = rsqrt(_86);
    _92 = (_72 * _86.xxx) + _79_m1.xyz;
    _72.x = _86 * _72.y;
    _55 = min(abs(_72.x), 1.0f);
    _55 = (-_55) + 1.0f;
    _72.x = dot(_92, _92);
    _72.x = rsqrt(_72.x);
    _72 = _72.xxx * _92;
    _26.x = dot(_26.xyz, _72);
    _26.x = clamp(_26.x, 0.0f, 1.0f);
    _26.x = log2(_26.x);
    float2 _147 = _26.xw * float2(96.0f, 0.3499999940395355224609375f);
    _26 = float4(_147.x, _26.y, _26.z, _147.y);
    _26.x = exp2(_26.x);
    _154.x = _26.x * _79_m6;
    _163 = _154.xxx * _79_m3.xyz;
    _154.x = _55 * _55;
    _154.x = (_55 * _154.x) + _26.w;
    _154.x = clamp(_154.x, 0.0f, 1.0f);
    _9 = _79_m4 + (-_79_m5);
    _9 = (_154.xxxx * _9) + _79_m5;
    _154 = (_9.xyz * vs_TEXCOORD2) + _163;
    _210.w = (_26.x * _79_m6) + _9.w;
    _210.w = clamp(_210.w, 0.0f, 1.0f);
    _92 = _154 + (-_79_m2.xyz);
    _232 = vs_TEXCOORD3;
    _232 = clamp(_232, 0.0f, 1.0f);
    _92 = (_232.xxx * _92) + _79_m2.xyz;
    _210 = float4(_92.x, _92.y, _92.z, _210.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._210 = _210;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _20_m7[4];
float4x4 unity_MatrixVP;
static float4 _20_m8[4];
float4 unity_FogParams;
float4 _LightColor0;
float _RippleScale;
float _RippleSpeed;
void __unity_init()
{
    _20_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _Time
#define _20_m1 _ProjectionParams
#define _20_m2 _WorldSpaceLightPos0
#define _20_m3 unity_SHAr
#define _20_m4 unity_SHAg
#define _20_m5 unity_SHAb
#define _20_m6 unity_SHC
#define _20_m9 unity_FogParams
#define _20_m10 _LightColor0
#define _20_m11 _RippleScale
#define _20_m12 _RippleSpeed



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _62;
static float _99;
static float3 _179;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m7[1];
    _9 = (_20_m7[0] * _11.xxxx) + _9;
    _9 = (_20_m7[2] * _11.zzzz) + _9;
    _44 = _9 + _20_m7[3];
    float3 _59 = (_20_m7[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _44.yyyy * _20_m8[1];
    _62 = (_20_m8[0] * _44.xxxx) + _62;
    _62 = (_20_m8[2] * _44.zzzz) + _62;
    _44 = (_20_m8[3] * _44.wwww) + _62;
    gl_Position = _44;
    _99 = _44.z / _20_m1.y;
    _99 = (-_99) + 1.0f;
    _99 *= _20_m1.z;
    _99 = max(_99, 0.0f);
    _99 *= _20_m9.x;
    _99 *= (-_99);
    vs_TEXCOORD3 = exp2(_99);
    _99 = _20_m11 * 1.7000000476837158203125f;
    _44.x = _20_m0.y * _20_m12;
    _44 = _44.xxxx * float4(1.0f, 0.60000002384185791015625f, -0.699999988079071044921875f, 1.10000002384185791015625f);
    float2 _160 = (_9.xz * _99.xx) + _44.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _160.x, _160.y);
    float2 _171 = (_9.xz * _20_m11.xx) + _44.xy;
    vs_TEXCOORD0 = float4(_171.x, _171.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD1 = _9.xyz;
    _179.x = dot(_20_m3.yw, 1.0f.xx);
    _179.y = dot(_20_m4.yw, 1.0f.xx);
    _179.z = dot(_20_m5.yw, 1.0f.xx);
    _179 += (-_20_m6.xyz);
    _9.x = _20_m2.y;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _220 = (_20_m10.xyz * _9.xxx) + _179;
    _9 = float4(_220.x, _220.y, _220.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _ShallowColor;
float4 _DeepColor;
float _Sparkle;
#define _79_m0 _WorldSpaceCameraPos
#define _79_m1 _WorldSpaceLightPos0
#define _79_m2 unity_FogColor
#define _79_m3 _LightColor0
#define _79_m4 _ShallowColor
#define _79_m5 _DeepColor
#define _79_m6 _Sparkle


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _210;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _210 : SV_Target0;
};

static float4 _9;
static float4 _26;
static float _32;
static float _42;
static float _55;
static float3 _72;
static float _86;
static float3 _92;
static float3 _154;
static float3 _163;
static float _232;

void frag_inner()
{
    _9.x = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).x;
    _26.x = _9.x + (-0.5f);
    _32 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.zw).x;
    _26.z = _32 + (-0.5f);
    _42 = _32 + _9.x;
    _26.w = _42 + (-1.0f);
    _26.y = 1.5f;
    _55 = dot(_26.xyz, _26.xyz);
    _55 = rsqrt(_55);
    float3 _68 = _26.xyz * _55.xxx;
    _26 = float4(_68.x, _68.y, _68.z, _26.w);
    _72 = (-vs_TEXCOORD1) + _79_m0;
    _86 = dot(_72, _72);
    _86 = rsqrt(_86);
    _92 = (_72 * _86.xxx) + _79_m1.xyz;
    _72.x = _86 * _72.y;
    _55 = min(abs(_72.x), 1.0f);
    _55 = (-_55) + 1.0f;
    _72.x = dot(_92, _92);
    _72.x = rsqrt(_72.x);
    _72 = _72.xxx * _92;
    _26.x = dot(_26.xyz, _72);
    _26.x = clamp(_26.x, 0.0f, 1.0f);
    _26.x = log2(_26.x);
    float2 _147 = _26.xw * float2(96.0f, 0.3499999940395355224609375f);
    _26 = float4(_147.x, _26.y, _26.z, _147.y);
    _26.x = exp2(_26.x);
    _154.x = _26.x * _79_m6;
    _163 = _154.xxx * _79_m3.xyz;
    _154.x = _55 * _55;
    _154.x = (_55 * _154.x) + _26.w;
    _154.x = clamp(_154.x, 0.0f, 1.0f);
    _9 = _79_m4 + (-_79_m5);
    _9 = (_154.xxxx * _9) + _79_m5;
    _154 = (_9.xyz * vs_TEXCOORD2) + _163;
    _210.w = (_26.x * _79_m6) + _9.w;
    _210.w = clamp(_210.w, 0.0f, 1.0f);
    _92 = _154 + (-_79_m2.xyz);
    _232 = vs_TEXCOORD3;
    _232 = clamp(_232, 0.0f, 1.0f);
    _92 = (_232.xxx * _92) + _79_m2.xyz;
    _210 = float4(_92.x, _92.y, _92.z, _210.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._210 = _210;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _20_m7[4];
float4x4 unity_MatrixVP;
static float4 _20_m8[4];
float4 unity_FogParams;
float4 _LightColor0;
float _RippleScale;
float _RippleSpeed;
void __unity_init()
{
    _20_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _Time
#define _20_m1 _ProjectionParams
#define _20_m2 _WorldSpaceLightPos0
#define _20_m3 unity_SHAr
#define _20_m4 unity_SHAg
#define _20_m5 unity_SHAb
#define _20_m6 unity_SHC
#define _20_m9 unity_FogParams
#define _20_m10 _LightColor0
#define _20_m11 _RippleScale
#define _20_m12 _RippleSpeed



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD3;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _62;
static float _99;
static float3 _177;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m7[1];
    _9 = (_20_m7[0] * _11.xxxx) + _9;
    _9 = (_20_m7[2] * _11.zzzz) + _9;
    _44 = _9 + _20_m7[3];
    float3 _59 = (_20_m7[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _44.yyyy * _20_m8[1];
    _62 = (_20_m8[0] * _44.xxxx) + _62;
    _62 = (_20_m8[2] * _44.zzzz) + _62;
    _44 = (_20_m8[3] * _44.wwww) + _62;
    gl_Position = _44;
    _99 = _44.z / _20_m1.y;
    _99 = (-_99) + 1.0f;
    _99 *= _20_m1.z;
    _99 = max(_99, 0.0f);
    vs_TEXCOORD3 = (_99 * _20_m9.z) + _20_m9.w;
    _99 = _20_m11 * 1.7000000476837158203125f;
    _44.x = _20_m0.y * _20_m12;
    _44 = _44.xxxx * float4(1.0f, 0.60000002384185791015625f, -0.699999988079071044921875f, 1.10000002384185791015625f);
    float2 _158 = (_9.xz * _99.xx) + _44.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _158.x, _158.y);
    float2 _169 = (_9.xz * _20_m11.xx) + _44.xy;
    vs_TEXCOORD0 = float4(_169.x, _169.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD1 = _9.xyz;
    _177.x = dot(_20_m3.yw, 1.0f.xx);
    _177.y = dot(_20_m4.yw, 1.0f.xx);
    _177.z = dot(_20_m5.yw, 1.0f.xx);
    _177 += (-_20_m6.xyz);
    _9.x = _20_m2.y;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _218 = (_20_m10.xyz * _9.xxx) + _177;
    _9 = float4(_218.x, _218.y, _218.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _ShallowColor;
float4 _DeepColor;
float _Sparkle;
#define _79_m0 _WorldSpaceCameraPos
#define _79_m1 _WorldSpaceLightPos0
#define _79_m2 unity_FogColor
#define _79_m3 _LightColor0
#define _79_m4 _ShallowColor
#define _79_m5 _DeepColor
#define _79_m6 _Sparkle


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _210;
static float vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _210 : SV_Target0;
};

static float4 _9;
static float4 _26;
static float _32;
static float _42;
static float _55;
static float3 _72;
static float _86;
static float3 _92;
static float3 _154;
static float3 _163;
static float _232;

void frag_inner()
{
    _9.x = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).x;
    _26.x = _9.x + (-0.5f);
    _32 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.zw).x;
    _26.z = _32 + (-0.5f);
    _42 = _32 + _9.x;
    _26.w = _42 + (-1.0f);
    _26.y = 1.5f;
    _55 = dot(_26.xyz, _26.xyz);
    _55 = rsqrt(_55);
    float3 _68 = _26.xyz * _55.xxx;
    _26 = float4(_68.x, _68.y, _68.z, _26.w);
    _72 = (-vs_TEXCOORD1) + _79_m0;
    _86 = dot(_72, _72);
    _86 = rsqrt(_86);
    _92 = (_72 * _86.xxx) + _79_m1.xyz;
    _72.x = _86 * _72.y;
    _55 = min(abs(_72.x), 1.0f);
    _55 = (-_55) + 1.0f;
    _72.x = dot(_92, _92);
    _72.x = rsqrt(_72.x);
    _72 = _72.xxx * _92;
    _26.x = dot(_26.xyz, _72);
    _26.x = clamp(_26.x, 0.0f, 1.0f);
    _26.x = log2(_26.x);
    float2 _147 = _26.xw * float2(96.0f, 0.3499999940395355224609375f);
    _26 = float4(_147.x, _26.y, _26.z, _147.y);
    _26.x = exp2(_26.x);
    _154.x = _26.x * _79_m6;
    _163 = _154.xxx * _79_m3.xyz;
    _154.x = _55 * _55;
    _154.x = (_55 * _154.x) + _26.w;
    _154.x = clamp(_154.x, 0.0f, 1.0f);
    _9 = _79_m4 + (-_79_m5);
    _9 = (_154.xxxx * _9) + _79_m5;
    _154 = (_9.xyz * vs_TEXCOORD2) + _163;
    _210.w = (_26.x * _79_m6) + _9.w;
    _210.w = clamp(_210.w, 0.0f, 1.0f);
    _92 = _154 + (-_79_m2.xyz);
    _232 = vs_TEXCOORD3;
    _232 = clamp(_232, 0.0f, 1.0f);
    _92 = (_232.xxx * _92) + _79_m2.xyz;
    _210 = float4(_92.x, _92.y, _92.z, _210.w);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._210 = _210;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _20_m6[4];
float4x4 unity_MatrixVP;
static float4 _20_m7[4];
float4 _LightColor0;
float _RippleScale;
float _RippleSpeed;
void __unity_init()
{
    _20_m6[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m6[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m6[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m6[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _Time
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 unity_SHAr
#define _20_m3 unity_SHAg
#define _20_m4 unity_SHAb
#define _20_m5 unity_SHC
#define _20_m8 _LightColor0
#define _20_m9 _RippleScale
#define _20_m10 _RippleSpeed



static float4 gl_Position;
static float4 _11;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _62;
static float _98;
static float3 _149;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m6[1];
    _9 = (_20_m6[0] * _11.xxxx) + _9;
    _9 = (_20_m6[2] * _11.zzzz) + _9;
    _44 = _9 + _20_m6[3];
    float3 _59 = (_20_m6[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _44.yyyy * _20_m7[1];
    _62 = (_20_m7[0] * _44.xxxx) + _62;
    _62 = (_20_m7[2] * _44.zzzz) + _62;
    gl_Position = (_20_m7[3] * _44.wwww) + _62;
    _98 = _20_m9 * 1.7000000476837158203125f;
    _44.x = _20_m0.y * _20_m10;
    _44 = _44.xxxx * float4(1.0f, 0.60000002384185791015625f, -0.699999988079071044921875f, 1.10000002384185791015625f);
    float2 _130 = (_9.xz * _98.xx) + _44.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _130.x, _130.y);
    float2 _141 = (_9.xz * _20_m9.xx) + _44.xy;
    vs_TEXCOORD0 = float4(_141.x, _141.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    vs_TEXCOORD1 = _9.xyz;
    _149.x = dot(_20_m2.yw, 1.0f.xx);
    _149.y = dot(_20_m3.yw, 1.0f.xx);
    _149.z = dot(_20_m4.yw, 1.0f.xx);
    _149 += (-_20_m5.xyz);
    _9.x = _20_m1.y;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    float3 _191 = (_20_m8.xyz * _9.xxx) + _149;
    _9 = float4(_191.x, _191.y, _191.z, _9.w);
    vs_TEXCOORD2 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _ShallowColor;
float4 _DeepColor;
float _Sparkle;
#define _79_m0 _WorldSpaceCameraPos
#define _79_m1 _WorldSpaceLightPos0
#define _79_m2 _LightColor0
#define _79_m3 _ShallowColor
#define _79_m4 _DeepColor
#define _79_m5 _Sparkle


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _197;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _197 : SV_Target0;
};

static float4 _9;
static float4 _26;
static float _32;
static float _42;
static float _55;
static float3 _72;
static float _86;
static float3 _92;
static float _154;
static float3 _162;

void frag_inner()
{
    _9.x = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.xy).x;
    _26.x = _9.x + (-0.5f);
    _32 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0.zw).x;
    _26.z = _32 + (-0.5f);
    _42 = _32 + _9.x;
    _26.w = _42 + (-1.0f);
    _26.y = 1.5f;
    _55 = dot(_26.xyz, _26.xyz);
    _55 = rsqrt(_55);
    float3 _68 = _26.xyz * _55.xxx;
    _26 = float4(_68.x, _68.y, _68.z, _26.w);
    _72 = (-vs_TEXCOORD1) + _79_m0;
    _86 = dot(_72, _72);
    _86 = rsqrt(_86);
    _92 = (_72 * _86.xxx) + _79_m1.xyz;
    _72.x = _86 * _72.y;
    _55 = min(abs(_72.x), 1.0f);
    _55 = (-_55) + 1.0f;
    _72.x = dot(_92, _92);
    _72.x = rsqrt(_72.x);
    _72 = _72.xxx * _92;
    _26.x = dot(_26.xyz, _72);
    _26.x = clamp(_26.x, 0.0f, 1.0f);
    _26.x = log2(_26.x);
    float2 _147 = _26.xw * float2(96.0f, 0.3499999940395355224609375f);
    _26 = float4(_147.x, _26.y, _26.z, _147.y);
    _26.x = exp2(_26.x);
    _154 = _26.x * _79_m5;
    _162 = _154.xxx * _79_m2.xyz;
    _154 = _55 * _55;
    _154 = (_55 * _154) + _26.w;
    _154 = clamp(_154, 0.0f, 1.0f);
    _9 = _79_m3 + (-_79_m4);
    _9 = (_154.xxxx * _9) + _79_m4;
    float3 _204 = (_9.xyz * vs_TEXCOORD2) + _162;
    _197 = float4(_204.x, _204.y, _204.z, _197.w);
    _197.w = (_26.x * _79_m5) + _9.w;
    _197.w = clamp(_197.w, 0.0f, 1.0f);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._197 = _197;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}