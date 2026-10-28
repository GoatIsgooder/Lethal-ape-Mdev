// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/Rivals/BarFill" {
Properties {

_FillAmount ("Fill Amount", Range(0, 1)) = 0.0

_FillColor ("Fill Color", Color) = (0.3,0.78,1,1)

_BackColor ("Background Color", Color) = (0.05,0.07,0.12,0.9)

_Flash ("White Flash", Range(0, 2)) = 0.0

_Alpha ("Master Alpha", Range(0, 1)) = 1.0

_Aspect ("Quad Width / Height", Float) = 7.5

_Corner ("Corner Radius (half-heights)", Range(0, 1)) = 0.8500000238418579

_GlowWidth ("Edge Glow Falloff", Float) = 14.0

_GlowStrength ("Edge Glow Strength", Range(0, 3)) = 0.800000011920929

_ShimmerSpeed ("Shimmer Speed", Float) = 0.3499999940395355

_ShimmerStrength ("Shimmer Strength", Range(0, 1)) = 0.18000000715255737

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay-3" "RenderType" = "Transparent" }
 Pass {
  Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay-3" "RenderType" = "Transparent" }
 ZTest Always
 ZWrite Off
 Cull Off
   Blend SrcAlpha OneMinusSrcAlpha
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
float4 _Time;
float _FillAmount;
float4 _FillColor;
float4 _BackColor;
float _Flash;
float _Alpha;
float _Aspect;
float _Corner;
float _GlowWidth;
float _GlowStrength;
float _ShimmerSpeed;
float _ShimmerStrength;
#define _34_m0 _Time
#define _34_m1 _FillAmount
#define _34_m2 _FillColor
#define _34_m3 _BackColor
#define _34_m4 _Flash
#define _34_m5 _Alpha
#define _34_m6 _Aspect
#define _34_m7 _Corner
#define _34_m8 _GlowWidth
#define _34_m9 _GlowStrength
#define _34_m10 _ShimmerSpeed
#define _34_m11 _ShimmerStrength



static float2 vs_TEXCOORD0;
static float4 _271;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _271 : SV_Target0;
};

static float4 _9;
static float2 _79;
static float2 _101;
static float3 _223;
static float _230;
static float3 _250;
static float _371;

void frag_inner()
{
    _9.x = vs_TEXCOORD0.y * 0.180000007152557373046875f;
    _9.x = (vs_TEXCOORD0.x * 0.800000011920928955078125f) + (-_9.x);
    _9.x = ((-_34_m0.y) * _34_m10) + _9.x;
    _9.x = frac(_9.x);
    float2 _58 = _9.xx + float2(-0.4000000059604644775390625f, -0.5f);
    _9 = float4(_58.x, _58.y, _9.z, _9.w);
    float2 _66 = _9.xy * float2(10.00000095367431640625f, 9.9999980926513671875f);
    _9 = float4(_66.x, _66.y, _9.z, _9.w);
    float2 _75 = clamp(_9.xy, 0.0f.xx, 1.0f.xx);
    _9 = float4(_75.x, _75.y, _9.z, _9.w);
    _79 = (_9.xy * (-2.0f).xx) + 3.0f.xx;
    float2 _92 = _9.xy * _9.xy;
    _9 = float4(_92.x, _92.y, _9.z, _9.w);
    _9.x *= _79.x;
    _101.x = ((-_79.y) * _9.y) + 1.0f;
    _9.x = _101.x * _9.x;
    _9.x *= _34_m11;
    _101.x = ddx_coarse(vs_TEXCOORD0.x);
    _79.x = ddy_coarse(vs_TEXCOORD0.x);
    _101.x = abs(_79.x) + abs(_101.x);
    _101.x = max(_101.x, 9.9999997473787516355514526367188e-05f);
    _79.x = (-vs_TEXCOORD0.x) + _34_m1;
    _101.x = _79.x / _101.x;
    _79.x = max(_79.x, 0.0f);
    _79.x = (-_79.x) * _34_m8;
    _79.x *= 1.44269502162933349609375f;
    _79.x = exp2(_79.x);
    _79.x *= _34_m9;
    _101.x += 0.5f;
    _101.x = clamp(_101.x, 0.0f, 1.0f);
    _9.x = _101.x * _9.x;
    _79.x = (_79.x * _101.x) + 1.0f;
    float3 _219 = (_34_m2.xyz * _79.xxx) + _9.xxx;
    _9 = float4(_219.x, _9.y, _219.y, _219.z);
    _223 = (-_9.xzw) + 1.60000002384185791015625f.xxx;
    _230 = _34_m4;
    _230 = clamp(_230, 0.0f, 1.0f);
    _223 = (_230.xxx * _223) + _9.xzw;
    float2 _247 = _230.xx * float2(0.85000002384185791015625f, 0.5f);
    _9 = float4(_247.x, _9.y, _247.y, _9.w);
    _250 = (-_34_m3.xyz) + 1.0f.xxx;
    _250 = (_9.xxx * _250) + _34_m3.xyz;
    _223 += (-_250);
    float3 _277 = (_101.xxx * _223) + _250;
    _271 = float4(_277.x, _277.y, _277.z, _271.w);
    _223.x = _34_m2.w + (-_34_m3.w);
    _223.x = (_101.x * _223.x) + _34_m3.w;
    _9.x = (-_223.x) + 1.0f;
    _9.x = (_9.z * _9.x) + _223.x;
    float2 _314 = vs_TEXCOORD0 + (-0.5f).xx;
    _250 = float3(_314.x, _250.y, _314.y);
    _250.y = _250.x * _34_m6;
    _101 = _250.yz + _250.yz;
    _250.x = _34_m6;
    _250.y = 1.0f;
    float2 _340 = _250.xy + (-_34_m7.xx);
    _250 = float3(_340.x, _340.y, _250.z);
    _101 = abs(_101) + (-_250.xy);
    _101 = max(_101, 0.0f.xx);
    _101.x = dot(_101, _101);
    _101.x = sqrt(_101.x);
    _101.x += (-_34_m7);
    _79.x = ddx_coarse(_101.x);
    _371 = ddy_coarse(_101.x);
    _79.x = abs(_371) + abs(_79.x);
    _79.x = max(_79.x, 9.9999997473787516355514526367188e-05f);
    _101.x /= _79.x;
    _101.x = (-_101.x) + 0.5f;
    _101.x = clamp(_101.x, 0.0f, 1.0f);
    _9.x = _101.x * _9.x;
    _9.x *= _34_m5;
    _271.w = _9.x;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._271 = _271;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}