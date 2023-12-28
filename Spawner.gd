extends Node2D


var amount_to_spawn := 30
var speed := 55

func _ready() -> void:
	Events.connect("spawn_arena", spawn_arena)
	Events.connect("set_difficulty", set_difficulty)
	Events.connect("set_speed", set_speed)

func spawn_arena() -> void:
	var arena_to_spawn := preload("res://Arenas/arena.tscn")
	var arena = arena_to_spawn.instantiate()
	add_child(arena)
	arena.position.y = -10
	arena.amount_to_spawn = amount_to_spawn
	arena.speed = speed

func set_difficulty(value) -> void:
	amount_to_spawn += value

func set_speed(value) -> void:
	speed += value
