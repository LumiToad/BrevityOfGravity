extends Control

var gameScene
var controllerConnected
var calledBy
var uiScene

var masterBus
var musicBus
var soundBus

var masterVolumeSlider
var musicVolumeSlider
var soundVolumeSlider

func _ready():
	uiScene = get_parent()
	getVolumeSlider()
	getAudioBus()
	loadAudioSettings()
	

func loadAudioSettings():
	var loadedSettingsDictionary = uiScene.loadSettings()
	if uiScene.loadSettings() == null:
		setDefaultVolume()
		saveSettings()
	elif loadedSettingsDictionary.has("AudioMasterSlider"):
		if !loadedSettingsDictionary["AudioMasterSlider"] == null:
			masterVolumeSlider.set_value(loadedSettingsDictionary["AudioMasterSlider"])
			musicVolumeSlider.set_value(loadedSettingsDictionary["AudioMusicSlider"])
			soundVolumeSlider.set_value(loadedSettingsDictionary["AudioSoundSlider"])
	else:
		setDefaultVolume()
		saveSettings()


func setDefaultVolume():
	masterVolumeSlider.set_value(-20)
	musicVolumeSlider.set_value(-20)
	soundVolumeSlider.set_value(5)

func saveSettings():
	uiScene.setSettings("AudioMasterSlider", masterVolumeSlider.get_value())
	uiScene.setSettings("AudioMusicSlider", musicVolumeSlider.get_value())
	uiScene.setSettings("AudioSoundSlider", soundVolumeSlider.get_value())

func getAudioBus():
	masterBus = AudioServer.get_bus_index("Master")
	musicBus = AudioServer.get_bus_index("Music")
	soundBus = AudioServer.get_bus_index("Sound")

func getVolumeSlider():
	masterVolumeSlider = $HBoxContainer/VBoxSlider/MasterSlider
	musicVolumeSlider = $HBoxContainer/VBoxSlider/MusicSlider
	soundVolumeSlider = $HBoxContainer/VBoxSlider/SoundSlider

func setControllerSupport(connected):
	controllerConnected = connected

func _on_MasterSlider_value_changed(value):
	AudioServer.set_bus_volume_db(masterBus, value)
	if value == -60:
		AudioServer.set_bus_mute(masterBus, true)
	else: AudioServer.set_bus_mute(masterBus, false)
	saveSettings()
	

func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(musicBus, value)
	if value == -60:
		AudioServer.set_bus_mute(musicBus, true)
	else: AudioServer.set_bus_mute(musicBus, false)
	saveSettings()

func _on_SoundSlider_value_changed(value):
	AudioServer.set_bus_volume_db(soundBus, value)
	if value == -60:
		AudioServer.set_bus_mute(soundBus, true)
	else: AudioServer.set_bus_mute(soundBus, false)
	saveSettings()

func _on_SoundSlider_drag_ended(value_changed):
	if $AudioStreamPlayer.is_playing() == false:
		$AudioStreamPlayer.play()

func _on_ButtonBack_button_up():
	var calledByString = str(calledBy).get_slice(":", 0)
	gameScene.showUIScene("AudioSettingsMenu", false, self)
	gameScene.showUIScene(calledByString, true, null)

func _on_AudioSettingsMenu_visibility_changed():
	if controllerConnected == true:
		masterVolumeSlider.grab_focus()
