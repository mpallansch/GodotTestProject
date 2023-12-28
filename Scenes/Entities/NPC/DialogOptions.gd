extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_dialog():
	return {
		"entry": {
			"label": "This is a label",
			"next": "two"
		},
		"two": {
			"label": "This is a second label",
			"options": [
				{
					"label": "Yes",
					"next": "yes"
				},
				{
					"label": "No",
					"next": "no"
				}
			]
		},
		"yes": {
			"label": "you answered yes",
			"next": "entry",
			"close_on_next": true
		},
		"no": {
			"label": "you answered no",
			"next": "entry",
			"close_on_next": true
		}
	}
