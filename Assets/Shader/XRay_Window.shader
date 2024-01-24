Shader "XRay_Window"
{
    Properties
    {
        _SRef("Stencil Reference", float) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" "Queue"="Geometry-100" }
        LOD 100

        Pass
        {
            Stencil {
                Ref [_SRef]
                Comp Always
                Pass Replace
            }

            ZWrite Off
            ColorMask 0
        }
    }
}

