extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime = 0.5
export (float) var steer_force = 0  # missile agility

var velocity = Vector2()
var acceleration = Vector2()  # missile acceleration
var target = null  # missile target


func start(_position, _direction, _target=null):
	# when the bullet is created, it needs to position itself at the tip of the muzzle
	# facing the same direction and it's velocity must have the same direction
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime  # update the timers lifetime
	$Lifetime.start()
	velocity = _direction * speed
	target = _target
	
func seek():
	# directional steering
	if position == null:
		return
	var desired_direction = (target.position - position).normalized() * speed
	var steer = (desired_direction - velocity).normalized() * steer_force
	return steer

func _process(delta):
	if target:
		# if the missile has a target
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)  # limit the speed
		rotation = velocity.angle()
	position += velocity * delta

func explode():
	velocity = Vector2(0,0)  # stop the bullet from moving
	$Sprite.hide()  # hide the bullet
	$Explosion.show()
	$Explosion.play('smoke')  # show smoke explosion animation

func _on_Bullet_body_entered(body):
	explode()
	if body.has_method('take_damage'):
		# if it hit a body that takes damage
		body.take_damage(damage)

func _on_Lifetime_timeout():
	# delete the bullet
	explode()


func _on_Explosion_animation_finished():
	queue_free()  # after explosion animation finishes, destroy the bullet
