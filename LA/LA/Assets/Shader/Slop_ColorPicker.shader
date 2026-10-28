// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/ColorPicker" {
Properties {

[KeywordEnum(Wheel, Slider)] _Mode ("Mode", Float) = 0.0

[Header(Wheel)] _FaceRadius ("Face Radius (m)", Float) = 0.10499999672174454

_HubRadius ("White Hub Radius (m)", Float) = 0.02800000086426735

_SatRadius ("Full Saturation Radius (m)", Float) = 0.09799999743700027

[Header(Slider)] _TrackSize ("Track Half Width, Half Length (m)", Vector) = (0.011,0.099,0,0)

_HandleSize ("Handle Half Width, Half Length, Corner (m)", Vector) = (0.0155,0.0075,0.005,0)

_Travel ("Handle Travel Half Length (m)", Float) = 0.08799999952316284

_ValueRange ("Value Range (min, max)", Vector) = (0.5,1,0,0)

[Header(Bezel)] _BezelColor ("Bezel Color", Color) = (0.11,0.12,0.14,1)

[Header(Driven at runtime)] _HSV ("Hue, Saturation, Value, Pressed", Vector) = (0,0,1,0)

_Pick ("Wheel Pick XZ (m)", Vector) = (0,0,0,0)

_PickColor ("Picked Color", Color) = (1,1,1,1)

}
SubShader {
 Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Geometry" "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile_local __ _MODE_SLIDER
#pragma multi_compile_local __ _MODE_WHEEL
#if defined(FOG_EXP) && defined(_MODE_SLIDER)
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
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _128;
static float3 _132;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _132 : NORMAL;
    float2 _128 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _151;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    vs_TEXCOORD0 = _128;
    _9.x = dot(_132, _21_m2[0].xyz);
    _9.y = dot(_132, _21_m2[1].xyz);
    _9.z = dot(_132, _21_m2[2].xyz);
    _151 = dot(_9.xyz, _9.xyz);
    _151 = rsqrt(_151);
    float3 _163 = _151.xxx * _9.xyz;
    _9 = float4(_163.x, _163.y, _163.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _128 = stage_input._128;
    _132 = stage_input._132;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _TrackSize;
float4 _HandleSize;
float _Travel;
float4 _ValueRange;
float4 _BezelColor;
float4 _HSV;
float4 _PickColor;
#define _13_m0 unity_FogColor
#define _13_m1 _TrackSize
#define _13_m2 _HandleSize
#define _13_m3 _Travel
#define _13_m4 _ValueRange
#define _13_m5 _BezelColor
#define _13_m6 _HSV
#define _13_m7 _PickColor



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _595;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _595 : SV_Target0;
};

static float3 _9;
static float _65;
static float _69;
static float4 _108;
static float _119;
static float4 _176;
static float _238;
static float _249;
static float3 _280;
static float3 _296;
static float2 _384;
static float _399;
static float _527;

void frag_inner()
{
    _9.x = (-_13_m1.x) + _13_m1.y;
    _9.x = (-_9.x) + abs(vs_TEXCOORD0.y);
    _9.y = max(_9.x, 0.0f);
    _9.x = vs_TEXCOORD0.x;
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x += (-_13_m1.x);
    _65 = ddx_coarse(_9.x);
    _69 = ddy_coarse(_9.x);
    _65 = abs(_69) + abs(_65);
    _65 = max(_65, 9.9999999747524270787835121154785e-07f);
    _65 = _9.x / _65;
    _9.x *= (-400.0f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * 0.180000007152557373046875f) + 0.819999992847442626953125f;
    _65 += 0.5f;
    _65 = clamp(_65, 0.0f, 1.0f);
    _108.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _108.x = rsqrt(_108.x);
    _119 = (vs_TEXCOORD1.y * _108.x) + (-0.699999988079071044921875f);
    float3 _130 = _108.xxx * vs_TEXCOORD1;
    _108 = float4(_130.x, _108.y, _130.y, _130.z);
    _108.x = dot(_108.xzw, float3(0.279447853565216064453125f, 0.931492865085601806640625f, 0.23287321627140045166015625f));
    _108.x = clamp(_108.x, 0.0f, 1.0f);
    _108.x = (_108.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _119 = ((-abs(_119)) * 4.0f) + 1.0f;
    _119 = max(_119, 0.0f);
    _119 *= 0.0350000001490116119384765625f;
    float3 _173 = (_13_m5.xyz * _108.xxx) + _119.xxx;
    _108 = float4(_173.x, _173.y, _173.z, _108.w);
    float3 _184 = _13_m6.xxx + float3(0.0f, 0.666666686534881591796875f, 0.3333333432674407958984375f);
    _176 = float4(_184.x, _184.y, _184.z, _176.w);
    float3 _189 = frac(_176.xyz);
    _176 = float4(_189.x, _189.y, _189.z, _176.w);
    float3 _199 = (_176.xyz * 6.0f.xxx) + (-3.0f).xxx;
    _176 = float4(_199.x, _199.y, _199.z, _176.w);
    float3 _207 = abs(_176.xyz) + (-1.0f).xxx;
    _176 = float4(_207.x, _207.y, _207.z, _176.w);
    float3 _214 = clamp(_176.xyz, 0.0f.xxx, 1.0f.xxx);
    _176 = float4(_214.x, _214.y, _214.z, _176.w);
    float3 _219 = _176.xyz + (-1.0f).xxx;
    _176 = float4(_219.x, _219.y, _219.z, _176.w);
    float3 _229 = (_13_m6.yyy * _176.xyz) + 1.0f.xxx;
    _176 = float4(_229.x, _229.y, _229.z, _176.w);
    _69 = vs_TEXCOORD0.y + _13_m3;
    _238 = _13_m3 + _13_m3;
    _69 /= _238;
    _69 = clamp(_69, 0.0f, 1.0f);
    _249 = (-_13_m4.x) + _13_m4.y;
    _69 = (_69 * _249) + _13_m4.x;
    _249 = max(_249, 9.9999997473787516355514526367188e-05f);
    float3 _270 = _176.xyz * _69.xxx;
    _176 = float4(_270.x, _270.y, _270.z, _176.w);
    float3 _277 = _9.xxx * _176.xyz;
    _176 = float4(_277.x, _277.y, _277.z, _176.w);
    _280 = (_176.xyz * 0.305306017398834228515625f.xxx) + 0.6821711063385009765625f.xxx;
    _280 = (_176.xyz * _280) + 0.01252287812530994415283203125f.xxx;
    _296 = ((-_176.xyz) * _280) + _108.xyz;
    float3 _308 = _176.xyz * _280;
    _176 = float4(_308.x, _308.y, _308.z, _176.w);
    _9 = (_65.xxx * _296) + _176.xyz;
    _176.x = (-_13_m4.x) + _13_m6.z;
    _176.x /= _249;
    _176.x = clamp(_176.x, 0.0f, 1.0f);
    _176.y = (_176.x * _238) + (-_13_m3);
    _176.x = 0.0f;
    float2 _349 = (-_176.xy) + vs_TEXCOORD0;
    _176 = float4(_349.x, _349.y, _176.z, _176.w);
    _238 = (_13_m6.w * 0.12000000476837158203125f) + 1.0f;
    float2 _369 = ((-_13_m2.xy) * _238.xx) + abs(_176.xy);
    _176 = float4(_369.x, _369.y, _176.z, _176.w);
    float2 _380 = (_13_m2.zz * _238.xx) + _176.xy;
    _176 = float4(_380.x, _380.y, _176.z, _176.w);
    _384 = max(_176.xy, 0.0f.xx);
    _176.x = max(_176.y, _176.x);
    _176.x = min(_176.x, 0.0f);
    _399 = dot(_384, _384);
    _399 = sqrt(_399);
    _176.x += _399;
    _238 = ((-_13_m2.z) * _238) + _176.x;
    float3 _424 = _238.xxx + float3(-0.00039999998989515006542205810546875f, -0.0007999999797903001308441162109375f, 0.00150000001303851604461669921875f);
    _176 = float4(_424.x, _424.y, _424.z, _176.w);
    _176.x *= 400.0f;
    _176.x = clamp(_176.x, 0.0f, 1.0f);
    _176.x = (-_176.x) + 1.0f;
    _176.x = ((-_176.x) * 0.3499999940395355224609375f) + 1.0f;
    _280 = _9 * _176.xxx;
    _9 = ((-_9) * _176.xxx) + float3(0.0199999995529651641845703125f, 0.0199999995529651641845703125f, 0.02500000037252902984619140625f);
    float2 _463 = ddx_coarse(_176.yz);
    _176 = float4(_463.x, _176.y, _176.z, _463.y);
    float2 _468 = ddy_coarse(_176.yz);
    _296 = float3(_468.x, _468.y, _296.z);
    float2 _477 = abs(_176.xw) + abs(_296.xy);
    _176 = float4(_477.x, _176.y, _176.z, _477.y);
    float2 _483 = max(_176.xw, 9.9999999747524270787835121154785e-07f.xx);
    _176 = float4(_483.x, _176.y, _176.z, _483.y);
    float2 _490 = _176.yz / _176.xw;
    _176 = float4(_490.x, _490.y, _176.z, _176.w);
    float2 _496 = _176.xy + 0.5f.xx;
    _176 = float4(_496.x, _496.y, _176.z, _176.w);
    float2 _503 = clamp(_176.xy, 0.0f.xx, 1.0f.xx);
    _176 = float4(_503.x, _503.y, _176.z, _176.w);
    float2 _510 = (-_176.xy) + 1.0f.xx;
    _176 = float4(_510.x, _510.y, _176.z, _176.w);
    _9 = (_176.xxx * _9) + _280;
    float3 _521 = (-_9) + 1.0f.xxx;
    _176 = float4(_521.x, _176.y, _521.y, _521.z);
    _280.x = ddx_coarse(_238);
    _527 = ddy_coarse(_238);
    _280.x = abs(_527) + abs(_280.x);
    _280.x = max(_280.x, 9.9999999747524270787835121154785e-07f);
    _238 /= _280.x;
    _238 += 0.5f;
    _238 = clamp(_238, 0.0f, 1.0f);
    _238 = (-_238) + 1.0f;
    _9 = (_238.xxx * _176.xzw) + _9;
    float3 _565 = (-_9) + _13_m7.xyz;
    _176 = float4(_565.x, _176.y, _565.y, _565.z);
    _9 = (_176.yyy * _176.xzw) + _9;
    _9 += (-_13_m0.xyz);
    _238 = vs_TEXCOORD2;
    _238 = clamp(_238, 0.0f, 1.0f);
    _9 = (_238.xxx * _9) + _13_m0.xyz;
    _595 = float4(_9.x, _9.y, _9.z, _595.w);
    _595.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._595 = _595;
    return stage_output;
}

#endif
#elif defined(FOG_EXP) && defined(_MODE_WHEEL)
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
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _128;
static float3 _132;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _132 : NORMAL;
    float2 _128 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _151;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.y;
    vs_TEXCOORD2 = exp2(-_9.x);
    vs_TEXCOORD0 = _128;
    _9.x = dot(_132, _21_m2[0].xyz);
    _9.y = dot(_132, _21_m2[1].xyz);
    _9.z = dot(_132, _21_m2[2].xyz);
    _151 = dot(_9.xyz, _9.xyz);
    _151 = rsqrt(_151);
    float3 _163 = _151.xxx * _9.xyz;
    _9 = float4(_163.x, _163.y, _163.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _128 = stage_input._128;
    _132 = stage_input._132;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float _FaceRadius;
float _HubRadius;
float _SatRadius;
float4 _BezelColor;
float4 _HSV;
float4 _Pick;
#define _235_m0 unity_FogColor
#define _235_m1 _FaceRadius
#define _235_m2 _HubRadius
#define _235_m3 _SatRadius
#define _235_m4 _BezelColor
#define _235_m5 _HSV
#define _235_m6 _Pick



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _637;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _637 : SV_Target0;
};

static float3 _9;
static bool _22;
static float3 _31;
static float _45;
static float4 _58;
static float2 _76;
static bool _120;
static bool _145;
static bool _178;
static float3 _310;
static float4 _427;
static float _438;
static float _537;
static float2 _558;
static float2 _562;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _22 = _9.x < 9.9999999600419720025001879548654e-13f;
    _9.x = sqrt(_9.x);
    float2 _34;
    if (_22)
    {
        _34 = float2(0.0f, 1.0f);
    }
    else
    {
        _34 = vs_TEXCOORD0;
    }
    _31 = float3(_34.x, _34.y, _31.z);
    _45 = max(abs(_31.y), abs(_31.x));
    _45 = 1.0f / _45;
    _58.x = min(abs(_31.y), abs(_31.x));
    _45 *= _58.x;
    _58.x = _45 * _45;
    _76.x = (_58.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _76.x = (_58.x * _76.x) + 0.1801410019397735595703125f;
    _76.x = (_58.x * _76.x) + (-0.33029949665069580078125f);
    _58.x = (_58.x * _76.x) + 0.999866008758544921875f;
    _76.x = _45 * _58.x;
    _76.x = (_76.x * (-2.0f)) + 1.57079637050628662109375f;
    _120 = abs(_31.y) < abs(_31.x);
    float _130;
    if (_120)
    {
        _130 = _76.x;
    }
    else
    {
        _130 = 0.0f;
    }
    _76.x = _130;
    _45 = (_45 * _58.x) + _76.x;
    _145 = _31.y < (-_31.y);
    _58.x = _145 ? (-3.1415927410125732421875f) : 0.0f;
    _45 += _58.x;
    _58.x = min(_31.y, _31.x);
    _31.x = max(_31.y, _31.x);
    _22 = _31.x >= (-_31.x);
    _178 = _58.x < (-_58.x);
    _22 = _22 && _178;
    float _189;
    if (_22)
    {
        _189 = -_45;
    }
    else
    {
        _189 = _45;
    }
    _31.x = _189;
    _31.x *= 0.15915493667125701904296875f;
    _31.x = frac(_31.x);
    _31 = _31.xxx + float3(0.0f, 0.666666686534881591796875f, 0.3333333432674407958984375f);
    _31 = frac(_31);
    _31 = (_31 * 6.0f.xxx) + (-3.0f).xxx;
    _31 = abs(_31) + (-1.0f).xxx;
    _31 = clamp(_31, 0.0f.xxx, 1.0f.xxx);
    _31 += (-1.0f).xxx;
    _58.x = (-_235_m2) + _235_m3;
    _58.x = max(_58.x, 9.9999997473787516355514526367188e-05f);
    _76 = _9.xx + (-float2(_235_m2, _235_m1));
    _9.x /= _235_m2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.x *= 0.070000000298023223876953125f;
    _58.x = _76.x / _58.x;
    _58.x = clamp(_58.x, 0.0f, 1.0f);
    _31 = (_58.xxx * _31) + 1.0f.xxx;
    _31 *= _235_m5.zzz;
    float2 _307 = ddx_coarse(_76);
    _58 = float4(_307.x, _58.y, _58.z, _307.y);
    float2 _312 = ddy_coarse(_76);
    _310 = float3(_312.x, _312.y, _310.z);
    float2 _321 = abs(_58.xw) + abs(_310.xy);
    _58 = float4(_321.x, _58.y, _58.z, _321.y);
    float2 _328 = max(_58.xw, 9.9999999747524270787835121154785e-07f.xx);
    _58 = float4(_328.x, _58.y, _58.z, _328.y);
    float2 _334 = _76 / _58.xw;
    _58 = float4(_334.x, _58.y, _334.y, _58.w);
    _76.x = abs(_76.x) + (-0.000600000028498470783233642578125f);
    float2 _347 = _58.xz + 0.5f.xx;
    _58 = float4(_347.x, _58.y, _347.y, _58.w);
    float2 _354 = clamp(_58.xz, 0.0f.xx, 1.0f.xx);
    _58 = float4(_354.x, _58.y, _354.y, _58.w);
    _58.x = (-_58.x) + 1.0f;
    _9.x = (_58.x * (-_9.x)) + 1.0f;
    _9 = _9.xxx * _31;
    _45 = ddx_coarse(_76.x);
    _58.x = ddy_coarse(_76.x);
    _45 = abs(_45) + abs(_58.x);
    _45 = max(_45, 9.9999999747524270787835121154785e-07f);
    _45 = _76.x / _45;
    _45 += 0.5f;
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 = (-_45) + 1.0f;
    _45 = ((-_45) * 0.20000000298023223876953125f) + 1.0f;
    _9 = _45.xxx * _9;
    float3 _415 = (_9 * 0.305306017398834228515625f.xxx) + 0.6821711063385009765625f.xxx;
    _58 = float4(_415.x, _415.y, _58.z, _415.z);
    float3 _424 = (_9 * _58.xyw) + 0.01252287812530994415283203125f.xxx;
    _58 = float4(_424.x, _424.y, _58.z, _424.z);
    _427.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _427.x = rsqrt(_427.x);
    _438 = (vs_TEXCOORD1.y * _427.x) + (-0.699999988079071044921875f);
    float3 _450 = _427.xxx * vs_TEXCOORD1;
    _427 = float4(_450.x, _427.y, _450.y, _450.z);
    _427.x = dot(_427.xzw, float3(0.279447853565216064453125f, 0.931492865085601806640625f, 0.23287321627140045166015625f));
    _427.x = clamp(_427.x, 0.0f, 1.0f);
    _427.x = (_427.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _438 = ((-abs(_438)) * 4.0f) + 1.0f;
    _438 = max(_438, 0.0f);
    _438 *= 0.0350000001490116119384765625f;
    float3 _492 = (_235_m4.xyz * _427.xxx) + _438.xxx;
    _427 = float4(_492.x, _492.y, _492.z, _427.w);
    _310 = ((-_9) * _58.xyw) + _427.xyz;
    _9 *= _58.xyw;
    _9 = (_58.zzz * _310) + _9;
    float3 _518 = (-_9) + float3(0.0199999995529651641845703125f, 0.0199999995529651641845703125f, 0.02500000037252902984619140625f);
    _58 = float4(_518.x, _518.y, _518.z, _58.w);
    float2 _527 = vs_TEXCOORD0 + (-_235_m6.xy);
    _310 = float3(_527.x, _527.y, _310.z);
    _45 = dot(_310.xy, _310.xy);
    _45 = sqrt(_45);
    _537 = (_235_m5.w * 0.003500000573694705963134765625f) + 0.008200000040233135223388671875f;
    _45 += (-_537);
    float2 _555 = abs(_45.xx) + float2(-0.00150000001303851604461669921875f, -0.0007999999797903001308441162109375f);
    _310 = float3(_555.x, _555.y, _310.z);
    _558 = ddx_coarse(_310.xy);
    _562 = ddy_coarse(_310.xy);
    _558 = abs(_558) + abs(_562);
    _558 = max(_558, 9.9999999747524270787835121154785e-07f.xx);
    float2 _576 = _310.xy / _558;
    _310 = float3(_576.x, _576.y, _310.z);
    float2 _581 = _310.xy + 0.5f.xx;
    _310 = float3(_581.x, _581.y, _310.z);
    float2 _588 = clamp(_310.xy, 0.0f.xx, 1.0f.xx);
    _310 = float3(_588.x, _588.y, _310.z);
    float2 _595 = (-_310.xy) + 1.0f.xx;
    _310 = float3(_595.x, _595.y, _310.z);
    _9 = (_310.xxx * _58.xyz) + _9;
    float3 _607 = (-_9) + 1.0f.xxx;
    _58 = float4(_607.x, _607.y, _607.z, _58.w);
    _9 = (_310.yyy * _58.xyz) + _9;
    _9 += (-_235_m0.xyz);
    _45 = vs_TEXCOORD2;
    _45 = clamp(_45, 0.0f, 1.0f);
    _9 = (_45.xxx * _9) + _235_m0.xyz;
    _637 = float4(_9.x, _9.y, _9.z, _637.w);
    _637.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._637 = _637;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(_MODE_SLIDER)
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
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _134;
static float3 _138;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _138 : NORMAL;
    float2 _134 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _157;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    vs_TEXCOORD0 = _134;
    _9.x = dot(_138, _21_m2[0].xyz);
    _9.y = dot(_138, _21_m2[1].xyz);
    _9.z = dot(_138, _21_m2[2].xyz);
    _157 = dot(_9.xyz, _9.xyz);
    _157 = rsqrt(_157);
    float3 _169 = _157.xxx * _9.xyz;
    _9 = float4(_169.x, _169.y, _169.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _134 = stage_input._134;
    _138 = stage_input._138;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _TrackSize;
float4 _HandleSize;
float _Travel;
float4 _ValueRange;
float4 _BezelColor;
float4 _HSV;
float4 _PickColor;
#define _13_m0 unity_FogColor
#define _13_m1 _TrackSize
#define _13_m2 _HandleSize
#define _13_m3 _Travel
#define _13_m4 _ValueRange
#define _13_m5 _BezelColor
#define _13_m6 _HSV
#define _13_m7 _PickColor



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _595;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _595 : SV_Target0;
};

static float3 _9;
static float _65;
static float _69;
static float4 _108;
static float _119;
static float4 _176;
static float _238;
static float _249;
static float3 _280;
static float3 _296;
static float2 _384;
static float _399;
static float _527;

void frag_inner()
{
    _9.x = (-_13_m1.x) + _13_m1.y;
    _9.x = (-_9.x) + abs(vs_TEXCOORD0.y);
    _9.y = max(_9.x, 0.0f);
    _9.x = vs_TEXCOORD0.x;
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x += (-_13_m1.x);
    _65 = ddx_coarse(_9.x);
    _69 = ddy_coarse(_9.x);
    _65 = abs(_69) + abs(_65);
    _65 = max(_65, 9.9999999747524270787835121154785e-07f);
    _65 = _9.x / _65;
    _9.x *= (-400.0f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * 0.180000007152557373046875f) + 0.819999992847442626953125f;
    _65 += 0.5f;
    _65 = clamp(_65, 0.0f, 1.0f);
    _108.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _108.x = rsqrt(_108.x);
    _119 = (vs_TEXCOORD1.y * _108.x) + (-0.699999988079071044921875f);
    float3 _130 = _108.xxx * vs_TEXCOORD1;
    _108 = float4(_130.x, _108.y, _130.y, _130.z);
    _108.x = dot(_108.xzw, float3(0.279447853565216064453125f, 0.931492865085601806640625f, 0.23287321627140045166015625f));
    _108.x = clamp(_108.x, 0.0f, 1.0f);
    _108.x = (_108.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _119 = ((-abs(_119)) * 4.0f) + 1.0f;
    _119 = max(_119, 0.0f);
    _119 *= 0.0350000001490116119384765625f;
    float3 _173 = (_13_m5.xyz * _108.xxx) + _119.xxx;
    _108 = float4(_173.x, _173.y, _173.z, _108.w);
    float3 _184 = _13_m6.xxx + float3(0.0f, 0.666666686534881591796875f, 0.3333333432674407958984375f);
    _176 = float4(_184.x, _184.y, _184.z, _176.w);
    float3 _189 = frac(_176.xyz);
    _176 = float4(_189.x, _189.y, _189.z, _176.w);
    float3 _199 = (_176.xyz * 6.0f.xxx) + (-3.0f).xxx;
    _176 = float4(_199.x, _199.y, _199.z, _176.w);
    float3 _207 = abs(_176.xyz) + (-1.0f).xxx;
    _176 = float4(_207.x, _207.y, _207.z, _176.w);
    float3 _214 = clamp(_176.xyz, 0.0f.xxx, 1.0f.xxx);
    _176 = float4(_214.x, _214.y, _214.z, _176.w);
    float3 _219 = _176.xyz + (-1.0f).xxx;
    _176 = float4(_219.x, _219.y, _219.z, _176.w);
    float3 _229 = (_13_m6.yyy * _176.xyz) + 1.0f.xxx;
    _176 = float4(_229.x, _229.y, _229.z, _176.w);
    _69 = vs_TEXCOORD0.y + _13_m3;
    _238 = _13_m3 + _13_m3;
    _69 /= _238;
    _69 = clamp(_69, 0.0f, 1.0f);
    _249 = (-_13_m4.x) + _13_m4.y;
    _69 = (_69 * _249) + _13_m4.x;
    _249 = max(_249, 9.9999997473787516355514526367188e-05f);
    float3 _270 = _176.xyz * _69.xxx;
    _176 = float4(_270.x, _270.y, _270.z, _176.w);
    float3 _277 = _9.xxx * _176.xyz;
    _176 = float4(_277.x, _277.y, _277.z, _176.w);
    _280 = (_176.xyz * 0.305306017398834228515625f.xxx) + 0.6821711063385009765625f.xxx;
    _280 = (_176.xyz * _280) + 0.01252287812530994415283203125f.xxx;
    _296 = ((-_176.xyz) * _280) + _108.xyz;
    float3 _308 = _176.xyz * _280;
    _176 = float4(_308.x, _308.y, _308.z, _176.w);
    _9 = (_65.xxx * _296) + _176.xyz;
    _176.x = (-_13_m4.x) + _13_m6.z;
    _176.x /= _249;
    _176.x = clamp(_176.x, 0.0f, 1.0f);
    _176.y = (_176.x * _238) + (-_13_m3);
    _176.x = 0.0f;
    float2 _349 = (-_176.xy) + vs_TEXCOORD0;
    _176 = float4(_349.x, _349.y, _176.z, _176.w);
    _238 = (_13_m6.w * 0.12000000476837158203125f) + 1.0f;
    float2 _369 = ((-_13_m2.xy) * _238.xx) + abs(_176.xy);
    _176 = float4(_369.x, _369.y, _176.z, _176.w);
    float2 _380 = (_13_m2.zz * _238.xx) + _176.xy;
    _176 = float4(_380.x, _380.y, _176.z, _176.w);
    _384 = max(_176.xy, 0.0f.xx);
    _176.x = max(_176.y, _176.x);
    _176.x = min(_176.x, 0.0f);
    _399 = dot(_384, _384);
    _399 = sqrt(_399);
    _176.x += _399;
    _238 = ((-_13_m2.z) * _238) + _176.x;
    float3 _424 = _238.xxx + float3(-0.00039999998989515006542205810546875f, -0.0007999999797903001308441162109375f, 0.00150000001303851604461669921875f);
    _176 = float4(_424.x, _424.y, _424.z, _176.w);
    _176.x *= 400.0f;
    _176.x = clamp(_176.x, 0.0f, 1.0f);
    _176.x = (-_176.x) + 1.0f;
    _176.x = ((-_176.x) * 0.3499999940395355224609375f) + 1.0f;
    _280 = _9 * _176.xxx;
    _9 = ((-_9) * _176.xxx) + float3(0.0199999995529651641845703125f, 0.0199999995529651641845703125f, 0.02500000037252902984619140625f);
    float2 _463 = ddx_coarse(_176.yz);
    _176 = float4(_463.x, _176.y, _176.z, _463.y);
    float2 _468 = ddy_coarse(_176.yz);
    _296 = float3(_468.x, _468.y, _296.z);
    float2 _477 = abs(_176.xw) + abs(_296.xy);
    _176 = float4(_477.x, _176.y, _176.z, _477.y);
    float2 _483 = max(_176.xw, 9.9999999747524270787835121154785e-07f.xx);
    _176 = float4(_483.x, _176.y, _176.z, _483.y);
    float2 _490 = _176.yz / _176.xw;
    _176 = float4(_490.x, _490.y, _176.z, _176.w);
    float2 _496 = _176.xy + 0.5f.xx;
    _176 = float4(_496.x, _496.y, _176.z, _176.w);
    float2 _503 = clamp(_176.xy, 0.0f.xx, 1.0f.xx);
    _176 = float4(_503.x, _503.y, _176.z, _176.w);
    float2 _510 = (-_176.xy) + 1.0f.xx;
    _176 = float4(_510.x, _510.y, _176.z, _176.w);
    _9 = (_176.xxx * _9) + _280;
    float3 _521 = (-_9) + 1.0f.xxx;
    _176 = float4(_521.x, _176.y, _521.y, _521.z);
    _280.x = ddx_coarse(_238);
    _527 = ddy_coarse(_238);
    _280.x = abs(_527) + abs(_280.x);
    _280.x = max(_280.x, 9.9999999747524270787835121154785e-07f);
    _238 /= _280.x;
    _238 += 0.5f;
    _238 = clamp(_238, 0.0f, 1.0f);
    _238 = (-_238) + 1.0f;
    _9 = (_238.xxx * _176.xzw) + _9;
    float3 _565 = (-_9) + _13_m7.xyz;
    _176 = float4(_565.x, _176.y, _565.y, _565.z);
    _9 = (_176.yyy * _176.xzw) + _9;
    _9 += (-_13_m0.xyz);
    _238 = vs_TEXCOORD2;
    _238 = clamp(_238, 0.0f, 1.0f);
    _9 = (_238.xxx * _9) + _13_m0.xyz;
    _595 = float4(_9.x, _9.y, _9.z, _595.w);
    _595.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._595 = _595;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2) && defined(_MODE_WHEEL)
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
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _134;
static float3 _138;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _138 : NORMAL;
    float2 _134 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _157;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _21_m4.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD2 = exp2(_9.x);
    vs_TEXCOORD0 = _134;
    _9.x = dot(_138, _21_m2[0].xyz);
    _9.y = dot(_138, _21_m2[1].xyz);
    _9.z = dot(_138, _21_m2[2].xyz);
    _157 = dot(_9.xyz, _9.xyz);
    _157 = rsqrt(_157);
    float3 _169 = _157.xxx * _9.xyz;
    _9 = float4(_169.x, _169.y, _169.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _134 = stage_input._134;
    _138 = stage_input._138;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float _FaceRadius;
float _HubRadius;
float _SatRadius;
float4 _BezelColor;
float4 _HSV;
float4 _Pick;
#define _235_m0 unity_FogColor
#define _235_m1 _FaceRadius
#define _235_m2 _HubRadius
#define _235_m3 _SatRadius
#define _235_m4 _BezelColor
#define _235_m5 _HSV
#define _235_m6 _Pick



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _637;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _637 : SV_Target0;
};

static float3 _9;
static bool _22;
static float3 _31;
static float _45;
static float4 _58;
static float2 _76;
static bool _120;
static bool _145;
static bool _178;
static float3 _310;
static float4 _427;
static float _438;
static float _537;
static float2 _558;
static float2 _562;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _22 = _9.x < 9.9999999600419720025001879548654e-13f;
    _9.x = sqrt(_9.x);
    float2 _34;
    if (_22)
    {
        _34 = float2(0.0f, 1.0f);
    }
    else
    {
        _34 = vs_TEXCOORD0;
    }
    _31 = float3(_34.x, _34.y, _31.z);
    _45 = max(abs(_31.y), abs(_31.x));
    _45 = 1.0f / _45;
    _58.x = min(abs(_31.y), abs(_31.x));
    _45 *= _58.x;
    _58.x = _45 * _45;
    _76.x = (_58.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _76.x = (_58.x * _76.x) + 0.1801410019397735595703125f;
    _76.x = (_58.x * _76.x) + (-0.33029949665069580078125f);
    _58.x = (_58.x * _76.x) + 0.999866008758544921875f;
    _76.x = _45 * _58.x;
    _76.x = (_76.x * (-2.0f)) + 1.57079637050628662109375f;
    _120 = abs(_31.y) < abs(_31.x);
    float _130;
    if (_120)
    {
        _130 = _76.x;
    }
    else
    {
        _130 = 0.0f;
    }
    _76.x = _130;
    _45 = (_45 * _58.x) + _76.x;
    _145 = _31.y < (-_31.y);
    _58.x = _145 ? (-3.1415927410125732421875f) : 0.0f;
    _45 += _58.x;
    _58.x = min(_31.y, _31.x);
    _31.x = max(_31.y, _31.x);
    _22 = _31.x >= (-_31.x);
    _178 = _58.x < (-_58.x);
    _22 = _22 && _178;
    float _189;
    if (_22)
    {
        _189 = -_45;
    }
    else
    {
        _189 = _45;
    }
    _31.x = _189;
    _31.x *= 0.15915493667125701904296875f;
    _31.x = frac(_31.x);
    _31 = _31.xxx + float3(0.0f, 0.666666686534881591796875f, 0.3333333432674407958984375f);
    _31 = frac(_31);
    _31 = (_31 * 6.0f.xxx) + (-3.0f).xxx;
    _31 = abs(_31) + (-1.0f).xxx;
    _31 = clamp(_31, 0.0f.xxx, 1.0f.xxx);
    _31 += (-1.0f).xxx;
    _58.x = (-_235_m2) + _235_m3;
    _58.x = max(_58.x, 9.9999997473787516355514526367188e-05f);
    _76 = _9.xx + (-float2(_235_m2, _235_m1));
    _9.x /= _235_m2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.x *= 0.070000000298023223876953125f;
    _58.x = _76.x / _58.x;
    _58.x = clamp(_58.x, 0.0f, 1.0f);
    _31 = (_58.xxx * _31) + 1.0f.xxx;
    _31 *= _235_m5.zzz;
    float2 _307 = ddx_coarse(_76);
    _58 = float4(_307.x, _58.y, _58.z, _307.y);
    float2 _312 = ddy_coarse(_76);
    _310 = float3(_312.x, _312.y, _310.z);
    float2 _321 = abs(_58.xw) + abs(_310.xy);
    _58 = float4(_321.x, _58.y, _58.z, _321.y);
    float2 _328 = max(_58.xw, 9.9999999747524270787835121154785e-07f.xx);
    _58 = float4(_328.x, _58.y, _58.z, _328.y);
    float2 _334 = _76 / _58.xw;
    _58 = float4(_334.x, _58.y, _334.y, _58.w);
    _76.x = abs(_76.x) + (-0.000600000028498470783233642578125f);
    float2 _347 = _58.xz + 0.5f.xx;
    _58 = float4(_347.x, _58.y, _347.y, _58.w);
    float2 _354 = clamp(_58.xz, 0.0f.xx, 1.0f.xx);
    _58 = float4(_354.x, _58.y, _354.y, _58.w);
    _58.x = (-_58.x) + 1.0f;
    _9.x = (_58.x * (-_9.x)) + 1.0f;
    _9 = _9.xxx * _31;
    _45 = ddx_coarse(_76.x);
    _58.x = ddy_coarse(_76.x);
    _45 = abs(_45) + abs(_58.x);
    _45 = max(_45, 9.9999999747524270787835121154785e-07f);
    _45 = _76.x / _45;
    _45 += 0.5f;
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 = (-_45) + 1.0f;
    _45 = ((-_45) * 0.20000000298023223876953125f) + 1.0f;
    _9 = _45.xxx * _9;
    float3 _415 = (_9 * 0.305306017398834228515625f.xxx) + 0.6821711063385009765625f.xxx;
    _58 = float4(_415.x, _415.y, _58.z, _415.z);
    float3 _424 = (_9 * _58.xyw) + 0.01252287812530994415283203125f.xxx;
    _58 = float4(_424.x, _424.y, _58.z, _424.z);
    _427.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _427.x = rsqrt(_427.x);
    _438 = (vs_TEXCOORD1.y * _427.x) + (-0.699999988079071044921875f);
    float3 _450 = _427.xxx * vs_TEXCOORD1;
    _427 = float4(_450.x, _427.y, _450.y, _450.z);
    _427.x = dot(_427.xzw, float3(0.279447853565216064453125f, 0.931492865085601806640625f, 0.23287321627140045166015625f));
    _427.x = clamp(_427.x, 0.0f, 1.0f);
    _427.x = (_427.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _438 = ((-abs(_438)) * 4.0f) + 1.0f;
    _438 = max(_438, 0.0f);
    _438 *= 0.0350000001490116119384765625f;
    float3 _492 = (_235_m4.xyz * _427.xxx) + _438.xxx;
    _427 = float4(_492.x, _492.y, _492.z, _427.w);
    _310 = ((-_9) * _58.xyw) + _427.xyz;
    _9 *= _58.xyw;
    _9 = (_58.zzz * _310) + _9;
    float3 _518 = (-_9) + float3(0.0199999995529651641845703125f, 0.0199999995529651641845703125f, 0.02500000037252902984619140625f);
    _58 = float4(_518.x, _518.y, _518.z, _58.w);
    float2 _527 = vs_TEXCOORD0 + (-_235_m6.xy);
    _310 = float3(_527.x, _527.y, _310.z);
    _45 = dot(_310.xy, _310.xy);
    _45 = sqrt(_45);
    _537 = (_235_m5.w * 0.003500000573694705963134765625f) + 0.008200000040233135223388671875f;
    _45 += (-_537);
    float2 _555 = abs(_45.xx) + float2(-0.00150000001303851604461669921875f, -0.0007999999797903001308441162109375f);
    _310 = float3(_555.x, _555.y, _310.z);
    _558 = ddx_coarse(_310.xy);
    _562 = ddy_coarse(_310.xy);
    _558 = abs(_558) + abs(_562);
    _558 = max(_558, 9.9999999747524270787835121154785e-07f.xx);
    float2 _576 = _310.xy / _558;
    _310 = float3(_576.x, _576.y, _310.z);
    float2 _581 = _310.xy + 0.5f.xx;
    _310 = float3(_581.x, _581.y, _310.z);
    float2 _588 = clamp(_310.xy, 0.0f.xx, 1.0f.xx);
    _310 = float3(_588.x, _588.y, _310.z);
    float2 _595 = (-_310.xy) + 1.0f.xx;
    _310 = float3(_595.x, _595.y, _310.z);
    _9 = (_310.xxx * _58.xyz) + _9;
    float3 _607 = (-_9) + 1.0f.xxx;
    _58 = float4(_607.x, _607.y, _607.z, _58.w);
    _9 = (_310.yyy * _58.xyz) + _9;
    _9 += (-_235_m0.xyz);
    _45 = vs_TEXCOORD2;
    _45 = clamp(_45, 0.0f, 1.0f);
    _9 = (_45.xxx * _9) + _235_m0.xyz;
    _637 = float4(_9.x, _9.y, _9.z, _637.w);
    _637.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._637 = _637;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(_MODE_SLIDER)
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
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _127;
static float3 _131;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _131 : NORMAL;
    float2 _127 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _150;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _21_m4.z) + _21_m4.w;
    vs_TEXCOORD0 = _127;
    _9.x = dot(_131, _21_m2[0].xyz);
    _9.y = dot(_131, _21_m2[1].xyz);
    _9.z = dot(_131, _21_m2[2].xyz);
    _150 = dot(_9.xyz, _9.xyz);
    _150 = rsqrt(_150);
    float3 _162 = _150.xxx * _9.xyz;
    _9 = float4(_162.x, _162.y, _162.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _127 = stage_input._127;
    _131 = stage_input._131;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float4 _TrackSize;
float4 _HandleSize;
float _Travel;
float4 _ValueRange;
float4 _BezelColor;
float4 _HSV;
float4 _PickColor;
#define _13_m0 unity_FogColor
#define _13_m1 _TrackSize
#define _13_m2 _HandleSize
#define _13_m3 _Travel
#define _13_m4 _ValueRange
#define _13_m5 _BezelColor
#define _13_m6 _HSV
#define _13_m7 _PickColor



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _595;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _595 : SV_Target0;
};

static float3 _9;
static float _65;
static float _69;
static float4 _108;
static float _119;
static float4 _176;
static float _238;
static float _249;
static float3 _280;
static float3 _296;
static float2 _384;
static float _399;
static float _527;

void frag_inner()
{
    _9.x = (-_13_m1.x) + _13_m1.y;
    _9.x = (-_9.x) + abs(vs_TEXCOORD0.y);
    _9.y = max(_9.x, 0.0f);
    _9.x = vs_TEXCOORD0.x;
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x += (-_13_m1.x);
    _65 = ddx_coarse(_9.x);
    _69 = ddy_coarse(_9.x);
    _65 = abs(_69) + abs(_65);
    _65 = max(_65, 9.9999999747524270787835121154785e-07f);
    _65 = _9.x / _65;
    _9.x *= (-400.0f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * 0.180000007152557373046875f) + 0.819999992847442626953125f;
    _65 += 0.5f;
    _65 = clamp(_65, 0.0f, 1.0f);
    _108.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _108.x = rsqrt(_108.x);
    _119 = (vs_TEXCOORD1.y * _108.x) + (-0.699999988079071044921875f);
    float3 _130 = _108.xxx * vs_TEXCOORD1;
    _108 = float4(_130.x, _108.y, _130.y, _130.z);
    _108.x = dot(_108.xzw, float3(0.279447853565216064453125f, 0.931492865085601806640625f, 0.23287321627140045166015625f));
    _108.x = clamp(_108.x, 0.0f, 1.0f);
    _108.x = (_108.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _119 = ((-abs(_119)) * 4.0f) + 1.0f;
    _119 = max(_119, 0.0f);
    _119 *= 0.0350000001490116119384765625f;
    float3 _173 = (_13_m5.xyz * _108.xxx) + _119.xxx;
    _108 = float4(_173.x, _173.y, _173.z, _108.w);
    float3 _184 = _13_m6.xxx + float3(0.0f, 0.666666686534881591796875f, 0.3333333432674407958984375f);
    _176 = float4(_184.x, _184.y, _184.z, _176.w);
    float3 _189 = frac(_176.xyz);
    _176 = float4(_189.x, _189.y, _189.z, _176.w);
    float3 _199 = (_176.xyz * 6.0f.xxx) + (-3.0f).xxx;
    _176 = float4(_199.x, _199.y, _199.z, _176.w);
    float3 _207 = abs(_176.xyz) + (-1.0f).xxx;
    _176 = float4(_207.x, _207.y, _207.z, _176.w);
    float3 _214 = clamp(_176.xyz, 0.0f.xxx, 1.0f.xxx);
    _176 = float4(_214.x, _214.y, _214.z, _176.w);
    float3 _219 = _176.xyz + (-1.0f).xxx;
    _176 = float4(_219.x, _219.y, _219.z, _176.w);
    float3 _229 = (_13_m6.yyy * _176.xyz) + 1.0f.xxx;
    _176 = float4(_229.x, _229.y, _229.z, _176.w);
    _69 = vs_TEXCOORD0.y + _13_m3;
    _238 = _13_m3 + _13_m3;
    _69 /= _238;
    _69 = clamp(_69, 0.0f, 1.0f);
    _249 = (-_13_m4.x) + _13_m4.y;
    _69 = (_69 * _249) + _13_m4.x;
    _249 = max(_249, 9.9999997473787516355514526367188e-05f);
    float3 _270 = _176.xyz * _69.xxx;
    _176 = float4(_270.x, _270.y, _270.z, _176.w);
    float3 _277 = _9.xxx * _176.xyz;
    _176 = float4(_277.x, _277.y, _277.z, _176.w);
    _280 = (_176.xyz * 0.305306017398834228515625f.xxx) + 0.6821711063385009765625f.xxx;
    _280 = (_176.xyz * _280) + 0.01252287812530994415283203125f.xxx;
    _296 = ((-_176.xyz) * _280) + _108.xyz;
    float3 _308 = _176.xyz * _280;
    _176 = float4(_308.x, _308.y, _308.z, _176.w);
    _9 = (_65.xxx * _296) + _176.xyz;
    _176.x = (-_13_m4.x) + _13_m6.z;
    _176.x /= _249;
    _176.x = clamp(_176.x, 0.0f, 1.0f);
    _176.y = (_176.x * _238) + (-_13_m3);
    _176.x = 0.0f;
    float2 _349 = (-_176.xy) + vs_TEXCOORD0;
    _176 = float4(_349.x, _349.y, _176.z, _176.w);
    _238 = (_13_m6.w * 0.12000000476837158203125f) + 1.0f;
    float2 _369 = ((-_13_m2.xy) * _238.xx) + abs(_176.xy);
    _176 = float4(_369.x, _369.y, _176.z, _176.w);
    float2 _380 = (_13_m2.zz * _238.xx) + _176.xy;
    _176 = float4(_380.x, _380.y, _176.z, _176.w);
    _384 = max(_176.xy, 0.0f.xx);
    _176.x = max(_176.y, _176.x);
    _176.x = min(_176.x, 0.0f);
    _399 = dot(_384, _384);
    _399 = sqrt(_399);
    _176.x += _399;
    _238 = ((-_13_m2.z) * _238) + _176.x;
    float3 _424 = _238.xxx + float3(-0.00039999998989515006542205810546875f, -0.0007999999797903001308441162109375f, 0.00150000001303851604461669921875f);
    _176 = float4(_424.x, _424.y, _424.z, _176.w);
    _176.x *= 400.0f;
    _176.x = clamp(_176.x, 0.0f, 1.0f);
    _176.x = (-_176.x) + 1.0f;
    _176.x = ((-_176.x) * 0.3499999940395355224609375f) + 1.0f;
    _280 = _9 * _176.xxx;
    _9 = ((-_9) * _176.xxx) + float3(0.0199999995529651641845703125f, 0.0199999995529651641845703125f, 0.02500000037252902984619140625f);
    float2 _463 = ddx_coarse(_176.yz);
    _176 = float4(_463.x, _176.y, _176.z, _463.y);
    float2 _468 = ddy_coarse(_176.yz);
    _296 = float3(_468.x, _468.y, _296.z);
    float2 _477 = abs(_176.xw) + abs(_296.xy);
    _176 = float4(_477.x, _176.y, _176.z, _477.y);
    float2 _483 = max(_176.xw, 9.9999999747524270787835121154785e-07f.xx);
    _176 = float4(_483.x, _176.y, _176.z, _483.y);
    float2 _490 = _176.yz / _176.xw;
    _176 = float4(_490.x, _490.y, _176.z, _176.w);
    float2 _496 = _176.xy + 0.5f.xx;
    _176 = float4(_496.x, _496.y, _176.z, _176.w);
    float2 _503 = clamp(_176.xy, 0.0f.xx, 1.0f.xx);
    _176 = float4(_503.x, _503.y, _176.z, _176.w);
    float2 _510 = (-_176.xy) + 1.0f.xx;
    _176 = float4(_510.x, _510.y, _176.z, _176.w);
    _9 = (_176.xxx * _9) + _280;
    float3 _521 = (-_9) + 1.0f.xxx;
    _176 = float4(_521.x, _176.y, _521.y, _521.z);
    _280.x = ddx_coarse(_238);
    _527 = ddy_coarse(_238);
    _280.x = abs(_527) + abs(_280.x);
    _280.x = max(_280.x, 9.9999999747524270787835121154785e-07f);
    _238 /= _280.x;
    _238 += 0.5f;
    _238 = clamp(_238, 0.0f, 1.0f);
    _238 = (-_238) + 1.0f;
    _9 = (_238.xxx * _176.xzw) + _9;
    float3 _565 = (-_9) + _13_m7.xyz;
    _176 = float4(_565.x, _176.y, _565.y, _565.z);
    _9 = (_176.yyy * _176.xzw) + _9;
    _9 += (-_13_m0.xyz);
    _238 = vs_TEXCOORD2;
    _238 = clamp(_238, 0.0f, 1.0f);
    _9 = (_238.xxx * _9) + _13_m0.xyz;
    _595 = float4(_9.x, _9.y, _9.z, _595.w);
    _595.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._595 = _595;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR) && defined(_MODE_WHEEL)
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
static float vs_TEXCOORD2;
static float2 vs_TEXCOORD0;
static float2 _127;
static float3 _131;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _131 : NORMAL;
    float2 _127 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _150;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m1[1];
    _9 = (_21_m1[0] * _11.xxxx) + _9;
    _9 = (_21_m1[2] * _11.zzzz) + _9;
    _9 += _21_m1[3];
    _49 = _9.yyyy * _21_m3[1];
    _49 = (_21_m3[0] * _9.xxxx) + _49;
    _49 = (_21_m3[2] * _9.zzzz) + _49;
    _9 = (_21_m3[3] * _9.wwww) + _49;
    gl_Position = _9;
    _9.x = _9.z / _21_m0.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _21_m0.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD2 = (_9.x * _21_m4.z) + _21_m4.w;
    vs_TEXCOORD0 = _127;
    _9.x = dot(_131, _21_m2[0].xyz);
    _9.y = dot(_131, _21_m2[1].xyz);
    _9.z = dot(_131, _21_m2[2].xyz);
    _150 = dot(_9.xyz, _9.xyz);
    _150 = rsqrt(_150);
    float3 _162 = _150.xxx * _9.xyz;
    _9 = float4(_162.x, _162.y, _162.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _127 = stage_input._127;
    _131 = stage_input._131;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 unity_FogColor;
float _FaceRadius;
float _HubRadius;
float _SatRadius;
float4 _BezelColor;
float4 _HSV;
float4 _Pick;
#define _235_m0 unity_FogColor
#define _235_m1 _FaceRadius
#define _235_m2 _HubRadius
#define _235_m3 _SatRadius
#define _235_m4 _BezelColor
#define _235_m5 _HSV
#define _235_m6 _Pick



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD2;
static float4 _637;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float vs_TEXCOORD2 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 _637 : SV_Target0;
};

static float3 _9;
static bool _22;
static float3 _31;
static float _45;
static float4 _58;
static float2 _76;
static bool _120;
static bool _145;
static bool _178;
static float3 _310;
static float4 _427;
static float _438;
static float _537;
static float2 _558;
static float2 _562;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _22 = _9.x < 9.9999999600419720025001879548654e-13f;
    _9.x = sqrt(_9.x);
    float2 _34;
    if (_22)
    {
        _34 = float2(0.0f, 1.0f);
    }
    else
    {
        _34 = vs_TEXCOORD0;
    }
    _31 = float3(_34.x, _34.y, _31.z);
    _45 = max(abs(_31.y), abs(_31.x));
    _45 = 1.0f / _45;
    _58.x = min(abs(_31.y), abs(_31.x));
    _45 *= _58.x;
    _58.x = _45 * _45;
    _76.x = (_58.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _76.x = (_58.x * _76.x) + 0.1801410019397735595703125f;
    _76.x = (_58.x * _76.x) + (-0.33029949665069580078125f);
    _58.x = (_58.x * _76.x) + 0.999866008758544921875f;
    _76.x = _45 * _58.x;
    _76.x = (_76.x * (-2.0f)) + 1.57079637050628662109375f;
    _120 = abs(_31.y) < abs(_31.x);
    float _130;
    if (_120)
    {
        _130 = _76.x;
    }
    else
    {
        _130 = 0.0f;
    }
    _76.x = _130;
    _45 = (_45 * _58.x) + _76.x;
    _145 = _31.y < (-_31.y);
    _58.x = _145 ? (-3.1415927410125732421875f) : 0.0f;
    _45 += _58.x;
    _58.x = min(_31.y, _31.x);
    _31.x = max(_31.y, _31.x);
    _22 = _31.x >= (-_31.x);
    _178 = _58.x < (-_58.x);
    _22 = _22 && _178;
    float _189;
    if (_22)
    {
        _189 = -_45;
    }
    else
    {
        _189 = _45;
    }
    _31.x = _189;
    _31.x *= 0.15915493667125701904296875f;
    _31.x = frac(_31.x);
    _31 = _31.xxx + float3(0.0f, 0.666666686534881591796875f, 0.3333333432674407958984375f);
    _31 = frac(_31);
    _31 = (_31 * 6.0f.xxx) + (-3.0f).xxx;
    _31 = abs(_31) + (-1.0f).xxx;
    _31 = clamp(_31, 0.0f.xxx, 1.0f.xxx);
    _31 += (-1.0f).xxx;
    _58.x = (-_235_m2) + _235_m3;
    _58.x = max(_58.x, 9.9999997473787516355514526367188e-05f);
    _76 = _9.xx + (-float2(_235_m2, _235_m1));
    _9.x /= _235_m2;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.x *= 0.070000000298023223876953125f;
    _58.x = _76.x / _58.x;
    _58.x = clamp(_58.x, 0.0f, 1.0f);
    _31 = (_58.xxx * _31) + 1.0f.xxx;
    _31 *= _235_m5.zzz;
    float2 _307 = ddx_coarse(_76);
    _58 = float4(_307.x, _58.y, _58.z, _307.y);
    float2 _312 = ddy_coarse(_76);
    _310 = float3(_312.x, _312.y, _310.z);
    float2 _321 = abs(_58.xw) + abs(_310.xy);
    _58 = float4(_321.x, _58.y, _58.z, _321.y);
    float2 _328 = max(_58.xw, 9.9999999747524270787835121154785e-07f.xx);
    _58 = float4(_328.x, _58.y, _58.z, _328.y);
    float2 _334 = _76 / _58.xw;
    _58 = float4(_334.x, _58.y, _334.y, _58.w);
    _76.x = abs(_76.x) + (-0.000600000028498470783233642578125f);
    float2 _347 = _58.xz + 0.5f.xx;
    _58 = float4(_347.x, _58.y, _347.y, _58.w);
    float2 _354 = clamp(_58.xz, 0.0f.xx, 1.0f.xx);
    _58 = float4(_354.x, _58.y, _354.y, _58.w);
    _58.x = (-_58.x) + 1.0f;
    _9.x = (_58.x * (-_9.x)) + 1.0f;
    _9 = _9.xxx * _31;
    _45 = ddx_coarse(_76.x);
    _58.x = ddy_coarse(_76.x);
    _45 = abs(_45) + abs(_58.x);
    _45 = max(_45, 9.9999999747524270787835121154785e-07f);
    _45 = _76.x / _45;
    _45 += 0.5f;
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 = (-_45) + 1.0f;
    _45 = ((-_45) * 0.20000000298023223876953125f) + 1.0f;
    _9 = _45.xxx * _9;
    float3 _415 = (_9 * 0.305306017398834228515625f.xxx) + 0.6821711063385009765625f.xxx;
    _58 = float4(_415.x, _415.y, _58.z, _415.z);
    float3 _424 = (_9 * _58.xyw) + 0.01252287812530994415283203125f.xxx;
    _58 = float4(_424.x, _424.y, _58.z, _424.z);
    _427.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _427.x = rsqrt(_427.x);
    _438 = (vs_TEXCOORD1.y * _427.x) + (-0.699999988079071044921875f);
    float3 _450 = _427.xxx * vs_TEXCOORD1;
    _427 = float4(_450.x, _427.y, _450.y, _450.z);
    _427.x = dot(_427.xzw, float3(0.279447853565216064453125f, 0.931492865085601806640625f, 0.23287321627140045166015625f));
    _427.x = clamp(_427.x, 0.0f, 1.0f);
    _427.x = (_427.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _438 = ((-abs(_438)) * 4.0f) + 1.0f;
    _438 = max(_438, 0.0f);
    _438 *= 0.0350000001490116119384765625f;
    float3 _492 = (_235_m4.xyz * _427.xxx) + _438.xxx;
    _427 = float4(_492.x, _492.y, _492.z, _427.w);
    _310 = ((-_9) * _58.xyw) + _427.xyz;
    _9 *= _58.xyw;
    _9 = (_58.zzz * _310) + _9;
    float3 _518 = (-_9) + float3(0.0199999995529651641845703125f, 0.0199999995529651641845703125f, 0.02500000037252902984619140625f);
    _58 = float4(_518.x, _518.y, _518.z, _58.w);
    float2 _527 = vs_TEXCOORD0 + (-_235_m6.xy);
    _310 = float3(_527.x, _527.y, _310.z);
    _45 = dot(_310.xy, _310.xy);
    _45 = sqrt(_45);
    _537 = (_235_m5.w * 0.003500000573694705963134765625f) + 0.008200000040233135223388671875f;
    _45 += (-_537);
    float2 _555 = abs(_45.xx) + float2(-0.00150000001303851604461669921875f, -0.0007999999797903001308441162109375f);
    _310 = float3(_555.x, _555.y, _310.z);
    _558 = ddx_coarse(_310.xy);
    _562 = ddy_coarse(_310.xy);
    _558 = abs(_558) + abs(_562);
    _558 = max(_558, 9.9999999747524270787835121154785e-07f.xx);
    float2 _576 = _310.xy / _558;
    _310 = float3(_576.x, _576.y, _310.z);
    float2 _581 = _310.xy + 0.5f.xx;
    _310 = float3(_581.x, _581.y, _310.z);
    float2 _588 = clamp(_310.xy, 0.0f.xx, 1.0f.xx);
    _310 = float3(_588.x, _588.y, _310.z);
    float2 _595 = (-_310.xy) + 1.0f.xx;
    _310 = float3(_595.x, _595.y, _310.z);
    _9 = (_310.xxx * _58.xyz) + _9;
    float3 _607 = (-_9) + 1.0f.xxx;
    _58 = float4(_607.x, _607.y, _607.z, _58.w);
    _9 = (_310.yyy * _58.xyz) + _9;
    _9 += (-_235_m0.xyz);
    _45 = vs_TEXCOORD2;
    _45 = clamp(_45, 0.0f, 1.0f);
    _9 = (_45.xxx * _9) + _235_m0.xyz;
    _637 = float4(_9.x, _9.y, _9.z, _637.w);
    _637.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._637 = _637;
    return stage_output;
}

#endif
#elif defined(_MODE_WHEEL)
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
static float2 vs_TEXCOORD0;
static float2 _87;
static float3 _91;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _91 : NORMAL;
    float2 _87 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _113;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _9 += _21_m0[3];
    _49 = _9.yyyy * _21_m2[1];
    _49 = (_21_m2[0] * _9.xxxx) + _49;
    _49 = (_21_m2[2] * _9.zzzz) + _49;
    gl_Position = (_21_m2[3] * _9.wwww) + _49;
    vs_TEXCOORD0 = _87;
    _9.x = dot(_91, _21_m1[0].xyz);
    _9.y = dot(_91, _21_m1[1].xyz);
    _9.z = dot(_91, _21_m1[2].xyz);
    _113 = dot(_9.xyz, _9.xyz);
    _113 = rsqrt(_113);
    float3 _125 = _113.xxx * _9.xyz;
    _9 = float4(_125.x, _125.y, _125.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _87 = stage_input._87;
    _91 = stage_input._91;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float _FaceRadius;
float _HubRadius;
float _SatRadius;
float4 _BezelColor;
float4 _HSV;
float4 _Pick;
#define _235_m0 _FaceRadius
#define _235_m1 _HubRadius
#define _235_m2 _SatRadius
#define _235_m3 _BezelColor
#define _235_m4 _HSV
#define _235_m5 _Pick



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _618;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _618 : SV_Target0;
};

static float3 _9;
static bool _22;
static float3 _31;
static float _45;
static float4 _58;
static float2 _76;
static bool _120;
static bool _145;
static bool _178;
static float3 _310;
static float4 _427;
static float _438;
static float _537;
static float2 _558;
static float2 _562;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD0, vs_TEXCOORD0);
    _22 = _9.x < 9.9999999600419720025001879548654e-13f;
    _9.x = sqrt(_9.x);
    float2 _34;
    if (_22)
    {
        _34 = float2(0.0f, 1.0f);
    }
    else
    {
        _34 = vs_TEXCOORD0;
    }
    _31 = float3(_34.x, _34.y, _31.z);
    _45 = max(abs(_31.y), abs(_31.x));
    _45 = 1.0f / _45;
    _58.x = min(abs(_31.y), abs(_31.x));
    _45 *= _58.x;
    _58.x = _45 * _45;
    _76.x = (_58.x * 0.02083509974181652069091796875f) + (-0.08513300120830535888671875f);
    _76.x = (_58.x * _76.x) + 0.1801410019397735595703125f;
    _76.x = (_58.x * _76.x) + (-0.33029949665069580078125f);
    _58.x = (_58.x * _76.x) + 0.999866008758544921875f;
    _76.x = _45 * _58.x;
    _76.x = (_76.x * (-2.0f)) + 1.57079637050628662109375f;
    _120 = abs(_31.y) < abs(_31.x);
    float _130;
    if (_120)
    {
        _130 = _76.x;
    }
    else
    {
        _130 = 0.0f;
    }
    _76.x = _130;
    _45 = (_45 * _58.x) + _76.x;
    _145 = _31.y < (-_31.y);
    _58.x = _145 ? (-3.1415927410125732421875f) : 0.0f;
    _45 += _58.x;
    _58.x = min(_31.y, _31.x);
    _31.x = max(_31.y, _31.x);
    _22 = _31.x >= (-_31.x);
    _178 = _58.x < (-_58.x);
    _22 = _22 && _178;
    float _189;
    if (_22)
    {
        _189 = -_45;
    }
    else
    {
        _189 = _45;
    }
    _31.x = _189;
    _31.x *= 0.15915493667125701904296875f;
    _31.x = frac(_31.x);
    _31 = _31.xxx + float3(0.0f, 0.666666686534881591796875f, 0.3333333432674407958984375f);
    _31 = frac(_31);
    _31 = (_31 * 6.0f.xxx) + (-3.0f).xxx;
    _31 = abs(_31) + (-1.0f).xxx;
    _31 = clamp(_31, 0.0f.xxx, 1.0f.xxx);
    _31 += (-1.0f).xxx;
    _58.x = (-_235_m1) + _235_m2;
    _58.x = max(_58.x, 9.9999997473787516355514526367188e-05f);
    _76 = _9.xx + (-float2(_235_m1, _235_m0));
    _9.x /= _235_m1;
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x *= _9.x;
    _9.x *= 0.070000000298023223876953125f;
    _58.x = _76.x / _58.x;
    _58.x = clamp(_58.x, 0.0f, 1.0f);
    _31 = (_58.xxx * _31) + 1.0f.xxx;
    _31 *= _235_m4.zzz;
    float2 _307 = ddx_coarse(_76);
    _58 = float4(_307.x, _58.y, _58.z, _307.y);
    float2 _312 = ddy_coarse(_76);
    _310 = float3(_312.x, _312.y, _310.z);
    float2 _321 = abs(_58.xw) + abs(_310.xy);
    _58 = float4(_321.x, _58.y, _58.z, _321.y);
    float2 _328 = max(_58.xw, 9.9999999747524270787835121154785e-07f.xx);
    _58 = float4(_328.x, _58.y, _58.z, _328.y);
    float2 _334 = _76 / _58.xw;
    _58 = float4(_334.x, _58.y, _334.y, _58.w);
    _76.x = abs(_76.x) + (-0.000600000028498470783233642578125f);
    float2 _347 = _58.xz + 0.5f.xx;
    _58 = float4(_347.x, _58.y, _347.y, _58.w);
    float2 _354 = clamp(_58.xz, 0.0f.xx, 1.0f.xx);
    _58 = float4(_354.x, _58.y, _354.y, _58.w);
    _58.x = (-_58.x) + 1.0f;
    _9.x = (_58.x * (-_9.x)) + 1.0f;
    _9 = _9.xxx * _31;
    _45 = ddx_coarse(_76.x);
    _58.x = ddy_coarse(_76.x);
    _45 = abs(_45) + abs(_58.x);
    _45 = max(_45, 9.9999999747524270787835121154785e-07f);
    _45 = _76.x / _45;
    _45 += 0.5f;
    _45 = clamp(_45, 0.0f, 1.0f);
    _45 = (-_45) + 1.0f;
    _45 = ((-_45) * 0.20000000298023223876953125f) + 1.0f;
    _9 = _45.xxx * _9;
    float3 _415 = (_9 * 0.305306017398834228515625f.xxx) + 0.6821711063385009765625f.xxx;
    _58 = float4(_415.x, _415.y, _58.z, _415.z);
    float3 _424 = (_9 * _58.xyw) + 0.01252287812530994415283203125f.xxx;
    _58 = float4(_424.x, _424.y, _58.z, _424.z);
    _427.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _427.x = rsqrt(_427.x);
    _438 = (vs_TEXCOORD1.y * _427.x) + (-0.699999988079071044921875f);
    float3 _450 = _427.xxx * vs_TEXCOORD1;
    _427 = float4(_450.x, _427.y, _450.y, _450.z);
    _427.x = dot(_427.xzw, float3(0.279447853565216064453125f, 0.931492865085601806640625f, 0.23287321627140045166015625f));
    _427.x = clamp(_427.x, 0.0f, 1.0f);
    _427.x = (_427.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _438 = ((-abs(_438)) * 4.0f) + 1.0f;
    _438 = max(_438, 0.0f);
    _438 *= 0.0350000001490116119384765625f;
    float3 _492 = (_235_m3.xyz * _427.xxx) + _438.xxx;
    _427 = float4(_492.x, _492.y, _492.z, _427.w);
    _310 = ((-_9) * _58.xyw) + _427.xyz;
    _9 *= _58.xyw;
    _9 = (_58.zzz * _310) + _9;
    float3 _518 = (-_9) + float3(0.0199999995529651641845703125f, 0.0199999995529651641845703125f, 0.02500000037252902984619140625f);
    _58 = float4(_518.x, _518.y, _518.z, _58.w);
    float2 _527 = vs_TEXCOORD0 + (-_235_m5.xy);
    _310 = float3(_527.x, _527.y, _310.z);
    _45 = dot(_310.xy, _310.xy);
    _45 = sqrt(_45);
    _537 = (_235_m4.w * 0.003500000573694705963134765625f) + 0.008200000040233135223388671875f;
    _45 += (-_537);
    float2 _555 = abs(_45.xx) + float2(-0.00150000001303851604461669921875f, -0.0007999999797903001308441162109375f);
    _310 = float3(_555.x, _555.y, _310.z);
    _558 = ddx_coarse(_310.xy);
    _562 = ddy_coarse(_310.xy);
    _558 = abs(_558) + abs(_562);
    _558 = max(_558, 9.9999999747524270787835121154785e-07f.xx);
    float2 _576 = _310.xy / _558;
    _310 = float3(_576.x, _576.y, _310.z);
    float2 _581 = _310.xy + 0.5f.xx;
    _310 = float3(_581.x, _581.y, _310.z);
    float2 _588 = clamp(_310.xy, 0.0f.xx, 1.0f.xx);
    _310 = float3(_588.x, _588.y, _310.z);
    float2 _595 = (-_310.xy) + 1.0f.xx;
    _310 = float3(_595.x, _595.y, _310.z);
    _9 = (_310.xxx * _58.xyz) + _9;
    float3 _607 = (-_9) + 1.0f.xxx;
    _58 = float4(_607.x, _607.y, _607.z, _58.w);
    _9 = (_310.yyy * _58.xyz) + _9;
    _618 = float4(_9.x, _9.y, _9.z, _618.w);
    _618.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._618 = _618;
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
static float2 vs_TEXCOORD0;
static float2 _87;
static float3 _91;
static float3 vs_TEXCOORD1;

struct SPIRV_Cross_Input
{
    float4 _11 : POSITION;
    float3 _91 : NORMAL;
    float2 _87 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _49;
static float _113;

void vert_inner()
{
    __unity_init();
    _9 = _11.yyyy * _21_m0[1];
    _9 = (_21_m0[0] * _11.xxxx) + _9;
    _9 = (_21_m0[2] * _11.zzzz) + _9;
    _9 += _21_m0[3];
    _49 = _9.yyyy * _21_m2[1];
    _49 = (_21_m2[0] * _9.xxxx) + _49;
    _49 = (_21_m2[2] * _9.zzzz) + _49;
    gl_Position = (_21_m2[3] * _9.wwww) + _49;
    vs_TEXCOORD0 = _87;
    _9.x = dot(_91, _21_m1[0].xyz);
    _9.y = dot(_91, _21_m1[1].xyz);
    _9.z = dot(_91, _21_m1[2].xyz);
    _113 = dot(_9.xyz, _9.xyz);
    _113 = rsqrt(_113);
    float3 _125 = _113.xxx * _9.xyz;
    _9 = float4(_125.x, _125.y, _125.z, _9.w);
    vs_TEXCOORD1 = _9.xyz;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _11 = stage_input._11;
    _87 = stage_input._87;
    _91 = stage_input._91;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float4 _TrackSize;
float4 _HandleSize;
float _Travel;
float4 _ValueRange;
float4 _BezelColor;
float4 _HSV;
float4 _PickColor;
#define _13_m0 _TrackSize
#define _13_m1 _HandleSize
#define _13_m2 _Travel
#define _13_m3 _ValueRange
#define _13_m4 _BezelColor
#define _13_m5 _HSV
#define _13_m6 _PickColor



static float2 vs_TEXCOORD0;
static float3 vs_TEXCOORD1;
static float4 _576;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float3 vs_TEXCOORD1 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 _576 : SV_Target0;
};

static float3 _9;
static float _65;
static float _69;
static float4 _108;
static float _119;
static float4 _176;
static float _238;
static float _249;
static float3 _280;
static float3 _296;
static float2 _384;
static float _399;
static float _527;

void frag_inner()
{
    _9.x = (-_13_m0.x) + _13_m0.y;
    _9.x = (-_9.x) + abs(vs_TEXCOORD0.y);
    _9.y = max(_9.x, 0.0f);
    _9.x = vs_TEXCOORD0.x;
    _9.x = dot(_9.xy, _9.xy);
    _9.x = sqrt(_9.x);
    _9.x += (-_13_m0.x);
    _65 = ddx_coarse(_9.x);
    _69 = ddy_coarse(_9.x);
    _65 = abs(_69) + abs(_65);
    _65 = max(_65, 9.9999999747524270787835121154785e-07f);
    _65 = _9.x / _65;
    _9.x *= (-400.0f);
    _9.x = clamp(_9.x, 0.0f, 1.0f);
    _9.x = (_9.x * 0.180000007152557373046875f) + 0.819999992847442626953125f;
    _65 += 0.5f;
    _65 = clamp(_65, 0.0f, 1.0f);
    _108.x = dot(vs_TEXCOORD1, vs_TEXCOORD1);
    _108.x = rsqrt(_108.x);
    _119 = (vs_TEXCOORD1.y * _108.x) + (-0.699999988079071044921875f);
    float3 _130 = _108.xxx * vs_TEXCOORD1;
    _108 = float4(_130.x, _108.y, _130.y, _130.z);
    _108.x = dot(_108.xzw, float3(0.279447853565216064453125f, 0.931492865085601806640625f, 0.23287321627140045166015625f));
    _108.x = clamp(_108.x, 0.0f, 1.0f);
    _108.x = (_108.x * 0.550000011920928955078125f) + 0.449999988079071044921875f;
    _119 = ((-abs(_119)) * 4.0f) + 1.0f;
    _119 = max(_119, 0.0f);
    _119 *= 0.0350000001490116119384765625f;
    float3 _173 = (_13_m4.xyz * _108.xxx) + _119.xxx;
    _108 = float4(_173.x, _173.y, _173.z, _108.w);
    float3 _184 = _13_m5.xxx + float3(0.0f, 0.666666686534881591796875f, 0.3333333432674407958984375f);
    _176 = float4(_184.x, _184.y, _184.z, _176.w);
    float3 _189 = frac(_176.xyz);
    _176 = float4(_189.x, _189.y, _189.z, _176.w);
    float3 _199 = (_176.xyz * 6.0f.xxx) + (-3.0f).xxx;
    _176 = float4(_199.x, _199.y, _199.z, _176.w);
    float3 _207 = abs(_176.xyz) + (-1.0f).xxx;
    _176 = float4(_207.x, _207.y, _207.z, _176.w);
    float3 _214 = clamp(_176.xyz, 0.0f.xxx, 1.0f.xxx);
    _176 = float4(_214.x, _214.y, _214.z, _176.w);
    float3 _219 = _176.xyz + (-1.0f).xxx;
    _176 = float4(_219.x, _219.y, _219.z, _176.w);
    float3 _229 = (_13_m5.yyy * _176.xyz) + 1.0f.xxx;
    _176 = float4(_229.x, _229.y, _229.z, _176.w);
    _69 = vs_TEXCOORD0.y + _13_m2;
    _238 = _13_m2 + _13_m2;
    _69 /= _238;
    _69 = clamp(_69, 0.0f, 1.0f);
    _249 = (-_13_m3.x) + _13_m3.y;
    _69 = (_69 * _249) + _13_m3.x;
    _249 = max(_249, 9.9999997473787516355514526367188e-05f);
    float3 _270 = _176.xyz * _69.xxx;
    _176 = float4(_270.x, _270.y, _270.z, _176.w);
    float3 _277 = _9.xxx * _176.xyz;
    _176 = float4(_277.x, _277.y, _277.z, _176.w);
    _280 = (_176.xyz * 0.305306017398834228515625f.xxx) + 0.6821711063385009765625f.xxx;
    _280 = (_176.xyz * _280) + 0.01252287812530994415283203125f.xxx;
    _296 = ((-_176.xyz) * _280) + _108.xyz;
    float3 _308 = _176.xyz * _280;
    _176 = float4(_308.x, _308.y, _308.z, _176.w);
    _9 = (_65.xxx * _296) + _176.xyz;
    _176.x = (-_13_m3.x) + _13_m5.z;
    _176.x /= _249;
    _176.x = clamp(_176.x, 0.0f, 1.0f);
    _176.y = (_176.x * _238) + (-_13_m2);
    _176.x = 0.0f;
    float2 _349 = (-_176.xy) + vs_TEXCOORD0;
    _176 = float4(_349.x, _349.y, _176.z, _176.w);
    _238 = (_13_m5.w * 0.12000000476837158203125f) + 1.0f;
    float2 _369 = ((-_13_m1.xy) * _238.xx) + abs(_176.xy);
    _176 = float4(_369.x, _369.y, _176.z, _176.w);
    float2 _380 = (_13_m1.zz * _238.xx) + _176.xy;
    _176 = float4(_380.x, _380.y, _176.z, _176.w);
    _384 = max(_176.xy, 0.0f.xx);
    _176.x = max(_176.y, _176.x);
    _176.x = min(_176.x, 0.0f);
    _399 = dot(_384, _384);
    _399 = sqrt(_399);
    _176.x += _399;
    _238 = ((-_13_m1.z) * _238) + _176.x;
    float3 _424 = _238.xxx + float3(-0.00039999998989515006542205810546875f, -0.0007999999797903001308441162109375f, 0.00150000001303851604461669921875f);
    _176 = float4(_424.x, _424.y, _424.z, _176.w);
    _176.x *= 400.0f;
    _176.x = clamp(_176.x, 0.0f, 1.0f);
    _176.x = (-_176.x) + 1.0f;
    _176.x = ((-_176.x) * 0.3499999940395355224609375f) + 1.0f;
    _280 = _9 * _176.xxx;
    _9 = ((-_9) * _176.xxx) + float3(0.0199999995529651641845703125f, 0.0199999995529651641845703125f, 0.02500000037252902984619140625f);
    float2 _463 = ddx_coarse(_176.yz);
    _176 = float4(_463.x, _176.y, _176.z, _463.y);
    float2 _468 = ddy_coarse(_176.yz);
    _296 = float3(_468.x, _468.y, _296.z);
    float2 _477 = abs(_176.xw) + abs(_296.xy);
    _176 = float4(_477.x, _176.y, _176.z, _477.y);
    float2 _483 = max(_176.xw, 9.9999999747524270787835121154785e-07f.xx);
    _176 = float4(_483.x, _176.y, _176.z, _483.y);
    float2 _490 = _176.yz / _176.xw;
    _176 = float4(_490.x, _490.y, _176.z, _176.w);
    float2 _496 = _176.xy + 0.5f.xx;
    _176 = float4(_496.x, _496.y, _176.z, _176.w);
    float2 _503 = clamp(_176.xy, 0.0f.xx, 1.0f.xx);
    _176 = float4(_503.x, _503.y, _176.z, _176.w);
    float2 _510 = (-_176.xy) + 1.0f.xx;
    _176 = float4(_510.x, _510.y, _176.z, _176.w);
    _9 = (_176.xxx * _9) + _280;
    float3 _521 = (-_9) + 1.0f.xxx;
    _176 = float4(_521.x, _176.y, _521.y, _521.z);
    _280.x = ddx_coarse(_238);
    _527 = ddy_coarse(_238);
    _280.x = abs(_527) + abs(_280.x);
    _280.x = max(_280.x, 9.9999999747524270787835121154785e-07f);
    _238 /= _280.x;
    _238 += 0.5f;
    _238 = clamp(_238, 0.0f, 1.0f);
    _238 = (-_238) + 1.0f;
    _9 = (_238.xxx * _176.xzw) + _9;
    float3 _565 = (-_9) + _13_m6.xyz;
    _176 = float4(_565.x, _176.y, _565.y, _565.z);
    _9 = (_176.yyy * _176.xzw) + _9;
    _576 = float4(_9.x, _9.y, _9.z, _576.w);
    _576.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._576 = _576;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}