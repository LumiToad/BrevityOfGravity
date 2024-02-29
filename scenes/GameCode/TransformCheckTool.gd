tool
extends Spatial



func _ready():
	checkTransform(get_parent())


func checkTransform(node):
	if Engine.editor_hint:
		for child in node.get_children():
			if str(child.translation.x).ends_with(".25") or str(child.translation.x).ends_with(".5") or str(child.translation.x).ends_with(".75"):
				pass
			else:
				if child.translation.x % 2 == 0:
					child.rotation_degrees.y = -45
			if str(child.translation.y).ends_with(".25") or str(child.translation.y).ends_with(".5") or str(child.translation.y).ends_with(".75"):
				pass
			else:
				if child.translation.y % 2 == 0:
					child.rotation_degrees.y = -45
			checkTransform(child)
