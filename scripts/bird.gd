extends CharacterBody2D

const G: int = 1000
const MAX_VEL: int = 600
const FLAP_SPEED: int = -500
const START_POS = Vector2(100, 400)

var flying: bool = false
var falling: bool = false

func _ready():
	reset()

func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)
	
func _physics_process(delta):
	if flying or falling:
		velocity.y += G * delta
		
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$animation_sprite.play()
		elif falling:
			set_rotation(PI/2)
			$animation_sprite.stop()
		move_and_collide(velocity * delta)
	else:
		$animation_sprite.stop()
	#if Input.is_action_pressed("fly"):
	#	$animation_sprite.play("flying")

func flap():
	velocity.y = FLAP_SPEED
