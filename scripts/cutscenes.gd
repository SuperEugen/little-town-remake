extends CanvasLayer

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
	if Global.gameOver:
		Global.showCutscene("gameOver")
	else:
		Global.playerCanMove = true
		Global.musicPlayer.set_stream_paused(false)
		Global.ambiencePlayer.set_stream_paused(false)
