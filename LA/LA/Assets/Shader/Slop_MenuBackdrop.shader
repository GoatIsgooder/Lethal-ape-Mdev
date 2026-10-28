// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/MenuBackdrop" {
Properties {

_BaseColor ("Base", Color) = (0.012,0.012,0.012,1)

_DotColor ("Dot", Color) = (0.12,0.12,0.12,1)

_Cell ("Cell Size (m)", Float) = 0.3400000035762787

_Dot ("Dot Radius (m)", Float) = 0.029999999329447746

_RingColor ("Floor Ring", Color) = (0.2,0.2,0.2,1)

_RingRadius ("Ring Radius (m)", Float) = 1.0499999523162842

_RingWidth ("Ring Width (m)", Float) = 0.009999999776482582

_WallFade ("Wall Fade (lo start, lo end, hi start, hi end)", Vector) = (-0.2,0.6,2.6,5.5)

_FloorFade ("Floor Fade (start, end)", Vector) = (2.5,8,0,0)

_Fade ("Fade", Range(0, 1)) = 1.0

}
SubShader {
 Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "QUEUE" = "Geometry" "RenderType" = "Opaque" }
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
static float vs_TEXCOORD1;
static float2 _90;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float2 _86 : TEXCOORD0;
    float2 _90 : TEXCOORD1;
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
    _9 = _11.yyyy * _20_m0[1];
    _9 = (_20_m0[0] * _11.xxxx) + _9;
    _9 = (_20_m0[2] * _11.zzzz) + _9;
    _9 += _20_m0[3];
    _48 = _9.yyyy * _20_m1[1];
    _48 = (_20_m1[0] * _9.xxxx) + _48;
    _48 = (_20_m1[2] * _9.zzzz) + _48;
    gl_Position = (_20_m1[3] * _9.wwww) + _48;
    vs_TEXCOORD0 = _86;
    vs_TEXCOORD1 = _90.x;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _86 = stage_input._86;
    _90 = stage_input._90;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _BaseColor;
float4 _DotColor;
float4 _RingColor;
float _Cell;
float _Dot;
float _RingRadius;
float _RingWidth;
float _Fade;
float4 _WallFade;
float4 _FloorFade;
#define _16_m0 _BaseColor
#define _16_m1 _DotColor
#define _16_m2 _RingColor
#define _16_m3 _Cell
#define _16_m4 _Dot
#define _16_m5 _RingRadius
#define _16_m6 _RingWidth
#define _16_m7 _Fade
#define _16_m8 _WallFade
#define _16_m9 _FloorFade



static float2 vs_TEXCOORD0;
static float vs_TEXCOORD1;
static float4 _393;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _393 : SV_Target0;
};

static float4 _9;
static float _27;
static float _47;
static float3 _53;
static float _78;
static float2 _252;
static float _355;
static float _358;

void frag_inner()
{
    float2 _23 = vs_TEXCOORD0 / _16_m3.xx;
    _9 = float4(_23.x, _23.y, _9.z, _9.w);
    _27 = floor(_9.y);
    _27 *= 0.5f;
    _27 = frac(_27);
    _9.x = _27 + _9.x;
    _27 = ddx_coarse(_9.x);
    _47 = ddy_coarse(_9.x);
    float2 _56 = frac(_9.xy);
    _53 = float3(_56.x, _56.y, _53.z);
    _9.x = abs(_47) + abs(_27);
    _27 = ddx_coarse(_9.y);
    _47 = ddy_coarse(_9.y);
    float2 _75 = _53.xy + (-0.5f).xx;
    _53 = float3(_75.x, _75.y, _53.z);
    _78 = abs(_53.y) + abs(_53.x);
    _78 *= _16_m3;
    _27 = abs(_47) + abs(_27);
    _9.x = max(_27, _9.x);
    _9.x += (-0.07999999821186065673828125f);
    _9.x *= 8.3333339691162109375f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _27 = _16_m4 * 0.707106769084930419921875f;
    _78 = (_78 * 0.707106769084930419921875f) + (-_27);
    _27 = ddx_coarse(_78);
    _47 = ddy_coarse(_78);
    _27 = abs(_47) + abs(_27);
    _27 = max(_27, 9.9999997473787516355514526367188e-06f);
    _78 /= _27;
    _78 = (-_78) + 0.5f;
    _78 = clamp(_78, 0.0f, 1.0f);
    _27 = dot(float2(float2(_16_m4, _16_m4)), float2(float2(_16_m4, _16_m4)));
    _47 = _16_m3 * _16_m3;
    _27 /= _47;
    _27 = (-_78) + _27;
    _9.x = (_9.x * _27) + _78;
    _78 = (-_16_m9.x) + _16_m9.y;
    _78 = 1.0f / _78;
    _27 = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _27 = sqrt(_27);
    _47 = _27 + (-_16_m9.x);
    _27 += (-_16_m5);
    _27 = ((-_16_m6) * 0.5f) + abs(_27);
    _78 *= _47;
    _78 = clamp(_78, 0.0f, 1.0f);
    _47 = (_78 * (-2.0f)) + 3.0f;
    _78 *= _78;
    _78 = ((-_47) * _78) + 1.0f;
    float2 _242 = (-_16_m8.xz) + _16_m8.yw;
    _53 = float3(_242.x, _242.y, _53.z);
    float2 _248 = 1.0f.xx / _53.xy;
    _53 = float3(_248.x, _248.y, _53.z);
    _252 = vs_TEXCOORD0.yy + (-_16_m8.xz);
    float2 _263 = _53.xy * _252;
    _53 = float3(_263.x, _263.y, _53.z);
    float2 _270 = clamp(_53.xy, 0.0f.xx, 1.0f.xx);
    _53 = float3(_270.x, _270.y, _53.z);
    _252 = (_53.xy * (-2.0f).xx) + 3.0f.xx;
    float2 _283 = _53.xy * _53.xy;
    _53 = float3(_283.x, _283.y, _53.z);
    _47 = _53.x * _252.x;
    _53.x = ((-_252.y) * _53.y) + 1.0f;
    _78 = ((-_47) * _53.x) + _78;
    _47 *= _53.x;
    _78 = (vs_TEXCOORD1 * _78) + _47;
    _78 *= _16_m7;
    _9.x = _78 * _9.x;
    _53 = (-_16_m0.xyz) + _16_m1.xyz;
    float3 _344 = (_9.xxx * _53) + _16_m0.xyz;
    _9 = float4(_344.x, _344.y, _9.z, _344.z);
    _53 = (-_9.xyw) + _16_m2.xyz;
    _355 = ddx_coarse(_27);
    _358 = ddy_coarse(_27);
    _355 = abs(_355) + abs(_358);
    _355 = max(_355, 9.9999997473787516355514526367188e-06f);
    _27 /= _355;
    _27 = (-_27) + 0.5f;
    _27 = clamp(_27, 0.0f, 1.0f);
    _27 *= vs_TEXCOORD1;
    _27 *= _16_m7;
    float3 _389 = (_27.xxx * _53) + _9.xyw;
    _9 = float4(_389.x, _389.y, _389.z, _9.w);
    _393 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _393.w);
    _393.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._393 = _393;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}