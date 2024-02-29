extends Spatial

var startPos

func _ready():
	startPos = translation.y

func flipParticles(isGravityUp):
	if isGravityUp == true:
		translation.y = startPos
	elif isGravityUp == false:
		translation.y = -translation.y

func emitParticles():
	$staub.emitting = true
	$staub2.emitting = true
	$sparks2.emitting = true
	$sparks3.emitting = true
