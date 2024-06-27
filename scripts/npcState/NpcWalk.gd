extends NpcState
class_name NpcWalk

##The maximum walked distance
@export var walk_distance_max: float = 2
##The minimum walked distance
@export var walk_distance_min: float = 1
##The amount of deviation in the npc trajectory, 5 being +- a lot
@export_range(0, 5) var walk_deviation: float
@onready var nav: NavigationAgent3D = $"../../NavigationAgent3D"

var walk_distance: float = 2.0
var original_pos: Vector3
var target_pos: Vector3
var direction: Vector3

#See if the npc has the different state to see the possible transitions
var npc_has_watch_state: bool
var npc_has_idle_state: bool

func enter():
	set_npc_state()
	player = get_tree().get_first_node_in_group("Player")
	check_other_states()
	anim_state.travel("Run")
	
	walk_distance = randf_range(walk_distance_min, walk_distance_max)
	original_pos = npc.global_position
	npc.looking_direction = Vector2(roundf(randf_range(-1,1)), roundf(randf_range(-1,1)))
	compute_target_position()

func exit():
	npc.velocity = Vector3.ZERO

func physics_update(_delta):
	var distance_to_player = (player.global_position - npc.global_position).length()
	try_transition_to_watch_state(distance_to_player)

func update(delta):
	compute_direction()
	var walk_direction = Vector3(direction.x, 0, direction.z)
	npc.velocity = npc.velocity.lerp(walk_direction * WALK_SPEED , delta * ACCELERATION)
	if nav.is_target_reached():
		npc.velocity = npc.velocity.move_toward(Vector3(0,0,0), delta * FRICTION)
	if npc and anim_tree: anim_tree.set("parameters/Run/blend_position", npc.looking_direction)
	try_transition_to_idle_state()

#---------Compute navigation---------
func compute_target_position():
	#If too far from spawn, go back
	if (npc.global_position - npc.spawn_position).length() > npc.max_distance_from_base_pos:
		target_pos = npc.spawn_position
	#Else, go to the desired position
	else:
		target_pos = Vector3(original_pos.x+(npc.looking_direction.x * walk_distance), original_pos.y, original_pos.z+(npc.looking_direction.y * walk_distance))

func compute_direction():
	if target_pos: 
		nav.target_position = target_pos
		direction = nav.get_next_path_position() - original_pos
		direction = direction.normalized()

#---------Manage States---------
func try_transition_to_idle_state():
	if npc.velocity == Vector3.ZERO:
		if npc_has_idle_state:
			transitioned.emit(self, "idle")

func try_transition_to_watch_state(distance: float):
	if distance < DETECTION_DISTANCE:
		if npc_has_watch_state:
			transitioned.emit(self, "watch")

func check_other_states():
	npc_has_watch_state = is_state_present("watch")
	npc_has_idle_state = is_state_present("idle")
