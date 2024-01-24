Shader "XRay_Object"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _SRef("Stencil Reference", float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Compare", float) = 6
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Stencil
        {
            Ref [_SRef]
            Comp [_SComp]
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 lightDirection = _WorldSpaceLightPos0;
                float3 lightColor = _LightColor0;

                o.color = max(0, dot(worldNormal, lightDirection)) * lightColor;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return half4(i.color * col, 1.0f);
            }
            ENDCG
        }
    }
}

