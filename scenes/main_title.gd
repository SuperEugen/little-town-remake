extends CanvasLayer

@onready var sprite = $BG/ParallaxLayer/Sprite2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/town.tscn")
		Global.playBGMAndAmbience()

	sprite.region_rect.position += delta * Vector2(15,15)
	if sprite.region_rect.position >= Vector2(720, 743):
		sprite.region_rect.position = Vector2.ZERO
