extends Node2D

var player_close = false
var highlighted = 0
var current_dialog_key = "entry"

@onready var dialog_interface = %DialogInterface
@onready var dialog_options = %DialogOptions.get_dialog()
@onready var dialog_label = %Label
@onready var dialog_options_list = %OptionsList

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog_interface.hide()
	render_dialog_interface()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("down") && player_close:
		if !dialog_interface.is_visible_in_tree():
			dialog_interface.show()
		else:
			if dialog_options[current_dialog_key].has("options"):
				if highlighted < dialog_options[current_dialog_key]["options"].size() - 1:
					highlighted += 1
			else:
				if dialog_options[current_dialog_key].has("close_on_next"):
					dialog_interface.hide()
				if dialog_options[current_dialog_key].has("next"):
					current_dialog_key = dialog_options[current_dialog_key]["next"]
			
			render_dialog_interface()
	if Input.is_action_just_pressed("up") && player_close && dialog_interface.is_visible_in_tree():
		if highlighted > 0:
			highlighted -= 1
			render_dialog_interface()
	if dialog_interface.is_visible_in_tree() && Input.is_action_just_pressed("accept"):
		if dialog_options[current_dialog_key].has("close_on_next"):
			dialog_interface.hide()
		if dialog_options[current_dialog_key].has("next"):
			current_dialog_key = dialog_options[current_dialog_key]["next"]
		elif dialog_options[current_dialog_key].has("options"):
			current_dialog_key = dialog_options[current_dialog_key]["options"][highlighted]["next"]
		render_dialog_interface()
	


func _on_area_2d_body_entered(body):
	if body.owner.name == "Player":
		player_close = true


func _on_area_2d_body_exited(body):
	if body.owner.name == "Player":
		player_close = false
		dialog_interface.hide()
		
func render_dialog_interface():
	dialog_label.text = dialog_options[current_dialog_key]["label"]
	
	for item in dialog_options_list.get_children():
		item.queue_free()
		
	if dialog_options[current_dialog_key].has("options"):
		var index = 0
		for item in dialog_options[current_dialog_key]["options"]:
			var option_label = Label.new()
			option_label.text = item["label"]
			option_label.add_theme_color_override("font_color", Color(0,0,0))
			if index == highlighted:
				option_label.add_theme_font_size_override("font_size", 34)
			else:
				option_label.add_theme_font_size_override("font_size", 30)
				
			dialog_options_list.add_child(option_label)
				
			index += 1
