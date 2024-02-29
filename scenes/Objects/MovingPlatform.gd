extends Spatial

enum directionEnum{
	FORWARD = 0,
	REVERSE = 1
}

export (float) var duration = 10
export (float) var idleDuration = 1.1
export (directionEnum) var startDirection

func _ready():
	setupPlatformStartPos(startDirection)
	setupTween(startDirection)
	initTween()
	

func _physics_process(delta):
	changeDirection()

func setupPlatformStartPos(direction):
	direction = 1 - direction
	$PathFollow.unit_offset = direction

func initTween():
	$Tween.start()

func setupTween(direction):
	var reverseDirection = 1 - direction
	$Tween.interpolate_property($PathFollow, "unit_offset", direction, reverseDirection, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, idleDuration)

func changeDirection():
	if $PathFollow.unit_offset == int($PathFollow.unit_offset):
		setupTween($PathFollow.unit_offset)
