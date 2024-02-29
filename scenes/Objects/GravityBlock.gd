extends RigidBody


export (bool) var isStartGravityFlipped = false
export (float) var shakeWeight = 0.01
export (SpatialMaterial) var gravityStateDOWN
export (SpatialMaterial) var gravityStateUP


var camera
var lastVelocityY = 0.0
var previousChainLink
var isOnGround = false
var isGravityUp = false
var dustParticles

func _ready():
	initBlock()

func initBlock():
	dustParticles = $VFX/VFX_GravityBlockHitGround
	if isStartGravityFlipped:
		isGravityUp = !isGravityUp
		changeGravityVisual()
		gravityFlip()

func _physics_process(delta):
	lastTravelSpeed()
	axisLockX()

func initialGravityFlip():
	isStartGravityFlipped = true
	

func gravityFlip():
	isOnGround = false
	self.gravity_scale *= -1 #flips gravity
	if previousChainLink != null && previousChainLink.has_method("gravityFlip"):
		previousChainLink.gravityFlip()

func axisLockX():
	if !previousChainLink == null:
		axis_lock_linear_x = isOnGround
		if lastVelocityY >= 1 or lastVelocityY <= -1:
			isOnGround = false

func hitByGravityBullet():
	if $GravityFlipTimer.is_stopped():
		$FlipSound.play()
		isGravityUp = !isGravityUp
		changeGravityVisual()
		dustParticles.flipParticles(isGravityUp)
		$GravityFlipTimer.start()

func hitByPlayerGravityBullet():
	hitByGravityBullet()

func hitByEnemyGravityBullet():
	hitByGravityBullet()

func setPreviousChainLink(node):
	previousChainLink = node

func lastTravelSpeed():
	if linear_velocity.y != 0:
		lastVelocityY = linear_velocity.y
		lastVelocityY / 2

func blockLanding():
	if $blockLandingStartTimer.is_stopped():
		isOnGround = true
		$BlockLandSound.play(2.9)
		camera = get_tree().get_root().get_camera()
		camera.setShakeFactor(lastVelocityY * (gravity_scale * shakeWeight))
		dustParticles.emitParticles()

func _on_Area_body_entered(body):
	if !isOnGround:
		if body.get_collision_mask_bit(2) == true:
			blockLanding()

func changeGravityVisual():
	if isGravityUp == false:
		setMaterialDown()
	elif isGravityUp == true:
		setMaterialUp()
	for child in $VFX.get_children():
		if child.has_method("changeColor"):
			child.changeColor(isGravityUp)

func setMaterialDown():
	$MeshInstance.set_surface_material(1, gravityStateDOWN)
	$OmniLight.light_color = Color("4CC6E7")

func setMaterialUp():
	$MeshInstance.set_surface_material(1, gravityStateUP)
	$OmniLight.light_color = Color("F3B132")

func _on_GravityFlipTimer_timeout():
	gravityFlip()

func _on_VisibilityEnabler_camera_entered(camera):
	sleeping = false

func _on_VisibilityEnabler_camera_exited(camera):
	sleeping = true

