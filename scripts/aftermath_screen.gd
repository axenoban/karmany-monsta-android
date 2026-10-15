extends Control
const Flow = preload("res://scripts/aftermath_flow.gd")
const Stage = preload("res://scripts/trial_stage.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const Locations = preload("res://scripts/location_visuals.gd")
const ExperiencePanel = preload("res://scripts/experience_panel.gd")
const Binding = preload("res://scripts/binding_stage.gd")
const VICTORY_DURATION:= 1.25
var app: Node
var host: Control
var stage:= ""
var encounter_id:= ""
var revision:= 0
var elapsed:= 0.0
var reduced:= false
var auto_attempted:= false
var content: VBoxContainer
var body: VBoxContainer
var footer: VBoxContainer
var message: Label
var xp_panel: GridContainer
var departing: TextureRect
var transition_alpha:= 0.0
func label(text: String, font: int, color: Color = Color("f3efdf")) -> Label:
	var node:= Label.new()
	node.text = text
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.add_theme_font_size_override("font_size", font + (2 if app.profile.settings.large_text else 0))
	node.add_theme_color_override("font_color", color)
	return node
func action(text: String, callback: Callable, secondary: bool = false) -> Button:
	var node:= Button.new()
	node.text = text
	node.custom_minimum_size = Vector2(290, 58)
	node.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	node.add_theme_font_size_override("font_size", 23 if not app.profile.settings.large_text else 26)
	if secondary:
		var style:= StyleBoxFlat.new()
		style.bg_color = Color.TRANSPARENT
		node.add_theme_stylebox_override("normal", style)
		node.add_theme_color_override("font_color", Color("b8cec7"))
	node.pressed.connect(callback)
	node.disabled = app.load_failed
	return node
func portrait(species: String, height: float = 175) -> TextureRect:
	var node:= TextureRect.new()
	node.texture = Stage.texture(species)
	node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	node.custom_minimum_size = Vector2(160, height)
	node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return node
func _ready() -> void :
	name = "AftermathScreen"
	add_to_group("aftermath_screen")
	app = get_node("/root/App")
	var campaign: Dictionary = app.profile.campaign
	var encounter: Dictionary = campaign.encounter
	encounter_id = encounter.id
	revision = int(encounter.revision)
	stage = Flow.step(campaign)
	reduced = app.profile.settings.get("reduced_motion", false)
	var background:= TextureRect.new()
	background.texture = Stage.texture(Locations.background_for(campaign))
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var dim:= ColorRect.new()
	dim.color = Color(0.025, 0.075, 0.08, 0.9 if stage == "experience" else 0.72)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var margin:= MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]: margin.add_theme_constant_override("margin_" + side, 20)
	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	margin.add_child(content)
	if stage not in ["defeat", "retreated"]:
		content.add_child(label("VICTORIA    /    EXPERIENCIA    /    VÍNCULO", 16, Color("b9c5ab")))
	var scroll:= ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(scroll)
	body = VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.alignment = BoxContainer.ALIGNMENT_CENTER
	body.add_theme_constant_override("separation", 12)
	scroll.add_child(body)
	footer = VBoxContainer.new()
	footer.add_theme_constant_override("separation", 2)
	content.add_child(footer)
	message = label("", 20, Color("ffd0a0"))
	message.hide()
	footer.add_child(message)
	var species: String = encounter.get("enemy_species", "tanugami")
	var species_name:= Catalog.species_name(species)
	match stage:
		"victory":
			body.add_child(label("VICTORIA", 52, Color("efd49b")))
			var pair:= HBoxContainer.new()
			body.add_child(pair)
			pair.add_child(portrait(encounter.get("ally_species", "zephyr"), 210))
			departing = portrait(species, 210)
			pair.add_child(departing)
			body.add_child(label("El encuentro ha terminado", 24))
			body.add_child(label("Tu equipo se prepara para continuar el viaje.", 20, Color("c0d4cc")))
			footer.add_child(action("Ver experiencia" if Flow.next(campaign) == "experience" else "Continuar al vínculo", advance))
		"experience":
			body.alignment = BoxContainer.ALIGNMENT_BEGIN
			body.add_child(label("EXPERIENCIA ADQUIRIDA", 34, Color("efd49b")))
			xp_panel = ExperiencePanel.new()
			xp_panel.receipt = Flow.receipt(campaign).duplicate(true)
			xp_panel.large = app.profile.settings.large_text
			body.add_child(xp_panel)
			var drop: Dictionary = campaign.get("exploration", {}).get("drop", {})
			if drop.get("encounter_id") == encounter_id and drop.get("received", false): body.add_child(label("Recuperador de stamina +30 obtenido", 20))
			footer.add_child(action("Continuar al vínculo", advance))
		"choose":
			body.add_child(label("UN VÍNCULO POR ELEGIR", 36, Color("efd49b")))
			body.add_child(label("Elige cuál de los rivales quieres vincular.", 22))
			var choices:= HBoxContainer.new()
			choices.add_theme_constant_override("separation", 20)
			body.add_child(choices)
			for rival in encounter.enemy_team:
				var card:= VBoxContainer.new()
				card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				choices.add_child(card)
				card.add_child(portrait(rival.species_id, 180))
				card.add_child(label("Nv. %d · %s" % [int(rival.get("level", 1)), "Ya vinculada" if Flow.owned_count(campaign, rival.species_id) > 0 else "Nueva especie"], 20))
				var id: String = rival.instance_id
				card.add_child(action("Elegir " + Catalog.species_name(rival.species_id), func(): host._act("choose_capture", id, revision)))
			footer.add_child(action("Continuar sin vínculo", confirm_leave, true))
		"duplicate":
			body.add_child(label("YA FORMA PARTE DE TU COLECCIÓN", 30, Color("efd49b")))
			body.add_child(portrait(species, 200))
			body.add_child(label("¿Quieres vincular otro %s?" % species_name, 30))
			body.add_child(label("Tienes %d · Este Karmany está en Nv. %d" % [Flow.owned_count(campaign, species), int(encounter.get("enemy", {}).get("level", 1))], 22))
			footer.add_child(action("Sí, vincular otro", advance))
			footer.add_child(action("No, seguir explorando", finish, true))
		"binding":
			var attempts: int = encounter.capture.actions.size()
			body.add_child(label("EL LIBRO TE ESPERA" if attempts == 0 else "EL VÍNCULO NO SE COMPLETÓ", 34, Color("efd49b")))
			var scene:= Binding.new()
			scene.draw_background = false
			scene.species = species
			scene.background_id = Locations.background_for(campaign)
			scene.custom_minimum_size.y = 230
			body.add_child(scene)
			body.add_child(label("%s · Nv. %d" % [species_name, int(encounter.get("enemy", {}).get("level", 1))], 28))
			body.add_child(label("%d intentos restantes · %d%% de posibilidad por intento" % [3 - attempts, roundi(float(encounter.capture.chance) * 100)], 21))
			footer.add_child(action("Abrir el Libro" if attempts == 0 else "Intentar de nuevo", func(): host._act("capture", "", revision)))
			footer.add_child(action("Dejarlo partir", confirm_leave, true))
		"captured":
			body.add_child(label("VÍNCULO LOGRADO", 42, Color("efd49b")))
			body.add_child(portrait(species, 220))
			body.add_child(label(species_name, 32))
			body.add_child(label("Ya está en tu colección. Puedes prepararlo desde Equipo.", 22))
			footer.add_child(action("Continuar recorrido", finish))
		"escaped":
			body.add_child(label("EL KARMANY SE HA MARCHADO", 34, Color("efd49b")))
			body.add_child(portrait(species, 190))
			body.add_child(label("La victoria y tu experiencia se conservan.", 24))
			footer.add_child(action("Continuar recorrido", finish))
		"defeat", "retreated":
			body.add_child(label("UN MOMENTO PARA RECUPERARSE" if stage == "defeat" else "DE VUELTA AL CAMINO", 34, Color("efd49b")))
			body.add_child(portrait(encounter.get("ally_species", "zephyr"), 220))
			body.add_child(label("Tu equipo volverá recuperado al próximo encuentro." if stage == "defeat" else "Puedes preparar tu equipo antes de volver.", 24))
			footer.add_child(action("Volver al mapa", finish))
	_update(0.0)
func _process(delta: float) -> void :
	if app.application_paused or not is_visible_in_tree() or (host.binding_busy or host.combat_busy): return
	elapsed += maxf(delta, 0)
	_update(delta)
	if stage == "victory" and elapsed >= VICTORY_DURATION and not auto_attempted:
		auto_attempted = true
		advance()
func _update(_delta: float) -> void :
	content.modulate.a = 1.0 if reduced else clampf(0.3 + elapsed / 0.3, 0.3, 1.0)
	if departing != null: departing.modulate.a = 0.18 if reduced else lerpf(1.0, 0.18, clampf(elapsed / 0.9, 0, 1))
	if xp_panel != null: xp_panel.set_fraction(1.0 if reduced else clampf(elapsed / 4.0, 0, 1))
func advance() -> void :
	if (host.binding_busy or host.combat_busy): return
	if app.advance_aftermath(encounter_id, stage): host.navigate.emit("battle")
	else: show_notice(app.notice if not app.notice.is_empty() else "El resultado ya cambió.")
func finish() -> void :
	if (host.binding_busy or host.combat_busy): return
	if app.finish_aftermath(encounter_id, revision): host.navigate.emit("jade_play")
	else: show_notice(app.notice)
func confirm_leave() -> void :
	host._confirm("El Karmany partirá. Conservarás la victoria y toda la experiencia ganada.", finish, "Dejar partir")
func show_notice(text: String) -> void :
	message.text = text
	message.show()
func handle_back() -> void :
	if (host.binding_busy or host.combat_busy): return
	if stage in ["victory", "experience"]: advance()
	else: host.navigate.emit("jade_play")
