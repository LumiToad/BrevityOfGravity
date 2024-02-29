extends TextureButton

#when QuitButton is being pressed
func _on_QuitButton_pressed():
	#plays quit sound
	$ButtonSound.play()
	#yield command waits for 1.0 second
	yield(get_tree().create_timer(1.0), "timeout")
	#closes the game
	get_tree().quit()


func _on_QuitButton_mouse_entered():
	$HoverSound.play()




#func _on_PlayButton_mouse_entered():
#	$HoverSound.play()

