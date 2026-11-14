extends Control
## Vista de interacción local. Solo emite señales; no escribe partida ni decide encuentros.
signal inspected(description: String)
signal encounter_requested

const AdventureTheme = preload("res://scripts/adventure_theme.gd")

var environment := ""
var description := ""
var hotspots: Array[Button] = []
var centers: Array[Vector2] = []
var selected: Button

func setup(background: Texture2D, info: Dictionary, large_text: bool = false) -> void:
	environment = str(info.get("environment", ""))
	description = str(info.get("description", ""))
	custom_minimum_size.y = 220
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	clip_contents = true

	var image := TextureRect.new()
	image.name = "InteractiveBackdrop"
	image.texture = background
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(image)
	image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var shade := ColorRect.new()
	shade.color = Color(0.015, 0.075, 0.065, 0.34)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	_add_hotspot("HotspotEnvironment", "Entorno", Vector2(0.18, 0.35), func(): _inspect("environment"), large_text)
	_add_hotspot("HotspotTrail", "Camino", Vector2(0.49, 0.68), func(): _inspect("description"), large_text)
	_add_hotspot("HotspotEncounter", "Buscar encuentro", Vector2(0.81, 0.35), func(): encounter_requested.emit(), large_text)

func _ready() -> void:
	resized.connect(_layout_hotspots)
	_layout_hotspots()

func _add_hotspot(id: String, caption: String, center: Vector2, action: Callable, large_text: bool) -> void:
	var spot := Button.new()
	spot.name = id
	spot.text = caption
	spot.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	spot.focus_mode = Control.FOCUS_ALL
	spot.tooltip_text = caption
	spot.add_theme_font_size_override("font_size", 23 if large_text else 20)
	spot.custom_minimum_size.y = 60
	AdventureTheme.decorate(spot)
	if id == "HotspotEncounter":
		spot.theme_type_variation = "JadePrimary"
	spot.pressed.connect(action)
	add_child(spot)
	hotspots.append(spot)
	centers.append(center)

func _layout_hotspots() -> void:
	var half_width := minf(96.0, size.x * 0.14)
	var half_height := 33.0
	for i in range(hotspots.size()):
		var spot := hotspots[i]
		var center := centers[i]
		spot.anchor_left = center.x
		spot.anchor_right = center.x
		spot.anchor_top = center.y
		spot.anchor_bottom = center.y
		spot.offset_left = -half_width
		spot.offset_right = half_width
		spot.offset_top = -half_height
		spot.offset_bottom = half_height

func _inspect(which: String) -> void:
	for spot in hotspots:
		if spot == selected: spot.theme_type_variation = "Button"
	selected = hotspots[0] if which == "environment" else hotspots[1]
	selected.theme_type_variation = "JadeSelected"
	inspected.emit(("Entorno: " + environment) if which == "environment" else description)
