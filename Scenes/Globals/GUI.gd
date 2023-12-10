extends Node2D

@onready var health_label = %HealthLabel
@onready var experience_label = %ExperienceLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	update_health_label()
	update_experience_label()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_health_label():
	health_label.text = "HP: " + str(PlayerVariables.health)
	pass

func update_experience_label():
	experience_label.text = "XP: " + str(PlayerVariables.experience)
	pass
