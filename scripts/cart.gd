class_name Cart
extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is Person:
		#Global.sell_lemonade()
		Global.sell.emit()
		area.wait_and_walk()
