extends StaticBody2D
class_name Arena

@onready var bubble_to_spawn := preload("res://Enemies/Bubble.tscn")
@onready var difficulty_pickup = preload("res://Pickups/difficulty_pickup.tscn")
@onready var gun_pickup = preload("res://Pickups/gun_pickup.tscn")
@onready var health_pickup = preload("res://Pickups/health_pickup.tscn")
@onready var speed_pickup = preload("res://Pickups/speed_pickup.tscn")
@onready var pick_up_list := [difficulty_pickup, gun_pickup, health_pickup, speed_pickup]
@onready var pickup_left: Marker2D = $PickupSpawnPositions/PickupLeft
@onready var pickup_right: Marker2D = $PickupSpawnPositions/PickupRight
@onready var pickup_locations := [pickup_left, pickup_right]

var speed := 55
var amount_to_spawn := 30

func _ready() -> void:
	Events.connect("set_speed", set_speed)
	randomize()
	for i in amount_to_spawn:
		spawn_bubble()
	spawn_pickups()

func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > 2000:
		queue_free()

func spawn_bubble() -> void:
	var bubble = bubble_to_spawn.instantiate()
	add_child(bubble)
	%PathFollow2D.progress_ratio = randf()
	bubble.global_position = %PathFollow2D.global_position

func spawn_pickups() -> void:
	randomize()
	var counter := 0
	for i in 2:
		var pickup = pick_up_list[randi() % pick_up_list.size()]
		var spawn_pickup = pickup.instantiate()
		add_child(spawn_pickup)
		spawn_pickup.position = pickup_locations[counter].position
		counter += 1

func set_speed(value) -> void:
	speed += value

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	Events.emit_signal("spawn_arena")

func _on_detection_area_body_entered(body: Node2D) -> void:
		if body is Player:
			var target = body
			Events.emit_signal("set_target", target)
			%DetectionArea.set_deferred("monitoring", false)
			%DetectionArea.set_deferred("monitorable", false)

