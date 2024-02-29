extends Spatial

export (String) var text
export (bool) var isStopingKolka
export (bool) var isChangingUI = true

var gameScene
var player

func setGame(gamePath):
	gameScene = gamePath

func _on_Area_body_entered(body):
	player = body
	gameScene.setTextInDialogUI(text)
	if isChangingUI == true:
		gameScene.showFadeInGameUI(true)
	if isStopingKolka == true:
		if player.has_method("enablePlayerControls"):
			player.enablePlayerControls(false)
			$StopTimer.start()
			isStopingKolka = false

func _on_Area_body_exited(body):
	gameScene.closeDialogUI()
	if isChangingUI == true:
		gameScene.showFadeInGameUI(false)

func _on_StopTimer_timeout():
	if player.has_method("enablePlayerControls"):
		player.enablePlayerControls(true)
