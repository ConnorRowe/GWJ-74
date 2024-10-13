extends Control

var jiggler : ControlJiggler = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jiggler = find_child("*Jiggler*", false)
	mouse_entered.connect(_on_mouse_entered)
	pivot_offset = size / 2

func _on_mouse_entered():
	jiggler.jiggle(1)
	SoundManager.wobble()
