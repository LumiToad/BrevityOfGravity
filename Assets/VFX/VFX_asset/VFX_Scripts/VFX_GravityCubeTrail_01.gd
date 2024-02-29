extends Spatial


func changeColor(state):
	$Orange/rings.emitting = state
	$Orange/stars.emitting = state
	$Orange/stars2.emitting = state
	$Blue/rings.emitting = !state
	$Blue/stars.emitting = !state
	$Blue/stars2.emitting = !state
