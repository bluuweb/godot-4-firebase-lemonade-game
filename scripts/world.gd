extends Node2D

@onready var path_2d: Path2D = $Path2D
@onready var path_2d_2: Path2D = $Path2D2

const PERSON = preload("res://scenes/person.tscn")

@onready var paths_array: Array[Path2D] = [path_2d, path_2d_2]
@onready var pathSelected: Path2D = path_2d
@onready var ui: CanvasLayer = $UI

@onready var label_level_time_out: Label = $TimeLevel/LevelTimeOut
@onready var timer_level: Timer = $TimeLevel/TimerLevel

var max_peoples := 10

func _ready() -> void:
	# Opcion conectando la señal
	#get_node("UI").get_node("ModalBuyStock").connect("game_start", game_start)
	pass
	
func game_start():
	get_tree().paused = false
	$TimeLevel/LevelTimeOut.text = str(Global.time_game)
	label_level_time_out.show()
	timer_level.start()
	generate_person()

# Para testear
var path1 := true

# Personas en el grupo
func people_active():
	return get_tree().get_nodes_in_group("people")

func generate_person():
	# Cuanto se demora en salir una nueva persona
	var time_out_new_person = randf_range(1, 3)
	
	#pathSelected = paths_array[randi_range(0, paths_array.size() - 1)]
	
	#pathSelected = paths_array[0 if path1 == true else 1]
	#path1 = !path1
	
	pathSelected = paths_array[0]
	await get_tree().create_timer(time_out_new_person).timeout
	if people_active().size() < max_peoples:
		# Crear una nueva persona
		var person = PERSON.instantiate()
		
		# Crear el PathFollow2D
		var path_follow_2d = PathFollow2D.new()
		path_follow_2d.loop = false
		pathSelected.add_child(path_follow_2d)
		
		# Asignar el PathFollow2D a la persona
		person.path_follow_2d = path_follow_2d
		path_follow_2d.add_child(person)
		
		# Agregar la persona al grupo "people"
		person.add_to_group("people")
		
	generate_person()

# Temporizador del nivel
func _on_timer_level_timeout() -> void:
	if Global.time_game <= 0:
		Global.time_game = 30
		#$UI/ModalBuyStock.show()
		$UI/ModalBuyStock.show_modal()
		get_tree().paused = true
		return
	
	Global.time_game -= 1
	label_level_time_out.text = str(Global.time_game)
