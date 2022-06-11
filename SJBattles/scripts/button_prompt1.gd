extends Node

func _on_Player_button_prompt(var player):
	print('W')
	self.visible = player.door_action
