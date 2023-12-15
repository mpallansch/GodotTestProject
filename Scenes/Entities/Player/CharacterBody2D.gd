extends CharacterBody2D

const JUMP_VELOCITY = -1600.0

signal apply_damage(damage)

@onready var animated_sprite = %AnimatedSprite2D
@onready var sword = %Area2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3

func _ready():
	apply_damage.connect(on_damage)
	play_animation("idle")
	PlayerVariables.store_player_referece(self)
	pass # Replace with function body.
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * PlayerVariables.current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, PlayerVariables.current_speed)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		play_animation("jump")
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("attack"):
		play_animation("attack")
	else:
		if is_on_floor():
			if direction != 0:
				if !$AnimationPlayer.current_animation || $AnimationPlayer.current_animation == "idle":
					play_animation("run")
			else:
				if !$AnimationPlayer.current_animation || $AnimationPlayer.current_animation == "run":
					play_animation("idle")
					
	if direction < 0:
		var current_scale = %AnimatedSprite2D.get_scale()
		if current_scale.x > 0:
			%AnimatedSprite2D.position.x = %AnimatedSprite2D.position.x * -1
			%AnimatedSprite2D.set_scale(Vector2(current_scale.x * -1, current_scale.y))
	elif direction > 0:
		var current_scale = %AnimatedSprite2D.get_scale()
		if current_scale.x < 0:
			%AnimatedSprite2D.position.x = %AnimatedSprite2D.position.x * -1
			%AnimatedSprite2D.set_scale(Vector2(current_scale.x * -1, current_scale.y))
			
					
	move_and_slide()
	
func on_damage(damage):
	PlayerVariables.increase_health(-1 * damage)
	play_animation("hurt")
	
func play_animation(name):
	$AnimationPlayer.play(name)
	if name != "attack":
		sword.on_attack_end()
