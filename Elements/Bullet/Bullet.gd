extends RigidBody2D

export (int) var max_bounce_count = 3
var bounce_count = max_bounce_count;

func _ready():
	$Particles.emitting = true

func _on_Bullet_body_entered(body):
	if body.name == "Player":
		bounce_count = 0;
		body.bullet_hit();
	else:
		bounce_count -= 1;

	if bounce_count == 0:
		queue_free ();

	update_bounce();

func update_bounce():
	$Sprite/Light2D.energy = 1.5 * bounce_count / max_bounce_count
	pass;