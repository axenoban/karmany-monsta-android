extends RefCounted

static func create() -> Theme:
	var result := Theme.new()
	result.default_font_size = 24
	result.set_color("font_color", "Label", Color("f4f5e7"))
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		var box := StyleBoxFlat.new()
		box.bg_color = Color("164858") if state == "normal" else Color("24647a")
		box.border_color = Color("7dc8d0")
		if state == "pressed": box.bg_color = Color("102c40")
		if state == "disabled":
			box.bg_color = Color("203c48")
			box.border_color = Color("49646d")
		box.set_border_width_all(2)
		box.set_corner_radius_all(18)
		box.content_margin_left = 18
		box.content_margin_right = 18
		box.content_margin_top = 12
		box.content_margin_bottom = 12
		box.shadow_color = Color(0, 0.04, 0.08, 0.35)
		box.shadow_size = 3
		if state == "focus":
			box.bg_color = Color.TRANSPARENT
			box.border_color = Color("ffe399")
			box.set_border_width_all(3)
		result.set_stylebox(state, "Button", box)
	result.set_color("font_color", "Button", Color("fff4d5"))
	result.set_color("font_hover_color", "Button", Color.WHITE)
	result.set_color("font_disabled_color", "Button", Color("a9bcc3"))
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color("102d40")
	panel.border_color = Color("dcbe72")
	panel.set_border_width_all(2)
	panel.set_corner_radius_all(18)
	panel.set_content_margin_all(16)
	result.set_stylebox("panel", "AcceptDialog", panel)
	result.set_stylebox("panel", "PanelContainer", panel)
	for style in ["background", "fill"]:
		var bar := StyleBoxFlat.new()
		bar.bg_color = Color("162b40") if style == "background" else Color("79d8aa")
		bar.set_corner_radius_all(10)
		result.set_stylebox(style, "ProgressBar", bar)
	return result
