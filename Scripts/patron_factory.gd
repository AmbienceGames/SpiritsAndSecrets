extends Node2D

@export
var bar_patrons: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bar_patrons = Globals.get_cast_for_day()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_random_patron() -> Patron:
	if len(bar_patrons) == 0:
		return null
	var index = randi() % len(bar_patrons)
	var patron: Patron = get_instance(bar_patrons.pop_at(index))
	return patron

func get_instance(patron_scene: PackedScene) -> Patron:
	var patron = patron_scene.instantiate() as Patron
	return patron

func add_patron(patron: Patron) -> void:
	var p = PackedScene.new()
	p.pack(patron)
	bar_patrons.append(p)
	
