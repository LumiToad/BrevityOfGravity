extends Control

var gameScene
var calledBy
var controllerConnected

func setControllerSupport(connected):
	controllerConnected = connected

func _on_ButtonControls_button_up():
	gameScene.showUIScene("ControlUI", true, self)
	gameScene.showUIScene("SettingsMenu", false, null)

func _on_ButtonAudio_button_up():
	gameScene.showUIScene("AudioSettingsMenu", true, self)
	gameScene.showUIScene("SettingsMenu", false, null)

func _on_ButtonVideo_button_up():
	gameScene.showUIScene("VideoSettingsMenu", true, self)
	gameScene.showUIScene("SettingsMenu", false, null)

func _on_ButtonBack_pressed():
	var calledByString = str(calledBy).get_slice(":", 0)
	gameScene.showUIScene("SettingsMenu", false, null)
	gameScene.showUIScene(calledByString, true, self)

func _on_SettingsMenu_visibility_changed():
	if self.visible == true:
		if controllerConnected == true:
			$VBoxContainer/VBoxContainer/ButtonControls.grab_focus()
