extends Control

var gameScene
var gameUI


func _on_VideoPlayer_finished():
	gameScene.currentSceneTemplate = gameScene.titleScreenSceneTemplate
	gameScene.reloadCurrentScene()
	gameScene.showFadeInGameUI(false)
	gameScene.showUIScene("MainMenu", true, null)
	self.queue_free()

func setGame(gamePath):
	gameScene = gamePath
