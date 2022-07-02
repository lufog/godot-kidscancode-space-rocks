extends Area2D
class_name Player


signal explode

@export var rot_speed: float = 2.6
@export var thrust: float = 500
@export var max_vel: float = 400
@export var friction: float = 0.65
@export var bullet_scene: PackedScene

var velocity: Vector2
var accel: Vector2
var shield_level: float = Global.shield_max
var shield_up: bool = true

@onready var viewport_rect := get_viewport().get_visible_rect()
@onready var bullet_container: Node = $BulletContainer
@onready var muzzle: Position2D = $MuzzlePosition
@onready var gun_timer: Timer = $GunTimer
@onready var shoot_sound_player: AudioStreamPlayer = $ShootSoundPlayer
@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var exhaust_animated_sprite: AnimatedSprite2D = $ExhaustAnimatedSprite


func _ready() -> void:
	position = viewport_rect.size / 2


func _process(delta: float) -> void:
	if shield_up:
		shield_level = min(shield_level + Global.shield_regen * delta, Global.shield_max)
	
	if shield_level <= 0 and shield_up:
		shield_up = false
		shield_level = 0
		shield_sprite.hide()
		
	
	if Input.is_action_pressed("shoot") and gun_timer.time_left == 0:
		_shoot()
	
	var rot_dir = Input.get_axis("left", "right")
	
	if rot_dir != 0:
		rotation += rot_speed * rot_dir * delta
	
	if Input.is_action_pressed("thrust"):
		accel = Vector2(thrust, 0).rotated(rotation - PI / 2)
		exhaust_animated_sprite.show()
	else:
		accel = Vector2.ZERO
		exhaust_animated_sprite.hide()
	
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
	var bullet := bullet_scene.instantiate() as Area2D
	bullet.global_position = muzzle.global_position
	bullet.rotation = rotation
	bullet_container.add_child(bullet)
	shoot_sound_player.play()
