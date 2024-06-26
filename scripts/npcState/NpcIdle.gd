extends NpcState
class_name NpcIdle

var idle_time: float
var player: Player

#See if the npc has the different state to see the possible transitions
var npc_has_watch_state: bool
var npc_has_walk_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	check_other_states()
	randomize_looking_direction()

func update(delta):
	if idle_time > 0:
		idle_time -= delta
	else:
		randomize_looking_direction()
		try_transition_to_walk_state()

func physics_update(_delta):
	var direction = player.global_position - npc.global_position
	try_transition_to_watch_state(direction)

func randomize_looking_direction():
	if npc and anim_tree:
		npc.looking_direction = Vector2(roundf(randf_range(-1,1)), roundf(randf_range(-1,1)))
		anim_tree.set("parameters/Idle/blend_position", npc.looking_direction)
	idle_time = randf_range(2, 3)

func try_transition_to_watch_state(direction: Vector3):
	if direction.length() < DETECTION_DISTANCE:
		if npc_has_watch_state:
			transitioned.emit(self, "watch")

func try_transition_to_walk_state():
	if npc_has_watch_state:
		transitioned.emit(self, "walk")

func check_other_states():
	npc_has_watch_state = is_state_present("watch")
	npc_has_walk_state = is_state_present("walk")
