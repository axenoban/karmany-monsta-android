extends RefCounted
# Jade nocturno: shared runtime styling. Text remains live and accessible.
const INK = Color("082522")
const PANEL = Color("103c34")
const JADE = Color("83ddb3")
const GOLD = Color("d8c18b")
const PAPER = Color("f4efdf")

static func box(fill: Color, edge: Color, padding: int = 16) -> StyleBoxFlat:
	var result := StyleBoxFlat.new()
	result.bg_color = fill
	result.border_color = edge
	result.set_border_width_all(1)
	result.set_corner_radius_all(5)
	result.set_content_margin_all(padding)
	result.shadow_color = Color(0.01, 0.04, 0.03, 0.3)
	result.shadow_size = 4
	return result


static func cut_panel(id: String, padding: int = 12) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = load("res://assets/ui/jade/" + id + ".svg")
	for side in [SIDE_LEFT,SIDE_TOP,SIDE_RIGHT,SIDE_BOTTOM]:
		style.set_texture_margin(side, 14)
		style.set_content_margin(side, padding)
	style.content_margin_left = 20
	style.content_margin_right = 20
	return style

static func create() -> Theme:
	var result := Theme.new()
	result.default_font_size = 24
	result.set_color("font_color", "Label", PAPER)
	for kind in ["HBoxContainer", "VBoxContainer", "GridContainer"]:
		result.set_constant("separation", kind, 8)
	result.set_constant("h_separation", "GridContainer", 16)
	result.set_constant("v_separation", "GridContainer", 16)
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		var fill := PANEL
		var edge := Color("648d78")
		if state == "hover":
			fill = Color("195446"); edge = JADE
		elif state == "pressed":
			fill = Color("27624c"); edge = GOLD
		elif state == "disabled":
			fill = Color("20352f"); edge = Color("52665b")
		elif state == "focus":
			fill = Color.TRANSPARENT; edge = GOLD
		var style := box(fill, edge, 12)
		style.content_margin_left = 20
		style.content_margin_right = 20
		if state == "focus": style.set_border_width_all(2)
		result.set_stylebox(state, "Button", style if state == "focus" else cut_panel(state))
	for color_name in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		result.set_color(color_name, "Button", PAPER)
	result.set_color("font_disabled_color", "Button", Color("a5b4aa"))
	result.set_type_variation("JadePrimary", "Button")
	result.set_stylebox("normal", "JadePrimary", cut_panel("primary"))
	result.set_type_variation("JadeSelected", "Button")
	result.set_stylebox("normal", "JadeSelected", cut_panel("selected"))
	for kind in ["AcceptDialog", "PanelContainer", "PopupPanel"]:
		result.set_stylebox("panel", kind, cut_panel("panel",14))
	for style in ["background", "fill"]:
		result.set_stylebox(style, "ProgressBar", box(Color("0c211c") if style == "background" else JADE, Color("567764"), 0))
	result.set_stylebox("slider", "HSlider", box(INK, Color("638b76"), 4))
	result.set_stylebox("grabber_area", "HSlider", box(JADE, JADE, 4))
	result.set_stylebox("grabber_area_highlight", "HSlider", box(GOLD, GOLD, 4))
	var knob := GradientTexture2D.new()
	knob.width = 28; knob.height = 28
	knob.gradient = Gradient.new()
	knob.gradient.colors = PackedColorArray([PAPER, GOLD])
	for icon in ["grabber", "grabber_highlight", "grabber_disabled"]:
		result.set_icon(icon, "HSlider", knob)
	return result

static func decorate(button: Button) -> void:
	var icons := {"Volver":"back", "Equipo":"team", "Libro":"book", "Ajustes":"settings", "Bestiario":"leaf", "Golpe":"attack", "Protección":"shield", "Insignia":"leaf", "Detalles":"info"}
	for caption in icons:
		if button.text == caption:
			button.icon = load("res://assets/ui/jade/icon_" + icons[caption] + ".svg")
			button.expand_icon = true
			button.add_theme_constant_override("icon_max_width", 28)
			button.add_theme_constant_override("h_separation", 12)
			break
