#version 450

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(std430, binding = 0) buffer Output
{
	double MSE[];

} OutData;

layout(binding = 0) uniform sampler2D texture_left;
layout(binding = 1) uniform sampler2D texture_right;

uniform int width;
uniform int height;

void main()
{
	uint index = gl_WorkGroupID.x +
		gl_WorkGroupID.y *					gl_NumWorkGroups.x +
		gl_LocalInvocationID.x *			gl_NumWorkGroups.x * gl_NumWorkGroups.y +
		gl_LocalInvocationID.y *			gl_NumWorkGroups.x * gl_NumWorkGroups.y * gl_WorkGroupSize.x;

	uvec2 threadLength = ivec2(0, 0);
	threadLength += (uvec2(width, height)) / (gl_NumWorkGroups.xy*gl_WorkGroupSize.xy);

	uvec2 threadBegin = threadLength * (gl_WorkGroupSize.xy * gl_WorkGroupID.xy + gl_LocalInvocationID.xy);

	double diff = 0;

	for (uint i = 0; i < threadLength.y; i++)
	{
		for (uint j = 0; j < threadLength.x; j++)
		{
			ivec2 localTexCoord = ivec2(threadBegin.x + j, threadBegin.y + i);

			if (localTexCoord.x >= width || localTexCoord.y >= height)
				continue;

			vec3 leftRGB = texelFetch(texture_left, localTexCoord, 0).rgb;
			vec3 rightRGB = texelFetch(texture_right, localTexCoord, 0).rgb;

			vec3 diffRGB = (leftRGB - rightRGB);

			diff += diffRGB.r * diffRGB.r;
			diff += diffRGB.g * diffRGB.g;
			diff += diffRGB.b * diffRGB.b;
		}
	}

	OutData.MSE[index] = diff / (threadLength.y * threadLength.x * 3.0f);
}