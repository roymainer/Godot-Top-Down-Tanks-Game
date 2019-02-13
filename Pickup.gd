extends Area2D

enum Items {health, ammo}

var icon_textures = [preload("res://assets/wrench_white.png"), 
				  	 preload("res://assets/ammo_machinegun.png")]

export (Items) var type = Items.health  # default health item
export (Vector2) var amount = Vector2(10,25)  # give between 10 to 25 health

func _ready():
	$Icon.texture = icon_textures[type]

func _on_Pickup_body_entered(body):
	match type:
		Items.health:
			if body.has_method('heal'):
				body.heal(int(rand_range(amount.x, amount.y)))
		Items.ammo:
			body.ammo += int(rand_range(amount.x, amount.y))  # add ammo to the capturing body
	queue_free()
			
