extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if has_meta("sprite"):
		var sprite_node = get_node("Sprites").get_node(get_meta("sprite"))
		if sprite_node:
			sprite_node.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.owner.name == "Player":
		if has_meta("increase_health"):
			PlayerVariables.increase_health(get_meta("increase_health"))
		if has_meta("increase_experience"):
			PlayerVariables.increase_experience(get_meta("increase_experience"))
		queue_free()
