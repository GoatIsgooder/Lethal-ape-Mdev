// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Hidden/Backrooms/FlickerScreenDarken" {
Properties {

_MainTex ("", 2D) = "white" { }

}
SubShader {
 Pass {
 ZTest Always
 ZWrite Off
 Cull Off
   ZTest Always
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
float4x4 _FlkInvVP;
static float4 _48_m0[4];
float _FlkScreenDebug;
float _FlkCount;
float4 _FlkCenter[100];
float4 _FlkExtents[100];
void __unity_init()
{
    _48_m0[0] = float4(_FlkInvVP[0][0], _FlkInvVP[1][0], _FlkInvVP[2][0], _FlkInvVP[3][0]);
    _48_m0[1] = float4(_FlkInvVP[0][1], _FlkInvVP[1][1], _FlkInvVP[2][1], _FlkInvVP[3][1]);
    _48_m0[2] = float4(_FlkInvVP[0][2], _FlkInvVP[1][2], _FlkInvVP[2][2], _FlkInvVP[3][2]);
    _48_m0[3] = float4(_FlkInvVP[0][3], _FlkInvVP[1][3], _FlkInvVP[2][3], _FlkInvVP[3][3]);
}
#define _48_m1 _FlkScreenDebug
#define _48_m2 _FlkCount
#define _48_m3 _FlkCenter
#define _48_m4 _FlkExtents


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _CameraDepthTexture;
SamplerState sampler_CameraDepthTexture;

static float2 vs_TEXCOORD0;
static float4 _59;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _59 : SV_Target0;
};

static float4 _9;
static float4 _20;
static bool _32;
static float2 _66;
static float4 _74;
static float4 _82;
static bool _110;
static float3 _138;
static int _141;
static bool _148;
static bool3 _169;
static bool _181;
static int _196;
static float3 _201;
static float _225;
static float _232;
static float _283;
static bool _295;

void frag_inner()
{
    __unity_init();
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _20.x = _CameraDepthTexture.Sample(sampler_CameraDepthTexture, vs_TEXCOORD0).x;
    _32 = 9.9999999747524270787835121154785e-07f >= _20.x;
    if (_32)
    {
        _32 = _48_m1 == 2;
        if (_32)
        {
            _59 = 1.0f.xxxx;
            return;
        }
        _59 = _9;
        return;
    }
    _66 = (vs_TEXCOORD0 * 2.0f.xx) + (-1.0f).xx;
    _74 = _66.yyyy * _48_m0[1];
    _82 = (_48_m0[0] * _66.xxxx) + _74;
    _20 = (_48_m0[2] * _20.xxxx) + _82;
    _20 += _48_m0[3];
    float3 _107 = _20.xyz / _20.www;
    _20 = float4(_107.x, _107.y, _107.z, _20.w);
    _110 = _48_m1 == 1;
    if (_110)
    {
        float3 _121 = _20.xyz * 0.100000001490116119384765625f.xxx;
        _74 = float4(_121.x, _121.y, _121.z, _74.w);
        float3 _126 = frac(_74.xyz);
        _74 = float4(_126.x, _126.y, _126.z, _74.w);
        _59 = float4(_74.xyz.x, _74.xyz.y, _74.xyz.z, _59.w);
        _59.w = 1.0f;
        return;
    }
    _138.x = 1.0f;
    _141 = 0;
    while (true)
    {
        _148 = _141 >= _48_m2;
        if (_148)
        {
            break;
        }
        float3 _164 = _20.xyz + (-_48_m3[_141].xyz);
        _74 = float4(_164.x, _164.y, _164.z, _74.w);
        float4 _177 = abs(_74.xyzx);
        _169 = bool4(_48_m4[_141].xyzx.x < _177.x, _48_m4[_141].xyzx.y < _177.y, _48_m4[_141].xyzx.z < _177.z, _48_m4[_141].xyzx.w < _177.w).xyz;
        _181 = _169.y || _169.x;
        _181 = _169.z || _181;
        if (_181)
        {
            _196 = _141 + 1;
            _141 = _196;
            continue;
        }
        _201 = max(9.9999997473787516355514526367188e-05f.xxx, _48_m4[_141].xyz);
        float3 _212 = _74.xyz / _201;
        _74 = float4(_212.x, _212.y, _212.z, _74.w);
        _74.x = dot(_74.xyz, _74.xyz);
        _74.x = sqrt(_74.x);
        _225 = 1.0f + (-_48_m4[_141].w);
        _232 = (-_225) + 1.0f;
        _74.x = (-_225) + _74.x;
        _225 = 1.0f / _232;
        _74.x = _225 * _74.x;
        _74.x = clamp(_74.x, 0.0f, 1.0f);
        _225 = (_74.x * (-2.0f)) + 3.0f;
        _74.x *= _74.x;
        _74.x = ((-_225) * _74.x) + 1.0f;
        _225 = (-1.0f) + _48_m3[_141].w;
        _74.x = (_74.x * _225) + 1.0f;
        _283 = min(_74.x, _138.x);
        _138.x = _283;
        _141++;
    }
    _138 = _138.xxx;
    _295 = _48_m1 == 2;
    if (_295)
    {
        _59 = float4(_138.x, _138.y, _138.z, _59.w);
        _59.w = 1.0f;
        return;
    }
    float3 _311 = _9.xyz * _138.zzz;
    _59 = float4(_311.x, _311.y, _311.z, _59.w);
    _59.w = _9.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._59 = _59;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}