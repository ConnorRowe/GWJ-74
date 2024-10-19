shader_type canvas_item;

uniform float target_closeness : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform sampler2D colour_lut : filter_nearest;

void vertex() {
	COLOR = texture(colour_lut, vec2(target_closeness, 0.0));
}
