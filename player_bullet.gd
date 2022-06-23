extends Area2D


@export var speed := 1000

var velocity: Vector2


func _ready() -> void:
	velocity = Vector2(speed, 0).rotated(rotation - PI / 2)


func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_life_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Asteroid:
		body.explode(velocity.normalized())
		self.queue_free()
