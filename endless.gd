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
	for i in board_width :
		var column = []
		for j in board_height :
			column.append(null)
		grid.append(column)
	
	spawn_blocks()
	
	gravity_timer = Timer.new()
	add_child(gravity_timer)
	gravity_timer.wait_time = gravity_time
	gravity_timer.one_shot = true
	gravity_timer.timeout.connect(_on_gravity_timer_timeout)
	gravity_timer.start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left") :
		var new_seed_location = seed_block.location + Vector2i(-1, 0)
		var new_stem_location = stem_block.location + Vector2i(-1, 0)
		if is_valid_move(new_seed_location) and is_valid_move(new_stem_location) :
			move_block(seed_block, new_seed_location)
			move_block(stem_block, new_stem_location)
	elif event.is_action_pressed("ui_right") :
		var new_seed_location = seed_block.location + Vector2i(1, 0)
		var new_stem_location = stem_block.location + Vector2i(1, 0)
		if is_valid_move(new_seed_location) and is_valid_move(new_stem_location) :
			move_block(seed_block, new_seed_location)
			move_block(stem_block, new_stem_location)

func location_to_position(location: Vector2i) -> Vector2i:
	return board_start_position + Vector2i((0.5+location.x)*cell_size, (0.5+location.y)*cell_size)

func _on_gravity_timer_timeout() :
	if seed_block != null and stem_block != null :
		var new_seed_location = seed_block.location + Vector2i(0, 1)
		var new_stem_location = stem_block.location + Vector2i(0, 1)
		if is_valid_move(new_seed_location) and is_valid_move(new_stem_location) :
			move_block(seed_block, new_seed_location)
			move_block(stem_block, new_stem_location)
		else :
			place_piece()
		
	gravity_timer.start()

func place_piece() :
	seed_block = null
	stem_block = null
	spawn_blocks()
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
	if is_valid_move(spawn_location) and is_valid_move(spawn_location + Vector2i(0, -1)) :
		seed_block = block.instantiate()
		seed_block.change_color(randi_range(0, 2))
		move_block(seed_block, spawn_location)
		add_child(seed_block)
		
		stem_block = block.instantiate()
		stem_block.change_color(randi_range(0, 2))
		move_block(stem_block, spawn_location + Vector2i(0, -1))
		add_child(stem_block)
	else :
		print("you lose!!!!!")

func move_block(block_to_move : Node2D, location : Vector2i) :
	grid[block_to_move.location.x][block_to_move.location.y] = null
	block_to_move.location = location
	if grid[block_to_move.location.x][block_to_move.location.y] != null :
		printerr("trying to move block to a spot that is already full!!")
	grid[block_to_move.location.x][block_to_move.location.y] = block_to_move
	block_to_move.position = location_to_position(block_to_move.location)

func is_valid_move(location) -> bool :
	if location.x >= board_width or location.x < 0 or location.y >= board_height or location.y < 0: 
		return false
	return (grid[location.x][location.y] == null) or (grid[location.x][location.y] == seed_block) or (grid[location.x][location.y] == stem_block)
	
