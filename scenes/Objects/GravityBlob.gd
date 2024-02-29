extends Spatial

signal sequence

#if in contact with something
func _on_Area_body_entered(body):
	if $Cooldown.is_stopped():
		if body.has_method("gravityFlip") and !body.has_method("gravityGunEnemy_Fire"):
			body.gravityFlip()
			emit_signal("sequence")
			$Cooldown.start()
