extends Node


var asteroid_scene: PackedScene = preload("res://asteroid/asteroid.tscn")
var explosion_effect_scene: PackedScene = preload("res://asteroid/explosion_effect/explosion_effect.tscn")

@onready var spawn_locations: Node = $SpawnLocations
@onready var asteroid_container: Node = $AsteroidContainer
@onready var explosion_sound_player: AudioStreamPlayer = $ExplosionSoundPlayer
@onready var hud: CanvasLayer = $HUD
@onready var player: Area2D = $Player


func  _ready() -> void:
	begin_next_level()


func _process(delta: float) -> void:
	hud.update(player)
	if asteroid_container.get_child_count() == 0:
		begin_next_level()


func begin_next_level() -> void:
	Global.level += 1
	hud.show_message("Wave %s" % Global.level)
	for i in Global.level:
		spawn_asteroid("big", spawn_locations.get_child(i).position)

func spawn_asteroid(size: String, pos: Vector2, vel := Vector2.ZERO) -> void:
	var a = asteroid_scene.instantiate()
	asteroid_container.add_child.call_deferred(a)
	a.exploded.connect(self.explode_asteroid)
	a.init.call_deferred(size, pos, vel)


func explode_asteroid(size: String, pos: Vector2, vel: Vector2, hit_dir: Vector2) -> void:
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
