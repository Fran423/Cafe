extends Node2D

@onready var area : Rect2 = Rect2($ColorRect.get_rect().position+global_position,$ColorRect.get_rect().size)
var price : float
func _ready() -> void:
	price = Main.prices['Coffee']

func place(object):
	if object.coffee == '':
		object.global_position = global_position+Vector2(0,-50)
		get_tree().current_scene.notifier(str(price),-1,global_position,'Kitchen')
	else:
		get_tree().current_scene.notifier('Filter is full!',0,global_position,'Kitchen')
		object.return_to_og_location()
