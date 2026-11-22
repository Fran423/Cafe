extends Node2D

@onready var dragging_component = $DraggingComponent
@onready var area : Rect2 = Rect2($PlaceRect.get_rect().position+global_position,$PlaceRect.get_rect().size)
@onready var viewport : Node = get_tree().current_scene.counter_texture
var legit : bool = true

func _ready() -> void:
	dragging_component.original_location = global_position
	
func return_to_og_location():
	global_position = $DraggingComponent.original_location
	reparent(get_tree().current_scene.counter_viewport,true)
	var scale_tween = create_tween()
	scale_tween.tween_property($Sprite,'scale',Vector2(1,1),0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func use(destination : Node):
	return_to_og_location()
