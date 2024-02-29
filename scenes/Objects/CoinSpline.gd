extends Spatial

export (PackedScene) var coinItem
export (float) var distance = 2

var currentScene

func _process(delta):
	if $Path/PathFollow.unit_offset < 1:
		spawnCoinItem()
		$Path/PathFollow.offset += distance

func spawnCoinItem():
	var coin = coinItem.instance()
	coin.translation = $Path/PathFollow.global_translation
	currentScene.add_child(coin)

func setCurrentScene(currentScenePath):
	currentScene = currentScenePath
