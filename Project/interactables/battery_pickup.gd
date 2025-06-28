extends Interactable3D
class_name BatteryPickup3D

func interact():
	if can_interact == true:
		if !GameManager.player_ref: return
		if !GameManager.player_ref.torch:
			print("Torch is null")
			return
		
		GameManager.player_ref.torch.battery += 1
		get_parent().queue_free()
