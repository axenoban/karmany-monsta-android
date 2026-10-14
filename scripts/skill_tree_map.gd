extends Control

signal node_selected(node_id: String)
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
	custom_minimum_size = Vector2(0, 320)
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
		button.gui_input.connect(func(event: InputEvent): _track_pointer(event, button))
		button.pressed.connect(func():
			if not _dragged:
				node_selected.emit(node_id))
		add_child(button)
		_buttons[node.id] = button
	resized.connect(_place_buttons)
	call_deferred("_place_buttons")

func _point(node: Dictionary) -> Vector2:
	return Vector2(float(node.position[0]) * size.x, float(node.position[1]) * size.y)

func _place_buttons() -> void:
	if _spec.is_empty():
		return
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

func _track_pointer(event: InputEvent, control: Control) -> void:
	if event is InputEventKey and event.pressed:
		_dragged = false
	elif event is InputEventScreenTouch:
		if event.index != 0:
			return
		pointer_event(event.pressed, control.get_global_transform() * event.position)
	elif event is InputEventScreenDrag and event.index == 0:
		pointer_move(control.get_global_transform() * event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pointer_event(event.pressed, control.get_global_transform() * event.position)
	elif event is InputEventMouseMotion and _pointer_down:
		pointer_move(control.get_global_transform() * event.position)

func pointer_event(pressed: bool, at: Vector2) -> void:
	if pressed:
		_pointer_origin = at
		_dragged = false
	else:
		pointer_move(at)
	_pointer_down = pressed

func pointer_move(at: Vector2) -> void:
	if _pointer_down and at.distance_to(_pointer_origin) > DRAG_THRESHOLD:
		_dragged = true
