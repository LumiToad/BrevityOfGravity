extends Spatial


func _on_Area_body_entered(body):
	if body.has_method("hitByDeathZone"):
		body.hitByDeathZone()
		queue_free()
