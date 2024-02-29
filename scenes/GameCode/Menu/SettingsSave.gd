extends CanvasLayer

var settingsDictionary = {}
var loadedSettingsDictionary = {}

func setSettings(settingsString, value):
	settingsDictionary[settingsString] = value
	saveSettingsInFile()

func saveSettingsInFile():
	settingsDictionary.merge(loadedSettingsDictionary, false)
	var dictionaryAsString = JSON.print(settingsDictionary)
	var file = File.new()
	file.open("user://settings.sav", File.WRITE)
	file.store_line(dictionaryAsString)
	file.close()

func loadSettings():
	var file = File.new()
	if file.file_exists("user://settings.sav"):
		file.open("user://settings.sav", File.READ)
		loadedSettingsDictionary = JSON.parse(file.get_as_text()).result
		return loadedSettingsDictionary
	else: return null
