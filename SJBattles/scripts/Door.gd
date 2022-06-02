extends KinematicBody2D

func _on_player_open_door(var player):
	$AnimationPlayer.play("open")
