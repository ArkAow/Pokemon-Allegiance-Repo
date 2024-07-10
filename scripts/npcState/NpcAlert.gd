extends NpcState
class_name NpcAlert

#See if the npc has the different state to see the possible transitions
var npc_has_wait_state: bool
var npc_has_watch_state: bool
var npc_has_walk_state: bool
var npc_has_idle_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	anim_state.travel("Idle")
	bubble_manager.manage_npc_bubble_enter(bubble_manager.animation_type.ALERT)

func update(_delta):
	try_transition_to_wait_state()

func physics_update(_delta):
	if Input.is_action_pressed("ui_accept"):
		npc.dialogue_actioned()

func exit():
	bubble_manager.manage_npc_bubble_exit()

#---------Manage States---------
func try_transition_to_wait_state():
	if npc_has_wait_state:
		if !npc.is_seeing_player():
			transitioned.emit(self, "wait")

func check_other_states():
	npc_has_wait_state = is_state_present("wait")
	npc_has_watch_state = is_state_present("watch")
	npc_has_walk_state = is_state_present("walk")
	npc_has_idle_state = is_state_present("idle")
