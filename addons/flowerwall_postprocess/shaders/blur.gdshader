shader_type canvas_item;

// Radius that the shader was designed for.
const float DEFAULT_RADIUS = 3.000000000;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Unit vector: (1, 0) or (0, 1)
uniform vec2 step;

// Desired blur radius.
uniform float radius = 3.000000000;

void fragment() {
	vec2 s = radius / DEFAULT_RADIUS * step / vec2(textureSize(screen_texture, 0));
	COLOR.rgb =
		0.036632845 * texture(screen_texture, SCREEN_UV - 3.000000000 * s).rgb +
		0.328026080 * texture(screen_texture, SCREEN_UV - 1.339243631 * s).rgb +
		0.487427471 * texture(screen_texture, SCREEN_UV + 0.444671945 * s).rgb +
		0.147913604 * texture(screen_texture, SCREEN_UV + 2.247663801 * s).rgb;
	COLOR.a = 1.0;
}
