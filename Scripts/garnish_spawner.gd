extends Node2D

var active = false

@export
var jar_texture: Texture

@export
var garnish_scene: PackedScene

@export
var garnish_name: String

@export
var garnish_flavors: Array[String]

var garnish: PackedScene
var content: Garnish
var label
# Called when the node enters the scene tree for the first time.
func _ready():
	label = find_child("Label")
	label.text = garnish_name
	garnish = load("res://Scenes/garnish.tscn")
	content = Garnish.new()
	content.garnish_name = garnish_name
	content.flavors = garnish_flavors
	content.cost = 0
	print(content)
	self.find_child("Sprite2D").texture = jar_texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#when this is clicked, if possible, it creates a glass, and sets it to drag
	if Input.is_action_just_pressed("click") and not Globals.is_dragging and active:
		var g = garnish.instantiate()
		g.sprite_scene = garnish_scene
		self.get_parent().add_child(g)
		content.texture = g.get_child(2).texture
		Globals.is_dragging = true
		g.contents.add(content)
		g.draggable = true
		g.global_position = get_global_mouse_position()


func _on_area_2d_mouse_entered():
	if not Globals.is_dragging:
		active = true
		label.visible = true


func _on_area_2d_mouse_exited():
	active = false
	label.visible = false
