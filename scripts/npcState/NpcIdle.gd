extends NpcState
class_name NpcIdle

##The maximum number of times the npc will look arround before trying to change state
@export_range(0, 10) var max_idle_turn: int = 1
##The minimum number of times the npc will look arround before trying to change state
@export_range(0, 10) var min_idle_turn: int = 1
##The maximum amount of time the npc will look in a direction
@export_range(0, 10) var max_idle_time: float = 3
##The minimum amount of time the npc will look in a direction
@export_range(0, 10) var min_idle_time: float = 2

var idle_turns: int
var current_idle_turn: int
var idle_time: float

#See if the npc has the different state to see the possible transitions
var npc_has_watch_state: bool
var npc_has_walk_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	check_other_states()
	randomize_looking_direction()
	
	idle_turns = randi_range(max_idle_turn, min_idle_turn)

func update(delta):
	if idle_time > 0:
		idle_time -= delta
	else:
		current_idle_turn+=1
		randomize_looking_direction()
		try_transition_to_walk_state()

func physics_update(_delta):
	var direction = player.global_position - npc.global_position
	try_transition_to_watch_state(direction)

func randomize_looking_direction():
	if npc and anim_tree:
		npc.looking_direction = Vector2(roundf(randf_range(-1,1)), roundf(randf_range(-1,1)))
		anim_tree.set("parameters/Idle/blend_position", npc.looking_direction)
	idle_time = randf_range(min_idle_time, max_idle_time)

func try_transition_to_watch_state(direction: Vector3):
	if direction.length() < DETECTION_DISTANCE:
		if npc_has_watch_state:
			transitioned.emit(self, "watch")

func try_transition_to_walk_state():
	if current_idle_turn >= idle_turns:
		if npc_has_watch_state:
			transitioned.emit(self, "walk")

func check_other_states():
	npc_has_watch_state = is_state_present("watch")
	npc_has_walk_state = is_state_present("walk")
