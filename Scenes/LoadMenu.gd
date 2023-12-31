extends Control

@onready var slots_list = %SlotsList

const saves = ["Slot 1", "Slot 2", "Slot 3"]

var save_buttons_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for save in saves:
		load_save_info(save)
		
	save_buttons_map[saves[0]].grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_save_label(save, is_empty, upgrades, experience):
	if !(save in save_buttons_map):
		var container = HBoxContainer.new()
		container.add_theme_constant_override("separation", 50)
		save_buttons_map[save] = Button.new()
		save_buttons_map[save].set_custom_minimum_size(Vector2(800,0))
		container.add_child(save_buttons_map[save])
		if !is_empty:
			var delete_button = Button.new()
			delete_button.text = "Delete"
			delete_button.add_theme_font_size_override("font_size", 45)
			delete_button.connect("pressed", get_on_delete_selected(save, delete_button))
			container.add_child(delete_button)
		slots_list.add_child(container)
		save_buttons_map[save].add_theme_font_size_override("font_size", 45)
		save_buttons_map[save].connect("pressed", get_on_load_selected(save))
	
	var label_text = save + "\n   "
	if is_empty:
		label_text += "Emtpy   "
	else:
		label_text += upgrades + " upgrades | " + experience + "xp   "
	save_buttons_map[save].text = label_text


func load_save_info(save):
	if not FileAccess.file_exists("user://" + save + ".save"):
		update_save_label(save, true, 0, 0)
	else:
		var save_game = FileAccess.open("user://" + save + ".save", FileAccess.READ)
		while save_game.get_position() < save_game.get_length():
			var json_string = save_game.get_line()

			var json = JSON.new()
			
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue

			var loaded_data = json.get_data()
			
			var upgrade_count = 0
			for upgrade in loaded_data["upgrades"]:
				if upgrade["purchased"]:
					upgrade_count += 1
		
			update_save_label(save, false, str(upgrade_count), str(loaded_data["experience"]))


func _on_button_pressed():
	SceneManager.goto_scene("MainMenu")

func get_on_load_selected(save):
	var save_name = save
	return func on_load_selected():
		PlayerVariables.load_data(save_name)

func get_on_delete_selected(save, delete_button):
	var save_name = save
	return func on_delete_selected():
		PlayerVariables.delete_data(save_name)
		delete_button.queue_free()
		load_save_info(save)
