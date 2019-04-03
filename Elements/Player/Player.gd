extends KinematicBody2D

signal power_changed(power_level)

export (float) var speed = 400
export (float) var dash_multiplyer = 2.2

export (float) var max_power = 100
export (float) var recharge_speed = 5

var power = max_power
var velocity = Vector2()
var screen_size;

func _ready():
	$RechargeTimer.connect("timeout", self, "_on_RechargeTimer_timeout");
	$Shield2.shown_until = 50
	$Shield2.hidden_until = 75
	$Shield3.shown_until = 50
	$Shield3.hidden_until = 75

	$Shield.connect("shield_hit", self, "_on_shield_hit");
	$Shield2.connect("shield_hit", self, "_on_shield_hit");
	$Shield3.connect("shield_hit", self, "_on_shield_hit");

func _process(delta):
	get_input(delta)
	recharge(delta)
	propagate_power()

func get_input(delta):
	look_at(get_global_mouse_position())
	velocity = Vector2();

	if Input.is_action_pressed("up"):
		velocity.y -= 1;
	if Input.is_action_pressed("down"):
		velocity.y += 1;
	if Input.is_action_pressed("left"):
		velocity.x -= 1;
	if Input.is_action_pressed("right"):
		velocity.x += 1;

	consume_power("MOVE")

	$Trail.emitting = false
	if int(power) != 0:
		velocity = velocity.normalized() * speed
		if Input.is_action_pressed("space") and velocity.length() > 0:
			velocity = velocity * dash_multiplyer
			consume_power("DASH")
			$Trail.emitting = true

	else:
		velocity = velocity.normalized() * speed / 2

	move_and_slide(velocity)

	$Shield.local_rotation = rotation;
	$Shield2.local_rotation = rotation + PI / 4;
	$Shield3.local_rotation = rotation - PI / 4;

func consume_power(action):
	var consumption = 0

	if action == "DASH":
		consumption += 0.4
	if action == "MOVE":
		consumption += velocity.length() / 13
	if action == "SHIELD":
		consumption += 5
	if action == "HURT":
		consumption += 50

	power -= consumption
	if power < 0:
		power = 0

	if power == 0 and consumption > 0:
		$RechargeTimer.start()

func propagate_power():
	var pw = power / max_power * 100;
	$Shield.power_level(pw)
	$Shield2.power_level(pw)
	$Shield3.power_level(pw)
	$Sprite/Light2D.energy = power / max_power * 1.2
	emit_signal("power_changed", int(power))

func recharge(delta):
	if int(power) == 0:
		return

	power += recharge_speed * delta
	if power > max_power:
		power = max_power

func _on_RechargeTimer_timeout():
	power += 1

func _on_shield_hit():
	consume_power("SHIELD")

func bullet_hit():
	consume_power("HURT")
	pass