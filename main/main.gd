extends Node


var asteroid_scene: PackedScene = preload("res://asteroid/asteroid.tscn")

@onready var spawn_locations: Node = $SpawnLocations


func _ready() -> void:
	for i in 5:
		var a = asteroid_scene.instantiate()
		add_child(a)
		a.init("big", spawn_locations.get_child(i).position)
