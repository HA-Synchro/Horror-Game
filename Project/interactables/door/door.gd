extends Interactable3D
class_name Door3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var door_open : bool = false

func _unhandled_input(_event: InputEvent) -> void:
	if is_focused:
		if Input.is_action_just_pressed("interact"):
			interact(GameManager.player_ref)
			GameManager.player_ref.last_used_door = self


func interact(body : CharacterBody3D):
	if can_interact == true:
		#can_interact = false
		
		#var tween := get_tree().create_tween()
		
		if door_open:
			#tween.tween_property(self, "rotation_degrees:y",0,1)
			door_open = false
			animation_player.play_backwards("open")
			
		else:
			#tween.tween_property(self, "rotation_degrees:y",-90,1)
			door_open = true
			animation_player.play("open")
		
		
		
		#await tween.finished
		#tween.kill()
		await animation_player.animation_finished
		can_interact = true
		if GameManager.nav_region.is_baking():
			await GameManager.nav_region.bake_finished

		GameManager.nav_region.bake_navigation_mesh()
		await GameManager.nav_region.bake_finished
		
		if body is ToyEnemy3D:
			body.get_new_target()
