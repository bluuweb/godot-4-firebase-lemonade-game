extends AnimatedSprite2D

func animate_gold():
	show()
	play("sell")
	
	# Crea una instancia de Tween, que es un nodo para realizar interpolaciones (animaciones).
	var tween: Tween = get_tree().create_tween()
	# Anima la propiedad "modulate:a" (la transparencia alfa) de este objeto (self) de 1.0 a 0.0 en 2 segundos.
	# Esto hace que el bloque se desvanezca visualmente.
	tween.tween_property(self, "modulate:a", 0.0, 2)
	# Después de completar la animación, ejecuta el método `finish_animation()`.
	tween.tween_callback(finish_animation)
	
# Método que se llama cuando la animación de destrucción termina.
func finish_animation():
	# Elimina el nodo del árbol de nodos, lo que significa que el bloque es destruido por completo.
	queue_free()
