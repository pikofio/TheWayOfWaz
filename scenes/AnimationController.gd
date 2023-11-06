extends Node2D

@onready var animator : AnimationTree = $AnimationTree
#get parent node
@onready var parent : Node = get_parent()

func _ready():
	animator.active = true
	
func _process(delta):
	pass

func _on_physics_controller_is_idle():
	disable_all()
	animator["parameters/conditions/IS_IDLE"] = true

func _on_physics_controller_is_moving():
	disable_all()
	animator["parameters/conditions/IS_WALKING"] = true

func _on_physics_controller_is_running():
	disable_all()
	animator["parameters/conditions/IS_RUNNING"] = true
	
func _on_physics_controller_is_jumping():
	disable_all()
	animator["parameters/conditions/IS_JUMPING"] = true
	
func disable_all() ->void:
	animator["parameters/conditions/IS_JUMPING"] = false
	animator["parameters/conditions/IS_RUNNING"] = false
	animator["parameters/conditions/IS_IDLE"] = false
	animator["parameters/conditions/IS_WALKING"] = false
