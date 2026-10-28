// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Fnaf/Static" {
Properties {

[Header(Feed)] _MainTex ("Feed", 2D) = "black" { }

_Gain ("Gain", Range(0, 4)) = 1.25

_Saturation ("Saturation", Range(0, 1)) = 0.3499999940395355

_Tint ("Tint", Color) = (0.86,1,0.9,1)

_PictureRect ("Picture Rect (x, y, w, h)", Vector) = (0,0,1,1)

[Header(Static)] _Static ("Static", Range(0, 1)) = 0.0

_NoiseLevel ("Static Brightness", Range(0, 1)) = 0.6000000238418579

_NoiseCells ("Noise Cells", Vector) = (240,150,0,0)

_NoiseRate ("Noise Rate", Range(1, 60)) = 30.0

[Header(Scramble)] _Scramble ("Scramble", Range(0, 1)) = 0.0

_ScrambleNoise ("Scramble Noise", Range(0, 1)) = 0.800000011920929

_Tear ("Tear", Range(0, 0.2)) = 0.05999999865889549

_RollSpeed ("Roll Speed", Range(0, 4)) = 0.8999999761581421

[Header(On Screen Display)] _OsdTex ("OSD (premultiplied)", 2D) = "black" { }

_Osd ("OSD Strength", Range(0, 1)) = 0.0

[Header(Glass)] _Scanlines ("Scanlines", Range(0, 1)) = 0.11999999731779099

_ScanlineCount ("Scanline Count", Float) = 150.0

_Vignette ("Vignette", Range(0, 2)) = 0.6000000238418579

_Aspect ("Glass Aspect (w / h)", Float) = 1.600000023841858

_CornerRadius ("Corner Radius (of the height)", Range(0, 0.5)) = 0.0

_CornerSoftness ("Corner Softness", Range(0.001, 0.05)) = 0.009999999776482582

_Sheen ("Glass Sheen", Range(0, 0.2)) = 0.0

}
SubShader {
 LOD 100
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  LOD 100
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
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
float4 _MainTex_ST;
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
#define _20_m2 _MainTex_ST



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
    vs_TEXCOORD0 = (_86 * _20_m2.xy) + _20_m2.zw;
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
float _Gain;
float _Saturation;
float4 _Tint;
float4 _PictureRect;
float _Static;
float _NoiseLevel;
float4 _NoiseCells;
float _NoiseRate;
float _Scramble;
float _ScrambleNoise;
float _Tear;
float _RollSpeed;
float _Osd;
float _Scanlines;
float _ScanlineCount;
float _Vignette;
float _Aspect;
float _CornerRadius;
float _CornerSoftness;
float _Sheen;
#define _12_m0 _Time
#define _12_m1 _Gain
#define _12_m2 _Saturation
#define _12_m3 _Tint
#define _12_m4 _PictureRect
#define _12_m5 _Static
#define _12_m6 _NoiseLevel
#define _12_m7 _NoiseCells
#define _12_m8 _NoiseRate
#define _12_m9 _Scramble
#define _12_m10 _ScrambleNoise
#define _12_m11 _Tear
#define _12_m12 _RollSpeed
#define _12_m13 _Osd
#define _12_m14 _Scanlines
#define _12_m15 _ScanlineCount
#define _12_m16 _Vignette
#define _12_m17 _Aspect
#define _12_m18 _CornerRadius
#define _12_m19 _CornerSoftness
#define _12_m20 _Sheen


Texture2D<float4> _MainTex;
SamplerState sampler_MainTex;
Texture2D<float4> _OsdTex;
SamplerState sampler_OsdTex;

static float2 vs_TEXCOORD0;
static float4 _806;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _806 : SV_Target0;
};

static float4 _9;
static bool _38;
static float4 _64;
static float3 _110;
static float2 _117;
static float _130;
static float3 _145;
static float2 _179;
static float _185;
static bool4 _351;
static float4 _367;
static float3 _414;
static float _429;
static float3 _437;
static float _503;
static float _735;

void frag_inner()
{
    _9.x = _12_m0.y * _12_m8;
    _9.x = floor(_9.x);
    _9.x *= 0.000244140625f;
    _38 = _9.x >= (-_9.x);
    _9.x = frac(abs(_9.x));
    float _52;
    if (_38)
    {
        _52 = _9.x;
    }
    else
    {
        _52 = -_9.x;
    }
    _9.w = _52;
    float3 _76 = vs_TEXCOORD0.yxy * _12_m7.yxy;
    _64 = float4(_76.x, _76.y, _76.z, _64.w);
    float3 _81 = floor(_64.xyz);
    _9 = float4(_81.x, _81.y, _81.z, _9.w);
    float2 _93 = (_9.xw * float2(1.0f, 4096.0f)) + float2(0.0f, 17.0f);
    _64 = float4(_93.x, _93.y, _64.z, _64.w);
    float2 _101 = _64.xy * float2(0.1412470042705535888671875f, 0.103100001811981201171875f);
    _64 = float4(_101.x, _101.y, _64.z, _64.w);
    float2 _106 = frac(_64.xy);
    _64 = float4(_106.x, _106.y, _64.z, _64.w);
    _110 = _64.yxx + 33.3300018310546875f.xxx;
    _117.x = dot(_64.xyx, _110);
    float2 _127 = _117.xx + _64.xy;
    _64 = float4(_127.x, _127.y, _64.z, _64.w);
    _130 = _64.y + _64.x;
    _64.x *= _130;
    _64.x = frac(_64.x);
    _145.x = _64.x * 0.300000011920928955078125f;
    float2 _159 = (_9.ww * float2(29204.48046875f, 15196.16015625f)) + _9.yz;
    _9 = float4(_9.x, _159.x, _159.y, _9.w);
    _9 *= float4(0.103100001811981201171875f, 0.103100001811981201171875f, 0.103100001811981201171875f, 422.297607421875f);
    _9 = frac(_9);
    float3 _170 = _9.zyy + 33.3300018310546875f.xxx;
    _64 = float4(_170.x, _170.y, _170.z, _64.w);
    _64.x = dot(_9.yzy, _64.xyz);
    _179 = _9.yz + _64.xx;
    _185 = _179.y + _179.x;
    _179.x *= _185;
    _179.x = frac(_179.x);
    _145.x = (_179.x * 0.699999988079071044921875f) + _145.x;
    float3 _210 = _9.wxx + 33.3300018310546875f.xxx;
    _64 = float4(_210.x, _210.y, _210.z, _64.w);
    _179.x = dot(_9.xwx, _64.xyz);
    float2 _223 = _179.xx + _9.xw;
    _9 = float4(_223.x, _223.y, _9.z, _9.w);
    _179.x = _9.y + _9.x;
    _9.x *= _179.x;
    _9.x = frac(_9.x);
    _9.x += (-0.5f);
    _179.x = _12_m0.y * _12_m12;
    _179.y = _179.x * 0.25f;
    _179.x = (vs_TEXCOORD0.y * 1.5f) + _179.x;
    _179 = frac(_179);
    _179.x *= 6.283185482025146484375f;
    _179.x = sin(_179.x);
    _179.x = (_179.x * 0.5f) + 0.5f;
    _185 = (-_179.y) + 1.0f;
    _185 = (-_185) + vs_TEXCOORD0.y;
    _185 = ((-abs(_185)) * 14.0f) + 1.0f;
    _185 = max(_185, 0.0f);
    _185 *= _185;
    _9.x = (_9.x * 0.25f) + _185;
    _9.x *= _12_m11;
    _64.x = (_9.x * _12_m9) + vs_TEXCOORD0.x;
    _64.y = vs_TEXCOORD0.y;
    float2 _338 = _64.xy + (-_12_m4.xy);
    _9 = float4(_338.x, _9.y, _338.y, _9.w);
    float2 _346 = _9.xz / _12_m4.zw;
    _9 = float4(_346.x, _9.y, _346.y, _9.w);
    bool2 _357 = bool4(_9.xzxx.x >= 0.0f.xxxx.x, _9.xzxx.y >= 0.0f.xxxx.y, _9.xzxx.z >= 0.0f.xxxx.z, _9.xzxx.w >= 0.0f.xxxx.w).xy;
    _351 = bool4(_357.x, _357.y, _351.z, _351.w);
    bool2 _364 = bool4(float4(0.0f, 0.0f, 1.0f, 1.0f).x >= _9.xxxz.x, float4(0.0f, 0.0f, 1.0f, 1.0f).y >= _9.xxxz.y, float4(0.0f, 0.0f, 1.0f, 1.0f).z >= _9.xxxz.z, float4(0.0f, 0.0f, 1.0f, 1.0f).w >= _9.xxxz.w).zw;
    _351 = bool4(_351.x, _351.y, _364.x, _364.y);
    float3 _376 = _MainTex.Sample(sampler_MainTex, _9.xz).xyz;
    _367 = float4(_376.x, _367.y, _376.y, _376.z);
    _64.x = float(_351.x);
    _64.y = float(_351.y);
    _64.z = float(_351.z);
    _64.w = float(_351.w);
    _64.x = _64.z * _64.x;
    _64.x = _64.y * _64.x;
    _64.x = _64.w * _64.x;
    _414.x = _64.x * _12_m1;
    float3 _426 = _367.xzw * _414.xxx;
    _64 = float4(_426.x, _426.y, _426.z, _64.w);
    _429 = dot(_64.xyz, float3(0.2989999949932098388671875f, 0.58700001239776611328125f, 0.114000000059604644775390625f));
    _437 = (_367.xzw * _414.xxx) + (-_429.xxx);
    _414 = (float3(float3(_12_m2, _12_m2, _12_m2)) * _437) + _429.xxx;
    _437 = (_145.xxx * float3(float3(_12_m6, _12_m6, _12_m6))) + (-_414);
    _145.x = (_12_m9 * _12_m10) + _12_m5;
    _145.x = clamp(_145.x, 0.0f, 1.0f);
    _145 = (_145.xxx * _437) + _414;
    _503 = _12_m9 * 0.3499999940395355224609375f;
    _503 = ((-_503) * _179.x) + 1.0f;
    _145 = _503.xxx * _145;
    _9.x = vs_TEXCOORD0.y * _12_m15;
    _179.x = ddx_coarse(_9.x);
    _185 = ddy_coarse(_9.x);
    _9.x *= 6.283185482025146484375f;
    _9.x = cos(_9.x);
    _9.x = (_9.x * 0.5f) + 0.5f;
    _179.x = abs(_185) + abs(_179.x);
    _179.x = (-_179.x) + 0.5f;
    _179.x *= 4.0f;
    _179.x = clamp(_179.x, 0.0f, 1.0f);
    _503 = (_12_m9 * 0.20000000298023223876953125f) + _12_m14;
    _503 = clamp(_503, 0.0f, 1.0f);
    _503 = _179.x * _503;
    _503 = ((-_503) * _9.x) + 1.0f;
    _145 = _503.xxx * _145;
    _145 *= _12_m3.xyz;
    _367 = _OsdTex.Sample(sampler_OsdTex, vs_TEXCOORD0);
    float3 _606 = _367.xyz * _12_m13.xxx;
    _9 = float4(_606.x, _606.y, _606.z, _9.w);
    _503 = ((-_367.w) * _12_m13) + 1.0f;
    _145 = (_145 * _503.xxx) + _9.xyz;
    float2 _629 = (vs_TEXCOORD0 * 2.0f.xx) + (-1.0f).xx;
    _9 = float4(_629.x, _629.y, _9.z, _9.w);
    _9.x = dot(_9.xy, _9.xy);
    _9.x *= _12_m16;
    _9.x = ((-_9.x) * 0.5f) + 1.0f;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _64 = vs_TEXCOORD0.xyxy + float4(-0.300000011920928955078125f, -0.819999992847442626953125f, -0.5f, -0.5f);
    _179 = _64.xy * float2(1.39999997615814208984375f, 2.599999904632568359375f);
    _179.x = dot(_179, _179);
    _179.x = (-_179.x) + 1.0f;
    _179.x = max(_179.x, 0.0f);
    _179.x *= _12_m20;
    float3 _693 = (_145 * _9.xxx) + _179.xxx;
    _9 = float4(_693.x, _693.y, _693.z, _9.w);
    _64.x = _12_m17;
    _64.y = 1.0f;
    _117 = _64.xy * _64.zw;
    float2 _720 = (_64.xy * 0.5f.xx) + (-float2(float2(_12_m18, _12_m18)));
    _64 = float4(_720.x, _720.y, _64.z, _64.w);
    float2 _728 = (-_64.xy) + abs(_117);
    _64 = float4(_728.x, _728.y, _64.z, _64.w);
    _117 = max(_64.xy, 0.0f.xx);
    _735 = max(_64.y, _64.x);
    _735 = min(_735, 0.0f);
    _64.x = dot(_117, _117);
    _64.x = sqrt(_64.x);
    _735 += _64.x;
    _735 += (-_12_m18);
    _735 += _12_m19;
    _64.x = 1.0f / _12_m19;
    _735 *= _64.x;
    _735 = clamp(_735, 0.0f, 1.0f);
    _64.x = (_735 * (-2.0f)) + 3.0f;
    _735 *= _735;
    _735 = ((-_64.x) * _735) + 1.0f;
    _351.x = 0.0f < _12_m18;
    _735 = _351.x ? _735 : 1.0f;
    float3 _802 = _735.xxx * _9.xyz;
    _9 = float4(_802.x, _802.y, _802.z, _9.w);
    _806 = float4(_9.xyz.x, _9.xyz.y, _9.xyz.z, _806.w);
    _806.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._806 = _806;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}