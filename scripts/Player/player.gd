class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1000


var FACING_RIGHT = false

@onready var animation_tree = $AnimationTree
@onready var character = $"."


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_input = 0


func init(id):
	set_multiplayer_authority(id)
	name = str(id)

func _ready():
	Debug.print(name)
	
	set_multiplayer_authority(name.to_int())
	
	animation_tree.active = true


func _physics_process(delta):
	if is_multiplayer_authority():
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
			
		move_input = Input.get_axis("Left", "Right")
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
			if move_input>0.5:
				character.scale.x = move_input
		velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)
		
		
		move_and_slide()
		
		rpc("send_data", global_position, velocity, move_input)

@rpc("unreliable_ordered")
func send_data(pos: Vector2, vel: Vector2, mi: float) -> void:
	global_position = lerp(global_position, pos, 0.5)
	velocity = lerp(velocity, vel, 0.5)
	move_input = mi

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move_input = Input.get_axis("Left", "Right")
	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
		if (FACING_RIGHT and move_input<0) or ((not FACING_RIGHT) and move_input>0):
			character.scale.x = -1 * abs(character.scale.x)
			FACING_RIGHT = not FACING_RIGHT
			
			
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)
	
	
	move_and_slide()

