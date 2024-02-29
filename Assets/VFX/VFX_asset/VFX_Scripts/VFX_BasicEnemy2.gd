extends Spatial

func emitParticles(boolValue):
	$Particles.emitting = boolValue
	$Particles2.emitting = boolValue
	$Particles3.emitting = boolValue
	$blob.emitting = boolValue
