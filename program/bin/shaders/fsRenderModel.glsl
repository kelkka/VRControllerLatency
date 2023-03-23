#version 430 core

uniform sampler2D diffuse;
//layout(r32f, binding = 1) uniform image2D wStorage;

in vec2 v2TexCoord;
//in vec3 color;
out vec4 outputColor;

uniform vec4 g_color;
//uniform int g_storeW;

//uniform vec2 g_max;
//uniform vec2 g_min;
//uniform int g_width;
//uniform int g_height;

void main()
{
	outputColor = texture( diffuse, v2TexCoord);
	//outputColor.rgb = color;
	outputColor *= g_color;
	//outputColor.a = (1.0 / gl_FragCoord.w);
	//outputColor.rgb = vec3(1.0/gl_FragCoord.w);
	//outputColor.a = gl_FragCoord.w / 3.0;
	//outputColor.rgb = vec3(outputColor.a);
//	if(g_storeW == 1)
//	{
//		imageStore(wStorage, ivec2(gl_FragCoord.xy), vec4(1000));
//		outputColor.rg = gl_FragCoord.xy;
//	}
//
//	vec2 fMin, fMax;
//	fMin.x = (g_min.x + 1) * g_width/2;
//	fMin.y = (g_min.y + 1) * g_height/2;
//	fMax.x = (g_max.x + 1) * g_width/2;
//	fMax.y = (g_max.y + 1) * g_height/2;
//
//	if(	gl_FragCoord.x < fMax.x
//		//gl_FragCoord.x > fMin.x && 
//		//gl_FragCoord.y > fMin.y && 
//		//gl_FragCoord.y < fMax.y
//		)
//	{
//		int x = int(gl_FragCoord.x);
//
//		ivec2 iCoord = ivec2(x, gl_FragCoord.y - fMax.y);
//
//		imageStore(handTexture, iCoord, outputColor);
//	}
//	else
//	{
//		imageStore(wStorage, ivec2(gl_FragCoord.xy), vec4(1,0,1,1));
//	}
}