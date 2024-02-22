extends Node2D

@export var pipe_scene: PackedScene

var game_running: bool
var game_over: bool
var score: int
var scroll: int
const SCROLL_SPEED: int = 4
var screen_size: Vector2i
var ground_height: int
var pipes: Array
const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $ground.get_node('Sprite2D').texture.get_height()
	#pipe_scene = 
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$game_over.hide()
	for pipe in pipes:
		get_tree().queue_delete(pipe)
	pipes.clear()
	update_score_label()
	#generate_pipes()
	$bird.reset()
	
func _input(event):
	if not game_over:
		if Input.is_action_pressed("fly"):
			if not game_running:
				start_game()
			else:
				if $bird.flying:
					$bird.flap()
					check_top()

func start_game():
	game_running = true
	$bird.flying = true
	$bird.flap()
	$pipe_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if game_running:
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
			
		$ground.position.x = -scroll
		
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

func _on_pipe_timer_timeout():
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
	
func scored():
	score += 1
	update_score_label()

func update_score_label():
	$score_label.text = "SCORE: " + str(score)

func check_top():
	if $bird.position.y < 0:
		$bird.falling = true
		stop_game()

func stop_game():
	$pipe_timer.stop()
	$game_over.show()
	$bird.flying = false
	game_running = false
	game_over = true

func bird_hit():
	$bird.falling = true
	stop_game()

func _on_ground_hit():
	$bird.falling = true
	stop_game()
	
func _on_game_over_restart():
	new_game()
