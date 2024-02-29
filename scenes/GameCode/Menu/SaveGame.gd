extends Node

var saveDictionary = {}
var loadedSaveDictionary = {}

func setSaveData(dataString, value):
	saveDictionary[dataString] = value
	saveDataInFile()

func saveDataInFile():
	var dictionaryAsString = JSON.print(saveDictionary)
	var file = File.new()
	file.open("user://save.sav", File.WRITE)
	file.store_line(dictionaryAsString)
	file.close()

func loadData():
	var file = File.new()
	if file.file_exists("user://save.sav"):
		file.open("user://save.sav", File.READ)
		loadedSaveDictionary = JSON.parse(file.get_as_text()).result
		return loadedSaveDictionary
	else: return null
