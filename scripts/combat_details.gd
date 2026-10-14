extends AcceptDialog
const Readout = preload("res://scripts/combat_readout.gd")
var readout: Dictionary = {}
var tabs: TabContainer
var font_increment := 0

func _label(text: String, font_size: int = 23) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size + font_increment)
	return label

func _page(caption: String) -> VBoxContainer:
	var scroll := ScrollContainer.new()
	scroll.name = caption
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	tabs.add_child(scroll)
	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.add_theme_constant_override("separation", 14)
	scroll.add_child(column)
	column.add_child(_label(readout.phase, 21))
	return column

func _unit(column: VBoxContainer, unit: Dictionary) -> void:
	column.add_child(_label(unit.name + " · " + unit.role + " · " + unit.id, 25))
	column.add_child(_label("Vida %d/%d · Ataque %d · Defensa %d" % [unit.hp, unit.max_hp, unit.attack, unit.defense]))
	var bar := ProgressBar.new()
	bar.max_value = unit.max_hp
	bar.value = unit.hp
	bar.show_percentage = false
	bar.custom_minimum_size.y = 20
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(bar)
	column.add_child(_label(unit.effects))
	column.add_child(_label(unit.signature_ready, 21))
	column.add_child(HSeparator.new())

func _skill(column: VBoxContainer, skill: Dictionary) -> void:
	column.add_child(_label(skill.name, 25))
	column.add_child(_label(skill.description))
	column.add_child(_label("Sin recarga." if skill.cooldown == 0 else "Recarga: %d turnos completos tras usarla." % skill.cooldown, 21))
	if skill.ready_turn > readout.turn: column.add_child(_label("Vuelve en turno %d." % skill.ready_turn, 21))
	column.add_child(_label("Disponible ahora." if skill.status.is_empty() else "No disponible: " + skill.status, 21))
	column.add_child(HSeparator.new())

func setup(snapshot: Dictionary, large_text: bool = false) -> bool:
	font_increment = 4 if large_text else 0
	readout = Readout.build(snapshot)
	if readout.is_empty(): return false
	name = "CombatDetails"
	title = "Estado del combate · turno %d" % readout.turn
	ok_button_text = "Cerrar"
	tabs = TabContainer.new()
	tabs.custom_minimum_size = Vector2(720, 410)
	add_child(tabs)
	var current := _page("Activos")
	if readout.legacy: current.add_child(_label("Encuentro anterior: conserva sus cifras y reglas hasta terminar.", 20))
	_unit(current, readout.active)
	_unit(current, readout.enemy)
	if readout.legacy:
		current.add_child(_label("La respuesta rival anterior usa Insignia cada tercer turno; no utiliza una recarga individual.", 21))
	var team := _page("Equipo")
	for member in readout.team: _unit(team, member)
	team.add_child(_label("Vida, efectos y recargas pertenecen a cada individuo. Cambiar no los traslada ni los elimina.", 21))
	var skills := _page("Técnicas")
	for skill in readout.skills: _skill(skills, skill)
	var resonances := _page("Resonancias")
	if readout.resonances.is_empty(): resonances.add_child(_label("No hay resonancias equipadas. Puedes usar una habilidad disponible del Karmany."))
	for resonance in readout.resonances: _skill(resonances, resonance)
	resonances.add_child(_label("Las resonancias se dirigen al activo actual o al rival indicado. Son opcionales y se usan antes de la acción del Karmany.", 21))
	confirmed.connect(queue_free)
	canceled.connect(queue_free)
	return true
