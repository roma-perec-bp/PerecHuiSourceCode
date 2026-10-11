extends Node

#SETTINGS
var fullScreen = true
var vsync = false
var lights = true

var mouseSense = 200

var music_volume = 0
var sfx_volume = 0

var backFromLevel:bool = false
var progress:int = 0
var lvl1:int = 0
var lvl2:int = 0
var lvl3:int = 0
var initialized:bool = false

var saveData = "user://save.dat"
var accessTo = "user://unlock.dat"

func _ready():
	load_save()
	reload_all_setting()
	
func reload_setting(doThis:int):
	check(doThis)
	
func reload_all_setting():
	check(5)
			
func give_access():
	var file = FileAccess.open(accessTo, FileAccess.WRITE)
	var save_file = important()
	file.store_var(save_file)

func save_data():
	var file = FileAccess.open(saveData, FileAccess.WRITE)
	var save_file = createData()
	file.store_var(save_file)
	
func load_save():
	var file = FileAccess.open(saveData, FileAccess.READ)
	if FileAccess.file_exists(saveData):
		var loaded_save = file.get_var()
		#SETTINGS
		fullScreen = loaded_save.FullScreen
		vsync = loaded_save.Vsync
		lights = loaded_save.FlashingLights
		
		mouseSense = loaded_save.MouseSense
		
		music_volume = loaded_save.MusicVolume
		sfx_volume = loaded_save.SoundVolume
		
		#LVL
		progress = loaded_save.progress
		lvl1 = loaded_save.lvl1
		lvl2 = loaded_save.lvl2
		lvl3 = loaded_save.lvl3

func createData():
	var data = {
		#SETTINGS
		"FullScreen": fullScreen,
		"Vsync": vsync,
		"FlashingLights": lights,
		
		"MouseSense": mouseSense,
		
		"MusicVolume": music_volume,
		"SoundVolume": sfx_volume,
		#LVL
		"progress": progress,
		"lvl1": lvl1,
		"lvl2": lvl2,
		"lvl3": lvl3,
	}
	return data

func check(doThis): #CHECKS FOR APPLYING SETTINGS OR BOOTING GAME
	match doThis:
		0: #FULL SCREEN CHECK
			if fullScreen == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: #VSYNC CHECK
			if vsync == true:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		2: #MUSIC VOLUME
			AudioServer.set_bus_volume_db(1, music_volume)
			
			if music_volume > -24:
				AudioServer.set_bus_mute(1, false)
			else:
				AudioServer.set_bus_mute(1, true)
				
		3: #SFX VOLUME
			AudioServer.set_bus_volume_db(2, sfx_volume)
			
			if sfx_volume > -24:
				AudioServer.set_bus_mute(2, false)
			else:
				AudioServer.set_bus_mute(2, true)
		5: #LAST ALWAYS CHECKS EVERYTHING
			AudioServer.set_bus_volume_db(1, music_volume)
			AudioServer.set_bus_volume_db(2, sfx_volume)
			if fullScreen == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				
			if vsync == true:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func important():
	var data = {
		"KateWTF": true,
		"ROMA PEREC": true,
		"Person Num 1": true,
		"Person Num 2": true,
		"Person Num 3": true,
		"Person Num 4": true,
		"Person Num 5": true,
		"Person Num 6": true,
		"Person Num 7": true,
		"Person Num 8": true,
		"Person Num 9": true,
		"Person Num 10": true,
		"Person Num 11": true,
		"Person Num 12": true,
		"Person Num 13": true,
		"Person Num 14": true,
		"Person Num 15": true,
		"Person Num 16": true,
		"Person Num 17": true,
		"Person Num 18": true,
		"Person Num 19": true,
		"Person Num 20": true,
		"Person Num 21": true,
		"Person Num 22": true,
		"Person Num 23": true,
		"Person Num 24": true,
		"Person Num 25": true,
		"Person Num 26": true,
		"Person Num 27": true,
		"Person Num 28": true,
		"Person Num 29": true,
		"Person Num 30": true,
		"Person Num 31": true,
		"Person Num 32": true,
		"Person Num 33": true,
		"Person Num 34": true,
		"Person Num 35": true,
		"Person Num 36": true,
		"Person Num 37": true,
		"Person Num 38": true,
		"Person Num 39": true,
		"Person Num 40": true,
		"Person Num 41": true,
		"Person Num 42": true,
	}
	return data
