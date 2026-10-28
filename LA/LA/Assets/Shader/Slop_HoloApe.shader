// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/HoloApe" {
Properties {

_FillColor ("Body", Color) = (0,0,0,0.6)

_RimColor ("Rim", Color) = (1,1,1,1)

_RimPower ("Rim Power", Range(0.5, 8)) = 2.5999999046325684

_RimStrength ("Rim Strength", Range(0, 3)) = 1.0

_LineColor ("Scanlines", Color) = (1,1,1,0.14)

_LineDensity ("Scanlines Per Metre", Float) = 150.0

_LineThickness ("Scanline Thickness", Range(0.05, 0.9)) = 0.3199999928474426

_LineSpeed ("Scanline Speed (m/s)", Float) = 0.02500000037252903

_BandColor ("Sweep Band", Color) = (1,1,1,0.28)

_BandPeriod ("Sweep Period (s)", Float) = 5.0

_BandRange ("Sweep Range (m from the ape root, min, max)", Vector) = (-0.5,0.72,0,0)

_BandWidth ("Sweep Width (m)", Float) = 0.05000000074505806

_OutlineColor ("Outline", Color) = (1,1,1,0.9)

_OutlinePixels ("Outline Width (px)", Float) = 1.600000023841858

_NearFade ("Near Fade (start, end) m", Vector) = (0.2,0.3,0,0)

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+20" "RenderType" = "Transparent" }
 Pass {
Cull Back
ZWrite On
 Name "DEPTH"
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+20" "RenderType" = "Transparent" }
   ColorMask 0
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
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
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _43;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m0[1];
    _9 = (_20_m0[0] * _11.xxxx) + _9;
    _9 = (_20_m0[2] * _11.zzzz) + _9;
    _43 = _9 + _20_m0[3];
    vs_TEXCOORD0 = (_20_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _43.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _43.xxxx) + _9;
    _9 = (_20_m1[2] * _43.zzzz) + _9;
    gl_Position = (_20_m1[3] * _43.wwww) + _9;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _NearFade;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _NearFade



static float3 vs_TEXCOORD0;
static float4 _99;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _99 : SV_Target0;
};

static float3 _9;
static float _44;
static bool _86;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-_16_m0);
    _9.x = dot(_9, _9);
    _9.x = sqrt(_9.x);
    _9.x += (-_16_m1.x);
    _44 = (-_16_m1.x) + _16_m1.y;
    _44 = 1.0f / _44;
    _9.x = _44 * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _44 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x = (_44 * _9.x) + (-0.5f);
    _86 = _9.x < 0.0f;
    if ((int(_86) * (-1)) != 0)
    {
        discard;
    }
    _99 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._99 = _99;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
 Name "OUTLINE"
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+20" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Front
   Blend One OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4 _ScreenParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_WorldToObject;
static float4 _20_m2[4];
float4x4 glstate_matrix_projection;
static float4 _20_m3[4];
float4x4 unity_MatrixInvV;
static float4 _20_m4[4];
float4x4 unity_MatrixVP;
static float4 _20_m5[4];
float _OutlinePixels;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _20_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _20_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _20_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _20_m3[0] = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]);
    _20_m3[1] = float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
    _20_m3[2] = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]);
    _20_m3[3] = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]);
    _20_m4[0] = float4(unity_MatrixInvV[0][0], unity_MatrixInvV[1][0], unity_MatrixInvV[2][0], unity_MatrixInvV[3][0]);
    _20_m4[1] = float4(unity_MatrixInvV[0][1], unity_MatrixInvV[1][1], unity_MatrixInvV[2][1], unity_MatrixInvV[3][1]);
    _20_m4[2] = float4(unity_MatrixInvV[0][2], unity_MatrixInvV[1][2], unity_MatrixInvV[2][2], unity_MatrixInvV[3][2]);
    _20_m4[3] = float4(unity_MatrixInvV[0][3], unity_MatrixInvV[1][3], unity_MatrixInvV[2][3], unity_MatrixInvV[3][3]);
    _20_m5[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m5[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m5[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m5[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ScreenParams
#define _20_m6 _OutlinePixels



static float4 gl_Position;
static float3 _64;
static float4 _186;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _186 : POSITION;
    float3 _64 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float4 _80;
static float _126;
static bool _158;
static float _162;
static float4 _206;

void vert_inner()
{
    __unity_init();
    _9 = _20_m2[1].xyz * _20_m4[1].yyy;
    _9 = (_20_m2[0].xyz * _20_m4[1].xxx) + _9;
    _9 = (_20_m2[2].xyz * _20_m4[1].zzz) + _9;
    _9 = (_20_m2[3].xyz * _20_m4[1].www) + _9;
    _9.x = dot(_9, _64);
    float2 _76 = _9.xx * _20_m3[1].xy;
    _9 = float3(_76.x, _76.y, _9.z);
    float3 _87 = _20_m2[1].xyz * _20_m4[0].yyy;
    _80 = float4(_87.x, _87.y, _87.z, _80.w);
    float3 _99 = (_20_m2[0].xyz * _20_m4[0].xxx) + _80.xyz;
    _80 = float4(_99.x, _99.y, _99.z, _80.w);
    float3 _111 = (_20_m2[2].xyz * _20_m4[0].zzz) + _80.xyz;
    _80 = float4(_111.x, _111.y, _111.z, _80.w);
    float3 _123 = (_20_m2[3].xyz * _20_m4[0].www) + _80.xyz;
    _80 = float4(_123.x, _123.y, _123.z, _80.w);
    _126 = dot(_80.xyz, _64);
    float2 _139 = (_20_m3[0].xy * _126.xx) + _9.xy;
    _9 = float3(_139.x, _139.y, _9.z);
    _126 = dot(_9.xy, _9.xy);
    _126 = sqrt(_126);
    float2 _153 = _9.xy / _126.xx;
    _9 = float3(_153.x, _153.y, _9.z);
    _158 = 9.9999997473787516355514526367188e-06f < _126;
    _162 = _20_m6 + _20_m6;
    float2 _175 = _162.xx / _20_m0.xy;
    _80 = float4(_175.x, _175.y, _80.z, _80.w);
    float2 _182 = _9.xy * _80.xy;
    _9 = float3(_182.x, _182.y, _9.z);
    _80 = _186.yyyy * _20_m1[1];
    _80 = (_20_m1[0] * _186.xxxx) + _80;
    _80 = (_20_m1[2] * _186.zzzz) + _80;
    _206 = _80 + _20_m1[3];
    vs_TEXCOORD0 = (_20_m1[3].xyz * _186.www) + _80.xyz;
    _80 = _206.yyyy * _20_m5[1];
    _80 = (_20_m5[0] * _206.xxxx) + _80;
    _80 = (_20_m5[2] * _206.zzzz) + _80;
    _80 = (_20_m5[3] * _206.wwww) + _80;
    float2 _256 = (_9.xy * _80.ww) + _80.xy;
    _9 = float3(_256.x, _256.y, _9.z);
    float2 _266;
    if (_158)
    {
        _266 = _9.xy;
    }
    else
    {
        _266 = _80.xy;
    }
    gl_Position = float4(_266.x, _266.y, gl_Position.z, gl_Position.w);
    gl_Position = float4(gl_Position.x, gl_Position.y, _80.zw.x, _80.zw.y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _64 = stage_input._64;
    _186 = stage_input._186;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _OutlineColor;
float4 _NearFade;
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _OutlineColor
#define _16_m2 _NearFade



static float3 vs_TEXCOORD0;
static float4 _91;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _91 : SV_Target0;
};

static float3 _9;
static float _44;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-_16_m0);
    _9.x = dot(_9, _9);
    _9.x = sqrt(_9.x);
    _9.x += (-_16_m2.x);
    _44 = (-_16_m2.x) + _16_m2.y;
    _44 = 1.0f / _44;
    _9.x = _44 * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _44 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _44;
    _9.x *= _16_m1.w;
    float3 _98 = _9.xxx * _16_m1.xyz;
    _91 = float4(_98.x, _98.y, _98.z, _91.w);
    _91.w = _9.x;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._91 = _91;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
Cull Back
 Name "BODY"
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+20" "RenderType" = "Transparent" }
 ZWrite Off
   Blend One OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float _HoloApeOriginY;
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m3 _HoloApeOriginY



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 _111;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _111 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _62;
static float _132;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    float3 _59 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _44.yyyy * _21_m2[1];
    _62 = (_21_m2[0] * _44.xxxx) + _62;
    _62 = (_21_m2[2] * _44.zzzz) + _62;
    gl_Position = (_21_m2[3] * _44.wwww) + _62;
    vs_TEXCOORD2 = _9.y + (-_21_m3);
    vs_TEXCOORD0 = _9.xyz;
    _9.x = dot(_111, _21_m1[0].xyz);
    _9.y = dot(_111, _21_m1[1].xyz);
    _9.z = dot(_111, _21_m1[2].xyz);
    _132 = dot(_9.xyz, _9.xyz);
    _132 = rsqrt(_132);
    vs_TEXCOORD1 = _132.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _111 = stage_input._111;
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
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _FillColor;
float4 _RimColor;
float4 _LineColor;
float4 _BandColor;
float _RimPower;
float _RimStrength;
float _LineDensity;
float _LineThickness;
float _LineSpeed;
float _BandPeriod;
float _BandWidth;
float4 _BandRange;
float4 _NearFade;
#define _13_m0 _Time
#define _13_m1 _WorldSpaceCameraPos
#define _13_m2 _FillColor
#define _13_m3 _RimColor
#define _13_m4 _LineColor
#define _13_m5 _BandColor
#define _13_m6 _RimPower
#define _13_m7 _RimStrength
#define _13_m8 _LineDensity
#define _13_m9 _LineThickness
#define _13_m10 _LineSpeed
#define _13_m11 _BandPeriod
#define _13_m12 _BandWidth
#define _13_m13 _BandRange
#define _13_m14 _NearFade



static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _406;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _406 : SV_Target0;
};

static float _8;
static float3 _32;
static float _55;
static float _82;
static float4 _158;
static float3 _190;
static float _272;
static float3 _331;

void frag_inner()
{
    _8 = (_13_m0.y * _13_m10) + vs_TEXCOORD0.y;
    _32.x = (_8 * _13_m8) + 0.5f;
    _8 *= _13_m8;
    _32.x = frac(_32.x);
    _32.x += (-0.5f);
    _55 = ddx_coarse(_8);
    _8 = ddy_coarse(_8);
    _8 = abs(_8) + abs(_55);
    _8 = max(_8, 9.9999997473787516355514526367188e-05f);
    _55 = (_13_m9 * 0.5f) + (-_8);
    _32.x = (-_55) + abs(_32.x);
    _82 = (_13_m9 * 0.5f) + _8;
    _8 += (-0.25f);
    _8 *= 4.0f;
    _8 = clamp(_8, 0.0f, 1.0f);
    _55 = (-_55) + _82;
    _55 = 1.0f / _55;
    _32.x = _55 * _32.x;
    _32.x = clamp(_32.x, 0.0f, 1.0f);
    _55 = (_32.x * (-2.0f)) + 3.0f;
    _32.x *= _32.x;
    _32.x = ((-_55) * _32.x) + 1.0f;
    _55 = (-_32.x) + _13_m9;
    _8 = (_8 * _55) + _32.x;
    _32.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _32.x = rsqrt(_32.x);
    _32 = _32.xxx * vs_TEXCOORD1;
    _158.x = ((-abs(_32.y)) * 1.35000002384185791015625f) + 1.0f;
    _158.x = max(_158.x, 0.0f);
    _8 *= _158.x;
    _8 *= _13_m4.w;
    float3 _187 = _8.xxx * _13_m4.xyz;
    _158 = float4(_187.x, _187.y, _187.z, _158.w);
    _190 = (-vs_TEXCOORD0) + _13_m1;
    _8 = dot(_190, _190);
    _8 = rsqrt(_8);
    _190 = _8.xxx * _190;
    _8 = dot(_32, _190);
    _8 = clamp(_8, 0.0f, 1.0f);
    _8 = (-_8) + 1.0f;
    _8 = log2(_8);
    _8 *= _13_m6;
    _8 = exp2(_8);
    _8 *= _13_m7;
    _32 = (_13_m3.xyz * _8.xxx) + _158.xyz;
    _8 = (_8 * 0.3499999940395355224609375f) + _13_m2.w;
    _8 = clamp(_8, 0.0f, 1.0f);
    float2 _259 = max(float2(_13_m11, _13_m12), float2(0.100000001490116119384765625f, 0.001000000047497451305389404296875f));
    _158 = float4(_259.x, _259.y, _158.z, _158.w);
    _158.x = _13_m0.y / _158.x;
    _158.x = frac(_158.x);
    _272 = (-_13_m13.x) + _13_m13.y;
    _158.x = (_158.x * _272) + _13_m13.x;
    _158.x = (-_158.x) + vs_TEXCOORD2;
    _158.x /= _158.y;
    _158.x *= _158.x;
    _158.x *= (-1.44269502162933349609375f);
    _158.x = exp2(_158.x);
    _158.x *= _13_m5.w;
    _32 = (_13_m5.xyz * _158.xxx) + _32;
    _331 = (_13_m2.xyz * _13_m2.www) + _32;
    _32 = vs_TEXCOORD0 + (-_13_m1);
    _32.x = dot(_32, _32);
    _32.x = sqrt(_32.x);
    _32.x += (-_13_m14.x);
    _55 = (-_13_m14.x) + _13_m14.y;
    _55 = 1.0f / _55;
    _32.x = _55 * _32.x;
    _32.x = clamp(_32.x, 0.0f, 1.0f);
    _55 = (_32.x * (-2.0f)) + 3.0f;
    _32.x *= _32.x;
    _32.x *= _55;
    float3 _397 = _32.xxx * _331;
    _158 = float4(_397.x, _397.y, _397.z, _158.w);
    _158.w = _32.x * _8;
    _406 = _158;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._406 = _406;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}