extends CharacterBody2D

var required = 1
var pushers = {}
var pushing_forces = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const SPEED = 100.0
const ACCELERATION = 50

@onready var cant_jugadores = $Caja/CantJugadores
@onready var colision_izquierda = $Caja/LadoIzquierdo/ColisionIzquierda
@onready var colision_derecha = $Caja/LadoDerecho/ColisionDerecha


func _ready():
#	cant_jugadores.text = str(cant_necesaria)
	pass
	

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_multiplayer_authority():
		if not is_on_floor():
			velocity.y += gravity * delta
		
		if abs(pushing_forces) >= required:
			velocity.x = move_toward(velocity.x, pushing_forces * SPEED , ACCELERATION * delta)
		else:
			velocity.x = move_toward(0, 0, 0)
	
		move_and_slide()
		send_data.rpc(global_position, velocity)

		


@rpc("unreliable_ordered")
func send_data(pos: Vector2, vel: Vector2) -> void:
	global_position = lerp(global_position, pos, 0.5)
	velocity = lerp(velocity, vel, 0.5)

func being_pushed(pusher: Node, force: int):
	if not pushers.has(pusher):
		pushers[pusher] = force
		pushing_forces += force

	else: 
		if pushers[pusher] != force:
			pushing_forces += (force - pushers[pusher])
			pushers[pusher] = force

func stoped_being_pushed(pusher: Node):
	if pushers.has(pusher):
		pushing_forces -= pushers[pusher]
		pushers.erase(pusher)


func _on_lado_derecho_body_exited(body):
	pushers = {}
	pushing_forces = 0
