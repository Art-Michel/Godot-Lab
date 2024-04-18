shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float noise_opacity: hint_range(0.0, 1.0, 0.05) = 0.3;

float filmGrainNoise(in float time, in vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233) * time)) * 43758.5453);
}

void fragment()
{
	COLOR.rgb = mix(texture(screen_texture, SCREEN_UV).rgb ,vec3(0.0), filmGrainNoise(TIME, SCREEN_UV) * noise_opacity);
}