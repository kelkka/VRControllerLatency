#version 430

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(binding = 0) uniform sampler2D texture_left;
layout(binding = 1) uniform sampler2D texture_right;
layout(rgba8, binding = 2) uniform image2D testBuffer;

//layout(std430, binding = 3) buffer Output
//{
//	vec4 ARGB[];
//
//} OutData;



uniform int width;
uniform int height;
uniform ivec2 startCoord;

void main()
{
	/*
	index = x +
	y * D1 +
	z * D1 * D2 +
	t * D1 * D2 * D3;

	*/
	//uint index =	gl_WorkGroupID.x +
	//				gl_WorkGroupID.y *					gl_NumWorkGroups.x +
	//				gl_LocalInvocationID.x *			gl_NumWorkGroups.x * gl_NumWorkGroups.y +
	//				gl_LocalInvocationID.y *			gl_NumWorkGroups.x * gl_NumWorkGroups.y * gl_WorkGroupSize.x;

	uint index = (startCoord.y + gl_GlobalInvocationID.y) * width + startCoord.x + gl_GlobalInvocationID.x;

	if (index >= width * height)
		return;

	ivec2 itexCoord;

	itexCoord.x = int(index) % width;
	itexCoord.y = int(index) / width;

	vec2 ftexCoord;

	ftexCoord.x = itexCoord.x / float(width);
	ftexCoord.y = itexCoord.y / float(height);

	imageStore(testBuffer, itexCoord, texture(texture_right, ftexCoord));

	//OutData.ARGB[index] = texture(texture_left, ftexCoord);
	//OutData.ARGB[index + width * height] = texture(texture_right, ftexCoord);

	
}