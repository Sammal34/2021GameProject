extends KinematicBody

var gravity = -25
var velocity = Vector3()
var camera
var anim_player
var character

const SPEED = 6 
const ACCELERATION = 3
const DE_ACCELERATION = 5


var jump_speed = 6  # jump strength
var spin = 0.1  # rotation speed

var jump = false



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():

	camera = get_node("Target/Camera").get_global_transform()
	anim_player = get_node("AnimationPlayer")
	character = get_node(".")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	
	var dir = Vector3() 
	var is_moving = false
	
	if(Input.is_action_pressed("move_fw")):
		dir += -camera.basis.z
		is_moving = true
	if(Input.is_action_pressed("move_bw")):
		dir += camera.basis.z
		is_moving = true
	if(Input.is_action_pressed("move_l")):
		dir += -camera.basis.x
		is_moving = true
	if(Input.is_action_pressed("move_r")):
		dir += camera.basis.x
		is_moving = true
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * gravity
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION
	
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	
	hv = hv.linear_interpolate(new_pos, accel * delta)
	velocity.x = hv.x 
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if is_moving:
		var angle = atan2(hv.x, hv.z)
		
		var char_rot = character.get_rotation()
		
		char_rot.y = angle
		character.set_rotation(char_rot)
		
	
	jump = false
	if Input.is_action_just_pressed("Jump"):
		jump = true
	if jump and is_on_floor():
		velocity.y = jump_speed




