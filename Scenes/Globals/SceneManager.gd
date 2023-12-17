extends Node

const layout_length_min = 8
const layout_length_max = 12

signal on_scene_change(scene_name)

var current_scene = null
var rng = RandomNumberGenerator.new()
var current_layout
var current_layout_index
var from_exit = false

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
		print(current_layout_index)
		var seed
		if "seed" in current_layout[current_layout_index]:
			seed = current_layout[current_layout_index]["seed"]
		
		current_scene.emit_signal("initialize", from_exit, seed)

	on_scene_change.emit(current_scene.name)
	
func generate_floor_layout():
	current_layout_index = 0
	current_layout = [
		{
			"scene": "StartingRoom"
		}
	]
	for i in range(rng.randi_range(layout_length_min, layout_length_max)):
		current_layout .push_back({
			"scene": "Room1" if rng.randi_range(0,1) > 0 else "Room2",
			"seed": rng.randi_range(0, 10000)
		})
	PlayerVariables.save_data()
	
func set_layout(layout, layout_index):
	current_layout = layout
	current_layout_index = layout_index
	print(layout, layout_index, layout[layout_index].scene)
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
