extends Node2D


var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	
	$Cookie.position.x = rng.randi_range(-1486, 1519)
	$Cookie.position.y = rng.randi_range(-82, -74)
