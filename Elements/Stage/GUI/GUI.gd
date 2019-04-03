extends CanvasLayer

var bar_size = Vector2();
var x = 0
var y = 0

func _ready():
	x = $PowerBar.position.x
	y = $PowerBar.position.y
	bar_size.y = 1

func set_power(power):
	# $PowerLabel.text = str(power) + "%"

	var current_scale = $PowerBar.transform.get_scale();
	bar_size.x = 1.0 + ( float(power) / 100.0) - float(current_scale.x) / 30.0

	$PowerBar.set_transform($PowerBar.transform.scaled (bar_size))
	$PowerBar.position.x = x
	$PowerBar.position.y = y