class_name Cart
extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is Person:
		await get_tree().create_timer(4).timeout
		Global.sell_lemonade()
		area.timer.start()
