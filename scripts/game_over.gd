extends CanvasLayer

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	# game over animation is over i.e. the game is over
	get_tree().quit()
