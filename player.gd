extends Area2D


@export var rot_speed: float = 2.6
@export var thrust: float = 500
@export var max_vel: float = 400
@export var friction: float = 0.65

var velocity: Vector2
var accel: Vector2

@onready var viewport_rect := get_viewport().get_visible_rect()


func _ready() -> void:
	position = viewport_rect.size / 2


func _process(delta: float) -> void:
	var rot_dir = Input.get_axis("left", "right")
	
	if rot_dir != 0:
		rotation += rot_speed * rot_dir * delta
	
	if Input.is_action_pressed("thrust"):
		accel = Vector2(thrust, 0).rotated(rotation - PI / 2)
	else:
		accel = Vector2.ZERO
	
	accel += velocity * -friction
	velocity += accel * delta
	position = Vector2(
		wrapf(position.x + velocity.x * delta, 0, viewport_rect.size.x),
		wrapf(position.y + velocity.y * delta, 0, viewport_rect.size.y)
	)
