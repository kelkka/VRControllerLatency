#version 450
//const int SSBO_IMAGE_LAYERS = 1;

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

//layout(binding = 0) uniform sampler2D controllerTexture;
layout(rgba8, binding = 2) uniform image2D finalImage;

layout(binding = 3) uniform sampler2D aaImage;
//layout(binding = 4) uniform sampler2D aaImage_r;

//uniform int width;
//uniform int height;

uniform ivec2 startCoord;
//uniform ivec2 startCoordOld;
//uniform ivec2 imageCenter;
//uniform ivec2 handImageSize;

//uniform mat4 PVM;

//highp vec2 FACTORS = vec2(8253.804488, 11100.99302);
//highp vec2 FACTORS_PLUS = vec2(292.0278566, 527.2638654);

#define s2(a, b)				temp = a; a = min(a, b); b = max(temp, b);
#define t2(a, b)				s2(v[a], v[b]);
#define t24(a, b, c, d, e, f, g, h)			t2(a, b); t2(c, d); t2(e, f); t2(g, h); 
#define t25(a, b, c, d, e, f, g, h, i, j)		t24(a, b, c, d, e, f, g, h); t2(i, j);

void main()
{
	ivec2 finalImageSize = imageSize(finalImage);

	//Starting point at destination image + pixel ID
	ivec2 storeCoord = ivec2(gl_GlobalInvocationID.xy) + startCoord;

	if(storeCoord.x < 0 || storeCoord.y < 0 || storeCoord.x > finalImageSize.x || storeCoord.y > finalImageSize.y)
	{
		return;
	}

	//vec4 colorAA1 = texture(aaImage_l, vec2(storeCoord.xy) / finalImageSize);
	//vec4 colorAA2 = texture(aaImage_r, vec2(storeCoord.xy) / finalImageSize);

//	if(colorAA1.a > 0)
//	{
//		imageStore(finalImage, ivec2(storeCoord.xy), colorAA1);
//	}
//	else if(colorAA2.a > 0)
//	{
//		imageStore(finalImage, ivec2(storeCoord.xy), colorAA2);
//	}
//	else
//	{
//		imageStore(finalImage, ivec2(storeCoord.xy), vec4(1,0,1,1));
//	}

//	return;

	vec4 color;

	color = texture(aaImage, vec2(storeCoord.xy) / finalImageSize);
//
	if(color.a == 0)
		return;
//	
//	imageStore(finalImage, ivec2(storeCoord.xy), color);
//
//	return;

	vec4 v[25];

	// Add the pixels which make up our window to the pixel array.
	for(int dX = -2; dX <= 2; ++dX) 
	{
		for(int dY = -2; dY <= 2; ++dY) 
		{		
			ivec2 offset = ivec2(dX, dY);
		    
			// If a pixel in the window is located at (x+dX, y+dY), put it at index (dX + R)(2R + 1) + (dY + R) of the
			// pixel array. This will fill the pixel array, with the top left pixel of the window at pixel[0] and the
			// bottom right pixel of the window at pixel[N-1].
			//v[(dX + 1) * 3 + (dY + 1)] = texture2D(T, gl_TexCoord[0].xy + offset * Tinvsize);

			v[(dX + 2) * 5 + (dY + 2)] = texture(aaImage, vec2(storeCoord.xy + offset) / finalImageSize);
		}
	}

	vec4 temp;

	// Starting with a subset of size 6, remove the min and max each time
	  t25(0, 1,			3, 4,		2, 4,		2, 3,		6, 7);
	  t25(5, 7,			5, 6,		9, 7,		1, 7,		1, 4);
	  t25(12, 13,		11, 13,		11, 12,		15, 16,		14, 16);
	  t25(14, 15,		18, 19,		17, 19,		17, 18,		21, 22);
	  t25(20, 22,		20, 21,		23, 24,		2, 5,		3, 6);
	  t25(0, 6,			0, 3,		4, 7,		1, 7,		1, 4);
	  t25(11, 14,		8, 14,		8, 11,		12, 15,		9, 15);
	  t25(9, 12,		13, 16,		10, 16,		10, 13,		20, 23);
	  t25(17, 23,		17, 20,		21, 24,		18, 24,		18, 21);
	  t25(19, 22,		8, 17,		9, 18,		0, 18,		0, 9);
	  t25(10, 19,		1, 19,		1, 10,		11, 20,		2, 20);
	  t25(2, 11,		12, 21,		3, 21,		3, 12,		13, 22);
	  t25(4, 22,		4, 13,		14, 23,		5, 23,		5, 14);
	  t25(15, 24,		6, 24,		6, 15,		7, 16,		7, 19);
	  t25(3, 11,		5, 17,		11, 17,		9, 17,		4, 10);
	  t25(6, 12,		7, 14,		4, 6,		4, 7,		12, 14);
	  t25(10, 14,		6, 7,		10, 12,		6, 10,		6, 17);
	  t25(12, 17,		7, 17,		7, 10,		12, 18,		7, 12);
	  t24(10, 18,		12, 20,		10, 20,		10, 12);

	color = v[12];
	
	if(color.a == 0)
		return;

	imageStore(finalImage, ivec2(storeCoord.xy), color);

	//imageStore(finalImage, ivec2(storeCoord.xy), vec4(colorAA1.a, colorAA2.a,0,1));

	//vec4 color = texture(controllerTexture, vec2(gl_GlobalInvocationID.xy) / handImageSize);

	//if(colorAA.r <= 0)
	//{
		
	//}
	//else
		//imageStore(finalImage, ivec2(storeCoord.xy), vec4(1,0,0,1));
}