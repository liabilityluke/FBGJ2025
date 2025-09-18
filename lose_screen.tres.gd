extends MarginContainer



func _on_board_lost(score: Variant, play_time: Variant, objectives: Variant, total_objectives: Variant) -> void:
	get_tree().paused = true
	$Panel/VBoxContainer/Score.text = str(score) + " points"
	$Panel/VBoxContainer/PlayTime.text = str(int(floor(play_time))) + " seconds"
	$Panel/VBoxContainer/LoseButton.grab_focus()
	$Panel/VBoxContainer/Objectives.text = str(objectives) + "/" + str(total_objectives) + " Objectives"
	show()




func _on_lose_button_pressed() -> void:
	print("button pressed!")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cabinet.tscn")
