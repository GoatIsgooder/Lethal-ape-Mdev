// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/FloorFog" {
Properties {

_NoiseTex ("Noise (R density, GB normal XZ)", 2D) = "gray" { }

_Color ("Fog Albedo", Color) = (0.86,0.84,0.92,1)

_Density ("Density", Range(0, 2)) = 0.8999999761581421

_Cutoff ("Clearing", Range(0, 0.9)) = 0.30000001192092896

_Scale ("Noise Scale (per metre)", Float) = 0.2199999988079071

_Wind ("Wind XZ (m/s), Detail XZ", Vector) = (0.12,0.05,-0.07,0.1)

_Undulate ("Roll Height (m)", Range(0, 0.4)) = 0.11999999731779099

_Relief ("Billow Relief", Range(0, 3)) = 1.7999999523162842

_BottomShade ("Bottom Layer Shade", Range(0, 1)) = 0.550000011920929

_TopThin ("Top Layer Strength", Range(0, 1)) = 0.3499999940395355

_EdgeFade ("Edge Fade (UV)", Range(0.01, 0.5)) = 0.18000000715255737

_NearFade ("Camera Fade Start, Range (m)", Vector) = (0.35,0.9,0,0)

_EyeFade ("Hide Sheets Within (m) Of Eye Height", Range(0.01, 1)) = 0.1599999964237213

[Header(Lighting)] [Toggle] _UseVolume ("Use Bakery Volume", Float) = 1.0

_AmbientBoost ("Baked Light Strength", Range(0, 4)) = 1.600000023841858

_AmbientFloor ("Minimum Light", Color) = (0.03,0.03,0.045,1)

_DirectStrength ("Realtime Light Strength", Range(0, 4)) = 1.2000000476837158

_Scatter ("Backlit Glow", Range(0, 4)) = 1.2000000476837158

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_ObjectToWorld;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _UseVolume;
float _Scale;
float _Undulate;
float4 _Wind;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _21_m6[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m6[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m6[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m6[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _WorldSpaceCameraPos
#define _21_m2 _ProjectionParams
#define _21_m3 unity_SHAr
#define _21_m4 unity_SHAg
#define _21_m5 unity_SHAb
#define _21_m8 unity_FogParams
#define _21_m9 _TopThin
#define _21_m10 _EyeFade
#define _21_m11 _BottomShade
#define _21_m12 _UseVolume
#define _21_m13 _Scale
#define _21_m14 _Undulate
#define _21_m15 _Wind
#define _21_m16 _GlobalVolumeMin
#define _21_m17 _GlobalVolumeInvSize


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float4 _106;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 vs_TEXCOORD1;
static float2 _480;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _480 : TEXCOORD0;
    float4 _106 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _68;
static float4 _80;
static float4 _93;
static float _136;
static float _141;
static float _196;
static float2 _214;
static float _238;
static bool _278;
static bool _283;
static float4 _336;
static float3 _352;
static float3 _357;
static float3 _381;
static float3 _398;
static float3 _411;
static float _415;

void vert_inner()
{
    __unity_init();
    float3 _29 = _11.yyy * _21_m6[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _41 = (_21_m6[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_41.x, _41.y, _41.z, _9.w);
    float3 _53 = (_21_m6[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _65 = (_21_m6[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_65.x, _65.y, _65.z, _9.w);
    float2 _77 = _9.xz * _21_m13.xx;
    _68 = float4(_77.x, _77.y, _68.z, _68.w);
    _80 = _21_m13.xxxx * _21_m15;
    _80 *= _21_m0.yyyy;
    _93 = _80 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _68 = (_68.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _93;
    float2 _115 = (_106.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _68.xy;
    _68 = float4(_115.x, _115.y, _68.z, _68.w);
    _68.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _68.xy, 2.0f).x;
    _136 = _68.x + (-0.5f);
    _141 = _136 + _136;
    _136 = _141 * _21_m14;
    _9.w = (_136 * _106.w) + _9.y;
    float2 _169 = (_9.xz * _21_m13.xx) + _80.xy;
    _93 = float4(_169.x, _169.y, _93.z, _93.w);
    float2 _182 = (_106.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _93.xy;
    vs_TEXCOORD0 = float4(_182.x, _182.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _193 = (_106.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _68.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _193.x, _193.y);
    _196 = (-_9.w) + _21_m1.y;
    _196 = abs(_196) / _21_m10;
    _196 = clamp(_196, 0.0f, 1.0f);
    _214.x = _21_m9 + (-1.0f);
    _214.x = (_106.w * _214.x) + 1.0f;
    _214.x = _196 * _214.x;
    _214.x = _196 * _214.x;
    _238 = (-_21_m11) + 1.0f;
    _214.y = (_106.w * _238) + _21_m11;
    _68 = _9.wwww * _21_m7[1];
    _68 = (_21_m7[0] * _9.xxxx) + _68;
    _68 = (_21_m7[2] * _9.zzzz) + _68;
    _68 += _21_m7[3];
    _278 = 0.5f < _21_m12;
    _283 = 0.0f < _21_m17.x;
    _278 = _278 && _283;
    _283 = _21_m17.x < 1000000.0f;
    _278 = _278 && _283;
    if (_278)
    {
        float3 _308 = _9.xwz + (-_21_m16);
        _93 = float4(_308.x, _308.y, _308.z, _93.w);
        float3 _315 = _93.xyz * _21_m17;
        _93 = float4(_315.x, _315.y, _315.z, _93.w);
        float3 _322 = clamp(_93.xyz, 0.0f.xxx, 1.0f.xxx);
        _93 = float4(_322.x, _322.y, _322.z, _93.w);
        _80 = _Volume0.SampleLevel(sampler_Volume0, _93.xyz, 0.0f);
        _336 = _Volume1.SampleLevel(sampler_Volume0, _93.xyz, 0.0f);
        _93 = _Volume2.SampleLevel(sampler_Volume0, _93.xyz, 0.0f);
        _352 = max(_80.xyz, 0.0f.xxx);
        _357.x = dot(_336.xyz, 0.3333333432674407958984375f.xxx);
        _357.y = dot(_93.xyz, 0.3333333432674407958984375f.xxx);
        _196 = _80.w + _336.w;
        _196 = _93.w + _196;
        _357.z = _196 * 0.3333333432674407958984375f;
        _381 = _352;
    }
    else
    {
        _381.x = max(_21_m3.w, 0.0f);
        _381.y = max(_21_m4.w, 0.0f);
        _381.z = max(_21_m5.w, 0.0f);
        _398 = _21_m3.xyz + _21_m4.xyz;
        _398 += _21_m5.xyz;
        _411 = _398 * 0.3333333432674407958984375f.xxx;
        _357 = _411;
    }
    _415 = dot(_381, 0.3333333432674407958984375f.xxx);
    _415 = max(_415, 9.9999997473787516355514526367188e-05f);
    float3 _424 = _357 / _415.xxx;
    _93 = float4(_424.x, _424.y, _424.z, _93.w);
    _415 = dot(_93.xyz, _93.xyz);
    _415 = sqrt(_415);
    _278 = 1.0f < _415;
    _415 = 1.0f / _415;
    _415 = _278 ? _415 : 1.0f;
    vs_TEXCOORD4 = _93.xyz * _415.xxx;
    _196 = _68.z / _21_m2.y;
    _196 = (-_196) + 1.0f;
    _196 *= _21_m2.z;
    _196 = max(_196, 0.0f);
    _196 *= _21_m8.y;
    vs_TEXCOORD5 = exp2(-_196);
    gl_Position = _68;
    vs_TEXCOORD1 = float4(_480.x, _480.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _214.x, _214.y);
    vs_TEXCOORD2 = _9.xwz;
    vs_TEXCOORD3 = _381;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _106 = stage_input._106;
    _480 = stage_input._480;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float4 _AmbientFloor;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _AmbientBoost;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
#define _87_m0 _WorldSpaceCameraPos
#define _87_m1 _WorldSpaceLightPos0
#define _87_m2 unity_FogColor
#define _87_m3 _LightColor0
#define _87_m4 _Color
#define _87_m5 _AmbientFloor
#define _87_m6 _Density
#define _87_m7 _Cutoff
#define _87_m8 _EdgeFade
#define _87_m9 _Relief
#define _87_m10 _AmbientBoost
#define _87_m11 _DirectStrength
#define _87_m12 _Scatter
#define _87_m13 _NearFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD5;
static float4 _532;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _532 : SV_Target0;
};

static float3 _9;
static float4 _29;
static float3 _44;
static float2 _53;
static float3 _57;
static float _105;
static float3 _127;
static float3 _138;
static float _159;
static float _223;
static float3 _231;
static float _240;
static float3 _244;
static float4 _379;
static float _394;
static float2 _425;

void frag_inner()
{
    _9 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _34 = _9.yz + (-0.5f).xx;
    _29 = float4(_34.x, _34.y, _29.z, _29.w);
    float2 _41 = _29.xy + _29.xy;
    _29 = float4(_41.x, _41.y, _29.z, _29.w);
    _44 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _53 = _44.yz + (-0.5f).xx;
    _57.x = _44.x * 0.3499999940395355224609375f;
    _57.x = (_9.x * 0.64999997615814208984375f) + _57.x;
    float2 _80 = (_53 * 0.89999997615814208984375f.xx) + _29.xy;
    _29 = float4(_80.x, _80.y, _29.z, _29.w);
    float2 _99 = _29.xy * float2(float2(_87_m9, _87_m9));
    _29 = float4(_99.x, _29.y, _99.y, _29.w);
    _29.y = 1.0f;
    _105 = dot(_29.xyz, _29.xyz);
    _105 = rsqrt(_105);
    float3 _117 = _105.xxx * _29.xyz;
    _29 = float4(_117.x, _117.y, _117.z, _29.w);
    _105 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _105 = sqrt(_105);
    _127.x = max(_105, 9.9999997473787516355514526367188e-05f);
    _105 = min(_105, 1.0f);
    _127 = vs_TEXCOORD4 / _127.xxx;
    _138.x = dot(_29.xyz, _127);
    _29.x = dot(_29.xyz, _87_m1.xyz);
    _29.x = (_29.x * 0.5f) + 0.5f;
    _159 = (_138.x * 0.5f) + 0.5f;
    _159 = (_159 * 1.60000002384185791015625f) + (-1.0f);
    _159 = (_105 * _159) + 1.0f;
    _138 = _159.xxx * vs_TEXCOORD3;
    _138 *= _87_m10.xxx;
    _159 = _57.x + (-_87_m7);
    _53.x = _57.x + (-0.5f);
    _53.x *= _87_m8;
    _57.x = (-_87_m7) + 1.0f;
    _159 /= _57.x;
    _159 = clamp(_159, 0.0f, 1.0f);
    _57.x = (-_159) + 1.0f;
    _159 *= _87_m6;
    _223 = _159 * vs_TEXCOORD1.z;
    _231 = (-vs_TEXCOORD2) + _87_m0;
    _240 = dot(_231, _231);
    _244.x = rsqrt(_240);
    _244 = _231 * _244.xxx;
    _159 = dot(-_244, _87_m1.xyz);
    _159 = clamp(_159, 0.0f, 1.0f);
    _127.x = dot(-_244, _127);
    _127.x = clamp(_127.x, 0.0f, 1.0f);
    _127.x *= _127.x;
    _127.x *= _127.x;
    _127.x = _57.x * _127.x;
    _105 *= _127.x;
    _105 = (_105 * _87_m12) + 1.0f;
    _127.x = _159 * _159;
    _127.x *= _127.x;
    _159 *= _127.x;
    _159 = _57.x * _159;
    _159 *= _87_m12;
    _29.x = (_29.x * _87_m11) + _159;
    _57 = _29.xxx * _87_m3.xyz;
    float3 _340 = (_138 * _105.xxx) + _57;
    _29 = float4(_340.x, _340.y, _29.z, _340.z);
    float3 _349 = _29.xyw + _87_m5.xyz;
    _29 = float4(_349.x, _349.y, _29.z, _349.z);
    float3 _358 = _29.xyw * _87_m4.xyz;
    _29 = float4(_358.x, _358.y, _29.z, _358.z);
    _244 = (_29.xyw * vs_TEXCOORD1.www) + (-_87_m2.xyz);
    _231.x = vs_TEXCOORD5;
    _231.x = clamp(_231.x, 0.0f, 1.0f);
    float3 _387 = (_231.xxx * _244) + _87_m2.xyz;
    _379 = float4(_387.x, _387.y, _387.z, _379.w);
    _231.x = _240 + 9.9999997473787516355514526367188e-06f;
    _394 = sqrt(_240);
    _394 += (-_87_m13.x);
    _231.x = rsqrt(_231.x);
    _231.x = (abs(_231.y) * _231.x) + (-0.0040000001899898052215576171875f);
    _231.x *= 21.7391300201416015625f;
    _231.x = clamp(_231.x, 0.0f, 1.0f);
    _425.x = (_231.x * (-2.0f)) + 3.0f;
    _231.x *= _231.x;
    _231.x *= _425.x;
    _425.x = max(_87_m13.y, 0.00999999977648258209228515625f);
    _425.x = _394 / _425.x;
    _425.x = clamp(_425.x, 0.0f, 1.0f);
    _231.x *= _425.x;
    _425 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _425 = min(_425, vs_TEXCOORD1.xy);
    _425.x = min(_425.y, _425.x);
    _425.x = (_53.x * 0.800000011920928955078125f) + _425.x;
    _394 = 1.0f / _87_m8;
    _425.x = _394 * _425.x;
    _425.x = clamp(_425.x, 0.0f, 1.0f);
    _394 = (_425.x * (-2.0f)) + 3.0f;
    _425.x *= _425.x;
    _425.x *= _394;
    _29.x = _231.x * _425.x;
    _379.w = _223 * _29.x;
    _379.w = clamp(_379.w, 0.0f, 1.0f);
    _532 = _379;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._532 = _532;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_ObjectToWorld;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _UseVolume;
float _Scale;
float _Undulate;
float4 _Wind;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _21_m6[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m6[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m6[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m6[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _WorldSpaceCameraPos
#define _21_m2 _ProjectionParams
#define _21_m3 unity_SHAr
#define _21_m4 unity_SHAg
#define _21_m5 unity_SHAb
#define _21_m8 unity_FogParams
#define _21_m9 _TopThin
#define _21_m10 _EyeFade
#define _21_m11 _BottomShade
#define _21_m12 _UseVolume
#define _21_m13 _Scale
#define _21_m14 _Undulate
#define _21_m15 _Wind
#define _21_m16 _GlobalVolumeMin
#define _21_m17 _GlobalVolumeInvSize


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float4 _106;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 vs_TEXCOORD1;
static float2 _483;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _483 : TEXCOORD0;
    float4 _106 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _68;
static float4 _80;
static float4 _93;
static float _136;
static float _141;
static float _196;
static float2 _214;
static float _238;
static bool _278;
static bool _283;
static float4 _336;
static float3 _352;
static float3 _357;
static float3 _381;
static float3 _398;
static float3 _411;
static float _415;

void vert_inner()
{
    __unity_init();
    float3 _29 = _11.yyy * _21_m6[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _41 = (_21_m6[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_41.x, _41.y, _41.z, _9.w);
    float3 _53 = (_21_m6[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _65 = (_21_m6[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_65.x, _65.y, _65.z, _9.w);
    float2 _77 = _9.xz * _21_m13.xx;
    _68 = float4(_77.x, _77.y, _68.z, _68.w);
    _80 = _21_m13.xxxx * _21_m15;
    _80 *= _21_m0.yyyy;
    _93 = _80 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _68 = (_68.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _93;
    float2 _115 = (_106.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _68.xy;
    _68 = float4(_115.x, _115.y, _68.z, _68.w);
    _68.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _68.xy, 2.0f).x;
    _136 = _68.x + (-0.5f);
    _141 = _136 + _136;
    _136 = _141 * _21_m14;
    _9.w = (_136 * _106.w) + _9.y;
    float2 _169 = (_9.xz * _21_m13.xx) + _80.xy;
    _93 = float4(_169.x, _169.y, _93.z, _93.w);
    float2 _182 = (_106.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _93.xy;
    vs_TEXCOORD0 = float4(_182.x, _182.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _193 = (_106.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _68.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _193.x, _193.y);
    _196 = (-_9.w) + _21_m1.y;
    _196 = abs(_196) / _21_m10;
    _196 = clamp(_196, 0.0f, 1.0f);
    _214.x = _21_m9 + (-1.0f);
    _214.x = (_106.w * _214.x) + 1.0f;
    _214.x = _196 * _214.x;
    _214.x = _196 * _214.x;
    _238 = (-_21_m11) + 1.0f;
    _214.y = (_106.w * _238) + _21_m11;
    _68 = _9.wwww * _21_m7[1];
    _68 = (_21_m7[0] * _9.xxxx) + _68;
    _68 = (_21_m7[2] * _9.zzzz) + _68;
    _68 += _21_m7[3];
    _278 = 0.5f < _21_m12;
    _283 = 0.0f < _21_m17.x;
    _278 = _278 && _283;
    _283 = _21_m17.x < 1000000.0f;
    _278 = _278 && _283;
    if (_278)
    {
        float3 _308 = _9.xwz + (-_21_m16);
        _93 = float4(_308.x, _308.y, _308.z, _93.w);
        float3 _315 = _93.xyz * _21_m17;
        _93 = float4(_315.x, _315.y, _315.z, _93.w);
        float3 _322 = clamp(_93.xyz, 0.0f.xxx, 1.0f.xxx);
        _93 = float4(_322.x, _322.y, _322.z, _93.w);
        _80 = _Volume0.SampleLevel(sampler_Volume0, _93.xyz, 0.0f);
        _336 = _Volume1.SampleLevel(sampler_Volume0, _93.xyz, 0.0f);
        _93 = _Volume2.SampleLevel(sampler_Volume0, _93.xyz, 0.0f);
        _352 = max(_80.xyz, 0.0f.xxx);
        _357.x = dot(_336.xyz, 0.3333333432674407958984375f.xxx);
        _357.y = dot(_93.xyz, 0.3333333432674407958984375f.xxx);
        _196 = _80.w + _336.w;
        _196 = _93.w + _196;
        _357.z = _196 * 0.3333333432674407958984375f;
        _381 = _352;
    }
    else
    {
        _381.x = max(_21_m3.w, 0.0f);
        _381.y = max(_21_m4.w, 0.0f);
        _381.z = max(_21_m5.w, 0.0f);
        _398 = _21_m3.xyz + _21_m4.xyz;
        _398 += _21_m5.xyz;
        _411 = _398 * 0.3333333432674407958984375f.xxx;
        _357 = _411;
    }
    _415 = dot(_381, 0.3333333432674407958984375f.xxx);
    _415 = max(_415, 9.9999997473787516355514526367188e-05f);
    float3 _424 = _357 / _415.xxx;
    _93 = float4(_424.x, _424.y, _424.z, _93.w);
    _415 = dot(_93.xyz, _93.xyz);
    _415 = sqrt(_415);
    _278 = 1.0f < _415;
    _415 = 1.0f / _415;
    _415 = _278 ? _415 : 1.0f;
    vs_TEXCOORD4 = _93.xyz * _415.xxx;
    _196 = _68.z / _21_m2.y;
    _196 = (-_196) + 1.0f;
    _196 *= _21_m2.z;
    _196 = max(_196, 0.0f);
    _196 *= _21_m8.x;
    _196 *= (-_196);
    vs_TEXCOORD5 = exp2(_196);
    gl_Position = _68;
    vs_TEXCOORD1 = float4(_483.x, _483.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _214.x, _214.y);
    vs_TEXCOORD2 = _9.xwz;
    vs_TEXCOORD3 = _381;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _106 = stage_input._106;
    _483 = stage_input._483;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float4 _AmbientFloor;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _AmbientBoost;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
#define _87_m0 _WorldSpaceCameraPos
#define _87_m1 _WorldSpaceLightPos0
#define _87_m2 unity_FogColor
#define _87_m3 _LightColor0
#define _87_m4 _Color
#define _87_m5 _AmbientFloor
#define _87_m6 _Density
#define _87_m7 _Cutoff
#define _87_m8 _EdgeFade
#define _87_m9 _Relief
#define _87_m10 _AmbientBoost
#define _87_m11 _DirectStrength
#define _87_m12 _Scatter
#define _87_m13 _NearFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD5;
static float4 _532;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _532 : SV_Target0;
};

static float3 _9;
static float4 _29;
static float3 _44;
static float2 _53;
static float3 _57;
static float _105;
static float3 _127;
static float3 _138;
static float _159;
static float _223;
static float3 _231;
static float _240;
static float3 _244;
static float4 _379;
static float _394;
static float2 _425;

void frag_inner()
{
    _9 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _34 = _9.yz + (-0.5f).xx;
    _29 = float4(_34.x, _34.y, _29.z, _29.w);
    float2 _41 = _29.xy + _29.xy;
    _29 = float4(_41.x, _41.y, _29.z, _29.w);
    _44 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _53 = _44.yz + (-0.5f).xx;
    _57.x = _44.x * 0.3499999940395355224609375f;
    _57.x = (_9.x * 0.64999997615814208984375f) + _57.x;
    float2 _80 = (_53 * 0.89999997615814208984375f.xx) + _29.xy;
    _29 = float4(_80.x, _80.y, _29.z, _29.w);
    float2 _99 = _29.xy * float2(float2(_87_m9, _87_m9));
    _29 = float4(_99.x, _29.y, _99.y, _29.w);
    _29.y = 1.0f;
    _105 = dot(_29.xyz, _29.xyz);
    _105 = rsqrt(_105);
    float3 _117 = _105.xxx * _29.xyz;
    _29 = float4(_117.x, _117.y, _117.z, _29.w);
    _105 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _105 = sqrt(_105);
    _127.x = max(_105, 9.9999997473787516355514526367188e-05f);
    _105 = min(_105, 1.0f);
    _127 = vs_TEXCOORD4 / _127.xxx;
    _138.x = dot(_29.xyz, _127);
    _29.x = dot(_29.xyz, _87_m1.xyz);
    _29.x = (_29.x * 0.5f) + 0.5f;
    _159 = (_138.x * 0.5f) + 0.5f;
    _159 = (_159 * 1.60000002384185791015625f) + (-1.0f);
    _159 = (_105 * _159) + 1.0f;
    _138 = _159.xxx * vs_TEXCOORD3;
    _138 *= _87_m10.xxx;
    _159 = _57.x + (-_87_m7);
    _53.x = _57.x + (-0.5f);
    _53.x *= _87_m8;
    _57.x = (-_87_m7) + 1.0f;
    _159 /= _57.x;
    _159 = clamp(_159, 0.0f, 1.0f);
    _57.x = (-_159) + 1.0f;
    _159 *= _87_m6;
    _223 = _159 * vs_TEXCOORD1.z;
    _231 = (-vs_TEXCOORD2) + _87_m0;
    _240 = dot(_231, _231);
    _244.x = rsqrt(_240);
    _244 = _231 * _244.xxx;
    _159 = dot(-_244, _87_m1.xyz);
    _159 = clamp(_159, 0.0f, 1.0f);
    _127.x = dot(-_244, _127);
    _127.x = clamp(_127.x, 0.0f, 1.0f);
    _127.x *= _127.x;
    _127.x *= _127.x;
    _127.x = _57.x * _127.x;
    _105 *= _127.x;
    _105 = (_105 * _87_m12) + 1.0f;
    _127.x = _159 * _159;
    _127.x *= _127.x;
    _159 *= _127.x;
    _159 = _57.x * _159;
    _159 *= _87_m12;
    _29.x = (_29.x * _87_m11) + _159;
    _57 = _29.xxx * _87_m3.xyz;
    float3 _340 = (_138 * _105.xxx) + _57;
    _29 = float4(_340.x, _340.y, _29.z, _340.z);
    float3 _349 = _29.xyw + _87_m5.xyz;
    _29 = float4(_349.x, _349.y, _29.z, _349.z);
    float3 _358 = _29.xyw * _87_m4.xyz;
    _29 = float4(_358.x, _358.y, _29.z, _358.z);
    _244 = (_29.xyw * vs_TEXCOORD1.www) + (-_87_m2.xyz);
    _231.x = vs_TEXCOORD5;
    _231.x = clamp(_231.x, 0.0f, 1.0f);
    float3 _387 = (_231.xxx * _244) + _87_m2.xyz;
    _379 = float4(_387.x, _387.y, _387.z, _379.w);
    _231.x = _240 + 9.9999997473787516355514526367188e-06f;
    _394 = sqrt(_240);
    _394 += (-_87_m13.x);
    _231.x = rsqrt(_231.x);
    _231.x = (abs(_231.y) * _231.x) + (-0.0040000001899898052215576171875f);
    _231.x *= 21.7391300201416015625f;
    _231.x = clamp(_231.x, 0.0f, 1.0f);
    _425.x = (_231.x * (-2.0f)) + 3.0f;
    _231.x *= _231.x;
    _231.x *= _425.x;
    _425.x = max(_87_m13.y, 0.00999999977648258209228515625f);
    _425.x = _394 / _425.x;
    _425.x = clamp(_425.x, 0.0f, 1.0f);
    _231.x *= _425.x;
    _425 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _425 = min(_425, vs_TEXCOORD1.xy);
    _425.x = min(_425.y, _425.x);
    _425.x = (_53.x * 0.800000011920928955078125f) + _425.x;
    _394 = 1.0f / _87_m8;
    _425.x = _394 * _425.x;
    _425.x = clamp(_425.x, 0.0f, 1.0f);
    _394 = (_425.x * (-2.0f)) + 3.0f;
    _425.x *= _425.x;
    _425.x *= _394;
    _29.x = _231.x * _425.x;
    _379.w = _223 * _29.x;
    _379.w = clamp(_379.w, 0.0f, 1.0f);
    _532 = _379;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._532 = _532;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_ObjectToWorld;
static float4 _21_m6[4];
float4x4 unity_MatrixVP;
static float4 _21_m7[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _UseVolume;
float _Scale;
float _Undulate;
float4 _Wind;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _21_m6[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m6[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m6[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m6[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m7[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m7[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m7[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m7[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _WorldSpaceCameraPos
#define _21_m2 _ProjectionParams
#define _21_m3 unity_SHAr
#define _21_m4 unity_SHAg
#define _21_m5 unity_SHAb
#define _21_m8 unity_FogParams
#define _21_m9 _TopThin
#define _21_m10 _EyeFade
#define _21_m11 _BottomShade
#define _21_m12 _UseVolume
#define _21_m13 _Scale
#define _21_m14 _Undulate
#define _21_m15 _Wind
#define _21_m16 _GlobalVolumeMin
#define _21_m17 _GlobalVolumeInvSize


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float4 _106;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD5;
static float4 vs_TEXCOORD1;
static float2 _480;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _480 : TEXCOORD0;
    float4 _106 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _68;
static float4 _80;
static float4 _93;
static float _136;
static float _141;
static float _196;
static float2 _214;
static float _238;
static bool _278;
static bool _283;
static float4 _336;
static float3 _352;
static float3 _357;
static float3 _381;
static float3 _398;
static float3 _411;
static float _415;

void vert_inner()
{
    __unity_init();
    float3 _29 = _11.yyy * _21_m6[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _41 = (_21_m6[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_41.x, _41.y, _41.z, _9.w);
    float3 _53 = (_21_m6[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _65 = (_21_m6[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_65.x, _65.y, _65.z, _9.w);
    float2 _77 = _9.xz * _21_m13.xx;
    _68 = float4(_77.x, _77.y, _68.z, _68.w);
    _80 = _21_m13.xxxx * _21_m15;
    _80 *= _21_m0.yyyy;
    _93 = _80 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _68 = (_68.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _93;
    float2 _115 = (_106.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _68.xy;
    _68 = float4(_115.x, _115.y, _68.z, _68.w);
    _68.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _68.xy, 2.0f).x;
    _136 = _68.x + (-0.5f);
    _141 = _136 + _136;
    _136 = _141 * _21_m14;
    _9.w = (_136 * _106.w) + _9.y;
    float2 _169 = (_9.xz * _21_m13.xx) + _80.xy;
    _93 = float4(_169.x, _169.y, _93.z, _93.w);
    float2 _182 = (_106.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _93.xy;
    vs_TEXCOORD0 = float4(_182.x, _182.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _193 = (_106.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _68.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _193.x, _193.y);
    _196 = (-_9.w) + _21_m1.y;
    _196 = abs(_196) / _21_m10;
    _196 = clamp(_196, 0.0f, 1.0f);
    _214.x = _21_m9 + (-1.0f);
    _214.x = (_106.w * _214.x) + 1.0f;
    _214.x = _196 * _214.x;
    _214.x = _196 * _214.x;
    _238 = (-_21_m11) + 1.0f;
    _214.y = (_106.w * _238) + _21_m11;
    _68 = _9.wwww * _21_m7[1];
    _68 = (_21_m7[0] * _9.xxxx) + _68;
    _68 = (_21_m7[2] * _9.zzzz) + _68;
    _68 += _21_m7[3];
    _278 = 0.5f < _21_m12;
    _283 = 0.0f < _21_m17.x;
    _278 = _278 && _283;
    _283 = _21_m17.x < 1000000.0f;
    _278 = _278 && _283;
    if (_278)
    {
        float3 _308 = _9.xwz + (-_21_m16);
        _93 = float4(_308.x, _308.y, _308.z, _93.w);
        float3 _315 = _93.xyz * _21_m17;
        _93 = float4(_315.x, _315.y, _315.z, _93.w);
        float3 _322 = clamp(_93.xyz, 0.0f.xxx, 1.0f.xxx);
        _93 = float4(_322.x, _322.y, _322.z, _93.w);
        _80 = _Volume0.SampleLevel(sampler_Volume0, _93.xyz, 0.0f);
        _336 = _Volume1.SampleLevel(sampler_Volume0, _93.xyz, 0.0f);
        _93 = _Volume2.SampleLevel(sampler_Volume0, _93.xyz, 0.0f);
        _352 = max(_80.xyz, 0.0f.xxx);
        _357.x = dot(_336.xyz, 0.3333333432674407958984375f.xxx);
        _357.y = dot(_93.xyz, 0.3333333432674407958984375f.xxx);
        _196 = _80.w + _336.w;
        _196 = _93.w + _196;
        _357.z = _196 * 0.3333333432674407958984375f;
        _381 = _352;
    }
    else
    {
        _381.x = max(_21_m3.w, 0.0f);
        _381.y = max(_21_m4.w, 0.0f);
        _381.z = max(_21_m5.w, 0.0f);
        _398 = _21_m3.xyz + _21_m4.xyz;
        _398 += _21_m5.xyz;
        _411 = _398 * 0.3333333432674407958984375f.xxx;
        _357 = _411;
    }
    _415 = dot(_381, 0.3333333432674407958984375f.xxx);
    _415 = max(_415, 9.9999997473787516355514526367188e-05f);
    float3 _424 = _357 / _415.xxx;
    _93 = float4(_424.x, _424.y, _424.z, _93.w);
    _415 = dot(_93.xyz, _93.xyz);
    _415 = sqrt(_415);
    _278 = 1.0f < _415;
    _415 = 1.0f / _415;
    _415 = _278 ? _415 : 1.0f;
    vs_TEXCOORD4 = _93.xyz * _415.xxx;
    _196 = _68.z / _21_m2.y;
    _196 = (-_196) + 1.0f;
    _196 *= _21_m2.z;
    _196 = max(_196, 0.0f);
    vs_TEXCOORD5 = (_196 * _21_m8.z) + _21_m8.w;
    gl_Position = _68;
    vs_TEXCOORD1 = float4(_480.x, _480.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _214.x, _214.y);
    vs_TEXCOORD2 = _9.xwz;
    vs_TEXCOORD3 = _381;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _106 = stage_input._106;
    _480 = stage_input._480;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_FogColor;
float4 _LightColor0;
float4 _Color;
float4 _AmbientFloor;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _AmbientBoost;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
#define _87_m0 _WorldSpaceCameraPos
#define _87_m1 _WorldSpaceLightPos0
#define _87_m2 unity_FogColor
#define _87_m3 _LightColor0
#define _87_m4 _Color
#define _87_m5 _AmbientFloor
#define _87_m6 _Density
#define _87_m7 _Cutoff
#define _87_m8 _EdgeFade
#define _87_m9 _Relief
#define _87_m10 _AmbientBoost
#define _87_m11 _DirectStrength
#define _87_m12 _Scatter
#define _87_m13 _NearFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD5;
static float4 _532;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _532 : SV_Target0;
};

static float3 _9;
static float4 _29;
static float3 _44;
static float2 _53;
static float3 _57;
static float _105;
static float3 _127;
static float3 _138;
static float _159;
static float _223;
static float3 _231;
static float _240;
static float3 _244;
static float4 _379;
static float _394;
static float2 _425;

void frag_inner()
{
    _9 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _34 = _9.yz + (-0.5f).xx;
    _29 = float4(_34.x, _34.y, _29.z, _29.w);
    float2 _41 = _29.xy + _29.xy;
    _29 = float4(_41.x, _41.y, _29.z, _29.w);
    _44 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _53 = _44.yz + (-0.5f).xx;
    _57.x = _44.x * 0.3499999940395355224609375f;
    _57.x = (_9.x * 0.64999997615814208984375f) + _57.x;
    float2 _80 = (_53 * 0.89999997615814208984375f.xx) + _29.xy;
    _29 = float4(_80.x, _80.y, _29.z, _29.w);
    float2 _99 = _29.xy * float2(float2(_87_m9, _87_m9));
    _29 = float4(_99.x, _29.y, _99.y, _29.w);
    _29.y = 1.0f;
    _105 = dot(_29.xyz, _29.xyz);
    _105 = rsqrt(_105);
    float3 _117 = _105.xxx * _29.xyz;
    _29 = float4(_117.x, _117.y, _117.z, _29.w);
    _105 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _105 = sqrt(_105);
    _127.x = max(_105, 9.9999997473787516355514526367188e-05f);
    _105 = min(_105, 1.0f);
    _127 = vs_TEXCOORD4 / _127.xxx;
    _138.x = dot(_29.xyz, _127);
    _29.x = dot(_29.xyz, _87_m1.xyz);
    _29.x = (_29.x * 0.5f) + 0.5f;
    _159 = (_138.x * 0.5f) + 0.5f;
    _159 = (_159 * 1.60000002384185791015625f) + (-1.0f);
    _159 = (_105 * _159) + 1.0f;
    _138 = _159.xxx * vs_TEXCOORD3;
    _138 *= _87_m10.xxx;
    _159 = _57.x + (-_87_m7);
    _53.x = _57.x + (-0.5f);
    _53.x *= _87_m8;
    _57.x = (-_87_m7) + 1.0f;
    _159 /= _57.x;
    _159 = clamp(_159, 0.0f, 1.0f);
    _57.x = (-_159) + 1.0f;
    _159 *= _87_m6;
    _223 = _159 * vs_TEXCOORD1.z;
    _231 = (-vs_TEXCOORD2) + _87_m0;
    _240 = dot(_231, _231);
    _244.x = rsqrt(_240);
    _244 = _231 * _244.xxx;
    _159 = dot(-_244, _87_m1.xyz);
    _159 = clamp(_159, 0.0f, 1.0f);
    _127.x = dot(-_244, _127);
    _127.x = clamp(_127.x, 0.0f, 1.0f);
    _127.x *= _127.x;
    _127.x *= _127.x;
    _127.x = _57.x * _127.x;
    _105 *= _127.x;
    _105 = (_105 * _87_m12) + 1.0f;
    _127.x = _159 * _159;
    _127.x *= _127.x;
    _159 *= _127.x;
    _159 = _57.x * _159;
    _159 *= _87_m12;
    _29.x = (_29.x * _87_m11) + _159;
    _57 = _29.xxx * _87_m3.xyz;
    float3 _340 = (_138 * _105.xxx) + _57;
    _29 = float4(_340.x, _340.y, _29.z, _340.z);
    float3 _349 = _29.xyw + _87_m5.xyz;
    _29 = float4(_349.x, _349.y, _29.z, _349.z);
    float3 _358 = _29.xyw * _87_m4.xyz;
    _29 = float4(_358.x, _358.y, _29.z, _358.z);
    _244 = (_29.xyw * vs_TEXCOORD1.www) + (-_87_m2.xyz);
    _231.x = vs_TEXCOORD5;
    _231.x = clamp(_231.x, 0.0f, 1.0f);
    float3 _387 = (_231.xxx * _244) + _87_m2.xyz;
    _379 = float4(_387.x, _387.y, _387.z, _379.w);
    _231.x = _240 + 9.9999997473787516355514526367188e-06f;
    _394 = sqrt(_240);
    _394 += (-_87_m13.x);
    _231.x = rsqrt(_231.x);
    _231.x = (abs(_231.y) * _231.x) + (-0.0040000001899898052215576171875f);
    _231.x *= 21.7391300201416015625f;
    _231.x = clamp(_231.x, 0.0f, 1.0f);
    _425.x = (_231.x * (-2.0f)) + 3.0f;
    _231.x *= _231.x;
    _231.x *= _425.x;
    _425.x = max(_87_m13.y, 0.00999999977648258209228515625f);
    _425.x = _394 / _425.x;
    _425.x = clamp(_425.x, 0.0f, 1.0f);
    _231.x *= _425.x;
    _425 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _425 = min(_425, vs_TEXCOORD1.xy);
    _425.x = min(_425.y, _425.x);
    _425.x = (_53.x * 0.800000011920928955078125f) + _425.x;
    _394 = 1.0f / _87_m8;
    _425.x = _394 * _425.x;
    _425.x = clamp(_425.x, 0.0f, 1.0f);
    _394 = (_425.x * (-2.0f)) + 3.0f;
    _425.x *= _425.x;
    _425.x *= _394;
    _29.x = _231.x * _425.x;
    _379.w = _223 * _29.x;
    _379.w = clamp(_379.w, 0.0f, 1.0f);
    _532 = _379;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._532 = _532;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4x4 unity_ObjectToWorld;
static float4 _21_m5[4];
float4x4 unity_MatrixVP;
static float4 _21_m6[4];
float _TopThin;
float _EyeFade;
float _BottomShade;
float _UseVolume;
float _Scale;
float _Undulate;
float4 _Wind;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _21_m5[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m5[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m5[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m5[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m6[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m6[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m6[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m6[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _Time
#define _21_m1 _WorldSpaceCameraPos
#define _21_m2 unity_SHAr
#define _21_m3 unity_SHAg
#define _21_m4 unity_SHAb
#define _21_m7 _TopThin
#define _21_m8 _EyeFade
#define _21_m9 _BottomShade
#define _21_m10 _UseVolume
#define _21_m11 _Scale
#define _21_m12 _Undulate
#define _21_m13 _Wind
#define _21_m14 _GlobalVolumeMin
#define _21_m15 _GlobalVolumeInvSize


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float4 _106;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float4 vs_TEXCOORD1;
static float2 _455;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _455 : TEXCOORD0;
    float4 _106 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _68;
static float4 _80;
static float4 _93;
static float _136;
static float _141;
static float _196;
static float2 _214;
static float _238;
static bool _283;
static bool _288;
static float3 _356;
static float3 _384;
static float3 _400;
static float3 _413;
static float _419;

void vert_inner()
{
    __unity_init();
    float3 _29 = _11.yyy * _21_m5[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _41 = (_21_m5[0].xyz * _11.xxx) + _9.xyz;
    _9 = float4(_41.x, _41.y, _41.z, _9.w);
    float3 _53 = (_21_m5[2].xyz * _11.zzz) + _9.xyz;
    _9 = float4(_53.x, _53.y, _53.z, _9.w);
    float3 _65 = (_21_m5[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_65.x, _65.y, _65.z, _9.w);
    float2 _77 = _9.xz * _21_m11.xx;
    _68 = float4(_77.x, _77.y, _68.z, _68.w);
    _80 = _21_m11.xxxx * _21_m13;
    _80 *= _21_m0.yyyy;
    _93 = _80 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _68 = (_68.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _93;
    float2 _115 = (_106.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _68.xy;
    _68 = float4(_115.x, _115.y, _68.z, _68.w);
    _68.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _68.xy, 2.0f).x;
    _136 = _68.x + (-0.5f);
    _141 = _136 + _136;
    _136 = _141 * _21_m12;
    _9.w = (_136 * _106.w) + _9.y;
    float2 _169 = (_9.xz * _21_m11.xx) + _80.xy;
    _80 = float4(_169.x, _169.y, _80.z, _80.w);
    float2 _182 = (_106.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _80.xy;
    vs_TEXCOORD0 = float4(_182.x, _182.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    float2 _193 = (_106.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _68.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _193.x, _193.y);
    _196 = (-_9.w) + _21_m1.y;
    _196 = abs(_196) / _21_m8;
    _196 = clamp(_196, 0.0f, 1.0f);
    _214.x = _21_m7 + (-1.0f);
    _214.x = (_106.w * _214.x) + 1.0f;
    _214.x = _196 * _214.x;
    _214.x = _196 * _214.x;
    _238 = (-_21_m9) + 1.0f;
    _214.y = (_106.w * _238) + _21_m9;
    _68 = _9.wwww * _21_m6[1];
    _68 = (_21_m6[0] * _9.xxxx) + _68;
    _68 = (_21_m6[2] * _9.zzzz) + _68;
    gl_Position = _68 + _21_m6[3];
    _283 = 0.5f < _21_m10;
    _288 = 0.0f < _21_m15.x;
    _283 = _283 && _288;
    _288 = _21_m15.x < 1000000.0f;
    _283 = _283 && _288;
    if (_283)
    {
        float3 _313 = _9.xwz + (-_21_m14);
        _80 = float4(_313.x, _313.y, _313.z, _80.w);
        float3 _320 = _80.xyz * _21_m15;
        _80 = float4(_320.x, _320.y, _320.z, _80.w);
        float3 _327 = clamp(_80.xyz, 0.0f.xxx, 1.0f.xxx);
        _80 = float4(_327.x, _327.y, _327.z, _80.w);
        _68 = _Volume0.SampleLevel(sampler_Volume0, _80.xyz, 0.0f);
        _93 = _Volume1.SampleLevel(sampler_Volume0, _80.xyz, 0.0f);
        _80 = _Volume2.SampleLevel(sampler_Volume0, _80.xyz, 0.0f);
        _356 = max(_68.xyz, 0.0f.xxx);
        _93.x = dot(_93.xyz, 0.3333333432674407958984375f.xxx);
        _93.y = dot(_80.xyz, 0.3333333432674407958984375f.xxx);
        _196 = _68.w + _93.w;
        _196 = _80.w + _196;
        _93.z = _196 * 0.3333333432674407958984375f;
        _384 = _356;
    }
    else
    {
        _384.x = max(_21_m2.w, 0.0f);
        _384.y = max(_21_m3.w, 0.0f);
        _384.z = max(_21_m4.w, 0.0f);
        _400 = _21_m2.xyz + _21_m3.xyz;
        _400 += _21_m4.xyz;
        _413 = _400 * 0.3333333432674407958984375f.xxx;
        _93 = float4(_413.x, _413.y, _413.z, _93.w);
    }
    _419 = dot(_384, 0.3333333432674407958984375f.xxx);
    _419 = max(_419, 9.9999997473787516355514526367188e-05f);
    float3 _429 = _93.xyz / _419.xxx;
    _80 = float4(_429.x, _429.y, _429.z, _80.w);
    _419 = dot(_80.xyz, _80.xyz);
    _419 = sqrt(_419);
    _283 = 1.0f < _419;
    _419 = 1.0f / _419;
    _419 = _283 ? _419 : 1.0f;
    vs_TEXCOORD4 = _80.xyz * _419.xxx;
    vs_TEXCOORD1 = float4(_455.x, _455.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
    vs_TEXCOORD1 = float4(vs_TEXCOORD1.x, vs_TEXCOORD1.y, _214.x, _214.y);
    vs_TEXCOORD2 = _9.xwz;
    vs_TEXCOORD3 = _384;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _106 = stage_input._106;
    _455 = stage_input._455;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float4 _AmbientFloor;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _AmbientBoost;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
#define _87_m0 _WorldSpaceCameraPos
#define _87_m1 _WorldSpaceLightPos0
#define _87_m2 _LightColor0
#define _87_m3 _Color
#define _87_m4 _AmbientFloor
#define _87_m5 _Density
#define _87_m6 _Cutoff
#define _87_m7 _EdgeFade
#define _87_m8 _Relief
#define _87_m9 _AmbientBoost
#define _87_m10 _DirectStrength
#define _87_m11 _Scatter
#define _87_m12 _NearFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD3;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 _511;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _511 : SV_Target0;
};

static float3 _9;
static float4 _29;
static float3 _44;
static float2 _53;
static float3 _57;
static float _105;
static float3 _127;
static float3 _138;
static float _159;
static float _223;
static float3 _231;
static float _240;
static float3 _244;
static float4 _361;
static float _373;
static float2 _404;

void frag_inner()
{
    _9 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _34 = _9.yz + (-0.5f).xx;
    _29 = float4(_34.x, _34.y, _29.z, _29.w);
    float2 _41 = _29.xy + _29.xy;
    _29 = float4(_41.x, _41.y, _29.z, _29.w);
    _44 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _53 = _44.yz + (-0.5f).xx;
    _57.x = _44.x * 0.3499999940395355224609375f;
    _57.x = (_9.x * 0.64999997615814208984375f) + _57.x;
    float2 _80 = (_53 * 0.89999997615814208984375f.xx) + _29.xy;
    _29 = float4(_80.x, _80.y, _29.z, _29.w);
    float2 _99 = _29.xy * float2(float2(_87_m8, _87_m8));
    _29 = float4(_99.x, _29.y, _99.y, _29.w);
    _29.y = 1.0f;
    _105 = dot(_29.xyz, _29.xyz);
    _105 = rsqrt(_105);
    float3 _117 = _105.xxx * _29.xyz;
    _29 = float4(_117.x, _117.y, _117.z, _29.w);
    _105 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _105 = sqrt(_105);
    _127.x = max(_105, 9.9999997473787516355514526367188e-05f);
    _105 = min(_105, 1.0f);
    _127 = vs_TEXCOORD4 / _127.xxx;
    _138.x = dot(_29.xyz, _127);
    _29.x = dot(_29.xyz, _87_m1.xyz);
    _29.x = (_29.x * 0.5f) + 0.5f;
    _159 = (_138.x * 0.5f) + 0.5f;
    _159 = (_159 * 1.60000002384185791015625f) + (-1.0f);
    _159 = (_105 * _159) + 1.0f;
    _138 = _159.xxx * vs_TEXCOORD3;
    _138 *= _87_m9.xxx;
    _159 = _57.x + (-_87_m6);
    _53.x = _57.x + (-0.5f);
    _53.x *= _87_m7;
    _57.x = (-_87_m6) + 1.0f;
    _159 /= _57.x;
    _159 = clamp(_159, 0.0f, 1.0f);
    _57.x = (-_159) + 1.0f;
    _159 *= _87_m5;
    _223 = _159 * vs_TEXCOORD1.z;
    _231 = (-vs_TEXCOORD2) + _87_m0;
    _240 = dot(_231, _231);
    _244.x = rsqrt(_240);
    _244 = _231 * _244.xxx;
    _159 = dot(-_244, _87_m1.xyz);
    _159 = clamp(_159, 0.0f, 1.0f);
    _127.x = dot(-_244, _127);
    _127.x = clamp(_127.x, 0.0f, 1.0f);
    _127.x *= _127.x;
    _127.x *= _127.x;
    _127.x = _57.x * _127.x;
    _105 *= _127.x;
    _105 = (_105 * _87_m11) + 1.0f;
    _127.x = _159 * _159;
    _127.x *= _127.x;
    _159 *= _127.x;
    _159 = _57.x * _159;
    _159 *= _87_m11;
    _29.x = (_29.x * _87_m10) + _159;
    _57 = _29.xxx * _87_m2.xyz;
    float3 _340 = (_138 * _105.xxx) + _57;
    _29 = float4(_340.x, _340.y, _29.z, _340.z);
    float3 _349 = _29.xyw + _87_m4.xyz;
    _29 = float4(_349.x, _349.y, _29.z, _349.z);
    float3 _358 = _29.xyw * _87_m3.xyz;
    _29 = float4(_358.x, _358.y, _29.z, _358.z);
    float3 _366 = _29.xyw * vs_TEXCOORD1.www;
    _361 = float4(_366.x, _366.y, _366.z, _361.w);
    _231.x = _240 + 9.9999997473787516355514526367188e-06f;
    _373 = sqrt(_240);
    _373 += (-_87_m12.x);
    _231.x = rsqrt(_231.x);
    _231.x = (abs(_231.y) * _231.x) + (-0.0040000001899898052215576171875f);
    _231.x *= 21.7391300201416015625f;
    _231.x = clamp(_231.x, 0.0f, 1.0f);
    _404.x = (_231.x * (-2.0f)) + 3.0f;
    _231.x *= _231.x;
    _231.x *= _404.x;
    _404.x = max(_87_m12.y, 0.00999999977648258209228515625f);
    _404.x = _373 / _404.x;
    _404.x = clamp(_404.x, 0.0f, 1.0f);
    _231.x *= _404.x;
    _404 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _404 = min(_404, vs_TEXCOORD1.xy);
    _404.x = min(_404.y, _404.x);
    _404.x = (_53.x * 0.800000011920928955078125f) + _404.x;
    _373 = 1.0f / _87_m7;
    _404.x = _373 * _404.x;
    _404.x = clamp(_404.x, 0.0f, 1.0f);
    _373 = (_404.x * (-2.0f)) + 3.0f;
    _404.x *= _404.x;
    _404.x *= _373;
    _29.x = _231.x * _404.x;
    _361.w = _223 * _29.x;
    _361.w = clamp(_361.w, 0.0f, 1.0f);
    _511 = _361;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._511 = _511;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "PreviewType" = "Plane" "QUEUE" = "Transparent-10" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend SrcAlpha One
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile __ DIRECTIONAL
#pragma multi_compile __ DIRECTIONAL_COOKIE
#pragma multi_compile __ POINT
#pragma multi_compile __ POINT_COOKIE
#pragma multi_compile __ SPOT
#if defined(DIRECTIONAL) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.y;
    vs_TEXCOORD3 = exp2(-_188);
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
#define _80_m0 _WorldSpaceCameraPos
#define _80_m1 _WorldSpaceLightPos0
#define _80_m2 _LightColor0
#define _80_m3 _Color
#define _80_m4 _Density
#define _80_m5 _Cutoff
#define _80_m6 _EdgeFade
#define _80_m7 _Relief
#define _80_m8 _DirectStrength
#define _80_m9 _Scatter
#define _80_m10 _NearFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float4 _425;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _425 : SV_Target0;
};

static float3 _9;
static float4 _24;
static float3 _39;
static float2 _46;
static float3 _50;
static float _98;
static float3 _113;
static float _145;
static float _182;
static float3 _190;
static float _200;
static float3 _204;
static float4 _276;
static float2 _287;
static float _321;

void frag_inner()
{
    _9 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _29 = _9.yz + (-0.5f).xx;
    _24 = float4(_29.x, _29.y, _24.z, _24.w);
    float2 _36 = _24.xy + _24.xy;
    _24 = float4(_36.x, _36.y, _24.z, _24.w);
    _39 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _46 = _39.yz + (-0.5f).xx;
    _50.x = _39.x * 0.3499999940395355224609375f;
    _50.x = (_9.x * 0.64999997615814208984375f) + _50.x;
    float2 _73 = (_46 * 0.89999997615814208984375f.xx) + _24.xy;
    _24 = float4(_73.x, _73.y, _24.z, _24.w);
    float2 _92 = _24.xy * float2(float2(_80_m7, _80_m7));
    _24 = float4(_92.x, _24.y, _92.y, _24.w);
    _24.y = 1.0f;
    _98 = dot(_24.xyz, _24.xyz);
    _98 = rsqrt(_98);
    float3 _110 = _98.xxx * _24.xyz;
    _24 = float4(_110.x, _110.y, _110.z, _24.w);
    _113.x = dot(_80_m1.xyz, _80_m1.xyz);
    _113.x = rsqrt(_113.x);
    _113 = _113.xxx * _80_m1.xyz;
    _24.x = dot(_24.xyz, _113);
    _24.x = (_24.x * 0.5f) + 0.5f;
    _145 = _50.x + (-_80_m5);
    _46.x = _50.x + (-0.5f);
    _46.x *= _80_m6;
    _98 = (-_80_m5) + 1.0f;
    _145 /= _98;
    _145 = clamp(_145, 0.0f, 1.0f);
    _98 = (-_145) + 1.0f;
    _145 *= _80_m4;
    _182 = _145 * vs_TEXCOORD1.z;
    _190 = (-vs_TEXCOORD2) + _80_m0;
    _200 = dot(_190, _190);
    _204.x = rsqrt(_200);
    _204 = _190 * _204.xxx;
    _145 = dot(-_204, _113);
    _145 = clamp(_145, 0.0f, 1.0f);
    _50.x = _145 * _145;
    _50.x *= _50.x;
    _145 *= _50.x;
    _145 = _98 * _145;
    _145 *= _80_m9;
    _24.x = (_24.x * _80_m8) + _145;
    _50 = _80_m2.xyz * _80_m3.xyz;
    float3 _261 = _24.xxx * _50;
    _24 = float4(_261.x, _261.y, _24.z, _261.z);
    _113 = _24.xyw * vs_TEXCOORD1.www;
    _190.x = vs_TEXCOORD3;
    _190.x = clamp(_190.x, 0.0f, 1.0f);
    float3 _280 = _113 * _190.xxx;
    _276 = float4(_280.x, _280.y, _280.z, _276.w);
    _113.x = _200 + 9.9999997473787516355514526367188e-06f;
    _287.x = sqrt(_200);
    _287.x += (-_80_m10.x);
    _113.x = rsqrt(_113.x);
    _113.x = (abs(_190.y) * _113.x) + (-0.0040000001899898052215576171875f);
    _113.x *= 21.7391300201416015625f;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _321 = (_113.x * (-2.0f)) + 3.0f;
    _113.x *= _113.x;
    _113.x *= _321;
    _321 = max(_80_m10.y, 0.00999999977648258209228515625f);
    _287.x /= _321;
    _287.x = clamp(_287.x, 0.0f, 1.0f);
    _113.x *= _287.x;
    _287 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _287 = min(_287, vs_TEXCOORD1.xy);
    _287.x = min(_287.y, _287.x);
    _287.x = (_46.x * 0.800000011920928955078125f) + _287.x;
    _321 = 1.0f / _80_m6;
    _287.x = _321 * _287.x;
    _287.x = clamp(_287.x, 0.0f, 1.0f);
    _321 = (_287.x * (-2.0f)) + 3.0f;
    _287.x *= _287.x;
    _287.x *= _321;
    _24.x = _113.x * _287.x;
    _276.w = _182 * _24.x;
    _276.w = clamp(_276.w, 0.0f, 1.0f);
    _425 = _276;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._425 = _425;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _305;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _305 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.x;
    _188 *= (-_188);
    vs_TEXCOORD3 = exp2(_188);
    float2 _227 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_227.x, _227.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _244 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_244.x, _244.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_305.x, _305.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _305 = stage_input._305;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
#define _80_m0 _WorldSpaceCameraPos
#define _80_m1 _WorldSpaceLightPos0
#define _80_m2 _LightColor0
#define _80_m3 _Color
#define _80_m4 _Density
#define _80_m5 _Cutoff
#define _80_m6 _EdgeFade
#define _80_m7 _Relief
#define _80_m8 _DirectStrength
#define _80_m9 _Scatter
#define _80_m10 _NearFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float4 _425;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _425 : SV_Target0;
};

static float3 _9;
static float4 _24;
static float3 _39;
static float2 _46;
static float3 _50;
static float _98;
static float3 _113;
static float _145;
static float _182;
static float3 _190;
static float _200;
static float3 _204;
static float4 _276;
static float2 _287;
static float _321;

void frag_inner()
{
    _9 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _29 = _9.yz + (-0.5f).xx;
    _24 = float4(_29.x, _29.y, _24.z, _24.w);
    float2 _36 = _24.xy + _24.xy;
    _24 = float4(_36.x, _36.y, _24.z, _24.w);
    _39 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _46 = _39.yz + (-0.5f).xx;
    _50.x = _39.x * 0.3499999940395355224609375f;
    _50.x = (_9.x * 0.64999997615814208984375f) + _50.x;
    float2 _73 = (_46 * 0.89999997615814208984375f.xx) + _24.xy;
    _24 = float4(_73.x, _73.y, _24.z, _24.w);
    float2 _92 = _24.xy * float2(float2(_80_m7, _80_m7));
    _24 = float4(_92.x, _24.y, _92.y, _24.w);
    _24.y = 1.0f;
    _98 = dot(_24.xyz, _24.xyz);
    _98 = rsqrt(_98);
    float3 _110 = _98.xxx * _24.xyz;
    _24 = float4(_110.x, _110.y, _110.z, _24.w);
    _113.x = dot(_80_m1.xyz, _80_m1.xyz);
    _113.x = rsqrt(_113.x);
    _113 = _113.xxx * _80_m1.xyz;
    _24.x = dot(_24.xyz, _113);
    _24.x = (_24.x * 0.5f) + 0.5f;
    _145 = _50.x + (-_80_m5);
    _46.x = _50.x + (-0.5f);
    _46.x *= _80_m6;
    _98 = (-_80_m5) + 1.0f;
    _145 /= _98;
    _145 = clamp(_145, 0.0f, 1.0f);
    _98 = (-_145) + 1.0f;
    _145 *= _80_m4;
    _182 = _145 * vs_TEXCOORD1.z;
    _190 = (-vs_TEXCOORD2) + _80_m0;
    _200 = dot(_190, _190);
    _204.x = rsqrt(_200);
    _204 = _190 * _204.xxx;
    _145 = dot(-_204, _113);
    _145 = clamp(_145, 0.0f, 1.0f);
    _50.x = _145 * _145;
    _50.x *= _50.x;
    _145 *= _50.x;
    _145 = _98 * _145;
    _145 *= _80_m9;
    _24.x = (_24.x * _80_m8) + _145;
    _50 = _80_m2.xyz * _80_m3.xyz;
    float3 _261 = _24.xxx * _50;
    _24 = float4(_261.x, _261.y, _24.z, _261.z);
    _113 = _24.xyw * vs_TEXCOORD1.www;
    _190.x = vs_TEXCOORD3;
    _190.x = clamp(_190.x, 0.0f, 1.0f);
    float3 _280 = _113 * _190.xxx;
    _276 = float4(_280.x, _280.y, _280.z, _276.w);
    _113.x = _200 + 9.9999997473787516355514526367188e-06f;
    _287.x = sqrt(_200);
    _287.x += (-_80_m10.x);
    _113.x = rsqrt(_113.x);
    _113.x = (abs(_190.y) * _113.x) + (-0.0040000001899898052215576171875f);
    _113.x *= 21.7391300201416015625f;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _321 = (_113.x * (-2.0f)) + 3.0f;
    _113.x *= _113.x;
    _113.x *= _321;
    _321 = max(_80_m10.y, 0.00999999977648258209228515625f);
    _287.x /= _321;
    _287.x = clamp(_287.x, 0.0f, 1.0f);
    _113.x *= _287.x;
    _287 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _287 = min(_287, vs_TEXCOORD1.xy);
    _287.x = min(_287.y, _287.x);
    _287.x = (_46.x * 0.800000011920928955078125f) + _287.x;
    _321 = 1.0f / _80_m6;
    _287.x = _321 * _287.x;
    _287.x = clamp(_287.x, 0.0f, 1.0f);
    _321 = (_287.x * (-2.0f)) + 3.0f;
    _287.x *= _287.x;
    _287.x *= _321;
    _24.x = _113.x * _287.x;
    _276.w = _182 * _24.x;
    _276.w = clamp(_276.w, 0.0f, 1.0f);
    _425 = _276;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._425 = _425;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    vs_TEXCOORD3 = (_188 * _17_m5.z) + _17_m5.w;
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
#define _80_m0 _WorldSpaceCameraPos
#define _80_m1 _WorldSpaceLightPos0
#define _80_m2 _LightColor0
#define _80_m3 _Color
#define _80_m4 _Density
#define _80_m5 _Cutoff
#define _80_m6 _EdgeFade
#define _80_m7 _Relief
#define _80_m8 _DirectStrength
#define _80_m9 _Scatter
#define _80_m10 _NearFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD3;
static float4 _425;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _425 : SV_Target0;
};

static float3 _9;
static float4 _24;
static float3 _39;
static float2 _46;
static float3 _50;
static float _98;
static float3 _113;
static float _145;
static float _182;
static float3 _190;
static float _200;
static float3 _204;
static float4 _276;
static float2 _287;
static float _321;

void frag_inner()
{
    _9 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _29 = _9.yz + (-0.5f).xx;
    _24 = float4(_29.x, _29.y, _24.z, _24.w);
    float2 _36 = _24.xy + _24.xy;
    _24 = float4(_36.x, _36.y, _24.z, _24.w);
    _39 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _46 = _39.yz + (-0.5f).xx;
    _50.x = _39.x * 0.3499999940395355224609375f;
    _50.x = (_9.x * 0.64999997615814208984375f) + _50.x;
    float2 _73 = (_46 * 0.89999997615814208984375f.xx) + _24.xy;
    _24 = float4(_73.x, _73.y, _24.z, _24.w);
    float2 _92 = _24.xy * float2(float2(_80_m7, _80_m7));
    _24 = float4(_92.x, _24.y, _92.y, _24.w);
    _24.y = 1.0f;
    _98 = dot(_24.xyz, _24.xyz);
    _98 = rsqrt(_98);
    float3 _110 = _98.xxx * _24.xyz;
    _24 = float4(_110.x, _110.y, _110.z, _24.w);
    _113.x = dot(_80_m1.xyz, _80_m1.xyz);
    _113.x = rsqrt(_113.x);
    _113 = _113.xxx * _80_m1.xyz;
    _24.x = dot(_24.xyz, _113);
    _24.x = (_24.x * 0.5f) + 0.5f;
    _145 = _50.x + (-_80_m5);
    _46.x = _50.x + (-0.5f);
    _46.x *= _80_m6;
    _98 = (-_80_m5) + 1.0f;
    _145 /= _98;
    _145 = clamp(_145, 0.0f, 1.0f);
    _98 = (-_145) + 1.0f;
    _145 *= _80_m4;
    _182 = _145 * vs_TEXCOORD1.z;
    _190 = (-vs_TEXCOORD2) + _80_m0;
    _200 = dot(_190, _190);
    _204.x = rsqrt(_200);
    _204 = _190 * _204.xxx;
    _145 = dot(-_204, _113);
    _145 = clamp(_145, 0.0f, 1.0f);
    _50.x = _145 * _145;
    _50.x *= _50.x;
    _145 *= _50.x;
    _145 = _98 * _145;
    _145 *= _80_m9;
    _24.x = (_24.x * _80_m8) + _145;
    _50 = _80_m2.xyz * _80_m3.xyz;
    float3 _261 = _24.xxx * _50;
    _24 = float4(_261.x, _261.y, _24.z, _261.z);
    _113 = _24.xyw * vs_TEXCOORD1.www;
    _190.x = vs_TEXCOORD3;
    _190.x = clamp(_190.x, 0.0f, 1.0f);
    float3 _280 = _113 * _190.xxx;
    _276 = float4(_280.x, _280.y, _280.z, _276.w);
    _113.x = _200 + 9.9999997473787516355514526367188e-06f;
    _287.x = sqrt(_200);
    _287.x += (-_80_m10.x);
    _113.x = rsqrt(_113.x);
    _113.x = (abs(_190.y) * _113.x) + (-0.0040000001899898052215576171875f);
    _113.x *= 21.7391300201416015625f;
    _113.x = clamp(_113.x, 0.0f, 1.0f);
    _321 = (_113.x * (-2.0f)) + 3.0f;
    _113.x *= _113.x;
    _113.x *= _321;
    _321 = max(_80_m10.y, 0.00999999977648258209228515625f);
    _287.x /= _321;
    _287.x = clamp(_287.x, 0.0f, 1.0f);
    _113.x *= _287.x;
    _287 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _287 = min(_287, vs_TEXCOORD1.xy);
    _287.x = min(_287.y, _287.x);
    _287.x = (_46.x * 0.800000011920928955078125f) + _287.x;
    _321 = 1.0f / _80_m6;
    _287.x = _321 * _287.x;
    _287.x = clamp(_287.x, 0.0f, 1.0f);
    _321 = (_287.x * (-2.0f)) + 3.0f;
    _287.x *= _287.x;
    _287.x *= _321;
    _24.x = _113.x * _287.x;
    _276.w = _182 * _24.x;
    _276.w = clamp(_276.w, 0.0f, 1.0f);
    _425 = _276;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._425 = _425;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.y;
    vs_TEXCOORD3 = exp2(-_188);
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _21_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _21_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _21_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _21_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _21_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _WorldSpaceLightPos0
#define _21_m2 _LightColor0
#define _21_m4 _Color
#define _21_m5 _Density
#define _21_m6 _Cutoff
#define _21_m7 _EdgeFade
#define _21_m8 _Relief
#define _21_m9 _DirectStrength
#define _21_m10 _Scatter
#define _21_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _459;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _459 : SV_Target0;
};

static float3 _9;
static float3 _77;
static float3 _90;
static float3 _99;
static float3 _114;
static float2 _121;
static float _125;
static float _163;
static float _201;
static float _236;
static float3 _244;
static float _251;
static float3 _255;
static float4 _312;
static float2 _323;
static float _357;

void frag_inner()
{
    __unity_init();
    float2 _29 = vs_TEXCOORD2.yy * _21_m3[1].xy;
    _9 = float3(_29.x, _29.y, _9.z);
    float2 _41 = (_21_m3[0].xy * vs_TEXCOORD2.xx) + _9.xy;
    _9 = float3(_41.x, _41.y, _9.z);
    float2 _53 = (_21_m3[2].xy * vs_TEXCOORD2.zz) + _9.xy;
    _9 = float3(_53.x, _53.y, _9.z);
    float2 _61 = _9.xy + _21_m3[3].xy;
    _9 = float3(_61.x, _61.y, _9.z);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9.xy).w;
    _77 = _21_m2.xyz * _21_m4.xyz;
    _77 = _9.xxx * _77;
    _90 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _104 = _90.yz + (-0.5f).xx;
    _99 = float3(_104.x, _104.y, _99.z);
    float2 _111 = _99.xy + _99.xy;
    _99 = float3(_111.x, _111.y, _99.z);
    _114 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _121 = _114.yz + (-0.5f).xx;
    _125 = _114.x * 0.3499999940395355224609375f;
    _125 = (_90.x * 0.64999997615814208984375f) + _125;
    float2 _142 = (_121 * 0.89999997615814208984375f.xx) + _99.xy;
    _99 = float3(_142.x, _142.y, _99.z);
    float2 _157 = _99.xy * float2(float2(_21_m8, _21_m8));
    _99 = float3(_157.x, _99.y, _157.y);
    _99.y = 1.0f;
    _163 = dot(_99, _99);
    _163 = rsqrt(_163);
    _99 = _163.xxx * _99;
    _9.x = dot(_21_m1.xyz, _21_m1.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _21_m1.xyz;
    _99.x = dot(_99, _9);
    _99.x = (_99.x * 0.5f) + 0.5f;
    _201 = _125 + (-_21_m6);
    _125 += (-0.5f);
    _125 *= _21_m7;
    _121.x = (-_21_m6) + 1.0f;
    _201 /= _121.x;
    _201 = clamp(_201, 0.0f, 1.0f);
    _121.x = (-_201) + 1.0f;
    _201 *= _21_m5;
    _236 = _201 * vs_TEXCOORD1.z;
    _244 = (-vs_TEXCOORD2) + _21_m0;
    _251 = dot(_244, _244);
    _255.x = rsqrt(_251);
    _255 = _244 * _255.xxx;
    _201 = dot(-_255, _9);
    _201 = clamp(_201, 0.0f, 1.0f);
    _163 = _201 * _201;
    _163 *= _163;
    _201 = _163 * _201;
    _201 = _121.x * _201;
    _201 *= _21_m10;
    _99.x = (_99.x * _21_m9) + _201;
    _77 *= _99.xxx;
    _9 = _77 * vs_TEXCOORD1.www;
    _244.x = vs_TEXCOORD3;
    _244.x = clamp(_244.x, 0.0f, 1.0f);
    float3 _316 = _9 * _244.xxx;
    _312 = float4(_316.x, _316.y, _316.z, _312.w);
    _9.x = _251 + 9.9999997473787516355514526367188e-06f;
    _323.x = sqrt(_251);
    _323.x += (-_21_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_244.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _357 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _357;
    _357 = max(_21_m11.y, 0.00999999977648258209228515625f);
    _323.x /= _357;
    _323.x = clamp(_323.x, 0.0f, 1.0f);
    _9.x *= _323.x;
    _323 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _323 = min(_323, vs_TEXCOORD1.xy);
    _323.x = min(_323.y, _323.x);
    _323.x = (_125 * 0.800000011920928955078125f) + _323.x;
    _357 = 1.0f / _21_m7;
    _323.x = _357 * _323.x;
    _323.x = clamp(_323.x, 0.0f, 1.0f);
    _357 = (_323.x * (-2.0f)) + 3.0f;
    _323.x *= _323.x;
    _323.x *= _357;
    _77.x = _9.x * _323.x;
    _312.w = _236 * _77.x;
    _312.w = clamp(_312.w, 0.0f, 1.0f);
    _459 = _312;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._459 = _459;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _305;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _305 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.x;
    _188 *= (-_188);
    vs_TEXCOORD3 = exp2(_188);
    float2 _227 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_227.x, _227.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _244 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_244.x, _244.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_305.x, _305.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _305 = stage_input._305;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _21_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _21_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _21_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _21_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _21_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _WorldSpaceLightPos0
#define _21_m2 _LightColor0
#define _21_m4 _Color
#define _21_m5 _Density
#define _21_m6 _Cutoff
#define _21_m7 _EdgeFade
#define _21_m8 _Relief
#define _21_m9 _DirectStrength
#define _21_m10 _Scatter
#define _21_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _459;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _459 : SV_Target0;
};

static float3 _9;
static float3 _77;
static float3 _90;
static float3 _99;
static float3 _114;
static float2 _121;
static float _125;
static float _163;
static float _201;
static float _236;
static float3 _244;
static float _251;
static float3 _255;
static float4 _312;
static float2 _323;
static float _357;

void frag_inner()
{
    __unity_init();
    float2 _29 = vs_TEXCOORD2.yy * _21_m3[1].xy;
    _9 = float3(_29.x, _29.y, _9.z);
    float2 _41 = (_21_m3[0].xy * vs_TEXCOORD2.xx) + _9.xy;
    _9 = float3(_41.x, _41.y, _9.z);
    float2 _53 = (_21_m3[2].xy * vs_TEXCOORD2.zz) + _9.xy;
    _9 = float3(_53.x, _53.y, _9.z);
    float2 _61 = _9.xy + _21_m3[3].xy;
    _9 = float3(_61.x, _61.y, _9.z);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9.xy).w;
    _77 = _21_m2.xyz * _21_m4.xyz;
    _77 = _9.xxx * _77;
    _90 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _104 = _90.yz + (-0.5f).xx;
    _99 = float3(_104.x, _104.y, _99.z);
    float2 _111 = _99.xy + _99.xy;
    _99 = float3(_111.x, _111.y, _99.z);
    _114 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _121 = _114.yz + (-0.5f).xx;
    _125 = _114.x * 0.3499999940395355224609375f;
    _125 = (_90.x * 0.64999997615814208984375f) + _125;
    float2 _142 = (_121 * 0.89999997615814208984375f.xx) + _99.xy;
    _99 = float3(_142.x, _142.y, _99.z);
    float2 _157 = _99.xy * float2(float2(_21_m8, _21_m8));
    _99 = float3(_157.x, _99.y, _157.y);
    _99.y = 1.0f;
    _163 = dot(_99, _99);
    _163 = rsqrt(_163);
    _99 = _163.xxx * _99;
    _9.x = dot(_21_m1.xyz, _21_m1.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _21_m1.xyz;
    _99.x = dot(_99, _9);
    _99.x = (_99.x * 0.5f) + 0.5f;
    _201 = _125 + (-_21_m6);
    _125 += (-0.5f);
    _125 *= _21_m7;
    _121.x = (-_21_m6) + 1.0f;
    _201 /= _121.x;
    _201 = clamp(_201, 0.0f, 1.0f);
    _121.x = (-_201) + 1.0f;
    _201 *= _21_m5;
    _236 = _201 * vs_TEXCOORD1.z;
    _244 = (-vs_TEXCOORD2) + _21_m0;
    _251 = dot(_244, _244);
    _255.x = rsqrt(_251);
    _255 = _244 * _255.xxx;
    _201 = dot(-_255, _9);
    _201 = clamp(_201, 0.0f, 1.0f);
    _163 = _201 * _201;
    _163 *= _163;
    _201 = _163 * _201;
    _201 = _121.x * _201;
    _201 *= _21_m10;
    _99.x = (_99.x * _21_m9) + _201;
    _77 *= _99.xxx;
    _9 = _77 * vs_TEXCOORD1.www;
    _244.x = vs_TEXCOORD3;
    _244.x = clamp(_244.x, 0.0f, 1.0f);
    float3 _316 = _9 * _244.xxx;
    _312 = float4(_316.x, _316.y, _316.z, _312.w);
    _9.x = _251 + 9.9999997473787516355514526367188e-06f;
    _323.x = sqrt(_251);
    _323.x += (-_21_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_244.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _357 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _357;
    _357 = max(_21_m11.y, 0.00999999977648258209228515625f);
    _323.x /= _357;
    _323.x = clamp(_323.x, 0.0f, 1.0f);
    _9.x *= _323.x;
    _323 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _323 = min(_323, vs_TEXCOORD1.xy);
    _323.x = min(_323.y, _323.x);
    _323.x = (_125 * 0.800000011920928955078125f) + _323.x;
    _357 = 1.0f / _21_m7;
    _323.x = _357 * _323.x;
    _323.x = clamp(_323.x, 0.0f, 1.0f);
    _357 = (_323.x * (-2.0f)) + 3.0f;
    _323.x *= _323.x;
    _323.x *= _357;
    _77.x = _9.x * _323.x;
    _312.w = _236 * _77.x;
    _312.w = clamp(_312.w, 0.0f, 1.0f);
    _459 = _312;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._459 = _459;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    vs_TEXCOORD3 = (_188 * _17_m5.z) + _17_m5.w;
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _21_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _21_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _21_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _21_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _21_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _WorldSpaceLightPos0
#define _21_m2 _LightColor0
#define _21_m4 _Color
#define _21_m5 _Density
#define _21_m6 _Cutoff
#define _21_m7 _EdgeFade
#define _21_m8 _Relief
#define _21_m9 _DirectStrength
#define _21_m10 _Scatter
#define _21_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _459;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _459 : SV_Target0;
};

static float3 _9;
static float3 _77;
static float3 _90;
static float3 _99;
static float3 _114;
static float2 _121;
static float _125;
static float _163;
static float _201;
static float _236;
static float3 _244;
static float _251;
static float3 _255;
static float4 _312;
static float2 _323;
static float _357;

void frag_inner()
{
    __unity_init();
    float2 _29 = vs_TEXCOORD2.yy * _21_m3[1].xy;
    _9 = float3(_29.x, _29.y, _9.z);
    float2 _41 = (_21_m3[0].xy * vs_TEXCOORD2.xx) + _9.xy;
    _9 = float3(_41.x, _41.y, _9.z);
    float2 _53 = (_21_m3[2].xy * vs_TEXCOORD2.zz) + _9.xy;
    _9 = float3(_53.x, _53.y, _9.z);
    float2 _61 = _9.xy + _21_m3[3].xy;
    _9 = float3(_61.x, _61.y, _9.z);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9.xy).w;
    _77 = _21_m2.xyz * _21_m4.xyz;
    _77 = _9.xxx * _77;
    _90 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _104 = _90.yz + (-0.5f).xx;
    _99 = float3(_104.x, _104.y, _99.z);
    float2 _111 = _99.xy + _99.xy;
    _99 = float3(_111.x, _111.y, _99.z);
    _114 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _121 = _114.yz + (-0.5f).xx;
    _125 = _114.x * 0.3499999940395355224609375f;
    _125 = (_90.x * 0.64999997615814208984375f) + _125;
    float2 _142 = (_121 * 0.89999997615814208984375f.xx) + _99.xy;
    _99 = float3(_142.x, _142.y, _99.z);
    float2 _157 = _99.xy * float2(float2(_21_m8, _21_m8));
    _99 = float3(_157.x, _99.y, _157.y);
    _99.y = 1.0f;
    _163 = dot(_99, _99);
    _163 = rsqrt(_163);
    _99 = _163.xxx * _99;
    _9.x = dot(_21_m1.xyz, _21_m1.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _21_m1.xyz;
    _99.x = dot(_99, _9);
    _99.x = (_99.x * 0.5f) + 0.5f;
    _201 = _125 + (-_21_m6);
    _125 += (-0.5f);
    _125 *= _21_m7;
    _121.x = (-_21_m6) + 1.0f;
    _201 /= _121.x;
    _201 = clamp(_201, 0.0f, 1.0f);
    _121.x = (-_201) + 1.0f;
    _201 *= _21_m5;
    _236 = _201 * vs_TEXCOORD1.z;
    _244 = (-vs_TEXCOORD2) + _21_m0;
    _251 = dot(_244, _244);
    _255.x = rsqrt(_251);
    _255 = _244 * _255.xxx;
    _201 = dot(-_255, _9);
    _201 = clamp(_201, 0.0f, 1.0f);
    _163 = _201 * _201;
    _163 *= _163;
    _201 = _163 * _201;
    _201 = _121.x * _201;
    _201 *= _21_m10;
    _99.x = (_99.x * _21_m9) + _201;
    _77 *= _99.xxx;
    _9 = _77 * vs_TEXCOORD1.www;
    _244.x = vs_TEXCOORD3;
    _244.x = clamp(_244.x, 0.0f, 1.0f);
    float3 _316 = _9 * _244.xxx;
    _312 = float4(_316.x, _316.y, _316.z, _312.w);
    _9.x = _251 + 9.9999997473787516355514526367188e-06f;
    _323.x = sqrt(_251);
    _323.x += (-_21_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_244.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _357 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _357;
    _357 = max(_21_m11.y, 0.00999999977648258209228515625f);
    _323.x /= _357;
    _323.x = clamp(_323.x, 0.0f, 1.0f);
    _9.x *= _323.x;
    _323 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _323 = min(_323, vs_TEXCOORD1.xy);
    _323.x = min(_323.y, _323.x);
    _323.x = (_125 * 0.800000011920928955078125f) + _323.x;
    _357 = 1.0f / _21_m7;
    _323.x = _357 * _323.x;
    _323.x = clamp(_323.x, 0.0f, 1.0f);
    _357 = (_323.x * (-2.0f)) + 3.0f;
    _323.x *= _323.x;
    _323.x *= _357;
    _77.x = _9.x * _323.x;
    _312.w = _236 * _77.x;
    _312.w = clamp(_312.w, 0.0f, 1.0f);
    _459 = _312;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._459 = _459;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.y;
    vs_TEXCOORD3 = exp2(-_188);
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _449;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _449 : SV_Target0;
};

static float3 _9;
static float3 _69;
static float3 _82;
static float3 _91;
static float3 _106;
static float2 _113;
static float _117;
static float _155;
static float _171;
static float _191;
static float3 _233;
static float _240;
static float3 _244;
static float4 _301;
static float2 _312;
static float _346;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _20_m3[1].xyz;
    _9 = (_20_m3[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_20_m3[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _20_m3[3].xyz;
    _9.x = dot(_9, _9);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9.xx).x;
    _69 = _20_m2.xyz * _20_m4.xyz;
    _69 = _9.xxx * _69;
    _82 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _96 = _82.yz + (-0.5f).xx;
    _91 = float3(_96.x, _96.y, _91.z);
    float2 _103 = _91.xy + _91.xy;
    _91 = float3(_103.x, _103.y, _91.z);
    _106 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _113 = _106.yz + (-0.5f).xx;
    _117 = _106.x * 0.3499999940395355224609375f;
    _117 = (_82.x * 0.64999997615814208984375f) + _117;
    float2 _134 = (_113 * 0.89999997615814208984375f.xx) + _91.xy;
    _91 = float3(_134.x, _134.y, _91.z);
    float2 _149 = _91.xy * float2(float2(_20_m8, _20_m8));
    _91 = float3(_149.x, _91.y, _149.y);
    _91.y = 1.0f;
    _155 = dot(_91, _91);
    _155 = rsqrt(_155);
    _91 = _155.xxx * _91;
    _9 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _171 = dot(_9, _9);
    _171 = rsqrt(_171);
    _9 = _171.xxx * _9;
    _91.x = dot(_91, _9);
    _91.x = (_91.x * 0.5f) + 0.5f;
    _191 = _117 + (-_20_m6);
    _117 += (-0.5f);
    _117 *= _20_m7;
    _113.x = (-_20_m6) + 1.0f;
    _191 /= _113.x;
    _191 = clamp(_191, 0.0f, 1.0f);
    _113.x = (-_191) + 1.0f;
    _191 *= _20_m5;
    _171 = _191 * vs_TEXCOORD1.z;
    _233 = (-vs_TEXCOORD2) + _20_m0;
    _240 = dot(_233, _233);
    _244.x = rsqrt(_240);
    _244 = _233 * _244.xxx;
    _191 = dot(-_244, _9);
    _191 = clamp(_191, 0.0f, 1.0f);
    _155 = _191 * _191;
    _155 *= _155;
    _191 = _155 * _191;
    _191 = _113.x * _191;
    _191 *= _20_m10;
    _91.x = (_91.x * _20_m9) + _191;
    _69 *= _91.xxx;
    _9 = _69 * vs_TEXCOORD1.www;
    _233.x = vs_TEXCOORD3;
    _233.x = clamp(_233.x, 0.0f, 1.0f);
    float3 _305 = _9 * _233.xxx;
    _301 = float4(_305.x, _305.y, _305.z, _301.w);
    _9.x = _240 + 9.9999997473787516355514526367188e-06f;
    _312.x = sqrt(_240);
    _312.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_233.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _346 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _346;
    _346 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _312.x /= _346;
    _312.x = clamp(_312.x, 0.0f, 1.0f);
    _9.x *= _312.x;
    _312 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _312 = min(_312, vs_TEXCOORD1.xy);
    _312.x = min(_312.y, _312.x);
    _312.x = (_117 * 0.800000011920928955078125f) + _312.x;
    _346 = 1.0f / _20_m7;
    _312.x = _346 * _312.x;
    _312.x = clamp(_312.x, 0.0f, 1.0f);
    _346 = (_312.x * (-2.0f)) + 3.0f;
    _312.x *= _312.x;
    _312.x *= _346;
    _69.x = _9.x * _312.x;
    _301.w = _171 * _69.x;
    _301.w = clamp(_301.w, 0.0f, 1.0f);
    _449 = _301;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._449 = _449;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.y;
    vs_TEXCOORD3 = exp2(-_188);
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _463;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _463 : SV_Target0;
};

static float3 _9;
static float _53;
static float2 _70;
static float3 _87;
static float3 _100;
static float3 _109;
static float3 _124;
static float2 _130;
static float _134;
static float _172;
static float _207;
static float3 _249;
static float _256;
static float3 _260;
static float4 _317;
static float _361;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _20_m3[1].xyz;
    _9 = (_20_m3[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_20_m3[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _20_m3[3].xyz;
    _53 = dot(_9, _9);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9).w;
    _70.x = _LightTextureB0.Sample(sampler_LightTextureB0, _53.xx).x;
    _9.x *= _70.x;
    _87 = _20_m2.xyz * _20_m4.xyz;
    _87 = _9.xxx * _87;
    _100 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _114 = _100.yz + (-0.5f).xx;
    _109 = float3(_114.x, _114.y, _109.z);
    float2 _121 = _109.xy + _109.xy;
    _109 = float3(_121.x, _121.y, _109.z);
    _124 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _130 = _124.yz + (-0.5f).xx;
    _134 = _124.x * 0.3499999940395355224609375f;
    _134 = (_100.x * 0.64999997615814208984375f) + _134;
    float2 _151 = (_130 * 0.89999997615814208984375f.xx) + _109.xy;
    _109 = float3(_151.x, _151.y, _109.z);
    float2 _166 = _109.xy * float2(float2(_20_m8, _20_m8));
    _109 = float3(_166.x, _109.y, _166.y);
    _109.y = 1.0f;
    _172 = dot(_109, _109);
    _172 = rsqrt(_172);
    _109 = _172.xxx * _109;
    _9 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _53 = dot(_9, _9);
    _53 = rsqrt(_53);
    _9 = _53.xxx * _9;
    _109.x = dot(_109, _9);
    _109.x = (_109.x * 0.5f) + 0.5f;
    _207 = _134 + (-_20_m6);
    _134 += (-0.5f);
    _134 *= _20_m7;
    _130.x = (-_20_m6) + 1.0f;
    _207 /= _130.x;
    _207 = clamp(_207, 0.0f, 1.0f);
    _130.x = (-_207) + 1.0f;
    _207 *= _20_m5;
    _53 = _207 * vs_TEXCOORD1.z;
    _249 = (-vs_TEXCOORD2) + _20_m0;
    _256 = dot(_249, _249);
    _260.x = rsqrt(_256);
    _260 = _249 * _260.xxx;
    _207 = dot(-_260, _9);
    _207 = clamp(_207, 0.0f, 1.0f);
    _172 = _207 * _207;
    _172 *= _172;
    _207 = _172 * _207;
    _207 = _130.x * _207;
    _207 *= _20_m10;
    _109.x = (_109.x * _20_m9) + _207;
    _87 *= _109.xxx;
    _9 = _87 * vs_TEXCOORD1.www;
    _249.x = vs_TEXCOORD3;
    _249.x = clamp(_249.x, 0.0f, 1.0f);
    float3 _321 = _9 * _249.xxx;
    _317 = float4(_321.x, _321.y, _321.z, _317.w);
    _9.x = _256 + 9.9999997473787516355514526367188e-06f;
    _70.x = sqrt(_256);
    _70.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_249.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _361 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _361;
    _361 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _70.x /= _361;
    _70.x = clamp(_70.x, 0.0f, 1.0f);
    _9.x *= _70.x;
    _70 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _70 = min(_70, vs_TEXCOORD1.xy);
    _70.x = min(_70.y, _70.x);
    _70.x = (_134 * 0.800000011920928955078125f) + _70.x;
    _361 = 1.0f / _20_m7;
    _70.x = _361 * _70.x;
    _70.x = clamp(_70.x, 0.0f, 1.0f);
    _361 = (_70.x * (-2.0f)) + 3.0f;
    _70.x *= _70.x;
    _70.x *= _361;
    _87.x = _9.x * _70.x;
    _317.w = _53 * _87.x;
    _317.w = clamp(_317.w, 0.0f, 1.0f);
    _463 = _317;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._463 = _463;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.y;
    vs_TEXCOORD3 = exp2(-_188);
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _499;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _499 : SV_Target0;
};

static float4 _9;
static float3 _49;
static float _66;
static bool _79;
static float3 _99;
static float3 _115;
static float3 _128;
static float3 _137;
static float3 _152;
static float2 _159;
static float _163;
static float _200;
static float _242;
static float _288;
static float3 _292;
static float4 _351;
static float2 _363;
static float _397;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyyy * _20_m3[1];
    _9 = (_20_m3[0] * vs_TEXCOORD2.xxxx) + _9;
    _9 = (_20_m3[2] * vs_TEXCOORD2.zzzz) + _9;
    _9 += _20_m3[3];
    float2 _55 = _9.xy / _9.ww;
    _49 = float3(_55.x, _55.y, _49.z);
    float2 _62 = _49.xy + 0.5f.xx;
    _49 = float3(_62.x, _62.y, _49.z);
    _66 = _LightTexture0.Sample(sampler_LightTexture0, _49.xy).w;
    _79 = 0.0f < _9.z;
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = _LightTextureB0.Sample(sampler_LightTextureB0, _9.xx).x;
    _99.x = float(_79);
    _99.x = _66 * _99.x;
    _99.x = _9.x * _99.x;
    _115 = _20_m2.xyz * _20_m4.xyz;
    _99 = _99.xxx * _115;
    _128 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _142 = _128.yz + (-0.5f).xx;
    _137 = float3(_142.x, _142.y, _137.z);
    float2 _149 = _137.xy + _137.xy;
    _137 = float3(_149.x, _149.y, _137.z);
    _152 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _159 = _152.yz + (-0.5f).xx;
    _163 = _152.x * 0.3499999940395355224609375f;
    _163 = (_128.x * 0.64999997615814208984375f) + _163;
    float2 _180 = (_159 * 0.89999997615814208984375f.xx) + _137.xy;
    _137 = float3(_180.x, _180.y, _137.z);
    float2 _195 = _137.xy * float2(float2(_20_m8, _20_m8));
    _137 = float3(_195.x, _137.y, _195.y);
    _137.y = 1.0f;
    _200 = dot(_137, _137);
    _200 = rsqrt(_200);
    _137 = _200.xxx * _137;
    float3 _215 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _9 = float4(_215.x, _215.y, _215.z, _9.w);
    _66 = dot(_9.xyz, _9.xyz);
    _66 = rsqrt(_66);
    float3 _229 = _66.xxx * _9.xyz;
    _9 = float4(_229.x, _229.y, _229.z, _9.w);
    _137.x = dot(_137, _9.xyz);
    _137.x = (_137.x * 0.5f) + 0.5f;
    _242 = _163 + (-_20_m6);
    _163 += (-0.5f);
    _163 *= _20_m7;
    _159.x = (-_20_m6) + 1.0f;
    _242 /= _159.x;
    _242 = clamp(_242, 0.0f, 1.0f);
    _159.x = (-_242) + 1.0f;
    _242 *= _20_m5;
    _66 = _242 * vs_TEXCOORD1.z;
    _49 = (-vs_TEXCOORD2) + _20_m0;
    _288 = dot(_49, _49);
    _292.x = rsqrt(_288);
    _292 = _49 * _292.xxx;
    _242 = dot(-_292, _9.xyz);
    _242 = clamp(_242, 0.0f, 1.0f);
    _200 = _242 * _242;
    _200 *= _200;
    _242 = _200 * _242;
    _242 = _159.x * _242;
    _242 *= _20_m10;
    _137.x = (_137.x * _20_m9) + _242;
    _99 *= _137.xxx;
    float3 _341 = _99 * vs_TEXCOORD1.www;
    _9 = float4(_341.x, _341.y, _341.z, _9.w);
    _49.x = vs_TEXCOORD3;
    _49.x = clamp(_49.x, 0.0f, 1.0f);
    float3 _356 = _9.xyz * _49.xxx;
    _351 = float4(_356.x, _356.y, _356.z, _351.w);
    _9.x = _288 + 9.9999997473787516355514526367188e-06f;
    _363.x = sqrt(_288);
    _363.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_49.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _397 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _397;
    _397 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _363.x /= _397;
    _363.x = clamp(_363.x, 0.0f, 1.0f);
    _9.x *= _363.x;
    _363 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _363 = min(_363, vs_TEXCOORD1.xy);
    _363.x = min(_363.y, _363.x);
    _363.x = (_163 * 0.800000011920928955078125f) + _363.x;
    _397 = 1.0f / _20_m7;
    _363.x = _397 * _363.x;
    _363.x = clamp(_363.x, 0.0f, 1.0f);
    _397 = (_363.x * (-2.0f)) + 3.0f;
    _363.x *= _363.x;
    _363.x *= _397;
    _99.x = _9.x * _363.x;
    _351.w = _66 * _99.x;
    _351.w = clamp(_351.w, 0.0f, 1.0f);
    _499 = _351;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._499 = _499;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _305;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _305 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.x;
    _188 *= (-_188);
    vs_TEXCOORD3 = exp2(_188);
    float2 _227 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_227.x, _227.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _244 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_244.x, _244.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_305.x, _305.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _305 = stage_input._305;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _449;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _449 : SV_Target0;
};

static float3 _9;
static float3 _69;
static float3 _82;
static float3 _91;
static float3 _106;
static float2 _113;
static float _117;
static float _155;
static float _171;
static float _191;
static float3 _233;
static float _240;
static float3 _244;
static float4 _301;
static float2 _312;
static float _346;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _20_m3[1].xyz;
    _9 = (_20_m3[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_20_m3[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _20_m3[3].xyz;
    _9.x = dot(_9, _9);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9.xx).x;
    _69 = _20_m2.xyz * _20_m4.xyz;
    _69 = _9.xxx * _69;
    _82 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _96 = _82.yz + (-0.5f).xx;
    _91 = float3(_96.x, _96.y, _91.z);
    float2 _103 = _91.xy + _91.xy;
    _91 = float3(_103.x, _103.y, _91.z);
    _106 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _113 = _106.yz + (-0.5f).xx;
    _117 = _106.x * 0.3499999940395355224609375f;
    _117 = (_82.x * 0.64999997615814208984375f) + _117;
    float2 _134 = (_113 * 0.89999997615814208984375f.xx) + _91.xy;
    _91 = float3(_134.x, _134.y, _91.z);
    float2 _149 = _91.xy * float2(float2(_20_m8, _20_m8));
    _91 = float3(_149.x, _91.y, _149.y);
    _91.y = 1.0f;
    _155 = dot(_91, _91);
    _155 = rsqrt(_155);
    _91 = _155.xxx * _91;
    _9 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _171 = dot(_9, _9);
    _171 = rsqrt(_171);
    _9 = _171.xxx * _9;
    _91.x = dot(_91, _9);
    _91.x = (_91.x * 0.5f) + 0.5f;
    _191 = _117 + (-_20_m6);
    _117 += (-0.5f);
    _117 *= _20_m7;
    _113.x = (-_20_m6) + 1.0f;
    _191 /= _113.x;
    _191 = clamp(_191, 0.0f, 1.0f);
    _113.x = (-_191) + 1.0f;
    _191 *= _20_m5;
    _171 = _191 * vs_TEXCOORD1.z;
    _233 = (-vs_TEXCOORD2) + _20_m0;
    _240 = dot(_233, _233);
    _244.x = rsqrt(_240);
    _244 = _233 * _244.xxx;
    _191 = dot(-_244, _9);
    _191 = clamp(_191, 0.0f, 1.0f);
    _155 = _191 * _191;
    _155 *= _155;
    _191 = _155 * _191;
    _191 = _113.x * _191;
    _191 *= _20_m10;
    _91.x = (_91.x * _20_m9) + _191;
    _69 *= _91.xxx;
    _9 = _69 * vs_TEXCOORD1.www;
    _233.x = vs_TEXCOORD3;
    _233.x = clamp(_233.x, 0.0f, 1.0f);
    float3 _305 = _9 * _233.xxx;
    _301 = float4(_305.x, _305.y, _305.z, _301.w);
    _9.x = _240 + 9.9999997473787516355514526367188e-06f;
    _312.x = sqrt(_240);
    _312.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_233.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _346 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _346;
    _346 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _312.x /= _346;
    _312.x = clamp(_312.x, 0.0f, 1.0f);
    _9.x *= _312.x;
    _312 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _312 = min(_312, vs_TEXCOORD1.xy);
    _312.x = min(_312.y, _312.x);
    _312.x = (_117 * 0.800000011920928955078125f) + _312.x;
    _346 = 1.0f / _20_m7;
    _312.x = _346 * _312.x;
    _312.x = clamp(_312.x, 0.0f, 1.0f);
    _346 = (_312.x * (-2.0f)) + 3.0f;
    _312.x *= _312.x;
    _312.x *= _346;
    _69.x = _9.x * _312.x;
    _301.w = _171 * _69.x;
    _301.w = clamp(_301.w, 0.0f, 1.0f);
    _449 = _301;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._449 = _449;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _305;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _305 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.x;
    _188 *= (-_188);
    vs_TEXCOORD3 = exp2(_188);
    float2 _227 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_227.x, _227.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _244 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_244.x, _244.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_305.x, _305.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _305 = stage_input._305;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _463;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _463 : SV_Target0;
};

static float3 _9;
static float _53;
static float2 _70;
static float3 _87;
static float3 _100;
static float3 _109;
static float3 _124;
static float2 _130;
static float _134;
static float _172;
static float _207;
static float3 _249;
static float _256;
static float3 _260;
static float4 _317;
static float _361;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _20_m3[1].xyz;
    _9 = (_20_m3[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_20_m3[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _20_m3[3].xyz;
    _53 = dot(_9, _9);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9).w;
    _70.x = _LightTextureB0.Sample(sampler_LightTextureB0, _53.xx).x;
    _9.x *= _70.x;
    _87 = _20_m2.xyz * _20_m4.xyz;
    _87 = _9.xxx * _87;
    _100 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _114 = _100.yz + (-0.5f).xx;
    _109 = float3(_114.x, _114.y, _109.z);
    float2 _121 = _109.xy + _109.xy;
    _109 = float3(_121.x, _121.y, _109.z);
    _124 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _130 = _124.yz + (-0.5f).xx;
    _134 = _124.x * 0.3499999940395355224609375f;
    _134 = (_100.x * 0.64999997615814208984375f) + _134;
    float2 _151 = (_130 * 0.89999997615814208984375f.xx) + _109.xy;
    _109 = float3(_151.x, _151.y, _109.z);
    float2 _166 = _109.xy * float2(float2(_20_m8, _20_m8));
    _109 = float3(_166.x, _109.y, _166.y);
    _109.y = 1.0f;
    _172 = dot(_109, _109);
    _172 = rsqrt(_172);
    _109 = _172.xxx * _109;
    _9 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _53 = dot(_9, _9);
    _53 = rsqrt(_53);
    _9 = _53.xxx * _9;
    _109.x = dot(_109, _9);
    _109.x = (_109.x * 0.5f) + 0.5f;
    _207 = _134 + (-_20_m6);
    _134 += (-0.5f);
    _134 *= _20_m7;
    _130.x = (-_20_m6) + 1.0f;
    _207 /= _130.x;
    _207 = clamp(_207, 0.0f, 1.0f);
    _130.x = (-_207) + 1.0f;
    _207 *= _20_m5;
    _53 = _207 * vs_TEXCOORD1.z;
    _249 = (-vs_TEXCOORD2) + _20_m0;
    _256 = dot(_249, _249);
    _260.x = rsqrt(_256);
    _260 = _249 * _260.xxx;
    _207 = dot(-_260, _9);
    _207 = clamp(_207, 0.0f, 1.0f);
    _172 = _207 * _207;
    _172 *= _172;
    _207 = _172 * _207;
    _207 = _130.x * _207;
    _207 *= _20_m10;
    _109.x = (_109.x * _20_m9) + _207;
    _87 *= _109.xxx;
    _9 = _87 * vs_TEXCOORD1.www;
    _249.x = vs_TEXCOORD3;
    _249.x = clamp(_249.x, 0.0f, 1.0f);
    float3 _321 = _9 * _249.xxx;
    _317 = float4(_321.x, _321.y, _321.z, _317.w);
    _9.x = _256 + 9.9999997473787516355514526367188e-06f;
    _70.x = sqrt(_256);
    _70.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_249.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _361 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _361;
    _361 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _70.x /= _361;
    _70.x = clamp(_70.x, 0.0f, 1.0f);
    _9.x *= _70.x;
    _70 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _70 = min(_70, vs_TEXCOORD1.xy);
    _70.x = min(_70.y, _70.x);
    _70.x = (_134 * 0.800000011920928955078125f) + _70.x;
    _361 = 1.0f / _20_m7;
    _70.x = _361 * _70.x;
    _70.x = clamp(_70.x, 0.0f, 1.0f);
    _361 = (_70.x * (-2.0f)) + 3.0f;
    _70.x *= _70.x;
    _70.x *= _361;
    _87.x = _9.x * _70.x;
    _317.w = _53 * _87.x;
    _317.w = clamp(_317.w, 0.0f, 1.0f);
    _463 = _317;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._463 = _463;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _305;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _305 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    _188 *= _17_m5.x;
    _188 *= (-_188);
    vs_TEXCOORD3 = exp2(_188);
    float2 _227 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_227.x, _227.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _244 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_244.x, _244.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_305.x, _305.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _305 = stage_input._305;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _499;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _499 : SV_Target0;
};

static float4 _9;
static float3 _49;
static float _66;
static bool _79;
static float3 _99;
static float3 _115;
static float3 _128;
static float3 _137;
static float3 _152;
static float2 _159;
static float _163;
static float _200;
static float _242;
static float _288;
static float3 _292;
static float4 _351;
static float2 _363;
static float _397;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyyy * _20_m3[1];
    _9 = (_20_m3[0] * vs_TEXCOORD2.xxxx) + _9;
    _9 = (_20_m3[2] * vs_TEXCOORD2.zzzz) + _9;
    _9 += _20_m3[3];
    float2 _55 = _9.xy / _9.ww;
    _49 = float3(_55.x, _55.y, _49.z);
    float2 _62 = _49.xy + 0.5f.xx;
    _49 = float3(_62.x, _62.y, _49.z);
    _66 = _LightTexture0.Sample(sampler_LightTexture0, _49.xy).w;
    _79 = 0.0f < _9.z;
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = _LightTextureB0.Sample(sampler_LightTextureB0, _9.xx).x;
    _99.x = float(_79);
    _99.x = _66 * _99.x;
    _99.x = _9.x * _99.x;
    _115 = _20_m2.xyz * _20_m4.xyz;
    _99 = _99.xxx * _115;
    _128 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _142 = _128.yz + (-0.5f).xx;
    _137 = float3(_142.x, _142.y, _137.z);
    float2 _149 = _137.xy + _137.xy;
    _137 = float3(_149.x, _149.y, _137.z);
    _152 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _159 = _152.yz + (-0.5f).xx;
    _163 = _152.x * 0.3499999940395355224609375f;
    _163 = (_128.x * 0.64999997615814208984375f) + _163;
    float2 _180 = (_159 * 0.89999997615814208984375f.xx) + _137.xy;
    _137 = float3(_180.x, _180.y, _137.z);
    float2 _195 = _137.xy * float2(float2(_20_m8, _20_m8));
    _137 = float3(_195.x, _137.y, _195.y);
    _137.y = 1.0f;
    _200 = dot(_137, _137);
    _200 = rsqrt(_200);
    _137 = _200.xxx * _137;
    float3 _215 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _9 = float4(_215.x, _215.y, _215.z, _9.w);
    _66 = dot(_9.xyz, _9.xyz);
    _66 = rsqrt(_66);
    float3 _229 = _66.xxx * _9.xyz;
    _9 = float4(_229.x, _229.y, _229.z, _9.w);
    _137.x = dot(_137, _9.xyz);
    _137.x = (_137.x * 0.5f) + 0.5f;
    _242 = _163 + (-_20_m6);
    _163 += (-0.5f);
    _163 *= _20_m7;
    _159.x = (-_20_m6) + 1.0f;
    _242 /= _159.x;
    _242 = clamp(_242, 0.0f, 1.0f);
    _159.x = (-_242) + 1.0f;
    _242 *= _20_m5;
    _66 = _242 * vs_TEXCOORD1.z;
    _49 = (-vs_TEXCOORD2) + _20_m0;
    _288 = dot(_49, _49);
    _292.x = rsqrt(_288);
    _292 = _49 * _292.xxx;
    _242 = dot(-_292, _9.xyz);
    _242 = clamp(_242, 0.0f, 1.0f);
    _200 = _242 * _242;
    _200 *= _200;
    _242 = _200 * _242;
    _242 = _159.x * _242;
    _242 *= _20_m10;
    _137.x = (_137.x * _20_m9) + _242;
    _99 *= _137.xxx;
    float3 _341 = _99 * vs_TEXCOORD1.www;
    _9 = float4(_341.x, _341.y, _341.z, _9.w);
    _49.x = vs_TEXCOORD3;
    _49.x = clamp(_49.x, 0.0f, 1.0f);
    float3 _356 = _9.xyz * _49.xxx;
    _351 = float4(_356.x, _356.y, _356.z, _351.w);
    _9.x = _288 + 9.9999997473787516355514526367188e-06f;
    _363.x = sqrt(_288);
    _363.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_49.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _397 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _397;
    _397 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _363.x /= _397;
    _363.x = clamp(_363.x, 0.0f, 1.0f);
    _9.x *= _363.x;
    _363 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _363 = min(_363, vs_TEXCOORD1.xy);
    _363.x = min(_363.y, _363.x);
    _363.x = (_163 * 0.800000011920928955078125f) + _363.x;
    _397 = 1.0f / _20_m7;
    _363.x = _397 * _363.x;
    _363.x = clamp(_363.x, 0.0f, 1.0f);
    _397 = (_363.x * (-2.0f)) + 3.0f;
    _363.x *= _363.x;
    _363.x *= _397;
    _99.x = _9.x * _363.x;
    _351.w = _66 * _99.x;
    _351.w = clamp(_351.w, 0.0f, 1.0f);
    _499 = _351;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._499 = _499;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    vs_TEXCOORD3 = (_188 * _17_m5.z) + _17_m5.w;
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _449;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _449 : SV_Target0;
};

static float3 _9;
static float3 _69;
static float3 _82;
static float3 _91;
static float3 _106;
static float2 _113;
static float _117;
static float _155;
static float _171;
static float _191;
static float3 _233;
static float _240;
static float3 _244;
static float4 _301;
static float2 _312;
static float _346;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _20_m3[1].xyz;
    _9 = (_20_m3[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_20_m3[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _20_m3[3].xyz;
    _9.x = dot(_9, _9);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9.xx).x;
    _69 = _20_m2.xyz * _20_m4.xyz;
    _69 = _9.xxx * _69;
    _82 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _96 = _82.yz + (-0.5f).xx;
    _91 = float3(_96.x, _96.y, _91.z);
    float2 _103 = _91.xy + _91.xy;
    _91 = float3(_103.x, _103.y, _91.z);
    _106 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _113 = _106.yz + (-0.5f).xx;
    _117 = _106.x * 0.3499999940395355224609375f;
    _117 = (_82.x * 0.64999997615814208984375f) + _117;
    float2 _134 = (_113 * 0.89999997615814208984375f.xx) + _91.xy;
    _91 = float3(_134.x, _134.y, _91.z);
    float2 _149 = _91.xy * float2(float2(_20_m8, _20_m8));
    _91 = float3(_149.x, _91.y, _149.y);
    _91.y = 1.0f;
    _155 = dot(_91, _91);
    _155 = rsqrt(_155);
    _91 = _155.xxx * _91;
    _9 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _171 = dot(_9, _9);
    _171 = rsqrt(_171);
    _9 = _171.xxx * _9;
    _91.x = dot(_91, _9);
    _91.x = (_91.x * 0.5f) + 0.5f;
    _191 = _117 + (-_20_m6);
    _117 += (-0.5f);
    _117 *= _20_m7;
    _113.x = (-_20_m6) + 1.0f;
    _191 /= _113.x;
    _191 = clamp(_191, 0.0f, 1.0f);
    _113.x = (-_191) + 1.0f;
    _191 *= _20_m5;
    _171 = _191 * vs_TEXCOORD1.z;
    _233 = (-vs_TEXCOORD2) + _20_m0;
    _240 = dot(_233, _233);
    _244.x = rsqrt(_240);
    _244 = _233 * _244.xxx;
    _191 = dot(-_244, _9);
    _191 = clamp(_191, 0.0f, 1.0f);
    _155 = _191 * _191;
    _155 *= _155;
    _191 = _155 * _191;
    _191 = _113.x * _191;
    _191 *= _20_m10;
    _91.x = (_91.x * _20_m9) + _191;
    _69 *= _91.xxx;
    _9 = _69 * vs_TEXCOORD1.www;
    _233.x = vs_TEXCOORD3;
    _233.x = clamp(_233.x, 0.0f, 1.0f);
    float3 _305 = _9 * _233.xxx;
    _301 = float4(_305.x, _305.y, _305.z, _301.w);
    _9.x = _240 + 9.9999997473787516355514526367188e-06f;
    _312.x = sqrt(_240);
    _312.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_233.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _346 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _346;
    _346 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _312.x /= _346;
    _312.x = clamp(_312.x, 0.0f, 1.0f);
    _9.x *= _312.x;
    _312 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _312 = min(_312, vs_TEXCOORD1.xy);
    _312.x = min(_312.y, _312.x);
    _312.x = (_117 * 0.800000011920928955078125f) + _312.x;
    _346 = 1.0f / _20_m7;
    _312.x = _346 * _312.x;
    _312.x = clamp(_312.x, 0.0f, 1.0f);
    _346 = (_312.x * (-2.0f)) + 3.0f;
    _312.x *= _312.x;
    _312.x *= _346;
    _69.x = _9.x * _312.x;
    _301.w = _171 * _69.x;
    _301.w = clamp(_301.w, 0.0f, 1.0f);
    _449 = _301;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._449 = _449;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    vs_TEXCOORD3 = (_188 * _17_m5.z) + _17_m5.w;
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _463;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _463 : SV_Target0;
};

static float3 _9;
static float _53;
static float2 _70;
static float3 _87;
static float3 _100;
static float3 _109;
static float3 _124;
static float2 _130;
static float _134;
static float _172;
static float _207;
static float3 _249;
static float _256;
static float3 _260;
static float4 _317;
static float _361;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _20_m3[1].xyz;
    _9 = (_20_m3[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_20_m3[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _20_m3[3].xyz;
    _53 = dot(_9, _9);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9).w;
    _70.x = _LightTextureB0.Sample(sampler_LightTextureB0, _53.xx).x;
    _9.x *= _70.x;
    _87 = _20_m2.xyz * _20_m4.xyz;
    _87 = _9.xxx * _87;
    _100 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _114 = _100.yz + (-0.5f).xx;
    _109 = float3(_114.x, _114.y, _109.z);
    float2 _121 = _109.xy + _109.xy;
    _109 = float3(_121.x, _121.y, _109.z);
    _124 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _130 = _124.yz + (-0.5f).xx;
    _134 = _124.x * 0.3499999940395355224609375f;
    _134 = (_100.x * 0.64999997615814208984375f) + _134;
    float2 _151 = (_130 * 0.89999997615814208984375f.xx) + _109.xy;
    _109 = float3(_151.x, _151.y, _109.z);
    float2 _166 = _109.xy * float2(float2(_20_m8, _20_m8));
    _109 = float3(_166.x, _109.y, _166.y);
    _109.y = 1.0f;
    _172 = dot(_109, _109);
    _172 = rsqrt(_172);
    _109 = _172.xxx * _109;
    _9 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _53 = dot(_9, _9);
    _53 = rsqrt(_53);
    _9 = _53.xxx * _9;
    _109.x = dot(_109, _9);
    _109.x = (_109.x * 0.5f) + 0.5f;
    _207 = _134 + (-_20_m6);
    _134 += (-0.5f);
    _134 *= _20_m7;
    _130.x = (-_20_m6) + 1.0f;
    _207 /= _130.x;
    _207 = clamp(_207, 0.0f, 1.0f);
    _130.x = (-_207) + 1.0f;
    _207 *= _20_m5;
    _53 = _207 * vs_TEXCOORD1.z;
    _249 = (-vs_TEXCOORD2) + _20_m0;
    _256 = dot(_249, _249);
    _260.x = rsqrt(_256);
    _260 = _249 * _260.xxx;
    _207 = dot(-_260, _9);
    _207 = clamp(_207, 0.0f, 1.0f);
    _172 = _207 * _207;
    _172 *= _172;
    _207 = _172 * _207;
    _207 = _130.x * _207;
    _207 *= _20_m10;
    _109.x = (_109.x * _20_m9) + _207;
    _87 *= _109.xxx;
    _9 = _87 * vs_TEXCOORD1.www;
    _249.x = vs_TEXCOORD3;
    _249.x = clamp(_249.x, 0.0f, 1.0f);
    float3 _321 = _9 * _249.xxx;
    _317 = float4(_321.x, _321.y, _321.z, _317.w);
    _9.x = _256 + 9.9999997473787516355514526367188e-06f;
    _70.x = sqrt(_256);
    _70.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_249.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _361 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _361;
    _361 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _70.x /= _361;
    _70.x = clamp(_70.x, 0.0f, 1.0f);
    _9.x *= _70.x;
    _70 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _70 = min(_70, vs_TEXCOORD1.xy);
    _70.x = min(_70.y, _70.x);
    _70.x = (_134 * 0.800000011920928955078125f) + _70.x;
    _361 = 1.0f / _20_m7;
    _70.x = _361 * _70.x;
    _70.x = clamp(_70.x, 0.0f, 1.0f);
    _361 = (_70.x * (-2.0f)) + 3.0f;
    _70.x *= _70.x;
    _70.x *= _361;
    _87.x = _9.x * _70.x;
    _317.w = _53 * _87.x;
    _317.w = clamp(_317.w, 0.0f, 1.0f);
    _463 = _317;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._463 = _463;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _17_m3[4];
float4x4 unity_MatrixVP;
static float4 _17_m4[4];
float4 unity_FogParams;
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m3[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m3[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m3[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m3[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _ProjectionParams
#define _17_m5 unity_FogParams
#define _17_m6 _TopThin
#define _17_m7 _EyeFade
#define _17_m8 _BottomShade
#define _17_m9 _Scale
#define _17_m10 _Undulate
#define _17_m11 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _44;
static float4 _94;
static float4 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _302;

struct SPIRV_Cross_Input
{
    float4 _44 : POSITION;
    float2 _302 : TEXCOORD0;
    float4 _94 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float3 _42;
static float2 _80;
static float _134;
static float _188;

void vert_inner()
{
    __unity_init();
    _9 = _17_m9.xxxx * _17_m11;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    _42 = _44.yyy * _17_m3[1].xyz;
    _42 = (_17_m3[0].xyz * _44.xxx) + _42;
    _42 = (_17_m3[2].xyz * _44.zzz) + _42;
    _42 = (_17_m3[3].xyz * _44.www) + _42;
    _80 = _42.xz * _17_m9.xx;
    _35 = (_80.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _80 = (_94.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _114 = (_94.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _114.x, _114.y);
    _80.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _80, 2.0f).x;
    _80.x += (-0.5f);
    _134 = _80.x + _80.x;
    _80.x = _134 * _17_m10;
    _80.x = (_80.x * _94.w) + _42.y;
    _35 = _80.xxxx * _17_m4[1];
    _35 = (_17_m4[0] * _42.xxxx) + _35;
    _35 = (_17_m4[2] * _42.zzzz) + _35;
    _35 += _17_m4[3];
    gl_Position = _35;
    _188 = _35.z / _17_m2.y;
    _188 = (-_188) + 1.0f;
    _188 *= _17_m2.z;
    _188 = max(_188, 0.0f);
    vs_TEXCOORD3 = (_188 * _17_m5.z) + _17_m5.w;
    float2 _224 = (_42.xz * _17_m9.xx) + _9.xy;
    _9 = float4(_224.x, _224.y, _9.z, _9.w);
    vs_TEXCOORD2 = float3(_42.xz.x, vs_TEXCOORD2.y, _42.xz.y);
    float2 _241 = (_94.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_241.x, _241.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _9.x = (-_80.x) + _17_m1.y;
    vs_TEXCOORD2.y = _80.x;
    _9.x = abs(_9.x) / _17_m7;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _134 = _17_m6 + (-1.0f);
    _134 = (_94.w * _134) + 1.0f;
    _134 = _9.x * _134;
    _134 = _9.x * _134;
    vs_TEXCOORD1.z = _134;
    _134 = (-_17_m8) + 1.0f;
    _134 = (_94.w * _134) + _17_m8;
    vs_TEXCOORD1.w = _134;
    vs_TEXCOORD1 = float4(_302.x, _302.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _44 = stage_input._44;
    _94 = stage_input._94;
    _302 = stage_input._302;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float vs_TEXCOORD3;
static float4 _499;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _499 : SV_Target0;
};

static float4 _9;
static float3 _49;
static float _66;
static bool _79;
static float3 _99;
static float3 _115;
static float3 _128;
static float3 _137;
static float3 _152;
static float2 _159;
static float _163;
static float _200;
static float _242;
static float _288;
static float3 _292;
static float4 _351;
static float2 _363;
static float _397;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyyy * _20_m3[1];
    _9 = (_20_m3[0] * vs_TEXCOORD2.xxxx) + _9;
    _9 = (_20_m3[2] * vs_TEXCOORD2.zzzz) + _9;
    _9 += _20_m3[3];
    float2 _55 = _9.xy / _9.ww;
    _49 = float3(_55.x, _55.y, _49.z);
    float2 _62 = _49.xy + 0.5f.xx;
    _49 = float3(_62.x, _62.y, _49.z);
    _66 = _LightTexture0.Sample(sampler_LightTexture0, _49.xy).w;
    _79 = 0.0f < _9.z;
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = _LightTextureB0.Sample(sampler_LightTextureB0, _9.xx).x;
    _99.x = float(_79);
    _99.x = _66 * _99.x;
    _99.x = _9.x * _99.x;
    _115 = _20_m2.xyz * _20_m4.xyz;
    _99 = _99.xxx * _115;
    _128 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _142 = _128.yz + (-0.5f).xx;
    _137 = float3(_142.x, _142.y, _137.z);
    float2 _149 = _137.xy + _137.xy;
    _137 = float3(_149.x, _149.y, _137.z);
    _152 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _159 = _152.yz + (-0.5f).xx;
    _163 = _152.x * 0.3499999940395355224609375f;
    _163 = (_128.x * 0.64999997615814208984375f) + _163;
    float2 _180 = (_159 * 0.89999997615814208984375f.xx) + _137.xy;
    _137 = float3(_180.x, _180.y, _137.z);
    float2 _195 = _137.xy * float2(float2(_20_m8, _20_m8));
    _137 = float3(_195.x, _137.y, _195.y);
    _137.y = 1.0f;
    _200 = dot(_137, _137);
    _200 = rsqrt(_200);
    _137 = _200.xxx * _137;
    float3 _215 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _9 = float4(_215.x, _215.y, _215.z, _9.w);
    _66 = dot(_9.xyz, _9.xyz);
    _66 = rsqrt(_66);
    float3 _229 = _66.xxx * _9.xyz;
    _9 = float4(_229.x, _229.y, _229.z, _9.w);
    _137.x = dot(_137, _9.xyz);
    _137.x = (_137.x * 0.5f) + 0.5f;
    _242 = _163 + (-_20_m6);
    _163 += (-0.5f);
    _163 *= _20_m7;
    _159.x = (-_20_m6) + 1.0f;
    _242 /= _159.x;
    _242 = clamp(_242, 0.0f, 1.0f);
    _159.x = (-_242) + 1.0f;
    _242 *= _20_m5;
    _66 = _242 * vs_TEXCOORD1.z;
    _49 = (-vs_TEXCOORD2) + _20_m0;
    _288 = dot(_49, _49);
    _292.x = rsqrt(_288);
    _292 = _49 * _292.xxx;
    _242 = dot(-_292, _9.xyz);
    _242 = clamp(_242, 0.0f, 1.0f);
    _200 = _242 * _242;
    _200 *= _200;
    _242 = _200 * _242;
    _242 = _159.x * _242;
    _242 *= _20_m10;
    _137.x = (_137.x * _20_m9) + _242;
    _99 *= _137.xxx;
    float3 _341 = _99 * vs_TEXCOORD1.www;
    _9 = float4(_341.x, _341.y, _341.z, _9.w);
    _49.x = vs_TEXCOORD3;
    _49.x = clamp(_49.x, 0.0f, 1.0f);
    float3 _356 = _9.xyz * _49.xxx;
    _351 = float4(_356.x, _356.y, _356.z, _351.w);
    _9.x = _288 + 9.9999997473787516355514526367188e-06f;
    _363.x = sqrt(_288);
    _363.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_49.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _397 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _397;
    _397 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _363.x /= _397;
    _363.x = clamp(_363.x, 0.0f, 1.0f);
    _9.x *= _363.x;
    _363 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _363 = min(_363, vs_TEXCOORD1.xy);
    _363.x = min(_363.y, _363.x);
    _363.x = (_163 * 0.800000011920928955078125f) + _363.x;
    _397 = 1.0f / _20_m7;
    _363.x = _397 * _363.x;
    _363.x = clamp(_363.x, 0.0f, 1.0f);
    _397 = (_363.x * (-2.0f)) + 3.0f;
    _363.x *= _363.x;
    _363.x *= _397;
    _99.x = _9.x * _363.x;
    _351.w = _66 * _99.x;
    _351.w = clamp(_351.w, 0.0f, 1.0f);
    _499 = _351;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._499 = _499;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _17_m2[4];
float4x4 unity_MatrixVP;
static float4 _17_m3[4];
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m4 _TopThin
#define _17_m5 _EyeFade
#define _17_m6 _BottomShade
#define _17_m7 _Scale
#define _17_m8 _Undulate
#define _17_m9 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _43;
static float4 _104;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _281;

struct SPIRV_Cross_Input
{
    float4 _43 : POSITION;
    float2 _281 : TEXCOORD0;
    float4 _104 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float4 _41;
static float2 _90;
static float _144;

void vert_inner()
{
    __unity_init();
    _9 = _17_m7.xxxx * _17_m9;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    float3 _51 = _43.yyy * _17_m2[1].xyz;
    _41 = float4(_51.x, _51.y, _51.z, _41.w);
    float3 _62 = (_17_m2[0].xyz * _43.xxx) + _41.xyz;
    _41 = float4(_62.x, _62.y, _62.z, _41.w);
    float3 _73 = (_17_m2[2].xyz * _43.zzz) + _41.xyz;
    _41 = float4(_73.x, _73.y, _73.z, _41.w);
    float3 _85 = (_17_m2[3].xyz * _43.www) + _41.xyz;
    _41 = float4(_85.x, _85.y, _85.z, _41.w);
    _90 = _41.xz * _17_m7.xx;
    _35 = (_90.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _90 = (_104.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _124 = (_104.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _124.x, _124.y);
    _90.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _90, 2.0f).x;
    _90.x += (-0.5f);
    _144 = _90.x + _90.x;
    _90.x = _144 * _17_m8;
    _41.w = (_90.x * _104.w) + _41.y;
    _35 = _41.wwww * _17_m3[1];
    _35 = (_17_m3[0] * _41.xxxx) + _35;
    _35 = (_17_m3[2] * _41.zzzz) + _35;
    gl_Position = _35 + _17_m3[3];
    float2 _204 = (_41.xz * _17_m7.xx) + _9.xy;
    _9 = float4(_204.x, _204.y, _9.z, _9.w);
    vs_TEXCOORD2 = _41.xwz;
    _90.x = (-_41.w) + _17_m1.y;
    _90.x = abs(_90.x) / _17_m5;
    _90.x = clamp(_90.x, 0.0f, 1.0f);
    float2 _240 = (_104.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_240.x, _240.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _144 = _17_m4 + (-1.0f);
    _144 = (_104.w * _144) + 1.0f;
    _144 = _90.x * _144;
    _144 = _90.x * _144;
    vs_TEXCOORD1.z = _144;
    _144 = (-_17_m6) + 1.0f;
    _144 = (_104.w * _144) + _17_m6;
    vs_TEXCOORD1.w = _144;
    vs_TEXCOORD1 = float4(_281.x, _281.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _43 = stage_input._43;
    _104 = stage_input._104;
    _281 = stage_input._281;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _21_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _21_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _21_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _21_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _21_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _21_m0 _WorldSpaceCameraPos
#define _21_m1 _WorldSpaceLightPos0
#define _21_m2 _LightColor0
#define _21_m4 _Color
#define _21_m5 _Density
#define _21_m6 _Cutoff
#define _21_m7 _EdgeFade
#define _21_m8 _Relief
#define _21_m9 _DirectStrength
#define _21_m10 _Scatter
#define _21_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 _448;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _448 : SV_Target0;
};

static float3 _9;
static float3 _77;
static float3 _90;
static float3 _99;
static float3 _114;
static float2 _121;
static float _125;
static float _163;
static float _201;
static float _236;
static float3 _244;
static float _251;
static float3 _255;
static float4 _301;
static float2 _312;
static float _346;

void frag_inner()
{
    __unity_init();
    float2 _29 = vs_TEXCOORD2.yy * _21_m3[1].xy;
    _9 = float3(_29.x, _29.y, _9.z);
    float2 _41 = (_21_m3[0].xy * vs_TEXCOORD2.xx) + _9.xy;
    _9 = float3(_41.x, _41.y, _9.z);
    float2 _53 = (_21_m3[2].xy * vs_TEXCOORD2.zz) + _9.xy;
    _9 = float3(_53.x, _53.y, _9.z);
    float2 _61 = _9.xy + _21_m3[3].xy;
    _9 = float3(_61.x, _61.y, _9.z);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9.xy).w;
    _77 = _21_m2.xyz * _21_m4.xyz;
    _77 = _9.xxx * _77;
    _90 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _104 = _90.yz + (-0.5f).xx;
    _99 = float3(_104.x, _104.y, _99.z);
    float2 _111 = _99.xy + _99.xy;
    _99 = float3(_111.x, _111.y, _99.z);
    _114 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _121 = _114.yz + (-0.5f).xx;
    _125 = _114.x * 0.3499999940395355224609375f;
    _125 = (_90.x * 0.64999997615814208984375f) + _125;
    float2 _142 = (_121 * 0.89999997615814208984375f.xx) + _99.xy;
    _99 = float3(_142.x, _142.y, _99.z);
    float2 _157 = _99.xy * float2(float2(_21_m8, _21_m8));
    _99 = float3(_157.x, _99.y, _157.y);
    _99.y = 1.0f;
    _163 = dot(_99, _99);
    _163 = rsqrt(_163);
    _99 = _163.xxx * _99;
    _9.x = dot(_21_m1.xyz, _21_m1.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _21_m1.xyz;
    _99.x = dot(_99, _9);
    _99.x = (_99.x * 0.5f) + 0.5f;
    _201 = _125 + (-_21_m6);
    _125 += (-0.5f);
    _125 *= _21_m7;
    _121.x = (-_21_m6) + 1.0f;
    _201 /= _121.x;
    _201 = clamp(_201, 0.0f, 1.0f);
    _121.x = (-_201) + 1.0f;
    _201 *= _21_m5;
    _236 = _201 * vs_TEXCOORD1.z;
    _244 = (-vs_TEXCOORD2) + _21_m0;
    _251 = dot(_244, _244);
    _255.x = rsqrt(_251);
    _255 = _244 * _255.xxx;
    _201 = dot(-_255, _9);
    _201 = clamp(_201, 0.0f, 1.0f);
    _163 = _201 * _201;
    _163 *= _163;
    _201 = _163 * _201;
    _201 = _121.x * _201;
    _201 *= _21_m10;
    _99.x = (_99.x * _21_m9) + _201;
    _77 *= _99.xxx;
    float3 _305 = _77 * vs_TEXCOORD1.www;
    _301 = float4(_305.x, _305.y, _305.z, _301.w);
    _9.x = _251 + 9.9999997473787516355514526367188e-06f;
    _312.x = sqrt(_251);
    _312.x += (-_21_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_244.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _346 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _346;
    _346 = max(_21_m11.y, 0.00999999977648258209228515625f);
    _312.x /= _346;
    _312.x = clamp(_312.x, 0.0f, 1.0f);
    _9.x *= _312.x;
    _312 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _312 = min(_312, vs_TEXCOORD1.xy);
    _312.x = min(_312.y, _312.x);
    _312.x = (_125 * 0.800000011920928955078125f) + _312.x;
    _346 = 1.0f / _21_m7;
    _312.x = _346 * _312.x;
    _312.x = clamp(_312.x, 0.0f, 1.0f);
    _346 = (_312.x * (-2.0f)) + 3.0f;
    _312.x *= _312.x;
    _312.x *= _346;
    _77.x = _9.x * _312.x;
    _301.w = _236 * _77.x;
    _301.w = clamp(_301.w, 0.0f, 1.0f);
    _448 = _301;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._448 = _448;
    return stage_output;
}

#endif
#elif defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _17_m2[4];
float4x4 unity_MatrixVP;
static float4 _17_m3[4];
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m4 _TopThin
#define _17_m5 _EyeFade
#define _17_m6 _BottomShade
#define _17_m7 _Scale
#define _17_m8 _Undulate
#define _17_m9 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _43;
static float4 _104;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _281;

struct SPIRV_Cross_Input
{
    float4 _43 : POSITION;
    float2 _281 : TEXCOORD0;
    float4 _104 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float4 _41;
static float2 _90;
static float _144;

void vert_inner()
{
    __unity_init();
    _9 = _17_m7.xxxx * _17_m9;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    float3 _51 = _43.yyy * _17_m2[1].xyz;
    _41 = float4(_51.x, _51.y, _51.z, _41.w);
    float3 _62 = (_17_m2[0].xyz * _43.xxx) + _41.xyz;
    _41 = float4(_62.x, _62.y, _62.z, _41.w);
    float3 _73 = (_17_m2[2].xyz * _43.zzz) + _41.xyz;
    _41 = float4(_73.x, _73.y, _73.z, _41.w);
    float3 _85 = (_17_m2[3].xyz * _43.www) + _41.xyz;
    _41 = float4(_85.x, _85.y, _85.z, _41.w);
    _90 = _41.xz * _17_m7.xx;
    _35 = (_90.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _90 = (_104.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _124 = (_104.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _124.x, _124.y);
    _90.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _90, 2.0f).x;
    _90.x += (-0.5f);
    _144 = _90.x + _90.x;
    _90.x = _144 * _17_m8;
    _41.w = (_90.x * _104.w) + _41.y;
    _35 = _41.wwww * _17_m3[1];
    _35 = (_17_m3[0] * _41.xxxx) + _35;
    _35 = (_17_m3[2] * _41.zzzz) + _35;
    gl_Position = _35 + _17_m3[3];
    float2 _204 = (_41.xz * _17_m7.xx) + _9.xy;
    _9 = float4(_204.x, _204.y, _9.z, _9.w);
    vs_TEXCOORD2 = _41.xwz;
    _90.x = (-_41.w) + _17_m1.y;
    _90.x = abs(_90.x) / _17_m5;
    _90.x = clamp(_90.x, 0.0f, 1.0f);
    float2 _240 = (_104.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_240.x, _240.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _144 = _17_m4 + (-1.0f);
    _144 = (_104.w * _144) + 1.0f;
    _144 = _90.x * _144;
    _144 = _90.x * _144;
    vs_TEXCOORD1.z = _144;
    _144 = (-_17_m6) + 1.0f;
    _144 = (_104.w * _144) + _17_m6;
    vs_TEXCOORD1.w = _144;
    vs_TEXCOORD1 = float4(_281.x, _281.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _43 = stage_input._43;
    _104 = stage_input._104;
    _281 = stage_input._281;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 _438;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _438 : SV_Target0;
};

static float3 _9;
static float3 _69;
static float3 _82;
static float3 _91;
static float3 _106;
static float2 _113;
static float _117;
static float _155;
static float _171;
static float _191;
static float3 _233;
static float _240;
static float3 _244;
static float4 _290;
static float2 _301;
static float _335;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _20_m3[1].xyz;
    _9 = (_20_m3[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_20_m3[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _20_m3[3].xyz;
    _9.x = dot(_9, _9);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9.xx).x;
    _69 = _20_m2.xyz * _20_m4.xyz;
    _69 = _9.xxx * _69;
    _82 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _96 = _82.yz + (-0.5f).xx;
    _91 = float3(_96.x, _96.y, _91.z);
    float2 _103 = _91.xy + _91.xy;
    _91 = float3(_103.x, _103.y, _91.z);
    _106 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _113 = _106.yz + (-0.5f).xx;
    _117 = _106.x * 0.3499999940395355224609375f;
    _117 = (_82.x * 0.64999997615814208984375f) + _117;
    float2 _134 = (_113 * 0.89999997615814208984375f.xx) + _91.xy;
    _91 = float3(_134.x, _134.y, _91.z);
    float2 _149 = _91.xy * float2(float2(_20_m8, _20_m8));
    _91 = float3(_149.x, _91.y, _149.y);
    _91.y = 1.0f;
    _155 = dot(_91, _91);
    _155 = rsqrt(_155);
    _91 = _155.xxx * _91;
    _9 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _171 = dot(_9, _9);
    _171 = rsqrt(_171);
    _9 = _171.xxx * _9;
    _91.x = dot(_91, _9);
    _91.x = (_91.x * 0.5f) + 0.5f;
    _191 = _117 + (-_20_m6);
    _117 += (-0.5f);
    _117 *= _20_m7;
    _113.x = (-_20_m6) + 1.0f;
    _191 /= _113.x;
    _191 = clamp(_191, 0.0f, 1.0f);
    _113.x = (-_191) + 1.0f;
    _191 *= _20_m5;
    _171 = _191 * vs_TEXCOORD1.z;
    _233 = (-vs_TEXCOORD2) + _20_m0;
    _240 = dot(_233, _233);
    _244.x = rsqrt(_240);
    _244 = _233 * _244.xxx;
    _191 = dot(-_244, _9);
    _191 = clamp(_191, 0.0f, 1.0f);
    _155 = _191 * _191;
    _155 *= _155;
    _191 = _155 * _191;
    _191 = _113.x * _191;
    _191 *= _20_m10;
    _91.x = (_91.x * _20_m9) + _191;
    _69 *= _91.xxx;
    float3 _294 = _69 * vs_TEXCOORD1.www;
    _290 = float4(_294.x, _294.y, _294.z, _290.w);
    _9.x = _240 + 9.9999997473787516355514526367188e-06f;
    _301.x = sqrt(_240);
    _301.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_233.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _335 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _335;
    _335 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _301.x /= _335;
    _301.x = clamp(_301.x, 0.0f, 1.0f);
    _9.x *= _301.x;
    _301 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _301 = min(_301, vs_TEXCOORD1.xy);
    _301.x = min(_301.y, _301.x);
    _301.x = (_117 * 0.800000011920928955078125f) + _301.x;
    _335 = 1.0f / _20_m7;
    _301.x = _335 * _301.x;
    _301.x = clamp(_301.x, 0.0f, 1.0f);
    _335 = (_301.x * (-2.0f)) + 3.0f;
    _301.x *= _301.x;
    _301.x *= _335;
    _69.x = _9.x * _301.x;
    _290.w = _171 * _69.x;
    _290.w = clamp(_290.w, 0.0f, 1.0f);
    _438 = _290;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._438 = _438;
    return stage_output;
}

#endif
#elif defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _17_m2[4];
float4x4 unity_MatrixVP;
static float4 _17_m3[4];
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m4 _TopThin
#define _17_m5 _EyeFade
#define _17_m6 _BottomShade
#define _17_m7 _Scale
#define _17_m8 _Undulate
#define _17_m9 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _43;
static float4 _104;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _281;

struct SPIRV_Cross_Input
{
    float4 _43 : POSITION;
    float2 _281 : TEXCOORD0;
    float4 _104 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float4 _41;
static float2 _90;
static float _144;

void vert_inner()
{
    __unity_init();
    _9 = _17_m7.xxxx * _17_m9;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    float3 _51 = _43.yyy * _17_m2[1].xyz;
    _41 = float4(_51.x, _51.y, _51.z, _41.w);
    float3 _62 = (_17_m2[0].xyz * _43.xxx) + _41.xyz;
    _41 = float4(_62.x, _62.y, _62.z, _41.w);
    float3 _73 = (_17_m2[2].xyz * _43.zzz) + _41.xyz;
    _41 = float4(_73.x, _73.y, _73.z, _41.w);
    float3 _85 = (_17_m2[3].xyz * _43.www) + _41.xyz;
    _41 = float4(_85.x, _85.y, _85.z, _41.w);
    _90 = _41.xz * _17_m7.xx;
    _35 = (_90.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _90 = (_104.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _124 = (_104.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _124.x, _124.y);
    _90.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _90, 2.0f).x;
    _90.x += (-0.5f);
    _144 = _90.x + _90.x;
    _90.x = _144 * _17_m8;
    _41.w = (_90.x * _104.w) + _41.y;
    _35 = _41.wwww * _17_m3[1];
    _35 = (_17_m3[0] * _41.xxxx) + _35;
    _35 = (_17_m3[2] * _41.zzzz) + _35;
    gl_Position = _35 + _17_m3[3];
    float2 _204 = (_41.xz * _17_m7.xx) + _9.xy;
    _9 = float4(_204.x, _204.y, _9.z, _9.w);
    vs_TEXCOORD2 = _41.xwz;
    _90.x = (-_41.w) + _17_m1.y;
    _90.x = abs(_90.x) / _17_m5;
    _90.x = clamp(_90.x, 0.0f, 1.0f);
    float2 _240 = (_104.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_240.x, _240.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _144 = _17_m4 + (-1.0f);
    _144 = (_104.w * _144) + 1.0f;
    _144 = _90.x * _144;
    _144 = _90.x * _144;
    vs_TEXCOORD1.z = _144;
    _144 = (-_17_m6) + 1.0f;
    _144 = (_104.w * _144) + _17_m6;
    vs_TEXCOORD1.w = _144;
    vs_TEXCOORD1 = float4(_281.x, _281.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _43 = stage_input._43;
    _104 = stage_input._104;
    _281 = stage_input._281;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 _452;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _452 : SV_Target0;
};

static float3 _9;
static float _53;
static float2 _70;
static float3 _87;
static float3 _100;
static float3 _109;
static float3 _124;
static float2 _130;
static float _134;
static float _172;
static float _207;
static float3 _249;
static float _256;
static float3 _260;
static float4 _306;
static float _350;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyy * _20_m3[1].xyz;
    _9 = (_20_m3[0].xyz * vs_TEXCOORD2.xxx) + _9;
    _9 = (_20_m3[2].xyz * vs_TEXCOORD2.zzz) + _9;
    _9 += _20_m3[3].xyz;
    _53 = dot(_9, _9);
    _9.x = _LightTexture0.Sample(sampler_LightTexture0, _9).w;
    _70.x = _LightTextureB0.Sample(sampler_LightTextureB0, _53.xx).x;
    _9.x *= _70.x;
    _87 = _20_m2.xyz * _20_m4.xyz;
    _87 = _9.xxx * _87;
    _100 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _114 = _100.yz + (-0.5f).xx;
    _109 = float3(_114.x, _114.y, _109.z);
    float2 _121 = _109.xy + _109.xy;
    _109 = float3(_121.x, _121.y, _109.z);
    _124 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _130 = _124.yz + (-0.5f).xx;
    _134 = _124.x * 0.3499999940395355224609375f;
    _134 = (_100.x * 0.64999997615814208984375f) + _134;
    float2 _151 = (_130 * 0.89999997615814208984375f.xx) + _109.xy;
    _109 = float3(_151.x, _151.y, _109.z);
    float2 _166 = _109.xy * float2(float2(_20_m8, _20_m8));
    _109 = float3(_166.x, _109.y, _166.y);
    _109.y = 1.0f;
    _172 = dot(_109, _109);
    _172 = rsqrt(_172);
    _109 = _172.xxx * _109;
    _9 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _53 = dot(_9, _9);
    _53 = rsqrt(_53);
    _9 = _53.xxx * _9;
    _109.x = dot(_109, _9);
    _109.x = (_109.x * 0.5f) + 0.5f;
    _207 = _134 + (-_20_m6);
    _134 += (-0.5f);
    _134 *= _20_m7;
    _130.x = (-_20_m6) + 1.0f;
    _207 /= _130.x;
    _207 = clamp(_207, 0.0f, 1.0f);
    _130.x = (-_207) + 1.0f;
    _207 *= _20_m5;
    _53 = _207 * vs_TEXCOORD1.z;
    _249 = (-vs_TEXCOORD2) + _20_m0;
    _256 = dot(_249, _249);
    _260.x = rsqrt(_256);
    _260 = _249 * _260.xxx;
    _207 = dot(-_260, _9);
    _207 = clamp(_207, 0.0f, 1.0f);
    _172 = _207 * _207;
    _172 *= _172;
    _207 = _172 * _207;
    _207 = _130.x * _207;
    _207 *= _20_m10;
    _109.x = (_109.x * _20_m9) + _207;
    _87 *= _109.xxx;
    float3 _310 = _87 * vs_TEXCOORD1.www;
    _306 = float4(_310.x, _310.y, _310.z, _306.w);
    _9.x = _256 + 9.9999997473787516355514526367188e-06f;
    _70.x = sqrt(_256);
    _70.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_249.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _350 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _350;
    _350 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _70.x /= _350;
    _70.x = clamp(_70.x, 0.0f, 1.0f);
    _9.x *= _70.x;
    _70 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _70 = min(_70, vs_TEXCOORD1.xy);
    _70.x = min(_70.y, _70.x);
    _70.x = (_134 * 0.800000011920928955078125f) + _70.x;
    _350 = 1.0f / _20_m7;
    _70.x = _350 * _70.x;
    _70.x = clamp(_70.x, 0.0f, 1.0f);
    _350 = (_70.x * (-2.0f)) + 3.0f;
    _70.x *= _70.x;
    _70.x *= _350;
    _87.x = _9.x * _70.x;
    _306.w = _53 * _87.x;
    _306.w = clamp(_306.w, 0.0f, 1.0f);
    _452 = _306;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._452 = _452;
    return stage_output;
}

#endif
#elif defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _17_m2[4];
float4x4 unity_MatrixVP;
static float4 _17_m3[4];
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m4 _TopThin
#define _17_m5 _EyeFade
#define _17_m6 _BottomShade
#define _17_m7 _Scale
#define _17_m8 _Undulate
#define _17_m9 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _43;
static float4 _104;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _281;

struct SPIRV_Cross_Input
{
    float4 _43 : POSITION;
    float2 _281 : TEXCOORD0;
    float4 _104 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float4 _41;
static float2 _90;
static float _144;

void vert_inner()
{
    __unity_init();
    _9 = _17_m7.xxxx * _17_m9;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    float3 _51 = _43.yyy * _17_m2[1].xyz;
    _41 = float4(_51.x, _51.y, _51.z, _41.w);
    float3 _62 = (_17_m2[0].xyz * _43.xxx) + _41.xyz;
    _41 = float4(_62.x, _62.y, _62.z, _41.w);
    float3 _73 = (_17_m2[2].xyz * _43.zzz) + _41.xyz;
    _41 = float4(_73.x, _73.y, _73.z, _41.w);
    float3 _85 = (_17_m2[3].xyz * _43.www) + _41.xyz;
    _41 = float4(_85.x, _85.y, _85.z, _41.w);
    _90 = _41.xz * _17_m7.xx;
    _35 = (_90.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _90 = (_104.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _124 = (_104.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _124.x, _124.y);
    _90.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _90, 2.0f).x;
    _90.x += (-0.5f);
    _144 = _90.x + _90.x;
    _90.x = _144 * _17_m8;
    _41.w = (_90.x * _104.w) + _41.y;
    _35 = _41.wwww * _17_m3[1];
    _35 = (_17_m3[0] * _41.xxxx) + _35;
    _35 = (_17_m3[2] * _41.zzzz) + _35;
    gl_Position = _35 + _17_m3[3];
    float2 _204 = (_41.xz * _17_m7.xx) + _9.xy;
    _9 = float4(_204.x, _204.y, _9.z, _9.w);
    vs_TEXCOORD2 = _41.xwz;
    _90.x = (-_41.w) + _17_m1.y;
    _90.x = abs(_90.x) / _17_m5;
    _90.x = clamp(_90.x, 0.0f, 1.0f);
    float2 _240 = (_104.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_240.x, _240.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _144 = _17_m4 + (-1.0f);
    _144 = (_104.w * _144) + 1.0f;
    _144 = _90.x * _144;
    _144 = _90.x * _144;
    vs_TEXCOORD1.z = _144;
    _144 = (-_17_m6) + 1.0f;
    _144 = (_104.w * _144) + _17_m6;
    vs_TEXCOORD1.w = _144;
    vs_TEXCOORD1 = float4(_281.x, _281.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _43 = stage_input._43;
    _104 = stage_input._104;
    _281 = stage_input._281;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4x4 unity_WorldToLight;
static float4 _20_m3[4];
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
void __unity_init()
{
    _20_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _20_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _20_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _20_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _20_m0 _WorldSpaceCameraPos
#define _20_m1 _WorldSpaceLightPos0
#define _20_m2 _LightColor0
#define _20_m4 _Color
#define _20_m5 _Density
#define _20_m6 _Cutoff
#define _20_m7 _EdgeFade
#define _20_m8 _Relief
#define _20_m9 _DirectStrength
#define _20_m10 _Scatter
#define _20_m11 _NearFade


Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD0;
static float4 vs_TEXCOORD1;
static float4 _485;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _485 : SV_Target0;
};

static float4 _9;
static float3 _49;
static float _66;
static bool _79;
static float3 _99;
static float3 _115;
static float3 _128;
static float3 _137;
static float3 _152;
static float2 _159;
static float _163;
static float _200;
static float _242;
static float _288;
static float3 _292;
static float4 _338;
static float2 _349;
static float _383;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD2.yyyy * _20_m3[1];
    _9 = (_20_m3[0] * vs_TEXCOORD2.xxxx) + _9;
    _9 = (_20_m3[2] * vs_TEXCOORD2.zzzz) + _9;
    _9 += _20_m3[3];
    float2 _55 = _9.xy / _9.ww;
    _49 = float3(_55.x, _55.y, _49.z);
    float2 _62 = _49.xy + 0.5f.xx;
    _49 = float3(_62.x, _62.y, _49.z);
    _66 = _LightTexture0.Sample(sampler_LightTexture0, _49.xy).w;
    _79 = 0.0f < _9.z;
    _9.x = dot(_9.xyz, _9.xyz);
    _9.x = _LightTextureB0.Sample(sampler_LightTextureB0, _9.xx).x;
    _99.x = float(_79);
    _99.x = _66 * _99.x;
    _99.x = _9.x * _99.x;
    _115 = _20_m2.xyz * _20_m4.xyz;
    _99 = _99.xxx * _115;
    _128 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    float2 _142 = _128.yz + (-0.5f).xx;
    _137 = float3(_142.x, _142.y, _137.z);
    float2 _149 = _137.xy + _137.xy;
    _137 = float3(_149.x, _149.y, _137.z);
    _152 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _159 = _152.yz + (-0.5f).xx;
    _163 = _152.x * 0.3499999940395355224609375f;
    _163 = (_128.x * 0.64999997615814208984375f) + _163;
    float2 _180 = (_159 * 0.89999997615814208984375f.xx) + _137.xy;
    _137 = float3(_180.x, _180.y, _137.z);
    float2 _195 = _137.xy * float2(float2(_20_m8, _20_m8));
    _137 = float3(_195.x, _137.y, _195.y);
    _137.y = 1.0f;
    _200 = dot(_137, _137);
    _200 = rsqrt(_200);
    _137 = _200.xxx * _137;
    float3 _215 = (-vs_TEXCOORD2) + _20_m1.xyz;
    _9 = float4(_215.x, _215.y, _215.z, _9.w);
    _66 = dot(_9.xyz, _9.xyz);
    _66 = rsqrt(_66);
    float3 _229 = _66.xxx * _9.xyz;
    _9 = float4(_229.x, _229.y, _229.z, _9.w);
    _137.x = dot(_137, _9.xyz);
    _137.x = (_137.x * 0.5f) + 0.5f;
    _242 = _163 + (-_20_m6);
    _163 += (-0.5f);
    _163 *= _20_m7;
    _159.x = (-_20_m6) + 1.0f;
    _242 /= _159.x;
    _242 = clamp(_242, 0.0f, 1.0f);
    _159.x = (-_242) + 1.0f;
    _242 *= _20_m5;
    _66 = _242 * vs_TEXCOORD1.z;
    _49 = (-vs_TEXCOORD2) + _20_m0;
    _288 = dot(_49, _49);
    _292.x = rsqrt(_288);
    _292 = _49 * _292.xxx;
    _242 = dot(-_292, _9.xyz);
    _242 = clamp(_242, 0.0f, 1.0f);
    _200 = _242 * _242;
    _200 *= _200;
    _242 = _200 * _242;
    _242 = _159.x * _242;
    _242 *= _20_m10;
    _137.x = (_137.x * _20_m9) + _242;
    _99 *= _137.xxx;
    float3 _342 = _99 * vs_TEXCOORD1.www;
    _338 = float4(_342.x, _342.y, _342.z, _338.w);
    _9.x = _288 + 9.9999997473787516355514526367188e-06f;
    _349.x = sqrt(_288);
    _349.x += (-_20_m11.x);
    _9.x = rsqrt(_9.x);
    _9.x = (abs(_49.y) * _9.x) + (-0.0040000001899898052215576171875f);
    _9.x *= 21.7391300201416015625f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _383 = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _383;
    _383 = max(_20_m11.y, 0.00999999977648258209228515625f);
    _349.x /= _383;
    _349.x = clamp(_349.x, 0.0f, 1.0f);
    _9.x *= _349.x;
    _349 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _349 = min(_349, vs_TEXCOORD1.xy);
    _349.x = min(_349.y, _349.x);
    _349.x = (_163 * 0.800000011920928955078125f) + _349.x;
    _383 = 1.0f / _20_m7;
    _349.x = _383 * _349.x;
    _349.x = clamp(_349.x, 0.0f, 1.0f);
    _383 = (_349.x * (-2.0f)) + 3.0f;
    _349.x *= _349.x;
    _349.x *= _383;
    _99.x = _9.x * _349.x;
    _338.w = _66 * _99.x;
    _338.w = clamp(_338.w, 0.0f, 1.0f);
    _485 = _338;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._485 = _485;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4x4 unity_ObjectToWorld;
static float4 _17_m2[4];
float4x4 unity_MatrixVP;
static float4 _17_m3[4];
float _TopThin;
float _EyeFade;
float _BottomShade;
float _Scale;
float _Undulate;
float4 _Wind;
void __unity_init()
{
    _17_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _17_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _17_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _17_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _17_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _17_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _17_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _17_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m4 _TopThin
#define _17_m5 _EyeFade
#define _17_m6 _BottomShade
#define _17_m7 _Scale
#define _17_m8 _Undulate
#define _17_m9 _Wind


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float4 gl_Position;
static float4 _43;
static float4 _104;
static float4 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float2 _281;

struct SPIRV_Cross_Input
{
    float4 _43 : POSITION;
    float2 _281 : TEXCOORD0;
    float4 _104 : COLOR;
};

struct SPIRV_Cross_Output
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _35;
static float4 _41;
static float2 _90;
static float _144;

void vert_inner()
{
    __unity_init();
    _9 = _17_m7.xxxx * _17_m9;
    _9 *= _17_m0.yyyy;
    _35 = _9 * float4(0.5f, 0.5f, 2.2999999523162841796875f, 2.2999999523162841796875f);
    float3 _51 = _43.yyy * _17_m2[1].xyz;
    _41 = float4(_51.x, _51.y, _51.z, _41.w);
    float3 _62 = (_17_m2[0].xyz * _43.xxx) + _41.xyz;
    _41 = float4(_62.x, _62.y, _62.z, _41.w);
    float3 _73 = (_17_m2[2].xyz * _43.zzz) + _41.xyz;
    _41 = float4(_73.x, _73.y, _73.z, _41.w);
    float3 _85 = (_17_m2[3].xyz * _43.www) + _41.xyz;
    _41 = float4(_85.x, _85.y, _85.z, _41.w);
    _90 = _41.xz * _17_m7.xx;
    _35 = (_90.xyxy * float4(0.3499999940395355224609375f, 0.3499999940395355224609375f, 2.2999999523162841796875f, 2.2999999523162841796875f)) + _35;
    _90 = (_104.ww * float2(0.20999999344348907470703125f, 0.4699999988079071044921875f)) + _35.xy;
    float2 _124 = (_104.ww * float2(0.730000019073486328125f, 0.189999997615814208984375f)) + _35.zw;
    vs_TEXCOORD0 = float4(vs_TEXCOORD0.x, vs_TEXCOORD0.y, _124.x, _124.y);
    _90.x = _NoiseTex.SampleLevel(sampler_NoiseTex, _90, 2.0f).x;
    _90.x += (-0.5f);
    _144 = _90.x + _90.x;
    _90.x = _144 * _17_m8;
    _41.w = (_90.x * _104.w) + _41.y;
    _35 = _41.wwww * _17_m3[1];
    _35 = (_17_m3[0] * _41.xxxx) + _35;
    _35 = (_17_m3[2] * _41.zzzz) + _35;
    gl_Position = _35 + _17_m3[3];
    float2 _204 = (_41.xz * _17_m7.xx) + _9.xy;
    _9 = float4(_204.x, _204.y, _9.z, _9.w);
    vs_TEXCOORD2 = _41.xwz;
    _90.x = (-_41.w) + _17_m1.y;
    _90.x = abs(_90.x) / _17_m5;
    _90.x = clamp(_90.x, 0.0f, 1.0f);
    float2 _240 = (_104.ww * float2(0.37000000476837158203125f, 0.61000001430511474609375f)) + _9.xy;
    vs_TEXCOORD0 = float4(_240.x, _240.y, vs_TEXCOORD0.z, vs_TEXCOORD0.w);
    _144 = _17_m4 + (-1.0f);
    _144 = (_104.w * _144) + 1.0f;
    _144 = _90.x * _144;
    _144 = _90.x * _144;
    vs_TEXCOORD1.z = _144;
    _144 = (-_17_m6) + 1.0f;
    _144 = (_104.w * _144) + _17_m6;
    vs_TEXCOORD1.w = _144;
    vs_TEXCOORD1 = float4(_281.x, _281.y, vs_TEXCOORD1.z, vs_TEXCOORD1.w);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _43 = stage_input._43;
    _104 = stage_input._104;
    _281 = stage_input._281;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 _LightColor0;
float4 _Color;
float _Density;
float _Cutoff;
float _EdgeFade;
float _Relief;
float _DirectStrength;
float _Scatter;
float4 _NearFade;
#define _17_m0 _WorldSpaceCameraPos
#define _17_m1 _WorldSpaceLightPos0
#define _17_m2 _LightColor0
#define _17_m3 _Color
#define _17_m4 _Density
#define _17_m5 _Cutoff
#define _17_m6 _EdgeFade
#define _17_m7 _Relief
#define _17_m8 _DirectStrength
#define _17_m9 _Scatter
#define _17_m10 _NearFade


Texture2D<float4> _NoiseTex;
SamplerState sampler_NoiseTex;

static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD1;
static float4 vs_TEXCOORD0;
static float4 _405;

struct SPIRV_Cross_Input
{
    float4 vs_TEXCOORD0 : TEXCOORD0;
    float4 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _405 : SV_Target0;
};

static float3 _9;
static float _25;
static float4 _30;
static float _62;
static float3 _131;
static float3 _142;
static float3 _148;
static float3 _169;
static float _265;
static float3 _330;
static float _353;

void frag_inner()
{
    _9 = (-vs_TEXCOORD2) + _17_m0;
    _25 = dot(_9, _9);
    _30.x = _25 + 9.9999997473787516355514526367188e-06f;
    _30.x = rsqrt(_30.x);
    _30.x = (abs(_9.y) * _30.x) + (-0.0040000001899898052215576171875f);
    _30.x *= 21.7391300201416015625f;
    _30.x = clamp(_30.x, 0.0f, 1.0f);
    _62 = (_30.x * (-2.0f)) + 3.0f;
    _30.x *= _30.x;
    _30.x *= _62;
    _62 = sqrt(_25);
    _25 = rsqrt(_25);
    _9 = _25.xxx * _9;
    _25 = _62 + (-_17_m10.x);
    _62 = max(_17_m10.y, 0.00999999977648258209228515625f);
    _25 /= _62;
    _25 = clamp(_25, 0.0f, 1.0f);
    _25 = _30.x * _25;
    float2 _115 = (-vs_TEXCOORD1.xy) + 1.0f.xx;
    _30 = float4(_115.x, _115.y, _30.z, _30.w);
    float2 _122 = min(_30.xy, vs_TEXCOORD1.xy);
    _30 = float4(_122.x, _122.y, _30.z, _30.w);
    _30.x = min(_30.y, _30.x);
    _131 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.zw).xyz;
    _142.x = _131.x * 0.3499999940395355224609375f;
    float2 _153 = _131.yz + (-0.5f).xx;
    _148 = float3(_153.x, _153.y, _148.z);
    _131 = _NoiseTex.Sample(sampler_NoiseTex, vs_TEXCOORD0.xy).xyz;
    _142.x = (_131.x * 0.64999997615814208984375f) + _142.x;
    float2 _172 = _131.yz + (-0.5f).xx;
    _169 = float3(_172.x, _172.y, _169.z);
    float2 _179 = _169.xy + _169.xy;
    _169 = float3(_179.x, _179.y, _169.z);
    float2 _189 = (_148.xy * 0.89999997615814208984375f.xx) + _169.xy;
    _148 = float3(_189.x, _189.y, _148.z);
    float2 _203 = _148.xy * float2(float2(_17_m7, _17_m7));
    _169 = float3(_203.x, _169.y, _203.y);
    _148.x = _142.x + (-0.5f);
    _142.x += (-_17_m5);
    _148.x *= _17_m6;
    _30.x = (_148.x * 0.800000011920928955078125f) + _30.x;
    _62 = 1.0f / _17_m6;
    _30.x = _62 * _30.x;
    _30.x = clamp(_30.x, 0.0f, 1.0f);
    _62 = (_30.x * (-2.0f)) + 3.0f;
    _30.x *= _30.x;
    _30.x *= _62;
    _148.x = _25 * _30.x;
    _265 = (-_17_m5) + 1.0f;
    _142.x /= _265;
    _142.x = clamp(_142.x, 0.0f, 1.0f);
    _265 = _142.x * _17_m4;
    _142.x = (-_142.x) + 1.0f;
    _25 = _265 * vs_TEXCOORD1.z;
    _30.w = _148.x * _25;
    _30.w = clamp(_30.w, 0.0f, 1.0f);
    _169.y = 1.0f;
    _148.x = dot(_169, _169);
    _148.x = rsqrt(_148.x);
    _148 = _148.xxx * _169;
    _25 = dot(_17_m1.xyz, _17_m1.xyz);
    _25 = rsqrt(_25);
    _330 = _25.xxx * _17_m1.xyz;
    _148.x = dot(_148, _330);
    _265 = dot(-_9, _330);
    _265 = clamp(_265, 0.0f, 1.0f);
    _148.x = (_148.x * 0.5f) + 0.5f;
    _353 = _265 * _265;
    _353 *= _353;
    _265 = _353 * _265;
    _142.x *= _265;
    _142.x *= _17_m9;
    _142.x = (_148.x * _17_m8) + _142.x;
    _148 = _17_m2.xyz * _17_m3.xyz;
    _142 = _142.xxx * _148;
    float3 _401 = _142 * vs_TEXCOORD1.www;
    _30 = float4(_401.x, _401.y, _401.z, _30.w);
    _405 = _30;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._405 = _405;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}