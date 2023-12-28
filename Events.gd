extends Node

# Auto-loaded node that only emits signals.
# Any node in the game can use it to emit signals, like so:
		# Events.emit_signal("mob_died", 10)

# Any node in the game can connect to the events:

	#Events.connect("mob_died", update_score)

# This allows nodes to easily communicate accross the project without needing to
# know about each other. We mainly use it to update the heads-up display, like
# the player's health and score

signal add_score(value)
signal set_alive
signal set_health(value)
signal set_target(value)
signal set_score(value)
signal set_difficulty(value)
signal set_speed(value)
signal gun_pickup
signal health_pickup(value)
signal clear_pickups
signal game_over
signal spawn_bubble(value)
signal spawn_arena
