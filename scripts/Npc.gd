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
