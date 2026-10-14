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
		label.text = "Lugar %d · %d stamina\n%s" % [i + 1, Route.entry_cost(point.id), "Completado" if Route.completed(progress, point.id) else ("Explorar" if Route.unlocked(progress, point.id) else "Bloqueado")]
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
		buttons[i].disabled = not Route.unlocked(progress, id) or encounter_active or controls_locked or stamina < Route.entry_cost(id)
		buttons[i].tooltip_text = "Retoma el encuentro actual." if encounter_active else ("Stamina insuficiente." if stamina < Route.entry_cost(id) else "Entrar a la localización.")
func _ready() -> void:
	resized.connect(_layout)
	_layout()
func _layout() -> void:
	for i in range(cards.size()):
		cards[i].size = Vector2(190, 110)
		cards[i].position = size * POSITIONS[i] - Vector2(95, 50)
	queue_redraw()
func _draw() -> void:
	var art := Stage.texture("jade_overhead")
	var tex_size := Vector2(art.get_width(), art.get_height())
	var scale_factor := maxf(size.x / tex_size.x, size.y / tex_size.y)
	var source_size := size / maxf(scale_factor, 0.001)
	draw_texture_rect_region(art, Rect2(Vector2.ZERO, size), Rect2((tex_size - source_size) * 0.5, source_size))
	for i in range(cards.size() - 1): draw_line(size * POSITIONS[i], size * POSITIONS[i + 1], Color(1, 0.92, 0.55, 0.6), 3, true)
