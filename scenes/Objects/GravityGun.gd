extends Spatial

var player
var gameScene

func _on_Area_body_entered(body):
	player = body
	if body.has_method("enablePlayerControls"):
		body.enablePlayerControls(false)
		gameScene.showFadeInGameUI(true)
		$AnimationPlayer.play("Cutscene")

func playerAnimation():
	if player.has_method("gunCollected"):
		player.gunCollected()

func deleteSelf():
	$Area.queue_free()
	$MeshInstance.queue_free()
	$OmniLight.queue_free()
	$AnimationPlayer.queue_free()

func setGame(gamePath):
	gameScene = gamePath
