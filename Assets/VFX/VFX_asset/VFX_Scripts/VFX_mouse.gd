extends Node2D

var gameScene
var calledBy

func _physics_process(delta):
	position = get_global_mouse_position()

