extends VBoxContainer
# Inline, no modal window, no focus grab, no animations and no gameplay actions.
const Session = preload("res://scripts/first_session.gd")
var entries: Array = []
var app: Node
var host: Node
var card: PanelContainer
var copy: Label
var index := -1
var help_button: Button
var automatic_pending := true
var save_warning: Label
func setup(owner_node: Node, context: String, point_id: String = "") -> void:
	host = owner_node
	app = get_node("/root/App")
	entries = Session.topics(app.profile, context, point_id)
	name = "ContextHelp"
	add_to_group("context_help")
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if entries.is_empty(): hide(); return
	help_button = button("Ayuda", open_help)
	help_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	add_child(help_button)
	save_warning = Label.new()
	save_warning.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	save_warning.add_theme_font_size_override("font_size", 24 if app.profile.settings.large_text else 20)
	save_warning.add_theme_color_override("font_color", Color("ffd0a0"))
	save_warning.hide()
	add_child(save_warning)
	card = PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color("163d3c")
	style.border_color = Color("8ed6b5")
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.set_content_margin_all(8)
	card.add_theme_stylebox_override("panel", style)
	add_child(card)
	var row := HBoxContainer.new()
	card.add_child(row)
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.custom_minimum_size.y = 76 if app.profile.settings.large_text else 60
	row.add_child(scroll)
	copy = Label.new()
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	copy.add_theme_font_size_override("font_size", 24 if app.profile.settings.large_text else 20)
	scroll.add_child(copy)
	var actions := HBoxContainer.new()
	row.add_child(actions)
	actions.add_child(button("Cerrar ayuda", dismiss))
	actions.add_child(button("Otra explicación", next_help))
	card.hide()
	_show_automatic.call_deferred()
func button(text: String, callback: Callable) -> Button:
	var node := Button.new()
	node.text = text
	node.custom_minimum_size.y = 48
	node.add_theme_font_size_override("font_size", 20 if app.profile.settings.large_text else 18)
	node.pressed.connect(callback)
	return node
func busy() -> bool:
	var aftermath: Variant = host.get("aftermath_screen")
	if aftermath != null and aftermath.stage in ["victory", "experience"] and aftermath.elapsed < (0.0 if aftermath.reduced else 4.0): return true
	return app.application_paused or host.get("combat_busy") == true or host.get("binding_busy") == true or preload("res://scripts/encounter_router.gd").pending(app.profile.campaign.encounter) or not app.pending_transition.is_empty()
func _process(_delta: float) -> void:
	if card == null: return
	# Hide, retaining its text, while attacks/XP/binding are moving.
	var blocked := busy()
	help_button.disabled = blocked
	card.visible = index >= 0 and not blocked
	if automatic_pending and not blocked and is_visible_in_tree(): _show_automatic()
func _show_automatic() -> void:
	if not automatic_pending or app.load_failed or busy() or not is_visible_in_tree(): return
	automatic_pending = false
	for i in range(entries.size()):
		if Session.automatic(app.profile, entries[i].id):
			present(i)
			return
func present(i: int) -> void:
	if busy() or entries.is_empty(): return
	for other in get_tree().get_nodes_in_group("context_help"):
		if other != self: other.close_card()
	index = i
	copy.text = entries[i].text
	card.show()
func open_help() -> void:
	automatic_pending = false
	present(0)
func next_help() -> void:
	if busy(): return
	_remember_current()
	automatic_pending = false
	present((index + 1) % entries.size())
func close_card() -> void:
	automatic_pending = false
	index = -1
	if card != null: card.hide()
func _remember_current() -> void:
	if index < 0 or not Session.automatic(app.profile, entries[index].id): return
	if app.dismiss_first_session(entries[index].id):
		save_warning.hide()
	else:
		# Never claim the acknowledgement was saved; closing remains independent.
		# App keeps the original profile on failure, so this topic may appear again.
		save_warning.text = app.notice
		save_warning.show()
func dismiss() -> void:
	if index < 0: return
	_remember_current()
	close_card()
func handle_back() -> bool:
	if index < 0 or card == null or not card.is_visible_in_tree(): return false
	dismiss()
	return true
