extends State
class_name NpcState

const WALK_SPEED: float = 1.0
const ACCELERATION: float = 30.0
const FRICTION: float = 50.0
const GRAVITY: float = 9.8

##The range, in meter, at which the npc can detect the player
@export_range(0, 5) var DETECTION_DISTANCE: float = 3.0
@onready var npc: CharacterBody3D = $"../.."

var anim_tree: AnimationTree
var state_machine: StateMachine
var player: Player

func set_npc_state():
	anim_tree = npc.get_node("AnimationTree")
	state_machine = get_parent()

func is_state_present(state_name: String) -> bool:
	for state in state_machine.states:
		if state == state_name.to_lower():
			return true
	return false
