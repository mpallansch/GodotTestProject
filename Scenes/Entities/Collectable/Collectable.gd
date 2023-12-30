extends Node2D

signal apply_persistent_state(persistent_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_persistent_state.connect(on_apply_persistent_state)
	
	if has_meta("sprite"):
		var sprite_node = get_node("Sprites").get_node(get_meta("sprite"))
		if sprite_node:
			sprite_node.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_apply_persistent_state(persistent_state):
	if "collected" in persistent_state && persistent_state["collected"] == true:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.owner.name == "Player":
		if has_meta("increase_health"):
			PlayerVariables.increase_health(get_meta("increase_health"))
		if has_meta("increase_experience"):
			PlayerVariables.increase_experience(get_meta("increase_experience"))
		SceneManager.set_persistent_state(get_path(), "collected", true)
		queue_free()
