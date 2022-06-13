extends Node

func _on_Player_button_prompt(var player):
	self.visible = player.door_action
