extends Node

var states
var current_state

func _ready():
	states = {
		"idle": $Idle,
		"moving-to-player": $MovingToPlayer,
		"shoot-player": $Shooting
	}
	set_state("idle")

func set_state(state_name):
	if current_state:
		current_state.terminate()

	current_state = states[state_name]
	current_state.start()

func exec_state():
	current_state.run()

func run(delta):
	current_state.run(delta);