Shader "MyShaders/XRay"
{
    Properties
    {
        _MainTex("Texture", 2D) = "black" {}
        _SRef("Stencil Reference", float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Compare", float) = 6
        [Enum(UnityEngine.Rendering.StencilOp)] _SOp("Stencil Operator", float) = 2
        [Enum(UnityEngine.Rendering.StencilOp)] _SFail("Stencil Fail", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Stencil {
                Ref[_SRef]
                Comp[_SComp]
                Pass[_SOp]
                Fail[_SFail]
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
