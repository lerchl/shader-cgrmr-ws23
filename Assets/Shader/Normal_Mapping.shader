Shader "Normal_Mapping"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalTexture ("Normal Texture", 2D) = "white" {}
        _NormalIntensity ("Normal Intensity", Range(-10, 10)) = 1
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

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float3 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float3 tangent : TEXCOORD2;
                float3 bitangent : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NormalTexture;
            float4 _NormalTexture_ST;

            float _NormalIntensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = UnityObjectToWorldNormal(v.tangent);
                o.bitangent = cross(o.tangent, o.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float3 normals = i.normal;
                float3 normalMap = UnpackNormal(tex2D(_NormalTexture, i.uv));

                normals = normalMap.r * i.tangent * _NormalIntensity +
                        normalMap.g * i.bitangent * _NormalIntensity +
                        normalMap.b * i.normal;
                
                float ndotl = max(0, dot(normals, _WorldSpaceLightPos0));
                float3 lighting = ndotl * _LightColor0 + ShadeSH9(float4(normals, 1));

                return float4(col * lighting, 1);
            }
            ENDCG
        }
    }
}
