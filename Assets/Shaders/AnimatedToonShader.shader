Shader "Unlit/AnimatedToonShader"
{
    Properties{
        _BaseColor("Base Color",Color) = (1,1,1,1)
        _RampTex("Ramp Texture", 2D) = "White"
    }

    SubShader{
        tags{"RenderPipeline" = "UniversalRenderPipeline" "RenderType"="Opaque"}
        
        Pass{
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes{
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
            };

            struct Varyings{
                float4 positionHCS : SV_POSITION;
                float3 normalWS : TEXCOORD0;
            };

            TEXTURE2D(_RampTex);
            SAMPLER(sampler_RampTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
            CBUFFER_END

            Varyings vert(Attributes IN){
                Varyings OUT;
                OUT.positionHCS=TransformObjectToHClip(IN.positionOS.xyz);
                OUT.normalWS=normalize(TransformObjectToWorldNormal(IN.normalOS));
                return OUT;
            }
            half4 frag(Varyings IN) : SV_Target{
                Light mainLight = GetMainLight();
                half3 lightDirWS = normalize(mainLight.direction);
                half3 lightColor = mainLight.color;

                half NdotL = saturate(dot(IN.normalWS,lightDirWS));
                half rampValue = SAMPLE_TEXTURE2D(_RampTex,sampler_RampTex,float2(NdotL,0)).r;
                half3 finalColor = _BaseColor.rgb*lightColor*rampValue;

                return half4(finalColor,_BaseColor.a);
            }
            ENDHLSL
        }
    }
}
