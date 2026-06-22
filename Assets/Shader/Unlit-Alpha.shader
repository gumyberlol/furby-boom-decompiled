Shader "Unlit/Transparent" {
Properties { _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {} }
SubShader {
    Tags { "Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" }
    Pass {
        ZWrite Off Blend SrcAlpha OneMinusSrcAlpha Cull Off
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        sampler2D _MainTex;
        float4 _MainTex_ST;
        struct a { float4 v:POSITION; fixed4 c:COLOR; float2 u:TEXCOORD0; };
        struct v { float4 p:SV_POSITION; fixed4 c:COLOR; float2 u:TEXCOORD0; };
        v vert(a i) { v o; o.p=mul(UNITY_MATRIX_MVP,i.v); o.c=i.c; o.u=TRANSFORM_TEX(i.u,_MainTex); return o; }
        fixed4 frag(v i):SV_Target { return tex2D(_MainTex,i.u)*i.c; }
        ENDCG
    }
}
}
