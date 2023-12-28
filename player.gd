extends CharacterBody2D
class_name Player

@onready var bullet_to_instance := preload("res://Bullet/Bullet.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var shoot_pos_center: Marker2D = $ShootPosCenter
@onready var shoot_pos_bottom: Marker2D = $ShootPosBottom
@onready var shoot_pos_top: Marker2D = $ShootPosTop
@onready var shoot_pos_list := [shoot_pos_bottom, shoot_pos_top]

var smooth_mouse_movement := Vector2.ZERO
var screen_size 
var damage_taken := -5
var alive := true

func _ready() -> void:
	screen_size = get_viewport_rect().size
	Events.connect("set_alive", set_death)
	Events.connect("gun_pickup", activate_extra_guns)

func _physics_process(_delta: float) -> void:
	if alive:
		set_playable_area()
		set_movement()
		set_mouse_movement()
		if Input.is_action_just_pressed("shoot"):
			shoot()
			%AudioStreamPlayer.playing = true
		move_and_slide()
	if position.y >= 1100:
		Events.emit_signal("game_over")
	
func shoot() -> void:
	var bullet = bullet_to_instance.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_transform = shoot_pos_center.global_transform

func shoot_extra_guns() -> void:
	randomize()
	var pos_to_spawn = shoot_pos_list[randi() % shoot_pos_list.size()]
	var bullet = bullet_to_instance.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_transform = pos_to_spawn.global_transform

func activate_extra_guns() -> void:
	%ShootTimer.autostart = true
	%ShootTimer.start()
	%PickupTimer.start()

func set_playable_area() -> void:
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func set_mouse_movement() -> void:
	smooth_mouse_movement = lerp(smooth_mouse_movement, get_global_mouse_position(), 0.3)
	look_at(smooth_mouse_movement)

func set_movement() -> void:
	var speed := 675.0
	var drag_factor := 0.05
	var direction := Input.get_vector("left", "right", "up", "down")
	var desired_velocity = speed * direction
	var steering_vector = desired_velocity - velocity
	velocity += steering_vector * drag_factor

func set_death() -> void:
	alive = false
	animation_player.play("death")
	await animation_player.animation_finished
	particles.emitting = true
	await particles.finished
	Events.emit_signal("game_over")

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area is Bubble:
		Events.emit_signal("set_health", damage_taken)
		animation_player.play("hit")

func _on_shoot_timer_timeout() -> void:
	shoot_extra_guns()

func _on_pickup_timer_timeout() -> void:
	%ShootTimer.autostart = false
	%ShootTimer.stop()
	
