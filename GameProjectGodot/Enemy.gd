extends KinematicBody

onready var nav = $"../Navigation" as Navigation
onready var player = $"../FPS" as KinematicBody

var path = []
var current_node = 0
var speed = 2


func _ready():
	path = nav.get_simple_path(global_transform.origin, player.global_transform.origin)
#	print(path)

func _physics_process(delta):
	if current_node < path.size():
		var direction: Vector3 = path[current_node] - global_transform.origin
		if direction.length() < 1:
			current_node += 1
		else:
			print("Dir: ", direction)
			move_and_slide(direction.normalized() * speed)
