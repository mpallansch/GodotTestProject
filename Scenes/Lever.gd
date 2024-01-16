extends Area2D

@onready var spikes = %Spikes
@onready var door = %Door

var player_collided = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("down") && player_collided:
		spikes.emit_signal("activate")
		door.emit_signal("activate")

func _on_body_entered(body):
	print(body.owner.name)
	if body.owner.name == "Player":
		player_collided = true

func _on_body_exited(body):
	if body.owner.name == "Player":
		player_collided = false
