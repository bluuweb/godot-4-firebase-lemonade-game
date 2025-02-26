# Juego de vender limonadas a los humildes guerros antes de su batalla épica.

## Recursos

- [https://pixelfrog-assets.itch.io/tiny-swords](https://pixelfrog-assets.itch.io/tiny-swords)

## Tween

- [https://docs.godotengine.org/es/4.x/classes/class_tween.html](https://docs.godotengine.org/es/4.x/classes/class_tween.html)
- [https://easings.net/](https://easings.net/)
- [https://raw.githubusercontent.com/godotengine/godot-docs/master/img/tween_cheatsheet.webp](https://raw.githubusercontent.com/godotengine/godot-docs/master/img/tween_cheatsheet.webp)

Ejemplo básico:

```py
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var tween = create_tween()
	# var tween = create_tween().set_parallel(true) # Hacer que se ejecuten en paralelo

	tween.tween_property(sprite_2d, "position", Vector2(200, 200), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite_2d, "rotation", deg_to_rad(360), 2.0)
	tween.tween_property(sprite_2d, "modulate", Color(1,1,1,0), 2.0)

	tween.tween_callback(finished_tween)

func finished_tween():
	sprite_2d.queue_free()
	print("terminó la animación")
```
