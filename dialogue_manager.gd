extends Control

var bubbles : Array[Control]
var costumer
@onready var bubble_scene : PackedScene = load('uid://dnvvkx4suov8y')
var dialogue_script : Array[Dictionary] = [
	{
		'side' = 1,
		'text' = 'Hello.',
		'pitch' = 0
	},
	{
		'side' = 1,
		'text' = 'An espresso, please.',
		'pitch' = 0
	},
	
	{
		'break' = ['loop']
	},
	
	{
		'side' = 0,
		'text' = 'An espresso?',
		'pitch' = 0
	},
	{
		'side' = 1,
		'text' = 'Yeah. Have you never prepared one? It\'s just coffee and milk!',
		'pitch' = 0
	},
	{
		'break' = []
	}
]
var current_dialogue : int = -1
var loop_start_point = 0
func _ready() -> void:
	next_dialogue()

func next_dialogue():
	current_dialogue += 1
	if current_dialogue > dialogue_script.size()-1:
		current_dialogue = loop_start_point
		next_dialogue()
		return
	if dialogue_script[current_dialogue].has('break'):
		if dialogue_script[current_dialogue]['break'].has('loop'):
			loop_start_point = current_dialogue
		await $NextDialogue.pressed
		next_dialogue()
		return
	var bubble : Control = bubble_scene.instantiate()
	bubble.dialogue = dialogue_script[current_dialogue]['text']
	bubble.talker = dialogue_script[current_dialogue]['side']
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
	bubble.connect('finished',next_dialogue)
	
