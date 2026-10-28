// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Hidden/LethalApe/Runtime/Unlit Transparent" {
Properties {

_Color ("Colour", Color) = (1,1,1,0.5)

_MainTex ("Texture", 2D) = "white" { }

[ToggleUI] _VertexColor ("Use Vertex Colours", Float) = 0.0

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
Cull Back
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _Color;
float _VertexColor;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 unity_FogParams
#define _20_m4 _MainTex_ST
#define _20_m5 _Color
#define _20_m6 _VertexColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _126;
static float4 _138;
static float4 _151;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _126 : TEXCOORD0;
    float4 _138 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _151 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float4 _137;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.y;
    vs_TEXCOORD1 = exp2(-_9.x);
    vs_TEXCOORD0 = (_126 * _20_m4.xy) + _20_m4.zw;
    _137 = _138 + (-1.0f).xxxx;
    _137 = (_20_m6.xxxx * _137) + 1.0f.xxxx;
    _151 = _137 * _20_m5;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _126 = stage_input._126;
    _138 = stage_input._138;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._151 = _151;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
#define _41_m0 unity_FogColor


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _35;
static float4 _70;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _35 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _70 : SV_Target0;
};

static float _8;
static float4 _18;
static float3 _31;
static float4 _50;

void frag_inner()
{
    _8 = vs_TEXCOORD1;
    _8 = clamp(_8, 0.0f, 1.0f);
    _18 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _31 = (_18.xyz * _35.xyz) + (-_41_m0.xyz);
    _50.w = _18.w * _35.w;
    float3 _66 = (_8.xxx * _31) + _41_m0.xyz;
    _50 = float4(_66.x, _66.y, _66.z, _50.w);
    _70 = _50;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _35 = stage_input._35;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._70 = _70;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _Color;
float _VertexColor;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 unity_FogParams
#define _20_m4 _MainTex_ST
#define _20_m5 _Color
#define _20_m6 _VertexColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _132;
static float4 _144;
static float4 _157;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _132 : TEXCOORD0;
    float4 _144 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _157 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float4 _143;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m3.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD1 = exp2(_9.x);
    vs_TEXCOORD0 = (_132 * _20_m4.xy) + _20_m4.zw;
    _143 = _144 + (-1.0f).xxxx;
    _143 = (_20_m6.xxxx * _143) + 1.0f.xxxx;
    _157 = _143 * _20_m5;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _144 = stage_input._144;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._157 = _157;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
#define _41_m0 unity_FogColor


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _35;
static float4 _70;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _35 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _70 : SV_Target0;
};

static float _8;
static float4 _18;
static float3 _31;
static float4 _50;

void frag_inner()
{
    _8 = vs_TEXCOORD1;
    _8 = clamp(_8, 0.0f, 1.0f);
    _18 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _31 = (_18.xyz * _35.xyz) + (-_41_m0.xyz);
    _50.w = _18.w * _35.w;
    float3 _66 = (_8.xxx * _31) + _41_m0.xyz;
    _50 = float4(_66.x, _66.y, _66.z, _50.w);
    _70 = _50;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _35 = stage_input._35;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._70 = _70;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
float4 unity_FogParams;
float4 _MainTex_ST;
float4 _Color;
float _VertexColor;
void __unity_init()
{
    _20_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m3 unity_FogParams
#define _20_m4 _MainTex_ST
#define _20_m5 _Color
#define _20_m6 _VertexColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _125;
static float4 _137;
static float4 _150;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _125 : TEXCOORD0;
    float4 _137 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _150 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float4 _136;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m1[1];
    _9 = (_20_m1[0] * _11.xxxx) + _9;
    _9 = (_20_m1[2] * _11.zzzz) + _9;
    _9 += _20_m1[3];
    _48 = _9.yyyy * _20_m2[1];
    _48 = (_20_m2[0] * _9.xxxx) + _48;
    _48 = (_20_m2[2] * _9.zzzz) + _48;
    _9 = (_20_m2[3] * _9.wwww) + _48;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD1 = (_9.x * _20_m3.z) + _20_m3.w;
    vs_TEXCOORD0 = (_125 * _20_m4.xy) + _20_m4.zw;
    _136 = _137 + (-1.0f).xxxx;
    _136 = (_20_m6.xxxx * _136) + 1.0f.xxxx;
    _150 = _136 * _20_m5;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _125 = stage_input._125;
    _137 = stage_input._137;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._150 = _150;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
#define _41_m0 unity_FogColor


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _35;
static float4 _70;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 _35 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _70 : SV_Target0;
};

static float _8;
static float4 _18;
static float3 _31;
static float4 _50;

void frag_inner()
{
    _8 = vs_TEXCOORD1;
    _8 = clamp(_8, 0.0f, 1.0f);
    _18 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _31 = (_18.xyz * _35.xyz) + (-_41_m0.xyz);
    _50.w = _18.w * _35.w;
    float3 _66 = (_8.xxx * _31) + _41_m0.xyz;
    _50 = float4(_66.x, _66.y, _66.z, _50.w);
    _70 = _50;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _35 = stage_input._35;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._70 = _70;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _20_m0[4];
float4x4 unity_MatrixVP;
static float4 _20_m1[4];
float4 _MainTex_ST;
float4 _Color;
float _VertexColor;
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
#define _20_m2 _MainTex_ST
#define _20_m3 _Color
#define _20_m4 _VertexColor



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _86;
static float4 _97;
static float4 _112;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
    float4 _97 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 _112 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float4 _96;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m0[1];
    _9 = (_20_m0[0] * _11.xxxx) + _9;
    _9 = (_20_m0[2] * _11.zzzz) + _9;
    _9 += _20_m0[3];
    _48 = _9.yyyy * _20_m1[1];
    _48 = (_20_m1[0] * _9.xxxx) + _48;
    _48 = (_20_m1[2] * _9.zzzz) + _48;
    gl_Position = (_20_m1[3] * _9.wwww) + _48;
    vs_TEXCOORD0 = (_86 * _20_m2.xy) + _20_m2.zw;
    _96 = _97 + (-1.0f).xxxx;
    _96 = (_20_m4.xxxx * _96) + 1.0f.xxxx;
    _112 = _96 * _20_m3;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    _97 = stage_input._97;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._112 = _112;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _23;
static float4 _27;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 _23 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _27 : SV_Target0;
};

static float4 _9;
static float4 _20;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20 = _9 * _23;
    _27 = _20;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _23 = stage_input._23;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._27 = _27;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}