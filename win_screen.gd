extends MarginContainer



func _on_board_won(score: Variant, play_time: Variant) -> void:
	get_tree().paused = true
	$Panel/VBoxContainer/Score.text = str(score) + " points"
	$Panel/VBoxContainer/PlayTime.text = str(int(floor(play_time))) + " seconds"
	$Panel/VBoxContainer/WinButton.grab_focus()
	show()


func _on_win_button_pressed() -> void:
	print("button pressed!")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cabinet.tscn")
