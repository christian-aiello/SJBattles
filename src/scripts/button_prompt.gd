extends Node

func _on_player_button_prompt(var player):
	self.visible = player.door_action
