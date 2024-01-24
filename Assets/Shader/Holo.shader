Shader "Holo"
{
    Properties
    {
        _RimColor ("Rim Color", Color) = (1, 1, 1, 1)
        _RimPower ("Rim Power", Range(0.5, 5.0)) = 2.5
        _RimIntensity ("Rim Intensity", Range(0.5, 25)) = 5
        _SRef("Stencil Reference", float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Compare", float) = 6
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha

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

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float3 normal: TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 viewDir : TEXCOORD1;
            };

            float4 _RimColor;
            float _RimPower;
            float _RimIntensity;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float rim = 1 - saturate(dot(i.viewDir, i.normal));
                half3 color = _RimColor * pow(rim, _RimPower) * _RimIntensity;
                return half4(color, rim);
            }
            ENDCG
        }
    }
}
