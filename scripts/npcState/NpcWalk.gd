extends NpcState
class_name NpcWalk

const WALK_SPEED: float = 1.0
const ACCELERATION: float = 30.0
const FRICTION: float = 50.0
const GRAVITY: float = 9.8

@export var walk_distance_max: float
@export var walk_distance_min: float
@export_range(0, 5) var walk_deviation: float
var walk_distance: float = 2.0
var original_pos: Vector3
var direction: Vector3
var player: Player

#See if the npc has the different state to see the possible transitions
var npc_has_watch_state: bool
var npc_has_idle_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	check_other_states()
	
	original_pos = npc.global_position
	npc.looking_direction = Vector2(roundf(randf_range(-1,1)), roundf(randf_range(-1,1)))
	direction = (Vector3(npc.looking_direction.x, 0, npc.looking_direction.y)).normalized()

func update(delta):
	var walked_distance = (original_pos - npc.global_position).length()
	if !walk_distance <= walked_distance:
		if direction:
			npc.velocity = npc.velocity.move_toward(direction * WALK_SPEED , delta * ACCELERATION)
	else:
		npc.velocity = npc.velocity.move_toward(Vector3(0,0,0), delta * FRICTION)
	if npc.velocity == Vector3.ZERO:
		try_transition_to_idle_state()

func try_transition_to_idle_state():
	if npc_has_idle_state:
		transitioned.emit(self, "idle")

func check_other_states():
	npc_has_watch_state = is_state_present("watch")
	npc_has_idle_state = is_state_present("idle")
