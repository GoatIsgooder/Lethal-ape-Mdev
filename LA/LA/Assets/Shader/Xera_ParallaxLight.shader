Shader "Xera/ParallaxLight"
{
    Properties
    {
        _OuterAlbedo("Albedo", 2D) = "white" {}
        _OuterNormal("Normal", 2D) = "bump" {}
        _InnerAlbedo("In Alb", 2D) = "white" {}
        _InnerNormal("In Nrm", 2D) = "bump" {}
        _InnerEmissionColor("In EmCol", Color) = (1,1,1,1)
        _InnerEmissionMap("In Em", 2D) = "white" {}
        _InnerEmissionScale("EmSc", Range(0,10)) = 1
        _ParallaxDepth("Depth", Range(0,5)) = 0.05
        _InnerSize("Size", Range(0.01,1)) = 0.5
        _Glossiness("Smooth", Range(0,1)) = 0.5
        _Metallic("Met", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0
        #pragma shader_feature _NORMALMAP _EMISSION

        sampler2D _OuterAlbedo, _OuterNormal, _InnerAlbedo, _InnerNormal, _InnerEmissionMap;
        float _ParallaxDepth, _InnerSize, _InnerEmissionScale, _Glossiness, _Metallic;
        fixed4 _InnerEmissionColor;

        struct Input { float2 uv_OuterAlbedo; float2 uv_InnerAlbedo; float3 viewDir; };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 outer = tex2D(_OuterAlbedo, IN.uv_OuterAlbedo); if(outer.a==0) outer=fixed4(1,1,1,1);
            o.Normal = UnpackNormal(tex2D(_OuterNormal, IN.uv_OuterAlbedo));

            float3 view = normalize(IN.viewDir);
            float depthScale = _ParallaxDepth * clamp(1.0 - abs(view.z), 0.0, 1.0);
            float2 offset = view.xy * depthScale;
            float2 uv = (IN.uv_InnerAlbedo-0.5)/_InnerSize+0.5-offset;
            uv = saturate(uv);

            fixed4 inner = tex2D(_InnerAlbedo, uv);
            fixed4 emis = tex2D(_InnerEmissionMap, uv)*_InnerEmissionColor*_InnerEmissionScale;
            float3 inNorm = UnpackNormal(tex2D(_InnerNormal, uv)).rgb;

            float2 c = uv-0.5;
            float mask = smoothstep(0.5,0.45,abs(c.x)/_InnerSize)*smoothstep(0.5,0.45,abs(c.y)/_InnerSize);

            o.Normal = normalize(lerp(o.Normal, inNorm, mask));
            o.Albedo = lerp(outer.rgb, inner.rgb, mask);
            o.Emission = emis.rgb*mask;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
