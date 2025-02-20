extends Node2D

@onready var path_2d: Path2D = $Path2D

const PERSON = preload("res://scenes/person.tscn")

func _ready() -> void:
    generate_person()

func generate_person():
    var random_time = randf_range(3, 3)
    
    await get_tree().create_timer(random_time).timeout
    
    # Contar cuántas personas existen en el grupo
    var people_count = get_tree().get_nodes_in_group("people").size()
    print("Número de personas: ", people_count)
    if people_count < 5:
        # Crear una nueva persona
        var person = PERSON.instantiate()
        
        # Crear el PathFollow2D
        var path_follow_2d = PathFollow2D.new()
        path_follow_2d.loop = false
        path_2d.add_child(path_follow_2d)
        
        # Asignar el PathFollow2D a la persona
        person.path_follow_2d = path_follow_2d
        path_follow_2d.add_child(person)
        
        # Agregar la persona al grupo "people"
        person.add_to_group("people")
        
    generate_person()
