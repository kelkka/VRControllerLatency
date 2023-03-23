#version 430

uniform mat4 PVM;

layout(location = 0) in vec2 position;
layout(location = 1) in vec2 v2TexCoordsIn;

out vec2 v2TexCoord;

uniform vec3 g_camRight;
uniform vec3 g_camUp;
uniform vec3 g_centerPos;
uniform vec2 g_size;

void main()
{
	v2TexCoord = v2TexCoordsIn;
	v2TexCoord.y = 1 - v2TexCoord.y;
	//gl_Position = PVM * vec4(position.xy,0, 1);

	vec3 worldPos = g_centerPos + 
		+ g_camRight * position.x * g_size.x
		+ g_camUp * position.y * g_size.y;

	//2016x2240
	// Output position of the vertex
	gl_Position = PVM * vec4(worldPos, 1.0f);

}
