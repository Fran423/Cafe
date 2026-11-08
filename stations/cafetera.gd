extends Node2D

@onready var area : Rect2 = Rect2($ColorRect3.get_rect().position+global_position,$ColorRect3.get_rect().size)
@onready var envase_marca : Marker2D = $EnvaseMarca
@onready var cazo_marca : Marker2D = $CazoMarca
var items : Dictionary = {
	'cazo' = null,
	'envase' = null
}

func add(coffee):
	pass
func place(object):
	if object.name == 'Cazo':
		if items['cazo'] == null:
			object.global_position = $CazoMarca.global_position
			items['cazo'] = object
			object.get_node('DraggingComponent').connect('grabbed',cazo_retirado)
		else:
			object.return_to_og_location()
			return
	elif object.is_in_group('Envases'):
		if items['envase'] == null:
			object.global_position = $EnvaseMarca.global_position
			object.change_pos($EnvaseMarca.global_position)
			items['envase'] = object
			object.get_node('DraggingComponent').connect('grabbed',envase_retirado)
		else:
			object.return_to_og_location()
			return
	fill_cup(items['envase'])
func cazo_retirado():
	if items['cazo'] != null:
		items['cazo'].get_node('DraggingComponent').disconnect('grabbed',cazo_retirado)
		items['cazo'] = null
		
func envase_retirado():
	if items['envase'] != null:
		items['envase'].get_node('DraggingComponent').disconnect('grabbed',envase_retirado)
		items['envase'] = null
		
func fill_cup(cup):
	if items['cazo'] != null and cup != null:
		if items['cazo'].coffee not in cup.coffee['coffee']:
			cup.coffee['coffee'].append(items['cazo'].coffee)
			items['cazo'].get_node('DraggingComponent').draggable = false
			items['envase'].get_node('DraggingComponent').draggable = false
			await get_tree().create_timer(0.5,false).timeout
			items['cazo'].get_node('DraggingComponent').draggable = true
			items['envase'].get_node('DraggingComponent').draggable = true
			items['cazo'].return_to_og_location()
			items['cazo'].coffee = ''
			cazo_retirado()
