extends TextureButton

#loads the gameScene
var gameScene
export (PackedScene) var levelSceneTemplate

func _ready():
	pass

#if PlayButton is pressed
func _on_PlayButton_pressed():
	$ButtonSound2.play()
	gameScene.screenFade.fadeOut(1,0)
	yield(get_tree().create_timer(1), "timeout")
	gameScene.loadLevel(levelSceneTemplate)

func _on_PlayButton_mouse_entered():
	$HoverSound.play()

func setGame(gamePath):
	gameScene = gamePath
