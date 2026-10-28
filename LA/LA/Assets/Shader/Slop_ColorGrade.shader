// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/ColorGrade" {
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
float4 _ScreenParams;
float _Exposure;
float _Contrast;
float _Saturation;
float _KeepRed;
float3 _ColorBalance;
float4 _ColorFilter;
float _VignetteIntensity;
float _VignetteSmoothness;
float3 _VignetteColor;
float _GrainIntensity;
float _GrainTime;
#define _27_m0 _ScreenParams
#define _27_m1 _Exposure
#define _27_m2 _Contrast
#define _27_m3 _Saturation
#define _27_m4 _KeepRed
#define _27_m5 _ColorBalance
#define _27_m6 _ColorFilter
#define _27_m7 _VignetteIntensity
#define _27_m8 _VignetteSmoothness
#define _27_m9 _VignetteColor
#define _27_m10 _GrainIntensity
#define _27_m11 _GrainTime


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _403;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _403 : SV_Target0;
};

static float4 _9;
static float3 _22;
static float3 _42;
static float3 _122;
static float3 _135;
static bool _161;
static float _169;
static bool _259;
static float _303;

void frag_inner()
{
    _9 = _MainTex.Sample(sampler_MainTex, vs_TEXCOORD0);
    _22 = _9.xyz * _27_m1.xxx;
    _22 *= _27_m6.xyz;
    _42.x = dot(float3(0.390404999256134033203125f, 0.549941003322601318359375f, 0.008926319889724254608154296875f), _22);
    _42.y = dot(float3(0.070841602981090545654296875f, 0.963172018527984619140625f, 0.001357750035822391510009765625f), _22);
    _42.z = dot(float3(0.02310819923877716064453125f, 0.1280210018157958984375f, 0.936245024204254150390625f), _22);
    _22 = _42 * _27_m5;
    _42.x = dot(float3(2.85846996307373046875f, -1.62879002094268798828125f, -0.0248910002410411834716796875f), _22);
    _42.y = dot(float3(-0.21018199622631072998046875f, 1.1582000255584716796875f, 0.0003242809907533228397369384765625f), _22);
    _42.z = dot(float3(-0.0418119989335536956787109375f, -0.118169002234935760498046875f, 1.0686700344085693359375f), _22);
    float3 _99 = _42 + (-0.180000007152557373046875f).xxx;
    _9 = float4(_99.x, _99.y, _99.z, _9.w);
    float3 _119 = (_9.xyz * float3(float3(_27_m2, _27_m2, _27_m2))) + 0.180000007152557373046875f.xxx;
    _9 = float4(_119.x, _119.y, _119.z, _9.w);
    _122 = max(_9.xyz, 0.0f.xxx);
    _22.x = dot(_122, float3(0.0396819151937961578369140625f, 0.4580217897891998291015625f, 0.0060965395532548427581787109375f));
    _135 = _9.xyz + (-_22.xxx);
    _22 = (float3(float3(_27_m3, _27_m3, _27_m3)) * _135) + _22.xxx;
    _161 = 0.0f < _27_m4;
    if (_161)
    {
        _169 = max(_9.z, _9.y);
        _169 = _9.x + (-_169);
        _122.x = max(_9.x, 0.001000000047497451305389404296875f);
        _122.x = _169 / _122.x;
        _122.x += (-0.60000002384185791015625f);
        _122.x *= 4.0f;
        _122.x = clamp(_122.x, 0.0f, 1.0f);
        _122.x *= _27_m4;
        _42 = _9.xyz + (-_22);
        _22 = (_122.xxx * _42) + _22;
    }
    float3 _223 = max(_22, 0.0f.xxx);
    _9 = float4(_223.x, _223.y, _223.z, _9.w);
    _22 = (_9.xyz * 2.5099999904632568359375f.xxx) + 0.02999999932944774627685546875f.xxx;
    _22 = _9.xyz * _22;
    _42 = (_9.xyz * 2.4300000667572021484375f.xxx) + 0.589999973773956298828125f.xxx;
    _42 = (_9.xyz * _42) + 0.14000000059604644775390625f.xxx;
    _22 /= _42;
    _22 = min(_22, 1.0f.xxx);
    _259 = 0.0f < _27_m7;
    if (_259)
    {
        float2 _270 = vs_TEXCOORD0 + (-0.5f).xx;
        _9 = float4(_270.x, _270.y, _9.z, _9.w);
        float2 _279 = abs(_9.xy) + abs(_9.xy);
        _9 = float4(_279.x, _279.y, _9.z, _9.w);
        _169 = dot(_9.xy, _9.xy);
        _169 = sqrt(_169);
        _169 *= _27_m7;
        _9.x = ((-_169) * _169) + 1.0f;
        _9.x = max(_9.x, 0.0f);
        _303 = max(_27_m8, 0.001000000047497451305389404296875f);
        _9.x = log2(_9.x);
        _9.x *= _303;
        _9.x = exp2(_9.x);
        _42 = _22 + (-_27_m9);
        _22 = (_9.xxx * _42) + _27_m9;
    }
    _259 = 0.0f < _27_m10;
    if (_259)
    {
        float2 _351 = (vs_TEXCOORD0 * _27_m0.xy) + _27_m11.xx;
        _9 = float4(_351.x, _351.y, _9.z, _9.w);
        _9.x = dot(_9.xy, float2(12.98980045318603515625f, 78.233001708984375f));
        _9.x = sin(_9.x);
        _9.x *= 43758.546875f;
        _9.x = frac(_9.x);
        _9.x += (-0.5f);
        _42 = _22;
        _42 = clamp(_42, 0.0f.xxx, 1.0f.xxx);
        _169 = dot(_42, float3(0.0396819151937961578369140625f, 0.4580217897891998291015625f, 0.0060965395532548427581787109375f));
        _169 = sqrt(_169);
        _303 = (-_169) + 1.0f;
        _169 = _9.x * _27_m10;
        _22 = (_169.xxx * _303.xxx) + _22;
    }
    _403 = float4(_22.x, _22.y, _22.z, _403.w);
    float3 _411 = clamp(_403.xyz, 0.0f.xxx, 1.0f.xxx);
    _403 = float4(_411.x, _411.y, _411.z, _403.w);
    _403.w = _9.w;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._403 = _403;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}