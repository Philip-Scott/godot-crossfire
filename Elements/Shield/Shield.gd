extends Area2D

signal shield_hit ()

export var local_rotation = 0;

export var hidden_until = 15;
export var shown_until = 2;

func _ready():
	power_level(100)
	connect("body_entered", self, "_on_body_entered")

func power_level(level):
	if level > 80:
		modulate = "#8cd5ff" # BLUE
	elif level > 60:
		modulate = "#d1ff82" # GREEN
	elif level > 40:
		modulate = "#fff394" # YELLOW
	elif level > 20:
		modulate = "#ffc27d" # ORANGE
	elif level > 10:
		modulate = "#95a3ab" # SLATE

	if visible:
		visible = level > shown_until
	else:
		visible = level > hidden_until

	$CollisionShape2D.disabled = !visible

func _on_body_entered(body):
	var reflect_dir = Vector2()
	reflect_dir.x = 300
	reflect_dir = reflect_dir.rotated(local_rotation)

	body.set_angular_velocity (0)
	body.set_linear_velocity (reflect_dir)

	emit_signal("shield_hit")
	pass
