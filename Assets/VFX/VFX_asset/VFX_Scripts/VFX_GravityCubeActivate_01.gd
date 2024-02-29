extends Spatial

export (GradientTexture) var gravityStateDOWN
export (GradientTexture) var gravityStateUP

func changeColor(state):
	if state == false:
		$Particles.get_process_material().set_color_ramp(gravityStateDOWN)
		$Particles2.get_process_material().set_color_ramp(gravityStateDOWN)
		$Particles3.get_process_material().set_color_ramp(gravityStateDOWN)
	elif state == true:
		$Particles.get_process_material().set_color_ramp(gravityStateUP)
		$Particles2.get_process_material().set_color_ramp(gravityStateUP)
		$Particles3.get_process_material().set_color_ramp(gravityStateUP)
	emitParticles()

func emitParticles():
	$Particles.emitting = true
	$Particles2.emitting = true
	$Particles3.emitting = true
