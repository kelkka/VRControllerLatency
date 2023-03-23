#version 450

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(binding = 0) uniform sampler2D texture_left;

layout(rgba8, binding = 0) uniform image2D outColor;

uniform int width;
uniform int height;
uniform ivec2 gStartCoord;

void main()
{
	uint index = (gStartCoord.y + gl_GlobalInvocationID.y) * width + gStartCoord.x + gl_GlobalInvocationID.x;

	//if (index >= width * height)
	//	return;

	ivec2 destTexCoord;
	ivec2 srcTexCoord;

	destTexCoord.x = int(index) % width;
	destTexCoord.y = int(index) / height;

	srcTexCoord = destTexCoord;

	if (srcTexCoord.y == 0)
		srcTexCoord.x += 581;
	else if (srcTexCoord.y == 1)
		srcTexCoord.x += 579;
	else if (srcTexCoord.y == 2)
		srcTexCoord.x += 576;

	vec4 color = vec4(1, 1, 0, 0);

	if (srcTexCoord.x < width)
	{
		color = texelFetch(texture_left, srcTexCoord, 0);
	}

	imageStore(outColor, destTexCoord, color);
}