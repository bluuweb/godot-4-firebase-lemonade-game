class_name Person
extends Area2D

@export var path_follow_2d: PathFollow2D # Referencia al PathFollow2D
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var emoji: Label = $Emoji

var timer_seconds = 0.1
var flagBackPerson := false
var flagFrontPerson := false
var flagCart := false

var is_in_cart := false

# Lista de diseños disponibles
var designs = ["green_gobling", "blue_knight", "red_archer"] # Agrega tantos diseños como necesites
var selected_design: String

var money := 1.0
var min_money := 0.0
var max_money := 5.0

# 💰😵😵‍💫🥺💸💵
const REACTION = {
	"WAIT": "⌛",
	"NORMAL": "😄",
	"NO_MONEY": "😵"
}

func _ready() -> void:
	emoji.hide()
	# Seleccionar un diseño al azar
	randomize() # Inicializa el generador de números aleatorios
	var random_design = randi_range(0, designs.size() - 1)
	selected_design = designs[random_design]
	
	# Configurar las animaciones iniciales según el diseño seleccionado
	animated_sprite.play("walk_" + selected_design)

	timer.wait_time = timer_seconds
	
	# Generar money de forma aleatoria
	money = randf_range(min_money, max_money)

func stop_walk(area: Area2D):
	area.timer.stop()
	area.animated_sprite.play("idle_" + area.selected_design) # Usa el diseño seleccionado

func start_walk(area: Area2D):
	area.timer.start()
	area.animated_sprite.play("walk_" + area.selected_design)

func wait_and_walk(reason: String, time = 0):
	emoji.text = REACTION.WAIT
	emoji.show()
	
	is_in_cart = true
	await get_tree().create_timer(time).timeout
	
	if reason == "normal":
		# Todo Colocar emoji de espera
		emoji.text = REACTION.NORMAL
		emoji.show()
		Global.sell.emit()
	
	if reason == "no_money":
		# TODO Colocar emoji sin dinero
		emoji.text = REACTION.NO_MONEY
		emoji.show()
	
	start_walk(self)
	is_in_cart = false
	
	# Colocar emoji de reacción, si le gustó o no le gustó la limonada (propina)

# Detectar el carrito de ventas y parar
func _on_area_entered(area: Area2D) -> void:
	if area is Cart:
		stop_walk(self) # Me detengo

# Detectó una persona atrás
func _on_area_2d_back_area_entered(area: Area2D) -> void:
	if area is Person:
		stop_walk(area) # Que se detenga el de atrás

func _on_area_2d_back_area_exited(area: Area2D) -> void:
	if area is Person and area.is_in_cart == false:
		start_walk(area) # Aquí hago que camine el de atrás
		
# Manejar el avance del camino
func _on_timer_timeout() -> void:
	path_follow_2d.progress_ratio += 0.01
	if path_follow_2d.progress_ratio >= 1:
		path_follow_2d.queue_free()
		queue_free()
		
