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

func physics_update(delta):
	compute_direction()
	npc.velocity = npc.velocity.move_toward(direction * WALK_SPEED , delta * ACCELERATION)
	if nav.is_target_reached() :
		npc.velocity = npc.velocity.move_toward(Vector3.ZERO, delta * FRICTION)

func update(_delta):
	compute_looking_direction()
	if anim_tree: anim_tree.set("parameters/Run/blend_position", npc.looking_direction)
	try_transition_to_idle_state()
	try_transition_to_watch_state()

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
		direction = nav.get_next_path_position() - npc.global_position
		direction = direction.normalized()

#---------Compute Looking Direction---------
func compute_looking_direction():
	var look_direction: Vector2 = Vector2.ZERO
	var last_looked_direction: Vector2 = npc.looking_direction
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
	npc.looking_direction = look_direction

#---------Manage States---------
func try_transition_to_idle_state():
	if npc.velocity == Vector3.ZERO:
		if npc_has_idle_state:
			transitioned.emit(self, "idle")

func try_transition_to_watch_state():
	var distance_to_player = (player.global_position - npc.global_position).length()
	if distance_to_player < DETECTION_DISTANCE:
		if npc_has_watch_state:
			transitioned.emit(self, "watch")

func check_other_states():
	npc_has_watch_state = is_state_present("watch")
	npc_has_idle_state = is_state_present("idle")
