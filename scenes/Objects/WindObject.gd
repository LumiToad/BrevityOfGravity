extends Spatial

enum directionEnum{
	RIGHT = 1
	LEFT = 2
}

const MINWINDSTRENGTH = 0

export (float) var maxWindStrength = 100
export (directionEnum) var direction = 0

var targetWindStrength = 0
var windfluencedArray = []

func _ready():
	memorizeWindfluenced(get_parent())

func memorizeWindfluenced(node):
	yield(get_tree().create_timer(0.5), "timeout")
	for child in node.get_children():
		if child.has_method("applyWindImpulse"):
			windfluencedArray.append(child)
		memorizeWindfluenced(child)

func callApplyWindImpulseInChildren(node):
	for i in range (0, windfluencedArray.size()):
		windfluencedArray[i].applyWindImpulse(targetWindStrength, directionEnum.keys()[direction])


func windStrengthRandomizer():
	randomize()
	targetWindStrength = rand_range(MINWINDSTRENGTH, maxWindStrength)

func _on_WindTimer_timeout():
	windStrengthRandomizer()
	callApplyWindImpulseInChildren(get_parent())
