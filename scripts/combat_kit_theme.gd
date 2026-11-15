extends RefCounted
## Presentation adapter for the approved-to-test PvP kit; no gameplay state.
const Base = preload("res://scripts/adventure_theme.gd")
const ROOT := "res://assets/ui/combat_kit/"

static func surface(id: String, margin: int = 14, padding: int = 10) -> StyleBoxTexture:
	var result := StyleBoxTexture.new()
	result.texture = load(ROOT + id + ".svg")
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		result.set_texture_margin(side, margin)
		result.set_content_margin(side, padding)
	return result

static func create() -> Theme:
	# A local theme on battle views keeps every other screen on its baseline.
	var result := Base.create()
	for variation in ["Button", "JadePrimary", "JadeSelected", "JadeQuiet", "JadeNav", "JadeDanger"]:
		var prefix := "secondary" if variation in ["JadeQuiet", "JadeNav"] else "button"
		for state in ["normal", "hover", "pressed", "disabled"]:
			var asset_state: String = "selected" if variation == "JadeSelected" and state == "normal" else state
			result.set_stylebox(state, variation, surface(prefix + "_" + asset_state, 16, 10))
		var focus := StyleBoxFlat.new()
		focus.bg_color = Color.TRANSPARENT
		focus.border_color = Base.PAPER
		focus.set_border_width_all(2)
		focus.set_corner_radius_all(6)
		focus.set_content_margin_all(0)
		result.set_stylebox("focus", variation, focus)
		result.set_color("font_disabled_color", variation, Color("a5b0a7"))
	for kind in ["AcceptDialog", "PanelContainer", "PopupPanel", "JadeCard"]:
		result.set_stylebox("panel", kind, surface("detail_panel", 24, 14))
	result.set_stylebox("background", "ProgressBar", surface("hp_track", 6, 0))
	result.set_stylebox("fill", "ProgressBar", surface("hp_fill", 6, 0))
	return result

static func decorate(button: Button, action_id: String = "") -> void:
	var icon_id: String = {"golpe": "golpe", "guardia": "proteccion", "insignia": "insignia"}.get(action_id, "")
	if icon_id.is_empty():
		icon_id = {"Golpe": "golpe", "Protección": "proteccion", "Insignia": "insignia", "Táctica": "proteccion", "Equipo": "equipo", "Estado y técnicas": "info", "Volver al combate": "back", "Cerrar": "close"}.get(button.text, "")
	if icon_id.is_empty(): return
	button.icon = load(ROOT + ("ico_lock" if button.disabled else "ico_" + icon_id) + ".svg")
	button.expand_icon = true
	button.add_theme_constant_override("icon_max_width", 28)
	button.add_theme_constant_override("h_separation", 12)
