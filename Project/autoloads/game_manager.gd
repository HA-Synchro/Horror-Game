extends Node

@export var player_ref : Player3D
@export var debug_player_ref : DebugPlayer3D

var active_player : CharacterBody3D 
@export var nav_region : NavigationRegion3D


func set_debug_player_active():
	active_player = debug_player_ref
			
	player_ref.camera.current = false
	player_ref.can_take_input = false
	# player_ref.hide()
			
	debug_player_ref.show()
	debug_player_ref.can_take_input = true
	debug_player_ref.camera.current = true
	
	NavigationServer3D.set_debug_enabled(true)

func set_normal_player_active():
	active_player = player_ref
			
	player_ref.camera.current = true
	player_ref.can_take_input = true
	player_ref.show()
			
	debug_player_ref.hide()
	debug_player_ref.can_take_input = false
	debug_player_ref.camera.current = false
	NavigationServer3D.set_debug_enabled(false)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
		if active_player == player_ref:
			set_debug_player_active()
		else:
			set_normal_player_active()
			
func _ready() -> void:
	nav_region = get_tree().get_first_node_in_group("NavigationRegion")
