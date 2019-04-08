extends Node

export (float) var movement_speed = 100

var mob
var target
var navigation

func _ready():
	mob = get_parent().get_parent()
	navigation = mob.get_parent().get_node("Navigation2D")

func start():
	target = mob.target

func terminate():
	pass

func run(delta):
	if !target: return

	var path = navigation.get_simple_path(mob.global_position, target.global_position, false)
	var move_distance = movement_speed * delta

	var start_point = mob.position

	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[i])
		if move_distance <= distance_to_next and move_distance >= 0.0:
			mob.position = start_point.linear_interpolate(path[i], move_distance / distance_to_next)
			break
		elif move_distance < 0.0:
			mob.position = path[i]
			break
		move_distance -= distance_to_next
		start_point = path[i]