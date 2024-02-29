tool
extends Spatial

export (bool) var isStoppingCam setget stopCameraSet


func stopCameraSet(boolValue):
	if boolValue == true:
		$StaticBody.set_collision_layer_bit(9, true)
		isStoppingCam = true
	elif boolValue == false:
		isStoppingCam = false
	if Engine.editor_hint and boolValue == true:
		var newMaterial = SpatialMaterial.new()
		newMaterial.albedo_color = Color("#0e1dd0")
		$MeshInstance.material_override = newMaterial
	elif Engine.editor_hint and boolValue == false:
		$MeshInstance.material_override = null
