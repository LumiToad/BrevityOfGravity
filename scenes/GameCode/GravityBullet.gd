extends KinematicBody

export (float) var bulletSpeed = 30

var move = Vector3.LEFT

func _on_Area_body_entered(body):
	if body.has_method("hitByPlayerGravityBullet"):
		body.hitByPlayerGravityBullet()
		killBullet()
	if body is StaticBody:
		killBullet()

func _process(delta):
	move_and_slide(move * bulletSpeed)

func deleteBullet():
	queue_free()

func killBullet():
	$VFX_GunTrail.onColision()
	$MeshInstance.queue_free()
	$Area.queue_free()
	$VFX_gravityGunBulletSplash.emitParticles()
	move = Vector3.ZERO
	$DeleteTimer.start()

func _on_VisibilityNotifier_screen_exited():
	deleteBullet()

func _on_DeleteTimer_timeout():
	deleteBullet()
