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
	manage_npc_bubble_enter()

func update(_delta):
	try_transition_to_wait_state()

func exit():
	manage_npc_bubble_exit()

#---------Manage Animations---------
func manage_npc_bubble_enter():
	npc.bubble.animation_finished.connect(play_alert_bubble_animation)
	npc.bubble.visible = true
	npc.bubble.play("pop_bubble")

func manage_npc_bubble_exit():
	npc.bubble.play("depop_bubble")
	await get_tree().create_timer(0.56).timeout
	npc.bubble.visible = false

func play_alert_bubble_animation():
	npc.bubble.play("alert_bubble")

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
