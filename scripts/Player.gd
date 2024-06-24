@icon("res://assets/icons/player-icon.png")
class_name Player extends CharacterBody3D

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
const WALK_SPEED: float = 3.0
const ACCELERATION: float = 30.0
const FRICTION: float = 30.0
const GRAVITY: float = 9.8
var input_direction: Vector2
var direction: Vector3

func _ready():
	anim_tree.active = true

func _process(delta):
	if not is_on_floor(): velocity.y -= GRAVITY * delta

func _physics_process(delta):
	input_direction = Input.get_vector("ui_west","ui_east","ui_north","ui_south")
	direction = (Vector3(input_direction.x, 0, input_direction.y)).normalized()
	player_animation()
	player_movement(delta)
	move_and_slide()

func player_animation():
	# All the code's logic to process the player's animation
	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Run/blend_position", input_direction)
	if velocity == Vector3.ZERO: anim_state.travel("Idle")
	else: anim_state.travel("Run")

func player_movement(delta):
	# All the code's logic to process the player's movement
	if direction: velocity = velocity.move_toward(direction * WALK_SPEED , delta * ACCELERATION)
	else: velocity = velocity.move_toward(Vector3(0,0,0), delta * FRICTION)
