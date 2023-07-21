extends CharacterBody2D

var move_input = 0;
var is_in_area = 0;

const SPEED = 100.0
const ACELERATION = 50


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	pass

func _physics_process(delta):
	if is_multiplayer_authority():
		if not is_on_floor():
			velocity.y += gravity * delta
			
		if is_in_area:
			velocity.x = move_toward(velocity.x,SPEED*move_input,ACELERATION*delta)
		else:
			velocity.x = move_toward(0, 0, 0)

	move_and_slide()
	
	

func _on_lado_izquierdo_body_entered(body):
	if body.is_in_group("Cafe"):
		move_input = 1
		is_in_area = 1
		
func _on_lado_izquierdo_body_exited(body):
	if body.is_in_group("Cafe"):
		move_input = 0
		is_in_area = 0
	
func _on_lado_derecho_body_entered(body):
	if body.is_in_group("Cafe"):
		move_input = -1
		is_in_area = 1
	
func _on_lado_derecho_body_exited(body):
	if body.is_in_group("Cafe"):
		move_input = 0
		is_in_area = 0
