extends Node2D

@onready var area : Rect2 = Rect2($ColorRect.get_rect().position+global_position,$ColorRect.get_rect().size)
signal credentials_rejected
func place(object):
	if object.legit:
		$AnimationPlayer.play("Legit")
	else:
		$AnimationPlayer.play("Wrong")
		credentials_rejected.emit()
