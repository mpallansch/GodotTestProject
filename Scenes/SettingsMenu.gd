extends Control

@onready var back_button = %BackButton

# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	SceneManager.goto_scene("res://Scenes/MainMenu.tscn")
