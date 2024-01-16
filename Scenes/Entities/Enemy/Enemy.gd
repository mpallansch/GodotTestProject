extends Node2D

const experience = 5
const projectile_interval = 3
const max_health = 15.0

signal enemy_apply_damage(damage)
signal apply_persistent_state(persistent_state)
signal freeze(delay)

@onready var projectile_scene = preload("res://Scenes/Entities/Enemy/Projectile.tscn")
@onready var health_bar = %HealthBar
@onready var health_bar_container = %HealthBarContainer

var health = max_health
var delay = 0
var freeze_delay = 0
var dead = false
var color_set = false

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_apply_damage.connect(on_damage)
	apply_persistent_state.connect(on_apply_persistent_state)
	freeze.connect(on_freeze)
	update_heatlh_bar()
	var current_scale = %AnimatedSprite2D.get_scale()
	%AnimatedSprite2D.position.x = %AnimatedSprite2D.position.x * -1
	%AnimatedSprite2D.set_scale(Vector2(current_scale.x * -1, current_scale.y))
	set_color()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		if !$AnimationPlayer.current_animation:
			GUI.create_popup(position.x, position.y, "+" + str(experience) + "xp")
			PlayerVariables.increment_kills()
			PlayerVariables.increase_experience(experience)
			SceneManager.set_persistent_state(get_path(), "dead", true)
			queue_free()
	else:
		if freeze_delay > 0:
			freeze_delay -= delta
			color_set = false
			%PacifistIndicator.color =  Color(0, 0, 1, .2)
		else:
			set_color()
			delay += delta
			if delay > projectile_interval:
				delay = 0
				var projectile = projectile_scene.instantiate()
				add_child(projectile)
				$AnimationPlayer.play("attack")
			if !$AnimationPlayer.current_animation:
				$AnimationPlayer.play("idle")

func on_damage(damage):
	health -= damage
	update_heatlh_bar()
	if health <= 0:
		dead = true
		$AnimationPlayer.play("death")
	else:
		$AnimationPlayer.play("hurt")
		
func update_heatlh_bar():
	health_bar.size.x = health_bar_container.size.x * (health / max_health)
	
func on_apply_persistent_state(persistent_state):
	if "dead" in persistent_state && persistent_state["dead"] == true:
		queue_free()
		
func on_freeze(delay):
	freeze_delay = delay
	
func set_color():
	if !color_set:
		color_set = true
		%PacifistIndicator.color = Color(0, 0, 0, clamp(PlayerVariables.kills * .05, 0.0, 0.5))
