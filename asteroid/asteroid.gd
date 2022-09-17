extends RigidBody2D
class_name Asteroid


signal exploded(size: String, pos: Vector2, vel: Vector2, hit_dir: Vector2)

@export var bounce := 0.5

const SPEED = 300.0

var size: String
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
@onready var puff_particles: GPUParticles2D = $PuffParticles


func _ready() -> void:
	randomize()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	for i in state.get_contact_count():
		puff_particles.global_position = state.get_contact_local_position(i)
		puff_particles.emitting = true
	
	state.transform.origin.x = wrapf(state.transform.origin.x, -extents.x, 
			viewport_rect.size.x + extents.x)
	state.transform.origin.y = wrapf(state.transform.origin.y, -extents.y, 
			viewport_rect.size.y + extents.y)


func init(init_size: String, init_pos: Vector2, init_vel: Vector2) -> void:
	size = init_size
	mass = Global.rock_mass[size]
	if init_vel.length() > 0:
		linear_velocity = init_vel
	else:
		linear_velocity = Vector2(randf_range(50, 100), 0).rotated(randf_range(0, 2 * PI))
	angular_velocity = randf_range(-1.5, 1.5)
	var index := randi_range(0, texture_paths[size].size() - 1)
	var texture := load(texture_paths[size][index]) as Texture2D
	sprite.texture = texture
	extents = texture.get_size() / 2
	var shape := CircleShape2D.new()
	shape.radius = min(texture.get_width() / 2.0, texture.get_height() / 2.0)
	collision.shape = shape
	position = init_pos


func explode(hit_vel: Vector2) -> void:
	exploded.emit(size, extents, position, linear_velocity, hit_vel)
	queue_free()
