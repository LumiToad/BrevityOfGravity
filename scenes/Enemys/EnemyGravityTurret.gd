extends RigidBody

export (float) var cooldown = 3.5
export (float) var visionRange = 30
export (bool) var isStartGravityFlipped = false
export (PackedScene) var enemyGravityBulletSceneTemplate

var currentScene
var cooldownTimer

func _ready():
	if isStartGravityFlipped == true:
		gravityFlip()
	initCDTimer()
	initLaser()
	if scale.x == -1:
		$VFX_gravityGunMuzzleFlash.scale.x *= -1

func _process(delta):
	startStopTimer()

func initLaser():
	$RayCast.cast_to.x *= visionRange
	$MeshInstance.scale.y *= visionRange
	$MeshInstance.translation.x -= (visionRange / 2)

func checkRaycast():
	var visionLine = $RayCast.get_collider()
	if !visionLine == null:
		if visionLine.has_method("gravityFlip") or visionLine.get_parent().has_method("gravityFlip"):
			return true
		else: return false
	else: return false

func initCDTimer():
	$CooldownTimer.set_wait_time(cooldown)

func setCurrentScene(currentScenePath):
	currentScene = currentScenePath

func gravityFlip():
	sleeping = false
	gravity_scale *= -1
	$FlipContainer.scale.y *= -1
	$CollisionPolygon.scale.y *= -1
	$FlipContainer/AnimatedSprite3D.frame = 1 - $FlipContainer/AnimatedSprite3D.frame

func hitByPlayerGravityBullet():
	pass

func hitByEnemyGravityBullet():
	gravityFlip()

func startStopTimer():
	if checkRaycast() == true:
		if $CooldownTimer.is_stopped():
			$CooldownTimer.start()
	elif checkRaycast() == false:
		$CooldownTimer.stop()

func fireGravityBullet():
	$Shot.play()
	if checkRaycast() == true:
		var enemyGravityBulletInstance = enemyGravityBulletSceneTemplate.instance()
		if scale.x < 0:
			enemyGravityBulletInstance.changeDirection()
		enemyGravityBulletInstance.setFireRef(self)
		currentScene.add_child(enemyGravityBulletInstance)
		$VFX_gravityGunMuzzleFlash.emitParticles()
		enemyGravityBulletInstance.global_translation = $FireBulletPivot.global_translation
		startStopTimer()

func _on_CooldownTimer_timeout():
	fireGravityBullet()
