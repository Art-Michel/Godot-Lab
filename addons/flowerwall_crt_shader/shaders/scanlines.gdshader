shader_type canvas_item;

uniform float scanline_space = 3.0;
uniform float scanline_opacity: hint_range(0, 1);

void fragment()
{
	COLOR.rgb = vec3(0, 0, 0);
	float scanline = mod(float(FRAGCOORD.y), scanline_space); // check which pixel we are in a row of 3
	COLOR.a = 1.0 - (step(1.0, scanline)); // black if above 1.0 (0.0, 1.0, 2.0)
	COLOR.a *= scanline_opacity;
}