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

func change_color(_color_num) :
	color_num = _color_num
	match color_num :
		0 : 
			$Red.show()
			$Green.hide()
			$Blue.hide()
		1 : 
			$Red.hide()
			$Green.show()
			$Blue.hide()
		2 : 
			$Red.hide()
			$Green.hide()
			$Blue.show()
		3 : 
			$Red.hide()
			$Green.show()
			$Blue.show()
		4 : 
			$Red.show()
			$Green.hide()
			$Blue.show()
		5 : 
			$Red.show()
			$Green.show()
			$Blue.hide()
		6 :
			$Red.show()
			$Green.show()
			$Blue.show()
