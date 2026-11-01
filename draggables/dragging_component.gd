extends Node2D

@export var parent_script : Script
@export var parent : Node
@export var delay : float
@export var tp_on_wrong_drop : bool
@export var original_location : Vector2
@export var sprite : Node2D
@export var drag_area_polygon : Polygon2D
@export var buyable : bool
@onready var current_viewport : Node = parent.viewport
@onready var bounds : Vector2 = Vector2(get_tree().current_scene.get_node(current_viewport.texture.viewport_path).size)
const return_delay : float = 10
var draggable : bool = true
var drag_area : PackedVector2Array
var is_dragged : bool = false

signal dropped

func _ready() -> void:
	print(bounds)
	for point : Vector2 in drag_area_polygon.polygon:
		drag_area.append(point)

func _process(delta: float) -> void:
	if is_dragged:
		drag(delta)

func drag(delta):
	parent.global_position = get_global_mouse_position()
func release(pos):
	if buyable:
		if get_global_mouse_position().x < 576:
			current_viewport = get_tree().current_scene.kitchen_texture
		else:
			current_viewport = get_tree().current_scene.counter_texture
		parent.viewport = current_viewport
		bounds = Vector2(get_tree().current_scene.get_node(current_viewport.texture.viewport_path).size)
		var proportion = Vector2(get_tree().current_scene.get_node(current_viewport.texture.viewport_path).size)/current_viewport.size
		pos = (pos-current_viewport.global_position)*proportion
		parent.reparent(get_tree().current_scene.get_node(current_viewport.texture.viewport_path),true)
		parent.scale = Vector2(1,1)
	parent.position = pos
	Main.object_placed.emit(pos,parent)
	print(Rect2(Vector2.ZERO,bounds))
	print(global_position-bounds)
	if !Rect2(Vector2.ZERO,bounds).has_point(global_position):
		if parent.has_method('failsafe'):
			parent.failsafe()
		else:
			parent.return_to_og_location()


func begin_drag():
	if buyable:
		parent.reparent(get_tree().current_scene,true)
		parent.scale = current_viewport.size / Vector2(
			get_tree().current_scene.get_node(current_viewport.texture.viewport_path).size
		)
	var tween = create_tween()
	tween.tween_property(sprite,'scale',Vector2(1.2,1.2),0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and !is_dragged and draggable:
			var new_drag_area : PackedVector2Array
			for point in drag_area:
				new_drag_area.append(to_global(point))
			if Geometry2D.is_point_in_polygon(event.position,new_drag_area):
				begin_drag()
				is_dragged = true
			
		if event.is_released() and is_dragged:
			is_dragged = false
			release(event.position)
