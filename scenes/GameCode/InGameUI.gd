extends Control

var gameScene
var calledBy

func _ready():
	$CenterContainer/GravityUI.frame = 0


func setGravityCharges(gravityCharges):
	$CenterContainer/GravityUI.frame = gravityCharges

func setHP(HP):
	if HP == 3:
		$CenterContainer/Heart1.frame = 1
		$CenterContainer/Heart2.frame = 1
		$CenterContainer/Heart3.frame = 1
	if HP == 2:
		$CenterContainer/Heart1.frame = 1
		$CenterContainer/Heart2.frame = 1
		$CenterContainer/Heart3.frame = 0
	if HP == 1:
		$CenterContainer/Heart1.frame = 1
		$CenterContainer/Heart2.frame = 0
		$CenterContainer/Heart3.frame = 0
	if HP <= 0:
		$CenterContainer/Heart1.frame = 0
		$CenterContainer/Heart2.frame = 0
		$CenterContainer/Heart3.frame = 0

func setGravityStaff(hasStaff):
	$CenterContainer/gravityStaff.visible = hasStaff

func setCoins(value):
	$Coins.text = str(value)

func showUI(boolValue):
	if boolValue == false:
		$AnimationPlayer.play("FadeInUI")
	else: $AnimationPlayer.play("FadeOutUI")
