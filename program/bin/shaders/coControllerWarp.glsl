#version 450
const int SSBO_IMAGE_LAYERS = 1;

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(binding = 0) uniform sampler2D controllerTexture;
layout(binding = 1) uniform sampler2D controllerTextureDepth;
layout(rgba8, binding = 2) uniform image2D finalImage;
//layout(std430, binding = 3) coherent buffer imageStorage
//{
//    float R[1024 * 1024 * SSBO_IMAGE_LAYERS];
//	float G[1024 * 1024 * SSBO_IMAGE_LAYERS];
//	float B[1024 * 1024 * SSBO_IMAGE_LAYERS];
//	float Z[1024 * 1024 * SSBO_IMAGE_LAYERS];
//};
layout(rgba8, binding = 4) uniform image2D aaImage;

uniform vec3 diffVector;
uniform int width;

uniform ivec2 startCoordOld;
uniform ivec2 imageCenter;
uniform ivec2 handImageSize;

uniform mat4 PVM;
uniform mat4 inversePVM;

uniform int height;

highp vec2 FACTORS = vec2(8253.804488, 11100.99302);
highp vec2 FACTORS_PLUS = vec2(292.0278566, 527.2638654);

void main()
{
	int index3d=0;
	ivec2 finalImageSize = imageSize(finalImage);

	//Starting point at destination image + pixel ID
	ivec2 storeCoord = ivec2(gl_GlobalInvocationID.xy) + startCoordOld;

	if(storeCoord.x < 0 || storeCoord.y < 0 || storeCoord.x > finalImageSize.x || storeCoord.y > finalImageSize.y)
		return;

	//Depth
	float z = texture(controllerTextureDepth, vec2(gl_GlobalInvocationID.xy) / handImageSize).r;

	//Screen space to NDC
	vec3 ndc;
	ndc.x = ((2.0 * float(storeCoord.x)) / finalImageSize.x) - 1.0;
	ndc.y = ((2.0 * float(storeCoord.y)) / finalImageSize.y) - 1.0;
	ndc.z = z * 2.0 - 1.0; 

	//NDC to local space
	highp vec4 localSpace = inversePVM * vec4(ndc, 1.0);

	//Perspective divide
	localSpace.xyz /= localSpace.w;
			
	//float homoz = localSpace.z;

	//Storage factors for hand controller model

	vec2 storageCoord;
	storageCoord.x = localSpace.x * FACTORS.x + FACTORS_PLUS.x;
	storageCoord.y = localSpace.y * FACTORS.y + FACTORS_PLUS.y;
	
	if(	storageCoord.x < 0		|| 
		storageCoord.x > 1024	|| 
		storageCoord.y < 0		|| 
		storageCoord.y > 1024)
	{
		//imageStore(aaImage, ivec2(storageCoord.xy), vec4(0,0,0,0));
		return;
	}

	//Sample 
	vec4 color = texture(controllerTexture, vec2(gl_GlobalInvocationID.xy) / handImageSize);

	if(color.a == 1.0)
	{
		localSpace.w = 1;
		//Warped coord
		//Get warped projected pixel
		vec4 warpedCoord = PVM * localSpace;

		//Perspective divide after P
		warpedCoord.xyz /= warpedCoord.w;

		//Screen space
		warpedCoord.x = (warpedCoord.x + 1) * finalImageSize.x * 0.5;
		warpedCoord.y = (warpedCoord.y + 1) * finalImageSize.y * 0.5;

//		if(	warpedCoord.x < 0		|| 
//		warpedCoord.x > finalImageSize.x	|| 
//		warpedCoord.y < 0		|| 
//		warpedCoord.y > finalImageSize.y)
//		{
//			imageStore(aaImage, ivec2(storageCoord.xy), vec4(0,0,0,0));
//			return;
//		}

		//Debug
//		color.r = 1;
		color.a = warpedCoord.z;

		vec4 old = imageLoad(aaImage, ivec2(warpedCoord.xy));

		if(old.a > warpedCoord.z || old.a == 0)
		{
			imageStore(aaImage, ivec2(warpedCoord.xy), color);
		}
		
		//imageStore(aaImage, ivec2(warpedCoord.xy), color + old);
	}

	//SSBO index of this pixel
//	index3d = int((gl_GlobalInvocationID.y * 1024) + gl_GlobalInvocationID.x);
//	Z[index3d] = 1;

	//imageStore(finalImage, ivec2(gl_GlobalInvocationID.xy), color);

//
//	imageStore(finalImage, ivec2(warpedCoord.xy) + ivec2(0,1), color);
//	imageStore(finalImage, ivec2(warpedCoord.xy) + ivec2(1,0), color);
//	imageStore(finalImage, ivec2(warpedCoord.xy) + ivec2(0,-1), color);
//	imageStore(finalImage, ivec2(warpedCoord.xy) + ivec2(-1,0), color);
//
//	int index3d_extra = int((gl_GlobalInvocationID.y * 1024) + gl_GlobalInvocationID.x);
//
//	R[index3d_extra] = 0;
//	G[index3d_extra] = 0;
//	B[index3d_extra] = 0;
//	Z[index3d_extra] = 0;

//	if(Z[index3d]==0)
//	{
//		R[index3d] = color.r;
//		G[index3d] = color.g;
//		B[index3d] = color.b;
//		Z[index3d] = homoz;
//	}
}

	