// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Pumpkin/Glow Ribbon" {
Properties {

_Intensity ("Intensity", Range(0, 4)) = 1.399999976158142

_Softness ("Edge Softness", Range(0.5, 6)) = 2.0

_CoreWhite ("Core White", Range(0, 2)) = 0.6000000238418579

_NearFade ("Near Camera Fade (m)", Range(0, 2)) = 0.5

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
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
static float4 _168;
static float4 _175;
static float2 vs_TEXCOORD0;
static float2 _187;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _168 : COLOR;
    float2 _187 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _175 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _146;

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
    _82 = _44.yyyy * _21_m3[1];
    _82 = (_21_m3[0] * _44.xxxx) + _82;
    _82 = (_21_m3[2] * _44.zzzz) + _82;
    _44 = (_21_m3[3] * _44.wwww) + _82;
    gl_Position = _44;
    _117 = _44.z / _21_m1.y;
    _117 = (-_117) + 1.0f;
    _117 *= _21_m1.z;
    _117 = max(_117, 0.0f);
    _117 *= _21_m4.y;
    vs_TEXCOORD1 = exp2(-_117);
    _146 = max(_21_m5, 0.001000000047497451305389404296875f);
    _9.x /= _146;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _168.w;
    _175.w = _9.x;
    _175 = float4(_168.xyz.x, _168.xyz.y, _168.xyz.z, _175.w);
    vs_TEXCOORD0 = _187;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _168 = stage_input._168;
    _187 = stage_input._187;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._175 = _175;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Intensity;
float _Softness;
float _CoreWhite;
#define _46_m0 _Intensity
#define _46_m1 _Softness
#define _46_m2 _CoreWhite



static float2 vs_TEXCOORD0;
static float4 _62;
static float vs_TEXCOORD1;
static float4 _111;

struct SPIRV_Cross_Input
{
    float4 _62 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _111 : SV_Target0;
};

static float3 _9;
static float3 _32;
static float _68;

void frag_inner()
{
    _9.x = (vs_TEXCOORD0.y * 2.0f) + (-1.0f);
    _9.x = (-abs(_9.x)) + 1.0f;
    _32.x = max(_9.x, 0.0f);
    _32.x = log2(_32.x);
    _32.x *= _46_m1;
    _32.x = exp2(_32.x);
    _32.x *= _62.w;
    _68 = _32.x * _32.x;
    _32.y = _32.x * _68;
    float2 _88 = _32.xy * float2(_46_m0, _46_m2);
    _32 = float3(_88.x, _88.y, _32.z);
    _32 = (_62.xyz * _32.xxx) + _32.yyy;
    _9.x = vs_TEXCOORD1;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9 = _32 * _9.xxx;
    _111 = float4(_9.x, _9.y, _9.z, _111.w);
    _111.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _62 = stage_input._62;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._111 = _111;
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
static float4 _171;
static float4 _178;
static float2 vs_TEXCOORD0;
static float2 _190;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _171 : COLOR;
    float2 _190 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _178 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _149;

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
    _82 = _44.yyyy * _21_m3[1];
    _82 = (_21_m3[0] * _44.xxxx) + _82;
    _82 = (_21_m3[2] * _44.zzzz) + _82;
    _44 = (_21_m3[3] * _44.wwww) + _82;
    gl_Position = _44;
    _117 = _44.z / _21_m1.y;
    _117 = (-_117) + 1.0f;
    _117 *= _21_m1.z;
    _117 = max(_117, 0.0f);
    _117 *= _21_m4.x;
    _117 *= (-_117);
    vs_TEXCOORD1 = exp2(_117);
    _149 = max(_21_m5, 0.001000000047497451305389404296875f);
    _9.x /= _149;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _171.w;
    _178.w = _9.x;
    _178 = float4(_171.xyz.x, _171.xyz.y, _171.xyz.z, _178.w);
    vs_TEXCOORD0 = _190;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _171 = stage_input._171;
    _190 = stage_input._190;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._178 = _178;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Intensity;
float _Softness;
float _CoreWhite;
#define _46_m0 _Intensity
#define _46_m1 _Softness
#define _46_m2 _CoreWhite



static float2 vs_TEXCOORD0;
static float4 _62;
static float vs_TEXCOORD1;
static float4 _111;

struct SPIRV_Cross_Input
{
    float4 _62 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _111 : SV_Target0;
};

static float3 _9;
static float3 _32;
static float _68;

void frag_inner()
{
    _9.x = (vs_TEXCOORD0.y * 2.0f) + (-1.0f);
    _9.x = (-abs(_9.x)) + 1.0f;
    _32.x = max(_9.x, 0.0f);
    _32.x = log2(_32.x);
    _32.x *= _46_m1;
    _32.x = exp2(_32.x);
    _32.x *= _62.w;
    _68 = _32.x * _32.x;
    _32.y = _32.x * _68;
    float2 _88 = _32.xy * float2(_46_m0, _46_m2);
    _32 = float3(_88.x, _88.y, _32.z);
    _32 = (_62.xyz * _32.xxx) + _32.yyy;
    _9.x = vs_TEXCOORD1;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9 = _32 * _9.xxx;
    _111 = float4(_9.x, _9.y, _9.z, _111.w);
    _111.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _62 = stage_input._62;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._111 = _111;
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
static float4 _169;
static float4 _175;
static float2 vs_TEXCOORD0;
static float2 _187;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _169 : COLOR;
    float2 _187 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _175 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _117;
static float _147;

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
    _82 = _44.yyyy * _21_m3[1];
    _82 = (_21_m3[0] * _44.xxxx) + _82;
    _82 = (_21_m3[2] * _44.zzzz) + _82;
    _44 = (_21_m3[3] * _44.wwww) + _82;
    gl_Position = _44;
    _117 = _44.z / _21_m1.y;
    _117 = (-_117) + 1.0f;
    _117 *= _21_m1.z;
    _117 = max(_117, 0.0f);
    vs_TEXCOORD1 = (_117 * _21_m4.z) + _21_m4.w;
    _147 = max(_21_m5, 0.001000000047497451305389404296875f);
    _9.x /= _147;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _169.w;
    _175.w = _9.x;
    _175 = float4(_169.xyz.x, _169.xyz.y, _169.xyz.z, _175.w);
    vs_TEXCOORD0 = _187;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _169 = stage_input._169;
    _187 = stage_input._187;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._175 = _175;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Intensity;
float _Softness;
float _CoreWhite;
#define _46_m0 _Intensity
#define _46_m1 _Softness
#define _46_m2 _CoreWhite



static float2 vs_TEXCOORD0;
static float4 _62;
static float vs_TEXCOORD1;
static float4 _111;

struct SPIRV_Cross_Input
{
    float4 _62 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _111 : SV_Target0;
};

static float3 _9;
static float3 _32;
static float _68;

void frag_inner()
{
    _9.x = (vs_TEXCOORD0.y * 2.0f) + (-1.0f);
    _9.x = (-abs(_9.x)) + 1.0f;
    _32.x = max(_9.x, 0.0f);
    _32.x = log2(_32.x);
    _32.x *= _46_m1;
    _32.x = exp2(_32.x);
    _32.x *= _62.w;
    _68 = _32.x * _32.x;
    _32.y = _32.x * _68;
    float2 _88 = _32.xy * float2(_46_m0, _46_m2);
    _32 = float3(_88.x, _88.y, _32.z);
    _32 = (_62.xyz * _32.xxx) + _32.yyy;
    _9.x = vs_TEXCOORD1;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9 = _32 * _9.xxx;
    _111 = float4(_9.x, _9.y, _9.z, _111.w);
    _111.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _62 = stage_input._62;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._111 = _111;
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
static float4 _140;
static float4 _147;
static float2 vs_TEXCOORD0;
static float2 _160;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _140 : COLOR;
    float2 _160 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _147 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float4 _82;
static float _116;

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
    _82 = _44.yyyy * _21_m2[1];
    _82 = (_21_m2[0] * _44.xxxx) + _82;
    _82 = (_21_m2[2] * _44.zzzz) + _82;
    gl_Position = (_21_m2[3] * _44.wwww) + _82;
    _116 = max(_21_m3, 0.001000000047497451305389404296875f);
    _9.x /= _116;
    _9.x += (-0.300000011920928955078125f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _140.w;
    _147.w = _9.x;
    _147 = float4(_140.xyz.x, _140.xyz.y, _140.xyz.z, _147.w);
    vs_TEXCOORD0 = _160;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _160 = stage_input._160;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output._147 = _147;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _Intensity;
float _Softness;
float _CoreWhite;
#define _41_m0 _Intensity
#define _41_m1 _Softness
#define _41_m2 _CoreWhite



static float2 vs_TEXCOORD0;
static float4 _57;
static float4 _84;

struct SPIRV_Cross_Input
{
    float4 _57 : TEXCOORD0;
    float2 vs_TEXCOORD0 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _84 : SV_Target0;
};

static float _8;
static float2 _27;
static float _63;

void frag_inner()
{
    _8 = (vs_TEXCOORD0.y * 2.0f) + (-1.0f);
    _8 = (-abs(_8)) + 1.0f;
    _27.x = max(_8, 0.0f);
    _27.x = log2(_27.x);
    _27.x *= _41_m1;
    _27.x = exp2(_27.x);
    _27.x *= _57.w;
    _63 = _27.x * _27.x;
    _27.y = _27.x * _63;
    _27 *= float2(_41_m0, _41_m2);
    float3 _93 = (_57.xyz * _27.xxx) + _27.yyy;
    _84 = float4(_93.x, _93.y, _93.z, _84.w);
    _84.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _57 = stage_input._57;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._84 = _84;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}