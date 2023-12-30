extends Node2D

signal initialize(from_exit, persistent_data, seed)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("initialize", on_initialize)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_nodes(node, seed):
	var rng = RandomNumberGenerator.new()
	if seed:
		rng.seed = seed
	
	for child_node in node.get_children():
		if child_node.has_meta("spawn_child") && child_node.get_meta("spawn_child") == true:
			if child_node.has_meta("spawn_child_empty_chance") && rng.randf_range(0, 1) < child_node.get_meta("spawn_child_empty_chance"):
				for sub_child_node in child_node.get_children():
					sub_child_node.queue_free()
			else:
				var keep_index = rng.randi_range(0, child_node.get_child_count() - 1)
				var index = 0
				
				for sub_child_node in child_node.get_children():
					if(index != keep_index):
						sub_child_node.queue_free()
						
					index += 1
					
		
		if child_node.has_meta("spawn_chance"):
			if rng.randf_range(0, 1) > child_node.get_meta("spawn_chance"):
				child_node.queue_free()
				
			
		if child_node.get_child_count() > 0:
			process_nodes(child_node, seed)
	
func on_initialize(from_exit, persistent_state, seed):
	if !from_exit:
		%Player.get_node("CharacterBody2D").position.x = %Exit.position.x
		%Player.get_node("CharacterBody2D").position.y = %Exit.position.y
	else:
		%Player.get_node("CharacterBody2D").position.x = %Enter.position.x
		%Player.get_node("CharacterBody2D").position.y = %Enter.position.y
		
	if persistent_state:
		for path in persistent_state:
			var node_receiving_state = get_node(path)
			if node_receiving_state:
				node_receiving_state.emit_signal("apply_persistent_state", persistent_state[path])
		
	process_nodes(self, seed)
