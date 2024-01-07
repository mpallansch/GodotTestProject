extends Node

@onready var background_audio = %BackgroundAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func adjust_enemy_music(is_enemy_present):
	if is_enemy_present:
		background_audio.volume_db = 0
	else:
		background_audio.volume_db = -90
