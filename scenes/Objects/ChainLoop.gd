extends RigidBody

export (float) var maxImpulsStrength = 0.5
var randomImpuls = rand_range(0, maxImpulsStrength)
var previousChainLink

func _ready():
	applyCollapseImpulse()

func gravityFlip():
	self.gravity_scale *= -1 #flips gravity
	if previousChainLink != null && previousChainLink.has_method("gravityFlip"):
		if previousChainLink.gravity_scale != self.gravity_scale:
			previousChainLink.gravityFlip()
		applyCollapseImpulse()

func applyCollapseImpulse():
	apply_central_impulse(Vector3(randomImpuls,0,randomImpuls))
	
func setPreviousChainLink(node):
	previousChainLink = node

func applyWindImpulse(strength, direction):
	if direction == "RIGHT":
		strength *= -1
	apply_central_impulse(Vector3(strength,0,0))
