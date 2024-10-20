# TODO: Mejorar el manejo de las animaciones
extends CharacterBody2D

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta:float) -> void:
	apply_gravity(delta)
	input_movement()
	move_and_slide()

func apply_gravity(delta:float) -> void:
	if not is_on_floor():
		animated_sprite.play("jump")
		velocity += get_gravity() * delta

func input_movement() -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		animated_sprite.flip_h = direction < 0
		velocity.x = direction * SPEED
		if is_on_floor():
			animated_sprite.play("walk")
	else:
		if is_on_floor():
			animated_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _unhandled_key_input(event:InputEvent) ->void:
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
