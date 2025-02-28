class_name Cart
extends Area2D

# Guardar al personaje que espera (cuando no hay stock)
var is_person_wait_stock: Person = null

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label_wait_time_limonade: Label = $LabelWaitTimeLimonade
@onready var timer_wait_limonade: Timer = $TimerWaitLimonade

func _ready() -> void:
	Global.update_stock_signal.connect(stock_available)
	config_inital_timer()
	toggle_wait_time_ui(false)
	
func config_inital_timer():
	timer_wait_limonade.connect("timeout", on_timer_out_wait_limonade)
	timer_wait_limonade.one_shot = true

func toggle_wait_time_ui(state: bool):
	if state:
		progress_bar.show()
		label_wait_time_limonade.show()
	else:
		progress_bar.hide()
		label_wait_time_limonade.hide()

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
		person.wait_and_walk("normal", Global.time_wait_for_limonade)
	else:
		person.wait_and_walk("no_money", Global.time_wait_for_limonade)
	
	active_progress_bar(Global.time_wait_for_limonade)
		
func active_progress_bar(time: float):
	# 1. reiniciar progress bar
	progress_bar.value = 100
	
	# 2. colocar el tiempo al timer
	timer_wait_limonade.wait_time = time
	
	# 3. activar el timer
	timer_wait_limonade.start()
	
	# 4. activar ui
	toggle_wait_time_ui(true)
	
# Actualizar la barra de progreso en cada frame
func _process(delta: float) -> void:
	if not timer_wait_limonade.is_stopped():
		# Calcular el porcentaje de tiempo restante
		var time_left = timer_wait_limonade.time_left
		var total_time = timer_wait_limonade.wait_time
		var progress = (time_left / total_time) * 100
		progress_bar.value = progress

# A los x segundos se acaba, representando el tiempo de preparación de limonadas
func on_timer_out_wait_limonade():
	toggle_wait_time_ui(false)
