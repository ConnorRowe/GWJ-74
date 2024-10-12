shader_type canvas_item;

uniform vec4 colour_r : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 colour_g : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 colour_b : source_color = vec4(0.0, 0.0, 1.0, 1.0);

void fragment() {
	vec4 base_colour = texture(TEXTURE, UV);
	COLOR = mix(mix(mix(base_colour, colour_r, base_colour.r), colour_g, base_colour.g), colour_b, base_colour.b);
	COLOR.a = base_colour.a;
}
