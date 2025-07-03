extends Interactable3D
class_name Cupboard3D

@export var toy_idle_location : Node3D
@export var toy_spawn_marker : Marker3D

func _ready() -> void:
	if toy_idle_location.get_children() != []: # There is already a toy stuck
		can_interact = false


func interact(body : CharacterBody3D):
	if can_interact == true:
		if !GameManager.player_ref: return
		
		var picked_up_toy : PickedUpToy3D = GameManager.player_ref.l_hand.get_child(0)
		if !picked_up_toy: return
		
		var toy : Enemy3D = picked_up_toy.interactable_toy_scene.instantiate()
		toy.can_move = false
		var interactable_toy : InteractableToy3D = toy.get_child(0) as InteractableToy3D
		interactable_toy.can_interact = false
		toy_idle_location.add_child(toy)
		picked_up_toy.queue_free()
		
		await get_tree().create_timer(5).timeout
		if !toy: return
		interactable_toy.can_interact = true
		toy_idle_location.remove_child(toy)
		self.get_owner().add_child(toy)
		toy.global_position = toy_spawn_marker.global_position
		toy.can_move = true

func on_ray_cast_collide() -> void:
	if !can_interact: 
		on_ray_cast_uncollide()
		return
		
	var picked_up_toy : PickedUpToy3D = GameManager.player_ref.l_hand.get_child(0)
	if !picked_up_toy:
		on_ray_cast_uncollide()
		return
	
	
	is_focused = true
	UIManager.show_crosshair()

func on_ray_cast_uncollide() -> void:
	is_focused = false
	UIManager.hide_crosshair()
