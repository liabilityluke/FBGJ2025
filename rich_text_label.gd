extends RichTextLabel


func _on_board_score_updated(score: Variant) -> void:
	text = str(score)
