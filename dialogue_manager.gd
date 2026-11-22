extends Control

var bubbles : Array[Control]
@onready var bubble_scene : PackedScene = load('uid://dnvvkx4suov8y')

var current_dialogue : int = -1
var loop_start_point = 0
signal box_clicked
signal bubble_advanced
func next_dialogue():
	box_clicked.emit()
	return

func new_bubble(text):
	$NextDialogue.disabled = true
	for dialogue : Dictionary in text:
		bubble_advanced.emit(dialogue)
		var bubble : Control = bubble_scene.instantiate()
		bubble.dialogue = dialogue['text']
		bubble.pitch = dialogue['pitch']
		bubble.talker = dialogue['side']
		if bubble.talker == 1:
			bubble.position.x += size.x-bubble.get_node('Text').size.x
		
		add_child(bubble)
		await get_tree().process_frame
		bubble.position.y = size.y
		bubble.show()
		for bub in bubbles:
			if bubbles != []:
				create_tween().tween_property(bub,'position:y',bub.position.y-bubble.get_node('Text').size.y-10,0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		bubbles.append(bubble)
		bubbles.push_front(bubble)
		bubble.talk()
		await bubble.finished
	$NextDialogue.disabled = false
		
