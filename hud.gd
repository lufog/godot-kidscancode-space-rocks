extends CanvasLayer


@onready var _tree := get_tree()
@onready var score_label: Label = $ScoreLabel
@onready var shield_bar: TextureProgressBar = $ShieldBar
@onready var message_label: Label = $MessageLabel
@onready var message_timer: Timer = $MessageTimer
@onready var pause_pop_up: Panel = $PausePopUp


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_toggle"):
		Global.paused = not Global.paused
		_tree.paused = Global.paused
		pause_pop_up.visible = Global.paused
		message_label.visible = not Global.paused


func _on_message_timer_timeout() -> void:
	message_label.hide()
	message_label.text = ""


func update(player: Player) -> void:
	update_shield(player.shield_level)


func update_score(value: int) -> void:
	score_label.text = str(value)


func show_message(text: String) -> void:
	message_label.text = text
	message_label.show()
	message_timer.start()


func update_shield(shield_level: float) -> void:
	var color = "green"
	
	if shield_level < 40:
		color = "red"
	elif shield_level < 70:
		color = "yellow"
	
	var texture = load("res://textures/bar_horizontal_%s_mid.png" % color)
	shield_bar.texture_progress = texture
	shield_bar.value = shield_level
