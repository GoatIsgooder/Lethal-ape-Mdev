// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Banshee/Glow" {
Properties {

_Tint ("Tint", Color) = (0.5,1,3,1)

_Softness ("Softness (falloff power)", Range(0.5, 8)) = 2.0

_NearFade ("Near Eye Fade (m)", Range(0, 2)) = 0.4000000059604645

[Toggle(BANSHEE_BILLBOARD)] _Billboard ("Face The Camera", Float) = 0.0

[Toggle(BANSHEE_STREAK)] _Streak ("Streak (trails)", Float) = 0.0

}
SubShader {
 LOD 100
 Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent+5" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent+5" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One One
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ BANSHEE_BILLBOARD
#pragma multi_compile_local __ BANSHEE_STREAK
#if defined(BANSHEE_BILLBOARD) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _18_m2[4];
float4x4 glstate_matrix_projection;
static float4 _18_m3[4];
float4x4 unity_MatrixV;
static float4 _18_m4[4];
float4 unity_FogParams;
float _NearFade;
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
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _ProjectionParams
#define _18_m5 unity_FogParams
#define _18_m6 _NearFade



static float4 gl_Position;
static float4 _68;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _203;
static float4 _213;
static float4 _214;

struct SPIRV_Cross_Input
{
    float4 _68 : POSITION;
    float2 _203 : TEXCOORD0;
    float4 _214 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _213 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _37;
static float4 _80;
static float _183;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_18_m2[0].xyz, _18_m2[0].xyz);
    _9.x = sqrt(_9.x);
    _37 = _18_m2[3].yyyy * _18_m4[1];
    _37 = (_18_m4[0] * _18_m2[3].xxxx) + _37;
    _37 = (_18_m4[2] * _18_m2[3].zzzz) + _37;
    _37 += _18_m4[3];
    float2 _77 = (_68.xy * _9.xx) + _37.xy;
    _9 = float4(_77.x, _77.y, _9.z, _9.w);
    _80 = _9.yyyy * _18_m3[1];
    _9 = (_18_m3[0] * _9.xxxx) + _80;
    _9 = (_18_m3[2] * _37.zzzz) + _9;
    _9 = (_18_m3[3] * _37.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _18_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _18_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _18_m5.y;
    vs_TEXCOORD1 = exp2(-_9.x);
    float3 _160 = (-_18_m0) + _18_m2[3].xyz;
    _9 = float4(_160.x, _160.y, _160.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_18_m6) * 0.3499999940395355224609375f) + _9.x;
    _183 = _18_m6 * 0.64999997615814208984375f;
    _183 = max(_183, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _183;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    float2 _210 = (_203 * 2.0f.xx) + (-1.0f).xx;
    vs_TEXCOORD0 = float3(_210.x, _210.y, vs_TEXCOORD0.z);
    _213 = _214;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _68 = stage_input._68;
    _203 = stage_input._203;
    _214 = stage_input._214;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._213 = _213;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _59_m0 _Tint
#define _59_m1 _Softness



static float3 vs_TEXCOORD0;
static float4 _81;
static float vs_TEXCOORD1;
static float4 _123;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _81 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _123 : SV_Target0;
};

static float3 _9;
static float3 _37;
static float _42;
static float _113;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0.xy, vs_TEXCOORD0.xy);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _37.x = log2(_9.x);
    _42 = _9.x * _9.x;
    _42 *= _42;
    _42 *= _42;
    _37.x *= _59_m1;
    _37.x = exp2(_37.x);
    _37.x = (_42 * 0.5f) + _37.x;
    _37.x *= _81.w;
    _37.x *= _59_m0.w;
    _9.x = _37.x * vs_TEXCOORD0.z;
    _37 = _81.xyz * _59_m0.xyz;
    _9 = _9.xxx * _37;
    _113 = vs_TEXCOORD1;
    _113 = clamp(_113, 0.0f, 1.0f);
    _9 *= _113.xxx;
    _123 = float4(_9.x, _9.y, _9.z, _123.w);
    _123.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _81 = stage_input._81;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._123 = _123;
    return stage_output;
}

#endif
#elif defined(BANSHEE_BILLBOARD) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _18_m2[4];
float4x4 glstate_matrix_projection;
static float4 _18_m3[4];
float4x4 unity_MatrixV;
static float4 _18_m4[4];
float4 unity_FogParams;
float _NearFade;
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
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _ProjectionParams
#define _18_m5 unity_FogParams
#define _18_m6 _NearFade



static float4 gl_Position;
static float4 _68;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _209;
static float4 _219;
static float4 _220;

struct SPIRV_Cross_Input
{
    float4 _68 : POSITION;
    float2 _209 : TEXCOORD0;
    float4 _220 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _219 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _37;
static float4 _80;
static float _189;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_18_m2[0].xyz, _18_m2[0].xyz);
    _9.x = sqrt(_9.x);
    _37 = _18_m2[3].yyyy * _18_m4[1];
    _37 = (_18_m4[0] * _18_m2[3].xxxx) + _37;
    _37 = (_18_m4[2] * _18_m2[3].zzzz) + _37;
    _37 += _18_m4[3];
    float2 _77 = (_68.xy * _9.xx) + _37.xy;
    _9 = float4(_77.x, _77.y, _9.z, _9.w);
    _80 = _9.yyyy * _18_m3[1];
    _9 = (_18_m3[0] * _9.xxxx) + _80;
    _9 = (_18_m3[2] * _37.zzzz) + _9;
    _9 = (_18_m3[3] * _37.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _18_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _18_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _18_m5.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD1 = exp2(_9.x);
    float3 _166 = (-_18_m0) + _18_m2[3].xyz;
    _9 = float4(_166.x, _166.y, _166.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_18_m6) * 0.3499999940395355224609375f) + _9.x;
    _189 = _18_m6 * 0.64999997615814208984375f;
    _189 = max(_189, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _189;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    float2 _216 = (_209 * 2.0f.xx) + (-1.0f).xx;
    vs_TEXCOORD0 = float3(_216.x, _216.y, vs_TEXCOORD0.z);
    _219 = _220;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _68 = stage_input._68;
    _209 = stage_input._209;
    _220 = stage_input._220;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._219 = _219;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _59_m0 _Tint
#define _59_m1 _Softness



static float3 vs_TEXCOORD0;
static float4 _81;
static float vs_TEXCOORD1;
static float4 _123;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _81 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _123 : SV_Target0;
};

static float3 _9;
static float3 _37;
static float _42;
static float _113;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0.xy, vs_TEXCOORD0.xy);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _37.x = log2(_9.x);
    _42 = _9.x * _9.x;
    _42 *= _42;
    _42 *= _42;
    _37.x *= _59_m1;
    _37.x = exp2(_37.x);
    _37.x = (_42 * 0.5f) + _37.x;
    _37.x *= _81.w;
    _37.x *= _59_m0.w;
    _9.x = _37.x * vs_TEXCOORD0.z;
    _37 = _81.xyz * _59_m0.xyz;
    _9 = _9.xxx * _37;
    _113 = vs_TEXCOORD1;
    _113 = clamp(_113, 0.0f, 1.0f);
    _9 *= _113.xxx;
    _123 = float4(_9.x, _9.y, _9.z, _123.w);
    _123.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _81 = stage_input._81;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._123 = _123;
    return stage_output;
}

#endif
#elif defined(BANSHEE_BILLBOARD) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _18_m2[4];
float4x4 glstate_matrix_projection;
static float4 _18_m3[4];
float4x4 unity_MatrixV;
static float4 _18_m4[4];
float4 unity_FogParams;
float _NearFade;
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
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _ProjectionParams
#define _18_m5 unity_FogParams
#define _18_m6 _NearFade



static float4 gl_Position;
static float4 _68;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _202;
static float4 _212;
static float4 _213;

struct SPIRV_Cross_Input
{
    float4 _68 : POSITION;
    float2 _202 : TEXCOORD0;
    float4 _213 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _212 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _37;
static float4 _80;
static float _182;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_18_m2[0].xyz, _18_m2[0].xyz);
    _9.x = sqrt(_9.x);
    _37 = _18_m2[3].yyyy * _18_m4[1];
    _37 = (_18_m4[0] * _18_m2[3].xxxx) + _37;
    _37 = (_18_m4[2] * _18_m2[3].zzzz) + _37;
    _37 += _18_m4[3];
    float2 _77 = (_68.xy * _9.xx) + _37.xy;
    _9 = float4(_77.x, _77.y, _9.z, _9.w);
    _80 = _9.yyyy * _18_m3[1];
    _9 = (_18_m3[0] * _9.xxxx) + _80;
    _9 = (_18_m3[2] * _37.zzzz) + _9;
    _9 = (_18_m3[3] * _37.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _18_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _18_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD1 = (_9.x * _18_m5.z) + _18_m5.w;
    float3 _159 = (-_18_m0) + _18_m2[3].xyz;
    _9 = float4(_159.x, _159.y, _159.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_18_m6) * 0.3499999940395355224609375f) + _9.x;
    _182 = _18_m6 * 0.64999997615814208984375f;
    _182 = max(_182, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _182;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    float2 _209 = (_202 * 2.0f.xx) + (-1.0f).xx;
    vs_TEXCOORD0 = float3(_209.x, _209.y, vs_TEXCOORD0.z);
    _212 = _213;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _68 = stage_input._68;
    _202 = stage_input._202;
    _213 = stage_input._213;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._212 = _212;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _59_m0 _Tint
#define _59_m1 _Softness



static float3 vs_TEXCOORD0;
static float4 _81;
static float vs_TEXCOORD1;
static float4 _123;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _81 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _123 : SV_Target0;
};

static float3 _9;
static float3 _37;
static float _42;
static float _113;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0.xy, vs_TEXCOORD0.xy);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _37.x = log2(_9.x);
    _42 = _9.x * _9.x;
    _42 *= _42;
    _42 *= _42;
    _37.x *= _59_m1;
    _37.x = exp2(_37.x);
    _37.x = (_42 * 0.5f) + _37.x;
    _37.x *= _81.w;
    _37.x *= _59_m0.w;
    _9.x = _37.x * vs_TEXCOORD0.z;
    _37 = _81.xyz * _59_m0.xyz;
    _9 = _9.xxx * _37;
    _113 = vs_TEXCOORD1;
    _113 = clamp(_113, 0.0f, 1.0f);
    _9 *= _113.xxx;
    _123 = float4(_9.x, _9.y, _9.z, _123.w);
    _123.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _81 = stage_input._81;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._123 = _123;
    return stage_output;
}

#endif
#elif defined(BANSHEE_STREAK) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float _NearFade;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _NearFade



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _176;
static float4 _180;
static float4 _181;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _176 : TEXCOORD0;
    float4 _181 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _180 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _93;
static float _128;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    float3 _58 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_21_m5) * 0.3499999940395355224609375f) + _9.x;
    _93 = _44.yyyy * _21_m3[1];
    _93 = (_21_m3[0] * _44.xxxx) + _93;
    _93 = (_21_m3[2] * _44.zzzz) + _93;
    _44 = (_21_m3[3] * _44.wwww) + _93;
    gl_Position = _44;
    _128 = _44.z / _21_m1.y;
    _128 = (-_128) + 1.0f;
    _128 *= _21_m1.z;
    _128 = max(_128, 0.0f);
    _128 *= _21_m4.y;
    vs_TEXCOORD1 = exp2(-_128);
    _128 = _21_m5 * 0.64999997615814208984375f;
    _128 = max(_128, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _128;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    vs_TEXCOORD0 = float3(_176.x, _176.y, vs_TEXCOORD0.z);
    _180 = _181;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _176 = stage_input._176;
    _181 = stage_input._181;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._180 = _180;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _55_m0 _Tint
#define _55_m1 _Softness



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _93;
static float4 _134;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _93 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _134 : SV_Target0;
};

static float4 _9;
static float4 _21;
static float3 _41;

void frag_inner()
{
    _9 = float4(vs_TEXCOORD0, vs_TEXCOORD1);
    _21.x = (_9.y * 2.0f) + (-1.0f);
    _21.x = (-abs(_21.x)) + 1.0f;
    _41.x = max(_21.x, 0.0f);
    _41.x = log2(_41.x);
    _41.x *= _55_m1;
    _41.x = exp2(_41.x);
    _21 = float4(_9.xw.x, _9.xw.y, _21.z, _21.w);
    float2 _76 = clamp(_21.xy, 0.0f.xx, 1.0f.xx);
    _21 = float4(_76.x, _76.y, _21.z, _21.w);
    _21.x = (-_21.x) + 1.0f;
    _21.x *= _41.x;
    _41.x = _21.x * _93.w;
    _41.x *= _55_m0.w;
    _21.x = _41.x * _9.z;
    _41 = _93.xyz * _55_m0.xyz;
    float3 _123 = _21.xxx * _41;
    _21 = float4(_123.x, _21.y, _123.y, _123.z);
    float3 _130 = _21.xzw * _21.yyy;
    _21 = float4(_130.x, _130.y, _130.z, _21.w);
    _134 = float4(_21.xyz.x, _21.xyz.y, _21.xyz.z, _134.w);
    _134.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _93 = stage_input._93;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._134 = _134;
    return stage_output;
}

#endif
#elif defined(BANSHEE_STREAK) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float _NearFade;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _NearFade



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _179;
static float4 _183;
static float4 _184;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _179 : TEXCOORD0;
    float4 _184 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _183 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _93;
static float _128;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    float3 _58 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_21_m5) * 0.3499999940395355224609375f) + _9.x;
    _93 = _44.yyyy * _21_m3[1];
    _93 = (_21_m3[0] * _44.xxxx) + _93;
    _93 = (_21_m3[2] * _44.zzzz) + _93;
    _44 = (_21_m3[3] * _44.wwww) + _93;
    gl_Position = _44;
    _128 = _44.z / _21_m1.y;
    _128 = (-_128) + 1.0f;
    _128 *= _21_m1.z;
    _128 = max(_128, 0.0f);
    _128 *= _21_m4.x;
    _128 *= (-_128);
    vs_TEXCOORD1 = exp2(_128);
    _128 = _21_m5 * 0.64999997615814208984375f;
    _128 = max(_128, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _128;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    vs_TEXCOORD0 = float3(_179.x, _179.y, vs_TEXCOORD0.z);
    _183 = _184;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _179 = stage_input._179;
    _184 = stage_input._184;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._183 = _183;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _55_m0 _Tint
#define _55_m1 _Softness



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _93;
static float4 _134;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _93 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _134 : SV_Target0;
};

static float4 _9;
static float4 _21;
static float3 _41;

void frag_inner()
{
    _9 = float4(vs_TEXCOORD0, vs_TEXCOORD1);
    _21.x = (_9.y * 2.0f) + (-1.0f);
    _21.x = (-abs(_21.x)) + 1.0f;
    _41.x = max(_21.x, 0.0f);
    _41.x = log2(_41.x);
    _41.x *= _55_m1;
    _41.x = exp2(_41.x);
    _21 = float4(_9.xw.x, _9.xw.y, _21.z, _21.w);
    float2 _76 = clamp(_21.xy, 0.0f.xx, 1.0f.xx);
    _21 = float4(_76.x, _76.y, _21.z, _21.w);
    _21.x = (-_21.x) + 1.0f;
    _21.x *= _41.x;
    _41.x = _21.x * _93.w;
    _41.x *= _55_m0.w;
    _21.x = _41.x * _9.z;
    _41 = _93.xyz * _55_m0.xyz;
    float3 _123 = _21.xxx * _41;
    _21 = float4(_123.x, _21.y, _123.y, _123.z);
    float3 _130 = _21.xzw * _21.yyy;
    _21 = float4(_130.x, _130.y, _130.z, _21.w);
    _134 = float4(_21.xyz.x, _21.xyz.y, _21.xyz.z, _134.w);
    _134.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _93 = stage_input._93;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._134 = _134;
    return stage_output;
}

#endif
#elif defined(BANSHEE_STREAK) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float _NearFade;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _NearFade



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _177;
static float4 _181;
static float4 _182;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _177 : TEXCOORD0;
    float4 _182 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _181 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _93;
static float _128;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    float3 _58 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_21_m5) * 0.3499999940395355224609375f) + _9.x;
    _93 = _44.yyyy * _21_m3[1];
    _93 = (_21_m3[0] * _44.xxxx) + _93;
    _93 = (_21_m3[2] * _44.zzzz) + _93;
    _44 = (_21_m3[3] * _44.wwww) + _93;
    gl_Position = _44;
    _128 = _44.z / _21_m1.y;
    _128 = (-_128) + 1.0f;
    _128 *= _21_m1.z;
    _128 = max(_128, 0.0f);
    vs_TEXCOORD1 = (_128 * _21_m4.z) + _21_m4.w;
    _128 = _21_m5 * 0.64999997615814208984375f;
    _128 = max(_128, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _128;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    vs_TEXCOORD0 = float3(_177.x, _177.y, vs_TEXCOORD0.z);
    _181 = _182;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _177 = stage_input._177;
    _182 = stage_input._182;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._181 = _181;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _55_m0 _Tint
#define _55_m1 _Softness



static float3 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _93;
static float4 _134;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _93 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _134 : SV_Target0;
};

static float4 _9;
static float4 _21;
static float3 _41;

void frag_inner()
{
    _9 = float4(vs_TEXCOORD0, vs_TEXCOORD1);
    _21.x = (_9.y * 2.0f) + (-1.0f);
    _21.x = (-abs(_21.x)) + 1.0f;
    _41.x = max(_21.x, 0.0f);
    _41.x = log2(_41.x);
    _41.x *= _55_m1;
    _41.x = exp2(_41.x);
    _21 = float4(_9.xw.x, _9.xw.y, _21.z, _21.w);
    float2 _76 = clamp(_21.xy, 0.0f.xx, 1.0f.xx);
    _21 = float4(_76.x, _76.y, _21.z, _21.w);
    _21.x = (-_21.x) + 1.0f;
    _21.x *= _41.x;
    _41.x = _21.x * _93.w;
    _41.x *= _55_m0.w;
    _21.x = _41.x * _9.z;
    _41 = _93.xyz * _55_m0.xyz;
    float3 _123 = _21.xxx * _41;
    _21 = float4(_123.x, _21.y, _123.y, _123.z);
    float3 _130 = _21.xzw * _21.yyy;
    _21 = float4(_130.x, _130.y, _130.z, _21.w);
    _134 = float4(_21.xyz.x, _21.xyz.y, _21.xyz.z, _134.w);
    _134.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _93 = stage_input._93;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._134 = _134;
    return stage_output;
}

#endif
#elif defined(BANSHEE_BILLBOARD)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _18_m1[4];
float4x4 glstate_matrix_projection;
static float4 _18_m2[4];
float4x4 unity_MatrixV;
static float4 _18_m3[4];
float _NearFade;
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
#define _18_m4 _NearFade



static float4 gl_Position;
static float4 _67;
static float3 vs_TEXCOORD0;
static float2 _168;
static float4 _178;
static float4 _179;

struct SPIRV_Cross_Input
{
    float4 _67 : POSITION;
    float2 _168 : TEXCOORD0;
    float4 _179 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 _178 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _37;
static float4 _79;
static float _144;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_18_m1[0].xyz, _18_m1[0].xyz);
    _9.x = sqrt(_9.x);
    _37 = _18_m1[3].yyyy * _18_m3[1];
    _37 = (_18_m3[0] * _18_m1[3].xxxx) + _37;
    _37 = (_18_m3[2] * _18_m1[3].zzzz) + _37;
    _37 += _18_m3[3];
    float2 _76 = (_67.xy * _9.xx) + _37.xy;
    _9 = float4(_76.x, _76.y, _9.z, _9.w);
    _79 = _9.yyyy * _18_m2[1];
    _9 = (_18_m2[0] * _9.xxxx) + _79;
    _9 = (_18_m2[2] * _37.zzzz) + _9;
    gl_Position = (_18_m2[3] * _37.wwww) + _9;
    float3 _120 = (-_18_m0) + _18_m1[3].xyz;
    _9 = float4(_120.x, _120.y, _120.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_18_m4) * 0.3499999940395355224609375f) + _9.x;
    _144 = _18_m4 * 0.64999997615814208984375f;
    _144 = max(_144, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _144;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    float2 _175 = (_168 * 2.0f.xx) + (-1.0f).xx;
    vs_TEXCOORD0 = float3(_175.x, _175.y, vs_TEXCOORD0.z);
    _178 = _179;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _67 = stage_input._67;
    _168 = stage_input._168;
    _179 = stage_input._179;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._178 = _178;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _59_m0 _Tint
#define _59_m1 _Softness



static float3 vs_TEXCOORD0;
static float4 _81;
static float4 _114;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 _81 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _114 : SV_Target0;
};

static float3 _9;
static float3 _37;
static float _42;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0.xy, vs_TEXCOORD0.xy);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _37.x = log2(_9.x);
    _42 = _9.x * _9.x;
    _42 *= _42;
    _42 *= _42;
    _37.x *= _59_m1;
    _37.x = exp2(_37.x);
    _37.x = (_42 * 0.5f) + _37.x;
    _37.x *= _81.w;
    _37.x *= _59_m0.w;
    _9.x = _37.x * vs_TEXCOORD0.z;
    _37 = _81.xyz * _59_m0.xyz;
    _9 = _9.xxx * _37;
    _114 = float4(_9.x, _9.y, _9.z, _114.w);
    _114.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _81 = stage_input._81;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._114 = _114;
    return stage_output;
}

#endif
#elif defined(BANSHEE_STREAK)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float _NearFade;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m3 _NearFade



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float2 _151;
static float4 _155;
static float4 _156;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _151 : TEXCOORD0;
    float4 _156 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 _155 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _92;
static float _126;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    float3 _58 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_21_m3) * 0.3499999940395355224609375f) + _9.x;
    _92 = _44.yyyy * _21_m2[1];
    _92 = (_21_m2[0] * _44.xxxx) + _92;
    _92 = (_21_m2[2] * _44.zzzz) + _92;
    gl_Position = (_21_m2[3] * _44.wwww) + _92;
    _126 = _21_m3 * 0.64999997615814208984375f;
    _126 = max(_126, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _126;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    vs_TEXCOORD0 = float3(_151.x, _151.y, vs_TEXCOORD0.z);
    _155 = _156;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _151 = stage_input._151;
    _156 = stage_input._156;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._155 = _155;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _46_m0 _Tint
#define _46_m1 _Softness



static float3 vs_TEXCOORD0;
static float4 _79;
static float4 _111;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 _79 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _111 : SV_Target0;
};

static float3 _9;
static float3 _31;

void frag_inner()
{
    _9.x = (vs_TEXCOORD0.y * 2.0f) + (-1.0f);
    _9.x = (-abs(_9.x)) + 1.0f;
    _31.x = max(_9.x, 0.0f);
    _31.x = log2(_31.x);
    _31.x *= _46_m1;
    _31.x = exp2(_31.x);
    _9.x = vs_TEXCOORD0.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _31.x;
    _31.x = _9.x * _79.w;
    _31.x *= _46_m0.w;
    _9.x = _31.x * vs_TEXCOORD0.z;
    _31 = _79.xyz * _46_m0.xyz;
    _9 = _9.xxx * _31;
    _111 = float4(_9.x, _9.y, _9.z, _111.w);
    _111.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _79 = stage_input._79;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._111 = _111;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float _NearFade;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _NearFade



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _176;
static float4 _186;
static float4 _187;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _176 : TEXCOORD0;
    float4 _187 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _186 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _93;
static float _128;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    float3 _58 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_21_m5) * 0.3499999940395355224609375f) + _9.x;
    _93 = _44.yyyy * _21_m3[1];
    _93 = (_21_m3[0] * _44.xxxx) + _93;
    _93 = (_21_m3[2] * _44.zzzz) + _93;
    _44 = (_21_m3[3] * _44.wwww) + _93;
    gl_Position = _44;
    _128 = _44.z / _21_m1.y;
    _128 = (-_128) + 1.0f;
    _128 *= _21_m1.z;
    _128 = max(_128, 0.0f);
    _128 *= _21_m4.y;
    vs_TEXCOORD1 = exp2(-_128);
    _128 = _21_m5 * 0.64999997615814208984375f;
    _128 = max(_128, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _128;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    float2 _183 = (_176 * 2.0f.xx) + (-1.0f).xx;
    vs_TEXCOORD0 = float3(_183.x, _183.y, vs_TEXCOORD0.z);
    _186 = _187;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _176 = stage_input._176;
    _187 = stage_input._187;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._186 = _186;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _59_m0 _Tint
#define _59_m1 _Softness



static float3 vs_TEXCOORD0;
static float4 _81;
static float vs_TEXCOORD1;
static float4 _123;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _81 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _123 : SV_Target0;
};

static float3 _9;
static float3 _37;
static float _42;
static float _113;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0.xy, vs_TEXCOORD0.xy);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _37.x = log2(_9.x);
    _42 = _9.x * _9.x;
    _42 *= _42;
    _42 *= _42;
    _37.x *= _59_m1;
    _37.x = exp2(_37.x);
    _37.x = (_42 * 0.5f) + _37.x;
    _37.x *= _81.w;
    _37.x *= _59_m0.w;
    _9.x = _37.x * vs_TEXCOORD0.z;
    _37 = _81.xyz * _59_m0.xyz;
    _9 = _9.xxx * _37;
    _113 = vs_TEXCOORD1;
    _113 = clamp(_113, 0.0f, 1.0f);
    _9 *= _113.xxx;
    _123 = float4(_9.x, _9.y, _9.z, _123.w);
    _123.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _81 = stage_input._81;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._123 = _123;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float _NearFade;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _NearFade



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _179;
static float4 _189;
static float4 _190;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _179 : TEXCOORD0;
    float4 _190 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _189 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _93;
static float _128;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    float3 _58 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_21_m5) * 0.3499999940395355224609375f) + _9.x;
    _93 = _44.yyyy * _21_m3[1];
    _93 = (_21_m3[0] * _44.xxxx) + _93;
    _93 = (_21_m3[2] * _44.zzzz) + _93;
    _44 = (_21_m3[3] * _44.wwww) + _93;
    gl_Position = _44;
    _128 = _44.z / _21_m1.y;
    _128 = (-_128) + 1.0f;
    _128 *= _21_m1.z;
    _128 = max(_128, 0.0f);
    _128 *= _21_m4.x;
    _128 *= (-_128);
    vs_TEXCOORD1 = exp2(_128);
    _128 = _21_m5 * 0.64999997615814208984375f;
    _128 = max(_128, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _128;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    float2 _186 = (_179 * 2.0f.xx) + (-1.0f).xx;
    vs_TEXCOORD0 = float3(_186.x, _186.y, vs_TEXCOORD0.z);
    _189 = _190;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _179 = stage_input._179;
    _190 = stage_input._190;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._189 = _189;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _59_m0 _Tint
#define _59_m1 _Softness



static float3 vs_TEXCOORD0;
static float4 _81;
static float vs_TEXCOORD1;
static float4 _123;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _81 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _123 : SV_Target0;
};

static float3 _9;
static float3 _37;
static float _42;
static float _113;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0.xy, vs_TEXCOORD0.xy);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _37.x = log2(_9.x);
    _42 = _9.x * _9.x;
    _42 *= _42;
    _42 *= _42;
    _37.x *= _59_m1;
    _37.x = exp2(_37.x);
    _37.x = (_42 * 0.5f) + _37.x;
    _37.x *= _81.w;
    _37.x *= _59_m0.w;
    _9.x = _37.x * vs_TEXCOORD0.z;
    _37 = _81.xyz * _59_m0.xyz;
    _9 = _9.xxx * _37;
    _113 = vs_TEXCOORD1;
    _113 = clamp(_113, 0.0f, 1.0f);
    _9 *= _113.xxx;
    _123 = float4(_9.x, _9.y, _9.z, _123.w);
    _123.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _81 = stage_input._81;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._123 = _123;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
float _NearFade;
void __unity_init()
{
    _21_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _ProjectionParams
#define _21_m4 unity_FogParams
#define _21_m5 _NearFade



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float2 _177;
static float4 _187;
static float4 _188;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _177 : TEXCOORD0;
    float4 _188 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _187 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _93;
static float _128;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _11.xxxx) + _9;
    _9 = (_21_m2[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m2[3];
    float3 _58 = (_21_m2[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_21_m5) * 0.3499999940395355224609375f) + _9.x;
    _93 = _44.yyyy * _21_m3[1];
    _93 = (_21_m3[0] * _44.xxxx) + _93;
    _93 = (_21_m3[2] * _44.zzzz) + _93;
    _44 = (_21_m3[3] * _44.wwww) + _93;
    gl_Position = _44;
    _128 = _44.z / _21_m1.y;
    _128 = (-_128) + 1.0f;
    _128 *= _21_m1.z;
    _128 = max(_128, 0.0f);
    vs_TEXCOORD1 = (_128 * _21_m4.z) + _21_m4.w;
    _128 = _21_m5 * 0.64999997615814208984375f;
    _128 = max(_128, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _128;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    float2 _184 = (_177 * 2.0f.xx) + (-1.0f).xx;
    vs_TEXCOORD0 = float3(_184.x, _184.y, vs_TEXCOORD0.z);
    _187 = _188;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _177 = stage_input._177;
    _188 = stage_input._188;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._187 = _187;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _59_m0 _Tint
#define _59_m1 _Softness



static float3 vs_TEXCOORD0;
static float4 _81;
static float vs_TEXCOORD1;
static float4 _123;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _81 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _123 : SV_Target0;
};

static float3 _9;
static float3 _37;
static float _42;
static float _113;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0.xy, vs_TEXCOORD0.xy);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _37.x = log2(_9.x);
    _42 = _9.x * _9.x;
    _42 *= _42;
    _42 *= _42;
    _37.x *= _59_m1;
    _37.x = exp2(_37.x);
    _37.x = (_42 * 0.5f) + _37.x;
    _37.x *= _81.w;
    _37.x *= _59_m0.w;
    _9.x = _37.x * vs_TEXCOORD0.z;
    _37 = _81.xyz * _59_m0.xyz;
    _9 = _9.xxx * _37;
    _113 = vs_TEXCOORD1;
    _113 = clamp(_113, 0.0f, 1.0f);
    _9 *= _113.xxx;
    _123 = float4(_9.x, _9.y, _9.z, _123.w);
    _123.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _81 = stage_input._81;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._123 = _123;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
float _NearFade;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m3 _NearFade



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float2 _151;
static float4 _161;
static float4 _162;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _151 : TEXCOORD0;
    float4 _162 : COLOR;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 _161 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _92;
static float _126;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    float3 _58 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_58.x, _58.y, _58.z, _9.w);
    float3 _67 = _9.xyz + (-_21_m0);
    _9 = float4(_67.x, _67.y, _67.z, _9.w);
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = sqrt(_9.x);
    _9.x = ((-_21_m3) * 0.3499999940395355224609375f) + _9.x;
    _92 = _44.yyyy * _21_m2[1];
    _92 = (_21_m2[0] * _44.xxxx) + _92;
    _92 = (_21_m2[2] * _44.zzzz) + _92;
    gl_Position = (_21_m2[3] * _44.wwww) + _92;
    _126 = _21_m3 * 0.64999997615814208984375f;
    _126 = max(_126, 0.001000000047497451305389404296875f);
    vs_TEXCOORD0.z = _9.x / _126;
    vs_TEXCOORD0.z = clamp(vs_TEXCOORD0.z, 0.0f, 1.0f);
    float2 _158 = (_151 * 2.0f.xx) + (-1.0f).xx;
    vs_TEXCOORD0 = float3(_158.x, _158.y, vs_TEXCOORD0.z);
    _161 = _162;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _151 = stage_input._151;
    _162 = stage_input._162;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._161 = _161;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Tint;
float _Softness;
#define _59_m0 _Tint
#define _59_m1 _Softness



static float3 vs_TEXCOORD0;
static float4 _81;
static float4 _114;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 _81 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _114 : SV_Target0;
};

static float3 _9;
static float3 _37;
static float _42;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0.xy, vs_TEXCOORD0.xy);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + 1.0f;
    _9.x = max(_9.x, 0.0f);
    _37.x = log2(_9.x);
    _42 = _9.x * _9.x;
    _42 *= _42;
    _42 *= _42;
    _37.x *= _59_m1;
    _37.x = exp2(_37.x);
    _37.x = (_42 * 0.5f) + _37.x;
    _37.x *= _81.w;
    _37.x *= _59_m0.w;
    _9.x = _37.x * vs_TEXCOORD0.z;
    _37 = _81.xyz * _59_m0.xyz;
    _9 = _9.xxx * _37;
    _114 = float4(_9.x, _9.y, _9.z, _114.w);
    _114.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _81 = stage_input._81;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._114 = _114;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}