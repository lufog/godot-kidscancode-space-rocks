extends CharacterBody2D


@export var bounce := 1.1

const SPEED = 300.0

var rot_speed = 300.0
var extents: Vector2
var texture_paths = {
	"big": ["res://asteroid/textures/meteor_big_1.png", 
			"res://asteroid/textures/meteor_big_2.png", 
			"res://asteroid/textures/meteor_big_3.png"],
	"med": ["res://asteroid/textures/meteor_med_1.png",
			"res://asteroid/textures/meteor_med_2.png"],
	"small": ["res://asteroid/textures/meteor_small_1.png",
			"res://asteroid/textures/meteor_small_2.png"],
	"tiny": ["res://asteroid/textures/meteor_tiny_1.png",
			"res://asteroid/textures/meteor_tiny_2.png"]}

@onready var viewport_rect := get_viewport().get_visible_rect()
@onready var sprite: Sprite2D = $Sprite
@onready var collision: CollisionShape2D = $Collision
@onready var euff_particles: GPUParticles2D = $EuffParticles


func _ready() -> void:
	randomize()
	velocity = Vector2(randf_range(30, 100), 0).rotated(randf_range(0, 2 * PI))
	rot_speed = randf_range(-1.5, 1.5)
	init("big", viewport_rect.size / 2)


func init(size: String, pos: Vector2) -> void:
	var index := randi_range(0, texture_paths[size].size() - 1)
	var texture := load(texture_paths[size][index]) as Texture2D
	sprite.texture = texture
	extents = texture.get_size() / 2
	var shape := CircleShape2D.new()
	shape.radius = min(texture.get_width() / 2.0, texture.get_height() / 2.0)
	collision.shape = shape
	position = pos


func _physics_process(delta: float) -> void:
	if is_on_wall():
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			velocity += col.get_normal() * col.get_collider().velocity.length() * bounce
			euff_particles.global_position = col.get_position()
			euff_particles.emitting = true
	
	rotation += rot_speed * delta
	position = Vector2(
		wrapf(position.x + velocity.x * delta, -extents.x, viewport_rect.size.x + extents.x),
		wrapf(position.y + velocity.y * delta, -extents.y, viewport_rect.size.y + extents.y)
	)
	move_and_slide()
