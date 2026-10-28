Shader "Unlit/WindowSkyCube_WithWorldGround"
{
    Properties
    {
        _SkyTex       ("Sky Cubemap", CUBE) = "" {}
        _SkyIntensity ("SkyIntensity", Range(0,5)) = 1
        _Size         ("Size", Float) = 1
        _T            ("Time", Float) = 1
        _Distortion   ("Distortion", Range(-50,50)) = 0

        _GroundTex    ("Ground Texture", 2D) = "white" {}
        _GroundY      ("Ground Y (world)", Float) = 0
        _GroundScale  ("Ground Scale (tiling)", Float) = 0.1
        _GroundTint   ("Ground Tint (RGBA)", Color) = (1,1,1,1)
        _GroundFadeDist ("Ground Fade Distance", Float) = 100
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv       : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 pos      : SV_POSITION;
                float3 worldPos : TEXCOORD2;
            };

            samplerCUBE _SkyTex;
            float4 _SkyTex_HDR;
            float _Size, _T, _Distortion, _SkyIntensity;

            sampler2D _GroundTex;
            float _GroundY;
            float _GroundScale;
            float4 _GroundTint;
            float _GroundFadeDist;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos      = UnityObjectToClipPos(v.vertex);
                o.uv       = v.uv;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            float N21(float2 p)
            {
                p = frac(p * float2(123.34, 345.45));
                p += dot(p, p + 34.345);
                return frac(p.x * p.y);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // --- existing procedural droplet/trail logic (unchanged) ---
                float t = fmod(_Time.y * 1 + _T, 7200);

                float2 aspect = float2(2, 1);
                float2 uv = i.uv * _Size * aspect;
                uv.y += t * 0.25;
                float2 gv = frac(uv) - 0.5;
                float2 id = floor(uv);

                float n = N21(id);
                t += n * 6.2831;
                float w = i.uv.y * 10;
                float x = (n - 0.5) * 0.8;
                x += (0.4 - abs(x)) * sin(3*w) * pow(sin(w), 6) * 0.45;

                float y = -sin(t + sin(t)*0.5) * 0.45;
                y -= (gv.x - x) * (gv.x - x);

                float2 dropPos = (gv - float2(x, y)) / aspect;
                float drop = smoothstep(0.05, 0.03, length(dropPos));

                float2 trailPos = (gv - float2(x, t * 0.25)) / aspect;
                trailPos.y = (frac(trailPos.y * 8) - 0.5) / 8;
                float trail = smoothstep(0.03, 0.01, length(trailPos));

                float fogTrail = smoothstep(-0.05, 0.05, dropPos.y);
                fogTrail *= smoothstep(0.5, y, gv.y);
                trail *= fogTrail;
                fogTrail *= smoothstep(0.05, 0.04, abs(dropPos.x));

                float2 offs = drop * dropPos + trail * trailPos;

                // --- camera / direction ---
                float3 camPos   = _WorldSpaceCameraPos.xyz;
                float3 viewDir  = normalize(i.worldPos - camPos);

                float3 camRight = unity_CameraToWorld[0].xyz;
                float3 camUp    = unity_CameraToWorld[1].xyz;

                float refrAmt = _Distortion * 0.5;
                float3 dirBase = normalize(viewDir);
                float3 dirRefr = normalize(viewDir + (camRight * offs.x + camUp * offs.y) * refrAmt);

                fixed4 skyBase = texCUBE(_SkyTex, dirBase) * _SkyIntensity;
                fixed4 skyRefr = texCUBE(_SkyTex, dirRefr)* _SkyIntensity;

                float refrMask = saturate(drop + trail + fogTrail);
                fixed4 skyCol = lerp(skyBase, skyRefr, refrMask);

                // --- WORLD-SPACE GROUND PLANE INTERSECTION ---
                // Ray: R(t) = camPos + viewDir * t
                // Ground plane: y = _GroundY -> solve for t = (_GroundY - camPos.y) / viewDir.y
                float groundMask = 0;
                fixed4 groundCol = fixed4(0,0,0,0);

                // avoid division by nearly-zero and ensure ray points down
                if (abs(viewDir.y) > 1e-5 && viewDir.y < 0.0)
                {
                    float tt = (_GroundY - camPos.y) / viewDir.y;
                    // only accept intersections in front of camera
                    if (tt > 0.0001)
                    {
                        float3 hitPos = camPos + viewDir * tt;
                        // sample ground texture using world XZ, scaled
                        float2 guv = hitPos.xz * _GroundScale;
                        // allow tiling by frac, or remove frac() if you want clamped repeated behavior
                        float2 guvf = frac(guv);
                        groundCol = tex2D(_GroundTex, guvf) * _GroundTint;

                        // fade by distance (so far away ground blends out smoothly)
                        float fade = 1.0;
                        if (_GroundFadeDist > 0.001) fade = saturate(1.0 - (tt / _GroundFadeDist));
                        groundMask = fade;
                    }
                }

                // final composite: ground overrides sky where ground hit occurs (modulated by groundMask)
                fixed4 finalCol = lerp(skyCol, groundCol, groundMask);

                UNITY_APPLY_FOG(i.fogCoord, finalCol);
                return finalCol;
            }
            ENDCG
        }
    }
}
