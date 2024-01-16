extends Node2D

const experience = 5
const projectile_interval = 3
const max_health = 15.0
const speed = 200.0
const strike_distance = 100

signal enemy_apply_damage(damage)
signal apply_persistent_state(persistent_state)
signal freeze(delay)

@onready var health_bar = %HealthBar
@onready var health_bar_container = %HealthBarContainer
@onready var sword = %Area2D2

var health = max_health
var delay = 0
var dead = false
var player
var freeze_delay = 0
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
	%PacifistIndicator.color = Color(0, 0, 0, clamp(PlayerVariables.kills * .05, 0.0, 0.5))
	player = PlayerVariables.get_player()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		if !$AnimationPlayer.current_animation:
			PlayerVariables.increment_kills()
			SceneManager.set_persistent_state(get_path(), "dead", true)
			GUI.create_popup(position.x, position.y, "+" + str(experience) + "xp")
			PlayerVariables.increase_experience(experience)
			queue_free()
	else:
		if freeze_delay > 0:
			freeze_delay -= delta
			color_set = false
			%PacifistIndicator.color =  Color(0, 0, 1, .2)
		else:
			set_color()
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
		
func on_apply_persistent_state(persistent_state):
	if "dead" in persistent_state && persistent_state["dead"] == true:
		queue_free()
		
func on_freeze(delay):
	freeze_delay = delay
	
func set_color():
	if !color_set:
		color_set = true
		%PacifistIndicator.color = Color(0, 0, 0, clamp(PlayerVariables.kills * .05, 0.0, 0.5))
