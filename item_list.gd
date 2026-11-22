extends ItemList

@export var drag_threshold := 10.0 # Píxeles mínimos para considerar arrastre

var is_pressing := false
var is_dragging := false
var drag_start_mouse_pos := Vector2.ZERO
var drag_start_local_pos := Vector2.ZERO
var drag_start_scroll := Vector2.ZERO


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Guardamos posiciones al pulsar y bloqueamos la acción inmediata
			is_pressing = true
			is_dragging = false
			drag_start_mouse_pos = get_global_mouse_position()
			drag_start_local_pos = event.position
			drag_start_scroll = Vector2(get_h_scroll_bar().value, get_v_scroll_bar().value)
			accept_event()
		else:
			# Al soltar: si NO se arrastró, aplicamos lógica Toggle
			if is_pressing and not is_dragging:
				var idx = get_item_at_position(drag_start_local_pos, true)
				if idx != -1 and is_item_selectable(idx):
					if is_selected(idx):
						deselect(idx)
						multi_selected.emit(idx, false)
					else:
						# El segundo parámetro 'false' evita deseleccionar los demás ítems
						select(idx, false)
						
						multi_selected.emit(idx, true)
			is_pressing = false
			is_dragging = false
			accept_event()

	elif event is InputEventMouseMotion and is_pressing:
		var delta = get_global_mouse_position() - drag_start_mouse_pos
		
		# Activamos el modo arrastre al superar el margen
		if not is_dragging and delta.length() > drag_threshold:
			is_dragging = true
			
		if is_dragging:
			get_h_scroll_bar().value = drag_start_scroll.x - delta.x
			get_v_scroll_bar().value = drag_start_scroll.y - delta.y
			accept_event()
