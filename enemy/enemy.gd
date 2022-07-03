extends Area2D


signal explode

var bullet_scene: PackedScene = preload("res://bullet/enemy_bullet/enemy_bullet.tscn")

var path: Path2D
var follow: PathFollow2D
var remote: Node2D
var speed: float = 250
var accuracy: float = 0.1
var health: float
var target: Node2D
var pulse_timer: Timer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bullet_container: Node = $BulletContainer
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_player: AudioStreamPlayer = $ShootPlayer
@onready var enemy_paths: Node = $EnemyPaths


func _ready() -> void:
	pulse_timer = Timer.new()
	add_child(pulse_timer)
	health = Global.enemy_health
	randomize()
	var path_index = randi() % enemy_paths.get_child_count()
	path = enemy_paths.get_children()[path_index]
	follow = PathFollow2D.new()
	follow.loop = false
	path.add_child(follow)
	remote = Node2D.new()
	follow.add_child(remote)
	shoot_timer.wait_time = 1.5
	shoot_timer.start()


func _process(delta: float) -> void:
	follow.offset += speed * delta
	position = remote.global_position
	if follow.unit_offset >= 1:
		queue_free()


func _on_shoot_timer_timeout() -> void:
	if target.visible:
		shoot_player.play()
		_shoot_pulse(3, 0.1)



func damage(amount: float) -> void:
	health -= amount
	animation_player.play("hit")
	if health <= 0:
		Global.score += Global.enemy_points
		explode.emit(position)
		queue_free()


func _pulse_delay(delay: float) -> void:
	pulse_timer.wait_time = delay
	pulse_timer.process_mode = 0
	pulse_timer.start()


func _shoot_pulse(n: int, delay: float) -> void:
	for i in range(n):
		_shoot_1()
		_pulse_delay(delay)
		await pulse_timer.timeout
	

func _shoot_1() -> void:
	var bullet := bullet_scene.instantiate() as Area2D
	bullet_container.add_child(bullet)
	var dir := global_position - target.global_position
	bullet.start_at(dir.angle() - PI / 2 + randf_range(-accuracy, accuracy), global_position)


func _shoot_3() -> void:
	var dir := global_position - target.global_position
	for a in [-0.1, 0, 0.1]:
		var bullet := bullet_scene.instantiate() as Area2D
		bullet_container.add_child(bullet)
		bullet.start_at(dir.angle() + PI / 2 + a, global_position)
