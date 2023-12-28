extends Node

const seed_max = 10000

const layout_length_min = 8
const layout_length_max = 12

const room_exits = {
	"StartingRoom": {
		"enter": "",
		"exit": "right"
	},
	"Room1": {
		"enter": "left",
		"exit": "right"
	},
	"Room2": {
		"enter": "left",
		"exit": "right"
	},
	"Room3": {
		"enter": "left",
		"exit": "up"
	},
	"Room4": {
		"enter": "left",
		"exit": "down"
	},
	"Room5": {
		"enter": "up",
		"exit": "left"
	},
	"Room6": {
		"enter": "down",
		"exit": "left"
	},
	"Room7": {
		"enter": "down",
		"exit": "up"
	},
	"Room8": {
		"enter": "up",
		"exit": "down"
	},
	"Room9": {
		"enter": "right",
		"exit": "left"
	},
	"Room10": {
		"enter": "right",
		"exit": "down"
	},
	"Room11": {
		"enter": "down",
		"exit": "right"
	},
	"Room12": {
		"enter": "up",
		"exit": "right"
	},
	"Room13": {
		"enter": "right",
		"exit": "up"
	},
	"Room14": {
		"enter": "up",
		"exit": ""
	},
	"Room15": {
		"enter": "right",
		"exit": ""
	},
	"Room16": {
		"enter": "left",
		"exit": ""
	},
	"Room17": {
		"enter": "down",
		"exit": ""
	}
}

const enter_exit_mapping = {
	"":"",
	"left": "right",
	"right": "left",
	"up": "down",
	"down": "up"
}

signal on_scene_change(scene_name)

var current_scene = null
var rng = RandomNumberGenerator.new()
var current_layout
var current_layout_index
var from_exit = true

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func random_scene():
	goto_scene("Room" + str(rng.randi_range(1, 2)))
	pass


func goto_scene(path):
	print(path)
	# This function will usually be called from a signal callback,
	# or some other function from the running scene.
	# Deleting the current scene at this point might be
	# a bad idea, because it may be inside of a callback or function of it.
	# The worst case will be a crash or unexpected behavior.

	# The way around this is deferring the load to a later time, when
	# it is ensured that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", "res://Scenes/" + path + ".tscn")


func _deferred_goto_scene(path):
	# Immediately free the current scene,
	# there is no risk here.
	current_scene.free()

	# Load new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optional, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	if current_layout:
		var seed
		if "seed" in current_layout[current_layout_index]:
			seed = current_layout[current_layout_index]["seed"]
		
		print(seed)
		current_scene.emit_signal("initialize", from_exit, seed)

	on_scene_change.emit(current_scene.name)
	
func generate_floor_layout():
	current_layout_index = 0
	current_layout = [
		{
			"scene": "StartingRoom"
		}
	]
	for i in range(rng.randi_range(layout_length_min - 2, layout_length_max - 2)):
		var possible_next_rooms = get_possible_next_rooms(room_exits[current_layout[i]["scene"]])
		current_layout.push_back({
			"scene": possible_next_rooms[rng.randi_range(0, possible_next_rooms.size() - 1)],
			"seed": rng.randi_range(0, seed_max)
		})
	var possible_end_rooms = get_possible_end_rooms(room_exits[current_layout[current_layout.size() - 1]["scene"]])
	current_layout.push_back({
		"scene": possible_end_rooms[rng.randi_range(0, possible_end_rooms.size() - 1)],
		"seed": rng.randi_range(0, seed_max)
	})
	PlayerVariables.save_data()
	goto_scene(current_layout[current_layout_index].scene)
	
func get_possible_next_rooms(current_room):
	var possible_next_rooms = []
	
	for room_name in room_exits:
		if enter_exit_mapping[room_exits[room_name]["enter"]] == current_room["exit"] && room_exits[room_name]["exit"] != "":
			possible_next_rooms.push_back(room_name)
	
	return possible_next_rooms
	
	
func get_possible_end_rooms(current_room):
	var possible_end_rooms = []
	
	for room_name in room_exits:
		if enter_exit_mapping[room_exits[room_name]["enter"]] == current_room["exit"] && room_exits[room_name]["exit"] == "":
			possible_end_rooms.push_back(room_name)
	
	return possible_end_rooms
	
func set_layout(layout, layout_index):
	current_layout = layout
	current_layout_index = layout_index
	goto_scene(layout[layout_index].scene)
	
func room_left_exit():
	if current_layout_index < current_layout.size() - 1:
		from_exit = true
		current_layout_index += 1
		goto_scene(current_layout[current_layout_index].scene)
		PlayerVariables.save_data()
		
func room_left_enter():
	if current_layout_index > 0:
		from_exit = false
		current_layout_index -= 1
		goto_scene(current_layout[current_layout_index].scene)
		PlayerVariables.save_data()
		
func on_death():
	from_exit = true
	current_layout_index = 0
	goto_scene("StartingRoom")
	PlayerVariables.save_data()
