extends Area2D

signal activate()

# Called when the node enters the scene tree for the first time.
func _ready():
	activate.connect(on_activate)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_activate():
	position.y = position.y - 200


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	area.get_parent().emit_signal("enemy_apply_damage", 100)
	
