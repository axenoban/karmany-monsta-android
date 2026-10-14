extends Control
signal point_selected(point_id: String)
const Route = preload("res://scripts/jade_route.gd")
const Stage = preload("res://scripts/trial_stage.gd")
const POSITIONS := [Vector2(0.16, 0.60), Vector2(0.39, 0.32), Vector2(0.64, 0.63), Vector2(0.85, 0.30)]
var cards: Array[VBoxContainer] = []
var buttons: Array[Button] = []
var progress: Dictionary = {}
var encounter_active := false
var controls_locked := false
var stamina := 100
func setup(route: Dictionary, active_encounter: bool, locked: bool) -> void:
	progress = route.duplicate(true)
	encounter_active = active_encounter
	controls_locked = locked
	custom_minimum_size.y = 260
	for i in range(Route.points().size()):
		var point: Dictionary = Route.points()[i]
		var card := VBoxContainer.new()
		card.add_theme_constant_override("separation", 2)
		cards.append(card)
		add_child(card)
		var button := Button.new()
		button.name = point.id
		button.text = "● %d" % (i + 1)
		button.custom_minimum_size = Vector2(90, 58)
		var point_id: String = point.id
		button.pressed.connect(func(): point_selected.emit(point_id))
		card.add_child(button)
		buttons.append(button)
		var label := Label.new()
		label.text = "✓" if Route.completed(progress, point.id) else ("" if Route.unlocked(progress, point.id) else "◆")
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 20)
		label.add_theme_color_override("font_shadow_color", Color.BLACK)
		label.add_theme_constant_override("shadow_offset_x", 2)
		label.add_theme_constant_override("shadow_offset_y", 2)
		card.add_child(label)
	update_stamina(stamina)
func update_stamina(value: int) -> void:
	stamina = value
	for i in range(buttons.size()):
		var id: String = Route.points()[i].id
		# Selection is read-only, including locked points and insufficient stamina.
		buttons[i].disabled = controls_locked
		buttons[i].tooltip_text = "Ver localización."
		buttons[i].modulate = Color.WHITE if Route.unlocked(progress, id) else Color("a1b6bf")
func _ready() -> void:
	resized.connect(_layout)
	_layout()
func _layout() -> void:
	var map_rect := _map_rect()
	for i in range(cards.size()):
		cards[i].size = Vector2(90, 90)
		cards[i].position = map_rect.position + map_rect.size * POSITIONS[i] - Vector2(45, 29)
	queue_redraw()
func _map_rect() -> Rect2:
	var art := Stage.texture("jade_overhead")
	var tex_size := Vector2(art.get_width(), art.get_height())
	var scale_factor := minf(size.x / tex_size.x, size.y / tex_size.y)
	var extent := tex_size * scale_factor
	return Rect2((size - extent) * 0.5, extent)
func _draw() -> void:
	# Map coordinates and texture use the same transform: markers stay on their terrain.
	var map_rect := _map_rect()
	draw_texture_rect(Stage.texture("jade_overhead"), map_rect, false)
	for i in range(cards.size() - 1): draw_dashed_line(map_rect.position + map_rect.size * POSITIONS[i], map_rect.position + map_rect.size * POSITIONS[i + 1], Color(1, 0.94, 0.69, 0.8), 3, 10, true)
