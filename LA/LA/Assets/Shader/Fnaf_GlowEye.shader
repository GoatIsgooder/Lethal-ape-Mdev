// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Fnaf/GlowEye" {
Properties {

_Color ("Color (driven at runtime)", Color) = (0,0,0,1)

_Core ("Core Radius", Range(0.02, 0.5)) = 0.1599999964237213

_Halo ("Halo Strength", Range(0, 1)) = 0.3499999940395355

_Size ("Billboard Size (m)", Float) = 0.05999999865889549

_Lift ("Toward Camera (m)", Float) = 0.006000000052154064

_Facing ("Facing Fade Start (dot)", Range(-1, 1)) = 0.25

}
SubShader {
 LOD 100
 Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One One
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _18_m1[4];
float4x4 glstate_matrix_projection;
static float4 _18_m2[4];
float4x4 unity_MatrixV;
static float4 _18_m3[4];
float _Size;
float _Lift;
float _Facing;
void __unity_init()
{
    _18_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _18_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _18_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _18_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _18_m2[0] = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]);
    _18_m2[1] = float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
    _18_m2[2] = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]);
    _18_m2[3] = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]);
    _18_m3[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _18_m3[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _18_m3[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _18_m3[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _18_m0 _WorldSpaceCameraPos
#define _18_m4 _Size
#define _18_m5 _Lift
#define _18_m6 _Facing



static float4 gl_Position;
static float2 _73;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float2 _73 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _70;
static float _158;

void vert_inner()
{
    __unity_init();
    float3 _29 = _18_m1[3].yyy * _18_m3[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _42 = (_18_m3[0].xyz * _18_m1[3].xxx) + _9.xyz;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    float3 _55 = (_18_m3[2].xyz * _18_m1[3].zzz) + _9.xyz;
    _9 = float4(_55.x, _55.y, _55.z, _9.w);
    float3 _67 = (_18_m3[3].xyz * _18_m1[3].www) + _9.xyz;
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    float2 _77 = _73 + (-0.5f).xx;
    _70 = float4(_77.x, _77.y, _70.z, _70.w);
    float2 _87 = _70.xy * _18_m4.xx;
    _70 = float4(_87.x, _87.y, _70.z, _70.w);
    _70.z = 0.0f;
    float3 _98 = _9.xyz + _70.xyz;
    _9 = float4(_98.x, _98.y, _98.z, _9.w);
    _70 = _9.yyyy * _18_m2[1];
    _70 = (_18_m2[0] * _9.xxxx) + _70;
    _9.x = _9.z + _18_m5;
    _9 = (_18_m2[2] * _9.xxxx) + _70;
    gl_Position = _9 + _18_m2[3];
    vs_TEXCOORD0 = (_73 * 2.0f.xx) + (-1.0f).xx;
    float3 _155 = _18_m0 + (-_18_m1[3].xyz);
    _9 = float4(_155.x, _155.y, _155.z, _9.w);
    _158 = dot(_9.xyz, _9.xyz);
    _158 = rsqrt(_158);
    float3 _170 = _158.xxx * _9.xyz;
    _9 = float4(_170.x, _170.y, _170.z, _9.w);
    _158 = dot(_18_m1[2].xyz, _18_m1[2].xyz);
    _158 = rsqrt(_158);
    float3 _187 = _158.xxx * _18_m1[2].xyz;
    _70 = float4(_187.x, _187.y, _187.z, _70.w);
    _9.x = dot(_70.xyz, _9.xyz);
    _9.x += (-_18_m6);
    _9.x *= 2.857142925262451171875f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _73 = stage_input._73;
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
float _Core;
float _Halo;
#define _33_m0 _Color
#define _33_m1 _Core
#define _33_m2 _Halo



static float2 vs_TEXCOORD0;
static float4 _83;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _83 : SV_Target0;
};

static float _8;
static float3 _19;
static float _27;
static float _45;

void frag_inner()
{
    _8 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _8 = sqrt(_8);
    _19.x = (-_8) + 1.0f;
    _27 = (-_8) + _33_m1;
    _19.x = max(_19.x, 0.0f);
    _45 = _19.x * _19.x;
    _19.x = _45 * _19.x;
    _45 = _33_m1 * 0.3499999940395355224609375f;
    _27 /= _45;
    _27 = clamp(_27, 0.0f, 1.0f);
    _19.x = (_33_m2 * _19.x) + _27;
    _19 = _19.xxx * _33_m0.xyz;
    float3 _89 = _19 * vs_TEXCOORD1.xxx;
    _83 = float4(_89.x, _89.y, _89.z, _83.w);
    _83.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._83 = _83;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}