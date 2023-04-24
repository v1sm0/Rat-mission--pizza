extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1000


var FACING_RIGHT = false

@onready var animation_tree = $AnimationTree
@onready var character = $"."


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_tree.active = true


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move_input = Input.get_axis("Left", "Right")
	if Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right"):
		if (FACING_RIGHT and move_input<0) or ((not FACING_RIGHT) and move_input>0):
			character.scale.x = -1 * abs(character.scale.x)
			FACING_RIGHT = not FACING_RIGHT
			
			
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION * delta)
	
	
	move_and_slide()
