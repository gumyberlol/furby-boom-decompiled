Shader "Unlit/Transparent Colored (SoftClip)" {
Properties {
    _MainTex ("Base (RGB), Alpha (A)", 2D) = "white" {}
    _ClipSharpness ("Clip Sharpness", Vector) = (20, 20, 0, 0)
}
SubShader {
    LOD 200
    Tags { "Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" }
    Pass {
        ZWrite Off
        Cull Off
        Fog { Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask RGB
        Offset -1, -1

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"

        sampler2D _MainTex;
        float4 _MainTex_ST;
        float2 _ClipSharpness;

        struct appdata {
            float4 vertex : POSITION;
            float4 color : COLOR;
            float2 texcoord : TEXCOORD0;
        };

        struct v2f {
            float4 pos : SV_POSITION;
            fixed4 color : COLOR;
            float2 uv : TEXCOORD0;
            float2 clipuv : TEXCOORD1;
        };

        v2f vert (appdata v) {
            v2f o;
            o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
            o.color = v.color;
            o.uv = v.texcoord;
            o.clipuv = v.vertex.xy * _MainTex_ST.xy + _MainTex_ST.zw;
            return o;
        }

        fixed4 frag (v2f i) : SV_Target {
            float2 factor = (1.0 - abs(i.clipuv)) * _ClipSharpness;
            fixed4 col = tex2D(_MainTex, i.uv) * i.color;
            col.a *= clamp(min(factor.x, factor.y), 0.0, 1.0);
            return col;
        }
        ENDCG
    }
}
SubShader {
    LOD 100
    Tags { "Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" }
    Pass {
        ZWrite Off
        Cull Off
        Fog { Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha
        AlphaTest Greater 0.01
        ColorMask RGB
        ColorMaterial AmbientAndDiffuse
        SetTexture [_MainTex] { combine texture * primary }
    }
}
}
