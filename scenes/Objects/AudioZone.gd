extends Spatial

enum transitionPlayerEnum{
	OFF,
	AUDIOPLAYER1,
	AUDIOPLAYER2,
	AUDIOPLAYER3
}

export (bool) var isNotChanging
export (bool) var isTransition
export (transitionPlayerEnum) var fromAudioPlayer1
export (transitionPlayerEnum) var toAudioPlayer2
export (float) var duration
export (float) var delay
export (bool) var isVolumeChange
export (float) var volumeDbPlayer1
export (float) var volumeDbPlayer2
export (float) var volumeDbPlayer3
export (String, FILE) var audioPath1
export (String, FILE) var audioPath2
export (String, FILE) var audioPath3
export (bool) var startPlayer1
export (bool) var startPlayer2
export (bool) var startPlayer3
export (bool) var stopPlayer1
export (bool) var stopPlayer2
export (bool) var stopPlayer3
export (bool) var isDeletingSelf

var gameScene
var gameAudioPlayer

func _on_Area_body_entered(body):
	setChosenAudioPlayer()
	if isNotChanging == true:
		if gameAudioPlayer.checkPlaying() == null:
			checkAudioFeature()
		else: pass
	else:
		checkAudioFeature()
	if isDeletingSelf == true:
		queue_free()

func checkAudioFeature():
	changeFileInPlayer()
	
	if stopPlayer1 == true:
		audioStop("AUDIOPLAYER1")
	if stopPlayer2 == true:
		audioStop("AUDIOPLAYER2")
	if stopPlayer3 == true:
		audioStop("AUDIOPLAYER3")
	
	if startPlayer1 == true:
		audioPlay("AUDIOPLAYER1")
	if startPlayer2 == true:
		audioPlay("AUDIOPLAYER2")
	if startPlayer3 == true:
		audioPlay("AUDIOPLAYER3")
	
	if isTransition == true:
		audioTransition()
	if isVolumeChange == true:
		audioVolume()

func changeFileInPlayer():
	if !audioPath1 == "":
		gameAudioPlayer.setTrackFile("AUDIOPLAYER1", audioPath1)
	if !audioPath2 == "":
		gameAudioPlayer.setTrackFile("AUDIOPLAYER2", audioPath2)
	if !audioPath3 == "":
		gameAudioPlayer.setTrackFile("AUDIOPLAYER3", audioPath3)

func setChosenAudioPlayer():
	gameAudioPlayer.chooseAudioPlayer(transitionPlayerEnum.keys()[fromAudioPlayer1], transitionPlayerEnum.keys()[toAudioPlayer2])

func audioTransition():
	gameAudioPlayer.setTransition(duration, delay)

func audioVolume():
	if !volumeDbPlayer1 == null:
		gameAudioPlayer.setVolume(volumeDbPlayer1, "AUDIOPLAYER1")
	if !volumeDbPlayer2 == null:
		gameAudioPlayer.setVolume(volumeDbPlayer2, "AUDIOPLAYER2")
	if !volumeDbPlayer3 == null:
		gameAudioPlayer.setVolume(volumeDbPlayer2, "AUDIOPLAYER3")

func audioPlay(player):
	gameAudioPlayer.resetVolume(player)
	gameAudioPlayer.playStream(player)

func audioStop(player):
	gameAudioPlayer.stopStream(player)

func setGame(gamePath):
	gameScene = gamePath
	gameAudioPlayer = gameScene.getAudioPlayer()
