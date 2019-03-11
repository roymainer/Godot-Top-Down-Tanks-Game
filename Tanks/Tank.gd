extends KinematicBody2D

signal shoot
signal health_changed
signal ammo_changed
signal dead

export (PackedScene) var Bullet
export (int) var max_speed
export (float) var rotation_speed
export (float) var gun_cooldown
export (int) var max_health
export (int) var gun_shots = 1  # how many bullets we're gonna shoot
export (float) var gun_spread = 0.2  # how spread are the shots
export (int) var max_ammo = 20  # maximum shots available
export (int) var ammo = -1 setget set_ammo  # -1 is unlimited ammo (for enemies)
export (float) var offroad_friction 

var velocity = Vector2()
var can_shoot = true
var alive = true
var health
var map

func _ready():
	health = max_health
	$Smoke.emitting = false
	emit_signal('health_changed', health * 100 / max_health)  # will emit the health percentage 
	emit_signal("ammo_changed", ammo * 100 / max_ammo) 
	$GunTimer.wait_time = gun_cooldown

func control(delta):
        pass
		
func shoot(num, spread, target=null):
	if can_shoot and ammo != 0:
		self.ammo -= 1  # reduce ammo every shot, use self.ammo to call the set_ammo func instead of just changing the value
		can_shoot = false
		$GunTimer.start()
		var dir = Vector2(1,0).rotated($Turret.global_rotation)
		if num > 1:
			for i in range(num):
				var a = -spread + i * (2*spread)/(num-1)  # create shots spread
				emit_signal('shoot', Bullet, $Turret/Muzzle.global_position, dir.rotated(a), target)
		else:
			emit_signal('shoot', Bullet, $Turret/Muzzle.global_position, dir, target)
		$AnimationPlayer.play("muzzle_flash")

func _physics_process(delta):
		if not alive:
				 return
		control(delta)
		if map:
			var tile = map.get_cellv(map.world_to_map(position))
			if tile in GLOBALS.slow_terrain:
				velocity *= float(offroad_friction)
		move_and_slide(velocity)
		
func heal(amount):
	health += amount
	health = clamp(health, 0, max_health)
	emit_signal('health_changed', health * 100 / max_health)  # percent health
	if health >= max_health/2:
		$Smoke.emitting = false
	
func take_damage(amount):
	health -= amount
	emit_signal('health_changed', health * 100 / max_health)
	if health <= max_health/2:
		$Smoke.emitting = true
	if health <= 0:
		explode()
		
func explode():
	$CollisionShape2D.disabled = true  # we don't want additional bullets to hit the explosion
	alive = false
	$Turret.hide()
	$Body.hide()
	$Explosion.show()
	$Explosion.play()
	emit_signal('dead')
	

func _on_GunTimer_timeout():
	can_shoot = true


func _on_Explosion_animation_finished():
	queue_free()

func set_ammo(value):
	if value > max_ammo:
		value = max_ammo  # limit the value to max_value
	ammo = value
	emit_signal("ammo_changed", ammo * 100 / max_ammo) 