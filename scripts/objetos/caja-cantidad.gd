extends CharacterBody2D

var cant_necesaria = 1;
var cant_actual = 0;
var bodys_empujando = [];
var bodys_moviendose = [];
var Movement = Vector2(1, 0);
var move_input = 0;

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
	if is_multiplayer_authority():
		if not is_on_floor():
			velocity.y += gravity * delta
		
		if len(bodys_moviendose) >= cant_actual:
			velocity.x = move_toward(velocity.x, move_input * SPEED , ACCELERATION * delta)
		elif len(bodys_moviendose) == 0:
			velocity.x = move_toward(0, 0, 0)
		
		
		send_data.rpc(global_position, velocity)
	move_and_slide()
#	if(cant_necesaria <= len(bodys_moviendose)):
#		self.set_collision_layer_value(1,false)
#		self.set_collision_layer_value(2,true)
#	else:
#		self.set_collision_layer_value(2,false)
#		self.set_collision_layer_value(1,true)
		


func moviendoCaja(quien,move):
	if move + move_input != 0: 
		if not bodys_moviendose.has(quien):
			bodys_moviendose.push_back(quien)
			move_input = move
	
func quieto(quien):
	bodys_moviendose.pop_at(bodys_moviendose.bsearch(quien))

func conectar(body):
	var personaje = bodys_empujando[bodys_empujando.bsearch(body)]
	personaje.empujando.connect(moviendoCaja)
	personaje.quieto.connect(quieto)
	personaje.chocan_rata.connect(entraCuerpo)
	personaje.ya_no_chocan_rata.connect(saleCuerpo)

func desconectar(body):
	var personaje = bodys_empujando[bodys_empujando.bsearch(body)]
	personaje.empujando.disconnect(moviendoCaja)
	personaje.quieto.disconnect(quieto)
	personaje.chocan_rata.disconnect(entraCuerpo)
	personaje.ya_no_chocan_rata.disconnect(saleCuerpo)
	move_input=0

func saleCuerpo(body):
	if body.is_in_group('Player'):
		cant_actual -= 1;
#		cant_jugadores.text = str(cant_necesaria-cant_actual)
		desconectar(body)
		bodys_empujando.pop_at(bodys_empujando.bsearch(body))
		bodys_moviendose.pop_at(bodys_moviendose.bsearch(body))

func entraCuerpo(body):
	if body.is_in_group('Player'):
		cant_actual += 1;
#		cant_jugadores.text = str(cant_necesaria-cant_actual)
		if not bodys_moviendose.has(body):
			bodys_empujando.push_back(body)
			conectar(body)
		


func _on_lado_izquierdo_body_entered(body):
	entraCuerpo(body)


func _on_lado_izquierdo_body_exited(body):
	saleCuerpo(body)


func _on_lado_derecho_body_entered(body):
	entraCuerpo(body)


func _on_lado_derecho_body_exited(body):
	saleCuerpo(body)


@rpc("unreliable_ordered")
func send_data(pos: Vector2, vel: Vector2, mi: float) -> void:
	global_position = lerp(global_position, pos, 0.5)
	velocity = lerp(velocity, vel, 0.5)

