shader_type canvas_item;

uniform float curve_power: hint_range(1.0, 1.05, 0.005) =1.025;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

vec2 distort(vec2 p) 
{
	float angle = p.y / p.x;
	float theta = atan(p.y,p.x);
	float radius = pow(length(p), curve_power);
	
	p.x = radius * cos(theta);
	p.y = radius * sin(theta);
	
	return 0.5 * (p + vec2(1.0,1.0));
}

void fragment() {
	vec2 xy = SCREEN_UV * 2.0;
	xy.x -= 1.0;
	xy.y -= 1.0;
	
	float d = length(xy);
	if(d < 1.5){
		xy = distort(xy);
	}
	else{
		xy = SCREEN_UV;
	}
	COLOR = texture(screen_texture, xy);
}

