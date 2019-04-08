extends Node

var Bullet =  preload("res://Elements/Bullet/Bullet.tscn")

export (float) var fire_rate_min = 0.8
export (float) var fire_rate_max = 2.0

var target
var mob
var hit_pos

var moving_state
var old_speed = 0
var can_shoot = false

func _ready():
	$ShootingTimer.wait_time = rand_range(fire_rate_min, fire_rate_max)
	moving_state = get_parent().get_node("MovingToPlayer")
	pass

func start():
	mob = get_parent().get_parent()
	target = mob.target
	$ShootingTimer.start()
	old_speed = moving_state.movement_speed
	moving_state.movement_speed = old_speed * 0.6
	pass

func terminate():
	$ShootingTimer.stop()
	moving_state.movement_speed = old_speed
	pass

func run(delta):
	moving_state.run(delta)
	if can_shoot:
		_aim_and_shoot()

func _on_ShootingTimer_timeout():
	can_shoot = true
	pass

func _aim_and_shoot():
	if !target: return

	var space_state = mob.get_world_2d().direct_space_state
	var position = mob.position
	var result = space_state.intersect_ray(position, target.position, [mob], mob.collision_mask)

	if result:
		hit_pos = result.position
		if result.collider.name == "Player":
			mob.rotation = (target.position - position).angle()
			var bullet_pos = Vector2()

			bullet_pos.x = 60
			bullet_pos = bullet_pos.rotated (mob.rotation)
			bullet_pos += position

			var bullet = Bullet.instance()
			bullet.position = bullet_pos

			var speed = Vector2()
			speed.x = 400
			speed = speed.rotated(mob.rotation)

			bullet.apply_impulse (Vector2(), speed);

			mob.get_parent().add_child(bullet)
			can_shoot = false
