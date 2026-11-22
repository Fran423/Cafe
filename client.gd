extends Node2D

var perfect_order : Array[Dictionary] = [{
	'coffee' = ['normal'],
	'type' = 'Cup',
	'extras' = ['Milk'],
	'ice' = false
}]
var food_ordered : Array = [
	'Croissant',
	'Tomato toast']
@export var pesos : Dictionary[String,int] = {
	'coffee' = 10,
	'extras' = 3,
	'type' = 4,
	'ice' = 4,
	'food' = 10
}
@onready var notification_scene : PackedScene = load('uid://d2so5cfrqepcj')
var cards_scene : PackedScene = load('uid://lq4ggl27d7lh')
var legit : bool
var card : Node
var credentials_given : bool = false
var credentials_rejected : bool = false
var dialogues_said : Array[String]
var dialogue_script : Dictionary[String,Array] = {
	'greetings' = [{
		'side' = 1,
		'text' = 'Hello.',
		'pitch' = 1
		},
		{
		'side' = 1,
		'text' = 'A Cappuccino, please. Also a Croissant and a Tomato toast.',
		'pitch' = 1
		}],
	
	'clarification' = [{
		'side' = 0,
		'text' = 'A Cappuccino?',
		'pitch' = 1
		},
		{
		'side' = 1,
		'text' = 'Yeah. Have you never prepared one? It\'s just 1 coffee and 1 milk!',
		'pitch' = 1
		}],
	
	'credential question' = [
		{
		'side' = 0,
		'text' = 'Sir, i need your credentials.',
		'pitch' = 1
		},
		{
		'side' = 1,
		'text' = 'Huh? Oh! Of course. Sorry.',
		'pitch' = 1,
		'action' = 'give_credentials'
		}
		],
		
	'credentials rejected' = [
		{
		'side' = 0,
		'text' = 'These credentials are outdated.',
		'pitch' = 1
		},
		{
		'side' = 1,
		'text' = '[i]Oh.',
		'pitch' = 1,
		'action' = 'give_credentials'
		}
	],
	
	'leave rejected' = [
		{
		'side' = 1,
		'text' = 'Ugh. Why?',
		'pitch' = 1,
		'action' = 'leave_rejected'
		}
	],
	
	'leave bad' = [
		{
		'side' = 1,
		'text' = 'This is not what i asked for.',
		'pitch' = 1,
		'action' = 'leave_served'
		}
	],
	'leave mid' = [
		{
		'side' = 1,
		'text' = 'Uh... Thanks...',
		'pitch' = 1,
		'action' = 'leave_served'
		}
	],
	'leave good' = [
		{
		'side' = 1,
		'text' = 'Thank you!',
		'pitch' = 0,
		'action' = 'leave_served'
		}
	]
}
signal dialogue_composed

func entered_counter(textbox,reader):
	connect('dialogue_composed',textbox.new_bubble)
	textbox.connect('box_clicked',box_clicked)
	textbox.connect('bubble_advanced',next_bubble)
	reader.connect('credentials_rejected',rejected)
	await get_tree().process_frame
	next_dialogue('greetings')

func box_clicked():
	if !credentials_given and !dialogues_said.has('credentials rejected'):
		next_dialogue('credential question')
	elif credentials_rejected and !dialogues_said.has('credentials rejected'):
		next_dialogue('credentials rejected')
	elif !dialogues_said.has('clarification'):
		next_dialogue('clarification')

func next_dialogue(dialogue_alias : String):
	dialogue_composed.emit(dialogue_script[dialogue_alias])
	dialogues_said.append(dialogue_alias)
	
func _ready() -> void:
	get_tree().current_scene.new_costumer_on_counter(self)
func next_bubble(dialogue : Dictionary):
	if dialogue.has('action'):
		call(dialogue['action'])

func leave_rejected():
	$Button.disabled = true
	get_tree().current_scene.costumer_left()
	await get_tree().create_timer(1,false).timeout
	create_tween().tween_property(self,'position:x',-500,2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(2,false).timeout
	queue_free()
func leave_served():
	$Button.disabled = true
	get_tree().current_scene.costumer_left()
	await get_tree().create_timer(1,false).timeout
	create_tween().tween_property(self,'position:x',1652,2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(2,false).timeout
	queue_free()

func give_credentials():
	credentials_given = true
	if card:
		card.queue_free()
	legit = randi_range(0,1) == 0
	card = cards_scene.instantiate()
	card.position = Vector2(850,300)
	card.legit = legit
	get_parent().call_deferred('add_child',card)

func rejected():
	credentials_rejected = true

func deliver(orders : Array[Dictionary],food : Array):
	if orders.is_empty() and food.is_empty():
		next_dialogue('leave rejected')
	else:
		var mark = grade(orders,food)
		if mark <= 50:
			next_dialogue('leave bad')
		elif mark < 100:
			next_dialogue('leave mid')
		else:
			next_dialogue('leave good')

func grade(order_delivered : Array[Dictionary], food_delivered : Array) -> int:
	var max_points : float = 0
	var points : float = 0
	var final_price : float = 0
	for current_perfect_order in perfect_order:
		if order_delivered.is_empty() and !perfect_order.is_empty():
			max_points += pesos['coffee']
			break
		var current_delivered_order : Dictionary = order_delivered[perfect_order.find(current_perfect_order)]
		#coffee
		if current_perfect_order['coffee'].size() == current_delivered_order['coffee'].size():
			for type in current_perfect_order['coffee']:
				max_points += pesos['coffee']
				if type in current_delivered_order['coffee']:
					points += pesos['coffee']
		else:
			max_points += pesos['coffee']

		#extras
		for extra in current_perfect_order['extras']:
			max_points += pesos['extras']
			if extra in current_delivered_order['extras']:
				points += pesos['extras']
		
		max_points += pesos['ice']
		if current_perfect_order['ice'] == current_delivered_order['ice']:
			points += pesos['ice']
		
		#type
		max_points += pesos['type']
		if current_perfect_order['type'] == current_delivered_order['type']:
			points += pesos['type']
	#amount of cups
	if order_delivered.size() != perfect_order.size():
		max_points *= 2
	#extra food
	for food in food_ordered:
		if food_delivered.is_empty() and !food_ordered.is_empty():
			max_points += pesos['food']
			break
		max_points += pesos['food']
		if food in food_delivered:
			points += pesos['food']
	
	#final price
	for order in perfect_order:
		match order['coffee']:
			'normal': final_price += Main.prices['Coffee']
			'cosmic': final_price += Main.prices['Cosmic coffee']
		for extra in order['extras']:
			final_price += Main.prices[extra]
		for food in food_ordered:
			final_price += Main.prices['Food']
	final_price *= 1.2
	var price_paid = final_price*(points/max_points)
	pay(price_paid)
	var final_grade : int = int(points/max_points*100)
	$Button/Label.text = str(final_grade,'%')
	return final_grade

func pay(price):
	
	var notifier : Control = notification_scene.instantiate()
	get_tree().current_scene.notifier(str(price),1,position,'Counter')
	

func _on_button_pressed() -> void:
	get_tree().current_scene.deliver_pressed(self)
