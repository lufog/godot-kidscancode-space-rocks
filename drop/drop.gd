extends RigidBody2D


@export var speed: float = 75

var type = null


func _ready() -> void:
	type = 'star'
	linear_velocity = Vector2(speed, 0).rotated(randf_range(-PI, PI))


func _on_lifetime_timer_timeout() -> void:
	queue_free()
