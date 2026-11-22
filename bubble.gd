extends Control

var talker : int = 1
var dialogue : String = ''
var pitch : float = 0
@onready var text_node : RichTextLabel = $Text
signal finished

func _ready() -> void:
	talk()

func talk() -> void:
	$DialogueSFX.pitch_scale = pitch
	text_node.text = dialogue
	await get_tree().process_frame
	text_node.position.y -= text_node.size.y/2
	if talker == 1:
		text_node.pivot_offset_ratio = Vector2(1,0)
	$AnimationPlayer.play("Bounce")

func _process(delta: float) -> void:
	if !$Lifetime.is_stopped():
		modulate.a = remap($Lifetime.time_left,$Lifetime.wait_time,0,1,0)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	var text : String = text_node.text
	for i in text.length():
		var character = text[i]
		if 'QWERTYUIOPASDFGHJKLÑZXCVBNM'.find(character.to_upper()) != -1:
			if character == character.to_upper():
				$DialogueSFX.volume_db = 5
			else:
				$DialogueSFX.volume_db = 0
			$DialogueSFX.stop()
			$DialogueSFX.play()
		text_node.visible_characters += 1
		var frames_to_wait : int = 2
		if character == ',':
			frames_to_wait = 6
		elif character == '.':
			frames_to_wait = 10
		for y in range(frames_to_wait):
			await get_tree().process_frame
	await get_tree().create_timer(text.length()*0.02,false).timeout
	finished.emit()
	await get_tree().create_timer(3,false).timeout
	$Lifetime.start()
