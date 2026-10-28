// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SoreBones/SpectatorGhost" {
Properties {

_BaseMap ("Bones", 2D) = "white" { }

_Color ("Bone Tint", Color) = (0.75,0.75,0.75,1)

_BlackPoint ("Black Point", Range(0, 1)) = 0.15000000596046448

_WhitePoint ("White Point", Range(0, 1)) = 0.6000000238418579

_Opacity ("Opacity", Range(0, 1)) = 0.8999999761581421

_DarkClear ("Dark See-Through", Range(0, 1)) = 0.10000000149011612

_InsideShade ("Inside Shade", Range(0, 1)) = 0.11999999731779099

[ToggleUI] _DoubleSided ("Double Sided", Float) = 0.0

[ToggleUI] _MirroredMesh ("Mirrored Mesh", Float) = 0.0

_Lighting ("Bakery Lighting", Range(0, 3)) = 1.0

_LightColor ("Light Colour", Range(0, 1)) = 0.0

_Emission ("Self Light", Range(0, 1)) = 0.05999999865889549

_RimColor ("Rim Color", Color) = (0.45,1,0.86,1)

_RimPower ("Rim Power", Range(0.5, 8)) = 3.0

_RimStrength ("Rim Strength", Range(0, 4)) = 0.11999999731779099

_PulseSpeed ("Pulse Speed", Float) = 2.200000047683716

_PulseAmount ("Pulse Amount", Range(0, 1)) = 0.30000001192092896

_Waver ("Waver", Range(0, 1)) = 0.11999999731779099

_FadeNear ("Fade Near", Float) = 1.5

_FadeFar ("Fade Far", Float) = 3.0

_VolumeMin ("Volume Min", Vector) = (0,0,0,1)

_VolumeInvSize ("Volume Inv Size", Vector) = (1000000.0,1000000.0,1000000.0,1)

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
ZWrite On
 Name "GhostDepth"
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Cull Off
   ColorMask 0
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_MatrixVP;
static float4 _21_m1[4];
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m1[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m1[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m1[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}




static float4 gl_Position;
static float4 _12;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float4 _54;

void vert_inner()
{
    __unity_init();
    _9 = _12.yyy * _21_m0[1].xyz;
    _9 = (_21_m0[0].xyz * _12.xxx) + _9;
    _9 = (_21_m0[2].xyz * _12.zzz) + _9;
    _9 += _21_m0[3].xyz;
    _54 = _9.yyyy * _21_m1[1];
    _54 = (_21_m1[0] * _9.xxxx) + _54;
    _54 = (_21_m1[2] * _9.zzzz) + _54;
    vs_TEXCOORD0 = _9;
    gl_Position = _54 + _21_m1[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
#define _15_m0 _WorldSpaceCameraPos
#define _15_m1 _FadeNear
#define _15_m2 _FadeFar
#define _15_m3 _GhostSeeAll



static float3 vs_TEXCOORD0;
static float4 _93;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _93 : SV_Target0;
};

static float3 _9;
static float _43;
static bool _79;

void frag_inner()
{
    _9 = vs_TEXCOORD0 + (-_15_m0);
    _9.x = dot(_9, _9);
    _9.x = sqrt(_9.x);
    _9.x = (-_9.x) + _15_m2;
    _43 = (-_15_m1) + _15_m2;
    _43 = max(_43, 0.001000000047497451305389404296875f);
    _9.x /= _43;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = max(_9.x, _15_m3);
    _9.x += (-0.0199999995529651641845703125f);
    _79 = _9.x < 0.0f;
    if ((int(_79) * (-1)) != 0)
    {
        discard;
    }
    _93 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._93 = _93;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
 Name "Ghost"
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "ALWAYS" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 ZWrite Off
 Cull Off
   Blend One OneMinusSrcAlpha
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _26_m1[4];
float4x4 unity_WorldToObject;
static float4 _26_m2[4];
float4x4 unity_MatrixVP;
static float4 _26_m3[4];
float4 unity_FogParams;
float4 _FlickerZones[8];
float4 _FlickerState[8];
float _FlickerZoneCount;
float4 _BaseMap_ST;
float _LightColor;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _26_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _26_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _26_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _26_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _26_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _26_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _26_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _26_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _26_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _26_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _26_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _26_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _26_m0 _ProjectionParams
#define _26_m4 unity_FogParams
#define _26_m5 _FlickerZones
#define _26_m6 _FlickerState
#define _26_m7 _FlickerZoneCount
#define _26_m8 _BaseMap_ST
#define _26_m9 _LightColor
#define _26_m10 _VolumeMin
#define _26_m11 _VolumeInvSize
#define _26_m12 _GlobalVolumeMin
#define _26_m13 _GlobalVolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _12;
static float3 _59;
static float2 vs_TEXCOORD0;
static float2 _121;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _12 : POSITION;
    float3 _59 : NORMAL;
    float2 _121 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float3 _57;
static float _82;
static float4 _93;
static bool _134;
static float4 _141;
static float4 _170;
static float4 _222;
static float3 _239;
static float3 _250;
static float _269;
static float _308;
static float _389;
static float _401;
static float _498;
static float _635;
static int _723;
static bool _724;

void vert_inner()
{
    __unity_init();
    _9 = _12.yyy * _26_m1[1].xyz;
    _9 = (_26_m1[0].xyz * _12.xxx) + _9;
    _9 = (_26_m1[2].xyz * _12.zzz) + _9;
    _9 += _26_m1[3].xyz;
    _57.x = dot(_59, _26_m2[0].xyz);
    _57.y = dot(_59, _26_m2[1].xyz);
    _57.z = dot(_59, _26_m2[2].xyz);
    _82 = dot(_57, _57);
    _82 = rsqrt(_82);
    _57 = _82.xxx * _57;
    _93 = _9.yyyy * _26_m3[1];
    _93 = (_26_m3[0] * _9.xxxx) + _93;
    _93 = (_26_m3[2] * _9.zzzz) + _93;
    _93 += _26_m3[3];
    vs_TEXCOORD0 = (_121 * _26_m8.xy) + _26_m8.zw;
    _134 = 1000000.0f < _26_m11.x;
    float3 _144;
    if (_134)
    {
        _144 = _26_m12;
    }
    else
    {
        _144 = float3(_26_m10.x, _26_m10.y, _26_m10.z);
    }
    _141 = float4(_144.x, _144.y, _144.z, _141.w);
    float3 _167 = _9 + (-_141.xyz);
    _141 = float4(_167.x, _167.y, _167.z, _141.w);
    float3 _172;
    if (_134)
    {
        _172 = _26_m13;
    }
    else
    {
        _172 = _26_m11;
    }
    _170 = float4(_172.x, _172.y, _172.z, _170.w);
    float3 _188 = _141.xyz * _170.xyz;
    _141 = float4(_188.x, _188.y, _188.z, _141.w);
    _170 = _Volume0.SampleLevel(sampler_Volume0, _141.xyz, 0.0f).xywz;
    _82 = _170.y + _170.x;
    _82 = _170.w + _82;
    _134 = 9.9999997473787516355514526367188e-06f < _82;
    if (_134)
    {
        _222 = _Volume1.SampleLevel(sampler_Volume0, _141.xyz, 0.0f).yxwz;
        _141 = _Volume2.SampleLevel(sampler_Volume0, _141.xyz, 0.0f).xzwy;
        _239 = max(_170.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _170.x = _222.y;
        _170.y = _141.x;
        _250 = _170.xyz * 0.5f.xxx;
        _82 = dot(_250, _250);
        _82 = sqrt(_82);
        float3 _266 = (_170.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _170 = float4(_266.x, _266.y, _266.z, _170.w);
        _269 = dot(_170.xyz, _170.xyz);
        _269 = rsqrt(_269);
        float3 _281 = _269.xxx * _170.xyz;
        _170 = float4(_281.x, _281.y, _281.z, _170.w);
        _269 = dot(_170.xyz, _57);
        _269 = (_269 * 0.5f) + 0.5f;
        _269 = clamp(_269, 0.0f, 1.0f);
        _170.x = _82 + _82;
        _170.x /= _239.x;
        _82 /= _239.x;
        _308 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _308 / _82;
        _308 = (-_82) + 1.0f;
        float2 _324 = _170.xx + float2(1.0f, 2.0f);
        _170 = float4(_324.x, _170.y, _324.y, _170.w);
        _308 = _170.z * _308;
        _269 = log2(_269);
        _269 *= _170.x;
        _269 = exp2(_269);
        _82 = (_308 * _269) + _82;
        _170.x = _82 * _239.x;
        _222.y = _141.w;
        _250 = _222.xyz * 0.5f.xxx;
        _82 = dot(_250, _250);
        _82 = sqrt(_82);
        float3 _363 = (_222.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _222 = float4(_363.x, _363.y, _363.z, _222.w);
        _269 = dot(_222.xyz, _222.xyz);
        _269 = rsqrt(_269);
        float3 _377 = _269.xxx * _222.xyz;
        _222 = float4(_377.x, _377.y, _377.z, _222.w);
        _269 = dot(_222.xyz, _57);
        _269 = (_269 * 0.5f) + 0.5f;
        _269 = clamp(_269, 0.0f, 1.0f);
        _389 = _82 + _82;
        _389 /= _239.y;
        _82 /= _239.y;
        _401 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _401 / _82;
        _401 = (-_82) + 1.0f;
        float2 _415 = _389.xx + float2(1.0f, 2.0f);
        _222 = float4(_415.x, _415.y, _222.z, _222.w);
        _389 = _401 * _222.y;
        _269 = log2(_269);
        _269 *= _222.x;
        _269 = exp2(_269);
        _82 = (_389 * _269) + _82;
        _170.y = _82 * _239.y;
        _141.x = _222.w;
        float3 _445 = _141.xyz * 0.5f.xxx;
        _222 = float4(_445.x, _445.y, _445.z, _222.w);
        _82 = dot(_222.xyz, _222.xyz);
        _82 = sqrt(_82);
        float3 _458 = (_141.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _141 = float4(_458.x, _458.y, _458.z, _141.w);
        _269 = dot(_141.xyz, _141.xyz);
        _269 = rsqrt(_269);
        float3 _472 = _269.xxx * _141.xyz;
        _141 = float4(_472.x, _472.y, _472.z, _141.w);
        _269 = dot(_141.xyz, _57);
        _269 = (_269 * 0.5f) + 0.5f;
        _269 = clamp(_269, 0.0f, 1.0f);
        _141.x = _82 + _82;
        _141.x /= _239.z;
        _82 /= _239.z;
        _498 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _498 / _82;
        _498 = (-_82) + 1.0f;
        float2 _512 = _141.xx + float2(1.0f, 2.0f);
        _141 = float4(_512.x, _141.y, _512.y, _141.w);
        _498 = _141.z * _498;
        _269 = log2(_269);
        _269 *= _141.x;
        _269 = exp2(_269);
        _82 = (_498 * _269) + _82;
        _170.z = _82 * _239.z;
        float3 _540 = max(_170.xyz, 0.0f.xxx);
        _141 = float4(_540.x, _540.y, _540.z, _141.w);
        float3 _546 = _141.xyz + 1.0f.xxx;
        _170 = float4(_546.x, _546.y, _546.z, _170.w);
        float3 _553 = _141.xyz * _170.xyz;
        _141 = float4(_553.x, _553.y, _553.z, _141.w);
        _82 = 0.0f;
        for (int _557 = 0; _557 < _26_m7; _557++)
        {
            float3 _576 = _9 + (-_26_m5[_557].xyz);
            _170 = float4(_576.x, _576.y, _576.z, _170.w);
            _389 = dot(_170.xyz, _170.xyz);
            _389 = sqrt(_389);
            _170.x = max(9.9999997473787516355514526367188e-05f, _26_m5[_557].w);
            _389 /= _170.x;
            _389 = (-_389) + 1.0f;
            _389 = max(_389, 0.0f);
            _170.x = _389 * _389;
            _389 = ((-_389) * 2.0f) + 3.0f;
            _389 *= _170.x;
            _389 *= _26_m6[_557].x;
            _82 = max(_82, _389);
        }
        _82 = (-_82) + 1.0f;
        float3 _632 = _82.xxx * _141.xyz;
        _170 = float4(_632.x, _632.y, _632.z, _170.w);
        _635 = dot(_170.xyz, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
        float3 _651 = (_141.xyz * _82.xxx) + (-_635.xxx);
        _141 = float4(_651.x, _651.y, _651.z, _141.w);
        float3 _663 = (_26_m9.xxx * _141.xyz) + _635.xxx;
        _141 = float4(_663.x, _663.y, _663.z, _141.w);
        vs_TEXCOORD3 = _141.xyz;
    }
    else
    {
        vs_TEXCOORD3 = 0.0f.xxx;
    }
    _82 = _93.z / _26_m0.y;
    _82 = (-_82) + 1.0f;
    _82 *= _26_m0.z;
    _82 = max(_82, 0.0f);
    _82 *= _26_m4.y;
    vs_TEXCOORD4 = exp2(-_82);
    gl_Position = _93;
    vs_TEXCOORD1 = _9;
    vs_TEXCOORD2 = _57;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _59 = stage_input._59;
    _121 = stage_input._121;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
float4 _Color;
float _BlackPoint;
float _WhitePoint;
float _Opacity;
float _DarkClear;
float _InsideShade;
float _DoubleSided;
float _MirroredMesh;
float _Lighting;
float _Emission;
float4 _RimColor;
float _RimPower;
float _RimStrength;
float _PulseSpeed;
float _PulseAmount;
float _Waver;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_FogColor
#define _17_m3 _FadeNear
#define _17_m4 _FadeFar
#define _17_m5 _GhostSeeAll
#define _17_m6 _Color
#define _17_m7 _BlackPoint
#define _17_m8 _WhitePoint
#define _17_m9 _Opacity
#define _17_m10 _DarkClear
#define _17_m11 _InsideShade
#define _17_m12 _DoubleSided
#define _17_m13 _MirroredMesh
#define _17_m14 _Lighting
#define _17_m15 _Emission
#define _17_m16 _RimColor
#define _17_m17 _RimPower
#define _17_m18 _RimStrength
#define _17_m19 _PulseSpeed
#define _17_m20 _PulseAmount
#define _17_m21 _Waver


Texture2D<float4> _BaseMap;
SamplerState sampler_BaseMap;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _456;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _456 : SV_Target0;
};

static float4 _9;
static float _27;
static float3 _49;
static float2 _90;
static float2 _115;
static float3 _137;
static float _153;
static float3 _260;
static float _277;
static float4 _352;

void frag_inner()
{
    float3 _23 = (-vs_TEXCOORD1) + _17_m1;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = dot(_9.xyz, _9.xyz);
    _27 = rsqrt(_27);
    float3 _39 = _27.xxx * _9.xyz;
    _9 = float4(_39.x, _39.y, _39.z, _9.w);
    _27 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _27 = rsqrt(_27);
    _49 = _27.xxx * vs_TEXCOORD2;
    _9.x = dot(_49, _9.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _17_m17;
    _9.x = exp2(_9.x);
    bool2 _102 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u).xx;
    _90 = float2(_102.x ? float2(0.0f, 1.0f).x : float2(1.0f, -1.0f).x, _102.y ? float2(0.0f, 1.0f).y : float2(1.0f, -1.0f).y);
    _9.y = (_17_m13 * _90.y) + _90.x;
    _115.x = (-_17_m12) + 1.0f;
    _115.y = ((-_9.y) * _115.x) + 1.0f;
    float2 _134 = _115.yx * _9.xy;
    _9 = float4(_134.x, _134.y, _9.z, _9.w);
    _137 = _BaseMap.Sample(sampler_BaseMap, vs_TEXCOORD0).xyz;
    _153 = dot(_137, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    _153 = sqrt(_153);
    _115.x = _153 + (-_17_m7);
    _27 = (-_17_m7) + _17_m8;
    _27 = max(_27, 0.001000000047497451305389404296875f);
    _115.x /= _27;
    _115.x = clamp(_115.x, 0.0f, 1.0f);
    _153 = _115.x * _115.x;
    _115.x = (_115.x * _115.x) + (-1.0f);
    _115.x = (_17_m10 * _115.x) + 1.0f;
    _115.x *= _17_m9;
    _9.x *= _153;
    _49 = _153.xxx * _17_m6.xyz;
    _9.x *= _17_m18;
    _27 = _17_m0.y * _17_m19;
    _27 = sin(_27);
    _27 = (_27 * 0.5f) + 0.5f;
    _27 = ((-_17_m20) * _27) + 1.0f;
    _9.x = _27 * _9.x;
    _260 = vs_TEXCOORD1 + (-_17_m1);
    _27 = dot(_260, _260);
    _27 = sqrt(_27);
    _27 = (-_27) + _17_m4;
    _277 = (-_17_m3) + _17_m4;
    _277 = max(_277, 0.001000000047497451305389404296875f);
    _27 /= _277;
    _27 = clamp(_27, 0.0f, 1.0f);
    _27 = max(_27, _17_m5);
    _9.x = _27 * _9.x;
    _260 = _9.xxx * _17_m16.xyz;
    _9.x = _17_m0.y * 2.5f;
    _9.x = (vs_TEXCOORD1.y * 9.0f) + (-_9.x);
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = ((-_17_m21) * _9.x) + 1.0f;
    _9.x *= _115.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _352.w = _27 * _9.x;
    float3 _386 = (vs_TEXCOORD3 * float3(float3(_17_m14, _17_m14, _17_m14))) + float3(float3(_17_m15, _17_m15, _17_m15));
    _9 = float4(_386.x, _9.y, _386.y, _386.z);
    float3 _392 = _9.xzw * _49;
    _9 = float4(_392.x, _9.y, _392.y, _392.z);
    _49.x = _17_m11 + (-1.0f);
    _90.x = (_9.y * _49.x) + 1.0f;
    float3 _411 = _90.xxx * _9.xzw;
    _9 = float4(_411.x, _411.y, _411.z, _9.w);
    float3 _420 = (_9.xyz * _352.www) + _260;
    _9 = float4(_420.x, _420.y, _420.z, _9.w);
    float3 _433 = ((-_17_m2.xyz) * _352.www) + _9.xyz;
    _9 = float4(_433.x, _433.y, _433.z, _9.w);
    _49 = _352.www * _17_m2.xyz;
    _27 = vs_TEXCOORD4;
    _27 = clamp(_27, 0.0f, 1.0f);
    float3 _452 = (_27.xxx * _9.xyz) + _49;
    _352 = float4(_452.x, _452.y, _452.z, _352.w);
    _456 = _352;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._456 = _456;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _26_m1[4];
float4x4 unity_WorldToObject;
static float4 _26_m2[4];
float4x4 unity_MatrixVP;
static float4 _26_m3[4];
float4 unity_FogParams;
float4 _FlickerZones[8];
float4 _FlickerState[8];
float _FlickerZoneCount;
float4 _BaseMap_ST;
float _LightColor;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _26_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _26_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _26_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _26_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _26_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _26_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _26_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _26_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _26_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _26_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _26_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _26_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _26_m0 _ProjectionParams
#define _26_m4 unity_FogParams
#define _26_m5 _FlickerZones
#define _26_m6 _FlickerState
#define _26_m7 _FlickerZoneCount
#define _26_m8 _BaseMap_ST
#define _26_m9 _LightColor
#define _26_m10 _VolumeMin
#define _26_m11 _VolumeInvSize
#define _26_m12 _GlobalVolumeMin
#define _26_m13 _GlobalVolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _12;
static float3 _59;
static float2 vs_TEXCOORD0;
static float2 _121;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _12 : POSITION;
    float3 _59 : NORMAL;
    float2 _121 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float3 _57;
static float _82;
static float4 _93;
static bool _134;
static float4 _141;
static float4 _170;
static float4 _222;
static float3 _239;
static float3 _250;
static float _269;
static float _308;
static float _389;
static float _401;
static float _498;
static float _635;
static int _726;
static bool _727;

void vert_inner()
{
    __unity_init();
    _9 = _12.yyy * _26_m1[1].xyz;
    _9 = (_26_m1[0].xyz * _12.xxx) + _9;
    _9 = (_26_m1[2].xyz * _12.zzz) + _9;
    _9 += _26_m1[3].xyz;
    _57.x = dot(_59, _26_m2[0].xyz);
    _57.y = dot(_59, _26_m2[1].xyz);
    _57.z = dot(_59, _26_m2[2].xyz);
    _82 = dot(_57, _57);
    _82 = rsqrt(_82);
    _57 = _82.xxx * _57;
    _93 = _9.yyyy * _26_m3[1];
    _93 = (_26_m3[0] * _9.xxxx) + _93;
    _93 = (_26_m3[2] * _9.zzzz) + _93;
    _93 += _26_m3[3];
    vs_TEXCOORD0 = (_121 * _26_m8.xy) + _26_m8.zw;
    _134 = 1000000.0f < _26_m11.x;
    float3 _144;
    if (_134)
    {
        _144 = _26_m12;
    }
    else
    {
        _144 = float3(_26_m10.x, _26_m10.y, _26_m10.z);
    }
    _141 = float4(_144.x, _144.y, _144.z, _141.w);
    float3 _167 = _9 + (-_141.xyz);
    _141 = float4(_167.x, _167.y, _167.z, _141.w);
    float3 _172;
    if (_134)
    {
        _172 = _26_m13;
    }
    else
    {
        _172 = _26_m11;
    }
    _170 = float4(_172.x, _172.y, _172.z, _170.w);
    float3 _188 = _141.xyz * _170.xyz;
    _141 = float4(_188.x, _188.y, _188.z, _141.w);
    _170 = _Volume0.SampleLevel(sampler_Volume0, _141.xyz, 0.0f).xywz;
    _82 = _170.y + _170.x;
    _82 = _170.w + _82;
    _134 = 9.9999997473787516355514526367188e-06f < _82;
    if (_134)
    {
        _222 = _Volume1.SampleLevel(sampler_Volume0, _141.xyz, 0.0f).yxwz;
        _141 = _Volume2.SampleLevel(sampler_Volume0, _141.xyz, 0.0f).xzwy;
        _239 = max(_170.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _170.x = _222.y;
        _170.y = _141.x;
        _250 = _170.xyz * 0.5f.xxx;
        _82 = dot(_250, _250);
        _82 = sqrt(_82);
        float3 _266 = (_170.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _170 = float4(_266.x, _266.y, _266.z, _170.w);
        _269 = dot(_170.xyz, _170.xyz);
        _269 = rsqrt(_269);
        float3 _281 = _269.xxx * _170.xyz;
        _170 = float4(_281.x, _281.y, _281.z, _170.w);
        _269 = dot(_170.xyz, _57);
        _269 = (_269 * 0.5f) + 0.5f;
        _269 = clamp(_269, 0.0f, 1.0f);
        _170.x = _82 + _82;
        _170.x /= _239.x;
        _82 /= _239.x;
        _308 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _308 / _82;
        _308 = (-_82) + 1.0f;
        float2 _324 = _170.xx + float2(1.0f, 2.0f);
        _170 = float4(_324.x, _170.y, _324.y, _170.w);
        _308 = _170.z * _308;
        _269 = log2(_269);
        _269 *= _170.x;
        _269 = exp2(_269);
        _82 = (_308 * _269) + _82;
        _170.x = _82 * _239.x;
        _222.y = _141.w;
        _250 = _222.xyz * 0.5f.xxx;
        _82 = dot(_250, _250);
        _82 = sqrt(_82);
        float3 _363 = (_222.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _222 = float4(_363.x, _363.y, _363.z, _222.w);
        _269 = dot(_222.xyz, _222.xyz);
        _269 = rsqrt(_269);
        float3 _377 = _269.xxx * _222.xyz;
        _222 = float4(_377.x, _377.y, _377.z, _222.w);
        _269 = dot(_222.xyz, _57);
        _269 = (_269 * 0.5f) + 0.5f;
        _269 = clamp(_269, 0.0f, 1.0f);
        _389 = _82 + _82;
        _389 /= _239.y;
        _82 /= _239.y;
        _401 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _401 / _82;
        _401 = (-_82) + 1.0f;
        float2 _415 = _389.xx + float2(1.0f, 2.0f);
        _222 = float4(_415.x, _415.y, _222.z, _222.w);
        _389 = _401 * _222.y;
        _269 = log2(_269);
        _269 *= _222.x;
        _269 = exp2(_269);
        _82 = (_389 * _269) + _82;
        _170.y = _82 * _239.y;
        _141.x = _222.w;
        float3 _445 = _141.xyz * 0.5f.xxx;
        _222 = float4(_445.x, _445.y, _445.z, _222.w);
        _82 = dot(_222.xyz, _222.xyz);
        _82 = sqrt(_82);
        float3 _458 = (_141.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _141 = float4(_458.x, _458.y, _458.z, _141.w);
        _269 = dot(_141.xyz, _141.xyz);
        _269 = rsqrt(_269);
        float3 _472 = _269.xxx * _141.xyz;
        _141 = float4(_472.x, _472.y, _472.z, _141.w);
        _269 = dot(_141.xyz, _57);
        _269 = (_269 * 0.5f) + 0.5f;
        _269 = clamp(_269, 0.0f, 1.0f);
        _141.x = _82 + _82;
        _141.x /= _239.z;
        _82 /= _239.z;
        _498 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _498 / _82;
        _498 = (-_82) + 1.0f;
        float2 _512 = _141.xx + float2(1.0f, 2.0f);
        _141 = float4(_512.x, _141.y, _512.y, _141.w);
        _498 = _141.z * _498;
        _269 = log2(_269);
        _269 *= _141.x;
        _269 = exp2(_269);
        _82 = (_498 * _269) + _82;
        _170.z = _82 * _239.z;
        float3 _540 = max(_170.xyz, 0.0f.xxx);
        _141 = float4(_540.x, _540.y, _540.z, _141.w);
        float3 _546 = _141.xyz + 1.0f.xxx;
        _170 = float4(_546.x, _546.y, _546.z, _170.w);
        float3 _553 = _141.xyz * _170.xyz;
        _141 = float4(_553.x, _553.y, _553.z, _141.w);
        _82 = 0.0f;
        for (int _557 = 0; _557 < _26_m7; _557++)
        {
            float3 _576 = _9 + (-_26_m5[_557].xyz);
            _170 = float4(_576.x, _576.y, _576.z, _170.w);
            _389 = dot(_170.xyz, _170.xyz);
            _389 = sqrt(_389);
            _170.x = max(9.9999997473787516355514526367188e-05f, _26_m5[_557].w);
            _389 /= _170.x;
            _389 = (-_389) + 1.0f;
            _389 = max(_389, 0.0f);
            _170.x = _389 * _389;
            _389 = ((-_389) * 2.0f) + 3.0f;
            _389 *= _170.x;
            _389 *= _26_m6[_557].x;
            _82 = max(_82, _389);
        }
        _82 = (-_82) + 1.0f;
        float3 _632 = _82.xxx * _141.xyz;
        _170 = float4(_632.x, _632.y, _632.z, _170.w);
        _635 = dot(_170.xyz, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
        float3 _651 = (_141.xyz * _82.xxx) + (-_635.xxx);
        _141 = float4(_651.x, _651.y, _651.z, _141.w);
        float3 _663 = (_26_m9.xxx * _141.xyz) + _635.xxx;
        _141 = float4(_663.x, _663.y, _663.z, _141.w);
        vs_TEXCOORD3 = _141.xyz;
    }
    else
    {
        vs_TEXCOORD3 = 0.0f.xxx;
    }
    _82 = _93.z / _26_m0.y;
    _82 = (-_82) + 1.0f;
    _82 *= _26_m0.z;
    _82 = max(_82, 0.0f);
    _82 *= _26_m4.x;
    _82 *= (-_82);
    vs_TEXCOORD4 = exp2(_82);
    gl_Position = _93;
    vs_TEXCOORD1 = _9;
    vs_TEXCOORD2 = _57;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _59 = stage_input._59;
    _121 = stage_input._121;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
float4 _Color;
float _BlackPoint;
float _WhitePoint;
float _Opacity;
float _DarkClear;
float _InsideShade;
float _DoubleSided;
float _MirroredMesh;
float _Lighting;
float _Emission;
float4 _RimColor;
float _RimPower;
float _RimStrength;
float _PulseSpeed;
float _PulseAmount;
float _Waver;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_FogColor
#define _17_m3 _FadeNear
#define _17_m4 _FadeFar
#define _17_m5 _GhostSeeAll
#define _17_m6 _Color
#define _17_m7 _BlackPoint
#define _17_m8 _WhitePoint
#define _17_m9 _Opacity
#define _17_m10 _DarkClear
#define _17_m11 _InsideShade
#define _17_m12 _DoubleSided
#define _17_m13 _MirroredMesh
#define _17_m14 _Lighting
#define _17_m15 _Emission
#define _17_m16 _RimColor
#define _17_m17 _RimPower
#define _17_m18 _RimStrength
#define _17_m19 _PulseSpeed
#define _17_m20 _PulseAmount
#define _17_m21 _Waver


Texture2D<float4> _BaseMap;
SamplerState sampler_BaseMap;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _456;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _456 : SV_Target0;
};

static float4 _9;
static float _27;
static float3 _49;
static float2 _90;
static float2 _115;
static float3 _137;
static float _153;
static float3 _260;
static float _277;
static float4 _352;

void frag_inner()
{
    float3 _23 = (-vs_TEXCOORD1) + _17_m1;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = dot(_9.xyz, _9.xyz);
    _27 = rsqrt(_27);
    float3 _39 = _27.xxx * _9.xyz;
    _9 = float4(_39.x, _39.y, _39.z, _9.w);
    _27 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _27 = rsqrt(_27);
    _49 = _27.xxx * vs_TEXCOORD2;
    _9.x = dot(_49, _9.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _17_m17;
    _9.x = exp2(_9.x);
    bool2 _102 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u).xx;
    _90 = float2(_102.x ? float2(0.0f, 1.0f).x : float2(1.0f, -1.0f).x, _102.y ? float2(0.0f, 1.0f).y : float2(1.0f, -1.0f).y);
    _9.y = (_17_m13 * _90.y) + _90.x;
    _115.x = (-_17_m12) + 1.0f;
    _115.y = ((-_9.y) * _115.x) + 1.0f;
    float2 _134 = _115.yx * _9.xy;
    _9 = float4(_134.x, _134.y, _9.z, _9.w);
    _137 = _BaseMap.Sample(sampler_BaseMap, vs_TEXCOORD0).xyz;
    _153 = dot(_137, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    _153 = sqrt(_153);
    _115.x = _153 + (-_17_m7);
    _27 = (-_17_m7) + _17_m8;
    _27 = max(_27, 0.001000000047497451305389404296875f);
    _115.x /= _27;
    _115.x = clamp(_115.x, 0.0f, 1.0f);
    _153 = _115.x * _115.x;
    _115.x = (_115.x * _115.x) + (-1.0f);
    _115.x = (_17_m10 * _115.x) + 1.0f;
    _115.x *= _17_m9;
    _9.x *= _153;
    _49 = _153.xxx * _17_m6.xyz;
    _9.x *= _17_m18;
    _27 = _17_m0.y * _17_m19;
    _27 = sin(_27);
    _27 = (_27 * 0.5f) + 0.5f;
    _27 = ((-_17_m20) * _27) + 1.0f;
    _9.x = _27 * _9.x;
    _260 = vs_TEXCOORD1 + (-_17_m1);
    _27 = dot(_260, _260);
    _27 = sqrt(_27);
    _27 = (-_27) + _17_m4;
    _277 = (-_17_m3) + _17_m4;
    _277 = max(_277, 0.001000000047497451305389404296875f);
    _27 /= _277;
    _27 = clamp(_27, 0.0f, 1.0f);
    _27 = max(_27, _17_m5);
    _9.x = _27 * _9.x;
    _260 = _9.xxx * _17_m16.xyz;
    _9.x = _17_m0.y * 2.5f;
    _9.x = (vs_TEXCOORD1.y * 9.0f) + (-_9.x);
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = ((-_17_m21) * _9.x) + 1.0f;
    _9.x *= _115.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _352.w = _27 * _9.x;
    float3 _386 = (vs_TEXCOORD3 * float3(float3(_17_m14, _17_m14, _17_m14))) + float3(float3(_17_m15, _17_m15, _17_m15));
    _9 = float4(_386.x, _9.y, _386.y, _386.z);
    float3 _392 = _9.xzw * _49;
    _9 = float4(_392.x, _9.y, _392.y, _392.z);
    _49.x = _17_m11 + (-1.0f);
    _90.x = (_9.y * _49.x) + 1.0f;
    float3 _411 = _90.xxx * _9.xzw;
    _9 = float4(_411.x, _411.y, _411.z, _9.w);
    float3 _420 = (_9.xyz * _352.www) + _260;
    _9 = float4(_420.x, _420.y, _420.z, _9.w);
    float3 _433 = ((-_17_m2.xyz) * _352.www) + _9.xyz;
    _9 = float4(_433.x, _433.y, _433.z, _9.w);
    _49 = _352.www * _17_m2.xyz;
    _27 = vs_TEXCOORD4;
    _27 = clamp(_27, 0.0f, 1.0f);
    float3 _452 = (_27.xxx * _9.xyz) + _49;
    _352 = float4(_452.x, _452.y, _452.z, _352.w);
    _456 = _352;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._456 = _456;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _26_m1[4];
float4x4 unity_WorldToObject;
static float4 _26_m2[4];
float4x4 unity_MatrixVP;
static float4 _26_m3[4];
float4 unity_FogParams;
float4 _FlickerZones[8];
float4 _FlickerState[8];
float _FlickerZoneCount;
float4 _BaseMap_ST;
float _LightColor;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _26_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _26_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _26_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _26_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _26_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _26_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _26_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _26_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _26_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _26_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _26_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _26_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _26_m0 _ProjectionParams
#define _26_m4 unity_FogParams
#define _26_m5 _FlickerZones
#define _26_m6 _FlickerState
#define _26_m7 _FlickerZoneCount
#define _26_m8 _BaseMap_ST
#define _26_m9 _LightColor
#define _26_m10 _VolumeMin
#define _26_m11 _VolumeInvSize
#define _26_m12 _GlobalVolumeMin
#define _26_m13 _GlobalVolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _12;
static float3 _59;
static float2 vs_TEXCOORD0;
static float2 _121;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _12 : POSITION;
    float3 _59 : NORMAL;
    float2 _121 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float3 _57;
static float _82;
static float4 _93;
static bool _134;
static float4 _141;
static float4 _170;
static float4 _222;
static float3 _239;
static float3 _250;
static float _269;
static float _308;
static float _389;
static float _401;
static float _498;
static float _635;
static int _723;
static bool _724;

void vert_inner()
{
    __unity_init();
    _9 = _12.yyy * _26_m1[1].xyz;
    _9 = (_26_m1[0].xyz * _12.xxx) + _9;
    _9 = (_26_m1[2].xyz * _12.zzz) + _9;
    _9 += _26_m1[3].xyz;
    _57.x = dot(_59, _26_m2[0].xyz);
    _57.y = dot(_59, _26_m2[1].xyz);
    _57.z = dot(_59, _26_m2[2].xyz);
    _82 = dot(_57, _57);
    _82 = rsqrt(_82);
    _57 = _82.xxx * _57;
    _93 = _9.yyyy * _26_m3[1];
    _93 = (_26_m3[0] * _9.xxxx) + _93;
    _93 = (_26_m3[2] * _9.zzzz) + _93;
    _93 += _26_m3[3];
    vs_TEXCOORD0 = (_121 * _26_m8.xy) + _26_m8.zw;
    _134 = 1000000.0f < _26_m11.x;
    float3 _144;
    if (_134)
    {
        _144 = _26_m12;
    }
    else
    {
        _144 = float3(_26_m10.x, _26_m10.y, _26_m10.z);
    }
    _141 = float4(_144.x, _144.y, _144.z, _141.w);
    float3 _167 = _9 + (-_141.xyz);
    _141 = float4(_167.x, _167.y, _167.z, _141.w);
    float3 _172;
    if (_134)
    {
        _172 = _26_m13;
    }
    else
    {
        _172 = _26_m11;
    }
    _170 = float4(_172.x, _172.y, _172.z, _170.w);
    float3 _188 = _141.xyz * _170.xyz;
    _141 = float4(_188.x, _188.y, _188.z, _141.w);
    _170 = _Volume0.SampleLevel(sampler_Volume0, _141.xyz, 0.0f).xywz;
    _82 = _170.y + _170.x;
    _82 = _170.w + _82;
    _134 = 9.9999997473787516355514526367188e-06f < _82;
    if (_134)
    {
        _222 = _Volume1.SampleLevel(sampler_Volume0, _141.xyz, 0.0f).yxwz;
        _141 = _Volume2.SampleLevel(sampler_Volume0, _141.xyz, 0.0f).xzwy;
        _239 = max(_170.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _170.x = _222.y;
        _170.y = _141.x;
        _250 = _170.xyz * 0.5f.xxx;
        _82 = dot(_250, _250);
        _82 = sqrt(_82);
        float3 _266 = (_170.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _170 = float4(_266.x, _266.y, _266.z, _170.w);
        _269 = dot(_170.xyz, _170.xyz);
        _269 = rsqrt(_269);
        float3 _281 = _269.xxx * _170.xyz;
        _170 = float4(_281.x, _281.y, _281.z, _170.w);
        _269 = dot(_170.xyz, _57);
        _269 = (_269 * 0.5f) + 0.5f;
        _269 = clamp(_269, 0.0f, 1.0f);
        _170.x = _82 + _82;
        _170.x /= _239.x;
        _82 /= _239.x;
        _308 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _308 / _82;
        _308 = (-_82) + 1.0f;
        float2 _324 = _170.xx + float2(1.0f, 2.0f);
        _170 = float4(_324.x, _170.y, _324.y, _170.w);
        _308 = _170.z * _308;
        _269 = log2(_269);
        _269 *= _170.x;
        _269 = exp2(_269);
        _82 = (_308 * _269) + _82;
        _170.x = _82 * _239.x;
        _222.y = _141.w;
        _250 = _222.xyz * 0.5f.xxx;
        _82 = dot(_250, _250);
        _82 = sqrt(_82);
        float3 _363 = (_222.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _222 = float4(_363.x, _363.y, _363.z, _222.w);
        _269 = dot(_222.xyz, _222.xyz);
        _269 = rsqrt(_269);
        float3 _377 = _269.xxx * _222.xyz;
        _222 = float4(_377.x, _377.y, _377.z, _222.w);
        _269 = dot(_222.xyz, _57);
        _269 = (_269 * 0.5f) + 0.5f;
        _269 = clamp(_269, 0.0f, 1.0f);
        _389 = _82 + _82;
        _389 /= _239.y;
        _82 /= _239.y;
        _401 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _401 / _82;
        _401 = (-_82) + 1.0f;
        float2 _415 = _389.xx + float2(1.0f, 2.0f);
        _222 = float4(_415.x, _415.y, _222.z, _222.w);
        _389 = _401 * _222.y;
        _269 = log2(_269);
        _269 *= _222.x;
        _269 = exp2(_269);
        _82 = (_389 * _269) + _82;
        _170.y = _82 * _239.y;
        _141.x = _222.w;
        float3 _445 = _141.xyz * 0.5f.xxx;
        _222 = float4(_445.x, _445.y, _445.z, _222.w);
        _82 = dot(_222.xyz, _222.xyz);
        _82 = sqrt(_82);
        float3 _458 = (_141.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _141 = float4(_458.x, _458.y, _458.z, _141.w);
        _269 = dot(_141.xyz, _141.xyz);
        _269 = rsqrt(_269);
        float3 _472 = _269.xxx * _141.xyz;
        _141 = float4(_472.x, _472.y, _472.z, _141.w);
        _269 = dot(_141.xyz, _57);
        _269 = (_269 * 0.5f) + 0.5f;
        _269 = clamp(_269, 0.0f, 1.0f);
        _141.x = _82 + _82;
        _141.x /= _239.z;
        _82 /= _239.z;
        _498 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _498 / _82;
        _498 = (-_82) + 1.0f;
        float2 _512 = _141.xx + float2(1.0f, 2.0f);
        _141 = float4(_512.x, _141.y, _512.y, _141.w);
        _498 = _141.z * _498;
        _269 = log2(_269);
        _269 *= _141.x;
        _269 = exp2(_269);
        _82 = (_498 * _269) + _82;
        _170.z = _82 * _239.z;
        float3 _540 = max(_170.xyz, 0.0f.xxx);
        _141 = float4(_540.x, _540.y, _540.z, _141.w);
        float3 _546 = _141.xyz + 1.0f.xxx;
        _170 = float4(_546.x, _546.y, _546.z, _170.w);
        float3 _553 = _141.xyz * _170.xyz;
        _141 = float4(_553.x, _553.y, _553.z, _141.w);
        _82 = 0.0f;
        for (int _557 = 0; _557 < _26_m7; _557++)
        {
            float3 _576 = _9 + (-_26_m5[_557].xyz);
            _170 = float4(_576.x, _576.y, _576.z, _170.w);
            _389 = dot(_170.xyz, _170.xyz);
            _389 = sqrt(_389);
            _170.x = max(9.9999997473787516355514526367188e-05f, _26_m5[_557].w);
            _389 /= _170.x;
            _389 = (-_389) + 1.0f;
            _389 = max(_389, 0.0f);
            _170.x = _389 * _389;
            _389 = ((-_389) * 2.0f) + 3.0f;
            _389 *= _170.x;
            _389 *= _26_m6[_557].x;
            _82 = max(_82, _389);
        }
        _82 = (-_82) + 1.0f;
        float3 _632 = _82.xxx * _141.xyz;
        _170 = float4(_632.x, _632.y, _632.z, _170.w);
        _635 = dot(_170.xyz, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
        float3 _651 = (_141.xyz * _82.xxx) + (-_635.xxx);
        _141 = float4(_651.x, _651.y, _651.z, _141.w);
        float3 _663 = (_26_m9.xxx * _141.xyz) + _635.xxx;
        _141 = float4(_663.x, _663.y, _663.z, _141.w);
        vs_TEXCOORD3 = _141.xyz;
    }
    else
    {
        vs_TEXCOORD3 = 0.0f.xxx;
    }
    _82 = _93.z / _26_m0.y;
    _82 = (-_82) + 1.0f;
    _82 *= _26_m0.z;
    _82 = max(_82, 0.0f);
    vs_TEXCOORD4 = (_82 * _26_m4.z) + _26_m4.w;
    gl_Position = _93;
    vs_TEXCOORD1 = _9;
    vs_TEXCOORD2 = _57;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _59 = stage_input._59;
    _121 = stage_input._121;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
float4 _Color;
float _BlackPoint;
float _WhitePoint;
float _Opacity;
float _DarkClear;
float _InsideShade;
float _DoubleSided;
float _MirroredMesh;
float _Lighting;
float _Emission;
float4 _RimColor;
float _RimPower;
float _RimStrength;
float _PulseSpeed;
float _PulseAmount;
float _Waver;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 unity_FogColor
#define _17_m3 _FadeNear
#define _17_m4 _FadeFar
#define _17_m5 _GhostSeeAll
#define _17_m6 _Color
#define _17_m7 _BlackPoint
#define _17_m8 _WhitePoint
#define _17_m9 _Opacity
#define _17_m10 _DarkClear
#define _17_m11 _InsideShade
#define _17_m12 _DoubleSided
#define _17_m13 _MirroredMesh
#define _17_m14 _Lighting
#define _17_m15 _Emission
#define _17_m16 _RimColor
#define _17_m17 _RimPower
#define _17_m18 _RimStrength
#define _17_m19 _PulseSpeed
#define _17_m20 _PulseAmount
#define _17_m21 _Waver


Texture2D<float4> _BaseMap;
SamplerState sampler_BaseMap;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD4;
static float4 _456;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _456 : SV_Target0;
};

static float4 _9;
static float _27;
static float3 _49;
static float2 _90;
static float2 _115;
static float3 _137;
static float _153;
static float3 _260;
static float _277;
static float4 _352;

void frag_inner()
{
    float3 _23 = (-vs_TEXCOORD1) + _17_m1;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = dot(_9.xyz, _9.xyz);
    _27 = rsqrt(_27);
    float3 _39 = _27.xxx * _9.xyz;
    _9 = float4(_39.x, _39.y, _39.z, _9.w);
    _27 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _27 = rsqrt(_27);
    _49 = _27.xxx * vs_TEXCOORD2;
    _9.x = dot(_49, _9.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _17_m17;
    _9.x = exp2(_9.x);
    bool2 _102 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u).xx;
    _90 = float2(_102.x ? float2(0.0f, 1.0f).x : float2(1.0f, -1.0f).x, _102.y ? float2(0.0f, 1.0f).y : float2(1.0f, -1.0f).y);
    _9.y = (_17_m13 * _90.y) + _90.x;
    _115.x = (-_17_m12) + 1.0f;
    _115.y = ((-_9.y) * _115.x) + 1.0f;
    float2 _134 = _115.yx * _9.xy;
    _9 = float4(_134.x, _134.y, _9.z, _9.w);
    _137 = _BaseMap.Sample(sampler_BaseMap, vs_TEXCOORD0).xyz;
    _153 = dot(_137, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    _153 = sqrt(_153);
    _115.x = _153 + (-_17_m7);
    _27 = (-_17_m7) + _17_m8;
    _27 = max(_27, 0.001000000047497451305389404296875f);
    _115.x /= _27;
    _115.x = clamp(_115.x, 0.0f, 1.0f);
    _153 = _115.x * _115.x;
    _115.x = (_115.x * _115.x) + (-1.0f);
    _115.x = (_17_m10 * _115.x) + 1.0f;
    _115.x *= _17_m9;
    _9.x *= _153;
    _49 = _153.xxx * _17_m6.xyz;
    _9.x *= _17_m18;
    _27 = _17_m0.y * _17_m19;
    _27 = sin(_27);
    _27 = (_27 * 0.5f) + 0.5f;
    _27 = ((-_17_m20) * _27) + 1.0f;
    _9.x = _27 * _9.x;
    _260 = vs_TEXCOORD1 + (-_17_m1);
    _27 = dot(_260, _260);
    _27 = sqrt(_27);
    _27 = (-_27) + _17_m4;
    _277 = (-_17_m3) + _17_m4;
    _277 = max(_277, 0.001000000047497451305389404296875f);
    _27 /= _277;
    _27 = clamp(_27, 0.0f, 1.0f);
    _27 = max(_27, _17_m5);
    _9.x = _27 * _9.x;
    _260 = _9.xxx * _17_m16.xyz;
    _9.x = _17_m0.y * 2.5f;
    _9.x = (vs_TEXCOORD1.y * 9.0f) + (-_9.x);
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = ((-_17_m21) * _9.x) + 1.0f;
    _9.x *= _115.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _352.w = _27 * _9.x;
    float3 _386 = (vs_TEXCOORD3 * float3(float3(_17_m14, _17_m14, _17_m14))) + float3(float3(_17_m15, _17_m15, _17_m15));
    _9 = float4(_386.x, _9.y, _386.y, _386.z);
    float3 _392 = _9.xzw * _49;
    _9 = float4(_392.x, _9.y, _392.y, _392.z);
    _49.x = _17_m11 + (-1.0f);
    _90.x = (_9.y * _49.x) + 1.0f;
    float3 _411 = _90.xxx * _9.xzw;
    _9 = float4(_411.x, _411.y, _411.z, _9.w);
    float3 _420 = (_9.xyz * _352.www) + _260;
    _9 = float4(_420.x, _420.y, _420.z, _9.w);
    float3 _433 = ((-_17_m2.xyz) * _352.www) + _9.xyz;
    _9 = float4(_433.x, _433.y, _433.z, _9.w);
    _49 = _352.www * _17_m2.xyz;
    _27 = vs_TEXCOORD4;
    _27 = clamp(_27, 0.0f, 1.0f);
    float3 _452 = (_27.xxx * _9.xyz) + _49;
    _352 = float4(_452.x, _452.y, _452.z, _352.w);
    _456 = _352;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._456 = _456;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _26_m0[4];
float4x4 unity_WorldToObject;
static float4 _26_m1[4];
float4x4 unity_MatrixVP;
static float4 _26_m2[4];
float4 _FlickerZones[8];
float4 _FlickerState[8];
float _FlickerZoneCount;
float4 _BaseMap_ST;
float _LightColor;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _26_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _26_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _26_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _26_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _26_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _26_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _26_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _26_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _26_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _26_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _26_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _26_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _26_m3 _FlickerZones
#define _26_m4 _FlickerState
#define _26_m5 _FlickerZoneCount
#define _26_m6 _BaseMap_ST
#define _26_m7 _LightColor
#define _26_m8 _VolumeMin
#define _26_m9 _VolumeInvSize
#define _26_m10 _GlobalVolumeMin
#define _26_m11 _GlobalVolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float4 gl_Position;
static float4 _12;
static float3 _59;
static float2 vs_TEXCOORD0;
static float2 _127;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _12 : POSITION;
    float3 _59 : NORMAL;
    float2 _127 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float3 _9;
static float3 _57;
static float _82;
static float4 _93;
static bool _140;
static float4 _175;
static float4 _227;
static float3 _244;
static float3 _255;
static float _274;
static float _313;
static float _394;
static float _406;
static float _503;
static float _639;
static int _697;
static bool _698;

void vert_inner()
{
    __unity_init();
    _9 = _12.yyy * _26_m0[1].xyz;
    _9 = (_26_m0[0].xyz * _12.xxx) + _9;
    _9 = (_26_m0[2].xyz * _12.zzz) + _9;
    _9 += _26_m0[3].xyz;
    _57.x = dot(_59, _26_m1[0].xyz);
    _57.y = dot(_59, _26_m1[1].xyz);
    _57.z = dot(_59, _26_m1[2].xyz);
    _82 = dot(_57, _57);
    _82 = rsqrt(_82);
    _57 = _82.xxx * _57;
    _93 = _9.yyyy * _26_m2[1];
    _93 = (_26_m2[0] * _9.xxxx) + _93;
    _93 = (_26_m2[2] * _9.zzzz) + _93;
    gl_Position = _93 + _26_m2[3];
    vs_TEXCOORD0 = (_127 * _26_m6.xy) + _26_m6.zw;
    _140 = 1000000.0f < _26_m9.x;
    float3 _149;
    if (_140)
    {
        _149 = _26_m10;
    }
    else
    {
        _149 = float3(_26_m8.x, _26_m8.y, _26_m8.z);
    }
    _93 = float4(_149.x, _149.y, _149.z, _93.w);
    float3 _172 = _9 + (-_93.xyz);
    _93 = float4(_172.x, _172.y, _172.z, _93.w);
    float3 _177;
    if (_140)
    {
        _177 = _26_m11;
    }
    else
    {
        _177 = _26_m9;
    }
    _175 = float4(_177.x, _177.y, _177.z, _175.w);
    float3 _193 = _93.xyz * _175.xyz;
    _93 = float4(_193.x, _193.y, _193.z, _93.w);
    _175 = _Volume0.SampleLevel(sampler_Volume0, _93.xyz, 0.0f).xywz;
    _82 = _175.y + _175.x;
    _82 = _175.w + _82;
    _140 = 9.9999997473787516355514526367188e-06f < _82;
    if (_140)
    {
        _227 = _Volume1.SampleLevel(sampler_Volume0, _93.xyz, 0.0f).yxwz;
        _93 = _Volume2.SampleLevel(sampler_Volume0, _93.xyz, 0.0f).xzwy;
        _244 = max(_175.xyw, 9.9999997473787516355514526367188e-06f.xxx);
        _175.x = _227.y;
        _175.y = _93.x;
        _255 = _175.xyz * 0.5f.xxx;
        _82 = dot(_255, _255);
        _82 = sqrt(_82);
        float3 _271 = (_175.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _175 = float4(_271.x, _271.y, _271.z, _175.w);
        _274 = dot(_175.xyz, _175.xyz);
        _274 = rsqrt(_274);
        float3 _286 = _274.xxx * _175.xyz;
        _175 = float4(_286.x, _286.y, _286.z, _175.w);
        _274 = dot(_175.xyz, _57);
        _274 = (_274 * 0.5f) + 0.5f;
        _274 = clamp(_274, 0.0f, 1.0f);
        _175.x = _82 + _82;
        _175.x /= _244.x;
        _82 /= _244.x;
        _313 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _313 / _82;
        _313 = (-_82) + 1.0f;
        float2 _329 = _175.xx + float2(1.0f, 2.0f);
        _175 = float4(_329.x, _175.y, _329.y, _175.w);
        _313 = _175.z * _313;
        _274 = log2(_274);
        _274 *= _175.x;
        _274 = exp2(_274);
        _82 = (_313 * _274) + _82;
        _175.x = _82 * _244.x;
        _227.y = _93.w;
        _255 = _227.xyz * 0.5f.xxx;
        _82 = dot(_255, _255);
        _82 = sqrt(_82);
        float3 _368 = (_227.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _227 = float4(_368.x, _368.y, _368.z, _227.w);
        _274 = dot(_227.xyz, _227.xyz);
        _274 = rsqrt(_274);
        float3 _382 = _274.xxx * _227.xyz;
        _227 = float4(_382.x, _382.y, _382.z, _227.w);
        _274 = dot(_227.xyz, _57);
        _274 = (_274 * 0.5f) + 0.5f;
        _274 = clamp(_274, 0.0f, 1.0f);
        _394 = _82 + _82;
        _394 /= _244.y;
        _82 /= _244.y;
        _406 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _406 / _82;
        _406 = (-_82) + 1.0f;
        float2 _420 = _394.xx + float2(1.0f, 2.0f);
        _227 = float4(_420.x, _420.y, _227.z, _227.w);
        _394 = _406 * _227.y;
        _274 = log2(_274);
        _274 *= _227.x;
        _274 = exp2(_274);
        _82 = (_394 * _274) + _82;
        _175.y = _82 * _244.y;
        _93.x = _227.w;
        float3 _450 = _93.xyz * 0.5f.xxx;
        _227 = float4(_450.x, _450.y, _450.z, _227.w);
        _82 = dot(_227.xyz, _227.xyz);
        _82 = sqrt(_82);
        float3 _463 = (_93.xyz * 0.5f.xxx) + 9.9999999747524270787835121154785e-07f.xxx;
        _93 = float4(_463.x, _463.y, _463.z, _93.w);
        _274 = dot(_93.xyz, _93.xyz);
        _274 = rsqrt(_274);
        float3 _477 = _274.xxx * _93.xyz;
        _93 = float4(_477.x, _477.y, _477.z, _93.w);
        _274 = dot(_93.xyz, _57);
        _274 = (_274 * 0.5f) + 0.5f;
        _274 = clamp(_274, 0.0f, 1.0f);
        _93.x = _82 + _82;
        _93.x /= _244.z;
        _82 /= _244.z;
        _503 = (-_82) + 1.0f;
        _82 += 1.0f;
        _82 = _503 / _82;
        _503 = (-_82) + 1.0f;
        float2 _517 = _93.xx + float2(1.0f, 2.0f);
        _93 = float4(_517.x, _93.y, _517.y, _93.w);
        _503 = _93.z * _503;
        _274 = log2(_274);
        _274 *= _93.x;
        _274 = exp2(_274);
        _82 = (_503 * _274) + _82;
        _175.z = _82 * _244.z;
        float3 _545 = max(_175.xyz, 0.0f.xxx);
        _93 = float4(_545.x, _545.y, _545.z, _93.w);
        float3 _551 = _93.xyz + 1.0f.xxx;
        _175 = float4(_551.x, _551.y, _551.z, _175.w);
        float3 _558 = _93.xyz * _175.xyz;
        _93 = float4(_558.x, _558.y, _558.z, _93.w);
        _82 = 0.0f;
        for (int _562 = 0; _562 < _26_m5; _562++)
        {
            float3 _580 = _9 + (-_26_m3[_562].xyz);
            _175 = float4(_580.x, _580.y, _580.z, _175.w);
            _394 = dot(_175.xyz, _175.xyz);
            _394 = sqrt(_394);
            _175.x = max(9.9999997473787516355514526367188e-05f, _26_m3[_562].w);
            _394 /= _175.x;
            _394 = (-_394) + 1.0f;
            _394 = max(_394, 0.0f);
            _175.x = _394 * _394;
            _394 = ((-_394) * 2.0f) + 3.0f;
            _394 *= _175.x;
            _394 *= _26_m4[_562].x;
            _82 = max(_82, _394);
        }
        _82 = (-_82) + 1.0f;
        float3 _636 = _82.xxx * _93.xyz;
        _175 = float4(_636.x, _636.y, _636.z, _175.w);
        _639 = dot(_175.xyz, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
        float3 _655 = (_93.xyz * _82.xxx) + (-_639.xxx);
        _93 = float4(_655.x, _655.y, _655.z, _93.w);
        float3 _667 = (_26_m7.xxx * _93.xyz) + _639.xxx;
        _93 = float4(_667.x, _667.y, _667.z, _93.w);
        vs_TEXCOORD3 = _93.xyz;
    }
    else
    {
        vs_TEXCOORD3 = 0.0f.xxx;
    }
    vs_TEXCOORD1 = _9;
    vs_TEXCOORD2 = _57;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _59 = stage_input._59;
    _127 = stage_input._127;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _Time;
float3 _WorldSpaceCameraPos;
float _FadeNear;
float _FadeFar;
float _GhostSeeAll;
float4 _Color;
float _BlackPoint;
float _WhitePoint;
float _Opacity;
float _DarkClear;
float _InsideShade;
float _DoubleSided;
float _MirroredMesh;
float _Lighting;
float _Emission;
float4 _RimColor;
float _RimPower;
float _RimStrength;
float _PulseSpeed;
float _PulseAmount;
float _Waver;
#define _17_m0 _Time
#define _17_m1 _WorldSpaceCameraPos
#define _17_m2 _FadeNear
#define _17_m3 _FadeFar
#define _17_m4 _GhostSeeAll
#define _17_m5 _Color
#define _17_m6 _BlackPoint
#define _17_m7 _WhitePoint
#define _17_m8 _Opacity
#define _17_m9 _DarkClear
#define _17_m10 _InsideShade
#define _17_m11 _DoubleSided
#define _17_m12 _MirroredMesh
#define _17_m13 _Lighting
#define _17_m14 _Emission
#define _17_m15 _RimColor
#define _17_m16 _RimPower
#define _17_m17 _RimStrength
#define _17_m18 _PulseSpeed
#define _17_m19 _PulseAmount
#define _17_m20 _Waver


Texture2D<float4> _BaseMap;
SamplerState sampler_BaseMap;

static bool gl_FrontFacing;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float4 _424;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _424 : SV_Target0;
};

static float4 _9;
static float _27;
static float3 _49;
static float2 _90;
static float2 _115;
static float3 _137;
static float _153;
static float3 _260;
static float _277;
static float4 _352;

void frag_inner()
{
    float3 _23 = (-vs_TEXCOORD1) + _17_m1;
    _9 = float4(_23.x, _23.y, _23.z, _9.w);
    _27 = dot(_9.xyz, _9.xyz);
    _27 = rsqrt(_27);
    float3 _39 = _27.xxx * _9.xyz;
    _9 = float4(_39.x, _39.y, _39.z, _9.w);
    _27 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _27 = rsqrt(_27);
    _49 = _27.xxx * vs_TEXCOORD2;
    _9.x = dot(_49, _9.xyz);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _9.x = log2(_9.x);
    _9.x *= _17_m16;
    _9.x = exp2(_9.x);
    bool2 _102 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u).xx;
    _90 = float2(_102.x ? float2(0.0f, 1.0f).x : float2(1.0f, -1.0f).x, _102.y ? float2(0.0f, 1.0f).y : float2(1.0f, -1.0f).y);
    _9.y = (_17_m12 * _90.y) + _90.x;
    _115.x = (-_17_m11) + 1.0f;
    _115.y = ((-_9.y) * _115.x) + 1.0f;
    float2 _134 = _115.yx * _9.xy;
    _9 = float4(_134.x, _134.y, _9.z, _9.w);
    _137 = _BaseMap.Sample(sampler_BaseMap, vs_TEXCOORD0).xyz;
    _153 = dot(_137, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    _153 = sqrt(_153);
    _115.x = _153 + (-_17_m6);
    _27 = (-_17_m6) + _17_m7;
    _27 = max(_27, 0.001000000047497451305389404296875f);
    _115.x /= _27;
    _115.x = clamp(_115.x, 0.0f, 1.0f);
    _153 = _115.x * _115.x;
    _115.x = (_115.x * _115.x) + (-1.0f);
    _115.x = (_17_m9 * _115.x) + 1.0f;
    _115.x *= _17_m8;
    _9.x *= _153;
    _49 = _153.xxx * _17_m5.xyz;
    _9.x *= _17_m17;
    _27 = _17_m0.y * _17_m18;
    _27 = sin(_27);
    _27 = (_27 * 0.5f) + 0.5f;
    _27 = ((-_17_m19) * _27) + 1.0f;
    _9.x = _27 * _9.x;
    _260 = vs_TEXCOORD1 + (-_17_m1);
    _27 = dot(_260, _260);
    _27 = sqrt(_27);
    _27 = (-_27) + _17_m3;
    _277 = (-_17_m2) + _17_m3;
    _277 = max(_277, 0.001000000047497451305389404296875f);
    _27 /= _277;
    _27 = clamp(_27, 0.0f, 1.0f);
    _27 = max(_27, _17_m4);
    _9.x = _27 * _9.x;
    _260 = _9.xxx * _17_m15.xyz;
    _9.x = _17_m0.y * 2.5f;
    _9.x = (vs_TEXCOORD1.y * 9.0f) + (-_9.x);
    _9.x = sin(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _9.x = ((-_17_m20) * _9.x) + 1.0f;
    _9.x *= _115.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _352.w = _27 * _9.x;
    float3 _386 = (vs_TEXCOORD3 * float3(float3(_17_m13, _17_m13, _17_m13))) + float3(float3(_17_m14, _17_m14, _17_m14));
    _9 = float4(_386.x, _9.y, _386.y, _386.z);
    float3 _392 = _9.xzw * _49;
    _9 = float4(_392.x, _9.y, _392.y, _392.z);
    _49.x = _17_m10 + (-1.0f);
    _90.x = (_9.y * _49.x) + 1.0f;
    float3 _411 = _90.xxx * _9.xzw;
    _9 = float4(_411.x, _411.y, _411.z, _9.w);
    float3 _420 = (_9.xyz * _352.www) + _260;
    _352 = float4(_420.x, _420.y, _420.z, _352.w);
    _424 = _352;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._424 = _424;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}