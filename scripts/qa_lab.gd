extends VBoxContainer
signal applied
signal launch(point_id: String)
signal leave
const Preset = preload("res://scripts/qa_profile.gd")
const Route = preload("res://scripts/jade_route.gd")
var trainer: SpinBox
var xp: SpinBox
var count: SpinBox
var active: SpinBox
var region: OptionButton
var point: SpinBox
var stamina: SpinBox
var species_controls: Array[OptionButton] = []
var levels: Array[SpinBox] = []
var summary: Label
var message: Label
func number(title: String, minimum: int, maximum: int, initial: int) -> SpinBox:
	var row := HBoxContainer.new()
	add_child(row)
	var label := Label.new(); label.text = title; label.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(label)
	var control := SpinBox.new(); control.min_value = minimum; control.max_value = maximum; control.value = initial; control.custom_minimum_size = Vector2(180,64); row.add_child(control)
	control.value_changed.connect(func(_value): update_summary())
	return control
func button(title: String, action: Callable):
	var control := Button.new(); control.text = title; control.custom_minimum_size.y = 64
	control.pressed.connect(action); add_child(control)
func _ready():
	trainer = number("Ezel · nivel", 1, 15, 1)
	for value in [1,5,10,15]:
		var level: int = value
		button("Ezel Nv.%d" % level, func(): trainer.value = level)
	xp = number("XP parcial", 0, 99, 0)
	count = number("Karmany en el equipo", 1, 3, 1)
	for i in range(3):
		var choice := OptionButton.new(); choice.custom_minimum_size.y = 64
		for id in Preset.species(): choice.add_item(id)
		choice.selected = i
		choice.item_selected.connect(func(_index): update_summary())
		add_child(choice); species_controls.append(choice)
		levels.append(number("Karmany %d · nivel" % (i + 1), 1, 15, 1))
	active = number("Karmany activo", 1, 1, 1)
	region = OptionButton.new(); region.add_item("Valle Jade"); region.add_item("Bosque del Velo"); region.custom_minimum_size.y = 64; add_child(region)
	region.item_selected.connect(func(_index): update_summary())
	point = number("Etapa", 1, 6, 1)
	stamina = number("Stamina", 0, 100, 100)
	button("Stamina completa", func(): stamina.value = 100)
	button("Stamina cero", func(): stamina.value = 0)
	summary = Label.new(); summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; add_child(summary)
	message = Label.new(); message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; add_child(message)
	button("Aplicar en laboratorio", func(): apply(false))
	button("Probar escenario / Reiniciar escenario QA", func(): apply(true))
	button("Reiniciar QA", confirm_reset)
	button("Salir al juego normal", func(): leave.emit())
	restore_configuration()
	update_summary()
func restore_configuration():
	var preset: Dictionary = App.qa_preset
	if preset.is_empty(): return
	trainer.value = preset.skill_tree.level
	xp.max_value = preload("res://scripts/level_progression.gd").requirement(int(trainer.value)) - 1
	xp.value = preset.campaign.progression.trainer_xp
	var members: Array = preset.campaign.team.members
	count.value = members.size()
	for i in range(members.size()):
		var member: Dictionary = members[i]
		species_controls[i].selected = Preset.species().find(member.species_id)
		levels[i].value = preset.campaign.progression.units[member.instance_id].level
		if member.instance_id == preset.campaign.team.active_id: active.value = i + 1
	var region_id: String = preset.campaign.route.selected
	region.selected = 0 if region_id == "jade" else 1
	point.value = Route.completions(preset.campaign.route,region_id).size() + 1
	stamina.value = preset.campaign.exploration.value

func update_summary():
	if not is_instance_valid(summary): return
	xp.max_value = preload("res://scripts/level_progression.gd").requirement(int(trainer.value)) - 1
	active.max_value = count.value
	for i in range(3):
		species_controls[i].disabled = i >= int(count.value)
		levels[i].editable = i < int(count.value)
	summary.text = "Configuración QA: Ezel Nv.%d · XP %d · %d Karmany · %s, etapa %d · stamina %d. Aplicar reemplaza solo la sesión QA." % [trainer.value, xp.value, count.value, region.get_item_text(region.selected), point.value, stamina.value]
func candidate() -> Dictionary:
	var members: Array = []
	for i in range(int(count.value)):
		members.append({"species":species_controls[i].get_item_text(species_controls[i].selected),"level":int(levels[i].value)})
	var result := Preset.preset(int(trainer.value), int(xp.value), members, int(active.value)-1, "jade" if region.selected == 0 else "veil", int(point.value), int(stamina.value))
	if not result.is_empty(): result.settings = App.profile.settings.duplicate(true)
	return result
func apply(start: bool):
	var next := candidate()
	if next.is_empty():
		message.text = "Configuración inválida. Zephyr solo puede aparecer una vez; usa compañeros distintos o duplicados de otras especies."
		return
	if not App.apply_qa(next):
		message.text = App.notice
		return
	message.text = "Configuración aplicada solo al laboratorio."
	applied.emit()
	if start: launch.emit(Route.points(next.campaign.route.selected)[int(point.value)-1].id)
func confirm_reset():
	var confirm := ConfirmationDialog.new(); confirm.dialog_text = "¿Restablecer solo el laboratorio QA? Tu partida normal no cambia."
	add_child(confirm)
	confirm.confirmed.connect(func():
		var fresh := Preset.preset(1,0,[{"species":"zephyr","level":1}],0,"jade",1,100)
		if App.apply_qa(fresh):
			trainer.value = 1; xp.value = 0; count.value = 1; active.value = 1
			region.selected = 0; point.value = 1; stamina.value = 100
			for i in range(3):
				species_controls[i].selected = i; levels[i].value = 1
			update_summary()
			message.text = "QA restablecido."
		else: message.text = App.notice
		confirm.queue_free())
	confirm.canceled.connect(confirm.queue_free); confirm.popup_centered(Vector2i(600,240))
