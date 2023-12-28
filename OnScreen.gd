extends Control

@onready var score_label: Label = $ScoreContainer/ScoreLabel

var score := 0

func _ready() -> void:
	Events.connect("set_score", set_score)

func set_score(value) -> void:
	score += value
	score_label.text = "score: %s" % score
