extends Spatial

enum exitDirectionEnum{
	RIGHT,
	LEFT
}

export (PackedScene) var levelSceneTemplate
export (exitDirectionEnum) var exitDirection
export (bool) var isCheckPoint = false
export (SpatialMaterial) var activeStateMaterial
export (bool) var isFinalGoal = false

var gameScene
var player

var coinsInLevel = 0
var coinsCollected = 0

func _ready():
	if isCheckPoint == true:
		setOnState()


func setOnState():
	$Vfx_Orb_1.visible = true
	$GoalCore.set_surface_material(1, activeStateMaterial)
	$GoalTopLeft.set_surface_material(1, activeStateMaterial)
	$GoalTopRight.set_surface_material(1, activeStateMaterial)

func saveLevel():
	var levelName = gameScene.getLevelName()
	var loadedSaveDictionary = gameScene.loadGameData()
	if !loadedSaveDictionary == null:
		if loadedSaveDictionary.has(levelName + "#CoinsInLevel"):
			if !loadedSaveDictionary[levelName + "#CoinsInLevel"] == loadedSaveDictionary[levelName + "#CoinsCollected"]:
				saveData(levelName)
			else: pass
		else: saveData(levelName)
	else: saveData(levelName)

func saveData(levelName):
	gameScene.saveGameData("CurrentLevel", levelSceneTemplate.get_path())
	gameScene.saveGameData(levelName + "#CoinsInLevel", coinsInLevel)
	gameScene.saveGameData(levelName + "#CoinsCollected", coinsCollected)

func _on_Area_body_entered(body):
	if isFinalGoal == true:
		player = body
		countCoins()
		gameScene.saveGameData(gameScene.getLevelName() + "#CoinsInLevel", coinsInLevel)
		gameScene.saveGameData(gameScene.getLevelName() + "#CoinsCollected", coinsCollected)
		finalGoalCutscene()
	else:
		if isCheckPoint == false:
			if body.has_method("enablePlayerControls"):
				body.enablePlayerControls(false)
			if body.has_method("cutsceneControl"):
				body.cutsceneControl(exitDirectionEnum.keys()[exitDirection])
			if body.has_method("changeLevel"):
				countCoins()
				body.changeLevel(levelSceneTemplate)
				setOnState()
				$VFX_GravityCubeActivate.changeColor(false)
				$VFX_GravityCubeActivate.emitParticles()
				$Vfx_Orb_1.visible = true
				$GoalReachedSound.play()
				saveLevel()

func setGame(gamePath):
	gameScene = gamePath

func countCoins():
	coinsInLevel = get_tree().get_nodes_in_group("CoinGroup").size()
	for coin in get_tree().get_nodes_in_group("CoinGroup"):
		if coin.collected == true:
			coinsCollected += 1


func finalGoalCutscene():
	gameScene.showFadeInGameUI(true)
	gameScene.initScreenFade("fadeOut", 2, 11, self)
	if player.has_method("enablePlayerControls"):
		player.enablePlayerControls(false)
	$AnimationPlayer2.play("FinalGoalCutscene")

func cutsceneControlAnimation(boolValue):
	if boolValue == true:
		player.cutsceneControl("RIGHT")
	else: 
		player.move.x = 0
		player.playAnimationIdle()
	

func startFinalVideo():
	player.killWalkingAudio()
	gameScene.finalVideoPlay()

func onScreenFadeComplete(_node):
	pass
