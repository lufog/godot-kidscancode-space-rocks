extends Node


var asteroid_scene: PackedScene = preload("res://asteroid/asteroid.tscn")
var explosion_effect_scene: PackedScene = preload("res://asteroid/explosion_effect/explosion_effect.tscn")

@onready var spawn_locations: Node = $SpawnLocations
@onready var asteroid_container: Node = $AsteroidContainer
@onready var explosion_sound_player: AudioStreamPlayer = $ExplosionSoundPlayer
@onready var hud: CanvasLayer = $HUD
@onready var player: Area2D = $Player
@onready var restart_timer: Timer = $RestartTimer


func  _ready() -> void:
	player.explode.connect(_explode_player)
	begin_next_level()


func _process(_delta: float) -> void:
	hud.update(player)
	if asteroid_container.get_child_count() == 0:
		begin_next_level()


func _explode_asteroid(size: String, pos: Vector2, vel: Vector2, hit_dir: Vector2) -> void:
	var new_size = Global.break_pattern[size]
	if new_size:
		for offset in [-1, 1]:
			var new_pos = pos + hit_dir.orthogonal().limit_length(25) * offset
			var new_vel = vel + hit_dir.orthogonal() * offset
			spawn_asteroid(new_size, new_pos, new_vel)
	var explosion_effect := explosion_effect_scene.instantiate() as AnimatedSprite2D
	add_child(explosion_effect)
	explosion_effect.position = pos
	explosion_effect.play()
	explosion_sound_player.play()


func _explode_player() -> void:
	player.disable()
	var explosion_effect := explosion_effect_scene.instantiate() as AnimatedSprite2D
	add_child(explosion_effect)
	explosion_effect.scale = Vector2(1.5, 1.5)
	explosion_effect.position = player.position
	explosion_effect.set_animation("sonic")
	explosion_effect.play()
	explosion_sound_player.play()
	hud.show_message("Game Over!")
	restart_timer.start()
	await restart_timer.timeout
	Global.new_game()


func begin_next_level() -> void:
	Global.level += 1
	hud.show_message("Wave %s" % Global.level)
	for i in Global.level:
		var index := randi_range(0, spawn_locations.get_child_count() - 1)
		spawn_asteroid("big", spawn_locations.get_child(index).position)


func spawn_asteroid(size: String, pos: Vector2, vel := Vector2.ZERO) -> void:
	var a = asteroid_scene.instantiate()
	asteroid_container.add_child.call_deferred(a)
	a.exploded.connect(_explode_asteroid)
	a.init.call_deferred(size, pos, vel)
