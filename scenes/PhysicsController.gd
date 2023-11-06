extends Node2D

#AnimationController signals
signal is_moving
signal is_idle
signal is_running
signal is_jumping


#variables for physic behavior
var speed = 90 #walking speed
var speed_run = 200
var acceleration = speed
var jump_force = 400
var gravity = 20
var phys_weight_x = 0.2


#other variables which are not states but are needed
var velocity := Vector2.ZERO
var mv_input := Vector2.ZERO
var jump_current : int
var jump_max = 1


#IMPORTANT STATES!! so nodes can behave ;)
var IS_IDLE : bool = false
var IS_MOVING : bool = false
var IS_RUNNING : bool = false
var IS_JUMPING : bool = false
var IS_ON_GROUND : bool = false
var BLOCK_INPUT := Vector2i.ZERO


#get parent node
@onready var parent : Node = get_parent()
@onready var animator : Node = $AnimationController

func _physics_process(delta):
	#check if player is on ground
	IS_ON_GROUND = parent.is_on_floor()

	check_for_ground()
	check_for_idle()
	check_for_input()

#####VERTICAL MOVEMENT#####
	#this is gravity!
	if !IS_ON_GROUND:
		velocity.y += gravity
		
	if IS_ON_GROUND:
		#vertical velocity handler JUMP
		if !BLOCK_INPUT.y:
			if Input.is_action_just_pressed("move_jump"):
				jump()

####HORIZONTAL MOVEMENT####

	#gets horizontal input from Input Map
	mv_input.x = Input.get_axis("move_left","move_right")

	#horizontal velocity handler
	if !BLOCK_INPUT.x:
		#make player run
		if IS_MOVING:
			if Input.is_action_pressed("move_run"):
				acceleration = speed_run
				IS_RUNNING = true
				if not IS_JUMPING:
					emit_signal("is_running")

		if Input.is_action_just_released("move_run"):
			acceleration = speed
			IS_RUNNING = false
			if IS_MOVING and not IS_JUMPING:
				emit_signal("is_moving")
		#handles only input movement
		if mv_input.x != 0:
			velocity.x = lerp(velocity.x,mv_input.x * acceleration,phys_weight_x)
		if mv_input.x == 0:
			velocity.x = lerp(velocity.x,.0,phys_weight_x)

	print_debug(" j ",IS_JUMPING," m ",IS_MOVING," r ",IS_RUNNING," g ",IS_ON_GROUND," i ",IS_IDLE)
	#send velocity to KinematicBody2D
	parent.velocity = velocity
	parent.move_and_slide()



func check_for_input() -> void:
	if mv_input.x != 0 and not IS_MOVING:
		IS_MOVING = true
		IS_IDLE = false
		emit_signal("is_moving")
	if mv_input.x == 0 and IS_MOVING:
		IS_MOVING = false
		if not IS_JUMPING:
			emit_signal("is_idle")
		
func check_for_ground() -> void:
	if IS_ON_GROUND and IS_JUMPING:
		IS_JUMPING = false
		velocity.y = 0
		jump_current = 0
		if IS_MOVING:
			emit_signal("is_moving")
			if IS_RUNNING:
				emit_signal("is_running")
		
func check_for_idle() -> void:
	if mv_input.x == 0 and IS_ON_GROUND:
		IS_IDLE = true
		if not IS_JUMPING:
			emit_signal("is_idle")
	
func jump():
	IS_JUMPING = true
	if jump_current < jump_max:
		jump_current += 1
		velocity.y = -jump_force
		emit_signal("is_jumping")
