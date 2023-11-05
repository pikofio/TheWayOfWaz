extends Node2D

@onready var animator : AnimationTree = $AnimationTree
#get parent node
@onready var parent : Node = get_parent()

func _ready():
	animator.active = true
	
func _process(delta):
	pass

func _on_physics_controller_is_idle():
	animator["parameters/conditions/IS_IDLE"] = true
	
	animator["parameters/conditions/IS_WALKING"] = false
	animator["parameters/conditions/IS_RUNNING"] = false
	animator["parameters/conditions/IS_FALLING"] = false
	animator["parameters/conditions/IS_JUMPING"] = false

func _on_physics_controller_is_moving():
	animator["parameters/conditions/IS_WALKING"] = true
	
	animator["parameters/conditions/IS_IDLE"] = false
	animator["parameters/conditions/IS_RUNNING"] = false
	animator["parameters/conditions/IS_FALLING"] = false
	animator["parameters/conditions/IS_JUMPING"] = false

func _on_physics_controller_is_running():
	animator["parameters/conditions/IS_RUNNING"] = true
	
	animator["parameters/conditions/IS_IDLE"] = false
	animator["parameters/conditions/IS_WALKING"] = false
	animator["parameters/conditions/IS_FALLING"] = false
	animator["parameters/conditions/IS_JUMPING"] = false

func _on_physics_controller_is_falling():
	animator["parameters/conditions/IS_FALLING"] = true

	animator["parameters/conditions/IS_JUMPING"] = false
	animator["parameters/conditions/IS_RUNNING"] = false
	animator["parameters/conditions/IS_IDLE"] = false
	animator["parameters/conditions/IS_WALKING"] = false
	
func _on_physics_controller_is_jumping():
	animator["parameters/conditions/IS_JUMPING"] = true
	
	animator["parameters/conditions/IS_FALLING"] = false
	animator["parameters/conditions/IS_RUNNING"] = false
	animator["parameters/conditions/IS_IDLE"] = false
	animator["parameters/conditions/IS_WALKING"] = false
