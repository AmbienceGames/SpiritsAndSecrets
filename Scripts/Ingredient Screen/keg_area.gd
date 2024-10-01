extends Node2D

class_name KegArea

@export
var whats_inside: String

@export
var jar_texture: Texture

var time_to_fill = 0.5
var drink

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = jar_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_time_to_fill_timeout() -> void:
	drink.add_ingredient(whats_inside)
	Globals.current_stars = 0


func _on_area_2d_area_entered(area):
	if area.get_parent().name == "Drink":
		drink = area.get_parent()
		$TimeToFill.start(time_to_fill)


func _on_area_2d_area_exited(area):
	if area.get_parent().name == "Drink":
		drink = area.get_parent()
		$TimeToFill.stop()
