extends Control

signal screenFadeComplete(calledBy)

var gameScene
var calledBy


func fadeIn(duration, idleTime):
	$ColorRect.color = Color(0,0,0,1)
	$Tween.interpolate_property($ColorRect, "color", Color(0,0,0,1), Color(0,0,0,0), duration, Tween.TRANS_LINEAR, Tween.EASE_IN, idleTime)
	$Tween.start()
	self.visible = true

func fadeOut(duration, idleTime):
	$ColorRect.color = Color(0,0,0,0)
	$Tween.interpolate_property($ColorRect, "color", Color(0,0,0,0), Color(0,0,0,1), duration, Tween.TRANS_LINEAR, Tween.EASE_IN, idleTime)
	$Tween.start()
	self.visible = true


func _on_Tween_tween_all_completed():
	if !is_connected("screenFadeComplete", calledBy, "onScreenFadeComplete"):
		connect("screenFadeComplete", calledBy, "onScreenFadeComplete")
	emit_signal("screenFadeComplete", calledBy)
