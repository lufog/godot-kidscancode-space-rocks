extends Area2D


signal explode
signal shoot

var bullet_scene: PackedScene = preload("res://bullet/enemy_bullet/enemy_bullet.tscn")

var follow: PathFollow2D
var speed: float = 250
var accuracy: float = 0.1
var health: float =  Global.enemy_health
var target: Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_player: AudioStreamPlayer = $ShootPlayer
@onready var enemy_paths: Node = $EnemyPaths
@onready var pulse_timer: Timer = $PulseTimer


func _ready() -> void:
	var path_index = randi() % enemy_paths.get_child_count()
	var path = enemy_paths.get_children()[path_index]
	follow = PathFollow2D.new()
	follow.loop = false
	path.add_child(follow)
	shoot_timer.wait_time = 1.5
	shoot_timer.start()


func _process(delta: float) -> void:
	follow.progress += speed * delta
	position = follow.global_position
	if follow.progress_ratio >= 1:
		queue_free()


func _on_shoot_timer_timeout() -> void:
	if target.visible:
		shoot_player.play()
		_shoot_pulse(3, 0.1)



func damage(amount: float) -> void:
	if is_queued_for_deletion():
		return
	
	health -= amount
	animation_player.play("hit")
	if health <= 0:
		Global.score += Global.enemy_points
		explode.emit(position)
		queue_free()


func _shoot_pulse(n: int, delay: float) -> void:
	for i in range(n):
		_shoot_1()
		pulse_timer.wait_time = delay
		pulse_timer.start()
		await pulse_timer.timeout
	

func _shoot_1() -> void:
	var dir := global_position - target.global_position
	shoot.emit(bullet_scene, global_position, dir.angle() - PI / 2 + randf_range(-accuracy, accuracy))


func _shoot_3() -> void:
	var dir := global_position - target.global_position
	for a in [-0.1, 0, 0.1]:
		shoot.emit(bullet_scene, global_position, dir.angle() - PI / 2 + randf_range(-accuracy, accuracy))
