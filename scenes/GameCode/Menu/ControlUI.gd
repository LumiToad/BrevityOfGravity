extends Control


var gameScene
var calledBy

func _on_ButtonBack_button_up():
	var calledByString = str(calledBy).get_slice(":", 0)
	gameScene.showUIScene("ControlUI", false, self)
	gameScene.showUIScene(calledByString, true, null)
