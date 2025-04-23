class_name Player extends CharacterBody2D

@export var animated_sprite:AnimatedSprite2D
@export var state_chart:StateChart

const SPEED := 150.0
const CLIMBING_VELOCITY := -50.0
const JUMP_VELOCITY := -300.0

var direction := 0.0

func _physics_process(_delta:float) -> void:
	if signf(velocity.x) != 0:
		animated_sprite.flip_h = velocity.x < 0
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _on_visible_on_screen_notifier_screen_exited():
	position.x = 0

#region Gravity state
func _on_ladder_area_area_entered(_area: Area2D) -> void:
	state_chart.send_event(PLAYER_STATES.IS_CLIMBING)

func _on_rope_area_area_entered(_area: Area2D) -> void:
	state_chart.send_event(PLAYER_STATES.IS_SWINGING)

func _on_gravity_state_physics_processing(delta: float) -> void:
	velocity += get_gravity() * delta
#endregion

#region NoGravity state
func _on_rope_area_area_exited(_area: Area2D) -> void:
	state_chart.send_event(PLAYER_STATES.HAS_GRAVITY)

func _on_ladder_area_area_exited(_area: Area2D) -> void:
	state_chart.send_event(PLAYER_STATES.HAS_GRAVITY)

func _on_no_gravity_state_entered() -> void:
	animated_sprite.play(PLAYER_ANIMATIONS.IDLE_CLIMB)
	velocity = Vector2.ZERO

func _on_no_gravity_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action("jump"):
		state_chart.send_event(PLAYER_STATES.STARTED_JUMPING)
#endregion

#region Grounded state 
func _on_grounded_state_processing(_delta: float) -> void:
	if not is_on_floor():
		state_chart.send_event(PLAYER_STATES.IS_ON_AIR)
	
func _on_grounded_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		state_chart.send_event(PLAYER_STATES.STARTED_JUMPING)
#endregion

#region Jump state
func _on_jump_state_entered() -> void:
	velocity.y = JUMP_VELOCITY
	animated_sprite.play(PLAYER_ANIMATIONS.JUMP)
func _on_jump_state_physics_processing(_delta: float) -> void:
	if velocity.y > 0:
		state_chart.send_event(PLAYER_STATES.STARTED_FALLING)
#endregion

#region Falling state
func _on_falling_state_entered() -> void:
	animated_sprite.play(PLAYER_ANIMATIONS.JUMP)

func _on_falling_state_physics_processing(_delta: float) -> void:
	if is_on_floor():
		state_chart.send_event(PLAYER_STATES.IS_ON_GROUND)
#endregion

#region Idle state
func _on_idle_state_entered() -> void:
	animated_sprite.play(PLAYER_ANIMATIONS.IDLE)

func _on_idle_state_physics_processing(_delta: float) -> void:
	if direction:
		state_chart.send_event(PLAYER_STATES.STARTED_WALKING)
#endregion

#region Walking state
func _on_walking_state_entered() -> void:
	animated_sprite.play(PLAYER_ANIMATIONS.WALK)

func _on_walking_state_physics_processing(_delta: float) -> void:
	if not direction:
		state_chart.send_event(PLAYER_STATES.STOPPED_WALKING)
#endregion

#region Climbing state
func _on_climbing_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("climb"):
		animated_sprite.play(PLAYER_ANIMATIONS.CLIMB)
		velocity.y = CLIMBING_VELOCITY
#endregion
