extends Sprite2D

var parent;

func _ready() -> void:
	parent = get_parent()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and \
			event.pressed and event.button_index == MOUSE_BUTTON_LEFT and \
			get_rect().has_point(to_local(event.position)):
		parent.sprite_clicked.emit(parent)
