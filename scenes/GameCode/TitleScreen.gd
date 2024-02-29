extends Node

export (String, FILE) var mainMenuTheme
var gameScene
var gameAudioPlayer

func _ready():
	get_tree().paused = false

func setGame(gamePath):
	gameScene = gamePath
	gameScene.initScreenFade("fadeIn", 1, 0, self)
	gameScene.showMouse(true)
	setShowUI()
	if !gameScene.loadGameData() == null:
		initialLoadGameData()
	gameScene.canBePaused = false

func setShowUI():
	gameScene.showUIScene("MainMenu", true, self)
	gameScene.showUIScene("VideoSettingsMenu", false, self)
	gameScene.showUIScene("SettingsMenu", false, self)
	gameScene.showUIScene("PauseMenu", false, self)
	gameScene.showUIScene("InGameUI", false, self)


func setTitleScreenAudio():
	gameAudioPlayer.setTrackFile("AUDIOPLAYER1", mainMenuTheme)
	gameAudioPlayer.stopStream("AUDIOPLAYER1")
	gameAudioPlayer.stopStream("AUDIOPLAYER2")
	gameAudioPlayer.stopStream("AUDIOPLAYER3")
	gameAudioPlayer.chooseAudioPlayer(null, "AUDIOPLAYER1")
	gameAudioPlayer.setTransition(1, 0)

func initialLoadGameData():
	gameScene.setResumeButton()

func onScreenFadeComplete(node):
	if node == self:
		gameAudioPlayer = gameScene.getAudioPlayer()
		setTitleScreenAudio()

