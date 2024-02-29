extends KinematicBody

enum speedEnum{
	SLOW = 1
	MIDDLE = 2
	FAST = 3
}

export (bool) var isStartGravityFlipped = false
export (speedEnum) var speed
export (float) var enemyGravity = -1
export (float) var walkingDistance = 0.5
export (bool) var isCorrupted
export (int) var damage = 1

var enemySpeed
var initialPos
var upVector = Vector3.UP
var move

func _ready():
	move = Vector3.ZERO
	setSpeed()
	memorizeLocation()
	setMovement()
	if isStartGravityFlipped:
		gravityFlip()
	if isCorrupted:
		$VFX_BasicEnemy2.emitParticles(true)
		$AnimationPlayer.play("CorruptedColor")

func setSpeed():
	if speed == 1:
		enemySpeed = 2
	elif speed == 2:
		enemySpeed = 3
	elif speed == 3:
		enemySpeed = 4

func memorizeLocation():
	initialPos = self.global_translation

func setMovement():
	move = Vector3.LEFT

func changeDirection():
	if move.x < 0:
		if self.global_translation.x <= initialPos.x - walkingDistance:
			move.x *= -1
	elif move.x > 0:
		if self.global_translation.x >= initialPos.x + walkingDistance:
			move.x *= -1

func _physics_process(delta):
	normalGravity()
	move_and_slide(move * enemySpeed, upVector, false, 4, 0.785398, false)
	changeDirection()

func normalGravity():
	if is_on_floor() == false:
		move.y += enemyGravity
	else:
		move.y = 0

func hitByPlayerGravityBullet():
	gravityFlip()

func hitByEnemyGravityBullet():
	gravityFlip()

func hitBySpikes():
	$EnemyDestroyed.play()
	$AnimationPlayer.play("hurt")

func gravityFlip():
	$FlipGravity.play(1.5)
	enemyGravity *= -1
	upVector *= -1
	$AnimatedSprite3D.scale.y *= -1

func killEnemy():
	$VFX_BasicEnemy2.emitParticles(false)
	self.queue_free()

func _on_Area_body_entered(body):
	if body.has_method("hitByPatrollingEnemy"):
		body.hitByPatrollingEnemy(damage)
