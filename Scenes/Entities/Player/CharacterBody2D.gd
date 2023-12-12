extends CharacterBody2D

const NAME = "Player"
const JUMP_VELOCITY = -1600.0

@onready var animated_sprite = %AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3

func _ready():
	$AnimationPlayer.play("idle")
	pass # Replace with function body.
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$AnimationPlayer.play("jump")
		velocity.y = JUMP_VELOCITY
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * PlayerVariables.current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, PlayerVariables.current_speed)
		
	if !Input.is_action_just_pressed("jump"):
		if is_on_floor():
			if direction != 0:
				if $AnimationPlayer.current_animation != "run":
					$AnimationPlayer.play("run")
			else:
				if $AnimationPlayer.current_animation != "idle":
					$AnimationPlayer.play("idle")
					
	if direction < 0:
		var current_scale = %AnimatedSprite2D.get_scale()
		if current_scale.x > 0:
			%AnimatedSprite2D.position.x = %AnimatedSprite2D.position.x * -1
			%AnimatedSprite2D.set_scale(Vector2(current_scale.x * -1, current_scale.y))
	else:
		var current_scale = %AnimatedSprite2D.get_scale()
		if current_scale.x < 0:
			%AnimatedSprite2D.position.x = %AnimatedSprite2D.position.x * -1
			%AnimatedSprite2D.set_scale(Vector2(current_scale.x * -1, current_scale.y))
			
					
	move_and_slide()
