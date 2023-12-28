extends Control

@onready var score_label: Label = $ScoreLabel
@onready var high_score_label: Label = $HighScoreLabel
@onready var menu: Control = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var save_game_path := "user://savedata.save"
var score := 0
var high_score := 0
var game_started := false

func _ready() -> void:
	%GameOverLabel.hide()
	load_score()
	Events.connect("set_score", set_score)
	Events.connect("game_over", set_game_over)
	high_score_label.text = "high score: %s" % high_score
	show_menu()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		show_menu()

func set_score(value) -> void:
	score += value
	score_label.text = "score: %s" % score
	if score > high_score:
		high_score = score
		high_score_label.text = "high score: %s" % high_score
		save_score()

func save_score() -> void:
	var file = FileAccess.open(save_game_path, FileAccess.WRITE)
	file.store_var(high_score)

func load_score() -> void:
	if FileAccess.file_exists(save_game_path):
		var file = FileAccess.open(save_game_path, FileAccess.READ)
		high_score = file.get_var()
	else:
		high_score = 0 

func show_menu() -> void:
	animation_player.play("show_menu")
	await animation_player.animation_finished
	get_tree().paused = true
	menu.visible = true

func hide_menu() -> void:
	animation_player.play("hide_menu")
	await animation_player.animation_finished
	menu.visible = false
	get_tree().paused = false

func set_game_over() -> void:
	show_menu()
	%StartResumeButton.hide()
	%GameOverLabel.show()

func _on_start_resume_button_pressed() -> void:
	hide_menu()
	if !game_started:
		Events.emit_signal("spawn_arena")
		game_started = true

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	menu.show()
	game_started = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
