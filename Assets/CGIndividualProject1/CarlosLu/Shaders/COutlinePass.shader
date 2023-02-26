Shader "Carlos/COutlinePass"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _OutlineWidth ("Outline Width", Range(0.002, 0.1)) = 0.005
        
    }
    SubShader // This outline is not idea is because when the camera views a sharp edges, unwanted parts might be culled
    {
        Tags { "Geometry"="Transparent" }
        //LOD 200
        
        ZWrite off
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert vertex:vert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        float _OutlineWidth;
        fixed4 _Color;
        fixed4 _OutlineColor;

        void vert (inout appdata_full v)
        {
            v.vertex.xyz += v.normal + _OutlineWidth;
        }

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            o.Emission = _OutlineColor.rgb;
        }
        ENDCG

        //-----------------------------------------------------//
        Tags { "Geometry"="Transparent" }
        
        ZWrite on
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        struct Input
        {
            float2 uv_MainTex;
        };
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            o.Alpha = c.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
