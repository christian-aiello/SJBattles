extends KinematicBody2D

signal button_prompt
signal open_door
signal open_door_two
signal enter_door
signal player_stats_changed
signal battle_begin

const ACCELERATION = 10
const MAX_SPEED = 100
const FRICTION = 10

var velocity = Vector2.ZERO
var direction = Vector2(1, 0)

var action = false
var door_action = false


onready var AnimationPlayer = $AnimationPlayer

var health = 100
var health_max = 100
var health_regeneration = 1
var mana = 100
var mana_max = 100
var mana_regeneration = 10

var attack_damage = 20

func _process(delta):
	var new_mana = min(mana + mana_regeneration * delta, mana_max)
	if new_mana != mana:
		mana = new_mana
		emit_signal("player_stats_changed", self)

	var new_health = min(health + health_regeneration * delta, health_max)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)
		
func _ready():
	emit_signal("button_prompt", self)
	emit_signal("player_stats_changed", self)
	
func hit(damage):
	health -= damage
	emit_signal("player_stats_changed", self)
	if health <= 0:
		print('DEAD')
		get_tree().quit()
	else:
		pass
		
func _input(event):
	if event.is_action_pressed("textbook"):
		if mana >= 25:
			mana = mana - 25
			action = true
			
			var target = $RayCast2D.get_collider()
			if target != null:
				if target.name.find("Slime") >= 0:
					target.hit(attack_damage)
				
				
			if direction.x > 0:
				AnimationPlayer.play('right_attack')
			elif direction.x < 0:
				AnimationPlayer.play('left_attack')
			else:
				if direction.y > 0:
					AnimationPlayer.play('down_attack')
				elif direction.y < 0:
					AnimationPlayer.play('up_attack')
			yield(get_tree().create_timer(0.6), 'timeout')
			action = false
		
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	input_vector.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
		
		direction = input_vector
		
		if not action:
			if input_vector.x > 0:
				AnimationPlayer.play('right')
			elif input_vector.x < 0:
				AnimationPlayer.play('left')
			else:
				if input_vector.y > 0:
					AnimationPlayer.play('down')
				elif input_vector.y < 0:
					AnimationPlayer.play('up')
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
		if not action:
			if direction.x > 0:
				AnimationPlayer.play('idle_right')
			elif direction.x < 0:
				AnimationPlayer.play('idle_left')
			else:
				if direction.y > 0:
					AnimationPlayer.play('idle_down')
				elif direction.y < 0:
					AnimationPlayer.play('idle_up')
		
	if Input.is_action_pressed('interact') and door_action:
		action = true
		if PlayerVariables.door_entered == 'Door':
			emit_signal("open_door", self)
			yield(get_tree().create_timer(1.2), "timeout")
			AnimationPlayer.play("enter")
			yield(get_tree().create_timer(2), "timeout")
			get_tree().change_scene("res://scenes/hallway.tscn")
			get_tree().change_scene("res://scenes/hallway.tscn")
		elif PlayerVariables.door_entered == 'Door2':
			emit_signal("open_door_two", self)
			yield(get_tree().create_timer(1.2), "timeout")
			AnimationPlayer.play("enter")
			yield(get_tree().create_timer(1.2), "timeout")
			get_tree().change_scene("res://scenes/hallway.tscn")
		
	if not action:
		move_and_collide(velocity * delta * MAX_SPEED)
	else:
		move_and_collide(velocity * delta * MAX_SPEED * 0.3)
	
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 32
		
	var target = $RayCast2D.get_collider()
	if target != null:
		
		
		
		if target.name == 'Door' and direction == Vector2(0, -1):
			if door_action != true:
				door_action = true
				PlayerVariables.door_entered = 'Door'
				emit_signal("button_prompt", self)
		elif target.name == 'Door2' and direction == Vector2(0, -1):
			if door_action != true:
				door_action = true
				PlayerVariables.door_entered = 'Door2'
				emit_signal("button_prompt", self)
		else:
			if door_action != false:
				door_action = false
				emit_signal("button_prompt", self)
				
		
	else:
		door_action = false
		emit_signal("button_prompt", self)
		
	
	var battle_target = $RayCast2D.get_collider()
	if battle_target != null:
		if battle_target.name == "OverworldBoss":
			emit_signal("battle_begun", 0)
			get_tree().change_scene("res://scenes/BattleArena.tscn")

		

		
	


