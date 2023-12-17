extends Control

@onready var start_button = %StartButton

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	SceneManager.goto_scene("LoadMenu")


func _on_settings_button_pressed():
	SceneManager.goto_scene("SettingsMenu")


func _on_quit_button_pressed():
	get_tree().quit()
