//http://shdr.bkcore.com
//Fragment shader

precision highp float;
uniform float time;
uniform vec2 resolution;
uniform vec2 jesus;
varying vec3 fPosition;
varying vec3 fNormal;


vec2 blinnPhongDir(const vec3 lightDir, const float lightInt, const float Ka, const float Kd, const float Ks, const float shininess)
{
  vec3 s = normalize(lightDir);
  vec3 v = normalize(-fPosition);
  vec3 n = normalize(fNormal);
  vec3 h = normalize(v+s);
  float diffuse = Ka + Kd * lightInt * max(0.0, dot(n, s));
  float spec =  Ks * pow(max(0.0, dot(n,h)), shininess);
  return vec2(diffuse, spec);
}
vec2 phongDir(const vec3 lightDir, const float lightInt, const float Ka, const float Kd, const float Ks, const float shininess)
{
  vec3 s = normalize(lightDir);
  vec3 v = normalize(-fPosition);
  vec3 n = normalize(fNormal);
  vec3 h = normalize(v+s);
  vec3 r = normalize(2.0 * n * dot(s, n) - s);
  float diffuse = Ka + Kd * lightInt * max(0.0, dot(n, s));
  float spec =  Ks * pow(max(0.0, dot(r, v)), shininess);
  return vec2(diffuse, spec);
}
  
float blink(const vec3 lightDir, const float magnitude, const float speed, const bool usePhong)
{
  float shininess = abs(mod(time * speed, magnitude) - magnitude / 2.) + 1.0;
  vec2 phong = usePhong ? phongDir(lightDir, 1.0, 0.0, 0.5, 1.0, shininess / 2.) : blinnPhongDir(lightDir, 1.0, 0.0, 0.5, 1.0, shininess);
  return phong.x + phong.y;
}

float defaultBlinkBrightness(const bool phong)
{
  const vec3 lightSource = vec3(0.0, 0.0, 1.0);
  vec3 lightDir = lightSource - fPosition;
  return blink(lightDir, 5.0, 120.0, phong);
}

void setBlink(const bool phong) 
{
  gl_FragColor = vec4(defaultBlinkBrightness(phong) * fNormal, 1.0);
}

vec3 rim(const vec3 color, const float start, const float end, const float coef, const bool outline)
{
  vec3 normal = normalize(fNormal);
  vec3 eye = normalize(-fPosition.xyz);
  float dotProd = dot(normal, eye);
  float rim = smoothstep(start, end, outline ? dotProd : 1.0 - dotProd);
  return clamp(rim, 0.0, 1.0) * coef * color;
}

void setRim()
{
  vec3 color = rim(fNormal, 0.0, 1.0, 1.0, true);
  for(int i = 0; i < 3; i++)
    if(color[i] > 0.2 && color[i] < 0.5)
      color[i] = 0.25;
    else if (color[i] >= 0.5)
      color[i] = 0.75;
    else 
      color[i] = 0.0;
    
  gl_FragColor = vec4(color, 1.0);
}

void main()
{
  setBlink(false);
  //setBlink(true);
  //setRim();
}



