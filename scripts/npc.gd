class_name NPC

extends CharacterBody2D

# seconds to wait for next idle animation
@export var minIdleWait: float = 1.0
@export var maxIdleWait: float = 5.0
@export var npcText: String = "Howdy"

@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D
var timerNode: Node = null

func _ready() -> void:
	animSprite.animation_finished.connect(_on_animation_finished)
	
	timerNode = Timer.new()
	timerNode.name = "idleTimer"
	timerNode.timeout.connect(_on_idle_timer_timeout)
	add_child(timerNode)

func _on_animation_finished() -> void:
	timerNode.wait_time = randf_range(minIdleWait, maxIdleWait)
	timerNode.start()

func _on_idle_timer_timeout() -> void:
	animSprite.play("idleDown")
