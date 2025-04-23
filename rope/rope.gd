extends Marker2D

@export var player:Player
@export var hook_area:Area2D

const MAX_ROTATION := PI/4
const ROTATION_SPEED := PI/2

var rotation_direction := -1

func _process(delta):
	if player and not player.velocity.y:
		player.global_position = hook_area.global_position
	
	if abs(rotation) >= MAX_ROTATION:
		rotation_direction *= -1 
	rotate(ROTATION_SPEED * rotation_direction * delta)

func _on_hook_area_area_entered(area: Area2D) -> void:
	player = area.owner as Player

func _on_hook_area_area_exited(_area: Area2D) -> void:
	player = null
