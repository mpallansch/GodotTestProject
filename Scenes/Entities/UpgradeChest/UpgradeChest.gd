extends Node2D

var player_in_chest = false
var scroll_depth = 0
var highlighted = 0
@onready var shop_interface = %ShopInterface
@onready var upgrade_list = %VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	shop_interface.hide()
	
	render_shop_interface()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("down") && player_in_chest:
		if !shop_interface.is_visible_in_tree():
			shop_interface.show()
		else:
			if highlighted < PlayerVariables.upgrades.size() - 1:
				highlighted += 1
				if highlighted >= scroll_depth + 3:
					scroll_depth += 1
			render_shop_interface()
	if Input.is_action_just_pressed("up") && player_in_chest && shop_interface.is_visible_in_tree():
		if highlighted > 0:
			highlighted -= 1
			if highlighted < scroll_depth:
				scroll_depth -= 1
			render_shop_interface()
	if Input.is_action_just_pressed("accept"):
		if PlayerVariables.upgrades[highlighted]["purchased"] == false && PlayerVariables.experience >= PlayerVariables.upgrades[highlighted]["price"]:
			PlayerVariables.purchase_upgrade(PlayerVariables.upgrades[highlighted]["name"])
			render_shop_interface()
	pass
	


func _on_area_2d_body_entered(body):
	if body.owner.name == "Player":
		player_in_chest = true
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if body.owner.name == "Player":
		player_in_chest = false
		shop_interface.hide()
	pass # Replace with function body.


func render_shop_interface():
	for item in upgrade_list.get_children():
		item.queue_free()
	
	var index = 0
	for item in PlayerVariables.upgrades:
		if index >= scroll_depth && index < scroll_depth + 3:
			var item_label = Label.new()
			item_label.text = item["name"] + ": " + str(item["price"]) + "xp"
			item_label.add_theme_color_override("font_color", Color(0,0,0))
			if item["purchased"]:
				item_label.add_theme_color_override("font_shadow_color", Color(0,1,0))
			if index == highlighted:
				item_label.add_theme_font_size_override("font_size", 34)
			else:
				item_label.add_theme_font_size_override("font_size", 30)
			upgrade_list.add_child(item_label)
		index += 1
	pass
