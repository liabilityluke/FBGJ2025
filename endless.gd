extends Node2D

var board_width := 6
var board_height := 8
var cell_size := 64
var board_start_position := Vector2i(0, 0)
var spawn_location := Vector2i(2, 1)

var grid : Array


var seed_block : Node2D
var stem_block : Node2D

var gravity_timer : Timer
@export var gravity_time := 1.0

var in_chain := false

var block := preload("res://block.tscn")

func _ready() -> void:
	#form the grid
	for i in board_height :
		var row = []
		for j in board_width :
			row.append(null)
		grid.append(row)
	
	spawn_blocks()
	
	gravity_timer = Timer.new()
	add_child(gravity_timer)
	gravity_timer.wait_time = gravity_time
	gravity_timer.one_shot = true
	gravity_timer.timeout.connect(_on_gravity_timer_timeout)
	gravity_timer.start()

func _input(event: InputEvent) -> void:
	pass

func location_to_position(location: Vector2i) -> Vector2i:
	return board_start_position + Vector2i((0.5+location.x)*cell_size, (0.5+location.y)*cell_size)

func _on_gravity_timer_timeout() :
	seed_block.location += Vector2i(0, 1)
	seed_block.position = location_to_position(seed_block.location)
	
	stem_block.location += Vector2i(0, 1)
	stem_block.position = location_to_position(stem_block.location)
	
	gravity_timer.start()

func place_piece() :
	pass #turn falling pieces into real pieces, check for chain

func on_chain_timer_timeout() :
	pass

func _on_drop_timer_timeout() :
	pass

func drop_blocks() :
	pass #drops all the blocks in the grid

#return true if the chain is continuing
func check_for_chain() -> bool :
	return false

func spawn_blocks() -> void :
	seed_block = block.instantiate()
	seed_block.change_color(randi_range(0, 2))
	seed_block.location = spawn_location
	seed_block.position = location_to_position(seed_block.location)
	add_child(seed_block)
	stem_block = block.instantiate()
	stem_block.change_color(randi_range(0, 2))
	stem_block.location = spawn_location + Vector2i(0, -1)
	stem_block.position = location_to_position(stem_block.location)
	add_child(stem_block)
