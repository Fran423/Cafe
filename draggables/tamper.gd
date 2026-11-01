extends Node2D

@onready var dragging_component = $DraggingComponent
@export var viewport : Node
func _ready() -> void:
	dragging_component.original_location = global_position
	
func return_to_og_location():
	var tween = create_tween()
	tween.tween_property(self,'position',dragging_component.original_location,get_process_delta_time()*dragging_component.return_delay)
	var scale_tween = create_tween()
	scale_tween.tween_property($Sprite,'scale',Vector2(1,1),0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func use(destination : Node):
	if destination.name == 'Cazo':
		if destination.coffee != 'none':
			destination.compress()
			var tween = create_tween()
			tween.tween_property(self,'position',destination.global_position,0.1)
			await get_tree().create_timer(0.5,false).timeout
		return_to_og_location()
