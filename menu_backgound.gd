extends Node2D

@onready var obj1 = $obj1 
@onready var obj2 = $obj2
@onready var obj3 = $obj3
@onready var obj4 = $obj4

@onready var array = [obj1,obj2,obj3,obj4]
 
var down_dir = Vector2(0,200)
func _setObj(obj):
	obj.global_position.y = -(randi() % 300 + 10)
	obj.global_position.x =  randi() % 1000 + 10
	obj.set_axis_velocity(down_dir)
	pass
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for k in range(4):
		_setObj(array[k])
		array[k].add_constant_torque(randi()%500)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if obj1.global_position.y > 700:
		_setObj(obj1)
		
	if obj2.global_position.y > 700:
		_setObj(obj2)
	pass
