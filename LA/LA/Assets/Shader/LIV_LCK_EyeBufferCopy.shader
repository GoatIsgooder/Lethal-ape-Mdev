// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "LIV/LCK/EyeBufferCopy" {
Properties {

_MainTex ("Source", 2DArray) = "" { }

_SliceIndex ("Eye Slice Index", Float) = 0.0

_ScaleOffset ("Scale (xy) Offset (zw)", Vector) = (1,1,0,0)

_SourceScaleOffset ("Source Scale (xy) Offset (zw)", Vector) = (1,1,0,0)

_BlitScaleBias ("Blit Scale (xy) Bias (zw)", Vector) = (1,1,0,0)

_FlipY ("Flip Y", Float) = 1.0

}
SubShader {
 LOD 100
 Tags { "RenderType" = "Opaque" }
 Pass {
 Name "EyeBufferCopy"
  LOD 100
  Tags { "RenderType" = "Opaque" }
 ZTest Always
 ZWrite Off
 Cull Off
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
float _SliceIndex;
float4 _ScaleOffset;
float4 _BlitScaleBias;
float _FlipY;
#define _17_m0 _SliceIndex
#define _17_m1 _ScaleOffset
#define _17_m2 _BlitScaleBias
#define _17_m3 _FlipY


Texture2DArray<float4> _MainTex;
SamplerState sampler_MainTex;

static float2 vs_TEXCOORD0;
static float4 _98;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _98 : SV_Target0;
};

static float3 _9;
static float _32;
static bool3 _55;
static bool2 _67;
static float4 _119;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m1.xy) + _17_m1.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _32 = (_9.y * (-2.0f)) + 1.0f;
    _9.z = (_17_m3 * _32) + _9.y;
    bool2 _63 = bool4(_9.xxzz.x < 0.0f.xxxx.x, _9.xxzz.y < 0.0f.xxxx.y, _9.xxzz.z < 0.0f.xxxx.z, _9.xxzz.w < 0.0f.xxxx.w).xz;
    _55 = bool3(_63.x, _55.y, _63.y);
    _67 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x < _9.xzxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y < _9.xzxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z < _9.xzxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w < _9.xzxx.w).xy;
    _55.x = _55.x || _67.x;
    _55.x = _55.z || _55.x;
    _55.x = _67.y || _55.x;
    if (_55.x)
    {
        _98 = float4(0.0f, 0.0f, 0.0f, 1.0f);
        return;
    }
    float2 _111 = (_9.xz * _17_m2.xy) + _17_m2.zw;
    _9 = float3(_111.x, _111.y, _9.z);
    _9.z = _17_m0;
    _119 = _MainTex.Sample(sampler_MainTex, _9);
    _98 = _119;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._98 = _98;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
 Name "EyeBufferCopy_RenderGraph"
  LOD 100
  Tags { "RenderType" = "Opaque" }
 ZTest Always
 ZWrite Off
 Cull Off
   ZTest Always
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)


static float4 gl_Position;
static int gl_VertexIndex;
static float2 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    uint gl_VertexIndex : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static uint3 _9;
static float2 _29;

uint spvBitfieldInsert(uint Base, uint Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint2 spvBitfieldInsert(uint2 Base, uint2 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint3 spvBitfieldInsert(uint3 Base, uint3 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint4 spvBitfieldInsert(uint4 Base, uint4 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

void vert_inner()
{
    _9.x = uint(int(spvBitfieldInsert(0, gl_VertexIndex, 1, 1)));
    _9.z = uint(gl_VertexIndex) & 2u;
    _29 = float2(_9.xz);
    float2 _46 = (_29 * 2.0f.xx) + (-1.0f).xx;
    gl_Position = float4(_46.x, _46.y, gl_Position.z, gl_Position.w);
    vs_TEXCOORD0 = _29;
    gl_Position = float4(gl_Position.x, gl_Position.y, float2(0.0f, 1.0f).x, float2(0.0f, 1.0f).y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    gl_VertexIndex = int(stage_input.gl_VertexIndex);
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _17_m0;
static float _17_m1;
static float4 _17_m2;
static float4 _17_m3;
static float _17_m4;



Texture2DArray<float4> _BlitTexture;
SamplerState sampler_BlitTexture;

static float2 vs_TEXCOORD0;
static float4 _120;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _120 : SV_Target0;
};

static float3 _9;
static bool _33;
static bool2 _42;
static float _51;
static float _56;
static bool3 _83;
static float4 _141;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m2.xy) + _17_m2.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _33 = _17_m4 < 0.0f;
    _42.x = _17_m0.x < 0.0f;
    _51 = _42.x ? 0.0f : 1.0f;
    float _59;
    if (_33)
    {
        _59 = _51;
    }
    else
    {
        _59 = _17_m4;
    }
    _56 = _59;
    _51 = (_9.y * (-2.0f)) + 1.0f;
    _9.z = (_56 * _51) + _9.y;
    bool2 _89 = bool4(_9.xxzz.x < 0.0f.xxxx.x, _9.xxzz.y < 0.0f.xxxx.y, _9.xxzz.z < 0.0f.xxxx.z, _9.xxzz.w < 0.0f.xxxx.w).xz;
    _83 = bool3(_89.x, _83.y, _89.y);
    _42 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x < _9.xzxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y < _9.xzxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z < _9.xzxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w < _9.xzxx.w).xy;
    _83.x = _83.x || _42.x;
    _83.x = _83.z || _83.x;
    _83.x = _42.y || _83.x;
    if (_83.x)
    {
        _120 = float4(0.0f, 0.0f, 0.0f, 1.0f);
        return;
    }
    float2 _133 = (_9.xz * _17_m3.xy) + _17_m3.zw;
    _9 = float3(_133.x, _133.y, _9.z);
    _9.z = _17_m1;
    _141 = _BlitTexture.Sample(sampler_BlitTexture, _9);
    _120 = _141;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._120 = _120;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
 Name "EyeBufferCopy_2D"
  LOD 100
  Tags { "RenderType" = "Opaque" }
 ZTest Always
 ZWrite Off
 Cull Off
   ZTest Always
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)


static float4 gl_Position;
static int gl_VertexIndex;
static float2 vs_TEXCOORD0;

struct SPIRV_Cross_Input
{
    uint gl_VertexIndex : POSITION;
};

struct SPIRV_Cross_Output
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
    float4 gl_Position : SV_Position;
};

static uint3 _9;
static float2 _29;

uint spvBitfieldInsert(uint Base, uint Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint2 spvBitfieldInsert(uint2 Base, uint2 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint3 spvBitfieldInsert(uint3 Base, uint3 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint4 spvBitfieldInsert(uint4 Base, uint4 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

void vert_inner()
{
    _9.x = uint(int(spvBitfieldInsert(0, gl_VertexIndex, 1, 1)));
    _9.z = uint(gl_VertexIndex) & 2u;
    _29 = float2(_9.xz);
    float2 _46 = (_29 * 2.0f.xx) + (-1.0f).xx;
    gl_Position = float4(_46.x, _46.y, gl_Position.z, gl_Position.w);
    vs_TEXCOORD0 = _29;
    gl_Position = float4(gl_Position.x, gl_Position.y, float2(0.0f, 1.0f).x, float2(0.0f, 1.0f).y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    gl_VertexIndex = int(stage_input.gl_VertexIndex);
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.vs_TEXCOORD0 = vs_TEXCOORD0;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _17_m0;
static float4 _17_m1;
static float4 _17_m2;
static float4 _17_m3;
static float _17_m4;



Texture2D<float4> _BlitTexture;
SamplerState sampler_BlitTexture;

static float2 vs_TEXCOORD0;
static float4 _120;

struct SPIRV_Cross_Input
{
    float2 vs_TEXCOORD0 : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 _120 : SV_Target0;
};

static float3 _9;
static bool _33;
static bool2 _42;
static float _51;
static float _56;
static bool3 _83;
static float4 _150;

void frag_inner()
{
    float2 _28 = (vs_TEXCOORD0 * _17_m1.xy) + _17_m1.zw;
    _9 = float3(_28.x, _28.y, _9.z);
    _33 = _17_m4 < 0.0f;
    _42.x = _17_m0.x < 0.0f;
    _51 = _42.x ? 0.0f : 1.0f;
    float _59;
    if (_33)
    {
        _59 = _51;
    }
    else
    {
        _59 = _17_m4;
    }
    _56 = _59;
    _51 = (_9.y * (-2.0f)) + 1.0f;
    _9.z = (_56 * _51) + _9.y;
    bool2 _89 = bool4(_9.xxzz.x < 0.0f.xxxx.x, _9.xxzz.y < 0.0f.xxxx.y, _9.xxzz.z < 0.0f.xxxx.z, _9.xxzz.w < 0.0f.xxxx.w).xz;
    _83 = bool3(_89.x, _83.y, _89.y);
    _42 = bool4(float4(1.0f, 1.0f, 0.0f, 0.0f).x < _9.xzxx.x, float4(1.0f, 1.0f, 0.0f, 0.0f).y < _9.xzxx.y, float4(1.0f, 1.0f, 0.0f, 0.0f).z < _9.xzxx.z, float4(1.0f, 1.0f, 0.0f, 0.0f).w < _9.xzxx.w).xy;
    _83.x = _83.x || _42.x;
    _83.x = _83.z || _83.x;
    _83.x = _42.y || _83.x;
    if (_83.x)
    {
        _120 = float4(0.0f, 0.0f, 0.0f, 1.0f);
        return;
    }
    float2 _133 = (_9.xz * _17_m2.xy) + _17_m2.zw;
    _9 = float3(_133.x, _133.y, _9.z);
    float2 _146 = (_9.xy * _17_m3.xy) + _17_m3.zw;
    _9 = float3(_146.x, _146.y, _9.z);
    _150 = _BlitTexture.Sample(sampler_BlitTexture, _9.xy);
    _120 = _150;
}

SPIRV_Cross_Output frag(SPIRV_Cross_Input stage_input)
{
    vs_TEXCOORD0 = stage_input.vs_TEXCOORD0;
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._120 = _120;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
}