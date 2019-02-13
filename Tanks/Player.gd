extends "res://tanks/Tank.gd"

func control(delta):
#	print("Player.control")
	$Turret.look_at(get_global_mouse_position())
	var rot_dir = 0
	if Input.is_action_pressed('turn_right'):
		rot_dir += 1
	if Input.is_action_pressed('turn_left'):
		rot_dir -= 1
	rotation += rotation_speed * rot_dir * delta
	velocity = Vector2()
	if Input.is_action_pressed('forward'):
		velocity = Vector2(max_speed, 0).rotated(rotation)
	if Input.is_action_pressed('back'):
		velocity = Vector2(-max_speed/2, 0).rotated(rotation)
	if Input.is_action_just_pressed('mouse_click'):
		shoot(gun_shots, gun_spread)  # calls the parent class (Tank) shoot func