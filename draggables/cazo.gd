extends Node2D

@onready var dragging_component = $DraggingComponent
@onready var area : Rect2 = Rect2($PlaceRect.get_rect().position+global_position,$PlaceRect.get_rect().size)
@export var viewport : Node
var coffee : String = 'none'
var compressed : int = 0

func update_area():
	area = Rect2($PlaceRect.get_rect().position+global_position,$PlaceRect.get_rect().size)
func _ready() -> void:
	dragging_component.original_location = global_position
	
func return_to_og_location():
	var tween = create_tween()
	tween.tween_property(self,'position',dragging_component.original_location,get_process_delta_time()*dragging_component.return_delay)
	var scale_tween = create_tween()
	scale_tween.tween_property($Sprite,'scale',Vector2(1,1),0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
func compress():
	compressed += 1

func use(destination : Node):
	$Sprite.scale = Vector2(1,1)
	if destination.name == 'MolinilloCafe':
		coffee = 'normal'
		var tween = create_tween()
		tween.tween_property(self,'position',destination.global_position,0.2)
	elif destination.name == 'MolinilloCosmico':
		coffee = 'cosmico'
		var tween = create_tween()
		tween.tween_property(self,'position',destination.global_position,0.2)
	elif destination.name == 'Cafetera':
		destination.add(coffee,compressed)
