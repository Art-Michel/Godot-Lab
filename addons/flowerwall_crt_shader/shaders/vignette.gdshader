shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float vignette_size: hint_range(0.1, 10.0, 0.1) = 5.0;
uniform float vignette_attenuation: hint_range(0.05, 5.0, 0.05) = 1.05;

void fragment()
{
	vec2 uv = UV;
	uv *=  1.0 - uv.yx;   //vec2(1.0)- uv.yx; -> 1.-u.yx; Thanks FabriceNeyret !
	float vig = uv.x*uv.y * vignette_size * 1000.0; // multiply with sth for intensityvig = pow(vig, 0.25); // change pow for modifying the extend of the  vignette
	vig = pow(vig, vignette_attenuation);
	COLOR = texture(screen_texture, UV);
	COLOR.rgb -= 1.0-(clamp(vig,0,1));
}