extends RichTextLabel

var objective_array := [] 

class Objective :
	var time := 30
	
	var text := "objective"
	
	var test_function : Callable
	
	func _init(time, text, test_function) :
		self.time = time
		self.text = text
		self.test_function = test_function
	
	
	func is_objective_met(chain_results : Dictionary) :
		return test_function.call(chain_results)



func _ready() -> void:
	objective_array.append(Objective.new(30, "Clear at least three in a row!", func(test_function) : return test_function["total_popped"] >= 3))
	objective_array.append(Objective.new(45, "Make a 2 chain!", func(test_function) : return test_function["chain_length"] >= 2))
	objective_array.append(Objective.new(30, "Clear at least 3 white blocks!", func(test_function) : return test_function["white_popped"] >= 3))
	objective_array.append(Objective.new(30, "Clear at least 6 blocks in a chain!", func(test_function) : return test_function["total_popped"] >= 6))
	objective_array.append(Objective.new(30, "Merge 2 blocks in a chain!", func(test_function) : return test_function["blocks_merged"] >= 2))
	objective_array.append(Objective.new(60, "Make a 3 chain!", func(test_function) : return test_function["chain_length"] >= 3))
	objective_array.append(Objective.new(45, "Merge twice and clear 4 blocks in a single chain!", func(test_function) : return (test_function["total_popped"] >= 4 and test_function["blocks_merged"] >= 2)))
	
	
	text = objective_array[0].text 
	
	$ObjectiveTimer.start_timer(objective_array[0].time)
	


func _on_board_chain_finished(chain_results: Variant) -> void:
	if objective_array.size() > 0 :
		if objective_array[0].is_objective_met(chain_results) :
			objective_array.pop_front()
			if objective_array.size() > 0 :
				
				text = objective_array[0].text
				$ObjectiveTimer.start_timer(objective_array[0].time)
			else :
				text = "you win!!"
