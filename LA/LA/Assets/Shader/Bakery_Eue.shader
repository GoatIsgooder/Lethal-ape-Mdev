// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Bakery/Eue" {
Properties {

[Toggle(_IS_OPPOSITE)] _IS_OPPOSITE ("Is Opposite", Float) = 0.0

_Color ("Color", Color) = (1,1,1,1)

_Pupil_Size ("Pupil Size", Range(0, 1)) = 0.5

_Pupil_Sharpness ("Pupil Sharpness", Vector) = (0,1,0,0)

_Eye_Back_Size ("Eye Back Size", Float) = 1.2999999523162842

_Eye_Bk ("Eye Back Color", Color) = (0,0,0,1)

[Toggle(BAKERY_VOLUME)] _BAKERY_VOLUME ("Use Bakery Volume", Float) = 0.0

[Toggle(BAKERY_VOLROTATION)] _BAKERY_VOLROTATION ("Support Runtime Volume Rotation", Float) = 0.0

_Volume0 ("Volume 0", 3D) = "black" { }

_Volume1 ("Volume 1", 3D) = "black" { }

_Volume2 ("Volume 2", 3D) = "black" { }

_VolumeMask ("Volume Mask", 3D) = "white" { }

_VolumeMin ("Volume Min", Vector) = (0,0,0,0)

_VolumeInvSize ("Volume Inv Size", Vector) = (1000000.0,1000000.0,1000000.0,0)

_VolumeInfluence ("Volume Influence", Range(0, 1)) = 0.5

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
 Name "FORWARD"
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ BAKERY_COMPRESSED_VOLUME
#pragma multi_compile_local __ BAKERY_VOLUME
#pragma multi_compile_local __ _IS_OPPOSITE
#if defined(BAKERY_COMPRESSED_VOLUME) && defined(BAKERY_VOLUME) && defined(FOG_EXP) && defined(_IS_OPPOSITE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _137;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _137 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _156;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    _9.x = dot(_137, _21_m2[0].xyz);
    _9.y = dot(_137, _21_m2[1].xyz);
    _9.z = dot(_137, _21_m2[2].xyz);
    _156 = dot(_9.xyz, _9.xyz);
    _156 = rsqrt(_156);
    vs_TEXCOORD0 = _156.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _137 = stage_input._137;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
float _VolumeInfluence;
float3 _VolumeMin;
float3 _VolumeInvSize;
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 unity_FogColor
#define _37_m2 _Color
#define _37_m3 _Pupil_Size
#define _37_m4 _Pupil_Sharpness
#define _37_m5 _Eye_Back_Size
#define _37_m6 _Eye_Bk
#define _37_m7 _VolumeInfluence
#define _37_m8 _VolumeMin
#define _37_m9 _VolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _369;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _369 : SV_Target0;
};

static float4 _9;
static float4 _30;
static float _46;
static float4 _61;
static float _91;
static bool _174;
static float4 _198;
static float4 _212;
static float4 _220;
static float4 _228;
static float3 _255;
static float3 _288;
static float3 _328;
static float3 _349;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD0;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    float3 _43 = (-vs_TEXCOORD1) + _37_m0;
    _30 = float4(_43.x, _43.y, _43.z, _30.w);
    _46 = dot(_30.xyz, _30.xyz);
    _46 = rsqrt(_46);
    float3 _58 = _46.xxx * _30.xyz;
    _30 = float4(_58.x, _58.y, _58.z, _30.w);
    _61.x = dot(_9.xyz, _30.xyz);
    _61.x = clamp(_61.x, 0.0f, 1.0f);
    _46 = (-_61.x) + 1.0f;
    _30.x = _37_m3 + 0.00999999977648258209228515625f;
    _61.x = _46 + (-_30.x);
    _91 = (-_30.x) + _37_m3;
    _61.x /= _91;
    _91 = (-_37_m4.x) + _37_m4.y;
    _61.x = (_61.x * _91) + _37_m4.x;
    _61.x = clamp(_61.x, 0.0f, 1.0f);
    _46 = log2(_46);
    _46 *= 0.660000026226043701171875f;
    _46 = exp2(_46);
    _91 = _46 / _37_m5;
    _91 = (-_91) + 1.0f;
    float3 _148 = ((-_37_m2.xyz) * _61.xxx) + 1.0f.xxx;
    _30 = float4(_148.x, _148.y, _148.z, _30.w);
    float3 _158 = _30.xyz + (-_37_m6.xyz);
    _61 = float4(_158.x, _61.y, _158.y, _158.z);
    float3 _169 = (_91.xxx * _61.xzw) + _37_m6.xyz;
    _61 = float4(_169.x, _169.y, _169.z, _61.w);
    _174 = 0.0f < _37_m7;
    if (_174)
    {
        float3 _187 = vs_TEXCOORD1 + (-_37_m8);
        _30 = float4(_187.x, _187.y, _187.z, _30.w);
        float3 _195 = _30.xyz * _37_m9;
        _30 = float4(_195.x, _195.y, _195.z, _30.w);
        _198 = _Volume0.Sample(sampler_Volume0, _30.xyz);
        _212 = _Volume1.Sample(sampler_Volume0, _30.xyz);
        _220 = (_212 * 2.0f.xxxx) + (-1.0f).xxxx;
        _228 = _Volume2.Sample(sampler_Volume0, _30.xyz);
        _30 = (_228.xywz * 2.0f.xxxx) + (-1.0f).xxxx;
        float3 _244 = _198.xyz * _220.xyz;
        _220 = float4(_244.x, _244.y, _244.z, _220.w);
        float3 _251 = _9.xxx * _220.xyz;
        _220 = float4(_251.x, _251.y, _251.z, _220.w);
        _255 = _198.xyz * _30.xyw;
        float3 _264 = _9.yyy * _255;
        _9 = float4(_264.x, _264.y, _9.z, _264.z);
        _30.x = _198.w;
        _30.y = _220.w;
        float3 _278 = _198.xyz * _30.xyz;
        _30 = float4(_278.x, _278.y, _278.z, _30.w);
        float3 _285 = _9.zzz * _30.xyz;
        _30 = float4(_285.x, _285.y, _285.z, _30.w);
        _288 = (_220.xyz * 2.0f.xxx) + _198.xyz;
        float3 _300 = (_9.xyw * 2.0f.xxx) + _288;
        _9 = float4(_300.x, _300.y, _300.z, _9.w);
        float3 _308 = (_30.xyz * 2.0f.xxx) + _9.xyz;
        _9 = float4(_308.x, _308.y, _308.z, _9.w);
        float3 _314 = max(_9.xyz, 0.0f.xxx);
        _9 = float4(_314.x, _314.y, _314.z, _9.w);
        float3 _325 = (_61.xyz * _9.xyz) + (-_61.xyz);
        _9 = float4(_325.x, _325.y, _325.z, _9.w);
        _328 = (_37_m7.xxx * _9.xyz) + _61.xyz;
        _61 = float4(_328.x, _328.y, _328.z, _61.w);
    }
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _349 = _61.xyz + (-_37_m1.xyz);
    float3 _365 = (_9.xxx * _349) + _37_m1.xyz;
    _9 = float4(_365.x, _365.y, _365.z, _9.w);
    _369 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _369.w);
    _369.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._369 = _369;
    return stage_output;
}

#endif
#elif defined(BAKERY_COMPRESSED_VOLUME) && defined(BAKERY_VOLUME) && defined(FOG_EXP2) && defined(_IS_OPPOSITE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _143;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _162;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    _9.x = dot(_143, _21_m2[0].xyz);
    _9.y = dot(_143, _21_m2[1].xyz);
    _9.z = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    vs_TEXCOORD0 = _162.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
float _VolumeInfluence;
float3 _VolumeMin;
float3 _VolumeInvSize;
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 unity_FogColor
#define _37_m2 _Color
#define _37_m3 _Pupil_Size
#define _37_m4 _Pupil_Sharpness
#define _37_m5 _Eye_Back_Size
#define _37_m6 _Eye_Bk
#define _37_m7 _VolumeInfluence
#define _37_m8 _VolumeMin
#define _37_m9 _VolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _369;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _369 : SV_Target0;
};

static float4 _9;
static float4 _30;
static float _46;
static float4 _61;
static float _91;
static bool _174;
static float4 _198;
static float4 _212;
static float4 _220;
static float4 _228;
static float3 _255;
static float3 _288;
static float3 _328;
static float3 _349;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD0;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    float3 _43 = (-vs_TEXCOORD1) + _37_m0;
    _30 = float4(_43.x, _43.y, _43.z, _30.w);
    _46 = dot(_30.xyz, _30.xyz);
    _46 = rsqrt(_46);
    float3 _58 = _46.xxx * _30.xyz;
    _30 = float4(_58.x, _58.y, _58.z, _30.w);
    _61.x = dot(_9.xyz, _30.xyz);
    _61.x = clamp(_61.x, 0.0f, 1.0f);
    _46 = (-_61.x) + 1.0f;
    _30.x = _37_m3 + 0.00999999977648258209228515625f;
    _61.x = _46 + (-_30.x);
    _91 = (-_30.x) + _37_m3;
    _61.x /= _91;
    _91 = (-_37_m4.x) + _37_m4.y;
    _61.x = (_61.x * _91) + _37_m4.x;
    _61.x = clamp(_61.x, 0.0f, 1.0f);
    _46 = log2(_46);
    _46 *= 0.660000026226043701171875f;
    _46 = exp2(_46);
    _91 = _46 / _37_m5;
    _91 = (-_91) + 1.0f;
    float3 _148 = ((-_37_m2.xyz) * _61.xxx) + 1.0f.xxx;
    _30 = float4(_148.x, _148.y, _148.z, _30.w);
    float3 _158 = _30.xyz + (-_37_m6.xyz);
    _61 = float4(_158.x, _61.y, _158.y, _158.z);
    float3 _169 = (_91.xxx * _61.xzw) + _37_m6.xyz;
    _61 = float4(_169.x, _169.y, _169.z, _61.w);
    _174 = 0.0f < _37_m7;
    if (_174)
    {
        float3 _187 = vs_TEXCOORD1 + (-_37_m8);
        _30 = float4(_187.x, _187.y, _187.z, _30.w);
        float3 _195 = _30.xyz * _37_m9;
        _30 = float4(_195.x, _195.y, _195.z, _30.w);
        _198 = _Volume0.Sample(sampler_Volume0, _30.xyz);
        _212 = _Volume1.Sample(sampler_Volume0, _30.xyz);
        _220 = (_212 * 2.0f.xxxx) + (-1.0f).xxxx;
        _228 = _Volume2.Sample(sampler_Volume0, _30.xyz);
        _30 = (_228.xywz * 2.0f.xxxx) + (-1.0f).xxxx;
        float3 _244 = _198.xyz * _220.xyz;
        _220 = float4(_244.x, _244.y, _244.z, _220.w);
        float3 _251 = _9.xxx * _220.xyz;
        _220 = float4(_251.x, _251.y, _251.z, _220.w);
        _255 = _198.xyz * _30.xyw;
        float3 _264 = _9.yyy * _255;
        _9 = float4(_264.x, _264.y, _9.z, _264.z);
        _30.x = _198.w;
        _30.y = _220.w;
        float3 _278 = _198.xyz * _30.xyz;
        _30 = float4(_278.x, _278.y, _278.z, _30.w);
        float3 _285 = _9.zzz * _30.xyz;
        _30 = float4(_285.x, _285.y, _285.z, _30.w);
        _288 = (_220.xyz * 2.0f.xxx) + _198.xyz;
        float3 _300 = (_9.xyw * 2.0f.xxx) + _288;
        _9 = float4(_300.x, _300.y, _300.z, _9.w);
        float3 _308 = (_30.xyz * 2.0f.xxx) + _9.xyz;
        _9 = float4(_308.x, _308.y, _308.z, _9.w);
        float3 _314 = max(_9.xyz, 0.0f.xxx);
        _9 = float4(_314.x, _314.y, _314.z, _9.w);
        float3 _325 = (_61.xyz * _9.xyz) + (-_61.xyz);
        _9 = float4(_325.x, _325.y, _325.z, _9.w);
        _328 = (_37_m7.xxx * _9.xyz) + _61.xyz;
        _61 = float4(_328.x, _328.y, _328.z, _61.w);
    }
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _349 = _61.xyz + (-_37_m1.xyz);
    float3 _365 = (_9.xxx * _349) + _37_m1.xyz;
    _9 = float4(_365.x, _365.y, _365.z, _9.w);
    _369 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _369.w);
    _369.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._369 = _369;
    return stage_output;
}

#endif
#elif defined(BAKERY_COMPRESSED_VOLUME) && defined(BAKERY_VOLUME) && defined(FOG_LINEAR) && defined(_IS_OPPOSITE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _136;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _136 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _155;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _21_m4.z) + _21_m4.w;
    _9.x = dot(_136, _21_m2[0].xyz);
    _9.y = dot(_136, _21_m2[1].xyz);
    _9.z = dot(_136, _21_m2[2].xyz);
    _155 = dot(_9.xyz, _9.xyz);
    _155 = rsqrt(_155);
    vs_TEXCOORD0 = _155.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
float _VolumeInfluence;
float3 _VolumeMin;
float3 _VolumeInvSize;
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 unity_FogColor
#define _37_m2 _Color
#define _37_m3 _Pupil_Size
#define _37_m4 _Pupil_Sharpness
#define _37_m5 _Eye_Back_Size
#define _37_m6 _Eye_Bk
#define _37_m7 _VolumeInfluence
#define _37_m8 _VolumeMin
#define _37_m9 _VolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _369;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _369 : SV_Target0;
};

static float4 _9;
static float4 _30;
static float _46;
static float4 _61;
static float _91;
static bool _174;
static float4 _198;
static float4 _212;
static float4 _220;
static float4 _228;
static float3 _255;
static float3 _288;
static float3 _328;
static float3 _349;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD0;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    float3 _43 = (-vs_TEXCOORD1) + _37_m0;
    _30 = float4(_43.x, _43.y, _43.z, _30.w);
    _46 = dot(_30.xyz, _30.xyz);
    _46 = rsqrt(_46);
    float3 _58 = _46.xxx * _30.xyz;
    _30 = float4(_58.x, _58.y, _58.z, _30.w);
    _61.x = dot(_9.xyz, _30.xyz);
    _61.x = clamp(_61.x, 0.0f, 1.0f);
    _46 = (-_61.x) + 1.0f;
    _30.x = _37_m3 + 0.00999999977648258209228515625f;
    _61.x = _46 + (-_30.x);
    _91 = (-_30.x) + _37_m3;
    _61.x /= _91;
    _91 = (-_37_m4.x) + _37_m4.y;
    _61.x = (_61.x * _91) + _37_m4.x;
    _61.x = clamp(_61.x, 0.0f, 1.0f);
    _46 = log2(_46);
    _46 *= 0.660000026226043701171875f;
    _46 = exp2(_46);
    _91 = _46 / _37_m5;
    _91 = (-_91) + 1.0f;
    float3 _148 = ((-_37_m2.xyz) * _61.xxx) + 1.0f.xxx;
    _30 = float4(_148.x, _148.y, _148.z, _30.w);
    float3 _158 = _30.xyz + (-_37_m6.xyz);
    _61 = float4(_158.x, _61.y, _158.y, _158.z);
    float3 _169 = (_91.xxx * _61.xzw) + _37_m6.xyz;
    _61 = float4(_169.x, _169.y, _169.z, _61.w);
    _174 = 0.0f < _37_m7;
    if (_174)
    {
        float3 _187 = vs_TEXCOORD1 + (-_37_m8);
        _30 = float4(_187.x, _187.y, _187.z, _30.w);
        float3 _195 = _30.xyz * _37_m9;
        _30 = float4(_195.x, _195.y, _195.z, _30.w);
        _198 = _Volume0.Sample(sampler_Volume0, _30.xyz);
        _212 = _Volume1.Sample(sampler_Volume0, _30.xyz);
        _220 = (_212 * 2.0f.xxxx) + (-1.0f).xxxx;
        _228 = _Volume2.Sample(sampler_Volume0, _30.xyz);
        _30 = (_228.xywz * 2.0f.xxxx) + (-1.0f).xxxx;
        float3 _244 = _198.xyz * _220.xyz;
        _220 = float4(_244.x, _244.y, _244.z, _220.w);
        float3 _251 = _9.xxx * _220.xyz;
        _220 = float4(_251.x, _251.y, _251.z, _220.w);
        _255 = _198.xyz * _30.xyw;
        float3 _264 = _9.yyy * _255;
        _9 = float4(_264.x, _264.y, _9.z, _264.z);
        _30.x = _198.w;
        _30.y = _220.w;
        float3 _278 = _198.xyz * _30.xyz;
        _30 = float4(_278.x, _278.y, _278.z, _30.w);
        float3 _285 = _9.zzz * _30.xyz;
        _30 = float4(_285.x, _285.y, _285.z, _30.w);
        _288 = (_220.xyz * 2.0f.xxx) + _198.xyz;
        float3 _300 = (_9.xyw * 2.0f.xxx) + _288;
        _9 = float4(_300.x, _300.y, _300.z, _9.w);
        float3 _308 = (_30.xyz * 2.0f.xxx) + _9.xyz;
        _9 = float4(_308.x, _308.y, _308.z, _9.w);
        float3 _314 = max(_9.xyz, 0.0f.xxx);
        _9 = float4(_314.x, _314.y, _314.z, _9.w);
        float3 _325 = (_61.xyz * _9.xyz) + (-_61.xyz);
        _9 = float4(_325.x, _325.y, _325.z, _9.w);
        _328 = (_37_m7.xxx * _9.xyz) + _61.xyz;
        _61 = float4(_328.x, _328.y, _328.z, _61.w);
    }
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _349 = _61.xyz + (-_37_m1.xyz);
    float3 _365 = (_9.xxx * _349) + _37_m1.xyz;
    _9 = float4(_365.x, _365.y, _365.z, _9.w);
    _369 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _369.w);
    _369.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._369 = _369;
    return stage_output;
}

#endif
#elif defined(BAKERY_COMPRESSED_VOLUME) && defined(BAKERY_VOLUME) && defined(_IS_OPPOSITE)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float3 _96;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _96 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _118;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _44.xxxx) + _9;
    _9 = (_21_m2[2] * _44.zzzz) + _9;
    gl_Position = (_21_m2[3] * _44.wwww) + _9;
    _9.x = dot(_96, _21_m1[0].xyz);
    _9.y = dot(_96, _21_m1[1].xyz);
    _9.z = dot(_96, _21_m1[2].xyz);
    _118 = dot(_9.xyz, _9.xyz);
    _118 = rsqrt(_118);
    vs_TEXCOORD0 = _118.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _96 = stage_input._96;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
float _VolumeInfluence;
float3 _VolumeMin;
float3 _VolumeInvSize;
#define _37_m0 _WorldSpaceCameraPos
#define _37_m1 _Color
#define _37_m2 _Pupil_Size
#define _37_m3 _Pupil_Sharpness
#define _37_m4 _Eye_Back_Size
#define _37_m5 _Eye_Bk
#define _37_m6 _VolumeInfluence
#define _37_m7 _VolumeMin
#define _37_m8 _VolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _342;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _342 : SV_Target0;
};

static float4 _9;
static float4 _30;
static float _46;
static float4 _61;
static float _91;
static bool _174;
static float4 _198;
static float4 _212;
static float4 _220;
static float4 _228;
static float3 _255;
static float3 _288;
static float3 _328;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD0;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    float3 _43 = (-vs_TEXCOORD1) + _37_m0;
    _30 = float4(_43.x, _43.y, _43.z, _30.w);
    _46 = dot(_30.xyz, _30.xyz);
    _46 = rsqrt(_46);
    float3 _58 = _46.xxx * _30.xyz;
    _30 = float4(_58.x, _58.y, _58.z, _30.w);
    _61.x = dot(_9.xyz, _30.xyz);
    _61.x = clamp(_61.x, 0.0f, 1.0f);
    _46 = (-_61.x) + 1.0f;
    _30.x = _37_m2 + 0.00999999977648258209228515625f;
    _61.x = _46 + (-_30.x);
    _91 = (-_30.x) + _37_m2;
    _61.x /= _91;
    _91 = (-_37_m3.x) + _37_m3.y;
    _61.x = (_61.x * _91) + _37_m3.x;
    _61.x = clamp(_61.x, 0.0f, 1.0f);
    _46 = log2(_46);
    _46 *= 0.660000026226043701171875f;
    _46 = exp2(_46);
    _91 = _46 / _37_m4;
    _91 = (-_91) + 1.0f;
    float3 _148 = ((-_37_m1.xyz) * _61.xxx) + 1.0f.xxx;
    _30 = float4(_148.x, _148.y, _148.z, _30.w);
    float3 _158 = _30.xyz + (-_37_m5.xyz);
    _61 = float4(_158.x, _61.y, _158.y, _158.z);
    float3 _169 = (_91.xxx * _61.xzw) + _37_m5.xyz;
    _61 = float4(_169.x, _169.y, _169.z, _61.w);
    _174 = 0.0f < _37_m6;
    if (_174)
    {
        float3 _187 = vs_TEXCOORD1 + (-_37_m7);
        _30 = float4(_187.x, _187.y, _187.z, _30.w);
        float3 _195 = _30.xyz * _37_m8;
        _30 = float4(_195.x, _195.y, _195.z, _30.w);
        _198 = _Volume0.Sample(sampler_Volume0, _30.xyz);
        _212 = _Volume1.Sample(sampler_Volume0, _30.xyz);
        _220 = (_212 * 2.0f.xxxx) + (-1.0f).xxxx;
        _228 = _Volume2.Sample(sampler_Volume0, _30.xyz);
        _30 = (_228.xywz * 2.0f.xxxx) + (-1.0f).xxxx;
        float3 _244 = _198.xyz * _220.xyz;
        _220 = float4(_244.x, _244.y, _244.z, _220.w);
        float3 _251 = _9.xxx * _220.xyz;
        _220 = float4(_251.x, _251.y, _251.z, _220.w);
        _255 = _198.xyz * _30.xyw;
        float3 _264 = _9.yyy * _255;
        _9 = float4(_264.x, _264.y, _9.z, _264.z);
        _30.x = _198.w;
        _30.y = _220.w;
        float3 _278 = _198.xyz * _30.xyz;
        _30 = float4(_278.x, _278.y, _278.z, _30.w);
        float3 _285 = _9.zzz * _30.xyz;
        _30 = float4(_285.x, _285.y, _285.z, _30.w);
        _288 = (_220.xyz * 2.0f.xxx) + _198.xyz;
        float3 _300 = (_9.xyw * 2.0f.xxx) + _288;
        _9 = float4(_300.x, _300.y, _300.z, _9.w);
        float3 _308 = (_30.xyz * 2.0f.xxx) + _9.xyz;
        _9 = float4(_308.x, _308.y, _308.z, _9.w);
        float3 _314 = max(_9.xyz, 0.0f.xxx);
        _9 = float4(_314.x, _314.y, _314.z, _9.w);
        float3 _325 = (_61.xyz * _9.xyz) + (-_61.xyz);
        _9 = float4(_325.x, _325.y, _325.z, _9.w);
        _328 = (_37_m6.xxx * _9.xyz) + _61.xyz;
        _61 = float4(_328.x, _328.y, _328.z, _61.w);
    }
    _342 = float4(_61.xyz.x, _61.xyz.y, _61.xyz.z, _342.w);
    _342.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._342 = _342;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP) && defined(_IS_OPPOSITE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _137;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _137 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _156;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    _9.x = dot(_137, _21_m2[0].xyz);
    _9.y = dot(_137, _21_m2[1].xyz);
    _9.z = dot(_137, _21_m2[2].xyz);
    _156 = dot(_9.xyz, _9.xyz);
    _156 = rsqrt(_156);
    vs_TEXCOORD0 = _156.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _137 = stage_input._137;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
float _VolumeInfluence;
float3 _VolumeMin;
float3 _VolumeInvSize;
#define _38_m0 _WorldSpaceCameraPos
#define _38_m1 unity_FogColor
#define _38_m2 _Color
#define _38_m3 _Pupil_Size
#define _38_m4 _Pupil_Sharpness
#define _38_m5 _Eye_Back_Size
#define _38_m6 _Eye_Bk
#define _38_m7 _VolumeInfluence
#define _38_m8 _VolumeMin
#define _38_m9 _VolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _304;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _304 : SV_Target0;
};

static float4 _9;
static float3 _31;
static float _45;
static float4 _55;
static float _84;
static bool _164;
static float4 _183;
static float4 _196;
static float4 _203;
static float3 _211;
static float3 _263;
static float3 _284;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD0;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _31 = (-vs_TEXCOORD1) + _38_m0;
    _45 = dot(_31, _31);
    _45 = rsqrt(_45);
    _31 = _45.xxx * _31;
    _55.x = dot(_9.xyz, _31);
    _55.x = clamp(_55.x, 0.0f, 1.0f);
    _45 = (-_55.x) + 1.0f;
    _31.x = _38_m3 + 0.00999999977648258209228515625f;
    _55.x = _45 + (-_31.x);
    _84 = (-_31.x) + _38_m3;
    _55.x /= _84;
    _84 = (-_38_m4.x) + _38_m4.y;
    _55.x = (_55.x * _84) + _38_m4.x;
    _55.x = clamp(_55.x, 0.0f, 1.0f);
    _45 = log2(_45);
    _45 *= 0.660000026226043701171875f;
    _45 = exp2(_45);
    _84 = _45 / _38_m5;
    _84 = (-_84) + 1.0f;
    _31 = ((-_38_m2.xyz) * _55.xxx) + 1.0f.xxx;
    float3 _148 = _31 + (-_38_m6.xyz);
    _55 = float4(_148.x, _55.y, _148.y, _148.z);
    float3 _159 = (_84.xxx * _55.xzw) + _38_m6.xyz;
    _55 = float4(_159.x, _159.y, _159.z, _55.w);
    _164 = 0.0f < _38_m7;
    if (_164)
    {
        _31 = vs_TEXCOORD1 + (-_38_m8);
        _31 *= _38_m9;
        _183 = _Volume0.Sample(sampler_Volume0, _31);
        _196 = _Volume1.Sample(sampler_Volume0, _31);
        _203 = _Volume2.Sample(sampler_Volume0, _31).xywz;
        _211 = (_9.xxx * _196.xyz) + _183.xyz;
        float3 _226 = (_9.yyy * _203.xyw) + _211;
        _9 = float4(_226.x, _226.y, _9.z, _226.z);
        _203.x = _183.w;
        _203.y = _196.w;
        float3 _243 = (_9.zzz * _203.xyz) + _9.xyw;
        _9 = float4(_243.x, _243.y, _243.z, _9.w);
        float3 _249 = max(_9.xyz, 0.0f.xxx);
        _9 = float4(_249.x, _249.y, _249.z, _9.w);
        float3 _260 = (_55.xyz * _9.xyz) + (-_55.xyz);
        _9 = float4(_260.x, _260.y, _260.z, _9.w);
        _263 = (_38_m7.xxx * _9.xyz) + _55.xyz;
        _55 = float4(_263.x, _263.y, _263.z, _55.w);
    }
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _284 = _55.xyz + (-_38_m1.xyz);
    float3 _300 = (_9.xxx * _284) + _38_m1.xyz;
    _9 = float4(_300.x, _300.y, _300.z, _9.w);
    _304 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _304.w);
    _304.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._304 = _304;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_EXP2) && defined(_IS_OPPOSITE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _143;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _162;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    _9.x = dot(_143, _21_m2[0].xyz);
    _9.y = dot(_143, _21_m2[1].xyz);
    _9.z = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    vs_TEXCOORD0 = _162.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
float _VolumeInfluence;
float3 _VolumeMin;
float3 _VolumeInvSize;
#define _38_m0 _WorldSpaceCameraPos
#define _38_m1 unity_FogColor
#define _38_m2 _Color
#define _38_m3 _Pupil_Size
#define _38_m4 _Pupil_Sharpness
#define _38_m5 _Eye_Back_Size
#define _38_m6 _Eye_Bk
#define _38_m7 _VolumeInfluence
#define _38_m8 _VolumeMin
#define _38_m9 _VolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _304;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _304 : SV_Target0;
};

static float4 _9;
static float3 _31;
static float _45;
static float4 _55;
static float _84;
static bool _164;
static float4 _183;
static float4 _196;
static float4 _203;
static float3 _211;
static float3 _263;
static float3 _284;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD0;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _31 = (-vs_TEXCOORD1) + _38_m0;
    _45 = dot(_31, _31);
    _45 = rsqrt(_45);
    _31 = _45.xxx * _31;
    _55.x = dot(_9.xyz, _31);
    _55.x = clamp(_55.x, 0.0f, 1.0f);
    _45 = (-_55.x) + 1.0f;
    _31.x = _38_m3 + 0.00999999977648258209228515625f;
    _55.x = _45 + (-_31.x);
    _84 = (-_31.x) + _38_m3;
    _55.x /= _84;
    _84 = (-_38_m4.x) + _38_m4.y;
    _55.x = (_55.x * _84) + _38_m4.x;
    _55.x = clamp(_55.x, 0.0f, 1.0f);
    _45 = log2(_45);
    _45 *= 0.660000026226043701171875f;
    _45 = exp2(_45);
    _84 = _45 / _38_m5;
    _84 = (-_84) + 1.0f;
    _31 = ((-_38_m2.xyz) * _55.xxx) + 1.0f.xxx;
    float3 _148 = _31 + (-_38_m6.xyz);
    _55 = float4(_148.x, _55.y, _148.y, _148.z);
    float3 _159 = (_84.xxx * _55.xzw) + _38_m6.xyz;
    _55 = float4(_159.x, _159.y, _159.z, _55.w);
    _164 = 0.0f < _38_m7;
    if (_164)
    {
        _31 = vs_TEXCOORD1 + (-_38_m8);
        _31 *= _38_m9;
        _183 = _Volume0.Sample(sampler_Volume0, _31);
        _196 = _Volume1.Sample(sampler_Volume0, _31);
        _203 = _Volume2.Sample(sampler_Volume0, _31).xywz;
        _211 = (_9.xxx * _196.xyz) + _183.xyz;
        float3 _226 = (_9.yyy * _203.xyw) + _211;
        _9 = float4(_226.x, _226.y, _9.z, _226.z);
        _203.x = _183.w;
        _203.y = _196.w;
        float3 _243 = (_9.zzz * _203.xyz) + _9.xyw;
        _9 = float4(_243.x, _243.y, _243.z, _9.w);
        float3 _249 = max(_9.xyz, 0.0f.xxx);
        _9 = float4(_249.x, _249.y, _249.z, _9.w);
        float3 _260 = (_55.xyz * _9.xyz) + (-_55.xyz);
        _9 = float4(_260.x, _260.y, _260.z, _9.w);
        _263 = (_38_m7.xxx * _9.xyz) + _55.xyz;
        _55 = float4(_263.x, _263.y, _263.z, _55.w);
    }
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _284 = _55.xyz + (-_38_m1.xyz);
    float3 _300 = (_9.xxx * _284) + _38_m1.xyz;
    _9 = float4(_300.x, _300.y, _300.z, _9.w);
    _304 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _304.w);
    _304.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._304 = _304;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(FOG_LINEAR) && defined(_IS_OPPOSITE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _136;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _136 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _155;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _21_m4.z) + _21_m4.w;
    _9.x = dot(_136, _21_m2[0].xyz);
    _9.y = dot(_136, _21_m2[1].xyz);
    _9.z = dot(_136, _21_m2[2].xyz);
    _155 = dot(_9.xyz, _9.xyz);
    _155 = rsqrt(_155);
    vs_TEXCOORD0 = _155.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
float _VolumeInfluence;
float3 _VolumeMin;
float3 _VolumeInvSize;
#define _38_m0 _WorldSpaceCameraPos
#define _38_m1 unity_FogColor
#define _38_m2 _Color
#define _38_m3 _Pupil_Size
#define _38_m4 _Pupil_Sharpness
#define _38_m5 _Eye_Back_Size
#define _38_m6 _Eye_Bk
#define _38_m7 _VolumeInfluence
#define _38_m8 _VolumeMin
#define _38_m9 _VolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _304;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _304 : SV_Target0;
};

static float4 _9;
static float3 _31;
static float _45;
static float4 _55;
static float _84;
static bool _164;
static float4 _183;
static float4 _196;
static float4 _203;
static float3 _211;
static float3 _263;
static float3 _284;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD0;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _31 = (-vs_TEXCOORD1) + _38_m0;
    _45 = dot(_31, _31);
    _45 = rsqrt(_45);
    _31 = _45.xxx * _31;
    _55.x = dot(_9.xyz, _31);
    _55.x = clamp(_55.x, 0.0f, 1.0f);
    _45 = (-_55.x) + 1.0f;
    _31.x = _38_m3 + 0.00999999977648258209228515625f;
    _55.x = _45 + (-_31.x);
    _84 = (-_31.x) + _38_m3;
    _55.x /= _84;
    _84 = (-_38_m4.x) + _38_m4.y;
    _55.x = (_55.x * _84) + _38_m4.x;
    _55.x = clamp(_55.x, 0.0f, 1.0f);
    _45 = log2(_45);
    _45 *= 0.660000026226043701171875f;
    _45 = exp2(_45);
    _84 = _45 / _38_m5;
    _84 = (-_84) + 1.0f;
    _31 = ((-_38_m2.xyz) * _55.xxx) + 1.0f.xxx;
    float3 _148 = _31 + (-_38_m6.xyz);
    _55 = float4(_148.x, _55.y, _148.y, _148.z);
    float3 _159 = (_84.xxx * _55.xzw) + _38_m6.xyz;
    _55 = float4(_159.x, _159.y, _159.z, _55.w);
    _164 = 0.0f < _38_m7;
    if (_164)
    {
        _31 = vs_TEXCOORD1 + (-_38_m8);
        _31 *= _38_m9;
        _183 = _Volume0.Sample(sampler_Volume0, _31);
        _196 = _Volume1.Sample(sampler_Volume0, _31);
        _203 = _Volume2.Sample(sampler_Volume0, _31).xywz;
        _211 = (_9.xxx * _196.xyz) + _183.xyz;
        float3 _226 = (_9.yyy * _203.xyw) + _211;
        _9 = float4(_226.x, _226.y, _9.z, _226.z);
        _203.x = _183.w;
        _203.y = _196.w;
        float3 _243 = (_9.zzz * _203.xyz) + _9.xyw;
        _9 = float4(_243.x, _243.y, _243.z, _9.w);
        float3 _249 = max(_9.xyz, 0.0f.xxx);
        _9 = float4(_249.x, _249.y, _249.z, _9.w);
        float3 _260 = (_55.xyz * _9.xyz) + (-_55.xyz);
        _9 = float4(_260.x, _260.y, _260.z, _9.w);
        _263 = (_38_m7.xxx * _9.xyz) + _55.xyz;
        _55 = float4(_263.x, _263.y, _263.z, _55.w);
    }
    _9.x = vs_TEXCOORD2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _284 = _55.xyz + (-_38_m1.xyz);
    float3 _300 = (_9.xxx * _284) + _38_m1.xyz;
    _9 = float4(_300.x, _300.y, _300.z, _9.w);
    _304 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _304.w);
    _304.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._304 = _304;
    return stage_output;
}

#endif
#elif defined(BAKERY_COMPRESSED_VOLUME) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _137;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _137 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _156;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    _9.x = dot(_137, _21_m2[0].xyz);
    _9.y = dot(_137, _21_m2[1].xyz);
    _9.z = dot(_137, _21_m2[2].xyz);
    _156 = dot(_9.xyz, _9.xyz);
    _156 = rsqrt(_156);
    vs_TEXCOORD0 = _156.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _137 = stage_input._137;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 unity_FogColor
#define _18_m2 _Color
#define _18_m3 _Pupil_Size
#define _18_m4 _Pupil_Sharpness
#define _18_m5 _Eye_Back_Size
#define _18_m6 _Eye_Bk



static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _182;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _182 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _42;
static float4 _48;
static float _66;
static float _92;
static float _102;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _18_m0;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _26 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _26 = rsqrt(_26);
    _42 = _26.xxx * vs_TEXCOORD0;
    _48.x = dot(_42, _9);
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    _9.x = (-_48.x) + 1.0f;
    _66 = _18_m3 + 0.00999999977648258209228515625f;
    _48.x = (-_66) + _9.x;
    _9.x = log2(_9.x);
    _9.x *= 0.660000026226043701171875f;
    _9.x = exp2(_9.x);
    _92 = _9.x / _18_m5;
    _92 = (-_92) + 1.0f;
    _102 = (-_66) + _18_m3;
    _48.x /= _102;
    _102 = (-_18_m4.x) + _18_m4.y;
    _48.x = (_48.x * _102) + _18_m4.x;
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    float3 _146 = (_18_m2.xyz * _48.xxx) + (-_18_m6.xyz);
    _48 = float4(_146.x, _48.y, _146.y, _146.z);
    float3 _157 = (_92.xxx * _48.xzw) + _18_m6.xyz;
    _48 = float4(_157.x, _157.y, _157.z, _48.w);
    _9 = _48.xyz + (-_18_m1.xyz);
    _26 = vs_TEXCOORD2;
    _26 = clamp(_26, 0.0f, 1.0f);
    _9 = (_26.xxx * _9) + _18_m1.xyz;
    _182 = float4(_9.x, _9.y, _9.z, _182.w);
    _182.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._182 = _182;
    return stage_output;
}

#endif
#elif defined(BAKERY_COMPRESSED_VOLUME) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _143;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _162;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    _9.x = dot(_143, _21_m2[0].xyz);
    _9.y = dot(_143, _21_m2[1].xyz);
    _9.z = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    vs_TEXCOORD0 = _162.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 unity_FogColor
#define _18_m2 _Color
#define _18_m3 _Pupil_Size
#define _18_m4 _Pupil_Sharpness
#define _18_m5 _Eye_Back_Size
#define _18_m6 _Eye_Bk



static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _182;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _182 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _42;
static float4 _48;
static float _66;
static float _92;
static float _102;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _18_m0;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _26 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _26 = rsqrt(_26);
    _42 = _26.xxx * vs_TEXCOORD0;
    _48.x = dot(_42, _9);
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    _9.x = (-_48.x) + 1.0f;
    _66 = _18_m3 + 0.00999999977648258209228515625f;
    _48.x = (-_66) + _9.x;
    _9.x = log2(_9.x);
    _9.x *= 0.660000026226043701171875f;
    _9.x = exp2(_9.x);
    _92 = _9.x / _18_m5;
    _92 = (-_92) + 1.0f;
    _102 = (-_66) + _18_m3;
    _48.x /= _102;
    _102 = (-_18_m4.x) + _18_m4.y;
    _48.x = (_48.x * _102) + _18_m4.x;
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    float3 _146 = (_18_m2.xyz * _48.xxx) + (-_18_m6.xyz);
    _48 = float4(_146.x, _48.y, _146.y, _146.z);
    float3 _157 = (_92.xxx * _48.xzw) + _18_m6.xyz;
    _48 = float4(_157.x, _157.y, _157.z, _48.w);
    _9 = _48.xyz + (-_18_m1.xyz);
    _26 = vs_TEXCOORD2;
    _26 = clamp(_26, 0.0f, 1.0f);
    _9 = (_26.xxx * _9) + _18_m1.xyz;
    _182 = float4(_9.x, _9.y, _9.z, _182.w);
    _182.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._182 = _182;
    return stage_output;
}

#endif
#elif defined(BAKERY_COMPRESSED_VOLUME) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _136;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _136 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _155;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _21_m4.z) + _21_m4.w;
    _9.x = dot(_136, _21_m2[0].xyz);
    _9.y = dot(_136, _21_m2[1].xyz);
    _9.z = dot(_136, _21_m2[2].xyz);
    _155 = dot(_9.xyz, _9.xyz);
    _155 = rsqrt(_155);
    vs_TEXCOORD0 = _155.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 unity_FogColor
#define _18_m2 _Color
#define _18_m3 _Pupil_Size
#define _18_m4 _Pupil_Sharpness
#define _18_m5 _Eye_Back_Size
#define _18_m6 _Eye_Bk



static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _182;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _182 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _42;
static float4 _48;
static float _66;
static float _92;
static float _102;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _18_m0;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _26 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _26 = rsqrt(_26);
    _42 = _26.xxx * vs_TEXCOORD0;
    _48.x = dot(_42, _9);
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    _9.x = (-_48.x) + 1.0f;
    _66 = _18_m3 + 0.00999999977648258209228515625f;
    _48.x = (-_66) + _9.x;
    _9.x = log2(_9.x);
    _9.x *= 0.660000026226043701171875f;
    _9.x = exp2(_9.x);
    _92 = _9.x / _18_m5;
    _92 = (-_92) + 1.0f;
    _102 = (-_66) + _18_m3;
    _48.x /= _102;
    _102 = (-_18_m4.x) + _18_m4.y;
    _48.x = (_48.x * _102) + _18_m4.x;
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    float3 _146 = (_18_m2.xyz * _48.xxx) + (-_18_m6.xyz);
    _48 = float4(_146.x, _48.y, _146.y, _146.z);
    float3 _157 = (_92.xxx * _48.xzw) + _18_m6.xyz;
    _48 = float4(_157.x, _157.y, _157.z, _48.w);
    _9 = _48.xyz + (-_18_m1.xyz);
    _26 = vs_TEXCOORD2;
    _26 = clamp(_26, 0.0f, 1.0f);
    _9 = (_26.xxx * _9) + _18_m1.xyz;
    _182 = float4(_9.x, _9.y, _9.z, _182.w);
    _182.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._182 = _182;
    return stage_output;
}

#endif
#elif defined(BAKERY_VOLUME) && defined(_IS_OPPOSITE)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float3 _96;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _96 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _118;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _44.xxxx) + _9;
    _9 = (_21_m2[2] * _44.zzzz) + _9;
    gl_Position = (_21_m2[3] * _44.wwww) + _9;
    _9.x = dot(_96, _21_m1[0].xyz);
    _9.y = dot(_96, _21_m1[1].xyz);
    _9.z = dot(_96, _21_m1[2].xyz);
    _118 = dot(_9.xyz, _9.xyz);
    _118 = rsqrt(_118);
    vs_TEXCOORD0 = _118.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _96 = stage_input._96;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
float _VolumeInfluence;
float3 _VolumeMin;
float3 _VolumeInvSize;
#define _38_m0 _WorldSpaceCameraPos
#define _38_m1 _Color
#define _38_m2 _Pupil_Size
#define _38_m3 _Pupil_Sharpness
#define _38_m4 _Eye_Back_Size
#define _38_m5 _Eye_Bk
#define _38_m6 _VolumeInfluence
#define _38_m7 _VolumeMin
#define _38_m8 _VolumeInvSize


Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _277;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _277 : SV_Target0;
};

static float4 _9;
static float3 _31;
static float _45;
static float4 _55;
static float _84;
static bool _164;
static float4 _183;
static float4 _196;
static float4 _203;
static float3 _211;
static float3 _263;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _9.x = rsqrt(_9.x);
    float3 _27 = _9.xxx * vs_TEXCOORD0;
    _9 = float4(_27.x, _27.y, _27.z, _9.w);
    _31 = (-vs_TEXCOORD1) + _38_m0;
    _45 = dot(_31, _31);
    _45 = rsqrt(_45);
    _31 = _45.xxx * _31;
    _55.x = dot(_9.xyz, _31);
    _55.x = clamp(_55.x, 0.0f, 1.0f);
    _45 = (-_55.x) + 1.0f;
    _31.x = _38_m2 + 0.00999999977648258209228515625f;
    _55.x = _45 + (-_31.x);
    _84 = (-_31.x) + _38_m2;
    _55.x /= _84;
    _84 = (-_38_m3.x) + _38_m3.y;
    _55.x = (_55.x * _84) + _38_m3.x;
    _55.x = clamp(_55.x, 0.0f, 1.0f);
    _45 = log2(_45);
    _45 *= 0.660000026226043701171875f;
    _45 = exp2(_45);
    _84 = _45 / _38_m4;
    _84 = (-_84) + 1.0f;
    _31 = ((-_38_m1.xyz) * _55.xxx) + 1.0f.xxx;
    float3 _148 = _31 + (-_38_m5.xyz);
    _55 = float4(_148.x, _55.y, _148.y, _148.z);
    float3 _159 = (_84.xxx * _55.xzw) + _38_m5.xyz;
    _55 = float4(_159.x, _159.y, _159.z, _55.w);
    _164 = 0.0f < _38_m6;
    if (_164)
    {
        _31 = vs_TEXCOORD1 + (-_38_m7);
        _31 *= _38_m8;
        _183 = _Volume0.Sample(sampler_Volume0, _31);
        _196 = _Volume1.Sample(sampler_Volume0, _31);
        _203 = _Volume2.Sample(sampler_Volume0, _31).xywz;
        _211 = (_9.xxx * _196.xyz) + _183.xyz;
        float3 _226 = (_9.yyy * _203.xyw) + _211;
        _9 = float4(_226.x, _226.y, _9.z, _226.z);
        _203.x = _183.w;
        _203.y = _196.w;
        float3 _243 = (_9.zzz * _203.xyz) + _9.xyw;
        _9 = float4(_243.x, _243.y, _243.z, _9.w);
        float3 _249 = max(_9.xyz, 0.0f.xxx);
        _9 = float4(_249.x, _249.y, _249.z, _9.w);
        float3 _260 = (_55.xyz * _9.xyz) + (-_55.xyz);
        _9 = float4(_260.x, _260.y, _260.z, _9.w);
        _263 = (_38_m6.xxx * _9.xyz) + _55.xyz;
        _55 = float4(_263.x, _263.y, _263.z, _55.w);
    }
    _277 = float4(_55.xyz.x, _55.xyz.y, _55.xyz.z, _277.w);
    _277.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._277 = _277;
    return stage_output;
}

#endif
#elif defined(BAKERY_COMPRESSED_VOLUME)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float3 _96;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _96 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _118;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _44.xxxx) + _9;
    _9 = (_21_m2[2] * _44.zzzz) + _9;
    gl_Position = (_21_m2[3] * _44.wwww) + _9;
    _9.x = dot(_96, _21_m1[0].xyz);
    _9.y = dot(_96, _21_m1[1].xyz);
    _9.z = dot(_96, _21_m1[2].xyz);
    _118 = dot(_9.xyz, _9.xyz);
    _118 = rsqrt(_118);
    vs_TEXCOORD0 = _118.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _96 = stage_input._96;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _Color
#define _18_m2 _Pupil_Size
#define _18_m3 _Pupil_Sharpness
#define _18_m4 _Eye_Back_Size
#define _18_m5 _Eye_Bk



static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float4 _150;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _150 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _42;
static float4 _48;
static float _66;
static float _92;
static float _102;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _18_m0;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _26 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _26 = rsqrt(_26);
    _42 = _26.xxx * vs_TEXCOORD0;
    _48.x = dot(_42, _9);
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    _9.x = (-_48.x) + 1.0f;
    _66 = _18_m2 + 0.00999999977648258209228515625f;
    _48.x = (-_66) + _9.x;
    _9.x = log2(_9.x);
    _9.x *= 0.660000026226043701171875f;
    _9.x = exp2(_9.x);
    _92 = _9.x / _18_m4;
    _92 = (-_92) + 1.0f;
    _102 = (-_66) + _18_m2;
    _48.x /= _102;
    _102 = (-_18_m3.x) + _18_m3.y;
    _48.x = (_48.x * _102) + _18_m3.x;
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    float3 _146 = (_18_m1.xyz * _48.xxx) + (-_18_m5.xyz);
    _48 = float4(_146.x, _48.y, _146.y, _146.z);
    float3 _159 = (_92.xxx * _48.xzw) + _18_m5.xyz;
    _150 = float4(_159.x, _159.y, _159.z, _150.w);
    _150.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._150 = _150;
    return stage_output;
}

#endif
#elif defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _137;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _137 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _156;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    _9.x = dot(_137, _21_m2[0].xyz);
    _9.y = dot(_137, _21_m2[1].xyz);
    _9.z = dot(_137, _21_m2[2].xyz);
    _156 = dot(_9.xyz, _9.xyz);
    _156 = rsqrt(_156);
    vs_TEXCOORD0 = _156.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _137 = stage_input._137;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 unity_FogColor
#define _18_m2 _Color
#define _18_m3 _Pupil_Size
#define _18_m4 _Pupil_Sharpness
#define _18_m5 _Eye_Back_Size
#define _18_m6 _Eye_Bk



static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _182;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _182 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _42;
static float4 _48;
static float _66;
static float _92;
static float _102;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _18_m0;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _26 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _26 = rsqrt(_26);
    _42 = _26.xxx * vs_TEXCOORD0;
    _48.x = dot(_42, _9);
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    _9.x = (-_48.x) + 1.0f;
    _66 = _18_m3 + 0.00999999977648258209228515625f;
    _48.x = (-_66) + _9.x;
    _9.x = log2(_9.x);
    _9.x *= 0.660000026226043701171875f;
    _9.x = exp2(_9.x);
    _92 = _9.x / _18_m5;
    _92 = (-_92) + 1.0f;
    _102 = (-_66) + _18_m3;
    _48.x /= _102;
    _102 = (-_18_m4.x) + _18_m4.y;
    _48.x = (_48.x * _102) + _18_m4.x;
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    float3 _146 = (_18_m2.xyz * _48.xxx) + (-_18_m6.xyz);
    _48 = float4(_146.x, _48.y, _146.y, _146.z);
    float3 _157 = (_92.xxx * _48.xzw) + _18_m6.xyz;
    _48 = float4(_157.x, _157.y, _157.z, _48.w);
    _9 = _48.xyz + (-_18_m1.xyz);
    _26 = vs_TEXCOORD2;
    _26 = clamp(_26, 0.0f, 1.0f);
    _9 = (_26.xxx * _9) + _18_m1.xyz;
    _182 = float4(_9.x, _9.y, _9.z, _182.w);
    _182.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._182 = _182;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _143;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _162;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    _9.x = dot(_143, _21_m2[0].xyz);
    _9.y = dot(_143, _21_m2[1].xyz);
    _9.z = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    vs_TEXCOORD0 = _162.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 unity_FogColor
#define _18_m2 _Color
#define _18_m3 _Pupil_Size
#define _18_m4 _Pupil_Sharpness
#define _18_m5 _Eye_Back_Size
#define _18_m6 _Eye_Bk



static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _182;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _182 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _42;
static float4 _48;
static float _66;
static float _92;
static float _102;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _18_m0;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _26 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _26 = rsqrt(_26);
    _42 = _26.xxx * vs_TEXCOORD0;
    _48.x = dot(_42, _9);
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    _9.x = (-_48.x) + 1.0f;
    _66 = _18_m3 + 0.00999999977648258209228515625f;
    _48.x = (-_66) + _9.x;
    _9.x = log2(_9.x);
    _9.x *= 0.660000026226043701171875f;
    _9.x = exp2(_9.x);
    _92 = _9.x / _18_m5;
    _92 = (-_92) + 1.0f;
    _102 = (-_66) + _18_m3;
    _48.x /= _102;
    _102 = (-_18_m4.x) + _18_m4.y;
    _48.x = (_48.x * _102) + _18_m4.x;
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    float3 _146 = (_18_m2.xyz * _48.xxx) + (-_18_m6.xyz);
    _48 = float4(_146.x, _48.y, _146.y, _146.z);
    float3 _157 = (_92.xxx * _48.xzw) + _18_m6.xyz;
    _48 = float4(_157.x, _157.y, _157.z, _48.w);
    _9 = _48.xyz + (-_18_m1.xyz);
    _26 = vs_TEXCOORD2;
    _26 = clamp(_26, 0.0f, 1.0f);
    _9 = (_26.xxx * _9) + _18_m1.xyz;
    _182 = float4(_9.x, _9.y, _9.z, _182.w);
    _182.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._182 = _182;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _21_m1[4];
float4x4 unity_WorldToObject;
static float4 _21_m2[4];
float4x4 unity_MatrixVP;
static float4 _21_m3[4];
float4 unity_FogParams;
void __unity_init()
{
    _21_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _21_m0 _ProjectionParams
#define _21_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float3 _136;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _136 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _155;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m1[3];
    vs_TEXCOORD1 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _21_m4.z) + _21_m4.w;
    _9.x = dot(_136, _21_m2[0].xyz);
    _9.y = dot(_136, _21_m2[1].xyz);
    _9.z = dot(_136, _21_m2[2].xyz);
    _155 = dot(_9.xyz, _9.xyz);
    _155 = rsqrt(_155);
    vs_TEXCOORD0 = _155.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 unity_FogColor
#define _18_m2 _Color
#define _18_m3 _Pupil_Size
#define _18_m4 _Pupil_Sharpness
#define _18_m5 _Eye_Back_Size
#define _18_m6 _Eye_Bk



static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD2;
static float4 _182;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _182 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _42;
static float4 _48;
static float _66;
static float _92;
static float _102;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _18_m0;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _26 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _26 = rsqrt(_26);
    _42 = _26.xxx * vs_TEXCOORD0;
    _48.x = dot(_42, _9);
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    _9.x = (-_48.x) + 1.0f;
    _66 = _18_m3 + 0.00999999977648258209228515625f;
    _48.x = (-_66) + _9.x;
    _9.x = log2(_9.x);
    _9.x *= 0.660000026226043701171875f;
    _9.x = exp2(_9.x);
    _92 = _9.x / _18_m5;
    _92 = (-_92) + 1.0f;
    _102 = (-_66) + _18_m3;
    _48.x /= _102;
    _102 = (-_18_m4.x) + _18_m4.y;
    _48.x = (_48.x * _102) + _18_m4.x;
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    float3 _146 = (_18_m2.xyz * _48.xxx) + (-_18_m6.xyz);
    _48 = float4(_146.x, _48.y, _146.y, _146.z);
    float3 _157 = (_92.xxx * _48.xzw) + _18_m6.xyz;
    _48 = float4(_157.x, _157.y, _157.z, _48.w);
    _9 = _48.xyz + (-_18_m1.xyz);
    _26 = vs_TEXCOORD2;
    _26 = clamp(_26, 0.0f, 1.0f);
    _9 = (_26.xxx * _9) + _18_m1.xyz;
    _182 = float4(_9.x, _9.y, _9.z, _182.w);
    _182.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._182 = _182;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _21_m0[4];
float4x4 unity_WorldToObject;
static float4 _21_m1[4];
float4x4 unity_MatrixVP;
static float4 _21_m2[4];
void __unity_init()
{
    _21_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _21_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _21_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _21_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _21_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _21_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _21_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _21_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _21_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _21_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _21_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _21_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD1;
static float3 _96;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _96 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _118;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _44 = _9 + _21_m0[3];
    vs_TEXCOORD1 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _44.xxxx) + _9;
    _9 = (_21_m2[2] * _44.zzzz) + _9;
    gl_Position = (_21_m2[3] * _44.wwww) + _9;
    _9.x = dot(_96, _21_m1[0].xyz);
    _9.y = dot(_96, _21_m1[1].xyz);
    _9.z = dot(_96, _21_m1[2].xyz);
    _118 = dot(_9.xyz, _9.xyz);
    _118 = rsqrt(_118);
    vs_TEXCOORD0 = _118.xxx * _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _96 = stage_input._96;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _Color;
float _Pupil_Size;
float2 _Pupil_Sharpness;
float _Eye_Back_Size;
float4 _Eye_Bk;
#define _18_m0 _WorldSpaceCameraPos
#define _18_m1 _Color
#define _18_m2 _Pupil_Size
#define _18_m3 _Pupil_Sharpness
#define _18_m4 _Eye_Back_Size
#define _18_m5 _Eye_Bk



static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD0;
static float4 _150;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _150 : SV_Target0;
};

static float3 _9;
static float _26;
static float3 _42;
static float4 _48;
static float _66;
static float _92;
static float _102;

void frag_inner()
{
    _9 = (-vs_TEXCOORD1) + _18_m0;
    _26 = dot(_9, _9);
    _26 = rsqrt(_26);
    _9 = _26.xxx * _9;
    _26 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _26 = rsqrt(_26);
    _42 = _26.xxx * vs_TEXCOORD0;
    _48.x = dot(_42, _9);
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    _9.x = (-_48.x) + 1.0f;
    _66 = _18_m2 + 0.00999999977648258209228515625f;
    _48.x = (-_66) + _9.x;
    _9.x = log2(_9.x);
    _9.x *= 0.660000026226043701171875f;
    _9.x = exp2(_9.x);
    _92 = _9.x / _18_m4;
    _92 = (-_92) + 1.0f;
    _102 = (-_66) + _18_m2;
    _48.x /= _102;
    _102 = (-_18_m3.x) + _18_m3.y;
    _48.x = (_48.x * _102) + _18_m3.x;
    _48.x = clamp(_48.x, 0.0f, 1.0f);
    float3 _146 = (_18_m1.xyz * _48.xxx) + (-_18_m5.xyz);
    _48 = float4(_146.x, _48.y, _146.y, _146.z);
    float3 _159 = (_92.xxx * _48.xzw) + _18_m5.xyz;
    _150 = float4(_159.x, _159.y, _159.z, _150.w);
    _150.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._150 = _150;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Diffuse"
}