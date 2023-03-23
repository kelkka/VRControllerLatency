#version 430 core

uniform sampler2D mytexture;
uniform float repeat;
uniform vec3 eyePos;
uniform float normalDirs;

uniform vec3 laserPos;
uniform vec3 laserDir;

in vec2 v2UVcoords;
in vec3 v3Normal;
in vec3 v3Pos;
out vec4 outputColor;

const vec3 lightPos = vec3(0, 2, 0);
const float ambient = 0.1f;

void main()
{
	vec3 lightDir = normalize(lightPos - v3Pos);
	vec3 normal = normalize(v3Normal * normalDirs);

	outputColor = vec4(0, 0, 0, 1);
	outputColor = texture(mytexture, v2UVcoords * repeat);
	//outputColor = texture(mytexture, v2UVcoords);

	float diffuse = max(dot(lightDir, normal), 0.0);
	float specular = 0;

	if (diffuse > 0)
	{
		vec3 surfaceToCam = normalize(v3Pos - eyePos);
		vec3 reflection = reflect(-lightDir, normal);
		specular = pow(max(dot(surfaceToCam, reflection), 0.0), 32);
	}

	float dist = length(lightPos - v3Pos);
	float attenuation = 1.0 / (1.0f + 0.01f * dist + 0.005f * (dist * dist));
	diffuse *= attenuation;
	specular *= attenuation;

	float theta = dot(normalize(laserPos - v3Pos), normalize(-laserDir));

	if(theta > 0.999995)
	{
		theta *= 0.6f;

		outputColor.r += theta;
		outputColor.g = 0;
		outputColor.b = 0;
		specular += theta;
	}

	outputColor.rgb = (specular + diffuse + ambient) * outputColor.rgb;
	outputColor.rgb += 0.1f;

	if(theta > 0.99)
	{
		float v = (theta - 0.99) * 70;
		outputColor.r += v * v;
	}
}