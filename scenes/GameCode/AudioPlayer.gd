extends Node

export (String, FILE) var audioTrack1
export (String, FILE) var audioTrack2
export (String, FILE) var audioTrack3

var audioPlayer1
var audioPlayer2
var audioPlayer3

var chosenAudioPlayer1 = null
var chosenAudioPlayer2 = null

func _ready():
	setAudioPlayers()

func setAudioPlayers():
	audioPlayer1 = $AudioStreamPlayer1
	audioPlayer2 = $AudioStreamPlayer2
	audioPlayer3 = $AudioStreamPlayer3

func setStreams():
	audioPlayer1.set_stream(load(audioTrack1))
	audioPlayer2.set_stream(load(audioTrack2))
	audioPlayer3.set_stream(load(audioTrack3))

func setTrackFile(player, fileString):
	if player == "AUDIOPLAYER1":
		audioTrack1 = fileString
		audioPlayer1.set_stream(load(audioTrack1))
	if player == "AUDIOPLAYER2":
		audioTrack2 = fileString
		audioPlayer2.set_stream(load(audioTrack2))
	if player == "AUDIOPLAYER3":
		audioTrack3 = fileString
		audioPlayer3.set_stream(load(audioTrack3))

func chooseAudioPlayer(player1, player2):
	if player1 == "AUDIOPLAYER1":
		chosenAudioPlayer1 = audioPlayer1
	elif player1 == "AUDIOPLAYER2":
		chosenAudioPlayer1 = audioPlayer2
	elif player1 == "AUDIOPLAYER3":
		chosenAudioPlayer1 = audioPlayer3
	
	if player2 == "AUDIOPLAYER1":
		chosenAudioPlayer2 = audioPlayer1
	elif player2 == "AUDIOPLAYER2":
		chosenAudioPlayer2 = audioPlayer2
	elif player2 == "AUDIOPLAYER3":
		chosenAudioPlayer2 = audioPlayer3

func setTransition(duration, delay):
	if !chosenAudioPlayer1 == null:
		$Tween.interpolate_property(chosenAudioPlayer1, "volume_db", 0, -80, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT, delay)
	if !chosenAudioPlayer2 == null:
		chosenAudioPlayer2.set_volume_db(-80)
		chosenAudioPlayer2.play(0.0)
		$Tween.interpolate_property(chosenAudioPlayer2, "volume_db", -80, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT, delay)
	$Tween.start()

func setVolume(volume, player):
	if player == "AUDIOPLAYER1":
		audioPlayer1.set_volume_db(volume)
	if player == "AUDIOPLAYER2":
		audioPlayer2.set_volume_db(volume)
	if player == "AUDIOPLAYER3":
		audioPlayer3.set_volume_db(volume)

func resetVolume(player):
	if player == "AUDIOPLAYER1":
		audioPlayer1.set_volume_db(0)
	if player == "AUDIOPLAYER2":
		audioPlayer2.set_volume_db(0)
	if player == "AUDIOPLAYER3":
		audioPlayer3.set_volume_db(0)

func playStream(player):
	if player == "AUDIOPLAYER1":
		audioPlayer1.play(0.0)
	if player == "AUDIOPLAYER2":
		audioPlayer2.play(0.0)
	if player == "AUDIOPLAYER3":
		audioPlayer3.play(0.0)

func stopStream(stream):
	if stream == "AUDIOPLAYER1":
		audioPlayer1.stop()
	if stream == "AUDIOPLAYER2":
		audioPlayer2.stop()
	if stream == "AUDIOPLAYER3":
		audioPlayer3.stop()

func checkPlaying():
	if audioPlayer1.is_playing() == true:
		return true
	if audioPlayer2.is_playing() == true:
		return true
	if audioPlayer3.is_playing() == true:
		return true

func _on_Tween_tween_completed(object, key):
	if !chosenAudioPlayer1 == null:
		if chosenAudioPlayer1.get_volume_db() <= -50:
			chosenAudioPlayer1.stop()
			chosenAudioPlayer1.set_volume_db(0)
