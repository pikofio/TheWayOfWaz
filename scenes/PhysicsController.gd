extends Node2D

#AnimationController signals
signal is_moving
signal is_idle
signal is_running
signal is_jumping
signal is_falling

#variables for physic behavior
var speed = 60 #walking speed
var run_speed = 200
var acceleration = speed + 0.5 * speed
var jump_force = 400
var gravity = 20
var phys_weight_x = 0.2



#other variables which are not states but are needed
var wall_face := Vector2.ZERO
var velocity := Vector2.ZERO
var mv_input := Vector2.ZERO
var mv_dir : int
var jump_current : int
var jump_max = 1



#IMPORTANT STATES!! so nodes can behave ;)
var IS_MOVING : bool
var IS_RUNNING : bool
var IS_JUMPING : bool
var IS_FALLING : bool
var IS_ON_GROUND : bool
var IS_ON_WALL : bool
var BLOCK_INPUT := Vector2i.ZERO


#get parent node
@onready var parent : Node = get_parent()

func _physics_process(delta):
	#update check states
	update_states()



#####VERTICAL MOVEMENT#####
	check_for_ground()
	#this is gravity!
	if !IS_ON_GROUND:
		velocity.y += gravity
		if velocity.y > 0:
			IS_FALLING = true
			emit_signal("is_falling")

	if IS_ON_GROUND:
		#vertical velocity handler JUMP
		if !BLOCK_INPUT.y:
			if Input.is_action_just_pressed("move_jump"):
				IS_JUMPING = true
				emit_signal("is_jumping")
				jump()

####HORIZONTAL MOVEMENT####

	#gets horizontal input from Input Map
	mv_input.x = Input.get_axis("move_left","move_right")


	#horizontal velocity handler
	if !BLOCK_INPUT.x:
		check_for_horizontal_input()
		#handles only input movement
		if mv_input.x != 0:
			velocity.x = lerp(velocity.x,mv_input.x * acceleration,phys_weight_x)
		if mv_input.x == 0:
			velocity.x = lerp(velocity.x,.0,phys_weight_x)

		#handles running
		if IS_MOVING:
			if Input.is_action_pressed("move_run"):
				if !IS_RUNNING:
					IS_RUNNING = true
					emit_signal("is_running")
			if Input.is_action_just_released("move_run"):
				IS_MOVING = false
				IS_RUNNING = false



	#send velocity to KinematicBody2D
	parent.velocity = velocity
	parent.move_and_slide()



func check_for_horizontal_input() -> void:
	if mv_input.x != 0 and not IS_MOVING:
		IS_MOVING = true
		emit_signal("is_moving")

		if IS_RUNNING:
			emit_signal("is_running")

	if mv_input.x == 0 and IS_MOVING:
		IS_MOVING = false
		emit_signal("is_idle")

	if IS_RUNNING:
		acceleration = 200
	if !IS_RUNNING:
		acceleration = 90


func check_for_ground() -> void:
	if IS_ON_GROUND:
		IS_JUMPING = false
		if velocity.y == 0 && IS_FALLING:
			IS_FALLING = false
			IS_MOVING = false
		velocity.y = 0
		jump_current = 0


func update_states() -> void: 
	IS_ON_GROUND = parent.is_on_floor()
	IS_ON_WALL = parent.is_on_wall()
	wall_face = parent.get_wall_normal()


func jump():
	if jump_current < jump_max:
		jump_current += 1
		velocity.y = -jump_force
