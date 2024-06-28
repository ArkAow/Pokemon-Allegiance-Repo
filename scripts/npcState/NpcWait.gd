extends NpcState
class_name NpcWait

@export var base_look_direction: Vector2 = Vector2.ZERO

#See if the npc has the different state to see the possible transitions
var npc_has_watch_state: bool
var npc_has_walk_state: bool
var npc_has_idle_state: bool

func enter():
	print("enter wait")
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	anim_state.travel("Idle")
	compute_waiting_direction()

func exit():
	print("exit wait")

func update(_delta):
	try_transition_to_watch_state()

#---------Manage animation---------
func compute_waiting_direction():
	if base_look_direction != Vector2.ZERO:
		var temp = Vector3(base_look_direction.x, 0, base_look_direction.y)
		npc.compute_looking_direction(temp)
	anim_tree.set("parameters/Idle/blend_position", npc.looking_direction)

#---------Manage States---------
func try_transition_to_watch_state():
	var direction = player.global_position - npc.global_position
	if direction.length() < DETECTION_DISTANCE:
		if npc_has_watch_state:
			transitioned.emit(self, "watch")

func check_other_states():
	npc_has_watch_state = is_state_present("watch")
	npc_has_walk_state = is_state_present("walk")
	npc_has_idle_state = is_state_present("idle")
