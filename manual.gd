extends Control

var current_page : int = 0

func appear() -> void:
	update_page()
	show()
func disappear():
	hide()
	$FlipPage.play()



var controls : Array = [
	'Click anywhere outside of the manual or the order screen to [color=RED]exit[/color] them.',
	'[color=LIME_GREEN][NEW][/color] To make meals, click on the [color=RED]order screen at the counter[/color] and [color=RED]select[/color] the meals you want Bob to make. After [color=RED]a few seconds[/color], the meals will appear on the counter.',
	'[color=LIME_GREEN][NEW][/color] If the costumer doesn\'t outright give you their credentials, [color=RED]ask them to before delivering their order.',
	'[color=LIME_GREEN][NEW][/color] To scan a costumer\'s credentials, [color=RED]drag[/color] them to the reader on the kitchen. A [color=RED]green[/color] flash means the credentials are [color=RED]correct[/color]. A [color=RED]red[/color] flash indicates they are [color=RED]outdated[/color].',
	'[color=LIME_GREEN][NEW][/color] If the costumer\'s credentials are [color=RED]outdated[/color], [color=RED]neglect[/color] them their order by clicking on them [color=RED]with an empty counter[/color]. Otherwise, proceed with their order as usual.',
	'Drag the filter to either the normal coffee or the cosmic coffee dispensers to fill it [color=RED]with that type of coffee[/color].',
	'Drag the tamper to the filter to [color=RED]press[/color] it.',
	'To fill a cup, drag it to the coffee machine, along with a [color=RED]filled and pressed[/color] filter.',
	'Drag the milk to the cup you want to [color=RED]add[/color] it.',
	'To put ice on a cup, drag the ice from the [color=RED]freezer[/color] to the cup you want to throw it into.',
	'Drag the cup to either the vanilla, ginger, pepper or alcohol droppers to [color=RED]add[/color] them.',
	'Filling a tamper with coffee or a cup with milk or extras will [color=RED]cost[/color] you a small sum of money. [i][color=DIM_GRAY]Money will be an important feature in the future, so make sure to not overspend it!',
	'To deliver a cup, drag it to the [color=RED]counter[/color] and press the costumer\'s head. This will finish the delivery, so [color=RED]make sure you have everything you want to deliver over the counter![/color]',
	'You can ask a costumer for more information of their order by clicking the [color=RED]space where the dialogue displays[/color]. [i][color=DIM_GRAY]Later on you will be able to use this to interrogate them.'
	]

var letter : Dictionary[String,Array] = {
	
	'Bases' = [
		'Espresso: 1 shot [color=SADDLE_BROWN]normal coffee[/color]',
		'Doppio: 2 shots [color=SADDLE_BROWN]normal coffee[/color]',
		'Space Black: 1 shot [color=DARK_BLUE]cosmic coffee[/color]',
		'Starry Night: 2 shots [color=DARK_BLUE]cosmic coffee[/color]',
		'Taijitu: 1 shot [color=SADDLE_BROWN]normal coffee[/color] + 1 shot [color=DARK_BLUE]cosmic coffee[/color]'],
	'Extras' = [
		'Iced: +1 ice',
		'Frozen: +2 ice',
		'Vanilla: +1 vanilla extract',
		'French: +2 vanilla extract',
		'Spicy: +1 pepper',
		'Ginger: +1 ginger',
		'Drunk: +1 alcohol',
		'Strong: +2 alcohol'],
	'Specials' = [
		'Kopi Jahe: 1 shot [color=SADDLE_BROWN]normal coffee[/color] + 1 pepper + 1 ginger',
		'Cold brew: 1 shot [color=SADDLE_BROWN]normal coffee[/color] + 1 ice + 1 ginger',
		'Cappuccino: 1 shot [color=SADDLE_BROWN]normal coffee[/color] + 1 milk',
		'Latte: 1 shot [color=SADDLE_BROWN]normal coffee[/color] + 2 milk',
		'Cortado: 2 shots [color=SADDLE_BROWN]normal coffee[/color] + 1 milk',
		'Irish: 1 shot [color=SADDLE_BROWN]normal coffee[/color] + 1 alcohol + 1 vanilla + 1 milk',
		'Breakfast drink: 1 milk + 1 milk + 1 milk']
}

func next_page():
	if current_page*6+6 <= controls.size():
		current_page += 1
		update_page()
		
func last_page():
	if current_page > 0:
		current_page -= 1
		update_page()
		

func update_page():
	$FlipPage.play()
	var page = current_page
	if $TabBar.current_tab == 0:
		for i in [$TabBar/Controls/LeftPage/RichTextLabel, $TabBar/Controls/LeftPage/RichTextLabel2, $TabBar/Controls/LeftPage/RichTextLabel3,$TabBar/Controls/RightPage/RichTextLabel, $TabBar/Controls/RightPage/RichTextLabel2, $TabBar/Controls/RightPage/RichTextLabel3]:
			i.show()
		$TabBar/Letter/LeftPage.hide()
		$TabBar/Letter/RightPage.hide()
		page = current_page*6
		if controls.size()-page > 0: 
			$TabBar/Controls/LeftPage/RichTextLabel.text = controls[page]
		else:
			$TabBar/Controls/LeftPage/RichTextLabel.text = ''
			
		if controls.size()-page-1 > 0: 
			$TabBar/Controls/LeftPage/RichTextLabel2.text = controls[page+1]
		else:
			$TabBar/Controls/LeftPage/RichTextLabel2.text = ''
			
		if controls.size()-page-2 > 0: 
			$TabBar/Controls/LeftPage/RichTextLabel3.text = controls[page+2]
		else:
			$TabBar/Controls/LeftPage/RichTextLabel3.text = ''
			
		if controls.size()-page-3 > 0: 
			$TabBar/Controls/RightPage/RichTextLabel.text = controls[page+3]
		else:
			$TabBar/Controls/RightPage/RichTextLabel.text = ''
			
		if controls.size()-page-4 > 0: 
			$TabBar/Controls/RightPage/RichTextLabel2.text = controls[page+4]
		else:
			$TabBar/Controls/RightPage/RichTextLabel2.text = ''
			
		if controls.size()-page-5 > 0: 
			$TabBar/Controls/RightPage/RichTextLabel3.text = controls[page+5]
		else:
			$TabBar/Controls/RightPage/RichTextLabel3.text = ''
		
		if current_page == 0:
			$LastPage.hide()
		else:
			$LastPage.show()
		if current_page*6+6 > controls.size():
			$NextPage.hide()
		else:
			$NextPage.show()
	elif $TabBar.current_tab == 1:
		for i in [$TabBar/Controls/LeftPage/RichTextLabel, $TabBar/Controls/LeftPage/RichTextLabel2, $TabBar/Controls/LeftPage/RichTextLabel3,$TabBar/Controls/RightPage/RichTextLabel, $TabBar/Controls/RightPage/RichTextLabel2, $TabBar/Controls/RightPage/RichTextLabel3]:
			i.hide()
		$TabBar/Letter/LeftPage.show()
		$TabBar/Letter/RightPage.show()
		var text_left : String
		var text_right : String
		if current_page == 0:
			$LastPage.hide()
			$NextPage.show()
			text_left = 'Bases: \n'
			text_right = 'Extras: \n'
			for i in letter['Bases']:
				text_left += str('\n',i)
			for i in letter['Extras']:
				text_right += str('\n',i)
		else:
			text_left = 'Specials: \n'
			for i in letter['Specials']:
				text_left += str('\n',i)
			$LastPage.show()
			$NextPage.hide()
		$TabBar/Letter/LeftPage.text = text_left
		$TabBar/Letter/RightPage.text = text_right

func _on_close_tracker_pressed() -> void:
	disappear()


func _on_tab_bar_tab_changed(tab: int) -> void:
	current_page = 0
	update_page()
