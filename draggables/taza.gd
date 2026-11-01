extends CharacterBody2D

@onready var dragging_component = $DraggingComponent
@onready var area : Rect2 = Rect2($PlaceRect.get_rect().position+global_position,$PlaceRect.get_rect().size)
@export var viewport : Node
var falling : bool = false
@onready var original_pos : Vector2 = global_position
var coffee : Dictionary = {
	'coffee' = [],
	'compressions' = 0,
	'extras' = []
}

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		if falling:
			velocity.y += get_gravity().y*delta
	if global_position.y > 1300:
		failsafe()
	move_and_slide()

func failsafe():
	global_position = get_tree().current_scene.get_node(viewport.texture.viewport_path).size/2
	velocity.y = 0

func update_area():
	area = Rect2($PlaceRect.get_rect().position+global_position,$PlaceRect.get_rect().size)
func _ready() -> void:
	dragging_component.original_location = global_position
	
func return_to_og_location():
	if viewport == get_tree().current_scene.counter_texture:
		falling = true
		var scale_tween = create_tween()
		scale_tween.tween_property($Sprite,'scale',Vector2(1,1),0.5).set_ease(Tween.EASE_OUT)
	else:
		falling = false
		var tween = create_tween()
		tween.tween_property(self,'position',dragging_component.original_location,get_process_delta_time()*dragging_component.return_delay)
		var scale_tween = create_tween()
		scale_tween.tween_property($Sprite,'scale',Vector2(1,1),0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	velocity.y = 0

func use(destination : Node):
	pass
