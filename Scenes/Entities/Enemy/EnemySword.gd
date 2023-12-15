extends Area2D

var damage = 3
var disable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func on_attack_start():
	print("here3")
	disable = false
	
func on_attack_end():
	disable = true

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if !disable:
		area.owner.get_node("CharacterBody2D").emit_signal("apply_damage", damage)
		disable = true
