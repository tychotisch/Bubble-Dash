extends Area2D

func _ready() -> void:
	Events.connect("clear_pickups", clear_pickup)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.emit_signal("gun_pickup")
		$AnimationPlayer.play("pick_up")
		Events.emit_signal("clear_pickups")

func clear_pickup() -> void:
	$AnimationPlayer.play("pick_up")
	
