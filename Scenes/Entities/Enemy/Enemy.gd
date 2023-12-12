extends Node2D

const experience = 5
const projectile_interval = 3
const max_health = 10

signal enemy_apply_damage(damage)

@onready var projectile_scene = preload("res://Scenes/Entities/Enemy/Projectile.tscn")

var health = max_health
var delay = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_apply_damage.connect(on_damage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delay += delta
	if delay > projectile_interval:
		delay = 0
		var projectile = projectile_scene.instantiate()
		add_child(projectile)
		projectile.position += projectile.transform.y * 50
		#projectile.position = Vector2()
	pass


func _on_area_2d_body_entered(body):
	#if(body.owner.name == "Player"):
		#PlayerVariables.increase_experience(experience)
		#queue_free()
	pass # Replace with function body.

func on_damage(damage):
	health -= damage
	if health <= 0:
		PlayerVariables.increase_experience(experience)
		queue_free()
