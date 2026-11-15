extends Control

var menu : Array[Dictionary] = [
	{
		'name' = 'Croissant',
		'file' = 'uid://c2or525b0dktm',
		'available' = true
	},
	{
		'name' = 'Cookie',
		'file' = 'uid://c2or525b0dktm',
		'available' = true
	},
	{
		'name' = 'Tomato toast',
		'file' = 'uid://c2or525b0dktm',
		'available' = true
	},
	{
		'name' = 'Cosmic jelly toast',
		'file' = 'uid://c2or525b0dktm',
		'available' = true
	},
	{
		'name' = 'Sandwich',
		'file' = 'uid://c2or525b0dktm',
		'available' = true
	}
]
@onready var list_node : ItemList = $Fondo/ItemList

func _ready() -> void:
	open()

func open():
	list_node.clear()
	for food : Dictionary in menu:
		list_node.add_item(food['name'],load(food['file']),food['available'])


func _on_item_list_multi_selected(_index: int, _selected: bool) -> void:
	if list_node.is_anything_selected():
		if $Fondo/Button.disabled:
			$Fondo/Button.disabled = false
		if list_node.get_selected_items().size() == 1:
			$Fondo/Button.text = 'ONE OF THIS!!'
		else:
			$Fondo/Button.text = 'A ROUND OF THESE!!'
	else:
		if !$Fondo/Button.disabled:
			$Fondo/Button.text = 'Select an order to proceed'
			$Fondo/Button.disabled = true
