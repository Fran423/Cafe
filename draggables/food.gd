extends CharacterBody2D

@onready var dragging_component = $DraggingComponent
@onready var area : Rect2 = Rect2($PlaceRect.get_rect().position+global_position,$PlaceRect.get_rect().size)
@onready var viewport : Node = get_tree().current_scene.counter_texture
var falling : bool = true
var original_pos : Vector2
var type : String
var sprite : CompressedTexture2D
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
	return

func failsafe():
	reparent(get_tree().current_scene.get_node(get_tree().current_scene.counter_texture.texture.viewport_path),true)
	viewport = get_tree().current_scene.counter_texture
	global_position = get_tree().current_scene.get_node(viewport.texture.viewport_path).size/2
	velocity.y = 0

func update_area():
	area = Rect2($PlaceRect.get_rect().position+global_position,$PlaceRect.get_rect().size)
	if viewport == get_tree().current_scene.kitchen_texture:
		failsafe()
func _ready() -> void:
	dragging_component.original_location = original_pos
	$Label.text = type
	$Sprite.texture = sprite
	update_area()
func return_to_og_location():
	if viewport == get_tree().current_scene.counter_texture:
		falling = true
		var scale_tween = create_tween()
		scale_tween.tween_property($Sprite,'scale',Vector2(1,1),0.5).set_ease(Tween.EASE_OUT)
	velocity.y = 0

func use(destination : Node):
	if destination.is_in_group('Extras'):
		return_to_og_location()
	elif destination.name == 'Trash':
		change_pos(Vector2.ZERO)
		queue_free()
