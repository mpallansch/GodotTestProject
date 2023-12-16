extends Node2D

const hidden_scenes = ["MainMenu", "SettingsMenu", "LoadMenu"]

@onready var menu_container = %MarginContainer
@onready var continue_button = %ContinueButton

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_container.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") && !(get_tree().current_scene.name in hidden_scenes):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			menu_container.show()
			continue_button.grab_focus()
		else:
			menu_container.hide()


func _on_continue_button_pressed():
	get_tree().paused = !get_tree().paused
	menu_container.hide()

func _on_quit_button_pressed():
	get_tree().paused = !get_tree().paused
	menu_container.hide()
	SceneManager.goto_scene("res://Scenes/MainMenu.tscn")

