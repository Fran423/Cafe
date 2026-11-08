extends Node2D

var perfect_order : Array[Dictionary] = [{
	'coffee' = ['normal'],
	'type' = 'Cup',
	'extras' = [],
	'ice' = true
}]
@export var pesos : Dictionary[String,int] = {
	'coffee' = 6,
	'extras' = 3,
	'ice' = 4
}


func deliver(orders : Array[Dictionary]):
	grade(orders)

func grade(order_delivered : Array[Dictionary]) -> int:
	var max_points : float = 0
	var points : float = 0
	if order_delivered.is_empty():
		$Button/Label.text = str(0,'%')
		return 0
	for current_perfect_order in perfect_order:
		
		var current_delivered_order : Dictionary = order_delivered[perfect_order.find(current_perfect_order)]
		#coffee
		for type in current_perfect_order['coffee']:
			max_points += pesos['coffee']
			if type in current_delivered_order['coffee']:
				points += pesos['coffee']

		#extras
		for extra in current_perfect_order['extras']:
			max_points += pesos['extras']
			if extra in current_delivered_order['extras']:
				points += pesos['extras']
		
		#ice
		if current_perfect_order['ice'] != current_delivered_order['ice']:
			max_points *= 1.5
		
		#type
		if current_perfect_order['type'] != current_delivered_order['type']:
			max_points *= 1.5
		
	if order_delivered.size() != perfect_order.size():
		max_points *= 2
	var final_grade : int = int(points/max_points*100)
	$Button/Label.text = str(final_grade,'%')
	print(points,max_points,final_grade)
	print(perfect_order[0])
	print(order_delivered[0])
	return final_grade

func _on_button_pressed() -> void:
	get_tree().current_scene.deliver_pressed(self)
