extends Control

signal node_selected(node_id: String)
signal pan_changed(value: Vector2)
var pan := Vector2.ZERO
var _pan_origin := Vector2.ZERO
var _pressed_node := ""
var canvas_size := Vector2(1600, 640)
var _spec: Dictionary
var _progress: Dictionary
var _selected := ""
var _buttons: Dictionary = {}
var _pointer_down := false
var _pointer_origin := Vector2.ZERO
var _dragged := false
const DRAG_THRESHOLD := 16.0

func setup(spec: Dictionary, progress: Dictionary, selected: String, large_text: bool = false) -> void:
	_spec = spec.duplicate(true)
	_progress = progress.duplicate(true)
	_selected = selected
	custom_minimum_size = Vector2(0, 340)
	clip_contents = true
	mouse_filter = MOUSE_FILTER_STOP
	canvas_size = Vector2(1800, 720) if large_text else Vector2(1600, 640)
	for node in _spec.nodes:
		var node_id: String = node.id
		var rank_value := int(_progress.ranks.get(node.id, 0))
		var button := Button.new()
		button.text = node.name + "\nRango %d / %d" % [rank_value, int(node.max_rank)]
		button.custom_minimum_size = Vector2(280 if large_text else 240, 94 if large_text else 84)
		button.add_theme_font_size_override("font_size", 28 if large_text else 23)
		if rank_value > 0:
			button.add_theme_color_override("font_color", Color("92e7bb"))
		if node.id == _selected:
			var box := StyleBoxFlat.new()
			box.bg_color = Color("285e51")
			box.set_border_width_all(2)
			box.border_color = Color("9be5b7")
			box.set_corner_radius_all(14)
			button.add_theme_stylebox_override("normal", box)
		button.mouse_filter = MOUSE_FILTER_IGNORE
		button.gui_input.connect(func(event: InputEvent):
			if event is InputEventKey: _dragged = false)
		button.pressed.connect(func():
			if not _dragged:
				node_selected.emit(node_id))
		add_child(button)
		_buttons[node.id] = button
	resized.connect(_place_buttons)
	call_deferred("_place_buttons")

func _point(node: Dictionary) -> Vector2:
	return Vector2(float(node.position[0]) * canvas_size.x, float(node.position[1]) * canvas_size.y) + pan

func _place_buttons() -> void:
	if _spec.is_empty():
		return
	pan = pan.clamp((size - canvas_size).min(Vector2.ZERO), Vector2.ZERO)
	for node in _spec.nodes:
		var button: Button = _buttons[node.id]
		button.size = button.custom_minimum_size
		button.position = _point(node) - button.size / 2
	queue_redraw()

func _draw() -> void:
	if _spec.is_empty():
		return
	for node in _spec.nodes:
		for prerequisite in node.prerequisites:
			for parent in _spec.nodes:
				if parent.id == prerequisite:
					draw_line(_point(parent), _point(node), Color("5e9e86"), 3, true)

# Capture the entire viewport before the outer ScrollContainer sees a gesture.
# Nodes, links and empty canvas consequently share exactly one gesture owner.
func _input(event: InputEvent) -> void:
	if not is_visible_in_tree(): return
	for window in get_viewport().get_embedded_subwindows():
		if window.visible:
			_pointer_down = false
			return
	if event is InputEventScreenTouch and event.canceled:
		_pointer_down = false
		return
	var at := Vector2.ZERO
	var pressed := false
	var boundary := false
	if event is InputEventScreenTouch:
		if event.index != 0: return
		at = event.position; pressed = event.pressed; boundary = true
	elif event is InputEventScreenDrag:
		if event.index != 0: return
		at = event.position
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.device == InputEvent.DEVICE_ID_EMULATION: return
		at = event.position; pressed = event.pressed; boundary = true
	elif event is InputEventMouseMotion:
		if event.device == InputEvent.DEVICE_ID_EMULATION: return
		at = event.position
	else: return
	var local := get_global_transform_with_canvas().affine_inverse() * at
	if boundary and pressed:
		if not Rect2(Vector2.ZERO, size).has_point(local): return
		var ancestor := get_parent()
		while ancestor is Control:
			if ancestor.clip_contents and not ancestor.get_global_rect().has_point(at): return
			ancestor = ancestor.get_parent()
		_pressed_node = ""
		for id in _buttons:
			if _buttons[id].get_rect().has_point(local): _pressed_node = id
		pointer_event(true, local)
	elif _pointer_down:
		if boundary:
			pointer_event(false, local)
			if not _dragged and not _pressed_node.is_empty() and _buttons[_pressed_node].get_rect().has_point(local):
				get_viewport().set_input_as_handled()
				node_selected.emit(_pressed_node)
				return
		else: pointer_move(local)
	else: return
	get_viewport().set_input_as_handled()

func pointer_event(pressed: bool, at: Vector2) -> void:
	if pressed:
		_pointer_origin = at
		_pan_origin = pan
		_dragged = false
	else: pointer_move(at)
	_pointer_down = pressed

func pointer_move(at: Vector2) -> void:
	var scale_factor := maxf(0.1, get_global_transform_with_canvas().get_scale().length() / sqrt(2.0))
	var threshold := clampf(DisplayServer.screen_get_dpi() / 160.0, 1.0, 3.0) * DRAG_THRESHOLD / scale_factor
	if _pointer_down and at.distance_to(_pointer_origin) > threshold: _dragged = true
	if _pointer_down and _dragged:
		pan = (_pan_origin + at - _pointer_origin).clamp((size - canvas_size).min(Vector2.ZERO), Vector2.ZERO)
		_place_buttons()
		pan_changed.emit(pan)
