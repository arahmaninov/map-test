class_name Camera
extends Camera2D


static var ref: Camera


func _enter_tree() -> void:
	if ref:
		free()
		return
	
	ref = self


func _ready() -> void:
	print("Initial zoom: " + str(zoom))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask > 0:
		move_offset(event)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and zoom <= Vector2(1.2, 1.2):
		zoom_in()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom_out()


func zoom_in() -> void:
	set_zoom(zoom * 1.05)
	print(zoom)


func zoom_out() -> void:
	set_zoom(zoom * 0.95)
	print(zoom)


func move_offset(event: InputEvent) -> void:
	var rel_x: float = event.relative.x
	var rel_y:float = event.relative.y
	var cam_pos: Vector2 = get_offset()
	var current_zoom: Vector2 = zoom
	
	cam_pos.x -= rel_x / current_zoom.x
	cam_pos.y -= rel_y / current_zoom.y
	set_offset(cam_pos)
