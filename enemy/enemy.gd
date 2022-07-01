extends Area2D


var bullet_scene: PackedScene = preload("res://enemy_bullet/enemy_bullet.tscn")

var path: Path2D
var follow: PathFollow2D
var remote: Node2D
var speed: float = 250
var target: Node2D

@onready var bullet_container: Node = $BulletContainer
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_player: AudioStreamPlayer = $ShootPlayer
@onready var enemy_paths: Node = $EnemyPaths


func _ready() -> void:
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
	shoot_player.play()
	_shoot_3()


func _shoot_1() -> void:
	var bullet := bullet_scene.instantiate() as Area2D
	bullet_container.add_child(bullet)
	var dir := global_position - target.global_position
	bullet.start_at(dir.angle() + PI / 2, global_position)


func _shoot_3() -> void:
	var dir := global_position - target.global_position
	for a in [-0.1, 0, 0.1]:
		var bullet := bullet_scene.instantiate() as Area2D
		bullet_container.add_child(bullet)
		bullet.start_at(dir.angle() + PI / 2 + a, global_position)
