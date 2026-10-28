// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "LethalApe/Quest Claim Fill" {
Properties {

_FillColor ("Fill Color", Color) = (1,0.85,0.2,1)

_TrackColor ("Track Color", Color) = (0.05,0.05,0.05,0.6)

_FillAmount ("Fill Amount", Range(0, 1)) = 0.0

_Softness ("Edge Softness", Range(0, 0.5)) = 0.03999999910593033

[Enum(LeftToRight,0,RightToLeft,1,BottomToTop,2,TopToBottom,3)] _FillDirection ("Fill Direction", Float) = 0.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
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
static float2 vs_TEXCOORD0;
static float2 _86;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

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
    vs_TEXCOORD0 = _86;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _FillColor;
float4 _TrackColor;
float _FillAmount;
float _Softness;
float _FillDirection;
#define _26_m0 _FillColor
#define _26_m1 _TrackColor
#define _26_m2 _FillAmount
#define _26_m3 _Softness
#define _26_m4 _FillDirection



static float2 vs_TEXCOORD0;
static float4 _167;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _167 : SV_Target0;
};

static float4 _9;
static bool3 _23;
static float _53;
static float4 _145;

void frag_inner()
{
    float2 _17 = (-vs_TEXCOORD0) + 1.0f.xx;
    _9 = float4(_17.x, _17.y, _9.z, _9.w);
    float4 _43 = float4(float4(_26_m4, _26_m4, _26_m4, _26_m4));
    _23 = bool4(_43.x < float4(0.5f, 1.5f, 2.5f, 0.0f).x, _43.y < float4(0.5f, 1.5f, 2.5f, 0.0f).y, _43.z < float4(0.5f, 1.5f, 2.5f, 0.0f).z, _43.w < float4(0.5f, 1.5f, 2.5f, 0.0f).w).xyz;
    float _60;
    if (_23.z)
    {
        _60 = vs_TEXCOORD0.y;
    }
    else
    {
        _60 = _9.y;
    }
    _53 = _60;
    float _73;
    if (_23.y)
    {
        _73 = _9.x;
    }
    else
    {
        _73 = _53;
    }
    _9.x = _73;
    float _85;
    if (_23.x)
    {
        _85 = vs_TEXCOORD0.x;
    }
    else
    {
        _85 = _9.x;
    }
    _9.x = _85;
    _53 = max(_26_m3, 9.9999997473787516355514526367188e-05f);
    _53 = (-_53) + _26_m2;
    _9.x = (-_53) + _9.x;
    _53 = (-_53) + _26_m2;
    _53 = 1.0f / _53;
    _9.x = _53 * _9.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _53 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _53;
    _145 = (-_26_m0) + _26_m1;
    _9 = (_9.xxxx * _145) + _26_m0;
    _23.x = 9.9999997473787516355514526367188e-05f >= _26_m2;
    float4 _171;
    if (_23.x)
    {
        _171 = _26_m1;
    }
    else
    {
        _171 = _9;
    }
    _167 = _171;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._167 = _167;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}