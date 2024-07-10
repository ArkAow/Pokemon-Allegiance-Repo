class_name NpcBubbleManager extends Node

@onready var bubble: AnimatedSprite3D = $"../Bubble"
enum animation_type {ALERT, DIALOGUE}


func manage_npc_bubble_enter(type: animation_type):
	if bubble.animation_finished.is_connected(set_npc_bubble_visibility):
		bubble.animation_finished.disconnect(set_npc_bubble_visibility)
	
	match type:
		animation_type.ALERT:
			bubble.animation_finished.connect(play_alert_bubble_animation)
		animation_type.DIALOGUE:
			bubble.animation_finished.connect(play_dialogue_bubble_animation)
	set_npc_bubble_visibility(true)
	bubble.play("pop_bubble")

func manage_npc_bubble_exit():
	bubble.animation_finished.connect(set_npc_bubble_visibility)
	bubble.play("depop_bubble")

func play_alert_bubble_animation():
	bubble.animation_finished.disconnect(play_alert_bubble_animation)
	bubble.play("alert_bubble")

func play_dialogue_bubble_animation():
	bubble.animation_finished.disconnect(play_alert_bubble_animation)
	bubble.play("dialogue_bubble")

func set_npc_bubble_visibility(visibility: bool = false):
	bubble.visible = visibility
