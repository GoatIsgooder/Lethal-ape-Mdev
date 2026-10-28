// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BloodDroplet" {
Properties {

_DropColor ("Surface Color", Color) = (0.42,0.02,0.02,1)

_DropDeep ("Deep Color", Color) = (0.07,0.004,0.004,1)

_Smoothness ("Smoothness", Range(0, 1)) = 0.8999999761581421

_Specular ("Highlight", Range(0, 4)) = 2.200000047683716

_Sheen ("Wet Sheen", Range(0, 2)) = 0.30000001192092896

[Toggle(BAKERY_VOLUME)] _BAKERY_VOLUME ("Use Bakery Volume", Float) = 1.0

_VolumeMin ("Volume Min", Vector) = (0,0,0,1)

_VolumeInvSize ("Volume Inv Size", Vector) = (1000000.0,1000000.0,1000000.0,1)

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
 Pass {
ZWrite On
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
 Cull Off
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ BAKERY_VOLUME
#if defined(BAKERY_VOLUME) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_MatrixVP;
static float4 _21_m9[4];
float4 unity_FogParams;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m9[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m9[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m9[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m10 unity_FogParams
#define _21_m11 _VolumeMin
#define _21_m12 _VolumeInvSize
#define _21_m13 _GlobalVolumeMin
#define _21_m14 _GlobalVolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD1;
static float2 _94;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD0;
static float4 _798;
static float4 _799;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _799 : COLOR;
    float2 _94 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _798 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float4 _102;
static bool _143;
static float4 _174;
static float4 _195;
static float _211;
static float4 _244;
static float3 _252;
static float3 _265;
static float _288;
static bool _292;
static float _332;
static float _364;
static float3 _407;
static float _411;
static float _454;
static float _466;
static float3 _525;
static float _583;
static float3 _647;
static bool _673;
static float3 _713;
static float _732;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    _51 = _45.yyyy * _21_m9[1];
    _51 = (_21_m9[0] * _45.xxxx) + _51;
    _51 = (_21_m9[2] * _45.zzzz) + _51;
    _45 = (_21_m9[3] * _45.wwww) + _51;
    float3 _87 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_87.x, _87.y, _87.z, _9.w);
    vs_TEXCOORD1 = (_94 * 2.0f.xx) + (-1.0f).xx;
    _102.x = dot(_21_m1.yw, 1.0f.xx);
    _102.y = dot(_21_m2.yw, 1.0f.xx);
    _102.z = dot(_21_m3.yw, 1.0f.xx);
    float3 _131 = _102.xyz + (-_21_m7.xyz);
    _102 = float4(_131.x, _131.y, _131.z, _102.w);
    vs_TEXCOORD2 = max(_102.xyz, 0.2199999988079071044921875f.xxx);
    _143 = 1000000.0f < _21_m12.x;
    float3 _152;
    if (_143)
    {
        _152 = _21_m13;
    }
    else
    {
        _152 = _21_m11;
    }
    _51 = float4(_152.x, _152.y, _152.z, _51.w);
    float3 _171 = _9.xyz + (-_51.xyz);
    _51 = float4(_171.x, _171.y, _171.z, _51.w);
    float3 _176;
    if (_143)
    {
        _176 = _21_m14;
    }
    else
    {
        _176 = _21_m12;
    }
    _174 = float4(_176.x, _176.y, _176.z, _174.w);
    float3 _192 = _51.xyz * _174.xyz;
    _51 = float4(_192.x, _192.y, _192.z, _51.w);
    _195 = _Volume0.SampleLevel(sampler_Volume0, _51.xyz, 0.0f).xywz;
    _211 = _195.y + _195.x;
    _211 = _195.w + _211;
    _143 = 9.9999997473787516355514526367188e-06f < _211;
    if (_143)
    {
        _174 = _Volume1.SampleLevel(sampler_Volume0, _51.xyz, 0.0f).yxwz;
        _51 = _Volume2.SampleLevel(sampler_Volume0, _51.xyz, 0.0f).xzwy;
        float3 _248 = max(_195.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _244 = float4(_248.x, _248.y, _248.z, _244.w);
        _252 = _174.yxw / _244.xyz;
        _252.x = dot(_252, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _265 = _51.xwy / _244.xyz;
        _252.y = dot(_265, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _195.x = _174.z;
        _195.y = _51.z;
        _265 = _195.zxy / _244.xyz;
        _252.z = dot(_265, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _288 = dot(_252, _252);
        _292 = 9.9999999392252902907785028219223e-09f < _288;
        _288 = rsqrt(_288);
        _252 = _288.xxx * _252;
        float3 _303;
        if (_292)
        {
            _303 = _252;
        }
        else
        {
            _303 = float3(0.0f, 1.0f, 0.0f);
        }
        _252 = _303;
        _195.x = _174.y;
        _195.y = _51.x;
        _265 = _195.xyz * 0.5f.xxx;
        _288 = dot(_265, _265);
        _288 = sqrt(_288);
        _265 = (_195.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _332 = dot(_265, _265);
        _332 = rsqrt(_332);
        _265 = _332.xxx * _265;
        _332 = dot(_265, _252);
        _332 = (_332 * 0.5f) + 0.5f;
        _332 = clamp(_332, 0.0f, 1.0f);
        _265.x = _288 + _288;
        _265.x /= _244.x;
        _288 /= _244.x;
        _364 = (-_288) + 1.0f;
        _288 += 1.0f;
        _288 = _364 / _288;
        _364 = (-_288) + 1.0f;
        float2 _379 = _265.xx + float2(1.0f, 2.0f);
        _265 = float3(_379.x, _265.y, _379.y);
        _364 = _265.z * _364;
        _332 = log2(_332);
        _332 *= _265.x;
        _332 = exp2(_332);
        _288 = (_364 * _332) + _288;
        _265.x = _288 * _244.x;
        _174.y = _51.w;
        _407 = _174.xyz * 0.5f.xxx;
        _411 = dot(_407, _407);
        _411 = sqrt(_411);
        float3 _420 = (_174.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _174 = float4(_420.x, _420.y, _420.z, _174.w);
        _244.x = dot(_174.xyz, _174.xyz);
        _244.x = rsqrt(_244.x);
        float3 _437 = _174.xyz * _244.xxx;
        _174 = float4(_437.x, _437.y, _437.z, _174.w);
        _174.x = dot(_174.xyz, _252);
        _174.x = (_174.x * 0.5f) + 0.5f;
        _174.x = clamp(_174.x, 0.0f, 1.0f);
        _454 = _411 + _411;
        _454 /= _244.y;
        _411 /= _244.y;
        _466 = (-_411) + 1.0f;
        _411 += 1.0f;
        _411 = _466 / _411;
        _466 = (-_411) + 1.0f;
        float2 _480 = _454.xx + float2(1.0f, 2.0f);
        _244 = float4(_480.x, _244.y, _244.z, _480.y);
        _454 = _466 * _244.w;
        _174.x = log2(_174.x);
        _174.x *= _244.x;
        _174.x = exp2(_174.x);
        _411 = (_454 * _174.x) + _411;
        _265.y = _411 * _244.y;
        _51.x = _174.w;
        float3 _517 = _51.xyz * 0.5f.xxx;
        _174 = float4(_517.x, _517.y, _517.z, _174.w);
        _411 = dot(_174.xyz, _174.xyz);
        _525.z = sqrt(_411);
        float3 _532 = (_51.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _51 = float4(_532.x, _532.y, _532.z, _51.w);
        _174.x = dot(_51.xyz, _51.xyz);
        _174.x = rsqrt(_174.x);
        float3 _549 = _51.xyz * _174.xxx;
        _51 = float4(_549.x, _549.y, _549.z, _51.w);
        _51.x = dot(_51.xyz, _252);
        _51.x = (_51.x * 0.5f) + 0.5f;
        _51.x = clamp(_51.x, 0.0f, 1.0f);
        _525.x = _525.z + _525.z;
        float2 _576 = _525.xz / _244.zz;
        _525 = float3(_576.x, _576.y, _525.z);
        _411 = (-_525.y) + 1.0f;
        _583 = _525.y + 1.0f;
        _583 = _411 / _583;
        _411 = (-_583) + 1.0f;
        float2 _595 = _525.xx + float2(1.0f, 2.0f);
        _174 = float4(_595.x, _595.y, _174.z, _174.w);
        _525.x = _411 * _174.y;
        _51.x = log2(_51.x);
        _51.x *= _174.x;
        _51.x = exp2(_51.x);
        _51.x = (_525.x * _51.x) + _583;
        _265.z = _51.x * _244.z;
        float3 _633 = max(_265, 0.0f.xxx);
        _51 = float4(_633.x, _633.y, _633.z, _51.w);
        vs_TEXCOORD5 = _51.xyz;
    }
    else
    {
        _252.x = 0.0f;
        _252.y = 1.0f;
        _252.z = 0.0f;
        vs_TEXCOORD5 = 0.0f.xxx;
    }
    if (!_143)
    {
        _647 = _21_m2.xyz * 0.715200006961822509765625f.xxx;
        _647 = (_21_m1.xyz * 0.2125999927520751953125f.xxx) + _647;
        _647 = (_21_m3.xyz * 0.072200000286102294921875f.xxx) + _647;
        _211 = dot(_647, _647);
        _673 = 9.9999999392252902907785028219223e-09f < _211;
        _211 = rsqrt(_211);
        _525 = _211.xxx * _647;
        float3 _683;
        if (_673)
        {
            _683 = _525;
        }
        else
        {
            _683 = _252;
        }
        _51 = float4(_683.x, _683.y, _683.z, _51.w);
        _51.w = 1.0f;
        _647.x = dot(_21_m1, _51);
        _647.y = dot(_21_m2, _51);
        _647.z = dot(_21_m3, _51);
        _102 = _51.yzzx * _51.xyzz;
        _713.x = dot(_21_m4, _102);
        _713.y = dot(_21_m5, _102);
        _713.z = dot(_21_m6, _102);
        _732 = _51.y * _51.y;
        _732 = (_51.x * _51.x) + (-_732);
        _713 = (_21_m7.xyz * _732.xxx) + _713;
        _647 += _713;
        vs_TEXCOORD5 = max(_647, 0.0f.xxx);
        vs_TEXCOORD4 = _51.xyz;
    }
    else
    {
        vs_TEXCOORD4 = _252;
    }
    _211 = _45.z / _21_m0.y;
    _211 = (-_211) + 1.0f;
    _211 *= _21_m0.z;
    _211 = max(_211, 0.0f);
    _211 *= _21_m10.y;
    vs_TEXCOORD3 = exp2(-_211);
    gl_Position = _45;
    vs_TEXCOORD0 = _9.xyz;
    _798 = _799;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _94 = stage_input._94;
    _799 = stage_input._799;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._798 = _798;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_MatrixInvV;
static float4 _77_m9[4];
float4 unity_FogColor;
float4 _LightColor0;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _DropColor;
float4 _DropDeep;
float _Smoothness;
float _Specular;
float _Sheen;
void __unity_init()
{
    _77_m9[0] = float4(unity_MatrixInvV[0][0], unity_MatrixInvV[1][0], unity_MatrixInvV[2][0], unity_MatrixInvV[3][0]);
    _77_m9[1] = float4(unity_MatrixInvV[0][1], unity_MatrixInvV[1][1], unity_MatrixInvV[2][1], unity_MatrixInvV[3][1]);
    _77_m9[2] = float4(unity_MatrixInvV[0][2], unity_MatrixInvV[1][2], unity_MatrixInvV[2][2], unity_MatrixInvV[3][2]);
    _77_m9[3] = float4(unity_MatrixInvV[0][3], unity_MatrixInvV[1][3], unity_MatrixInvV[2][3], unity_MatrixInvV[3][3]);
}
#define _77_m0 _WorldSpaceCameraPos
#define _77_m1 _WorldSpaceLightPos0
#define _77_m2 unity_SHAr
#define _77_m3 unity_SHAg
#define _77_m4 unity_SHAb
#define _77_m5 unity_SHBr
#define _77_m6 unity_SHBg
#define _77_m7 unity_SHBb
#define _77_m8 unity_SHC
#define _77_m10 unity_FogColor
#define _77_m11 _LightColor0
#define _77_m12 _VolumeMin
#define _77_m13 _VolumeInvSize
#define _77_m14 _GlobalVolumeMin
#define _77_m15 _GlobalVolumeInvSize
#define _77_m16 _DropColor
#define _77_m17 _DropDeep
#define _77_m18 _Smoothness
#define _77_m19 _Specular
#define _77_m20 _Sheen


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float2 vs_TEXCOORD1;
static float4 _29;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD3;
static float4 _1022;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _29 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1022 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _36;
static bool _47;
static float3 _101;
static float4 _111;
static bool _140;
static float3 _167;
static float4 _182;
static float _196;
static float4 _213;
static float4 _221;
static float3 _229;
static float3 _240;
static float _246;
static float3 _250;
static float _261;
static float _302;
static float _358;
static float4 _364;
static float _409;
static float3 _461;
static float _509;
static float3 _557;
static float4 _564;
static float3 _587;
static float _606;
static float _677;
static bool _685;
static float _795;
static float3 _837;
static float3 _847;

void frag_inner()
{
    __unity_init();
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = (-_9.x) + 1.0f;
    _26 = (-_29.w) + 1.0f;
    _36.x = ((-_26) * 0.60000002384185791015625f) + _9.x;
    _47 = _36.x < 0.0f;
    if ((int(_47) * (-1)) != 0)
    {
        discard;
    }
    _9.x = max(_9.x, 0.0f);
    _9.x = sqrt(_9.x);
    _36 = vs_TEXCOORD1.yyy * _77_m9[1].xyz;
    _36 = (_77_m9[0].xyz * vs_TEXCOORD1.xxx) + _36;
    _36 = (_77_m9[2].xyz * _9.xxx) + _36;
    _101.x = dot(_36, _36);
    _101.x = rsqrt(_101.x);
    float3 _115 = _36 * _101.xxx;
    _111 = float4(_115.x, _115.y, _115.z, _111.w);
    _36 = _77_m16.xyz + (-_77_m17.xyz);
    _9 = (_9.xxx * _36) + _77_m17.xyz;
    _9 *= _29.xyz;
    _140 = 1000000.0f < _77_m13.x;
    float3 _149;
    if (_140)
    {
        _149 = _77_m14;
    }
    else
    {
        _149 = _77_m12;
    }
    _101 = _149;
    _101 = (-_101) + vs_TEXCOORD0;
    float3 _169;
    if (_140)
    {
        _169 = _77_m15;
    }
    else
    {
        _169 = _77_m13;
    }
    _167 = _169;
    _101 *= _167;
    _182 = _Volume0.SampleLevel(sampler_Volume0, _101, 0.0f).xywz;
    _196 = _182.y + _182.x;
    _196 = _182.w + _196;
    _140 = 9.9999997473787516355514526367188e-06f < _196;
    if (_140)
    {
        _213 = _Volume1.SampleLevel(sampler_Volume0, _101, 0.0f).yxwz;
        _221 = _Volume2.SampleLevel(sampler_Volume0, _101, 0.0f).xzwy;
        _229 = max(_182.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _182.x = _213.y;
        _182.y = _221.x;
        _240 = _182.xyz * 0.5f.xxx;
        _246 = dot(_240, _240);
        _250.z = sqrt(_246);
        _167 = (_182.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _261 = dot(_167, _167);
        _261 = rsqrt(_261);
        _167 *= _261.xxx;
        _167.x = dot(_167, _111.xyz);
        _167.x = (_167.x * 0.5f) + 0.5f;
        _167.x = clamp(_167.x, 0.0f, 1.0f);
        _250.x = _250.z + _250.z;
        float2 _295 = _250.xz / _229.xx;
        _250 = float3(_295.x, _295.y, _250.z);
        _246 = (-_250.y) + 1.0f;
        _302 = _250.y + 1.0f;
        _302 = _246 / _302;
        _246 = (-_302) + 1.0f;
        float2 _316 = _250.xx + float2(1.0f, 2.0f);
        _240 = float3(_316.x, _316.y, _240.z);
        _250.x = _246 * _240.y;
        _167.x = log2(_167.x);
        _167.x *= _240.x;
        _167.x = exp2(_167.x);
        _167.x = (_250.x * _167.x) + _302;
        _167.x *= _229.x;
        _213.y = _221.w;
        _240 = _213.xyz * 0.5f.xxx;
        _358 = dot(_240, _240);
        _358 = sqrt(_358);
        float3 _368 = (_213.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _364 = float4(_368.x, _368.y, _368.z, _364.w);
        _246 = dot(_364.xyz, _364.xyz);
        _246 = rsqrt(_246);
        float3 _382 = _246.xxx * _364.xyz;
        _364 = float4(_382.x, _382.y, _382.z, _364.w);
        _246 = dot(_364.xyz, _111.xyz);
        _246 = (_246 * 0.5f) + 0.5f;
        _246 = clamp(_246, 0.0f, 1.0f);
        _364.x = _358 + _358;
        _364.x /= _229.y;
        _358 /= _229.y;
        _409 = (-_358) + 1.0f;
        _358 += 1.0f;
        _358 = _409 / _358;
        _409 = (-_358) + 1.0f;
        float2 _423 = _364.xx + float2(1.0f, 2.0f);
        _364 = float4(_423.x, _364.y, _423.y, _364.w);
        _409 = _364.z * _409;
        _246 = log2(_246);
        _246 *= _364.x;
        _246 = exp2(_246);
        _358 = (_409 * _246) + _358;
        _167.y = _358 * _229.y;
        _221.x = _213.w;
        float3 _453 = _221.xyz * 0.5f.xxx;
        _364 = float4(_453.x, _453.y, _453.z, _364.w);
        _358 = dot(_364.xyz, _364.xyz);
        _461.z = sqrt(_358);
        _101 = (_221.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _246 = dot(_101, _101);
        _246 = rsqrt(_246);
        _101 *= _246.xxx;
        _101.x = dot(_101, _111.xyz);
        _101.x = (_101.x * 0.5f) + 0.5f;
        _101.x = clamp(_101.x, 0.0f, 1.0f);
        _461.x = _461.z + _461.z;
        float2 _502 = _461.xz / _229.zz;
        _461 = float3(_502.x, _502.y, _461.z);
        _358 = (-_461.y) + 1.0f;
        _509 = _461.y + 1.0f;
        _509 = _358 / _509;
        _358 = (-_509) + 1.0f;
        float2 _521 = _461.xx + float2(1.0f, 2.0f);
        _364 = float4(_521.x, _521.y, _364.z, _364.w);
        _461.x = _358 * _364.y;
        _101.x = log2(_101.x);
        _101.x *= _364.x;
        _101.x = exp2(_101.x);
        _101.x = (_461.x * _101.x) + _509;
        _167.z = _101.x * _229.z;
        _557 = _167;
    }
    else
    {
        _557.x = 0.0f;
        _557.y = 0.0f;
        _557.z = 0.0f;
    }
    _111.w = 1.0f;
    _564.x = dot(_77_m2, _111);
    _564.y = dot(_77_m3, _111);
    _564.z = dot(_77_m4, _111);
    _221 = _111.yzzx * _111.xyzz;
    _587.x = dot(_77_m5, _221);
    _587.y = dot(_77_m6, _221);
    _587.z = dot(_77_m7, _221);
    _606 = _111.y * _111.y;
    _606 = (_111.x * _111.x) + (-_606);
    _587 = (_77_m8.xyz * _606.xxx) + _587;
    float3 _632 = _564.xyz + _587;
    _564 = float4(_632.x, _632.y, _632.z, _564.w);
    float3 _636;
    if (_140)
    {
        _636 = _557;
    }
    else
    {
        _636 = _564.xyz;
    }
    _557 = _636;
    _196 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _196 = rsqrt(_196);
    _167 = _196.xxx * vs_TEXCOORD4;
    _557 = max(_557, 0.2199999988079071044921875f.xxx);
    float3 _662 = (-vs_TEXCOORD0) + _77_m0;
    _364 = float4(_662.x, _662.y, _662.z, _364.w);
    _246 = dot(_364.xyz, _364.xyz);
    _246 = rsqrt(_246);
    _229 = _246.xxx * _364.xyz;
    _677 = dot(_77_m1.xyz, _77_m1.xyz);
    _685 = 9.9999999747524270787835121154785e-07f < _677;
    _677 = rsqrt(_677);
    _240 = _677.xxx * _77_m1.xyz;
    float3 _697;
    if (_685)
    {
        _697 = _240;
    }
    else
    {
        _697 = float3(0.0f, 1.0f, 0.0f);
    }
    _240 = _697;
    float3 _710 = (_364.xyz * _246.xxx) + _240;
    _364 = float4(_710.x, _710.y, _710.z, _364.w);
    _246 = dot(_364.xyz, _364.xyz);
    _246 = rsqrt(_246);
    float3 _724 = _246.xxx * _364.xyz;
    _364 = float4(_724.x, _724.y, _724.z, _364.w);
    _246 = dot(_111.xyz, _240);
    _246 = (_246 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _246 = clamp(_246, 0.0f, 1.0f);
    _364.x = dot(_111.xyz, _364.xyz);
    _364.x = clamp(_364.x, 0.0f, 1.0f);
    float2 _757 = (_77_m18.xx * float2(10.0f, 7.0f)) + 1.0f.xx;
    _564 = float4(_757.x, _757.y, _564.z, _564.w);
    float2 _762 = exp2(_564.xy);
    _564 = float4(_762.x, _762.y, _564.z, _564.w);
    _364.x = log2(_364.x);
    _364.x *= _564.x;
    _364.x = exp2(_364.x);
    _364.x *= _77_m19;
    _409 = dot(_111.xyz, _229);
    _409 = clamp(_409, 0.0f, 1.0f);
    _409 = (-_409) + 1.0f;
    _795 = _409 * _409;
    _795 *= _795;
    _409 = _795 * _409;
    _795 = (_409 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    float3 _813 = _795.xxx * _557;
    _564 = float4(_813.x, _564.y, _813.y, _813.z);
    float3 _821 = _564.xzw * _77_m18.xxx;
    _564 = float4(_821.x, _564.y, _821.y, _821.z);
    float3 _828 = _564.xzw * 0.300000011920928955078125f.xxx;
    _564 = float4(_828.x, _564.y, _828.y, _828.z);
    _587 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _837 = (_77_m11.xyz * _246.xxx) + _557;
    _847 = _364.xxx * _77_m11.xyz;
    _837 = (_9 * _837) + _847;
    float3 _864 = (_564.xzw * _587) + _837;
    _564 = float4(_864.x, _564.y, _864.y, _864.z);
    float3 _872 = (vs_TEXCOORD4 * _196.xxx) + _229;
    _364 = float4(_872.x, _364.y, _872.y, _872.z);
    _196 = dot(_364.xzw, _364.xzw);
    _196 = rsqrt(_196);
    float3 _886 = _196.xxx * _364.xzw;
    _364 = float4(_886.x, _364.y, _886.y, _886.z);
    _196 = dot(_111.xyz, _364.xzw);
    _196 = clamp(_196, 0.0f, 1.0f);
    _196 = log2(_196);
    _196 *= _564.y;
    _196 = exp2(_196);
    _196 *= _77_m19;
    _246 = dot(-_229, _111.xyz);
    _246 += _246;
    float3 _924 = (_111.xyz * (-_246.xxx)) + (-_229);
    _364 = float4(_924.x, _364.y, _924.y, _924.z);
    _167.x = dot(_364.xzw, _167);
    _167.x = (_167.x * 0.5f) + 0.5f;
    _167.x = clamp(_167.x, 0.0f, 1.0f);
    _167.x *= _167.x;
    _167.x *= _167.x;
    _587 = (-_557) + vs_TEXCOORD5;
    _557 = (_167.xxx * _587) + _557;
    _587 = (_9 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    float3 _977 = (vs_TEXCOORD5 * _196.xxx) + _564.xzw;
    _564 = float4(_977.x, _977.y, _977.z, _564.w);
    _557 *= _587;
    _606 = _409 * _77_m20;
    _606 *= _77_m18;
    _557 = (_557 * _606.xxx) + _564.xyz;
    _9.x = vs_TEXCOORD3;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _36 = _557 + (-_77_m10.xyz);
    _9 = (_9.xxx * _36) + _77_m10.xyz;
    _1022 = float4(_9.x, _9.y, _9.z, _1022.w);
    _1022.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _29 = stage_input._29;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1022 = _1022;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_MatrixVP;
static float4 _21_m9[4];
float4 unity_FogParams;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m9[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m9[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m9[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m10 unity_FogParams
#define _21_m11 _VolumeMin
#define _21_m12 _VolumeInvSize
#define _21_m13 _GlobalVolumeMin
#define _21_m14 _GlobalVolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD1;
static float2 _94;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD0;
static float4 _801;
static float4 _802;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _802 : COLOR;
    float2 _94 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _801 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float4 _102;
static bool _143;
static float4 _174;
static float4 _195;
static float _211;
static float4 _244;
static float3 _252;
static float3 _265;
static float _288;
static bool _292;
static float _332;
static float _364;
static float3 _407;
static float _411;
static float _454;
static float _466;
static float3 _525;
static float _583;
static float3 _647;
static bool _673;
static float3 _713;
static float _732;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    _51 = _45.yyyy * _21_m9[1];
    _51 = (_21_m9[0] * _45.xxxx) + _51;
    _51 = (_21_m9[2] * _45.zzzz) + _51;
    _45 = (_21_m9[3] * _45.wwww) + _51;
    float3 _87 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_87.x, _87.y, _87.z, _9.w);
    vs_TEXCOORD1 = (_94 * 2.0f.xx) + (-1.0f).xx;
    _102.x = dot(_21_m1.yw, 1.0f.xx);
    _102.y = dot(_21_m2.yw, 1.0f.xx);
    _102.z = dot(_21_m3.yw, 1.0f.xx);
    float3 _131 = _102.xyz + (-_21_m7.xyz);
    _102 = float4(_131.x, _131.y, _131.z, _102.w);
    vs_TEXCOORD2 = max(_102.xyz, 0.2199999988079071044921875f.xxx);
    _143 = 1000000.0f < _21_m12.x;
    float3 _152;
    if (_143)
    {
        _152 = _21_m13;
    }
    else
    {
        _152 = _21_m11;
    }
    _51 = float4(_152.x, _152.y, _152.z, _51.w);
    float3 _171 = _9.xyz + (-_51.xyz);
    _51 = float4(_171.x, _171.y, _171.z, _51.w);
    float3 _176;
    if (_143)
    {
        _176 = _21_m14;
    }
    else
    {
        _176 = _21_m12;
    }
    _174 = float4(_176.x, _176.y, _176.z, _174.w);
    float3 _192 = _51.xyz * _174.xyz;
    _51 = float4(_192.x, _192.y, _192.z, _51.w);
    _195 = _Volume0.SampleLevel(sampler_Volume0, _51.xyz, 0.0f).xywz;
    _211 = _195.y + _195.x;
    _211 = _195.w + _211;
    _143 = 9.9999997473787516355514526367188e-06f < _211;
    if (_143)
    {
        _174 = _Volume1.SampleLevel(sampler_Volume0, _51.xyz, 0.0f).yxwz;
        _51 = _Volume2.SampleLevel(sampler_Volume0, _51.xyz, 0.0f).xzwy;
        float3 _248 = max(_195.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _244 = float4(_248.x, _248.y, _248.z, _244.w);
        _252 = _174.yxw / _244.xyz;
        _252.x = dot(_252, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _265 = _51.xwy / _244.xyz;
        _252.y = dot(_265, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _195.x = _174.z;
        _195.y = _51.z;
        _265 = _195.zxy / _244.xyz;
        _252.z = dot(_265, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _288 = dot(_252, _252);
        _292 = 9.9999999392252902907785028219223e-09f < _288;
        _288 = rsqrt(_288);
        _252 = _288.xxx * _252;
        float3 _303;
        if (_292)
        {
            _303 = _252;
        }
        else
        {
            _303 = float3(0.0f, 1.0f, 0.0f);
        }
        _252 = _303;
        _195.x = _174.y;
        _195.y = _51.x;
        _265 = _195.xyz * 0.5f.xxx;
        _288 = dot(_265, _265);
        _288 = sqrt(_288);
        _265 = (_195.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _332 = dot(_265, _265);
        _332 = rsqrt(_332);
        _265 = _332.xxx * _265;
        _332 = dot(_265, _252);
        _332 = (_332 * 0.5f) + 0.5f;
        _332 = clamp(_332, 0.0f, 1.0f);
        _265.x = _288 + _288;
        _265.x /= _244.x;
        _288 /= _244.x;
        _364 = (-_288) + 1.0f;
        _288 += 1.0f;
        _288 = _364 / _288;
        _364 = (-_288) + 1.0f;
        float2 _379 = _265.xx + float2(1.0f, 2.0f);
        _265 = float3(_379.x, _265.y, _379.y);
        _364 = _265.z * _364;
        _332 = log2(_332);
        _332 *= _265.x;
        _332 = exp2(_332);
        _288 = (_364 * _332) + _288;
        _265.x = _288 * _244.x;
        _174.y = _51.w;
        _407 = _174.xyz * 0.5f.xxx;
        _411 = dot(_407, _407);
        _411 = sqrt(_411);
        float3 _420 = (_174.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _174 = float4(_420.x, _420.y, _420.z, _174.w);
        _244.x = dot(_174.xyz, _174.xyz);
        _244.x = rsqrt(_244.x);
        float3 _437 = _174.xyz * _244.xxx;
        _174 = float4(_437.x, _437.y, _437.z, _174.w);
        _174.x = dot(_174.xyz, _252);
        _174.x = (_174.x * 0.5f) + 0.5f;
        _174.x = clamp(_174.x, 0.0f, 1.0f);
        _454 = _411 + _411;
        _454 /= _244.y;
        _411 /= _244.y;
        _466 = (-_411) + 1.0f;
        _411 += 1.0f;
        _411 = _466 / _411;
        _466 = (-_411) + 1.0f;
        float2 _480 = _454.xx + float2(1.0f, 2.0f);
        _244 = float4(_480.x, _244.y, _244.z, _480.y);
        _454 = _466 * _244.w;
        _174.x = log2(_174.x);
        _174.x *= _244.x;
        _174.x = exp2(_174.x);
        _411 = (_454 * _174.x) + _411;
        _265.y = _411 * _244.y;
        _51.x = _174.w;
        float3 _517 = _51.xyz * 0.5f.xxx;
        _174 = float4(_517.x, _517.y, _517.z, _174.w);
        _411 = dot(_174.xyz, _174.xyz);
        _525.z = sqrt(_411);
        float3 _532 = (_51.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _51 = float4(_532.x, _532.y, _532.z, _51.w);
        _174.x = dot(_51.xyz, _51.xyz);
        _174.x = rsqrt(_174.x);
        float3 _549 = _51.xyz * _174.xxx;
        _51 = float4(_549.x, _549.y, _549.z, _51.w);
        _51.x = dot(_51.xyz, _252);
        _51.x = (_51.x * 0.5f) + 0.5f;
        _51.x = clamp(_51.x, 0.0f, 1.0f);
        _525.x = _525.z + _525.z;
        float2 _576 = _525.xz / _244.zz;
        _525 = float3(_576.x, _576.y, _525.z);
        _411 = (-_525.y) + 1.0f;
        _583 = _525.y + 1.0f;
        _583 = _411 / _583;
        _411 = (-_583) + 1.0f;
        float2 _595 = _525.xx + float2(1.0f, 2.0f);
        _174 = float4(_595.x, _595.y, _174.z, _174.w);
        _525.x = _411 * _174.y;
        _51.x = log2(_51.x);
        _51.x *= _174.x;
        _51.x = exp2(_51.x);
        _51.x = (_525.x * _51.x) + _583;
        _265.z = _51.x * _244.z;
        float3 _633 = max(_265, 0.0f.xxx);
        _51 = float4(_633.x, _633.y, _633.z, _51.w);
        vs_TEXCOORD5 = _51.xyz;
    }
    else
    {
        _252.x = 0.0f;
        _252.y = 1.0f;
        _252.z = 0.0f;
        vs_TEXCOORD5 = 0.0f.xxx;
    }
    if (!_143)
    {
        _647 = _21_m2.xyz * 0.715200006961822509765625f.xxx;
        _647 = (_21_m1.xyz * 0.2125999927520751953125f.xxx) + _647;
        _647 = (_21_m3.xyz * 0.072200000286102294921875f.xxx) + _647;
        _211 = dot(_647, _647);
        _673 = 9.9999999392252902907785028219223e-09f < _211;
        _211 = rsqrt(_211);
        _525 = _211.xxx * _647;
        float3 _683;
        if (_673)
        {
            _683 = _525;
        }
        else
        {
            _683 = _252;
        }
        _51 = float4(_683.x, _683.y, _683.z, _51.w);
        _51.w = 1.0f;
        _647.x = dot(_21_m1, _51);
        _647.y = dot(_21_m2, _51);
        _647.z = dot(_21_m3, _51);
        _102 = _51.yzzx * _51.xyzz;
        _713.x = dot(_21_m4, _102);
        _713.y = dot(_21_m5, _102);
        _713.z = dot(_21_m6, _102);
        _732 = _51.y * _51.y;
        _732 = (_51.x * _51.x) + (-_732);
        _713 = (_21_m7.xyz * _732.xxx) + _713;
        _647 += _713;
        vs_TEXCOORD5 = max(_647, 0.0f.xxx);
        vs_TEXCOORD4 = _51.xyz;
    }
    else
    {
        vs_TEXCOORD4 = _252;
    }
    _211 = _45.z / _21_m0.y;
    _211 = (-_211) + 1.0f;
    _211 *= _21_m0.z;
    _211 = max(_211, 0.0f);
    _211 *= _21_m10.x;
    _211 *= (-_211);
    vs_TEXCOORD3 = exp2(_211);
    gl_Position = _45;
    vs_TEXCOORD0 = _9.xyz;
    _801 = _802;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _94 = stage_input._94;
    _802 = stage_input._802;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._801 = _801;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_MatrixInvV;
static float4 _77_m9[4];
float4 unity_FogColor;
float4 _LightColor0;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _DropColor;
float4 _DropDeep;
float _Smoothness;
float _Specular;
float _Sheen;
void __unity_init()
{
    _77_m9[0] = float4(unity_MatrixInvV[0][0], unity_MatrixInvV[1][0], unity_MatrixInvV[2][0], unity_MatrixInvV[3][0]);
    _77_m9[1] = float4(unity_MatrixInvV[0][1], unity_MatrixInvV[1][1], unity_MatrixInvV[2][1], unity_MatrixInvV[3][1]);
    _77_m9[2] = float4(unity_MatrixInvV[0][2], unity_MatrixInvV[1][2], unity_MatrixInvV[2][2], unity_MatrixInvV[3][2]);
    _77_m9[3] = float4(unity_MatrixInvV[0][3], unity_MatrixInvV[1][3], unity_MatrixInvV[2][3], unity_MatrixInvV[3][3]);
}
#define _77_m0 _WorldSpaceCameraPos
#define _77_m1 _WorldSpaceLightPos0
#define _77_m2 unity_SHAr
#define _77_m3 unity_SHAg
#define _77_m4 unity_SHAb
#define _77_m5 unity_SHBr
#define _77_m6 unity_SHBg
#define _77_m7 unity_SHBb
#define _77_m8 unity_SHC
#define _77_m10 unity_FogColor
#define _77_m11 _LightColor0
#define _77_m12 _VolumeMin
#define _77_m13 _VolumeInvSize
#define _77_m14 _GlobalVolumeMin
#define _77_m15 _GlobalVolumeInvSize
#define _77_m16 _DropColor
#define _77_m17 _DropDeep
#define _77_m18 _Smoothness
#define _77_m19 _Specular
#define _77_m20 _Sheen


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float2 vs_TEXCOORD1;
static float4 _29;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD3;
static float4 _1022;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _29 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1022 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _36;
static bool _47;
static float3 _101;
static float4 _111;
static bool _140;
static float3 _167;
static float4 _182;
static float _196;
static float4 _213;
static float4 _221;
static float3 _229;
static float3 _240;
static float _246;
static float3 _250;
static float _261;
static float _302;
static float _358;
static float4 _364;
static float _409;
static float3 _461;
static float _509;
static float3 _557;
static float4 _564;
static float3 _587;
static float _606;
static float _677;
static bool _685;
static float _795;
static float3 _837;
static float3 _847;

void frag_inner()
{
    __unity_init();
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = (-_9.x) + 1.0f;
    _26 = (-_29.w) + 1.0f;
    _36.x = ((-_26) * 0.60000002384185791015625f) + _9.x;
    _47 = _36.x < 0.0f;
    if ((int(_47) * (-1)) != 0)
    {
        discard;
    }
    _9.x = max(_9.x, 0.0f);
    _9.x = sqrt(_9.x);
    _36 = vs_TEXCOORD1.yyy * _77_m9[1].xyz;
    _36 = (_77_m9[0].xyz * vs_TEXCOORD1.xxx) + _36;
    _36 = (_77_m9[2].xyz * _9.xxx) + _36;
    _101.x = dot(_36, _36);
    _101.x = rsqrt(_101.x);
    float3 _115 = _36 * _101.xxx;
    _111 = float4(_115.x, _115.y, _115.z, _111.w);
    _36 = _77_m16.xyz + (-_77_m17.xyz);
    _9 = (_9.xxx * _36) + _77_m17.xyz;
    _9 *= _29.xyz;
    _140 = 1000000.0f < _77_m13.x;
    float3 _149;
    if (_140)
    {
        _149 = _77_m14;
    }
    else
    {
        _149 = _77_m12;
    }
    _101 = _149;
    _101 = (-_101) + vs_TEXCOORD0;
    float3 _169;
    if (_140)
    {
        _169 = _77_m15;
    }
    else
    {
        _169 = _77_m13;
    }
    _167 = _169;
    _101 *= _167;
    _182 = _Volume0.SampleLevel(sampler_Volume0, _101, 0.0f).xywz;
    _196 = _182.y + _182.x;
    _196 = _182.w + _196;
    _140 = 9.9999997473787516355514526367188e-06f < _196;
    if (_140)
    {
        _213 = _Volume1.SampleLevel(sampler_Volume0, _101, 0.0f).yxwz;
        _221 = _Volume2.SampleLevel(sampler_Volume0, _101, 0.0f).xzwy;
        _229 = max(_182.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _182.x = _213.y;
        _182.y = _221.x;
        _240 = _182.xyz * 0.5f.xxx;
        _246 = dot(_240, _240);
        _250.z = sqrt(_246);
        _167 = (_182.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _261 = dot(_167, _167);
        _261 = rsqrt(_261);
        _167 *= _261.xxx;
        _167.x = dot(_167, _111.xyz);
        _167.x = (_167.x * 0.5f) + 0.5f;
        _167.x = clamp(_167.x, 0.0f, 1.0f);
        _250.x = _250.z + _250.z;
        float2 _295 = _250.xz / _229.xx;
        _250 = float3(_295.x, _295.y, _250.z);
        _246 = (-_250.y) + 1.0f;
        _302 = _250.y + 1.0f;
        _302 = _246 / _302;
        _246 = (-_302) + 1.0f;
        float2 _316 = _250.xx + float2(1.0f, 2.0f);
        _240 = float3(_316.x, _316.y, _240.z);
        _250.x = _246 * _240.y;
        _167.x = log2(_167.x);
        _167.x *= _240.x;
        _167.x = exp2(_167.x);
        _167.x = (_250.x * _167.x) + _302;
        _167.x *= _229.x;
        _213.y = _221.w;
        _240 = _213.xyz * 0.5f.xxx;
        _358 = dot(_240, _240);
        _358 = sqrt(_358);
        float3 _368 = (_213.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _364 = float4(_368.x, _368.y, _368.z, _364.w);
        _246 = dot(_364.xyz, _364.xyz);
        _246 = rsqrt(_246);
        float3 _382 = _246.xxx * _364.xyz;
        _364 = float4(_382.x, _382.y, _382.z, _364.w);
        _246 = dot(_364.xyz, _111.xyz);
        _246 = (_246 * 0.5f) + 0.5f;
        _246 = clamp(_246, 0.0f, 1.0f);
        _364.x = _358 + _358;
        _364.x /= _229.y;
        _358 /= _229.y;
        _409 = (-_358) + 1.0f;
        _358 += 1.0f;
        _358 = _409 / _358;
        _409 = (-_358) + 1.0f;
        float2 _423 = _364.xx + float2(1.0f, 2.0f);
        _364 = float4(_423.x, _364.y, _423.y, _364.w);
        _409 = _364.z * _409;
        _246 = log2(_246);
        _246 *= _364.x;
        _246 = exp2(_246);
        _358 = (_409 * _246) + _358;
        _167.y = _358 * _229.y;
        _221.x = _213.w;
        float3 _453 = _221.xyz * 0.5f.xxx;
        _364 = float4(_453.x, _453.y, _453.z, _364.w);
        _358 = dot(_364.xyz, _364.xyz);
        _461.z = sqrt(_358);
        _101 = (_221.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _246 = dot(_101, _101);
        _246 = rsqrt(_246);
        _101 *= _246.xxx;
        _101.x = dot(_101, _111.xyz);
        _101.x = (_101.x * 0.5f) + 0.5f;
        _101.x = clamp(_101.x, 0.0f, 1.0f);
        _461.x = _461.z + _461.z;
        float2 _502 = _461.xz / _229.zz;
        _461 = float3(_502.x, _502.y, _461.z);
        _358 = (-_461.y) + 1.0f;
        _509 = _461.y + 1.0f;
        _509 = _358 / _509;
        _358 = (-_509) + 1.0f;
        float2 _521 = _461.xx + float2(1.0f, 2.0f);
        _364 = float4(_521.x, _521.y, _364.z, _364.w);
        _461.x = _358 * _364.y;
        _101.x = log2(_101.x);
        _101.x *= _364.x;
        _101.x = exp2(_101.x);
        _101.x = (_461.x * _101.x) + _509;
        _167.z = _101.x * _229.z;
        _557 = _167;
    }
    else
    {
        _557.x = 0.0f;
        _557.y = 0.0f;
        _557.z = 0.0f;
    }
    _111.w = 1.0f;
    _564.x = dot(_77_m2, _111);
    _564.y = dot(_77_m3, _111);
    _564.z = dot(_77_m4, _111);
    _221 = _111.yzzx * _111.xyzz;
    _587.x = dot(_77_m5, _221);
    _587.y = dot(_77_m6, _221);
    _587.z = dot(_77_m7, _221);
    _606 = _111.y * _111.y;
    _606 = (_111.x * _111.x) + (-_606);
    _587 = (_77_m8.xyz * _606.xxx) + _587;
    float3 _632 = _564.xyz + _587;
    _564 = float4(_632.x, _632.y, _632.z, _564.w);
    float3 _636;
    if (_140)
    {
        _636 = _557;
    }
    else
    {
        _636 = _564.xyz;
    }
    _557 = _636;
    _196 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _196 = rsqrt(_196);
    _167 = _196.xxx * vs_TEXCOORD4;
    _557 = max(_557, 0.2199999988079071044921875f.xxx);
    float3 _662 = (-vs_TEXCOORD0) + _77_m0;
    _364 = float4(_662.x, _662.y, _662.z, _364.w);
    _246 = dot(_364.xyz, _364.xyz);
    _246 = rsqrt(_246);
    _229 = _246.xxx * _364.xyz;
    _677 = dot(_77_m1.xyz, _77_m1.xyz);
    _685 = 9.9999999747524270787835121154785e-07f < _677;
    _677 = rsqrt(_677);
    _240 = _677.xxx * _77_m1.xyz;
    float3 _697;
    if (_685)
    {
        _697 = _240;
    }
    else
    {
        _697 = float3(0.0f, 1.0f, 0.0f);
    }
    _240 = _697;
    float3 _710 = (_364.xyz * _246.xxx) + _240;
    _364 = float4(_710.x, _710.y, _710.z, _364.w);
    _246 = dot(_364.xyz, _364.xyz);
    _246 = rsqrt(_246);
    float3 _724 = _246.xxx * _364.xyz;
    _364 = float4(_724.x, _724.y, _724.z, _364.w);
    _246 = dot(_111.xyz, _240);
    _246 = (_246 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _246 = clamp(_246, 0.0f, 1.0f);
    _364.x = dot(_111.xyz, _364.xyz);
    _364.x = clamp(_364.x, 0.0f, 1.0f);
    float2 _757 = (_77_m18.xx * float2(10.0f, 7.0f)) + 1.0f.xx;
    _564 = float4(_757.x, _757.y, _564.z, _564.w);
    float2 _762 = exp2(_564.xy);
    _564 = float4(_762.x, _762.y, _564.z, _564.w);
    _364.x = log2(_364.x);
    _364.x *= _564.x;
    _364.x = exp2(_364.x);
    _364.x *= _77_m19;
    _409 = dot(_111.xyz, _229);
    _409 = clamp(_409, 0.0f, 1.0f);
    _409 = (-_409) + 1.0f;
    _795 = _409 * _409;
    _795 *= _795;
    _409 = _795 * _409;
    _795 = (_409 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    float3 _813 = _795.xxx * _557;
    _564 = float4(_813.x, _564.y, _813.y, _813.z);
    float3 _821 = _564.xzw * _77_m18.xxx;
    _564 = float4(_821.x, _564.y, _821.y, _821.z);
    float3 _828 = _564.xzw * 0.300000011920928955078125f.xxx;
    _564 = float4(_828.x, _564.y, _828.y, _828.z);
    _587 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _837 = (_77_m11.xyz * _246.xxx) + _557;
    _847 = _364.xxx * _77_m11.xyz;
    _837 = (_9 * _837) + _847;
    float3 _864 = (_564.xzw * _587) + _837;
    _564 = float4(_864.x, _564.y, _864.y, _864.z);
    float3 _872 = (vs_TEXCOORD4 * _196.xxx) + _229;
    _364 = float4(_872.x, _364.y, _872.y, _872.z);
    _196 = dot(_364.xzw, _364.xzw);
    _196 = rsqrt(_196);
    float3 _886 = _196.xxx * _364.xzw;
    _364 = float4(_886.x, _364.y, _886.y, _886.z);
    _196 = dot(_111.xyz, _364.xzw);
    _196 = clamp(_196, 0.0f, 1.0f);
    _196 = log2(_196);
    _196 *= _564.y;
    _196 = exp2(_196);
    _196 *= _77_m19;
    _246 = dot(-_229, _111.xyz);
    _246 += _246;
    float3 _924 = (_111.xyz * (-_246.xxx)) + (-_229);
    _364 = float4(_924.x, _364.y, _924.y, _924.z);
    _167.x = dot(_364.xzw, _167);
    _167.x = (_167.x * 0.5f) + 0.5f;
    _167.x = clamp(_167.x, 0.0f, 1.0f);
    _167.x *= _167.x;
    _167.x *= _167.x;
    _587 = (-_557) + vs_TEXCOORD5;
    _557 = (_167.xxx * _587) + _557;
    _587 = (_9 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    float3 _977 = (vs_TEXCOORD5 * _196.xxx) + _564.xzw;
    _564 = float4(_977.x, _977.y, _977.z, _564.w);
    _557 *= _587;
    _606 = _409 * _77_m20;
    _606 *= _77_m18;
    _557 = (_557 * _606.xxx) + _564.xyz;
    _9.x = vs_TEXCOORD3;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _36 = _557 + (-_77_m10.xyz);
    _9 = (_9.xxx * _36) + _77_m10.xyz;
    _1022 = float4(_9.x, _9.y, _9.z, _1022.w);
    _1022.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _29 = stage_input._29;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1022 = _1022;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m8[4];
float4x4 unity_MatrixVP;
static float4 _21_m9[4];
float4 unity_FogParams;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _21_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m9[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m9[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m9[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m9[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m1 unity_SHAr
#define _21_m2 unity_SHAg
#define _21_m3 unity_SHAb
#define _21_m4 unity_SHBr
#define _21_m5 unity_SHBg
#define _21_m6 unity_SHBb
#define _21_m7 unity_SHC
#define _21_m10 unity_FogParams
#define _21_m11 _VolumeMin
#define _21_m12 _VolumeInvSize
#define _21_m13 _GlobalVolumeMin
#define _21_m14 _GlobalVolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD1;
static float2 _94;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float vs_TEXCOORD3;
static float3 vs_TEXCOORD0;
static float4 _798;
static float4 _799;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _799 : COLOR;
    float2 _94 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _798 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float3 vs_TEXCOORD2 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float4 _102;
static bool _143;
static float4 _174;
static float4 _195;
static float _211;
static float4 _244;
static float3 _252;
static float3 _265;
static float _288;
static bool _292;
static float _332;
static float _364;
static float3 _407;
static float _411;
static float _454;
static float _466;
static float3 _525;
static float _583;
static float3 _647;
static bool _673;
static float3 _713;
static float _732;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m8[1];
    _9 = (_21_m8[0] * _11.xxxx) + _9;
    _9 = (_21_m8[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m8[3];
    _51 = _45.yyyy * _21_m9[1];
    _51 = (_21_m9[0] * _45.xxxx) + _51;
    _51 = (_21_m9[2] * _45.zzzz) + _51;
    _45 = (_21_m9[3] * _45.wwww) + _51;
    float3 _87 = (_21_m8[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_87.x, _87.y, _87.z, _9.w);
    vs_TEXCOORD1 = (_94 * 2.0f.xx) + (-1.0f).xx;
    _102.x = dot(_21_m1.yw, 1.0f.xx);
    _102.y = dot(_21_m2.yw, 1.0f.xx);
    _102.z = dot(_21_m3.yw, 1.0f.xx);
    float3 _131 = _102.xyz + (-_21_m7.xyz);
    _102 = float4(_131.x, _131.y, _131.z, _102.w);
    vs_TEXCOORD2 = max(_102.xyz, 0.2199999988079071044921875f.xxx);
    _143 = 1000000.0f < _21_m12.x;
    float3 _152;
    if (_143)
    {
        _152 = _21_m13;
    }
    else
    {
        _152 = _21_m11;
    }
    _51 = float4(_152.x, _152.y, _152.z, _51.w);
    float3 _171 = _9.xyz + (-_51.xyz);
    _51 = float4(_171.x, _171.y, _171.z, _51.w);
    float3 _176;
    if (_143)
    {
        _176 = _21_m14;
    }
    else
    {
        _176 = _21_m12;
    }
    _174 = float4(_176.x, _176.y, _176.z, _174.w);
    float3 _192 = _51.xyz * _174.xyz;
    _51 = float4(_192.x, _192.y, _192.z, _51.w);
    _195 = _Volume0.SampleLevel(sampler_Volume0, _51.xyz, 0.0f).xywz;
    _211 = _195.y + _195.x;
    _211 = _195.w + _211;
    _143 = 9.9999997473787516355514526367188e-06f < _211;
    if (_143)
    {
        _174 = _Volume1.SampleLevel(sampler_Volume0, _51.xyz, 0.0f).yxwz;
        _51 = _Volume2.SampleLevel(sampler_Volume0, _51.xyz, 0.0f).xzwy;
        float3 _248 = max(_195.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _244 = float4(_248.x, _248.y, _248.z, _244.w);
        _252 = _174.yxw / _244.xyz;
        _252.x = dot(_252, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _265 = _51.xwy / _244.xyz;
        _252.y = dot(_265, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _195.x = _174.z;
        _195.y = _51.z;
        _265 = _195.zxy / _244.xyz;
        _252.z = dot(_265, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _288 = dot(_252, _252);
        _292 = 9.9999999392252902907785028219223e-09f < _288;
        _288 = rsqrt(_288);
        _252 = _288.xxx * _252;
        float3 _303;
        if (_292)
        {
            _303 = _252;
        }
        else
        {
            _303 = float3(0.0f, 1.0f, 0.0f);
        }
        _252 = _303;
        _195.x = _174.y;
        _195.y = _51.x;
        _265 = _195.xyz * 0.5f.xxx;
        _288 = dot(_265, _265);
        _288 = sqrt(_288);
        _265 = (_195.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _332 = dot(_265, _265);
        _332 = rsqrt(_332);
        _265 = _332.xxx * _265;
        _332 = dot(_265, _252);
        _332 = (_332 * 0.5f) + 0.5f;
        _332 = clamp(_332, 0.0f, 1.0f);
        _265.x = _288 + _288;
        _265.x /= _244.x;
        _288 /= _244.x;
        _364 = (-_288) + 1.0f;
        _288 += 1.0f;
        _288 = _364 / _288;
        _364 = (-_288) + 1.0f;
        float2 _379 = _265.xx + float2(1.0f, 2.0f);
        _265 = float3(_379.x, _265.y, _379.y);
        _364 = _265.z * _364;
        _332 = log2(_332);
        _332 *= _265.x;
        _332 = exp2(_332);
        _288 = (_364 * _332) + _288;
        _265.x = _288 * _244.x;
        _174.y = _51.w;
        _407 = _174.xyz * 0.5f.xxx;
        _411 = dot(_407, _407);
        _411 = sqrt(_411);
        float3 _420 = (_174.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _174 = float4(_420.x, _420.y, _420.z, _174.w);
        _244.x = dot(_174.xyz, _174.xyz);
        _244.x = rsqrt(_244.x);
        float3 _437 = _174.xyz * _244.xxx;
        _174 = float4(_437.x, _437.y, _437.z, _174.w);
        _174.x = dot(_174.xyz, _252);
        _174.x = (_174.x * 0.5f) + 0.5f;
        _174.x = clamp(_174.x, 0.0f, 1.0f);
        _454 = _411 + _411;
        _454 /= _244.y;
        _411 /= _244.y;
        _466 = (-_411) + 1.0f;
        _411 += 1.0f;
        _411 = _466 / _411;
        _466 = (-_411) + 1.0f;
        float2 _480 = _454.xx + float2(1.0f, 2.0f);
        _244 = float4(_480.x, _244.y, _244.z, _480.y);
        _454 = _466 * _244.w;
        _174.x = log2(_174.x);
        _174.x *= _244.x;
        _174.x = exp2(_174.x);
        _411 = (_454 * _174.x) + _411;
        _265.y = _411 * _244.y;
        _51.x = _174.w;
        float3 _517 = _51.xyz * 0.5f.xxx;
        _174 = float4(_517.x, _517.y, _517.z, _174.w);
        _411 = dot(_174.xyz, _174.xyz);
        _525.z = sqrt(_411);
        float3 _532 = (_51.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _51 = float4(_532.x, _532.y, _532.z, _51.w);
        _174.x = dot(_51.xyz, _51.xyz);
        _174.x = rsqrt(_174.x);
        float3 _549 = _51.xyz * _174.xxx;
        _51 = float4(_549.x, _549.y, _549.z, _51.w);
        _51.x = dot(_51.xyz, _252);
        _51.x = (_51.x * 0.5f) + 0.5f;
        _51.x = clamp(_51.x, 0.0f, 1.0f);
        _525.x = _525.z + _525.z;
        float2 _576 = _525.xz / _244.zz;
        _525 = float3(_576.x, _576.y, _525.z);
        _411 = (-_525.y) + 1.0f;
        _583 = _525.y + 1.0f;
        _583 = _411 / _583;
        _411 = (-_583) + 1.0f;
        float2 _595 = _525.xx + float2(1.0f, 2.0f);
        _174 = float4(_595.x, _595.y, _174.z, _174.w);
        _525.x = _411 * _174.y;
        _51.x = log2(_51.x);
        _51.x *= _174.x;
        _51.x = exp2(_51.x);
        _51.x = (_525.x * _51.x) + _583;
        _265.z = _51.x * _244.z;
        float3 _633 = max(_265, 0.0f.xxx);
        _51 = float4(_633.x, _633.y, _633.z, _51.w);
        vs_TEXCOORD5 = _51.xyz;
    }
    else
    {
        _252.x = 0.0f;
        _252.y = 1.0f;
        _252.z = 0.0f;
        vs_TEXCOORD5 = 0.0f.xxx;
    }
    if (!_143)
    {
        _647 = _21_m2.xyz * 0.715200006961822509765625f.xxx;
        _647 = (_21_m1.xyz * 0.2125999927520751953125f.xxx) + _647;
        _647 = (_21_m3.xyz * 0.072200000286102294921875f.xxx) + _647;
        _211 = dot(_647, _647);
        _673 = 9.9999999392252902907785028219223e-09f < _211;
        _211 = rsqrt(_211);
        _525 = _211.xxx * _647;
        float3 _683;
        if (_673)
        {
            _683 = _525;
        }
        else
        {
            _683 = _252;
        }
        _51 = float4(_683.x, _683.y, _683.z, _51.w);
        _51.w = 1.0f;
        _647.x = dot(_21_m1, _51);
        _647.y = dot(_21_m2, _51);
        _647.z = dot(_21_m3, _51);
        _102 = _51.yzzx * _51.xyzz;
        _713.x = dot(_21_m4, _102);
        _713.y = dot(_21_m5, _102);
        _713.z = dot(_21_m6, _102);
        _732 = _51.y * _51.y;
        _732 = (_51.x * _51.x) + (-_732);
        _713 = (_21_m7.xyz * _732.xxx) + _713;
        _647 += _713;
        vs_TEXCOORD5 = max(_647, 0.0f.xxx);
        vs_TEXCOORD4 = _51.xyz;
    }
    else
    {
        vs_TEXCOORD4 = _252;
    }
    _211 = _45.z / _21_m0.y;
    _211 = (-_211) + 1.0f;
    _211 *= _21_m0.z;
    _211 = max(_211, 0.0f);
    vs_TEXCOORD3 = (_211 * _21_m10.z) + _21_m10.w;
    gl_Position = _45;
    vs_TEXCOORD0 = _9.xyz;
    _798 = _799;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _94 = stage_input._94;
    _799 = stage_input._799;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._798 = _798;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_MatrixInvV;
static float4 _77_m9[4];
float4 unity_FogColor;
float4 _LightColor0;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _DropColor;
float4 _DropDeep;
float _Smoothness;
float _Specular;
float _Sheen;
void __unity_init()
{
    _77_m9[0] = float4(unity_MatrixInvV[0][0], unity_MatrixInvV[1][0], unity_MatrixInvV[2][0], unity_MatrixInvV[3][0]);
    _77_m9[1] = float4(unity_MatrixInvV[0][1], unity_MatrixInvV[1][1], unity_MatrixInvV[2][1], unity_MatrixInvV[3][1]);
    _77_m9[2] = float4(unity_MatrixInvV[0][2], unity_MatrixInvV[1][2], unity_MatrixInvV[2][2], unity_MatrixInvV[3][2]);
    _77_m9[3] = float4(unity_MatrixInvV[0][3], unity_MatrixInvV[1][3], unity_MatrixInvV[2][3], unity_MatrixInvV[3][3]);
}
#define _77_m0 _WorldSpaceCameraPos
#define _77_m1 _WorldSpaceLightPos0
#define _77_m2 unity_SHAr
#define _77_m3 unity_SHAg
#define _77_m4 unity_SHAb
#define _77_m5 unity_SHBr
#define _77_m6 unity_SHBg
#define _77_m7 unity_SHBb
#define _77_m8 unity_SHC
#define _77_m10 unity_FogColor
#define _77_m11 _LightColor0
#define _77_m12 _VolumeMin
#define _77_m13 _VolumeInvSize
#define _77_m14 _GlobalVolumeMin
#define _77_m15 _GlobalVolumeInvSize
#define _77_m16 _DropColor
#define _77_m17 _DropDeep
#define _77_m18 _Smoothness
#define _77_m19 _Specular
#define _77_m20 _Sheen


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float2 vs_TEXCOORD1;
static float4 _29;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD3;
static float4 _1022;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _29 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _1022 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _36;
static bool _47;
static float3 _101;
static float4 _111;
static bool _140;
static float3 _167;
static float4 _182;
static float _196;
static float4 _213;
static float4 _221;
static float3 _229;
static float3 _240;
static float _246;
static float3 _250;
static float _261;
static float _302;
static float _358;
static float4 _364;
static float _409;
static float3 _461;
static float _509;
static float3 _557;
static float4 _564;
static float3 _587;
static float _606;
static float _677;
static bool _685;
static float _795;
static float3 _837;
static float3 _847;

void frag_inner()
{
    __unity_init();
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = (-_9.x) + 1.0f;
    _26 = (-_29.w) + 1.0f;
    _36.x = ((-_26) * 0.60000002384185791015625f) + _9.x;
    _47 = _36.x < 0.0f;
    if ((int(_47) * (-1)) != 0)
    {
        discard;
    }
    _9.x = max(_9.x, 0.0f);
    _9.x = sqrt(_9.x);
    _36 = vs_TEXCOORD1.yyy * _77_m9[1].xyz;
    _36 = (_77_m9[0].xyz * vs_TEXCOORD1.xxx) + _36;
    _36 = (_77_m9[2].xyz * _9.xxx) + _36;
    _101.x = dot(_36, _36);
    _101.x = rsqrt(_101.x);
    float3 _115 = _36 * _101.xxx;
    _111 = float4(_115.x, _115.y, _115.z, _111.w);
    _36 = _77_m16.xyz + (-_77_m17.xyz);
    _9 = (_9.xxx * _36) + _77_m17.xyz;
    _9 *= _29.xyz;
    _140 = 1000000.0f < _77_m13.x;
    float3 _149;
    if (_140)
    {
        _149 = _77_m14;
    }
    else
    {
        _149 = _77_m12;
    }
    _101 = _149;
    _101 = (-_101) + vs_TEXCOORD0;
    float3 _169;
    if (_140)
    {
        _169 = _77_m15;
    }
    else
    {
        _169 = _77_m13;
    }
    _167 = _169;
    _101 *= _167;
    _182 = _Volume0.SampleLevel(sampler_Volume0, _101, 0.0f).xywz;
    _196 = _182.y + _182.x;
    _196 = _182.w + _196;
    _140 = 9.9999997473787516355514526367188e-06f < _196;
    if (_140)
    {
        _213 = _Volume1.SampleLevel(sampler_Volume0, _101, 0.0f).yxwz;
        _221 = _Volume2.SampleLevel(sampler_Volume0, _101, 0.0f).xzwy;
        _229 = max(_182.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _182.x = _213.y;
        _182.y = _221.x;
        _240 = _182.xyz * 0.5f.xxx;
        _246 = dot(_240, _240);
        _250.z = sqrt(_246);
        _167 = (_182.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _261 = dot(_167, _167);
        _261 = rsqrt(_261);
        _167 *= _261.xxx;
        _167.x = dot(_167, _111.xyz);
        _167.x = (_167.x * 0.5f) + 0.5f;
        _167.x = clamp(_167.x, 0.0f, 1.0f);
        _250.x = _250.z + _250.z;
        float2 _295 = _250.xz / _229.xx;
        _250 = float3(_295.x, _295.y, _250.z);
        _246 = (-_250.y) + 1.0f;
        _302 = _250.y + 1.0f;
        _302 = _246 / _302;
        _246 = (-_302) + 1.0f;
        float2 _316 = _250.xx + float2(1.0f, 2.0f);
        _240 = float3(_316.x, _316.y, _240.z);
        _250.x = _246 * _240.y;
        _167.x = log2(_167.x);
        _167.x *= _240.x;
        _167.x = exp2(_167.x);
        _167.x = (_250.x * _167.x) + _302;
        _167.x *= _229.x;
        _213.y = _221.w;
        _240 = _213.xyz * 0.5f.xxx;
        _358 = dot(_240, _240);
        _358 = sqrt(_358);
        float3 _368 = (_213.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _364 = float4(_368.x, _368.y, _368.z, _364.w);
        _246 = dot(_364.xyz, _364.xyz);
        _246 = rsqrt(_246);
        float3 _382 = _246.xxx * _364.xyz;
        _364 = float4(_382.x, _382.y, _382.z, _364.w);
        _246 = dot(_364.xyz, _111.xyz);
        _246 = (_246 * 0.5f) + 0.5f;
        _246 = clamp(_246, 0.0f, 1.0f);
        _364.x = _358 + _358;
        _364.x /= _229.y;
        _358 /= _229.y;
        _409 = (-_358) + 1.0f;
        _358 += 1.0f;
        _358 = _409 / _358;
        _409 = (-_358) + 1.0f;
        float2 _423 = _364.xx + float2(1.0f, 2.0f);
        _364 = float4(_423.x, _364.y, _423.y, _364.w);
        _409 = _364.z * _409;
        _246 = log2(_246);
        _246 *= _364.x;
        _246 = exp2(_246);
        _358 = (_409 * _246) + _358;
        _167.y = _358 * _229.y;
        _221.x = _213.w;
        float3 _453 = _221.xyz * 0.5f.xxx;
        _364 = float4(_453.x, _453.y, _453.z, _364.w);
        _358 = dot(_364.xyz, _364.xyz);
        _461.z = sqrt(_358);
        _101 = (_221.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _246 = dot(_101, _101);
        _246 = rsqrt(_246);
        _101 *= _246.xxx;
        _101.x = dot(_101, _111.xyz);
        _101.x = (_101.x * 0.5f) + 0.5f;
        _101.x = clamp(_101.x, 0.0f, 1.0f);
        _461.x = _461.z + _461.z;
        float2 _502 = _461.xz / _229.zz;
        _461 = float3(_502.x, _502.y, _461.z);
        _358 = (-_461.y) + 1.0f;
        _509 = _461.y + 1.0f;
        _509 = _358 / _509;
        _358 = (-_509) + 1.0f;
        float2 _521 = _461.xx + float2(1.0f, 2.0f);
        _364 = float4(_521.x, _521.y, _364.z, _364.w);
        _461.x = _358 * _364.y;
        _101.x = log2(_101.x);
        _101.x *= _364.x;
        _101.x = exp2(_101.x);
        _101.x = (_461.x * _101.x) + _509;
        _167.z = _101.x * _229.z;
        _557 = _167;
    }
    else
    {
        _557.x = 0.0f;
        _557.y = 0.0f;
        _557.z = 0.0f;
    }
    _111.w = 1.0f;
    _564.x = dot(_77_m2, _111);
    _564.y = dot(_77_m3, _111);
    _564.z = dot(_77_m4, _111);
    _221 = _111.yzzx * _111.xyzz;
    _587.x = dot(_77_m5, _221);
    _587.y = dot(_77_m6, _221);
    _587.z = dot(_77_m7, _221);
    _606 = _111.y * _111.y;
    _606 = (_111.x * _111.x) + (-_606);
    _587 = (_77_m8.xyz * _606.xxx) + _587;
    float3 _632 = _564.xyz + _587;
    _564 = float4(_632.x, _632.y, _632.z, _564.w);
    float3 _636;
    if (_140)
    {
        _636 = _557;
    }
    else
    {
        _636 = _564.xyz;
    }
    _557 = _636;
    _196 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _196 = rsqrt(_196);
    _167 = _196.xxx * vs_TEXCOORD4;
    _557 = max(_557, 0.2199999988079071044921875f.xxx);
    float3 _662 = (-vs_TEXCOORD0) + _77_m0;
    _364 = float4(_662.x, _662.y, _662.z, _364.w);
    _246 = dot(_364.xyz, _364.xyz);
    _246 = rsqrt(_246);
    _229 = _246.xxx * _364.xyz;
    _677 = dot(_77_m1.xyz, _77_m1.xyz);
    _685 = 9.9999999747524270787835121154785e-07f < _677;
    _677 = rsqrt(_677);
    _240 = _677.xxx * _77_m1.xyz;
    float3 _697;
    if (_685)
    {
        _697 = _240;
    }
    else
    {
        _697 = float3(0.0f, 1.0f, 0.0f);
    }
    _240 = _697;
    float3 _710 = (_364.xyz * _246.xxx) + _240;
    _364 = float4(_710.x, _710.y, _710.z, _364.w);
    _246 = dot(_364.xyz, _364.xyz);
    _246 = rsqrt(_246);
    float3 _724 = _246.xxx * _364.xyz;
    _364 = float4(_724.x, _724.y, _724.z, _364.w);
    _246 = dot(_111.xyz, _240);
    _246 = (_246 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _246 = clamp(_246, 0.0f, 1.0f);
    _364.x = dot(_111.xyz, _364.xyz);
    _364.x = clamp(_364.x, 0.0f, 1.0f);
    float2 _757 = (_77_m18.xx * float2(10.0f, 7.0f)) + 1.0f.xx;
    _564 = float4(_757.x, _757.y, _564.z, _564.w);
    float2 _762 = exp2(_564.xy);
    _564 = float4(_762.x, _762.y, _564.z, _564.w);
    _364.x = log2(_364.x);
    _364.x *= _564.x;
    _364.x = exp2(_364.x);
    _364.x *= _77_m19;
    _409 = dot(_111.xyz, _229);
    _409 = clamp(_409, 0.0f, 1.0f);
    _409 = (-_409) + 1.0f;
    _795 = _409 * _409;
    _795 *= _795;
    _409 = _795 * _409;
    _795 = (_409 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    float3 _813 = _795.xxx * _557;
    _564 = float4(_813.x, _564.y, _813.y, _813.z);
    float3 _821 = _564.xzw * _77_m18.xxx;
    _564 = float4(_821.x, _564.y, _821.y, _821.z);
    float3 _828 = _564.xzw * 0.300000011920928955078125f.xxx;
    _564 = float4(_828.x, _564.y, _828.y, _828.z);
    _587 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _837 = (_77_m11.xyz * _246.xxx) + _557;
    _847 = _364.xxx * _77_m11.xyz;
    _837 = (_9 * _837) + _847;
    float3 _864 = (_564.xzw * _587) + _837;
    _564 = float4(_864.x, _564.y, _864.y, _864.z);
    float3 _872 = (vs_TEXCOORD4 * _196.xxx) + _229;
    _364 = float4(_872.x, _364.y, _872.y, _872.z);
    _196 = dot(_364.xzw, _364.xzw);
    _196 = rsqrt(_196);
    float3 _886 = _196.xxx * _364.xzw;
    _364 = float4(_886.x, _364.y, _886.y, _886.z);
    _196 = dot(_111.xyz, _364.xzw);
    _196 = clamp(_196, 0.0f, 1.0f);
    _196 = log2(_196);
    _196 *= _564.y;
    _196 = exp2(_196);
    _196 *= _77_m19;
    _246 = dot(-_229, _111.xyz);
    _246 += _246;
    float3 _924 = (_111.xyz * (-_246.xxx)) + (-_229);
    _364 = float4(_924.x, _364.y, _924.y, _924.z);
    _167.x = dot(_364.xzw, _167);
    _167.x = (_167.x * 0.5f) + 0.5f;
    _167.x = clamp(_167.x, 0.0f, 1.0f);
    _167.x *= _167.x;
    _167.x *= _167.x;
    _587 = (-_557) + vs_TEXCOORD5;
    _557 = (_167.xxx * _587) + _557;
    _587 = (_9 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    float3 _977 = (vs_TEXCOORD5 * _196.xxx) + _564.xzw;
    _564 = float4(_977.x, _977.y, _977.z, _564.w);
    _557 *= _587;
    _606 = _409 * _77_m20;
    _606 *= _77_m18;
    _557 = (_557 * _606.xxx) + _564.xyz;
    _9.x = vs_TEXCOORD3;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _36 = _557 + (-_77_m10.xyz);
    _9 = (_9.xxx * _36) + _77_m10.xyz;
    _1022 = float4(_9.x, _9.y, _9.z, _1022.w);
    _1022.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _29 = stage_input._29;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._1022 = _1022;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME)
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _21_m7[4];
float4x4 unity_MatrixVP;
static float4 _21_m8[4];
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _21_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 unity_SHAr
#define _21_m1 unity_SHAg
#define _21_m2 unity_SHAb
#define _21_m3 unity_SHBr
#define _21_m4 unity_SHBg
#define _21_m5 unity_SHBb
#define _21_m6 unity_SHC
#define _21_m9 _VolumeMin
#define _21_m10 _VolumeInvSize
#define _21_m11 _GlobalVolumeMin
#define _21_m12 _GlobalVolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _11;
static float2 vs_TEXCOORD1;
static float2 _101;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD5;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD0;
static float4 _772;
static float4 _773;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _773 : COLOR;
    float2 _101 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _772 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
    float3 vs_TEXCOORD2 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float3 _110;
static bool _146;
static float _212;
static float4 _229;
static float4 _246;
static float3 _253;
static float3 _266;
static float _289;
static bool _293;
static float3 _325;
static float _337;
static float _383;
static float _438;
static float3 _532;
static float _587;
static float3 _652;
static bool _678;
static float4 _713;
static float3 _719;
static float _737;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m7[1];
    _9 = (_21_m7[0] * _11.xxxx) + _9;
    _9 = (_21_m7[2] * _11.zzzz) + _9;
    _45 = _9 + _21_m7[3];
    _51 = _45.yyyy * _21_m8[1];
    _51 = (_21_m8[0] * _45.xxxx) + _51;
    _51 = (_21_m8[2] * _45.zzzz) + _51;
    gl_Position = (_21_m8[3] * _45.wwww) + _51;
    float3 _94 = (_21_m7[3].xyz * _11.www) + _9.xyz;
    _9 = float4(_94.x, _94.y, _94.z, _9.w);
    vs_TEXCOORD1 = (_101 * 2.0f.xx) + (-1.0f).xx;
    _110.x = dot(_21_m0.yw, 1.0f.xx);
    _110.y = dot(_21_m1.yw, 1.0f.xx);
    _110.z = dot(_21_m2.yw, 1.0f.xx);
    _110 += (-_21_m6.xyz);
    vs_TEXCOORD2 = max(_110, 0.2199999988079071044921875f.xxx);
    _146 = 1000000.0f < _21_m10.x;
    float3 _155;
    if (_146)
    {
        _155 = _21_m11;
    }
    else
    {
        _155 = _21_m9;
    }
    _45 = float4(_155.x, _155.y, _155.z, _45.w);
    float3 _174 = _9.xyz + (-_45.xyz);
    _45 = float4(_174.x, _174.y, _174.z, _45.w);
    float3 _178;
    if (_146)
    {
        _178 = _21_m12;
    }
    else
    {
        _178 = _21_m10;
    }
    _51 = float4(_178.x, _178.y, _178.z, _51.w);
    float3 _194 = _45.xyz * _51.xyz;
    _45 = float4(_194.x, _194.y, _194.z, _45.w);
    _51 = _Volume0.SampleLevel(sampler_Volume0, _45.xyz, 0.0f).xywz;
    _212 = _51.y + _51.x;
    _212 = _51.w + _212;
    _146 = 9.9999997473787516355514526367188e-06f < _212;
    if (_146)
    {
        _229 = _Volume1.SampleLevel(sampler_Volume0, _45.xyz, 0.0f).yxwz;
        _45 = _Volume2.SampleLevel(sampler_Volume0, _45.xyz, 0.0f).xzwy;
        float3 _250 = max(_51.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _246 = float4(_250.x, _250.y, _250.z, _246.w);
        _253 = _229.yxw / _246.xyz;
        _253.x = dot(_253, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _266 = _45.xwy / _246.xyz;
        _253.y = dot(_266, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _51.x = _229.z;
        _51.y = _45.z;
        _266 = _51.zxy / _246.xyz;
        _253.z = dot(_266, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
        _289 = dot(_253, _253);
        _293 = 9.9999999392252902907785028219223e-09f < _289;
        _289 = rsqrt(_289);
        _253 = _289.xxx * _253;
        float3 _304;
        if (_293)
        {
            _304 = _253;
        }
        else
        {
            _304 = float3(0.0f, 1.0f, 0.0f);
        }
        _253 = _304;
        _51.x = _229.y;
        _51.y = _45.x;
        _266 = _51.xyz * 0.5f.xxx;
        _289 = dot(_266, _266);
        _325.z = sqrt(_289);
        float3 _334 = (_51.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _51 = float4(_334.x, _334.y, _334.z, _51.w);
        _337 = dot(_51.xyz, _51.xyz);
        _337 = rsqrt(_337);
        float3 _349 = _51.xyz * _337.xxx;
        _51 = float4(_349.x, _349.y, _349.z, _51.w);
        _51.x = dot(_51.xyz, _253);
        _51.x = (_51.x * 0.5f) + 0.5f;
        _51.x = clamp(_51.x, 0.0f, 1.0f);
        _325.x = _325.z + _325.z;
        float2 _376 = _325.xz / _246.xx;
        _325 = float3(_376.x, _376.y, _325.z);
        _289 = (-_325.y) + 1.0f;
        _383 = _325.y + 1.0f;
        _383 = _289 / _383;
        _289 = (-_383) + 1.0f;
        float2 _396 = _325.xx + float2(1.0f, 2.0f);
        _266 = float3(_396.x, _396.y, _266.z);
        _325.x = _289 * _266.y;
        _51.x = log2(_51.x);
        _51.x *= _266.x;
        _51.x = exp2(_51.x);
        _51.x = (_325.x * _51.x) + _383;
        _51.x *= _246.x;
        _229.y = _45.w;
        _266 = _229.xyz * 0.5f.xxx;
        _438 = dot(_266, _266);
        _438 = sqrt(_438);
        _266 = (_229.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _289 = dot(_266, _266);
        _289 = rsqrt(_289);
        _266 = _289.xxx * _266;
        _289 = dot(_266, _253);
        _289 = (_289 * 0.5f) + 0.5f;
        _289 = clamp(_289, 0.0f, 1.0f);
        _246.x = _438 + _438;
        _246.x /= _246.y;
        _438 /= _246.y;
        _337 = (-_438) + 1.0f;
        _438 += 1.0f;
        _438 = _337 / _438;
        _337 = (-_438) + 1.0f;
        float2 _492 = _246.xx + float2(1.0f, 2.0f);
        _266 = float3(_492.x, _492.y, _266.z);
        _246.x = _337 * _266.y;
        _289 = log2(_289);
        _289 *= _266.x;
        _289 = exp2(_289);
        _438 = (_246.x * _289) + _438;
        _51.y = _438 * _246.y;
        _45.x = _229.w;
        float3 _524 = _45.xyz * 0.5f.xxx;
        _246 = float4(_524.x, _524.y, _246.z, _524.z);
        _438 = dot(_246.xyw, _246.xyw);
        _532.z = sqrt(_438);
        float3 _539 = (_45.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _45 = float4(_539.x, _539.y, _539.z, _45.w);
        _289 = dot(_45.xyz, _45.xyz);
        _289 = rsqrt(_289);
        float3 _553 = _45.xyz * _289.xxx;
        _45 = float4(_553.x, _553.y, _553.z, _45.w);
        _45.x = dot(_45.xyz, _253);
        _45.x = (_45.x * 0.5f) + 0.5f;
        _45.x = clamp(_45.x, 0.0f, 1.0f);
        _532.x = _532.z + _532.z;
        float2 _580 = _532.xz / _246.zz;
        _532 = float3(_580.x, _580.y, _532.z);
        _438 = (-_532.y) + 1.0f;
        _587 = _532.y + 1.0f;
        _587 = _438 / _587;
        _438 = (-_587) + 1.0f;
        float2 _599 = _532.xx + float2(1.0f, 2.0f);
        _246 = float4(_599.x, _599.y, _246.z, _246.w);
        _532.x = _438 * _246.y;
        _45.x = log2(_45.x);
        _45.x *= _246.x;
        _45.x = exp2(_45.x);
        _45.x = (_532.x * _45.x) + _587;
        _51.z = _45.x * _246.z;
        float3 _638 = max(_51.xyz, 0.0f.xxx);
        _45 = float4(_638.x, _638.y, _638.z, _45.w);
        vs_TEXCOORD5 = _45.xyz;
    }
    else
    {
        _253.x = 0.0f;
        _253.y = 1.0f;
        _253.z = 0.0f;
        vs_TEXCOORD5 = 0.0f.xxx;
    }
    if (!_146)
    {
        _652 = _21_m1.xyz * 0.715200006961822509765625f.xxx;
        _652 = (_21_m0.xyz * 0.2125999927520751953125f.xxx) + _652;
        _652 = (_21_m2.xyz * 0.072200000286102294921875f.xxx) + _652;
        _212 = dot(_652, _652);
        _678 = 9.9999999392252902907785028219223e-09f < _212;
        _212 = rsqrt(_212);
        _532 = _212.xxx * _652;
        float3 _688;
        if (_678)
        {
            _688 = _532;
        }
        else
        {
            _688 = _253;
        }
        _45 = float4(_688.x, _688.y, _688.z, _45.w);
        _45.w = 1.0f;
        _652.x = dot(_21_m0, _45);
        _652.y = dot(_21_m1, _45);
        _652.z = dot(_21_m2, _45);
        _713 = _45.yzzx * _45.xyzz;
        _719.x = dot(_21_m3, _713);
        _719.y = dot(_21_m4, _713);
        _719.z = dot(_21_m5, _713);
        _737 = _45.y * _45.y;
        _737 = (_45.x * _45.x) + (-_737);
        _719 = (_21_m6.xyz * _737.xxx) + _719;
        _652 += _719;
        vs_TEXCOORD5 = max(_652, 0.0f.xxx);
        vs_TEXCOORD4 = _45.xyz;
    }
    else
    {
        vs_TEXCOORD4 = _253;
    }
    vs_TEXCOORD0 = _9.xyz;
    _772 = _773;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _101 = stage_input._101;
    _773 = stage_input._773;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output._772 = _772;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_MatrixInvV;
static float4 _77_m9[4];
float4 _LightColor0;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
float4 _DropColor;
float4 _DropDeep;
float _Smoothness;
float _Specular;
float _Sheen;
void __unity_init()
{
    _77_m9[0] = float4(unity_MatrixInvV[0][0], unity_MatrixInvV[1][0], unity_MatrixInvV[2][0], unity_MatrixInvV[3][0]);
    _77_m9[1] = float4(unity_MatrixInvV[0][1], unity_MatrixInvV[1][1], unity_MatrixInvV[2][1], unity_MatrixInvV[3][1]);
    _77_m9[2] = float4(unity_MatrixInvV[0][2], unity_MatrixInvV[1][2], unity_MatrixInvV[2][2], unity_MatrixInvV[3][2]);
    _77_m9[3] = float4(unity_MatrixInvV[0][3], unity_MatrixInvV[1][3], unity_MatrixInvV[2][3], unity_MatrixInvV[3][3]);
}
#define _77_m0 _WorldSpaceCameraPos
#define _77_m1 _WorldSpaceLightPos0
#define _77_m2 unity_SHAr
#define _77_m3 unity_SHAg
#define _77_m4 unity_SHAb
#define _77_m5 unity_SHBr
#define _77_m6 unity_SHBg
#define _77_m7 unity_SHBb
#define _77_m8 unity_SHC
#define _77_m10 _LightColor0
#define _77_m11 _VolumeMin
#define _77_m12 _VolumeInvSize
#define _77_m13 _GlobalVolumeMin
#define _77_m14 _GlobalVolumeInvSize
#define _77_m15 _DropColor
#define _77_m16 _DropDeep
#define _77_m17 _Smoothness
#define _77_m18 _Specular
#define _77_m19 _Sheen


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float2 vs_TEXCOORD1;
static float4 _29;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 _993;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _29 : TEXCOORD2;
    float3 vs_TEXCOORD4 : TEXCOORD3;
    float3 vs_TEXCOORD5 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _993 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _36;
static bool _47;
static float3 _101;
static float4 _111;
static bool _140;
static float3 _167;
static float4 _182;
static float _196;
static float4 _213;
static float4 _221;
static float3 _229;
static float3 _240;
static float _246;
static float3 _250;
static float _261;
static float _302;
static float _358;
static float4 _364;
static float _409;
static float3 _461;
static float _509;
static float3 _557;
static float4 _564;
static float3 _587;
static float _606;
static float _677;
static bool _685;
static float _795;
static float3 _837;
static float3 _847;

void frag_inner()
{
    __unity_init();
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = (-_9.x) + 1.0f;
    _26 = (-_29.w) + 1.0f;
    _36.x = ((-_26) * 0.60000002384185791015625f) + _9.x;
    _47 = _36.x < 0.0f;
    if ((int(_47) * (-1)) != 0)
    {
        discard;
    }
    _9.x = max(_9.x, 0.0f);
    _9.x = sqrt(_9.x);
    _36 = vs_TEXCOORD1.yyy * _77_m9[1].xyz;
    _36 = (_77_m9[0].xyz * vs_TEXCOORD1.xxx) + _36;
    _36 = (_77_m9[2].xyz * _9.xxx) + _36;
    _101.x = dot(_36, _36);
    _101.x = rsqrt(_101.x);
    float3 _115 = _36 * _101.xxx;
    _111 = float4(_115.x, _115.y, _115.z, _111.w);
    _36 = _77_m15.xyz + (-_77_m16.xyz);
    _9 = (_9.xxx * _36) + _77_m16.xyz;
    _9 *= _29.xyz;
    _140 = 1000000.0f < _77_m12.x;
    float3 _149;
    if (_140)
    {
        _149 = _77_m13;
    }
    else
    {
        _149 = _77_m11;
    }
    _101 = _149;
    _101 = (-_101) + vs_TEXCOORD0;
    float3 _169;
    if (_140)
    {
        _169 = _77_m14;
    }
    else
    {
        _169 = _77_m12;
    }
    _167 = _169;
    _101 *= _167;
    _182 = _Volume0.SampleLevel(sampler_Volume0, _101, 0.0f).xywz;
    _196 = _182.y + _182.x;
    _196 = _182.w + _196;
    _140 = 9.9999997473787516355514526367188e-06f < _196;
    if (_140)
    {
        _213 = _Volume1.SampleLevel(sampler_Volume0, _101, 0.0f).yxwz;
        _221 = _Volume2.SampleLevel(sampler_Volume0, _101, 0.0f).xzwy;
        _229 = max(_182.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _182.x = _213.y;
        _182.y = _221.x;
        _240 = _182.xyz * 0.5f.xxx;
        _246 = dot(_240, _240);
        _250.z = sqrt(_246);
        _167 = (_182.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _261 = dot(_167, _167);
        _261 = rsqrt(_261);
        _167 *= _261.xxx;
        _167.x = dot(_167, _111.xyz);
        _167.x = (_167.x * 0.5f) + 0.5f;
        _167.x = clamp(_167.x, 0.0f, 1.0f);
        _250.x = _250.z + _250.z;
        float2 _295 = _250.xz / _229.xx;
        _250 = float3(_295.x, _295.y, _250.z);
        _246 = (-_250.y) + 1.0f;
        _302 = _250.y + 1.0f;
        _302 = _246 / _302;
        _246 = (-_302) + 1.0f;
        float2 _316 = _250.xx + float2(1.0f, 2.0f);
        _240 = float3(_316.x, _316.y, _240.z);
        _250.x = _246 * _240.y;
        _167.x = log2(_167.x);
        _167.x *= _240.x;
        _167.x = exp2(_167.x);
        _167.x = (_250.x * _167.x) + _302;
        _167.x *= _229.x;
        _213.y = _221.w;
        _240 = _213.xyz * 0.5f.xxx;
        _358 = dot(_240, _240);
        _358 = sqrt(_358);
        float3 _368 = (_213.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _364 = float4(_368.x, _368.y, _368.z, _364.w);
        _246 = dot(_364.xyz, _364.xyz);
        _246 = rsqrt(_246);
        float3 _382 = _246.xxx * _364.xyz;
        _364 = float4(_382.x, _382.y, _382.z, _364.w);
        _246 = dot(_364.xyz, _111.xyz);
        _246 = (_246 * 0.5f) + 0.5f;
        _246 = clamp(_246, 0.0f, 1.0f);
        _364.x = _358 + _358;
        _364.x /= _229.y;
        _358 /= _229.y;
        _409 = (-_358) + 1.0f;
        _358 += 1.0f;
        _358 = _409 / _358;
        _409 = (-_358) + 1.0f;
        float2 _423 = _364.xx + float2(1.0f, 2.0f);
        _364 = float4(_423.x, _364.y, _423.y, _364.w);
        _409 = _364.z * _409;
        _246 = log2(_246);
        _246 *= _364.x;
        _246 = exp2(_246);
        _358 = (_409 * _246) + _358;
        _167.y = _358 * _229.y;
        _221.x = _213.w;
        float3 _453 = _221.xyz * 0.5f.xxx;
        _364 = float4(_453.x, _453.y, _453.z, _364.w);
        _358 = dot(_364.xyz, _364.xyz);
        _461.z = sqrt(_358);
        _101 = (_221.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _246 = dot(_101, _101);
        _246 = rsqrt(_246);
        _101 *= _246.xxx;
        _101.x = dot(_101, _111.xyz);
        _101.x = (_101.x * 0.5f) + 0.5f;
        _101.x = clamp(_101.x, 0.0f, 1.0f);
        _461.x = _461.z + _461.z;
        float2 _502 = _461.xz / _229.zz;
        _461 = float3(_502.x, _502.y, _461.z);
        _358 = (-_461.y) + 1.0f;
        _509 = _461.y + 1.0f;
        _509 = _358 / _509;
        _358 = (-_509) + 1.0f;
        float2 _521 = _461.xx + float2(1.0f, 2.0f);
        _364 = float4(_521.x, _521.y, _364.z, _364.w);
        _461.x = _358 * _364.y;
        _101.x = log2(_101.x);
        _101.x *= _364.x;
        _101.x = exp2(_101.x);
        _101.x = (_461.x * _101.x) + _509;
        _167.z = _101.x * _229.z;
        _557 = _167;
    }
    else
    {
        _557.x = 0.0f;
        _557.y = 0.0f;
        _557.z = 0.0f;
    }
    _111.w = 1.0f;
    _564.x = dot(_77_m2, _111);
    _564.y = dot(_77_m3, _111);
    _564.z = dot(_77_m4, _111);
    _221 = _111.yzzx * _111.xyzz;
    _587.x = dot(_77_m5, _221);
    _587.y = dot(_77_m6, _221);
    _587.z = dot(_77_m7, _221);
    _606 = _111.y * _111.y;
    _606 = (_111.x * _111.x) + (-_606);
    _587 = (_77_m8.xyz * _606.xxx) + _587;
    float3 _632 = _564.xyz + _587;
    _564 = float4(_632.x, _632.y, _632.z, _564.w);
    float3 _636;
    if (_140)
    {
        _636 = _557;
    }
    else
    {
        _636 = _564.xyz;
    }
    _557 = _636;
    _196 = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _196 = rsqrt(_196);
    _167 = _196.xxx * vs_TEXCOORD4;
    _557 = max(_557, 0.2199999988079071044921875f.xxx);
    float3 _662 = (-vs_TEXCOORD0) + _77_m0;
    _364 = float4(_662.x, _662.y, _662.z, _364.w);
    _246 = dot(_364.xyz, _364.xyz);
    _246 = rsqrt(_246);
    _229 = _246.xxx * _364.xyz;
    _677 = dot(_77_m1.xyz, _77_m1.xyz);
    _685 = 9.9999999747524270787835121154785e-07f < _677;
    _677 = rsqrt(_677);
    _240 = _677.xxx * _77_m1.xyz;
    float3 _697;
    if (_685)
    {
        _697 = _240;
    }
    else
    {
        _697 = float3(0.0f, 1.0f, 0.0f);
    }
    _240 = _697;
    float3 _710 = (_364.xyz * _246.xxx) + _240;
    _364 = float4(_710.x, _710.y, _710.z, _364.w);
    _246 = dot(_364.xyz, _364.xyz);
    _246 = rsqrt(_246);
    float3 _724 = _246.xxx * _364.xyz;
    _364 = float4(_724.x, _724.y, _724.z, _364.w);
    _246 = dot(_111.xyz, _240);
    _246 = (_246 * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _246 = clamp(_246, 0.0f, 1.0f);
    _364.x = dot(_111.xyz, _364.xyz);
    _364.x = clamp(_364.x, 0.0f, 1.0f);
    float2 _757 = (_77_m17.xx * float2(10.0f, 7.0f)) + 1.0f.xx;
    _564 = float4(_757.x, _757.y, _564.z, _564.w);
    float2 _762 = exp2(_564.xy);
    _564 = float4(_762.x, _762.y, _564.z, _564.w);
    _364.x = log2(_364.x);
    _364.x *= _564.x;
    _364.x = exp2(_364.x);
    _364.x *= _77_m18;
    _409 = dot(_111.xyz, _229);
    _409 = clamp(_409, 0.0f, 1.0f);
    _409 = (-_409) + 1.0f;
    _795 = _409 * _409;
    _795 *= _795;
    _409 = _795 * _409;
    _795 = (_409 * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    float3 _813 = _795.xxx * _557;
    _564 = float4(_813.x, _564.y, _813.y, _813.z);
    float3 _821 = _564.xzw * _77_m17.xxx;
    _564 = float4(_821.x, _564.y, _821.y, _821.z);
    float3 _828 = _564.xzw * 0.300000011920928955078125f.xxx;
    _564 = float4(_828.x, _564.y, _828.y, _828.z);
    _587 = (_9 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _837 = (_77_m10.xyz * _246.xxx) + _557;
    _847 = _364.xxx * _77_m10.xyz;
    _837 = (_9 * _837) + _847;
    float3 _864 = (_564.xzw * _587) + _837;
    _564 = float4(_864.x, _564.y, _864.y, _864.z);
    float3 _872 = (vs_TEXCOORD4 * _196.xxx) + _229;
    _364 = float4(_872.x, _364.y, _872.y, _872.z);
    _196 = dot(_364.xzw, _364.xzw);
    _196 = rsqrt(_196);
    float3 _886 = _196.xxx * _364.xzw;
    _364 = float4(_886.x, _364.y, _886.y, _886.z);
    _196 = dot(_111.xyz, _364.xzw);
    _196 = clamp(_196, 0.0f, 1.0f);
    _196 = log2(_196);
    _196 *= _564.y;
    _196 = exp2(_196);
    _196 *= _77_m18;
    _246 = dot(-_229, _111.xyz);
    _246 += _246;
    float3 _924 = (_111.xyz * (-_246.xxx)) + (-_229);
    _364 = float4(_924.x, _364.y, _924.y, _924.z);
    _167.x = dot(_364.xzw, _167);
    _167.x = (_167.x * 0.5f) + 0.5f;
    _167.x = clamp(_167.x, 0.0f, 1.0f);
    _167.x *= _167.x;
    _167.x *= _167.x;
    _587 = (-_557) + vs_TEXCOORD5;
    _557 = (_167.xxx * _587) + _557;
    _587 = (_9 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    float3 _977 = (vs_TEXCOORD5 * _196.xxx) + _564.xzw;
    _564 = float4(_977.x, _977.y, _977.z, _564.w);
    _557 *= _587;
    _606 = _409 * _77_m19;
    _606 *= _77_m17;
    float3 _1000 = (_557 * _606.xxx) + _564.xyz;
    _993 = float4(_1000.x, _1000.y, _1000.z, _993.w);
    _993.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    _29 = stage_input._29;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._993 = _993;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _20_m8[4];
float4x4 unity_MatrixVP;
static float4 _20_m9[4];
float4 unity_FogParams;
void __unity_init()
{
    _20_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m9[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m9[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m9[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m9[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m1 unity_SHAr
#define _20_m2 unity_SHAg
#define _20_m3 unity_SHAb
#define _20_m4 unity_SHBr
#define _20_m5 unity_SHBg
#define _20_m6 unity_SHBb
#define _20_m7 unity_SHC
#define _20_m10 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD1;
static float2 _141;
static float4 _149;
static float4 _150;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _150 : COLOR;
    float2 _141 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _149 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float3 _153;
static float3 _208;
static bool _215;
static float4 _254;
static float3 _260;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m8[1];
    _9 = (_20_m8[0] * _11.xxxx) + _9;
    _9 = (_20_m8[2] * _11.zzzz) + _9;
    _44 = _9 + _20_m8[3];
    vs_TEXCOORD0 = (_20_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _20_m9[1];
    _9 = (_20_m9[0] * _44.xxxx) + _9;
    _9 = (_20_m9[2] * _44.zzzz) + _9;
    _9 = (_20_m9[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m10.y;
    vs_TEXCOORD3 = exp2(-_9.x);
    vs_TEXCOORD1 = (_141 * 2.0f.xx) + (-1.0f).xx;
    _149 = _150;
    _153.x = dot(_20_m1.yw, 1.0f.xx);
    _153.y = dot(_20_m2.yw, 1.0f.xx);
    _153.z = dot(_20_m3.yw, 1.0f.xx);
    _153 += (-_20_m7.xyz);
    vs_TEXCOORD2 = max(_153, 0.2199999988079071044921875f.xxx);
    _153 = _20_m2.xyz * 0.715200006961822509765625f.xxx;
    _153 = (_20_m1.xyz * 0.2125999927520751953125f.xxx) + _153;
    _153 = (_20_m3.xyz * 0.072200000286102294921875f.xxx) + _153;
    _9.x = dot(_153, _153);
    _208.x = rsqrt(_9.x);
    _215 = 9.9999999392252902907785028219223e-09f < _9.x;
    _208 = _208.xxx * _153;
    float3 _226;
    if (_215)
    {
        _226 = _208;
    }
    else
    {
        _226 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_226.x, _226.y, _226.z, _9.w);
    vs_TEXCOORD4 = _9.xyz;
    _153.x = _9.y * _9.y;
    _153.x = (_9.x * _9.x) + (-_153.x);
    _254 = _9.yzzx * _9.xyzz;
    _260.x = dot(_20_m4, _254);
    _260.y = dot(_20_m5, _254);
    _260.z = dot(_20_m6, _254);
    _153 = (_20_m7.xyz * _153.xxx) + _260;
    _9.w = 1.0f;
    _260.x = dot(_20_m1, _9);
    _260.y = dot(_20_m2, _9);
    _260.z = dot(_20_m3, _9);
    _153 += _260;
    vs_TEXCOORD5 = max(_153, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _141 = stage_input._141;
    _150 = stage_input._150;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._149 = _149;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_MatrixInvV;
static float4 _78_m2[4];
float4 unity_FogColor;
float4 _LightColor0;
float4 _DropColor;
float4 _DropDeep;
float _Smoothness;
float _Specular;
float _Sheen;
void __unity_init()
{
    _78_m2[0] = float4(unity_MatrixInvV[0][0], unity_MatrixInvV[1][0], unity_MatrixInvV[2][0], unity_MatrixInvV[3][0]);
    _78_m2[1] = float4(unity_MatrixInvV[0][1], unity_MatrixInvV[1][1], unity_MatrixInvV[2][1], unity_MatrixInvV[3][1]);
    _78_m2[2] = float4(unity_MatrixInvV[0][2], unity_MatrixInvV[1][2], unity_MatrixInvV[2][2], unity_MatrixInvV[3][2]);
    _78_m2[3] = float4(unity_MatrixInvV[0][3], unity_MatrixInvV[1][3], unity_MatrixInvV[2][3], unity_MatrixInvV[3][3]);
}
#define _78_m0 _WorldSpaceCameraPos
#define _78_m1 _WorldSpaceLightPos0
#define _78_m3 unity_FogColor
#define _78_m4 _LightColor0
#define _78_m5 _DropColor
#define _78_m6 _DropDeep
#define _78_m7 _Smoothness
#define _78_m8 _Specular
#define _78_m9 _Sheen



static float4 _11;
static float2 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD3;
static float4 _529;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _11 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _529 : SV_Target0;
};

static float4 _9;
static float3 _25;
static float3 _38;
static bool _59;
static float _88;
static float3 _96;
static float _120;
static float3 _126;
static float3 _146;
static float3 _261;
static float3 _267;
static float3 _291;
static float _337;
static float3 _348;
static float _515;

void frag_inner()
{
    __unity_init();
    _9.x = (-_11.w) + 1.0f;
    _25.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _25.x = (-_25.x) + 1.0f;
    _38.x = ((-_9.x) * 0.60000002384185791015625f) + _25.x;
    _25.x = max(_25.x, 0.0f);
    _25.x = sqrt(_25.x);
    _59 = _38.x < 0.0f;
    if ((int(_59) * (-1)) != 0)
    {
        discard;
    }
    _38.x = dot(_78_m1.xyz, _78_m1.xyz);
    _88 = rsqrt(_38.x);
    _59 = 9.9999999747524270787835121154785e-07f < _38.x;
    _96 = _88.xxx * _78_m1.xyz;
    float3 _105;
    if (_59)
    {
        _105 = _96;
    }
    else
    {
        _105 = float3(0.0f, 1.0f, 0.0f);
    }
    _38 = _105;
    _96 = (-vs_TEXCOORD0) + _78_m0;
    _120 = dot(_96, _96);
    _120 = rsqrt(_120);
    _126 = (_96 * _120.xxx) + _38;
    _96 = _120.xxx * _96;
    _120 = dot(_126, _126);
    _120 = rsqrt(_120);
    _126 = _120.xxx * _126;
    _146 = vs_TEXCOORD1.yyy * _78_m2[1].xyz;
    _146 = (_78_m2[0].xyz * vs_TEXCOORD1.xxx) + _146;
    _146 = (_78_m2[2].xyz * _25.xxx) + _146;
    _120 = dot(_146, _146);
    _120 = rsqrt(_120);
    _146 = _120.xxx * _146;
    _120 = dot(_146, _126);
    _120 = clamp(_120, 0.0f, 1.0f);
    _120 = log2(_120);
    float2 _196 = (_78_m7.xx * float2(10.0f, 7.0f)) + 1.0f.xx;
    _9 = float4(_196.x, _196.y, _9.z, _9.w);
    float2 _201 = exp2(_9.xy);
    _9 = float4(_201.x, _201.y, _9.z, _9.w);
    _120 *= _9.x;
    _120 = exp2(_120);
    _120 *= _78_m8;
    float3 _221 = _120.xxx * _78_m4.xyz;
    _9 = float4(_221.x, _9.y, _221.y, _221.z);
    _126 = _78_m5.xyz + (-_78_m6.xyz);
    _126 = (_25.xxx * _126) + _78_m6.xyz;
    _126 *= _11.xyz;
    _25.x = dot(_146, _38);
    _25.x = (_25.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _261 = max(vs_TEXCOORD2, 0.2199999988079071044921875f.xxx);
    _267 = (_78_m4.xyz * _25.xxx) + _261;
    float3 _281 = (_126 * _267) + _9.xzw;
    _9 = float4(_281.x, _9.y, _281.y, _281.z);
    _267 = (_126 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _291 = (_126 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _25.x = dot(_146, _96);
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = (-_25.x) + 1.0f;
    _38.x = _25.x * _25.x;
    _38.x *= _38.x;
    _25.x = _38.x * _25.x;
    _38.x = (_25.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _337 = _25.x * _78_m9;
    _337 *= _78_m7;
    _348 = _38.xxx * _261;
    _348 *= _78_m7.xxx;
    _348 *= 0.300000011920928955078125f.xxx;
    float3 _367 = (_348 * _267) + _9.xzw;
    _9 = float4(_367.x, _9.y, _367.y, _367.z);
    _25.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _25.x = rsqrt(_25.x);
    _38 = (vs_TEXCOORD4 * _25.xxx) + _96;
    _126 = _25.xxx * vs_TEXCOORD4;
    _25.x = dot(_38, _38);
    _25.x = rsqrt(_25.x);
    _25 = _25.xxx * _38;
    _25.x = dot(_146, _25);
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = log2(_25.x);
    _25.x = _9.y * _25.x;
    _25.x = exp2(_25.x);
    _25.x *= _78_m8;
    float3 _437 = (vs_TEXCOORD5 * _25.xxx) + _9.xzw;
    _9 = float4(_437.x, _437.y, _437.z, _9.w);
    _25.x = dot(-_96, _146);
    _25.x += _25.x;
    _25 = (_146 * (-_25.xxx)) + (-_96);
    _25.x = dot(_25, _126);
    _25.x = (_25.x * 0.5f) + 0.5f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x *= _25.x;
    _25.x *= _25.x;
    _267 = (-_261) + vs_TEXCOORD5;
    _261 = (_25.xxx * _267) + _261;
    _261 = _291 * _261;
    float3 _504 = (_261 * _337.xxx) + _9.xyz;
    _9 = float4(_504.x, _504.y, _504.z, _9.w);
    _25 = _9.xyz + (-_78_m3.xyz);
    _515 = vs_TEXCOORD3;
    _515 = clamp(_515, 0.0f, 1.0f);
    _25 = (_515.xxx * _25) + _78_m3.xyz;
    _529 = float4(_25.x, _25.y, _25.z, _529.w);
    _529.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._529 = _529;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _20_m8[4];
float4x4 unity_MatrixVP;
static float4 _20_m9[4];
float4 unity_FogParams;
void __unity_init()
{
    _20_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m9[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m9[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m9[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m9[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m1 unity_SHAr
#define _20_m2 unity_SHAg
#define _20_m3 unity_SHAb
#define _20_m4 unity_SHBr
#define _20_m5 unity_SHBg
#define _20_m6 unity_SHBb
#define _20_m7 unity_SHC
#define _20_m10 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD1;
static float2 _147;
static float4 _155;
static float4 _156;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _156 : COLOR;
    float2 _147 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _155 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float3 _159;
static float3 _214;
static bool _221;
static float4 _260;
static float3 _266;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m8[1];
    _9 = (_20_m8[0] * _11.xxxx) + _9;
    _9 = (_20_m8[2] * _11.zzzz) + _9;
    _44 = _9 + _20_m8[3];
    vs_TEXCOORD0 = (_20_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _20_m9[1];
    _9 = (_20_m9[0] * _44.xxxx) + _9;
    _9 = (_20_m9[2] * _44.zzzz) + _9;
    _9 = (_20_m9[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _20_m10.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD3 = exp2(_9.x);
    vs_TEXCOORD1 = (_147 * 2.0f.xx) + (-1.0f).xx;
    _155 = _156;
    _159.x = dot(_20_m1.yw, 1.0f.xx);
    _159.y = dot(_20_m2.yw, 1.0f.xx);
    _159.z = dot(_20_m3.yw, 1.0f.xx);
    _159 += (-_20_m7.xyz);
    vs_TEXCOORD2 = max(_159, 0.2199999988079071044921875f.xxx);
    _159 = _20_m2.xyz * 0.715200006961822509765625f.xxx;
    _159 = (_20_m1.xyz * 0.2125999927520751953125f.xxx) + _159;
    _159 = (_20_m3.xyz * 0.072200000286102294921875f.xxx) + _159;
    _9.x = dot(_159, _159);
    _214.x = rsqrt(_9.x);
    _221 = 9.9999999392252902907785028219223e-09f < _9.x;
    _214 = _214.xxx * _159;
    float3 _232;
    if (_221)
    {
        _232 = _214;
    }
    else
    {
        _232 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_232.x, _232.y, _232.z, _9.w);
    vs_TEXCOORD4 = _9.xyz;
    _159.x = _9.y * _9.y;
    _159.x = (_9.x * _9.x) + (-_159.x);
    _260 = _9.yzzx * _9.xyzz;
    _266.x = dot(_20_m4, _260);
    _266.y = dot(_20_m5, _260);
    _266.z = dot(_20_m6, _260);
    _159 = (_20_m7.xyz * _159.xxx) + _266;
    _9.w = 1.0f;
    _266.x = dot(_20_m1, _9);
    _266.y = dot(_20_m2, _9);
    _266.z = dot(_20_m3, _9);
    _159 += _266;
    vs_TEXCOORD5 = max(_159, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _147 = stage_input._147;
    _156 = stage_input._156;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._155 = _155;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_MatrixInvV;
static float4 _78_m2[4];
float4 unity_FogColor;
float4 _LightColor0;
float4 _DropColor;
float4 _DropDeep;
float _Smoothness;
float _Specular;
float _Sheen;
void __unity_init()
{
    _78_m2[0] = float4(unity_MatrixInvV[0][0], unity_MatrixInvV[1][0], unity_MatrixInvV[2][0], unity_MatrixInvV[3][0]);
    _78_m2[1] = float4(unity_MatrixInvV[0][1], unity_MatrixInvV[1][1], unity_MatrixInvV[2][1], unity_MatrixInvV[3][1]);
    _78_m2[2] = float4(unity_MatrixInvV[0][2], unity_MatrixInvV[1][2], unity_MatrixInvV[2][2], unity_MatrixInvV[3][2]);
    _78_m2[3] = float4(unity_MatrixInvV[0][3], unity_MatrixInvV[1][3], unity_MatrixInvV[2][3], unity_MatrixInvV[3][3]);
}
#define _78_m0 _WorldSpaceCameraPos
#define _78_m1 _WorldSpaceLightPos0
#define _78_m3 unity_FogColor
#define _78_m4 _LightColor0
#define _78_m5 _DropColor
#define _78_m6 _DropDeep
#define _78_m7 _Smoothness
#define _78_m8 _Specular
#define _78_m9 _Sheen



static float4 _11;
static float2 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD3;
static float4 _529;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _11 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _529 : SV_Target0;
};

static float4 _9;
static float3 _25;
static float3 _38;
static bool _59;
static float _88;
static float3 _96;
static float _120;
static float3 _126;
static float3 _146;
static float3 _261;
static float3 _267;
static float3 _291;
static float _337;
static float3 _348;
static float _515;

void frag_inner()
{
    __unity_init();
    _9.x = (-_11.w) + 1.0f;
    _25.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _25.x = (-_25.x) + 1.0f;
    _38.x = ((-_9.x) * 0.60000002384185791015625f) + _25.x;
    _25.x = max(_25.x, 0.0f);
    _25.x = sqrt(_25.x);
    _59 = _38.x < 0.0f;
    if ((int(_59) * (-1)) != 0)
    {
        discard;
    }
    _38.x = dot(_78_m1.xyz, _78_m1.xyz);
    _88 = rsqrt(_38.x);
    _59 = 9.9999999747524270787835121154785e-07f < _38.x;
    _96 = _88.xxx * _78_m1.xyz;
    float3 _105;
    if (_59)
    {
        _105 = _96;
    }
    else
    {
        _105 = float3(0.0f, 1.0f, 0.0f);
    }
    _38 = _105;
    _96 = (-vs_TEXCOORD0) + _78_m0;
    _120 = dot(_96, _96);
    _120 = rsqrt(_120);
    _126 = (_96 * _120.xxx) + _38;
    _96 = _120.xxx * _96;
    _120 = dot(_126, _126);
    _120 = rsqrt(_120);
    _126 = _120.xxx * _126;
    _146 = vs_TEXCOORD1.yyy * _78_m2[1].xyz;
    _146 = (_78_m2[0].xyz * vs_TEXCOORD1.xxx) + _146;
    _146 = (_78_m2[2].xyz * _25.xxx) + _146;
    _120 = dot(_146, _146);
    _120 = rsqrt(_120);
    _146 = _120.xxx * _146;
    _120 = dot(_146, _126);
    _120 = clamp(_120, 0.0f, 1.0f);
    _120 = log2(_120);
    float2 _196 = (_78_m7.xx * float2(10.0f, 7.0f)) + 1.0f.xx;
    _9 = float4(_196.x, _196.y, _9.z, _9.w);
    float2 _201 = exp2(_9.xy);
    _9 = float4(_201.x, _201.y, _9.z, _9.w);
    _120 *= _9.x;
    _120 = exp2(_120);
    _120 *= _78_m8;
    float3 _221 = _120.xxx * _78_m4.xyz;
    _9 = float4(_221.x, _9.y, _221.y, _221.z);
    _126 = _78_m5.xyz + (-_78_m6.xyz);
    _126 = (_25.xxx * _126) + _78_m6.xyz;
    _126 *= _11.xyz;
    _25.x = dot(_146, _38);
    _25.x = (_25.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _261 = max(vs_TEXCOORD2, 0.2199999988079071044921875f.xxx);
    _267 = (_78_m4.xyz * _25.xxx) + _261;
    float3 _281 = (_126 * _267) + _9.xzw;
    _9 = float4(_281.x, _9.y, _281.y, _281.z);
    _267 = (_126 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _291 = (_126 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _25.x = dot(_146, _96);
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = (-_25.x) + 1.0f;
    _38.x = _25.x * _25.x;
    _38.x *= _38.x;
    _25.x = _38.x * _25.x;
    _38.x = (_25.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _337 = _25.x * _78_m9;
    _337 *= _78_m7;
    _348 = _38.xxx * _261;
    _348 *= _78_m7.xxx;
    _348 *= 0.300000011920928955078125f.xxx;
    float3 _367 = (_348 * _267) + _9.xzw;
    _9 = float4(_367.x, _9.y, _367.y, _367.z);
    _25.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _25.x = rsqrt(_25.x);
    _38 = (vs_TEXCOORD4 * _25.xxx) + _96;
    _126 = _25.xxx * vs_TEXCOORD4;
    _25.x = dot(_38, _38);
    _25.x = rsqrt(_25.x);
    _25 = _25.xxx * _38;
    _25.x = dot(_146, _25);
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = log2(_25.x);
    _25.x = _9.y * _25.x;
    _25.x = exp2(_25.x);
    _25.x *= _78_m8;
    float3 _437 = (vs_TEXCOORD5 * _25.xxx) + _9.xzw;
    _9 = float4(_437.x, _437.y, _437.z, _9.w);
    _25.x = dot(-_96, _146);
    _25.x += _25.x;
    _25 = (_146 * (-_25.xxx)) + (-_96);
    _25.x = dot(_25, _126);
    _25.x = (_25.x * 0.5f) + 0.5f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x *= _25.x;
    _25.x *= _25.x;
    _267 = (-_261) + vs_TEXCOORD5;
    _261 = (_25.xxx * _267) + _261;
    _261 = _291 * _261;
    float3 _504 = (_261 * _337.xxx) + _9.xyz;
    _9 = float4(_504.x, _504.y, _504.z, _9.w);
    _25 = _9.xyz + (-_78_m3.xyz);
    _515 = vs_TEXCOORD3;
    _515 = clamp(_515, 0.0f, 1.0f);
    _25 = (_515.xxx * _25) + _78_m3.xyz;
    _529 = float4(_25.x, _25.y, _25.z, _529.w);
    _529.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._529 = _529;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _20_m8[4];
float4x4 unity_MatrixVP;
static float4 _20_m9[4];
float4 unity_FogParams;
void __unity_init()
{
    _20_m8[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m8[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m8[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m8[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m9[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m9[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m9[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m9[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 _ProjectionParams
#define _20_m1 unity_SHAr
#define _20_m2 unity_SHAg
#define _20_m3 unity_SHAb
#define _20_m4 unity_SHBr
#define _20_m5 unity_SHBg
#define _20_m6 unity_SHBb
#define _20_m7 unity_SHC
#define _20_m10 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD3;
static float2 vs_TEXCOORD1;
static float2 _140;
static float4 _148;
static float4 _149;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _149 : COLOR;
    float2 _140 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _148 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float3 _152;
static float3 _207;
static bool _214;
static float4 _253;
static float3 _259;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m8[1];
    _9 = (_20_m8[0] * _11.xxxx) + _9;
    _9 = (_20_m8[2] * _11.zzzz) + _9;
    _44 = _9 + _20_m8[3];
    vs_TEXCOORD0 = (_20_m8[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _20_m9[1];
    _9 = (_20_m9[0] * _44.xxxx) + _9;
    _9 = (_20_m9[2] * _44.zzzz) + _9;
    _9 = (_20_m9[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _20_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _20_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD3 = (_9.x * _20_m10.z) + _20_m10.w;
    vs_TEXCOORD1 = (_140 * 2.0f.xx) + (-1.0f).xx;
    _148 = _149;
    _152.x = dot(_20_m1.yw, 1.0f.xx);
    _152.y = dot(_20_m2.yw, 1.0f.xx);
    _152.z = dot(_20_m3.yw, 1.0f.xx);
    _152 += (-_20_m7.xyz);
    vs_TEXCOORD2 = max(_152, 0.2199999988079071044921875f.xxx);
    _152 = _20_m2.xyz * 0.715200006961822509765625f.xxx;
    _152 = (_20_m1.xyz * 0.2125999927520751953125f.xxx) + _152;
    _152 = (_20_m3.xyz * 0.072200000286102294921875f.xxx) + _152;
    _9.x = dot(_152, _152);
    _207.x = rsqrt(_9.x);
    _214 = 9.9999999392252902907785028219223e-09f < _9.x;
    _207 = _207.xxx * _152;
    float3 _225;
    if (_214)
    {
        _225 = _207;
    }
    else
    {
        _225 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_225.x, _225.y, _225.z, _9.w);
    vs_TEXCOORD4 = _9.xyz;
    _152.x = _9.y * _9.y;
    _152.x = (_9.x * _9.x) + (-_152.x);
    _253 = _9.yzzx * _9.xyzz;
    _259.x = dot(_20_m4, _253);
    _259.y = dot(_20_m5, _253);
    _259.z = dot(_20_m6, _253);
    _152 = (_20_m7.xyz * _152.xxx) + _259;
    _9.w = 1.0f;
    _259.x = dot(_20_m1, _9);
    _259.y = dot(_20_m2, _9);
    _259.z = dot(_20_m3, _9);
    _152 += _259;
    vs_TEXCOORD5 = max(_152, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _149 = stage_input._149;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._148 = _148;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_MatrixInvV;
static float4 _78_m2[4];
float4 unity_FogColor;
float4 _LightColor0;
float4 _DropColor;
float4 _DropDeep;
float _Smoothness;
float _Specular;
float _Sheen;
void __unity_init()
{
    _78_m2[0] = float4(unity_MatrixInvV[0][0], unity_MatrixInvV[1][0], unity_MatrixInvV[2][0], unity_MatrixInvV[3][0]);
    _78_m2[1] = float4(unity_MatrixInvV[0][1], unity_MatrixInvV[1][1], unity_MatrixInvV[2][1], unity_MatrixInvV[3][1]);
    _78_m2[2] = float4(unity_MatrixInvV[0][2], unity_MatrixInvV[1][2], unity_MatrixInvV[2][2], unity_MatrixInvV[3][2]);
    _78_m2[3] = float4(unity_MatrixInvV[0][3], unity_MatrixInvV[1][3], unity_MatrixInvV[2][3], unity_MatrixInvV[3][3]);
}
#define _78_m0 _WorldSpaceCameraPos
#define _78_m1 _WorldSpaceLightPos0
#define _78_m3 unity_FogColor
#define _78_m4 _LightColor0
#define _78_m5 _DropColor
#define _78_m6 _DropDeep
#define _78_m7 _Smoothness
#define _78_m8 _Specular
#define _78_m9 _Sheen



static float4 _11;
static float2 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float vs_TEXCOORD3;
static float4 _529;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float vs_TEXCOORD3 : TEXCOORD2;
    float4 _11 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD4 : TEXCOORD5;
    float3 vs_TEXCOORD5 : TEXCOORD6;
};

struct SPIRV_Cross_Output
{
    float4 _529 : SV_Target0;
};

static float4 _9;
static float3 _25;
static float3 _38;
static bool _59;
static float _88;
static float3 _96;
static float _120;
static float3 _126;
static float3 _146;
static float3 _261;
static float3 _267;
static float3 _291;
static float _337;
static float3 _348;
static float _515;

void frag_inner()
{
    __unity_init();
    _9.x = (-_11.w) + 1.0f;
    _25.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _25.x = (-_25.x) + 1.0f;
    _38.x = ((-_9.x) * 0.60000002384185791015625f) + _25.x;
    _25.x = max(_25.x, 0.0f);
    _25.x = sqrt(_25.x);
    _59 = _38.x < 0.0f;
    if ((int(_59) * (-1)) != 0)
    {
        discard;
    }
    _38.x = dot(_78_m1.xyz, _78_m1.xyz);
    _88 = rsqrt(_38.x);
    _59 = 9.9999999747524270787835121154785e-07f < _38.x;
    _96 = _88.xxx * _78_m1.xyz;
    float3 _105;
    if (_59)
    {
        _105 = _96;
    }
    else
    {
        _105 = float3(0.0f, 1.0f, 0.0f);
    }
    _38 = _105;
    _96 = (-vs_TEXCOORD0) + _78_m0;
    _120 = dot(_96, _96);
    _120 = rsqrt(_120);
    _126 = (_96 * _120.xxx) + _38;
    _96 = _120.xxx * _96;
    _120 = dot(_126, _126);
    _120 = rsqrt(_120);
    _126 = _120.xxx * _126;
    _146 = vs_TEXCOORD1.yyy * _78_m2[1].xyz;
    _146 = (_78_m2[0].xyz * vs_TEXCOORD1.xxx) + _146;
    _146 = (_78_m2[2].xyz * _25.xxx) + _146;
    _120 = dot(_146, _146);
    _120 = rsqrt(_120);
    _146 = _120.xxx * _146;
    _120 = dot(_146, _126);
    _120 = clamp(_120, 0.0f, 1.0f);
    _120 = log2(_120);
    float2 _196 = (_78_m7.xx * float2(10.0f, 7.0f)) + 1.0f.xx;
    _9 = float4(_196.x, _196.y, _9.z, _9.w);
    float2 _201 = exp2(_9.xy);
    _9 = float4(_201.x, _201.y, _9.z, _9.w);
    _120 *= _9.x;
    _120 = exp2(_120);
    _120 *= _78_m8;
    float3 _221 = _120.xxx * _78_m4.xyz;
    _9 = float4(_221.x, _9.y, _221.y, _221.z);
    _126 = _78_m5.xyz + (-_78_m6.xyz);
    _126 = (_25.xxx * _126) + _78_m6.xyz;
    _126 *= _11.xyz;
    _25.x = dot(_146, _38);
    _25.x = (_25.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _261 = max(vs_TEXCOORD2, 0.2199999988079071044921875f.xxx);
    _267 = (_78_m4.xyz * _25.xxx) + _261;
    float3 _281 = (_126 * _267) + _9.xzw;
    _9 = float4(_281.x, _9.y, _281.y, _281.z);
    _267 = (_126 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _291 = (_126 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _25.x = dot(_146, _96);
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = (-_25.x) + 1.0f;
    _38.x = _25.x * _25.x;
    _38.x *= _38.x;
    _25.x = _38.x * _25.x;
    _38.x = (_25.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _337 = _25.x * _78_m9;
    _337 *= _78_m7;
    _348 = _38.xxx * _261;
    _348 *= _78_m7.xxx;
    _348 *= 0.300000011920928955078125f.xxx;
    float3 _367 = (_348 * _267) + _9.xzw;
    _9 = float4(_367.x, _9.y, _367.y, _367.z);
    _25.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _25.x = rsqrt(_25.x);
    _38 = (vs_TEXCOORD4 * _25.xxx) + _96;
    _126 = _25.xxx * vs_TEXCOORD4;
    _25.x = dot(_38, _38);
    _25.x = rsqrt(_25.x);
    _25 = _25.xxx * _38;
    _25.x = dot(_146, _25);
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = log2(_25.x);
    _25.x = _9.y * _25.x;
    _25.x = exp2(_25.x);
    _25.x *= _78_m8;
    float3 _437 = (vs_TEXCOORD5 * _25.xxx) + _9.xzw;
    _9 = float4(_437.x, _437.y, _437.z, _9.w);
    _25.x = dot(-_96, _146);
    _25.x += _25.x;
    _25 = (_146 * (-_25.xxx)) + (-_96);
    _25.x = dot(_25, _126);
    _25.x = (_25.x * 0.5f) + 0.5f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x *= _25.x;
    _25.x *= _25.x;
    _267 = (-_261) + vs_TEXCOORD5;
    _261 = (_25.xxx * _267) + _261;
    _261 = _291 * _261;
    float3 _504 = (_261 * _337.xxx) + _9.xyz;
    _9 = float4(_504.x, _504.y, _504.z, _9.w);
    _25 = _9.xyz + (-_78_m3.xyz);
    _515 = vs_TEXCOORD3;
    _515 = clamp(_515, 0.0f, 1.0f);
    _25 = (_515.xxx * _25) + _78_m3.xyz;
    _529 = float4(_25.x, _25.y, _25.z, _529.w);
    _529.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._529 = _529;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 unity_SHAr;
float4 unity_SHAg;
float4 unity_SHAb;
float4 unity_SHBr;
float4 unity_SHBg;
float4 unity_SHBb;
float4 unity_SHC;
float4x4 unity_ObjectToWorld;
static float4 _20_m7[4];
float4x4 unity_MatrixVP;
static float4 _20_m8[4];
void __unity_init()
{
    _20_m7[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _20_m7[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _20_m7[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _20_m7[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _20_m8[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _20_m8[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _20_m8[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _20_m8[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _20_m0 unity_SHAr
#define _20_m1 unity_SHAg
#define _20_m2 unity_SHAb
#define _20_m3 unity_SHBr
#define _20_m4 unity_SHBg
#define _20_m5 unity_SHBb
#define _20_m6 unity_SHC



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD1;
static float2 _100;
static float4 _108;
static float4 _109;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float4 _109 : COLOR;
    float2 _100 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _108 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float3 _112;
static float3 _171;
static bool _178;
static float4 _218;
static float3 _224;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _20_m7[1];
    _9 = (_20_m7[0] * _11.xxxx) + _9;
    _9 = (_20_m7[2] * _11.zzzz) + _9;
    _44 = _9 + _20_m7[3];
    vs_TEXCOORD0 = (_20_m7[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _20_m8[1];
    _9 = (_20_m8[0] * _44.xxxx) + _9;
    _9 = (_20_m8[2] * _44.zzzz) + _9;
    gl_Position = (_20_m8[3] * _44.wwww) + _9;
    vs_TEXCOORD1 = (_100 * 2.0f.xx) + (-1.0f).xx;
    _108 = _109;
    _112.x = dot(_20_m0.yw, 1.0f.xx);
    _112.y = dot(_20_m1.yw, 1.0f.xx);
    _112.z = dot(_20_m2.yw, 1.0f.xx);
    _112 += (-_20_m6.xyz);
    vs_TEXCOORD2 = max(_112, 0.2199999988079071044921875f.xxx);
    _112 = _20_m1.xyz * 0.715200006961822509765625f.xxx;
    _112 = (_20_m0.xyz * 0.2125999927520751953125f.xxx) + _112;
    _112 = (_20_m2.xyz * 0.072200000286102294921875f.xxx) + _112;
    _9.x = dot(_112, _112);
    _171.x = rsqrt(_9.x);
    _178 = 9.9999999392252902907785028219223e-09f < _9.x;
    _171 = _171.xxx * _112;
    float3 _189;
    if (_178)
    {
        _189 = _171;
    }
    else
    {
        _189 = float3(0.0f, 1.0f, 0.0f);
    }
    _9 = float4(_189.x, _189.y, _189.z, _9.w);
    vs_TEXCOORD4 = _9.xyz;
    _112.x = _9.y * _9.y;
    _112.x = (_9.x * _9.x) + (-_112.x);
    _218 = _9.yzzx * _9.xyzz;
    _224.x = dot(_20_m3, _218);
    _224.y = dot(_20_m4, _218);
    _224.z = dot(_20_m5, _218);
    _112 = (_20_m6.xyz * _112.xxx) + _224;
    _9.w = 1.0f;
    _224.x = dot(_20_m0, _9);
    _224.y = dot(_20_m1, _9);
    _224.z = dot(_20_m2, _9);
    _112 += _224;
    vs_TEXCOORD5 = max(_112, 0.0f.xxx);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _100 = stage_input._100;
    _109 = stage_input._109;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output._108 = _108;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_MatrixInvV;
static float4 _78_m2[4];
float4 _LightColor0;
float4 _DropColor;
float4 _DropDeep;
float _Smoothness;
float _Specular;
float _Sheen;
void __unity_init()
{
    _78_m2[0] = float4(unity_MatrixInvV[0][0], unity_MatrixInvV[1][0], unity_MatrixInvV[2][0], unity_MatrixInvV[3][0]);
    _78_m2[1] = float4(unity_MatrixInvV[0][1], unity_MatrixInvV[1][1], unity_MatrixInvV[2][1], unity_MatrixInvV[3][1]);
    _78_m2[2] = float4(unity_MatrixInvV[0][2], unity_MatrixInvV[1][2], unity_MatrixInvV[2][2], unity_MatrixInvV[3][2]);
    _78_m2[3] = float4(unity_MatrixInvV[0][3], unity_MatrixInvV[1][3], unity_MatrixInvV[2][3], unity_MatrixInvV[3][3]);
}
#define _78_m0 _WorldSpaceCameraPos
#define _78_m1 _WorldSpaceLightPos0
#define _78_m3 _LightColor0
#define _78_m4 _DropColor
#define _78_m5 _DropDeep
#define _78_m6 _Smoothness
#define _78_m7 _Specular
#define _78_m8 _Sheen



static float4 _11;
static float2 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD4;
static float3 vs_TEXCOORD5;
static float4 _499;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD1 : TEXCOORD1;
    float4 _11 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD4 : TEXCOORD4;
    float3 vs_TEXCOORD5 : TEXCOORD5;
};

struct SPIRV_Cross_Output
{
    float4 _499 : SV_Target0;
};

static float4 _9;
static float3 _25;
static float3 _38;
static bool _59;
static float _88;
static float3 _96;
static float _120;
static float3 _126;
static float3 _146;
static float3 _261;
static float3 _267;
static float3 _291;
static float _337;
static float3 _348;

void frag_inner()
{
    __unity_init();
    _9.x = (-_11.w) + 1.0f;
    _25.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _25.x = (-_25.x) + 1.0f;
    _38.x = ((-_9.x) * 0.60000002384185791015625f) + _25.x;
    _25.x = max(_25.x, 0.0f);
    _25.x = sqrt(_25.x);
    _59 = _38.x < 0.0f;
    if ((int(_59) * (-1)) != 0)
    {
        discard;
    }
    _38.x = dot(_78_m1.xyz, _78_m1.xyz);
    _88 = rsqrt(_38.x);
    _59 = 9.9999999747524270787835121154785e-07f < _38.x;
    _96 = _88.xxx * _78_m1.xyz;
    float3 _105;
    if (_59)
    {
        _105 = _96;
    }
    else
    {
        _105 = float3(0.0f, 1.0f, 0.0f);
    }
    _38 = _105;
    _96 = (-vs_TEXCOORD0) + _78_m0;
    _120 = dot(_96, _96);
    _120 = rsqrt(_120);
    _126 = (_96 * _120.xxx) + _38;
    _96 = _120.xxx * _96;
    _120 = dot(_126, _126);
    _120 = rsqrt(_120);
    _126 = _120.xxx * _126;
    _146 = vs_TEXCOORD1.yyy * _78_m2[1].xyz;
    _146 = (_78_m2[0].xyz * vs_TEXCOORD1.xxx) + _146;
    _146 = (_78_m2[2].xyz * _25.xxx) + _146;
    _120 = dot(_146, _146);
    _120 = rsqrt(_120);
    _146 = _120.xxx * _146;
    _120 = dot(_146, _126);
    _120 = clamp(_120, 0.0f, 1.0f);
    _120 = log2(_120);
    float2 _196 = (_78_m6.xx * float2(10.0f, 7.0f)) + 1.0f.xx;
    _9 = float4(_196.x, _196.y, _9.z, _9.w);
    float2 _201 = exp2(_9.xy);
    _9 = float4(_201.x, _201.y, _9.z, _9.w);
    _120 *= _9.x;
    _120 = exp2(_120);
    _120 *= _78_m7;
    float3 _221 = _120.xxx * _78_m3.xyz;
    _9 = float4(_221.x, _9.y, _221.y, _221.z);
    _126 = _78_m4.xyz + (-_78_m5.xyz);
    _126 = (_25.xxx * _126) + _78_m5.xyz;
    _126 *= _11.xyz;
    _25.x = dot(_146, _38);
    _25.x = (_25.x * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _261 = max(vs_TEXCOORD2, 0.2199999988079071044921875f.xxx);
    _267 = (_78_m3.xyz * _25.xxx) + _261;
    float3 _281 = (_126 * _267) + _9.xzw;
    _9 = float4(_281.x, _9.y, _281.y, _281.z);
    _267 = (_126 * 2.0f.xxx) + 0.1500000059604644775390625f.xxx;
    _291 = (_126 * 3.0f.xxx) + 0.0599999986588954925537109375f.xxx;
    _25.x = dot(_146, _96);
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = (-_25.x) + 1.0f;
    _38.x = _25.x * _25.x;
    _38.x *= _38.x;
    _25.x = _38.x * _25.x;
    _38.x = (_25.x * 0.959999978542327880859375f) + 0.039999999105930328369140625f;
    _337 = _25.x * _78_m8;
    _337 *= _78_m6;
    _348 = _38.xxx * _261;
    _348 *= _78_m6.xxx;
    _348 *= 0.300000011920928955078125f.xxx;
    float3 _367 = (_348 * _267) + _9.xzw;
    _9 = float4(_367.x, _9.y, _367.y, _367.z);
    _25.x = dot(vs_TEXCOORD4, vs_TEXCOORD4);
    _25.x = rsqrt(_25.x);
    _38 = (vs_TEXCOORD4 * _25.xxx) + _96;
    _126 = _25.xxx * vs_TEXCOORD4;
    _25.x = dot(_38, _38);
    _25.x = rsqrt(_25.x);
    _25 = _25.xxx * _38;
    _25.x = dot(_146, _25);
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x = log2(_25.x);
    _25.x = _9.y * _25.x;
    _25.x = exp2(_25.x);
    _25.x *= _78_m7;
    float3 _437 = (vs_TEXCOORD5 * _25.xxx) + _9.xzw;
    _9 = float4(_437.x, _437.y, _437.z, _9.w);
    _25.x = dot(-_96, _146);
    _25.x += _25.x;
    _25 = (_146 * (-_25.xxx)) + (-_96);
    _25.x = dot(_25, _126);
    _25.x = (_25.x * 0.5f) + 0.5f;
    _25.x = clamp(_25.x, 0.0f, 1.0f);
    _25.x *= _25.x;
    _25.x *= _25.x;
    _267 = (-_261) + vs_TEXCOORD5;
    _261 = (_25.xxx * _267) + _261;
    _261 = _291 * _261;
    float3 _506 = (_261 * _337.xxx) + _9.xyz;
    _499 = float4(_506.x, _506.y, _506.z, _499.w);
    _499.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._499 = _499;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}