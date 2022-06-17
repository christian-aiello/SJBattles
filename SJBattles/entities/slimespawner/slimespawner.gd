extends Node2D

export var spawn_area : Rect2 = Rect2(256, 256, 544, 544)
export var max_slimes = 10
export var start_slimes = 3
var slime_count = 0
var slime_scene = preload("res://Entities/slime/slime.tscn")

# Random number generator
var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	
	for x in range(start_slimes):
		instance_slime()
	slime_count = start_slimes
	
func _on_Timer_timeout():
	if slime_count < max_slimes:
		instance_slime()
		slime_count = slime_count + 1

func instance_slime():
	var slime = slime_scene.instance()
	add_child(slime)
	
	# Place the skeleton in a valid position
	slime.position.x = spawn_area.position.x + rng.randf_range(0, spawn_area.size.x)
	slime.position.y = spawn_area.position.y + rng.randf_range(0, spawn_area.size.y)
