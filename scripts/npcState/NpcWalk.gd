extends NpcState
class_name NpcWalk

##The maximum walked distance
@export var walk_distance_max: float = 2
##The minimum walked distance
@export var walk_distance_min: float = 1
##The amount of deviation in the npc trajectory, 5 being +- a lot
@export_range(0, 5) var walk_deviation: float

var walk_distance: float = 2.0
var original_pos: Vector3
var direction: Vector3

#See if the npc has the different state to see the possible transitions
var npc_has_watch_state: bool
var npc_has_idle_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	check_other_states()
	anim_state.travel("Run")
	
	original_pos = npc.global_position
	npc.looking_direction = Vector2(roundf(randf_range(-1,1)), roundf(randf_range(-1,1)))
	direction = (Vector3(npc.looking_direction.x, 0, npc.looking_direction.y)).normalized()

func exit():
	npc.velocity = Vector3.ZERO

func physics_update(_delta):
	var direction_to_player = player.global_position - npc.global_position
	try_transition_to_watch_state(direction_to_player)

func update(delta):
	var walked_distance = (original_pos - npc.global_position).length()
	if !walk_distance <= walked_distance:
		if direction: npc.velocity = npc.velocity.move_toward(direction * WALK_SPEED , delta * ACCELERATION)
	else: npc.velocity = npc.velocity.move_toward(Vector3(0,0,0), delta * FRICTION)
	if npc and anim_tree: anim_tree.set("parameters/Run/blend_position", npc.looking_direction)
	try_go_back_base_position(delta)
	try_transition_to_idle_state()

func try_go_back_base_position(_delta):
	if ((npc.base_position - npc.global_position).length() > npc.max_distance_from_base_pos):
		npc.velocity = npc.velocity.move_toward(npc.base_position * WALK_SPEED , _delta * ACCELERATION)

func try_transition_to_idle_state():
	if npc.velocity == Vector3.ZERO:
		if npc_has_idle_state:
			transitioned.emit(self, "idle")

func try_transition_to_watch_state(direction: Vector3):
	if direction.length() < DETECTION_DISTANCE:
		if npc_has_watch_state:
			transitioned.emit(self, "watch")

func check_other_states():
	npc_has_watch_state = is_state_present("watch")
	npc_has_idle_state = is_state_present("idle")
