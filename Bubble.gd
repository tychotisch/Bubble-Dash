extends Area2D
class_name Bubble

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explosion: CPUParticles2D = $Explosion
@onready var sprite: Sprite2D = $Sprite2D

var target
var speed := 150
var max_speed := 150
var on_screen := false
var score := randi() % 10

func _ready() -> void:
	randomize()
	speed = randi() % max_speed + 100
	Events.connect("set_target", set_target)

func _physics_process(delta: float) -> void:
	if target and on_screen:
		var direction = (target.global_position - global_position).normalized()
		position += speed * direction * delta
		rotation = position.angle_to_point(target.global_position)

func set_target(value) -> void:
	target = value

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	on_screen = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Bullet:
		%Hitbox.set_deferred("monitoring", false)
		Events.emit_signal("set_score", score)
		animation_player.play("death")
		await animation_player.animation_finished
		%AudioStreamPlayer.playing = true
		explosion.emitting = true
		await explosion.finished
		queue_free()

func _on_bubble_detection_area_entered(area: Area2D) -> void:
		if area is Bubble:
			area.speed += 15
			speed -= 15

