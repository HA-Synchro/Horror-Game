extends Interactable3D
class_name Door3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var door_open : bool = false

func interact():
	if can_interact == true:
		#can_interact = false
		
		
		#var tween := get_tree().create_tween()
		
		if door_open:
			#tween.tween_property(self, "rotation_degrees:y",0,1)
			animation_player.play_backwards("open")
		else:
			#tween.tween_property(self, "rotation_degrees:y",-90,1)
			animation_player.play("open")
		
		door_open = !door_open
		
		#await tween.finished
		#tween.kill()
		await animation_player.animation_finished
		can_interact = true
		if GameManager.nav_region.is_baking():
			await GameManager.nav_region.bake_finished
			
		GameManager.nav_region.bake_navigation_mesh()
