class_name Person
extends Area2D

@export var path_follow_2d: PathFollow2D # Referencia al PathFollow2D
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var timer_seconds = 0.1
var flagBackPerson := false
var flagFrontPerson := false
var flagCart := false

# Lista de diseños disponibles
var designs = ["green_gobling", "blue_knight", "red_archer"] # Agrega tantos diseños como necesites
var selected_design: String

func _ready() -> void:
	# Seleccionar un diseño al azar
	randomize() # Inicializa el generador de números aleatorios
	var random_design = randi_range(0, designs.size() - 1)
	selected_design = designs[random_design]
	
	# Configurar las animaciones iniciales según el diseño seleccionado
	animated_sprite.play("walk_" + selected_design)

	timer.wait_time = timer_seconds

func stop_walk(area: Area2D):
	area.timer.stop()
	area.animated_sprite.play("idle_" + area.selected_design) # Usa el diseño seleccionado

func start_walk(area: Area2D):
	area.timer.start()
	area.animated_sprite.play("walk_" + area.selected_design)

# Detectar a otra persona o el carrito de ventas y parar
func _on_area_entered(area: Area2D) -> void:
	if area is Person:
		stop_walk(self)
		
	elif area is Cart:
		stop_walk(self)
		
func _on_area_exited(area: Area2D) -> void:
	if area is Person:
		start_walk(self)

# Detectó una persona atrás
func _on_area_2d_back_area_entered(area: Area2D) -> void:
	if area is Person:
		stop_walk(area)

func _on_area_2d_back_area_exited(area: Area2D) -> void:
	if area is Person:
		start_walk(area)
		
# Manejar el avance del camino
func _on_timer_timeout() -> void:
	path_follow_2d.progress_ratio += 0.01
	if path_follow_2d.progress_ratio >= 1:
		path_follow_2d.queue_free()
		queue_free()
