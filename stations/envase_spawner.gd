extends Node2D

@export var envase_scene : PackedScene
@export var type : String
var actual_envase : Node2D

func _ready() -> void:
	envase_nuevo()

func envase_nuevo():
	var envase : Node2D = envase_scene.instantiate()
	envase.coffee['type'] = type
	envase.global_position = global_position
	get_parent().add_child.call_deferred(envase)
	if actual_envase != null:
		actual_envase.disconnect('original_position_changed',envase_nuevo)
	actual_envase = envase
	actual_envase.connect('original_position_changed',envase_nuevo)
	actual_envase.original_pos = global_position
	
