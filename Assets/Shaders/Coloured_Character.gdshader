shader_type canvas_item;

uniform float fade_amount : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform vec4 fill_colour : source_color  = vec4(1.0);
uniform sampler2D fill_tex: filter_nearest;
uniform sampler2D fade_tex: filter_nearest;

void fragment() {
	if (fade_amount > 0.0 && texture(fade_tex, UV).r <= fade_amount)
		discard;
	
	vec4 fill_sample = texture(fill_tex, UV) * fill_colour;
	COLOR = mix(texture(TEXTURE, UV), fill_sample, fill_sample.a);
}
