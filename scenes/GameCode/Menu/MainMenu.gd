extends Control



var gameScene
var calledBy
var controllerConnected
var gameAudioPlayer


# --- Buttons ---

func setResumeButton():
	$VBoxContainer/ButtonPlayNewGame.text = "New Game"
	$VBoxContainer/ButtonResume.set_disabled(false)

func onScreenFadeComplete(node):
	if node == self:
		if self.visible == true:
			lockButtons(false)
			gameAudioPlayer.stopStream("AUDIOPLAYER1")
			gameAudioPlayer.stopStream("AUDIOPLAYER2")
			gameAudioPlayer.stopStream("AUDIOPLAYER3")
			gameScene.loadLevel(gameScene.levelSceneTemplate)
			gameScene.showUIScene("MainMenu", false, self)
			gameScene.showMouse(false)

func setControllerSupport(connected):
	controllerConnected = connected
	if self.visible == true:
		gameScene.showMouse(true)
	if connected == true:
		$VBoxContainer/ButtonPlayNewGame.grab_focus()

func lockButtons(boolValue):
	$VBoxContainer/ButtonPlayNewGame.set_disabled(boolValue)
	$VBoxContainer/ButtonResume.set_disabled(boolValue)
	$VBoxContainer/ButtonSettings.set_disabled(boolValue)
	$VBoxContainer/ButtonGallery.set_disabled(boolValue)
	$VBoxContainer/ButtonCredits.set_disabled(boolValue)
	$VBoxContainer/ButtonQuit.set_disabled(boolValue)

func _on_ButtonPlayNewGame_pressed():
	gameScene.resetLevelTemplate()
	gameScene.initScreenFade("fadeOut", 1, 0.5, self)
	lockButtons(true)


func _on_ButtonResume_pressed():
	var loadedData = gameScene.loadGameData()
	if !loadedData == null:
		if !loadedData["CurrentLevel"] == null:
			gameScene.levelSceneTemplate = load(loadedData["CurrentLevel"])
	gameScene.initScreenFade("fadeOut", 1, 0.5, self)
	lockButtons(true)

func _on_ButtonSettings_pressed():
	gameScene.showUIScene("SettingsMenu", true, self)
	gameScene.showUIScene("MainMenu", false, self)


func _on_ButtonCredits_pressed():
	gameScene.finalVideoPlay()
	gameScene.showUIScene("MainMenu", false, null)
	

func _on_ButtonQuit_pressed():
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().quit()


func _on_ButtonGallery_button_up():
	gameScene.showUIScene("MainMenu", false, self)
	gameScene.showUIScene("AchievementGalleryUI", true, self)

func _on_MainMenu_visibility_changed():
	if self.visible == true:
		gameAudioPlayer = gameScene.getAudioPlayer()
		if controllerConnected == true:
			$VBoxContainer/ButtonPlayNewGame.grab_focus()


func _on_ButtonLink_button_up():
	OS.shell_open("https://brevity-of-gravity.school4games.net/")
