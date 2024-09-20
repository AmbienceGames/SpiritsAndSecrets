extends Node2D

@export
var pickup: bool
@export
var image: Texture
@export
var half_image: Texture
@export
var empty_image: Texture
@export
var is_bottle: bool
@export
var count: int = -1
@export
var price: int = -1
@export
var has_label = true
@export
var unlocked = true
@export
var unlock_cost = 0

var curr_count

var is_dragging = false
var is_removing = false
var place

var normal_color: Color = Color(1, 1, 1, 1) # Full brightness (white)
var locked_color: Color = Color(0.3, 0.3, 0.3, 1) # Darkened color

func _ready():
	if pickup:
		$Outside.show()
	else:
		$Outside.scale = Vector2(.5,.5)
	
	$Outside.texture = image
	place = position
	curr_count = count
	set_label()
	if not unlocked:
		$Outside.modulate = locked_color
		$Label.text = self.name + "\nLocked! Click to unlock for " + str(unlock_cost) + " Gold."
	else:
		Globals.unlocked_ingredients.append(self.name.substr("Ingredients".length()))
func _process(delta):
	if unlocked:
		if is_dragging:
			global_position = get_global_mouse_position()
		if curr_count >= 0:
			if curr_count == 0 and pickup:
				$Outside.texture = empty_image
			elif curr_count <= count / 2 and pickup:
				$Outside.texture = half_image
	
		


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if unlocked:
			if event.pressed and curr_count != 0:
				is_dragging = true
				self.z_index = 2
				if not pickup:
					$Outside.show()
			else:
				is_dragging = false
				position = place
				self.z_index = 0
				if not pickup:
					$Outside.hide()
				if is_removing and curr_count > 0:
					$Label.hide()
					curr_count -= 1
					set_label()
		else:
			if not event.pressed and unlock_cost <= Globals.player_balance:
				$Outside.modulate = normal_color
				unlocked = true
				Globals.player_balance -= unlock_cost
				set_label()
				Globals.unlocked_ingredients.append(name.substr("Ingredients".length()))

func _on_area_2d_area_entered(area):
	if area.get_parent().name == "Drink":
		is_removing = true

func _on_area_2d_area_exited(area):
	if area.get_parent().name == "Drink":
		is_removing = false

func set_label():
	$Label.text = self.name + "\nCount: " + str(curr_count) + "\nPrice per Count:" + str(price)
	
func _on_area_2d_mouse_entered():
	if has_label:
		$Label.show()
		z_index = 1


func _on_area_2d_mouse_exited():
	if has_label:
		$Label.hide()
		z_index = 0
