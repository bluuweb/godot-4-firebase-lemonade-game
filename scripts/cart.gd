class_name Cart
extends Area2D

# Guardar al personaje que espera (cuando no hay stock)
var is_person_wait_stock: Person = null

func _ready() -> void:
	Global.update_stock_signal.connect(stock_available)

func stock_available():
	print("person_wait_stock: ", is_person_wait_stock)
	if is_person_wait_stock:
		#print("ahora si tiene stock")
		#await get_tree().process_frame # Da tiempo a que se ejecute correctamente
		#_on_area_entered(person)
		person_wait_order(is_person_wait_stock)
		is_person_wait_stock = null

# Aquí se detecta la compra
func _on_area_entered(area: Area2D) -> void:
	if area is Person:
		# Si no existe stock, no puedo seguir caminando
		if Global.stock <= 0:
			print("No tiene stock")
			is_person_wait_stock = area
			return
			
		person_wait_order(area)

func person_wait_order(person: Person):
	if person.money >= Global.price:
		person.wait_and_walk("normal", 1.5)
	else:
		person.wait_and_walk("no_money", 1.5)
