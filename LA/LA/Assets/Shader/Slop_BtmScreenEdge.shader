// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmScreenEdge" {
Properties {

_Color ("Tint", Color) = (0.4,1,0.6,1)

_Strength ("Strength", Range(0, 1)) = 0.0

_Darken ("Edge Darken", Range(0, 1)) = 0.5

_Fringe ("Fringe", Range(0, 1)) = 0.6000000238418579

_FlashMode ("Flash Mode", Float) = 0.0

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+10" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+10" "RenderType" = "Transparent" }
 ZTest Always
 ZWrite Off
 Cull Off
   Blend One OneMinusSrcAlpha
 ZTest Always
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _20_m1[4];
float4x4 unity_MatrixVP;
static float4 _20_m2[4];
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
#define _20_m0 _Time



static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD0;
static float2 _86;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _48;

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
    gl_Position = (_20_m2[3] * _9.wwww) + _48;
    vs_TEXCOORD0 = _86;
    float2 _94 = _20_m0.yy * float2(1.7000000476837158203125f, 1.10000002384185791015625f);
    _9 = float4(_94.x, _94.y, _9.z, _9.w);
    _9.x = (_86.y * 56.54866790771484375f) + _9.x;
    _9.y = (_86.y * 25.1327419281005859375f) + (-_9.y);
    float2 _119 = sin(_9.xy);
    _9 = float4(_119.x, _119.y, _9.z, _9.w);
    _9.x *= 0.1500000059604644775390625f;
    _9.x = (_9.x * _9.y) + 0.85000002384185791015625f;
    vs_TEXCOORD1 = _9.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
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
float _Strength;
float _Darken;
float _Fringe;
float _FlashMode;
#define _14_m0 _Color
#define _14_m1 _Strength
#define _14_m2 _Darken
#define _14_m3 _Fringe
#define _14_m4 _FlashMode



static float4 _25;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _25 : SV_Target0;
};

static bool _8;
static float _47;
static float4 _60;
static float2 _66;
static float3 _107;
static float3 _114;

void frag_inner()
{
    _8 = 0.5f < _14_m4;
    if (_8)
    {
        float3 _36 = _14_m0.xyz * _14_m1.xxx;
        _25 = float4(_36.x, _36.y, _36.z, _25.w);
        _25.w = _14_m1;
        return;
    }
    _47 = vs_TEXCOORD0.x;
    _47 = clamp(_47, 0.0f, 1.0f);
    _60.x = _47 * _47;
    _66.x = ((-_47) * 2.0f) + 3.0f;
    _60.x = _66.x * _60.x;
    _66 = _47.xx + float2(-0.579999983310699462890625f, -0.439999997615814208984375f);
    _66 = ((-abs(_66)) * 6.0f.xx) + 1.0f.xx;
    float2 _96 = max(_66, 0.0f.xx);
    _60 = float4(_60.x, _96.x, _96.y, _60.w);
    float3 _103 = _60.xyz * _60.xyz;
    _60 = float4(_103.x, _103.y, _103.z, _60.w);
    _107 = _60.xxx * _14_m0.xyz;
    _114 = _60.zzz * float3(0.0419999994337558746337890625f, 0.262499988079071044921875f, 0.3499999940395355224609375f);
    float3 _129 = (_60.yyy * float3(0.5f, 0.0900000035762786865234375f, 0.0599999986588954925537109375f)) + _114;
    _60 = float4(_60.x, _129.x, _129.y, _129.z);
    _60 *= float4(_14_m2, _14_m3, _14_m3, _14_m3);
    float3 _152 = (_107 * vs_TEXCOORD1.xxx) + _60.yzw;
    _60 = float4(_60.x, _152.x, _152.y, _152.z);
    _25 = _60.yzwx * _14_m1.xxxx;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._25 = _25;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}