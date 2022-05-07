extends AnimatedSprite2D

func _on_Player_send_animation(velocity):
	if velocity.y < 0:
		play("jump")
	elif velocity.x != 0:		
		flip_h = velocity.x < 0
		play("walk")
	else:
		play("idle")
