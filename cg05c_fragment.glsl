//http://shdr.bkcore.com
//Fragment shader
precision highp float;
uniform float time;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
varying vec3 fNormal;
varying vec3 fPosition;
varying vec3 color;

void main()
{
  gl_FragColor = vec4(color, 1.0);
}