// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Glowerboi/GlowGlowGlow" {
Properties {

_Color ("Color", Color) = (1,0.66,0.36,1)

_Size ("Size (m)", Float) = 1.100000023841858

_Pull ("Pull toward camera (m)", Float) = 0.44999998807907104

_Flicker ("Flicker", Range(0, 1)) = 0.15000000596046448

_FlickerSpeed ("Flicker speed", Float) = 7.0

}
SubShader {
 Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
 Name "Halo"
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
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _18_m2[4];
float4x4 glstate_matrix_projection;
static float4 _18_m3[4];
float4x4 unity_MatrixV;
static float4 _18_m4[4];
float4 unity_FogParams;
float _Size;
float _Pull;
float _Flicker;
float _FlickerSpeed;
void __unity_init()
{
    _18_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _18_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _18_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _18_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _18_m3[0] = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]);
    _18_m3[1] = float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
    _18_m3[2] = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]);
    _18_m3[3] = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]);
    _18_m4[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _18_m4[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _18_m4[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _18_m4[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _18_m0 _Time
#define _18_m1 _ProjectionParams
#define _18_m5 unity_FogParams
#define _18_m6 _Size
#define _18_m7 _Pull
#define _18_m8 _Flicker
#define _18_m9 _FlickerSpeed



static float4 gl_Position;
static float4 _141;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _141 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float _57;
static float4 _64;
static float _84;
static bool _127;
static float3 _136;
static float4 _214;
static float _272;

void vert_inner()
{
    __unity_init();
    _9 = _18_m2[3].yyy * _18_m4[1].xyz;
    _9 = (_18_m4[0].xyz * _18_m2[3].xxx) + _9;
    _9 = (_18_m4[2].xyz * _18_m2[3].zzz) + _9;
    _9 += _18_m4[3].xyz;
    _57 = dot(_9, _9);
    _57 = sqrt(_57);
    _64.x = _57 * 0.5f;
    _64.x = min(_64.x, _18_m7);
    _64.x = _57 + (-_64.x);
    _84 = max(_57, 9.9999997473787516355514526367188e-05f);
    _57 = ((-_18_m6) * 0.20000000298023223876953125f) + _57;
    _64.x /= _84;
    _84 = _18_m6 * 0.400000035762786865234375f;
    _84 = 1.0f / _84;
    _57 *= _84;
    _57 = clamp(_57, 0.0f, 1.0f);
    _84 = (_57 * (-2.0f)) + 3.0f;
    _57 *= _57;
    _57 *= _84;
    _127 = _57 >= 9.9999997473787516355514526367188e-05f;
    _84 = float(_127);
    _84 *= _18_m6;
    float2 _144 = _84.xx * _141.xy;
    _136 = float3(_144.x, _144.y, _136.z);
    _136.z = 0.0f;
    _9 = (_9 * _64.xxx) + _136;
    _64 = _9.yyyy * _18_m3[1];
    _64 = (_18_m3[0] * _9.xxxx) + _64;
    _64 = (_18_m3[2] * _9.zzzz) + _64;
    _64 += _18_m3[3];
    gl_Position = _64;
    _9.x = _64.z / _18_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _18_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _18_m5.y;
    _214.w = exp2(-_9.x);
    _9.x = dot(_18_m2[3].xyz, float3(12.98980045318603515625f, 78.233001708984375f, 37.71900177001953125f));
    _9 = _9.xxx * float3(0.15915499627590179443359375f, 0.638212025165557861328125f, 0.864211976528167724609375f);
    _9 = frac(_9);
    _9 *= 6.283185482025146484375f.xxx;
    _9.x = (_18_m0.y * _18_m9) + _9.x;
    _64.x = _18_m0.y * _18_m9;
    float2 _267 = (_64.xx * float2(2.309999942779541015625f, 5.13000011444091796875f)) + _9.yz;
    _9 = float3(_9.x, _267.x, _267.y);
    _9 = sin(_9);
    _272 = _9.y * 0.300000011920928955078125f;
    _9.x = (_9.x * 0.5f) + _272;
    _9.x = (_9.z * 0.20000000298023223876953125f) + _9.x;
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = ((-_18_m8) * _9.x) + 1.0f;
    _9.z = _57 * _9.x;
    float2 _313 = _141.xy * 2.0f.xx;
    _9 = float3(_313.x, _313.y, _9.z);
    _214 = float4(_9.x, _9.y, _9.z, _214.w);
    vs_TEXCOORD0 = _214.xy;
    vs_TEXCOORD1 = _214.z;
    vs_TEXCOORD2 = _214.w;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _141 = stage_input._141;
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
float4 _Color;
#define _51_m0 _Color



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _78;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _78 : SV_Target0;
};

static float3 _9;
static float _35;
static float3 _65;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _35 = _9.x * _9.x;
    _9.x *= _35;
    _9 = _9.xxx * _51_m0.xyz;
    _9 *= vs_TEXCOORD1.xxx;
    _65.x = vs_TEXCOORD2;
    _65.x = clamp(_65.x, 0.0f, 1.0f);
    _65 = _9 * _65.xxx;
    _78 = float4(_65.x, _65.y, _65.z, _78.w);
    _78.w = 0.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._78 = _78;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _18_m2[4];
float4x4 glstate_matrix_projection;
static float4 _18_m3[4];
float4x4 unity_MatrixV;
static float4 _18_m4[4];
float4 unity_FogParams;
float _Size;
float _Pull;
float _Flicker;
float _FlickerSpeed;
void __unity_init()
{
    _18_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _18_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _18_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _18_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _18_m3[0] = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]);
    _18_m3[1] = float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
    _18_m3[2] = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]);
    _18_m3[3] = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]);
    _18_m4[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _18_m4[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _18_m4[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _18_m4[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _18_m0 _Time
#define _18_m1 _ProjectionParams
#define _18_m5 unity_FogParams
#define _18_m6 _Size
#define _18_m7 _Pull
#define _18_m8 _Flicker
#define _18_m9 _FlickerSpeed



static float4 gl_Position;
static float4 _141;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _141 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float _57;
static float4 _64;
static float _84;
static bool _127;
static float3 _136;
static float4 _221;
static float _278;

void vert_inner()
{
    __unity_init();
    _9 = _18_m2[3].yyy * _18_m4[1].xyz;
    _9 = (_18_m4[0].xyz * _18_m2[3].xxx) + _9;
    _9 = (_18_m4[2].xyz * _18_m2[3].zzz) + _9;
    _9 += _18_m4[3].xyz;
    _57 = dot(_9, _9);
    _57 = sqrt(_57);
    _64.x = _57 * 0.5f;
    _64.x = min(_64.x, _18_m7);
    _64.x = _57 + (-_64.x);
    _84 = max(_57, 9.9999997473787516355514526367188e-05f);
    _57 = ((-_18_m6) * 0.20000000298023223876953125f) + _57;
    _64.x /= _84;
    _84 = _18_m6 * 0.400000035762786865234375f;
    _84 = 1.0f / _84;
    _57 *= _84;
    _57 = clamp(_57, 0.0f, 1.0f);
    _84 = (_57 * (-2.0f)) + 3.0f;
    _57 *= _57;
    _57 *= _84;
    _127 = _57 >= 9.9999997473787516355514526367188e-05f;
    _84 = float(_127);
    _84 *= _18_m6;
    float2 _144 = _84.xx * _141.xy;
    _136 = float3(_144.x, _144.y, _136.z);
    _136.z = 0.0f;
    _9 = (_9 * _64.xxx) + _136;
    _64 = _9.yyyy * _18_m3[1];
    _64 = (_18_m3[0] * _9.xxxx) + _64;
    _64 = (_18_m3[2] * _9.zzzz) + _64;
    _64 += _18_m3[3];
    gl_Position = _64;
    _9.x = _64.z / _18_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _18_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _18_m5.x;
    _9.x *= (-_9.x);
    _221.w = exp2(_9.x);
    _9.x = dot(_18_m2[3].xyz, float3(12.98980045318603515625f, 78.233001708984375f, 37.71900177001953125f));
    _9 = _9.xxx * float3(0.15915499627590179443359375f, 0.638212025165557861328125f, 0.864211976528167724609375f);
    _9 = frac(_9);
    _9 *= 6.283185482025146484375f.xxx;
    _9.x = (_18_m0.y * _18_m9) + _9.x;
    _64.x = _18_m0.y * _18_m9;
    float2 _273 = (_64.xx * float2(2.309999942779541015625f, 5.13000011444091796875f)) + _9.yz;
    _9 = float3(_9.x, _273.x, _273.y);
    _9 = sin(_9);
    _278 = _9.y * 0.300000011920928955078125f;
    _9.x = (_9.x * 0.5f) + _278;
    _9.x = (_9.z * 0.20000000298023223876953125f) + _9.x;
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = ((-_18_m8) * _9.x) + 1.0f;
    _9.z = _57 * _9.x;
    float2 _319 = _141.xy * 2.0f.xx;
    _9 = float3(_319.x, _319.y, _9.z);
    _221 = float4(_9.x, _9.y, _9.z, _221.w);
    vs_TEXCOORD0 = _221.xy;
    vs_TEXCOORD1 = _221.z;
    vs_TEXCOORD2 = _221.w;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _141 = stage_input._141;
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
float4 _Color;
#define _51_m0 _Color



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _78;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _78 : SV_Target0;
};

static float3 _9;
static float _35;
static float3 _65;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _35 = _9.x * _9.x;
    _9.x *= _35;
    _9 = _9.xxx * _51_m0.xyz;
    _9 *= vs_TEXCOORD1.xxx;
    _65.x = vs_TEXCOORD2;
    _65.x = clamp(_65.x, 0.0f, 1.0f);
    _65 = _9 * _65.xxx;
    _78 = float4(_65.x, _65.y, _65.z, _78.w);
    _78.w = 0.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._78 = _78;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _18_m2[4];
float4x4 glstate_matrix_projection;
static float4 _18_m3[4];
float4x4 unity_MatrixV;
static float4 _18_m4[4];
float4 unity_FogParams;
float _Size;
float _Pull;
float _Flicker;
float _FlickerSpeed;
void __unity_init()
{
    _18_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _18_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _18_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _18_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _18_m3[0] = float4(glstate_matrix_projection[0][0], glstate_matrix_projection[1][0], glstate_matrix_projection[2][0], glstate_matrix_projection[3][0]);
    _18_m3[1] = float4(glstate_matrix_projection[0][1], glstate_matrix_projection[1][1], glstate_matrix_projection[2][1], glstate_matrix_projection[3][1]);
    _18_m3[2] = float4(glstate_matrix_projection[0][2], glstate_matrix_projection[1][2], glstate_matrix_projection[2][2], glstate_matrix_projection[3][2]);
    _18_m3[3] = float4(glstate_matrix_projection[0][3], glstate_matrix_projection[1][3], glstate_matrix_projection[2][3], glstate_matrix_projection[3][3]);
    _18_m4[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _18_m4[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _18_m4[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _18_m4[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _18_m0 _Time
#define _18_m1 _ProjectionParams
#define _18_m5 unity_FogParams
#define _18_m6 _Size
#define _18_m7 _Pull
#define _18_m8 _Flicker
#define _18_m9 _FlickerSpeed



static float4 gl_Position;
static float4 _141;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _141 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float _57;
static float4 _64;
static float _84;
static bool _127;
static float3 _136;
static float4 _207;
static float _270;

void vert_inner()
{
    __unity_init();
    _9 = _18_m2[3].yyy * _18_m4[1].xyz;
    _9 = (_18_m4[0].xyz * _18_m2[3].xxx) + _9;
    _9 = (_18_m4[2].xyz * _18_m2[3].zzz) + _9;
    _9 += _18_m4[3].xyz;
    _57 = dot(_9, _9);
    _57 = sqrt(_57);
    _64.x = _57 * 0.5f;
    _64.x = min(_64.x, _18_m7);
    _64.x = _57 + (-_64.x);
    _84 = max(_57, 9.9999997473787516355514526367188e-05f);
    _57 = ((-_18_m6) * 0.20000000298023223876953125f) + _57;
    _64.x /= _84;
    _84 = _18_m6 * 0.400000035762786865234375f;
    _84 = 1.0f / _84;
    _57 *= _84;
    _57 = clamp(_57, 0.0f, 1.0f);
    _84 = (_57 * (-2.0f)) + 3.0f;
    _57 *= _57;
    _57 *= _84;
    _127 = _57 >= 9.9999997473787516355514526367188e-05f;
    _84 = float(_127);
    _84 *= _18_m6;
    float2 _144 = _84.xx * _141.xy;
    _136 = float3(_144.x, _144.y, _136.z);
    _136.z = 0.0f;
    _9 = (_9 * _64.xxx) + _136;
    _64 = _9.yyyy * _18_m3[1];
    _64 = (_18_m3[0] * _9.xxxx) + _64;
    _64 = (_18_m3[2] * _9.zzzz) + _64;
    _64 += _18_m3[3];
    gl_Position = _64;
    _9.x = _64.z / _18_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _18_m1.z;
    _9.x = max(_9.x, 0.0f);
    _207.w = (_9.x * _18_m5.z) + _18_m5.w;
    _9.x = dot(_18_m2[3].xyz, float3(12.98980045318603515625f, 78.233001708984375f, 37.71900177001953125f));
    _9 = _9.xxx * float3(0.15915499627590179443359375f, 0.638212025165557861328125f, 0.864211976528167724609375f);
    _9 = frac(_9);
    _9 *= 6.283185482025146484375f.xxx;
    _9.x = (_18_m0.y * _18_m9) + _9.x;
    _64.x = _18_m0.y * _18_m9;
    float2 _265 = (_64.xx * float2(2.309999942779541015625f, 5.13000011444091796875f)) + _9.yz;
    _9 = float3(_9.x, _265.x, _265.y);
    _9 = sin(_9);
    _270 = _9.y * 0.300000011920928955078125f;
    _9.x = (_9.x * 0.5f) + _270;
    _9.x = (_9.z * 0.20000000298023223876953125f) + _9.x;
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = ((-_18_m8) * _9.x) + 1.0f;
    _9.z = _57 * _9.x;
    float2 _311 = _141.xy * 2.0f.xx;
    _9 = float3(_311.x, _311.y, _9.z);
    _207 = float4(_9.x, _9.y, _9.z, _207.w);
    vs_TEXCOORD0 = _207.xy;
    vs_TEXCOORD1 = _207.z;
    vs_TEXCOORD2 = _207.w;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _141 = stage_input._141;
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
float4 _Color;
#define _51_m0 _Color



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _78;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _78 : SV_Target0;
};

static float3 _9;
static float _35;
static float3 _65;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _35 = _9.x * _9.x;
    _9.x *= _35;
    _9 = _9.xxx * _51_m0.xyz;
    _9 *= vs_TEXCOORD1.xxx;
    _65.x = vs_TEXCOORD2;
    _65.x = clamp(_65.x, 0.0f, 1.0f);
    _65 = _9 * _65.xxx;
    _78 = float4(_65.x, _65.y, _65.z, _78.w);
    _78.w = 0.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._78 = _78;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _18_m1[4];
float4x4 glstate_matrix_projection;
static float4 _18_m2[4];
float4x4 unity_MatrixV;
static float4 _18_m3[4];
float _Size;
float _Pull;
float _Flicker;
float _FlickerSpeed;
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
#define _18_m0 _Time
#define _18_m4 _Size
#define _18_m5 _Pull
#define _18_m6 _Flicker
#define _18_m7 _FlickerSpeed



static float4 gl_Position;
static float4 _140;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _140 : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float _56;
static float4 _63;
static float _83;
static bool _126;
static float3 _135;
static float _235;
static float4 _279;

void vert_inner()
{
    __unity_init();
    _9 = _18_m1[3].yyy * _18_m3[1].xyz;
    _9 = (_18_m3[0].xyz * _18_m1[3].xxx) + _9;
    _9 = (_18_m3[2].xyz * _18_m1[3].zzz) + _9;
    _9 += _18_m3[3].xyz;
    _56 = dot(_9, _9);
    _56 = sqrt(_56);
    _63.x = _56 * 0.5f;
    _63.x = min(_63.x, _18_m5);
    _63.x = _56 + (-_63.x);
    _83 = max(_56, 9.9999997473787516355514526367188e-05f);
    _56 = ((-_18_m4) * 0.20000000298023223876953125f) + _56;
    _63.x /= _83;
    _83 = _18_m4 * 0.400000035762786865234375f;
    _83 = 1.0f / _83;
    _56 *= _83;
    _56 = clamp(_56, 0.0f, 1.0f);
    _83 = (_56 * (-2.0f)) + 3.0f;
    _56 *= _56;
    _56 *= _83;
    _126 = _56 >= 9.9999997473787516355514526367188e-05f;
    _83 = float(_126);
    _83 *= _18_m4;
    float2 _143 = _83.xx * _140.xy;
    _135 = float3(_143.x, _143.y, _135.z);
    _135.z = 0.0f;
    _9 = (_9 * _63.xxx) + _135;
    _63 = _9.yyyy * _18_m2[1];
    _63 = (_18_m2[0] * _9.xxxx) + _63;
    _63 = (_18_m2[2] * _9.zzzz) + _63;
    gl_Position = _63 + _18_m2[3];
    _9.x = dot(_18_m1[3].xyz, float3(12.98980045318603515625f, 78.233001708984375f, 37.71900177001953125f));
    _9 = _9.xxx * float3(0.15915499627590179443359375f, 0.638212025165557861328125f, 0.864211976528167724609375f);
    _9 = frac(_9);
    _9 *= 6.283185482025146484375f.xxx;
    _9.x = (_18_m0.y * _18_m7) + _9.x;
    _63.x = _18_m0.y * _18_m7;
    float2 _230 = (_63.xx * float2(2.309999942779541015625f, 5.13000011444091796875f)) + _9.yz;
    _9 = float3(_9.x, _230.x, _230.y);
    _9 = sin(_9);
    _235 = _9.y * 0.300000011920928955078125f;
    _9.x = (_9.x * 0.5f) + _235;
    _9.x = (_9.z * 0.20000000298023223876953125f) + _9.x;
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = ((-_18_m6) * _9.x) + 1.0f;
    _9.z = _56 * _9.x;
    float2 _276 = _140.xy * 2.0f.xx;
    _9 = float3(_276.x, _276.y, _9.z);
    _279 = float4(_9.x, _9.y, _9.z, _279.w);
    vs_TEXCOORD0 = _279.xy;
    vs_TEXCOORD1 = _279.z;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _140 = stage_input._140;
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
#define _51_m0 _Color



static float2 vs_TEXCOORD0;
static float4 _60;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _60 : SV_Target0;
};

static float3 _9;
static float _35;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _35 = _9.x * _9.x;
    _9.x *= _35;
    _9 = _9.xxx * _51_m0.xyz;
    float3 _66 = _9 * vs_TEXCOORD1.xxx;
    _60 = float4(_66.x, _66.y, _66.z, _60.w);
    _60.w = 0.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._60 = _60;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}