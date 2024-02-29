extends Control

var gameScene
var calledBy
var uiScene
var controllerConnected

var resolutionPopup
var windowPopup
var msaaPopup
var anisotropicPopup
var currentFXAA
var currentMSAA
var currentVSync
var currentWindowMode
var currentResolution
var currentAnisotropic
var currentWidth
var currentHeight
var chosenWindowMode
var chosenResolution
var chosenWidth
var chosenHeight
var chosenMSAA
var chosenAnisotropic
var chosenVSync
var chosenFXAA

func _ready():
	uiScene = get_parent()
	getPopups()
	loadVideoSettings()
	getSettings()
	setSettingsInButtons()

func getPopups():
	resolutionPopup = $ScrollContainer/VBoxContainer/HBoxContainer2/ResolutionMenu.get_popup()
	windowPopup = $ScrollContainer/VBoxContainer/HBoxContainer/WindowMenu.get_popup()
	msaaPopup = $ScrollContainer/VBoxContainer/HBoxContainer4/MSAAButton.get_popup()
	anisotropicPopup = $ScrollContainer/VBoxContainer/HBoxContainer3/AnisotropicMenu.get_popup()

func loadVideoSettings():
	var loadedSettingsDictionary = uiScene.loadSettings()
	if uiScene.loadSettings() == null:
		setDefault()
	elif loadedSettingsDictionary.has("ResolutionWidth") == true:
		if !loadedSettingsDictionary["ResolutionWidth"] == null:
			chosenResolution = loadedSettingsDictionary["Resolution"]
			chosenWidth = loadedSettingsDictionary["ResolutionWidth"]
			chosenHeight = loadedSettingsDictionary["ResolutionHeight"]
			chosenWindowMode = loadedSettingsDictionary["WindowMode"]
			chosenAnisotropic = loadedSettingsDictionary["Anisotrophic"]
			chosenFXAA = loadedSettingsDictionary["FXAA"]
			chosenMSAA = loadedSettingsDictionary["MSAA"]
			chosenVSync = loadedSettingsDictionary["VSync"]
			setSettings()
		else: setDefault()
	else: setDefault()

func setDefault():
	getSettings()
	saveSettings()

func setSettingsInButtons():
	setResolutionInButton(currentResolution)
	setWindowInButton(currentWindowMode)
	setMSAAInButton(currentMSAA)
	setFXAAInButton(currentFXAA)
	setAnisotropicInButton(currentAnisotropic)
	setVSyncInButton(currentVSync)

func setResolutionInButton(resolution):
	$ScrollContainer/VBoxContainer/HBoxContainer2/ResolutionMenu.text = resolution

func setWindowInButton(windowMode):
	$ScrollContainer/VBoxContainer/HBoxContainer/WindowMenu.text = windowMode

func setMSAAInButton(msaaMode):
	var msaaLabel = $ScrollContainer/VBoxContainer/HBoxContainer4/MSAAButton
	if msaaMode == 0:
		msaaLabel.text = "Disabled"
	else: msaaLabel.text = msaaPopup.get_item_text(msaaMode)

func setFXAAInButton(fxaaMode):
	$ScrollContainer/VBoxContainer/HBoxContainer5/FXAACheck.pressed = fxaaMode

func setAnisotropicInButton(anisotropicMode):
	$ScrollContainer/VBoxContainer/HBoxContainer3/AnisotropicMenu.text = str(anisotropicMode)

func setVSyncInButton(vMode):
	$ScrollContainer/VBoxContainer/HBoxContainer6/VSyncCheck.pressed = vMode

func getSettings():
	currentWidth = OS.get_window_size()[0]
	currentHeight = OS.get_window_size()[1]
	currentResolution = str(currentWidth, "x", currentHeight)
	if OS.is_window_fullscreen() == true:
		currentWindowMode = "Fullscreen"
	else:
		if OS.get_borderless_window() == true:
			currentWindowMode = "Borderless"
		else:
			currentWindowMode = "Windowed"
	currentFXAA = get_viewport().get_use_fxaa()
	currentAnisotropic = ProjectSettings.get_setting("rendering/quality/filters/anisotropic_filter_level")
	currentMSAA = get_viewport().get_msaa()
	currentVSync = OS.is_vsync_enabled()


func hideAll(boolValue):
	self.visible = !boolValue

func changeResolution(id):
	chosenResolution = resolutionPopup.get_item_text(id)
	chosenWidth = int(chosenResolution.split("x")[0])
	chosenHeight = int(chosenResolution.split("x")[1])
	setResolutionInButton(chosenResolution)

func changeWindowMode(id):
	chosenWindowMode = windowPopup.get_item_text(id)
	setWindowInButton(chosenWindowMode)

func changeMSAA(id):
	chosenMSAA = id
	setMSAAInButton(id)

func changeAnisotropic(id):
	chosenAnisotropic = anisotropicPopup.get_item_text(id)
	setAnisotropicInButton(chosenAnisotropic)

func setSettings():
	if !chosenResolution == null:
		OS.set_window_size(Vector2(chosenWidth,chosenHeight))
	if !chosenWindowMode == null:
		if chosenWindowMode == "Borderless":
			OS.set_window_fullscreen(false)
			OS.set_borderless_window(true)
		if chosenWindowMode == "Windowed":
			OS.set_window_fullscreen(false)
			OS.set_borderless_window(false)
		if chosenWindowMode == "Fullscreen":
			OS.set_window_fullscreen(true)
	if !chosenAnisotropic == null:
		ProjectSettings.set_setting("rendering/quality/filters/anisotropic_filter_level", chosenAnisotropic)
	if !chosenFXAA == null:
		get_viewport().set_use_fxaa(chosenFXAA)
	if !chosenMSAA == null:
		get_viewport().set_msaa(chosenMSAA)
	if !chosenVSync == null:
		OS.set_use_vsync(chosenVSync)

func saveSettings():
	uiScene.setSettings("Resolution", chosenResolution)
	uiScene.setSettings("ResolutionWidth", chosenWidth)
	uiScene.setSettings("ResolutionHeight", chosenHeight)
	uiScene.setSettings("WindowMode", chosenWindowMode)
	uiScene.setSettings("Anisotrophic", chosenAnisotropic)
	uiScene.setSettings("FXAA", chosenFXAA)
	uiScene.setSettings("MSAA", chosenMSAA)
	uiScene.setSettings("VSync", chosenVSync)

func setControllerSupport(connected):
	controllerConnected = connected

func _on_ButtonBack_button_up():
	var calledByString = str(calledBy).get_slice(":", 0)
	gameScene.showUIScene("VideoSettingsMenu", false, self)
	gameScene.showUIScene(calledByString, true, null)
	getSettings()
	setSettingsInButtons()

func _on_Confirm_button_up():
	setSettings()
	saveSettings()

func _on_ResolutionMenu_button_up():
	resolutionPopup.connect("id_pressed", self, "changeResolution")

func _on_WindowMenu_button_up():
	windowPopup.connect("id_pressed", self, "changeWindowMode")

func _on_MSAAButton_button_up():
	msaaPopup.connect("id_pressed", self, "changeMSAA")

func _on_AnisotropicMenu_button_up():
	anisotropicPopup.connect("id_pressed", self, "changeAnisotropic")

func _on_FXAACheck_toggled(button_pressed):
	chosenFXAA = $ScrollContainer/VBoxContainer/HBoxContainer5/FXAACheck.pressed

func _on_VSyncCheck_toggled(button_pressed):
	chosenVSync = $ScrollContainer/VBoxContainer/HBoxContainer6/VSyncCheck.pressed

func _on_VideoSettingsMenu_visibility_changed():
	if controllerConnected == true:
		$HBoxContainer/ButtonBack.grab_focus()
