extends Control


func _ready() -> void:
	SoundManager.menu_music()
	
	create_tween().tween_property($TransitionColorRect, "color", Color.TRANSPARENT, 1.0).from(Color.WHITE)
	
	GameInstance.played_intro = false

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
