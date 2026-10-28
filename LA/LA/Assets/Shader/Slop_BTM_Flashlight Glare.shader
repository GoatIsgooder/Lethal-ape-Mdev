// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BTM/Flashlight Glare" {
Properties {

_Color ("Colour", Color) = (1,0.94,0.84,1)

_Size ("Size from the side (m)", Float) = 0.14000000059604645

_Bloom ("Size head-on (m)", Float) = 0.800000011920929

_Side ("Brightness from the side", Range(0, 1)) = 0.2199999988079071

_Focus ("Head-on tightness", Range(1, 32)) = 8.0

_Pull ("Pull toward the eye (m)", Float) = 0.07000000029802322

}
SubShader {
 Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
 Name "Glare"
  Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
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
float4x4 unity_ObjectToWorld;
static float4 _18_m1[4];
float4x4 glstate_matrix_projection;
static float4 _18_m2[4];
float4x4 unity_MatrixV;
static float4 _18_m3[4];
float4 unity_FogParams;
float _Size;
float _Bloom;
float _Side;
float _Focus;
float _Pull;
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
#define _18_m4 unity_FogParams
#define _18_m5 _Size
#define _18_m6 _Bloom
#define _18_m7 _Side
#define _18_m8 _Focus
#define _18_m9 _Pull



static float4 gl_Position;
static float4 _195;
static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _195 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float _56;
static float3 _64;
static float4 _71;
static float _89;
static float2 _169;

void vert_inner()
{
    __unity_init();
    _9 = _18_m1[3].yyy * _18_m3[1].xyz;
    _9 = (_18_m3[0].xyz * _18_m1[3].xxx) + _9;
    _9 = (_18_m3[2].xyz * _18_m1[3].zzz) + _9;
    _9 += _18_m3[3].xyz;
    _56 = dot(-_9, -_9);
    _56 = rsqrt(_56);
    _64 = _56.xxx * (-_9);
    float3 _79 = _18_m0 + (-_18_m1[3].xyz);
    _71 = float4(_79.x, _79.y, _79.z, _71.w);
    _56 = dot(_71.xyz, _71.xyz);
    _56 = sqrt(_56);
    _89 = _56 * 0.5f;
    _89 = min(_89, _18_m9);
    _9 = (_64 * _89.xxx) + _9;
    _64.x = max(_56, 9.9999997473787516355514526367188e-05f);
    _56 *= (-_18_m4.y);
    _56 = exp2(_56);
    _56 = min(_56, 1.0f);
    _56 = sqrt(_56);
    _64 = _71.xyz / _64.xxx;
    _89 = dot(_18_m1[2].xyz, _18_m1[2].xyz);
    _89 = rsqrt(_89);
    float3 _143 = _89.xxx * _18_m1[2].xyz;
    _71 = float4(_143.x, _143.y, _143.z, _71.w);
    _64.x = dot(_71.xyz, _64);
    _64.x = clamp(_64.x, 0.0f, 1.0f);
    _64.x = log2(_64.x);
    _64.x *= _18_m8;
    _169.y = exp2(_64.x);
    _64.x = (-_18_m5) + _18_m6;
    _64.x = (_169.y * _64.x) + _18_m5;
    float2 _198 = _64.xx * _195.xy;
    _71 = float4(_198.x, _198.y, _71.z, _71.w);
    _71.z = 0.0f;
    _9 += _71.xyz;
    _71 = _9.yyyy * _18_m2[1];
    _71 = (_18_m2[0] * _9.xxxx) + _71;
    _71 = (_18_m2[2] * _9.zzzz) + _71;
    gl_Position = _71 + _18_m2[3];
    vs_TEXCOORD0 = _195.xy + _195.xy;
    _9.x = (-_18_m7) + 1.0f;
    _9.x = (_169.y * _9.x) + _18_m7;
    _169.x = _56 * _9.x;
    vs_TEXCOORD1 = _169;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _195 = stage_input._195;
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
#define _62_m0 _Color



static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float4 _71;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _71 : SV_Target0;
};

static float _8;
static float3 _22;
static float _35;

void frag_inner()
{
    _8 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _8 = sqrt(_8);
    _8 = min(_8, 1.0f);
    _22.x = (-_8) + 1.0f;
    _22.x *= _22.x;
    _35 = (vs_TEXCOORD1.y * 0.520000040531158447265625f) + 0.07999999821186065673828125f;
    _35 *= _22.x;
    _22.x = (_22.x * _22.x) + _35;
    _22 = _22.xxx * _62_m0.xyz;
    float3 _75 = _22 * vs_TEXCOORD1.xxx;
    _71 = float4(_75.x, _75.y, _75.z, _71.w);
    _71.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._71 = _71;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _18_m1[4];
float4x4 glstate_matrix_projection;
static float4 _18_m2[4];
float4x4 unity_MatrixV;
static float4 _18_m3[4];
float4 unity_FogParams;
float _Size;
float _Bloom;
float _Side;
float _Focus;
float _Pull;
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
#define _18_m4 unity_FogParams
#define _18_m5 _Size
#define _18_m6 _Bloom
#define _18_m7 _Side
#define _18_m8 _Focus
#define _18_m9 _Pull



static float4 gl_Position;
static float4 _196;
static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _196 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float _56;
static float3 _64;
static float4 _71;
static float _89;
static float2 _169;

void vert_inner()
{
    __unity_init();
    _9 = _18_m1[3].yyy * _18_m3[1].xyz;
    _9 = (_18_m3[0].xyz * _18_m1[3].xxx) + _9;
    _9 = (_18_m3[2].xyz * _18_m1[3].zzz) + _9;
    _9 += _18_m3[3].xyz;
    _56 = dot(-_9, -_9);
    _56 = rsqrt(_56);
    _64 = _56.xxx * (-_9);
    float3 _79 = _18_m0 + (-_18_m1[3].xyz);
    _71 = float4(_79.x, _79.y, _79.z, _71.w);
    _56 = dot(_71.xyz, _71.xyz);
    _56 = sqrt(_56);
    _89 = _56 * 0.5f;
    _89 = min(_89, _18_m9);
    _9 = (_64 * _89.xxx) + _9;
    _64.x = max(_56, 9.9999997473787516355514526367188e-05f);
    _56 *= _18_m4.x;
    _56 *= (-_56);
    _56 = exp2(_56);
    _56 = sqrt(_56);
    _64 = _71.xyz / _64.xxx;
    _89 = dot(_18_m1[2].xyz, _18_m1[2].xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _18_m1[2].xyz;
    _71 = float4(_142.x, _142.y, _142.z, _71.w);
    _64.x = dot(_71.xyz, _64);
    _64.x = clamp(_64.x, 0.0f, 1.0f);
    _64.x = log2(_64.x);
    _64.x *= _18_m8;
    _169.y = exp2(_64.x);
    _64.x = (-_18_m5) + _18_m6;
    _64.x = (_169.y * _64.x) + _18_m5;
    float2 _199 = _64.xx * _196.xy;
    _71 = float4(_199.x, _199.y, _71.z, _71.w);
    _71.z = 0.0f;
    _9 += _71.xyz;
    _71 = _9.yyyy * _18_m2[1];
    _71 = (_18_m2[0] * _9.xxxx) + _71;
    _71 = (_18_m2[2] * _9.zzzz) + _71;
    gl_Position = _71 + _18_m2[3];
    vs_TEXCOORD0 = _196.xy + _196.xy;
    _9.x = (-_18_m7) + 1.0f;
    _9.x = (_169.y * _9.x) + _18_m7;
    _169.x = _56 * _9.x;
    vs_TEXCOORD1 = _169;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _196 = stage_input._196;
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
#define _62_m0 _Color



static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float4 _71;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _71 : SV_Target0;
};

static float _8;
static float3 _22;
static float _35;

void frag_inner()
{
    _8 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _8 = sqrt(_8);
    _8 = min(_8, 1.0f);
    _22.x = (-_8) + 1.0f;
    _22.x *= _22.x;
    _35 = (vs_TEXCOORD1.y * 0.520000040531158447265625f) + 0.07999999821186065673828125f;
    _35 *= _22.x;
    _22.x = (_22.x * _22.x) + _35;
    _22 = _22.xxx * _62_m0.xyz;
    float3 _75 = _22 * vs_TEXCOORD1.xxx;
    _71 = float4(_75.x, _75.y, _75.z, _71.w);
    _71.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._71 = _71;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _18_m1[4];
float4x4 glstate_matrix_projection;
static float4 _18_m2[4];
float4x4 unity_MatrixV;
static float4 _18_m3[4];
float4 unity_FogParams;
float _Size;
float _Bloom;
float _Side;
float _Focus;
float _Pull;
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
#define _18_m4 unity_FogParams
#define _18_m5 _Size
#define _18_m6 _Bloom
#define _18_m7 _Side
#define _18_m8 _Focus
#define _18_m9 _Pull



static float4 gl_Position;
static float4 _197;
static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _197 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float _56;
static float3 _64;
static float4 _71;
static float _89;
static float2 _170;

void vert_inner()
{
    __unity_init();
    _9 = _18_m1[3].yyy * _18_m3[1].xyz;
    _9 = (_18_m3[0].xyz * _18_m1[3].xxx) + _9;
    _9 = (_18_m3[2].xyz * _18_m1[3].zzz) + _9;
    _9 += _18_m3[3].xyz;
    _56 = dot(-_9, -_9);
    _56 = rsqrt(_56);
    _64 = _56.xxx * (-_9);
    float3 _79 = _18_m0 + (-_18_m1[3].xyz);
    _71 = float4(_79.x, _79.y, _79.z, _71.w);
    _56 = dot(_71.xyz, _71.xyz);
    _56 = sqrt(_56);
    _89 = _56 * 0.5f;
    _89 = min(_89, _18_m9);
    _9 = (_64 * _89.xxx) + _9;
    _64.x = max(_56, 9.9999997473787516355514526367188e-05f);
    _56 = (_56 * _18_m4.z) + _18_m4.w;
    _56 = clamp(_56, 0.0f, 1.0f);
    _56 = sqrt(_56);
    _64 = _71.xyz / _64.xxx;
    _89 = dot(_18_m1[2].xyz, _18_m1[2].xyz);
    _89 = rsqrt(_89);
    float3 _145 = _89.xxx * _18_m1[2].xyz;
    _71 = float4(_145.x, _145.y, _145.z, _71.w);
    _64.x = dot(_71.xyz, _64);
    _64.x = clamp(_64.x, 0.0f, 1.0f);
    _64.x = log2(_64.x);
    _64.x *= _18_m8;
    _170.y = exp2(_64.x);
    _64.x = (-_18_m5) + _18_m6;
    _64.x = (_170.y * _64.x) + _18_m5;
    float2 _200 = _64.xx * _197.xy;
    _71 = float4(_200.x, _200.y, _71.z, _71.w);
    _71.z = 0.0f;
    _9 += _71.xyz;
    _71 = _9.yyyy * _18_m2[1];
    _71 = (_18_m2[0] * _9.xxxx) + _71;
    _71 = (_18_m2[2] * _9.zzzz) + _71;
    gl_Position = _71 + _18_m2[3];
    vs_TEXCOORD0 = _197.xy + _197.xy;
    _9.x = (-_18_m7) + 1.0f;
    _9.x = (_170.y * _9.x) + _18_m7;
    _170.x = _56 * _9.x;
    vs_TEXCOORD1 = _170;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _197 = stage_input._197;
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
#define _62_m0 _Color



static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float4 _71;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _71 : SV_Target0;
};

static float _8;
static float3 _22;
static float _35;

void frag_inner()
{
    _8 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _8 = sqrt(_8);
    _8 = min(_8, 1.0f);
    _22.x = (-_8) + 1.0f;
    _22.x *= _22.x;
    _35 = (vs_TEXCOORD1.y * 0.520000040531158447265625f) + 0.07999999821186065673828125f;
    _35 *= _22.x;
    _22.x = (_22.x * _22.x) + _35;
    _22 = _22.xxx * _62_m0.xyz;
    float3 _75 = _22 * vs_TEXCOORD1.xxx;
    _71 = float4(_75.x, _75.y, _75.z, _71.w);
    _71.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._71 = _71;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _18_m1[4];
float4x4 glstate_matrix_projection;
static float4 _18_m2[4];
float4x4 unity_MatrixV;
static float4 _18_m3[4];
float _Size;
float _Bloom;
float _Side;
float _Focus;
float _Pull;
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
#define _18_m5 _Bloom
#define _18_m6 _Side
#define _18_m7 _Focus
#define _18_m8 _Pull



static float4 gl_Position;
static float4 _187;
static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _187 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float _67;
static float3 _78;
static float4 _85;
static float _103;
static float2 _164;

void vert_inner()
{
    __unity_init();
    float3 _29 = _18_m1[3].yyy * _18_m3[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _42 = (_18_m3[0].xyz * _18_m1[3].xxx) + _9.xyz;
    _9 = float4(_42.x, _42.y, _42.z, _9.w);
    float3 _55 = (_18_m3[2].xyz * _18_m1[3].zzz) + _9.xyz;
    _9 = float4(_55.x, _55.y, _55.z, _9.w);
    float3 _63 = _9.xyz + _18_m3[3].xyz;
    _9 = float4(_63.x, _63.y, _63.z, _9.w);
    _67 = dot(-_9.xyz, -_9.xyz);
    _67 = rsqrt(_67);
    _78 = _67.xxx * (-_9.xyz);
    float3 _93 = _18_m0 + (-_18_m1[3].xyz);
    _85 = float4(_93.x, _93.y, _93.z, _85.w);
    _67 = dot(_85.xyz, _85.xyz);
    _67 = sqrt(_67);
    _103 = _67 * 0.5f;
    _67 = max(_67, 9.9999997473787516355514526367188e-05f);
    float3 _114 = _85.xyz / _67.xxx;
    _85 = float4(_114.x, _114.y, _114.z, _85.w);
    _67 = min(_103, _18_m8);
    float3 _129 = (_78 * _67.xxx) + _9.xyz;
    _9 = float4(_129.x, _129.y, _129.z, _9.w);
    _67 = dot(_18_m1[2].xyz, _18_m1[2].xyz);
    _67 = rsqrt(_67);
    _78 = _67.xxx * _18_m1[2].xyz;
    _67 = dot(_78, _85.xyz);
    _67 = clamp(_67, 0.0f, 1.0f);
    _67 = log2(_67);
    _67 *= _18_m7;
    _164.y = exp2(_67);
    _67 = (-_18_m4) + _18_m5;
    _67 = (_164.y * _67) + _18_m4;
    float2 _190 = _67.xx * _187.xy;
    _85 = float4(_190.x, _190.y, _85.z, _85.w);
    _85.z = 0.0f;
    float3 _199 = _9.xyz + _85.xyz;
    _9 = float4(_199.x, _199.y, _199.z, _9.w);
    _85 = _9.yyyy * _18_m2[1];
    _85 = (_18_m2[0] * _9.xxxx) + _85;
    _9 = (_18_m2[2] * _9.zzzz) + _85;
    gl_Position = _9 + _18_m2[3];
    vs_TEXCOORD0 = _187.xy + _187.xy;
    _9.x = (-_18_m6) + 1.0f;
    _164.x = (_164.y * _9.x) + _18_m6;
    vs_TEXCOORD1 = _164;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _187 = stage_input._187;
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
#define _62_m0 _Color



static float2 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float4 _71;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _71 : SV_Target0;
};

static float _8;
static float3 _22;
static float _35;

void frag_inner()
{
    _8 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _8 = sqrt(_8);
    _8 = min(_8, 1.0f);
    _22.x = (-_8) + 1.0f;
    _22.x *= _22.x;
    _35 = (vs_TEXCOORD1.y * 0.520000040531158447265625f) + 0.07999999821186065673828125f;
    _35 *= _22.x;
    _22.x = (_22.x * _22.x) + _35;
    _22 = _22.xxx * _62_m0.xyz;
    float3 _75 = _22 * vs_TEXCOORD1.xxx;
    _71 = float4(_75.x, _75.y, _75.z, _71.w);
    _71.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._71 = _71;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}