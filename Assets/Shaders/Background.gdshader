shader_type canvas_item;

uniform vec2 player_position = vec2(0);
const vec2 SCREEN_SIZE = vec2(320, 180);

void vertex() {
	UV += (player_position / SCREEN_SIZE);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
