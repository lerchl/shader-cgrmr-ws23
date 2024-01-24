Shader "MyShaders/XRay_Seethrough"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SRef("Stencil Reference", float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SComp("Stencil Compare", float) = 6
        [Enum(UnityEngine.Rendering.StencilOp)] _SOp("Stencil Operator", float) = 2
        [Enum(UnityEngine.Rendering.StencilOp)] _SFail("Stencil Fail", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" "Queue"="Geometry-100" }
        LOD 100

        Pass
        {
            Stencil {
                Ref[_SRef]
                Comp[_SComp]
                Pass[_SOp]
                Fail[_SFail]
            }

            ZWrite Off
            ColorMask 0
        }
    }
}
