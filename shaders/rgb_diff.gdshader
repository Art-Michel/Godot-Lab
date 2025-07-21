shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float r = 1;
uniform float g = 1;
uniform float b = 1;

void fragment()
{
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR.r *= r;
	COLOR.g *= g;
	COLOR.b *= b;
}
