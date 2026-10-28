// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Slop/BtmRiftShard" {
Properties {

_BaseColor ("Crystal", Color) = (0.06,0.08,0.2,1)

_GlowColor ("Glow", Color) = (0.45,0.85,1,1)

_EdgeColor ("Cut Edge", Color) = (0.75,0.95,1,1)

_CrackScale ("Crack Scale (per m)", Float) = 9.0

_CrackWidth ("Crack Width", Range(0.005, 0.2)) = 0.05000000074505806

_Drift ("Drift (m)", Float) = 0.017999999225139618

_SurgeOpen ("Surge Opening (m)", Float) = 0.14000000059604645

_Surge ("Surge", Range(0, 1)) = 0.0

_CoreRadius ("Core Light Radius (m)", Float) = 1.600000023841858

}
SubShader {
 Tags { "RenderType" = "Opaque" }
 Pass {
Cull Back
ZWrite On
  Tags { "RenderType" = "Opaque" }
  HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#if defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _57_m2[4];
float4x4 unity_WorldToObject;
static float4 _57_m3[4];
float4x4 unity_MatrixVP;
static float4 _57_m4[4];
float4 unity_FogParams;
float _Drift;
float _SurgeOpen;
float _Surge;
void __unity_init()
{
    _57_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _57_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _57_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _57_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _57_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _57_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _57_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _57_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _57_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _57_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _57_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _57_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _57_m0 _Time
#define _57_m1 _ProjectionParams
#define _57_m5 unity_FogParams
#define _57_m6 _Drift
#define _57_m7 _SurgeOpen
#define _57_m8 _Surge



static float4 gl_Position;
static float3 _12;
static float4 _41;
static float4 _174;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _336;
static float3 _340;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _174 : POSITION;
    float3 _340 : NORMAL;
    float4 _41 : COLOR;
    float2 _336 : TEXCOORD0;
    float3 _12 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _39;
static float _74;
static float3 _85;
static float3 _111;
static float2 _188;
static float4 _194;
static float3 _214;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_12.xy, _12.xy);
    _9.x = sqrt(_9.x);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    float2 _36 = _12.xy / _9.xx;
    _9 = float4(_36.x, _36.y, _9.z, _9.w);
    float3 _48 = _41.yyy * float3(11.0f, 6.283100128173828125f, 4.0f);
    _39 = float4(_48.x, _48.y, _48.z, _39.w);
    float3 _71 = (_57_m0.yyy * float3(0.550000011920928955078125f, 0.89999997615814208984375f, 0.699999988079071044921875f)) + _39.xyz;
    _39 = float4(_71.x, _71.y, _71.z, _39.w);
    _74 = cos(_39.z);
    float2 _81 = sin(_39.xy);
    _39 = float4(_81.x, _81.y, _39.z, _39.w);
    _85.z = _74 * _57_m6;
    _39.z = 0.0f;
    _39.w = 0.5f;
    float2 _108 = float2(float2(float2(_57_m6, _57_m6)));
    _85 = float3(_108.x, _108.y, _85.z);
    _111 = _39.zyw * _85;
    _74 = _57_m7 * _57_m8;
    float2 _128 = _41.yy + float2(-0.5f, 0.60000002384185791015625f);
    _85 = float3(_128.x, _128.y, _85.z);
    _74 *= _85.y;
    _85.x *= _57_m8;
    _85.x *= 0.25f;
    _39.x = (_39.x * 0.0500000007450580596923828125f) + _85.x;
    _85.x = cos(_39.x);
    _39.x = sin(_39.x);
    _9.z = 0.3499999940395355224609375f;
    float3 _171 = (_9.xyz * _74.xxx) + _111;
    _9 = float4(_171.x, _171.y, _171.z, _9.w);
    _111 = float3(_174.yx.x, _174.yx.y, _111.z);
    float2 _184 = _111.xy + (-_12.yx);
    _111 = float3(_184.x, _184.y, _111.z);
    _188 = _39.xx * _111.xy;
    _194.x = (_111.y * _85.x) + (-_188.x);
    _194.y = (_111.x * _85.x) + _188.y;
    _214 = float3(_12.xy.x, _12.xy.y, _214.z);
    _214.z = _174.z;
    _194.z = 0.0f;
    _111 = _194.xyz + _214;
    float3 _231 = _9.xyz + _111;
    _9 = float4(_231.x, _231.y, _231.z, _9.w);
    _194 = _9.yyyy * _57_m2[1];
    _194 = (_57_m2[0] * _9.xxxx) + _194;
    _9 = (_57_m2[2] * _9.zzzz) + _194;
    _9 += _57_m2[3];
    _194 = _9.yyyy * _57_m4[1];
    _194 = (_57_m4[0] * _9.xxxx) + _194;
    _194 = (_57_m4[2] * _9.zzzz) + _194;
    _194 = (_57_m4[3] * _9.wwww) + _194;
    vs_TEXCOORD1 = _9.xyz;
    gl_Position = _194;
    _9.x = _194.z / _57_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _57_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _57_m5.y;
    vs_TEXCOORD5 = exp2(-_9.x);
    vs_TEXCOORD0 = _336;
    float2 _343 = _39.xx * _340.yx;
    _9 = float4(_343.x, _343.y, _9.z, _9.w);
    _39.x = (_340.x * _85.x) + (-_9.x);
    _39.y = (_340.y * _85.x) + _9.y;
    _39.z = _340.z;
    _9.x = dot(_39.xyz, _57_m3[0].xyz);
    _9.y = dot(_39.xyz, _57_m3[1].xyz);
    _9.z = dot(_39.xyz, _57_m3[2].xyz);
    _74 = dot(_9.xyz, _9.xyz);
    _74 = rsqrt(_74);
    vs_TEXCOORD2 = _74.xxx * _9.xyz;
    vs_TEXCOORD3 = _57_m2[3].xyz;
    vs_TEXCOORD4 = _41.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _41 = stage_input._41;
    _174 = stage_input._174;
    _336 = stage_input._336;
    _340 = stage_input._340;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _BaseColor;
float4 _GlowColor;
float4 _EdgeColor;
float _CrackScale;
float _CrackWidth;
float _Surge;
float _CoreRadius;
#define _49_m0 _WorldSpaceCameraPos
#define _49_m1 unity_FogColor
#define _49_m2 _BaseColor
#define _49_m3 _GlowColor
#define _49_m4 _EdgeColor
#define _49_m5 _CrackScale
#define _49_m6 _CrackWidth
#define _49_m7 _Surge
#define _49_m8 _CoreRadius



static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD5;
static float4 _528;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _528 : SV_Target0;
};

static float3 _9;
static float _27;
static float3 _42;
static float3 _65;
static float _76;
static float _89;
static float3 _131;
static float _179;
static float _201;
static float3 _246;
static float2 _251;
static float2 _265;
static float _271;
static float3 _283;
static bool3 _320;
static float3 _383;
static float _476;
static int _547;
static bool _548;
static bool _549;
static int _550;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD2;
    _27 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    _9 = _27.xxx * _9;
    _42 = (-vs_TEXCOORD1) + _49_m0;
    _27 = dot(_42, _42);
    _27 = rsqrt(_27);
    _42 = _27.xxx * _42;
    _65 = (-vs_TEXCOORD1) + vs_TEXCOORD3;
    _27 = dot(_65, _65);
    _27 = sqrt(_27);
    _76 = _27 / _49_m8;
    _76 = (-_76) + 1.0f;
    _76 = clamp(_76, 0.0f, 1.0f);
    _89 = (_49_m7 * 0.89999997615814208984375f) + 0.550000011920928955078125f;
    _27 = max(_27, 0.001000000047497451305389404296875f);
    _65 /= _27.xxx;
    _27 = dot(_9, _65);
    _27 = (_27 * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _27 = clamp(_27, 0.0f, 1.0f);
    _65.x = (_9.y * 0.5f) + 0.5f;
    _65.x = clamp(_65.x, 0.0f, 1.0f);
    _65.x = (_65.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _131 = _27.xxx * _49_m3.xyz;
    _131 = _27.xxx * _131;
    _131 = _76.xxx * _131;
    _131 = _89.xxx * _131;
    _131 *= 0.64999997615814208984375f.xxx;
    _65 = (_49_m2.xyz * _65.xxx) + _131;
    _9.x = dot(_9, _42);
    _9.x = min(abs(_9.x), 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _179 = _9.x * _9.x;
    _9.x = _179 * _9.x;
    _9 = _9.xxx * _49_m3.xyz;
    _9 = (_9 * 0.300000011920928955078125f.xxx) + _65;
    _201 = vs_TEXCOORD4.y * 13.0f;
    float2 _219 = (vs_TEXCOORD0 * _49_m5.xx) + _201.xx;
    _42 = float3(_219.x, _219.y, _42.z);
    float2 _224 = floor(_42.xy);
    _65 = float3(_224.x, _224.y, _65.z);
    float2 _229 = frac(_42.xy);
    _42 = float3(_229.x, _229.y, _42.z);
    _131.x = 8.0f;
    _131.y = 8.0f;
    float _336;
    float2 _352;
    for (int _236 = -1; _236 <= 1; _236++)
    {
        _246.y = float(_236);
        _251 = _131.yx;
        for (int _254 = -1; _254 <= 1; _254++)
        {
            _246.x = float(_254);
            _265 = _65.xy + _246.xy;
            _271 = dot(_265, float2(127.09999847412109375f, 311.70001220703125f));
            _265.x = dot(_265, float2(269.5f, 183.3000030517578125f));
            _283.x = sin(_271);
            _283.y = sin(_265.x);
            _265 = _283.xy * 43758.546875f.xx;
            _265 = frac(_265);
            float2 _301 = _265 + _246.xy;
            _246 = float3(_301.x, _246.y, _301.y);
            float2 _309 = (-_42.xy) + _246.xz;
            _246 = float3(_309.x, _246.y, _309.y);
            _283.x = dot(_246.xz, _246.xz);
            bool2 _328 = bool4(_283.xxxx.x < _251.xxyx.x, _283.xxxx.y < _251.xxyx.y, _283.xxxx.z < _251.xxyx.z, _283.xxxx.w < _251.xxyx.w).xz;
            _320 = bool3(_328.x, _320.y, _328.y);
            if (_320.z)
            {
                _336 = _283.x;
            }
            else
            {
                _336 = _251.y;
            }
            _283.z = _336;
            _283.y = _251.x;
            if (_320.x)
            {
                _352 = _283.xy;
            }
            else
            {
                _352 = _283.yz;
            }
            _251 = _352;
        }
        _131 = float3(_251.yx.x, _251.yx.y, _131.z);
    }
    float2 _371 = sqrt(_131.xy);
    _42 = float3(_371.x, _371.y, _42.z);
    _27 = (-_42.y) + _42.x;
    _42.x = ddx_coarse(_27);
    _383.x = ddy_coarse(_27);
    _42.x = abs(_383.x) + abs(_42.x);
    _383.x = (-_42.x) + _49_m6;
    _42.x += _49_m6;
    _42.x = (-_383.x) + _42.x;
    _27 += (-_383.x);
    _42.x = 1.0f / _42.x;
    _27 *= _42.x;
    _27 = clamp(_27, 0.0f, 1.0f);
    _42.x = (_27 * (-2.0f)) + 3.0f;
    _27 *= _27;
    _27 = ((-_42.x) * _27) + 1.0f;
    _42 = _27.xxx * _49_m3.xyz;
    _27 = (_76 * 0.75f) + 0.25f;
    _42 = _27.xxx * _42;
    _9 = (_42 * _89.xxx) + _9;
    _201 = vs_TEXCOORD4.x + (-0.800000011920928955078125f);
    _201 *= 5.000000476837158203125f;
    _201 = clamp(_201, 0.0f, 1.0f);
    _476 = (_201 * (-2.0f)) + 3.0f;
    _201 *= _201;
    _201 *= _476;
    _27 = (_89 * 0.300000011920928955078125f) + 0.699999988079071044921875f;
    _42.x = _201 * 0.85000002384185791015625f;
    _383 = (_49_m4.xyz * _27.xxx) + (-_9);
    _9 = (_42.xxx * _383) + _9;
    _27 = vs_TEXCOORD5;
    _27 = clamp(_27, 0.0f, 1.0f);
    _9 += (-_49_m1.xyz);
    _9 = (_27.xxx * _9) + _49_m1.xyz;
    _528 = float4(_9.x, _9.y, _9.z, _528.w);
    _528.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._528 = _528;
    return stage_output;
}

#endif
#elif defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _57_m2[4];
float4x4 unity_WorldToObject;
static float4 _57_m3[4];
float4x4 unity_MatrixVP;
static float4 _57_m4[4];
float4 unity_FogParams;
float _Drift;
float _SurgeOpen;
float _Surge;
void __unity_init()
{
    _57_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _57_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _57_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _57_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _57_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _57_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _57_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _57_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _57_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _57_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _57_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _57_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _57_m0 _Time
#define _57_m1 _ProjectionParams
#define _57_m5 unity_FogParams
#define _57_m6 _Drift
#define _57_m7 _SurgeOpen
#define _57_m8 _Surge



static float4 gl_Position;
static float3 _12;
static float4 _41;
static float4 _174;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _342;
static float3 _346;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _174 : POSITION;
    float3 _346 : NORMAL;
    float4 _41 : COLOR;
    float2 _342 : TEXCOORD0;
    float3 _12 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _39;
static float _74;
static float3 _85;
static float3 _111;
static float2 _188;
static float4 _194;
static float3 _214;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_12.xy, _12.xy);
    _9.x = sqrt(_9.x);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    float2 _36 = _12.xy / _9.xx;
    _9 = float4(_36.x, _36.y, _9.z, _9.w);
    float3 _48 = _41.yyy * float3(11.0f, 6.283100128173828125f, 4.0f);
    _39 = float4(_48.x, _48.y, _48.z, _39.w);
    float3 _71 = (_57_m0.yyy * float3(0.550000011920928955078125f, 0.89999997615814208984375f, 0.699999988079071044921875f)) + _39.xyz;
    _39 = float4(_71.x, _71.y, _71.z, _39.w);
    _74 = cos(_39.z);
    float2 _81 = sin(_39.xy);
    _39 = float4(_81.x, _81.y, _39.z, _39.w);
    _85.z = _74 * _57_m6;
    _39.z = 0.0f;
    _39.w = 0.5f;
    float2 _108 = float2(float2(float2(_57_m6, _57_m6)));
    _85 = float3(_108.x, _108.y, _85.z);
    _111 = _39.zyw * _85;
    _74 = _57_m7 * _57_m8;
    float2 _128 = _41.yy + float2(-0.5f, 0.60000002384185791015625f);
    _85 = float3(_128.x, _128.y, _85.z);
    _74 *= _85.y;
    _85.x *= _57_m8;
    _85.x *= 0.25f;
    _39.x = (_39.x * 0.0500000007450580596923828125f) + _85.x;
    _85.x = cos(_39.x);
    _39.x = sin(_39.x);
    _9.z = 0.3499999940395355224609375f;
    float3 _171 = (_9.xyz * _74.xxx) + _111;
    _9 = float4(_171.x, _171.y, _171.z, _9.w);
    _111 = float3(_174.yx.x, _174.yx.y, _111.z);
    float2 _184 = _111.xy + (-_12.yx);
    _111 = float3(_184.x, _184.y, _111.z);
    _188 = _39.xx * _111.xy;
    _194.x = (_111.y * _85.x) + (-_188.x);
    _194.y = (_111.x * _85.x) + _188.y;
    _214 = float3(_12.xy.x, _12.xy.y, _214.z);
    _214.z = _174.z;
    _194.z = 0.0f;
    _111 = _194.xyz + _214;
    float3 _231 = _9.xyz + _111;
    _9 = float4(_231.x, _231.y, _231.z, _9.w);
    _194 = _9.yyyy * _57_m2[1];
    _194 = (_57_m2[0] * _9.xxxx) + _194;
    _9 = (_57_m2[2] * _9.zzzz) + _194;
    _9 += _57_m2[3];
    _194 = _9.yyyy * _57_m4[1];
    _194 = (_57_m4[0] * _9.xxxx) + _194;
    _194 = (_57_m4[2] * _9.zzzz) + _194;
    _194 = (_57_m4[3] * _9.wwww) + _194;
    vs_TEXCOORD1 = _9.xyz;
    gl_Position = _194;
    _9.x = _194.z / _57_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _57_m1.z;
    _9.x = max(_9.x, 0.0f);
    _9.x *= _57_m5.x;
    _9.x *= (-_9.x);
    vs_TEXCOORD5 = exp2(_9.x);
    vs_TEXCOORD0 = _342;
    float2 _349 = _39.xx * _346.yx;
    _9 = float4(_349.x, _349.y, _9.z, _9.w);
    _39.x = (_346.x * _85.x) + (-_9.x);
    _39.y = (_346.y * _85.x) + _9.y;
    _39.z = _346.z;
    _9.x = dot(_39.xyz, _57_m3[0].xyz);
    _9.y = dot(_39.xyz, _57_m3[1].xyz);
    _9.z = dot(_39.xyz, _57_m3[2].xyz);
    _74 = dot(_9.xyz, _9.xyz);
    _74 = rsqrt(_74);
    vs_TEXCOORD2 = _74.xxx * _9.xyz;
    vs_TEXCOORD3 = _57_m2[3].xyz;
    vs_TEXCOORD4 = _41.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _41 = stage_input._41;
    _174 = stage_input._174;
    _342 = stage_input._342;
    _346 = stage_input._346;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _BaseColor;
float4 _GlowColor;
float4 _EdgeColor;
float _CrackScale;
float _CrackWidth;
float _Surge;
float _CoreRadius;
#define _49_m0 _WorldSpaceCameraPos
#define _49_m1 unity_FogColor
#define _49_m2 _BaseColor
#define _49_m3 _GlowColor
#define _49_m4 _EdgeColor
#define _49_m5 _CrackScale
#define _49_m6 _CrackWidth
#define _49_m7 _Surge
#define _49_m8 _CoreRadius



static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD5;
static float4 _528;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _528 : SV_Target0;
};

static float3 _9;
static float _27;
static float3 _42;
static float3 _65;
static float _76;
static float _89;
static float3 _131;
static float _179;
static float _201;
static float3 _246;
static float2 _251;
static float2 _265;
static float _271;
static float3 _283;
static bool3 _320;
static float3 _383;
static float _476;
static int _547;
static bool _548;
static bool _549;
static int _550;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD2;
    _27 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    _9 = _27.xxx * _9;
    _42 = (-vs_TEXCOORD1) + _49_m0;
    _27 = dot(_42, _42);
    _27 = rsqrt(_27);
    _42 = _27.xxx * _42;
    _65 = (-vs_TEXCOORD1) + vs_TEXCOORD3;
    _27 = dot(_65, _65);
    _27 = sqrt(_27);
    _76 = _27 / _49_m8;
    _76 = (-_76) + 1.0f;
    _76 = clamp(_76, 0.0f, 1.0f);
    _89 = (_49_m7 * 0.89999997615814208984375f) + 0.550000011920928955078125f;
    _27 = max(_27, 0.001000000047497451305389404296875f);
    _65 /= _27.xxx;
    _27 = dot(_9, _65);
    _27 = (_27 * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _27 = clamp(_27, 0.0f, 1.0f);
    _65.x = (_9.y * 0.5f) + 0.5f;
    _65.x = clamp(_65.x, 0.0f, 1.0f);
    _65.x = (_65.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _131 = _27.xxx * _49_m3.xyz;
    _131 = _27.xxx * _131;
    _131 = _76.xxx * _131;
    _131 = _89.xxx * _131;
    _131 *= 0.64999997615814208984375f.xxx;
    _65 = (_49_m2.xyz * _65.xxx) + _131;
    _9.x = dot(_9, _42);
    _9.x = min(abs(_9.x), 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _179 = _9.x * _9.x;
    _9.x = _179 * _9.x;
    _9 = _9.xxx * _49_m3.xyz;
    _9 = (_9 * 0.300000011920928955078125f.xxx) + _65;
    _201 = vs_TEXCOORD4.y * 13.0f;
    float2 _219 = (vs_TEXCOORD0 * _49_m5.xx) + _201.xx;
    _42 = float3(_219.x, _219.y, _42.z);
    float2 _224 = floor(_42.xy);
    _65 = float3(_224.x, _224.y, _65.z);
    float2 _229 = frac(_42.xy);
    _42 = float3(_229.x, _229.y, _42.z);
    _131.x = 8.0f;
    _131.y = 8.0f;
    float _336;
    float2 _352;
    for (int _236 = -1; _236 <= 1; _236++)
    {
        _246.y = float(_236);
        _251 = _131.yx;
        for (int _254 = -1; _254 <= 1; _254++)
        {
            _246.x = float(_254);
            _265 = _65.xy + _246.xy;
            _271 = dot(_265, float2(127.09999847412109375f, 311.70001220703125f));
            _265.x = dot(_265, float2(269.5f, 183.3000030517578125f));
            _283.x = sin(_271);
            _283.y = sin(_265.x);
            _265 = _283.xy * 43758.546875f.xx;
            _265 = frac(_265);
            float2 _301 = _265 + _246.xy;
            _246 = float3(_301.x, _246.y, _301.y);
            float2 _309 = (-_42.xy) + _246.xz;
            _246 = float3(_309.x, _246.y, _309.y);
            _283.x = dot(_246.xz, _246.xz);
            bool2 _328 = bool4(_283.xxxx.x < _251.xxyx.x, _283.xxxx.y < _251.xxyx.y, _283.xxxx.z < _251.xxyx.z, _283.xxxx.w < _251.xxyx.w).xz;
            _320 = bool3(_328.x, _320.y, _328.y);
            if (_320.z)
            {
                _336 = _283.x;
            }
            else
            {
                _336 = _251.y;
            }
            _283.z = _336;
            _283.y = _251.x;
            if (_320.x)
            {
                _352 = _283.xy;
            }
            else
            {
                _352 = _283.yz;
            }
            _251 = _352;
        }
        _131 = float3(_251.yx.x, _251.yx.y, _131.z);
    }
    float2 _371 = sqrt(_131.xy);
    _42 = float3(_371.x, _371.y, _42.z);
    _27 = (-_42.y) + _42.x;
    _42.x = ddx_coarse(_27);
    _383.x = ddy_coarse(_27);
    _42.x = abs(_383.x) + abs(_42.x);
    _383.x = (-_42.x) + _49_m6;
    _42.x += _49_m6;
    _42.x = (-_383.x) + _42.x;
    _27 += (-_383.x);
    _42.x = 1.0f / _42.x;
    _27 *= _42.x;
    _27 = clamp(_27, 0.0f, 1.0f);
    _42.x = (_27 * (-2.0f)) + 3.0f;
    _27 *= _27;
    _27 = ((-_42.x) * _27) + 1.0f;
    _42 = _27.xxx * _49_m3.xyz;
    _27 = (_76 * 0.75f) + 0.25f;
    _42 = _27.xxx * _42;
    _9 = (_42 * _89.xxx) + _9;
    _201 = vs_TEXCOORD4.x + (-0.800000011920928955078125f);
    _201 *= 5.000000476837158203125f;
    _201 = clamp(_201, 0.0f, 1.0f);
    _476 = (_201 * (-2.0f)) + 3.0f;
    _201 *= _201;
    _201 *= _476;
    _27 = (_89 * 0.300000011920928955078125f) + 0.699999988079071044921875f;
    _42.x = _201 * 0.85000002384185791015625f;
    _383 = (_49_m4.xyz * _27.xxx) + (-_9);
    _9 = (_42.xxx * _383) + _9;
    _27 = vs_TEXCOORD5;
    _27 = clamp(_27, 0.0f, 1.0f);
    _9 += (-_49_m1.xyz);
    _9 = (_27.xxx * _9) + _49_m1.xyz;
    _528 = float4(_9.x, _9.y, _9.z, _528.w);
    _528.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._528 = _528;
    return stage_output;
}

#endif
#elif defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4 _ProjectionParams;
float4x4 unity_ObjectToWorld;
static float4 _57_m2[4];
float4x4 unity_WorldToObject;
static float4 _57_m3[4];
float4x4 unity_MatrixVP;
static float4 _57_m4[4];
float4 unity_FogParams;
float _Drift;
float _SurgeOpen;
float _Surge;
void __unity_init()
{
    _57_m2[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _57_m2[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _57_m2[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _57_m2[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _57_m3[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _57_m3[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _57_m3[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _57_m3[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _57_m4[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _57_m4[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _57_m4[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _57_m4[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _57_m0 _Time
#define _57_m1 _ProjectionParams
#define _57_m5 unity_FogParams
#define _57_m6 _Drift
#define _57_m7 _SurgeOpen
#define _57_m8 _Surge



static float4 gl_Position;
static float3 _12;
static float4 _41;
static float4 _174;
static float3 vs_TEXCOORD1;
static float vs_TEXCOORD5;
static float2 vs_TEXCOORD0;
static float2 _334;
static float3 _338;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _174 : POSITION;
    float3 _338 : NORMAL;
    float4 _41 : COLOR;
    float2 _334 : TEXCOORD0;
    float3 _12 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _39;
static float _74;
static float3 _85;
static float3 _111;
static float2 _188;
static float4 _194;
static float3 _214;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_12.xy, _12.xy);
    _9.x = sqrt(_9.x);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    float2 _36 = _12.xy / _9.xx;
    _9 = float4(_36.x, _36.y, _9.z, _9.w);
    float3 _48 = _41.yyy * float3(11.0f, 6.283100128173828125f, 4.0f);
    _39 = float4(_48.x, _48.y, _48.z, _39.w);
    float3 _71 = (_57_m0.yyy * float3(0.550000011920928955078125f, 0.89999997615814208984375f, 0.699999988079071044921875f)) + _39.xyz;
    _39 = float4(_71.x, _71.y, _71.z, _39.w);
    _74 = cos(_39.z);
    float2 _81 = sin(_39.xy);
    _39 = float4(_81.x, _81.y, _39.z, _39.w);
    _85.z = _74 * _57_m6;
    _39.z = 0.0f;
    _39.w = 0.5f;
    float2 _108 = float2(float2(float2(_57_m6, _57_m6)));
    _85 = float3(_108.x, _108.y, _85.z);
    _111 = _39.zyw * _85;
    _74 = _57_m7 * _57_m8;
    float2 _128 = _41.yy + float2(-0.5f, 0.60000002384185791015625f);
    _85 = float3(_128.x, _128.y, _85.z);
    _74 *= _85.y;
    _85.x *= _57_m8;
    _85.x *= 0.25f;
    _39.x = (_39.x * 0.0500000007450580596923828125f) + _85.x;
    _85.x = cos(_39.x);
    _39.x = sin(_39.x);
    _9.z = 0.3499999940395355224609375f;
    float3 _171 = (_9.xyz * _74.xxx) + _111;
    _9 = float4(_171.x, _171.y, _171.z, _9.w);
    _111 = float3(_174.yx.x, _174.yx.y, _111.z);
    float2 _184 = _111.xy + (-_12.yx);
    _111 = float3(_184.x, _184.y, _111.z);
    _188 = _39.xx * _111.xy;
    _194.x = (_111.y * _85.x) + (-_188.x);
    _194.y = (_111.x * _85.x) + _188.y;
    _214 = float3(_12.xy.x, _12.xy.y, _214.z);
    _214.z = _174.z;
    _194.z = 0.0f;
    _111 = _194.xyz + _214;
    float3 _231 = _9.xyz + _111;
    _9 = float4(_231.x, _231.y, _231.z, _9.w);
    _194 = _9.yyyy * _57_m2[1];
    _194 = (_57_m2[0] * _9.xxxx) + _194;
    _9 = (_57_m2[2] * _9.zzzz) + _194;
    _9 += _57_m2[3];
    _194 = _9.yyyy * _57_m4[1];
    _194 = (_57_m4[0] * _9.xxxx) + _194;
    _194 = (_57_m4[2] * _9.zzzz) + _194;
    _194 = (_57_m4[3] * _9.wwww) + _194;
    vs_TEXCOORD1 = _9.xyz;
    gl_Position = _194;
    _9.x = _194.z / _57_m1.y;
    _9.x = (-_9.x) + 1.0f;
    _9.x *= _57_m1.z;
    _9.x = max(_9.x, 0.0f);
    vs_TEXCOORD5 = (_9.x * _57_m5.z) + _57_m5.w;
    vs_TEXCOORD0 = _334;
    float2 _341 = _39.xx * _338.yx;
    _9 = float4(_341.x, _341.y, _9.z, _9.w);
    _39.x = (_338.x * _85.x) + (-_9.x);
    _39.y = (_338.y * _85.x) + _9.y;
    _39.z = _338.z;
    _9.x = dot(_39.xyz, _57_m3[0].xyz);
    _9.y = dot(_39.xyz, _57_m3[1].xyz);
    _9.z = dot(_39.xyz, _57_m3[2].xyz);
    _74 = dot(_9.xyz, _9.xyz);
    _74 = rsqrt(_74);
    vs_TEXCOORD2 = _74.xxx * _9.xyz;
    vs_TEXCOORD3 = _57_m2[3].xyz;
    vs_TEXCOORD4 = _41.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _41 = stage_input._41;
    _174 = stage_input._174;
    _334 = stage_input._334;
    _338 = stage_input._338;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD5 = vs_TEXCOORD5;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 unity_FogColor;
float4 _BaseColor;
float4 _GlowColor;
float4 _EdgeColor;
float _CrackScale;
float _CrackWidth;
float _Surge;
float _CoreRadius;
#define _49_m0 _WorldSpaceCameraPos
#define _49_m1 unity_FogColor
#define _49_m2 _BaseColor
#define _49_m3 _GlowColor
#define _49_m4 _EdgeColor
#define _49_m5 _CrackScale
#define _49_m6 _CrackWidth
#define _49_m7 _Surge
#define _49_m8 _CoreRadius



static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float vs_TEXCOORD5;
static float4 _528;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float vs_TEXCOORD5 : TEXCOORD3;
    float3 vs_TEXCOORD2 : TEXCOORD4;
    float3 vs_TEXCOORD3 : TEXCOORD5;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _528 : SV_Target0;
};

static float3 _9;
static float _27;
static float3 _42;
static float3 _65;
static float _76;
static float _89;
static float3 _131;
static float _179;
static float _201;
static float3 _246;
static float2 _251;
static float2 _265;
static float _271;
static float3 _283;
static bool3 _320;
static float3 _383;
static float _476;
static int _547;
static bool _548;
static bool _549;
static int _550;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD2;
    _27 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    _9 = _27.xxx * _9;
    _42 = (-vs_TEXCOORD1) + _49_m0;
    _27 = dot(_42, _42);
    _27 = rsqrt(_27);
    _42 = _27.xxx * _42;
    _65 = (-vs_TEXCOORD1) + vs_TEXCOORD3;
    _27 = dot(_65, _65);
    _27 = sqrt(_27);
    _76 = _27 / _49_m8;
    _76 = (-_76) + 1.0f;
    _76 = clamp(_76, 0.0f, 1.0f);
    _89 = (_49_m7 * 0.89999997615814208984375f) + 0.550000011920928955078125f;
    _27 = max(_27, 0.001000000047497451305389404296875f);
    _65 /= _27.xxx;
    _27 = dot(_9, _65);
    _27 = (_27 * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _27 = clamp(_27, 0.0f, 1.0f);
    _65.x = (_9.y * 0.5f) + 0.5f;
    _65.x = clamp(_65.x, 0.0f, 1.0f);
    _65.x = (_65.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _131 = _27.xxx * _49_m3.xyz;
    _131 = _27.xxx * _131;
    _131 = _76.xxx * _131;
    _131 = _89.xxx * _131;
    _131 *= 0.64999997615814208984375f.xxx;
    _65 = (_49_m2.xyz * _65.xxx) + _131;
    _9.x = dot(_9, _42);
    _9.x = min(abs(_9.x), 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _179 = _9.x * _9.x;
    _9.x = _179 * _9.x;
    _9 = _9.xxx * _49_m3.xyz;
    _9 = (_9 * 0.300000011920928955078125f.xxx) + _65;
    _201 = vs_TEXCOORD4.y * 13.0f;
    float2 _219 = (vs_TEXCOORD0 * _49_m5.xx) + _201.xx;
    _42 = float3(_219.x, _219.y, _42.z);
    float2 _224 = floor(_42.xy);
    _65 = float3(_224.x, _224.y, _65.z);
    float2 _229 = frac(_42.xy);
    _42 = float3(_229.x, _229.y, _42.z);
    _131.x = 8.0f;
    _131.y = 8.0f;
    float _336;
    float2 _352;
    for (int _236 = -1; _236 <= 1; _236++)
    {
        _246.y = float(_236);
        _251 = _131.yx;
        for (int _254 = -1; _254 <= 1; _254++)
        {
            _246.x = float(_254);
            _265 = _65.xy + _246.xy;
            _271 = dot(_265, float2(127.09999847412109375f, 311.70001220703125f));
            _265.x = dot(_265, float2(269.5f, 183.3000030517578125f));
            _283.x = sin(_271);
            _283.y = sin(_265.x);
            _265 = _283.xy * 43758.546875f.xx;
            _265 = frac(_265);
            float2 _301 = _265 + _246.xy;
            _246 = float3(_301.x, _246.y, _301.y);
            float2 _309 = (-_42.xy) + _246.xz;
            _246 = float3(_309.x, _246.y, _309.y);
            _283.x = dot(_246.xz, _246.xz);
            bool2 _328 = bool4(_283.xxxx.x < _251.xxyx.x, _283.xxxx.y < _251.xxyx.y, _283.xxxx.z < _251.xxyx.z, _283.xxxx.w < _251.xxyx.w).xz;
            _320 = bool3(_328.x, _320.y, _328.y);
            if (_320.z)
            {
                _336 = _283.x;
            }
            else
            {
                _336 = _251.y;
            }
            _283.z = _336;
            _283.y = _251.x;
            if (_320.x)
            {
                _352 = _283.xy;
            }
            else
            {
                _352 = _283.yz;
            }
            _251 = _352;
        }
        _131 = float3(_251.yx.x, _251.yx.y, _131.z);
    }
    float2 _371 = sqrt(_131.xy);
    _42 = float3(_371.x, _371.y, _42.z);
    _27 = (-_42.y) + _42.x;
    _42.x = ddx_coarse(_27);
    _383.x = ddy_coarse(_27);
    _42.x = abs(_383.x) + abs(_42.x);
    _383.x = (-_42.x) + _49_m6;
    _42.x += _49_m6;
    _42.x = (-_383.x) + _42.x;
    _27 += (-_383.x);
    _42.x = 1.0f / _42.x;
    _27 *= _42.x;
    _27 = clamp(_27, 0.0f, 1.0f);
    _42.x = (_27 * (-2.0f)) + 3.0f;
    _27 *= _27;
    _27 = ((-_42.x) * _27) + 1.0f;
    _42 = _27.xxx * _49_m3.xyz;
    _27 = (_76 * 0.75f) + 0.25f;
    _42 = _27.xxx * _42;
    _9 = (_42 * _89.xxx) + _9;
    _201 = vs_TEXCOORD4.x + (-0.800000011920928955078125f);
    _201 *= 5.000000476837158203125f;
    _201 = clamp(_201, 0.0f, 1.0f);
    _476 = (_201 * (-2.0f)) + 3.0f;
    _201 *= _201;
    _201 *= _476;
    _27 = (_89 * 0.300000011920928955078125f) + 0.699999988079071044921875f;
    _42.x = _201 * 0.85000002384185791015625f;
    _383 = (_49_m4.xyz * _27.xxx) + (-_9);
    _9 = (_42.xxx * _383) + _9;
    _27 = vs_TEXCOORD5;
    _27 = clamp(_27, 0.0f, 1.0f);
    _9 += (-_49_m1.xyz);
    _9 = (_27.xxx * _9) + _49_m1.xyz;
    _528 = float4(_9.x, _9.y, _9.z, _528.w);
    _528.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    vs_TEXCOORD5 = stage_input.vs_TEXCOORD5;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._528 = _528;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
float4 _Time;
float4x4 unity_ObjectToWorld;
static float4 _57_m1[4];
float4x4 unity_WorldToObject;
static float4 _57_m2[4];
float4x4 unity_MatrixVP;
static float4 _57_m3[4];
float _Drift;
float _SurgeOpen;
float _Surge;
void __unity_init()
{
    _57_m1[0] = float4(unity_ObjectToWorld[0][0], unity_ObjectToWorld[1][0], unity_ObjectToWorld[2][0], unity_ObjectToWorld[3][0]);
    _57_m1[1] = float4(unity_ObjectToWorld[0][1], unity_ObjectToWorld[1][1], unity_ObjectToWorld[2][1], unity_ObjectToWorld[3][1]);
    _57_m1[2] = float4(unity_ObjectToWorld[0][2], unity_ObjectToWorld[1][2], unity_ObjectToWorld[2][2], unity_ObjectToWorld[3][2]);
    _57_m1[3] = float4(unity_ObjectToWorld[0][3], unity_ObjectToWorld[1][3], unity_ObjectToWorld[2][3], unity_ObjectToWorld[3][3]);
    _57_m2[0] = float4(unity_WorldToObject[0][0], unity_WorldToObject[1][0], unity_WorldToObject[2][0], unity_WorldToObject[3][0]);
    _57_m2[1] = float4(unity_WorldToObject[0][1], unity_WorldToObject[1][1], unity_WorldToObject[2][1], unity_WorldToObject[3][1]);
    _57_m2[2] = float4(unity_WorldToObject[0][2], unity_WorldToObject[1][2], unity_WorldToObject[2][2], unity_WorldToObject[3][2]);
    _57_m2[3] = float4(unity_WorldToObject[0][3], unity_WorldToObject[1][3], unity_WorldToObject[2][3], unity_WorldToObject[3][3]);
    _57_m3[0] = float4(unity_MatrixVP[0][0], unity_MatrixVP[1][0], unity_MatrixVP[2][0], unity_MatrixVP[3][0]);
    _57_m3[1] = float4(unity_MatrixVP[0][1], unity_MatrixVP[1][1], unity_MatrixVP[2][1], unity_MatrixVP[3][1]);
    _57_m3[2] = float4(unity_MatrixVP[0][2], unity_MatrixVP[1][2], unity_MatrixVP[2][2], unity_MatrixVP[3][2]);
    _57_m3[3] = float4(unity_MatrixVP[0][3], unity_MatrixVP[1][3], unity_MatrixVP[2][3], unity_MatrixVP[3][3]);
}
#define _57_m0 _Time
#define _57_m4 _Drift
#define _57_m5 _SurgeOpen
#define _57_m6 _Surge



static float4 gl_Position;
static float3 _12;
static float4 _41;
static float4 _174;
static float3 vs_TEXCOORD1;
static float2 vs_TEXCOORD0;
static float2 _299;
static float3 _303;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;

struct SPIRV_Cross_Input
{
    float4 _174 : POSITION;
    float3 _303 : NORMAL;
    float4 _41 : COLOR;
    float2 _299 : TEXCOORD0;
    float3 _12 : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _39;
static float _74;
static float3 _85;
static float3 _111;
static float2 _188;
static float4 _194;
static float3 _214;

void vert_inner()
{
    __unity_init();
    _9.x = dot(_12.xy, _12.xy);
    _9.x = sqrt(_9.x);
    _9.x = max(_9.x, 0.001000000047497451305389404296875f);
    float2 _36 = _12.xy / _9.xx;
    _9 = float4(_36.x, _36.y, _9.z, _9.w);
    float3 _48 = _41.yyy * float3(11.0f, 6.283100128173828125f, 4.0f);
    _39 = float4(_48.x, _48.y, _48.z, _39.w);
    float3 _71 = (_57_m0.yyy * float3(0.550000011920928955078125f, 0.89999997615814208984375f, 0.699999988079071044921875f)) + _39.xyz;
    _39 = float4(_71.x, _71.y, _71.z, _39.w);
    _74 = cos(_39.z);
    float2 _81 = sin(_39.xy);
    _39 = float4(_81.x, _81.y, _39.z, _39.w);
    _85.z = _74 * _57_m4;
    _39.z = 0.0f;
    _39.w = 0.5f;
    float2 _108 = float2(float2(float2(_57_m4, _57_m4)));
    _85 = float3(_108.x, _108.y, _85.z);
    _111 = _39.zyw * _85;
    _74 = _57_m5 * _57_m6;
    float2 _128 = _41.yy + float2(-0.5f, 0.60000002384185791015625f);
    _85 = float3(_128.x, _128.y, _85.z);
    _74 *= _85.y;
    _85.x *= _57_m6;
    _85.x *= 0.25f;
    _39.x = (_39.x * 0.0500000007450580596923828125f) + _85.x;
    _85.x = cos(_39.x);
    _39.x = sin(_39.x);
    _9.z = 0.3499999940395355224609375f;
    float3 _171 = (_9.xyz * _74.xxx) + _111;
    _9 = float4(_171.x, _171.y, _171.z, _9.w);
    _111 = float3(_174.yx.x, _174.yx.y, _111.z);
    float2 _184 = _111.xy + (-_12.yx);
    _111 = float3(_184.x, _184.y, _111.z);
    _188 = _39.xx * _111.xy;
    _194.x = (_111.y * _85.x) + (-_188.x);
    _194.y = (_111.x * _85.x) + _188.y;
    _214 = float3(_12.xy.x, _12.xy.y, _214.z);
    _214.z = _174.z;
    _194.z = 0.0f;
    _111 = _194.xyz + _214;
    float3 _231 = _9.xyz + _111;
    _9 = float4(_231.x, _231.y, _231.z, _9.w);
    _194 = _9.yyyy * _57_m1[1];
    _194 = (_57_m1[0] * _9.xxxx) + _194;
    _9 = (_57_m1[2] * _9.zzzz) + _194;
    _9 += _57_m1[3];
    _194 = _9.yyyy * _57_m3[1];
    _194 = (_57_m3[0] * _9.xxxx) + _194;
    _194 = (_57_m3[2] * _9.zzzz) + _194;
    gl_Position = (_57_m3[3] * _9.wwww) + _194;
    vs_TEXCOORD1 = _9.xyz;
    vs_TEXCOORD0 = _299;
    float2 _306 = _39.xx * _303.yx;
    _9 = float4(_306.x, _306.y, _9.z, _9.w);
    _39.x = (_303.x * _85.x) + (-_9.x);
    _39.y = (_303.y * _85.x) + _9.y;
    _39.z = _303.z;
    _9.x = dot(_39.xyz, _57_m2[0].xyz);
    _9.y = dot(_39.xyz, _57_m2[1].xyz);
    _9.z = dot(_39.xyz, _57_m2[2].xyz);
    _74 = dot(_9.xyz, _9.xyz);
    _74 = rsqrt(_74);
    vs_TEXCOORD2 = _74.xxx * _9.xyz;
    vs_TEXCOORD3 = _57_m1[3].xyz;
    vs_TEXCOORD4 = _41.xy;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _41 = stage_input._41;
    _174 = stage_input._174;
    _299 = stage_input._299;
    _303 = stage_input._303;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD1 = vs_TEXCOORD1;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    stage_output.vs_TEXCOORD2 = vs_TEXCOORD2;
    stage_output.vs_TEXCOORD3 = vs_TEXCOORD3;
    stage_output.vs_TEXCOORD4 = vs_TEXCOORD4;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
float3 _WorldSpaceCameraPos;
float4 _BaseColor;
float4 _GlowColor;
float4 _EdgeColor;
float _CrackScale;
float _CrackWidth;
float _Surge;
float _CoreRadius;
#define _49_m0 _WorldSpaceCameraPos
#define _49_m1 _BaseColor
#define _49_m2 _GlowColor
#define _49_m3 _EdgeColor
#define _49_m4 _CrackScale
#define _49_m5 _CrackWidth
#define _49_m6 _Surge
#define _49_m7 _CoreRadius



static bool gl_FrontFacing;
static float3 vs_TEXCOORD2;
static float3 vs_TEXCOORD1;
static float3 vs_TEXCOORD3;
static float2 vs_TEXCOORD4;
static float2 vs_TEXCOORD0;
static float4 _509;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float2 vs_TEXCOORD4 : TEXCOORD1;
    float3 vs_TEXCOORD1 : TEXCOORD2;
    float3 vs_TEXCOORD2 : TEXCOORD3;
    float3 vs_TEXCOORD3 : TEXCOORD4;
    bool gl_FrontFacing : SV_IsFrontFace;
};

struct SPIRV_Cross_Output
{
    float4 _509 : SV_Target0;
};

static float3 _9;
static float _27;
static float3 _42;
static float3 _65;
static float _76;
static float _89;
static float3 _131;
static float _179;
static float _201;
static float3 _245;
static float2 _250;
static float2 _264;
static float _270;
static float3 _282;
static bool3 _319;
static float3 _382;
static float _475;
static int _528;
static bool _529;
static bool _530;
static int _531;

void frag_inner()
{
    _9.x = dot(vs_TEXCOORD2, vs_TEXCOORD2);
    _9.x = rsqrt(_9.x);
    _9 = _9.xxx * vs_TEXCOORD2;
    _27 = ((gl_FrontFacing ? 4294967295u : 0u) != 0u) ? 1.0f : (-1.0f);
    _9 = _27.xxx * _9;
    _42 = (-vs_TEXCOORD1) + _49_m0;
    _27 = dot(_42, _42);
    _27 = rsqrt(_27);
    _42 = _27.xxx * _42;
    _65 = (-vs_TEXCOORD1) + vs_TEXCOORD3;
    _27 = dot(_65, _65);
    _27 = sqrt(_27);
    _76 = _27 / _49_m7;
    _76 = (-_76) + 1.0f;
    _76 = clamp(_76, 0.0f, 1.0f);
    _89 = (_49_m6 * 0.89999997615814208984375f) + 0.550000011920928955078125f;
    _27 = max(_27, 0.001000000047497451305389404296875f);
    _65 /= _27.xxx;
    _27 = dot(_9, _65);
    _27 = (_27 * 0.699999988079071044921875f) + 0.300000011920928955078125f;
    _27 = clamp(_27, 0.0f, 1.0f);
    _65.x = (_9.y * 0.5f) + 0.5f;
    _65.x = clamp(_65.x, 0.0f, 1.0f);
    _65.x = (_65.x * 0.449999988079071044921875f) + 0.550000011920928955078125f;
    _131 = _27.xxx * _49_m2.xyz;
    _131 = _27.xxx * _131;
    _131 = _76.xxx * _131;
    _131 = _89.xxx * _131;
    _131 *= 0.64999997615814208984375f.xxx;
    _65 = (_49_m1.xyz * _65.xxx) + _131;
    _9.x = dot(_9, _42);
    _9.x = min(abs(_9.x), 1.0f);
    _9.x = (-_9.x) + 1.0f;
    _179 = _9.x * _9.x;
    _9.x = _179 * _9.x;
    _9 = _9.xxx * _49_m2.xyz;
    _9 = (_9 * 0.300000011920928955078125f.xxx) + _65;
    _201 = vs_TEXCOORD4.y * 13.0f;
    float2 _219 = (vs_TEXCOORD0 * _49_m4.xx) + _201.xx;
    _42 = float3(_219.x, _219.y, _42.z);
    float2 _224 = floor(_42.xy);
    _65 = float3(_224.x, _224.y, _65.z);
    float2 _229 = frac(_42.xy);
    _42 = float3(_229.x, _229.y, _42.z);
    _131.x = 8.0f;
    _131.y = 8.0f;
    float _335;
    float2 _351;
    for (int _236 = -1; _236 <= 1; _236++)
    {
        _245.y = float(_236);
        _250 = _131.yx;
        for (int _253 = -1; _253 <= 1; _253++)
        {
            _245.x = float(_253);
            _264 = _65.xy + _245.xy;
            _270 = dot(_264, float2(127.09999847412109375f, 311.70001220703125f));
            _264.x = dot(_264, float2(269.5f, 183.3000030517578125f));
            _282.x = sin(_270);
            _282.y = sin(_264.x);
            _264 = _282.xy * 43758.546875f.xx;
            _264 = frac(_264);
            float2 _300 = _264 + _245.xy;
            _245 = float3(_300.x, _245.y, _300.y);
            float2 _308 = (-_42.xy) + _245.xz;
            _245 = float3(_308.x, _245.y, _308.y);
            _282.x = dot(_245.xz, _245.xz);
            bool2 _327 = bool4(_282.xxxx.x < _250.xxyx.x, _282.xxxx.y < _250.xxyx.y, _282.xxxx.z < _250.xxyx.z, _282.xxxx.w < _250.xxyx.w).xz;
            _319 = bool3(_327.x, _319.y, _327.y);
            if (_319.z)
            {
                _335 = _282.x;
            }
            else
            {
                _335 = _250.y;
            }
            _282.z = _335;
            _282.y = _250.x;
            if (_319.x)
            {
                _351 = _282.xy;
            }
            else
            {
                _351 = _282.yz;
            }
            _250 = _351;
        }
        _131 = float3(_250.yx.x, _250.yx.y, _131.z);
    }
    float2 _370 = sqrt(_131.xy);
    _42 = float3(_370.x, _370.y, _42.z);
    _27 = (-_42.y) + _42.x;
    _42.x = ddx_coarse(_27);
    _382.x = ddy_coarse(_27);
    _42.x = abs(_382.x) + abs(_42.x);
    _382.x = (-_42.x) + _49_m5;
    _42.x += _49_m5;
    _42.x = (-_382.x) + _42.x;
    _27 += (-_382.x);
    _42.x = 1.0f / _42.x;
    _27 *= _42.x;
    _27 = clamp(_27, 0.0f, 1.0f);
    _42.x = (_27 * (-2.0f)) + 3.0f;
    _27 *= _27;
    _27 = ((-_42.x) * _27) + 1.0f;
    _42 = _27.xxx * _49_m2.xyz;
    _27 = (_76 * 0.75f) + 0.25f;
    _42 = _27.xxx * _42;
    _9 = (_42 * _89.xxx) + _9;
    _201 = vs_TEXCOORD4.x + (-0.800000011920928955078125f);
    _201 *= 5.000000476837158203125f;
    _201 = clamp(_201, 0.0f, 1.0f);
    _475 = (_201 * (-2.0f)) + 3.0f;
    _201 *= _201;
    _201 *= _475;
    _27 = (_89 * 0.300000011920928955078125f) + 0.699999988079071044921875f;
    _42.x = _201 * 0.85000002384185791015625f;
    _382 = (_49_m3.xyz * _27.xxx) + (-_9);
    _9 = (_42.xxx * _382) + _9;
    _509 = float4(_9.x, _9.y, _9.z, _509.w);
    _509.w = 1.0f;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    gl_FrontFacing = stage_input.gl_FrontFacing;
    vs_TEXCOORD2 = stage_input.vs_TEXCOORD2;
    vs_TEXCOORD1 = stage_input.vs_TEXCOORD1;
    vs_TEXCOORD3 = stage_input.vs_TEXCOORD3;
    vs_TEXCOORD4 = stage_input.vs_TEXCOORD4;
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._509 = _509;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}