extends CharacterBody3D
class_name Enemy3D

@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var seeing_ray_cast: RayCast3D = $SeeingRayCast
@onready var interact_ray_cast: RayCast3D = $InteractRayCast

const SPEED            : float = 2.5     
const CHASE_RANGE      : float = 24.0
const WANDER_RADIUS    : float = 6.0     
const WANDER_COOLDOWN  : float = 2.0     
 

var player_last_position : Vector3

var _wander_t   : float = 0.0              
var can_move : bool = true

func _ready() -> void:
	randomize()                 
	add_to_group("Enemies")     
	_pick_new_wander_point()     

func _physics_process(delta: float) -> void:
	if !can_move: return
	if GameManager.player_ref:
		get_new_target_position(delta)

	
	var next_pos := nav.get_next_path_position()
	var dir      := (next_pos - global_transform.origin).normalized()
	velocity     = dir * SPEED
	move_and_slide()
	
	if dir.length_squared() > 0:
		look_at(global_transform.origin + dir, Vector3.UP)


func get_new_target_position(delta: float):
	if is_behind_wall():
		# GETS LAST DOOR
		if !GameManager.player_ref.last_used_door: return
		nav.set_target_position(GameManager.player_ref.last_used_door.mesh_instance_3d.global_position)
		GameManager.player_ref.last_used_door = null
		
		# Gets last player position
		# nav.set_target_position(player_last_position)
	else:
		player_last_position= GameManager.player_ref.global_position
		var to_player := player_last_position - global_transform.origin
		if to_player.length_squared() <= CHASE_RANGE * CHASE_RANGE:
			nav.set_target_position(player_last_position)
			_wander_t = 0.0
		else:
			_wander_t -= delta
			if _wander_t <= 0.0 or nav.is_navigation_finished():
				_pick_new_wander_point()
				_wander_t = WANDER_COOLDOWN

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

func is_behind_wall() -> bool:
	seeing_ray_cast.target_position = to_local(GameManager.player_ref.global_position)
	if seeing_ray_cast.is_colliding():
		if seeing_ray_cast.get_collider() == GameManager.player_ref:
			return false
	if interact_ray_cast.is_colliding():
		if interact_ray_cast.get_collider() is Door3D:
			return false
	return true
