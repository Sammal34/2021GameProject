extends KinematicBody

onready var nav = $"../Navigation" as Navigation
onready var player = $"../FPS" as KinematicBody

var path = []

func _ready():

	path = nav.get_simple_path(global_transform.origin, player.global_transform.origin)
	print(path)
