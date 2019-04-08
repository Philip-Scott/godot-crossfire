extends RigidBody2D

signal place_bullet(position, direction)

export (int) var detect_radius  = 1000
export (int) var fire_radius  = 500
export (bool) var debug = false

var laser_color = Color(.87, .0, .0, 0.1)
var target

func _ready():
	$Visibility.detect_radius = detect_radius
	$ShootingArea.detect_radius = fire_radius

	if debug:
		$Light2D.visible = false

func _physics_process(delta):
	$States.run(delta)

var destryoing = false
func bullet_hit():
	if destryoing: return
	destryoing = true

	$States.set_state("idle")
	$DestroyParticles.emitting = true
	$CollisionShape2D.disabled = true
	$Light2D.enabled = false
	$Sprite.visible = false
	$Visibility.queue_free()
	$DespawnTimer.start()

func _on_DespawnTimer_timeout():
	queue_free()

func _on_Visibility_in_area(body):
	target = body
	$States.set_state("moving-to-player")

func _on_Visibility_out_of_area(target):
	$States.set_state("idle")

func _on_ShootingArea_in_area(body):
	target = body
	$States.set_state("shoot-player");

func _on_ShootingArea_out_of_area(target):
	$States.set_state("moving-to-player")
