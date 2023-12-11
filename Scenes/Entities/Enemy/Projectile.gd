extends Node2D

const speed = -300
const damage = 10

@onready var area_node = get_node("Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	area_node.position += area_node.transform.x * speed * delta
	pass
	

func _on_area_2d_body_entered(body):
	if body.owner.name == "Player":
		PlayerVariables.increase_health(-1 * damage)
	queue_free()
	pass # Replace with function body.
