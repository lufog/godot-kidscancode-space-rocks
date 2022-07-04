extends Node


# Game settings.
var game_over: bool = false
var score: int = 0
var level: int = 0
var paused: bool = false
var current_scene = null
var new_scene = null

# Player settings.
var shield_max: int = 100
var bullet_damage: float = 25
var cash: int = 0
var upgrade_level = { 'thrust': 1, 'fire_rate': 1, 'rot': 1, 'shield_regen': 4, 'guns': 4 }
var thrust_level = { 1: 200, 2: 400, 3: 600, 4: 800 }
var rot_level = { 1: 1.5, 2: 2.5, 3: 3.5, 4: 4.5 }
var shield_level = { 1: 5, 2: 7.5, 3: 10, 4: 15 }
var fire_level = { 1: 0.4, 2: 0.3, 3: 0.2, 4: 0.1 }

# Enemy settings
var enemy_bullet_damage: float = 25
var enemy_health: float = 30
var enemy_points: float = 100

# Asteroid settings.
var rock_mass := { "big": 20, "med": 9, "small": 5, "tiny": 1 }
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
