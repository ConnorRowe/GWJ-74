shader_type canvas_item;

uniform vec4 colour_a : source_color = vec4(0.0);
uniform vec4 colour_b : source_color = vec4(1.0);
const float swap_speed = 3.0;

void fragment() {
	vec4 base_colour = texture(TEXTURE, UV);
	if(base_colour.a <= 0.1)
		discard;

	bool swap = fract(TIME * swap_speed) > 0.5;
	if(base_colour.r > .5)
		COLOR = swap ? colour_a : colour_b;
	else
		COLOR = swap ? colour_b : colour_a;
}
