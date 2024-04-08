shader_type canvas_item;

uniform float scanline_space = 3.0;
uniform float scanline_opacity: hint_range(0, 1);

float scanline(float y, float screeny)
{
	float o = mod(round(y * (1.0/screeny)), scanline_space);
	o = clamp(o,0,1);
	return (1.0 - o) * scanline_opacity;
}

void fragment()
{
	COLOR.rgb = vec3(0,0,0);
	COLOR.a = scanline(UV.y, SCREEN_PIXEL_SIZE.y);
}

