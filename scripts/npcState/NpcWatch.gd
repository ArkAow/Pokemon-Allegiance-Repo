extends NpcState
class_name NpcWatch

@export var DETECTION_DISTANCE: float = 4.0
var looking_direction: Vector2
var player: Player

var npc_has_idle_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	npc_has_idle_state = is_state_present("Idle")

func physics_update(_delta):
	var direction = player.global_position - npc.global_position
	try_transition_to_idle_state(direction)
	process_looking_direction(direction)

func process_looking_direction(direction: Vector3):
	var look_direction: Vector2 = Vector2.ZERO
	var last_looked_direction: Vector2 = looking_direction

	if direction.x < -0.4:
		look_direction.x = -1
	elif direction.x > 0.4:
		look_direction.x = 1
	else:
		if last_looked_direction.y == 0:
			look_direction.x = last_looked_direction.x

	if direction.z < -0.5:
		look_direction.y = -1
	elif direction.z > 0.5:
		look_direction.y = 1
	else:
		if look_direction.x == 0:
			look_direction.y = last_looked_direction.y

	looking_direction = look_direction
	anim_tree.set("parameters/Idle/blend_position", looking_direction)

func try_transition_to_idle_state(direction: Vector3):
	if direction.length() > DETECTION_DISTANCE:
		if npc_has_idle_state:
			transitioned.emit(self, "idle")
