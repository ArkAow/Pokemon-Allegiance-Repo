extends CharacterBody3D
class_name Npc

##The png file that will be the npc's appearence
@export var sprite_texture: Texture2D
##The max distance at which the npc can be from spawn point
@export var max_distance_from_base_pos: float = 5
##The range, in meter, at which the npc can detect the player
@export_range(0, 5) var DETECTION_DISTANCE: float = 3.0

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite3D = $Sprite3D
@onready var ray: RayCast3D = $RayCast3D

const GRAVITY: float = 9.8
var looking_direction: Vector2 = Vector2.ZERO
var spawn_position: Vector3

func _ready():
	change_skin()
	anim_tree.active = true
	spawn_position = Vector3(global_position.x, 0, global_position.z)

func _process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	move_and_slide()

func _physics_process(delta):
	if is_detecting_player():
		cast_ray_to_player()

func change_skin():
	if sprite_texture:
		sprite.set_texture(sprite_texture)

#---------Compute Looking---------
func compute_looking_direction(_direction: Vector3):
	var look_direction: Vector2 = Vector2.ZERO
	var last_looked_direction: Vector2 = looking_direction

	if _direction.x < -0.4:
		look_direction.x = -1
	elif _direction.x > 0.4:
		look_direction.x = 1
	else:
		if last_looked_direction.y == 0:
			look_direction.x = last_looked_direction.x

	if _direction.z < -0.8:
		look_direction.y = -1
	elif _direction.z > 0.8:
		look_direction.y = 1
	else:
		if look_direction.x == 0:
			look_direction.y = last_looked_direction.y
	looking_direction = look_direction

func is_detecting_player()->bool:
	var player = get_tree().get_first_node_in_group("Player")
	var direction = player.global_position - global_position
	return direction.length() < DETECTION_DISTANCE

func cast_ray_to_player():
	var player = get_tree().get_first_node_in_group("Player")
	ray.target_position = player.global_position - global_position

func can_see_player()->bool:
	var target = ray.get_collider()
	if target is Player:
		return true
	return false
