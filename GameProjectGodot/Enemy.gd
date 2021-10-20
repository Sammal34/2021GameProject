extends KinematicBody

onready var nav = $"../Navigation" as Navigation
onready var player = $"../FPS" as KinematicBody

var path = []
var current_node = 0
var speed = 2
var health = 5

func _ready():
	print ("value")
#	print(path)
	pass

#func set_rotation():
#	Enemy.axis


func _physics_process(delta):
	
#	if aimcast.is_colliding("Enemy.tscn"):
#		queue_free()
	
	if current_node < path.size():
		var direction: Vector3 = path[current_node] - global_transform.origin
		if direction.length() <= .1:
			current_node += 1
		else:
#			print("Dir: ", direction)
			look_at(get_parent().get_node("FPS").global_transform.origin,Vector3.UP)
			rotation_degrees.x = 0
			rotation_degrees.z = 0
			move_and_slide(direction.normalized() * speed)
			$ZombieGirl/AnimationPlayer.play("Zombie Running (1)-loop")
	else:
		update_path(get_parent().get_node("FPS").global_transform.origin)
		current_node = 0
		
func update_path(target_position):
	path = nav.get_simple_path(global_transform.origin, target_position)
	


func _on_Timer_timeout():
	print("lookin for da playa")
	update_path(player.global_transform.origin)


func _on_Hitting_body_entered(body):
	if body.is_in_group("Player"):
		PlayerHealth.take_damage(10)
		$ZombieGirl/AnimationPlayer.play("Zombie Punching-loop")
#		queue_free() # Replace with function body.


func _on_Health_value_changed(value):
	print("value")
	pass # Replace with function body.

func take_damage(amount):
	health -=amount
	if health <=0:
		set_physics_process(false)
		$ZombieGirl/AnimationPlayer.play("Zombie Death-loop")
		yield(get_tree().create_timer(3.0),"timeout")
		queue_free()
