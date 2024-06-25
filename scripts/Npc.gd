extends CharacterBody3D
class_name Npc

@export var sprite_texture: Texture2D
@onready var anim_tree = $AnimationTree

func _ready():
	change_skin()
	anim_tree.active = true

func change_skin():
	var sprite = get_node("Sprite")
	if sprite_texture:
		sprite.set_texture(sprite_texture)
