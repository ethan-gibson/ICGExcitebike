Shader "Unlit/DesertTint"
{
    Properties{
        _MainTex("Texture2D", 2D) = "White" {}
        _TintColor("Tint Color", Color) = (1,1,1,1)
    }
    SubShader{
               tags{"RenderPipeline" = "UniversalRenderPipeline" "RenderType"="Opaque"}
        
        Pass{
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes{
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings{
                float2 uv : TEXCOORD0;
                float4 positionHCS : SV_POSITION;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            float4 _TintColor;

            Varyings vert(Attributes IN){
                Varyings OUT;
                OUT.positionHCS=TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = IN.uv;
                return OUT;
            }
            half4 frag(Varyings IN):SV_Target{
                half4 col = SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex,IN.uv);
                return col*_TintColor;
            }
            ENDHLSL
        }
    }
}
