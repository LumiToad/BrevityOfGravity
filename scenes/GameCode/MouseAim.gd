extends Spatial

export (PackedScene) var gravityBullet
export (float) var deadzone = 0.15
export (float) var rangeFactor = 5

var currentScene

var levelCamera

var player

var controllerConnected

var scaleFacing = Vector3(1,1,0)

func _ready():
	levelCamera = get_tree().get_root().get_camera()

func _process(delta):
	if !player == null:
		if player.hasStaff == true:
			if controllerConnected == true:
				controllerAim()
				$VFX_ControllerCursor.visible = true
			else:
				mouseAim()

func setControllerSupport(connected):
	controllerConnected = connected
	if !player == null:
		if player.hasStaff == true:
			$VFX_ControllerCursor.visible = controllerConnected

func mouseAim():
	var mouse_pos = levelCamera.project_position(get_viewport().get_mouse_position(),-levelCamera.translation.z)
	var direction = self.global_translation.direction_to(mouse_pos)
	gunFire(direction)

func controllerAim():
	var direction = Vector3.ZERO
	var joyStickPos = Vector3(Input.get_joy_axis(0,JOY_AXIS_2), Input.get_joy_axis(0,JOY_AXIS_3), 0)
	if joyStickPos.length() > deadzone:
		direction = Vector3.ZERO.direction_to(joyStickPos)
	else: pass
	direction *= -1
	$VFX_ControllerCursor.translation.x = direction.x * scaleFacing.x *rangeFactor 
	$VFX_ControllerCursor.translation.y = direction.y * scaleFacing.y *rangeFactor
	if !direction == Vector3.ZERO:
		gunFire(direction)

func gunFire(direction):
	if $StaffCooldownTimer.is_stopped():
		if Input.is_action_just_pressed("gravity_gun"):
			$StaffCooldownTimer.start()
			if player.hasStaff and player.enableControls:
				$PlayerShot.play()
				$VFX_gravityGunMuzzleFlash.emitParticles()
				var gravityBulletFire = gravityBullet.instance()
				gravityBulletFire.translation = global_translation
				gravityBulletFire.move = direction
				currentScene.add_child(gravityBulletFire)

func correctFlipX():
	$VFX_ControllerCursor.scale.x *= -1
	$VFX_gravityGunMuzzleFlash.scale.x *= -1
	scaleFacing.x *= -1

func correctFlipY():
	$VFX_ControllerCursor.scale.y *= -1
	$VFX_gravityGunMuzzleFlash.scale.y *= -1
	scaleFacing.y *= -1

func setCurrentScene(currentScenePath):
	currentScene = currentScenePath

func setPlayer(node):
	player = node
