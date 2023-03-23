#version 430 core

uniform float fadeVal;
uniform vec3 fadeColor;

in vec2 v2UVcoords;
out vec4 outputColor;

void main()
{
	outputColor = vec4(fadeColor, fadeVal);
}