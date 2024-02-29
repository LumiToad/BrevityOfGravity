extends Spatial

var player

func _on_Area_body_entered(body):
	if body.has_method("enablePlayerControls"):
		player = body
		player.enablePlayerControls(false)
		$AnimationPlayer.play("Collapse")
		$EnableControlsTimer.start()

func enableControls():
	player.enablePlayerControls(true)

func setPlayerAnimation():
	if player.has_method("cutsceneControl"):
		player.cutsceneControl("JUMP")

func addForce():
	for child in get_children():
		if child is RigidBody:
			randomize()
			child.apply_central_impulse(Vector3(rand_range(-4,4),rand_range(-1,1),0))

func _on_EnableControlsTimer_timeout():
	enableControls()
