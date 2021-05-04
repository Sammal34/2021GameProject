extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var camera

const SPEED = 6 
const ACCELERATION = 3
const DE_ACCELERATION = 5



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	camera = get_node("../Camera").get_global_transform()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	var dir = Vector3() 
	
	if(Input.is_action_pressed("move_fw")):
		
	
