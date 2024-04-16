shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightness_multiplier:hint_range(0.7,2.0, 0.05) = 1.1;

void fragment()
{
    vec3 colorIn = texture(screen_texture, UV).xyz;
	float r;
	float g;
	float b;
    int rgbIndex = int(FRAGCOORD.x) % 3;
	if(rgbIndex == 0)
		r = 1.;
	else
		r = 0.;
	if(rgbIndex == 1)
		g = 1.;
	else
		g = 0.;
	if(rgbIndex == 2)
		b = 1.;
	else
		b = 0.;
    vec3 mask = vec3(r,g,b);

    vec3 colorOut = colorIn * mask * brightness_multiplier;

    COLOR = vec4(colorOut, 1.0);
}