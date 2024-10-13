shader_type canvas_item;

const vec4 key_colour = vec4(1.0, 0.0, 1.0, 1.0);
uniform vec4 replace_colour : source_color = vec4(1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR == key_colour)
		COLOR = replace_colour;
}

