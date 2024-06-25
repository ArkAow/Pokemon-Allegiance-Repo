extends State
class_name NpcState

@export var npc: CharacterBody3D
var anim_tree: AnimationTree
var state_machine: StateMachine

func set_npc_state():
	anim_tree = npc.get_node("AnimationTree")
	state_machine = get_parent()

func is_state_present(state_name: String) -> bool:
	if state_machine and "states" in state_machine:
		for state in state_machine.states.values():
			if state.get_name() == state_name:
				return true
	return false
