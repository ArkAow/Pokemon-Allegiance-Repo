extends NpcState
class_name NpcIdle

@export var DETECTION_DISTANCE: float = 4.0
var looking_direction: Vector2
var idle_time: float
var player: Player

#See if the npc has the different state to see the possible transitions
var npc_has_watch_state = is_state_present("Watch")

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	randomize_looking_direction()

func update(delta: float):
	if idle_time > 0:
		idle_time -= delta
	else:
		randomize_looking_direction()

func physics_update(_delta):
	var direction = player.global_position - npc.global_position
	try_transition_to_watch_state(direction)

func randomize_looking_direction():
	if npc and anim_tree:
		looking_direction = Vector2(roundf(randf_range(-1,1)), roundf(randf_range(-1,1)))
		anim_tree.set("parameters/Idle/blend_position", looking_direction)
	idle_time = randf_range(2, 3)

func try_transition_to_watch_state(direction: Vector3):
	if direction.length() < DETECTION_DISTANCE:
		transitioned.emit(self, "watch")
