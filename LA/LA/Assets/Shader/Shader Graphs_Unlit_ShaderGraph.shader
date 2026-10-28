// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Shader Graphs/Unlit_ShaderGraph" {
Properties {

_BaseColor ("_BaseColor", Color) = (0,0,0,0)

_BUILTIN_Surface ("Float", Float) = 0.0

_BUILTIN_Blend ("Float", Float) = 0.0

_BUILTIN_AlphaClip ("Float", Float) = 0.0

_BUILTIN_SrcBlend ("Float", Float) = 1.0

_BUILTIN_DstBlend ("Float", Float) = 0.0

_BUILTIN_ZWrite ("Float", Float) = 1.0

_BUILTIN_ZWriteControl ("Float", Float) = 0.0

_BUILTIN_ZTest ("Float", Float) = 4.0

_BUILTIN_CullMode ("Float", Float) = 2.0

_BUILTIN_QueueOffset ("Float", Float) = 0.0

_BUILTIN_QueueControl ("Float", Float) = -1.0

}
SubShader {
 Tags { "BuiltInMaterialType" = "Unlit" "QUEUE" = "Geometry" "RenderType" = "Opaque" "ShaderGraphShader" = "true" "ShaderGraphTargetId" = "BuiltInUnlitSubTarget" }
 Pass {
 Name "Pass"
  Tags { "BuiltInMaterialType" = "Unlit" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" "ShaderGraphShader" = "true" "ShaderGraphTargetId" = "BuiltInUnlitSubTarget" }
 ZTest [_BUILTIN_ZTest]
 ZWrite [_BUILTIN_ZWrite]
 Cull [_BUILTIN_CullMode]
   Blend [_BUILTIN_SrcBlend] [_BUILTIN_DstBlend]
 ZTest [_BUILTIN_ZTest]
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile_fog
#pragma multi_compile __ DIRECTIONAL
#pragma multi_compile __ DIRLIGHTMAP_COMBINED
#pragma multi_compile __ LIGHTMAP_ON
#pragma multi_compile __ LIGHTPROBE_SH
#pragma multi_compile __ SHADOWS_SCREEN
#pragma multi_compile __ VERTEXLIGHT_ON
#if defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_EXP2) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(DIRLIGHTMAP_COMBINED) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(SHADOWS_SCREEN) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_EXP2)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(FOG_LINEAR)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTMAP_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(LIGHTPROBE_SH)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(SHADOWS_SCREEN)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#elif defined(DIRECTIONAL) && defined(VERTEXLIGHT_ON)
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
static float4 _21_m0[4];
static float4 _21_m1[4];
static float4 _21_m2;
static float4 _21_m3;
static float4 _21_m4;
static float4 _73_m0;
static float4 _73_m1;
static float4 _73_m2;
static float4 _73_m3;
static float4 _73_m4;
static float4 _73_m5[4];
static float4 _73_m6[4];
static float4 _73_m7[4];
static float4 _73_m8[4];
static int _73_m9;
static float4 _73_m10;






static float4 gl_Position;
static float3 _12;

struct SPIRV_Cross_Input
{
    float3 _12 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float4 _64;

void vert_inner()
{
    float3 _29 = _12.yyy * _21_m0[1].xyz;
    _9 = float4(_29.x, _29.y, _29.z, _9.w);
    float3 _40 = (_21_m0[0].xyz * _12.xxx) + _9.xyz;
    _9 = float4(_40.x, _40.y, _40.z, _9.w);
    float3 _52 = (_21_m0[2].xyz * _12.zzz) + _9.xyz;
    _9 = float4(_52.x, _52.y, _52.z, _9.w);
    float3 _61 = _9.xyz + _21_m0[3].xyz;
    _9 = float4(_61.x, _61.y, _61.z, _9.w);
    _64 = _9.yyyy * _73_m8[1];
    _64 = (_73_m8[0] * _9.xxxx) + _64;
    _9 = (_73_m8[2] * _9.zzzz) + _64;
    gl_Position = _9 + _73_m8[3];
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)
static float4 _12_m0;




static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = float4(_12_m0.xyz.x, _12_m0.xyz.y, _12_m0.xyz.z, _9.w);
    _9.w = 1.0f;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
 Pass {
ZWrite On
 Name "ShadowCaster"
  Tags { "BuiltInMaterialType" = "Unlit" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Geometry" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" "ShaderGraphShader" = "true" "ShaderGraphTargetId" = "BuiltInUnlitSubTarget" }
 Cull [_BUILTIN_CullMode]
   Blend [_BUILTIN_SrcBlend] [_BUILTIN_DstBlend]
 ColorMask 0
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#pragma multi_compile __ SHADOWS_CUBE
#pragma multi_compile __ SHADOWS_DEPTH
#pragma multi_compile_local __ _CASTING_PUNCTUAL_LIGHT_SHADOW
#if defined(SHADOWS_DEPTH) && defined(_CASTING_PUNCTUAL_LIGHT_SHADOW)
#if defined(SHADER_STAGE_VERTEX)
static float4 _20_m0[4];
static float4 _20_m1[4];
static float4 _20_m2;
static float4 _20_m3;
static float4 _20_m4;
static float4 _99_m0;
static float4 _99_m1;
static float4 _99_m2;
static float4 _99_m3;
static float4 _99_m4;
static float4 _99_m5;
static float4 _99_m6;
static float4 _99_m7[8];
static float4 _99_m8[8];
static float4 _99_m9[8];
static float4 _99_m10[8];
static float4 _99_m11;
static float4 _99_m12;
static float4 _99_m13;
static float4 _99_m14;
static float4 _99_m15;
static float4 _99_m16;
static float4 _99_m17;
static float4 _99_m18;
static float4 _99_m19;
static float4 _143_m0[4];
static float4 _143_m1;
static float4 _143_m2;
static float4 _143_m3;
static float4 _143_m4;
static float4 _143_m5[16];
static float4 _143_m6;
static float4 _143_m7;
static float4 _187_m0;
static float4 _187_m1;
static float4 _187_m2;
static float4 _187_m3;
static float4 _187_m4;
static float4 _187_m5[4];
static float4 _187_m6[4];
static float4 _187_m7[4];
static float4 _187_m8[4];
static int _187_m9;
static float4 _187_m10;










static float4 gl_Position;
static float3 _12;
static float3 _63;

struct SPIRV_Cross_Input
{
    float3 _63 : POSITION;
    float3 _12 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float _47;
static float4 _62;
static float4 _88;
static bool _161;
static float _229;

void vert_inner()
{
    _9.x = dot(_12, _20_m1[0].xyz);
    _9.y = dot(_12, _20_m1[1].xyz);
    _9.z = dot(_12, _20_m1[2].xyz);
    _47 = dot(_9.xyz, _9.xyz);
    _47 = rsqrt(_47);
    float3 _59 = _47.xxx * _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _63.yyyy * _20_m0[1];
    _62 = (_20_m0[0] * _63.xxxx) + _62;
    _62 = (_20_m0[2] * _63.zzzz) + _62;
    _62 += _20_m0[3];
    float3 _107 = ((-_62.xyz) * _99_m0.www) + _99_m0.xyz;
    _88 = float4(_107.x, _107.y, _107.z, _88.w);
    _47 = dot(_88.xyz, _88.xyz);
    _47 = rsqrt(_47);
    float3 _121 = _47.xxx * _88.xyz;
    _88 = float4(_121.x, _121.y, _121.z, _88.w);
    _47 = dot(_9.xyz, _88.xyz);
    _47 = ((-_47) * _47) + 1.0f;
    _47 = sqrt(_47);
    _47 *= _143_m2.z;
    float3 _156 = ((-_9.xyz) * _47.xxx) + _62.xyz;
    _9 = float4(_156.x, _156.y, _156.z, _9.w);
    _161 = _143_m2.z != 0.0f;
    float3 _168;
    if (_161)
    {
        _168 = _9.xyz;
    }
    else
    {
        _168 = _62.xyz;
    }
    _9 = float4(_168.x, _168.y, _168.z, _9.w);
    _88 = _9.yyyy * _187_m8[1];
    _88 = (_187_m8[0] * _9.xxxx) + _88;
    _9 = (_187_m8[2] * _9.zzzz) + _88;
    _9 = (_187_m8[3] * _62.wwww) + _9;
    _62.x = _143_m2.x / _9.w;
    _62.x = min(_62.x, 0.0f);
    _62.x = max(_62.x, -1.0f);
    _229 = _9.z + _62.x;
    _62.x = min(_9.w, _229);
    gl_Position = float4(_9.xyw.x, _9.xyw.y, gl_Position.z, _9.xyw.z);
    _9.x = (-_229) + _62.x;
    gl_Position.z = (_143_m2.y * _9.x) + _229;
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _63 = stage_input._63;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#else
#if defined(SHADER_STAGE_VERTEX)
static float4 _20_m0[4];
static float4 _20_m1[4];
static float4 _20_m2;
static float4 _20_m3;
static float4 _20_m4;
static float4 _99_m0;
static float4 _99_m1;
static float4 _99_m2;
static float4 _99_m3;
static float4 _99_m4;
static float4 _99_m5;
static float4 _99_m6;
static float4 _99_m7[8];
static float4 _99_m8[8];
static float4 _99_m9[8];
static float4 _99_m10[8];
static float4 _99_m11;
static float4 _99_m12;
static float4 _99_m13;
static float4 _99_m14;
static float4 _99_m15;
static float4 _99_m16;
static float4 _99_m17;
static float4 _99_m18;
static float4 _99_m19;
static float4 _143_m0[4];
static float4 _143_m1;
static float4 _143_m2;
static float4 _143_m3;
static float4 _143_m4;
static float4 _143_m5[16];
static float4 _143_m6;
static float4 _143_m7;
static float4 _187_m0;
static float4 _187_m1;
static float4 _187_m2;
static float4 _187_m3;
static float4 _187_m4;
static float4 _187_m5[4];
static float4 _187_m6[4];
static float4 _187_m7[4];
static float4 _187_m8[4];
static int _187_m9;
static float4 _187_m10;










static float4 gl_Position;
static float3 _12;
static float3 _63;

struct SPIRV_Cross_Input
{
    float3 _63 : POSITION;
    float3 _12 : NORMAL;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

static float4 _9;
static float _47;
static float4 _62;
static float4 _88;
static bool _161;

void vert_inner()
{
    _9.x = dot(_12, _20_m1[0].xyz);
    _9.y = dot(_12, _20_m1[1].xyz);
    _9.z = dot(_12, _20_m1[2].xyz);
    _47 = dot(_9.xyz, _9.xyz);
    _47 = rsqrt(_47);
    float3 _59 = _47.xxx * _9.xyz;
    _9 = float4(_59.x, _59.y, _59.z, _9.w);
    _62 = _63.yyyy * _20_m0[1];
    _62 = (_20_m0[0] * _63.xxxx) + _62;
    _62 = (_20_m0[2] * _63.zzzz) + _62;
    _62 += _20_m0[3];
    float3 _107 = ((-_62.xyz) * _99_m0.www) + _99_m0.xyz;
    _88 = float4(_107.x, _107.y, _107.z, _88.w);
    _47 = dot(_88.xyz, _88.xyz);
    _47 = rsqrt(_47);
    float3 _121 = _47.xxx * _88.xyz;
    _88 = float4(_121.x, _121.y, _121.z, _88.w);
    _47 = dot(_9.xyz, _88.xyz);
    _47 = ((-_47) * _47) + 1.0f;
    _47 = sqrt(_47);
    _47 *= _143_m2.z;
    float3 _156 = ((-_9.xyz) * _47.xxx) + _62.xyz;
    _9 = float4(_156.x, _156.y, _156.z, _9.w);
    _161 = _143_m2.z != 0.0f;
    float3 _168;
    if (_161)
    {
        _168 = _9.xyz;
    }
    else
    {
        _168 = _62.xyz;
    }
    _9 = float4(_168.x, _168.y, _168.z, _9.w);
    _88 = _9.yyyy * _187_m8[1];
    _88 = (_187_m8[0] * _9.xxxx) + _88;
    _9 = (_187_m8[2] * _9.zzzz) + _88;
    _9 = (_187_m8[3] * _62.wwww) + _9;
    _62.x = min(_9.w, _9.z);
    _62.x = (-_9.z) + _62.x;
    gl_Position.z = (_143_m2.y * _62.x) + _9.z;
    gl_Position = float4(_9.xyw.x, _9.xyw.y, gl_Position.z, _9.xyw.z);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _12 = stage_input._12;
    _63 = stage_input._63;
    vert_inner();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    return stage_output;
}

#endif
#if defined(SHADER_STAGE_FRAGMENT)


static float4 _9;

struct SPIRV_Cross_Output
{
    float4 _9 : SV_Target0;
};

void frag_inner()
{
    _9 = 0.0f.xxxx;
}

SPIRV_Cross_Output frag()
{
    frag_inner();
    SPIRV_Cross_Output stage_output;
    stage_output._9 = _9;
    return stage_output;
}

#endif
#endif
ENDHLSL
}
}
FallBack "Hidden/Shader Graph/FallbackError"
CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
}