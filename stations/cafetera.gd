extends Node2D

@onready var area : Rect2 = Rect2($ColorRect3.get_rect().position+global_position,$ColorRect3.get_rect().size)
@onready var envase_marca : Marker2D = $EnvaseMarca
@onready var cazo_marca : Marker2D = $CazoMarca

func add(coffee,compressed):
	pass
