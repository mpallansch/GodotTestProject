extends Node2D

var speed = -300
var is_player_generated = false
const damage = 5

@onready var area_node = get_node("Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	area_node.position += area_node.transform.x * speed * delta
	pass
	
func initialize(new_speed, new_is_player_generated):
	speed = new_speed
	is_player_generated = new_is_player_generated

func _on_area_2d_body_entered(body):
	if body.owner.name == "Player":
		if !is_player_generated:
			body.owner.get_node("CharacterBody2D").emit_signal("apply_damage", damage)	
			queue_free()
	else: 
		queue_free()


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if is_player_generated:
		area.owner.emit_signal("freeze", 3)
		queue_free()
