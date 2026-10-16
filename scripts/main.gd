extends Control

const Progress = preload("res://scripts/level_progression.gd")
const ProgressRules = preload("res://scripts/progression_rules.gd")
const JADE:= Color("8ed6b5")
const INK:= Color("0b2325")
const PAPER:= Color("eee9d9")
const Catalog = preload("res://scripts/species_catalog.gd")
const Books = preload("res://scripts/book_progression.gd")
const Structure = preload("res://scripts/combat_structure.gd")
const TreeModel = preload("res://scripts/trainer_skill_tree.gd")
const Roster = preload("res://scripts/trial_roster.gd")
const TrialUI = preload("res://scripts/trial_ui.gd")
const Stage = preload("res://scripts/trial_stage.gd")
const AdventureTheme = preload("res://scripts/adventure_theme.gd")
var tree_scroll_position:= 0
var tree_pan := Vector2.ZERO
var intro_dismissed := false
var intro_replay := false
var prologue: Control
const Portrait = preload("res://scripts/r1_portrait.gd")
const TreeMap = preload("res://scripts/skill_tree_map.gd")
var catalog:= Catalog.new()
var books:= Books.new()
var structure:= Structure.new()
var catalog_rarity:= ""
var selected_species:= ""
var selected_tree_node:= "curacion"
var page:= "home"
var navigation := preload("res://scripts/navigation_history.gd").new()
var body: VBoxContainer
var dialog: ConfirmationDialog
var export_dialog: FileDialog
var toast: Label

func _ready() -> void :
	App.combat_updated.connect(_refresh_combat)
	App.profile_changed.connect(func(): navigation.reset())
	if not catalog.load_file():
		App.log_event(catalog.last_error)
	if not books.load_file():
		App.log_event(books.last_error)
	if not structure.load_file():
		App.log_event(structure.last_error)
	theme = AdventureTheme.create()
	dialog = ConfirmationDialog.new()
	dialog.title = "Comenzar un nuevo viaje"
	dialog.dialog_text = "Se reemplazarán el viaje, el árbol, la colección y el encuentro actuales. Tus ajustes se conservarán."
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

func _draw() -> void :
	draw_rect(Rect2(Vector2.ZERO, size), INK)

	for i in range(7):
		var center:= Vector2(size.x * 0.73 + i * 42, size.y * 0.36 + i * 24)
		draw_circle(center, 180 - i * 19, Color(0.12, 0.32, 0.29, 0.18))
	draw_line(Vector2(size.x * 0.6, 0), Vector2(size.x * 0.91, size.y), Color(0.48, 0.78, 0.64, 0.08), 2)

func _safe_margins() -> void :
	var margin:= get_node_or_null("Page") as MarginContainer
	if margin == null:
		return
	var left:= 44
	var right:= 44
	var top:= 66 if App.qa_active else 24
	var bottom:= 24
	if OS.get_name() == "Android":
		var safe:= DisplayServer.get_display_safe_area()
		var screen:= DisplayServer.screen_get_size()
		if screen.x > 0 and screen.y > 0 and safe.size.x > 0:
			var scale:= size / Vector2(screen)
			left += int(maxi(0, safe.position.x) * scale.x)
			right += int(maxi(0, screen.x - safe.end.x) * scale.x)
			top += int(maxi(0, safe.position.y) * scale.y)
			bottom += int(maxi(0, screen.y - safe.end.y) * scale.y)
	margin.add_theme_constant_override("margin_left", left)
	margin.add_theme_constant_override("margin_right", right)
	margin.add_theme_constant_override("margin_top", top)
	margin.add_theme_constant_override("margin_bottom", bottom)
	queue_redraw()

func _show(next_page: String, record_history: bool = true) -> void :
	if next_page not in navigation.ROUTES: return
	if record_history: navigation.visit(page, next_page)
	page = next_page
	var old:= get_node_or_null("Page")
	if old != null:
		remove_child(old)
		old.queue_free()
	theme.default_font_size = 28 if App.profile.settings.large_text else 24
	var margin:= MarginContainer.new()
	margin.name = "Page"
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(margin)
	var column:= VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	margin.add_child(column)
	var header:= HBoxContainer.new()
	column.add_child(header)
	if App.qa_active:
		var overlay := CanvasLayer.new()
		overlay.layer = 100
		margin.add_child(overlay)
		var strip := ColorRect.new()
		strip.color = INK
		strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		strip.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
		strip.offset_bottom = 42
		overlay.add_child(strip)
		var banner := _label("LABORATORIO QA · NO AFECTA TU PARTIDA", 24, JADE)
		banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		banner.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
		strip.add_child(banner)
		banner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		if page != "tree_lab": column.add_child(_button("Volver al laboratorio QA", func(): _show("tree_lab")))
	var brand:= _label("KARMANY MONSTA", 22, JADE)
	brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(brand)
	if page != "home":
		header.add_child(_button("Volver", _back))
	var scroll:= ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.scroll_deadzone = 18
	if page == "skill_tree":
		scroll.set_deferred("scroll_vertical", tree_scroll_position)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)
	body = VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	scroll.add_child(body)
	match page:
		"home": _home()
		"prologue": _prologue()
		"map": _map()
		"book": _book()
		"settings": _settings()
		"diagnostics": _diagnostics()
		"bestiary": _bestiary()
		"species": _species()
		"trainers": _trainers()
		"skill_tree": _skill_tree()
		"loadout": _loadout()
		"tree_lab": _tree_lab()
		"intro", "jade_play", "battle", "exploration": _playable()
		"collection": _collection()
		"team": _team()
	toast = _label("", 18, JADE)
	toast.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if page in ["intro", "jade_play", "battle", "exploration"]:
		toast.hide()
	column.add_child(toast)
	column.add_child(_label("PREVIEW %s · SHISAI" % App.build_info.get("version", "0.13.0"), 16, Color("93aaa3")))
	_safe_margins()

func _label(text: String, font_size: int = 24, color: Color = PAPER) -> Label:
	var label:= Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label

func _copy(text: String) -> void :
	var label:= _label(text, theme.default_font_size)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_child(label)

func _heading(text: String) -> void :
	body.add_child(_label(text, 46, PAPER))

func _button(text: String, action: Callable) -> Button:
	var button:= Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 64)
	var epoch: int = App.ui_epoch
	button.pressed.connect( func():
		if epoch != App.ui_epoch: return
		App.tap()
		action.call())
	return button

func _home() -> void:
	_heading("Karmany Monsta")
	_copy("El viaje de Ezel · Zephyr, tu compañero · Axe, tu mentor")
	var resume := _button("Continuar aventura", _continue_adventure)
	resume.disabled = not App.profile.journey.started or App.load_failed
	body.add_child(resume)
	body.add_child(_button("Nueva partida", _new_journey))
	body.add_child(_button("Ajustes", func(): _show("settings")))

func _continue_adventure() -> void:
	if not App.profile.journey.started: return
	var encounter: Dictionary = App.profile.campaign.encounter
	if not encounter.is_empty() and encounter.get("phase") in ["battle", "replacement", "capture"]:
		_show("exploration" if App.profile.campaign.get("exploration", {}).get("scouting", false) else "battle")
	elif not intro_dismissed and App.profile.get("r1_intro", {}).get("status") == "pending" and not App.profile.journey.visited_jade:
		intro_replay = false
		_show("prologue")
	else: _show("map")

func _prologue() -> void:
	var scroll := body.get_parent()
	var column := scroll.get_parent()
	column.remove_child(scroll)
	scroll.queue_free()
	prologue = preload("res://scripts/r1_prologue.gd").new()
	prologue.reduced = App.profile.settings.reduced_motion
	prologue.large = App.profile.settings.large_text
	prologue.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(prologue)
	prologue.finished.connect(func(status: String):
		var saved := true
		if not intro_replay:
			intro_dismissed = true
			saved = App.finish_r1_intro(status)
		_show("settings" if intro_replay else "map", false)
		if not saved: toast.text = App.notice + " La introducción no se marcó como vista.")

func _new_journey() -> void :
	if App.profile.journey.started or App.load_failed:
		dialog.popup_centered(Vector2i(600, 260))
	else:
		_start()

func _start() -> void :
	if App.start_journey():
		navigation.reset()
		intro_dismissed = false
		intro_replay = false
		_show("prologue", false)
	else:
		toast.text = App.notice

func _map() -> void:
	_heading("Shisai · Regiones")
	_copy("Elige una región. La stamina se gasta al entrar en una localización.")
	for region_id in ["jade", "veil"]:
		var id: String = region_id
		var region := ProgressRules.region(id)
		var panel := PanelContainer.new()
		body.add_child(panel)
		var card := VBoxContainer.new()
		panel.add_child(card)
		var art := TextureRect.new()
		art.texture = Stage.texture("jade_point_1" if id == "jade" else "veil_bamboo")
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		art.custom_minimum_size.y = 160
		card.add_child(art)
		var complete: int = preload("res://scripts/jade_route.gd").completions(App.profile.campaign.route, id).size()
		card.add_child(_label("%s · %d/6 completadas" % [region.name, complete]))
		var reason := ProgressRules.region_reason(App.profile.skill_tree, id)
		var state := _label("Disponible" if reason.is_empty() else reason)
		state.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card.add_child(state)
		var needs_buy: bool = int(region.cost) > 0 and id not in App.profile.skill_tree.unlocks
		var open := _button("Desbloquear · %d punto" % int(region.cost) if needs_buy else "Explorar región", func(): _open_region(id, needs_buy))
		open.disabled = App.load_failed or int(App.profile.skill_tree.level) < int(region.min_level) or _encounter_in_progress()
		card.add_child(open)
	if _encounter_in_progress(): body.add_child(_button("Retomar aventura", _continue_adventure))
	for entry in [["Libro", "book"], ["Bestiario", "bestiary"], ["Ezel · Perfil", "trainers"], ["Equipo", "team"], ["Árbol de resonancias", "skill_tree"], ["Ajustes", "settings"]]:
		var target: String = entry[1]
		body.add_child(_button(entry[0], func(): _show(target)))

func _open_region(id: String, buy: bool) -> void:
	if buy:
		var confirm := ConfirmationDialog.new()
		confirm.dialog_text = "Desbloquear %s cuesta %d punto permanente del árbol." % [ProgressRules.region(id).name, int(ProgressRules.region(id).cost)]
		add_child(confirm)
		confirm.confirmed.connect(func():
			if App.purchase_unlock(id): _open_region(id, false)
			else: toast.text = App.notice
			confirm.queue_free())
		confirm.canceled.connect(confirm.queue_free)
		confirm.popup_centered(Vector2i(620,240))
	elif App.select_region(id): _show("jade_play")
	else: toast.text = App.notice

func _book() -> void :
	_heading("El Libro")
	var tree:= _tree_model()
	var current:= ProgressRules.current_book(tree.state)
	_copy("Entrenador Nv. %d · %d puntos disponibles" % [tree.state.level, tree.points_available()])
	_copy("Hasta tres intentos tras derrotar al rival. Las mejoras se aplican al siguiente encuentro.")
	for level in books.all_levels():
		var policy:= books.policy_for(level.id)
		var status:= " · EQUIPADO" if level.id == current else (" · Adquirido" if level.id == "book_initial" or level.id in tree.state.unlocks else (" · Disponible" if tree.unlock_reason(level.id).is_empty() else " · Bloqueado"))
		_copy(level.name + status)
		var chances: Array[String] = []
		for rarity in ["Común", "Raro", "Épico"]:
			chances.append(rarity + ": " + ("%d%%" % roundi(policy.chance_for(rarity) * 100) if policy.permits(rarity) else "Bloqueado"))
		_copy(" · ".join(chances))
		var requirement:= ProgressRules.unlock(level.id)
		if not requirement.is_empty():
			_copy("Requiere Nv. %d · Coste %d punto(s)" % [requirement.min_level, requirement.cost])
			var reason:= tree.unlock_reason(level.id)
			var id: String = level.id
			var buy:= _button("Adquirir " + level.name, func(): _confirm_book_upgrade(id))
			buy.disabled = not reason.is_empty() or _encounter_in_progress() or App.load_failed
			body.add_child(buy)
			if not reason.is_empty(): _copy(reason)
	if _encounter_in_progress(): _copy("Termina el encuentro para adquirir mejoras. El Libro usado en él se conserva.")
	body.add_child(_button("Redistribuir resonancias", _confirm_redistribute))
	_copy("Los puntos de libros permanecen gastados al redistribuir. Raros y épicos requieren encuentros de esas rarezas en futuras regiones.")

func _confirm_book_upgrade(id: String) -> void :
	var definition:= ProgressRules.unlock(id)
	var confirm:= ConfirmationDialog.new()
	confirm.dialog_text = "Adquirir %s por %d punto(s). La mejora es permanente y usará puntos compartidos con las resonancias." % [definition.name, definition.cost]
	add_child(confirm)
	confirm.confirmed.connect( func():
		if App.purchase_unlock(id):
			_show("book")
			toast.text = "Libro mejorado."
		else: toast.text = App.notice
		confirm.queue_free())
	confirm.canceled.connect(confirm.queue_free)
	confirm.popup_centered(Vector2i(620, 240))

func _confirm_redistribute() -> void :
	var confirm:= ConfirmationDialog.new()
	confirm.dialog_text = "Se devolverán los puntos de resonancias y se vaciarán las equipadas. Libros y otros desbloqueos conservarán su coste."
	add_child(confirm)
	confirm.confirmed.connect( func():
		if App.redistribute_resonances():
			_show("skill_tree")
			toast.text = "Puntos de resonancias recuperados."
		else: toast.text = App.notice
		confirm.queue_free())
	confirm.canceled.connect(confirm.queue_free)
	confirm.popup_centered(Vector2i(620, 240))

func _portrait(id: String, hidden_species: bool = false) -> Control:
	var art := Portrait.new()
	art.setup(id, hidden_species)
	return art

func _trainers() -> void:
	_heading("Ezel · Tu perfil")
	body.add_child(_portrait("ezel"))
	var tree := _tree_model()
	_copy("Nivel %d · XP %d/%d · %d puntos disponibles" % [tree.state.level, App.profile.campaign.progression.trainer_xp, Progress.requirement(int(tree.state.level)), tree.points_available()])
	_copy("Resonancias equipadas")
	if tree.state.equipped.is_empty(): _copy("No hay resonancias equipadas.")
	for id in tree.state.equipped:
		_copy("%s · Rango %d" % [TreeModel.node_definition(id).name, int(tree.state.ranks[id])])
	_copy("Tu equipo")
	for member in App.profile.campaign.team.members:
		var row := HBoxContainer.new()
		body.add_child(row)
		row.add_child(_portrait(member.species_id))
		var text := _label("%s · %s\n%s" % [Roster.member_name(member), "Activo" if member.instance_id == App.profile.campaign.team.active_id else "Reserva", Progress.summary(App.profile.campaign, member.instance_id)])
		text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(text)
	for entry in [["Equipo", "team"], ["Árbol de resonancias", "skill_tree"], ["Libro", "book"]]:
		var target: String = entry[1]
		body.add_child(_button(entry[0], func(): _show(target)))

func _tree_model() -> TrainerSkillTree:
	var tree:= TreeModel.new()
	tree.restore(App.profile.skill_tree)
	return tree

func _skill_tree() -> void :
	var tree:= _tree_model()
	var slots:= int(TreeModel.specification().equip_slots)
	_heading("Árbol de resonancias")
	_copy("Nivel %d · %d puntos disponibles · %d/%d equipadas" % [tree.state.level, tree.points_available(), tree.state.equipped.size(), slots])
	_copy("Equipa hasta cuatro resonancias. El encuentro usa tu selección al comenzar.")
	var map:= TreeMap.new()
	map.setup(TreeModel.specification(), tree.snapshot(), selected_tree_node, App.profile.settings.large_text)
	map.pan = tree_pan
	map.pan_changed.connect(func(value: Vector2): tree_pan = value)
	map.node_selected.connect(_select_tree_node)
	body.add_child(map)
	var node:= TreeModel.node_definition(selected_tree_node)
	var chosen_node: String = selected_tree_node
	var rank_value:= int(tree.state.ranks.get(selected_tree_node, 0))
	_copy(node.name + " · " + ("Exclusiva provisional" if node.branch == "personal" else "General"))
	_copy(node.description)
	if rank_value > 0:
		var next_rank:= "Rango máximo" if rank_value >= node.max_rank else "Siguiente rango: %d%%" % roundi((1.0 + rank_value * float(TreeModel.specification().rank_power_step)) * 100)
		_copy("Potencia de rango: %d%% · %s" % [roundi(tree.power_multiplier(selected_tree_node) * 100), next_rank])
	var reason:= tree.purchase_reason(selected_tree_node)
	_copy("Aprender o mejorar cuesta 1 punto." if reason.is_empty() else reason)
	var actions:= HBoxContainer.new()
	actions.add_theme_constant_override("separation", 12)

	get_node("Page").get_child(0).add_child(actions)
	var purchase:= _button(("Aprender " if rank_value == 0 else "Mejorar ") + node.name + " · 1 punto", func(): _tree_action("purchase", chosen_node, "skill_tree", rank_value))
	purchase.disabled = not reason.is_empty() or App.load_failed
	actions.add_child(purchase)
	var equipped: bool = tree.state.equipped.has(selected_tree_node)
	if not equipped and rank_value > 0 and tree.state.equipped.size() >= slots:
		_copy("Los %d espacios están ocupados. Retira una resonancia para cambiarla." % slots)
	var equip:= _button("Retirar" if equipped else "Equipar", func(): _tree_action("unequip" if equipped else "equip", chosen_node, "skill_tree"))
	equip.disabled = rank_value == 0 or ( not equipped and tree.state.equipped.size() >= slots) or App.load_failed
	actions.add_child(equip)
	actions.add_child(_button("Ver equipadas", func(): _show("loadout")))
	body.add_child(_button("Redistribuir resonancias", _confirm_redistribute))
	_copy("Para probar niveles y bonificaciones: Diagnóstico → Laboratorio del árbol.")

func _loadout() -> void :
	_heading("Resonancias equipadas")
	var tree:= _tree_model()
	var slots:= int(TreeModel.specification().equip_slots)
	_copy("%d espacios en total. Aprender una resonancia no la equipa automáticamente." % slots)
	for i in range(slots):
		if i < tree.state.equipped.size():
			var node_id: String = tree.state.equipped[i]
			var definition:= TreeModel.node_definition(node_id)
			_copy("%d · %s · Rango %d" % [i + 1, definition.name, int(tree.state.ranks[node_id])])
			body.add_child(_button("Retirar " + definition.name, func(): _tree_action("unequip", node_id, "loadout")))
		else:
			_copy("%d · Espacio libre" % (i + 1))

func _tree_action(operation: String, node_id: String, return_page: String, expected_rank: int = -1) -> void :
	if App.change_tree(operation, node_id, expected_rank):
		_show(return_page)
		toast.text = "Árbol guardado."
	else:
		toast.text = App.notice

func _tree_lab() -> void:
	if not App.qa_active or not App.qa_available():
		_copy("El laboratorio requiere una sesión QA aislada en una build preview.")
		return
	_heading("Laboratorio QA")
	var lab := preload("res://scripts/qa_lab.gd").new()
	body.add_child(lab)
	lab.launch.connect(func(point_id: String):
		if App.start_route(point_id): _show("exploration")
		else: lab.message.text = App.notice)
	lab.leave.connect(_exit_qa)

func _enter_qa() -> void:
	var confirm := ConfirmationDialog.new()
	confirm.dialog_text = "Entrar al laboratorio crea una sesión sintética separada. No afecta tu partida."
	add_child(confirm)
	confirm.confirmed.connect(func():
		if App.enter_qa(): _show("tree_lab", false)
		else: toast.text = App.notice
		confirm.queue_free())
	confirm.canceled.connect(confirm.queue_free)
	confirm.popup_centered(Vector2i(620,260))

func _exit_qa() -> void:
	if App.exit_qa(): _show("map", false)
	else: toast.text = App.notice

func _bestiary() -> void :
	_heading("Bestiario de Shisai")
	_copy("Valle Jade y Bosque del Velo · Registros de la enciclopedia de Shisai")
	var filters:= HBoxContainer.new()
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
	var entries:= catalog.all_entries(catalog_rarity)
	_copy("%d especies" % entries.size())
	for entry in entries:
		var species_id: String = entry.id
		var known := _species_owned(species_id)
		var row := HBoxContainer.new()
		body.add_child(row)
		row.add_child(_portrait(species_id, not known))
		var button := _button(entry.name + " · " + entry.rarity + ("" if known else " · Sin vincular"), func():
			selected_species = species_id
			_show("species"))
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(button)

func _species_owned(id: String) -> bool:
	for member in App.profile.campaign.collection:
		if member.species == id: return true
	return false

func _species() -> void:
	var entry := catalog.find_species(selected_species)
	if entry.is_empty():
		_copy("La ficha solicitada no está disponible.")
		return
	_heading(entry.name)
	var known := _species_owned(selected_species)
	body.add_child(_portrait(selected_species, not known))
	_copy(entry.rarity)
	if not known:
		_copy("Vincula esta especie con el Libro para descubrir su ficha.")
		return
	_copy(entry.biome)
	_copy(entry.physiology.split(". ")[0] + ". " + entry.behavior.split(". ")[0])
	var stats := CombatCatalog.stats_at_level(selected_species, 1)
	if stats.is_empty(): _copy("Datos de combate aún no disponibles")
	else: _copy("Base Nv. 1 · Vida %d · Ataque %d · Defensa %d · Velocidad %d" % [stats.life, stats.attack, stats.defense, stats.speed])

func _settings() -> void :
	_heading("Ajustes")
	body.add_child(_button("Ver introducción", func():
		intro_replay = true
		_show("prologue")))
	body.add_child(_button("Diagnóstico", func(): _show("diagnostics")))
	for key in ["large_text", "haptics", "sound", "reduced_motion"]:
		var current_key: String = key
		var title: String = {"large_text": "Texto grande", "haptics": "Vibración al tocar", "sound": "Efectos de sonido", "reduced_motion": "Movimiento reducido"}[key]
		var enabled: bool = App.profile.settings[key]
		var button:= _button(title + (" · Activado" if enabled else " · Desactivado"), func(): _toggle(current_key))
		button.disabled = App.load_failed
		body.add_child(button)
	_copy("Movimiento reducido mantiene quietos a los personajes y simplifica el vínculo. Conserva sonidos y resultados.")
	var volume:= HSlider.new()
	volume.name = "EffectsVolume"
	volume.min_value = 0
	volume.max_value = 100
	volume.step = 5
	volume.value = App.profile.settings.get("effects_volume", 0.65) * 100
	volume.custom_minimum_size = Vector2(0, 58)
	volume.editable = not App.load_failed
	var caption:= _label("Volumen de efectos: %d%%" % volume.value, theme.default_font_size)
	body.add_child(caption)
	body.add_child(volume)
	volume.value_changed.connect( func(value: float):
		caption.text = "Volumen de efectos: %d%%" % value)
	volume.drag_ended.connect( func(changed: bool):
		if changed: _save_volume(volume))
	volume.gui_input.connect( func(event: InputEvent):
		if event is InputEventKey and event.pressed: _save_volume.call_deferred(volume))
	_copy("Los ajustes se guardan al cambiarlos.")

func _save_volume(slider: HSlider) -> void :
	if not is_instance_valid(slider): return
	if App.set_effect_volume(slider.value / 100.0):
		App.play_sfx("item")
	else: toast.text = App.notice

func _toggle(key: String) -> void :
	if App.set_preference(key, not App.profile.settings[key]):
		_show("settings")
		toast.text = "Ajuste guardado."
	else:
		toast.text = App.notice

func _diagnostics() -> void :
	_heading("Diagnóstico")
	_copy(App.diagnostic_report())
	body.add_child(_button("Exportar informe", _export_report))
	if App.qa_available():
		body.add_child(_button("Laboratorio QA", func():
			if App.qa_active: _show("tree_lab")
			else: _enter_qa()))
	body.add_child(_button("Copiar informe", func():
		DisplayServer.clipboard_set(App.diagnostic_report())
		toast.text = "Informe copiado."))

func _export_report() -> void :
	export_dialog.current_file = "karmany-diagnostico.txt"
	export_dialog.popup_centered_ratio(0.8)

func _write_report(path: String) -> void :
	if App.qa_active:
		toast.text = "La exportación está desactivada en QA."
		return
	var handle:= FileAccess.open(path, FileAccess.WRITE)
	if handle == null:
		toast.text = "No se pudo exportar. Puedes copiar el informe."
		return
	handle.store_string(App.diagnostic_report())
	handle.flush()
	toast.text = "Informe exportado." if handle.get_error() == OK else "No se pudo completar la exportación."

func _back() -> void :
	if _close_modal(self): return
	if page == "prologue" and is_instance_valid(prologue):
		prologue.back()
		return
	for transition in get_tree().get_nodes_in_group("combat_transition"):
		if transition.is_visible_in_tree():
			transition.finish()
			return
	for animation in get_tree().get_nodes_in_group("binding_cinematic"):
		if animation.is_visible_in_tree():
			animation.finish()
			return
	for help in get_tree().get_nodes_in_group("context_help"):
		if help.is_visible_in_tree() and help.handle_back(): return
	for screen in get_tree().get_nodes_in_group("aftermath_screen"):
		if screen.is_visible_in_tree():
			screen.handle_back()
			return
	for summary in get_tree().get_nodes_in_group("experience_summary"):
		if summary.visible:
			summary._finish()
			return
	if page == "home" and navigation.entries.is_empty():
		App.log_event("Salida solicitada.")
		get_tree().quit()
		return
	var fallback := "jade_play" if page in ["battle", "exploration", "intro", "team", "collection"] else "map"
	_show(navigation.previous(page, fallback), false)

func _close_modal(node: Node) -> bool:
	# Reverse traversal closes the topmost popup, without confirming its action.
	var children := node.get_children()
	children.reverse()
	for child in children:
		if child is Window and child.visible:
			child.hide()
			if child != dialog and child != export_dialog: child.queue_free()
			return true
		if _close_modal(child): return true
	return false

func _notification(what: int) -> void :
	if what == NOTIFICATION_WM_GO_BACK_REQUEST or what == NOTIFICATION_WM_CLOSE_REQUEST:
		_back()

func _unhandled_key_input(event: InputEvent) -> void :
	if event.is_action_pressed("ui_cancel"):
		_back()
		get_viewport().set_input_as_handled()

func _select_tree_node(node_id: String) -> void :
	for child in body.get_children():
		if child.has_signal("pan_changed"): tree_pan = child.pan
	App.tap()
	selected_tree_node = node_id
	var scroll:= body.get_parent() as ScrollContainer
	tree_scroll_position = scroll.scroll_vertical
	_show("skill_tree")

func _playable() -> void :

	var scroll:= body.get_parent() as ScrollContainer
	var parent:= scroll.get_parent()
	parent.get_child(0).hide()
	parent.remove_child(scroll)
	scroll.queue_free()
	var trial:= TrialUI.new()
	trial.mode = "intro" if page == "intro" else ("map" if page == "jade_play" else ("exploration" if page == "exploration" else "battle"))
	trial.size_flags_vertical = Control.SIZE_EXPAND_FILL
	trial.custom_minimum_size = Vector2(0, 500)
	parent.add_child(trial)
	trial.navigate.connect(_show)
	trial.back_requested.connect(_back)

func _collection() -> void :
	_heading("Colección")
	_copy("Zephyr está vinculado a Ezel desde su nacimiento; no es una captura del Libro.")
	var stage:= Stage.new()
	stage.mode = "collection"
	if not App.profile.campaign.collection.is_empty(): stage.collection_species = App.profile.campaign.collection.back().species
	stage.custom_minimum_size = Vector2(0, 260)
	body.add_child(stage)
	var in_progress:= _encounter_in_progress()
	for member in Roster.owned(App.profile.campaign):
		var chosen_id: String = member.instance_id
		var portrait:= TextureRect.new()
		portrait.texture = Stage.texture(member.species_id)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.custom_minimum_size = Vector2(120, 120)
		body.add_child(portrait)
		_copy(Roster.member_name(member))
		var progress:= Progress.record_for(App.profile.campaign, member.instance_id)
		_copy(Progress.summary(App.profile.campaign, member.instance_id))
		var stats:= CombatCatalog.stats_at_level(member.species_id, int(progress.level))
		_copy("Ensayo · Vida %d · Ataque %d · Defensa %d\nInsignia: %s" % [stats.life, stats.attack, stats.defense, CombatCatalog.action(member.species_id, "insignia").description])
		var equipped:= false
		for current in App.profile.campaign.team.members:
			if current.instance_id == chosen_id: equipped = true
		var add:= _button("Ya está en el equipo" if equipped else "Añadir al equipo", func(): _team_action("add", chosen_id, "collection"))
		add.disabled = equipped or in_progress or App.profile.campaign.team.members.size() >= 3 or App.load_failed
		body.add_child(add)
	body.add_child(_button("Preparar equipo", func(): _show("team")))
	_copy("Capturas guardadas: %d. Los duplicados son individuos diferentes y no repiten la bonificación del árbol." % App.profile.campaign.collection.size())
	body.add_child(_button("Volver al valle", func(): _show("jade_play")))

func _encounter_in_progress() -> bool:
	return not App.profile.campaign.encounter.is_empty() and App.profile.campaign.encounter.phase in ["battle", "replacement", "capture"]

func _team_action(operation: String, member_id: String, return_page: String = "team") -> void :
	if App.change_team(operation, member_id):
		_show(return_page)
		toast.text = "Equipo guardado. Se aplica al siguiente encuentro."
	else:
		toast.text = App.notice

func _team() -> void :
	var team: Dictionary = App.profile.campaign.team
	_heading("Equipo · %d / 3" % team.members.size())
	_copy("Elige el Karmany activo antes del encuentro. Cada individuo capturado puede ocupar un espacio.")
	var locked:= _encounter_in_progress()
	if locked:
		_copy("El encuentro está en curso. Termínalo o abandónalo para cambiar el equipo.")
	for member in team.members:
		var chosen: String = member.instance_id
		var row:= HBoxContainer.new()
		row.add_theme_constant_override("separation", 18)
		body.add_child(row)
		var portrait:= TextureRect.new()
		portrait.texture = Stage.texture(member.species_id)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.custom_minimum_size = Vector2(120, 120)
		row.add_child(portrait)
		var text:= VBoxContainer.new()
		text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(text)
		text.add_child(_label(Roster.member_name(member) + (" · ACTIVO" if chosen == team.active_id else " · RESERVA")))
		var progress:= Progress.record_for(App.profile.campaign, chosen)
		var stats:= CombatCatalog.stats_at_level(member.species_id, int(progress.level))
		text.add_child(_label(Progress.summary(App.profile.campaign, chosen), 22))
		text.add_child(_label("Vida %d · Ataque %d · Defensa %d" % [stats.life, stats.attack, stats.defense], 22))
		var xp_bar:= ProgressBar.new()
		xp_bar.max_value = Progress.requirement(int(progress.level))
		xp_bar.value = progress.xp
		xp_bar.show_percentage = false
		xp_bar.custom_minimum_size.y = 14
		text.add_child(xp_bar)
		var buttons:= HBoxContainer.new()
		text.add_child(buttons)
		var active:= _button("Elegir activo", func(): _team_action("active", chosen))
		active.disabled = chosen == team.active_id or locked or App.load_failed
		buttons.add_child(active)
		var remove:= _button("Retirar del equipo", func(): _team_action("remove", chosen))
		remove.disabled = locked or team.members.size() == 1 or App.load_failed
		buttons.add_child(remove)
	_copy("Solo este equipo gana XP al vencer en localizaciones. Valle Jade deja de dar XP a cada individuo desde Nv. 10. Retirar conserva nivel y experiencia.")
	body.add_child(_button("Añadir desde la colección", func(): _show("collection")))
	body.add_child(_button("Volver al valle", func(): _show("jade_play")))

func refresh_current() -> void:
	_show(page, false)

func _refresh_combat() -> void :
	if page in ["battle", "jade_play", "team", "exploration"]:
		refresh_current()
