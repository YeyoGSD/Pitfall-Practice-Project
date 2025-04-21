extends Node2D

func _on_ladder_body_entered(body: Player) -> void:
	body.state_chart.send_event(PLAYER_STATES.STARTED_CLIMBING)

func _on_ladder_body_exited(body: Player) -> void:
	body.state_chart.send_event(PLAYER_STATES.IS_ON_GROUND)
