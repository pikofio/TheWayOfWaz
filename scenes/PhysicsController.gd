extends Node2D


#variables for physic behavior
var speed = 400
var acceleration = speed + 0.5 * speed
var jump_force = 800
var gravity = 50
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
var IS_JUMPING : bool
var IS_ON_GROUND : bool
var IS_ON_WALL : bool
var IS_HOLDING_ON_WALL : bool
var BLOCK_INPUT := Vector2i.ZERO

#IS KEY (BEING)PRESSED
var IS_PRESSED_JUMP_BTN : bool #will work on function so pressing jump will be registered for a little longer



#get parent node
@onready var parent : Node = get_parent()


func _physics_process(delta):
	#update check states
	update_states()



#####VERTICAL MOVEMENT#####

	#this is gravity!
	if not IS_ON_GROUND:
		velocity.y += gravity
	if IS_ON_GROUND:
		IS_JUMPING = false
		velocity.y = 0
		jump_current = 0
		#vertical velocity handler JUMP
		if !BLOCK_INPUT.y:
			if Input.is_action_just_pressed("move_jump"):
				IS_JUMPING = true
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


####WALL INTERACTIONS####
	if IS_ON_WALL:
		if Input.is_action_pressed("hold_on_wall"):
			IS_HOLDING_ON_WALL = true
			BLOCK_INPUT.x = true
			velocity = Vector2(0,0)
		else:
			if IS_HOLDING_ON_WALL:
				BLOCK_INPUT.x = false

		#wall jump
		if !BLOCK_INPUT.y:
			if Input.is_action_just_pressed("move_jump"):
				IS_HOLDING_ON_WALL = false
				BLOCK_INPUT.x = false
				IS_JUMPING = true
				
				velocity = Vector2(speed * wall_face.x,-jump_force)
				IS_MOVING = true
				#on wall jump: just fall down with no vertical velocity
				if Input.is_action_pressed("move_down"):
					velocity.y = 0



	print_debug(IS_MOVING , IS_JUMPING)
	#send velocity to KinematicBody2D
	parent.velocity = velocity
	parent.move_and_slide()



func check_for_horizontal_input() -> void:
	if mv_input.x != 0 and not IS_MOVING:
		IS_MOVING = true
	if mv_input.x == 0 and IS_MOVING:
		IS_MOVING = false



func update_states() -> void: 
	IS_ON_GROUND = parent.is_on_floor()
	IS_ON_WALL = parent.is_on_wall()
	wall_face = parent.get_wall_normal()



func jump():
	if jump_current < jump_max:
		jump_current += 1
		velocity.y = -jump_force
