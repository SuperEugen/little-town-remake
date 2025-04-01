extends Node

var sfxGreeting: Resource = preload("res://assets/audio/snd_greeting01.wav")
var sfxPickUp: Resource = preload("res://assets/audio/snd_itemPickup.wav")
var sfxPutDown: Resource = preload("res://assets/audio/snd_itemPutDown.wav")
var sfxDialogOpen: Resource = preload("res://assets/audio/snd_pop01.wav")
var sfxPromptOpen: Resource = preload("res://assets/audio/snd_pop02.wav")

enum SFX {GREETING, PICK_UP, PUT_DOWN, DIALOG_OPEN, PROMPT_OPEN}

var fadeSpeed: float = 0.5		# time in seconds for fading in and out

var dialogScene: Resource = preload("res://scenes/dialog_box.tscn")
var dialogInstance: Node  = null

var promptScene: Resource = preload("res://scenes/prompt.tscn")
var promptInstance: Node  = null

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
