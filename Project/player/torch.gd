extends Node3D
class_name torch3d

@onready var spot_light_3d: SpotLight3D = $"../SpotLight3D"
var label = UIManager.get_node("CanvasLayer/Battery")

@export var battery : int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if battery > 0:
		label.text = "Battery: " + str(battery)
	else:
		label.text = "Battery: 0" 
	if Input.is_action_just_pressed("torch"):
		battery -= 1
	if Input.is_action_pressed("torch") and battery > 0:
		torch_on()
	else:
		spot_light_3d.visible = false
	
func torch_on():
	spot_light_3d.visible = true
