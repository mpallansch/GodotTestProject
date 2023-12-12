extends Area2D

var damage = 5
var delay = 350

var time_since_hit = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if Time.get_ticks_msec() - time_since_hit > delay:
		time_since_hit = Time.get_ticks_msec()
		area.owner.emit_signal("enemy_apply_damage", damage)
