// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Hidden/LethalApe/Runtime/Lit Baked" {
Properties {

_Color ("Colour", Color) = (1,1,1,1)

_MainTex ("Albedo", 2D) = "white" { }

[ToggleUI] _VertexColor ("Use Vertex Colours", Float) = 0.0

_EmissionColor ("Emission", Color) = (0,0,0,1)

_EmissionMap ("Emission Map", 2D) = "white" { }

}
SubShader {
 LOD 100
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
 Name "FORWARD"
  LOD 100
  Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
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
float4 unity_LightmapST;
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
#define _20_m4 unity_LightmapST
#define _20_m5 _MainTex_ST
#define _20_m6 _Color
#define _20_m7 _VertexColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _126;
static float2 vs_TEXCOORD1;
static float2 _138;
static float4 _150;
static float4 _163;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _126 : TEXCOORD0;
    float2 _138 : TEXCOORD1;
    float4 _150 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _163 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float4 _149;

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
    vs_TEXCOORD2 = exp2(-_9.x);
    vs_TEXCOORD0 = (_126 * _20_m5.xy) + _20_m5.zw;
    vs_TEXCOORD1 = (_138 * _20_m4.xy) + _20_m4.zw;
    _149 = _150 + (-1.0f).xxxx;
    _149 = (_20_m7.xxxx * _149) + 1.0f.xxxx;
    _163 = _149 * _20_m6;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _126 = stage_input._126;
    _138 = stage_input._138;
    _150 = stage_input._150;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._163 = _163;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 unity_Lightmap_HDR;
float4 _EmissionColor;
#define _25_m0 unity_FogColor
#define _25_m1 unity_Lightmap_HDR
#define _25_m2 _EmissionColor


Texture2D<float4> unity_Lightmap;
SamplerState samplerunity_Lightmap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _56;
static float vs_TEXCOORD2;
static float4 _92;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _56 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _92 : SV_Target0;
};

static float3 _9;
static float3 _33;
static float3 _40;
static float4 _48;
static float4 _53;
static float _73;

void frag_inner()
{
    _9 = unity_Lightmap.Sample(samplerunity_Lightmap, vs_TEXCOORD1).xyz;
    _9 *= _25_m1.xxx;
    _33 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0).xyz;
    _40 = _33 * _25_m2.xyz;
    _48 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _53 = _48 * _56;
    _40 = (_53.xyz * _9) + _40;
    _40 += (-_25_m0.xyz);
    _73 = vs_TEXCOORD2;
    _73 = clamp(_73, 0.0f, 1.0f);
    float3 _88 = (_73.xxx * _40) + _25_m0.xyz;
    _53 = float4(_88.x, _88.y, _88.z, _53.w);
    _92 = _53;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _56 = stage_input._56;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._92 = _92;
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
float4 unity_LightmapST;
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
#define _20_m4 unity_LightmapST
#define _20_m5 _MainTex_ST
#define _20_m6 _Color
#define _20_m7 _VertexColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _132;
static float2 vs_TEXCOORD1;
static float2 _144;
static float4 _156;
static float4 _169;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _132 : TEXCOORD0;
    float2 _144 : TEXCOORD1;
    float4 _156 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _169 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float4 _155;

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
    vs_TEXCOORD2 = exp2(_9.x);
    vs_TEXCOORD0 = (_132 * _20_m5.xy) + _20_m5.zw;
    vs_TEXCOORD1 = (_144 * _20_m4.xy) + _20_m4.zw;
    _155 = _156 + (-1.0f).xxxx;
    _155 = (_20_m7.xxxx * _155) + 1.0f.xxxx;
    _169 = _155 * _20_m6;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _132 = stage_input._132;
    _144 = stage_input._144;
    _156 = stage_input._156;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._169 = _169;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 unity_Lightmap_HDR;
float4 _EmissionColor;
#define _25_m0 unity_FogColor
#define _25_m1 unity_Lightmap_HDR
#define _25_m2 _EmissionColor


Texture2D<float4> unity_Lightmap;
SamplerState samplerunity_Lightmap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _56;
static float vs_TEXCOORD2;
static float4 _92;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _56 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _92 : SV_Target0;
};

static float3 _9;
static float3 _33;
static float3 _40;
static float4 _48;
static float4 _53;
static float _73;

void frag_inner()
{
    _9 = unity_Lightmap.Sample(samplerunity_Lightmap, vs_TEXCOORD1).xyz;
    _9 *= _25_m1.xxx;
    _33 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0).xyz;
    _40 = _33 * _25_m2.xyz;
    _48 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _53 = _48 * _56;
    _40 = (_53.xyz * _9) + _40;
    _40 += (-_25_m0.xyz);
    _73 = vs_TEXCOORD2;
    _73 = clamp(_73, 0.0f, 1.0f);
    float3 _88 = (_73.xxx * _40) + _25_m0.xyz;
    _53 = float4(_88.x, _88.y, _88.z, _53.w);
    _92 = _53;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _56 = stage_input._56;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._92 = _92;
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
float4 unity_LightmapST;
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
#define _20_m4 unity_LightmapST
#define _20_m5 _MainTex_ST
#define _20_m6 _Color
#define _20_m7 _VertexColor



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _125;
static float2 vs_TEXCOORD1;
static float2 _137;
static float4 _149;
static float4 _162;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _125 : TEXCOORD0;
    float2 _137 : TEXCOORD1;
    float4 _149 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _162 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float4 _148;

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
    vs_TEXCOORD2 = (_9.x * _20_m3.z) + _20_m3.w;
    vs_TEXCOORD0 = (_125 * _20_m5.xy) + _20_m5.zw;
    vs_TEXCOORD1 = (_137 * _20_m4.xy) + _20_m4.zw;
    _148 = _149 + (-1.0f).xxxx;
    _148 = (_20_m7.xxxx * _148) + 1.0f.xxxx;
    _162 = _148 * _20_m6;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _125 = stage_input._125;
    _137 = stage_input._137;
    _149 = stage_input._149;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._162 = _162;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 unity_Lightmap_HDR;
float4 _EmissionColor;
#define _25_m0 unity_FogColor
#define _25_m1 unity_Lightmap_HDR
#define _25_m2 _EmissionColor


Texture2D<float4> unity_Lightmap;
SamplerState samplerunity_Lightmap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _56;
static float vs_TEXCOORD2;
static float4 _92;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _56 : TEXCOORD2;
    float vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _92 : SV_Target0;
};

static float3 _9;
static float3 _33;
static float3 _40;
static float4 _48;
static float4 _53;
static float _73;

void frag_inner()
{
    _9 = unity_Lightmap.Sample(samplerunity_Lightmap, vs_TEXCOORD1).xyz;
    _9 *= _25_m1.xxx;
    _33 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0).xyz;
    _40 = _33 * _25_m2.xyz;
    _48 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _53 = _48 * _56;
    _40 = (_53.xyz * _9) + _40;
    _40 += (-_25_m0.xyz);
    _73 = vs_TEXCOORD2;
    _73 = clamp(_73, 0.0f, 1.0f);
    float3 _88 = (_73.xxx * _40) + _25_m0.xyz;
    _53 = float4(_88.x, _88.y, _88.z, _53.w);
    _92 = _53;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _56 = stage_input._56;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._92 = _92;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _20_m0[4];
float4x4 unity_MatrixVP;
static float4 _20_m1[4];
float4 unity_LightmapST;
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
#define _20_m2 unity_LightmapST
#define _20_m3 _MainTex_ST
#define _20_m4 _Color
#define _20_m5 _VertexColor



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _86;
static float2 vs_TEXCOORD1;
static float2 _97;
static float4 _108;
static float4 _123;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
    float2 _97 : TEXCOORD1;
    float4 _108 : COLOR;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _123 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;
static float4 _107;

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
    vs_TEXCOORD0 = (_86 * _20_m3.xy) + _20_m3.zw;
    vs_TEXCOORD1 = (_97 * _20_m2.xy) + _20_m2.zw;
    _107 = _108 + (-1.0f).xxxx;
    _107 = (_20_m5.xxxx * _107) + 1.0f.xxxx;
    _123 = _107 * _20_m4;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    _97 = stage_input._97;
    _108 = stage_input._108;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._123 = _123;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_Lightmap_HDR;
float4 _EmissionColor;
#define _25_m0 unity_Lightmap_HDR
#define _25_m1 _EmissionColor


Texture2D<float4> unity_Lightmap;
SamplerState samplerunity_Lightmap;
Texture2D<float4> _EmissionMap;
SamplerState sampler_EmissionMap;
Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float4 _56;
static float4 _68;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _56 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _68 : SV_Target0;
};

static float3 _9;
static float3 _33;
static float3 _40;
static float4 _48;
static float4 _53;

void frag_inner()
{
    _9 = unity_Lightmap.Sample(samplerunity_Lightmap, vs_TEXCOORD1).xyz;
    _9 *= _25_m0.xxx;
    _33 = _EmissionMap.Sample(sampler_EmissionMap, vs_TEXCOORD0).xyz;
    _40 = _33 * _25_m1.xyz;
    _48 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _53 = _48 * _56;
    float3 _64 = (_53.xyz * _9) + _40;
    _53 = float4(_64.x, _64.y, _64.z, _53.w);
    _68 = _53;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    _56 = stage_input._56;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._68 = _68;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}