class_name Person
extends Area2D

@export var path_follow_2d: PathFollow2D # Referencia al PathFollow2D
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var emoji: Label = $Emoji

var timer_seconds = 0.1
var flag_person_died := false
var is_in_cart := false

# Lista de diseños disponibles
const DESIGNS = ["green_gobling", "blue_knight", "red_archer"] # Agrega tantos diseños como necesites
var selected_design: String

var money := 1.0
var min_money := 0.0
var max_money := 5.0

# 💰😵😵‍💫🥺💸💵
const REACTION = {
	"WAIT": "⌛",
	"NORMAL": "🍋",
	"NO_MONEY": "💵👎",
	"DIED": "💀"
}

func _ready() -> void:
	emoji.hide()
	# Seleccionar un diseño al azar
	var random_design = randi_range(0, DESIGNS.size() - 1)
	selected_design = DESIGNS[random_design]
	
	# Configurar las animaciones iniciales según el diseño seleccionado
	animated_sprite.play("walk_" + selected_design)

	timer.wait_time = timer_seconds
	
	# Generar dinero de forma aleatoria
	money = randf_range(min_money, max_money)

# state: "idle_", "walk_"
func play_animation(state):
	animated_sprite.play(state + selected_design) # Usa el diseño seleccionado

func stop_walk():
	if flag_person_died: return
	timer.stop()
	play_animation("idle_")

func start_walk():
	if flag_person_died: return
	timer.start()
	play_animation("walk_")
	
func emoji_show(reaction: String):
	emoji.text = reaction
	emoji.show()

func wait_and_walk(reason: String, time = 0):	
	emoji_show(REACTION.WAIT)
	
	is_in_cart = true
	
	await get_tree().create_timer(time).timeout
	
	if reason == "normal":
		emoji_show(REACTION.NORMAL)
		Global.sell.emit()
	
	if reason == "no_money":
		emoji_show(REACTION.NO_MONEY)
	
	start_walk()
	is_in_cart = false
	
# Detectar el carrito de ventas y parar
func _on_area_entered(area: Area2D) -> void:
	if area is Cart:
		stop_walk() # Me detengo

# Detectó una persona atrás
func _on_area_2d_back_area_entered(area: Area2D) -> void:
	if area is Person:
		area.stop_walk() # Que se detenga el de atrás

func _on_area_2d_back_area_exited(area: Area2D) -> void:
	if area is Person and area.is_in_cart == false:
		area.start_walk() # Aquí hago que camine el de atrás
		
# Manejar el avance del camino
func _on_timer_timeout() -> void:
	path_follow_2d.progress_ratio += 0.01
	if path_follow_2d.progress_ratio >= 1:
		path_follow_2d.queue_free()
		queue_free()

func person_explotion():
	# Desactivar colisiones
	$CollisionShape2D.disabled = true
	$Area2DBack/CollisionShape2D.disabled = true
	
	flag_person_died = true
	timer.stop()
	emoji_show(REACTION.DIED)
	animated_sprite.play("tnt")

# Cuando termina la animación de explosión
func _on_animated_sprite_2d_animation_finished() -> void:
	if flag_person_died:
		queue_free()
	if animated_sprite.animation == "tnt":
		queue_free()
