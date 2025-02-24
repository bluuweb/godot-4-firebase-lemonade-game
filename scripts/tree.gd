extends Node2D

@onready var timer_spaw_lemon: Timer = $TimerSpawLemon
@onready var lemon: Sprite2D = $Area2D/Lemon

var timeLemon = 3
var lemon_active = false

func _ready() -> void:
	# Me conecto a la señal de game start
	$"../../UI".connect("game_start", game_start)
	
	lemon.hide()
	
func game_start():
	timer_spaw_lemon.wait_time = timeLemon
	timer_spaw_lemon.start()

# Temporizador para que aparezcan los limones
func _on_timer_spaw_lemon_timeout() -> void:
	if !lemon_active:
		lemon.show()
		lemon_active = true
		timer_spaw_lemon.stop()

# Detectar clic
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			lemon.hide()
			lemon_active = false
			timer_spaw_lemon.start()
			Global.update_stock(1)
			#Global.stock += 1
			#print("Global.stock: " , Global.stock)
