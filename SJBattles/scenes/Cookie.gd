extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


func cookie_found():
	$Sprite.hide()
	$CollisionShape2D.disabled = true
	PlayerVariables.num_cookies += 1


