extends Control

signal navigate(page: String)
const Encounter = preload("res://scripts/trial_encounter.gd")
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
	var title := _label("VALLE JADE · " + ((("Error al guardar respuesta" if not App.response_error.is_empty() else "Respuesta rival") if not App.profile.campaign.encounter.is_empty() and Encounter.enemy_pending_from(App.profile.campaign.encounter) else "Resonancia → Karmany") if mode == "battle" else "Ezel, Axe y Zephyr"), 26)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
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
	stage.custom_minimum_size = Vector2(0, 170)
	stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(stage)

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
		var active: bool = not App.profile.campaign.encounter.is_empty() and App.profile.campaign.encounter.phase in ["battle", "capture"]
		points.add_child(_button("● Retomar encuentro" if active else "● Tanugami", func():
			if App.start_trial(): navigate.emit("battle")
			else: _notice()))
		points.add_child(_button("● Árbol", func(): navigate.emit("skill_tree")))
		var links := HBoxContainer.new()
		column.add_child(links)
		links.add_child(_button("Colección · %d" % (1 + App.profile.campaign.collection.size()), func(): navigate.emit("collection")))
		links.add_child(_button("Equipo", func(): navigate.emit("team")))
		links.add_child(_button("Libro", func(): navigate.emit("book")))
		links.add_child(_button("Menú", func(): navigate.emit("home")))

func _act(operation: String, id: String, revision: int) -> void:
	if App.trial_action(operation, id, revision):
		navigate.emit("battle")
	else:
		_notice()

func _battle() -> void:
	var encounter := Encounter.new()
	if not encounter.restore(App.profile.campaign.encounter):
		column.add_child(_label("No hay un encuentro activo. Vuelve al mapa."))
		return
	var state := encounter.state
	var revision: int = state.revision
	column.add_child(_label("%s  %d / 80       Tanugami rival  %d / 80       Turno %d" % [encounter.ally_name(), state.player_hp, state.enemy_hp, state.round], 26))
	_stage("battle", state.player_hp == 0, state.enemy_hp == 0)
	var action_label := _label(encounter.last_action_text(), 22)
	action_label.name = "LastAction"
	column.add_child(action_label)
	if state.phase == "battle":
		var actions := HBoxContainer.new()
		column.add_child(actions)
		for id in ["golpe", "guardia", "insignia"]:
			var chosen: String = id
			var reason := encounter.reason("karmany", chosen)
			var name: String = Encounter.rules().actions[id].name
			var extra := " · T%d" % int(state.ready.get(id, 0)) if int(state.ready.get(id, 0)) > state.round else ""
			actions.add_child(_button(name + extra, func(): _act("karmany", chosen, revision), not reason.is_empty()))
		var resonances := HBoxContainer.new()
		column.add_child(resonances)
		if state.loadout.is_empty():
			var hint := _label("Sin resonancias equipadas. La habilidad del Karmany dará paso al rival.", 20)
			hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			resonances.add_child(hint)
		for id in state.loadout:
			var chosen: String = id
			var reason := encounter.reason("trainer", chosen)
			var name: String = Encounter.rules().resonances[id].name
			resonances.add_child(_button("Ezel: " + name, func(): _act("trainer", chosen, revision), not reason.is_empty()))
		var finish := HBoxContainer.new()
		column.add_child(finish)
		if state.enemy_pending and not App.response_error.is_empty():
			finish.add_child(_button("Reintentar respuesta", App.retry_enemy_response))
		else:
			finish.add_child(_button("Abandonar encuentro", func(): _act("retreat", "", revision), state.enemy_pending))
	elif state.phase == "capture":
		var used: int = state.capture.actions.size()
		column.add_child(_label("Libro inicial · 45%% por intento · quedan %d de 3" % (3 - used), 25))
		column.add_child(_button("Intentar vínculo con el Libro", func(): _act("capture", "", revision)))
	else:
		var text := "Tanugami capturado y añadido a la colección." if state.phase == "captured" else ("Tanugami escapó; puedes iniciar otro encuentro." if state.phase == "escaped" else (encounter.ally_name() + " quedó fuera de combate. La próxima prueba comienza recuperado." if state.phase == "defeat" else "Regresaste al valle."))
		column.add_child(_label(text, 25))
		column.add_child(_button("Volver al mapa", func(): navigate.emit("jade_play")))

func _notice() -> void:
	message.text = App.notice
	message.show()
