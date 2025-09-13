extends Node2D

#red is zero, green is one, blue is two, cyan is three, magenta is four, yellow is five, white is six.

enum COLOR_NUM{
	RED,
	GREEN,
	BLUE,
	CYAN,
	MAGENTA,
	YELLOW,
	WHITE,
	}

var color_num := 0
var location := Vector2i(0, 0)

func _ready() :
	pass

func change_color(_color_num, play_animation := false) :
	var previous_color = color_num
	color_num = _color_num
	match color_num :
		0 : 
			show_red(previous_color)
			#show_green(true)
			#show_blue(true)
		1 : 
			#show_red(true)
			show_green(previous_color)
			#show_blue(true)
		2 : 
			#show_red(true)
			#show_green(true)
			show_blue(previous_color)
		3 : 
			#show_red(true)
			show_green(previous_color)
			show_blue(previous_color)
		4 : 
			show_red(previous_color)
			#show_green(true)
			show_blue(previous_color)
		5 : 
			show_red(previous_color)
			show_green(previous_color)
			#show_blue(true)
		6 :
			show_red(previous_color)
			show_green(previous_color)
			show_blue(previous_color)
	if play_animation :
		$AnimationPlayer.play("merge")

func show_red(previous_color) :
	$Colors/Red.show()
	if previous_color == 0 or previous_color == 4 or previous_color == 5 :
		$AnimationColorsFalling/Red.hide()
		$AnimationColorsStatic/Red.show()
	else :
		$AnimationColorsFalling/Red.show()
		$AnimationColorsStatic/Red.hide()


func show_green(previous_color) :
	$Colors/Green.show()
	if previous_color == 1 or previous_color == 3 or previous_color == 5 :
		$AnimationColorsFalling/Green.hide()
		$AnimationColorsStatic/Green.show()
	else :
		$AnimationColorsFalling/Green.show()
		$AnimationColorsStatic/Green.hide()

func show_blue(previous_color) :
	$Colors/Blue.show()
	if previous_color == 2 or previous_color == 3 or previous_color == 4 :
		$AnimationColorsFalling/Blue.hide()
		$AnimationColorsStatic/Blue.show()
	else :
		$AnimationColorsFalling/Blue.show()
		$AnimationColorsStatic/Blue.hide()
