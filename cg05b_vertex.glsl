//http://shdr.bkcore.com
//Vertex shader

precision highp float;
attribute vec3 position;
attribute vec3 normal;
uniform float time;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
varying vec3 fNormal;
varying vec3 fPosition;

void main()
{
  fNormal = normalize(normalMatrix * normal);
  
  
  float weight = abs(cos(time)), weight2 = abs(sin(time));
  vec3 ball_position = normalize(position);
  vec3 translating_position = position + vec3(weight * 5.0, weight2 * 2.0, 0.0);
  
  vec3 current_position = weight * position + weight2 * ball_position + (1.0 - weight - weight2) * translating_position;
  
  vec4 pos = modelViewMatrix * vec4(current_position, 1.0);
  fPosition = pos.xyz;
  gl_Position = projectionMatrix * pos;
}