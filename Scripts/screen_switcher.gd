extends Node2D

@export
var tavern_screens: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tavern_screens[0].visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
