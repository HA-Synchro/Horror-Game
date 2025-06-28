extends SpotLight3D
class_name Torch3D


var label : Label = UIManager.get_node("CanvasLayer/Battery")
var can_use_torch : bool = true

@export var battery : int = 4:
	set(value):
		battery = value
		label.text = "Battery: " + str(battery)

func _ready() -> void:
	battery = 4


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("torch"):
		if !can_use_torch: return
		if battery <= 0: return
		can_use_torch = false
		battery = battery - 1
		light_energy = 3
		var tween := get_tree().create_tween()
		tween.tween_property(self, "light_energy", 0, 1)
		await tween.finished
		tween.kill()
		can_use_torch = true
