class_name Player

extends CharacterBody2D

enum STATE {IDLE, WALKING, PICKING_UP, PUTTING_DOWN, CARRY_IDLE, CARRY_WALKING}

enum DIR {LEFT, RIGHT, UP, DOWN}

@export var walkSpeed: float = 300.0		# pixel / second
@export var runSpeed: float = 600.0			# pixel / second

@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D

var actionPossible: bool = false			# i.e. talking or picking up an item

var detectedBody: Node2D = null
var dialogActive = false
var hasItem: Node2D = null
var carryLimit: float = 1.0
var playerState: STATE = STATE.IDLE
var playerDirection: DIR = DIR.DOWN

func _ready() -> void:
	playerState = STATE.IDLE
	Global.playerCanMove = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("test"):
		pass	# Global.showCutscene("teacherSad")
	
func _physics_process(delta: float) -> void:
	# don't move during dialog
	if Global.playerCanMove:
		var dirInput := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		if dirInput == Vector2.ZERO:
			if hasItem == null:
				playerState = STATE.IDLE
			else:
				playerState = STATE.CARRY_IDLE
			velocity = Vector2.ZERO
		else:
			if hasItem == null:
				playerState = STATE.WALKING
			else:
				playerState = STATE.CARRY_WALKING

			if Input.is_action_pressed("shift"):
				velocity = dirInput * runSpeed
				Global.createDustCloud(self)
			else:
				velocity = dirInput * walkSpeed

			velocity *= carryLimit
		
		if dirInput.x > 0:
			playerDirection = DIR.RIGHT
		elif dirInput.x < 0:
			playerDirection = DIR.LEFT
		elif dirInput.y > 0:
			playerDirection = DIR.DOWN
		elif dirInput.y < 0:
			playerDirection = DIR.UP
		# otherwise don't change dirFacing
	
	if actionPossible or hasItem != null:
		if Input.is_action_just_pressed("space"):
			if detectedBody is NPC:
				if hasItem == null:
					if dialogActive:
						Global.fadeOutDialog(detectedBody)
						dialogActive = false
					else:
						playerState = STATE.IDLE
						velocity = Vector2.ZERO
						dialogActive = true
						Global.fadeOutPrompt(self)
						Global.fadeInDialog(detectedBody, detectedBody.npcText)
				else:
					if hasItem == detectedBody.npcItem:
						if dialogActive:
							Global.fadeOutDialog(detectedBody)
							dialogActive = false
							detectedBody.npcDone = true
							hasItem.queue_free()
							carryLimit = 1.0
							detectedBody.setHappy()
							Global.showCutscene(detectedBody.cutsceneHappy)
						else:
							playerState = STATE.IDLE
							velocity = Vector2.ZERO
							dialogActive = true
							Global.fadeOutPrompt(self)
							Global.fadeInDialog(detectedBody, detectedBody.itemTextHappy)
					else:
						if dialogActive:
							Global.fadeOutDialog(detectedBody)
							dialogActive = false
							Global.showCutscene(detectedBody.cutsceneSad)
						else:
							playerState = STATE.IDLE
							velocity = Vector2.ZERO
							dialogActive = true
							Global.fadeOutPrompt(self)
							Global.fadeInDialog(detectedBody, detectedBody.itemTextSad)

			else:
				if hasItem == null:
					Global.playerCanMove = false
					playerState = STATE.PICKING_UP
					velocity = Vector2.ZERO
					hasItem = detectedBody
					carryLimit = detectedBody.itemWeight
					hasItem.itemState = Item.STATE.TAKEN
					Global.fadeOutPrompt(self)
					Global.playSFX(Global.SFX.PICK_UP)
					# when animation finished state will be changed to carry idle
				else:
					Global.playerCanMove = false
					playerState = STATE.PUTTING_DOWN
					velocity = Vector2.ZERO
					carryLimit = 1.0
					hasItem.itemState = Item.STATE.IDLE
					hasItem = null
					Global.playSFX(Global.SFX.PUT_DOWN)
					# when animation finished state will be changed to idle					
	
	animatePlayer()
	move_and_slide()

	if hasItem != null:
		match playerDirection:
			DIR.UP:
				hasItem.global_position = Vector2(global_position.x, \
												  global_position.y - 90)
			DIR.DOWN:
				hasItem.global_position = Vector2(global_position.x, \
												  global_position.y - 70)
			# TODO: put item behind player
			DIR.LEFT:
				hasItem.global_position = Vector2(global_position.x - 50, \
												  global_position.y - 90)
			# TODO: put item behind player
			DIR.RIGHT:
				hasItem.global_position = Vector2(global_position.x + 50, \
												  global_position.y - 90)
			# TODO: put item behind player

func _on_awareness_body_entered(body: Node2D) -> void:
	if body is NPC:
		if !body.npcDone:
			Global.fadeInPrompt(self)
			detectedBody = body
			actionPossible = true
			Global.playSFX(Global.SFX.GREETING)
	elif body is Item:
		Global.fadeInPrompt(self)
		detectedBody = body
		actionPossible = true

func _on_awareness_body_exited(body: Node2D) -> void:
	detectedBody = null
	actionPossible = false
	# prompt might already be null if dialog with NPC was started
	if $Prompt != null:
		Global.fadeOutPrompt(self)

func _on_animated_sprite_2d_animation_finished() -> void:
	if playerState == STATE.PICKING_UP:
		playerState = STATE.CARRY_IDLE
		Global.playerCanMove = true
	if playerState == STATE.PUTTING_DOWN:
		playerState = STATE.IDLE
		Global.playerCanMove = true

func animatePlayer() -> void:
	var animPrefix: String = ""
	var animPostfix: String = ""

	match playerState:
		STATE.IDLE:
			animPrefix = "idle"
		STATE.WALKING:
			animPrefix = "walk"
		STATE.PICKING_UP:
			animPrefix = "pickup"
		STATE.PUTTING_DOWN:
			animPrefix = "putdown"
		STATE.CARRY_IDLE:
			animPrefix = "carryIdle"
		STATE.CARRY_WALKING:
			animPrefix = "carryWalk"
	
	match playerDirection:
		DIR.LEFT:
			animPostfix = "Left"
		DIR.RIGHT:
			animPostfix = "Right"
		DIR.UP:
			animPostfix = "Up"
		DIR.DOWN:
			animPostfix = "Down"
	
	animSprite.play(animPrefix + animPostfix)
