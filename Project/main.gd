extends Node3D
@onready var player: Player3D = $SubViewportContainer/SubViewport/Player

func _physics_process(delta: float) -> void:
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
