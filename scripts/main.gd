extends Control

const JADE := Color("8ed6b5")
const INK := Color("0b2325")
const PAPER := Color("eee9d9")
const Catalog = preload("res://scripts/species_catalog.gd")
const Books = preload("res://scripts/book_progression.gd")
const Structure = preload("res://scripts/combat_structure.gd")
var catalog := Catalog.new()
var books := Books.new()
var structure := Structure.new()
var catalog_rarity := ""
var selected_species := ""
var page := "home"
var body: VBoxContainer
var dialog: ConfirmationDialog
var export_dialog: FileDialog
var toast: Label

func _ready() -> void:
	if not catalog.load_file():
		App.log_event(catalog.last_error)
	if not books.load_file():
		App.log_event(books.last_error)
	if not structure.load_file():
		App.log_event(structure.last_error)
	var ui_theme := Theme.new()
	ui_theme.default_font_size = 24
	ui_theme.set_color("font_color", "Label", PAPER)
	ui_theme.set_color("font_color", "Button", PAPER)
	ui_theme.set_color("font_hover_color", "Button", Color.WHITE)
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		var box := StyleBoxFlat.new()
		box.bg_color = Color("1d4643") if state == "normal" else Color("2a6056")
		if state == "disabled":
			box.bg_color = Color("173333")
		box.set_corner_radius_all(14)
		box.content_margin_left = 24
		box.content_margin_right = 24
		box.content_margin_top = 14
		box.content_margin_bottom = 14
		if state == "focus":
			box.bg_color = Color.TRANSPARENT
			box.set_border_width_all(2)
			box.border_color = JADE
		ui_theme.set_stylebox(state, "Button", box)
	theme = ui_theme
	dialog = ConfirmationDialog.new()
	dialog.title = "Comenzar un nuevo viaje"
	dialog.dialog_text = "Se reemplazará el progreso del viaje actual. Tus ajustes se conservarán."
	dialog.ok_button_text = "Comenzar"
	dialog.cancel_button_text = "Cancelar"
	dialog.confirmed.connect(_start)
	add_child(dialog)
	export_dialog = FileDialog.new()
	export_dialog.title = "Guardar diagnóstico"
	export_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	export_dialog.access = FileDialog.ACCESS_FILESYSTEM
	export_dialog.use_native_dialog = true
	export_dialog.filters = PackedStringArray(["*.txt ; Informe de diagnóstico"])
	export_dialog.file_selected.connect(_write_report)
	add_child(export_dialog)
	get_viewport().size_changed.connect(_safe_margins)
	_show("home")
	if not App.notice.is_empty():
		toast.text = App.notice

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), INK)
	# Abstract jade shapes, not an unapproved geographical map.
	for i in range(7):
		var center := Vector2(size.x * 0.73 + i * 42, size.y * 0.36 + i * 24)
		draw_circle(center, 180 - i * 19, Color(0.12, 0.32, 0.29, 0.18))
	draw_line(Vector2(size.x * 0.60, 0), Vector2(size.x * 0.91, size.y), Color(0.48, 0.78, 0.64, 0.08), 2)

func _safe_margins() -> void:
	var margin := get_node_or_null("Page") as MarginContainer
	if margin == null:
		return
	var left := 44
	var right := 44
	var top := 24
	var bottom := 24
	if OS.get_name() == "Android":
		var safe := DisplayServer.get_display_safe_area()
		var screen := DisplayServer.screen_get_size()
		if screen.x > 0 and screen.y > 0 and safe.size.x > 0:
			var scale := size / Vector2(screen)
			left += int(maxi(0, safe.position.x) * scale.x)
			right += int(maxi(0, screen.x - safe.end.x) * scale.x)
			top += int(maxi(0, safe.position.y) * scale.y)
			bottom += int(maxi(0, screen.y - safe.end.y) * scale.y)
	margin.add_theme_constant_override("margin_left", left)
	margin.add_theme_constant_override("margin_right", right)
	margin.add_theme_constant_override("margin_top", top)
	margin.add_theme_constant_override("margin_bottom", bottom)
	queue_redraw()

func _show(next_page: String) -> void:
	page = next_page
	var old := get_node_or_null("Page")
	if old != null:
		remove_child(old)
		old.queue_free()
	theme.default_font_size = 28 if App.profile.settings.large_text else 24
	var margin := MarginContainer.new()
	margin.name = "Page"
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	margin.add_child(column)
	var header := HBoxContainer.new()
	column.add_child(header)
	var brand := _label("KARMANY MONSTA", 22, JADE)
	brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(brand)
	if page != "home":
		header.add_child(_button("Volver", _back))
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)
	body = VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	scroll.add_child(body)
	match page:
		"home": _home()
		"map": _map()
		"book": _book()
		"settings": _settings()
		"diagnostics": _diagnostics()
		"bestiary": _bestiary()
		"species": _species()
		"trainers": _trainers()
	toast = _label("", 18, JADE)
	toast.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(toast)
	column.add_child(_label("PREVIEW 0.3 · LIBRO Y ENTRENADORES", 16, Color("93aaa3")))
	_safe_margins()

func _label(text: String, font_size: int = 24, color: Color = PAPER) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label

func _copy(text: String) -> void:
	var label := _label(text, theme.default_font_size)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_child(label)

func _heading(text: String) -> void:
	body.add_child(_label(text, 46, PAPER))

func _button(text: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 64)
	button.pressed.connect(func():
		App.tap()
		action.call())
	return button

func _home() -> void:
	_heading("Un viaje en Valle Jade")
	_copy("Ezel y Axe · Karmany Monsta")
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	body.add_child(row)
	var continue_button := _button("Continuar", func(): _show("map"))
	continue_button.disabled = not App.profile.journey.started
	row.add_child(continue_button)
	row.add_child(_button("Comenzar viaje", _new_journey))
	row.add_child(_button("Ajustes", func(): _show("settings")))
	body.add_child(_button("Diagnóstico", func(): _show("diagnostics")))
	_copy("Consulta el bestiario de Valle Jade. Combate, captura e ilustraciones se incorporarán en los siguientes bloques.")

func _new_journey() -> void:
	if App.profile.journey.started or App.load_failed:
		dialog.popup_centered(Vector2i(600, 260))
	else:
		_start()

func _start() -> void:
	if App.start_journey():
		_show("map")
	else:
		toast.text = App.notice

func _map() -> void:
	_heading("Valle Jade")
	_copy("Punto de partida de Ezel y Axe.")
	var button := _button("◆  Valle Jade   ·   " + ("Visitado" if App.profile.journey.visited_jade else "Visitar"), _visit)
	body.add_child(button)
	body.add_child(_button("Consultar el Libro", func(): _show("book")))
	body.add_child(_button("Bestiario de Valle Jade", func(): _show("bestiary")))
	body.add_child(_button("Entrenadores", func(): _show("trainers")))
	_copy("Esta entrega conserva tu visita. Los encuentros y las rutas del primer capítulo llegarán con el contenido jugable.")

func _visit() -> void:
	if App.visit_jade():
		_show("map")
		toast.text = "Visita guardada."
	else:
		toast.text = App.notice

func _book() -> void:
	_heading("El Libro")
	_copy("Sus mejoras permitirán capturar rarezas superiores y aumentar las posibilidades de captura.")
	_copy("Después de derrotar a un Karmany elegible tendrás hasta tres intentos. Si todos fallan, escapará y el encuentro terminará. Podrás encontrarlo de nuevo.")
	_copy("Probabilidades por intento")
	if not books.last_error.is_empty():
		_copy(books.last_error)
	else:
		for level in books.all_levels():
			var policy := books.policy_for(level.id)
			var description: String = level.name + "\n"
			for rarity in ["Común", "Raro", "Épico"]:
				description += rarity + ": " + ("%d%%" % roundi(policy.chance_for(rarity) * 100) if policy.permits(rarity) else "Bloqueado") + "   "
			_copy(description)
	_copy("Esta pantalla consulta las reglas del Libro. Las mejoras y la captura jugable estarán disponibles con el combate.")

func _trainers() -> void:
	_heading("Entrenadores")
	_copy("Las resonancias son habilidades del entrenador que apoyan a sus Karmany.")
	if not structure.last_error.is_empty():
		_copy(structure.last_error)
		return
	var rules := structure.rules()
	_copy("Equipo: hasta %d Karmany · %d activo" % [rules.team_capacity, rules.active_per_side])
	_copy("Cada Karmany tendrá tres habilidades, incluida una insignia, y estadísticas de Vida, Ataque, Defensa y Velocidad.")
	for role in rules.trainer_roles:
		_copy(role.name + "\n" + role.purpose + ".")
	_copy("Las habilidades concretas del entrenador y su funcionamiento en el combate están pendientes de definición.")

func _bestiary() -> void:
	_heading("Bestiario de Valle Jade")
	_copy("Tierras Bajas de Jade · Registros de la enciclopedia de Shisai")
	var filters := HBoxContainer.new()
	filters.add_theme_constant_override("separation", 12)
	body.add_child(filters)
	for rarity in ["", "Común", "Raro", "Épico"]:
		var chosen: String = rarity
		var caption: String = "Todas" if rarity.is_empty() else rarity
		if rarity == catalog_rarity:
			caption = "● " + caption
		filters.add_child(_button(caption, func():
			catalog_rarity = chosen
			_show("bestiary")))
	if not catalog.last_error.is_empty():
		_copy(catalog.last_error)
		return
	var entries := catalog.all_entries(catalog_rarity)
	_copy("%d especies" % entries.size())
	for entry in entries:
		var species_id: String = entry.id
		body.add_child(_button(entry.name + "  ·  " + entry.rarity, func():
			selected_species = species_id
			_show("species")))

func _species() -> void:
	var entry := catalog.find_species(selected_species)
	if entry.is_empty():
		_copy("La ficha solicitada no está disponible.")
		return
	_heading(entry.name)
	_copy(entry.epithet + " · " + entry.rarity)
	_copy(entry.biology)
	_copy("Fisiología\n" + entry.physiology)
	_copy("Comportamiento\n" + entry.behavior)
	_copy("Resonancia lumínica\n" + entry.resonance.luminous)
	_copy("Resonancia sombría\n" + entry.resonance.shadow)

func _settings() -> void:
	_heading("Ajustes")
	for key in ["large_text", "haptics"]:
		var current_key: String = key
		var title := "Texto grande" if key == "large_text" else "Vibración al tocar"
		var enabled: bool = App.profile.settings[key]
		var button := _button(title + (" · Activado" if enabled else " · Desactivado"), func(): _toggle(current_key))
		button.disabled = App.load_failed
		body.add_child(button)
	_copy("Los ajustes se guardan al cambiarlos.")

func _toggle(key: String) -> void:
	if App.set_preference(key, not App.profile.settings[key]):
		_show("settings")
		toast.text = "Ajuste guardado."
	else:
		toast.text = App.notice

func _diagnostics() -> void:
	_heading("Diagnóstico")
	_copy(App.diagnostic_report())
	body.add_child(_button("Exportar informe", _export_report))
	body.add_child(_button("Copiar informe", func():
		DisplayServer.clipboard_set(App.diagnostic_report())
		toast.text = "Informe copiado."))

func _export_report() -> void:
	export_dialog.current_file = "karmany-diagnostico.txt"
	export_dialog.popup_centered_ratio(0.8)

func _write_report(path: String) -> void:
	var handle := FileAccess.open(path, FileAccess.WRITE)
	if handle == null:
		toast.text = "No se pudo exportar. Puedes copiar el informe."
		return
	handle.store_string(App.diagnostic_report())
	handle.flush()
	toast.text = "Informe exportado." if handle.get_error() == OK else "No se pudo completar la exportación."

func _back() -> void:
	if export_dialog.visible:
		export_dialog.hide()
	elif dialog.visible:
		dialog.hide()
	elif page == "species":
		_show("bestiary")
	elif page == "bestiary" or page == "trainers":
		_show("map")
	elif page != "home":
		_show("home")
	else:
		App.log_event("Salida solicitada.")
		get_tree().quit()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST or what == NOTIFICATION_WM_CLOSE_REQUEST:
		_back()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_back()
		get_viewport().set_input_as_handled()
