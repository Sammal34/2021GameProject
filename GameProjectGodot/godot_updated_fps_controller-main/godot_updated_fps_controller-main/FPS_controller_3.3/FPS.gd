extends KinematicBody

var melee_damage = 50

var speed 
var default_move_speed = 5
var crouch_move_speed = 2.5
var crouch_speed = 20 
var accel_type = {"default": 40, "air": 1}
onready var accel = accel_type["default"]
var gravity = 20
var jump = 6.5
var default_height = 1.5
var crouch_height = 0.5

var current_weapon = 1
var cam_accel = 40
var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()
var damage = 100

var health = 100

onready var swingcast = $Head/Camera/Hand/Hammers/swing
onready var pcap = $CollisionShape
onready var aimcast = $Head/Camera/Hand/Gun/AimCast
onready var muzzle = $Head/Gun/Muzzle
onready var bullet = preload("res://Bullet.tscn")
onready var hit = preload("res://WallHit.tscn")
onready var Gun = $Head/Camera/Hand/Gun
onready var Hammer = $Head/Camera/Hand/Hammers

onready var EnemyHealth = $Enemy/Health

onready var melee_anim = $AnimationPlayer
onready var hitbox = $Head/Camera/Hitbox


onready var head = $Head
onready var camera = $Head/Camera

func melee():
	if Input.is_action_just_pressed("fire"):
		if not melee_anim.is_playing():
			melee_anim.play("Attack")
			melee_anim.queue("Return")

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if current_weapon < 2:
					current_weapon += 1
				else:
					current_weapon = 1
			if event.button_index == BUTTON_WHEEL_DOWN:
				if current_weapon < 1:
					current_weapon -= 1
				else:
					current_weapon = 2


	if PlayerHealth.health <=0:
		queue_free()

func weapon_select():
	if Input.is_action_just_pressed("weapon1"):
		current_weapon = 1
	elif Input.is_action_just_pressed("weapon2"):
		current_weapon = 2
		if Input.is_action_just_pressed("fire"):
			if not melee_anim.is_playing():
				melee_anim.play("Attack")
				melee_anim.queue("Return")
	
	if current_weapon == 1:
		Gun.visible = true
		Gun.shoot()
	else:
		Gun.visible = false
	
	if current_weapon == 2:
		Hammer.visible = true
	else:
		Hammer.visible = false
	
	

func _process(delta):
	
	
	
	weapon_select()
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
		speed = default_move_speed
	#get keyboard input
		var direction = Vector3()
		if current_weapon ==2:
			if Input.is_action_just_pressed("fire"):
				print("swing")
				if swingcast.is_colliding():
					if swingcast.get_collider().is_in_group("Enemy"):
						print("hit enemy")
						var enemy = swingcast.get_collider()
						enemy.health -=1
						if enemy.health <=0:
							enemy.queue_free()
							EnemyHealth =- 1
							
		if current_weapon == 1:
			if Input.is_action_just_pressed("fire"):
#			print("swagnus")
				var musicNode = $Gunshot
				musicNode.play()
				if aimcast.is_colliding():
					if aimcast.get_collider().is_in_group("Enemy"):
						print("hit enemy")
						var enemy = aimcast.get_collider()
						enemy.health -=1
						if enemy.health <=0:
							enemy.queue_free()
							EnemyHealth =- 1
#				var b = hit.instance()
#				get_tree().get_root().add_child(b)
#				b.set_translation(aimcast.get_collision_point())
#				#b.shoot = true
#				print("AMONGUS")
		var h_rot = global_transform.basis.get_euler().y
		var f_input = Input.get_action_strength("move_bw") - Input.get_action_strength("move_fw")
		var h_input = Input.get_action_strength("move_r") - Input.get_action_strength("move_l")
		direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
		
		if Input.is_action_pressed("crouch"):
			pcap.shape.height -= crouch_speed * delta
			speed = crouch_move_speed
		else: 
			pcap.shape.height += crouch_speed * delta
			
			
		pcap.shape.height = clamp(pcap.shape.height, crouch_height, default_height)
			
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
		melee()
	
	
#func _on_Area_area_entered(area):
#	if area.is_in_group("Enemy"):
#		print("Hit Me")
#		PlayerHealth.take_damage(10)
#
#		area.queue_free()


