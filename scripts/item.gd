class_name Item

extends StaticBody2D

enum STATE {IDLE, TAKEN, USED}

@export var itemName: String = "item"
@export var itemWeight: float = 1.0

var itemState = STATE.IDLE
