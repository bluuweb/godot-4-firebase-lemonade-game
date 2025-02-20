class_name Person
extends Area2D

@export var path_follow_2d: PathFollow2D  # Referencia al PathFollow2D
@onready var timer: Timer = $Timer

var timer_seconds = 0.1
var flagBackPerson := false
var flagFrontPerson := false
var flagCart := false

func _ready() -> void:
	timer.wait_time = timer_seconds

# Detectar a otra persona o el carrito de ventas y parar
func _on_area_entered(area: Area2D) -> void:
	if area is Person:
		timer.stop()
		
	elif area is Cart:
		timer.stop()
		

func _on_area_exited(area: Area2D) -> void:
	if area is Person:
		timer.start()

# Detectó una persona atrás
func _on_area_2d_back_area_entered(area: Area2D) -> void:
	if area is Person:
		# afecto a la otra persona que está atrás
		area.timer.stop()

func _on_area_2d_back_area_exited(area: Area2D) -> void:
	if area is Person:
		# afecto a la otra persona que está atrás
		area.timer.start()
		
# Manejar el avance del camino
func _on_timer_timeout() -> void:
	path_follow_2d.progress_ratio += 0.01
	if path_follow_2d.progress_ratio >= 1:
		print("Se terminó el camino")
		path_follow_2d.queue_free()
		queue_free()
