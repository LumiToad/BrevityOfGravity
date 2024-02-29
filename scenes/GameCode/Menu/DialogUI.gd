extends Control

var gameScene
var calledBy


func setText(string):
	if $Label.text == "":
		$AnimationPlayer.play("fadeIn")
		$Label.text = string

func hideText():
	$AnimationPlayer.play("fadeOut")

func _on_DialogUI_visibility_changed():
	if visible == false:
		$Label.text = ""
