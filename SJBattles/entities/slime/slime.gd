extends KinematicBody2D

signal death


var player
var rng = RandomNumberGenerator.new()
onready var AnimationPlayer = $AnimationPlayer

export var speed = 25
var direction : Vector2
var last_direction = Vector2(0, 1)
var countdown = 0

var health = 20

var attack_damage = 5
var attack_cooldown_time = 1500
var next_attack_time = 0

func hit(damage):
	health -= damage
	if health > 0:
		pass #Replace with damage code
	else:
		
		$Timer.stop()
		direction = Vector2.ZERO
		set_process(false)
		emit_signal("death")
		get_tree().queue_delete(self)
		

func _ready():
	player = get_tree().root.get_node("Root/Player")
	rng.randomize()
	
func _on_Timer_timeout():
	var rel_player_pos = player.position - position
	
	if rel_player_pos.length() <= 16:
		direction = Vector2.ZERO
		last_direction = rel_player_pos.normalized()
	elif rel_player_pos.length() <= 100 and countdown == 0:
		direction = rel_player_pos.normalized()
	elif countdown == 0:
		var random_number = rng.randf()
		if random_number < 0.05:
			direction = Vector2.ZERO
		elif random_number < 0.1:
			direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)
			
	if countdown > 0:
		countdown = countdown - 1
		
func _physics_process(delta):
	var movement = direction * speed * delta
	
	var collision = move_and_collide(movement)
	
	if collision != null and collision.collider.name != "Player":
		direction = direction.rotated(rng.randf_range(PI/4, PI/2))
		countdown = rng.randi_range(2, 5)
		
	if direction.x > 0.707:
		AnimationPlayer.play('right')
	elif direction.x < -0.707:
		AnimationPlayer.play('left')
	else:
		if direction.y > 0.707:
			AnimationPlayer.play('down')
		elif direction.y < -0.707:
			AnimationPlayer.play('up')
			
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 20
		
func _process(_delta):
	var now = OS.get_ticks_msec()
	if now >= next_attack_time:
		var target = $RayCast2D.get_collider()
		if target != null and target.name == "Player" and player.health > 0:
			player.hit(attack_damage)
			next_attack_time = now + attack_cooldown_time

		
