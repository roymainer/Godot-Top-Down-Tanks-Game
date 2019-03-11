extends Node

var slow_terrain = [0, 7, 8, 10, 17, 18, 20, 30]
var current_level = 0
var levels = ["res://UI/TitleScreen.tscn", "res://Maps/Map01.tscn"]

func restart():
	current_level = 0
	get_tree().change_scene(levels[current_level])
	
func next_level():
	current_level += 1
	if current_level < levels.size():
		get_tree().change_scene(levels[current_level])
	else:
		restart()