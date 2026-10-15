extends AcceptDialog
# Read-only presentation of the atomic victory receipt. No progression writes here.
const Progress = preload("res://scripts/level_progression.gd")
const Catalog = preload("res://scripts/combat_catalog.gd")
const Stage = preload("res://scripts/trial_stage.gd")
const Motion = preload("res://scripts/motion_preferences.gd")
const Audio = preload("res://scripts/effect_audio.gd")
const DURATION := 2.4
var receipt: Dictionary = {}
var cards: Array = []
var elapsed := 0.0
var duration := DURATION
var reduced := false
var audio: Node
var level_cue_played := false

# Continuous XP sampling preserves a full bar briefly at each level boundary.
static func frame(row: Dictionary, fraction: float) -> Dictionary:
	var before: Dictionary = row.before
	var after: Dictionary = row.after
	var t := clampf(fraction, 0.0, 1.0)
	var level := int(before.level)
	var xp := float(before.xp)
	var gained := int(row.gained)
	if t >= 1.0:
		return {"level": int(after.level), "xp": float(after.xp), "maximum": Progress.requirement(int(after.level)), "full": bool(row.capped), "done": true}
	if int(after.level) - level > 1:
		var hold := maxf(1.0, float(gained) * 0.12)
		var clock := t * (float(gained) + hold * (int(after.level) - level))
		while level < int(after.level):
			var needed := float(Progress.requirement(level)) - xp
			if clock <= needed: return {"level":level,"xp":xp+clock,"maximum":Progress.requirement(level),"full":false,"done":false}
			clock -= needed
			if clock <= hold: return {"level":level,"xp":float(Progress.requirement(level)),"maximum":Progress.requirement(level),"full":false,"done":false}
			clock -= hold
			level += 1
			xp = 0.0
		return {"level":level,"xp":minf(clock,float(after.xp)),"maximum":Progress.requirement(level),"full":bool(row.capped),"done":false}
	# Allocate visible time to filling and a pause before the next level begins.
	var crossing := int(after.level) > level
	var fill_end := 0.68 if crossing else 1.0
	var value := float(gained) * minf(t / fill_end, 1.0)
	var threshold := Progress.requirement(level)
	if crossing:
		var needed := threshold - xp
		if value >= needed and t < 0.80:
			return {"level": level, "xp": float(threshold), "maximum": threshold, "full": false, "done": false}
		if t >= 0.80:
			level = int(after.level)
			xp = float(after.xp) * clampf((t - 0.80) / 0.20, 0.0, 1.0)
			return {"level": level, "xp": xp, "maximum": Progress.requirement(level), "full": bool(row.capped), "done": false}
	return {"level": level, "xp": xp + value, "maximum": threshold, "full": bool(row.capped) and not crossing, "done": false}

static func stat_changes(row: Dictionary, presented_level: int = -1) -> String:
	if row.id == "trainer" or int(row.after.level) <= int(row.before.level): return ""
	var before := Catalog.stats_at_level(row.species_id, int(row.before.level))
	var after := Catalog.stats_at_level(row.species_id, int(row.after.level) if presented_level < 0 else presented_level)
	var lines: Array[String] = []
	for entry in [["life", "Vida"], ["attack", "Ataque"], ["defense", "Defensa"]]:
		lines.append("%s  %d → %d  (+%d)" % [entry[1], before[entry[0]], after[entry[0]], after[entry[0]] - before[entry[0]]])
	lines.append("Velocidad  %d → %d" % [before.speed, after.speed])
	return "\n".join(lines)

func label_for(text: String, font_size: int = 22) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var app := get_node_or_null("/root/App")
	label.add_theme_font_size_override("font_size", font_size + (4 if app != null and app.profile.settings.get("large_text", false) else 0))
	return label

func _ready() -> void:
	name = "ExperienceSummary"
	add_to_group("experience_summary")
	title = "EXPERIENCIA ADQUIRIDA"
	ok_button_text = "Continuar"
	exclusive = true
	get_ok_button().custom_minimum_size.y = 58
	confirmed.connect(_finish)
	canceled.connect(_finish)
	reduced = Motion.reduced(self)
	audio = Audio.new()
	add_child(audio)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 14)
	scroll.add_child(content)
	content.add_child(label_for("Victoria · Valle Jade", 28))
	content.add_child(label_for("Experiencia del equipo principal. Límite regional: nivel 10.", 20))
	for row in receipt.get("rows", []):
		# Old receipts remain valid saves; they have no recoverable animation origin.
		if not row.has("before") or not row.has("after"): continue
		duration = maxf(duration, minf(5.0, DURATION + 0.45 * maxi(0,int(row.after.level)-int(row.before.level)-1)))
		var panel := PanelContainer.new()
		var style := StyleBoxFlat.new()
		style.bg_color = Color("183136")
		style.border_color = Color("567d76")
		style.set_border_width_all(1)
		style.set_corner_radius_all(12)
		style.content_margin_left = 16
		style.content_margin_right = 16
		style.content_margin_top = 12
		style.content_margin_bottom = 12
		panel.add_theme_stylebox_override("panel", style)
		content.add_child(panel)
		var body := VBoxContainer.new()
		body.add_theme_constant_override("separation", 6)
		panel.add_child(body)
		var header := HBoxContainer.new()
		body.add_child(header)
		if row.id != "trainer":
			var portrait := TextureRect.new()
			portrait.texture = Stage.texture(row.species_id)
			portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			portrait.custom_minimum_size = Vector2(64, 64)
			header.add_child(portrait)
		var title_label := label_for("Entrenador" if row.id == "trainer" else Catalog.species_name(row.species_id), 26)
		title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		header.add_child(title_label)
		var gain_label := label_for("+%d XP" % int(row.gained), 26)
		gain_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		header.add_child(gain_label)
		var status := label_for("")
		body.add_child(status)
		var bar := ProgressBar.new()
		bar.custom_minimum_size.y = 24
		bar.show_percentage = false
		var fill := StyleBoxFlat.new()
		fill.bg_color = Color("72dbc0")
		fill.set_corner_radius_all(8)
		bar.add_theme_stylebox_override("fill", fill)
		body.add_child(bar)
		var stats := label_for("", 22)
		stats.add_theme_color_override("font_color", Color("b0f3cf"))
		body.add_child(stats)
		cards.append({"row": row.duplicate(true), "status": status, "bar": bar, "stats": stats, "announced": false})
	_update_cards(1.0 if reduced else 0.0)
	set_process(false)

func present() -> void:
	var available: Vector2 = get_parent().get_viewport().get_visible_rect().size
	popup_centered(Vector2i(mini(760, int(available.x) - 40), mini(590, int(available.y) - 70)))
	get_ok_button().grab_focus()
	set_process(not reduced)

func _process(delta: float) -> void:
	if not visible: return
	var app := get_node_or_null("/root/App")
	if app != null and app.application_paused: return
	elapsed = minf(duration, elapsed + delta)
	_update_cards(elapsed / duration)
	if elapsed >= duration: set_process(false)

func _update_cards(fraction: float) -> void:
	for card in cards:
		var row: Dictionary = card.row
		var sample := frame(row, fraction)
		card.bar.max_value = sample.maximum
		card.bar.value = sample.maximum if sample.full else sample.xp
		var up := int(sample.level) > int(row.before.level)
		card.status.text = "Nv. %d · %s%s" % [sample.level, "Límite regional alcanzado" if sample.full else "%d / %d XP" % [int(sample.xp), sample.maximum], " · ¡Subió de nivel!" if up else ""]
		card.stats.text = stat_changes(row, int(sample.level)) if up else ""
		if up and not card.announced:
			card.announced = true
			if not reduced and not level_cue_played:
				level_cue_played = true
				audio.play_cue("item")

func _finish() -> void:
	set_process(false)
	audio.stop()
	hide()
	queue_free()
