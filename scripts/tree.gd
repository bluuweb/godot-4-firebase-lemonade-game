extends Node2D

@onready var timer_spaw_lemon: Timer = $TimerSpawLemon
@onready var lemon: Sprite2D = $Area2D/Lemon
@onready var animated_tnt: AnimatedSprite2D = $Area2D/AnimatedTNT
@onready var timer_explotion: Timer = $TimerExplotion

var timeLemon = 3
var item_is_active = false
var second_active_tnt = 3 # tiempo para desactivar la bomba sino explota
var item_active

func _ready() -> void:
	# Me conecto a la señal de game start
	$"../../UI".connect("game_start", game_start)
	
	lemon.hide()
	animated_tnt.hide()
	# Desactivar collisionShape
	$Area2D/CollisionShape2D.disabled = true
	
	timer_explotion.wait_time = second_active_tnt
	
func game_start():
	timer_spaw_lemon.wait_time = timeLemon
	timer_spaw_lemon.start()

# Temporizador para que aparezcan los limones y tnt
func _on_timer_spaw_lemon_timeout() -> void:
	if !item_is_active:
		item_active = randi_range(1, 2)
		if item_active == 1:
			lemon.show()
		if item_active == 2:
			animated_tnt.show()
			animated_tnt.play("tnt")
			timer_explotion.start() #activar tiempo limite y sino explotar
			
		item_is_active = true
		timer_spaw_lemon.stop()
		$Area2D/CollisionShape2D.disabled = false

func bomb_explote():
	item_is_active = false
	timer_spaw_lemon.start()
	$Area2D/CollisionShape2D.disabled = true
	animated_tnt.play("explotion")
	var person_nodes = $"../..".get_tree().get_nodes_in_group("people")
	for person in person_nodes:
		person.person_explotion() # Aquí explotan y queue_free

	# TODO: Revisar por qué algunos siguen vivos al explotar

func bomb_disable():
	animated_tnt.hide()
	item_is_active = false
	timer_spaw_lemon.start()
	$Area2D/CollisionShape2D.disabled = true
	timer_explotion.stop()

# Detectar clic
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if item_active == 2:
				bomb_disable()
				return
				
		# Cuando se hace click izquierdo
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if item_active == 1:
				item_is_active = false
				timer_spaw_lemon.start()
				$Area2D/CollisionShape2D.disabled = true
				lemon.hide()
				Global.update_stock(1)
			else: # Aquí explota la bomba
				bomb_explote()

# Aquí cuando termina la animación de TNT
func _on_animated_tnt_animation_finished() -> void:
	if animated_tnt.animation == "explotion":
		animated_tnt.hide()

# Cuando terminé explota la bomba
func _on_timer_explotion_timeout() -> void:
	bomb_explote()
