extends Node

@export var player_ref : Player3D
@export var nav_region : NavigationRegion3D

func _ready() -> void:
	nav_region = get_tree().get_first_node_in_group("NavigationRegion")
