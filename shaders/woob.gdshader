shader_type canvas_item;

uniform float amplitude = 0.1;
uniform float frequency = 6.0;
uniform float speed = 10.0;
void fragment() {
	vec2 uv = UV;
	uv.y += sin((uv.x * frequency + TIME * speed)) * amplitude;
	uv.y*= 1. + amplitude * 2.2;
	uv.y-= amplitude *1.1;

	COLOR.rgba = texture(TEXTURE, uv);
	COLOR.a = step(0.0, uv.y);
	COLOR.a -= step(1.0, uv.y);
}
