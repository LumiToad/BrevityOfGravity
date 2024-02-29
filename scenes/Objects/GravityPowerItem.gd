extends Spatial

var player
var gameScene

func _on_Area_body_entered(body):
	player = body
	if body.has_method("enablePlayerControls"):
		body.enablePlayerControls(false)
		gameScene.showFadeInGameUI(true)
	$Area/AnimationPlayer.play("Cutscene")

func deleteSelf():
	$Area.queue_free()

func playerAnimation():
	if player.has_method("gravityPowerItemCollected"):
		player.gravityPowerItemCollected()

func setGame(gamePath):
	gameScene = gamePath
