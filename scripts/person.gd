class_name Person
extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass
