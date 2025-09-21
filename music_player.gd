extends AudioStreamPlayer

func start_game() :
	stream = preload("res://assets/maintrack.ogg")
	play()

func start_results(_1, _2, _3, _4) :
	stream = preload("res://assets/results.ogg")
	play()
