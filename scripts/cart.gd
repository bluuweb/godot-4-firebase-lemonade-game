class_name Cart
extends Node2D

func _ready() -> void:
	#sell_lemonade()
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Person:
		Global.sell_lemonade()
