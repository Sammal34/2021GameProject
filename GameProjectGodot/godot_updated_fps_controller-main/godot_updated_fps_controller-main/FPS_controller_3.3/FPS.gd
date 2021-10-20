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

onready var swingcast = $Head/Camera/Hand/swing
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
						enemy.health -=2
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
						enemy.take_damage(1)
						
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

#
#Achievement Criteria
#Achievement
#Achievement with Merit
#Achievement with Excellence
#Present a reflective analysis of developing a digital outcome.
#Present an in-depth reflective analysis of developing a digital outcome.
#Present an insightful reflective analysis of developing a digital outcome.
#
#
#Type your School Code and 9-digit National Student Number (NSN) into the header at the top of this page. (If your NSN has 10 digits, omit the leading zero.)
#
#Answer all parts of the assessment task in this document.
#
#Your answer should be presented in 12pt Arial font, within the expanding text boxes, and may only include information you produce during this examination session.
#
#You may not access the Internet, except to access the digital outcome if necessary.
#
#You should aim to write between 800–1500 words in total.
#
#Save your finished work as a PDF file with the file name used in the header at the top of this page (“SchoolCode-YourNSN-91909.pdf”).
#
#By saving your work at the end of the examination, you are declaring that this work is your own. NZQA may sample your work to ensure that this is the case.
#
#
#
#
#
#© New Zealand Qualifications Authority, 2020. All rights reserved.
#No part of this publication may be reproduced by any means without the prior permission of the New Zealand Qualifications Authority
#
#INSTRUCTIONS
#Read all parts of the assessment task before you begin.
#Choose any digital outcome that you developed during the year. 
#
#Type your chosen digital outcome in the space below: 
#Dungeon Game (A fps level based game)
#
#
#Begin your answers on page 3.
#
#
#ASSESSMENT TASK
#
#
#(a)	(i)	Explain the digital outcome that you developed, referring specifically to its digital aspects.
#My digital outcome for Dungeon Game was a first person level based PVE game, where the player would go through rooms in the level and kill the enemies using a range of weapons. The aim is for the player to get through the level without dying and going to the next floor. There are three floors until the player can beat the game. When the player beats the game, the game ends and the player can play it again or quit at their own choice. The game uses WASD movement mechanics because of how commonly they are used in many other games, the player also controls the direction of which the player can look around giving them a 360 degree view. This gives the player more freedom in the game and allows them to move around the level where they want. When the game is being played the player has two weapons that they can select, one being a close ranged melee weapon and the other being a gun where the player can shoot the enemies while having distance between them. the player can swap the weapons using numbers 1 and 2 on the keyboard. I made the game to have good user accessibility and tried to make the game as easy for Inexperienced and Experienced players as possible.
#
#
#
#(ii)	Explain how decisions you made in the development process are linked to the characteristics of your chosen digital outcome, referring to:
#the selection of the tools and techniques used to develop the outcome
#the influence of stakeholder feedback.
#In the creation of my game I decided to use a kanban board called Trello that was suggested by my teacher, Trello was very useful to develop the outcome of my game, Trello was used to display information outside of my game, it allowed me to make rows and columns and create an order of what needed to be made and produced first, In my trello there were 8 columns which were sections that I could put notes and lists underneath them. The use of this board was vital for me to create my desired outcome because it became a guideline. 
#I also used Github which is a backup and storing program that allowed me to have previous saves of my game and made it so my game couldn’t corrupt and I’d lose anything.
#To create and code my game I used a program called Godot. Godot is a software that lets the user create anything that they can with the resources that are within the Godot engine, this lets users create anything they want on Godot. I decided to use Godot in this program because I have used it previously, it is also a program that my teacher has worked on a lot. This was very useful to me because he could provide me with help and material to create my desired outcome when I didn't know how to or couldn’t.
#When creating my desired outcome I received stakeholder feedback from my classmates and pairs, this feedback allowed me to change and tweak my game with the knowledge and insight from someone who experienced and played my game. some of the feedback included “Making the sounds quieter” ,“Add a crouch feature” and “and make the player be able to swing the hammer without the gun shooting” I implemented some of this user feedback into my game other than being able to turn the sound down, because I’m going to implement a volume controller and because loud = funny. The most vital piece of information was with adding two different ways to attack, prior to this when you swung the melee weapon the gun would shoot which was very heavily flawed, I implemented this into my game and it changed my desired outcome.
#
#
#
#(b)	(i)	Explain how decisions you made affected the development process of your chosen digital outcome’s characteristics, referring to:
#the selection of the tools and techniques used to develop the outcome, AND
#the influence of stakeholder feedback.
#The use of the tools I used in my game changed the development of my final outcome in many ways. I had many decisions in my game and development process that changed my final development process. Some of these decisions were the use of the programs I used, If i hadn’t used Godot I would have struggled a lot more in creating my game as I have previous experience in it, If I hadn’t used trello then I would’ve found it harder to know what I had done, needed to do, trello was very helpful in gathering all of my resources and need resources for the creation of my desired outcome. 
#The techniques that I used in my game creation was very useful and changed what my desired outcome wouldn’t have been if I didn’t use them, some of these techniques I used in my game were free player movement and giving the player freedom in the game that they were playing, If I was to make the game where the player would move on a grid like a chess board it would’ve changed the way that the game was played completely, the game would’ve become a strategy based game. 
#The influence of the stakeholder feedback was huge, it made me make decisions of how the player would experience the game, The player feedback helped me add more of a free moving element where they can duck, jump, run and sprint, this made me have to learn different movement mechanics in the game and I had to understand vectors and 3 dimensional planes more in godot, this changed how the  game was played very heavily.
#
#
#
#(ii)	Explain how the development process of your chosen digital outcome was guided by the new knowledge and skills that you gained during that process.
#My development process of my digital outcome was guided by the new skills and knowledge that I learnt throughout the process. Some of the new skills that I used in the creation of my game were directional player movement, the understanding of variables and Aimcasts.
#Directional player movement was very big in the creation of my game and is the main way that the player plays the game without the mechanics used against the enemies. The player movement is one of the most important things for the player to utilise because without it the game wouldn’t be able to be played or completed.
#The understanding of variables in more depth was very strong in creating my game for many reasons. variables were one of the most important things in the creation of my game, without learning how to use variables more and using them strongly many of the aspects in my game wouldn’t be able to be utilized, without variables the game probably wouldn’t run.
#My new knowledge of aimcasts was very strong in my game and helped me understand and create shooting and attacking mechanics in my game. If in my game there weren’t aimcasts, players wouldn’t be able to shoot or use the melee weapon that is in the game. 
#
#
#
#(c)	(i)	What could have been done differently to improve both the development process and digital outcome? In your answer, explain why this would have improved the process and outcome.
#
#
#
#
#
#(ii)	What general conclusions can you draw from your completed digital outcome and / or the development process? In your answer, refer to any TWO of:
#usability
#aesthetics
#accessibility
#





