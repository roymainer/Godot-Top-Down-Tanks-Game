extends "res://tanks/Tank.gd"

onready var parent = get_parent()

export (float) var turret_speed
export (int) var detect_radius  # allow different view range to different tanks

var speed = 0
var target = null

func _ready():
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius  # set the radius to set value (set in inspector)

func control(delta):
	if parent is PathFollow2D:
		if $LookAhead1.is_colliding() or $LookAhead2.is_colliding():
			# if there is something in fron of our tank
			speed = lerp(speed, 0, 0.1)  # linear decrease in speed to 0
		elif max_speed != null:
			speed = lerp(speed, max_speed, 0.05)  # increase speed to max (but slower)
		parent.set_offset(parent.get_offset() + speed * delta)
		position = Vector2()
	else:
        # other movement code
        pass

func _process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()  # get target position normalized to enemy tank position
		var current_dir = Vector2(1,0).rotated($Turret.global_rotation)  # current turret direction (a rotated unit vector)
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
		if target_dir.dot(current_dir) > 0.9:
			shoot(gun_shots, gun_spread, target)

func _on_DetectRadius_body_entered(body):
#	if body.name == "Player":
#		target = body
	target = body  # detect collision radius is set to mask only player


func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null
