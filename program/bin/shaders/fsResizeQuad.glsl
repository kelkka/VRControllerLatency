#version 430 core

uniform sampler2DMS mytexture;

in vec2 v2UVcoords;
out vec4 outputColor;

//uniform int width;
//uniform int height;

vec4 textureMultisample();

void main()
{
	outputColor = textureMultisample();
	//outputColor.a = 1;
	//outputColor.r = 1;
}

vec4 textureMultisample()
{
	vec4 color = vec4(0.0);
	ivec2 coord = ivec2(v2UVcoords * textureSize(mytexture));
	//ivec2 coord = ivec2(v2UVcoords * vec2(width, height));

	const int NUM_SAMPLES = 4;

	for (int i = 0; i < NUM_SAMPLES; i++)
		color += texelFetch(mytexture, coord, i);

	color /= float(NUM_SAMPLES);

	return color;
}


