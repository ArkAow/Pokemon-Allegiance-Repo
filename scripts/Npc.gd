extends CharacterBody3D
class_name Npc

##The png file that will be the npc's appearence
@export var sprite_texture: Texture2D
##The max distance at which the npc can be from spawn point
@export var max_distance_from_base_pos: float = 5
@onready var anim_tree = $AnimationTree
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

func change_skin():
	var sprite = get_node("Sprite3D")
	if sprite_texture:
		sprite.set_texture(sprite_texture)

#---------Compute Looking Direction---------
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

	if _direction.z < -0.5:
		look_direction.y = -1
	elif _direction.z > 0.5:
		look_direction.y = 1
	else:
		if look_direction.x == 0:
			look_direction.y = last_looked_direction.y
	looking_direction = look_direction
