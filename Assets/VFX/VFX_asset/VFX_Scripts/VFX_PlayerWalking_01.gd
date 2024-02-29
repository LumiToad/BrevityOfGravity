extends Spatial

func emitParicles(boolValue):
	$dust.emitting = boolValue
	$spark.emitting = boolValue
