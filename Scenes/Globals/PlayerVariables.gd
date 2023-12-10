extends Node

const default_health = 10

var health = 0;
var experience = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	health = default_health
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
	pass

func increase_health(points):
	health += points
	if health <= 0:
		health = default_health
		SceneManager.goto_scene("res://Scenes/StartingRoom.tscn")
	GUI.update_health_label()
	pass
