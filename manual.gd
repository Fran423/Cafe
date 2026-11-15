extends Control

var current_page : int = 0

func appear() -> void:
	update_page()
	show()
func disappear():
	hide()



var combinations : Array = [
	'Click anywhere outside of the manual to [color=RED]close[/color] it.',
	'Drag the filter to either the normal coffee or the cosmic coffee dispensers to fill it [color=RED]with that type of coffee[/color].',
	'Drag the tamper to the filter to [color=RED]press[/color] it.',
	'To fill a cup, drag it to the coffee machine, along with a [color=RED]filled and pressed[/color] filter.',
	'Drag the milk to the cup you want to [color=RED]add[/color] it.',
	'To put ice on a cup, drag the ice from the [color=RED]freezer[/color] to the cup you want to throw it into.',
	'Drag the cup to either the vanilla, ginger, pepper or alcohol droppers to [color=RED]add[/color] them.',
	'To deliver a cup, drag it to the [color=RED]counter[/color] and press the costumer\'s head. This will finish the delivery, so [color=RED]make sure you have everything you want to deliver over the counter![/color]',
	'You can ask a costumer for more information of their order by clicking the [color=RED]space where the dialogue displays.']
func next_page():
	if current_page*6+6 <= combinations.size():
		current_page += 1
		update_page()
func last_page():
	if current_page > 0:
		current_page -= 1
		update_page()

func update_page():
	var page = current_page*6
	if combinations.size()-page > 0: 
		$TabBar/Controls/LeftPage/RichTextLabel.text = combinations[page]
	else:
		$TabBar/Controls/LeftPage/RichTextLabel.text = ''
		
	if combinations.size()-page-1 > 0: 
		$TabBar/Controls/LeftPage/RichTextLabel2.text = combinations[page+1]
	else:
		$TabBar/Controls/LeftPage/RichTextLabel2.text = ''
		
	if combinations.size()-page-2 > 0: 
		$TabBar/Controls/LeftPage/RichTextLabel3.text = combinations[page+2]
	else:
		$TabBar/Controls/LeftPage/RichTextLabel3.text = ''
		
	if combinations.size()-page-3 > 0: 
		$TabBar/Controls/RightPage/RichTextLabel.text = combinations[page+3]
	else:
		$TabBar/Controls/RightPage/RichTextLabel.text = ''
		
	if combinations.size()-page-4 > 0: 
		$TabBar/Controls/RightPage/RichTextLabel2.text = combinations[page+4]
	else:
		$TabBar/Controls/RightPage/RichTextLabel2.text = ''
		
	if combinations.size()-page-5 > 0: 
		$TabBar/Controls/RightPage/RichTextLabel3.text = combinations[page+5]
	else:
		$TabBar/Controls/RightPage/RichTextLabel3.text = ''
	
	print(current_page)
	if current_page == 0:
		$LastPage.hide()
	else:
		$LastPage.show()
	if current_page*6+6 > combinations.size():
		$NextPage.hide()
	else:
		$NextPage.show()


func _on_close_tracker_pressed() -> void:
	disappear()
