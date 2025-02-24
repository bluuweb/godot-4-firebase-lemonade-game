class_name Cart
extends Area2D

# Aquí se detecta la compra
func _on_area_entered(area: Area2D) -> void:
	if area is Person:
		if area.money >= Global.price:
			area.wait_and_walk("normal", 1.5)
		else:
			area.wait_and_walk("no_money", 1.5)
