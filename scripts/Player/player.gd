class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
const ACCELERATION = 1000

var force = 0
var pushing_forces = 0: 
	set(value) : 
		Debug.print('se sssteta')
		pushing_forces = value
		if multiplayer.is_server(): 
			Debug.print('es server')
			Debug.print(value)
			update_pushing_forces.rpc_id(get_multiplayer_authority(), pushing_forces)
var jumping = false
var pushers = {}
var collider = null

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var pivot = $pivot
@onready var collision = $CollisionShape2D
@onready var ray = $pivot/ray

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_input = 0

func init(id):
	set_multiplayer_authority(id)
	name = str(id)

func _ready():	
	set_multiplayer_authority(name.to_int())
	animation_tree.active = true
	animation_player.play('IDLE')
	print('Se correo la animación')


func _physics_process(delta):
	if multiplayer.is_server():
		if ray.is_colliding():
			collider = ray.get_collider() as Node
			if collider.has_method("being_pushed"):
				collider.being_pushed(self, force + pushing_forces)
		else: 
			if collider != null: 
				if collider.has_method("stoped_being_pushed"):
					collider.stoped_being_pushed(self)
					collider = null
			
	if is_multiplayer_authority():
		# Add the gravity
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			animation_player.play("Saltar")
			jumping = true
			
			
		move_input = Input.get_axis("Left", "Right")
		force = move_input
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if move_input != 0:
			pivot.scale.x = sign(move_input)
		
		velocity.x = move_toward(velocity.x, clamp(move_input+pushing_forces,-1,1) * SPEED, ACCELERATION * delta)
#		Debug.print(pushing_forces)
		
		if abs(velocity.x) < 0.5: 
			animation_player.play("IDLE")
			
		elif (not jumping) and (abs(velocity.x) > 0.5):
			animation_player.play("Caminar")
		
		if abs(velocity.y)<0.2:
			jumping = false

		
		move_and_slide()

		rpc("send_data", global_position, velocity, move_input)
		
			

@rpc("unreliable_ordered")
func send_data(pos: Vector2, vel: Vector2, mi: float) -> void:
	global_position = lerp(global_position, pos, 0.5)
	velocity = lerp(velocity, vel, 0.5)
	
	if(mi != 0):
		pivot.scale.x = sign(mi) 
	force = mi

@rpc("reliable","any_peer")
func update_pushing_forces(new_pushing_forces: int):
	Debug.print('Se updeitea la pushing')
	pushing_forces = new_pushing_forces


func being_pushed(pusher: Node, forces: int):
	if pusher == collider and forces == force:
		pass
	else: 
		if not pushers.has(pusher):
			Debug.print('nuevo pusher')
			pushers[pusher] = forces
			pushing_forces += forces
			change_pushing_force()
		else: 
			if pushers[pusher] != forces:
				Debug.print('fuerza distinta')
				pushing_forces += (forces - pushers[pusher])
				pushers[pusher] = forces
				change_pushing_force()

func change_pushing_force():
	if ray.is_colliding():
		var collider := ray.get_collider() as Node
		if collider.has_method("being_pushed"):
			collider.being_pushed(self, force + pushing_forces)

func stoped_being_pushed(pusher: Node):
	if pushers.has(pusher):
		pushing_forces -= pushers[pusher]
		pushers.erase(pusher)
