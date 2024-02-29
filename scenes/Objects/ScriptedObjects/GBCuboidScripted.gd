extends RigidBody

export (PackedScene) var gravityCuboidSceneTemplate

var currentScene

func activateBlock():
	var gravityCuboid = gravityCuboidSceneTemplate.instance()
	queue_free()
	gravityCuboid.global_translation = self.global_translation
	gravityCuboid.rotation_degrees.y -= 180
	currentScene.add_child(gravityCuboid)

func setCurrentScene(currentScenePath):
	currentScene = currentScenePath

func _on_GravityBlob_sequence():
	activateBlock()
