#version 430
layout(location = 0) in vec2 in_position;
layout(location = 1) in vec2 in_texCoord;

out vec2 v2UVcoords;
uniform mat4 PVM;

void main()
{
	v2UVcoords = in_texCoord;
	v2UVcoords.y = 1 - v2UVcoords.y;
	gl_Position = PVM * vec4(in_position,0,1);
}