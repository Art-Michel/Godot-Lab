shader_type canvas_item;

uniform float scanline_space = 3.0;
uniform float scanline_opacity: hint_range(0, 1);

//float scanline(float y, float screeny)
//{
	//float o = mod(round(y * (1.0/screeny)), scanline_space);
	//o = clamp(o,0,1);
	//return (1.0 - o) * scanline_opacity;
//}

void fragment()
{
	COLOR.rgb = vec3(0, 0, 0);
	//COLOR.a = scanline(UV.y, SCREEN_PIXEL_SIZE.y);
	float scanline = mod(float(FRAGCOORD.y), scanline_space); // check which pixel we are in a row of 3
	COLOR.a = 1.0 - (step(1.0, scanline)); // black if above 1.0 (0.0, 1.0, 2.0)
	COLOR.a *= scanline_opacity;
}