shader_type canvas_item;
uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap, repeat_disable;
uniform sampler2D noise_texture: filter_linear_mipmap, repeat_enable;
uniform float wiggle = 320;

float v2random(vec2 uv) {
	return texture(noise_texture, mod(uv, vec2(1.0))).x;
}

void fragment() {
	vec2 uvn = SCREEN_UV;

	uvn.x += (v2random(vec2(uvn.y / 10.0, TIME / 10.0) / 1.0) - 0.5) / wiggle;
	uvn.x += (v2random(vec2(uvn.y, TIME * 10.0)) - 0.5) / wiggle;

	COLOR = texture(screen_texture, uvn);
}