extends Node2D

@onready var menu_container = %MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_container.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			menu_container.show()
		else:
			menu_container.hide()
	pass
