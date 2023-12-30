extends Node2D

const experience = 5
const projectile_interval = 3
const max_health = 15.0

signal enemy_apply_damage(damage)
signal apply_persistent_state(persistent_state)

@onready var projectile_scene = preload("res://Scenes/Entities/Enemy/Projectile.tscn")
@onready var health_bar = %HealthBar
@onready var health_bar_container = %HealthBarContainer

var health = max_health
var delay = 0
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_apply_damage.connect(on_damage)
	apply_persistent_state.connect(on_apply_persistent_state)
	update_heatlh_bar()
	var current_scale = %AnimatedSprite2D.get_scale()
	%AnimatedSprite2D.position.x = %AnimatedSprite2D.position.x * -1
	%AnimatedSprite2D.set_scale(Vector2(current_scale.x * -1, current_scale.y))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		if !$AnimationPlayer.current_animation:
			PlayerVariables.increase_experience(experience)
			queue_free()
	else:
		delay += delta
		if delay > projectile_interval:
			delay = 0
			var projectile = projectile_scene.instantiate()
			add_child(projectile)
			$AnimationPlayer.play("attack")
			#projectile.position = Vector2()
		if !$AnimationPlayer.current_animation:
			$AnimationPlayer.play("idle")

func on_damage(damage):
	health -= damage
	update_heatlh_bar()
	$AnimationPlayer.play("hurt")
	if health <= 0:
		dead = true
		$AnimationPlayer.play("death")
		SceneManager.set_persistent_state(get_path(), "dead", true)
		
func update_heatlh_bar():
	health_bar.size.x = health_bar_container.size.x * (health / max_health)
	
func on_apply_persistent_state(persistent_state):
	if "dead" in persistent_state && persistent_state["dead"] == true:
		queue_free()
