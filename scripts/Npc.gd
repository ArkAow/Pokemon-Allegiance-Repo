extends CharacterBody3D
class_name Npc

@export var sprite_texture: Texture2D
@onready var anim_tree = $AnimationTree
const GRAVITY: float = 9.8

func _ready():
	change_skin()
	anim_tree.active = true

func _process(delta):
	if not is_on_floor(): velocity.y -= GRAVITY * delta
	move_and_slide()

func change_skin():
	var sprite = get_node("Sprite3D")
	if sprite_texture:
		sprite.set_texture(sprite_texture)
