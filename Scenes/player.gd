extends CharacterBody2D


const SPEED = 1200.0
const JUMP_VELOCITY = -2500.0
const WORLD_LIMIT = 4000
const BOOST_MULTIPLIER = 1.8

var lives = 3

signal send_animation

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if position.y > WORLD_LIMIT:
			end_game()

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AudioStreamPlayer.stream = load("res://SFX/jump1.ogg")
		$AudioStreamPlayer.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	animate()

	move_and_slide()
	
func animate():
	emit_signal("send_animation", velocity)

func hurt():
	velocity.y = JUMP_VELOCITY
	lives -= 1
	if lives == 0:
		end_game()
	$AudioStreamPlayer.stream = load("res://SFX/pain.ogg")
	$AudioStreamPlayer.play()

func boost():
	velocity.y = JUMP_VELOCITY * BOOST_MULTIPLIER

		
func end_game():
	get_tree().change_scene("res://Scenes/end_game.tscn")
