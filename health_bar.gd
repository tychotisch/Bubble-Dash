extends Control


@onready var health_progress_bar: ProgressBar = $HealthProgressBar

var health := 100

func _ready() -> void:
	set_health_ui()
	Events.connect("set_health", set_health)
	Events.connect("health_pickup", set_health)

func _process(_delta: float) -> void:
	if health <= 0:
		Events.emit_signal("set_alive")

func set_health_ui() -> void:
	health_progress_bar.max_value = health
	#set_health_label()
	set_health_progress_bar()

func set_health_progress_bar() -> void:
	health_progress_bar.value = health

func set_health(value):
	health += value
	set_health_progress_bar()
