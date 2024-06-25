extends NpcState
class_name NpcWalk

const WALK_SPEED: float = 3.0
const ACCELERATION: float = 30.0
const FRICTION: float = 30.0
const GRAVITY: float = 9.8

@export var walk_distance_max: float
@export var walk_distance_min: float
@export var walk_distance: float
@export_range(0, 10) var walk_deviation: float
var original_pos: Vector3
var player: Player

#See if the npc has the different state to see the possible transitions
var npc_has_watch_state: bool
var npc_has_idle_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	original_pos = npc.global_position
	npc_has_watch_state = is_state_present("Watch")
	npc_has_watch_state = is_state_present("Idle")

func update(_delta):
	var walked_distance = (original_pos - npc.global_position).length()
	if !walk_distance <= walked_distance:
		pass

func physics_update(_delta):
	pass
