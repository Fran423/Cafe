extends Node2D
@export var extra : String
@onready var area : Rect2 = Rect2($ColorRect.get_rect().position+global_position,$ColorRect.get_rect().size)
@export var price : float
var cups_filled : Array[Node]

func _ready() -> void:
	$Label.text = extra
	price = Main.prices[extra]

func place(object):
	if object not in cups_filled:
		object.global_position = global_position+Vector2(0,-50)
		get_tree().current_scene.notifier(str(price),-1,$NotifierMark.global_position,'Kitchen')
		cups_filled.append(object)
	else:
		get_tree().current_scene.notifier('Already filled!',0,$NotifierMark.global_position,'Kitchen')
