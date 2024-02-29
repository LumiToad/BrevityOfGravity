extends Control

export (Environment) var blurryEnvironment

var gameScene
var gameAudioPlayer
var calledBy
var oldEnvironment
var controllerConnected

func pauseGame():
	var camera = get_tree().get_root().get_camera()
	oldEnvironment = camera.get_environment()
	camera.set_environment(blurryEnvironment)
	get_tree().paused = true

func resumeGame():
	get_tree().paused = false
	var camera = get_tree().get_root().get_camera()
	camera.set_environment(oldEnvironment)
	gameScene.showUIScene("PauseMenu", false, self)
	gameScene.showMouse(false)

func quitToMainMenu():
	gameScene.currentSceneTemplate = gameScene.titleScreenSceneTemplate
	gameScene.reloadCurrentScene()

func showQuitPopup(boolValue):
	if boolValue == true:
		$Control/PopupPanel.popup()
	elif boolValue == false:
		$Control/PopupPanel.visible = false
	$Control.visible = boolValue

func onScreenFadeComplete(node):
	if node == self:
		quitToMainMenu()

func fadeOutAudio():
	gameAudioPlayer = gameScene.getAudioPlayer()
	gameAudioPlayer.stopStream("AUDIOPLAYER1")
	gameAudioPlayer.stopStream("AUDIOPLAYER2")
	gameAudioPlayer.stopStream("AUDIOPLAYER3")

func setControllerSupport(connected):
	controllerConnected = connected
	if self.visible == true:
		gameScene.showMouse(true)

func _on_ButtonResume_pressed():
	resumeGame()

func _on_ButtonRestart_pressed():
	gameScene.showUIScene("PauseMenu", false, self)
	gameScene.reloadLevel()
	get_tree().paused = !get_tree().paused

func _on_ButtonSettings_pressed():
	gameScene.showUIScene("SettingsMenu", true, self)
	gameScene.showUIScene("PauseMenu", false, self)

func _on_ButtonQuit_pressed():
	showQuitPopup(true)
	gameScene.showUIScene("PauseMenu", false, self)

func _on_PopupButtonYes_pressed():
	gameScene.initScreenFade("fadeOut", 1, 0, self)
	fadeOutAudio()
	showQuitPopup(false)

func _on_PopupButtonNo_pressed():
	showQuitPopup(false)
	gameScene.showUIScene("PauseMenu", true, self)

func _on_PauseMenu_visibility_changed():
	if self.visible == true:
		if controllerConnected == true:
			$VBoxContainer/ButtonResume.grab_focus()
