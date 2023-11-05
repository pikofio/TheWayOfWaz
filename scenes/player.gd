extends CharacterBody2D

@onready var ph_ctl = $PhysicsController
@onready var animator = $AnimationController
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ph_ctl.IS_JUMPING:
		$MainSprite/Spadow.position.y -= velocity.y/300
	
	if velocity.x < 0:
		$MainSprite.flip_h = true
	if velocity.x > 0:
		$MainSprite.flip_h = false
