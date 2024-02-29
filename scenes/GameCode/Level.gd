extends Spatial

var gameScene

func _ready():
	$Player.setCamera($Camera)
	$Camera.target = $Player
	
	
func setGame(gamePath):
	gameScene = gamePath
	gameScene.setLevelName(self.name)

func setPauseMode(mode):
	pause_mode = mode
