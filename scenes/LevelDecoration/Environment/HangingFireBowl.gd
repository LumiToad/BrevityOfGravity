extends RigidBody


func applyWindImpulse(strength, direction):
	if direction == "RIGHT":
		strength *= -1
	apply_central_impulse(Vector3(strength,0,0))
