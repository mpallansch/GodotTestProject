extends Node

const default_speed = 650.0
const default_health = 10

var upgrades = [{
	"name": "Increase Speed",
	"price": 5,
	"purchased": false
},{
	"name": "Upgrade 2",
	"price": 50,
	"purchased": false
},{
	"name": "Upgrade 3",
	"price": 80,
	"purchased": false
},{
	"name": "Upgrade 4",
	"price": 150,
	"purchased": false
},{
	"name": "Upgrade 5",
	"price": 500,
	"purchased": false
},{
	"name": "Upgrade 6",
	"price": 1500,
	"purchased": false
},{
	"name": "Upgrade 7",
	"price": 5000,
	"purchased": false
},{
	"name": "Upgrade 8",
	"price": 50000,
	"purchased": false
}]

var health = 0
var experience = 0
var current_speed = 0
var player
var current_save = "Default"

# Called when the node enters the scene tree for the first time.
func _ready():
	enforce_defaults()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func enforce_defaults():
	health = default_health
	current_speed = default_speed
	experience = 0
	GUI.update_health_label()
	GUI.update_experience_label()
	

func increase_experience(points):
	experience += points
	GUI.update_experience_label()
	save_data()

func increase_health(points):
	health += points
	if health <= 0:
		health = default_health
		SceneManager.goto_scene("StartingRoom")
	GUI.update_health_label()

func purchase_upgrade(upgrade_name):
	for upgrade in upgrades:
		if upgrade["name"] == upgrade_name:
			upgrade["purchased"] = true
			increase_experience(-1 * upgrade["price"])
			break
			
	apply_upgrades()
	
	save_data()
	
func save_data():
	var save_game = FileAccess.open("user://" + current_save + ".save", FileAccess.WRITE)

	var json_string = JSON.stringify({"experience": experience, "upgrades": upgrades, "layout": SceneManager.current_layout, "layout_index": SceneManager.current_layout_index})

	save_game.store_line(json_string)
	
func load_data(save):
	current_save = save
	if not FileAccess.file_exists("user://" + current_save + ".save"):
		enforce_defaults()
		SceneManager.generate_floor_layout()
		return

	var save_game = FileAccess.open("user://" + current_save + ".save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var loaded_data = json.get_data()
		
		experience = loaded_data["experience"]
		GUI.update_experience_label()
		
		upgrades = loaded_data["upgrades"]
		apply_upgrades()
		
		if "layout" in loaded_data && "layout_index" in loaded_data:
			SceneManager.set_layout(loaded_data["layout"], loaded_data["layout_index"])
		else:
			SceneManager.generate_floor_layout()
		
	pass
	
func apply_upgrades():
	for upgrade in upgrades:
		if upgrade["purchased"] && upgrade["name"] == "Increase Speed":
			current_speed = default_speed * 2
			
func store_player_referece(player_ref):
	player = player_ref
	
func get_player():
	return player


