extends NpcState
class_name NpcWatch

@export var DETECTION_DISTANCE: float = 100.0
var looking_direction: Vector3
var player: Player = get_tree().get_first_node_in_group("player")

#See if the npc has the different state to see the possible transitions
var npc_has_idle_state = is_state_present("Idle")

func enter():
	set_npc_state()

func physics_update(_delta):
	var direction = player.global_position - npc.global_position
	try_transition_to_idle_state(direction)
	process_looking_direction(direction)

func process_looking_direction(direction: Vector3):
	var look_direction: Vector3 = Vector3(0,0,0)
	var last_looked_direction: Vector3 = looking_direction
	
	if direction.x < -16:
		look_direction.x = -1
	elif direction.x > 16:
		look_direction.x = 1
	else:
		if last_looked_direction.y == 0:
			look_direction.x = last_looked_direction.x
		
	if direction.y < -16:
		look_direction.y = -1
	elif direction.y > 16:
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
