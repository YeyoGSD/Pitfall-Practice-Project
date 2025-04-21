extends Node2D

func _on_ladder_body_entered(body: Node2D) -> void:
	if body is Player:
		body.state_chart.send_event(PLAYER_STATES.STARTED_CLIMBING)

func _on_ladder_body_exited(body: Node2D) -> void:
	if body is Player:
		body.state_chart.send_event(PLAYER_STATES.IS_ON_GROUND)
