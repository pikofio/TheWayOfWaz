extends CharacterBody2D

var speed = 300
var jump_speed = 50
var gravity = 1000
var mv_input = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print_debug(mv_input,velocity)
	velocity.y += gravity * delta
	
	mv_input.x = Input.get_axis("ui_left","ui_right")

	velocity.x = mv_input.x * speed
	
	move_and_slide()
