extends Spatial

#on touch...
func _on_Area_body_entered(body):
	#with the player
	if body.has_method("hitBySpikes"):
		body.hitBySpikes()
