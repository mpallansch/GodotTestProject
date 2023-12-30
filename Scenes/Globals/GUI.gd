extends Node2D

const hidden_scenes = ["MainMenu", "SettingsMenu", "LoadMenu"]

@onready var health_label = %HealthLabel
@onready var experience_label = %ExperienceLabel
@onready var scene_label = %SceneLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_if_not_playing( get_tree().current_scene.name )
	update_health_label()
	update_experience_label()
	if !PlayerVariables.debug:
		scene_label.hide()
	SceneManager.connect("on_scene_change", hide_if_not_playing)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_health_label():
	health_label.text = "HP: " + str(PlayerVariables.health)
	pass

func update_experience_label():
	experience_label.text = "XP: " + str(PlayerVariables.experience)
	pass
	
func hide_if_not_playing(scene_name):
	if scene_name in hidden_scenes:
		self.get_node("CanvasLayer").hide()
	else:
		self.get_node("CanvasLayer").show()
		
func scene_change(scene_name):
	scene_label.text = scene_name
