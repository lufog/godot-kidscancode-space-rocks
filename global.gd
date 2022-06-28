extends Node


# Game settings.
var game_over: bool = false
var score: int = 0
var level: int = 0
var paused: bool = false
var current_scene = null
var new_scene = null

# Player settings.
var shield_max: int = 10
var shield_regen: int = 10

# Asteroid settings.
var break_pattern := { "big": "med", "med": "small", "small": "tiny", "tiny": null }
var asteroid_damage := { "big": 40, "med": 20, "small": 15, "tiny": 10 }
var asteroid_poins := { "big": 10, "med": 15, "small": 20, "tiny": 40 }

@onready var _tree := get_tree()
@onready var _root := _tree.get_root()


func _ready() -> void:
	current_scene = _root.get_child(_root.get_child_count() - 1)


func goto_scene(path: String) -> void:
	var s: PackedScene = ResourceLoader.load(path)
	new_scene = s.instantiate()
	_root.add_child(new_scene)
	_tree.set_current_scene(new_scene)
	current_scene.queue_free()
	current_scene = new_scene


func new_game() -> void:
	game_over = false
	score = 0
	level = 0
	goto_scene("res://main/main.tscn")
