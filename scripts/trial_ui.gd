extends Control

signal navigate(page: String)
const Details = preload("res://scripts/combat_details.gd")
const Encounter = preload("res://scripts/trial_encounter.gd")
const Router = preload("res://scripts/encounter_router.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const Tactical = preload("res://scripts/tactical_encounter.gd")
const Stage = preload("res://scripts/trial_stage.gd")
var mode := "battle"
var column: VBoxContainer
var message: Label

func _ready() -> void:
	_build()

func _label(text: String, font_size: int = 24) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _button(text: String, action: Callable, disabled: bool = false) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size.y = 58
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.disabled = disabled or App.load_failed
	button.pressed.connect(func():
		App.tap()
		action.call())
	return button

func _build() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 8)
	add_child(margin)
	column = VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	margin.add_child(column)
	var header := HBoxContainer.new()
	column.add_child(header)
	var title := _label("VALLE JADE · " + ((("Error al guardar respuesta" if not App.response_error.is_empty() else "Respuesta rival") if not App.profile.campaign.encounter.is_empty() and Router.pending(App.profile.campaign.encounter) else "Resonancia → Karmany") if mode == "battle" else "Ezel, Axe y Zephyr"), 26)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	if mode == "battle" and Router.valid(App.profile.campaign.encounter):
		header.add_child(_button("Estado y técnicas", _details))
	header.add_child(_button("Mapa", func(): navigate.emit("jade_play")))
	if mode == "intro" or mode == "map":
		_world()
	else:
		_battle()
	message = _label("", 20)
	column.add_child(message)
	message.hide()

func _stage(stage_mode: String, dead_player: bool = false, dead_enemy: bool = false) -> void:
	var stage := Stage.new()
	stage.mode = stage_mode
	stage.player_defeated = dead_player
	stage.enemy_defeated = dead_enemy
	if stage_mode == "battle":
		stage.ally_species = App.profile.campaign.encounter.get("ally_species", "zephyr")
		stage.enemy_species = App.profile.campaign.encounter.get("enemy_species", "tanugami")
	stage.custom_minimum_size = Vector2(0, 170)
	stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(stage)
	if stage_mode == "battle" and App.consume_animation(App.profile.campaign.encounter):
		stage.play(App.profile.campaign.encounter.get("event", {}))

func _world() -> void:
	_stage(mode)
	if mode == "intro":
		column.add_child(_label("Ezel · pensamiento", 23))
		column.add_child(_label("«Si mis manos pueden hacer crecer una flor en la piedra, ¿por qué no pueden sostener el mundo?»"))
		column.add_child(_label("Encuentro de prueba: Ezel y Zephyr junto a Axe. Cifras y técnicas experimentales para evaluar el combate.", 20))
		column.add_child(_button("Entrar al valle", func():
			if App.mark_intro_seen(): navigate.emit("jade_play")
			else: _notice()))
	else:
		column.add_child(_label("Elige un punto del mapa. El árbol se aplica al comenzar cada encuentro.", 21))
		var points := HBoxContainer.new()
		column.add_child(points)
		points.add_theme_constant_override("separation", 16)
		points.add_child(_button("● Ezel y Axe", func(): navigate.emit("intro")))
		var active: bool = not App.profile.campaign.encounter.is_empty() and App.profile.campaign.encounter.phase in ["battle", "replacement", "capture"]
		points.add_child(_button("● Retomar encuentro" if active else "● Entrenamiento", func():
			if active:
				if App.start_trial(): navigate.emit("battle")
				else: _notice()
			else: _rivals()))
		points.add_child(_button("● Árbol", func(): navigate.emit("skill_tree")))
		var links := HBoxContainer.new()
		column.add_child(links)
		links.add_child(_button("Colección · %d" % (1 + App.profile.campaign.collection.size()), func(): navigate.emit("collection")))
		links.add_child(_button("Equipo", func(): navigate.emit("team")))
		links.add_child(_button("Libro", func(): navigate.emit("book")))
		links.add_child(_button("Menú", func(): navigate.emit("home")))

func _act(operation: String, id: String, revision: int, target_id: String = "") -> void:
	if App.trial_action(operation, id, revision, target_id):
		navigate.emit("battle")
	else:
		_notice()

func _battle() -> void:
	var encounter = Router.create(App.profile.campaign.encounter)
	if not encounter.restore(App.profile.campaign.encounter):
		column.add_child(_label("No hay un encuentro activo. Vuelve al mapa."))
		return
	var state: Dictionary = encounter.state
	var revision: int = state.revision
	var tactical: bool = encounter is Tactical
	var enemy_species: String = state.get("enemy_species", "tanugami")
	var enemy_name := Catalog.species_name(enemy_species)
	var player_max: int = int(Catalog.stats(state.ally_species).life) if tactical else 80
	var enemy_max: int = int(Catalog.stats(enemy_species).life) if tactical else 80
	column.add_child(_label("%s  %d / %d       %s rival  %d / %d       Turno %d" % [encounter.ally_name(), state.player_hp, player_max, enemy_name, state.enemy_hp, enemy_max, state.round], 24))
	_stage("battle", state.player_hp == 0, state.enemy_hp == 0)
	var action_label := _label(encounter.last_action_text(), 22)
	action_label.name = "LastAction"
	column.add_child(action_label)
	if state.phase == "battle":
		var actions := HBoxContainer.new()
		column.add_child(actions)
		for id in ["golpe", "guardia", "insignia"]:
			var chosen: String = id
			var reason: String = encounter.reason("karmany", chosen)
			var name: String = Catalog.action(state.ally_species, id).name if tactical else Encounter.rules().actions[id].name
			var extra := " · T%d" % int(state.ready.get(id, 0)) if int(state.ready.get(id, 0)) > state.round else ""
			actions.add_child(_button(name + extra, func():
				if tactical and chosen == "insignia" and state.ally_species == "sakuromushi": _support(state, revision)
				else: _act("karmany", chosen, revision), not reason.is_empty()))
			if tactical: actions.get_child(actions.get_child_count() - 1).tooltip_text = Catalog.action(state.ally_species, id).description + (" " + reason if not reason.is_empty() else "")
		if tactical:
			var team_row := HBoxContainer.new()
			team_row.name = "BattleTeam"
			column.add_child(team_row)
			for member in state.members:
				var member_id: String = member.instance_id
				var caption := "%s %d/%d" % [Catalog.species_name(member.species_id), member.hp, int(Catalog.stats(member.species_id).life)]
				team_row.add_child(_button(caption + (" · activo" if member_id == state.ally_id else " · cambiar"), func():
					_confirm("Entrará " + Catalog.species_name(member.species_id) + " · " + member_id + ". Cambiar consume la acción del Karmany y el rival atacará al nuevo activo. Los efectos y recargas permanecen en cada individuo; una resonancia ya usada no se traslada.", func(): _act("switch", member_id, revision)), member.hp == 0 or member_id == state.ally_id or state.enemy_pending))
		var resonances := HBoxContainer.new()
		resonances.name = "Resonances"
		column.add_child(resonances)
		if state.loadout.is_empty():
			var hint := _label("Sin resonancias equipadas. La habilidad del Karmany dará paso al rival.", 20)
			hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			resonances.add_child(hint)
		for id in state.loadout:
			var chosen: String = id
			var reason: String = encounter.reason("trainer", chosen)
			var name: String = Encounter.rules().resonances[id].name
			resonances.add_child(_button("Ezel: " + name, func(): _act("trainer", chosen, revision), not reason.is_empty()))
		var finish := HBoxContainer.new()
		column.add_child(finish)
		if state.enemy_pending and not App.response_error.is_empty():
			finish.add_child(_button("Reintentar respuesta", App.retry_enemy_response))
		else:
			finish.add_child(_button("Abandonar encuentro", func(): _act("retreat", "", revision), state.enemy_pending))
	elif state.phase == "replacement":
		column.add_child(_label("Elige un reemplazo. El rival no atacará otra vez por este cambio.", 22))
		var replacements := HBoxContainer.new()
		column.add_child(replacements)
		for member in state.members:
			var member_id: String = member.instance_id
			if member.hp > 0:
				replacements.add_child(_button("Entrar: " + Catalog.species_name(member.species_id), func(): _act("replace", member_id, revision)))
	elif state.phase == "capture":
		var used: int = state.capture.actions.size()
		column.add_child(_label("Libro inicial · 45%% por intento · quedan %d de 3" % (3 - used), 25))
		column.add_child(_button("Intentar vínculo con el Libro", func(): _act("capture", "", revision)))
	else:
		var text: String = enemy_name + " capturado y añadido a la colección." if state.phase == "captured" else (enemy_name + " escapó; puedes iniciar otro encuentro." if state.phase == "escaped" else (encounter.ally_name() + " quedó fuera de combate. La próxima prueba comienza recuperado." if state.phase == "defeat" else "Regresaste al valle."))
		column.add_child(_label(text, 25))
		column.add_child(_button("Volver al mapa", func(): navigate.emit("jade_play")))

func _notice() -> void:
	message.text = App.notice
	message.show()

func _rivals() -> void:
	var dialog := AcceptDialog.new()
	dialog.title = "Entrenamiento · elige rival"
	var choices := VBoxContainer.new()
	dialog.add_child(choices)
	for species in ["tanugami", "ushigane", "kitsunibi", "sakuromushi"]:
		var chosen: String = species
		choices.add_child(_button(Catalog.species_name(chosen), func():
			if App.start_trial(chosen): navigate.emit("battle")
			else: _notice()
			dialog.queue_free()))
	add_child(dialog)
	dialog.canceled.connect(dialog.queue_free)
	dialog.confirmed.connect(dialog.queue_free)
	dialog.popup_centered(Vector2i(440, 330))

func _confirm(text: String, action: Callable) -> void:
	var dialog := ConfirmationDialog.new()
	dialog.dialog_text = text
	dialog.dialog_autowrap = true
	dialog.ok_button_text = "Confirmar cambio"
	add_child(dialog)
	dialog.confirmed.connect(func():
		action.call()
		dialog.queue_free())
	dialog.canceled.connect(dialog.queue_free)
	dialog.popup_centered(Vector2i(580, 230))

func _support(state: Dictionary, revision: int) -> void:
	var dialog := AcceptDialog.new()
	dialog.title = "Insignia · elige quién recibe +25% al próximo golpe"
	var choices := VBoxContainer.new()
	dialog.add_child(choices)
	for member in state.members:
		if member.hp <= 0: continue
		var recipient: String = member.instance_id
		choices.add_child(_button(Catalog.species_name(member.species_id) + " · " + recipient, func():
			_act("karmany", "insignia", revision, recipient)
			dialog.queue_free()))
	add_child(dialog)
	dialog.canceled.connect(dialog.queue_free)
	dialog.confirmed.connect(dialog.queue_free)
	dialog.popup_centered(Vector2i(580, 300))

func _details() -> void:
	if get_node_or_null("CombatDetails") != null: return
	var dialog := Details.new()
	if not dialog.setup(App.profile.campaign.encounter, App.profile.settings.large_text):
		dialog.free()
		return
	add_child(dialog)
	dialog.popup_centered(Vector2i(820, 520))
