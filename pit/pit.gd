extends Area2D

func _process(delta: float) -> void:
	print (scale.x)
	scale.x += 1 * delta
	scale.x = clampf(scale.x, 0.3, 1.0)
