extends NpcState
class_name NpcWait

@export var base_look_direction: Vector2 = Vector2(0, -1)

#See if the npc has the different state to see the possible transitions
var npc_has_watch_state: bool
var npc_has_walk_state: bool
var npc_has_idle_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	anim_state.travel("Idle")



func check_other_states():
	npc_has_watch_state = is_state_present("watch")
	npc_has_walk_state = is_state_present("walk")
	npc_has_idle_state = is_state_present("idle")
