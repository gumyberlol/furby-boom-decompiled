Shader "Transparent/Diffuse" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
}
SubShader {
    LOD 200
    Tags { "Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" }
    Pass {
        Name "FORWARD"
        Tags { "LightMode"="ForwardBase" }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask RGB

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile_fwdbase
        #include "UnityCG.cginc"
        #include "Lighting.cginc"

        sampler2D _MainTex;
        float4 _MainTex_ST;
        fixed4 _Color;

        struct appdata {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };

        struct v2f {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
            float3 worldNormal : TEXCOORD1;
            float3 shLight : TEXCOORD2;
        };

        v2f vert (appdata v) {
            v2f o;
            o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
            float3 worldNormal = normalize(mul((float3x3)_Object2World, normalize(v.normal)));
            o.worldNormal = worldNormal;
            o.shLight = ShadeSH9(float4(worldNormal, 1));
            return o;
        }

        fixed4 frag (v2f i) : SV_Target {
            fixed4 tex = tex2D(_MainTex, i.uv) * _Color;
            fixed NdotL = max(0, dot(normalize(i.worldNormal), _WorldSpaceLightPos0.xyz));
            fixed4 c;
            c.rgb = tex.rgb * _LightColor0.rgb * NdotL * 2.0 + tex.rgb * i.shLight;
            c.a = tex.a;
            return c;
        }
        ENDCG
    }
}
FallBack "Transparent/VertexLit"
}
