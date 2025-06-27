extends Node
@onready var shop: Panel = $"../Shop"
@onready var Torch3d: Button = $"../Shop/Button"
@onready var exit: Button = $"../Shop/Exit"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	exit.pressed.connect(exit_shop)
	
	if Input.is_action_just_pressed("Buy"):
		shop.visible = true
func exit_shop():
	shop.visible = false
	
func battery_rechrage():
	pass
