extends Node2D

var player_in_portal = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("down") && player_in_portal:
		SceneManager.next_floor()


func _on_area_2d_body_entered(body):
	if body.owner.name == "Player":
		player_in_portal = true


func _on_area_2d_body_exited(body):
	if body.owner.name == "Player":
		player_in_portal = false
