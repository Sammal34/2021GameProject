extends KinematicBody

onready var nav = $"../Navigation" as Navigation
onready var player = $"../FPS" as KinematicBody

var path = []
var current_node = 0
var speed = 2

func _ready():
#	print(nav)
#	print(path)
	pass

func _physics_process(delta):
	
#	if aimcast.is_colliding("Enemy.tscn"):
#		queue_free()
	
	if current_node < path.size():
		var direction: Vector3 = path[current_node] - global_transform.origin
		if direction.length() <= .1:
			current_node += 1
		else:
#			print("Dir: ", direction)
			move_and_slide(direction.normalized() * speed)

func update_path(target_position):
	path = nav.get_simple_path(global_transform.origin, target_position)
	


func _on_Timer_timeout():
	print("lookin for da playa")
	update_path(player.global_transform.origin)


func _on_Hitting_body_entered(body):
	if body.is_in_group("Player"):
		PlayerHealth.take_damage(10)
#		queue_free() # Replace with function body.
