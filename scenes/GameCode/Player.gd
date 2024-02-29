extends KinematicBody

export (float) var playerMaxSpeed = 17.5

export (float) var playerAcceleration = 0.05

export (float) var playerGravity = -1.15

export (float) var jumpForceReset = 7.7

export (float) var jumpForceDecrease = 1

export var gravityChangeReset = 2

export (float) var ceilingRecoil = 1

export (bool) var gravityFlipSelf = false

export (bool) var hasStaff = false

export (float) var damageBoostForceX = 5

export (float) var damageBoostForceY = 5

var jumpForce = 0.0

var hasJumped = false

var applyJumpForce = true

var enableControls = true

var gameScene

var levelReference

var levelCamera

var directionVector = Vector3(0, 1, 0)

var snapVector = Vector3(0,-1,0)

var tempSnap = Vector3()

var move = Vector3(0,playerGravity,0)

var gravityChange = 0

var currentAnimation

var bufferedJump = false

var isJumping = false

var healthPoints = 3

var coins = 0

var lastMoveX

var upCollided
var downCollided
var leftCollided
var rightCollided

func _ready():
	setCurrentAnimation()
	if gravityFlipSelf:
		gravityChange = gravityChangeReset
	jumpForce = jumpForceReset
	setUpCrushRayCast()

func _physics_process(delta):
	gameScene.setInGameUI(gravityChange, healthPoints, hasStaff, coins)
	normalGravity()
	if enableControls == true and $DamageBoostTimer.is_stopped():
		key_input(delta)
		flipScale()
	
	if hasJumped:
		jumpForce -= jumpForceDecrease
		jumpForce = clamp(jumpForce, 0, jumpForceReset)
	var wasOnFloor = is_on_floor()
	
	move_and_slide_with_snap(move, snapVector, directionVector, true, 4, 0.785398, false)
	
	if wasOnFloor != is_on_floor():
		coyoteTimer()
	
	reapplySnap()
	
	updateRayCasts()
	checkCrushedByGeometry()
	checkWallCameraStop()

func key_input(delta): 

	if Input.is_action_just_pressed("gravity") and gravityFlipSelf:
		if gravityOnceEvaluate() == true: 
			gravityFlip()
	
	leftRight()
	jump(delta)

func jump(delta):
	if Input.is_action_just_pressed("jump"):
		inputBuffer()
		if evaluateCanJump():
			hasJumped = true
			$AudioContainer/PlayerJump.play()
		
	if Input.is_action_pressed("jump") and hasJumped and applyJumpForce:
		isJumping = true
	elif Input.is_action_just_released("jump"):
		isJumping = false
		applyJumpForce = false
	
	if hasJumped:
		playAnimationJumping()
		jumpCalc()
	if is_on_floor():
		jumpForce = jumpForceReset
		if playerGravity < 0 and move.y <= 0:
			if $BufferTimer.is_stopped():
				hasJumped = false
			else: 
				hasJumped = true
				$AudioContainer/PlayerJump.play()
		elif playerGravity > 0 and move.y >= 0:
			if $BufferTimer.is_stopped():
				hasJumped = false
			else: 
				hasJumped = true
				$AudioContainer/PlayerJump.play()
		applyJumpForce = true

func evaluateCanJump():
	if (is_on_floor() or !$BufferTimer.is_stopped() or !$CoyoteTimer.is_stopped()) and !hasJumped:
		return true

func coyoteTimer():
	if (!is_on_floor() and $CoyoteTimer.is_stopped() and $BufferTimer.is_stopped()) and !hasJumped:
		$CoyoteTimer.start()

func inputBuffer():
	if !is_on_floor():
		if $CoyoteTimer.is_stopped() and $BufferTimer.is_stopped() and hasJumped:
			$BufferTimer.start()

func jumpCalc():
	if hasJumped and (isJumping or !$BufferTimer.is_stopped()):
		memorizeSnap()
		if playerGravity < 0 and move.y >= 0:
			move.y += jumpForce
			if move.y != 0:
				$BufferTimer.stop()
		elif playerGravity > 0 and move.y <= 0:
			move.y += -jumpForce
			if move.y != 0:
				$BufferTimer.stop()
		elif playerGravity < 0 and !$CoyoteTimer.is_stopped():
			move.y += jumpForce
		elif playerGravity > 0 and !$CoyoteTimer.is_stopped():
			move.y += -jumpForce
		elif hasJumped:
			jumpForce = 0

func memorizeSnap():
	if is_on_floor():
		if snapVector.y != 0:
			tempSnap = snapVector
			snapVector = Vector3.ZERO

func reapplySnap():
	if is_midair():
		if snapVector.y == 0:
			snapVector = tempSnap

func leftRight():
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
		if lastMoveX == null:
			pass
		else: 
			move.x = lerp(move.x, -lastMoveX, playerAcceleration)
	elif Input.is_action_pressed("left"):
		if is_on_floor():
			playAnimationWalking()
		else: playAnimationJumping()
		if getCollisionLeftRight() != "left":
			move.x = lerp(move.x, playerMaxSpeed, playerAcceleration)
			lastMoveX = move.x
		else: move.x = 0
	elif Input.is_action_pressed("right"):
		if is_on_floor():
			playAnimationWalking()
		else: playAnimationJumping()
		if getCollisionLeftRight() != "right":
			move.x = lerp(move.x, -playerMaxSpeed, playerAcceleration)
		else: move.x = 0
	else: 
		lastMoveX = 0
		if is_on_floor() and !hasJumped:
			playAnimationIdle()
			if $DamageBoostTimer.is_stopped():
				move.x = 0
		move.x = lerp(move.x, 0, 0.01)

func flipScale():
	if move.x > 0:
		if $FlipContainer.scale.x > 0:
			$FlipContainer.scale.x *= -1
			$FlipContainer/MouseAim.correctFlipX()
	elif move.x < 0:
		if $FlipContainer.scale.x < 0:
			$FlipContainer.scale.x *= -1
			$FlipContainer/MouseAim.correctFlipX()

func gravityOnceEvaluate():
	if !is_on_floor() and gravityChange > 0: 
		gravityChange -= 1
		return true
	elif is_on_floor():
		return true
	else:
		return false

func normalGravity():
	if !is_on_floor():
		move.y += playerGravity
	ceilingRecoil()
	if is_on_floor():
		if gravityFlipSelf:
			gravityChange = gravityChangeReset
		if $DamageBoostTimer.is_stopped():
			move.y = 0

func ceilingRecoil():
	if is_on_ceiling():
		if playerGravity < 0:
			move.y = -ceilingRecoil
		elif playerGravity > 0:
			move.y = ceilingRecoil


func gravityFlip():
	playerGravity *= -1
	$FlipContainer.scale.y *= -1
	snapVector *= -1
	directionVector *= -1
	$AudioContainer/GravityChange.play()
	$FlipContainer/MouseAim.correctFlipY()
	$VFXContainer/VFX_PlayerWalking.translation.y *= -1

func activateStaff():
	hasStaff = true
	gameScene.showMouse(null)
	currentAnimation = $FlipContainer/PlayerStaffSprite3D
	$FlipContainer/PlayerSprite3D.visible = false
	$FlipContainer/PlayerStaffSprite3D.visible = true
	$FlipContainer/MouseAim.setPlayer(self)

func coinCollected():
	coins += 1

func gunCollected():
	activateStaff()
	enablePlayerControls(true)
	$VFXContainer/VFX_GravityPowerItemCutsceneExplosion.emitPowerItemParticles()
	gameScene.showFadeInGameUI(false)

func gravityPowerItemCollected():
	gravityFlipSelf = true
	enablePlayerControls(false)
	cutsceneControl("GCHANGE")
	move.x = -20
	move.x = 1
	#$VFXContainer/VFX_GettingGravity.emitParticles()
	$VFXContainer/VFX_GravityPowerItemCutsceneExplosion.emitPowerItemParticles()
	yield(get_tree().create_timer(0.8), "timeout")
	enablePlayerControls(true)
	gameScene.showFadeInGameUI(false)
	move.x = 0

func hitByPatrollingEnemy(damageValue):
	hurtPlayer(damageValue)

func hitByEnemyGravityBullet():
	gravityFlip()

func hitByDeathZone():
	healthPoints = 0
	killPlayer()
	levelCamera.target = null

func hitBySpikes():
	hurtPlayer(3)

func hurtPlayer(value):
	if $InvincibleTimer.is_stopped() == true:
		if $DamageBoostTimer.is_stopped():
			if !$FlipContainer/PlayerSprite3D.animation == "dying":
				healthPoints -= value
			if !deathCheck():
				$AudioContainer/PlayerIsHurt.play()
				playerDamageBoost()

func crushed():
	hurtPlayer(3)

func deathCheck():
	if healthPoints <= 0:
		killPlayer()
		playAnimationDying()
		return true

func killPlayer():
	if !currentAnimation.animation == "dying":
		gameScene.canBePaused = false
		$AudioContainer/PlayerDies.play()
		enableControls = false
		move.x = 0
		yield(get_tree().create_timer(1), "timeout")
		gameScene.onPlayerDeath()

func playerDamageBoost():
	if !$FlipContainer/PlayerSprite3D.animation == "dying":
		$AnimationPlayer.play("playerHurt")
		$DamageBoostTimer.start()
		memorizeSnap()
		if playerGravity < 0:
			move.y = damageBoostForceY
		elif playerGravity > 0:
			move.y = -damageBoostForceY
		if $FlipContainer.scale.x > 0:
			move.x = damageBoostForceX
		elif $FlipContainer.scale.x < 0:
			move.x = -damageBoostForceX

func switchCollisionLayerMask(layerBit, layerActive, maskBit, maskActive):
	set_collision_layer_bit(layerBit, layerActive)
	set_collision_mask_bit(maskBit, maskActive)

func is_midair():
	if !is_on_floor() and !is_on_ceiling():
		return true
	else: return false

func setGame(gamePath):
	gameScene = gamePath
	if hasStaff == true:
		activateStaff()

func setCamera(cam):
	levelCamera = cam
	$FlipContainer/MouseAim.levelCamera = levelCamera

func setCurrentAnimation():
	$FlipContainer/WeaponSprite3D.visible = false
	currentAnimation = $FlipContainer/PlayerSprite3D
	currentAnimation.visible = true

func playAnimationIdle():
	if !currentAnimation.animation == "idle":
		currentAnimation.play("idle")
		$VFXContainer/VFX_PlayerWalking.emitParicles(false)
		$AudioContainer/Walking.stop()

func playAnimationWalking():
	if !currentAnimation.animation == "walking":
		currentAnimation.play("walking")
		$VFXContainer/VFX_PlayerWalking.emitParicles(true)
		$AudioContainer/Walking.play()

func playAnimationDying():
	if !currentAnimation.animation == "dying":
		currentAnimation.play("dying")
		$AudioContainer/Walking.stop()
		if $FlipContainer/PlayerStaffSprite3D.visible:
			$AnimationPlayer.play("dropStaff")
		$VFXContainer/VFX_PlayerWalking.emitParicles(false)

func playAnimationJumping():
	if !currentAnimation.animation == "jumping":
		currentAnimation.play("jumping")
		$VFXContainer/VFX_PlayerWalking.emitParicles(false)
		$AudioContainer/Walking.stop()

func updateRayCasts():
	upCollided = $RayCastUp.get_collider()
	downCollided = $RayCastDown.get_collider()
	leftCollided = $RayCastLeft.get_collider()
	rightCollided = $RayCastRight.get_collider()
	
func setUpCrushRayCast():
	$RayCastUp.cast_to.y *= ($CollisionShape.shape.height - 0.05)
	$RayCastDown.cast_to.y *= ($CollisionShape.shape.height - 0.05)


func checkCrushedByGeometry():
	if checkWall("up") and checkWall("down"):
		crushed()
		turnOffRaycasts()
	if checkWall("left") and checkWall("right"):
		crushed()
		turnOffRaycasts()

func turnOffRaycasts():
	$RayCastUp.collide_with_bodies = false
	$RayCastDown.collide_with_bodies = false

func checkWall(direction):
	if direction == "up":
		if upCollided != null and upCollided.get_collision_mask_bit(0) == true:
			return true
		else: return false
	if direction == "down":
		if downCollided != null and downCollided.get_collision_mask_bit(0) == true:
			return true
		else: return false

func getCollisionLeftRight():
	for i in range(get_slide_count()):
		if is_on_wall():
			var collision = get_slide_collision(i)
			if collision.normal.x > 0:
				return "right"
			elif collision.normal.x < 0:
				return "left"
	return "none"

func checkWallCameraStop():
	if !leftCollided == null or !rightCollided == null:
		var camera = get_tree().get_root().get_camera()
		camera.camStopOnWall(true)
	else:
		var camera = get_tree().get_root().get_camera()
		camera.camStopOnWall(false)

func enablePlayerControls(boolValue):
	move.x = 0
	playAnimationIdle()
	enableControls = boolValue

func cutsceneControl(action):
	if action == "LEFT":
		playAnimationWalking()
		move.x = playerMaxSpeed * 0.5
	if action == "RIGHT":
		playAnimationWalking()
		move.x = -playerMaxSpeed * 0.5
	if action == "JUMP":
		playAnimationJumping()
		#code to make player jump
	if action == "GCHANGE":
		gravityFlip()
	if action == "GGUN":
		#code to make player fire
		pass

func changeLevel(level):
	gameScene.canBePaused = false
	gameScene.initScreenFade("fadeOut", 1, 0.1, self)
	levelReference = level

func setControllerSupport(connected):
	if hasStaff == true:
		gameScene.showMouse(true)
	else: gameScene.showMouse(false)

func onScreenFadeComplete(node):
	if node == self:
		gameScene.loadLevel(levelReference)

func _on_DamageBoostTimer_timeout():
	$AnimationPlayer.stop()
	$FlipContainer.visible = true

func killWalkingAudio():
	$AudioContainer/Walking.stop()
