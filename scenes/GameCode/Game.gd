extends Node2D

var currentSceneTemplate
export (PackedScene) var videoScreenSceneTemplate
export (PackedScene) var titleScreenSceneTemplate 
export (PackedScene) var newGameLevelSceneTemplate
var levelSceneTemplate

var screenFade
var canBePaused = false
var mouseVisible = false
var currentLevelName = ""
var controllerConnected
var toggle = false

func _ready():
	for menu in $UI.get_children():
		menu.gameScene = self
	changeSceneTo(titleScreenSceneTemplate)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.connect("joy_connection_changed", self, "onControllerConnected")
	if Input.get_connected_joypads().size() > 0:
		onControllerConnected(0, true)

func _process(delta):
	pauseMenu()
	#------SCREENSHOT MODE FOR DEVTEAM----
	if Input.is_action_just_pressed("UI_invisible"):
		toggle = !toggle
		showFadeInGameUI(toggle)

func getLevelName():
	return currentLevelName

func setLevelName(nameString):
	if nameString.find("@") == 0:
		currentLevelName = nameString.get_slice("@", 1)
	else: currentLevelName = nameString

func resetLevelTemplate():
	levelSceneTemplate = newGameLevelSceneTemplate

func showFadeInGameUI(boolValue):
	$UI/InGameUI.showUI(boolValue)
	var camera = get_tree().get_root().get_camera()
	if !camera == null:
		camera.showCoinUI(boolValue)

func onControllerConnected(device_id, connected):
	controllerConnected = connected
	setControllerInChildren(self, connected)

func setControllerInChildren(node, connected):
	for child in node.get_children():
		if child.has_method("setControllerSupport"):
			child.setControllerSupport(connected)
		setControllerInChildren(child, connected)

func saveGameData(dataString, value):
	$SaveGame.setSaveData(dataString, value)

func loadGameData():
	return $SaveGame.loadData()

func setResumeButton():
	$UI/MainMenu.setResumeButton()

func showUIScene(scene, boolValue, callRef):
	var sceneUI = $UI.get_node(scene)
	sceneUI.visible = boolValue
	if boolValue == true:
		if !callRef == null:
			sceneUI.calledBy = callRef

func showMouse(boolValue):
	if controllerConnected == true:
		$UI/VFXMouse.visible = false
	else:
		if mouseVisible == true:
			$UI/VFXMouse.visible = true
		elif boolValue == null:
			mouseVisible = true
			$UI/VFXMouse.visible = true
		elif boolValue == true:
			$UI/VFXMouse.visible = true
		elif boolValue == false:
			$UI/VFXMouse.visible = false

func pauseMenu():
	if canBePaused == true:
		if get_tree().paused == false:
			if Input.is_action_just_pressed("pause"):
				showUIScene("PauseMenu", true, self)
				$UI/PauseMenu.pauseGame()
				showMouse(true)
				for child in $CurrentScene.get_children():
					if child.has_method("setPauseMode"):
						child.setPauseMode(PAUSE_MODE_STOP)

func reloadCurrentScene():
	changeSceneTo(currentSceneTemplate)

func changeSceneTo(newScene):
	for child in $CurrentScene.get_children():
		child.queue_free()
	currentSceneTemplate = newScene
	$CurrentScene.add_child(currentSceneTemplate.instance())
	setGameRefInChild(self)
	setCurrentSceneRefInChild($CurrentScene)
	if Input.get_connected_joypads().size() > 0:
		onControllerConnected(0, true)

func reloadLevel():
	loadLevel(currentSceneTemplate)

func loadLevel(level):
	changeSceneTo(level)
	showMouse(false)
	initScreenFade("fadeIn", 1, 0, self)
	showUIScene("InGameUI", true, self)
	canBePaused = true

func setGameRefInChild(node):
	for child in node.get_children():
		if child.has_method("setGame"):
			child.setGame(self)
		setGameRefInChild(child)

func setCurrentSceneRefInChild(node):
	for child in node.get_children():
		if child.has_method("setCurrentScene"):
			child.setCurrentScene($CurrentScene)
		setCurrentSceneRefInChild(child)

func setInGameUI(gravityCharges, HP, hasStaff, coins):
	for child in $UI.get_children():
		if child.has_method("setGravityCharges"):
			child.setGravityCharges(gravityCharges)
		if child.has_method("setHP"):
			child.setHP(HP)
		if child.has_method("setGravityStaff"):
			child.setGravityStaff(hasStaff)
		if child.has_method("setCoins"):
			child.setCoins(coins)

func onPlayerDeath():
	$UI/ScreenFade.fadeOut(1, 0)
	yield(get_tree().create_timer(1), "timeout")
	loadLevel(currentSceneTemplate)

func initScreenFade(fade, time, idle, node):
	$UI/ScreenFade.calledBy = node
	if fade == "fadeIn":
		$UI/ScreenFade.fadeIn(time, idle)
	elif fade == "fadeOut":
		$UI/ScreenFade.fadeOut(time, idle)

func getAudioPlayer():
	return $AudioPlayer

func setTextInDialogUI(string):
	$UI/DialogUI.setText(string)
	showUIScene("DialogUI", true, self)

func closeDialogUI():
	$UI/DialogUI.hideText()

func setTutorial(animationName):
	$UI/TutorialUI.playTutorialAnimation(animationName)
	showUIScene("TutorialUI", true, self)

func closeTutorialUI():
	$UI/TutorialUI.stopTutorialAnimation()
	showUIScene("TutorialUI", false, self)

func finalVideoPlay():
	canBePaused = false
	var videoScreen = videoScreenSceneTemplate.instance()
	videoScreen.gameScene = self
	$AudioPlayer.stopStream("AUDIOPLAYER1")
	$AudioPlayer.stopStream("AUDIOPLAYER2")
	$AudioPlayer.stopStream("AUDIOPLAYER3")
	$UI.add_child(videoScreen)
	for child in $CurrentScene.get_children():
		child.queue_free()

func onScreenFadeComplete(_dummy):
	pass
