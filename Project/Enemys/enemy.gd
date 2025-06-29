extends CharacterBody3D

@onready var nav : NavigationAgent3D = $NavigationAgent3D

const SPEED            : float = 2.5     
const CHASE_RANGE      : float = 12.0   
const WANDER_RADIUS    : float = 6.0     
const WANDER_COOLDOWN  : float = 2.0     

var _player_pos : Vector3 = Vector3.ZERO   
var _wander_t   : float = 0.0              


func _ready() -> void:
	randomize()                 
	add_to_group("enemies")     
	_pick_new_wander_point()     



func update_target_location(pos: Vector3) -> void:
	_player_pos = pos


func _physics_process(delta: float) -> void:

	if _player_pos != Vector3.ZERO:
		var to_player := _player_pos - global_transform.origin
		if to_player.length_squared() <= CHASE_RANGE * CHASE_RANGE:
			nav.set_target_position(_player_pos)
			_wander_t = 0.0
		else:
			_wander_t -= delta
			if _wander_t <= 0.0 or nav.is_navigation_finished():
				_pick_new_wander_point()
				_wander_t = WANDER_COOLDOWN

	
	var next_pos := nav.get_next_path_position()
	var dir      := (next_pos - global_transform.origin).normalized()
	velocity     = dir * SPEED
	move_and_slide()



func _pick_new_wander_point() -> void:
	var random_dir := Vector3(
		randf_range(-1.0, 1.0),
		0.0,
		randf_range(-1.0, 1.0)
	).normalized()

	var candidate := global_transform.origin + random_dir * WANDER_RADIUS

	
	var nav_map: RID = nav.get_navigation_map()
	if nav_map.is_valid():
		candidate = NavigationServer3D.map_get_closest_point(nav_map, candidate)

	nav.set_target_position(candidate)
