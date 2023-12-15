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

var health = 0;
var experience = 0;
var current_speed = default_speed
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	health = default_health
	GUI.update_health_label()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func global_print(message):
	print(message)
	pass

func increase_experience(points):
	experience += points
	GUI.update_experience_label()
	save_data()
	pass

func increase_health(points):
	health += points
	if health <= 0:
		health = default_health
		SceneManager.goto_scene("res://Scenes/StartingRoom.tscn")
	GUI.update_health_label()
	pass

func purchase_upgrade(upgrade_name):
	for upgrade in upgrades:
		if upgrade["name"] == upgrade_name:
			upgrade["purchased"] = true
			increase_experience(-1 * upgrade["price"])
			break
			
	apply_upgrades()
	
	save_data()
	pass
	
func save_data():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)

	var json_string = JSON.stringify({"experience": experience, "upgrades": upgrades})

	save_game.store_line(json_string)
	pass
	
func load_data():
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
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
		
	pass
	
func apply_upgrades():
	for upgrade in upgrades:
		if upgrade["purchased"] && upgrade["name"] == "Increase Speed":
			current_speed = default_speed * 2
			
func store_player_referece(player_ref):
	player = player_ref
	
func get_player():
	return player


