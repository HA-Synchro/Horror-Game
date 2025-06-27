extends Node3D
@onready var spot_light_3d: SpotLight3D = $"../SpotLight3D"

@export var battery : int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("torch"):
		battery -= 1
	if Input.is_action_pressed("torch") and battery > 0:
		torch_on()
	else:
		spot_light_3d.visible = false
	
func torch_on():
	spot_light_3d.visible = true
