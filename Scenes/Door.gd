extends RigidBody2D

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
