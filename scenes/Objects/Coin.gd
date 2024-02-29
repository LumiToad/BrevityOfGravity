extends Spatial

var collected = false

func _on_Area_body_entered(body):
	if body.has_method("coinCollected"):
		body.coinCollected()
		collected = true
		$MeshInstance.queue_free()
		$Area.queue_free()
		$OrbPickup.play()
		$VFX_Coin_01.emitParticles(false)

func _on_OrbPickup_finished():
	for child in get_children():
		child.queue_free()
