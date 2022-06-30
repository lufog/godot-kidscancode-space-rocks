extends Area2D


var path: Path2D
var follow: PathFollow2D
var remote: Node2D
var speed: float = 250

@onready var enemy_paths: Node = $EnemyPaths


func _ready() -> void:
	randomize()
	var path_index = randi() % enemy_paths.get_child_count()
	path = enemy_paths.get_children()[path_index]
	follow = PathFollow2D.new()
	follow.loop = false
	path.add_child(follow)
	remote = Node2D.new()
	follow.add_child(remote)


func _process(delta: float) -> void:
	follow.offset += speed * delta
	position = remote.global_position


func _on_visible_notifier_screen_exited() -> void:
	queue_free()
