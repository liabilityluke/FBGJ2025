extends RichTextLabel

var timer : Timer
signal timeout

func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(func() : timeout.emit())
	add_child(timer)
	

func _process(delta: float) -> void:
	text = str(int(floor(timer.time_left)))

func start_timer(time) :
	timer.wait_time = time
	timer.start()
