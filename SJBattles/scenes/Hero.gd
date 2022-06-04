extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.



func _on_BattleArena_hero_default() -> void:
	
	$Player/AnimationPlayer.play("idle_right")


func _on_BattleArena_hero_attack() -> void:
	
	$Player/AnimationPlayer.play("right_attack")
