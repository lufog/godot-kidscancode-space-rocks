extends Area2D
class_name Player


signal explode
signal shoot

@export var max_vel: float = 400
@export var friction: float = 0.65
@export var bullet_scene: PackedScene

var rot_speed: float = Global.rot_level[Global.upgrade_level['rot']]
var thrust: float = Global.thrust_level[Global.upgrade_level['thrust']]
var velocity: Vector2
var accel: Vector2
var shield_level: float = Global.shield_max
var shield_up: bool = true

@onready var viewport_rect := get_viewport().get_visible_rect()
@onready var muzzle_location: Position2D = $MuzzleLocation
@onready var muzzle_left_location: Position2D = $MuzzleLeftLocation
@onready var muzzle_right_location: Position2D = $MuzzleRightLocation
@onready var gun_timer: Timer = $GunTimer
@onready var shoot_sound_player: AudioStreamPlayer = $ShootSoundPlayer
@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var exhaust_particles: GPUParticles2D = $ExhaustParticles



func _ready() -> void:
	position = viewport_rect.size / 2


func _physics_process(delta: float) -> void:
	if shield_up:
		shield_level = min(shield_level + Global.shield_level[Global.upgrade_level['shield_regen']] * delta, Global.shield_max)
	
	if shield_level <= 0 and shield_up:
		shield_up = false
		shield_level = 0
		shield_sprite.hide()
		
	
	if Input.is_action_pressed("shoot") and gun_timer.time_left == 0:
		_shoot_2()
	
	var rot_dir = Input.get_axis("left", "right")
	
	if rot_dir != 0:
		rotation += rot_speed * rot_dir * delta
	
	if Input.is_action_pressed("thrust"):
		accel = Vector2(thrust, 0).rotated(rotation - PI / 2)
		exhaust_particles.emitting = true
	else:
		accel = Vector2.ZERO
		exhaust_particles.emitting = false
	
	accel += velocity * -friction
	velocity += accel * delta
	position = Vector2(
		wrapf(position.x + velocity.x * delta, 0, viewport_rect.size.x),
		wrapf(position.y + velocity.y * delta, 0, viewport_rect.size.y)
	)


func _on_body_entered(body: Node2D) -> void:
	if not visible:
		return
	
	if body is Asteroid:
		if shield_up:
			body.explode(velocity)
			damage(Global.asteroid_damage[body.size])


func disable() -> void:
	hide()
	set_process(false)


func damage(amount: float) -> void:
	if shield_up:
		shield_level -= amount
	else:
		disable()
		explode.emit()


func _shoot() -> void:
	gun_timer.start()
	shoot_sound_player.play()
	shoot.emit(bullet_scene, muzzle_location.global_position, rotation)

func _shoot_2() -> void:
	gun_timer.start()
	shoot_sound_player.play()
	shoot.emit(bullet_scene, muzzle_left_location.global_position, rotation)
	shoot.emit(bullet_scene, muzzle_right_location.global_position, rotation)
