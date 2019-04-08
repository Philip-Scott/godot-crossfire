extends Area2D

signal in_area(target)
signal out_of_area(target)

export (int) var detect_radius = 0 setget _on_detect_radius_set
export (Color) var debug_color = Color(.87, .91, .247, 0.05)

func _ready():
	pass

func _draw():
	print("DRAW");
	draw_circle(Vector2(), detect_radius,  debug_color)

func _on_Visibility_body_entered(body):
	emit_signal("in_area", body)

func _on_Visibility_body_exited(body):
	emit_signal("out_of_area", body)

func _on_detect_radius_set(value):
	if value < 0: return

	var visibility_shape = CircleShape2D.new()
	visibility_shape.radius = value;
	$CollisionShape2D.shape = visibility_shape

	detect_radius = value;