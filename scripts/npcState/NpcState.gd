extends State
class_name NpcState

@export var DETECTION_DISTANCE: float = 4.0
@export var npc: CharacterBody3D
var anim_tree: AnimationTree
var state_machine: StateMachine

func set_npc_state():
	anim_tree = npc.get_node("AnimationTree")
	state_machine = get_parent()

func is_state_present(state_name: String) -> bool:
	for state in state_machine.states:
		print(state)
		if state == state_name.to_lower():
			return true
	return false
