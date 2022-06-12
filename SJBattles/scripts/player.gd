extends KinematicBody2D

signal button_prompt
signal open_door
signal open_door_two
signal open_french_door
signal enter_door
signal player_stats_changed
signal battle_begin

const ACCELERATION = 10
const MAX_SPEED = 100
const FRICTION = 5

var velocity = Vector2.ZERO
var direction = Vector2(1, 0)

var action = false
var door_action = false


onready var AnimationPlayer = $AnimationPlayer

var health = PlayerVariables.health
var health_max = 100
var health_regeneration = 1
var mana = PlayerVariables.mana
var mana_max = 100
var mana_regeneration = 10

var attack_damage = 20

func _process(delta):
	
	if not action:
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
	self.direction = PlayerVariables.direction
	self.position.x = PlayerVariables.position_x
	self.position.y = PlayerVariables.position_y
	
func hit(damage):
	health -= damage
	emit_signal("player_stats_changed", self)
	if health <= 0:
		print('DEAD')
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
		PlayerVariables.direction = self.direction
		PlayerVariables.health = self.health
		PlayerVariables.mana = self.mana
		if PlayerVariables.door_entered == 'Door':
			emit_signal("open_door", self)
			yield(get_tree().create_timer(1.2), "timeout")
			AnimationPlayer.play("enter")
			yield(get_tree().create_timer(2), "timeout")
			PlayerVariables.position_x = 0
			PlayerVariables.position_y = 0
			get_tree().change_scene("res://scenes/floor1.tscn")
		elif PlayerVariables.door_entered == 'Door2':
			emit_signal("open_door_two", self)
			yield(get_tree().create_timer(1.2), "timeout")
			AnimationPlayer.play("enter")
			PlayerVariables.position_x = 0
			PlayerVariables.position_y = 0
			yield(get_tree().create_timer(1.2), "timeout")
			get_tree().change_scene("res://scenes/floor1.tscn")
		elif PlayerVariables.door_entered == 'french_door':
			emit_signal("open_french_door", self)
			yield(get_tree().create_timer(1.2), "timeout")
			AnimationPlayer.play("enter")
			PlayerVariables.position_x = 0
			PlayerVariables.position_y = 0
			yield(get_tree().create_timer(1.2), "timeout")
			get_tree().change_scene("res://scenes/french.tscn")
		elif PlayerVariables.door_entered == 'lu1':
			PlayerVariables.position_x = -1616
			PlayerVariables.position_y = -64
			yield(get_tree().create_timer(0.6), 'timeout')
			get_tree().change_scene("res://scenes/floor2.tscn")
		elif PlayerVariables.door_entered == 'ru1':
			PlayerVariables.position_x = 1616
			PlayerVariables.position_y = -64
			yield(get_tree().create_timer(0.6), 'timeout')
			get_tree().change_scene("res://scenes/floor2.tscn")
		elif PlayerVariables.door_entered == 'lu2':
			PlayerVariables.position_x = -1616
			PlayerVariables.position_y = -64
			yield(get_tree().create_timer(0.6), 'timeout')
			get_tree().change_scene("res://scenes/floor3.tscn")
		elif PlayerVariables.door_entered == 'rd2':
			PlayerVariables.position_x = 1616
			PlayerVariables.position_y = -160
			yield(get_tree().create_timer(0.6), 'timeout')
			get_tree().change_scene("res://scenes/floor1.tscn")
		elif PlayerVariables.door_entered == 'ld2':
			PlayerVariables.position_x = -1616
			PlayerVariables.position_y = -160
			yield(get_tree().create_timer(0.6), 'timeout')
			get_tree().change_scene("res://scenes/floor1.tscn")
		elif PlayerVariables.door_entered == 'ru2':
			PlayerVariables.position_x = 1616
			PlayerVariables.position_y = -64
			yield(get_tree().create_timer(0.6), 'timeout')
			get_tree().change_scene("res://scenes/floor3.tscn")
		elif PlayerVariables.door_entered == 'rd3':
			PlayerVariables.position_x = 1616
			PlayerVariables.position_y = -160
			yield(get_tree().create_timer(0.6), 'timeout')
			get_tree().change_scene("res://scenes/floor2.tscn")
		elif PlayerVariables.door_entered == 'ld3':
			PlayerVariables.position_x = -1616
			PlayerVariables.position_y = -160
			yield(get_tree().create_timer(0.6), 'timeout')
			get_tree().change_scene("res://scenes/floor2.tscn")
			
		print(PlayerVariables.door_entered)
		
		
		
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
		elif target.name == 'french_door' and direction == Vector2(0, -1):
			if door_action != true:
				door_action = true
				PlayerVariables.door_entered = 'french_door'
				emit_signal("button_prompt", self)
		else:
			if door_action != false and get_tree().get_current_scene().get_name() == 'main':
				door_action = false
				emit_signal("button_prompt", self)
				
		
	else:
		if door_action != false and get_tree().get_current_scene().get_name() == 'main':
			door_action = false
			emit_signal("button_prompt", self)
		
	
	var battle_target = $RayCast2D.get_collider()
	if battle_target != null:
		if battle_target.name == "OverworldBoss":
			PlayerVariables.enemy_encountered = 0
			get_tree().change_scene("res://scenes/BattleArena.tscn")

func _on_Door_body_entered(body):
	if body.name == 'Player':
		PlayerVariables.position_x = -32
		PlayerVariables.position_y = -448
		get_tree().change_scene("res://scenes/main.tscn")

func _on_lu1_body_entered(body):
	if body.name == 'Player':		
		door_action = true
		PlayerVariables.door_entered = 'lu1'
		emit_signal("button_prompt", self)

func _on_lu1_body_exited(body):
	if body.name == 'Player':
		door_action = false
		PlayerVariables.door_entered = null
		emit_signal("button_prompt", self)
		
func _on_ru1_body_entered(body):
	if body.name == 'Player':
		door_action = true
		PlayerVariables.door_entered = 'ru1'
		emit_signal("button_prompt", self)

func _on_ru1_body_exited(body):
	if body.name == 'Player':
		door_action = false
		PlayerVariables.door_entered = null
		emit_signal("button_prompt", self)


func _on_lu2_body_entered(body):
	if body.name == 'Player':
		door_action = true
		PlayerVariables.door_entered = 'lu2'
		emit_signal("button_prompt", self)


func _on_lu2_body_exited(body):
	if body.name == 'Player':
		door_action = false
		PlayerVariables.door_entered = null
		emit_signal("button_prompt", self)


func _on_ru2_body_entered(body):
	if body.name == 'Player':		
		door_action = true
		PlayerVariables.door_entered = 'ru2'
		emit_signal("button_prompt", self)


func _on_ru2_body_exited(body):
	if body.name == 'Player':
		door_action = false
		PlayerVariables.door_entered = null
		emit_signal("button_prompt", self)


func _on_rd2_body_entered(body):
	if body.name == 'Player':		
		door_action = true
		PlayerVariables.door_entered = 'rd2'
		emit_signal("button_prompt", self)


func _on_rd2_body_exited(body):
	if body.name == 'Player':
		door_action = false
		PlayerVariables.door_entered = null
		emit_signal("button_prompt", self)


func _on_ld2_body_entered(body):
	if body.name == 'Player':		
		door_action = true
		PlayerVariables.door_entered = 'ld2'
		emit_signal("button_prompt", self)


func _on_ld2_body_exited(body):
	if body.name == 'Player':
		door_action = false
		PlayerVariables.door_entered = null
		emit_signal("button_prompt", self)


func _on_rd3_body_entered(body):
	if body.name == 'Player':		
		door_action = true
		PlayerVariables.door_entered = 'rd3'
		emit_signal("button_prompt", self)


func _on_ld3_body_entered(body):
	if body.name == 'Player':		
		door_action = true
		PlayerVariables.door_entered = 'ld3'
		emit_signal("button_prompt", self)


func _on_ld3_body_exited(body):
	if body.name == 'Player':
		door_action = false
		PlayerVariables.door_entered = null
		emit_signal("button_prompt", self)

func _on_rd3_body_exited(body):
	if body.name == 'Player':
		door_action = false
		PlayerVariables.door_entered = null
		emit_signal("button_prompt", self)


func _on_rd1_body_entered(body: Node) -> void:
	pass # Replace with function body.


func _on_rd1_body_exited(body: Node) -> void:
	pass # Replace with function body.



func _on_ld1_body_entered(body: Node) -> void:
	pass # Replace with function body.


func _on_ld1_body_exited(body: Node) -> void:
	pass # Replace with function body.


func _on_lu3_body_entered(body: Node) -> void:
	pass # Replace with function body.


func _on_lu3_body_exited(body: Node) -> void:
	pass # Replace with function body.


func _on_ru3_body_entered(body: Node) -> void:
	pass # Replace with function body.


func _on_ru3_body_exited(body: Node) -> void:
	pass # Replace with function body.
