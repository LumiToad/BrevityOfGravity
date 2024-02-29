extends Spatial

func emitParticles(boolValue):
	$blob.emitting = boolValue
	$blob2.emitting = boolValue
	$blob3.emitting = boolValue
	$fog_wide.emitting = boolValue
