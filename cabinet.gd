extends Node3D

func _input(event: InputEvent):
	$SubViewport.push_input(event)
