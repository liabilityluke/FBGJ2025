extends RichTextLabel

var objective_array := [] 

class Objective :
	var time := 30
	
	var text := "objective"
	
	var test_function : Callable
	
	var requirements := {
		"points" : 0,
		"blocks_merged" : 0,
		"chain_length" : 0,
		"total_popped" : 0,
		"primary_popped" : 0,
		"secondary_popped" : 0,
		"red popped" : 0,
		"blue popped" : 0,
		"green popped" : 0,
		"cyan popped" : 0,
		"magenta popped" : 0,
		"yellow popped" : 0,
		"white popped" : 0
	}
	
	func _init(time, text, test_function) :
		self.time = time
		self.text = text
		self.test_function = test_function
	
	
	func is_objective_met(chain_results : Dictionary) :
		return test_function.call(chain_results)



func _ready() -> void:
	objective_array.append(Objective.new(45, "Clear at least three in a row!", func(test_function) : return test_function["total_popped"] >= 3))
	
	text = objective_array[0].text 


func _on_board_chain_finished(chain_results: Variant) -> void:
	if objective_array.size() > 0 :
		if objective_array[0].is_objective_met(chain_results) :
			objective_array.pop_front()
			if objective_array.size() > 0 :
				
				text = objective_array[0].text
			else :
				text = "you win!!"
