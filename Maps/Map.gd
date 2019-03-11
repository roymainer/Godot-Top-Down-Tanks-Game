extends Node2D

func _ready():
	set_camera_limits()
	Input.set_custom_mouse_cursor(load("res://assets/UI/crossair_black.png"), Input.CURSOR_ARROW, 
	Vector2(16, 16))  # set pointer position to the middle of the cursor sprite (32, 32)
	$Player.map = $Ground
	
func set_camera_limits():
	var map_limits = $Ground.get_used_rect()  # get the size of the used map
	var map_cellsize = $Ground.cell_size  # get the cell size
	$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
	
func _on_Tank_shoot(bullet, _position, _direction, _target=null):
	var b = bullet.instance()
	add_child(b)  # the bullet is added to the map
	b.start(_position, _direction, _target)  # start the bullet
	
func _on_Player_dead():
#	print("Player is dead, reloading scene")
#	get_tree().reload_current_scene()  # if the player dies, reload the current scene
	GLOBALS.restart()
