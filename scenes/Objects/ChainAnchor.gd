extends Spatial

enum chainDirectionEnum{
	DOWN,
	UP
}

export (PackedScene) var loopScene
export (PackedScene) var linkScene
export (PackedScene) var attachedObject
export (bool) var isBowl = false
export (bool) var isStartGravityFlipped = false
export (int) var numberOfLoops = 5
export (chainDirectionEnum) var chainDirection

var chainDistance = -0.9

func _ready():
	if chainDirection == 1:
		chainDistance *= -1
	#sets StaticAnchor as var "parent"
	var parent = get_child(0)
	#do this "numberOfLoops" times
	for i in range (numberOfLoops):
		var isRotateLoop = false
		#rotates every second loop instance
		if i % 2 == 0: isRotateLoop = true
		else: isRotateLoop = false
		#calls addLoop with var "parent" as argument, return becomes var "child"
		var child = addLoop(parent, isRotateLoop, i)
		#calls addLink with var "parent", var "child" and "i" as argument
		addLink(parent, child, false)
		#var "parent" gets changed to what is currently in var "child"
		parent = child
		
	if attachedObject != null:
		var child = addAttachment(parent)
		addLink(parent, child, true)

func addLoop(parent, isRotateLoop, i):
	return addInstance(parent, loopScene, isRotateLoop, false, i)

func addAttachment(parent):
	return addInstance(parent, attachedObject, null, true, null)

func addInstance(parent, template, isRotateLoop, isAttachement, i):
	var instance = template.instance()
	instance.translation = parent.translation
	if isAttachement and !isBowl:
		chainDistance = -0.7
		instance.translation.y += chainDistance
	elif isAttachement and isBowl:
		chainDistance = -6.15
		instance.translation.y += chainDistance
	else:
		instance.translation.y += chainDistance
	if isRotateLoop and isRotateLoop != null:
		instance.rotation_degrees.y += 90
	if instance.has_method("setPreviousChainLink"):
		instance.setPreviousChainLink(parent)
	if instance.has_method("initialGravityFlip") and isStartGravityFlipped and isAttachement:
		instance.initialGravityFlip()
	add_child(instance)
	return instance

func addLink(parent, child, isAttachment):
	#var "pin" is instance of linkScene
	var pin = linkScene.instance()
	#config joint a as var "parent"
	pin.set_node_a(parent.get_path())
	#config joint b as var "child"
	pin.set_node_b(child.get_path())
	#spawns pin as child of var parent
	if isAttachment:
		pin.set("collision/exclude_nodes", true)
		pin.set("swing_span", 20)
		pin.set("twist_span", 20)
		pin.set("softness", 1)
	parent.add_child(pin)
	
	#get translation between parent and child
	#1. iteration anchor and loop, 2. iteration and above both are loop
	#final iteration is loop and attachment
	pin.global_translation = (parent.global_translation + child.global_translation) * 0.5
