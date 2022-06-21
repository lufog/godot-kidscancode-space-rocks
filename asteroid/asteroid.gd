extends CharacterBody2D


@export var bounce := 1.1

const SPEED = 300.0

var rot_speed = 300.0
var extents: Vector2

@onready var viewport_rect := get_viewport().get_visible_rect()
@onready var sprite: Sprite2D = $Sprite
@onready var euff_particles: GPUParticles2D = $EuffParticles


func _ready() -> void:
	randomize()
	velocity = Vector2(randf_range(30, 100), 0).rotated(randf_range(0, 2 * PI))
	rot_speed = randf_range(-1.5, 1.5)
	extents = sprite.texture.get_size() / 2

func _physics_process(delta: float) -> void:
	if is_on_wall():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			velocity += collision.get_normal() * collision.get_collider().velocity.length() * bounce
			euff_particles.global_position = collision.get_position()
			euff_particles.emitting = true
	
	rotation += rot_speed * delta
	position = Vector2(
		wrapf(position.x + velocity.x * delta, -extents.x, viewport_rect.size.x + extents.x),
		wrapf(position.y + velocity.y * delta, -extents.y, viewport_rect.size.y + extents.y)
	)
	move_and_slide()
