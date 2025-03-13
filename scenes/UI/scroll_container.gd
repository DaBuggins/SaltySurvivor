extends ScrollContainer




func _input(event):
	if event.is_action_pressed("ui_page_down"):
			set_v_scroll(get_v_scroll() + 140)
	if event.is_action_pressed("ui_page_up"):
			set_v_scroll(get_v_scroll() - 140)
