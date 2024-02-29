extends Spatial

export (GradientTexture) var gravityStateDOWN
export (GradientTexture) var gravityStateUP


func changeColor(state):
	if state == false:
		$blob.get_process_material().set_color_ramp(gravityStateDOWN)
		$fog_wide.get_process_material().set_color_ramp(gravityStateDOWN)
		$sparks2.get_process_material().set_color_ramp(gravityStateDOWN)
		$sparks3.get_process_material().set_color_ramp(gravityStateDOWN)
	elif state == true:
		$blob.get_process_material().set_color_ramp(gravityStateUP)
		$fog_wide.get_process_material().set_color_ramp(gravityStateUP)
		$sparks2.get_process_material().set_color_ramp(gravityStateUP)
		$sparks3.get_process_material().set_color_ramp(gravityStateUP)
