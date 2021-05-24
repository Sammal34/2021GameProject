extends RigidBody

var shoot = false
const DAMAGE = 50
const SPEED = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	

func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z)

func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
		queue_free()
	else:
		queue_free()
		
	
