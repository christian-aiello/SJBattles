extends KinematicBody2D

signal button_prompt
signal open_door
signal enter_door

const ACCELERATION = 10
const MAX_SPEED = 100
const FRICTION = 10

var velocity = Vector2.ZERO
var direction = Vector2.ZERO

var door_action = false

onready var AnimationPlayer = $AnimationPlayer

func _ready():
	emit_signal("button_prompt", self)
	
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength('right') - Input.get_action_strength('left')
	input_vector.y = Input.get_action_strength('down') - Input.get_action_strength('up')
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
		
		direction = input_vector
		
		if input_vector.x > 0:
			AnimationPlayer.play('left')
		elif input_vector.x < 0:
			AnimationPlayer.play('right')
		else:
			if input_vector.y > 0:
				AnimationPlayer.play('down')
			elif input_vector.y < 0:
				AnimationPlayer.play('up')
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	if Input.is_action_pressed('interact') and door_action:
		emit_signal("open_door", self)
		$AnimationPlayer.play("enter_door")
		yield(get_tree().create_timer(1.2), "timeout")
		get_tree().change_scene("res://scenes/hallway.tscn")
		
	move_and_collide(velocity * delta * MAX_SPEED)
	
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 32
		
	var target = $RayCast2D.get_collider()
	if target != null:
		if target.name.find('Door') >= 0 and direction == Vector2(0, -1):
			if door_action != true:
				door_action = true
				emit_signal("button_prompt", self)
		else:
			if door_action != false:
				door_action = false
				emit_signal("button_prompt", self)
	else:
		door_action = false
		emit_signal("button_prompt", self)
		

		
	


