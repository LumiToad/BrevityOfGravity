extends Spatial

export (bool) var overrideLerpSpeedX = false
export (float) var lerpSpeedX = 0.05
export (bool) var overrideLerpSpeedY = false
export (float) var lerpSpeedY = 0.05
export (bool) var overrideBorderRangeX = false
export (float) var borderRangeX = 1
export (bool) var overrideBorderRangeY = false
export (float) var borderRangeY = 1
export (bool) var isZoom = false
export (float) var zPos = 50
export (float) var lerpSpeedZ = 0.05
export (bool) var isStaticCamera = false
export (bool) var stopLookAhead = false
export (bool) var resetCamera = true


func _on_Area_body_entered(body):
	var camera = get_tree().get_root().get_camera()
	if overrideLerpSpeedX:
		camera.overrideLerpSpeedX(lerpSpeedX)
	if overrideLerpSpeedY:
		camera.overrideLerpSpeedY(lerpSpeedY)
	if overrideBorderRangeX:
		camera.overrideBorderRangeX(borderRangeX)
	if overrideBorderRangeY:
		camera.overrideBorderRangeY(borderRangeY)
	if isZoom:
		camera.zoom(zPos, lerpSpeedZ)
	if isStaticCamera:
		camera.staticCam(global_translation)
	if stopLookAhead:
		camera.stopLookAhead()

func _on_Area_body_exited(body):
	var camera = get_tree().get_root().get_camera()
	if !camera == null:
		if resetCamera:
			camera.resetCameraSettings()
	

