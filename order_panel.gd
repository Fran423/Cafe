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
@onready var list_node : ItemList = $ItemList
signal orders_finished
var orders_in_work : Array[Dictionary]

func open():
	show()
	if $Cooktime.is_stopped():
		$Load.hide()
		$ItemList.show()
		list_node.clear()
		for food : Dictionary in menu:
			list_node.add_item(food['name'],load(food['file']),food['available'])
			list_node.set_item_tooltip_enabled(menu.find(food),false)
		$Button.text = 'Select an order to proceed'
		$Button.disabled = true
	else:
		$Load.show()
		$ItemList.hide()

func close():
	hide()

func _process(delta: float) -> void:
	if !$Cooktime.is_stopped():
		$Screen/Progress.value = $Cooktime.wait_time-$Cooktime.time_left
func _on_item_list_multi_selected(_index: int, _selected: bool) -> void:
	if list_node.is_anything_selected():
		if $Button.disabled:
			$Button.disabled = false
		$Button.text = 'A ROUND OF THESE!!'
	else:
		if !$Button.disabled:
			$Button.text = 'Select an order to proceed'
			$Button.disabled = true


func _on_button_pressed() -> void:
	if $Cooktime.is_stopped():
		$Screen/Progress.max_value = $Cooktime.wait_time
		for order in $ItemList.get_selected_items():
			orders_in_work.append(menu[order])
		$Cooktime.start()
		$Button.text = 'Stop order'
		
	else:
		$Cooktime.stop()
		orders_in_work.clear()
		$Button.text = 'Select an order to proceed.'
		$Button.disabled = true
		
	open()


func _on_cooktime_timeout() -> void:
	orders_finished.emit(orders_in_work)
	$Load.hide()
	$ItemList.show()
	list_node.clear()
	for food : Dictionary in menu:
		list_node.add_item(food['name'],load(food['file']),food['available'])
		list_node.set_item_tooltip_enabled(menu.find(food),false)
	$Button.text = 'Select an order to proceed'
	$Button.disabled = true
	orders_in_work.clear()

func _on_close_tracker_pressed() -> void:
	close()
