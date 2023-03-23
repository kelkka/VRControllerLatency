#version 430 core

uniform sampler2D diffuse;

in vec2 v2TexCoord;
out vec4 outputColor;

void main()
{
   outputColor.a = 0.0f;
   outputColor = texture( diffuse, v2TexCoord);

}