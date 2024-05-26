extends Area2D


var region_name: String = ""


func _on_child_entered_tree(node: Node) -> void:
	if node.is_class("Polygon2D"):
		node.color = Color(1, 1, 1, 0.5)


func _on_mouse_entered() -> void:
	EventBus.country_hover.emit(region_name)
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.modulate = Color.DARK_KHAKI


func _on_mouse_exited() -> void:
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.modulate = Color.WHITE


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		EventBus.country_clicked.emit(region_name)
