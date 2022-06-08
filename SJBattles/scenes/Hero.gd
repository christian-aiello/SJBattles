extends Node2D




func _on_BattleArena_hero_default() -> void:
	$Player/AnimationPlayer.play("idle_right")


func _on_BattleArena_hero_attack() -> void:
	$Player/AnimationPlayer.play("right_attack")
