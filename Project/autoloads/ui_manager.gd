extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_fps()
	
func update_fps() -> void:
	%FPSLabel.text = "FPS: %s" % Engine.get_frames_per_second()

func show_crosshair():
	$CanvasLayer/Crosshair.show()
	
func hide_crosshair():
	$CanvasLayer/Crosshair.hide()
