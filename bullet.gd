extends Area2D
class_name Bullet

var speed := 800

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	

func _on_body_entered(body: Node2D) -> void:
	if body is Arena:
		queue_free()



func _on_area_entered(area: Area2D) -> void:
	if area is Bubble:
		queue_free()
