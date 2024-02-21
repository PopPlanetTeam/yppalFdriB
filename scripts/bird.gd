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
	
