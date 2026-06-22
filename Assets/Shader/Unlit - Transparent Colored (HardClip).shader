Shader "Unlit/Transparent Colored (HardClip)" {
Properties {
    _MainTex ("Base (RGB), Alpha (A)", 2D) = "white" {}
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
            float2 t = abs(i.clipuv);
            float x = 1.0 - max(t.x, t.y);
            clip(x);
            return tex2D(_MainTex, i.uv) * i.color;
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
