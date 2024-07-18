extends Node2D

@export
var possible_patrons: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_random_patron() -> Patron:
	var base: PackedScene = possible_patrons.pick_random()
	var patron = get_instance(base)

	return patron

func get_instance(patron_scene: PackedScene) -> Patron:
	var patron = patron_scene.instantiate() as Patron
	patron._ready()
	return patron