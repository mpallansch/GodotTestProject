extends Node2D

@onready var label = %Label

# Called when the node enters the scene tree for the first time.
func _ready():
	if has_meta("label_text"):
		label.text = get_meta("label_text")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$AnimationPlayer.current_animation:
		queue_free()

