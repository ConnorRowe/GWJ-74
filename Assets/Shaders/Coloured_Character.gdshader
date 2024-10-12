shader_type canvas_item;

uniform vec4 fill_colour : source_color  = vec4(1.0);
uniform sampler2D fill_tex: filter_nearest;

void fragment() {
	vec4 fill_sample = texture(fill_tex, UV) * fill_colour;
	COLOR = mix(texture(TEXTURE, UV), fill_sample, fill_sample.a);
}
