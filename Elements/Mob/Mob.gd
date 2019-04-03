extends RigidBody2D

var Bullet =  preload("res://Elements/Bullet/Bullet.tscn")

signal place_bullet(position, direction)

export (int) var detect_radius  = 420
export (float) var fire_rate_min = 1.0
export (float) var fire_rate_max = 4.0
export (bool) var debug = false

var vis_color = Color(.87, .91, .247, 0.05)
var laser_color = Color(.87, .0, .0, 0.1)
var target
var hit_pos

func _ready():
	var visibility = CircleShape2D.new()
	visibility.radius = detect_radius;
	$Visibility/CollisionShape2D.shape = visibility
	$ShootingTimer.wait_time = rand_range(fire_rate_min, fire_rate_max)
	if debug:
		$Light2D.visible = false

func _draw():
	if debug:
		draw_circle(Vector2(), detect_radius,  vis_color)
		if hit_pos and target:
			draw_circle((hit_pos - position).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), (hit_pos - position).rotated(-rotation), laser_color, 5)

func _on_ShootingTimer_timeout():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position, [self], collision_mask)

	if result:
		hit_pos = result.position
		if result.collider.name == "Player":
			rotation = (target.position - position).angle()
			var bullet_pos = Vector2()

			bullet_pos.x = 60
			bullet_pos = bullet_pos.rotated (rotation)
			bullet_pos += position

			var bullet = Bullet.instance()
			bullet.position = bullet_pos

			var speed = Vector2()
			speed.x = 400
			speed = speed.rotated(rotation)

			bullet.apply_impulse (Vector2(), speed);

			get_parent().add_child(bullet)

	update()
func _on_Visibility_body_entered(body):
	target = body
	$Sprite.self_modulate.r = 1.0
	$ShootingTimer.start()

func _on_Visibility_body_exited(body):
	target = null
	$Sprite.self_modulate.r = 0.0
	$ShootingTimer.stop()


func _on_Mob_body_shape_entered(body_id, body, body_shape, local_shape):
	print_debug(body_id)
	pass # Replace with function body.
