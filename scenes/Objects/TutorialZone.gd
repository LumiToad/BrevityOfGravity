extends Spatial

enum tutorialEnum {
	MovementLeftRight,
	JumpLong,
	JumpShort,
	GravityChange,
	GravityStaff
}

export (tutorialEnum) var tutorial

var gameScene

func setGame(gamePath):
	gameScene = gamePath

func _on_Area_body_entered(body):
	gameScene.setTutorial(tutorialEnum.keys()[tutorial])

func _on_Area_body_exited(body):
	gameScene.closeTutorialUI()
