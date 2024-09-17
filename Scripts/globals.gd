extends Node


var day: int = 1

var cast: Array = [
	["trent","glanthor","constantine", "klaus","theo","lucius","lilianne","ethred"],
	["glanthor", "klaus","theo","lucius","lilianne","ethred"],
	["trent","glanthor","klaus","theo","lucius","lilianne","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
]

var player_balance = 100

var ingredient_flavors = {
	"Dwarven Stout": ["strong", "alcoholic", "liquid", "dark"],
	"Elderflower Liqueur": ["light", "alcoholic", "liquid", "floral"],
	"Elven Moonshine": ["strong", "alcoholic", "liquid", "smooth"],
	"Halfling Whiskey": ["smooth", "alcoholic", "liquid", "caramel"],
	"Pirates Dark Rum": ["strong", "alcoholic", "liquid", "dark", "caramel"],
	"Dragonfruit Extract": ["sweet", "liquid", "colorful"],
	"Elven Honey": ["sweet", "liquid", "floral"],
	"Feywild Berry Juice": ["fruity", "liquid", "magical"],
	"Shadowroot Syrup": ["sweet", "liquid", "dark", "earthy"],
	"Celestial Citrus Blend": ["citrus", "liquid", "bright"],
	"Gnomish Ginger Brew": ["spicy", "liquid", "refreshing"],
	"Halflings Apple Cider": ["sweet", "liquid", "fruity"],
	"Moonlit Lavender Essence": ["floral", "liquid", "aromatic"],
	"Treant Sap": ["sweet", "liquid", "earthy"],
	"Rune Infused Rose Water": ["floral", "liquid", "magical"],
	"Ghost Pepper Elixir": ["spicy", "liquid", "bold"],
	"Goblin Spice": ["spicy", "solid", "bold", "powder"],
	"Mystic Mint Leaves": ["refreshing", "solid", "mint"],
	"Orcish Blood Orange Zest": ["tart", "solid", "citrus"],
	"Wizards Basil": ["aromatic", "solid", "herb"],
	"Pixie Dust Sugar": ["sweet", "solid", "colorful", "powder"],
	"Infernal Cinnamon Stick": ["spicy", "solid", "warm"],
	"Elemental Ice Shards": ["cold", "solid", "magical"],
	"Mermaids Sea Salt": ["salty", "solid", "powder"],
	"Phoenix Feather": ["bright", "solid", "bold"],
	"Sylvan Sage": ["aromatic", "solid", "herb"],
	"Thieves Blackberries": ["tart", "solid", "fruity"]
}

var recipes = []

func get_cast_for_day() -> Array[PackedScene]:
	var names = cast[day-1]
	var path = "res://Scenes/Characters"
	var dir = DirAccess.open(path)
	var res: Array[PackedScene] = []
	for name in names:
		res.append(load(path + "/" + name + ".tscn"))
	return res


func load_json_file(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()  # Create an instance of the JSON class
	var json_error = json.parse(json_string)
	
	if json_error != OK:
		print("Failed to parse JSON, error code: ", json_error)
		return {}
	
	var json_result = json.get_data()  # Extract the parsed data
	return json_result

# Function to turn JSON into recipe objects
func create_recipes_from_json(json_data: Dictionary) -> Array:
	var recipes_list = []
	var recipes_data = json_data.get("recipes", [])
	
	for recipe_data in recipes_data:
		var new_recipe = Recipe.new()
		new_recipe.recipe_name = recipe_data.get("recipe_name", "")
		new_recipe.glass_type = recipe_data.get("glass_type", "")
		new_recipe.ingredients = recipe_data.get("ingredients", [])
		new_recipe.has_ice = recipe_data.get("has_ice", false)
		
		recipes_list.append(new_recipe)
	
	return recipes_list



# Called when the node enters the scene tree for the first time.
func _ready():
	var json_data = load_json_file("res://Recipes/recipes.json")
	recipes = create_recipes_from_json(json_data)
	
	for recipe in recipes:
		print(recipe.generate_recipe_string())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


