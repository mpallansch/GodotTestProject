extends Node2D

const experience = 5
const projectile_interval = 3
const max_health = 15.0
const speed = 200.0
const strike_distance = 100

signal enemy_apply_damage(damage)

@onready var health_bar = %HealthBar
@onready var health_bar_container = %HealthBarContainer
@onready var sword = %Area2D2

var health = max_health
var delay = 0
var dead = false
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_apply_damage.connect(on_damage)
	update_heatlh_bar()
	var current_scale = %AnimatedSprite2D.get_scale()
	%AnimatedSprite2D.position.x = %AnimatedSprite2D.position.x * -1
	%AnimatedSprite2D.set_scale(Vector2(current_scale.x * -1, current_scale.y))
	player = PlayerVariables.get_player()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		if !$AnimationPlayer.current_animation:
			PlayerVariables.increase_experience(experience)
			queue_free()
	else:
		if player.position.x < position.x - strike_distance:
			if !$AnimationPlayer.current_animation || $AnimationPlayer.current_animation == "idle":
				play_animation("run")
			position.x -= delta * speed
		elif player.position.x > position.x + strike_distance:
			if !$AnimationPlayer.current_animation || $AnimationPlayer.current_animation == "idle":
				play_animation("run")
			position.x += delta * speed
		else:
			if !$AnimationPlayer.current_animation || $AnimationPlayer.current_animation == "run":
				sword.on_attack_start()
				play_animation("attack")
				
		if player.position.x < position.x:
			var current_scale = %AnimatedSprite2D.get_scale()
			if current_scale.x > 0:
				%AnimatedSprite2D.position.x = %AnimatedSprite2D.position.x * -1
				%AnimatedSprite2D.set_scale(Vector2(current_scale.x * -1, current_scale.y))
		elif player.position.x > position.x:
			var current_scale = %AnimatedSprite2D.get_scale()
			if current_scale.x < 0:
				%AnimatedSprite2D.position.x = %AnimatedSprite2D.position.x * -1
				%AnimatedSprite2D.set_scale(Vector2(current_scale.x * -1, current_scale.y))
		

func on_damage(damage):
	health -= damage
	update_heatlh_bar()
	play_animation("hurt")
	if health <= 0:
		dead = true
		play_animation("death")
		
func update_heatlh_bar():
	health_bar.size.x = health_bar_container.size.x * (health / max_health)
	
	
func play_animation(name):
	$AnimationPlayer.play(name)
	if name != "attack":
		sword.on_attack_end()
