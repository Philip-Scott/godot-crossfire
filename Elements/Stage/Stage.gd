extends Node2D

func _ready():
	$Player.connect("power_changed", self, "_on_Player_power_changed")
	$Player.visible = true;
	randomize()

func _on_Player_power_changed(power):
	$GUI.set_power (power);
