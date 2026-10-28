// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmSimSky" {
Properties {

_SkyCube ("Sky Cubemap", Cube) = "" { }

_SkyTint ("Sky Tint", Color) = (0.62,0.66,0.78,1)

_SkyIntensity ("Sky Intensity", Range(0, 2)) = 0.550000011920929

_HorizonHaze ("Horizon Haze Height", Range(0.01, 0.6)) = 0.2199999988079071

_GroundTex ("Ground Grid", 2D) = "white" { }

_GroundTint ("Ground Tint", Color) = (0.3,0.32,0.36,1)

_GroundY ("Ground Height (world)", Float) = 7.0

_TileMeters ("Metres per Grid Tile", Float) = 4.0

_GridOrigin ("Grid Origin (world)", Vector) = (0,0,0,0)

_EdgeColor ("Boundary Grid", Color) = (0.75,0.88,1,1)

_EdgeRadius ("Boundary Reveal Radius (m)", Float) = 2.5999999046325684

_EdgeCell ("Boundary Grid Cell (m)", Float) = 0.5

}
SubShader {
 Tags { "QUEUE" = "Geometry+400" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "QUEUE" = "Geometry+400" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
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
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4x4 unity_MatrixV;
static float4 _19_m1[4];
float4 unity_FogColor;
float4 unity_FogParams;
float4 _SkyCube_HDR;
float4 _SkyTint;
float4 _GroundTint;
float4 _EdgeColor;
float _SkyIntensity;
float _HorizonHaze;
float _GroundY;
float _TileMeters;
float _EdgeRadius;
float _EdgeCell;
float4 _GridOrigin;
float4 _BtmRevealCenter;
float4 _BtmHandL;
float4 _BtmHandR;
void __unity_init()
{
    _19_m1[0] = float4(unity_MatrixV[0][0], unity_MatrixV[1][0], unity_MatrixV[2][0], unity_MatrixV[3][0]);
    _19_m1[1] = float4(unity_MatrixV[0][1], unity_MatrixV[1][1], unity_MatrixV[2][1], unity_MatrixV[3][1]);
    _19_m1[2] = float4(unity_MatrixV[0][2], unity_MatrixV[1][2], unity_MatrixV[2][2], unity_MatrixV[3][2]);
    _19_m1[3] = float4(unity_MatrixV[0][3], unity_MatrixV[1][3], unity_MatrixV[2][3], unity_MatrixV[3][3]);
}
#define _19_m0 _WorldSpaceCameraPos
#define _19_m2 unity_FogColor
#define _19_m3 unity_FogParams
#define _19_m4 _SkyCube_HDR
#define _19_m5 _SkyTint
#define _19_m6 _GroundTint
#define _19_m7 _EdgeColor
#define _19_m8 _SkyIntensity
#define _19_m9 _HorizonHaze
#define _19_m10 _GroundY
#define _19_m11 _TileMeters
#define _19_m12 _EdgeRadius
#define _19_m13 _EdgeCell
#define _19_m14 _GridOrigin
#define _19_m15 _BtmRevealCenter
#define _19_m16 _BtmHandL
#define _19_m17 _BtmHandR


Texture2D<float4> _GroundTex;
SamplerState sampler_GroundTex;
TextureCube<float4> _SkyCube;
SamplerState sampler_SkyCube;

static float3 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _647;

struct SPIRV_Cross_Input
{
    float3 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _647 : SV_Target0;
};

static float3 _9;
static float _28;
static bool _40;
static float3 _59;
static float4 _87;
static float4 _125;
static float3 _181;
static float3 _195;
static float3 _257;
static bool _311;
static bool _317;
static float4 _367;
static float _376;
static float3 _382;
static float3 _458;

void frag_inner()
{
    __unity_init();
    _9 = vs_TEXCOORD0 + (-_19_m0);
    _28 = dot(_9, _9);
    _28 = rsqrt(_28);
    _9 = _28.xxx * _9;
    _40 = _9.y < 0.0f;
    if (_40)
    {
        _40 = _19_m10 < _19_m0.y;
        if (_40)
        {
            _59.x = -_19_m1[0].z;
            _59.y = -_19_m1[1].z;
            _59.z = -_19_m1[2].z;
            _28 = (-_19_m0.y) + _19_m10;
            _28 /= _9.y;
            float2 _97 = (_9.xz * _28.xx) + _19_m0.xz;
            _87 = float4(_97.x, _97.y, _87.z, _87.w);
            float2 _108 = _87.xy + (-_19_m14.xz);
            _87 = float4(_108.x, _108.y, _87.z, _87.w);
            float2 _122 = _87.xy / float2(float2(_19_m11, _19_m11));
            _87 = float4(_122.x, _122.y, _87.z, _87.w);
            float3 _134 = _GroundTex.Sample(sampler_GroundTex, _87.xy).xyz;
            _125 = float4(_134.x, _134.y, _134.z, _125.w);
            _59.x = dot(_9, _59);
            _59.x = max(_59.x, 0.0500000007450580596923828125f);
            _28 *= _59.x;
            _28 *= _19_m3.x;
            _28 *= (-_28);
            _28 = exp2(_28);
            _59 = (_125.xyz * _19_m6.xyz) + (-_19_m2.xyz);
            _59 = (_28.xxx * _59) + _19_m2.xyz;
            _181 = _59;
        }
        else
        {
            _181 = _19_m2.xyz;
        }
    }
    else
    {
        _125 = _SkyCube.Sample(sampler_SkyCube, _9);
        _195.x = _125.w + (-1.0f);
        _195.x = (_19_m4.w * _195.x) + 1.0f;
        _195.x = log2(_195.x);
        _195.x *= _19_m4.y;
        _195.x = exp2(_195.x);
        _195.x *= _19_m4.x;
        _195 = _125.xyz * _195.xxx;
        _195 *= _19_m5.xyz;
        _9.x = 1.0f / _19_m9;
        _9.x *= _9.y;
        _9.x = clamp(_9.x, 0.0f, 1.0f);
        _257.x = (_9.x * (-2.0f)) + 3.0f;
        _9.x *= _9.x;
        _9.x *= _257.x;
        _257 = (_195 * _19_m8.xxx) + (-_19_m2.xyz);
        _59 = (_9.xxx * _257) + _19_m2.xyz;
        _181 = _59;
    }
    _9.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD1.yxz;
    _311 = 0.699999988079071044921875f < abs(_9.x);
    _317 = abs(_9.z) < abs(_9.y);
    float2 _327;
    if (_317)
    {
        _327 = vs_TEXCOORD0.zy;
    }
    else
    {
        _327 = vs_TEXCOORD0.xy;
    }
    _257 = float3(_327.x, _327.y, _257.z);
    float2 _339;
    if (_311)
    {
        _339 = vs_TEXCOORD0.xz;
    }
    else
    {
        _339 = _257.xy;
    }
    _9 = float3(_339.x, _339.y, _9.z);
    float2 _361 = _9.xy / float2(float2(_19_m13, _19_m13));
    _9 = float3(_361.x, _361.y, _9.z);
    _87 = ddx_coarse(_9.xyxy);
    _367 = ddy_coarse(_9.xyxy);
    _87 = abs(_87) + abs(_367);
    _376 = _19_m12 * 0.64999997615814208984375f;
    _382 = vs_TEXCOORD0 + (-_19_m15.xyz);
    _28 = dot(_382, _382);
    _28 = sqrt(_28);
    _28 = ((-_19_m12) * 0.3499999940395355224609375f) + _28;
    _376 = 1.0f / _376;
    _28 = _376 * _28;
    _28 = clamp(_28, 0.0f, 1.0f);
    _382.x = (_28 * (-2.0f)) + 3.0f;
    _28 *= _28;
    _28 = ((-_382.x) * _28) + 1.0f;
    _28 *= _19_m15.w;
    _382 = vs_TEXCOORD0 + (-_19_m16.xyz);
    _382.x = dot(_382, _382);
    _382.x = sqrt(_382.x);
    _382.x = ((-_19_m12) * 0.3499999940395355224609375f) + _382.x;
    _382.x = _376 * _382.x;
    _382.x = clamp(_382.x, 0.0f, 1.0f);
    _458.x = (_382.x * (-2.0f)) + 3.0f;
    _382.x *= _382.x;
    _382.x = ((-_458.x) * _382.x) + 1.0f;
    _382.x *= _19_m16.w;
    _458 = vs_TEXCOORD0 + (-_19_m17.xyz);
    _458.x = dot(_458, _458);
    _458.x = sqrt(_458.x);
    _458.x = ((-_19_m12) * 0.3499999940395355224609375f) + _458.x;
    _376 *= _458.x;
    _376 = clamp(_376, 0.0f, 1.0f);
    _458.x = (_376 * (-2.0f)) + 3.0f;
    _376 *= _376;
    _376 = ((-_458.x) * _376) + 1.0f;
    _376 *= _19_m17.w;
    _376 = max(_376, _382.x);
    _376 = max(_376, _28);
    _40 = 0.001000000047497451305389404296875f < _376;
    float2 _542 = frac(_9.xy);
    _9 = float3(_542.x, _542.y, _9.z);
    float2 _549 = _9.xy + (-0.5f).xx;
    _9 = float3(_549.x, _549.y, _9.z);
    _87 = ((-_87) * float4(1.80000007152557373046875f, 1.80000007152557373046875f, 0.60000002384185791015625f, 0.60000002384185791015625f)) + 0.5f.xxxx;
    float2 _566 = (-_87.xy) + _87.zw;
    _382 = float3(_566.x, _566.y, _382.z);
    float2 _575 = abs(_9.xy) + (-_87.xy);
    _9 = float3(_575.x, _575.y, _9.z);
    float2 _581 = 1.0f.xx / _382.xy;
    _382 = float3(_581.x, _581.y, _382.z);
    float2 _588 = _9.xy * _382.xy;
    _9 = float3(_588.x, _588.y, _9.z);
    float2 _595 = clamp(_9.xy, 0.0f.xx, 1.0f.xx);
    _9 = float3(_595.x, _595.y, _9.z);
    float2 _603 = (_9.xy * (-2.0f).xx) + 3.0f.xx;
    _382 = float3(_603.x, _603.y, _382.z);
    float2 _610 = _9.xy * _9.xy;
    _9 = float3(_610.x, _610.y, _9.z);
    float2 _617 = _9.xy * _382.xy;
    _9 = float3(_617.x, _617.y, _9.z);
    _9.x = max(_9.y, _9.x);
    _9.x = (_9.x * 0.550000011920928955078125f) + 0.039999999105930328369140625f;
    _382 = _9.xxx * _19_m7.xyz;
    _9 = (_382 * _376.xxx) + _181;
    float3 _650;
    if (_40)
    {
        _650 = _9;
    }
    else
    {
        _650 = _181;
    }
    _647 = float4(_650.x, _650.y, _650.z, _647.w);
    _647.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._647 = _647;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}