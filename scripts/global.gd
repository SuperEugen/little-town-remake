extends Node

var sfxGreeting: Resource = preload("res://assets/sfx/snd_greeting.wav")
var sfxPickUp: Resource = preload("res://assets/sfx/snd_pick_up.wav")
var sfxPutDown: Resource = preload("res://assets/sfx/snd_put_down.wav")
var sfxDialogOpen: Resource = preload("res://assets/sfx/snd_plop.wav")
var sfxPromptOpen: Resource = preload("res://assets/sfx/snd_click.wav")

enum SFX {GREETING, PICK_UP, PUT_DOWN, DIALOG_OPEN, PROMPT_OPEN}

var fadeSpeed: float = 0.5		# time in seconds for fading in and out dialogs and prompts

var dialogScene: Resource = preload("res://scenes/dialog_box.tscn")
var dialogInstance: Node  = null

var promptScene: Resource = preload("res://scenes/prompt.tscn")
var promptInstance: Node  = null

var dustCloudScene: Resource = preload("res://scenes/dust_cloud.tscn")
var dustCloudInstance: Node = null

var cutsceneBakerHappy: Resource = preload("res://scenes/cutscene_baker_happy.tscn")
var cutsceneBakerSad: Resource = preload("res://scenes/cutscene_baker_sad.tscn")
var cutsceneGrocerHappy: Resource = preload("res://scenes/cutscene_grocer_happy.tscn")
var cutsceneGrocerSad: Resource = preload("res://scenes/cutscene_grocer_sad.tscn")
var cutsceneTeacherHappy: Resource = preload("res://scenes/cutscene_teacher_happy.tscn")
var cutsceneTeacherSad: Resource = preload("res://scenes/cutscene_teacher_sad.tscn")
var cutsceneGameOver: Resource = preload("res://scenes/game_over.tscn")
var cutsceneInstance: Node = null

var playerCanMove: bool = true
var gameOver: bool = false

@onready var musicPlayer: AudioStreamPlayer = get_node("/root/Town/BGMusic")
@onready var ambiencePlayer: AudioStreamPlayer = get_node("/root/Town/BGAmbience")

func playSFX(sfx: SFX) -> void:
	var asp := AudioStreamPlayer.new()
	var stream: Resource = null
	
	match sfx:
		SFX.GREETING:
			stream = sfxGreeting
		SFX.PICK_UP:
			stream = sfxPickUp
		SFX.PUT_DOWN:
			stream = sfxPutDown
		SFX.DIALOG_OPEN:
			stream = sfxDialogOpen
		SFX.PROMPT_OPEN:
			stream = sfxPromptOpen
	
	asp.stream = stream
	asp.name = "SFX"
	add_child(asp)
	
	asp.play()
	await asp.finished
	asp.queue_free()

func fadeInDialog(char: CharacterBody2D, dialog: String) -> void:
	playerCanMove = false
	Global.playSFX(Global.SFX.DIALOG_OPEN)
	
	dialogInstance = dialogScene.instantiate()
	var lbl = dialogInstance.get_node("Label")
	lbl.set("text", dialog)
	
	char.add_child(dialogInstance)
	
	dialogInstance.set("modulate", Color.TRANSPARENT)
	var tween = dialogInstance.create_tween()
	tween.tween_property(dialogInstance, "modulate", Color.WHITE, fadeSpeed)

func fadeOutDialog(char: CharacterBody2D) -> void:
	var tween = dialogInstance.create_tween()
	tween.tween_property(dialogInstance, "modulate", Color.TRANSPARENT, fadeSpeed)
	tween.tween_callback(dialogInstance.queue_free)
	playerCanMove = true

func fadeInPrompt(char: CharacterBody2D) -> void:
	Global.playSFX(Global.SFX.PROMPT_OPEN)
	
	if promptInstance == null:
		promptInstance = promptScene.instantiate()
	
	char.add_child(promptInstance)
	
	promptInstance.set("modulate", Color.TRANSPARENT)
	var tween = promptInstance.create_tween()
	tween.tween_property(promptInstance, "modulate", Color.WHITE, fadeSpeed)

func fadeOutPrompt(char: CharacterBody2D) -> void:
	if promptInstance != null:
		var tween = promptInstance.create_tween()
		tween.tween_property(promptInstance, "modulate", Color.TRANSPARENT, fadeSpeed)
		tween.tween_callback(promptInstance.queue_free)

func createDustCloud(char: CharacterBody2D) -> void:
	char.get_parent()
	dustCloudInstance = dustCloudScene.instantiate()
	
	var scale = randf_range(0.8, 1.2)
	dustCloudInstance.set("scale", Vector2(scale, scale))
	# dust cloud is up a little to appear behind player
	dustCloudInstance.set("global_position", Vector2(char.global_position.x, \
													 char.global_position.y - 30))
	
	var tweenRotation = dustCloudInstance.create_tween()
	var tweenDrift = dustCloudInstance.create_tween()
	var tweenFade = dustCloudInstance.create_tween()
	tweenRotation.tween_property(dustCloudInstance, "rotation", \
			randf_range(5, 20), 4)
	tweenDrift.tween_property(dustCloudInstance, "position", \
			Vector2(char.global_position.x, char.global_position.y - randf_range(100, 400)), 4)
	tweenFade.tween_property(dustCloudInstance, "modulate", \
			Color.TRANSPARENT, randf_range(0.2, 0.8))
	tweenFade.tween_callback(dustCloudInstance.queue_free)
	
	char.add_sibling(dustCloudInstance)

func showCutscene(name: String) -> void:	
	playerCanMove = false
	
	musicPlayer.set_stream_paused(true)
	ambiencePlayer.set_stream_paused(true)
	
	match name:
		"bakerHappy":
			cutsceneInstance = cutsceneBakerHappy.instantiate()
		"bakerSad":
			cutsceneInstance = cutsceneBakerSad.instantiate()
		"grocerHappy":
			cutsceneInstance = cutsceneGrocerHappy.instantiate()
		"grocerSad":
			cutsceneInstance = cutsceneGrocerSad.instantiate()
		"teacherHappy":
			cutsceneInstance = cutsceneTeacherHappy.instantiate()
		"teacherSad":
			cutsceneInstance = cutsceneTeacherSad.instantiate()
		"gameOver":
			cutsceneInstance = cutsceneGameOver.instantiate()
	
	get_node("/root/Town/Cutscenes").add_child(cutsceneInstance)
