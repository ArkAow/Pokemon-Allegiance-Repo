extends NpcState
class_name NpcWatch

#See if the npc has the different state to see the possible transitions
var npc_has_idle_state: bool
var npc_has_walk_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	anim_state.travel("Idle")

func physics_update(_delta):
	var direction = player.global_position - npc.global_position
	try_transition_to_idle_state(direction)
	npc.compute_looking_direction(direction)
	anim_tree.set("parameters/Idle/blend_position", npc.looking_direction)

#---------Manage States---------
func try_transition_to_idle_state(direction: Vector3):
	if direction.length() > DETECTION_DISTANCE:
		if npc_has_idle_state:
			transitioned.emit(self, "idle")

func check_other_states():
	npc_has_idle_state = is_state_present("Watch")
	npc_has_walk_state = is_state_present("Walk")
