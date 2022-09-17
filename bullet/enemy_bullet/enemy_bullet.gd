extends "res://bullet/bullet.gd"


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("damage"):
		area.damage(Global.enemy_bullet_damage)
		queue_free()
