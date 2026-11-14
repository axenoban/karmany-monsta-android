extends Control
## Vista transitoria de consultas de combate. No posee estado de partida ni altera turnos.
signal dismissed

var content: VBoxContainer
var tabs: TabContainer
var _shell: Panel
var _large := false
var _closing := false
var _status: Label

func setup(caption: String, large_text: bool = false) -> void:
	name = "CombatContextPanel"
	add_to_group("combat_context_panel")
	_large = large_text
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var scrim := ColorRect.new()
	scrim.name = "PanelScrim"
	scrim.color = Color(0.015, 0.045, 0.045, 0.53)
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(scrim)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Panel (no PanelContainer) no expande su rectangulo por el minimum_size
	# de las pestañas; el contenido largo se desplaza dentro del scroll.
	_shell = Panel.new()
	_shell.name = "PanelSurface"
	_shell.mouse_filter = Control.MOUSE_FILTER_STOP
	var style := StyleBoxFlat.new()
	style.bg_color = Color("112d30")
	style.border_color = Color("85c9ae")
	style.set_border_width_all(2)
	style.set_corner_radius_all(16)
	style.set_content_margin_all(14)
	_shell.add_theme_stylebox_override("panel", style)
	add_child(_shell)

	var vertical := VBoxContainer.new()
	vertical.name = "PanelLayout"
	vertical.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vertical.offset_left = 14.0
	vertical.offset_right = -14.0
	vertical.offset_top = 14.0
	vertical.offset_bottom = -14.0
	vertical.add_theme_constant_override("separation", 10)
	_shell.add_child(vertical)
	var heading := HBoxContainer.new()
	vertical.add_child(heading)
	var label := _label(caption, 27)
	label.name = "PanelTitle"
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	heading.add_child(label)
	var close_button := Button.new()
	close_button.name = "ClosePanel"
	close_button.text = "Cerrar"
	close_button.custom_minimum_size = Vector2(98, 54)
	close_button.pressed.connect(close_panel)
	heading.add_child(close_button)
	var line := HSeparator.new()
	vertical.add_child(line)
	var scroll := ScrollContainer.new()
	scroll.name = "PanelScroll"
	scroll.custom_minimum_size = Vector2.ZERO
	scroll.clip_contents = true
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vertical.add_child(scroll)
	content = VBoxContainer.new()
	content.name = "PanelBody"
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 10)
	scroll.add_child(content)
	_status = _label("", 19)
	_status.name = "PanelNotice"
	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status.hide()
	vertical.add_child(_status)
	resized.connect(_layout)
	_layout()
	close_button.grab_focus.call_deferred()

func _layout() -> void:
	if _shell == null or size.x < 1 or size.y < 1: return
	# La escena puede calcular un mínimo mayor que el viewport con texto grande.
	# El panel debe ajustarse a la zona visible, y desplazar su contenido internamente.
	var viewport: Vector2 = get_viewport_rect().size
	var available := Vector2(
		minf(size.x, maxf(200.0, viewport.x - global_position.x)),
		minf(size.y, maxf(200.0, viewport.y - global_position.y))
	)
	if available.x >= 1080.0 and available.y >= 560.0:
		var panel_width := minf(560.0, available.x * 0.46)
		_shell.position = Vector2(available.x - panel_width - 10.0, 8.0)
		_shell.size = Vector2(panel_width, available.y - 16.0)
	else:
		var top := maxf(8.0, available.y * 0.34)
		_shell.position = Vector2(8.0, top)
		_shell.size = Vector2(maxf(190.0, available.x - 16.0), maxf(160.0, available.y - top - 8.0))

func _label(value: String, font_size: int = 21) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size + (3 if _large else 0))
	return label

func add_text(value: String, font_size: int = 21) -> Label:
	var label := _label(value, font_size)
	content.add_child(label)
	return label

func add_action(caption: String, callback: Callable, disabled: bool = false) -> Button:
	var button := Button.new()
	button.name = "PanelAction"
	button.text = caption
	button.disabled = disabled
	button.custom_minimum_size.y = 56
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.add_theme_font_size_override("font_size", 22 if _large else 19)
	button.pressed.connect(callback)
	content.add_child(button)
	return button

func set_notice(value: String) -> void:
	if _status == null: return
	_status.text = value
	_status.visible = not value.is_empty()

func close_panel() -> void:
	if _closing: return
	_closing = true
	dismissed.emit()
	queue_free()

func handle_back() -> bool:
	if _closing or not is_visible_in_tree(): return false
	close_panel()
	return true

func _detail_label(parent: Node, value: String, font_size: int = 19) -> void:
	parent.add_child(_label(value, font_size))

func _unit(parent: Node, unit: Dictionary) -> void:
	_detail_label(parent, "%s · Nv. %d · %s" % [unit.get("name", ""), int(unit.get("level", 1)), unit.get("role", "")], 22)
	_detail_label(parent, "Vida %d/%d · Ataque %d · Defensa %d" % [int(unit.get("hp", 0)), int(unit.get("max_hp", 0)), int(unit.get("attack", 0)), int(unit.get("defense", 0))])
	var bar := ProgressBar.new()
	bar.max_value = maxf(1, float(unit.get("max_hp", 1)))
	bar.value = float(unit.get("hp", 0))
	bar.show_percentage = false
	bar.custom_minimum_size.y = 16
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(bar)
	_detail_label(parent, str(unit.get("effects", "")))
	_detail_label(parent, str(unit.get("signature_ready", "")), 18)
	parent.add_child(HSeparator.new())

func _technique(parent: Node, skill: Dictionary) -> void:
	_detail_label(parent, str(skill.get("name", "")), 22)
	_detail_label(parent, str(skill.get("description", "")))
	var cooldown := int(skill.get("cooldown", 0))
	_detail_label(parent, "Sin recarga." if cooldown == 0 else "Recarga: %d turnos completos." % cooldown, 18)
	if int(skill.get("ready_turn", 0)) > int(get_meta("readout_turn", 0)):
		_detail_label(parent, "Disponible en turno %d." % int(skill.ready_turn), 18)
	_detail_label(parent, "Disponible." if str(skill.get("status", "")).is_empty() else "No disponible: " + str(skill.status), 18)
	parent.add_child(HSeparator.new())

func populate_details(readout: Dictionary) -> void:
	set_meta("readout_turn", int(readout.get("turn", 0)))
	tabs = TabContainer.new()
	tabs.name = "CombatDetailTabs"
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs.custom_minimum_size.y = 240
	content.add_child(tabs)
	for caption in ["Activos", "Equipo", "Técnicas", "Resonancias"]:
		var scroll := ScrollContainer.new()
		scroll.name = caption
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tabs.add_child(scroll)
		var list := VBoxContainer.new()
		list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		list.add_theme_constant_override("separation", 8)
		scroll.add_child(list)
		_detail_label(list, str(readout.get("phase", "")), 18)
		match caption:
			"Activos":
				_unit(list, readout.active)
				_unit(list, readout.enemy)
			"Equipo":
				for unit in readout.get("team", []): _unit(list, unit)
			"Técnicas":
				for skill in readout.get("skills", []): _technique(list, skill)
			"Resonancias":
				var resonances: Array = readout.get("resonances", [])
				if resonances.is_empty(): _detail_label(list, "No hay resonancias equipadas.")
				for skill in resonances: _technique(list, skill)
