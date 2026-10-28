// Recovered from the game's compiled Vulkan shader (SPIR-V -> HLSL via SPIRV-Cross).
Shader "Hidden/Slop/Social/Portrait Alpha" {
Properties {

}
SubShader {
 Tags { "QUEUE" = "Overlay" "RenderType" = "Opaque" }
 Pass {
  Tags { "QUEUE" = "Overlay" "RenderType" = "Opaque" }
 ZTest Always
 ZWrite Off
 Cull Off
   ColorMask A
 ZTest Always
HLSLPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 4.5
#if 1
#if defined(SHADER_STAGE_VERTEX)


static float4 gl_Position;
static float4 _17;

struct SPIRV_Cross_Input
{
    float4 _17 : POSITION;
};

struct SPIRV_Cross_Output
{
    float4 gl_Position : SV_Position;
};

void vert_inner()
{
    gl_Position = float4(_17.xy.x, _17.xy.y, gl_Position.z, gl_Position.w);
    gl_Position = float4(gl_Position.x, gl_Position.y, float2(0.5f, 1.0f).x, float2(0.5f, 1.0f).y);
}

SPIRV_Cross_Output vert(SPIRV_Cross_Input stage_input)
{
    _17 = stage_input._17;
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
    _9 = 1.0f.xxxx;
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
}