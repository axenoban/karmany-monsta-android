extends Control
signal point_selected(point_id: String)
const Route = preload("res://scripts/jade_route.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const Stage = preload("res://scripts/trial_stage.gd")
var cards: Array[VBoxContainer] = []
var buttons: Array[Button] = []
var progress: Dictionary = {}
var encounter_active := false
var controls_locked := false

func setup(route: Dictionary, active_encounter: bool, locked: bool) -> void:
	progress = route.duplicate(true)
	encounter_active = active_encounter
	controls_locked = locked
	custom_minimum_size.y = 260
	for i in range(Route.points().size()):
		var point: Dictionary = Route.points()[i]
		var card := VBoxContainer.new()
		card.add_theme_constant_override("separation", 4)
		cards.append(card)
		add_child(card)
		var title := Label.new()
		title.text = "%d · %s" % [i + 1, Catalog.species_name(point.species)]
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.add_theme_font_size_override("font_size", 22)
		card.add_child(title)
		var portrait := TextureRect.new()
		portrait.texture = Stage.texture(point.species)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.custom_minimum_size.y = 90
		card.add_child(portrait)
		var done := Route.completed(progress, point.id)
		var available := Route.unlocked(progress, point.id)
		var status := Label.new()
		status.text = "Completado" if done else ("Disponible" if available else "Bloqueado")
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		status.add_theme_font_size_override("font_size", 20)
		card.add_child(status)
		var button := Button.new()
		button.name = point.id
		button.text = "Repetir" if done else ("Iniciar" if available else "Vence el anterior")
		button.custom_minimum_size.y = 58
		button.disabled = not available or encounter_active or controls_locked
		var point_id: String = point.id
		button.pressed.connect(func(): point_selected.emit(point_id))
		card.add_child(button)
		buttons.append(button)

func _ready() -> void:
	resized.connect(_layout)
	_layout()
func _layout() -> void:
	for i in range(cards.size()):
		cards[i].position = Vector2(size.x * (0.03 + i * 0.245), maxf(0, (size.y - 228) * 0.5))
		cards[i].size = Vector2(size.x * 0.205, 228)
	queue_redraw()
func _draw() -> void:
	draw_texture_rect(Stage.texture("jade"), Rect2(Vector2.ZERO, size), false, Color(0.5, 0.5, 0.5))
	for i in range(cards.size() - 1):
		var start := Vector2(size.x * (0.13 + i * 0.245), size.y * 0.5)
		var end := Vector2(size.x * (0.13 + (i + 1) * 0.245), size.y * 0.5)
		draw_line(start, end, Color(0.6, 0.85, 0.7, 0.5), 4, true)
