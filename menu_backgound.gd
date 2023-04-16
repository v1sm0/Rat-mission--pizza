extends Node2D

@onready var obj1 = $obj1 
@onready var obj2 = $obj2
 
var down_dir = Vector2(0,200)
# Called when the node enters the scene tree for the first time.
func _ready():
	obj1.global_position.y = randi() % 100 + 10
	obj1.global_position.x =  randi() % 1000 + 10
	obj1.set_axis_velocity(down_dir)
	obj2.add_constant_torque(randi()%500)
	
	obj2.global_position.y = randi() % 100 + 10
	obj2.global_position.x =  randi() % 1000 + 10
	obj2.set_axis_velocity(down_dir)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if obj1.global_position.y > 700:
		obj1.global_position.y = -(randi() % 300 + 10)
		obj1.global_position.x =  randi() % 1000 + 10
		obj1.set_axis_velocity(down_dir)
		
	if obj2.global_position.y > 700:
		obj2.global_position.y = -(randi() % 300 + 10)
		obj2.global_position.x =  randi() % 1000 + 10
		obj2.set_axis_velocity(down_dir)
	pass
