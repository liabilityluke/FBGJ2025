extends Node3D

func _input(event: InputEvent):
	$"cabinet/SubViewport".push_input(event)

func _ready() :
	get_tree().paused = true
	$MusicPlayer.start_game()

func start_game() :
	get_tree().paused = false
