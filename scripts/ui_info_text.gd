extends Node2D

@onready var background: Sprite2D = $Background
@onready var label: Label = $Label
@onready var animated: AnimatedSprite2D = $Animated

func _ready() -> void:
	pass

func update_text(text: String):
	label.text = text

func animate():
	animated.play("sell")
	
