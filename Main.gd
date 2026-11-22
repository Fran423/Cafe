extends Node

signal object_placed
var current_money : float = 1300
var object_dragged : Node
var prices : Dictionary = {
	'Coffee' = 5,
	'Cosmic coffee' = 7.5,
	'Vanilla' = 20,
	'Alcohol' = 20,
	'Ginger' = 20,
	'Pepper' = 20,
	'Milk' = 10,
	'Food' = 10
}
var order_possibilities : Dictionary = {
	'coffee' = ['normal','cosmico']
}
