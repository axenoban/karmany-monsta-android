extends Control

signal navigate(page: String)
const AftermathScreen = preload("res://scripts/aftermath_screen.gd")
var aftermath_screen: Control
const ExperienceSummary = preload("res://scripts/experience_summary.gd")
const Progress = preload("res://scripts/level_progression.gd")
const ProgressRules = preload("res://scripts/progression_rules.gd")
const Energy = preload("res://scripts/exploration_energy.gd")
const Route = preload("res://scripts/jade_route.gd")
const RouteMap = preload("res://scripts/jade_route_map.gd")
const Details = preload("res://scripts/combat_details.gd")
const Encounter = preload("res://scripts/trial_encounter.gd")
const Router = preload("res://scripts/encounter_router.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
const BindingStage = preload("res://scripts/binding_stage.gd")
var binding_busy:= false
var combat_busy:= false
const CombatTransitionScreen = preload("res://scripts/combat_transition_screen.gd")
const Stage = preload("res://scripts/trial_stage.gd")
const Locations = preload("res://scripts/location_visuals.gd")
var mode:= "battle"
var column: VBoxContainer
var message: Label
var stamina_label: Label
var stamina_item_button: Button
var route_map_node: Control
var selected_location:= ""
var location_energy_label: Label
var location_enter_button: Button

func _ready() -> void :
	_build()
	if mode == "battle": _present_transition()
	if mode == "battle" and not App.profile.campaign.encounter.has("regional"): _show_experience.call_deferred()

func _label(text: String, font_size: int = 24) -> Label:
	var label:= Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _button(text: String, action: Callable, disabled: bool = false) -> Button:
	var button:= Button.new()
	button.text = text
	button.custom_minimum_size.y = 58
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.disabled = disabled or App.load_failed
	button.pressed.connect( func():
		App.tap()
		action.call())
	return button

func _build() -> void :
	if mode == "battle":
		var background := TextureRect.new()
		background.name = "ContinuousBackground"
		background.texture = Stage.texture(Locations.background_for(App.profile.campaign))
		background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		background.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(background)
		background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		var shade := ColorRect.new()
		shade.color = Color(0.02,0.06,0.06,0.35)
		shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(shade)
		shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if mode == "battle" and App.profile.campaign.encounter.has("regional") and App.profile.campaign.encounter.get("phase") in ["capture", "captured", "escaped", "defeat", "retreated"]:
		aftermath_screen = AftermathScreen.new()
		aftermath_screen.host = self
		add_child(aftermath_screen)
		aftermath_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		return
	var margin:= MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 8)
	add_child(margin)
	column = VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	margin.add_child(column)
	var header:= HBoxContainer.new()
	column.add_child(header)
	var title:= _label("COMBATE · Turno %d" % int(App.profile.campaign.encounter.get("round", 1)) if mode == "battle" else ProgressRules.region(App.profile.campaign.get("route", {}).get("selected", "jade")).name.to_upper() + " · Exploración", 26)
	if mode == "battle" and App.profile.campaign.encounter.has("regional") and App.profile.campaign.encounter.get("phase") in ["capture", "captured", "escaped"]: title.text = "VÍNCULO · EL LIBRO"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	if mode == "battle":
		header.add_child(_button("Opciones", _options_menu))
	elif mode == "map": header.add_child(_button("Opciones", _map_options))
	else: header.add_child(_button("Mapa", func(): navigate.emit("jade_play")))
	header.get_child(1).size_flags_horizontal = Control.SIZE_SHRINK_END
	if mode in ["intro", "map", "exploration"]:
		_world()
	else:
		_battle()
	message = _label("", 20)
	column.add_child(message)
	message.hide()


func _stage(stage_mode: String, dead_player: bool = false, dead_enemy: bool = false) -> void :
	var stage:= Stage.new()
	stage.mode = stage_mode
	stage.draw_background = stage_mode != "battle"
	stage.player_defeated = dead_player
	stage.enemy_defeated = dead_enemy
	if stage_mode == "battle":
		stage.background_id = Locations.background_for(App.profile.campaign)
		stage.ally_species = App.profile.campaign.encounter.get("ally_species", "zephyr")
		stage.enemy_species = App.profile.campaign.encounter.get("enemy_species", "tanugami")
	stage.custom_minimum_size = Vector2(0, 130 if stage_mode == "battle" and App.profile.campaign.encounter.get("phase") in ["capture", "captured", "escaped", "defeat", "retreated"] else 170)
	stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(stage)
	if stage_mode == "battle" and App.pending_transition.is_empty() and App.consume_animation(App.profile.campaign.encounter):
		stage.play(App.profile.campaign.encounter.get("event", {}))

func _world() -> void :
	if mode == "exploration":
		_exploration_scene()
		return
	if mode == "map":
		var route_map:= RouteMap.new()
		route_map_node = route_map
		var route: Dictionary = App.profile.campaign.get("route", Route.defaults())
		var active: bool = not App.profile.campaign.encounter.is_empty() and App.profile.campaign.encounter.phase in ["battle", "replacement", "capture"]
		route_map.setup(route, active, App.load_failed)
		route_map.size_flags_vertical = Control.SIZE_EXPAND_FILL
		route_map.point_selected.connect( func(id: String):
			App.tap()
			_location_details(id))
		column.add_child(route_map)
	else: _stage(mode)
	if mode == "intro":
		column.add_child(_label("Ezel · pensamiento", 23))
		column.add_child(_label("«Si mis manos pueden hacer crecer una flor en la piedra, ¿por qué no pueden sostener el mundo?»"))
		column.add_child(_label("Encuentro de prueba: Ezel y Zephyr junto a Axe. Cifras y técnicas experimentales para evaluar el combate.", 20))
		column.add_child(_button("Entrar al valle", func():
			if App.mark_intro_seen(): navigate.emit("jade_play")
			else: _notice()))
	else:
		var xp: int = int(Progress.normalized(App.profile.campaign).trainer_xp)
		column.add_child(_label("Entrenador Nv. %d · XP %d/%d · Límite regional Nv. %d" % [App.profile.skill_tree.level, xp, Progress.requirement(int(App.profile.skill_tree.level)), int(ProgressRules.region(App.profile.campaign.get("route", {}).get("selected", "jade")).xp_cap)], 20))
		var energy_row:= HBoxContainer.new()
		column.add_child(energy_row)
		stamina_label = _label("", 21)
		stamina_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		energy_row.add_child(stamina_label)
		stamina_item_button = _button("", _use_stamina_item)
		energy_row.add_child(stamina_item_button)
		_update_stamina()
		var clock:= Timer.new()
		clock.wait_time = 1.0
		clock.timeout.connect(_update_stamina)
		add_child(clock)
		clock.start()
		var points:= HBoxContainer.new()
		column.add_child(points)
		var active: bool = not App.profile.campaign.encounter.is_empty() and App.profile.campaign.encounter.phase in ["battle", "replacement", "capture"]
		points.add_child(_button("Retomar localización" if active and App.profile.campaign.get("exploration", Energy.defaults()).scouting else ("Retomar encuentro" if active else "Entrenamiento libre"), func():
			if active: _open_encounter()
			else: _rivals()))
		points.add_child(_button("Regiones", _regions))

func _act(operation: String, id: String, revision: int, target_id: String = "") -> void :
	if binding_busy or combat_busy: return
	if operation == "capture":
		_attempt_binding(revision)
		return
	if App.trial_action(operation, id, revision, target_id):
		navigate.emit("battle")
	else:
		_notice()

func _attempt_binding(revision: int) -> void :
	if binding_busy or combat_busy: return
	binding_busy = true
	if not App.trial_action("capture", "", revision):
		binding_busy = false
		_notice()
		return

	var state: Dictionary = App.profile.campaign.encounter
	var layer:= CanvasLayer.new()
	layer.layer = 20
	add_child(layer)
	var animation:= BindingStage.new()
	animation.name = "BindingAnimation"
	animation.cinematic = true
	animation.species = state.get("enemy_species", "tanugami")
	animation.background_id = Locations.background_for(App.profile.campaign)
	layer.add_child(animation)
	animation.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var focus:= get_viewport().gui_get_focus_owner()
	if focus != null: focus.release_focus()
	animation.finished.connect( func():
		navigate.emit("battle"), CONNECT_ONE_SHOT)
	animation.play(state.phase)

func _battle() -> void :
	var encounter = Router.create(App.profile.campaign.encounter)
	if not encounter.restore(App.profile.campaign.encounter):
		column.add_child(_label("No hay un encuentro activo. Vuelve al mapa."))
		return
	var state: Dictionary = encounter.state
	var revision: int = state.revision
	var tactical: bool = encounter is Tactical
	var enemy_species: String = state.get("enemy_species", "tanugami")
	var enemy_name:= Catalog.species_name(enemy_species)
	var player_max: int = int(Tactical.stats_for(encounter.active()).life) if tactical else 80
	var enemy_max: int = int(Tactical.stats_for(state.enemy).life) if tactical else 80
	var health:= HBoxContainer.new()
	health.add_theme_constant_override("separation", 24)
	column.add_child(health)
	_health_bar(health, "AllyHP", encounter.ally_name() + (" · Nv. %d" % int(encounter.active().get("level", 1)) if tactical else ""), int(state.player_hp), player_max)
	_health_bar(health, "EnemyHP", enemy_name + (" · Nv. %d" % int(state.enemy.get("level", 1)) if tactical else "") + (" · %d/%d" % [int(state.enemy_index) + 1, state.enemy_team.size()] if state.has("enemy_team") and state.phase == "battle" else ""), int(state.enemy_hp), enemy_max)
	if state.phase in ["capture", "captured", "escaped"]:
		health.hide()
		var binding:= BindingStage.new()
		binding.species = enemy_species
		binding.outcome = state.phase
		binding.background_id = Locations.background_for(App.profile.campaign)
		binding.custom_minimum_size = Vector2(0, 210)
		binding.size_flags_vertical = Control.SIZE_EXPAND_FILL
		column.add_child(binding)
	else:
		_stage("battle", state.player_hp == 0, state.enemy_hp == 0)
	var action_label:= _label(encounter.last_action_text(), 22)
	action_label.name = "LastAction"
	column.add_child(action_label)
	if state.phase == "battle":
		var actions:= HBoxContainer.new()
		column.add_child(actions)
		for id in ["golpe", "guardia", "insignia"]:
			var chosen: String = id
			var reason: String = encounter.reason("karmany", chosen)
			var name: String = Catalog.action(state.ally_species, id).name if tactical else Encounter.rules().actions[id].name
			var extra:= " · T%d" % int(state.ready.get(id, 0)) if int(state.ready.get(id, 0)) > state.round else ""
			actions.add_child(_button(name + extra, func():
				if tactical and chosen == "insignia" and (Catalog.action(state.ally_species, "insignia").has("grant_boost") or Catalog.action(state.ally_species, "insignia").has("relay_boost")): _support(state, revision)
				else: _act("karmany", chosen, revision), not reason.is_empty()))
			var technique_button:= actions.get_child(actions.get_child_count() - 1) as Button
			technique_button.modulate = Color("e2c9ff") if id == "insignia" else (Color("a9e8ff") if id == "guardia" else Color("bdffe3"))
			if tactical: actions.get_child(actions.get_child_count() - 1).tooltip_text = Catalog.action(state.ally_species, id).description + (" " + reason if not reason.is_empty() else "")
		var secondary:= HBoxContainer.new()
		column.add_child(secondary)
		secondary.add_child(_button("Entrenador", _trainer_menu))
		if tactical: secondary.add_child(_button("Equipo", _team_menu))
		if state.enemy_pending and not App.response_error.is_empty():
			secondary.add_child(_button("Reintentar respuesta", App.retry_enemy_response))
	elif state.phase == "replacement":
		column.add_child(_label("Elige un reemplazo. El rival no atacará otra vez por este cambio.", 22))
		var replacements:= HBoxContainer.new()
		column.add_child(replacements)
		for member in state.members:
			var member_id: String = member.instance_id
			if member.hp > 0:
				replacements.add_child(_button("Entrar: " + Catalog.species_name(member.species_id), func(): _act("replace", member_id, revision)))
	elif state.phase == "capture":
		_drop_notice(state.id)
		var used: int = state.capture.actions.size()
		var chance: float = float(state.capture.chance)
		var book_id: String = state.capture.policy_id
		var book_name: String = {"book_initial": "Libro inicial", "book_upgrade_1": "Mejora 1", "book_upgrade_2": "Mejora 2"}.get(book_id, book_id)
		column.add_child(_label("%s · %d%% por intento · quedan %d de 3" % [book_name, roundi(chance * 100), 3 - used], 25))
		_reward_notice(state.id)
		if state.has("enemy_team") and state.capture_choice.is_empty():
			column.add_child(_label("Elige un rival derrotado para el único vínculo de esta victoria.", 20))
			var choices:= HBoxContainer.new()
			column.add_child(choices)
			for rival in state.enemy_team:
				var selected_id: String = rival.instance_id
				choices.add_child(_button("Vincular: %s · Nv. %d" % [Catalog.species_name(rival.species_id), int(rival.get("level", 1))], func(): _act("choose_capture", selected_id, revision)))
		else:
			column.add_child(_button("Intentar vínculo con el Libro", func(): _act("capture", "", revision)))
		if App.profile.campaign.get("route", Route.defaults()).current.get("encounter_id") == state.id:
			column.add_child(_button("Continuar recorrido sin vínculo", func():
				_confirm("La victoria ya cuenta para el recorrido. Continuar renuncia a los intentos restantes de este encuentro; podrás repetirlo después para intentar el vínculo.", func(): _continue_route(state.id, revision), "Continuar sin vínculo")))
	else:
		var text: String = enemy_name + " capturado y añadido a la colección." if state.phase == "captured" else (enemy_name + " escapó; puedes iniciar otro encuentro." if state.phase == "escaped" else (encounter.ally_name() + " quedó fuera de combate. La próxima prueba comienza recuperado." if state.phase == "defeat" else "Regresaste al valle."))
		_drop_notice(state.id)
		_reward_notice(state.id)
		column.add_child(_label(text, 25))
		column.add_child(_button("Volver al mapa", func(): navigate.emit("jade_play")))
		if state.phase in ["captured", "escaped"] and App.profile.campaign.get("route", Route.defaults()).current.get("encounter_id") == state.id:
			column.add_child(_button("Continuar recorrido", func(): _continue_route(state.id, revision)))

func _notice() -> void :
	App.play_sfx("error")
	if aftermath_screen != null:
		aftermath_screen.show_notice(App.notice)
		return
	message.text = App.notice
	message.show()

func _rivals() -> void :
	var dialog:= AcceptDialog.new()
	dialog.title = "Entrenamiento · elige rival"
	var choices:= VBoxContainer.new()
	dialog.add_child(choices)
	for species in ["tanugami", "ushigane", "kitsunibi", "sakuromushi"]:
		var chosen: String = species
		choices.add_child(_button(Catalog.species_name(chosen), func():
			if App.start_trial(chosen): _open_encounter()
			else: _notice()
			dialog.queue_free()))
	add_child(dialog)
	dialog.canceled.connect(dialog.queue_free)
	dialog.confirmed.connect(dialog.queue_free)
	dialog.popup_centered(Vector2i(440, 330))

func _confirm(text: String, action: Callable, confirmation: String = "Confirmar cambio") -> void :
	var dialog:= ConfirmationDialog.new()
	dialog.dialog_text = text
	dialog.dialog_autowrap = true
	dialog.ok_button_text = confirmation
	add_child(dialog)
	dialog.confirmed.connect( func():
		action.call()
		dialog.queue_free())
	dialog.canceled.connect(dialog.queue_free)
	dialog.popup_centered(Vector2i(580, 230))

func _support(state: Dictionary, revision: int) -> void :
	var dialog:= AcceptDialog.new()
	var effect := Catalog.action(state.ally_species, "insignia")
	var boost := roundi(float(effect.get("relay_boost", effect.get("grant_boost", 0))) * 100)
	dialog.title = "Insignia · ataque y relevo (+20%, 2 rondas)" if effect.has("relay_boost") else "Insignia · elige quién recibe +%d%% al próximo golpe" % boost
	var choices:= VBoxContainer.new()
	dialog.add_child(choices)
	for member in state.members:
		if member.hp <= 0 or (effect.has("relay_boost") and member.instance_id == state.ally_id): continue
		var recipient: String = member.instance_id
		choices.add_child(_button(Catalog.species_name(member.species_id) + " · " + recipient, func():
			_act("karmany", "insignia", revision, recipient)
			dialog.queue_free()))
	add_child(dialog)
	dialog.canceled.connect(dialog.queue_free)
	dialog.confirmed.connect(dialog.queue_free)
	dialog.popup_centered(Vector2i(580, 300))

func _details() -> void :
	if get_node_or_null("CombatDetails") != null: return
	var dialog:= Details.new()
	if not dialog.setup(App.profile.campaign.encounter, App.profile.settings.large_text):
		dialog.free()
		return
	add_child(dialog)
	dialog.popup_centered(Vector2i(820, 520))

func _continue_route(encounter_id: String, revision: int) -> void :
	if App.continue_route(encounter_id, revision): navigate.emit("jade_play")
	else: _notice()

func _health_bar(parent: HBoxContainer, id: String, caption: String, hp: int, maximum: int) -> void :
	var box:= VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(box)
	box.add_child(_label("%s · %d/%d PS" % [caption, hp, maximum], 23))
	var bar:= ProgressBar.new()
	bar.name = id
	bar.max_value = maximum
	bar.value = hp
	bar.show_percentage = false
	bar.custom_minimum_size.y = 22
	box.add_child(bar)

func _popup(id: String, caption: String) -> VBoxContainer:
	if get_node_or_null(id) != null: return null
	var dialog:= AcceptDialog.new()
	dialog.name = id
	dialog.title = caption
	dialog.ok_button_text = "Cerrar"
	var scroll:= ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.custom_minimum_size = Vector2(610, 300)
	dialog.add_child(scroll)
	var content:= VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	scroll.add_child(content)
	add_child(dialog)
	dialog.confirmed.connect(dialog.queue_free)
	dialog.canceled.connect(dialog.queue_free)
	dialog.popup_centered(Vector2i(680, 430))
	return content

func _options_menu() -> void :
	var content:= _popup("OptionsMenu", "Opciones de combate")
	if content == null: return
	var state: Dictionary = App.profile.campaign.encounter
	content.add_child(_button("Estado y técnicas", func():
		_dismiss("OptionsMenu")
		_details()))
	content.add_child(_button("Volver al mapa", func(): navigate.emit("jade_play")))
	content.add_child(_label("Volver al mapa conserva el encuentro y su respuesta pendiente.", 20))
	if state.phase in ["battle", "replacement"]:
		content.add_child(_button("Abandonar pelea", func():
			_dismiss("OptionsMenu")
			_confirm("Abandonar termina el encuentro sin victoria. La stamina de entrada ya se gastó y no se devuelve.", func(): _act("retreat", "", int(state.revision)), "Abandonar pelea"), Router.pending(state)))
		if Router.pending(state): content.add_child(_label("Espera la respuesta rival para abandonar.", 20))

func _trainer_menu() -> void :
	var content:= _popup("TrainerMenu", "Entrenador · resonancia opcional")
	if content == null: return
	var model = Router.create(App.profile.campaign.encounter)
	if not model.restore(App.profile.campaign.encounter): return
	var state: Dictionary = model.state
	if state.loadout.is_empty():
		var hint:= _label("Sin resonancias equipadas. Puedes actuar con tu Karmany.")
		hint.name = "TrainerHint"
		content.add_child(hint)
	for id in state.loadout:
		var chosen: String = id
		var reason: String = model.reason("trainer", id)
		content.add_child(_button("Ezel: " + Encounter.rules().resonances[id].name, func(): _act("trainer", chosen, int(state.revision)), not reason.is_empty()))
		if not reason.is_empty(): content.add_child(_label(reason, 20))

func _team_menu() -> void :
	var content:= _popup("TeamMenu", "Equipo · cambiar consume la acción")
	if content == null: return
	var state: Dictionary = App.profile.campaign.encounter
	for member in state.get("members", []):
		var id: String = member.instance_id
		content.add_child(_button("%s %d/%d · %s" % [Catalog.species_name(member.species_id), member.hp, int(Tactical.stats_for(member).life), "activo" if id == state.ally_id else id], func():
			_dismiss("TeamMenu")
			_confirm("Entrará " + Catalog.species_name(member.species_id) + ". El cambio consume la acción y el rival responderá contra el nuevo activo. Los efectos y recargas permanecen en cada individuo.", func(): _act("switch", id, int(state.revision))), id == state.ally_id or member.hp == 0 or Router.pending(state)))

func _open_encounter() -> void :
	navigate.emit("exploration" if App.profile.campaign.get("exploration", Energy.defaults()).scouting else "battle")

func _exploration_scene() -> void :
	var point_id: String = App.profile.campaign.get("route", Route.defaults()).current.get("point_id", "")
	var view:= TextureRect.new()
	view.name = "LocationBackdrop"
	view.texture = Stage.texture(Locations.background_for(App.profile.campaign))
	view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	view.custom_minimum_size.y = 220
	view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(view)
	var info:= Locations.details(point_id)
	column.add_child(_label("%s · %s" % [info.get("title", "Localización"), info.get("environment", "Valle Jade")], 24))
	column.add_child(_label("Entrada pagada: %d stamina. Buscar y retomar no tienen coste adicional." % Route.entry_cost(point_id), 20))
	var encounter_id: String = App.profile.campaign.encounter.get("id", "")
	column.add_child(_button("Buscar encuentro", func():
		if App.discover_location(encounter_id): navigate.emit("battle")
		else: _notice()))
	column.add_child(_button("Salir de la localización", func():
		_confirm("Salir termina esta exploración. La stamina de entrada no se devuelve.", func():
			if App.trial_action("retreat"): navigate.emit("jade_play")
			else: _notice(), "Salir")))

func _update_stamina() -> void :
	if stamina_label == null: return
	var energy:= App.stamina_view()
	var countdown:= 0
	if energy.value < 100:
		countdown = maxi(1, int(energy.anchor) + 60 - int(Time.get_unix_time_from_system()))
	stamina_label.text = "Ruta %d/6 · Stamina %d/100 · %s · Objetos: %d" % [Route.completions(App.profile.campaign.get("route", Route.defaults()), App.profile.campaign.get("route", {}).get("selected", "jade")).size(), energy.value, "+1 en %ds" % countdown if energy.value < 100 else "Completa", energy.items]
	stamina_item_button.text = "Usar recuperador +30"
	stamina_item_button.disabled = energy.items <= 0 or energy.value >= 100 or App.load_failed
	if route_map_node != null: route_map_node.update_stamina(int(energy.value))
	_update_location_entry()

func _location_details(point_id: String) -> void :
	var info:= Locations.details(point_id)
	if info.is_empty(): return
	var content:= _popup("LocationDetails", info.title + " · " + info.environment)
	if content == null: return
	selected_location = point_id
	var image_view:= TextureRect.new()
	image_view.texture = Stage.texture(info.background)
	image_view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image_view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	image_view.custom_minimum_size = Vector2(0, 80)
	content.add_child(image_view)
	content.add_child(_label(info.description, 22))
	var point:= Route.point(point_id)
	if point.has("level"):
		content.add_child(_label("Nv. %d · %d rivales · XP inicial %d / repetición %d" % [int(point.level), point.enemies.size(), int(point.first_xp), int(point.repeat_xp)], 20))
	else: content.add_child(_label("Las criaturas se revelan al buscar un encuentro dentro del lugar.", 20))
	location_energy_label = _label("", 22)
	location_energy_label.name = "LocationEnergy"
	content.add_child(location_energy_label)
	location_enter_button = _button("", func():

		if App.start_route(point_id):
			_dismiss("LocationDetails")
			_open_encounter()
		else:
			_update_location_entry()
			_notice())
	location_enter_button.name = "LocationEnter"
	content.add_child(location_enter_button)
	_update_location_entry()

	var scroll:= content.get_parent() as ScrollContainer
	scroll.custom_minimum_size.y = 430
	var dialog:= get_node("LocationDetails") as Window
	dialog.popup_centered(Vector2i(740, 560))

func _update_location_entry() -> void :
	if not is_instance_valid(location_energy_label) or not is_instance_valid(location_enter_button): return
	var route: Dictionary = App.profile.campaign.get("route", Route.defaults())
	var active: bool = not App.profile.campaign.encounter.is_empty() and App.profile.campaign.encounter.phase in ["battle", "replacement", "capture"]
	var same: bool = active and route.current.get("point_id", "") == selected_location
	var unlocked:= Route.unlocked(route, selected_location)
	var cost:= Route.entry_cost(selected_location)
	var available: int = App.stamina_view().value
	var status:= "Completado · puedes repetir" if Route.completed(route, selected_location) else "Disponible para explorar"
	if not unlocked: status = "Bloqueado · completa el lugar anterior"
	elif active: status = "Encuentro en curso aquí" if same else "Termina o retoma el encuentro actual"
	elif available < cost: status = "Stamina insuficiente"
	location_energy_label.text = "%s\nEntrada: %d stamina · Disponible: %d/100%s" % [status, cost, available, "\nEntrada ya pagada · retomar no gasta stamina." if same else ""]
	location_enter_button.text = "Retomar localización" if same else "Entrar · %d stamina" % cost
	location_enter_button.disabled = App.load_failed or not unlocked or (active and not same) or ( not same and available < cost)

func _use_stamina_item() -> void :
	var revision: int = int(App.profile.campaign.get("exploration", Energy.defaults()).revision)
	if App.use_recovery_item(revision): navigate.emit("jade_play")
	else: _notice()

func _drop_notice(encounter_id: String) -> void :
	var drop: Dictionary = App.profile.campaign.get("exploration", Energy.defaults()).drop
	if drop.get("encounter_id") == encounter_id and drop.get("received", false):
		column.add_child(_label("Objeto obtenido: recuperador de stamina (+30). Disponible en el mapa.", 21))

func _map_options() -> void :
	var content:= _popup("MapOptions", "Exploración · opciones")
	if content == null: return
	content.add_child(_button("Viajar entre regiones", func():
		_dismiss("MapOptions")
		_regions()))
	for entry in [["Equipo", "team"], ["Colección", "collection"], ["Árbol", "skill_tree"], ["Libro", "book"], ["Ezel y Axe", "intro"], ["Menú principal", "home"]]:
		var target: String = entry[1]
		content.add_child(_button(entry[0], func(): navigate.emit(target)))

func _dismiss(id: String) -> void :
	var dialog:= get_node_or_null(id) as Window
	if dialog != null:
		dialog.hide()
		dialog.queue_free()

func _reward_notice(encounter_id: String) -> void :
	var receipt: Dictionary = App.profile.campaign.get("progression", {}).get("last_reward", {})
	if receipt.get("encounter_id") != encounter_id: return
	var lines: Array[String] = []
	for row in receipt.rows:
		var caption: String = "Entrenador" if row.id == "trainer" else row.id
		for member in _roster_for_rewards():
			if member.instance_id == row.id: caption = Catalog.species_name(member.species_id)
		lines.append("%s Nv. %d: +%d XP" % [caption, row.level, row.gained])
	if receipt.region.is_empty(): lines = ["Entrenamiento libre: sin experiencia."]
	var label:= _label(" · ".join(lines), 18)
	label.name = "ExperienceReward"
	column.add_child(label)
func _roster_for_rewards() -> Array:
	return preload("res://scripts/trial_roster.gd").owned(App.profile.campaign)

func _show_experience() -> void :
	var receipt:= App.consume_experience(App.profile.campaign.encounter.get("id", ""))
	if receipt.is_empty(): return
	var dialog:= ExperienceSummary.new()
	dialog.receipt = receipt
	add_child(dialog)
	dialog.present()

func _regions() -> void :
	var content:= _popup("Regions", "Regiones de Shisai")
	if content == null: return
	for region_id in ["jade", "veil"]:
		var selected: String = region_id
		var definition:= ProgressRules.region(selected)
		var reason:= ProgressRules.region_reason(App.profile.skill_tree, selected)
		content.add_child(_label("%s · Nv. %d · Tope XP %d" % [definition.name, int(definition.min_level), int(definition.xp_cap)], 24))
		var locked: bool = int(App.profile.skill_tree.level) < int(definition.min_level)
		var needs_buy: bool = int(definition.cost) > 0 and selected not in App.profile.skill_tree.get("unlocks", [])
		content.add_child(_button("Desbloquear · %d punto" % int(definition.cost) if needs_buy else "Viajar: " + definition.name, func():
			_dismiss("Regions")
			if needs_buy:
				_confirm("Desbloquear %s cuesta %d punto permanente del árbol." % [definition.name, int(definition.cost)], func():
					if App.purchase_unlock(selected) and App.select_region(selected): navigate.emit("jade_play")
					else: _notice(), "Desbloquear región")
			elif App.select_region(selected): navigate.emit("jade_play")
			else: _notice(), locked))
		if not reason.is_empty(): content.add_child(_label(reason, 20))


func _tactics_menu() -> void :
	var content:= _popup("TacticsMenu", "Táctica")
	if content == null: return
	content.add_child(_button("Entrenador · resonancias", func():
		_dismiss("TacticsMenu")
		_trainer_menu()))
	if App.profile.campaign.encounter.get("schema") == 2:
		content.add_child(_button("Equipo · cambiar Karmany", func():
			_dismiss("TacticsMenu")
			_team_menu()))

func _present_transition() -> void :
	var receipt: Dictionary = App.consume_transition()
	if receipt.is_empty(): return
	combat_busy = true
	App.consume_animation(App.profile.campaign.encounter)
	var layer:= CanvasLayer.new()
	layer.layer = 19
	add_child(layer)
	var scene:= CombatTransitionScreen.new()
	scene.receipt = receipt
	scene.background_id = Locations.background_for(App.profile.campaign)
	layer.add_child(scene)
	scene.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var focus:= get_viewport().gui_get_focus_owner()
	if focus != null: focus.release_focus()
	scene.finished.connect( func():
		combat_busy = false
		layer.queue_free(), CONNECT_ONE_SHOT)
