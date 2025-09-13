extends Node2D

@export var board_width := 6
@export var board_height := 10
var cell_size := 64
var board_start_position := Vector2i(0, 0)
@export var spawn_location := Vector2i(2, 1)

var grid : Array

var seed_block : Node2D
var stem_block : Node2D
var rotation_state := 0
var fast_dropping := false

var gravity_timer : Timer
@export var gravity_time := 1.0

var chain_timer : Timer
@export var chain_time := 0.5

var drop_timer : Timer
@export var drop_time := 0.5

var in_chain := false

var block := preload("res://block.tscn")

@export var primary_chance := 0.75

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

	chain_timer = Timer.new()
	add_child(chain_timer)
	chain_timer.wait_time = chain_time
	chain_timer.one_shot = true
	chain_timer.timeout.connect(on_chain_timer_timeout)

	drop_timer = Timer.new()
	add_child(drop_timer)
	drop_timer.wait_time = drop_time
	drop_timer.one_shot = true
	drop_timer.timeout.connect(_on_drop_timer_timeout)

func _input(event: InputEvent) -> void:
	if seed_block != null and stem_block != null :
		if event.is_action_pressed("ui_left") :
			var new_seed_location = seed_block.location + Vector2i(-1, 0)
			var new_stem_location = stem_block.location + Vector2i(-1, 0)
			if is_valid_move(new_seed_location) and is_valid_move(new_stem_location) :
				if rotation_state != 3 :
					move_block(seed_block, new_seed_location)
					move_block(stem_block, new_stem_location)
				else :
					move_block(stem_block, new_stem_location)
					move_block(seed_block, new_seed_location)
		elif event.is_action_pressed("ui_right") :
			var new_seed_location = seed_block.location + Vector2i(1, 0)
			var new_stem_location = stem_block.location + Vector2i(1, 0)
			if is_valid_move(new_seed_location) and is_valid_move(new_stem_location) :
				if rotation_state != 1 :
					move_block(seed_block, new_seed_location)
					move_block(stem_block, new_stem_location)
				else :
					move_block(stem_block, new_stem_location)
					move_block(seed_block, new_seed_location)
		elif event.is_action_pressed("ui_accept") :
			rotate_falling_blocks(false)
		elif event.is_action_pressed("ui_cancel") :
			rotate_falling_blocks(true)
		elif event.is_action_pressed("ui_down") :
			_on_gravity_timer_timeout()
			gravity_timer.wait_time = 0.1
			gravity_timer.start()
			fast_dropping = true

func _process(delta: float) -> void:
	if !Input.is_action_pressed("ui_down") and fast_dropping :
		fast_dropping = false
		gravity_timer.wait_time = gravity_time
		gravity_timer.start()

func rotate_falling_blocks(clockwise := true) :
	var desired_rotation_state : int
	if clockwise :
		desired_rotation_state = wrap(rotation_state + 1, 0, 4)
	else :
		desired_rotation_state = wrap(rotation_state - 1, 0, 4)
	
	var stem_vector : Vector2i
	match desired_rotation_state :
		0 :
			stem_vector = Vector2i(0, -1)
		1 :
			stem_vector = Vector2i(1, 0)
		2 :
			stem_vector = Vector2i(0, 1)
		3 :
			stem_vector = Vector2i(-1, 0)
	
	if is_valid_move(seed_block.location + stem_vector) :
		rotation_state = desired_rotation_state
		move_block(stem_block, seed_block.location + stem_vector)
		

func location_to_position(location: Vector2i) -> Vector2i:
	return board_start_position + Vector2i((0.5+location.x)*cell_size, (0.5+location.y)*cell_size)

func _on_gravity_timer_timeout() :
	if seed_block != null and stem_block != null :
		var new_seed_location = seed_block.location + Vector2i(0, 1)
		var new_stem_location = stem_block.location + Vector2i(0, 1)
		if is_valid_move(new_seed_location) and is_valid_move(new_stem_location) :
			if rotation_state != 2 :
				move_block(seed_block, new_seed_location)
				move_block(stem_block, new_stem_location)
			else :
				move_block(stem_block, new_stem_location)
				move_block(seed_block, new_seed_location)
		else :
			place_piece()
		
	gravity_timer.start()

func place_piece() :
	#var dropping_seed_block = seed_block
	#var dropping_stem_block = stem_block
	seed_block = null
	stem_block = null
	
	on_chain_timer_timeout()
	#drop_blocks()
	#check_for_chain()
	#drop_blocks()
	#var test_location : Vector2i
	#test_location = dropping_seed_block.location + Vector2i(0, 1)
	#while is_valid_move(test_location) :
		#move_block(dropping_seed_block, test_location)
		#test_location += Vector2i(0, 1)
	#
	#test_location = dropping_stem_block.location + Vector2i(0, 1)
	#while is_valid_move(test_location) :
		#move_block(dropping_stem_block, test_location)
		#test_location += Vector2i(0, 1)
	
	#spawn_blocks()
	pass #turn falling pieces into real pieces, check for chain

func on_chain_timer_timeout() :
	drop_blocks()
	drop_timer.start()

func _on_drop_timer_timeout() :
	if check_for_chain() :
		chain_timer.start()
	else :
		spawn_blocks()

func drop_blocks() :
	for row in range(board_height - 1, -1, -1) :
		for column in board_width :
			var dropping_block = grid[column][row]
			if dropping_block != null :
				var test_location : Vector2i
				test_location = dropping_block.location + Vector2i(0, 1)
				while is_valid_move(test_location) :
					move_block(dropping_block, test_location)
					test_location += Vector2i(0, 1)

#return true if the chain is continuing
func check_for_chain() -> bool :
	print("---")
	var chain_detected := false
	#check for clearing
	for row in range(board_height - 1, -1, -1) :
		for column in board_width :
			var test_block = grid[column][row]
			if test_block != null :
				var blocks_to_check := [test_block]
				var color_num = test_block.color_num
				
				for  check_block in blocks_to_check :
					
					#horizontal check :
					for check_vector in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)] :
						var test_location = check_block.location + check_vector
						var line_blocks := [check_block]
						while true :
							if test_location.x >= board_width or test_location.x < 0 or test_location.y < 0 or test_location.y >= board_height :
								break
							if grid[test_location.x][test_location.y] == null :
								break
							if grid[test_location.x][test_location.y].color_num != color_num :
								break
							line_blocks.append(grid[test_location.x][test_location.y])
							test_location += check_vector
							
						if line_blocks.size() >= 3 :
							for line_block in line_blocks :
								if not line_block in blocks_to_check :
									blocks_to_check.append(line_block)
					
				
				if blocks_to_check.size() > 1 :
					for popping_block in blocks_to_check :
						popping_block.queue_free()
						grid[popping_block.location.x][popping_block.location.y] = null
					chain_detected = true
			
	
	#check for merging
	for row in range(board_height - 1, -1, -1) :
		for column in board_width :
			var test_block = grid[column][row]
			if row != 0 :
				if test_block != null and grid[column][row - 1] != null :
					var combining_color_num = grid[column][row - 1].color_num
					var test_color_num = test_block.color_num
					var combination_color := -1
					
					match test_color_num :
						0 : #red
							match combining_color_num :
								1 :
									combination_color = 5
								2 :
									combination_color = 4
								3 :
									combination_color = 6
						1 :  #green
							match combining_color_num :
								0 :
									combination_color = 5
								2 :
									combination_color = 3
								4 :
									combination_color = 6
						2 : #blue
							match combining_color_num :
								0 :
									combination_color = 4
								1 :
									combination_color = 3
								5 :
									combination_color = 6
						3 : #cyan
							if combining_color_num == 0 :
								combination_color = 6
						4 : #magenta
							if combining_color_num == 1 :
								combination_color = 6
						5 : #yellow
							if combining_color_num == 2 :
								combination_color = 6
					
					#might have 0 null confusion if i misunderstand how this works
					if combination_color != -1 :
						grid[column][row - 1].queue_free()
						grid[column][row - 1] = null
						test_block.change_color(combination_color)
						chain_detected = true
	
	return chain_detected

func spawn_blocks() -> void :
	rotation_state = 0
	
	if is_valid_move(spawn_location) and is_valid_move(spawn_location + Vector2i(0, -1)) :
		seed_block = block.instantiate()
		seed_block.change_color(generate_weighted_random_color(primary_chance))
		move_block(seed_block, spawn_location)
		add_child(seed_block)
		
		stem_block = block.instantiate()
		stem_block.change_color(generate_weighted_random_color(primary_chance))
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
	
func generate_weighted_random_color(primary_weight := 0.75) :
	pass
	if randf() < primary_weight :
		return randi_range(0, 2)
	else :
		return randi_range(3, 5)
	
