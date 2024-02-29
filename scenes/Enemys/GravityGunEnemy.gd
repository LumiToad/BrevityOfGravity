extends KinematicBody


#sets enemy speed
export (float) var enemy_speed = 10

#sets enemy gravity
export (float) var enemy_gravity = -1 # sets enemy_gravity

#loads the enemyBullet
export (PackedScene) var enemyBulletScene

#starts with gravity reversed
export (bool) var gravityReversed

#placeholder for the gameScene
var gameScene

const UP_VECTOR = Vector3(0, -1, 0) # defines a constant UP_Vector to 0, -1

var move = Vector3(0,enemy_gravity,0) # sets move to 0x, Y enemy_gravity, z0

func _ready():
	if gravityReversed:
		gravityFlip()
	

func _process(delta):
	normalGravity(delta)
	move_and_slide(move * enemy_speed, UP_VECTOR)


func normalGravity(delta): 
	if is_on_ceiling() or is_on_floor():
		move.y = 0
	move.y += + enemy_gravity * delta


func gravityFlip():
	$GravityFlip.play(1.5)
	enemy_gravity *= -1


func hitBySpikes():
	$MeshInstance.hide()
	$AnimationPlayer.stop()
	$EnemyDestruction.play()
	yield(get_tree().create_timer(.5), "timeout")
	self.queue_free()


func _on_Area_body_entered(body):
	if body.has_method("hitByGravityGunEnemy"):
		body.hitByGravityGunEnemy()

func gravityGunEnemy_Fire():
	#instance a bullet from PackedScene
	var enemyBullet = enemyBulletScene.instance()
	#set the enemyBullet translation to global translation
	enemyBullet.translation = global_translation
	#if enemy is facing left
	if scale.x < 0:
		#change bullet speed to negativ, so the bullet actually flies left
		enemyBullet.bullet_speed *= -1
	#spawns bullet
	gameScene.add_child(enemyBullet)

func setGame(gamePath):
	gameScene = gamePath
