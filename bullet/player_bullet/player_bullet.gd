extends "res://bullet/bullet.gd"


func _on_body_entered(body: Node2D) -> void:
	if body is Asteroid:
		body.explode(velocity.normalized())
		self.queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("damage"):
		area.damage(Global.bullet_damage)
		self.queue_free()
