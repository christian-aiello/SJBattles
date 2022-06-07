extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

signal send_enemy_identity
#enemy_identity is going from player --> enemy --> battle_arena --> enemy
func _on_Player_battle_begin(enemy_identity) -> void:
	emit_signal("send_enemy_identity", enemy_identity)

func _on_BattleArena_enemy_setup(enemy_identity) -> void:
	var animations: = ["digasbarro", "gidaro", "mauti", "valeri"]
	var animation: = str(animations[enemy_identity])
	$AnimatedSprite.play(animation)


var horizontal_dist: = 200 #how far the attack animation should translate the enemy
var num_frames: = 30 #the number of frames for HALF of the attack animation
func _on_BattleArena_enemy_attack() -> void:
	#moving forward
	for i in range(num_frames):
		position.x -= horizontal_dist/num_frames
		$AttackTimer.start()
		yield($AttackTimer, "timeout")
		
	#moving backward
	for i in range(num_frames):
		position.x += horizontal_dist/num_frames
		$AttackTimer.start()
		yield($AttackTimer, "timeout")


