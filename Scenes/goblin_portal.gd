class_name GoblinPortal
extends Node2D

@onready var portal_material : ShaderMaterial = material

func appear() -> void:
	create_tween().tween_property(material, "shader_parameter/fade_amount", 0.0, 0.5).from(1.0).set_trans(Tween.TRANS_CUBIC)


func disappear() -> void:
	await create_tween().tween_property(material, "shader_parameter/fade_amount", 1.0, 0.5).from(0.0).set_trans(Tween.TRANS_CUBIC).finished
	queue_free()
