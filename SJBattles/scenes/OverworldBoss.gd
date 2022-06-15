extends KinematicBody2D

func _ready() -> void:
	$Sprite.hide()
	$CollisionShape2D.disabled = true
	
func _physics_process(delta: float) -> void:
	$Sprite.show()
	$CollisionShape2D.disabled = false
