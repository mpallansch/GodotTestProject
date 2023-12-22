extends Node2D

signal initialize(from_exit, seed)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("initialize", on_initialize)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_initialize(from_exit, seed):
	if !from_exit:
		%Player.get_node("CharacterBody2D").position.x = %Exit.position.x
		%Player.get_node("CharacterBody2D").position.y = %Exit.position.y
	else:
		%Player.get_node("CharacterBody2D").position.x = %Enter.position.x
		%Player.get_node("CharacterBody2D").position.y = %Enter.position.y
