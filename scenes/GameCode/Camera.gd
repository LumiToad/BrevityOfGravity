extends Spatial

export (float) var borderRangeX = 5.5
export (float) var borderRangeY = 4
export (float) var lerpSpeedX = 0.23
export (float) var lerpSpeedY = 0.38
export (float) var maxShakePower = 17

var target
var gameScene
var targetBorder = Vector3()
var shakeVector = Vector3(0,0,0)
var shakeFactor = 0.0
var minDefaultZoom = -10.0
var lerpDeltaFixValue = 10.0
var isStartPos = false
var lastDirection
var camStopPos

#cameraZone settings
var originalZpos = 0.0
var originalLerpSpeedX = 0.0
var originalLerpSpeedY = 0.0
var originalBorderRangeX = 0.0
var originalBorderRangeY = 0.0
var lerpSpeedZ = 0.0
var zPos = 0.0
var cameraZonePos = Vector3()
var isZoom = false
var isStaticCam = false
var lookAhead = true

func _ready():
	originalZpos = global_translation.z
	originalLerpSpeedX = lerpSpeedX
	originalLerpSpeedY = lerpSpeedY
	originalBorderRangeX = borderRangeX
	originalBorderRangeY = borderRangeY
	lerpDeltaFix()
	if global_translation.z >= minDefaultZoom:
		printerr("Lumi here! Please put a higher negative number than ",  minDefaultZoom, " in Translation z of the camera!") 
		get_tree().quit()


func _physics_process(delta):
	if !target == null and isStartPos == false:
		setCameraStartPos(targetBorder)
	
	if !target == null and isStartPos == true:
		if !camStopPos == null:
			targetBorder.x = camStopPos.x
			setBorderY(target.playerGravity)
			lerpCamera(targetBorder, delta)
		elif lookAhead:
			setBorderX(target.move.x)
			setBorderY(target.playerGravity)
			lerpCamera(targetBorder, delta)
		elif lookAhead == false and isStaticCam == false:
			lerpCamera(target.global_translation, delta)
		elif isStaticCam:
			lerpCamera(cameraZonePos, delta)
	camShake()

# --- normal camera ---

func setCameraStartPos(targetBorder):
	setBorderX(-1)
	setBorderY(1)
	global_translation.x = targetBorder.x
	global_translation.y = targetBorder.y
	if global_translation.x == targetBorder.x:
		if global_translation.y == targetBorder.y:
			isStartPos = true

func lerpDeltaFix():
	lerpSpeedX *= lerpDeltaFixValue
	lerpSpeedY *= lerpDeltaFixValue
	lerpSpeedZ *= lerpDeltaFixValue
	lerpSpeedX = clamp(lerpSpeedX, 0, 5)
	lerpSpeedY = clamp(lerpSpeedY, 0, 5)
	lerpSpeedZ = clamp(lerpSpeedZ, 0, 5)

func lerpCamera(position, delta):
	global_translation.x = lerp(global_translation.x, position.x + shakeVector.x, lerpSpeedX * delta)
	global_translation.y = lerp(global_translation.y, position.y + shakeVector.y, lerpSpeedY * delta)
	if isZoom:
		global_translation.z = lerp(global_translation.z, zPos, lerpSpeedZ * delta)
	else:
		global_translation.z = lerp(global_translation.z, originalZpos, lerpSpeedZ * delta)

func setBorderX(direction):
	if direction > 0:
		targetBorder.x = target.global_translation.x + borderRangeX
		lastDirection = 1
	elif direction < 0:
		targetBorder.x = target.global_translation.x - borderRangeX
		lastDirection = -1
	elif direction == 0 and targetBorder.x != 0:
		setBorderX(lastDirection)

func setBorderY(direction):
	if direction > 0:
		targetBorder.y = target.global_translation.y - borderRangeY
	elif direction < 0:
		targetBorder.y = target.global_translation.y + borderRangeY

func camStopOnWall(boolValue):
	if boolValue == true and !target == null:
		if camStopPos == null:
			camStopPos = Vector3(target.global_translation.x, 0, 0)
	else: camStopPos = null

# --- normal camera end ---


# --- camera zone ---


func overrideLerpSpeedX(speed):
	lerpSpeedX = speed
	lerpSpeedX *= lerpDeltaFixValue
	lerpSpeedX = clamp(lerpSpeedX, 0, 5)

func overrideLerpSpeedY(speed):
	lerpSpeedY = speed
	lerpSpeedY *= lerpDeltaFixValue
	lerpSpeedY = clamp(lerpSpeedY, 0, 5)

func overrideBorderRangeX(value):
	borderRangeX = value

func overrideBorderRangeY(value):
	borderRangeY = value

func zoom(distance, speed):
	isZoom = true
	zPos = distance
	lerpSpeedZ = speed
	lerpSpeedZ *= lerpDeltaFixValue
	lerpSpeedZ = clamp(lerpSpeedZ, 0, 5)

func staticCam(position):
	lookAhead = false
	isStaticCam = true
	cameraZonePos = position

func stopLookAhead():
	lookAhead = false

func resetCameraSettings():
	isZoom = false
	isStaticCam = false
	lookAhead = true
	overrideBorderRangeX(originalBorderRangeX)
	overrideBorderRangeY(originalBorderRangeY)
	overrideLerpSpeedX(originalLerpSpeedX)
	overrideLerpSpeedY(originalLerpSpeedY)

# --- camera zone end ---

# --- camera shake ---

func setShakeFactor(value):
	shakeFactor = value

func camShake():
	shakeFactor = lerp(shakeFactor, 0, 0.1)
	randomize()
	shakeVector = Vector3(rand_range(-shakeFactor,shakeFactor), rand_range(-shakeFactor,shakeFactor), rand_range(-shakeFactor,shakeFactor))

# --- camera shake end ---

func showCoinUI(boolValue):
	$CoinUI/VFX_Coin_01.emitParticles(!boolValue)
