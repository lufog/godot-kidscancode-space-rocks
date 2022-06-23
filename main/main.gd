extends Node


var asteroid_scene: PackedScene = preload("res://asteroid/asteroid.tscn")
var break_pattern := { "big": "med", "med": "small", "small": "tiny", "tiny": null }

@onready var spawn_locations: Node = $SpawnLocations
@onready var asteroid_container: Node = $AsteroidContainer


func _ready() -> void:
	for i in 1:
		spawn_asteroid("big", spawn_locations.get_child(i).position)


func _process(delta: float) -> void:
	if asteroid_container.get_child_count() == 0:
		for i in 2:
			spawn_asteroid("big", spawn_locations.get_child(i).position)


func spawn_asteroid(size: String, pos: Vector2, vel := Vector2.ZERO) -> void:
	var a = asteroid_scene.instantiate()
	asteroid_container.add_child.call_deferred(a)
	a.exploded.connect(self.explode_asteroid)
	a.init.call_deferred(size, pos, vel)


func explode_asteroid(size: String, pos: Vector2, vel: Vector2, hit_dir: Vector2) -> void:
	var new_size = break_pattern[size]
	if new_size:
		for offset in [-1, 1]:
			var new_pos = pos + hit_dir.orthogonal().limit_length(25) * offset
			var new_vel = vel + hit_dir.orthogonal() * offset
			spawn_asteroid(new_size, new_pos, new_vel)
