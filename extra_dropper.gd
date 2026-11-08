extends Node2D
@export var extra : String
@onready var area : Rect2 = Rect2($ColorRect.get_rect().position+global_position,$ColorRect.get_rect().size)

func _ready() -> void:
	$Label.text = extra
