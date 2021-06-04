extends KinematicBody

var speed = 4
var accel_type = {"default": 40, "air": 1}
onready var accel = accel_type["default"]
var gravity = 20
var jump = 6.5

var cam_accel = 40
var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var damage = 100


onready var aimcast = $Head/Camera/AimCast
onready var muzzle = $Head/Gun/Muzzle
onready var bullet = preload("res://Bullet.tscn")
onready var hit = preload("res://WallHit.tscn")


onready var head = $Head
onready var camera = $Head/Camera

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
func _physics_process(delta):
	#get keyboard input
		var direction = Vector3()
		if Input.is_action_just_pressed("fire"):
			print("swagnus")
			
			if aimcast.is_colliding():
				var b = hit.instance()
				get_tree().get_root().add_child(b)
				b.set_translation(aimcast.get_collision_point())
				#b.shoot = true
				print("AMONGUS")
				
		var h_rot = global_transform.basis.get_euler().y
		var f_input = Input.get_action_strength("move_bw") - Input.get_action_strength("move_fw")
		var h_input = Input.get_action_strength("move_r") - Input.get_action_strength("move_l")
		direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
		if is_on_floor():
			snap = -get_floor_normal()
			accel = accel_type["default"]
			gravity_vec = Vector3.ZERO
		else:
			snap = Vector3.DOWN
			accel = accel_type["air"]
			gravity_vec += Vector3.DOWN * gravity * delta
		
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * jump
	
	#make it move
		velocity = velocity.linear_interpolate(direction * speed, accel * delta)
		movement = velocity + gravity_vec
	
		move_and_slide_with_snap(movement, snap, Vector3.UP)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
