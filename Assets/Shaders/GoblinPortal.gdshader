shader_type canvas_item;

uniform float fade_amount : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform sampler2D fade_tex: filter_nearest;

void fragment() {
	float sine_time = sin((TIME * 2.0) + UV.y);
	vec2 shift_uv = vec2( (UV.x + (sine_time * 0.1)), UV.y);
	if (fade_amount > 0.0 && texture(fade_tex, shift_uv).r <= fade_amount)
		discard;
		
	COLOR = texture(TEXTURE, shift_uv);
}