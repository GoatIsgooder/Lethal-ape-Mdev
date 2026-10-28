// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "SoreBones/EyeShader2" {
Properties {

_EyeTex ("Eye Texture", 2D) = "white" { }

_EyeSize ("Eye Size", Range(0.05, 2)) = 0.5

_EyeOffset ("Eye UV Offset", Vector) = (0,0,0,0)

_EyeFalloff ("Eye Edge Falloff", Range(0.001, 1)) = 0.15000000596046448

_MainColor ("Main Color", Color) = (1,1,1,1)

_Smoothness ("Smoothness", Range(0, 1)) = 0.5

_FrenselOutlinePower ("Fresnel Outline Power", Float) = 1.0

_FrenselOutlineColor ("Fresnel Outline Color", Color) = (0.7,0.7,0.7,1)

_FrenselOutlineMultiplier ("Fresnel Outline Multiplier", Float) = 1.0

[Toggle] _UseLookDirection ("Use Look Direction", Float) = 0.0

_LookDirection ("Look Direction (XY)", Vector) = (0,0,0,0)

_IrisForward ("Iris Forward Axis (object)", Vector) = (0,0,1,0)

_IrisUp ("Iris Up Axis (object)", Vector) = (0,1,0,0)

_LookStraightDistance ("Look Straight Distance", Float) = 1.0

_LookStraightSoftness ("Look Straight Softness", Float) = 0.5

_VolumeIntensity ("Bakery Volume Intensity", Range(0, 1)) = 1.0

}
SubShader {
 LOD 100
 Tags { "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  LOD 100
  Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
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
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _140;
static float3 _143;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _140 : TEXCOORD0;
    float3 _143 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD4 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
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
    _9.x *= _21_m4.y;
    vs_TEXCOORD4 = exp2(-_9.x);
    vs_TEXCOORD0 = _140;
    _9.x = dot(_143, _21_m2[0].xyz);
    _9.y = dot(_143, _21_m2[1].xyz);
    _9.z = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    vs_TEXCOORD2 = _162.xxx * _9.xyz;
    _9.x = dot(_143, _143);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD3 = _9.xxx * _143;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _140 = stage_input._140;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToObject;
static float4 _16_m1[4];
float4 unity_FogColor;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
float _VolumeIntensity;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _16_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m2 unity_FogColor
#define _16_m3 _MainColor
#define _16_m4 _FrenselOutlineColor
#define _16_m5 _EyeOffset
#define _16_m6 _EyeSize
#define _16_m7 _EyeFalloff
#define _16_m8 _FrenselOutlinePower
#define _16_m9 _FrenselOutlineMultiplier
#define _16_m10 _UseLookDirection
#define _16_m11 _LookDirection
#define _16_m12 _IrisForward
#define _16_m13 _IrisUp
#define _16_m14 _LookStraightDistance
#define _16_m15 _LookStraightSoftness
#define _16_m16 _VolumeIntensity
#define _16_m17 _VolumeMin
#define _16_m18 _VolumeInvSize
#define _16_m19 _GlobalVolumeMin
#define _16_m20 _GlobalVolumeInvSize


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float3 _877;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD4 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float3 _877 : SV_Target0;
};

static float3 _9;
static float3 _40;
static float _57;
static float4 _68;
static float _117;
static float _162;
static float3 _256;
static float4 _306;
static float3 _334;
static bool4 _369;
static float3 _385;
static bool _535;
static float4 _569;
static float4 _588;
static float4 _596;
static float3 _697;
static float2 _802;

void frag_inner()
{
    __unity_init();
    _9.x = dot(_16_m12.xyz, _16_m12.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _16_m12.zxy;
    _40 = _9.yzx * _16_m13.yzx;
    _40 = (_16_m13.xyz * _9.zxy) + (-_40);
    _57 = dot(_40, _40);
    _57 = rsqrt(_57);
    _40 = _57.xxx * _40;
    float3 _73 = _9.zxy * _40.yzx;
    _68 = float4(_73.x, _73.y, _73.z, _68.w);
    float3 _84 = (_9.yzx * _40.zxy) + (-_68.xyz);
    _68 = float4(_84.x, _84.y, _84.z, _68.w);
    _9 = (_16_m11.xxx * _40) + _9;
    _9 = (_16_m11.yyy * _68.xyz) + _9;
    _57 = dot(_9, _9);
    _57 = rsqrt(_57);
    _40 = (-vs_TEXCOORD1) + _16_m0;
    _117 = dot(_40, _40);
    _68.x = rsqrt(_117);
    _117 = sqrt(_117);
    _40 *= _68.xxx;
    float3 _136 = _40.yyy * _16_m1[1].zxy;
    _68 = float4(_136.x, _136.y, _136.z, _68.w);
    float3 _147 = (_16_m1[0].zxy * _40.xxx) + _68.xyz;
    _68 = float4(_147.x, _147.y, _147.z, _68.w);
    float3 _159 = (_16_m1[2].zxy * _40.zzz) + _68.xyz;
    _68 = float4(_159.x, _159.y, _159.z, _68.w);
    _162 = dot(_68.xyz, _68.xyz);
    _162 = rsqrt(_162);
    float3 _174 = _162.xxx * _68.xyz;
    _68 = float4(_174.x, _174.y, _174.z, _68.w);
    _9 = (_9 * _57.xxx) + (-_68.xyz);
    _57 = (-_16_m15) + _16_m14;
    _117 = (-_57) + _117;
    _162 = _16_m15 + _16_m14;
    _57 = (-_57) + _162;
    _57 = 1.0f / _57;
    _57 *= _117;
    _57 = clamp(_57, 0.0f, 1.0f);
    _117 = (_57 * (-2.0f)) + 3.0f;
    _57 *= _57;
    _57 *= _117;
    _57 = max(_57, _16_m10);
    _9 = (_57.xxx * _9) + _68.xyz;
    _57 = dot(_16_m1[1].xyz, _16_m1[1].xyz);
    _57 = rsqrt(_57);
    float3 _253 = _57.xxx * _16_m1[1].zxy;
    _68 = float4(_253.x, _253.y, _253.z, _68.w);
    _256 = _9.zxy * _68.xyz;
    float3 _268 = (_68.zxy * _9) + (-_256);
    _68 = float4(_268.x, _268.y, _268.z, _68.w);
    _57 = dot(_68.xyz, _68.xyz);
    _57 = max(_57, 9.9999999747524270787835121154785e-07f);
    _57 = rsqrt(_57);
    float3 _285 = _57.xxx * _68.xyz;
    _68 = float4(_285.x, _285.y, _285.z, _68.w);
    _256 = _9 * _68.yzx;
    _256 = (_9.zxy * _68.zxy) + (-_256);
    _57 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _57 = rsqrt(_57);
    float3 _310 = _57.xxx * vs_TEXCOORD3;
    _306 = float4(_310.x, _310.y, _310.z, _306.w);
    _256.y = dot(_306.xyz, _256);
    _256.x = dot(_306.xyz, _68.xyz);
    _9.x = dot(_306.zxy, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _334.x = max(_16_m6, 9.9999997473787516355514526367188e-05f);
    float2 _346 = _256.xy / _334.xx;
    _334 = float3(_346.x, _346.y, _334.z);
    float2 _358 = (_334.xy * 0.5f.xx) + _16_m5.xy;
    _334 = float3(_358.x, _358.y, _334.z);
    float2 _363 = _334.xy + 0.5f.xx;
    _334 = float3(_363.x, _363.y, _334.z);
    bool2 _375 = bool4(_334.xyxx.x >= 0.0f.xxxx.x, _334.xyxx.y >= 0.0f.xxxx.y, _334.xyxx.z >= 0.0f.xxxx.z, _334.xyxx.w >= 0.0f.xxxx.w).xy;
    _369 = bool4(_375.x, _375.y, _369.z, _369.w);
    bool2 _382 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _334.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _334.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _334.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _334.xxxy.w).zw;
    _369 = bool4(_369.x, _369.y, _382.x, _382.y);
    _385 = _EyeTex.Sample(sampler_EyeTex, _334.xy).xyz;
    _334 = _385 + (-_16_m3.xyz);
    _68.x = float(_369.x);
    _68.y = float(_369.y);
    _68.z = float(_369.z);
    _68.w = float(_369.w);
    _117 = _68.z * _68.x;
    _117 = _68.y * _117;
    _117 = _68.w * _117;
    _68.x = 1.0f / _16_m7;
    _9.x *= _68.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _68.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _68.x;
    _9.x *= _117;
    _9 = (_9.xxx * _334) + _16_m3.xyz;
    _57 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _57 = rsqrt(_57);
    float3 _493 = _57.xxx * vs_TEXCOORD2;
    _68 = float4(_493.x, _493.y, _493.z, _68.w);
    _57 = dot(_68.xyz, _40);
    _57 = clamp(_57, 0.0f, 1.0f);
    _57 = (-_57) + 1.0f;
    _57 = log2(_57);
    _57 *= _16_m8;
    _57 = exp2(_57);
    _40 = _57.xxx * _16_m4.xyz;
    _9 = (_40 * _16_m9.xxx) + _9;
    _57 = dot(abs(_16_m18), 1.0f.xxx);
    _535 = _57 == 0.0f;
    float3 _540;
    if (_535)
    {
        _540 = _16_m19;
    }
    else
    {
        _540 = _16_m17;
    }
    _40 = _540;
    float3 _552;
    if (_535)
    {
        _552 = _16_m20;
    }
    else
    {
        _552 = _16_m18;
    }
    _256 = _552;
    _40 = (-_40) + vs_TEXCOORD1;
    _40 = _256 * _40;
    _569 = _Volume0.Sample(sampler_Volume0, _40).xywz;
    float3 _585 = max(_569.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _306 = float4(_585.x, _585.y, _585.z, _306.w);
    _588 = _Volume1.Sample(sampler_Volume0, _40).yxwz;
    _596 = _Volume2.Sample(sampler_Volume0, _40).xzwy;
    _569.x = _588.y;
    _569.y = _596.x;
    _256 = _569.xyz * 0.5f.xxx;
    _57 = dot(_256, _256);
    _57 = sqrt(_57);
    _162 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.x;
    _57 = min(_57, 1.0f);
    _256 /= _162.xxx;
    _162 = dot(_256, _68.xyz);
    _162 = (_162 * 0.5f) + 0.5f;
    _162 = clamp(_162, 0.0f, 1.0f);
    _162 = log2(_162);
    float2 _648 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _256 = float3(_648.x, _648.y, _256.z);
    _162 *= _256.x;
    _162 = exp2(_162);
    _256.x = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _256.x / _57;
    _256.x = (-_57) + 1.0f;
    _256.x = _256.y * _256.x;
    _57 = (_256.x * _162) + _57;
    _256.x = _57 * _306.x;
    _596.x = _588.w;
    _588.y = _596.w;
    _40 = _596.xyz * 0.5f.xxx;
    _697 = _588.xyz * 0.5f.xxx;
    _57 = dot(_697, _697);
    _57 = sqrt(_57);
    _117 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.y;
    _57 = min(_57, 1.0f);
    _697 /= _117.xxx;
    _117 = dot(_697, _68.xyz);
    _117 = (_117 * 0.5f) + 0.5f;
    _117 = clamp(_117, 0.0f, 1.0f);
    _117 = log2(_117);
    float2 _732 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _306 = float4(_732.x, _306.y, _306.z, _732.y);
    _117 *= _306.x;
    _117 = exp2(_117);
    _162 = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _162 / _57;
    _162 = (-_57) + 1.0f;
    _162 = _306.w * _162;
    _57 = (_162 * _117) + _57;
    _256.y = _57 * _306.y;
    _57 = dot(_40, _40);
    _57 = sqrt(_57);
    _117 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.z;
    _57 = min(_57, 1.0f);
    _40 /= _117.xxx;
    _40.x = dot(_40, _68.xyz);
    _40.x = (_40.x * 0.5f) + 0.5f;
    _40.x = clamp(_40.x, 0.0f, 1.0f);
    _40.x = log2(_40.x);
    _802 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _40.x *= _802.x;
    _40.x = exp2(_40.x);
    _802.x = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _802.x / _57;
    _802.x = (-_57) + 1.0f;
    _802.x = _802.y * _802.x;
    _57 = (_802.x * _40.x) + _57;
    _256.z = _57 * _306.z;
    _9 *= _256;
    _9 = (_9 * float3(float3(_16_m16, _16_m16, _16_m16))) + (-_16_m2.xyz);
    _57 = vs_TEXCOORD4;
    _57 = clamp(_57, 0.0f, 1.0f);
    _877 = (_57.xxx * _9) + _16_m2.xyz;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._877 = _877;
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
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _146;
static float3 _149;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _146 : TEXCOORD0;
    float3 _149 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD4 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _168;

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
    vs_TEXCOORD4 = exp2(_9.x);
    vs_TEXCOORD0 = _146;
    _9.x = dot(_149, _21_m2[0].xyz);
    _9.y = dot(_149, _21_m2[1].xyz);
    _9.z = dot(_149, _21_m2[2].xyz);
    _168 = dot(_9.xyz, _9.xyz);
    _168 = rsqrt(_168);
    vs_TEXCOORD2 = _168.xxx * _9.xyz;
    _9.x = dot(_149, _149);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD3 = _9.xxx * _149;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    _149 = stage_input._149;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToObject;
static float4 _16_m1[4];
float4 unity_FogColor;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
float _VolumeIntensity;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _16_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m2 unity_FogColor
#define _16_m3 _MainColor
#define _16_m4 _FrenselOutlineColor
#define _16_m5 _EyeOffset
#define _16_m6 _EyeSize
#define _16_m7 _EyeFalloff
#define _16_m8 _FrenselOutlinePower
#define _16_m9 _FrenselOutlineMultiplier
#define _16_m10 _UseLookDirection
#define _16_m11 _LookDirection
#define _16_m12 _IrisForward
#define _16_m13 _IrisUp
#define _16_m14 _LookStraightDistance
#define _16_m15 _LookStraightSoftness
#define _16_m16 _VolumeIntensity
#define _16_m17 _VolumeMin
#define _16_m18 _VolumeInvSize
#define _16_m19 _GlobalVolumeMin
#define _16_m20 _GlobalVolumeInvSize


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float3 _877;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD4 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float3 _877 : SV_Target0;
};

static float3 _9;
static float3 _40;
static float _57;
static float4 _68;
static float _117;
static float _162;
static float3 _256;
static float4 _306;
static float3 _334;
static bool4 _369;
static float3 _385;
static bool _535;
static float4 _569;
static float4 _588;
static float4 _596;
static float3 _697;
static float2 _802;

void frag_inner()
{
    __unity_init();
    _9.x = dot(_16_m12.xyz, _16_m12.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _16_m12.zxy;
    _40 = _9.yzx * _16_m13.yzx;
    _40 = (_16_m13.xyz * _9.zxy) + (-_40);
    _57 = dot(_40, _40);
    _57 = rsqrt(_57);
    _40 = _57.xxx * _40;
    float3 _73 = _9.zxy * _40.yzx;
    _68 = float4(_73.x, _73.y, _73.z, _68.w);
    float3 _84 = (_9.yzx * _40.zxy) + (-_68.xyz);
    _68 = float4(_84.x, _84.y, _84.z, _68.w);
    _9 = (_16_m11.xxx * _40) + _9;
    _9 = (_16_m11.yyy * _68.xyz) + _9;
    _57 = dot(_9, _9);
    _57 = rsqrt(_57);
    _40 = (-vs_TEXCOORD1) + _16_m0;
    _117 = dot(_40, _40);
    _68.x = rsqrt(_117);
    _117 = sqrt(_117);
    _40 *= _68.xxx;
    float3 _136 = _40.yyy * _16_m1[1].zxy;
    _68 = float4(_136.x, _136.y, _136.z, _68.w);
    float3 _147 = (_16_m1[0].zxy * _40.xxx) + _68.xyz;
    _68 = float4(_147.x, _147.y, _147.z, _68.w);
    float3 _159 = (_16_m1[2].zxy * _40.zzz) + _68.xyz;
    _68 = float4(_159.x, _159.y, _159.z, _68.w);
    _162 = dot(_68.xyz, _68.xyz);
    _162 = rsqrt(_162);
    float3 _174 = _162.xxx * _68.xyz;
    _68 = float4(_174.x, _174.y, _174.z, _68.w);
    _9 = (_9 * _57.xxx) + (-_68.xyz);
    _57 = (-_16_m15) + _16_m14;
    _117 = (-_57) + _117;
    _162 = _16_m15 + _16_m14;
    _57 = (-_57) + _162;
    _57 = 1.0f / _57;
    _57 *= _117;
    _57 = clamp(_57, 0.0f, 1.0f);
    _117 = (_57 * (-2.0f)) + 3.0f;
    _57 *= _57;
    _57 *= _117;
    _57 = max(_57, _16_m10);
    _9 = (_57.xxx * _9) + _68.xyz;
    _57 = dot(_16_m1[1].xyz, _16_m1[1].xyz);
    _57 = rsqrt(_57);
    float3 _253 = _57.xxx * _16_m1[1].zxy;
    _68 = float4(_253.x, _253.y, _253.z, _68.w);
    _256 = _9.zxy * _68.xyz;
    float3 _268 = (_68.zxy * _9) + (-_256);
    _68 = float4(_268.x, _268.y, _268.z, _68.w);
    _57 = dot(_68.xyz, _68.xyz);
    _57 = max(_57, 9.9999999747524270787835121154785e-07f);
    _57 = rsqrt(_57);
    float3 _285 = _57.xxx * _68.xyz;
    _68 = float4(_285.x, _285.y, _285.z, _68.w);
    _256 = _9 * _68.yzx;
    _256 = (_9.zxy * _68.zxy) + (-_256);
    _57 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _57 = rsqrt(_57);
    float3 _310 = _57.xxx * vs_TEXCOORD3;
    _306 = float4(_310.x, _310.y, _310.z, _306.w);
    _256.y = dot(_306.xyz, _256);
    _256.x = dot(_306.xyz, _68.xyz);
    _9.x = dot(_306.zxy, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _334.x = max(_16_m6, 9.9999997473787516355514526367188e-05f);
    float2 _346 = _256.xy / _334.xx;
    _334 = float3(_346.x, _346.y, _334.z);
    float2 _358 = (_334.xy * 0.5f.xx) + _16_m5.xy;
    _334 = float3(_358.x, _358.y, _334.z);
    float2 _363 = _334.xy + 0.5f.xx;
    _334 = float3(_363.x, _363.y, _334.z);
    bool2 _375 = bool4(_334.xyxx.x >= 0.0f.xxxx.x, _334.xyxx.y >= 0.0f.xxxx.y, _334.xyxx.z >= 0.0f.xxxx.z, _334.xyxx.w >= 0.0f.xxxx.w).xy;
    _369 = bool4(_375.x, _375.y, _369.z, _369.w);
    bool2 _382 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _334.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _334.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _334.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _334.xxxy.w).zw;
    _369 = bool4(_369.x, _369.y, _382.x, _382.y);
    _385 = _EyeTex.Sample(sampler_EyeTex, _334.xy).xyz;
    _334 = _385 + (-_16_m3.xyz);
    _68.x = float(_369.x);
    _68.y = float(_369.y);
    _68.z = float(_369.z);
    _68.w = float(_369.w);
    _117 = _68.z * _68.x;
    _117 = _68.y * _117;
    _117 = _68.w * _117;
    _68.x = 1.0f / _16_m7;
    _9.x *= _68.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _68.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _68.x;
    _9.x *= _117;
    _9 = (_9.xxx * _334) + _16_m3.xyz;
    _57 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _57 = rsqrt(_57);
    float3 _493 = _57.xxx * vs_TEXCOORD2;
    _68 = float4(_493.x, _493.y, _493.z, _68.w);
    _57 = dot(_68.xyz, _40);
    _57 = clamp(_57, 0.0f, 1.0f);
    _57 = (-_57) + 1.0f;
    _57 = log2(_57);
    _57 *= _16_m8;
    _57 = exp2(_57);
    _40 = _57.xxx * _16_m4.xyz;
    _9 = (_40 * _16_m9.xxx) + _9;
    _57 = dot(abs(_16_m18), 1.0f.xxx);
    _535 = _57 == 0.0f;
    float3 _540;
    if (_535)
    {
        _540 = _16_m19;
    }
    else
    {
        _540 = _16_m17;
    }
    _40 = _540;
    float3 _552;
    if (_535)
    {
        _552 = _16_m20;
    }
    else
    {
        _552 = _16_m18;
    }
    _256 = _552;
    _40 = (-_40) + vs_TEXCOORD1;
    _40 = _256 * _40;
    _569 = _Volume0.Sample(sampler_Volume0, _40).xywz;
    float3 _585 = max(_569.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _306 = float4(_585.x, _585.y, _585.z, _306.w);
    _588 = _Volume1.Sample(sampler_Volume0, _40).yxwz;
    _596 = _Volume2.Sample(sampler_Volume0, _40).xzwy;
    _569.x = _588.y;
    _569.y = _596.x;
    _256 = _569.xyz * 0.5f.xxx;
    _57 = dot(_256, _256);
    _57 = sqrt(_57);
    _162 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.x;
    _57 = min(_57, 1.0f);
    _256 /= _162.xxx;
    _162 = dot(_256, _68.xyz);
    _162 = (_162 * 0.5f) + 0.5f;
    _162 = clamp(_162, 0.0f, 1.0f);
    _162 = log2(_162);
    float2 _648 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _256 = float3(_648.x, _648.y, _256.z);
    _162 *= _256.x;
    _162 = exp2(_162);
    _256.x = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _256.x / _57;
    _256.x = (-_57) + 1.0f;
    _256.x = _256.y * _256.x;
    _57 = (_256.x * _162) + _57;
    _256.x = _57 * _306.x;
    _596.x = _588.w;
    _588.y = _596.w;
    _40 = _596.xyz * 0.5f.xxx;
    _697 = _588.xyz * 0.5f.xxx;
    _57 = dot(_697, _697);
    _57 = sqrt(_57);
    _117 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.y;
    _57 = min(_57, 1.0f);
    _697 /= _117.xxx;
    _117 = dot(_697, _68.xyz);
    _117 = (_117 * 0.5f) + 0.5f;
    _117 = clamp(_117, 0.0f, 1.0f);
    _117 = log2(_117);
    float2 _732 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _306 = float4(_732.x, _306.y, _306.z, _732.y);
    _117 *= _306.x;
    _117 = exp2(_117);
    _162 = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _162 / _57;
    _162 = (-_57) + 1.0f;
    _162 = _306.w * _162;
    _57 = (_162 * _117) + _57;
    _256.y = _57 * _306.y;
    _57 = dot(_40, _40);
    _57 = sqrt(_57);
    _117 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.z;
    _57 = min(_57, 1.0f);
    _40 /= _117.xxx;
    _40.x = dot(_40, _68.xyz);
    _40.x = (_40.x * 0.5f) + 0.5f;
    _40.x = clamp(_40.x, 0.0f, 1.0f);
    _40.x = log2(_40.x);
    _802 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _40.x *= _802.x;
    _40.x = exp2(_40.x);
    _802.x = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _802.x / _57;
    _802.x = (-_57) + 1.0f;
    _802.x = _802.y * _802.x;
    _57 = (_802.x * _40.x) + _57;
    _256.z = _57 * _306.z;
    _9 *= _256;
    _9 = (_9 * float3(float3(_16_m16, _16_m16, _16_m16))) + (-_16_m2.xyz);
    _57 = vs_TEXCOORD4;
    _57 = clamp(_57, 0.0f, 1.0f);
    _877 = (_57.xxx * _9) + _16_m2.xyz;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._877 = _877;
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
static float vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float2 _139;
static float3 _142;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _139 : TEXCOORD0;
    float3 _142 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float vs_TEXCOORD4 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float2 vs_TEXCOORD0 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _161;

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
    vs_TEXCOORD4 = (_9.x * _21_m4.z) + _21_m4.w;
    vs_TEXCOORD0 = _139;
    _9.x = dot(_142, _21_m2[0].xyz);
    _9.y = dot(_142, _21_m2[1].xyz);
    _9.z = dot(_142, _21_m2[2].xyz);
    _161 = dot(_9.xyz, _9.xyz);
    _161 = rsqrt(_161);
    vs_TEXCOORD2 = _161.xxx * _9.xyz;
    _9.x = dot(_142, _142);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD3 = _9.xxx * _142;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _139 = stage_input._139;
    _142 = stage_input._142;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToObject;
static float4 _16_m1[4];
float4 unity_FogColor;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
float _VolumeIntensity;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _16_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m2 unity_FogColor
#define _16_m3 _MainColor
#define _16_m4 _FrenselOutlineColor
#define _16_m5 _EyeOffset
#define _16_m6 _EyeSize
#define _16_m7 _EyeFalloff
#define _16_m8 _FrenselOutlinePower
#define _16_m9 _FrenselOutlineMultiplier
#define _16_m10 _UseLookDirection
#define _16_m11 _LookDirection
#define _16_m12 _IrisForward
#define _16_m13 _IrisUp
#define _16_m14 _LookStraightDistance
#define _16_m15 _LookStraightSoftness
#define _16_m16 _VolumeIntensity
#define _16_m17 _VolumeMin
#define _16_m18 _VolumeInvSize
#define _16_m19 _GlobalVolumeMin
#define _16_m20 _GlobalVolumeInvSize


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float vs_TEXCOORD4;
static float3 _877;

struct SPIRV_Cross_Input
{
    float vs_TEXCOORD4 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float3 _877 : SV_Target0;
};

static float3 _9;
static float3 _40;
static float _57;
static float4 _68;
static float _117;
static float _162;
static float3 _256;
static float4 _306;
static float3 _334;
static bool4 _369;
static float3 _385;
static bool _535;
static float4 _569;
static float4 _588;
static float4 _596;
static float3 _697;
static float2 _802;

void frag_inner()
{
    __unity_init();
    _9.x = dot(_16_m12.xyz, _16_m12.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _16_m12.zxy;
    _40 = _9.yzx * _16_m13.yzx;
    _40 = (_16_m13.xyz * _9.zxy) + (-_40);
    _57 = dot(_40, _40);
    _57 = rsqrt(_57);
    _40 = _57.xxx * _40;
    float3 _73 = _9.zxy * _40.yzx;
    _68 = float4(_73.x, _73.y, _73.z, _68.w);
    float3 _84 = (_9.yzx * _40.zxy) + (-_68.xyz);
    _68 = float4(_84.x, _84.y, _84.z, _68.w);
    _9 = (_16_m11.xxx * _40) + _9;
    _9 = (_16_m11.yyy * _68.xyz) + _9;
    _57 = dot(_9, _9);
    _57 = rsqrt(_57);
    _40 = (-vs_TEXCOORD1) + _16_m0;
    _117 = dot(_40, _40);
    _68.x = rsqrt(_117);
    _117 = sqrt(_117);
    _40 *= _68.xxx;
    float3 _136 = _40.yyy * _16_m1[1].zxy;
    _68 = float4(_136.x, _136.y, _136.z, _68.w);
    float3 _147 = (_16_m1[0].zxy * _40.xxx) + _68.xyz;
    _68 = float4(_147.x, _147.y, _147.z, _68.w);
    float3 _159 = (_16_m1[2].zxy * _40.zzz) + _68.xyz;
    _68 = float4(_159.x, _159.y, _159.z, _68.w);
    _162 = dot(_68.xyz, _68.xyz);
    _162 = rsqrt(_162);
    float3 _174 = _162.xxx * _68.xyz;
    _68 = float4(_174.x, _174.y, _174.z, _68.w);
    _9 = (_9 * _57.xxx) + (-_68.xyz);
    _57 = (-_16_m15) + _16_m14;
    _117 = (-_57) + _117;
    _162 = _16_m15 + _16_m14;
    _57 = (-_57) + _162;
    _57 = 1.0f / _57;
    _57 *= _117;
    _57 = clamp(_57, 0.0f, 1.0f);
    _117 = (_57 * (-2.0f)) + 3.0f;
    _57 *= _57;
    _57 *= _117;
    _57 = max(_57, _16_m10);
    _9 = (_57.xxx * _9) + _68.xyz;
    _57 = dot(_16_m1[1].xyz, _16_m1[1].xyz);
    _57 = rsqrt(_57);
    float3 _253 = _57.xxx * _16_m1[1].zxy;
    _68 = float4(_253.x, _253.y, _253.z, _68.w);
    _256 = _9.zxy * _68.xyz;
    float3 _268 = (_68.zxy * _9) + (-_256);
    _68 = float4(_268.x, _268.y, _268.z, _68.w);
    _57 = dot(_68.xyz, _68.xyz);
    _57 = max(_57, 9.9999999747524270787835121154785e-07f);
    _57 = rsqrt(_57);
    float3 _285 = _57.xxx * _68.xyz;
    _68 = float4(_285.x, _285.y, _285.z, _68.w);
    _256 = _9 * _68.yzx;
    _256 = (_9.zxy * _68.zxy) + (-_256);
    _57 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _57 = rsqrt(_57);
    float3 _310 = _57.xxx * vs_TEXCOORD3;
    _306 = float4(_310.x, _310.y, _310.z, _306.w);
    _256.y = dot(_306.xyz, _256);
    _256.x = dot(_306.xyz, _68.xyz);
    _9.x = dot(_306.zxy, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _334.x = max(_16_m6, 9.9999997473787516355514526367188e-05f);
    float2 _346 = _256.xy / _334.xx;
    _334 = float3(_346.x, _346.y, _334.z);
    float2 _358 = (_334.xy * 0.5f.xx) + _16_m5.xy;
    _334 = float3(_358.x, _358.y, _334.z);
    float2 _363 = _334.xy + 0.5f.xx;
    _334 = float3(_363.x, _363.y, _334.z);
    bool2 _375 = bool4(_334.xyxx.x >= 0.0f.xxxx.x, _334.xyxx.y >= 0.0f.xxxx.y, _334.xyxx.z >= 0.0f.xxxx.z, _334.xyxx.w >= 0.0f.xxxx.w).xy;
    _369 = bool4(_375.x, _375.y, _369.z, _369.w);
    bool2 _382 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _334.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _334.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _334.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _334.xxxy.w).zw;
    _369 = bool4(_369.x, _369.y, _382.x, _382.y);
    _385 = _EyeTex.Sample(sampler_EyeTex, _334.xy).xyz;
    _334 = _385 + (-_16_m3.xyz);
    _68.x = float(_369.x);
    _68.y = float(_369.y);
    _68.z = float(_369.z);
    _68.w = float(_369.w);
    _117 = _68.z * _68.x;
    _117 = _68.y * _117;
    _117 = _68.w * _117;
    _68.x = 1.0f / _16_m7;
    _9.x *= _68.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _68.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _68.x;
    _9.x *= _117;
    _9 = (_9.xxx * _334) + _16_m3.xyz;
    _57 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _57 = rsqrt(_57);
    float3 _493 = _57.xxx * vs_TEXCOORD2;
    _68 = float4(_493.x, _493.y, _493.z, _68.w);
    _57 = dot(_68.xyz, _40);
    _57 = clamp(_57, 0.0f, 1.0f);
    _57 = (-_57) + 1.0f;
    _57 = log2(_57);
    _57 *= _16_m8;
    _57 = exp2(_57);
    _40 = _57.xxx * _16_m4.xyz;
    _9 = (_40 * _16_m9.xxx) + _9;
    _57 = dot(abs(_16_m18), 1.0f.xxx);
    _535 = _57 == 0.0f;
    float3 _540;
    if (_535)
    {
        _540 = _16_m19;
    }
    else
    {
        _540 = _16_m17;
    }
    _40 = _540;
    float3 _552;
    if (_535)
    {
        _552 = _16_m20;
    }
    else
    {
        _552 = _16_m18;
    }
    _256 = _552;
    _40 = (-_40) + vs_TEXCOORD1;
    _40 = _256 * _40;
    _569 = _Volume0.Sample(sampler_Volume0, _40).xywz;
    float3 _585 = max(_569.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _306 = float4(_585.x, _585.y, _585.z, _306.w);
    _588 = _Volume1.Sample(sampler_Volume0, _40).yxwz;
    _596 = _Volume2.Sample(sampler_Volume0, _40).xzwy;
    _569.x = _588.y;
    _569.y = _596.x;
    _256 = _569.xyz * 0.5f.xxx;
    _57 = dot(_256, _256);
    _57 = sqrt(_57);
    _162 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.x;
    _57 = min(_57, 1.0f);
    _256 /= _162.xxx;
    _162 = dot(_256, _68.xyz);
    _162 = (_162 * 0.5f) + 0.5f;
    _162 = clamp(_162, 0.0f, 1.0f);
    _162 = log2(_162);
    float2 _648 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _256 = float3(_648.x, _648.y, _256.z);
    _162 *= _256.x;
    _162 = exp2(_162);
    _256.x = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _256.x / _57;
    _256.x = (-_57) + 1.0f;
    _256.x = _256.y * _256.x;
    _57 = (_256.x * _162) + _57;
    _256.x = _57 * _306.x;
    _596.x = _588.w;
    _588.y = _596.w;
    _40 = _596.xyz * 0.5f.xxx;
    _697 = _588.xyz * 0.5f.xxx;
    _57 = dot(_697, _697);
    _57 = sqrt(_57);
    _117 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.y;
    _57 = min(_57, 1.0f);
    _697 /= _117.xxx;
    _117 = dot(_697, _68.xyz);
    _117 = (_117 * 0.5f) + 0.5f;
    _117 = clamp(_117, 0.0f, 1.0f);
    _117 = log2(_117);
    float2 _732 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _306 = float4(_732.x, _306.y, _306.z, _732.y);
    _117 *= _306.x;
    _117 = exp2(_117);
    _162 = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _162 / _57;
    _162 = (-_57) + 1.0f;
    _162 = _306.w * _162;
    _57 = (_162 * _117) + _57;
    _256.y = _57 * _306.y;
    _57 = dot(_40, _40);
    _57 = sqrt(_57);
    _117 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.z;
    _57 = min(_57, 1.0f);
    _40 /= _117.xxx;
    _40.x = dot(_40, _68.xyz);
    _40.x = (_40.x * 0.5f) + 0.5f;
    _40.x = clamp(_40.x, 0.0f, 1.0f);
    _40.x = log2(_40.x);
    _802 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _40.x *= _802.x;
    _40.x = exp2(_40.x);
    _802.x = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _802.x / _57;
    _802.x = (-_57) + 1.0f;
    _802.x = _802.y * _802.x;
    _57 = (_802.x * _40.x) + _57;
    _256.z = _57 * _306.z;
    _9 *= _256;
    _9 = (_9 * float3(float3(_16_m16, _16_m16, _16_m16))) + (-_16_m2.xyz);
    _57 = vs_TEXCOORD4;
    _57 = clamp(_57, 0.0f, 1.0f);
    _877 = (_57.xxx * _9) + _16_m2.xyz;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._877 = _877;
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
static float2 vs_TEXCOORD0;
static float2 _99;
static float3 _102;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _99 : TEXCOORD0;
    float3 _102 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
    float2 vs_TEXCOORD0 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _44;
static float _124;

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
    vs_TEXCOORD0 = _99;
    _9.x = dot(_102, _21_m1[0].xyz);
    _9.y = dot(_102, _21_m1[1].xyz);
    _9.z = dot(_102, _21_m1[2].xyz);
    _124 = dot(_9.xyz, _9.xyz);
    _124 = rsqrt(_124);
    vs_TEXCOORD2 = _124.xxx * _9.xyz;
    _9.x = dot(_102, _102);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD3 = _9.xxx * _102;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _99 = stage_input._99;
    _102 = stage_input._102;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4x4 unity_WorldToObject;
static float4 _16_m1[4];
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
float _VolumeIntensity;
float3 _VolumeMin;
float3 _VolumeInvSize;
float3 _GlobalVolumeMin;
float3 _GlobalVolumeInvSize;
void __unity_init()
{
    _16_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m2 _MainColor
#define _16_m3 _FrenselOutlineColor
#define _16_m4 _EyeOffset
#define _16_m5 _EyeSize
#define _16_m6 _EyeFalloff
#define _16_m7 _FrenselOutlinePower
#define _16_m8 _FrenselOutlineMultiplier
#define _16_m9 _UseLookDirection
#define _16_m10 _LookDirection
#define _16_m11 _IrisForward
#define _16_m12 _IrisUp
#define _16_m13 _LookStraightDistance
#define _16_m14 _LookStraightSoftness
#define _16_m15 _VolumeIntensity
#define _16_m16 _VolumeMin
#define _16_m17 _VolumeInvSize
#define _16_m18 _GlobalVolumeMin
#define _16_m19 _GlobalVolumeInvSize


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture3D<float4> _Volume0;
SamplerState sampler_Volume0;
Texture3D<float4> _Volume1;
Texture3D<float4> _Volume2;

static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float3 vs_TEXCOORD2;
static float3 _852;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD1 : TEXCOORD0;
    float3 vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD3 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float3 _852 : SV_Target0;
};

static float3 _9;
static float3 _40;
static float _57;
static float4 _68;
static float _117;
static float _162;
static float3 _256;
static float4 _306;
static float3 _334;
static bool4 _369;
static float3 _385;
static bool _534;
static float4 _568;
static float4 _587;
static float4 _595;
static float3 _696;
static float2 _801;

void frag_inner()
{
    __unity_init();
    _9.x = dot(_16_m11.xyz, _16_m11.xyz);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * _16_m11.zxy;
    _40 = _9.yzx * _16_m12.yzx;
    _40 = (_16_m12.xyz * _9.zxy) + (-_40);
    _57 = dot(_40, _40);
    _57 = rsqrt(_57);
    _40 = _57.xxx * _40;
    float3 _73 = _9.zxy * _40.yzx;
    _68 = float4(_73.x, _73.y, _73.z, _68.w);
    float3 _84 = (_9.yzx * _40.zxy) + (-_68.xyz);
    _68 = float4(_84.x, _84.y, _84.z, _68.w);
    _9 = (_16_m10.xxx * _40) + _9;
    _9 = (_16_m10.yyy * _68.xyz) + _9;
    _57 = dot(_9, _9);
    _57 = rsqrt(_57);
    _40 = (-vs_TEXCOORD1) + _16_m0;
    _117 = dot(_40, _40);
    _68.x = rsqrt(_117);
    _117 = sqrt(_117);
    _40 *= _68.xxx;
    float3 _136 = _40.yyy * _16_m1[1].zxy;
    _68 = float4(_136.x, _136.y, _136.z, _68.w);
    float3 _147 = (_16_m1[0].zxy * _40.xxx) + _68.xyz;
    _68 = float4(_147.x, _147.y, _147.z, _68.w);
    float3 _159 = (_16_m1[2].zxy * _40.zzz) + _68.xyz;
    _68 = float4(_159.x, _159.y, _159.z, _68.w);
    _162 = dot(_68.xyz, _68.xyz);
    _162 = rsqrt(_162);
    float3 _174 = _162.xxx * _68.xyz;
    _68 = float4(_174.x, _174.y, _174.z, _68.w);
    _9 = (_9 * _57.xxx) + (-_68.xyz);
    _57 = (-_16_m14) + _16_m13;
    _117 = (-_57) + _117;
    _162 = _16_m14 + _16_m13;
    _57 = (-_57) + _162;
    _57 = 1.0f / _57;
    _57 *= _117;
    _57 = clamp(_57, 0.0f, 1.0f);
    _117 = (_57 * (-2.0f)) + 3.0f;
    _57 *= _57;
    _57 *= _117;
    _57 = max(_57, _16_m9);
    _9 = (_57.xxx * _9) + _68.xyz;
    _57 = dot(_16_m1[1].xyz, _16_m1[1].xyz);
    _57 = rsqrt(_57);
    float3 _253 = _57.xxx * _16_m1[1].zxy;
    _68 = float4(_253.x, _253.y, _253.z, _68.w);
    _256 = _9.zxy * _68.xyz;
    float3 _268 = (_68.zxy * _9) + (-_256);
    _68 = float4(_268.x, _268.y, _268.z, _68.w);
    _57 = dot(_68.xyz, _68.xyz);
    _57 = max(_57, 9.9999999747524270787835121154785e-07f);
    _57 = rsqrt(_57);
    float3 _285 = _57.xxx * _68.xyz;
    _68 = float4(_285.x, _285.y, _285.z, _68.w);
    _256 = _9 * _68.yzx;
    _256 = (_9.zxy * _68.zxy) + (-_256);
    _57 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _57 = rsqrt(_57);
    float3 _310 = _57.xxx * vs_TEXCOORD3;
    _306 = float4(_310.x, _310.y, _310.z, _306.w);
    _256.y = dot(_306.xyz, _256);
    _256.x = dot(_306.xyz, _68.xyz);
    _9.x = dot(_306.zxy, _9);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _334.x = max(_16_m5, 9.9999997473787516355514526367188e-05f);
    float2 _346 = _256.xy / _334.xx;
    _334 = float3(_346.x, _346.y, _334.z);
    float2 _358 = (_334.xy * 0.5f.xx) + _16_m4.xy;
    _334 = float3(_358.x, _358.y, _334.z);
    float2 _363 = _334.xy + 0.5f.xx;
    _334 = float3(_363.x, _363.y, _334.z);
    bool2 _375 = bool4(_334.xyxx.x >= 0.0f.xxxx.x, _334.xyxx.y >= 0.0f.xxxx.y, _334.xyxx.z >= 0.0f.xxxx.z, _334.xyxx.w >= 0.0f.xxxx.w).xy;
    _369 = bool4(_375.x, _375.y, _369.z, _369.w);
    bool2 _382 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _334.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _334.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _334.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _334.xxxy.w).zw;
    _369 = bool4(_369.x, _369.y, _382.x, _382.y);
    _385 = _EyeTex.Sample(sampler_EyeTex, _334.xy).xyz;
    _334 = _385 + (-_16_m2.xyz);
    _68.x = float(_369.x);
    _68.y = float(_369.y);
    _68.z = float(_369.z);
    _68.w = float(_369.w);
    _117 = _68.z * _68.x;
    _117 = _68.y * _117;
    _117 = _68.w * _117;
    _68.x = 1.0f / _16_m6;
    _9.x *= _68.x;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _68.x = (_9.x * (-2.0f)) + 3.0f;
    _9.x *= _9.x;
    _9.x *= _68.x;
    _9.x *= _117;
    _9 = (_9.xxx * _334) + _16_m2.xyz;
    _57 = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _57 = rsqrt(_57);
    float3 _492 = _57.xxx * vs_TEXCOORD2;
    _68 = float4(_492.x, _492.y, _492.z, _68.w);
    _57 = dot(_68.xyz, _40);
    _57 = clamp(_57, 0.0f, 1.0f);
    _57 = (-_57) + 1.0f;
    _57 = log2(_57);
    _57 *= _16_m7;
    _57 = exp2(_57);
    _40 = _57.xxx * _16_m3.xyz;
    _9 = (_40 * _16_m8.xxx) + _9;
    _57 = dot(abs(_16_m17), 1.0f.xxx);
    _534 = _57 == 0.0f;
    float3 _539;
    if (_534)
    {
        _539 = _16_m18;
    }
    else
    {
        _539 = _16_m16;
    }
    _40 = _539;
    float3 _551;
    if (_534)
    {
        _551 = _16_m19;
    }
    else
    {
        _551 = _16_m17;
    }
    _256 = _551;
    _40 = (-_40) + vs_TEXCOORD1;
    _40 = _256 * _40;
    _568 = _Volume0.Sample(sampler_Volume0, _40).xywz;
    float3 _584 = max(_568.xyw, 9.9999997473787516355514526367188e-06f.xxx);
    _306 = float4(_584.x, _584.y, _584.z, _306.w);
    _587 = _Volume1.Sample(sampler_Volume0, _40).yxwz;
    _595 = _Volume2.Sample(sampler_Volume0, _40).xzwy;
    _568.x = _587.y;
    _568.y = _595.x;
    _256 = _568.xyz * 0.5f.xxx;
    _57 = dot(_256, _256);
    _57 = sqrt(_57);
    _162 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.x;
    _57 = min(_57, 1.0f);
    _256 /= _162.xxx;
    _162 = dot(_256, _68.xyz);
    _162 = (_162 * 0.5f) + 0.5f;
    _162 = clamp(_162, 0.0f, 1.0f);
    _162 = log2(_162);
    float2 _647 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _256 = float3(_647.x, _647.y, _256.z);
    _162 *= _256.x;
    _162 = exp2(_162);
    _256.x = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _256.x / _57;
    _256.x = (-_57) + 1.0f;
    _256.x = _256.y * _256.x;
    _57 = (_256.x * _162) + _57;
    _256.x = _57 * _306.x;
    _595.x = _587.w;
    _587.y = _595.w;
    _40 = _595.xyz * 0.5f.xxx;
    _696 = _587.xyz * 0.5f.xxx;
    _57 = dot(_696, _696);
    _57 = sqrt(_57);
    _117 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.y;
    _57 = min(_57, 1.0f);
    _696 /= _117.xxx;
    _117 = dot(_696, _68.xyz);
    _117 = (_117 * 0.5f) + 0.5f;
    _117 = clamp(_117, 0.0f, 1.0f);
    _117 = log2(_117);
    float2 _731 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _306 = float4(_731.x, _306.y, _306.z, _731.y);
    _117 *= _306.x;
    _117 = exp2(_117);
    _162 = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _162 / _57;
    _162 = (-_57) + 1.0f;
    _162 = _306.w * _162;
    _57 = (_162 * _117) + _57;
    _256.y = _57 * _306.y;
    _57 = dot(_40, _40);
    _57 = sqrt(_57);
    _117 = max(_57, 9.9999997473787516355514526367188e-06f);
    _57 /= _306.z;
    _57 = min(_57, 1.0f);
    _40 /= _117.xxx;
    _40.x = dot(_40, _68.xyz);
    _40.x = (_40.x * 0.5f) + 0.5f;
    _40.x = clamp(_40.x, 0.0f, 1.0f);
    _40.x = log2(_40.x);
    _801 = (_57.xx * 2.0f.xx) + float2(1.0f, 2.0f);
    _40.x *= _801.x;
    _40.x = exp2(_40.x);
    _801.x = (-_57) + 1.0f;
    _57 += 1.0f;
    _57 = _801.x / _57;
    _801.x = (-_57) + 1.0f;
    _801.x = _801.y * _801.x;
    _57 = (_801.x * _40.x) + _57;
    _256.z = _57 * _306.z;
    _9 *= _256;
    _852 = _9 * float3(float3(_16_m15, _16_m15, _16_m15));
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._852 = _852;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
Cull Back
  LOD 100
  Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" }
 ZWrite Off
   Blend One One
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
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD5;
static float3 _137;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _137 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
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
    vs_TEXCOORD0 = (_21_m1[3].xyz * _11.www) + _9.xyz;
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
    vs_TEXCOORD5 = exp2(-_9.x);
    _9.x = dot(_137, _21_m2[0].xyz);
    _9.y = dot(_137, _21_m2[1].xyz);
    _9.z = dot(_137, _21_m2[2].xyz);
    _156 = dot(_9.xyz, _9.xyz);
    _156 = rsqrt(_156);
    vs_TEXCOORD1 = _156.xxx * _9.xyz;
    _9.x = dot(_137, _137);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD2 = _9.xxx * _137;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _137 = stage_input._137;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _577;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _85 = dot(_16_m1.xyz, _16_m1.xyz);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _16_m1.xyz;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _62 *= _16_m3.xyz;
    _47 = _47.xxx * _62;
    _9 = _9.xxx * _47;
    _577 = vs_TEXCOORD5;
    _577 = clamp(_577, 0.0f, 1.0f);
    _9 *= _577.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2)
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
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD5;
static float3 _143;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _143 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
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
    vs_TEXCOORD0 = (_21_m1[3].xyz * _11.www) + _9.xyz;
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
    vs_TEXCOORD5 = exp2(_9.x);
    _9.x = dot(_143, _21_m2[0].xyz);
    _9.y = dot(_143, _21_m2[1].xyz);
    _9.z = dot(_143, _21_m2[2].xyz);
    _162 = dot(_9.xyz, _9.xyz);
    _162 = rsqrt(_162);
    vs_TEXCOORD1 = _162.xxx * _9.xyz;
    _9.x = dot(_143, _143);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD2 = _9.xxx * _143;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _143 = stage_input._143;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _577;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _85 = dot(_16_m1.xyz, _16_m1.xyz);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _16_m1.xyz;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _62 *= _16_m3.xyz;
    _47 = _47.xxx * _62;
    _9 = _9.xxx * _47;
    _577 = vs_TEXCOORD5;
    _577 = clamp(_577, 0.0f, 1.0f);
    _9 *= _577.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR)
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
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD5;
static float3 _136;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _136 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
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
    vs_TEXCOORD0 = (_21_m1[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m3[1];
    _9 = (_21_m3[0] * _44.xxxx) + _9;
    _9 = (_21_m3[2] * _44.zzzz) + _9;
    _9 = (_21_m3[3] * _44.wwww) + _9;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD5 = (_9.x * _21_m4.z) + _21_m4.w;
    _9.x = dot(_136, _21_m2[0].xyz);
    _9.y = dot(_136, _21_m2[1].xyz);
    _9.z = dot(_136, _21_m2[2].xyz);
    _155 = dot(_9.xyz, _9.xyz);
    _155 = rsqrt(_155);
    vs_TEXCOORD1 = _155.xxx * _9.xyz;
    _9.x = dot(_136, _136);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD2 = _9.xxx * _136;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _136 = stage_input._136;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _577;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _85 = dot(_16_m1.xyz, _16_m1.xyz);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _16_m1.xyz;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _62 *= _16_m3.xyz;
    _47 = _47.xxx * _62;
    _9 = _9.xxx * _47;
    _577 = vs_TEXCOORD5;
    _577 = clamp(_577, 0.0f, 1.0f);
    _9 *= _577.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _146;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _165;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m4.y;
    vs_TEXCOORD5 = exp2(-_45.x);
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _165 = dot(_45.xyz, _45.xyz);
    _165 = rsqrt(_165);
    vs_TEXCOORD1 = _165.xxx * _45.xyz;
    _45.x = dot(_146, _146);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _146;
    float2 _199 = _9.yy * _22_m5[1].xy;
    _45 = float4(_199.x, _199.y, _45.z, _45.w);
    float2 _210 = (_22_m5[0].xy * _9.xx) + _45.xy;
    _9 = float4(_210.x, _210.y, _9.z, _9.w);
    float2 _221 = (_22_m5[2].xy * _9.zz) + _9.xy;
    _9 = float4(_221.x, _221.y, _9.z, _9.w);
    vs_TEXCOORD3 = (_22_m5[3].xy * _9.ww) + _9.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD5 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _589;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _85 = dot(_16_m1.xyz, _16_m1.xyz);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _16_m1.xyz;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = _LightTexture0.Sample(sampler_LightTexture0, vs_TEXCOORD3).w;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _589 = vs_TEXCOORD5;
    _589 = clamp(_589, 0.0f, 1.0f);
    _9 *= _589.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _152;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _152 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _171;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m4.x;
    _45.x *= (-_45.x);
    vs_TEXCOORD5 = exp2(_45.x);
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_152, _22_m2[0].xyz);
    _45.y = dot(_152, _22_m2[1].xyz);
    _45.z = dot(_152, _22_m2[2].xyz);
    _171 = dot(_45.xyz, _45.xyz);
    _171 = rsqrt(_171);
    vs_TEXCOORD1 = _171.xxx * _45.xyz;
    _45.x = dot(_152, _152);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _152;
    float2 _205 = _9.yy * _22_m5[1].xy;
    _45 = float4(_205.x, _205.y, _45.z, _45.w);
    float2 _216 = (_22_m5[0].xy * _9.xx) + _45.xy;
    _9 = float4(_216.x, _216.y, _9.z, _9.w);
    float2 _227 = (_22_m5[2].xy * _9.zz) + _9.xy;
    _9 = float4(_227.x, _227.y, _9.z, _9.w);
    vs_TEXCOORD3 = (_22_m5[3].xy * _9.ww) + _9.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _152 = stage_input._152;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD5 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _589;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _85 = dot(_16_m1.xyz, _16_m1.xyz);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _16_m1.xyz;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = _LightTexture0.Sample(sampler_LightTexture0, vs_TEXCOORD3).w;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _589 = vs_TEXCOORD5;
    _589 = clamp(_589, 0.0f, 1.0f);
    _9 *= _589.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _145;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _145 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD5 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _164;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    vs_TEXCOORD5 = (_45.x * _22_m4.z) + _22_m4.w;
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_145, _22_m2[0].xyz);
    _45.y = dot(_145, _22_m2[1].xyz);
    _45.z = dot(_145, _22_m2[2].xyz);
    _164 = dot(_45.xyz, _45.xyz);
    _164 = rsqrt(_164);
    vs_TEXCOORD1 = _164.xxx * _45.xyz;
    _45.x = dot(_145, _145);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _145;
    float2 _198 = _9.yy * _22_m5[1].xy;
    _45 = float4(_198.x, _198.y, _45.z, _45.w);
    float2 _209 = (_22_m5[0].xy * _9.xx) + _45.xy;
    _9 = float4(_209.x, _209.y, _9.z, _9.w);
    float2 _220 = (_22_m5[2].xy * _9.zz) + _9.xy;
    _9 = float4(_220.x, _220.y, _9.z, _9.w);
    vs_TEXCOORD3 = (_22_m5[3].xy * _9.ww) + _9.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float vs_TEXCOORD5 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _589;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _85 = dot(_16_m1.xyz, _16_m1.xyz);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _16_m1.xyz;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = _LightTexture0.Sample(sampler_LightTexture0, vs_TEXCOORD3).w;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _589 = vs_TEXCOORD5;
    _589 = clamp(_589, 0.0f, 1.0f);
    _9 *= _589.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _146;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _165;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m4.y;
    vs_TEXCOORD5 = exp2(-_45.x);
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _165 = dot(_45.xyz, _45.xyz);
    _165 = rsqrt(_165);
    vs_TEXCOORD1 = _165.xxx * _45.xyz;
    _45.x = dot(_146, _146);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _146;
    float3 _198 = _9.yyy * _22_m5[1].xyz;
    _45 = float4(_198.x, _198.y, _198.z, _45.w);
    float3 _209 = (_22_m5[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    float3 _220 = (_22_m5[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_220.x, _220.y, _220.z, _9.w);
    vs_TEXCOORD3 = (_22_m5[3].xyz * _9.www) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _592;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _563 = _LightTexture0.Sample(sampler_LightTexture0, _563.xx).x;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _592 = vs_TEXCOORD5;
    _592 = clamp(_592, 0.0f, 1.0f);
    _9 *= _592.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _146;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _165;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m4.y;
    vs_TEXCOORD5 = exp2(-_45.x);
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _165 = dot(_45.xyz, _45.xyz);
    _165 = rsqrt(_165);
    vs_TEXCOORD1 = _165.xxx * _45.xyz;
    _45.x = dot(_146, _146);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _146;
    float3 _198 = _9.yyy * _22_m5[1].xyz;
    _45 = float4(_198.x, _198.y, _198.z, _45.w);
    float3 _209 = (_22_m5[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_209.x, _209.y, _209.z, _45.w);
    float3 _220 = (_22_m5[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_220.x, _220.y, _220.z, _9.w);
    vs_TEXCOORD3 = (_22_m5[3].xyz * _9.www) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _574;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _563 = _LightTextureB0.Sample(sampler_LightTextureB0, _563.xx).x;
    _574 = _LightTexture0.Sample(sampler_LightTexture0, vs_TEXCOORD3).w;
    _563 = _574 * _563;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _574 = vs_TEXCOORD5;
    _574 = clamp(_574, 0.0f, 1.0f);
    _9 *= _574.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _146;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _146 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _165;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m4.y;
    vs_TEXCOORD5 = exp2(-_45.x);
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_146, _22_m2[0].xyz);
    _45.y = dot(_146, _22_m2[1].xyz);
    _45.z = dot(_146, _22_m2[2].xyz);
    _165 = dot(_45.xyz, _45.xyz);
    _165 = rsqrt(_165);
    vs_TEXCOORD1 = _165.xxx * _45.xyz;
    _45.x = dot(_146, _146);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _146;
    _45 = _9.yyyy * _22_m5[1];
    _45 = (_22_m5[0] * _9.xxxx) + _45;
    _45 = (_22_m5[2] * _9.zzzz) + _45;
    vs_TEXCOORD3 = (_22_m5[3] * _9.wwww) + _45;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _146 = stage_input._146;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static bool _563;
static float _570;
static float2 _574;
static float _627;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = 0.0f < vs_TEXCOORD3.z;
    _570 = float(_563);
    _574 = vs_TEXCOORD3.xy / vs_TEXCOORD3.ww;
    _574 += 0.5f.xx;
    _574.x = _LightTexture0.Sample(sampler_LightTexture0, _574).w;
    _570 = _574.x * _570;
    _574.x = dot(vs_TEXCOORD3.xyz, vs_TEXCOORD3.xyz);
    _574.x = _LightTextureB0.Sample(sampler_LightTextureB0, _574.xx).x;
    _570 = _574.x * _570;
    _62 *= _16_m3.xyz;
    _47 = _47.xxx * _62;
    _47 = _570.xxx * _47;
    _9 = _9.xxx * _47;
    _627 = vs_TEXCOORD5;
    _627 = clamp(_627, 0.0f, 1.0f);
    _9 *= _627.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _152;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _152 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _171;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m4.x;
    _45.x *= (-_45.x);
    vs_TEXCOORD5 = exp2(_45.x);
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_152, _22_m2[0].xyz);
    _45.y = dot(_152, _22_m2[1].xyz);
    _45.z = dot(_152, _22_m2[2].xyz);
    _171 = dot(_45.xyz, _45.xyz);
    _171 = rsqrt(_171);
    vs_TEXCOORD1 = _171.xxx * _45.xyz;
    _45.x = dot(_152, _152);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _152;
    float3 _204 = _9.yyy * _22_m5[1].xyz;
    _45 = float4(_204.x, _204.y, _204.z, _45.w);
    float3 _215 = (_22_m5[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_215.x, _215.y, _215.z, _45.w);
    float3 _226 = (_22_m5[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_226.x, _226.y, _226.z, _9.w);
    vs_TEXCOORD3 = (_22_m5[3].xyz * _9.www) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _152 = stage_input._152;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _592;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _563 = _LightTexture0.Sample(sampler_LightTexture0, _563.xx).x;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _592 = vs_TEXCOORD5;
    _592 = clamp(_592, 0.0f, 1.0f);
    _9 *= _592.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _152;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _152 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _171;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m4.x;
    _45.x *= (-_45.x);
    vs_TEXCOORD5 = exp2(_45.x);
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_152, _22_m2[0].xyz);
    _45.y = dot(_152, _22_m2[1].xyz);
    _45.z = dot(_152, _22_m2[2].xyz);
    _171 = dot(_45.xyz, _45.xyz);
    _171 = rsqrt(_171);
    vs_TEXCOORD1 = _171.xxx * _45.xyz;
    _45.x = dot(_152, _152);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _152;
    float3 _204 = _9.yyy * _22_m5[1].xyz;
    _45 = float4(_204.x, _204.y, _204.z, _45.w);
    float3 _215 = (_22_m5[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_215.x, _215.y, _215.z, _45.w);
    float3 _226 = (_22_m5[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_226.x, _226.y, _226.z, _9.w);
    vs_TEXCOORD3 = (_22_m5[3].xyz * _9.www) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _152 = stage_input._152;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _574;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _563 = _LightTextureB0.Sample(sampler_LightTextureB0, _563.xx).x;
    _574 = _LightTexture0.Sample(sampler_LightTexture0, vs_TEXCOORD3).w;
    _563 = _574 * _563;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _574 = vs_TEXCOORD5;
    _574 = clamp(_574, 0.0f, 1.0f);
    _9 *= _574.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _152;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _152 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _171;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    _45.x *= _22_m4.x;
    _45.x *= (-_45.x);
    vs_TEXCOORD5 = exp2(_45.x);
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_152, _22_m2[0].xyz);
    _45.y = dot(_152, _22_m2[1].xyz);
    _45.z = dot(_152, _22_m2[2].xyz);
    _171 = dot(_45.xyz, _45.xyz);
    _171 = rsqrt(_171);
    vs_TEXCOORD1 = _171.xxx * _45.xyz;
    _45.x = dot(_152, _152);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _152;
    _45 = _9.yyyy * _22_m5[1];
    _45 = (_22_m5[0] * _9.xxxx) + _45;
    _45 = (_22_m5[2] * _9.zzzz) + _45;
    vs_TEXCOORD3 = (_22_m5[3] * _9.wwww) + _45;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _152 = stage_input._152;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static bool _563;
static float _570;
static float2 _574;
static float _627;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = 0.0f < vs_TEXCOORD3.z;
    _570 = float(_563);
    _574 = vs_TEXCOORD3.xy / vs_TEXCOORD3.ww;
    _574 += 0.5f.xx;
    _574.x = _LightTexture0.Sample(sampler_LightTexture0, _574).w;
    _570 = _574.x * _570;
    _574.x = dot(vs_TEXCOORD3.xyz, vs_TEXCOORD3.xyz);
    _574.x = _LightTextureB0.Sample(sampler_LightTextureB0, _574.xx).x;
    _570 = _574.x * _570;
    _62 *= _16_m3.xyz;
    _47 = _47.xxx * _62;
    _47 = _570.xxx * _47;
    _9 = _9.xxx * _47;
    _627 = vs_TEXCOORD5;
    _627 = clamp(_627, 0.0f, 1.0f);
    _9 *= _627.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _145;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _145 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _164;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    vs_TEXCOORD5 = (_45.x * _22_m4.z) + _22_m4.w;
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_145, _22_m2[0].xyz);
    _45.y = dot(_145, _22_m2[1].xyz);
    _45.z = dot(_145, _22_m2[2].xyz);
    _164 = dot(_45.xyz, _45.xyz);
    _164 = rsqrt(_164);
    vs_TEXCOORD1 = _164.xxx * _45.xyz;
    _45.x = dot(_145, _145);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _145;
    float3 _197 = _9.yyy * _22_m5[1].xyz;
    _45 = float4(_197.x, _197.y, _197.z, _45.w);
    float3 _208 = (_22_m5[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    float3 _219 = (_22_m5[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_219.x, _219.y, _219.z, _9.w);
    vs_TEXCOORD3 = (_22_m5[3].xyz * _9.www) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _592;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _563 = _LightTexture0.Sample(sampler_LightTexture0, _563.xx).x;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _592 = vs_TEXCOORD5;
    _592 = clamp(_592, 0.0f, 1.0f);
    _9 *= _592.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _145;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _145 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _164;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    vs_TEXCOORD5 = (_45.x * _22_m4.z) + _22_m4.w;
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_145, _22_m2[0].xyz);
    _45.y = dot(_145, _22_m2[1].xyz);
    _45.z = dot(_145, _22_m2[2].xyz);
    _164 = dot(_45.xyz, _45.xyz);
    _164 = rsqrt(_164);
    vs_TEXCOORD1 = _164.xxx * _45.xyz;
    _45.x = dot(_145, _145);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _145;
    float3 _197 = _9.yyy * _22_m5[1].xyz;
    _45 = float4(_197.x, _197.y, _197.z, _45.w);
    float3 _208 = (_22_m5[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_208.x, _208.y, _208.z, _45.w);
    float3 _219 = (_22_m5[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_219.x, _219.y, _219.z, _9.w);
    vs_TEXCOORD3 = (_22_m5[3].xyz * _9.www) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _574;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _563 = _LightTextureB0.Sample(sampler_LightTextureB0, _563.xx).x;
    _574 = _LightTexture0.Sample(sampler_LightTexture0, vs_TEXCOORD3).w;
    _563 = _574 * _563;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _574 = vs_TEXCOORD5;
    _574 = clamp(_574, 0.0f, 1.0f);
    _9 *= _574.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _22_m1[4];
float4x4 unity_WorldToObject;
static float4 _22_m2[4];
float4x4 unity_MatrixVP;
static float4 _22_m3[4];
float4 unity_FogParams;
float4x4 unity_WorldToLight;
static float4 _22_m5[4];
void __unity_init()
{
    _22_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m5[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m5[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m5[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m5[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}
#define _22_m0 _ProjectionParams
#define _22_m4 unity_FogParams



static float4 gl_Position;
static float4 _11;
static float vs_TEXCOORD5;
static float3 vs_TEXCOORD0;
static float3 _145;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _145 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _164;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m1[1];
    _9 = (_22_m1[0] * _11.xxxx) + _9;
    _9 = (_22_m1[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m1[3];
    _51 = _45.yyyy * _22_m3[1];
    _51 = (_22_m3[0] * _45.xxxx) + _51;
    _51 = (_22_m3[2] * _45.zzzz) + _51;
    _45 = (_22_m3[3] * _45.wwww) + _51;
    gl_Position = _45;
    _45.x = _45.z / _22_m0.y;
    _45.x = (-_45.x) + 1.0f;
    _45.x *= _22_m0.z;
    _45.x = max(_45.x, 0.0f);
    vs_TEXCOORD5 = (_45.x * _22_m4.z) + _22_m4.w;
    vs_TEXCOORD0 = (_22_m1[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m1[3] * _11.wwww) + _9;
    _45.x = dot(_145, _22_m2[0].xyz);
    _45.y = dot(_145, _22_m2[1].xyz);
    _45.z = dot(_145, _22_m2[2].xyz);
    _164 = dot(_45.xyz, _45.xyz);
    _164 = rsqrt(_164);
    vs_TEXCOORD1 = _164.xxx * _45.xyz;
    _45.x = dot(_145, _145);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _145;
    _45 = _9.yyyy * _22_m5[1];
    _45 = (_22_m5[0] * _9.xxxx) + _45;
    _45 = (_22_m5[2] * _9.zzzz) + _45;
    vs_TEXCOORD3 = (_22_m5[3] * _9.wwww) + _45;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _145 = stage_input._145;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;
static float vs_TEXCOORD5;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD5 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float4 vs_TEXCOORD3 : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static bool _563;
static float _570;
static float2 _574;
static float _627;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = 0.0f < vs_TEXCOORD3.z;
    _570 = float(_563);
    _574 = vs_TEXCOORD3.xy / vs_TEXCOORD3.ww;
    _574 += 0.5f.xx;
    _574.x = _LightTexture0.Sample(sampler_LightTexture0, _574).w;
    _570 = _574.x * _570;
    _574.x = dot(vs_TEXCOORD3.xyz, vs_TEXCOORD3.xyz);
    _574.x = _LightTextureB0.Sample(sampler_LightTextureB0, _574.xx).x;
    _570 = _574.x * _570;
    _62 *= _16_m3.xyz;
    _47 = _47.xxx * _62;
    _47 = _570.xxx * _47;
    _9 = _9.xxx * _47;
    _627 = vs_TEXCOORD5;
    _627 = clamp(_627, 0.0f, 1.0f);
    _9 *= _627.xxx;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4x4 unity_MatrixVP;
static float4 _22_m2[4];
float4x4 unity_WorldToLight;
static float4 _22_m3[4];
void __unity_init()
{
    _22_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 _105;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float2 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _105 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _127;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m0[1];
    _9 = (_22_m0[0] * _11.xxxx) + _9;
    _9 = (_22_m0[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m0[3];
    _51 = _45.yyyy * _22_m2[1];
    _51 = (_22_m2[0] * _45.xxxx) + _51;
    _51 = (_22_m2[2] * _45.zzzz) + _51;
    gl_Position = (_22_m2[3] * _45.wwww) + _51;
    vs_TEXCOORD0 = (_22_m0[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m0[3] * _11.wwww) + _9;
    _45.x = dot(_105, _22_m1[0].xyz);
    _45.y = dot(_105, _22_m1[1].xyz);
    _45.z = dot(_105, _22_m1[2].xyz);
    _127 = dot(_45.xyz, _45.xyz);
    _127 = rsqrt(_127);
    vs_TEXCOORD1 = _127.xxx * _45.xyz;
    _45.x = dot(_105, _105);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _105;
    float2 _160 = _9.yy * _22_m3[1].xy;
    _45 = float4(_160.x, _160.y, _45.z, _45.w);
    float2 _171 = (_22_m3[0].xy * _9.xx) + _45.xy;
    _9 = float4(_171.x, _171.y, _9.z, _9.w);
    float2 _182 = (_22_m3[2].xy * _9.zz) + _9.xy;
    _9 = float4(_182.x, _182.y, _9.z, _9.w);
    vs_TEXCOORD3 = (_22_m3[3].xy * _9.ww) + _9.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _105 = stage_input._105;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float2 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float2 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _85 = dot(_16_m1.xyz, _16_m1.xyz);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _16_m1.xyz;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = _LightTexture0.Sample(sampler_LightTexture0, vs_TEXCOORD3).w;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(POINT)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4x4 unity_MatrixVP;
static float4 _22_m2[4];
float4x4 unity_WorldToLight;
static float4 _22_m3[4];
void __unity_init()
{
    _22_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 _105;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _105 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _127;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m0[1];
    _9 = (_22_m0[0] * _11.xxxx) + _9;
    _9 = (_22_m0[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m0[3];
    _51 = _45.yyyy * _22_m2[1];
    _51 = (_22_m2[0] * _45.xxxx) + _51;
    _51 = (_22_m2[2] * _45.zzzz) + _51;
    gl_Position = (_22_m2[3] * _45.wwww) + _51;
    vs_TEXCOORD0 = (_22_m0[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m0[3] * _11.wwww) + _9;
    _45.x = dot(_105, _22_m1[0].xyz);
    _45.y = dot(_105, _22_m1[1].xyz);
    _45.z = dot(_105, _22_m1[2].xyz);
    _127 = dot(_45.xyz, _45.xyz);
    _127 = rsqrt(_127);
    vs_TEXCOORD1 = _127.xxx * _45.xyz;
    _45.x = dot(_105, _105);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _105;
    float3 _159 = _9.yyy * _22_m3[1].xyz;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    float3 _170 = (_22_m3[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_170.x, _170.y, _170.z, _45.w);
    float3 _181 = (_22_m3[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_181.x, _181.y, _181.z, _9.w);
    vs_TEXCOORD3 = (_22_m3[3].xyz * _9.www) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _105 = stage_input._105;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _563 = _LightTexture0.Sample(sampler_LightTexture0, _563.xx).x;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(POINT_COOKIE)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4x4 unity_MatrixVP;
static float4 _22_m2[4];
float4x4 unity_WorldToLight;
static float4 _22_m3[4];
void __unity_init()
{
    _22_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 _105;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _105 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _127;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m0[1];
    _9 = (_22_m0[0] * _11.xxxx) + _9;
    _9 = (_22_m0[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m0[3];
    _51 = _45.yyyy * _22_m2[1];
    _51 = (_22_m2[0] * _45.xxxx) + _51;
    _51 = (_22_m2[2] * _45.zzzz) + _51;
    gl_Position = (_22_m2[3] * _45.wwww) + _51;
    vs_TEXCOORD0 = (_22_m0[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m0[3] * _11.wwww) + _9;
    _45.x = dot(_105, _22_m1[0].xyz);
    _45.y = dot(_105, _22_m1[1].xyz);
    _45.z = dot(_105, _22_m1[2].xyz);
    _127 = dot(_45.xyz, _45.xyz);
    _127 = rsqrt(_127);
    vs_TEXCOORD1 = _127.xxx * _45.xyz;
    _45.x = dot(_105, _105);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _105;
    float3 _159 = _9.yyy * _22_m3[1].xyz;
    _45 = float4(_159.x, _159.y, _159.z, _45.w);
    float3 _170 = (_22_m3[0].xyz * _9.xxx) + _45.xyz;
    _45 = float4(_170.x, _170.y, _170.z, _45.w);
    float3 _181 = (_22_m3[2].xyz * _9.zzz) + _45.xyz;
    _9 = float4(_181.x, _181.y, _181.z, _9.w);
    vs_TEXCOORD3 = (_22_m3[3].xyz * _9.www) + _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _105 = stage_input._105;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;
TextureCube<float4> _LightTexture0;
SamplerState sampler_LightTexture0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float3 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static float _563;
static float _574;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = dot(vs_TEXCOORD3, vs_TEXCOORD3);
    _563 = _LightTextureB0.Sample(sampler_LightTextureB0, _563.xx).x;
    _574 = _LightTexture0.Sample(sampler_LightTexture0, vs_TEXCOORD3).w;
    _563 = _574 * _563;
    _62 *= _16_m3.xyz;
    _62 = _47.xxx * _62;
    _47 = _563.xxx * _62;
    _9 = _9.xxx * _47;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#elif defined(SPOT)
#if defined(SHADER_STAGE_VERTEX)
float4x4 unity_ObjectToWorld;
static float4 _22_m0[4];
float4x4 unity_WorldToObject;
static float4 _22_m1[4];
float4x4 unity_MatrixVP;
static float4 _22_m2[4];
float4x4 unity_WorldToLight;
static float4 _22_m3[4];
void __unity_init()
{
    _22_m0[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _22_m0[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _22_m0[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _22_m0[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _22_m1[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _22_m1[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _22_m1[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _22_m1[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _22_m2[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _22_m2[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _22_m2[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _22_m2[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
    _22_m3[0] = float4(unity_WorldToLight[0][0], unity_WorldToLight[1][0], unity_WorldToLight[2][0], unity_WorldToLight[3][0]);
    _22_m3[1] = float4(unity_WorldToLight[0][1], unity_WorldToLight[1][1], unity_WorldToLight[2][1], unity_WorldToLight[3][1]);
    _22_m3[2] = float4(unity_WorldToLight[0][2], unity_WorldToLight[1][2], unity_WorldToLight[2][2], unity_WorldToLight[3][2]);
    _22_m3[3] = float4(unity_WorldToLight[0][3], unity_WorldToLight[1][3], unity_WorldToLight[2][3], unity_WorldToLight[3][3]);
}




static float4 gl_Position;
static float4 _11;
static float3 vs_TEXCOORD0;
static float3 _105;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float4 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _105 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _45;
static float4 _51;
static float _127;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _22_m0[1];
    _9 = (_22_m0[0] * _11.xxxx) + _9;
    _9 = (_22_m0[2] * _11.zzzz) + _9;
    _45 = _9 + _22_m0[3];
    _51 = _45.yyyy * _22_m2[1];
    _51 = (_22_m2[0] * _45.xxxx) + _51;
    _51 = (_22_m2[2] * _45.zzzz) + _51;
    gl_Position = (_22_m2[3] * _45.wwww) + _51;
    vs_TEXCOORD0 = (_22_m0[3].xyz * _11.www) + _9.xyz;
    _9 = (_22_m0[3] * _11.wwww) + _9;
    _45.x = dot(_105, _22_m1[0].xyz);
    _45.y = dot(_105, _22_m1[1].xyz);
    _45.z = dot(_105, _22_m1[2].xyz);
    _127 = dot(_45.xyz, _45.xyz);
    _127 = rsqrt(_127);
    vs_TEXCOORD1 = _127.xxx * _45.xyz;
    _45.x = dot(_105, _105);
    _45.x = rsqrt(_45.x);
    vs_TEXCOORD2 = _45.xxx * _105;
    _45 = _9.yyyy * _22_m3[1];
    _45 = (_22_m3[0] * _9.xxxx) + _45;
    _45 = (_22_m3[2] * _9.zzzz) + _45;
    vs_TEXCOORD3 = (_22_m3[3] * _9.wwww) + _45;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _105 = stage_input._105;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;
Texture2D<float4> _LightTexture0;
SamplerState sampler_LightTexture0;
Texture2D<float4> _LightTextureB0;
SamplerState sampler_LightTextureB0;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;
static float4 vs_TEXCOORD3;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
    float4 vs_TEXCOORD3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;
static bool _563;
static float _570;
static float2 _574;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _76 = (-vs_TEXCOORD0) + _16_m1.xyz;
    _85 = dot(_76, _76);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _76;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _563 = 0.0f < vs_TEXCOORD3.z;
    _570 = float(_563);
    _574 = vs_TEXCOORD3.xy / vs_TEXCOORD3.ww;
    _574 += 0.5f.xx;
    _574.x = _LightTexture0.Sample(sampler_LightTexture0, _574).w;
    _570 = _574.x * _570;
    _574.x = dot(vs_TEXCOORD3.xyz, vs_TEXCOORD3.xyz);
    _574.x = _LightTextureB0.Sample(sampler_LightTextureB0, _574.xx).x;
    _570 = _574.x * _570;
    _62 *= _16_m3.xyz;
    _47 = _47.xxx * _62;
    _47 = _570.xxx * _47;
    _9 = _9.xxx * _47;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
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
static float3 vs_TEXCOORD0;
static float3 _96;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _96 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
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
    vs_TEXCOORD0 = (_21_m0[3].xyz * _11.www) + _9.xyz;
    _9 = _44.yyyy * _21_m2[1];
    _9 = (_21_m2[0] * _44.xxxx) + _9;
    _9 = (_21_m2[2] * _44.zzzz) + _9;
    gl_Position = (_21_m2[3] * _44.wwww) + _9;
    _9.x = dot(_96, _21_m1[0].xyz);
    _9.y = dot(_96, _21_m1[1].xyz);
    _9.z = dot(_96, _21_m1[2].xyz);
    _118 = dot(_9.xyz, _9.xyz);
    _118 = rsqrt(_118);
    vs_TEXCOORD1 = _118.xxx * _9.xyz;
    _9.x = dot(_96, _96);
    _9.x = rsqrt(_9.x);
    vs_TEXCOORD2 = _9.xxx * _96;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _96 = stage_input._96;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _WorldSpaceLightPos0;
float4x4 unity_WorldToObject;
static float4 _16_m2[4];
float4 _LightColor0;
float4 _MainColor;
float4 _FrenselOutlineColor;
float4 _EyeOffset;
float _EyeSize;
float _EyeFalloff;
float _FrenselOutlinePower;
float _FrenselOutlineMultiplier;
float _VolumeIntensity;
float _UseLookDirection;
float4 _LookDirection;
float4 _IrisForward;
float4 _IrisUp;
float _LookStraightDistance;
float _LookStraightSoftness;
void __unity_init()
{
    _16_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _16_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _16_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _16_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
}
#define _16_m0 _WorldSpaceCameraPos
#define _16_m1 _WorldSpaceLightPos0
#define _16_m3 _LightColor0
#define _16_m4 _MainColor
#define _16_m5 _FrenselOutlineColor
#define _16_m6 _EyeOffset
#define _16_m7 _EyeSize
#define _16_m8 _EyeFalloff
#define _16_m9 _FrenselOutlinePower
#define _16_m10 _FrenselOutlineMultiplier
#define _16_m11 _VolumeIntensity
#define _16_m12 _UseLookDirection
#define _16_m13 _LookDirection
#define _16_m14 _IrisForward
#define _16_m15 _IrisUp
#define _16_m16 _LookStraightDistance
#define _16_m17 _LookStraightSoftness


Texture2D<float4> _EyeTex;
SamplerState sampler_EyeTex;

static float4 _44;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float3 vs_TEXCOORD2 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _44 : SV_Target0;
};

static float3 _9;
static bool _35;
static float3 _47;
static float3 _62;
static float3 _76;
static float _85;
static float _89;
static float4 _97;
static float3 _155;
static float3 _162;
static float3 _188;
static float _222;
static float _231;
static bool4 _391;
static float _424;
static float3 _438;
static float3 _462;

void frag_inner()
{
    __unity_init();
    _9.x = (-_16_m11) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _35 = 0.001000000047497451305389404296875f >= _9.x;
    if (_35)
    {
        _44 = 0.0f.xxxx;
        return;
    }
    _47.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _47.x = rsqrt(_47.x);
    _47 = _47.xxx * vs_TEXCOORD1;
    _62.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _62.x = rsqrt(_62.x);
    _62 = _62.xxx * vs_TEXCOORD2;
    _76 = (-vs_TEXCOORD0) + _16_m0;
    _85 = dot(_76, _76);
    _89 = rsqrt(_85);
    _76 = _89.xxx * _76;
    float3 _106 = _76.yyy * _16_m2[1].zxy;
    _97 = float4(_106.x, _106.y, _106.z, _97.w);
    float3 _117 = (_16_m2[0].zxy * _76.xxx) + _97.xyz;
    _97 = float4(_117.x, _117.y, _117.z, _97.w);
    float3 _128 = (_16_m2[2].zxy * _76.zzz) + _97.xyz;
    _97 = float4(_128.x, _128.y, _128.z, _97.w);
    _89 = dot(_97.xyz, _97.xyz);
    _89 = rsqrt(_89);
    float3 _142 = _89.xxx * _97.xyz;
    _97 = float4(_142.x, _142.y, _142.z, _97.w);
    _89 = dot(_16_m14.xyz, _16_m14.xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m14.zxy;
    _162 = _155.yzx * _16_m15.yzx;
    _162 = (_16_m15.xyz * _155.zxy) + (-_162);
    _89 = dot(_162, _162);
    _89 = rsqrt(_89);
    _162 = _89.xxx * _162;
    _188 = _155.zxy * _162.yzx;
    _188 = (_155.yzx * _162.zxy) + (-_188);
    _155 = (_16_m13.xxx * _162) + _155;
    _155 = (_16_m13.yyy * _188) + _155;
    _89 = dot(_155, _155);
    _89 = rsqrt(_89);
    _222 = (-_16_m17) + _16_m16;
    _231 = _16_m17 + _16_m16;
    _85 = sqrt(_85);
    _231 = (-_222) + _231;
    _85 = (-_222) + _85;
    _222 = 1.0f / _231;
    _85 *= _222;
    _85 = clamp(_85, 0.0f, 1.0f);
    _222 = (_85 * (-2.0f)) + 3.0f;
    _85 *= _85;
    _85 *= _222;
    _85 = max(_85, _16_m12);
    _155 = (_155 * _89.xxx) + (-_97.xyz);
    float3 _284 = (_85.xxx * _155) + _97.xyz;
    _97 = float4(_284.x, _284.y, _284.z, _97.w);
    _85 = dot(_62.zxy, _97.xyz);
    _85 = clamp(_85, 0.0f, 1.0f);
    _89 = dot(_16_m2[1].xyz, _16_m2[1].xyz);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _16_m2[1].zxy;
    _162 = _97.zxy * _155;
    _155 = (_155.zxy * _97.xyz) + (-_162);
    _89 = dot(_155, _155);
    _89 = max(_89, 9.9999999747524270787835121154785e-07f);
    _89 = rsqrt(_89);
    _155 = _89.xxx * _155;
    _162 = _97.xyz * _155.yzx;
    float3 _345 = (_97.zxy * _155.zxy) + (-_162);
    _97 = float4(_345.x, _345.y, _345.z, _97.w);
    _155.x = dot(_62, _155);
    _155.y = dot(_62, _97.xyz);
    _62.x = max(_16_m7, 9.9999997473787516355514526367188e-05f);
    float2 _369 = _155.xy / _62.xx;
    _62 = float3(_369.x, _369.y, _62.z);
    float2 _381 = (_62.xy * 0.5f.xx) + _16_m6.xy;
    _62 = float3(_381.x, _381.y, _62.z);
    float2 _386 = _62.xy + 0.5f.xx;
    _62 = float3(_386.x, _386.y, _62.z);
    bool2 _396 = bool4(_62.xyxx.x >= 0.0f.xxxx.x, _62.xyxx.y >= 0.0f.xxxx.y, _62.xyxx.z >= 0.0f.xxxx.z, _62.xyxx.w >= 0.0f.xxxx.w).xy;
    _391 = bool4(_396.x, _396.y, _391.z, _391.w);
    bool2 _403 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _62.xxxy.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _62.xxxy.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _62.xxxy.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _62.xxxy.w).zw;
    _391 = bool4(_391.x, _391.y, _403.x, _403.y);
    _97.x = float(_391.x);
    _97.y = float(_391.y);
    _97.z = float(_391.z);
    _97.w = float(_391.w);
    _424 = _97.z * _97.x;
    _424 = _97.y * _424;
    _424 = _97.w * _424;
    _438 = _EyeTex.Sample(sampler_EyeTex, _62.xy).xyz;
    _62.x = 1.0f / _16_m8;
    _62.x *= _85;
    _62.x = clamp(_62.x, 0.0f, 1.0f);
    _462.x = (_62.x * (-2.0f)) + 3.0f;
    _62.x *= _62.x;
    _62.x *= _462.x;
    _62.x *= _424;
    _462 = _438 + (-_16_m4.xyz);
    _62 = (_62.xxx * _462) + _16_m4.xyz;
    _85 = dot(_47, _76);
    _85 = clamp(_85, 0.0f, 1.0f);
    _85 = (-_85) + 1.0f;
    _85 = log2(_85);
    _85 *= _16_m9;
    _85 = exp2(_85);
    _76 = _85.xxx * _16_m5.xyz;
    _62 = (_76 * float3(float3(_16_m10, _16_m10, _16_m10))) + _62;
    _85 = dot(_16_m1.xyz, _16_m1.xyz);
    _85 = rsqrt(_85);
    _76 = _85.xxx * _16_m1.xyz;
    _47.x = dot(_47, _76);
    _47.x = clamp(_47.x, 0.0f, 1.0f);
    _62 *= _16_m3.xyz;
    _47 = _47.xxx * _62;
    _9 = _9.xxx * _47;
    _44 = float4(_9.x, _9.y, _9.z, _44.w);
    _44.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._44 = _44;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}