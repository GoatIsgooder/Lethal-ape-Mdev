// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/IceSurf" {
Properties {

_DeepColor ("Deep", Color) = (0.13,0.46,0.82,0.88)

_ShallowColor ("Shallow", Color) = (0.66,0.91,1,0.7)

_FrostColor ("Frost", Color) = (0.92,0.98,1,1)

_Glow ("Self Glow", Range(0, 1)) = 0.3499999940395355

_RimPower ("Rim Power", Range(0.5, 8)) = 2.5

_EdgeFrost ("Edge Frost Width", Range(0, 0.5)) = 0.11999999731779099

_StreakScale ("Streak Scale", Float) = 1.2999999523162842

_SpecPower ("Spec Power", Range(4, 256)) = 96.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
Cull Back
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
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



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _131;
static float3 _134;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _296;
static float4 _297;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _134 : NORMAL;
    float2 _131 : TEXCOORD0;
    float4 _297 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _296 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _51;
static float _154;
static float3 _223;
static float4 _240;
static float3 _246;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m9[1];
    _9 = (_22_m9[0] * _11.xxxx) + _9;
    _9 = (_22_m9[2] * _11.zzzz) + _9;
    _9 += _22_m9[3];
    _51 = _9.yyyy * _22_m11[1];
    _51 = (_22_m11[0] * _9.xxxx) + _51;
    _51 = (_22_m11[2] * _9.zzzz) + _51;
    _9 = (_22_m11[3] * _9.wwww) + _51;
    gl_Position = _9;
    _9.x = _9.z / _22_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _22_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _22_m12.y;
    vs_TEXCOORD4 = exp2(-_9.x);
    vs_TEXCOORD0 = _131;
    _9.x = dot(_134, _22_m10[0].xyz);
    _9.y = dot(_134, _22_m10[1].xyz);
    _9.z = dot(_134, _22_m10[2].xyz);
    _154 = dot(_9.xyz, _9.xyz);
    _154 = rsqrt(_154);
    float3 _166 = _154.xxx * _9.xyz;
    _9 = float4(_166.x, _166.y, _166.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    float3 _178 = _11.yyy * _22_m9[1].xyz;
    _51 = float4(_178.x, _178.y, _178.z, _51.w);
    float3 _189 = (_22_m9[0].xyz * _11.xxx) + _51.xyz;
    _51 = float4(_189.x, _189.y, _189.z, _51.w);
    float3 _200 = (_22_m9[2].xyz * _11.zzz) + _51.xyz;
    _51 = float4(_200.x, _200.y, _200.z, _51.w);
    float3 _211 = (_22_m9[3].xyz * _11.www) + _51.xyz;
    _51 = float4(_211.x, _211.y, _211.z, _51.w);
    vs_TEXCOORD2 = (-_51.xyz) + _22_m0;
    _223.x = _9.y * _9.y;
    _223.x = (_9.x * _9.x) + (-_223.x);
    _240 = _9.yzzx * _9.xyzz;
    _246.x = dot(_22_m5, _240);
    _246.y = dot(_22_m6, _240);
    _246.z = dot(_22_m7, _240);
    _223 = (_22_m8.xyz * _223.xxx) + _246;
    _9.w = 1.0f;
    _246.x = dot(_22_m2, _9);
    _246.y = dot(_22_m3, _9);
    _246.z = dot(_22_m4, _9);
    vs_TEXCOORD3 = _223 + _246;
    _296 = _297;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _131 = stage_input._131;
    _134 = stage_input._134;
    _297 = stage_input._297;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._296 = _296;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _DeepColor;
float4 _ShallowColor;
float4 _FrostColor;
float _Glow;
float _RimPower;
float _EdgeFrost;
float _StreakScale;
float _SpecPower;
#define _21_m0 _WorldSpaceLightPos0
#define _21_m1 unity_FogColor
#define _21_m2 _LightColor0
#define _21_m3 _DeepColor
#define _21_m4 _ShallowColor
#define _21_m5 _FrostColor
#define _21_m6 _Glow
#define _21_m7 _RimPower
#define _21_m8 _EdgeFrost
#define _21_m9 _StreakScale
#define _21_m10 _SpecPower



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _261;
static float vs_TEXCOORD4;
static float4 _356;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _261 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _356 : SV_Target0;
};

static float3 _9;
static float _31;
static float2 _36;
static float3 _141;
static float3 _155;
static float _168;
static float _182;
static float4 _203;
static float3 _220;
static float3 _228;
static float4 _258;
static float3 _320;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.y * _21_m9;
    _31 = sin(_9.x);
    _36 = vs_TEXCOORD0.xx * float2(31.0f, 9.0f);
    _9.y = (_31 * 2.5f) + _36.x;
    _9.x = (_9.x * 3.099999904632568359375f) + _36.y;
    float2 _60 = sin(_9.xy);
    _9 = float3(_60.x, _60.y, _9.z);
    _9.x = (_9.y * _9.x) + (-0.60000002384185791015625f);
    _9.x *= 2.7027027606964111328125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _31;
    _31 = (-vs_TEXCOORD0.x) + 1.0f;
    _31 = min(_31, vs_TEXCOORD0.x);
    _36.x = 1.0f / _21_m8;
    _31 = _36.x * _31;
    _31 = clamp(_31, 0.0f, 1.0f);
    _36.x = (_31 * (-2.0f)) + 3.0f;
    _31 *= _31;
    _31 = ((-_36.x) * _31) + 1.0f;
    _36.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _36.x = rsqrt(_36.x);
    _141 = _36.xxx * vs_TEXCOORD1;
    _36.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _36.x = rsqrt(_36.x);
    _155 = _36.xxx * vs_TEXCOORD2;
    _36.x = dot(_141, _155);
    _36.x = clamp(_36.x, 0.0f, 1.0f);
    _168 = (-_36.x) + 1.0f;
    _168 = log2(_168);
    _168 *= _21_m7;
    _168 = exp2(_168);
    _182 = _168 * 0.550000011920928955078125f;
    _182 = (_31 * 0.85000002384185791015625f) + _182;
    _9.x = (_9.x * 0.300000011920928955078125f) + _182;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _203 = (-_21_m3) + _21_m4;
    _203 = (_36.xxxx * _203) + _21_m3;
    _220 = vs_TEXCOORD3 + _21_m6.xxx;
    _228 = _203.xyz * _220;
    float3 _242 = ((-_203.xyz) * _220) + _21_m5.xyz;
    _203 = float4(_242.x, _242.y, _242.z, _203.w);
    _31 = (_31 * 0.25f) + _203.w;
    _31 = (_168 * 0.300000011920928955078125f) + _31;
    _31 = clamp(_31, 0.0f, 1.0f);
    _258.w = _31 * _261.w;
    _9 = (_9.xxx * _203.xyz) + _228;
    float3 _280 = _21_m0.xyz + float3(0.25f, 0.89999997615814208984375f, 0.1500000059604644775390625f);
    _203 = float4(_280.x, _280.y, _280.z, _203.w);
    _168 = dot(_203.xyz, _203.xyz);
    _168 = rsqrt(_168);
    _155 = (_203.xyz * _168.xxx) + _155;
    _168 = dot(_155, _155);
    _168 = rsqrt(_168);
    _155 = _168.xxx * _155;
    _168 = dot(_141, _155);
    _168 = clamp(_168, 0.0f, 1.0f);
    _168 = log2(_168);
    _168 *= _21_m10;
    _168 = exp2(_168);
    _320 = _21_m2.xyz + 0.4000000059604644775390625f.xxx;
    _9 = (_168.xxx * _320) + _9;
    _9 += (-_21_m1.xyz);
    _168 = vs_TEXCOORD4;
    _168 = clamp(_168, 0.0f, 1.0f);
    float3 _352 = (_168.xxx * _9) + _21_m1.xyz;
    _258 = float4(_352.x, _352.y, _352.z, _258.w);
    _356 = _258;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    _261 = stage_input._261;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._356 = _356;
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



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _137;
static float3 _140;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _302;
static float4 _303;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _140 : NORMAL;
    float2 _137 : TEXCOORD0;
    float4 _303 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _302 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _51;
static float _160;
static float3 _229;
static float4 _246;
static float3 _252;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m9[1];
    _9 = (_22_m9[0] * _11.xxxx) + _9;
    _9 = (_22_m9[2] * _11.zzzz) + _9;
    _9 += _22_m9[3];
    _51 = _9.yyyy * _22_m11[1];
    _51 = (_22_m11[0] * _9.xxxx) + _51;
    _51 = (_22_m11[2] * _9.zzzz) + _51;
    _9 = (_22_m11[3] * _9.wwww) + _51;
    gl_Position = _9;
    _9.x = _9.z / _22_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _22_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _22_m12.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD4 = exp2(_9.x);
    vs_TEXCOORD0 = _137;
    _9.x = dot(_140, _22_m10[0].xyz);
    _9.y = dot(_140, _22_m10[1].xyz);
    _9.z = dot(_140, _22_m10[2].xyz);
    _160 = dot(_9.xyz, _9.xyz);
    _160 = rsqrt(_160);
    float3 _172 = _160.xxx * _9.xyz;
    _9 = float4(_172.x, _172.y, _172.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    float3 _184 = _11.yyy * _22_m9[1].xyz;
    _51 = float4(_184.x, _184.y, _184.z, _51.w);
    float3 _195 = (_22_m9[0].xyz * _11.xxx) + _51.xyz;
    _51 = float4(_195.x, _195.y, _195.z, _51.w);
    float3 _206 = (_22_m9[2].xyz * _11.zzz) + _51.xyz;
    _51 = float4(_206.x, _206.y, _206.z, _51.w);
    float3 _217 = (_22_m9[3].xyz * _11.www) + _51.xyz;
    _51 = float4(_217.x, _217.y, _217.z, _51.w);
    vs_TEXCOORD2 = (-_51.xyz) + _22_m0;
    _229.x = _9.y * _9.y;
    _229.x = (_9.x * _9.x) + (-_229.x);
    _246 = _9.yzzx * _9.xyzz;
    _252.x = dot(_22_m5, _246);
    _252.y = dot(_22_m6, _246);
    _252.z = dot(_22_m7, _246);
    _229 = (_22_m8.xyz * _229.xxx) + _252;
    _9.w = 1.0f;
    _252.x = dot(_22_m2, _9);
    _252.y = dot(_22_m3, _9);
    _252.z = dot(_22_m4, _9);
    vs_TEXCOORD3 = _229 + _252;
    _302 = _303;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _137 = stage_input._137;
    _140 = stage_input._140;
    _303 = stage_input._303;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._302 = _302;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _DeepColor;
float4 _ShallowColor;
float4 _FrostColor;
float _Glow;
float _RimPower;
float _EdgeFrost;
float _StreakScale;
float _SpecPower;
#define _21_m0 _WorldSpaceLightPos0
#define _21_m1 unity_FogColor
#define _21_m2 _LightColor0
#define _21_m3 _DeepColor
#define _21_m4 _ShallowColor
#define _21_m5 _FrostColor
#define _21_m6 _Glow
#define _21_m7 _RimPower
#define _21_m8 _EdgeFrost
#define _21_m9 _StreakScale
#define _21_m10 _SpecPower



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _261;
static float vs_TEXCOORD4;
static float4 _356;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _261 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _356 : SV_Target0;
};

static float3 _9;
static float _31;
static float2 _36;
static float3 _141;
static float3 _155;
static float _168;
static float _182;
static float4 _203;
static float3 _220;
static float3 _228;
static float4 _258;
static float3 _320;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.y * _21_m9;
    _31 = sin(_9.x);
    _36 = vs_TEXCOORD0.xx * float2(31.0f, 9.0f);
    _9.y = (_31 * 2.5f) + _36.x;
    _9.x = (_9.x * 3.099999904632568359375f) + _36.y;
    float2 _60 = sin(_9.xy);
    _9 = float3(_60.x, _60.y, _9.z);
    _9.x = (_9.y * _9.x) + (-0.60000002384185791015625f);
    _9.x *= 2.7027027606964111328125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _31;
    _31 = (-vs_TEXCOORD0.x) + 1.0f;
    _31 = min(_31, vs_TEXCOORD0.x);
    _36.x = 1.0f / _21_m8;
    _31 = _36.x * _31;
    _31 = clamp(_31, 0.0f, 1.0f);
    _36.x = (_31 * (-2.0f)) + 3.0f;
    _31 *= _31;
    _31 = ((-_36.x) * _31) + 1.0f;
    _36.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _36.x = rsqrt(_36.x);
    _141 = _36.xxx * vs_TEXCOORD1;
    _36.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _36.x = rsqrt(_36.x);
    _155 = _36.xxx * vs_TEXCOORD2;
    _36.x = dot(_141, _155);
    _36.x = clamp(_36.x, 0.0f, 1.0f);
    _168 = (-_36.x) + 1.0f;
    _168 = log2(_168);
    _168 *= _21_m7;
    _168 = exp2(_168);
    _182 = _168 * 0.550000011920928955078125f;
    _182 = (_31 * 0.85000002384185791015625f) + _182;
    _9.x = (_9.x * 0.300000011920928955078125f) + _182;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _203 = (-_21_m3) + _21_m4;
    _203 = (_36.xxxx * _203) + _21_m3;
    _220 = vs_TEXCOORD3 + _21_m6.xxx;
    _228 = _203.xyz * _220;
    float3 _242 = ((-_203.xyz) * _220) + _21_m5.xyz;
    _203 = float4(_242.x, _242.y, _242.z, _203.w);
    _31 = (_31 * 0.25f) + _203.w;
    _31 = (_168 * 0.300000011920928955078125f) + _31;
    _31 = clamp(_31, 0.0f, 1.0f);
    _258.w = _31 * _261.w;
    _9 = (_9.xxx * _203.xyz) + _228;
    float3 _280 = _21_m0.xyz + float3(0.25f, 0.89999997615814208984375f, 0.1500000059604644775390625f);
    _203 = float4(_280.x, _280.y, _280.z, _203.w);
    _168 = dot(_203.xyz, _203.xyz);
    _168 = rsqrt(_168);
    _155 = (_203.xyz * _168.xxx) + _155;
    _168 = dot(_155, _155);
    _168 = rsqrt(_168);
    _155 = _168.xxx * _155;
    _168 = dot(_141, _155);
    _168 = clamp(_168, 0.0f, 1.0f);
    _168 = log2(_168);
    _168 *= _21_m10;
    _168 = exp2(_168);
    _320 = _21_m2.xyz + 0.4000000059604644775390625f.xxx;
    _9 = (_168.xxx * _320) + _9;
    _9 += (-_21_m1.xyz);
    _168 = vs_TEXCOORD4;
    _168 = clamp(_168, 0.0f, 1.0f);
    float3 _352 = (_168.xxx * _9) + _21_m1.xyz;
    _258 = float4(_352.x, _352.y, _352.z, _258.w);
    _356 = _258;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    _261 = stage_input._261;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._356 = _356;
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



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _130;
static float3 _133;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _294;
static float4 _295;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _133 : NORMAL;
    float2 _130 : TEXCOORD0;
    float4 _295 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _294 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _51;
static float _153;
static float3 _222;
static float4 _239;
static float3 _245;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m9[1];
    _9 = (_22_m9[0] * _11.xxxx) + _9;
    _9 = (_22_m9[2] * _11.zzzz) + _9;
    _9 += _22_m9[3];
    _51 = _9.yyyy * _22_m11[1];
    _51 = (_22_m11[0] * _9.xxxx) + _51;
    _51 = (_22_m11[2] * _9.zzzz) + _51;
    _9 = (_22_m11[3] * _9.wwww) + _51;
    gl_Position = _9;
    _9.x = _9.z / _22_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _22_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD4 = (_9.x * _22_m12.z) + _22_m12.w;
    vs_TEXCOORD0 = _130;
    _9.x = dot(_133, _22_m10[0].xyz);
    _9.y = dot(_133, _22_m10[1].xyz);
    _9.z = dot(_133, _22_m10[2].xyz);
    _153 = dot(_9.xyz, _9.xyz);
    _153 = rsqrt(_153);
    float3 _165 = _153.xxx * _9.xyz;
    _9 = float4(_165.x, _165.y, _165.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    float3 _177 = _11.yyy * _22_m9[1].xyz;
    _51 = float4(_177.x, _177.y, _177.z, _51.w);
    float3 _188 = (_22_m9[0].xyz * _11.xxx) + _51.xyz;
    _51 = float4(_188.x, _188.y, _188.z, _51.w);
    float3 _199 = (_22_m9[2].xyz * _11.zzz) + _51.xyz;
    _51 = float4(_199.x, _199.y, _199.z, _51.w);
    float3 _210 = (_22_m9[3].xyz * _11.www) + _51.xyz;
    _51 = float4(_210.x, _210.y, _210.z, _51.w);
    vs_TEXCOORD2 = (-_51.xyz) + _22_m0;
    _222.x = _9.y * _9.y;
    _222.x = (_9.x * _9.x) + (-_222.x);
    _239 = _9.yzzx * _9.xyzz;
    _245.x = dot(_22_m5, _239);
    _245.y = dot(_22_m6, _239);
    _245.z = dot(_22_m7, _239);
    _222 = (_22_m8.xyz * _222.xxx) + _245;
    _9.w = 1.0f;
    _245.x = dot(_22_m2, _9);
    _245.y = dot(_22_m3, _9);
    _245.z = dot(_22_m4, _9);
    vs_TEXCOORD3 = _222 + _245;
    _294 = _295;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _130 = stage_input._130;
    _133 = stage_input._133;
    _295 = stage_input._295;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._294 = _294;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _DeepColor;
float4 _ShallowColor;
float4 _FrostColor;
float _Glow;
float _RimPower;
float _EdgeFrost;
float _StreakScale;
float _SpecPower;
#define _21_m0 _WorldSpaceLightPos0
#define _21_m1 unity_FogColor
#define _21_m2 _LightColor0
#define _21_m3 _DeepColor
#define _21_m4 _ShallowColor
#define _21_m5 _FrostColor
#define _21_m6 _Glow
#define _21_m7 _RimPower
#define _21_m8 _EdgeFrost
#define _21_m9 _StreakScale
#define _21_m10 _SpecPower



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _261;
static float vs_TEXCOORD4;
static float4 _356;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 _261 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _356 : SV_Target0;
};

static float3 _9;
static float _31;
static float2 _36;
static float3 _141;
static float3 _155;
static float _168;
static float _182;
static float4 _203;
static float3 _220;
static float3 _228;
static float4 _258;
static float3 _320;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.y * _21_m9;
    _31 = sin(_9.x);
    _36 = vs_TEXCOORD0.xx * float2(31.0f, 9.0f);
    _9.y = (_31 * 2.5f) + _36.x;
    _9.x = (_9.x * 3.099999904632568359375f) + _36.y;
    float2 _60 = sin(_9.xy);
    _9 = float3(_60.x, _60.y, _9.z);
    _9.x = (_9.y * _9.x) + (-0.60000002384185791015625f);
    _9.x *= 2.7027027606964111328125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _31;
    _31 = (-vs_TEXCOORD0.x) + 1.0f;
    _31 = min(_31, vs_TEXCOORD0.x);
    _36.x = 1.0f / _21_m8;
    _31 = _36.x * _31;
    _31 = clamp(_31, 0.0f, 1.0f);
    _36.x = (_31 * (-2.0f)) + 3.0f;
    _31 *= _31;
    _31 = ((-_36.x) * _31) + 1.0f;
    _36.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _36.x = rsqrt(_36.x);
    _141 = _36.xxx * vs_TEXCOORD1;
    _36.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _36.x = rsqrt(_36.x);
    _155 = _36.xxx * vs_TEXCOORD2;
    _36.x = dot(_141, _155);
    _36.x = clamp(_36.x, 0.0f, 1.0f);
    _168 = (-_36.x) + 1.0f;
    _168 = log2(_168);
    _168 *= _21_m7;
    _168 = exp2(_168);
    _182 = _168 * 0.550000011920928955078125f;
    _182 = (_31 * 0.85000002384185791015625f) + _182;
    _9.x = (_9.x * 0.300000011920928955078125f) + _182;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _203 = (-_21_m3) + _21_m4;
    _203 = (_36.xxxx * _203) + _21_m3;
    _220 = vs_TEXCOORD3 + _21_m6.xxx;
    _228 = _203.xyz * _220;
    float3 _242 = ((-_203.xyz) * _220) + _21_m5.xyz;
    _203 = float4(_242.x, _242.y, _242.z, _203.w);
    _31 = (_31 * 0.25f) + _203.w;
    _31 = (_168 * 0.300000011920928955078125f) + _31;
    _31 = clamp(_31, 0.0f, 1.0f);
    _258.w = _31 * _261.w;
    _9 = (_9.xxx * _203.xyz) + _228;
    float3 _280 = _21_m0.xyz + float3(0.25f, 0.89999997615814208984375f, 0.1500000059604644775390625f);
    _203 = float4(_280.x, _280.y, _280.z, _203.w);
    _168 = dot(_203.xyz, _203.xyz);
    _168 = rsqrt(_168);
    _155 = (_203.xyz * _168.xxx) + _155;
    _168 = dot(_155, _155);
    _168 = rsqrt(_168);
    _155 = _168.xxx * _155;
    _168 = dot(_141, _155);
    _168 = clamp(_168, 0.0f, 1.0f);
    _168 = log2(_168);
    _168 *= _21_m10;
    _168 = exp2(_168);
    _320 = _21_m2.xyz + 0.4000000059604644775390625f.xxx;
    _9 = (_168.xxx * _320) + _9;
    _9 += (-_21_m1.xyz);
    _168 = vs_TEXCOORD4;
    _168 = clamp(_168, 0.0f, 1.0f);
    float3 _352 = (_168.xxx * _9) + _21_m1.xyz;
    _258 = float4(_352.x, _352.y, _352.z, _258.w);
    _356 = _258;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    _261 = stage_input._261;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._356 = _356;
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



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _90;
static float3 _93;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _258;
static float4 _259;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _93 : NORMAL;
    float2 _90 : TEXCOORD0;
    float4 _259 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _258 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _51;
static float _116;
static float3 _185;
static float4 _202;
static float3 _208;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m8[1];
    _9 = (_22_m8[0] * _11.xxxx) + _9;
    _9 = (_22_m8[2] * _11.zzzz) + _9;
    _9 += _22_m8[3];
    _51 = _9.yyyy * _22_m10[1];
    _51 = (_22_m10[0] * _9.xxxx) + _51;
    _51 = (_22_m10[2] * _9.zzzz) + _51;
    gl_Position = (_22_m10[3] * _9.wwww) + _51;
    vs_TEXCOORD0 = _90;
    _9.x = dot(_93, _22_m9[0].xyz);
    _9.y = dot(_93, _22_m9[1].xyz);
    _9.z = dot(_93, _22_m9[2].xyz);
    _116 = dot(_9.xyz, _9.xyz);
    _116 = rsqrt(_116);
    float3 _128 = _116.xxx * _9.xyz;
    _9 = float4(_128.x, _128.y, _128.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
    float3 _140 = _11.yyy * _22_m8[1].xyz;
    _51 = float4(_140.x, _140.y, _140.z, _51.w);
    float3 _151 = (_22_m8[0].xyz * _11.xxx) + _51.xyz;
    _51 = float4(_151.x, _151.y, _151.z, _51.w);
    float3 _162 = (_22_m8[2].xyz * _11.zzz) + _51.xyz;
    _51 = float4(_162.x, _162.y, _162.z, _51.w);
    float3 _173 = (_22_m8[3].xyz * _11.www) + _51.xyz;
    _51 = float4(_173.x, _173.y, _173.z, _51.w);
    vs_TEXCOORD2 = (-_51.xyz) + _22_m0;
    _185.x = _9.y * _9.y;
    _185.x = (_9.x * _9.x) + (-_185.x);
    _202 = _9.yzzx * _9.xyzz;
    _208.x = dot(_22_m4, _202);
    _208.y = dot(_22_m5, _202);
    _208.z = dot(_22_m6, _202);
    _185 = (_22_m7.xyz * _185.xxx) + _208;
    _9.w = 1.0f;
    _208.x = dot(_22_m1, _9);
    _208.y = dot(_22_m2, _9);
    _208.z = dot(_22_m3, _9);
    vs_TEXCOORD3 = _185 + _208;
    _258 = _259;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _90 = stage_input._90;
    _93 = stage_input._93;
    _259 = stage_input._259;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output._258 = _258;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _DeepColor;
float4 _ShallowColor;
float4 _FrostColor;
float _Glow;
float _RimPower;
float _EdgeFrost;
float _StreakScale;
float _SpecPower;
#define _21_m0 _WorldSpaceLightPos0
#define _21_m1 _LightColor0
#define _21_m2 _DeepColor
#define _21_m3 _ShallowColor
#define _21_m4 _FrostColor
#define _21_m5 _Glow
#define _21_m6 _RimPower
#define _21_m7 _EdgeFrost
#define _21_m8 _StreakScale
#define _21_m9 _SpecPower



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float4 _261;
static float4 _337;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 _261 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _337 : SV_Target0;
};

static float3 _9;
static float _31;
static float2 _36;
static float3 _141;
static float3 _155;
static float _168;
static float _182;
static float4 _203;
static float3 _220;
static float3 _228;
static float4 _258;
static float3 _320;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.y * _21_m8;
    _31 = sin(_9.x);
    _36 = vs_TEXCOORD0.xx * float2(31.0f, 9.0f);
    _9.y = (_31 * 2.5f) + _36.x;
    _9.x = (_9.x * 3.099999904632568359375f) + _36.y;
    float2 _60 = sin(_9.xy);
    _9 = float3(_60.x, _60.y, _9.z);
    _9.x = (_9.y * _9.x) + (-0.60000002384185791015625f);
    _9.x *= 2.7027027606964111328125f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _31 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _31;
    _31 = (-vs_TEXCOORD0.x) + 1.0f;
    _31 = min(_31, vs_TEXCOORD0.x);
    _36.x = 1.0f / _21_m7;
    _31 = _36.x * _31;
    _31 = clamp(_31, 0.0f, 1.0f);
    _36.x = (_31 * (-2.0f)) + 3.0f;
    _31 *= _31;
    _31 = ((-_36.x) * _31) + 1.0f;
    _36.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _36.x = rsqrt(_36.x);
    _141 = _36.xxx * vs_TEXCOORD1;
    _36.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _36.x = rsqrt(_36.x);
    _155 = _36.xxx * vs_TEXCOORD2;
    _36.x = dot(_141, _155);
    _36.x = clamp(_36.x, 0.0f, 1.0f);
    _168 = (-_36.x) + 1.0f;
    _168 = log2(_168);
    _168 *= _21_m6;
    _168 = exp2(_168);
    _182 = _168 * 0.550000011920928955078125f;
    _182 = (_31 * 0.85000002384185791015625f) + _182;
    _9.x = (_9.x * 0.300000011920928955078125f) + _182;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _203 = (-_21_m2) + _21_m3;
    _203 = (_36.xxxx * _203) + _21_m2;
    _220 = vs_TEXCOORD3 + _21_m5.xxx;
    _228 = _203.xyz * _220;
    float3 _242 = ((-_203.xyz) * _220) + _21_m4.xyz;
    _203 = float4(_242.x, _242.y, _242.z, _203.w);
    _31 = (_31 * 0.25f) + _203.w;
    _31 = (_168 * 0.300000011920928955078125f) + _31;
    _31 = clamp(_31, 0.0f, 1.0f);
    _258.w = _31 * _261.w;
    _9 = (_9.xxx * _203.xyz) + _228;
    float3 _280 = _21_m0.xyz + float3(0.25f, 0.89999997615814208984375f, 0.1500000059604644775390625f);
    _203 = float4(_280.x, _280.y, _280.z, _203.w);
    _168 = dot(_203.xyz, _203.xyz);
    _168 = rsqrt(_168);
    _155 = (_203.xyz * _168.xxx) + _155;
    _168 = dot(_155, _155);
    _168 = rsqrt(_168);
    _155 = _168.xxx * _155;
    _168 = dot(_141, _155);
    _168 = clamp(_168, 0.0f, 1.0f);
    _168 = log2(_168);
    _168 *= _21_m9;
    _168 = exp2(_168);
    _320 = _21_m1.xyz + 0.4000000059604644775390625f.xxx;
    float3 _333 = (_168.xxx * _320) + _9;
    _258 = float4(_333.x, _333.y, _333.z, _258.w);
    _337 = _258;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    _261 = stage_input._261;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._337 = _337;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}