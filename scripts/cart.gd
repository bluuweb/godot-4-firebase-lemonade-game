class_name Cart
extends Area2D

# Guardar al personaje que espera (cuando no hay stock)
var person : Person = null

func _ready() -> void:
	Global.update_stock_signal.connect(stock_available)

func stock_available():
	if person:
		_on_area_entered(person)
		person = null

# Aquí se detecta la compra
func _on_area_entered(area: Area2D) -> void:
	if area is Person:
		# Si no existe stock, no puedo seguir caminando
		if Global.stock <= 0:
			print("No tiene stock")
			person = area
			return
		
		if area.money >= Global.price:
			area.wait_and_walk("normal", 1.5)
		else:
			area.wait_and_walk("no_money", 1.5)
