extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_BattleArena_enemy_setup(enemy_identity) -> void:
	var animations: = ["digasbarro", "gidaro", "mauti", "valeri", "binelli", "lionti", "pantaleo", "tauro"]
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


