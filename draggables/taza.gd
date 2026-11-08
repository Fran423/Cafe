extends CharacterBody2D

@onready var dragging_component = $DraggingComponent
@onready var area : Rect2 = Rect2($PlaceRect.get_rect().position+global_position,$PlaceRect.get_rect().size)
@onready var viewport : Node = get_tree().current_scene.kitchen_texture
var falling : bool = false
var original_pos : Vector2
var coffee : Dictionary = {
	'coffee' = [],
	'type' = [],
	'extras' = [],
	'ice' = false
}
signal original_position_changed
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		if falling:
			velocity.y += get_gravity().y*delta
	if global_position.y > 1300:
		failsafe()
	move_and_slide()

func change_pos(pos):
	original_position_changed.emit()
	original_pos = pos
	$DraggingComponent.original_location = original_pos

func place(object):
	if object.name == 'Hielo':
		if !coffee['extras'].has('ice'):
			coffee['extras'].append('ice')
		object.return_to_og_location()

func failsafe():
	global_position = get_tree().current_scene.get_node(viewport.texture.viewport_path).size/2
	velocity.y = 0

func update_area():
	area = Rect2($PlaceRect.get_rect().position+global_position,$PlaceRect.get_rect().size)
func _ready() -> void:
	$Label.text = coffee['type']
	dragging_component.original_location = original_pos
	
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
	if destination.is_in_group('Extras'):
		if destination.extra not in coffee['extras']:
			coffee['extras'].append(destination.extra)
			await get_tree().create_timer(0.5,false).timeout
		return_to_og_location()
	elif destination.name == 'Trash':
		change_pos(Vector2.ZERO)
		queue_free()
