extends Interactable3D
class_name Cupboard3D


func _ready() -> void:
	if $"../Toy".get_children() != []:
		can_interact = false


func interact():
	if can_interact == true:
		if !GameManager.player_ref: return
		
		var picked_up_toy : PickedUpToy3D = GameManager.player_ref.l_hand.get_child(0)
		if !picked_up_toy: return
		
		var toy : Enemy3D = picked_up_toy.interactable_toy_scene.instantiate()
		toy.can_move = false
		var interactable_toy : InteractableToy3D = toy.get_child(0) as InteractableToy3D
		interactable_toy.can_interact = false
		$"../Toy".add_child(toy)
		picked_up_toy.queue_free()
		
		await get_tree().create_timer(5).timeout
		if !toy: return
		interactable_toy.can_interact = true
		$"../Toy".remove_child(toy)
		self.get_owner().add_child(toy)
		toy.global_position = $"../ToySpawnLocation".global_position
		toy.can_move = true
