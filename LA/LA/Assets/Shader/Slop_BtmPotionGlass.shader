// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmPotionGlass" {
Properties {

_Color ("Glass Tint (A = base opacity)", Color) = (0.78,0.9,0.86,0.07)

_RimColor ("Edge Color (A = edge opacity)", Color) = (0.62,0.78,0.74,0.7)

_RimPower ("Edge Power", Range(0.5, 8)) = 2.5999999046325684

_StreakColor ("Streak Color", Color) = (1,0.93,0.8,1)

_StreakPos ("Streak View X", Range(-1, 1)) = -0.41999998688697815

_StreakWidth ("Streak Width", Range(0.01, 0.4)) = 0.07000000029802322

_BandHeight ("Sky Band Reflect Y", Range(-1, 1)) = 0.550000011920929

_BandWidth ("Sky Band Width", Range(0.01, 0.6)) = 0.11999999731779099

_BandStrength ("Sky Band Strength", Range(0, 1)) = 0.3499999940395355

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
Cull Back
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _23_m1[4];
float4x4 unity_WorldToObject;
static float4 _23_m2[4];
float4x4 unity_MatrixV;
static float4 _23_m3[4];
float4x4 unity_MatrixVP;
static float4 _23_m4[4];
float _RimPower;
void __unity_init()
{
    _23_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _23_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _23_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _23_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _23_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _23_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _23_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _23_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _23_m3[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _23_m3[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _23_m3[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _23_m3[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
    _23_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _23_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _23_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _23_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _23_m0 _WorldSpaceCameraPos
#define _23_m5 _RimPower



static float4 gl_Position;
static float4 _11;
static float3 _124;
static float vs_TEXCOORD2;
static float vs_TEXCOORD0;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _124 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _46;
static float4 _72;
static float _108;
static float _159;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _23_m1[1];
    _9 = (_23_m1[0] * _11.xxxx) + _9;
    _9 = (_23_m1[2] * _11.zzzz) + _9;
    _46 = _9 + _23_m1[3];
    float3 _60 = (_23_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_60.x, _60.y, _60.z, _9.w);
    float3 _69 = (-_9.xyz) + _23_m0;
    _9 = float4(_69.x, _69.y, _69.z, _9.w);
    _72 = _46.yyyy * _23_m4[1];
    _72 = (_23_m4[0] * _46.xxxx) + _72;
    _72 = (_23_m4[2] * _46.zzzz) + _72;
    gl_Position = (_23_m4[3] * _46.wwww) + _72;
    _108 = dot(_9.xyz, _9.xyz);
    _108 = rsqrt(_108);
    float3 _120 = _108.xxx * _9.xyz;
    _9 = float4(_120.x, _120.y, _120.z, _9.w);
    _46.x = dot(_124, _23_m2[0].xyz);
    _46.y = dot(_124, _23_m2[1].xyz);
    _46.z = dot(_124, _23_m2[2].xyz);
    _108 = dot(_46.xyz, _46.xyz);
    _108 = rsqrt(_108);
    float3 _156 = _108.xxx * _46.xyz;
    _46 = float4(_156.x, _156.y, _156.z, _46.w);
    _159 = dot(-_9.xyz, _46.xyz);
    _159 += _159;
    vs_TEXCOORD2 = (_46.y * (-_159)) + (-_9.y);
    _159 = dot(_46.xyz, _9.xyz);
    _159 = clamp(_159, 0.0f, 1.0f);
    _159 = (-_159) + 1.0f;
    _159 = log2(_159);
    _159 *= _23_m5;
    vs_TEXCOORD0 = exp2(_159);
    _9.x = _46.y * _23_m3[1].x;
    _9.x = (_23_m3[0].x * _46.x) + _9.x;
    _9.x = (_23_m3[2].x * _46.z) + _9.x;
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _124 = stage_input._124;
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
float4 _Color;
float4 _RimColor;
float4 _StreakColor;
float _StreakPos;
float _StreakWidth;
float _BandHeight;
float _BandWidth;
float _BandStrength;
#define _23_m0 _Color
#define _23_m1 _RimColor
#define _23_m2 _StreakColor
#define _23_m3 _StreakPos
#define _23_m4 _StreakWidth
#define _23_m5 _BandHeight
#define _23_m6 _BandWidth
#define _23_m7 _BandStrength



static float vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _177;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _177 : SV_Target0;
};

static float4 _9;
static float _20;
static float3 _36;
static float3 _84;

void frag_inner()
{
    _9 = float4(vs_TEXCOORD0, vs_TEXCOORD1, vs_TEXCOORD2, 0.0f);
    _20 = _23_m4 * 0.60000002384185791015625f;
    _20 = 1.0f / _20;
    _36.x = (_23_m3 * 1.4500000476837158203125f) + _9.y;
    _20 *= abs(_36.x);
    _20 = clamp(_20, 0.0f, 1.0f);
    _36.x = (_20 * (-2.0f)) + 3.0f;
    _20 *= _20;
    _20 = ((-_36.x) * _20) + 1.0f;
    float2 _81 = _9.yz + (-float2(_23_m3, _23_m5));
    _36 = float3(_81.x, _81.y, _36.z);
    float2 _92 = 1.0f.xx / float2(_23_m4, _23_m6);
    _84 = float3(_92.x, _92.y, _84.z);
    float2 _100 = abs(_36.xy) * _84.xy;
    _36 = float3(_100.x, _100.y, _36.z);
    float2 _107 = clamp(_36.xy, 0.0f.xx, 1.0f.xx);
    _36 = float3(_107.x, _107.y, _36.z);
    float2 _115 = (_36.xy * (-2.0f).xx) + 3.0f.xx;
    _84 = float3(_115.x, _115.y, _84.z);
    float2 _122 = _36.xy * _36.xy;
    _36 = float3(_122.x, _122.y, _36.z);
    float2 _131 = ((-_84.xy) * _36.xy) + 1.0f.xx;
    _36 = float3(_131.x, _131.y, _36.z);
    _20 = (_20 * 0.3499999940395355224609375f) + _36.x;
    _20 = (_36.y * _23_m7) + _20;
    _20 = clamp(_20, 0.0f, 1.0f);
    _36 = (-_23_m0.xyz) + _23_m1.xyz;
    _36 = (_9.xxx * _36) + _23_m0.xyz;
    _84 = (-_36) + _23_m2.xyz;
    float3 _183 = (_20.xxx * _84) + _36;
    _177 = float4(_183.x, _183.y, _183.z, _177.w);
    _20 *= _23_m2.w;
    _36.x = (_9.x * _23_m1.w) + _23_m0.w;
    _177.w = (_20 * 0.85000002384185791015625f) + _36.x;
    _177.w = clamp(_177.w, 0.0f, 1.0f);
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._177 = _177;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}