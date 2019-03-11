extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var vel = Vector2(-252.568222, -161.8928222)
	var fri = 0.75
	vel *= fri
	print(vel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
