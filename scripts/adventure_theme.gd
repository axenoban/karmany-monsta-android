extends RefCounted
# Jade Nocturno: estilo semántico reutilizable para todas las fases del juego.
const INK = Color("082522")
const PANEL = Color("103c34")
const JADE = Color("83ddb3")
const GOLD = Color("d8c18b")
const PAPER = Color("f4efdf")
const MIST = Color("adc8ba")
const EDGE = Color("648d78")

static func box(fill: Color, edge: Color, padding: int = 16) -> StyleBoxFlat:
	var result := StyleBoxFlat.new()
	result.bg_color = fill
	result.border_color = edge
	result.set_border_width_all(1)
	result.set_corner_radius_all(8)
	result.set_content_margin_all(padding)
	result.shadow_color = Color(0.01, 0.04, 0.03, 0.25)
	result.shadow_size = 3
	return result

static func cut_panel(id: String, padding: int = 12) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = load("res://assets/ui/jade/" + id + ".svg")
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		style.set_texture_margin(side, 14)
		style.set_content_margin(side, padding)
	style.content_margin_left = 20
	style.content_margin_right = 20
	return style

static func _variation(theme: Theme, name: String, fill: Color, edge: Color, text_color: Color) -> void:
	theme.set_type_variation(name, "Button")
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		var style := box(fill, edge, 12)
		if state == "hover": style.bg_color = fill.lightened(0.10)
		if state == "pressed": style.bg_color = fill.lightened(0.19)
		if state == "disabled":
			style.bg_color = PANEL.darkened(0.12)
			style.border_color = EDGE.darkened(0.28)
		if state == "focus":
			style.bg_color = Color.TRANSPARENT
			style.border_color = GOLD
			style.set_border_width_all(2)
		theme.set_stylebox(state, name, style)
	for item in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		theme.set_color(item, name, text_color)
	theme.set_color("font_disabled_color", name, MIST.darkened(0.18))

static func create() -> Theme:
	var result := Theme.new()
	result.default_font_size = 24
	result.set_color("font_color", "Label", PAPER)
	for kind in ["HBoxContainer", "VBoxContainer", "GridContainer"]:
		result.set_constant("separation", kind, 8)
	result.set_constant("h_separation", "GridContainer", 14)
	result.set_constant("v_separation", "GridContainer", 14)
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		result.set_stylebox(state, "Button", cut_panel("controls_v2/" + state))
	for item in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		result.set_color(item, "Button", PAPER)
	result.set_color("font_disabled_color", "Button", MIST.darkened(0.18))
	result.set_type_variation("JadePrimary", "Button")
	result.set_stylebox("normal", "JadePrimary", cut_panel("controls_v2/primary"))
	result.set_type_variation("JadeSelected", "Button")
	result.set_stylebox("normal", "JadeSelected", cut_panel("controls_v2/selected"))
	# Keep role identity while interacting; disabled remains neutral.
	for role in ["primary", "selected"]:
		var kind := "JadePrimary" if role == "primary" else "JadeSelected"
		for state in ["hover", "pressed"]:
			result.set_stylebox(state, kind, cut_panel("controls_v2/" + role + "_" + state))
	_variation(result, "JadeQuiet", Color("11372f"), EDGE.darkened(0.20), MIST)
	_variation(result, "JadeNav", Color("123d36"), EDGE, PAPER)
	_variation(result, "JadeDanger", Color("40382d"), GOLD.darkened(0.18), GOLD)
	for kind in ["AcceptDialog", "PanelContainer", "PopupPanel"]:
		result.set_stylebox("panel", kind, cut_panel("panel", 14))
	result.set_type_variation("JadeCard", "PanelContainer")
	result.set_stylebox("panel", "JadeCard", cut_panel("panel", 16))
	result.set_type_variation("JadeStatusPanel", "PanelContainer")
	result.set_stylebox("panel", "JadeStatusPanel", box(Color("103b33"), EDGE.darkened(0.12), 10))
	for kind in ["JadePageTitle", "JadeSectionTitle", "JadeEyebrow", "JadeMuted", "JadeStatus"]:
		result.set_type_variation(kind, "Label")
	result.set_font_size("font_size", "JadePageTitle", 34)
	result.set_font_size("font_size", "JadeSectionTitle", 26)
	result.set_font_size("font_size", "JadeEyebrow", 19)
	result.set_font_size("font_size", "JadeMuted", 19)
	result.set_font_size("font_size", "JadeStatus", 21)
	result.set_color("font_color", "JadePageTitle", PAPER)
	result.set_color("font_color", "JadeSectionTitle", JADE)
	result.set_color("font_color", "JadeEyebrow", GOLD)
	result.set_color("font_color", "JadeMuted", MIST)
	result.set_color("font_color", "JadeStatus", PAPER)
	for style in ["background", "fill"]:
		result.set_stylebox(style, "ProgressBar", box(Color("0c211c") if style == "background" else JADE, EDGE, 0))
	result.set_stylebox("slider", "HSlider", box(INK, EDGE, 4))
	result.set_stylebox("grabber_area", "HSlider", box(JADE, JADE, 4))
	result.set_stylebox("grabber_area_highlight", "HSlider", box(GOLD, GOLD, 4))
	var knob := GradientTexture2D.new()
	knob.width = 28
	knob.height = 28
	knob.gradient = Gradient.new()
	knob.gradient.colors = PackedColorArray([PAPER, GOLD])
	for icon_name in ["grabber", "grabber_highlight", "grabber_disabled"]:
		result.set_icon(icon_name, "HSlider", knob)
	return result

static func apply_role(button: Button, role: String) -> void:
	match role:
		"primary": button.theme_type_variation = "JadePrimary"
		"quiet": button.theme_type_variation = "JadeQuiet"
		"navigation": button.theme_type_variation = "JadeNav"
		"danger": button.theme_type_variation = "JadeDanger"
		"selected": button.theme_type_variation = "JadeSelected"

static func decorate(button: Button) -> void:
	var icons := {"Volver": "back", "Volver al combate": "back", "Menú": "settings", "Táctica": "shield", "Entrenador": "book", "Equipo": "team", "Libro": "book", "Ajustes": "settings", "Bestiario": "leaf", "Golpe": "attack", "Protección": "shield", "Insignia": "leaf", "Detalles": "info"}
	for caption in icons:
		if button.text == caption:
			button.icon = load("res://assets/ui/jade/icon_" + icons[caption] + ".svg")
			button.expand_icon = true
			button.add_theme_constant_override("icon_max_width", 28)
			button.add_theme_constant_override("h_separation", 12)
			break
