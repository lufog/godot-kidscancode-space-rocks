extends Area2D

@export var speed: float = 1000

var velocity: Vector2


func start_at(dir, pos) -> void:
	rotation = dir
	position = pos
	velocity = Vector2(-speed, 0).rotated(dir + PI / 2)


func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_visible_notifier_screen_exited() -> void:
	queue_free()
