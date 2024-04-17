shader_type canvas_item;

uniform float scanlines_interval:hint_range(0.0, 20.0, 1.0) = 6.0;
uniform float scanline_opacity: hint_range(0, 1, 0.01) = 0.5;
uniform float scanline_thickness: hint_range(0, 10, 1.0) = 3;

void fragment()
{
	COLOR.rgb = vec3(0, 0, 0);
	float scanline = mod(float(FRAGCOORD.y), scanlines_interval); // check which pixel we are in a row of X
	COLOR.a = 1.0 - (step(scanline_thickness, scanline)); // black if above 1.0 (0.0, 1.0, 2.0)
	COLOR.a *= scanline_opacity;
}