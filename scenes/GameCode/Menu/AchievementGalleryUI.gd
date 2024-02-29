extends Control

export (Array, String) var galleryArray
export (String, FILE) var galleryMusic
export (String, FILE) var mainMenuTheme

var gameScene
var calledBy
var controllerConnected
var gameAudioPlayer

var loadedCoinData
var numberOfFrames
var galleryRect
var currentFrame = 0
var requestedLevelName = "Act-I-1"


func _ready():
	galleryRect = $TextureRect.texture
	numberOfFrames = galleryRect.get_frames() - 1

func loadCoinData():
	loadedCoinData = gameScene.loadGameData()

func _on_BackButton_button_up():
	currentFrame = galleryRect.get_current_frame()
	if currentFrame == 0:
		galleryRect.set_current_frame(numberOfFrames)
	else:
		galleryRect.set_current_frame(currentFrame - 1)
	currentFrame = galleryRect.get_current_frame()
	checkPictureLocked()

func _on_NextButton_button_up():
	currentFrame = galleryRect.get_current_frame()
	if currentFrame == numberOfFrames:
		galleryRect.set_current_frame(0)
	else:
		galleryRect.set_current_frame(currentFrame + 1)
	currentFrame = galleryRect.get_current_frame()
	checkPictureLocked()

func checkPictureLocked():
	requestedLevelName = galleryArray[currentFrame]
	if !loadedCoinData == null:
		if loadedCoinData.has(requestedLevelName + "#CoinsCollected"):
			if loadedCoinData.has(requestedLevelName + "#CoinsInLevel"):
				if loadedCoinData[requestedLevelName + "#CoinsCollected"] == loadedCoinData[requestedLevelName + "#CoinsInLevel"]:
					$TextureRect/LockScreen.visible = false
				else: 
					$TextureRect/LockScreen.visible = true
			setLabel(true)
		else: setLabel(false)
	else: setLabel(false)

func setLabel(hasEntry):
	if hasEntry == true:
		$HBoxContainer/SectionName.text = requestedLevelName.right(4)
		$HBoxContainer/CoinsCollected.text = str(loadedCoinData[requestedLevelName + "#CoinsCollected"])
		$HBoxContainer/CoinsAvailable.text = str(loadedCoinData[requestedLevelName + "#CoinsInLevel"])
	else:
		$TextureRect/LockScreen.visible = true
		$HBoxContainer/SectionName.text = "???"
		$HBoxContainer/CoinsCollected.text = "???"
		$HBoxContainer/CoinsAvailable.text = "???"

func setControllerSupport(connected):
	controllerConnected = connected

func setGalleryScreenAudio():
	gameAudioPlayer.setTrackFile("AUDIOPLAYER2", galleryMusic)
	gameAudioPlayer.stopStream("AUDIOPLAYER2")
	gameAudioPlayer.stopStream("AUDIOPLAYER3")
	gameAudioPlayer.chooseAudioPlayer("AUDIOPLAYER1", "AUDIOPLAYER2")
	gameAudioPlayer.setTransition(1, 0)

func setTitleScreenAudio():
	gameAudioPlayer.setTrackFile("AUDIOPLAYER1", mainMenuTheme)
	gameAudioPlayer.chooseAudioPlayer("AUDIOPLAYER2", "AUDIOPLAYER1")
	gameAudioPlayer.setTransition(1, 0)

func _on_ButtonBack_button_up():
	var calledByString = str(calledBy).get_slice(":", 0)
	gameScene.showUIScene("AchievementGalleryUI", false, self)
	gameScene.showUIScene(calledByString, true, self)

func _on_AchievementGalleryUI_visibility_changed():
	galleryRect.set_current_frame(0)
	loadCoinData()
	checkPictureLocked()
	if self.visible == true:
		gameAudioPlayer = gameScene.getAudioPlayer()
		setGalleryScreenAudio()
		if controllerConnected == true:
			$ButtonBack.grab_focus()
	else: setTitleScreenAudio()

