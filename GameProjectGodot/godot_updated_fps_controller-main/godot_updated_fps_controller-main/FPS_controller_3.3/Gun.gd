extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var damage = 100

onready var head = $Head
onready var aimcast = $Head/Camera/Aimcast
onready var muzzle = $Head/Gun/Muzzle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	var direction = Vector3()
	
	if Input.is_action_just_pressed("fire"):
		if aimcast.is_colliding():
			var bullet = get_world().direct_space_state
			var collision = bullet.intersect_ray(muzzle.transform.origin, aimcast.get_collision_point())
			
			if collision:
				var target = collision.collider
				
				
