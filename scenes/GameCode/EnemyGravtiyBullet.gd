extends KinematicBody

export (float) var bulletSpeed = 30

var move = Vector3.LEFT

var fireRef

func _on_Area_body_entered(body):
	if !body == fireRef: 
		if body.has_method("hitByEnemyGravityBullet"):
			body.hitByEnemyGravityBullet()
			killBullet()
		if body is StaticBody:
			killBullet()

func _process(delta):
	move_and_slide(move * bulletSpeed)

func deleteBullet():
	queue_free()

func killBullet():
	$VFX_EnemyGunTrail.onColision()
	$MeshInstance.visible = false
	$VFX_gravityGunBulletSplash.emitParticles()
	move = Vector3.ZERO
	$DeleteTimer.start()

func changeDirection():
	move.x *= -1

func setFireRef(node):
	fireRef = node

func _on_VisibilityNotifier_screen_exited():
	deleteBullet()

func _on_DeleteTimer_timeout():
	deleteBullet()
