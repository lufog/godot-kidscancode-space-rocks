extends Node


# Game settings.
var game_over: bool = false
var score: int = 0
var level: int = 0

# Player settings.
var shield_max: int = 100
var shield_regen: int = 10

# Asteroid settings.
var break_pattern := { "big": "med", "med": "small", "small": "tiny", "tiny": null }
var asteroid_damage := { "big": 40, "med": 20, "small": 15, "tiny": 10 }
var asteroid_poins := { "big": 10, "med": 15, "small": 20, "tiny": 40 }
