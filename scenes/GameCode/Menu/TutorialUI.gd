extends Control

var gameScene
var calledBy
var controllerConnected = false

func playTutorialAnimation(animationName):
	if controllerConnected == false:
		if animationName == "MovementLeftRight":
			$AnimationPlayer.play("KeyboardArrows")
		if animationName == "JumpLong":
			$AnimationPlayer.play("KeyboardSpaceLong")
		if animationName == "JumpShort":
			$AnimationPlayer.play("KeyboardSpaceShort")
		if animationName == "GravityChange":
			$AnimationPlayer.play("MouseGravityChange")
		if animationName == "GravityStaff":
			$AnimationPlayer.play("MouseStaffAim")
	if controllerConnected == true:
		if animationName == "MovementLeftRight":
			$AnimationPlayer.play("DPADJoyAxisLR")
		if animationName == "JumpLong":
			$AnimationPlayer.play("AButtonLong")
		if animationName == "JumpShort":
			$AnimationPlayer.play("AButtonShort")
		if animationName == "GravityChange":
			$AnimationPlayer.play("L1L2")
		if animationName == "GravityStaff":
			$AnimationPlayer.play("R1R2+R3")
	

func stopTutorialAnimation():
	for child in $CenterContainer/Control.get_children():
		child.visible = false
	$AnimationPlayer.stop(true)

func setControllerSupport(connected):
	controllerConnected = connected
