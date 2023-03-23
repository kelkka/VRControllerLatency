#version 430 core

uniform sampler2DRect mytexture;

in vec2 v2UVcoords;
out vec4 outputColor;

uniform int width;
uniform int height;

void main()
{
	ivec2 coords = ivec2(v2UVcoords.x * width, (1 - v2UVcoords.y) * height);
	outputColor.rgb = texture2DRect(mytexture, coords).rgb;
	outputColor.a = 1;
}