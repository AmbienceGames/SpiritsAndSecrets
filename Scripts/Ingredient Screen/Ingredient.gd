extends Node2D

@export
var pickup: bool
@export
var image: Texture
@export
var is_bottle: bool
@export
var count: int

var is_dragging = false
var place

func _ready():
	if pickup:
		$Outside.show()
	else:
		$Outside.scale = Vector2(.5,.5)
	$Outside.texture = image
	place = position
	
	
func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position()


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			self.z_index = 1
			if not pickup:
				$Outside.show()
		else:
			is_dragging = false
			position = place
			self.z_index = 0
			if not pickup:
				$Outside.hide()
