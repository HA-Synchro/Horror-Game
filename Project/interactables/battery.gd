extends StaticBody3D
@onready var battery: Node3D = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func bat_interact():
	if Torch.battery < 4:
		Torch.battery += 4 - Torch.battery_after_loss
	battery.visible = false
