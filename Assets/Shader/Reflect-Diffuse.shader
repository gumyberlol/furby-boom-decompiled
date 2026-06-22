Shader "Reflective/Diffuse" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
    _MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
    _Cube ("Reflection Cubemap", CUBE) = "_Skybox" {}
}
SubShader {
    LOD 200
    Tags { "RenderType"="Opaque" }
    Pass {
        Name "FORWARD"
        Tags { "LightMode"="ForwardBase" }

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile_fwdbase
        #include "UnityCG.cginc"
        #include "Lighting.cginc"

        sampler2D _MainTex;
        float4 _MainTex_ST;
        samplerCUBE _Cube;
        fixed4 _Color;
        fixed4 _ReflectColor;

        struct appdata {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };

        struct v2f {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
            float3 reflDir : TEXCOORD1;
            float3 worldNormal : TEXCOORD2;
            float3 shLight : TEXCOORD3;
        };

        v2f vert (appdata v) {
            v2f o;
            o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
            float3 worldNormal = normalize(mul((float3x3)_Object2World, normalize(v.normal)));
            o.worldNormal = worldNormal;
            float3 worldPos = mul(_Object2World, v.vertex).xyz;
            float3 incident = worldPos - _WorldSpaceCameraPos;
            float3 refl = reflect(incident, worldNormal);
            o.reflDir = float3(-refl.x, refl.yz);
            o.shLight = ShadeSH9(float4(worldNormal, 1));
            return o;
        }

        fixed4 frag (v2f i) : SV_Target {
            fixed4 tex = tex2D(_MainTex, i.uv) * _Color;
            fixed4 refl = texCUBE(_Cube, i.reflDir) * tex.a;
            fixed NdotL = max(0, dot(normalize(i.worldNormal), _WorldSpaceLightPos0.xyz));
            fixed4 c;
            c.xyz = tex.xyz * _LightColor0.xyz * NdotL * 2.0
                  + tex.xyz * i.shLight
                  + refl.xyz * _ReflectColor.xyz;
            c.w = refl.w * _ReflectColor.w;
            return c;
        }
        ENDCG
    }
}
FallBack "Diffuse"
}
